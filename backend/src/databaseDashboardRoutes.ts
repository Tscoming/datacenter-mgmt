import type { Request, Response } from 'express';
import { getDatabaseSchema, queryDatabase, quoteIdentifier } from './db';
import { logRequestStep } from './requestLogger';

const toNumber = (value: unknown, fallback = 0) => {
  if (value === null || value === undefined) return fallback;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
};

const toLimit = (value: unknown, fallback: number) => {
  const parsed = Math.floor(toNumber(value, fallback));
  return parsed > 0 ? parsed : fallback;
};

const round = (value: unknown, digits: number) => {
  const factor = 10 ** digits;
  return Math.round(toNumber(value) * factor) / factor;
};

const logDataCount = (req: Request, label: string, data: unknown) => {
  const count = Array.isArray(data) ? data.length : data ? 1 : 0;
  logRequestStep(req, 'db:data', `${label} count=${count}`);
};

const getSnapshotPayload = async <T>(req: Request, schema: string, snapshotType: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{ payload: T }>(
    req,
    `dashboard.${snapshotType}.snapshot`,
    `
      select payload
      from ${schemaName}.dashboard_snapshot
      where snapshot_type = $1
      order by captured_at desc
      limit 1
    `,
    [snapshotType],
  );

  return result.rows[0]?.payload || null;
};

const normalizeAlert = (value: any) => ({
  id: String(value?.id || ''),
  level: value?.level || 'info',
  type: value?.type || value?.alert_type || '',
  deviceId: value?.deviceId || value?.device_id || undefined,
  deviceName: value?.deviceName || value?.device_name || undefined,
  message: value?.message || '',
  createdAt: value?.createdAt || value?.created_at || '',
  acknowledged: Boolean(value?.acknowledged),
  acknowledgedAt: value?.acknowledgedAt || value?.acknowledged_at || undefined,
  acknowledgedBy: value?.acknowledgedBy || value?.acknowledged_by || undefined,
});

const getDashboardStats = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'dashboard.stats.aggregate',
    `
      with cabinet_usage as (
        select
          count(distinct cabinet_id)::numeric as used_cabinets,
          coalesce(sum(end_u - start_u + 1), 0)::numeric as used_u
        from ${schemaName}.rack_installation
        where valid_to is null
      ),
      recent_alerts as (
        select coalesce(jsonb_agg(alert_json order by created_at desc), '[]'::jsonb) as alerts
        from (
          select
            ae.created_at,
            jsonb_strip_nulls(jsonb_build_object(
              'id', ae.id,
              'level', ae.level,
              'type', ae.alert_type,
              'deviceId', ae.device_id,
              'deviceName', d.name,
              'message', ae.message,
              'createdAt', to_char(ae.created_at at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
              'acknowledged', ae.acknowledged,
              'acknowledgedAt', case
                when ae.acknowledged_at is null then null
                else to_char(ae.acknowledged_at at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')
              end,
              'acknowledgedBy', ae.acknowledged_by
            )) as alert_json
          from ${schemaName}.alert_event ae
          left join ${schemaName}.device d on d.id = ae.device_id
          order by ae.created_at desc
          limit 4
        ) recent
      )
      select
        (select count(*) from ${schemaName}.datacenter)::int as datacenter_count,
        (select count(*) from ${schemaName}.cabinet)::int as cabinet_count,
        (select count(*) from ${schemaName}.device)::int as device_count,
        (select count(*) from ${schemaName}.cable_connection)::int as connection_count,
        (select count(*) from ${schemaName}.device where operational_status = 'online')::int as online_devices,
        (select count(*) from ${schemaName}.device where operational_status = 'offline')::int as offline_devices,
        (select count(*) from ${schemaName}.device where operational_status = 'warning')::int as warning_devices,
        (select count(*) from ${schemaName}.device where operational_status = 'error')::int as error_devices,
        coalesce((select used_cabinets / nullif((select count(*) from ${schemaName}.cabinet), 0) from cabinet_usage), 0) as cabinet_usage_rate,
        coalesce((select used_u / nullif((select sum(u_height) from ${schemaName}.cabinet), 0) from cabinet_usage), 0) as u_usage_rate,
        (select alerts from recent_alerts) as recent_alerts
    `,
  );

  const row = result.rows[0] || {};
  return {
    datacenterCount: toNumber(row.datacenter_count),
    cabinetCount: toNumber(row.cabinet_count),
    deviceCount: toNumber(row.device_count),
    connectionCount: toNumber(row.connection_count),
    onlineDevices: toNumber(row.online_devices),
    offlineDevices: toNumber(row.offline_devices),
    warningDevices: toNumber(row.warning_devices),
    errorDevices: toNumber(row.error_devices),
    cabinetUsageRate: round(row.cabinet_usage_rate, 2),
    uUsageRate: round(row.u_usage_rate, 2),
    recentAlerts: Array.isArray(row.recent_alerts) ? row.recent_alerts.map(normalizeAlert) : [],
  };
};

