#!/usr/bin/env bash
# Negative cases for the end-to-end proof receipt (fail-closed).
# Expects systems-proof-receipt.sh to exit non-zero with FAIL lines when certs are incomplete/invalid.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
LEAN4_ROOT="$(cd "$ROOT/../../../.." && pwd)"
SCRIPT="$LEAN4_ROOT/script/systems-proof-receipt.sh"
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
  if ! grep -qE 'RECEIPT: FAIL' "$out"; then
    echo "FAIL: case $name: expected RECEIPT: FAIL" >&2
    cat "$out" >&2
    exit 1
  fi
  # Stale CompCert OK must not pollute FAIL receipts when ccomp was skipped.
  if grep -qE 'skipping CompCert' "$out"; then
    if grep -qE 'CompCert object receipt \(this run\)' "$out"; then
      echo "FAIL: case $name: included CompCert object receipt after skip" >&2
      cat "$out" >&2
      exit 1
    fi
  fi
  echo "OK: negative case $name (exit $ec)"
  grep -E '^FAIL:' "$out" | head -n3
}

# 1) Missing extract .c → fail closed
fail_case missing_extract \
  env SYSTEMS_LEAN_COMPCERT_REQUIRE=1 \
  "$SCRIPT" "$tmpdir/receipt-missing.txt" "$tmpdir/no-such-Extract.c" "$tmpdir/no-bundle.a"

# 2) Present C without certs → fail closed (before / without needing ccomp)
cat >"$tmpdir/uncertified.c" <<'C'
// Stub freestanding-looking C without certificates
#include <stdint.h>
uint64_t lean_fs_add(uint64_t x, uint64_t y) { return x + y; }
C
fail_case missing_certs \
  env SYSTEMS_LEAN_COMPCERT_REQUIRE=1 \
      SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST=1 \
  "$SCRIPT" "$tmpdir/receipt-uncert.txt" "$tmpdir/uncertified.c" "$tmpdir/no-bundle.a"

# 3) Partial memsafe header only (no QTT claim line, no CompCert cert)
cat >"$tmpdir/partial.c" <<'C'
#include <stdint.h>
uint64_t lean_fs_add(uint64_t x, uint64_t y) { return x + y; }
/* SYSTEMS_LEAN_MEMSAFE_CERT begin
SYSTEMS_LEAN_MEMSAFE_CERT/2
module=Partial
claim=full_memory_safety_freestanding_model
SYSTEMS_LEAN_MEMSAFE_CERT end */
C
fail_case partial_certs \
  env SYSTEMS_LEAN_COMPCERT_REQUIRE=1 \
      SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST=1 \
  "$SCRIPT" "$tmpdir/receipt-partial.txt" "$tmpdir/partial.c" "$tmpdir/no-bundle.a"

# 4) Forged EXTRACT: greppable markers present but invalid digests/sigs.
# Healthy FS0 dogfood may still exist — Lean must verify *this* EXTRACT and FAIL.
# (Compositional bug: grepping markers then verifying hardcoded dogfood paths.)
cat >"$tmpdir/forged-Extract.c" <<'C'
/* freestanding-looking C with greppable cert markers only (not a valid seal) */
#include <stdint.h>
uint64_t lean_fs_add(uint64_t x, uint64_t y) { return x + y; }
/* SYSTEMS_LEAN_MEMSAFE_CERT begin
SYSTEMS_LEAN_MEMSAFE_CERT/2
module=Forged
c_digest=0000000000000000
claim=full_memory_safety_freestanding_model
claim=qtt_zero_quantity_erased
claim=qtt_linear_resources_exact_once
claim=qtt_omega_unrestricted_scalars
claim=no_use_after_free
claim=no_double_free
claim=no_invalid_free
claim=no_oob_certified_buffers
claim=no_managed_lean_runtime
claim=libc_allowlist_only
flags=freestanding,qtt,affine_checked,scalar_abi,export_c_roots,zero_qty_erased
sig=0000000000000000
SYSTEMS_LEAN_MEMSAFE_CERT end */
/* SYSTEMS_LEAN_COMPCERT_MEMCERT begin
SYSTEMS_LEAN_COMPCERT_MEMCERT/1
module=Forged
c_digest=0000000000000000
memsafe_sig=0000000000000000
claim=compcert_compatible_memory_safety
claim=no_dangling_pointer_certified_blocks
claim=no_out_of_bounds_certified_blocks
claim=ownership_separation_linear_resources
claim=valid_freestanding_memsafe_cert_prerequisite
claim=qtt_zero_quantity_erased
model=compcert_clight_style_blocks
flags=compcert_oriented,requires_memsafe_v2,qtt
sig=0000000000000000
SYSTEMS_LEAN_COMPCERT_MEMCERT end */
C
fail_case forged_extract_greppable_invalid_sig \
  env SYSTEMS_LEAN_COMPCERT_REQUIRE=1 \
      SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST=1 \
  "$SCRIPT" "$tmpdir/receipt-forged.txt" "$tmpdir/forged-Extract.c" "$tmpdir/no-bundle.a"

# Ensure forged case failed at Lean verify (not only later), and did not claim ccomp OK for this run.
if ! grep -qE 'independent Lean verify failed|FAIL memsafe|signature mismatch|c_digest mismatch' \
    "$tmpdir/forged_extract_greppable_invalid_sig.out"; then
  echo "FAIL: forged_extract should fail Lean verifyEmbedded" >&2
  cat "$tmpdir/forged_extract_greppable_invalid_sig.out" >&2
  exit 1
fi
if grep -qE 'OK: real CompCert ccomp pipeline|CompCert object receipt \(this run\)' \
    "$tmpdir/forged_extract_greppable_invalid_sig.out"; then
  echo "FAIL: forged_extract must not claim CompCert success this run" >&2
  cat "$tmpdir/forged_extract_greppable_invalid_sig.out" >&2
  exit 1
fi
echo "OK: forged EXTRACT compositional negative (Lean verify on actual path)"

echo "OK: proof receipt negative cases passed"
exit 0
