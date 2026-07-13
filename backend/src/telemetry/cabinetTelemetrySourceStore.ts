import { getApiDataSource, getDatabaseSchema, getPool, quoteIdentifier } from '../db';

export interface PersistedCabinetTelemetrySource {
  id: string;
  cabinetId: string;
  host: string;
  port: number;
  unitId: number;
  timeoutMs: number;
  enabled: boolean;
}

type SourceRow = {
  source_id: string;
  cabinet_id: string;
  host: string;
  port: number;
  unit_id: number;
  timeout_ms: number;
  enabled: boolean;
};

const mockSources = new Map<string, PersistedCabinetTelemetrySource>();

const mapRow = (row: SourceRow): PersistedCabinetTelemetrySource => ({
  id: row.source_id,
  cabinetId: row.cabinet_id,
  host: row.host,
  port: Number(row.port),
  unitId: Number(row.unit_id),
  timeoutMs: Number(row.timeout_ms),
  enabled: row.enabled,
});

const ensureTable = async () => {
  const schemaName = quoteIdentifier(getDatabaseSchema());
  await getPool().query(`
    create table if not exists ${schemaName}.cabinet_telemetry_source (
      cabinet_id text primary key references ${schemaName}.cabinet(id) on delete cascade,
      source_id text not null unique,
      host text not null,
      port integer not null check (port between 1 and 65535),
      unit_id integer not null check (unit_id between 0 and 255),
      timeout_ms integer not null check (timeout_ms >= 100),
      enabled boolean not null default true,
      created_at timestamptz not null default now(),
      updated_at timestamptz not null default now()
    )
  `);
};

const initializeMockSources = (bootstrapSources: PersistedCabinetTelemetrySource[]) => {
  for (const source of bootstrapSources) {
    if (!mockSources.has(source.cabinetId)) mockSources.set(source.cabinetId, source);
  }
};

export const listCabinetTelemetrySources = async (
  bootstrapSources: PersistedCabinetTelemetrySource[] = [],
) => {
  if (getApiDataSource() !== 'database') {
    initializeMockSources(bootstrapSources);
    return [...mockSources.values()];
  }

  await ensureTable();
  const schemaName = quoteIdentifier(getDatabaseSchema());
  for (const source of bootstrapSources) {
    await getPool().query(
      `
        insert into ${schemaName}.cabinet_telemetry_source (
          cabinet_id, source_id, host, port, unit_id, timeout_ms, enabled
        ) values ($1, $2, $3, $4, $5, $6, $7)
        on conflict (cabinet_id) do nothing
      `,
      [
        source.cabinetId,
        source.id,
        source.host,
        source.port,
        source.unitId,
        source.timeoutMs,
        source.enabled,
      ],
    );
  }
  const result = await getPool().query<SourceRow>(
    `select source_id, cabinet_id, host, port, unit_id, timeout_ms, enabled
     from ${schemaName}.cabinet_telemetry_source
     order by cabinet_id`,
  );
  return result.rows.map(mapRow);
};

export const getCabinetTelemetrySource = async (cabinetId: string) => {
  if (getApiDataSource() !== 'database') {
    initializeMockSources([]);
    return mockSources.get(cabinetId) || null;
  }

  await ensureTable();
  const schemaName = quoteIdentifier(getDatabaseSchema());
  const result = await getPool().query<SourceRow>(
    `select source_id, cabinet_id, host, port, unit_id, timeout_ms, enabled
     from ${schemaName}.cabinet_telemetry_source
     where cabinet_id = $1`,
    [cabinetId],
  );
  return result.rows[0] ? mapRow(result.rows[0]) : null;
};

export const getCabinetCode = async (cabinetId: string) => {
  if (getApiDataSource() !== 'database') {
    const { getCabinetSnapshots } = require('../../mock/cabinet.mock');
    const cabinet = (getCabinetSnapshots() as Array<{ id: string; code: string }>).find(
      (item) => item.id === cabinetId,
    );
    return cabinet?.code || null;
  }

  const schemaName = quoteIdentifier(getDatabaseSchema());
  const result = await getPool().query<{ code: string }>(
    `select code from ${schemaName}.cabinet where id = $1`,
    [cabinetId],
  );
  return result.rows[0]?.code || null;
};

export const saveCabinetTelemetrySource = async (
  source: PersistedCabinetTelemetrySource,
) => {
  if (getApiDataSource() !== 'database') {
    const { getCabinetSnapshots } = require('../../mock/cabinet.mock');
    const cabinetExists = (getCabinetSnapshots() as Array<{ id: string }>).some(
      (cabinet) => cabinet.id === source.cabinetId,
    );
    if (!cabinetExists) throw new Error(`Registered cabinet not found: ${source.cabinetId}`);
    initializeMockSources([]);
    const duplicateSource = [...mockSources.values()].find(
      (item) => item.id === source.id && item.cabinetId !== source.cabinetId,
    );
    if (duplicateSource) throw new Error(`Duplicate telemetry source id: ${source.id}`);
    mockSources.set(source.cabinetId, source);
    return source;
  }

  await ensureTable();
  const schemaName = quoteIdentifier(getDatabaseSchema());
  const result = await getPool().query<SourceRow>(
    `
      insert into ${schemaName}.cabinet_telemetry_source (
        cabinet_id, source_id, host, port, unit_id, timeout_ms, enabled
      ) values ($1, $2, $3, $4, $5, $6, $7)
      on conflict (cabinet_id) do update set
        source_id = excluded.source_id,
        host = excluded.host,
        port = excluded.port,
        unit_id = excluded.unit_id,
        timeout_ms = excluded.timeout_ms,
        enabled = excluded.enabled,
        updated_at = now()
      returning source_id, cabinet_id, host, port, unit_id, timeout_ms, enabled
    `,
    [
      source.cabinetId,
      source.id,
      source.host,
      source.port,
      source.unitId,
      source.timeoutMs,
      source.enabled,
    ],
  );
  return mapRow(result.rows[0]);
};

export const deleteCabinetTelemetrySource = async (cabinetId: string) => {
  if (getApiDataSource() !== 'database') {
    initializeMockSources([]);
    return mockSources.delete(cabinetId);
  }

  await ensureTable();
  const schemaName = quoteIdentifier(getDatabaseSchema());
  const result = await getPool().query<{ cabinet_id: string }>(
    `delete from ${schemaName}.cabinet_telemetry_source
     where cabinet_id = $1
     returning cabinet_id`,
    [cabinetId],
  );
  return result.rows.length > 0;
};
