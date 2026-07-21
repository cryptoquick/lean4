#!/usr/bin/env bash
# Smoke: A34 freestanding-adjacent plan-module object inventory in NATIVE_GRAPH +
# NATIVE_SEAL.
#
# A20/A31 emit plan-module .o (root under .slake-native/, A30-folded path-dep
# under dep/.slake-native/). A34 product-guarantees those .o appear in:
#   .slake-native/slake_native_graph  with package-cwd-relative object paths
#     (e.g. object Core .slake-native/Core.o;
#      object Dep dep/.slake-native/Dep.o;
#      A29 sibling object Dep ../dep/.slake-native/Dep.o)
#   .slake-native/slake_native_seal   with module <Mod> obj_hash <16-hex>
#     (FNV-1a 64 over object file bytes)
#
# Honesty: freestanding-adjacent plan-module object inventory in NATIVE_GRAPH +
# NATIVE_SEAL subset — not freestanding build TCB / not Lake lean_lib facet /
# not CLAIMED / not every dep plan module / not name-table SO (A13). Soft-omit
# missing .o; banners only when ≥1 object/obj_hash line. SCORE does **not** run
# this smoke.
#
# Prefer absolute SLAKE_BIN (this script absolutizes when set). Relative
# SLAKE_BIN from repo root fails after cd into fixtures.
#
# Bands:
#   1) PLAN_ONLY + NATIVE_OBJ + NATIVE_GRAPH + NATIVE_SEAL on systems_shaped:
#      object Core/Host lines + obj_hash for both
#   2) require_path_shaped + path-dep: object Dep under dep/.slake-native + App
#   3) Optional sibling band: object Dep ../dep/.slake-native/Dep.o
#   4) nested require_path_nested_shaped: object Foo.Bar dep/.slake-native/Foo/Bar.o
#   5) NATIVE_GRAPH+SEAL without NATIVE_OBJ: no object/obj_hash lines
#   6) systems_shaped olean-only graph/seal still green (no false A34 claims)
#   7) help/env honesty greps (capture to var then grep <<<"$var")
#
#   SLAKE_NATIVE_OBJ_GRAPH_SEAL_SMOKE_STRICT=1 ./tests/slake/native_obj_graph_seal_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
PKG="$ROOT/require_path_shaped"
SIBLING_PKG="$ROOT/require_sibling_shaped/app"
NESTED_PKG="$ROOT/require_path_nested_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_OBJ_GRAPH_SEAL_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_GRAPH_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_SEAL_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OBJ_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL (STRICT): $*"
    exit 1
  fi
  echo "SKIP: $*"
  exit 0
}

