# Git Operations

- NEVER perform git commit, push, or other git operations without explicit user permission
- MUST ask before running: `git commit`, `git push`, `git merge`, `git rebase`, etc.
- NEVER use `git add .` or `git add <directory>` — MUST add files individually
- NEVER delete untracked files
- NEVER push directly to `main` — from a worktree, MUST open a PR from the feature branch
- MUST use merge commit (`--merge`) when merging PRs — NEVER use squash merge
- NEVER use `git rebase`
- NEVER use `git push --force` (unconditional overwrite). `git push --force-with-lease` is permitted only on a feature branch you just pushed yourself, after `git commit --amend` or similar local rewrite — it aborts safely if anyone else pushed in the meantime. NEVER force-push (any variant) to `main` or shared branches.
- MUST use commit message prefixes: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
- When asked to 'create a PR' or 'PR、マージ', this MUST be interpreted as CREATE a pull request, not merge it
- MUST confirm the correct default/target branch before creating PRs
- Read-only operations (`git status`, `git diff`, `git log`) MAY be run freely
- SHOULD commit after each meaningful change (e.g., schema done → commit, utility functions done → commit)
