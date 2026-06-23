# DCIM Ontology 最小 Demo 设计

本目录承接 `design/` 中已有的 DCIM Ontology 教学材料，并结合 `backend/mock` 与 `frontend/types/idc.d.ts` 中的现有数据契约，输出一个可以落地到实际数据模型的最小 Demo 设计。

> 注意：当前文件系统上 `Design` 与已有 `design` 是同一目录的大小写别名。因此本次新增内容放在该目录下的新子目录中，没有移动原有教学材料。

## 目录规划

| 子目录 | 职责 | 主要文件 |
|---|---|---|
| `demo/` | 定义最小 Demo 的业务边界、能力问题和交付范围 | `minimal-demo-scope.md` |
| `ontology/` | 定义 Demo 采用的本体模块、类、关系和状态语义 | `dcim-ontology-model.md` |
| `mapping/` | 将后端 mock 数据字段映射到 Ontology 概念和事实 | `mock-data-mapping.md` |
| `constraints/` | 定义数据质量规则、关系约束和校验策略 | `quality-rules.md` |
| `data-model/` | 落地为 Canonical Data Model 与 PostgreSQL 表结构 | `canonical-data-model.md`, `postgresql-schema.sql` |

## 最小化原则

1. 只覆盖当前 mock 已经具备的数据：数据中心、机柜、设备模板、设备、端口、连线、PDU、电力拓扑、环境观测、告警。
2. 不引入当前数据中不存在的复杂域：业务服务、工单、制冷水系统、BIM 几何、租户、SLA。
3. 不把 Ontology 做成运行时依赖；Demo 先使用关系数据库承载事实，通过字段、关系表和约束体现语义。
4. 对复杂关系实体化：安装、端口连线、电力供给、观测值、告警触发都建成独立事实表。
5. 保留后续演进入口：`valid_from`、`valid_to`、`source_system`、`confidence` 等字段用于来源、历史和可信度。

## 推荐阅读顺序

1. `demo/minimal-demo-scope.md`
2. `ontology/dcim-ontology-model.md`
3. `mapping/mock-data-mapping.md`
4. `constraints/quality-rules.md`
5. `data-model/canonical-data-model.md`
6. `data-model/postgresql-schema.sql`
