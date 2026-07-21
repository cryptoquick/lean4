#!/usr/bin/env bash
# Smoke: A19 SLAKE_NATIVE_C=1 host lean C-output emit subset after native oleans.
#
# Honesty: host lean C-output emit subset — not freestanding build TCB, not Lake
# lean_lib shared-object of compiled Lean IR, not full object compile+link of
# Lean runtime, not CLAIMED expansion. SCORE does **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with tools present.
#
# systems_shaped bands:
#   1) PLAN_ONLY + NATIVE_C: plan + oleans + Core.c / Host.c, exit 0, honesty banners
#   2) NATIVE_BUILD + NATIVE_C: skip lake; C files present
#   3) env reports NATIVE_C flags + NATIVE_BUILD/PLAN_ONLY conjunction lines
#   4) STRICT + missing LEAN → fail-closed
#   5) NATIVE_BUILD + NATIVE_C + missing LEAN → fail-closed (no skip-lake / no lake)
#   6) clean: after C emit, slake clean removes .slake-native
#   7) missing source soft-skip (Host.lean removed; Core still emits)
#   8) srcdir_shaped nested Foo/Bar.c + -R src
#
#   SLAKE_NATIVE_C_SMOKE_STRICT=1 ./tests/slake/native_c_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
SRCDIR_PKG="$ROOT/srcdir_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_C_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL (STRICT): $*"
    exit 1
  fi
  echo "SKIP: $*"
  exit 0
}

resolve_slake() {
  if [[ -n "${SLAKE_BIN:-}" && -x "${SLAKE_BIN}" ]]; then
    echo "$SLAKE_BIN"
    return 0
  fi
  local cand
  for cand in \
    "$REPO_ROOT/tests/slake/driver/.lake/build/bin/slake" \
    "$ROOT/driver/.lake/build/bin/slake"
  do
    if [[ -x "$cand" ]]; then
      echo "$cand"
      return 0
    fi
  done
  return 1
}

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

LEAN_PROBE="${LEAN:-lean}"
if ! command -v "$LEAN_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEAN_PROBE" ]]; then
  strict_fail "host lean not found (set LEAN= or PATH to stage1/bin)"
fi

if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi

# Wipe native products between bands.
wipe_native() {
  rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true
}

assert_c_files() {
  local core="$SYSTEMS_PKG/.slake-native/Core.c"
  local host="$SYSTEMS_PKG/.slake-native/Host.c"
  if [[ ! -f "$core" ]]; then
    echo "FAIL: expected Core.c at $core"
    exit 1
  fi
  if [[ ! -s "$core" ]]; then
    echo "FAIL: Core.c is empty"
    exit 1
  fi
  if [[ ! -f "$host" ]]; then
    echo "FAIL: expected Host.c at $host"
    exit 1
  fi
  if [[ ! -s "$host" ]]; then
    echo "FAIL: Host.c is empty"
    exit 1
  fi
  # Host lean C emit produces Lean compiler output markers (not empty greenwash).
  if ! grep -Fq 'Lean compiler output' "$core"; then
    echo "FAIL: Core.c missing Lean compiler output marker"
    exit 1
  fi
  if ! grep -Fq 'Lean compiler output' "$host"; then
    echo "FAIL: Host.c missing Lean compiler output marker"
    exit 1
  fi
}

assert_honesty() {
  local out="$1"
  if ! printf '%s' "$out" | grep -Fq "host lean C-output emit subset"; then
    echo "FAIL: expected host lean C-output emit subset honesty banner"
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
  # Must not claim Lake lean_lib SO of compiled Lean IR as achieved product.
  if printf '%s' "$out" | grep -Fq "Lake lean_lib shared-object of compiled Lean IR" \
      && ! printf '%s' "$out" | grep -Fq "not Lake lean_lib"; then
    echo "FAIL: overclaim Lake lean_lib without denial"
    exit 1
  fi
}

wipe_native

echo "== A19 Run 1: PLAN_ONLY + NATIVE_C → plan + oleans + C emit =="
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_C=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_C Run 1 exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eq 'systems_shaped.*Core.*Host|slake depgraph plan: systems_shaped Core Host|slake host plan: systems_shaped Core Host'; then
  # Accept either freestanding or host plan banner forms used by prior smokes.
  if ! printf '%s' "$out" | grep -Fq "Core" || ! printf '%s' "$out" | grep -Fq "Host"; then
    echo "FAIL: expected systems_shaped Core Host plan (NATIVE_C implies plan)"
    printf '%s\n' "$out"
    exit 1
  fi
