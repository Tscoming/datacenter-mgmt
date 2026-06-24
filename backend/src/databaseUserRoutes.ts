import crypto from 'node:crypto';
import type { Request, Response } from 'express';
import { getDatabaseSchema, queryDatabase, quoteIdentifier } from './db';
import { logRequestStep } from './requestLogger';

type UserRole = 'admin' | 'user';
type UserStatus = 'active' | 'disabled';

type UserRow = {
  id: string;
  username: string;
  name: string;
  email: string;
  phone: string | null;
  role: UserRole;
  status: UserStatus;
  avatar: string | null;
  title: string | null;
  department: string | null;
  created_at: string;
  updated_at: string;
  last_login_at: string | null;
  password_salt?: string;
  password_hash?: string;
  total?: number;
};

const hashPassword = (password: string, salt: string) =>
  crypto.createHash('sha256').update(`${salt}:${password}`).digest('hex');

const createPasswordFields = (password: string) => {
  const passwordSalt = crypto.randomBytes(12).toString('hex');
  return {
    passwordSalt,
    passwordHash: hashPassword(password, passwordSalt),
  };
};

const isoExpr = (column: string) =>
  `to_char(${column} at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')`;

const optionalString = (value: unknown) => {
  if (value === undefined || value === null) return null;
  const text = String(value).trim();
  return text ? text : null;
};

const routeParam = (value: unknown) => (Array.isArray(value) ? String(value[0] || '') : String(value || ''));

const toPositiveInt = (value: unknown, fallback: number) => {
  const parsed = Math.floor(Number(value || fallback));
  return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
};

const logDataCount = (req: Request, label: string, data: unknown) => {
  const count = Array.isArray(data) ? data.length : data ? 1 : 0;
  logRequestStep(req, 'db:data', `${label} count=${count}`);
};

const handleError = (res: Response, error: unknown) => {
  res.status(500).send({
    success: false,
    errorMessage: error instanceof Error ? error.message : 'Database user route failed',
  });
};

const mapUser = (row: UserRow) => ({
  id: row.id,
  userid: row.id,
  username: row.username,
  name: row.name,
  email: row.email,
  phone: row.phone || undefined,
  role: row.role,
  access: row.role,
  status: row.status,
  avatar: row.avatar || undefined,
  title: row.title || undefined,
  department: row.department || undefined,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
  lastLoginAt: row.last_login_at || undefined,
});

export const ensureUserTable = async (req: Request, schema: string) => {
  const schemaName = quoteIdentifier(schema);
  await queryDatabase(
    req,
    'user.ensureTable',
    `
      create table if not exists ${schemaName}.managed_user (
        id text primary key,
        username text not null unique,
        name text not null,
        email text not null unique,
        phone text,
        role text not null check (role in ('admin', 'user')),
        status text not null check (status in ('active', 'disabled')),
        avatar text,
        title text,
        department text,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now(),
        last_login_at timestamptz,
        password_salt text not null,
        password_hash text not null
      )
    `,
  );

  const adminPassword = createPasswordFields('ant.design');
  const userPassword = createPasswordFields('ant.design');
  await queryDatabase(
    req,
    'user.seed',
    `
      insert into ${schemaName}.managed_user (
        id,
        username,
        name,
        email,
        role,
        status,
        avatar,
        title,
        department,
        password_salt,
        password_hash
      )
      select *
      from (
        values
          (
            'u_admin',
            'admin',
            '系统管理员',
            'admin@datacenter.local',
            'admin',
            'active',
            'https://gw.alipayobjects.com/zos/antfincdn/XAosXuNZyF/BiazfanxmamNRoxxVxka.png',
            '系统管理员',
            '平台管理部',
            $1,
            $2
          ),
          (
            'u_user',
            'user',
            '普通用户',
            'user@datacenter.local',
            'user',
            'active',
            null,
            '运维工程师',
            '数据中心运维部',
            $3,
            $4
          )
      ) as seed(
        id,
        username,
        name,
        email,
        role,
        status,
        avatar,
        title,
        department,
        password_salt,
        password_hash
      )
      where not exists (select 1 from ${schemaName}.managed_user)
      on conflict (id) do nothing
    `,
    [
      adminPassword.passwordSalt,
      adminPassword.passwordHash,
      userPassword.passwordSalt,
      userPassword.passwordHash,
    ],
  );
};

