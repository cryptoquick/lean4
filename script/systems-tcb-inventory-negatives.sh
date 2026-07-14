#!/usr/bin/env bash
# Negative / positive cases for systems-tcb-inventory.sh (TCB honesty, fail-closed).
#
# Ensures:
#   * Success path emits measured GC_FREE_ELABORATOR (0 on classic stage1) + TCB_HONESTY_OK=1
#   * Shared systems-tcb-honesty-check.sh rejects forged GC_FREE_ELABORATOR=1 without earn tokens
#   * Dual TCB_HONESTY_OK=0 and =1 rejected by shared checker
#   * Missing lean under REQUIRE → non-zero + TCB_HONESTY_OK=0 (no PATH fallback)
#   * Missing / empty bundle under REQUIRE → non-zero + TCB_HONESTY_OK=0
#   * Product residual under REQUIRE fails (thin; residual_nm is primary product gate)
#   * PRODUCT_GC_FREE / PRODUCT_NO_LEANSHARED fail-closed:
#       residual dirty / missing bundle / missing nm / empty nm / unscanned → =0
#       clean scanned bundle → =1; never dual =0 and =1
#   * PATH without nm + non-empty clean archive → PRODUCT_*=0 (advisory + REQUIRE)
#   * SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 without earned residual → FAIL
#   * Inventory emits HOST_ELABORATOR_RESIDUAL (G3 measured class)
#
# Does not require freestanding product artifacts for most cases (uses temp paths).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GATE="$ROOT/script/systems-tcb-inventory.sh"
# shellcheck source=systems-tcb-honesty-check.sh
source "$ROOT/script/systems-tcb-honesty-check.sh"
chmod +x "$GATE"
chmod +x "$ROOT/script/systems-host-elaborator-residual.sh" 2>/dev/null || true

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

# Prefer stage1 when present (positive advisory may use real lean).
# Explicit SYSTEMS_LEAN_TCB_LEAN in cases below still must not fall back to this PATH.
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
fi

assert_product_gc_tokens() {
  local name="$1" out="$2" expect="$3" # expect is 0 or 1
  if ! grep -qx "PRODUCT_GC_FREE=${expect}" "$out"; then
    echo "FAIL: case $name: expected PRODUCT_GC_FREE=${expect}" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx "PRODUCT_NO_LEANSHARED=${expect}" "$out"; then
    echo "FAIL: case $name: expected PRODUCT_NO_LEANSHARED=${expect}" >&2
    cat "$out" >&2
    exit 1
  fi
  # Never dual 0 and 1 for product GC tokens.
  local gc0 gc1 ns0 ns1
  gc0="$(grep -cx 'PRODUCT_GC_FREE=0' "$out" || true)"
  gc1="$(grep -cx 'PRODUCT_GC_FREE=1' "$out" || true)"
  ns0="$(grep -cx 'PRODUCT_NO_LEANSHARED=0' "$out" || true)"
  ns1="$(grep -cx 'PRODUCT_NO_LEANSHARED=1' "$out" || true)"
  if [[ "$((gc0 + gc1))" -ne 1 ]] || [[ "$((ns0 + ns1))" -ne 1 ]]; then
    echo "FAIL: case $name: dual or missing PRODUCT_GC_FREE / PRODUCT_NO_LEANSHARED lines" >&2
    cat "$out" >&2
    exit 1
  fi
}

