#!/usr/bin/env bash
# Systems Lean G2: greppable linear residual / mult-policy metrics (fail-closed).
#
# Verifies **source artifacts** for definitional Mult free-safety policy (not log
# lines alone, not elaborator completeness, not GC_FREE_ELABORATOR=1):
#   * linear exact-once / second-use impossible (`linear_exact_once_second_use`)
#   * mult-0 / zero-qty erased / non-runtime (`zero_qty_*`)
#   * product residual mult policy marker (`productResidualMultPolicyChecked`)
#   * free-safety formal layer + algebra markers
#   * linear no silent-drop (`linear_must_consume` / mayDiscard .one = false)
#
# Greps run on a **comment-stripped snapshot** of each source (line `--` and block
# `/- … -/` removed) so comment-only forges cannot PASS. Marker defs are checked
# as structured regions that must bind real witnesses (not free `true`).
# Identifier/lemma witnesses are matched after **string-literal strip** so
# `"linear_exact_once_second_use"` cannot stand in for a real binding.
# Claim inventory intentionally matches quoted `claim=…` strings (real code form).
#
# Success tokens (stdout, exact-line; only after all checks pass):
#   LINEAR_SECOND_USE_IMPOSSIBLE=1
#   MULT0_NON_RUNTIME_POLICY=1
#   PRODUCT_RESIDUAL_MULT_POLICY=1
#   LINEAR_NO_SILENT_DROP=1
#   FREE_SAFETY_FORMAL_LAYER=1
#   LINEAR_RESIDUAL_METRICS_OK=1
# Failure: exit ≠ 0, all tokens =0, FAIL: lines on stderr.
#
# Product paths (default / validate):
#   Always pin $ROOT/src/Lean/Compiler/{Multiplicity,QTT/FreeSafety,QTT/Theorems}.lean
#   Ambient SYSTEMS_LEAN_LINEAR_METRICS_{MULT,FREESAFETY,THEOREMS} are **ignored**
#   unless SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE=1 (negatives / disposable trees).
#
# Usage (lean4 root):
#   ./script/systems-linear-residual-metrics.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PRODUCT_MULT="$ROOT/src/Lean/Compiler/Multiplicity.lean"
PRODUCT_FS="$ROOT/src/Lean/Compiler/QTT/FreeSafety.lean"
PRODUCT_THM="$ROOT/src/Lean/Compiler/QTT/Theorems.lean"

# Resolve a path to absolute when possible.
abspath() {
  local p="$1"
  if command -v realpath >/dev/null 2>&1 && [[ -e "$p" ]]; then
    realpath "$p"
  elif [[ -e "$p" ]]; then
    (cd "$(dirname "$p")" && echo "$(pwd)/$(basename "$p")")
  else
    echo "$p"
  fi
}

PRODUCT_MULT="$(abspath "$PRODUCT_MULT")"
PRODUCT_FS="$(abspath "$PRODUCT_FS")"
PRODUCT_THM="$(abspath "$PRODUCT_THM")"

ALLOW_OVERRIDE="${SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE:-0}"
if [[ "$ALLOW_OVERRIDE" == "1" ]]; then
  MULT="$(abspath "${SYSTEMS_LEAN_LINEAR_METRICS_MULT:-$PRODUCT_MULT}")"
  FS="$(abspath "${SYSTEMS_LEAN_LINEAR_METRICS_FREESAFETY:-$PRODUCT_FS}")"
  THM="$(abspath "${SYSTEMS_LEAN_LINEAR_METRICS_THEOREMS:-$PRODUCT_THM}")"
else
  # Product / validate path: pin real src paths; refuse ambient overrides.
  if [[ -n "${SYSTEMS_LEAN_LINEAR_METRICS_MULT:-}" \
     || -n "${SYSTEMS_LEAN_LINEAR_METRICS_FREESAFETY:-}" \
     || -n "${SYSTEMS_LEAN_LINEAR_METRICS_THEOREMS:-}" ]]; then
    echo "NOTE: ignoring SYSTEMS_LEAN_LINEAR_METRICS_* overrides (set SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE=1 for disposable trees)" >&2
  fi
  MULT="$PRODUCT_MULT"
  FS="$PRODUCT_FS"
  THM="$PRODUCT_THM"
