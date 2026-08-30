#!/usr/bin/env bash

set -Eeuo pipefail

on_error() {
  printf 'worktree setup failed at line %s\n' "$1" >&2
}

trap 'on_error "$LINENO"' ERR

if [ "$#" -ne 2 ]; then
  printf 'usage: %s <original-repository-path> <worktree-repository-path>\n' "$0" >&2
  exit 1
fi

if ! original_repo_path="$(cd -- "$1" 2>/dev/null && pwd -P)"; then
  printf 'worktree setup failed: original repository path is not accessible: %s\n' "$1" >&2
  exit 1
fi

if ! worktree_repo_path="$(cd -- "$2" 2>/dev/null && pwd -P)"; then
  printf 'worktree setup failed: worktree repository path is not accessible: %s\n' "$2" >&2
  exit 1
fi

cd -- "$worktree_repo_path"

shopt -s nullglob
setup_scripts=(scripts/setup-worktree-*.sh)

for setup_script in "${setup_scripts[@]}"; do
  [ -f "$setup_script" ] || continue

  if ! bash "$setup_script" "$original_repo_path" "$worktree_repo_path"; then
    printf 'worktree setup failed: %s\n' "$setup_script" >&2
    exit 1
  fi
done
