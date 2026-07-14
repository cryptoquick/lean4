#!/usr/bin/env bash
# Negative cases for systems-compcert-compliant.sh (fail-closed).
# Residual / sorry / missing / REQUIRE_REF discovery must never print:
#   PROVABLY_COMPCERT_COMPLIANT=1  or  COMPCERT_DOGFOOD=1
# Full-gate cases require freestanding product artifacts (hard-fail if missing).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GATE="$ROOT/script/systems-compcert-compliant.sh"
FS_EXAMPLE="$ROOT/tests/lake/examples/systems"
EXTRACT_PROD="$FS_EXAMPLE/lib/.lake/build/ir/Extract.c"
BUNDLE_PROD="$FS_EXAMPLE/lib/.lake/build/lib/libfs_extract_bundle.a"
IR_PROD="$FS_EXAMPLE/lib/.lake/build/ir"

chmod +x "$GATE" "$ROOT/script/systems-sorry-free-check.sh" \
  "$ROOT/script/systems-selfhost-link-check.sh" \
  "$ROOT/script/systems-residual-policy.sh"

tmpdir="$(mktemp -d)"
neg_dir="$ROOT/script/.tmp-compliant-neg"
cleanup() {
  rm -rf "$tmpdir" "$neg_dir"
}
trap cleanup EXIT

# Prefer stage1 when present.
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
fi

# shellcheck source=systems-residual-policy.sh
source "$ROOT/script/systems-residual-policy.sh"
if ! systems_lean_require_product_fs_modules; then
  echo "FAIL: cannot load PRODUCT_STDLIB_MODULES for compliant negatives matrix" >&2
  exit 1
fi

require_product() {
  if [[ ! -f "$EXTRACT_PROD" || ! -f "$BUNDLE_PROD" ]]; then
    echo "FAIL: freestanding product artifacts required for compliant negatives" >&2
    echo "hint: lake --dir=$FS_EXAMPLE/lib build  (tooling/layout — not a soft skip)" >&2
    exit 1
  fi
  # Full PRODUCT_STDLIB matrix hard-required (manifest-driven).
  local m
  for m in "${SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}"; do
    if [[ ! -f "$IR_PROD/Systems/${m}.c" ]]; then
      echo "FAIL: missing product IR $IR_PROD/Systems/${m}.c (required for full-gate negatives)" >&2
      exit 1
    fi
  done
}

# Copy full freestanding product matrix into a disposable IR tree.
copy_product_fs_ir() {
  local dest="$1"
  mkdir -p "$dest/Systems/Parallelism"
  local m dest_f dest_dir
  for m in "${SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}"; do
    dest_f="$dest/Systems/${m}.c"
    dest_dir="$(dirname "$dest_f")"
    mkdir -p "$dest_dir"
    cp "$IR_PROD/Systems/${m}.c" "$dest_f"
  done
}

fail_case() {
  local name="$1"
  local expect_re="$2"
  shift 2
  local out="$tmpdir/$name.out"
  local receipt_out=""
  # Capture SYSTEMS_LEAN_COMPLIANT_OUT from env args when present for receipt asserts.
  local a prev=""
  for a in "$@"; do
    if [[ "$prev" == "SYSTEMS_LEAN_COMPLIANT_OUT"* ]] || [[ "$prev" == SYSTEMS_LEAN_COMPLIANT_OUT=* ]]; then
      :
    fi
    if [[ "$a" == SYSTEMS_LEAN_COMPLIANT_OUT=* ]]; then
      receipt_out="${a#SYSTEMS_LEAN_COMPLIANT_OUT=}/compliant-receipt.txt"
    fi
    prev="$a"
  done
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  if [[ $ec -eq 0 ]]; then
    echo "FAIL: expected non-zero for case $name" >&2
    cat "$out" >&2
    exit 1
  fi
  # Exact-line success tokens only (prose may mention token names).
  if grep -qxE 'PROVABLY_COMPCERT_COMPLIANT=1|COMPCERT_DOGFOOD=1' "$out"; then
    echo "FAIL: case $name printed a success token on failure" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line in output" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE "$expect_re" "$out"; then
    echo "FAIL: case $name: expected log match /$expect_re/" >&2
    cat "$out" >&2
    exit 1
  fi
  # Prefer receipt path from env= form used by `env KEY=val ...`
  if [[ -z "$receipt_out" ]]; then
    # env KEY=val style: last SYSTEMS_LEAN_COMPLIANT_OUT= in the command string is hard;
    # also accept OUT from the log "out: " line.
    local out_dir
    out_dir="$(grep -E '^out: ' "$out" | tail -n1 | sed 's/^out: //')" || true
    if [[ -n "$out_dir" ]]; then
      receipt_out="$out_dir/compliant-receipt.txt"
    fi
  fi
  if [[ -n "$receipt_out" && -f "$receipt_out" ]]; then
    if ! grep -qE '^RECEIPT: FAIL$|^PROVABLY_COMPCERT_COMPLIANT=0$' "$receipt_out"; then
      echo "FAIL: case $name: expected FAIL receipt markers in $receipt_out" >&2
      cat "$receipt_out" >&2
      exit 1
    fi
    if grep -qxE 'PROVABLY_COMPCERT_COMPLIANT=1|COMPCERT_DOGFOOD=1' "$receipt_out"; then
      echo "FAIL: case $name: success token in FAIL receipt $receipt_out" >&2
      exit 1
    fi
  fi
  echo "OK: negative case $name (exit $ec, no success token, matched /$expect_re/)"
  # Diagnostic only: avoid SIGPIPE→exit 141 under `set -o pipefail` when head closes early.
  grep -E '^FAIL:' "$out" | head -n2 || true
}

