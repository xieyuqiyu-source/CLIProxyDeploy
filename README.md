# CLIProxyDeploy

`CLIProxyDeploy` 是 `CLIProxy` 系列项目的聚合部署仓库，用来解决以下问题：

- 代码仓库分散：`CLIProxyApi`、`CLIProxyManagement`、`CLIProxyApp`、`CLIProxyCloud` 分开维护
- 部署麻烦：每次都要分别拉取、构建、同步
- 环境不一致：本地、Windows、Linux 服务器容易出现目录结构不统一

这个仓库不承载业务代码，而是承载：

- 仓库清单
- 一键拉取 / 更新脚本
- 服务端部署脚本
- Windows 构建脚本
- 运维说明

## 目录结构

建议最终工作区保持如下结构：

```text
CLIProxy/
├── CLIProxyApi
├── CLIProxyApp
├── CLIProxyCloud
├── CLIProxyDeploy
└── CLIProxyManagement
```

其中：

- `CLIProxyApi`：代理核心后端
- `CLIProxyManagement`：官方管理界面
- `CLIProxyApp`：桌面客户端
- `CLIProxyCloud`：账号、会员、支付、云同步后端
- `CLIProxyDeploy`：统一拉取、构建、部署控制台

## 仓库清单

当前使用的仓库如下：

- 官方后端：<https://github.com/router-for-me/CLIProxyAPI>
- 官方管理界面：<https://github.com/router-for-me/Cli-Proxy-API-Management-Center>
- 你的客户端：<https://github.com/xieyuqiyu-source/CLIProxyApp>
- 你的云后端：<https://github.com/xieyuqiyu-source/CLIProxyCloud>

## 快速开始

### 1. 初始化工作区

在 `CLIProxyDeploy` 所在目录执行：

```bash
./scripts/bootstrap.sh
```

这个脚本会在 `CLIProxyDeploy` 的上一级目录中补齐所有缺失仓库。

### 2. 更新所有仓库

```bash
./scripts/update.sh
```

这个脚本会：

- 拉取所有仓库
- 输出当前提交号
- 统一检查状态

### 3. 查看当前仓库状态

```bash
./scripts/status.sh
```

会显示每个仓库：

- 当前分支
- 当前提交
- 是否有未提交改动

## Windows 构建

Windows 机器建议也保持同样结构：

```text
C:\Users\<你>\Documents\Work\CLIProxy\
├── CLIProxyApi
├── CLIProxyApp
├── CLIProxyCloud
├── CLIProxyDeploy
└── CLIProxyManagement
```

Windows 构建脚本：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\build-app.ps1
```

默认行为：

- 构建 `CLIProxyManagement`
- 构建 `CLIProxyApp`
- 输出 Windows 安装包路径

前提依赖：

- Visual Studio 2022 Build Tools
- Rust stable `x86_64-pc-windows-msvc`
- Go
- Node.js

## Linux 服务器部署

当前服务器信息：

- 域名：`cliproxy.szxsai.com`
- 反代入口：`https://cliproxy.szxsai.com`
- 服务：`cliproxycloud.service`
- 部署目录：`/var/www/CLIProxyCloud`

使用部署脚本：

```bash
./scripts/deploy-cloud-server.sh
```

该脚本默认会：

- 将本地 `CLIProxyCloud` 同步到远端
- 不覆盖远端 `.env`
- 编译远端二进制
- 重启 `cliproxycloud.service`
- 检查健康状态

## 当前建议流程

### 本地开发

1. 在 `CLIProxyApp` 或 `CLIProxyCloud` 中改代码
2. 分别提交到各自仓库
3. 回到 `CLIProxyDeploy` 使用脚本统一同步环境

### Windows 打包

1. 先执行 `bootstrap.sh` 或手工保证目录结构一致
2. 在 Windows 中运行 `build-app.ps1`
3. 在 `CLIProxyApp/src-tauri/target/release/bundle/` 下取产物

### 云端部署

1. 提交 `CLIProxyCloud`
2. 在 `CLIProxyDeploy` 中运行 `deploy-cloud-server.sh`
3. 验证 `https://cliproxy.szxsai.com/healthz`

## 设计原则

为什么不把所有代码硬合并成一个仓库：

- 业务职责不同
- 发布节奏不同
- 官方仓库要持续跟上游更新
- 客户端和云后端需要独立提交与发布

为什么要新增 `CLIProxyDeploy`：

- 保留独立开发仓库的好处
- 同时解决部署和运维聚合的问题

## 后续可继续补的内容

- Docker Compose 一键拉起开发环境
- Server 端一键初始化脚本
- 自动生成版本发布清单
- Windows 远程构建脚本
- macOS / Windows / Linux 的统一发布流程

