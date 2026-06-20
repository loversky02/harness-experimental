# Skill Orchestration — the conductor map

**Goal:** every overlapping skill keeps existing, but each gets **one clear home
domain** so they don't collide, and a **single pipeline** chains the best of each
so they coordinate smoothly. Nothing is deleted; responsibilities are separated.

## 1. The conductor rule

For any non-trivial work, **harness is the conductor**:
1. Classify scale (tiny / normal / high-risk ↔ BMAD level 0–4).
2. Delegate each phase to the **one** skill that owns that domain (§2).
3. **Never run two overlapping skills for the same step.** Tiers escalate, they
   don't stack — use the lightest skill that fits; go deeper only when it falls short (§4).

## 2. Domain ownership — one home per skill

Each skill below is the **default owner** of its domain. Others in the same row
are deeper escalations, not parallel choices.

| Domain | Default owner | Escalate / deeper | Note |
|--------|---------------|-------------------|------|
| Entry, classify, route | **harness** | — | the conductor |
| Quick ideation / trade-offs | **brainstorm** | → `ck-predict` (5-persona debate) | |
| Upfront product artifacts + named roles | **bmad-bridge** (analyst/pm/ux/po/qa) | — | brief, PRD, UX, PO-check, QA-gate |
| Edge-case / scenario surfacing | **ck-scenario** | — | 12-dimension |
| Architecture/security/UX debate | **ck-predict** | — | before risky changes |
| Detailed phased plan | **ck-plan** | — | when not running full khuym/bmad |
| Lock fuzzy decisions | **khuym:exploring** → **khuym:planning** | — | CONTEXT.md source of truth |
| Feasibility proof (repo truth) | **khuym:validating** | — | ≠ PO doc-check |
| Document alignment | **bmad-bridge** PO | — | ≠ feasibility |
| Story drafting | **harness** packet / **vibecode** TIP | — | pick one format per project |
| Constraint-enforced build | **vibecode-kit** (Contractor/Builder) | — | no architecture drift |
| Test-first discipline (during build) | **test-driven-development** | — | RED-GREEN-REFACTOR; ≠ `test` (run) / `ck-scenario` (what to test) |
| Parallel execution | **khuym:swarming/executing** | — | file reservations |
| Cross-session agent teams | **team** | — | vs swarming (one session) |
| Autonomous / recurring loop (ops) | **loop-engineering** | — | unattended; a SEPARATE lane from the interactive pipeline |
| Quick fix (known cause) | **fix** | → `ck-debug` | |
| Root-cause debug | **ck-debug** | `khuym:debugging` only inside a swarm worker | the two are equivalent — don't run both |
| Quick security scan | **security-scan** | → **ck-security** (STRIDE+OWASP) | `/security-review` = CLI equivalent |
| Code review | **code-review** (or `/code-review`) | → **khuym:reviewing** (pipeline gate) → **bmad-bridge** QA gate (verdict) | one per change |
| Quality cleanup only | **simplify** | — | no bug hunting |
| Find file / symbol | **explore** | → **scout** (parallel) → **feature-research** (deep) | tiered by breadth |
| How does OSS X work | **code-research** | — | |
| Library/API docs | **docs-seeker** | — | external |
| Fact research | **ask** → **research** → **deep-research** | — | tiered by depth |
| Optimize a metric (loop) | **ck-autoresearch** | — | |
| Create docs from scratch | **docs** | — | |
| Refresh stale docs | **refresh-project-docs** | — | |
| Deploy | **deploy** (PaaS) | → **devops** (Docker/K8s/CF/GCP), **use-railway**, **vercel** | by platform |
| Release → PR pipeline | **ship** | — | |
| UI build | **frontend-development** | — | React/TS |
| UI polished/manual design | **frontend-design** | — | |
| UI shadcn styling | **ui-styling** | — | |
| UI design recommendations | **ui-ux-pro-max** | — | |
| UI AI-generated design | **stitch** | — | Google Stitch |
| Brand / logo / banner / CIP | **design** | — | |
| Browser quick script/shot | **chrome-devtools** | → **agent-browser** (long autonomous) | + Chrome-ext / Playwright MCP |
| Task tracking CLI | **project-management** | — | |
| Agent task board | **kanban** | — | |
| Plan timeline dashboard | **plans-kanban** | — | |
| Session wrap-up (human) | **watzup** (quick) / **retro** (metrics) / **journal** (reflection) | — | pick ONE per session |
| Learning extraction (machine) | **khuym:compounding** | + `dream`, `consolidate-memory` | |
| Make a skill | **skill-creator** | (`template-skill` to scaffold) | |
| Make an agent | **agent-creator** | — | |
| Build an MCP server | **mcp-builder** | `build-mcp-server` (plugin) | |
| Improve a prompt | **prompt-leverage** | — | |

