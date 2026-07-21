#!/usr/bin/env bash
# Smoke: A28 path-dep source-hash fold into A11 frozen deps <hex>.
#
# A27 residual: path-dep modules sit outside the root plan, so A11's plan-node
# deps-line never saw Dep's source hash. A27 closes olean-mtime cascade
# (path-dep-olean-newer). A28 folds path-dep import source hashes into the
# consumer's A11 `deps <hex>` so a hash-fresh path-dep with non-newer olean
# cannot leave App deps-line stale (A11 Run 5 shape across package boundary).
#
# Honesty: path-dep source-hash fold into A11 deps-line subset only — not
# git/url / not Lake resolve-deps / not Lake package-transitive hash / not
# freestanding build TCB / not CLAIMED. A30 also expands root plan with Dep.
# SCORE does **not** run this smoke.
#
# Fixture: tests/slake/require_path_shaped (App imports path-require Dep).
#   Run 1: full compile; App sidecar has deps line; A28 honesty banners
#   Run 2: fresh skip Dep + App
#   Run 3: pure deps-line — edit Dep, keep Dep hash-fresh with old olean mtime
#          not newer than App; App rebuilds deps-line-stale; App deps line changes
#   Run 4: touch Dep without content → both stay skip
#   Run 5: help/env honesty greps; A30 root plan includes Dep
#
#   SLAKE_REQUIRE_PATH_DEPS_HASH_SMOKE_STRICT=1 ./tests/slake/require_path_deps_hash_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/require_path_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

A28_SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/slake-a28-XXXXXX")"
cleanup_a28() {
  rm -rf "$A28_SCRATCH" 2>/dev/null || true
  (
    cd "$PKG" 2>/dev/null || exit 0
    if [[ -f dep/Dep.lean.a28bak ]]; then
      mv -f dep/Dep.lean.a28bak dep/Dep.lean
    fi
    rm -rf .slake-native dep/.slake-native .lake dep/.lake 2>/dev/null || true
  )
}
trap cleanup_a28 EXIT

