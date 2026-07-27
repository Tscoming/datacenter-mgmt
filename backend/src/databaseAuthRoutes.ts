import crypto from 'node:crypto';
import type { Request, Response } from 'express';
import { getDatabaseSchema, queryDatabase, quoteIdentifier } from './db';
import { ensureUserTable } from './databaseUserRoutes';

type UserRole = 'admin' | 'user';

type AuthUser = {
  id: string;
  username: string;
  name: string;
  email: string;
  role: UserRole;
  status: 'active' | 'disabled';
  avatar?: string;
  title?: string;
  department?: string;
  createdAt: string;
  updatedAt: string;
  lastLoginAt?: string;
  passwordSalt: string;
  passwordHash: string;
};

type AuthUserRow = {
  id: string;
  username: string;
  name: string;
  email: string;
  role: UserRole;
  status: 'active' | 'disabled';
  avatar: string | null;
  title: string | null;
  department: string | null;
  created_at: string;
  updated_at: string;
  last_login_at: string | null;
  password_salt: string;
  password_hash: string;
};

type SessionRecord = {
  userId: string;
  token: string;
  refreshToken: string;
  expiresAt: number;
};

type ElevatedSessionRecord = {
  userId: string;
  sessionToken: string;
  expiresAt: number;
};

const hashPassword = (password: string, salt: string) =>
  crypto.createHash('sha256').update(`${salt}:${password}`).digest('hex');

const sessionsByToken = new Map<string, SessionRecord>();
const sessionsByRefreshToken = new Map<string, SessionRecord>();
const elevatedSessionsByToken = new Map<string, ElevatedSessionRecord>();

const generateToken = () => `tk_${crypto.randomBytes(18).toString('hex')}_${Date.now()}`;

const isoExpr = (column: string) =>
  `to_char(${column} at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"')`;

const mapAuthUser = (row: AuthUserRow): AuthUser => ({
  id: row.id,
  username: row.username,
  name: row.name,
  email: row.email,
  role: row.role,
  status: row.status,
  avatar: row.avatar || undefined,
  title: row.title || undefined,
  department: row.department || undefined,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
  lastLoginAt: row.last_login_at || undefined,
  passwordSalt: row.password_salt,
  passwordHash: row.password_hash,
});

const stripSensitiveUser = (user: AuthUser) => {
  const { passwordHash: _passwordHash, passwordSalt: _passwordSalt, ...safe } = user;
  return {
    ...safe,
    access: user.role,
    userid: user.id,
  };
};

const selectAuthUserSql = (schemaName: string, whereClause: string) => `
  select
    id,
    username,
    name,
    email,
    role,
    status,
    avatar,
    title,
    department,
    ${isoExpr('created_at')} as created_at,
    ${isoExpr('updated_at')} as updated_at,
    ${isoExpr('last_login_at')} as last_login_at,
    password_salt,
    password_hash
  from ${schemaName}.managed_user
  ${whereClause}
`;

const getAuthUserById = async (req: Request, schema: string, id: string) => {
  const result = await queryDatabase<AuthUserRow>(
    req,
    'auth.userById',
    selectAuthUserSql(quoteIdentifier(schema), 'where id = $1'),
    [id],
  );
  return result.rows[0] ? mapAuthUser(result.rows[0]) : null;
};

const getAuthUserByUsername = async (req: Request, schema: string, username: string) => {
  const result = await queryDatabase<AuthUserRow>(
    req,
    'auth.userByUsername',
    selectAuthUserSql(quoteIdentifier(schema), 'where username = $1'),
    [username],
  );
  return result.rows[0] ? mapAuthUser(result.rows[0]) : null;
};

const issueSession = (userId: string) => {
  const session: SessionRecord = {
    userId,
    token: generateToken(),
    refreshToken: generateToken(),
    expiresAt: Date.now() + 5 * 60 * 1000,
  };
  sessionsByToken.set(session.token, session);
  sessionsByRefreshToken.set(session.refreshToken, session);
  return {
    token: session.token,
    refreshToken: session.refreshToken,
    expiresAt: session.expiresAt,
  };
};

const getBearerToken = (req: Request) => {
  const auth = req.headers?.authorization;
  if (!auth) return null;
  const match = String(auth).match(/^Bearer\s+(.+)$/i);
  return match?.[1] || null;
};

const getSessionFromRequest = (req: Request) => {
  const token = getBearerToken(req);
  if (!token) return null;

  const session = sessionsByToken.get(token);
  if (!session) return false;

  if (session.expiresAt <= Date.now()) {
    sessionsByToken.delete(session.token);
    sessionsByRefreshToken.delete(session.refreshToken);
    return false;
  }

  return session;
};

const deleteSession = (session: SessionRecord) => {
  sessionsByToken.delete(session.token);
  sessionsByRefreshToken.delete(session.refreshToken);
  for (const [token, elevatedSession] of elevatedSessionsByToken) {
    if (elevatedSession.sessionToken === session.token) {
      elevatedSessionsByToken.delete(token);
    }
  }
};

const ensureAuthUserTable = async (req: Request) => {
  const schema = getDatabaseSchema();
  await ensureUserTable(req, schema);
  return schema;
};

const requireLogin = async (req: Request, res: Response) => {
  const session = getSessionFromRequest(req);
  if (!session) {
    res.status(401).send({
      data: { isLogin: false },
      errorCode: '401',
      errorMessage: session === false ? '登录已过期，请重新登录！' : '请先登录！',
      success: false,
    });
    return null;
  }

  const schema = await ensureAuthUserTable(req);
  const user = await getAuthUserById(req, schema, session.userId);
  if (!user || user.status !== 'active') {
    deleteSession(session);
    res.status(401).send({
      data: { isLogin: false },
      errorCode: '401',
      errorMessage: '登录已过期，请重新登录！',
      success: false,
    });
    return null;
  }

  return user;
};

