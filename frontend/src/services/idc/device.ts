import { request } from '@umijs/max';

export type DeviceSshBinding = {
    deviceId: string;
    keyId: string;
    keyLabel: string;
    keyType: string;
    username: string;
    port: number;
    updatedAt: string;
};

export type DeviceSshConnectionPayload = {
    keyId?: string;
    username?: string;
    port?: number;
    passphrase?: string;
};

export type DeviceSshTestResult = {
    connected: boolean;
    stage: 'network' | 'handshake' | 'authentication' | 'ready';
    host: string;
    port: number;
    username: string;
    keyLabel: string;
    keyType: string;
    elapsedMs: number;
    testedAt: string;
    serverFingerprint?: string;
    algorithms?: {
        kex?: string;
        serverHostKey?: string;
        cipherClientToServer?: string;
        cipherServerToClient?: string;
    };
    banner?: string;
    errorCode?: string;
    errorMessage?: string;
};

const keyManagementOptions = (verificationToken: string) => ({
    headers: { 'X-Key-Management-Token': verificationToken },
});

/** 获取设备列表 */
export async function getDevices(
    params?: IDC.PageParams & {
        cabinetId?: string;
        datacenterId?: string;
        templateId?: string;
        name?: string;
        status?: string;
        assetCode?: string;
        managementIp?: string;
        department?: string;
        isMounted?: string; // "true" / "false" / ""
        keyword?: string;
    },
) {
    return request<IDC.PageResult<IDC.Device>>('/api/idc/devices', {
        method: 'GET',
        params,
    });
}

/** 获取单个设备 */
export async function getDevice(id: string) {
    return request<IDC.ApiResponse<IDC.Device>>(`/api/idc/devices/${id}`, {
        method: 'GET',
    });
}

/** 创建设备（上架） */
export async function createDevice(data: IDC.DeviceCreateParams) {
    return request<IDC.ApiResponse<IDC.Device>>('/api/idc/devices', {
        method: 'POST',
        data,
    });
}

/** 更新设备 */
export async function updateDevice(id: string, data: Partial<IDC.Device>) {
    return request<IDC.ApiResponse<IDC.Device>>(`/api/idc/devices/${id}`, {
        method: 'PUT',
        data,
    });
}

/** 删除设备（下架） */
export async function deleteDevice(id: string) {
    return request<IDC.ApiResponse>(`/api/idc/devices/${id}`, {
        method: 'DELETE',
    });
}

/** 获取机柜内的设备 */
export async function getDevicesByCabinet(cabinetId: string) {
    return request<IDC.ApiResponse<IDC.Device[]>>(
        `/api/idc/devices/by-cabinet/${cabinetId}`,
        {
            method: 'GET',
        },
    );
}

/** 批量更新设备状态 */
export async function batchUpdateDeviceStatus(ids: string[], status: IDC.Device['status']) {
    return request<IDC.ApiResponse>('/api/idc/devices/batch-status', {
        method: 'POST',
        data: { ids, status },
    });
}

/** 获取设备统计 */
export async function getDeviceStats() {
    return request<IDC.ApiResponse<{
        total: number;
        online: number;
        offline: number;
        warning: number;
        error: number;
        maintenance: number;
        byCategory: Record<string, number>;
        byDepartment: Record<string, number>;
    }>>('/api/idc/devices/stats', {
        method: 'GET',
    });
}

/** 设备下架（保留数据） */
export async function unmountDevice(id: string) {
    return request<IDC.ApiResponse>(`/api/idc/devices/${id}/unmount`, {
        method: 'POST',
    });
}

export async function validateDeviceMount(data: IDC.DeviceMountValidationRequest) {
    return request<IDC.ApiResponse<IDC.DeviceMountValidationResult>>(
        '/api/idc/devices/validate-mount',
        {
            method: 'POST',
            data,
        },
    );
}

export async function getDeviceSshBinding(
    id: string,
    verificationToken: string,
) {
    return request<IDC.ApiResponse<DeviceSshBinding | null>>(
        `/api/idc/devices/${id}/ssh-binding`,
        {
            method: 'GET',
            ...keyManagementOptions(verificationToken),
        },
    );
}

export async function updateDeviceSshBinding(
    id: string,
    data: DeviceSshConnectionPayload,
    verificationToken: string,
) {
    return request<IDC.ApiResponse<DeviceSshBinding | null>>(
        `/api/idc/devices/${id}/ssh-binding`,
        {
            method: 'PUT',
            data,
            ...keyManagementOptions(verificationToken),
        },
    );
}

export async function testDeviceSsh(
    id: string,
    data: DeviceSshConnectionPayload,
    verificationToken: string,
) {
    return request<IDC.ApiResponse<DeviceSshTestResult>>(
        `/api/idc/devices/${id}/test-ssh`,
        {
            method: 'POST',
            data,
            ...keyManagementOptions(verificationToken),
        },
    );
}
