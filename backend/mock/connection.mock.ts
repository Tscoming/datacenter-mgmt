import type { Request, Response } from 'express';
import { devicesData } from './device.mock';
import { uuidv4 } from './utils';

// Mock 连线数据
export let connectionsData: IDC.Connection[] = [
    // 核心交换机到接入交换机
    {
        id: 'conn-001',
        cableNumber: 'BJ-FIBER-001',
        connectionType: 'network',
        cableType: 'SingleModeFiber',
        cableColor: '#3498db',
        cableLength: 3,
        sourceDeviceId: 'dev-001',
        sourcePortId: 'port-dev-001-sfp-1',
        targetDeviceId: 'dev-002',
        targetPortId: 'port-dev-002-sfp-1',
        status: 'active',
        description: '核心到接入上联-1',
        createdAt: '2023-02-25T08:00:00Z',
        updatedAt: '2024-12-01T10:00:00Z',
    },
    {
        id: 'conn-002',
        cableNumber: 'BJ-FIBER-002',
        connectionType: 'network',
        cableType: 'SingleModeFiber',
        cableColor: '#3498db',
        cableLength: 3,
        sourceDeviceId: 'dev-001',
        sourcePortId: 'port-dev-001-sfp-2',
        targetDeviceId: 'dev-002',
        targetPortId: 'port-dev-002-sfp-2',
        status: 'active',
        description: '核心到接入上联-2',
        createdAt: '2023-02-25T08:00:00Z',
        updatedAt: '2024-12-01T10:00:00Z',
    },
    // 接入交换机到服务器
    {
        id: 'conn-003',
        cableNumber: 'BJ-CAT6A-001',
        connectionType: 'network',
        cableType: 'Cat6a',
        cableColor: '#2ecc71',
        cableLength: 2,
        sourceDeviceId: 'dev-002',
        sourcePortId: 'port-dev-002-rj45-1',
        targetDeviceId: 'dev-003',
        targetPortId: 'port-dev-003-eth-1',
        status: 'active',
        description: '服务器A1-1业务网络',
        createdAt: '2023-03-20T08:00:00Z',
        updatedAt: '2024-11-20T14:00:00Z',
    },
    {
        id: 'conn-004',
        cableNumber: 'BJ-CAT6A-002',
        connectionType: 'network',
        cableType: 'Cat6a',
        cableColor: '#2ecc71',
        cableLength: 2,
        sourceDeviceId: 'dev-002',
        sourcePortId: 'port-dev-002-rj45-2',
        targetDeviceId: 'dev-003',
        targetPortId: 'port-dev-003-eth-2',
        status: 'active',
        description: '服务器A1-1管理网络',
        createdAt: '2023-03-20T08:00:00Z',
        updatedAt: '2024-11-20T14:00:00Z',
    },
    {
        id: 'conn-005',
        cableNumber: 'BJ-CAT6A-003',
        connectionType: 'network',
        cableType: 'Cat6a',
        cableColor: '#2ecc71',
        cableLength: 2,
        sourceDeviceId: 'dev-002',
        sourcePortId: 'port-dev-002-rj45-3',
        targetDeviceId: 'dev-004',
        targetPortId: 'port-dev-004-eth-1',
        status: 'active',
        description: '服务器A1-2业务网络',
        createdAt: '2023-03-20T08:00:00Z',
        updatedAt: '2024-11-20T14:00:00Z',
    },
    {
        id: 'conn-006',
        cableNumber: 'BJ-CAT6A-004',
        connectionType: 'network',
        cableType: 'Cat6a',
        cableColor: '#2ecc71',
        cableLength: 2,
        sourceDeviceId: 'dev-002',
        sourcePortId: 'port-dev-002-rj45-4',
        targetDeviceId: 'dev-005',
        targetPortId: 'port-dev-005-eth-1',
        status: 'active',
        description: '数据库服务器业务网络',
        createdAt: '2023-04-10T08:00:00Z',
        updatedAt: '2024-10-15T16:00:00Z',
    },
    // 防火墙到负载均衡
    {
        id: 'conn-007',
        cableNumber: 'BJ-FIBER-003',
        connectionType: 'network',
        cableType: 'MultiModeFiber',
        cableColor: '#e67e22',
        cableLength: 5,
        sourceDeviceId: 'dev-006',
        sourcePortId: 'port-dev-006-sfp-1',
        targetDeviceId: 'dev-007',
        targetPortId: 'port-dev-007-sfp-1',
        status: 'active',
        description: '防火墙到负载均衡',
        createdAt: '2023-02-10T08:00:00Z',
        updatedAt: '2024-11-28T11:00:00Z',
    },
    // 存储连线
    {
        id: 'conn-008',
        cableNumber: 'BJ-ISCSI-001',
        connectionType: 'storage',
        cableType: 'Cat6a',
        cableColor: '#9b59b6',
        cableLength: 10,
        sourceDeviceId: 'dev-005',
        sourcePortId: 'port-dev-005-eth-2',
        targetDeviceId: 'dev-008',
        targetPortId: 'port-dev-008-iscsi-1',
        status: 'active',
        description: '数据库到存储iSCSI连接',
        createdAt: '2023-05-15T08:00:00Z',
        updatedAt: '2024-09-20T09:00:00Z',
    },
    // 跨机柜连线
    {
        id: 'conn-009',
        cableNumber: 'BJ-FIBER-004',
        connectionType: 'network',
        cableType: 'SingleModeFiber',
        cableColor: '#3498db',
        cableLength: 15,
        sourceDeviceId: 'dev-001',
        sourcePortId: 'port-dev-001-sfp-3',
        targetDeviceId: 'dev-006',
        targetPortId: 'port-dev-006-sfp-2',
        status: 'active',
        description: '核心交换机到防火墙',
        createdAt: '2023-02-10T08:00:00Z',
        updatedAt: '2024-12-01T10:00:00Z',
    },
    // 管理连线
    {
        id: 'conn-010',
        cableNumber: 'BJ-MGMT-001',
        connectionType: 'management',
        cableType: 'Cat6',
        cableColor: '#27ae60',
        cableLength: 3,
        sourceDeviceId: 'dev-002',
        sourcePortId: 'port-dev-002-rj45-47',
        targetDeviceId: 'dev-003',
        targetPortId: 'port-dev-003-mgmt',
        status: 'active',
        description: '服务器IPMI管理',
        createdAt: '2023-03-20T08:00:00Z',
        updatedAt: '2024-11-20T14:00:00Z',
    },
];

