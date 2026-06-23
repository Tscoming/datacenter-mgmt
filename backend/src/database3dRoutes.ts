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

const logDataCount = (req: Request, label: string, data: unknown) => {
  const count = Array.isArray(data) ? data.length : data ? 1 : 0;
  logRequestStep(req, 'db:data', `${label} count=${count}`);
};

const isoExpr = (column: string) =>
  `to_char(${column} at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')`;

const dateExpr = (column: string) => `to_char(${column}, 'YYYY-MM-DD')`;

const handleError = (res: Response, error: unknown) => {
  res.status(500).json({
    success: false,
    errorMessage: error instanceof Error ? error.message : 'Database 3D route failed',
  });
};

const mapDatacenter = (row: any) => ({
  id: row.id,
  name: row.name,
  code: row.code,
  address: row.address,
  area: toNumber(row.area_sqm),
  totalCabinets: toNumber(row.total_cabinets),
  usedCabinets: toNumber(row.used_cabinets),
  status: row.lifecycle_status,
  description: row.description || undefined,
  contact: row.contact || undefined,
  phone: row.phone || undefined,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const datacenterSelectSql = (schemaName: string, whereClause = '') => `
  with cabinet_stats as (
    select
      c.datacenter_id,
      count(*)::int as total_cabinets,
      count(distinct ri.cabinet_id)::int as used_cabinets
    from ${schemaName}.cabinet c
    left join ${schemaName}.rack_installation ri on ri.cabinet_id = c.id and ri.valid_to is null
    group by c.datacenter_id
  )
  select
    dc.id,
    dc.name,
    dc.code,
    dc.address,
    dc.area_sqm,
    coalesce(cs.total_cabinets, 0) as total_cabinets,
    coalesce(cs.used_cabinets, 0) as used_cabinets,
    dc.lifecycle_status,
    dc.description,
    dc.contact,
    dc.phone,
    ${isoExpr('dc.created_at')} as created_at,
    ${isoExpr('dc.updated_at')} as updated_at
  from ${schemaName}.datacenter dc
  left join cabinet_stats cs on cs.datacenter_id = dc.id
  ${whereClause}
`;

const getAllDatacenters = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    '3d.datacenters.all',
    `
      select id, name, code
      from ${schemaName}.datacenter
      order by id
    `,
  );

  return result.rows.map((row) => ({
    id: row.id,
    name: row.name,
    code: row.code,
  }));
};

const getDatacenters = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const current = toPositiveInt(req.query.current, 1);
  const pageSize = toPositiveInt(req.query.pageSize, 10);
  const offset = (current - 1) * pageSize;
  const params: unknown[] = [];
  const filters: string[] = [];

  if (req.query.name) {
    params.push(`%${String(req.query.name)}%`);
    filters.push(`dc.name ilike $${params.length}`);
  }
  if (req.query.status) {
    params.push(String(req.query.status));
    filters.push(`dc.lifecycle_status = $${params.length}`);
  }
  if (req.query.code) {
    params.push(`%${String(req.query.code)}%`);
    filters.push(`dc.code ilike $${params.length}`);
  }

  const whereClause = filters.length ? `where ${filters.join(' and ')}` : '';
  params.push(pageSize, offset);

  const result = await queryDatabase<any>(
    req,
    'datacenter.list',
    `
      with filtered as (
        ${datacenterSelectSql(schemaName, whereClause)}
      ),
      total_count as (
        select count(*)::int as total from filtered
      )
      select filtered.*, (select total from total_count) as total
      from filtered
      order by updated_at desc, id
      limit $${params.length - 1} offset $${params.length}
    `,
    params,
  );

  return {
    data: result.rows.map(mapDatacenter),
    total: toNumber(result.rows[0]?.total),
    current,
    pageSize,
  };
};

const getDatacenter = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'datacenter.detail',
    `${datacenterSelectSql(schemaName, 'where dc.id = $1')} limit 1`,
    [id],
  );

  return result.rows[0] ? mapDatacenter(result.rows[0]) : null;
};

