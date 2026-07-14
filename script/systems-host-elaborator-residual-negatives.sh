#!/usr/bin/env bash
# Negative / positive cases for systems-host-elaborator-residual.sh (G3, fail-closed).
#
# Ensures:
#   * Real stage1 lean (when present) measures HOST_HAS_LEANSHARED=1 → GC_FREE=0
#   * Forged GC_FREE_ELABORATOR=1 with leanshared / classic residual → rejected by checker
#   * Dual residual_ok / dual GC_FREE / dual HOST_HAS → rejected
#   * Missing lean under REQUIRE → non-zero + GC_FREE=0 + residual_ok=0 (no PATH fallback)
#   * FORCE_GC_FREE_ELABORATOR=1 without earned residual → FAIL on **all** exit paths
#   * Non-ELF lean (shell script / empty +x) → unmeasured, never GC_FREE=1
#   * residual_free earn path tokens accepted by checker only with full evidence
#   * FORCE + earned residual_free allowed
#   * Product PRODUCT_GC_FREE is not this gate (no product tokens required)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GATE="$ROOT/script/systems-host-elaborator-residual.sh"
# shellcheck source=systems-host-elaborator-residual.sh
source "$ROOT/script/systems-host-elaborator-residual.sh"
# shellcheck source=systems-tcb-honesty-check.sh
source "$ROOT/script/systems-tcb-honesty-check.sh"
chmod +x "$GATE"

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

# Prefer stage1 when present (positive path). Explicit LEAN in cases must not PATH-fallback.
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
  STAGE1_LEAN="$ROOT/build/release/stage1/bin/lean"
else
  STAGE1_LEAN=""
fi

fail_case() {
  local name="$1"
  shift
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  if [[ $ec -eq 0 ]]; then
    echo "FAIL: expected non-zero for case $name" >&2
    cat "$out" >&2
    exit 1
  fi
  if grep -qx 'GC_FREE_ELABORATOR=1' "$out"; then
    echo "FAIL: case $name emitted GC_FREE_ELABORATOR=1 on failure" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'GC_FREE_ELABORATOR=0' "$out"; then
    echo "FAIL: case $name missing GC_FREE_ELABORATOR=0" >&2
    cat "$out" >&2
    exit 1
  fi
  if grep -qx 'HOST_ELABORATOR_RESIDUAL_OK=1' "$out"; then
    echo "FAIL: case $name printed HOST_ELABORATOR_RESIDUAL_OK=1 on failure" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_ELABORATOR_RESIDUAL_OK=0' "$out"; then
    echo "FAIL: case $name missing HOST_ELABORATOR_RESIDUAL_OK=0" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qE '^FAIL:' "$out"; then
    echo "FAIL: case $name: expected FAIL: line" >&2
    cat "$out" >&2
    exit 1
  fi
  if systems_lean_host_elab_tokens_ok "$out"; then
    echo "FAIL: case $name accepted by systems_lean_host_elab_tokens_ok" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: negative case $name (exit $ec)"
}

pass_case() {
  local name="$1"
  shift
  local out="$tmpdir/$name.out"
  set +e
  "$@" >"$out" 2>&1
  local ec=$?
  set -e
  if [[ $ec -ne 0 ]]; then
    echo "FAIL: expected zero for case $name" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! systems_lean_host_elab_tokens_ok "$out"; then
    echo "FAIL: case $name failed systems_lean_host_elab_tokens_ok" >&2
    cat "$out" >&2
    exit 1
  fi
  # Dual GC tokens forbidden.
  local gc0 gc1
  gc0="$(grep -cx 'GC_FREE_ELABORATOR=0' "$out" || true)"
  gc1="$(grep -cx 'GC_FREE_ELABORATOR=1' "$out" || true)"
  if [[ "$((gc0 + gc1))" -ne 1 ]]; then
    echo "FAIL: case $name dual or missing GC_FREE_ELABORATOR" >&2
    cat "$out" >&2
    exit 1
  fi
  echo "OK: positive case $name"
}

