#!/usr/bin/env bash
# Smoke: A27 path-dep → root olean cascade invalidation subset.
#
# A26 residual: path-dep modules sit outside the root plan, so A9/A11 plan-edge
# cascade does not rebuild root App when Dep's API changes. A27 closes that:
# after path-require precompile, root modules that import path-dep plan modules
# rebuild when a path-dep olean is newer than the root olean (path-dep-olean-newer).
#
# Honesty: path-dep → root olean cascade subset — not git/url / not Lake
# resolve-deps / not freestanding build TCB / not CLAIMED / not full Lake shake.
# A30 also folds imported path-dep modules into root plan (Dep before App).
# SCORE does **not** run this smoke.
#
# Fixture: tests/slake/require_path_shaped (App imports path-require Dep).
#   Run 1: full compile Dep + App
#   Run 2: fresh skip both
#   Run 3: content-edit Dep.lean → Dep rebuild + App path-dep cascade
#   Run 4: rewrite Dep.olean only → App path-dep-olean-newer (cross-run band)
#   Run 5: touch Dep without content (A10 hash-fresh) → App still skip
#   Run 6: SLAKE_NATIVE_OLEAN_FORCE=1 rebuilds App (not path-dep banner exclusivity)
#   Run 7: nested path-require depth-2 temp fixture → Leaf edit cascades Mid
#   Negatives: honesty greps; A26 require_path still root plan only
#   Deferred residual: multi path-dep name-collision (first inventory match wins)
#
#   SLAKE_REQUIRE_PATH_CASCADE_SMOKE_STRICT=1 ./tests/slake/require_path_cascade_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/require_path_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_REQUIRE_PATH_CASCADE_SMOKE_STRICT:-}" == "1" || "${SLAKE_REQUIRE_PATH_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

LEAN_PROBE="${LEAN:-lean}"
if ! command -v "$LEAN_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEAN_PROBE" ]]; then
  strict_fail "host lean not found (set LEAN= or PATH to stage1/bin)"
fi

run_native_olean() {
  (
    cd "$PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_OLEAN=1
    export SLAKE_NATIVE_OLEAN_STRICT=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    unset LEAN || true
    "$SLAKE_EXE" build 2>&1
  )
}

count_app_lean_spawns() {
  # Root App lean -o only (not path-dep Dep under dep package).
  printf '%s' "$1" | grep -c 'native olean: .* -o .*App\.olean\|native olean: .* -o App\.olean' || true
}

count_dep_lean_spawns() {
  printf '%s' "$1" | grep -c 'native olean: .* -o .*Dep\.olean\|native olean: .* -o Dep\.olean' || true
}

