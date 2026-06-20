#!/usr/bin/env bash
# Harness fitness functions — computational sensors that enforce STATIC REPO
# invariants MECHANICALLY rather than asking for them in prose. "Constraints
# over instructions": a violation fails the check (and the CI gate) instead of
# relying on probabilistic compliance.
#
# Scope: repository structure (files, schema sequence, managed blocks, internal
# links). This COMPLEMENTS — it does not replace — `harness-cli audit`, which
# computes durable-layer drift/entropy from harness.db. Fitness is the CI gate;
# audit is the data-level analysis.
#
# Fast, deterministic, no agent and no network. Safe to run in pre-commit/CI.
#
# Usage:
#   scripts/harness-fitness.sh [--strict]
#     --strict   treat drift/stale warnings as failures too
#
# Exit code: 0 = all hard checks pass; 1 = a hard check failed (or, with
# --strict, any warning).
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 2

STRICT=0
[ "${1:-}" = "--strict" ] && STRICT=1

FAIL=0
WARN=0
err()  { printf '  \033[31m✗\033[0m %s\n' "$1"; FAIL=$((FAIL + 1)); }
note() { printf '  \033[33m⚠\033[0m %s\n' "$1"; WARN=$((WARN + 1)); }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }

# ---------------------------------------------------------------------------
echo "[C1] Harness skeleton files present"
SKELETON="
AGENTS.md
README.md
docs/HARNESS.md
docs/FEATURE_INTAKE.md
docs/ARCHITECTURE.md
docs/TEST_MATRIX.md
docs/CONTEXT_RULES.md
docs/HARNESS_BACKLOG.md
docs/HARNESS_COMPONENTS.md
docs/HARNESS_MATURITY.md
docs/TRACE_SPEC.md
scripts/schema/001-init.sql
scripts/install-harness.sh
"
miss=0
for f in $SKELETON; do
  [ -f "$f" ] || { err "missing required harness file: $f"; miss=$((miss + 1)); }
done
[ "$miss" -eq 0 ] && ok "all ${miss:+}required harness files exist"

# ---------------------------------------------------------------------------
echo "[C2] Schema migrations are sequential and gap-free"
expected=1
gap=0
for f in scripts/schema/[0-9][0-9][0-9]-*.sql; do
  [ -e "$f" ] || break
  n=$(basename "$f" | sed -E 's/^0*([0-9]+).*/\1/')
  if [ "$n" -ne "$expected" ]; then
    err "schema migration gap: expected $(printf '%03d' "$expected"), found $(basename "$f")"
    gap=$((gap + 1))
  fi
  expected=$((expected + 1))
done
[ "$gap" -eq 0 ] && ok "$((expected - 1)) migrations numbered 001..$(printf '%03d' "$((expected - 1))")"

# ---------------------------------------------------------------------------
echo "[C3] Agent entrypoints carry the managed Harness block"
for f in AGENTS.md CLAUDE.md; do
  if [ -f "$f" ]; then
    if grep -q 'HARNESS:BEGIN' "$f" && grep -q 'HARNESS:END' "$f"; then
      ok "$f has HARNESS:BEGIN/END markers"
    else
      err "$f is missing HARNESS:BEGIN/END markers (installer cannot manage it)"
    fi
  fi
done

# ---------------------------------------------------------------------------
echo "[C4] Internal repo path references resolve (operating docs only)"
broken=0
# Scope to operating/reference docs. Templates and demos carry illustrative
# example paths, and PHASE*.md are historical journals — excluded to avoid
# flagging intended placeholders as drift.
refs=$(grep -rhoE '`(docs|scripts|crates|\.github)/[A-Za-z0-9_./-]+`' \
         --include='*.md' --exclude='PHASE*.md' --exclude='*BACKLOG*' \
         --exclude-dir=templates --exclude-dir=demo . 2>/dev/null \
       | tr -d '`' | sed -E 's/[.,):]+$//' | sort -u)
for ref in $refs; do
  case "$ref" in
    *\**|*NNNN*|scripts/bin/*) continue ;;   # globs, placeholders, installed binary
  esac
  [ -e "$ref" ] || { note "doc references a path that does not exist: $ref"; broken=$((broken + 1)); }
done
[ "$broken" -eq 0 ] && ok "all backticked repo paths in markdown resolve"

# ---------------------------------------------------------------------------
echo "[C5] Drift / stale markers"
markers=$(grep -rIlE 'TODO|FIXME|XXX|TBD' --include='*.md' docs .claude 2>/dev/null | wc -l | tr -d ' ')
if [ "${markers:-0}" -gt 0 ]; then
  note "$markers doc(s) contain TODO/FIXME/XXX/TBD markers (review for drift)"
else
  ok "no stale markers in docs/.claude"
fi

# ---------------------------------------------------------------------------
echo "[C6] Trace health (durable layer, read-only)"
DB="${HARNESS_DB:-harness.db}"
if command -v sqlite3 >/dev/null 2>&1 && [ -f "$DB" ]; then
  total=$(sqlite3 "$DB" "SELECT count(*) FROM trace;" 2>/dev/null || echo "n/a")
  bad=$(sqlite3 "$DB" "SELECT count(*) FROM trace WHERE outcome IN ('failed','blocked');" 2>/dev/null || echo 0)
  ok "traces recorded: $total (failed/blocked: ${bad:-0})"
  [ "${bad:-0}" -gt 0 ] && note "${bad} trace(s) failed/blocked — run 'harness-cli audit' for drift/entropy and 'harness-cli query friction'"
else
  ok "no harness.db here (durable-layer check skipped — expected outside an initialized project)"
fi

# ---------------------------------------------------------------------------
echo ""
printf 'Fitness: %d hard failure(s), %d warning(s).\n' "$FAIL" "$WARN"
if [ "$FAIL" -gt 0 ]; then exit 1; fi
if [ "$STRICT" -eq 1 ] && [ "$WARN" -gt 0 ]; then
  echo "(--strict) warnings treated as failures."
  exit 1
fi
exit 0
