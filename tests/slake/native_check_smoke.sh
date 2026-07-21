#!/usr/bin/env bash
# Smoke: A7 SLAKE_NATIVE_CHECK=1 sequential host-lean typecheck after package plan.
#
# Honesty: thin sequential host-lean typecheck subset — not freestanding build TCB,
# not olean orchestration, not CLAIMED expansion. SCORE does **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with binary present.
#
# Bands: green PLAN_ONLY+NATIVE on basic_toml; env; NATIVE alone; STRICT negatives
# (ill-typed module, missing module file, non-Lean LEAN=); soft multi-module residual note.
#
#   SLAKE_NATIVE_CHECK_SMOKE_STRICT=1 ./tests/slake/native_check_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/parity/basic_toml"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_CHECK_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

# Host lean for typecheck (stage1 preferred when PATH already set in CI/smokes).
LEAN_PROBE="${LEAN:-lean}"
if ! command -v "$LEAN_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEAN_PROBE" ]]; then
  strict_fail "host lean not found (set LEAN= or PATH to stage1/bin)"
fi

echo "== A7 SLAKE_PLAN_ONLY=1 + SLAKE_NATIVE_CHECK=1 on $PKG (no lake) =="
(
  cd "$PKG"
  rm -rf .lake 2>/dev/null || true
  # Clean any prior oleans next to sources so check is source-only honesty.
  rm -f ./*.olean 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_CHECK=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK_STRICT || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_CHECK exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: basic_toml BasicToml"; then
    echo "FAIL: expected package plan line (NATIVE_CHECK implies plan)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_CHECK=1"; then
    echo "FAIL: expected NATIVE_CHECK banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "sequential host-lean typecheck"; then
    echo "FAIL: expected sequential host-lean typecheck honesty"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
    echo "FAIL: expected residual honesty (not freestanding build TCB)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not olean orchestration"; then
    echo "FAIL: expected residual honesty (not olean orchestration)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not CLAIMED"; then
    echo "FAIL: expected residual honesty (not CLAIMED)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native check: "; then
    echo "FAIL: expected native check lean invocation line for BasicToml"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "BasicToml.lean"; then
    echo "FAIL: expected BasicToml.lean in native check path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native check OK"; then
    echo "FAIL: expected native check OK"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq "native check OK \(host lean sequential; [1-9][0-9]* module"; then
    echo "FAIL: expected nonzero module count in native check OK banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake"; then
    echo "FAIL: PLAN_ONLY must still skip lake after native check"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_CHECK must not create .lake/build via lake"
    exit 1
  fi
)

echo "== A7 env identity reports NATIVE_CHECK =="
(
  cd "$PKG"
  export SLAKE_NATIVE_CHECK=1
  export SLAKE_PLAN_ONLY=1
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq "SLAKE_NATIVE_CHECK: 1" <<<"$env_out"; then
    echo "FAIL: env must report SLAKE_NATIVE_CHECK: 1"
    exit 1
  fi
  if ! grep -Fq "thin sequential host-lean typecheck" <<<"$env_out"; then
    echo "FAIL: env must claim thin sequential host-lean typecheck honesty"
    exit 1
  fi
  if ! grep -Fq "PLAN_ONLY + NATIVE_CHECK" <<<"$env_out"; then
    echo "FAIL: env must document PLAN_ONLY + NATIVE_CHECK still skips lake"
    exit 1
  fi
)

echo "== A7 NATIVE_CHECK alone still implies plan (may lake; soft assert plan banner) =="
(
  cd "$PKG"
  rm -rf .lake 2>/dev/null || true
  export SLAKE_NATIVE_CHECK=1
  unset SLAKE_PLAN_ONLY || true
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_CHECK_STRICT || true
  unset LEAN || true
  # Only assert plan+check banners; do not require full lake success (package may
  # need toolchain/network in some envs). Prefer PLAN_ONLY path for no-lake green.
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan:"; then
    echo "FAIL: NATIVE_CHECK without PLAN_ONLY must still print package plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_CHECK=1"; then
    echo "FAIL: expected NATIVE_CHECK banner without PLAN_ONLY"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native check OK"; then
    echo "FAIL: expected native check OK before lake"
    exit 1
  fi
  # If native check ran OK, lake may still fail for unrelated reasons — only fail
  # when native check itself failed (nonzero before lake banners).
  if printf '%s' "$out" | grep -Fq "native check failed"; then
    echo "FAIL: native check failed under NATIVE_CHECK alone"
    exit 1
  fi
  # Soft: if lake was attempted after check, that is expected without PLAN_ONLY.
  if printf '%s' "$out" | grep -Fq "skipping lake"; then
    echo "FAIL: NATIVE_CHECK without PLAN_ONLY must not skip lake"
    exit 1
  fi
  # Clean lake artifacts if created so later smokes stay isolated.
  rm -rf .lake 2>/dev/null || true
)

echo "== A7 negative: ill-typed module fails closed (PLAN_ONLY+NATIVE) =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-nc-bad.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "bad_nc"
version = "0.1.0"
defaultTargets = ["BadNc"]

[[lean_lib]]
name = "BadNc"
EOF
  cat >"$tmp/BadNc.lean" <<'EOF'
module

/-!
Ill-typed fixture for A7 native_check_smoke negative band.
-/

def x : Nat := "not a nat"
EOF
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_CHECK=1
  unset SLAKE_NATIVE_CHECK_STRICT || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: ill-typed BadNc must exit nonzero under NATIVE_CHECK"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native check failed for module BadNc"; then
    echo "FAIL: expected 'native check failed for module BadNc'"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on typecheck fail"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A7 negative: STRICT missing module file fails closed =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-nc-miss.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "miss_nc"
version = "0.1.0"
defaultTargets = ["MissingMod"]

[[lean_lib]]
name = "MissingMod"
EOF
  # Intentionally no MissingMod.lean
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_CHECK=1
  export SLAKE_NATIVE_CHECK_STRICT=1
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT missing module must exit nonzero"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq "missing file for MissingMod|no modules typechecked \(STRICT\)"; then
    echo "FAIL: expected STRICT missing-file or no-modules banner"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A7 negative: non-Lean LEAN=/bin/true rejected (STRICT) =="
(
  cd "$PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_CHECK=1
  export SLAKE_NATIVE_CHECK_STRICT=1
  export LEAN=/bin/true
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: LEAN=/bin/true must not green-wash under STRICT"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq "lean not found or not a real Lean binary|STRICT"; then
    echo "FAIL: expected real-Lean rejection banner under LEAN=/bin/true STRICT"
    exit 1
  fi
  # Must not claim native check OK via fake lean.
  if printf '%s' "$out" | grep -Fq "native check OK"; then
    echo "FAIL: must not print native check OK when lean is /bin/true"
    exit 1
  fi
)

echo "== A7 residual note: multi-module systems_shaped (not multi-module TCB claim) =="
(
  # Soft residual documentation band: Core typechecks alone; Host imports Core and
  # may fail without oleans. We assert plan + Core attempt; do **not** claim full
  # multi-module freestanding compile TCB.
  if [[ ! -d "$SYSTEMS_PKG" ]]; then
    echo "SKIP: systems_shaped fixture missing"
    exit 0
  fi
  cd "$SYSTEMS_PKG"
  rm -rf .lake 2>/dev/null || true
  rm -f ./*.olean 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_CHECK=1
  unset SLAKE_NATIVE_CHECK_STRICT || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected systems_shaped Core Host plan under NATIVE_CHECK"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "Core.lean"; then
    echo "FAIL: expected Core.lean in native check walk (topo first)"
    exit 1
  fi
  # Residual honesty: either Core+Host both OK (if oleans/LEAN_PATH enough) OR
  # Host fails import without claiming multi-module TCB. Never silent green-wash.
  if printf '%s' "$out" | grep -Fq "native check OK"; then
    echo "NOTE: multi-module systems_shaped fully typechecked under thin host lean (lucky LEAN_PATH/oleans); still not freestanding build TCB"
  elif printf '%s' "$out" | grep -Fq "native check failed for module Host"; then
    echo "NOTE: Host failed after Core (expected olean/import residual; not multi-module TCB claim)"
    if [[ "$rc" -eq 0 ]]; then
      echo "FAIL: Host typecheck fail must exit nonzero"
      exit 1
    fi
  else
    echo "FAIL: expected either native check OK or Host module fail for systems_shaped residual band"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on systems_shaped band"
    exit 1
  fi
)

echo "native_check_smoke: OK"
