#!/usr/bin/env bash
# Negative / positive cases for systems-linear-residual-metrics.sh (G2, fail-closed).
#
# Ensures:
#   * Real product tree emits all six success tokens (clears ambient overrides)
#   * Missing / empty Multiplicity / FreeSafety / Theorems → FAIL + all tokens =0
#   * Stripped second-use / mult-0 / productResidualMultPolicyChecked → FAIL
#   * Forged free-true markers without witnesses → FAIL
#   * Comment-only forges → FAIL (comment strip)
#   * Free-true formal layer with comment conjuncts → FAIL
#   * Success tokens without real markers cannot pass (gate greps artifacts)
#   * Wrong failure class still produces FAIL: lines (not silent OK)
#   * Path overrides require SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE=1
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GATE="$ROOT/script/systems-linear-residual-metrics.sh"
chmod +x "$GATE" 2>/dev/null || true

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

SUCCESS_TOKENS=(
  LINEAR_SECOND_USE_IMPOSSIBLE=1
  MULT0_NON_RUNTIME_POLICY=1
  PRODUCT_RESIDUAL_MULT_POLICY=1
  LINEAR_NO_SILENT_DROP=1
  FREE_SAFETY_FORMAL_LAYER=1
  LINEAR_RESIDUAL_METRICS_OK=1
)
ZERO_TOKENS=(
  LINEAR_SECOND_USE_IMPOSSIBLE=0
  MULT0_NON_RUNTIME_POLICY=0
  PRODUCT_RESIDUAL_MULT_POLICY=0
  LINEAR_NO_SILENT_DROP=0
  FREE_SAFETY_FORMAL_LAYER=0
  LINEAR_RESIDUAL_METRICS_OK=0
)

# On failure: all six success tokens absent; all six =0 present.
assert_all_tokens_zero() {
  local name="$1" out="$2"
  local t
  for t in "${SUCCESS_TOKENS[@]}"; do
    if grep -qx "$t" "$out"; then
      echo "FAIL: case $name emitted success token $t on failure" >&2
      cat "$out" >&2
      exit 1
    fi
  done
  for t in "${ZERO_TOKENS[@]}"; do
    if ! grep -qx "$t" "$out"; then
      echo "FAIL: case $name missing fail-closed token $t" >&2
      cat "$out" >&2
      exit 1
    fi
  done
}

fail_case() {
  local name="$1"
  shift
  local expect_re=""
  if [[ "${1:-}" == "--expect" ]]; then
    expect_re="$2"
    shift 2
  fi
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  # Gate must exit exactly 1 (fail-closed); other non-zero is internal/tool error.
  if [[ $ec -ne 1 ]]; then
    echo "FAIL: expected exit 1 for case $name (got $ec)" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line" >&2
    cat "$out" >&2
    exit 1
  fi
  if [[ -n "$expect_re" ]] && ! grep -qE "$expect_re" "$out"; then
    echo "FAIL: case $name: expected FAIL matching /$expect_re/" >&2
    cat "$out" >&2
    exit 1
  fi
  assert_all_tokens_zero "$name" "$out"
  echo "OK: negative case $name (exit $ec)"
  grep -E '^FAIL:' "$out" | head -n2 || true
}

pass_case() {
  local name="$1"
  shift
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  if [[ $ec -ne 0 ]]; then
    echo "FAIL: expected zero for case $name" >&2
    cat "$out" >&2
    exit 1
  fi
  if grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: unexpected FAIL: line on PASS" >&2
    cat "$out" >&2
    exit 1
  fi
  local t
  for t in "${SUCCESS_TOKENS[@]}"; do
    if ! grep -qx "$t" "$out"; then
      echo "FAIL: case $name missing success token $t" >&2
      cat "$out" >&2
      exit 1
    fi
  done
  # Never dual =0 and =1 for any token family.
  local z
  for z in "${ZERO_TOKENS[@]}"; do
    if grep -qx "$z" "$out"; then
      echo "FAIL: case $name: dual fail token $z on PASS" >&2
      cat "$out" >&2
      exit 1
    fi
  done
  local ok0 ok1
  ok0="$(grep -cx 'LINEAR_RESIDUAL_METRICS_OK=0' "$out" || true)"
  ok1="$(grep -cx 'LINEAR_RESIDUAL_METRICS_OK=1' "$out" || true)"
  if [[ "$ok0" -ne 0 ]] || [[ "$ok1" -ne 1 ]]; then
    echo "FAIL: case $name: dual or missing LINEAR_RESIDUAL_METRICS_OK" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: positive case $name"
}

