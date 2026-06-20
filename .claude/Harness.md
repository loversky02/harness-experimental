# Harness — Agent Operating System

For non-trivial implementation work, use the `/harness` skill to apply the intake → classify → story → validate → implement workflow.

When the harness skill is loaded, read source-of-truth in this order:
1. `README.md` or project status
2. `docs/HARNESS.md` (operating model)
3. `docs/FEATURE_INTAKE.md` (before any work)
4. User spec or prompt
5. `docs/product/` (product contracts)
6. `docs/ARCHITECTURE.md` (before implementation)
7. `docs/stories/` (story packets, backlog)
8. `docs/TEST_MATRIX.md` (proof status)
9. `docs/decisions/` (why choices were made)

Quick rules:
- Implementation prompts go through intake first, not straight to code
- Tiny changes (typos, narrow edits) can patch directly
- Normal changes need a story packet
- High-risk changes need full story folder + human confirmation
- Before finishing: update docs, stories, test matrix, and capture harness friction

## Skill orchestration (conductor model)

harness is the **conductor** for ALL non-trivial work: classify scale, then delegate
each phase to the ONE skill that owns that domain — **never run two overlapping
skills for the same step** (tiers escalate, they don't stack). Full map:
`~/.claude/skills/harness/references/ORCHESTRATION.md`.

Unified pipeline (scale-gated): intake(**harness**) → analysis(**bmad-bridge** analyst)
→ planning(**bmad-bridge** pm / **ck-plan**) → risk(**ck-predict**, **ck-scenario**)
→ solutioning(**bmad-bridge** architect + `docs/adr/`) → align(**bmad-bridge** PO)
+ feasibility(**khuym** validating) → story(harness / **vibecode** TIP)
→ execute(**khuym** swarming/executing | **vibecode** Builder) → review(**code-review**
+ **ck-security** + **bmad-bridge** QA gate) → learn(**khuym** compounding).

Lanes: bmad-bridge = what/why (artifacts+roles) · khuym = prove-then-execute · vibecode
= how-safely (constraints) · harness = routing+scale+TEST_MATRIX · ck-* = analysis injections.
Tie-breaks: fix→ck-debug · security-scan→ck-security · explore→scout→feature-research ·
one wrap-up only (watzup/retro/journal).

Two lanes: **interactive** build (the pipeline above) vs **autonomous loops** — the
`loop-engineering` skill (scheduled/triggered ops like PR-babysitter, daily-triage,
dependency-sweeper) with budget + maker/checker verifier + safety denylist + human gates.
