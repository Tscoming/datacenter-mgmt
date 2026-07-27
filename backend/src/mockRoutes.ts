import { getApiDataSource } from './db';

const mockModulePaths = [
  '../mock/user',
  '../mock/notices',
  '../mock/listTableList',
  '../mock/route',
  '../mock/monitor.mock',
  '../mock/datacenter.mock',
  '../mock/cabinet.mock',
  '../mock/device.mock',
  '../mock/deviceTemplate.mock',
  '../mock/port.mock',
  '../mock/connection.mock',
  '../mock/dashboard.mock',
  '../mock/environment.mock',
  '../mock/layout.mock',
  '../mock/pdu.mock',
  '../mock/powerTopology.mock',
  '../mock/alert.mock',
];

export const loadMockRouteModules = () => {
  const dataSourceModulePaths =
    getApiDataSource() === 'database'
      ? [
          './databaseAuthRoutes',
          './databaseDashboardRoutes',
          './databaseEnvironmentRoutes',
          './database3dRoutes',
          './databaseAlertRoutes',
          './databaseUserRoutes',
          './databaseKeyManagementRoutes',
          './databaseDeviceSshRoutes',
        ]
      : mockModulePaths;
  const modulePaths = [...dataSourceModulePaths, './telemetryRoutes'];

  return modulePaths.map((modulePath) => {
    const routeModule = require(modulePath);
    return routeModule.default || routeModule;
  });
};