# --- 1) Forged GC_FREE=1 with classic residual / leanshared → residual checker rejects ---
cat >"$tmpdir/forged_gc_with_shared.out" <<'EOF'
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=1
HOST_ELABORATOR_RESIDUAL_OK=1
EOF
if systems_lean_host_elab_tokens_ok "$tmpdir/forged_gc_with_shared.out"; then
  echo "FAIL: forged GC_FREE=1 with HOST_HAS_LEANSHARED=1 accepted" >&2
  exit 1
fi
echo "OK: negative case forged_gc_with_shared (residual checker rejects)"

# --- 1b) Forged GC_FREE=1 without residual_free evidence ---
cat >"$tmpdir/forged_gc_no_evidence.out" <<'EOF'
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=1
HOST_ELABORATOR_RESIDUAL_OK=1
EOF
if systems_lean_host_elab_tokens_ok "$tmpdir/forged_gc_no_evidence.out"; then
  echo "FAIL: forged GC_FREE=1 without residual_free accepted" >&2
  exit 1
fi
echo "OK: negative case forged_gc_no_evidence"

# --- 1c) Honesty checker: GC_FREE=1 with classic TCB rejected ---
cat >"$tmpdir/forged_honesty_classic.out" <<'EOF'
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=1
TCB_HONESTY_OK=1
EOF
if systems_lean_tcb_honesty_tokens_ok "$tmpdir/forged_honesty_classic.out"; then
  echo "FAIL: honesty accepted GC_FREE=1 with classic TCB" >&2
  exit 1
fi
echo "OK: negative case forged_honesty_gc_classic"

# --- 1d) Dual residual_ok ---
cat >"$tmpdir/dual_ok.out" <<'EOF'
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=0
HOST_ELABORATOR_RESIDUAL_OK=1
EOF
if systems_lean_host_elab_tokens_ok "$tmpdir/dual_ok.out"; then
  echo "FAIL: dual residual_ok accepted" >&2
  exit 1
fi
echo "OK: negative case dual_residual_ok"

# --- 2) Missing lean under REQUIRE (must not PATH-fallback to stage1) ---
fail_case missing_lean_require \
  env SYSTEMS_LEAN_HOST_ELAB_REQUIRE=1 \
      SYSTEMS_LEAN_TCB_LEAN="$tmpdir/no-such-lean" \
      SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/no-such-lean" \
      "$GATE"
if ! grep -qE 'lean missing' "$tmpdir/missing_lean_require.out"; then
  echo "FAIL: missing_lean_require did not report lean missing" >&2
  cat "$tmpdir/missing_lean_require.out" >&2
  exit 1
fi
echo "OK: missing_lean_require failed for lean (not PATH fallback)"

# --- 3) FORCE_GC_FREE without earned residual (stage1 classic) ---
if [[ -n "$STAGE1_LEAN" ]]; then
  fail_case force_gc_free_refused \
    env SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 \
        SYSTEMS_LEAN_TCB_LEAN="$STAGE1_LEAN" \
        SYSTEMS_LEAN_HOST_ELAB_LEAN="$STAGE1_LEAN" \
        SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
        "$GATE"
  if ! grep -qE 'FORCE_GC_FREE|refused' "$tmpdir/force_gc_free_refused.out"; then
    echo "FAIL: force_gc_free_refused missing refuse message" >&2
    cat "$tmpdir/force_gc_free_refused.out" >&2
    exit 1
  fi
  echo "OK: FORCE_GC_FREE refused on classic stage1"
fi

# --- 3b) FORCE on advisory early-exit paths (missing lean / non-ELF) — must not exit 0 ---
fail_case force_missing_lean_advisory \
  env SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 \
      SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
      SYSTEMS_LEAN_TCB_LEAN="$tmpdir/no-lean-force-adv" \
      SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/no-lean-force-adv" \
      "$GATE"
if ! grep -qE 'FORCE_GC_FREE|refused' "$tmpdir/force_missing_lean_advisory.out"; then
  echo "FAIL: force_missing_lean_advisory missing refuse message" >&2
  cat "$tmpdir/force_missing_lean_advisory.out" >&2
  exit 1
fi
echo "OK: FORCE refused on advisory missing-lean early exit"

printf '#!/bin/sh\nexit 0\n' >"$tmpdir/fake-shell-lean"
chmod +x "$tmpdir/fake-shell-lean"
fail_case force_non_elf_advisory \
  env SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 \
      SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
      SYSTEMS_LEAN_TCB_LEAN="$tmpdir/fake-shell-lean" \
      SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/fake-shell-lean" \
      "$GATE"