const createDatacenter = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const id = `dc-${crypto.randomBytes(4).toString('hex')}`;
  const result = await queryDatabase<any>(
    req,
    'datacenter.create',
    `
      insert into ${schemaName}.datacenter (
        id,
        name,
        code,
        address,
        area_sqm,
        lifecycle_status,
        description,
        contact,
        phone,
        created_at,
        updated_at
      )
      values ($1, $2, $3, $4, $5, 'active', $6, $7, $8, now(), now())
      returning id
    `,
    [
      id,
      String(body.name || '').trim(),
      String(body.code || '').trim(),
      String(body.address || '').trim(),
      body.area === undefined || body.area === '' ? 0 : toNumber(body.area),
      body.description ? String(body.description).trim() : null,
      body.contact ? String(body.contact).trim() : null,
      body.phone ? String(body.phone).trim() : null,
    ],
  );

  return getDatacenter(req, schema, result.rows[0].id);
};

const updateDatacenter = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const result = await queryDatabase<any>(
    req,
    'datacenter.update',
    `
      update ${schemaName}.datacenter
      set
        name = coalesce($2, name),
        code = coalesce($3, code),
        address = coalesce($4, address),
        area_sqm = coalesce($5, area_sqm),
        lifecycle_status = coalesce($6, lifecycle_status),
        description = $7,
        contact = $8,
        phone = $9,
        updated_at = now()
      where id = $1
      returning id
    `,
    [
      id,
      body.name === undefined ? null : String(body.name).trim(),
      body.code === undefined ? null : String(body.code).trim(),
      body.address === undefined ? null : String(body.address).trim(),
      body.area === undefined || body.area === '' ? null : toNumber(body.area),
      body.status === undefined ? null : String(body.status),
      body.description === undefined ? null : String(body.description).trim() || null,
      body.contact === undefined ? null : String(body.contact).trim() || null,
      body.phone === undefined ? null : String(body.phone).trim() || null,
    ],
  );

  return result.rows[0] ? getDatacenter(req, schema, result.rows[0].id) : null;
};

const deleteDatacenter = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const cabinetCount = await queryDatabase<{ count: string }>(
    req,
    'datacenter.delete.check_cabinets',
    `select count(*)::int as count from ${schemaName}.cabinet where datacenter_id = $1`,
    [id],
  );

  if (toNumber(cabinetCount.rows[0]?.count) > 0) {
    return {
      deleted: false,
      errorMessage: '该数据中心存在关联机柜，不能删除。',
    };
  }

  const result = await queryDatabase<{ id: string }>(
    req,
    'datacenter.delete',
    `delete from ${schemaName}.datacenter where id = $1 returning id`,
    [id],
  );

  return {
    deleted: result.rows.length > 0,
    errorMessage: result.rows.length > 0 ? undefined : '数据中心不存在',
  };
};

const getAllDeviceTemplates = async (req: Request, schema: string, category?: string) => {
  const schemaName = quoteIdentifier(schema);
  const params = category ? [category] : [];
  const where = category ? 'where dt.category = $1' : '';
  const result = await queryDatabase<any>(
    req,
    '3d.device_templates.all',
    `
      select
        dt.id,
        dt.name,
        dt.category,
        dt.brand,
        dt.model,
        dt.u_height,
        dt.front_color,
        dt.rear_color,
        dt.model3d_url,
        dt.image_url,
        dt.is_builtin,
        dt.max_power_w,
        dt.spec_json,
        dt.description,
        ${isoExpr('dt.created_at')} as created_at,
        ${isoExpr('dt.updated_at')} as updated_at,
        coalesce(
          jsonb_agg(
            jsonb_build_object(
              'id', pgt.id,
              'name', pgt.name,
              'portType', pgt.port_type,
              'count', pgt.port_count,
              'speed', pgt.speed,
              'poe', pgt.poe
            )
            order by pgt.id
          ) filter (where pgt.id is not null),
          '[]'::jsonb
        ) as port_groups
      from ${schemaName}.device_template dt
      left join ${schemaName}.port_group_template pgt on pgt.template_id = dt.id
      ${where}
      group by dt.id
      order by dt.category, dt.brand, dt.model
    `,
    params,
  );

  return result.rows.map((row) => ({
    id: row.id,
    name: row.name,
    category: row.category,
    brand: row.brand,
    model: row.model,
    uHeight: toNumber(row.u_height),
    portGroups: row.port_groups || [],
    frontColor: row.front_color || undefined,
    rearColor: row.rear_color || undefined,
    model3dUrl: row.model3d_url || undefined,
    imageUrl: row.image_url || undefined,
    isBuiltin: Boolean(row.is_builtin),
    description: row.description || undefined,
    specs: row.spec_json || {},
    maxPower: toNumber(row.max_power_w),
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  }));
};

