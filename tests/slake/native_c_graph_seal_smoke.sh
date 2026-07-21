#!/usr/bin/env bash
# Smoke: A35 freestanding-adjacent plan-module C source inventory in NATIVE_GRAPH +
# NATIVE_SEAL.
#
# A19/A31 emit plan-module .c (root under .slake-native/, A30-folded path-dep
# under dep/.slake-native/). A35 product-guarantees those .c appear in:
#   .slake-native/slake_native_graph  with package-cwd-relative c_source paths
#     (e.g. c_source Core .slake-native/Core.c;
#      c_source Dep dep/.slake-native/Dep.c;
#      A29 sibling c_source Dep ../dep/.slake-native/Dep.c)
#   .slake-native/slake_native_seal   with module <Mod> c_hash <16-hex>
#     (FNV-1a 64 over C file bytes)
#
# Honesty: freestanding-adjacent plan-module C source inventory in NATIVE_GRAPH +
# NATIVE_SEAL subset — not freestanding build TCB / not Lake lean_lib facet /
# not CLAIMED / not every dep plan module / not changing C emit semantics.
# Soft-omit missing .c; banners only when ≥1 c_source/c_hash line. SCORE does
# **not** run this smoke.
#
# Prefer absolute SLAKE_BIN (this script absolutizes when set). Relative
# SLAKE_BIN from repo root fails after cd into fixtures.
#
# Bands:
#   1) PLAN_ONLY + NATIVE_C + NATIVE_GRAPH + NATIVE_SEAL on systems_shaped:
#      c_source Core/Host lines + c_hash for both
#   2) require_path_shaped + path-dep: c_source Dep under dep/.slake-native + App
#   3) Optional sibling band: c_source Dep ../dep/.slake-native/Dep.c
#   4) nested require_path_nested_shaped: c_source Foo.Bar dep/.slake-native/Foo/Bar.c
#   5) NATIVE_GRAPH+SEAL without NATIVE_C products: no c_source/c_hash lines
#   6) systems_shaped olean-only still green (no false A35 claims)
#   7) help/env honesty greps (capture to var then grep <<<"$var")
#
#   SLAKE_NATIVE_C_GRAPH_SEAL_SMOKE_STRICT=1 ./tests/slake/native_c_graph_seal_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
PKG="$ROOT/require_path_shaped"
SIBLING_PKG="$ROOT/require_sibling_shaped/app"
NESTED_PKG="$ROOT/require_path_nested_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_C_GRAPH_SEAL_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_GRAPH_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_SEAL_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_C_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

wipe_systems() {
  rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true
}

wipe_pkg() {
  rm -rf "$PKG/.slake-native" "$PKG/dep/.slake-native" "$PKG/.lake" "$PKG/dep/.lake" 2>/dev/null || true
}

assert_a35_banner() {
  local out="$1"
  # Here-strings: pipefail + grep -q can false-fail on early match SIGPIPE.
  if ! grep -Eiq 'plan-module C source inventory in NATIVE_GRAPH|plan-module C source inventory in NATIVE_SEAL|A35 freestanding-adjacent plan-module C' <<<"$out"; then
    echo "FAIL: expected A35 plan-module C source inventory honesty wording in build output"
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

assert_no_a35_claims() {
  local g="$1"
  local s="$2"
  local out="$3"
  if grep -Eq '^c_source ' "$g" 2>/dev/null; then
    echo "FAIL: expected no c_source lines without NATIVE_C products"
    echo "--- graph ---"
    cat "$g"
    exit 1
  fi
  if grep -Eq 'c_hash' "$s" 2>/dev/null; then
    echo "FAIL: expected no c_hash lines without NATIVE_C products"
    echo "--- seal ---"
    cat "$s"
    exit 1
  fi
  if grep -Fq 'A35 freestanding-adjacent plan-module C' "$g" 2>/dev/null; then
    echo "FAIL: graph must not claim A35 C source inventory when no c_source lines"
    exit 1
  fi
  if grep -Fq 'A35 freestanding-adjacent plan-module C' "$s" 2>/dev/null; then
    echo "FAIL: seal must not claim A35 C source inventory when no c_hash lines"
    exit 1
  fi
  # Here-strings: pipefail + grep -q can false-pass a negative check on early-match SIGPIPE.
  if grep -Eiq 'A35 freestanding-adjacent plan-module C source inventory' <<<"$out"; then
    echo "FAIL: build output must not claim A35 C source inventory when no C sources"
    exit 1
  fi
}

echo "== A35 PLAN_ONLY + NATIVE_C + GRAPH + SEAL: systems_shaped Core/Host C sources =="
wipe_systems
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_C=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_EXE || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH_STRICT || true
  unset SLAKE_NATIVE_SEAL_STRICT || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+C+GRAPH+SEAL systems_shaped exited $rc (expected 0)"
  exit 1
fi
g="$SYSTEMS_PKG/.slake-native/slake_native_graph"
s="$SYSTEMS_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$g" || ! -f "$s" ]]; then
  echo "FAIL: expected graph and seal files under systems_shaped"
  exit 1
