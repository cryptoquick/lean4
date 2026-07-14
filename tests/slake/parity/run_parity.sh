#!/usr/bin/env bash
# Lake ↔ Slake parity sketch for claimed MVP commands.
# Until a slake executable is resolvable, slake steps SKIP (exit 0) after lake succeeds.
# A present slake that only emits MVP stub text does **not** claim full parity OK.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/basic_toml"
CLAIMED=(build clean env)

# W85: remaining-argv plumbing smoke (soft SKIP if no lake; always-on when lake present).
# Outside CLAIMED — verifies classic-host forwards pass extra tokens to lake.
argv_forward_smoke() {
  local out
  if ! command -v lake >/dev/null 2>&1 && [[ -z "${LAKE:-}" ]]; then
    echo "SKIP: argv-forward smoke (no lake on PATH; set LAKE= to enable)"
    return 0
  fi
  out="$("$SLAKE_EXE" build --help 2>&1)" || true
  if ! printf '%s' "$out" | grep -Fq 'delegating to `lake build --help`'; then
    echo "FAIL: slake build --help did not show argv-forward banner"
    printf '%s\n' "$out"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'USAGE:|Build targets|lake build'; then
    echo "FAIL: slake build --help did not look like lake help output"
    printf '%s\n' "$out"
    exit 1
  fi
  out="$("$SLAKE_EXE" exe --help 2>&1)" || true
  if ! printf '%s' "$out" | grep -Fq 'delegating to `lake exe --help`'; then
    echo "FAIL: slake exe --help did not show argv-forward banner"
    printf '%s\n' "$out"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'USAGE:|exe-target|ALIAS: lake exec|lake exe'; then
    echo "FAIL: slake exe --help did not look like lake help output"
    printf '%s\n' "$out"
    exit 1
  fi
  out="$("$SLAKE_EXE" run --help 2>&1)" || true
  if ! printf '%s' "$out" | grep -Fq 'delegating to `lake run --help`'; then
    echo "FAIL: slake run --help did not show argv-forward banner"
    printf '%s\n' "$out"
    exit 1
  fi
  echo "OK: argv-forward smoke (build/exe/run --help plumbed to lake)"
}

REPO_ROOT="$(cd "$ROOT/../../.." && pwd)"

resolve_slake() {
  if [[ -n "${SLAKE_BIN:-}" && -x "${SLAKE_BIN}" ]]; then
    echo "$SLAKE_BIN"
    return 0
  fi
  if command -v slake >/dev/null 2>&1; then
    command -v slake
    return 0
  fi
  # stage1 install path (future), driver build product, or local drop-in
  local cand
  for cand in \
    "$REPO_ROOT/build/release/stage1/bin/slake" \
    "$REPO_ROOT/build/stage1/bin/slake" \
    "$REPO_ROOT/tests/slake/driver/.lake/build/bin/slake" \
    "$ROOT/../driver/.lake/build/bin/slake" \
    "$ROOT/slake"
  do
    if [[ -x "$cand" ]]; then
      echo "$cand"
      return 0
    fi
  done
  return 1
}

# True if stdout/stderr looks like Phase-2 classic stub (not a real build driver).
is_stub_output() {
  local text="$1"
  printf '%s' "$text" | grep -Eiq \
    'MVP stub|not wired|skeleton; not Lake parity|stub — not wired|stub dispatch|Phase 2\+ driver'
}

if ! command -v lake >/dev/null 2>&1; then
  echo "SKIP: lake not on PATH (parity needs classic lake as reference)"
  exit 0
fi

echo "== lake parity reference on $PKG =="
(
  cd "$PKG"
  # clean first so build is meaningful when artifacts exist
  lake clean || true
  lake build
  lake clean
)

