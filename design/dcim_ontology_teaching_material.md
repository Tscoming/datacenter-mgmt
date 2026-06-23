# 基于 Ontology 的数据中心基础设施管理数据模型设计

> 教学版教材  
> 适用对象：数据中心架构师、DCIM 产品经理、数字孪生工程师、数据库设计人员、BIM/运维集成人员  
> 建议学时：16～24 学时  
> 文档定位：从行业标准、Ontology 理论、语义建模到数据库落地的系统化教程

---

## 目录

1. 课程导入：为什么 DCIM 需要统一数据模型  
2. 行业标准与技术体系全景  
3. Ontology 基础理论  
4. DCIM 本体总体架构  
5. 核心领域模型设计  
6. 关系实体化与拓扑建模  
7. 时间、来源与数据可信度  
8. 约束、规则与推理  
9. 数据库物理模型设计  
10. Ontology 与数据库同步架构  
11. 查询、分析与能力问题  
12. 项目实施方法与治理机制  
13. 教学案例：从机柜到业务影响分析  
14. 常见误区与改进建议  
15. 实施检查表  
16. 术语表  
17. 练习题与实践任务

---

# 1. 课程导入：为什么 DCIM 需要统一数据模型

## 1.1 DCIM 管理对象的复杂性

数据中心基础设施管理并不是单纯的资产管理。它同时涉及：

- 园区、楼宇、楼层、机房、功能区、机柜和 U 位；
- 市电、变压器、开关柜、ATS、UPS、PDU、机柜 PDU 和服务器 PSU；
- 冷机、冷却塔、水泵、CRAC、CRAH、CDU、Manifold 和冷板；
- 服务器、存储、网络、GPU、虚拟机、容器和 Kubernetes 集群；
- 端口、线缆、配线架、VLAN、VRF、子网和逻辑链路；
- 温度、功率、电量、流量、压力和湿度等监控数据；
- 告警、事件、故障、工单、巡检、变更和维护计划；
- 应用、业务服务、租户、负责人、SLA 和依赖关系；
- BIM、IFC、三维模型、图纸、说明书和验收文档。

这些对象并不是单纯的树形关系，而是一个复杂的、多领域、多时间维度的关系网络。

## 1.2 传统数据库建模的局限

传统系统常见设计如下：

```text
设备表
- 设备名称
- 设备类型
- 所属机房
- 所属机柜
- 上级设备
- 状态
```

这种设计的问题包括：

1. `上级设备` 无法同时表达空间包含、供电、制冷、网络和业务依赖。
2. 一个简单的 `status` 无法区分生命周期状态、运行状态、健康状态和管理状态。
3. 双路供电、旁路、母联和切换关系难以表达。
4. 设备可能同时属于多个类别，单一 `device_type` 无法满足语义需求。
5. 属性来源、可信度和有效时间无法追踪。
6. IFC、Redfish、BACnet、SNMP 等外部数据难以统一。
7. 数据虽然“存进去了”，但无法稳定回答影响分析和风险分析问题。

## 1.3 统一数据模型的目标

一个成熟的 DCIM 统一数据模型，应能够回答：

- 这台设备是什么？
- 它位于哪里？
- 它连接了什么？
- 它由什么供电？
- 它由什么制冷？
- 它承载了哪些逻辑资源和业务？
- 它有哪些监控点？
- 数据来自哪里？
- 这些事实在哪个时间段有效？
- 如果某个设备发生故障，会影响什么？
- 当前数据是否完整、合规、可信？

因此，推荐建立：

> **DCIM Ontology + Canonical Data Model + 多模数据库体系**

---

# 2. 行业标准与技术体系全景

不存在一个能够独立覆盖所有 DCIM 领域的单一标准。最佳实践是按照领域复用标准，并通过企业本体统一映射。

## 2.1 标准分层

| 领域 | 主要标准或技术 | 作用 |
|---|---|---|
| 数据中心总体 | ISO/IEC 22237、TIA-942 | 设施分类、空间、电气、制冷、安全、运营 |
| 建筑与空间 | IFC / ISO 16739 | 建筑、空间、设备几何、管线、BIM 交换 |
| IT 设备管理 | DMTF Redfish | 服务器、机箱、CPU、内存、GPU、电源、风扇、遥测 |
| 通用管理语义 | DMTF CIM | 管理对象、设备、系统、服务和关系 |
| 楼宇与动力环境 | BACnet、Modbus、SNMP | 设备通信和数据采集 |
| 楼宇语义 | Brick、Project Haystack、ASHRAE 223 | 设备、测点、空间和系统关系语义 |
| 观测与传感 | W3C SOSA/SSN | 传感器、观测、属性、被观测对象 |
| 单位与量纲 | QUDT、UCUM | 单位、量值类型、维度和转换 |
| 时间语义 | OWL-Time | 时间点、时间段和时间关系 |
| 数据来源 | PROV-O | 数据来源、活动、主体和衍生关系 |
| 能效指标 | ISO/IEC 30134 | PUE、WUE 等指标口径 |
| 运维流程 | ITIL、ISO/IEC 20000 | 事件、问题、变更、配置和服务管理 |

## 2.2 标准的正确使用方式

标准不应被简单地“导入系统”，而应承担不同角色：

```text
标准分类和概念
        ↓
企业 DCIM Ontology
        ↓
Canonical Data Model
        ↓
数据库、接口和应用
```

例如：

- IFC 负责空间和几何数据；
- Redfish 负责 IT 设备接口和设备结构；
- BACnet/Modbus/SNMP 负责采集；
- Brick/Haystack 负责楼宇设备和测点语义；
- SOSA/SSN 负责观测模型；
- QUDT 负责单位；
- PROV-O 负责来源；
- 企业 DCIM 本体负责跨域统一。

## 2.3 版本管理原则

标准可能持续更新，因此应：

- 保存标准名称和版本；
- 保存外部类型标识；
- 建立版本间映射；
- 不把外部类型作为企业主键；
- 对已经废弃的概念标记 `deprecated`；
- 支持 `replacedBy` 或等价映射。

---

# 3. Ontology 基础理论

## 3.1 什么是 Ontology

Ontology 可以理解为：

> 对某个领域中的概念、关系、属性、约束和规则进行形式化表达的知识模型。

它不仅说明“有哪些对象”，还说明：

