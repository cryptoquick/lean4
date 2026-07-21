#!/usr/bin/env bash
# Smoke: A29 sibling confining path [[require]] — monorepo `path = "../dep"`.
#
# Fixture require_sibling_shaped/app requires ../dep (sibling under package
# parent confining root). PLAN_ONLY identity shows path-require=1; A30 expands
# plan to require_sibling_app Dep App when App imports Dep. NATIVE_OLEAN /
# NATIVE_BUILD precompile dep oleans via A26
# walker with A29 resolve. Negatives: multi-.. escape path-require=0; bare ..
# path-require=0; absolute path-require=0; symlink sibling refuse under STRICT;
# mid-path .. refuse.
#
# Soft-SKIP if slake binary missing. Hard-fail when binary present and claim fails.
# SCORE / systems-validate do **not** run this smoke.
#
#   SLAKE_REQUIRE_SIBLING_SMOKE_STRICT=1 ./tests/slake/require_sibling_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/require_sibling_shaped/app"
DEP="$ROOT/require_sibling_shaped/dep"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_REQUIRE_SIBLING_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/App.lean" || ! -f "$DEP/Dep.lean" || ! -f "$DEP/lakefile.toml" ]]; then
  echo "FAIL: missing require_sibling_shaped package at $PKG / $DEP"
  exit 1
fi

if ! grep -Eq '^\[\[require\]\]' "$PKG/lakefile.toml"; then
  echo "FAIL: app lakefile must have [[require]]"
  exit 1
fi
if ! grep -Eq 'path[[:space:]]*=[[:space:]]*"\.\./dep"' "$PKG/lakefile.toml"; then
  echo "FAIL: app lakefile must path-require ../dep"
  exit 1
fi
if ! grep -Eq '^import Dep[[:space:]]*$' "$PKG/App.lean"; then
  echo "FAIL: App.lean must import Dep"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== A29 identity (env) sibling path-require =="
(
  cd "$PKG"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "name=require_sibling_app"; then
    echo "FAIL: expected name=require_sibling_app"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq 'require=1'; then
    echo "FAIL: expected require=1 in identity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq 'path-require=1'; then
    echo "FAIL: expected path-require=1 for sibling ../dep (A29)"
    exit 1
  fi
)

echo "== A29/A30 PLAN_ONLY plan (package-transitive subset when App imports Dep) =="
(
  cd "$PKG"
  rm -rf .slake-native "$DEP/.slake-native" .lake "$DEP/.lake" 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: PLAN_ONLY build failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing plan line"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: require_sibling_app Dep App( |$)'; then
    echo "FAIL: expected expanded plan 'require_sibling_app Dep App' (A30)"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'path-require=1'; then
    echo "FAIL: plan identity should mention path-require=1"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'sibling confining|A29 sibling|path \[\[require\]\]|package-transitive plan subset'; then
    echo "FAIL: expected A29 sibling / A30 honesty note in plan banner"
    exit 1
  fi
)

echo "== A29 NATIVE_OLEAN: sibling path-dep precompile + App olean =="
(
  cd "$PKG"
  rm -rf .slake-native "$DEP/.slake-native" .lake "$DEP/.lake" 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_OLEAN_STRICT=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: NATIVE_OLEAN build failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq 'A26 path-require olean precompile'; then
    echo "FAIL: expected A26 path-require olean precompile banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'A29 sibling confining|sibling confining \.\./path'; then
    echo "FAIL: precompile honesty should name A29 sibling confining for ../dep"
    exit 1
  fi
  if [[ ! -f "$DEP/.slake-native/Dep.olean" ]]; then
    echo "FAIL: missing dep/.slake-native/Dep.olean after sibling path-require precompile"
    exit 1
  fi
  if [[ ! -f .slake-native/App.olean ]]; then
    echo "FAIL: missing app/.slake-native/App.olean after root olean"
    exit 1
  fi
)

echo "== A29 NATIVE_BUILD skip-lake with sibling path require =="
(
  cd "$PKG"
  rm -rf .slake-native "$DEP/.slake-native" .lake "$DEP/.lake" 2>/dev/null || true
  export SLAKE_NATIVE_BUILD=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: NATIVE_BUILD failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq 'skipping lake after successful native olean compile'; then
    echo "FAIL: expected NATIVE_BUILD skip-lake banner"
    exit 1
  fi
  if [[ ! -f .slake-native/App.olean || ! -f "$DEP/.slake-native/Dep.olean" ]]; then
    echo "FAIL: NATIVE_BUILD must produce root + sibling dep oleans"
    exit 1
  fi
)

echo "== A29 nested sibling path ../packages/foo form =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  mkdir -p "$tmp/ws/app" "$tmp/ws/packages/foo"
  cat > "$tmp/ws/app/lakefile.toml" <<'TOML'
name = "nest_sib_app"
defaultTargets = ["App"]

[[require]]
name = "foo"
path = "../packages/foo"