const waitTime = (time: number = 100) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve(true);
        }, time);
    });
};

const getDatacenterIdByCabinetId = (cabinetId: string) => {
    if (cabinetId.startsWith('cab-bj-')) return 'dc-001';
    if (cabinetId.startsWith('cab-sh-')) return 'dc-002';
    if (cabinetId.startsWith('cab-sz-')) return 'dc-003';
    if (cabinetId.startsWith('cab-cd-')) return 'dc-004';
    return undefined;
};

const getDeviceDatacenterId = (deviceId: string) => {
    const device = devicesData.find(d => d.id === deviceId);
    return device ? getDatacenterIdByCabinetId(device.cabinetId) : undefined;
};

const findPortConflict = (
    sourcePortId: string,
    targetPortId: string,
    excludedConnectionId?: string,
) => {
    if (!sourcePortId || !targetPortId || sourcePortId === targetPortId) {
        return { portId: sourcePortId || targetPortId, connection: undefined };
    }

    const portIds = new Set([sourcePortId, targetPortId]);
    const connection = connectionsData.find(
        item =>
            item.id !== excludedConnectionId &&
            (portIds.has(item.sourcePortId) || portIds.has(item.targetPortId)),
    );
    if (!connection) return undefined;

    return {
        portId: portIds.has(connection.sourcePortId)
            ? connection.sourcePortId
            : connection.targetPortId,
        connection,
    };
};

