#!/usr/bin/env bash
# Smoke: A22 SLAKE_NATIVE_AR=1 host static archive of plan-module objects via ar rcs.
#
# Honesty: host static archive of plan-module objects subset via ar rcs — not
# freestanding build TCB, not Lake lean_lib static/shared facet, not CLAIMED, not
# linking Lean runtime into the archive (plain ar of module .o only; A21 leanc
# remains the path that pulls runtime into SO). A13 NATIVE_LINK remains name-table
# SO (libslake_native.so). A21 NATIVE_IRLINK remains leanc IR SO (libslake_ir.so).
# SCORE does **not** run this smoke.
#
# Soft-skip when slake binary, host lean, host cc, or host ar missing
# (parity-preserving). Hard-fail when STRICT and tools missing, or claim fails
# with tools present.
#
# systems_shaped bands:
#   1) PLAN_ONLY + NATIVE_AR: plan + oleans + C + .o + libslake_ir.a (ar t members)
#   2) NATIVE_BUILD + NATIVE_AR: skip lake; archive present
#   3) env reports NATIVE_AR / STRICT + NATIVE_BUILD/PLAN_ONLY conjunctions
#   4) STRICT + missing AR → fail-closed
#   5) NATIVE_BUILD + NATIVE_AR + missing AR → fail-closed (no skip-lake)
#   6) non-STRICT missing AR → soft-skip (exit 0, no .a)
#   6b) STRICT + probe-passing stub ar that fails on rcs → fail-closed (no OK)
#   7) Coexistence: NATIVE_AR + NATIVE_IRLINK → SO + archive; + NATIVE_LINK optional
#      (STRICT requires host leanc; soft SKIP only when non-STRICT)
#   8) graph/seal light touch: static_lib with AR; multi-product with IRLINK/LINK
#      (8b STRICT requires host leanc)
#   9) clean wipes .slake-native (A17)
#  10) help lists NATIVE_AR
#
#   SLAKE_NATIVE_AR_SMOKE_STRICT=1 ./tests/slake/native_ar_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SYSTEMS_PKG="$ROOT/systems_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_NATIVE_AR_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_IRLINK_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OBJ_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_C_SMOKE_STRICT:-}" == "1" || "${SLAKE_NATIVE_OLEAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

CC_PROBE="${CC:-cc}"
if ! command -v "$CC_PROBE" >/dev/null 2>&1 && [[ ! -x "$CC_PROBE" ]]; then
  strict_fail "host cc not found (set CC= or PATH)"
fi

AR_PROBE="${AR:-ar}"
if ! command -v "$AR_PROBE" >/dev/null 2>&1 && [[ ! -x "$AR_PROBE" ]]; then
  strict_fail "host ar not found (set AR= or PATH)"
fi

if [[ ! -d "$SYSTEMS_PKG" ]]; then
  strict_fail "systems_shaped fixture missing at $SYSTEMS_PKG"
fi

wipe_native() {
  rm -rf "$SYSTEMS_PKG/.slake-native" "$SYSTEMS_PKG/.lake" 2>/dev/null || true
}

assert_ir_a() {
  local a="$SYSTEMS_PKG/.slake-native/libslake_ir.a"
  local core_o="$SYSTEMS_PKG/.slake-native/Core.o"
  local host_o="$SYSTEMS_PKG/.slake-native/Host.o"
  local ar_list members
  for f in "$a" "$core_o" "$host_o"; do
    if [[ ! -f "$f" ]]; then
      echo "FAIL: expected regular file at $f"
      exit 1
    fi
    if [[ ! -s "$f" ]]; then
      echo "FAIL: expected non-empty file at $f"
      exit 1
    fi
  done
  # Member table: real ar archive of plan-module objects (not a non-empty junk file).
  # GNU ar typically stores basenames (Core.o / Host.o) even when args were
  # .slake-native/Core.o; accept basename or package-relative path forms.
  ar_list="$AR_PROBE"
  if [[ ! -x "$ar_list" ]] && ! command -v "$ar_list" >/dev/null 2>&1; then
    ar_list="ar"
  fi
  members="$("$ar_list" t "$a" 2>/dev/null || true)"
  if [[ -z "$members" ]]; then
    echo "FAIL: ar t produced empty member list for libslake_ir.a (not a real archive?)"
    exit 1
  fi
  if ! printf '%s\n' "$members" | grep -Eq '(^|/|\.slake-native/)Core\.o$'; then
    echo "FAIL: archive must list Core.o member (ar t)"
    printf '%s\n' "$members"
    exit 1
  fi
  if ! printf '%s\n' "$members" | grep -Eq '(^|/|\.slake-native/)Host\.o$'; then
    echo "FAIL: archive must list Host.o member (ar t)"
    printf '%s\n' "$members"
    exit 1
  fi
}

