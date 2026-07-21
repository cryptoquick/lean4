#!/usr/bin/env bash
# Smoke: A23 SLAKE_NATIVE_EXE=1 host leanc executable link of plan-module objects
# + stub main + Lean runtime via leanc.
#
# Honesty: host leanc executable link subset of plan-module objects + stub main +
# Lean runtime via leanc — not freestanding build TCB, not Lake lean_exe, not
# CLAIMED, not a real application entry from lakefile (generated stub main).
# A13 NATIVE_LINK remains name-table SO (libslake_native.so). A21 NATIVE_IRLINK
# remains leanc IR SO (libslake_ir.so). A22 NATIVE_AR remains static archive
# (libslake_ir.a). SCORE does **not** run this smoke.
#
# Soft-skip when slake binary, host lean, host cc, or host leanc missing
# (parity-preserving). Hard-fail when STRICT and tools missing, or claim fails
# with tools present.
#
# systems_shaped bands:
#   1) PLAN_ONLY + NATIVE_EXE: plan + oleans + C + .o + slake_ir (executable)
#   2) NATIVE_BUILD + NATIVE_EXE: skip lake; binary present
#   3) env reports NATIVE_EXE / STRICT + NATIVE_BUILD/PLAN_ONLY conjunctions
#   4) STRICT + missing LEANC → fail-closed
#   5) NATIVE_BUILD + NATIVE_EXE + missing LEANC → fail-closed (no skip-lake)
#   6) non-STRICT missing LEANC → soft-skip (exit 0, no binary)
#   6b) STRICT + probe-passing stub leanc that fails on real link → fail-closed
#   7) Coexistence: NATIVE_EXE + NATIVE_IRLINK + NATIVE_AR (+ optional LINK)
#   8) graph/seal light touch: executable with EXE; multi-product with IRLINK/AR/LINK
#   9) clean wipes .slake-native (A17)
#  10) help lists NATIVE_EXE + honesty phrase
#
#   SLAKE_NATIVE_EXE_SMOKE_STRICT=1 ./tests/slake/native_exe_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_EXE_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_AR_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_IRLINK_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OBJ_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_C_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

assert_slake_ir() {
  local bin="$SYSTEMS_PKG/.slake-native/slake_ir"
  local core_o="$SYSTEMS_PKG/.slake-native/Core.o"
  local host_o="$SYSTEMS_PKG/.slake-native/Host.o"
  local main_c="$SYSTEMS_PKG/.slake-native/slake_native_main.c"
  for f in "$bin" "$core_o" "$host_o" "$main_c"; do
    if [[ ! -f "$f" ]]; then
      echo "FAIL: expected regular file at $f"
      exit 1
    fi
    if [[ ! -s "$f" ]]; then
      echo "FAIL: expected non-empty file at $f"
      exit 1
    fi
  done
  # Prefer executable bit on the binary (host leanc should set it).
  if [[ ! -x "$bin" ]]; then
    echo "FAIL: expected executable bit on $bin"
    exit 1
  fi
  # Optional run: stub main returns 0.
  if ! ( cd "$SYSTEMS_PKG" && ./.slake-native/slake_ir ); then
    echo "FAIL: .slake-native/slake_ir did not exit 0"
    exit 1
  fi
}

assert_honesty() {
  local out="$1"
  if ! printf '%s' "$out" | grep -Fq "host leanc executable link subset of plan-module objects"; then
    echo "FAIL: expected host leanc executable link subset of plan-module objects honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "stub main"; then
    echo "FAIL: expected stub main honesty"
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
  if ! printf '%s' "$out" | grep -Fq "not Lake lean_exe"; then
    echo "FAIL: expected not Lake lean_exe denial"
    exit 1
  fi
  # Must not claim freestanding build TCB as achieved.
  if printf '%s' "$out" | grep -Fq "freestanding build TCB" \
      && ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
    echo "FAIL: freestanding build TCB mentioned without denial"
    exit 1
  fi
}

unset_a23_build_env() {
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
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_IRLINK_STRICT || true
  unset SLAKE_NATIVE_AR || true
  unset SLAKE_NATIVE_AR_STRICT || true
  unset SLAKE_NATIVE_EXE_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN_INCLUDE || true
  unset LEAN_PREFIX || true
  unset LEAN_SYSROOT || true
  unset LEANC || true
  unset AR || true
}

