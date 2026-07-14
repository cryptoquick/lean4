#!/usr/bin/env bash
# End-to-end Systems Lean proof receipt (R4 dogfood; fail-closed).
#
# Succeeds (exit 0) only if all required gates pass:
#   1) MemSafetyCert present + QTT 0-qty claim on freestanding Extract C
#   2) CompCertCert present on Extract C
#   3) Independent Lean verify of the **same product TU matrix** that ccomp uses
#      (Extract + present Systems/{Scalars,Sys,Bytes,Numerics,Status}.c)
#      via shipped MemSafetyCert.verifyEmbedded / CompCertCert.verifyEmbedded
#   4) Real CompCert `ccomp` success (or hard-fail if missing when REQUIRE set)
#   5) Optional self-host nm gate when freestanding bundle is present
#   6) Residual IR greps on the product matrix (systems-residual-policy; fail-closed)
#   7) G2 linear residual mult-policy metrics (Multiplicity/FreeSafety source greps)
#   8) Track D QTT UseCheck depth (pure-fvar residual + freestanding bif* splitter SSoT)
#
# Honesty: this receipt is **not** the PROVABLY_COMPCERT_COMPLIANT=1 accomplishment
# token (that requires ./ref ccomp + systems-compcert-compliant.sh). R4 success is
# CompCert dogfood / sealed verify, not ResidualFree∧SorryFree∧REQUIRE_REF.
# G2 linear metrics are Mult-policy greps only — not elaborator completeness / GC-free.
# Track D QTT depth is UseCheck surface residual hardening — not full elaborator completeness.
#
# Env:
#   SYSTEMS_LEAN_COMPCERT_RESULT     — preferred nix result with bin/ccomp
#   SYSTEMS_LEAN_COMPCERT_REQUIRE=1  — refuse CompCert skip (default for this receipt)
#   SYSTEMS_LEAN_ALLOW_NO_COMPCERT=1 — allow SKIP only if REQUIRE is unset
#   SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST=1 — do not run nm gate even if bundle exists
#   SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_SELFHOST=1 — fail if bundle/nm gate unavailable
#   SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_RESIDUAL_IR=1 — skip residual IR greps (not recommended)
#   SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_LINEAR_METRICS=1 — skip G2 mult-policy greps
#     Honesty: SKIP means receipt is **incomplete for full product integrity** (validate
#     treats GATE linear_metrics as core). Prefer not skipping for dogfood receipts.
#   SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_LINEAR=1 — fail if linear metrics skipped
#   SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_QTT_DEPTH=1 — skip Track D UseCheck depth greps
#     Honesty: SKIP is incomplete for full product integrity (validate GATE qtt_depth is core).
#   SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_QTT_DEPTH=1 — fail if QTT depth skipped
#
# Usage (from lean4 root, stage1 lean on PATH, freestanding extract built):
#   ./script/systems-proof-receipt.sh [out.txt [Extract.c [bundle.a]]]
#
# Classic Lean users never need this; freestanding dogfood only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=systems-residual-policy.sh
source "$ROOT/script/systems-residual-policy.sh"
FS_EXAMPLE="$ROOT/tests/lake/examples/systems"
OUT="${1:-$FS_EXAMPLE/out/proof-receipt-full.txt}"
EXTRACT="${2:-$FS_EXAMPLE/lib/.lake/build/ir/Extract.c}"
BUNDLE="${3:-$FS_EXAMPLE/lib/.lake/build/lib/libfs_extract_bundle.a}"
VERIFY_LEAN="$FS_EXAMPLE/verify_memsafe.lean"
CHECK_COMPCERT="$FS_EXAMPLE/check_compcert.sh"
# IR root for companions = directory containing Extract.c (same matrix as check_compcert).
FS0_IR="$(cd "$(dirname "$EXTRACT")" 2>/dev/null && pwd || echo "$FS_EXAMPLE/lib/.lake/build/ir")"

mkdir -p "$(dirname "$OUT")"

