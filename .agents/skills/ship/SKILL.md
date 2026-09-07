---
name: ship
description: Use when the user explicitly asks to ship, create a PR, or review and deliver current repository changes through commit and push.
---

# Ship

An explicit ship/create-PR request authorizes commit, merging the latest `main` into the feature branch, push, and PR creation or update within the requested scope. NEVER merge a PR.

## Workflow

1. **Stage files**
   - MUST select commit-related files.
2. **Commit**
   - MUST use one of the commit-message prefixes: `feat:`, `fix:`, `refactor:`, `docs:`, or `chore:`.
   - NEVER bypass pre-commit hooks.
3. **Merge the latest `main`**
   - MUST fetch and merge the latest `main` into the feature branch before pushing, resolving conflicts locally.
   - NEVER use `git rebase`.
4. **Push**
   - MUST push the feature branch.
   - NEVER force-push, including `--force-with-lease`.
5. **Create or update the PR**
   - MUST use `gh api` for PR operations; this environment requires it.
   - MUST write the PR title and body in Japanese, retaining the required headings below.

## PR Body

MUST include these sections in order:

1. `# Summary`
2. `# Items to Confirm / Review`
3. `# User Prompt`

Under `# User Prompt`, MUST reconstruct the agreed request from the conversation as a complete instruction, preserving its purpose and scope rather than pasting a chat log.
