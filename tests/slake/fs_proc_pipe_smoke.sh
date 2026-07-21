#!/usr/bin/env bash
# Smoke: SLAKE_USE_FS_PROC_PIPE=1 slake build/test/exe/lint/script/clean/update/pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/query-kind check-build/check-test on basic_toml (requires FS-linked driver).
# True green requires freestanding pipe path banners — not classic fall-back.
# W86: FS_PROC_PIPE also plumbs remaining argv after `build` (max 64; CLAIMED unchanged).
# W87: FS_PROC_PIPE also covers `test`; W88: also `exe` (+ rest); W89: also `lint` (+ rest); W90: also `script` (+ rest); W91: also `clean` (empty-rest-only; CLAIMED token dual residual); W92: also `update` (rest plumbed; outside CLAIMED); W93: also `pack` (rest plumbed; outside CLAIMED; chdir pkg for relative archive parity); W94: also `cache` (rest plumbed; outside CLAIMED; chdir pkg); W95: also `unpack` (rest plumbed; outside CLAIMED; chdir pkg); W96: also `query` (rest plumbed; outside CLAIMED; chdir pkg); W97: also `shake`; W98: also `serve`; W99: also `upload` (rest plumbed; outside CLAIMED; chdir pkg); W100: also `lean` (rest plumbed; outside CLAIMED; chdir pkg); W101: also `scripts` (rest plumbed; outside CLAIMED; chdir pkg); W102: also `setup-file` (rest plumbed; outside CLAIMED; chdir pkg); W103: also `self-check`; W104: also `version-tags`; W109: also `check-build` (rest plumbed; outside CLAIMED; chdir pkg); W110: also `check-test` (rest plumbed; outside CLAIMED; chdir pkg); W113: also `query-kind` (rest plumbed; outside CLAIMED; chdir pkg); W114: also `resolve-deps` (rest plumbed; outside CLAIMED; chdir pkg); CLAIMED unchanged.; W115: also `reservoir-config`; W116: also `upgrade` (+ rest; chdir pkg; resolveLakeAbs)
# Also: STRICT product fail-closed negative + default no-pipe banner assert.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/parity/basic_toml"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

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

if ! command -v lake >/dev/null 2>&1; then
  echo "SKIP: lake not on PATH"
  exit 0
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  echo "SKIP: slake binary not found (build tests/slake/driver)"
  exit 0
fi

env_out="$("$SLAKE_EXE" env 2>&1)" || true
if ! grep -Fq "SLAKE_FS_PROC_PIPE_LINKED: 1" <<<"$env_out"; then
  if [[ "${SLAKE_FS_PROC_PIPE_SMOKE_STRICT:-}" == "1" ]]; then
    echo "FAIL: slake not linked with freestanding Proc pipe shim"
    printf '%s\n' "$env_out"
    exit 1
  fi
  echo "SKIP: slake not linked with freestanding Proc pipe shim (rebuild driver after systems extract)"
  printf '%s\n' "$env_out"
  exit 0
fi

# Default path (flags unset): must not print pipe capture banners (parity-preserving).
echo "== default build (no FS_PROC_PIPE) must not print pipe capture =="
(
  cd "$PKG"
  lake clean || true
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: default path printed pipe/stdio banner"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "captured" && printf '%s' "$out" | grep -Fq "freestanding pipe"; then
    echo "FAIL: default path printed freestanding pipe capture line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
    echo "FAIL: default path claimed Systems.Proc pipe success"
    exit 1
  fi
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: default slake build exited $rc"
    exit 1
  fi
  "$SLAKE_EXE" clean >/dev/null
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 build on $PKG =="
(
  cd "$PKG"
  lake clean || true
  export SLAKE_USE_FS_PROC_PIPE=1
  # Unset multi-arg so PIPE path is unambiguous (precedence trap if both inherited).
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC_PIPE path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
    echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)'"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "captured" || ! printf '%s' "$out" | grep -Fq "freestanding pipe"; then
    echo "FAIL: expected freestanding pipe capture line from slake_fs_proc.c"
    exit 1
  fi
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: slake build exited $rc under SLAKE_USE_FS_PROC_PIPE=1"
    exit 1
  fi
  if [[ ! -d .lake/build ]]; then
    echo "FAIL: expected .lake/build after FS_PROC_PIPE build"
    exit 1
  fi
  "$SLAKE_EXE" clean >/dev/null
)

