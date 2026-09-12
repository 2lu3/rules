# rules

Cursor、Claude Code、Codex向けの共通ルールとセットアップです。

## 含まれるもの

- `AGENTS.md`: エージェント向けルール
- `.agents/rules/`: 用途の metadata を持つルール文書
- `.pre-commit-config.yaml`: 基本的なファイルチェック
- `.github/workflows/ci.yml`: pre-commitのCI
- `.agents/scripts/setup-worktree.sh`: worktree作成時のセットアップ
- `.agents/skills/`: 配布するスキルの正本

## 他のリポジトリへの導入

対象リポジトリのルートで実行します。`git`と`pre-commit`は事前にインストールしてください。

```sh
curl -fsSL https://raw.githubusercontent.com/2lu3/rules/main/install.sh | sh -s -- --profile [research / prototype / production]
```

`-h` / `--help` で使い方を表示します。
`--profile` は必須で、`research`（研究）、`prototype`（試作）、`production`（本番運用）から選びます。
`install.sh` は `all` と指定用途の文書を選択し、`AGENTS.md` のリンクを揃え、pre-commit の Git hook を登録します。
`all` は全用途共通の文書を示す metadata で、インストール用途としては指定しません。

既存の配布対象は置き換えられます。`.agents/rules/` は既存の内容を全て置き換えます。
用途を切り替える場合も同じコマンドで再実行します。前の用途の文書は残りません。
一回のインストールで選べる用途は一つです。

`.agents/skills/`は`.claude/skills/`と`.codex/skills/`にもコピーされます。Claude Codeは前者、Codex CLIは後者を参照します。

## ルールの metadata

`.agents/rules/*.md` は、ファイル先頭に次の frontmatter を必ず置きます。

```yaml
---
applies_to: [all]
---
```

用途別文書には `[research]`、`[prototype]`、`[production]` を指定します。
複数用途で共有する場合は `applies_to: [research, prototype]` のように列挙できます。
共通文書には、用途にかかわらず成立する原則を置きます。

インストーラーが扱う `applies_to` は、上記の一行の非引用リスト形式に限定します。
キーは行頭に置き、コロンの後は空白一つ、値は `all` / `research` / `prototype` / `production` を使います。
汎用 YAML パーサーは使用せず、引用符や複数行リストには対応しません。
metadata の欠落、不正な形式、未知の用途は、配布対象を変更する前にエラーになります。
文書を追加するときは `AGENTS.md` にも `- [表示名](.agents/rules/ファイル名.md): 説明` の形式でリンクを追加してください。

## タスク管理ツールの宣言

`flow` は、タスクを扱う場合に、タスクをどこで扱うかを導入先リポジトリの readme から読み取ります。
`install.sh` の配布対象(`AGENTS.md` や `.agents/` 配下)は再インストールのたびに置き換わるため、
導入先固有の宣言は配布対象外の readme(`README.md`、このリポジトリでは `ReadMe.md`)に置きます。

```markdown
task_tracker: linear
```

`task_tracker` はタスク管理ツール名(`github` / `linear` / `jira` など)です。

`flow p` は、実行モードが未指定で `single` を推奨する場合、モードの確認を挟まず登録します。
`multi` が適切な場合だけ理由を添えて提案し、返答を待ちます。明示された指定を優先し、
タスクには `Execution mode: single` または `Execution mode: multi` を記録します。

対象タスクがあるのに宣言が無い場合、スキルはユーザーに確認します。導入済みの CLI、接続中の MCP、issue
テンプレートの有無から推測することはしません。このリポジトリ自身のタスク管理は上記の通り Linear です。

`flow` の呼び出しにタスクが明記されていない場合は、`タスクが明記されていません。` と出力し、
タスクのステータス変更や closing reference の追加を行わずに、ユーザーが明示した範囲を処理します。
`flow c` はDraft PR作成まで、`flow a` は対象PRのマージまでを行います。`flow a` は現在状態を認識し、
不足している `p` / `d` / `c` を順番に補完します。
対象タスクの状態更新とトラッカーの確認は、共通の[タスクの状態管理](.agents/rules/task-management.md)に従います。

## worktree setup

worktree作成時に利用するソフトから、次のスクリプトを自動実行してください。

```sh
.agents/scripts/setup-worktree.sh /path/to/original-repository /path/to/worktree-repository
```

このスクリプトは、worktreeのブランチを確認した後、`.agents/scripts/setup-worktree-*.sh`をファイル名順に実行します。`main`、`master`、detached HEADでは実行できません。

worktreeの同期や`main`のpull、pre-commitのhook登録は行いません。pre-commitのhook登録は`install.sh`が行います。

## 手動チェック

```sh
uv run --no-project python -m unittest discover -s tests
sh -n install.sh
pre-commit run --all-files
```

## 参考

- https://zenn.dev/singularity/articles/stopped-reviewing-my-code
