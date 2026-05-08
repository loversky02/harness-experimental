# harness-experimental

A reusable collaboration harness that helps humans and agents turn specs into
safe, validated work.

**Forked from [hoangnb24/harness-experimental](https://github.com/hoangnb24/harness-experimental)**
with enhancements for Claude Code integration.

## What's New in This Fork

- **Design Tree Interview** — agent interviews user branch-by-branch to resolve
  dependencies before writing any code. Integrated into the intake flow.
- **Claude Code skills** — `/harness` (full intake-to-implement workflow),
  `/today` (daily standup), `/meet` (meeting notes extractor).
- **Lightweight entrypoint** — `.claude/Harness.md` loads via `CLAUDE.md` for
  always-on harness awareness.

## Current State

Harness v0. No application implementation, no baked-in product spec.
The harness provides: file structure, agent operating model, feature intake
process, story templates, and validation expectations.

## Mental Model

```text
Human intent → Design Tree Interview → Feature Intake → Story Packet
    → Agent Work Loop → Product Delta → Validation Proof → Harness Delta
```

Every task produces two outputs:
1. **Product delta** — code, tests, API shape, data model, docs.
2. **Harness delta** — templates, validation expectations, decisions, backlog
   items that make the next task easier.

## Design Tree Interview

When input is ambiguous or involves multiple decisions, the agent interviews
the user before classifying work:

- Ask one question at a time. Follow the tree branch-by-branch.
- If a question can be answered by exploring the codebase, explore instead.
- Do not generate code until the tree walk is complete.

This is baked into `docs/FEATURE_INTAKE.md` as a step before classification.

## Source-of-Truth Reading Order

1. `AGENTS.md` — entrypoint and operating rules
2. `docs/HARNESS.md` — human-agent collaboration model
3. `docs/FEATURE_INTAKE.md` — intake gate + design tree + risk lanes
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
    FEATURE_INTAKE.md       ← intake gate + design tree + risk lanes
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
