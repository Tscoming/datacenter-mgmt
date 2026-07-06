# Datacenter Management

IDC 数据中心管理系统，采用前后端分离的 workspace 结构。`frontend` 提供管理控制台界面，`backend` 提供真实 HTTP API 服务，并覆盖原有 mock 接口能力。

## 项目结构

```text
.
├── backend/              # Express API 服务
│   ├── mock/             # mock 数据与数据库快照生成结果
│   ├── src/              # 后端启动、路由注册、数据源切换与数据库访问逻辑
│   ├── package.json
│   └── tsconfig.json
├── design/               # Ontology 设计、数据模型、迁移脚本与运行手册
├── frontend/             # 原 Ant Design Pro / Umi 前端项目
│   ├── config/           # Umi 配置与开发代理
│   ├── mock/             # 前端开发 mock 备份
│   ├── src/              # 页面、组件、状态、服务封装
│   ├── types/            # IDC 业务类型
│   └── package.json
├── package.json          # 根 workspace 脚本
└── pnpm-workspace.yaml
```

## 功能范围

前端包含以下 IDC 管理能力：

- 数据中心、机柜、设备、设备模板、端口、PDU 管理
- 数据中心布局、资源树、拓扑、电力拓扑
- 3D 数据中心、3D 机柜和设备可视化
- Dashboard、环境监控、告警中心
- 登录、权限、多语言和基础运维页面

后端提供与现有 mock 对齐的 API 服务，并支持按配置在 mock 数据和 PostgreSQL 数据库之间切换。当前 database 模式覆盖现有 mock API，无缺失路由，覆盖 `/api/idc/*`、`/api/pdu/*`、`/api/power/*`、登录、通知、规则等接口。

## 技术栈

- Frontend: React 19, Umi Max, Ant Design Pro, Ant Design, Zustand, Three.js
- Backend: Node.js, Express, TypeScript, ts-node, PostgreSQL
- Package workspace: npm workspaces + pnpm workspace

## 环境要求

- Node.js `>=20`
- pnpm 或 npm

首次安装依赖：

```bash
pnpm install
```

## 本地启动

同时启动前后端：

```bash
npm run dev
```

开发模式下，前端支持热更新，后端会监听 `backend/src` 和 `backend/mock` 的源码变化并自动重启。

分别启动：

```bash
npm run dev:backend
npm run dev:frontend
```

默认地址：

- 前端：`http://localhost:8000`
- 后端：`http://127.0.0.1:8008`
- 健康检查：`http://127.0.0.1:8008/health`

前端开发环境通过 [frontend/config/proxy.ts](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/frontend/config/proxy.ts) 将 `/api/` 代理到 `http://127.0.0.1:8008`。

## 后端数据源配置

后端支持两种数据源：

| 配置值 | 说明 |
|---|---|
| `API_DATA_SOURCE=mock` | 默认模式，使用 [backend/mock](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/mock) 中的 mock 模块 |
| `API_DATA_SOURCE=database` | 数据库模式，从 PostgreSQL 读取和写入数据 |

项目根目录提供：

- `.env.example`：配置模板，可提交到仓库。
- `.env`：当前本地环境配置，已加入 `.gitignore`，不应提交。

后端启动时会自动加载根目录 `.env` 和 `backend/.env`。真实 shell 环境变量优先级最高；如果同时存在根目录 `.env` 和 `backend/.env`，`backend/.env` 会覆盖根目录中的同名配置。

数据库连接配置：

| 环境变量 | 默认值 |
|---|---|
| `PGHOST` | `ubuntu.home.lab` |
| `PGPORT` | `5432` |
| `PGDATABASE` | `mydb` |
| `PGUSER` | `postgres` |
| `PGPASSWORD` | `password` |
| `PGSCHEMA` | `dcim_ontology_demo_20260623083835` |

以数据库模式启动后端：

```bash
npm run --workspace backend start
```

启动日志会输出当前数据源和数据库 schema，例如：

```text
API data source: database
Database: postgres@ubuntu.home.lab:5432/mydb schema=dcim_ontology_demo_20260623083835
```

## Ontology 数据模型与迁移

本项目已基于 `design/` 中的 Ontology 设计，将原始 mock 数据迁移到 PostgreSQL 独立 schema：

