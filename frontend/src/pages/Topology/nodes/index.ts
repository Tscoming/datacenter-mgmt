import { FIREWALL_NODE_TYPE, firewallNodeStyle } from './FirewallNode';
import {
  LOADBALANCER_NODE_TYPE,
  loadbalancerNodeStyle,
} from './LoadbalancerNode';
import { OTHER_NODE_TYPE, otherNodeStyle } from './OtherNode';
import { ROUTER_NODE_TYPE, routerNodeStyle } from './RouterNode';
import { SERVER_NODE_TYPE, serverNodeStyle } from './ServerNode';
import { STORAGE_NODE_TYPE, storageNodeStyle } from './StorageNode';
import { SWITCH_NODE_TYPE, switchNodeStyle } from './SwitchNode';

type BuiltInNodeType = 'circle' | 'diamond' | 'ellipse' | 'hexagon' | 'rect';

export interface NodeStyleConfig {
  [key: string]: unknown;
  type: BuiltInNodeType;
  size: [number, number];
  iconSrc: string;
}

export {
  FIREWALL_NODE_TYPE,
  firewallNodeStyle,
  LOADBALANCER_NODE_TYPE,
  loadbalancerNodeStyle,
  OTHER_NODE_TYPE,
  otherNodeStyle,
  ROUTER_NODE_TYPE,
  routerNodeStyle,
  SERVER_NODE_TYPE,
  STORAGE_NODE_TYPE,
  SWITCH_NODE_TYPE,
  serverNodeStyle,
  storageNodeStyle,
  switchNodeStyle,
};

export const normalizeTopologyNodeType = (deviceType: string) => {
  const normalized = deviceType.toLowerCase().replaceAll('_', '-');
  const aliases: Record<string, string> = {
    switch: 'access-switch',
    core: 'core-switch',
    'core-switch': 'core-switch',
    aggregation: 'aggregation-switch',
    'aggregation-switch': 'aggregation-switch',
    distribution: 'aggregation-switch',
    'distribution-switch': 'aggregation-switch',
    access: 'access-switch',
    'access-switch': 'access-switch',
    router: 'router',
    firewall: 'firewall',
    loadbalancer: 'loadbalancer',
    'load-balancer': 'loadbalancer',
    server: 'server',
    storage: 'storage',
    vm: 'virtual',
    pod: 'virtual',
    virtual: 'virtual',
    'virtual-machine': 'virtual',
  };
  return aliases[normalized] || 'other';
};

const visualNodeStyles: Record<string, NodeStyleConfig> = {
  'core-switch': {
    ...switchNodeStyle,
    type: 'diamond',
    size: [120, 90],
  },
  'aggregation-switch': {
    ...switchNodeStyle,
    type: 'rect',
    size: [96, 72],
    radius: 10,
  },
  'access-switch': {
    ...switchNodeStyle,
    type: 'rect',
    size: [80, 60],
    radius: 8,
  },
  router: {
    ...routerNodeStyle,
    type: 'diamond',
    size: [96, 72],
  },
  firewall: {
    ...firewallNodeStyle,
    type: 'hexagon',
    size: [88, 66],
  },
  loadbalancer: {
    ...loadbalancerNodeStyle,
    type: 'rect',
    size: [80, 60],
    radius: 18,
  },
  server: {
    ...serverNodeStyle,
    type: 'circle',
    size: [52, 52],
  },
  storage: {
    ...storageNodeStyle,
    type: 'ellipse',
    size: [80, 60],
  },
  virtual: {
    ...serverNodeStyle,
    type: 'ellipse',
    size: [64, 40],
  },
  other: {
    ...otherNodeStyle,
    type: 'rect',
    size: [72, 54],
  },
};

export const typeColors: Record<string, string> = {
  'core-switch': '#ff6b6b',
  'aggregation-switch': '#4a90d9',
  'access-switch': '#52c41a',
  switch: '#52c41a',
  router: '#fa8c16',
  firewall: '#f5222d',
  loadbalancer: '#722ed1',
  server: '#1890ff',
  storage: '#13c2c2',
  virtual: '#bfbfbf',
  vm: '#bfbfbf',
  pod: '#bfbfbf',
  other: '#8c8c8c',
};

const darkThemeTypeColors: Record<string, string> = {
  'core-switch': '#ff9c9c',
  'aggregation-switch': '#69b1ff',
  'access-switch': '#95de64',
  switch: '#95de64',
  router: '#ffc069',
  firewall: '#ff4d4f',
  loadbalancer: '#b37feb',
  server: '#69b1ff',
  storage: '#5cdbd3',
  virtual: '#d9d9d9',
  vm: '#d9d9d9',
  pod: '#d9d9d9',
  other: '#d9d9d9',
};

const lightThemeTypeColors: Record<string, string> = {
  'core-switch': '#c93f46',
  'aggregation-switch': '#2f6fad',
  'access-switch': '#237804',
  switch: '#237804',
  router: '#ad4e00',
  firewall: '#a8071a',
  loadbalancer: '#531dab',
  server: '#0958d9',
  storage: '#006d75',
  virtual: '#434343',
  vm: '#434343',
  pod: '#434343',
  other: '#434343',
};

export const getHighContrastTypeColors = (isDarkTheme: boolean) =>
  isDarkTheme ? darkThemeTypeColors : lightThemeTypeColors;

export const connectionColors: Record<string, string> = {
  network: '#1890ff',
  storage: '#faad14',
  management: '#52c41a',
  power: '#f5222d',
};

export const getNodeStyleByType = (deviceType: string): NodeStyleConfig =>
  visualNodeStyles[normalizeTopologyNodeType(deviceType)] ||
  visualNodeStyles.other;

const recolorSvgIcon = (iconSrc: string, color: string) => {
  const separatorIndex = iconSrc.indexOf(',');
  if (separatorIndex < 0) return iconSrc;

  const prefix = iconSrc.slice(0, separatorIndex + 1);
  const encodedSvg = iconSrc.slice(separatorIndex + 1);
  const svg = decodeURIComponent(encodedSvg).replace(
    /stroke="[^"]+"/,
    `stroke="${color}"`,
  );
  return `${prefix}${encodeURIComponent(svg)}`;
};

export const getThemedNodeStyle = (
  deviceType: string,
  color: string,
): NodeStyleConfig => {
  const style = getNodeStyleByType(deviceType);
  return {
    ...style,
    stroke: color,
    iconFill: color,
    iconSrc: recolorSvgIcon(style.iconSrc, color),
    shadowColor: `${color}33`,
  };
};
