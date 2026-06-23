#!/usr/bin/env node
/* eslint-disable no-console */

const crypto = require('crypto');
const fs = require('fs');
const net = require('net');
const path = require('path');

const WORKSPACE = path.resolve(__dirname, '../..');
const BACKEND = path.join(WORKSPACE, 'backend');

process.env.TS_NODE_COMPILER_OPTIONS = JSON.stringify({
  module: 'CommonJS',
  moduleResolution: 'node',
  esModuleInterop: true,
  skipLibCheck: true,
});
require(path.join(WORKSPACE, 'backend/node_modules/ts-node/register/transpile-only'));

const dbConfig = {
  host: process.env.PGHOST || 'ubuntu.home.lab',
  port: Number(process.env.PGPORT || 5432),
  database: process.env.PGDATABASE || 'mydb',
  user: process.env.PGUSER || 'postgres',
  password: process.env.PGPASSWORD || 'password',
};

function getArg(name) {
  const prefix = `--${name}=`;
  const item = process.argv.find((arg) => arg.startsWith(prefix));
  return item ? item.slice(prefix.length) : undefined;
}

function quoteIdent(value) {
  if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(value)) {
    throw new Error(`Invalid SQL identifier: ${value}`);
  }
  return `"${value.replace(/"/g, '""')}"`;
}

function defaultSchemaName() {
  return `dcim_ontology_demo_${new Date().toISOString().replace(/[-:TZ.]/g, '').slice(0, 14)}`;
}

const importMock = (name) => require(path.join(BACKEND, 'mock', name)).default;

const mocks = {
  datacenter: importMock('datacenter.mock.ts'),
  cabinet: importMock('cabinet.mock.ts'),
  deviceTemplate: importMock('deviceTemplate.mock.ts'),
  device: importMock('device.mock.ts'),
  port: importMock('port.mock.ts'),
  connection: importMock('connection.mock.ts'),
  pdu: importMock('pdu.mock.ts'),
  power: importMock('powerTopology.mock.ts'),
  environment: importMock('environment.mock.ts'),
  alert: importMock('alert.mock.ts'),
  dashboard: importMock('dashboard.mock.ts'),
  layout: importMock('layout.mock.ts'),
};

function makeReq({ params = {}, query = {}, body = {} } = {}) {
  return { params, query, body };
}

async function callRoute(routes, key, options) {
  const handler = routes[key];
  if (!handler) throw new Error(`Missing mock route: ${key}`);

  return new Promise((resolve, reject) => {
    const res = {
      statusCode: 200,
      status(code) {
        this.statusCode = code;
        return this;
      },
      json(payload) {
        if (this.statusCode >= 400) {
          reject(new Error(`${key} returned ${this.statusCode}: ${JSON.stringify(payload)}`));
          return;
        }
        resolve(payload);
      },
    };

    Promise.resolve(handler(makeReq(options), res)).catch(reject);
  });
}

function cstring(value) {
  return Buffer.from(`${value}\0`);
}

function writeInt16(value) {
  const b = Buffer.alloc(2);
  b.writeInt16BE(value);
  return b;
}

function writeInt32(value) {
  const b = Buffer.alloc(4);
  b.writeInt32BE(value);
  return b;
}

function clientMessage(type, payload = Buffer.alloc(0)) {
  const len = writeInt32(payload.length + 4);
  return Buffer.concat([Buffer.from(type), len, payload]);
}

class PgWireClient {
  constructor(config) {
    this.config = config;
    this.socket = null;
    this.buffer = Buffer.alloc(0);
    this.messages = [];
    this.waiters = [];
  }

  async connect() {
    this.socket = net.createConnection({
      host: this.config.host,
      port: this.config.port,
    });

    this.socket.on('data', (chunk) => this.onData(chunk));
    this.socket.on('error', (error) => this.rejectNext(error));
    this.socket.on('close', () => this.rejectNext(new Error('PostgreSQL connection closed')));

    await new Promise((resolve, reject) => {
      this.socket.once('connect', resolve);
      this.socket.once('error', reject);
    });

    const params = Buffer.concat([
      writeInt32(196608),
      cstring('user'), cstring(this.config.user),
      cstring('database'), cstring(this.config.database),
      cstring('client_encoding'), cstring('UTF8'),
      cstring('DateStyle'), cstring('ISO'),
      Buffer.from([0]),
    ]);
    this.socket.write(Buffer.concat([writeInt32(params.length + 4), params]));

    await this.authenticate();
  }

  onData(chunk) {
    this.buffer = Buffer.concat([this.buffer, chunk]);
    while (this.buffer.length >= 5) {
      const type = String.fromCharCode(this.buffer[0]);
      const len = this.buffer.readInt32BE(1);
      if (this.buffer.length < len + 1) return;
      const payload = this.buffer.subarray(5, len + 1);
      this.buffer = this.buffer.subarray(len + 1);
      const msg = { type, payload };
      const waiter = this.waiters.shift();
      if (waiter) waiter.resolve(msg);
      else this.messages.push(msg);
    }
  }

  rejectNext(error) {
    const waiter = this.waiters.shift();
    if (waiter) waiter.reject(error);
  }

  readMessage() {
    const msg = this.messages.shift();
    if (msg) return Promise.resolve(msg);
    return new Promise((resolve, reject) => this.waiters.push({ resolve, reject }));
  }

