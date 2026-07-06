import { Area, Line } from '@ant-design/charts';
import { Canvas } from '@react-three/fiber';
import { history } from '@umijs/max';
import { Button, Select, Switch } from 'antd';
import {
  AlertTriangle,
  ArrowLeft,
  CheckSquare,
  CloudSun,
  Cpu,
  Droplets,
  Gauge,
  Monitor,
  Power,
  Server,
  Snowflake,
  Thermometer,
  XSquare,
  Zap,
} from 'lucide-react';
import { Suspense, useEffect, useMemo, useState } from 'react';
import { getCabinetsByDatacenter } from '@/services/idc/cabinet';
import {
  getConnectionsByDatacenter,
  getConnectionTypes,
} from '@/services/idc/connection';
import { getDatacenter, getAllDatacenters } from '@/services/idc/datacenter';
import { getDevices } from '@/services/idc/device';
import { getCabinetEnvironments } from '@/services/idc/environment';
import { getDatacenterLayout } from '@/services/idc/layout';
import {
  getDigitalTwinScreenData,
  type DigitalTwinScreenData,
} from '@/services/idc/screen';
import { ScreenDatacenterScene } from './ScreenDatacenterScene';
import styles from './index.less';

type ScreenDatacenterOption = { id: string; name: string; code: string };
type ScreenConnectionType = { value: string; label: string; color: string };

const chartTheme = {
  styleSheet: {
    backgroundColor: 'transparent',
    brandColor: '#00eaff',
    paletteQualitative10: ['#00eaff', '#ffb000', '#16f19a', '#4f8bff'],
  },
};

const Panel: React.FC<{
  title: string;
  icon: React.ReactNode;
  className?: string;
  children: React.ReactNode;
}> = ({ title, icon, className, children }) => (
  <section className={`${styles.panel} ${className || ''}`}>
    <div className={styles.panelTitle}>
      <span className={styles.panelIcon}>{icon}</span>
      <span>{title}</span>
    </div>
    <div className={styles.panelBody}>{children}</div>
  </section>
);

const MetricCard: React.FC<{
  label: string;
  value: string | number;
  icon: React.ReactNode;
  tone?: 'cyan' | 'green' | 'yellow' | 'red';
}> = ({ label, value, icon, tone = 'cyan' }) => (
  <div className={`${styles.metricCard} ${styles[tone]}`}>
    <div className={styles.metricIcon}>{icon}</div>
    <div>
      <div className={styles.metricLabel}>{label}</div>
      <div className={styles.metricValue}>{value}</div>
    </div>
  </div>
);

const MiniBars: React.FC<{ data: { name: string; value: number }[] }> = ({ data }) => (
  <div className={styles.miniBars}>
    {data.map((item) => (
      <div key={item.name} className={styles.miniBarItem}>
        <div className={styles.miniBarTrack}>
          <div className={styles.miniBarFill} style={{ height: `${Math.min(100, item.value * 2.4)}%` }} />
        </div>
        <span>{item.name}</span>
      </div>
    ))}
  </div>
);

const MemoryRing: React.FC<{ value: number }> = ({ value }) => (
  <div className={styles.memoryWrap}>
    <div className={styles.memoryRing} style={{ '--percent': `${value}%` } as React.CSSProperties}>
      <span>{value}%</span>
    </div>
    <div className={styles.memoryLegend}>
      <span>30%</span>
      <span>70%</span>
    </div>
  </div>
);

const CabinetStatus: React.FC<{ data: DigitalTwinScreenData['charts']['cabinetStatus'] }> = ({ data }) => (
  <div className={styles.cabinetStatus}>
    {data.map((item) => (
      <div key={item.cabinetId} className={styles.cabinetStatusItem}>
        <span>{item.cabinetName}</span>
        <div className={styles.statusBar}>
          <i
            className={`${styles.statusFill} ${styles[item.status]}`}
            style={{ width: `${item.usage}%` }}
          />
        </div>
        <b>{item.usage}%</b>
      </div>
    ))}
  </div>
);

const AlertTicker: React.FC<{ alerts: IDC.AlertDetail[] }> = ({ alerts }) => (
  <div className={styles.alertTicker}>
    <span className={styles.alertBadge}>实时告警 {alerts.length}</span>
    <div className={styles.tickerTrack}>
      <div className={styles.tickerContent}>
        {[...alerts, ...alerts].map((alert, index) => (
          <span key={`${alert.id}-${index}`} className={styles.tickerItem}>
            {new Date(alert.createdAt).toLocaleTimeString('zh-CN', {
              hour: '2-digit',
              minute: '2-digit',
              second: '2-digit',
            })}
            <b>{alert.message}</b>
          </span>
        ))}
      </div>
    </div>
  </div>
);

