#!/usr/bin/env bash
# Smoke: A17 slake clean wipes package-local .slake-native (native product out dir
# wipe subset with .lake/build).
#
# Honesty: CLAIMED clean semantic growth within (build clean env test) — not full
# Lake clean set, not freestanding build TCB expansion beyond hygiene, not Lake
# lean_lib SO. SCORE does **not** run this smoke.
#
# Soft-skip when slake binary missing (parity-preserving).
# Hard-fail when STRICT and binary missing, or claim fails with binary present.
# Under STRICT, missing host lean fails the olean integration band (no soft-OK).
#
# Bands (execution order):
#   1) Marker-only .slake-native wiped by native clean
#   2) Symlink fence: .slake-native as symlink → refuse + nonzero
#   3) PLAN_ONLY + NATIVE_OLEAN creates oleans under systems_shaped; slake clean
#      removes .slake-native (and .lake/build if present); no oleans left
#   4) FS_PROC dual residual: marker under .slake-native → SLAKE_USE_FS_PROC=1
#      clean → freestanding banner + .slake-native gone (soft-skip if unlinked)
#   5) FS_PROC_PIPE dual residual (same; soft-skip if pipe unlinked)
#
#   SLAKE_NATIVE_CLEAN_SMOKE_STRICT=1 ./tests/slake/native_clean_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_CLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

# Host lean for olean band.
LEAN_PROBE="${LEAN:-lean}"
have_lean=0
if command -v "$LEAN_PROBE" >/dev/null 2>&1 || [[ -x "$LEAN_PROBE" ]]; then
  have_lean=1
fi

if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi

# Band run tracking for final OK honesty (Issue 3).
band_marker=0
band_symlink=0
band_olean=0
band_fs_proc=0
band_fs_pipe=0

echo "== A17 clean: marker-only .slake-native wipe =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  mkdir -p .slake-native
  printf 'a17-marker\n' > .slake-native/marker
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: slake clean exited $rc with marker .slake-native"
    exit 1
  fi
  if [[ -d .slake-native ]]; then
    echo "FAIL: .slake-native still present after clean"
    ls -la .slake-native 2>/dev/null || true
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: .lake/build still present after clean"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq '.slake-native'; then
    echo "FAIL: clean output missing .slake-native remove line"
    exit 1
  fi
  echo "OK: marker-only .slake-native wiped"
) || exit 1
band_marker=1

echo "== A17 clean: symlink fence on .slake-native =="
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  # Point symlink at a disposable foreign dir under the package (not monorepo roots).
  foreign="$(mktemp -d "$SYSTEMS_PKG/.a17-foreign-XXXXXX")"
  printf 'keep\n' > "$foreign/keep"
  ln -s "$(basename "$foreign")" .slake-native
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_USE_FS_PROC_PIPE || true
  out_rc=0
  out="$("$SLAKE_EXE" clean 2>&1)" || out_rc=$?
  printf '%s\n' "$out"
  if [[ "$out_rc" -eq 0 ]]; then
    echo "FAIL: clean accepted symlink .slake-native (expected refuse + nonzero)"
    rm -rf .slake-native "$foreign" 2>/dev/null || true
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'refuse symlink|symlink path'; then
    echo "FAIL: clean symlink band missing refuse-symlink message"
    rm -rf .slake-native "$foreign" 2>/dev/null || true
    exit 1
  fi
  if [[ ! -f "$foreign/keep" ]]; then
    echo "FAIL: symlink fence failed — foreign target was wiped"
    rm -rf .slake-native "$foreign" 2>/dev/null || true
    exit 1
  fi
  rm -rf .slake-native "$foreign" 2>/dev/null || true
  echo "OK: .slake-native symlink refused (fence)"
) || exit 1
band_symlink=1

