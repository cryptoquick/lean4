#!/usr/bin/env bash
# Smoke: A20 SLAKE_NATIVE_OBJ=1 host object compile of lean C after native C emit.
#
# Honesty: host object compile of lean C subset — not freestanding build TCB, not
# Lake lean_lib shared-object of compiled Lean IR, not linking Lean runtime into
# SO, not CLAIMED expansion. A13 NATIVE_LINK remains name-table shared-lib (not
# IR link of these .o files). SCORE does **not** run this smoke.
#
# Soft-skip when slake binary, host lean, or host cc missing (parity-preserving).
# Hard-fail when STRICT and binary/lean/cc missing, or claim fails with tools present.
#
# systems_shaped bands:
#   1) PLAN_ONLY + NATIVE_OBJ: plan + oleans + Core.c/Host.c + Core.o/Host.o
#   2) NATIVE_BUILD + NATIVE_OBJ: skip lake; .o present
#   3) env reports NATIVE_OBJ / STRICT + NATIVE_BUILD/PLAN_ONLY conjunctions
#   4) STRICT + missing CC → fail-closed
#   5) NATIVE_BUILD + NATIVE_OBJ + missing CC → fail-closed (no skip-lake)
#   6) STRICT + bad LEAN_INCLUDE → fail-closed (no silent fallthrough)
#   7) NATIVE_BUILD + bad LEAN_INCLUDE → fail-closed (no skip-lake)
#   8) non-STRICT missing CC → soft-skip (exit 0, no Core.o)
#   9) non-STRICT include unresolvable → soft-skip (exit 0, no Core.o)
#  10) empty .o after fake cc success → always fail-closed
#  11) srcdir_shaped nested Foo/Bar.o (after C)
#  12) clean wipes .slake-native (A17)
#  13) help lists NATIVE_OBJ
#
#   SLAKE_NATIVE_OBJ_SMOKE_STRICT=1 ./tests/slake/native_obj_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
SRCDIR_PKG="$ROOT/srcdir_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_OBJ_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_C_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

CC_PROBE="${CC:-cc}"
if ! command -v "$CC_PROBE" >/dev/null 2>&1 && [[ ! -x "$CC_PROBE" ]]; then
  strict_fail "host cc not found (set CC= or PATH)"
fi

if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi

wipe_native() {
  rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true
}

assert_c_and_o_files() {
  local core_c="$SYSTEMS_PKG/.slake-native/Core.c"
  local host_c="$SYSTEMS_PKG/.slake-native/Host.c"
  local core_o="$SYSTEMS_PKG/.slake-native/Core.o"
  local host_o="$SYSTEMS_PKG/.slake-native/Host.o"
  for f in "$core_c" "$host_c" "$core_o" "$host_o"; do
    if [[ ! -f "$f" ]]; then
      echo "FAIL: expected regular file at $f"
      exit 1
    fi
    if [[ ! -s "$f" ]]; then
      echo "FAIL: expected non-empty file at $f"
      exit 1
    fi
  done
  if ! grep -Fq 'Lean compiler output' "$core_c"; then
    echo "FAIL: Core.c missing Lean compiler output marker"
    exit 1
  fi
  if ! grep -Fq 'Lean compiler output' "$host_c"; then
    echo "FAIL: Host.c missing Lean compiler output marker"
    exit 1
  fi
}

assert_honesty() {
  local out="$1"
  if ! printf '%s' "$out" | grep -Fq "host object compile of lean C"; then
    echo "FAIL: expected host object compile of lean C honesty banner"
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
  if ! printf '%s' "$out" | grep -Fq "not linking Lean runtime"; then
    echo "FAIL: expected not linking Lean runtime denial"
    exit 1
  fi
  # Must not claim Lake lean_lib SO of compiled Lean IR as achieved product.
  if printf '%s' "$out" | grep -Fq "Lake lean_lib shared-object of compiled Lean IR" \
      && ! printf '%s' "$out" | grep -Fq "not Lake lean_lib"; then
    echo "FAIL: overclaim Lake lean_lib without denial"
    exit 1
  fi
}

# Full unset block for build bands (avoid inherited STRICT/FORCE/JOBS pollution).
unset_a20_build_env() {
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset SLAKE_NATIVE_OLEAN_JOBS || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_OBJ_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN_INCLUDE || true
  unset LEAN_PREFIX || true
  unset LEAN_SYSROOT || true
}

wipe_native