wipe_native

echo "== A23 Run 1: PLAN_ONLY + NATIVE_EXE → plan + oleans + C + .o + slake_ir =="
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_EXE=1
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
  unset SLAKE_NATIVE_EXE_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_EXE Run 1 exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "Core" || ! printf '%s' "$out" | grep -Fq "Host"; then
  echo "FAIL: expected systems_shaped Core Host plan (NATIVE_EXE implies plan)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_EXE=1"; then
  echo "FAIL: expected NATIVE_EXE banner"
  printf '%s\n' "$out"
  exit 1
fi
assert_honesty "$out"
if ! printf '%s' "$out" | grep -Fq "native executable link OK"; then
  echo "FAIL: expected native executable link OK"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native object compile OK"; then
  echo "FAIL: expected native object compile OK (EXE implies OBJ)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native C emit OK"; then
  echo "FAIL: expected native C emit OK (EXE implies C)"
  printf '%s\n' "$out"
  exit 1
fi
# EXE alone must NOT run IRLINK or AR.
if printf '%s' "$out" | grep -Fq "native IR link OK"; then
  echo "FAIL: NATIVE_EXE alone must not run IRLINK"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "native static archive OK"; then
  echo "FAIL: NATIVE_EXE alone must not run AR"
  printf '%s\n' "$out"
  exit 1
fi
assert_slake_ir
if [[ -f "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
  echo "FAIL: NATIVE_EXE alone must not write libslake_ir.so"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]]; then
  echo "FAIL: NATIVE_EXE alone must not write libslake_ir.a"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_EXE must not create .lake/build"
  exit 1
fi
echo "OK: PLAN_ONLY+NATIVE_EXE wrote slake_ir (and .o files)"

echo "== A23 Run 2: NATIVE_BUILD + NATIVE_EXE → skip lake, binary present =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_EXE=1
  unset SLAKE_PLAN_ONLY || true
  unset_a23_build_env
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_EXE exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host lean C-output emit + host object compile + host leanc executable link"; then
  echo "FAIL: expected skip-lake banner with host leanc executable link"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native executable link OK"; then
  echo "FAIL: expected native executable link OK under NATIVE_BUILD+NATIVE_EXE"
  printf '%s\n' "$out"
  exit 1
fi
assert_slake_ir
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_EXE must not create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_EXE skip-lake with slake_ir"

echo "== A23 Run 3: env identity reports NATIVE_EXE =="
env_out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_EXE=1
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "SLAKE_NATIVE_EXE: 1" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_EXE: 1"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "SLAKE_NATIVE_EXE_STRICT:" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_EXE_STRICT status"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "host leanc executable link subset of plan-module objects" <<<"$env_out"; then
  echo "FAIL: env must describe host leanc executable link subset of plan-module objects"
  printf '%s\n' "$env_out"
  exit 1
fi
env_build="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_EXE=1
  unset SLAKE_PLAN_ONLY || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "NATIVE_BUILD + NATIVE_EXE" <<<"$env_build"; then
  echo "FAIL: env must document NATIVE_BUILD + NATIVE_EXE cascade"
  printf '%s\n' "$env_build"
  exit 1
fi
if ! grep -Fq "skip lake only if olean + C emit + object compile + executable link succeed" <<<"$env_build" \
    && ! grep -Fq "skip lake only if olean + host lean C-output emit + host object compile + host leanc executable link succeed" <<<"$env_build"; then
  echo "FAIL: env NATIVE_BUILD+NATIVE_EXE must state skip-lake requires executable link"
  printf '%s\n' "$env_build"
  exit 1
fi
env_plan="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_EXE=1
  unset SLAKE_NATIVE_BUILD || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "PLAN_ONLY + NATIVE_EXE" <<<"$env_plan" \
    && ! grep -Fq "PLAN_ONLY + NATIVE_OLEAN + NATIVE_EXE" <<<"$env_plan"; then
  echo "FAIL: env must document PLAN_ONLY + NATIVE_EXE"
  printf '%s\n' "$env_plan"
  exit 1
fi
echo "OK: env reports NATIVE_EXE"