REAL_MULT="$ROOT/src/Lean/Compiler/Multiplicity.lean"
REAL_FS="$ROOT/src/Lean/Compiler/QTT/FreeSafety.lean"
REAL_THM="$ROOT/src/Lean/Compiler/QTT/Theorems.lean"

copy_real() {
  local dest_mult="$1" dest_fs="$2" dest_thm="$3"
  cp -a "$REAL_MULT" "$dest_mult"
  cp -a "$REAL_FS" "$dest_fs"
  cp -a "$REAL_THM" "$dest_thm"
}

# Override path only when ALLOW_OVERRIDE=1 (product path ignores ambient overrides).
run_gate() {
  local mult="$1" fs="$2" thm="$3"
  env SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE=1 \
      SYSTEMS_LEAN_LINEAR_METRICS_MULT="$mult" \
      SYSTEMS_LEAN_LINEAR_METRICS_FREESAFETY="$fs" \
      SYSTEMS_LEAN_LINEAR_METRICS_THEOREMS="$thm" \
      "$GATE"
}

# --- 0) Real product tree (positive): clear ambient overrides ---
pass_case real_tree \
  env -u SYSTEMS_LEAN_LINEAR_METRICS_MULT \
      -u SYSTEMS_LEAN_LINEAR_METRICS_FREESAFETY \
      -u SYSTEMS_LEAN_LINEAR_METRICS_THEOREMS \
      -u SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE \
      "$GATE"

# --- 0b) Ambient overrides without ALLOW must be ignored (still PASS on real src) ---
: >"$tmpdir/poison-mult.lean"
pass_case ignore_ambient_override_without_allow \
  env -u SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE \
      SYSTEMS_LEAN_LINEAR_METRICS_MULT="$tmpdir/poison-mult.lean" \
      SYSTEMS_LEAN_LINEAR_METRICS_FREESAFETY="$tmpdir/poison-mult.lean" \
      SYSTEMS_LEAN_LINEAR_METRICS_THEOREMS="$tmpdir/poison-mult.lean" \
      "$GATE"

# --- 1) Missing Multiplicity (with ALLOW) ---
fail_case missing_multiplicity --expect 'missing linear residual source artifact' \
  run_gate "$tmpdir/no-mult.lean" "$REAL_FS" "$REAL_THM"

# --- 2) Missing FreeSafety ---
fail_case missing_freesafety --expect 'missing linear residual source artifact' \
  run_gate "$REAL_MULT" "$tmpdir/no-fs.lean" "$REAL_THM"

# --- 3) Missing Theorems ---
fail_case missing_theorems --expect 'missing linear residual source artifact' \
  run_gate "$REAL_MULT" "$REAL_FS" "$tmpdir/no-thm.lean"

# --- 4) Empty Multiplicity / FreeSafety / Theorems ---
: >"$tmpdir/empty-mult.lean"
fail_case empty_multiplicity --expect 'empty linear residual source artifact' \
  run_gate "$tmpdir/empty-mult.lean" "$REAL_FS" "$REAL_THM"

: >"$tmpdir/empty-fs.lean"
fail_case empty_freesafety --expect 'empty linear residual source artifact' \
  run_gate "$REAL_MULT" "$tmpdir/empty-fs.lean" "$REAL_THM"

