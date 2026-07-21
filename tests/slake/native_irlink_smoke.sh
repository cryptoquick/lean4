#!/usr/bin/env bash
# Smoke: A21 SLAKE_NATIVE_IRLINK=1 host leanc IR shared-lib link of plan-module
# objects + Lean runtime via leanc.
#
# Honesty: host leanc IR shared-lib link subset of plan-module objects + Lean
# runtime via leanc — not freestanding build TCB, not Lake lean_lib shared-object
# TCB, not CLAIMED, not full Lake shared facet. A13 NATIVE_LINK remains a separate
# name-table SO (libslake_native.so). SCORE does **not** run this smoke.
#
# Soft-skip when slake binary, host lean, host cc, or host leanc missing
# (parity-preserving). Hard-fail when STRICT and tools missing, or claim fails
# with tools present.
#
# systems_shaped bands:
#   1) PLAN_ONLY + NATIVE_IRLINK: plan + oleans + C + .o + libslake_ir.so
#   2) NATIVE_BUILD + NATIVE_IRLINK: skip lake; SO present
#   3) env reports NATIVE_IRLINK / STRICT + NATIVE_BUILD/PLAN_ONLY conjunctions
#   4) STRICT + missing LEANC → fail-closed
#   5) NATIVE_BUILD + NATIVE_IRLINK + missing LEANC → fail-closed (no skip-lake)
#   6) non-STRICT missing LEANC → soft-skip (exit 0, no SO)
#   7) Coexistence: NATIVE_IRLINK + NATIVE_LINK → both SOs present
#   8) graph/seal light touch: shared_lib_ir with IRLINK; both fields with LINK
#   9) clean wipes .slake-native (A17)
#  10) help lists NATIVE_IRLINK
#
#   SLAKE_NATIVE_IRLINK_SMOKE_STRICT=1 ./tests/slake/native_irlink_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_IRLINK_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OBJ_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_C_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

LEANC_PROBE="${LEANC:-leanc}"
if ! command -v "$LEANC_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEANC_PROBE" ]]; then
  strict_fail "host leanc not found (set LEANC= or PATH)"
fi

if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi

wipe_native() {
  rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true
}

assert_ir_so() {
  local so="$SYSTEMS_PKG/.slake-native/libslake_ir.so"
  local core_o="$SYSTEMS_PKG/.slake-native/Core.o"
  local host_o="$SYSTEMS_PKG/.slake-native/Host.o"
  for f in "$so" "$core_o" "$host_o"; do
    if [[ ! -f "$f" ]]; then
      echo "FAIL: expected regular file at $f"
      exit 1
    fi
    if [[ ! -s "$f" ]]; then
      echo "FAIL: expected non-empty file at $f"
      exit 1
    fi
  done
}

assert_honesty() {
  local out="$1"
  if ! printf '%s' "$out" | grep -Fq "host leanc IR shared-lib link"; then
    echo "FAIL: expected host leanc IR shared-lib link honesty banner"
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
  # Must not claim Lake lean_lib SO TCB as achieved product without denial.
  if printf '%s' "$out" | grep -Fq "Lake lean_lib shared-object" \
      && ! printf '%s' "$out" | grep -Fq "not Lake lean_lib"; then
    echo "FAIL: overclaim Lake lean_lib without denial"
    exit 1
  fi
}

unset_a21_build_env() {
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset SLAKE_NATIVE_OLEAN_JOBS || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_OBJ_STRICT || true
  unset SLAKE_NATIVE_IRLINK_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN_INCLUDE || true
  unset LEAN_PREFIX || true
  unset LEAN_SYSROOT || true
  unset LEANC || true
}

wipe_native

echo "== A21 Run 1: PLAN_ONLY + NATIVE_IRLINK → plan + oleans + C + .o + libslake_ir.so =="
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
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
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_IRLINK Run 1 exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "Core" || ! printf '%s' "$out" | grep -Fq "Host"; then
  echo "FAIL: expected systems_shaped Core Host plan (NATIVE_IRLINK implies plan)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_IRLINK=1"; then
  echo "FAIL: expected NATIVE_IRLINK banner"
  printf '%s\n' "$out"
  exit 1
