import type { Request, Response } from 'express';

const waitTime = (time: number = 100) => {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(true);
    }, time);
  });
};

async function getFakeCaptcha(_req: Request, res: Response) {
  await waitTime(2000);
  return res.json('captcha-xxx');
}

const { ANT_DESIGN_PRO_ONLY_DO_NOT_USE_IN_YOUR_PRODUCTION } = process.env;

/**
 * 当前用户的权限，如果为空代表没登录
 * current user access， if is '', user need login
 * 如果是 pro 的预览，默认是有权限的
 */
let access =
  ANT_DESIGN_PRO_ONLY_DO_NOT_USE_IN_YOUR_PRODUCTION === 'site' ? 'admin' : '';

const getAccess = () => {
  return access;
};

let currentToken: string | null = null;
let currentRefreshToken: string | null = null;
let tokenExpiresAt = 0;

const generateToken = () => {
  return `tk_${Math.random().toString(36).slice(2)}_${Date.now()}`;
};

const issueSession = () => {
  currentToken = generateToken();
  currentRefreshToken = generateToken();
  tokenExpiresAt = Date.now() + 5 * 60 * 1000;
  return {
    token: currentToken,
    refreshToken: currentRefreshToken,
    expiresAt: tokenExpiresAt,
  };
};

const getBearerToken = (req: Request) => {
  const auth = req.headers?.authorization;
  if (!auth) return null;
  const match = String(auth).match(/^Bearer\s+(.+)$/i);
  return match?.[1] || null;
};

const validateAccessToken = (req: Request) => {
  const token = getBearerToken(req);
  if (!token) return null;
  if (!currentToken) return false;
  if (token !== currentToken) return false;
  if (tokenExpiresAt <= Date.now()) return false;
  return true;
};

// 代码中会兼容本地 service mock 以及部署站点的静态数据
export default {
  // 支持值为 Object 和 Array
  'GET /api/currentUser': (_req: Request, res: Response) => {
    const tokenState = validateAccessToken(_req);
    if (tokenState === false) {
      res.status(401).send({
        data: {
          isLogin: false,
        },
        errorCode: '401',
        errorMessage: '登录已过期，请重新登录！',
        success: true,
      });
      return;
    }

    if (!getAccess() && tokenState !== true) {
      res.status(401).send({
        data: {
          isLogin: false,
        },
        errorCode: '401',
        errorMessage: '请先登录！',
        success: true,
      });
      return;
    }
    res.send({
      success: true,
      data: {
        name: 'Serati Ma',
        avatar:
          'https://gw.alipayobjects.com/zos/antfincdn/XAosXuNZyF/BiazfanxmamNRoxxVxka.png',
        userid: '00000001',
        email: 'antdesign@alipay.com',
        signature: '海纳百川，有容乃大',
        title: '交互专家',
        group: '蚂蚁金服－某某某事业群－某某平台部－某某技术部－UED',
        tags: [
          {
            key: '0',
            label: '很有想法的',
          },
          {
            key: '1',
            label: '专注设计',
          },
          {
            key: '2',
            label: '辣~',
          },
          {
            key: '3',
            label: '大长腿',
          },
          {
            key: '4',
            label: '川妹子',
          },
          {
            key: '5',
            label: '海纳百川',
          },
        ],
        notifyCount: 12,
        unreadCount: 11,
        country: 'China',
        access: getAccess(),
        geographic: {
          province: {
            label: '浙江省',
            key: '330000',
          },
          city: {
            label: '杭州市',
            key: '330100',
          },
        },
        address: '西湖区工专路 77 号',
        phone: '0752-268888888',
      },
    });
  },
  // GET POST 可省略
  'GET /api/users': [
    {
      key: '1',
      name: 'John Brown',
      age: 32,
      address: 'New York No. 1 Lake Park',
    },
    {
      key: '2',
      name: 'Jim Green',
      age: 42,
      address: 'London No. 1 Lake Park',
    },
    {
      key: '3',
      name: 'Joe Black',
      age: 32,
      address: 'Sidney No. 1 Lake Park',
    },
  ],
  'POST /api/login/account': async (req: Request, res: Response) => {
    const { password, username, type } = req.body;
    await waitTime(2000);
    if (password === 'ant.design' && username === 'admin') {
      const session = issueSession();
      res.send({
        status: 'ok',
        type,
        currentAuthority: 'admin',
        ...session,
      });
      access = 'admin';
      return;
    }
    if (password === 'ant.design' && username === 'user') {
      const session = issueSession();
      res.send({
        status: 'ok',
        type,
        currentAuthority: 'user',
        ...session,
      });
      access = 'user';
      return;
    }
    if (type === 'mobile') {
      const session = issueSession();
      res.send({
        status: 'ok',
        type,
        currentAuthority: 'admin',
        ...session,
      });
      access = 'admin';
      return;
    }

    res.send({
      status: 'error',
      type,
      currentAuthority: 'guest',
    });
    access = 'guest';
    currentToken = null;
    currentRefreshToken = null;
    tokenExpiresAt = 0;
  },
  'POST /api/login/outLogin': (_req: Request, res: Response) => {
    access = '';
    currentToken = null;
    currentRefreshToken = null;
    tokenExpiresAt = 0;
    res.send({ data: {}, success: true });
  },
  'POST /api/login/refresh': (req: Request, res: Response) => {
    const { refreshToken } = req.body || {};
    if (!currentRefreshToken || refreshToken !== currentRefreshToken) {
      res.status(401).send({
        success: false,
        errorMessage: 'Invalid refresh token',
      });
      return;
    }

    currentToken = generateToken();
    tokenExpiresAt = Date.now() + 5 * 60 * 1000;
    res.send({
      success: true,
      data: {
        token: currentToken,
        refreshToken: currentRefreshToken,
        expiresAt: tokenExpiresAt,
      },
    });
  },
  'POST /api/register': (_req: Request, res: Response) => {
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