# Canonical absolute path for an executable (handles relative SLAKE_BIN after cd).
abs_exe() {
  local p="$1"
  if [[ -z "$p" ]]; then
    return 1
  fi
  if [[ "$p" != /* ]]; then
    p="$(pwd)/$p"
  fi
  local dir base
  dir="$(cd "$(dirname "$p")" && pwd)"
  base="$(basename "$p")"
  echo "$dir/$base"
}

resolve_slake() {
  if [[ -n "${SLAKE_BIN:-}" ]]; then
    local abs
    if ! abs="$(abs_exe "$SLAKE_BIN")"; then
      return 1
    fi
    if [[ -x "$abs" ]]; then
      echo "$abs"
      return 0
    fi
    return 1
  fi
  local cand abs
  for cand in \
    "$REPO_ROOT/tests/slake/driver/.lake/build/bin/slake" \
    "$ROOT/driver/.lake/build/bin/slake"
  do
    if [[ -x "$cand" ]]; then
      abs="$(abs_exe "$cand")" || continue
      echo "$abs"
      return 0
    fi
  done
  return 1
}

if [[ ! -f "$SYSTEMS_PKG/lakefile.toml" || ! -f "$SYSTEMS_PKG/Core.lean" || ! -f "$SYSTEMS_PKG/Host.lean" ]]; then
  echo "FAIL: missing systems_shaped package at $SYSTEMS_PKG"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

LEAN_PROBE="${LEAN:-lean}"
if ! command -v "$LEAN_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEAN_PROBE" ]]; then
  strict_fail "host lean not found (set LEAN= or PATH to stage1/bin)"
fi
CC_PROBE="${CC:-cc}"
if ! command -v "$CC_PROBE" >/dev/null 2>&1 && [[ ! -x "$CC_PROBE" ]]; then
  strict_fail "host cc not found (set CC= or PATH) for NATIVE_OBJ bands"
fi

wipe_systems() {
  rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true
}

wipe_pkg() {
  rm -rf "$PKG/.slake-native" "$PKG/dep/.slake-native" "$PKG/.lake" "$PKG/dep/.lake" 2>/dev/null || true
}

assert_a34_banner() {
  local out="$1"
  # Here-strings: pipefail + grep -q can false-fail on early match SIGPIPE.
  if ! grep -Eiq 'plan-module object inventory in NATIVE_GRAPH|plan-module object inventory in NATIVE_SEAL|A34 freestanding-adjacent plan-module object' <<<"$out"; then
    echo "FAIL: expected A34 plan-module object inventory honesty wording in build output"
    exit 1
  fi
  if ! grep -Fq "not freestanding build TCB" <<<"$out"; then
    echo "FAIL: expected freestanding build TCB denial"
    exit 1
  fi
  if ! grep -Fq "not CLAIMED" <<<"$out"; then
    echo "FAIL: expected not CLAIMED denial"
    exit 1
  fi
}

assert_no_a34_claims() {
  local g="$1"
  local s="$2"
  local out="$3"
  if grep -Eq '^object ' "$g" 2>/dev/null; then
    echo "FAIL: expected no object lines without NATIVE_OBJ products"
    echo "--- graph ---"
    cat "$g"
    exit 1
  fi
  if grep -Eq 'obj_hash' "$s" 2>/dev/null; then
    echo "FAIL: expected no obj_hash lines without NATIVE_OBJ products"
    echo "--- seal ---"
    cat "$s"
    exit 1
  fi
  if grep -Fq 'A34 freestanding-adjacent plan-module object' "$g" 2>/dev/null; then
    echo "FAIL: graph must not claim A34 object inventory when no object lines"
    exit 1
  fi
  if grep -Fq 'A34 freestanding-adjacent plan-module object' "$s" 2>/dev/null; then
    echo "FAIL: seal must not claim A34 object inventory when no obj_hash lines"
    exit 1
  fi
  # Here-strings: pipefail + grep -q can false-pass a negative check on early-match SIGPIPE.
  if grep -Eiq 'A34 freestanding-adjacent plan-module object inventory' <<<"$out"; then
    echo "FAIL: build output must not claim A34 object inventory when no objects"
    exit 1
  fi
}

echo "== A34 PLAN_ONLY + NATIVE_OBJ + GRAPH + SEAL: systems_shaped Core/Host objects =="
wipe_systems
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_EXE || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH_STRICT || true
  unset SLAKE_NATIVE_SEAL_STRICT || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+OBJ+GRAPH+SEAL systems_shaped exited $rc (expected 0)"
  exit 1
fi
g="$SYSTEMS_PKG/.slake-native/slake_native_graph"
s="$SYSTEMS_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$g" || ! -f "$s" ]]; then
  echo "FAIL: expected graph and seal files under systems_shaped"
  exit 1
fi
if [[ ! -f "$SYSTEMS_PKG/.slake-native/Core.o" || ! -f "$SYSTEMS_PKG/.slake-native/Host.o" ]]; then
  echo "FAIL: expected Core.o and Host.o under systems_shaped .slake-native"
  exit 1
fi
if ! grep -Fq 'object Core .slake-native/Core.o' "$g"; then
  echo "FAIL: graph must list object Core .slake-native/Core.o"
  echo "--- graph ---"
  cat "$g"
  exit 1
fi
if ! grep -Fq 'object Host .slake-native/Host.o' "$g"; then
  echo "FAIL: graph must list object Host .slake-native/Host.o"
  echo "--- graph ---"
  cat "$g"
  exit 1
fi
# Olean lines stay stable (A14).
if ! grep -Fq 'module Core olean .slake-native/Core.olean' "$g"; then
  echo "FAIL: graph must still list module Core olean (A14 stable)"
  exit 1
fi
if ! grep -Fq 'A34 freestanding-adjacent plan-module object inventory in NATIVE_GRAPH' "$g"; then
  echo "FAIL: graph header must identify A34 object inventory subset"
  exit 1
fi
if ! grep -Eq 'module Core obj_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must have module Core obj_hash <16-hex>"
  echo "--- seal ---"
  cat "$s"
  exit 1
fi
if ! grep -Eq 'module Host obj_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must have module Host obj_hash <16-hex>"
  exit 1
fi
if ! grep -Eq 'module Core olean_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must still have module Core olean_hash (A15 stable)"
  exit 1
fi
if ! grep -Fq 'A34 freestanding-adjacent plan-module object inventory in NATIVE_SEAL' "$s"; then
  echo "FAIL: seal header must identify A34 object inventory subset"
  exit 1
fi
assert_a34_banner "$out"
echo "OK: systems_shaped PLAN_ONLY+OBJ+GRAPH+SEAL object inventory"

echo "== A34 require_path_shaped: path-dep Dep.o + root App.o =="
if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/App.lean" || ! -f "$PKG/dep/Dep.lean" ]]; then
  strict_fail "require_path_shaped fixture missing at $PKG"
fi
wipe_pkg
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: require_path_shaped PLAN_ONLY+OBJ+GRAPH+SEAL exited $rc"
  exit 1
fi
g="$PKG/.slake-native/slake_native_graph"
s="$PKG/.slake-native/slake_native_seal"
if [[ ! -f "$g" || ! -f "$s" ]]; then
  echo "FAIL: expected graph and seal under require_path_shaped"
  exit 1
fi
if [[ ! -f "$PKG/dep/.slake-native/Dep.o" ]]; then
  echo "FAIL: expected path-dep Dep.o at dep/.slake-native/Dep.o"
  exit 1
fi
if [[ ! -f "$PKG/.slake-native/App.o" ]]; then
  echo "FAIL: expected root App.o at .slake-native/App.o"
  exit 1
fi
if ! grep -Fq 'object Dep dep/.slake-native/Dep.o' "$g"; then
  echo "FAIL: graph must list object Dep dep/.slake-native/Dep.o (package-cwd-relative)"
  echo "--- graph ---"
  cat "$g"
  exit 1
fi
if grep -E 'object Dep /' "$g"; then
  echo "FAIL: graph must not use absolute path for path-dep Dep object"
  exit 1
fi
if ! grep -Fq 'object App .slake-native/App.o' "$g"; then
  echo "FAIL: graph must list object App .slake-native/App.o"
  exit 1
fi
# A32 olean lines still present.
if ! grep -Fq 'module Dep olean dep/.slake-native/Dep.olean' "$g"; then
  echo "FAIL: graph must still list A32 path-dep olean for Dep"
  exit 1
fi
if ! grep -Eq 'module Dep obj_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must have module Dep obj_hash <16-hex>"
  echo "--- seal ---"
  cat "$s"
  exit 1
fi
if ! grep -Eq 'module App obj_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must have module App obj_hash <16-hex>"
  exit 1
fi
assert_a34_banner "$out"
echo "OK: require_path_shaped path-dep + root object inventory"

echo "== A34 A29 sibling: object Dep ../dep/.slake-native/Dep.o =="
if [[ ! -f "$SIBLING_PKG/lakefile.toml" || ! -f "$SIBLING_PKG/App.lean" || ! -f "$ROOT/require_sibling_shaped/dep/Dep.lean" ]]; then
  strict_fail "require_sibling_shaped fixture missing at $SIBLING_PKG"
fi
rm -rf "$SIBLING_PKG/.slake-native" "$ROOT/require_sibling_shaped/dep/.slake-native" \
  "$SIBLING_PKG/.lake" "$ROOT/require_sibling_shaped/dep/.lake" 2>/dev/null || true
out=""
rc=0
out="$(
  cd "$SIBLING_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: sibling PLAN_ONLY+OBJ+GRAPH+SEAL exited $rc"
  exit 1
fi
sg="$SIBLING_PKG/.slake-native/slake_native_graph"
ss="$SIBLING_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$sg" || ! -f "$ss" ]]; then
  echo "FAIL: sibling expected graph and seal files"
  exit 1
fi
if ! grep -Fq 'object Dep ../dep/.slake-native/Dep.o' "$sg"; then
  echo "FAIL: sibling graph must list object Dep ../dep/.slake-native/Dep.o (A29 package-cwd-relative)"
  echo "--- sibling graph ---"
  cat "$sg"
  exit 1
fi
if grep -E 'object Dep /' "$sg"; then
  echo "FAIL: sibling graph must not use absolute host path for path-dep Dep object"
  exit 1
fi
if ! grep -Fq 'object App .slake-native/App.o' "$sg"; then
  echo "FAIL: sibling graph must list object App .slake-native/App.o"
  exit 1
fi
if ! grep -Eq 'module Dep obj_hash [0-9a-f]{16}' "$ss"; then
  echo "FAIL: sibling seal must have module Dep obj_hash <16-hex>"
  exit 1
fi
assert_a34_banner "$out"
echo "OK: A29 sibling package-cwd-relative path-dep object inventory"

echo "== A34 nested path-dep: object Foo.Bar dep/.slake-native/Foo/Bar.o =="
if [[ ! -f "$NESTED_PKG/lakefile.toml" || ! -f "$NESTED_PKG/App.lean" || ! -f "$NESTED_PKG/dep/Foo/Bar.lean" ]]; then
  strict_fail "require_path_nested_shaped fixture missing at $NESTED_PKG"
fi
rm -rf "$NESTED_PKG/.slake-native" "$NESTED_PKG/dep/.slake-native" \
  "$NESTED_PKG/.lake" "$NESTED_PKG/dep/.lake" 2>/dev/null || true
out=""
rc=0
out="$(
  cd "$NESTED_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: nested PLAN_ONLY+OBJ+GRAPH+SEAL exited $rc"
  exit 1
fi
ng="$NESTED_PKG/.slake-native/slake_native_graph"
ns="$NESTED_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$ng" || ! -f "$ns" ]]; then
  echo "FAIL: nested expected graph and seal files"
  exit 1
fi
if [[ ! -f "$NESTED_PKG/dep/.slake-native/Foo/Bar.o" ]]; then
  echo "FAIL: expected nested path-dep Foo/Bar.o at dep/.slake-native/Foo/Bar.o"
  exit 1
fi
if ! grep -Fq 'object Foo.Bar dep/.slake-native/Foo/Bar.o' "$ng"; then
  echo "FAIL: nested graph must list object Foo.Bar dep/.slake-native/Foo/Bar.o (not doubled)"
  echo "--- nested graph ---"
  cat "$ng"
  exit 1
fi
if grep -E 'object Foo\.Bar .*(Foo/Foo|Foo\.Foo)' "$ng"; then
  echo "FAIL: nested graph must not double Foo components in object path"
  exit 1
fi
if grep -E 'object Foo\.Bar /' "$ng"; then
  echo "FAIL: nested graph must not use absolute path for path-dep Foo.Bar object"
  exit 1
fi
if ! grep -Fq 'object App .slake-native/App.o' "$ng"; then
  echo "FAIL: nested graph must list object App .slake-native/App.o"
  exit 1
fi
# A32 olean lines still present for nested path-dep.
if ! grep -Fq 'module Foo.Bar olean dep/.slake-native/Foo/Bar.olean' "$ng"; then
  echo "FAIL: nested graph must still list A32 path-dep olean for Foo.Bar"
  exit 1
fi
if ! grep -Eq 'module Foo\.Bar obj_hash [0-9a-f]{16}' "$ns"; then
  echo "FAIL: nested seal must have module Foo.Bar obj_hash <16-hex>"
  echo "--- nested seal ---"
  cat "$ns"
  exit 1
fi
if ! grep -Eq 'module App obj_hash [0-9a-f]{16}' "$ns"; then
  echo "FAIL: nested seal must have module App obj_hash <16-hex>"
  exit 1
fi
assert_a34_banner "$out"
echo "OK: nested path-dep Foo.Bar object inventory (not doubled)"

echo "== A34 GRAPH+SEAL without NATIVE_OBJ: no object/obj_hash lines =="
wipe_systems
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+GRAPH+SEAL without OBJ exited $rc"
  exit 1
fi
g="$SYSTEMS_PKG/.slake-native/slake_native_graph"
s="$SYSTEMS_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$g" || ! -f "$s" ]]; then
  echo "FAIL: expected olean-only graph and seal"
  exit 1
fi
# Olean inventory still present (A14/A15 regression).
if ! grep -Fq 'module Core olean .slake-native/Core.olean' "$g"; then
  echo "FAIL: olean-only graph must still list module Core olean"
  exit 1
fi
if ! grep -Eq 'module Core olean_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: olean-only seal must still list module Core olean_hash"
  exit 1
fi
assert_no_a34_claims "$g" "$s" "$out"
echo "OK: without NATIVE_OBJ no object/obj_hash lines (A14/A15 regression)"

echo "== A34 systems_shaped olean-only still green (no false A34 claims) =="
# Already covered by band 4; reaffirm no object products after clean olean path.
if [[ -f "$SYSTEMS_PKG/.slake-native/Core.o" ]]; then
  echo "FAIL: olean-only path must not leave Core.o"
  exit 1
fi
echo "OK: systems_shaped olean-only graph/seal green without A34 claims"

echo "== A34 help honesty =="
# Here-strings avoid pipefail+grep -q SIGPIPE when patterns match early in large help.
help="$("$SLAKE_EXE" --help 2>&1)" || true
if ! grep -Eiq 'plan-module object inventory|A34' <<<"$help"; then
  echo "FAIL: --help must mention A34 plan-module object inventory in NATIVE_GRAPH + NATIVE_SEAL"
  exit 1
fi
if ! grep -Eiq 'object <Mod>|obj_hash' <<<"$help"; then
  echo "FAIL: --help must document object <Mod> / obj_hash inventory lines"
  exit 1
fi
if ! grep -Eiq 'not freestanding build TCB|not CLAIMED' <<<"$help"; then
  echo "FAIL: --help must residual-deny freestanding TCB / CLAIMED near A34"
  exit 1
fi

echo "== A34 env honesty (GRAPH) =="
env_g="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_GRAPH=1
  unset SLAKE_NATIVE_SEAL || true
  unset SLAKE_NATIVE_OBJ || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'plan-module object inventory|A34' <<<"$env_g"; then
  echo "FAIL: env with NATIVE_GRAPH must mention A34 object inventory subset"
  exit 1
fi

echo "== A34 env honesty (SEAL) =="
env_s="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_OBJ || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'plan-module object inventory|A34|obj_hash' <<<"$env_s"; then
  echo "FAIL: env with NATIVE_SEAL must mention A34 object inventory / obj_hash"
  exit 1
fi

echo "OK: A34 freestanding-adjacent plan-module object inventory in NATIVE_GRAPH + NATIVE_SEAL smoke"
exit 0
