import type { Express, Request, Response } from 'express';
import { logRequestStep } from './requestLogger';

type MockHandler = unknown;
type MockRouteModule = Record<string, MockHandler>;

const METHODS = new Set(['GET', 'POST', 'PUT', 'DELETE', 'PATCH']);

const parseRouteKey = (key: string) => {
  const normalized = key.trim().replace(/\s+/, ' ');
  const [maybeMethod, ...pathParts] = normalized.split(' ');

  if (METHODS.has(maybeMethod.toUpperCase()) && pathParts.length > 0) {
    return {
      method: maybeMethod.toLowerCase() as 'get' | 'post' | 'put' | 'delete' | 'patch',
      path: pathParts.join(' '),
    };
  }

  return {
    method: 'get' as const,
    path: normalized,
  };
};

const sendStaticValue = (value: MockHandler, req: Request, res: Response) => {
  if (Array.isArray(value)) {
    logRequestStep(req, 'return', `static array length=${value.length}`);
    res.json(value);
    return;
  }

  if (value && typeof value === 'object') {
    logRequestStep(req, 'return', 'static object');
    res.json(value);
    return;
  }

  logRequestStep(req, 'return', `static ${typeof value}`);
  res.send(value);
};

export const registerMockRoutes = (app: Express, modules: MockRouteModule[]) => {
  const routes = modules.flatMap((routeModule) =>
    Object.entries(routeModule).map(([key, handler]) => ({
      ...parseRouteKey(key),
      handler,
    })),
  );

  routes
    .sort((left, right) => {
      const leftSegments = left.path.split('/').filter(Boolean);
      const rightSegments = right.path.split('/').filter(Boolean);
      const leftParams = leftSegments.filter((segment) => segment.startsWith(':')).length;
      const rightParams = rightSegments.filter((segment) => segment.startsWith(':')).length;

      if (leftParams !== rightParams) return leftParams - rightParams;
      return rightSegments.length - leftSegments.length;
    })
    .forEach(({ method, path, handler }) => {
      app[method](path, (req: Request, res: Response) => {
        logRequestStep(req, 'route', `${method.toUpperCase()} ${path}`);

        if (typeof handler === 'function') {
          logRequestStep(req, 'handler', 'function start');
          return (handler as (req: Request, res: Response) => unknown)(req, res);
        }

        logRequestStep(req, 'handler', 'static value');
        sendStaticValue(handler, req, res);
      });
    });

  return routes.length;
};