fi

# Sub-check status (0/1).
ok_second_use=0
ok_mult0=0
ok_product=0
ok_silent=0
ok_layer=0
status=0

# FAIL diagnostics: stderr only (tokens stay on stdout; no duplicate streams).
fail_line() {
  printf 'FAIL: %s\n' "$*" >&2
  status=1
}

ok_line() {
  printf 'OK: %s\n' "$*" >&2
}

# --- Comment-stripped code snapshot (Issue 1 + Issue 8: single read per file) ---
# Snapshots stored as files under a private temp dir for multi-grep without re-read races.
SNAP_DIR=""
cleanup_snap() {
  if [[ -n "${SNAP_DIR:-}" && -d "$SNAP_DIR" ]]; then
    rm -rf "$SNAP_DIR"
  fi
}
trap cleanup_snap EXIT

# Strip Lean block comments (/- … -/, /-- … -/, /-! … -/) then line comments (-- …).
# Keeps newlines so multi-line patterns remain greppable. Comment-only forges → empty code.
strip_lean_comments() {
  local src="$1"
  if command -v perl >/dev/null 2>&1; then
    # Non-greedy block comments; then strip -- to EOL (not inside already-removed blocks).
    perl -0777 -pe 's{/\-.*?\-/}{}sg; s/--[^\n]*//g' -- "$src"
  else
    # Portable fallback: drop block-comment lines and -- line comments via sed/awk.
    # Multi-line block comments spanning many lines: best-effort with sed.
    sed -e 's|--.*||g' "$src" \
      | awk '
        BEGIN { inblk=0 }
        {
          line = $0
          out = ""
          while (length(line) > 0) {
            if (inblk) {
              if (match(line, /\-\//)) {
                line = substr(line, RSTART + RLENGTH)
                inblk = 0
              } else {
                line = ""
              }
            } else {
              if (match(line, /\/\-/)) {
                out = out substr(line, 1, RSTART - 1)
                line = substr(line, RSTART + 2)
                inblk = 1
              } else {
                out = out line
                line = ""
              }
            }
          }
          print out
        }
      '
  fi
}

# Load file once into SNAP_DIR/<tag>.code (comment-stripped).
# Sets global: SNAP_<tag> path. Returns 1 if missing/empty source.
load_snap() {
  local tag="$1" src="$2"
  local out="$SNAP_DIR/${tag}.code"
  if [[ ! -f "$src" ]]; then
    return 1
  fi
  if [[ ! -s "$src" ]]; then
    return 2
  fi
  strip_lean_comments "$src" >"$out"
  # Fail closed if snapshot is empty after strip (comment-only forge).
  if [[ ! -s "$out" ]]; then
    return 3
  fi
  # Export path via nameref-ish globals
  case "$tag" in
    mult) SNAP_MULT="$out" ;;
    fs)   SNAP_FS="$out" ;;
    thm)  SNAP_THM="$out" ;;
  esac
  return 0
}

# Grep comment-stripped snapshot (ERE by default; -F for fixed).
code_grep() {
  local snap="$1" pat="$2" mode="${3:--E}"
  [[ -f "$snap" ]] || return 1
  if [[ "$mode" == "-F" ]]; then
    grep -qF -- "$pat" "$snap"
  else
    grep -qE -- "$pat" "$snap"
  fi
}

