# Plan: `# User Prompt` を合意した要求として再構成する

## Issue
https://github.com/2lu3/rules/issues/6

## Goal
Bug Fix / Feature Request Workflow のステップ5を直し、PR 説明文の `# User Prompt` が発言ログではなく、議論の合意として再構成した一つの指示になるようにする。

## Approach
1. [`cursor.md`](../cursor.md) のステップ5を、合意した英語の文言に置き換える
2. Cursor User Rules を `cursor.md` と同じ内容に同期する
3. 見出し `# User Prompt` 自体は維持する
4. 禁止事項（原文貼り付け、発言順の羅列、会話が支持しない要件の追加）を明記する

## Out of scope
- PR 説明文の他セクション（Summary / Items to Confirm / Closes）の変更
- 実装スコープを会話から膨らませるルールへの変更