require_product

# 1) Missing extract / bundle → fail closed (skip build).
fail_case missing_artifacts 'ResidualFree|missing' \
  env SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$tmpdir/no-Extract.c" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$tmpdir/no-bundle.a" \
      SYSTEMS_LEAN_COMPLIANT_IR_DIR="$tmpdir/empty-ir" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-missing" \
      "$GATE"

# 2) SorryFree via full gate.
mkdir -p "$neg_dir"
cat >"$neg_dir/SorryFixture.lean" <<'LEAN'
theorem bogus : True := by sorry
LEAN
cat >"$neg_dir/corpus.txt" <<'EOF'
script/.tmp-compliant-neg/SorryFixture.lean
EOF
fail_case sorry_blocks_compliant 'SorryFree|sorry|admit' \
  env SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
      SYSTEMS_LEAN_COMPLIANCE_CORPUS="$neg_dir/corpus.txt" \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$EXTRACT_PROD" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$BUNDLE_PROD" \
      SYSTEMS_LEAN_COMPLIANT_IR_DIR="$IR_PROD" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-sorry" \
      "$GATE"

# 3) Residual IR via FULL compliant gate (disposable IR tree with lean_object).
mkdir -p "$tmpdir/ir_bad"
cp "$EXTRACT_PROD" "$tmpdir/ir_bad/Extract.c"
copy_product_fs_ir "$tmpdir/ir_bad"
echo '/* residual fixture */ lean_object *bad;' >>"$tmpdir/ir_bad/Extract.c"
# Use real bundle so nm may pass; residual IR must fail ResidualFree.
fail_case residual_ir_full_gate 'residual Lean RC/object|ResidualFree' \
  env SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$tmpdir/ir_bad/Extract.c" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$BUNDLE_PROD" \
      SYSTEMS_LEAN_COMPLIANT_IR_DIR="$tmpdir/ir_bad" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-ir" \
      "$GATE"

# 4) Residual nm via full gate (U lean_inc).
if ! command -v cc >/dev/null 2>&1; then
  echo "FAIL: cc required for residual nm negative (tool discovery)" >&2
  exit 1
fi
cat >"$tmpdir/bad_rc.c" <<'C'
extern void lean_inc(void *);
void product_entry(void *o) { lean_inc(o); }
C
cc -c -o "$tmpdir/bad_rc.o" "$tmpdir/bad_rc.c"
fail_case residual_nm_full_gate 'ResidualFree|lean_inc|U lean_' \
  env SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$EXTRACT_PROD" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$tmpdir/bad_rc.o" \
      SYSTEMS_LEAN_COMPLIANT_IR_DIR="$IR_PROD" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-nm" \
      "$GATE"

