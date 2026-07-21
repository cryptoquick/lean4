#!/usr/bin/env bash
# Smoke: A18 multi-line roots / defaultTargets array parse.
#
# Package has no defaultTargets and no package-level srcDir. Plan modules come
# from multi-line [[lean_lib]] roots under srcDir = "lib". Beta imports Alpha →
# plan `multiline_roots_shaped Alpha Beta` (import-scan), matching single-line
# A16 roots_shaped golden behavior.
#
# Soft-SKIP if slake binary missing. Hard-fail when binary present and claim fails.
# SCORE / systems-validate do **not** run this smoke.
#
#   SLAKE_MULTILINE_ROOTS_PLAN_SMOKE_STRICT=1 ./tests/slake/multiline_roots_plan_smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/multiline_roots_shaped"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"

strict_fail() {
  if [[ "${SLAKE_MULTILINE_ROOTS_PLAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_ROOTS_PLAN_SMOKE_STRICT:-}" == "1" || "${SLAKE_DEPGRAPH_SMOKE_STRICT:-}" == "1" ]]; then
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

assert_ml_roots_plan() {
  local out="$1"
  local plan
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if [[ -z "$plan" ]]; then
    echo "FAIL: missing 'slake depgraph plan:' line"
    return 1
  fi
  # Must not plan only the lib name Lib (pre-A16 leanLibNames fallback / empty roots).
  if printf '%s' "$plan" | grep -Eq 'slake depgraph plan: multiline_roots_shaped Lib( |$)'; then
    echo "FAIL: plan is lean_lib name only (Lib); expected multi-line roots Alpha Beta"
    echo "  got: $plan"
    return 1
  fi
  # Golden: package name + Alpha then Beta (import-scan; Beta imports Alpha).
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: multiline_roots_shaped Alpha Beta( |$)'; then
    echo "FAIL: expected plan 'multiline_roots_shaped Alpha Beta'"
    echo "  got: $plan"
    return 1
  fi
  local alpha_pos beta_pos
  alpha_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Alpha$' | head -n1 | cut -d: -f1 || true)"
  beta_pos="$(printf '%s' "$plan" | tr ' ' '\n' | grep -n '^Beta$' | head -n1 | cut -d: -f1 || true)"
  if [[ -z "$alpha_pos" || -z "$beta_pos" ]]; then
    echo "FAIL: plan must include both Alpha and Beta"
    echo "  got: $plan"
    return 1
  fi
  if ! [[ "$alpha_pos" -lt "$beta_pos" ]]; then
    echo "FAIL: expected Alpha before Beta in import-scan plan"
    echo "  got: $plan"
    return 1
  fi
  return 0
}

if [[ ! -f "$PKG/lakefile.toml" || ! -f "$PKG/lib/Alpha.lean" || ! -f "$PKG/lib/Beta.lean" ]]; then
  echo "FAIL: missing multiline_roots_shaped package at $PKG"
  exit 1
fi

# Fixture must use a multi-line roots array (opening `[` not closed on same line).
if ! awk '
  BEGIN { in_roots=0 }
  /^[[:space:]]*roots[[:space:]]*=/ {
    line=$0
    sub(/^[[:space:]]*roots[[:space:]]*=[[:space:]]*/, "", line)
    if (line ~ /^\[/ && line !~ /\]/) { in_roots=1; next }
    if (line ~ /^\[/ && line ~ /\]/) { single=1 }
  }
  in_roots && /\]/ { multi=1 }
  END { exit (multi ? 0 : 1) }
' "$PKG/lakefile.toml"; then
  echo "FAIL: lakefile.toml must use multi-line roots = [ … ] (not single-line)"
  exit 1
fi

# Package-level keys only appear before the first table header (`[`).
pkg_level="$(awk 'BEGIN{p=1} /^[[:space:]]*\[/{p=0} p' "$PKG/lakefile.toml")"
if printf '%s\n' "$pkg_level" | grep -Eq '^[[:space:]]*srcDir[[:space:]]*='; then
  echo "FAIL: package-level srcDir must be absent (per-lib srcDir dogfood)"
  exit 1
fi

if printf '%s\n' "$pkg_level" | grep -Eq '^[[:space:]]*defaultTargets[[:space:]]*='; then
  echo "FAIL: defaultTargets must be absent (multi-line roots plan dogfood)"
  exit 1
fi

if ! grep -Eq '^import Alpha[[:space:]]*$' "$PKG/lib/Beta.lean"; then
  echo "FAIL: lib/Beta.lean must import Alpha for this smoke"
  exit 1
fi