echo "OK: FORCE refused on advisory non-ELF early exit"

# --- 4) Positive: stage1 lean measures classic residual (G3 staged PASS) ---
if [[ -n "$STAGE1_LEAN" ]]; then
  pass_case stage1_classic_residual \
    env SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
        SYSTEMS_LEAN_TCB_LEAN="$STAGE1_LEAN" \
        SYSTEMS_LEAN_HOST_ELAB_LEAN="$STAGE1_LEAN" \
        "$GATE"
  if ! grep -qx 'HOST_HAS_LEANSHARED=1' "$tmpdir/stage1_classic_residual.out"; then
    echo "FAIL: stage1 expected HOST_HAS_LEANSHARED=1" >&2
    cat "$tmpdir/stage1_classic_residual.out" >&2
    exit 1
  fi
  if ! grep -qx 'GC_FREE_ELABORATOR=0' "$tmpdir/stage1_classic_residual.out"; then
    echo "FAIL: stage1 expected GC_FREE_ELABORATOR=0" >&2
    cat "$tmpdir/stage1_classic_residual.out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime' "$tmpdir/stage1_classic_residual.out"; then
    echo "FAIL: stage1 expected classic residual class" >&2
    cat "$tmpdir/stage1_classic_residual.out" >&2
    exit 1
  fi
  echo "OK: stage1 measures classic residual + GC_FREE_ELABORATOR=0"
else
  echo "OK: skip stage1_classic_residual (no stage1 lean)"
fi

# --- 5) Clean residual_free earn fixture accepted by residual + honesty checkers ---
cat >"$tmpdir/earn_residual_free.out" <<'EOF'
HOST_HAS_LEANSHARED=0
HOST_ELABORATOR_RESIDUAL=residual_free
HOST_ELABORATOR_TCB=residual_free
GC_FREE_ELABORATOR=1
HOST_ELABORATOR_RESIDUAL_OK=1
EOF
if ! systems_lean_host_elab_tokens_ok "$tmpdir/earn_residual_free.out"; then
  echo "FAIL: residual_free earn fixture rejected by residual checker" >&2
  exit 1
fi
echo "OK: residual_free earn fixture accepted by residual checker"

cat >"$tmpdir/earn_honesty.out" <<'EOF'
HOST_ELABORATOR_TCB=residual_free
HOST_ELABORATOR_RESIDUAL=residual_free
HOST_HAS_LEANSHARED=0
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=1
TCB_HONESTY_OK=1
EOF
if ! systems_lean_tcb_honesty_tokens_ok "$tmpdir/earn_honesty.out"; then
  echo "FAIL: residual_free honesty earn fixture rejected" >&2
  exit 1
fi
echo "OK: residual_free honesty earn fixture accepted"

# --- 6) Classic honesty still accepted ---
cat >"$tmpdir/classic_honesty.out" <<'EOF'
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=0
TCB_HONESTY_OK=1
EOF
if ! systems_lean_tcb_honesty_tokens_ok "$tmpdir/classic_honesty.out"; then
  echo "FAIL: classic honesty fixture rejected" >&2
  exit 1
fi
echo "OK: classic honesty fixture accepted"

# --- 7) Advisory missing lean: exit 0, GC_FREE=0, residual_ok=0 (not residual_tokens_ok) ---
set +e
env SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
    SYSTEMS_LEAN_TCB_LEAN="$tmpdir/no-lean-adv" \
    SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/no-lean-adv" \
    "$GATE" >"$tmpdir/advisory_missing.out" 2>&1
adv_ec=$?
set -e
if [[ $adv_ec -ne 0 ]]; then
  echo "FAIL: advisory missing lean expected exit 0" >&2
  cat "$tmpdir/advisory_missing.out" >&2
  exit 1
fi
if ! grep -qx 'GC_FREE_ELABORATOR=0' "$tmpdir/advisory_missing.out"; then
  echo "FAIL: advisory missing lean missing GC_FREE=0" >&2
  cat "$tmpdir/advisory_missing.out" >&2
  exit 1
