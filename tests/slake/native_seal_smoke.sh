#!/usr/bin/env bash
# Smoke: A15 SLAKE_NATIVE_SEAL=1 host freestanding-adjacent product seal subset
# after native oleans.
#
# Honesty: host freestanding-adjacent product seal subset — not freestanding
# build TCB, not Lake lean_lib SO, not Lake build graph TCB, not CLAIMED
# expansion. SCORE does **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with tools present.
#
# systems_shaped bands:
#   1) PLAN_ONLY + NATIVE_SEAL: plan + oleans + seal file (package/module hashes/
#      seal hex/summary), honesty denials, exit 0; no lake
#   2) Rebuild: oleans skip-fresh; seal re-written
#   3) NATIVE_BUILD + NATIVE_SEAL: skip lake after success; seal present
#   4) NATIVE_BUILD + LINK + GRAPH + SEAL: skip lake; seal has shared_lib + graph_hash
#   5) NATIVE_SEAL alone → lake-delegates after seal OK
#   6) env reports SEAL flags
#   7) STRICT + missing lean → olean soft-skip; seal fail-closed (no oleans)
#   8) NATIVE_BUILD + NATIVE_SEAL + missing lean → fail-closed (no skip-lake / no lake)
#
#   SLAKE_NATIVE_SEAL_SMOKE_STRICT=1 ./tests/slake/native_seal_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_SEAL_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

run_native_seal_plan_only() {
  (
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_SEAL=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    unset SLAKE_NATIVE_BUILD || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH || true
    unset SLAKE_NATIVE_SEAL_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )
}

assert_seal_core_host() {
  local s="$1"
  if [[ ! -f "$s" ]]; then
    echo "FAIL: expected seal file at $s"
    exit 1
  fi
  if ! grep -Fq 'package systems_shaped' "$s"; then
    echo "FAIL: seal must have package systems_shaped line"
    exit 1
  fi
  if ! grep -Eq '^module Core olean_hash [0-9a-f]{16}$' "$s"; then
    echo "FAIL: seal must list Core olean_hash <16-hex> module line"
    exit 1
  fi
  if ! grep -Eq '^module Host olean_hash [0-9a-f]{16}$' "$s"; then
    echo "FAIL: seal must list Host olean_hash <16-hex> module line"
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
  if ! grep -Fq 'A15 host freestanding-adjacent product seal subset' "$s"; then
    echo "FAIL: seal header must identify A15 host freestanding-adjacent product seal subset"
    exit 1
  fi
  if ! grep -Fq 'NOT freestanding build TCB' "$s"; then
    echo "FAIL: seal header must residual-honesty NOT freestanding build TCB"
    exit 1
  fi
  if ! grep -Fq 'NOT Lake lean_lib SO' "$s"; then
    echo "FAIL: seal header must residual-honesty NOT Lake lean_lib SO"
    exit 1
  fi
  if ! grep -Fq 'NOT Lake build graph TCB' "$s"; then
    echo "FAIL: seal header must residual-honesty NOT Lake build graph TCB"
    exit 1
  fi
  if ! grep -Fq 'NOT CLAIMED' "$s"; then
    echo "FAIL: seal header must residual-honesty NOT CLAIMED"
    exit 1
  fi
}

echo "== A15 Run 1: PLAN_ONLY + NATIVE_SEAL → plan + oleans + seal =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  rm -f ./*.olean 2>/dev/null || true
  out="$(run_native_seal_plan_only)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_SEAL Run 1 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected systems_shaped Core Host plan (NATIVE_SEAL implies plan)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_SEAL=1"; then
    echo "FAIL: expected NATIVE_SEAL banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "host freestanding-adjacent product seal subset"; then
    echo "FAIL: expected host freestanding-adjacent product seal subset honesty"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native seal OK"; then
    echo "FAIL: expected native seal OK banner"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: expected oleans under .slake-native/"
    exit 1
  fi
  assert_seal_core_host .slake-native/slake_native_seal
  # A13 field only (`shared_lib `); do not false-match A21 `shared_lib_ir`.
  if grep -Eq '^shared_lib ' .slake-native/slake_native_seal; then
    echo "FAIL: PLAN_ONLY+NATIVE_SEAL without LINK must not list shared_lib"
    exit 1
  fi
  if grep -Fq 'graph_hash' .slake-native/slake_native_seal; then
    echo "FAIL: PLAN_ONLY+NATIVE_SEAL without GRAPH must not list graph_hash"
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
  if ! printf '%s' "$out" | grep -Fq "not Lake lean_lib SO"; then
    echo "FAIL: expected residual honesty (not Lake lean_lib SO)"
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
    echo "FAIL: PLAN_ONLY+NATIVE_SEAL must not create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: PLAN_ONLY must not lake-delegate"
    exit 1
  fi
)

