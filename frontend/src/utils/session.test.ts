import { beforeEach, describe, expect, it, vi } from 'vitest';
import { ensureValidSession, getAccessToken, setSession } from './session';

vi.mock('@umijs/max', () => ({
  history: {
    location: {
      pathname: '/',
      search: '',
    },
    replace: vi.fn(),
  },
}));

describe('session refresh', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.restoreAllMocks();
  });

  it('clears stale session when refresh token is rejected', async () => {
    vi.spyOn(globalThis, 'fetch').mockResolvedValue(
      new Response(JSON.stringify({ success: false }), { status: 401 }),
    );

    setSession({
      token: 'stale-token',
      refreshToken: 'stale-refresh-token',
      expiresAt: Date.now() + 1_000,
    });

    await expect(ensureValidSession()).resolves.toBeNull();

    expect(localStorage.getItem('session')).toBeNull();
    expect(localStorage.getItem('token')).toBeNull();
    expect(getAccessToken()).toBeNull();
  });
});
