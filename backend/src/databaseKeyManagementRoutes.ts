import crypto from 'node:crypto';
import type { Request, Response } from 'express';
import { utils as sshUtils } from 'ssh2';
import { requireKeyManagementAccess } from './databaseAuthRoutes';
import { getDatabaseSchema, queryDatabase, quoteIdentifier } from './db';

type KeyType = 'RSA' | 'ED25519' | 'ECDSA' | 'OTHER';
type GeneratedKeyType = Exclude<KeyType, 'OTHER'>;

type ManagedKeyRow = {
  id: string;
  label: string;
  key_type: KeyType;
  public_key: string | null;
  certificate: string | null;
  description: string | null;
  encrypted_private_key: string;
  private_key_iv: string;
  private_key_tag: string;
  created_by: string;
  updated_by: string;
  created_at: string;
  updated_at: string;
};

const isoExpr = (column: string) =>
  `to_char(${column} at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')`;

const routeParam = (value: unknown) =>
  Array.isArray(value) ? String(value[0] || '') : String(value || '');

const encryptionKey = () => {
  const secret = String(process.env.KEY_MANAGEMENT_SECRET || '');
  if (secret.length < 32) {
    throw new Error('KEY_MANAGEMENT_SECRET must contain at least 32 characters');
  }
  return crypto.createHash('sha256').update(secret).digest();
};

const encryptPrivateKey = (privateKey: string) => {
  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv('aes-256-gcm', encryptionKey(), iv);
  const encrypted = Buffer.concat([
    cipher.update(privateKey, 'utf8'),
    cipher.final(),
  ]);
  return {
    encryptedPrivateKey: encrypted.toString('base64'),
    privateKeyIv: iv.toString('base64'),
    privateKeyTag: cipher.getAuthTag().toString('base64'),
  };
};

const decryptPrivateKey = (row: ManagedKeyRow) => {
  const decipher = crypto.createDecipheriv(
    'aes-256-gcm',
    encryptionKey(),
    Buffer.from(row.private_key_iv, 'base64'),
  );
  decipher.setAuthTag(Buffer.from(row.private_key_tag, 'base64'));
  return Buffer.concat([
    decipher.update(Buffer.from(row.encrypted_private_key, 'base64')),
    decipher.final(),
  ]).toString('utf8');
};

const mapKey = (row: ManagedKeyRow, includePrivateKey = false) => ({
  id: row.id,
  label: row.label,
  keyType: row.key_type,
  publicKey: row.public_key || undefined,
  certificate: row.certificate || undefined,
  description: row.description || undefined,
  hasPrivateKey: Boolean(row.encrypted_private_key),
  createdBy: row.created_by,
  updatedBy: row.updated_by,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
  ...(includePrivateKey ? { privateKey: decryptPrivateKey(row) } : {}),
});

export const ensureKeyTable = async (req: Request, schema: string) => {
  await queryDatabase(
    req,
    'keyManagement.ensureTable',
    `
      create table if not exists ${quoteIdentifier(schema)}.managed_ssh_key (
        id text primary key,
        label text not null,
        key_type text not null check (key_type in ('RSA', 'ED25519', 'ECDSA', 'OTHER')),
        public_key text,
        certificate text,
        description text,
        encrypted_private_key text not null,
        private_key_iv text not null,
        private_key_tag text not null,
        created_by text not null,
        updated_by text not null,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      )
    `,
  );
};

export const getManagedKeyForSsh = async (
  req: Request,
  schema: string,
  id: string,
) => {
  await ensureKeyTable(req, schema);
  const result = await queryDatabase<ManagedKeyRow>(
    req,
    'keyManagement.forSsh',
    selectKeySql(schema, 'where id = $1'),
    [id],
  );
  const row = result.rows[0];
  if (!row) return null;
  return {
    id: row.id,
    label: row.label,
    keyType: row.key_type,
    privateKey: decryptPrivateKey(row),
  };
};

const selectKeySql = (schema: string, whereClause = '') => `
  select
    id,
    label,
    key_type,
    public_key,
    certificate,
    description,
    encrypted_private_key,
    private_key_iv,
    private_key_tag,
    created_by,
    updated_by,
    ${isoExpr('created_at')} as created_at,
    ${isoExpr('updated_at')} as updated_at
  from ${quoteIdentifier(schema)}.managed_ssh_key
  ${whereClause}
`;

