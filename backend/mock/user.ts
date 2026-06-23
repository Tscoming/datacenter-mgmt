import crypto from 'crypto';
import type { Request, Response } from 'express';

type UserRole = 'admin' | 'user';
type UserStatus = 'active' | 'disabled';

interface ManagedUser {
  id: string;
  username: string;
  name: string;
  email: string;
  phone?: string;
  role: UserRole;
  status: UserStatus;
  avatar?: string;
  title?: string;
  department?: string;
  createdAt: string;
  updatedAt: string;
  lastLoginAt?: string;
  passwordSalt: string;
  passwordHash: string;
}

interface SessionRecord {
  userId: string;
  token: string;
  refreshToken: string;
  expiresAt: number;
}

const waitTime = (time: number = 100) =>
  new Promise((resolve) => {
    setTimeout(() => resolve(true), time);
  });

async function getFakeCaptcha(_req: Request, res: Response) {
  await waitTime(2000);
  return res.json('captcha-xxx');
}

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

const createSeedUser = (
  id: string,
  username: string,
  password: string,
  role: UserRole,
  name: string,
  email: string,
  extra: Partial<ManagedUser> = {},
): ManagedUser => {
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
    ...extra,
  };
};

let users: ManagedUser[] = [
  createSeedUser(
    'u_admin',
    'admin',
    'ant.design',
    'admin',
    '系统管理员',
    'admin@datacenter.local',
  ),
  createSeedUser(
    'u_user',
    'user',
    'ant.design',
    'user',
    '普通用户',
    'user@datacenter.local',
  ),
];

const sessionsByToken = new Map<string, SessionRecord>();
const sessionsByRefreshToken = new Map<string, SessionRecord>();

const generateToken = () =>
  `tk_${crypto.randomBytes(18).toString('hex')}_${Date.now()}`;