export default {
    // 获取连线列表
    'GET /api/idc/connections': async (req: Request, res: Response) => {
        await waitTime(300);
        const {
            current = 1,
            pageSize = 10,
            connectionType,
            cableType,
            sourceDeviceId,
            targetDeviceId,
            status,
            cableNumber,
        } = req.query;

        let filteredData = [...connectionsData];

        if (connectionType) {
            filteredData = filteredData.filter(c => c.connectionType === connectionType);
        }
        if (cableType) {
            filteredData = filteredData.filter(c => c.cableType === cableType);
        }
        if (sourceDeviceId) {
            filteredData = filteredData.filter(c => c.sourceDeviceId === sourceDeviceId);
        }
        if (targetDeviceId) {
            filteredData = filteredData.filter(c => c.targetDeviceId === targetDeviceId);
        }
        if (status) {
            filteredData = filteredData.filter(c => c.status === status);
        }
        if (cableNumber) {
            filteredData = filteredData.filter(c => c.cableNumber.includes(cableNumber as string));
        }

        const start = (Number(current) - 1) * Number(pageSize);
        const end = start + Number(pageSize);
        const paginatedData = filteredData.slice(start, end);

        res.json({
            success: true,
            data: paginatedData,
            total: filteredData.length,
            current: Number(current),
            pageSize: Number(pageSize),
        });
    },

    // 获取单条连线
    'GET /api/idc/connections/:id': async (req: Request, res: Response) => {
        await waitTime(200);
        const { id } = req.params;
        const connection = connectionsData.find(c => c.id === id);

        if (connection) {
            res.json({ success: true, data: connection });
        } else {
            res.status(404).json({ success: false, errorMessage: '连线不存在' });
        }
    },

    // 创建连线
    'POST /api/idc/connections': async (req: Request, res: Response) => {
        await waitTime(500);
        const body = req.body as IDC.ConnectionCreateParams;
        const conflict = findPortConflict(body.sourcePortId, body.targetPortId);
        if (conflict) {
            res.status(409).json({
                success: false,
                errorMessage: conflict.connection
                    ? `端口 ${conflict.portId} 已被连线 ${conflict.connection.cableNumber}（${conflict.connection.id}）占用`
                    : '源端口和目标端口必须是两个不同的有效端口',
            });
            return;
        }

        const newConnection: IDC.Connection = {
            id: `conn-${uuidv4().slice(0, 8)}`,
            cableNumber: body.cableNumber,
            connectionType: body.connectionType,
            cableType: body.cableType,
            cableColor: body.cableColor || '#3498db',
            cableLength: body.cableLength,
            sourceDeviceId: body.sourceDeviceId,
            sourcePortId: body.sourcePortId,
            targetDeviceId: body.targetDeviceId,
            targetPortId: body.targetPortId,
            status: 'active',
            description: body.description,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
        };

        connectionsData.push(newConnection);
        res.json({ success: true, data: newConnection });
    },

    // 更新连线
    'PUT /api/idc/connections/:id': async (req: Request, res: Response) => {
        await waitTime(400);
        const { id } = req.params;
        const body = req.body;

        const index = connectionsData.findIndex(c => c.id === id);
        if (index === -1) {
            res.status(404).json({ success: false, errorMessage: '连线不存在' });
            return;
        }

        const current = connectionsData[index];
        const sourcePortId = body.sourcePortId ?? current.sourcePortId;
        const targetPortId = body.targetPortId ?? current.targetPortId;
        const conflict = findPortConflict(sourcePortId, targetPortId, current.id);
        if (conflict) {
            res.status(409).json({
                success: false,
                errorMessage: conflict.connection
                    ? `端口 ${conflict.portId} 已被连线 ${conflict.connection.cableNumber}（${conflict.connection.id}）占用`
                    : '源端口和目标端口必须是两个不同的有效端口',
            });
            return;
        }

        connectionsData[index] = {
            ...connectionsData[index],
            ...body,
            updatedAt: new Date().toISOString(),
        };

        res.json({ success: true, data: connectionsData[index] });
    },

    // 删除连线
    'DELETE /api/idc/connections/:id': async (req: Request, res: Response) => {
        await waitTime(300);
        const { id } = req.params;

        const index = connectionsData.findIndex(c => c.id === id);
        if (index === -1) {
            res.status(404).json({ success: false, errorMessage: '连线不存在' });
            return;
        }

        connectionsData.splice(index, 1);
        res.json({ success: true });
    },

    // 获取设备的连线（3D视图用）
    'GET /api/idc/connections/by-device/:deviceId': async (req: Request, res: Response) => {
        await waitTime(200);
        const { deviceId } = req.params;
        const deviceConnections = connectionsData.filter(
            c => c.sourceDeviceId === deviceId || c.targetDeviceId === deviceId
        );

        res.json({
            success: true,
            data: deviceConnections,
        });
    },

    // 获取数据中心的所有连线（3D视图用）
    'GET /api/idc/connections/by-datacenter/:datacenterId': async (req: Request, res: Response) => {
        await waitTime(300);
        const { datacenterId } = req.params;
        const dcConnections = connectionsData.filter(c =>
            getDeviceDatacenterId(c.sourceDeviceId) === datacenterId ||
            getDeviceDatacenterId(c.targetDeviceId) === datacenterId
        );

        res.json({
            success: true,
            data: dcConnections,
        });
    },

    // 连线类型选项
    'GET /api/idc/connection-types': async (_req: Request, res: Response) => {
        await waitTime(100);
        res.json({
            success: true,
            data: [
                { value: 'network', label: '网络连线', color: '#3498db' },
                { value: 'power', label: '电源连线', color: '#e74c3c' },
                { value: 'management', label: '管理连线', color: '#27ae60' },
                { value: 'storage', label: '存储连线', color: '#9b59b6' },
                { value: 'stack', label: '堆叠连线', color: '#f39c12' },
            ],
        });
    },

    // 线缆类型选项
    'GET /api/idc/cable-types': async (_req: Request, res: Response) => {
        await waitTime(100);
        res.json({
            success: true,
            data: [
                { value: 'Cat5e', label: 'Cat5e网线' },
                { value: 'Cat6', label: 'Cat6网线' },
                { value: 'Cat6a', label: 'Cat6a网线' },
                { value: 'Cat7', label: 'Cat7网线' },
                { value: 'SingleModeFiber', label: '单模光纤' },
                { value: 'MultiModeFiber', label: '多模光纤' },
                { value: 'DAC', label: 'DAC高速铜缆' },
                { value: 'AOC', label: 'AOC有源光缆' },
                { value: 'PowerCable', label: '电源线' },
            ],
        });
    },

    // 连线统计
    'GET /api/idc/connections/stats': async (_req: Request, res: Response) => {
        await waitTime(200);

        const stats = {
            total: connectionsData.length,
            active: connectionsData.filter(c => c.status === 'active').length,
            inactive: connectionsData.filter(c => c.status === 'inactive').length,
            faulty: connectionsData.filter(c => c.status === 'faulty').length,
            byType: {} as Record<string, number>,
            byCableType: {} as Record<string, number>,
        };

        connectionsData.forEach(c => {
            stats.byType[c.connectionType] = (stats.byType[c.connectionType] || 0) + 1;
            stats.byCableType[c.cableType] = (stats.byCableType[c.cableType] || 0) + 1;
        });

        res.json({ success: true, data: stats });
    },
};