fi
if [[ ! -f "$SYSTEMS_PKG/.slake-native/Core.c" || ! -f "$SYSTEMS_PKG/.slake-native/Host.c" ]]; then
  echo "FAIL: expected Core.c and Host.c under systems_shaped .slake-native"
  exit 1
fi
if ! grep -Fq 'c_source Core .slake-native/Core.c' "$g"; then
  echo "FAIL: graph must list c_source Core .slake-native/Core.c"
  echo "--- graph ---"
  cat "$g"
  exit 1
fi
if ! grep -Fq 'c_source Host .slake-native/Host.c' "$g"; then
  echo "FAIL: graph must list c_source Host .slake-native/Host.c"
  echo "--- graph ---"
  cat "$g"
  exit 1
fi
# Olean lines stay stable (A14).
if ! grep -Fq 'module Core olean .slake-native/Core.olean' "$g"; then
  echo "FAIL: graph must still list module Core olean (A14 stable)"
  exit 1
fi
if ! grep -Fq 'A35 freestanding-adjacent plan-module C source inventory in NATIVE_GRAPH' "$g"; then
  echo "FAIL: graph header must identify A35 C source inventory subset"
  exit 1
fi
if ! grep -Eq 'module Core c_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must have module Core c_hash <16-hex>"
  echo "--- seal ---"
  cat "$s"
  exit 1
fi
if ! grep -Eq 'module Host c_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must have module Host c_hash <16-hex>"
  exit 1
fi
if ! grep -Eq 'module Core olean_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must still have module Core olean_hash (A15 stable)"
  exit 1
fi
if ! grep -Fq 'A35 freestanding-adjacent plan-module C source inventory in NATIVE_SEAL' "$s"; then
  echo "FAIL: seal header must identify A35 C source inventory subset"
  exit 1
fi
# Without NATIVE_OBJ: no object inventory claims.
if grep -Eq '^object ' "$g" 2>/dev/null; then
  echo "FAIL: NATIVE_C-only path must not list object lines"
  exit 1
fi
if grep -Eq 'obj_hash' "$s" 2>/dev/null; then
  echo "FAIL: NATIVE_C-only path must not list obj_hash lines"
  exit 1
fi
assert_a35_banner "$out"
echo "OK: systems_shaped PLAN_ONLY+C+GRAPH+SEAL C source inventory"

echo "== A35 require_path_shaped: path-dep Dep.c + root App.c =="
if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/App.lean" || ! -f "$PKG/dep/Dep.lean" ]]; then
  strict_fail "require_path_shaped fixture missing at $PKG"
fi
wipe_pkg
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_C=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: require_path_shaped PLAN_ONLY+C+GRAPH+SEAL exited $rc"
  exit 1
fi
g="$PKG/.slake-native/slake_native_graph"
s="$PKG/.slake-native/slake_native_seal"
if [[ ! -f "$g" || ! -f "$s" ]]; then
  echo "FAIL: expected graph and seal under require_path_shaped"
  exit 1