if [[ "$have_lean" -eq 1 ]]; then
  echo "== A17 clean: after PLAN_ONLY+NATIVE_OLEAN oleans are gone =="
  (
    cd "$SYSTEMS_PKG"
    rm -rf .lake .slake-native 2>/dev/null || true
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_OLEAN=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_USE_FS_PROC_PIPE || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset LEAN || true
    out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
    rc="${rc:-0}"
    printf '%s\n' "$out"
    if [[ "$rc" -ne 0 ]]; then
      echo "FAIL: PLAN_ONLY+NATIVE_OLEAN exited $rc"
      exit 1
    fi
    if [[ ! -f .slake-native/Core.olean || ! -f .slake-native/Host.olean ]]; then
      echo "FAIL: expected oleans under .slake-native/ before clean"
      ls -la .slake-native 2>/dev/null || true
      exit 1
    fi
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_NATIVE_OLEAN || true
    out_c="$("$SLAKE_EXE" clean 2>&1)" || rc_c=$?
    rc_c="${rc_c:-0}"
    printf '%s\n' "$out_c"
    if [[ "$rc_c" -ne 0 ]]; then
      echo "FAIL: slake clean after oleans exited $rc_c"
      exit 1
    fi
    if [[ -d .slake-native ]]; then
      echo "FAIL: .slake-native still present after clean (oleans should be gone)"
      ls -laR .slake-native 2>/dev/null || true
      exit 1
    fi
    if [[ -d .lake/build ]]; then
      echo "FAIL: .lake/build still present after clean"
      exit 1
    fi
    if [[ -f Core.olean || -f Host.olean ]]; then
      echo "FAIL: stray package-root oleans after clean"
      exit 1
    fi
    echo "OK: clean removed .slake-native after native olean compile"
  ) || exit 1
  band_olean=1
