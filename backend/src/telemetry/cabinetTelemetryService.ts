import type { Request, Response } from 'express';
import { getApiDataSource, getDatabaseSchema, getPool, quoteIdentifier } from '../db';
import { loadEnv } from '../env';
import { readCoils, readHoldingRegisters } from './modbusTcp';
import {
  deleteCabinetTelemetrySource,
  getCabinetCode,
  getCabinetTelemetrySource,
  listCabinetTelemetrySources,
  saveCabinetTelemetrySource,
  type PersistedCabinetTelemetrySource,
} from './cabinetTelemetrySourceStore';

export interface CabinetTelemetrySourceConfig extends PersistedCabinetTelemetrySource {}

interface CabinetTelemetryPollingConfig {
  lowFrequencySeconds: number;
  highFrequencySeconds: number;
}

export interface CabinetBinding {
  cabinetId: string;
  cabinetName: string;
  datacenterId: string;
  datacenterName?: string;
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
  binding?: CabinetBinding;
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

interface SourceRuntime {
  timer?: NodeJS.Timeout;
  inFlight: boolean;
  binding?: CabinetBinding;
  highFrequencySubscriberConnections: Map<string, Set<Response>>;
}

interface Subscriber {
  response: Response;
  datacenterId?: string;
}

type CabinetRow = {
  id: string;
  name: string;
  datacenter_id: string;
  datacenter_name: string | null;
};

const asInteger = (value: unknown, fallback: number) => {
  const parsed = Number(value);
  return Number.isInteger(parsed) ? parsed : fallback;
};

const asPositiveSeconds = (value: unknown, fallback: number, name: string) => {
  const parsed = Number(value);
  const seconds = Number.isFinite(parsed) ? parsed : fallback;
  if (seconds < 0.5) throw new Error(`${name} must be at least 0.5 seconds`);
  return seconds;
};

const loadPollingConfig = (): CabinetTelemetryPollingConfig => {
  const lowFrequencySeconds = asPositiveSeconds(
    process.env.CABINET_TELEMETRY_LOW_FREQUENCY_SECONDS,
    60,
    'CABINET_TELEMETRY_LOW_FREQUENCY_SECONDS',
  );
  const highFrequencySeconds = asPositiveSeconds(
    process.env.CABINET_TELEMETRY_HIGH_FREQUENCY_SECONDS,
    2,
    'CABINET_TELEMETRY_HIGH_FREQUENCY_SECONDS',
  );
  if (highFrequencySeconds > lowFrequencySeconds) {
    throw new Error(
      'CABINET_TELEMETRY_HIGH_FREQUENCY_SECONDS must not exceed CABINET_TELEMETRY_LOW_FREQUENCY_SECONDS',
    );
  }
  return { lowFrequencySeconds, highFrequencySeconds };
};

const parseSourceConfig = (value: unknown, index: number): CabinetTelemetrySourceConfig => {
  const item = (value || {}) as Record<string, unknown>;
  const id = String(item.id || `cabinet-telemetry-${index + 1}`).trim();
  const cabinetId = String(item.cabinetId || '').trim();
  const host = String(item.host || '').trim();
  const port = asInteger(item.port, 502);
  const unitId = asInteger(item.unitId, 1);
  const timeoutMs = asInteger(item.timeoutMs, 1800);

  if (!id || !cabinetId || !host) {
    throw new Error(`Telemetry source ${index + 1} requires id, cabinetId and host`);
  }
  if (port < 1 || port > 65535) {
    throw new Error(`Telemetry source ${id} has invalid port ${port}`);
  }
  if (unitId < 0 || unitId > 255) {
    throw new Error(`Telemetry source ${id} has invalid unitId ${unitId}`);
  }
  if (timeoutMs < 100) {
    throw new Error(`Telemetry source ${id} timeoutMs must be at least 100`);
  }

  return {
    id,
    cabinetId,
    host,
    port,
    unitId,
    timeoutMs,
    enabled: item.enabled !== false,
  };
};

const loadSourceConfigs = async () => {
  loadEnv();
  const raw = process.env.CABINET_TELEMETRY_SOURCES?.trim();
  let bootstrapSources: CabinetTelemetrySourceConfig[] = [];
  if (raw) {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) {
      throw new Error('CABINET_TELEMETRY_SOURCES must be a JSON array');
    }
    bootstrapSources = parsed.map(parseSourceConfig);
  }

