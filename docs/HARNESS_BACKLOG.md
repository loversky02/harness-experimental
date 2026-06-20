# Harness Backlog

Use this file when an agent discovers a missing harness capability but should
not change the operating model immediately.

## Template

```md
## Missing Harness Capability

### Title

Short name.

### Discovered While

Task or story that exposed the gap.

### Current Pain

What was hard, repeated, ambiguous, or unsafe?

### Suggested Improvement

What should be added or changed?

### Risk

Tiny, normal, or high-risk.

CLI value: `--risk tiny`, `--risk normal`, or `--risk high-risk`.

### Status

proposed | accepted | implemented | rejected
```

## Items

## Missing Harness Capability

### Title

Gating `audit` mode (entropy exit code).

### Discovered While

ADR 0006 — adding the static fitness CI gate.

### Current Pain

`harness-cli audit` reports drift/entropy but always exits 0, so CI can gate
static structure (`harness-fitness.sh`) but cannot gate durable-layer entropy.

### Suggested Improvement

Add `harness-cli audit --max-entropy <n>` (or `--strict`) that exits non-zero
above a threshold, then call it from `harness-fitness.yml` as a real gate.

### Risk

normal.

### Status

proposed

## Missing Harness Capability

### Title

Port static fitness checks into the Rust CLI (`harness-cli check`).

### Discovered While

ADR 0006 — the fitness checks shipped as bash because no Rust toolchain was
available to verify CLI changes.

### Current Pain

Structural invariants live in `scripts/harness-fitness.sh` (bash), separate from
the Rust durable-layer tool, so the check surface is split across two languages.

### Suggested Improvement

Reimplement the skeleton/migration/marker/link checks as `harness-cli check`,
keep the bash script as a zero-dependency fallback, and have CI prefer the CLI.

### Risk

normal.

### Status

proposed

## Missing Harness Capability

### Title

Falsifiable predictions on harness edits (`harness_change` table).

### Discovered While

Reviewing the AHE paper (arXiv:2604.25850) decision-observability loop against
the durable layer, which records predicted-vs-actual only for backlog items.

### Current Pain

A harness *edit* (doc, schema, script) is not paired with a predicted impact
that a later round verifies, so the evolution loop is not closed end to end.

### Suggested Improvement

Add `scripts/schema/006-harness-change.sql` with a `harness_change` table
(change ref, predicted impact, risk, rollback, verified outcome) plus
`harness-cli evolve` to record and later falsify each prediction.

### Risk

high-risk (schema migration + changes the self-improvement contract).

### Status

proposed
