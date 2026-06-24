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

const optionalString = (value: unknown) => {
  if (value === undefined || value === null) return null;
  const text = String(value).trim();
  return text ? text : null;
};

const optionalDate = (value: unknown) => optionalString(value);

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

const getDeviceTemplates = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const current = toPositiveInt(req.query.current, 1);
  const pageSize = toPositiveInt(req.query.pageSize, 10);
  const offset = (current - 1) * pageSize;
  const params: unknown[] = [];
  const filters: string[] = [];

  if (req.query.category) {
    params.push(String(req.query.category));
    filters.push(`dt.category = $${params.length}`);
  }
  if (req.query.brand) {
    params.push(`%${String(req.query.brand)}%`);
    filters.push(`dt.brand ilike $${params.length}`);
  }
  if (req.query.name) {
    params.push(`%${String(req.query.name)}%`);
    filters.push(`(dt.name ilike $${params.length} or dt.model ilike $${params.length})`);
  }
  if (req.query.isBuiltin !== undefined) {
    params.push(String(req.query.isBuiltin) === 'true');
    filters.push(`dt.is_builtin = $${params.length}`);
  }

  const where = filters.length ? `where ${filters.join(' and ')}` : '';
  params.push(pageSize, offset);

  const result = await queryDatabase<any>(
    req,
    'device_template.list',
    `
      with filtered as (
        select dt.*
        from ${schemaName}.device_template dt
        ${where}
      ),
      total_count as (
        select count(*)::int as total from filtered
      )
      select
        f.id,
        f.name,
        f.category,
        f.brand,
        f.model,
        f.u_height,
        f.front_color,
        f.rear_color,
        f.model3d_url,
        f.image_url,
        f.is_builtin,
        f.max_power_w,
        f.spec_json,
        f.description,
        ${isoExpr('f.created_at')} as created_at,
        ${isoExpr('f.updated_at')} as updated_at,
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
        ) as port_groups,
        (select total from total_count) as total
      from filtered f
      left join ${schemaName}.port_group_template pgt on pgt.template_id = f.id
      group by f.id, f.name, f.category, f.brand, f.model, f.u_height, f.front_color, f.rear_color,
        f.model3d_url, f.image_url, f.is_builtin, f.max_power_w, f.spec_json, f.description,
        f.created_at, f.updated_at
      order by f.category, f.brand, f.model
      limit $${params.length - 1} offset $${params.length}
    `,
    params,
  );

  return {
    data: result.rows.map(mapDeviceTemplate),
    total: toNumber(result.rows[0]?.total),
    current,
    pageSize,
  };
};

const mapDeviceTemplate = (row: any) => ({
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
});

const getDeviceTemplate = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'device_template.detail',
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
      where dt.id = $1
      group by dt.id
      limit 1
    `,
    [id],
  );

  return result.rows[0] ? mapDeviceTemplate(result.rows[0]) : null;
};

const createDeviceTemplate = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const id = `tpl-custom-${crypto.randomBytes(4).toString('hex')}`;
  await queryDatabase(
    req,
    'device_template.create',
    `
      insert into ${schemaName}.device_template (
        id, name, category, brand, model, u_height, front_color, is_builtin,
        max_power_w, spec_json, description, source_system, created_at, updated_at
      )
      values ($1, $2, $3, $4, $5, $6, $7, false, $8, $9::jsonb, $10, 'database', now(), now())
    `,
    [
      id,
      String(body.name || '').trim(),
      String(body.category || 'other'),
      String(body.brand || '').trim(),
      String(body.model || '').trim(),
      toPositiveInt(body.uHeight, 1),
      optionalString(body.frontColor) || '#3d3d3d',
      body.maxPower === undefined || body.maxPower === '' ? 0 : toNumber(body.maxPower),
      JSON.stringify(body.specs || {}),
      optionalString(body.description),
    ],
  );

  const portGroups = Array.isArray(body.portGroups) ? body.portGroups : [];
  for (let index = 0; index < portGroups.length; index += 1) {
    const pg = portGroups[index] || {};
    await queryDatabase(
      req,
      'device_template.port_group.create',
      `
        insert into ${schemaName}.port_group_template (
          id, template_id, name, port_type, port_count, speed, poe
        )
        values ($1, $2, $3, $4, $5, $6, $7)
      `,
      [
        `pg-${index + 1}`,
        id,
        String(pg.name || `${pg.portType || 'RJ45'}端口`),
        String(pg.portType || 'RJ45'),
        toPositiveInt(pg.count, 1),
        String(pg.speed || '1G'),
        Boolean(pg.poe),
      ],
    );
  }

  return getDeviceTemplate(req, schema, id);
};

const updateDeviceTemplate = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const existing = await queryDatabase<{ is_builtin: boolean }>(
    req,
    'device_template.update.check',
    `select is_builtin from ${schemaName}.device_template where id = $1`,
    [id],
  );

  if (!existing.rows[0]) return { errorMessage: '设备模板不存在', data: null, status: 404 };
  if (existing.rows[0].is_builtin) return { errorMessage: '内置模板不能修改', data: null, status: 403 };

  const result = await queryDatabase<any>(
    req,
    'device_template.update',
    `
      update ${schemaName}.device_template
      set
        name = coalesce($2, name),
        category = coalesce($3, category),
        brand = coalesce($4, brand),
        model = coalesce($5, model),
        u_height = coalesce($6, u_height),
        front_color = coalesce($7, front_color),
        max_power_w = coalesce($8, max_power_w),
        spec_json = coalesce($9::jsonb, spec_json),
        description = $10,
        updated_at = now()
      where id = $1
      returning id
    `,
    [
      id,
      body.name === undefined ? null : String(body.name).trim(),
      body.category === undefined ? null : String(body.category),
      body.brand === undefined ? null : String(body.brand).trim(),
      body.model === undefined ? null : String(body.model).trim(),
      body.uHeight === undefined || body.uHeight === '' ? null : toPositiveInt(body.uHeight, 1),
      body.frontColor === undefined ? null : String(body.frontColor).trim(),
      body.maxPower === undefined || body.maxPower === '' ? null : toNumber(body.maxPower),
      body.specs === undefined ? null : JSON.stringify(body.specs || {}),
      body.description === undefined ? null : optionalString(body.description),
    ],
  );

  if (Array.isArray(body.portGroups)) {
    await queryDatabase(req, 'device_template.port_group.delete', `delete from ${schemaName}.port_group_template where template_id = $1`, [id]);
    for (let index = 0; index < body.portGroups.length; index += 1) {
      const pg = body.portGroups[index] || {};
      await queryDatabase(
        req,
        'device_template.port_group.update_insert',
        `
          insert into ${schemaName}.port_group_template (
            id, template_id, name, port_type, port_count, speed, poe
          )
          values ($1, $2, $3, $4, $5, $6, $7)
        `,
        [
          pg.id || `pg-${index + 1}`,
          id,
          String(pg.name || `${pg.portType || 'RJ45'}端口`),
          String(pg.portType || 'RJ45'),
          toPositiveInt(pg.count, 1),
          String(pg.speed || '1G'),
          Boolean(pg.poe),
        ],
      );
    }
  }

  return { data: result.rows[0] ? await getDeviceTemplate(req, schema, id) : null, status: 200 };
};

const deleteDeviceTemplate = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const existing = await queryDatabase<{ is_builtin: boolean }>(
    req,
    'device_template.delete.check',
    `select is_builtin from ${schemaName}.device_template where id = $1`,
    [id],
  );

  if (!existing.rows[0]) return { deleted: false, status: 404, errorMessage: '设备模板不存在' };
  if (existing.rows[0].is_builtin) return { deleted: false, status: 403, errorMessage: '内置模板不能删除' };

  const usage = await queryDatabase<{ count: string }>(
    req,
    'device_template.delete.check_usage',
    `
      select (
        (select count(*) from ${schemaName}.device where template_id = $1) +
        (select count(*) from ${schemaName}.pdu where template_id = $1)
      )::int as count
    `,
    [id],
  );

  if (toNumber(usage.rows[0]?.count) > 0) {
    return { deleted: false, status: 400, errorMessage: '设备模板已被设备使用，不能删除。' };
  }

  await queryDatabase(req, 'device_template.port_group.delete', `delete from ${schemaName}.port_group_template where template_id = $1`, [id]);
  const result = await queryDatabase<{ id: string }>(
    req,
    'device_template.delete',
    `delete from ${schemaName}.device_template where id = $1 returning id`,
    [id],
  );

  return { deleted: result.rows.length > 0, status: 200 };
};

const getDeviceCategories = () => [
  { value: 'switch', label: '交换机' },
  { value: 'router', label: '路由器' },
  { value: 'server', label: '服务器' },
  { value: 'storage', label: '存储' },
  { value: 'firewall', label: '防火墙' },
  { value: 'loadbalancer', label: '负载均衡' },
  { value: 'other', label: '其他' },
];

const getDeviceBrands = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{ brand: string }>(
    req,
    'device_template.brands',
    `select distinct brand from ${schemaName}.device_template where brand is not null order by brand`,
  );

  return result.rows.map((row) => ({ value: row.brand, label: row.brand }));
};

const getDevices = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const current = toPositiveInt(req.query.current, 1);
  const pageSize = toPositiveInt(req.query.pageSize, 10);
  const offset = (current - 1) * pageSize;
  const params: unknown[] = [];
  const filters: string[] = [];

  if (req.query.cabinetId) {
    params.push(String(req.query.cabinetId));
    filters.push(`ri.cabinet_id = $${params.length}`);
  }
  if (req.query.datacenterId) {
    params.push(String(req.query.datacenterId));
    filters.push(`c.datacenter_id = $${params.length}`);
  }
  if (req.query.templateId) {
    params.push(String(req.query.templateId));
    filters.push(`d.template_id = $${params.length}`);
  }
  if (req.query.name) {
    params.push(`%${String(req.query.name)}%`);
    filters.push(`d.name ilike $${params.length}`);
  }
  if (req.query.status) {
    params.push(String(req.query.status));
    filters.push(`d.operational_status = $${params.length}`);
  }
  if (req.query.assetCode) {
    params.push(`%${String(req.query.assetCode)}%`);
    filters.push(`d.asset_code ilike $${params.length}`);
  }
  if (req.query.managementIp) {
    params.push(`%${String(req.query.managementIp)}%`);
    filters.push(`host(d.management_ip) ilike $${params.length}`);
  }
  if (req.query.department) {
    params.push(String(req.query.department));
    filters.push(`d.department = $${params.length}`);
  }
  if (req.query.isMounted === 'true') {
    filters.push('ri.cabinet_id is not null');
  }
  if (req.query.isMounted === 'false') {
    filters.push('ri.cabinet_id is null');
  }

  const where = filters.length ? `where ${filters.join(' and ')}` : '';
  params.push(pageSize, offset);

  const result = await queryDatabase<any>(
    req,
    'device.list',
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
        left join ${schemaName}.cabinet c on c.id = ri.cabinet_id
        ${where}
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
        host(md.management_ip) as management_ip,
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
      limit $${params.length - 1} offset $${params.length}
    `,
    params,
  );

  const total = toNumber(result.rows[0]?.total);
  const data = result.rows.map(mapDevice);

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

