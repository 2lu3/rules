---
name: register
description: Use when an agreed plan is ready to become a tracked task — creating the issue/ticket that holds the requirements, implementation plan, key decisions, and the reconstructed user prompt before implementation starts.
---

# Register

Turn a plan agreed with the user into a tracked task that becomes the source of truth for the work. Runs after planning. Creating the task is where this skill ends — implementation is a separate step, whether it happens right after or much later.

## Identify the task tracker

1. MUST read the repository's readme (`README.md`, or the casing that repo uses, e.g. `ReadMe.md`) and look for the declaration `task_tracker: <name>`.
2. If the declaration is absent, MUST ask the user which tracker to use. NEVER infer it from installed CLIs, connected MCP servers, issue templates, or README prose. After the user answers, SHOULD offer to add the declaration to that readme.

## Workflow

1. **Confirm the plan**
   - MUST have discussed and clarified the requirements with the user before creating anything.
   - MUST confirm that the plan declares exactly one execution mode: `Execution mode: single` or `Execution mode: multi`.
   - If the execution mode is missing or unclear, MUST ask the user and stop before creating the task. NEVER infer the mode during registration.
2. **Create the task**
   - MUST create one task in the identified tracker, titled with a summary of the work.
3. **Write the task description**
   - MUST include the detailed requirements, the implementation plan, the key decisions, and the agreed request under the exact Markdown heading `# User Prompt`.
   - The task description is the source of truth for the work — NEVER leave any of it in chat alone.

## `# User Prompt`

`# User Prompt` is not a chat log. MUST reconstruct and explain the request as one complete instruction, so a third party would share the same understanding of what to do and how far to go.

- The user's messages are often fragments or restatements. MUST infer purpose and scope from the whole conversation and rewrite them into a form a third party could agree with.
- NEVER paste the original wording. NEVER list messages in speaking order. NEVER add requirements the conversation does not support.
- If there are multiple distinct requests, list each as a bullet point.

`ship` reuses this text verbatim in the PR body, so it MUST stand on its own.
