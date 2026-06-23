import { loadEnv } from './env';
import type { Request } from 'express';
import { logRequestStep } from './requestLogger';

type QueryResult<T> = {
  rows: T[];
};

type PoolLike = {
  query<T>(sql: string, params?: unknown[]): Promise<QueryResult<T>>;
};

let pool: PoolLike | null = null;

export const getApiDataSource = () => {
  loadEnv();
  return process.env.API_DATA_SOURCE || 'mock';
};

export const getDatabaseSchema = () => {
  loadEnv();
  const schema = process.env.PGSCHEMA || 'public';
  if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(schema)) {
    throw new Error(`Invalid PGSCHEMA: ${schema}`);
  }
  return schema;
};

export const quoteIdentifier = (identifier: string) => `"${identifier.replace(/"/g, '""')}"`;

export const getPool = (): PoolLike => {
  loadEnv();
  if (pool) return pool;

  const { Pool } = require('pg');
  const nextPool = new Pool({
    host: process.env.PGHOST,
    port: process.env.PGPORT ? Number(process.env.PGPORT) : undefined,
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
  });

  pool = nextPool;
  return nextPool;
};

const normalizeSql = (sql: string) => sql.replace(/\s+/g, ' ').trim();

export const queryDatabase = async <T>(
  req: Request,
  label: string,
  sql: string,
  params?: unknown[],
) => {
  const pool = getPool();
  logRequestStep(
    req,
    'db:query',
    `${label} sql=${normalizeSql(sql)}${params?.length ? ` params=${JSON.stringify(params)}` : ''}`,
  );

  const result = await pool.query<T>(sql, params);
  logRequestStep(req, 'db:result', `${label} rows=${result.rows.length}`);
  return result;
};
