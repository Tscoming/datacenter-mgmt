import type { Request, Response } from 'express';
import { getDatabaseSchema, queryDatabase, quoteIdentifier } from './db';
import { logRequestStep } from './requestLogger';

type EnvironmentOverview = {
  totalCabinets: number;
  normalCabinets: number;
  warningCabinets: number;
  criticalCabinets: number;
  avgTemperature: number;
  avgHumidity: number;
  maxTemperature: number;
  maxTemperatureCabinet: string;
  minTemperature: number;
  totalPower: number;
  avgPue: number;
};

const toNumber = (value: unknown, fallback = 0) => {
  if (value === null || value === undefined) return fallback;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
};

const round = (value: unknown, digits: number) => {
  const factor = 10 ** digits;
  return Math.round(toNumber(value) * factor) / factor;
};

const toPositiveInt = (value: unknown, fallback: number) => {
  const parsed = Math.floor(toNumber(value, fallback));
  return parsed > 0 ? parsed : fallback;
};

const firstParam = (value: string | string[] | undefined) =>
  Array.isArray(value) ? value[0] : value || '';

const isoExpr = (column: string) =>
  `to_char(${column} at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')`;

const dateExpr = (column: string) => `to_char(${column}, 'YYYY-MM-DD')`;

const logDataCount = (req: Request, label: string, data: unknown) => {
  const count = Array.isArray(data) ? data.length : data ? 1 : 0;
  logRequestStep(req, 'db:data', `${label} count=${count}`);
};

const normalizeOverview = (value: any): EnvironmentOverview => ({
  totalCabinets: toNumber(value?.totalCabinets),
  normalCabinets: toNumber(value?.normalCabinets),
  warningCabinets: toNumber(value?.warningCabinets),
  criticalCabinets: toNumber(value?.criticalCabinets),
  avgTemperature: round(value?.avgTemperature, 1),
  avgHumidity: round(value?.avgHumidity, 1),
  maxTemperature: round(value?.maxTemperature, 1),
  maxTemperatureCabinet: value?.maxTemperatureCabinet || '',
  minTemperature: round(value?.minTemperature, 1),
  totalPower: round(value?.totalPower, 1),
  avgPue: round(value?.avgPue, 2),
});

const getSnapshotOverview = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{ payload: EnvironmentOverview }>(
    req,
    'environment_overview.snapshot',
    `
      select payload
      from ${schemaName}.dashboard_snapshot
      where snapshot_type = $1
      order by captured_at desc
      limit 1
    `,
    ['environment_overview'],
  );

  return result.rows[0]?.payload ? normalizeOverview(result.rows[0].payload) : null;
};

const getAggregatedOverview = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<{
    total_cabinets: string;
    normal_cabinets: string;
    warning_cabinets: string;
    critical_cabinets: string;
    avg_temperature: string | null;
    avg_humidity: string | null;
    max_temperature: string | null;
    max_temperature_cabinet: string | null;
    min_temperature: string | null;
    total_power: string | null;
    avg_pue: string | null;
  }>(
    req,
    'environment_overview.aggregate',
    `
    with cabinet_temperature as (
      select
        c.id,
        c.name,
        c.health_status,
        avg(o.value_num) filter (where o.metric = 'temperature') as avg_temperature,
        max(o.value_num) filter (where o.metric = 'temperature') as max_temperature,
        min(o.value_num) filter (where o.metric = 'temperature') as min_temperature,
        avg(o.value_num) filter (where o.metric = 'humidity') as avg_humidity
      from ${schemaName}.cabinet c
      left join ${schemaName}.observation o on o.target_type = 'cabinet' and o.target_id = c.id
      group by c.id, c.name, c.health_status
    ),
    hottest_cabinet as (
      select name, max_temperature
      from cabinet_temperature
      where max_temperature is not null
      order by max_temperature desc
      limit 1
    ),
    latest_pue_date as (
      select max(metric_date) as metric_date
      from ${schemaName}.pue_daily
    )
    select
      count(*)::int as total_cabinets,
      count(*) filter (where health_status = 'normal')::int as normal_cabinets,
      count(*) filter (where health_status = 'warning')::int as warning_cabinets,
      count(*) filter (where health_status in ('critical', 'error', 'faulty'))::int as critical_cabinets,
      avg(avg_temperature) as avg_temperature,
      avg(avg_humidity) as avg_humidity,
      max(max_temperature) as max_temperature,
      (select name from hottest_cabinet) as max_temperature_cabinet,
      min(min_temperature) as min_temperature,
      (select sum(current_load_w) / 1000.0 from ${schemaName}.pdu) as total_power,
      (
        select avg(p.pue)
        from ${schemaName}.pue_daily p
        join latest_pue_date d on p.metric_date = d.metric_date
      ) as avg_pue
    from cabinet_temperature
  `,
  );

  const row = result.rows[0];
  return normalizeOverview({
    totalCabinets: row?.total_cabinets,
    normalCabinets: row?.normal_cabinets,
    warningCabinets: row?.warning_cabinets,
    criticalCabinets: row?.critical_cabinets,
    avgTemperature: row?.avg_temperature,
    avgHumidity: row?.avg_humidity,
    maxTemperature: row?.max_temperature,
    maxTemperatureCabinet: row?.max_temperature_cabinet,
    minTemperature: row?.min_temperature,
    totalPower: row?.total_power,
    avgPue: row?.avg_pue,
  });
};

