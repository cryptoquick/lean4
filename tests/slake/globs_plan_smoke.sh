#!/usr/bin/env bash
# Smoke: A24/A25 per-lib globs recursive multi-level subset for plan expansion.
#
# Package has no defaultTargets and no package-level srcDir. Plan modules come
# from [[lean_lib]] globs = ["Core.*"] under srcDir = "lib" (Core + recursive
# children Core.Extra + Core.Nested.Deep). Extra imports Core; Deep imports
# Extra → plan `globs_shaped Core Core.Extra Core.Nested.Deep` (import-scan).
#
# Soft-SKIP if slake binary missing. Hard-fail when binary present and claim fails.
# SCORE / systems-validate do **not** run this smoke.
#
#   SLAKE_GLOBS_PLAN_SMOKE_STRICT=1 ./tests/slake/globs_plan_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/globs_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_GLOBS_PLAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_ROOTS_PLAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

assert_globs_plan() {
  local out="$1"
  local plan
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing 'slake depgraph plan:' line"
    return 1
  fi
  # Must not plan only the lib name Lib (pre-A24 leanLibNames fallback).
  if printf '%s' "$plan" | grep -Eq 'slake depgraph plan: globs_shaped Lib( |$)'; then
    echo "FAIL: plan is lean_lib name only (Lib); expected globs Core Core.Extra Core.Nested.Deep"
    echo "  got: $plan"
    return 1
  fi
  # Golden: package name + Core then Core.Extra then Core.Nested.Deep (import-scan).
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: globs_shaped Core Core\.Extra Core\.Nested\.Deep( |$)'; then
    echo "FAIL: expected plan 'globs_shaped Core Core.Extra Core.Nested.Deep'"
    echo "  got: $plan"
    return 1
  fi
  local core_pos extra_pos deep_pos
  core_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Core$' | head -n1 | cut -d: -f1 || true)"
  extra_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Core\.Extra$' | head -n1 | cut -d: -f1 || true)"
  deep_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Core\.Nested\.Deep$' | head -n1 | cut -d: -f1 || true)"
  if [[ -z "$core_pos" || -z "$extra_pos" || -z "$deep_pos" ]]; then
    echo "FAIL: plan must include Core, Core.Extra, and Core.Nested.Deep"
    echo "  got: $plan"
    return 1
  fi
  if ! [[ "$core_pos" -lt "$extra_pos" && "$extra_pos" -lt "$deep_pos" ]]; then
    echo "FAIL: expected Core before Core.Extra before Core.Nested.Deep in import-scan plan"
    echo "  got: $plan"
    return 1
  fi
  return 0
}

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/lib/Core.lean" || ! -f "$PKG/lib/Core/Extra.lean" || ! -f "$PKG/lib/Core/Nested/Deep.lean" ]]; then
  echo "FAIL: missing globs_shaped package (need Core + Extra + Nested/Deep) at $PKG"
  exit 1
fi

# Package-level keys only appear before the first table header (`[`).
pkg_level="$(awk 'BEGIN{p=1} /^[[:space:]]*\[/{p=0} p' "$PKG/lakefile.toml")"
if printf '%s\n' "$pkg_level" | grep -Eq '^[[:space:]]*srcDir[[:space:]]*='; then
  echo "FAIL: package-level srcDir must be absent (per-lib srcDir dogfood)"
  exit 1
fi

if printf '%s\n' "$pkg_level" | grep -Eq '^[[:space:]]*defaultTargets[[:space:]]*='; then
  echo "FAIL: defaultTargets must be absent (globs plan dogfood)"
  exit 1
fi

if ! grep -Eq 'globs[[:space:]]*=' "$PKG/lakefile.toml"; then
  echo "FAIL: lakefile.toml must set lean_lib globs"
  exit 1
fi
if ! grep -Eq 'srcDir[[:space:]]*=' "$PKG/lakefile.toml"; then
  echo "FAIL: lakefile.toml must set per-lib srcDir under [[lean_lib]]"
  exit 1
fi

if ! grep -Eq '^import Core[[:space:]]*$' "$PKG/lib/Core/Extra.lean"; then
  echo "FAIL: lib/Core/Extra.lean must import Core for this smoke"
  exit 1
fi
if ! grep -Eq '^import Core\.Extra[[:space:]]*$' "$PKG/lib/Core/Nested/Deep.lean"; then
  echo "FAIL: lib/Core/Nested/Deep.lean must import Core.Extra for this smoke"
  exit 1
fi

