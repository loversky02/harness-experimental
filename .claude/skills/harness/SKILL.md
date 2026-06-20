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

## Connecting With Existing Skills — harness is the conductor

harness classifies the work, then **delegates each phase to the ONE skill that
owns that domain**. Never run two overlapping skills for the same step (tiers
escalate, they don't stack). Full domain map + tie-breakers: `references/ORCHESTRATION.md`.

**Unified pipeline (scale-gated):**
intake (**harness**) → analysis (**bmad-bridge** analyst → brief) → planning
(**bmad-bridge** pm → PRD / **ck-plan**) → risk (**ck-predict**, **ck-scenario**)
→ solutioning (**bmad-bridge** architect + `docs/adr/`) → align (**bmad-bridge** PO)
+ feasibility (**khuym** validating) → story (harness packet / **vibecode** TIP)
→ execute (**khuym** swarming/executing or **vibecode** Builder) → review
(**code-review** + **ck-security** + **bmad-bridge** QA gate) → learn (**khuym** compounding).

| Phase | Default → escalate |
|-------|--------------------|
| Explore codebase | `explore` → `scout` → `feature-research` (+ `code-research`) |
| Plan | `harness` routes → `ck-plan` / `bmad-bridge` (artifacts) / `khuym:planning` |
| Risk analysis | `ck-scenario` (edge cases), `ck-predict` (5-persona) |
| Diagnose | `fix` (known cause) → `ck-debug` (root cause) |
| Implement | `vibecode-kit` (constraint) / `khuym:swarming` (parallel) / `backend-development`, `frontend-development` |
| Review | `code-review` → `ck-security` (deep) → `bmad-bridge` QA gate (verdict) |
| Test | `test-driven-development` (test-first discipline) → `test` / `web-testing` (run) |
| Ship | `ship` → `deploy` / `devops` (by target) |
| Learn | `khuym:compounding` (machine) · `retro`/`watzup` (human) |

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
7. docs/stories/ (story packets, backlog)
8. docs/TEST_MATRIX.md (proof status)
9. docs/decisions/ (why choices were made)
