# Mock 到 PostgreSQL 迁移运行手册

## 目标

将 `backend/mock` 中的当前 mock 数据迁移到 PostgreSQL，并按 Ontology 概念落地为：

- 主数据表：`datacenter`, `cabinet`, `device_template`, `device`, `pdu`, `port`
- 关系事实表：`rack_installation`, `cable_connection`, `power_connection`
- 观测与告警表：`observation`, `pue_daily`, `alert_rule`, `alert_event`
- Ontology 显式层：`ontology_individual`, `ontology_relationship`
- mock 补充快照：`layout_*`, `dashboard_snapshot`, `topology_snapshot`, `operation_record`, `mock_raw_payload`

## 执行脚本

脚本位置：

```bash
node Design/data-model/migrate-mock-to-postgres.js
```

默认只生成 SQL，不连接数据库：

```bash
node Design/data-model/migrate-mock-to-postgres.js
```

实际执行迁移需要显式传入：

```bash
node Design/data-model/migrate-mock-to-postgres.js --execute
```

默认会创建一个带时间戳的独立 schema，例如：

```text
dcim_ontology_demo_20260623153000
```

也可以指定固定 schema：

```bash
node Design/data-model/migrate-mock-to-postgres.js --execute --schema=dcim_ontology_demo
```

默认连接参数来自用户提供的信息：

```text
Host: ubuntu.home.lab
Port: 5432
Database: mydb
Username: postgres
Password: password
```

也可以用环境变量覆盖：

```bash
PGHOST=ubuntu.home.lab \
PGPORT=5432 \
PGDATABASE=mydb \
PGUSER=postgres \
PGPASSWORD=password \
node Design/data-model/migrate-mock-to-postgres.js --execute --schema=dcim_ontology_demo
```

## 重要风险

脚本会先 `create schema if not exists ...`，再 `set search_path` 到目标 schema，并重建本设计定义的目标表：

```text
datacenter, cabinet, device_template, port_group_template, device, pdu,
rack_installation, port, cable_connection, power_node, power_connection,
observation, pue_daily, alert_rule, alert_event, ontology_individual,
ontology_relationship, layout_*, dashboard_snapshot, operation_record,
topology_snapshot, mock_raw_payload
```

这些表会在目标 schema 内先 `drop table if exists ... cascade`，再按最新 schema 创建和导入。

默认时间戳 schema 不会覆盖已有 `public` 表。只有在你显式指定了一个已经存在的 schema 时，该 schema 内的同名表会被重建。

## 验证

`--execute` 成功后，脚本会自动验证：

1. 关键表行数与 mock 抽取结果一致。
2. 设备都能关联到设备模板。
3. 线缆连接的两端端口都存在。
4. 安装事实都能关联到机柜。
5. 电力连接的两端节点都存在。
6. 每台设备都有 `installedIn` Ontology 关系。

失败时脚本会退出非 0，并打印失败项。