# Residual honesty: package-root modules must be absent (forces per-lib srcDir).
if [[ -f "$PKG/Core.lean" || -f "$PKG/Lib.lean" ]]; then
  echo "FAIL: package-root Core/Lib modules must not exist (per-lib srcDir dogfood)"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== A24/A25 per-lib globs recursive multi-level: SLAKE_PLAN_ONLY=1 on globs_shaped =="
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
  assert_globs_plan "$out"
  if ! printf '%s' "$out" | grep -Eqi 'import-scan|import edge'; then
    echo "FAIL: expected import-scan honesty banner when nested globs modules import each other"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'per-lib globs|per-lib-globs'; then
    echo "FAIL: expected per-lib globs honesty in plan banner or identity"
    exit 1
  fi
  # A25: banner should name recursive multi-level subset (not over-claim full Lake).
  if ! printf '%s' "$out" | grep -Eqi 'recursive multi-level|multi-level subset|recursive.*glob'; then
    # Accept identity marker path if banner uses shorter form + residual negation.
    if ! printf '%s' "$out" | grep -Eqi 'per-lib globs recursive|globs recursive multi-level'; then
      echo "FAIL: expected recursive multi-level honesty in plan banner"
      exit 1
    fi
  fi
  # Must not over-claim full Lake Glob / freestanding TCB / CLAIMED.
  if printf '%s' "$out" | grep -Eqi 'full Lake Glob' && ! printf '%s' "$out" | grep -Eqi 'not full Lake Glob|≠ full Lake Glob'; then
    echo "FAIL: plan output must not claim full Lake Glob without negation"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'not full Lake|not freestanding|not CLAIMED|≠ full Lake|not build TCB'; then
    echo "FAIL: expected residual honesty (not full Lake / not freestanding / not CLAIMED)"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
    exit 1
  fi
)

echo "== A24/A25 per-lib globs: env identity reports per-lib-globs marker =="
(
  cd "$PKG"
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq 'per-lib-globs' <<<"$env_out"; then
    echo "FAIL: env identity must include per-lib-globs for globs_shaped"
    exit 1
  fi
  # Must not advertise a package-level srcDir=lib (it is per-lib only).
  if grep -Eq 'srcDir=lib' <<<"$env_out"; then
    echo "FAIL: env must not print package-level srcDir=lib (per-lib only)"
    exit 1
  fi
)

echo "== A24 multi-line globs array band =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-globs-ml.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg/lib"
  cat >"$tmp/pkg/lib/Alpha.lean" <<'EOF'
module
namespace Alpha
def marker : String := "ml_alpha"
end Alpha
EOF
  cat >"$tmp/pkg/lib/Beta.lean" <<'EOF'
module
import Alpha
namespace Beta
def marker : String := "ml_beta"
end Beta
EOF
  cat >"$tmp/pkg/lakefile.toml" <<'EOF'
name = "ml_globs"
# No defaultTargets — multi-line globs ones.

[[lean_lib]]
name = "Lib"
srcDir = "lib"
globs = [
  "Alpha",
  "Beta",
]
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: multi-line globs PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: ml_globs Alpha Beta( |$)'; then
    echo "FAIL: expected multi-line globs plan 'ml_globs Alpha Beta'"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'per-lib globs|per-lib-globs'; then
    echo "FAIL: expected per-lib globs honesty for multi-line ones"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A24/A25 submodules glob M.+ : children only (exclude self; multi-level) =="
