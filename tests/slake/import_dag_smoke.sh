#!/usr/bin/env bash
# Smoke: package import-scan DAG plan (Host imports Core; declaration order Host first).
#
# Proves freestanding plan is **not** pure declaration-order chain when package-local
# import edges exist: plan must list Core before Host.
#
# Soft-SKIP if slake binary missing. Hard-fail when binary present and claim fails.
# SCORE / systems-validate do **not** run this smoke.
#
#   SLAKE_IMPORT_DAG_SMOKE_STRICT=1 ./tests/slake/import_dag_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_IMPORT_DAG_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

# Assert plan line lists Core before Host (import edge), not Host before Core (chain).
assert_core_before_host() {
  local out="$1"
  local plan
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing 'slake depgraph plan:' line"
    return 1
  fi
  # Chain-only (wrong): systems_shaped Host Core
  if printf '%s' "$plan" | grep -Eq 'slake depgraph plan: systems_shaped Host Core( |$)'; then
    echo "FAIL: plan is declaration-order chain (Host before Core); expected import-scan Core before Host"
    echo "  got: $plan"
    return 1
  fi
  # Core must appear before Host on the plan line.
  local core_pos host_pos
  core_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Core$' | head -n1 | cut -d: -f1 || true)"
  host_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Host$' | head -n1 | cut -d: -f1 || true)"
  if [[ -z "$core_pos" || -z "$host_pos" ]]; then
    echo "FAIL: plan must include both Core and Host"
    echo "  got: $plan"
    return 1
  fi
  if ! [[ "$core_pos" -lt "$host_pos" ]]; then
    echo "FAIL: expected Core before Host in import-scan plan"
    echo "  got: $plan"
    return 1
  fi
  return 0
}

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/Host.lean" ]]; then
  echo "FAIL: missing systems_shaped package at $PKG"
  exit 1
fi

if ! grep -Eq '^import Core[[:space:]]*$' "$PKG/Host.lean"; then
  echo "FAIL: Host.lean must import Core for this smoke"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== import DAG: SLAKE_PLAN_ONLY=1 on systems_shaped =="
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
  assert_core_before_host "$out"
  # Banner must claim import-scan when freestanding linked or host path with edges.
  if ! printf '%s' "$out" | grep -Eqi 'import-scan|import edge'; then
    echo "FAIL: expected import-scan honesty banner when Host imports Core"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
    exit 1
  fi
)

echo "== import DAG: SLAKE_DEPGRAPH=1 + PLAN_ONLY (freestanding when linked) =="
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
  assert_core_before_host "$out"
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  if grep -Fq "SLAKE_DEPGRAPH_LINKED: 1" <<<"$env_out"; then
    if ! printf '%s' "$out" | grep -Fq "package-derived"; then
      echo "FAIL: linked driver must use freestanding package-derived plan"
      exit 1
    fi
    if ! printf '%s' "$out" | grep -Fq "import-scan"; then
      echo "FAIL: linked path must print import-scan DAG subset banner"
      exit 1
    fi
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: must not create .lake/build under PLAN_ONLY"
    exit 1
  fi
)

echo "import_dag_smoke: OK"