fi
if systems_lean_host_elab_tokens_ok "$tmpdir/advisory_missing.out"; then
  echo "FAIL: advisory missing lean should not pass residual_tokens_ok" >&2
  cat "$tmpdir/advisory_missing.out" >&2
  exit 1
fi
echo "OK: advisory missing lean exit 0 + GC_FREE=0 (not residual_ok)"

# --- 8) Non-ELF lean paths must never earn GC_FREE=1 (Issue 1) ---
assert_unmeasured_no_earn() {
  local name="$1" out="$2"
  if grep -qx 'GC_FREE_ELABORATOR=1' "$out"; then
    echo "FAIL: case $name emitted GC_FREE_ELABORATOR=1 (non-ELF must not earn)" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'GC_FREE_ELABORATOR=0' "$out"; then
    echo "FAIL: case $name missing GC_FREE_ELABORATOR=0" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_ELABORATOR_RESIDUAL=unmeasured' "$out"; then
    echo "FAIL: case $name expected HOST_ELABORATOR_RESIDUAL=unmeasured" >&2
    cat "$out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_ELABORATOR_RESIDUAL_OK=0' "$out"; then
    echo "FAIL: case $name expected HOST_ELABORATOR_RESIDUAL_OK=0" >&2
    cat "$out" >&2
    exit 1
  fi
  if systems_lean_host_elab_tokens_ok "$out"; then
    echo "FAIL: case $name should not pass residual_tokens_ok" >&2
    cat "$out" >&2
    exit 1
  fi
}

# Shell-script "lean" (executable but not ELF).
printf '#!/bin/sh\necho fake-lean\nexit 0\n' >"$tmpdir/shell-lean"
chmod +x "$tmpdir/shell-lean"
set +e
env SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
    SYSTEMS_LEAN_TCB_LEAN="$tmpdir/shell-lean" \
    SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/shell-lean" \
    "$GATE" >"$tmpdir/shell_lean.out" 2>&1
shell_ec=$?
set -e
if [[ $shell_ec -ne 0 ]]; then
  echo "FAIL: shell_lean advisory expected exit 0 (got $shell_ec)" >&2
  cat "$tmpdir/shell_lean.out" >&2
  exit 1
fi
assert_unmeasured_no_earn shell_lean "$tmpdir/shell_lean.out"
echo "OK: shell-script lean is unmeasured (never GC_FREE=1)"

# Empty +x file (not ELF).
: >"$tmpdir/empty-lean"
chmod +x "$tmpdir/empty-lean"
set +e
env SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
    SYSTEMS_LEAN_TCB_LEAN="$tmpdir/empty-lean" \
    SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/empty-lean" \
    "$GATE" >"$tmpdir/empty_lean.out" 2>&1
empty_ec=$?
set -e
if [[ $empty_ec -ne 0 ]]; then
  echo "FAIL: empty_lean advisory expected exit 0 (got $empty_ec)" >&2
  cat "$tmpdir/empty_lean.out" >&2
  exit 1
fi
assert_unmeasured_no_earn empty_lean "$tmpdir/empty_lean.out"
echo "OK: empty +x lean is unmeasured (never GC_FREE=1)"

# REQUIRE non-ELF → fail hard.
fail_case non_elf_require \
  env SYSTEMS_LEAN_HOST_ELAB_REQUIRE=1 \
      SYSTEMS_LEAN_TCB_LEAN="$tmpdir/shell-lean" \
      SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/shell-lean" \
      "$GATE"
assert_unmeasured_no_earn non_elf_require "$tmpdir/non_elf_require.out"
echo "OK: REQUIRE non-ELF fails closed with unmeasured tokens"

# --- 9) Token checker fixtures: dual GC, dual HOST_HAS, unmeasured+OK=1, free+gc0 ---
cat >"$tmpdir/dual_gc.out" <<'EOF'
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
GC_FREE_ELABORATOR=1
HOST_ELABORATOR_RESIDUAL_OK=1
EOF
if systems_lean_host_elab_tokens_ok "$tmpdir/dual_gc.out"; then
  echo "FAIL: dual GC_FREE tokens accepted" >&2
  exit 1
fi
echo "OK: dual GC_FREE tokens rejected"

