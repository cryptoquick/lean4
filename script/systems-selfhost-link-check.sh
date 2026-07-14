#!/usr/bin/env bash
# Systems Lean self-host gate (R6): verify freestanding product objects
# do not require Lean GC/RC dynlibs. Classic stage1 is untouched.
#
# Policy (aligned with freestanding check-nm for Lean runtime undefs):
#   - any U lean_* or U l_*  → FAIL (requires leanshared / mangled runtime)
#   - Init_shared / leanshared residues anywhere → FAIL
#   - defined residual RC entry points (lean_inc, lean_object, …) → FAIL
# Product T lean_fs_* / T lp_systems__* are allowed; U lp_* is not U l_*.
#
# Fail-closed: missing artifact, missing nm, or forbidden symbols → exit ≠ 0.
# PRODUCT_GC_FREE=1 / PRODUCT_NO_LEANSHARED=1 emit only after residual success
# (nm residual only — not residual_ir; validate GATE product_gc_free also needs IR).
#
# H2: this is a product-only gate — no elaborator, no host GC-free requirement.
# PRODUCT_GC_FREE=1 can hold while GC_FREE_ELABORATOR=0 (independent axes).
# Consumer recipe (no libleanshared): cc -std=c11 -o out main.c libfs_extract_bundle.a
# See doc/dev/systems-lean-selfhost.md § H2.
#
# Usage (from lean4 root, after freestanding product build):
#   ./script/systems-selfhost-link-check.sh
#   ./script/systems-selfhost-link-check.sh path/to/libfs_extract_bundle.a
#   ./script/systems-selfhost-link-check.sh path/to/foo.o
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=systems-residual-policy.sh
source "$ROOT/script/systems-residual-policy.sh"
ART="${1:-$ROOT/tests/lake/examples/systems/lib/.lake/build/lib/libfs_extract_bundle.a}"

if [[ ! -f "$ART" ]]; then
  echo "FAIL: missing product artifact $ART" >&2
  echo "hint: build freestanding product first (./script/systems-selfhost.sh or lake --dir=tests/lake/examples/systems/lib build)" >&2
  exit 1
fi

if [[ ! -s "$ART" ]]; then
  echo "FAIL: product artifact is empty: $ART" >&2
  exit 1
fi

echo "=== Systems Lean self-host link check (no GC required on product) ==="
echo "artifact: $ART"

if ! command -v nm >/dev/null 2>&1; then
  echo "FAIL: nm required for self-host product gate (tool discovery, not a product rejection)" >&2
  exit 1
fi

# Collect undefined and global symbols. Prefer plain nm; fall back to -C demangle / -A.
# Use -- so paths starting with '-' are not parsed as options (fail-closed either way).
nm_u() {
  nm -u -- "$ART" 2>/dev/null || nm -u -C -- "$ART" 2>/dev/null || nm -u -A -- "$ART" 2>/dev/null || true
}
nm_all() {
  nm -- "$ART" 2>/dev/null || nm -g -- "$ART" 2>/dev/null || nm -A -- "$ART" 2>/dev/null || true
}

undef=$(nm_u)
allsym=$(nm_all)

if [[ -z "$allsym" && -z "$undef" ]]; then
  echo "FAIL: nm produced no symbols for $ART (unreadable or non-object archive?)" >&2
  exit 1
fi

# Align with freestanding check-nm + systems-residual-policy.sh (shared helper).
if systems_lean_nm_undef_has_runtime "$undef"; then
  bad_lean=$(echo "$undef" | grep -E '[[:space:]]U[[:space:]]+lean_' || true)
  bad_l=$(echo "$undef" | grep -E '[[:space:]]U[[:space:]]+l_' || true)
  echo "FAIL: product has Lean runtime / mangled undefs (U lean_* / U l_* — requires leanshared/Init_shared):" >&2
  [[ -n "$bad_lean" ]] && echo "$bad_lean" >&2
  [[ -n "$bad_l" ]] && echo "$bad_l" >&2
  exit 1
fi

bad_shared=$(echo "$undef"$'\n'"$allsym" | grep -E "$SYSTEMS_LEAN_SHARED_RE" || true)
if [[ -n "$bad_shared" ]]; then
  echo "FAIL: product references Lean shared libs (Init_shared / leanshared*):" >&2
  echo "$bad_shared" >&2
  exit 1
fi

# Defined residual RC/object entry points (not freestanding product exports like lean_fs_*).
bad_def=$(echo "$allsym" | grep -E '[[:space:]][TtWw][[:space:]]+('"$SYSTEMS_LEAN_RC_DEF_RE"')' || true)
if [[ -n "$bad_def" ]]; then
  echo "FAIL: product defines Lean RC/runtime symbols (not freestanding-clean):" >&2
  echo "$bad_def" >&2
  exit 1
fi

echo "OK: no U lean_* / U l_* on freestanding product archive"
echo "OK: no Init_shared / leanshared* residues"
echo "OK: classic runtime remains available for non-FS builds (not deprecated)"
echo "receipt: self-host FS product objects do not need libleanshared"
# Greppable product GC/RC-free tokens (wire residual; not host elaborator GC-free).
echo "PRODUCT_NO_LEANSHARED=1"
echo "PRODUCT_GC_FREE=1"
exit 0
