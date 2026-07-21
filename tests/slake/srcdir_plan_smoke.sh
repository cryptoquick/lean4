#!/usr/bin/env bash
# Smoke: A6 srcDir / nested / dotted source-root plan resolution + path confinement.
#
# Package sources live under src/ (srcDir = "src"). Host meta-imports Foo.Bar;
# declaration order lists Host first. Plan must resolve src/Host.lean +
# src/Foo/Bar.lean and emit Foo.Bar before Host (import-scan DAG), not Host before
# Foo.Bar (declaration chain).
#
# Soft-SKIP if slake binary missing. Hard-fail when binary present and claim fails.
# SCORE / systems-validate do **not** run this smoke.
#
#   SLAKE_SRCDIR_PLAN_SMOKE_STRICT=1 ./tests/slake/srcdir_plan_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/srcdir_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_SRCDIR_PLAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

# Assert plan line lists Foo.Bar before Host (import edge under srcDir), not Host first.
assert_foo_bar_before_host() {
  local out="$1"
  local plan
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing 'slake depgraph plan:' line"
    return 1
  fi
  if printf '%s' "$plan" | grep -Eq 'slake depgraph plan: srcdir_shaped Host Foo\.Bar( |$)'; then
    echo "FAIL: plan is declaration-order chain (Host before Foo.Bar); expected srcDir/dotted import-scan Foo.Bar before Host"
    echo "  got: $plan"
    return 1
  fi
  local foo_pos host_pos
  # Tokenize plan line; Foo.Bar is a single plan-node token.
  foo_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Foo\.Bar$' | head -n1 | cut -d: -f1 || true)"
  host_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Host$' | head -n1 | cut -d: -f1 || true)"
  if [[ -z "$foo_pos" || -z "$host_pos" ]]; then
    echo "FAIL: plan must include both Foo.Bar and Host"
    echo "  got: $plan"
    return 1
  fi
  if ! [[ "$foo_pos" -lt "$host_pos" ]]; then
    echo "FAIL: expected Foo.Bar before Host in srcDir/dotted import-scan plan"
    echo "  got: $plan"
    return 1
  fi
  # Golden full plan: package name + Foo.Bar then Host
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: srcdir_shaped Foo\.Bar Host( |$)'; then
    echo "FAIL: expected plan 'srcdir_shaped Foo.Bar Host'"
    echo "  got: $plan"
    return 1
  fi
  return 0
}

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/src/Host.lean" || ! -f "$PKG/src/Foo/Bar.lean" ]]; then
  echo "FAIL: missing srcdir_shaped package at $PKG"
  exit 1
fi

if ! grep -Eq '^srcDir[[:space:]]*=' "$PKG/lakefile.toml"; then
  echo "FAIL: lakefile.toml must set srcDir for this smoke"
  exit 1
fi

if ! grep -Eq '^meta import Foo\.Bar[[:space:]]*$' "$PKG/src/Host.lean"; then
  echo "FAIL: src/Host.lean must use 'meta import Foo.Bar' for this smoke"
  exit 1
fi

if ! grep -Fq 'Foo.Bar' "$PKG/lakefile.toml"; then
  echo "FAIL: lakefile.toml must list dotted plan node Foo.Bar"
  exit 1
fi

# Residual honesty: package-root modules must be absent (forces srcDir resolution).
if [[ -f "$PKG/Host.lean" || -f "$PKG/Foo.Bar.lean" || -d "$PKG/Foo" ]]; then
  echo "FAIL: package-root Host/Foo modules must not exist (srcDir dogfood)"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== A6 srcDir+dotted plan: SLAKE_PLAN_ONLY=1 on srcdir_shaped =="
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
  assert_foo_bar_before_host "$out"
  # Banner must claim import-scan and mention srcDir/nested path resolution used.
  if ! printf '%s' "$out" | grep -Eqi 'import-scan|import edge'; then
    echo "FAIL: expected import-scan honesty banner when Host meta-imports Foo.Bar under srcDir"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'srcDir/nested path resolution used|srcDir=src'; then
    echo "FAIL: expected srcDir/nested path resolution honesty in plan banner (srcDir present)"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
    exit 1
  fi
)

echo "== A6 srcDir+dotted plan: SLAKE_DEPGRAPH=1 + PLAN_ONLY (freestanding when linked) =="
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
  assert_foo_bar_before_host "$out"
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
  if ! grep -Fq 'srcDir=src' <<<"$env_out"; then
    echo "FAIL: env identity must include srcDir=src for srcdir_shaped"
    echo "$env_out"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: must not create .lake/build under PLAN_ONLY"
    exit 1
  fi
)

echo "== A6 path confinement: srcDir=.. must not read outside package =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-escape.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg"
  # Modules only *outside* the package root — escape would open these via srcDir=".."
  cat >"$tmp/Host.lean" <<'EOF'
module
import Core
namespace Host
def marker : String := "escape_host"
end Host
EOF
  cat >"$tmp/Core.lean" <<'EOF'
module
namespace Core
def marker : String := "escape_core"
end Core
EOF
  cat >"$tmp/pkg/lakefile.toml" <<'EOF'
name = "escape_pkg"
srcDir = ".."
defaultTargets = ["Host", "Core"]

[[lean_lib]]
name = "Host"

[[lean_lib]]
name = "Core"
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: escape_pkg PLAN_ONLY exited $rc (must stay fail-closed soft)"
    exit 1
  fi
  # Unsafe srcDir ignored → no package-local modules → declaration-order chain.
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing plan line for escape_pkg"
    exit 1
  fi
  if printf '%s' "$plan" | grep -Eq 'escape_pkg Core Host( |$)'; then
    echo "FAIL: srcDir=.. escaped package (import-scan saw parent Host/Core)"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'escape_pkg Host Core( |$)'; then
    echo "FAIL: expected confined declaration-order plan 'escape_pkg Host Core'"
    echo "  got: $plan"
    exit 1
  fi
  # Identity must not advertise unsafe srcDir=..
  if printf '%s' "$out" | grep -Fq 'srcDir=..'; then
    echo "FAIL: unsafe srcDir=.. must not appear in identity"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A6 path confinement: absolute srcDir must not escape =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-escape-abs.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg" "$tmp/outside"
  cat >"$tmp/outside/Host.lean" <<'EOF'
module
import Core
namespace Host
def marker : String := "abs_escape_host"
end Host
EOF
  cat >"$tmp/outside/Core.lean" <<'EOF'
module
namespace Core
def marker : String := "abs_escape_core"
end Core
EOF
  # Absolute srcDir pointing at outside/
  cat >"$tmp/pkg/lakefile.toml" <<EOF
name = "escape_abs"
srcDir = "$tmp/outside"
defaultTargets = ["Host", "Core"]

[[lean_lib]]
name = "Host"

[[lean_lib]]
name = "Core"
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: escape_abs PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if printf '%s' "$plan" | grep -Eq 'escape_abs Core Host( |$)'; then
    echo "FAIL: absolute srcDir escaped package tree"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'escape_abs Host Core( |$)'; then
    echo "FAIL: expected confined plan 'escape_abs Host Core'"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "srcdir_plan_smoke: OK"