fi
assert_honesty "$out"
if ! printf '%s' "$out" | grep -Fq "native IR link OK"; then
  echo "FAIL: expected native IR link OK"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native object compile OK"; then
  echo "FAIL: expected native object compile OK (IRLINK implies OBJ)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native C emit OK"; then
  echo "FAIL: expected native C emit OK (IRLINK implies C)"
  printf '%s\n' "$out"
  exit 1
fi
assert_ir_so
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_IRLINK must not create .lake/build"
  exit 1
fi
echo "OK: PLAN_ONLY+NATIVE_IRLINK wrote libslake_ir.so (and .o files)"

echo "== A21 Run 2: NATIVE_BUILD + NATIVE_IRLINK → skip lake, SO present =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_PLAN_ONLY || true
  unset_a21_build_env
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_IRLINK exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host lean C-output emit + host object compile + host leanc IR shared-lib link"; then
  echo "FAIL: expected skip-lake banner with host leanc IR shared-lib link"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native IR link OK"; then
  echo "FAIL: expected native IR link OK under NATIVE_BUILD+NATIVE_IRLINK"
  printf '%s\n' "$out"
  exit 1
fi
assert_ir_so
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_IRLINK must not create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_IRLINK skip-lake with libslake_ir.so"

echo "== A21 Run 3: env identity reports NATIVE_IRLINK =="
env_out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_IRLINK=1
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "SLAKE_NATIVE_IRLINK: 1" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_IRLINK: 1"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "SLAKE_NATIVE_IRLINK_STRICT:" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_IRLINK_STRICT status"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "host leanc IR shared-lib link" <<<"$env_out"; then
  echo "FAIL: env must describe host leanc IR shared-lib link subset"
  printf '%s\n' "$env_out"
  exit 1
fi
env_build="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_PLAN_ONLY || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "NATIVE_BUILD + NATIVE_IRLINK" <<<"$env_build"; then
  echo "FAIL: env must document NATIVE_BUILD + NATIVE_IRLINK cascade"
  printf '%s\n' "$env_build"
  exit 1
fi
if ! grep -Fq "skip lake only if olean + C emit + object compile + IR link succeed" <<<"$env_build" \
    && ! grep -Fq "skip lake only if olean + host lean C-output emit + host object compile + host leanc IR shared-lib link succeed" <<<"$env_build"; then
  echo "FAIL: env NATIVE_BUILD+NATIVE_IRLINK must state skip-lake requires IR link"
  printf '%s\n' "$env_build"
  exit 1
fi
env_plan="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_NATIVE_BUILD || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "PLAN_ONLY + NATIVE_IRLINK" <<<"$env_plan" \
    && ! grep -Fq "PLAN_ONLY + NATIVE_OLEAN + NATIVE_IRLINK" <<<"$env_plan"; then
  echo "FAIL: env must document PLAN_ONLY + NATIVE_IRLINK"
  printf '%s\n' "$env_plan"
  exit 1
fi
echo "OK: env reports NATIVE_IRLINK"

echo "== A21 Run 4: NATIVE_IRLINK_STRICT + missing LEANC → fail-closed =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  export LEANC="/nonexistent/leanc-a21-missing-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a21_build_env
  export SLAKE_NATIVE_IRLINK_STRICT=1
  export LEANC="/nonexistent/leanc-a21-missing-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_IRLINK_STRICT with missing leanc must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'leanc not found|not usable|STRICT|fail-closed'; then
  echo "FAIL: expected leanc-missing STRICT diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
  echo "FAIL: must not write libslake_ir.so when leanc missing under STRICT"
  exit 1
fi
echo "OK: NATIVE_IRLINK_STRICT + missing LEANC fail-closed"

