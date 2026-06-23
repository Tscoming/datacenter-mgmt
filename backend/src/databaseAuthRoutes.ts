import crypto from 'node:crypto';
import type { Request, Response } from 'express';

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
  passwordSalt: string;
  passwordHash: string;
  createdAt: string;
  updatedAt: string;
};

type SessionRecord = {
  userId: string;
  token: string;
  refreshToken: string;
  expiresAt: number;
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

const nowIso = () => new Date().toISOString();

const createUser = (
  id: string,
  username: string,
  password: string,
  role: UserRole,
  name: string,
  email: string,
): AuthUser => {
  const timestamp = nowIso();
  return {
    id,
    username,
    name,
    email,
    role,
    status: 'active',
    avatar:
      role === 'admin'
        ? 'https://gw.alipayobjects.com/zos/antfincdn/XAosXuNZyF/BiazfanxmamNRoxxVxka.png'
        : undefined,
    title: role === 'admin' ? '系统管理员' : '运维工程师',
    department: role === 'admin' ? '平台管理部' : '数据中心运维部',
    createdAt: timestamp,
    updatedAt: timestamp,
    ...createPasswordFields(password),
  };
};

const users = [
  createUser('u_admin', 'admin', 'ant.design', 'admin', '系统管理员', 'admin@datacenter.local'),
  createUser('u_user', 'user', 'ant.design', 'user', '普通用户', 'user@datacenter.local'),
];

const sessionsByToken = new Map<string, SessionRecord>();
const sessionsByRefreshToken = new Map<string, SessionRecord>();

const generateToken = () => `tk_${crypto.randomBytes(18).toString('hex')}_${Date.now()}`;

const stripSensitiveUser = (user: AuthUser) => {
  const { passwordHash: _passwordHash, passwordSalt: _passwordSalt, ...safe } = user;
  return {
    ...safe,
    access: user.role,
    userid: user.id,
  };
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

const requireLogin = (req: Request, res: Response) => {
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

  const user = users.find((item) => item.id === session.userId);
  if (!user || user.status !== 'active') {
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

export default {
  'GET /api/currentUser': (req: Request, res: Response) => {
    const currentUser = requireLogin(req, res);
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
  },

  'POST /api/login/account': (req: Request, res: Response) => {
    const { password, username, type } = req.body || {};
    const user = users.find((item) => item.username === String(username || ''));

    if (
      user &&
      user.status === 'active' &&
      hashPassword(String(password || ''), user.passwordSalt) === user.passwordHash
    ) {
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
  },

  'POST /api/login/refresh': (req: Request, res: Response) => {
    const { refreshToken } = req.body || {};
    const session = sessionsByRefreshToken.get(String(refreshToken || ''));
    if (!session) {
      res.status(401).send({ success: false, errorMessage: 'Invalid refresh token' });
      return;
    }

    const user = users.find((item) => item.id === session.userId);
    if (!user || user.status !== 'active') {
      sessionsByToken.delete(session.token);
      sessionsByRefreshToken.delete(session.refreshToken);
      res.status(401).send({ success: false, errorMessage: 'Invalid refresh token' });
      return;
    }

    sessionsByToken.delete(session.token);
    sessionsByRefreshToken.delete(session.refreshToken);
    res.send({ success: true, data: issueSession(user.id) });
  },

  'POST /api/login/outLogin': (req: Request, res: Response) => {
    const token = getBearerToken(req);
    if (token) {
      const session = sessionsByToken.get(token);
      if (session) {
        sessionsByToken.delete(session.token);
        sessionsByRefreshToken.delete(session.refreshToken);
      }
    }
    res.send({ data: {}, success: true });
  },

  'GET /api/login/captcha': (_req: Request, res: Response) => {
    res.json('captcha-xxx');
  },
};