: >"$tmpdir/empty-thm.lean"
fail_case empty_theorems --expect 'empty linear residual source artifact' \
  run_gate "$REAL_MULT" "$REAL_FS" "$tmpdir/empty-thm.lean"

# --- 5) Strip linear_exact_once_second_use theorem + witnesses ---
copy_real "$tmpdir/m5.lean" "$tmpdir/fs5.lean" "$tmpdir/t5.lean"
sed -i \
  -e '/private theorem linear_exact_once_second_use/,/:= rfl/d' \
  -e 's/:= linear_exact_once_second_use/:= rfl \/* stripped *\//g' \
  "$tmpdir/m5.lean"
fail_case strip_second_use --expect 'linear_exact_once_second_use' \
  run_gate "$tmpdir/m5.lean" "$tmpdir/fs5.lean" "$tmpdir/t5.lean"

# --- 6) Strip mult-0 theorems ---
copy_real "$tmpdir/m6.lean" "$tmpdir/fs6.lean" "$tmpdir/t6.lean"
sed -i \
  -e '/private theorem zero_qty_erased_policy/,/:= rfl/d' \
  -e '/private theorem zero_qty_implies_non_runtime/,/:= rfl/d' \
  -e 's/:= zero_qty_erased_policy/:= rfl \/* stripped *\//g' \
  -e 's/:= zero_qty_implies_non_runtime/:= rfl \/* stripped *\//g' \
  "$tmpdir/m6.lean"
fail_case strip_mult0 --expect 'zero_qty' \
  run_gate "$tmpdir/m6.lean" "$tmpdir/fs6.lean" "$tmpdir/t6.lean"

# --- 7) Strip productResidualMultPolicyChecked public def ---
copy_real "$tmpdir/m7.lean" "$tmpdir/fs7.lean" "$tmpdir/t7.lean"
sed -i 's/productResidualMultPolicyChecked/productResidualMultPolicyStripped/g' \
  "$tmpdir/m7.lean" "$tmpdir/fs7.lean" "$tmpdir/t7.lean"
fail_case strip_product_marker --expect 'productResidualMultPolicyChecked' \
  run_gate "$tmpdir/m7.lean" "$tmpdir/fs7.lean" "$tmpdir/t7.lean"

# --- 8) Forged free-true markers (names present, no witnesses / wrong bodies) ---
cat >"$tmpdir/forged-mult.lean" <<'EOF'
-- forged Multiplicity markers without definitional witnesses
namespace Multiplicity.Theorems
public def algebraChecked : Bool := true
public def freeSafetyChecked : Bool := true
public def productResidualMultPolicyChecked : Bool := true
-- name-only mentions without real theorems:
-- linear_exact_once_second_use
-- zero_qty_erased_policy
-- zero_qty_implies_non_runtime
-- product_residual_mult_policy
-- linear_must_consume
end Multiplicity.Theorems
EOF
cat >"$tmpdir/forged-fs.lean" <<'EOF'
-- forged FreeSafety joint marker without Mult conjuncts or claim strings
namespace FreeSafety
public def productResidualMultPolicyChecked : Bool := true
public def freeSafetyFormalLayerChecked : Bool := true
public def linearExactOncePolicy : Bool := true
public def linearExactOnceChain : Bool := true
public def zeroQtyErasedPolicy : Bool := true
public def zeroQtyNonRuntimePolicy : Bool := true
public def productFreeSafetyPolicies : Bool := true
public def memsafeFreeSafetyClaimsPresent : Bool := true
end FreeSafety
EOF
cat >"$tmpdir/forged-thm.lean" <<'EOF'
namespace Theorems
public def productResidualMultPolicyChecked : Bool := true
public def algebraChecked : Bool := true
end Theorems
EOF
fail_case forged_free_true --expect 'free true|linear_exact_once|zero_qty|missing|witness' \
  run_gate "$tmpdir/forged-mult.lean" "$tmpdir/forged-fs.lean" "$tmpdir/forged-thm.lean"