(
  # Product claim: "M.+" → submodules only (recursive), not M itself.
  # Immediate + nested children must both appear; self excluded.
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-globs-plus.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg/lib/Alpha/Nested"
  cat >"$tmp/pkg/lib/Alpha.lean" <<'EOF'
module
namespace Alpha
def marker : String := "plus_alpha"
end Alpha
EOF
  cat >"$tmp/pkg/lib/Alpha/Child.lean" <<'EOF'
module
import Alpha
namespace Alpha.Child
def marker : String := "plus_child"
end Alpha.Child
EOF
  cat >"$tmp/pkg/lib/Alpha/Nested/Deep.lean" <<'EOF'
module
import Alpha.Child
namespace Alpha.Nested.Deep
def marker : String := "plus_deep"
end Alpha.Nested.Deep
EOF
  cat >"$tmp/pkg/lakefile.toml" <<'EOF'
name = "plus_globs"
# No defaultTargets — globs = ["Alpha.+"] children only (not Alpha), recursive.

[[lean_lib]]
name = "Lib"
srcDir = "lib"
globs = ["Alpha.+"]
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: plus_globs PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  # Must include Alpha.Child (immediate) and Alpha.Nested.Deep (multi-level).
  if ! printf '%s' "$plan" | grep -Eq 'Alpha\.Child'; then
    echo "FAIL: expected Alpha.Child from globs = [\"Alpha.+\"] recursive walk"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'Alpha\.Nested\.Deep'; then
    echo "FAIL: expected Alpha.Nested.Deep multi-level child from Alpha.+"
    echo "  got: $plan"
    exit 1
  fi
  # Must NOT include bare Alpha as a plan module (.+ excludes self).
  if printf '%s' "$plan" | tr ' ' '\n' | grep -Eq '^Alpha$'; then
    echo "FAIL: Alpha.+ must exclude self Alpha from plan nodes (children only)"
    echo "  got: $plan"
    exit 1
  fi
  # Golden: package + children only (import-scan Child before Nested.Deep).
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: plus_globs Alpha\.Child Alpha\.Nested\.Deep( |$)'; then
    echo "FAIL: expected plan 'plus_globs Alpha.Child Alpha.Nested.Deep'"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'per-lib globs|per-lib-globs'; then
    echo "FAIL: expected per-lib globs honesty for M.+ band"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A24 path-escape: glob with .. filtered =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-globs-escape.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg/lib"
  cat >"$tmp/pkg/lib/Safe.lean" <<'EOF'
module
namespace Safe
def marker : String := "safe"
end Safe
EOF
  cat >"$tmp/pkg/lakefile.toml" <<'EOF'
name = "escape_globs"
# No defaultTargets — unsafe glob base filtered; safe one remains.

[[lean_lib]]
name = "Lib"
srcDir = "lib"
globs = ["..", "Safe", "Evil..+", "Foo/Bar"]
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: escape_globs PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'escape_globs Safe( |$)'; then
    echo "FAIL: expected confined plan 'escape_globs Safe' (unsafe globs filtered)"
    echo "  got: $plan"
    exit 1
  fi
  if printf '%s' "$plan" | grep -Eq '\.\.|Foo/Bar|Evil'; then
    echo "FAIL: unsafe glob tokens leaked into plan"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A24 roots still win over globs when both set =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-roots-win-globs.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg/lib"
  cat >"$tmp/pkg/lib/Alpha.lean" <<'EOF'
module
namespace Alpha
def marker : String := "alpha"
end Alpha
EOF
  cat >"$tmp/pkg/lib/Beta.lean" <<'EOF'
module
import Alpha
namespace Beta
def marker : String := "beta"
end Beta
EOF
  cat >"$tmp/pkg/lib/Gamma.lean" <<'EOF'
module
namespace Gamma
def marker : String := "gamma"
end Gamma
EOF
  cat >"$tmp/pkg/lakefile.toml" <<'EOF'
name = "roots_win"
# No defaultTargets — roots win over globs on same lib.

[[lean_lib]]
name = "Lib"
srcDir = "lib"
roots = ["Alpha", "Beta"]
globs = ["Gamma"]
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: roots_win PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'roots_win Alpha Beta( |$)'; then
    echo "FAIL: expected roots to win: plan 'roots_win Alpha Beta'"
    echo "  got: $plan"
    exit 1
  fi
  if printf '%s' "$plan" | grep -Eq 'Gamma'; then
    echo "FAIL: globs must not contribute when roots non-empty"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A24/A25 optional NATIVE_OLEAN under globs_shaped (when lean present) =="
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
  assert_globs_plan "$out"
  if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Core/Extra.olean || ! -f .slake-native/Core/Nested/Deep.olean ]]; then
    echo "FAIL: expected .slake-native/Core.olean, Core/Extra.olean, Core/Nested/Deep.olean under globs resolve"
    ls -laR .slake-native 2>/dev/null || true
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
    exit 1
  fi
)

echo "== A24 regression: roots_shaped still roots plan (no globs) =="
(
  ROOTS_PKG="$ROOT/roots_shaped"
  if [[ ! -f "$ROOTS_PKG/lakefile.toml" ]]; then
    echo "FAIL: roots_shaped missing"
    exit 1
  fi
  cd "$ROOTS_PKG"
  rm -rf .lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: roots_shaped PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: roots_shaped Alpha Beta( |$)'; then
    echo "FAIL: roots_shaped plan regression (expected roots_shaped Alpha Beta)"
    echo "  got: $plan"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'per-lib-globs'; then
    echo "FAIL: roots_shaped must not report per-lib-globs"
    exit 1
  fi
)

