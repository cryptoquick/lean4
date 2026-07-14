#!/usr/bin/env bash
# Fail closed if ComplianceCorpus contains `sorry` or `admit` (W7.C4).
# Usage: ./script/systems-sorry-free-check.sh
#        SYSTEMS_LEAN_COMPLIANCE_CORPUS=path ./script/systems-sorry-free-check.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CORPUS="${SYSTEMS_LEAN_COMPLIANCE_CORPUS:-$ROOT/script/systems-compliance-corpus.txt}"

if [[ ! -f "$CORPUS" ]]; then
  echo "FAIL: missing ComplianceCorpus list $CORPUS (tool/layout)" >&2
  exit 1
fi

# Match bare `sorry` / `admit` as Lean tactics/keywords (not words inside comments only —
# grepping comments is acceptable fail-closed; use `# sorry` never in corpus files).
PAT='(^|[^A-Za-z_])(sorry|admit)([^A-Za-z_]|$)'

bad=0
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
  f="$ROOT/$line"
  if [[ ! -f "$f" ]]; then
    echo "FAIL: corpus path missing: $line" >&2
    bad=1
    continue
  fi
  if grep -nE "$PAT" "$f" >/dev/null 2>&1; then
    echo "FAIL: sorry/admit in ComplianceCorpus file: $line" >&2
    grep -nE "$PAT" "$f" >&2 || true
    bad=1
  fi
done < "$CORPUS"

if [[ "$bad" -ne 0 ]]; then
  echo "FAIL: SorryFree(ComplianceCorpus) violated" >&2
  exit 1
fi

echo "OK: ComplianceCorpus is sorry/admit free ($CORPUS)"
exit 0