echo "== A20 Run 1: PLAN_ONLY + NATIVE_OBJ → plan + oleans + C + .o =="
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_OBJ_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_OBJ Run 1 exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "Core" || ! printf '%s' "$out" | grep -Fq "Host"; then
  echo "FAIL: expected systems_shaped Core Host plan (NATIVE_OBJ implies plan)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_OBJ=1"; then
  echo "FAIL: expected NATIVE_OBJ banner"
  printf '%s\n' "$out"
  exit 1
fi
assert_honesty "$out"
if ! printf '%s' "$out" | grep -Fq "native object compile OK"; then
  echo "FAIL: expected native object compile OK"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native C emit OK"; then
  echo "FAIL: expected native C emit OK (NATIVE_OBJ implies NATIVE_C)"
  printf '%s\n' "$out"
  exit 1
fi
assert_c_and_o_files
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_OBJ must not create .lake/build"
  exit 1
fi
echo "OK: PLAN_ONLY+NATIVE_OBJ wrote Core.o and Host.o (and C files)"

echo "== A20 Run 2: NATIVE_BUILD + NATIVE_OBJ → skip lake, .o present =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_OBJ=1
  unset SLAKE_PLAN_ONLY || true
  unset_a20_build_env
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_OBJ exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host lean C-output emit + host object compile"; then
  echo "FAIL: expected skip-lake banner with host object compile"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native object compile OK"; then
  echo "FAIL: expected native object compile OK under NATIVE_BUILD+NATIVE_OBJ"
  printf '%s\n' "$out"
  exit 1
fi
assert_c_and_o_files
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_OBJ must not create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_OBJ skip-lake with .o files"

echo "== A20 Run 3: env identity reports NATIVE_OBJ =="
env_out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_OBJ=1
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "SLAKE_NATIVE_OBJ: 1" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_OBJ: 1"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "SLAKE_NATIVE_OBJ_STRICT:" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_OBJ_STRICT status"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "host object compile of lean C" <<<"$env_out"; then
  echo "FAIL: env must describe host object compile of lean C subset"
  printf '%s\n' "$env_out"
  exit 1
fi
env_build="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_OBJ=1
  unset SLAKE_PLAN_ONLY || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "NATIVE_BUILD + NATIVE_OBJ" <<<"$env_build"; then
  echo "FAIL: env must document NATIVE_BUILD + NATIVE_OBJ cascade"
  printf '%s\n' "$env_build"
  exit 1
fi
if ! grep -Fq "skip lake only if olean + C emit + object compile succeed" <<<"$env_build" \
    && ! grep -Fq "skip lake only if olean + host lean C-output emit + host object compile succeed" <<<"$env_build"; then
  echo "FAIL: env NATIVE_BUILD+NATIVE_OBJ must state skip-lake requires object compile"
  printf '%s\n' "$env_build"
  exit 1
fi
env_plan="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  unset SLAKE_NATIVE_BUILD || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "PLAN_ONLY + NATIVE_OBJ" <<<"$env_plan" \
    && ! grep -Fq "PLAN_ONLY + NATIVE_OLEAN + NATIVE_OBJ" <<<"$env_plan"; then
  echo "FAIL: env must document PLAN_ONLY + NATIVE_OBJ"
  printf '%s\n' "$env_plan"
  exit 1
fi
echo "OK: env reports NATIVE_OBJ"

echo "== A20 Run 4: NATIVE_OBJ_STRICT + missing cc → fail-closed =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export CC="/nonexistent/cc-a20-missing-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a20_build_env
  export SLAKE_NATIVE_OBJ_STRICT=1
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_OBJ_STRICT with missing cc must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'cc not found|not usable|STRICT|fail-closed'; then
  echo "FAIL: expected cc-missing STRICT diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/Core.o" ]]; then
  echo "FAIL: must not write Core.o when cc missing under STRICT"
  exit 1
fi
echo "OK: NATIVE_OBJ_STRICT + missing cc fail-closed"

echo "== A20 Run 5: NATIVE_BUILD + NATIVE_OBJ + missing cc → fail-closed (no skip-lake) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_OBJ=1
  export CC="/nonexistent/cc-a20-missing-$$"
  unset SLAKE_PLAN_ONLY || true
  unset_a20_build_env
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_OBJ with missing cc must exit nonzero (fail-closed)"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_OBJ must not claim skip-lake"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_OBJ must not lake-delegate to create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_OBJ missing cc fail-closed"

