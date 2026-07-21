#!/usr/bin/env bash
# Smoke: A11 plan-node transitive deps-hash on NATIVE_OLEAN (plan-import subset).
#
# Honesty: **direct plan-import dep source-hash closure + cascade multi-hop**
# among A5 edges only (banner “plan-node transitive deps-hash”). Live plan-import
# dep must be hash-fresh at run-start snapshot before mtime/hash skip of
# dependents; optional frozen `deps <hex>` line in `.olean.slakehash` (sorted
# **direct** plan-import dep names + source hashes at compile time); mtime/hash
# skip best-effort heals self+deps sidecar. Not freestanding build TCB, not Lake
# shake/hash TCB, not Lake package-transitive hash, not CLAIMED expansion. SCORE
# does **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with binary present.
#
# systems_shaped: Core before Host (Host imports Core).
#   Run 1: empty .slake-native → compile both; sidecars have deps line
#   Run 2: fresh cache → skip both
#   Run 3: content-edit Core → Core rebuild + Host cascade (and/or deps-hash)
#   Run 4: live dep-hash-stale — delete Core sidecar; Core still mtime-fresh →
#          Core skips + heals sidecar; Host rebuilds once (dep-hash-stale) via
#          start-of-run snapshot (without A9 dep-olean-newer)
#   Run 4b: reconverge — second run skip both (Core sidecar present; no lean -o)
#   Run 5: pure deps-line — content-edit Core, rewrite Core sidecar to NEW hash
#          (false hash-fresh), keep Core.olean mtime old so Core hash-skips and
#          Host is not forced by dep-olean-newer; Host rebuilds (deps-line-stale)
#   PLAN_ONLY still no .lake/build
#
#   SLAKE_NATIVE_OLEAN_DEPS_HASH_SMOKE_STRICT=1 ./tests/slake/native_olean_deps_hash_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

# Package-local scratch for Run 5 artifact swaps (avoids fixed /tmp races).
A11_SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/slake-a11-XXXXXX")"
cleanup_a11() {
  rm -rf "$A11_SCRATCH" 2>/dev/null || true
  (
    cd "$SYSTEMS_PKG" 2>/dev/null || exit 0
    if [[ -f Core.lean.a11bak ]]; then
      mv -f Core.lean.a11bak Core.lean
    fi
    rm -rf .slake-native .lake 2>/dev/null || true
  )
}
trap cleanup_a11 EXIT

strict_fail() {
  if [[ "${SLAKE_NATIVE_OLEAN_DEPS_HASH_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_HASH_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_CACHE_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

LEAN_PROBE="${LEAN:-lean}"
if ! command -v "$LEAN_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEAN_PROBE" ]]; then
  strict_fail "host lean not found (set LEAN= or PATH to stage1/bin)"
fi

if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi

run_native_olean() {
  (
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_OLEAN=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset SLAKE_NATIVE_OLEAN_FORCE || true
    unset SLAKE_NATIVE_BUILD || true
    unset LEAN || true
    "$SLAKE_EXE" build 2>&1
  )
}

count_lean_spawns() {
  printf '%s' "$1" | grep -c 'native olean: .* -o ' || true
}

# Portable: restore mtime of $1 from reference file $2 (GNU touch -r).
restore_mtime_from() {
  local target="$1"
  local ref="$2"
  if touch -r "$ref" "$target" 2>/dev/null; then
    return 0
  fi
  # Fallback: leave as-is (smoke may still work via other gates).
  return 1
}

echo "== A11 Run 1: PLAN_ONLY+NATIVE_OLEAN compile + write deps line sidecars =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  rm -f ./*.olean 2>/dev/null || true
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 1 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected systems_shaped Core Host plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "FNV-1a 64 source content-hash sidecar"; then
    echo "FAIL: expected FNV-1a 64 source content-hash sidecar honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "plan-node transitive deps-hash"; then
    echo "FAIL: expected A11 plan-node transitive deps-hash honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not Lake package-transitive hash"; then
    echo "FAIL: expected residual honesty not Lake package-transitive hash"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not Lake shake/hash TCB"; then
    echo "FAIL: expected residual honesty Lake shake/hash TCB"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: expected Core.olean and Host.olean under .slake-native"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean.slakehash ]]; then
    echo "FAIL: expected Core.olean.slakehash sidecar after successful -o"
    exit 1
  fi
  if [[ ! -f .slake-native/Host.olean.slakehash ]]; then
    echo "FAIL: expected Host.olean.slakehash sidecar after successful -o"
    exit 1
  fi
  if ! grep -Eq '^fnv1a64 [0-9a-f]{16} Core' .slake-native/Core.olean.slakehash; then
    echo "FAIL: Core.slakehash must have line1 'fnv1a64 <16hex> Core'"
    cat .slake-native/Core.olean.slakehash || true
    exit 1
  fi
  if ! grep -Eq '^deps [0-9a-f]{16}$' .slake-native/Core.olean.slakehash; then
    echo "FAIL: Core.slakehash must have A11 deps line (empty-dep closure ok)"
    cat .slake-native/Core.olean.slakehash || true
    exit 1
  fi
  if ! grep -Eq '^fnv1a64 [0-9a-f]{16} Host' .slake-native/Host.olean.slakehash; then
    echo "FAIL: Host.slakehash must have line1 'fnv1a64 <16hex> Host'"
    cat .slake-native/Host.olean.slakehash || true
    exit 1
  fi
  if ! grep -Eq '^deps [0-9a-f]{16}$' .slake-native/Host.olean.slakehash; then
    echo "FAIL: Host.slakehash must have A11 deps line (Core source closure)"
    cat .slake-native/Host.olean.slakehash || true
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -lt 2 ]]; then
    echo "FAIL: Run 1 expected ≥2 lean -o spawns, got $spawns"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 1"
    exit 1
  fi
)