# W86 light: non-empty rest under PIPE path.
echo "== SLAKE_USE_FS_PROC_PIPE=1 build --help (non-empty rest) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" build --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE rest path fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE rest path fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding pipe/stdio banner for rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'build[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated PIPE argv line"
    exit 1
  fi
  echo "fs_proc_pipe_rest_argv: OK"
)

# STRICT negative: bad absolute lake path must exit nonzero with no IO.Process fall back.
# Mirrors multi-arg fs_proc_smoke product STRICT fail-closed policy (shared SLAKE_FS_PROC_STRICT).
echo "== SLAKE_FS_PROC_STRICT=1 negative (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_pipe_strict_lake
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero (PIPE path)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE path"
    exit 1
  fi
  echo "fs_proc_pipe_strict_negative: OK"
)


# W87: freestanding FS_PROC_PIPE for `test` (outside CLAIMED).
echo "== SLAKE_USE_FS_PROC_PIPE=1 test on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" test 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE test path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE test path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner on test path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'test'; then
    echo "FAIL: expected freestanding pipe path/argv to mention test"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: PIPE spawn failed for test"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on test rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_test: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 test --help (non-empty rest) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" test --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE test rest path fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE test rest path fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding pipe/stdio banner for test rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'test[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated PIPE test argv line"
    exit 1
  fi
  echo "fs_proc_pipe_test_rest_argv: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative test (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_pipe_strict_lake_test
  out="$("$SLAKE_EXE" test 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero (PIPE test path)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE test fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE test message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE test path"
    exit 1
  fi
  echo "fs_proc_pipe_test_strict_negative: OK"
)

# W88: freestanding FS_PROC_PIPE for `exe` (outside CLAIMED). Bare empty-rest + --help rest + STRICT.
echo "== SLAKE_USE_FS_PROC_PIPE=1 exe (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" exe 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE exe empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE exe empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner on exe empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'exe'; then
    echo "FAIL: expected freestanding pipe path/argv to mention exe (empty rest)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc pipe spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare exe"
    exit 1
  fi
  echo "fs_proc_pipe_exe_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 exe --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" exe --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE exe path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE exe path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner on exe path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'exe'; then
    echo "FAIL: expected freestanding pipe path/argv to mention exe"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'exe[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated PIPE exe argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc pipe spawn failed'; then
    echo "FAIL: PIPE spawn failed for exe"
    exit 1
  fi
  echo "fs_proc_pipe_exe: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative exe (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_pipe_strict_lake_exe
  out="$("$SLAKE_EXE" exe 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero (PIPE exe path)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE exe fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE exe message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE exe path"
    exit 1
  fi
  echo "fs_proc_pipe_exe_strict_negative: OK"
)


# W89: freestanding PIPE for `lint` (outside CLAIMED). Bare empty-rest + --help rest + STRICT.
# lake lint may exit nonzero without config — still require freestanding path, not IO.Process fall-back.
echo "== SLAKE_USE_FS_PROC_PIPE=1 lint (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" lint 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE lint empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE lint empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner on lint empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lint'; then
    echo "FAIL: expected freestanding path/argv to mention lint (empty rest)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc pipe spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare lint"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare lint"
    exit 1
  fi
  echo "fs_proc_pipe_lint_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 lint --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" lint --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE lint path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE lint path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner on lint path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lint'; then
    echo "FAIL: expected freestanding argv/path to mention lint"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lint[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated PIPE lint argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc pipe spawn failed'; then
    echo "FAIL: PIPE spawn failed for lint"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on lint --help"
    exit 1
  fi
  echo "fs_proc_pipe_lint: OK"
)