- 对象属于什么类别；
- 类别之间有什么继承关系；
- 对象之间可以建立什么关系；
- 某些关系是否具有逆关系、传递性或对称性；
- 哪些事实可以被推理出来；
- 外部标准概念如何映射到企业概念。

## 3.2 TBox 与 ABox

### TBox：术语层

TBox 描述概念和关系定义。

```text
Server 是 ComputeDevice
ComputeDevice 是 ITEquipment
ITEquipment 是 ManagedAsset
poweredBy 的定义域是 Equipment
poweredBy 的值域是 ElectricalSystem
```

### ABox：实例层

ABox 描述现实世界中的具体对象。

```text
GPU-SRV-001 是 Server
GPU-SRV-001 安装在 Rack-A01
GPU-SRV-001 由 UPS-A 供电
```

## 3.3 类、个体和属性

### Class

表示类别：

```text
Server
Rack
UPS
Sensor
BusinessService
```

### Individual

表示实际对象：

```text
DC01
Rack-A01
UPS-A
GPU-SRV-001
```

### Object Property

表示对象之间的关系：

```text
installedIn
poweredBy
cooledBy
dependsOn
hasComponent
```

### Datatype Property

表示对象与数据值之间的关系：

```text
serialNumber
ratedPower
manufacturerName
temperatureValue
```

## 3.4 多重分类

同一个对象可以同时属于多个类。

```text
GPU-SRV-001:
- Server
- ManagedAsset
- RackMountedEquipment
- RedfishManagedDevice
- ProductionResource
```

这比传统数据库中的单一 `device_type` 更符合真实世界。

## 3.5 开放世界与封闭世界

### 开放世界假设

在 OWL 中：

```text
未记录第二路电源
```

不代表：

```text
不存在第二路电源
```

### 封闭世界假设

在业务合规检查中：

```text
没有记录第二路电源
```

通常应判定为：

```text
数据不完整或不合规
```

因此：

- OWL 负责语义和推理；
- SHACL 负责数据完整性和合规；
- 数据库约束负责事务一致性。

## 3.6 Ontology 不是数据库替代品

Ontology 适合：

- 统一语义；
- 跨系统映射；
- 关系推理；
- 影响分析；
- 知识查询。

关系数据库适合：

- 事务；
- 唯一性；
- 外键；
- 高并发写入；
- 当前状态维护。

时序数据库适合：

- 高频监控；
- 聚合；
- 趋势；
- 保留策略。

---

# 4. DCIM 本体总体架构

## 4.1 四层架构

```text
┌──────────────────────────────────────┐
│ Ontology 语义层                       │
│ 类、关系、继承、等价、逆关系、推理     │
├──────────────────────────────────────┤
│ 约束与规则层                          │
│ SHACL、策略、质量规则、合规规则         │
├──────────────────────────────────────┤
│ Canonical Data Model                  │
│ 实体、关系、属性、时间、来源、版本      │
├──────────────────────────────────────┤
│ 物理存储层                            │
│ PostgreSQL、RDF、Graph、TSDB、对象存储 │
└──────────────────────────────────────┘
```

## 4.2 模块化本体

```text
dcim-core
├── dcim-location
├── dcim-asset
├── dcim-topology
├── dcim-electrical
├── dcim-cooling
├── dcim-network
├── dcim-compute
├── dcim-observation
├── dcim-operations
├── dcim-business
├── dcim-sustainability
├── dcim-provenance
└── dcim-mapping
```

## 4.3 上层概念

```text
dcim:Entity
├── dcim:PhysicalEntity
├── dcim:LogicalEntity
├── dcim:InformationEntity
├── dcim:Activity
├── dcim:Event
└── dcim:Role
```

## 4.4 设计原则

1. 领域模块分离。
2. 核心概念稳定。
3. 外部标准通过映射接入。
4. 关系优先于字段堆积。
5. 复杂关系应实体化。
6. 所有事实支持来源。
7. 动态事实支持有效时间。
8. 推理事实与原始事实分离。
9. 语义模型与物理模型解耦。
10. 以能力问题验证模型。

---

# 5. 核心领域模型设计

# 5.1 空间与位置模型

## 类层次

```text
SpatialEntity
├── Site
├── Building
├── Floor
├── Room
│   ├── DataHall
│   ├── ElectricalRoom
│   ├── CoolingRoom
│   └── MeetMeRoom
├── Zone
│   ├── FireZone
│   ├── SecurityZone
│   ├── ColdAisle
│   └── HotAisle
├── Row
├── Rack
└── RackUnitPosition
```

## 核心关系

```text
contains
isContainedIn
locatedIn
installedIn
occupiesRackUnit
adjacentTo
hasGeometry
hasCoordinate
```

## 关系语义

| 关系 | 建议语义 |
|---|---|
| contains | 可定义为传递关系 |
| isContainedIn | contains 的逆关系 |
| adjacentTo | 对称关系 |
| installedIn | 非传递关系 |
| occupiesRackUnit | 设备到 U 位占用 |
| hasGeometry | 对应 IFC/三维模型 |
| locatedIn | 逻辑或空间位置 |

## 关键注意事项

- `contains` 和 `installedIn` 不应混用。
- 设备安装关系必须支持时间。
- 同一设备在同一时间只能有一个有效安装位置。
- 机柜 U 位占用需要防止重叠。
- 三维对象与资产对象通过全局 ID 关联。

---

# 5.2 资产与设备模型

## 类层次

```text
ManagedAsset
├── FacilityAsset
│   ├── ElectricalEquipment
│   ├── CoolingEquipment
│   ├── FireProtectionEquipment
│   └── SecurityEquipment
├── ITAsset
│   ├── ComputeDevice
│   ├── StorageDevice
│   └── NetworkDevice
├── PassiveAsset
│   ├── Cable
│   ├── PatchPanel
│   ├── Pipe
│   └── Busway
└── Component
    ├── PowerSupply
    ├── Fan
    ├── Processor
    ├── GPU
    ├── MemoryModule
    └── Port
```

## 型号与实例分离

```text
ProductModel
AssetInstance
```

示例：

```text
Dell PowerEdge XE9680 → ProductModel
SN-ABC12345           → AssetInstance
NVIDIA H100 SXM       → ProductModel
GPU-03                → Component
```

## 核心关系

```text
instanceOfModel
manufacturedBy
hasComponent
componentOf
managedBy
ownedBy
```

## 生命周期状态

建议至少分离：

```text
lifecycleStatus
operationalStatus
healthStatus
administrativeStatus
```

示例：