  async authenticate() {
    while (true) {
      const msg = await this.readMessage();
      if (msg.type === 'R') {
        const code = msg.payload.readInt32BE(0);
        if (code === 0) continue;
        if (code === 3) {
          this.socket.write(clientMessage('p', cstring(this.config.password)));
          continue;
        }
        if (code === 5) {
          const salt = msg.payload.subarray(4, 8);
          const inner = crypto.createHash('md5').update(this.config.password + this.config.user).digest('hex');
          const outer = crypto.createHash('md5').update(Buffer.concat([Buffer.from(inner), salt])).digest('hex');
          this.socket.write(clientMessage('p', cstring(`md5${outer}`)));
          continue;
        }
        if (code === 10) {
          await this.scramAuthenticate(msg.payload.subarray(4));
          continue;
        }
        throw new Error(`Unsupported PostgreSQL auth code ${code}`);
      }
      if (msg.type === 'E') throw new Error(this.parseError(msg.payload));
      if (msg.type === 'Z') return;
    }
  }

  async scramAuthenticate(payload) {
    const mechanisms = payload.toString('utf8').split('\0').filter(Boolean);
    if (!mechanisms.includes('SCRAM-SHA-256')) {
      throw new Error(`Unsupported SASL mechanisms: ${mechanisms.join(', ')}`);
    }

    const clientNonce = crypto.randomBytes(18).toString('base64').replace(/=/g, '');
    const clientFirstBare = `n=${this.config.user},r=${clientNonce}`;
    const clientFirst = `n,,${clientFirstBare}`;
    this.socket.write(clientMessage('p', Buffer.concat([
      cstring('SCRAM-SHA-256'),
      writeInt32(Buffer.byteLength(clientFirst)),
      Buffer.from(clientFirst),
    ])));

    const cont = await this.readMessage();
    if (cont.type !== 'R' || cont.payload.readInt32BE(0) !== 11) {
      throw new Error('Expected SASLContinue during SCRAM auth');
    }
    const serverFirst = cont.payload.subarray(4).toString('utf8');
    const attrs = Object.fromEntries(serverFirst.split(',').map((part) => [part[0], part.slice(2)]));
    if (!attrs.r || !attrs.r.startsWith(clientNonce)) throw new Error('Invalid SCRAM nonce from server');

    const salt = Buffer.from(attrs.s, 'base64');
    const iterations = Number(attrs.i);
    const saltedPassword = crypto.pbkdf2Sync(this.config.password, salt, iterations, 32, 'sha256');
    const clientKey = crypto.createHmac('sha256', saltedPassword).update('Client Key').digest();
    const storedKey = crypto.createHash('sha256').update(clientKey).digest();
    const clientFinalNoProof = `c=biws,r=${attrs.r}`;
    const authMessage = `${clientFirstBare},${serverFirst},${clientFinalNoProof}`;
    const clientSignature = crypto.createHmac('sha256', storedKey).update(authMessage).digest();
    const proof = Buffer.alloc(clientKey.length);
    for (let i = 0; i < clientKey.length; i += 1) proof[i] = clientKey[i] ^ clientSignature[i];

    this.socket.write(clientMessage('p', Buffer.from(`${clientFinalNoProof},p=${proof.toString('base64')}`)));

    const final = await this.readMessage();
    if (final.type !== 'R' || final.payload.readInt32BE(0) !== 12) {
      throw new Error('Expected SASLFinal during SCRAM auth');
    }
  }

  parseError(payload) {
    const text = payload.toString('utf8');
    return text.split('\0').filter(Boolean).map((part) => part.slice(1)).join(' | ');
  }

  parseRows(rowDescription, rowPayload) {
    const values = [];
    let offset = 2;
    const fieldCount = rowPayload.readInt16BE(0);
    for (let i = 0; i < fieldCount; i += 1) {
      const len = rowPayload.readInt32BE(offset);
      offset += 4;
      if (len === -1) {
        values.push(null);
      } else {
        values.push(rowPayload.subarray(offset, offset + len).toString('utf8'));
        offset += len;
      }
    }
    return Object.fromEntries(rowDescription.map((name, index) => [name, values[index]]));
  }

  parseRowDescription(payload) {
    const count = payload.readInt16BE(0);
    let offset = 2;
    const fields = [];
    for (let i = 0; i < count; i += 1) {
      const end = payload.indexOf(0, offset);
      fields.push(payload.subarray(offset, end).toString('utf8'));
      offset = end + 1 + 18;
    }
    return fields;
  }

  async query(sql) {
    this.socket.write(clientMessage('Q', cstring(sql)));
    let rowDescription = [];
    const rows = [];
    while (true) {
      const msg = await this.readMessage();
      if (msg.type === 'T') rowDescription = this.parseRowDescription(msg.payload);
      else if (msg.type === 'D') rows.push(this.parseRows(rowDescription, msg.payload));
      else if (msg.type === 'E') throw new Error(this.parseError(msg.payload));
      else if (msg.type === 'Z') return rows;
    }
  }

  end() {
    if (this.socket) this.socket.end(clientMessage('X'));
  }
}

