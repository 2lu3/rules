#!/bin/sh

set -eu

# 配布元、対象ファイル、通信タイムアウトを定義する
RULES_RAW_BASE_URL="https://raw.githubusercontent.com/2lu3/rules/main"
INSTALLATION_FILES="AGENTS.md .pre-commit-config.yaml .github/workflows/ci.yml scripts/setup-worktree.sh"
CURL_CONNECT_TIMEOUT_SECONDS=10
CURL_MAX_TIME_SECONDS=60

# 実行に必要なコマンドを確認する
if ! command -v curl >/dev/null 2>&1; then
  printf 'rules install failed: curl is required\n' >&2
  exit 1
fi

if ! command -v pre-commit >/dev/null 2>&1; then
  printf 'rules install failed: pre-commit is required\n' >&2
  exit 1
fi

# 対象リポジトリのルートを特定する
if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  printf 'rules install failed: run this script inside a Git repository\n' >&2
  exit 1
fi

cd "$repo_root"

# 配布元から1ファイルを対象リポジトリへダウンロードする
download_file() {
  relative_path="$1"
  source_url="$RULES_RAW_BASE_URL/$relative_path"
  target_directory="$(dirname "$relative_path")"

  mkdir -p "$target_directory"
  if ! curl -fsSL --proto '=https' --tlsv1.2 \
    --connect-timeout "$CURL_CONNECT_TIMEOUT_SECONDS" \
    --max-time "$CURL_MAX_TIME_SECONDS" \
    "$source_url" -o "$relative_path"; then
    printf 'rules install failed: could not download %s\n' "$source_url" >&2
    exit 1
  fi
}

# 配布ファイルを順に取得する
for relative_path in $INSTALLATION_FILES; do
  download_file "$relative_path"
done

# worktree セットアップスクリプトに実行権限を付与する
chmod 0755 scripts/setup-worktree.sh

# リポジトリの共有 Git hook に pre-commit を登録する
if ! pre-commit install --install-hooks; then
  printf 'rules install failed: could not install pre-commit hook in %s\n' "$repo_root" >&2
  exit 1
fi

# 導入結果を表示する
printf 'rules installed in %s\n' "$repo_root"