```text
lifecycleStatus      = Installed
operationalStatus    = Offline
healthStatus         = Critical
administrativeStatus = Maintenance
```

---

# 5.3 电力模型

## 类层次

```text
ElectricalEquipment
├── UtilityFeed
├── Transformer
├── Switchgear
├── ATS
├── Generator
├── UPS
├── DistributionPanel
├── RPP
├── Busway
├── RackPDU
├── Outlet
└── PowerSupplyUnit
```

## 供电链路示例

```text
UtilityFeed
→ Transformer
→ Switchgear
→ ATS
→ UPS
→ DistributionPanel
→ RPP
→ RackPDU
→ Outlet
→ Server PSU
```

## 直接关系与推导关系

```text
directlyFeeds
directlyFedBy
upstreamOf
downstreamOf
```

推荐语义：

```text
directlyFeeds 是 upstreamOf 的子属性
upstreamOf 可定义为传递关系
downstreamOf 是 upstreamOf 的逆关系
```

## 供电连接实体化

```text
PowerConnection
- fromEndpoint
- toEndpoint
- feedRole
- phase
- voltageLevel
- ratedCurrent
- switchable
- normalState
- redundancyGroup
- validDuring
- provenance
```

这样才能表达：

- A/B 路；
- 插口；
- PSU；
- 相位；
- 额定电流；
- 旁路；
- 切换状态；
- 有效时间；
- 数据来源。

---

# 5.4 制冷模型

## 类层次

```text
CoolingEquipment
├── Chiller
├── CoolingTower
├── Pump
├── CRAC
├── CRAH
├── InRowCooler
├── CDU
├── Manifold
├── HeatExchanger
├── Valve
└── ColdPlate
```

## 风冷链路

```text
Chiller
→ Pump
→ CRAH
→ ColdAisle
→ Rack
→ IT Equipment
```

## 液冷链路

```text
CoolingSource
→ PrimaryLoop
→ CDU
→ SecondaryLoop
→ Manifold
→ ColdPlate
→ GPU/CPU
```

## 制冷连接实体

```text
CoolingConnection
- sourceEndpoint
- targetEndpoint
- medium
- direction
- designFlow
- designPressure
- supplyOrReturn
- validDuring
```

## 核心关系

```text
directlySuppliesCoolingTo
cooledBy
hasSupplyConnection
hasReturnConnection
servesCoolingZone
rejectsHeatTo
```

---

# 5.5 网络与布线模型

## 类层次

```text
NetworkEntity
├── NetworkDevice
├── Module
├── PhysicalPort
├── LogicalInterface
├── Cable
├── CableEndpoint
├── PatchPanel
├── PhysicalLink
├── LogicalLink
├── VLAN
├── Subnet
├── VRF
├── LAG
└── Circuit
```

## 物理连接

```text
Device Port
→ Patch Cord
→ Patch Panel Port
→ Trunk Cable
→ Patch Panel Port
→ Patch Cord
→ Switch Port
```

## 逻辑连接

```text
LogicalInterface
→ VLAN
→ Subnet
→ VRF
→ LAG
```

## 核心关系

```text
physicallyConnectedTo
logicallyConnectedTo
terminatesAt
memberOfVLAN
memberOfLAG
belongsToVRF
hasIPAddress
```

注意：

- 物理连接和逻辑连接必须分开；
- `physicallyConnectedTo` 可以是对称关系；
- 物理连接不能定义为传递关系；
- 配线架是网络建模中的关键对象。

---

# 5.6 监控与观测模型

建议复用 SOSA/SSN。

## 核心概念

```text
Sensor
Observation
ObservableProperty
FeatureOfInterest
Procedure
Platform
Actuator
Actuation
```

## 示例

```text
Sensor-001 observes InletAirTemperature
Sensor-001 isHostedBy Server-001
Observation-123 hasFeatureOfInterest Server-001
Observation-123 observedProperty InletAirTemperature
Observation-123 hasSimpleResult 24.3
Observation-123 unit DEG_C
```

## 测点分类

```text
MeasurementPoint
├── TemperaturePoint
├── PowerPoint
├── EnergyPoint
├── VoltagePoint
├── CurrentPoint
├── PressurePoint
├── FlowPoint
└── HumidityPoint
```

## 单位设计

所有测量值必须包含：

```text
value
unit
timestamp
quality
source
```

错误：

```json
{
  "temperature": 24,
  "power": 500
}
```

推荐：

```json
{
  "metric": "inlet_temperature",
  "value": 24.0,
  "unit": "Cel",
  "timestamp": "2026-06-23T13:30:00+09:00",
  "quality": "good"
}
```

---

# 5.7 业务与服务依赖模型

## 类层次

```text
LogicalResource
├── BusinessService
├── Application
├── ApplicationComponent
├── DatabaseService
├── MiddlewareService
├── KubernetesCluster
├── VirtualMachine
├── Container
└── Tenant
```

## 核心关系

```text
directlyDependsOn
dependsOn
supportedBy
hosts
hostedOn
serves
ownedBy
managedBy
```

## 依赖链示例

```text
BusinessService
→ Application
→ KubernetesCluster
→ VirtualMachine
→ PhysicalServer
→ RackPDU
→ UPS
→ Transformer
```

## 影响分析

当 UPS 发生故障时，可以反向查询：

```text
UPS
→ RackPDU
→ Server
→ VM
→ Application
→ BusinessService
```

---

# 6. 关系实体化与拓扑建模

## 6.1 为什么关系需要实体化

简单三元关系：

```text
Server-001 poweredBy UPS-A
```

无法记录：

- 哪个 PSU；
- 哪个插口；
- A 路还是 B 路；
- 额定电流；
- 哪个时间段有效；
- 来源是什么；
- 是否经过人工确认。

因此应使用关系实体：

```text
PowerConnection-001
├── fromEndpoint: PDU-A-Outlet-12
├── toEndpoint: Server-001-PSU-1
├── feedRole: Feed-A
├── phase: L1
├── ratedCurrent: 16A
├── validFrom: 2026-01-01
├── sourceSystem: DCIM
└── confidence: 1.0
```

## 6.2 建议实体化的关系

- InstallationAssignment
- PowerConnection
- CoolingConnection
- NetworkLink
- OwnershipAssignment
- ResponsibilityAssignment
- ServiceDependency
- MeasurementBinding
- MaintenanceAssignment

## 6.3 图结构与树结构

