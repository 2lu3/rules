---
name: land
description: Create a PR from already implemented changes and merge it when the user explicitly requests both. Validate and deliver without implementing or fixing code, and move an associated task through review to done. A ship or create-PR request alone does not authorize this workflow.
---

# Land

An explicit `land` request, or a request to create a PR from existing changes and merge it, authorizes delivery and merge within the requested scope. Read [ship](../ship/SKILL.md) for its delivery procedure and [close](../close/SKILL.md) for merge and task completion. Use only the phases specified below; do not run ship's implementation lifecycle.

## Workflow

1. **Establish the requested scope**
   - Inspect the current changes and conversation to identify what the user wants delivered.
   - MUST NOT implement features, fix code, or update implementation documentation. If unfinished work or validation failures require changes, report the blocker and stop delivery.
   - Follow ship's target-task and tracker identification rules. A task is optional; do not create one just to run this workflow.
   - When a task exists, check the existing changes against its scope and manage its review and done statuses. Skip implementation execution modes and the in-progress transition because implementation has already happened.
2. **Validate and create the PR**
   - Review the existing diff, check documentation consistency, and run relevant validation without applying automatic fixes.
   - Follow ship's stage, commit, latest-main merge, push, move-to-review, and draft-PR steps, including its PR body requirements and task closing reference.
   - If merging the latest main requires manual conflict resolution, stop and report it; do not make implementation changes to resolve conflicts in this workflow.
   - When a task exists, actually move it to in review. In no-task mode, skip tracker operations and closing references.
   - Do not proceed to close if validation or PR delivery is incomplete.
3. **Run close on that PR**
   - Continue without asking for another merge confirmation: the combined request already authorizes merging. Do not pause for optional human review.
   - Check required checks, required reviews, and mergeability. Never bypass repository protections; report unmet requirements if they prevent merging.
   - Mark the draft PR ready for review through `gh api graphql` using `markPullRequestReadyForReview`, then follow close's merge and task-completion procedure.
   - Verify the PR was actually merged before reporting success.
4. **Report the result**
   - Include the PR link, validation result, and confirmed merge status. When a task exists, include its confirmed final status.

## Review boundary

A request for `ship` or PR creation alone MUST stop at the PR for human review. Use this combined workflow only when the user also explicitly authorizes merging. A discussion about creating or editing this skill is not authorization to ship or merge the skill changes themselves.