# Default: proof receipt hard-requires CompCert unless ALLOW_NO is set without REQUIRE.
if [[ -z "${SYSTEMS_LEAN_COMPCERT_REQUIRE:-}" && "${SYSTEMS_LEAN_ALLOW_NO_COMPCERT:-}" != "1" ]]; then
  export SYSTEMS_LEAN_COMPCERT_REQUIRE=1
fi

status=0
lines=()
# Track whether CompCert ran in *this* invocation (avoid stale out/compcert/proof-receipt.txt).
ccomp_ran=0
ccomp_ok=0

log() {
  lines+=("$1")
  printf '%s\n' "$1"
}

ok()  { log "OK: $*"; }
fail() {
  log "FAIL: $*"
  status=1
}
note() { log "NOTE: $*"; }

# Absolute path when possible (for Lean env list + stable logging).
abspath() {
  local p="$1"
  if [[ -e "$p" ]]; then
    # Prefer realpath; fall back to cd/pwd for missing-parent edge cases.
    if command -v realpath >/dev/null 2>&1; then
      realpath "$p"
    else
      (cd "$(dirname "$p")" && echo "$(pwd)/$(basename "$p")")
    fi
  else
    # Still canonicalize parent if present.
    local d b
    d="$(dirname "$p")"
    b="$(basename "$p")"
    if [[ -d "$d" ]]; then
      echo "$(cd "$d" && pwd)/$b"
    else
      echo "$p"
    fi
  fi
}

log "Systems Lean proof receipt"
log "date: $(date -Is 2>/dev/null || date)"
if command -v lean >/dev/null 2>&1; then
  log "lean: $(command -v lean)"
  log "lean-version: $(lean --version 2>/dev/null | head -n1 || true)"
else
  fail "lean not on PATH (need stage1 lean to verify certs)"
fi
EXTRACT_ABS="$(abspath "$EXTRACT")"
log "extract: $EXTRACT_ABS"
log "---"

# --- Gate 1–2: embedded cert markers on Extract.c (fast preflight) ---
if [[ ! -f "$EXTRACT" ]]; then
  fail "missing freestanding Extract.c (build: lake --dir=$FS_EXAMPLE/lib build)"
else
  if grep -q 'SYSTEMS_LEAN_MEMSAFE_CERT' "$EXTRACT"; then
    ok "MemSafetyCert embedded"
  else
    fail "MemSafetyCert missing (SYSTEMS_LEAN_MEMSAFE_CERT)"
  fi
  if grep -q 'qtt_zero_quantity_erased' "$EXTRACT"; then
    ok "QTT 0-qty claim in Extract.c"
  else
    fail "QTT 0-qty claim missing (qtt_zero_quantity_erased)"
  fi
  if grep -q 'SYSTEMS_LEAN_COMPCERT_MEMCERT' "$EXTRACT"; then
    ok "CompCertCert embedded"
  else
    fail "CompCertCert missing (SYSTEMS_LEAN_COMPCERT_MEMCERT)"
  fi
fi

# Build the same C set that check_compcert will use: full product TU matrix.
# Lean must verifyEmbedded every path that will enter ccomp (forged EXTRACT cannot ride on dogfood).
build_verify_list() {
  local f
  while IFS= read -r f || [[ -n "$f" ]]; do
    [[ -z "$f" ]] && continue
    printf '%s\n' "$(abspath "$f")"
  done < <(systems_lean_list_product_c_tus "$FS0_IR" "$EXTRACT")
}