fi
if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_C=1"; then
  echo "FAIL: expected NATIVE_C banner"
  printf '%s\n' "$out"
  exit 1
fi
assert_honesty "$out"
if ! printf '%s' "$out" | grep -Fq "native C emit OK"; then
  echo "FAIL: expected native C emit OK"
  printf '%s\n' "$out"
  exit 1
fi
assert_c_files
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_C must not create .lake/build"
  exit 1
fi
echo "OK: PLAN_ONLY+NATIVE_C wrote Core.c and Host.c"

echo "== A19 Run 2: NATIVE_BUILD + NATIVE_C → skip lake, C present =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_C=1
  unset SLAKE_PLAN_ONLY || true
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_C exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host lean C-output emit"; then
  echo "FAIL: expected skip-lake banner with host lean C-output emit"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native C emit OK"; then
  echo "FAIL: expected native C emit OK under NATIVE_BUILD+NATIVE_C"
  printf '%s\n' "$out"
  exit 1
fi
assert_c_files
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_C must not create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_C skip-lake with C files"

echo "== A19 Run 3: env identity reports NATIVE_C =="
env_out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_C=1
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "SLAKE_NATIVE_C: 1" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_C: 1"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "SLAKE_NATIVE_C_STRICT:" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_C_STRICT status"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "host lean C-output emit subset" <<<"$env_out"; then
  echo "FAIL: env must describe host lean C-output emit subset"
  printf '%s\n' "$env_out"
  exit 1
fi
# Conjunction: NATIVE_BUILD + NATIVE_C must state skip-lake requires C emit.
env_build="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_C=1
  unset SLAKE_PLAN_ONLY || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "NATIVE_BUILD + NATIVE_C" <<<"$env_build"; then
  echo "FAIL: env must document NATIVE_BUILD + NATIVE_C cascade"
  printf '%s\n' "$env_build"
  exit 1
fi
if ! grep -Fq "skip lake only if olean + C emit succeed" <<<"$env_build" \
    && ! grep -Fq "skip lake only if olean + host lean C-output emit succeed" <<<"$env_build"; then
  echo "FAIL: env NATIVE_BUILD+NATIVE_C must state skip-lake requires C emit"
  printf '%s\n' "$env_build"
  exit 1
fi
env_plan="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_C=1
  unset SLAKE_NATIVE_BUILD || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "PLAN_ONLY + NATIVE_C" <<<"$env_plan" \
    && ! grep -Fq "PLAN_ONLY + NATIVE_OLEAN + NATIVE_C" <<<"$env_plan"; then
  echo "FAIL: env must document PLAN_ONLY + NATIVE_C"
  printf '%s\n' "$env_plan"
  exit 1
fi
echo "OK: env reports NATIVE_C"

echo "== A19 Run 4: NATIVE_C_STRICT + missing lean → fail-closed =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_C=1
  export SLAKE_NATIVE_C_STRICT=1
  export LEAN="/nonexistent/lean-a19-missing-$$"
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_C_STRICT with missing lean must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'lean not found|not a real Lean|STRICT|fail-closed'; then
  echo "FAIL: expected lean-missing STRICT diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/Core.c" ]]; then
  echo "FAIL: must not write Core.c when lean missing under STRICT"
  exit 1
fi
echo "OK: NATIVE_C_STRICT + missing lean fail-closed"

echo "== A19 Run 5: NATIVE_BUILD + NATIVE_C + missing lean → fail-closed (no skip-lake) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_C=1
  export LEAN="/nonexistent/lean-a19-missing-$$"
  unset SLAKE_PLAN_ONLY || true
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_C with missing lean must exit nonzero (fail-closed)"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_C must not claim skip-lake"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_C must not lake-delegate to create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_C missing lean fail-closed"

echo "== A19 Run 6: clean wipes .slake-native after C emit (A17) =="
wipe_native
(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_C=1
  unset SLAKE_NATIVE_BUILD || true
  unset LEAN || true
  "$SLAKE_EXE" build >/dev/null 2>&1
)
assert_c_files
(
  cd "$SYSTEMS_PKG"
  "$SLAKE_EXE" clean 2>&1
) >/dev/null
if [[ -d "$SYSTEMS_PKG/.slake-native" ]]; then
  echo "FAIL: slake clean must remove .slake-native (including .c files)"
  exit 1
