# Skills

このディレクトリは、Codex CLI / Cursor / Claude Code など複数のエージェントツールで共通利用する「スキル」の正本(source of truth)です。

## 配置規約

1スキル1ディレクトリとし、直下に `SKILL.md` を置きます。

```
.agents/skills/<skill-name>/SKILL.md
```

現時点ではスキルが未作成のため、このディレクトリには本ファイルのみが存在します(Git は空ディレクトリを追跡できないため、プレースホルダを兼ねています)。

## 配布の仕組み

`install.sh` はこのディレクトリの内容を丸ごと、対象リポジトリの `.agents/skills/` と `.claude/skills/` の両方へ `cp` で実体コピーします。Claude Code は `.claude/skills/` しか読み込まないため、この複製によって同じスキルを橋渡ししています(symlink ではなく実体コピーなので、Windows 環境や `core.symlinks` 設定に依存しません)。

## 注意

`.agents/skills/` と `.claude/skills/` はどちらも配布物専用です。対象リポジトリ側でこの配下を直接編集しても、次回 `install.sh` 実行時にディレクトリごと置き換えられます。独自のスキルを追加したい場合は別ディレクトリを使うか、本リポジトリ (`2lu3/rules`) への変更を提案してください。