echo "== A24 regression: systems_shaped still defaultTargets plan =="
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

echo "== A25 path confinement: dir symlink outside pkg not walked =="
(
  # lib/Alpha/escape → $outside with Outside.lean must not become Alpha.escape.Outside.
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-globs-symlink.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  outside="$tmp/outside"
  mkdir -p "$outside" "$tmp/pkg/lib/Alpha"
  cat >"$outside/Outside.lean" <<'EOF'
module
namespace Outside
def marker : String := "escaped"
end Outside
EOF
  cat >"$tmp/pkg/lib/Alpha.lean" <<'EOF'
module
namespace Alpha
def marker : String := "sym_alpha"
end Alpha
EOF
  cat >"$tmp/pkg/lib/Alpha/Child.lean" <<'EOF'
module
import Alpha
namespace Alpha.Child
def marker : String := "sym_child"
end Alpha.Child
EOF
  # Directory symlink that would escape the package if followed.
  ln -s "$outside" "$tmp/pkg/lib/Alpha/escape"
  cat >"$tmp/pkg/lakefile.toml" <<'EOF'
name = "symlink_globs"
# No defaultTargets — Alpha.* must not pull Outside via dir symlink.

[[lean_lib]]
name = "Lib"
srcDir = "lib"
globs = ["Alpha.*"]
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: symlink_globs PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'Alpha\.Child'; then
    echo "FAIL: expected Alpha.Child from real dir walk under symlink band"
    echo "  got: $plan"
    exit 1
  fi
  if printf '%s' "$plan" | grep -Eqi 'Outside|escape'; then
    echo "FAIL: dir symlink escape leaked into plan (path confinement)"
    echo "  got: $plan"
    exit 1
  fi
  # Golden: package + Alpha + Child only (sorted/import-scan); no Outside.
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: symlink_globs Alpha Alpha\.Child( |$)'; then
    echo "FAIL: expected plan 'symlink_globs Alpha Alpha.Child' (no escape)"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A25 bounds: maxGlobWalkDirDepth over-cap leaf soft-skipped =="
(
  # Nested dirs deeper than maxGlobWalkDirDepth (16) must not contribute plan nodes.
  # Fuel semantics: base dir processed with fuel 16; nth nested dir entered with fuel 16-n;
  # fuel 0 → no readDir. File under 17 nested dirs is absent; shallow Child remains.
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-globs-depth.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/pkg/lib/Alpha"
  cat >"$tmp/pkg/lib/Alpha.lean" <<'EOF'
module
namespace Alpha
def marker : String := "depth_alpha"
end Alpha
EOF
  cat >"$tmp/pkg/lib/Alpha/Child.lean" <<'EOF'
module
import Alpha
namespace Alpha.Child
def marker : String := "depth_child"
end Alpha.Child
EOF
  # 17 nested dirs: n1/n2/.../n17/Deep.lean — over maxGlobWalkDirDepth=16.
  deep_path="$tmp/pkg/lib/Alpha"
  for i in $(seq 1 17); do
    deep_path="$deep_path/n$i"
  done
  mkdir -p "$deep_path"
  cat >"$deep_path/Deep.lean" <<'EOF'
module
namespace OverDepth
def marker : String := "too_deep"
end OverDepth
EOF
  cat >"$tmp/pkg/lakefile.toml" <<'EOF'
name = "depth_globs"
# No defaultTargets — Alpha.* must include Child, not over-depth leaf.

[[lean_lib]]
name = "Lib"
srcDir = "lib"
globs = ["Alpha.*"]
EOF
  cd "$tmp/pkg"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: depth_globs PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'Alpha\.Child'; then
    echo "FAIL: expected shallow Alpha.Child under depth-bound band"
    echo "  got: $plan"
    exit 1
  fi
  if printf '%s' "$plan" | grep -Eq 'Deep|n17|n16\.n17'; then
    echo "FAIL: over-depth nested leaf leaked into plan (maxGlobWalkDirDepth)"
    echo "  got: $plan"
    exit 1
  fi
  # Must not expand into a huge n1.n2... chain either.
  if printf '%s' "$plan" | grep -Eq 'Alpha\.n1'; then
    # Intermediate empty dirs alone should not emit modules; if any n* module
    # appears without a .lean at that level it would be a bug. Soft assert:
    echo "FAIL: unexpected Alpha.n1* module from empty intermediate dirs"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: depth_globs Alpha Alpha\.Child( |$)'; then
    echo "FAIL: expected plan 'depth_globs Alpha Alpha.Child'"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "globs_plan_smoke: OK"
