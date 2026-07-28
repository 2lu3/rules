# Obsolete (external doc references)

Moved from `cursor.md`. These pointed at repo-local docs that are not part of this rules repo.

## Debugging Approach

- Deeper methodology — bug-family matrices, sweeping a rule across every call site (then extracting ONE shared helper), adversarially reviewing retry/replay mechanisms, deterministic per-branch repro, `git fetch` before judging another repo's state, and never trusting an error string as the only evidence → [`docs/debugging-methodology.md`](docs/debugging-methodology.md). Read before a non-trivial bug hunt.

## Web Design & Debugging

- Falling back to the Playwright MCP by hand (web-design steps, debugging a live flow, the `browser_*` tool list) → [`docs/web-debugging.md`](docs/web-debugging.md).

## Node.js / TypeScript — Coding Style

- MUST separate pure data transformation functions into their own files for reusability and testability (see [`docs/testing.md`](docs/testing.md) → Designing for testability)

## Node.js / TypeScript — Testing

- Full unit-test pattern checklist (happy/edge/corner/boundary/empty/null/invalid/error/negative/regression), golden tests, and the **designing-for-testability** rules → [`docs/testing.md`](docs/testing.md). Read before writing or refactoring tests.
- Cross-platform CI (Linux/Windows/macOS matrix, `node:path` / `node:url` portability) → [`docs/cross-platform-ci.md`](docs/cross-platform-ci.md); Windows-only traps (`fs.watch`, `path.resolve`) → [`docs/windows-gotchas.md`](docs/windows-gotchas.md) — MUST read before debugging a Windows failure.