# Extract def/theorem region for NAME from snapshot into stdout.
# Region: from line matching def/theorem NAME through next top-level def/theorem/end/namespace.
extract_region() {
  local snap="$1" name="$2"
  [[ -f "$snap" ]] || return 1
  awk -v name="$name" '
    BEGIN { take=0 }
    {
      if (!take) {
        if ($0 ~ "(public[[:space:]]+|private[[:space:]]+|protected[[:space:]]+)?(def|theorem|abbrev)[[:space:]]+" name "([^A-Za-z0-9_]|$)") {
          take=1
          print
          next
        }
      } else {
        if ($0 ~ /^(public[[:space:]]+|private[[:space:]]+|protected[[:space:]]+)?(def|theorem|abbrev)[[:space:]]+/ \
            || $0 ~ /^end([[:space:]]|$)/ \
            || $0 ~ /^namespace[[:space:]]/ \
            || $0 ~ /^section[[:space:]]/ \
            || $0 ~ /^#/) {
          exit
        }
        print
      }
    }
  ' "$snap"
}

# Strip double- and single-quoted string literals (best-effort escapes) so witness
# greps cannot match lemma names that only appear inside strings.
strip_string_literals() {
  if command -v perl >/dev/null 2>&1; then
    perl -pe 's/"(?:\\.|[^"\\])*"/""/g; s/'\''(?:\\.|[^'\''\\])*'\''/'\'''\''/g'
  else
    sed -E 's/"([^"\\]|\\.)*"/""/g; s/'\''([^'\''\\]|\\.)*'\''/'\'''\''/g'
  fi
}

# True if region has a real have-binding to a lemma/ident (not true/false).
# Handles multi-line Lean style: `have _ : Prop := lemma` spanning several lines.
region_has_real_have_lemma() {
  local region_ids="$1"
  local flat
  flat="$(printf '%s\n' "$region_ids" | tr '\n' ' ' | tr -s '[:space:]' ' ')"
  if command -v perl >/dev/null 2>&1; then
    if printf '%s' "$flat" | perl -ne '
      while (/have\s+_(.*?)(?=have\s+_|$)/sg) {
        my $b = $1;
        while ($b =~ /:=\s*([A-Za-z_][A-Za-z0-9_'\''\.]*)/g) {
          my $id = $1;
          exit 0 if $id ne "true" && $id ne "false";
        }
      }
      exit 1;
    '; then
      return 0
    fi
    return 1
  fi
  # Portable fallback: strip vacuous := true/false then look for have _ … := Ident.
  local stripped
  stripped="$(printf '%s' "$flat" | sed -E 's/:=[[:space:]]*(true|false)//g')"
  printf '%s' "$stripped" | grep -qE 'have[[:space:]]+_.*:=[[:space:]]*[A-Za-z_][A-Za-z0-9_'\''\.]*'
}

# True if region for NAME exists, is not free true/false, and contains all witness patterns.
# Identifier witnesses are grepped on string-stripped region text.
# Args: snap name [witness_ere ...]
require_def_witnesses() {
  local snap="$1" name="$2"
  shift 2
  local region region_ids w
  region="$(extract_region "$snap" "$name" || true)"
  if [[ -z "${region//[[:space:]]/}" ]]; then
    fail_line "missing def/theorem region for $name (code lines)"
    return 1
  fi
  region_ids="$(printf '%s\n' "$region" | strip_string_literals)"

  local has_have=0 has_real_have=0 has_and=0 bare=0
  if printf '%s\n' "$region_ids" | grep -qE 'have[[:space:]]+_'; then
    has_have=1
  fi
  if region_has_real_have_lemma "$region_ids"; then
    has_real_have=1
  fi
  if printf '%s\n' "$region_ids" | grep -qE '&&'; then
    has_and=1
  fi

  # Vacuous have _ := true without a real lemma binding is free-true (fail-closed).
  if [[ "$has_have" -eq 1 && "$has_real_have" -eq 0 ]]; then
    fail_line "marker $name has only vacuous have _ := true/false (no lemma binding)"
    return 1
  fi

  # Bare free true/false: := true/false without real have-lemma and without && chain.
  if printf '%s\n' "$region_ids" | grep -qE ':[[:space:]]*Bool[[:space:]]*:=[[:space:]]*(true|false)[[:space:]]*$' \
    || printf '%s\n' "$region_ids" | grep -qE ':=[[:space:]]*(true|false)[[:space:]]*$'; then
    if [[ "$has_real_have" -eq 0 && "$has_and" -eq 0 ]]; then
      bare=1
    fi
  fi
  if [[ "$bare" -eq 1 ]]; then
    fail_line "marker $name is free true/false without witnesses"
    return 1
  fi

  for w in "$@"; do
    if ! printf '%s\n' "$region_ids" | grep -qE -- "$w"; then
      fail_line "marker $name missing witness /$w/ in def region (code, not strings)"
      return 1
    fi
  done
  return 0
}

