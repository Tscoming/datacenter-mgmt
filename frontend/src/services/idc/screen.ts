import dayjs from 'dayjs';

export interface ScreenTimePoint {
  time: string;
  value: number;
  type?: string;
}

export interface ScreenCategoryPoint {
  name: string;
  value: number;
}

export interface ScreenCabinetStatusPoint {
  cabinetId: string;
  cabinetName: string;
  usage: number;
  status: 'normal' | 'warning' | 'error' | 'offline';
}

export interface DigitalTwinScreenData {
  overview: {
    pue: number;
    totalPowerKw: number;
    coolingPowerKw: number;
    itPowerKw: number;
    avgTemperature: number;
    avgHumidity: number;
    deviceTotal: number;
    online: number;
    warning: number;
    offline: number;
  };
  datacenter: IDC.Datacenter;
  layout: IDC.DatacenterLayout;
  cabinets: IDC.Cabinet[];
  devices: IDC.Device[];
  cabinetEnvironments: IDC.CabinetEnvironment[];
  alerts: IDC.AlertDetail[];
  charts: {
    cpuUsage: ScreenTimePoint[];
    memoryUsage: ScreenCategoryPoint[];
    temperatureByZone: ScreenCategoryPoint[];
    networkTraffic: ScreenTimePoint[];
    powerTrend: ScreenTimePoint[];
    cabinetStatus: ScreenCabinetStatusPoint[];
  };
}

const now = dayjs();

const datacenter: IDC.Datacenter = {
  id: 'dc-screen-001',
  name: '机房数字孪生监控平台',
  code: 'DC-SCREEN-001',
  address: 'A座核心机房',
  area: 1680,
  totalCabinets: 12,
  usedCabinets: 10,
  status: 'active',
  contact: 'NOC',
  phone: '400-800-1024',
  createdAt: now.subtract(300, 'day').toISOString(),
  updatedAt: now.toISOString(),
};

const cabinetSeeds = [
  ['cab-a-01', 'A-01', 'A-01', 1, 1, 'normal', 31, 7600],
  ['cab-a-02', 'A-02', 'A-02', 1, 2, 'normal', 34, 8300],
  ['cab-a-03', 'A-03', 'A-03', 1, 3, 'warning', 39, 9600],
  ['cab-a-04', 'A-04', 'A-04', 1, 4, 'normal', 25, 6400],
  ['cab-a-05', 'A-05', 'A-05', 1, 5, 'normal', 29, 7100],
  ['cab-b-01', 'B-01', 'B-01', 2, 1, 'normal', 28, 6900],
  ['cab-b-02', 'B-02', 'B-02', 2, 2, 'warning', 37, 9100],
  ['cab-b-03', 'B-03', 'B-03', 2, 3, 'normal', 30, 7200],
  ['cab-b-04', 'B-04', 'B-04', 2, 4, 'normal', 23, 5500],
  ['cab-b-05', 'B-05', 'B-05', 2, 5, 'normal', 33, 6600],
  ['cab-c-01', 'C-01', 'C-01', 3, 1, 'offline', 16, 1200],
  ['cab-c-02', 'C-02', 'C-02', 3, 2, 'normal', 26, 5800],
] as const;

const cabinets: IDC.Cabinet[] = cabinetSeeds.map(
  ([id, name, code, row, column, status, usedU, currentPower]) => ({
    id,
    datacenterId: datacenter.id,
    datacenterName: datacenter.name,
    name,
    code,
    row,
    column,
    uHeight: 42,
    usedU,
    maxPower: 10000,
    currentPower,
    status,
    createdAt: now.subtract(250, 'day').toISOString(),
    updatedAt: now.toISOString(),
  }),
);

