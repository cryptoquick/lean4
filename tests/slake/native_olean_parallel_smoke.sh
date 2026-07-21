#!/usr/bin/env bash
# Smoke: A12 SLAKE_NATIVE_OLEAN_JOBS=N parallel ready-set host-lean olean waves.
#
# Honesty: parallel host-lean olean wave subset — not freestanding build TCB, not
# Lake job server TCB, not CLAIMED expansion, not shared-lib link. SCORE does
# **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with binary present.
#
# Bands:
#   1) JOBS unset / JOBS=1 sequential on parallel_shaped (A||B then Top)
#   2) JOBS=2 on parallel_shaped: both A and B oleans; Top after deps
#   3) systems_shaped JOBS=2: Core before Host still correct (ready-set)
#   4) NATIVE_BUILD + JOBS still skip lake on success
#   5) invalid JOBS → sequential jobs=1
#   6) JOBS=2 lean-fail fail-closed under NATIVE_BUILD (drain batch; no skip-lake success)
#   7) Honesty greps (jobs line; not Lake job server / not freestanding / not CLAIMED)
#
#   SLAKE_NATIVE_OLEAN_PARALLEL_SMOKE_STRICT=1 ./tests/slake/native_olean_parallel_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PARALLEL_PKG="$ROOT/parallel_shaped"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_OLEAN_PARALLEL_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

if [[ ! -d "$PARALLEL_PKG" ]]; then
  strict_fail "parallel_shaped fixture missing at $PARALLEL_PKG"
fi
if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi

