# Ubuntu 22.04 安装、配置与使用 Node-RED

本文说明如何在 Ubuntu 22.04 上安装 Node-RED，将其作为 `systemd` 服务运行，完成基础安全配置，并创建、验证和维护第一个 Flow。

## 1. 适用范围与约定

- 操作系统：Ubuntu 22.04 LTS（物理机或虚拟机均可）。
- 安装用户：使用普通用户登录，在需要系统权限的命令前使用 `sudo`；不要直接使用 `root` 用户安装。
- Node-RED 默认端口：`1880`。
- Node-RED 用户目录：`~/.node-red`，其中包含配置、Flow、凭据和已安装的扩展节点。
- 本文采用 Node-RED 官方提供的 Debian/Ubuntu 安装脚本。该脚本会安装或更新受支持的 Node.js、Node-RED，并创建 `systemd` 服务。

> Node-RED 编辑器默认没有登录保护。仅在本机访问时可以先完成安装再配置；如果需要从局域网或公网访问，必须先完成“安全配置”章节，不要直接将 `1880` 端口暴露到公网。

## 2. 安装前检查

确认系统版本和 CPU 架构：

```bash
cat /etc/os-release
uname -m
```

预期在 `/etc/os-release` 中看到：

```text
VERSION_ID="22.04"
```

更新软件包索引，并安装安装脚本及扩展节点常用的依赖：

```bash
sudo apt update
sudo apt install -y build-essential git curl
```

如果机器上已经通过 `apt`、`nvm` 或其他工具安装了 Node.js，先记录当前版本：

```bash
node --version 2>/dev/null || true
npm --version 2>/dev/null || true
```

官方脚本可能更新系统级 Node.js。若现有业务依赖特定 Node.js 版本，建议先使用独立虚拟机或容器验证，避免影响同机应用。

## 3. 安装 Node-RED

### 3.1 查看安装脚本帮助（可选）

```bash
bash <(curl -sL https://github.com/node-red/linux-installers/releases/latest/download/install-update-nodered-deb) --help
```

