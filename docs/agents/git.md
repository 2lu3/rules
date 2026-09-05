# Git Operations

- Before running `git commit`, `git push`, `git merge`, `git rebase`, or similar state-changing commands, MUST ask for confirmation if explicit permission has not been given.
- Explicitly invoking the `ship` skill counts as explicit permission for commit, merging the latest `main` into the current feature branch, pushing the feature branch, and creating or updating one PR within the requested scope. It does not authorize merging a PR.
- NEVER delete untracked files.
- When merging a PR, MUST use a merge commit (`--merge`); NEVER use squash merge.
- Read-only operations (`git status`, `git diff`, `git log`) MAY be run freely.
- SHOULD commit after each meaningful change (for example, after completing a schema or utility function).