空间层级通常接近树：

```text
Site
→ Building
→ Floor
→ Room
→ Row
→ Rack
```

电力、制冷、网络和业务依赖通常是图：

```text
多上游
多下游
冗余
旁路
环路
双路连接
```

不能用一个通用 `parent_id` 代替所有拓扑关系。

---

# 7. 时间、来源与数据可信度

# 7.1 时间模型

所有动态事实应具备有效时间。

```text
valid_from
valid_to
recorded_at
```

## 双时间模型

| 时间类型 | 含义 |
|---|---|
| Valid Time | 事实在现实世界中有效的时间 |
| Transaction Time | 事实被系统记录的时间 |

示例：

```text
设备于 6 月 1 日迁移
系统于 6 月 3 日补录
```

则：

```text
valid_from = 2026-06-01
recorded_at = 2026-06-03
```

## 应保存历史的事实

- 设备位置；
- 端口连接；
- 供电关系；
- 制冷关系；
- 所有权；
- 责任人；
- 业务依赖；
- 设备角色；
- 指标公式版本。

---

# 7.2 数据来源

同一事实可能来自：

- IFC；
- Redfish；
- BACnet；
- SNMP；
- CMDB；
- Excel；
- 人工录入；
- 自动发现；
- 现场巡检。

每个关键事实建议保存：

```text
sourceSystem
sourceRecordId
observedAt
ingestedAt
validFrom
validTo
confidence
verificationStatus
verifiedBy
payloadHash
```

## 权威来源策略

示例：

| 属性 | 权威来源 |
|---|---|
| 资产编码 | ERP/资产系统 |
| 序列号 | Redfish + 人工校验 |
| 设备位置 | DCIM |
| 建筑几何 | IFC/BIM |
| 实时温度 | BMS/传感器 |
| 业务归属 | CMDB |
| 工单状态 | ITSM |

## 冲突处理

当多个来源冲突时，不应直接覆盖。建议：

1. 保留所有来源断言；
2. 标记权威优先级；
3. 生成冲突记录；
4. 人工确认；
5. 形成经过验证的 canonical assertion。

---

# 8. 约束、规则与推理

# 8.1 OWL、SHACL 和数据库约束分工

| 能力 | 推荐技术 |
|---|---|
| 类别继承 | OWL |
| 逆关系 | OWL |
| 传递关系 | OWL |
| 等价类 | OWL |
| 必填字段 | SHACL |
| 数量限制 | SHACL |
| 条件合规 | SHACL/SPARQL |
| 唯一性 | 数据库 |
| 外键一致性 | 数据库 |
| U 位防重叠 | 数据库排斥约束 |
| 事务原子性 | 数据库 |

# 8.2 SHACL 示例

## 机柜位置约束

```turtle
dcim:RackShape
    a sh:NodeShape ;
    sh:targetClass loc:Rack ;

    sh:property [
        sh:path loc:locatedIn ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class loc:Room ;
        sh:message "机柜必须且只能位于一个机房空间中。" ;
    ] .
```

## 测点单位约束

```turtle
dcim:MeasurementPointShape
    a sh:NodeShape ;
    sh:targetClass dcim:MeasurementPoint ;

    sh:property [
        sh:path dcim:observedProperty ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
    ] ;

    sh:property [
        sh:path dcim:canonicalUnit ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
    ] .
```

## 供电连接约束

```turtle
dcim:PowerConnectionShape
    a sh:NodeShape ;
    sh:targetClass dcim:PowerConnection ;

    sh:property [
        sh:path dcim:fromEndpoint ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class dcim:PowerOutputEndpoint ;
    ] ;

    sh:property [
        sh:path dcim:toEndpoint ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class dcim:PowerInputEndpoint ;
    ] .
```

# 8.3 推理规则

## 部件位置推理

```text
如果：
PSU-1 componentOf Server-1
Server-1 installedIn Rack-A01

则：
PSU-1 locatedIn Rack-A01
```

## 供电上游推理

```text
如果：
PDU-A directlyFedBy UPS-A
Server-1 directlyFedBy PDU-A

则：
Server-1 upstreamPowerSystem UPS-A
```

## 业务影响推理

```text
如果：
Application-A dependsOn VM-1
VM-1 hostedOn Server-1
Server-1 poweredBy UPS-A

则：
Application-A potentiallyImpactedBy UPS-A
```

## 确定性与风险推断分离

应区分：

```text
dependsOn
potentiallyImpactedBy
```

前者是明确事实，后者是风险推断结果。

# 8.4 推理范围控制

生产环境建议：

- 使用 OWL 2 RL 风格推理；
- 预计算常用传递闭包；
- 限制递归深度；
- 区分实时查询和离线推理；
- 将推理结果写入独立 Named Graph；
- 避免在实时接口中执行无限制推理。

---

# 9. 数据库物理模型设计

# 9.1 推荐存储架构

| 数据类型 | 推荐存储 |
|---|---|
| 主数据和事务 | PostgreSQL |
| 本体、语义映射、推理 | RDF Store |
| 高级关系分析 | 图数据库或图查询层 |
| 时序监控 | TimescaleDB/时序数据库 |
| BIM、图纸、原始报文 | 对象存储 |
| 全文检索 | 搜索引擎 |

# 9.2 核心术语表

```sql
CREATE TYPE ontology_term_kind AS ENUM (
    'CLASS',
    'OBJECT_PROPERTY',
    'DATATYPE_PROPERTY',
    'CONCEPT',
    'UNIT',
    'STATUS'
);

CREATE TABLE ontology_term (
    term_id          BIGSERIAL PRIMARY KEY,
    iri              TEXT NOT NULL UNIQUE,
    local_name       TEXT NOT NULL,
    namespace        TEXT NOT NULL,
    term_kind        ontology_term_kind NOT NULL,
    label_zh         TEXT,
    label_en         TEXT,
    definition       TEXT,
    version          TEXT,
    deprecated       BOOLEAN NOT NULL DEFAULT FALSE,
    replaced_by_id   BIGINT REFERENCES ontology_term(term_id)
);
```

# 9.3 通用实体表

