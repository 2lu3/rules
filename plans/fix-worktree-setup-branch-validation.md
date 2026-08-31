# worktree setup のブランチ検証

## Issue

https://github.com/2lu3/rules/issues/13

## User Prompt

`scripts/setup-worktree.sh` の早い段階で worktree の現在ブランチを検証し、`main`、`master`、detached HEAD の場合は明確なエラーを表示して終了する。検証後は既存の worktree セットアップ処理を継続し、検証内容を `AGENTS.md` から削除し、`ReadMe.md` の説明を更新する。

## 実装方針

- worktree パスへ移動した直後に現在ブランチを取得する。
- `main` と `master` を拒否し、ブランチを取得できない場合は detached HEAD または Git worktree ではない状態として拒否する。
- 許可されたブランチでは検証成功メッセージを表示して、既存の固有 setup script のディスパッチを続ける。
- `AGENTS.md` からブランチ確認、clone／worktree 判定、ブランチ切り替え、fetch とデフォルトブランチとの差分確認に関するルールを削除する。
- `ReadMe.md` にブランチ検証の対象と、pre-commit 設定に依存しないことを記載する。

## 検証

- `bash -n scripts/setup-worktree.sh` で構文を確認する。
- 一時 Git リポジトリで `main`、`master`、detached HEAD が失敗し、feature ブランチが固有 setup script なしでも成功することを確認する。
- `git diff --check` で空白エラーがないことを確認する。

## 検証結果

- `bash -n scripts/setup-worktree.sh`: 成功
- `pre-commit run --all-files`: 全チェック成功
- 一時 Git リポジトリで `main`、`master`、detached HEAD は明確なエラーで失敗し、`feature/test` は pre-commit 設定と固有 setup script がない状態でも成功
- `git diff --check`: 成功