如果需要在执行前审查脚本，可先在浏览器打开其 [GitHub 发布地址](https://github.com/node-red/linux-installers/releases/latest/download/install-update-nodered-deb)，确认内容后再执行。

### 3.2 执行官方安装脚本

使用计划运行 Node-RED 的普通用户执行：

```bash
bash <(curl -sL https://github.com/node-red/linux-installers/releases/latest/download/install-update-nodered-deb)
```

根据提示确认安装。Ubuntu 服务器通常不需要安装 Raspberry Pi 专用节点。脚本会完成以下工作：

1. 检查并安装受支持的 Node.js 和 npm。
2. 安装或升级 Node-RED。
3. 创建 `nodered.service`。
4. 提供 `node-red-start`、`node-red-stop`、`node-red-restart` 和 `node-red-log` 等管理命令。

### 3.3 验证安装结果

```bash
node --version
npm --version
node-red --version
```

启动服务：

```bash
node-red-start
```

`node-red-start` 会启动后台服务并显示日志。按 `Ctrl+C` 只会退出日志查看，不会停止 Node-RED。

另开一个终端检查服务和端口：

```bash
systemctl status nodered.service --no-pager
ss -lnt | grep ':1880'
curl -I http://127.0.0.1:1880/
```

正常情况下，服务状态为 `active (running)`，并且 `1880` 端口正在监听。

设置开机自动启动：

```bash
sudo systemctl enable nodered.service
```

常用服务命令：

```bash
node-red-start
node-red-stop
node-red-restart
node-red-log
```

也可以直接使用 `systemctl`：

```bash
sudo systemctl start nodered.service
sudo systemctl stop nodered.service
sudo systemctl restart nodered.service
systemctl status nodered.service --no-pager
```

## 4. 访问编辑器

### 4.1 在服务器本机访问

打开浏览器访问：

```text
http://127.0.0.1:1880
```

### 4.2 通过 SSH 隧道安全访问（推荐）

如果 Ubuntu 是远程服务器，推荐保持 `1880` 端口不对外开放，并在客户端执行：

```bash
ssh -L 1880:127.0.0.1:1880 <ubuntu-user>@<server-ip>
```

SSH 会话保持连接时，在客户端浏览器打开：

```text
http://127.0.0.1:1880
```

### 4.3 允许局域网访问

查看服务器 IP：

```bash
hostname -I
```

如果启用了 UFW，只允许可信局域网网段访问。例如局域网为 `192.168.1.0/24`：

```bash
sudo ufw allow from 192.168.1.0/24 to any port 1880 proto tcp
sudo ufw status
```

然后在同一局域网内访问：

```text
http://<server-ip>:1880
```

不要使用 `sudo ufw allow 1880/tcp` 将编辑器开放给所有来源。需要公网访问时，应通过 VPN，或在 Node-RED 前配置带 HTTPS 的 Nginx/Caddy 反向代理。

## 5. 基础配置

### 5.1 确认实际配置文件

首次启动后，Node-RED 会创建用户目录和默认配置。查看启动日志：

```bash
node-red-log
```

日志中会列出类似内容：

```text
Settings file  : /home/<ubuntu-user>/.node-red/settings.js
User directory : /home/<ubuntu-user>/.node-red
Flows file     : /home/<ubuntu-user>/.node-red/flows.json
```

本文后续默认配置文件为：

```text
~/.node-red/settings.js
```

修改前先备份：

```bash
cp ~/.node-red/settings.js ~/.node-red/settings.js.bak
```

### 5.2 为编辑器启用用户名和密码

生成 bcrypt 密码哈希：

```bash
node-red admin hash-pw
```

按提示输入密码并复制输出的哈希值。编辑配置文件：

```bash
nano ~/.node-red/settings.js
```

找到已注释的 `adminAuth` 配置并启用，或在 `module.exports = { ... }` 内加入：

```javascript
adminAuth: {
    type: "credentials",
    users: [
        {
            username: "admin",
            password: "<粘贴 node-red admin hash-pw 输出的哈希值>",
            permissions: "*"
        }
    ]
},
```

注意：

- `password` 必须填写完整哈希，不能填写明文密码。
- `settings.js` 是 JavaScript 对象，每个相邻配置项之间必须有逗号。
- 不要同时保留两个生效的 `adminAuth` 配置。

检查配置文件语法并重启：

```bash
node --check ~/.node-red/settings.js
node-red-restart
node-red-log
```

再次打开编辑器，应出现登录页面。

### 5.3 设置 Flow 凭据加密密钥

Node-RED 会将节点中保存的密码、Token 等凭据写入 `flows_cred.json`。建议在首次保存任何凭据前设置固定密钥。

生成随机密钥：

```bash
openssl rand -base64 32
```

将输出妥善保存，并在 `settings.js` 的 `module.exports = { ... }` 中加入：

```javascript
credentialSecret: "<粘贴随机密钥>",
```

限制配置目录权限并重启：

```bash
chmod 700 ~/.node-red
chmod 600 ~/.node-red/settings.js
node --check ~/.node-red/settings.js
node-red-restart
```

> `credentialSecret` 丢失后，已有的加密凭据无法恢复。系统投入使用后不要随意修改该值；备份 Node-RED 数据时应同时安全备份该密钥。

### 5.4 可选：保护 HTTP In 节点提供的接口

`adminAuth` 只保护编辑器和管理 API，不会自动保护 Flow 中 `HTTP In` 节点创建的接口。若所有 HTTP Flow 可以共用一组 Basic Auth，可生成另一个密码哈希，并在 `settings.js` 中加入：

```javascript
httpNodeAuth: {
    user: "apiuser",
    pass: "<bcrypt 密码哈希>"
},
```

重启后使用以下方式请求：

```bash
curl -u apiuser:<明文密码> http://127.0.0.1:1880/health
```

如果不同接口需要不同的认证和授权策略，应在反向代理或 Flow 内单独实现，不要共享一个全局账号。

## 6. 创建并验证第一个 Flow

下面创建一个 `GET /health` 接口，用于验证 Node-RED 的编辑、部署和 HTTP 调用流程。

### 6.1 导入示例 Flow

1. 登录 Node-RED 编辑器。
2. 点击右上角菜单，选择 **Import**。
3. 将下面的 JSON 粘贴到导入窗口。
4. 选择 **new flow**，点击 **Import**。
5. 点击右上角 **Deploy** 部署。

```json
[
    {
        "id": "dcim-health-tab",
        "type": "tab",
        "label": "HTTP API 示例",
        "disabled": false,
        "info": ""
    },
    {
        "id": "dcim-health-in",
        "type": "http in",
        "z": "dcim-health-tab",
        "name": "GET /health",
        "url": "/health",
        "method": "get",
        "upload": false,
        "swaggerDoc": "",
        "x": 180,
        "y": 100,
        "wires": [["dcim-health-function"]]
    },
    {
        "id": "dcim-health-function",
        "type": "function",
        "z": "dcim-health-tab",
        "name": "构造响应",
        "func": "msg.headers = { \"content-type\": \"application/json\" };\nmsg.payload = { status: \"ok\", service: \"node-red\" };\nreturn msg;",
        "outputs": 1,
        "timeout": 0,
        "noerr": 0,
        "initialize": "",
        "finalize": "",
        "libs": [],
        "x": 400,
        "y": 100,
        "wires": [["dcim-health-response"]]
    },
    {
        "id": "dcim-health-response",
        "type": "http response",
        "z": "dcim-health-tab",
        "name": "返回 JSON",
        "statusCode": "",
        "headers": {},
        "x": 620,
        "y": 100,
        "wires": []
    }
]
```

### 6.2 调用接口

未配置 `httpNodeAuth` 时：

```bash
curl http://127.0.0.1:1880/health
```

预期响应：

```json
{"status":"ok","service":"node-red"}
```

如果配置了 `httpNodeAuth`：

```bash
curl -u apiuser:<明文密码> http://127.0.0.1:1880/health
```

### 6.3 理解基本操作

- 从左侧 Palette 拖入节点。
- 将前一个节点的输出端连接到后一个节点的输入端。
- 双击节点编辑属性。
- 点击 **Deploy** 后修改才会在运行时生效。
- 使用 `Inject` 节点手动或定时产生消息。
- 使用 `Debug` 节点在右侧 Debug 面板检查 `msg.payload` 或完整消息。
- Flow 出现问题时，可以先停止服务，再用安全模式启动，避免有问题的 Flow 自动运行：

```bash
node-red-stop
node-red --safe
```

修正并重新部署后，按 `Ctrl+C` 退出安全模式，再执行：

```bash
node-red-start
```

## 7. 安装扩展节点

### 7.1 使用编辑器安装

1. 打开右上角菜单。
2. 选择 **Manage palette**。
3. 打开 **Install** 页签。
4. 搜索扩展节点的完整 npm 包名，检查维护状态和文档后再安装。

不要安装来源不明或长期无人维护的节点。扩展节点会在 Node-RED 进程中执行代码，具有与 Node-RED 服务用户相同的权限。

### 7.2 使用命令行安装

必须使用运行 Node-RED 的同一个普通用户执行，并在用户目录中安装：

```bash
node-red-stop
cd ~/.node-red
npm install <node-module-name>
node-red-start
```

安装后查看日志，确认没有模块加载错误：

```bash
node-red-log
```

`npm install` 会更新 `~/.node-red/package.json`，便于备份后恢复依赖。不要在这里使用 `sudo npm install`，否则容易产生 root 所有的文件，导致服务无法读写。

## 8. Flow 导入、导出与备份

### 8.1 从编辑器导出

1. 选择要导出的节点或 Flow。
2. 打开右上角菜单，选择 **Export**。
3. 选择导出范围和 **formatted** JSON。
4. 将 JSON 保存到版本库中。

导出的 Flow JSON 通常不包含节点凭据。迁移时还需要处理 `flows_cred.json` 和对应的 `credentialSecret`。

### 8.2 备份用户目录

停止服务以获得一致的备份：

```bash
node-red-stop
tar -czf "node-red-backup-$(date +%F-%H%M%S).tar.gz" -C "$HOME" .node-red
chmod 600 node-red-backup-*.tar.gz
node-red-start
```

备份文件可能包含账号、Flow 凭据和密钥，必须按敏感文件保管，不要提交到 Git。

主要文件包括：

| 文件 | 用途 |
| --- | --- |
| `~/.node-red/settings.js` | Node-RED 运行配置和安全设置 |
| `~/.node-red/flows.json` | Flow 定义；实际名称以启动日志为准 |
| `~/.node-red/flows_cred.json` | 加密后的节点凭据 |
| `~/.node-red/package.json` | 已安装扩展节点依赖 |
| `~/.node-red/lib/` | 本地 Flow/Function 库 |

恢复到新机器时，应先安装 Node-RED、停止服务，再恢复 `.node-red` 目录，确认目录属于运行服务的用户，最后启动并检查日志。

## 9. 升级

升级前先按上一节备份 `~/.node-red`，并记录版本：

```bash
node-red --version
node --version
```

重新执行官方安装脚本即可升级：

```bash
bash <(curl -sL https://github.com/node-red/linux-installers/releases/latest/download/install-update-nodered-deb)
```

升级完成后验证：

```bash
node-red --version
node-red-restart
node-red-log
curl http://127.0.0.1:1880/health
```

生产环境升级前，应先阅读 Node-RED 和关键扩展节点的发布说明，并在测试环境验证现有 Flow。

## 10. 常见问题排查

### 10.1 无法打开编辑器

依次检查：

```bash
systemctl status nodered.service --no-pager
node-red-log
ss -lnt | grep ':1880'
curl -I http://127.0.0.1:1880/
sudo ufw status
```

- 本机 `curl` 成功、远程浏览器失败：通常是防火墙、安全组、路由或访问地址问题。
- 服务未启动：优先查看 `node-red-log` 中的第一条错误。
- 修改 `settings.js` 后无法启动：运行 `node --check ~/.node-red/settings.js` 检查语法。

### 10.2 服务写文件时报 `EACCES`

检查用户目录所有者：

```bash
ls -ld ~/.node-red
find ~/.node-red -maxdepth 2 ! -user "$USER" -ls
```

常见原因是在 `~/.node-red` 中使用过 `sudo npm install`。确认当前登录用户就是 Node-RED 服务运行用户后，再修复所有者：

```bash
sudo chown -R "$USER":"$USER" ~/.node-red
node-red-restart
```

### 10.3 扩展节点安装失败

```bash
cd ~/.node-red
npm --version
npm install <node-module-name> --verbose
```

检查错误中是否包含：

- 缺少编译工具：确认已安装 `build-essential`。
- Node.js 版本不兼容：查看扩展节点文档支持范围。
- 网络或 npm registry 错误：检查 DNS、代理和 registry 配置。
- 原生模块编译失败：查看该扩展节点是否支持当前 CPU 架构和 Node.js 主版本。

### 10.4 错误 Flow 导致启动异常

先停止服务，再以安全模式启动：

```bash
node-red-stop
node-red --safe
```

安全模式会加载编辑器但不启动 Flow。修正问题并部署后退出前台进程，再恢复服务启动。

## 11. 安全检查清单

- 已为编辑器配置 `adminAuth`，并使用强密码。
- 已设置并安全备份固定的 `credentialSecret`。
- `1880` 端口只允许本机、VPN 或可信局域网访问。
- 公网访问使用 HTTPS 反向代理，不直接暴露 Node-RED。
- Node-RED 使用普通用户运行，不使用 `root`。
- 不在 Function 节点或 Flow JSON 中硬编码密码和 Token。
- 只安装可信、持续维护的扩展节点。
- 定期备份 `~/.node-red`，并对备份文件实施访问控制。
- 升级前在测试环境验证 Flow 和扩展节点兼容性。

## 12. 官方参考资料

- [Node-RED：在 Debian/Ubuntu 上安装](https://nodered.org/docs/getting-started/raspberrypi)
- [Node-RED：本地安装和命令行参数](https://nodered.org/docs/getting-started/local)
- [Node-RED：配置文件](https://nodered.org/docs/user-guide/runtime/settings-file)
- [Node-RED：运行时配置项](https://nodered.org/docs/user-guide/runtime/configuration)
- [Node-RED：安全配置](https://nodered.org/docs/user-guide/runtime/securing-node-red)
- [Node-RED：Palette Manager](https://nodered.org/docs/user-guide/editor/palette/manager)