echo "== A20 Run 6: NATIVE_OBJ_STRICT + bad LEAN_INCLUDE → fail-closed (no fallthrough) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export SLAKE_NATIVE_OBJ_STRICT=1
  export LEAN_INCLUDE="/nonexistent/lean-include-a20-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a20_build_env
  # Re-set STRICT after helper unsets it.
  export SLAKE_NATIVE_OBJ_STRICT=1
  export LEAN_INCLUDE="/nonexistent/lean-include-a20-$$"
  unset LEAN_PREFIX || true
  unset LEAN_SYSROOT || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_OBJ_STRICT with bad LEAN_INCLUDE must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'LEAN_INCLUDE set but not a directory|include dir not found|fail-closed|STRICT'; then
  echo "FAIL: expected bad-LEAN_INCLUDE STRICT diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/Core.o" ]]; then
  echo "FAIL: must not write Core.o when LEAN_INCLUDE bad under STRICT"
  exit 1
fi
echo "OK: NATIVE_OBJ_STRICT + bad LEAN_INCLUDE fail-closed"

echo "== A20 Run 7: NATIVE_BUILD + NATIVE_OBJ + bad LEAN_INCLUDE → fail-closed (no skip-lake) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_OBJ=1
  export LEAN_INCLUDE="/nonexistent/lean-include-a20-build-$$"
  unset SLAKE_PLAN_ONLY || true
  unset_a20_build_env
  export LEAN_INCLUDE="/nonexistent/lean-include-a20-build-$$"
  unset LEAN_PREFIX || true
  unset LEAN_SYSROOT || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_OBJ with bad LEAN_INCLUDE must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
  echo "FAIL: fail-closed bad LEAN_INCLUDE must not claim skip-lake"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'LEAN_INCLUDE set but not a directory|include dir not found|fail-closed'; then
  echo "FAIL: expected bad-LEAN_INCLUDE NATIVE_BUILD diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: fail-closed bad LEAN_INCLUDE must not lake-delegate"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_OBJ bad LEAN_INCLUDE fail-closed"

echo "== A20 Run 8: non-STRICT missing cc → soft-skip (exit 0, no Core.o) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export CC="/nonexistent/cc-a20-soft-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a20_build_env
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: non-STRICT missing cc must soft-skip (exit 0), got $rc"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'cc not found|not usable.*skipping host object compile|skipping host object compile of lean C'; then
  echo "FAIL: expected missing-cc soft-skip diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/Core.o" ]]; then
  echo "FAIL: soft-skip missing cc must not write Core.o"
  exit 1
fi
# C emit should still have succeeded (obj is the only soft-skip).
if [[ ! -s "$SYSTEMS_PKG/.slake-native/Core.c" ]]; then
  echo "FAIL: expected Core.c from C emit even when object compile soft-skips"
  exit 1
fi
echo "OK: non-STRICT missing cc soft-skips object compile"

echo "== A20 Run 9: non-STRICT include unresolvable → soft-skip (exit 0, no Core.o) =="
wipe_native
# Real lean for olean/C; --print-prefix fails so include resolution yields none.
REAL_LEAN="$(command -v "${LEAN:-lean}" || true)"
if [[ -z "$REAL_LEAN" || ! -x "$REAL_LEAN" ]]; then
  strict_fail "host lean not found for include soft-skip band"
fi
FAKE_LEAN="$(mktemp "${TMPDIR:-/tmp}/a20-fake-lean.XXXXXX")"
cat > "$FAKE_LEAN" <<EOF
#!/usr/bin/env bash
if [[ "\${1:-}" == "--print-prefix" ]]; then
  exit 1
fi
exec "$REAL_LEAN" "\$@"
EOF
chmod +x "$FAKE_LEAN"
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export LEAN="$FAKE_LEAN"
  unset SLAKE_NATIVE_BUILD || true
  unset_a20_build_env
  unset LEAN_INCLUDE || true
  unset LEAN_PREFIX || true
  unset LEAN_SYSROOT || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
rm -f "$FAKE_LEAN"

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: non-STRICT unresolvable include must soft-skip (exit 0), got $rc"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'Lean include dir not found|include dir not found.*skipping|skipping host object compile of lean C'; then
  echo "FAIL: expected include soft-skip diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/Core.o" ]]; then
  echo "FAIL: soft-skip missing include must not write Core.o"
  exit 1
fi
echo "OK: non-STRICT unresolvable include soft-skips object compile"

