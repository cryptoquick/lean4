#!/usr/bin/env bash
# Smoke: A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products.
#
# A30 folds imported path-dep plan modules (Dep) into the root plan for olean
# topo, but A30 excluded them from root C/OBJ/IRLINK. A31 emits lean -c / cc -c
# for A30-folded path-dep modules under dep/.slake-native/ and feeds those .o
# into libslake_ir.so / libslake_ir.a / slake_ir.
#
# Honesty: freestanding-adjacent path-dep plan-module C/OBJ into IR products
# subset (A30-folded only) — not freestanding build TCB / not Lake lean_lib
# shared facet / not CLAIMED / not every dep plan module / not git/url.
# SCORE does **not** run this smoke.
#
# Prefer absolute SLAKE_BIN (this script absolutizes when set). Relative
# SLAKE_BIN from repo root fails after cd into fixtures.
#
# Bands:
#   1) PLAN_ONLY + NATIVE_IRLINK on require_path_shaped: Dep.o under dep/,
#      App.o under root, libslake_ir.so; honesty greps
#   2) NATIVE_BUILD + NATIVE_IRLINK: skip-lake success through path-dep C/OBJ
#   3) NATIVE_AR coexistence optional
#   4) NATIVE_EXE optional
#   5) Nested Foo.Bar path-dep C/OBJ under dep/.slake-native/Foo/
#   6) STRICT + missing LEANC fail-closed under path-dep fold
#   7) systems_shaped without path-require still green (no path-dep IR claims)
#   8) require_path / help / env honesty (IRLINK + AR + EXE + C)
#
#   SLAKE_NATIVE_PATHDEP_IR_SMOKE_STRICT=1 ./tests/slake/native_pathdep_ir_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/require_path_shaped"
NESTED_PKG="$ROOT/require_path_nested_shaped"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_PATHDEP_IR_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_IRLINK_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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
if [[ ! -f "$NESTED_PKG/lakefile.toml" || ! -f "$NESTED_PKG/App.lean" || ! -f "$NESTED_PKG/dep/Foo/Bar.lean" ]]; then
  echo "FAIL: missing require_path_nested_shaped package at $NESTED_PKG"
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
  strict_fail "host cc not found (set CC= or PATH)"
fi

LEANC_PROBE="${LEANC:-leanc}"
if ! command -v "$LEANC_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEANC_PROBE" ]]; then
  strict_fail "host leanc not found (set LEANC= or PATH)"
fi

wipe_pkg() {
  rm -rf "$PKG/.slake-native" "$PKG/dep/.slake-native" "$PKG/.lake" "$PKG/dep/.lake" 2>/dev/null || true
}

wipe_nested() {
  rm -rf "$NESTED_PKG/.slake-native" "$NESTED_PKG/dep/.slake-native" \
    "$NESTED_PKG/.lake" "$NESTED_PKG/dep/.lake" 2>/dev/null || true
}

assert_pathdep_ir_products() {
  local so="$PKG/.slake-native/libslake_ir.so"
  local app_o="$PKG/.slake-native/App.o"
  local dep_o="$PKG/dep/.slake-native/Dep.o"
  local dep_c="$PKG/dep/.slake-native/Dep.c"
  for f in "$so" "$app_o" "$dep_o" "$dep_c"; do
    if [[ ! -f "$f" ]]; then
      echo "FAIL: expected regular file at $f"
      exit 1
    fi
    if [[ ! -s "$f" ]]; then
      echo "FAIL: expected non-empty file at $f"
      exit 1
    fi
  done
  # Root must not host-compile path-dep Dep into root outDir.
  if [[ -f "$PKG/.slake-native/Dep.o" ]]; then
    echo "FAIL: path-dep Dep.o must live under dep/.slake-native/, not root .slake-native/"
    exit 1
  fi
}

assert_honesty() {
  local out="$1"
  if ! printf '%s' "$out" | grep -Eiq 'path-dep plan-module C/OBJ into IR products|path-dep plan-module C emit|path-dep object'; then
    echo "FAIL: expected A31 path-dep IR honesty wording"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding-adjacent path-dep|path-dep plan-module C/OBJ into IR'; then
    echo "FAIL: expected freestanding-adjacent path-dep IR subset wording"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
    echo "FAIL: expected freestanding build TCB denial"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not CLAIMED"; then
    echo "FAIL: expected not CLAIMED denial"
    exit 1
  fi
  # Must not claim full Lake lean_lib shared facet as achieved product.
  if printf '%s' "$out" | grep -Eiq 'Lake lean_lib shared' \
      && ! printf '%s' "$out" | grep -Eiq 'not Lake lean_lib'; then
    echo "FAIL: overclaim Lake lean_lib without denial"
    exit 1
  fi
}

