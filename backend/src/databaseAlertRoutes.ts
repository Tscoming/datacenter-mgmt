import crypto from 'node:crypto';
import type { Request, Response } from 'express';
import { getDatabaseSchema, queryDatabase, quoteIdentifier } from './db';
import { logRequestStep } from './requestLogger';

const toNumber = (value: unknown, fallback = 0) => {
  if (value === null || value === undefined) return fallback;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
};

const toPositiveInt = (value: unknown, fallback: number) => {
  const parsed = Math.floor(toNumber(value, fallback));
  return parsed > 0 ? parsed : fallback;
};

const firstParam = (value: string | string[] | undefined) =>
  Array.isArray(value) ? value[0] : value || '';

const optionalString = (value: unknown) => {
  if (value === undefined || value === null) return null;
  const text = String(value).trim();
  return text ? text : null;
};

const isoExpr = (column: string) =>
  `to_char(${column} at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')`;

const logDataCount = (req: Request, label: string, data: unknown) => {
  const count = Array.isArray(data) ? data.length : data ? 1 : 0;
  logRequestStep(req, 'db:data', `${label} count=${count}`);
};

const handleError = (res: Response, error: unknown) => {
  res.status(500).json({
    success: false,
    errorMessage: error instanceof Error ? error.message : 'Database alert route failed',
  });
};

const mapAlert = (row: any) => ({
  id: row.id,
  level: row.level,
  type: row.alert_type,
  source: row.source,
  ruleId: row.rule_id || undefined,
  ruleName: row.rule_name || undefined,
  deviceId: row.device_id || undefined,
  deviceName: row.device_name || undefined,
  cabinetId: row.cabinet_id || undefined,
  cabinetName: row.cabinet_name || undefined,
  datacenterId: row.datacenter_id || undefined,
  datacenterName: row.datacenter_name || undefined,
  message: row.message,
  value: row.value_num === null || row.value_num === undefined ? undefined : toNumber(row.value_num),
  threshold: row.threshold_num === null || row.threshold_num === undefined ? undefined : toNumber(row.threshold_num),
  createdAt: row.created_at,
  acknowledged: Boolean(row.acknowledged),
  acknowledgedAt: row.acknowledged_at || undefined,
  acknowledgedBy: row.acknowledged_by || undefined,
  resolvedAt: row.resolved_at || undefined,
  resolvedBy: row.resolved_by || undefined,
  notes: row.notes || undefined,
});

const alertSelectSql = (schemaName: string, whereClause = '') => `
  select
    ae.id,
    ae.level,
    ae.alert_type,
    ae.source,
    ae.rule_id,
    ar.name as rule_name,
    ae.device_id,
    d.name as device_name,
    ae.cabinet_id,
    c.name as cabinet_name,
    ae.datacenter_id,
    dc.name as datacenter_name,
    ae.message,
    ae.value_num,
    ae.threshold_num,
    ae.acknowledged,
    ${isoExpr('ae.acknowledged_at')} as acknowledged_at,
    ae.acknowledged_by,
    ${isoExpr('ae.resolved_at')} as resolved_at,
    ae.resolved_by,
    ae.notes,
    ${isoExpr('ae.created_at')} as created_at
  from ${schemaName}.alert_event ae
  left join ${schemaName}.alert_rule ar on ar.id = ae.rule_id
  left join ${schemaName}.device d on d.id = ae.device_id
  left join ${schemaName}.cabinet c on c.id = ae.cabinet_id
  left join ${schemaName}.datacenter dc on dc.id = ae.datacenter_id
  ${whereClause}
`;