assert_honesty() {
  local out="$1"
  if ! printf '%s' "$out" | grep -Fq "host static archive of plan-module objects"; then
    echo "FAIL: expected host static archive of plan-module objects honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
    echo "FAIL: expected freestanding build TCB denial"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "not CLAIMED"; then
    echo "FAIL: expected not CLAIMED denial"
    exit 1
  fi
  # Must not claim Lake lean_lib static/shared as achieved product without denial.
  if printf '%s' "$out" | grep -Eqi 'Lake lean_lib (static|shared)' \
      && ! printf '%s' "$out" | grep -Fq "not Lake lean_lib"; then
    echo "FAIL: overclaim Lake lean_lib without denial"
    exit 1
  fi
  # Must not claim freestanding build TCB as achieved.
  if printf '%s' "$out" | grep -Fq "freestanding build TCB" \
      && ! printf '%s' "$out" | grep -Fq "not freestanding build TCB"; then
    echo "FAIL: freestanding build TCB mentioned without denial"
    exit 1
  fi
}

unset_a22_build_env() {
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset SLAKE_NATIVE_OLEAN_JOBS || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_C_STRICT || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_OBJ_STRICT || true
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_IRLINK_STRICT || true
  unset SLAKE_NATIVE_AR_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN_INCLUDE || true
  unset LEAN_PREFIX || true
  unset LEAN_SYSROOT || true
  unset LEANC || true
  unset AR || true
}

wipe_native

echo "== A22 Run 1: PLAN_ONLY + NATIVE_AR → plan + oleans + C + .o + libslake_ir.a =="
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_AR=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_NATIVE_CHECK || true
  unset SLAKE_NATIVE_OLEAN || true
  unset SLAKE_NATIVE_OLEAN_STRICT || true
  unset SLAKE_NATIVE_OLEAN_FORCE || true
  unset SLAKE_NATIVE_BUILD || true
  unset SLAKE_NATIVE_C || true
  unset SLAKE_NATIVE_OBJ || true
  unset SLAKE_NATIVE_IRLINK || true
  unset SLAKE_NATIVE_AR_STRICT || true
  unset SLAKE_NATIVE_LINK || true
  unset SLAKE_NATIVE_GRAPH || true
  unset SLAKE_NATIVE_SEAL || true
  unset LEAN || true
  unset CC || true
  unset AR || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_AR Run 1 exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "Core" || ! printf '%s' "$out" | grep -Fq "Host"; then
  echo "FAIL: expected systems_shaped Core Host plan (NATIVE_AR implies plan)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "SLAKE_NATIVE_AR=1"; then
  echo "FAIL: expected NATIVE_AR banner"
  printf '%s\n' "$out"
  exit 1
fi
assert_honesty "$out"
if ! printf '%s' "$out" | grep -Fq "native static archive OK"; then
  echo "FAIL: expected native static archive OK"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native object compile OK"; then
  echo "FAIL: expected native object compile OK (AR implies OBJ)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native C emit OK"; then
  echo "FAIL: expected native C emit OK (AR implies C)"
  printf '%s\n' "$out"
  exit 1
fi
# AR alone must NOT run IRLINK.
if printf '%s' "$out" | grep -Fq "native IR link OK"; then
  echo "FAIL: NATIVE_AR alone must not run IRLINK"
  printf '%s\n' "$out"
  exit 1
