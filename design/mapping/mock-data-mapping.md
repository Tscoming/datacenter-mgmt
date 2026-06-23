# Mock 数据映射

## 数据源清单

| Mock 文件 | 主要对象 | 说明 |
|---|---|---|
| `backend/mock/datacenter.mock.ts` | `Datacenter` | 数据中心主数据 |
| `backend/mock/cabinet.mock.ts` | `Cabinet` | 机柜主数据和容量字段 |
| `backend/mock/deviceTemplate.mock.ts` | `DeviceTemplate` | 设备型号、端口组、规格 |
| `backend/mock/device.mock.ts` | `Device` | 设备资产实例和安装位置 |
| `backend/mock/port.mock.ts` | `Port` | 按设备模板动态生成端口 |
| `backend/mock/connection.mock.ts` | `Connection` | 网络、管理、存储、供电线缆 |
| `backend/mock/pdu.mock.ts` | `PDU` | PDU 设备与 PDU 模板 |
| `backend/mock/powerTopology.mock.ts` | `PowerNode`, `PowerLink` | 市电、UPS、PDU、设备供电拓扑 |
| `backend/mock/environment.mock.ts` | `Observation` | 温湿度、功率、PUE、能耗 |
| `backend/mock/alert.mock.ts` | `AlertRule`, `AlertDetail` | 告警规则和告警事件 |
| `backend/mock/layout.mock.ts` | `DatacenterLayout` | 平面布局、区域、设施 |

## 字段映射

### Datacenter

| Mock 字段 | Canonical 字段 | Ontology |
|---|---|---|
| `id` | `datacenter.id` | Individual IRI 后缀 |
| `name` | `datacenter.name` | `rdfs:label` |
| `code` | `datacenter.code` | 业务编码 |
| `address` | `datacenter.address` | 地址属性 |
| `area` | `datacenter.area_sqm` | 面积观测/属性 |
| `status` | `datacenter.lifecycle_status` | 生命周期状态 |
| `totalCabinets`, `usedCabinets` | 派生统计 | 不作为事实权威来源 |

### Cabinet

| Mock 字段 | Canonical 字段 | Ontology |
|---|---|---|
| `id` | `cabinet.id` | `Cabinet` Individual |
| `datacenterId` | `cabinet.datacenter_id` | `locatedIn` / `contains` |
| `row`, `column` | `cabinet.row_no`, `cabinet.column_no` | 平面位置索引 |
| `uHeight` | `cabinet.u_height` | U 位容量 |
| `usedU` | 派生统计 | 由安装事实计算 |
| `maxPower` | `cabinet.max_power_w` | 容量上限 |
| `currentPower` | 当前观测或快照 | 优先由功率观测计算 |
| `status` | `cabinet.health_status` | 健康状态 |

### DeviceTemplate

| Mock 字段 | Canonical 字段 | Ontology |
|---|---|---|
| `id` | `device_template.id` | `ProductModel` Individual |
| `category` | `device_template.category` | 设备类别映射 |
| `brand`, `model` | `brand`, `model` | 型号属性 |
| `uHeight` | `u_height` | 默认占用 U 数 |
| `portGroups` | `port_group` | 端口模板 |
| `specs` | `spec_json` | 非规范化规格扩展 |
| `maxPower` | `max_power_w` | 额定或最大功率 |

### Device

| Mock 字段 | Canonical 字段 | Ontology |
|---|---|---|
| `id` | `device.id` | `Device` Individual |
| `templateId` | `device.template_id` | `hasProductModel` |
| `cabinetId`, `startU`, `endU` | `rack_installation` | `installedIn` 事实 |
| `assetCode` | `device.asset_code` | 资产编码 |
| `serialNumber` | `device.serial_number` | 序列号 |
| `managementIp` | `device.management_ip` | 管理属性 |
| `status` | `device.operational_status` | 运行状态 |
| `owner`, `department` | `device.owner`, `department` | 责任归属属性 |

### Port 与 Connection

| Mock 字段 | Canonical 字段 | Ontology |
|---|---|---|
| `Port.deviceId` | `port.device_id` | `hasPort` |
| `Port.portGroupId` | `port.port_group_id` | 来自端口模板 |
| `Port.portNumber` | `port.port_number` | 接口编号 |
| `Port.portType`, `speed` | `port.port_type`, `speed` | 接口类型与速率 |
| `vlanConfig`, `qosConfig` | `vlan_config`, `qos_config` | JSON 配置 |
| `Connection.sourcePortId`, `targetPortId` | `cable_connection` | 端口连接事实 |
| `cableNumber`, `cableType`, `cableLength` | `cable_connection` 属性 | 线缆事实属性 |

### 电力拓扑

| Mock 字段 | Canonical 字段 | Ontology |
|---|---|---|
| `powerNodes.id` | `power_node.id` | `UtilityFeed` / `UPS` / `PDU` / `Device` |
| `powerNodes.type` | `power_node.node_type` | 电力节点类别 |
| `powerNodes.load`, `capacity` | `load_w`, `capacity_w` | 当前负载与容量 |
| `powerLinks.source`, `target` | `power_connection` | `poweredBy` 事实 |
| `powerLinks.powerPath` | `power_path` | A/B 路 |
| `powerLinks.status` | `status` | 连接事实状态 |

### 环境与告警

| Mock 字段 | Canonical 字段 | Ontology |
|---|---|---|
| `EnvironmentSensor.temperature` | `observation.metric='temperature'` | 温度观测 |
| `EnvironmentSensor.humidity` | `observation.metric='humidity'` | 湿度观测 |
| `PowerConsumption.*` | `observation` | 功率、电流、电压、电量观测 |
| `PueData.*` | `pue_daily` 或 `observation` | PUE 日指标 |
| `AlertRule.condition` | `alert_rule.condition_json` | 规则条件 |
| `AlertDetail.*` | `alert_event` | 告警事件事实 |

## 派生字段处理

下列字段不应作为权威事实直接维护，应由事实表计算或作为缓存：

| 字段 | 推荐来源 |
|---|---|
| `Datacenter.totalCabinets` | `count(cabinet where datacenter_id=...)` |
| `Datacenter.usedCabinets` | 有安装设备的机柜数 |
| `Cabinet.usedU` | `rack_installation.end_u - start_u + 1` 汇总 |
| `Cabinet.currentPower` | `power_observation` 或 PDU/设备负载汇总 |
| `DashboardStats.*` | 查询聚合或物化视图 |