const getAlerts = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const current = toPositiveInt(req.query.current, 1);
  const pageSize = toPositiveInt(req.query.pageSize, 10);
  const offset = (current - 1) * pageSize;
  const params: unknown[] = [];
  const filters: string[] = [];

  if (req.query.level) {
    params.push(String(req.query.level));
    filters.push(`ae.level = $${params.length}`);
  }
  if (req.query.acknowledged !== undefined) {
    params.push(String(req.query.acknowledged) === 'true');
    filters.push(`ae.acknowledged = $${params.length}`);
  }
  if (req.query.type) {
    params.push(String(req.query.type));
    filters.push(`ae.alert_type = $${params.length}`);
  }
  if (req.query.deviceId) {
    params.push(String(req.query.deviceId));
    filters.push(`ae.device_id = $${params.length}`);
  }
  if (req.query.cabinetId) {
    params.push(String(req.query.cabinetId));
    filters.push(`ae.cabinet_id = $${params.length}`);
  }
  if (req.query.datacenterId) {
    params.push(String(req.query.datacenterId));
    filters.push(`ae.datacenter_id = $${params.length}`);
  }
  if (req.query.startTime) {
    params.push(String(req.query.startTime));
    filters.push(`ae.created_at >= $${params.length}::timestamptz`);
  }
  if (req.query.endTime) {
    params.push(String(req.query.endTime));
    filters.push(`ae.created_at <= $${params.length}::timestamptz`);
  }

  const whereClause = filters.length ? `where ${filters.join(' and ')}` : '';
  params.push(pageSize, offset);
  const result = await queryDatabase<any>(
    req,
    'alert.list',
    `
      with filtered as (
        ${alertSelectSql(schemaName, whereClause)}
      ),
      total_count as (
        select count(*)::int as total from filtered
      )
      select filtered.*, (select total from total_count) as total
      from filtered
      order by created_at desc, id
      limit $${params.length - 1} offset $${params.length}
    `,
    params,
  );

  return {
    data: result.rows.map(mapAlert),
    total: toNumber(result.rows[0]?.total),
    current,
    pageSize,
  };
};

const getAlertStats = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'alert.stats',
    `
      select
        count(*)::int as total,
        count(*) filter (where level = 'critical')::int as critical,
        count(*) filter (where level = 'error')::int as error,
        count(*) filter (where level = 'warning')::int as warning,
        count(*) filter (where level = 'info')::int as info,
        count(*) filter (where acknowledged = false)::int as unacknowledged,
        count(*) filter (where created_at::date = current_date)::int as today_new,
        avg(extract(epoch from (resolved_at - created_at)) / 60.0) filter (where resolved_at is not null) as avg_resolve_time
      from ${schemaName}.alert_event
    `,
  );
  const row = result.rows[0] || {};
  return {
    total: toNumber(row.total),
    critical: toNumber(row.critical),
    error: toNumber(row.error),
    warning: toNumber(row.warning),
    info: toNumber(row.info),
    unacknowledged: toNumber(row.unacknowledged),
    todayNew: toNumber(row.today_new),
    avgResolveTime: Math.round(toNumber(row.avg_resolve_time)),
  };
};

const acknowledgeAlerts = async (req: Request, schema: string, ids: string[], notes?: string) => {
  const schemaName = quoteIdentifier(schema);
  if (!ids.length) return 0;
  const result = await queryDatabase<{ id: string }>(
    req,
    'alert.acknowledge',
    `
      update ${schemaName}.alert_event
      set
        acknowledged = true,
        acknowledged_at = coalesce(acknowledged_at, now()),
        acknowledged_by = coalesce(acknowledged_by, '当前用户'),
        notes = coalesce($2, notes)
      where id = any($1::text[])
      returning id
    `,
    [ids, optionalString(notes)],
  );
  return result.rows.length;
};

const resolveAlerts = async (req: Request, schema: string, ids: string[], notes?: string) => {
  const schemaName = quoteIdentifier(schema);
  if (!ids.length) return 0;
  const result = await queryDatabase<{ id: string }>(
    req,
    'alert.resolve',
    `
      update ${schemaName}.alert_event
      set
        acknowledged = true,
        acknowledged_at = coalesce(acknowledged_at, now()),
        acknowledged_by = coalesce(acknowledged_by, '当前用户'),
        resolved_at = coalesce(resolved_at, now()),
        resolved_by = coalesce(resolved_by, '当前用户'),
        notes = coalesce($2, notes)
      where id = any($1::text[])
      returning id
    `,
    [ids, optionalString(notes)],
  );
  return result.rows.length;
};