fi
assert_ir_a
if [[ -f "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
  echo "FAIL: NATIVE_AR alone must not write libslake_ir.so"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: PLAN_ONLY+NATIVE_AR must not create .lake/build"
  exit 1
fi
echo "OK: PLAN_ONLY+NATIVE_AR wrote libslake_ir.a (and .o files)"

echo "== A22 Run 2: NATIVE_BUILD + NATIVE_AR → skip lake, archive present =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_AR=1
  unset SLAKE_PLAN_ONLY || true
  unset_a22_build_env
  unset LEAN || true
  unset CC || true
  unset AR || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_AR exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile + host lean C-output emit + host object compile + host static archive"; then
  echo "FAIL: expected skip-lake banner with host static archive"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native static archive OK"; then
  echo "FAIL: expected native static archive OK under NATIVE_BUILD+NATIVE_AR"
  printf '%s\n' "$out"
  exit 1
fi
assert_ir_a
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_AR must not create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_AR skip-lake with libslake_ir.a"

echo "== A22 Run 3: env identity reports NATIVE_AR =="
env_out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_AR=1
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "SLAKE_NATIVE_AR: 1" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_AR: 1"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "SLAKE_NATIVE_AR_STRICT:" <<<"$env_out"; then
  echo "FAIL: env must report SLAKE_NATIVE_AR_STRICT status"
  printf '%s\n' "$env_out"
  exit 1
fi
if ! grep -Fq "host static archive of plan-module objects" <<<"$env_out"; then
  echo "FAIL: env must describe host static archive of plan-module objects subset"
  printf '%s\n' "$env_out"
  exit 1
fi
env_build="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_AR=1
  unset SLAKE_PLAN_ONLY || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "NATIVE_BUILD + NATIVE_AR" <<<"$env_build"; then
  echo "FAIL: env must document NATIVE_BUILD + NATIVE_AR cascade"
  printf '%s\n' "$env_build"
  exit 1
fi
if ! grep -Fq "skip lake only if olean + C emit + object compile + static archive succeed" <<<"$env_build" \
    && ! grep -Fq "skip lake only if olean + host lean C-output emit + host object compile + host static archive succeed" <<<"$env_build"; then
  echo "FAIL: env NATIVE_BUILD+NATIVE_AR must state skip-lake requires static archive"
  printf '%s\n' "$env_build"
  exit 1
fi
env_plan="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_AR=1
  unset SLAKE_NATIVE_BUILD || true
  "$SLAKE_EXE" env 2>&1
)"
if ! grep -Fq "PLAN_ONLY + NATIVE_AR" <<<"$env_plan" \
    && ! grep -Fq "PLAN_ONLY + NATIVE_OLEAN + NATIVE_AR" <<<"$env_plan"; then
  echo "FAIL: env must document PLAN_ONLY + NATIVE_AR"
  printf '%s\n' "$env_plan"
  exit 1
fi
echo "OK: env reports NATIVE_AR"

echo "== A22 Run 4: NATIVE_AR_STRICT + missing AR → fail-closed =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_AR=1
  export AR="/nonexistent/ar-a22-missing-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a22_build_env
  export SLAKE_NATIVE_AR_STRICT=1
  export AR="/nonexistent/ar-a22-missing-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_AR_STRICT with missing ar must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'ar not found|not usable|STRICT|fail-closed'; then
  echo "FAIL: expected ar-missing STRICT diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]]; then
  echo "FAIL: must not write libslake_ir.a when ar missing under STRICT"
  exit 1
fi
echo "OK: NATIVE_AR_STRICT + missing AR fail-closed"

echo "== A22 Run 5: NATIVE_BUILD + NATIVE_AR + missing AR → fail-closed (no skip-lake) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_NATIVE_BUILD=1
  export SLAKE_NATIVE_AR=1
  export AR="/nonexistent/ar-a22-build-missing-$$"
  unset SLAKE_PLAN_ONLY || true
  unset_a22_build_env
  export AR="/nonexistent/ar-a22-build-missing-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: NATIVE_BUILD+NATIVE_AR with missing ar must exit nonzero (fail-closed)"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "skipping lake after successful native olean compile"; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_AR must not claim skip-lake"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.lake/build" ]]; then
  echo "FAIL: fail-closed NATIVE_BUILD+NATIVE_AR must not lake-delegate to create .lake/build"
  exit 1
fi
echo "OK: NATIVE_BUILD+NATIVE_AR missing AR fail-closed"

echo "== A22 Run 6: non-STRICT missing AR → soft-skip (exit 0, no .a) =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_AR=1
  export AR="/nonexistent/ar-a22-soft-$$"
  unset SLAKE_NATIVE_BUILD || true
  unset_a22_build_env
  export AR="/nonexistent/ar-a22-soft-$$"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: non-STRICT missing AR must soft-skip (exit 0), got $rc"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'ar not found|not usable|skipping host static archive'; then
  echo "FAIL: expected soft-skip warn for missing ar"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "native static archive OK"; then
  echo "FAIL: soft-skip must not claim native static archive OK"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]]; then
  echo "FAIL: soft-skip must not write libslake_ir.a when ar missing"
  exit 1
