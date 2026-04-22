import { PageContainer } from '@ant-design/pro-components';
import { history } from '@umijs/max';
import {
  Alert,
  Button,
  Card,
  Divider,
  Form,
  Input,
  InputNumber,
  message,
  Segmented,
  Select,
  Space,
  Typography,
} from 'antd';
import {
  AirVent,
  Camera,
  DoorClosed,
  FlameKindling,
  Package,
  Ruler,
  Save,
  ScanEye,
  Square,
  Thermometer,
  Undo2,
  ZoomIn,
  ZoomOut,
} from 'lucide-react';
import React, {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import { getCabinetsByDatacenter } from '@/services/idc/cabinet';
import { getAllDatacenters } from '@/services/idc/datacenter';
import {
  getDatacenterLayout,
  saveDatacenterLayout,
} from '@/services/idc/layout';
import styles from './index.less';

type ToolMode =
  | 'select'
  | 'zone'
  | 'hot_aisle'
  | 'cold_aisle'
  | IDC.LayoutFacilityType;

type Selected =
  | { type: 'cabinet'; cabinetId: string }
  | { type: 'zone'; id: string }
  | { type: 'facility'; id: string }
  | null;

function clamp(n: number, min: number, max: number) {
  return Math.max(min, Math.min(max, n));
}

function snap(n: number, step: number) {
  return Math.round(n / step) * step;
}

function uid(prefix: string) {
  return `${prefix}_${Math.random().toString(36).slice(2)}_${Date.now()}`;
}

function facilityIcon(type: IDC.LayoutFacilityType) {
  const size = 18;
  switch (type) {
    case 'ups':
      return <Package size={size} />;
    case 'crac':
      return <AirVent size={size} />;
    case 'sensor':
      return <Thermometer size={size} />;
    case 'door':
      return <DoorClosed size={size} />;
    case 'camera':
      return <Camera size={size} />;
    case 'fire_extinguisher':
      return <FlameKindling size={size} />;
    case 'pdu':
      return <ScanEye size={size} />;
    default:
      return <Square size={size} />;
  }
}

const ZONE_COLORS: Record<IDC.LayoutZoneType, string> = {
  zone: 'rgba(82, 196, 26, 0.12)',
  hot_aisle: 'rgba(245, 34, 45, 0.10)',
  cold_aisle: 'rgba(22, 119, 255, 0.10)',
  restricted: 'rgba(250, 173, 20, 0.10)',
  other: 'rgba(0, 0, 0, 0.06)',
};

function zoneLabel(type: IDC.LayoutZoneType) {
  switch (type) {
    case 'hot_aisle':
      return '热通道';
    case 'cold_aisle':
      return '冷通道';
    case 'restricted':
      return '限制区';
    case 'zone':
      return '区域';
    default:
      return '其他';
  }
}

const DatacenterLayoutPage: React.FC = () => {
  const [datacenters, setDatacenters] = useState<IDC.Datacenter[]>([]);
  const [selectedDc, setSelectedDc] = useState<string>();
  const [cabinets, setCabinets] = useState<IDC.Cabinet[]>([]);
  const [layout, setLayout] = useState<IDC.DatacenterLayout | null>(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  const [tool, setTool] = useState<ToolMode>('select');
  const [selected, setSelected] = useState<Selected>(null);

  const [scale, setScale] = useState(1);
  const [offset, setOffset] = useState({ x: 20, y: 20 });

  const wrapRef = useRef<HTMLDivElement | null>(null);
  const dragRef = useRef<{
    kind: 'pan' | 'cabinet' | 'zone' | 'facility' | 'draw_zone';
    id?: string;
    cabinetId?: string;
    startClientX: number;
    startClientY: number;
    startOffsetX: number;
    startOffsetY: number;
    startX?: number;
    startY?: number;
    startW?: number;
    startH?: number;
    zoneType?: IDC.LayoutZoneType;
  } | null>(null);

  const pxPerMeter = layout?.pxPerMeter || 50;
  const cabinetW = 0.6;
  const cabinetD = 1.0;
  const gridStep = 0.1;

  useEffect(() => {
    getAllDatacenters().then((res) => {
      if (res.success && res.data) {
        setDatacenters(res.data);
        const id = (res.data as any)?.[0]?.id as string | undefined;
        if (id) setSelectedDc(id);
      }
    });
  }, []);

  const load = useCallback(async (dcId: string) => {
    setLoading(true);
    try {
      const [cabRes, layoutRes] = await Promise.all([
        getCabinetsByDatacenter(dcId),
        getDatacenterLayout(dcId),
      ]);
      if (cabRes.success && cabRes.data) setCabinets(cabRes.data);
      if (layoutRes.success && layoutRes.data) {
        setLayout(layoutRes.data);
      } else {
        setLayout(null);
      }
      setSelected(null);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (selectedDc) load(selectedDc);
  }, [selectedDc, load]);

  const cabinetMap = useMemo(() => {
    const map = new Map<string, IDC.Cabinet>();
    cabinets.forEach((c) => map.set(c.id, c));
    return map;
  }, [cabinets]);

  const cabinetItems = useMemo(() => {
    const items = layout?.cabinets || [];
    const known = new Set(items.map((i) => i.cabinetId));
    const missing = cabinets.filter((c) => !known.has(c.id));
    if (!missing.length) return items;
    return [
      ...items,
      ...missing.map((c) => {
        const row = (c as any).row as number | undefined;
        const column = (c as any).column as number | undefined;
        const x = typeof column === 'number' ? column * 1.2 : 0;
        const y = typeof row === 'number' ? row * 1.4 : 0;
        return { cabinetId: c.id, x, y, rotation: 0 };
      }),
    ];
  }, [layout?.cabinets, cabinets]);

  const zones = layout?.zones || [];
  const facilities = layout?.facilities || [];

  const viewportStyle = useMemo(() => {
    return {
      transform: `translate(${offset.x}px, ${offset.y}px) scale(${scale})`,
      width: layout ? `${layout.canvasWidth * pxPerMeter}px` : '2000px',
      height: layout ? `${layout.canvasHeight * pxPerMeter}px` : '1400px',
      position: 'relative' as const,
    };
  }, [offset.x, offset.y, scale, layout, pxPerMeter]);

  const toWorld = useCallback(
    (clientX: number, clientY: number) => {
      const wrap = wrapRef.current;
      if (!wrap) return { x: 0, y: 0 };
      const rect = wrap.getBoundingClientRect();
      const x = (clientX - rect.left - offset.x) / scale / pxPerMeter;
      const y = (clientY - rect.top - offset.y) / scale / pxPerMeter;
      return { x, y };
    },
    [offset.x, offset.y, scale, pxPerMeter],
  );

  const setCabinetItem = useCallback(
    (cabinetId: string, next: Partial<IDC.DatacenterLayoutCabinetItem>) => {
      setLayout((prev) => {
        if (!prev) return prev;
        const cabinetsNext = cabinetItems.map((i) =>
          i.cabinetId === cabinetId ? { ...i, ...next } : i,
        );
        return { ...prev, cabinets: cabinetsNext };
      });
    },
    [cabinetItems],
  );

  const setZoneItem = useCallback(
    (id: string, next: Partial<IDC.DatacenterLayoutZoneItem>) => {
      setLayout((prev) => {
        if (!prev) return prev;
        const zonesNext = prev.zones.map((z) =>
          z.id === id ? { ...z, ...next } : z,
        );
        return { ...prev, zones: zonesNext };
      });
    },
    [],
  );

  const setFacilityItem = useCallback(
    (id: string, next: Partial<IDC.DatacenterLayoutFacilityItem>) => {
      setLayout((prev) => {
        if (!prev) return prev;
        const facilitiesNext = prev.facilities.map((f) =>
          f.id === id ? { ...f, ...next } : f,
        );
        return { ...prev, facilities: facilitiesNext };
      });
    },
    [],
  );

  const ensureLayout = useCallback(() => {
    setLayout((prev) => {
      if (prev && prev.datacenterId) return prev;
      if (!selectedDc) return prev;
      const base: IDC.DatacenterLayout = {
        datacenterId: selectedDc,
        version: 1,
        canvasWidth: 60,
        canvasHeight: 40,
        pxPerMeter: 50,
        cabinets: [],
        zones: [],
        facilities: [],
        updatedAt: new Date().toISOString(),
      };
      return base;
    });
  }, [selectedDc]);

  useEffect(() => {
    if (!layout && selectedDc) ensureLayout();
  }, [layout, selectedDc, ensureLayout]);

  const onPointerDownWrap = useCallback(
    (e: React.PointerEvent) => {
      if (e.button !== 0) return;
      const target = e.target as HTMLElement;
      const isCanvas = target.dataset?.role === 'canvas';

      if (tool !== 'select' && isCanvas) {
        const zoneType: IDC.LayoutZoneType =
          tool === 'zone' || tool === 'hot_aisle' || tool === 'cold_aisle'
            ? (tool as IDC.LayoutZoneType)
            : 'zone';

        if (tool === 'zone' || tool === 'hot_aisle' || tool === 'cold_aisle') {
          const pos = toWorld(e.clientX, e.clientY);
          const id = uid('zone');
          setSelected({ type: 'zone', id });
          setLayout((prev) => {
            if (!prev) return prev;
            const z: IDC.DatacenterLayoutZoneItem = {
              id,
              type: zoneType,
              name: zoneLabel(zoneType),
              x: snap(pos.x, gridStep),
              y: snap(pos.y, gridStep),
              width: gridStep,
              height: gridStep,
              rotation: 0,
              color: ZONE_COLORS[zoneType],
            };
            return { ...prev, zones: [...prev.zones, z] };
          });
          dragRef.current = {
            kind: 'draw_zone',
            id,
            startClientX: e.clientX,
            startClientY: e.clientY,
            startOffsetX: offset.x,
            startOffsetY: offset.y,
            startX: pos.x,
            startY: pos.y,
            zoneType,
          };
          (e.currentTarget as HTMLDivElement).setPointerCapture(e.pointerId);
          return;
        }

        const pos = toWorld(e.clientX, e.clientY);
        const id = uid('facility');
        setSelected({ type: 'facility', id });
        setLayout((prev) => {
          if (!prev) return prev;
          const f: IDC.DatacenterLayoutFacilityItem = {
            id,
            type: tool as IDC.LayoutFacilityType,
            name: tool,
            x: snap(pos.x, gridStep),
            y: snap(pos.y, gridStep),
            rotation: 0,
          };
          return { ...prev, facilities: [...prev.facilities, f] };
        });
        setTool('select');
        return;
      }

      if (tool === 'select' && isCanvas) {
        setSelected(null);
        dragRef.current = {
          kind: 'pan',
          startClientX: e.clientX,
          startClientY: e.clientY,
          startOffsetX: offset.x,
          startOffsetY: offset.y,
        };
        (e.currentTarget as HTMLDivElement).setPointerCapture(e.pointerId);
      }
    },
    [tool, toWorld, offset.x, offset.y, gridStep, ensureLayout],
  );

  const onPointerMoveWrap = useCallback(
    (e: React.PointerEvent) => {
      const drag = dragRef.current;
      if (!drag) return;

      if (drag.kind === 'pan') {
        const dx = e.clientX - drag.startClientX;
        const dy = e.clientY - drag.startClientY;
        setOffset({ x: drag.startOffsetX + dx, y: drag.startOffsetY + dy });
        return;
      }

      if (drag.kind === 'cabinet' && drag.cabinetId) {
        const dx = (e.clientX - drag.startClientX) / scale / pxPerMeter;
        const dy = (e.clientY - drag.startClientY) / scale / pxPerMeter;
        const nextX = snap((drag.startX || 0) + dx, gridStep);
        const nextY = snap((drag.startY || 0) + dy, gridStep);
        setCabinetItem(drag.cabinetId, { x: nextX, y: nextY });
        return;
      }

      if (drag.kind === 'facility' && drag.id) {
        const dx = (e.clientX - drag.startClientX) / scale / pxPerMeter;
        const dy = (e.clientY - drag.startClientY) / scale / pxPerMeter;
        const nextX = snap((drag.startX || 0) + dx, gridStep);
        const nextY = snap((drag.startY || 0) + dy, gridStep);
        setFacilityItem(drag.id, { x: nextX, y: nextY });
        return;
      }

      if (drag.kind === 'zone' && drag.id) {
        const dx = (e.clientX - drag.startClientX) / scale / pxPerMeter;
        const dy = (e.clientY - drag.startClientY) / scale / pxPerMeter;
        const nextX = snap((drag.startX || 0) + dx, gridStep);
        const nextY = snap((drag.startY || 0) + dy, gridStep);
        setZoneItem(drag.id, { x: nextX, y: nextY });
        return;
      }

      if (drag.kind === 'draw_zone' && drag.id) {
        const start = { x: drag.startX || 0, y: drag.startY || 0 };
        const cur = toWorld(e.clientX, e.clientY);
        const x = snap(Math.min(start.x, cur.x), gridStep);
        const y = snap(Math.min(start.y, cur.y), gridStep);
        const width = snap(Math.abs(cur.x - start.x), gridStep);
        const height = snap(Math.abs(cur.y - start.y), gridStep);
        setZoneItem(drag.id, {
          x,
          y,
          width: Math.max(gridStep, width),
          height: Math.max(gridStep, height),
        });
      }
    },
    [
      scale,
      pxPerMeter,
      gridStep,
      toWorld,
      setCabinetItem,
      setZoneItem,
      setFacilityItem,
    ],
  );

  const onPointerUpWrap = useCallback((e: React.PointerEvent) => {
    if (dragRef.current) {
      dragRef.current = null;
      try {
        (e.currentTarget as HTMLDivElement).releasePointerCapture(e.pointerId);
      } catch {}
    }
  }, []);

  const onWheel = useCallback(
    (e: React.WheelEvent) => {
      e.preventDefault();
      const next = clamp(scale + (e.deltaY > 0 ? -0.08 : 0.08), 0.3, 3);
      setScale(next);
    },
    [scale],
  );

  const selectedCabinetItem = useMemo(() => {
    if (!selected || selected.type !== 'cabinet') return null;
    return cabinetItems.find((i) => i.cabinetId === selected.cabinetId) || null;
  }, [selected, cabinetItems]);

  const selectedZone = useMemo(() => {
    if (!selected || selected.type !== 'zone') return null;
    return zones.find((z) => z.id === selected.id) || null;
  }, [selected, zones]);

  const selectedFacility = useMemo(() => {
    if (!selected || selected.type !== 'facility') return null;
    return facilities.find((f) => f.id === selected.id) || null;
  }, [selected, facilities]);

  const autoLayout = useCallback(() => {
    if (!layout) return;
    const placed = new Set(layout.cabinets.map((c) => c.cabinetId));
    const next = [...layout.cabinets];
    const cols = Math.max(1, Math.ceil(Math.sqrt(cabinets.length)));
    let idx = 0;
    cabinets.forEach((c) => {
      if (placed.has(c.id)) return;
      const x = (idx % cols) * (cabinetW + 0.8);
      const y = Math.floor(idx / cols) * (cabinetD + 0.9);
      next.push({ cabinetId: c.id, x, y, rotation: 0 });
      idx += 1;
    });
    setLayout({ ...layout, cabinets: next });
    message.success('已生成默认布局');
  }, [layout, cabinets]);

  const save = useCallback(async () => {
    if (!selectedDc || !layout) return;
    setSaving(true);
    try {
      const res = await saveDatacenterLayout(selectedDc, {
        version: layout.version,
        canvasWidth: layout.canvasWidth,
        canvasHeight: layout.canvasHeight,
        pxPerMeter: layout.pxPerMeter,
        cabinets: cabinetItems,
        zones: layout.zones,
        facilities: layout.facilities,
      });
      if (res.success && res.data) {
        setLayout(res.data);
        message.success('保存成功');
      } else {
        message.error('保存失败');
      }
    } finally {
      setSaving(false);
    }
  }, [selectedDc, layout, cabinetItems]);

  const go3D = useCallback(() => {
    if (!selectedDc) return;
    history.push(`/datacenter3d?id=${selectedDc}`);
  }, [selectedDc]);

  const toolOptions = useMemo(() => {
    return [
      { label: '选择', value: 'select', icon: <ScanEye size={16} /> },
      { label: '区域', value: 'zone', icon: <Square size={16} /> },
      { label: '热通道', value: 'hot_aisle', icon: <Thermometer size={16} /> },
      { label: '冷通道', value: 'cold_aisle', icon: <Ruler size={16} /> },
      { label: 'UPS', value: 'ups', icon: <Package size={16} /> },
      { label: '空调', value: 'crac', icon: <AirVent size={16} /> },
      { label: '传感器', value: 'sensor', icon: <Thermometer size={16} /> },
      { label: '门禁', value: 'door', icon: <DoorClosed size={16} /> },
      { label: '摄像头', value: 'camera', icon: <Camera size={16} /> },
      {
        label: '灭火器',
        value: 'fire_extinguisher',
        icon: <FlameKindling size={16} />,
      },
    ];
  }, []);

  const onRotateSelected = useCallback(
    (delta: number) => {
      if (!selected) return;
      if (selected.type === 'cabinet') {
        const cur = selectedCabinetItem?.rotation || 0;
        setCabinetItem(selected.cabinetId, { rotation: cur + delta });
      }
      if (selected.type === 'zone') {
        const cur = selectedZone?.rotation || 0;
        setZoneItem(selected.id, { rotation: cur + delta });
      }
      if (selected.type === 'facility') {
        const cur = selectedFacility?.rotation || 0;
        setFacilityItem(selected.id, { rotation: cur + delta });
      }
    },
    [
      selected,
      selectedCabinetItem,
      selectedZone,
      selectedFacility,
      setCabinetItem,
      setZoneItem,
      setFacilityItem,
    ],
  );

  const onDeleteSelected = useCallback(() => {
    if (!selected || !layout) return;
    if (selected.type === 'zone') {
      setLayout({
        ...layout,
        zones: layout.zones.filter((z) => z.id !== selected.id),
      });
      setSelected(null);
      return;
    }
    if (selected.type === 'facility') {
      setLayout({
        ...layout,
        facilities: layout.facilities.filter((f) => f.id !== selected.id),
      });
      setSelected(null);
      return;
    }
    message.info('机柜不支持删除（请在机柜管理中删除）');
  }, [selected, layout]);

  const infoText = useMemo(() => {
    if (!layout) return '';
    return `画布：${layout.canvasWidth}m × ${layout.canvasHeight}m，比例：${layout.pxPerMeter}px/m`;
  }, [layout]);

  return (
    <PageContainer
      header={{
        title: '机房布局编辑器',
        subTitle: infoText,
      }}
    >
      <div className={styles.layoutPage}>
        <div className={styles.sidebar}>
          <Card>
            <Space direction="vertical" style={{ width: '100%' }}>
              <Typography.Text type="secondary">数据中心</Typography.Text>
              <Select
                value={selectedDc}
                onChange={(v) => setSelectedDc(v)}
                options={datacenters.map((d) => ({
                  value: d.id,
                  label: d.name,
                }))}
                loading={loading}
                style={{ width: '100%' }}
              />
              <Space wrap>
                <Button
                  icon={<Save size={16} />}
                  type="primary"
                  onClick={save}
                  loading={saving}
                >
                  保存
                </Button>
                <Button onClick={() => selectedDc && load(selectedDc)}>
                  刷新
                </Button>
                <Button onClick={go3D}>打开3D</Button>
              </Space>
            </Space>
          </Card>

          <Card>
            <Space direction="vertical" style={{ width: '100%' }}>
              <Typography.Text type="secondary">工具</Typography.Text>
              <Segmented
                value={tool}
                onChange={(v) => setTool(v as ToolMode)}
                options={toolOptions as any}
              />
              <Alert
                type="info"
                showIcon
                message={
                  tool === 'select'
                    ? '拖拽物体移动，拖拽空白区域平移，滚轮缩放'
                    : '在画布空白处点击/拖拽创建或放置'
                }
              />
              <Space wrap>
                <Button
                  icon={<ZoomIn size={16} />}
                  onClick={() => setScale((s) => clamp(s + 0.1, 0.3, 3))}
                />
                <Button
                  icon={<ZoomOut size={16} />}
                  onClick={() => setScale((s) => clamp(s - 0.1, 0.3, 3))}
                />
                <Button
                  icon={<Undo2 size={16} />}
                  onClick={() => {
                    setScale(1);
                    setOffset({ x: 20, y: 20 });
                  }}
                />
              </Space>
              <Divider style={{ margin: '12px 0' }} />
              <Space wrap>
                <Button onClick={autoLayout}>生成默认布局</Button>
                <Button danger onClick={onDeleteSelected} disabled={!selected}>
                  删除选中
                </Button>
              </Space>
              <Space wrap>
                <Button
                  onClick={() => onRotateSelected(-90)}
                  disabled={!selected}
                >
                  左转90°
                </Button>
                <Button
                  onClick={() => onRotateSelected(90)}
                  disabled={!selected}
                >
                  右转90°
                </Button>
              </Space>
            </Space>
          </Card>

          <Card>
            <Typography.Text type="secondary">属性</Typography.Text>
            <Divider style={{ margin: '12px 0' }} />
            {!selected ? (
              <Typography.Text type="secondary">未选择对象</Typography.Text>
            ) : selected.type === 'cabinet' ? (
              <Form layout="vertical">
                <Form.Item label="机柜">
                  <Input
                    value={
                      cabinetMap.get(selected.cabinetId)?.name ||
                      selected.cabinetId
                    }
                    disabled
                  />
                </Form.Item>
                <Form.Item label="X(m)">
                  <InputNumber
                    value={selectedCabinetItem?.x || 0}
                    step={gridStep}
                    onChange={(v) =>
                      setCabinetItem(selected.cabinetId, {
                        x: snap(Number(v || 0), gridStep),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
                <Form.Item label="Y(m)">
                  <InputNumber
                    value={selectedCabinetItem?.y || 0}
                    step={gridStep}
                    onChange={(v) =>
                      setCabinetItem(selected.cabinetId, {
                        y: snap(Number(v || 0), gridStep),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
                <Form.Item label="旋转(°)">
                  <InputNumber
                    value={selectedCabinetItem?.rotation || 0}
                    step={90}
                    onChange={(v) =>
                      setCabinetItem(selected.cabinetId, {
                        rotation: Number(v || 0),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
              </Form>
            ) : selected.type === 'zone' ? (
              <Form layout="vertical">
                <Form.Item label="类型">
                  <Select
                    value={selectedZone?.type}
                    options={[
                      { value: 'zone', label: '区域' },
                      { value: 'hot_aisle', label: '热通道' },
                      { value: 'cold_aisle', label: '冷通道' },
                      { value: 'restricted', label: '限制区' },
                      { value: 'other', label: '其他' },
                    ]}
                    onChange={(v) =>
                      selectedZone &&
                      setZoneItem(selectedZone.id, { type: v as any })
                    }
                  />
                </Form.Item>
                <Form.Item label="名称">
                  <Input
                    value={selectedZone?.name}
                    onChange={(e) =>
                      selectedZone &&
                      setZoneItem(selectedZone.id, { name: e.target.value })
                    }
                  />
                </Form.Item>
                <Form.Item label="X(m)">
                  <InputNumber
                    value={selectedZone?.x || 0}
                    step={gridStep}
                    onChange={(v) =>
                      selectedZone &&
                      setZoneItem(selectedZone.id, {
                        x: snap(Number(v || 0), gridStep),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
                <Form.Item label="Y(m)">
                  <InputNumber
                    value={selectedZone?.y || 0}
                    step={gridStep}
                    onChange={(v) =>
                      selectedZone &&
                      setZoneItem(selectedZone.id, {
                        y: snap(Number(v || 0), gridStep),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
                <Form.Item label="宽(m)">
                  <InputNumber
                    value={selectedZone?.width || 0}
                    step={gridStep}
                    min={gridStep}
                    onChange={(v) =>
                      selectedZone &&
                      setZoneItem(selectedZone.id, {
                        width: Math.max(gridStep, Number(v || 0)),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
                <Form.Item label="高(m)">
                  <InputNumber
                    value={selectedZone?.height || 0}
                    step={gridStep}
                    min={gridStep}
                    onChange={(v) =>
                      selectedZone &&
                      setZoneItem(selectedZone.id, {
                        height: Math.max(gridStep, Number(v || 0)),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
                <Form.Item label="旋转(°)">
                  <InputNumber
                    value={selectedZone?.rotation || 0}
                    step={90}
                    onChange={(v) =>
                      selectedZone &&
                      setZoneItem(selectedZone.id, { rotation: Number(v || 0) })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
              </Form>
            ) : (
              <Form layout="vertical">
                <Form.Item label="类型">
                  <Input value={selectedFacility?.type} disabled />
                </Form.Item>
                <Form.Item label="名称">
                  <Input
                    value={selectedFacility?.name}
                    onChange={(e) =>
                      selectedFacility &&
                      setFacilityItem(selectedFacility.id, {
                        name: e.target.value,
                      })
                    }
                  />
                </Form.Item>
                <Form.Item label="X(m)">
                  <InputNumber
                    value={selectedFacility?.x || 0}
                    step={gridStep}
                    onChange={(v) =>
                      selectedFacility &&
                      setFacilityItem(selectedFacility.id, {
                        x: snap(Number(v || 0), gridStep),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
                <Form.Item label="Y(m)">
                  <InputNumber
                    value={selectedFacility?.y || 0}
                    step={gridStep}
                    onChange={(v) =>
                      selectedFacility &&
                      setFacilityItem(selectedFacility.id, {
                        y: snap(Number(v || 0), gridStep),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
                <Form.Item label="旋转(°)">
                  <InputNumber
                    value={selectedFacility?.rotation || 0}
                    step={90}
                    onChange={(v) =>
                      selectedFacility &&
                      setFacilityItem(selectedFacility.id, {
                        rotation: Number(v || 0),
                      })
                    }
                    style={{ width: '100%' }}
                  />
                </Form.Item>
              </Form>
            )}
          </Card>
        </div>

        <Card
          className={styles.canvasCard}
          loading={loading}
          bodyStyle={{ height: '100%' }}
        >
          <div
            className={styles.canvasWrap}
            ref={wrapRef}
            onPointerDown={onPointerDownWrap}
            onPointerMove={onPointerMoveWrap}
            onPointerUp={onPointerUpWrap}
            onWheel={onWheel}
          >
            <div
              className={styles.viewport}
              style={viewportStyle}
              data-role="canvas"
            >
              {zones.map((z) => {
                const left = z.x * pxPerMeter;
                const top = z.y * pxPerMeter;
                const width = z.width * pxPerMeter;
                const height = z.height * pxPerMeter;
                const isSelected =
                  selected?.type === 'zone' && selected.id === z.id;
                return (
                  <div
                    key={z.id}
                    className={`${styles.zone} ${isSelected ? styles.zoneSelected : ''}`}
                    style={{
                      left,
                      top,
                      width,
                      height,
                      background: z.color || ZONE_COLORS[z.type],
                      transform: `rotate(${z.rotation || 0}deg)`,
                      transformOrigin: 'center',
                    }}
                    onPointerDown={(e) => {
                      e.stopPropagation();
                      setSelected({ type: 'zone', id: z.id });
                      dragRef.current = {
                        kind: 'zone',
                        id: z.id,
                        startClientX: e.clientX,
                        startClientY: e.clientY,
                        startOffsetX: offset.x,
                        startOffsetY: offset.y,
                        startX: z.x,
                        startY: z.y,
                      };
                      (wrapRef.current as HTMLDivElement).setPointerCapture(
                        e.pointerId,
                      );
                    }}
                  >
                    <div
                      style={{
                        padding: 8,
                        fontSize: 12,
                        color: 'rgba(0,0,0,0.75)',
                      }}
                    >
                      {z.name || zoneLabel(z.type)}
                    </div>
                  </div>
                );
              })}

              {cabinetItems.map((ci) => {
                const c = cabinetMap.get(ci.cabinetId);
                const name = c?.code || c?.name || ci.cabinetId;
                const left = ci.x * pxPerMeter;
                const top = ci.y * pxPerMeter;
                const w = cabinetW * pxPerMeter;
                const h = cabinetD * pxPerMeter;
                const isSelected =
                  selected?.type === 'cabinet' &&
                  selected.cabinetId === ci.cabinetId;
                return (
                  <div
                    key={ci.cabinetId}
                    className={`${styles.cabinet} ${
                      isSelected ? styles.cabinetSelected : ''
                    }`}
                    style={{
                      left,
                      top,
                      width: w,
                      height: h,
                      transform: `rotate(${ci.rotation || 0}deg)`,
                      transformOrigin: 'center',
                    }}
                    onPointerDown={(e) => {
                      e.stopPropagation();
                      setSelected({ type: 'cabinet', cabinetId: ci.cabinetId });
                      dragRef.current = {
                        kind: 'cabinet',
                        cabinetId: ci.cabinetId,
                        startClientX: e.clientX,
                        startClientY: e.clientY,
                        startOffsetX: offset.x,
                        startOffsetY: offset.y,
                        startX: ci.x,
                        startY: ci.y,
                      };
                      (wrapRef.current as HTMLDivElement).setPointerCapture(
                        e.pointerId,
                      );
                    }}
                  >
                    {name}
                  </div>
                );
              })}

              {facilities.map((f) => {
                const left = f.x * pxPerMeter - 17;
                const top = f.y * pxPerMeter - 17;
                const isSelected =
                  selected?.type === 'facility' && selected.id === f.id;
                return (
                  <div
                    key={f.id}
                    className={`${styles.facility} ${
                      isSelected ? styles.facilitySelected : ''
                    }`}
                    style={{
                      left,
                      top,
                      transform: `rotate(${f.rotation || 0}deg)`,
                      transformOrigin: 'center',
                    }}
                    onPointerDown={(e) => {
                      e.stopPropagation();
                      setSelected({ type: 'facility', id: f.id });
                      dragRef.current = {
                        kind: 'facility',
                        id: f.id,
                        startClientX: e.clientX,
                        startClientY: e.clientY,
                        startOffsetX: offset.x,
                        startOffsetY: offset.y,
                        startX: f.x,
                        startY: f.y,
                      };
                      (wrapRef.current as HTMLDivElement).setPointerCapture(
                        e.pointerId,
                      );
                    }}
                  >
                    {facilityIcon(f.type)}
                  </div>
                );
              })}
            </div>
          </div>
        </Card>
      </div>
    </PageContainer>
  );
};

export default DatacenterLayoutPage;
