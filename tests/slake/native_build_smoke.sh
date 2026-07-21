#!/usr/bin/env bash
# Smoke: A10 SLAKE_NATIVE_BUILD=1 freestanding-adjacent sequential native olean build.
#
# Honesty: freestanding-adjacent sequential native olean build subset — not
# freestanding build TCB, not Lake TCB, not CLAIMED expansion. CLAIMED `build`
# without this flag remains lake-delegated (covered by run_parity). SCORE does
# **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with binary present.
#
# systems_shaped:
#   Run 1: NATIVE_BUILD alone → plan + oleans + sidecars, exit 0, **no** .lake/build
#   Run 2: NATIVE_BUILD again → skip fresh (cache), still no .lake/build
#   Run 3: LEAN=/nonexistent → fail-closed nonzero (no zero-work success / no skip-lake success)
#   Run 4: break Host.lean → lean nonzero → fail-closed (no successful skip-lake banner)
#   Env: NATIVE_BUILD reported; skip-lake honesty
#
#   SLAKE_NATIVE_BUILD_SMOKE_STRICT=1 ./tests/slake/native_build_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_BUILD_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

run_native_build() {
  (
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    # Intentionally do **not** set PLAN_ONLY — NATIVE_BUILD alone must skip lake.
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    unset LEAN || true
    "$SLAKE_EXE" build 2>&1
  )
}

echo "== A10 NATIVE_BUILD Run 1: compile Core+Host, skip lake, no .lake/build =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  rm -f ./*.olean 2>/dev/null || true
  out="$(run_native_build)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: NATIVE_BUILD Run 1 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected systems_shaped Core Host plan (NATIVE_BUILD implies plan)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_BUILD=1"; then
    echo "FAIL: expected NATIVE_BUILD banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding-adjacent sequential native olean build subset"; then
    echo "FAIL: expected freestanding-adjacent sequential native olean build honesty"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: expected skip-lake-after-success banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Core\.lean' >/dev/null; then
    echo "FAIL: expected Core lean -o under NATIVE_BUILD"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Host\.lean' >/dev/null; then
    echo "FAIL: expected Host lean -o under NATIVE_BUILD"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: expected oleans under .slake-native/"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean.slakehash ]]; then
    echo "FAIL: expected hash sidecar under NATIVE_BUILD (A10 path)"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: NATIVE_BUILD must not create .lake/build (no lake cosplay)"
    exit 1
  fi
  # Must not lake-delegate (classic host path prints "delegating to `lake build`").
  # Honesty banners may say "skipping lake" / "not Lake TCB" — those are OK.
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD success path must not lake-delegate"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'IO.Process path'; then
    echo "FAIL: NATIVE_BUILD success path must not take classic IO.Process lake path"
    exit 1
  fi
)

echo "== A10 NATIVE_BUILD Run 2: fresh cache → skip, still no lake =="
(
  cd "$SYSTEMS_PKG"
  sleep 1
  out="$(run_native_build)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: NATIVE_BUILD Run 2 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: skip Core (fresh)"; then
    echo "FAIL: expected skip Core (fresh) on second NATIVE_BUILD"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: skip Host (fresh)"; then
    echo "FAIL: expected skip Host (fresh) on second NATIVE_BUILD"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: NATIVE_BUILD Run 2 must not create .lake/build"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: expected skip-lake banner on Run 2"
    exit 1
  fi
)

echo "== A10 NATIVE_BUILD Run 3: LEAN missing → fail-closed (no zero-work success) =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  # Point LEAN at a missing absolute path (resolveLeanCmd must reject).
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_NATIVE_BUILD=1
    export LEAN="/nonexistent/slake-native-build-lean-$$"
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: NATIVE_BUILD with missing LEAN must exit nonzero (fail-closed)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: must not claim successful skip-lake when lean is missing"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lean not found|not a real Lean|fail-closed'; then
    echo "FAIL: expected lean-missing / fail-closed diagnostic"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: fail-closed NATIVE_BUILD must not lake-delegate to create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD fail-closed must not lake-delegate"
    exit 1
  fi
)

echo "== A10 NATIVE_BUILD Run 4: lean nonzero (broken Host) → fail-closed =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  cp -a Host.lean Host.lean.a10bak
  # Syntax error so host lean -o fails for Host after Core succeeds.
  printf '\n# this is not valid lean syntax {{{{\n' >> Host.lean
  out="$(run_native_build)" || rc=$?
  rc="${rc:-0}"
  mv -f Host.lean.a10bak Host.lean
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: NATIVE_BUILD with lean compile failure must exit nonzero"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
    echo "FAIL: must not claim successful skip-lake when lean -o fails"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean failed"; then
    echo "FAIL: expected native olean failed diagnostic"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: lean-fail NATIVE_BUILD must not lake-delegate to create .lake/build"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'delegating to `lake build`'; then
    echo "FAIL: NATIVE_BUILD lean-fail must not lake-delegate"
    exit 1
  fi
)

echo "== A10 env identity reports NATIVE_BUILD =="
(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq "SLAKE_NATIVE_BUILD: 1" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_BUILD: 1"
    exit 1
  fi
  if ! grep -Fq "NATIVE_BUILD" <<<"$env_out"; then
    echo "FAIL: env must document NATIVE_BUILD narrative"
    exit 1
  fi
  if ! grep -Fq "skip lake on success" <<<"$env_out"; then
    echo "FAIL: env must document skip lake on success"
    exit 1
  fi
  if ! grep -Fq "fail-closed" <<<"$env_out"; then
    echo "FAIL: env must document NATIVE_BUILD fail-closed"
    exit 1
  fi
  if ! grep -Fq "not freestanding build TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty freestanding build TCB"
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
  rm -f Host.lean.a10bak 2>/dev/null || true
)

echo "OK: native_build_smoke (A10 freestanding-adjacent sequential native olean build subset)"
exit 0