echo "== A23 Run 4: NATIVE_EXE_STRICT + missing LEANC → fail-closed =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_EXE=1
  export LEANC="/nonexistent/leanc-a23-missing-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a23_build_env
  export SLAKE_NATIVE_EXE_STRICT=1
  export LEANC="/nonexistent/leanc-a23-missing-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_EXE_STRICT with missing leanc must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'leanc not found|not usable|STRICT|fail-closed'; then
  echo "FAIL: expected leanc-missing STRICT diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/slake_ir" ]]; then
  echo "FAIL: must not write slake_ir when leanc missing under STRICT"
  exit 1
fi
echo "OK: NATIVE_EXE_STRICT + missing LEANC fail-closed"

echo "== A23 Run 5: NATIVE_BUILD + NATIVE_EXE + missing LEANC → fail-closed (no skip-lake) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_EXE=1
  export LEANC="/nonexistent/leanc-a23-build-missing-$$"
  unset SLAKE_PLAN_ONLY || true
  unset_a23_build_env
  export LEANC="/nonexistent/leanc-a23-build-missing-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_EXE with missing leanc must exit nonzero (fail-closed)"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_EXE must not claim skip-lake"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_EXE must not lake-delegate to create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_EXE missing LEANC fail-closed"

echo "== A23 Run 6: non-STRICT missing LEANC → soft-skip (exit 0, no binary) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_EXE=1
  export LEANC="/nonexistent/leanc-a23-soft-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a23_build_env
  export LEANC="/nonexistent/leanc-a23-soft-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: non-STRICT missing LEANC must soft-skip (exit 0), got $rc"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'leanc not found|not usable|skipping host leanc executable'; then
  echo "FAIL: expected soft-skip warn for missing leanc"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "native executable link OK"; then
  echo "FAIL: soft-skip must not claim native executable link OK"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/slake_ir" ]]; then
  echo "FAIL: soft-skip must not write slake_ir when leanc missing"
  exit 1
fi
echo "OK: non-STRICT missing LEANC soft-skips executable link"

echo "== A23 Run 6b: STRICT + probe-passing stub leanc that fails on real link → fail-closed =="
wipe_native
FAKE_LEANC="$(mktemp "${TMPDIR:-/tmp}/a23-fake-leanc.XXXXXX")"
cat > "$FAKE_LEANC" <<'EOF'
#!/usr/bin/env bash
# Pass resolveLeancCmd probe (--version + C toolchain marker), then fail on real link
# so nonzero leanc exit is always fail-closed (no native executable link OK).
case "${1:-}" in
  --version|-v)
    echo "clang version 18.1.0 (A23 link-fail probe)"
    exit 0
    ;;
esac
# Any real link path: fail closed for this negative band.
exit 42
EOF
chmod +x "$FAKE_LEANC"
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_EXE=1
  export SLAKE_NATIVE_EXE_STRICT=1
  export LEANC="$FAKE_LEANC"
  unset SLAKE_NATIVE_BUILD || true
  unset_a23_build_env
  export SLAKE_NATIVE_EXE_STRICT=1
  export LEANC="$FAKE_LEANC"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
rm -f "$FAKE_LEANC"

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: probe-pass + link-fail leanc under STRICT must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "native executable link OK"; then
  echo "FAIL: link-fail leanc must not claim native executable link OK"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'native executable link failed|leanc exit|spawn failed'; then
  echo "FAIL: expected nonzero-leanc / executable-link-failed diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/slake_ir" ]]; then
  if [[ -s "$SYSTEMS_PKG/.slake-native/slake_ir" ]]; then
    echo "FAIL: link-fail stub must not leave a successful non-empty slake_ir"
    exit 1
  fi
fi
echo "OK: STRICT + probe-pass link-fail leanc fail-closed (no executable link OK)"

echo "== A23 Run 7: coexistence NATIVE_EXE + NATIVE_IRLINK + NATIVE_AR (+ optional LINK) =="
wipe_native
out=""
rc=0
AR_PROBE="${AR:-ar}"
if ! command -v "$AR_PROBE" >/dev/null 2>&1 && [[ ! -x "$AR_PROBE" ]]; then
  if [[ "${SLAKE_NATIVE_EXE_SMOKE_STRICT:-}" == "1" ]]; then
    strict_fail "host ar not found for coexistence band (STRICT requires ar for EXE+IRLINK+AR+LINK)"
  fi
  echo "SKIP: host ar not found for coexistence band (EXE alone already covered)"