# --- 8b) Comment-only forge (all greppable names only in comments) ---
cat >"$tmpdir/comment-mult.lean" <<'EOF'
-- private theorem linear_exact_once_second_use :
--     (Multiplicity.useOnce .one).bind Multiplicity.useOnce = none := rfl
-- private theorem zero_qty_erased_policy : ... := rfl
-- private theorem zero_qty_implies_non_runtime : ... := rfl
-- private theorem product_residual_mult_policy : ... := rfl
-- private theorem linear_must_consume : mayDiscard .one = false := rfl
-- public def productResidualMultPolicyChecked : Bool := true
-- public def freeSafetyChecked : Bool := true
-- public def algebraChecked : Bool := true
-- := linear_exact_once_second_use
-- := zero_qty_implies_non_runtime
-- := product_residual_mult_policy
namespace Multiplicity.Theorems
def placeholder : Nat := 0
end Multiplicity.Theorems
EOF
cat >"$tmpdir/comment-fs.lean" <<'EOF'
-- public def freeSafetyFormalLayerChecked : Bool :=
--   Multiplicity.Theorems.freeSafetyChecked &&
--   Multiplicity.Theorems.algebraChecked &&
--   Multiplicity.Theorems.productResidualMultPolicyChecked &&
--   productFreeSafetyPolicies &&
--   linearExactOnceChain &&
--   memsafeFreeSafetyClaimsPresent
-- public def linearExactOncePolicy : Bool := ...
-- qtt_linear_resources_exact_once
-- qtt_zero_quantity_erased
-- qtt_omega_unrestricted_scalars
-- !Multiplicity.mayDiscard .one
namespace FreeSafety
def placeholder : Nat := 0
end FreeSafety
EOF
cat >"$tmpdir/comment-thm.lean" <<'EOF'
-- public def productResidualMultPolicyChecked : Bool := Multiplicity.Theorems.productResidualMultPolicyChecked
namespace Theorems
def placeholder : Nat := 0
end Theorems
EOF
fail_case comment_only_forge --expect 'missing|comment-only|empty code|linear_exact|productResidual|freeSafety' \
  run_gate "$tmpdir/comment-mult.lean" "$tmpdir/comment-fs.lean" "$tmpdir/comment-thm.lean"

# --- 8c) Free-true formal layer with conjuncts only in comments ---
copy_real "$tmpdir/m8c.lean" "$tmpdir/fs8c.lean" "$tmpdir/t8c.lean"
cat >"$tmpdir/fs8c.lean" <<'EOF'
module
prelude
namespace Lean.Compiler.QTT.FreeSafety
public def productResidualMultPolicyChecked : Bool := Multiplicity.Theorems.productResidualMultPolicyChecked
public def linearExactOncePolicy : Bool :=
  (!Multiplicity.mayDiscard .one) &&
  (Multiplicity.useOnce .one == some .zero) &&
  ((Multiplicity.useOnce .one).bind Multiplicity.useOnce == none) &&
  Multiplicity.isLinear .one &&
  Multiplicity.requireLinear .one
public def linearExactOnceChain : Bool :=
  (Multiplicity.useOnce .one == some .zero) &&
  ((Multiplicity.useOnce .one).bind Multiplicity.useOnce == none) &&
  ((Multiplicity.useOnce .one).map Multiplicity.isLinear == some false)
public def zeroQtyErasedPolicy : Bool :=
  Multiplicity.isErased .zero &&
  (!Multiplicity.isRuntime .zero) &&
  (Multiplicity.useOnce .zero == none)
public def zeroQtyNonRuntimePolicy : Bool :=
  zeroQtyErasedPolicy &&
  Multiplicity.mayDiscard .zero &&
  (!Multiplicity.isLinear .zero) &&
  (!Multiplicity.requireLinear .zero)
public def productFreeSafetyPolicies : Bool :=
  linearExactOncePolicy && zeroQtyErasedPolicy && zeroQtyNonRuntimePolicy
