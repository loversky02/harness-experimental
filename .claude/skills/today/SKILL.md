---
name: today
description: "Daily standup loop: review yesterday's work, plan today, identify blockers, focus session, wrap-up. Use at the start or end of a work session. SKIP when: the user just wants to code directly without process."
---

# Daily Standup

Lightweight daily workflow. Run in ~3-5 minutes.

## Loop

1. **Review** — what was done yesterday/last session?
   - Check recent git commits, story files, decision records
   - Note what was completed vs deferred

2. **Plan** — what's on deck today?
   - List 1-3 intended outcomes
   - Identify which harness lane each belongs to (tiny/normal/high-risk)

3. **Blockers** — anything in the way?
   - Missing context, unclear spec, dependency on another task
   - Log blockers to `docs/HARNESS_BACKLOG.md` or project tracker

4. **Focus** — pick the first task and start
   - Run through harness intake gate if it's implementation work

5. **Wrap-up** — at end of session
   - What got done? What's deferred?
   - Update story status and TEST_MATRIX
   - Quick note on harness friction encountered

## Output

Keep it short. At the end, the agent says:

```
Done today: [what was completed]
Deferred: [what moved to tomorrow]
Blockers: [anything stuck]
Harness delta: [any process improvement made]
```