const getScreenDatacenterId = () => {
  const params = new URLSearchParams(window.location.search);
  return params.get('datacenterId') || params.get('id') || undefined;
};

const loadDevicesByDatacenter = async (datacenterId: string) => {
  const pageSize = 200;
  const firstPage = await getDevices({
    current: 1,
    pageSize,
    datacenterId,
  });
  if (!firstPage.success) {
    throw new Error('Failed to load devices by datacenter.');
  }
  const devices = [...(firstPage.data || [])];
  const total = firstPage.total || devices.length;
  const totalPages = Math.ceil(total / pageSize);

  if (totalPages <= 1) return devices;

  const pages = Array.from({ length: totalPages - 1 }, (_, index) => index + 2);
  const restPages = await Promise.all(
    pages.map((page) =>
      getDevices({
        current: page,
        pageSize,
        datacenterId,
      }),
    ),
  );

  for (const page of restPages) {
    if (!page.success) {
      throw new Error('Failed to load devices by datacenter.');
    }
    devices.push(...(page.data || []));
  }

  return devices;
};

const loadScreenSceneData = async (
  baseData: DigitalTwinScreenData,
  selectedDatacenterId: string,
): Promise<{
  data: DigitalTwinScreenData;
  connections: IDC.Connection[];
  connectionTypes: ScreenConnectionType[];
}> => {
  const [datacenterRes, cabinetRes, layoutRes, devices, envRes, connectionRes, connectionTypeRes] =
    await Promise.all([
      getDatacenter(selectedDatacenterId),
      getCabinetsByDatacenter(selectedDatacenterId),
      getDatacenterLayout(selectedDatacenterId),
      loadDevicesByDatacenter(selectedDatacenterId),
      getCabinetEnvironments(),
      getConnectionsByDatacenter(selectedDatacenterId),
      getConnectionTypes(),
    ]);

  if (!datacenterRes.success || !datacenterRes.data) {
    throw new Error(`Failed to load datacenter ${selectedDatacenterId}.`);
  }
  if (!cabinetRes.success || !cabinetRes.data) {
    throw new Error(`Failed to load cabinets for datacenter ${selectedDatacenterId}.`);
  }
  if (!layoutRes.success || !layoutRes.data) {
    throw new Error(`Failed to load layout for datacenter ${selectedDatacenterId}.`);
  }
  if (!envRes.success || !envRes.data) {
    throw new Error('Failed to load cabinet environment data.');
  }
  if (!connectionRes.success || !connectionRes.data) {
    throw new Error('Failed to load datacenter connection data.');
  }
  if (!connectionTypeRes.success || !connectionTypeRes.data) {
    throw new Error('Failed to load connection type data.');
  }

  const cabinetEnvironments = (envRes.data || []).filter(
    (item) => item.datacenterId === selectedDatacenterId,
  );

  return {
    data: {
      ...baseData,
      datacenter: datacenterRes.data,
      layout: layoutRes.data,
      cabinets: cabinetRes.data,
      devices,
      cabinetEnvironments,
    },
    connections: connectionRes.data,
    connectionTypes: connectionTypeRes.data,
  };
};

const loadDigitalTwinScreenData = async (datacenterId?: string) => {
  const [screenRes, dcListRes] = await Promise.all([
    getDigitalTwinScreenData(),
    getAllDatacenters(),
  ]);

  if (!screenRes.success || !screenRes.data) {
    throw new Error('Digital twin screen data is unavailable.');
  }
  if (!dcListRes.success || !dcListRes.data) {
    throw new Error('Failed to load datacenter list.');
  }

  const selectedDatacenterId = datacenterId || getScreenDatacenterId() || dcListRes.data[0]?.id;
  if (!selectedDatacenterId) {
    throw new Error('No datacenter is available for the digital twin screen scene.');
  }

  return {
    datacenters: dcListRes.data,
    selectedDatacenterId,
    ...(await loadScreenSceneData(screenRes.data, selectedDatacenterId)),
  };
};

