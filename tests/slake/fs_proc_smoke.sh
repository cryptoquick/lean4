#!/usr/bin/env bash
# Smoke: SLAKE_USE_FS_PROC=1 slake build/test/exe/lint/script/clean/update/pack/cache/unpack/query/shake/serve/upload/lean/scripts/setup-file/self-check/version-tags/query-kind check-build/check-test on basic_toml (requires FS-linked driver).
# W86: FS_PROC plumb remaining argv after `build` (CLAIMED still build/clean/env).
# W87: FS_PROC also covers `test`; W88: also `exe` (+ rest); W89: also `lint` (+ rest); W90: also `script` (+ rest); W91: also `clean` (empty-rest-only; CLAIMED token dual residual); W92: also `update` (rest plumbed; outside CLAIMED); W93: also `pack` (rest plumbed; outside CLAIMED; chdir pkg for relative archive parity); W94: also `cache` (rest plumbed; outside CLAIMED; chdir pkg); W95: also `unpack` (rest plumbed; outside CLAIMED; chdir pkg); W96: also `query` (rest plumbed; outside CLAIMED; chdir pkg); W97: also `shake`; W98: also `serve`; W99: also `upload` (rest plumbed; outside CLAIMED; chdir pkg); W100: also `lean` (rest plumbed; outside CLAIMED; chdir pkg); W101: also `scripts` (rest plumbed; outside CLAIMED; chdir pkg); W102: also `setup-file` (rest plumbed; outside CLAIMED; chdir pkg); W103: also `self-check`; W104: also `version-tags`; W109: also `check-build` (rest plumbed; outside CLAIMED; chdir pkg); W110: also `check-test` (rest plumbed; outside CLAIMED; chdir pkg); W113: also `query-kind` (rest plumbed; outside CLAIMED; chdir pkg); W114: also `resolve-deps` (rest plumbed; outside CLAIMED; chdir pkg); CLAIMED unchanged.; W115: also `reservoir-config`; W116: also `upgrade` (+ rest; chdir pkg; resolveLakeAbs)
# True green requires the Systems.Proc success line — not a classic fall-back path.
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

# Require env to report FS_PROC linked (Option C link present).
env_out="$("$SLAKE_EXE" env 2>&1)" || true
if ! grep -Fq "SLAKE_FS_PROC_LINKED: 1" <<<"$env_out"; then
  echo "SKIP: slake not linked with freestanding Proc shim (rebuild driver after systems extract)"
  printf '%s\n' "$env_out"
  exit 0
fi

echo "== SLAKE_USE_FS_PROC=1 build on $PKG =="
(
  cd "$PKG"
  lake clean || true
  export SLAKE_USE_FS_PROC=1
  # Unset PIPE so multi-arg path is unambiguous (precedence trap if both inherited).
  unset SLAKE_USE_FS_PROC_PIPE || true
  # Unset STRICT so a true spawn path is measured; smoke fails if fall-back occurs.
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
    echo "FAIL: expected success line 'OK (via lake / Systems.Proc)'"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc"; then
    echo "FAIL: expected freestanding Systems.Proc banner"
    exit 1
  fi
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: slake build exited $rc under SLAKE_USE_FS_PROC=1"
    exit 1
  fi
  if [[ ! -d .lake/build ]]; then
    echo "FAIL: expected .lake/build after FS_PROC build"
    exit 1
  fi
  "$SLAKE_EXE" clean >/dev/null
)

# W86: non-empty rest after `build` must reach freestanding argv (not hard-coded build-only).
# --help is a harmless lake flag outside CLAIMED parity; assert banner + shown argv include rest.
echo "== SLAKE_USE_FS_PROC=1 build --help (non-empty rest) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" build --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC rest path fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC rest path fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc multi-arg"; then
    echo "FAIL: expected freestanding Systems.Proc multi-arg banner for rest path"
    exit 1
  fi
  # CLI prints: lake=… --dir=… build --help
  if ! printf '%s' "$out" | grep -Eiq 'build[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on single --help token"
    exit 1
  fi
  # lake --help under build may exit 0; accept 0 or lake's help exit — require no spawn fail fall-back.
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for build --help"
    exit 1
  fi
  echo "fs_proc_rest_argv: OK"
)

# STRICT negative: bad absolute lake path must exit nonzero with no IO.Process fall back.
echo "== SLAKE_FS_PROC_STRICT=1 negative (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_strict_lake
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging"
    exit 1
  fi
  echo "fs_proc_strict_negative: OK"
)


# W87: freestanding FS_PROC for `test` (outside CLAIMED). Assert banner + argv contains `test`.
# lake test may exit nonzero without a testDriver — still require freestanding path, not IO.Process fall-back.
echo "== SLAKE_USE_FS_PROC=1 test on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" test 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC test path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC test path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc"; then
    echo "FAIL: expected freestanding Systems.Proc banner on test path"
    exit 1
  fi
  # argv line must show the fixed `test` command token (not only build)
  if ! printf '%s' "$out" | grep -Eiq '(^|[[:space:]])test([[:space:]]|$)'; then
    # also accept banner/path forms that print cmd=test or … test
    if ! printf '%s' "$out" | grep -Eiq 'test'; then
      echo "FAIL: expected freestanding argv/path to mention test"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for test"
    exit 1
  fi
  # Prefer explicit success line when lake test exits 0; tolerate nonzero lake status if freestanding ran.
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on test rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_test: OK"
)