  const sources = (await listCabinetTelemetrySources(bootstrapSources)).map(parseSourceConfig);
  const sourceIds = new Set<string>();
  const cabinetIds = new Set<string>();
  for (const source of sources) {
    if (sourceIds.has(source.id)) throw new Error(`Duplicate telemetry source id: ${source.id}`);
    if (cabinetIds.has(source.cabinetId)) {
      throw new Error(`Cabinet ${source.cabinetId} has more than one telemetry source`);
    }
    sourceIds.add(source.id);
    cabinetIds.add(source.cabinetId);
  }
  return sources;
};

export const decodeRackTelemetry = (
  source: CabinetTelemetrySourceConfig,
  binding: CabinetBinding,
  registers: number[],
  coils: boolean[],
): CabinetTelemetry => {
  if (registers.length < 20) throw new Error('Expected 20 holding registers');
  if (coils.length < 8) throw new Error('Expected 8 coils');

  const alarmCode = registers[10];
  const online = coils[0];
  const criticalAlarm = coils[6];
  const severity = !online
    ? 'offline'
    : criticalAlarm || coils[2] || coils[3] || coils[4]
      ? 'critical'
      : alarmCode !== 0 || coils[5]
        ? 'warning'
        : 'normal';

  return {
    sourceId: source.id,
    cabinetId: binding.cabinetId,
    cabinetName: binding.cabinetName,
    datacenterId: binding.datacenterId,
    endpoint: `${source.host}:${source.port}`,
    timestamp: new Date().toISOString(),
    simulatorCabinetId: registers[0],
    temperatureC: registers[1] / 10,
    humidityRH: registers[2] / 10,
    voltageV: registers[3] / 10,
    currentA: registers[4] / 100,
    activePowerW: registers[5],
    apparentPowerVA: registers[6],
    energyLowWordKwh: registers[7] / 10,
    fanRpm: registers[8],
    doorOpenCount: registers[9],
    alarmCode,
    loadPercent: registers[11] / 10,
    inletTemperatureC: registers[12] / 10,
    outletTemperatureC: registers[13] / 10,
    uptimeSeconds: registers[14] * 65536 + registers[15],
    ratedPowerW: registers[16],
    highTemperatureThresholdC: registers[17] / 10,
    highHumidityThresholdRH: registers[18] / 10,
    modelVersion: registers[19],
    online,
    doorOpen: coils[1],
    smokeAlarm: coils[2],
    waterLeak: coils[3],
    powerAlarm: coils[4],
    fanAlarm: coils[5],
    criticalAlarm,
    maintenanceMode: coils[7],
    severity,
  };
};

class CabinetTelemetryService {
  private states = new Map<string, CabinetTelemetrySourceState>();
  private runtimes = new Map<string, SourceRuntime>();
  private subscribers = new Set<Subscriber>();
  private prioritySubscribers = new Set<Response>();
  private heartbeatTimer?: NodeJS.Timeout;
  private started = false;
  private configurationError?: string;
  private pollingConfig: CabinetTelemetryPollingConfig = {
    lowFrequencySeconds: 60,
    highFrequencySeconds: 2,
  };