echo "== A21 Run 5: NATIVE_BUILD + NATIVE_IRLINK + missing LEANC → fail-closed (no skip-lake) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_IRLINK=1
  export LEANC="/nonexistent/leanc-a21-build-missing-$$"
  unset SLAKE_PLAN_ONLY || true
  unset_a21_build_env
  export LEANC="/nonexistent/leanc-a21-build-missing-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_IRLINK with missing leanc must exit nonzero (fail-closed)"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_IRLINK must not claim skip-lake"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_IRLINK must not lake-delegate to create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_IRLINK missing LEANC fail-closed"

echo "== A21 Run 6: non-STRICT missing LEANC → soft-skip (exit 0, no SO) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  export LEANC="/nonexistent/leanc-a21-soft-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a21_build_env
  export LEANC="/nonexistent/leanc-a21-soft-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: non-STRICT missing LEANC must soft-skip (exit 0), got $rc"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'leanc not found|not usable|skipping host leanc IR shared-lib link'; then
  echo "FAIL: expected soft-skip warn for missing leanc"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "native IR link OK"; then
  echo "FAIL: soft-skip must not claim native IR link OK"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
  echo "FAIL: soft-skip must not write libslake_ir.so when leanc missing"
  exit 1
fi
echo "OK: non-STRICT missing LEANC soft-skips IR link"

echo "== A21 Run 7: coexistence NATIVE_IRLINK + NATIVE_LINK → both SOs =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_NATIVE_BUILD || true
  unset_a21_build_env
  # Re-export after unset_a21_build_env (it clears NATIVE_LINK among others).
  export SLAKE_NATIVE_LINK=1
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_IRLINK+NATIVE_LINK exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
assert_ir_so
if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]]; then
  echo "FAIL: expected non-empty libslake_native.so alongside libslake_ir.so"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native IR link OK"; then
  echo "FAIL: expected native IR link OK under coexistence"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native link OK"; then
  echo "FAIL: expected native link OK (name-table) under coexistence"
  printf '%s\n' "$out"
  exit 1
fi
echo "OK: both libslake_ir.so and libslake_native.so coexist"

echo "== A21 Run 8a: PLAN_ONLY + IRLINK + GRAPH → shared_lib_ir; no A13 shared_lib =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_NATIVE_BUILD || true
  unset_a21_build_env
  export SLAKE_NATIVE_GRAPH=1
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+IRLINK+GRAPH exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
assert_ir_so
graph_path="$SYSTEMS_PKG/.slake-native/slake_native_graph"
if [[ ! -f "$graph_path" ]]; then
  echo "FAIL: expected slake_native_graph after NATIVE_GRAPH"
  exit 1
fi
if ! grep -Eq '^shared_lib_ir \.slake-native/libslake_ir\.so$' "$graph_path"; then
  echo "FAIL: graph must list shared_lib_ir after NATIVE_IRLINK"
  cat "$graph_path"
  exit 1
fi
# A13 field only — line-anchored so shared_lib_ir does not false-match.
if grep -Eq '^shared_lib ' "$graph_path"; then
  echo "FAIL: graph must not list A13 shared_lib without NATIVE_LINK"
  cat "$graph_path"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native graph OK"; then
  echo "FAIL: expected native graph OK under IRLINK+GRAPH"
  printf '%s\n' "$out"
  exit 1
fi
echo "OK: graph lists shared_lib_ir; A13 shared_lib absent without LINK"

echo "== A21 Run 8b: PLAN_ONLY + IRLINK + LINK + GRAPH + SEAL → both SO fields =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_IRLINK=1
  unset SLAKE_NATIVE_BUILD || true
  unset_a21_build_env
  export SLAKE_NATIVE_LINK=1
  export SLAKE_NATIVE_GRAPH=1
  export SLAKE_NATIVE_SEAL=1
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+IRLINK+LINK+GRAPH+SEAL exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
assert_ir_so
if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]]; then
  echo "FAIL: expected non-empty libslake_native.so under coexistence+graph/seal"
  exit 1