const validateUserPayload = async (
  req: Request,
  schema: string,
  body: Record<string, any>,
  options: { requirePassword: boolean; exceptId?: string },
) => {
  const schemaName = quoteIdentifier(schema);
  const username = String(body.username || '').trim();
  const name = String(body.name || '').trim();
  const email = String(body.email || '').trim();
  const password = String(body.password || '');
  const role = String(body.role || 'user');
  const status = String(body.status || 'active');

  if (!username) return '用户名不能为空。';
  if (!/^[a-zA-Z0-9_.-]{3,32}$/.test(username)) {
    return '用户名只能包含字母、数字、下划线、点和短横线，长度 3-32 位。';
  }
  if (!name) return '姓名不能为空。';
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return '邮箱格式不正确。';
  if (!['admin', 'user'].includes(role)) return '角色不正确。';
  if (!['active', 'disabled'].includes(status)) return '状态不正确。';
  if (options.requirePassword && password.length < 6) return '密码至少需要 6 位。';
  if (password && password.length < 6) return '密码至少需要 6 位。';

  const params: unknown[] = [username, email];
  let exceptClause = '';
  if (options.exceptId) {
    params.push(options.exceptId);
    exceptClause = `and id <> $${params.length}`;
  }

  const uniqueResult = await queryDatabase<{ username_used: boolean; email_used: boolean }>(
    req,
    'user.validateUnique',
    `
      select
        exists(select 1 from ${schemaName}.managed_user where username = $1 ${exceptClause}) as username_used,
        exists(select 1 from ${schemaName}.managed_user where email = $2 ${exceptClause}) as email_used
    `,
    params,
  );
  const uniqueRow = uniqueResult.rows[0];
  if (uniqueRow?.username_used) return '用户名已存在。';
  if (uniqueRow?.email_used) return '邮箱已存在。';
  return null;
};

const selectUserSql = (schemaName: string, whereClause: string) => `
  select
    id,
    username,
    name,
    email,
    phone,
    role,
    status,
    avatar,
    title,
    department,
    ${isoExpr('created_at')} as created_at,
    ${isoExpr('updated_at')} as updated_at,
    ${isoExpr('last_login_at')} as last_login_at
  from ${schemaName}.managed_user
  ${whereClause}
`;

const getUserById = async (req: Request, schema: string, id: string) => {
  const schemaName = quoteIdentifier(schema);
  const result = await queryDatabase<UserRow>(
    req,
    'user.detail',
    selectUserSql(schemaName, 'where id = $1'),
    [id],
  );
  return result.rows[0] ? mapUser(result.rows[0]) : null;
};

