#!/usr/bin/env bash
# Smoke: A9 SLAKE_NATIVE_OLEAN mtime + plan-edge cascade cache invalidation subset.
#
# Honesty: mtime + plan-edge cascade cache invalidation subset on the A8 native
# olean path — not freestanding build TCB, not lake-equivalent TCB, not CLAIMED
# expansion, not full olean graph invalidation, not Lake shake/hash TCB.
# (A10 adds FNV-1a 64 source content-hash; this smoke still proves A9 cascade.
# Bare touch is hash-fresh under A10 — Run 3 uses a real content edit.)
# SCORE does **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with binary present.
#
# systems_shaped: Core before Host (Host imports Core).
#   Run 1: empty .slake-native → compile both, write oleans
#   Run 2: fresh → skip Core + Host (fresh banners; no lean spawn for either)
#   Run 3: content-edit Core.lean → Core rebuild + Host cascade (bare touch is
#          hash-fresh under A10; content edit invalidates hash + cascades)
#   Run 4 (optional FORCE): rebuild all despite fresh oleans
#   Run 5: rewrite Core.olean only (interrupted-run sim) → Host cascade via dep-olean-newer
#   PLAN_ONLY still no .lake/build
#
#   SLAKE_NATIVE_OLEAN_CACHE_SMOKE_STRICT=1 ./tests/slake/native_olean_cache_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_OLEAN_CACHE_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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
    # Caller may set/unset FORCE.
    unset LEAN || true
    "$SLAKE_EXE" build 2>&1
  )
}

count_lean_spawns() {
  # Count host lean compile lines (not skip banners).
  printf '%s' "$1" | grep -c 'native olean: .* -o ' || true
}

echo "== A9 Run 1: PLAN_ONLY+NATIVE_OLEAN compile Core+Host (empty outdir) =="
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
  if ! printf '%s' "$out" | grep -Fq "mtime + plan-edge cascade cache invalidation subset"; then
    echo "FAIL: expected A9 mtime + plan-edge cascade honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
    echo "FAIL: expected residual honesty (not freestanding build TCB)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not lake-equivalent TCB"; then
    echo "FAIL: expected residual honesty (not lake-equivalent TCB)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not CLAIMED"; then
    echo "FAIL: expected residual honesty (not CLAIMED)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not Lake shake/hash TCB"; then
    echo "FAIL: expected residual honesty (not Lake shake/hash TCB)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not full olean graph invalidation"; then
    echo "FAIL: expected residual honesty (not full olean graph invalidation)"
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -lt 2 ]]; then
    echo "FAIL: Run 1 expected ≥2 lean -o spawns, got $spawns"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Core (fresh)"; then
    echo "FAIL: Run 1 must not skip Core (empty outdir)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: expected native olean OK on Run 1"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake"; then
    echo "FAIL: PLAN_ONLY must still skip lake"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
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
)

echo "== A9 Run 2: same inputs → skip both fresh (no lean -o) =="
(
  cd "$SYSTEMS_PKG"
  # Ensure second-resolution mtime clocks cannot claim source is newer than olean
  # written in Run 1 on coarse FS (sleep 0 is usually fine; belt-and-suspenders).
  sleep 1
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 2 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: skip Core (fresh)"; then
    echo "FAIL: expected skip Core (fresh)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: skip Host (fresh)"; then
    echo "FAIL: expected skip Host (fresh)"
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -ne 0 ]]; then
    echo "FAIL: Run 2 expected 0 lean -o spawns for fresh oleans, got $spawns"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipped fresh"; then
    echo "FAIL: expected skipped fresh count in OK banner"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on Run 2"
    exit 1
  fi
)