```sql
CREATE TABLE entity (
    entity_id               UUID PRIMARY KEY,
    iri                     TEXT NOT NULL UNIQUE,
    canonical_name          TEXT NOT NULL,
    description             TEXT,

    lifecycle_state_id      BIGINT REFERENCES ontology_term(term_id),
    operational_state_id    BIGINT REFERENCES ontology_term(term_id),
    health_state_id         BIGINT REFERENCES ontology_term(term_id),
    administrative_state_id BIGINT REFERENCES ontology_term(term_id),

    valid_from              TIMESTAMPTZ,
    valid_to                TIMESTAMPTZ,

    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    row_version             BIGINT NOT NULL DEFAULT 1,

    CHECK (valid_to IS NULL OR valid_to > valid_from)
);
```

# 9.4 多重类型表

```sql
CREATE TABLE entity_type (
    entity_id      UUID NOT NULL REFERENCES entity(entity_id)
                   ON DELETE CASCADE,
    class_term_id  BIGINT NOT NULL REFERENCES ontology_term(term_id),
    is_primary     BOOLEAN NOT NULL DEFAULT FALSE,
    source         TEXT,
    confidence     NUMERIC(5,4),

    PRIMARY KEY (entity_id, class_term_id),

    CHECK (confidence IS NULL OR confidence BETWEEN 0 AND 1)
);
```

# 9.5 外部标识表

```sql
CREATE TABLE entity_identifier (
    identifier_id    UUID PRIMARY KEY,
    entity_id        UUID NOT NULL REFERENCES entity(entity_id)
                     ON DELETE CASCADE,

    scheme           TEXT NOT NULL,
    identifier_value TEXT NOT NULL,
    source_system    TEXT,
    is_authoritative BOOLEAN NOT NULL DEFAULT FALSE,
    valid_from       TIMESTAMPTZ,
    valid_to         TIMESTAMPTZ,

    UNIQUE (scheme, identifier_value),
    CHECK (valid_to IS NULL OR valid_to > valid_from)
);
```

# 9.6 来源表

```sql
CREATE TABLE provenance_record (
    provenance_id      UUID PRIMARY KEY,
    source_system      TEXT NOT NULL,
    source_record_id   TEXT,
    activity_type      TEXT,
    agent              TEXT,
    observed_at        TIMESTAMPTZ,
    ingested_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    confidence         NUMERIC(5,4),
    verification_status TEXT,
    verified_by        TEXT,
    verified_at        TIMESTAMPTZ,
    payload_hash       TEXT,
    raw_payload_uri    TEXT
);
```

# 9.7 通用关系断言

```sql
CREATE TABLE relation_assertion (
    relation_id        UUID PRIMARY KEY,
    relation_type_id   BIGINT NOT NULL
                       REFERENCES ontology_term(term_id),

    subject_entity_id  UUID NOT NULL
                       REFERENCES entity(entity_id),

    object_entity_id   UUID NOT NULL
                       REFERENCES entity(entity_id),

    valid_during       TSTZRANGE NOT NULL,

    provenance_id      UUID
                       REFERENCES provenance_record(provenance_id),

    confidence         NUMERIC(5,4),
    assertion_status   TEXT NOT NULL DEFAULT 'ACTIVE',
    attributes         JSONB NOT NULL DEFAULT '{}'::jsonb,

    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),

    CHECK (subject_entity_id <> object_entity_id)
);
```

# 9.8 供电连接扩展表

```sql
CREATE TABLE power_connection (
    relation_id       UUID PRIMARY KEY
                      REFERENCES relation_assertion(relation_id)
                      ON DELETE CASCADE,

    from_endpoint_id  UUID NOT NULL REFERENCES entity(entity_id),
    to_endpoint_id    UUID NOT NULL REFERENCES entity(entity_id),

    feed_role         TEXT,
    phase             TEXT,
    voltage_level_v   NUMERIC(12,3),
    rated_current_a   NUMERIC(12,3),

    is_switchable     BOOLEAN NOT NULL DEFAULT FALSE,
    normal_state      TEXT,
    redundancy_group  TEXT
);
```

# 9.9 网络连接扩展表

```sql
CREATE TABLE network_link (
    relation_id       UUID PRIMARY KEY
                      REFERENCES relation_assertion(relation_id)
                      ON DELETE CASCADE,

    endpoint_a_id     UUID NOT NULL REFERENCES entity(entity_id),
    endpoint_b_id     UUID NOT NULL REFERENCES entity(entity_id),

    cable_entity_id   UUID REFERENCES entity(entity_id),
    link_layer        TEXT,
    media_type        TEXT,
    speed_bps         BIGINT,
    duplex_mode       TEXT,
    circuit_code      TEXT
);
```

# 9.10 空间安装表

```sql
CREATE TABLE spatial_placement (
    placement_id      UUID PRIMARY KEY,
    entity_id         UUID NOT NULL REFERENCES entity(entity_id),
    container_id      UUID NOT NULL REFERENCES entity(entity_id),

    rack_u_start      NUMERIC(5,2),
    rack_u_height     NUMERIC(5,2),

    position_x        NUMERIC(16,6),
    position_y        NUMERIC(16,6),
    position_z        NUMERIC(16,6),

    rotation_x        NUMERIC(16,6),
    rotation_y        NUMERIC(16,6),
    rotation_z        NUMERIC(16,6),

    ifc_global_id     TEXT,
    geometry_uri      TEXT,

    valid_during      TSTZRANGE NOT NULL,
    provenance_id     UUID REFERENCES provenance_record(provenance_id)
);
```

# 9.11 可扩展属性表

```sql
CREATE TABLE property_assertion (
    property_assertion_id UUID PRIMARY KEY,

    entity_id             UUID NOT NULL REFERENCES entity(entity_id),
    property_term_id      BIGINT NOT NULL
                          REFERENCES ontology_term(term_id),

    value_text            TEXT,
    value_number          NUMERIC,
    value_boolean         BOOLEAN,
    value_timestamp       TIMESTAMPTZ,
    value_json            JSONB,

    unit_term_id          BIGINT REFERENCES ontology_term(term_id),

    valid_during          TSTZRANGE,
    provenance_id         UUID REFERENCES provenance_record(provenance_id),

    confidence            NUMERIC(5,4),

    CHECK (
        num_nonnulls(
            value_text,
            value_number,
            value_boolean,
            value_timestamp,
            value_json
        ) = 1
    )
);
```

原则：

- 高频、关键字段使用明确列；
- 少量扩展属性使用 EAV；
- 不要把全部业务字段都塞进 JSONB；
- 不要用 EAV 替代领域建模。

---

# 9.12 时序数据模型

## 测点主数据

