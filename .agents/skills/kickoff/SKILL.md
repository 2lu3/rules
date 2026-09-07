---
name: kickoff
description: Use when starting implementation work on a task that is already tracked — moves the task's status to the one meaning "in progress" in the repository's task tracker.
---

# Kickoff

Mark a tracked task as started before implementation begins. This is the moment work moves from "planned" to "in progress" in the tracker, so the task's status stays a reliable signal of what is actually happening.

## Identify the task tracker

1. MUST read the repository's readme (`README.md`, or the casing that repo uses, e.g. `ReadMe.md`) and look for the declaration `task_tracker: <name>`.
2. If the declaration is absent, MUST ask the user which tracker to use. NEVER infer it from installed CLIs, connected MCP servers, issue templates, or README prose. After the user answers, SHOULD offer to add the declaration to that readme.

## Identify the target task

1. MUST use the task the user explicitly names, or the task registered earlier in this conversation (e.g. by `register`).
2. If neither is available, MUST ask the user which task to start. NEVER guess the task from the current branch name or other contextual hints.

## Workflow

1. MUST move the task's status to whatever status in that tracker means "in progress" (e.g. an "In Progress" column or single-select value).
2. If the tracker has no such status configured, MUST tell the user instead of inventing a field, label, or column.
3. NEVER change anything else about the task (title, description, assignee, etc.) as part of this skill.