fail_case() {
  local name="$1"
  shift
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  if [[ $ec -eq 0 ]]; then
    echo "FAIL: expected non-zero for case $name" >&2
    cat "$out" >&2
    exit 1
  fi
  if grep -qx 'TCB_HONESTY_OK=1' "$out"; then
    echo "FAIL: case $name printed TCB_HONESTY_OK=1 on failure" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'TCB_HONESTY_OK=0' "$out"; then
    echo "FAIL: case $name missing TCB_HONESTY_OK=0" >&2
    cat "$out" >&2
    exit 1
  fi
  # Honesty: never claim GC-free elaborator even on failure paths.
  if grep -qx 'GC_FREE_ELABORATOR=1' "$out"; then
    echo "FAIL: case $name emitted GC_FREE_ELABORATOR=1" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'GC_FREE_ELABORATOR=0' "$out"; then
    echo "FAIL: case $name missing GC_FREE_ELABORATOR=0" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line in output" >&2
    cat "$out" >&2
    exit 1
  fi
  # Failure / unscanned residual must not claim product GC-free.
  assert_product_gc_tokens "$name" "$out" 0
  # Shared checker must not accept a failure transcript as PASS-quality.
  if systems_lean_tcb_honesty_tokens_ok "$out"; then
    echo "FAIL: case $name accepted by systems_lean_tcb_honesty_tokens_ok" >&2
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
  if ! systems_lean_tcb_honesty_tokens_ok "$out"; then
    echo "FAIL: case $name failed shared systems_lean_tcb_honesty_tokens_ok" >&2
    cat "$out" >&2
    exit 1
  fi
  # Inventory still emits PRODUCT_FS_NEXT (not required by validate checker).
  if ! grep -qE '^PRODUCT_FS_NEXT=' "$out"; then
    echo "FAIL: case $name missing PRODUCT_FS_NEXT=" >&2
    cat "$out" >&2
    exit 1
  fi
  # G3: host residual class always emitted (measured).
  if ! grep -qE '^HOST_ELABORATOR_RESIDUAL=' "$out"; then
    echo "FAIL: case $name missing HOST_ELABORATOR_RESIDUAL=" >&2
    cat "$out" >&2
    exit 1
  fi
  # Always emit exactly one product GC token pair (0 or 1, never dual).
  local gc0 gc1
  gc0="$(grep -cx 'PRODUCT_GC_FREE=0' "$out" || true)"
  gc1="$(grep -cx 'PRODUCT_GC_FREE=1' "$out" || true)"
  if [[ "$((gc0 + gc1))" -ne 1 ]]; then
    echo "FAIL: case $name: dual or missing PRODUCT_GC_FREE" >&2
    cat "$out" >&2
    exit 1
  fi
  # Exactly one host GC_FREE token (measured 0 or earned 1).
  local hgc0 hgc1
  hgc0="$(grep -cx 'GC_FREE_ELABORATOR=0' "$out" || true)"
  hgc1="$(grep -cx 'GC_FREE_ELABORATOR=1' "$out" || true)"
  if [[ "$((hgc0 + hgc1))" -ne 1 ]]; then
    echo "FAIL: case $name: dual or missing GC_FREE_ELABORATOR" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: positive case $name"
}

# --- 1) Forged success claiming GC_FREE_ELABORATOR=1 without earn tokens → reject ---
cat >"$tmpdir/forged_gc_free.out" <<'EOF'
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=1
TCB_HONESTY_OK=1
EOF
if systems_lean_tcb_honesty_tokens_ok "$tmpdir/forged_gc_free.out"; then
  echo "FAIL: forged GC_FREE_ELABORATOR=1 was accepted by honesty checker" >&2
  exit 1
fi
echo "OK: negative case forged_gc_free_elaborator (checker rejects GC_FREE=1 without earn path)"

# --- 1b) Forged GC_FREE=1 with HOST_HAS_LEANSHARED=1 → reject ---
cat >"$tmpdir/forged_gc_with_shared.out" <<'EOF'
HOST_ELABORATOR_TCB=residual_free
HOST_ELABORATOR_RESIDUAL=residual_free
HOST_HAS_LEANSHARED=1
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=1
TCB_HONESTY_OK=1
EOF
if systems_lean_tcb_honesty_tokens_ok "$tmpdir/forged_gc_with_shared.out"; then
  echo "FAIL: GC_FREE=1 with HOST_HAS_LEANSHARED=1 accepted" >&2
  exit 1
fi
echo "OK: negative case forged_gc_with_leanshared"