# Claim strings live in quoted form in real FreeSafety code; match intentionally
# on the region *with* string literals (after comment strip only).
# Args: snap name claim1 claim2 ...
require_def_claim_strings() {
  local snap="$1" name="$2"
  shift 2
  local region c
  region="$(extract_region "$snap" "$name" || true)"
  if [[ -z "${region//[[:space:]]/}" ]]; then
    fail_line "missing def/theorem region for $name (code lines)"
    return 1
  fi
  # Reject free true for claim inventory.
  local region_ids
  region_ids="$(printf '%s\n' "$region" | strip_string_literals)"
  if printf '%s\n' "$region_ids" | grep -qE ':=[[:space:]]*(true|false)[[:space:]]*$' \
    && ! printf '%s\n' "$region_ids" | grep -qE '&&'; then
    fail_line "marker $name is free true/false without claim comparisons"
    return 1
  fi
  for c in "$@"; do
    # Real form: "claim=qtt_…"
    if ! printf '%s\n' "$region" | grep -qF "\"claim=${c}\"" \
      && ! printf '%s\n' "$region" | grep -qF "claim=${c}"; then
      fail_line "marker $name missing claim string claim=${c}"
      return 1
    fi
  done
  return 0
}

emit_tokens() {
  # Fail-closed: any check failure ⇒ all greppable tokens =0.
  local all_ok=0
  if [[ "$status" -eq 0 && "$ok_second_use" -eq 1 && "$ok_mult0" -eq 1 \
      && "$ok_product" -eq 1 && "$ok_silent" -eq 1 && "$ok_layer" -eq 1 ]]; then
    all_ok=1
  fi
  if [[ "$all_ok" -eq 1 ]]; then
    echo "LINEAR_SECOND_USE_IMPOSSIBLE=1"
    echo "MULT0_NON_RUNTIME_POLICY=1"
    echo "PRODUCT_RESIDUAL_MULT_POLICY=1"
    echo "LINEAR_NO_SILENT_DROP=1"
    echo "FREE_SAFETY_FORMAL_LAYER=1"
    echo "LINEAR_RESIDUAL_METRICS_OK=1"
  else
    echo "LINEAR_SECOND_USE_IMPOSSIBLE=0"
    echo "MULT0_NON_RUNTIME_POLICY=0"
    echo "PRODUCT_RESIDUAL_MULT_POLICY=0"
    echo "LINEAR_NO_SILENT_DROP=0"
    echo "FREE_SAFETY_FORMAL_LAYER=0"
    echo "LINEAR_RESIDUAL_METRICS_OK=0"
  fi
}

echo "=== Systems Lean linear residual metrics (G2 mult-policy) ===" >&2
echo "multiplicity: $MULT" >&2
echo "freesafety:   $FS" >&2
echo "theorems:     $THM" >&2
echo "allow_override: $ALLOW_OVERRIDE" >&2

if ! command -v grep >/dev/null 2>&1; then
  fail_line "grep not found on PATH (tool/layout)"
  emit_tokens
  exit 1
fi

SNAP_DIR="$(mktemp -d)"
SNAP_MULT=""
SNAP_FS=""
SNAP_THM=""

# --- Layout: real source files (not a log we just printed) ---
load_mult_rc=0
load_fs_rc=0
load_thm_rc=0
set +e
load_snap mult "$MULT"; load_mult_rc=$?
load_snap fs "$FS"; load_fs_rc=$?
load_snap thm "$THM"; load_thm_rc=$?
set -e

