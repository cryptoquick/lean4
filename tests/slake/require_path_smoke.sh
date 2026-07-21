#!/usr/bin/env bash
# Smoke: A26 path [[require]] subset — LEAN_PATH feed + path-dep olean precompile.
#
# Root require_path_shaped requires path dep/ with module Dep; App imports Dep.
# PLAN_ONLY identity shows require=1 path-require=1; A30 expands plan to
# require_path_shaped Dep App when App imports Dep. NATIVE_OLEAN / NATIVE_BUILD /
# NATIVE_CHECK-only precompile dep oleans (single walker). Nested depth-2 temp fixture.
# Negatives: absolute/`..` path-require=0; missing/file/symlink not-a-dir
# fail-closed under STRICT/BUILD; require-cap=16 truncated fail-closed.
#
# Soft-SKIP if slake binary missing. Hard-fail when binary present and claim fails.
# SCORE / systems-validate do **not** run this smoke.
#
#   SLAKE_REQUIRE_PATH_SMOKE_STRICT=1 ./tests/slake/require_path_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/require_path_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_REQUIRE_PATH_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/App.lean" || ! -f "$PKG/dep/Dep.lean" || ! -f "$PKG/dep/lakefile.toml" ]]; then
  echo "FAIL: missing require_path_shaped package at $PKG"
  exit 1
fi

if ! grep -Eq '^\[\[require\]\]' "$PKG/lakefile.toml"; then
  echo "FAIL: root lakefile must have [[require]]"
  exit 1
fi
if ! grep -Eq 'path[[:space:]]*=[[:space:]]*"dep"' "$PKG/lakefile.toml"; then
  echo "FAIL: root lakefile must path-require dep"
  exit 1
fi
if ! grep -Eq '^import Dep[[:space:]]*$' "$PKG/App.lean"; then
  echo "FAIL: App.lean must import Dep"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== A26 identity (env) require + path-require =="
(
  cd "$PKG"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "name=require_path_shaped"; then
    echo "FAIL: expected name=require_path_shaped"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq 'require=1'; then
    echo "FAIL: expected require=1 in identity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq 'path-require=1'; then
    echo "FAIL: expected path-require=1 in identity"
    exit 1
  fi
)

echo "== A26/A30 PLAN_ONLY plan (package-transitive subset when App imports Dep) =="
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
  # A30: import-driven package-transitive plan subset — Dep before App.
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: require_path_shaped Dep App( |$)'; then
    echo "FAIL: expected expanded plan 'require_path_shaped Dep App' (A30)"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'path-require=1'; then
    echo "FAIL: plan identity should mention path-require=1"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'path \[\[require\]\]|path-require|A26 path|package-transitive plan subset'; then
    echo "FAIL: expected path require / A30 honesty note in plan banner"
    exit 1
  fi
)

echo "== A26 NATIVE_OLEAN: path-dep precompile + App olean =="
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
  if [[ ! -f dep/.slake-native/Dep.olean ]]; then
    echo "FAIL: missing dep/.slake-native/Dep.olean after path-require precompile"
    exit 1
  fi
  if [[ ! -f .slake-native/App.olean ]]; then
    echo "FAIL: missing .slake-native/App.olean after root olean"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'path \[\[require\]\] LEAN_PATH|path-dep olean precompile'; then
    echo "FAIL: expected A26 LEAN_PATH / precompile honesty on olean path"
    exit 1
  fi
)

echo "== A26 NATIVE_BUILD skip-lake with path require =="
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
    echo "FAIL: NATIVE_BUILD must produce root + dep oleans"
    exit 1
  fi
)

echo "== A26 NATIVE_CHECK-only path-require precompile + typecheck =="
(
  cd "$PKG"
  rm -rf .slake-native dep/.slake-native .lake dep/.lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_CHECK=1
  export SLAKE_NATIVE_CHECK_STRICT=1
  # Ensure olean-only flags off so we exercise CHECK-only walker entry.
  unset SLAKE_NATIVE_OLEAN SLAKE_NATIVE_BUILD || true
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: NATIVE_CHECK build failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq 'A26 path-require olean precompile'; then
    echo "FAIL: NATIVE_CHECK-only must precompile path-require oleans"
    exit 1
  fi
  if [[ ! -f dep/.slake-native/Dep.olean ]]; then
    echo "FAIL: NATIVE_CHECK-only missing dep/.slake-native/Dep.olean"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'native check OK'; then
    echo "FAIL: expected native check OK after path-require precompile"
    exit 1
  fi
  # Root typecheck must not leave root olean (CHECK is typecheck-only for root).
  if [[ -f .slake-native/App.olean ]]; then
    echo "FAIL: NATIVE_CHECK-only must not write root App.olean (olean path is separate)"
    exit 1
  fi
)

