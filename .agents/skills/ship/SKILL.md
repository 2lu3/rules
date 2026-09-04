---
name: ship
description: Use when the user explicitly asks to ship, create a PR, or review and deliver current repository changes through commit and push.
---

# Ship

Use a deterministic command spine. The LLM fills semantic gaps between commands; it must not skip a gate because the change is small or urgent.

## Command spine

Run these in order and record relevant output:

1. `git status --short --branch`
2. `git branch --show-current` and `git symbolic-ref --short HEAD`
3. Discover and read repository instructions (`AGENTS.md`, `CONTRIBUTING.md`, relevant `.github/`, and `docs/` files).
4. Inspect tracked and untracked intended paths, `git diff`, `git diff --cached`, and `git diff --check`.
5. If `.pre-commit-config.yaml` exists, run `pre-commit run --all-files`; select project tests, lint, typecheck, or build commands from instructions and metadata.
6. Re-run `git status --short --branch`, inspect the complete diff, and stage only the intended files by path.
7. Inspect `git diff --cached`, then commit with a required prefix: `feat:`, `fix:`, `refactor:`, `docs:`, or `chore:`.
8. If configured, run `pre-commit run --from-ref HEAD~1 --to-ref HEAD`; then run `git status --short --branch` and `git log -1 --oneline`.
9. Push the feature branch with `git push -u origin <branch>`.
10. Check for an existing PR with `gh pr list --state open --head <branch>` before creating one.
11. Create or update the PR with the confirmed target branch and a body file. Use a quoted heredoc or equivalent file-based method so Markdown backticks and shell characters are not expanded.
12. Report the commit, branch, PR URL, validation, and pending checks.

## LLM decision slots

Between commands, decide only what cannot be hard-coded:

- Scope and whether dirty files are unrelated user work.
- Default branch and required validation commands.
- Review classification plus commit/PR text based on the actual diff.

State decisions with evidence. Do not invent tests, treat saved output as a clean rerun, or use pre-edit success as final evidence.

## Hard stops

Stop and report instead of committing, pushing, or creating a PR when:

- The current branch is `main`, `master`, detached, or otherwise not a safe feature branch.
- Unrelated changes cannot be separated confidently.
- Merge markers, `git diff --check`, required validation, or post-validation changes are unresolved.
- Target branch, remote, authorization, or PR ownership is unclear.
- An open PR already exists and update intent is unclear.

Never use `git add .`, `git add -A`, `git reset --hard`, `git checkout --`, `git rebase`, or force-push. Never merge the PR. An explicit ship/create-PR request authorizes delivery, not merging.

## PR body contract

Follow repository PR rules. For AI-generated changes, start with:

1. `# Summary`
2. `# Items to Confirm / Review`

Then include `# User Prompt`, approach/key decisions, and validation evidence. Reconstruct the request; do not paste a transcript. If required, put `Closes #123` on the final line.

## Final review

Before success, confirm final status, diff, and commit. Distinguish local validation from remote CI/review: a created PR is not merged, and pending checks are not passing.