echo "== A11 Run 2: fresh cache → skip both =="
(
  cd "$SYSTEMS_PKG"
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 2 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skip Core (fresh)"; then
    echo "FAIL: expected skip Core (fresh) on Run 2"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skip Host (fresh)"; then
    echo "FAIL: expected skip Host (fresh) on Run 2"
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -ne 0 ]]; then
    echo "FAIL: Run 2 expected 0 lean -o spawns, got $spawns"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 2"
    exit 1
  fi
)

echo "== A11 Run 3: content-edit Core → Core + Host rebuild =="
(
  cd "$SYSTEMS_PKG"
  sleep 1
  cp -a Core.lean Core.lean.a11bak
  printf '\n-- A11 deps-hash content bump\n' >> Core.lean
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  # Keep edited Core for subsequent runs that need it; restore at end.
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    mv -f Core.lean.a11bak Core.lean 2>/dev/null || true
    echo "FAIL: Run 3 exited $rc (expected 0)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Core (fresh)"; then
    echo "FAIL: Core must rebuild after content edit (not skip fresh)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Core (hash-fresh)"; then
    echo "FAIL: Core must rebuild after content edit (not skip hash-fresh)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Core\.lean' >/dev/null; then
    echo "FAIL: expected Core lean -o rebuild after content edit"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (fresh)"; then
    echo "FAIL: Host must rebuild when Core recompiled (not skip solely by Host mtime)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (hash-fresh)"; then
    echo "FAIL: Host must rebuild when Core recompiled (not skip hash-fresh)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Host\.lean' >/dev/null; then
    echo "FAIL: expected Host lean -o rebuild (cascade and/or deps-hash)"
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -lt 2 ]]; then
    echo "FAIL: Run 3 expected ≥2 lean -o spawns (Core+Host), got $spawns"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 3"
    exit 1
  fi
)

