#!/usr/bin/env bash
# Smoke: A14 SLAKE_NATIVE_GRAPH=1 host package link graph subset after native oleans.
#
# Honesty: host package link graph subset — not freestanding build TCB, not Lake
# build graph TCB, not Lake lean_lib SO, not CLAIMED expansion. SCORE does **not**
# run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with tools present.
#
# systems_shaped bands:
#   1) PLAN_ONLY + NATIVE_GRAPH: plan + oleans + graph file (package/module/edge), exit 0
#   2) Rebuild: oleans skip-fresh; graph re-written
#   3) NATIVE_BUILD + NATIVE_GRAPH: skip lake after success; graph present
#   4) NATIVE_BUILD + NATIVE_GRAPH + NATIVE_LINK: skip lake; graph has shared_lib
#   5) NATIVE_GRAPH alone → lake-delegates after graph OK
#   6) env reports NATIVE_GRAPH
#   7) Honesty greps: residual denials present; no freestanding build TCB overclaim
#   8) STRICT + missing lean → olean soft-skips; graph fail-closed (no oleans)
#   9) NATIVE_BUILD + NATIVE_GRAPH + missing lean → fail-closed (no skip-lake / no lake)
#
#   SLAKE_NATIVE_GRAPH_SMOKE_STRICT=1 ./tests/slake/native_graph_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_GRAPH_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

run_native_graph_plan_only() {
  (
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_GRAPH=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    unset SLAKE_NATIVE_BUILD || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )
}

assert_graph_core_host() {
  local g="$1"
  if [[ ! -f "$g" ]]; then
    echo "FAIL: expected graph file at $g"
    exit 1
  fi
  if ! grep -Fq 'package systems_shaped' "$g"; then
    echo "FAIL: graph must have package systems_shaped line"
    exit 1
  fi
  if ! grep -Fq 'module Core olean .slake-native/Core.olean' "$g"; then
    echo "FAIL: graph must list Core olean module line"
    exit 1
  fi
  if ! grep -Fq 'module Host olean .slake-native/Host.olean' "$g"; then
    echo "FAIL: graph must list Host olean module line"
    exit 1
  fi
  # A5: Host imports Core → edge Core Host (from → to means to imports from)
  if ! grep -Fq 'edge Core Host' "$g"; then
    echo "FAIL: graph must have edge Core Host (Host imports Core)"
    exit 1
  fi
  if ! grep -Eq 'summary modules=2 edges=1' "$g"; then
    echo "FAIL: graph must have summary modules=2 edges=1"
    exit 1
  fi
  if ! grep -Fq 'A14 host package link graph subset' "$g"; then
    echo "FAIL: graph header must identify A14 host package link graph subset"
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

echo "== A14 Run 1: PLAN_ONLY + NATIVE_GRAPH → plan + oleans + graph =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  rm -f ./*.olean 2>/dev/null || true
  out="$(run_native_graph_plan_only)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_GRAPH Run 1 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected systems_shaped Core Host plan (NATIVE_GRAPH implies plan)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_GRAPH=1"; then
    echo "FAIL: expected NATIVE_GRAPH banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "host package link graph subset"; then
    echo "FAIL: expected host package link graph subset honesty"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native graph OK"; then
    echo "FAIL: expected native graph OK banner"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: expected oleans under .slake-native/"
    exit 1
  fi
  assert_graph_core_host .slake-native/slake_native_graph
  # A13 field only (`shared_lib `); do not false-match A21 `shared_lib_ir`.
  if grep -Eq '^shared_lib ' .slake-native/slake_native_graph; then
    echo "FAIL: PLAN_ONLY+NATIVE_GRAPH without LINK must not list shared_lib"
    exit 1
  fi
  # Overclaim greps
  if printf '%s' "$out" | grep -Eiq 'freestanding build TCB[[:space:]]*$|achieved freestanding build TCB|is freestanding build TCB'; then
    echo "FAIL: must not overclaim freestanding build TCB as achieved"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
    echo "FAIL: expected residual honesty (not freestanding build TCB)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not Lake build graph TCB"; then
    echo "FAIL: expected residual honesty (not Lake build graph TCB)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not CLAIMED"; then
    echo "FAIL: expected residual honesty (not CLAIMED)"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_GRAPH must not create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: PLAN_ONLY must not lake-delegate"
    exit 1
  fi
)