fi
echo "OK: clean removes C emit products under .slake-native"

echo "== A19 Run 7: missing source soft-skip (Host.lean absent; Core still emits) =="
wipe_native
host_bak=""
if [[ -f "$SYSTEMS_PKG/Host.lean" ]]; then
  host_bak="$SYSTEMS_PKG/Host.lean.a19bak-$$"
  mv "$SYSTEMS_PKG/Host.lean" "$host_bak"
fi
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_C=1
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
# Always restore Host.lean before asserting (trap-like).
if [[ -n "$host_bak" && -f "$host_bak" ]]; then
  mv "$host_bak" "$SYSTEMS_PKG/Host.lean"
fi
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_C with missing Host source must soft-skip (exit 0), got $rc"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'missing source for module Host|skip missing file for Host|warn — missing source for module Host'; then
  echo "FAIL: expected missing-source soft-skip diagnostic for Host"
  printf '%s\n' "$out"
  exit 1
fi
if [[ ! -s "$SYSTEMS_PKG/.slake-native/Core.c" ]]; then
  echo "FAIL: Core.c should still be emitted when only Host source is missing"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/Host.c" ]]; then
  echo "FAIL: Host.c must not be written when Host.lean is missing"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native C emit OK"; then
  echo "FAIL: expected native C emit OK after soft-skipping missing Host"
  printf '%s\n' "$out"
  exit 1
fi
wipe_native
echo "OK: missing source soft-skips Host; Core.c still emitted"

echo "== A19 Run 8: srcdir_shaped nested Foo/Bar.c + -R src =="
if [[ ! -d "$SRCDIR_PKG" ]]; then
  strict_fail "srcdir_shaped fixture missing at $SRCDIR_PKG"
fi
rm -rf "$SRCDIR_PKG/.slake-native" "$SRCDIR_PKG/.lake" 2>/dev/null || true
out=""
rc=0
out="$(
  cd "$SRCDIR_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_C=1
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: srcdir_shaped PLAN_ONLY+NATIVE_C exited $rc"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq ".slake-native/Foo/Bar.c"; then
  echo "FAIL: expected package-relative .slake-native/Foo/Bar.c in C emit argv/banner"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eq -- '-R src'; then
  echo "FAIL: expected -R src for modules resolved under srcDir"
  printf '%s\n' "$out"
  exit 1
fi
if [[ ! -s "$SRCDIR_PKG/.slake-native/Foo/Bar.c" ]]; then
  echo "FAIL: expected non-empty .slake-native/Foo/Bar.c on disk"
  exit 1
fi
if ! grep -Fq 'Lean compiler output' "$SRCDIR_PKG/.slake-native/Foo/Bar.c"; then
  echo "FAIL: Foo/Bar.c missing Lean compiler output marker"
  exit 1
fi
if [[ ! -s "$SRCDIR_PKG/.slake-native/Host.c" ]]; then
  echo "FAIL: expected non-empty .slake-native/Host.c on srcdir_shaped"
  exit 1
fi
if [[ -d "$SRCDIR_PKG/.lake/build" ]]; then
  echo "FAIL: PLAN_ONLY must not create .lake/build on srcdir_shaped C band"
  exit 1
fi
assert_honesty "$out"
rm -rf "$SRCDIR_PKG/.slake-native" 2>/dev/null || true
echo "OK: srcdir_shaped nested Foo/Bar.c + -R src"

# Help token lock for NATIVE_C
help_out="$("$SLAKE_EXE" --help 2>&1 || true)"
if ! grep -Fq 'SLAKE_NATIVE_C=1' <<<"$help_out"; then
  echo "FAIL: --help must list SLAKE_NATIVE_C=1"
  exit 1
fi
if ! grep -Fq 'host lean C-output emit' <<<"$help_out"; then
  echo "FAIL: --help must mention host lean C-output emit"
  exit 1
fi
if ! grep -Fq 'after NATIVE_C' <<<"$help_out"; then
  echo "FAIL: --help GRAPH/SEAL order must mention NATIVE_C"
  exit 1
fi
echo "OK: --help lists NATIVE_C"

wipe_native
echo "PASS: native_c_smoke (A19 host lean C-output emit subset)"
exit 0
