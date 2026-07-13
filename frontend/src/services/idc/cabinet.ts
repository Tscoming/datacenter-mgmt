import { request } from '@umijs/max';
import type { CabinetTelemetry, CabinetTelemetrySourceConfig } from './telemetry';

/** 获取机柜列表 */
export async function getCabinets(
    params?: IDC.PageParams & {
        datacenterId?: string;
        name?: string;
        status?: string;
        code?: string;
    },
) {
    return request<IDC.PageResult<IDC.Cabinet>>('/api/idc/cabinets', {
        method: 'GET',
        params,
    });
}

/** 获取单个机柜 */
export async function getCabinet(id: string) {
    return request<IDC.ApiResponse<IDC.Cabinet>>(`/api/idc/cabinets/${id}`, {
        method: 'GET',
    });
}

/** 创建机柜 */
export async function createCabinet(data: IDC.CabinetCreateParams) {
    return request<IDC.ApiResponse<IDC.Cabinet>>('/api/idc/cabinets', {
        method: 'POST',
        data,
    });
}

/** 更新机柜 */
export async function updateCabinet(id: string, data: Partial<IDC.Cabinet>) {
    return request<IDC.ApiResponse<IDC.Cabinet>>(`/api/idc/cabinets/${id}`, {
        method: 'PUT',
        data,
    });
}

/** 删除机柜 */
export async function deleteCabinet(id: string) {
    return request<IDC.ApiResponse>(`/api/idc/cabinets/${id}`, {
        method: 'DELETE',
    });
}

/** 获取数据中心下的所有机柜 */
export async function getCabinetsByDatacenter(datacenterId: string) {
    return request<IDC.ApiResponse<IDC.Cabinet[]>>(
        `/api/idc/cabinets/by-datacenter/${datacenterId}`,
        {
            method: 'GET',
        },
    );
}

/** 获取机柜U位使用情况 */
export async function getCabinetUUsage(id: string) {
    return request<IDC.ApiResponse<{
        cabinetId: string;
        uHeight: number;
        usedU: number;
        availableU: number;
        uSlots: { u: number; deviceId: string | null; deviceName: string | null }[];
    }>>(`/api/idc/cabinets/${id}/u-usage`, {
        method: 'GET',
    });
}

/** 获取机柜遥测采集配置 */
export async function getCabinetTelemetrySource(id: string) {
    return request<IDC.ApiResponse<CabinetTelemetrySourceConfig | null>>(
        `/api/idc/cabinets/${id}/telemetry-source`,
        { method: 'GET' },
    );
}

/** 单独保存机柜遥测采集配置 */
export async function saveCabinetTelemetrySource(
    id: string,
    data: Omit<CabinetTelemetrySourceConfig, 'cabinetId'>,
) {
    return request<IDC.ApiResponse<CabinetTelemetrySourceConfig>>(
        `/api/idc/cabinets/${id}/telemetry-source`,
        { method: 'PUT', data },
    );
}

/** 使用当前表单配置单次测试机柜遥测采集，不保存配置 */
export async function testCabinetTelemetrySource(
    id: string,
    data: Omit<CabinetTelemetrySourceConfig, 'cabinetId'>,
) {
    return request<IDC.ApiResponse<CabinetTelemetry>>(
        `/api/idc/cabinets/${id}/telemetry-source/test`,
        { method: 'POST', data },
    );
}

/** 删除机柜遥测采集配置 */
export async function deleteCabinetTelemetrySource(id: string) {
    return request<IDC.ApiResponse<{ deleted: boolean }>>(
        `/api/idc/cabinets/${id}/telemetry-source`,
        { method: 'DELETE' },
    );
}