fi
echo "OK: non-STRICT missing AR soft-skips static archive"

echo "== A22 Run 6b: STRICT + probe-passing stub ar that fails on rcs → fail-closed =="
wipe_native
FAKE_AR="$(mktemp "${TMPDIR:-/tmp}/a22-fake-ar.XXXXXX")"
cat > "$FAKE_AR" <<'EOF'
#!/usr/bin/env bash
# Pass resolveArCmd probe (--version / -V + ar/binutils marker), then fail on rcs
# so nonzero ar exit is always fail-closed (no native static archive OK).
case "${1:-}" in
  --version|-V)
    echo "GNU ar (GNU Binutils) 2.40 (A22 rcs-fail probe)"
    exit 0
    ;;
esac
# Any archive write/list path: fail closed for this negative band.
exit 42
EOF
chmod +x "$FAKE_AR"
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_AR=1
  export SLAKE_NATIVE_AR_STRICT=1
  export AR="$FAKE_AR"
  unset SLAKE_NATIVE_BUILD || true
  unset_a22_build_env
  export SLAKE_NATIVE_AR_STRICT=1
  export AR="$FAKE_AR"
  unset LEAN || true
  unset CC || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?
rm -f "$FAKE_AR"

if [[ "$rc" -eq 0 ]]; then
  echo "FAIL: probe-pass + rcs-fail ar under STRICT must exit nonzero"
  printf '%s\n' "$out"
  exit 1
fi
if printf '%s' "$out" | grep -Fq "native static archive OK"; then
  echo "FAIL: rcs-fail ar must not claim native static archive OK"
  printf '%s\n' "$out"
  exit 1
fi
if ! printf '%s' "$out" | grep -Eiq 'native static archive failed|ar exit|spawn failed'; then
  echo "FAIL: expected nonzero-ar / archive-failed diagnostic"
  printf '%s\n' "$out"
  exit 1
fi
if [[ -f "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]]; then
  # Stale empty/partial .a must not look like success; product removes before rcs
  # but a stub could still create one — either way no OK banner above.
  if [[ -s "$SYSTEMS_PKG/.slake-native/libslake_ir.a" ]]; then
    echo "FAIL: rcs-fail stub must not leave a successful non-empty libslake_ir.a"
    exit 1
  fi
fi
echo "OK: STRICT + probe-pass rcs-fail ar fail-closed (no archive OK)"

echo "== A22 Run 7: coexistence NATIVE_AR + NATIVE_IRLINK (+ optional LINK) =="
wipe_native
out=""
rc=0
# Need leanc for IRLINK coexistence band. Under smoke STRICT, require leanc so
# multi-product coexistence is proven on CI (not soft-SKIP).
LEANC_PROBE="${LEANC:-leanc}"
if ! command -v "$LEANC_PROBE" >/dev/null 2>&1 && [[ ! -x "$LEANC_PROBE" ]]; then
  if [[ "${SLAKE_NATIVE_AR_SMOKE_STRICT:-}" == "1" ]]; then
    strict_fail "host leanc not found for coexistence band (STRICT requires leanc for AR+IRLINK+LINK)"
  fi
  echo "SKIP: host leanc not found for coexistence band (AR alone already covered)"
else
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_AR=1
    export SLAKE_NATIVE_IRLINK=1
    unset SLAKE_NATIVE_BUILD || true
    unset_a22_build_env
    # Re-export after unset (it clears NATIVE_IRLINK / NATIVE_LINK among others).
    export SLAKE_NATIVE_IRLINK=1
    export SLAKE_NATIVE_LINK=1
    unset LEAN || true
    unset CC || true
    unset AR || true
    unset LEANC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?

  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+NATIVE_AR+NATIVE_IRLINK+NATIVE_LINK exited $rc (expected 0)"
    printf '%s\n' "$out"
    exit 1
  fi
  assert_ir_a
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
    echo "FAIL: expected non-empty libslake_ir.so alongside libslake_ir.a"
    exit 1
  fi
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]]; then
    echo "FAIL: expected non-empty libslake_native.so alongside archive + IR SO"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native static archive OK"; then
    echo "FAIL: expected native static archive OK under coexistence"
    printf '%s\n' "$out"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native IR link OK"; then
    echo "FAIL: expected native IR link OK under coexistence"
    printf '%s\n' "$out"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native link OK"; then
    echo "FAIL: expected native link OK (name-table) under coexistence"
    printf '%s\n' "$out"
    exit 1
  fi
  echo "OK: libslake_ir.a + libslake_ir.so + libslake_native.so coexist"
