#!/bin/sh

set -eu

# 配布元、対象ファイル、通信タイムアウトを定義する
RULES_RAW_BASE_URL="https://raw.githubusercontent.com/2lu3/rules/main"
INSTALLATION_FILES="AGENTS.md .pre-commit-config.yaml .github/workflows/ci.yml scripts/setup-worktree.sh"
CURL_CONNECT_TIMEOUT_SECONDS=10
CURL_MAX_TIME_SECONDS=60

# エラー内容を統一して表示する
fail() {
  printf 'rules install failed: %s\n' "$1" >&2
  exit 1
}

# 実行に必要なコマンドを確認する
if ! command -v curl >/dev/null 2>&1; then
  fail 'curl is required'
fi

if ! command -v git >/dev/null 2>&1; then
  fail 'git is required'
fi

# 対象リポジトリのルートを特定する
if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  fail 'run this script inside a Git repository'
fi

# ダウンロード中の一時ファイルを保存する場所を作る
if ! temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/rules-install.XXXXXX")"; then
  fail 'could not create a temporary directory'
fi

# 中断や終了時に一時ファイルを削除する
cleanup() {
  rm -rf "$temp_dir"
}

trap cleanup 0
trap 'exit 1' 1 2 15

# 配布元から1ファイルを一時領域へダウンロードする
download_file() {
  relative_path="$1"
  temporary_path="$temp_dir/$relative_path"
  temporary_directory="$(dirname "$temporary_path")"
  source_url="$RULES_RAW_BASE_URL/$relative_path"

  mkdir -p "$temporary_directory"
  if ! curl -fsSL --proto '=https' --tlsv1.2 \
    --connect-timeout "$CURL_CONNECT_TIMEOUT_SECONDS" \
    --max-time "$CURL_MAX_TIME_SECONDS" \
    "$source_url" -o "$temporary_path"; then
    fail "could not download $source_url"
  fi
}

# ダウンロード済みのファイルを対象リポジトリへ配置する
install_file() {
  relative_path="$1"
  temporary_path="$temp_dir/$relative_path"
  target_path="$repo_root/$relative_path"
  target_directory="$(dirname "$target_path")"

  mkdir -p "$target_directory"
  chmod 0644 "$temporary_path"
  if [ "$relative_path" = "scripts/setup-worktree.sh" ]; then
    chmod 0755 "$temporary_path"
  fi
  mv "$temporary_path" "$target_path"
}

# 先に全ファイルを取得し、取得失敗時の部分更新を防ぐ
for relative_path in $INSTALLATION_FILES; do
  download_file "$relative_path"
done

# 全ファイルの取得後に対象リポジトリを更新する
for relative_path in $INSTALLATION_FILES; do
  install_file "$relative_path"
done

# 導入結果と次の手順を案内する
printf 'rules installed in %s\n' "$repo_root"