echo "== A15 Run 2: rebuild — oleans skip-fresh; seal re-written =="
(
  cd "$SYSTEMS_PKG"
  sleep 1
  before_seal_mtime=""
  if [[ -f .slake-native/slake_native_seal ]]; then
    before_seal_mtime="$(stat -c %Y .slake-native/slake_native_seal 2>/dev/null || true)"
  fi
  # Corrupt seal content so re-write is observable even if mtime granularity is coarse.
  if [[ -f .slake-native/slake_native_seal ]]; then
    printf 'stale-seal-marker\n' > .slake-native/slake_native_seal
  fi
  out="$(run_native_seal_plan_only)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_SEAL Run 2 exited $rc (expected 0)"
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
  if ! printf '%s' "$out" | grep -Fq "native seal OK"; then
    echo "FAIL: expected native seal OK on second run (always re-write)"
    exit 1
  fi
  assert_seal_core_host .slake-native/slake_native_seal
  if grep -Fq 'stale-seal-marker' .slake-native/slake_native_seal; then
    echo "FAIL: seal must be re-written (stale marker still present)"
    exit 1
  fi
  if [[ -n "$before_seal_mtime" ]]; then
    after_seal_mtime="$(stat -c %Y .slake-native/slake_native_seal 2>/dev/null || true)"
    if [[ -n "$after_seal_mtime" && "$after_seal_mtime" -lt "$before_seal_mtime" ]]; then
      echo "FAIL: seal mtime went backwards after re-write"
      exit 1
    fi
  fi
)

echo "== A15 Run 3: NATIVE_BUILD + NATIVE_SEAL → skip lake, seal present =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_SEAL=1
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH || true
    unset SLAKE_NATIVE_SEAL_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_SEAL exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_BUILD=1"; then
    echo "FAIL: expected NATIVE_BUILD banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native seal OK"; then
    echo "FAIL: expected native seal OK under NATIVE_BUILD+NATIVE_SEAL"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + product seal"; then
    echo "FAIL: expected combined skip-lake banner after olean + seal"
    exit 1
  fi
  assert_seal_core_host .slake-native/slake_native_seal
  if [[ -d .lake/build ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_SEAL must not create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD success path must not lake-delegate"
    exit 1
  fi
)

echo "== A15 Run 4: NATIVE_BUILD + LINK + GRAPH + SEAL → skip lake; shared_lib + graph_hash =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  # Need host cc for link; soft-skip when missing (unless STRICT).
  CC_PROBE="${CC:-cc}"
  if ! command -v "$CC_PROBE" >/dev/null 2>&1 && [[ ! -x "$CC_PROBE" ]]; then
    if [[ "${SLAKE_NATIVE_SEAL_SMOKE_STRICT:-}" == "1" ]]; then
      echo "FAIL (STRICT): host cc not found for NATIVE_LINK band (set CC= or PATH)"
      exit 1
    fi
    echo "SKIP: host cc not found for NATIVE_LINK band"
    exit 0
  fi
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_LINK=1
    export SLAKE_NATIVE_GRAPH=1
    export SLAKE_NATIVE_SEAL=1
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_GRAPH_STRICT || true
    unset SLAKE_NATIVE_LINK_STRICT || true
    unset SLAKE_NATIVE_SEAL_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: NATIVE_BUILD+LINK+GRAPH+SEAL exited $rc (expected 0)"
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
  if ! printf '%s' "$out" | grep -Fq "native seal OK"; then
    echo "FAIL: expected native seal OK after graph"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host shared-lib link + package link graph + product seal"; then
    echo "FAIL: expected combined skip-lake banner after olean + link + graph + seal"
    exit 1
  fi
  assert_seal_core_host .slake-native/slake_native_seal
  if ! grep -Fq 'shared_lib .slake-native/libslake_native.so' .slake-native/slake_native_seal; then
    echo "FAIL: seal must list shared_lib after NATIVE_LINK"
    exit 1
  fi
  if ! grep -Eq '^graph_hash [0-9a-f]{16}$' .slake-native/slake_native_seal; then
    echo "FAIL: seal must list graph_hash after NATIVE_GRAPH"
    exit 1
  fi
  if [[ ! -f .slake-native/libslake_native.so ]]; then
    echo "FAIL: expected shared lib under NATIVE_BUILD+LINK+GRAPH+SEAL"
    exit 1
  fi
  if [[ ! -f .slake-native/slake_native_graph ]]; then
    echo "FAIL: expected graph under NATIVE_BUILD+LINK+GRAPH+SEAL"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: NATIVE_BUILD+LINK+GRAPH+SEAL must not create .lake/build"
    exit 1
  fi
)

