import type { Request, Response } from 'express';
import { getCabinetSnapshots } from './cabinet.mock';
import { connectionsData } from './connection.mock';
import { devicesData } from './device.mock';

const waitTime = (time: number = 100) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve(true);
        }, time);
    });
};

const categoryMeta: Record<string, { label: string; color: string }> = {
    switch: { label: '交换机', color: '#1890ff' },
    router: { label: '路由器', color: '#13c2c2' },
    server: { label: '服务器', color: '#52c41a' },
    storage: { label: '存储', color: '#faad14' },
    firewall: { label: '防火墙', color: '#f5222d' },
    loadbalancer: { label: '负载均衡', color: '#722ed1' },
    other: { label: '其他', color: '#8c8c8c' },
};

const templateCategoryMap: Record<string, string> = {
    'tpl-huawei-s5735-48t4x': 'switch',
    'tpl-huawei-s6730-48x6c': 'switch',
    'tpl-huawei-ce6881-48s6cq': 'switch',
    'tpl-cisco-c9300-48p': 'switch',
    'tpl-cisco-n9k-93180yc': 'switch',
    'tpl-h3c-s6850-56hf': 'switch',
    'tpl-ruijie-s6220-48xs6qxs': 'switch',
    'tpl-huawei-2288h-v6': 'server',
    'tpl-dell-r750': 'server',
    'tpl-hpe-dl380-gen10': 'server',
    'tpl-inspur-nf5280m6': 'server',
    'tpl-huawei-ne40e-x8': 'router',
    'tpl-cisco-asr-9000': 'router',
    'tpl-huawei-oceanstor-5500': 'storage',
    'tpl-huawei-usg6680': 'firewall',
    'tpl-f5-big-ip-i5800': 'loadbalancer',
};

const datacenters = [
    { datacenterId: 'dc-001', name: '北京亦庄' },
    { datacenterId: 'dc-002', name: '上海嘉定' },
    { datacenterId: 'dc-003', name: '深圳坪山' },
    { datacenterId: 'dc-004', name: '成都天府' },
];

const getDatacenterIdByCabinetId = (cabinetId: string) => {
    if (cabinetId.startsWith('cab-bj-')) return 'dc-001';
    if (cabinetId.startsWith('cab-sh-')) return 'dc-002';
    if (cabinetId.startsWith('cab-sz-')) return 'dc-003';
    if (cabinetId.startsWith('cab-cd-')) return 'dc-004';
    return undefined;
};

const roundRatio = (value: number) => Math.round(value * 100) / 100;

const getDashboardStatsSnapshot = (): IDC.DashboardStats => {
    const cabinets = getCabinetSnapshots();
    const totalU = cabinets.reduce((sum, cabinet) => sum + cabinet.uHeight, 0);
    const usedU = cabinets.reduce((sum, cabinet) => sum + cabinet.usedU, 0);

    return {
        datacenterCount: datacenters.length,
        cabinetCount: cabinets.length,
        deviceCount: devicesData.length,
        connectionCount: connectionsData.length,
        onlineDevices: devicesData.filter(d => d.status === 'online').length,
        offlineDevices: devicesData.filter(d => d.status === 'offline').length,
        warningDevices: devicesData.filter(d => d.status === 'warning').length,
        errorDevices: devicesData.filter(d => d.status === 'error').length,
        cabinetUsageRate: cabinets.length
            ? roundRatio(cabinets.filter(c => c.usedU > 0).length / cabinets.length)
            : 0,
        uUsageRate: totalU ? roundRatio(usedU / totalU) : 0,
        recentAlerts: [
            {
                id: 'alert-001',
                level: 'warning',
                type: 'port_usage',
                deviceId: 'dev-010',
                deviceName: '核心交换机-B1',
                message: '端口利用率超过80%',
                createdAt: '2024-12-05T09:00:00Z',
                acknowledged: false,
            },
            {
                id: 'alert-002',
                level: 'info',
                type: 'maintenance',
                deviceId: 'dev-008',
                deviceName: '核心存储-1',
                message: '计划维护：存储系统固件升级',
                createdAt: '2024-12-04T14:30:00Z',
                acknowledged: true,
                acknowledgedAt: '2024-12-04T15:00:00Z',
                acknowledgedBy: '周存储',
            },
        ],
    };
};

const getDeviceCategorySnapshot = () => {
    const counts = devicesData.reduce<Record<string, number>>((acc, device) => {
        const category = templateCategoryMap[device.templateId] || 'other';
        acc[category] = (acc[category] || 0) + 1;
        return acc;
    }, {});

    return Object.entries(counts).map(([category, count]) => ({
        category,
        label: categoryMeta[category]?.label || category,
        count,
        color: categoryMeta[category]?.color || categoryMeta.other.color,
    }));
};

