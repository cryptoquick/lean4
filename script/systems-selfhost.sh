#!/usr/bin/env bash
# Systems Lean self-host product path (R6).
#
# Thin entrypoint around `script/lean-systems selfhost`:
# builds the freestanding product (unless skipped), installs lean-systems under
# out/systems-selfhost/bin/, runs the nm link gate, negatives, and tiny compile.
#
# Honesty:
#   - Host elaborator TCB = classic stage1 lean + libleanshared (GC/RC still used).
#   - Product / embed TCB = freestanding extract objects + libc only
#     (no Init_shared, no leanshared*, no U lean_* / U l_* on the product link line).
#
# Usage (lean4 root; stage1 preferred when present):
#   ./script/systems-selfhost.sh              # full product path
#   ./script/systems-selfhost.sh --version    # lean-systems --version only
#   ./script/systems-selfhost.sh check        # nm gate only (bundle must exist)
#   ./script/systems-selfhost.sh negatives    # link-check negative cases
#
# Env:
#   SYSTEMS_LEAN_SELFHOST_SKIP_BUILD=1  skip lake rebuild (bundle must already exist)
#
# Classic Lean CI does not need this; opt-in Systems Lean dogfood only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PREFIX="${SYSTEMS_LEAN_PREFIX:-$ROOT/out/systems-selfhost}"
export SYSTEMS_LEAN_PREFIX="$PREFIX"

# Prefer in-tree stage1 when present.
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
fi
if [[ -z "${LAKE:-}" && -x "$ROOT/build/release/stage1/bin/lake" ]]; then
  export LAKE="$ROOT/build/release/stage1/bin/lake"
fi

chmod +x \
  "$ROOT/script/lean-systems" \
  "$ROOT/script/systems-selfhost-link-check.sh" \
  "$ROOT/script/systems-selfhost-link-check-negatives.sh"

LEAN_SYSTEMS="$ROOT/script/lean-systems"

case "${1:-}" in
  --version|-v)
    exec "$LEAN_SYSTEMS" --version
    ;;
  --help|-h)
    cat <<EOF
systems-selfhost.sh — R6 Systems Lean product self-host path

  (no args)     lean-systems selfhost (build + install + nm + negatives + tiny)
  --version     lean-systems version / honesty banner
  check         nm gate only (requires existing bundle)
  negatives     fail-closed negative cases for the nm gate
  --help        this help

Install prefix: \$SYSTEMS_LEAN_PREFIX (default: out/systems-selfhost)
Entry point:    \$SYSTEMS_LEAN_PREFIX/bin/lean-systems
Skip rebuild:   SYSTEMS_LEAN_SELFHOST_SKIP_BUILD=1 (after make check / lake build)

See doc/dev/systems-lean-selfhost.md
EOF
    exit 0
    ;;
  check)
    shift
    exec "$LEAN_SYSTEMS" check "$@"
    ;;
  negatives)
    exec "$LEAN_SYSTEMS" negatives
    ;;
  "")
    ;;
  *)
    echo "error: unknown argument: $1 (try --help)" >&2
    exit 1
    ;;
esac

echo "=== Systems Lean self-host product path (R6) ==="
echo "root:   $ROOT"
echo "prefix: $PREFIX"
echo "note: elaborator host still uses classic lean + libleanshared (GC/RC)."
echo "note: freestanding product objects must not need GC dynlibs (no U lean_* / U l_*)."

if ! command -v lean >/dev/null 2>&1; then
  echo "error: lean not on PATH; build stage1 or export PATH=$ROOT/build/release/stage1/bin:\$PATH" >&2
  exit 1
fi

"$LEAN_SYSTEMS" selfhost

# Verify installed entry point (capture output first — avoid SIGPIPE under pipefail with grep -q).
if [[ ! -x "$PREFIX/bin/lean-systems" ]]; then
  echo "FAIL: missing installed entry point $PREFIX/bin/lean-systems" >&2
  exit 1
fi
ver_out="$("$PREFIX/bin/lean-systems" --version)"
if ! grep -q 'Systems Lean self-host' <<<"$ver_out"; then
  echo "FAIL: installed lean-systems --version missing product label" >&2
  echo "$ver_out" >&2
  exit 1
fi

echo "=== Systems Lean self-host product path OK ==="
echo "lean-systems: $PREFIX/bin/lean-systems"
echo "check:        $PREFIX/bin/lean-systems check"
echo "docs:         doc/dev/systems-lean-selfhost.md"
exit 0
