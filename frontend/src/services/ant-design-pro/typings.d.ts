// @ts-ignore
/* eslint-disable */

declare namespace API {
  type CurrentUser = {
    name?: string;
    avatar?: string;
    userid?: string;
    id?: string;
    username?: string;
    email?: string;
    signature?: string;
    title?: string;
    group?: string;
    tags?: { key?: string; label?: string }[];
    notifyCount?: number;
    unreadCount?: number;
    country?: string;
    access?: string;
    geographic?: {
      province?: { label?: string; key?: string };
      city?: { label?: string; key?: string };
    };
    address?: string;
    phone?: string;
    role?: 'admin' | 'user';
    status?: 'active' | 'disabled';
    department?: string;
    createdAt?: string;
    updatedAt?: string;
    lastLoginAt?: string;
  };

  type LoginResult = {
    success?: boolean;
    status?: string;
    type?: string;
    currentAuthority?: string;
    token?: string;
    refreshToken?: string;
    expiresAt?: number;
    user?: CurrentUser;
  };

  type ManagedUser = {
    id: string;
    userid?: string;
    username: string;
    name: string;
    email: string;
    phone?: string;
    role: 'admin' | 'user';
    access?: string;
    status: 'active' | 'disabled';
    avatar?: string;
    title?: string;
    department?: string;
    createdAt: string;
    updatedAt: string;
    lastLoginAt?: string;
  };

  type ManagedUserParams = {
    current?: number;
    pageSize?: number;
    keyword?: string;
    name?: string;
    role?: string;
    status?: string;
  };

  type ManagedUserPayload = {
    username: string;
    name: string;
    email: string;
    password?: string;
    phone?: string;
    role: 'admin' | 'user';
    status: 'active' | 'disabled';
    avatar?: string;
    title?: string;
    department?: string;
  };

  type PageParams = {
    current?: number;
    pageSize?: number;
  };

  type RuleListItem = {
    key?: number;
    disabled?: boolean;
    href?: string;
    avatar?: string;
    name?: string;
    owner?: string;
    desc?: string;
    callNo?: number;
    status?: number;
    updatedAt?: string;
    createdAt?: string;
    progress?: number;
  };

  type RuleList = {
    data?: RuleListItem[];
    /** 列表的内容总数 */
    total?: number;
    success?: boolean;
  };

  type FakeCaptcha = {
    code?: number;
    status?: string;
  };

  type LoginParams = {
    username?: string;
    password?: string;
    autoLogin?: boolean;
    type?: string;
  };

  type ErrorResponse = {
    /** 业务约定的错误码 */
    errorCode: string;
    /** 业务上的错误信息 */
    errorMessage?: string;
    /** 业务上的请求是否成功 */
    success?: boolean;
  };

  type NoticeIconList = {
    data?: NoticeIconItem[];
    /** 列表的内容总数 */
    total?: number;
    success?: boolean;
  };

  type NoticeIconItemType = 'notification' | 'message' | 'event';

  type NoticeIconItem = {
    id?: string;
    extra?: string;
    key?: string;
    read?: boolean;
    avatar?: string;
    title?: string;
    status?: string;
    datetime?: string;
    description?: string;
    type?: NoticeIconItemType;
  };
}
