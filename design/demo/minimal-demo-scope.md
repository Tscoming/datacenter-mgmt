# 最小 Demo 范围

## 设计目标

基于 Ontology 的方法，从当前 DCIM mock 数据中抽象出一个可验证、可查询、可迁移到数据库的最小数据模型。Demo 的成功标准不是覆盖完整数据中心，而是能稳定回答一组核心能力问题。

## 范围内对象

| 领域 | Demo 对象 | 来源 |
|---|---|---|
| 空间 | `Datacenter`, `Cabinet`, `LayoutZone`, `LayoutFacility` | `datacenter.mock.ts`, `cabinet.mock.ts`, `layout.mock.ts` |
| 资产 | `DeviceTemplate`, `Device`, `PDU` | `deviceTemplate.mock.ts`, `device.mock.ts`, `pdu.mock.ts` |
| 安装 | 设备安装到机柜及 U 位区间 | `Device.cabinetId`, `startU`, `endU` |
| 网络 | `Port`, `Connection`, VLAN/QoS 配置 | `port.mock.ts`, `connection.mock.ts` |
| 电力 | `PowerNode`, `PowerLink`, A/B 路供电 | `powerTopology.mock.ts`, `pdu.mock.ts` |
| 观测 | 温湿度、功率、PUE、能耗 | `environment.mock.ts` |
| 告警 | `AlertRule`, `AlertDetail` | `alert.mock.ts` |

## 范围外对象

| 对象 | 暂不纳入原因 | 后续扩展方式 |
|---|---|---|
| 业务服务 | 当前 mock 没有服务与设备依赖数据 | 增加 `business_service`, `service_dependency` |
| 工单/变更 | 当前仅有操作记录文本，没有流程状态 | 增加 `work_order`, `change_record` |
| 制冷拓扑 | 当前只有环境指标，没有冷机/CRAC 连接 | 增加 `cooling_node`, `cooling_connection` |
| BIM/IFC 几何 | 当前布局为二维坐标 | 增加外部标识和几何引用表 |
| RDF 三元组存储 | Demo 优先落地关系库 | 后续增加 RDF 同步或图数据库投影 |

## 能力问题

最小 Demo 必须能回答：

1. 某台设备是什么型号、属于什么设备类别、安装在哪个数据中心的哪个机柜和 U 位？
2. 某个机柜当前 U 位和功率容量是否超限？
3. 某个端口连接到了哪个设备端口，连接类型和线缆类型是什么？
4. 某台设备是否具备 A/B 双路供电？
5. 某个 PDU 或 UPS 下游影响哪些设备？
6. 某个机柜最近的温度、湿度和功率观测值是多少？
7. 哪些告警来自规则触发，关联到哪个数据中心、机柜或设备？
8. 当前数据中哪些对象缺少关键关系，例如设备没有模板、端口没有设备、连线端口不存在？

## Demo 数据切片

建议首个 Demo 只使用 `dc-001` 北京亦庄数据中心的一组数据：

| 对象 | 选择 |
|---|---|
| 数据中心 | `dc-001` |
| 机柜 | `cab-bj-001`, `cab-bj-002`, `cab-bj-003` |
| 设备 | `dev-001` 到 `dev-008` |
| PDU | `pdu-001` 到 `pdu-004` |
| 连线 | `conn-001` 到 `conn-010` |
| 电力链路 | `link-001` 到 `link-013` |
| 告警 | `alert-001`, `alert-002`, `alert-004`, `alert-005` |

该切片足够覆盖空间、安装、网络、电力、观测和告警，不需要额外造数。
