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
