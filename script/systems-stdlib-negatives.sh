#!/usr/bin/env bash
# Negative cases for R7 systems-stdlib / inventory gates (fail-closed).
# Does not require a full freestanding rebuild. Classic CI can skip; freestanding
# `make check-stdlib` runs this after the positive path.
#
# Residual IR: drives systems-stdlib.sh SKIP_BUILD against a disposable poisoned tree
# via SYSTEMS_LEAN_STDLIB_LIB_DIR (does not clobber real freestanding IR).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

STDLIB="$ROOT/script/systems-stdlib.sh"
INV="$ROOT/script/systems-stdlib-inventory.sh"
chmod +x "$STDLIB" "$INV"

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
  if ! grep -qE 'FAIL:|error:' "$out"; then
    echo "FAIL: case $name: expected FAIL:/error: line in output" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: negative case $name (exit $ec)"
  # Diagnostic only: avoid SIGPIPE→exit 141 under `set -o pipefail` when head closes early.
  grep -E 'FAIL:|error:' "$out" | head -n2 || true
}

# Prefer in-tree stage1 when present (same as systems-stdlib.sh).
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
fi

# 1) Bad SYSTEMS_LEAN_STDLIB_SKIP_BUILD value
fail_case bad_skip_build \
  env SYSTEMS_LEAN_STDLIB_SKIP_BUILD=maybe SYSTEMS_LEAN_STDLIB_INVENTORY=0 "$STDLIB"

# 2) Bad SYSTEMS_LEAN_STDLIB_INVENTORY value
fail_case bad_inventory_flag \
  env SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1 SYSTEMS_LEAN_STDLIB_INVENTORY=2 "$STDLIB" \
    "$tmpdir/no-such.a"

# 3) Missing product artifact under SKIP_BUILD
fail_case missing_artifact \
  env SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1 SYSTEMS_LEAN_STDLIB_INVENTORY=0 "$STDLIB" \
    "$tmpdir/no-such-product.a"

# 4) Empty product artifact under SKIP_BUILD
: >"$tmpdir/empty.a"
fail_case empty_artifact \
  env SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1 SYSTEMS_LEAN_STDLIB_INVENTORY=0 "$STDLIB" \
    "$tmpdir/empty.a"

# 5) Inventory --write to a missing doc path (python3 preflight still runs if present)
fail_case inventory_missing_doc \
  "$INV" --write --out "$tmpdir/no-such-dir/inventory.md"

# 6) Residual RC in freestanding IR: real systems-stdlib.sh fail-closed path.
# Disposable package lib dir; does not touch tests/lake/examples/systems.
fake_lib="$tmpdir/fake_freestanding/lib"
mkdir -p "$fake_lib/.lake/build/ir/Systems" "$fake_lib/.lake/build/lib"
for m in Scalars Sys Bytes Numerics Status; do
  echo "/* clean freestanding IR */" >"$fake_lib/.lake/build/ir/Systems/${m}.c"
done
# Inject residual forbidden by check_r7_ir (lean_object|lean_inc|lean_dec|lean/lean.h)
echo "lean_object *poison;" >>"$fake_lib/.lake/build/ir/Systems/Bytes.c"
# Non-empty fake bundle so artifact gates pass and residual check runs
printf '!<arch>\n' >"$fake_lib/.lake/build/lib/libfs_extract_bundle.a"
fake_bundle="$fake_lib/.lake/build/lib/libfs_extract_bundle.a"

fail_case residual_ir \
  env \
    SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1 \
    SYSTEMS_LEAN_STDLIB_INVENTORY=0 \
    SYSTEMS_LEAN_STDLIB_LIB_DIR="$fake_lib" \
    "$STDLIB" "$fake_bundle"

# Must name residual / Bytes.c (not only a generic FAIL from missing path)
if ! grep -qE 'residual Lean RC/object|lean_object' "$tmpdir/residual_ir.out"; then
  echo "FAIL: residual_ir case did not report residual RC/object (gate drift?)" >&2
  cat "$tmpdir/residual_ir.out" >&2
  exit 1
fi
echo "OK: residual_ir exercised systems-stdlib check_r7_ir via SYSTEMS_LEAN_STDLIB_LIB_DIR"

# 7) Clean override tree must not false-fail residual (sanity: residual gate is specific)
clean_lib="$tmpdir/clean_freestanding/lib"
mkdir -p "$clean_lib/.lake/build/ir/Systems" "$clean_lib/.lake/build/lib"
for m in Scalars Sys Bytes Numerics Status; do
  echo "/* clean freestanding IR */" >"$clean_lib/.lake/build/ir/Systems/${m}.c"
done
printf '!<arch>\n' >"$clean_lib/.lake/build/lib/libfs_extract_bundle.a"
clean_bundle="$clean_lib/.lake/build/lib/libfs_extract_bundle.a"
# May fail nm gate (fake archive) but must NOT fail residual greps.
set +e
env \
  SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1 \
  SYSTEMS_LEAN_STDLIB_INVENTORY=0 \
  SYSTEMS_LEAN_STDLIB_LIB_DIR="$clean_lib" \
  "$STDLIB" "$clean_bundle" >"$tmpdir/clean_ir.out" 2>&1
clean_ec=$?
set -e
if grep -qE 'residual Lean RC/object' "$tmpdir/clean_ir.out"; then
  echo "FAIL: clean IR tree falsely failed residual RC gate" >&2
  cat "$tmpdir/clean_ir.out" >&2
  exit 1
fi
echo "OK: clean override tree did not trip residual RC gate (exit $clean_ec is nm/other)"

echo "OK: systems-stdlib negatives passed"
exit 0