for pair in "mult:$MULT:$load_mult_rc" "fs:$FS:$load_fs_rc" "thm:$THM:$load_thm_rc"; do
  tag="${pair%%:*}"
  rest="${pair#*:}"
  path="${rest%:*}"
  rc="${rest##*:}"
  case "$rc" in
    0) ;;
    1) fail_line "missing linear residual source artifact: $path" ;;
    2) fail_line "empty linear residual source artifact: $path" ;;
    3) fail_line "comment-only / empty code after strip: $path" ;;
    *) fail_line "failed to snapshot $path (rc=$rc)" ;;
  esac
done
if [[ "$status" -ne 0 ]]; then
  emit_tokens
  exit 1
fi

# ---------------------------------------------------------------------------
# 1) Linear exact-once / second-use impossible
# ---------------------------------------------------------------------------
second_bad=0
if ! code_grep "$SNAP_MULT" 'private[[:space:]]+theorem[[:space:]]+linear_exact_once_second_use'; then
  fail_line "missing private theorem linear_exact_once_second_use in Multiplicity.lean"
  second_bad=1
fi
if ! code_grep "$SNAP_MULT" 'useOnce[[:space:]]+\.one\)\.bind[[:space:]]+Multiplicity\.useOnce[[:space:]]*=[[:space:]]*none'; then
  fail_line "linear_exact_once_second_use missing useOnce one then second use = none"
  second_bad=1
fi
# freeSafetyChecked must witness the lemma in its def region (not free true / comment).
if ! require_def_witnesses "$SNAP_MULT" freeSafetyChecked \
    'linear_exact_once_second_use' \
    'have[[:space:]]+_'; then
  second_bad=1
fi
# productResidualMultPolicyChecked also witnesses second-use.
if ! require_def_witnesses "$SNAP_MULT" productResidualMultPolicyChecked \
    'linear_exact_once_second_use' \
    'product_residual_mult_policy' \
    'have[[:space:]]+_'; then
  second_bad=1
fi
if ! code_grep "$SNAP_FS" 'def[[:space:]]+linearExactOncePolicy' || \
   ! code_grep "$SNAP_FS" 'def[[:space:]]+linearExactOnceChain'; then
  fail_line "FreeSafety missing linearExactOncePolicy / linearExactOnceChain"
  second_bad=1
fi
if ! require_def_witnesses "$SNAP_FS" linearExactOncePolicy \
    'useOnce[[:space:]]+\.one' \
    'useOnce[[:space:]]*==[[:space:]]*none|bind[[:space:]]+Multiplicity\.useOnce[[:space:]]*==[[:space:]]*none'; then
  second_bad=1
fi
if ! require_def_witnesses "$SNAP_FS" linearExactOnceChain \
    'useOnce[[:space:]]+\.one' \
    'bind[[:space:]]+Multiplicity\.useOnce[[:space:]]*==[[:space:]]*none'; then
  second_bad=1
fi
if [[ "$second_bad" -eq 0 ]]; then
  ok_second_use=1
  ok_line "linear exact-once / second-use impossible (Multiplicity + FreeSafety)"
fi

# ---------------------------------------------------------------------------
# 2) Mult-0 / zero-qty erased / non-runtime
# ---------------------------------------------------------------------------
mult0_bad=0
if ! code_grep "$SNAP_MULT" 'private[[:space:]]+theorem[[:space:]]+zero_qty_erased_policy'; then
  fail_line "missing private theorem zero_qty_erased_policy"
  mult0_bad=1
fi
if ! code_grep "$SNAP_MULT" 'private[[:space:]]+theorem[[:space:]]+zero_qty_implies_non_runtime'; then
  fail_line "missing private theorem zero_qty_implies_non_runtime"
  mult0_bad=1
fi
for cell in \
  'isErased[[:space:]]+\.zero[[:space:]]*=[[:space:]]*true' \
  'isRuntime[[:space:]]+\.zero[[:space:]]*=[[:space:]]*false' \
  'useOnce[[:space:]]+\.zero[[:space:]]*=[[:space:]]*none'
do
  if ! code_grep "$SNAP_MULT" "$cell"; then
    fail_line "mult-0 policy missing cell /$cell/ in Multiplicity.lean"
    mult0_bad=1
  fi