wipe_pkg

echo "== A31 PLAN_ONLY + NATIVE_IRLINK: path-dep Dep.o + root App.o + libslake_ir.so =="
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_IRLINK_STRICT || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_EXE || true
  unset SLAKE_NATIVE_LINK || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_IRLINK exited $rc"
  exit 1
fi
assert_pathdep_ir_products
assert_honesty "$out"
if ! printf '%s' "$out" | grep -Eq 'slake depgraph plan:.*Dep.*App'; then
  echo "FAIL: expected expanded plan with Dep before App"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'path-dep object|path-dep module'; then
  echo "FAIL: expected path-dep object count / module note in IR link path"
  exit 1
fi

echo "== A31 NATIVE_BUILD + NATIVE_IRLINK: skip-lake through path-dep C/OBJ =="
wipe_pkg
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_PLAN_ONLY || true
  unset SLAKE_NATIVE_IRLINK_STRICT || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_EXE || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_IRLINK exited $rc (expected 0)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host lean C-output emit + host object compile + host leanc IR shared-lib link"; then
  echo "FAIL: expected skip-lake banner with host leanc IR shared-lib link under NATIVE_BUILD"
  exit 1
fi
assert_pathdep_ir_products
assert_honesty "$out"
if [[ -d "$PKG/.lake/build" ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_IRLINK must not create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_IRLINK skip-lake with path-dep Dep.o + libslake_ir.so"

echo "== A31 NATIVE_AR coexistence with path-dep objs =="
wipe_pkg
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_AR=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_EXE || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  unset AR || true
  "$SLAKE_EXE" build 2>&1
)" || { echo "FAIL: IRLINK+AR build failed"; printf '%s\n' "$out"; exit 1; }
printf '%s\n' "$out"
assert_pathdep_ir_products
if [[ ! -s "$PKG/.slake-native/libslake_ir.a" ]]; then
  echo "FAIL: expected non-empty libslake_ir.a"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'path-dep plan-module C/OBJ into IR products|path-dep object'; then
  echo "FAIL: AR path expected path-dep IR honesty"
  exit 1
fi

echo "== A31 NATIVE_EXE with path-dep objs =="
wipe_pkg
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_EXE=1
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_BUILD || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || { echo "FAIL: EXE build failed"; printf '%s\n' "$out"; exit 1; }
printf '%s\n' "$out"
if [[ ! -s "$PKG/dep/.slake-native/Dep.o" ]]; then
  echo "FAIL: expected Dep.o under dep for EXE"
  exit 1
fi
if [[ ! -s "$PKG/.slake-native/slake_ir" ]]; then
  echo "FAIL: expected non-empty slake_ir executable"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'path-dep plan-module C/OBJ into IR products|path-dep object'; then
  echo "FAIL: EXE path expected path-dep IR honesty"
  exit 1
fi

echo "== A31 nested Foo.Bar path-dep C/OBJ under dep/.slake-native/Foo/ =="
wipe_nested
out=""
rc=0
out="$(
  cd "$NESTED_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_EXE || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: nested PLAN_ONLY+NATIVE_IRLINK exited $rc"
  exit 1
fi
nested_c="$NESTED_PKG/dep/.slake-native/Foo/Bar.c"
nested_o="$NESTED_PKG/dep/.slake-native/Foo/Bar.o"
nested_so="$NESTED_PKG/.slake-native/libslake_ir.so"
app_o="$NESTED_PKG/.slake-native/App.o"
for f in "$nested_c" "$nested_o" "$nested_so" "$app_o"; do
  if [[ ! -s "$f" ]]; then
    echo "FAIL: expected non-empty nested path-dep product at $f"
    exit 1
  fi
done
# Doubled path would be dep/.slake-native/Foo/Foo/Bar.* (bug from olean.parent).
if [[ -e "$NESTED_PKG/dep/.slake-native/Foo/Foo" ]]; then
  echo "FAIL: doubled nested path dep/.slake-native/Foo/Foo (pathDepOutDir bug)"
  exit 1
fi
if [[ -f "$NESTED_PKG/.slake-native/Foo/Bar.o" ]]; then
  echo "FAIL: nested path-dep Foo.Bar.o must live under dep/.slake-native/, not root"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eq 'Foo\.Bar'; then
  echo "FAIL: expected Foo.Bar in plan or path-dep IR path"
  exit 1
fi
assert_honesty "$out"
echo "OK: nested Foo.Bar C/OBJ at dep/.slake-native/Foo/Bar.{c,o}"

echo "== A31 STRICT + missing LEANC fail-closed under path-dep fold =="
wipe_pkg
out=""
rc=0
out="$(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  export SLAKE_NATIVE_IRLINK_STRICT=1
  export LEANC="/nonexistent/leanc-a31-pathdep-missing-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_IRLINK_STRICT with missing leanc must exit nonzero under path-dep fold"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'leanc not found|not usable|STRICT|fail-closed'; then
  echo "FAIL: expected leanc-missing STRICT diagnostic under path-dep fold"
  exit 1
fi
if [[ -f "$PKG/.slake-native/libslake_ir.so" ]]; then
  echo "FAIL: must not write libslake_ir.so when leanc missing under STRICT"
  exit 1
fi
# Path-dep C/OBJ may still have run before IR link; that is fine — link fail-closed.
echo "OK: STRICT + missing LEANC fail-closed under path-dep fold"

echo "== A31 systems_shaped without path-require: no path-dep IR claims =="
rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_NATIVE_BUILD || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || { echo "FAIL: systems_shaped IRLINK failed"; printf '%s\n' "$out"; exit 1; }
printf '%s\n' "$out"
if [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
  echo "FAIL: systems_shaped expected libslake_ir.so"
  exit 1
fi
if printf '%s' "$out" | grep -Eiq 'A31 path-dep|path-dep plan-module C emit|path-dep plan-module object compile'; then
  echo "FAIL: systems_shaped without path-require must not claim path-dep IR"
  exit 1
fi

echo "== A31 help honesty =="
# Here-strings avoid pipefail+grep -q SIGPIPE when patterns match early in large help.
help="$("$SLAKE_EXE" --help 2>&1)" || true
if ! grep -Eiq 'path-dep plan-module C/OBJ into IR products|A31' <<<"$help"; then
  echo "FAIL: --help must mention A31 path-dep plan-module C/OBJ into IR products"
  exit 1
fi
if ! grep -Eiq 'not Lake lean_lib|not freestanding build TCB' <<<"$help"; then
  echo "FAIL: --help must deny Lake lean_lib / freestanding TCB near A31"
  exit 1
fi
if ! grep -Eiq 'path-dep C → root C|path-dep C' <<<"$help"; then
  echo "FAIL: --help must document path-dep C before root C order"
  exit 1
fi

echo "== A31 env honesty (IRLINK) =="
env_out="$(
  cd "$PKG"
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_EXE || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_OBJ || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'path-dep plan-module C/OBJ into IR products|A31' <<<"$env_out"; then
  echo "FAIL: env with NATIVE_IRLINK must mention A31 path-dep IR subset"
  exit 1
fi

echo "== A31 env honesty (AR-only) =="
env_ar="$(
  cd "$PKG"
  export SLAKE_NATIVE_AR=1
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_EXE || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_OBJ || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'path-dep plan-module C/OBJ into IR products|A31' <<<"$env_ar"; then
  echo "FAIL: env with NATIVE_AR must mention A31 path-dep IR subset"
  exit 1
fi

echo "== A31 env honesty (EXE-only) =="
env_exe="$(
  cd "$PKG"
  export SLAKE_NATIVE_EXE=1
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_OBJ || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'path-dep plan-module C/OBJ into IR products|A31' <<<"$env_exe"; then
  echo "FAIL: env with NATIVE_EXE must mention A31 path-dep IR subset"
  exit 1
fi

echo "== A31 env honesty (C-only) =="
env_c="$(
  cd "$PKG"
  export SLAKE_NATIVE_C=1
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_EXE || true
  unset SLAKE_NATIVE_OBJ || true
  "$SLAKE_EXE" env 2>&1
)" || true
if ! grep -Eiq 'path-dep plan-module C/OBJ into IR products|A31' <<<"$env_c"; then
  echo "FAIL: env with NATIVE_C must mention A31 path-dep IR subset"
  exit 1
fi

wipe_pkg
wipe_nested
rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true

echo "PASS: native_pathdep_ir_smoke (A31 freestanding-adjacent path-dep plan-module C/OBJ into IR products subset)"
