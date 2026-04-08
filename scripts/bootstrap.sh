#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$SCRIPT_DIR/repos.sh"

echo "Workspace root: $ROOT_DIR"

for item in "${REPOS[@]}"; do
  name="${item%%|*}"
  url="${item#*|}"
  target="$ROOT_DIR/$name"

  if [[ -d "$target/.git" ]]; then
    echo "[skip] $name already exists"
    continue
  fi

  echo "[clone] $name"
  git clone "$url" "$target"
done

echo
echo "Bootstrap completed."

