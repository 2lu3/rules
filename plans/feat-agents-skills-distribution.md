# .agents/skills/ 正本化と install.sh の cp 配布への対応

## User Prompt

Codex CLI / Cursor / Claude Code など複数のエージェントツールで共通利用するスキル（SKILL.md）を配布できるようにする。業界的には `.agents/skills/` が共通の置き場として収束しつつある一方、Claude Code は現状 `.claude/skills/` しか読み込まないため、`.agents/skills/` を正本としつつ `.claude/skills/` へも複製して橋渡しする。複製は symlink ではなく `cp` による実体コピーとする（Windows 環境や `core.symlinks` 設定への依存を避けるため）。

現状の `install.sh` はファイルを1つずつ `curl` でダウンロードする方式のため、中身が可変なディレクトリ（スキル群）を丸ごと配布できない。これに対応するため、`install.sh` の取得方式を全面的に見直す。

## 実装方針

- リポジトリに `.agents/skills/README.md` を新規作成する。配布用スキルの正本ディレクトリであること、配置規約（`.agents/skills/<skill-name>/SKILL.md`）、install.sh による配布の仕組み、対象リポジトリ側での直接編集は次回実行時に上書きされる旨を記載する。初期状態は空スケルトンのみで実際の SKILL.md は作らない。
- `install.sh` を「ファイル単位の curl ダウンロード」から「`2lu3/rules` を shallow git clone し、対象パスを `cp` で対象リポジトリへ同期する」方式に書き換える。
  - 依存コマンドチェックを `curl` から `git` に変更する（`pre-commit` は維持）。
  - `mktemp -d` で一時ディレクトリを作成し、`trap 'rm -rf "$tmp_dir"' EXIT` で確実に削除する。
  - 配布対象パス（`AGENTS.md`, `.pre-commit-config.yaml`, `.github/workflows/ci.yml`, `scripts/setup-worktree.sh`, `.agents/skills`）を、コピー元の存在確認 → `rm -rf` → `cp -r` の順で「置き換え」同期する。
  - 対象リポジトリに配置した `.agents/skills` を、同じ「置き換え」方式で `.claude/skills` にも実体コピーする。
- `ReadMe.md` を更新し、新しい導入方式（git clone + cp）と `.agents/skills/` → `.claude/skills/` の橋渡しについて説明を追記する。

## 検証

- `sh -n install.sh` で構文確認。
- ローカルに一時的な配布元リポジトリと導入先リポジトリを用意し、`install.sh` の `RULES_REPO_URL` を差し替えて実行。以下を確認する。
  - 既存の配布ファイル・ディレクトリが正しく配置されること
  - `.agents/skills/` と `.claude/skills/` の両方が実体コピーとして複製され、内容が一致すること（symlink でないこと）
  - 2回目実行しても冪等であり、対象リポジトリ側で追加した独自ファイルが「置き換え」により削除されること
  - clone 失敗時にも一時ディレクトリが確実に削除されること
- README の記述と実際のスクリプト動作を照合する。
