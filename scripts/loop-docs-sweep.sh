#!/usr/bin/env bash
# loop:docs-sweep — L0 report-only docs-drift detector (the unattended/ops lane).
#
# Flags two kinds of drift, deterministically, from git history alone:
#   1. Possibly stale  — a doc references a repo file that was committed AFTER
#      the doc's own last change (the doc may describe code that since moved).
#   2. Broken refs     — a backticked repo path in a doc no longer exists.
#
# L0 = OBSERVE ONLY. No LLM, no secrets, no edits, no network. It writes a report
# (stdout + GitHub step summary) and exits 0. A human reads it and acts — or the
# loop gets promoted to L1 once it is boring and reliable. See the loop-engineering
# skill for levels and the safety model.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 2

ts() { git log -1 --format=%ct -- "$1" 2>/dev/null; }

flagged=""; broken=""; nf=0; nb=0; nd=0
while IFS= read -r doc; do
  [ -f "$doc" ] || continue
  case "$doc" in
    *templates/*|*demo/*|*CHANGELOG*|*BACKLOG*|PHASE[0-9]*.md|.claude/*) continue ;;
  esac
  nd=$((nd + 1))
  dts=$(ts "$doc"); [ -n "$dts" ] || continue
  newer=""
  while IFS= read -r ref; do
    [ -n "$ref" ] || continue
    case "$ref" in *'*'*|*NNNN*|scripts/bin/*) continue ;; esac
    if [ ! -e "$ref" ]; then
      broken+="  - \`$doc\` → missing \`$ref\`"$'\n'; nb=$((nb + 1)); continue
    fi
    # Staleness signal only for DESCRIBED CODE — skip directory pointers and
    # doc→doc cross-links (a linked doc changing does not make this doc stale).
    case "$ref" in */|*.md) continue ;; esac
    rts=$(ts "$ref"); [ -n "$rts" ] || continue
    [ "$rts" -gt "$dts" ] && newer="$newer \`$ref\`"
  done < <(grep -oE '`(docs|scripts|crates|\.github)/[A-Za-z0-9_./-]+`' "$doc" 2>/dev/null \
            | tr -d '`' | sed -E 's/[.,):]+$//' | sort -u)
  if [ -n "$newer" ]; then
    flagged+="  - \`$doc\` (last changed $(git log -1 --format=%cd --date=short -- "$doc")) → references newer:$newer"$'\n'
    nf=$((nf + 1))
  fi
done < <(git ls-files '*.md' 2>/dev/null | sort -u)

out="${LOOP_REPORT_FILE:-/tmp/docs-sweep-report.md}"
{
  echo "# 📋 Docs drift report — loop:docs-sweep (L0 report-only)"
  echo
  echo "_rev $(git rev-parse --short HEAD) · scanned $nd docs · $(git log -1 --format=%cd --date=short)_"
  echo
  echo "## Possibly stale: $nf"
  echo "A doc references a repo file committed *after* the doc's own last change."
  echo
  if [ "$nf" -gt 0 ]; then printf '%s' "$flagged"; else echo "_none — docs track the code 🎉_"; fi
  echo
  echo "## Broken references: $nb"
  echo
  if [ "$nb" -gt 0 ]; then printf '%s' "$broken"; else echo "_none 🎉_"; fi
  echo
  echo "---"
  echo "_L0 loop: **report only** — no files were edited. Verify each item, then fix"
  echo "manually or promote this loop to L1 (drafts a PR) once it is reliable._"
} > "$out"

cat "$out"
[ -n "${GITHUB_STEP_SUMMARY:-}" ] && cat "$out" >> "$GITHUB_STEP_SUMMARY"
[ -n "${GITHUB_OUTPUT:-}" ] && echo "has_findings=$([ $((nf + nb)) -gt 0 ] && echo true || echo false)" >> "$GITHUB_OUTPUT"
exit 0