fi

echo "== A22 Run 8a: PLAN_ONLY + AR + GRAPH → static_lib; no shared_lib / shared_lib_ir =="
wipe_native
out=""
rc=0
out="$(
  cd "$SYSTEMS_PKG"
  export SLAKE_PLAN_ONLY=1
  export SLAKE_NATIVE_AR=1
  unset SLAKE_NATIVE_BUILD || true
  unset_a22_build_env
  export SLAKE_NATIVE_GRAPH=1
  unset LEAN || true
  unset CC || true
  unset AR || true
  "$SLAKE_EXE" build 2>&1
)" || rc=$?

if [[ "$rc" -ne 0 ]]; then
  echo "FAIL: PLAN_ONLY+AR+GRAPH exited $rc (expected 0)"
  printf '%s\n' "$out"
  exit 1
fi
assert_ir_a
graph_path="$SYSTEMS_PKG/.slake-native/slake_native_graph"
if [[ ! -f "$graph_path" ]]; then
  echo "FAIL: expected slake_native_graph after NATIVE_GRAPH"
  exit 1
fi
if ! grep -Eq '^static_lib \.slake-native/libslake_ir\.a$' "$graph_path"; then
  echo "FAIL: graph must list static_lib after NATIVE_AR"
  cat "$graph_path"
  exit 1
fi
if grep -Eq '^shared_lib ' "$graph_path"; then
  echo "FAIL: graph must not list A13 shared_lib without NATIVE_LINK"
  cat "$graph_path"
  exit 1
fi
if grep -Eq '^shared_lib_ir ' "$graph_path"; then
  echo "FAIL: graph must not list shared_lib_ir without NATIVE_IRLINK"
  cat "$graph_path"
  exit 1
fi
if ! printf '%s' "$out" | grep -Fq "native graph OK"; then
  echo "FAIL: expected native graph OK under AR+GRAPH"
  printf '%s\n' "$out"
  exit 1
fi
echo "OK: graph lists static_lib; shared_lib/shared_lib_ir absent without LINK/IRLINK"

echo "== A22 Run 8b: PLAN_ONLY + AR + IRLINK + LINK + GRAPH + SEAL → all product fields =="
wipe_native
out=""
rc=0
if ! command -v "${LEANC:-leanc}" >/dev/null 2>&1 && [[ ! -x "${LEANC:-leanc}" ]]; then
  if [[ "${SLAKE_NATIVE_AR_SMOKE_STRICT:-}" == "1" ]]; then
    strict_fail "host leanc not found for graph/seal multi-product band (STRICT requires leanc)"
  fi
  echo "SKIP: host leanc not found for graph/seal multi-product band"