# --- 2) Forged TCB_HONESTY_OK without GC_FREE=0 ---
cat >"$tmpdir/forged_ok_no_gc0.out" <<'EOF'
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
PRODUCT_EMBED_TCB=residual_free_goal
TCB_HONESTY_OK=1
EOF
if systems_lean_tcb_honesty_tokens_ok "$tmpdir/forged_ok_no_gc0.out"; then
  echo "FAIL: output missing GC_FREE_ELABORATOR=0 was accepted" >&2
  exit 1
fi
echo "OK: negative case missing_gc_free_token (checker rejects)"

# --- 2b) Dual TCB_HONESTY_OK=0 and =1 rejected ---
cat >"$tmpdir/dual_honesty.out" <<'EOF'
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=0
TCB_HONESTY_OK=0
TCB_HONESTY_OK=1
EOF
if systems_lean_tcb_honesty_tokens_ok "$tmpdir/dual_honesty.out"; then
  echo "FAIL: dual TCB_HONESTY_OK=0 and =1 was accepted" >&2
  exit 1
fi
echo "OK: negative case dual_tcb_honesty_ok (checker rejects dual 0/1)"

# --- 3) Missing lean under REQUIRE (must not PATH-fallback to stage1) ---
# PATH has stage1 lean above; explicit SYSTEMS_LEAN_TCB_LEAN must still fail.
fail_case missing_lean_require \
  env SYSTEMS_LEAN_TCB_REQUIRE=1 \
      SYSTEMS_LEAN_TCB_LEAN="$tmpdir/no-such-lean" \
      SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/no-such-bundle.a" \
      "$GATE"
if ! grep -qE 'lean missing' "$tmpdir/missing_lean_require.out"; then
  echo "FAIL: missing_lean_require did not report lean missing (wrong fail path?)" >&2
  cat "$tmpdir/missing_lean_require.out" >&2
  exit 1
fi
echo "OK: missing_lean_require failed for lean (not PATH fallback)"

# --- 4) Missing bundle under REQUIRE (lean may exist) ---
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  fail_case missing_bundle_require \
    env SYSTEMS_LEAN_TCB_REQUIRE=1 \
        SYSTEMS_LEAN_TCB_LEAN="$ROOT/build/release/stage1/bin/lean" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/no-such-bundle.a" \
        "$GATE"
else
  echo "OK: skip missing_bundle_require (no stage1 lean; missing_lean_require covers REQUIRE)"
fi

# --- 4b) Empty bundle under REQUIRE ---
: >"$tmpdir/empty-bundle.a"
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  fail_case empty_bundle_require \
    env SYSTEMS_LEAN_TCB_REQUIRE=1 \
        SYSTEMS_LEAN_TCB_LEAN="$ROOT/build/release/stage1/bin/lean" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/empty-bundle.a" \
        "$GATE"
else
  printf '#!/bin/sh\nexit 0\n' >"$tmpdir/fake-lean-empty"
  chmod +x "$tmpdir/fake-lean-empty"
  fail_case empty_bundle_require \
    env SYSTEMS_LEAN_TCB_REQUIRE=1 \
        SYSTEMS_LEAN_TCB_LEAN="$tmpdir/fake-lean-empty" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/empty-bundle.a" \
        "$GATE"
fi

# Resolve C compiler (align with link-check negatives / validate).
CC_BIN="${CC:-}"
if [[ -z "$CC_BIN" ]]; then
  if command -v cc >/dev/null 2>&1; then
    CC_BIN="$(command -v cc)"
  elif command -v gcc >/dev/null 2>&1; then
    CC_BIN="$(command -v gcc)"
  fi
fi

lean_arg=()
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  lean_arg=(SYSTEMS_LEAN_TCB_LEAN="$ROOT/build/release/stage1/bin/lean")
else
  printf '#!/bin/sh\nexit 0\n' >"$tmpdir/fake-lean"
  chmod +x "$tmpdir/fake-lean"
  lean_arg=(SYSTEMS_LEAN_TCB_LEAN="$tmpdir/fake-lean")
fi

# --- 5) Product residual under REQUIRE fails + PRODUCT_GC_FREE=0 ---
if [[ -n "$CC_BIN" ]]; then
  cat >"$tmpdir/residual.c" <<'EOF'
