#!/usr/bin/env bash

set -Eeuo pipefail

on_error() {
  printf 'worktree setup failed at line %s\n' "$1" >&2
}

trap 'on_error "$LINENO"' ERR

# リポジトリのルートを解決する
if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  printf 'worktree setup requires a Git worktree\n' >&2
  exit 1
fi

# リポジトリのルートを作業ディレクトリにする
cd "$repo_root"
