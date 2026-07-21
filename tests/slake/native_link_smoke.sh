#!/usr/bin/env bash
# Smoke: A13 SLAKE_NATIVE_LINK=1 host shared-lib link subset after native oleans.
#
# Honesty: host shared-lib link subset — not freestanding build TCB, not Lake
# shared-lib TCB, not Lake lean_lib shared-object of compiled Lean IR, not
# CLAIMED expansion. SCORE does **not** run this smoke.
#
# Soft-skip when slake binary, host lean, or host cc missing (parity-preserving).
# Hard-fail when STRICT and binary/lean/cc missing, or claim fails with tools present.
#
# systems_shaped bands:
#   1) PLAN_ONLY + NATIVE_LINK: plan + oleans + libslake_native.so, exit 0, no overclaim
#   2) Rebuild: oleans may skip-fresh; link re-runs; shared lib still present
#   3) STRICT: broken CC → fail-closed nonzero
#   4) NATIVE_BUILD + NATIVE_LINK: skip lake after success; no .lake/build
#   5) NATIVE_BUILD + NATIVE_LINK + broken CC → fail-closed (no skip-lake / no lake fallback)
#   6) NATIVE_LINK alone (no PLAN_ONLY / no NATIVE_BUILD) → lake-delegates after link
#   7) Honesty greps: no freestanding build TCB / Lake job server / Lake shared-lib TCB claims
#
#   SLAKE_NATIVE_LINK_SMOKE_STRICT=1 ./tests/slake/native_link_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_LINK_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

run_native_link_plan_only() {
  (
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_LINK=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    unset SLAKE_NATIVE_BUILD || true
    unset SLAKE_NATIVE_LINK_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )
}

echo "== A13 Run 1: PLAN_ONLY + NATIVE_LINK → plan + oleans + shared lib =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  rm -f ./*.olean 2>/dev/null || true
  out="$(run_native_link_plan_only)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_LINK Run 1 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected systems_shaped Core Host plan (NATIVE_LINK implies plan)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_LINK=1"; then
    echo "FAIL: expected NATIVE_LINK banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "host shared-lib link subset"; then
    echo "FAIL: expected host shared-lib link subset honesty"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: expected native link OK banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake_native_plan_modules"; then
    echo "FAIL: expected slake_native_plan_modules export honesty"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: expected oleans under .slake-native/"
    exit 1
  fi
  if [[ ! -f .slake-native/slake_native_export.c ]]; then
    echo "FAIL: expected .slake-native/slake_native_export.c"
    exit 1
  fi
  if [[ ! -f .slake-native/libslake_native.so ]]; then
    echo "FAIL: expected .slake-native/libslake_native.so"
    exit 1
  fi
  if ! grep -Fq 'slake_native_plan_modules' .slake-native/slake_native_export.c; then
    echo "FAIL: export C source must define slake_native_plan_modules"
    exit 1
  fi
  if ! grep -Fq '"Core"' .slake-native/slake_native_export.c; then
    echo "FAIL: export C source must list Core plan module"
    exit 1
  fi
  if ! grep -Fq '"Host"' .slake-native/slake_native_export.c; then
    echo "FAIL: export C source must list Host plan module"
    exit 1
  fi
  # Overclaim greps (fail-closed: residual "not Lake job server" denial required if phrase appears)
  if printf '%s' "$out" | grep -Eiq 'freestanding build TCB[[:space:]]*$|achieved freestanding build TCB|is freestanding build TCB'; then
    echo "FAIL: must not overclaim freestanding build TCB as achieved"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "Lake job server TCB" && ! printf '%s' "$out" | grep -Fq "not Lake job server"; then
    echo "FAIL: Lake job server TCB mentioned without residual 'not Lake job server' denial"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'Lake shared-lib TCB[[:space:]]*(achieved|yes|done)' ; then
    echo "FAIL: must not overclaim Lake shared-lib TCB"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
    echo "FAIL: expected residual honesty (not freestanding build TCB)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not Lake shared-lib TCB"; then
    echo "FAIL: expected residual honesty (not Lake shared-lib TCB)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not CLAIMED"; then
    echo "FAIL: expected residual honesty (not CLAIMED)"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_LINK must not create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: PLAN_ONLY must not lake-delegate"
    exit 1
  fi
)

echo "== A13 Run 2: rebuild — oleans skip-fresh; link re-runs =="
(
  cd "$SYSTEMS_PKG"
  sleep 1
  # Capture mtime of shared lib before rebuild (if available).
  before_so_mtime=""
  if [[ -f .slake-native/libslake_native.so ]]; then
    before_so_mtime="$(stat -c %Y .slake-native/libslake_native.so 2>/dev/null || true)"
  fi
  out="$(run_native_link_plan_only)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_LINK Run 2 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: skip Core (fresh)"; then
    echo "FAIL: expected skip Core (fresh) on second run"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: skip Host (fresh)"; then
    echo "FAIL: expected skip Host (fresh) on second run"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native link:"; then
    echo "FAIL: expected link re-run (or at least native link: log) on second run"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: expected native link OK on second run"
    exit 1
  fi
  if [[ ! -f .slake-native/libslake_native.so ]]; then
    echo "FAIL: shared lib must still exist after rebuild"
    exit 1
  fi
  # Best-effort: link re-run should refresh mtime when stat available.
  if [[ -n "$before_so_mtime" ]]; then
    after_so_mtime="$(stat -c %Y .slake-native/libslake_native.so 2>/dev/null || true)"
    if [[ -n "$after_so_mtime" && "$after_so_mtime" -lt "$before_so_mtime" ]]; then
      echo "FAIL: shared lib mtime went backwards after link re-run"
      exit 1
    fi
  fi
)

