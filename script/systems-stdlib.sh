#!/usr/bin/env bash
# Systems Lean R7 — freestanding stdlib product path.
#
# Builds Systems.* (first-wave stdlib + prelude) via freestanding Lake,
# runs the R6 nm / self-host link gate on the product archive, optionally
# regenerates the Init/Std inventory.
#
# Honesty:
#   - Product extract uses Systems.* only (no Init/Std import on FS path).
#   - Classic Init/Std/Lean stage1 is unchanged; this is opt-in.
#   - Does **not** claim every Init file is freestanding.
#
# Usage (lean4 root; stage1 preferred when present):
#   ./script/systems-stdlib.sh
#   ./script/systems-stdlib.sh path/to/libfs_extract_bundle.a
#   SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1 ./script/systems-stdlib.sh   # nm + inventory only
#   SYSTEMS_LEAN_STDLIB_INVENTORY=0 ./script/systems-stdlib.sh    # skip inventory
#   SYSTEMS_LEAN_STDLIB_LIB_DIR=/path/to/lib   # override freestanding package lib dir
#     (for tests/negatives; expects .lake/build/ir/Systems/*.c under that dir)
#
# Fail-closed: missing lean/lake, failed build, residual RC in IR, or nm gate → exit ≠ 0.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
# shellcheck source=systems-residual-policy.sh
source "$ROOT/script/systems-residual-policy.sh"

FS_EXAMPLE="$ROOT/tests/lake/examples/systems"
# Override for negatives / disposable trees (must not point at production unless intentional).
LIB_DIR="${SYSTEMS_LEAN_STDLIB_LIB_DIR:-$FS_EXAMPLE/lib}"
DEFAULT_BUNDLE="$LIB_DIR/.lake/build/lib/libfs_extract_bundle.a"
ART="${1:-}"

# Prefer in-tree stage1 when present.
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
fi
if [[ -z "${LAKE:-}" && -x "$ROOT/build/release/stage1/bin/lake" ]]; then
  export LAKE="$ROOT/build/release/stage1/bin/lake"
fi
LAKE_BIN="${LAKE:-lake}"

chmod +x \
  "$ROOT/script/systems-selfhost-link-check.sh" \
  "$ROOT/script/systems-stdlib-inventory.sh"

if ! command -v lean >/dev/null 2>&1; then
  echo "FAIL: lean not on PATH; build stage1 or export PATH" >&2
  exit 1
fi
if ! command -v "$LAKE_BIN" >/dev/null 2>&1 && [[ ! -x "$LAKE_BIN" ]]; then
  echo "FAIL: lake not available (LAKE=$LAKE_BIN)" >&2
  exit 1
fi

echo "=== Systems Lean R7: freestanding stdlib product path ==="
echo "lean: $(command -v lean)"
echo "lake: $LAKE_BIN"

SKIP_BUILD="${SYSTEMS_LEAN_STDLIB_SKIP_BUILD:-0}"
case "$SKIP_BUILD" in
  0|1) ;;
  *)
    echo "FAIL: SYSTEMS_LEAN_STDLIB_SKIP_BUILD must be 0 or 1 (got: $SKIP_BUILD)" >&2
    exit 1
    ;;
esac

INV="${SYSTEMS_LEAN_STDLIB_INVENTORY:-1}"
case "$INV" in
  0|1) ;;
  *)
    echo "FAIL: SYSTEMS_LEAN_STDLIB_INVENTORY must be 0 or 1 (got: $INV)" >&2
    exit 1
    ;;
esac

# Residual RC markers forbidden in freestanding IR (unified residual policy only).
# Prefer systems_lean_check_product_ir_residuals when Extract.c is present; partial
# override trees (negatives) that only ship Systems/*.c use the same RE helper.
check_r7_ir() {
  local ctx="$1"
  local ir_root="$LIB_DIR/.lake/build/ir"
  local extract_c="$ir_root/Extract.c"
  local m f
  # Full product tree: single-source residual greps (Extract + Systems companions).
  if [[ -f "$extract_c" ]]; then
    if ! systems_lean_check_product_ir_residuals "$ir_root" "$extract_c"; then
      echo "FAIL: product IR residual policy ($ctx)" >&2
      exit 1
    fi
    return 0
  fi
  # Partial trees (stdlib negatives): Systems modules only.
  for m in "${SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}"; do
    f="$ir_root/Systems/${m}.c"
    if [[ ! -f "$f" ]]; then
      echo "FAIL: missing R7 freestanding IR $f ($ctx)" >&2
      exit 1
    fi
    if systems_lean_ir_file_has_residual "$f"; then
      echo "FAIL: residual Lean RC/object in $f ($ctx)" >&2
      exit 1
    fi
  done
}

if [[ "$SKIP_BUILD" != "1" ]]; then
  echo "--- lake build freestanding (Systems + Extract) ---"
  if [[ ! -d "$LIB_DIR" ]]; then
    echo "FAIL: missing freestanding package dir $LIB_DIR" >&2
    exit 1
  fi
  # Fail-closed: do not reuse a stale success marker after a failed build.
  STAMP="$LIB_DIR/.lake/build/r7-stdlib.stamp"
  rm -f "$STAMP"
  if ! "$LAKE_BIN" --dir="$LIB_DIR" build; then
    echo "FAIL: freestanding lake build failed" >&2
    exit 1
  fi
  # Resolve bundle via lake query (authoritative path).
  BUNDLE="$("$LAKE_BIN" --dir="$LIB_DIR" query Extract:freestanding.bundle)"
  if [[ -z "$BUNDLE" ]]; then
    echo "FAIL: empty freestanding.bundle from lake query" >&2
    exit 1
  fi
  n_bundle=$(echo "$BUNDLE" | wc -w)
  if [[ "$n_bundle" -ne 1 ]]; then
    echo "FAIL: freestanding.bundle must be exactly 1 path, got $n_bundle: $BUNDLE" >&2
    exit 1
  fi
  if [[ ! -f "$BUNDLE" ]]; then
    echo "FAIL: missing freestanding bundle $BUNDLE" >&2
    exit 1
  fi
  check_r7_ir "build"
  date -u +%Y-%m-%dT%H:%MZ >"$STAMP"
  echo "OK: freestanding stdlib built → $BUNDLE"
  ART="${ART:-$BUNDLE}"
else
  echo "note: skip lake rebuild (SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1)"
  ART="${ART:-$DEFAULT_BUNDLE}"
  if [[ ! -f "$ART" ]]; then
    echo "FAIL: missing product artifact $ART (build first or drop SKIP_BUILD)" >&2
    exit 1
  fi
  # Same existence + residual greps as full build (no vacuous SKIP_BUILD green).
  check_r7_ir "SKIP_BUILD"
fi

if [[ ! -f "$ART" ]]; then
  echo "FAIL: missing product artifact $ART" >&2
  exit 1
fi
if [[ ! -s "$ART" ]]; then
  echo "FAIL: product artifact is empty: $ART" >&2
  exit 1
fi

echo "--- nm / self-host link gate ---"
"$ROOT/script/systems-selfhost-link-check.sh" "$ART"

# Optional inventory (default on; flag validated at startup).
case "$INV" in
  0)
    echo "note: inventory skipped (SYSTEMS_LEAN_STDLIB_INVENTORY=0)"
    ;;
  1)
    echo "--- regenerate stdlib inventory (doc) ---"
    "$ROOT/script/systems-stdlib-inventory.sh" --write
    ;;
esac

echo "OK: systems-stdlib product path (R7 freestanding stdlib + nm gate)"
echo "artifact: $ART"
exit 0
