#!/usr/bin/env bash
# Smoke: A30 package-transitive plan subset — import-driven path-dep plan fold.
#
# After A26–A29, path-dep modules were precompiled + cascaded but never root plan
# nodes, so PLAN_ONLY could not show Dep before App among plan labels and
# import-scan edges could not form Dep → App among plan nodes.
#
# A30: when a root plan module imports a path-dep plan module name, fold that
# name into the root plan (import-driven subset only — not every dep plan
# module). Kahn orders Dep before App. Path-dep olean still under dep/.slake-native/.
#
# Honesty: package-transitive plan subset only — not Lake resolve-deps / not
# git/url / not freestanding build TCB / not CLAIMED. SCORE does **not** run this.
#
# Fixture reuse: tests/slake/require_path_shaped (App imports path-require Dep).
# Optional sibling band: require_sibling_shaped/app.
# Regression: systems_shaped plan unchanged (no path require).
#
#   SLAKE_REQUIRE_TRANSITIVE_PLAN_SMOKE_STRICT=1 ./tests/slake/require_transitive_plan_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/require_path_shaped"
SIB_APP="$ROOT/require_sibling_shaped/app"
SIB_DEP="$ROOT/require_sibling_shaped/dep"
SYS="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_REQUIRE_TRANSITIVE_PLAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_REQUIRE_PATH_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/App.lean" || ! -f "$PKG/dep/Dep.lean" ]]; then
  echo "FAIL: missing require_path_shaped package at $PKG"
  exit 1
fi
if ! grep -Eq '^import Dep[[:space:]]*$' "$PKG/App.lean"; then
  echo "FAIL: App.lean must import Dep"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== A30 PLAN_ONLY: package-transitive plan includes Dep before App =="
(
  cd "$PKG"
  rm -rf .slake-native dep/.slake-native .lake dep/.lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: PLAN_ONLY build failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing plan line"
    exit 1
  fi
  # Expanded plan: package + Dep + App with Dep before App (topo).
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: require_path_shaped Dep App( |$)'; then
    echo "FAIL: expected expanded plan 'require_path_shaped Dep App'"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'path-require=1'; then
    echo "FAIL: plan identity should mention path-require=1"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'package-transitive plan subset|A30 package-transitive'; then
    echo "FAIL: expected package-transitive plan subset honesty when expansion happened"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'not package-transitive plan into root'; then
    echo "FAIL: residual 'not package-transitive plan into root' must not remain after A30 when expansion active"
    exit 1
  fi
)

echo "== A30 identity still path-require=1 =="
(
  cd "$PKG"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  if ! printf '%s' "$out" | grep -Eq 'path-require=1'; then
    echo "FAIL: expected path-require=1 in env identity"
    exit 1
  fi
  # Identity path-require=1 is sufficient; A30 plan banner appears on PLAN_ONLY/NATIVE_* paths.
  if ! printf '%s' "$out" | grep -Eq 'path-require=1'; then
    echo "FAIL: env should show path-require=1"
    exit 1
  fi
)

echo "== A30 NATIVE_OLEAN: path-dep skip log + App olean + Dep under dep/ =="
(
  cd "$PKG"
  rm -rf .slake-native dep/.slake-native .lake dep/.lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_OLEAN_STRICT=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: NATIVE_OLEAN build failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq 'A26 path-require olean precompile'; then
    echo "FAIL: expected A26 path-require olean precompile banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'skip Dep \(path-dep plan node|path-dep plan node; olean under path-require'; then
    echo "FAIL: expected path-dep plan node skip log for Dep in root olean wave"
    exit 1
  fi
  if [[ ! -f dep/.slake-native/Dep.olean ]]; then
    echo "FAIL: missing dep/.slake-native/Dep.olean"
    exit 1
  fi
  if [[ ! -f .slake-native/App.olean ]]; then
    echo "FAIL: missing .slake-native/App.olean"
    exit 1
  fi
  # Root must not write Dep.olean under root outDir.
  if [[ -f .slake-native/Dep.olean ]]; then
    echo "FAIL: root must not compile Dep into .slake-native/Dep.olean (path-dep olean under dep/)"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: require_path_shaped Dep App( |$)'; then
    echo "FAIL: NATIVE_OLEAN plan must be require_path_shaped Dep App"
    echo "  got: $plan"
    exit 1
  fi
)

echo "== A30 NATIVE_BUILD skip-lake with expanded plan =="
(
  cd "$PKG"
  rm -rf .slake-native dep/.slake-native .lake dep/.lake 2>/dev/null || true
  export SLAKE_NATIVE_BUILD=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: NATIVE_BUILD failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq 'skipping lake after successful native olean compile'; then
    echo "FAIL: expected NATIVE_BUILD skip-lake banner"
    exit 1
  fi
  if [[ ! -f .slake-native/App.olean || ! -f dep/.slake-native/Dep.olean ]]; then
    echo "FAIL: NATIVE_BUILD must produce root App + dep Dep oleans"
    exit 1
  fi
)

echo "== A30 sibling fixture also expands plan when App imports Dep =="
(
  if [[ ! -f "$SIB_APP/App.lean" || ! -f "$SIB_DEP/Dep.lean" ]]; then
    echo "FAIL: missing require_sibling_shaped fixture"
    exit 1
  fi
  cd "$SIB_APP"
  rm -rf .slake-native "$SIB_DEP/.slake-native" .lake "$SIB_DEP/.lake" 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: sibling PLAN_ONLY failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: require_sibling_app Dep App( |$)'; then
    echo "FAIL: expected sibling expanded plan 'require_sibling_app Dep App'"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'package-transitive plan subset|A30 package-transitive'; then
    echo "FAIL: sibling expand must print package-transitive plan subset honesty"
    exit 1
  fi
)

echo "== A30 regression: systems_shaped plan unchanged (no path require) =="
(
  if [[ ! -f "$SYS/lakefile.toml" ]]; then
    echo "FAIL: missing systems_shaped"
    exit 1
  fi
  cd "$SYS"
  export SLAKE_PLAN_ONLY=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: systems PLAN_ONLY failed"; printf '%s\n' "$out"; exit 1; }
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: systems_shaped Core Host( |$)'; then
    echo "FAIL: systems_shaped plan regression — expected systems_shaped Core Host"
    echo "  got: $plan"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'package-transitive plan subset'; then
    echo "FAIL: systems_shaped must not claim package-transitive plan expand (no path require)"
    exit 1
  fi
)

echo "== A30 help honesty =="
(
  help="$("$SLAKE_EXE" --help 2>&1)" || true
  if ! grep -Eiq 'package-transitive plan subset|A30' <<<"$help"; then
    echo "FAIL: --help must mention A30 package-transitive plan subset"
    exit 1
  fi
)

echo "PASS: require_transitive_plan_smoke (A30 package-transitive plan subset)"
