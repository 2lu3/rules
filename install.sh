#!/bin/sh

set -eu

# 配布元、対象パスを定義する
RULES_REPO_URL="https://github.com/2lu3/rules.git"
RULES_REF="main"
INSTALLATION_PATHS="AGENTS.md .pre-commit-config.yaml .github/workflows/ci.yml scripts/setup-worktree.sh .agents/skills .agents/rules"
SKILLS_RELATIVE_PATH=".agents/skills"
CLAUDE_SKILLS_RELATIVE_PATH=".claude/skills"

usage() {
  printf 'Usage: install.sh --profile research|prototype|production\n'
}

if [ "$#" -eq 1 ] && { [ "$1" = "--help" ] || [ "$1" = "-h" ]; }; then
  usage
  exit 0
fi

if [ "$#" -ne 2 ] || [ "$1" != "--profile" ]; then
  usage >&2
  exit 1
fi
profile="$2"
case "$profile" in
  research|prototype|production) ;;
  *)
    printf 'rules install failed: unknown profile: %s\n' "$profile" >&2
    exit 1
    ;;
esac

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

# 配置前に全 metadata を検証し、選択結果を一時領域で組み立てる。
selected_rules="$tmp_dir/selected-rules"
mkdir -p "$selected_rules"
for rule_path in "$source_root"/.agents/rules/*.md; do
  if ! selected="$(awk -v profile="$profile" '
    NR == 1 {
      if ($0 != "---") exit 1
      next
    }
    $0 == "---" { closed = 1; exit }
    /^applies_to:/ {
      if (++declarations != 1 || $0 !~ /^applies_to: \[[a-z]+(, *[a-z]+)*\]$/) exit 1
      scopes = $0
      sub(/^applies_to: \[/, "", scopes)
      sub(/\]$/, "", scopes)
      count = split(scopes, values, /, */)
      for (i = 1; i <= count; i++) {
        scope = values[i]
        if (scope != "all" && scope != "research" && scope != "prototype" && scope != "production") exit 1
        if (scope == "all" || scope == profile) selected = 1
      }
    }
    END {
      if (!closed || declarations != 1) exit 1
      print selected ? "yes" : "no"
    }
  ' "$rule_path")"; then
    printf 'rules install failed: invalid applies_to frontmatter: %s\n' "$rule_path" >&2
    exit 1
  fi
  if [ "$selected" = "yes" ]; then
    cp "$rule_path" "$selected_rules/"
  fi
done

selected_agents="$tmp_dir/AGENTS.md"
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    '- ['*'](.agents/rules/'*')'*)
      rule_name="${line#*](.agents/rules/}"
      rule_name="${rule_name%%)*}"
      if [ ! -f "$selected_rules/$rule_name" ]; then
        continue
      fi
      ;;
  esac
  printf '%s\n' "$line"
done < "$source_root/AGENTS.md" > "$selected_agents"
printf '\n適用用途: `%s`。`all` と `%s` の文書をインストール済みです。\n' "$profile" "$profile" >> "$selected_agents"
mv "$selected_agents" "$source_root/AGENTS.md"
rm -rf "$source_root/.agents/rules"
mv "$selected_rules" "$source_root/.agents/rules"

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
printf 'rules installed in %s (profile: %s)\n' "$repo_root" "$profile"