if [[ -f "$PKG/Alpha.lean" || -f "$PKG/Beta.lean" || -f "$PKG/Lib.lean" ]]; then
  echo "FAIL: package-root Alpha/Beta/Lib modules must not exist (per-lib srcDir dogfood)"
  exit 1
fi

if ! SLAKE_EXE="$(resolve_slake)"; then
  strict_fail "slake binary not found (build tests/slake/driver)"
fi

echo "== A18 multi-line roots: SLAKE_PLAN_ONLY=1 on multiline_roots_shaped =="
(
  cd "$PKG"
  rm -rf .lake .slake-native 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: PLAN_ONLY exited $rc"
    exit 1
  fi
  assert_ml_roots_plan "$out"
  if ! printf '%s' "$out" | grep -Eqi 'import-scan|import edge'; then
    echo "FAIL: expected import-scan honesty banner when Beta imports Alpha under multi-line roots"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Eqi 'per-lib roots/srcDir|per-lib-roots/srcDir'; then
    echo "FAIL: expected per-lib roots/srcDir honesty in plan banner or identity"
    exit 1
  fi
  if [[ -d .lake/build ]]; then
    echo "FAIL: PLAN_ONLY must not create .lake/build"
    exit 1
  fi
)

echo "== A18 multi-line roots: env identity reports per-lib marker =="
(
  cd "$PKG"
  env_out="$("$SLAKE_EXE" env 2>&1)" || true
  printf '%s\n' "$env_out"
  if ! grep -Fq 'per-lib-roots/srcDir' <<<"$env_out"; then
    echo "FAIL: env identity must include per-lib-roots/srcDir for multiline_roots_shaped"
    exit 1
  fi
  if grep -Eq 'srcDir=lib' <<<"$env_out"; then
    echo "FAIL: env must not print package-level srcDir=lib (per-lib only)"
    exit 1
  fi
)

echo "== A18 multi-line defaultTargets band (systems_shaped-like) =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-ml-targets.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp"
  cat >"$tmp/Core.lean" <<'EOF'
module
namespace Core
def marker : String := "ml_targets_core"
end Core
EOF
  cat >"$tmp/Host.lean" <<'EOF'
module
import Core
namespace Host
def marker : String := "ml_targets_host"
end Host
EOF
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "ml_targets_shaped"
# Multi-line defaultTargets (A18) — Host first in declaration, Core first after import-scan.

defaultTargets = [
  "Host",
  "Core",
]

[[lean_lib]]
name = "Lib"
EOF
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  unset SLAKE_NATIVE_OLEAN || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: ml_targets_shaped PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: ml_targets_shaped Core Host( |$)'; then
    echo "FAIL: expected multi-line defaultTargets plan 'ml_targets_shaped Core Host'"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'defaultTargets=2'; then
    echo "FAIL: expected defaultTargets=2 from multi-line array"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A18 negative: unclosed multi-line roots → soft empty (lib name fallback) =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-ml-unclosed.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp"
  cat >"$tmp/Lib.lean" <<'EOF'
module
namespace Lib
def marker : String := "unclosed_lib"
end Lib
EOF
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "ml_unclosed"
# Unclosed multi-line roots — fail-closed empty roots; plan falls back to lib name.