const getDeviceTrend = async (req: Request, schema: string, days: number) => {
  const snapshot = await getSnapshotPayload<any[]>(req, schema, 'device_trend');
  if (Array.isArray(snapshot) && snapshot.length > 0) {
    return snapshot.slice(-days).map((item) => ({
      date: String(item.date),
      online: toNumber(item.online),
      offline: toNumber(item.offline),
      warning: toNumber(item.warning),
      error: toNumber(item.error),
    }));
  }

  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'dashboard.device_trend.aggregate',
    `
      select
        to_char(current_date, 'YYYY-MM-DD') as date,
        count(*) filter (where operational_status = 'online')::int as online,
        count(*) filter (where operational_status = 'offline')::int as offline,
        count(*) filter (where operational_status = 'warning')::int as warning,
        count(*) filter (where operational_status = 'error')::int as error
      from ${schemaName}.device
    `,
  );

  return result.rows.map((row) => ({
    date: row.date,
    online: toNumber(row.online),
    offline: toNumber(row.offline),
    warning: toNumber(row.warning),
    error: toNumber(row.error),
  }));
};

const getCabinetUsageRank = async (req: Request, schema: string, limit: number) => {
  const snapshot = await getSnapshotPayload<any[]>(req, schema, 'cabinet_usage_rank');
  if (Array.isArray(snapshot) && snapshot.length > 0) {
    return snapshot.slice(0, limit).map((item) => ({
      cabinetId: String(item.cabinetId || ''),
      cabinetName: String(item.cabinetName || ''),
      usage: round(item.usage, 2),
    }));
  }

  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'dashboard.cabinet_usage_rank.aggregate',
    `
      select
        c.id as cabinet_id,
        regexp_replace(c.name, '机柜$', '') as cabinet_name,
        coalesce(sum(ri.end_u - ri.start_u + 1)::numeric / nullif(c.u_height, 0), 0) as usage
      from ${schemaName}.cabinet c
      left join ${schemaName}.rack_installation ri on ri.cabinet_id = c.id and ri.valid_to is null
      group by c.id, c.name, c.u_height
      order by usage desc, c.id
      limit $1
    `,
    [limit],
  );

  return result.rows.map((row) => ({
    cabinetId: row.cabinet_id,
    cabinetName: row.cabinet_name,
    usage: round(row.usage, 2),
  }));
};

const categoryMeta: Record<string, { label: string; color: string }> = {
  switch: { label: '交换机', color: '#1890ff' },
  router: { label: '路由器', color: '#13c2c2' },
  server: { label: '服务器', color: '#52c41a' },
  storage: { label: '存储', color: '#faad14' },
  firewall: { label: '防火墙', color: '#f5222d' },
  loadbalancer: { label: '负载均衡', color: '#722ed1' },
  other: { label: '其他', color: '#8c8c8c' },
};

const getDeviceCategory = async (req: Request, schema: string) => {
  const snapshot = await getSnapshotPayload<any[]>(req, schema, 'device_category');
  if (Array.isArray(snapshot) && snapshot.length > 0) {
    return snapshot.map((item) => ({
      category: String(item.category || 'other'),
      label: String(item.label || categoryMeta[String(item.category)]?.label || item.category || '其他'),
      count: toNumber(item.count),
      color: String(item.color || categoryMeta[String(item.category)]?.color || categoryMeta.other.color),
    }));
  }

  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'dashboard.device_category.aggregate',
    `
      select
        coalesce(dt.category, 'other') as category,
        count(*)::int as count
      from ${schemaName}.device d
      left join ${schemaName}.device_template dt on dt.id = d.template_id
      group by coalesce(dt.category, 'other')
      order by count desc, category
    `,
  );

  return result.rows.map((row) => {
    const category = row.category || 'other';
    return {
      category,
      label: categoryMeta[category]?.label || category,
      count: toNumber(row.count),
      color: categoryMeta[category]?.color || categoryMeta.other.color,
    };
  });
};

