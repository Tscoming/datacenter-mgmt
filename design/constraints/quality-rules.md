# 数据质量与约束规则

## 约束分层

| 层级 | 职责 | 示例 |
|---|---|---|
| 数据库约束 | 保证主外键、唯一性、枚举、范围 | 机柜 U 高度必须大于 0 |
| 业务校验 | 保证跨表业务一致性 | 设备上架 U 位不能重叠 |
| Ontology/SHACL | 保证语义完整性 | `Device` 必须有 `ProductModel` |
| 派生检查 | 周期性发现风险 | 单路供电、容量超限 |

## 必要数据库约束

1. `datacenter.code` 唯一。
2. 同一数据中心内 `cabinet.code` 唯一。
3. `device.asset_code` 唯一。
4. `device.template_id` 必须引用存在的 `device_template.id`。
5. `rack_installation.cabinet_id` 必须引用存在的 `cabinet.id`。
6. `rack_installation.start_u >= 1`，`end_u >= start_u`，`end_u <= cabinet.u_height`。
7. 同一机柜内有效安装事实的 U 位区间不能重叠。
8. 同一设备同一时间只能有一个有效安装位置。
9. `port.device_id` 必须引用存在的 `device.id`。
10. `cable_connection.source_port_id` 与 `target_port_id` 必须引用存在的端口，且不能相同。
11. 有效 `cable_connection` 中同一个端口不能同时出现在多条 active 物理连接中。
12. `power_connection.source_node_id` 与 `target_node_id` 不能相同。

## Ontology/SHACL 风格规则

```text
Device
- 必须有 exactly 1 assetCode
- 必须有 exactly 1 hasProductModel
- 如果 isMounted=true，则必须有 exactly 1 active RackInstallation

Cabinet
- 必须 locatedIn exactly 1 Datacenter
- uHeight 必须为正整数
- maxPower 必须为非负数

CableConnection
- 必须有 exactly 1 sourcePort
- 必须有 exactly 1 targetPort
- sourcePort != targetPort
- connectionType 必须属于 network/power/management/storage/stack

PowerConnection
- powerPath 必须属于 A/B/unknown
- status=active 时 source 与 target 必须在同一 datacenter 范围内
```

## Demo 级质量检查 SQL

```sql
-- 设备缺少模板
select d.id, d.name, d.template_id
from device d
left join device_template t on t.id = d.template_id
where t.id is null;

-- 同一机柜 U 位重叠
select a.cabinet_id, a.device_id as device_a, b.device_id as device_b
from rack_installation a
join rack_installation b
  on a.cabinet_id = b.cabinet_id
 and a.id < b.id
 and coalesce(a.valid_to, 'infinity') > b.valid_from
 and coalesce(b.valid_to, 'infinity') > a.valid_from
 and int4range(a.start_u, a.end_u + 1, '[)') && int4range(b.start_u, b.end_u + 1, '[)');

-- 单路供电设备
select target_node_id as device_id, count(distinct power_path) as path_count
from power_connection
where status = 'active' and target_node_type = 'device'
group by target_node_id
having count(distinct power_path) < 2;

-- active 连线引用不存在的端口
select c.id, c.source_port_id, c.target_port_id
from cable_connection c
left join port sp on sp.id = c.source_port_id
left join port tp on tp.id = c.target_port_id
where c.status = 'active'
  and (sp.id is null or tp.id is null);
```

## 告警规则校验

| 规则类型 | 必填指标 | 单位 | 推荐校验 |
|---|---|---|---|
| `temperature` | `temperature` | Celsius | 阈值范围 `0-60` |
| `humidity` | `humidity` | Percent | 阈值范围 `0-100` |
| `power` | `power_usage_percent` | Percent | 阈值范围 `0-100` |
| `device_status` | `device_status` | Enum 编码 | 只允许离线/异常编码 |
| `port_status` | `port_usage_percent` | Percent | 阈值范围 `0-100` |
| `capacity` | `u_usage_percent` | Percent | 阈值范围 `0-100` |