  async start() {
    if (this.started) return;
    this.started = true;

    let sources: CabinetTelemetrySourceConfig[];
    try {
      sources = await loadSourceConfigs();
      this.pollingConfig = loadPollingConfig();
      const highFrequencyMs = this.pollingConfig.highFrequencySeconds * 1000;
      for (const source of sources) {
        if (source.timeoutMs >= highFrequencyMs) {
          throw new Error(
            `Telemetry source ${source.id} timeoutMs must be lower than the high-frequency interval`,
          );
        }
      }
    } catch (error) {
      this.configurationError = error instanceof Error ? error.message : String(error);
      console.error(`[telemetry] Configuration error: ${this.configurationError}`);
      return;
    }

    if (sources.length === 0) {
      console.log('[telemetry] No cabinet telemetry sources configured');
      return;
    }
    console.log(`[telemetry] Loaded ${sources.length} cabinet telemetry source(s)`);

    for (const source of sources) {
      this.states.set(source.id, {
        source,
        status: source.enabled ? 'starting' : 'disabled',
        consecutiveFailures: 0,
        collectionMode: 'low',
        pollIntervalSeconds: this.pollingConfig.lowFrequencySeconds,
        highFrequencySubscribers: 0,
      });
      this.runtimes.set(source.id, {
        inFlight: false,
        highFrequencySubscriberConnections: new Map(),
      });
    }

    const bindings = await this.resolveCabinetBindings(sources.map((source) => source.cabinetId));

    for (const source of sources) {
      const state = this.states.get(source.id) as CabinetTelemetrySourceState;
      const binding = bindings.get(source.cabinetId);
      if (!binding) {
        this.states.set(source.id, {
          ...state,
          status: 'configuration_error',
          lastError: `Registered cabinet not found: ${source.cabinetId}`,
        });
        console.error(`[telemetry:${source.id}] Registered cabinet not found: ${source.cabinetId}`);
        continue;
      }

      state.binding = binding;
      if (!source.enabled) continue;

      const runtime = this.runtimes.get(source.id) as SourceRuntime;
      runtime.binding = binding;
      this.schedule(source, binding, 'low', true, 'startup');
      console.log(
        `[telemetry:${source.id}] ${source.host}:${source.port} -> ${binding.cabinetName} (${binding.cabinetId}), low=${this.pollingConfig.lowFrequencySeconds}s, high=${this.pollingConfig.highFrequencySeconds}s`,
      );
    }

    this.heartbeatTimer = setInterval(() => {
      for (const subscriber of this.subscribers) subscriber.response.write(': heartbeat\n\n');
      for (const response of this.prioritySubscribers) response.write(': heartbeat\n\n');
    }, 15000);
    this.heartbeatTimer.unref();
  }

  stop() {
    for (const runtime of this.runtimes.values()) {
      if (runtime.timer) clearInterval(runtime.timer);
    }
    if (this.heartbeatTimer) clearInterval(this.heartbeatTimer);
    for (const subscriber of this.subscribers) subscriber.response.end();
    for (const response of this.prioritySubscribers) response.end();
    this.runtimes.clear();
    this.subscribers.clear();
    this.prioritySubscribers.clear();
    this.started = false;
  }

  getStates(datacenterId?: string) {
    return [...this.states.values()].filter(
      (state) => !datacenterId || state.binding?.datacenterId === datacenterId,
    );
  }

  getStateByCabinetId(cabinetId: string) {
    return [...this.states.values()].find((state) => state.source.cabinetId === cabinetId);
  }

  getConfigurationError() {
    return this.configurationError;
  }

  async getSourceConfiguration(cabinetId: string) {
    return getCabinetTelemetrySource(cabinetId);
  }

  async saveSourceConfiguration(cabinetId: string, value: unknown) {
    loadEnv();
    const item = (value || {}) as Record<string, unknown>;
    const cabinetCode = await getCabinetCode(cabinetId);
    if (!cabinetCode) throw new Error(`Registered cabinet not found: ${cabinetId}`);
    const source = parseSourceConfig(
      {
        ...item,
        id: item.id || `${cabinetCode}-Telemery`,
        cabinetId,
      },
      0,
    );
    const pollingConfig = loadPollingConfig();
    if (source.timeoutMs >= pollingConfig.highFrequencySeconds * 1000) {
      throw new Error(
        `timeoutMs must be lower than the high-frequency interval (${pollingConfig.highFrequencySeconds}s)`,
      );
    }
    const saved = await saveCabinetTelemetrySource(source);
    await this.reload();
    return saved;
  }

