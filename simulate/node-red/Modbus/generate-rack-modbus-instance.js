const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

function readArgument(name) {
  const index = process.argv.indexOf(`--${name}`);
  return index === -1 ? undefined : process.argv[index + 1];
}

const instanceName = readArgument('name');
const portText = readArgument('port');
const outputArgument = readArgument('output');
const port = Number(portText);

if (!instanceName || !portText || !Number.isInteger(port) || port < 1 || port > 65535) {
  console.error(
    'Usage: node generate-rack-modbus-instance.js --name <instance-name> --port <1-65535> [--output <file>]',
  );
  process.exit(1);
}

const templatePath = path.join(__dirname, 'node-red-rack-modbus-simulator.json');
const template = JSON.parse(fs.readFileSync(templatePath, 'utf8'));
const idMap = new Map(template.map((node) => [node.id, crypto.randomBytes(8).toString('hex')]));

function remapIds(value) {
  if (Array.isArray(value)) {
    return value.map(remapIds);
  }

  if (value && typeof value === 'object') {
    return Object.fromEntries(Object.entries(value).map(([key, item]) => [key, remapIds(item)]));
  }

  return typeof value === 'string' && idMap.has(value) ? idMap.get(value) : value;
}

const flow = remapIds(template);

for (const node of flow) {
  if (node.info) {
    node.info = node.info.replaceAll('1502', String(port));
  }

  if (node.type === 'tab') {
    node.label = `${instanceName} Modbus TCP 仿真器 :${port}`;
    continue;
  }

  if (node.name) {
    node.name = `[${instanceName}] ${node.name.replaceAll('1502', String(port))}`;
  }

  if (node.type === 'modbus-server') {
    node.serverPort = port;
  }

  if (node.type === 'modbus-client') {
    node.tcpPort = String(port);
    node.name = `[${instanceName}] Local Rack Simulator :${port}`;
  }
}

const safeName = instanceName
  .trim()
  .replace(/[^\p{L}\p{N}._-]+/gu, '-')
  .replace(/^-+|-+$/g, '') || 'rack';
const outputPath = path.resolve(
  outputArgument || path.join(process.cwd(), `node-red-rack-modbus-${safeName}-${port}.json`),
);

fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, `${JSON.stringify(flow, null, 2)}\n`, 'utf8');
console.log(outputPath);
