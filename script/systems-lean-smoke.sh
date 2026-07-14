#!/usr/bin/env bash
# Systems Lean integration smoke (R5 + light R6): minimal matrix without forced CompCert.
#
# Default:
#   1) Elab tests: qtt_binder_mult, qtt_use_check, qtt_formal_layer, memsafe_cert
#   2) freestanding classic harness: make check  (no clean; not ./test.sh)
#      ./test.sh = clean.sh + make check (from-scratch); use that when you want a wipe.
#      make check includes R6 check-selfhost + check-selfhost-negatives.
#   3) R6 self-host product path: lean-systems version + systems-selfhost
#      After make check the bundle already exists, so selfhost uses
#      SYSTEMS_LEAN_SELFHOST_SKIP_BUILD=1 (install + nm + negatives + tiny only).
#      Skip R6 with SYSTEMS_LEAN_SMOKE_SELFHOST=0.
#
# Optional full matrix (requires CompCert / ccomp):
#   SYSTEMS_LEAN_SMOKE_FULL=1 ./script/systems-lean-smoke.sh
#   → also runs make check-full (hard-requires ccomp + proof receipt)
#
# R7 stdlib path (default on after make check; cheap SKIP_BUILD):
#   SYSTEMS_LEAN_SMOKE_STDLIB=0 to skip
#   SYSTEMS_LEAN_SMOKE_STDLIB=1 (default) → systems-stdlib.sh with SKIP_BUILD
#
# Usage (from lean4 root, stage1 lean/lake on PATH):
#   ./script/systems-lean-smoke.sh
#
# Classic Lean CI never needs this; freestanding dogfood only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Prefer in-tree stage1 when present (matches freestanding/test.sh).
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
fi
if [[ -z "${LAKE:-}" && -x "$ROOT/build/release/stage1/bin/lake" ]]; then
  export LAKE="$ROOT/build/release/stage1/bin/lake"
fi

if ! command -v lean >/dev/null 2>&1; then
  echo "error: lean not on PATH; build stage1 or export PATH" >&2
  exit 1
fi

echo "=== Systems Lean smoke: elab (QTT + memsafe) ==="
for t in qtt_binder_mult qtt_use_check qtt_formal_layer memsafe_cert; do
  echo "--- tests/elab/$t.lean ---"
  tests/with_stage1_test_env.sh tests/elab/run_test.sh "$t.lean"
done
echo "OK: elab matrix"

FS_EXAMPLE="$ROOT/tests/lake/examples/systems"
echo "=== Systems Lean smoke: freestanding classic checks ==="
# make check only (no forced CompCert, no clean). ./test.sh would wipe the harness first.
(
  cd "$FS_EXAMPLE"
  if [[ -n "${LAKE:-}" ]]; then
    LAKE="$LAKE" make check
  else
    make check
  fi
)
echo "OK: freestanding make check"

# R6 self-host product path (default on).
# SYSTEMS_LEAN_SMOKE_SELFHOST: unset or 1 → run; 0 → skip; other values → error.
_smoke_sh="${SYSTEMS_LEAN_SMOKE_SELFHOST:-1}"
case "$_smoke_sh" in
  0)
    echo "Note: R6 self-host path skipped (SYSTEMS_LEAN_SMOKE_SELFHOST=0)"
    ;;
  1)
    echo "=== Systems Lean smoke: R6 self-host product path ==="
    echo "note: make check already built the bundle; selfhost skips lake rebuild"
    chmod +x \
      "$ROOT/script/systems-selfhost.sh" \
      "$ROOT/script/lean-systems" \
      "$ROOT/script/systems-selfhost-link-check.sh" \
      "$ROOT/script/systems-selfhost-link-check-negatives.sh"
    "$ROOT/script/lean-systems" --version
    # Avoid a second freestanding lake build (make check already produced the bundle).
    SYSTEMS_LEAN_SELFHOST_SKIP_BUILD=1 "$ROOT/script/systems-selfhost.sh"
    PREFIX="${SYSTEMS_LEAN_PREFIX:-$ROOT/out/systems-selfhost}"
    test -x "$PREFIX/bin/lean-systems" \
      || { echo "FAIL: missing $PREFIX/bin/lean-systems after systems-selfhost.sh" >&2; exit 1; }
    "$PREFIX/bin/lean-systems" --help >/dev/null
    "$PREFIX/bin/lean-systems" check
    echo "OK: R6 self-host product path"
    ;;
  *)
    echo "error: SYSTEMS_LEAN_SMOKE_SELFHOST must be 0 or 1 (got: $_smoke_sh)" >&2
    exit 1
    ;;
esac

# R7 freestanding stdlib path (default on; reuses make check build).
# SYSTEMS_LEAN_SMOKE_STDLIB: unset or 1 → run; 0 → skip; other values → error.
_smoke_stdlib="${SYSTEMS_LEAN_SMOKE_STDLIB:-1}"
case "$_smoke_stdlib" in
  0)
    echo "Note: R7 systems-stdlib path skipped (SYSTEMS_LEAN_SMOKE_STDLIB=0)"
    ;;
  1)
    echo "=== Systems Lean smoke: R7 systems-stdlib product path ==="
    chmod +x \
      "$ROOT/script/systems-stdlib.sh" \
      "$ROOT/script/systems-stdlib-inventory.sh" \
      "$ROOT/script/systems-selfhost-link-check.sh"
    # make check already built the bundle and ran check-stdlib; this is a
    # second opt-in entry when smoke is used standalone after check, or a
    # cheap re-verify. Prefer SKIP_BUILD + skip inventory rewrite noise:
    SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1 SYSTEMS_LEAN_STDLIB_INVENTORY=0 \
      "$ROOT/script/systems-stdlib.sh"
    echo "OK: R7 systems-stdlib product path"
    ;;
  *)
    echo "error: SYSTEMS_LEAN_SMOKE_STDLIB must be 0 or 1 (got: $_smoke_stdlib)" >&2
    exit 1
    ;;
esac

if [[ "${SYSTEMS_LEAN_SMOKE_FULL:-}" == "1" ]]; then
  echo "=== Systems Lean smoke FULL: check-full (CompCert + proof receipt) ==="
  (
    cd "$FS_EXAMPLE"
    if [[ -n "${LAKE:-}" ]]; then
      LAKE="$LAKE" make check-full
    else
      make check-full
    fi
  )
  echo "OK: freestanding make check-full"
else
  echo "Note: CompCert/proof-receipt not run (set SYSTEMS_LEAN_SMOKE_FULL=1 for check-full)"
fi

echo "Systems Lean integration smoke passed"