echo "== A14 Run 2: rebuild — oleans skip-fresh; graph re-written =="
(
  cd "$SYSTEMS_PKG"
  sleep 1
  before_graph_mtime=""
  if [[ -f .slake-native/slake_native_graph ]]; then
    before_graph_mtime="$(stat -c %Y .slake-native/slake_native_graph 2>/dev/null || true)"
  fi
  # Corrupt graph content so re-write is observable even if mtime granularity is coarse.
  if [[ -f .slake-native/slake_native_graph ]]; then
    printf 'stale-graph-marker\n' > .slake-native/slake_native_graph
  fi
  out="$(run_native_graph_plan_only)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_GRAPH Run 2 exited $rc (expected 0)"
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
  if ! printf '%s' "$out" | grep -Fq "native graph OK"; then
    echo "FAIL: expected native graph OK on second run (always re-write)"
    exit 1
  fi
  assert_graph_core_host .slake-native/slake_native_graph
  if grep -Fq 'stale-graph-marker' .slake-native/slake_native_graph; then
    echo "FAIL: graph must be re-written (stale marker still present)"
    exit 1
  fi
  if [[ -n "$before_graph_mtime" ]]; then
    after_graph_mtime="$(stat -c %Y .slake-native/slake_native_graph 2>/dev/null || true)"
    if [[ -n "$after_graph_mtime" && "$after_graph_mtime" -lt "$before_graph_mtime" ]]; then
      echo "FAIL: graph mtime went backwards after re-write"
      exit 1
    fi
  fi
)

echo "== A14 Run 3: NATIVE_BUILD + NATIVE_GRAPH → skip lake, graph present =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_GRAPH=1
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_GRAPH exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_BUILD=1"; then
    echo "FAIL: expected NATIVE_BUILD banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native graph OK"; then
    echo "FAIL: expected native graph OK under NATIVE_BUILD+NATIVE_GRAPH"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + package link graph"; then
    echo "FAIL: expected combined skip-lake banner after olean + graph"
    exit 1
  fi
  assert_graph_core_host .slake-native/slake_native_graph
  if [[ -d .lake/build ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_GRAPH must not create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD success path must not lake-delegate"
    exit 1
  fi
)

echo "== A14 Run 4: NATIVE_BUILD + NATIVE_GRAPH + NATIVE_LINK → skip lake; shared_lib line =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  # Need host cc for link; soft-skip when missing (unless STRICT).
  CC_PROBE="${CC:-cc}"
  if ! command -v "$CC_PROBE" >/dev/null 2>&1 && [[ ! -x "$CC_PROBE" ]]; then
    if [[ "${SLAKE_NATIVE_GRAPH_SMOKE_STRICT:-}" == "1" ]]; then
      echo "FAIL (STRICT): host cc not found for NATIVE_LINK band (set CC= or PATH)"
      exit 1
    fi
    echo "SKIP: host cc not found for NATIVE_LINK band"
    exit 0
  fi
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_GRAPH=1
    export SLAKE_NATIVE_LINK=1
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_GRAPH_STRICT || true
    unset SLAKE_NATIVE_LINK_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_GRAPH+NATIVE_LINK exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: expected native link OK"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native graph OK"; then
    echo "FAIL: expected native graph OK after link"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host shared-lib link + package link graph"; then
    echo "FAIL: expected combined skip-lake banner after olean + link + graph"
    exit 1
  fi
  assert_graph_core_host .slake-native/slake_native_graph
  if ! grep -Fq 'shared_lib .slake-native/libslake_native.so' .slake-native/slake_native_graph; then
    echo "FAIL: graph must list shared_lib after NATIVE_LINK"
    exit 1
  fi
  if [[ ! -f .slake-native/libslake_native.so ]]; then
    echo "FAIL: expected shared lib under NATIVE_BUILD+LINK+GRAPH"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: NATIVE_BUILD+LINK+GRAPH must not create .lake/build"
    exit 1
  fi
)