  async testSourceConfiguration(cabinetId: string, value: unknown) {
    loadEnv();
    const item = (value || {}) as Record<string, unknown>;
    const cabinetCode = await getCabinetCode(cabinetId);
    if (!cabinetCode) throw new Error(`Registered cabinet not found: ${cabinetId}`);
    const source = parseSourceConfig(
      {
        ...item,
        id: item.id || `${cabinetCode}-Telemery`,
        cabinetId,
      },
      0,
    );
    const pollingConfig = loadPollingConfig();
    if (source.timeoutMs >= pollingConfig.highFrequencySeconds * 1000) {
      throw new Error(
        `timeoutMs must be lower than the high-frequency interval (${pollingConfig.highFrequencySeconds}s)`,
      );
    }
    const binding = (await this.resolveCabinetBindings([cabinetId])).get(cabinetId);
    if (!binding) throw new Error(`Registered cabinet not found: ${cabinetId}`);
    const endpoint = {
      host: source.host,
      port: source.port,
      unitId: source.unitId,
      timeoutMs: source.timeoutMs,
    };
    const [registers, coils] = await Promise.all([
      readHoldingRegisters(endpoint, 0, 20),
      readCoils(endpoint, 0, 8),
    ]);
    return decodeRackTelemetry(source, binding, registers, coils);
  }

  async deleteSourceConfiguration(cabinetId: string) {
    const deleted = await deleteCabinetTelemetrySource(cabinetId);
    await this.reload();
    return deleted;
  }

  private async reload() {
    this.stop();
    this.states.clear();
    this.configurationError = undefined;
    await this.start();
  }

  subscribe(req: Request, res: Response) {
    const datacenterId = req.query.datacenterId ? String(req.query.datacenterId) : undefined;
    const subscriber = { response: res, datacenterId };

    res.status(200);
    res.set({
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache, no-transform',
      Connection: 'keep-alive',
      'X-Accel-Buffering': 'no',
    });
    res.flushHeaders();
    res.write('retry: 3000\n\n');
    this.writeEvent(res, 'snapshot', { items: this.getStates(datacenterId) });
    this.subscribers.add(subscriber);

    req.once('close', () => {
      this.subscribers.delete(subscriber);
    });
  }

  subscribeHighFrequency(req: Request, res: Response, cabinetId: string) {
    const subscriptionId = String(req.query.subscriptionId || '').trim();
    if (!/^[A-Za-z0-9._:-]{1,128}$/.test(subscriptionId)) {
      res.status(400).json({
        success: false,
        errorMessage: 'A valid subscriptionId query parameter is required',
      });
      return;
    }
    const state = this.getStateByCabinetId(cabinetId);
    const runtime = state ? this.runtimes.get(state.source.id) : undefined;
    if (!state || !runtime) {
      res.status(404).json({
        success: false,
        errorMessage: `No telemetry source is configured for cabinet ${cabinetId}`,
      });
      return;
    }
    if (!state.source.enabled || !runtime.binding) {
      res.status(409).json({
        success: false,
        errorMessage: `Telemetry source for cabinet ${cabinetId} is not available`,
      });
      return;
    }

    res.status(200);
    res.set({
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache, no-transform',
      Connection: 'keep-alive',
      'X-Accel-Buffering': 'no',
    });
    res.flushHeaders();
    res.write('retry: 3000\n\n');
    this.prioritySubscribers.add(res);

    let connections = runtime.highFrequencySubscriberConnections.get(subscriptionId);
    const isNewSubscription = !connections;
    if (!connections) {
      connections = new Set<Response>();
      runtime.highFrequencySubscriberConnections.set(subscriptionId, connections);
    }
    connections.add(res);
    if (isNewSubscription) {
      const subscriberCount = runtime.highFrequencySubscriberConnections.size;
      console.log(
        `[telemetry:${state.source.id}] High-frequency subscriber opened, cabinet=${cabinetId}, subscription=${subscriptionId}, subscribers=${subscriberCount}`,
      );
      if (subscriberCount === 1) {
        this.schedule(state.source, runtime.binding, 'high', true, 'cabinet-summary-opened');
      } else {
        this.updateCollectionState(state.source, 'high');
      }
    }
    this.writeEvent(res, 'snapshot', this.getStateByCabinetId(cabinetId));

    req.once('close', () => {
      this.prioritySubscribers.delete(res);
      const activeConnections = runtime.highFrequencySubscriberConnections.get(subscriptionId);
      if (!activeConnections) return;
      activeConnections.delete(res);
      if (activeConnections.size > 0) return;
      runtime.highFrequencySubscriberConnections.delete(subscriptionId);
      this.afterHighFrequencySubscriberClosed(state, runtime, cabinetId, subscriptionId);
    });
  }

