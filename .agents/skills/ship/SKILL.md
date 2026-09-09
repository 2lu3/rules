---
name: ship
description: Use when the user explicitly asks to ship or create a PR — starts the tracked task, implements the registered work, moves it to review, and creates or updates a draft PR.
---

# Ship

An explicit ship/create-PR request runs the full task-start-through-draft-PR lifecycle. It authorizes starting the tracked task, implementing its registered scope, committing, merging the latest `main` into the feature branch, pushing, and creating or updating one draft PR within the requested scope. NEVER merge a PR — merging is `close`'s responsibility, not `ship`'s.

## Identify the task tracker

1. MUST read the repository's readme and look for the declaration of task tracker.
2. If the declaration is absent, MUST ask the user which tracker to use. NEVER infer it from installed CLIs, connected MCP servers, issue templates, or README prose. After the user answers, SHOULD offer to add the declaration to that readme.

## Identify the target task

1. MUST use the task the user explicitly names, or the task registered earlier in this conversation (e.g. by `register`).
2. If neither is available, MUST ask the user which task to start. NEVER guess the task from the current branch name or other contextual hints.
3. `ship` requires a tracked task because it moves the task to both "in progress" and "in review".

## Determine the execution mode

1. MUST read the task's `Execution mode: single` or `Execution mode: multi` and use the registered implementation plan as the source of truth.
2. If the execution mode is missing, MUST use `single`.
3. If the execution mode is present but invalid or ambiguous, MUST NOT start implementation. Report the issue and stop.
4. For `single`, MUST continue implementation as one implementation agent in the task workspace.
5. For `multi`, MUST act as the parent coordinator:
   - MUST decompose work according to the registered plan and launch multiple implementation subagents through the available orchestration tools.
   - SHOULD give independently editable subtasks isolated workspaces and clear ownership. Subagents MUST NOT concurrently edit the same files without coordination.
   - MUST collect subagent results, integrate their changes, resolve conflicts, and run the full relevant validation as the parent.
6. MUST NOT broaden the registered scope or invent additional subtasks. If the plan cannot be decomposed safely, stop and report the blocker.

## Workflow

1. **Move the task to in progress**
   - MUST move the task's status to whatever status in that tracker means "in progress" (e.g. an "In Progress" column or single-select value).
   - If the tracker has no such status configured, MUST tell the user instead of inventing a field, label, or column.
2. **Implement the task**
   - MUST follow the execution mode and registered implementation plan above.
3. **Update documentation**
   - MUST check the repository's readme (`README.md`, or the casing that repo uses) and `docs/` when specs, commands, or options changed, and update them to match the implementation.
   - MUST keep command examples, options, and usage instructions accurate.
   - MUST update CLAUDE.md/AGENTS.md when they carry documentation affected by the change.
4. **Stage files**
   - MUST select commit-related files.
5. **Commit**
   - MUST use one of the commit-message prefixes: `feat:`, `fix:`, `refactor:`, `docs:`, or `chore:`.
   - NEVER bypass pre-commit hooks.
6. **Merge the latest `main`**
   - MUST fetch and merge the latest `main` into the feature branch before pushing, resolving conflicts locally.
   - NEVER use `git rebase`.
7. **Push**
   - MUST push the feature branch.
   - NEVER force-push, including `--force-with-lease`.
8. **Move the task to review**
   - MUST move the task's status to whatever status in that tracker means "in review" (e.g. an "In Review" column or single-select value).
   - If the tracker has no such status configured, MUST tell the user instead of inventing a field, label, or column.
9. **Create or update the draft PR**
   - MUST use `gh api` for PR operations; this environment requires it.
   - If no matching open PR exists, MUST create a new PR with `draft: true`.
   - If an existing PR is being updated and it is not already a draft, MUST convert it with the GitHub GraphQL `convertPullRequestToDraft` mutation through `gh api graphql` before completing the workflow.
   - MUST write the PR title and body in Japanese, retaining the required headings below.

## PR Body

MUST include these sections in order:

1. `# Summary`
2. `# Items to Confirm / Review`
3. `# User Prompt`

`# Summary` and `# Items to Confirm / Review` MUST come first, so a reviewer sees what changed and what the author specifically wants a human to check (risky decisions, assumptions, unverified behaviors) before anything else.

Under `# User Prompt`, MUST reproduce the agreed request as one complete instruction, NEVER a chat log. When a tracked task already holds a `# User Prompt`, MUST reuse that text. Otherwise reconstruct it: infer purpose and scope from the whole conversation, NEVER paste the original wording or list messages in speaking order, NEVER add requirements the conversation does not support, and list each distinct request as a bullet point.

MUST also record the implementation approach, the steps taken, and the key decisions in the body. Important information discussed in chat MUST end up in the task, the PR description, or PR comments — NEVER only in chat.

MUST end the body with the closing reference that the repository's task tracker uses to auto-close a task on merge (GitHub Issues: `Closes #<n>`), for the task this work is based on. Place it at the **very end** (after all other sections). If multiple tasks apply, list each on its own line.
