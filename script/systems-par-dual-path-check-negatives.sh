#!/usr/bin/env bash
# Negative cases for systems-par-dual-path-check.sh (fail-closed Track C isolation).
#
# Ensures that if product somehow exposes pthread / HW-SIMD dogfood symbols or
# residual IR, the dual-path check exits ≠ 0 and never prints success tokens.
# Primary PARALLELISM_* / PRODUCT_PARALLELISM_* tokens only (no PAR_* aliases).
#
# Usage (lean4 root):
#   ./script/systems-par-dual-path-check-negatives.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
GATE="$ROOT/script/systems-par-dual-path-check.sh"
FS_EXAMPLE="$ROOT/tests/lake/examples/systems"
REAL_BUNDLE="$FS_EXAMPLE/lib/.lake/build/lib/libfs_extract_bundle.a"

chmod +x "$GATE" 2>/dev/null || true

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

# Write a complete clean Par IR matrix under $1 (directory).
write_clean_ir() {
  local root="$1"
  mkdir -p "$root/Systems/Parallelism"
  printf '/* shaped map only */\nint mapAddU8Chunk4;\nuint32_t lean_fs_par_map_fold;\n' \
    >"$root/Extract.c"
  printf '/* L1 */\nint mapAddU8;\nint mapAddU8Chunk4;\n' \
    >"$root/Systems/Parallelism/Simd.c"
  printf '/* L2 sequential */\nint forkJoinMapAdd;\n' \
    >"$root/Systems/Parallelism/ForkJoin.c"
  printf '/* L3 */\nint chanPing;\n' \
    >"$root/Systems/Parallelism/Channel.c"
}

# Assert dropped one-wave aliases are never emitted (primary PARALLELISM_* only).
assert_no_par_aliases() {
  local out="$1"
  local ctx="$2"
  if printf '%s\n' "$out" | grep -qE '^(PAR_DUAL_PATH_OK|PRODUCT_PAR_[A-Z0-9_]+)='; then
    echo "$out"
    fail "dropped PAR_* / PRODUCT_PAR_* alias emitted ($ctx)"
  fi
}

# Real product (if present) must PASS isolation — positives keep SCORE green.
if [[ -f "$REAL_BUNDLE" ]]; then
  echo "=== positive: real freestanding product bundle must be dual-path clean ==="
  out="$("$GATE" "$REAL_BUNDLE" 2>&1)" || {
    echo "$out"
    fail "real product bundle failed dual-path check"
  }
  printf '%s\n' "$out" | grep -qx 'PARALLELISM_DUAL_PATH_OK=1' \
    || { echo "$out"; fail "missing PARALLELISM_DUAL_PATH_OK=1 on real product"; }
  printf '%s\n' "$out" | grep -qx 'PRODUCT_PARALLELISM_NO_PTHREAD=1' \
    || { echo "$out"; fail "missing PRODUCT_PARALLELISM_NO_PTHREAD=1 on real product"; }
  printf '%s\n' "$out" | grep -qx 'PRODUCT_PARALLELISM_L2_SEQUENTIAL=1' \
    || { echo "$out"; fail "missing PRODUCT_PARALLELISM_L2_SEQUENTIAL=1 on real product"; }
  printf '%s\n' "$out" | grep -qx 'PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1' \
    || { echo "$out"; fail "missing PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1 on real product"; }
  printf '%s\n' "$out" | grep -qx 'CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1' \
    || { echo "$out"; fail "missing CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1 on real product"; }
  assert_no_par_aliases "$out" "real product PASS"
  echo "OK: real product dual-path PASS"
else
  echo "NOTE: real freestanding bundle missing — skip positive (artifact-only negatives still run)"
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# --- missing artifact ---
echo "=== negative: missing bundle → FAIL, no success tokens ==="
set +e
out="$("$GATE" "$tmpdir/does-not-exist.a" 2>&1)"
rc=$?
set -e
[[ "$rc" -ne 0 ]] || { echo "$out"; fail "missing bundle should exit ≠ 0"; }
printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
  && { echo "$out"; fail "success token on missing bundle"; } || true
printf '%s\n' "$out" | grep -qx 'PARALLELISM_DUAL_PATH_OK=0' \
  || { echo "$out"; fail "expected PARALLELISM_DUAL_PATH_OK=0 on missing bundle"; }
assert_no_par_aliases "$out" "missing bundle FAIL"

