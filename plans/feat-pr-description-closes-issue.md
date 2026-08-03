# Plan: PR description closes original issue

## Issue
https://github.com/2lu3/rules/issues/2

## Goal
Bug Fix / Feature Request Workflow の PR 説明文ルールに、ステップ2で作成した GitHub issue をマージ時に自動クローズする記述を必須化する。

## Approach
1. [`cursor.md`](../cursor.md) の Bug Fix / Feature Request Workflow に、PR 説明文へ `Closes #<issue-number>` を含める MUST 項目を追加する
2. 対象はステップ2で作成した GitHub issue（複数ある場合はそれぞれに `Closes #n`）
3. キーワードは `Closes` を使う
4. 配置は PR 説明文の **一番末尾**（他セクションの後）とし、マージ時に GitHub が issue を閉じられるようにする

## Out of scope
- squash 以外のマージ戦略変更
- issue 作成フロー自体の変更