export const requireKeyManagementAccess = async (req: Request, res: Response) => {
  const session = getSessionFromRequest(req);
  const user = await requireLogin(req, res);
  if (!user || !session) return null;

  if (user.role !== 'admin') {
    res.status(403).send({
      success: false,
      errorCode: '403',
      errorMessage: '仅管理员可以访问密钥管理。',
    });
    return null;
  }

  const verificationToken = String(req.headers['x-key-management-token'] || '');
  const elevatedSession = elevatedSessionsByToken.get(verificationToken);
  if (
    !elevatedSession ||
    elevatedSession.userId !== user.id ||
    elevatedSession.sessionToken !== session.token ||
    elevatedSession.expiresAt <= Date.now()
  ) {
    if (elevatedSession) elevatedSessionsByToken.delete(verificationToken);
    res.status(428).send({
      success: false,
      errorCode: 'KEY_MANAGEMENT_VERIFICATION_REQUIRED',
      errorMessage: '二次验证已失效，请重新验证。',
    });
    return null;
  }

  return user;
};

const handleAuthError = (res: Response, error: unknown) => {
  res.status(500).send({
    success: false,
    errorMessage: error instanceof Error ? error.message : 'Database auth route failed',
  });
};

export default {
  'GET /api/currentUser': async (req: Request, res: Response) => {
    try {
      const currentUser = await requireLogin(req, res);
      if (!currentUser) return;

      res.send({
        success: true,
        data: {
          ...stripSensitiveUser(currentUser),
          notifyCount: 0,
          unreadCount: 0,
          country: 'China',
        },
      });
    } catch (error) {
      handleAuthError(res, error);
    }
  },

  'POST /api/login/account': async (req: Request, res: Response) => {
    try {
      const { password, username, type } = req.body || {};
      const schema = await ensureAuthUserTable(req);
      const user = await getAuthUserByUsername(req, schema, String(username || ''));

      if (
        user &&
        user.status === 'active' &&
        hashPassword(String(password || ''), user.passwordSalt) === user.passwordHash
      ) {
        await queryDatabase(
          req,
          'auth.updateLastLogin',
          `update ${quoteIdentifier(schema)}.managed_user set last_login_at = now(), updated_at = now() where id = $1`,
          [user.id],
        );

        res.send({
          success: true,
          status: 'ok',
          type,
          currentAuthority: user.role,
          user: stripSensitiveUser(user),
          ...issueSession(user.id),
        });
        return;
      }

      res.send({
        success: true,
        status: 'error',
        type,
        currentAuthority: 'guest',
      });
    } catch (error) {
      handleAuthError(res, error);
    }
  },

  'POST /api/login/refresh': async (req: Request, res: Response) => {
    try {
      const { refreshToken } = req.body || {};
      const session = sessionsByRefreshToken.get(String(refreshToken || ''));
      if (!session) {
        res.status(401).send({ success: false, errorMessage: 'Invalid refresh token' });
        return;
      }

      const schema = await ensureAuthUserTable(req);
      const user = await getAuthUserById(req, schema, session.userId);
      if (!user || user.status !== 'active') {
        deleteSession(session);
        res.status(401).send({ success: false, errorMessage: 'Invalid refresh token' });
        return;
      }

      deleteSession(session);
      res.send({ success: true, data: issueSession(user.id) });
    } catch (error) {
      handleAuthError(res, error);
    }
  },

  'POST /api/login/outLogin': (req: Request, res: Response) => {
    const token = getBearerToken(req);
    if (token) {
      const session = sessionsByToken.get(token);
      if (session) {
        deleteSession(session);
      }
    }
    res.send({ data: {}, success: true });
  },

  'POST /api/key-management/verify': async (req: Request, res: Response) => {
    try {
      const session = getSessionFromRequest(req);
      const user = await requireLogin(req, res);
      if (!user || !session) return;

      if (user.role !== 'admin') {
        res.status(403).send({
          success: false,
          errorCode: '403',
          errorMessage: '仅管理员可以访问密钥管理。',
        });
        return;
      }

      const passwordHash = hashPassword(String(req.body?.password || ''), user.passwordSalt);
      const expectedHash = Buffer.from(user.passwordHash, 'hex');
      const actualHash = Buffer.from(passwordHash, 'hex');
      if (
        expectedHash.length !== actualHash.length ||
        !crypto.timingSafeEqual(expectedHash, actualHash)
      ) {
        res.status(400).send({
          success: false,
          errorCode: 'INVALID_PASSWORD',
          errorMessage: '当前账户密码不正确。',
        });
        return;
      }

      const verificationToken = `km_${crypto.randomBytes(24).toString('hex')}`;
      const expiresAt = Date.now() + 5 * 60 * 1000;
      for (const [token, elevatedSession] of elevatedSessionsByToken) {
        if (
          elevatedSession.expiresAt <= Date.now() ||
          elevatedSession.sessionToken === session.token
        ) {
          elevatedSessionsByToken.delete(token);
        }
      }
      elevatedSessionsByToken.set(verificationToken, {
        userId: user.id,
        sessionToken: session.token,
        expiresAt,
      });
      res.send({
        success: true,
        data: { verificationToken, expiresAt },
      });
    } catch (error) {
      handleAuthError(res, error);
    }
  },

  'GET /api/login/captcha': (_req: Request, res: Response) => {
    res.json('captcha-xxx');
  },
};
