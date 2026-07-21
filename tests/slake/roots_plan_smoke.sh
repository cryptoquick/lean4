#!/usr/bin/env bash
# Smoke: A16 per-lib roots + optional per-lib srcDir plan resolution.
#
# Package has no defaultTargets and no package-level srcDir. Plan modules come
# from [[lean_lib]] roots under srcDir = "lib". Beta imports Alpha → plan
# `roots_shaped Alpha Beta` (import-scan), not `Lib` alone and not package-root
# files.
#
# Soft-SKIP if slake binary missing. Hard-fail when binary present and claim fails.
# SCORE / systems-validate do **not** run this smoke.
#
#   SLAKE_ROOTS_PLAN_SMOKE_STRICT=1 ./tests/slake/roots_plan_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/roots_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_ROOTS_PLAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

assert_roots_plan() {
  local out="$1"
  local plan
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing 'slake depgraph plan:' line"
    return 1
  fi
  # Must not plan only the lib name Lib (pre-A16 leanLibNames fallback).
  if printf '%s' "$plan" | grep -Eq 'slake depgraph plan: roots_shaped Lib( |$)'; then
    echo "FAIL: plan is lean_lib name only (Lib); expected roots Alpha Beta"
    echo "  got: $plan"
    return 1
  fi
  # Golden: package name + Alpha then Beta (import-scan; Beta imports Alpha).
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: roots_shaped Alpha Beta( |$)'; then
    echo "FAIL: expected plan 'roots_shaped Alpha Beta'"
    echo "  got: $plan"
    return 1
  fi
  local alpha_pos beta_pos
  alpha_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Alpha$' | head -n1 | cut -d: -f1 || true)"
  beta_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Beta$' | head -n1 | cut -d: -f1 || true)"
  if [[ -z "$alpha_pos" || -z "$beta_pos" ]]; then
    echo "FAIL: plan must include both Alpha and Beta"
    echo "  got: $plan"
    return 1
  fi
  if ! [[ "$alpha_pos" -lt "$beta_pos" ]]; then
    echo "FAIL: expected Alpha before Beta in import-scan plan"
    echo "  got: $plan"
    return 1
  fi
  return 0
}

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/lib/Alpha.lean" || ! -f "$PKG/lib/Beta.lean" ]]; then
  echo "FAIL: missing roots_shaped package at $PKG"
  exit 1
fi

# Package-level keys only appear before the first table header (`[`).
# Per-lib `srcDir =` under `[[lean_lib]]` is expected for this dogfood.
pkg_level="$(awk 'BEGIN{p=1} /^[[:space:]]*\[/{p=0} p' "$PKG/lakefile.toml")"
if printf '%s\n' "$pkg_level" | grep -Eq '^[[:space:]]*srcDir[[:space:]]*='; then
  echo "FAIL: package-level srcDir must be absent (per-lib srcDir dogfood)"
  exit 1
fi

if printf '%s\n' "$pkg_level" | grep -Eq '^[[:space:]]*defaultTargets[[:space:]]*='; then
  echo "FAIL: defaultTargets must be absent (roots plan dogfood)"
  exit 1
fi

if ! grep -Eq 'roots[[:space:]]*=' "$PKG/lakefile.toml"; then
  echo "FAIL: lakefile.toml must set lean_lib roots"
  exit 1
fi
if ! grep -Eq 'srcDir[[:space:]]*=' "$PKG/lakefile.toml"; then
  echo "FAIL: lakefile.toml must set per-lib srcDir under [[lean_lib]]"
  exit 1
fi

if ! grep -Eq '^import Alpha[[:space:]]*$' "$PKG/lib/Beta.lean"; then
  echo "FAIL: lib/Beta.lean must import Alpha for this smoke"
  exit 1
fi

# Residual honesty: package-root modules must be absent (forces per-lib srcDir).
if [[ -f "$PKG/Alpha.lean" || -f "$PKG/Beta.lean" || -f "$PKG/Lib.lean" ]]; then
  echo "FAIL: package-root Alpha/Beta/Lib modules must not exist (per-lib srcDir dogfood)"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== A16 per-lib roots: SLAKE_PLAN_ONLY=1 on roots_shaped =="
(
  cd "$PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY exited $rc"
    exit 1
  fi
  assert_roots_plan "$out"
  if ! printf '%s' "$out" | grep -Eqi 'import-scan|import edge'; then
    echo "FAIL: expected import-scan honesty banner when Beta imports Alpha under per-lib srcDir"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'per-lib roots/srcDir|per-lib-roots/srcDir'; then
    echo "FAIL: expected per-lib roots/srcDir honesty in plan banner or identity"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
    exit 1
  fi
)

echo "== A16 per-lib roots: env identity reports per-lib marker =="
(
  cd "$PKG"
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq 'per-lib-roots/srcDir' <<<"$env_out"; then
    echo "FAIL: env identity must include per-lib-roots/srcDir for roots_shaped"
    exit 1
  fi
  # Must not advertise a package-level srcDir=lib (it is per-lib only).
  if grep -Eq 'srcDir=lib' <<<"$env_out"; then
    echo "FAIL: env must not print package-level srcDir=lib (per-lib only)"
    exit 1
  fi
)