echo "== A26 nested path-require depth-2 precompile =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  mkdir -p "$tmp/mid/leaf"
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "nest_root"
defaultTargets = ["App"]

[[require]]
name = "mid"
path = "mid"

[[lean_lib]]
name = "App"
TOML
  cat > "$tmp/App.lean" <<'LEAN'
import Mid
def app := midHello
LEAN
  cat > "$tmp/mid/lakefile.toml" <<'TOML'
name = "mid"
defaultTargets = ["Mid"]

[[require]]
name = "leaf"
path = "leaf"

[[lean_lib]]
name = "Mid"
TOML
  cat > "$tmp/mid/Mid.lean" <<'LEAN'
import Leaf
def midHello : String := leafHello ++ " mid"
LEAN
  cat > "$tmp/mid/leaf/lakefile.toml" <<'TOML'
name = "leaf"
defaultTargets = ["Leaf"]

[[lean_lib]]
name = "Leaf"
TOML
  cat > "$tmp/mid/leaf/Leaf.lean" <<'LEAN'
def leafHello : String := "leaf"
LEAN
  cd "$tmp"
  rm -rf .slake-native mid/.slake-native mid/leaf/.slake-native 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_OLEAN_STRICT=1
  out="$("$SLAKE_EXE" build 2>&1)" || { echo "FAIL: nested path-require olean failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  # Two precompile banners: mid then leaf (or leaf nested under mid compile).
  pre_n="$(printf '%s\n' "$out" | grep -c 'A26 path-require olean precompile' || true)"
  if [[ "$pre_n" -lt 2 ]]; then
    echo "FAIL: expected ≥2 path-require precompile banners for depth-2 (got $pre_n)"
    exit 1
  fi
  if [[ ! -f mid/leaf/.slake-native/Leaf.olean ]]; then
    echo "FAIL: missing nested leaf Leaf.olean"
    exit 1
  fi
  if [[ ! -f mid/.slake-native/Mid.olean ]]; then
    echo "FAIL: missing mid Mid.olean"
    exit 1
  fi
  if [[ ! -f .slake-native/App.olean ]]; then
    echo "FAIL: missing root App.olean after nested path requires"
    exit 1
  fi
)

echo "== A26 negative: absolute path require ignored (path-require=0) =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "abs_req"
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
  if ! printf '%s' "$out" | grep -Eq 'require=1'; then
    echo "FAIL: absolute path still counts as require header"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq 'path-require=0'; then
    echo "FAIL: absolute path must not become path-require (expected path-require=0)"
    exit 1
  fi
)

echo "== A26 negative: multi-.. escape path ignored (path-require=0; A29 single-.. is separate) =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "dotdot_req"
defaultTargets = ["App"]

[[require]]
name = "escape"
path = "../../escape"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/App.lean"
  cd "$tmp"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'path-require=0'; then
    echo "FAIL: multi-.. escape path must not become path-require (expected path-require=0)"
    exit 1
  fi
)

echo "== A26 negative: missing path dir fail-closed under NATIVE_BUILD =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "miss_req"
defaultTargets = ["App"]

[[require]]
name = "ghost"
path = "ghost"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/App.lean"
  cd "$tmp"
  set +e
  out="$(SLAKE_NATIVE_BUILD=1 "$SLAKE_EXE" build 2>&1)"
  code=$?
  set -e
  printf '%s\n' "$out"
  if [[ "$code" -eq 0 ]]; then
    echo "FAIL: NATIVE_BUILD with missing path require dir must fail-closed (got exit 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'missing or not a directory|path require missing|A26 path require'; then
    echo "FAIL: expected missing path-require error banner"
    exit 1
  fi
)

echo "== A26 negative: missing path dir fail-closed under NATIVE_OLEAN_STRICT =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "miss_olean_strict"
defaultTargets = ["App"]

[[require]]
name = "ghost"
path = "ghost"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/App.lean"
  cd "$tmp"
  set +e
  out="$(SLAKE_PLAN_ONLY=1 SLAKE_NATIVE_OLEAN=1 SLAKE_NATIVE_OLEAN_STRICT=1 "$SLAKE_EXE" build 2>&1)"
  code=$?
  set -e
  printf '%s\n' "$out"
  if [[ "$code" -eq 0 ]]; then
    echo "FAIL: NATIVE_OLEAN_STRICT with missing path require dir must fail-closed"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'missing or not a directory|A26 path require'; then
    echo "FAIL: expected missing-or-not-a-directory banner under OLEAN_STRICT"
    exit 1
  fi
)

