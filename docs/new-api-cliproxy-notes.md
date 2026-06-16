# New API + CLIProxyApi 临时备忘

更新时间：2026-06-16 Asia/Shanghai

这是一份临时的私有部署备忘。New API 渠道配置稳定后，可以删除这份文件。

## 服务器信息

- SSH 别名：`tencent`
- 公网 IP：`124.223.111.163`
- New API 外网入口：`http://124.223.111.163/`
- New API 初始化页面：`http://124.223.111.163/setup`
- New API 服务目录：`/opt/new-api`
- New API 容器名：`new-api`
- Redis 容器名：`new-api-redis`
- New API 在宿主机上的本地端口：`3008`

## New API 对接 CLIProxyApi 的渠道配置

在 New API 里添加 CLIProxyApi 渠道时使用：

```json
{
  "base_url": "http://cliproxyapi.local/v1",
  "type": 1,
  "key": "mMt12XOUsERCXcspFslU8Rg6AesLvQ2e"
}
```

注意：

- 不要在 New API 里填 `http://127.0.0.1:8317`。New API 运行在 Docker 容器里，容器里的 `127.0.0.1` 指的是容器自己，不是宿主机。
- `cliproxyapi.local` 已在 `/opt/new-api/docker-compose.yml` 里映射到 Docker 宿主机网关。
- Nginx 内部暴露了 `cliproxyapi.local`，并代理到宿主机上的 `127.0.0.1:8317`。

已在 New API 容器内验证：

```text
http://cliproxyapi.local/v1/models
```

返回 `200 OK`。

## CLIProxyApi 信息

- 宿主机监听地址：`127.0.0.1:8317`
- 公开管理接口：`https://cliproxy.szxsai.com/v0/management`
- 管理端页面：`https://cliproxy.szxsai.com/cpm/`
- 配置文件：`/etc/cliproxyapi/config.yaml`
- 二进制路径：`/var/www/CLIProxyApi/cliproxyapi`
- systemd 服务：`cliproxyapi.service`
- API Key：`mMt12XOUsERCXcspFslU8Rg6AesLvQ2e`
- Manager 管理密钥：`xuanshu.1`

## 代理信息

服务器本地代理：

```text
http://127.0.0.1:7890
```

代理服务：

```text
mihomo-ai.service
```

当前代理节点：

```text
SG-01
```

已观测到的代理出口：

```text
188.253.120.98
Singapore / Akari Networks
```

`CLIProxyApi` 当前配置中包含：

```yaml
proxy-url: "http://127.0.0.1:7890"
```

Docker 也配置了守护进程级别的镜像拉取代理：

```text
/etc/systemd/system/docker.service.d/http-proxy.conf
```

## 常用检查命令

```bash
ssh tencent 'cd /opt/new-api && docker compose ps'
ssh tencent 'systemctl status cliproxyapi --no-pager'
ssh tencent 'curl -sS -I http://127.0.0.1:3008'
ssh tencent 'curl -sS -H "Authorization: Bearer mMt12XOUsERCXcspFslU8Rg6AesLvQ2e" http://127.0.0.1:8317/v1/models'
ssh tencent 'docker exec new-api wget -S -O- --header="Authorization: Bearer mMt12XOUsERCXcspFslU8Rg6AesLvQ2e" http://cliproxyapi.local/v1/models'
```
