---
name: close
description: Use when the user explicitly asks to merge the PR that `ship` created — merges the PR and moves the task's status to the one meaning "done" in the repository's task tracker.
---

# Close

An explicit merge/close request authorizes merging the PR that `ship` created and moving the task it closes to "done". This is the last step of the `register` → `kickoff` → `ship` → `close` lifecycle, so the task's status stays a reliable signal of what is actually happening. `ship` NEVER merges a PR — merging is this skill's responsibility.

## Preconditions

1. MUST confirm which PR to merge (the one the user names, or the PR created earlier in this conversation by `ship`).
2. MUST check the PR's checks/reviews status via `gh api` before merging; if required checks are failing or required reviews are missing, MUST NOT merge and MUST tell the user instead.

## Identify the task tracker

1. MUST read the repository's readme (`README.md`, or the casing that repo uses, e.g. `ReadMe.md`) and look for the declaration `task_tracker: <name>`.
2. If the declaration is absent, MUST ask the user which tracker to use. NEVER infer it from installed CLIs, connected MCP servers, issue templates, or README prose. After the user answers, SHOULD offer to add the declaration to that readme.

## Identify the target task

1. MUST use the task the merged PR closes (e.g. its `Closes #<n>` reference), or the task the user explicitly names.
2. If neither is available, MUST ask the user which task to close. NEVER guess the task from the current branch name or other contextual hints.

## Workflow

1. **Merge the PR**
   - MUST use `gh api` to merge; this environment requires it.
   - MUST merge with a merge commit (`gh api`'s `merge_method: merge`, i.e. git.md's `--merge`); NEVER squash-merge or rebase-merge.
   - NEVER force-merge past a failing required check or a missing required review.
2. **Move the task to done**
   - MUST move the task's status to whatever status in that tracker means "done" (e.g. a "Done" column or single-select value).
   - If the tracker has no such status configured, MUST tell the user instead of inventing a field, label, or column.
   - If the tracker auto-transitions the task on merge (e.g. GitHub Issues via `Closes #<n>`), MUST verify the task actually reached that status rather than assuming the closing reference worked.
   - NEVER change anything else about the task (title, description, assignee, etc.) as part of this skill.
