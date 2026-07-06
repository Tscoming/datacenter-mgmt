import express from 'express';
import { loadEnv } from './env';
import { loadMockRouteModules } from './mockRoutes';
import { requestLogger } from './requestLogger';
import { registerMockRoutes } from './registerMockRoutes';

loadEnv();

const app = express();
const port = Number(process.env.PORT || 8008);
const host = process.env.HOST || '127.0.0.1';

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(requestLogger);

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', req.header('origin') || '*');
  res.header('Access-Control-Allow-Credentials', 'true');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,PATCH,OPTIONS');

  if (req.method === 'OPTIONS') {
    res.sendStatus(204);
    return;
  }

  next();
});

app.get('/health', (_req, res) => {
  res.json({ success: true, service: 'datacenter-mgmt-backend' });
});

const routeCount = registerMockRoutes(app, loadMockRouteModules());

app.use((req, res) => {
  res.status(404).json({
    success: false,
    errorMessage: `Route not found: ${req.method} ${req.path}`,
  });
});

const server = app.listen(port, host, () => {
  console.log(`Backend API listening on http://${host}:${port}`);
  console.log(`Registered ${routeCount} API routes`);
});

server.on('error', (error: NodeJS.ErrnoException) => {
  if (error.code === 'EADDRINUSE') {
    console.error(`Backend API port is already in use: http://${host}:${port}`);
  } else {
    console.error(error);
  }
  process.exit(1);
});

let shuttingDown = false;

const shutdown = (signal: NodeJS.Signals) => {
  if (shuttingDown) return;
  shuttingDown = true;

  console.log(`Received ${signal}; closing backend API server...`);
  server.close((error) => {
    if (error) {
      console.error(error);
      process.exit(1);
      return;
    }
    process.exit(0);
  });

  setTimeout(() => {
    console.error('Timed out closing backend API server.');
    process.exit(1);
  }, 3000).unref();
};

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
process.on('SIGHUP', shutdown);
