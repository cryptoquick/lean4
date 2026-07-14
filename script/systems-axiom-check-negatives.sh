#!/usr/bin/env bash
# Negative / positive cases for systems-axiom-check.sh (fail-closed W7.C5).
# Does not require freestanding product artifacts.
#
# Empty-corpus PASS is intentional layout OK — not a claim that product TCB is axiom-free.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GATE="$ROOT/script/systems-axiom-check.sh"
chmod +x "$GATE"

tmpdir="$(mktemp -d)"
# Fixture under lean4 root (corpus paths must be ROOT-relative); gitignored + trap-cleaned.
neg_src="$ROOT/script/.tmp-axiom-neg-src"
rm -rf "$neg_src"
mkdir -p "$neg_src"
cleanup() {
  rm -rf "$tmpdir" "$neg_src"
}
trap cleanup EXIT

fail_case() {
  local name="$1"
  shift
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  # Gate must exit exactly 1 (not other non-zero).
  if [[ $ec -ne 1 ]]; then
    echo "FAIL: expected exit 1 for case $name (got $ec)" >&2
    cat "$out" >&2
    exit 1
  fi
  if grep -qx 'AXIOM_AUTO_GATE_OK=1' "$out"; then
    echo "FAIL: case $name printed AXIOM_AUTO_GATE_OK=1 on failure" >&2
    cat "$out" >&2
    exit 1
  fi
  # Require explicit failure token (not merely a FAIL: line without OK=0).
  if ! grep -qx 'AXIOM_AUTO_GATE_OK=0' "$out"; then
    echo "FAIL: case $name missing AXIOM_AUTO_GATE_OK=0" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line in output" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: negative case $name (exit $ec)"
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
  if ! grep -qx 'AXIOM_AUTO_GATE_OK=1' "$out"; then
    echo "FAIL: case $name missing AXIOM_AUTO_GATE_OK=1" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: positive case $name"
}

# Relative paths used in corpus (must live under lean4 root).
REL="script/.tmp-axiom-neg-src/Poison.lean"
ABS="$ROOT/$REL"
REL2="script/.tmp-axiom-neg-src/Allow.lean"
ABS2="$ROOT/$REL2"
REL3="script/.tmp-axiom-neg-src/Extern.lean"
ABS3="$ROOT/$REL3"
REL_MISS="script/.tmp-axiom-neg-src/Missing.lean"

# empty allowlist (comments only)
cat >"$tmpdir/allow.txt" <<'EOF'
# empty allowlist for negative test
EOF

# --- 1) Unlisted axiom ⇒ FAIL, no OK token ---
cat >"$ABS" <<'EOF'
module
-- temporary negative fixture; not part of product corpus
axiom unlistedPoison : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus.txt"
fail_case unlisted_axiom \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"

# --- 2) Path-only allowlist ⇒ PASS ---
printf '%s\n' "$REL" >"$tmpdir/allow-path.txt"
pass_case allowlisted_path \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-path.txt" \
      "$GATE"

# --- 3) path+name allowlist matching ⇒ PASS ---
printf '%s name=unlistedPoison\n' "$REL" >"$tmpdir/allow-name.txt"
pass_case allowlisted_path_name \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-name.txt" \
      "$GATE"

# --- 4) path+name wrong name ⇒ FAIL ---
printf '%s name=otherAxiom\n' "$REL" >"$tmpdir/allow-wrong.txt"
fail_case wrong_name_allowlist \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-wrong.txt" \
      "$GATE"

# --- 5) Missing corpus file ⇒ FAIL (tool/layout) ---
fail_case missing_corpus \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/no-such-corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"

# --- 6) Missing allowlist file ⇒ FAIL (tool/layout) ---
fail_case missing_allowlist \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/no-such-allow.txt" \
      "$GATE"

# --- 7) Empty corpus (no axioms) + empty allowlist ⇒ PASS (layout only; not "product axiom-free") ---
: >"$tmpdir/empty-corpus.txt"
pass_case empty_corpus_empty_allowlist \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/empty-corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"

# --- 8) Comment-only "axiom" mention should not fail (line comment skipped) ---
cat >"$ABS" <<'EOF'
module
-- axiom is only mentioned in this comment
def ok : Nat := 0
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-comment.txt"
pass_case comment_only_axiom_word \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-comment.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"

# --- 9) Corpus member path missing on disk ⇒ FAIL ---
printf '%s\n' "$REL_MISS" >"$tmpdir/corpus-missing-member.txt"
fail_case corpus_member_missing \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-missing-member.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"