const DigitalTwinScreen: React.FC = () => {
  const [data, setData] = useState<DigitalTwinScreenData | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [datacenters, setDatacenters] = useState<ScreenDatacenterOption[]>([]);
  const [selectedDatacenterId, setSelectedDatacenterId] = useState<string>();
  const [connections, setConnections] = useState<IDC.Connection[]>([]);
  const [connectionTypes, setConnectionTypes] = useState<ScreenConnectionType[]>([]);
  const [showConnections, setShowConnections] = useState(false);
  const [currentTime, setCurrentTime] = useState(new Date());

  useEffect(() => {
    let cancelled = false;

    const loadData = async () => {
      try {
        const result = await loadDigitalTwinScreenData();
        if (!cancelled) {
          setDatacenters(result.datacenters);
          setSelectedDatacenterId(result.selectedDatacenterId);
          setData(result.data);
          setConnections(result.connections);
          setConnectionTypes(result.connectionTypes);
          setErrorMessage(null);
        }
      } catch (error) {
        console.error('Failed to load digital twin screen scene data:', error);
        if (!cancelled) {
          setData(null);
          setConnections([]);
          setConnectionTypes([]);
          setErrorMessage(error instanceof Error ? error.message : 'Failed to load digital twin screen scene data.');
        }
      }
    };

    loadData();
    return () => {
      cancelled = true;
    };
  }, []);

  const handleDatacenterChange = async (datacenterId: string) => {
    setSelectedDatacenterId(datacenterId);
    setData(null);
    setErrorMessage(null);

    try {
      const result = await loadDigitalTwinScreenData(datacenterId);
      setDatacenters(result.datacenters);
      setSelectedDatacenterId(result.selectedDatacenterId);
      setData(result.data);
      setConnections(result.connections);
      setConnectionTypes(result.connectionTypes);
    } catch (error) {
      console.error('Failed to load digital twin screen scene data:', error);
      setData(null);
      setConnections([]);
      setConnectionTypes([]);
      setErrorMessage(error instanceof Error ? error.message : 'Failed to load digital twin screen scene data.');
    }
  };

  const handleBack = () => {
    if (window.history.length > 1) {
      history.back();
      return;
    }
    history.push('/dashboard');
  };

  useEffect(() => {
    const timer = window.setInterval(() => setCurrentTime(new Date()), 1000);
    return () => window.clearInterval(timer);
  }, []);

  const cpuConfig = useMemo(
    () => ({
      data: data?.charts.cpuUsage || [],
      xField: 'time',
      yField: 'value',
      height: 150,
      smooth: true,
      theme: chartTheme,
      color: '#00eaff',
      area: {
        style: {
          fill: 'l(270) 0:rgba(0,234,255,0.22) 1:rgba(0,234,255,0.02)',
        },
      },
      line: { style: { lineWidth: 3 } },
      axis: {
        x: { labelFill: '#8aa8bd', lineStroke: '#18364a', tickStroke: '#18364a' },
        y: { labelFill: '#8aa8bd', gridStroke: '#173146' },
      },
    }),
    [data?.charts.cpuUsage],
  );

  const networkConfig = useMemo(
    () => ({
      data: data?.charts.networkTraffic || [],
      xField: 'time',
      yField: 'value',
      seriesField: 'type',
      height: 150,
      smooth: true,
      theme: chartTheme,
      color: ['#00eaff', '#ffb000'],
      legend: {
        color: {
          title: false,
          position: 'top',
          itemLabelFill: '#b8d8e6',
        },
      },
      axis: {
        x: { labelFill: '#8aa8bd', lineStroke: '#18364a', tickStroke: '#18364a' },
        y: { labelFill: '#8aa8bd', gridStroke: '#173146' },
      },
    }),
    [data?.charts.networkTraffic],
  );

  const powerConfig = useMemo(
    () => ({
      data: data?.charts.powerTrend || [],
      xField: 'time',
      yField: 'value',
      height: 150,
      smooth: true,
      theme: chartTheme,
      color: '#ffb000',
      area: {
        style: {
          fill: 'l(270) 0:rgba(255,176,0,0.24) 1:rgba(255,176,0,0.02)',
        },
      },
      line: { style: { lineWidth: 3 } },
      axis: {
        x: { labelFill: '#8aa8bd', lineStroke: '#18364a', tickStroke: '#18364a' },
        y: { labelFill: '#8aa8bd', gridStroke: '#173146' },
      },
    }),
    [data?.charts.powerTrend],
  );

  if (errorMessage) {
    return <div className={styles.loading}>3D机柜数据加载失败：{errorMessage}</div>;
  }

  if (!data) {
    return <div className={styles.loading}>加载数字孪生大屏...</div>;
  }

  const memoryValue = data.charts.memoryUsage.find((item) => item.name === 'used')?.value || 0;
  const metrics = [
    { label: 'PUE', value: data.overview.pue.toFixed(2), icon: <Zap size={27} /> },
    { label: '总功耗', value: `${data.overview.totalPowerKw.toFixed(1)} kW`, icon: <Power size={24} /> },
    { label: '制冷功耗', value: `${data.overview.coolingPowerKw.toFixed(1)} kW`, icon: <Snowflake size={24} /> },
    { label: 'IT功耗', value: `${data.overview.itPowerKw.toFixed(1)} kW`, icon: <Monitor size={24} /> },
    { label: '平均温度', value: `${data.overview.avgTemperature.toFixed(1)}℃`, icon: <Thermometer size={24} /> },
    { label: '平均湿度', value: `${data.overview.avgHumidity}%`, icon: <Droplets size={24} /> },
    { label: '设备总数', value: data.overview.deviceTotal.toLocaleString(), icon: <Server size={24} /> },
    { label: '在线', value: data.overview.online.toLocaleString(), icon: <CheckSquare size={24} />, tone: 'green' as const },
    { label: '告警', value: data.overview.warning, icon: <AlertTriangle size={24} />, tone: 'yellow' as const },
    { label: '离线', value: data.overview.offline, icon: <XSquare size={24} />, tone: 'red' as const },
  ];

  return (
    <div className={styles.screen}>
      <header className={styles.header}>
        <div className={styles.headerMeta}>
          <Button
            className={styles.backButton}
            type="text"
            icon={<ArrowLeft size={16} />}
            onClick={handleBack}
          >
            返回
          </Button>
          {currentTime.toLocaleString('zh-CN', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            weekday: 'short',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
          })}
          <CloudSun size={15} />
          <Select
            className={styles.datacenterSelect}
            value={selectedDatacenterId}
            popupMatchSelectWidth={false}
            onChange={handleDatacenterChange}
            options={datacenters.map((item) => ({
              value: item.id,
              label: item.name,
            }))}
          />
          25℃ 晴朗
        </div>
        <h1>{data.datacenter.name}</h1>
        <div className={styles.systemStatus}>
          <span>系统运行正常</span>
          <em>已运行：0天0小时1分</em>
        </div>
      </header>

      <div className={styles.metricGrid}>
        {metrics.map((item) => (
          <MetricCard key={item.label} {...item} />
        ))}
      </div>

      <main className={styles.content}>
        <aside className={styles.leftColumn}>
          <Panel title="CPU使用率" icon={<Zap size={16} />}>
            <Area {...cpuConfig} />
          </Panel>
          <Panel title="内存使用率" icon={<Cpu size={16} />}>
            <MemoryRing value={memoryValue} />
          </Panel>
          <Panel title="温度监控" icon={<Thermometer size={16} />}>
            <MiniBars data={data.charts.temperatureByZone} />
          </Panel>
        </aside>

        <section className={styles.sceneWrap}>
          <div className={styles.sceneStats}>
            <span>FPS: <b>60</b></span>
            <span>Draw Calls: <b>{data.cabinets.length * 12}</b></span>
            <span>Cabinets: <b>{data.cabinets.length}</b></span>
          </div>
          <div className={styles.connectionSwitch}>
            <Switch
              size="small"
              checked={showConnections}
              onChange={setShowConnections}
            />
            <span>显示连线关系</span>
          </div>
          <Canvas shadows dpr={[1, 2]} className={styles.sceneCanvas}>
            <Suspense fallback={null}>
              <ScreenDatacenterScene
                layout={data.layout}
                cabinets={data.cabinets}
                devices={data.devices}
                cabinetEnvironments={data.cabinetEnvironments}
                connections={connections}
                connectionTypes={connectionTypes}
                showConnections={showConnections}
              />
            </Suspense>
          </Canvas>
          <div className={styles.sceneTabs}>
            <button className={styles.activeTab}>总览</button>
            <button>A区</button>
            <button>B区</button>
            <button>拓扑</button>
          </div>
        </section>

        <aside className={styles.rightColumn}>
          <Panel title="网络流量" icon={<Gauge size={16} />}>
            <Line {...networkConfig} />
          </Panel>
          <Panel title="能耗分析" icon={<Zap size={16} />}>
            <Area {...powerConfig} />
          </Panel>
          <Panel title="机柜状态" icon={<Server size={16} />}>
            <CabinetStatus data={data.charts.cabinetStatus} />
          </Panel>
        </aside>
      </main>

      <AlertTicker alerts={data.alerts} />
    </div>
  );
};

export default DigitalTwinScreen;