extern void lean_inc(void *);
void residual_touch(void *o) { lean_inc(o); }
EOF
  "$CC_BIN" -c -o "$tmpdir/residual.o" "$tmpdir/residual.c"
  ar rcs "$tmpdir/libresidual.a" "$tmpdir/residual.o"
  fail_case product_residual_require \
    env SYSTEMS_LEAN_TCB_REQUIRE=1 \
        "${lean_arg[@]}" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/libresidual.a" \
        "$GATE"

  # 5b) Defined RC residual under REQUIRE also PRODUCT_GC_FREE=0
  cat >"$tmpdir/rcdef.c" <<'EOF'
void lean_inc(void *o) { (void)o; }
void product_entry(void *o) { lean_inc(o); }
EOF
  "$CC_BIN" -c -o "$tmpdir/rcdef.o" "$tmpdir/rcdef.c"
  ar rcs "$tmpdir/librcdef.a" "$tmpdir/rcdef.o"
  fail_case product_rc_def_require \
    env SYSTEMS_LEAN_TCB_REQUIRE=1 \
        "${lean_arg[@]}" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/librcdef.a" \
        "$GATE"

  # 5c) Shared-lib residue under REQUIRE
  cat >"$tmpdir/shared.c" <<'EOF'
void Init_shared_bogus(void) {}
void leanshared_bogus(void) {}
EOF
  "$CC_BIN" -c -o "$tmpdir/shared.o" "$tmpdir/shared.c"
  ar rcs "$tmpdir/libshared.a" "$tmpdir/shared.o"
  fail_case product_shared_require \
    env SYSTEMS_LEAN_TCB_REQUIRE=1 \
        "${lean_arg[@]}" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/libshared.a" \
        "$GATE"
else
  echo "OK: skip product_residual_require / rc_def / shared (no host cc; residual_nm negatives cover product residual)"
fi

# --- 6) Positive advisory: real script emits honest tokens (exit 0) ---
# Advisory mode: missing bundle is OK (still exit 0 + honesty tokens) and PRODUCT_GC_FREE=0.
adv_lean="${SYSTEMS_LEAN_TCB_LEAN:-}"
if [[ -z "$adv_lean" ]]; then
  if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
    adv_lean="$ROOT/build/release/stage1/bin/lean"
  else
    adv_lean="$tmpdir/no-lean-advisory"
  fi
fi
pass_case advisory_tokens \
  env SYSTEMS_LEAN_TCB_REQUIRE=0 \
      SYSTEMS_LEAN_TCB_LEAN="$adv_lean" \
      SYSTEMS_LEAN_TCB_BUNDLE="${SYSTEMS_LEAN_TCB_BUNDLE:-$tmpdir/no-bundle.a}" \
      "$GATE"
assert_product_gc_tokens advisory_tokens "$tmpdir/advisory_tokens.out" 0
echo "OK: advisory missing-bundle emits PRODUCT_GC_FREE=0 (unchecked residual)"

# --- 6b) Advisory residual-dirty bundle → PRODUCT_GC_FREE=0 (exit 0) ---
if [[ -n "$CC_BIN" && -f "$tmpdir/libresidual.a" ]]; then
  pass_case advisory_residual_dirty \
    env SYSTEMS_LEAN_TCB_REQUIRE=0 \
        "${lean_arg[@]}" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/libresidual.a" \
        "$GATE"
  assert_product_gc_tokens advisory_residual_dirty "$tmpdir/advisory_residual_dirty.out" 0
  echo "OK: advisory residual-dirty emits PRODUCT_GC_FREE=0"
fi

# --- 6c) Clean product object archive → PRODUCT_GC_FREE=1 ---
# Prefer a CC-built clean archive; fall back to real freestanding bundle if present.
clean_bundle=""
if [[ -n "$CC_BIN" ]]; then
  cat >"$tmpdir/clean.c" <<'EOF'
