#!/usr/bin/env bash
# Smoke: SLAKE_PLAN_ONLY=1 prints package-derived plan and skips lake (exit 0).
#
# Soft-skip when slake binary missing (parity-preserving).
# Hard-fail when binary present and claim fails.
# systems-validate SCORE does **not** run this smoke.
#
#   SLAKE_PLAN_ONLY_SMOKE_STRICT=1 ./tests/slake/plan_only_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/parity/basic_toml"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_PLAN_ONLY_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

echo "== SLAKE_PLAN_ONLY=1 (no lake spawn) on $PKG =="
(
  cd "$PKG"
  # Ensure no prior artifacts; PLAN_ONLY must not create .lake/build via lake.
  rm -rf .lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY build exited $rc (expected 0 without lake)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: basic_toml BasicToml"; then
    echo "FAIL: expected plan line with package name + target"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_PLAN_ONLY=1"; then
    echo "FAIL: expected PLAN_ONLY skip banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake"; then
    echo "FAIL: expected skipping lake message"
    exit 1
  fi
  # Must not have invoked a successful lake build artifact tree.
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build via lake"
    exit 1
  fi
)

echo "== SLAKE_DEPGRAPH=1 + SLAKE_PLAN_ONLY=1 (freestanding when linked) =="
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
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: basic_toml BasicToml"; then
    echo "FAIL: expected package plan under DEPGRAPH+PLAN_ONLY"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: DEPGRAPH+PLAN_ONLY must not create .lake/build"
    exit 1
  fi
  # Linked path should claim freestanding package-derived plan.
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  if grep -Fq "SLAKE_DEPGRAPH_LINKED: 1" <<<"$env_out"; then
    if ! printf '%s' "$out" | grep -Fq "package-derived"; then
      echo "FAIL: linked driver must print package-derived freestanding banner"
      exit 1
    fi
  fi
)

echo "plan_only_smoke: OK"