echo "== A27 Run 1: full path-require precompile + App olean =="
(
  cd "$PKG"
  rm -rf .slake-native dep/.slake-native .lake dep/.lake 2>/dev/null || true
  out="$(run_native_olean)" || { echo "FAIL: Run 1 failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq 'A26 path-require olean precompile'; then
    echo "FAIL: expected A26 path-require precompile banner"
    exit 1
  fi
  if [[ ! -f dep/.slake-native/Dep.olean || ! -f .slake-native/App.olean ]]; then
    echo "FAIL: Run 1 must produce Dep + App oleans"
    exit 1
  fi
  # Honesty: A27 cascade named when path requires present (not residual "not cascade").
  if ! printf '%s' "$out" | grep -Eiq 'path-dep.*cascade|path-dep-olean-newer|A27 path-dep'; then
    echo "FAIL: expected A27 path-dep cascade honesty when path requires present"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'not path-dep cascade invalidation of root oleans'; then
    echo "FAIL: residual 'not path-dep cascade' honesty must not remain after A27"
    exit 1
  fi
  # A30: package-transitive plan subset includes Dep when App imports Dep.
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq '(^| )Dep( |$)'; then
    echo "FAIL: root plan must include Dep (A30 package-transitive plan subset)"
    echo "  got: $plan"
    exit 1
  fi
)

echo "== A27 Run 2: fresh skip Dep + App (no lean -o) =="
(
  cd "$PKG"
  out="$(run_native_olean)" || { echo "FAIL: Run 2 failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'skip Dep \(fresh\)|skip Dep \(hash-fresh\)'; then
    echo "FAIL: expected skip Dep (fresh|hash-fresh) on Run 2"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq 'skip App \(fresh\)|skip App \(hash-fresh\)'; then
    echo "FAIL: expected skip App (fresh|hash-fresh) on Run 2"
    exit 1
  fi
  app_spawns="$(count_app_lean_spawns "$out")"
  if [[ "$app_spawns" -ne 0 ]]; then
    echo "FAIL: Run 2 must not re-lean App (got $app_spawns spawns)"
    exit 1
  fi
)

echo "== A27 Run 3: content-edit Dep.lean → Dep rebuild + App path-dep cascade =="
(
  cd "$PKG"
  # Content edit so A10 hash invalidates Dep; App source unchanged so only
  # path-dep cascade can force App rebuild. Trap-restore golden Dep.lean so an
  # interrupted STRICT run cannot leave the fixture dirty.
  dep_bak="$(mktemp)"
  cp dep/Dep.lean "$dep_bak"
  restore_dep() {
    cp "$dep_bak" dep/Dep.lean
    rm -f "$dep_bak"
  }
  trap restore_dep EXIT
  printf '\n-- A27 path-dep cascade content bump\n' >> dep/Dep.lean
  out="$(run_native_olean)" || { echo "FAIL: Run 3 failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eq 'skip Dep \(fresh\)|skip Dep \(hash-fresh\)'; then
    echo "FAIL: Dep must rebuild after content edit (not skip)"
    exit 1
  fi
  dep_spawns="$(count_dep_lean_spawns "$out")"
  if [[ "$dep_spawns" -lt 1 ]]; then
    echo "FAIL: expected Dep lean -o after content edit"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eq 'skip App \(fresh\)|skip App \(hash-fresh\)'; then
    echo "FAIL: App must path-dep-cascade rebuild when Dep recompiled (not skip by App mtime/hash alone)"
    exit 1
  fi
  app_spawns="$(count_app_lean_spawns "$out")"
  if [[ "$app_spawns" -lt 1 ]]; then
    echo "FAIL: expected App lean -o path-dep cascade after Dep content edit"
    exit 1
  fi
  # Align with Run4: hard-require explicit path-dep cascade banner (not generic
  # native-olean activity alone).
  if ! printf '%s' "$out" | grep -Eiq 'path-dep-olean-newer|rebuild App \(path-dep'; then
    echo "FAIL: expected path-dep-olean-newer rebuild banner for App after Dep content edit"
    exit 1
  fi
  # Explicit restore before trap EXIT (idempotent); trap covers early fail.
  restore_dep
  trap - EXIT
)

echo "== A27 Run 3b: restore Dep + recompile both clean =="
(
  cd "$PKG"
  rm -rf .slake-native dep/.slake-native 2>/dev/null || true
  out="$(run_native_olean)" || { echo "FAIL: Run 3b clean compile failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if [[ ! -f dep/.slake-native/Dep.olean || ! -f .slake-native/App.olean ]]; then
    echo "FAIL: Run 3b missing oleans"
    exit 1
  fi
)

echo "== A27 Run 4: rewrite Dep.olean only → App path-dep-olean-newer =="
(
  cd "$PKG"
  # Fresh skip baseline first so both oleans exist and App is skip-eligible.
  out0="$(run_native_olean)" || { echo "FAIL: Run 4 baseline failed"; printf '%s\n' "$out0"; exit 1; }
  # Bump only Dep.olean mtime (interrupted / path-dep rebuilt without App).
  sleep 1
  if ! cat dep/.slake-native/Dep.olean > dep/.slake-native/Dep.olean.tmp \
    || ! mv dep/.slake-native/Dep.olean.tmp dep/.slake-native/Dep.olean; then
    echo "FAIL: manual Dep.olean rewrite for path-dep-olean-newer band failed"
    exit 1
  fi
  # Ensure Dep.olean is strictly newer than App.olean.
  touch -r .slake-native/App.olean -d '1 second ago' .slake-native/App.olean 2>/dev/null \
    || touch -A -010000 .slake-native/App.olean 2>/dev/null \
    || true
  sleep 1
  cat dep/.slake-native/Dep.olean > dep/.slake-native/Dep.olean.tmp
  mv dep/.slake-native/Dep.olean.tmp dep/.slake-native/Dep.olean
  out="$(run_native_olean)" || { echo "FAIL: Run 4 cascade failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  # Dep source unchanged → skip Dep (hash-fresh or fresh).
  if ! printf '%s' "$out" | grep -Eq 'skip Dep \(fresh\)|skip Dep \(hash-fresh\)'; then
    echo "FAIL: Dep source fresh — expected skip Dep after olean-only rewrite"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eq 'skip App \(fresh\)|skip App \(hash-fresh\)'; then
    echo "FAIL: App must cascade when Dep.olean is newer than App.olean"
    exit 1
  fi
  app_spawns="$(count_app_lean_spawns "$out")"
  if [[ "$app_spawns" -lt 1 ]]; then
    echo "FAIL: expected App lean -o via path-dep-olean-newer"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'path-dep-olean-newer|rebuild App \(path-dep'; then
    echo "FAIL: expected path-dep-olean-newer rebuild banner for App"
    exit 1
  fi
)

echo "== A27 Run 5: touch Dep without content → App still skip (hash-fresh) =="
(
  cd "$PKG"
  # Ensure clean fresh state.
  out0="$(run_native_olean)" || true
  # Touch Dep source only (A10: Dep hash-fresh; olean mtime unchanged).
  touch dep/Dep.lean
  out="$(run_native_olean)" || { echo "FAIL: Run 5 failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'skip Dep \(fresh\)|skip Dep \(hash-fresh\)'; then
    echo "FAIL: bare touch Dep must stay hash-fresh/fresh (not rebuild)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq 'skip App \(fresh\)|skip App \(hash-fresh\)'; then
    echo "FAIL: App must stay skip when Dep only touch-without-edit"
    exit 1
  fi
  app_spawns="$(count_app_lean_spawns "$out")"
  if [[ "$app_spawns" -ne 0 ]]; then
    echo "FAIL: App must not cascade on bare touch of Dep (got $app_spawns spawns)"
    exit 1
  fi
)

echo "== A27 Run 6: FORCE rebuilds App (not path-dep banner exclusivity) =="
(
  cd "$PKG"
  # Fresh baseline so App would otherwise skip.
  out0="$(run_native_olean)" || { echo "FAIL: Run 6 baseline failed"; printf '%s\n' "$out0"; exit 1; }
  out="$(
    cd "$PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_OLEAN=1
    export SLAKE_NATIVE_OLEAN_STRICT=1
    export SLAKE_NATIVE_OLEAN_FORCE=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset LEAN || true
    "$SLAKE_EXE" build 2>&1
  )" || { echo "FAIL: Run 6 FORCE failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  app_spawns="$(count_app_lean_spawns "$out")"
  if [[ "$app_spawns" -lt 1 ]]; then
    echo "FAIL: FORCE must re-lean App even when otherwise fresh"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eq 'skip App \(fresh\)|skip App \(hash-fresh\)'; then
    echo "FAIL: FORCE must not skip App as fresh"
    exit 1
  fi
  # FORCE may or may not print path-dep-olean-newer (banner suppressed when force);
  # do not require path-dep exclusivity — only that FORCE rebuilds.
)

echo "== A27 Run 7: nested path-require depth-2 Leaf edit → Mid path-dep cascade =="
(
  # Cheap temp fixture (same shape as A26 nested precompile smoke): root App
  # imports Mid (path mid); Mid imports Leaf (path leaf). Edit Leaf → Mid
  # rebuilds via path-dep-olean-newer when Mid is the consumer package under
  # root precompile of mid (mid's own path-dep Leaf).
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  mkdir -p "$tmp/mid/leaf"
  cat > "$tmp/lakefile.toml" <<'TOML'
name = "nest_cascade_root"
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
  run_nest() {
    (
      cd "$tmp"
      export SLAKE_PLAN_ONLY=1
      export SLAKE_NATIVE_OLEAN=1
      export SLAKE_NATIVE_OLEAN_STRICT=1
      unset SLAKE_DEPGRAPH || true
      unset SLAKE_USE_FS_PROC || true
      unset SLAKE_NATIVE_CHECK || true
      unset SLAKE_NATIVE_OLEAN_FORCE || true
      unset LEAN || true
      "$SLAKE_EXE" build 2>&1
    )
  }
  rm -rf "$tmp"/.slake-native "$tmp"/mid/.slake-native "$tmp"/mid/leaf/.slake-native 2>/dev/null || true
  out1="$(run_nest)" || { echo "FAIL: Run 7 full nested compile failed"; printf '%s\n' "$out1"; exit 1; }
  printf '%s\n' "$out1"
  if [[ ! -f "$tmp/mid/leaf/.slake-native/Leaf.olean" || ! -f "$tmp/mid/.slake-native/Mid.olean" || ! -f "$tmp/.slake-native/App.olean" ]]; then
    echo "FAIL: Run 7 missing nested oleans after full compile"
    exit 1
  fi
  # Fresh skip baseline (all skip).
  out2="$(run_nest)" || { echo "FAIL: Run 7 fresh nested failed"; printf '%s\n' "$out2"; exit 1; }
  printf '%s\n' "$out2"
  # Content-edit Leaf only → Leaf rebuild + Mid path-dep cascade (Mid imports Leaf
  # as path-dep; Mid is not a Leaf plan node). Root App may also cascade if Mid
  # olean becomes newer.
  printf '\n-- A27 nested leaf cascade bump\n' >> "$tmp/mid/leaf/Leaf.lean"
  out3="$(run_nest)" || { echo "FAIL: Run 7 Leaf edit cascade failed"; printf '%s\n' "$out3"; exit 1; }
  printf '%s\n' "$out3"
  if printf '%s' "$out3" | grep -Eq 'skip Leaf \(fresh\)|skip Leaf \(hash-fresh\)'; then
    echo "FAIL: Leaf must rebuild after content edit"
    exit 1
  fi
  leaf_spawns="$(printf '%s' "$out3" | grep -cE 'native olean: .* -o .*Leaf\.olean|native olean: .* -o Leaf\.olean' || true)"
  if [[ "$leaf_spawns" -lt 1 ]]; then
    echo "FAIL: expected Leaf lean -o after content edit"
    exit 1
  fi
  if printf '%s' "$out3" | grep -Eq 'skip Mid \(fresh\)|skip Mid \(hash-fresh\)'; then
    echo "FAIL: Mid must path-dep-cascade when Leaf recompiled (not skip by Mid mtime/hash alone)"
    exit 1
  fi
  mid_spawns="$(printf '%s' "$out3" | grep -cE 'native olean: .* -o .*Mid\.olean|native olean: .* -o Mid\.olean' || true)"
  if [[ "$mid_spawns" -lt 1 ]]; then
    echo "FAIL: expected Mid lean -o path-dep cascade after Leaf content edit"
    exit 1
  fi
  if ! printf '%s' "$out3" | grep -Eiq 'path-dep-olean-newer|rebuild Mid \(path-dep'; then
    echo "FAIL: expected path-dep-olean-newer rebuild banner for Mid after nested Leaf edit"
    exit 1
  fi
  # A30: root App imports Mid → Mid in root plan; Leaf only under mid package (not root import).
  plan="$(printf '%s\n' "$out3" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq '(^| )Mid( |$)'; then
    echo "FAIL: root plan must include Mid (A30; App imports Mid)"
    echo "  got: $plan"
    exit 1
  fi
  if printf '%s' "$plan" | grep -Eq '(^| )Leaf( |$)'; then
    echo "FAIL: root plan must not include Leaf (not imported by root App; only mid path-dep)"
    echo "  got: $plan"
    exit 1
  fi
)

echo "== A27 honesty greps (help + env) =="
(
  help="$("$SLAKE_EXE" --help 2>&1)" || true
  if ! grep -Eiq 'path-dep.*cascade|path-dep-olean-newer|A27' <<<"$help"; then
    # Help may fold A27 under NATIVE_OLEAN path-require wording.
    if ! grep -Eiq 'path \[\[require\]\].*cascade|cascade.*path-require|path-dep → root|path-dep -> root' <<<"$help"; then
      echo "FAIL: --help must mention path-dep cascade / A27 honesty"
      exit 1
    fi
  fi
  if grep -Fq 'not path-dep cascade invalidation of root oleans' <<<"$help"; then
    echo "FAIL: help must not keep residual 'not path-dep cascade' claim after A27"
    exit 1
  fi
  cd "$PKG"
  env_out="$(SLAKE_NATIVE_OLEAN=1 "$SLAKE_EXE" env 2>&1)" || true
  if ! grep -Eiq 'path-dep|path \[\[require\]\]|A26' <<<"$env_out"; then
    echo "FAIL: env with NATIVE_OLEAN should still mention path require / path-dep"
    exit 1
  fi
)

echo "OK: require_path_cascade_smoke (A27 path-dep → root olean cascade subset)"
exit 0
