import crypto from 'node:crypto';
import type { Request, Response } from 'express';
import { Client, type ConnectConfig, type NegotiatedAlgorithms } from 'ssh2';
import { requireKeyManagementAccess } from './databaseAuthRoutes';
import {
  ensureKeyTable,
  getManagedKeyForSsh,
} from './databaseKeyManagementRoutes';
import { getDatabaseSchema, queryDatabase, quoteIdentifier } from './db';

type DeviceRow = {
  id: string;
  name: string;
  management_ip: string | null;
};

type SshBindingRow = {
  device_id: string;
  key_id: string;
  key_label: string;
  key_type: string;
  username: string;
  port: number;
  updated_at: string;
};

type SshTestResult = {
  connected: boolean;
  stage: 'network' | 'handshake' | 'authentication' | 'ready';
  host: string;
  port: number;
  username: string;
  keyLabel: string;
  keyType: string;
  elapsedMs: number;
  testedAt: string;
  serverFingerprint?: string;
  algorithms?: {
    kex?: string;
    serverHostKey?: string;
    cipherClientToServer?: string;
    cipherServerToClient?: string;
  };
  banner?: string;
  errorCode?: string;
  errorMessage?: string;
};

const routeParam = (value: unknown) =>
  Array.isArray(value) ? String(value[0] || '') : String(value || '');

const isoExpr = (column: string) =>
  `to_char(${column} at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')`;

const ensureBindingTable = async (req: Request, schema: string) => {
  await ensureKeyTable(req, schema);
  const schemaName = quoteIdentifier(schema);
  await queryDatabase(
    req,
    'deviceSsh.ensureTable',
    `
      create table if not exists ${schemaName}.device_ssh_binding (
        device_id text primary key
          references ${schemaName}.device(id) on delete cascade,
        key_id text not null
          references ${schemaName}.managed_ssh_key(id) on delete cascade,
        username text not null,
        port integer not null default 22 check (port between 1 and 65535),
        updated_by text not null,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      )
    `,
  );
};

const getDevice = async (req: Request, schema: string, id: string) => {
  const result = await queryDatabase<DeviceRow>(
    req,
    'deviceSsh.device',
    `
      select id, name, host(management_ip) as management_ip
      from ${quoteIdentifier(schema)}.device
      where id = $1
    `,
    [id],
  );
  return result.rows[0] || null;
};

const getBinding = async (req: Request, schema: string, deviceId: string) => {
  const result = await queryDatabase<SshBindingRow>(
    req,
    'deviceSsh.binding',
    `
      select
        b.device_id,
        b.key_id,
        k.label as key_label,
        k.key_type,
        b.username,
        b.port,
        ${isoExpr('b.updated_at')} as updated_at
      from ${quoteIdentifier(schema)}.device_ssh_binding b
      join ${quoteIdentifier(schema)}.managed_ssh_key k on k.id = b.key_id
      where b.device_id = $1
    `,
    [deviceId],
  );
  const row = result.rows[0];
  return row
    ? {
        deviceId: row.device_id,
        keyId: row.key_id,
        keyLabel: row.key_label,
        keyType: row.key_type,
        username: row.username,
        port: row.port,
        updatedAt: row.updated_at,
      }
    : null;
};

const validateConnectionPayload = (body: Record<string, unknown>) => {
  const keyId = String(body.keyId || '').trim();
  const username = String(body.username || '').trim();
  const port = Number(body.port || 22);
  if (!keyId) return '请选择 SSH 密钥。';
  if (!username) return 'SSH 用户名不能为空。';
  if (!/^[a-zA-Z0-9._-]{1,64}$/.test(username)) return 'SSH 用户名格式不正确。';
  if (!Number.isInteger(port) || port < 1 || port > 65535) return 'SSH 端口不正确。';
  return null;
};

const fingerprint = (key: Buffer) =>
  `SHA256:${crypto.createHash('sha256').update(key).digest('base64').replace(/=+$/, '')}`;

const sanitizeHandshake = (info: NegotiatedAlgorithms) => ({
  kex: info.kex,
  serverHostKey: info.serverHostKey,
  cipherClientToServer: info.cs?.cipher,
  cipherServerToClient: info.sc?.cipher,
});