const getCabinets = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const current = toPositiveInt(req.query.current, 1);
  const pageSize = toPositiveInt(req.query.pageSize, 10);
  const offset = (current - 1) * pageSize;
  const params: unknown[] = [];
  const filters: string[] = [];

  if (req.query.datacenterId) {
    params.push(String(req.query.datacenterId));
    filters.push(`c.datacenter_id = $${params.length}`);
  }
  if (req.query.name) {
    params.push(`%${String(req.query.name)}%`);
    filters.push(`c.name ilike $${params.length}`);
  }
  if (req.query.status) {
    params.push(String(req.query.status));
    filters.push(`c.health_status = $${params.length}`);
  }
  if (req.query.code) {
    params.push(`%${String(req.query.code)}%`);
    filters.push(`c.code ilike $${params.length}`);
  }

  const whereClause = filters.length ? `where ${filters.join(' and ')}` : '';
  params.push(pageSize, offset);

  const result = await queryDatabase<any>(
    req,
    'cabinet.list',
    `
      with filtered as (
        ${cabinetSelectSql(schemaName, whereClause)}
      ),
      total_count as (
        select count(*)::int as total from filtered
      )
      select filtered.*, (select total from total_count) as total
      from filtered
      order by datacenter_id, row_no, column_no, id
      limit $${params.length - 1} offset $${params.length}
    `,
    params,
  );

  return {
    data: result.rows.map(mapCabinet),
    total: toNumber(result.rows[0]?.total),
    current,
    pageSize,
  };
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

const createCabinet = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const id = `cab-${crypto.randomBytes(4).toString('hex')}`;
  const result = await queryDatabase<any>(
    req,
    'cabinet.create',
    `
      insert into ${schemaName}.cabinet (
        id, datacenter_id, name, code, row_no, column_no, u_height,
        max_power_w, health_status, description, source_system, created_at, updated_at
      )
      values ($1, $2, $3, $4, $5, $6, $7, $8, 'normal', $9, 'database', now(), now())
      returning id
    `,
    [
      id,
      String(body.datacenterId || ''),
      String(body.name || '').trim(),
      String(body.code || '').trim(),
      toPositiveInt(body.row, 1),
      toPositiveInt(body.column, 1),
      toPositiveInt(body.uHeight, 42),
      body.maxPower === undefined || body.maxPower === '' ? 10000 : toNumber(body.maxPower),
      optionalString(body.description),
    ],
  );

  return getCabinet(req, schema, result.rows[0].id);
};

const updateCabinet = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const result = await queryDatabase<any>(
    req,
    'cabinet.update',
    `
      update ${schemaName}.cabinet
      set
        datacenter_id = coalesce($2, datacenter_id),
        name = coalesce($3, name),
        code = coalesce($4, code),
        row_no = coalesce($5, row_no),
        column_no = coalesce($6, column_no),
        u_height = coalesce($7, u_height),
        max_power_w = coalesce($8, max_power_w),
        health_status = coalesce($9, health_status),
        description = $10,
        updated_at = now()
      where id = $1
      returning id
    `,
    [
      id,
      body.datacenterId === undefined ? null : String(body.datacenterId),
      body.name === undefined ? null : String(body.name).trim(),
      body.code === undefined ? null : String(body.code).trim(),
      body.row === undefined || body.row === '' ? null : toPositiveInt(body.row, 1),
      body.column === undefined || body.column === '' ? null : toPositiveInt(body.column, 1),
      body.uHeight === undefined || body.uHeight === '' ? null : toPositiveInt(body.uHeight, 42),
      body.maxPower === undefined || body.maxPower === '' ? null : toNumber(body.maxPower),
      body.status === undefined ? null : String(body.status),
      body.description === undefined ? null : optionalString(body.description),
    ],
  );

  return result.rows[0] ? getCabinet(req, schema, result.rows[0].id) : null;
};

const deleteCabinet = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const usage = await queryDatabase<{ count: string }>(
    req,
    'cabinet.delete.check_usage',
    `
      select count(*)::int as count
      from ${schemaName}.rack_installation
      where cabinet_id = $1 and valid_to is null
    `,
    [id],
  );

  if (toNumber(usage.rows[0]?.count) > 0) {
    return { deleted: false, status: 400, errorMessage: '该机柜存在已上架设备或PDU，不能删除。' };
  }

  const result = await queryDatabase<{ id: string }>(
    req,
    'cabinet.delete',
    `delete from ${schemaName}.cabinet where id = $1 returning id`,
    [id],
  );

  return {
    deleted: result.rows.length > 0,
    status: result.rows.length > 0 ? 200 : 404,
    errorMessage: result.rows.length > 0 ? undefined : '机柜不存在',
  };
};

const getCabinetUUsage = async (req: Request, schema: string, id: string) => {
  const cabinet = await getCabinet(req, schema, id);
  if (!cabinet) return null;

  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'cabinet.u_usage',
    `
      select
        ri.start_u,
        ri.end_u,
        ri.device_id,
        d.name as device_name,
        ri.pdu_id,
        p.name as pdu_name
      from ${schemaName}.rack_installation ri
      left join ${schemaName}.device d on d.id = ri.device_id
      left join ${schemaName}.pdu p on p.id = ri.pdu_id
      where ri.cabinet_id = $1 and ri.valid_to is null
      order by ri.start_u
    `,
    [id],
  );

  const uSlots = Array.from({ length: cabinet.uHeight }, (_, index) => ({
    u: index + 1,
    deviceId: null as string | null,
    deviceName: null as string | null,
  }));

  result.rows.forEach((row) => {
    const assetId = row.device_id || row.pdu_id;
    const assetName = row.device_name || row.pdu_name;
    for (let u = toNumber(row.start_u); u <= toNumber(row.end_u); u += 1) {
      const slot = uSlots[u - 1];
      if (!slot) continue;
      slot.deviceId = assetId;
      slot.deviceName = assetName;
    }
  });

  const usedU = uSlots.filter((slot) => slot.deviceId).length;
  return {
    cabinetId: id,
    uHeight: cabinet.uHeight,
    usedU,
    availableU: cabinet.uHeight - usedU,
    uSlots,
  };
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