const stripSensitiveUser = (user: ManagedUser) => {
  const { passwordHash: _passwordHash, passwordSalt: _passwordSalt, ...safe } =
    user;
  return {
    ...safe,
    access: user.role,
    userid: user.id,
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

const getCurrentUser = (req: Request) => {
  const session = getSessionFromRequest(req);
  if (!session) return session;
  return users.find((user) => user.id === session.userId) || false;
};

const requireLogin = (req: Request, res: Response) => {
  const currentUser = getCurrentUser(req);
  if (currentUser === false) {
    res.status(401).send({
      data: { isLogin: false },
      errorCode: '401',
      errorMessage: '登录已过期，请重新登录！',
      success: false,
    });
    return null;
  }
  if (!currentUser) {
    res.status(401).send({
      data: { isLogin: false },
      errorCode: '401',
      errorMessage: '请先登录！',
      success: false,
    });
    return null;
  }
  return currentUser;
};

const requireAdmin = (req: Request, res: Response) => {
  const currentUser = requireLogin(req, res);
  if (!currentUser) return null;
  if (currentUser.role !== 'admin') {
    res.status(403).send({
      success: false,
      errorCode: '403',
      errorMessage: '只有管理员可以管理用户。',
    });
    return null;
  }
  return currentUser;
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

const paginateUsers = (req: Request) => {
  const current = Number(req.query.current || 1);
  const pageSize = Number(req.query.pageSize || 20);
  const keyword = String(req.query.keyword || req.query.name || '').trim();
  const role = String(req.query.role || '').trim();
  const status = String(req.query.status || '').trim();

  let data = users;
  if (keyword) {
    const lowered = keyword.toLowerCase();
    data = data.filter(
      (user) =>
        user.username.toLowerCase().includes(lowered) ||
        user.name.toLowerCase().includes(lowered) ||
        user.email.toLowerCase().includes(lowered),
    );
  }
  if (role) data = data.filter((user) => user.role === role);
  if (status) data = data.filter((user) => user.status === status);

  const start = (current - 1) * pageSize;
  return {
    data: data.slice(start, start + pageSize).map(stripSensitiveUser),
    total: data.length,
    success: true,
  };
};

const isUsernameUsed = (username: string, exceptId?: string) =>
  users.some((user) => user.username === username && user.id !== exceptId);

const isEmailUsed = (email: string, exceptId?: string) =>
  users.some((user) => user.email === email && user.id !== exceptId);

const validateUserPayload = (
  body: Record<string, any>,
  options: { requirePassword: boolean; exceptId?: string },
) => {
  const username = String(body.username || '').trim();
  const name = String(body.name || '').trim();
  const email = String(body.email || '').trim();
  const password = String(body.password || '');
  const role = String(body.role || 'user') as UserRole;
  const status = String(body.status || 'active') as UserStatus;

  if (!username) return '用户名不能为空。';
  if (!/^[a-zA-Z0-9_.-]{3,32}$/.test(username)) {
    return '用户名只能包含字母、数字、下划线、点和短横线，长度 3-32 位。';
  }
  if (!name) return '姓名不能为空。';
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return '邮箱格式不正确。';
  if (!['admin', 'user'].includes(role)) return '角色不正确。';
  if (!['active', 'disabled'].includes(status)) return '状态不正确。';
  if (options.requirePassword && password.length < 6) {
    return '密码至少需要 6 位。';
  }
  if (password && password.length < 6) return '密码至少需要 6 位。';
  if (isUsernameUsed(username, options.exceptId)) return '用户名已存在。';
  if (isEmailUsed(email, options.exceptId)) return '邮箱已存在。';
  return null;
};

const removeUserSessions = (userId: string) => {
  for (const session of sessionsByToken.values()) {
    if (session.userId === userId) {
      sessionsByToken.delete(session.token);
      sessionsByRefreshToken.delete(session.refreshToken);
    }
  }
};

export default {
  'GET /api/currentUser': (req: Request, res: Response) => {
    const currentUser = requireLogin(req, res);
    if (!currentUser) return;

    res.send({
      success: true,
      data: {
        ...stripSensitiveUser(currentUser),
        notifyCount: 12,
        unreadCount: 11,
        country: 'China',
      },
    });
  },

  'GET /api/users': (req: Request, res: Response) => {
    if (!requireAdmin(req, res)) return;
    res.send(paginateUsers(req));
  },

  'GET /api/users/:id': (req: Request, res: Response) => {
    if (!requireAdmin(req, res)) return;
    const user = users.find((item) => item.id === req.params.id);
    if (!user) {
      res.status(404).send({ success: false, errorMessage: '用户不存在。' });
      return;
    }
    res.send({ success: true, data: stripSensitiveUser(user) });
  },

  'POST /api/users': (req: Request, res: Response) => {
    if (!requireAdmin(req, res)) return;
    const errorMessage = validateUserPayload(req.body || {}, {
      requirePassword: true,
    });
    if (errorMessage) {
      res.status(400).send({ success: false, errorMessage });
      return;
    }

    const timestamp = nowIso();
    const user: ManagedUser = {
      id: `u_${Date.now()}_${crypto.randomBytes(4).toString('hex')}`,
      username: String(req.body.username).trim(),
      name: String(req.body.name).trim(),
      email: String(req.body.email).trim(),
      phone: String(req.body.phone || '').trim() || undefined,
      role: req.body.role || 'user',
      status: req.body.status || 'active',
      title: String(req.body.title || '').trim() || undefined,
      department: String(req.body.department || '').trim() || undefined,
      avatar: String(req.body.avatar || '').trim() || undefined,
      createdAt: timestamp,
      updatedAt: timestamp,
      ...createPasswordFields(String(req.body.password)),
    };
    users = [user, ...users];
    res.send({ success: true, data: stripSensitiveUser(user) });
  },

  'PUT /api/users/:id': (req: Request, res: Response) => {
    const currentUser = requireAdmin(req, res);
    if (!currentUser) return;
    const user = users.find((item) => item.id === req.params.id);
    if (!user) {
      res.status(404).send({ success: false, errorMessage: '用户不存在。' });
      return;
    }

    const errorMessage = validateUserPayload(
      {
        ...user,
        ...req.body,
        password: req.body?.password || '',
      },
      { requirePassword: false, exceptId: user.id },
    );
    if (errorMessage) {
      res.status(400).send({ success: false, errorMessage });
      return;
    }

    const nextRole = (req.body.role || user.role) as UserRole;
    const nextStatus = (req.body.status || user.status) as UserStatus;
    if (
      user.id === currentUser.id &&
      (nextRole !== 'admin' || nextStatus !== 'active')
    ) {
      res.status(400).send({
        success: false,
        errorMessage: '不能降低或禁用当前登录管理员。',
      });
      return;
    }

    const nextPassword =
      req.body.password && String(req.body.password).trim()
        ? createPasswordFields(String(req.body.password))
        : {};
    Object.assign(user, {
      username: String(req.body.username || user.username).trim(),
      name: String(req.body.name || user.name).trim(),
      email: String(req.body.email || user.email).trim(),
      phone:
        req.body.phone === undefined
          ? user.phone
          : String(req.body.phone).trim() || undefined,
      role: nextRole,
      status: nextStatus,
      title:
        req.body.title === undefined
          ? user.title
          : String(req.body.title).trim() || undefined,
      department:
        req.body.department === undefined
          ? user.department
          : String(req.body.department).trim() || undefined,
      avatar:
        req.body.avatar === undefined
          ? user.avatar
          : String(req.body.avatar).trim() || undefined,
      updatedAt: nowIso(),
      ...nextPassword,
    });

    if (user.status === 'disabled') removeUserSessions(user.id);
    res.send({ success: true, data: stripSensitiveUser(user) });
  },

  'DELETE /api/users/:id': (req: Request, res: Response) => {
    const currentUser = requireAdmin(req, res);
    if (!currentUser) return;
    const user = users.find((item) => item.id === req.params.id);
    if (!user) {
      res.status(404).send({ success: false, errorMessage: '用户不存在。' });
      return;
    }
    if (user.id === currentUser.id) {
      res.status(400).send({ success: false, errorMessage: '不能删除当前用户。' });
      return;
    }
    if (
      user.role === 'admin' &&
      users.filter((item) => item.role === 'admin' && item.status === 'active')
        .length <= 1
    ) {
      res.status(400).send({
        success: false,
        errorMessage: '至少需要保留一个启用状态的管理员。',
      });
      return;
    }
    users = users.filter((item) => item.id !== user.id);
    removeUserSessions(user.id);
    res.send({ success: true, data: {} });
  },

  'POST /api/login/account': async (req: Request, res: Response) => {
    const { password, username, type } = req.body;
    await waitTime(300);

    const user = users.find((item) => item.username === String(username || ''));
    if (
      user &&
      user.status === 'active' &&
      hashPassword(String(password || ''), user.passwordSalt) ===
        user.passwordHash
    ) {
      user.lastLoginAt = nowIso();
      user.updatedAt = nowIso();
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

  'POST /api/login/refresh': (req: Request, res: Response) => {
    const { refreshToken } = req.body || {};
    const session = sessionsByRefreshToken.get(String(refreshToken || ''));
    if (!session) {
      res.status(401).send({
        success: false,
        errorMessage: 'Invalid refresh token',
      });
      return;
    }

    const user = users.find((item) => item.id === session.userId);
    if (!user || user.status !== 'active') {
      sessionsByToken.delete(session.token);
      sessionsByRefreshToken.delete(session.refreshToken);
      res.status(401).send({
        success: false,
        errorMessage: 'Invalid refresh token',
      });
      return;
    }

    sessionsByToken.delete(session.token);
    sessionsByRefreshToken.delete(session.refreshToken);
    const nextSession = issueSession(user.id);
    res.send({
      success: true,
      data: nextSession,
    });
  },

  'POST /api/register': (req: Request, res: Response) => {
    const errorMessage = validateUserPayload(
      {
        ...req.body,
        name: req.body?.name || req.body?.username,
        role: 'user',
        status: 'active',
      },
      { requirePassword: true },
    );
    if (errorMessage) {
      res.status(400).send({ success: false, errorMessage });
      return;
    }

    const timestamp = nowIso();
    const user: ManagedUser = {
      id: `u_${Date.now()}_${crypto.randomBytes(4).toString('hex')}`,
      username: String(req.body.username).trim(),
      name: String(req.body.name || req.body.username).trim(),
      email: String(req.body.email).trim(),
      role: 'user',
      status: 'active',
      createdAt: timestamp,
      updatedAt: timestamp,
      ...createPasswordFields(String(req.body.password)),
    };
    users = [user, ...users];
    res.send({ status: 'ok', currentAuthority: 'user', success: true });
  },

  'GET /api/500': (_req: Request, res: Response) => {
    res.status(500).send({
      timestamp: 1513932555104,
      status: 500,
      error: 'error',
      message: 'error',
      path: '/base/category/list',
    });
  },
  'GET /api/404': (_req: Request, res: Response) => {
    res.status(404).send({
      timestamp: 1513932643431,
      status: 404,
      error: 'Not Found',
      message: 'No message available',
      path: '/base/category/list/2121212',
    });
  },
  'GET /api/403': (_req: Request, res: Response) => {
    res.status(403).send({
      timestamp: 1513932555104,
      status: 403,
      error: 'Forbidden',
      message: 'Forbidden',
      path: '/base/category/list',
    });
  },
  'GET /api/401': (_req: Request, res: Response) => {
    res.status(401).send({
      timestamp: 1513932555104,
      status: 401,
      error: 'Unauthorized',
      message: 'Unauthorized',
      path: '/base/category/list',
    });
  },

  'GET  /api/login/captcha': getFakeCaptcha,
};
