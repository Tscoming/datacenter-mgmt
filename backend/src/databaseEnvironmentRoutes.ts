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
};
