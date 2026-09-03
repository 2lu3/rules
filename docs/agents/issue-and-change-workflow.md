# Bug Fix / Feature Request Workflow

When asked to fix a bug or implement a new feature:

1. MUST discuss and clarify requirements with the user
2. MUST create a GitHub issue summarizing the task once scope is clear
3. MUST create a plan file under the repository's `plans/` directory (e.g., `plans/fix-xxx.md` or `plans/feat-xxx.md`) — this file MUST be committed to the repo
4. MUST implement based on the plan
5. MUST write the agreed request under the exact Markdown heading `# User Prompt` in the PR description.
   - `# User Prompt` is not a chat log. Reconstruct and explain it as one complete instruction so a third party would share the same understanding of what to do and how far to go.
   - The user's messages are often fragments or restatements. MUST infer purpose and scope from the whole conversation and rewrite them into a form a third party could agree with.
   - NEVER paste the original wording. NEVER list messages in speaking order. NEVER add requirements the conversation does not support.
   - If there are multiple distinct requests, list each as a bullet point.
6. MUST include detailed implementation approach, proposed steps, and key decisions in the PR description — important information discussed in chat MUST be persisted as files or PR comments, NEVER only in chat
7. For AI-generated code PRs, MUST put a **Summary** section and an **Items to Confirm / Review** section at the **very top** of the PR description (before User Prompt, implementation details, etc.). The reviewer should see the summary and explicit review-focus points first, so they know what changed and what the author specifically wants a human to check (e.g., risky decisions, assumptions, unverified behaviors).
8. MUST end the PR description with GitHub closing keyword(s) for the issue created in step 2, using `Closes #<n>`, so merging the PR automatically closes that issue. Place them at the **very end** of the body (after all other sections). If multiple issues apply, list each on its own line (`Closes #n`).