else
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_EXE=1
    export SLAKE_NATIVE_IRLINK=1
    export SLAKE_NATIVE_AR=1
    unset SLAKE_NATIVE_BUILD || true
    unset_a23_build_env
    # Re-export after unset (it clears NATIVE_IRLINK / NATIVE_AR / NATIVE_LINK among others).
    export SLAKE_NATIVE_IRLINK=1
    export SLAKE_NATIVE_AR=1
    export SLAKE_NATIVE_LINK=1
    unset LEAN || true
    unset CC || true
    unset AR || true
    unset LEANC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?

  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_EXE+NATIVE_IRLINK+NATIVE_AR+NATIVE_LINK exited $rc (expected 0)"
    printf '%s\n' "$out"
    exit 1
  fi
  assert_slake_ir
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
    echo "FAIL: expected non-empty libslake_ir.so alongside slake_ir"
    exit 1
  fi
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]]; then
    echo "FAIL: expected non-empty libslake_ir.a alongside slake_ir"
    exit 1
  fi
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]]; then
    echo "FAIL: expected non-empty libslake_native.so alongside exe + IR SO + archive"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native executable link OK"; then
    echo "FAIL: expected native executable link OK under coexistence"
    printf '%s\n' "$out"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native IR link OK"; then
    echo "FAIL: expected native IR link OK under coexistence"
    printf '%s\n' "$out"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native static archive OK"; then
    echo "FAIL: expected native static archive OK under coexistence"
    printf '%s\n' "$out"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: expected native link OK (name-table) under coexistence"
    printf '%s\n' "$out"
    exit 1
  fi
  echo "OK: slake_ir + libslake_ir.so + libslake_ir.a + libslake_native.so coexist"
fi

echo "== A23 Run 8a: PLAN_ONLY + EXE + GRAPH → executable; no shared_lib / shared_lib_ir / static_lib =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_EXE=1
  unset SLAKE_NATIVE_BUILD || true
  unset_a23_build_env
  export SLAKE_NATIVE_GRAPH=1
  unset LEAN || true
  unset CC || true
  unset LEANC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+EXE+GRAPH exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
assert_slake_ir
graph_path="$SYSTEMS_PKG/.slake-native/slake_native_graph"
if [[ ! -f "$graph_path" ]]; then
  echo "FAIL: expected slake_native_graph after NATIVE_GRAPH"
  exit 1
fi
if ! grep -Eq '^executable \.slake-native/slake_ir$' "$graph_path"; then
  echo "FAIL: graph must list executable after NATIVE_EXE"
  cat "$graph_path"
  exit 1
fi
if grep -Eq '^shared_lib ' "$graph_path"; then
  echo "FAIL: graph must not list A13 shared_lib without NATIVE_LINK"
  cat "$graph_path"
  exit 1
fi
if grep -Eq '^shared_lib_ir ' "$graph_path"; then
  echo "FAIL: graph must not list shared_lib_ir without NATIVE_IRLINK"
  cat "$graph_path"
  exit 1
fi
if grep -Eq '^static_lib ' "$graph_path"; then
  echo "FAIL: graph must not list static_lib without NATIVE_AR"
  cat "$graph_path"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native graph OK"; then
  echo "FAIL: expected native graph OK under EXE+GRAPH"
  printf '%s\n' "$out"
  exit 1
fi
echo "OK: graph lists executable; shared_lib/shared_lib_ir/static_lib absent without LINK/IRLINK/AR"

echo "== A23 Run 8b: PLAN_ONLY + EXE + IRLINK + AR + LINK + GRAPH + SEAL → all product fields =="
wipe_native
out=""
rc=0
if ! command -v "${AR:-ar}" >/dev/null 2>&1 && [[ ! -x "${AR:-ar}" ]]; then
  if [[ "${SLAKE_NATIVE_EXE_SMOKE_STRICT:-}" == "1" ]]; then
    strict_fail "host ar not found for graph/seal multi-product band (STRICT requires ar)"
  fi
  echo "SKIP: host ar not found for graph/seal multi-product band"
