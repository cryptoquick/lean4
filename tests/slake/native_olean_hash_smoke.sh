#!/usr/bin/env bash
# Smoke: A10 SLAKE_NATIVE_OLEAN FNV-1a 64 source content-hash sidecar subset.
#
# Honesty: content-hash **source sidecar subset** on the A8/A9 native olean path —
# not freestanding build TCB, not lake-equivalent TCB, not CLAIMED expansion, not
# full olean graph invalidation, not Lake shake/hash TCB, not Lake package-transitive
# hash (A11 plan-node deps-hash is a separate smoke). SCORE does **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with binary present.
#
# systems_shaped: Core before Host (Host imports Core).
#   Run 1: empty .slake-native → compile both, write oleans + .olean.slakehash
#   Run 2: bare touch Core.lean (same bytes) → skip Core (hash-fresh); Host skip fresh
#   Run 3: content-edit Core → Core rebuild + Host cascade
#   Run 4: delete Core.olean keep sidecar → rebuild Core (not hash-fresh; orphan sidecar)
#   PLAN_ONLY still no .lake/build
#
#   SLAKE_NATIVE_OLEAN_HASH_SMOKE_STRICT=1 ./tests/slake/native_olean_hash_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_OLEAN_HASH_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_CACHE_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

echo "== A10 Run 1: PLAN_ONLY+NATIVE_OLEAN compile + write .slakehash sidecars =="
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
    echo "FAIL: expected A10 FNV-1a 64 source content-hash honesty banner"
    exit 1
  fi
  # A11: plan-node transitive deps-hash is shipped; residual is Lake package-transitive.
  if ! printf '%s' "$out" | grep -Fq "not Lake package-transitive hash"; then
    echo "FAIL: expected residual honesty not Lake package-transitive hash"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "plan-node transitive deps-hash"; then
    echo "FAIL: expected A11 plan-node transitive deps-hash honesty banner"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean ]]; then
    echo "FAIL: expected .slake-native/Core.olean after Run 1"
    exit 1
  fi
  if [[ ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: expected .slake-native/Host.olean after Run 1"
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
    echo "FAIL: Core.slakehash must be 'fnv1a64 <16hex> Core'"
    cat .slake-native/Core.olean.slakehash || true
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 1"
    exit 1
  fi
)

echo "== A10 Run 2: touch Core.lean (same bytes) → skip Core (hash-fresh) =="
(
  cd "$SYSTEMS_PKG"
  sleep 1
  # Bump mtime only — content identical to hash sidecar.
  touch Core.lean
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 2 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: skip Core (hash-fresh)"; then
    echo "FAIL: expected skip Core (hash-fresh) after touch-without-edit"
    exit 1
  fi
  # Host source untouched; mtime-fresh skip is fine (or hash-fresh).
  if ! printf '%s' "$out" | grep -E 'native olean: skip Host \(fresh\)|native olean: skip Host \(hash-fresh\)' >/dev/null; then
    echo "FAIL: expected skip Host (fresh or hash-fresh)"
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -ne 0 ]]; then
    echo "FAIL: Run 2 expected 0 lean -o spawns after touch-without-edit, got $spawns"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 2"
    exit 1
  fi
)

echo "== A10 Run 3: content-edit Core → Core rebuild + Host cascade =="
(
  cd "$SYSTEMS_PKG"
  sleep 1
  cp -a Core.lean Core.lean.a10bak
  printf '\n-- A10 hash content bump\n' >> Core.lean
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  mv -f Core.lean.a10bak Core.lean
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
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
  if printf '%s' "$out" | grep -E 'skip Host \(fresh\)|skip Host \(hash-fresh\)' >/dev/null; then
    echo "FAIL: Host must cascade-rebuild when Core recompiled"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Host\.lean' >/dev/null; then
    echo "FAIL: expected Host lean -o cascade rebuild"
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -lt 2 ]]; then
    echo "FAIL: Run 3 expected ≥2 lean -o spawns (Core+Host cascade), got $spawns"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 3"
    exit 1
  fi
)

echo "== A10 Run 4: delete Core.olean keep sidecar → rebuild (not hash-fresh) =="
(
  cd "$SYSTEMS_PKG"
  # Re-seed cache from clean sources (Run 3 restored Core.lean but oleans may be
  # from edited content; FORCE-equivalent: wipe + compile once).
  rm -rf .slake-native 2>/dev/null || true
  out_seed="$(run_native_olean)" || rc_seed=$?
  rc_seed="${rc_seed:-0}"
  if [[ "$rc_seed" -ne 0 ]]; then
    echo "FAIL: Run 4 seed compile exited $rc_seed"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Core.olean.slakehash ]]; then
    echo "FAIL: Run 4 seed must write Core.olean + sidecar"
    exit 1
  fi
  # Orphan sidecar: remove olean only.
  rm -f .slake-native/Core.olean
  if [[ ! -f .slake-native/Core.olean.slakehash ]]; then
    echo "FAIL: sidecar must remain after olean delete"
    exit 1
  fi
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 4 exited $rc (expected 0)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Core (hash-fresh)"; then
    echo "FAIL: orphan sidecar must not hash-fresh-skip when olean is missing"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Core (fresh)"; then
    echo "FAIL: missing olean must not mtime-fresh-skip"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Core\.lean' >/dev/null; then
    echo "FAIL: expected Core lean -o rebuild after olean delete (orphan sidecar)"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean ]]; then
    echo "FAIL: Core.olean must be rewritten after orphan-sidecar rebuild"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 4"
    exit 1
  fi
)

echo "== A10 env identity reports FNV-1a / content-hash honesty =="
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
  if ! grep -Fq "FNV-1a 64 source content-hash" <<<"$env_out"; then
    echo "FAIL: env must mention FNV-1a 64 source content-hash"
    exit 1
  fi
  if ! grep -Fq "not Lake package-transitive hash" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty not Lake package-transitive hash"
    exit 1
  fi
  if ! grep -Fq "plan-node transitive deps-hash" <<<"$env_out"; then
    echo "FAIL: env must mention plan-node transitive deps-hash"
    exit 1
  fi
  if ! grep -Fq "not Lake shake/hash TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty Lake shake/hash TCB"
    exit 1
  fi
)

# Leave fixture non-dirty.
(
  cd "$SYSTEMS_PKG"
  rm -rf .slake-native .lake 2>/dev/null || true
  rm -f Core.lean.a10bak 2>/dev/null || true
)

echo "OK: native_olean_hash_smoke (A10 FNV-1a 64 source content-hash sidecar subset)"
exit 0
