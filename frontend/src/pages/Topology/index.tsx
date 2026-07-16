import { PageContainer } from '@ant-design/pro-components';
import { Graph } from '@antv/g6';
import {
  Alert,
  Badge,
  Button,
  Card,
  Descriptions,
  Empty,
  Select,
  Space,
  Spin,
  Statistic,
  Tooltip,
  theme,
} from 'antd';
import { Focus, Maximize2, Minimize2, ZoomIn, ZoomOut } from 'lucide-react';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { getTopology } from '@/services/idc/dashboard';
import { getAllDatacenters } from '@/services/idc/datacenter';
import styles from './index.less';
import {
  connectionColors,
  getHighContrastTypeColors,
  getThemedNodeStyle,
  normalizeTopologyNodeType,
} from './nodes';

interface TopologyNode {
  [key: string]: unknown;
  id: string;
  label: string;
  type: string;
  status: string;
}

interface TopologyEdge {
  [key: string]: unknown;
  source: string;
  target: string;
  type: string;
}

interface SelectedTopologyEdge extends TopologyEdge {
  id: string;
}

const GRAPH_HEIGHT = 640;

const typeLabels: Record<string, string> = {
  'core-switch': '核心交换机',
  'aggregation-switch': '汇聚交换机',
  'access-switch': '接入交换机',
  switch: '接入交换机',
  router: '路由器',
  server: '服务器',
  storage: '存储',
  firewall: '防火墙',
  loadbalancer: '负载均衡',
  virtual: '虚拟机 / Pod',
  vm: '虚拟机 / Pod',
  pod: '虚拟机 / Pod',
  other: '其他',
};

const legendNodeTypes = [
  'core-switch',
  'aggregation-switch',
  'access-switch',
  'router',
  'firewall',
  'loadbalancer',
  'server',
  'storage',
  'virtual',
];

const statusLabels: Record<string, string> = {
  online: '在线',
  warning: '告警',
  offline: '离线',
};

const connectionLabels: Record<string, string> = {
  network: '网络',
  storage: '存储',
  management: '管理',
  stack: '堆叠',
  power: '电力',
};

const escapeHtml = (value: unknown) =>
  String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');

const isDarkColor = (color: string) => {
  const match = /^#([0-9a-f]{6})$/i.exec(color);
  if (!match) return false;
  const value = Number.parseInt(match[1], 16);
  const red = (value >> 16) & 255;
  const green = (value >> 8) & 255;
  const blue = value & 255;
  return (red * 299 + green * 587 + blue * 114) / 1000 < 128;
};