const getDatacenterLoad = async (req: Request, schema: string) => {
  const snapshot = await getSnapshotPayload<any[]>(req, schema, 'datacenter_load');
  if (Array.isArray(snapshot) && snapshot.length > 0) {
    return snapshot.map((item) => ({
      datacenterId: String(item.datacenterId || ''),
      name: String(item.name || ''),
      cabinetUsage: round(item.cabinetUsage, 2),
      powerUsage: round(item.powerUsage, 2),
      deviceCount: toNumber(item.deviceCount),
    }));
  }

  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'dashboard.datacenter_load.aggregate',
    `
      with cabinet_usage as (
        select
          c.datacenter_id,
          count(c.id)::numeric as cabinet_count,
          count(distinct ri.cabinet_id)::numeric as used_cabinets,
          coalesce(sum(c.max_power_w), 0)::numeric as max_power_w
        from ${schemaName}.cabinet c
        left join ${schemaName}.rack_installation ri on ri.cabinet_id = c.id and ri.valid_to is null
        group by c.datacenter_id
      ),
      device_usage as (
        select
          c.datacenter_id,
          count(distinct d.id)::int as device_count
        from ${schemaName}.device d
        join ${schemaName}.rack_installation ri
          on ri.device_id = d.id
          and ri.asset_type = 'device'
          and ri.valid_to is null
        join ${schemaName}.cabinet c on c.id = ri.cabinet_id
        group by c.datacenter_id
      ),
      power_usage as (
        select
          c.datacenter_id,
          coalesce(sum(p.current_load_w), 0)::numeric as current_power_w
        from ${schemaName}.cabinet c
        left join ${schemaName}.pdu p on p.cabinet_id = c.id
        group by c.datacenter_id
      )
      select
        dc.id as datacenter_id,
        dc.name,
        coalesce(cu.used_cabinets / nullif(cu.cabinet_count, 0), 0) as cabinet_usage,
        coalesce(pu.current_power_w / nullif(cu.max_power_w, 0), 0) as power_usage,
        coalesce(du.device_count, 0) as device_count
      from ${schemaName}.datacenter dc
      left join cabinet_usage cu on cu.datacenter_id = dc.id
      left join device_usage du on du.datacenter_id = dc.id
      left join power_usage pu on pu.datacenter_id = dc.id
      order by dc.id
    `,
  );

  return result.rows.map((row) => ({
    datacenterId: row.datacenter_id,
    name: row.name,
    cabinetUsage: round(row.cabinet_usage, 2),
    powerUsage: round(row.power_usage, 2),
    deviceCount: toNumber(row.device_count),
  }));
};

const getRecentOperations = async (req: Request, schema: string, limit: number) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'dashboard.recent_operations',
    `
      select
        id,
        operation_type as type,
        operator_name as operator,
        target,
        description,
        to_char(created_at at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"') as created_at
      from ${schemaName}.operation_record
      order by created_at desc
      limit $1
    `,
    [limit],
  );

  return result.rows.map((row) => ({
    id: row.id,
    type: row.type,
    operator: row.operator,
    target: row.target,
    description: row.description,
    createdAt: row.created_at,
  }));
};

const handleError = (res: Response, error: unknown) => {
  res.status(500).json({
    success: false,
    errorMessage: error instanceof Error ? error.message : 'Database dashboard route failed',
  });
};

export default {
  'GET /api/idc/dashboard/stats': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getDashboardStats(req, schema);
      logDataCount(req, 'dashboard.stats', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/dashboard/device-trend': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      const days = toLimit(req.query.days, 7);
      logRequestStep(req, 'db:schema', schema);
      const data = await getDeviceTrend(req, schema, days);
      logDataCount(req, 'dashboard.device_trend', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/dashboard/cabinet-usage-rank': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      const limit = toLimit(req.query.limit, 10);
      logRequestStep(req, 'db:schema', schema);
      const data = await getCabinetUsageRank(req, schema, limit);
      logDataCount(req, 'dashboard.cabinet_usage_rank', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/dashboard/device-category': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getDeviceCategory(req, schema);
      logDataCount(req, 'dashboard.device_category', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/dashboard/datacenter-load': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getDatacenterLoad(req, schema);
      logDataCount(req, 'dashboard.datacenter_load', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/dashboard/recent-operations': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      const limit = toLimit(req.query.limit, 10);
      logRequestStep(req, 'db:schema', schema);
      const data = await getRecentOperations(req, schema, limit);
      logDataCount(req, 'dashboard.recent_operations', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/dashboard/alerts/:id/acknowledge': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      const schemaName = quoteIdentifier(schema);
      const { id } = req.params;
      const { notes } = req.body || {};
      logRequestStep(req, 'db:schema', schema);
      const result = await queryDatabase(
        req,
        'dashboard.alert_acknowledge',
        `
          update ${schemaName}.alert_event
          set
            acknowledged = true,
            acknowledged_at = coalesce(acknowledged_at, now()),
            acknowledged_by = coalesce(acknowledged_by, '当前用户'),
            notes = coalesce($2, notes)
          where id = $1
          returning id
        `,
        [id, notes || null],
      );
      logDataCount(req, 'dashboard.alert_acknowledge', result.rows);
      res.json({ success: true, message: `告警 ${id} 已确认` });
    } catch (error) {
      handleError(res, error);
    }
  },
};