# --- Gate 3: independent Lean verify of EXTRACT (+ companions) ---
if [[ $status -eq 0 ]]; then
  if [[ ! -f "$VERIFY_LEAN" ]]; then
    fail "missing $VERIFY_LEAN"
  elif ! command -v lean >/dev/null 2>&1; then
    fail "lean missing; cannot run independent cert verify"
  else
    VERIFY_LIST="$(build_verify_list)"
    log "--- Lean verifyEmbedded (MemSafetyCert + CompCertCert) ---"
    log "verify-files:"
    while IFS= read -r vf || [[ -n "$vf" ]]; do
      [[ -n "$vf" ]] && log "  - $vf"
    done <<<"$VERIFY_LIST"
    set +e
    verify_out="$(
      cd "$FS_EXAMPLE" && \
        SYSTEMS_LEAN_VERIFY_C_FILES="$VERIFY_LIST" lean verify_memsafe.lean 2>&1
    )"
    verify_ec=$?
    set -e
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -n "$line" ]] && log "$line"
    done <<<"$verify_out"
    if [[ $verify_ec -eq 0 ]]; then
      # Ensure the EXTRACT path itself was reported as verified (not only companions).
      if grep -qF "verified $EXTRACT_ABS" <<<"$verify_out" || \
         grep -qF "verified $EXTRACT" <<<"$verify_out"; then
        ok "independent Lean verify of sealed freestanding C (includes EXTRACT)"
      else
        # Fallback: verify_out uses the path we passed; require EXTRACT_ABS substring.
        if grep -qF "$EXTRACT_ABS" <<<"$verify_out"; then
          ok "independent Lean verify of sealed freestanding C (includes EXTRACT)"
        else
          fail "Lean verify did not cover EXTRACT path $EXTRACT_ABS"
        fi
      fi
    else
      fail "independent Lean verify failed (exit $verify_ec)"
    fi
  fi
else
  note "skipping Lean verify because preflight markers failed"
fi

# --- Gate 4: real CompCert ccomp ---
log "--- CompCert (ccomp) ---"
if [[ $status -ne 0 ]]; then
  note "skipping CompCert because earlier gates failed"
elif [[ ! -x "$CHECK_COMPCERT" && ! -f "$CHECK_COMPCERT" ]]; then
  fail "missing $CHECK_COMPCERT"
else
  chmod +x "$CHECK_COMPCERT"
  ccomp_ran=1
  set +e
  ccomp_out="$(
    cd "$FS_EXAMPLE" && \
      SYSTEMS_LEAN_COMPCERT_IR_DIR="$FS0_IR" \
      ./check_compcert.sh "$EXTRACT" "$FS_EXAMPLE/out/compcert" 2>&1
  )"
  ccomp_ec=$?
  set -e
  # Summarize rather than dump entire ccomp.log body twice.
  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      OK:*|FAIL:*|SKIP:*|NOTE:*|===*|claims:*|receipt:*|date:*|ccomp:*|sources:|objects:|"  - "*)
        log "$line"
        ;;
    esac
  done <<<"$ccomp_out"
  if [[ $ccomp_ec -eq 0 ]]; then
    if grep -q '^SKIP:' <<<"$ccomp_out"; then
      if [[ "${SYSTEMS_LEAN_COMPCERT_REQUIRE:-}" == "1" ]]; then
        fail "CompCert SKIP while SYSTEMS_LEAN_COMPCERT_REQUIRE=1"
      else
        note "CompCert skipped (ALLOW_NO); receipt incomplete for full R4"
        fail "CompCert not run (incomplete proof receipt)"
      fi
    else
      ccomp_ok=1
      ok "real CompCert ccomp pipeline"
    fi
  else
    fail "CompCert pipeline failed (exit $ccomp_ec)"
  fi
fi

# Only attach CompCert object receipt from *this* successful ccomp run (never stale on FAIL/skip).
if [[ $ccomp_ok -eq 1 && -f "$FS_EXAMPLE/out/compcert/proof-receipt.txt" ]]; then
  log "--- CompCert object receipt (this run) ---"
  while IFS= read -r line || [[ -n "$line" ]]; do
    log "$line"
  done <"$FS_EXAMPLE/out/compcert/proof-receipt.txt"
elif [[ $ccomp_ran -eq 0 ]]; then
  note "CompCert object receipt omitted (ccomp not run this invocation)"
elif [[ $ccomp_ok -eq 0 ]]; then
  note "CompCert object receipt omitted (ccomp did not succeed this invocation)"
fi

# --- Gate 5: optional self-host nm ---
log "--- self-host nm (optional) ---"
if [[ "${SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST:-}" == "1" ]]; then
  note "self-host nm skipped (SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST=1)"