echo "== A11 Run 4: delete Core sidecar; Core mtime-skips+heals; Host dep-hash-stale =="
(
  cd "$SYSTEMS_PKG"
  # After Run 3, both fresh with sidecars. Remove Core sidecar only.
  # Core remains mtime-fresh (olean ≥ source). Start-of-run snapshot sees Core
  # not hash-fresh → Host rebuilds once (dep-hash-stale). Core mtime-skips and
  # heals sidecar so Run 4b can reconverge. Keep Core.olean mtime ≤ Host so
  # dep-olean-newer alone does not force Host.
  if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: Run 4 requires oleans from prior runs"
    exit 1
  fi
  rm -f .slake-native/Core.olean.slakehash
  # Ensure Core.olean is not newer than Host.olean (dep-olean-newer false).
  restore_mtime_from .slake-native/Core.olean .slake-native/Host.olean || true
  # Ensure Core.olean ≥ Core.lean for mtime-fresh skip.
  touch -r Core.lean .slake-native/Core.olean 2>/dev/null || touch .slake-native/Core.olean
  # If touch made Core.olean new, pull Host.olean to match or newer.
  touch -r .slake-native/Core.olean .slake-native/Host.olean 2>/dev/null || true
  # Bump Host.olean slightly after Core so dep-olean-newer stays false for Host.
  sleep 1
  touch .slake-native/Host.olean
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 4 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skip Core (fresh)"; then
    echo "FAIL: Core should mtime-skip without sidecar (A9 path + heal)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (fresh)"; then
    echo "FAIL: Host must not mtime-skip when Core sidecar missing at run start (dep-hash-stale)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (hash-fresh)"; then
    echo "FAIL: Host must not hash-skip when Core sidecar missing at run start"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "rebuild Host (dep-hash-stale)"; then
    echo "FAIL: expected rebuild Host (dep-hash-stale) log"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Host\.lean' >/dev/null; then
    echo "FAIL: expected Host lean -o under dep-hash-stale"
    exit 1
  fi
  # Core must not have been recompiled (only Host).
  if printf '%s' "$out" | grep -E 'native olean: .* -o .*Core\.lean' >/dev/null; then
    echo "FAIL: Core must not recompile on Run 4 (mtime-skip + heal only)"
    exit 1
  fi
  # Option A heal: Core sidecar must be rewritten on mtime-skip.
  if [[ ! -f .slake-native/Core.olean.slakehash ]]; then
    echo "FAIL: Core sidecar must be healed on mtime-skip (option A)"
    exit 1
  fi
  if ! grep -Eq '^fnv1a64 [0-9a-f]{16} Core' .slake-native/Core.olean.slakehash; then
    echo "FAIL: healed Core sidecar must have valid line1"
    cat .slake-native/Core.olean.slakehash || true
    exit 1
  fi
  if ! grep -Eq '^deps [0-9a-f]{16}$' .slake-native/Core.olean.slakehash; then
    echo "FAIL: healed Core sidecar must have deps line"
    cat .slake-native/Core.olean.slakehash || true
    exit 1
  fi
  if [[ ! -f .slake-native/Host.olean.slakehash ]]; then
    echo "FAIL: Host sidecar must be rewritten after rebuild"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 4"
    exit 1
  fi
)

echo "== A11 Run 4b: reconverge — skip both after heal =="
(
  cd "$SYSTEMS_PKG"
  if [[ ! -f .slake-native/Core.olean.slakehash ]]; then
    echo "FAIL: Run 4b requires Core sidecar healed by Run 4"
    exit 1
  fi
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 4b exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skip Core (fresh)"; then
    echo "FAIL: expected skip Core (fresh) on Run 4b reconverge"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skip Host (fresh)"; then
    echo "FAIL: expected skip Host (fresh) on Run 4b reconverge"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "rebuild Host (dep-hash-stale)"; then
    echo "FAIL: Host must not dep-hash-stale again after Core sidecar heal (non-convergence)"
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -ne 0 ]]; then
    echo "FAIL: Run 4b expected 0 lean -o spawns (reconverged), got $spawns"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 4b"
    exit 1
  fi
)