fi
if [[ ! -f "$PKG/dep/.slake-native/Dep.c" ]]; then
  echo "FAIL: expected path-dep Dep.c at dep/.slake-native/Dep.c"
  exit 1
fi
if [[ ! -f "$PKG/.slake-native/App.c" ]]; then
  echo "FAIL: expected root App.c at .slake-native/App.c"
  exit 1
fi
if ! grep -Fq 'c_source Dep dep/.slake-native/Dep.c' "$g"; then
  echo "FAIL: graph must list c_source Dep dep/.slake-native/Dep.c (package-cwd-relative)"
  echo "--- graph ---"
  cat "$g"
  exit 1
fi
if grep -E 'c_source Dep /' "$g"; then
  echo "FAIL: graph must not use absolute path for path-dep Dep C source"
  exit 1
fi
if ! grep -Fq 'c_source App .slake-native/App.c' "$g"; then
  echo "FAIL: graph must list c_source App .slake-native/App.c"
  exit 1
fi
# A32 olean lines still present.
if ! grep -Fq 'module Dep olean dep/.slake-native/Dep.olean' "$g"; then
  echo "FAIL: graph must still list A32 path-dep olean for Dep"
  exit 1
fi
if ! grep -Eq 'module Dep c_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must have module Dep c_hash <16-hex>"
  echo "--- seal ---"
  cat "$s"
  exit 1
fi
if ! grep -Eq 'module App c_hash [0-9a-f]{16}' "$s"; then
  echo "FAIL: seal must have module App c_hash <16-hex>"
  exit 1
fi
assert_a35_banner "$out"
echo "OK: require_path_shaped path-dep + root C source inventory"

echo "== A35 A29 sibling: c_source Dep ../dep/.slake-native/Dep.c =="
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
  export SLAKE_NATIVE_C=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_OBJ || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: sibling PLAN_ONLY+C+GRAPH+SEAL exited $rc"
  exit 1
fi
sg="$SIBLING_PKG/.slake-native/slake_native_graph"
ss="$SIBLING_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$sg" || ! -f "$ss" ]]; then
  echo "FAIL: sibling expected graph and seal files"
  exit 1
fi
if ! grep -Fq 'c_source Dep ../dep/.slake-native/Dep.c' "$sg"; then
  echo "FAIL: sibling graph must list c_source Dep ../dep/.slake-native/Dep.c (A29 package-cwd-relative)"
  echo "--- sibling graph ---"
  cat "$sg"
  exit 1
fi
if grep -E 'c_source Dep /' "$sg"; then
  echo "FAIL: sibling graph must not use absolute host path for path-dep Dep C source"
  exit 1
fi
if ! grep -Fq 'c_source App .slake-native/App.c' "$sg"; then
  echo "FAIL: sibling graph must list c_source App .slake-native/App.c"
  exit 1
fi
if ! grep -Eq 'module Dep c_hash [0-9a-f]{16}' "$ss"; then
  echo "FAIL: sibling seal must have module Dep c_hash <16-hex>"
  exit 1
fi
assert_a35_banner "$out"
echo "OK: A29 sibling package-cwd-relative path-dep C source inventory"

echo "== A35 nested path-dep: c_source Foo.Bar dep/.slake-native/Foo/Bar.c =="
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
  export SLAKE_NATIVE_C=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: nested PLAN_ONLY+C+GRAPH+SEAL exited $rc"
  exit 1
fi
ng="$NESTED_PKG/.slake-native/slake_native_graph"
ns="$NESTED_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$ng" || ! -f "$ns" ]]; then
  echo "FAIL: nested expected graph and seal files"
  exit 1
fi
if [[ ! -f "$NESTED_PKG/dep/.slake-native/Foo/Bar.c" ]]; then
  echo "FAIL: expected nested path-dep Foo/Bar.c at dep/.slake-native/Foo/Bar.c"
  exit 1