# STRICT negative on lint path: bad absolute lake path must exit nonzero with no fall-back.
echo "== SLAKE_FS_PROC_STRICT=1 negative lint (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_pipe_strict_lake_lint
  out="$("$SLAKE_EXE" lint 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on lint path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT lint fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT lint message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on lint path"
    exit 1
  fi
  echo "fs_proc_pipe_lint_strict_negative: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 script (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" script 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE script path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE script path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner on script empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '(^|[[:space:]])script([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq 'script'; then
      echo "FAIL: expected freestanding path/argv to mention script (empty rest)"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc pipe spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare script"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare script"
    exit 1
  fi
  echo "fs_proc_pipe_script_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 script --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" script --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE script path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE script path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc pipe/stdio"; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner on script path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'script'; then
    echo "FAIL: expected freestanding argv/path to mention script"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'script[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated PIPE script argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc pipe spawn failed'; then
    echo "FAIL: PIPE spawn failed for script"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on script --help"
    exit 1
  fi
  echo "fs_proc_pipe_script: OK"
)

# STRICT negative on script path: bad absolute lake path must exit nonzero with no fall-back.
echo "== SLAKE_FS_PROC_STRICT=1 negative script (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_pipe_strict_lake_script
  out="$("$SLAKE_EXE" script 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on script path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT script fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT script message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on script path"
    exit 1
  fi
  echo "fs_proc_pipe_script_strict_negative: OK"
)


# W91: FS_PROC_PIPE clean path (CLAIMED token; freestanding dual residual → lake clean; empty-rest-only)
echo "== SLAKE_USE_FS_PROC_PIPE=1 clean (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PIPE clean empty-rest expected rc=0, got $rc"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE clean path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to (IO\.Process|native clean)'; then
    echo "FAIL: PIPE clean path fell back (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe/stdio'; then
    echo "FAIL: expected freestanding Systems.Proc pipe/stdio banner on clean empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
    echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on clean rc=0"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '(^|[[:space:]])clean([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq 'clean'; then
      echo "FAIL: expected freestanding path/argv to mention clean (empty rest)"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare clean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare clean"
    exit 1
  fi
  echo "fs_proc_pipe_clean_empty_rest: OK"
)

# Empty-rest-only negative: non-empty rest (incl. --help) must refuse without spawn/fall-back.
echo "== SLAKE_USE_FS_PROC_PIPE=1 clean --help (non-empty rest refused) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" clean --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: PIPE clean --help rest should exit nonzero (empty-rest-only)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'non-empty rest refused|empty rest only'; then
    echo "FAIL: expected empty-rest-only refuse messaging on PIPE clean --help"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to (IO\.Process|native clean)'; then
    echo "FAIL: PIPE clean rest refuse must not fall back to native"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
    echo "FAIL: PIPE clean rest refuse must not report lake success"
    exit 1
  fi
  echo "fs_proc_pipe_clean_rest_refused: OK"
)

# STRICT negative on clean path: bad absolute lake path must exit nonzero with no fall-back.
echo "== SLAKE_FS_PROC_STRICT=1 negative clean (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_pipe_strict_lake_clean
  out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on clean path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT clean fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to (IO\.Process|native clean)'; then
    echo "FAIL: STRICT clean message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on clean path"
    exit 1
  fi
  echo "fs_proc_pipe_clean_strict_negative: OK"
)



# W92: FS_PROC_PIPE update path (outside CLAIMED; rest plumbed; require pipe banners + rc==0 OK line)
echo "== SLAKE_USE_FS_PROC_PIPE=1 update (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" update 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE update fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE update fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe/stdio|FS_PROC_PIPE'; then
    echo "FAIL: expected freestanding pipe banner on update path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'pipe'; then
    echo "FAIL: expected pipe-specific wording on update PIPE path (no bare Proc false-green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare update"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
      echo "FAIL: expected pipe success line on update rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_update_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 update --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" update --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE update rest fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE update rest fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe/stdio|FS_PROC_PIPE'; then
    echo "FAIL: expected freestanding pipe banner on update --help"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'pipe'; then
    echo "FAIL: expected pipe-specific wording on update --help PIPE path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq -- '--help'; then
    echo "FAIL: expected --help in PIPE update argv"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: PIPE spawn failed for update --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
      echo "FAIL: expected pipe success line on update --help rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_update_rest: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative update PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w92-update-pipe-strict"
  out="$("$SLAKE_EXE" update 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on update"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE update fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE update says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE update"
    exit 1
  fi
  echo "fs_proc_pipe_update_strict_negative: OK"
)