const getCabinetEnvironments = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'environment.cabinets',
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
    avgTemperature: round(row.avg_temperature, 1),
    maxTemperature: round(row.max_temperature, 1),
    minTemperature: round(row.min_temperature, 1),
    avgHumidity: round(row.avg_humidity, 1),
    status: row.status,
  }));
};

const getCabinetSensors = async (req: Request, schema: string, cabinetId: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'environment.cabinet_sensors',
    `
      with latest as (
        select distinct on (sensor_position, metric)
          sensor_id,
          sensor_position,
          metric,
          value_num,
          observed_at
        from ${schemaName}.observation
        where target_type = 'cabinet'
          and target_id = $1
          and metric in ('temperature', 'humidity')
        order by sensor_position, metric, observed_at desc
      ),
      positions as (
        select
          coalesce(sensor_position, 'front') as position,
          max(sensor_id) as sensor_id,
          max(value_num) filter (where metric = 'temperature') as temperature,
          max(value_num) filter (where metric = 'humidity') as humidity,
          max(observed_at) as last_updated
        from latest
        group by coalesce(sensor_position, 'front')
      )
      select
        p.position,
        p.sensor_id,
        p.temperature,
        p.humidity,
        ${isoExpr('p.last_updated')} as last_updated,
        c.name as cabinet_name
      from positions p
      join ${schemaName}.cabinet c on c.id = $1
      order by p.position
    `,
    [cabinetId],
  );

  return result.rows.map((row, index) => ({
    id: row.sensor_id || `sensor-${cabinetId}-${row.position || index}`,
    cabinetId,
    cabinetName: row.cabinet_name || undefined,
    position: row.position || 'front',
    temperature: round(row.temperature, 1),
    humidity: round(row.humidity, 1),
    lastUpdated: row.last_updated,
  }));
};

const getTemperatureTrend = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const hours = toPositiveInt(req.query.hours, 24);
  const result = await queryDatabase<any>(
    req,
    'environment.temperature_trend',
    `
      select
        date_trunc('hour', observed_at) as bucket,
        avg(value_num) as avg_temperature,
        max(value_num) as max_temperature,
        min(value_num) as min_temperature
      from ${schemaName}.observation
      where metric = 'temperature'
        and observed_at >= now() - ($1::int * interval '1 hour')
      group by date_trunc('hour', observed_at)
      order by bucket
    `,
    [hours],
  );

  return result.rows.map((row) => ({
    timestamp: new Date(row.bucket).toISOString(),
    avgTemperature: round(row.avg_temperature, 1),
    maxTemperature: round(row.max_temperature, 1),
    minTemperature: round(row.min_temperature, 1),
  }));
};

const getPueTrend = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const days = toPositiveInt(req.query.days, 30);
  const params: unknown[] = [days];
  const filters = [`p.metric_date >= current_date - ($1::int * interval '1 day')`];
  if (req.query.datacenterId) {
    params.push(String(req.query.datacenterId));
    filters.push(`p.datacenter_id = $${params.length}`);
  }

  const result = await queryDatabase<any>(
    req,
    'environment.pue_trend',
    `
      select
        p.datacenter_id,
        dc.name as datacenter_name,
        ${dateExpr('p.metric_date')} as metric_date,
        p.pue,
        p.it_power_kw,
        p.total_power_kw,
        p.cooling_power_kw
      from ${schemaName}.pue_daily p
      join ${schemaName}.datacenter dc on dc.id = p.datacenter_id
      where ${filters.join(' and ')}
      order by p.metric_date
    `,
    params,
  );

  return result.rows.map((row) => ({
    datacenterId: row.datacenter_id,
    datacenterName: row.datacenter_name,
    date: row.metric_date,
    pue: round(row.pue, 2),
    itPower: round(row.it_power_kw, 1),
    totalPower: round(row.total_power_kw, 1),
    coolingPower: round(row.cooling_power_kw, 1),
  }));
};

