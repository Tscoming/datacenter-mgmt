import { history } from '@umijs/max';

export interface Session {
  token: string;
  refreshToken: string;
  expiresAt: number;
}

const SESSION_KEY = 'session';
const CHANNEL_NAME = 'session';
const REFRESH_AHEAD_MS = 30_000;

let initialized = false;
let refreshing: Promise<Session | null> | null = null;

function getNow(): number {
  return Date.now();
}

function isSessionValid(session: Session | null): session is Session {
  if (!session) return false;
  return (
    Boolean(session.token) &&
    Boolean(session.refreshToken) &&
    session.expiresAt > 0
  );
}

export function getSession(): Session | null {
  if (typeof window === 'undefined') return null;
  const raw = localStorage.getItem(SESSION_KEY);
  if (!raw) return null;
  try {
    return JSON.parse(raw) as Session;
  } catch {
    return null;
  }
}

export function setSession(session: Session): void {
  if (typeof window === 'undefined') return;
  localStorage.setItem(SESSION_KEY, JSON.stringify(session));
  localStorage.setItem('token', session.token);
  broadcast({ type: 'session:update' });
}

export function clearSession(): void {
  if (typeof window === 'undefined') return;
  localStorage.removeItem(SESSION_KEY);
  localStorage.removeItem('token');
  broadcast({ type: 'session:clear' });
}

export function getAccessToken(): string | null {
  const session = getSession();
  if (isSessionValid(session)) return session.token;
  if (typeof window === 'undefined') return null;
  return localStorage.getItem('token');
}

export async function ensureValidSession(): Promise<Session | null> {
  const session = getSession();
  if (!isSessionValid(session)) return null;
  if (session.expiresAt - getNow() > REFRESH_AHEAD_MS) return session;

  if (!refreshing) {
    refreshing = refreshSession(session.refreshToken).finally(() => {
      refreshing = null;
    });
  }
  return refreshing;
}

async function refreshSession(refreshToken: string): Promise<Session | null> {
  if (typeof window === 'undefined') return null;
  try {
    const res = await fetch('/api/login/refresh', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ refreshToken }),
    });

    if (!res.ok) {
      if (res.status === 401 || res.status === 403) {
        clearSession();
        redirectToLogin();
      }
      return null;
    }
    const json = await res.json();
    const data = json?.data;
    if (!json?.success || !data?.token || !data?.expiresAt) return null;

    const next: Session = {
      token: data.token,
      refreshToken: data.refreshToken || refreshToken,
      expiresAt: data.expiresAt,
    };
    setSession(next);
    return next;
  } catch {
    return null;
  }
}

function redirectToLogin(): void {
  const loginPath = '/user/login';
  if (history.location.pathname === loginPath) return;
  const currentPath = history.location.pathname + history.location.search;
  const redirect = encodeURIComponent(currentPath);
  history.replace(`${loginPath}?redirect=${redirect}`);
}

function broadcast(payload: any): void {
  if (typeof window === 'undefined') return;
  if ('BroadcastChannel' in window) {
    const channel = new BroadcastChannel(CHANNEL_NAME);
    channel.postMessage(payload);
    channel.close();
  }
}

function onExternalSessionChange(): void {
  const token = getAccessToken();
  if (!token) {
    redirectToLogin();
  }
}

export function initSessionSync(): void {
  if (initialized) return;
  initialized = true;

  if (typeof window === 'undefined') return;

  window.addEventListener('storage', (e) => {
    if (e.key === SESSION_KEY || e.key === 'token') {
      onExternalSessionChange();
    }
  });

  if ('BroadcastChannel' in window) {
    const channel = new BroadcastChannel(CHANNEL_NAME);
    channel.addEventListener('message', () => {
      onExternalSessionChange();
    });
  }
}