const mapRule = (row: any) => ({
  id: row.id,
  name: row.name,
  type: row.rule_type,
  enabled: Boolean(row.enabled),
  condition: row.condition_json || {},
  severity: row.severity,
  notification: row.notification_json || {},
  scope: row.scope_json || undefined,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const getAlertRules = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'alert_rule.list',
    `
      select
        id,
        name,
        rule_type,
        enabled,
        condition_json,
        severity,
        notification_json,
        scope_json,
        ${isoExpr('created_at')} as created_at,
        ${isoExpr('updated_at')} as updated_at
      from ${schemaName}.alert_rule
      order by created_at desc, id
    `,
  );
  return result.rows.map(mapRule);
};

const getAlertRule = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'alert_rule.detail',
    `
      select
        id,
        name,
        rule_type,
        enabled,
        condition_json,
        severity,
        notification_json,
        scope_json,
        ${isoExpr('created_at')} as created_at,
        ${isoExpr('updated_at')} as updated_at
      from ${schemaName}.alert_rule
      where id = $1
      limit 1
    `,
    [id],
  );
  return result.rows[0] ? mapRule(result.rows[0]) : null;
};

const createAlertRule = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const id = `rule-${crypto.randomBytes(4).toString('hex')}`;
  const result = await queryDatabase<{ id: string }>(
    req,
    'alert_rule.create',
    `
      insert into ${schemaName}.alert_rule (
        id, name, rule_type, enabled, condition_json, severity, notification_json, scope_json, source_system, created_at, updated_at
      )
      values ($1, $2, $3, $4, $5::jsonb, $6, $7::jsonb, $8::jsonb, 'database', now(), now())
      returning id
    `,
    [
      id,
      String(body.name || '').trim(),
      String(body.type || 'temperature'),
      body.enabled ?? true,
      JSON.stringify(body.condition || {}),
      String(body.severity || 'warning'),
      JSON.stringify(body.notification || {}),
      body.scope === undefined ? null : JSON.stringify(body.scope || {}),
    ],
  );
  return getAlertRule(req, schema, result.rows[0].id);
};

const updateAlertRule = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const result = await queryDatabase<{ id: string }>(
    req,
    'alert_rule.update',
    `
      update ${schemaName}.alert_rule
      set
        name = coalesce($2, name),
        rule_type = coalesce($3, rule_type),
        enabled = coalesce($4, enabled),
        condition_json = coalesce($5::jsonb, condition_json),
        severity = coalesce($6, severity),
        notification_json = coalesce($7::jsonb, notification_json),
        scope_json = coalesce($8::jsonb, scope_json),
        updated_at = now()
      where id = $1
      returning id
    `,
    [
      id,
      body.name === undefined ? null : String(body.name).trim(),
      body.type === undefined ? null : String(body.type),
      body.enabled === undefined ? null : Boolean(body.enabled),
      body.condition === undefined ? null : JSON.stringify(body.condition || {}),
      body.severity === undefined ? null : String(body.severity),
      body.notification === undefined ? null : JSON.stringify(body.notification || {}),
      body.scope === undefined ? null : JSON.stringify(body.scope || {}),
    ],
  );
  return result.rows[0] ? getAlertRule(req, schema, result.rows[0].id) : null;
};

const deleteAlertRule = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{ id: string }>(
    req,
    'alert_rule.delete',
    `delete from ${schemaName}.alert_rule where id = $1 returning id`,
    [id],
  );
  return result.rows.length > 0;
};

const toggleAlertRule = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{ id: string }>(
    req,
    'alert_rule.toggle',
    `
      update ${schemaName}.alert_rule
      set enabled = not enabled, updated_at = now()
      where id = $1
      returning id
    `,
    [id],
  );
  return result.rows[0] ? getAlertRule(req, schema, result.rows[0].id) : null;
};

