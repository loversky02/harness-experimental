# 0006 Static fitness gate and skill reconciliation

Date: 2026-06-20

## Status

Accepted

## Context

Two gaps remained between this harness and current harness-engineering practice
(OpenAI "taste invariants", Martin Fowler's computational sensors, AHE —
arXiv:2604.25850):

1. The durable layer already exposes `harness-cli audit` (drift + entropy score)
   and `harness-cli propose` (improvement proposals from observed patterns) —
   the harness is H5-partial. But nothing runs them as a *gate*: structural
   compliance still relied on an agent reading prose, which yields probabilistic
   compliance. The research is consistent that a rule a *check* enforces beats a
   rule the agent is *asked* to follow.
2. The `/harness` skill shipped the older operating docs, which described the
   harness as having "no drift detector" and "H5 not achieved". The skill was
   under-reporting the repository's real capability, so an agent driving through
   the skill would not reach for `audit`, `propose`, `verify`, `intervention`,
   or the tool registry that already exist.

## Decision

- Add `scripts/harness-fitness.sh`: deterministic, read-only sensors over
  **static repository structure** — skeleton-file presence, gap-free schema
  migrations, managed `HARNESS:BEGIN/END` blocks, internal path-reference
  integrity, and drift markers. It exits non-zero on violations. This
  *complements* `harness-cli audit` (durable-layer drift/entropy); it does not
  duplicate it.
- Add `.github/workflows/harness-fitness.yml`: runs the fitness gate on PRs, and
  runs `harness-cli audit`/`propose` informationally when a CLI binary is
  present. Enforcement is now mechanical at PR time.
- Reconcile the `/harness` skill with the repository's true capability: refresh
  the skill's `HARNESS_COMPONENTS.md` / `HARNESS_MATURITY.md` references and add
  a durable-layer command section to `SKILL.md`, while keeping the conductor
  orchestration model intact.

## Alternatives Considered

1. Reimplement drift/entropy/proposals in a bash `harness-evolve.sh` — drafted,
   then **rejected and deleted** as a duplicate of `harness-cli audit`/`propose`.
   The honest move was to gate and surface the existing Rust commands, not
   re-create them in a second language.
2. Add the fitness checks inside the Rust CLI now — deferred; no Rust toolchain
   was available to compile/test, and shipping unverified Rust violates the
   harness's own "validation before done" rule. Tracked in the backlog.

## Predicted Impact

- Structural drift is caught at PR time instead of by a future confused agent.
- The skill stops under-reporting capability, so agents actually use `audit`,
  `propose`, `verify`, and `intervention`.
- No regression to existing tables, commands, or the build (additive only).

## Risk

normal — additive new files plus doc/skill refresh; no schema or Rust change.

## Validation

- `bash -n` on the script; `harness-fitness.sh` run against this repo (passed;
  surfaced real drift warnings, which were triaged: a historical journal and
  template examples, plus genuine cross-ecosystem references); the C6 db path
  exercised against a temp `harness.db` built from the migrations in
  `scripts/schema/` (001 through 005).
- The fitness gate's own pass in CI is its proof.

## Rollback

Delete `scripts/harness-fitness.sh` and the workflow; revert the skill refresh.
No schema or CLI change to undo; no data loss.

## Follow-Up

- Give `harness-cli audit` a threshold/exit-code mode so CI can gate on entropy,
  then call it from the fitness workflow instead of only informationally.
- Port the static structural checks into the Rust CLI as `harness-cli check`.
- Add a `harness_change` predictions table so harness edits — not only backlog
  items — carry a falsifiable predicted-vs-actual pair end to end.