  releaseHighFrequency(cabinetId: string, subscriptionId: string) {
    const state = this.getStateByCabinetId(cabinetId);
    const runtime = state ? this.runtimes.get(state.source.id) : undefined;
    if (!state || !runtime) return false;
    const connections = runtime.highFrequencySubscriberConnections.get(subscriptionId);
    if (!connections) return true;

    runtime.highFrequencySubscriberConnections.delete(subscriptionId);
    for (const response of connections) {
      this.prioritySubscribers.delete(response);
      response.end();
    }
    this.afterHighFrequencySubscriberClosed(state, runtime, cabinetId, subscriptionId);
    return true;
  }

  private afterHighFrequencySubscriberClosed(
    state: CabinetTelemetrySourceState,
    runtime: SourceRuntime,
    cabinetId: string,
    subscriptionId: string,
  ) {
    const subscriberCount = runtime.highFrequencySubscriberConnections.size;
      console.log(
      `[telemetry:${state.source.id}] High-frequency subscriber closed, cabinet=${cabinetId}, subscription=${subscriptionId}, subscribers=${subscriberCount}`,
      );
    if (subscriberCount === 0) {
      this.schedule(
        state.source,
        runtime.binding as CabinetBinding,
        'low',
        false,
        'cabinet-summary-closed',
      );
    } else {
      this.updateCollectionState(state.source, 'high');
    }
  }

  private schedule(
    source: CabinetTelemetrySourceConfig,
    binding: CabinetBinding,
    mode: 'low' | 'high',
    pollImmediately: boolean,
    reason: 'startup' | 'cabinet-summary-opened' | 'cabinet-summary-closed',
  ) {
    const runtime = this.runtimes.get(source.id);
    if (!runtime) return;
    const previousState = this.states.get(source.id);
    if (runtime.timer) clearInterval(runtime.timer);

    const intervalSeconds =
      mode === 'high'
        ? this.pollingConfig.highFrequencySeconds
        : this.pollingConfig.lowFrequencySeconds;
    runtime.timer = setInterval(() => void this.poll(source, binding), intervalSeconds * 1000);
    runtime.timer.unref();
    this.updateCollectionState(source, mode);
    if (
      previousState &&
      (previousState.collectionMode !== mode ||
        previousState.pollIntervalSeconds !== intervalSeconds)
    ) {
      console.log(
        `[telemetry:${source.id}] Polling frequency ${previousState.collectionMode}(${previousState.pollIntervalSeconds}s) -> ${mode}(${intervalSeconds}s), cabinet=${binding.cabinetId}, subscribers=${runtime.highFrequencySubscriberConnections.size}, reason=${reason}`,
      );
    }
    if (pollImmediately) void this.poll(source, binding);
  }

  private updateCollectionState(source: CabinetTelemetrySourceConfig, mode: 'low' | 'high') {
    const state = this.states.get(source.id);
    const runtime = this.runtimes.get(source.id);
    if (!state || !runtime) return;
    const next: CabinetTelemetrySourceState = {
      ...state,
      collectionMode: mode,
      pollIntervalSeconds:
        mode === 'high'
          ? this.pollingConfig.highFrequencySeconds
          : this.pollingConfig.lowFrequencySeconds,
      highFrequencySubscribers: runtime.highFrequencySubscriberConnections.size,
    };
    this.states.set(source.id, next);
    this.broadcast('status', next);
  }

