---
name: harness
description: "Project operating system for turning specs/prompts into safe, validated work. Use when starting new feature work, receiving a spec, planning implementation, or when the user wants structured intake→story→validation→implementation flow. SKIP when: quick one-line fix (use fix), exploratory question, or the user explicitly wants direct code changes without process."
argument-hint: "[spec|feature|change|initiative|maintenance|improvement]"
---

# Harness — Agent Operating System

The harness is the collaboration layer between human intent and agent execution.
It ensures every piece of work passes through: **intake → classify → story → validate → implement → update harness**.

## Quick Start

For ANY implementation request, run through the intake gate first:

1. Read `references/FEATURE_INTAKE.md` to classify the work.
2. Restate the request as a work item.
3. Find affected docs/stories.
4. Run the risk checklist.
5. Choose lane: **tiny**, **normal**, or **high-risk**.

Then execute according to the lane rules below.

## The Three Lanes

### Tiny
Patch directly. Keep docs current. Run available quick checks. Update harness only if friction found.

### Normal
Create/update a story from `templates/story.md`. Link product docs. Add validation. Implement smallest vertical slice. Update TEST_MATRIX.

### High-Risk
Create story folder from `templates/high-risk-story/`. Fill execplan, overview, design, validation. Ask human confirmation before implementation. Record a decision.

## Connecting With Existing Skills

| Phase | Skills to use |
|-------|--------------|
| Explore codebase | `scout`, `explore`, `code-research` |
| Diagnose issues | `ck-debug`, `ck-scenario` |
| Implement | `fix` (tiny), `vibecode-kit` (normal+), `backend-development`, `frontend-development` |
| Review | `code-review`, `ck-security` |
| Test | `test`, `web-testing` |
| Plan | `planning`, `ck-plan` |
| Ship | `ship`, `deploy` |

## Task Loop (Every Task)

1. Classify via `references/FEATURE_INTAKE.md`
2. Identify input type: new spec, spec slice, change, initiative, maintenance, harness improvement
3. Locate affected docs and stories
4. Check TEST_MATRIX for existing proof and gaps
5. Work inside the selected lane
6. Before finishing, ask:
   - Did product truth change?
   - Did validation expectations change?
   - Did architecture rules change?
   - Did we discover a repeated failure pattern?
   - Does the next agent need clearer instructions?
7. Update harness files or add proposal to HARNESS_BACKLOG

## Done Definition

- Change completed or blocker documented
- Docs, stories, test matrix remain current
- Validation commands run (when they exist)
- Missing harness capabilities added to HARNESS_BACKLOG
- Final response says what changed and what was not attempted

## Source-of-Truth Reading Order

1. README.md (project status)
2. docs/HARNESS.md (operating model)
3. docs/FEATURE_INTAKE.md (before any work)
4. User spec or prompt
5. docs/product/ (product contracts)
6. docs/ARCHITECTURE.md (before implementation)
7. docs/CONTEXT_RULES.md (which context each lane must load)
8. docs/stories/ (story packets, backlog)
9. docs/TEST_MATRIX.md (proof status)
10. docs/decisions/ (why choices were made)

## Durable Layer

Operational records (intake classifications, story status, decisions, backlog,
execution traces) live in a SQLite durable layer, not hand-edited markdown. The
Rust Harness CLI is the primary operational tool — use it when present:

- `scripts/bin/harness-cli query matrix` — proof status
- `scripts/bin/harness-cli query tools --capability <name> --status present` —
  what external tools are equipped (`references/TOOL_REGISTRY.md`)

An absent tool or capability is a clean skip, never a failure.