public def memsafeFreeSafetyClaimsPresent : Bool :=
  true  -- not checking claims
-- Forged free-true formal layer; real conjuncts only in comments:
-- Multiplicity.Theorems.freeSafetyChecked
-- Multiplicity.Theorems.algebraChecked
-- Multiplicity.Theorems.productResidualMultPolicyChecked
-- productFreeSafetyPolicies
-- linearExactOnceChain
-- memsafeFreeSafetyClaimsPresent
public def freeSafetyFormalLayerChecked : Bool := true
end Lean.Compiler.QTT.FreeSafety
EOF
fail_case free_true_formal_layer --expect 'free true|freeSafetyFormalLayerChecked|witness|missing' \
  run_gate "$tmpdir/m8c.lean" "$tmpdir/fs8c.lean" "$tmpdir/t8c.lean"

# --- 9) Forged success log as Mult file must not satisfy gate (log ≠ source artifact) ---
# Mult path is a greppable-token log only; FS/Thm are real product sources.
cat >"$tmpdir/forged-log-as-mult.lean" <<'EOF'
LINEAR_SECOND_USE_IMPOSSIBLE=1
MULT0_NON_RUNTIME_POLICY=1
PRODUCT_RESIDUAL_MULT_POLICY=1
LINEAR_NO_SILENT_DROP=1
FREE_SAFETY_FORMAL_LAYER=1
LINEAR_RESIDUAL_METRICS_OK=1
# success tokens alone are not Multiplicity theorems
EOF
fail_case forged_log_not_artifact --expect 'linear_exact|missing|zero_qty|productResidual|theorem' \
  run_gate "$tmpdir/forged-log-as-mult.lean" "$REAL_FS" "$REAL_THM"

# --- 10) Strip freeSafetyFormalLayerChecked only ---
copy_real "$tmpdir/m10.lean" "$tmpdir/fs10.lean" "$tmpdir/t10.lean"
sed -i 's/freeSafetyFormalLayerChecked/freeSafetyFormalLayerStripped/g' "$tmpdir/fs10.lean"
fail_case strip_formal_layer --expect 'freeSafetyFormalLayerChecked' \
  run_gate "$tmpdir/m10.lean" "$tmpdir/fs10.lean" "$tmpdir/t10.lean"

# --- 11) Strip silent-drop / mayDiscard one = false cells ---
copy_real "$tmpdir/m11.lean" "$tmpdir/fs11.lean" "$tmpdir/t11.lean"
sed -i \
  -e '/private theorem linear_must_consume/,/:= rfl/d' \
  -e 's/:= linear_must_consume/:= rfl \/* stripped *\//g' \
  -e 's/mayDiscard \.one = false/mayDiscard .one = true/g' \
  "$tmpdir/m11.lean"
# Also flip FreeSafety polarity so !mayDiscard becomes mayDiscard without negation.
sed -i 's/(!Multiplicity.mayDiscard \.one)/ (Multiplicity.mayDiscard .one)/g' "$tmpdir/fs11.lean"
fail_case strip_silent_drop --expect 'silent-drop|linear_must_consume|mayDiscard' \
  run_gate "$tmpdir/m11.lean" "$tmpdir/fs11.lean" "$tmpdir/t11.lean"

# --- 12) Wrong failure class: Mult with only algebraChecked free-true ---
cat >"$tmpdir/partial-mult.lean" <<'EOF'
namespace Multiplicity.Theorems
private theorem add_one_one : True := trivial
public def algebraChecked : Bool := true
-- deliberately no freeSafetyChecked / productResidualMultPolicyChecked / zero_qty_*
end Multiplicity.Theorems
EOF
cp -a "$REAL_FS" "$tmpdir/partial-fs.lean"
cp -a "$REAL_THM" "$tmpdir/partial-thm.lean"
fail_case partial_algebra_only --expect 'linear_exact|zero_qty|productResidualMultPolicyChecked|free true|missing' \
  run_gate "$tmpdir/partial-mult.lean" "$tmpdir/partial-fs.lean" "$tmpdir/partial-thm.lean"