const getDevice = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'device.detail',
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
        host(d.management_ip) as management_ip,
        d.operational_status,
        ${dateExpr('d.purchase_date')} as purchase_date,
        ${dateExpr('d.warranty_expiry')} as warranty_expiry,
        d.vendor,
        d.owner,
        d.department,
        d.description,
        ${isoExpr('d.created_at')} as created_at,
        ${isoExpr('d.updated_at')} as updated_at
      from ${schemaName}.device d
      left join ${schemaName}.rack_installation ri
        on ri.device_id = d.id
        and ri.asset_type = 'device'
        and ri.valid_to is null
      where d.id = $1
      limit 1
    `,
    [id],
  );

  return result.rows[0] ? mapDevice(result.rows[0]) : null;
};

const createDevicePorts = async (req: Request, schema: string, deviceId: string, templateId: string) => {
  const schemaName = quoteIdentifier(schema);
  const groups = await queryDatabase<any>(
    req,
    'device.ports.template_groups',
    `
      select id, port_type, port_count, speed
      from ${schemaName}.port_group_template
      where template_id = $1
      order by id
    `,
    [templateId],
  );

  for (const group of groups.rows) {
    for (let index = 1; index <= toPositiveInt(group.port_count, 1); index += 1) {
      await queryDatabase(
        req,
        'device.port.create',
        `
          insert into ${schemaName}.port (
            id, device_id, port_group_id, port_number, port_type, speed,
            admin_status, link_status, last_updated
          )
          values ($1, $2, $3, $4, $5, $6, 'up', 'disconnected', now())
          on conflict (device_id, port_number) do nothing
        `,
        [
          `port-${deviceId}-${group.id}-${index}`,
          deviceId,
          group.id,
          `${group.id}-${index}`,
          group.port_type,
          group.speed,
        ],
      );
    }
  }
};

const createDevice = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const id = `dev-${crypto.randomBytes(4).toString('hex')}`;
  const template = await queryDatabase<{ u_height: number }>(
    req,
    'device.create.template',
    `select u_height from ${schemaName}.device_template where id = $1`,
    [String(body.templateId || '')],
  );
  const uHeight = toPositiveInt(template.rows[0]?.u_height, 1);
  const startU = toPositiveInt(body.startU, 1);
  const endU = body.endU === undefined || body.endU === '' ? startU + uHeight - 1 : toPositiveInt(body.endU, startU);

  const result = await queryDatabase<any>(
    req,
    'device.create',
    `
      insert into ${schemaName}.device (
        id, template_id, asset_code, name, serial_number, management_ip,
        operational_status, purchase_date, warranty_expiry, vendor, owner,
        department, description, source_system, created_at, updated_at
      )
      values ($1, $2, $3, $4, $5, $6::inet, 'online', $7::date, $8::date, $9, $10, $11, $12, 'database', now(), now())
      returning id
    `,
    [
      id,
      String(body.templateId || ''),
      String(body.assetCode || '').trim(),
      String(body.name || '').trim(),
      optionalString(body.serialNumber),
      optionalString(body.managementIp),
      optionalDate(body.purchaseDate),
      optionalDate(body.warrantyExpiry),
      optionalString(body.vendor),
      optionalString(body.owner),
      optionalString(body.department),
      optionalString(body.description),
    ],
  );

  await queryDatabase(
    req,
    'device.rack_installation.create',
    `
      insert into ${schemaName}.rack_installation (
        asset_type, device_id, cabinet_id, start_u, end_u, source_system
      )
      values ('device', $1, $2, $3, $4, 'database')
    `,
    [id, String(body.cabinetId || ''), startU, endU],
  );

  await createDevicePorts(req, schema, id, String(body.templateId || ''));
  return getDevice(req, schema, result.rows[0].id);
};

const updateDevice = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const result = await queryDatabase<any>(
    req,
    'device.update',
    `
      update ${schemaName}.device
      set
        template_id = coalesce($2, template_id),
        asset_code = coalesce($3, asset_code),
        name = coalesce($4, name),
        serial_number = $5,
        management_ip = $6::inet,
        operational_status = coalesce($7, operational_status),
        purchase_date = $8::date,
        warranty_expiry = $9::date,
        vendor = $10,
        owner = $11,
        department = $12,
        description = $13,
        updated_at = now()
      where id = $1
      returning id
    `,
    [
      id,
      body.templateId === undefined ? null : String(body.templateId),
      body.assetCode === undefined ? null : String(body.assetCode).trim(),
      body.name === undefined ? null : String(body.name).trim(),
      body.serialNumber === undefined ? null : optionalString(body.serialNumber),
      body.managementIp === undefined ? null : optionalString(body.managementIp),
      body.status === undefined ? null : String(body.status),
      body.purchaseDate === undefined ? null : optionalDate(body.purchaseDate),
      body.warrantyExpiry === undefined ? null : optionalDate(body.warrantyExpiry),
      body.vendor === undefined ? null : optionalString(body.vendor),
      body.owner === undefined ? null : optionalString(body.owner),
      body.department === undefined ? null : optionalString(body.department),
      body.description === undefined ? null : optionalString(body.description),
    ],
  );

  if (!result.rows[0]) return null;

  if (body.cabinetId !== undefined || body.startU !== undefined || body.endU !== undefined) {
    const current = await getDevice(req, schema, id);
    const cabinetId = body.cabinetId === undefined ? current?.cabinetId : String(body.cabinetId);
    const startU = body.startU === undefined ? current?.startU : toPositiveInt(body.startU, 1);
    const endU = body.endU === undefined ? current?.endU : toPositiveInt(body.endU, startU || 1);
    await queryDatabase(
      req,
      'device.rack_installation.close',
      `
        update ${schemaName}.rack_installation
        set valid_to = now()
        where asset_type = 'device' and device_id = $1 and valid_to is null
      `,
      [id],
    );
    if (cabinetId && startU && endU) {
      await queryDatabase(
        req,
        'device.rack_installation.update_insert',
        `
          insert into ${schemaName}.rack_installation (
            asset_type, device_id, cabinet_id, start_u, end_u, source_system
          )
          values ('device', $1, $2, $3, $4, 'database')
        `,
        [id, cabinetId, startU, endU],
      );
    }
  }

  return getDevice(req, schema, id);
};

const deleteDevice = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  await queryDatabase(
    req,
    'device.delete.connections',
    `delete from ${schemaName}.cable_connection where source_device_id = $1 or target_device_id = $1`,
    [id],
  );
  await queryDatabase(req, 'device.delete.ports', `delete from ${schemaName}.port where device_id = $1`, [id]);
  await queryDatabase(req, 'device.delete.rack_installation', `delete from ${schemaName}.rack_installation where device_id = $1`, [id]);
  const result = await queryDatabase<{ id: string }>(
    req,
    'device.delete',
    `delete from ${schemaName}.device where id = $1 returning id`,
    [id],
  );

  return result.rows.length > 0;
};

const unmountDevice = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{ id: string }>(
    req,
    'device.unmount',
    `
      update ${schemaName}.rack_installation
      set valid_to = now()
      where asset_type = 'device' and device_id = $1 and valid_to is null
      returning device_id as id
    `,
    [id],
  );

  return result.rows[0] ? getDevice(req, schema, id) : null;
};

const batchUpdateDeviceStatus = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const ids = Array.isArray(req.body?.ids) ? req.body.ids.map(String) : [];
  const status = String(req.body?.status || 'offline');
  if (!ids.length) return 0;
  const result = await queryDatabase<{ id: string }>(
    req,
    'device.batch_status',
    `
      update ${schemaName}.device
      set operational_status = $2, updated_at = now()
      where id = any($1::text[])
      returning id
    `,
    [ids, status],
  );

  return result.rows.length;
};

const getDeviceStats = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'device.stats',
    `
      with base as (
        select d.*, dt.category
        from ${schemaName}.device d
        left join ${schemaName}.device_template dt on dt.id = d.template_id
      )
      select
        (select count(*)::int from base) as total,
        (select count(*)::int from base where operational_status = 'online') as online,
        (select count(*)::int from base where operational_status = 'offline') as offline,
        (select count(*)::int from base where operational_status = 'warning') as warning,
        (select count(*)::int from base where operational_status = 'error') as error,
        (select count(*)::int from base where operational_status = 'maintenance') as maintenance,
        coalesce((select jsonb_object_agg(category, category_count) from (
          select category, count(*)::int as category_count
          from base
          where category is not null
          group by category
        ) categories), '{}'::jsonb) as by_category,
        coalesce((select jsonb_object_agg(department, department_count) from (
          select department, count(*)::int as department_count
          from base
          where department is not null
          group by department
        ) departments), '{}'::jsonb) as by_department
    `,
  );
  const row = result.rows[0] || {};
  return {
    total: toNumber(row.total),
    online: toNumber(row.online),
    offline: toNumber(row.offline),
    warning: toNumber(row.warning),
    error: toNumber(row.error),
    maintenance: toNumber(row.maintenance),
    byCategory: row.by_category || {},
    byDepartment: row.by_department || {},
  };
};

const validateDeviceMount = async (req: Request, schema: string) => {
  const body = req.body || {};
  const cabinetId = String(body.cabinetId || '');
  const cabinetUHeight = toPositiveInt(body.cabinetUHeight, 42);
  const deviceUHeight = toPositiveInt(body.deviceUHeight, 1);
  const startU = body.startU === undefined ? undefined : toPositiveInt(body.startU, 1);
  const endU = body.endU === undefined ? (startU ? startU + deviceUHeight - 1 : undefined) : toPositiveInt(body.endU, startU || 1);
  const schemaName = quoteIdentifier(schema);
  const existing = await queryDatabase<any>(
    req,
    'device.validate_mount.existing',
    `
      select start_u, end_u
      from ${schemaName}.rack_installation
      where cabinet_id = $1 and valid_to is null
    `,
    [cabinetId],
  );

  const errors: string[] = [];
  const warnings: string[] = [];
  const isOverlap = (aStart: number, aEnd: number, bStart: number, bEnd: number) =>
    Math.max(aStart, bStart) <= Math.min(aEnd, bEnd);
  const canPlaceAt = (candidateStart: number) => {
    const candidateEnd = candidateStart + deviceUHeight - 1;
    if (candidateEnd > cabinetUHeight) return false;
    return !existing.rows.some((row) =>
      isOverlap(candidateStart, candidateEnd, toNumber(row.start_u), toNumber(row.end_u)),
    );
  };

  let recommendedStartU: number | undefined;
  for (let u = cabinetUHeight - deviceUHeight + 1; u >= 1; u -= 1) {
    if (canPlaceAt(u)) {
      recommendedStartU = u;
      break;
    }
  }

  if (startU && endU) {
    if (startU < 1) errors.push('起始U位必须大于等于1');
    if (endU > cabinetUHeight) errors.push('U位超出机柜高度');
    if (!canPlaceAt(startU)) errors.push('所选U位区间存在占用冲突');
  }

  const maxPower = toNumber(body.cabinetMaxPower);
  const currentPower = toNumber(body.cabinetCurrentPower);
  const devicePower = toNumber(body.deviceMaxPower);
  const powerAfter = maxPower ? currentPower + devicePower : undefined;
  const powerRatioAfter = maxPower && powerAfter !== undefined ? powerAfter / maxPower : undefined;

  if (maxPower && powerAfter !== undefined) {
    if (powerAfter > maxPower) errors.push('功率将超过机柜最大承载');
    if (powerAfter / maxPower >= 0.8 && powerAfter <= maxPower) warnings.push('功率负载较高，可能存在散热压力');
  }
  if (!body.totalPortCount) warnings.push('设备模板未定义端口信息');
  if ((body.powerPortCount || 0) < 2) warnings.push('设备电源口可能不支持A/B双路冗余');
  warnings.push('A/B路电源来源未配置，建议在电力拓扑中补齐冗余链路');

  return {
    ok: errors.length === 0,
    errors,
    warnings,
    recommendedStartU,
    recommendedEndU: recommendedStartU ? recommendedStartU + deviceUHeight - 1 : undefined,
    powerAfter,
    powerRatioAfter,
  };
};

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
        host(d.management_ip) as management_ip,
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

const getPort = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'port.detail',
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
      where p.id = $1
      limit 1
    `,
    [id],
  );

  return result.rows[0]
    ? {
        id: result.rows[0].id,
        deviceId: result.rows[0].device_id,
        portGroupId: result.rows[0].port_group_id,
        groupId: result.rows[0].port_group_id,
        index: 0,
        portNumber: result.rows[0].port_number,
        portAlias: result.rows[0].port_alias || undefined,
        portType: result.rows[0].port_type,
        speed: result.rows[0].speed,
        status: result.rows[0].admin_status,
        linkStatus: result.rows[0].link_status,
        vlanConfig: result.rows[0].vlan_config || undefined,
        qosConfig: result.rows[0].qos_config || undefined,
        macBindings: result.rows[0].mac_bindings || undefined,
        portSecurity: result.rows[0].port_security ?? undefined,
        maxMacCount: result.rows[0].max_mac_count ?? undefined,
        dot1xEnabled: result.rows[0].dot1x_enabled ?? undefined,
        connectedDeviceId: result.rows[0].connected_device_id || undefined,
        connectedPortId: result.rows[0].connected_port_id || undefined,
        connectionPurpose: result.rows[0].connection_purpose || undefined,
        lastUpdated: result.rows[0].last_updated,
        description: result.rows[0].description || undefined,
      }
    : null;
};

