#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
CLOUD_DIR="$ROOT_DIR/CLIProxyCloud"

SERVER_HOST="${SERVER_HOST:-124.223.111.163}"
SERVER_USER="${SERVER_USER:-ubuntu}"
SERVER_PASSWORD="${SERVER_PASSWORD:-xuanshu.1}"
SERVER_TARGET_DIR="${SERVER_TARGET_DIR:-/var/www/CLIProxyCloud}"
SERVER_SERVICE="${SERVER_SERVICE:-cliproxycloud.service}"
HEALTH_URL="${HEALTH_URL:-https://cliproxy.szxsai.com/healthz}"

if [[ ! -d "$CLOUD_DIR" ]]; then
  echo "CLIProxyCloud directory not found: $CLOUD_DIR" >&2
  exit 1
fi

if ! command -v sshpass >/dev/null 2>&1; then
  echo "sshpass is required." >&2
  exit 1
fi

echo "[sync] $CLOUD_DIR -> $SERVER_USER@$SERVER_HOST:$SERVER_TARGET_DIR"
sshpass -p "$SERVER_PASSWORD" rsync -az \
  -e "ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10" \
  --exclude '.git' \
  --exclude '.env' \
  --exclude 'storage' \
  --exclude 'certs' \
  "$CLOUD_DIR/" \
  "$SERVER_USER@$SERVER_HOST:$SERVER_TARGET_DIR/"

echo "[build] remote binary"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 \
  "$SERVER_USER@$SERVER_HOST" \
  "cd $SERVER_TARGET_DIR && go build -o cliproxy-cloud ./cmd/server && sudo systemctl restart $SERVER_SERVICE && sudo systemctl is-active $SERVER_SERVICE"

echo "[health] $HEALTH_URL"
curl -fsS "$HEALTH_URL"
echo
echo "Deploy completed."