# --- empty artifact ---
echo "=== negative: empty bundle → FAIL ==="
: >"$tmpdir/empty.a"
set +e
out="$("$GATE" "$tmpdir/empty.a" 2>&1)"
rc=$?
set -e
[[ "$rc" -ne 0 ]] || { echo "$out"; fail "empty bundle should exit ≠ 0"; }
printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
  && { echo "$out"; fail "success token on empty bundle"; } || true
printf '%s\n' "$out" | grep -qx 'PARALLELISM_DUAL_PATH_OK=0' \
  || { echo "$out"; fail "expected PARALLELISM_DUAL_PATH_OK=0 on empty bundle"; }
# Other success tokens must also be 0 (symmetry with missing-bundle).
for tok in PRODUCT_PARALLELISM_L2_SEQUENTIAL PRODUCT_PARALLELISM_NO_PTHREAD \
           PRODUCT_PARALLELISM_L1_SHAPED_ONLY CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED; do
  printf '%s\n' "$out" | grep -qx "${tok}=0" \
    || { echo "$out"; fail "expected ${tok}=0 on empty bundle"; }
done
assert_no_par_aliases "$out" "empty bundle FAIL"

# --- forged product with pthread dogfood T symbols ---
if command -v cc >/dev/null 2>&1; then
  echo "=== negative: archive with lean_fs_par_fork_join_pthread T → FAIL isolation ==="
  cat >"$tmpdir/forged_pthread.c" <<'EOF'
#include <stddef.h>
#include <stdint.h>
/* Minimal forged "product" that wrongly exports pthread dogfood symbols. */
uint32_t lean_fs_par_l2_backend(uint32_t u) { (void)u; return 0u; }
uint32_t lean_fs_par_fork_join(size_t d, size_t s, size_t n, uint8_t a) {
  (void)d; (void)s; (void)n; (void)a; return 0u;
}
uint32_t lean_fs_par_fork_join_pthread(size_t d, size_t s, size_t n, uint8_t a) {
  (void)d; (void)s; (void)n; (void)a; return 0u;
}
uint32_t lean_fs_par_l2_backend_pthread(uint32_t u) { (void)u; return 1u; }
EOF
  cc -std=c11 -c -o "$tmpdir/forged_pthread.o" "$tmpdir/forged_pthread.c"
  ar rcs "$tmpdir/forged_pthread.a" "$tmpdir/forged_pthread.o"
  write_clean_ir "$tmpdir/ir"
  set +e
  out="$(SYSTEMS_LEAN_PAR_IR_ROOT="$tmpdir/ir" "$GATE" "$tmpdir/forged_pthread.a" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" -ne 0 ]] || { echo "$out"; fail "pthread-exporting archive should fail dual-path"; }
  printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
    && { echo "$out"; fail "success token when product defines pthread dogfood"; } || true
  printf '%s\n' "$out" | grep -E 'fork_join_pthread|PRODUCT_PARALLELISM_NO_PTHREAD=0|host dogfood' >/dev/null \
    || { echo "$out"; fail "expected isolation diagnostic for pthread dogfood defs"; }
  assert_no_par_aliases "$out" "forged pthread FAIL"
  echo "OK: forged pthread product FAIL"

  echo "=== negative: archive with only lean_fs_par_map_add_u8_simd_hw T → FAIL isolation ==="
  cat >"$tmpdir/forged_simd.c" <<'EOF'
#include <stddef.h>
#include <stdint.h>
uint32_t lean_fs_par_l2_backend(uint32_t u) { (void)u; return 0u; }
uint32_t lean_fs_par_fork_join(size_t d, size_t s, size_t n, uint8_t a) {
  (void)d; (void)s; (void)n; (void)a; return 0u;
}
uint32_t lean_fs_par_map_add_u8_simd_hw(size_t d, size_t s, size_t n, uint8_t a) {
  (void)d; (void)s; (void)n; (void)a; return 0u;
}
EOF
  cc -std=c11 -c -o "$tmpdir/forged_simd.o" "$tmpdir/forged_simd.c"
  ar rcs "$tmpdir/forged_simd.a" "$tmpdir/forged_simd.o"
  write_clean_ir "$tmpdir/ir_simd_t"
  set +e
  out="$(SYSTEMS_LEAN_PAR_IR_ROOT="$tmpdir/ir_simd_t" "$GATE" "$tmpdir/forged_simd.a" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" -ne 0 ]] || { echo "$out"; fail "simd_hw-exporting archive should fail dual-path"; }
  printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
    && { echo "$out"; fail "success token when product defines simd_hw dogfood"; } || true
  printf '%s\n' "$out" | grep -E 'map_add_u8_simd_hw|host dogfood|PRODUCT_PARALLELISM_NO_PTHREAD=0' >/dev/null \
    || { echo "$out"; fail "expected isolation diagnostic for simd_hw dogfood def"; }
  assert_no_par_aliases "$out" "forged simd_hw FAIL"
  echo "OK: forged simd_hw product FAIL"

  echo "=== negative: missing T lean_fs_par_l2_backend → FAIL ==="
  cat >"$tmpdir/no_l2.c" <<'EOF'