[[lean_lib]]
name = "Lib"
roots = [
  "Alpha",
  "Beta",
EOF
  # deliberately no closing ]
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: unclosed roots must stay fail-closed soft (exit 0)"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  # Empty roots → lean_lib name Lib (A16 fallback); must not list Alpha/Beta.
  if printf '%s' "$plan" | grep -Eq '\bAlpha\b|\bBeta\b'; then
    echo "FAIL: unclosed multi-line roots must not yield Alpha/Beta plan nodes"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: ml_unclosed Lib( |$)'; then
    echo "FAIL: expected lib-name fallback plan 'ml_unclosed Lib' on unclosed roots"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A18 negative: path-escape root labels filtered (isSafeModName) =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-ml-escape-roots.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp/lib"
  cat >"$tmp/lib/Alpha.lean" <<'EOF'
module
namespace Alpha
def marker : String := "escape_root_alpha"
end Alpha
EOF
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "ml_escape_roots"
# Multi-line roots with unsafe path-escape labels filtered; only Alpha remains.

[[lean_lib]]
name = "Lib"
srcDir = "lib"
roots = [
  "../Evil",
  "Alpha",
  "/abs/Bad",
]
EOF
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: escape roots PLAN_ONLY exited $rc (must stay fail-closed soft)"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if printf '%s' "$plan" | grep -Eq 'Evil|/abs|Bad|\.\.'; then
    echo "FAIL: unsafe root labels must be filtered from plan"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: ml_escape_roots Alpha( |$)'; then
    echo "FAIL: expected plan with only safe root Alpha"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A18 negative: mid-array [[lean_lib]] header → unclosed roots (not silent close) =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-ml-midhdr.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp"
  # Lib.lean so first lib name fallback is readable if plan uses it; Other.lean for second.
  cat >"$tmp/Lib.lean" <<'EOF'
module
namespace Lib
def marker : String := "midhdr_lib"
end Lib
EOF
  cat >"$tmp/Other.lean" <<'EOF'
module
namespace Other
def marker : String := "midhdr_other"
end Other
EOF
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "ml_midhdr"
# Unclosed multi-line roots interrupted by next [[lean_lib]] (no closing ] line).
# Fail-closed: roots empty (not Alpha/Beta), second lib header must still be seen.

[[lean_lib]]
name = "Lib"
roots = [
  "Alpha",
  "Beta",
[[lean_lib]]
name = "Other"
EOF
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: mid-array header roots must stay fail-closed soft (exit 0)"
    exit 1
  fi
  # Identity must see both lean_lib tables (header not consumed as array close).
  if ! printf '%s' "$out" | grep -Fq 'lean_lib=2'; then
    echo "FAIL: mid-array [[lean_lib]] must still be scanned (expected lean_lib=2)"
    echo "  (bug: header treated as array close would drop second lib)"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  # Partial roots must not be accepted; no defaultTargets → plan from lib names.
  if printf '%s' "$plan" | grep -Eq '\bAlpha\b|\bBeta\b'; then
    echo "FAIL: mid-array header must not silently accept partial multi-line roots Alpha/Beta"
    echo "  got: $plan"
    exit 1
  fi
  # Both lib names should appear in plan (declaration order when no import edges).
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: ml_midhdr Lib Other( |$)'; then
    echo "FAIL: expected plan 'ml_midhdr Lib Other' (empty roots → lib names; second lib kept)"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A18 negative: mid-array header after multi-line defaultTargets → empty targets =="
(
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/slake-ml-midhdr-dt.XXXXXX")"
  cleanup() { rm -rf "$tmp"; }
  trap cleanup EXIT
  mkdir -p "$tmp"
  cat >"$tmp/Lib.lean" <<'EOF'
module
namespace Lib
def marker : String := "midhdr_dt_lib"
end Lib
EOF
  cat >"$tmp/lakefile.toml" <<'EOF'
name = "ml_midhdr_dt"
# Unclosed multi-line defaultTargets interrupted by [[lean_lib]] — empty targets,
# plan falls back to lean_lib name; lean_lib header must not be dropped.

defaultTargets = [
  "Host",
  "Core",
[[lean_lib]]
name = "Lib"
EOF
  cd "$tmp"
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: mid-array defaultTargets header must stay fail-closed soft (exit 0)"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'defaultTargets=0'; then
    echo "FAIL: unclosed multi-line defaultTargets interrupted by header must yield count 0"
    exit 1
  fi
  if ! printf '%s' "$out" | grep -Fq 'lean_lib=1'; then
    echo "FAIL: [[lean_lib]] after unclosed defaultTargets must still be scanned"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if printf '%s' "$plan" | grep -Eq '\bHost\b|\bCore\b'; then
    echo "FAIL: mid-array header must not accept partial multi-line defaultTargets Host/Core"
    echo "  got: $plan"
    exit 1
  fi
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: ml_midhdr_dt Lib( |$)'; then
    echo "FAIL: expected plan 'ml_midhdr_dt Lib' after empty defaultTargets + lib name"
    echo "  got: $plan"
    exit 1
  fi
  trap - EXIT
  cleanup
)

echo "== A18 regression: single-line roots_shaped still green =="
(
  RS="$ROOT/roots_shaped"
  if [[ ! -f "$RS/lakefile.toml" ]]; then
    echo "FAIL: roots_shaped missing"
    exit 1
  fi
  cd "$RS"
  rm -rf .lake 2>/dev/null || true
  export SLAKE_PLAN_ONLY=1
  unset SLAKE_DEPGRAPH || true
  out="$("$SLAKE_EXE" build 2>&1)" || rc=$?
  rc="${rc:-0}"
  printf '%s\n' "$out"
  if [[ "$rc" -ne 0 ]]; then
    echo "FAIL: roots_shaped PLAN_ONLY exited $rc"
    exit 1
  fi
  plan="$(printf '%s\n' "$out" | grep -F 'slake depgraph plan:' | head -n1 || true)"
  if ! printf '%s' "$plan" | grep -Eq 'slake depgraph plan: roots_shaped Alpha Beta( |$)'; then
    echo "FAIL: single-line roots_shaped regression (expected roots_shaped Alpha Beta)"
    echo "  got: $plan"
    exit 1
  fi
)

echo "multiline_roots_plan_smoke: OK"