else
  out="$(
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_AR=1
    export SLAKE_NATIVE_IRLINK=1
    unset SLAKE_NATIVE_BUILD || true
    unset_a22_build_env
    export SLAKE_NATIVE_IRLINK=1
    export SLAKE_NATIVE_LINK=1
    export SLAKE_NATIVE_GRAPH=1
    export SLAKE_NATIVE_SEAL=1
    unset LEAN || true
    unset CC || true
    unset AR || true
    unset LEANC || true
    "$SLAKE_EXE" build 2>&1
  )" || rc=$?

  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY+AR+IRLINK+LINK+GRAPH+SEAL exited $rc (expected 0)"
    printf '%s\n' "$out"
    exit 1
  fi
  assert_ir_a
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_ir.so" ]]; then
    echo "FAIL: expected non-empty libslake_ir.so under multi-product band"
    exit 1
  fi
  if [[ ! -f "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]] || [[ ! -s "$SYSTEMS_PKG/.slake-native/libslake_native.so" ]]; then
    echo "FAIL: expected non-empty libslake_native.so under multi-product band"
    exit 1
  fi
  graph_path="$SYSTEMS_PKG/.slake-native/slake_native_graph"
  seal_path="$SYSTEMS_PKG/.slake-native/slake_native_seal"
  if [[ ! -f "$graph_path" || ! -f "$seal_path" ]]; then
    echo "FAIL: expected graph and seal artifacts"
    exit 1
  fi
  if ! grep -Eq '^static_lib \.slake-native/libslake_ir\.a$' "$graph_path"; then
    echo "FAIL: graph must list static_lib with AR"
    cat "$graph_path"
    exit 1
  fi
  if ! grep -Eq '^shared_lib_ir \.slake-native/libslake_ir\.so$' "$graph_path"; then
    echo "FAIL: graph must list shared_lib_ir with IRLINK"
    cat "$graph_path"
    exit 1
  fi
  if ! grep -Eq '^shared_lib \.slake-native/libslake_native\.so$' "$graph_path"; then
    echo "FAIL: graph must list A13 shared_lib with NATIVE_LINK"
    cat "$graph_path"
    exit 1
  fi
  if ! grep -Eq '^static_lib \.slake-native/libslake_ir\.a$' "$seal_path"; then
    echo "FAIL: seal must list static_lib with AR"
    cat "$seal_path"
    exit 1
  fi
  if ! grep -Eq '^shared_lib_ir \.slake-native/libslake_ir\.so$' "$seal_path"; then
    echo "FAIL: seal must list shared_lib_ir with IRLINK"
    cat "$seal_path"
    exit 1
  fi
  if ! grep -Eq '^shared_lib \.slake-native/libslake_native\.so$' "$seal_path"; then
    echo "FAIL: seal must list A13 shared_lib with NATIVE_LINK"
    cat "$seal_path"
    exit 1
  fi
  if ! grep -Eq '^graph_hash ' "$seal_path"; then
    echo "FAIL: seal must list graph_hash when GRAPH ran before SEAL"
    cat "$seal_path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "native seal OK"; then
    echo "FAIL: expected native seal OK under multi-product band"
    printf '%s\n' "$out"
    exit 1
  fi
  echo "OK: graph/seal list shared_lib, shared_lib_ir, and static_lib"
fi

echo "== A22 Run 9: clean wipes .slake-native (A17) =="
# Ensure artifacts exist (from prior runs or rebuild AR-only).
if [[ ! -d "$SYSTEMS_PKG/.slake-native" ]]; then
  (
    cd "$SYSTEMS_PKG"
    export SLAKE_PLAN_ONLY=1
    export SLAKE_NATIVE_AR=1
    unset_a22_build_env
    "$SLAKE_EXE" build >/dev/null 2>&1 || true
  )
fi
if [[ ! -d "$SYSTEMS_PKG/.slake-native" ]]; then
  echo "FAIL: expected .slake-native before clean"
  exit 1
fi
clean_out=""
clean_rc=0
clean_out="$(
  cd "$SYSTEMS_PKG"
  unset SLAKE_PLAN_ONLY || true
  unset SLAKE_NATIVE_BUILD || true
  unset_a22_build_env
  "$SLAKE_EXE" clean 2>&1
)" || clean_rc=$?
if [[ "$clean_rc" -ne 0 ]]; then
  echo "FAIL: slake clean exited $clean_rc"
  printf '%s\n' "$clean_out"
  exit 1
fi
if [[ -d "$SYSTEMS_PKG/.slake-native" ]]; then
  echo "FAIL: clean must wipe .slake-native (A17)"
  exit 1
fi
echo "OK: clean wiped .slake-native"

echo "== A22 Run 10: help lists NATIVE_AR =="
# Redirect to a file (not bash var + printf|grep): large UTF-8 usage text is flaky
# under command-substitution + pipe grep on some hosts after long smoke runs.
help_file="$(mktemp "${TMPDIR:-/tmp}/slake-ar-help.XXXXXX")"
"$SLAKE_EXE" --help >"$help_file" 2>&1 || true
if ! grep -Fq "SLAKE_NATIVE_AR" "$help_file"; then
  echo "FAIL: --help must list SLAKE_NATIVE_AR"
  head -80 "$help_file" || true
  rm -f "$help_file"
  exit 1
fi
if ! grep -Fq "libslake_ir.a" "$help_file"; then
  echo "FAIL: --help must mention libslake_ir.a"
  rm -f "$help_file"
  exit 1
fi
if ! grep -Fq "host static archive of plan-module objects" "$help_file"; then
  echo "FAIL: --help must describe host static archive of plan-module objects"
  rm -f "$help_file"
  exit 1
fi
rm -f "$help_file"
echo "OK: help lists NATIVE_AR"

echo "OK: native_ar_smoke (A22) all bands passed"