fi
if ! grep -Fq 'c_source Foo.Bar dep/.slake-native/Foo/Bar.c' "$ng"; then
  echo "FAIL: nested graph must list c_source Foo.Bar dep/.slake-native/Foo/Bar.c (not doubled)"
  echo "--- nested graph ---"
  cat "$ng"
  exit 1
fi
if grep -E 'c_source Foo\.Bar .*(Foo/Foo|Foo\.Foo)' "$ng"; then
  echo "FAIL: nested graph must not double Foo components in C source path"
  exit 1
fi
if grep -E 'c_source Foo\.Bar /' "$ng"; then
  echo "FAIL: nested graph must not use absolute path for path-dep Foo.Bar C source"
  exit 1
fi
if ! grep -Fq 'c_source App .slake-native/App.c' "$ng"; then
  echo "FAIL: nested graph must list c_source App .slake-native/App.c"
  exit 1
fi
# A32 olean lines still present for nested path-dep.
if ! grep -Fq 'module Foo.Bar olean dep/.slake-native/Foo/Bar.olean' "$ng"; then
  echo "FAIL: nested graph must still list A32 path-dep olean for Foo.Bar"
  exit 1
fi
if ! grep -Eq 'module Foo\.Bar c_hash [0-9a-f]{16}' "$ns"; then
  echo "FAIL: nested seal must have module Foo.Bar c_hash <16-hex>"
  echo "--- nested seal ---"
  cat "$ns"
  exit 1
fi
if ! grep -Eq 'module App c_hash [0-9a-f]{16}' "$ns"; then
  echo "FAIL: nested seal must have module App c_hash <16-hex>"
  exit 1
fi
assert_a35_banner "$out"
echo "OK: nested path-dep Foo.Bar C source inventory (not doubled)"

echo "== A35 GRAPH+SEAL without NATIVE_C: no c_source/c_hash lines =="
wipe_systems
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+GRAPH+SEAL without C exited $rc"
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
assert_no_a35_claims "$g" "$s" "$out"
echo "OK: without NATIVE_C no c_source/c_hash lines (A14/A15 regression)"

echo "== A35 systems_shaped olean-only still green (no false A35 claims) =="
# Already covered by band 5; reaffirm no C products after clean olean path.
if [[ -f "$SYSTEMS_PKG/.slake-native/Core.c" ]]; then
  echo "FAIL: olean-only path must not leave Core.c"
  exit 1
fi
echo "OK: systems_shaped olean-only graph/seal green without A35 claims"

echo "== A35 help honesty =="
# Here-strings avoid pipefail+grep -q SIGPIPE when patterns match early in large help.
help="$("$SLAKE_EXE" --help 2>&1)" || true
if ! grep -Eiq 'plan-module C source inventory|A35' <<<"$help"; then
  echo "FAIL: --help must mention A35 plan-module C source inventory in NATIVE_GRAPH + NATIVE_SEAL"
  exit 1
fi
if ! grep -Eiq 'c_source <Mod>|c_hash' <<<"$help"; then
  echo "FAIL: --help must document c_source <Mod> / c_hash inventory lines"
  exit 1
fi
if ! grep -Eiq 'not freestanding build TCB|not CLAIMED' <<<"$help"; then
  echo "FAIL: --help must residual-deny freestanding TCB / CLAIMED near A35"
  exit 1
fi

echo "== A35 env honesty (GRAPH) =="
env_g="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_GRAPH=1
  unset SLAKE_NATIVE_SEAL || true
  unset SLAKE_NATIVE_C || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'plan-module C source inventory|A35|c_source' <<<"$env_g"; then
  echo "FAIL: env with NATIVE_GRAPH must mention A35 C source inventory subset"
  exit 1
fi

echo "== A35 env honesty (SEAL) =="
env_s="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_C || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'plan-module C source inventory|A35|c_hash' <<<"$env_s"; then
  echo "FAIL: env with NATIVE_SEAL must mention A35 C source inventory / c_hash"
  exit 1
fi

echo "OK: A35 freestanding-adjacent plan-module C source inventory in NATIVE_GRAPH + NATIVE_SEAL smoke"
exit 0