```text
dcim_ontology_demo_20260623083835
```

迁移后的核心表包括：

- 主数据：`datacenter`, `cabinet`, `device_template`, `device`, `pdu`, `port`
- 关系事实：`rack_installation`, `cable_connection`, `power_connection`
- 观测与告警：`observation`, `pue_daily`, `alert_rule`, `alert_event`
- Ontology 显式层：`ontology_individual`, `ontology_relationship`
- 快照与同步：`dashboard_snapshot`, `topology_snapshot`, `layout_snapshot`, `mock_raw_payload`, `api_mock_response`

迁移脚本与说明：

- [Design/data-model/migrate-mock-to-postgres.js](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/Design/data-model/migrate-mock-to-postgres.js)
- [Design/data-model/generated-mock-migration.sql](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/Design/data-model/generated-mock-migration.sql)
- [Design/data-model/migration-runbook.md](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/Design/data-model/migration-runbook.md)

重新生成迁移 SQL：

```bash
node Design/data-model/migrate-mock-to-postgres.js --schema=dcim_ontology_demo
```

执行远程迁移需要显式加 `--execute`：

```bash
node Design/data-model/migrate-mock-to-postgres.js --execute --schema=dcim_ontology_demo
```

默认会创建独立 schema；只有指定已存在的 schema 时，脚本才会重建该 schema 内的同名表。

## 常用命令

```bash
# 后端类型检查
npm run tsc --workspace backend

# 从当前 PostgreSQL schema 生成 mock 快照
npm run sync:mock --workspace backend

# 前端类型检查
npm run tsc --workspace frontend

# 前端测试
npm run test --workspace frontend

# 前后端构建
npm run build
```

## 后端 API 说明

后端入口为 [backend/src/server.ts](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/src/server.ts)，路由注册逻辑在 [backend/src/registerMockRoutes.ts](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/src/registerMockRoutes.ts)。

后端通过 [backend/src/mockRoutes.ts](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/src/mockRoutes.ts) 根据 `API_DATA_SOURCE` 加载路由：

- `mock` 模式：加载 [backend/mock](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/mock) 下的接口模块。
- `database` 模式：优先加载 [backend/src/databaseRoutes.ts](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/src/databaseRoutes.ts)，并保留 mock 模块作为兜底。

路由注册按静态路由优先、动态路由靠后的顺序注册 Express 路由，避免类似 `/api/idc/devices/stats` 被 `/api/idc/devices/:id` 提前匹配。

示例接口：

```bash
curl http://127.0.0.1:8008/health
curl http://127.0.0.1:8008/api/idc/datacenters/all
curl http://127.0.0.1:8008/api/idc/devices/stats
curl http://127.0.0.1:8008/api/pdu/templates
curl http://127.0.0.1:8008/api/db-sync/tables
```

## 数据库到 Mock 同步

后端提供数据库到 mock 的同步脚本：

```bash
npm run sync:mock --workspace backend
```

该命令会读取当前 PostgreSQL schema 中的表结构和数据，生成：

```text
backend/mock/generatedDbSnapshot.mock.ts
```

生成的 mock 快照提供：

- `GET /api/db-sync/tables`
- `GET /api/db-sync/tables/:table`

这些接口可用于查看数据库 schema 中的表清单和表数据快照。

## 开发约定

- 前端业务代码放在 `frontend/src`。
- 前端 API 调用封装放在 `frontend/src/services`。
- 后端服务代码放在 `backend/src`。
- 后端 mock 数据源位于 `backend/mock`。
- 后端数据库数据源位于 `backend/src/databaseRoutes.ts`，数据库访问层位于 `backend/src/db`。
- 新增业务 API 时，应同时考虑 mock 模式与 database 模式的数据返回一致性。
- 新增 API 时，优先在后端实现真实接口，再让前端 service 调用该接口。

## 当前注意事项

- mock 模式仍是内存数据服务，重启后新增、修改、删除的数据不会持久化。
- database 模式会写入 `PGSCHEMA` 指定的 PostgreSQL schema。
- `frontend/mock` 保留为前端原始 mock 备份；后端 mock API 以 `backend/mock` 为准。
- 前端测试依赖当前 workspace 的 Vite/Vitest 版本组合，若测试启动失败，优先检查 lockfile 和本地依赖解析。
