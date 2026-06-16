# New API + CLIProxyApi Temporary Notes

Last updated: 2026-06-16 Asia/Shanghai

This file is a temporary private deployment note. Delete it after the New API
channel configuration is no longer needed.

## Server

- SSH alias: `tencent`
- Public IP: `124.223.111.163`
- New API public entry: `http://124.223.111.163/`
- New API setup page: `http://124.223.111.163/setup`
- New API server path: `/opt/new-api`
- New API container: `new-api`
- Redis container: `new-api-redis`
- New API local port on host: `3008`

## New API Channel For CLIProxyApi

Use this channel configuration in New API:

```json
{
  "base_url": "http://cliproxyapi.local/v1",
  "type": 1,
  "key": "mMt12XOUsERCXcspFslU8Rg6AesLvQ2e"
}
```

Notes:

- Do not use `http://127.0.0.1:8317` inside New API. New API runs in Docker,
  so `127.0.0.1` points to the container itself.
- `cliproxyapi.local` is mapped in `/opt/new-api/docker-compose.yml` to the
  Docker host gateway.
- Nginx exposes `cliproxyapi.local` internally and proxies to
  `127.0.0.1:8317`.

Verified from inside the New API container:

```text
http://cliproxyapi.local/v1/models
```

returns `200 OK`.

## CLIProxyApi

- Host listen address: `127.0.0.1:8317`
- Public management URL: `https://cliproxy.szxsai.com/v0/management`
- Management UI: `https://cliproxy.szxsai.com/cpm/`
- Config file: `/etc/cliproxyapi/config.yaml`
- Binary path: `/var/www/CLIProxyApi/cliproxyapi`
- systemd service: `cliproxyapi.service`
- API key: `mMt12XOUsERCXcspFslU8Rg6AesLvQ2e`
- Manager key: `xuanshu.1`

## Proxy

Server local proxy:

```text
http://127.0.0.1:7890
```

Service:

```text
mihomo-ai.service
```

Current proxy node:

```text
SG-01
```

Observed proxy egress:

```text
188.253.120.98
Singapore / Akari Networks
```

`CLIProxyApi` config currently has:

```yaml
proxy-url: "http://127.0.0.1:7890"
```

Docker also has a daemon-level pull proxy configured at:

```text
/etc/systemd/system/docker.service.d/http-proxy.conf
```

## Useful Checks

```bash
ssh tencent 'cd /opt/new-api && docker compose ps'
ssh tencent 'systemctl status cliproxyapi --no-pager'
ssh tencent 'curl -sS -I http://127.0.0.1:3008'
ssh tencent 'curl -sS -H "Authorization: Bearer mMt12XOUsERCXcspFslU8Rg6AesLvQ2e" http://127.0.0.1:8317/v1/models'
ssh tencent 'docker exec new-api wget -S -O- --header="Authorization: Bearer mMt12XOUsERCXcspFslU8Rg6AesLvQ2e" http://cliproxyapi.local/v1/models'
```
