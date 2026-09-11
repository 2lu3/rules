# Global Cursor Settings

> Keywords: **MUST** / **NEVER** = mandatory. **SHOULD** = recommended unless there is a clear reason not to. **MAY** = optional.

詳細ルールは以下に分割されています。各文書の frontmatter の `applies_to` は適用用途を示します。
`all` は全用途共通です。用途別文書は対象コードがその用途の場合に適用します。

- [General Workflow](.agents/rules/general-workflow.md): 全体方針、汎用ワークフロー、デバッグ、PR作成前後の運用方針
- [タスクの状態管理](.agents/rules/task-management.md): 担当タスクの状態更新とトラッカーの確認
- [Git 運用](.agents/rules/git.md): Git 操作の権限ルール
- [Register スキル](.agents/skills/register/SKILL.md): 計画をタスクとして登録し、実装の source of truth にする手順
- [Ship スキル](.agents/skills/ship/SKILL.md): 実装からDraft PR作成までの一連の手順
- [Close スキル](.agents/skills/close/SKILL.md): PR をマージし、タスクのステータスを「完了」相当へ移動する手順
- [Land スキル](.agents/skills/land/SKILL.md): 実装済みの変更を検証して PR 作成・マージを行い、対象タスクを「レビュー中」「完了」へ更新する手順（実装は行わない）
- [Python](.agents/rules/python.md): Python 依存管理・実行規約
- [研究コード](.agents/rules/research-code.md): 科学的妥当性、再現性、例外伝播の方針
- [プロトタイプコード](.agents/rules/prototype-code.md): 仮説検証に必要な実装と検証の方針
- [本番運用コード](.agents/rules/production-code.md): 利用者との契約、境界でのエラー処理、運用の方針