# --- 13) productResidualMultPolicyChecked free-true while other lemma names exist file-wide ---
copy_real "$tmpdir/m13.lean" "$tmpdir/fs13.lean" "$tmpdir/t13.lean"
# Replace only the public def productResidualMultPolicyChecked body with free true
# (leave private theorem product_residual_mult_policy intact so file-wide greps could pass).
if command -v python3 >/dev/null 2>&1; then
  python3 - "$tmpdir/m13.lean" <<'PY'
import re, sys
path = sys.argv[1]
text = open(path).read()
pat = re.compile(
    r'public def productResidualMultPolicyChecked : Bool :=\n(?:.*\n)*?  true\n',
    re.M,
)
new, n = pat.subn(
    'public def productResidualMultPolicyChecked : Bool := true\n',
    text,
    count=1,
)
if n != 1:
    sys.stderr.write(f'FAIL: could not rewrite productResidualMultPolicyChecked (n={n})\n')
    sys.exit(2)
open(path, 'w').write(new)
PY
else
  # awk fallback: rewrite first public def productResidualMultPolicyChecked region.
  awk '
    BEGIN { take=0; done=0 }
    {
      if (!done && $0 ~ /public def productResidualMultPolicyChecked/) {
        print "public def productResidualMultPolicyChecked : Bool := true"
        take=1
        next
      }
      if (take) {
        if ($0 ~ /^(public |private |protected )?(def|theorem|abbrev) / || $0 ~ /^end /) {
          take=0
          done=1
          print
        }
        next
      }
      print
    }
  ' "$tmpdir/m13.lean" >"$tmpdir/m13.rewritten.lean"
  mv "$tmpdir/m13.rewritten.lean" "$tmpdir/m13.lean"
fi
fail_case free_true_product_marker_with_filewide_lemmas --expect 'free true|productResidualMultPolicyChecked|witness|vacuous' \
  run_gate "$tmpdir/m13.lean" "$tmpdir/fs13.lean" "$tmpdir/t13.lean"

# --- 14) Body invert: keep linear_exact_once_second_use name, invert = none → some ---
copy_real "$tmpdir/m14.lean" "$tmpdir/fs14.lean" "$tmpdir/t14.lean"
sed -i \
  -e 's/(Multiplicity\.useOnce \.one)\.bind Multiplicity\.useOnce = none/(Multiplicity.useOnce .one).bind Multiplicity.useOnce = some .one/g' \
  -e 's/(Multiplicity\.useOnce \.one)\.bind Multiplicity\.useOnce == none/(Multiplicity.useOnce .one).bind Multiplicity.useOnce == some .one/g' \
  "$tmpdir/m14.lean" "$tmpdir/fs14.lean"
fail_case body_invert_second_use --expect 'second use|useOnce one then second|= none|none' \
  run_gate "$tmpdir/m14.lean" "$tmpdir/fs14.lean" "$tmpdir/t14.lean"

# --- 15) Strip claim strings only (memsafeFreeSafetyClaimsPresent) ---
copy_real "$tmpdir/m15.lean" "$tmpdir/fs15.lean" "$tmpdir/t15.lean"
sed -i \
  -e 's/claim=qtt_linear_resources_exact_once/claim=qtt_stripped_linear/g' \
  -e 's/claim=qtt_zero_quantity_erased/claim=qtt_stripped_zero/g' \
  -e 's/claim=qtt_omega_unrestricted_scalars/claim=qtt_stripped_omega/g' \
  "$tmpdir/fs15.lean"
fail_case strip_claim_strings --expect 'claim=|claim string|qtt_linear_resources|qtt_zero_quantity|qtt_omega' \
  run_gate "$tmpdir/m15.lean" "$tmpdir/fs15.lean" "$tmpdir/t15.lean"

