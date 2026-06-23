const { spawn } = require('node:child_process');

const npmCommand = process.platform === 'win32' ? 'npm.cmd' : 'npm';
const isWindows = process.platform === 'win32';

const processes = [
  start('backend', ['run', 'dev:backend']),
  start('frontend', ['run', 'dev:frontend']),
];

let shuttingDown = false;

process.on('SIGINT', () => shutdown('SIGINT', 130));
process.on('SIGTERM', () => shutdown('SIGTERM', 143));

function start(name, args) {
  const child = spawn(npmCommand, args, {
    cwd: process.cwd(),
    stdio: 'inherit',
    detached: !isWindows,
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