const updatePort = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const result = await queryDatabase<{ id: string }>(
    req,
    'port.update',
    `
      update ${schemaName}.port
      set
        port_alias = $2,
        admin_status = coalesce($3, admin_status),
        vlan_config = coalesce($4::jsonb, vlan_config),
        qos_config = coalesce($5::jsonb, qos_config),
        description = $6,
        last_updated = now()
      where id = $1
      returning id
    `,
    [
      id,
      body.portAlias === undefined ? null : optionalString(body.portAlias),
      body.status === undefined ? null : String(body.status),
      body.vlanConfig === undefined ? null : JSON.stringify(body.vlanConfig),
      body.qosConfig === undefined ? null : JSON.stringify(body.qosConfig),
      body.description === undefined ? null : optionalString(body.description),
    ],
  );

  return result.rows[0] ? getPort(req, schema, result.rows[0].id) : null;
};

const batchUpdatePortVlan = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const portIds = Array.isArray(req.body?.portIds) ? req.body.portIds.map(String) : [];
  if (!portIds.length) return [];
  const result = await queryDatabase<{ id: string }>(
    req,
    'port.batch_vlan',
    `
      update ${schemaName}.port
      set vlan_config = $2::jsonb, last_updated = now()
      where id = any($1::text[])
      returning id
    `,
    [portIds, JSON.stringify(req.body?.vlanConfig || {})],
  );

  const updated = [];
  for (const row of result.rows) {
    const port = await getPort(req, schema, row.id);
    if (port) updated.push(port);
  }
  return updated;
};

const batchUpdatePortStatus = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const portIds = Array.isArray(req.body?.portIds) ? req.body.portIds.map(String) : [];
  const status = String(req.body?.status || 'down');
  if (!portIds.length) return 0;
  const result = await queryDatabase<{ id: string }>(
    req,
    'port.batch_status',
    `
      update ${schemaName}.port
      set admin_status = $2, last_updated = now()
      where id = any($1::text[])
      returning id
    `,
    [portIds, status],
  );

  return result.rows.length;
};

const getPortStats = async (req: Request, schema: string, deviceId: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'port.stats',
    `
      select
        count(*)::int as total,
        count(*) filter (where admin_status = 'up')::int as up,
        count(*) filter (where admin_status = 'down')::int as down,
        count(*) filter (where admin_status = 'disabled')::int as disabled,
        count(*) filter (where admin_status = 'error')::int as error,
        count(*) filter (where link_status = 'connected')::int as connected,
        count(*) filter (where link_status = 'disconnected')::int as disconnected,
        coalesce((select jsonb_object_agg(port_type, type_count) from (
          select port_type, count(*)::int as type_count
          from ${schemaName}.port
          where device_id = $1
          group by port_type
        ) types), '{}'::jsonb) as by_type
      from ${schemaName}.port
      where device_id = $1
    `,
    [deviceId],
  );
  const row = result.rows[0] || {};
  return {
    total: toNumber(row.total),
    up: toNumber(row.up),
    down: toNumber(row.down),
    disabled: toNumber(row.disabled),
    error: toNumber(row.error),
    connected: toNumber(row.connected),
    disconnected: toNumber(row.disconnected),
    byType: row.by_type || {},
  };
};

const getPortTypes = () => [
  { value: 'RJ45', label: 'RJ45电口' },
  { value: 'SFP', label: 'SFP光口' },
  { value: 'SFP+', label: 'SFP+万兆光口' },
  { value: 'QSFP+', label: 'QSFP+ 40G光口' },
  { value: 'QSFP28', label: 'QSFP28 100G光口' },
  { value: 'FC', label: 'FC光纤通道口' },
  { value: 'USB', label: 'USB接口' },
  { value: 'Console', label: 'Console控制台' },
  { value: 'Power', label: '电源接口' },
];

const getPortSpeeds = () => [
  { value: '100M', label: '100Mbps' },
  { value: '1G', label: '1Gbps' },
  { value: '10G', label: '10Gbps' },
  { value: '25G', label: '25Gbps' },
  { value: '40G', label: '40Gbps' },
  { value: '100G', label: '100Gbps' },
  { value: 'N/A', label: '不适用' },
];

const getVlanModes = () => [
  { value: 'access', label: 'Access' },
  { value: 'trunk', label: 'Trunk' },
  { value: 'hybrid', label: 'Hybrid' },
];

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

const mapConnection = (row: any) => ({
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
});

const connectionSelectSql = (schemaName: string, whereClause = '') => `
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
  ${whereClause}
`;

