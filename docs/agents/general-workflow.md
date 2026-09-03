# General

## Global Cursor Settings

- Keywords: **MUST** / **NEVER** = mandatory. **SHOULD** = recommended unless there is a clear reason not to. **MAY** = optional.

## General

- When today's date is needed, MUST run the `date` command to get it — NEVER rely on model's internal knowledge

## Change Scope Rules

- MUST only make changes that were explicitly requested — NEVER autonomously add features, tools, packages, or content
- MUST ask first if something additional seems needed
- MUST keep PR comments, commit messages, and documentation concise unless asked otherwise

## Debugging Approach

- MUST diagnose the ROOT CAUSE before attempting fixes
- NEVER try quick-fix approaches (hardcoding values, JSON workarounds)
- MUST check git history/diffs when investigating regressions
- MUST understand what the user is asking before jumping to debug

## Skills

- Prefer these skills over doing the work by hand:

  - **PR bot review triage** → `/gh-review-loop` (see PR Bot Review Handling)
  - **Code review / refactor / security** → `/code-review`, `/simplify`, `/security-review` (see Code Quality)
  - **Web verify / run / UI test / perf** → `/verify`, `run`, `/pr-ui-test`, `/web-perf` (see Web Design & Debugging)

## Web Design & Debugging

- MUST prefer the dedicated skills over driving a browser by hand:
  - `/verify` — exercise a change end-to-end and observe real behavior (run before committing nontrivial UI changes)
  - `run` — launch and drive the project's app to see a change working / take a screenshot
  - `/pr-ui-test` — UI regression check for a PR
  - `/web-perf` — web performance investigation