#include <stddef.h>
#include <stdint.h>
/* Sequential fork_join present but L2 backend export missing. */
uint32_t lean_fs_par_fork_join(size_t d, size_t s, size_t n, uint8_t a) {
  (void)d; (void)s; (void)n; (void)a; return 0u;
}
EOF
  cc -std=c11 -c -o "$tmpdir/no_l2.o" "$tmpdir/no_l2.c"
  ar rcs "$tmpdir/no_l2.a" "$tmpdir/no_l2.o"
  write_clean_ir "$tmpdir/ir_no_l2"
  set +e
  out="$(SYSTEMS_LEAN_PAR_IR_ROOT="$tmpdir/ir_no_l2" "$GATE" "$tmpdir/no_l2.a" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" -ne 0 ]] || { echo "$out"; fail "missing lean_fs_par_l2_backend should fail"; }
  printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
    && { echo "$out"; fail "success token when L2 backend T missing"; } || true
  printf '%s\n' "$out" | grep -E 'lean_fs_par_l2_backend|PRODUCT_PARALLELISM_L2_SEQUENTIAL=0' >/dev/null \
    || { echo "$out"; fail "expected diagnostic for missing L2 backend"; }
  assert_no_par_aliases "$out" "missing L2 backend FAIL"
  echo "OK: missing L2 backend FAIL"

  echo "=== negative: U pthread_create residual → FAIL isolation ==="
  cat >"$tmpdir/u_pthread.c" <<'EOF'
#include <stddef.h>
#include <stdint.h>
/* Forged product that leaves pthread_create undefined (wrong residual). */
extern int pthread_create(void *t, const void *a, void *(*start)(void *), void *arg);
uint32_t lean_fs_par_l2_backend(uint32_t u) { (void)u; return 0u; }
uint32_t lean_fs_par_fork_join(size_t d, size_t s, size_t n, uint8_t a) {
  (void)d; (void)s; (void)n; (void)a;
  /* Force a U pthread_create without linking -pthread into the .a object. */
  (void)pthread_create((void *)0, (const void *)0, (void *(*)(void *))0, (void *)0);
  return 0u;
}
EOF
  cc -std=c11 -c -o "$tmpdir/u_pthread.o" "$tmpdir/u_pthread.c"
  ar rcs "$tmpdir/u_pthread.a" "$tmpdir/u_pthread.o"
  write_clean_ir "$tmpdir/ir_u_pthread"
  # Confirm nm sees U pthread_create
  if ! nm -u "$tmpdir/u_pthread.a" 2>/dev/null | grep -E 'pthread_create' >/dev/null; then
    # Some linkers may not leave U if optimized away — force with volatile
    cat >"$tmpdir/u_pthread2.c" <<'EOF'
#include <stddef.h>
#include <stdint.h>
int pthread_create(void *, const void *, void *(*)(void *), void *);
static int (*volatile p_create)(void *, const void *, void *(*)(void *), void *) = pthread_create;
uint32_t lean_fs_par_l2_backend(uint32_t u) { (void)u; return 0u; }
uint32_t lean_fs_par_fork_join(size_t d, size_t s, size_t n, uint8_t a) {
  (void)d; (void)s; (void)n; (void)a;
  return (uint32_t)(uintptr_t)p_create;
}
EOF
    cc -std=c11 -c -o "$tmpdir/u_pthread.o" "$tmpdir/u_pthread2.c"
    ar rcs "$tmpdir/u_pthread.a" "$tmpdir/u_pthread.o"
  fi
  set +e
  out="$(SYSTEMS_LEAN_PAR_IR_ROOT="$tmpdir/ir_u_pthread" "$GATE" "$tmpdir/u_pthread.a" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" -ne 0 ]] || { echo "$out"; fail "U pthread_create residual should fail dual-path"; }
  printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
    && { echo "$out"; fail "success token when product has U pthread_create"; } || true
  printf '%s\n' "$out" | grep -E 'pthread|PRODUCT_PARALLELISM_NO_PTHREAD=0' >/dev/null \
    || { echo "$out"; fail "expected pthread residual diagnostic"; }
  assert_no_par_aliases "$out" "U pthread residual FAIL"
  echo "OK: U pthread_create residual FAIL"

  echo "=== negative: partial Par IR matrix (missing Channel.c) → FAIL ==="
  cat >"$tmpdir/clean_seq.c" <<'EOF'
