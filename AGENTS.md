# Global Cursor Settings

> Keywords: **MUST** / **NEVER** = mandatory. **SHOULD** = recommended unless there is a clear reason not to. **MAY** = optional.

詳細ルールは以下に分割されています。各文書の frontmatter の `applies_to` は適用用途を示します。
`all` は全用途共通です。用途別文書は対象コードがその用途の場合に適用します。

- [General Workflow](docs/agents/general-workflow.md): 全体方針、汎用ワークフロー、デバッグ、PR作成前後の運用方針
- [Git 運用](docs/agents/git.md): Git 操作の権限ルール
- [Ship スキル](.agents/skills/ship/SKILL.md): commit、push、PR 作成を含む Git 納品手順
- [PR Bot Review 運用](docs/agents/pr-bot-review-flow.md): bot レビューの triage 方針
- [Issue/Change ワークフロー](docs/agents/issue-and-change-workflow.md): 機能・修正時の手順
- [コード品質ガイドライン](docs/agents/code-quality-guidelines.md): コード品質、DRY、コーディング方針・コメント規約
- [ドキュメント保守](docs/agents/documentation-maintenance.md): ドキュメント更新規則
- [JavaScript / TypeScript](docs/agents/js.md): Node.js と TypeScript の実装規約
- [Vue](docs/agents/vue.md): Vue とスタイリングの規約
- [Python](docs/agents/python.md): Python 依存管理・実行規約
- [研究コード](docs/agents/research-code.md): 科学的妥当性、再現性、例外伝播の方針
- [プロトタイプコード](docs/agents/prototype-code.md): 仮説検証に必要な実装と検証の方針
- [本番運用コード](docs/agents/production-code.md): 利用者との契約、境界でのエラー処理、運用の方針