const getDevices = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const current = toPositiveInt(req.query.current, 1);
  const pageSize = toPositiveInt(req.query.pageSize, 20);
  const offset = (current - 1) * pageSize;
  const params = [pageSize, offset];

  const result = await queryDatabase<any>(
    req,
    '3d.devices.list',
    `
      with mounted_devices as (
        select
          d.*,
          ri.cabinet_id,
          ri.start_u,
          ri.end_u
        from ${schemaName}.device d
        left join ${schemaName}.rack_installation ri
          on ri.device_id = d.id
          and ri.asset_type = 'device'
          and ri.valid_to is null
      ),
      total_count as (
        select count(*)::int as total from mounted_devices
      )
      select
        md.id,
        md.template_id,
        md.cabinet_id,
        md.asset_code,
        md.name,
        md.serial_number,
        md.start_u,
        md.end_u,
        md.management_ip::text as management_ip,
        md.operational_status,
        ${dateExpr('md.purchase_date')} as purchase_date,
        ${dateExpr('md.warranty_expiry')} as warranty_expiry,
        md.vendor,
        md.owner,
        md.department,
        md.description,
        ${isoExpr('md.created_at')} as created_at,
        ${isoExpr('md.updated_at')} as updated_at,
        (select total from total_count) as total
      from mounted_devices md
      order by md.id
      limit $1 offset $2
    `,
    params,
  );

  const total = toNumber(result.rows[0]?.total);
  const data = result.rows.map((row) => ({
    id: row.id,
    templateId: row.template_id,
    cabinetId: row.cabinet_id || '',
    assetCode: row.asset_code,
    name: row.name,
    serialNumber: row.serial_number || undefined,
    startU: toNumber(row.start_u),
    endU: toNumber(row.end_u),
    managementIp: row.management_ip || undefined,
    status: row.operational_status,
    purchaseDate: row.purchase_date || undefined,
    warrantyExpiry: row.warranty_expiry || undefined,
    vendor: row.vendor || undefined,
    owner: row.owner || undefined,
    department: row.department || undefined,
    isMounted: Boolean(row.cabinet_id),
    description: row.description || undefined,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  }));

  return { data, total, current, pageSize };
};

const mapCabinet = (row: any) => ({
  id: row.id,
  datacenterId: row.datacenter_id,
  datacenterName: row.datacenter_name,
  name: row.name,
  code: row.code,
  row: toNumber(row.row_no),
  column: toNumber(row.column_no),
  uHeight: toNumber(row.u_height),
  usedU: toNumber(row.used_u),
  maxPower: toNumber(row.max_power_w),
  currentPower: toNumber(row.current_power),
  status: row.health_status,
  description: row.description || undefined,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const cabinetSelectSql = (schemaName: string, whereClause: string) => `
  with u_usage as (
    select cabinet_id, coalesce(sum(end_u - start_u + 1), 0)::int as used_u
    from ${schemaName}.rack_installation
    where valid_to is null
    group by cabinet_id
  ),
  power_usage as (
    select cabinet_id, coalesce(sum(current_load_w), 0) as current_power
    from ${schemaName}.pdu
    group by cabinet_id
  )
  select
    c.id,
    c.datacenter_id,
    dc.name as datacenter_name,
    c.name,
    c.code,
    c.row_no,
    c.column_no,
    c.u_height,
    coalesce(uu.used_u, 0) as used_u,
    c.max_power_w,
    coalesce(pu.current_power, 0) as current_power,
    c.health_status,
    c.description,
    ${isoExpr('c.created_at')} as created_at,
    ${isoExpr('c.updated_at')} as updated_at
  from ${schemaName}.cabinet c
  join ${schemaName}.datacenter dc on dc.id = c.datacenter_id
  left join u_usage uu on uu.cabinet_id = c.id
  left join power_usage pu on pu.cabinet_id = c.id
  ${whereClause}
`;

const getCabinetsByDatacenter = async (req: Request, schema: string, datacenterId: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    '3d.cabinets.by_datacenter',
    `
      ${cabinetSelectSql(schemaName, 'where c.datacenter_id = $1')}
      order by c.row_no, c.column_no, c.id
    `,
    [datacenterId],
  );

  return result.rows.map(mapCabinet);
};

const getCabinet = async (req: Request, schema: string, cabinetId: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'cabinet3d.cabinet',
    `${cabinetSelectSql(schemaName, 'where c.id = $1')} limit 1`,
    [cabinetId],
  );

  return result.rows[0] ? mapCabinet(result.rows[0]) : null;
};

