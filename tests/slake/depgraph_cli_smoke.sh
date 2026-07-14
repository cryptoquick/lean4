#!/usr/bin/env bash
# Smoke: SLAKE_DEPGRAPH=1 slake build prints freestanding DepGraph plan.
# Default path (flag unset) is covered by parity — this only exercises the flag.
#
# Soft-skip honesty: without a linked driver/extract, exits 0 SKIP (parity-preserving).
# systems-validate SCORE does **not** run this smoke — green SCORE alone does not prove
# DepGraph CLI wiring. Opt-in hard fail when linked plan path is expected:
#   SLAKE_DEPGRAPH_SMOKE_STRICT=1 ./tests/slake/depgraph_cli_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/parity/basic_toml"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

if ! command -v lake >/dev/null 2>&1; then
  strict_fail "lake not on PATH"
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

# Require env to report DEPGRAPH linked (Option C link present).
env_out="$("$SLAKE_EXE" env 2>&1)" || true
if ! printf '%s' "$env_out" | grep -Fq "SLAKE_DEPGRAPH_LINKED: 1"; then
  printf '%s\n' "$env_out"
  strict_fail "slake not linked with freestanding DepGraph shim (rebuild driver after systems extract)"
fi

echo "== SLAKE_DEPGRAPH=1 build on $PKG =="
(
  cd "$PKG"
  lake clean || true
  export SLAKE_DEPGRAPH=1
  # Keep default IO.Process lake path so smoke does not require FS_PROC success.
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: C B A"; then
    echo "FAIL: expected plan line 'slake depgraph plan: C B A'"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding DepGraph"; then
    echo "FAIL: expected freestanding DepGraph banner"
    exit 1
  fi
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: slake build exited $rc under SLAKE_DEPGRAPH=1"
    exit 1
  fi
  if [[ ! -d .lake/build ]]; then
    echo "FAIL: expected .lake/build after depgraph-plan build"
    exit 1
  fi
  "$SLAKE_EXE" clean >/dev/null
)

# Default path must not print plan (parity honesty).
echo "== default build (no DEPGRAPH) must not print plan =="
(
  cd "$PKG"
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  if printf '%s' "$out" | grep -Fq "slake depgraph plan:"; then
    echo "FAIL: plan printed without SLAKE_DEPGRAPH=1"
    exit 1
  fi
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: default slake build exited $rc"
    exit 1
  fi
  "$SLAKE_EXE" clean >/dev/null
)

echo "depgraph_cli_smoke: OK"