# W93: FS_PROC_PIPE pack path (outside CLAIMED; rest plumbed; require pipe banners + rc==0 OK line)
echo "== SLAKE_USE_FS_PROC_PIPE=1 pack (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" pack 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE pack fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE pack fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding pipe banner on pack path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'pipe/stdio|stdout'; then
    echo "FAIL: expected pipe-specific wording on pack PIPE path (no bare Proc false-green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare pack"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
      echo "FAIL: expected pipe success line on pack rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_pack_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 pack --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" pack --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE pack rest fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE pack rest fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding pipe banner on pack --help"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'pipe/stdio|stdout'; then
    echo "FAIL: expected pipe-specific wording on pack --help PIPE path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq -- '--help'; then
    echo "FAIL: expected --help in PIPE pack argv"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: PIPE spawn failed for pack --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
      echo "FAIL: expected pipe success line on pack --help rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_pack_rest: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative pack PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w93-pack-pipe-strict"
  out="$("$SLAKE_EXE" pack 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on pack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE pack fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE pack says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE pack"
    exit 1
  fi
  echo "fs_proc_pipe_pack_strict_negative: OK"
)


# W94: freestanding FS_PROC_PIPE for `cache` (outside CLAIMED). Empty rest + --help rest + STRICT.
echo "== SLAKE_USE_FS_PROC_PIPE=1 cache empty rest on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" cache 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE cache fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE cache fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding pipe banner on cache empty rest"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'pipe/stdio|stdout'; then
    echo "FAIL: expected pipe-specific wording on cache PIPE path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]cache([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]cache([[:space:]]|$)'; then
      echo "FAIL: expected argv token cache on PIPE path"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare cache"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
      echo "FAIL: expected pipe success line on cache rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_cache_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 cache --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" cache --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: PIPE cache rest fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: PIPE cache rest fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding pipe banner on cache --help"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'pipe/stdio|stdout'; then
    echo "FAIL: expected pipe-specific wording on cache --help PIPE path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq -- '--help'; then
    echo "FAIL: expected --help in PIPE cache argv"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: PIPE spawn failed for cache --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc pipe)"; then
      echo "FAIL: expected pipe success line on cache --help rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_cache_rest: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative cache PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w94-cache-pipe-strict"
  out="$("$SLAKE_EXE" cache 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on cache"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE cache fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE cache says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE cache"
    exit 1
  fi
  echo "fs_proc_pipe_cache_strict_negative: OK"
)

