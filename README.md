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

## Why Star This Repo

Star this repo if you want practical, reusable patterns for making AI-assisted
software development more reliable, inspectable, and easier for humans to steer.

This project is exploring a simple idea:

> Coding agents do not only need better prompts. They need better repositories.

## The Problem

Most repos are built for humans reading code in a familiar codebase. Coding
agents usually enter with only a chat prompt and a shallow snapshot of files.
That leads to common failure modes:

- The agent edits code before understanding product intent.
- Important constraints live only in chat history or in someone's head.
- Validation expectations are vague or discovered too late.
- Architecture tradeoffs are repeated instead of inherited.
- Large requests do not get broken into reviewable story-sized work.

## The Harness Approach

A repository starts to have a harness when it helps an agent answer practical
engineering questions without relying only on chat history:

- What should I read first?
- What type of work is this?
- Which product contract does it affect?
- How risky is the change?
- What proof will show the work is done?
- What decision or lesson should future agents inherit?

In this repo, those answers live in:

- `AGENTS.md` — the stable agent shim with local project notes and Harness
  doc links.
- `docs/HARNESS.md` — the human-agent collaboration model.
- `docs/FEATURE_INTAKE.md` — tiny, normal, and high-risk work classification.
- `docs/ARCHITECTURE.md` — architecture discovery and boundary rules.
- `docs/TEST_MATRIX.md` — behavior-to-proof validation expectations.
- `docs/stories/` — story packets and backlog items.
- `docs/decisions/` — durable decisions and tradeoffs.
- `docs/templates/` — reusable spec, story, decision, and validation templates.

OpenAI describes this shift as an agent-first world where humans steer and
agents execute:

https://openai.com/index/harness-engineering/

## Install Harness Into A Project

From a target project directory, run:

```bash
curl -fsSL "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --yes
```

On Windows PowerShell, run:

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.ps1"))) -Yes
```

If the target already has `AGENTS.md`, `docs/`, or `scripts/`, choose one:

```bash
# Update an existing Harness repo without moving existing files
curl -fsSL "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --merge --yes

# Back up and replace AGENTS.md, docs/, and scripts/
curl -fsSL "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --override --yes
```

```powershell
# Update an existing Harness repo without moving existing files
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.ps1"))) -Merge -Yes

# Back up and replace AGENTS.md, docs/, and scripts/
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.ps1"))) -Override -Yes
```

Use `--merge` when a project already has Harness and you want to append newly
added Harness files without moving the existing `AGENTS.md`, `docs/`, or
`scripts/` paths into backup. Existing files stay untouched; only missing
Harness files are created.

For older Harness installs whose `AGENTS.md` still contains the full generated
operating guide, refresh it into the small stable shim:

```bash
curl -fsSL "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --merge --refresh-agent-shim --yes
```

The refresh backs up the existing file. If it detects the old
Harness-generated guide, it replaces it with the shim. If the file appears
custom, it appends or updates a marked Harness block instead of overwriting the
project's local instructions.

If the project is driven with Claude Code, add `--claude`. Claude Code never
auto-loads `AGENTS.md`, so without this the installed harness is invisible to
fresh sessions. The flag installs (or refreshes) a `CLAUDE.md` whose marked
Harness block `@`-imports `AGENTS.md` and `docs/FEATURE_INTAKE.md` into every
session's context. An existing `CLAUDE.md` gets the block appended after a
backup; plain installs without the flag never touch `CLAUDE.md`:

```bash
curl -fsSL "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --claude --yes
```

Or install into a specific path:

```bash
curl -fsSL "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.sh?$(date +%s)" | bash -s -- --directory /path/to/project --yes
```

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/hoangnb24/repository-harness/main/scripts/install-harness.ps1"))) -Directory C:\path\to\project -Yes
```

Use `--dry-run` on Bash or `-DryRun` on PowerShell to preview changes before
writing files.

The installer also downloads the prebuilt Harness CLI for the current platform,
verifies its `.sha256` checksum, and installs it at
`scripts/bin/harness-cli` on macOS/Linux or `scripts/bin/harness-cli.exe` on
Windows. The Rust CLI is the main Harness tool and stable command path.

Harness CLI release assets are published from tags by the
`Harness CLI Release` GitHub Actions workflow. The installer expects each
release to include `harness-cli-<platform>` and
`harness-cli-<platform>.sha256` assets for macOS arm64, macOS x64, Linux x64,
Linux arm64, and Windows x64. The Windows asset is
`harness-cli-windows-x64.exe` plus `harness-cli-windows-x64.exe.sha256`.

Merged pull requests are recorded in `CHANGELOG.md` by the
`Post-Merge Maintenance` workflow. When a merged PR changes the Rust CLI source,
schema, Cargo metadata, or CLI release packaging, that workflow bumps the CLI
patch version, updates `scripts/harness-cli-release-tag`, creates a
`harness-cli-v*` tag, and runs the Harness CLI release build for that tag.

## Try The Flow

The fastest way to understand the harness is to inspect the tiny demo:

- `docs/demo/README.md`: shows how a simple product idea becomes product docs,
  stories, validation expectations, and decisions before implementation starts.

A typical flow looks like this:

```text
human intent or product spec
  -> product contract
  -> feature intake
  -> story packet
  -> validation expectations
  -> implementation work
  -> decision or lesson captured for future agents
```

Implementation prompts do not go straight to code. They first pass through
feature intake, become story-sized work when needed, and then carry both product
validation and harness maintenance expectations.

## Try Harness Symphony

Harness Symphony is the local runner for Harness stories. It prepares an
isolated run workspace, passes an explicit contract to an agent, collects
`SUMMARY.md` and `RESULT.json`, and keeps durable Harness updates reviewable
through semantic changesets.

Start here:

- `docs/SYMPHONY_QUICKSTART.md`: first-run instructions and the daily command
  loop.
- `docs/SYMPHONY_SCOPE.md`: detailed design and implementation scope.

The usual first commands are:

```bash
cargo build -p harness-symphony
target/debug/harness-symphony doctor
target/debug/harness-symphony work list
target/debug/harness-symphony run <story-id> --prepare-only
```

## Tool Registry

The harness can use optional external tools (linters, code-graph servers,
deploy checks) without depending on any of them. You register a tool as a
provider of a *capability*, the harness scans whether it is actually present,
and a workflow step uses whatever is equipped — an absent tool is a clean skip,
never a failure.

```bash
# register a tool as a provider of a capability
scripts/bin/harness-cli tool register --name deploy-check --kind cli \
  --capability deploy-verification --command ./scripts/deploy-check.sh \
  --responsibility Verification --description "Verify deploy health before release"

# scan presence (writes present/missing/unknown)
scripts/bin/harness-cli tool check

# a step looks up what is equipped for a purpose
scripts/bin/harness-cli query tools --capability deploy-verification --status present
```

Kinds (`cli`, `binary`, `mcp`, `skill`, `http`) make it agent-generic: each
agent runtime uses what it can orchestrate. See `docs/TOOL_REGISTRY.md` for the
full model, the degrade ladder, and how to wire a tool into a flow step.

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