elif [[ -f "$BUNDLE" ]]; then
  set +e
  nm_out="$("$ROOT/script/systems-selfhost-link-check.sh" "$BUNDLE" 2>&1)"
  nm_ec=$?
  set -e
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -n "$line" ]] && log "$line"
  done <<<"$nm_out"
  if [[ $nm_ec -eq 0 ]]; then
    ok "self-host nm gate"
  else
    fail "self-host nm gate failed (exit $nm_ec)"
  fi
else
  if [[ "${SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_SELFHOST:-}" == "1" ]]; then
    fail "missing freestanding bundle for self-host nm ($BUNDLE)"
  else
    note "self-host bundle not present; nm gate skipped (optional)"
  fi
fi

# --- Gate 6: residual IR greps (product matrix; aligns with residual-policy / check_compcert TUs) ---
log "--- residual IR (product matrix) ---"
if [[ "${SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_RESIDUAL_IR:-}" == "1" ]]; then
  note "residual IR greps skipped (SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_RESIDUAL_IR=1)"
elif [[ $status -ne 0 ]]; then
  note "skipping residual IR because earlier gates failed"
elif [[ ! -f "$EXTRACT" ]]; then
  fail "residual IR: missing Extract $EXTRACT"
else
  set +e
  ir_out="$(systems_lean_check_product_ir_residuals "$FS0_IR" "$EXTRACT" 2>&1)"
  ir_ec=$?
  set -e
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -n "$line" ]] && log "$line"
  done <<<"${ir_out:-}"
  if [[ $ir_ec -ne 0 ]]; then
    fail "residual IR policy greps failed (product matrix)"
  else
    ok "residual IR greps on product TU matrix (systems-residual-policy)"
  fi
fi

# --- Gate 7: G2 linear residual mult-policy metrics (source greps; no CompCert) ---
# Align token checks with validate GATE linear_metrics (all six success tokens).
log "--- linear residual metrics (G2 Mult/FreeSafety) ---"
if [[ "${SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_LINEAR_METRICS:-}" == "1" ]]; then
  note "linear residual metrics skipped (SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_LINEAR_METRICS=1)"
  note "honesty: SKIP is incomplete for full product integrity (validate GATE linear_metrics is core)"
  if [[ "${SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_LINEAR:-}" == "1" ]]; then
    fail "linear residual metrics skipped while SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_LINEAR=1"
  fi
elif [[ $status -ne 0 ]]; then
  note "skipping linear residual metrics because earlier gates failed"
elif [[ ! -f "$ROOT/script/systems-linear-residual-metrics.sh" ]]; then
  fail "missing systems-linear-residual-metrics.sh"
else
  chmod +x "$ROOT/script/systems-linear-residual-metrics.sh" 2>/dev/null || true
  set +e
  # Product path: refuse ambient path overrides (pin $ROOT/src unless ALLOW_OVERRIDE).
  lin_out="$(
    env -u SYSTEMS_LEAN_LINEAR_METRICS_MULT \
        -u SYSTEMS_LEAN_LINEAR_METRICS_FREESAFETY \
        -u SYSTEMS_LEAN_LINEAR_METRICS_THEOREMS \
        -u SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE \
        "$ROOT/script/systems-linear-residual-metrics.sh" 2>&1
  )"
  lin_ec=$?
  set -e
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -n "$line" ]] && log "$line"
  done <<<"${lin_out:-}"
  lin_tokens_ok=1
  for tok in \
    LINEAR_SECOND_USE_IMPOSSIBLE=1 \
    MULT0_NON_RUNTIME_POLICY=1 \
    PRODUCT_RESIDUAL_MULT_POLICY=1 \
    LINEAR_NO_SILENT_DROP=1 \
    FREE_SAFETY_FORMAL_LAYER=1 \
    LINEAR_RESIDUAL_METRICS_OK=1
  do
    if ! grep -qx "$tok" <<<"$lin_out"; then
      lin_tokens_ok=0
    fi
  done
  if [[ $lin_ec -ne 0 || "$lin_tokens_ok" -ne 1 ]]; then
    fail "linear residual mult-policy metrics failed (need all six LINEAR_*=1 tokens)"
  else
    ok "linear residual mult-policy metrics (Multiplicity/FreeSafety markers; all six tokens)"
  fi