## 3. The unified pipeline (best of each, scale-gated)

One end-to-end flow. Skip phases per scale level (`bmad-bridge/references/scale-levels.md`).

```
INTAKE        harness — classify scale 0–4, locate docs/stories
   │
ANALYSIS      bmad-bridge:analyst → docs/product/brief.md            [L3–4]
   │
PLANNING      bmad-bridge:pm → PRD  (or ck-plan for a phased plan)   [L2–4]
   │          + UX: bmad-bridge:ux-expert → frontend-design/stitch
   │
RISK          ck-predict (debate) + ck-scenario (edge cases)         [L2–4]
   │
SOLUTIONING   bmad-bridge:architect → docs/adr/ + epics              [L3–4]
   │
ALIGN+FEASIBLE  bmad-bridge:PO (docs agree)  +  khuym:validating (buildable)
   │
STORY         harness story packet  /  vibecode TIP  (via bmad-bridge:sm)
   │
EXECUTE       khuym:swarming+executing (parallel)  |  vibecode Builder (constraint)
   │
REVIEW        code-review  +  ck-security  +  bmad-bridge QA gate (PASS/CONCERNS/FAIL/WAIVED)
   │
LEARN         khuym:compounding (machine)  +  retro/watzup (human wrap-up)
```

The two **planning philosophies coexist** here, each in its lane:
- **bmad-bridge** owns *what/why* (product artifacts + roles).
- **khuym** owns *prove-then-execute* (validating + swarming + compounding).
- **vibecode-kit** owns *how, safely* (role constraints during BUILD).
- **harness** owns *routing + scale + docs/TEST_MATRIX*.
- **ck-*** are *analysis injections* (plan/predict/scenario/debug/security) called at the phase that needs them.

## 4. Overlap tie-breakers

- **Planning (harness / khuym / vibecode / ck-plan / bmad-bridge):** harness routes.
  Default chain = bmad-bridge (artifacts) → khuym (validate+execute) → vibecode
  (constraint during build). Use `ck-plan` standalone only for a quick phased plan
  with no product artifacts. Don't open two planning skills for one feature.
- **Debug (ck-debug vs khuym:debugging):** identical intent. Standalone → `ck-debug`.
  Inside a khuym swarm worker → `khuym:debugging`. Never both.
- **Review (code-review / /code-review / reviewing / QA gate):** one *finds* issues
  (`code-review`), one is the *pipeline gate* (`khuym:reviewing`), one is the
  *verdict* (`bmad-bridge` QA gate). Run in that order, not in parallel.
- **Security (security-scan vs ck-security):** scan first; escalate to `ck-security`
  only if the scan flags something or the change is sensitive.
- **Explore (explore / scout / feature-research):** lightest that answers the
  question. `explore` for one lookup, `scout` for parallel breadth, `feature-research`
  before building a complex feature.
- **Wrap-up (journal / watzup / retro / session-report):** pick ONE per session —
  `watzup` quick, `retro` for metrics, `journal` for reflection.

## 5. Parallelism & MCP routing

- **team** = multiple agents across sessions; **khuym:swarming** = bounded parallel
  workers in one run with file reservations. Use swarming inside the pipeline; team
  for long-running multi-track efforts.
- **Browser:** dedicated MCP (Slack/Gmail/etc.) → Chrome extension MCP (web apps) →
  `chrome-devtools` (quick script) → `agent-browser` (long autonomous) → computer-use
  (native apps). Don't drop to a slower tier when a faster one fits.

## 6. Invariants ("don't collide")

1. One task, one owner skill per domain at a time.
2. harness routes; skills don't self-invoke each other's domains.
3. Tiers escalate, never stack.
4. Artifacts land in the project's real tree (`docs/…`, khuym `history/…`) — never a parallel tree.
5. The same scale level carries through all phases (don't re-classify mid-flow).
