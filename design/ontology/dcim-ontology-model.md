# DCIM Ontology 模型

## 建模假设

1. `Datacenter` 在当前 Demo 中同时代表站点、机房管理单元和容量统计边界。
2. `Cabinet` 是空间对象，也是可承载设备的安装位置。
3. `DeviceTemplate` 是型号或产品模型，`Device` 是资产实例。
4. `PDU` 在 mock 中独立于 `Device`，但 Ontology 中应建模为 `PowerDistributionUnit`，同时也是 `RackMountedEquipment`。
5. `Connection`、`PowerLink`、`Observation`、`Alert` 都是事实对象，不只是两个对象之间的字段。

## 模块划分

| 模块 | 职责 | 关键概念 |
|---|---|---|
| `dcim-core` | 所有对象的统一标识、名称、状态、来源、时间 | `ManagedEntity`, `LifecycleState`, `OperationalState` |
| `dcim-location` | 数据中心、机柜、布局区域 | `Datacenter`, `Cabinet`, `LayoutZone`, `LayoutFacility` |
| `dcim-asset` | 设备模板、资产实例、上架安装 | `ProductModel`, `Device`, `RackInstallation` |
| `dcim-network` | 端口、线缆、网络/管理/存储连接 | `Port`, `CableConnection`, `VlanConfig`, `QosConfig` |
| `dcim-electrical` | 市电、UPS、PDU、设备供电链路 | `UtilityFeed`, `UPS`, `PDU`, `PowerConnection` |
| `dcim-observation` | 温湿度、功率、PUE 等观测值 | `Sensor`, `Observation`, `MetricType` |
| `dcim-alert` | 告警规则、告警事件、确认和恢复 | `AlertRule`, `AlertEvent` |

## 核心类

```text
ManagedEntity
├── SpatialEntity
│   ├── Datacenter
│   ├── Cabinet
│   ├── LayoutZone
│   └── LayoutFacility
├── Asset
│   ├── Device
│   │   ├── Server
│   │   ├── Switch
│   │   ├── Router
│   │   ├── Storage
│   │   ├── Firewall
│   │   └── LoadBalancer
│   └── PowerDistributionUnit
├── ProductModel
│   └── DeviceTemplate
├── Interface
│   └── Port
├── RelationshipFact
│   ├── RackInstallation
│   ├── CableConnection
│   └── PowerConnection
├── Observation
└── AlertEvent
```

## 关键关系

| 关系 | Domain | Range | 是否实体化 | 说明 |
|---|---|---|---|---|
| `contains` | `Datacenter` | `Cabinet` | 否 | 空间包含，可由 `Cabinet.datacenterId` 表达 |
| `installedIn` | `Device/PDU` | `Cabinet` | 是 | 需要表达 U 位、时间、占用约束 |
| `hasProductModel` | `Device/PDU` | `DeviceTemplate` | 否 | 设备实例到型号 |
| `hasPort` | `Device` | `Port` | 否 | 端口归属 |
| `connectedByCable` | `Port` | `Port` | 是 | 需要线缆编号、类型、长度、状态 |
| `poweredBy` | `Device/PDU/UPS` | `PDU/UPS/UtilityFeed` | 是 | 需要 A/B 路、负载、状态 |
| `observes` | `Sensor` | `Cabinet/Device/Datacenter` | 是 | 观测目标和指标类型 |
| `triggers` | `AlertRule` | `AlertEvent` | 否 | 告警事件记录规则来源 |

## 状态语义

当前 mock 中存在多类状态，不能合并为一个 `status` 概念。

| 状态来源 | Ontology 语义 | 当前枚举 |
|---|---|---|
| `Datacenter.status` | 管理/生命周期状态 | `active`, `maintenance`, `offline` |
| `Cabinet.status` | 健康状态 | `normal`, `warning`, `error`, `offline` |
| `Device.status` | 运行状态 | `online`, `offline`, `warning`, `error`, `maintenance` |
| `Port.status` | 接口管理状态 | `up`, `down`, `disabled`, `error` |
| `Port.linkStatus` | 链路检测状态 | `connected`, `disconnected` |
| `Connection.status` | 连接事实状态 | `active`, `inactive`, `faulty` |
| `Alert.level` | 事件严重度 | `info`, `warning`, `error`, `critical` |

## TBox 到 Demo 数据的最小映射

| Ontology 类 | 当前数据结构 |
|---|---|
| `Datacenter` | `IDC.Datacenter` |
| `Cabinet` | `IDC.Cabinet` |
| `ProductModel` | `IDC.DeviceTemplate`, `pduTemplates` |
| `Device` | `IDC.Device` |
| `PowerDistributionUnit` | `pduDevices` |
| `Port` | `IDC.Port` |
| `CableConnection` | `IDC.Connection` |
| `PowerConnection` | `powerLinks` |
| `Observation` | `EnvironmentSensor`, `PowerConsumption`, `PueData`, `TemperatureTrend` |
| `AlertRule` | `IDC.AlertRule` |
| `AlertEvent` | `IDC.AlertDetail` |