# --- 10) Multi-axiom file; only one name= allowlisted ⇒ FAIL on the other ---
cat >"$ABS" <<'EOF'
module
axiom allowedOne : True
axiom blockedTwo : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-multi.txt"
printf '%s name=allowedOne\n' "$REL" >"$tmpdir/allow-partial.txt"
fail_case multi_axiom_partial_name \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-multi.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-partial.txt" \
      "$GATE"
# Ensure FAIL names the blocked axiom
out_multi="$tmpdir/multi_axiom_partial_name.out"
if ! grep -q 'name=blockedTwo' "$out_multi"; then
  echo "FAIL: multi_axiom_partial_name should report name=blockedTwo" >&2
  cat "$out_multi" >&2
  exit 1
fi

# --- 11) Production-shaped @[extern] public axiom Dotted.name with name= ⇒ PASS ---
cat >"$ABS3" <<'EOF'
module
@[extern c inline "((uint32_t)(#1) | (uint32_t)(#2))"]
public axiom U32.lor : U32 → U32 → U32
EOF
printf '%s\n' "$REL3" >"$tmpdir/corpus-extern.txt"
printf '%s name=U32.lor\n' "$REL3" >"$tmpdir/allow-extern.txt"
pass_case extern_dotted_name \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-extern.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-extern.txt" \
      "$GATE"

# --- 12) Malformed allowlist entry ⇒ FAIL ---
printf 'not a valid entry because spaces without name=\n' >"$tmpdir/allow-malformed.txt"
fail_case malformed_allowlist \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/empty-corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-malformed.txt" \
      "$GATE"

# --- 13) name= is path-scoped (same name on other path does not allow) ---
cat >"$ABS" <<'EOF'
module
axiom sharedName : True
EOF
cat >"$ABS2" <<'EOF'
module
axiom sharedName : True
EOF
printf '%s\n%s\n' "$REL" "$REL2" >"$tmpdir/corpus-scoped.txt"
# Allow sharedName only on REL2; REL remains unlisted → FAIL
printf '%s name=sharedName\n' "$REL2" >"$tmpdir/allow-scoped.txt"
fail_case name_path_scoping \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-scoped.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-scoped.txt" \
      "$GATE"
out_scope="$tmpdir/name_path_scoping.out"
if ! grep -q "$REL" "$out_scope"; then
  echo "FAIL: name_path_scoping should mention unlisted path $REL" >&2
  cat "$out_scope" >&2
  exit 1
fi

# --- 14) Path-allowlisted sibling + unlisted poison path still fails ---
cat >"$ABS2" <<'EOF'
module
axiom allowlistedSibling : True
EOF
cat >"$ABS" <<'EOF'
module
axiom poisonSibling : True
EOF
printf '%s\n%s\n' "$REL2" "$REL" >"$tmpdir/corpus-sibling.txt"
printf '%s\n' "$REL2" >"$tmpdir/allow-sibling.txt"
fail_case sibling_poison_unlisted \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-sibling.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-sibling.txt" \
      "$GATE"
out_sib="$tmpdir/sibling_poison_unlisted.out"
if ! grep -q 'name=poisonSibling' "$out_sib"; then
  echo "FAIL: sibling_poison_unlisted should report name=poisonSibling" >&2
  cat "$out_sib" >&2
  exit 1
fi

# --- 15) Both siblings allowlisted by path ⇒ PASS ---
printf '%s\n%s\n' "$REL" "$REL2" >"$tmpdir/allow-both.txt"
pass_case sibling_both_allowlisted \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-sibling.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-both.txt" \
      "$GATE"

# --- 16) unsafe axiom unlisted ⇒ FAIL (must not fail-open as prose) ---
cat >"$ABS" <<'EOF'
module
unsafe axiom evilUnsafe : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-unsafe.txt"
fail_case unsafe_axiom_unlisted \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-unsafe.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"
out_unsafe="$tmpdir/unsafe_axiom_unlisted.out"
if ! grep -q 'name=evilUnsafe' "$out_unsafe"; then
  echo "FAIL: unsafe_axiom_unlisted should report name=evilUnsafe" >&2
  cat "$out_unsafe" >&2
  exit 1
fi

# --- 17) public noncomputable axiom unlisted ⇒ FAIL (stacked modifiers) ---
cat >"$ABS" <<'EOF'
module
public noncomputable axiom evilNoncomp : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-noncomp.txt"
fail_case public_noncomputable_axiom_unlisted \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-noncomp.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"
out_nc="$tmpdir/public_noncomputable_axiom_unlisted.out"
if ! grep -q 'name=evilNoncomp' "$out_nc"; then
  echo "FAIL: public_noncomputable_axiom_unlisted should report name=evilNoncomp" >&2
  cat "$out_nc" >&2
  exit 1
fi