SLAKE_EXE=""
if SLAKE_EXE="$(resolve_slake)"; then
  echo "== slake parity on $PKG (exe=$SLAKE_EXE) =="
  (
    cd "$PKG"
    out_env="$("$SLAKE_EXE" env 2>&1)"
    rc_env=$?
    if [[ "$rc_env" -ne 0 ]]; then
      echo "FAIL: slake env exited $rc_env"
      printf '%s\n' "$out_env"
      exit 1
    fi
    # Package walk-up must resolve *this* package, not monorepo tests/
    if ! printf '%s' "$out_env" | grep -Fq "package: $PKG"; then
      echo "FAIL: slake env package path does not match $PKG"
      printf '%s\n' "$out_env"
      exit 1
    fi
    # Host TOML identity (Slake.Config) — strengthens CLAIMED env
    if ! printf '%s' "$out_env" | grep -Fq 'name=basic_toml'; then
      echo "FAIL: slake env missing package name identity (name=basic_toml)"
      printf '%s\n' "$out_env"
      exit 1
    fi
    if ! printf '%s' "$out_env" | grep -Fq 'defaultTargets=1'; then
      echo "FAIL: slake env missing defaultTargets count (defaultTargets=1)"
      printf '%s\n' "$out_env"
      exit 1
    fi
    if ! printf '%s' "$out_env" | grep -Fq 'lean_lib=1'; then
      echo "FAIL: slake env missing lean_lib count (lean_lib=1)"
      printf '%s\n' "$out_env"
      exit 1
    fi

    out_clean="$("$SLAKE_EXE" clean 2>&1)"
    rc_clean=$?
    if [[ "$rc_clean" -ne 0 ]]; then
      echo "FAIL: slake clean (pre-build) exited $rc_clean"
      printf '%s\n' "$out_clean"
      exit 1
    fi

    out_build="$("$SLAKE_EXE" build 2>&1)"
    rc_build=$?
    combined="${out_env}
${out_clean}
${out_build}"
    if [[ "$rc_build" -ne 0 ]]; then
      echo "FAIL: slake build exited $rc_build"
      printf '%s\n' "$out_build"
      exit 1
    fi
    if is_stub_output "$combined"; then
      echo "OK: slake stub dispatch only (${CLAIMED[*]}; not Lake parity; no artifact check)"
      echo "     classic host stubs under src/slake/; freestanding cores stay in Systems.*"
      exit 0
    fi
    # Real driver path: require package build artifacts *before* final clean.
    if [[ ! -d .lake/build ]]; then
      echo "FAIL: slake build exit 0 but no .lake/build under $PKG"
      printf '%s\n' "$out_build"
      exit 1
    fi
    out_clean2="$("$SLAKE_EXE" clean 2>&1)"
    rc_clean2=$?
    if [[ "$rc_clean2" -ne 0 ]]; then
      echo "FAIL: slake clean (post-build) exited $rc_clean2"
      printf '%s\n' "$out_clean2"
      exit 1
    fi
    if is_stub_output "$out_clean2"; then
      echo "FAIL: slake clean looked like stub after non-stub build"
      printf '%s\n' "$out_clean2"
      exit 1
    fi
    if [[ -d .lake/build ]]; then
      echo "FAIL: slake clean left .lake/build under $PKG"
      printf '%s\n' "$out_clean2"
      exit 1
    fi

    # Safety: from tests/slake/parity (no local package), must not bind monorepo tests/
    (
      cd "$ROOT"
      w_env="$("$SLAKE_EXE" env 2>&1)"
      if printf '%s' "$w_env" | grep -E 'package: .*/tests$'; then
        echo "FAIL: walk-up from $ROOT bound monorepo tests/"
        printf '%s\n' "$w_env"
        exit 1
      fi
      w_clean_rc=0
      w_clean="$("$SLAKE_EXE" clean 2>&1)" || w_clean_rc=$?
      if printf '%s' "$w_clean" | grep -E 'removed .*/tests/\.lake/build'; then
        echo "FAIL: clean from $ROOT removed monorepo tests/.lake/build"
        printf '%s\n' "$w_clean"
        exit 1
      fi
      # Fail-closed: no plausible package → clean exits non-zero
      if printf '%s' "$w_env" | grep -Fq 'package: (not found'; then
        if [[ "$w_clean_rc" -eq 0 ]]; then
          echo "FAIL: clean from $ROOT exited 0 without package root"
          printf '%s\n' "$w_clean"
          exit 1
        fi
      fi
    ) || exit 1

    # Also from tests/slake
    (
      cd "$ROOT/.."
      w_env="$("$SLAKE_EXE" env 2>&1)"
      if printf '%s' "$w_env" | grep -E 'package: .*/tests$'; then
        echo "FAIL: walk-up from tests/slake bound monorepo tests/"
        printf '%s\n' "$w_env"
        exit 1
      fi
      w_clean_rc=0
      w_clean="$("$SLAKE_EXE" clean 2>&1)" || w_clean_rc=$?
      if printf '%s' "$w_clean" | grep -E 'removed .*/tests/\.lake/build'; then
        echo "FAIL: clean from tests/slake removed monorepo tests/.lake/build"
        printf '%s\n' "$w_clean"
        exit 1
      fi
      if printf '%s' "$w_env" | grep -Fq 'package: (not found'; then
        if [[ "$w_clean_rc" -eq 0 ]]; then
          echo "FAIL: clean from tests/slake exited 0 without package root"
          printf '%s\n' "$w_clean"
          exit 1
        fi
      fi
    ) || exit 1

    # Non-CLAIMED help lock (W84 exec/upgrade + W83 query-kind/resolve-deps/reservoir-config + W82 setup-file/self-check/version-tags + W81 translate-config/run + W80 serve/upload).
    # Does not expand CLAIMED=(build clean env). In-tree driver (tests/slake/driver) hard-fails if
    # W80–W84 tokens missing; external/older SLAKE_EXE soft-WARNs only.
    # Residual (same as W80–W82): help-token lock only — no dedicated package-root dispatch smoke for thin forwards.
    help_out="$("$SLAKE_EXE" --help 2>&1 || true)"
    if printf '%s' "$help_out" | grep -Eq 'serve' \
        && printf '%s' "$help_out" | grep -Eq 'upload' \
        && printf '%s' "$help_out" | grep -Eq 'translate-config' \
        && printf '%s' "$help_out" | grep -Eq '  run         ' \
        && printf '%s' "$help_out" | grep -Eq 'setup-file' \
        && printf '%s' "$help_out" | grep -Eq 'self-check' \
        && printf '%s' "$help_out" | grep -Eq 'version-tags' \
        && printf '%s' "$help_out" | grep -Eq 'query-kind' \
        && printf '%s' "$help_out" | grep -Eq 'resolve-deps' \
        && printf '%s' "$help_out" | grep -Eq 'reservoir-config' \
        && printf '%s' "$help_out" | grep -Eq 'exec' \
        && printf '%s' "$help_out" | grep -Eq 'upgrade'; then
      echo "OK: slake --help lists serve/upload/translate-config/run/setup-file/self-check/version-tags/query-kind/resolve-deps/reservoir-config/exec/upgrade (outside CLAIMED)"
    else
      case "$SLAKE_EXE" in
        */tests/slake/driver/*|*/tests/slake/driver/.lake/*)
          echo "FAIL: in-tree slake --help missing non-CLAIMED W80–W84 tokens" >&2
          exit 1
          ;;
        *)
          echo "WARN: slake --help missing non-CLAIMED W80–W84 tokens (external/older binary; not a parity fail)"
          ;;
      esac
    fi

    echo "OK: lake and slake claimed slice (${CLAIMED[*]}) with build artifacts"
    argv_forward_smoke
    exit 0
  )
  exit $?
fi

echo "SKIP: slake not on PATH (build tests/slake/driver or set SLAKE_BIN)"
echo "      looked for: PATH, \$SLAKE_BIN, stage1 bin/slake, tests/slake/driver/.lake/build/bin/slake, tests/slake/parity/slake"
echo "      driver: cd tests/slake/driver && lake build  # → .lake/build/bin/slake"
echo "      lake claimed slice OK for: ${CLAIMED[*]}"
exit 0
