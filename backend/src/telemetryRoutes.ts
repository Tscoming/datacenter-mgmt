import type { Request, Response } from 'express';
import { cabinetTelemetryService } from './telemetry/cabinetTelemetryService';

export default {
  'GET /api/idc/cabinets/:cabinetId/telemetry-source': async (req: Request, res: Response) => {
    try {
      const data = await cabinetTelemetryService.getSourceConfiguration(
        String(req.params.cabinetId),
      );
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({
        success: false,
        errorMessage: error instanceof Error ? error.message : String(error),
      });
    }
  },

  'PUT /api/idc/cabinets/:cabinetId/telemetry-source': async (req: Request, res: Response) => {
    try {
      const data = await cabinetTelemetryService.saveSourceConfiguration(
        String(req.params.cabinetId),
        req.body,
      );
      res.json({ success: true, data });
    } catch (error) {
      res.status(400).json({
        success: false,
        errorMessage: error instanceof Error ? error.message : String(error),
      });
    }
  },

  'POST /api/idc/cabinets/:cabinetId/telemetry-source/test': async (
    req: Request,
    res: Response,
  ) => {
    try {
      const data = await cabinetTelemetryService.testSourceConfiguration(
        String(req.params.cabinetId),
        req.body,
      );
      res.json({ success: true, data });
    } catch (error) {
      res.status(400).json({
        success: false,
        errorMessage: error instanceof Error ? error.message : String(error),
      });
    }
  },

  'DELETE /api/idc/cabinets/:cabinetId/telemetry-source': async (
    req: Request,
    res: Response,
  ) => {
    try {
      const deleted = await cabinetTelemetryService.deleteSourceConfiguration(
        String(req.params.cabinetId),
      );
      res.json({ success: true, data: { deleted } });
    } catch (error) {
      res.status(500).json({
        success: false,
        errorMessage: error instanceof Error ? error.message : String(error),
      });
    }
  },

  'GET /api/idc/telemetry/sources': (req: Request, res: Response) => {
    const datacenterId = req.query.datacenterId ? String(req.query.datacenterId) : undefined;
    res.json({
      success: true,
      data: cabinetTelemetryService.getStates(datacenterId),
      configurationError: cabinetTelemetryService.getConfigurationError(),
    });
  },

  'GET /api/idc/telemetry/cabinets/:cabinetId': (req: Request, res: Response) => {
    const state = cabinetTelemetryService.getStateByCabinetId(String(req.params.cabinetId));
    if (!state) {
      res.status(404).json({
        success: false,
        errorMessage: `No telemetry source is configured for cabinet ${req.params.cabinetId}`,
      });
      return;
    }
    res.json({ success: true, data: state });
  },

  'GET /api/idc/telemetry/cabinets/:cabinetId/high-frequency-stream': (
    req: Request,
    res: Response,
  ) => {
    cabinetTelemetryService.subscribeHighFrequency(
      req,
      res,
      String(req.params.cabinetId),
    );
  },

  'DELETE /api/idc/telemetry/cabinets/:cabinetId/high-frequency-subscriptions/:subscriptionId': (
    req: Request,
    res: Response,
  ) => {
    const released = cabinetTelemetryService.releaseHighFrequency(
      String(req.params.cabinetId),
      String(req.params.subscriptionId),
    );
    if (!released) {
      res.status(404).json({
        success: false,
        errorMessage: `No telemetry source is configured for cabinet ${req.params.cabinetId}`,
      });
      return;
    }
    res.status(204).end();
  },

  'POST /api/idc/telemetry/cabinets/:cabinetId/high-frequency-subscriptions/:subscriptionId/release': (
    req: Request,
    res: Response,
  ) => {
    const released = cabinetTelemetryService.releaseHighFrequency(
      String(req.params.cabinetId),
      String(req.params.subscriptionId),
    );
    if (!released) {
      res.status(404).json({
        success: false,
        errorMessage: `No telemetry source is configured for cabinet ${req.params.cabinetId}`,
      });
      return;
    }
    res.status(204).end();
  },

  'GET /api/idc/telemetry/stream': (req: Request, res: Response) => {
    cabinetTelemetryService.subscribe(req, res);
  },
};
