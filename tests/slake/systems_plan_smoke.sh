#!/usr/bin/env bash
# A4 dogfood: package-derived slake build plan on a Systems-shaped multi-target
# package (`tests/slake/systems_shaped`: Host + Core libs; Host imports Core).
#
# Documents + exercises:
#   SLAKE_PLAN_ONLY=1              host/package plan, skip lake (exit 0)
#   SLAKE_DEPGRAPH=1               freestanding package plan then lake (optional)
#   SLAKE_DEPGRAPH=1 SLAKE_PLAN_ONLY=1  freestanding plan, skip lake
#
# Declaration order is Host then Core; import-scan places Core before Host.
# Soft-SKIP if slake binary missing. Hard-fail when binary present and claim fails.
# SCORE / systems-validate do **not** run this smoke.
#
#   SLAKE_SYSTEMS_PLAN_SMOKE_STRICT=1 ./tests/slake/systems_plan_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_SYSTEMS_PLAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

if [[ ! -f "$PKG/lakefile.toml" ]]; then
  echo "FAIL: missing systems_shaped package at $PKG"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== A4 systems_shaped identity (env) =="
(
  cd "$PKG"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "name=systems_shaped"; then
    echo "FAIL: expected name=systems_shaped"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "defaultTargets=2"; then
    echo "FAIL: expected defaultTargets=2"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "lean_lib=2"; then
    echo "FAIL: expected lean_lib=2"
    exit 1
  fi
)

echo "== A4 SLAKE_PLAN_ONLY=1 multi-target plan (no lake) =="
(
  cd "$PKG"
  rm -rf .lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY exited $rc"
    exit 1
  fi
  # package name + both targets; import-scan puts Core before Host (not declaration Host Core)
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected import-scan plan 'systems_shaped Core Host' (Core before Host)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eq 'slake depgraph plan: systems_shaped Host Core( |$)'; then
    echo "FAIL: declaration-order chain Host before Core — import DAG not applied"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake"; then
    echo "FAIL: expected skipping lake"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
    exit 1
  fi
)

echo "== A4 SLAKE_DEPGRAPH=1 + PLAN_ONLY (freestanding when linked) =="
(
  cd "$PKG"
  rm -rf .lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_DEPGRAPH=1
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: DEPGRAPH+PLAN_ONLY exited $rc"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected multi-target import-scan package plan (Core before Host)"
    exit 1
  fi
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  if grep -Fq "SLAKE_DEPGRAPH_LINKED: 1" <<<"$env_out"; then
    if ! printf '%s' "$out" | grep -Fq "package-derived"; then
      echo "FAIL: linked driver must use freestanding package-derived plan"
      exit 1
    fi
    if ! printf '%s' "$out" | grep -Fq "import-scan"; then
      echo "FAIL: linked multi-module plan must claim import-scan DAG subset"
      exit 1
    fi
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: must not create .lake/build under PLAN_ONLY"
    exit 1
  fi
)

echo "systems_plan_smoke: OK"