echo "== A11 Run 5: pure deps-line — Core false hash-fresh; Host deps-line-stale =="
(
  cd "$SYSTEMS_PKG"
  # Full recompile to known-good state first (sidecars + oleans aligned).
  rm -rf .slake-native
  out0="$(run_native_olean)" || rc0=$?
  rc0="${rc0:-0}"
  if [[ "$rc0" -ne 0 ]]; then
    echo "FAIL: Run 5 setup compile exited $rc0"
    exit 1
  fi
  # Capture Host deps line before Core edit (must change when Core source changes).
  host_deps_before="$(grep -E '^deps [0-9a-f]{16}$' .slake-native/Host.olean.slakehash | head -1 || true)"
  if [[ -z "$host_deps_before" ]]; then
    echo "FAIL: Host must have deps line after setup compile"
    cat .slake-native/Host.olean.slakehash || true
    exit 1
  fi
  core_line1="$(grep -E '^fnv1a64 [0-9a-f]{16} Core' .slake-native/Core.olean.slakehash | head -1)"
  core_deps="$(grep -E '^deps [0-9a-f]{16}$' .slake-native/Core.olean.slakehash | head -1)"
  # Content-edit Core (invalidates Host deps closure).
  sleep 1
  printf '\n-- A11 pure deps-line bump\n' >> Core.lean
  # Cleaner proof without external FNV:
  # 1. Save Host.olean + Host.slakehash + Core.olean (pre-edit) under A11_SCRATCH
  # 2. Run slake → Core rebuilds (hash miss) + Host cascade; captures NEW Core sidecar
  # 3. Restore Core.olean to OLD binary and OLD mtime; keep NEW Core sidecar (matches new source)
  # 4. Restore Host.olean + OLD Host.slakehash (with OLD deps line)
  # 5. Run slake → Core hash-fresh skips (new sidecar + new source + olean present);
  #    Host has old deps line vs new Core source → deps-line-stale rebuild
  cp -a .slake-native/Core.olean "$A11_SCRATCH/core_olean_old"
  cp -a .slake-native/Host.olean "$A11_SCRATCH/host_olean_old"
  cp -a .slake-native/Host.olean.slakehash "$A11_SCRATCH/host_hash_old"
  out_mid="$(run_native_olean)" || rc_mid=$?
  rc_mid="${rc_mid:-0}"
  if [[ "$rc_mid" -ne 0 ]]; then
    echo "FAIL: Run 5 mid compile exited $rc_mid"
    exit 1
  fi
  # Keep new Core sidecar (matches edited Core.lean); restore old Core.olean binary+mtime.
  cp -a "$A11_SCRATCH/core_olean_old" .slake-native/Core.olean
  # Keep Core.olean mtime old relative to Host: restore Host olean + old Host sidecar.
  cp -a "$A11_SCRATCH/host_olean_old" .slake-native/Host.olean
  cp -a "$A11_SCRATCH/host_hash_old" .slake-native/Host.olean.slakehash
  # Ensure Core.olean not newer than Host.olean.
  touch -r .slake-native/Host.olean .slake-native/Core.olean 2>/dev/null || true
  sleep 1
  touch .slake-native/Host.olean
  # Core source is newer than Core.olean → not mtime-fresh, but hash-fresh via new sidecar.
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 5 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skip Core (hash-fresh)"; then
    echo "FAIL: Core should hash-fresh skip (new sidecar matches edited source; old olean present)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (fresh)"; then
    echo "FAIL: Host must not skip when deps line frozen against old Core source"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (hash-fresh)"; then
    echo "FAIL: Host must not hash-skip under deps-line-stale"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "rebuild Host (deps-line-stale)"; then
    echo "FAIL: expected rebuild Host (deps-line-stale) log"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Host\.lean' >/dev/null; then
    echo "FAIL: expected Host lean -o under deps-line-stale"
    exit 1
  fi
  if printf '%s' "$out" | grep -E 'native olean: .* -o .*Core\.lean' >/dev/null; then
    echo "FAIL: Core must not recompile on Run 5 (hash-fresh only)"
    exit 1
  fi
  host_deps_after="$(grep -E '^deps [0-9a-f]{16}$' .slake-native/Host.olean.slakehash | head -1 || true)"
  if [[ -z "$host_deps_after" ]]; then
    echo "FAIL: Host deps line missing after deps-line-stale rebuild"
    exit 1
  fi
  if [[ "$host_deps_after" == "$host_deps_before" ]]; then
    echo "FAIL: Host deps line should change when Core source changed"
    echo "  before=$host_deps_before after=$host_deps_after"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 5"
    exit 1
  fi
  # silence unused-ish locals for shellcheck-friendly paths
  : "${core_line1:-}" "${core_deps:-}"
)

echo "== A11 env identity reports plan-node transitive deps-hash honesty =="
(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_PLAN_ONLY=1
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq "SLAKE_NATIVE_OLEAN: 1" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_OLEAN: 1"
    exit 1
  fi
  if ! grep -Fq "plan-node transitive deps-hash" <<<"$env_out"; then
    echo "FAIL: env must mention plan-node transitive deps-hash"
    exit 1
  fi
  if ! grep -Fq "not Lake package-transitive hash" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty not Lake package-transitive hash"
    exit 1
  fi
  if ! grep -Fq "FNV-1a 64 source content-hash" <<<"$env_out"; then
    echo "FAIL: env must still mention FNV-1a 64 source content-hash"
    exit 1
  fi
)

# Fixture restore + scratch cleanup via trap.
echo "OK: native_olean_deps_hash_smoke (A11 plan-node transitive deps-hash subset)"
exit 0