const returningKeySql = `
  id,
  label,
  key_type,
  public_key,
  certificate,
  description,
  encrypted_private_key,
  private_key_iv,
  private_key_tag,
  created_by,
  updated_by,
  ${isoExpr('created_at')} as created_at,
  ${isoExpr('updated_at')} as updated_at
`;

export const generateSshKeyPair = (
  keyType: GeneratedKeyType,
  passphrase?: string,
) => {
  const encryption = passphrase
    ? { passphrase, cipher: 'aes256-ctr', rounds: 16 }
    : {};
  const pair =
    keyType === 'RSA'
      ? sshUtils.generateKeyPairSync('rsa', { bits: 4096, ...encryption })
      : keyType === 'ECDSA'
        ? sshUtils.generateKeyPairSync('ecdsa', { bits: 256, ...encryption })
        : passphrase
          ? sshUtils.generateKeyPairSync('ed25519', {
              passphrase,
              cipher: 'aes256-ctr',
              rounds: 16,
            })
          : sshUtils.generateKeyPairSync('ed25519');

  return {
    privateKey: pair.private,
    publicKey: pair.public,
  };
};

const validatePayload = (body: Record<string, unknown>, requirePrivateKey: boolean) => {
  const label = String(body.label || '').trim();
  const privateKey = String(body.privateKey || '').trim();
  const keyType = String(body.keyType || 'OTHER').toUpperCase();
  if (!label) return '密钥名称不能为空。';
  if (label.length > 100) return '密钥名称不能超过 100 个字符。';
  if (requirePrivateKey && !privateKey) return '私钥不能为空。';
  if (privateKey && !privateKey.includes('PRIVATE KEY')) return '私钥格式不正确。';
  if (!['RSA', 'ED25519', 'ECDSA', 'OTHER'].includes(keyType)) return '密钥类型不正确。';
  return null;
};

const validateGeneratePayload = (body: Record<string, unknown>) => {
  const label = String(body.label || '').trim();
  const keyType = String(body.keyType || '').toUpperCase();
  const passphrase = String(body.passphrase || '');
  if (!label) return '密钥名称不能为空。';
  if (label.length > 100) return '密钥名称不能超过 100 个字符。';
  if (!['RSA', 'ED25519', 'ECDSA'].includes(keyType)) return '密钥类型不正确。';
  if (passphrase && passphrase.length < 8) return '私钥口令至少需要 8 个字符。';
  return null;
};

const insertManagedKey = async (
  req: Request,
  schema: string,
  userId: string,
  body: {
    label: string;
    keyType: KeyType;
    privateKey: string;
    publicKey?: string;
    certificate?: string;
    description?: string;
  },
) => {
  const encrypted = encryptPrivateKey(body.privateKey.trim());
  const id = `key_${crypto.randomUUID()}`;
  const result = await queryDatabase<ManagedKeyRow>(
    req,
    'keyManagement.create',
    `
      insert into ${quoteIdentifier(schema)}.managed_ssh_key (
        id, label, key_type, public_key, certificate, description,
        encrypted_private_key, private_key_iv, private_key_tag, created_by, updated_by
      )
      values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $10)
      returning ${returningKeySql}
    `,
    [
      id,
      body.label.trim(),
      body.keyType,
      body.publicKey?.trim() || null,
      body.certificate?.trim() || null,
      body.description?.trim() || null,
      encrypted.encryptedPrivateKey,
      encrypted.privateKeyIv,
      encrypted.privateKeyTag,
      userId,
    ],
  );
  return result.rows[0];
};

const handleError = (res: Response, error: unknown) => {
  res.status(500).send({
    success: false,
    errorMessage:
      error instanceof Error ? error.message : 'Database key management route failed',
  });
};