else
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_EXE=1
    export SLAKE_NATIVE_IRLINK=1
    export SLAKE_NATIVE_AR=1
    unset SLAKE_NATIVE_BUILD || true
    unset_a23_build_env
    export SLAKE_NATIVE_IRLINK=1
    export SLAKE_NATIVE_AR=1
    export SLAKE_NATIVE_LINK=1
    export SLAKE_NATIVE_GRAPH=1
    export SLAKE_NATIVE_SEAL=1
    unset LEAN || true
    unset CC || true
    unset AR || true
    unset LEANC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?

  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+EXE+IRLINK+AR+LINK+GRAPH+SEAL exited $rc (expected 0)"
    printf '%s\n' "$out"
    exit 1
  fi
  assert_slake_ir
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
    echo "FAIL: expected non-empty libslake_ir.so under multi-product band"
    exit 1
  fi
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]]; then
    echo "FAIL: expected non-empty libslake_ir.a under multi-product band"
    exit 1
  fi
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]]; then
    echo "FAIL: expected non-empty libslake_native.so under multi-product band"
    exit 1
  fi
  graph_path="$SYSTEMS_PKG/.slake-native/slake_native_graph"
  seal_path="$SYSTEMS_PKG/.slake-native/slake_native_seal"
  if [[ ! -f "$graph_path" || ! -f "$seal_path" ]]; then
    echo "FAIL: expected graph and seal artifacts"
    exit 1
  fi
  if ! grep -Eq '^executable \.slake-native/slake_ir$' "$graph_path"; then
    echo "FAIL: graph must list executable with EXE"
    cat "$graph_path"
    exit 1
  fi
  if ! grep -Eq '^shared_lib_ir \.slake-native/libslake_ir\.so$' "$graph_path"; then
    echo "FAIL: graph must list shared_lib_ir with IRLINK"
    cat "$graph_path"
    exit 1
  fi
  if ! grep -Eq '^static_lib \.slake-native/libslake_ir\.a$' "$graph_path"; then
    echo "FAIL: graph must list static_lib with AR"
    cat "$graph_path"
    exit 1
  fi
  if ! grep -Eq '^shared_lib \.slake-native/libslake_native\.so$' "$graph_path"; then
    echo "FAIL: graph must list A13 shared_lib with NATIVE_LINK"
    cat "$graph_path"
    exit 1
  fi
  if ! grep -Eq '^executable \.slake-native/slake_ir$' "$seal_path"; then
    echo "FAIL: seal must list executable with EXE"
    cat "$seal_path"
    exit 1
  fi
  if ! grep -Eq '^static_lib \.slake-native/libslake_ir\.a$' "$seal_path"; then
    echo "FAIL: seal must list static_lib with AR"
    cat "$seal_path"
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
    echo "FAIL: expected native seal OK under multi-product band"
    printf '%s\n' "$out"
    exit 1
  fi
  echo "OK: graph/seal list executable, shared_lib, shared_lib_ir, and static_lib"
fi

echo "== A23 Run 9: clean wipes .slake-native (A17) =="
# Ensure artifacts exist (from prior runs or rebuild EXE-only).
if [[ ! -d "$SYSTEMS_PKG/.slake-native" ]]; then
  (
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_EXE=1
    unset_a23_build_env
    "$SLAKE_EXE" build >/dev/null 2>&1 || true
  )
fi
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
  unset_a23_build_env
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

echo "== A23 Run 10: help lists NATIVE_EXE =="
help_file="$(mktemp "${TMPDIR:-/tmp}/slake-exe-help.XXXXXX")"
"$SLAKE_EXE" --help >"$help_file" 2>&1 || true
if ! grep -Fq "SLAKE_NATIVE_EXE" "$help_file"; then
  echo "FAIL: --help must list SLAKE_NATIVE_EXE"
  head -80 "$help_file" || true
  rm -f "$help_file"
  exit 1
fi
if ! grep -Fq "slake_ir" "$help_file"; then
  echo "FAIL: --help must mention slake_ir"
  rm -f "$help_file"
  exit 1
fi
if ! grep -Fq "host leanc executable link subset of plan-module objects" "$help_file"; then
  echo "FAIL: --help must describe host leanc executable link subset of plan-module objects"
  rm -f "$help_file"
  exit 1
fi
if ! grep -Fq "stub main" "$help_file"; then
  echo "FAIL: --help must mention stub main honesty"
  rm -f "$help_file"
  exit 1
fi
rm -f "$help_file"
echo "OK: help lists NATIVE_EXE"

echo "OK: native_exe_smoke (A23) all bands passed"
