# Global Cursor Settings

> Keywords: **MUST** / **NEVER** = mandatory. **SHOULD** = recommended unless there is a clear reason not to. **MAY** = optional.

詳細ルールは以下に分割されています。各文書の frontmatter の `applies_to` は適用用途を示します。
`all` は全用途共通です。用途別文書は対象コードがその用途の場合に適用します。

- [General Workflow](.agents/rules/general-workflow.md): 全体方針、汎用ワークフロー、デバッグ、PR作成前後の運用方針
- [Git 運用](.agents/rules/git.md): Git 操作の権限ルール
- [Register スキル](.agents/skills/register/SKILL.md): 計画をタスクとして登録し、実装の source of truth にする手順
- [Kickoff スキル](.agents/skills/kickoff/SKILL.md): 着手時にタスクのステータスを「進行中」相当へ移動する手順
- [Ship スキル](.agents/skills/ship/SKILL.md): ドキュメント更新、commit、push、PR 作成、タスクのステータスを「レビュー中」相当へ移動する納品手順
- [Close スキル](.agents/skills/close/SKILL.md): PR をマージし、タスクのステータスを「完了」相当へ移動する手順
- [Python](.agents/rules/python.md): Python 依存管理・実行規約
- [研究コード](.agents/rules/research-code.md): 科学的妥当性、再現性、例外伝播の方針
- [プロトタイプコード](.agents/rules/prototype-code.md): 仮説検証に必要な実装と検証の方針
- [本番運用コード](.agents/rules/production-code.md): 利用者との契約、境界でのエラー処理、運用の方針