export default {
  'GET /api/users': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      const schemaName = quoteIdentifier(schema);
      await ensureUserTable(req, schema);

      const current = toPositiveInt(req.query.current, 1);
      const pageSize = toPositiveInt(req.query.pageSize, 20);
      const offset = (current - 1) * pageSize;
      const keyword = String(req.query.keyword || req.query.name || '').trim();
      const params: unknown[] = [];
      const filters: string[] = [];

      if (keyword) {
        params.push(`%${keyword}%`);
        filters.push(`(username ilike $${params.length} or name ilike $${params.length} or email ilike $${params.length})`);
      }
      if (req.query.role) {
        params.push(String(req.query.role));
        filters.push(`role = $${params.length}`);
      }
      if (req.query.status) {
        params.push(String(req.query.status));
        filters.push(`status = $${params.length}`);
      }

      const whereClause = filters.length ? `where ${filters.join(' and ')}` : '';
      params.push(pageSize, offset);
      const result = await queryDatabase<UserRow>(
        req,
        'user.list',
        `
          with filtered as (
            select
              id,
              username,
              name,
              email,
              phone,
              role,
              status,
              avatar,
              title,
              department,
              ${isoExpr('created_at')} as created_at,
              ${isoExpr('updated_at')} as updated_at,
              ${isoExpr('last_login_at')} as last_login_at,
              created_at as sort_created_at
            from ${schemaName}.managed_user
            ${whereClause}
          ),
          total_count as (
            select count(*)::int as total from filtered
          )
          select filtered.*, (select total from total_count) as total
          from filtered
          order by sort_created_at desc, id
          limit $${params.length - 1} offset $${params.length}
        `,
        params,
      );

      const data = result.rows.map(mapUser);
      logDataCount(req, 'user.list', data);
      res.send({
        data,
        total: Number(result.rows[0]?.total || 0),
        success: true,
      });
    } catch (error) {
      handleError(res, error);
    }
  },

  'GET /api/users/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      await ensureUserTable(req, schema);
      const user = await getUserById(req, schema, routeParam(req.params.id));
      if (!user) {
        res.status(404).send({ success: false, errorMessage: '用户不存在。' });
        return;
      }
      logDataCount(req, 'user.detail', user);
      res.send({ success: true, data: user });
    } catch (error) {
      handleError(res, error);
    }
  },

  'POST /api/users': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      const schemaName = quoteIdentifier(schema);
      await ensureUserTable(req, schema);
      const body = req.body || {};
      const errorMessage = await validateUserPayload(req, schema, body, {
        requirePassword: true,
      });
      if (errorMessage) {
        res.status(400).send({ success: false, errorMessage });
        return;
      }

      const id = `u_${Date.now()}_${crypto.randomBytes(4).toString('hex')}`;
      const passwordFields = createPasswordFields(String(body.password));
      const result = await queryDatabase<UserRow>(
        req,
        'user.create',
        `
          insert into ${schemaName}.managed_user (
            id,
            username,
            name,
            email,
            phone,
            role,
            status,
            avatar,
            title,
            department,
            password_salt,
            password_hash
          )
          values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
          returning
            id,
            username,
            name,
            email,
            phone,
            role,
            status,
            avatar,
            title,
            department,
            ${isoExpr('created_at')} as created_at,
            ${isoExpr('updated_at')} as updated_at,
            ${isoExpr('last_login_at')} as last_login_at
        `,
        [
          id,
          String(body.username).trim(),
          String(body.name).trim(),
          String(body.email).trim(),
          optionalString(body.phone),
          body.role || 'user',
          body.status || 'active',
          optionalString(body.avatar),
          optionalString(body.title),
          optionalString(body.department),
          passwordFields.passwordSalt,
          passwordFields.passwordHash,
        ],
      );
      const user = mapUser(result.rows[0]);
      logDataCount(req, 'user.create', user);
      res.send({ success: true, data: user });
    } catch (error) {
      handleError(res, error);
    }
  },

  'PUT /api/users/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      const schemaName = quoteIdentifier(schema);
      await ensureUserTable(req, schema);

      const existingResult = await queryDatabase<UserRow>(
        req,
        'user.findForUpdate',
        `
          select
            id,
            username,
            name,
            email,
            phone,
            role,
            status,
            avatar,
            title,
            department,
            password_salt,
            password_hash,
            ${isoExpr('created_at')} as created_at,
            ${isoExpr('updated_at')} as updated_at,
            ${isoExpr('last_login_at')} as last_login_at
          from ${schemaName}.managed_user
          where id = $1
        `,
        [req.params.id],
      );
      const existing = existingResult.rows[0];
      if (!existing) {
        res.status(404).send({ success: false, errorMessage: '用户不存在。' });
        return;
      }

      const body = req.body || {};
      const nextPayload = {
        ...existing,
        ...body,
        password: body.password || '',
      };
      const errorMessage = await validateUserPayload(req, schema, nextPayload, {
        requirePassword: false,
        exceptId: existing.id,
      });
      if (errorMessage) {
        res.status(400).send({ success: false, errorMessage });
        return;
      }

      const nextPassword =
        body.password && String(body.password).trim()
          ? createPasswordFields(String(body.password))
          : {
              passwordSalt: existing.password_salt,
              passwordHash: existing.password_hash,
            };
      const result = await queryDatabase<UserRow>(
        req,
        'user.update',
        `
          update ${schemaName}.managed_user
          set
            username = $2,
            name = $3,
            email = $4,
            phone = $5,
            role = $6,
            status = $7,
            avatar = $8,
            title = $9,
            department = $10,
            password_salt = $11,
            password_hash = $12,
            updated_at = now()
          where id = $1
          returning
            id,
            username,
            name,
            email,
            phone,
            role,
            status,
            avatar,
            title,
            department,
            ${isoExpr('created_at')} as created_at,
            ${isoExpr('updated_at')} as updated_at,
            ${isoExpr('last_login_at')} as last_login_at
        `,
        [
          existing.id,
          String(body.username || existing.username).trim(),
          String(body.name || existing.name).trim(),
          String(body.email || existing.email).trim(),
          body.phone === undefined ? existing.phone : optionalString(body.phone),
          body.role || existing.role,
          body.status || existing.status,
          body.avatar === undefined ? existing.avatar : optionalString(body.avatar),
          body.title === undefined ? existing.title : optionalString(body.title),
          body.department === undefined ? existing.department : optionalString(body.department),
          nextPassword.passwordSalt,
          nextPassword.passwordHash,
        ],
      );
      const user = mapUser(result.rows[0]);
      logDataCount(req, 'user.update', user);
      res.send({ success: true, data: user });
    } catch (error) {
      handleError(res, error);
    }
  },

  'DELETE /api/users/:id': async (req: Request, res: Response) => {
    try {
      const schema = getDatabaseSchema();
      const schemaName = quoteIdentifier(schema);
      await ensureUserTable(req, schema);

      const userResult = await queryDatabase<{ role: UserRole; status: UserStatus }>(
        req,
        'user.findForDelete',
        `select role, status from ${schemaName}.managed_user where id = $1`,
        [req.params.id],
      );
      const user = userResult.rows[0];
      if (!user) {
        res.status(404).send({ success: false, errorMessage: '用户不存在。' });
        return;
      }

      if (user.role === 'admin' && user.status === 'active') {
        const adminCountResult = await queryDatabase<{ total: number }>(
          req,
          'user.activeAdminCount',
          `
            select count(*)::int as total
            from ${schemaName}.managed_user
            where role = 'admin' and status = 'active'
          `,
        );
        if (Number(adminCountResult.rows[0]?.total || 0) <= 1) {
          res.status(400).send({
            success: false,
            errorMessage: '至少需要保留一个启用状态的管理员。',
          });
          return;
        }
      }

      const result = await queryDatabase<{ id: string }>(
        req,
        'user.delete',
        `delete from ${schemaName}.managed_user where id = $1 returning id`,
        [req.params.id],
      );
      logDataCount(req, 'user.delete', result.rows);
      res.send({ success: true, data: {} });
    } catch (error) {
      handleError(res, error);
    }
  },
};
