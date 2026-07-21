#!/usr/bin/env bash
# Smoke: A33 freestanding-adjacent path-require package `.slake-native` wipe on
# CLAIMED `slake clean` (product-first hygiene; not CLAIMED token expansion).
#
# A17 wipes only root package `.slake-native` (+ `.lake/build`). After A26–A32,
# path `[[require]]` deps leave freestanding-adjacent products under
# `dep/.slake-native/`. Root `slake clean` must also wipe those path-dep products.
#
# Honesty: path-require package `.slake-native` wipe subset (A26 under-pkg / A29
# sibling confining; identity order; soft missing OK; symlink fence) — not
# freestanding build TCB / not Lake resolve-deps clean of every workspace package /
# not git/url / not multi-.. / not dep `.lake/build` / not CLAIMED expansion.
# SCORE does **not** run this smoke.
#
# Prefer absolute SLAKE_BIN (this script absolutizes when set). Relative
# SLAKE_BIN from repo root fails after cd into fixtures.
#
# Bands:
#   1) require_path_shaped: PLAN_ONLY+NATIVE_OLEAN → root + dep .slake-native
#      exist → slake clean → both gone; A33 log; dep/.lake/build marker survives
#   2) require_sibling_shaped: app clean wipes ../dep/.slake-native (not multi-..)
#      + sibling dep/.lake/build marker survives
#   3) systems_shaped (no path-require): clean still wipes root only; no false
#      path-dep wipe claims
#   4) help/env honesty greps for A33 (here-strings; never printf|grep -q under
#      pipefail on long help)
#   5) dep .slake-native as symlink → refuse + nonzero (A17 fence; no A33
#      wiped log when refuse-only)
#   6) FS_PROC dual residual: markers under root + dep .slake-native →
#      SLAKE_USE_FS_PROC=1 clean → freestanding + both gone + A33 log
#      (soft-skip if unlinked; STRICT hard-fail)
#   7) FS_PROC_PIPE dual residual (same; soft-skip if pipe unlinked)
#
#   SLAKE_NATIVE_PATHDEP_CLEAN_SMOKE_STRICT=1 ./tests/slake/native_pathdep_clean_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/require_path_shaped"
SIBLING_APP="$ROOT/require_sibling_shaped/app"
SIBLING_DEP="$ROOT/require_sibling_shaped/dep"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_PATHDEP_CLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_CLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL (STRICT): $*"
    exit 1
  fi
  echo "SKIP: $*"
  exit 0
}

