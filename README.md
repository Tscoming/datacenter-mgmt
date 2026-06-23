# Datacenter Management

IDC 数据中心管理系统，采用前后端分离的 workspace 结构。`frontend` 提供管理控制台界面，`backend` 提供真实 HTTP API 服务，并覆盖原有 mock 接口能力。

## 项目结构

```text
.
├── backend/              # Express API 服务
│   ├── mock/             # 从原 mock 迁移出的后端接口实现
│   ├── src/              # 后端启动、路由注册与适配逻辑
│   ├── package.json
│   └── tsconfig.json
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

后端提供与现有 mock 对齐的 API 服务，当前注册 `102` 个路由，覆盖 `/api/idc/*`、`/api/pdu/*`、`/api/power/*`、登录、通知、规则等接口。

## 技术栈

- Frontend: React 19, Umi Max, Ant Design Pro, Ant Design, Zustand, Three.js
- Backend: Node.js, Express, TypeScript, ts-node
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

- 前端：`http://localhost:8002`
- 后端：`http://127.0.0.1:8008`
- 健康检查：`http://127.0.0.1:8008/health`

前端开发环境通过 [frontend/config/proxy.ts](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/frontend/config/proxy.ts) 将 `/api/` 代理到 `http://127.0.0.1:8008`。

## 常用命令

```bash
# 后端类型检查
npm run tsc --workspace backend

# 前端类型检查
npm run tsc --workspace frontend

# 前端测试
npm run test --workspace frontend

# 前后端构建
npm run build
```

## 后端 API 说明

后端入口为 [backend/src/server.ts](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/src/server.ts)，路由注册逻辑在 [backend/src/registerMockRoutes.ts](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/src/registerMockRoutes.ts)。

后端会加载 [backend/mock](/Volumes/MacMiniM4-Data/workspaces/datacenter-mgmt/backend/mock) 下的接口模块，并按静态路由优先、动态路由靠后的顺序注册 Express 路由，避免类似 `/api/idc/devices/stats` 被 `/api/idc/devices/:id` 提前匹配。

示例接口：

```bash
curl http://127.0.0.1:8008/health
curl http://127.0.0.1:8008/api/idc/datacenters/all
curl http://127.0.0.1:8008/api/idc/devices/stats
curl http://127.0.0.1:8008/api/pdu/templates
```

## 开发约定

- 前端业务代码放在 `frontend/src`。
- 前端 API 调用封装放在 `frontend/src/services`。
- 后端服务代码放在 `backend/src`。
- 后端当前数据源位于 `backend/mock`，后续接入数据库时应逐步替换这里的内存数据实现。
- 新增 API 时，优先在后端实现真实接口，再让前端 service 调用该接口。

## 当前注意事项

- 后端当前是内存数据服务，重启后新增、修改、删除的数据不会持久化。
- `frontend/mock` 保留为前端原始 mock 备份；真实 API 服务以 `backend/mock` 为准。
- 前端测试依赖当前 workspace 的 Vite/Vitest 版本组合，若测试启动失败，优先检查 lockfile 和本地依赖解析。