const getEnergyStats = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<any>(
    req,
    'environment.energy_stats',
    `
      with monthly as (
        select
          sum(total_power_kw * 24) filter (where metric_date >= date_trunc('month', current_date)) as current_energy,
          sum(total_power_kw * 24) filter (
            where metric_date >= date_trunc('month', current_date) - interval '1 month'
              and metric_date < date_trunc('month', current_date)
          ) as previous_energy,
          avg(pue) as avg_pue
        from ${schemaName}.pue_daily
      )
      select
        coalesce(current_energy, 0) as total_energy,
        coalesce(current_energy, 0) * 0.7 as total_cost,
        coalesce(avg_pue, 0) as avg_pue,
        coalesce(current_energy, 0) * 0.5 as carbon_emission,
        case
          when coalesce(previous_energy, 0) = 0 then 0
          else (coalesce(current_energy, 0) - previous_energy) / previous_energy * 100
        end as compared_last_month
      from monthly
    `,
  );
  const row = result.rows[0] || {};
  return {
    totalEnergy: round(row.total_energy, 1),
    totalCost: round(row.total_cost, 1),
    avgPue: round(row.avg_pue, 2),
    carbonEmission: round(row.carbon_emission, 1),
    comparedLastMonth: round(row.compared_last_month, 1),
  };
};

const getPowerConsumption = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  const params: unknown[] = [];
  const filters: string[] = [];
  if (req.query.cabinetId) {
    params.push(String(req.query.cabinetId));
    filters.push(`c.id = $${params.length}`);
  }
  const where = filters.length ? `where ${filters.join(' and ')}` : '';
  const result = await queryDatabase<any>(
    req,
    'environment.power',
    `
      select
        c.id as cabinet_id,
        regexp_replace(c.name, '机柜$', '') as cabinet_name,
        c.datacenter_id,
        dc.name as datacenter_name,
        coalesce(sum(p.current_load_w), 0) / 1000.0 as active_power,
        coalesce(sum(p.current_load_w), 0) / 950.0 as apparent_power,
        case when coalesce(sum(p.current_load_w), 0) = 0 then 0 else 0.95 end as power_factor,
        coalesce(sum(p.current_load_w), 0) * 24 / 1000.0 as energy,
        coalesce(sum(p.current_load_w), 0) / 220.0 as current_amp,
        220 as voltage,
        now() as captured_at
      from ${schemaName}.cabinet c
      join ${schemaName}.datacenter dc on dc.id = c.datacenter_id
      left join ${schemaName}.pdu p on p.cabinet_id = c.id
      ${where}
      group by c.id, dc.name
      order by c.datacenter_id, c.row_no, c.column_no
    `,
    params,
  );

  return result.rows.map((row) => ({
    id: `power-${row.cabinet_id}`,
    cabinetId: row.cabinet_id,
    cabinetName: row.cabinet_name,
    datacenterId: row.datacenter_id,
    datacenterName: row.datacenter_name,
    timestamp: new Date(row.captured_at).toISOString(),
    activePower: round(row.active_power, 2),
    apparentPower: round(row.apparent_power, 2),
    powerFactor: round(row.power_factor, 2),
    energy: round(row.energy, 1),
    current: round(row.current_amp, 1),
    voltage: round(row.voltage, 1),
  }));
};

export default {
  'GET /api/idc/environment/overview': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const snapshotOverview = await getSnapshotOverview(req, schema);
      logRequestStep(
        req,
        'db:source',
        snapshotOverview ? 'environment_overview.snapshot' : 'environment_overview.aggregate',
      );
      const overview = snapshotOverview || (await getAggregatedOverview(req, schema));
      res.json({ success: true, data: overview });
    } catch (error) {
      res.status(500).json({
        success: false,
        errorMessage: error instanceof Error ? error.message : 'Failed to query environment overview',
      });
    }
  },

  'GET /api/idc/environment/cabinets': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getCabinetEnvironments(req, schema);
      logDataCount(req, 'environment.cabinets', data);
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({ success: false, errorMessage: error instanceof Error ? error.message : 'Failed to query cabinet environments' });
    }
  },

  'GET /api/idc/environment/cabinet/:cabinetId': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getCabinetSensors(req, schema, firstParam(req.params.cabinetId));
      logDataCount(req, 'environment.cabinet_sensors', data);
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({ success: false, errorMessage: error instanceof Error ? error.message : 'Failed to query cabinet sensors' });
    }
  },

  'GET /api/idc/environment/temperature-trend': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getTemperatureTrend(req, schema);
      logDataCount(req, 'environment.temperature_trend', data);
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({ success: false, errorMessage: error instanceof Error ? error.message : 'Failed to query temperature trend' });
    }
  },

  'GET /api/idc/environment/pue-trend': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getPueTrend(req, schema);
      logDataCount(req, 'environment.pue_trend', data);
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({ success: false, errorMessage: error instanceof Error ? error.message : 'Failed to query PUE trend' });
    }
  },

  'GET /api/idc/environment/energy-stats': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getEnergyStats(req, schema);
      logDataCount(req, 'environment.energy_stats', data);
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({ success: false, errorMessage: error instanceof Error ? error.message : 'Failed to query energy stats' });
    }
  },

  'GET /api/idc/environment/power': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      logRequestStep(req, 'db:schema', schema);
      const data = await getPowerConsumption(req, schema);
      logDataCount(req, 'environment.power', data);
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({ success: false, errorMessage: error instanceof Error ? error.message : 'Failed to query power consumption' });
    }
  },
};