const sql = {
  lit(value) {
    if (value === undefined || value === null) return 'null';
    if (typeof value === 'number') return Number.isFinite(value) ? String(value) : 'null';
    if (typeof value === 'boolean') return value ? 'true' : 'false';
    return `'${String(value).replace(/'/g, "''")}'`;
  },
  json(value) {
    return `${this.lit(JSON.stringify(value ?? null))}::jsonb`;
  },
  textArray(value) {
    if (!value) return 'null';
    return `ARRAY[${value.map((item) => this.lit(item)).join(',')}]::text[]`;
  },
};

function insert(table, rows) {
  if (!rows.length) return '';
  const columns = Object.keys(rows[0]);
  const values = rows.map((row) => `(${columns.map((col) => row[col]).join(', ')})`).join(',\n');
  return `insert into ${table} (${columns.join(', ')}) values\n${values};`;
}

function asData(payload) {
  if (!payload.success) throw new Error(`Mock response failed: ${JSON.stringify(payload)}`);
  return payload.data;
}

async function collectMockData() {
  const datacenters = asData(await callRoute(mocks.datacenter, 'GET /api/idc/datacenters', { query: { current: 1, pageSize: 1000 } }));
  const cabinets = asData(await callRoute(mocks.cabinet, 'GET /api/idc/cabinets', { query: { current: 1, pageSize: 1000 } }));
  const deviceTemplates = asData(await callRoute(mocks.deviceTemplate, 'GET /api/idc/device-templates/all'));
  const devices = asData(await callRoute(mocks.device, 'GET /api/idc/devices', { query: { current: 1, pageSize: 1000 } }));
  const ports = (await Promise.all(devices.map((device) =>
    callRoute(mocks.port, 'GET /api/idc/ports/by-device/:deviceId', { params: { deviceId: device.id } }).then(asData)
  ))).flat();
  const connections = asData(await callRoute(mocks.connection, 'GET /api/idc/connections', { query: { current: 1, pageSize: 1000 } }));
  const pduDevices = asData(await callRoute(mocks.pdu, 'GET /api/pdu/devices'));
  const pduTemplates = asData(await callRoute(mocks.pdu, 'GET /api/pdu/templates'));
  const powerTopology = asData(await callRoute(mocks.power, 'GET /api/power/topology'));
  const powerRedundancy = asData(await callRoute(mocks.power, 'GET /api/power/redundancy'));
  const powerLoadBalance = asData(await callRoute(mocks.power, 'GET /api/power/load-balance'));
  const cabinetEnvironment = asData(await callRoute(mocks.environment, 'GET /api/idc/environment/cabinets'));
  const cabinetSensors = (await Promise.all(cabinets.map((cabinet) =>
    callRoute(mocks.environment, 'GET /api/idc/environment/cabinet/:cabinetId', { params: { cabinetId: cabinet.id } }).then(asData)
  ))).flat();
  const temperatureTrend = asData(await callRoute(mocks.environment, 'GET /api/idc/environment/temperature-trend', { query: { hours: 24 } }));
  const pueTrend = (await Promise.all(datacenters.map((dc) =>
    callRoute(mocks.environment, 'GET /api/idc/environment/pue-trend', { query: { datacenterId: dc.id, days: 30 } }).then(asData)
  ))).flat();
  const energyStats = asData(await callRoute(mocks.environment, 'GET /api/idc/environment/energy-stats'));
  const powerConsumption = asData(await callRoute(mocks.environment, 'GET /api/idc/environment/power'));
  const environmentOverview = asData(await callRoute(mocks.environment, 'GET /api/idc/environment/overview'));
  const alerts = asData(await callRoute(mocks.alert, 'GET /api/idc/alerts', { query: { current: 1, pageSize: 1000 } }));
  const alertRules = asData(await callRoute(mocks.alert, 'GET /api/idc/alert-rules'));
  const alertStats = asData(await callRoute(mocks.alert, 'GET /api/idc/alerts/stats'));
  const dashboardStats = asData(await callRoute(mocks.dashboard, 'GET /api/idc/dashboard/stats'));
  const deviceTrend = asData(await callRoute(mocks.dashboard, 'GET /api/idc/dashboard/device-trend', { query: { days: 7 } }));
  const cabinetUsageRank = asData(await callRoute(mocks.dashboard, 'GET /api/idc/dashboard/cabinet-usage-rank', { query: { limit: 10 } }));
  const deviceCategory = asData(await callRoute(mocks.dashboard, 'GET /api/idc/dashboard/device-category'));
  const datacenterLoad = asData(await callRoute(mocks.dashboard, 'GET /api/idc/dashboard/datacenter-load'));
  const recentOperations = asData(await callRoute(mocks.dashboard, 'GET /api/idc/dashboard/recent-operations', { query: { limit: 10 } }));
  const topologies = await Promise.all(datacenters.map((dc) =>
    callRoute(mocks.dashboard, 'GET /api/idc/topology/:datacenterId', { params: { datacenterId: dc.id } }).then(asData)
  ));
  const layouts = await Promise.all(datacenters.map((dc) =>
    callRoute(mocks.layout, 'GET /api/idc/datacenters/:id/layout', { params: { id: dc.id } }).then(asData)
  ));

  return {
    datacenters,
    cabinets,
    deviceTemplates,
    devices,
    ports,
    connections,
    pduDevices,
    pduTemplates,
    powerTopology,
    powerRedundancy,
    powerLoadBalance,
    cabinetEnvironment,
    cabinetSensors,
    temperatureTrend,
    pueTrend,
    energyStats,
    powerConsumption,
    environmentOverview,
    alerts,
    alertRules,
    alertStats,
    dashboardStats,
    deviceTrend,
    cabinetUsageRank,
    deviceCategory,
    datacenterLoad,
    recentOperations,
    topologies,
    layouts,
  };
}