else
  # Issue 3: under STRICT, missing lean fails closed for the olean integration band.
  if [[ "${SLAKE_NATIVE_CLEAN_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL (STRICT): host lean missing — PLAN_ONLY+NATIVE_OLEAN clean band required under STRICT"
    echo "      set LEAN= or PATH to stage1/bin, or run without SLAKE_NATIVE_CLEAN_SMOKE_STRICT=1"
    exit 1
  fi
  echo "SKIP band: host lean missing — PLAN_ONLY+NATIVE_OLEAN clean band"
fi

# Dual residual FS_PROC / PIPE: after lake clean, native wipe of .slake-native (A17).
# Soft-skip when shim unlinked (parity-preserving dual residual honesty).
env_out="$("$SLAKE_EXE" env 2>&1)" || true
fs_linked=0
pipe_linked=0
if grep -Fq "SLAKE_FS_PROC_LINKED: 1" <<<"$env_out"; then
  fs_linked=1
fi
if grep -Fq "SLAKE_FS_PROC_PIPE_LINKED: 1" <<<"$env_out"; then
  pipe_linked=1
fi

if [[ "$fs_linked" -eq 1 ]]; then
  echo "== A17 clean: FS_PROC dual residual wipes .slake-native after lake clean =="
  (
    cd "$SYSTEMS_PKG"
    rm -rf .lake .slake-native 2>/dev/null || true
    mkdir -p .slake-native
    printf 'a17-fs-proc-marker\n' > .slake-native/marker
    export SLAKE_USE_FS_PROC=1
    unset SLAKE_USE_FS_PROC_PIPE || true
    unset SLAKE_FS_PROC_STRICT || true
    out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
    rc="${rc:-0}"
    printf '%s\n' "$out"
    if [[ "$rc" -ne 0 ]]; then
      echo "FAIL: FS_PROC clean exited $rc"
      exit 1
    fi
    if printf '%s' "$out" | grep -Eiq 'falling back to native clean'; then
      echo "FAIL: FS_PROC clean fell back to native (expected freestanding path)"
      exit 1
    fi
    if ! printf '%s' "$out" | grep -Fq "SLAKE_USE_FS_PROC=1"; then
      echo "FAIL: expected SLAKE_USE_FS_PROC=1 clean banner"
      exit 1
    fi
    if ! printf '%s' "$out" | grep -Fq "Systems.Proc"; then
      echo "FAIL: expected freestanding Systems.Proc clean path"
      exit 1
    fi
    if [[ -d .slake-native ]]; then
      echo "FAIL: .slake-native still present after FS_PROC clean"
      ls -la .slake-native 2>/dev/null || true
      exit 1
    fi
    if ! printf '%s' "$out" | grep -Fq '.slake-native'; then
      echo "FAIL: FS_PROC clean output missing .slake-native remove line"
      exit 1
    fi
    echo "OK: FS_PROC clean wiped .slake-native after lake clean"
  ) || exit 1
  band_fs_proc=1
else
  if [[ "${SLAKE_NATIVE_CLEAN_SMOKE_STRICT:-}" == "1" ]]; then
    # Driver in this tree is expected to link FS_PROC; hard-fail under STRICT.
    echo "FAIL (STRICT): SLAKE_FS_PROC_LINKED != 1 — FS_PROC dual residual clean band required"
    printf '%s\n' "$env_out" | grep -E 'FS_PROC|LINKED' || true
    exit 1
  fi
  echo "SKIP band: FS_PROC shim not linked — dual residual .slake-native wipe"
fi

if [[ "$pipe_linked" -eq 1 ]]; then
  echo "== A17 clean: FS_PROC_PIPE dual residual wipes .slake-native after lake clean =="
  (
    cd "$SYSTEMS_PKG"
    rm -rf .lake .slake-native 2>/dev/null || true
    mkdir -p .slake-native
    printf 'a17-fs-pipe-marker\n' > .slake-native/marker
    export SLAKE_USE_FS_PROC_PIPE=1
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_FS_PROC_STRICT || true
    out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
    rc="${rc:-0}"
    printf '%s\n' "$out"
    if [[ "$rc" -ne 0 ]]; then
      echo "FAIL: FS_PROC_PIPE clean exited $rc"
      exit 1
    fi
    if printf '%s' "$out" | grep -Eiq 'falling back to native clean'; then
      echo "FAIL: FS_PROC_PIPE clean fell back to native (expected freestanding path)"
      exit 1
    fi
    if ! printf '%s' "$out" | grep -Fq "SLAKE_USE_FS_PROC_PIPE=1"; then
      echo "FAIL: expected SLAKE_USE_FS_PROC_PIPE=1 clean banner"
      exit 1
    fi
    if ! printf '%s' "$out" | grep -Eqi 'Systems\.Proc pipe|pipe/stdio'; then
      echo "FAIL: expected freestanding Systems.Proc pipe clean path"
      exit 1
    fi
    if [[ -d .slake-native ]]; then
      echo "FAIL: .slake-native still present after FS_PROC_PIPE clean"
      ls -la .slake-native 2>/dev/null || true
      exit 1
    fi
    if ! printf '%s' "$out" | grep -Fq '.slake-native'; then
      echo "FAIL: FS_PROC_PIPE clean output missing .slake-native remove line"
      exit 1
    fi
    echo "OK: FS_PROC_PIPE clean wiped .slake-native after lake clean"
  ) || exit 1
  band_fs_pipe=1
else
  if [[ "${SLAKE_NATIVE_CLEAN_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL (STRICT): SLAKE_FS_PROC_PIPE_LINKED != 1 — PIPE dual residual clean band required"
    printf '%s\n' "$env_out" | grep -E 'FS_PROC|LINKED' || true
    exit 1
  fi
  echo "SKIP band: FS_PROC_PIPE shim not linked — dual residual .slake-native wipe"
fi

ran=()
[[ "$band_marker" -eq 1 ]] && ran+=("marker")
[[ "$band_symlink" -eq 1 ]] && ran+=("symlink")
[[ "$band_olean" -eq 1 ]] && ran+=("olean")
[[ "$band_fs_proc" -eq 1 ]] && ran+=("fs_proc")
[[ "$band_fs_pipe" -eq 1 ]] && ran+=("fs_pipe")
ran_s="${ran[*]}"
ran_s="${ran_s// /,}"

echo "OK: A17 native_clean_smoke bands=[${ran_s}] (native product out dir wipe subset; not freestanding build TCB / not full Lake clean / not CLAIMED expansion)"
exit 0