echo "== A14 Run 5: NATIVE_GRAPH alone → lake-delegates after graph OK =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_GRAPH=1
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_NATIVE_BUILD || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "native graph OK"; then
    echo "FAIL: expected native graph OK under NATIVE_GRAPH alone before lake"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_GRAPH alone must lake-delegate after successful graph"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + package link graph"; then
    echo "FAIL: NATIVE_GRAPH alone must not skip lake (NATIVE_BUILD required for skip-lake)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: NATIVE_GRAPH alone must not claim olean-only skip-lake"
    exit 1
  fi
  assert_graph_core_host .slake-native/slake_native_graph
  # Exit code is lake's; do not require 0 — product claim is lake-delegate.
  :
)

echo "== A14 Run 6: env identity reports NATIVE_GRAPH =="
(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_GRAPH=1
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq "SLAKE_NATIVE_GRAPH: 1" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_GRAPH: 1"
    exit 1
  fi
  if ! grep -Fq "SLAKE_NATIVE_GRAPH_STRICT:" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_GRAPH_STRICT status"
    exit 1
  fi
  if ! grep -Fq "host package link graph subset" <<<"$env_out"; then
    echo "FAIL: env must document host package link graph subset"
    exit 1
  fi
  if ! grep -Fq "not freestanding build TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty freestanding build TCB"
    exit 1
  fi
  if ! grep -Fq "not Lake build graph TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty not Lake build graph TCB"
    exit 1
  fi
  if ! grep -Fq "not CLAIMED" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty not CLAIMED"
    exit 1
  fi
)

echo "== A14 Run 7: STRICT + missing lean → olean soft-skip; graph fail-closed (no oleans) =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_GRAPH=1
    export SLAKE_NATIVE_GRAPH_STRICT=1
    # Missing lean: olean path soft-skips (no OLEAN_STRICT / no NATIVE_BUILD); graph then
    # sees no oleans and must fail-closed under GRAPH_STRICT.
    export LEAN="/nonexistent/slake-native-graph-lean-$$"
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_BUILD || true
    unset SLAKE_NATIVE_LINK || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: NATIVE_GRAPH_STRICT with missing lean / no oleans must exit nonzero"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'no oleans present for graph|no plan modules for graph|fail-closed|STRICT'; then
    echo "FAIL: expected graph empty / fail-closed / STRICT diagnostic"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native graph OK"; then
    echo "FAIL: must not claim native graph OK when oleans absent under STRICT"
    exit 1
  fi
  if [[ -f .slake-native/slake_native_graph ]]; then
    # Soft-skip olean may create out dir; graph file must not be a successful product.
    if grep -Eq '^module ' .slake-native/slake_native_graph 2>/dev/null; then
      echo "FAIL: must not write successful module graph under STRICT with no oleans"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: PLAN_ONLY+GRAPH_STRICT fail-closed must not lake-delegate"
    exit 1
  fi
)

echo "== A14 Run 8: NATIVE_BUILD + NATIVE_GRAPH + missing lean → fail-closed (no skip-lake) =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_GRAPH=1
    export LEAN="/nonexistent/slake-native-graph-lean-$$"
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH_STRICT || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_GRAPH with missing lean must exit nonzero (fail-closed)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + package link graph"; then
    echo "FAIL: must not claim olean+graph skip-lake when lean is missing under NATIVE_BUILD"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: must not claim olean-only skip-lake when lean is missing under NATIVE_BUILD+GRAPH"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native graph OK"; then
    echo "FAIL: must not claim native graph OK when lean is missing under NATIVE_BUILD"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lean not found|not a real Lean|fail-closed|NATIVE_BUILD'; then
    echo "FAIL: expected lean-missing / fail-closed diagnostic under NATIVE_BUILD+NATIVE_GRAPH"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_GRAPH must not lake-delegate to create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD+NATIVE_GRAPH fail-closed must not lake-delegate"
    exit 1
  fi
)

# Leave fixture non-dirty.
(
  cd "$SYSTEMS_PKG"
  rm -rf .slake-native .lake 2>/dev/null || true
)

echo "OK: native_graph_smoke (A14 host package link graph subset after native oleans)"
exit 0
