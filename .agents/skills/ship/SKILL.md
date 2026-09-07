---
name: ship
description: Use when the user explicitly asks to ship, create a PR, or review and deliver current repository changes through commit and push.
---

# Ship

An explicit ship/create-PR request authorizes commit, merging the latest `main` into the feature branch, push, and PR creation or update within the requested scope. NEVER merge a PR.

## Workflow

1. **Update documentation**
   - MUST check the repository's readme (`README.md`, or the casing that repo uses) and `docs/` when specs, commands, or options changed, and update them to match the implementation.
   - MUST keep command examples, options, and usage instructions accurate.
   - MUST update CLAUDE.md/AGENTS.md when they carry documentation affected by the change.
2. **Stage files**
   - MUST select commit-related files.
3. **Commit**
   - MUST use one of the commit-message prefixes: `feat:`, `fix:`, `refactor:`, `docs:`, or `chore:`.
   - NEVER bypass pre-commit hooks.
4. **Merge the latest `main`**
   - MUST fetch and merge the latest `main` into the feature branch before pushing, resolving conflicts locally.
   - NEVER use `git rebase`.
5. **Push**
   - MUST push the feature branch.
   - NEVER force-push, including `--force-with-lease`.
6. **Create or update the PR**
   - MUST use `gh api` for PR operations; this environment requires it.
   - MUST write the PR title and body in Japanese, retaining the required headings below.
7. **Move the task to review**
   - If this PR closes no tracked task, skip this step.
   - Otherwise MUST read the repository's readme (`README.md`, or the casing that repo uses, e.g. `ReadMe.md`) for the `task_tracker: <name>` declaration; if absent, MUST ask the user which tracker to use (NEVER infer it from installed CLIs, connected MCP servers, issue templates, or README prose), and after the user answers, SHOULD offer to add the declaration to that readme.
   - MUST move each such task's status to whatever status in that tracker means "in review" (e.g. an "In Review" column or single-select value).
   - If the tracker has no such status configured, MUST tell the user instead of inventing a field, label, or column.

## PR Body

MUST include these sections in order:

1. `# Summary`
2. `# Items to Confirm / Review`
3. `# User Prompt`

`# Summary` and `# Items to Confirm / Review` MUST come first, so a reviewer sees what changed and what the author specifically wants a human to check (risky decisions, assumptions, unverified behaviors) before anything else.

Under `# User Prompt`, MUST reproduce the agreed request as one complete instruction, NEVER a chat log. When a tracked task already holds a `# User Prompt`, MUST reuse that text. Otherwise reconstruct it: infer purpose and scope from the whole conversation, NEVER paste the original wording or list messages in speaking order, NEVER add requirements the conversation does not support, and list each distinct request as a bullet point.

MUST also record the implementation approach, the steps taken, and the key decisions in the body. Important information discussed in chat MUST end up in the task, the PR description, or PR comments — NEVER only in chat.

MUST end the body with the closing reference that the repository's task tracker uses to auto-close a task on merge (GitHub Issues: `Closes #<n>`), for the task this work is based on. Place it at the **very end** (after all other sections). If multiple tasks apply, list each on its own line.
