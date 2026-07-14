#!/usr/bin/env bash
# Fail closed if ComplianceCorpus contains unlisted Lean `axiom` declarations (W7.C5).
# Allowlist: script/systems-tcb-axiom-allowlist.txt (paths relative to lean4 root).
#
# Scope: **ComplianceCorpus only** (script/systems-compliance-corpus.txt). This is not a
# full PRODUCT_STDLIB walk; modules outside the corpus are not axiom-gated here.
# PRODUCT ↔ corpus membership is systems-product-stdlib-check.sh (PRODUCT_CORPUS_ALIGN_OK).
#
# Grep status: no-match (1) is OK; tool/errors (≥2 or missing grep) are FAIL — never
# vacuous AXIOM_AUTO_GATE_OK=1 on scan failure.
#
# Empty corpus + empty allowlist ⇒ PASS (layout OK). That alone does **not** claim the
# product TCB is axiom-free; freestanding FFI axioms live under allowlisted corpus paths.
#
# Allowlist grammar:
#   path/to/File.lean              — path-only INTENTIONAL_TCB_PATH_ALLOW (any axiom)
#   path/to/File.lean name=Ident   — name pin (silent TCB growth blocked for other names)
# Dual path-only + name= for the **same path** is rejected (path-only would nullify pins).
#
# Orphan name= pins (pin without a matching source axiom) are **intentional one-way**:
# allowlist may be a superset of current decls (pre-pin / residual lock). AxiomAuto only
# fails on unlisted *source* axioms, not unused pins. Documented; not a silent fail-open
# for new axioms (those still need a pin or path-only).
#
# Parser SSoT: script/systems-axiom-lib.sh (shared with product-stdlib-check).
#
# Usage: ./script/systems-axiom-check.sh
#        SYSTEMS_LEAN_COMPLIANCE_CORPUS=path \
#        SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST=path \
#        ./script/systems-axiom-check.sh
#
# Greppable success: AXIOM_AUTO_GATE_OK=1
# Greppable failure: AXIOM_AUTO_GATE_OK=0
# Greppable pin inventory:
#   AXIOM_ALLOWLIST_PATH_ONLY_COUNT=N   # INTENTIONAL_TCB_PATH_ALLOW path entries
#   AXIOM_ALLOWLIST_NAME_PIN_COUNT=N    # path name=Ident pins (B1 silent-growth lock)
# Pin counts: allowlist is parsed before corpus layout checks when the allowlist file
# exists, so missing-corpus FAIL still emits accurate counts. Missing allowlist ⇒ 0.
# FAIL detail lines are printed on both stdout and stderr (merged 2>&1 still greppable).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CORPUS="${SYSTEMS_LEAN_COMPLIANCE_CORPUS:-$ROOT/script/systems-compliance-corpus.txt}"
ALLOWLIST="${SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST:-$ROOT/script/systems-tcb-axiom-allowlist.txt}"
# shellcheck source=systems-axiom-lib.sh
source "$ROOT/script/systems-axiom-lib.sh"

# Print FAIL on stdout + stderr so tokens and details are greppable under either stream.
fail_line() {
  printf 'FAIL: %s\n' "$*"
  printf 'FAIL: %s\n' "$*" >&2
}

