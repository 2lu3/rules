# Node.js / TypeScript

## Package Manager

- MUST use **yarn** (`yarn`, `yarn add`, `yarn remove`)
- NEVER use npm commands
- MUST use `yarn add` instead of manually editing package.json
- During upgrade work, if a dependency turns out to be unused, MUST propose removing it (`yarn remove`) instead of upgrading it

## Skills

- **New project** → `/init-project`
- **Publish an npm package** → `/publish`
- **Release the MulmoClaude app** (GitHub release, not npm) → `/release-app`

## Import Style

- MUST use top-level `import` for npm packages — NEVER use `await import()` for packages that are always needed
- Dynamic `import()` MAY only be used for conditional/optional dependencies that are not always loaded
- NEVER re-export modules unless there is a specific, justified reason

## Coding Style

- MUST prefer `const` over `let`; NEVER use `var`
- MUST prefer functional approaches (`forEach`, `map`, `filter`, `reduce`) over `for` loops
- MUST prefer `async/await` over `.then()` chains
- MUST use explicit type definitions; NEVER use `any`
- NEVER silence lint/type errors with `eslint-disable`, `@ts-ignore`, or `@ts-expect-error` — fix the types / root cause instead (define proper type files if needed)
- Network requests (fetch, API calls) MUST include timeout handling with AbortController

## TypeScript Best Practices

- NEVER use `as` type casts; MUST use type guards instead (e.g., `const isXxx = (x: unknown): x is Type => { ... }`)
- MUST use existing utility functions from libraries (e.g., `isObject` from graphai) instead of writing your own
- MUST use `z.infer<typeof schema>` to derive types from Zod schemas; NEVER define duplicate local types
- MUST use array + `push()` + `join()` pattern for building strings with `const` instead of `let` + `+=`
- MUST separate pure data transformation functions into their own files for reusability and testability
- MUST use descriptive format names (e.g., "object format" vs "text format") instead of "new/legacy"
- MUST verify the correct API signatures for the TARGET version when migrating or upgrading packages — NEVER assume old APIs still work

## Testing

- SHOULD use Node.js native `node:test` and `node:assert` by default; if the project already uses another runner (e.g. vitest, as in Cloudflare Workers projects), MUST follow the existing one
- MUST mock external APIs (tests MUST run without API keys)
- MUST place tests in `test/` at the repo root, named `test_xxx.ts`; MUST add a `test` script to package.json and run it in CI

## Documentation

- MUST generate proper web components (Vue/Astro) for web documentation — NEVER plain markdown files, unless explicitly asked for markdown