# --- 16) String-only witnesses + vacuous have _ := true (must FAIL after string strip) ---
cat >"$tmpdir/string-only-mult.lean" <<'EOF'
namespace Multiplicity.Theorems
private theorem linear_exact_once_second_use :
    True := trivial
-- policy equation inverted / absent; "witnesses" only as strings:
public def freeSafetyChecked : Bool :=
  have _ := true
  have _ := "linear_exact_once_second_use"
  have _ := "zero_qty_erased_policy"
  have _ := "zero_qty_implies_non_runtime"
  have _ := "linear_must_consume"
  have _ := "product_residual_mult_policy"
  true
public def productResidualMultPolicyChecked : Bool :=
  have _ := true
  have _ := "product_residual_mult_policy"
  have _ := "linear_exact_once_second_use"
  have _ := "zero_qty_implies_non_runtime"
  have _ := "zero_qty_erased_policy"
  true
public def algebraChecked : Bool :=
  have _ := true
  true
-- keep greppable names as strings only for mult-0 cells
def _strings : List String :=
  ["isErased .zero = true", "isRuntime .zero = false", "useOnce .zero = none",
   "mayDiscard .one = false",
   "(Multiplicity.useOnce .one).bind Multiplicity.useOnce = none"]
end Multiplicity.Theorems
EOF
cat >"$tmpdir/string-only-fs.lean" <<'EOF'
namespace FreeSafety
public def productResidualMultPolicyChecked : Bool :=
  Multiplicity.Theorems.productResidualMultPolicyChecked
public def linearExactOncePolicy : Bool :=
  true  -- "useOnce .one" "bind Multiplicity.useOnce == none"
public def linearExactOnceChain : Bool := true
public def zeroQtyErasedPolicy : Bool := true
public def zeroQtyNonRuntimePolicy : Bool := true
public def productFreeSafetyPolicies : Bool := true
public def omegaRepeatedUseStable : Bool := true
public def memsafeFreeSafetyClaimsPresent : Bool :=
  true  -- "claim=qtt_linear_resources_exact_once" only if free-true allowed
public def freeSafetyFormalLayerChecked : Bool :=
  true
  -- "Multiplicity.Theorems.freeSafetyChecked"
  -- "claimInventoryChecked"
  -- "omegaRepeatedUseStable"
end FreeSafety
EOF
cat >"$tmpdir/string-only-thm.lean" <<'EOF'
namespace Theorems
public def productResidualMultPolicyChecked : Bool :=
  Multiplicity.Theorems.productResidualMultPolicyChecked
public def algebraChecked : Bool := Multiplicity.Theorems.algebraChecked
end Theorems
EOF
fail_case string_only_witnesses --expect 'vacuous|free true|missing|witness|useOnce|linear_exact|claim' \
  run_gate "$tmpdir/string-only-mult.lean" "$tmpdir/string-only-fs.lean" "$tmpdir/string-only-thm.lean"

# --- 17) Drop claimInventoryChecked / omegaRepeatedUseStable from formal layer ---
copy_real "$tmpdir/m17.lean" "$tmpdir/fs17.lean" "$tmpdir/t17.lean"
# Remove only the joint-def conjuncts (keep public def omegaRepeatedUseStable itself).
sed -i \
  -e 's/LCNF\.MemSafetyCert\.Theorems\.claimInventoryChecked[[:space:]]*&&[[:space:]]*//' \
  -e 's/omegaRepeatedUseStable[[:space:]]*&&[[:space:]]*//' \
  "$tmpdir/fs17.lean"
fail_case drop_formal_layer_conjuncts --expect 'claimInventoryChecked|omegaRepeatedUseStable|witness' \
  run_gate "$tmpdir/m17.lean" "$tmpdir/fs17.lean" "$tmpdir/t17.lean"

echo "OK: systems-linear-residual-metrics negatives (fail-closed; comment/free-true/string forges; all tokens=0 on FAIL)"
exit 0
