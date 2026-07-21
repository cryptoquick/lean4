#!/usr/bin/env bash
# Smoke: A8 SLAKE_NATIVE_OLEAN=1 multi-module sequential host-lean + olean LEAN_PATH.
#
# Honesty: multi-module sequential host-lean + package-local olean LEAN_PATH subset —
# not freestanding build TCB, not lake-equivalent TCB, not CLAIMED expansion, not full
# olean graph/cache invalidation. SCORE does **not** run this smoke.
#
# Soft-skip when slake binary or host lean missing (parity-preserving).
# Hard-fail when STRICT and binary/lean missing, or claim fails with binary present.
#
# Primary band: systems_shaped (Core before Host; Host imports Core via olean).
# Also: srcdir_shaped (srcDir + dotted Foo.Bar nested oleans + -R); PLAN_ONLY no
# .lake/build; env identity; residual NATIVE_CHECK multi-module note; both-flag
# olean-wins; ill-typed / STRICT missing-file fail-closed.
#
#   SLAKE_NATIVE_OLEAN_SMOKE_STRICT=1 ./tests/slake/native_olean_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
SRCDIR_PKG="$ROOT/srcdir_shaped"
BASIC_PKG="$ROOT/parity/basic_toml"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

# Host lean for compile (stage1 preferred when PATH already set in CI/smokes).
LEAN_PROBE="${LEAN:-lean}"
if ! command -v "$LEAN_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEAN_PROBE" ]]; then
  strict_fail "host lean not found (set LEAN= or PATH to stage1/bin)"
fi

if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi

