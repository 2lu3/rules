# Plan: add `ship` skill

Issue: #22

## Scope

Add a reusable `.agents/skills/ship/SKILL.md` for explicit delivery requests that combine review, validation, commit, push, and pull-request creation.

## Approach

1. Initialize the skill with valid metadata and keep the body focused on release-safety decisions.
2. Encode repository-specific instruction discovery, diff review, validation evidence, safe Git operations, duplicate-PR checks, and PR-body requirements.
3. Validate the skill structure, run repository hooks, inspect the final diff, then commit, push, and create a PR targeting `main`.

## Decisions

- Keep the skill automatically discoverable as `ship`.
- Never merge a PR or push directly to a protected/default branch as part of this workflow.
- Stop and report when validation, branch safety, authorization, or remote delivery is blocked.