echo "== A20 Run 10: empty .o after fake cc success → always fail-closed =="
wipe_native
FAKE_CC="$(mktemp "${TMPDIR:-/tmp}/a20-fake-cc.XXXXXX")"
cat > "$FAKE_CC" <<'EOF'
#!/usr/bin/env bash
# Pass resolveCcCmd --version probe (gcc marker), then succeed with empty -o
# to lock empty-object fail-closed after "successful" cc.
if [[ "${1:-}" == "--version" ]]; then
  echo "gcc (A20 empty-object probe) 0.0.0"
  exit 0
fi
out=""
while [[ $# -gt 0 ]]; do
  if [[ "$1" == "-o" ]]; then
    out="${2:-}"
    shift 2
    continue
  fi
  shift
done
if [[ -n "$out" ]]; then
  : > "$out"
  exit 0
fi
exit 1
EOF
chmod +x "$FAKE_CC"
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  export CC="$FAKE_CC"
  unset SLAKE_NATIVE_BUILD || true
  unset_a20_build_env
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
rm -f "$FAKE_CC"

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: empty .o after cc success must exit nonzero (always fail-closed)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'empty or non-file object|native object compile empty'; then
  echo "FAIL: expected empty-object diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
echo "OK: empty .o after fake cc always fail-closed"

echo "== A20 Run 11: srcdir_shaped nested Foo/Bar.o + C =="
if [[ ! -d "$SRCDIR_PKG" ]]; then
  strict_fail "srcdir_shaped fixture missing at $SRCDIR_PKG"
fi
rm -rf "$SRCDIR_PKG/.slake-native" "$SRCDIR_PKG/.lake" 2>/dev/null || true
out=""
rc=0
out="$(
  cd "$SRCDIR_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  unset SLAKE_NATIVE_OBJ_STRICT || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: srcdir_shaped PLAN_ONLY+NATIVE_OBJ exited $rc"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq ".slake-native/Foo/Bar.o"; then
  echo "FAIL: expected package-relative .slake-native/Foo/Bar.o in object compile argv/banner"
  printf '%s\n' "$out"
  exit 1
fi
if [[ ! -s "$SRCDIR_PKG/.slake-native/Foo/Bar.c" ]]; then
  echo "FAIL: expected non-empty .slake-native/Foo/Bar.c on disk"
  exit 1
fi
if [[ ! -s "$SRCDIR_PKG/.slake-native/Foo/Bar.o" ]]; then
  echo "FAIL: expected non-empty .slake-native/Foo/Bar.o on disk"
  exit 1
fi
if [[ ! -s "$SRCDIR_PKG/.slake-native/Host.o" ]]; then
  echo "FAIL: expected non-empty .slake-native/Host.o on srcdir_shaped"
  exit 1
fi
if [[ -d "$SRCDIR_PKG/.lake/build" ]]; then
  echo "FAIL: PLAN_ONLY must not create .lake/build on srcdir_shaped OBJ band"
  exit 1
fi
assert_honesty "$out"
rm -rf "$SRCDIR_PKG/.slake-native" 2>/dev/null || true
echo "OK: srcdir_shaped nested Foo/Bar.o after C"

echo "== A20 Run 12: clean wipes .slake-native after object compile (A17) =="
wipe_native
(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OBJ=1
  unset SLAKE_NATIVE_BUILD || true
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build >/dev/null 2>&1
)
assert_c_and_o_files
(
  cd "$SYSTEMS_PKG"
  "$SLAKE_EXE" clean 2>&1
) >/dev/null
if [[ -d "$SYSTEMS_PKG/.slake-native" ]]; then
  echo "FAIL: slake clean must remove .slake-native (including .o files)"
  exit 1
fi
echo "OK: clean removes object compile products under .slake-native"

# Help token lock for NATIVE_OBJ
help_out="$("$SLAKE_EXE" --help 2>&1 || true)"
if ! grep -Fq 'SLAKE_NATIVE_OBJ=1' <<<"$help_out"; then
  echo "FAIL: --help must list SLAKE_NATIVE_OBJ=1"
  exit 1
fi
if ! grep -Fq 'host object compile of lean C' <<<"$help_out"; then
  echo "FAIL: --help must mention host object compile of lean C"
  exit 1
fi
if ! grep -Fq 'obj → link' <<<"$help_out" && ! grep -Fq 'C emit → obj' <<<"$help_out"; then
  echo "FAIL: --help order must mention obj after C emit"
  exit 1
fi
echo "OK: --help lists NATIVE_OBJ"

wipe_native
echo "PASS: native_obj_smoke (A20 host object compile of lean C subset)"
exit 0