strict_fail() {
  if [[ "${SLAKE_REQUIRE_PATH_DEPS_HASH_SMOKE_STRICT:-}" == "1" || "${SLAKE_REQUIRE_PATH_CASCADE_SMOKE_STRICT:-}" == "1" || "${SLAKE_REQUIRE_PATH_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_DEPS_HASH_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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
  printf '%s' "$1" | grep -c 'native olean: .* -o .*App\.olean\|native olean: .* -o App\.olean' || true
}

count_dep_lean_spawns() {
  printf '%s' "$1" | grep -c 'native olean: .* -o .*Dep\.olean\|native olean: .* -o Dep\.olean' || true
}

echo "== A28 Run 1: full path-require precompile + App olean; deps line + honesty =="
(
  cd "$PKG"
  rm -rf .slake-native dep/.slake-native .lake dep/.lake 2>/dev/null || true
  out="$(run_native_olean)" || { echo "FAIL: Run 1 failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq 'A26 path-require olean precompile'; then
    echo "FAIL: expected A26 path-require precompile banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'A28|path-dep source-hash fold|path-dep.*deps-line|deps-line.*path-dep'; then
    echo "FAIL: expected A28 path-dep source-hash fold honesty banner when path requires present"
    exit 1
  fi
  if [[ ! -f dep/.slake-native/Dep.olean || ! -f .slake-native/App.olean ]]; then
    echo "FAIL: Run 1 must produce Dep + App oleans"
    exit 1
  fi
  if [[ ! -f .slake-native/App.olean.slakehash ]]; then
    echo "FAIL: expected App.olean.slakehash after successful -o"
    exit 1
  fi
  if ! grep -Eq '^fnv1a64 [0-9a-f]{16} App' .slake-native/App.olean.slakehash; then
    echo "FAIL: App.slakehash must have line1 'fnv1a64 <16hex> App'"
    cat .slake-native/App.olean.slakehash || true
    exit 1
  fi
  if ! grep -Eq '^deps [0-9a-f]{16}$' .slake-native/App.olean.slakehash; then
    echo "FAIL: App.slakehash must have A11/A28 deps line (path-dep Dep source closure)"
    cat .slake-native/App.olean.slakehash || true
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

echo "== A28 Run 2: fresh skip Dep + App =="
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

echo "== A28 Run 3: pure path-dep deps-line — Dep hash-fresh; App deps-line-stale =="
(
  cd "$PKG"
  # Full recompile to known-good state first.
  rm -rf .slake-native dep/.slake-native 2>/dev/null || true
  out0="$(run_native_olean)" || { echo "FAIL: Run 3 setup compile failed"; printf '%s\n' "$out0"; exit 1; }
  app_deps_before="$(grep -E '^deps [0-9a-f]{16}$' .slake-native/App.olean.slakehash | head -1 || true)"
  if [[ -z "$app_deps_before" ]]; then
    echo "FAIL: App must have deps line after setup compile"
    cat .slake-native/App.olean.slakehash || true
    exit 1
  fi
  # Content-edit Dep (invalidates App deps closure). Trap-restore golden Dep.lean.
  cp -a dep/Dep.lean dep/Dep.lean.a28bak
  restore_dep() {
    if [[ -f dep/Dep.lean.a28bak ]]; then
      mv -f dep/Dep.lean.a28bak dep/Dep.lean
    fi
  }
  trap 'restore_dep' EXIT
  sleep 1
  printf '\n-- A28 path-dep deps-hash content bump\n' >> dep/Dep.lean
  # Save pre-edit Dep.olean + App olean/sidecar for pure deps-line band.
  cp -a dep/.slake-native/Dep.olean "$A28_SCRATCH/dep_olean_old"
  cp -a .slake-native/App.olean "$A28_SCRATCH/app_olean_old"
  cp -a .slake-native/App.olean.slakehash "$A28_SCRATCH/app_hash_old"
  out_mid="$(run_native_olean)" || { echo "FAIL: Run 3 mid compile failed"; printf '%s\n' "$out_mid"; exit 1; }
  printf '%s\n' "$out_mid"
  # Keep new Dep sidecar (matches edited Dep.lean); restore old Dep.olean binary.
  # Restore App olean + OLD App.slakehash (with OLD deps line frozen against old Dep).
  cp -a "$A28_SCRATCH/dep_olean_old" dep/.slake-native/Dep.olean
  cp -a "$A28_SCRATCH/app_olean_old" .slake-native/App.olean
  cp -a "$A28_SCRATCH/app_hash_old" .slake-native/App.olean.slakehash
  # Ensure Dep.olean is NOT newer than App.olean (A27 path-dep-olean-newer false).
  touch -r .slake-native/App.olean dep/.slake-native/Dep.olean 2>/dev/null || true
  sleep 1
  touch .slake-native/App.olean
  # Dep source is newer than Dep.olean → not mtime-fresh, but hash-fresh via new sidecar.
  out="$(run_native_olean)" || { echo "FAIL: Run 3 pure deps-line failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'skip Dep \(hash-fresh\)'; then
    echo "FAIL: Dep should hash-fresh skip (new sidecar matches edited source; old olean present)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eq 'skip App \(fresh\)|skip App \(hash-fresh\)'; then
    echo "FAIL: App must not skip when deps line frozen against old Dep source"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'rebuild App (deps-line-stale)'; then
    echo "FAIL: expected rebuild App (deps-line-stale) via A28 path-dep fold"
    exit 1
  fi
  app_spawns="$(count_app_lean_spawns "$out")"
  if [[ "$app_spawns" -lt 1 ]]; then
    echo "FAIL: expected App lean -o under deps-line-stale"
    exit 1
  fi
  dep_spawns="$(count_dep_lean_spawns "$out")"
  if [[ "$dep_spawns" -ne 0 ]]; then
    echo "FAIL: Dep must not recompile on Run 3 (hash-fresh only); got $dep_spawns"
    exit 1
  fi
  # Pure A28 band: Dep.olean kept not newer than App — must not fire A27 rebuild
  # banner (gate-order regression). Grep rebuild line only — honesty banners still
  # name path-dep-olean-newer as shipped A27 subset wording.
  if printf '%s' "$out" | grep -Eq 'rebuild App \(path-dep-olean-newer\)|rebuild App \(path-dep\)'; then
    echo "FAIL: pure deps-line Run 3 must not rebuild App via path-dep-olean-newer (A27); expected deps-line-stale only"
    exit 1
  fi
  app_deps_after="$(grep -E '^deps [0-9a-f]{16}$' .slake-native/App.olean.slakehash | head -1 || true)"
  if [[ -z "$app_deps_after" ]]; then
    echo "FAIL: App deps line missing after deps-line-stale rebuild"
    exit 1
  fi
  if [[ "$app_deps_after" == "$app_deps_before" ]]; then
    echo "FAIL: App deps line should change when Dep source changed (A28 fold)"
    echo "  before=$app_deps_before after=$app_deps_after"
    exit 1
  fi
  restore_dep
  trap cleanup_a28 EXIT
)

echo "== A28 Run 3b: restore Dep + reconverge skip both =="
(
  cd "$PKG"
  # Restore golden Dep if bak remains; clean compile then fresh skip.
  if [[ -f dep/Dep.lean.a28bak ]]; then
    mv -f dep/Dep.lean.a28bak dep/Dep.lean
  fi
  rm -rf .slake-native dep/.slake-native 2>/dev/null || true
  out0="$(run_native_olean)" || { echo "FAIL: Run 3b clean compile failed"; printf '%s\n' "$out0"; exit 1; }
  out="$(run_native_olean)" || { echo "FAIL: Run 3b reconverge failed"; printf '%s\n' "$out"; exit 1; }
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Eq 'skip App \(fresh\)|skip App \(hash-fresh\)'; then
    echo "FAIL: expected skip App after reconverge"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rebuild App (deps-line-stale)'; then
    echo "FAIL: App must not deps-line-stale after reconverge"
    exit 1
  fi
  app_spawns="$(count_app_lean_spawns "$out")"
  if [[ "$app_spawns" -ne 0 ]]; then
    echo "FAIL: Run 3b expected 0 App lean -o spawns, got $app_spawns"
    exit 1
  fi
)

echo "== A28 Run 4: touch Dep without content → App still skip =="
(
  cd "$PKG"
  out0="$(run_native_olean)" || true
  touch dep/Dep.lean
  out="$(run_native_olean)" || { echo "FAIL: Run 4 failed"; printf '%s\n' "$out"; exit 1; }
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
    echo "FAIL: App must not cascade/deps-stale on bare touch of Dep (got $app_spawns)"
    exit 1
  fi
)

echo "== A28 honesty greps (help + env) =="
(
  help="$("$SLAKE_EXE" --help 2>&1)" || true
  if ! grep -Eiq 'A28|path-dep source-hash fold|path-dep.*deps|deps.*path-dep' <<<"$help"; then
    echo "FAIL: --help must mention A28 / path-dep source-hash fold honesty"
    exit 1
  fi
  cd "$PKG"
  env_out="$(SLAKE_NATIVE_OLEAN=1 "$SLAKE_EXE" env 2>&1)" || true
  if ! grep -Eiq 'A28|path-dep source-hash fold|path-dep.*deps-line|deps-line.*path-dep' <<<"$env_out"; then
    echo "FAIL: env with NATIVE_OLEAN must mention A28 path-dep deps-hash fold"
    exit 1
  fi
  if grep -Fq 'not path-dep fold into A11' <<<"$env_out"; then
    echo "FAIL: env must not keep residual 'not path-dep fold into A11' after A28"
    exit 1
  fi
)

echo "OK: require_path_deps_hash_smoke (A28 path-dep source-hash fold into A11 deps-line subset)"
exit 0