```sql
CREATE TABLE measurement_point (
    point_id                 UUID PRIMARY KEY,
    point_entity_id          UUID NOT NULL UNIQUE
                             REFERENCES entity(entity_id),

    feature_of_interest_id   UUID NOT NULL
                             REFERENCES entity(entity_id),

    sensor_entity_id         UUID REFERENCES entity(entity_id),

    observed_property_id     BIGINT NOT NULL
                             REFERENCES ontology_term(term_id),

    canonical_unit_id        BIGINT
                             REFERENCES ontology_term(term_id),

    source_protocol          TEXT,
    source_address           TEXT,
    sampling_interval_ms     BIGINT,
    aggregation_method       TEXT,
    enabled                  BOOLEAN NOT NULL DEFAULT TRUE
);
```

## 时序观测

```sql
CREATE TABLE observation (
    point_id         UUID NOT NULL
                     REFERENCES measurement_point(point_id),

    observed_at      TIMESTAMPTZ NOT NULL,

    numeric_value    DOUBLE PRECISION,
    text_value       TEXT,
    boolean_value    BOOLEAN,

    unit_term_id     BIGINT REFERENCES ontology_term(term_id),

    quality_code     TEXT,
    source_timestamp TIMESTAMPTZ,
    ingested_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    PRIMARY KEY (point_id, observed_at),

    CHECK (
        num_nonnulls(
            numeric_value,
            text_value,
            boolean_value
        ) = 1
    )
);
```

---

# 10. Ontology 与数据库同步架构

## 10.1 统一标识

推荐：

```text
数据库 UUID：
550e8400-e29b-41d4-a716-446655440000

RDF IRI：
urn:dcim:entity:550e8400-e29b-41d4-a716-446655440000
```

## 10.2 同步流程

```text
PostgreSQL
    ↓ CDC / Domain Event
Semantic Mapping Service
    ↓
RDF Knowledge Graph
    ↓
Reasoning + SHACL Validation
    ↓
Quality Result / Inferred Result
    ↓
API / Search / Digital Twin
```

## 10.3 Named Graph 设计

```text
graph:ontology-schema
graph:reference-data
graph:ifc-asserted
graph:redfish-asserted
graph:bms-asserted
graph:cmdb-asserted
graph:human-verified
graph:inferred
graph:policy-violations
```

## 10.4 数据权威分工

| 系统 | 权威内容 |
|---|---|
| PostgreSQL | 事务主数据、当前状态 |
| RDF Store | 语义、本体、映射、推理 |
| TSDB | 高频监控 |
| Object Storage | IFC、原始数据、文档 |
| ITSM | 工单、变更、事件 |
| CMDB | 应用和业务关系 |

---

# 11. 查询、分析与能力问题

Ontology 设计必须从能力问题出发。

## 11.1 核心能力问题

1. 某台服务器位于哪个机房、机柜和 U 位？
2. 某机柜还剩多少空间、电力和制冷容量？
3. 某服务器的 A/B 两路电源分别来自哪个 UPS？
4. UPS 故障会影响哪些机柜、服务器、虚拟机和业务？
5. 某设备的网络路径经过哪些端口和配线架？
6. 某 CDU 故障影响哪些 GPU 节点？
7. 哪些生产设备不符合双路供电策略？
8. 哪些测点缺少单位、采集地址或被测对象？
9. PUE 由哪些电表和测量边界计算？
10. 某次故障发生时，设备当时的拓扑是什么？
11. 某个属性来自 IFC、Redfish、BMS 还是人工录入？
12. 多个来源冲突时，哪个来源是权威来源？

## 11.2 示例查询逻辑

### 查询服务器上游 UPS

```text
Server
→ PSU
→ PowerConnection
→ RackPDU Outlet
→ RackPDU
→ RPP
→ UPS
```

### 查询业务影响

```text
UPS
→ downstream power topology
→ Physical Server
→ Virtual Machine
→ Application
→ Business Service
```

### 查询数据质量

```text
MeasurementPoint
WHERE canonicalUnit is missing
OR featureOfInterest is missing
OR sourceAddress is missing
```

---

# 12. 项目实施方法与治理机制

# 12.1 实施阶段

## 阶段 1：范围和能力问题

输出：

- 业务目标；
- 管理范围；
- 核心能力问题；
- 数据源清单；
- 角色和责任边界。

## 阶段 2：术语和概念治理

输出：

- 术语表；
- 中英文名称；
- 定义；
- 同义词；
- 外部标准映射；
- 废弃规则。

## 阶段 3：领域本体设计

输出：

- 类层次；
- 对象属性；
- 数据属性；
- 逆关系；
- 传递关系；
- 对称关系；
- 领域约束。

## 阶段 4：SHACL 和质量规则

输出：

- 必填规则；
- 类型规则；
- 数量规则；
- 条件规则；
- 质量评分；
- 冲突处理。

## 阶段 5：逻辑和物理数据库设计

输出：

- ER 模型；
- 表结构；
- 索引；
- 历史模型；
- 事务约束；
- 时序模型；
- 对象存储结构。

## 阶段 6：数据接入和映射

输出：

- IFC Mapping；
- Redfish Mapping；
- BACnet Mapping；
- SNMP Mapping；
- CMDB Mapping；
- 数据清洗和对齐规则。

## 阶段 7：验证和上线

输出：

- 能力问题验证；
- 性能测试；
- 数据质量报告；
- 推理准确性验证；
- 灰度上线方案；
- 运维手册。

# 12.2 治理角色

| 角色 | 责任 |
|---|---|
| Ontology Owner | 维护本体架构 |
| Domain Steward | 负责电力、制冷、网络等领域定义 |
| Data Owner | 确认权威来源 |
| Data Steward | 负责质量和冲突处理 |
| Integration Architect | 负责数据接入和映射 |
| Database Architect | 负责物理存储 |
| Product Owner | 负责业务能力和优先级 |
| Operations Team | 负责现场数据和验证 |

# 12.3 版本管理

每次本体发布应包含：

```text
ontologyVersion
releaseDate
changeLog
deprecatedTerms
replacementTerms
migrationRules
compatibilityNotes
```

---

# 13. 教学案例：从机柜到业务影响分析

## 13.1 场景

数据中心 DC01 中：

- Rack-A01 位于 DataHall-A；
- GPU-SRV-001 安装在 Rack-A01 的 20U～23U；
- PSU-1 接到 PDU-A；
- PSU-2 接到 PDU-B；
- PDU-A 由 UPS-A 供电；
- PDU-B 由 UPS-B 供电；
- GPU-SRV-001 承载 VM-001；
- VM-001 承载 Application-A；
- Application-A 支撑 Business-Service-A。

