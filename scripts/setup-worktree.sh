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

# pre-commit 設定がないリポジトリでは何もしない
if [[ ! -f .pre-commit-config.yaml ]]; then
  printf 'No .pre-commit-config.yaml found; skipping hook installation\n'
  exit 0
fi

# pre-commit コマンドが利用できることを確認する
if ! command -v pre-commit >/dev/null 2>&1; then
  printf 'pre-commit is required to install the worktree hook\n' >&2
  printf 'Install pre-commit, then run this script again\n' >&2
  exit 1
fi

# Git hook と必要な hook 環境をインストールする
pre-commit install --install-hooks
printf 'pre-commit hook installed for %s\n' "$repo_root"