const layout: IDC.DatacenterLayout = {
  datacenterId: datacenter.id,
  version: 1,
  canvasWidth: 60,
  canvasHeight: 40,
  pxPerMeter: 50,
  cabinets: [
    { cabinetId: 'cab-b-04', x: 24.8, y: 17.8, rotation: 176 },
    { cabinetId: 'cab-b-05', x: 27.4, y: 17.65, rotation: 180 },
    { cabinetId: 'cab-c-01', x: 30.55, y: 17.45, rotation: 182 },
    { cabinetId: 'cab-c-02', x: 33.05, y: 17.55, rotation: 183 },
    { cabinetId: 'cab-a-03', x: 25.8, y: 20.3, rotation: 180 },
    { cabinetId: 'cab-a-04', x: 28.2, y: 20.25, rotation: 180 },
    { cabinetId: 'cab-a-05', x: 30.7, y: 20.12, rotation: 180 },
    { cabinetId: 'cab-b-01', x: 33.2, y: 20.05, rotation: 180 },
    { cabinetId: 'cab-a-01', x: 23.55, y: 22.55, rotation: 178 },
    { cabinetId: 'cab-a-02', x: 26.2, y: 22.45, rotation: 180 },
    { cabinetId: 'cab-b-02', x: 29.1, y: 22.4, rotation: 180 },
    { cabinetId: 'cab-b-03', x: 32.1, y: 22.35, rotation: 182 },
  ],
  zones: [
    {
      id: 'cold-aisle-1',
      name: '冷通道',
      type: 'cold_aisle',
      x: 23.4,
      y: 18.9,
      width: 10.4,
      height: 1.0,
      rotation: 0,
      color: 'rgba(0, 221, 255, 0.2)',
    },
    {
      id: 'hot-aisle-1',
      name: '热通道',
      type: 'hot_aisle',
      x: 23.5,
      y: 21.25,
      width: 10.5,
      height: 1.0,
      rotation: 0,
      color: 'rgba(255, 61, 113, 0.2)',
    },
  ],
  facilities: [
    {
      id: 'facility-camera-north',
      type: 'camera',
      name: '摄像头-北侧通道',
      x: 8,
      y: 4,
      height: 2.5,
      rotation: 45,
      pitch: -18,
    },
    {
      id: 'facility-camera-south',
      type: 'camera',
      name: '摄像头-南侧通道',
      x: 52,
      y: 36,
      height: 2.5,
      rotation: 225,
      pitch: -24,
    },
    {
      id: 'facility-extinguisher-west',
      type: 'fire_extinguisher',
      name: '灭火器-西侧立柱',
      x: 6,
      y: 20,
      rotation: 0,
    },
    {
      id: 'facility-extinguisher-east',
      type: 'fire_extinguisher',
      name: '灭火器-东侧立柱',
      x: 54,
      y: 20,
      rotation: 0,
    },
    { id: 'facility-access-main', type: 'door', name: '门禁-主入口', x: 30, y: 1.2, rotation: 0 },
    { id: 'facility-temp-sensor-a', type: 'sensor', name: '温湿度传感器-A区', x: 18, y: 16, rotation: 0 },
  ],
  updatedAt: now.toISOString(),
};

const devices: IDC.Device[] = cabinets.flatMap((cabinet, cabinetIndex) => {
  const count = Math.max(4, Math.min(10, Math.round(cabinet.usedU / 4)));
  return Array.from({ length: count }, (_, index) => {
    const startU = 2 + index * 4;
    const status =
      cabinet.status === 'offline'
        ? 'offline'
        : cabinet.status === 'warning' && index === 1
          ? 'warning'
          : 'online';
    return {
      id: `dev-${cabinet.id}-${index + 1}`,
      templateId: index % 5 === 0 ? 'tpl-switch' : 'tpl-server',
      cabinetId: cabinet.id,
      assetCode: `${cabinet.code}-DEV-${String(index + 1).padStart(2, '0')}`,
      name: `${cabinet.code} 设备 ${index + 1}`,
      serialNumber: `SN${cabinetIndex}${index}${now.unix()}`,
      startU,
      endU: startU + (index % 3 === 0 ? 1 : 0),
      managementIp: `10.12.${cabinetIndex + 1}.${index + 10}`,
      status,
      vendor: index % 5 === 0 ? 'H3C' : 'Dell',
      owner: 'IDC运维',
      department: '基础设施部',
      createdAt: now.subtract(180, 'day').toISOString(),
      updatedAt: now.toISOString(),
    };
  });
});

