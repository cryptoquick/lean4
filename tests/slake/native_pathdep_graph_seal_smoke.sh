#!/usr/bin/env bash
# Smoke: A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH +
# NATIVE_SEAL.
#
# A30 folds imported path-dep plan modules (Dep) into the root plan; A31 emits
# path-dep C/OBJ into IR products. A32 product-guarantees those A30-folded modules
# appear in:
#   .slake-native/slake_native_graph  with package-cwd-relative olean paths
#     (e.g. module Dep olean dep/.slake-native/Dep.olean;
#      A29 sibling ../dep/.slake-native/Dep.olean)
#   .slake-native/slake_native_seal   with path-dep olean_hash lines
#
# Honesty: freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH +
# NATIVE_SEAL subset (A30-folded only) — not freestanding build TCB / not Lake
# build graph TCB / not Lake resolve-deps / not CLAIMED / not every dep plan
# module / not git/url / not multi-... SCORE does **not** run this smoke.
#
# Prefer absolute SLAKE_BIN (this script absolutizes when set). Relative
# SLAKE_BIN from repo root fails after cd into fixtures.
#
# Bands:
#   1) PLAN_ONLY + NATIVE_GRAPH: Dep under dep/.slake-native/ + App under root;
#      edge Dep App; A32 honesty
#   2) PLAN_ONLY + NATIVE_SEAL: path-dep + root olean_hash; seal digest
#   3) PLAN_ONLY + NATIVE_IRLINK + NATIVE_GRAPH: shared_lib_ir when SO exists
#   4) NATIVE_BUILD + GRAPH + SEAL + IRLINK skip-lake band
#   5) A29 sibling require_sibling_shaped: ../dep/.slake-native/Dep.olean (not abs)
#   6) nested require_path_nested_shaped: Foo.Bar → dep/.slake-native/Foo/Bar.olean
#   7) systems_shaped: no path-dep path prefixes in graph/seal module lines
#   8) help/env honesty greps for A32 wording
#
#   SLAKE_NATIVE_PATHDEP_GRAPH_SEAL_SMOKE_STRICT=1 ./tests/slake/native_pathdep_graph_seal_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/require_path_shaped"
SIBLING_PKG="$ROOT/require_sibling_shaped/app"
NESTED_PKG="$ROOT/require_path_nested_shaped"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_PATHDEP_GRAPH_SEAL_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_GRAPH_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_SEAL_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/App.lean" || ! -f "$PKG/dep/Dep.lean" ]]; then
  echo "FAIL: missing require_path_shaped package at $PKG"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

LEAN_PROBE="${LEAN:-lean}"
if ! command -v "$LEAN_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEAN_PROBE" ]]; then
  strict_fail "host lean not found (set LEAN= or PATH to stage1/bin)"
fi

wipe_pkg() {
  rm -rf "$PKG/.slake-native" "$PKG/dep/.slake-native" "$PKG/.lake" "$PKG/dep/.lake" 2>/dev/null || true
}

assert_graph_pathdep() {
  local g="$1"
  if [[ ! -f "$g" ]]; then
    echo "FAIL: expected graph file at $g"
    exit 1
  fi
  if ! grep -Fq 'package require_path_shaped' "$g"; then
    echo "FAIL: graph must have package require_path_shaped line"
    exit 1
  fi
  # A32: package-cwd-relative path-dep olean (not absolute host path).
  if ! grep -Fq 'module Dep olean dep/.slake-native/Dep.olean' "$g"; then
    echo "FAIL: graph must list module Dep olean dep/.slake-native/Dep.olean (package-cwd-relative)"
    echo "--- graph ---"
    cat "$g"
    exit 1
  fi
  if grep -E 'module Dep olean /' "$g"; then
    echo "FAIL: graph must not use absolute path for path-dep Dep olean"
    exit 1
  fi
  if ! grep -Fq 'module App olean .slake-native/App.olean' "$g"; then
    echo "FAIL: graph must list module App olean .slake-native/App.olean"
    exit 1
  fi
  if ! grep -Fq 'edge Dep App' "$g"; then
    echo "FAIL: graph must have edge Dep App (App imports Dep)"
    exit 1
  fi
  if ! grep -Eq 'summary modules=2 edges=1' "$g"; then
    echo "FAIL: graph must have summary modules=2 edges=1"
    exit 1
  fi
  if ! grep -Fq 'A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH' "$g"; then
    echo "FAIL: graph header must identify A32 path-dep plan-module nodes subset"
    exit 1
  fi
  if ! grep -Fq 'NOT freestanding build TCB' "$g"; then
    echo "FAIL: graph header must residual-honesty NOT freestanding build TCB"
    exit 1
  fi
  if ! grep -Fq 'NOT Lake build graph TCB' "$g"; then
    echo "FAIL: graph header must residual-honesty NOT Lake build graph TCB"
    exit 1
  fi
  if ! grep -Fq 'NOT CLAIMED' "$g"; then
    echo "FAIL: graph header must residual-honesty NOT CLAIMED"
    exit 1
  fi
}