abs_exe() {
  local p="$1"
  if [[ -z "$p" ]]; then
    return 1
  fi
  if [[ "$p" != /* ]]; then
    p="$(pwd)/$p"
  fi
  local dir base
  dir="$(cd "$(dirname "$p")" && pwd)"
  base="$(basename "$p")"
  echo "$dir/$base"
}

resolve_slake() {
  if [[ -n "${SLAKE_BIN:-}" ]]; then
    local abs
    if ! abs="$(abs_exe "$SLAKE_BIN")"; then
      return 1
    fi
    if [[ -x "$abs" ]]; then
      echo "$abs"
      return 0
    fi
    return 1
  fi
  local cand abs
  for cand in \
    "$REPO_ROOT/tests/slake/driver/.lake/build/bin/slake" \
    "$ROOT/driver/.lake/build/bin/slake"
  do
    if [[ -x "$cand" ]]; then
      abs="$(abs_exe "$cand")" || continue
      echo "$abs"
      return 0
    fi
  done
  return 1
}

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/App.lean" || ! -f "$PKG/dep/Dep.lean" ]]; then
  echo "FAIL: missing require_path_shaped package at $PKG"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

LEAN_PROBE="${LEAN:-lean}"
have_lean=0
if command -v "$LEAN_PROBE" >/dev/null 2>&1 || [[ -x "$LEAN_PROBE" ]]; then
  have_lean=1
fi

band_underpkg=0
band_sibling=0
band_systems=0
band_help=0
band_symlink=0
band_fs_proc=0
band_fs_pipe=0

wipe_path_pkg() {
  rm -rf "$PKG/.slake-native" "$PKG/dep/.slake-native" "$PKG/.lake" "$PKG/dep/.lake" 2>/dev/null || true
}

if [[ "$have_lean" -eq 1 ]]; then
  echo "== A33 under-pkg: clean wipes root + dep/.slake-native =="
  (
    wipe_path_pkg
    cd "$PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_OLEAN=1
    unset SLAKE_DEPGRAPH || true
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_USE_FS_PROC_PIPE || true
    unset SLAKE_NATIVE_CHECK || true
    unset SLAKE_NATIVE_OLEAN_STRICT || true
    unset LEAN || true
    out_b="$("$SLAKE_EXE" build 2>&1)" || rc_b=$?
    rc_b="${rc_b:-0}"
    printf '%s\n' "$out_b"
    if [[ "$rc_b" -ne 0 ]]; then
      echo "FAIL: PLAN_ONLY+NATIVE_OLEAN exited $rc_b"
      exit 1
    fi
    if [[ ! -f .slake-native/App.olean ]]; then
      echo "FAIL: expected root .slake-native/App.olean before clean"
      ls -laR .slake-native 2>/dev/null || true
      exit 1
    fi
    if [[ ! -f dep/.slake-native/Dep.olean ]]; then
      echo "FAIL: expected dep/.slake-native/Dep.olean before clean"
      ls -laR dep/.slake-native 2>/dev/null || true
      exit 1
    fi
    # Honesty: A33 must not wipe dep .lake/build — plant a marker that must survive.
    mkdir -p dep/.lake/build
    printf 'keep\n' > dep/.lake/build/a33-marker
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_NATIVE_OLEAN || true
    out_c="$("$SLAKE_EXE" clean 2>&1)" || rc_c=$?
    rc_c="${rc_c:-0}"
    printf '%s\n' "$out_c"
    if [[ "$rc_c" -ne 0 ]]; then
      echo "FAIL: slake clean after path-dep oleans exited $rc_c"
      exit 1
    fi
    if [[ -d .slake-native ]]; then
      echo "FAIL: root .slake-native still present after clean"
      ls -laR .slake-native 2>/dev/null || true
      exit 1
    fi
    if [[ -d dep/.slake-native ]]; then
      echo "FAIL: dep/.slake-native still present after clean (A33 leak)"
      ls -laR dep/.slake-native 2>/dev/null || true
      exit 1
    fi
    if [[ -d .lake/build ]]; then
      echo "FAIL: .lake/build still present after clean"
      exit 1
    fi
    if [[ ! -f dep/.lake/build/a33-marker ]]; then
      echo "FAIL: dep/.lake/build/a33-marker missing after clean (A33 must not wipe dep .lake/build)"
      ls -laR dep/.lake 2>/dev/null || true
      exit 1
    fi
    # Honesty: A33 path-require wipe log (only when something was removed).
    if ! grep -Fq 'A33 path-require' <<<"$out_c"; then
      echo "FAIL: clean output missing A33 path-require wipe line"
      exit 1
    fi
    if ! grep -Fq 'path-require package' <<<"$out_c"; then
      echo "FAIL: clean output missing path-require package honesty"
      exit 1
    fi
    # Root remove line still present.
    if ! grep -Fq '.slake-native' <<<"$out_c"; then
      echo "FAIL: clean output missing .slake-native remove line"
      exit 1
    fi
    # Not wiping dep .lake/build claims (marker survival is the hard check;
    # A33 must not claim Lake resolve-deps / git/url).
    if grep -Eiq 'git/url wipe|resolve-deps clean|multi-\.\. wipe' <<<"$out_c"; then
      echo "FAIL: clean overclaimed git/url / resolve-deps / multi-.. wipe"
      exit 1
    fi
    echo "OK: under-pkg path-require clean wiped root + dep/.slake-native (dep .lake/build kept)"
  ) || exit 1
  band_underpkg=1
else
  if [[ "${SLAKE_NATIVE_PATHDEP_CLEAN_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL (STRICT): host lean missing — under-pkg olean clean band required under STRICT"
    echo "      set LEAN= or PATH to stage1/bin, or run without SLAKE_NATIVE_PATHDEP_CLEAN_SMOKE_STRICT=1"
    exit 1
  fi
  echo "SKIP band: host lean missing — under-pkg PLAN_ONLY+NATIVE_OLEAN clean band"
fi

if [[ "$have_lean" -eq 1 ]]; then
  if [[ ! -f "$SIBLING_APP/lakefile.toml" || ! -f "$SIBLING_APP/App.lean" || ! -f "$SIBLING_DEP/Dep.lean" ]]; then
    strict_fail "require_sibling_shaped fixture missing"
  fi
  echo "== A33 sibling: app clean wipes ../dep/.slake-native =="
  (
    rm -rf "$SIBLING_APP/.slake-native" "$SIBLING_DEP/.slake-native" \
      "$SIBLING_APP/.lake" "$SIBLING_DEP/.lake" 2>/dev/null || true
    cd "$SIBLING_APP"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_OLEAN=1
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_USE_FS_PROC_PIPE || true
    unset LEAN || true
    out_b="$("$SLAKE_EXE" build 2>&1)" || rc_b=$?
    rc_b="${rc_b:-0}"
    printf '%s\n' "$out_b"
    if [[ "$rc_b" -ne 0 ]]; then
      echo "FAIL: sibling PLAN_ONLY+NATIVE_OLEAN exited $rc_b"
      exit 1
    fi
    if [[ ! -f .slake-native/App.olean ]]; then
      echo "FAIL: expected sibling app .slake-native/App.olean"
      exit 1
    fi
    if [[ ! -f "$SIBLING_DEP/.slake-native/Dep.olean" ]]; then
      echo "FAIL: expected sibling dep/.slake-native/Dep.olean before clean"
      ls -laR "$SIBLING_DEP/.slake-native" 2>/dev/null || true
      exit 1
    fi
    # Honesty: A33 must not wipe sibling dep .lake/build.
    mkdir -p "$SIBLING_DEP/.lake/build"
    printf 'keep\n' > "$SIBLING_DEP/.lake/build/a33-marker"
    unset SLAKE_PLAN_ONLY || true
    unset SLAKE_NATIVE_OLEAN || true
    out_c="$("$SLAKE_EXE" clean 2>&1)" || rc_c=$?
    rc_c="${rc_c:-0}"
    printf '%s\n' "$out_c"
    if [[ "$rc_c" -ne 0 ]]; then
      echo "FAIL: sibling slake clean exited $rc_c"
      exit 1
    fi
    if [[ -d .slake-native ]]; then
      echo "FAIL: sibling app .slake-native still present after clean"
      exit 1
    fi
    if [[ -d "$SIBLING_DEP/.slake-native" ]]; then
      echo "FAIL: sibling dep/.slake-native still present after app clean (A33 leak)"
      ls -laR "$SIBLING_DEP/.slake-native" 2>/dev/null || true
      exit 1
    fi
    if [[ ! -f "$SIBLING_DEP/.lake/build/a33-marker" ]]; then
      echo "FAIL: sibling dep/.lake/build/a33-marker missing after clean (must not wipe dep .lake/build)"
      ls -laR "$SIBLING_DEP/.lake" 2>/dev/null || true
      exit 1
    fi
    if ! grep -Fq 'A33 path-require' <<<"$out_c"; then
      echo "FAIL: sibling clean missing A33 path-require wipe line"
      exit 1
    fi
    echo "OK: sibling path-require clean wiped app + ../dep/.slake-native (dep .lake/build kept)"
  ) || exit 1
  band_sibling=1
else
  echo "SKIP band: host lean missing — sibling path-require clean band"
fi

echo "== A33 systems_shaped: no path-require; clean wipes root only =="
if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi
(
  cd "$SYSTEMS_PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  mkdir -p .slake-native
  printf 'a33-systems-marker\n' > .slake-native/marker
  # Ensure no accidental path-require wipe log when identity has no path requires.
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_USE_FS_PROC_PIPE || true
  out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: systems_shaped clean exited $rc"
    exit 1
  fi
  if [[ -d .slake-native ]]; then
    echo "FAIL: systems_shaped .slake-native still present after clean"
    exit 1
  fi
  if grep -Fq 'A33 path-require wipe' <<<"$out"; then
    echo "FAIL: systems_shaped clean claimed A33 path-require wipe (no path requires)"
    exit 1
  fi
  if ! grep -Fq '.slake-native' <<<"$out"; then
    echo "FAIL: systems_shaped clean missing root .slake-native remove line"
    exit 1
  fi
  echo "OK: systems_shaped clean root-only (no false path-dep wipe)"
) || exit 1
band_systems=1

echo "== A33 help/env honesty greps =="
(
  help="$("$SLAKE_EXE" --help 2>&1)" || true
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  # Use here-strings (never printf … | grep -q on long help under pipefail).
  if ! grep -Fq 'A33' <<<"$help"; then
    echo "FAIL: --help missing A33"
    exit 1
  fi
  if ! grep -Fq 'path-require' <<<"$help"; then
    echo "FAIL: --help missing path-require clean honesty"
    exit 1
  fi
  if ! grep -Eqi 'A33.*path-require|path-require.*\.slake-native' <<<"$help"; then
    echo "FAIL: --help missing A33 path-require .slake-native wipe wording"
    exit 1
  fi
  if ! grep -Fq 'A33 path-require package .slake-native wipe on clean' <<<"$env_out"; then
    echo "FAIL: slake env missing A33 path-require clean honesty line"
    exit 1
  fi
  if ! grep -Fq 'not git/url' <<<"$env_out"; then
    echo "FAIL: env A33 honesty must residual-not git/url"
    exit 1
  fi
  if ! grep -Fq 'not Lake resolve-deps' <<<"$env_out"; then
    echo "FAIL: env A33 honesty must residual-not Lake resolve-deps"
    exit 1
  fi
  if ! grep -Fq 'not multi-..' <<<"$env_out"; then
    echo "FAIL: env A33 honesty must residual-not multi-.."
    exit 1
  fi
  echo "OK: help/env A33 honesty greps"
) || exit 1
band_help=1

echo "== A33 path-dep .slake-native symlink fence =="
(
  wipe_path_pkg
  cd "$PKG"
  # Root needs a real dir so we reach path-require wipe after root clean.
  mkdir -p .slake-native
  printf 'root-marker\n' > .slake-native/marker
  # Dep package real dir with symlink .slake-native (A17-class fence).
  foreign="$(mktemp -d "$PKG/dep/.a33-foreign-XXXXXX")"
  printf 'keep\n' > "$foreign/keep"
  ln -s "$(basename "$foreign")" dep/.slake-native
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_USE_FS_PROC_PIPE || true
  out_rc=0
  out="$("$SLAKE_EXE" clean 2>&1)" || out_rc=$?
  printf '%s\n' "$out"
  if [[ "$out_rc" -eq 0 ]]; then
    echo "FAIL: clean accepted symlink dep/.slake-native (expected refuse + nonzero)"
    rm -rf dep/.slake-native "$foreign" 2>/dev/null || true
    exit 1
  fi
  if ! grep -Eqi 'refuse symlink|symlink path' <<<"$out"; then
    echo "FAIL: path-dep symlink band missing refuse-symlink message"
    rm -rf dep/.slake-native "$foreign" 2>/dev/null || true
    exit 1
  fi
  if [[ ! -f "$foreign/keep" ]]; then
    echo "FAIL: path-dep symlink fence failed — foreign target was wiped"
    rm -rf dep/.slake-native "$foreign" 2>/dev/null || true
    exit 1
  fi
  # Log only on successful wipe — refuse-only path must not claim A33 wiped.
  if grep -Fq 'A33 path-require wiped' <<<"$out"; then
    echo "FAIL: path-dep symlink band claimed A33 wiped (refuse-only; nothing removed)"
    rm -rf dep/.slake-native "$foreign" 2>/dev/null || true
    exit 1
  fi
  rm -rf dep/.slake-native "$foreign" .slake-native 2>/dev/null || true
  echo "OK: dep/.slake-native symlink refused (A17 fence on path-require)"
) || exit 1
band_symlink=1

# Dual residual FS_PROC / PIPE: after lake clean, native wipe of root + path-require
# .slake-native (A33). Soft-skip when shim unlinked (parity-preserving dual residual).
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
  echo "== A33 clean: FS_PROC dual residual wipes root + dep/.slake-native =="
  (
    wipe_path_pkg
    cd "$PKG"
    # Markers only under freestanding-adjacent out dirs. Do not assert dep
    # .lake/build survives FS_PROC: lake clean may wipe workspace Lake trees
    # (documented dual residual honesty). A33 native wipe set still excludes
    # dep .lake/build (proven on native under-pkg/sibling bands).
    mkdir -p .slake-native dep/.slake-native
    printf 'a33-fs-root\n' > .slake-native/marker
    printf 'a33-fs-dep\n' > dep/.slake-native/marker
    export SLAKE_USE_FS_PROC=1
    unset SLAKE_USE_FS_PROC_PIPE || true
    unset SLAKE_FS_PROC_STRICT || true
    out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
    rc="${rc:-0}"
    printf '%s\n' "$out"
    if [[ "$rc" -ne 0 ]]; then
      echo "FAIL: FS_PROC path-dep clean exited $rc"
      exit 1
    fi
    if grep -Eiq 'falling back to native clean' <<<"$out"; then
      echo "FAIL: FS_PROC path-dep clean fell back to native (expected freestanding path)"
      exit 1
    fi
    if ! grep -Fq "SLAKE_USE_FS_PROC=1" <<<"$out"; then
      echo "FAIL: expected SLAKE_USE_FS_PROC=1 clean banner"
      exit 1
    fi
    if ! grep -Fq "Systems.Proc" <<<"$out"; then
      echo "FAIL: expected freestanding Systems.Proc clean path"
      exit 1
    fi
    if [[ -d .slake-native ]]; then
      echo "FAIL: root .slake-native still present after FS_PROC clean"
      ls -laR .slake-native 2>/dev/null || true
      exit 1
    fi
    if [[ -d dep/.slake-native ]]; then
      echo "FAIL: dep/.slake-native still present after FS_PROC clean (A33 dual residual leak)"
      ls -laR dep/.slake-native 2>/dev/null || true
      exit 1
    fi
    if ! grep -Fq 'A33 path-require' <<<"$out"; then
      echo "FAIL: FS_PROC clean missing A33 path-require wipe line"
      exit 1
    fi
    echo "OK: FS_PROC dual residual wiped root + dep/.slake-native after lake clean"
  ) || exit 1
  band_fs_proc=1
else
  if [[ "${SLAKE_NATIVE_PATHDEP_CLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_CLEAN_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL (STRICT): SLAKE_FS_PROC_LINKED != 1 — FS_PROC dual residual path-dep clean band required"
    grep -E 'FS_PROC|LINKED' <<<"$env_out" || true
    exit 1
  fi
  echo "SKIP band: FS_PROC shim not linked — dual residual path-dep .slake-native wipe"
fi

if [[ "$pipe_linked" -eq 1 ]]; then
  echo "== A33 clean: FS_PROC_PIPE dual residual wipes root + dep/.slake-native =="
  (
    wipe_path_pkg
    cd "$PKG"
    # Same honesty as FS_PROC band: lake clean may wipe Lake trees; prove A33
    # freestanding-adjacent wipe set only here.
    mkdir -p .slake-native dep/.slake-native
    printf 'a33-pipe-root\n' > .slake-native/marker
    printf 'a33-pipe-dep\n' > dep/.slake-native/marker
    export SLAKE_USE_FS_PROC_PIPE=1
    unset SLAKE_USE_FS_PROC || true
    unset SLAKE_FS_PROC_STRICT || true
    out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
    rc="${rc:-0}"
    printf '%s\n' "$out"
    if [[ "$rc" -ne 0 ]]; then
      echo "FAIL: FS_PROC_PIPE path-dep clean exited $rc"
      exit 1
    fi
    if grep -Eiq 'falling back to native clean' <<<"$out"; then
      echo "FAIL: FS_PROC_PIPE path-dep clean fell back to native (expected freestanding path)"
      exit 1
    fi
    if ! grep -Fq "SLAKE_USE_FS_PROC_PIPE=1" <<<"$out"; then
      echo "FAIL: expected SLAKE_USE_FS_PROC_PIPE=1 clean banner"
      exit 1
    fi
    if ! grep -Eqi 'Systems\.Proc pipe|pipe/stdio' <<<"$out"; then
      echo "FAIL: expected freestanding Systems.Proc pipe clean path"
      exit 1
    fi
    if [[ -d .slake-native ]]; then
      echo "FAIL: root .slake-native still present after FS_PROC_PIPE clean"
      ls -laR .slake-native 2>/dev/null || true
      exit 1
    fi
    if [[ -d dep/.slake-native ]]; then
      echo "FAIL: dep/.slake-native still present after FS_PROC_PIPE clean (A33 dual residual leak)"
      ls -laR dep/.slake-native 2>/dev/null || true
      exit 1
    fi
    if ! grep -Fq 'A33 path-require' <<<"$out"; then
      echo "FAIL: FS_PROC_PIPE clean missing A33 path-require wipe line"
      exit 1
    fi
    echo "OK: FS_PROC_PIPE dual residual wiped root + dep/.slake-native after lake clean"
  ) || exit 1
  band_fs_pipe=1
else
  if [[ "${SLAKE_NATIVE_PATHDEP_CLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_CLEAN_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL (STRICT): SLAKE_FS_PROC_PIPE_LINKED != 1 — PIPE dual residual path-dep clean band required"
    grep -E 'FS_PROC|LINKED' <<<"$env_out" || true
    exit 1
  fi
  echo "SKIP band: FS_PROC_PIPE shim not linked — dual residual path-dep .slake-native wipe"
fi

ran=()
[[ "$band_underpkg" -eq 1 ]] && ran+=("underpkg")
[[ "$band_sibling" -eq 1 ]] && ran+=("sibling")
[[ "$band_systems" -eq 1 ]] && ran+=("systems")
[[ "$band_help" -eq 1 ]] && ran+=("help")
[[ "$band_symlink" -eq 1 ]] && ran+=("symlink")
[[ "$band_fs_proc" -eq 1 ]] && ran+=("fs_proc")
[[ "$band_fs_pipe" -eq 1 ]] && ran+=("fs_pipe")
ran_s="${ran[*]}"
ran_s="${ran_s// /,}"

echo "OK: A33 native_pathdep_clean_smoke bands=[${ran_s}] (path-require package .slake-native wipe subset; not freestanding build TCB / not Lake resolve-deps / not git/url / not multi-.. / not CLAIMED expansion)"
exit 0