done
if ! require_def_witnesses "$SNAP_MULT" freeSafetyChecked \
    'zero_qty_erased_policy' \
    'zero_qty_implies_non_runtime'; then
  mult0_bad=1
fi
if ! require_def_witnesses "$SNAP_MULT" productResidualMultPolicyChecked \
    'zero_qty_erased_policy' \
    'zero_qty_implies_non_runtime'; then
  mult0_bad=1
fi
if ! code_grep "$SNAP_FS" 'def[[:space:]]+zeroQtyErasedPolicy' || \
   ! code_grep "$SNAP_FS" 'def[[:space:]]+zeroQtyNonRuntimePolicy'; then
  fail_line "FreeSafety missing zeroQtyErasedPolicy / zeroQtyNonRuntimePolicy"
  mult0_bad=1
fi
if ! require_def_witnesses "$SNAP_FS" zeroQtyNonRuntimePolicy \
    'isErased|zeroQtyErasedPolicy' \
    'isRuntime|mayDiscard'; then
  mult0_bad=1
fi
if [[ "$mult0_bad" -eq 0 ]]; then
  ok_mult0=1
  ok_line "mult-0 / zero-qty erased / non-runtime policy (Multiplicity + FreeSafety)"
fi

# ---------------------------------------------------------------------------
# 3) Product residual mult policy marker
# ---------------------------------------------------------------------------
prod_bad=0
if ! code_grep "$SNAP_MULT" 'def[[:space:]]+productResidualMultPolicyChecked'; then
  fail_line "missing public def productResidualMultPolicyChecked in Multiplicity.Theorems"
  prod_bad=1
fi
if ! code_grep "$SNAP_MULT" 'private[[:space:]]+theorem[[:space:]]+product_residual_mult_policy'; then
  fail_line "missing private theorem product_residual_mult_policy"
  prod_bad=1
fi
# Structured: product marker region must bind product_residual_mult_policy (not free true).
if ! require_def_witnesses "$SNAP_MULT" productResidualMultPolicyChecked \
    'product_residual_mult_policy' \
    'linear_exact_once_second_use' \
    'zero_qty_implies_non_runtime' \
    'have[[:space:]]+_'; then
  prod_bad=1
fi
if ! code_grep "$SNAP_MULT" 'def[[:space:]]+freeSafetyChecked'; then
  fail_line "missing public def freeSafetyChecked"
  prod_bad=1
fi
if ! code_grep "$SNAP_MULT" 'def[[:space:]]+algebraChecked'; then
  fail_line "missing public def algebraChecked"
  prod_bad=1
fi
# algebraChecked must not be free true (has have-witnesses for tables).
if ! require_def_witnesses "$SNAP_MULT" algebraChecked 'have[[:space:]]+_'; then
  prod_bad=1
fi
if ! code_grep "$SNAP_FS" 'def[[:space:]]+productResidualMultPolicyChecked'; then
  fail_line "FreeSafety missing productResidualMultPolicyChecked re-export"
  prod_bad=1
fi
# FreeSafety re-export must point at Multiplicity.Theorems (not free true).
if ! require_def_witnesses "$SNAP_FS" productResidualMultPolicyChecked \
    'Multiplicity\.Theorems\.productResidualMultPolicyChecked'; then
  prod_bad=1
fi
if ! code_grep "$SNAP_THM" 'def[[:space:]]+productResidualMultPolicyChecked'; then
  fail_line "QTT.Theorems missing productResidualMultPolicyChecked re-export"
  prod_bad=1
fi
if ! require_def_witnesses "$SNAP_THM" productResidualMultPolicyChecked \
    'Multiplicity\.Theorems\.productResidualMultPolicyChecked'; then
  prod_bad=1
fi
if ! code_grep "$SNAP_FS" 'def[[:space:]]+productFreeSafetyPolicies'; then
  fail_line "FreeSafety missing productFreeSafetyPolicies bundle"
  prod_bad=1