fi
graph_path="$SYSTEMS_PKG/.slake-native/slake_native_graph"
seal_path="$SYSTEMS_PKG/.slake-native/slake_native_seal"
if [[ ! -f "$graph_path" || ! -f "$seal_path" ]]; then
  echo "FAIL: expected graph and seal artifacts"
  exit 1
fi
if ! grep -Eq '^shared_lib_ir \.slake-native/libslake_ir\.so$' "$graph_path"; then
  echo "FAIL: graph must list shared_lib_ir with IRLINK+LINK"
  cat "$graph_path"
  exit 1
fi
if ! grep -Eq '^shared_lib \.slake-native/libslake_native\.so$' "$graph_path"; then
  echo "FAIL: graph must list A13 shared_lib with NATIVE_LINK"
  cat "$graph_path"
  exit 1
fi
if ! grep -Eq '^shared_lib_ir \.slake-native/libslake_ir\.so$' "$seal_path"; then
  echo "FAIL: seal must list shared_lib_ir with IRLINK"
  cat "$seal_path"
  exit 1
fi
if ! grep -Eq '^shared_lib \.slake-native/libslake_native\.so$' "$seal_path"; then
  echo "FAIL: seal must list A13 shared_lib with NATIVE_LINK"
  cat "$seal_path"
  exit 1
fi
if ! grep -Eq '^graph_hash ' "$seal_path"; then
  echo "FAIL: seal must list graph_hash when GRAPH ran before SEAL"
  cat "$seal_path"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native seal OK"; then
  echo "FAIL: expected native seal OK under IRLINK+LINK+GRAPH+SEAL"
  printf '%s\n' "$out"
  exit 1
fi
echo "OK: graph/seal list both shared_lib and shared_lib_ir"

echo "== A21 Run 9: clean wipes .slake-native (A17) =="
# Leave artifacts from Run 8b, then clean.
if [[ ! -d "$SYSTEMS_PKG/.slake-native" ]]; then
  echo "FAIL: expected .slake-native before clean"
  exit 1
fi
clean_out=""
clean_rc=0
clean_out="$(
  cd "$SYSTEMS_PKG"
  unset SLAKE_PLAN_ONLY || true
  unset SLAKE_NATIVE_BUILD || true
  unset_a21_build_env
  "$SLAKE_EXE" clean 2>&1
)" || clean_rc=$?
if [[ "$clean_rc" -ne 0 ]]; then
  echo "FAIL: slake clean exited $clean_rc"
  printf '%s\n' "$clean_out"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.slake-native" ]]; then
  echo "FAIL: clean must wipe .slake-native (A17)"
  exit 1
fi
echo "OK: clean wiped .slake-native"

echo "== A21 Run 10: help lists NATIVE_IRLINK =="
# Redirect to a file (not bash var + printf|grep): large UTF-8 usage text is flaky
# under command-substitution + pipe grep on some hosts after long smoke runs.
help_file="$(mktemp "${TMPDIR:-/tmp}/slake-irlink-help.XXXXXX")"
"$SLAKE_EXE" --help >"$help_file" 2>&1 || true
if ! grep -Fq "SLAKE_NATIVE_IRLINK" "$help_file"; then
  echo "FAIL: --help must list SLAKE_NATIVE_IRLINK"
  head -80 "$help_file" || true
  rm -f "$help_file"
  exit 1
fi
if ! grep -Fq "libslake_ir.so" "$help_file"; then
  echo "FAIL: --help must mention libslake_ir.so"
  rm -f "$help_file"
  exit 1
fi
if ! grep -Fq "host leanc IR shared-lib link" "$help_file"; then
  echo "FAIL: --help must describe host leanc IR shared-lib link"
  rm -f "$help_file"
  exit 1
fi
rm -f "$help_file"
echo "OK: help lists NATIVE_IRLINK"

echo "OK: native_irlink_smoke (A21) all bands passed"