function templateIdForPdu(template, index) {
  return template.id || `tpl-pdu-${String(index + 1).padStart(3, '0')}`;
}

function pduTemplateId(device, pduTemplates) {
  const match = pduTemplates.find((tpl) =>
    tpl.brand === device.pduData?.brand && tpl.model === device.pduData?.model
  );
  return match ? templateIdForPdu(match, pduTemplates.indexOf(match)) : null;
}

function findCabinet(cabinets, id) {
  return cabinets.find((cabinet) => cabinet.id === id);
}

function rowsFor(data) {
  const allTemplates = [
    ...data.deviceTemplates.map((t) => ({ ...t, normalizedCategory: t.category })),
    ...data.pduTemplates.map((t, index) => ({
      id: templateIdForPdu(t, index),
      name: `${t.brand} ${t.model}`,
      category: 'pdu',
      brand: t.brand,
      model: t.model,
      uHeight: t.uHeight,
      portGroups: t.portGroups || [],
      isBuiltin: true,
      specs: t.specs,
      maxPower: Number.parseFloat(String(t.specs?.maxLoad || '').replace(/[^\d.]/g, '')) || null,
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
      normalizedCategory: 'pdu',
    })),
  ];

  const powerNodeType = Object.fromEntries(data.powerTopology.nodes.map((node) => [node.id, node.type]));
  const observations = [];
  data.cabinetSensors.forEach((sensor) => {
    observations.push({
      id: sql.lit(`obs-${sensor.id}-temperature`),
      target_type: sql.lit('cabinet'),
      target_id: sql.lit(sensor.cabinetId),
      sensor_id: sql.lit(sensor.id),
      sensor_position: sql.lit(sensor.position),
      metric: sql.lit('temperature'),
      value_num: sql.lit(sensor.temperature),
      unit: sql.lit('Celsius'),
      observed_at: sql.lit(sensor.lastUpdated),
    });
    observations.push({
      id: sql.lit(`obs-${sensor.id}-humidity`),
      target_type: sql.lit('cabinet'),
      target_id: sql.lit(sensor.cabinetId),
      sensor_id: sql.lit(sensor.id),
      sensor_position: sql.lit(sensor.position),
      metric: sql.lit('humidity'),
      value_num: sql.lit(sensor.humidity),
      unit: sql.lit('Percent'),
      observed_at: sql.lit(sensor.lastUpdated),
    });
  });
  data.powerConsumption.forEach((item) => {
    [
      ['active_power', item.activePower, 'kW'],
      ['apparent_power', item.apparentPower, 'kVA'],
      ['power_factor', item.powerFactor, 'Ratio'],
      ['energy', item.energy, 'kWh'],
      ['current', item.current, 'A'],
      ['voltage', item.voltage, 'V'],
    ].forEach(([metric, value, unit]) => {
      if (value !== undefined) {
        observations.push({
          id: sql.lit(`obs-${item.id}-${metric}`),
          target_type: sql.lit('cabinet'),
          target_id: sql.lit(item.cabinetId),
          sensor_id: 'null',
          sensor_position: 'null',
          metric: sql.lit(metric),
          value_num: sql.lit(value),
          unit: sql.lit(unit),
          observed_at: sql.lit(item.timestamp),
        });
      }
    });
  });

  return {
    datacenter: data.datacenters.map((dc) => ({
      id: sql.lit(dc.id),
      name: sql.lit(dc.name),
      code: sql.lit(dc.code),
      address: sql.lit(dc.address),
      area_sqm: sql.lit(dc.area),
      lifecycle_status: sql.lit(dc.status),
      description: sql.lit(dc.description),
      contact: sql.lit(dc.contact),
      phone: sql.lit(dc.phone),
      created_at: sql.lit(dc.createdAt),
      updated_at: sql.lit(dc.updatedAt),
    })),
    cabinet: data.cabinets.map((cabinet) => ({
      id: sql.lit(cabinet.id),
      datacenter_id: sql.lit(cabinet.datacenterId),
      name: sql.lit(cabinet.name),
      code: sql.lit(cabinet.code),
      row_no: sql.lit(cabinet.row),
      column_no: sql.lit(cabinet.column),
      u_height: sql.lit(cabinet.uHeight),
      max_power_w: sql.lit(cabinet.maxPower),
      health_status: sql.lit(cabinet.status),
      description: sql.lit(cabinet.description),
      created_at: sql.lit(cabinet.createdAt),
      updated_at: sql.lit(cabinet.updatedAt),
    })),
    device_template: allTemplates.map((tpl) => ({
      id: sql.lit(tpl.id),
      name: sql.lit(tpl.name),
      category: sql.lit(tpl.normalizedCategory),
      brand: sql.lit(tpl.brand),
      model: sql.lit(tpl.model),
      u_height: sql.lit(tpl.uHeight),
      front_color: sql.lit(tpl.frontColor),
      rear_color: sql.lit(tpl.rearColor),
      model3d_url: sql.lit(tpl.model3dUrl),
      image_url: sql.lit(tpl.imageUrl),
      is_builtin: sql.lit(Boolean(tpl.isBuiltin)),
      max_power_w: sql.lit(tpl.maxPower),
      spec_json: sql.json(tpl.specs || {}),
      description: sql.lit(tpl.description),
      created_at: sql.lit(tpl.createdAt),
      updated_at: sql.lit(tpl.updatedAt),
    })),
    port_group_template: allTemplates.flatMap((tpl) => (tpl.portGroups || []).map((group) => ({
      id: sql.lit(group.id),
      template_id: sql.lit(tpl.id),
      name: sql.lit(group.name),
      port_type: sql.lit(group.portType),
      port_count: sql.lit(group.count),
      speed: sql.lit(group.speed),
      poe: sql.lit(Boolean(group.poe)),
    }))),
    device: data.devices.map((device) => ({
      id: sql.lit(device.id),
      template_id: sql.lit(device.templateId),
      asset_code: sql.lit(device.assetCode),
      name: sql.lit(device.name),
      serial_number: sql.lit(device.serialNumber),
      management_ip: sql.lit(device.managementIp),
      operational_status: sql.lit(device.status),
      purchase_date: sql.lit(device.purchaseDate),
      warranty_expiry: sql.lit(device.warrantyExpiry),
      vendor: sql.lit(device.vendor),
      owner: sql.lit(device.owner),
      department: sql.lit(device.department),
      description: sql.lit(device.description),
      created_at: sql.lit(device.createdAt),
      updated_at: sql.lit(device.updatedAt),
    })),
    pdu: data.pduDevices.map((device) => ({
      id: sql.lit(device.id),
      template_id: sql.lit(pduTemplateId(device, data.pduTemplates)),
      cabinet_id: sql.lit(device.cabinetId),
      name: sql.lit(device.name),
      asset_code: sql.lit(device.assetCode),
      management_ip: sql.lit(device.managementIp),
      power_path: sql.lit(device.pduData?.powerPath || 'unknown'),
      input_voltage: sql.lit(device.pduData?.inputVoltage),
      output_ports: sql.lit(device.pduData?.outputPorts),
      max_load_w: sql.lit(device.pduData?.maxLoad),
      current_load_w: sql.lit(device.pduData?.currentLoad),
      brand: sql.lit(device.pduData?.brand),
      model: sql.lit(device.pduData?.model),
      operational_status: sql.lit(device.status),
      created_at: sql.lit(device.createdAt),
      updated_at: sql.lit(device.updatedAt),
    })),
    rack_installation: [
      ...data.devices.map((device) => ({
        asset_type: sql.lit('device'),
        device_id: sql.lit(device.id),
        pdu_id: 'null',
        cabinet_id: sql.lit(device.cabinetId),
        start_u: sql.lit(device.startU),
        end_u: sql.lit(device.endU),
        valid_from: sql.lit(device.createdAt),
      })),
      ...data.pduDevices.map((device) => ({
        asset_type: sql.lit('pdu'),
        device_id: 'null',
        pdu_id: sql.lit(device.id),
        cabinet_id: sql.lit(device.cabinetId),
        start_u: sql.lit(device.startU),
        end_u: sql.lit(device.endU),
        valid_from: sql.lit(device.createdAt),
      })),
    ],
    port: data.ports.map((port) => ({
      id: sql.lit(port.id),
      device_id: sql.lit(port.deviceId),
      port_group_id: sql.lit(port.portGroupId),
      port_number: sql.lit(port.portNumber),
      port_alias: sql.lit(port.portAlias),
      port_type: sql.lit(port.portType),
      speed: sql.lit(port.speed),
      admin_status: sql.lit(port.status),
      link_status: sql.lit(port.linkStatus),
      vlan_config: port.vlanConfig ? sql.json(port.vlanConfig) : 'null',
      qos_config: port.qosConfig ? sql.json(port.qosConfig) : 'null',
      mac_bindings: sql.textArray(port.macBindings),
      port_security: sql.lit(port.portSecurity),
      max_mac_count: sql.lit(port.maxMacCount),
      dot1x_enabled: sql.lit(port.dot1xEnabled),
      connection_purpose: sql.lit(port.connectionPurpose),
      description: sql.lit(port.description),
      last_updated: sql.lit(port.lastUpdated),
    })),
    cable_connection: data.connections.map((conn) => ({
      id: sql.lit(conn.id),
      cable_number: sql.lit(conn.cableNumber),
      connection_type: sql.lit(conn.connectionType),
      cable_type: sql.lit(conn.cableType),
      cable_color: sql.lit(conn.cableColor),
      cable_length_m: sql.lit(conn.cableLength),
      source_device_id: sql.lit(conn.sourceDeviceId),
      source_port_id: sql.lit(conn.sourcePortId),
      target_device_id: sql.lit(conn.targetDeviceId),
      target_port_id: sql.lit(conn.targetPortId),
      status: sql.lit(conn.status),
      description: sql.lit(conn.description),
      created_at: sql.lit(conn.createdAt),
      updated_at: sql.lit(conn.updatedAt),
    })),
    power_node: data.powerTopology.nodes.map((node) => ({
      id: sql.lit(node.id),
      datacenter_id: sql.lit(node.datacenterId),
      node_type: sql.lit(node.type),
      name: sql.lit(node.name),
      status: sql.lit(node.status),
      load_w: sql.lit(node.load),
      capacity_w: sql.lit(node.capacity),
    })),
    power_connection: data.powerTopology.links.map((link) => ({
      id: sql.lit(link.id),
      datacenter_id: sql.lit(link.datacenterId),
      source_node_id: sql.lit(link.source),
      target_node_id: sql.lit(link.target),
      target_node_type: sql.lit(powerNodeType[link.target] || 'device'),
      power_path: sql.lit(link.powerPath || 'unknown'),
      status: sql.lit(link.status),
      valid_from: sql.lit('2024-01-01T00:00:00Z'),
    })),
    observation: observations,
    pue_daily: data.pueTrend.map((item) => ({
      datacenter_id: sql.lit(item.datacenterId),
      metric_date: sql.lit(item.date),
      pue: sql.lit(item.pue),
      it_power_kw: sql.lit(item.itPower),
      total_power_kw: sql.lit(item.totalPower),
      cooling_power_kw: sql.lit(item.coolingPower),
    })),
    alert_rule: data.alertRules.map((rule) => ({
      id: sql.lit(rule.id),
      name: sql.lit(rule.name),
      rule_type: sql.lit(rule.type),
      enabled: sql.lit(rule.enabled),
      condition_json: sql.json(rule.condition),
      severity: sql.lit(rule.severity),
      notification_json: sql.json(rule.notification),
      scope_json: rule.scope ? sql.json(rule.scope) : 'null',
      created_at: sql.lit(rule.createdAt),
      updated_at: sql.lit(rule.updatedAt),
    })),
    alert_event: data.alerts.map((alert) => ({
      id: sql.lit(alert.id),
      level: sql.lit(alert.level),
      alert_type: sql.lit(alert.type),
      source: sql.lit(alert.source),
      rule_id: sql.lit(alert.ruleId),
      device_id: sql.lit(alert.deviceId),
      cabinet_id: sql.lit(alert.cabinetId),
      datacenter_id: sql.lit(alert.datacenterId),
      message: sql.lit(alert.message),
      value_num: sql.lit(alert.value),
      threshold_num: sql.lit(alert.threshold),
      acknowledged: sql.lit(alert.acknowledged),
      acknowledged_at: sql.lit(alert.acknowledgedAt),
      acknowledged_by: sql.lit(alert.acknowledgedBy),
      resolved_at: sql.lit(alert.resolvedAt),
      resolved_by: sql.lit(alert.resolvedBy),
      notes: sql.lit(alert.notes),
      created_at: sql.lit(alert.createdAt),
    })),
    layout_snapshot: data.layouts.map((layout) => ({
      datacenter_id: sql.lit(layout.datacenterId),
      version: sql.lit(layout.version),
      canvas_width: sql.lit(layout.canvasWidth),
      canvas_height: sql.lit(layout.canvasHeight),
      px_per_meter: sql.lit(layout.pxPerMeter),
      raw_json: sql.json(layout),
      updated_at: sql.lit(layout.updatedAt),
    })),
    layout_cabinet_position: data.layouts.flatMap((layout) => layout.cabinets.map((item) => ({
      datacenter_id: sql.lit(layout.datacenterId),
      cabinet_id: sql.lit(item.cabinetId),
      x: sql.lit(item.x),
      y: sql.lit(item.y),
      rotation: sql.lit(item.rotation),
    }))),
    layout_zone: data.layouts.flatMap((layout) => layout.zones.map((item) => ({
      id: sql.lit(item.id),
      datacenter_id: sql.lit(layout.datacenterId),
      zone_type: sql.lit(item.type),
      name: sql.lit(item.name),
      x: sql.lit(item.x),
      y: sql.lit(item.y),
      width: sql.lit(item.width),
      height: sql.lit(item.height),
      rotation: sql.lit(item.rotation),
      color: sql.lit(item.color),
    }))),
    layout_facility: data.layouts.flatMap((layout) => layout.facilities.map((item) => ({
      id: sql.lit(item.id),
      datacenter_id: sql.lit(layout.datacenterId),
      facility_type: sql.lit(item.type),
      name: sql.lit(item.name),
      x: sql.lit(item.x),
      y: sql.lit(item.y),
      rotation: sql.lit(item.rotation),
    }))),
    dashboard_snapshot: [
      ['dashboard_stats', null, data.dashboardStats],
      ['device_trend', null, data.deviceTrend],
      ['cabinet_usage_rank', null, data.cabinetUsageRank],
      ['device_category', null, data.deviceCategory],
      ['datacenter_load', null, data.datacenterLoad],
      ['power_redundancy', null, data.powerRedundancy],
      ['power_load_balance', null, data.powerLoadBalance],
      ['cabinet_environment', null, data.cabinetEnvironment],
      ['temperature_trend', null, data.temperatureTrend],
      ['energy_stats', null, data.energyStats],
      ['environment_overview', null, data.environmentOverview],
      ['alert_stats', null, data.alertStats],
    ].map(([type, scope, payload]) => ({
      id: sql.lit(`snapshot-${type}`),
      snapshot_type: sql.lit(type),
      scope_id: sql.lit(scope),
      payload: sql.json(payload),
    })),
    operation_record: data.recentOperations.map((op) => ({
      id: sql.lit(op.id),
      operation_type: sql.lit(op.type),
      operator_name: sql.lit(op.operator),
      target: sql.lit(op.target),
      description: sql.lit(op.description),
      created_at: sql.lit(op.createdAt),
    })),
    topology_snapshot: data.topologies.map((topology) => ({
      id: sql.lit(`topology-${topology.datacenterId}`),
      datacenter_id: sql.lit(topology.datacenterId),
      payload: sql.json(topology),
    })),
    mock_raw_payload: Object.entries(data).map(([key, value]) => ({
      id: sql.lit(`raw-${key}`),
      source_name: sql.lit(key),
      payload: sql.json(value),
    })),
  };
}