## 13.2 RDF 实例示例

```turtle
<urn:dcim:rack:A01>
    a loc:Rack ;
    loc:locatedIn <urn:dcim:room:DataHall-A> .

<urn:dcim:server:GPU-001>
    a asset:ManagedAsset, compute:ComputeDevice ;
    loc:installedIn <urn:dcim:rack:A01> ;
    asset:hasComponent
        <urn:dcim:psu:GPU-001-PSU1>,
        <urn:dcim:psu:GPU-001-PSU2> .

<urn:dcim:power-connection:001>
    a elec:PowerConnection ;
    dcim:fromEndpoint <urn:dcim:outlet:PDU-A-12> ;
    dcim:toEndpoint <urn:dcim:psu:GPU-001-PSU1> ;
    elec:feedRole elec:FeedA .

<urn:dcim:vm:VM-001>
    a biz:VirtualMachine ;
    biz:hostedOn <urn:dcim:server:GPU-001> .

<urn:dcim:application:APP-A>
    a biz:Application ;
    biz:dependsOn <urn:dcim:vm:VM-001> .

<urn:dcim:service:SERVICE-A>
    a biz:BusinessService ;
    biz:dependsOn <urn:dcim:application:APP-A> .
```

## 13.3 可实现的分析

- 查询设备位置；
- 验证 U 位是否冲突；
- 验证是否具备双路供电；
- 查询 A/B 路是否来自不同 UPS；
- UPS-A 故障影响分析；
- 查询业务服务的基础设施依赖；
- 查询来源和可信度；
- 查询历史时点拓扑。

## 13.4 合规规则示例

```text
规则：
生产服务器必须具有两条有效供电连接，
且 feedRole 分别为 A 和 B，
上游 UPS 不得相同。
```

该规则适合使用 SHACL-SPARQL 或规则引擎实现。

---

# 14. 常见误区与改进建议

## 误区 1：把 Ontology 当作分类字典

问题：

```text
只定义 Server、UPS、Rack
不定义关系、规则和来源
```

改进：

- 定义关系语义；
- 定义逆关系；
- 定义时间；
- 定义来源；
- 定义能力问题。

## 误区 2：所有对象只有一个类型

问题：

```text
device_type = SERVER
```

改进：

- 支持多重类型；
- 区分类、角色和状态；
- 区分产品型号和设备实例。

## 误区 3：所有关系都用 parent_id

问题：

```text
无法表达双路、旁路、网络、依赖
```

改进：

- 使用显式关系；
- 复杂关系实体化；
- 对不同拓扑建立专用模型。

## 误区 4：把所有属性放 JSONB

问题：

- 查询困难；
- 约束困难；
- 数据质量不可控；
- 索引复杂。

改进：

- 关键字段显式建列；
- 扩展属性才使用 JSONB/EAV；
- 属性必须关联 ontology term。

## 误区 5：把所有数据放入 RDF

问题：

- 高频写入成本高；
- 时序聚合不适合；
- 事务控制复杂。

改进：

- RDF 管语义；
- PostgreSQL 管事务；
- TSDB 管时序；
- 对象存储管文件。

## 误区 6：忽略历史时间

问题：

```text
只能知道现在，不知道故障发生时的拓扑
```

改进：

- 动态关系使用有效时间；
- 引入双时间模型；
- 所有变更可追溯。

## 误区 7：没有数据来源

问题：

```text
无法判断 Redfish、BIM、CMDB 谁更可信
```

改进：

- 使用 PROV-O 思想；
- 每条事实保留来源；
- 建立权威来源矩阵；
- 支持人工验证。

---

# 15. 实施检查表

## 15.1 Ontology 检查

- [ ] 是否定义了顶层概念？
- [ ] 是否进行了模块化拆分？
- [ ] 是否区分类、角色、状态和实例？
- [ ] 是否支持多重类型？
- [ ] 是否定义关系的逆关系？
- [ ] 是否识别传递关系和对称关系？
- [ ] 是否避免错误使用传递关系？
- [ ] 是否建立外部标准映射？
- [ ] 是否定义命名空间和版本？
- [ ] 是否定义废弃和替代机制？

## 15.2 数据模型检查

- [ ] 是否使用不可变 UUID？
- [ ] 是否为每个实体生成 IRI？
- [ ] 是否区分型号和实例？
- [ ] 是否区分空间关系和安装关系？
- [ ] 是否对复杂关系实体化？
- [ ] 是否保存 valid time？
- [ ] 是否保存 transaction time？
- [ ] 是否保存来源和可信度？
- [ ] 是否区分原始事实和推理事实？
- [ ] 是否支持历史查询？

## 15.3 数据库检查

- [ ] 唯一性是否由数据库保证？
- [ ] U 位冲突是否有排斥约束？
- [ ] 端口是否支持占用约束？
- [ ] 时序数据是否与主数据分离？
- [ ] 关键字段是否避免使用 EAV？
- [ ] JSONB 是否仅用于扩展属性？
- [ ] 是否有必要索引？
- [ ] 是否考虑分区和归档？
- [ ] 是否支持 CDC？
- [ ] 是否设计 Named Graph？

## 15.4 数据质量检查

- [ ] 机柜是否都有位置？
- [ ] 设备是否都有类型？
- [ ] 测点是否都有单位？
- [ ] 连接是否都有端点？
- [ ] 动态关系是否都有有效时间？
- [ ] 数据是否都有来源？
- [ ] 冲突是否有处理流程？
- [ ] 生产设备是否满足冗余规则？
- [ ] 推理结果是否可追溯？
- [ ] 质量报告是否可量化？

---

# 16. 术语表