const getConnections = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const current = toPositiveInt(req.query.current, 1);
  const pageSize = toPositiveInt(req.query.pageSize, 10);
  const offset = (current - 1) * pageSize;
  const params: unknown[] = [];
  const filters: string[] = [];

  if (req.query.connectionType) {
    params.push(String(req.query.connectionType));
    filters.push(`cc.connection_type = $${params.length}`);
  }
  if (req.query.cableType) {
    params.push(String(req.query.cableType));
    filters.push(`cc.cable_type = $${params.length}`);
  }
  if (req.query.sourceDeviceId) {
    params.push(String(req.query.sourceDeviceId));
    filters.push(`cc.source_device_id = $${params.length}`);
  }
  if (req.query.targetDeviceId) {
    params.push(String(req.query.targetDeviceId));
    filters.push(`cc.target_device_id = $${params.length}`);
  }
  if (req.query.status) {
    params.push(String(req.query.status));
    filters.push(`cc.status = $${params.length}`);
  }
  if (req.query.cableNumber) {
    params.push(`%${String(req.query.cableNumber)}%`);
    filters.push(`cc.cable_number ilike $${params.length}`);
  }

  const whereClause = filters.length ? `where ${filters.join(' and ')}` : '';
  params.push(pageSize, offset);
  const result = await queryDatabase<any>(
    req,
    'connection.list',
    `
      with filtered as (
        ${connectionSelectSql(schemaName, whereClause)}
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
    data: result.rows.map(mapConnection),
    total: toNumber(result.rows[0]?.total),
    current,
    pageSize,
  };
};

const getConnection = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'connection.detail',
    `${connectionSelectSql(schemaName, 'where cc.id = $1')} limit 1`,
    [id],
  );

  return result.rows[0] ? mapConnection(result.rows[0]) : null;
};

const syncConnectionPorts = async (
  req: Request,
  schema: string,
  connectedPortIds: string[],
  disconnectedPortIds: string[],
) => {
  const schemaName = quoteIdentifier(schema);
  if (connectedPortIds.length) {
    await queryDatabase(
      req,
      'connection.ports.connect',
      `
        update ${schemaName}.port
        set link_status = 'connected', last_updated = now()
        where id = any($1::text[])
      `,
      [connectedPortIds],
    );
  }
  if (disconnectedPortIds.length) {
    await queryDatabase(
      req,
      'connection.ports.disconnect',
      `
        update ${schemaName}.port
        set link_status = 'disconnected', last_updated = now()
        where id = any($1::text[])
          and not exists (
            select 1
            from ${schemaName}.cable_connection cc
            where cc.source_port_id = port.id or cc.target_port_id = port.id
          )
      `,
      [disconnectedPortIds],
    );
  }
};

const createConnection = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const id = `conn-${crypto.randomBytes(4).toString('hex')}`;
  const result = await queryDatabase<{ id: string }>(
    req,
    'connection.create',
    `
      insert into ${schemaName}.cable_connection (
        id,
        cable_number,
        connection_type,
        cable_type,
        cable_color,
        cable_length_m,
        source_device_id,
        source_port_id,
        target_device_id,
        target_port_id,
        status,
        description,
        source_system,
        created_at,
        updated_at
      )
      values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, 'active', $11, 'database', now(), now())
      returning id
    `,
    [
      id,
      String(body.cableNumber || '').trim(),
      String(body.connectionType || 'network'),
      String(body.cableType || 'Cat6'),
      optionalString(body.cableColor) || '#3498db',
      body.cableLength === undefined || body.cableLength === '' ? null : toNumber(body.cableLength),
      String(body.sourceDeviceId || ''),
      String(body.sourcePortId || ''),
      String(body.targetDeviceId || ''),
      String(body.targetPortId || ''),
      optionalString(body.description),
    ],
  );

  await syncConnectionPorts(req, schema, [String(body.sourcePortId), String(body.targetPortId)], []);
  return getConnection(req, schema, result.rows[0].id);
};

const updateConnection = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const previous = await getConnection(req, schema, id);
  if (!previous) return null;

  const body = req.body || {};
  const result = await queryDatabase<{ id: string }>(
    req,
    'connection.update',
    `
      update ${schemaName}.cable_connection
      set
        cable_number = coalesce($2, cable_number),
        connection_type = coalesce($3, connection_type),
        cable_type = coalesce($4, cable_type),
        cable_color = coalesce($5, cable_color),
        cable_length_m = coalesce($6, cable_length_m),
        source_device_id = coalesce($7, source_device_id),
        source_port_id = coalesce($8, source_port_id),
        target_device_id = coalesce($9, target_device_id),
        target_port_id = coalesce($10, target_port_id),
        status = coalesce($11, status),
        description = $12,
        updated_at = now()
      where id = $1
      returning id
    `,
    [
      id,
      body.cableNumber === undefined ? null : String(body.cableNumber).trim(),
      body.connectionType === undefined ? null : String(body.connectionType),
      body.cableType === undefined ? null : String(body.cableType),
      body.cableColor === undefined ? null : optionalString(body.cableColor),
      body.cableLength === undefined || body.cableLength === '' ? null : toNumber(body.cableLength),
      body.sourceDeviceId === undefined ? null : String(body.sourceDeviceId),
      body.sourcePortId === undefined ? null : String(body.sourcePortId),
      body.targetDeviceId === undefined ? null : String(body.targetDeviceId),
      body.targetPortId === undefined ? null : String(body.targetPortId),
      body.status === undefined ? null : String(body.status),
      body.description === undefined ? null : optionalString(body.description),
    ],
  );

  const next = await getConnection(req, schema, result.rows[0].id);
  const connected = [next?.sourcePortId, next?.targetPortId].filter(Boolean) as string[];
  const disconnected = [previous.sourcePortId, previous.targetPortId].filter((portId) => !connected.includes(portId)) as string[];
  await syncConnectionPorts(req, schema, connected, disconnected);
  return next;
};

const deleteConnection = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const previous = await getConnection(req, schema, id);
  if (!previous) return false;
  const result = await queryDatabase<{ id: string }>(
    req,
    'connection.delete',
    `delete from ${schemaName}.cable_connection where id = $1 returning id`,
    [id],
  );

  if (result.rows.length) {
    await syncConnectionPorts(req, schema, [], [previous.sourcePortId, previous.targetPortId]);
  }
  return result.rows.length > 0;
};

const getConnectionsByDevice = async (req: Request, schema: string, deviceId: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'connection.by_device',
    `
      ${connectionSelectSql(schemaName, 'where cc.source_device_id = $1 or cc.target_device_id = $1')}
      order by cc.created_at desc, cc.id
    `,
    [deviceId],
  );

  return result.rows.map(mapConnection);
};

const getConnectionStats = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'connection.stats',
    `
      select
        count(*)::int as total,
        count(*) filter (where status = 'active')::int as active,
        count(*) filter (where status = 'inactive')::int as inactive,
        count(*) filter (where status = 'faulty')::int as faulty,
        coalesce((select jsonb_object_agg(connection_type, type_count) from (
          select connection_type, count(*)::int as type_count
          from ${schemaName}.cable_connection
          group by connection_type
        ) types), '{}'::jsonb) as by_type,
        coalesce((select jsonb_object_agg(cable_type, cable_count) from (
          select cable_type, count(*)::int as cable_count
          from ${schemaName}.cable_connection
          group by cable_type
        ) cable_types), '{}'::jsonb) as by_cable_type
      from ${schemaName}.cable_connection
    `,
  );
  const row = result.rows[0] || {};
  return {
    total: toNumber(row.total),
    active: toNumber(row.active),
    inactive: toNumber(row.inactive),
    faulty: toNumber(row.faulty),
    byType: row.by_type || {},
    byCableType: row.by_cable_type || {},
  };
};

const getConnectionTypes = () => [
  { value: 'network', label: '网络连线', color: '#3498db' },
  { value: 'power', label: '电源连线', color: '#e74c3c' },
  { value: 'management', label: '管理连线', color: '#27ae60' },
  { value: 'storage', label: '存储连线', color: '#9b59b6' },
  { value: 'stack', label: '堆叠连线', color: '#f39c12' },
];

const getCableTypes = () => [
  { value: 'Cat5e', label: 'Cat5e网线' },
  { value: 'Cat6', label: 'Cat6网线' },
  { value: 'Cat6a', label: 'Cat6a网线' },
  { value: 'Cat7', label: 'Cat7网线' },
  { value: 'SingleModeFiber', label: '单模光纤' },
  { value: 'MultiModeFiber', label: '多模光纤' },
  { value: 'DAC', label: 'DAC高速铜缆' },
  { value: 'AOC', label: 'AOC有源光缆' },
  { value: 'PowerCable', label: '电源线' },
];

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

  const fallbackFacilities: IDC.DatacenterLayoutFacilityItem[] = [
    { id: 'facility-camera-north', type: 'camera', name: '摄像头-北侧通道', x: 8, y: 4, height: 2.5, rotation: 45, pitch: -18 },
    { id: 'facility-camera-south', type: 'camera', name: '摄像头-南侧通道', x: 52, y: 36, height: 2.5, rotation: 225, pitch: -24 },
    {
      id: 'facility-extinguisher-west',
      type: 'fire_extinguisher',
      name: '灭火器-西侧立柱',
      x: 6,
      y: 20,
      rotation: 0,
    },
    {
      id: 'facility-extinguisher-east',
      type: 'fire_extinguisher',
      name: '灭火器-东侧立柱',
      x: 54,
      y: 20,
      rotation: 0,
    },
    { id: 'facility-access-main', type: 'door', name: '门禁-主入口', x: 30, y: 1.2, rotation: 0 },
    { id: 'facility-temp-sensor-a', type: 'sensor', name: '温湿度传感器-A区', x: 18, y: 16, rotation: 0 },
  ];

  const layout = result.rows[0]?.raw_json || {
    datacenterId,
    version: 1,
    canvasWidth: 60,
    canvasHeight: 40,
    pxPerMeter: 50,
    cabinets: [],
    zones: [],
    facilities: fallbackFacilities,
    updatedAt: new Date().toISOString(),
  };

  return {
    ...layout,
    datacenterId: layout.datacenterId || datacenterId,
    facilities: Array.isArray(layout.facilities) && layout.facilities.length > 0
      ? layout.facilities
      : fallbackFacilities,
  };
};

const saveDatacenterLayout = async (req: Request, schema: string, datacenterId: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const prev = await getDatacenterLayout(req, schema, datacenterId);
  const updatedAt = new Date().toISOString();
  const next = {
    ...prev,
    datacenterId,
    version: toNumber(body.version ?? prev.version, 1) + 1,
    canvasWidth: toNumber(body.canvasWidth ?? prev.canvasWidth, 60),
    canvasHeight: toNumber(body.canvasHeight ?? prev.canvasHeight, 40),
    pxPerMeter: toNumber(body.pxPerMeter ?? prev.pxPerMeter, 50),
    cabinets: Array.isArray(body.cabinets) ? body.cabinets : prev.cabinets || [],
    zones: Array.isArray(body.zones) ? body.zones : prev.zones || [],
    facilities: Array.isArray(body.facilities) ? body.facilities : prev.facilities || [],
    updatedAt,
  };

  await queryDatabase(
    req,
    '3d.layout.save',
    `
      insert into ${schemaName}.layout_snapshot (
        datacenter_id,
        version,
        canvas_width,
        canvas_height,
        px_per_meter,
        raw_json,
        updated_at
      )
      values ($1, $2, $3, $4, $5, $6::jsonb, $7::timestamptz)
      on conflict (datacenter_id) do update
      set
        version = excluded.version,
        canvas_width = excluded.canvas_width,
        canvas_height = excluded.canvas_height,
        px_per_meter = excluded.px_per_meter,
        raw_json = excluded.raw_json,
        updated_at = excluded.updated_at
    `,
    [
      datacenterId,
      next.version,
      next.canvasWidth,
      next.canvasHeight,
      next.pxPerMeter,
      JSON.stringify(next),
      updatedAt,
    ],
  );

  return next;
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

const mapPduDevice = (row: any) => ({
  id: row.id,
  name: row.name,
  category: 'pdu',
  cabinetId: row.cabinet_id,
  startU: toNumber(row.start_u),
  endU: toNumber(row.end_u),
  uHeight: Math.max(1, toNumber(row.end_u) - toNumber(row.start_u) + 1),
  assetCode: row.asset_code,
  status: row.operational_status,
  managementIp: row.management_ip || undefined,
  pduData: {
    powerPath: row.power_path,
    inputVoltage: toNumber(row.input_voltage),
    outputPorts: toNumber(row.output_ports),
    maxLoad: toNumber(row.max_load_w),
    currentLoad: toNumber(row.current_load_w),
    brand: row.brand || undefined,
    model: row.model || undefined,
  },
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const getPduDevices = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const params: unknown[] = [];
  const filters: string[] = [];

  if (req.query.cabinetId) {
    params.push(String(req.query.cabinetId));
    filters.push(`p.cabinet_id = $${params.length}`);
  }
  if (req.query.powerPath) {
    params.push(String(req.query.powerPath));
    filters.push(`p.power_path = $${params.length}`);
  }

  const where = filters.length ? `where ${filters.join(' and ')}` : '';
  const result = await queryDatabase<any>(
    req,
    'pdu.devices.list',
    `
      select
        p.id,
        p.name,
        p.cabinet_id,
        ri.start_u,
        ri.end_u,
        p.asset_code,
        p.operational_status,
        host(p.management_ip) as management_ip,
        p.power_path,
        p.input_voltage,
        p.output_ports,
        p.max_load_w,
        p.current_load_w,
        p.brand,
        p.model,
        ${isoExpr('p.created_at')} as created_at,
        ${isoExpr('p.updated_at')} as updated_at
      from ${schemaName}.pdu p
      left join ${schemaName}.rack_installation ri
        on ri.pdu_id = p.id
        and ri.asset_type = 'pdu'
        and ri.valid_to is null
      ${where}
      order by p.id
    `,
    params,
  );

  return result.rows.map(mapPduDevice);
};

const getPduDevice = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'pdu.devices.detail',
    `
      select
        p.id,
        p.name,
        p.cabinet_id,
        ri.start_u,
        ri.end_u,
        p.asset_code,
        p.operational_status,
        host(p.management_ip) as management_ip,
        p.power_path,
        p.input_voltage,
        p.output_ports,
        p.max_load_w,
        p.current_load_w,
        p.brand,
        p.model,
        ${isoExpr('p.created_at')} as created_at,
        ${isoExpr('p.updated_at')} as updated_at
      from ${schemaName}.pdu p
      left join ${schemaName}.rack_installation ri
        on ri.pdu_id = p.id
        and ri.asset_type = 'pdu'
        and ri.valid_to is null
      where p.id = $1
      limit 1
    `,
    [id],
  );

  return result.rows[0] ? mapPduDevice(result.rows[0]) : null;
};

const createPduDevice = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const pduData = body.pduData || {};
  const id = `pdu-${crypto.randomBytes(4).toString('hex')}`;
  const startU = toPositiveInt(body.startU, 1);
  const uHeight = toPositiveInt(body.uHeight, 2);
  const endU = body.endU === undefined || body.endU === '' ? startU + uHeight - 1 : toPositiveInt(body.endU, startU);

  const result = await queryDatabase<any>(
    req,
    'pdu.devices.create',
    `
      insert into ${schemaName}.pdu (
        id, cabinet_id, name, asset_code, management_ip, power_path,
        input_voltage, output_ports, max_load_w, current_load_w, brand, model,
        operational_status, source_system, created_at, updated_at
      )
      values ($1, $2, $3, $4, $5::inet, $6, $7, $8, $9, $10, $11, $12, 'online', 'database', now(), now())
      returning id
    `,
    [
      id,
      String(body.cabinetId || ''),
      String(body.name || '').trim(),
      optionalString(body.assetCode) || `PDU-${Date.now()}`,
      optionalString(body.managementIp),
      String(pduData.powerPath || body.powerPath || 'unknown'),
      pduData.inputVoltage === undefined ? 220 : toNumber(pduData.inputVoltage),
      pduData.outputPorts === undefined ? toNumber(body.outputPorts, 16) : toNumber(pduData.outputPorts),
      pduData.maxLoad === undefined ? toNumber(body.maxLoad, 3000) : toNumber(pduData.maxLoad),
      pduData.currentLoad === undefined ? 0 : toNumber(pduData.currentLoad),
      optionalString(pduData.brand),
      optionalString(pduData.model),
    ],
  );

  await queryDatabase(
    req,
    'pdu.rack_installation.create',
    `
      insert into ${schemaName}.rack_installation (
        asset_type, pdu_id, cabinet_id, start_u, end_u, source_system
      )
      values ('pdu', $1, $2, $3, $4, 'database')
    `,
    [id, String(body.cabinetId || ''), startU, endU],
  );

  return getPduDevice(req, schema, result.rows[0].id);
};

const updatePduDevice = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const body = req.body || {};
  const pduData = body.pduData || {};
  const result = await queryDatabase<any>(
    req,
    'pdu.devices.update',
    `
      update ${schemaName}.pdu
      set
        name = coalesce($2, name),
        cabinet_id = coalesce($3, cabinet_id),
        asset_code = coalesce($4, asset_code),
        management_ip = $5::inet,
        power_path = coalesce($6, power_path),
        input_voltage = coalesce($7, input_voltage),
        output_ports = coalesce($8, output_ports),
        max_load_w = coalesce($9, max_load_w),
        current_load_w = coalesce($10, current_load_w),
        brand = coalesce($11, brand),
        model = coalesce($12, model),
        operational_status = coalesce($13, operational_status),
        updated_at = now()
      where id = $1
      returning id
    `,
    [
      id,
      body.name === undefined ? null : String(body.name).trim(),
      body.cabinetId === undefined ? null : String(body.cabinetId),
      body.assetCode === undefined ? null : optionalString(body.assetCode),
      body.managementIp === undefined ? null : optionalString(body.managementIp),
      pduData.powerPath === undefined && body.powerPath === undefined ? null : String(pduData.powerPath || body.powerPath),
      pduData.inputVoltage === undefined && body.inputVoltage === undefined ? null : toNumber(pduData.inputVoltage ?? body.inputVoltage),
      pduData.outputPorts === undefined && body.outputPorts === undefined ? null : toNumber(pduData.outputPorts ?? body.outputPorts),
      pduData.maxLoad === undefined && body.maxLoad === undefined ? null : toNumber(pduData.maxLoad ?? body.maxLoad),
      pduData.currentLoad === undefined && body.currentLoad === undefined ? null : toNumber(pduData.currentLoad ?? body.currentLoad),
      pduData.brand === undefined ? null : optionalString(pduData.brand),
      pduData.model === undefined ? null : optionalString(pduData.model),
      body.status === undefined ? null : String(body.status),
    ],
  );

  if (!result.rows[0]) return null;

  if (body.cabinetId !== undefined || body.startU !== undefined || body.endU !== undefined) {
    const current = await getPduDevice(req, schema, id);
    const cabinetId = body.cabinetId === undefined ? current?.cabinetId : String(body.cabinetId);
    const startU = body.startU === undefined ? current?.startU : toPositiveInt(body.startU, 1);
    const endU = body.endU === undefined ? current?.endU : toPositiveInt(body.endU, startU || 1);
    await queryDatabase(
      req,
      'pdu.rack_installation.close',
      `
        update ${schemaName}.rack_installation
        set valid_to = now()
        where asset_type = 'pdu' and pdu_id = $1 and valid_to is null
      `,
      [id],
    );
    if (cabinetId && startU && endU) {
      await queryDatabase(
        req,
        'pdu.rack_installation.update_insert',
        `
          insert into ${schemaName}.rack_installation (
            asset_type, pdu_id, cabinet_id, start_u, end_u, source_system
          )
          values ('pdu', $1, $2, $3, $4, 'database')
        `,
        [id, cabinetId, startU, endU],
      );
    }
  }

  return getPduDevice(req, schema, id);
};

const deletePduDevice = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  await queryDatabase(req, 'pdu.rack_installation.delete', `delete from ${schemaName}.rack_installation where pdu_id = $1`, [id]);
  const result = await queryDatabase<{ id: string }>(
    req,
    'pdu.devices.delete',
    `delete from ${schemaName}.pdu where id = $1 returning id`,
    [id],
  );

  return result.rows.length > 0;
};

const getPduTemplates = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'pdu.templates',
    `
      select
        id,
        category,
        brand,
        model,
        u_height,
        max_power_w,
        spec_json
      from ${schemaName}.device_template
      where category = 'pdu'
      order by brand, model
    `,
  );

  return result.rows.map((row) => ({
    id: row.id,
    category: 'pdu',
    brand: row.brand,
    model: row.model,
    uHeight: toNumber(row.u_height),
    powerConsumption: 0,
    specs: {
      inputVoltage: row.spec_json?.inputVoltage || '220V',
      outputPorts: toNumber(row.spec_json?.outputPorts),
      maxLoad: row.spec_json?.maxLoad || `${toNumber(row.max_power_w)}W`,
      ratedCurrent: row.spec_json?.ratedCurrent || '',
    },
    portGroups: [],
  }));
};

const mapPowerNodeStatus = (status: string) => {
  if (status === 'error' || status === 'maintenance') return 'warning';
  if (status === 'online' || status === 'offline' || status === 'warning') return status;
  return 'offline';
};

const mapPowerLinkStatus = (status: string) => {
  if (status === 'faulty') return 'fault';
  if (status === 'active' || status === 'inactive' || status === 'fault') return status;
  return 'inactive';
};

const mapPowerNode = (row: any) => ({
  id: row.id,
  type: row.node_type,
  name: row.name,
  status: mapPowerNodeStatus(row.status),
  load: row.load_w === null || row.load_w === undefined ? undefined : toNumber(row.load_w),
  capacity: row.capacity_w === null || row.capacity_w === undefined ? undefined : toNumber(row.capacity_w),
  datacenterId: row.datacenter_id,
});

const mapPowerLink = (row: any) => ({
  id: row.id,
  source: row.source_node_id,
  target: row.target_node_id,
  powerPath: row.power_path,
  status: mapPowerLinkStatus(row.status),
  datacenterId: row.datacenter_id,
});

const getPowerTopology = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const params: unknown[] = [];
  const nodeFilters: string[] = [];
  const linkFilters: string[] = ['valid_to is null'];

  if (req.query.datacenterId) {
    params.push(String(req.query.datacenterId));
    nodeFilters.push(`datacenter_id = $${params.length}`);
    linkFilters.push(`datacenter_id = $${params.length}`);
  }

  const nodeWhere = nodeFilters.length ? `where ${nodeFilters.join(' and ')}` : '';
  const linkWhere = linkFilters.length ? `where ${linkFilters.join(' and ')}` : '';

  const nodesResult = await queryDatabase<any>(
    req,
    'power.topology.nodes',
    `
      select id, datacenter_id, node_type, name, status, load_w, capacity_w
      from ${schemaName}.power_node
      ${nodeWhere}
      order by
        case node_type
          when 'utility' then 1
          when 'ups' then 2
          when 'pdu' then 3
          when 'device' then 4
          else 5
        end,
        id
    `,
    params,
  );

  const linksResult = await queryDatabase<any>(
    req,
    'power.topology.links',
    `
      select id, datacenter_id, source_node_id, target_node_id, power_path, status
      from ${schemaName}.power_connection
      ${linkWhere}
      order by id
    `,
    params,
  );

  return {
    nodes: nodesResult.rows.map(mapPowerNode),
    links: linksResult.rows.map(mapPowerLink),
  };
};

const getPowerRedundancy = async (req: Request, schema: string) => {
  const topology = await getPowerTopology(req, schema);
  const deviceNodes = topology.nodes.filter((node) => node.type === 'device');
  const activeLinks = topology.links.filter((link) => link.status === 'active');
  const devicePowerPaths = new Map<string, Set<string>>();

  activeLinks.forEach((link) => {
    if (!deviceNodes.some((node) => node.id === link.target)) return;
    if (!devicePowerPaths.has(link.target)) devicePowerPaths.set(link.target, new Set());
    devicePowerPaths.get(link.target)?.add(link.powerPath);
  });

  const dualPower: Array<any> = [];
  const singlePower: Array<any> = [];

  devicePowerPaths.forEach((paths, deviceId) => {
    const device = deviceNodes.find((node) => node.id === deviceId);
    if (!device) return;

    const powerPaths = Array.from(paths).sort();
    if (paths.size >= 2) {
      dualPower.push({ ...device, powerPaths });
      return;
    }

    singlePower.push({
      ...device,
      powerPaths,
      risk: 'single-point-failure',
    });
  });

  const totalDevices = devicePowerPaths.size;
  const dualPowerCount = dualPower.length;
  const singlePowerCount = singlePower.length;

  return {
    dualPower,
    singlePower,
    summary: {
      totalDevices,
      dualPowerCount,
      singlePowerCount,
      redundancyRate: totalDevices > 0 ? `${((dualPowerCount / totalDevices) * 100).toFixed(2)}%` : '0%',
    },
  };
};

const getPowerLoadBalance = async (req: Request, schema: string) => {
  const topology = await getPowerTopology(req, schema);
  const nodesById = new Map(topology.nodes.map((node) => [node.id, node]));
  const activeLinks = topology.links.filter((link) => link.status === 'active');

  const loadByPath = (powerPath: string) =>
    activeLinks
      .filter((link) => link.powerPath === powerPath)
      .reduce((sum, link) => sum + toNumber(nodesById.get(link.target)?.load), 0);

  const pathALoad = loadByPath('A');
  const pathBLoad = loadByPath('B');
  const totalLoad = pathALoad + pathBLoad;
  const balanceRate = totalLoad > 0 ? (Math.abs(pathALoad - pathBLoad) / totalLoad) * 100 : 0;

  return {
    pathA: {
      load: pathALoad,
      percentage: totalLoad > 0 ? `${((pathALoad / totalLoad) * 100).toFixed(2)}%` : '0%',
    },
    pathB: {
      load: pathBLoad,
      percentage: totalLoad > 0 ? `${((pathBLoad / totalLoad) * 100).toFixed(2)}%` : '0%',
    },
    totalLoad,
    balanceRate: `${balanceRate.toFixed(2)}%`,
    status: balanceRate < 10 ? 'balanced' : balanceRate < 20 ? 'warning' : 'unbalanced',
  };
};

const getNetworkTopology = async (req: Request, schema: string, datacenterId: string) => {
  const schemaName = quoteIdentifier(schema);
  const nodesResult = await queryDatabase<any>(
    req,
    'network.topology.nodes',
    `
      select distinct
        d.id,
        d.name,
        d.operational_status,
        dt.category,
        row_number() over (order by dt.category, d.id) as rn
      from ${schemaName}.device d
      join ${schemaName}.device_template dt on dt.id = d.template_id
      join ${schemaName}.rack_installation ri
        on ri.device_id = d.id
        and ri.asset_type = 'device'
        and ri.valid_to is null
      join ${schemaName}.cabinet c on c.id = ri.cabinet_id
      where c.datacenter_id = $1
      order by dt.category, d.id
    `,
    [datacenterId],
  );

  const edgesResult = await queryDatabase<any>(
    req,
    'network.topology.edges',
    `
      with scoped_edges as (
        select
          cc.source_device_id,
          cc.target_device_id,
          cc.connection_type
        from ${schemaName}.cable_connection cc
        join ${schemaName}.rack_installation sri
          on sri.device_id = cc.source_device_id
          and sri.asset_type = 'device'
          and sri.valid_to is null
        join ${schemaName}.cabinet sc on sc.id = sri.cabinet_id
        left join ${schemaName}.rack_installation tri
          on tri.device_id = cc.target_device_id
          and tri.asset_type = 'device'
          and tri.valid_to is null
        left join ${schemaName}.cabinet tc on tc.id = tri.cabinet_id
        where sc.datacenter_id = $1 or tc.datacenter_id = $1
      )
      select
        source_device_id,
        target_device_id,
        (array_agg(
          connection_type
          order by case connection_type
            when 'network' then 1
            when 'management' then 2
            when 'storage' then 3
            when 'stack' then 4
            when 'power' then 5
            else 6
          end,
          connection_type
        ))[1] as connection_type
      from scoped_edges
      group by source_device_id, target_device_id
      order by source_device_id, target_device_id
    `,
    [datacenterId],
  );

  return {
    datacenterId,
    nodes: nodesResult.rows.map((row) => ({
      id: row.id,
      label: row.name,
      type: row.category || 'other',
      status: mapPowerNodeStatus(row.operational_status),
      x: 120 + ((toNumber(row.rn) - 1) % 5) * 180,
      y: 100 + Math.floor((toNumber(row.rn) - 1) / 5) * 150,
    })),
    edges: edgesResult.rows.map((row) => ({
      source: row.source_device_id,
      target: row.target_device_id,
      type: row.connection_type,
    })),
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

  'GET /api/idc/device-templates': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await getDeviceTemplates(req, schema);
      logDataCount(req, 'device_template.list', result.data);
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

  'GET /api/idc/device-templates/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getDeviceTemplate(req, schema, firstParam(req.params.id));
      logDataCount(req, 'device_template.detail', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '设备模板不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/device-templates': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await createDeviceTemplate(req, schema);
      logDataCount(req, 'device_template.create', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/idc/device-templates/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await updateDeviceTemplate(req, schema, firstParam(req.params.id));
      logDataCount(req, 'device_template.update', result.data);
      if (!result.data) {
        res.status(result.status).json({ success: false, errorMessage: result.errorMessage });
        return;
      }
      res.json({ success: true, data: result.data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/idc/device-templates/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await deleteDeviceTemplate(req, schema, firstParam(req.params.id));
      logDataCount(req, 'device_template.delete', result.deleted ? result : null);
      if (!result.deleted) {
        res.status(result.status).json({ success: false, errorMessage: result.errorMessage });
        return;
      }
      res.json({ success: true });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/device-categories': (req: Request, res: Response) => {
    const data = getDeviceCategories();
    logDataCount(req, 'device_template.categories', data);
    res.json({ success: true, data });
  },

  'GET /api/idc/device-brands': (req: Request, res: Response) =>
    withSchema(req, res, 'device_template.brands', (schema) => getDeviceBrands(req, schema)),

  'POST /api/idc/devices/validate-mount': (req: Request, res: Response) =>
    withSchema(req, res, 'device.validate_mount', (schema) => validateDeviceMount(req, schema)),

  'POST /api/idc/devices/batch-status': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const count = await batchUpdateDeviceStatus(req, schema);
      logRequestStep(req, 'db:data', `device.batch_status count=${count}`);
      res.json({ success: true });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/devices/stats': (req: Request, res: Response) =>
    withSchema(req, res, 'device.stats', (schema) => getDeviceStats(req, schema)),

  'GET /api/idc/devices': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await getDevices(req, schema);
      logDataCount(req, 'device.list', result.data);
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

  'GET /api/idc/devices/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getDevice(req, schema, firstParam(req.params.id));
      logDataCount(req, 'device.detail', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '设备不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/devices': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await createDevice(req, schema);
      logDataCount(req, 'device.create', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/idc/devices/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await updateDevice(req, schema, firstParam(req.params.id));
      logDataCount(req, 'device.update', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '设备不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/idc/devices/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const deleted = await deleteDevice(req, schema, firstParam(req.params.id));
      logRequestStep(req, 'db:data', `device.delete count=${deleted ? 1 : 0}`);
      if (!deleted) {
        res.status(404).json({ success: false, errorMessage: '设备不存在' });
        return;
      }
      res.json({ success: true });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/devices/:id/unmount': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await unmountDevice(req, schema, firstParam(req.params.id));
      logDataCount(req, 'device.unmount', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '设备不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/cabinets': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await getCabinets(req, schema);
      logDataCount(req, 'cabinet.list', result.data);
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

  'POST /api/idc/cabinets': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await createCabinet(req, schema);
      logDataCount(req, 'cabinet.create', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/idc/cabinets/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await updateCabinet(req, schema, firstParam(req.params.id));
      logDataCount(req, 'cabinet.update', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '机柜不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/idc/cabinets/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await deleteCabinet(req, schema, firstParam(req.params.id));
      logDataCount(req, 'cabinet.delete', result.deleted ? result : null);
      if (!result.deleted) {
        res.status(result.status).json({ success: false, errorMessage: result.errorMessage });
        return;
      }
      res.json({ success: true });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/cabinets/:id/u-usage': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getCabinetUUsage(req, schema, firstParam(req.params.id));
      logDataCount(req, 'cabinet.u_usage', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '机柜不存在' });
        return;
      }
      res.json({ success: true, data });
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

  'GET /api/idc/ports/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getPort(req, schema, firstParam(req.params.id));
      logDataCount(req, 'port.detail', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '端口不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/idc/ports/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await updatePort(req, schema, firstParam(req.params.id));
      logDataCount(req, 'port.update', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '端口不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/ports/batch-vlan': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await batchUpdatePortVlan(req, schema);
      logDataCount(req, 'port.batch_vlan', data);
      res.json({ success: true, data, message: `成功更新 ${data.length} 个端口的VLAN配置` });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/ports/batch-status': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const count = await batchUpdatePortStatus(req, schema);
      logRequestStep(req, 'db:data', `port.batch_status count=${count}`);
      res.json({ success: true, message: `成功更新 ${count} 个端口的状态` });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/ports/stats/:deviceId': (req: Request, res: Response) =>
    withSchema(req, res, 'port.stats', (schema) => getPortStats(req, schema, firstParam(req.params.deviceId))),

  'GET /api/idc/port-types': (req: Request, res: Response) => {
    const data = getPortTypes();
    logDataCount(req, 'port.types', data);
    res.json({ success: true, data });
  },

  'GET /api/idc/port-speeds': (req: Request, res: Response) => {
    const data = getPortSpeeds();
    logDataCount(req, 'port.speeds', data);
    res.json({ success: true, data });
  },

  'GET /api/idc/vlan-modes': (req: Request, res: Response) => {
    const data = getVlanModes();
    logDataCount(req, 'port.vlan_modes', data);
    res.json({ success: true, data });
  },

  'GET /api/idc/connections': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const result = await getConnections(req, schema);
      logDataCount(req, 'connection.list', result.data);
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

  'GET /api/idc/connections/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getConnection(req, schema, firstParam(req.params.id));
      logDataCount(req, 'connection.detail', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '连线不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/connections': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await createConnection(req, schema);
      logDataCount(req, 'connection.create', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/idc/connections/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await updateConnection(req, schema, firstParam(req.params.id));
      logDataCount(req, 'connection.update', data);
      if (!data) {
        res.status(404).json({ success: false, errorMessage: '连线不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/idc/connections/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const deleted = await deleteConnection(req, schema, firstParam(req.params.id));
      logRequestStep(req, 'db:data', `connection.delete count=${deleted ? 1 : 0}`);
      if (!deleted) {
        res.status(404).json({ success: false, errorMessage: '连线不存在' });
        return;
      }
      res.json({ success: true });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/idc/connections/by-device/:deviceId': (req: Request, res: Response) =>
    withSchema(req, res, 'connection.by_device', (schema) =>
      getConnectionsByDevice(req, schema, firstParam(req.params.deviceId)),
    ),

  'GET /api/idc/connection-types': (req: Request, res: Response) => {
    const data = getConnectionTypes();
    logDataCount(req, 'connection.types', data);
    res.json({ success: true, data });
  },

  'GET /api/idc/cable-types': (req: Request, res: Response) => {
    const data = getCableTypes();
    logDataCount(req, 'connection.cable_types', data);
    res.json({ success: true, data });
  },

  'GET /api/idc/connections/stats': (req: Request, res: Response) =>
    withSchema(req, res, 'connection.stats', (schema) => getConnectionStats(req, schema)),

  'GET /api/idc/connections/by-datacenter/:datacenterId': (req: Request, res: Response) =>
    withSchema(req, res, '3d.connections.by_datacenter', (schema) =>
      getConnectionsByDatacenter(req, schema, firstParam(req.params.datacenterId)),
    ),

  'GET /api/idc/datacenters/:id/layout': (req: Request, res: Response) =>
    withSchema(req, res, '3d.layout', (schema) => getDatacenterLayout(req, schema, firstParam(req.params.id))),

  'PUT /api/idc/datacenters/:id/layout': (req: Request, res: Response) =>
    withSchema(req, res, '3d.layout.save', (schema) =>
      saveDatacenterLayout(req, schema, firstParam(req.params.id)),
    ),

  'GET /api/idc/environment/cabinets': (req: Request, res: Response) =>
    withSchema(req, res, '3d.cabinet_environment', (schema) => getCabinetEnvironments(req, schema)),

  'GET /api/pdu/devices': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getPduDevices(req, schema);
      logDataCount(req, 'pdu.devices.list', data);
      res.json({ success: true, data, total: data.length });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/pdu/devices/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getPduDevice(req, schema, firstParam(req.params.id));
      logDataCount(req, 'pdu.devices.detail', data);
      if (!data) {
        res.status(404).json({ success: false, message: 'PDU设备不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/pdu/devices': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await createPduDevice(req, schema);
      logDataCount(req, 'pdu.devices.create', data);
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/pdu/devices/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await updatePduDevice(req, schema, firstParam(req.params.id));
      logDataCount(req, 'pdu.devices.update', data);
      if (!data) {
        res.status(404).json({ success: false, message: 'PDU设备不存在' });
        return;
      }
      res.json({ success: true, data });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/pdu/devices/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const deleted = await deletePduDevice(req, schema, firstParam(req.params.id));
      logRequestStep(req, 'db:data', `pdu.devices.delete count=${deleted ? 1 : 0}`);
      if (!deleted) {
        res.status(404).json({ success: false, message: 'PDU设备不存在' });
        return;
      }
      res.json({ success: true, message: 'PDU设备已删除' });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/pdu/templates': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getPduTemplates(req, schema);
      logDataCount(req, 'pdu.templates', data);
      res.json({ success: true, data, total: data.length });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/power/topology': (req: Request, res: Response) =>
    withSchema(req, res, 'power.topology', (schema) => getPowerTopology(req, schema)),

  'GET /api/power/redundancy': (req: Request, res: Response) =>
    withSchema(req, res, 'power.redundancy', (schema) => getPowerRedundancy(req, schema)),

  'GET /api/power/load-balance': (req: Request, res: Response) =>
    withSchema(req, res, 'power.load_balance', (schema) => getPowerLoadBalance(req, schema)),

  'GET /api/idc/topology/:datacenterId': (req: Request, res: Response) =>
    withSchema(req, res, 'network.topology', (schema) =>
      getNetworkTopology(req, schema, firstParam(req.params.datacenterId)),
    ),
};