#include <stddef.h>
#include <stdint.h>
uint32_t lean_fs_par_l2_backend(uint32_t u) { (void)u; return 0u; }
uint32_t lean_fs_par_fork_join(size_t d, size_t s, size_t n, uint8_t a) {
  (void)d; (void)s; (void)n; (void)a; return 0u;
}
EOF
  cc -std=c11 -c -o "$tmpdir/clean_seq.o" "$tmpdir/clean_seq.c"
  ar rcs "$tmpdir/clean_seq.a" "$tmpdir/clean_seq.o"
  write_clean_ir "$tmpdir/ir_partial"
  rm -f "$tmpdir/ir_partial/Systems/Parallelism/Channel.c"
  set +e
  out="$(SYSTEMS_LEAN_PAR_IR_ROOT="$tmpdir/ir_partial" "$GATE" "$tmpdir/clean_seq.a" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" -ne 0 ]] || { echo "$out"; fail "partial Par IR matrix should fail"; }
  printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
    && { echo "$out"; fail "success token on partial Par IR"; } || true
  printf '%s\n' "$out" | grep -E 'incomplete product Par IR|missing:.*Channel' >/dev/null \
    || { echo "$out"; fail "expected incomplete matrix diagnostic"; }
  assert_no_par_aliases "$out" "partial Par IR FAIL"
  echo "OK: partial Par IR FAIL"

  echo "=== negative: IR with pthread.h → FAIL even if nm is clean ==="
  write_clean_ir "$tmpdir/ir_bad"
  printf '#include <pthread.h>\nint mapAddU8Chunk4;\nuint32_t lean_fs_par_map_fold;\n' \
    >"$tmpdir/ir_bad/Extract.c"
  set +e
  out="$(SYSTEMS_LEAN_PAR_IR_ROOT="$tmpdir/ir_bad" "$GATE" "$tmpdir/clean_seq.a" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" -ne 0 ]] || { echo "$out"; fail "IR with pthread.h should fail"; }
  printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
    && { echo "$out"; fail "success token when IR has pthread.h"; } || true
  assert_no_par_aliases "$out" "IR pthread.h FAIL"
  echo "OK: IR pthread.h FAIL"

  echo "=== negative: IR with _mm_add_epi8 → FAIL L1 shaped-only ==="
  write_clean_ir "$tmpdir/ir_simd"
  printf '#include <emmintrin.h>\nvoid f(void){ (void)_mm_setzero_si128(); }\nint mapAddU8;\nint mapAddU8Chunk4;\n' \
    >"$tmpdir/ir_simd/Systems/Parallelism/Simd.c"
  set +e
  out="$(SYSTEMS_LEAN_PAR_IR_ROOT="$tmpdir/ir_simd" "$GATE" "$tmpdir/clean_seq.a" 2>&1)"
  rc=$?
  set -e
  [[ "$rc" -ne 0 ]] || { echo "$out"; fail "IR with HW SIMD should fail"; }
  printf '%s\n' "$out" | grep -q 'PARALLELISM_DUAL_PATH_OK=1' \
    && { echo "$out"; fail "success token when IR has HW SIMD"; } || true
  printf '%s\n' "$out" | grep -qx 'PRODUCT_PARALLELISM_L1_SHAPED_ONLY=0' \
    || { echo "$out"; fail "expected PRODUCT_PARALLELISM_L1_SHAPED_ONLY=0"; }
  assert_no_par_aliases "$out" "IR HW SIMD FAIL"
  echo "OK: IR HW SIMD FAIL"
else
  echo "NOTE: no host cc — skip object/IR fixture negatives (missing/empty still covered)"
fi

echo "OK: systems-par-dual-path-check negatives (fail-closed; pthread/HW-SIMD isolation)"
exit 0