# 5) REQUIRE_REF / accomplishment mode with no ./ref ccomp → tool discovery fail-closed.
# Hide local ref ccomp for this case only (workspace may have ref/bin/ccomp pinned).
# RESULT alone must not satisfy REQUIRE_REF.
ref_ccomp_hide=()
for _rc in "$ROOT/ref/bin/ccomp" "$ROOT/ref/ccomp" "$ROOT/ref/ccomp.opt"; do
  if [[ -e "$_rc" || -L "$_rc" ]]; then
    mv "$_rc" "${_rc}.neg-hide"
    ref_ccomp_hide+=("${_rc}.neg-hide")
  fi
done
restore_ref_ccomp() {
  local h
  for h in "${ref_ccomp_hide[@]:-}"; do
    [[ -e "$h" || -L "$h" ]] || continue
    mv "$h" "${h%.neg-hide}"
  done
}
trap 'restore_ref_ccomp; cleanup' EXIT
fail_case require_ref_missing 'tool discovery|REQUIRE_REF|ref' \
  env -u SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT \
      SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 \
      SYSTEMS_LEAN_COMPCERT_REQUIRE=1 \
      SYSTEMS_LEAN_COMPCERT_RESULT="$ROOT/result-compcert" \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$EXTRACT_PROD" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$BUNDLE_PROD" \
      SYSTEMS_LEAN_COMPLIANT_IR_DIR="$IR_PROD" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-ref" \
      "$GATE"
restore_ref_ccomp
ref_ccomp_hide=()
trap cleanup EXIT

# 6) Dogfood ALLOW_RESULT must not print PROVABLY token even if green (smoke only if RESULT works).
# Here: ensure a deliberate failure path under ALLOW_RESULT still never prints PROVABLY.
fail_case dogfood_no_provably_on_fail 'FAIL:' \
  env SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
      SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$tmpdir/no-Extract.c" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$tmpdir/no-bundle.a" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-dogfood-fail" \
      "$GATE"

# 7) Empty bundle file → ResidualFree fail-closed.
: >"$tmpdir/empty.a"
fail_case empty_bundle 'ResidualFree|empty|missing' \
  env SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$EXTRACT_PROD" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$tmpdir/empty.a" \
      SYSTEMS_LEAN_COMPLIANT_IR_DIR="$IR_PROD" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-empty" \
      "$GATE"

# 8) Missing certs on product C → CertsVerify fail (full gate).
# Full PRODUCT_STDLIB matrix of stub .c files (no certs) so ResidualFree companion hard-require passes.
mkdir -p "$tmpdir/ir_nocert/Systems/Parallelism"
echo 'int ok(void){return 0;}' >"$tmpdir/ir_nocert/Extract.c"
for m in "${SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}"; do
  mkdir -p "$tmpdir/ir_nocert/Systems/$(dirname "$m")"
  echo 'int ok(void){return 0;}' >"$tmpdir/ir_nocert/Systems/${m}.c"
done
# Real bundle so ResidualFree nm may pass; certs must fail.
fail_case missing_certs 'CertsVerify|MEMSAFE|qtt_zero|COMPCERT_MEMCERT|missing' \
  env SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$tmpdir/ir_nocert/Extract.c" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$BUNDLE_PROD" \
      SYSTEMS_LEAN_COMPLIANT_IR_DIR="$tmpdir/ir_nocert" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-nocert" \
      "$GATE"

# 9) Alternate residual IR arm (lean_box / initialize_) via full gate.
mkdir -p "$tmpdir/ir_box"
cp "$EXTRACT_PROD" "$tmpdir/ir_box/Extract.c"
copy_product_fs_ir "$tmpdir/ir_box"
echo '/* residual fixture */ void *p = lean_box(0);' >>"$tmpdir/ir_box/Extract.c"
echo '/* residual fixture */ void initialize_Foo(void);' >>"$tmpdir/ir_box/Systems/Bytes.c"
fail_case residual_ir_box_init 'residual Lean RC/object|lean_box|initialize_|ResidualFree' \
  env SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
      SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
      SYSTEMS_LEAN_COMPLIANT_EXTRACT="$tmpdir/ir_box/Extract.c" \
      SYSTEMS_LEAN_COMPLIANT_BUNDLE="$BUNDLE_PROD" \
      SYSTEMS_LEAN_COMPLIANT_IR_DIR="$tmpdir/ir_box" \
      SYSTEMS_LEAN_COMPLIANT_OUT="$tmpdir/out-box" \
      "$GATE"

echo "OK: systems-compcert-compliant negatives (fail-closed; no success tokens on failure)"
exit 0
