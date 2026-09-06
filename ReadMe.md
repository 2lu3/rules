# rules

Cursor、Claude Code、Codex向けの共通ルールとセットアップです。

## 含まれるもの

- `AGENTS.md`: エージェント向けルール
- `docs/agents/`: 用途の metadata を持つルール文書
- `.pre-commit-config.yaml`: 基本的なファイルチェック
- `.github/workflows/ci.yml`: pre-commitのCI
- `scripts/setup-worktree.sh`: worktree作成時のセットアップ
- `.agents/skills/`: 配布するスキルの正本

## 他のリポジトリへの導入

対象リポジトリのルートで実行します。`git`と`pre-commit`は事前にインストールしてください。

```sh
curl -fsSL https://raw.githubusercontent.com/2lu3/rules/main/install.sh | sh -s -- --profile research
```

`-h` / `--help` で使い方を表示します。
`--profile` は必須で、`research`（研究）、`prototype`（試作）、`app`（製品）から選びます。
`install.sh` は `all` と指定用途の文書を選択し、`AGENTS.md` のリンクを揃え、pre-commit の Git hook を登録します。
`all` は全用途共通の文書を示す metadata で、インストール用途としては指定しません。

既存の配布対象は置き換えられます。`docs/` 内の置き換え対象は `docs/agents/` のみです。
用途を切り替える場合も同じコマンドで再実行します。前の用途の文書は残りません。
一回のインストールで選べる用途は一つです。

`.agents/skills/`は`.claude/skills/`にもコピーされます。Claude Codeは後者を参照します。

## ルールの metadata

`docs/agents/*.md` は、ファイル先頭に次の frontmatter を必ず置きます。

```yaml
---
applies_to: [all]
---
```

用途別文書には `[research]`、`[prototype]`、`[app]` を指定します。
複数用途で共有する場合は `applies_to: [research, prototype]` のように列挙できます。
共通文書には、用途にかかわらず成立する原則を置きます。

インストーラーが扱う `applies_to` は、上記の一行の非引用リスト形式に限定します。
キーは行頭に置き、コロンの後は空白一つ、値は `all` / `research` / `prototype` / `app` を使います。
汎用 YAML パーサーは使用せず、引用符や複数行リストには対応しません。
metadata の欠落、不正な形式、未知の用途は、配布対象を変更する前にエラーになります。
文書を追加するときは `AGENTS.md` にも `- [表示名](docs/agents/ファイル名.md): 説明` の形式でリンクを追加してください。

## worktree setup

worktree作成時に利用するソフトから、次のスクリプトを自動実行してください。

```sh
scripts/setup-worktree.sh /path/to/original-repository /path/to/worktree-repository
```

このスクリプトは、worktreeのブランチを確認した後、`scripts/setup-worktree-*.sh`をファイル名順に実行します。`main`、`master`、detached HEADでは実行できません。

worktreeの同期や`main`のpull、pre-commitのhook登録は行いません。pre-commitのhook登録は`install.sh`が行います。

## 手動チェック

```sh
uv run --no-project python -m unittest discover -s tests
sh -n install.sh
pre-commit run --all-files
```

## 参考

- https://zenn.dev/singularity/articles/stopped-reviewing-my-code
