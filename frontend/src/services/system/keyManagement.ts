import { request } from '@umijs/max';

export type ManagedKey = {
  id: string;
  label: string;
  keyType: 'RSA' | 'ED25519' | 'ECDSA' | 'OTHER';
  publicKey?: string;
  privateKey?: string;
  certificate?: string;
  description?: string;
  hasPrivateKey: boolean;
  createdBy: string;
  updatedBy: string;
  createdAt: string;
  updatedAt: string;
};

export type ManagedKeyPayload = {
  label: string;
  keyType: ManagedKey['keyType'];
  privateKey?: string;
  publicKey?: string;
  certificate?: string;
  description?: string;
};

export type GenerateManagedKeyPayload = {
  label: string;
  keyType: Exclude<ManagedKey['keyType'], 'OTHER'>;
  passphrase?: string;
};

const verifiedOptions = (verificationToken: string) => ({
  headers: { 'X-Key-Management-Token': verificationToken },
});

export async function verifyKeyManagement(password: string) {
  return request<{
    success: boolean;
    data: { verificationToken: string; expiresAt: number };
  }>('/api/key-management/verify', {
    method: 'POST',
    data: { password },
  });
}

export async function getManagedKeys(
  verificationToken: string,
  keyword?: string,
) {
  return request<{ success: boolean; data: ManagedKey[] }>(
    '/api/key-management/keys',
    {
      method: 'GET',
      params: { keyword },
      ...verifiedOptions(verificationToken),
    },
  );
}

export async function getManagedKey(id: string, verificationToken: string) {
  return request<{ success: boolean; data: ManagedKey }>(
    `/api/key-management/keys/${id}`,
    {
      method: 'GET',
      ...verifiedOptions(verificationToken),
    },
  );
}

export async function createManagedKey(
  data: ManagedKeyPayload,
  verificationToken: string,
) {
  return request<{ success: boolean; data: ManagedKey }>(
    '/api/key-management/keys',
    {
      method: 'POST',
      data,
      ...verifiedOptions(verificationToken),
    },
  );
}

export async function generateManagedKey(
  data: GenerateManagedKeyPayload,
  verificationToken: string,
) {
  return request<{ success: boolean; data: ManagedKey }>(
    '/api/key-management/keys/generate',
    {
      method: 'POST',
      data,
      ...verifiedOptions(verificationToken),
    },
  );
}

export async function updateManagedKey(
  id: string,
  data: ManagedKeyPayload,
  verificationToken: string,
) {
  return request<{ success: boolean; data: ManagedKey }>(
    `/api/key-management/keys/${id}`,
    {
      method: 'PUT',
      data,
      ...verifiedOptions(verificationToken),
    },
  );
}

export async function deleteManagedKey(id: string, verificationToken: string) {
  return request<{ success: boolean; data: Record<string, never> }>(
    `/api/key-management/keys/${id}`,
    {
      method: 'DELETE',
      ...verifiedOptions(verificationToken),
    },
  );
}