const getDatacenterLoadSnapshot = () => {
    const cabinets = getCabinetSnapshots();

    return datacenters.map((datacenter) => {
        const dcCabinets = cabinets.filter(cabinet => cabinet.datacenterId === datacenter.datacenterId);
        const currentPower = dcCabinets.reduce((sum, cabinet) => sum + cabinet.currentPower, 0);
        const maxPower = dcCabinets.reduce((sum, cabinet) => sum + cabinet.maxPower, 0);

        return {
            ...datacenter,
            cabinetUsage: dcCabinets.length
                ? roundRatio(dcCabinets.filter(c => c.usedU > 0).length / dcCabinets.length)
                : 0,
            powerUsage: maxPower ? roundRatio(currentPower / maxPower) : 0,
            deviceCount: devicesData.filter(d => getDatacenterIdByCabinetId(d.cabinetId) === datacenter.datacenterId).length,
        };
    });
};

export default {
    'GET /api/idc/dashboard/stats': async (_req: Request, res: Response) => {
        await waitTime(300);
        res.json({ success: true, data: getDashboardStatsSnapshot() });
    },

    'GET /api/idc/dashboard/device-trend': async (req: Request, res: Response) => {
        await waitTime(300);
        const { days = 7 } = req.query;
        const stats = getDashboardStatsSnapshot();

        const data = Array.from({ length: Number(days) }, (_, i) => {
            const date = new Date();
            date.setDate(date.getDate() - (Number(days) - 1 - i));
            return {
                date: date.toISOString().split('T')[0],
                online: stats.onlineDevices,
                offline: stats.offlineDevices,
                warning: stats.warningDevices,
                error: stats.errorDevices,
            };
        });

        res.json({ success: true, data });
    },

    'GET /api/idc/dashboard/cabinet-usage-rank': async (req: Request, res: Response) => {
        await waitTime(300);
        const { limit = 10 } = req.query;
        const data = getCabinetSnapshots()
            .map(cabinet => ({
                cabinetId: cabinet.id,
                cabinetName: cabinet.name,
                usage: cabinet.uHeight ? roundRatio(cabinet.usedU / cabinet.uHeight) : 0,
            }))
            .sort((left, right) => right.usage - left.usage)
            .slice(0, Number(limit));

        res.json({ success: true, data });
    },

    'GET /api/idc/dashboard/device-category': async (_req: Request, res: Response) => {
        await waitTime(200);
        res.json({ success: true, data: getDeviceCategorySnapshot() });
    },

    'GET /api/idc/dashboard/datacenter-load': async (_req: Request, res: Response) => {
        await waitTime(200);
        res.json({ success: true, data: getDatacenterLoadSnapshot() });
    },

    'GET /api/idc/dashboard/recent-operations': async (req: Request, res: Response) => {
        await waitTime(200);
        const { limit = 10 } = req.query;
        const data = [
            {
                id: 'op-001',
                type: 'device_mount',
                operator: '钱AI',
                target: 'GPU服务器-C1-1',
                description: '设备上架',
                createdAt: '2024-12-05T10:30:00Z',
            },
            {
                id: 'op-002',
                type: 'port_config',
                operator: '张运维',
                target: '接入交换机-A1-1 GE1/0/24',
                description: 'VLAN配置变更: Access VLAN 100 -> 102',
                createdAt: '2024-12-05T09:15:00Z',
            },
            {
                id: 'op-003',
                type: 'connection_create',
                operator: '张运维',
                target: 'BJ-CAT6A-005',
                description: '创建网络连线',
                createdAt: '2024-12-04T16:20:00Z',
            },
        ].slice(0, Number(limit));

        res.json({ success: true, data });
    },

    'POST /api/idc/dashboard/alerts/:id/acknowledge': async (req: Request, res: Response) => {
        await waitTime(300);
        const { id } = req.params;

        res.json({
            success: true,
            message: `告警 ${id} 已确认`,
        });
    },

    'GET /api/idc/topology/:datacenterId': async (req: Request, res: Response) => {
        await waitTime(500);
        const { datacenterId } = req.params;
        const nodes = devicesData
            .filter(device => getDatacenterIdByCabinetId(device.cabinetId) === datacenterId)
            .map((device, index) => ({
                id: device.id,
                label: device.name,
                type: templateCategoryMap[device.templateId] || 'other',
                status: device.status,
                x: 160 + (index % 4) * 160,
                y: 120 + Math.floor(index / 4) * 140,
            }));

        const edges = connectionsData
            .filter(connection =>
                nodes.some(node => node.id === connection.sourceDeviceId) &&
                nodes.some(node => node.id === connection.targetDeviceId),
            )
            .map(connection => ({
                source: connection.sourceDeviceId,
                target: connection.targetDeviceId,
                type: connection.connectionType,
            }));

        res.json({
            success: true,
            data: {
                datacenterId,
                nodes,
                edges,
            },
        });
    },
};