unsigned lean_fs_add_u(unsigned a, unsigned b) { return a + b; }
EOF
  "$CC_BIN" -c -o "$tmpdir/clean.o" "$tmpdir/clean.c"
  ar rcs "$tmpdir/libclean.a" "$tmpdir/clean.o"
  clean_bundle="$tmpdir/libclean.a"
elif [[ -s "$ROOT/tests/lake/examples/systems/lib/.lake/build/lib/libfs_extract_bundle.a" ]]; then
  clean_bundle="$ROOT/tests/lake/examples/systems/lib/.lake/build/lib/libfs_extract_bundle.a"
fi
if [[ -n "$clean_bundle" ]]; then
  pass_case advisory_clean_bundle \
    env SYSTEMS_LEAN_TCB_REQUIRE=0 \
        "${lean_arg[@]}" \
        SYSTEMS_LEAN_TCB_BUNDLE="$clean_bundle" \
        "$GATE"
  assert_product_gc_tokens advisory_clean_bundle "$tmpdir/advisory_clean_bundle.out" 1
  echo "OK: advisory clean bundle emits PRODUCT_GC_FREE=1 PRODUCT_NO_LEANSHARED=1"
else
  echo "OK: skip advisory_clean_bundle (no cc and no freestanding bundle)"
fi

# --- 6d) PATH without nm + non-empty clean archive → PRODUCT_GC_FREE=0 (unscanned) ---
# Regression for product_residual_checked: missing nm must not default-to-clean (=1).
if [[ -n "$clean_bundle" ]] && command -v nm >/dev/null 2>&1; then
  # Disposable PATH: coreutils/shell helpers only — deliberately omit nm.
  tools="$tmpdir/path_no_nm"
  mkdir -p "$tools"
  # env must resolve bash shebang helpers; inventory needs date/head/sed/grep/cat.
  for cmd in bash env date head sed grep cat tr uname dirname basename mktemp true false od cmp wc printf; do
    if p="$(command -v "$cmd" 2>/dev/null)"; then
      ln -sf "$p" "$tools/$cmd"
    fi
  done
  # Include readelf/objdump/ldd for host residual scan (ELF NEEDED); never nm.
  for cmd in readelf objdump ldd ar; do
    if p="$(command -v "$cmd" 2>/dev/null)"; then
      ln -sf "$p" "$tools/$cmd"
    fi
  done
  if PATH="$tools" command -v nm >/dev/null 2>&1; then
    echo "FAIL: path_no_nm fixture still resolves nm" >&2
    exit 1
  fi
  # Advisory: exit 0, honesty OK, but PRODUCT_GC_FREE=0 (residual unchecked).
  pass_case advisory_no_nm \
    env PATH="$tools" \
        SYSTEMS_LEAN_TCB_REQUIRE=0 \
        "${lean_arg[@]}" \
        SYSTEMS_LEAN_TCB_BUNDLE="$clean_bundle" \
        "$GATE"
  assert_product_gc_tokens advisory_no_nm "$tmpdir/advisory_no_nm.out" 0
  if ! grep -qE 'nm not available' "$tmpdir/advisory_no_nm.out"; then
    echo "FAIL: advisory_no_nm expected nm-not-available note" >&2
    cat "$tmpdir/advisory_no_nm.out" >&2
    exit 1
  fi
  echo "OK: advisory PATH without nm + clean archive emits PRODUCT_GC_FREE=0"

  # REQUIRE: non-zero + TCB_HONESTY_OK=0 + PRODUCT_GC_FREE=0 + nm not available.
  fail_case no_nm_require \
    env PATH="$tools" \
        SYSTEMS_LEAN_TCB_REQUIRE=1 \
        "${lean_arg[@]}" \
        SYSTEMS_LEAN_TCB_BUNDLE="$clean_bundle" \
        "$GATE"
  if ! grep -qE 'nm not available' "$tmpdir/no_nm_require.out"; then
    echo "FAIL: no_nm_require did not report nm not available" >&2
    cat "$tmpdir/no_nm_require.out" >&2
    exit 1
  fi
  echo "OK: REQUIRE PATH without nm fails closed with PRODUCT_GC_FREE=0"