# --- 18) @[extern] unsafe public axiom Dotted.name unlisted ⇒ FAIL ---
cat >"$ABS" <<'EOF'
module
@[extern c inline "((uint32_t)(#1) | (uint32_t)(#2))"]
unsafe public axiom Evil.lor : U32 → U32 → U32
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-ext-unsafe.txt"
fail_case extern_unsafe_public_unlisted \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-ext-unsafe.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"
out_eu="$tmpdir/extern_unsafe_public_unlisted.out"
if ! grep -q 'name=Evil.lor' "$out_eu"; then
  echo "FAIL: extern_unsafe_public_unlisted should report name=Evil.lor" >&2
  cat "$out_eu" >&2
  exit 1
fi

# --- 19) partial local axiom unlisted ⇒ FAIL ---
cat >"$ABS" <<'EOF'
module
partial local axiom evilPartial : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-partial.txt"
fail_case partial_local_axiom_unlisted \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-partial.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"
out_pl="$tmpdir/partial_local_axiom_unlisted.out"
if ! grep -q 'name=evilPartial' "$out_pl"; then
  echo "FAIL: partial_local_axiom_unlisted should report name=evilPartial" >&2
  cat "$out_pl" >&2
  exit 1
fi

# --- 20) B1: new axiom under path with only name= pins ⇒ FAIL (silent TCB growth blocked) ---
cat >"$ABS" <<'EOF'
module
axiom pinnedOk : True
axiom silentGrowth : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-name-only.txt"
printf '%s name=pinnedOk\n' "$REL" >"$tmpdir/allow-name-only.txt"
fail_case name_only_path_new_axiom \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-name-only.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-name-only.txt" \
      "$GATE"
out_nonly="$tmpdir/name_only_path_new_axiom.out"
if ! grep -q 'name=silentGrowth' "$out_nonly"; then
  echo "FAIL: name_only_path_new_axiom should report name=silentGrowth" >&2
  cat "$out_nonly" >&2
  exit 1
fi
if grep -q 'name=pinnedOk' "$out_nonly" && grep -qE 'unlisted axiom.*name=pinnedOk' "$out_nonly"; then
  echo "FAIL: name_only_path_new_axiom should not unlist pinnedOk" >&2
  cat "$out_nonly" >&2
  exit 1
fi

# --- 21) B1: path-only INTENTIONAL_TCB_PATH_ALLOW still accepts new axioms under that path ---
cat >"$ABS" <<'EOF'
module
axiom pathAllowOne : True
axiom pathAllowTwo : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-path-growth.txt"
printf '%s\n' "$REL" >"$tmpdir/allow-path-growth.txt"
pass_case path_only_accepts_new_axioms \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-path-growth.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-path-growth.txt" \
      "$GATE"
out_pg="$tmpdir/path_only_accepts_new_axioms.out"
if ! grep -qx 'AXIOM_ALLOWLIST_PATH_ONLY_COUNT=1' "$out_pg"; then
  echo "FAIL: path_only_accepts_new_axioms missing AXIOM_ALLOWLIST_PATH_ONLY_COUNT=1" >&2
  cat "$out_pg" >&2
  exit 1
fi
if ! grep -qx 'AXIOM_ALLOWLIST_NAME_PIN_COUNT=0' "$out_pg"; then
  echo "FAIL: path_only_accepts_new_axioms missing AXIOM_ALLOWLIST_NAME_PIN_COUNT=0" >&2
  cat "$out_pg" >&2
  exit 1
fi

# --- 22) B1: greppable pin counts on name-only allowlist success ---
cat >"$ABS" <<'EOF'
module
axiom onlyPinned : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-counts.txt"
printf '%s name=onlyPinned\n' "$REL" >"$tmpdir/allow-counts.txt"
pass_case name_pin_counts \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-counts.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-counts.txt" \
      "$GATE"
out_cnt="$tmpdir/name_pin_counts.out"
if ! grep -qx 'AXIOM_ALLOWLIST_PATH_ONLY_COUNT=0' "$out_cnt"; then
  echo "FAIL: name_pin_counts missing AXIOM_ALLOWLIST_PATH_ONLY_COUNT=0" >&2
  cat "$out_cnt" >&2
  exit 1
fi
if ! grep -qx 'AXIOM_ALLOWLIST_NAME_PIN_COUNT=1' "$out_cnt"; then
  echo "FAIL: name_pin_counts missing AXIOM_ALLOWLIST_NAME_PIN_COUNT=1" >&2
  cat "$out_cnt" >&2
  exit 1
fi