emit_allowlist_counts() {
  local pc=0 nc=0
  if declare -p ALLOW_PATH >/dev/null 2>&1; then
    pc=${#ALLOW_PATH[@]}
  fi
  if declare -p ALLOW_NAME >/dev/null 2>&1; then
    nc=${#ALLOW_NAME[@]}
  fi
  echo "AXIOM_ALLOWLIST_PATH_ONLY_COUNT=$pc"
  echo "AXIOM_ALLOWLIST_NAME_PIN_COUNT=$nc"
}

fail_gate() {
  echo "AXIOM_AUTO_GATE_OK=0"
  emit_allowlist_counts
  fail_line "$*"
  exit 1
}

# Declare pin maps before any fail_gate so emit_allowlist_counts never hits unset arrays.
# path-only allow entries (any axiom in file — intentional TCB growth inside that path)
declare -A ALLOW_PATH=()
# path+name allow entries (key: "path"$'\t'"name")
declare -A ALLOW_NAME=()
# paths that have at least one name= pin (for dual-entry detection)
declare -A ALLOW_NAME_PATHS=()

if ! command -v grep >/dev/null 2>&1; then
  fail_gate "grep not found on PATH (tool/layout)"
fi

# Parse allowlist before corpus layout checks when the file exists so early FAIL
# (e.g. missing corpus) still emits accurate PATH_ONLY / NAME_PIN counts.
# Missing allowlist ⇒ fail with counts=0 (cannot parse).
if [[ ! -f "$ALLOWLIST" ]]; then
  fail_gate "missing TCB axiom allowlist $ALLOWLIST (tool/layout)"
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
  # trim leading/trailing whitespace
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [[ -z "$line" ]] && continue
  if [[ "$line" =~ ^([^[:space:]]+)[[:space:]]+name=([^[:space:]]+)$ ]]; then
    p="${BASH_REMATCH[1]}"
    n="${BASH_REMATCH[2]}"
    ALLOW_NAME["$p"$'\t'"$n"]=1
    ALLOW_NAME_PATHS["$p"]=1
  elif [[ "$line" =~ [[:space:]] ]]; then
    fail_gate "bad allowlist entry (expected 'path' or 'path name=Ident'): $line"
  else
    ALLOW_PATH["$line"]=1
  fi
done < "$ALLOWLIST"

# Dual path-only + name= for the same path nullifies pins (path-only wins at check time).
# Fail closed so silent TCB growth cannot be re-opened by a stray path-only line.
for p in "${!ALLOW_NAME_PATHS[@]}"; do
  if [[ -n "${ALLOW_PATH[$p]:-}" ]]; then
    fail_gate "dual allowlist entry for $p (path-only + name=); remove one mode (path-only nullifies name pins)"
  fi
done

if [[ ! -f "$CORPUS" ]]; then
  fail_gate "missing ComplianceCorpus list $CORPUS (tool/layout)"
fi

axiom_allowed() {
  local rel="$1" name="$2"
  if [[ -n "${ALLOW_PATH[$rel]:-}" ]]; then
    return 0
  fi
  if [[ -n "$name" && -n "${ALLOW_NAME[$rel$'\t'$name]:-}" ]]; then
    return 0
  fi
  return 1
}

bad=0
found=0
grep_err="$(mktemp)"
trap 'rm -f "$grep_err"' EXIT

while IFS= read -r rel || [[ -n "$rel" ]]; do
  [[ -z "$rel" || "$rel" =~ ^[[:space:]]*# ]] && continue
  rel="${rel#"${rel%%[![:space:]]*}"}"
  rel="${rel%"${rel##*[![:space:]]}"}"
  [[ -z "$rel" ]] && continue
  f="$ROOT/$rel"
  if [[ ! -f "$f" ]]; then
    fail_line "corpus path missing: $rel"
    bad=1
    continue
  fi
  if [[ ! -r "$f" ]]; then
    fail_line "corpus path unreadable: $rel"
    bad=1
    continue
  fi

  set +e
  hits="$(grep -nE "$SYSTEMS_LEAN_AXIOM_LINE_RE" "$f" 2>"$grep_err")"
  grc=$?
  set -e
  if [[ "$grc" -eq 0 ]]; then
    :
  elif [[ "$grc" -eq 1 ]]; then
    hits=""
  else
    gerr="$(tr '\n' ' ' <"$grep_err" | head -c 200 || true)"
    fail_line "grep scan failed for $rel (exit $grc)${gerr:+: $gerr}"
    bad=1
    continue
  fi

  while IFS= read -r hit || [[ -n "${hit:-}" ]]; do
    [[ -z "${hit:-}" ]] && continue
    lineno="${hit%%:*}"
    content="${hit#*:}"
    # Whole-line comments only (fail-closed on mixed code+comment lines).
    if [[ "$content" =~ ^[[:space:]]*-- ]]; then
      continue
    fi
    # Prose/docs mentioning the word "axiom" without a declaration shape — skip.
    if ! systems_lean_is_axiom_decl_line "$content"; then
      continue
    fi
    found=$((found + 1))
    name="$(systems_lean_extract_axiom_name "$content")"
    if axiom_allowed "$rel" "$name"; then
      continue
    fi
    if [[ -n "$name" ]]; then
      fail_line "unlisted axiom in ComplianceCorpus: $rel:$lineno name=$name"
    else
      fail_line "unlisted axiom in ComplianceCorpus: $rel:$lineno (unparsed name)"
      printf '  %s\n' "$content"
      printf '  %s\n' "$content" >&2
    fi
    bad=1
  done <<<"$hits"
done < "$CORPUS"

if [[ "$bad" -ne 0 ]]; then
  echo "AXIOM_AUTO_GATE_OK=0"
  emit_allowlist_counts
  fail_line "AxiomAutoGate(ComplianceCorpus) violated (unlisted axiom or incomplete corpus)"
  exit 1
fi

echo "AXIOM_AUTO_GATE_OK=1"
emit_allowlist_counts
echo "OK: AxiomAutoGate(ComplianceCorpus) — $found axiom decl(s) checked, all allowlisted or none present ($CORPUS)"
echo "OK: allowlist pins path-only=${#ALLOW_PATH[@]} name=${#ALLOW_NAME[@]} (INTENTIONAL_TCB_PATH_ALLOW for path-only dense FFI; orphan name= pins intentional one-way)"
exit 0