# W95: freestanding FS_PROC_PIPE for `unpack` (outside CLAIMED). Bare empty-rest + --help rest.
# lake unpack may exit nonzero without artifacts — still require freestanding path + banners.
echo "== SLAKE_USE_FS_PROC_PIPE=1 unpack (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_FS_PROC_STRICT || true
  rc=0
  out="$("$SLAKE_EXE" unpack 2>&1)" || rc=$?
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process|IO\.Process'; then
    if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
      echo "FAIL: FS_PROC_PIPE unpack path fell back to IO.Process (not true freestanding green)"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on unpack path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]unpack([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]unpack([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include unpack command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected unpack chdir/cwd honesty banner on empty-rest FS_PROC_PIPE unpack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC_PIPE spawn failed for bare unpack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare unpack"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on unpack rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_unpack_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 unpack --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_FS_PROC_STRICT || true
  rc=0
  out="$("$SLAKE_EXE" unpack --help 2>&1)" || rc=$?
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process' && ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: FS_PROC_PIPE unpack path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on unpack path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE unpack argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC_PIPE spawn failed for unpack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on unpack --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on unpack --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected unpack chdir/cwd honesty banner on FS_PROC_PIPE unpack"
    exit 1
  fi
  echo "fs_proc_pipe_unpack_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative unpack PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w95-unpack-pipe-strict"
  out="$("$SLAKE_EXE" unpack 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on unpack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE unpack fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE unpack says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE unpack"
    exit 1
  fi
  echo "fs_proc_pipe_unpack_strict_negative: OK"
)


# W96: freestanding FS_PROC_PIPE for `query` (outside CLAIMED). Bare empty-rest + --help rest.
echo "== SLAKE_USE_FS_PROC_PIPE=1 query (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  rc=0
  out="$("$SLAKE_EXE" query 2>&1)" || rc=$?
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process|IO\.Process'; then
    if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
      echo "FAIL: FS_PROC_PIPE query path fell back to IO.Process (not true freestanding green)"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on query path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]query([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]query([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include query command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query chdir/cwd honesty banner on empty-rest FS_PROC_PIPE query"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC_PIPE spawn failed for bare query"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare query"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on query rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_query_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 query --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" query --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE query path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on query path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE query argv line"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query chdir/cwd honesty banner on FS_PROC_PIPE query"
    exit 1
  fi
  echo "fs_proc_pipe_query_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative query PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w96-query-pipe-strict"
  out="$("$SLAKE_EXE" query 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on query"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE query fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE query says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE query"
    exit 1
  fi
  echo "fs_proc_pipe_query_strict_negative: OK"
)

# W97: freestanding FS_PROC_PIPE for `shake` (outside CLAIMED). Bare empty-rest + --help rest.
echo "== SLAKE_USE_FS_PROC_PIPE=1 shake (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  rc=0
  out="$("$SLAKE_EXE" shake 2>&1)" || rc=$?
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process|IO\.Process'; then
    if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
      echo "FAIL: FS_PROC_PIPE shake path fell back to IO.Process (not true freestanding green)"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on shake path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]shake([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]shake([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include shake command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected shake chdir/cwd honesty banner on empty-rest FS_PROC_PIPE shake"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC_PIPE spawn failed for bare shake"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare shake"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on shake rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_shake_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 shake --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" shake --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE shake path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on shake path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE shake argv line"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected shake chdir/cwd honesty banner on FS_PROC_PIPE shake"
    exit 1
  fi
  echo "fs_proc_pipe_shake_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative shake PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w97-shake-pipe-strict"
  out="$("$SLAKE_EXE" shake 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on shake"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE shake fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE shake says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE shake"
    exit 1
  fi
  echo "fs_proc_pipe_shake_strict_negative: OK"
)

# W98: freestanding FS_PROC_PIPE for `serve` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest.
# PIPE serve has no dedicated cwd-parity/BUG-1 band (same as PIPE query/shake prior waves): multi-arg fs_proc_smoke covers relative LAKE + resolveLakeAbs; PIPE shares the same Lean resolveLakeAbs + C leading-/ gate.
echo "== SLAKE_USE_FS_PROC_PIPE=1 serve (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  rc=0
  out="$("$SLAKE_EXE" serve 2>&1)" || rc=$?
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process|IO\.Process'; then
    if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
      echo "FAIL: FS_PROC_PIPE serve path fell back to IO.Process (not true freestanding green)"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on serve path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]serve([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]serve([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include serve command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected serve chdir/cwd honesty banner on empty-rest FS_PROC_PIPE serve"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC_PIPE spawn failed for bare serve"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare serve"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on serve rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pipe_serve_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 serve --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" serve --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE serve path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on serve path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE serve argv line"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected serve chdir/cwd honesty banner on FS_PROC_PIPE serve"
    exit 1
  fi
  echo "fs_proc_pipe_serve_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative serve PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w98-serve-pipe-strict"
  out="$("$SLAKE_EXE" serve 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on serve"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE serve fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE serve says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE serve"
    exit 1
  fi
  echo "fs_proc_pipe_serve_strict_negative: OK"
)

# W99: freestanding FS_PROC_PIPE for `upload` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest.
# PIPE upload has no dedicated cwd-parity/BUG-1 band (same as PIPE query/shake/serve prior waves): multi-arg fs_proc_smoke covers relative LAKE + resolveLakeAbs; PIPE shares the same Lean resolveLakeAbs + C leading-/ gate.
echo "== SLAKE_USE_FS_PROC_PIPE=1 upload (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  rc=0
  out="$("$SLAKE_EXE" upload 2>&1)" || rc=$?
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process|IO\.Process'; then
    if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
      echo "FAIL: FS_PROC_PIPE upload path fell back to IO.Process (not true freestanding green)"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on upload path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]upload([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]upload([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include upload command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upload chdir/cwd honesty banner on empty-rest FS_PROC_PIPE upload"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC_PIPE spawn failed for bare upload"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare upload"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on upload rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on upload empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_upload_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 upload --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" upload --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE upload path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on upload path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE upload argv line"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upload chdir/cwd honesty banner on FS_PROC_PIPE upload"
    exit 1
  fi
  echo "fs_proc_pipe_upload_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative upload PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w99-upload-pipe-strict"
  out="$("$SLAKE_EXE" upload 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on upload"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE upload fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE upload says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE upload"
    exit 1
  fi
  echo "fs_proc_pipe_upload_strict_negative: OK"
)

# W100: freestanding FS_PROC_PIPE for `lean` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest.
# PIPE lean has no dedicated cwd-parity/BUG-1 band (same as PIPE query/shake/serve prior waves): multi-arg fs_proc_smoke covers relative LAKE + resolveLakeAbs; PIPE shares the same Lean resolveLakeAbs + C leading-/ gate.
echo "== SLAKE_USE_FS_PROC_PIPE=1 lean (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  rc=0
  out="$("$SLAKE_EXE" lean 2>&1)" || rc=$?
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process|IO\.Process'; then
    if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
      echo "FAIL: FS_PROC_PIPE lean path fell back to IO.Process (not true freestanding green)"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on lean path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]lean([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]lean([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include lean command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected lean chdir/cwd honesty banner on empty-rest FS_PROC_PIPE lean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC_PIPE spawn failed for bare lean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare lean"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on lean rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on lean empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_lean_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 lean --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" lean --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE lean path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on lean path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE lean argv line"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected lean chdir/cwd honesty banner on FS_PROC_PIPE lean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC_PIPE spawn failed for lean --help"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on lean --help"
    exit 1
  fi
  echo "fs_proc_pipe_lean_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative lean PIPE (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w100-lean-pipe-strict"
  out="$("$SLAKE_EXE" lean 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT PIPE + bad LAKE should exit nonzero on lean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT PIPE lean fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT PIPE lean says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on PIPE lean"
    exit 1
  fi
  echo "fs_proc_pipe_lean_strict_negative: OK"
)


# W101: freestanding FS_PROC_PIPE for `scripts` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest.
# PIPE scripts has no dedicated cwd-parity/BUG-1 band (same as PIPE query/shake/serve/upload/lean prior waves): multi-arg fs_proc_smoke covers relative LAKE + resolveLakeAbs; PIPE shares the same Lean resolveLakeAbs + C leading-/ gate.
echo "== SLAKE_USE_FS_PROC_PIPE=1 scripts (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" scripts 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE scripts path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on scripts path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]scripts([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]scripts([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include scripts command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected scripts chdir/cwd honesty banner on empty-rest FS_PROC_PIPE scripts"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare scripts"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare scripts"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on scripts rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on scripts empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_scripts_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 scripts --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" scripts --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE scripts path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on scripts path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE scripts argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for scripts"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on scripts --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on scripts --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected scripts chdir/cwd honesty banner on FS_PROC_PIPE scripts"
    exit 1
  fi
  echo "fs_proc_pipe_scripts_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative scripts (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w101-scripts-strict-pipe"
  out="$("$SLAKE_EXE" scripts 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on scripts path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT scripts fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT scripts message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on scripts path"
    exit 1
  fi
  echo "fs_proc_pipe_scripts_strict_negative: OK"
)


# W102: freestanding FS_PROC_PIPE for `setup-file` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest.
# PIPE setup-file has no dedicated cwd-parity/BUG-1 band (same as PIPE query/shake/serve/upload/lean prior waves): multi-arg fs_proc_smoke covers relative LAKE + resolveLakeAbs; PIPE shares the same Lean resolveLakeAbs + C leading-/ gate.
echo "== SLAKE_USE_FS_PROC_PIPE=1 setup-file (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" setup-file 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE setup-file path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on setup-file path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]setup-file([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]setup-file([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include setup-file command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected setup-file chdir/cwd honesty banner on empty-rest FS_PROC_PIPE setup-file"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare setup-file"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare setup-file"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on setup-file rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on setup-file empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_setup_file_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 setup-file --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" setup-file --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE setup-file path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on setup-file path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE setup-file argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for setup-file"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on setup-file --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on setup-file --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected setup-file chdir/cwd honesty banner on FS_PROC_PIPE setup-file"
    exit 1
  fi
  echo "fs_proc_pipe_setup_file_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative setup-file (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w102-setup-file-strict-pipe"
  out="$("$SLAKE_EXE" setup-file 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on setup-file path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT setup-file fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT setup-file message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on setup-file path"
    exit 1
  fi
  echo "fs_proc_pipe_setup_file_strict_negative: OK"
)


# W103: freestanding FS_PROC_PIPE for `self-check` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest.
# PIPE self-check has no dedicated cwd-parity/BUG-1 band (same as PIPE query/shake/serve/upload/lean prior waves): multi-arg fs_proc_smoke covers relative LAKE + resolveLakeAbs; PIPE shares the same Lean resolveLakeAbs + C leading-/ gate.
echo "== SLAKE_USE_FS_PROC_PIPE=1 self-check (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" self-check 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE self-check path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on self-check path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]self-check([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]self-check([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include self-check command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected self-check chdir/cwd honesty banner on empty-rest FS_PROC_PIPE self-check"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare self-check"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare self-check"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on self-check rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on self-check empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_self_check_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 self-check --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" self-check --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE self-check path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on self-check path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE self-check argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for self-check"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on self-check --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on self-check --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected self-check chdir/cwd honesty banner on FS_PROC_PIPE self-check"
    exit 1
  fi
  echo "fs_proc_pipe_self_check_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative self-check (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w103-self-check-strict-pipe"
  out="$("$SLAKE_EXE" self-check 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on self-check path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT self-check fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT self-check message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on self-check path"
    exit 1
  fi
  echo "fs_proc_pipe_self_check_strict_negative: OK"
)

# W104: freestanding FS_PROC_PIPE for `version-tags` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest.
# PIPE version-tags has no dedicated cwd-parity/BUG-1 band (same as PIPE query/shake/serve/upload/lean prior waves): multi-arg fs_proc_smoke covers relative LAKE + resolveLakeAbs; PIPE shares the same Lean resolveLakeAbs + C leading-/ gate.
echo "== SLAKE_USE_FS_PROC_PIPE=1 version-tags (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" version-tags 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE version-tags path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on version-tags path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]version-tags([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]version-tags([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include version-tags command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected version-tags chdir/cwd honesty banner on empty-rest FS_PROC_PIPE version-tags"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare version-tags"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare version-tags"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on version-tags rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on version-tags empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_version_tags_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 version-tags --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" version-tags --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE version-tags path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on version-tags path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE version-tags argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for version-tags"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on version-tags --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on version-tags --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected version-tags chdir/cwd honesty banner on FS_PROC_PIPE version-tags"
    exit 1
  fi
  echo "fs_proc_pipe_version_tags_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative version-tags (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w104-version-tags-strict-pipe"
  out="$("$SLAKE_EXE" version-tags 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on version-tags path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT version-tags fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT version-tags message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on version-tags path"
    exit 1
  fi
  echo "fs_proc_pipe_version_tags_strict_negative: OK"
)


echo "== SLAKE_USE_FS_PROC_PIPE=1 query-kind (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" query-kind 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE query-kind path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on query-kind path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]query-kind([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]query-kind([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include query-kind command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query-kind chdir/cwd honesty banner on empty-rest FS_PROC_PIPE query-kind"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare query-kind"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare query-kind"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on query-kind rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on query-kind empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_query_kind_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 query-kind --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" query-kind --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE query-kind path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on query-kind path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE query-kind argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for query-kind"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on query-kind --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on query-kind --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query-kind chdir/cwd honesty banner on FS_PROC_PIPE query-kind"
    exit 1
  fi
  echo "fs_proc_pipe_query_kind_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative query-kind (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w104-query-kind-strict-pipe"
  out="$("$SLAKE_EXE" query-kind 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on query-kind path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT query-kind fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT query-kind message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on query-kind path"
    exit 1
  fi
  echo "fs_proc_pipe_query_kind_strict_negative: OK"
)


echo "== SLAKE_USE_FS_PROC_PIPE=1 resolve-deps (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" resolve-deps 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE resolve-deps path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe/stdio'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on resolve-deps path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]resolve-deps([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]resolve-deps([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include resolve-deps command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected resolve-deps chdir/cwd honesty banner on empty-rest FS_PROC_PIPE resolve-deps"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare resolve-deps"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare resolve-deps"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on resolve-deps rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on resolve-deps empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_resolve_deps_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 resolve-deps --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" resolve-deps --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE resolve-deps path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe/stdio'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on resolve-deps path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE resolve-deps argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for resolve-deps"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on resolve-deps --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on resolve-deps --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected resolve-deps chdir/cwd honesty banner on FS_PROC_PIPE resolve-deps"
    exit 1
  fi
  echo "fs_proc_pipe_resolve_deps_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative resolve-deps (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w114-resolve-deps-strict-pipe"
  out="$("$SLAKE_EXE" resolve-deps 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on resolve-deps path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT resolve-deps fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT resolve-deps message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on resolve-deps path"
    exit 1
  fi
  echo "fs_proc_pipe_resolve_deps_strict_negative: OK"
)




echo "== SLAKE_USE_FS_PROC_PIPE=1 reservoir-config (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" reservoir-config 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE reservoir-config path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe/stdio'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on reservoir-config path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]reservoir-config([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]reservoir-config([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include reservoir-config command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected reservoir-config chdir/cwd honesty banner on empty-rest FS_PROC_PIPE reservoir-config"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare reservoir-config"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare reservoir-config"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on reservoir-config rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on reservoir-config empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_reservoir_config_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 reservoir-config --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" reservoir-config --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE reservoir-config path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc pipe/stdio'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on reservoir-config path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE reservoir-config argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for reservoir-config"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on reservoir-config --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on reservoir-config --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected reservoir-config chdir/cwd honesty banner on FS_PROC_PIPE reservoir-config"
    exit 1
  fi
  echo "fs_proc_pipe_reservoir_config_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative reservoir-config (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w115-reservoir-config-strict-pipe"
  out="$("$SLAKE_EXE" reservoir-config 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on reservoir-config path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT reservoir-config fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT reservoir-config message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on reservoir-config path"
    exit 1
  fi
  echo "fs_proc_pipe_reservoir_config_strict_negative: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 upgrade (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" upgrade 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE upgrade path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'freestanding Systems.Proc pipe/stdio'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on upgrade path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]upgrade([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]upgrade([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include upgrade command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upgrade chdir/cwd honesty banner on empty-rest FS_PROC_PIPE upgrade"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for bare upgrade"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow|too many'; then
    echo "FAIL: unexpected rest overflow on bare upgrade"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on upgrade rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty env|child env empty'; then
    echo "FAIL: expected empty child env honesty banner on upgrade empty-rest"
    exit 1
  fi
  echo "fs_proc_pipe_upgrade_empty: OK"
)

echo "== SLAKE_USE_FS_PROC_PIPE=1 upgrade --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" upgrade --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC_PIPE upgrade path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'freestanding Systems.Proc pipe/stdio'; then
    echo "FAIL: expected freestanding Systems.Proc pipe banner on upgrade path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '([[:space:]]|^)--help([[:space:]]|$)'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC_PIPE upgrade argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: PIPE spawn failed for upgrade"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow|too many'; then
    echo "FAIL: unexpected rest overflow on upgrade --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc pipe)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc pipe)' on upgrade --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upgrade chdir/cwd honesty banner on FS_PROC_PIPE upgrade"
    exit 1
  fi
  echo "fs_proc_pipe_upgrade_help: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative upgrade (bad lake path, PIPE) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC_PIPE=1
  unset SLAKE_USE_FS_PROC || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w116-upgrade-strict-pipe"
  out="$("$SLAKE_EXE" upgrade 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on upgrade path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT upgrade fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT upgrade message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on upgrade path"
    exit 1
  fi
  echo "fs_proc_pipe_upgrade_strict_negative: OK"
)


echo "fs_proc_pipe_smoke: OK"