assert_seal_pathdep() {
  local s="$1"
  if [[ ! -f "$s" ]]; then
    echo "FAIL: expected seal file at $s"
    exit 1
  fi
  if ! grep -Fq 'package require_path_shaped' "$s"; then
    echo "FAIL: seal must have package require_path_shaped line"
    exit 1
  fi
  if ! grep -Eq 'module Dep olean_hash [0-9a-f]{16}' "$s"; then
    echo "FAIL: seal must have module Dep olean_hash <16-hex>"
    echo "--- seal ---"
    cat "$s"
    exit 1
  fi
  if ! grep -Eq 'module App olean_hash [0-9a-f]{16}' "$s"; then
    echo "FAIL: seal must have module App olean_hash <16-hex>"
    exit 1
  fi
  if ! grep -Eq '^seal [0-9a-f]{16}$' "$s"; then
    echo "FAIL: seal must have seal <16-hex> digest line"
    exit 1
  fi
  if ! grep -Eq 'summary modules=2' "$s"; then
    echo "FAIL: seal must have summary modules=2"
    exit 1
  fi
  if ! grep -Fq 'A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_SEAL' "$s"; then
    echo "FAIL: seal header must identify A32 path-dep plan-module nodes subset"
    exit 1
  fi
  if ! grep -Fq 'NOT freestanding build TCB' "$s"; then
    echo "FAIL: seal header must residual-honesty NOT freestanding build TCB"
    exit 1
  fi
  if ! grep -Fq 'NOT CLAIMED' "$s"; then
    echo "FAIL: seal header must residual-honesty NOT CLAIMED"
    exit 1
  fi
}

assert_a32_banner() {
  local out="$1"
  # Here-strings: pipefail + grep -q can false-fail on early match SIGPIPE.
  if ! grep -Eiq 'path-dep plan-module nodes in NATIVE_GRAPH|path-dep plan-module nodes in NATIVE_SEAL|A32 freestanding-adjacent path-dep' <<<"$out"; then
    echo "FAIL: expected A32 path-dep plan-module nodes honesty wording in build output"
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

wipe_pkg

echo "== A32 PLAN_ONLY + NATIVE_GRAPH: path-dep Dep + root App module lines =="
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_GRAPH=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_EXE || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_SEAL || true
  unset SLAKE_NATIVE_GRAPH_STRICT || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_GRAPH exited $rc (expected 0)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eq 'slake depgraph plan:.*Dep.*App'; then
  echo "FAIL: expected expanded plan with Dep before App"
  exit 1
fi
assert_graph_pathdep "$PKG/.slake-native/slake_native_graph"
assert_a32_banner "$out"
echo "OK: PLAN_ONLY+NATIVE_GRAPH path-dep Dep + root App"

echo "== A32 PLAN_ONLY + NATIVE_SEAL: path-dep + root olean_hash =="
wipe_pkg
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_SEAL_STRICT || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_SEAL exited $rc (expected 0)"
  exit 1
fi
assert_seal_pathdep "$PKG/.slake-native/slake_native_seal"
assert_a32_banner "$out"
echo "OK: PLAN_ONLY+NATIVE_SEAL path-dep Dep + root App olean_hash"

echo "== A32 PLAN_ONLY + NATIVE_IRLINK + NATIVE_GRAPH: shared_lib_ir when SO exists =="
CC_PROBE="${CC:-cc}"
LEANC_PROBE="${LEANC:-leanc}"
if ! command -v "$CC_PROBE" >/dev/null 2>&1 && [[ ! -x "$CC_PROBE" ]]; then
  strict_fail "host cc not found (set CC= or PATH) for IRLINK band"
fi
if ! command -v "$LEANC_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEANC_PROBE" ]]; then
  strict_fail "host leanc not found (set LEANC= or PATH) for IRLINK band"
fi
wipe_pkg
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  export SLAKE_NATIVE_GRAPH=1
  unset SLAKE_NATIVE_SEAL || true
  unset SLAKE_NATIVE_BUILD || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+IRLINK+GRAPH exited $rc"
  exit 1
