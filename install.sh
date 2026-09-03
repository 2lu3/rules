#!/bin/sh

set -eu

# 配布元、対象パスを定義する
RULES_REPO_URL="https://github.com/2lu3/rules.git"
RULES_REF="main"
INSTALLATION_PATHS="AGENTS.md .pre-commit-config.yaml .github/workflows/ci.yml scripts/setup-worktree.sh .agents/skills"
SKILLS_RELATIVE_PATH=".agents/skills"
CLAUDE_SKILLS_RELATIVE_PATH=".claude/skills"

# 実行に必要なコマンドを確認する
if ! command -v git >/dev/null 2>&1; then
  printf 'rules install failed: git is required\n' >&2
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

# 配布元を取得する一時ディレクトリを用意し、終了時に必ず削除する
if ! tmp_dir="$(mktemp -d)"; then
  printf 'rules install failed: could not create a temporary directory\n' >&2
  exit 1
fi
trap 'rm -rf "$tmp_dir"' EXIT

source_root="$tmp_dir/rules"

if ! git clone --depth 1 --branch "$RULES_REF" --quiet "$RULES_REPO_URL" "$source_root"; then
  printf 'rules install failed: could not clone %s\n' "$RULES_REPO_URL" >&2
  exit 1
fi

# 配布元の1パスを対象リポジトリへ同期する(既存の内容は置き換える)
sync_path() {
  relative_path="$1"
  source_path="$source_root/$relative_path"
  target_path="$repo_root/$relative_path"

  if [ ! -e "$source_path" ]; then
    printf 'rules install failed: expected path missing in source: %s\n' "$relative_path" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$target_path")"
  rm -rf "$target_path"
  cp -r "$source_path" "$target_path"
}

# 配布パスを順に同期する
for relative_path in $INSTALLATION_PATHS; do
  sync_path "$relative_path"
done

# Claude Code は .claude/skills/ しか参照しないため、.agents/skills/ を実体コピーで橋渡しする
mkdir -p "$(dirname "$repo_root/$CLAUDE_SKILLS_RELATIVE_PATH")"
rm -rf "$repo_root/$CLAUDE_SKILLS_RELATIVE_PATH"
cp -r "$repo_root/$SKILLS_RELATIVE_PATH" "$repo_root/$CLAUDE_SKILLS_RELATIVE_PATH"

# worktree セットアップスクリプトに実行権限を付与する
chmod 0755 scripts/setup-worktree.sh

# リポジトリの共有 Git hook に pre-commit を登録する
if ! pre-commit install --install-hooks; then
  printf 'rules install failed: could not install pre-commit hook in %s\n' "$repo_root" >&2
  exit 1
fi

# 導入結果を表示する
printf 'rules installed in %s\n' "$repo_root"