const cabinetEnvironments: IDC.CabinetEnvironment[] = cabinets.map(
  (cabinet, index) => {
    const avgTemperature =
      cabinet.status === 'warning' ? 31 + (index % 2) : 23 + (index % 5);
    const status =
      cabinet.status === 'warning'
        ? 'warning'
        : cabinet.status === 'offline'
          ? 'critical'
          : 'normal';
    return {
      cabinetId: cabinet.id,
      cabinetName: cabinet.name,
      datacenterId: datacenter.id,
      datacenterName: datacenter.name,
      avgTemperature,
      maxTemperature: avgTemperature + 2.4,
      minTemperature: avgTemperature - 2.1,
      avgHumidity: 42 + (index % 7),
      status,
    };
  },
);

const alertSeeds: {
  level: IDC.Alert['level'];
  type: string;
  message: string;
  cabinetId: string;
  value: number;
}[] = [
  {
    level: 'warning',
    type: 'temperature',
    message: 'A-12机柜磁盘空间不足',
    cabinetId: 'cab-a-03',
    value: 45,
  },
  {
    level: 'warning',
    type: 'network',
    message: 'B-02网络延迟异常 (120ms)',
    cabinetId: 'cab-b-02',
    value: 120,
  },
  {
    level: 'error',
    type: 'power',
    message: 'UPS-01电池电量低于20%',
    cabinetId: 'cab-b-02',
    value: 18,
  },
  {
    level: 'warning',
    type: 'device_status',
    message: 'A-03机柜温度过高 (45℃)',
    cabinetId: 'cab-a-03',
    value: 45,
  },
  {
    level: 'warning',
    type: 'capacity',
    message: 'B-07服务器CPU使用率95%',
    cabinetId: 'cab-b-05',
    value: 95,
  },
];

const alerts: IDC.AlertDetail[] = alertSeeds.map((alert, index) => ({
  id: `screen-alert-${index + 1}`,
  level: alert.level,
  type: alert.type,
  message: alert.message,
  createdAt: now.subtract(index * 7 + 2, 'minute').toISOString(),
  acknowledged: false,
  source: 'system',
  cabinetId: alert.cabinetId,
  cabinetName: cabinets.find((cabinet) => cabinet.id === alert.cabinetId)?.name,
  datacenterId: datacenter.id,
  datacenterName: datacenter.name,
  value: alert.value,
}));

const hours = ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'];

const screenData: DigitalTwinScreenData = {
  overview: {
    pue: 1.45,
    totalPowerKw: 285.6,
    coolingPowerKw: 128.3,
    itPowerKw: 157.3,
    avgTemperature: 24.5,
    avgHumidity: 45,
    deviceTotal: devices.length,
    online: devices.filter((device) => device.status === 'online').length,
    warning: devices.filter((device) => device.status === 'warning').length,
    offline: devices.filter((device) => device.status === 'offline').length,
  },
  datacenter,
  layout,
  cabinets,
  devices,
  cabinetEnvironments,
  alerts,
  charts: {
    cpuUsage: hours.map((time, index) => ({
      time,
      value: [36, 65, 42, 22, 49, 51][index],
    })),
    memoryUsage: [
      { name: 'used', value: 70 },
      { name: 'free', value: 30 },
    ],
    temperatureByZone: [
      { name: 'A区', value: 24 },
      { name: 'B区', value: 24 },
      { name: 'C区', value: 34 },
      { name: 'D区', value: 20 },
    ],
    networkTraffic: hours.flatMap((time, index) => [
      { time, value: [340, 235, 210, 378, 330, 205][index], type: '入站' },
      { time, value: [178, 96, 102, 157, 166, 269][index], type: '出站' },
    ]),
    powerTrend: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'].map(
      (time, index) => ({
        time,
        value: [3820, 3650, 3560, 4050, 4040, 4120, 3740][index],
      }),
    ),
    cabinetStatus: cabinets.slice(0, 6).map((cabinet) => ({
      cabinetId: cabinet.id,
      cabinetName: cabinet.name,
      usage: Math.round((cabinet.usedU / cabinet.uHeight) * 100),
      status: cabinet.status,
    })),
  },
};

export async function getDigitalTwinScreenData() {
  return Promise.resolve({
    success: true,
    data: screenData,
  } satisfies IDC.ApiResponse<DigitalTwinScreenData>);
}