cat >"$tmpdir/dual_has.out" <<'EOF'
HOST_HAS_LEANSHARED=0
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=1
EOF
if systems_lean_host_elab_tokens_ok "$tmpdir/dual_has.out"; then
  echo "FAIL: dual HOST_HAS_LEANSHARED accepted" >&2
  exit 1
fi
echo "OK: dual HOST_HAS_LEANSHARED rejected"

cat >"$tmpdir/unmeasured_ok1.out" <<'EOF'
HOST_ELABORATOR_RESIDUAL=unmeasured
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=1
EOF
if systems_lean_host_elab_tokens_ok "$tmpdir/unmeasured_ok1.out"; then
  echo "FAIL: unmeasured + RESIDUAL_OK=1 accepted" >&2
  exit 1
fi
echo "OK: unmeasured + RESIDUAL_OK=1 rejected"

cat >"$tmpdir/free_gc0.out" <<'EOF'
HOST_HAS_LEANSHARED=0
HOST_ELABORATOR_RESIDUAL=residual_free
HOST_ELABORATOR_TCB=residual_free
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=1
EOF
if systems_lean_host_elab_tokens_ok "$tmpdir/free_gc0.out"; then
  echo "FAIL: residual_free + GC_FREE=0 accepted" >&2
  exit 1
fi
echo "OK: residual_free + GC_FREE=0 rejected"

# Honesty dual HOST_HAS
cat >"$tmpdir/honesty_dual_has.out" <<'EOF'
HOST_ELABORATOR_TCB=residual_free
HOST_ELABORATOR_RESIDUAL=residual_free
HOST_HAS_LEANSHARED=0
HOST_HAS_LEANSHARED=1
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=1
TCB_HONESTY_OK=1
EOF
if systems_lean_tcb_honesty_tokens_ok "$tmpdir/honesty_dual_has.out"; then
  echo "FAIL: honesty dual HOST_HAS accepted" >&2
  exit 1
fi
echo "OK: honesty dual HOST_HAS rejected"

# --- 10) Synthetic residual_free ELF (optional; needs cc + no shared lean libs) ---
# Build a tiny binary without leanshared NEEDED — earn path live test + FORCE allow.
CC_BIN="${CC:-}"
if [[ -z "$CC_BIN" ]]; then
  if command -v cc >/dev/null 2>&1; then
    CC_BIN="$(command -v cc)"
  elif command -v gcc >/dev/null 2>&1; then
    CC_BIN="$(command -v gcc)"
  fi
fi
if [[ -n "$CC_BIN" ]]; then
  cat >"$tmpdir/clean_host.c" <<'EOF'
