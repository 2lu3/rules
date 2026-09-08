---
name: kickoff
description: Use when starting implementation work on a tracked task — moves the task's status to "in progress" and starts implementation according to its execution mode. For multi-agent work, act as the parent coordinator and launch implementation subagents.
---

# Kickoff

Mark a tracked task as started and begin implementation according to its registered execution mode. This is the moment work moves from "planned" to "in progress" in the tracker, so the task's status stays a reliable signal of what is actually happening.

## Identify the task tracker

1. MUST read the repository's readme (`README.md`, or the casing that repo uses, e.g. `ReadMe.md`) and look for the declaration `task_tracker: <name>`.
2. If the declaration is absent, MUST ask the user which tracker to use. NEVER infer it from installed CLIs, connected MCP servers, issue templates, or README prose. After the user answers, SHOULD offer to add the declaration to that readme.

## Identify the target task

1. MUST use the task the user explicitly names, or the task registered earlier in this conversation (e.g. by `register`).
2. If neither is available, MUST ask the user which task to start. NEVER guess the task from the current branch name or other contextual hints.

## Workflow

1. MUST move the task's status to whatever status in that tracker means "in progress" (e.g. an "In Progress" column or single-select value).
2. If the tracker has no such status configured, MUST tell the user instead of inventing a field, label, or column.
3. MUST read the task's `Execution mode: single` or `Execution mode: multi` and use the registered implementation plan as the source of truth.
4. If the execution mode is missing or unclear, MUST NOT start implementation. Report the issue and stop.
5. For `single`, MUST continue implementation as one implementation agent in the task workspace.
6. For `multi`, MUST act as the parent coordinator:
   - MUST decompose work according to the registered plan and launch multiple implementation subagents through the available orchestration tools.
   - SHOULD give independently editable subtasks isolated workspaces and clear ownership. Subagents MUST NOT concurrently edit the same files without coordination.
   - MUST collect subagent results, integrate their changes, resolve conflicts, and run the full relevant validation as the parent.
7. MUST NOT broaden the registered scope or invent additional subtasks. If the plan cannot be decomposed safely, stop and report the blocker.
8. MUST NOT invoke `ship` or `close` as part of kickoff; those remain separate lifecycle steps.
9. The status transition is the only task-tracker mutation performed by kickoff; do not change the task's title, description, assignee, or other tracker fields.
