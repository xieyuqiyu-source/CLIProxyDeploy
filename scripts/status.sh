#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$SCRIPT_DIR/repos.sh"

for item in "${REPOS[@]}"; do
  name="${item%%|*}"
  target="$ROOT_DIR/$name"

  echo "=== $name ==="
  if [[ ! -d "$target/.git" ]]; then
    echo "missing"
    echo
    continue
  fi

  branch="$(git -C "$target" rev-parse --abbrev-ref HEAD)"
  commit="$(git -C "$target" rev-parse --short HEAD)"
  changes="$(git -C "$target" status --short)"

  echo "branch: $branch"
  echo "commit: $commit"
  if [[ -n "$changes" ]]; then
    echo "$changes"
  else
    echo "clean"
  fi
  echo
done