export default {
  'GET /api/key-management/keys': async (req: Request, res: Response) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const schema = getDatabaseSchema();
      await ensureKeyTable(req, schema);
      const keyword = String(req.query.keyword || '').trim();
      const params: unknown[] = [];
      let whereClause = '';
      if (keyword) {
        params.push(`%${keyword}%`);
        whereClause = 'where label ilike $1 or description ilike $1';
      }
      const result = await queryDatabase<ManagedKeyRow>(
        req,
        'keyManagement.list',
        `${selectKeySql(schema, whereClause)} order by updated_at desc, id`,
        params,
      );
      res.send({ success: true, data: result.rows.map((row) => mapKey(row)) });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/key-management/keys/:id': async (req: Request, res: Response) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const schema = getDatabaseSchema();
      await ensureKeyTable(req, schema);
      const result = await queryDatabase<ManagedKeyRow>(
        req,
        'keyManagement.detail',
        selectKeySql(schema, 'where id = $1'),
        [routeParam(req.params.id)],
      );
      if (!result.rows[0]) {
        res.status(404).send({ success: false, errorMessage: '密钥不存在。' });
        return;
      }
      res.send({ success: true, data: mapKey(result.rows[0], true) });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/key-management/keys': async (req: Request, res: Response) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const body = req.body || {};
      const validationError = validatePayload(body, true);
      if (validationError) {
        res.status(400).send({ success: false, errorMessage: validationError });
        return;
      }
      const schema = getDatabaseSchema();
      await ensureKeyTable(req, schema);
      const created = await insertManagedKey(req, schema, user.id, {
        label: String(body.label),
        keyType: String(body.keyType || 'OTHER').toUpperCase() as KeyType,
        privateKey: String(body.privateKey),
        publicKey: String(body.publicKey || ''),
        certificate: String(body.certificate || ''),
        description: String(body.description || ''),
      });
      res.status(201).send({ success: true, data: mapKey(created) });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/key-management/keys/generate': async (req: Request, res: Response) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const body = req.body || {};
      const validationError = validateGeneratePayload(body);
      if (validationError) {
        res.status(400).send({ success: false, errorMessage: validationError });
        return;
      }

      const keyType = String(body.keyType).toUpperCase() as GeneratedKeyType;
      const generated = generateSshKeyPair(
        keyType,
        String(body.passphrase || '') || undefined,
      );
      const schema = getDatabaseSchema();
      await ensureKeyTable(req, schema);
      const created = await insertManagedKey(req, schema, user.id, {
        label: String(body.label),
        keyType,
        privateKey: generated.privateKey,
        publicKey: generated.publicKey,
        description: `系统生成的 ${keyType} SSH 密钥`,
      });
      res.status(201).send({ success: true, data: mapKey(created) });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/key-management/keys/:id': async (req: Request, res: Response) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const body = req.body || {};
      const validationError = validatePayload(body, false);
      if (validationError) {
        res.status(400).send({ success: false, errorMessage: validationError });
        return;
      }
      const schema = getDatabaseSchema();
      await ensureKeyTable(req, schema);
      const existing = await queryDatabase<ManagedKeyRow>(
        req,
        'keyManagement.detailForUpdate',
        selectKeySql(schema, 'where id = $1'),
        [routeParam(req.params.id)],
      );
      if (!existing.rows[0]) {
        res.status(404).send({ success: false, errorMessage: '密钥不存在。' });
        return;
      }
      const encrypted = body.privateKey
        ? encryptPrivateKey(String(body.privateKey).trim())
        : {
            encryptedPrivateKey: existing.rows[0].encrypted_private_key,
            privateKeyIv: existing.rows[0].private_key_iv,
            privateKeyTag: existing.rows[0].private_key_tag,
          };
      const result = await queryDatabase<ManagedKeyRow>(
        req,
        'keyManagement.update',
        `
          update ${quoteIdentifier(schema)}.managed_ssh_key
          set label = $2,
              key_type = $3,
              public_key = $4,
              certificate = $5,
              description = $6,
              encrypted_private_key = $7,
              private_key_iv = $8,
              private_key_tag = $9,
              updated_by = $10,
              updated_at = now()
          where id = $1
          returning ${returningKeySql}
        `,
        [
          routeParam(req.params.id),
          String(body.label).trim(),
          String(body.keyType || existing.rows[0].key_type).toUpperCase(),
          String(body.publicKey || '').trim() || null,
          String(body.certificate || '').trim() || null,
          String(body.description || '').trim() || null,
          encrypted.encryptedPrivateKey,
          encrypted.privateKeyIv,
          encrypted.privateKeyTag,
          user.id,
        ],
      );
      res.send({ success: true, data: mapKey(result.rows[0]) });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/key-management/keys/:id': async (req: Request, res: Response) => {
    try {
      const user = await requireKeyManagementAccess(req, res);
      if (!user) return;
      const schema = getDatabaseSchema();
      await ensureKeyTable(req, schema);
      const result = await queryDatabase<{ id: string }>(
        req,
        'keyManagement.delete',
        `delete from ${quoteIdentifier(schema)}.managed_ssh_key where id = $1 returning id`,
        [routeParam(req.params.id)],
      );
      if (!result.rows[0]) {
        res.status(404).send({ success: false, errorMessage: '密钥不存在。' });
        return;
      }
      res.send({ success: true, data: {} });
    } catch (error) {
      handleError(res, error);
    }
  },
};