[[lean_lib]]
name = "App"
TOML
  cat > "$tmp/ws/app/App.lean" <<'LEAN'
import Foo
def app := fooHello
LEAN
  cat > "$tmp/ws/packages/foo/lakefile.toml" <<'TOML'
name = "foo"
defaultTargets = ["Foo"]

[[lean_lib]]
name = "Foo"
TOML
  cat > "$tmp/ws/packages/foo/Foo.lean" <<'LEAN'
def fooHello : String := "foo"
LEAN
  cd "$tmp/ws/app"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_OLEAN_STRICT=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: nested sibling path olean failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'path-require=1'; then
    echo "FAIL: expected path-require=1 for ../packages/foo"
    exit 1
  fi
  if [[ ! -f "$tmp/ws/packages/foo/.slake-native/Foo.olean" ]]; then
    echo "FAIL: missing packages/foo Foo.olean after sibling confining resolve"
    exit 1
  fi
  if [[ ! -f .slake-native/App.olean ]]; then
    echo "FAIL: missing App.olean after nested sibling path require"
    exit 1
  fi
)

echo "== A29 negative: multi-.. escape path-require=0 =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  mkdir -p "$tmp/ws/app"
  cat > "$tmp/ws/app/lakefile.toml" <<'TOML'
name = "escape_req"
defaultTargets = ["App"]

[[require]]
name = "evil"
path = "../../escape"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/ws/app/App.lean"
  cd "$tmp/ws/app"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'require=1'; then
    echo "FAIL: multi-.. still counts as require header"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq 'path-require=0'; then
    echo "FAIL: multi-.. escape must not become path-require (expected path-require=0)"
    exit 1
  fi
)

echo "== A29 negative: bare .. path-require=0 =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "bare_dotdot"
defaultTargets = ["App"]

[[require]]
name = "parent"
path = ".."

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/App.lean"
  cd "$tmp"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'path-require=0'; then
    echo "FAIL: bare .. must not become path-require"
    exit 1
  fi
)

echo "== A29 negative: mid-path .. refuse path-require=0 =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "mid_dotdot"
defaultTargets = ["App"]

[[require]]
name = "sneak"
path = "foo/../bar"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/App.lean"
  cd "$tmp"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'path-require=0'; then
    echo "FAIL: mid-path .. must not become path-require"
    exit 1
  fi
)

echo "== A29 negative: absolute path still path-require=0 =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "abs_sib"
defaultTargets = ["App"]

[[require]]
name = "evil"
path = "/tmp/evil"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/App.lean"
  cd "$tmp"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'path-require=0'; then
    echo "FAIL: absolute path must not become path-require"
    exit 1
  fi
)

echo "== A29 negative: symlink sibling refuse under NATIVE_OLEAN_STRICT =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  mkdir -p "$tmp/ws/app" "$tmp/outside"
  cat > "$tmp/ws/app/lakefile.toml" <<'TOML'
name = "sym_sib"
defaultTargets = ["App"]

[[require]]
name = "link"
path = "../link"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/ws/app/App.lean"
  # Symlink escape: confining parent is ws/, but link → outside tree.
  ln -s "$tmp/outside" "$tmp/ws/link"
  printf 'name = "out"\ndefaultTargets = ["Out"]\n\n[[lean_lib]]\nname = "Out"\n' > "$tmp/outside/lakefile.toml"
  echo 'def o := 1' > "$tmp/outside/Out.lean"
  cd "$tmp/ws/app"
  set +e
  out="$(SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_OLEAN=1 SLAKE_NATIVE_OLEAN_STRICT=1 "$SLAKE_EXE" build 2>&1)"
  code=$?
  set -e
  printf '%s\n' "$out"
  if [[ "$code" -eq 0 ]]; then
    echo "FAIL: symlink sibling path require must fail-closed under OLEAN_STRICT"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'missing or not a directory|refuse symlink|A26 path require'; then
    echo "FAIL: expected symlink/not-a-directory refuse banner"
    exit 1
  fi
)

echo "== A29 honesty greps (help) =="
(
  help="$("$SLAKE_EXE" --help 2>&1)" || true
  if ! grep -Fq 'path [[require]]' <<<"$help"; then
    echo "FAIL: --help must mention path [[require]]"
    exit 1
  fi
  if ! grep -Eiq 'sibling confining|A29' <<<"$help"; then
    echo "FAIL: --help must mention A29 sibling confining"
    exit 1
  fi
  if ! grep -Eiq 'not git/url|not Lake resolve-deps' <<<"$help"; then
    echo "FAIL: --help must honesty-limit git/url / resolve-deps"
    exit 1
  fi
  if ! grep -Eiq 'multi-\.\.|multi-\.\. escape|not multi' <<<"$help"; then
    echo "FAIL: --help should honesty-limit multi-.. escape"
    exit 1
  fi
)

echo "OK: require_sibling_smoke (A29 sibling confining path [[require]] subset)"
exit 0
