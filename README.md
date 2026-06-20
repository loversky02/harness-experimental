# harness-experimental

A reusable collaboration harness that helps humans and agents turn specs into
safe, validated work.

**Forked from [hoangnb24/harness-experimental](https://github.com/hoangnb24/harness-experimental)**
with enhancements for Claude Code integration.

## What's New in This Fork

- **Claude Code skills** — `/harness` (full intake-to-implement workflow),
  `/today` (daily standup), `/meet` (meeting notes extractor).
- **Skill orchestration (conductor model)** — `/harness` classifies scale, then
  delegates each phase to the one skill that owns it (bmad-bridge, khuym,
  vibecode, ck-*); tiers escalate, they don't stack. See
  `.claude/skills/harness/references/ORCHESTRATION.md`.
- **Lightweight entrypoint** — `.claude/Harness.md` loads via `CLAUDE.md` for
  always-on harness awareness.

## Current State

Harness v0. No application implementation, no baked-in product spec.
The harness provides: file structure, agent operating model, feature intake
process, story templates, and validation expectations.

## Now Includes (merged from upstream)

This fork stays in sync with [hoangnb24/harness-experimental][upstream]. The
following upstream capabilities now ship here on top of the fork's Claude Code
integration:

- **SQLite durable layer** — `scripts/harness` CLI stores intake
  classifications, story status, decisions, backlog, and execution traces as
  data instead of hand-edited markdown (`docs/decisions/0004-sqlite-durable-layer.md`).
- **Rust Harness CLI** — `scripts/bin/harness-cli` is the primary operational
  tool, distributed as a prebuilt, checksum-verified binary.
- **Tool Registry** — register optional external tools as capability providers;
  an absent tool is a clean skip, never a failure (`docs/TOOL_REGISTRY.md`).
- **Demo walkthrough** — `docs/demo/` shows a product idea moving through
  intake → contracts → story → validation → decisions.

[upstream]: https://github.com/hoangnb24/harness-experimental

## Mental Model

```text
Human intent → Feature Intake → Story Packet
    → Agent Work Loop → Product Delta → Validation Proof → Harness Delta
```

Every task produces two outputs:
1. **Product delta** — code, tests, API shape, data model, docs.
2. **Harness delta** — templates, validation expectations, decisions, backlog
   items that make the next task easier.

## Skill Orchestration (Conductor Model)

The harness is the **conductor** for all non-trivial work: it classifies scale,
then delegates each phase to the one skill that owns that domain — never running
two overlapping skills for the same step (tiers escalate, they don't stack).

Unified pipeline (scale-gated): intake (**harness**) → analysis (**bmad-bridge**)
→ planning (**bmad-bridge** / **ck-plan**) → risk (**ck-predict**, **ck-scenario**)
→ solutioning (**bmad-bridge** architect) → align (**bmad-bridge** PO) + feasibility
(**khuym**) → story → execute (**khuym** / **vibecode**) → review (**code-review**
+ **ck-security** + **bmad-bridge** QA gate) → learn (**khuym**).

Full domain map and tie-breakers: `.claude/skills/harness/references/ORCHESTRATION.md`.

## Source-of-Truth Reading Order

1. `AGENTS.md` — entrypoint and operating rules
2. `docs/HARNESS.md` — human-agent collaboration model
3. `docs/FEATURE_INTAKE.md` — intake gate + risk lanes
4. User spec or prompt
5. `docs/product/` — product contracts
6. `docs/ARCHITECTURE.md` — architecture discovery rules
7. `docs/stories/` — story packets and backlog
8. `docs/TEST_MATRIX.md` — behavior-to-proof control panel
9. `docs/decisions/` — durable decisions and tradeoffs

## Three Risk Lanes

| Lane | When | Requirements |
|------|------|-------------|
| **Tiny** | Typos, copy, narrow edits | Patch directly, keep docs current |
| **Normal** | Story-sized behavior | Story packet, validation, vertical slice |
| **High-Risk** | Auth, data, security, multi-platform | Full story folder + human confirmation |

## Claude Code Skills

| Skill | Use when |
|-------|---------|
| `/harness` | Non-trivial implementation — full intake → story → validate → implement |
| `/today` | Start/end of session — review → plan → blockers → focus → wrap-up |
| `/meet` | Paste meeting notes — extract decisions, actions, open questions |

## Repository Structure

```text
project/
  AGENTS.md
  README.md
  .claude/
    Harness.md              ← lightweight entrypoint for CLAUDE.md
    skills/
      harness/              ← full intake workflow skill
      today/                ← daily standup skill
      meet/                 ← meeting notes skill
  docs/
    HARNESS.md              ← collaboration model
    FEATURE_INTAKE.md       ← intake gate + risk lanes
    ARCHITECTURE.md         ← architecture discovery rules
    TEST_MATRIX.md          ← proof control panel
    HARNESS_BACKLOG.md      ← harness growth proposals
    product/                ← product contracts
    stories/                ← story packets, backlog
    decisions/              ← durable decisions
    templates/              ← story, decision, spec-intake, validation
  scripts/
    README.md
```

## Install

From a target project directory:

```bash
curl -fsSL "https://raw.githubusercontent.com/loversky02/harness-experimental/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --yes
```

With conflict resolution:

```bash
# Keep existing files, add only missing harness files
curl -fsSL "https://raw.githubusercontent.com/loversky02/harness-experimental/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --merge --yes

# Back up and replace AGENTS.md, docs/, scripts/
curl -fsSL "https://raw.githubusercontent.com/loversky02/harness-experimental/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --override --yes

# Install into a specific path
curl -fsSL "https://raw.githubusercontent.com/loversky02/harness-experimental/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --directory /path/to/project --yes
```

Use `--dry-run` to preview changes. The installer itself is not copied into
the target project.

## Working Rule

Implementation prompts do not go straight to code. They pass through the
intake gate, become story-sized work when needed, and carry both product
validation and harness maintenance expectations.

## Growth Rule

The harness grows from friction. When an agent is confused, repeats manual
reasoning, or discovers a missing rule, it improves the harness or adds a
proposal to `HARNESS_BACKLOG.md`.