# --- 23) Dual path-only + name= for same path ⇒ FAIL (path-only would nullify pins) ---
cat >"$ABS" <<'EOF'
module
axiom dualPoison : True
axiom dualExtra : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-dual.txt"
# Both path-only and a single name= for REL — dual rejected at parse time.
{
  printf '%s\n' "$REL"
  printf '%s name=dualPoison\n' "$REL"
} >"$tmpdir/allow-dual.txt"
fail_case dual_path_and_name \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-dual.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-dual.txt" \
      "$GATE"
out_dual="$tmpdir/dual_path_and_name.out"
if ! grep -q 'dual allowlist entry' "$out_dual"; then
  echo "FAIL: dual_path_and_name should report dual allowlist entry" >&2
  cat "$out_dual" >&2
  exit 1
fi
# Pin counts still emitted on FAIL.
if ! grep -qE '^AXIOM_ALLOWLIST_PATH_ONLY_COUNT=' "$out_dual"; then
  echo "FAIL: dual_path_and_name missing AXIOM_ALLOWLIST_PATH_ONLY_COUNT" >&2
  cat "$out_dual" >&2
  exit 1
fi
if ! grep -qE '^AXIOM_ALLOWLIST_NAME_PIN_COUNT=' "$out_dual"; then
  echo "FAIL: dual_path_and_name missing AXIOM_ALLOWLIST_NAME_PIN_COUNT" >&2
  cat "$out_dual" >&2
  exit 1
fi

# --- 24) Unlisted axiom FAIL path still emits pin counts ---
cat >"$ABS" <<'EOF'
module
axiom countOnFail : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-fail-counts.txt"
# empty allowlist
fail_case fail_emits_pin_counts \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-fail-counts.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow.txt" \
      "$GATE"
out_fc="$tmpdir/fail_emits_pin_counts.out"
if ! grep -qx 'AXIOM_ALLOWLIST_PATH_ONLY_COUNT=0' "$out_fc"; then
  echo "FAIL: fail_emits_pin_counts missing AXIOM_ALLOWLIST_PATH_ONLY_COUNT=0" >&2
  cat "$out_fc" >&2
  exit 1
fi
if ! grep -qx 'AXIOM_ALLOWLIST_NAME_PIN_COUNT=0' "$out_fc"; then
  echo "FAIL: fail_emits_pin_counts missing AXIOM_ALLOWLIST_NAME_PIN_COUNT=0" >&2
  cat "$out_fc" >&2
  exit 1
fi

# --- 25) Orphan name= pin (pin without source axiom) still PASS (intentional one-way) ---
cat >"$ABS" <<'EOF'
module
axiom realOne : True
EOF
printf '%s\n' "$REL" >"$tmpdir/corpus-orphan.txt"
{
  printf '%s name=realOne\n' "$REL"
  printf '%s name=orphanPin\n' "$REL"
} >"$tmpdir/allow-orphan.txt"
pass_case orphan_name_pin_ok \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/corpus-orphan.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-orphan.txt" \
      "$GATE"
out_or="$tmpdir/orphan_name_pin_ok.out"
if ! grep -qx 'AXIOM_ALLOWLIST_NAME_PIN_COUNT=2' "$out_or"; then
  echo "FAIL: orphan_name_pin_ok missing AXIOM_ALLOWLIST_NAME_PIN_COUNT=2" >&2
  cat "$out_or" >&2
  exit 1
fi

# --- 26) Missing corpus still emits accurate pin counts when allowlist is parseable ---
printf 'src/Systems/Scalars.lean\n' >"$tmpdir/allow-real-path.txt"
printf 'src/Systems/BitOps.lean name=U32.bswap\n' >>"$tmpdir/allow-real-path.txt"
fail_case missing_corpus_emits_pin_counts \
  env SYSTEMS_LEAN_COMPLIANCE_CORPUS="$tmpdir/no-such-corpus.txt" \
      SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST="$tmpdir/allow-real-path.txt" \
      "$GATE"
out_mcp="$tmpdir/missing_corpus_emits_pin_counts.out"
if ! grep -qx 'AXIOM_ALLOWLIST_PATH_ONLY_COUNT=1' "$out_mcp"; then
  echo "FAIL: missing_corpus_emits_pin_counts expected PATH_ONLY_COUNT=1 (allowlist parsed before corpus layout FAIL)" >&2
  cat "$out_mcp" >&2
  exit 1
fi
if ! grep -qx 'AXIOM_ALLOWLIST_NAME_PIN_COUNT=1' "$out_mcp"; then
  echo "FAIL: missing_corpus_emits_pin_counts expected NAME_PIN_COUNT=1" >&2
  cat "$out_mcp" >&2
  exit 1
fi

echo "OK: systems-axiom-check negatives (fail-closed; AXIOM_AUTO_GATE_OK=0 on every failure; exit 1)"
exit 0
