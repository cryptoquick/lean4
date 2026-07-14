#!/usr/bin/env bash
# Systems Lean Track C: product vs host dual-path isolation for Three-Layer Cake Parallelism.
#
# Product residual / ccomp matrix must stay **sequential only**:
#   * L2 backend export lean_fs_par_l2_backend is defined (T) on the product bundle
#   * Product must NOT define lean_fs_par_fork_join_pthread / lean_fs_par_l2_backend_pthread
#   * Product must NOT pull pthread_* / pthread headers as product residual deps
#   * Product Parallelism IR is free of pthread / hardware SIMD intrinsics (L1 is shaped chunk-4 only)
#   * When IR root is used (default), the full Parallelism IR matrix is required (fail-closed)
#
# Opt-in host dogfood (par_pthread.c / par_simd_hw.c / make check-par-*) is **out of band**
# and must never be required by residual_nm / residual_ir / default `make check`.
#
# Success tokens (stdout, exact-line; only after all checks pass):
#   PRODUCT_PARALLELISM_L2_SEQUENTIAL=1
#   PRODUCT_PARALLELISM_NO_PTHREAD=1
#   PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1
#   PARALLELISM_DUAL_PATH_OK=1
#   CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1
# Failure: exit ≠ 0; all tokens =0; FAIL: lines on stderr.
# No one-wave PAR_* / PRODUCT_PAR_* transition aliases (primary PARALLELISM_* only).
#
# Usage (lean4 root; freestanding product already built):
#   ./script/systems-par-dual-path-check.sh
#   ./script/systems-par-dual-path-check.sh path/to/libfs_extract_bundle.a
# Env:
#   SYSTEMS_LEAN_PAR_IR_ROOT  — product IR root (default freestanding lib/.lake/build/ir)
#   SYSTEMS_LEAN_PAR_BUNDLE   — override product archive (else argv1 / default bundle)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FS_EXAMPLE="$ROOT/tests/lake/examples/systems"
DEFAULT_BUNDLE="$FS_EXAMPLE/lib/.lake/build/lib/libfs_extract_bundle.a"
BUNDLE="${1:-${SYSTEMS_LEAN_PAR_BUNDLE:-$DEFAULT_BUNDLE}}"
IR_ROOT="${SYSTEMS_LEAN_PAR_IR_ROOT:-$FS_EXAMPLE/lib/.lake/build/ir}"

# Full product Parallelism IR matrix (aligned with residual_ir / check-ir). Required when IR root is set.
REQUIRED_PAR_IR=(
  Extract.c
  Systems/Parallelism/Simd.c
  Systems/Parallelism/ForkJoin.c
  Systems/Parallelism/Channel.c
)

status=0
ok_l2=0
ok_no_pthread=0
ok_l1=0

fail_line() {
  printf 'FAIL: %s\n' "$*" >&2
  status=1
}

ok_line() {
  printf 'OK: %s\n' "$*" >&2
}

emit_fail_tokens() {
  echo "PRODUCT_PARALLELISM_L2_SEQUENTIAL=0"
  echo "PRODUCT_PARALLELISM_NO_PTHREAD=0"
  echo "PRODUCT_PARALLELISM_L1_SHAPED_ONLY=0"
  echo "PARALLELISM_DUAL_PATH_OK=0"
  echo "CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=0"
}

if [[ ! -f "$BUNDLE" ]]; then
  fail_line "missing product bundle: $BUNDLE"
  emit_fail_tokens
  exit 1
fi

if [[ ! -s "$BUNDLE" ]]; then
  fail_line "product bundle is empty: $BUNDLE"
  emit_fail_tokens
  exit 1
fi

if ! command -v nm >/dev/null 2>&1; then
  fail_line "nm required for Par dual-path product isolation check"
  emit_fail_tokens
  exit 1
fi

echo "=== Systems Lean Parallelism dual-path isolation (product sequential only) ===" >&2
echo "bundle: $BUNDLE" >&2
echo "ir_root: $IR_ROOT" >&2

nm_all() {
  nm -- "$BUNDLE" 2>/dev/null || nm -g -- "$BUNDLE" 2>/dev/null || nm -A -- "$BUNDLE" 2>/dev/null || true
}
nm_u() {
  nm -u -- "$BUNDLE" 2>/dev/null || nm -u -C -- "$BUNDLE" 2>/dev/null || nm -u -A -- "$BUNDLE" 2>/dev/null || true
}

allsym=$(nm_all)
undef=$(nm_u)

if [[ -z "$allsym" ]]; then
  fail_line "nm produced no symbols for $BUNDLE"
  emit_fail_tokens
  exit 1
fi

# --- L2 sequential product backend present ---
if echo "$allsym" | grep -E '[[:space:]]T[[:space:]]+lean_fs_par_l2_backend$' >/dev/null; then
  ok_line "product defines T lean_fs_par_l2_backend (sequential L2 id export)"
  ok_l2=1
else
  fail_line "product missing T lean_fs_par_l2_backend (sequential L2 backend export)"
fi

if echo "$allsym" | grep -E '[[:space:]]T[[:space:]]+lean_fs_par_fork_join$' >/dev/null; then
  ok_line "product defines T lean_fs_par_fork_join (sequential L2 body)"