int main(void) { return 0; }
EOF
  "$CC_BIN" -o "$tmpdir/clean_host" "$tmpdir/clean_host.c"
  pass_case synthetic_residual_free \
    env SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
        SYSTEMS_LEAN_TCB_LEAN="$tmpdir/clean_host" \
        SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/clean_host" \
        "$GATE"
  if ! grep -qx 'GC_FREE_ELABORATOR=1' "$tmpdir/synthetic_residual_free.out"; then
    echo "FAIL: synthetic clean host expected GC_FREE_ELABORATOR=1" >&2
    cat "$tmpdir/synthetic_residual_free.out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_HAS_LEANSHARED=0' "$tmpdir/synthetic_residual_free.out"; then
    echo "FAIL: synthetic clean host expected HOST_HAS_LEANSHARED=0" >&2
    cat "$tmpdir/synthetic_residual_free.out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_ELABORATOR_RESIDUAL=residual_free' "$tmpdir/synthetic_residual_free.out"; then
    echo "FAIL: synthetic clean host expected residual_free" >&2
    cat "$tmpdir/synthetic_residual_free.out" >&2
    exit 1
  fi
  echo "OK: synthetic residual-free binary earns GC_FREE_ELABORATOR=1"

  # FORCE + earned residual_free must be allowed (exit 0).
  pass_case force_earned_allowed \
    env SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 \
        SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
        SYSTEMS_LEAN_TCB_LEAN="$tmpdir/clean_host" \
        SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/clean_host" \
        "$GATE"
  if ! grep -qx 'GC_FREE_ELABORATOR=1' "$tmpdir/force_earned_allowed.out"; then
    echo "FAIL: force_earned_allowed expected GC_FREE=1" >&2
    cat "$tmpdir/force_earned_allowed.out" >&2
    exit 1
  fi
  echo "OK: FORCE + earned residual_free allowed"

  # --- 11) ldd alone must not earn residual_free (Issue 2 r3) ---
  # Disposable PATH: keep ldd + od/head for ELF magic; omit readelf/objdump.
  tools_ldd="$tmpdir/path_ldd_only"
  mkdir -p "$tools_ldd"
  for cmd in bash env date head sed grep cat tr uname dirname basename mktemp true false od cmp wc printf; do
    if p="$(command -v "$cmd" 2>/dev/null)"; then
      ln -sf "$p" "$tools_ldd/$cmd"
    fi
  done
  if p="$(command -v ldd 2>/dev/null)"; then
    ln -sf "$p" "$tools_ldd/ldd"
  fi
  # Pin READELF/OBJDUMP empty (set-but-empty disables tool; no /usr/bin fallthrough).
  set +e
  env PATH="$tools_ldd" \
      SYSTEMS_LEAN_HOST_READELF= \
      SYSTEMS_LEAN_HOST_OBJDUMP= \
      SYSTEMS_LEAN_HOST_OD="$tools_ldd/od" \
      SYSTEMS_LEAN_HOST_LDD="$tools_ldd/ldd" \
      SYSTEMS_LEAN_HOST_HEAD="$tools_ldd/head" \
      SYSTEMS_LEAN_HOST_CMP="$tools_ldd/cmp" \
      SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
      SYSTEMS_LEAN_TCB_LEAN="$tmpdir/clean_host" \
      SYSTEMS_LEAN_HOST_ELAB_LEAN="$tmpdir/clean_host" \
      "$GATE" >"$tmpdir/ldd_only_clean.out" 2>&1
  ldd_ec=$?
  set -e
  if [[ $ldd_ec -ne 0 ]]; then
    echo "FAIL: ldd_only_clean advisory expected exit 0 (got $ldd_ec)" >&2
    cat "$tmpdir/ldd_only_clean.out" >&2
    exit 1
  fi
  if grep -qx 'GC_FREE_ELABORATOR=1' "$tmpdir/ldd_only_clean.out"; then
    echo "FAIL: ldd_only_clean earned GC_FREE_ELABORATOR=1" >&2
    cat "$tmpdir/ldd_only_clean.out" >&2
    exit 1
  fi
  if ! grep -qx 'GC_FREE_ELABORATOR=0' "$tmpdir/ldd_only_clean.out"; then
    echo "FAIL: ldd_only_clean missing GC_FREE=0" >&2
    cat "$tmpdir/ldd_only_clean.out" >&2
    exit 1
  fi
  if grep -qx 'HOST_ELABORATOR_RESIDUAL=residual_free' "$tmpdir/ldd_only_clean.out"; then
    echo "FAIL: ldd_only_clean claimed residual_free" >&2
    cat "$tmpdir/ldd_only_clean.out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_ELABORATOR_RESIDUAL=unmeasured' "$tmpdir/ldd_only_clean.out"; then
    echo "FAIL: ldd_only_clean expected unmeasured" >&2
    cat "$tmpdir/ldd_only_clean.out" >&2
    exit 1
  fi
  echo "OK: ldd-only clean ELF does not earn residual_free (unmeasured)"
else
  echo "OK: skip synthetic_residual_free / force_earned_allowed / ldd_only (no host cc)"
fi

# --- 12) Hostile PATH lying readelf must not mint GC_FREE=1 on stage1 (Issue 1 r3) ---
if [[ -n "$STAGE1_LEAN" ]]; then
  lie="$tmpdir/lie_tools"
  mkdir -p "$lie"
  # Lying readelf: pretends ELF with empty NEEDED.
  cat >"$lie/readelf" <<'EOF'
#!/bin/sh
# Hostile PATH fixture: always "succeed" with no NEEDED lines.
exit 0
EOF
  chmod +x "$lie/readelf"
  cat >"$lie/objdump" <<'EOF'