const mapDevice = (row: any) => ({
  id: row.id,
  templateId: row.template_id,
  cabinetId: row.cabinet_id || '',
  assetCode: row.asset_code,
  name: row.name,
  serialNumber: row.serial_number || undefined,
  startU: toNumber(row.start_u),
  endU: toNumber(row.end_u),
  managementIp: row.management_ip || undefined,
  status: row.operational_status,
  purchaseDate: row.purchase_date || undefined,
  warrantyExpiry: row.warranty_expiry || undefined,
  vendor: row.vendor || undefined,
  owner: row.owner || undefined,
  department: row.department || undefined,
  isMounted: Boolean(row.cabinet_id),
  description: row.description || undefined,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const getDevicesByCabinet = async (req: Request, schema: string, cabinetId: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'cabinet3d.devices.by_cabinet',
    `
      select
        d.id,
        d.template_id,
        ri.cabinet_id,
        d.asset_code,
        d.name,
        d.serial_number,
        ri.start_u,
        ri.end_u,
        d.management_ip::text as management_ip,
        d.operational_status,
        ${dateExpr('d.purchase_date')} as purchase_date,
        ${dateExpr('d.warranty_expiry')} as warranty_expiry,
        d.vendor,
        d.owner,
        d.department,
        d.description,
        ${isoExpr('d.created_at')} as created_at,
        ${isoExpr('d.updated_at')} as updated_at
      from ${schemaName}.rack_installation ri
      join ${schemaName}.device d on d.id = ri.device_id
      where ri.asset_type = 'device'
        and ri.valid_to is null
        and ri.cabinet_id = $1
      order by ri.start_u desc, d.id
    `,
    [cabinetId],
  );

  return result.rows.map(mapDevice);
};

const getPortsByDevice = async (req: Request, schema: string, deviceId: string) => {
  const schemaName = quoteIdentifier(schema);
  const portType = req.query.portType ? String(req.query.portType) : '';
  const status = req.query.status ? String(req.query.status) : '';
  const linkStatus = req.query.linkStatus ? String(req.query.linkStatus) : '';
  const params: unknown[] = [deviceId];
  const filters = ['p.device_id = $1'];

  if (portType) {
    params.push(portType);
    filters.push(`p.port_type = $${params.length}`);
  }
  if (status) {
    params.push(status);
    filters.push(`p.admin_status = $${params.length}`);
  }
  if (linkStatus) {
    params.push(linkStatus);
    filters.push(`p.link_status = $${params.length}`);
  }

  const result = await queryDatabase<any>(
    req,
    'cabinet3d.ports.by_device',
    `
      select
        p.id,
        p.device_id,
        p.port_group_id,
        p.port_number,
        p.port_alias,
        p.port_type,
        p.speed,
        p.admin_status,
        p.link_status,
        p.vlan_config,
        p.qos_config,
        p.mac_bindings,
        p.port_security,
        p.max_mac_count,
        p.dot1x_enabled,
        p.connection_purpose,
        p.description,
        ${isoExpr('p.last_updated')} as last_updated,
        cc.id as connection_id,
        case
          when cc.source_port_id = p.id then cc.target_device_id
          when cc.target_port_id = p.id then cc.source_device_id
          else null
        end as connected_device_id,
        case
          when cc.source_port_id = p.id then cc.target_port_id
          when cc.target_port_id = p.id then cc.source_port_id
          else null
        end as connected_port_id
      from ${schemaName}.port p
      left join ${schemaName}.cable_connection cc
        on cc.source_port_id = p.id or cc.target_port_id = p.id
      where ${filters.join(' and ')}
      order by p.port_group_id, p.port_number
    `,
    params,
  );

  return result.rows.map((row, index) => ({
    id: row.id,
    deviceId: row.device_id,
    portGroupId: row.port_group_id,
    groupId: row.port_group_id,
    index,
    portNumber: row.port_number,
    portAlias: row.port_alias || undefined,
    portType: row.port_type,
    speed: row.speed,
    status: row.admin_status,
    linkStatus: row.link_status,
    vlanConfig: row.vlan_config || undefined,
    qosConfig: row.qos_config || undefined,
    macBindings: row.mac_bindings || undefined,
    portSecurity: row.port_security ?? undefined,
    maxMacCount: row.max_mac_count ?? undefined,
    dot1xEnabled: row.dot1x_enabled ?? undefined,
    connectedDeviceId: row.connected_device_id || undefined,
    connectedPortId: row.connected_port_id || undefined,
    connectionPurpose: row.connection_purpose || undefined,
    lastUpdated: row.last_updated,
    description: row.description || undefined,
  }));
};

const getConnectionsByDatacenter = async (req: Request, schema: string, datacenterId: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    '3d.connections.by_datacenter',
    `
      select
        cc.id,
        cc.cable_number,
        cc.connection_type,
        cc.cable_type,
        cc.cable_color,
        cc.cable_length_m,
        cc.source_device_id,
        cc.source_port_id,
        cc.target_device_id,
        cc.target_port_id,
        cc.status,
        cc.description,
        ${isoExpr('cc.created_at')} as created_at,
        ${isoExpr('cc.updated_at')} as updated_at
      from ${schemaName}.cable_connection cc
      left join ${schemaName}.rack_installation sri on sri.device_id = cc.source_device_id and sri.asset_type = 'device' and sri.valid_to is null
      left join ${schemaName}.rack_installation tri on tri.device_id = cc.target_device_id and tri.asset_type = 'device' and tri.valid_to is null
      left join ${schemaName}.cabinet sc on sc.id = sri.cabinet_id
      left join ${schemaName}.cabinet tc on tc.id = tri.cabinet_id
      where sc.datacenter_id = $1 or tc.datacenter_id = $1
      order by cc.id
    `,
    [datacenterId],
  );

  return result.rows.map((row) => ({
    id: row.id,
    cableNumber: row.cable_number,
    connectionType: row.connection_type,
    cableType: row.cable_type,
    cableColor: row.cable_color || undefined,
    cableLength: toNumber(row.cable_length_m),
    sourceDeviceId: row.source_device_id,
    sourcePortId: row.source_port_id,
    targetDeviceId: row.target_device_id,
    targetPortId: row.target_port_id,
    status: row.status,
    description: row.description || undefined,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  }));
};

