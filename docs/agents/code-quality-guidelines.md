# Code Quality

- MUST check for duplicate code with existing codebase after completing a significant implementation, and refactor to eliminate redundancy. Prioritize readability.
- SHOULD run `/code-review` after a significant implementation to catch bugs and cleanups (`--fix` to apply, `--comment` to post inline PR comments); use `/simplify` for quality-only refactors and `/security-review` when the change has a security surface

# Coding Style

## Philosophy: Code for Human Comprehension

Human context and memory are limited. MUST write code with this in mind:

- **Compact functions**: Split into small, focused functions that humans can fully comprehend at a glance
- **Clear naming**: Function and variable names MUST tell a story; a beginner should understand the flow
- **Minimal scope**: Keep variable scope as small as possible to reduce cognitive load
- **Readable flow**: Code MUST read like a narrative

## Rules

- NEVER use magic numbers; MUST use named constants
- SHOULD include units in variable names when applicable (e.g., `timeout_ms`, `distance_km`)
- MUST follow DRY principle (Don't Repeat Yourself)
- MUST add try/catch (or language equivalent) for operations that can fail
  - Network requests MUST include timeout handling
  - MUST provide meaningful error messages with context (URL, file path, etc.)
- MUST use existing library or standard-library functions instead of writing your own parsers/helpers (e.g. `isObject` from graphai, pydantic-settings / dotenv for `.env`). NEVER reinvent what the project already depends on. Adding a new package still requires asking first (see Change Scope Rules)

## Comments

- **Default to writing no comments.** Lean on names, types, and argument structure to do the explaining. If a comment restates what the next line obviously does (e.g. `// Initialize counter` followed by `let counter = 0;`), delete it.
- **NEVER explain WHAT the code does** — well-named functions, variables, and types already do that. If a comment is needed to understand WHAT, the better fix is to rename the identifier, tighten the type, or extract a smaller function.
- **ONLY add a comment when the WHY is non-obvious**: a hidden constraint, a subtle invariant, a workaround for a specific bug, a browser / library quirk, behavior that would surprise a reader. A future maintainer should be able to look at the comment and judge "is this still the right call?" — which means the *reason* must be in the comment, not just the *rule*.
- **NEVER reference the current task, fix, or callers** in comments (`// used by X`, `// added for the Y flow`, `// see issue #123`) — that context belongs in the PR description / commit message, and rots as the codebase evolves.
- **Don't write multi-paragraph docstrings or multi-line comment blocks** unless absolutely required by an external contract (public-API JSDoc on a published package). One short line is the cap.
- When refactoring, **delete WHAT comments aggressively** rather than keeping them around "just in case" — the source of truth is the code.

