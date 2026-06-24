import type { Request, Response } from 'express';

type LayoutStore = Record<string, IDC.DatacenterLayout>;

const store: LayoutStore = {};

function nowIso() {
  return new Date().toISOString();
}

function defaultFacilities(): IDC.DatacenterLayoutFacilityItem[] {
  return [
    { id: 'facility-camera-north', type: 'camera', name: '摄像头-北侧通道', x: 8, y: 4, height: 2.5, rotation: 45, pitch: -18 },
    { id: 'facility-camera-south', type: 'camera', name: '摄像头-南侧通道', x: 52, y: 36, height: 2.5, rotation: 225, pitch: -24 },
    {
      id: 'facility-extinguisher-west',
      type: 'fire_extinguisher',
      name: '灭火器-西侧立柱',
      x: 6,
      y: 20,
      rotation: 0,
    },
    {
      id: 'facility-extinguisher-east',
      type: 'fire_extinguisher',
      name: '灭火器-东侧立柱',
      x: 54,
      y: 20,
      rotation: 0,
    },
    { id: 'facility-access-main', type: 'door', name: '门禁-主入口', x: 30, y: 1.2, rotation: 0 },
    { id: 'facility-temp-sensor-a', type: 'sensor', name: '温湿度传感器-A区', x: 18, y: 16, rotation: 0 },
  ];
}

function defaultLayout(datacenterId: string): IDC.DatacenterLayout {
  return {
    datacenterId,
    version: 1,
    canvasWidth: 60,
    canvasHeight: 40,
    pxPerMeter: 50,
    cabinets: [],
    zones: [],
    facilities: defaultFacilities(),
    updatedAt: nowIso(),
  };
}

export default {
  'GET /api/idc/datacenters/:id/layout': (req: Request, res: Response) => {
    const { id } = req.params;
    res.json({
      success: true,
      data: store[id] ?? defaultLayout(id),
    });
  },

  'PUT /api/idc/datacenters/:id/layout': (req: Request, res: Response) => {
    const { id } = req.params;
    const body = req.body as Partial<IDC.DatacenterLayout>;
    const prev = store[id] ?? defaultLayout(id);
    const next: IDC.DatacenterLayout = {
      ...prev,
      datacenterId: id,
      version: (body.version ?? prev.version) + 1,
      canvasWidth: body.canvasWidth ?? prev.canvasWidth,
      canvasHeight: body.canvasHeight ?? prev.canvasHeight,
      pxPerMeter: body.pxPerMeter ?? prev.pxPerMeter,
      cabinets: body.cabinets ?? prev.cabinets,
      zones: body.zones ?? prev.zones,
      facilities: body.facilities ?? prev.facilities,
      updatedAt: nowIso(),
    };
    store[id] = next;
    res.json({ success: true, data: next });
  },
};
