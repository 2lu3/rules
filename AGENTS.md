# Global Cursor Settings

> Keywords: **MUST** / **NEVER** = mandatory. **SHOULD** = recommended unless there is a clear reason not to. **MAY** = optional.

詳細ルールは以下に分割されています。各文書の frontmatter の `applies_to` は適用用途を示します。
`all` は全用途共通です。用途別文書は対象コードがその用途の場合に適用します。

- [General Workflow](.agents/rules/general-workflow.md): 全体方針、汎用ワークフロー、デバッグ、PR作成前後の運用方針
- [Git 運用](.agents/rules/git.md): Git 操作の権限ルール
- [Ship スキル](.agents/skills/ship/SKILL.md): commit、push、PR 作成を含む Git 納品手順
- [PR Bot Review 運用](.agents/rules/pr-bot-review-flow.md): bot レビューの triage 方針
- [Issue/Change ワークフロー](.agents/rules/issue-and-change-workflow.md): 機能・修正時の手順
- [コード品質ガイドライン](.agents/rules/code-quality-guidelines.md): コード品質、DRY、コーディング方針・コメント規約
- [ドキュメント保守](.agents/rules/documentation-maintenance.md): ドキュメント更新規則
- [JavaScript / TypeScript](.agents/rules/js.md): Node.js と TypeScript の実装規約
- [Vue](.agents/rules/vue.md): Vue とスタイリングの規約
- [Python](.agents/rules/python.md): Python 依存管理・実行規約
- [研究コード](.agents/rules/research-code.md): 科学的妥当性、再現性、例外伝播の方針
- [プロトタイプコード](.agents/rules/prototype-code.md): 仮説検証に必要な実装と検証の方針
- [本番運用コード](.agents/rules/production-code.md): 利用者との契約、境界でのエラー処理、運用の方針
