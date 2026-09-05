# rules

Cursor、Claude Code、Codex向けの共通ルールとセットアップです。

## 含まれるもの

- `AGENTS.md`: エージェント向けルール
- `.pre-commit-config.yaml`: 基本的なファイルチェック
- `.github/workflows/ci.yml`: pre-commitのCI
- `scripts/setup-worktree.sh`: worktree作成時のセットアップ
- `.agents/skills/`: 配布するスキルの正本

## 他のリポジトリへの導入

対象リポジトリのルートで実行します。`git`と`pre-commit`は事前にインストールしてください。

```sh
curl -fsSL https://raw.githubusercontent.com/2lu3/rules/main/install.sh | sh
```

`install.sh`は共通ファイルを配置し、pre-commitのGit hookを登録します。既存の配布対象ファイルは置き換えられます。

`.agents/skills/`は`.claude/skills/`にもコピーされます。Claude Codeは後者を参照します。

## worktree setup

worktree作成時に利用するソフトから、次のスクリプトを自動実行してください。

```sh
scripts/setup-worktree.sh /path/to/original-repository /path/to/worktree-repository
```

このスクリプトは、worktreeのブランチを確認した後、`scripts/setup-worktree-*.sh`をファイル名順に実行します。`main`、`master`、detached HEADでは実行できません。

worktreeの同期や`main`のpull、pre-commitのhook登録は行いません。pre-commitのhook登録は`install.sh`が行います。

## 手動チェック

```sh
pre-commit run --all-files
```

## 参考

- https://zenn.dev/singularity/articles/stopped-reviewing-my-code
