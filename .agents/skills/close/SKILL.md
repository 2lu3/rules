---
name: close
description: Use when the user explicitly asks to merge the PR that `ship` created — merges the PR and moves its task to the status meaning "done" when a task is provided; otherwise reports that no task is specified and merges without task tracking.
---

# Close

An explicit merge/close request authorizes merging the draft PR that `ship` created and moving the task it closes to "done" when a target task exists. When no target task is explicitly named or referenced, enter no-task mode: report that fact, skip task tracking, and merge the PR without changing task metadata. This is the last step of the `register` → `ship` → `close` lifecycle. `ship` NEVER merges a PR — merging is this skill's responsibility.

## Preconditions

1. MUST confirm which PR to merge (the one the user names, or the PR created earlier in this conversation by `ship`).
2. MUST check the PR's checks/reviews status via `gh api` before merging; if required checks are failing or required reviews are missing, MUST NOT merge and MUST tell the user instead.

## Identify the target task

1. MUST use the task the merged PR closes (e.g. its `Closes #<n>` reference), or the task the user explicitly names.
2. If neither is available, MUST output `タスクが明記されていません。` and continue without task tracking. MUST NOT ask a follow-up question or guess the task from the current branch name or other contextual hints.
3. When a target task exists, MUST actually change its status to "done" after the PR is merged, or verify that the tracker's automatic transition reached "done".

## Identify the task tracker

1. When a target task exists, MUST read the repository's readme (`README.md`, or the casing that repo uses, e.g. `ReadMe.md`) and look for the declaration `task_tracker: <name>`.
2. If the declaration is absent, MUST ask the user which tracker to use. NEVER infer it from installed CLIs, connected MCP servers, issue templates, or README prose. After the user answers, SHOULD offer to add the declaration to that readme.

## Workflow

1. **Merge the PR**
   - MUST use `gh api` to merge; this environment requires it.
   - MUST merge with a merge commit (`gh api`'s `merge_method: merge`, i.e. git.md's `--merge`); NEVER squash-merge or rebase-merge.
   - NEVER force-merge past a failing required check or a missing required review.
2. **Move the task to done**
   - When a target task exists, MUST move its status to whatever status in that tracker means "done" (e.g. a "Done" column or single-select value).
   - When no target task exists, MUST skip this step.
   - If a target task exists but the tracker has no such status configured, MUST tell the user instead of inventing a field, label, or column.
   - If a target task exists and the tracker auto-transitions it on merge (e.g. GitHub Issues via `Closes #<n>`), MUST verify the task actually reached that status rather than assuming the closing reference worked.
   - NEVER change anything else about the task (title, description, assignee, etc.) as part of this skill.