fi
assert_graph_pathdep "$PKG/.slake-native/slake_native_graph"
if [[ ! -s "$PKG/.slake-native/libslake_ir.so" ]]; then
  echo "FAIL: expected non-empty libslake_ir.so"
  exit 1
fi
if ! grep -Fq 'shared_lib_ir .slake-native/libslake_ir.so' "$PKG/.slake-native/slake_native_graph"; then
  echo "FAIL: graph must list shared_lib_ir when libslake_ir.so exists"
  exit 1
fi
assert_a32_banner "$out"
echo "OK: PLAN_ONLY+IRLINK+GRAPH with path-dep modules + shared_lib_ir"

echo "== A32 NATIVE_BUILD + GRAPH + SEAL + IRLINK: skip-lake band =="
wipe_pkg
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_IRLINK=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_PLAN_ONLY || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: NATIVE_BUILD+IRLINK+GRAPH+SEAL exited $rc (expected 0)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native"; then
  echo "FAIL: expected skip-lake banner under NATIVE_BUILD"
  exit 1
fi
assert_graph_pathdep "$PKG/.slake-native/slake_native_graph"
assert_seal_pathdep "$PKG/.slake-native/slake_native_seal"
if ! grep -Fq 'graph_hash' "$PKG/.slake-native/slake_native_seal"; then
  echo "FAIL: seal under GRAPH+SEAL must include graph_hash"
  exit 1
fi
if ! grep -Fq 'shared_lib_ir' "$PKG/.slake-native/slake_native_seal"; then
  echo "FAIL: seal under IRLINK+SEAL must include shared_lib_ir"
  exit 1
fi
if [[ -d "$PKG/.lake/build" ]]; then
  echo "FAIL: NATIVE_BUILD must not create .lake/build"
  exit 1
fi
assert_a32_banner "$out"
echo "OK: NATIVE_BUILD+IRLINK+GRAPH+SEAL skip-lake with path-dep nodes"

echo "== A32 A29 sibling: package-cwd-relative ../dep/.slake-native/Dep.olean =="
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
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: sibling PLAN_ONLY+GRAPH+SEAL exited $rc"
  exit 1
fi
sg="$SIBLING_PKG/.slake-native/slake_native_graph"
ss="$SIBLING_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$sg" || ! -f "$ss" ]]; then
  echo "FAIL: sibling expected graph and seal files"
  exit 1
fi
if ! grep -Fq 'module Dep olean ../dep/.slake-native/Dep.olean' "$sg"; then
  echo "FAIL: sibling graph must list module Dep olean ../dep/.slake-native/Dep.olean (A29 package-cwd-relative)"
  echo "--- sibling graph ---"
  cat "$sg"
  exit 1
fi
if grep -E 'module Dep olean /' "$sg"; then
  echo "FAIL: sibling graph must not use absolute host path for path-dep Dep olean"
  exit 1
fi
if ! grep -Fq 'module App olean .slake-native/App.olean' "$sg"; then
  echo "FAIL: sibling graph must list module App olean .slake-native/App.olean"
  exit 1
fi
if ! grep -Fq 'edge Dep App' "$sg"; then
  echo "FAIL: sibling graph must have edge Dep App"
  exit 1
fi
if ! grep -Eq 'module Dep olean_hash [0-9a-f]{16}' "$ss"; then
  echo "FAIL: sibling seal must have module Dep olean_hash <16-hex>"
  exit 1
fi
if ! grep -Eq 'module App olean_hash [0-9a-f]{16}' "$ss"; then
  echo "FAIL: sibling seal must have module App olean_hash <16-hex>"
  exit 1
fi
if ! grep -Fq 'A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH' "$sg"; then
  echo "FAIL: sibling graph header must identify A32 path-dep plan-module nodes"
  exit 1
fi
assert_a32_banner "$out"
echo "OK: A29 sibling package-cwd-relative path-dep graph/seal"

echo "== A32 nested path-dep: Foo.Bar → dep/.slake-native/Foo/Bar.olean =="
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
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: nested PLAN_ONLY+GRAPH+SEAL exited $rc"
  exit 1
fi
ng="$NESTED_PKG/.slake-native/slake_native_graph"
ns="$NESTED_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$ng" || ! -f "$ns" ]]; then
  echo "FAIL: nested expected graph and seal files"
  exit 1
fi
if ! grep -Fq 'module Foo.Bar olean dep/.slake-native/Foo/Bar.olean' "$ng"; then
  echo "FAIL: nested graph must list module Foo.Bar olean dep/.slake-native/Foo/Bar.olean (not doubled)"
  echo "--- nested graph ---"
  cat "$ng"
  exit 1