export const testSshConnection = (
  config: ConnectConfig,
  context: Pick<SshTestResult, 'host' | 'port' | 'username' | 'keyLabel' | 'keyType'>,
) =>
  new Promise<SshTestResult>((resolve) => {
    const client = new Client();
    const startedAt = Date.now();
    let stage: SshTestResult['stage'] = 'network';
    let settled = false;
    let serverFingerprint: string | undefined;
    let algorithms: SshTestResult['algorithms'];
    let banner: string | undefined;

    const finish = (
      connected: boolean,
      error?: Error & { code?: string; level?: string },
    ) => {
      if (settled) return;
      settled = true;
      client.end();
      resolve({
        connected,
        stage,
        ...context,
        elapsedMs: Date.now() - startedAt,
        testedAt: new Date().toISOString(),
        serverFingerprint,
        algorithms,
        banner,
        ...(error
          ? {
              errorCode: error.code || error.level || 'SSH_CONNECTION_FAILED',
              errorMessage: error.message,
            }
          : {}),
      });
    };

    client
      .on('handshake', (info) => {
        stage = 'handshake';
        algorithms = sanitizeHandshake(info);
      })
      .on('banner', (message) => {
        banner = message.trim().slice(0, 500);
      })
      .on('ready', () => {
        stage = 'ready';
        finish(true);
      })
      .on('error', (error) => {
        if (error.level === 'client-authentication') stage = 'authentication';
        finish(false, error);
      });

    try {
      client.connect({
        ...config,
        readyTimeout: 10_000,
        keepaliveInterval: 0,
        hostVerifier: (key: Buffer) => {
          serverFingerprint = fingerprint(key);
          return true;
        },
      });
    } catch (error) {
      stage = 'authentication';
      finish(false, error as Error & { code?: string; level?: string });
    }
  });

const handleError = (res: Response, error: unknown) => {
  res.status(500).send({
    success: false,
    errorMessage:
      error instanceof Error ? error.message : 'Device SSH route failed',
  });
};

export default {
  'GET /api/idc/devices/:id/ssh-binding': async (
    req: Request,
    res: Response,
  ) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const schema = getDatabaseSchema();
      await ensureBindingTable(req, schema);
      const device = await getDevice(req, schema, routeParam(req.params.id));
      if (!device) {
        res.status(404).send({ success: false, errorMessage: '设备不存在。' });
        return;
      }
      res.send({
        success: true,
        data: await getBinding(req, schema, device.id),
      });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/idc/devices/:id/ssh-binding': async (
    req: Request,
    res: Response,
  ) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const schema = getDatabaseSchema();
      await ensureBindingTable(req, schema);
      const deviceId = routeParam(req.params.id);
      const device = await getDevice(req, schema, deviceId);
      if (!device) {
        res.status(404).send({ success: false, errorMessage: '设备不存在。' });
        return;
      }

      const body = req.body || {};
      const keyId = String(body.keyId || '').trim();
      if (!keyId) {
        await queryDatabase(
          req,
          'deviceSsh.binding.delete',
          `delete from ${quoteIdentifier(schema)}.device_ssh_binding where device_id = $1`,
          [deviceId],
        );
        res.send({ success: true, data: null });
        return;
      }

      const validationError = validateConnectionPayload(body);
      if (validationError) {
        res.status(400).send({ success: false, errorMessage: validationError });
        return;
      }
      const key = await getManagedKeyForSsh(req, schema, keyId);
      if (!key) {
        res.status(404).send({ success: false, errorMessage: '密钥不存在。' });
        return;
      }
      await queryDatabase(
        req,
        'deviceSsh.binding.upsert',
        `
          insert into ${quoteIdentifier(schema)}.device_ssh_binding (
            device_id, key_id, username, port, updated_by
          )
          values ($1, $2, $3, $4, $5)
          on conflict (device_id) do update
          set key_id = excluded.key_id,
              username = excluded.username,
              port = excluded.port,
              updated_by = excluded.updated_by,
              updated_at = now()
        `,
        [
          deviceId,
          keyId,
          String(body.username).trim(),
          Number(body.port || 22),
          user.id,
        ],
      );
      res.send({
        success: true,
        data: await getBinding(req, schema, deviceId),
      });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/idc/devices/:id/test-ssh': async (
    req: Request,
    res: Response,
  ) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const schema = getDatabaseSchema();
      await ensureBindingTable(req, schema);
      const device = await getDevice(req, schema, routeParam(req.params.id));
      if (!device) {
        res.status(404).send({ success: false, errorMessage: '设备不存在。' });
        return;
      }
      if (!device.management_ip) {
        res.status(400).send({
          success: false,
          errorMessage: '设备尚未设置管理 IP。',
        });
        return;
      }

      const body = req.body || {};
      const validationError = validateConnectionPayload(body);
      if (validationError) {
        res.status(400).send({ success: false, errorMessage: validationError });
        return;
      }
      const key = await getManagedKeyForSsh(
        req,
        schema,
        String(body.keyId),
      );
      if (!key) {
        res.status(404).send({ success: false, errorMessage: '密钥不存在。' });
        return;
      }

      const port = Number(body.port || 22);
      const username = String(body.username).trim();
      const result = await testSshConnection(
        {
          host: device.management_ip,
          port,
          username,
          privateKey: key.privateKey,
          passphrase: String(body.passphrase || '') || undefined,
        },
        {
          host: device.management_ip,
          port,
          username,
          keyLabel: key.label,
          keyType: key.keyType,
        },
      );
      res.send({ success: true, data: result });
    } catch (error) {
      handleError(res, error);
    }
  },
};