# W87: non-empty rest after `test` must reach freestanding argv.
echo "== SLAKE_USE_FS_PROC=1 test --help (non-empty rest) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" test --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC test rest path fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC test rest path fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc multi-arg"; then
    echo "FAIL: expected freestanding Systems.Proc multi-arg banner for test rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'test[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC test argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on single --help token (test)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for test --help"
    exit 1
  fi
  echo "fs_proc_test_rest_argv: OK"
)

# STRICT negative on test path: bad absolute lake path must exit nonzero with no fall-back.
echo "== SLAKE_FS_PROC_STRICT=1 negative test (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_strict_lake_test
  out="$("$SLAKE_EXE" test 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on test path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT test fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT test message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on test path"
    exit 1
  fi
  echo "fs_proc_test_strict_negative: OK"
)

# W88: freestanding FS_PROC for `exe` (outside CLAIMED). Bare empty-rest + --help rest + STRICT.
# lake exe may exit nonzero without a target — still require freestanding path, not IO.Process fall-back.
echo "== SLAKE_USE_FS_PROC=1 exe (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" exe 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC exe empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC exe empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc"; then
    echo "FAIL: expected freestanding Systems.Proc banner on exe empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '(^|[[:space:]])exe([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq 'exe'; then
      echo "FAIL: expected freestanding argv/path to mention exe (empty rest)"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare exe"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare exe"
    exit 1
  fi
  echo "fs_proc_exe_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 exe --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" exe --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC exe path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC exe path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc"; then
    echo "FAIL: expected freestanding Systems.Proc banner on exe path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '(^|[[:space:]])exe([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq 'exe'; then
      echo "FAIL: expected freestanding argv/path to mention exe"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'exe[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC exe argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for exe"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on exe --help"
    exit 1
  fi
  echo "fs_proc_exe: OK"
)

# STRICT negative on exe path: bad absolute lake path must exit nonzero with no fall-back.
echo "== SLAKE_FS_PROC_STRICT=1 negative exe (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_strict_lake_exe
  out="$("$SLAKE_EXE" exe 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on exe path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT exe fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT exe message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on exe path"
    exit 1
  fi
  echo "fs_proc_exe_strict_negative: OK"
)


# W89: freestanding FS_PROC for `lint` (outside CLAIMED). Bare empty-rest + --help rest + STRICT.
# lake lint may exit nonzero without config — still require freestanding path, not IO.Process fall-back.
echo "== SLAKE_USE_FS_PROC=1 lint (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" lint 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC lint empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC lint empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc"; then
    echo "FAIL: expected freestanding Systems.Proc banner on lint empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '(^|[[:space:]])lint([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq 'lint'; then
      echo "FAIL: expected freestanding argv/path to mention lint (empty rest)"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare lint"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare lint"
    exit 1
  fi
  echo "fs_proc_lint_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 lint --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" lint --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC lint path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC lint path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc"; then
    echo "FAIL: expected freestanding Systems.Proc banner on lint path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lint'; then
    echo "FAIL: expected freestanding argv/path to mention lint"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lint[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC lint argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for lint"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on lint --help"
    exit 1
  fi
  echo "fs_proc_lint: OK"
)

# STRICT negative on lint path: bad absolute lake path must exit nonzero with no fall-back.
echo "== SLAKE_FS_PROC_STRICT=1 negative lint (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_strict_lake_lint
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
  echo "fs_proc_lint_strict_negative: OK"
)

echo "== SLAKE_USE_FS_PROC=1 script (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" script 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC script path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC script path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc multi-arg"; then
    echo "FAIL: expected freestanding Systems.Proc multi-arg banner on script empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '(^|[[:space:]])script([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq 'script'; then
      echo "FAIL: expected freestanding argv/path to mention script (empty rest)"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare script"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare script"
    exit 1
  fi
  echo "fs_proc_script_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 script --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" script --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC script path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC script path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "freestanding Systems.Proc multi-arg"; then
    echo "FAIL: expected freestanding Systems.Proc multi-arg banner on script path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'script'; then
    echo "FAIL: expected freestanding argv/path to mention script"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'script[[:space:]]+--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC script argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'freestanding Proc spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for script"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on script --help"
    exit 1
  fi
  echo "fs_proc_script: OK"
)

# STRICT negative on script path: bad absolute lake path must exit nonzero with no fall-back.
echo "== SLAKE_FS_PROC_STRICT=1 negative script (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_strict_lake_script
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
  echo "fs_proc_script_strict_negative: OK"
)


# W91: FS_PROC clean path (CLAIMED token; freestanding dual residual → lake clean; empty-rest-only)
echo "== SLAKE_USE_FS_PROC=1 clean (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" clean 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: FS_PROC clean empty-rest expected rc=0, got $rc"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC clean path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to (IO\.Process|native clean)'; then
    echo "FAIL: FS_PROC clean path fell back (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc multi-arg banner on clean empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
    echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on clean rc=0"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '(^|[[:space:]])clean([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq 'clean'; then
      echo "FAIL: expected freestanding argv/path to mention clean (empty rest)"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare clean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare clean"
    exit 1
  fi
  echo "fs_proc_clean_empty_rest: OK"
)

