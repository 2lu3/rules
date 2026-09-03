# PR Bot Review Handling

After pushing to a PR, MUST triage **every** bot reviewer — not just the first one (CodeRabbit `coderabbitai[bot]`, Sourcery `sourcery-ai[bot]`, Codex, plus project-specific reviewers like Socket Security). Use the `/gh-review-loop` skill: it reads what all the GitHub-side bots posted on the latest commit (including inline threads that `gh pr view` omits), applies real fixes, pushes, and waits for re-review until every bot signs off, CI is green, and the user confirms.

Core principles it enforces — and which MUST hold even when triaging by hand:

- MUST NOT blindly apply suggestions — verify each against the actual codebase; bots disagree, so pick the right answer rather than satisfying both mechanically.
- Classify each comment: actionable fix (apply + add tests), valid nitpick (fix if cheap, else note as intentional), false positive / outdated (verify and skip with reason), rate-limited (note; re-check later).
- MUST commit fixes as `fix: address <bot-name> review comments` (name the specific bot), batched into one commit when possible.
- MUST post a follow-up PR comment summarizing what was addressed vs. deliberately skipped, so the human reviewer doesn't re-walk the bot threads.