echo "== A9 Run 3: content-edit Core.lean → Core rebuild + Host cascade =="
(
  cd "$SYSTEMS_PKG"
  # A10: bare touch is hash-fresh (content-hash sidecar). Cascade band needs a real
  # content edit so mtime+hash both invalidate Core (Host still cascade-rebuilds).
  sleep 1
  cp -a Core.lean Core.lean.a9bak
  printf '\n-- A9 cascade content bump\n' >> Core.lean
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  mv -f Core.lean.a9bak Core.lean
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
  if printf '%s' "$out" | grep -Fq "skip Host (fresh)"; then
    echo "FAIL: Host must cascade-rebuild when Core recompiled (not skip solely by Host mtime)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (hash-fresh)"; then
    echo "FAIL: Host must cascade-rebuild when Core recompiled (not skip hash-fresh)"
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

echo "== A9 Run 4: FORCE=1 rebuilds all despite fresh =="
(
  cd "$SYSTEMS_PKG"
  sleep 1
  # Leave oleans from Run 3; without FORCE both would skip.
  export SLAKE_NATIVE_OLEAN_FORCE=1
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 4 FORCE exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_OLEAN_FORCE=1"; then
    echo "FAIL: expected FORCE banner"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Core (fresh)"; then
    echo "FAIL: FORCE must not skip Core"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (fresh)"; then
    echo "FAIL: FORCE must not skip Host"
    exit 1
  fi
  spawns="$(count_lean_spawns "$out")"
  if [[ "$spawns" -lt 2 ]]; then
    echo "FAIL: FORCE expected ≥2 lean -o spawns, got $spawns"
    exit 1
  fi
)

echo "== A9 Run 5: dep-olean-newer (rewrite Core.olean only → Host cascade) =="
(
  cd "$SYSTEMS_PKG"
  # Both oleans from Run 4 are fresh vs sources. Simulate interrupted/external Core
  # rebuild: rewrite only Core.olean so it is newer than Host.olean without touching
  # Core.lean / Host.lean (no this-run recompile tracking).
  sleep 1
  LEAN_CMD="${LEAN:-lean}"
  export LEAN_PATH="$SYSTEMS_PKG/.slake-native${LEAN_PATH:+:$LEAN_PATH}"
  if ! "$LEAN_CMD" -o .slake-native/Core.olean Core.lean; then
    echo "FAIL: manual Core.olean rewrite for dep-olean-newer band failed"
    exit 1
  fi
  unset LEAN_PATH || true
  # Ensure Host.olean is older than Core.olean (manual rewrite just now).
  # Host.lean must remain older than Host.olean so source-mtime alone would skip Host.
  out="$(run_native_olean)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: Run 5 exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skip Core (fresh)"; then
    echo "FAIL: Core source+olean both fresh — expected skip Core (fresh)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "skip Host (fresh)"; then
    echo "FAIL: Host must cascade-rebuild when Core.olean is newer than Host.olean"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -E 'native olean: .* -o .*Host\.lean' >/dev/null; then
    echo "FAIL: expected Host lean -o cascade via dep-olean-newer"
    exit 1
  fi
)

echo "== A9 env identity reports FORCE + cascade honesty =="
(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_OLEAN_FORCE=1
  export SLAKE_PLAN_ONLY=1
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq "SLAKE_NATIVE_OLEAN: 1" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_OLEAN: 1"
    exit 1
  fi
  if ! grep -Fq "SLAKE_NATIVE_OLEAN_FORCE: 1" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_OLEAN_FORCE: 1"
    exit 1
  fi
  if ! grep -Fq "mtime + plan-edge cascade" <<<"$env_out"; then
    echo "FAIL: env must mention mtime + plan-edge cascade"
    exit 1
  fi
  if ! grep -Fq "not Lake shake/hash TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty Lake shake/hash TCB"
    exit 1
  fi
  if ! grep -Fq "always rebuild all plan modules" <<<"$env_out"; then
    echo "FAIL: env FORCE narrative missing"
    exit 1
  fi
  if ! grep -Fq "PLAN_ONLY + NATIVE_OLEAN + FORCE" <<<"$env_out"; then
    echo "FAIL: env must qualify PLAN_ONLY+NATIVE_OLEAN with FORCE (not bare skip-fresh)"
    exit 1
  fi
  if grep -Fq "PLAN_ONLY + NATIVE_OLEAN — plan, sequential olean compile (skip fresh), still skip lake" <<<"$env_out"; then
    echo "FAIL: bare skip-fresh PLAN_ONLY line must not appear when FORCE is set"
    exit 1
  fi
)

# Leave fixture non-dirty.
(
  cd "$SYSTEMS_PKG"
  rm -rf .slake-native .lake 2>/dev/null || true
)

echo "OK: native_olean_cache_smoke (A9 mtime + plan-edge cascade subset)"
exit 0