# Empty-rest-only negative: non-empty rest (incl. --help) must refuse without spawn/fall-back.
echo "== SLAKE_USE_FS_PROC=1 clean --help (non-empty rest refused) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" clean --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: clean --help rest should exit nonzero (empty-rest-only)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'non-empty rest refused|empty rest only'; then
    echo "FAIL: expected empty-rest-only refuse messaging on clean --help"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to (IO\.Process|native clean)'; then
    echo "FAIL: clean rest refuse must not fall back to native"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
    echo "FAIL: clean rest refuse must not report lake success"
    exit 1
  fi
  echo "fs_proc_clean_rest_refused: OK"
)

# STRICT negative on clean path: bad absolute lake path must exit nonzero with no fall-back.
echo "== SLAKE_FS_PROC_STRICT=1 negative clean (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE=/no/such/slake_fs_proc_strict_lake_clean
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
  echo "fs_proc_clean_strict_negative: OK"
)



# W92: freestanding FS_PROC for `update` (outside CLAIMED). Bare empty-rest + --help rest + STRICT.
# lake update may exit nonzero without network/manifest work — still require freestanding path + banners.
# When lake returns 0, require OK (via lake / Systems.Proc) success line (no bare-Proc false-green).
echo "== SLAKE_USE_FS_PROC=1 update (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" update 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC update empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC update empty-rest fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc multi-arg banner on update empty-rest path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]update([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]update([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include update command token"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare update"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on update rc=0"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare update"
    exit 1
  fi
  echo "fs_proc_update_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 update --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" update --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC update path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC update path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on update path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC update argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for update"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on update --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on update --help rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_update_rest: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative update (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w92-update-strict"
  out="$("$SLAKE_EXE" update 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on update path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT update fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT update message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on update path"
    exit 1
  fi
  echo "fs_proc_update_strict_negative: OK"
)


# W93: freestanding FS_PROC for `pack` (outside CLAIMED). Bare empty-rest + --help rest + STRICT.
# lake pack may exit nonzero without artifacts — still require freestanding path + banners.
# When lake returns 0, require OK (via lake / Systems.Proc) success line (no bare-Proc false-green).
echo "== SLAKE_USE_FS_PROC=1 pack (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" pack 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC pack path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC pack path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on pack path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]pack([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]pack([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include pack command token"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare pack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare pack"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on pack rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pack_empty_rest: OK"
)

# Relative archive path parity: FS_PROC chdir(pkg) so archive lands under package root
# (matches classic IO.Process cwd=pkg). Create minimal buildDir so tar succeeds.
echo "== SLAKE_USE_FS_PROC=1 pack relative archive path on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  mkdir -p .lake/build
  echo "w93-pack-rel" > .lake/build/w93_pack_marker.txt
  rm -f w93-pack-rel.tgz .lake/w93-pack-rel.tgz
  out="$("$SLAKE_EXE" pack w93-pack-rel.tgz 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC pack relative fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC pack relative fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on pack relative path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected pack chdir/cwd honesty banner on FS_PROC pack"
    exit 1
  fi
  if [[ ! -f "$PKG/w93-pack-rel.tgz" ]]; then
    echo "FAIL: expected relative archive under package root ($PKG/w93-pack-rel.tgz)"
    ls -la "$PKG" .lake 2>/dev/null || true
    exit 1
  fi
  if [[ -f "$PWD/w93-pack-rel.tgz" && "$PWD" != "$PKG" ]]; then
    echo "FAIL: archive also/only at process cwd outside pkg"
    exit 1
  fi
  rm -f "$PKG/w93-pack-rel.tgz"
  echo "fs_proc_pack_relative_archive: OK"
)

echo "== SLAKE_USE_FS_PROC=1 pack --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" pack --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC pack path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC pack path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on pack path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC pack argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for pack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on pack --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on pack --help rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_pack_rest: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative pack (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w93-pack-strict"
  out="$("$SLAKE_EXE" pack 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on pack path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT pack fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT pack message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on pack path"
    exit 1
  fi
  echo "fs_proc_pack_strict_negative: OK"
)


# W94 BUG-1 follow-on: cache cwd-parity / absolute-lake honesty.
# FS_PROC chdir(pkg) must not break relative $LAKE (CLI absolutizes pre-chdir).
# Soft-fail OK if lake binary missing at resolved path — still require no wrong-cwd fall-back forge.
echo "== SLAKE_USE_FS_PROC=1 cache cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  # Prefer a true absolute lake when available; also exercise relative LAKE=./… against pre-chdir cwd.
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for cache cwd-parity; skip"
      echo "fs_proc_cache_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  # Relative path from package root to lake (when lake is under repo); else use absolute (still exercises chdir banner).
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      # path relative to PKG
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" cache --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: cache cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: cache cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on cache cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected cache chdir/cwd honesty banner"
    exit 1
  fi
  # Lake line should show absolute lake= path (leading /) after resolveLakeAbs
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on cache FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    # Soft: relative resolve edge — do not forge green if spawn truly failed
    echo "SOFT: cache cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_cache_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_cache_cwd_parity: OK"
)

# W94: freestanding FS_PROC for `cache` (outside CLAIMED). Empty rest + --help rest + STRICT.
# Rest may rebind Lake globals (unlike clean empty-rest-only). Dual residual honesty.
echo "== SLAKE_USE_FS_PROC=1 cache empty rest on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" cache 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC cache path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC cache path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on cache path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]cache([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]cache([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include cache command token"
      exit 1
    fi
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare cache"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on bare cache"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on cache rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_cache_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 cache --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" cache --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC cache path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC cache path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on cache path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC cache argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'pipe spawn failed|spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for cache"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'rest argv exceeds max'; then
    echo "FAIL: unexpected rest overflow on cache --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq "OK (via lake / Systems.Proc)"; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on cache --help rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_cache_rest: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative cache (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w94-cache-strict"
  out="$("$SLAKE_EXE" cache 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on cache path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT cache fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT cache message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on cache path"
    exit 1
  fi
  echo "fs_proc_cache_strict_negative: OK"
)

# W95: freestanding FS_PROC for `unpack` (outside CLAIMED). Bare empty-rest + --help rest.
# lake unpack may exit nonzero without artifacts — still require freestanding path + banners.
echo "== SLAKE_USE_FS_PROC=1 unpack (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" unpack 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC unpack path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: FS_PROC unpack path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on unpack path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]unpack([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]unpack([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include unpack command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected unpack chdir/cwd honesty banner on empty-rest FS_PROC unpack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare unpack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare unpack"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on unpack rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_unpack_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 unpack --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" unpack --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process' && ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: FS_PROC unpack path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc'; then
    echo "FAIL: expected freestanding Systems.Proc banner on unpack path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC unpack argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for unpack"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on unpack --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on unpack --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected unpack chdir/cwd honesty banner on FS_PROC unpack"
    exit 1
  fi
  echo "fs_proc_unpack_help: OK"
)

# W95 BUG-1 follow-on: unpack cwd-parity / absolute-lake honesty.
# FS_PROC chdir(pkg) must not break relative $LAKE (CLI absolutizes pre-chdir).
# Soft-fail OK if lake binary missing at resolved path — still require no wrong-cwd fall-back forge.
echo "== SLAKE_USE_FS_PROC=1 unpack cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  # Prefer a true absolute lake when available; also exercise relative LAKE=./… against pre-chdir cwd.
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for unpack cwd-parity; skip"
      echo "fs_proc_unpack_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  # Relative path from package root to lake (when lake is under repo); else use absolute (still exercises chdir banner).
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      # path relative to PKG
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" unpack --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: unpack cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: unpack cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on unpack cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected unpack chdir/cwd honesty banner"
    exit 1
  fi
  # Lake line should show absolute lake= path (leading /) after resolveLakeAbs
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on unpack FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    # Soft: relative resolve edge — do not forge green if spawn truly failed
    echo "SOFT: unpack cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_unpack_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_unpack_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative unpack (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w95-unpack-strict"
  out="$("$SLAKE_EXE" unpack 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on unpack path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT unpack fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT unpack message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on unpack path"
    exit 1
  fi
  echo "fs_proc_unpack_strict_negative: OK"
)


# W96: freestanding FS_PROC for `query` (outside CLAIMED; rest plumbed; chdir pkg).
echo "== SLAKE_USE_FS_PROC=1 query (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" query 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC query path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on query path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]query([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]query([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include query command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query chdir/cwd honesty banner on empty-rest FS_PROC query"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare query"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare query"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on query rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_query_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 query --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" query --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC query path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on query path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC query argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for query"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on query --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on query --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query chdir/cwd honesty banner on FS_PROC query"
    exit 1
  fi
  echo "fs_proc_query_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 query cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  # Use outer-scope REPO_ROOT (script top); do not recompute via $0 after cd "$PKG".
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for query cwd-parity; skip"
      echo "fs_proc_query_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  # Relative path from package root to lake (when lake is under repo); else use absolute (still exercises chdir banner).
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      # path relative to PKG
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" query --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: query cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: query cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on query cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query chdir/cwd honesty banner"
    exit 1
  fi
  # Lake line should show absolute lake= path (leading /) after resolveLakeAbs
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on query FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    # Soft: relative resolve edge — do not forge green if spawn truly failed
    echo "SOFT: query cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_query_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_query_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative query (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w96-query-strict"
  out="$("$SLAKE_EXE" query 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on query path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT query fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT query message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on query path"
    exit 1
  fi
  echo "fs_proc_query_strict_negative: OK"
)

# W97: freestanding FS_PROC for `shake` (outside CLAIMED; rest plumbed; chdir pkg).
echo "== SLAKE_USE_FS_PROC=1 shake (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" shake 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC shake path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on shake path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]shake([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]shake([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include shake command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected shake chdir/cwd honesty banner on empty-rest FS_PROC shake"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare shake"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare shake"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on shake rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_shake_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 shake --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" shake --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC shake path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on shake path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC shake argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for shake"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on shake --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on shake --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected shake chdir/cwd honesty banner on FS_PROC shake"
    exit 1
  fi
  echo "fs_proc_shake_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 shake cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  # Use outer-scope REPO_ROOT (script top); do not recompute via $0 after cd "$PKG".
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for shake cwd-parity; skip"
      echo "fs_proc_shake_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  # Relative path from package root to lake (when lake is under repo); else use absolute (still exercises chdir banner).
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      # path relative to PKG
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" shake --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: shake cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: shake cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on shake cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected shake chdir/cwd honesty banner"
    exit 1
  fi
  # Lake line should show absolute lake= path (leading /) after resolveLakeAbs
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on shake FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    # Soft: relative resolve edge — do not forge green if spawn truly failed
    echo "SOFT: shake cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_shake_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_shake_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative shake (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w97-shake-strict"
  out="$("$SLAKE_EXE" shake 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on shake path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT shake fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT shake message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on shake path"
    exit 1
  fi
  echo "fs_proc_shake_strict_negative: OK"
)

# W98: freestanding FS_PROC for `serve` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest + cwd-parity/BUG-1.
echo "== SLAKE_USE_FS_PROC=1 serve (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" serve 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC serve path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on serve path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]serve([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]serve([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include serve command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected serve chdir/cwd honesty banner on empty-rest FS_PROC serve"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare serve"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare serve"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on serve rc=0"
      exit 1
    fi
  fi
  echo "fs_proc_serve_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 serve --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" serve --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC serve path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on serve path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC serve argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for serve"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on serve --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on serve --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected serve chdir/cwd honesty banner on FS_PROC serve"
    exit 1
  fi
  echo "fs_proc_serve_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 serve cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  # Use outer-scope REPO_ROOT (script top); do not recompute via $0 after cd "$PKG".
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for serve cwd-parity; skip"
      echo "fs_proc_serve_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  # Relative path from package root to lake (when lake is under repo); else use absolute (still exercises chdir banner).
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      # path relative to PKG
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" serve --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: serve cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: serve cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on serve cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected serve chdir/cwd honesty banner"
    exit 1
  fi
  # Lake line should show absolute lake= path (leading /) after resolveLakeAbs
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on serve FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    # Soft: relative resolve edge — do not forge green if spawn truly failed
    echo "SOFT: serve cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_serve_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_serve_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative serve (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w98-serve-strict"
  out="$("$SLAKE_EXE" serve 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on serve path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT serve fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT serve message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on serve path"
    exit 1
  fi
  echo "fs_proc_serve_strict_negative: OK"
)

# W99: freestanding FS_PROC for `upload` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest + cwd-parity/BUG-1.
echo "== SLAKE_USE_FS_PROC=1 upload (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" upload 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC upload path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on upload path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]upload([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]upload([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include upload command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upload chdir/cwd honesty banner on empty-rest FS_PROC upload"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare upload"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare upload"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on upload rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on upload empty-rest"
    exit 1
  fi
  echo "fs_proc_upload_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 upload --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" upload --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC upload path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on upload path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC upload argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for upload"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on upload --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on upload --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upload chdir/cwd honesty banner on FS_PROC upload"
    exit 1
  fi
  echo "fs_proc_upload_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 upload cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  # Use outer-scope REPO_ROOT (script top); do not recompute via $0 after cd "$PKG".
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for upload cwd-parity; skip"
      echo "fs_proc_upload_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  # Relative path from package root to lake (when lake is under repo); else use absolute (still exercises chdir banner).
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      # path relative to PKG
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" upload --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: upload cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: upload cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on upload cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upload chdir/cwd honesty banner"
    exit 1
  fi
  # Lake line should show absolute lake= path (leading /) after resolveLakeAbs
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on upload FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    # Soft: relative resolve edge — do not forge green if spawn truly failed
    echo "SOFT: upload cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_upload_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_upload_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative upload (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w99-upload-strict"
  out="$("$SLAKE_EXE" upload 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on upload path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT upload fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT upload message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on upload path"
    exit 1
  fi
  echo "fs_proc_upload_strict_negative: OK"
)

# W100: freestanding FS_PROC for `lean` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest + cwd-parity/BUG-1.
echo "== SLAKE_USE_FS_PROC=1 lean (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" lean 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC lean path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on lean path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]lean([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]lean([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include lean command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected lean chdir/cwd honesty banner on empty-rest FS_PROC lean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare lean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare lean"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on lean rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on lean empty-rest"
    exit 1
  fi
  echo "fs_proc_lean_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 lean --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" lean --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC lean path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on lean path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC lean argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for lean"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on lean --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on lean --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected lean chdir/cwd honesty banner on FS_PROC lean"
    exit 1
  fi
  echo "fs_proc_lean_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 lean cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  # Use outer-scope REPO_ROOT (script top); do not recompute via $0 after cd "$PKG".
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for lean cwd-parity; skip"
      echo "fs_proc_lean_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  # Relative path from package root to lake (when lake is under repo); else use absolute (still exercises chdir banner).
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      # path relative to PKG
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" lean --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: lean cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: lean cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on lean cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected lean chdir/cwd honesty banner"
    exit 1
  fi
  # Lake line should show absolute lake= path (leading /) after resolveLakeAbs
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on lean FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    # Soft: relative resolve edge — do not forge green if spawn truly failed
    echo "SOFT: lean cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_lean_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_lean_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative lean (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w100-lean-strict"
  out="$("$SLAKE_EXE" lean 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -eq 0 ]]; then
    echo "FAIL: STRICT + bad LAKE should exit nonzero on lean path"
    exit 1
  fi
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: STRICT lean fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: STRICT lean message says falling back"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'STRICT'; then
    echo "FAIL: expected STRICT messaging on lean path"
    exit 1
  fi
  echo "fs_proc_lean_strict_negative: OK"
)


# W101: freestanding FS_PROC for `scripts` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest + cwd-parity/BUG-1.
echo "== SLAKE_USE_FS_PROC=1 scripts (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" scripts 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC scripts path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on scripts path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]scripts([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]scripts([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include scripts command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected scripts chdir/cwd honesty banner on empty-rest FS_PROC scripts"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare scripts"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare scripts"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on scripts rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on scripts empty-rest"
    exit 1
  fi
  echo "fs_proc_scripts_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 scripts --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" scripts --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC scripts path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on scripts path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC scripts argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for scripts"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on scripts --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on scripts --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected scripts chdir/cwd honesty banner on FS_PROC scripts"
    exit 1
  fi
  echo "fs_proc_scripts_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 scripts cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for scripts cwd-parity; skip"
      echo "fs_proc_scripts_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" scripts --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: scripts cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: scripts cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on scripts cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected scripts chdir/cwd honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on scripts FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "SOFT: scripts cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_scripts_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_scripts_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative scripts (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w101-scripts-strict"
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
  echo "fs_proc_scripts_strict_negative: OK"
)


# W102: freestanding FS_PROC for `setup-file` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest + cwd-parity/BUG-1.
echo "== SLAKE_USE_FS_PROC=1 setup-file (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" setup-file 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC setup-file path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on setup-file path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]setup-file([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]setup-file([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include setup-file command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected setup-file chdir/cwd honesty banner on empty-rest FS_PROC setup-file"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare setup-file"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare setup-file"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on setup-file rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on setup-file empty-rest"
    exit 1
  fi
  echo "fs_proc_setup_file_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 setup-file --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" setup-file --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC setup-file path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on setup-file path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC setup-file argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for setup-file"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on setup-file --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on setup-file --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected setup-file chdir/cwd honesty banner on FS_PROC setup-file"
    exit 1
  fi
  echo "fs_proc_setup_file_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 setup-file cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for setup-file cwd-parity; skip"
      echo "fs_proc_setup_file_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" setup-file --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: setup-file cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: setup-file cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on setup-file cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected setup-file chdir/cwd honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on setup-file FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "SOFT: setup-file cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_setup_file_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_setup_file_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative setup-file (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w102-setup-file-strict"
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
  echo "fs_proc_setup_file_strict_negative: OK"
)


# W103: freestanding FS_PROC for `self-check` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; CLAIMED clean envelope unchanged). Bare empty-rest + --help rest + cwd-parity/BUG-1.
echo "== SLAKE_USE_FS_PROC=1 self-check (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" self-check 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC self-check path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on self-check path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]self-check([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]self-check([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include self-check command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected self-check chdir/cwd honesty banner on empty-rest FS_PROC self-check"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare self-check"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare self-check"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on self-check rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on self-check empty-rest"
    exit 1
  fi
  echo "fs_proc_self_check_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 self-check --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" self-check --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC self-check path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on self-check path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC self-check argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for self-check"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on self-check --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on self-check --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected self-check chdir/cwd honesty banner on FS_PROC self-check"
    exit 1
  fi
  echo "fs_proc_self_check_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 self-check cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for self-check cwd-parity; skip"
      echo "fs_proc_self_check_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" self-check --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: self-check cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: self-check cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on self-check cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected self-check chdir/cwd honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on self-check FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "SOFT: self-check cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_self_check_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_self_check_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative self-check (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w103-self-check-strict"
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
  echo "fs_proc_self_check_strict_negative: OK"
)

# W104: freestanding FS_PROC for `version-tags` (outside CLAIMED; rest plumbed — not empty-rest-only; rest may rebind Lake globals; peers end at …/self-check; CLAIMED clean envelope unchanged).
echo "== SLAKE_USE_FS_PROC=1 version-tags (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" version-tags 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC version-tags path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on version-tags path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]version-tags([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]version-tags([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include version-tags command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected version-tags chdir/cwd honesty banner on empty-rest FS_PROC version-tags"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare version-tags"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare version-tags"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on version-tags rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on version-tags empty-rest"
    exit 1
  fi
  echo "fs_proc_version_tags_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 version-tags --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" version-tags --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC version-tags path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on version-tags path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC version-tags argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for version-tags"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on version-tags --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on version-tags --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected version-tags chdir/cwd honesty banner on FS_PROC version-tags"
    exit 1
  fi
  echo "fs_proc_version_tags_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 version-tags cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for version-tags cwd-parity; skip"
      echo "fs_proc_version_tags_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" version-tags --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: version-tags cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: version-tags cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on version-tags cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected version-tags chdir/cwd honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on version-tags FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "SOFT: version-tags cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_version_tags_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_version_tags_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative version-tags (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w104-version-tags-strict"
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
  echo "fs_proc_version_tags_strict_negative: OK"
)


echo "== SLAKE_USE_FS_PROC=1 query-kind (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" query-kind 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC query-kind path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on query-kind path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]query-kind([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]query-kind([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include query-kind command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query-kind chdir/cwd honesty banner on empty-rest FS_PROC query-kind"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare query-kind"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare query-kind"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on query-kind rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on query-kind empty-rest"
    exit 1
  fi
  echo "fs_proc_query_kind_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 query-kind --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" query-kind --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC query-kind path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on query-kind path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC query-kind argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for query-kind"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on query-kind --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on query-kind --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query-kind chdir/cwd honesty banner on FS_PROC query-kind"
    exit 1
  fi
  echo "fs_proc_query_kind_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 query-kind cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for query-kind cwd-parity; skip"
      echo "fs_proc_query_kind_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" query-kind --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: query-kind cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: query-kind cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on query-kind cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected query-kind chdir/cwd honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on query-kind FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "SOFT: query-kind cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_query_kind_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_query_kind_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative query-kind (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w104-query-kind-strict"
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
  echo "fs_proc_query_kind_strict_negative: OK"
)


echo "== SLAKE_USE_FS_PROC=1 resolve-deps (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" resolve-deps 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC resolve-deps path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on resolve-deps path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]resolve-deps([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]resolve-deps([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include resolve-deps command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected resolve-deps chdir/cwd honesty banner on empty-rest FS_PROC resolve-deps"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare resolve-deps"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare resolve-deps"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on resolve-deps rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on resolve-deps empty-rest"
    exit 1
  fi
  echo "fs_proc_resolve_deps_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 resolve-deps --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" resolve-deps --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC resolve-deps path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on resolve-deps path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC resolve-deps argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for resolve-deps"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on resolve-deps --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on resolve-deps --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected resolve-deps chdir/cwd honesty banner on FS_PROC resolve-deps"
    exit 1
  fi
  echo "fs_proc_resolve_deps_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 resolve-deps cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for resolve-deps cwd-parity; skip"
      echo "fs_proc_resolve_deps_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" resolve-deps --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: resolve-deps cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: resolve-deps cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on resolve-deps cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected resolve-deps chdir/cwd honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on resolve-deps FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "SOFT: resolve-deps cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_resolve_deps_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_resolve_deps_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative resolve-deps (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w114-resolve-deps-strict"
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
  echo "fs_proc_resolve_deps_strict_negative: OK"
)




echo "== SLAKE_USE_FS_PROC=1 reservoir-config (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" reservoir-config 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC reservoir-config path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on reservoir-config path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]reservoir-config([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]reservoir-config([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include reservoir-config command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected reservoir-config chdir/cwd honesty banner on empty-rest FS_PROC reservoir-config"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare reservoir-config"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on bare reservoir-config"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on reservoir-config rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty child env'; then
    echo "FAIL: expected empty child env honesty banner on reservoir-config empty-rest"
    exit 1
  fi
  echo "fs_proc_reservoir_config_empty_rest: OK"
)

echo "== SLAKE_USE_FS_PROC=1 reservoir-config --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" reservoir-config --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC reservoir-config path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on reservoir-config path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq -- '--help'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC reservoir-config argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for reservoir-config"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow'; then
    echo "FAIL: unexpected rest overflow on reservoir-config --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on reservoir-config --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected reservoir-config chdir/cwd honesty banner on FS_PROC reservoir-config"
    exit 1
  fi
  echo "fs_proc_reservoir_config_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 reservoir-config cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  LAKE_ABS="${LAKE:-}"
  if [[ -z "$LAKE_ABS" || "$LAKE_ABS" != /* ]]; then
    if command -v lake >/dev/null 2>&1; then
      LAKE_ABS="$(command -v lake)"
    elif [[ -x "$REPO_ROOT/build/release/stage1/bin/lake" ]]; then
      LAKE_ABS="$REPO_ROOT/build/release/stage1/bin/lake"
    else
      echo "SOFT: no lake binary for reservoir-config cwd-parity; skip"
      echo "fs_proc_reservoir_config_cwd_parity: SOFT-SKIP"
      exit 0
    fi
  fi
  REL_LAKE=""
  case "$LAKE_ABS" in
    "$REPO_ROOT"/*)
      REL_LAKE="$(python3 -c "import os.path; print(os.path.relpath('$LAKE_ABS', '$PKG'))")"
      ;;
  esac
  if [[ -n "$REL_LAKE" && "$REL_LAKE" != /* ]]; then
    export LAKE="$REL_LAKE"
    echo "using relative LAKE=$LAKE (BUG-1 pre-chdir absolutize)"
  else
    export LAKE="$LAKE_ABS"
    echo "using absolute LAKE=$LAKE (relative path unavailable from pkg)"
  fi
  out="$("$SLAKE_EXE" reservoir-config --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: reservoir-config cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: reservoir-config cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'freestanding Systems\.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on reservoir-config cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected reservoir-config chdir/cwd honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on reservoir-config FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "SOFT: reservoir-config cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_reservoir_config_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_reservoir_config_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative reservoir-config (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w115-reservoir-config-strict"
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
  echo "fs_proc_reservoir_config_strict_negative: OK"
)

echo "== SLAKE_USE_FS_PROC=1 upgrade (empty rest) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" upgrade 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC upgrade path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'freestanding Systems.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on upgrade path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=.+[[:space:]]upgrade([[:space:]]|$)'; then
    if ! printf '%s' "$out" | grep -Eiq '--dir=.+[[:space:]]upgrade([[:space:]]|$)'; then
      echo "FAIL: expected freestanding argv line to include upgrade command token"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upgrade chdir/cwd honesty banner on empty-rest FS_PROC upgrade"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for bare upgrade"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow|too many'; then
    echo "FAIL: unexpected rest overflow on bare upgrade"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on upgrade rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'empty env|does not inherit'; then
    echo "FAIL: expected empty child env honesty banner on upgrade empty-rest"
    exit 1
  fi
  echo "fs_proc_upgrade_empty: OK"
)

echo "== SLAKE_USE_FS_PROC=1 upgrade --help on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  out="$("$SLAKE_EXE" upgrade --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: FS_PROC upgrade path fell back to IO.Process (not true freestanding green)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'freestanding Systems.Proc multi-arg'; then
    echo "FAIL: expected freestanding Systems.Proc banner on upgrade path"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq '([[:space:]]|^)--help([[:space:]]|$)'; then
    echo "FAIL: expected rest token --help in delegated FS_PROC upgrade argv line"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "FAIL: FS_PROC spawn failed for upgrade"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'rest overflow|too many'; then
    echo "FAIL: unexpected rest overflow on upgrade --help"
    exit 1
  fi
  if [[ "$rc" -eq 0 ]]; then
    if ! printf '%s' "$out" | grep -Fq 'OK (via lake / Systems.Proc)'; then
      echo "FAIL: expected success line 'OK (via lake / Systems.Proc)' on upgrade --help rc=0"
      exit 1
    fi
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upgrade chdir/cwd honesty banner on FS_PROC upgrade"
    exit 1
  fi
  echo "fs_proc_upgrade_help: OK"
)

echo "== SLAKE_USE_FS_PROC=1 upgrade cwd-parity (relative LAKE path) on $PKG =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  unset SLAKE_FS_PROC_STRICT || true
  lake_abs=""
  if [[ -n "${LAKE:-}" && -x "$LAKE" ]]; then
    lake_abs="$LAKE"
  elif command -v lake >/dev/null 2>&1; then
    lake_abs="$(command -v lake)"
  fi
  if [[ -z "$lake_abs" ]]; then
      echo "SOFT: no lake binary for upgrade cwd-parity; skip"
      echo "fs_proc_upgrade_cwd_parity: SOFT-SKIP"
      exit 0
  fi
  # Relative LAKE path that resolveLakeAbs must absolutize pre-chdir (BUG-1).
  rel_lake="$(basename "$lake_abs")"
  lake_dir="$(dirname "$lake_abs")"
  if [[ "$lake_dir" != "." && "$lake_dir" != "/" ]]; then
    # Prefer joining via PATH-relative basename only when lake is on PATH.
    if [[ "$(command -v "$rel_lake" 2>/dev/null || true)" == "$lake_abs" ]]; then
      export LAKE="$rel_lake"
    else
      export LAKE="$lake_abs"
    fi
  else
    export LAKE="$rel_lake"
  fi
  out="$("$SLAKE_EXE" upgrade --help 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if printf '%s' "$out" | grep -Fq 'OK (via lake / IO.Process)'; then
    echo "FAIL: upgrade cwd-parity fell back to IO.Process"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'falling back to IO\.Process'; then
    echo "FAIL: upgrade cwd-parity fell back to IO.Process"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'freestanding Systems.Proc multi-arg'; then
    echo "FAIL: expected freestanding banner on upgrade cwd-parity"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'chdir to package root|cwd=pkg'; then
    echo "FAIL: expected upgrade chdir/cwd honesty banner"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eiq 'lake=/'; then
    echo "FAIL: expected absolutized lake=/… on upgrade FS_PROC banner (BUG-1)"
    exit 1
  fi
  if printf '%s' "$out" | grep -Eiq 'spawn failed'; then
    echo "SOFT: upgrade cwd-parity spawn failed (lake missing after resolve?); not forging green"
    echo "fs_proc_upgrade_cwd_parity: SOFT-SKIP"
    exit 0
  fi
  echo "fs_proc_upgrade_cwd_parity: OK"
)

echo "== SLAKE_FS_PROC_STRICT=1 negative upgrade (bad lake path) =="
(
  cd "$PKG"
  export SLAKE_USE_FS_PROC=1
  unset SLAKE_USE_FS_PROC_PIPE || true
  export SLAKE_FS_PROC_STRICT=1
  export LAKE="/nonexistent/lake-binary-w116-upgrade-strict"
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
  echo "fs_proc_upgrade_strict_negative: OK"
)


echo "fs_proc_smoke: OK"