const getAlertingDevices = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'alert.alerting_devices',
    `
      select
        coalesce(array_agg(distinct device_id) filter (where device_id is not null), '{}') as device_ids,
        coalesce(array_agg(distinct cabinet_id) filter (where cabinet_id is not null and device_id is null), '{}') as cabinet_ids
      from ${schemaName}.alert_event
      where acknowledged = false and resolved_at is null
    `,
  );
  return {
    deviceIds: result.rows[0]?.device_ids || [],
    cabinetIds: result.rows[0]?.cabinet_ids || [],
  };
};

const withSchema = async <T>(req: Request, res: Response, label: string, run: (schema: string) => Promise<T>) => {
  try {
    const schema = getDatabaseSchema();
    logRequestStep(req, 'db:schema', schema);
    const data = await run(schema);
    logDataCount(req, label, data);
    res.json({ success: true, data });
  } catch (error) {
    handleError(res, error);
  }
};

export default {
  'GET /api/idc/alerts': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await getAlerts(req, schema);
      logDataCount(req, 'alert.list', result.data);
      res.json({ success: true, data: result.data, total: result.total, current: result.current, pageSize: result.pageSize });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/alerts/stats': (req: Request, res: Response) =>
    withSchema(req, res, 'alert.stats', (schema) => getAlertStats(req, schema)),

  'POST /api/idc/alerts/:id/acknowledge': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const count = await acknowledgeAlerts(req, schema, [firstParam(req.params.id)], req.body?.notes);
      logRequestStep(req, 'db:data', `alert.acknowledge count=${count}`);
      res.json({ success: true, message: `告警 ${firstParam(req.params.id)} 已确认` });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/alerts/:id/resolve': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const count = await resolveAlerts(req, schema, [firstParam(req.params.id)], req.body?.notes);
      logRequestStep(req, 'db:data', `alert.resolve count=${count}`);
      res.json({ success: true, message: `告警 ${firstParam(req.params.id)} 已解决` });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/alerts/batch-acknowledge': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const ids = Array.isArray(req.body?.ids) ? req.body.ids.map(String) : [];
      const count = await acknowledgeAlerts(req, schema, ids);
      logRequestStep(req, 'db:data', `alert.batch_acknowledge count=${count}`);
      res.json({ success: true, message: `已批量确认 ${count} 条告警` });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/alerts/batch-resolve': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const ids = Array.isArray(req.body?.ids) ? req.body.ids.map(String) : [];
      const count = await resolveAlerts(req, schema, ids);
      logRequestStep(req, 'db:data', `alert.batch_resolve count=${count}`);
      res.json({ success: true, message: `已批量解决 ${count} 条告警` });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/alert-rules': (req: Request, res: Response) =>
    withSchema(req, res, 'alert_rule.list', (schema) => getAlertRules(req, schema)),

  'POST /api/idc/alert-rules': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await createAlertRule(req, schema);
      logDataCount(req, 'alert_rule.create', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/idc/alert-rules/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await updateAlertRule(req, schema, firstParam(req.params.id));
      logDataCount(req, 'alert_rule.update', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '规则不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/idc/alert-rules/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const deleted = await deleteAlertRule(req, schema, firstParam(req.params.id));
      logRequestStep(req, 'db:data', `alert_rule.delete count=${deleted ? 1 : 0}`);
      if (!deleted) {
        res.status(404).json({ success: false, errorMessage: '规则不存在' });
        return;
      }
      res.json({ success: true, message: '规则已删除' });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/alert-rules/:id/toggle': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await toggleAlertRule(req, schema, firstParam(req.params.id));
      logDataCount(req, 'alert_rule.toggle', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '规则不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/alerts/alerting-devices': (req: Request, res: Response) =>
    withSchema(req, res, 'alert.alerting_devices', (schema) => getAlertingDevices(req, schema)),
};