function ontologyRows(data) {
  const individuals = [];
  const relationships = [];
  const addIndividual = (sourceTable, sourceId, ontologyClass, label) => {
    const id = `${sourceTable}:${sourceId}:${ontologyClass}`;
    individuals.push({
      id: sql.lit(id),
      ontology_class: sql.lit(ontologyClass),
      source_table: sql.lit(sourceTable),
      source_id: sql.lit(sourceId),
      label: sql.lit(label),
    });
    return id;
  };
  const addRel = (relationshipType, sourceId, targetId, factTable, factId, validFrom = '2024-01-01T00:00:00Z') => {
    relationships.push({
      id: sql.lit(`${relationshipType}:${sourceId}->${targetId}:${factId || 'fact'}`.replace(/'/g, '')),
      relationship_type: sql.lit(relationshipType),
      source_individual_id: sql.lit(sourceId),
      target_individual_id: sql.lit(targetId),
      fact_table: sql.lit(factTable),
      fact_id: sql.lit(factId),
      valid_from: sql.lit(validFrom),
    });
  };

  const dcIds = Object.fromEntries(data.datacenters.map((dc) => [dc.id, addIndividual('datacenter', dc.id, 'Datacenter', dc.name)]));
  const cabinetIds = Object.fromEntries(data.cabinets.map((cabinet) => [cabinet.id, addIndividual('cabinet', cabinet.id, 'Cabinet', cabinet.name)]));
  const templateIds = Object.fromEntries(data.deviceTemplates.map((tpl) => [tpl.id, addIndividual('device_template', tpl.id, 'ProductModel', tpl.name)]));
  data.pduTemplates.forEach((tpl, index) => {
    const id = templateIdForPdu(tpl, index);
    templateIds[id] = addIndividual('device_template', id, 'ProductModel', `${tpl.brand} ${tpl.model}`);
  });
  const deviceIds = Object.fromEntries(data.devices.map((device) => {
    const category = data.deviceTemplates.find((tpl) => tpl.id === device.templateId)?.category || 'Device';
    return [device.id, addIndividual('device', device.id, category[0].toUpperCase() + category.slice(1), device.name)];
  }));
  const pduIds = Object.fromEntries(data.pduDevices.map((pdu) => [pdu.id, addIndividual('pdu', pdu.id, 'PowerDistributionUnit', pdu.name)]));
  const portIds = Object.fromEntries(data.ports.map((port) => [port.id, addIndividual('port', port.id, 'Port', port.portNumber)]));
  const powerNodeIds = Object.fromEntries(data.powerTopology.nodes.map((node) => [
    node.id,
    addIndividual('power_node', node.id, node.type === 'utility' ? 'UtilityFeed' : node.type.toUpperCase(), node.name),
  ]));

  data.cabinets.forEach((cabinet) => addRel('contains', dcIds[cabinet.datacenterId], cabinetIds[cabinet.id], 'cabinet', cabinet.id, cabinet.createdAt));
  data.devices.forEach((device) => {
    addRel('hasProductModel', deviceIds[device.id], templateIds[device.templateId], 'device', device.id, device.createdAt);
    addRel('installedIn', deviceIds[device.id], cabinetIds[device.cabinetId], 'rack_installation', device.id, device.createdAt);
  });
  data.pduDevices.forEach((pdu) => {
    const templateId = pduTemplateId(pdu, data.pduTemplates);
    if (templateId) addRel('hasProductModel', pduIds[pdu.id], templateIds[templateId], 'pdu', pdu.id, pdu.createdAt);
    addRel('installedIn', pduIds[pdu.id], cabinetIds[pdu.cabinetId], 'rack_installation', pdu.id, pdu.createdAt);
  });
  data.ports.forEach((port) => addRel('hasPort', deviceIds[port.deviceId], portIds[port.id], 'port', port.id, port.lastUpdated));
  data.connections.forEach((conn) => addRel('connectedByCable', portIds[conn.sourcePortId], portIds[conn.targetPortId], 'cable_connection', conn.id, conn.createdAt));
  data.powerTopology.links.forEach((link) => addRel('poweredBy', powerNodeIds[link.target], powerNodeIds[link.source], 'power_connection', link.id));

  return { ontology_individual: individuals, ontology_relationship: relationships };
}

function buildMigrationSql(data, schemaName) {
  const schema = fs.readFileSync(path.join(__dirname, 'postgresql-schema.sql'), 'utf8');
  const tables = [
    'mock_raw_payload', 'topology_snapshot', 'operation_record', 'dashboard_snapshot',
    'layout_facility', 'layout_zone', 'layout_cabinet_position', 'layout_snapshot',
    'alert_event', 'alert_rule', 'pue_daily', 'observation', 'power_connection',
    'power_node', 'cable_connection', 'port', 'rack_installation', 'pdu', 'device',
    'port_group_template', 'device_template', 'ontology_relationship', 'ontology_individual',
    'cabinet', 'datacenter',
  ];
  const rows = { ...rowsFor(data), ...ontologyRows(data) };
  const ordered = [
    'datacenter', 'ontology_individual', 'cabinet', 'device_template', 'port_group_template',
    'device', 'pdu', 'rack_installation', 'port', 'cable_connection', 'power_node',
    'power_connection', 'observation', 'pue_daily', 'alert_rule', 'alert_event',
    'layout_snapshot', 'layout_cabinet_position', 'layout_zone', 'layout_facility',
    'dashboard_snapshot', 'operation_record', 'topology_snapshot', 'mock_raw_payload',
    'ontology_relationship',
  ];

  return [
    'begin;',
    `create schema if not exists ${quoteIdent(schemaName)};`,
    `set search_path to ${quoteIdent(schemaName)};`,
    ...tables.map((table) => `drop table if exists ${table} cascade;`),
    schema,
    ...ordered.map((table) => insert(table, rows[table] || '')).filter(Boolean),
    'commit;',
  ].join('\n\n');
}

async function verify(client, expected, schemaName) {
  await client.query(`set search_path to ${quoteIdent(schemaName)};`);
  const tables = [
    'datacenter', 'cabinet', 'device_template', 'device', 'pdu', 'rack_installation',
    'port', 'cable_connection', 'power_node', 'power_connection', 'observation',
    'pue_daily', 'alert_rule', 'alert_event', 'ontology_individual', 'ontology_relationship',
    'mock_raw_payload',
  ];
  const rows = await client.query(`
    select table_name, row_count::text
    from (
      ${tables.map((table) => `select '${table}' as table_name, count(*) as row_count from ${table}`).join('\nunion all\n')}
    ) s
    order by table_name;
  `);

  const integrity = await client.query(`
    select 'devices_without_template' as check_name, count(*)::text as failures
    from device d left join device_template t on t.id = d.template_id where t.id is null
    union all
    select 'connections_without_ports', count(*)::text
    from cable_connection c
    left join port sp on sp.id = c.source_port_id
    left join port tp on tp.id = c.target_port_id
    where sp.id is null or tp.id is null
    union all
    select 'installations_without_cabinet', count(*)::text
    from rack_installation ri left join cabinet c on c.id = ri.cabinet_id where c.id is null
    union all
    select 'power_links_without_nodes', count(*)::text
    from power_connection pc
    left join power_node s on s.id = pc.source_node_id
    left join power_node t on t.id = pc.target_node_id
    where s.id is null or t.id is null
    union all
    select 'ontology_missing_installedIn', count(*)::text
    from device d
    where not exists (
      select 1 from ontology_relationship r
      where r.relationship_type = 'installedIn' and r.fact_id = d.id
    );
  `);

  console.log('\nImported row counts:');
  rows.forEach((row) => console.log(`  ${row.table_name}: ${row.row_count}`));
  console.log('\nIntegrity checks:');
  integrity.forEach((row) => console.log(`  ${row.check_name}: ${row.failures}`));

  const failures = integrity.filter((row) => row.failures !== '0');
  if (failures.length) throw new Error(`Integrity checks failed: ${JSON.stringify(failures)}`);

  const rowMap = Object.fromEntries(rows.map((row) => [row.table_name, Number(row.row_count)]));
  for (const [table, count] of Object.entries(expected)) {
    if (rowMap[table] !== count) {
      throw new Error(`Unexpected ${table} count: expected ${count}, got ${rowMap[table]}`);
    }
  }
}

async function main() {
  const execute = process.argv.includes('--execute');
  const schemaName = getArg('schema') || process.env.PGSCHEMA || defaultSchemaName();
  const data = await collectMockData();
  const migrationSql = buildMigrationSql(data, schemaName);
  const out = path.join(__dirname, 'generated-mock-migration.sql');
  fs.writeFileSync(out, migrationSql);
  console.log(`Generated SQL: ${out}`);
  console.log(`Target schema: ${schemaName}`);

  if (!execute) {
    console.log('Default mode: skipped PostgreSQL execution. Re-run with --execute to create the target schema and import data.');
    return;
  }

  const client = new PgWireClient(dbConfig);
  await client.connect();
  try {
    await client.query(migrationSql);
    await verify(client, {
      datacenter: data.datacenters.length,
      cabinet: data.cabinets.length,
      device: data.devices.length,
      pdu: data.pduDevices.length,
      port: data.ports.length,
      cable_connection: data.connections.length,
      power_node: data.powerTopology.nodes.length,
      power_connection: data.powerTopology.links.length,
      alert_rule: data.alertRules.length,
      alert_event: data.alerts.length,
      mock_raw_payload: Object.keys(data).length,
    }, schemaName);
  } finally {
    client.end();
  }
}

main().catch((error) => {
  console.error(error.stack || error.message);
  process.exit(1);
});
