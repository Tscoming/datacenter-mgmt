import type { NextFunction, Request, Response } from 'express';

let nextRequestId = 1;

const summarize = (value: unknown) => {
  if (value === undefined || value === null) return '';

  const text = JSON.stringify(value);
  if (!text || text === '{}' || text === '[]') return '';
  return text.length > 500 ? `${text.slice(0, 500)}...` : text;
};

const getRequestId = (req: Request) => {
  const request = req as Request & { requestId?: string };
  if (!request.requestId) {
    request.requestId = String(nextRequestId++).padStart(6, '0');
  }

  return request.requestId;
};

export const logRequestStep = (req: Request, step: string, details?: string) => {
  const requestId = getRequestId(req);
  const suffix = details ? ` ${details}` : '';
  console.log(`[api:${requestId}] ${step}${suffix}`);
};

export const requestLogger = (req: Request, res: Response, next: NextFunction) => {
  const startedAt = Date.now();
  const query = summarize(req.query);
  const body = summarize(req.body);

  logRequestStep(
    req,
    'start',
    `${req.method} ${req.originalUrl}${query ? ` query=${query}` : ''}${body ? ` body=${body}` : ''}`,
  );

  res.on('finish', () => {
    const duration = Date.now() - startedAt;
    logRequestStep(req, 'end', `${req.method} ${req.originalUrl} status=${res.statusCode} duration=${duration}ms`);
  });

  next();
};