fi
if grep -E 'module Foo\.Bar olean .*(Foo/Foo|Foo\.Foo)' "$ng"; then
  echo "FAIL: nested graph must not double Foo components in olean path"
  exit 1
fi
if grep -E 'module Foo\.Bar olean /' "$ng"; then
  echo "FAIL: nested graph must not use absolute path for path-dep Foo.Bar olean"
  exit 1
fi
if ! grep -Fq 'module App olean .slake-native/App.olean' "$ng"; then
  echo "FAIL: nested graph must list module App olean .slake-native/App.olean"
  exit 1
fi
if ! grep -Fq 'edge Foo.Bar App' "$ng"; then
  echo "FAIL: nested graph must have edge Foo.Bar App"
  exit 1
fi
if ! grep -Eq 'module Foo\.Bar olean_hash [0-9a-f]{16}' "$ns"; then
  echo "FAIL: nested seal must have module Foo.Bar olean_hash <16-hex>"
  exit 1
fi
assert_a32_banner "$out"
echo "OK: nested path-dep Foo.Bar graph/seal (not doubled)"

echo "== A32 systems_shaped without path-require: no path-dep path prefixes =="
if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi
rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_IRLINK || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: systems_shaped GRAPH+SEAL exited $rc"
  exit 1
fi
g="$SYSTEMS_PKG/.slake-native/slake_native_graph"
s="$SYSTEMS_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$g" || ! -f "$s" ]]; then
  echo "FAIL: systems_shaped expected graph and seal files"
  exit 1
fi
# No path-dep-style module olean paths (dep/.slake-native/ or absolute outside .slake-native).
if grep -E 'module .+ olean [^.]' "$g" | grep -vE 'module .+ olean \.slake-native/'; then
  echo "FAIL: systems_shaped graph must not list path-dep-style olean paths"
  exit 1
fi
if grep -Fq 'A32 freestanding-adjacent path-dep' "$g"; then
  echo "FAIL: systems_shaped graph must not claim A32 path-dep plan-module nodes"
  exit 1
fi
if grep -Fq 'A32 freestanding-adjacent path-dep' "$s"; then
  echo "FAIL: systems_shaped seal must not claim A32 path-dep plan-module nodes"
  exit 1
fi
if printf '%s' "$out" | grep -Eiq 'A32 freestanding-adjacent path-dep plan-module nodes'; then
  echo "FAIL: systems_shaped without path-require must not emit A32 path-dep graph/seal banners"
  exit 1
fi
echo "OK: systems_shaped no path-dep graph/seal claims"

echo "== A32 help honesty =="
# Here-strings avoid pipefail+grep -q SIGPIPE when patterns match early in large help.
help="$("$SLAKE_EXE" --help 2>&1)" || true
if ! grep -Eiq 'path-dep plan-module nodes in NATIVE_GRAPH|A32' <<<"$help"; then
  echo "FAIL: --help must mention A32 path-dep plan-module nodes in NATIVE_GRAPH + NATIVE_SEAL"
  exit 1
fi
if ! grep -Eiq 'package-cwd-relative|root-package-relative|dep/\.slake-native' <<<"$help"; then
  echo "FAIL: --help must document package-cwd-relative path-dep olean paths"
  exit 1
fi
if ! grep -Eiq 'not freestanding build TCB|not Lake build graph TCB|not CLAIMED' <<<"$help"; then
  echo "FAIL: --help must residual-deny freestanding/Lake graph TCB / CLAIMED near A32"
  exit 1
fi

echo "== A32 env honesty (GRAPH) =="
env_g="$(
  cd "$PKG"
  export SLAKE_NATIVE_GRAPH=1
  unset SLAKE_NATIVE_SEAL || true
  unset SLAKE_NATIVE_IRLINK || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'path-dep plan-module nodes in NATIVE_GRAPH|A32' <<<"$env_g"; then
  echo "FAIL: env with NATIVE_GRAPH must mention A32 path-dep graph subset"
  exit 1
fi

echo "== A32 env honesty (SEAL) =="
env_s="$(
  cd "$PKG"
  export SLAKE_NATIVE_SEAL=1
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_IRLINK || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'path-dep plan-module nodes in NATIVE_SEAL|A32' <<<"$env_s"; then
  echo "FAIL: env with NATIVE_SEAL must mention A32 path-dep seal subset"
  exit 1
fi

echo "OK: A32 freestanding-adjacent path-dep plan-module nodes in NATIVE_GRAPH + NATIVE_SEAL smoke"
exit 0
