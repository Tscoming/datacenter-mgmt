import express from 'express';
import { loadMockRouteModules } from './mockRoutes';
import { requestLogger } from './requestLogger';
import { registerMockRoutes } from './registerMockRoutes';

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

app.listen(port, host, () => {
  console.log(`Backend API listening on http://${host}:${port}`);
  console.log(`Registered ${routeCount} API routes`);
});