echo "== A15 Run 5: NATIVE_SEAL alone → lake-delegates after seal OK =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_SEAL=1
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_NATIVE_BUILD || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH || true
    unset SLAKE_NATIVE_SEAL_STRICT || true
    unset LEAN || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "native seal OK"; then
    echo "FAIL: expected native seal OK under NATIVE_SEAL alone before lake"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_SEAL alone must lake-delegate after successful seal"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + product seal"; then
    echo "FAIL: NATIVE_SEAL alone must not skip lake (NATIVE_BUILD required for skip-lake)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: NATIVE_SEAL alone must not claim olean-only skip-lake"
    exit 1
  fi
  assert_seal_core_host .slake-native/slake_native_seal
  # Exit code is lake's; do not require 0 — product claim is lake-delegate.
  :
)

echo "== A15 Run 6: env identity reports NATIVE_SEAL =="
(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_SEAL=1
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq "SLAKE_NATIVE_SEAL: 1" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_SEAL: 1"
    exit 1
  fi
  if ! grep -Fq "SLAKE_NATIVE_SEAL_STRICT:" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_SEAL_STRICT status"
    exit 1
  fi
  if ! grep -Fq "host freestanding-adjacent product seal subset" <<<"$env_out"; then
    echo "FAIL: env must document host freestanding-adjacent product seal subset"
    exit 1
  fi
  if ! grep -Fq "not freestanding build TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty freestanding build TCB"
    exit 1
  fi
  if ! grep -Fq "not Lake lean_lib SO" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty not Lake lean_lib SO"
    exit 1
  fi
  if ! grep -Fq "not CLAIMED" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty not CLAIMED"
    exit 1
  fi
)

echo "== A15 Run 7: STRICT + missing lean → olean soft-skip; seal fail-closed (no oleans) =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_SEAL=1
    export SLAKE_NATIVE_SEAL_STRICT=1
    # Missing lean: olean path soft-skips (no OLEAN_STRICT / no NATIVE_BUILD); seal then
    # sees no oleans and must fail-closed under SEAL_STRICT.
    export LEAN="/nonexistent/slake-native-seal-lean-$$"
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_BUILD || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: NATIVE_SEAL_STRICT with missing lean / no oleans must exit nonzero"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'no oleans present for seal|no plan modules for seal|cannot hash|fail-closed|STRICT'; then
    echo "FAIL: expected seal empty / fail-closed / STRICT diagnostic"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native seal OK"; then
    echo "FAIL: must not claim native seal OK when oleans absent under STRICT"
    exit 1
  fi
  if [[ -f .slake-native/slake_native_seal ]]; then
    # Soft-skip olean may create out dir; seal file must not be a successful product.
    if grep -Eq '^module ' .slake-native/slake_native_seal 2>/dev/null; then
      echo "FAIL: must not write successful module seal under STRICT with no oleans"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: PLAN_ONLY+SEAL_STRICT fail-closed must not lake-delegate"
    exit 1
  fi
)

echo "== A15 Run 8: NATIVE_BUILD + NATIVE_SEAL + missing lean → fail-closed (no skip-lake) =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export SLAKE_NATIVE_SEAL=1
    export LEAN="/nonexistent/slake-native-seal-lean-$$"
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_LINK || true
    unset SLAKE_NATIVE_GRAPH || true
    unset SLAKE_NATIVE_SEAL_STRICT || true
    unset CC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: NATIVE_BUILD+NATIVE_SEAL with missing lean must exit nonzero (fail-closed)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + product seal"; then
    echo "FAIL: must not claim olean+seal skip-lake when lean is missing under NATIVE_BUILD"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: must not claim olean-only skip-lake when lean is missing under NATIVE_BUILD+SEAL"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native seal OK"; then
    echo "FAIL: must not claim native seal OK when lean is missing under NATIVE_BUILD"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lean not found|not a real Lean|fail-closed|NATIVE_BUILD'; then
    echo "FAIL: expected lean-missing / fail-closed diagnostic under NATIVE_BUILD+NATIVE_SEAL"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_SEAL must not lake-delegate to create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD+NATIVE_SEAL fail-closed must not lake-delegate"
    exit 1
  fi
)

# Leave fixture non-dirty.
(
  cd "$SYSTEMS_PKG"
  rm -rf .slake-native .lake 2>/dev/null || true
)

echo "OK: native_seal_smoke (A15 host freestanding-adjacent product seal subset after native oleans)"
exit 0