else
  echo "OK: skip no-nm product GC cases (need clean archive + host nm to build fixture contrast)"
fi

echo "OK: positive case honesty_checker_accepts_real_tokens (via shared checker in pass_case)"

# --- 7) Clean tokens fixture accepted ---
cat >"$tmpdir/clean_tokens.out" <<'EOF'
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=0
TCB_HONESTY_OK=1
EOF
if ! systems_lean_tcb_honesty_tokens_ok "$tmpdir/clean_tokens.out"; then
  echo "FAIL: clean honesty tokens rejected" >&2
  exit 1
fi
echo "OK: positive case clean_token_fixture"

# --- 8) Stdin form of shared checker ---
if ! systems_lean_tcb_honesty_tokens_ok <<<"$(cat "$tmpdir/clean_tokens.out")"; then
  echo "FAIL: stdin form of systems_lean_tcb_honesty_tokens_ok rejected clean tokens" >&2
  exit 1
fi
echo "OK: positive case clean_token_fixture_stdin"

# --- 9) residual_free earn honesty fixture accepted ---
cat >"$tmpdir/earn_tokens.out" <<'EOF'
HOST_ELABORATOR_TCB=residual_free
HOST_ELABORATOR_RESIDUAL=residual_free
HOST_HAS_LEANSHARED=0
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=1
TCB_HONESTY_OK=1
EOF
if ! systems_lean_tcb_honesty_tokens_ok "$tmpdir/earn_tokens.out"; then
  echo "FAIL: residual_free earn honesty tokens rejected" >&2
  exit 1
fi
echo "OK: positive case residual_free_earn_honesty_fixture"

# --- 10) FORCE_GC_FREE without earned residual fails (stage1 or fake lean) ---
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  fail_case force_gc_free_refused \
    env SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 \
        SYSTEMS_LEAN_TCB_REQUIRE=0 \
        SYSTEMS_LEAN_TCB_LEAN="$ROOT/build/release/stage1/bin/lean" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/no-bundle-force.a" \
        "$GATE"
  if ! grep -qE 'FORCE_GC_FREE|refused' "$tmpdir/force_gc_free_refused.out"; then
    echo "FAIL: force_gc_free_refused missing refuse message" >&2
    cat "$tmpdir/force_gc_free_refused.out" >&2
    exit 1
  fi
  echo "OK: inventory FORCE_GC_FREE refused on classic stage1"
else
  echo "OK: skip force_gc_free_refused (no stage1 lean)"
fi

# --- 11) Stage1 inventory: measured GC_FREE=0 + classic residual when lean present ---
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  pass_case stage1_measured_classic \
    env SYSTEMS_LEAN_TCB_REQUIRE=0 \
        SYSTEMS_LEAN_TCB_LEAN="$ROOT/build/release/stage1/bin/lean" \
        SYSTEMS_LEAN_TCB_BUNDLE="$tmpdir/no-bundle-stage1.a" \
        "$GATE"
  if ! grep -qx 'GC_FREE_ELABORATOR=0' "$tmpdir/stage1_measured_classic.out"; then
    echo "FAIL: stage1 inventory expected GC_FREE_ELABORATOR=0" >&2
    cat "$tmpdir/stage1_measured_classic.out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_HAS_LEANSHARED=1' "$tmpdir/stage1_measured_classic.out"; then
    echo "FAIL: stage1 inventory expected HOST_HAS_LEANSHARED=1" >&2
    cat "$tmpdir/stage1_measured_classic.out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime' "$tmpdir/stage1_measured_classic.out"; then
    echo "FAIL: stage1 inventory expected classic residual" >&2
    cat "$tmpdir/stage1_measured_classic.out" >&2
    exit 1
  fi
  echo "OK: stage1 inventory measures classic residual (G3)"
else
  echo "OK: skip stage1_measured_classic (no stage1 lean)"
fi

echo "OK: systems-tcb-inventory negatives (fail-closed; shared honesty checker; measured G3 dual path)"
exit 0