  private async resolveCabinetBindings(cabinetIds: string[]) {
    if (getApiDataSource() !== 'database') {
      const { getCabinetSnapshots } = require('../../mock/cabinet.mock');
      const cabinets = getCabinetSnapshots() as Array<{
        id: string;
        name: string;
        datacenterId: string;
        datacenterName?: string;
      }>;
      return new Map(
        cabinets
          .filter((cabinet) => cabinetIds.includes(cabinet.id))
          .map((cabinet) => [
            cabinet.id,
            {
              cabinetId: cabinet.id,
              cabinetName: cabinet.name,
              datacenterId: cabinet.datacenterId,
              datacenterName: cabinet.datacenterName,
            },
          ]),
      );
    }

    const schemaName = quoteIdentifier(getDatabaseSchema());
    const result = await getPool().query<CabinetRow>(
      `
        select
          c.id,
          c.name,
          c.datacenter_id,
          dc.name as datacenter_name
        from ${schemaName}.cabinet c
        join ${schemaName}.datacenter dc on dc.id = c.datacenter_id
        where c.id = any($1::text[])
      `,
      [cabinetIds],
    );

    return new Map(
      result.rows.map((row) => [
        row.id,
        {
          cabinetId: row.id,
          cabinetName: row.name,
          datacenterId: row.datacenter_id,
          datacenterName: row.datacenter_name || undefined,
        },
      ]),
    );
  }

  private async poll(source: CabinetTelemetrySourceConfig, binding: CabinetBinding) {
    const runtime = this.runtimes.get(source.id);
    if (!runtime || runtime.inFlight) return;
    runtime.inFlight = true;

    const previous = this.states.get(source.id) as CabinetTelemetrySourceState;
    const lastAttemptAt = new Date().toISOString();
    try {
      const endpoint = {
        host: source.host,
        port: source.port,
        unitId: source.unitId,
        timeoutMs: source.timeoutMs,
      };
      const [registers, coils] = await Promise.all([
        readHoldingRegisters(endpoint, 0, 20),
        readCoils(endpoint, 0, 8),
      ]);
      const telemetry = decodeRackTelemetry(source, binding, registers, coils);
      const next: CabinetTelemetrySourceState = {
        ...previous,
        binding,
        status: telemetry.online ? 'online' : 'offline',
        lastAttemptAt,
        lastSuccessAt: telemetry.timestamp,
        lastError: telemetry.online ? undefined : 'Simulator reports offline state',
        consecutiveFailures: 0,
        telemetry,
      };
      this.states.set(source.id, next);
      this.broadcast('telemetry', next);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      const failures = previous.consecutiveFailures + 1;
      const next: CabinetTelemetrySourceState = {
        ...previous,
        binding,
        status: 'offline',
        lastAttemptAt,
        lastError: message,
        consecutiveFailures: failures,
      };
      this.states.set(source.id, next);
      this.broadcast('status', next);
      if (failures === 1 || failures % 10 === 0) {
        console.error(`[telemetry:${source.id}] Poll failed (${failures}): ${message}`);
      }
    } finally {
      runtime.inFlight = false;
    }
  }

  private writeEvent(response: Response, event: string, data: unknown) {
    response.write(`event: ${event}\n`);
    response.write(`data: ${JSON.stringify(data)}\n\n`);
  }

  private broadcast(event: string, state: CabinetTelemetrySourceState) {
    for (const subscriber of this.subscribers) {
      if (
        subscriber.datacenterId &&
        state.binding?.datacenterId !== subscriber.datacenterId
      ) {
        continue;
      }
      this.writeEvent(subscriber.response, event, state);
    }
  }
}

export const cabinetTelemetryService = new CabinetTelemetryService();

export const startCabinetTelemetryService = () => cabinetTelemetryService.start();
export const stopCabinetTelemetryService = () => cabinetTelemetryService.stop();
