#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$SCRIPT_DIR/repos.sh"

for item in "${REPOS[@]}"; do
  name="${item%%|*}"
  target="$ROOT_DIR/$name"

  if [[ ! -d "$target/.git" ]]; then
    echo "[missing] $name is not cloned"
    continue
  fi

  echo "=== $name ==="
  git -C "$target" fetch --all --tags
  git -C "$target" pull --ff-only || true
  git -C "$target" status --short
  git -C "$target" rev-parse --short HEAD
  echo
done