echo "== A8 SLAKE_PLAN_ONLY=1 + SLAKE_NATIVE_OLEAN=1 on systems_shaped (Core→Host oleans; no lake) =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  rm -f ./*.olean 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_OLEAN exited $rc (expected 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected systems_shaped Core Host plan (NATIVE_OLEAN implies plan; topo Core before Host)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_OLEAN=1"; then
    echo "FAIL: expected NATIVE_OLEAN banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "multi-module sequential host-lean + olean LEAN_PATH"; then
    echo "FAIL: expected multi-module sequential host-lean + olean LEAN_PATH honesty"
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
  if ! printf '%s' "$out" | grep -Fq "not full olean graph invalidation"; then
    echo "FAIL: expected residual honesty (not full olean graph invalidation)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean: "; then
    echo "FAIL: expected native olean lean invocation line"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "Core.lean"; then
    echo "FAIL: expected Core.lean in olean walk (topo first)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "Host.lean"; then
    echo "FAIL: expected Host.lean in olean walk (after Core)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: expected native olean OK (Host must import Core via olean LEAN_PATH)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq "native olean OK \(host lean sequential \+ olean LEAN_PATH; [1-9][0-9]* module"; then
    echo "FAIL: expected nonzero module count in native olean OK banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "skipping lake"; then
    echo "FAIL: PLAN_ONLY must still skip lake after native olean"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_OLEAN must not create .lake/build via lake"
    exit 1
  fi
  if [[ ! -f .slake-native/Core.olean ]]; then
    echo "FAIL: expected package-local .slake-native/Core.olean"
    exit 1
  fi
  if [[ ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: expected package-local .slake-native/Host.olean"
    exit 1
  fi
  # Clean oleans so later bands start clean (leave fixture non-dirty).
  rm -rf .slake-native 2>/dev/null || true
)

echo "== A8 env identity reports NATIVE_OLEAN =="
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
  if ! grep -Fq "multi-module sequential host-lean + olean LEAN_PATH subset" <<<"$env_out"; then
    echo "FAIL: env must claim multi-module sequential host-lean + olean LEAN_PATH subset honesty"
    exit 1
  fi
  if ! grep -Fq "PLAN_ONLY + NATIVE_OLEAN" <<<"$env_out"; then
    echo "FAIL: env must document PLAN_ONLY + NATIVE_OLEAN still skips lake"
    exit 1
  fi
  if ! grep -Fq "not freestanding build TCB" <<<"$env_out"; then
    echo "FAIL: env must residual-honesty freestanding build TCB"
    exit 1
  fi
)

echo "== A8 env both-flag honesty: olean wins over NATIVE_CHECK =="
(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_CHECK=1
  export SLAKE_PLAN_ONLY=1
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq "olean path wins" <<<"$env_out"; then
    echo "FAIL: env must document olean path wins when both NATIVE flags set"
    exit 1
  fi
  if ! grep -Fq "thin NATIVE_CHECK typecheck skipped" <<<"$env_out"; then
    echo "FAIL: env must document thin NATIVE_CHECK typecheck skipped when both set"
    exit 1
  fi
)

echo "== A8 residual contrast: NATIVE_CHECK alone on systems_shaped may fail Host without oleans =="
(
  # Document interaction: thin typecheck without olean LEAN_PATH is residual for multi-module.
  # Do not require Host fail (lucky LEAN_PATH possible); require plan + Core attempt.
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  rm -f ./*.olean 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_CHECK=1
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_CHECK_STRICT || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: systems_shaped Core Host"; then
    echo "FAIL: expected systems_shaped Core Host plan under NATIVE_CHECK residual band"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "Core.lean"; then
    echo "FAIL: expected Core.lean in native check walk"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native check OK"; then
    echo "NOTE: multi-module systems_shaped fully typechecked under thin host lean (lucky LEAN_PATH/oleans); still not freestanding build TCB"
  elif printf '%s' "$out" | grep -Fq "native check failed for module Host"; then
    echo "NOTE: Host failed after Core without olean path (expected residual; NATIVE_OLEAN closes this gap)"
    if [[ "$rc" -eq 0 ]]; then
      echo "FAIL: Host typecheck fail must exit nonzero"
      exit 1
    fi
  else
    echo "FAIL: expected either native check OK or Host module fail for residual contrast band"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on residual contrast band"
    exit 1
  fi
)

echo "== A8 negative: non-Lean LEAN=/bin/true rejected (STRICT) =="
(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_OLEAN_STRICT=1
  export LEAN=/bin/true
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: LEAN=/bin/true must not green-wash under NATIVE_OLEAN STRICT"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq "lean not found or not a real Lean binary|STRICT"; then
    echo "FAIL: expected real-Lean rejection banner under LEAN=/bin/true STRICT"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: must not print native olean OK when lean is /bin/true"
    exit 1
  fi
)

echo "== A8 single-module basic_toml still green under NATIVE_OLEAN =="
(
  if [[ ! -d "$BASIC_PKG" ]]; then
    echo "SKIP: basic_toml fixture missing"
    exit 0
  fi
  cd "$BASIC_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: basic_toml PLAN_ONLY+NATIVE_OLEAN exited $rc"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: expected native olean OK on basic_toml"
    exit 1
  fi
  if [[ ! -f .slake-native/BasicToml.olean ]]; then
    echo "FAIL: expected .slake-native/BasicToml.olean"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on basic_toml olean band"
    exit 1
  fi
  rm -rf .slake-native 2>/dev/null || true
)

echo "== A8 srcdir_shaped: srcDir + dotted Foo.Bar nested oleans + -R =="
(
  if [[ ! -d "$SRCDIR_PKG" ]]; then
    echo "SKIP: srcdir_shaped fixture missing"
    exit 0
  fi
  cd "$SRCDIR_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: srcdir_shaped PLAN_ONLY+NATIVE_OLEAN exited $rc"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "slake depgraph plan: srcdir_shaped Foo.Bar Host"; then
    echo "FAIL: expected srcdir_shaped Foo.Bar Host plan under NATIVE_OLEAN"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: expected native olean OK on srcdir_shaped"
    exit 1
  fi
  # Nested olean path for dotted module; Host under src/ uses -R src.
  if ! printf '%s' "$out" | grep -Fq ".slake-native/Foo/Bar.olean"; then
    echo "FAIL: expected package-relative .slake-native/Foo/Bar.olean in olean argv"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq -- '-R src'; then
    echo "FAIL: expected -R src for modules resolved under srcDir"
    exit 1
  fi
  if [[ ! -f .slake-native/Foo/Bar.olean ]]; then
    echo "FAIL: expected .slake-native/Foo/Bar.olean on disk"
    exit 1
  fi
  if [[ ! -f .slake-native/Host.olean ]]; then
    echo "FAIL: expected .slake-native/Host.olean on disk"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on srcdir_shaped olean band"
    exit 1
  fi
  rm -rf .slake-native 2>/dev/null || true
)

echo "== A8 both-flag build: olean runs; no thin native check OK banner =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_CHECK=1
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: both-flag PLAN_ONLY+NATIVE_OLEAN+NATIVE_CHECK exited $rc"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: expected native olean OK when both NATIVE flags set"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native check OK"; then
    echo "FAIL: must not print native check OK when NATIVE_OLEAN wins (superset)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_CHECK=1; sequential host-lean typecheck"; then
    echo "FAIL: must not run thin NATIVE_CHECK path when NATIVE_OLEAN is set"
    exit 1
  fi
  rm -rf .slake-native 2>/dev/null || true
)

echo "== A8 negative: ill-typed module fails closed (PLAN_ONLY+NATIVE_OLEAN) =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-no-bad.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "bad_no"
version = "0.1.0"
defaultTargets = ["BadNo"]

[[lean_lib]]
name = "BadNo"
EOF
  cat >"$tmp/BadNo.lean" <<'EOF'
module

/-!
Ill-typed fixture for A8 native_olean_smoke negative band.
-/

def x : Nat := "not a nat"
EOF
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: ill-typed BadNo must exit nonzero under NATIVE_OLEAN"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean failed for module BadNo"; then
    echo "FAIL: expected 'native olean failed for module BadNo'"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: must not print native olean OK on typecheck fail"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build on typecheck fail"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A8 negative: STRICT missing module file fails closed =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-no-miss.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "miss_no"
version = "0.1.0"
defaultTargets = ["MissingMod"]

[[lean_lib]]
name = "MissingMod"
EOF
  # Intentionally no MissingMod.lean
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  export SLAKE_NATIVE_OLEAN_STRICT=1
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT missing module must exit nonzero under NATIVE_OLEAN"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eq "missing file for MissingMod|no modules compiled \(STRICT\)"; then
    echo "FAIL: expected STRICT missing-file or no-modules banner under NATIVE_OLEAN"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: must not print native olean OK on STRICT missing file"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A8 flat-fallback under srcDir: no -R when module only exists at package root =="
(
  # Regression for Issue 1: package declares srcDir but plan module file lives only
  # at package root (A6 flat fallback). Must compile without -R src (lean requires
  # input under -R root).
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-no-flat.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/src"
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "flat_fb"
version = "0.1.0"
srcDir = "src"
defaultTargets = ["FlatOnly"]

[[lean_lib]]
name = "FlatOnly"
EOF
  # Only at package root — not under src/
  cat >"$tmp/FlatOnly.lean" <<'EOF'
module

/-!
A6 flat package-root fallback fixture for A8 -R regression.
-/

def marker : Nat := 1
EOF
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_OLEAN=1
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_DEPGRAPH || true
  unset LEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: flat fallback under srcDir must compile without -R (exit $rc)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native olean OK"; then
    echo "FAIL: expected native olean OK for flat fallback under srcDir"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eq -- '-R src'; then
    echo "FAIL: must not pass -R src when resolved file is flat package-root fallback"
    exit 1
  fi
  if [[ ! -f .slake-native/FlatOnly.olean ]]; then
    echo "FAIL: expected .slake-native/FlatOnly.olean"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "native_olean_smoke: OK"
