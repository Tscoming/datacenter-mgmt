import { request } from '@umijs/max';

export interface CabinetTelemetrySourceConfig {
  id: string;
  cabinetId: string;
  host: string;
  port: number;
  unitId: number;
  timeoutMs: number;
  enabled: boolean;
}

export interface CabinetTelemetry {
  sourceId: string;
  cabinetId: string;
  cabinetName: string;
  datacenterId: string;
  endpoint: string;
  timestamp: string;
  simulatorCabinetId: number;
  temperatureC: number;
  humidityRH: number;
  voltageV: number;
  currentA: number;
  activePowerW: number;
  apparentPowerVA: number;
  energyLowWordKwh: number;
  fanRpm: number;
  doorOpenCount: number;
  alarmCode: number;
  loadPercent: number;
  inletTemperatureC: number;
  outletTemperatureC: number;
  uptimeSeconds: number;
  ratedPowerW: number;
  highTemperatureThresholdC: number;
  highHumidityThresholdRH: number;
  modelVersion: number;
  online: boolean;
  doorOpen: boolean;
  smokeAlarm: boolean;
  waterLeak: boolean;
  powerAlarm: boolean;
  fanAlarm: boolean;
  criticalAlarm: boolean;
  maintenanceMode: boolean;
  severity: 'normal' | 'warning' | 'critical' | 'offline';
}

export interface CabinetTelemetrySourceState {
  source: CabinetTelemetrySourceConfig;
  binding?: {
    cabinetId: string;
    cabinetName: string;
    datacenterId: string;
    datacenterName?: string;
  };
  status: 'starting' | 'online' | 'offline' | 'configuration_error' | 'disabled';
  lastAttemptAt?: string;
  lastSuccessAt?: string;
  lastError?: string;
  consecutiveFailures: number;
  collectionMode: 'low' | 'high';
  pollIntervalSeconds: number;
  highFrequencySubscribers: number;
  telemetry?: CabinetTelemetry;
}

export async function getCabinetTelemetrySources(datacenterId?: string) {
  return request<IDC.ApiResponse<CabinetTelemetrySourceState[]>>(
    '/api/idc/telemetry/sources',
    {
      method: 'GET',
      params: datacenterId ? { datacenterId } : undefined,
    },
  );
}

export function subscribeCabinetTelemetry(
  datacenterId: string,
  handlers: {
    onSnapshot: (items: CabinetTelemetrySourceState[]) => void;
    onState: (state: CabinetTelemetrySourceState) => void;
    onOpen?: () => void;
    onError?: () => void;
  },
) {
  const query = new URLSearchParams({ datacenterId });
  const eventSource = new EventSource(`/api/idc/telemetry/stream?${query.toString()}`);

  eventSource.onopen = () => handlers.onOpen?.();
  eventSource.onerror = () => handlers.onError?.();
  eventSource.addEventListener('snapshot', (event) => {
    const payload = JSON.parse((event as MessageEvent<string>).data) as {
      items: CabinetTelemetrySourceState[];
    };
    handlers.onSnapshot(payload.items || []);
  });

  const handleState = (event: Event) => {
    handlers.onState(
      JSON.parse((event as MessageEvent<string>).data) as CabinetTelemetrySourceState,
    );
  };
  eventSource.addEventListener('telemetry', handleState);
  eventSource.addEventListener('status', handleState);

  return () => eventSource.close();
}

export function subscribeCabinetHighFrequencyTelemetry(
  cabinetId: string,
  onState: (state: CabinetTelemetrySourceState) => void,
) {
  const subscriptionId = crypto.randomUUID();
  const encodedCabinetId = encodeURIComponent(cabinetId);
  const encodedSubscriptionId = encodeURIComponent(subscriptionId);
  const eventSource = new EventSource(
    `/api/idc/telemetry/cabinets/${encodedCabinetId}/high-frequency-stream?subscriptionId=${encodedSubscriptionId}`,
  );
  eventSource.addEventListener('snapshot', (event) => {
    onState(JSON.parse((event as MessageEvent<string>).data) as CabinetTelemetrySourceState);
  });
  return () => {
    eventSource.close();
    void fetch(
      `/api/idc/telemetry/cabinets/${encodedCabinetId}/high-frequency-subscriptions/${encodedSubscriptionId}`,
      { method: 'DELETE', keepalive: true },
    ).catch(() => undefined);
  };
}