echo "== A13 Run 3: STRICT + broken CC → fail-closed =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_LINK=1
    export SLAKE_NATIVE_LINK_STRICT=1
    export CC="/nonexistent/slake-native-link-cc-$$"
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_BUILD || true
    unset LEAN || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: NATIVE_LINK_STRICT with missing CC must exit nonzero"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'cc not found|not usable|STRICT|fail-closed'; then
    echo "FAIL: expected cc-missing / STRICT diagnostic"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: must not claim native link OK when CC is missing"
    exit 1
  fi
  if [[ -f .slake-native/libslake_native.so ]]; then
    echo "FAIL: must not produce shared lib when CC is missing under STRICT"
    exit 1
  fi
)

echo "== A13 Run 4: NATIVE_BUILD + NATIVE_LINK → skip lake, no .lake/build =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_LINK=1
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_LINK exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_BUILD=1"; then
    echo "FAIL: expected NATIVE_BUILD banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: expected native link OK under NATIVE_BUILD+NATIVE_LINK"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host shared-lib link"; then
    echo "FAIL: expected combined skip-lake banner after olean + link"
    exit 1
  fi
  if [[ ! -f .slake-native/libslake_native.so ]]; then
    echo "FAIL: expected shared lib under NATIVE_BUILD+NATIVE_LINK"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_LINK must not create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD success path must not lake-delegate"
    exit 1
  fi
)

echo "== A13 Run 5: NATIVE_BUILD + NATIVE_LINK + broken CC → fail-closed (no skip-lake) =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_LINK=1
    export CC="/nonexistent/slake-native-link-cc-$$"
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK_STRICT || true
    unset LEAN || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_LINK with missing CC must exit nonzero (fail-closed)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host shared-lib link"; then
    echo "FAIL: must not claim combined skip-lake when CC is missing under NATIVE_BUILD"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: must not claim olean-only skip-lake when NATIVE_LINK+missing CC under NATIVE_BUILD"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: must not claim native link OK when CC is missing under NATIVE_BUILD"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'cc not found|not usable|fail-closed'; then
    echo "FAIL: expected cc-missing / fail-closed diagnostic under NATIVE_BUILD+NATIVE_LINK"
    exit 1
  fi
  if [[ -f .slake-native/libslake_native.so ]]; then
    echo "FAIL: must not produce shared lib when CC is missing under NATIVE_BUILD+NATIVE_LINK"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_LINK must not lake-delegate to create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD+NATIVE_LINK fail-closed must not lake-delegate"
    exit 1
  fi
)

echo "== A13 Run 6: NATIVE_LINK alone → lake-delegates after successful link =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_LINK=1
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_NATIVE_BUILD || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK_STRICT || true
    unset LEAN || true
    unset CC || true
    # Lake may succeed or fail depending on fixture lean_lib; we only assert
    # slake's post-link lake-delegate path (not skip-lake).
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: expected native link OK under NATIVE_LINK alone before lake"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_LINK alone must lake-delegate after successful link"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host shared-lib link"; then
    echo "FAIL: NATIVE_LINK alone must not skip lake (NATIVE_BUILD required for skip-lake)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: NATIVE_LINK alone must not claim olean-only skip-lake"
    exit 1
  fi
  if [[ ! -f .slake-native/libslake_native.so ]]; then
    echo "FAIL: expected shared lib under NATIVE_LINK alone"
    exit 1
  fi
  # Exit code is lake's; do not require 0 — product claim is lake-delegate, not lake success.
  :
)

echo "== A13 Run 7: env identity reports NATIVE_LINK =="
(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_LINK=1
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq "SLAKE_NATIVE_LINK: 1" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_LINK: 1"
    exit 1
  fi
  if ! grep -Fq "SLAKE_NATIVE_LINK_STRICT:" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_LINK_STRICT status"
    exit 1
  fi
  if ! grep -Fq "host shared-lib link subset" <<<"$env_out"; then
    echo "FAIL: env must document host shared-lib link subset"
    exit 1
  fi
  if ! grep -Fq "not freestanding build TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty freestanding build TCB"
    exit 1
  fi
  if ! grep -Fq "not Lake shared-lib TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty not Lake shared-lib TCB"
    exit 1
  fi
  if ! grep -Fq "not CLAIMED" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty not CLAIMED"
    exit 1
  fi
)

# Leave fixture non-dirty.
(
  cd "$SYSTEMS_PKG"
  rm -rf .slake-native .lake 2>/dev/null || true
)

echo "OK: native_link_smoke (A13 host shared-lib link subset after native oleans)"
exit 0
