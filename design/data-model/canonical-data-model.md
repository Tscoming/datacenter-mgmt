# Canonical Data Model

## 模型原则

1. 主数据对象使用稳定主键：数据中心、机柜、设备模板、设备、端口、PDU。
2. 关系事实独立成表：安装、线缆连接、电力连接、观测、告警事件。
3. 统计字段不作为权威事实：容量、使用率、仪表盘指标优先由事实表计算。
4. 当前状态与历史事实分离：对象表保留当前快照，事实表保留 `valid_from`、`valid_to`。
5. 外部来源统一记录：每张核心表包含 `source_system`，关键事实包含 `confidence`。

## 实体表

| 表 | 说明 | 对应 mock |
|---|---|---|
| `datacenter` | 数据中心主数据 | `Datacenter` |
| `cabinet` | 机柜主数据 | `Cabinet` |
| `device_template` | 设备模板/型号 | `DeviceTemplate` |
| `port_group_template` | 端口组模板 | `PortGroup` |
| `device` | 设备资产实例 | `Device` |
| `pdu` | PDU 资产实例 | `pduDevices` |
| `port` | 设备端口 | `Port` |
| `power_node` | 电力拓扑节点 | `powerNodes` |
| `alert_rule` | 告警规则 | `AlertRule` |

## 事实表

| 表 | 说明 | 为什么实体化 |
|---|---|---|
| `rack_installation` | 设备/PDU 安装到机柜的 U 位事实 | 需要 U 位区间、历史、冲突检查 |
| `cable_connection` | 端口到端口的线缆事实 | 需要线缆编号、类型、长度、状态 |
| `power_connection` | 电力节点供电关系 | 需要 A/B 路、状态、负载分析 |
| `observation` | 温度、湿度、电力等观测值 | 需要时间序列和单位 |
| `pue_daily` | 数据中心日 PUE 指标 | 便于 Demo 查询和趋势展示 |
| `alert_event` | 告警事件 | 需要确认、恢复、关联对象 |

## 关键查询

### 设备完整画像

```sql
select
  d.id,
  d.name,
  d.asset_code,
  t.category,
  t.brand,
  t.model,
  dc.name as datacenter_name,
  c.name as cabinet_name,
  ri.start_u,
  ri.end_u,
  d.operational_status
from device d
join device_template t on t.id = d.template_id
left join rack_installation ri on ri.device_id = d.id and ri.valid_to is null
left join cabinet c on c.id = ri.cabinet_id
left join datacenter dc on dc.id = c.datacenter_id
where d.id = 'dev-003';
```

### 下游供电影响

```sql
with recursive downstream as (
  select source_node_id, target_node_id, target_node_type, power_path
  from power_connection
  where source_node_id = 'ups-001' and status = 'active'
  union all
  select pc.source_node_id, pc.target_node_id, pc.target_node_type, pc.power_path
  from power_connection pc
  join downstream d on pc.source_node_id = d.target_node_id
  where pc.status = 'active'
)
select *
from downstream
where target_node_type = 'device';
```

### 机柜最新环境摘要

```sql
select distinct on (target_id, metric)
  target_id as cabinet_id,
  metric,
  value_num,
  unit,
  observed_at
from observation
where target_type = 'cabinet'
  and target_id = 'cab-bj-001'
  and metric in ('temperature', 'humidity', 'active_power')
order by target_id, metric, observed_at desc;
```