fi
if ! require_def_witnesses "$SNAP_FS" productFreeSafetyPolicies \
    'linearExactOncePolicy' \
    'zeroQtyErasedPolicy|zeroQtyNonRuntimePolicy'; then
  prod_bad=1
fi
if [[ "$prod_bad" -eq 0 ]]; then
  ok_product=1
  ok_line "product residual mult policy marker greppable (Mult + FreeSafety + Theorems)"
fi

# ---------------------------------------------------------------------------
# 4) Linear no silent-drop (mayDiscard .one polarity = false / !mayDiscard)
# ---------------------------------------------------------------------------
silent_bad=0
if ! code_grep "$SNAP_MULT" 'private[[:space:]]+theorem[[:space:]]+linear_must_consume'; then
  fail_line "missing private theorem linear_must_consume (no silent-drop)"
  silent_bad=1
fi
if ! code_grep "$SNAP_MULT" 'mayDiscard[[:space:]]+\.one[[:space:]]*=[[:space:]]*false'; then
  fail_line "linear silent-drop policy missing mayDiscard .one = false"
  silent_bad=1
fi
if ! require_def_witnesses "$SNAP_MULT" freeSafetyChecked 'linear_must_consume'; then
  silent_bad=1
fi
# FreeSafety polarity: !mayDiscard .one  OR  mayDiscard .one = false / == false
if ! code_grep "$SNAP_FS" '(![[:space:]]*Multiplicity\.mayDiscard[[:space:]]+\.one|mayDiscard[[:space:]]+\.one[[:space:]]*(=|==)[[:space:]]*false)'; then
  fail_line "FreeSafety missing mayDiscard .one = false / !mayDiscard polarity"
  silent_bad=1
fi
if [[ "$silent_bad" -eq 0 ]]; then
  ok_silent=1
  ok_line "linear no silent-drop (mayDiscard one = false)"
fi

# ---------------------------------------------------------------------------
# 5) Joint free-safety formal layer
# ---------------------------------------------------------------------------
layer_bad=0
if ! code_grep "$SNAP_FS" 'def[[:space:]]+freeSafetyFormalLayerChecked'; then
  fail_line "missing public def freeSafetyFormalLayerChecked"
  layer_bad=1
fi
# Structured region: full joint conjuncts (incl. claimInventory + omegaRepeatedUseStable).
if ! require_def_witnesses "$SNAP_FS" freeSafetyFormalLayerChecked \
    'Multiplicity\.Theorems\.freeSafetyChecked' \
    'Multiplicity\.Theorems\.algebraChecked' \
    'Multiplicity\.Theorems\.productResidualMultPolicyChecked' \
    'claimInventoryChecked' \
    'productFreeSafetyPolicies' \
    'omegaRepeatedUseStable' \
    'linearExactOnceChain' \
    'memsafeFreeSafetyClaimsPresent'; then
  layer_bad=1
fi
# Claim strings: real code uses "claim=qtt_…" string comparisons (intentional).
if ! require_def_claim_strings "$SNAP_FS" memsafeFreeSafetyClaimsPresent \
    'qtt_linear_resources_exact_once' \
    'qtt_zero_quantity_erased' \
    'qtt_omega_unrestricted_scalars'; then
  layer_bad=1
fi
if [[ "$layer_bad" -eq 0 ]]; then
  ok_layer=1
  ok_line "freeSafetyFormalLayerChecked joint marker (Mult + host policies + claims)"
fi

# ---------------------------------------------------------------------------
# Emit tokens
# ---------------------------------------------------------------------------
if [[ "$ok_second_use" -ne 1 || "$ok_mult0" -ne 1 || "$ok_product" -ne 1 \
    || "$ok_silent" -ne 1 || "$ok_layer" -ne 1 ]]; then
  status=1
fi

emit_tokens

if [[ "$status" -eq 0 ]]; then
  echo "receipt: linear residual mult-policy metrics verified on source markers" >&2
  echo "honesty: Mult/FreeSafety definitional policy only — not UseCheck completeness, not elaborator GC-free" >&2
  exit 0
fi
exit 1
