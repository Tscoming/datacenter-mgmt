const { spawn } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

const npmCommand = process.platform === 'win32' ? 'npm.cmd' : 'npm';
const isWindows = process.platform === 'win32';

loadRootEnv();

const processes = [
  start('backend', ['run', 'dev:backend']),
  start('frontend', ['run', 'dev:frontend']),
];

let shuttingDown = false;

process.on('SIGINT', () => shutdown('SIGINT', 130));
process.on('SIGTERM', () => shutdown('SIGTERM', 143));

function start(name, args) {
  const env = { ...process.env };
  if (name === 'frontend') {
    env.PORT = getFrontendPort();
  }

  const child = spawn(npmCommand, args, {
    cwd: process.cwd(),
    env,
    stdio: 'inherit',
    detached: !isWindows,
    shell: isWindows,
  });

  child.on('exit', (code, signal) => {
    if (shuttingDown) {
      return;
    }

    const exitCode = code ?? signalToExitCode(signal);
    console.error(`${name} exited; stopping dev servers.`);
    shutdown('SIGTERM', exitCode);
  });

  return child;
}

function loadRootEnv() {
  const envFile = path.resolve(process.cwd(), '.env');
  if (!fs.existsSync(envFile)) {
    return;
  }

  const content = fs.readFileSync(envFile, 'utf8');
  for (const line of content.split(/\r?\n/)) {
    const parsed = parseEnvLine(line);
    if (!parsed || process.env[parsed.key] !== undefined) {
      continue;
    }
    process.env[parsed.key] = parsed.value;
  }
}

function parseEnvLine(line) {
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith('#')) {
    return null;
  }

  const separator = trimmed.indexOf('=');
  if (separator < 0) {
    return null;
  }

  const key = trimmed.slice(0, separator).trim();
  let value = trimmed.slice(separator + 1).trim();

  if (
    (value.startsWith('"') && value.endsWith('"')) ||
    (value.startsWith("'") && value.endsWith("'"))
  ) {
    value = value.slice(1, -1);
  }

  return key ? { key, value } : null;
}

function getFrontendPort() {
  return process.env.FRONTEND_PORT || '8000';
}

function shutdown(signal, exitCode) {
  if (shuttingDown) {
    return;
  }

  shuttingDown = true;
  process.exitCode = exitCode;

  for (const child of processes) {
    stop(child, signal);
  }

  setTimeout(() => {
    for (const child of processes) {
      stop(child, 'SIGKILL');
    }
    process.exit(exitCode);
  }, 3000).unref();
}

function stop(child, signal) {
  if (child.exitCode !== null || child.signalCode !== null) {
    return;
  }

  try {
    if (isWindows) {
      spawn('taskkill', ['/pid', String(child.pid), '/t', '/f'], { stdio: 'ignore' });
      return;
    }

    process.kill(-child.pid, signal);
  } catch (error) {
    if (error.code !== 'ESRCH') {
      console.error(`Failed to stop process ${child.pid}: ${error.message}`);
    }
  }
}

function signalToExitCode(signal) {
  if (signal === 'SIGINT') {
    return 130;
  }
  if (signal === 'SIGTERM') {
    return 143;
  }
  return 1;
}