const TopologyPage: React.FC = () => {
  const { token } = theme.useToken();
  const [datacenters, setDatacenters] = useState<
    { id: string; name: string }[]
  >([]);
  const [selectedDc, setSelectedDc] = useState<string>();
  const [nodes, setNodes] = useState<TopologyNode[]>([]);
  const [edges, setEdges] = useState<TopologyEdge[]>([]);
  const [selectedNode, setSelectedNode] = useState<TopologyNode>();
  const [selectedEdge, setSelectedEdge] = useState<SelectedTopologyEdge>();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string>();
  const [graphReady, setGraphReady] = useState(false);
  const [isFullscreen, setIsFullscreen] = useState(false);

  const containerRef = useRef<HTMLDivElement>(null);
  const graphRef = useRef<Graph | null>(null);
  const cardRef = useRef<HTMLDivElement>(null);

  const graphTheme = useMemo(
    () => ({
      surface: token.colorBgContainer,
      surfaceElevated: token.colorBgElevated,
      canvas: token.colorBgLayout,
      fillAlter: token.colorFillAlter,
      border: token.colorBorderSecondary,
      grid: token.colorSplit,
      text: token.colorText,
      textSecondary: token.colorTextSecondary,
      primary: token.colorPrimary,
      primaryShadow: token.colorPrimaryBg,
      error: token.colorError,
      success: token.colorSuccess,
      warning: token.colorWarning,
      disabled: token.colorTextDisabled,
      boxShadow: token.boxShadowSecondary,
    }),
    [
      token.boxShadowSecondary,
      token.colorBgContainer,
      token.colorBgElevated,
      token.colorBgLayout,
      token.colorBorderSecondary,
      token.colorError,
      token.colorFillAlter,
      token.colorPrimary,
      token.colorPrimaryBg,
      token.colorSplit,
      token.colorSuccess,
      token.colorText,
      token.colorTextDisabled,
      token.colorTextSecondary,
      token.colorWarning,
    ],
  );

  const statusColors: Record<string, string> = {
    online: graphTheme.success,
    warning: graphTheme.warning,
    offline: graphTheme.disabled,
  };

  const typeColors = useMemo(
    () => getHighContrastTypeColors(isDarkColor(graphTheme.surface)),
    [graphTheme.surface],
  );

  const themedCardStyle = {
    '--topology-surface': graphTheme.surface,
    '--topology-surface-elevated': graphTheme.surfaceElevated,
    '--topology-canvas': graphTheme.canvas,
    '--topology-fill-alter': graphTheme.fillAlter,
    '--topology-border': graphTheme.border,
    '--topology-text': graphTheme.text,
    '--topology-text-secondary': graphTheme.textSecondary,
    '--topology-box-shadow': graphTheme.boxShadow,
  } as React.CSSProperties;

  useEffect(() => {
    getAllDatacenters()
      .then((res) => {
        if (res.success && res.data?.length) {
          setDatacenters(res.data);
          setSelectedDc(res.data[0].id);
          return;
        }
        setError('未获取到可用的数据中心');
      })
      .catch(() => setError('数据中心列表加载失败，请稍后重试'));
  }, []);

  useEffect(() => {
    if (!selectedDc) return;

    let active = true;
    setLoading(true);
    setError(undefined);
    setGraphReady(false);
    setSelectedNode(undefined);
    setSelectedEdge(undefined);

    getTopology(selectedDc)
      .then((res) => {
        if (!active) return;
        if (res.success && res.data) {
          setNodes(res.data.nodes || []);
          setEdges(res.data.edges || []);
        } else {
          setNodes([]);
          setEdges([]);
          setError('拓扑数据加载失败，请稍后重试');
        }
      })
      .catch(() => {
        if (!active) return;
        setNodes([]);
        setEdges([]);
        setError('拓扑数据加载失败，请检查服务状态后重试');
      })
      .finally(() => {
        if (active) setLoading(false);
      });

    return () => {
      active = false;
    };
  }, [selectedDc]);

  const nodeMap = useMemo(
    () => new Map(nodes.map((node) => [node.id, node])),
    [nodes],
  );

  const edgeMap = useMemo(
    () =>
      new Map(
        edges.map((edge, index) => {
          const id = `${edge.source}-${edge.target}-${index}`;
          return [id, { ...edge, id }];
        }),
      ),
    [edges],
  );

  useEffect(() => {
    if (!containerRef.current || nodes.length === 0 || loading) return;

    graphRef.current?.destroy();
    graphRef.current = null;

    const graph = new Graph({
      container: containerRef.current,
      width: containerRef.current.clientWidth || 800,
      height: GRAPH_HEIGHT,
      autoFit: 'view',
      padding: [56, 64, 72, 64],
      data: {
        nodes: nodes.map((node) => {
          const visualType = normalizeTopologyNodeType(node.type);
          const nodeStyle = getThemedNodeStyle(
            visualType,
            typeColors[visualType] || typeColors.other,
          );
          return {
            id: node.id,
            type: nodeStyle.type,
            data: { ...node, visualType },
            style: {
              ...nodeStyle,
              fill: graphTheme.surfaceElevated,
              opacity: node.status === 'offline' ? 0.6 : 1,
            },
          };
        }),
        edges: edges.map((edge, index) => ({
          id: `${edge.source}-${edge.target}-${index}`,
          source: edge.source,
          target: edge.target,
          data: edge,
          style: {
            stroke: connectionColors[edge.type] || graphTheme.border,
            lineWidth: edge.type === 'network' ? 2.5 : 2,
          },
        })),
      },
      layout: {
        type: 'antv-dagre',
        rankdir: 'TB',
        ranksep: 100,
        nodesep: 48,
        controlPoints: true,
      },
      node: {
        style: {
          labelText: (datum: any) => datum.data?.label || datum.id,
          labelPlacement: 'bottom',
          labelFill: graphTheme.text,
          labelFontSize: 12,
          labelFontWeight: 500,
          labelOffsetY: 10,
          labelWordWrap: true,
          labelMaxWidth: 120,
        },
        state: {
          active: {
            lineWidth: 3,
            shadowBlur: 16,
          },
          selected: {
            lineWidth: 4,
            stroke: graphTheme.primary,
            shadowColor: graphTheme.primaryShadow,
            shadowBlur: 18,
          },
          inactive: {
            opacity: 0.25,
          },
        },
      },
      edge: {
        type: 'cubic-vertical',
        style: {
          endArrow: true,
          endArrowSize: 7,
        },
        state: {
          active: {
            lineWidth: 4,
          },
          selected: {
            lineWidth: 4,
            stroke: graphTheme.primary,
          },
          inactive: {
            opacity: 0.15,
          },
        },
      },
      behaviors: [
        'drag-canvas',
        { type: 'zoom-canvas', sensitivity: 1.2 },
        'drag-element',
        'click-select',
        { type: 'hover-activate', degree: 1 },
      ],
      plugins: [
        {
          type: 'grid-line',
          size: 24,
          stroke: graphTheme.grid,
          lineWidth: 1,
        },
        {
          type: 'tooltip',
          style: {
            '.tooltip': {
              background: graphTheme.surfaceElevated,
              border: `1px solid ${graphTheme.border}`,
              boxShadow: graphTheme.boxShadow,
              color: graphTheme.text,
            },
          },
          getContent: (_event: unknown, items: any[]) => {
            const item = items?.[0];
            if (!item) return '';
            const data = item.data || {};
            if (item.source && item.target) {
              return `<div class="${styles.graphTooltip}"><strong>${escapeHtml(
                connectionLabels[data.type] || data.type,
              )}</strong><span>${escapeHtml(item.source)} → ${escapeHtml(
                item.target,
              )}</span></div>`;
            }
            return `<div class="${styles.graphTooltip}"><strong>${escapeHtml(
              data.label || item.id,
            )}</strong><span>类型：${escapeHtml(
              typeLabels[data.visualType] || typeLabels[data.type] || data.type,
            )}</span><span>状态：${escapeHtml(
              statusLabels[data.status] || data.status,
            )}</span></div>`;
          },
        },
      ],
    });

    graph.on('node:click', (event: any) => {
      setSelectedNode(nodeMap.get(String(event.target?.id)));
      setSelectedEdge(undefined);
    });
    graph.on('edge:click', (event: any) => {
      setSelectedEdge(edgeMap.get(String(event.target?.id)));
      setSelectedNode(undefined);
    });
    graph.on('canvas:click', () => {
      setSelectedNode(undefined);
      setSelectedEdge(undefined);
    });

    graphRef.current = graph;
    graph
      .render()
      .then(() => setGraphReady(true))
      .catch(() => setError('拓扑图渲染失败，请刷新页面重试'));

    return () => {
      graph.destroy();
      if (graphRef.current === graph) graphRef.current = null;
    };
  }, [edgeMap, edges, graphTheme, loading, nodeMap, nodes, typeColors]);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    const resizeObserver = new ResizeObserver(([entry]) => {
      if (!graphRef.current) return;
      const height = cardRef.current?.contains(document.fullscreenElement)
        ? Math.max(window.innerHeight - 190, GRAPH_HEIGHT)
        : GRAPH_HEIGHT;
      graphRef.current.setSize(entry.contentRect.width, height);
    });
    resizeObserver.observe(container);
    return () => resizeObserver.disconnect();
  }, [nodes.length]);

  useEffect(() => {
    const handleFullscreenChange = () => {
      setIsFullscreen(document.fullscreenElement === cardRef.current);
      requestAnimationFrame(() => graphRef.current?.fitView());
    };
    document.addEventListener('fullscreenchange', handleFullscreenChange);
    return () =>
      document.removeEventListener('fullscreenchange', handleFullscreenChange);
  }, []);

  const changeZoom = useCallback(async (factor: number) => {
    const graph = graphRef.current;
    if (!graph) return;
    await graph.zoomTo(Math.min(3, Math.max(0.2, graph.getZoom() * factor)));
  }, []);

  const toggleFullscreen = async () => {
    if (!cardRef.current) return;
    if (document.fullscreenElement === cardRef.current) {
      await document.exitFullscreen();
    } else {
      await cardRef.current.requestFullscreen();
    }
  };

  return (
    <PageContainer title={false}>
      <Card
        ref={cardRef}
        className={isFullscreen ? styles.fullscreenCard : undefined}
        style={themedCardStyle}
      >
        <div className={styles.toolbar}>
          <Space wrap>
            <span>数据中心：</span>
            <Select
              placeholder="请选择数据中心"
              className={styles.datacenterSelect}
              value={selectedDc}
              onChange={setSelectedDc}
              options={datacenters.map((dc) => ({
                value: dc.id,
                label: dc.name,
              }))}
            />
          </Space>
          <Space>
            <Tooltip title="缩小">
              <Button
                icon={<ZoomOut size={15} />}
                onClick={() => changeZoom(0.8)}
              />
            </Tooltip>
            <Tooltip title="放大">
              <Button
                icon={<ZoomIn size={15} />}
                onClick={() => changeZoom(1.25)}
              />
            </Tooltip>
            <Tooltip title="适应画布">
              <Button
                icon={<Focus size={15} />}
                onClick={() => graphRef.current?.fitView()}
              />
            </Tooltip>
            <Tooltip title={isFullscreen ? '退出全屏' : '全屏模式'}>
              <Button
                icon={
                  isFullscreen ? (
                    <Minimize2 size={15} />
                  ) : (
                    <Maximize2 size={15} />
                  )
                }
                onClick={toggleFullscreen}
              >
                {isFullscreen ? '退出全屏' : '全屏'}
              </Button>
            </Tooltip>
          </Space>
        </div>

        <div className={styles.summaryBar}>
          <Space className={styles.statistics} size={32} wrap>
            <Statistic title="设备" value={nodes.length} />
            <Statistic title="物理连线" value={edges.length} />
            <Statistic
              title="异常设备"
              value={nodes.filter((node) => node.status !== 'online').length}
              valueStyle={{ color: graphTheme.error }}
            />
          </Space>
          <div className={styles.legend}>
            <Space className={styles.legendRow} size={[14, 8]} wrap>
              {legendNodeTypes.map((type) => (
                <Badge
                  key={type}
                  color={typeColors[type]}
                  text={typeLabels[type]}
                />
              ))}
            </Space>
            <Space className={styles.legendRow} size={[14, 8]} wrap>
              {Object.entries(connectionLabels)
                .filter(([type]) =>
                  ['network', 'storage', 'management'].includes(type),
                )
                .map(([type, label]) => (
                  <Badge
                    key={type}
                    color={connectionColors[type]}
                    text={`${label}连线`}
                  />
                ))}
            </Space>
          </div>
        </div>

        {error && (
          <Alert
            className={styles.errorAlert}
            type="error"
            showIcon
            message={error}
          />
        )}

        <div className={styles.topologyContainer}>
          {loading ? (
            <div className={styles.loadingWrapper}>
              <Spin size="large" tip="加载拓扑数据中..." />
            </div>
          ) : nodes.length === 0 ? (
            <Empty description="暂无拓扑数据" className={styles.emptyState} />
          ) : (
            <>
              <div
                ref={containerRef}
                className={styles.graphContainer}
                style={{ opacity: graphReady ? 1 : 0.35 }}
              />
              {selectedNode && (
                <Card
                  size="small"
                  className={styles.detailCard}
                  title="设备详情"
                  extra={
                    <Button
                      type="text"
                      size="small"
                      onClick={() => setSelectedNode(undefined)}
                    >
                      关闭
                    </Button>
                  }
                >
                  <Descriptions column={1} size="small">
                    <Descriptions.Item label="设备名称">
                      {selectedNode.label}
                    </Descriptions.Item>
                    <Descriptions.Item label="设备类型">
                      {typeLabels[
                        normalizeTopologyNodeType(selectedNode.type)
                      ] || selectedNode.type}
                    </Descriptions.Item>
                    <Descriptions.Item label="运行状态">
                      <Badge
                        color={statusColors[selectedNode.status] || '#8c8c8c'}
                        text={
                          statusLabels[selectedNode.status] ||
                          selectedNode.status
                        }
                      />
                    </Descriptions.Item>
                    <Descriptions.Item label="设备 ID">
                      {selectedNode.id}
                    </Descriptions.Item>
                  </Descriptions>
                </Card>
              )}
              {selectedEdge && (
                <Card
                  size="small"
                  className={styles.detailCard}
                  title="连线详情"
                  extra={
                    <Button
                      type="text"
                      size="small"
                      onClick={() => setSelectedEdge(undefined)}
                    >
                      关闭
                    </Button>
                  }
                >
                  <Descriptions column={1} size="small">
                    <Descriptions.Item label="连线类型">
                      <Badge
                        color={
                          connectionColors[selectedEdge.type] ||
                          graphTheme.border
                        }
                        text={
                          connectionLabels[selectedEdge.type] ||
                          selectedEdge.type
                        }
                      />
                    </Descriptions.Item>
                    <Descriptions.Item label="源设备">
                      {nodeMap.get(selectedEdge.source)?.label ||
                        selectedEdge.source}
                    </Descriptions.Item>
                    <Descriptions.Item label="目标设备">
                      {nodeMap.get(selectedEdge.target)?.label ||
                        selectedEdge.target}
                    </Descriptions.Item>
                    <Descriptions.Item label="源设备 ID">
                      {selectedEdge.source}
                    </Descriptions.Item>
                    <Descriptions.Item label="目标设备 ID">
                      {selectedEdge.target}
                    </Descriptions.Item>
                  </Descriptions>
                </Card>
              )}
            </>
          )}
        </div>
      </Card>
    </PageContainer>
  );
};

export default TopologyPage;