| 术语 | 解释 |
|---|---|
| Ontology | 对领域概念和关系的形式化描述 |
| TBox | 类、属性和公理定义 |
| ABox | 具体实例和事实 |
| Class | 类别 |
| Individual | 实例对象 |
| Object Property | 对象之间的关系 |
| Datatype Property | 对象与数据值之间的关系 |
| OWL | Web Ontology Language |
| RDF | 资源描述框架 |
| SHACL | RDF 数据约束和验证语言 |
| IRI | 全局资源标识 |
| Canonical Model | 企业统一规范化数据模型 |
| Provenance | 数据来源和生成过程 |
| Valid Time | 事实真实生效时间 |
| Transaction Time | 事实录入系统时间 |
| Named Graph | RDF 中用于区分来源和用途的命名图 |
| SOSA/SSN | 传感器和观测本体 |
| QUDT | 单位和量纲本体 |
| PROV-O | 数据来源本体 |
| IFC | 建筑信息模型交换标准 |
| Redfish | IT 设备管理标准接口 |
| Brick | 建筑设备和测点语义模型 |
| Haystack | 楼宇设备和测点标签语义体系 |
| Competency Question | 用于验证本体能力的问题 |
| EAV | Entity-Attribute-Value 动态属性模型 |

---

# 17. 练习题与实践任务

## 17.1 理论题

1. 为什么 Ontology 不应直接替代关系数据库？
2. TBox 和 ABox 的区别是什么？
3. `contains` 和 `installedIn` 为什么不能合并？
4. 为什么 `physicallyConnectedTo` 不应定义为传递关系？
5. 为什么复杂连接关系需要实体化？
6. 开放世界假设与 DCIM 数据质量检查有什么冲突？
7. 为什么设备需要多个状态字段？
8. 为什么时序数据不适合全部写入 RDF？
9. IFC 和 Redfish 应分别承担什么角色？
10. 为什么必须保存数据来源和有效时间？

## 17.2 建模题

### 任务一：空间模型

设计：

```text
园区
→ 楼宇
→ 楼层
→ 机房
→ 行
→ 机柜
→ U 位
```

要求：

- 给出类；
- 给出关系；
- 标注传递关系；
- 标注逆关系；
- 给出 SHACL 约束。

### 任务二：双路供电

为一台双电源服务器设计：

- 服务器；
- 两个 PSU；
- 两个 PDU 插口；
- 两个 PDU；
- 两个 UPS；
- A/B 路关系；
- 有效时间；
- 连接来源。

### 任务三：业务影响分析

设计：

```text
UPS
→ PDU
→ Server
→ VM
→ Application
→ BusinessService
```

要求能够查询：

- UPS 故障影响哪些业务；
- 业务依赖哪些物理设备；
- 推理结果的来源和路径。

## 17.3 数据库实践

1. 创建 `entity`、`entity_type` 和 `relation_assertion` 表。
2. 插入一个机房、机柜、服务器和 UPS。
3. 建立安装关系。
4. 建立供电连接。
5. 增加有效时间。
6. 编写查询找出服务器上游 UPS。
7. 增加第二路电源并验证冗余。
8. 增加一个冲突来源并设计解决方法。

## 17.4 综合项目

构建一个小型 DCIM 知识模型，至少包含：

- 1 个数据中心；
- 2 个机房；
- 4 个机柜；
- 10 台服务器；
- 2 套 UPS；
- 2 套 PDU；
- 1 套制冷系统；
- 1 个 Kubernetes 集群；
- 2 个业务应用；
- 20 个监控点；
- 1 个 IFC 对象映射；
- 1 个 Redfish 数据映射；
- 5 条 SHACL 规则；
- 3 个影响分析查询。

---

# 总结

基于 Ontology 的 DCIM 数据模型，本质上是建立一套能够跨越建筑、设施、IT、监控和业务的统一语义体系。

最终推荐架构是：

```text
OWL Ontology
    +
SHACL 约束
    +
Canonical Data Model
    +
PostgreSQL
    +
RDF Knowledge Graph
    +
Time-Series Database
    +
Object Storage
```

最重要的十条原则：

1. Ontology 是语义权威，数据库是事务权威。
2. 一个对象可以有多个类型。
3. 类、角色、状态和实例必须分开。
4. 空间、安装、供电、制冷、网络和依赖关系必须分开。
5. 复杂关系必须实体化。
6. 动态关系必须有时间。
7. 关键事实必须有来源。
8. 主数据、时序、几何和文档必须分层存储。
9. 原始事实、确认事实和推理事实必须分离。
10. 所有设计必须能够回答明确的能力问题。

## 这套理论和方法能够回答的典型问题

1. 某台服务器当前位于哪个园区、楼宇、楼层、机房、机柜和 U 位？
2. 某个机柜在当前时刻是否有 U 位重叠、超高安装或空间冲突？
3. 某个机柜还剩余多少可用 U 位、可用功率和可用重量容量？
4. 某台服务器的 A 路和 B 路电源分别来自哪个 UPS、PDU 和插口？
5. 某个 UPS 故障会直接影响哪些机柜、服务器、虚拟机、应用和业务服务？
6. 某台服务器是否满足生产环境的双路供电和冗余隔离要求？
7. 某个设备的供电链路是否经过旁路、母联或切换设备？
8. 某个配线架端口当前连接了哪些设备端口，链路两端分别是什么角色？
9. 某条网络链路是否存在环路、单点故障或非预期跨域连接？
10. 某台设备的网络路径穿过了哪些交换机、配线架、跳线和逻辑网络？
11. 某个 CDU 或冷源故障会影响哪些机柜、冷板、GPU 节点和业务负载？
12. 某个区域的冷通道、热通道、CRAC 或 CRAH 是否满足设计送风和回风要求？
13. 某个测点是否缺少单位、采集地址、被测对象或有效的来源记录？
14. 某个传感器当前是否正常工作，其最近一次观测的质量等级如何？
15. 某个业务服务依赖哪些应用、虚拟机、物理服务器和基础设施组件？
16. 某次故障发生时，相关设备当时的安装位置、供电拓扑和业务依赖是什么？
17. 某个资产属性来自 IFC、Redfish、BMS、CMDB 还是人工录入，哪一条是权威来源？
18. 某个事实是否在指定时间段内有效，录入时间和真实生效时间分别是什么？
19. 某个设备当前的生命周期状态、运行状态、健康状态和管理状态是否一致？
20. 哪些生产设备不符合资产台账、双路供电、冗余配置或测点完整性规则？
21. 哪些机柜或房间的环境监控点覆盖不足，无法形成完整的温度、湿度和功耗视图？
22. 某个电量或功率指标的计算口径使用了哪些电表、边界和单位换算规则？
23. 某个对象是否同时具备多个语义类型，例如既是服务器又是 Redfish 管理对象和生产资源？
24. 某条关系在历史上是否发生过变更，变更前后分别连接了哪些对象？
25. 当多个来源对同一事实存在冲突时，当前采用了哪条断言，为什么？