run_parallel_pkg() {
  local jobs_env="${1:-}"
  (
    cd "$PARALLEL_PKG"
    rm -rf .lake .slake-native 2>/dev/null || true
    rm -f ./*.olean 2>/dev/null || true
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_OLEAN=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    unset SLAKE_NATIVE_BUILD || true
    unset LEAN || true
    if [[ -n "$jobs_env" ]]; then
      export SLAKE_NATIVE_OLEAN_JOBS="$jobs_env"
    else
      unset SLAKE_NATIVE_OLEAN_JOBS || true
    fi
    "$SLAKE_EXE" build 2>&1
  )
}

echo "== A12 Run 1: JOBS unset (sequential default) on parallel_shaped =="
out=""
rc=0
out="$(run_parallel_pkg "")" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: JOBS unset exited $rc (expected 0)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: parallel_shaped"; then
  echo "FAIL: expected parallel_shaped plan"
  exit 1
fi
# Plan must place A and B before Top (import-scan).
if ! printf '%s' "$out" | grep -Eq 'slake depgraph plan: parallel_shaped .*A.*B.*Top|slake depgraph plan: parallel_shaped .*B.*A.*Top'; then
  echo "FAIL: expected A and B before Top in plan (got: $(printf '%s' "$out" | grep -F 'slake depgraph plan:' | head -1))"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "multi-module sequential host-lean + olean LEAN_PATH"; then
  echo "FAIL: expected sequential honesty banner when JOBS unset"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean: jobs=1"; then
  echo "FAIL: expected native olean: jobs=1 honesty line"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean OK (host lean sequential + olean LEAN_PATH"; then
  echo "FAIL: expected sequential OK banner"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
  echo "FAIL: expected residual honesty (not freestanding build TCB)"
  exit 1
fi
if [[ ! -f "$PARALLEL_PKG/.slake-native/A.olean" || ! -f "$PARALLEL_PKG/.slake-native/B.olean" || ! -f "$PARALLEL_PKG/.slake-native/Top.olean" ]]; then
  echo "FAIL: expected A.olean B.olean Top.olean under .slake-native/"
  exit 1
fi
rm -rf "$PARALLEL_PKG/.slake-native" 2>/dev/null || true

echo "== A12 Run 2: JOBS=1 explicit sequential on parallel_shaped =="
out=""
rc=0
out="$(run_parallel_pkg "1")" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: JOBS=1 exited $rc (expected 0)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean: jobs=1"; then
  echo "FAIL: expected jobs=1 with JOBS=1"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "multi-module sequential host-lean + olean LEAN_PATH"; then
  echo "FAIL: expected sequential banner for JOBS=1"
  exit 1
fi
rm -rf "$PARALLEL_PKG/.slake-native" 2>/dev/null || true

echo "== A12 Run 3: JOBS=2 parallel ready-set on parallel_shaped (A||B then Top) =="
out=""
rc=0
out="$(run_parallel_pkg "2")" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: JOBS=2 exited $rc (expected 0)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean: jobs=2"; then
  echo "FAIL: expected native olean: jobs=2"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "multi-module parallel host-lean olean wave + LEAN_PATH"; then
  echo "FAIL: expected parallel host-lean olean wave banner"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "not Lake job server TCB"; then
  echo "FAIL: expected honesty (not Lake job server TCB)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "not CLAIMED"; then
  echo "FAIL: expected honesty (not CLAIMED)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "not shared-lib link"; then
  echo "FAIL: expected honesty (not shared-lib link)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean OK (host lean parallel olean wave + olean LEAN_PATH"; then
  echo "FAIL: expected parallel OK banner"
  exit 1
fi
# All three modules compiled (or at least oleans present).
if [[ ! -f "$PARALLEL_PKG/.slake-native/A.olean" || ! -f "$PARALLEL_PKG/.slake-native/B.olean" || ! -f "$PARALLEL_PKG/.slake-native/Top.olean" ]]; then
  echo "FAIL: expected A.olean B.olean Top.olean after JOBS=2"
  exit 1
fi
# Top lean line must appear after both A and B have been handled (compiled or skip).
# Extract line numbers of lean -o for A, B, Top relative args.
a_line="$(printf '%s\n' "$out" | grep -n 'native olean: .* -o .*A\.lean' | head -1 | cut -d: -f1 || true)"
b_line="$(printf '%s\n' "$out" | grep -n 'native olean: .* -o .*B\.lean' | head -1 | cut -d: -f1 || true)"
top_line="$(printf '%s\n' "$out" | grep -n 'native olean: .* -o .*Top\.lean' | head -1 | cut -d: -f1 || true)"
if [[ -z "$a_line" || -z "$b_line" || -z "$top_line" ]]; then
  echo "FAIL: expected lean -o lines for A, B, and Top"
  exit 1
fi
if [[ "$top_line" -le "$a_line" || "$top_line" -le "$b_line" ]]; then
  echo "FAIL: Top lean must start after A and B lean lines (ready-set; got A=$a_line B=$b_line Top=$top_line)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake"; then
  echo "FAIL: PLAN_ONLY must still skip lake after parallel olean"
  exit 1
fi
if [[ -d "$PARALLEL_PKG/.lake/build" ]]; then
  echo "FAIL: PLAN_ONLY must not create .lake/build"
  exit 1
fi
rm -rf "$PARALLEL_PKG/.slake-native" 2>/dev/null || true

echo "== A12 Run 4: systems_shaped JOBS=2 still Core before Host (ready-set chain) =="
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_OLEAN_JOBS=2
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: systems_shaped JOBS=2 exited $rc"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
  echo "FAIL: expected systems_shaped Core Host plan"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean: jobs=2"; then
  echo "FAIL: expected jobs=2 on systems_shaped"
  exit 1
fi
core_line="$(printf '%s\n' "$out" | grep -n 'native olean: .* -o .*Core\.lean' | head -1 | cut -d: -f1 || true)"
host_line="$(printf '%s\n' "$out" | grep -n 'native olean: .* -o .*Host\.lean' | head -1 | cut -d: -f1 || true)"
if [[ -z "$core_line" || -z "$host_line" ]]; then
  echo "FAIL: expected Core and Host lean -o lines"
  exit 1
fi
if [[ "$host_line" -le "$core_line" ]]; then
  echo "FAIL: Host must not start before Core finishes/starts (ready-set; Core=$core_line Host=$host_line)"
  exit 1
fi
if [[ ! -f "$SYSTEMS_PKG/.slake-native/Core.olean" || ! -f "$SYSTEMS_PKG/.slake-native/Host.olean" ]]; then
  echo "FAIL: expected Core.olean and Host.olean"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean OK"; then
  echo "FAIL: expected native olean OK (Host imports Core via olean)"
  exit 1
fi
rm -rf "$SYSTEMS_PKG/.slake-native" 2>/dev/null || true

echo "== A12 Run 5: NATIVE_BUILD + JOBS=2 skip lake on success =="
out=""
rc=0
out="$(
  cd "$PARALLEL_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_OLEAN_JOBS=2
  unset SLAKE_PLAN_ONLY || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset LEAN || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: NATIVE_BUILD+JOBS=2 exited $rc (expected 0)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean: jobs=2"; then
  echo "FAIL: expected jobs=2 under NATIVE_BUILD"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
  echo "FAIL: NATIVE_BUILD must skip lake on success"
  exit 1
fi
if [[ -d "$PARALLEL_PKG/.lake/build" ]]; then
  echo "FAIL: NATIVE_BUILD must not create .lake/build via lake"
  exit 1
fi
if [[ ! -f "$PARALLEL_PKG/.slake-native/A.olean" || ! -f "$PARALLEL_PKG/.slake-native/Top.olean" ]]; then
  echo "FAIL: expected oleans after NATIVE_BUILD+JOBS"
  exit 1
fi
rm -rf "$PARALLEL_PKG/.slake-native" 2>/dev/null || true

echo "== A12 Run 6: invalid JOBS falls back to sequential =="
out=""
rc=0
out="$(run_parallel_pkg "nope")" || rc=$?
printf '%s\n' "$out"
if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: invalid JOBS exited $rc (expected 0 sequential)"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native olean: jobs=1"; then
  echo "FAIL: invalid JOBS must fall back to jobs=1"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "multi-module sequential host-lean + olean LEAN_PATH"; then
  echo "FAIL: invalid JOBS must use sequential banner"
  exit 1
fi
rm -rf "$PARALLEL_PKG/.slake-native" 2>/dev/null || true

echo "== A12 Run 7: JOBS=2 lean-fail fail-closed under NATIVE_BUILD (drain batch; no skip-lake success) =="
(
  cd "$PARALLEL_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  cp -a A.lean A.lean.a12bak
  # Syntax error so host lean -o fails for A (ready-set batch with B under JOBS=2).
  printf '\n# this is not valid lean syntax {{{{\n' >> A.lean
  out=""
  rc=0
  out="$(
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_OLEAN_JOBS=2
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    unset LEAN || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  mv -f A.lean.a12bak A.lean
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: JOBS=2 lean-fail under NATIVE_BUILD must exit nonzero"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: must not claim successful skip-lake when lean -o fails under JOBS=2"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean failed"; then
    echo "FAIL: expected native olean failed diagnostic under JOBS=2 lean-fail"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: jobs=2"; then
    echo "FAIL: expected jobs=2 on lean-fail path"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: lean-fail NATIVE_BUILD+JOBS must not lake-delegate to create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD lean-fail must not lake-delegate"
    exit 1
  fi
)
rm -rf "$PARALLEL_PKG/.slake-native" 2>/dev/null || true

echo "OK: native_olean_parallel_smoke (A12 JOBS ready-set parallel host-lean olean wave subset)"
exit 0