const getDatacenterLayout = async (req: Request, schema: string, datacenterId: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{ raw_json: any }>(
    req,
    '3d.layout',
    `
      select raw_json
      from ${schemaName}.layout_snapshot
      where datacenter_id = $1
      limit 1
    `,
    [datacenterId],
  );

  return (
    result.rows[0]?.raw_json || {
      datacenterId,
      version: 1,
      canvasWidth: 60,
      canvasHeight: 40,
      pxPerMeter: 50,
      cabinets: [],
      zones: [],
      facilities: [],
      updatedAt: new Date().toISOString(),
    }
  );
};

const getSnapshotPayload = async <T>(req: Request, schema: string, snapshotType: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{ payload: T }>(
    req,
    `3d.${snapshotType}.snapshot`,
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

const getCabinetEnvironments = async (req: Request, schema: string) => {
  const snapshot = await getSnapshotPayload<any[]>(req, schema, 'cabinet_environment');
  if (Array.isArray(snapshot)) {
    return snapshot.map((item) => ({
      cabinetId: item.cabinetId,
      cabinetName: item.cabinetName,
      datacenterId: item.datacenterId,
      datacenterName: item.datacenterName,
      avgTemperature: toNumber(item.avgTemperature),
      maxTemperature: toNumber(item.maxTemperature),
      minTemperature: toNumber(item.minTemperature),
      avgHumidity: toNumber(item.avgHumidity),
      status: item.status,
    }));
  }

  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    '3d.cabinet_environment.aggregate',
    `
      select
        c.id as cabinet_id,
        regexp_replace(c.name, '机柜$', '') as cabinet_name,
        c.datacenter_id,
        dc.name as datacenter_name,
        avg(o.value_num) filter (where o.metric = 'temperature') as avg_temperature,
        max(o.value_num) filter (where o.metric = 'temperature') as max_temperature,
        min(o.value_num) filter (where o.metric = 'temperature') as min_temperature,
        avg(o.value_num) filter (where o.metric = 'humidity') as avg_humidity,
        case
          when max(o.value_num) filter (where o.metric = 'temperature') > 28 then 'critical'
          when avg(o.value_num) filter (where o.metric = 'temperature') > 26 then 'warning'
          else 'normal'
        end as status
      from ${schemaName}.cabinet c
      join ${schemaName}.datacenter dc on dc.id = c.datacenter_id
      left join ${schemaName}.observation o on o.target_type = 'cabinet' and o.target_id = c.id
      group by c.id, dc.name
      order by c.datacenter_id, c.row_no, c.column_no
    `,
  );

  return result.rows.map((row) => ({
    cabinetId: row.cabinet_id,
    cabinetName: row.cabinet_name,
    datacenterId: row.datacenter_id,
    datacenterName: row.datacenter_name,
    avgTemperature: toNumber(row.avg_temperature),
    maxTemperature: toNumber(row.max_temperature),
    minTemperature: toNumber(row.min_temperature),
    avgHumidity: toNumber(row.avg_humidity),
    status: row.status,
  }));
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
  'GET /api/idc/datacenters/all': (req: Request, res: Response) =>
    withSchema(req, res, '3d.datacenters.all', (schema) => getAllDatacenters(req, schema)),

  'GET /api/idc/datacenters': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await getDatacenters(req, schema);
      logDataCount(req, 'datacenter.list', result.data);
      res.json({
        success: true,
        data: result.data,
        total: result.total,
        current: result.current,
        pageSize: result.pageSize,
      });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/datacenters/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getDatacenter(req, schema, firstParam(req.params.id));
      logDataCount(req, 'datacenter.detail', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '数据中心不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/datacenters': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await createDatacenter(req, schema);
      logDataCount(req, 'datacenter.create', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/idc/datacenters/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await updateDatacenter(req, schema, firstParam(req.params.id));
      logDataCount(req, 'datacenter.update', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '数据中心不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/idc/datacenters/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await deleteDatacenter(req, schema, firstParam(req.params.id));
      logDataCount(req, 'datacenter.delete', result.deleted ? result : null);
      if (!result.deleted) {
        res.status(400).json({ success: false, errorMessage: result.errorMessage });
        return;
      }
      res.json({ success: true });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/device-templates/all': (req: Request, res: Response) =>
    withSchema(req, res, '3d.device_templates.all', (schema) =>
      getAllDeviceTemplates(req, schema, req.query.category ? String(req.query.category) : undefined),
    ),

  'GET /api/idc/devices': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await getDevices(req, schema);
      logDataCount(req, '3d.devices.list', result.data);
      res.json({
        success: true,
        data: result.data,
        total: result.total,
        current: result.current,
        pageSize: result.pageSize,
      });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/cabinets/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getCabinet(req, schema, firstParam(req.params.id));
      logDataCount(req, 'cabinet3d.cabinet', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '机柜不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/cabinets/by-datacenter/:datacenterId': (req: Request, res: Response) =>
    withSchema(req, res, '3d.cabinets.by_datacenter', (schema) =>
      getCabinetsByDatacenter(req, schema, firstParam(req.params.datacenterId)),
    ),

  'GET /api/idc/devices/by-cabinet/:cabinetId': (req: Request, res: Response) =>
    withSchema(req, res, 'cabinet3d.devices.by_cabinet', (schema) =>
      getDevicesByCabinet(req, schema, firstParam(req.params.cabinetId)),
    ),

  'GET /api/idc/ports/by-device/:deviceId': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getPortsByDevice(req, schema, firstParam(req.params.deviceId));
      logDataCount(req, 'cabinet3d.ports.by_device', data);
      res.json({ success: true, data, total: data.length });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/connections/by-datacenter/:datacenterId': (req: Request, res: Response) =>
    withSchema(req, res, '3d.connections.by_datacenter', (schema) =>
      getConnectionsByDatacenter(req, schema, firstParam(req.params.datacenterId)),
    ),

  'GET /api/idc/datacenters/:id/layout': (req: Request, res: Response) =>
    withSchema(req, res, '3d.layout', (schema) => getDatacenterLayout(req, schema, firstParam(req.params.id))),

  'GET /api/idc/environment/cabinets': (req: Request, res: Response) =>
    withSchema(req, res, '3d.cabinet_environment', (schema) => getCabinetEnvironments(req, schema)),
};