fi

# --- Gate 8: Track D QTT UseCheck depth (source greps; no CompCert) ---
# Align token checks with validate GATE qtt_depth (all three success tokens).
log "--- QTT depth (Track D UseCheck pure-fvar + bif* SSoT) ---"
if [[ "${SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_QTT_DEPTH:-}" == "1" ]]; then
  note "QTT depth greps skipped (SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_QTT_DEPTH=1)"
  note "honesty: SKIP is incomplete for full product integrity (validate GATE qtt_depth is core)"
  # Always greppable incomplete tokens when SKIP (even if RECEIPT still PASS without REQUIRE).
  log "QTT_DEPTH_SKIPPED=1"
  log "QTT_DEPTH_INCOMPLETE=1"
  log "QTT_DEPTH_OK=0"
  if [[ "${SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_QTT_DEPTH:-}" == "1" ]]; then
    fail "QTT depth greps skipped while SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_QTT_DEPTH=1"
  fi
elif [[ $status -ne 0 ]]; then
  note "skipping QTT depth because earlier gates failed"
elif [[ ! -f "$ROOT/script/systems-qtt-depth-check.sh" ]]; then
  fail "missing systems-qtt-depth-check.sh"
else
  chmod +x "$ROOT/script/systems-qtt-depth-check.sh" 2>/dev/null || true
  set +e
  # Product path: refuse ambient path overrides (pin $ROOT/src unless ALLOW_OVERRIDE).
  qtt_out="$(
    env -u SYSTEMS_LEAN_QTT_DEPTH_USECHECK \
        -u SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING \
        -u SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE \
        "$ROOT/script/systems-qtt-depth-check.sh" 2>&1
  )"
  qtt_ec=$?
  set -e
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -n "$line" ]] && log "$line"
  done <<<"${qtt_out:-}"
  qtt_tokens_ok=1
  for tok in \
    QTT_USECHECK_DISTINCT_PURE_FVAR=1 \
    QTT_SPLITTER_BIF_COMPLETE=1 \
    QTT_DEPTH_OK=1
  do
    if ! grep -qx "$tok" <<<"$qtt_out"; then
      qtt_tokens_ok=0
    fi
  done
  if [[ $qtt_ec -ne 0 || "$qtt_tokens_ok" -ne 1 ]]; then
    fail "QTT depth checks failed (need QTT_USECHECK_DISTINCT_PURE_FVAR=1, QTT_SPLITTER_BIF_COMPLETE=1, QTT_DEPTH_OK=1)"
  else
    ok "QTT depth (UseCheck pure-fvar residual + freestanding bif* splitter completeness)"
  fi
fi

log "---"
log "classic runtime: not deprecated; stage1 with libleanshared remains default"
log "QTT/FS: opt-in via compiler.freestanding / compiler.qtt"
log "honesty: Lean certs are checkable obligations; CompCert owns C-to-asm proof for ccomp path"
log "we are not CompCert — this R4 receipt is dogfood/sealed verify, not PROVABLY_COMPCERT_COMPLIANT=1"
log "for PROVABLY token use systems-compcert-compliant.sh with ./ref ccomp (REQUIRE_REF)"
log "G2 linear metrics: Mult/FreeSafety greps only — not UseCheck completeness, not GC_FREE_ELABORATOR=1"
log "G2 SKIP_LINEAR_METRICS: incomplete for full product integrity (validate treats linear_metrics as core)"
log "Track D QTT depth: UseCheck pure-fvar + bif* SSoT greps — not full elaborator completeness"
log "Track D SKIP_QTT_DEPTH: incomplete for full product integrity (validate treats qtt_depth as core)"

if [[ $status -eq 0 ]]; then
  log "RECEIPT: PASS"
else
  log "RECEIPT: FAIL"
fi

# Atomic-ish write of full receipt
{
  printf '%s\n' "${lines[@]}"
} >"$OUT"

echo "Wrote $OUT"
exit "$status"
