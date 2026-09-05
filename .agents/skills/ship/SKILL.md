---
name: ship
description: Use when the user explicitly asks to ship, create a PR, or review and deliver current repository changes through commit and push.
---

# Ship

Keywords: MUST / NEVER = mandatory. SHOULD = recommended unless there is a clear reason not to. MAY = optional.

## Command Procedure

MUST run the following steps in order.

1. **Stage files**
   - MUST select commit-related files individually.
   - NEVER use `git add .`, `git add -A`, or `git add <directory>`.
2. **Commit**
   - MUST use one of the required commit-message prefixes: `feat:`, `fix:`, `refactor:`, `docs:`, or `chore:`.
   - If pre-commit fails, MUST resolve the root cause.
   - If the problem is with pre-commit itself, MUST ask the user before changing its configuration or hooks.
3. **Merge the latest `main`**
   - MUST fetch the latest `main` with `git fetch origin main`.
   - MUST merge `origin/main` into the current feature branch with `git merge origin/main`.
   - NEVER use `git rebase`.
   - If merge conflicts cannot be resolved, MUST stop and report instead of continuing.
4. **Push**
   - MUST push the current feature branch with `git push -u origin <branch>`.
   - NEVER use `git push --force` (unconditional overwrite). `git push --force-with-lease` MAY be used only on a feature branch that you pushed yourself immediately beforehand, after a local rewrite such as `git commit --amend`. NEVER force-push in any form to `main` or a shared branch.
5. **Create the PR**
   - MUST confirm the correct default or target branch before creating the PR.
   - MUST check for an existing PR for the branch through `gh api` before creating or updating one.
   - If no open PR exists, MUST create one through `gh api`, using the confirmed target branch and a body file. For example: `gh api repos/{owner}/{repo}/pulls -F title='...' -F head='{branch}' -F base='{base}' -F 'body=@pr-body.md'`.
   - If an open PR exists, MUST update that PR through `gh api`; NEVER create a second PR for the same branch. For example: `gh api --method PATCH repos/{owner}/{repo}/pulls/{pull_number} -F title='...' -F 'body=@pr-body.md'`.
   - Use a quoted heredoc or equivalent file-based method to create the body so Markdown backticks and shell characters are not expanded.
   - MUST report the commit, branch, PR URL, validation, and pending checks.

## LLM Decision Points

Between commands, MUST decide only what cannot be hard-coded.

- The scope of the changes and whether working-tree changes are unrelated user work.
- The default branch and required validation commands.
- The review classification and commit/PR text based on the actual diff.

MUST support decisions with evidence. NEVER invent tests, treat saved output as a clean rerun, or use pre-edit success as final evidence. Commit and PR text SHOULD be concise and based on the actual diff.

## Hard Stops

In the following cases, MUST stop and report instead of committing, pushing, or creating a PR.

- The current branch is `main`, `master`, detached, or otherwise not a safe feature branch.
- Unrelated changes cannot be separated confidently.
- Merge markers, `git diff --check`, required validation, or post-validation changes remain unresolved.
- The target branch, remote, authorization, or PR ownership is unclear.
- Multiple open PRs exist for the current branch, or the existing PR cannot be identified confidently.

NEVER use `git add .`, `git add -A`, `git reset --hard`, `git checkout --`, `git rebase`, or force-push. NEVER merge a PR. An explicit ship/create-PR request authorizes delivery, not merging.

## PR Body Requirements

MUST follow the repository's PR rules. For AI-generated changes, MUST include the following sections in this order:

1. `# Summary`
2. `# Items to Confirm / Review`
3. `# User Prompt`

Under `# User Prompt`, MUST reconstruct the request instead of pasting a conversation transcript. MUST also include the approach, key decisions, and validation evidence. If required, MAY place `Closes #123` on the final line.

## Final Review

Before reporting completion, MUST confirm the final status, diff, and commit. MUST distinguish local validation from remote CI and review: a created PR is not merged, and pending checks are not passing.