else
  fail_line "product missing T lean_fs_par_fork_join"
  ok_l2=0
fi

# --- Product must not expose pthread / HW-SIMD dogfood symbols ---
bad_dogfood_defs=$(echo "$allsym" | grep -E '[[:space:]][TtWw][[:space:]]+(lean_fs_par_fork_join_pthread|lean_fs_par_l2_backend_pthread|lean_fs_par_map_add_u8_simd_hw|lean_fs_par_l1_backend_simd_hw|pthread_create|pthread_join)$' || true)
if [[ -n "$bad_dogfood_defs" ]]; then
  fail_line "product defines host dogfood / pthread symbols (must stay off residual matrix):"
  printf '%s\n' "$bad_dogfood_defs" >&2
  ok_no_pthread=0
else
  ok_line "product does not define pthread / HW-SIMD dogfood exports"
  ok_no_pthread=1
fi

# Broad residual: any U pthread_* or __pthread* (not just create/join/mutex).
bad_pthread_undef=$(echo "$undef" | grep -E '[[:space:]]U[[:space:]]+(__)?pthread[_A-Za-z0-9]*' || true)
if [[ -n "$bad_pthread_undef" ]]; then
  fail_line "product has pthread undefs (product residual must not depend on libpthread):"
  printf '%s\n' "$bad_pthread_undef" >&2
  ok_no_pthread=0
else
  ok_line "product has no U pthread_* residual deps"
fi

# --- Product IR: full matrix required; no pthread; no HW SIMD intrinsics ---
IR_FILES=()
missing_ir=()
if [[ ! -d "$IR_ROOT" ]]; then
  fail_line "missing product IR root directory: $IR_ROOT (build freestanding first)"
  ok_l1=0
  ok_no_pthread=0
else
  for rel in "${REQUIRED_PAR_IR[@]}"; do
    if [[ -f "$IR_ROOT/$rel" ]]; then
      IR_FILES+=("$IR_ROOT/$rel")
    else
      missing_ir+=("$rel")
    fi
  done
  if [[ "${#missing_ir[@]}" -gt 0 ]]; then
    fail_line "incomplete product Par IR matrix under $IR_ROOT (fail-closed; need full residual companions):"
    for m in "${missing_ir[@]}"; do
      printf '  missing: %s\n' "$m" >&2
    done
    ok_l1=0
    ok_no_pthread=0
  fi
fi

if [[ "${#IR_FILES[@]}" -eq "${#REQUIRED_PAR_IR[@]}" ]]; then
  # pthread isolation on product IR text
  if grep -En 'pthread\.h|pthread_create|pthread_join|SYSTEMS_LEAN_PAR_PTHREAD' "${IR_FILES[@]}" >/dev/null 2>&1; then
    fail_line "product Par IR contains pthread headers/symbols/defines:"
    grep -En 'pthread\.h|pthread_create|pthread_join|SYSTEMS_LEAN_PAR_PTHREAD' "${IR_FILES[@]}" >&2 || true
    ok_no_pthread=0
  else
    ok_line "product Par IR free of pthread headers/symbols (full matrix present)"
  fi

  # L1 shaped-only: no hardware SIMD intrinsics / immintrin on product residual IR
  if grep -En 'immintrin\.h|emmintrin\.h|xmmintrin\.h|[[:space:]]_mm_|[[:space:]]_mm256_|[[:space:]]_mm512_|__m128i|__m256i' "${IR_FILES[@]}" >/dev/null 2>&1; then
    fail_line "product Par IR contains hardware SIMD intrinsics (L1 must stay sequential chunked-4 shape):"
    grep -En 'immintrin\.h|emmintrin\.h|xmmintrin\.h|[[:space:]]_mm_|[[:space:]]_mm256_|[[:space:]]_mm512_|__m128i|__m256i' "${IR_FILES[@]}" >&2 || true
    ok_l1=0
  else
    ok_line "product Par IR free of hardware SIMD intrinsics (L1 shaped-only)"
    ok_l1=1
  fi

  # Sanity: sequential map / chunk4 surface still present in IR somewhere
  if ! grep -E 'mapAddU8|mapAddU8Chunk4|lean_fs_par_map_fold' "${IR_FILES[@]}" >/dev/null 2>&1; then
    fail_line "product Par IR missing sequential L1 map markers"
    ok_l1=0
  fi
elif [[ "$status" -eq 0 && "${#IR_FILES[@]}" -eq 0 ]]; then
  # Directory existed but no files matched — already reported missing matrix.
  :
fi

# Honesty: concurrent runtime / pthread is host dogfood assumed, not CompCert product residual.
ok_line "concurrent runtime / pthread dogfood is assumed host policy — not product-proved residual"

if [[ "$status" -ne 0 || "$ok_l2" -ne 1 || "$ok_no_pthread" -ne 1 || "$ok_l1" -ne 1 ]]; then
  emit_fail_tokens
  exit 1
fi

echo "PRODUCT_PARALLELISM_L2_SEQUENTIAL=1"
echo "PRODUCT_PARALLELISM_NO_PTHREAD=1"
echo "PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1"
echo "PARALLELISM_DUAL_PATH_OK=1"
echo "CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1"
exit 0