echo "== A16 optional NATIVE_OLEAN under per-lib srcDir (when lean present) =="
(
  LEAN_PROBE="${LEAN:-lean}"
  if ! command -v "$LEAN_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEAN_PROBE" ]]; then
    echo "SKIP: host lean not found — NATIVE_OLEAN band soft-skip"
    exit 0
  fi
  cd "$PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_OLEAN exited $rc"
    exit 1
  fi
  assert_roots_plan "$out"
  if [[ ! -f .slake-native/Alpha.olean || ! -f .slake-native/Beta.olean ]]; then
    echo "FAIL: expected .slake-native/Alpha.olean and Beta.olean under per-lib resolve"
    ls -la .slake-native 2>/dev/null || true
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq -- '-R lib|lean -R lib'; then
    # Accept either argv dump form from native olean log line.
    if ! printf '%s' "$out" | grep -Fq -- '-R' || ! printf '%s' "$out" | grep -Fq 'lib/'; then
      echo "FAIL: expected lean -R lib for per-lib srcDir olean compile"
      exit 1
    fi
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
    exit 1
  fi
)

echo "== A16 path confinement: per-lib srcDir=.. must not escape =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-roots-escape.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg"
  # Modules only *outside* the package root — escape would open these via lib srcDir=".."
  cat >"$tmp/Alpha.lean" <<'EOF'
module
namespace Alpha
def marker : String := "escape_alpha"
end Alpha
EOF
  cat >"$tmp/Beta.lean" <<'EOF'
module
import Alpha
namespace Beta
def marker : String := "escape_beta"
end Beta
EOF
  cat >"$tmp/pkg/lakefile.toml" <<'EOF'
name = "escape_roots"
# No defaultTargets — plan from roots; unsafe per-lib srcDir must be ignored.

[[lean_lib]]
name = "Lib"
srcDir = ".."
roots = ["Alpha", "Beta"]
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: escape_roots PLAN_ONLY exited $rc (must stay fail-closed soft)"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing plan line for escape_roots"
    exit 1
  fi
  # Plan still lists roots labels; without readable package-local modules → declaration chain.
  if ! printf '%s' "$plan" | grep -Eq 'escape_roots Alpha Beta( |$)'; then
    echo "FAIL: expected confined declaration-order plan 'escape_roots Alpha Beta'"
    echo "  got: $plan"
    exit 1
  fi
  # Positive import-scan banner only (avoid matching residual "no package import edges").
  if printf '%s' "$out" | grep -Eqi 'import-scan DAG subset|[0-9]+ import edge\(s\) among'; then
    echo "FAIL: per-lib srcDir=.. escaped package (import-scan saw parent Alpha/Beta)"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'declaration-order|no package import edges|chain = declaration'; then
    echo "FAIL: expected declaration-order / no-edges honesty when per-lib srcDir is unsafe"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'srcDir=..'; then
    echo "FAIL: unsafe per-lib srcDir=.. must not appear in identity"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A16 path confinement: absolute per-lib srcDir must not escape =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-roots-escape-abs.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg" "$tmp/outside"
  # Modules only under absolute outside/ — escape would open these via per-lib abs srcDir.
  cat >"$tmp/outside/Alpha.lean" <<'EOF'
module
namespace Alpha
def marker : String := "abs_escape_alpha"
end Alpha
EOF
  cat >"$tmp/outside/Beta.lean" <<'EOF'
module
import Alpha
namespace Beta
def marker : String := "abs_escape_beta"
end Beta
EOF
  cat >"$tmp/pkg/lakefile.toml" <<EOF
name = "escape_roots_abs"
# No defaultTargets — plan from roots; absolute per-lib srcDir must be ignored.

[[lean_lib]]
name = "Lib"
srcDir = "$tmp/outside"
roots = ["Alpha", "Beta"]
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: escape_roots_abs PLAN_ONLY exited $rc (must stay fail-closed soft)"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing plan line for escape_roots_abs"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'escape_roots_abs Alpha Beta( |$)'; then
    echo "FAIL: expected confined declaration-order plan 'escape_roots_abs Alpha Beta'"
    echo "  got: $plan"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eqi 'import-scan DAG subset|[0-9]+ import edge\(s\) among'; then
    echo "FAIL: absolute per-lib srcDir escaped package (import-scan saw outside Alpha/Beta)"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'declaration-order|no package import edges|chain = declaration'; then
    echo "FAIL: expected declaration-order / no-edges honesty when per-lib srcDir is absolute"
    exit 1
  fi
  # Identity must not advertise the absolute outside path as srcDir=.
  if printf '%s' "$out" | grep -Fq "srcDir=$tmp/outside"; then
    echo "FAIL: absolute per-lib srcDir must not appear in identity"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eq 'srcDir=/'; then
    echo "FAIL: absolute srcDir= path leaked into identity/banner"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A16 regression: systems_shaped still defaultTargets plan (not roots) =="
(
  SYS="$ROOT/systems_shaped"
  if [[ ! -f "$SYS/lakefile.toml" ]]; then
    echo "FAIL: systems_shaped missing"
    exit 1
  fi
  cd "$SYS"
  rm -rf .lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: systems_shaped PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: systems_shaped Core Host( |$)'; then
    echo "FAIL: systems_shaped plan regression (expected systems_shaped Core Host)"
    echo "  got: $plan"
    exit 1
  fi
)

echo "roots_plan_smoke: OK"