echo "== A26 negative: path require is regular file refuse =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "file_req"
defaultTargets = ["App"]

[[require]]
name = "notdir"
path = "notdir"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/App.lean"
  echo 'not a directory' > "$tmp/notdir"
  cd "$tmp"
  set +e
  out="$(SLAKE_NATIVE_BUILD=1 "$SLAKE_EXE" build 2>&1)"
  code=$?
  set -e
  printf '%s\n' "$out"
  if [[ "$code" -eq 0 ]]; then
    echo "FAIL: file-as-path-require must fail-closed under NATIVE_BUILD"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'missing or not a directory|refuse symlink/file'; then
    echo "FAIL: expected not-a-directory banner for file path require"
    exit 1
  fi
)

echo "== A26 negative: path require symlink refuse =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  mkdir -p "$tmp/real_dep"
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "sym_req"
defaultTargets = ["App"]

[[require]]
name = "dep"
path = "dep"

[[lean_lib]]
name = "App"
TOML
  echo 'def x := 1' > "$tmp/App.lean"
  ln -s real_dep "$tmp/dep"
  # Also point symlink outside for escape flavor (same refuse).
  cd "$tmp"
  set +e
  out="$(SLAKE_NATIVE_BUILD=1 "$SLAKE_EXE" build 2>&1)"
  code=$?
  set -e
  printf '%s\n' "$out"
  if [[ "$code" -eq 0 ]]; then
    echo "FAIL: symlink path-require must fail-closed under NATIVE_BUILD"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'missing or not a directory|refuse symlink'; then
    echo "FAIL: expected symlink refuse / not-a-directory banner"
    exit 1
  fi
)

echo "== A26 negative: require-cap=16 when truncated =="
(
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  {
    echo 'name = "cap_req"'
    echo 'defaultTargets = ["App"]'
    echo
    i=1
    while [[ "$i" -le 17 ]]; do
      echo '[[require]]'
      echo "name = \"r$i\""
      echo "path = \"d$i\""
      echo
      i=$((i + 1))
    done
    echo '[[lean_lib]]'
    echo 'name = "App"'
  } > "$tmp/lakefile.toml"
  echo 'def x := 1' > "$tmp/App.lean"
  # Create only first 16 dirs so path-require count can be 16 if all safe.
  i=1
  while [[ "$i" -le 16 ]]; do
    mkdir -p "$tmp/d$i"
    printf 'name = "d%d"\ndefaultTargets = ["D"]\n\n[[lean_lib]]\nname = "D"\n' "$i" > "$tmp/d$i/lakefile.toml"
    echo 'def d := 1' > "$tmp/d$i/D.lean"
    i=$((i + 1))
  done
  cd "$tmp"
  out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'require=17'; then
    echo "FAIL: expected require=17 for 17 headers"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'require-cap=16'; then
    echo "FAIL: expected require-cap=16 when truncated"
    exit 1
  fi
  # Fail-closed under NATIVE_BUILD when truncated (even if dirs exist for stored).
  set +e
  out2="$(SLAKE_NATIVE_BUILD=1 "$SLAKE_EXE" build 2>&1)"
  code=$?
  set -e
  printf '%s\n' "$out2"
  if [[ "$code" -eq 0 ]]; then
    echo "FAIL: NATIVE_BUILD with truncated requires must fail-closed"
    exit 1
  fi
  if ! printf '%s' "$out2" | grep -Eiq 'truncated|require-cap'; then
    echo "FAIL: expected truncated require fail-closed banner"
    exit 1
  fi
)

echo "== A26 honesty greps (help) =="
(
  help="$("$SLAKE_EXE" --help 2>&1)" || true
  if ! grep -Fq 'path [[require]]' <<<"$help"; then
    echo "FAIL: --help must mention path [[require]] (A26 honesty)"
    exit 1
  fi
  if ! grep -Eiq 'not git/url|not Lake resolve-deps' <<<"$help"; then
    echo "FAIL: --help must honesty-limit git/url / resolve-deps"
    exit 1
  fi
  if ! grep -Eiq 'path-require roots|A26 path-require' <<<"$help"; then
    # LEAN_PATH honesty for NATIVE_C mentions path-require roots
    if ! grep -Fq 'path-require roots' <<<"$help"; then
      echo "FAIL: --help NATIVE_C LEAN_PATH should mention path-require roots"
      exit 1
    fi
  fi
)

echo "OK: require_path_smoke (A26 path [[require]] subset)"
exit 0
