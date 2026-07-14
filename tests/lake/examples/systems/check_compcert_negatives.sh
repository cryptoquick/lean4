#!/usr/bin/env bash
# Negative cases for the CompCert dogfood harness (missing extract / missing certs).
# Expects check_compcert.sh to exit non-zero with a clear FAIL line.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$ROOT/check_compcert.sh"
chmod +x "$SCRIPT"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

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
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line in output" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: negative case $name (exit $ec)"
  grep -E '^FAIL:' "$out" | head -n1
}

# 1) Missing extract .c
fail_case missing_extract \
  env -u SYSTEMS_LEAN_ALLOW_NO_COMPCERT \
  "$SCRIPT" "$tmpdir/no-such-Extract.c" "$tmpdir/out-missing"

# 2) Present file but missing MemSafetyCert / QTT / CompCert certs
cat >"$tmpdir/uncertified.c" <<'C'
// Lean compiler output (stub for negative test)
#include <stdint.h>
uint64_t lean_fs_add(uint64_t x, uint64_t y) { return x + y; }
C
fail_case missing_memsafe_cert \
  env -u SYSTEMS_LEAN_ALLOW_NO_COMPCERT \
  "$SCRIPT" "$tmpdir/uncertified.c" "$tmpdir/out-uncert"

# 3) Memsafe header only — still missing QTT claim and CompCert cert
cat >"$tmpdir/partial.c" <<'C'
#include <stdint.h>
uint64_t lean_fs_add(uint64_t x, uint64_t y) { return x + y; }
/* SYSTEMS_LEAN_MEMSAFE_CERT begin
SYSTEMS_LEAN_MEMSAFE_CERT/2
module=Partial
claim=full_memory_safety_freestanding_model
SYSTEMS_LEAN_MEMSAFE_CERT end */
C
fail_case missing_qtt_or_compcert_cert \
  env -u SYSTEMS_LEAN_ALLOW_NO_COMPCERT \
  "$SCRIPT" "$tmpdir/partial.c" "$tmpdir/out-partial"

# 4) REQUIRE_REF without ./ref ccomp → tool-discovery fail closed (never SKIP).
# Use a certified stub so we pass claim checks and hit discovery; ALLOW must not soft-skip.
cat >"$tmpdir/certified.c" <<'C'
#include <stdint.h>
uint64_t lean_fs_add(uint64_t x, uint64_t y) { return x + y; }
/* SYSTEMS_LEAN_MEMSAFE_CERT begin
SYSTEMS_LEAN_MEMSAFE_CERT/2
module=Certified
claim=full_memory_safety_freestanding_model
claim=qtt_zero_quantity_erased
SYSTEMS_LEAN_MEMSAFE_CERT end */
/* SYSTEMS_LEAN_COMPCERT_MEMCERT begin
SYSTEMS_LEAN_COMPCERT_MEMCERT/1
module=Certified
claim=clight_block_ownership
claim=qtt_zero_quantity_erased
SYSTEMS_LEAN_COMPCERT_MEMCERT end */
C
out_ref="$tmpdir/require-ref.out"
set +e
env SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 \
  SYSTEMS_LEAN_ALLOW_NO_COMPCERT=1 \
  "$SCRIPT" "$tmpdir/certified.c" "$tmpdir/out-require-ref" >"$out_ref" 2>&1
ec_ref=$?
set -e
if [[ $ec_ref -eq 0 ]]; then
  echo "FAIL: REQUIRE_REF without ./ref ccomp must not SKIP/succeed" >&2
  cat "$out_ref" >&2
  exit 1
fi
if ! grep -qiE 'tool discovery|REQUIRE_REF' "$out_ref"; then
  echo "FAIL: REQUIRE_REF case: expected tool-discovery messaging" >&2
  cat "$out_ref" >&2
  exit 1
fi
if grep -qE '^SKIP:' "$out_ref"; then
  echo "FAIL: REQUIRE_REF must not emit SKIP under ALLOW_NO_COMPCERT" >&2
  cat "$out_ref" >&2
  exit 1
fi
echo "OK: negative case require_ref_tool_discovery (exit $ec_ref)"
grep -E '^FAIL:' "$out_ref" | head -n1

echo "OK: CompCert negative cases passed"
exit 0
