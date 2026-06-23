import { request } from '@umijs/max';

export async function getUsers(params?: API.ManagedUserParams) {
  return request<{
    data: API.ManagedUser[];
    total: number;
    success: boolean;
  }>('/api/users', {
    method: 'GET',
    params,
  });
}

export async function getUser(id: string) {
  return request<{ data: API.ManagedUser; success: boolean }>(
    `/api/users/${id}`,
    {
      method: 'GET',
    },
  );
}

export async function createUser(data: API.ManagedUserPayload) {
  return request<{ data: API.ManagedUser; success: boolean }>('/api/users', {
    method: 'POST',
    data,
  });
}

export async function updateUser(
  id: string,
  data: Partial<API.ManagedUserPayload>,
) {
  return request<{ data: API.ManagedUser; success: boolean }>(
    `/api/users/${id}`,
    {
      method: 'PUT',
      data,
    },
  );
}

export async function deleteUser(id: string) {
  return request<{ data: Record<string, never>; success: boolean }>(
    `/api/users/${id}`,
    {
      method: 'DELETE',
    },
  );
}