#!/bin/sh
exit 0
EOF
  chmod +x "$lie/objdump"
  # Provide od/head/cmp so magic still works; keep real stage1 lean.
  for cmd in bash env od head cmp tr cat; do
    if p="$(command -v "$cmd" 2>/dev/null)"; then
      ln -sf "$p" "$lie/$cmd"
    fi
  done
  # Prefer /usr/bin tools over PATH liars — stage1 must still see leanshared.
  set +e
  env PATH="$lie:$PATH" \
      SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
      SYSTEMS_LEAN_TCB_LEAN="$STAGE1_LEAN" \
      SYSTEMS_LEAN_HOST_ELAB_LEAN="$STAGE1_LEAN" \
      "$GATE" >"$tmpdir/hostile_path.out" 2>&1
  hp_ec=$?
  set -e
  if [[ $hp_ec -ne 0 ]]; then
    echo "FAIL: hostile_path stage1 expected exit 0" >&2
    cat "$tmpdir/hostile_path.out" >&2
    exit 1
  fi
  if grep -qx 'GC_FREE_ELABORATOR=1' "$tmpdir/hostile_path.out"; then
    echo "FAIL: hostile PATH lying readelf minted GC_FREE_ELABORATOR=1 on stage1" >&2
    cat "$tmpdir/hostile_path.out" >&2
    exit 1
  fi
  if ! grep -qx 'HOST_HAS_LEANSHARED=1' "$tmpdir/hostile_path.out"; then
    echo "FAIL: hostile_path expected HOST_HAS_LEANSHARED=1 (pinned /usr/bin tools)" >&2
    cat "$tmpdir/hostile_path.out" >&2
    exit 1
  fi
  if ! grep -qx 'GC_FREE_ELABORATOR=0' "$tmpdir/hostile_path.out"; then
    echo "FAIL: hostile_path expected GC_FREE=0" >&2
    cat "$tmpdir/hostile_path.out" >&2
    exit 1
  fi
  echo "OK: hostile PATH lying readelf does not mint GC_FREE=1 (tools prefer /usr/bin)"

  # When both scanners are explicitly pinned to liars, multi-empty NEEDED would earn —
  # but ELF magic alone is not enough protection; require disagree if one real tool remains.
  # Pin only readelf to liar; real objdump (absolute) should still find shared or disagree→unmeasured.
  set +e
  env PATH="$lie:$PATH" \
      SYSTEMS_LEAN_HOST_READELF="$lie/readelf" \
      SYSTEMS_LEAN_HOST_ELAB_REQUIRE=0 \
      SYSTEMS_LEAN_TCB_LEAN="$STAGE1_LEAN" \
      SYSTEMS_LEAN_HOST_ELAB_LEAN="$STAGE1_LEAN" \
      "$GATE" >"$tmpdir/pin_lie_readelf.out" 2>&1
  pl_ec=$?
  set -e
  if grep -qx 'GC_FREE_ELABORATOR=1' "$tmpdir/pin_lie_readelf.out"; then
    echo "FAIL: pinned lying readelf + real objdump minted GC_FREE=1" >&2
    cat "$tmpdir/pin_lie_readelf.out" >&2
    exit 1
  fi
  # Either classic HAS=1 (objdump wins alone if readelf fails empty-ok but wait - empty success has re_ok=1)
  # Lying readelf exits 0 with empty out → has=0; real objdump has=1 → disagree → unmeasured.
  if ! grep -qx 'GC_FREE_ELABORATOR=0' "$tmpdir/pin_lie_readelf.out"; then
    echo "FAIL: pin_lie_readelf missing GC_FREE=0" >&2
    cat "$tmpdir/pin_lie_readelf.out" >&2
    exit 1
  fi
  if grep -qx 'HOST_ELABORATOR_RESIDUAL=residual_free' "$tmpdir/pin_lie_readelf.out"; then
    echo "FAIL: pin_lie_readelf claimed residual_free" >&2
    cat "$tmpdir/pin_lie_readelf.out" >&2
    exit 1
  fi
  echo "OK: pinned lying readelf + real objdump does not earn residual_free (disagree/classic)"
else
  echo "OK: skip hostile PATH stage1 cases (no stage1 lean)"
fi

echo "OK: systems-host-elaborator-residual negatives (fail-closed; measured G3 dual path)"
exit 0
