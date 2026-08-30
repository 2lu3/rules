# rules 導入スクリプト

## User Prompt

Issue #11 の要件に従い、GitHub Actions の CI、pre-commit 設定と worktree 用セットアップスクリプト、エージェント向けの `AGENTS.md` を別の Git リポジトリへ導入するシェルスクリプトを1つ作成する。README にリモートスクリプトの実行方法を記載し、PR を作成する。

## 実装方針

- リポジトリルートの `install.sh` を POSIX `sh` として追加する。
- `curl -fsSL .../install.sh | sh` で実行できるよう、対象リポジトリの Git ルートを検出する。
- 必要な4ファイルを対象リポジトリへ順にダウンロードし、再実行時に同じ状態になるよう更新する。
- 配布元は `main` ブランチの GitHub raw URL に固定する。
- 既存ファイルは更新し、`pre-commit` 自体のインストールは対象プロジェクトの環境に任せる。
- `install.sh` が `pre-commit install --install-hooks` を実行し、`setup-worktree.sh` では pre-commit のインストールを行わない。
- `setup-worktree.sh` は worktree 作成時に利用するソフトが自動実行する前提とし、インストーラーから手動実行を促さない。

## 検証

- `sh -n install.sh` で構文を確認する。
- 一時 Git リポジトリから実際の `main` ブランチ raw URL を取得し、4ファイルの配置と実行権限を確認する。
- README の実行例とスクリプトの実際の URL・動作を照合する。
