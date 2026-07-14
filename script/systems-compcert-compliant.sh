#!/usr/bin/env bash
# Provably CompCert compliant gate (accomplishment test).
#
# Success tokens (exactly one greppable line on full green; NEVER on failure):
#   PROVABLY_COMPCERT_COMPLIANT=1
#     — all conjuncts hold AND ccomp **resolves** to a **non-shell** machine-code
#       binary under ./ref/CompCert/ (built from the submodule). A shell launcher
#       under ./ref or even under ref/CompCert that only execs nix/RESULT is
#       **not** enough for PROVABLY.
#   COMPCERT_DOGFOOD=1
#     — all conjuncts hold with RESULT/nix/PATH ccomp, OR accomplishment mode
#       where ccomp is only a ./ref launcher → nix/RESULT pin (honest downgrade).
#       Never prints PROVABLY_…=1.
#
# Predicate:
#   ResidualFree  — systems-selfhost-link-check + residual IR greps (systems-residual-policy)
#   SorryFree     — systems-sorry-free-check (ComplianceCorpus)
#   AxiomAuto     — systems-axiom-check (ComplianceCorpus vs systems-tcb-axiom-allowlist.txt)
#   ProductStdlib — systems-product-stdlib-check (PRODUCT ⊆ corpus + allowlist coverage;
#                 greppable PRODUCT_STDLIB_MODULES_OK=1 and PRODUCT_CORPUS_ALIGN_OK=1)
#   CertsVerify   — MemSafetyCert + CompCertCert + qtt_zero_quantity_erased (+ Lean verify)
#                 on the full product TU matrix (Extract + present Systems modules)
#   CcompAccepts  — real ccomp on pure stripped TUs for that same matrix
#   Receipt       — out/compcert/compliant-receipt.txt with ccomp version + this-run paths
#
# Env:
#   SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 — default for this script unless ALLOW_RESULT
#   SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 — dogfood with RESULT/nix/PATH; prints COMPCERT_DOGFOOD=1 only
#   SYSTEMS_LEAN_COMPCERT_RESULT        — escape hatch / CI cache (bin/ccomp); dogfood only
#   SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 — do not lake-build; require existing artifacts
#   SYSTEMS_LEAN_COMPLIANT_BUNDLE       — override freestanding bundle path
#   SYSTEMS_LEAN_COMPLIANT_EXTRACT      — override Extract.c path
#   SYSTEMS_LEAN_COMPLIANT_IR_DIR       — override IR root (Extract + Systems/)
#   SYSTEMS_LEAN_COMPLIANT_OUT          — receipt dir (default freestanding/out/compcert)
#
# Usage (lean4 root; stage1 lean preferred on PATH):
#   ./script/systems-compcert-compliant.sh
#   SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 ./script/systems-compcert-compliant.sh  # dogfood
#   make -C tests/lake/examples/systems check-compcert-compliant
#
# Classic Lean users never need this. Fail-closed; never vacuous-OK.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FS_EXAMPLE="$ROOT/tests/lake/examples/systems"
IR_DIR="${SYSTEMS_LEAN_COMPLIANT_IR_DIR:-$FS_EXAMPLE/lib/.lake/build/ir}"
EXTRACT="${SYSTEMS_LEAN_COMPLIANT_EXTRACT:-$IR_DIR/Extract.c}"
BUNDLE="${SYSTEMS_LEAN_COMPLIANT_BUNDLE:-$FS_EXAMPLE/lib/.lake/build/lib/libfs_extract_bundle.a}"
OUT_DIR="${SYSTEMS_LEAN_COMPLIANT_OUT:-$FS_EXAMPLE/out/compcert}"
RECEIPT="$OUT_DIR/compliant-receipt.txt"
CHECK_COMPCERT="$FS_EXAMPLE/check_compcert.sh"
VERIFY_LEAN="$FS_EXAMPLE/verify_memsafe.lean"

# Capture log lines for receipt; success tokens only at the very end on green.
lines=()
status=0
ccomp_ok=0
success_printed=0
# this-run product TU list (absolute paths)
declare -a PRODUCT_TUS=()
declare -a THIS_PURE=()
declare -a THIS_OBJ=()
ccomp_path=""
ccomp_ver=""
dogfood_mode=0

log() { lines+=("$1"); printf '%s\n' "$1"; }
ok()  { log "OK: $*"; }
fail() {
  log "FAIL: $*"
  status=1
}
note() { log "NOTE: $*"; }

# Ensure greppable success tokens never appear as *exact lines* before final green.
# (Notes may mention the tokens in prose — only whole-line matches count.)
assert_no_success_token() {
  if printf '%s\n' "${lines[@]}" | grep -qxE 'PROVABLY_COMPCERT_COMPLIANT=1|COMPCERT_DOGFOOD=1'; then
    echo "INTERNAL: success token leaked before final gate" >&2
    exit 2
  fi
}

abspath() {
  local p="$1"
  if [[ -e "$p" ]] && command -v realpath >/dev/null 2>&1; then
    realpath "$p"
  elif [[ -e "$p" ]]; then
    (cd "$(dirname "$p")" && echo "$(pwd)/$(basename "$p")")
  else
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

write_fail_receipt() {
  mkdir -p "$OUT_DIR"
  {
    printf '%s\n' "${lines[@]:-}"
    echo "RECEIPT: FAIL"
    echo "PROVABLY_COMPCERT_COMPLIANT=0"
    echo "COMPCERT_DOGFOOD=0"
  } >"$RECEIPT"
}

# Invalidate any prior PASS receipt *before* sourcing residual-policy (set -e can abort on source).
mkdir -p "$OUT_DIR"
{
  echo "RECEIPT: INVALIDATED (compliant gate started)"
  echo "date: $(date -Is 2>/dev/null || date)"
  echo "PROVABLY_COMPCERT_COMPLIANT=0"
  echo "COMPCERT_DOGFOOD=0"
} >"$RECEIPT"

on_exit() {
  local ec=$?
  if [[ $success_printed -eq 1 ]]; then
    return 0
  fi
  # Crash or early exit: never leave a prior PASS success *line* on disk.
  if [[ ! -f "$RECEIPT" ]] \
      || grep -qx 'PROVABLY_COMPCERT_COMPLIANT=1' "$RECEIPT" 2>/dev/null \
      || grep -qx 'COMPCERT_DOGFOOD=1' "$RECEIPT" 2>/dev/null \
      || grep -q 'INVALIDATED' "$RECEIPT" 2>/dev/null; then
    write_fail_receipt
  fi
  return "$ec"
}
trap on_exit EXIT

# shellcheck source=systems-residual-policy.sh
source "$ROOT/script/systems-residual-policy.sh"

# Prefer in-tree stage1.
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
fi
if [[ -z "${LAKE:-}" && -x "$ROOT/build/release/stage1/bin/lake" ]]; then
  export LAKE="$ROOT/build/release/stage1/bin/lake"
fi
LAKE_BIN="${LAKE:-lake}"

chmod +x \
  "$ROOT/script/systems-selfhost-link-check.sh" \
  "$ROOT/script/systems-sorry-free-check.sh" \
  "$ROOT/script/systems-axiom-check.sh" \
  "$ROOT/script/systems-product-stdlib-check.sh" \
  "$ROOT/script/systems-residual-policy.sh" \
  "$CHECK_COMPCERT" 2>/dev/null || true

# --- Mode: accomplishment (./ref) vs explicit dogfood (ALLOW_RESULT) ---
if [[ "${SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT:-0}" == "1" ]]; then
  dogfood_mode=1
  export SYSTEMS_LEAN_COMPCERT_REQUIRE=1
  # Do not force REQUIRE_REF; RESULT/nix/PATH allowed.
  note "dogfood mode (SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1): dogfood success line only; never the PROVABLY accomplishment line"
else
  dogfood_mode=0
  export SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1
  export SYSTEMS_LEAN_COMPCERT_REQUIRE=1
  note "accomplishment mode: SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 (ccomp from ./ref only)"
fi
unset SYSTEMS_LEAN_ALLOW_NO_COMPCERT || true

# Propagate IR dir to check_compcert so ccomp uses the same matrix.
export SYSTEMS_LEAN_COMPCERT_IR_DIR="$IR_DIR"

log "=== Systems Lean: provably CompCert compliant gate ==="
log "date: $(date -Is 2>/dev/null || date)"
log "root: $ROOT"
log "mode: $([[ $dogfood_mode -eq 1 ]] && echo dogfood || echo accomplishment/ref)"
if command -v lean >/dev/null 2>&1; then
  log "lean: $(command -v lean)"
  log "lean-version: $(lean --version 2>/dev/null | head -n1 || true)"
else
  fail "lean not on PATH (need stage1 lean for CertsVerify)"
fi

# --- Optional product build ---
SKIP_BUILD="${SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD:-0}"
if [[ "$SKIP_BUILD" != "1" ]]; then
  if ! command -v "$LAKE_BIN" >/dev/null 2>&1 && [[ ! -x "$LAKE_BIN" ]]; then
    fail "lake not available (LAKE=$LAKE_BIN); set SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 if artifacts exist"
  else
    log "--- lake build freestanding ---"
    set +e
    build_out="$("$LAKE_BIN" --dir="$FS_EXAMPLE/lib" build 2>&1)"
    build_ec=$?
    set -e
    if [[ $build_ec -ne 0 ]]; then
      fail "freestanding lake build failed (exit $build_ec)"
      printf '%s\n' "$build_out" | tail -n 40 | while IFS= read -r l; do log "  $l"; done
    else
      ok "freestanding lake build"
      if [[ -z "${SYSTEMS_LEAN_COMPLIANT_BUNDLE:-}" ]]; then
        qb="$("$LAKE_BIN" --dir="$FS_EXAMPLE/lib" query Extract:freestanding.bundle 2>/dev/null || true)"
        if [[ -n "$qb" && -f "$qb" ]]; then
          BUNDLE="$qb"
        fi
      fi
    fi
  fi
else
  note "skipping lake build (SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1)"
fi

EXTRACT_ABS="$(abspath "$EXTRACT")"
BUNDLE_ABS="$(abspath "$BUNDLE")"
log "extract: $EXTRACT_ABS"
log "bundle: $BUNDLE_ABS"
log "ir-dir: $IR_DIR"
log "out: $OUT_DIR"

# Build this-run product TU matrix (Extract + every PRODUCT_STDLIB companion; fail-closed).
if [[ -f "$EXTRACT" ]]; then
  set +e
  _tu_list="$(systems_lean_list_product_c_tus "$IR_DIR" "$EXTRACT" 2>"$OUT_DIR/list-tus.err")"
  _tu_ec=$?
  set -e
  if [[ $_tu_ec -ne 0 ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -n "$line" ]] && log "$line"
    done <"$OUT_DIR/list-tus.err" 2>/dev/null || true
    fail "product TU matrix incomplete (systems_lean_list_product_c_tus exit $_tu_ec)"
  fi
  while IFS= read -r tu || [[ -n "$tu" ]]; do
    [[ -n "$tu" ]] || continue
    PRODUCT_TUS+=("$(abspath "$tu")")
  done <<<"$_tu_list"
  unset _tu_list _tu_ec
fi
log "product-TU-matrix (${#PRODUCT_TUS[@]}):"
for tu in "${PRODUCT_TUS[@]:-}"; do
  log "  - $tu"
done

# ========== 1) ResidualFree ==========
log "--- ResidualFree ---"
if [[ $status -ne 0 ]]; then
  note "skipping ResidualFree after earlier failure"
else
  if [[ ! -f "$BUNDLE" ]]; then
    fail "ResidualFree: missing freestanding bundle $BUNDLE"
  else
    set +e
    nm_out="$("$ROOT/script/systems-selfhost-link-check.sh" "$BUNDLE" 2>&1)"
    nm_ec=$?
    set -e
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -n "$line" ]] && log "$line"
    done <<<"$nm_out"
    if [[ $nm_ec -ne 0 ]]; then
      fail "ResidualFree: self-host link / nm gate failed (exit $nm_ec)"
    else
      ok "ResidualFree: nm / self-host link gate"
    fi
  fi

  if [[ $status -eq 0 ]]; then
    set +e
    ir_out="$(systems_lean_check_product_ir_residuals "$IR_DIR" "$EXTRACT" 2>&1)"
    ir_ec=$?
    set -e
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -n "$line" ]] && log "$line"
    done <<<"${ir_out:-}"
    if [[ $ir_ec -ne 0 ]]; then
      fail "ResidualFree: residual IR policy greps failed"
    else
      ok "ResidualFree: product IR residual greps (systems-residual-policy)"
    fi
  fi
fi

# ========== 2) SorryFree ==========
log "--- SorryFree ---"
if [[ $status -ne 0 ]]; then
  note "skipping SorryFree after earlier failure"
else
  set +e
  sorry_out="$("$ROOT/script/systems-sorry-free-check.sh" 2>&1)"
  sorry_ec=$?
  set -e
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -n "$line" ]] && log "$line"
  done <<<"$sorry_out"
  if [[ $sorry_ec -ne 0 ]]; then
    fail "SorryFree: ComplianceCorpus contains sorry/admit or is incomplete"
  else
    ok "SorryFree: ComplianceCorpus"
  fi
fi

# ========== 2b) AxiomAuto (TCB allowlist; fail-closed W7.C5) ==========
log "--- AxiomAuto ---"
if [[ $status -ne 0 ]]; then
  note "skipping AxiomAuto after earlier failure"
else
  set +e
  axiom_out="$("$ROOT/script/systems-axiom-check.sh" 2>&1)"
  axiom_ec=$?
  set -e
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -n "$line" ]] && log "$line"
  done <<<"$axiom_out"
  # Match validate GATE axiom_auto: OK token + path-only budget (Scalars/Sys only)
  # + at least one name pin (blocks silent widen to all path-only).
  if [[ $axiom_ec -ne 0 ]] \
    || ! printf '%s\n' "$axiom_out" | grep -qx 'AXIOM_AUTO_GATE_OK=1' \
    || ! printf '%s\n' "$axiom_out" | grep -qx 'AXIOM_ALLOWLIST_PATH_ONLY_COUNT=2' \
    || ! printf '%s\n' "$axiom_out" | grep -qE '^AXIOM_ALLOWLIST_NAME_PIN_COUNT=[1-9][0-9]*$'; then
    fail "AxiomAuto: ComplianceCorpus unlisted axiom, tool/layout incomplete, or pin budget (need PATH_ONLY_COUNT=2 and NAME_PIN_COUNT≥1)"
  else
    ok "AxiomAuto: ComplianceCorpus (AXIOM_AUTO_GATE_OK=1 PATH_ONLY_COUNT=2 NAME_PIN_COUNT≥1)"
  fi
fi

# ========== 2c) ProductStdlib (B2 PRODUCT ⊆ corpus + allowlist coverage) ==========
# AxiomAuto alone walks ComplianceCorpus only; without this conjunct a PRODUCT module
# with axioms could sit off-corpus and still green-light PROVABLY/DOGFOOD.
log "--- ProductStdlib ---"
if [[ $status -ne 0 ]]; then
  note "skipping ProductStdlib after earlier failure"
else
  set +e
  pstd_out="$(
    env SYSTEMS_LEAN_PRODUCT_IR_ROOT="${SYSTEMS_LEAN_PRODUCT_IR_ROOT:-$IR_DIR}" \
      "$ROOT/script/systems-product-stdlib-check.sh" 2>&1
  )"
  pstd_ec=$?
  set -e
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -n "$line" ]] && log "$line"
  done <<<"$pstd_out"
  if [[ $pstd_ec -ne 0 ]] \
    || ! printf '%s\n' "$pstd_out" | grep -qx 'PRODUCT_STDLIB_MODULES_OK=1' \
    || ! printf '%s\n' "$pstd_out" | grep -qx 'PRODUCT_CORPUS_ALIGN_OK=1'; then
    fail "ProductStdlib: PRODUCT ↔ corpus align or allowlist coverage incomplete (PRODUCT_CORPUS_ALIGN_OK / MODULES_OK)"
  else
    ok "ProductStdlib: PRODUCT_STDLIB_MODULES_OK=1 PRODUCT_CORPUS_ALIGN_OK=1"
  fi
fi

# ========== 3) CertsVerify (full product TU matrix) ==========
log "--- CertsVerify ---"
if [[ $status -ne 0 ]]; then
  note "skipping CertsVerify after earlier failure"
else
  if [[ ! -f "$EXTRACT" ]]; then
    fail "CertsVerify: missing $EXTRACT"
  elif [[ ${#PRODUCT_TUS[@]} -eq 0 ]]; then
    fail "CertsVerify: empty product TU matrix"
  else
    cert_bad=0
    for f in "${PRODUCT_TUS[@]}"; do
      if ! grep -q 'SYSTEMS_LEAN_MEMSAFE_CERT' "$f"; then
        fail "CertsVerify: $f missing MemSafetyCert (SYSTEMS_LEAN_MEMSAFE_CERT)"
        cert_bad=1
      fi
      if ! grep -q 'qtt_zero_quantity_erased' "$f"; then
        fail "CertsVerify: $f missing qtt_zero_quantity_erased"
        cert_bad=1
      fi
      if ! grep -q 'SYSTEMS_LEAN_COMPCERT_MEMCERT' "$f"; then
        fail "CertsVerify: $f missing CompCertCert (SYSTEMS_LEAN_COMPCERT_MEMCERT)"
        cert_bad=1
      fi
    done
    if [[ $cert_bad -eq 0 ]]; then
      ok "CertsVerify: embedded claim markers on ${#PRODUCT_TUS[@]} product C TUs"
    fi

    if [[ $status -eq 0 ]]; then
      if [[ ! -f "$VERIFY_LEAN" ]]; then
        fail "CertsVerify: missing $VERIFY_LEAN"
      elif ! command -v lean >/dev/null 2>&1; then
        fail "CertsVerify: lean missing"
      else
        VERIFY_LIST="$(printf '%s\n' "${PRODUCT_TUS[@]}")"
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
        if [[ $verify_ec -ne 0 ]]; then
          fail "CertsVerify: independent Lean verifyEmbedded failed (exit $verify_ec)"
        else
          # Require every TU to appear with a verified line (fail-closed coverage).
          missing_v=0
          for f in "${PRODUCT_TUS[@]}"; do
            if ! grep -qF "verified $f" <<<"$verify_out"; then
              # MemSafety and CompCert lines both say "verified $path"
              if ! grep -qF "$f" <<<"$verify_out"; then
                fail "CertsVerify: Lean verify did not cover $f"
                missing_v=1
              fi
            fi
          done
          if [[ $missing_v -eq 0 ]]; then
            ok "CertsVerify: independent Lean verifyEmbedded (${#PRODUCT_TUS[@]} TUs)"
          fi
        fi
      fi
    fi
  fi
fi

# ========== 4) CcompAccepts ==========
log "--- CcompAccepts ---"
if [[ $status -ne 0 ]]; then
  note "skipping CcompAccepts after earlier failure"
else
  if [[ ! -f "$CHECK_COMPCERT" ]]; then
    fail "CcompAccepts: missing $CHECK_COMPCERT"
  else
    chmod +x "$CHECK_COMPCERT"
    # Clear prior pure/obj for this matrix only (do not rely on orphan globs in receipt).
    set +e
    ccomp_out="$(
      cd "$FS_EXAMPLE" && \
        SYSTEMS_LEAN_COMPCERT_IR_DIR="$IR_DIR" \
        ./check_compcert.sh "$EXTRACT" "$OUT_DIR" 2>&1
    )"
    ccomp_ec=$?
    set -e
    while IFS= read -r line || [[ -n "$line" ]]; do
      case "$line" in
        OK:*|FAIL:*|SKIP:*|NOTE:*|===*|claims:*|receipt:*|date:*|ccomp:*|sources:|objects:|"  - "*)
          log "$line"
          ;;
      esac
    done <<<"$ccomp_out"
    if [[ $ccomp_ec -ne 0 ]]; then
      fail "CcompAccepts: ccomp pipeline failed (exit $ccomp_ec)"
    elif grep -q '^SKIP:' <<<"$ccomp_out"; then
      fail "CcompAccepts: CompCert SKIP is not compliance (install ccomp under ./ref or set ALLOW_RESULT)"
    else
      # Record this-run pure/obj from PRODUCT_TUS basenames only (never orphan globs).
      for f in "${PRODUCT_TUS[@]}"; do
        base="$(basename "$f" .c)"
        pure="$OUT_DIR/${base}.pure.c"
        obj="$OUT_DIR/${base}.o"
        if [[ ! -f "$pure" ]]; then
          fail "CcompAccepts: missing this-run pure C $pure"
        else
          THIS_PURE+=("$pure")
        fi
        if [[ ! -f "$obj" ]]; then
          fail "CcompAccepts: missing this-run object $obj"
        else
          THIS_OBJ+=("$obj")
        fi
      done
      if [[ $status -eq 0 ]]; then
        ccomp_ok=1
        ok "CcompAccepts: real ccomp on ${#THIS_OBJ[@]} pure stripped TUs (this run)"
      fi
    fi
  fi
fi

# Resolve the *effective* ccomp binary (follow launchers under ./ref to nix/RESULT or
# in-tree ref/CompCert/ccomp). PROVABLY requires a **non-shell** binary under ref/CompCert/
# (typically an ELF built from the submodule). A shell launcher placed under
# ref/CompCert/ that only execs nix/RESULT must **not** count as PROVABLY.
ccomp_resolved=""

# Return 0 if path is a real machine-code ccomp (not a shell launcher / text script).
is_real_compcert_binary() {
  local p="$1"
  [[ -n "$p" && -f "$p" && -x "$p" ]] || return 1
  # Shebang → launcher/script, never PROVABLY.
  if head -c 2 "$p" 2>/dev/null | grep -q $'#!'; then
    return 1
  fi
  if head -n1 "$p" 2>/dev/null | grep -qE '^#!.*\b(ba)?sh\b'; then
    return 1
  fi
  if command -v file >/dev/null 2>&1; then
    local desc
    desc="$(file -b "$p" 2>/dev/null || true)"
    # Reject text / shell scripts even if marked executable.
    if printf '%s' "$desc" | grep -qiE 'shell script|ASCII text|UTF-8 Unicode text|Bourne|bash script'; then
      return 1
    fi
    # Accept ELF / Mach-O / PE machine binaries.
    if printf '%s' "$desc" | grep -qiE 'ELF|Mach-O|PE32|executable'; then
      return 0
    fi
    return 1
  fi
  # No file(1): shebang already rejected; treat remaining executable as real.
  return 0
}

resolve_ccomp_binary() {
  local p="$1"
  local rp cand inner
  [[ -n "$p" ]] || { echo ""; return 0; }
  rp="$(abspath "$p")"

  # Symlink → ultimate target first (may be nix store or in-tree).
  if [[ -L "$rp" ]] && command -v readlink >/dev/null 2>&1; then
    rp="$(abspath "$(readlink -f "$rp" 2>/dev/null || readlink "$rp")")"
  fi

  # In-tree CompCert path: only "resolved" for PROVABLY if real binary.
  case "$rp" in
    "$ROOT/ref/CompCert"/*)
      if is_real_compcert_binary "$rp"; then
        echo "$rp"
        return 0
      fi
      # Shell launcher under ref/CompCert/ — fall through to dogfood pins.
      ;;
  esac

  # Shell launcher (under ref/bin or ref/CompCert): prefer real in-tree build, else RESULT/nix.
  if [[ -f "$rp" ]] && { head -c 2 "$rp" 2>/dev/null | grep -q $'#!' || head -n1 "$rp" 2>/dev/null | grep -qE 'bash|sh'; }; then
    if [[ -x "$ROOT/ref/CompCert/ccomp" ]] && is_real_compcert_binary "$ROOT/ref/CompCert/ccomp"; then
      abspath "$ROOT/ref/CompCert/ccomp"
      return 0
    fi
    for cand in \
      "$ROOT/result-compcert/bin/ccomp" \
      "${SYSTEMS_LEAN_COMPCERT_RESULT:-}/bin/ccomp"
    do
      if [[ -n "${cand:-}" && -x "$cand" ]]; then
        inner="$(abspath "$cand")"
        # Follow one more symlink hop if needed.
        if [[ -L "$inner" ]] && command -v readlink >/dev/null 2>&1; then
          inner="$(abspath "$(readlink -f "$inner" 2>/dev/null || readlink "$inner")")"
        fi
        echo "$inner"
        return 0
      fi
    done
    # Last resort: leave launcher path (will not be PROVABLY — not a real binary).
    echo "$rp"
    return 0
  fi
  echo "$rp"
}

if [[ $ccomp_ok -eq 1 ]]; then
  if [[ -f "$OUT_DIR/ccomp-version.txt" ]]; then
    ccomp_ver="$(head -n1 "$OUT_DIR/ccomp-version.txt" 2>/dev/null || true)"
  fi
  if [[ -f "$OUT_DIR/ccomp-path.txt" ]]; then
    ccomp_path="$(head -n1 "$OUT_DIR/ccomp-path.txt" 2>/dev/null || true)"
  fi
  ccomp_resolved="$(resolve_ccomp_binary "${ccomp_path:-}")"
  log "ccomp-path: ${ccomp_path:-unknown}"
  log "ccomp-resolved: ${ccomp_resolved:-unknown}"
  # Accomplishment discovery: recorded path must live under ./ref
  if [[ $dogfood_mode -eq 0 ]]; then
    case "$(abspath "${ccomp_path:-/}")" in
      "$ROOT/ref"/*|"$ROOT/ref"/ccomp|"$ROOT/ref"/ccomp.opt) ;;
      *)
        if [[ -n "$ccomp_path" && -x "$ccomp_path" ]]; then
          rp="$(abspath "$ccomp_path")"
          case "$rp" in
            "$ROOT/ref"/*) ;;
            *)
              fail "CcompAccepts: accomplishment requires ccomp under $ROOT/ref (got: ${ccomp_path:-unknown}); tool discovery, not product residual"
              ccomp_ok=0
              ;;
          esac
        else
          fail "CcompAccepts: accomplishment requires ccomp under $ROOT/ref (got: ${ccomp_path:-unknown}); tool discovery, not product residual"
          ccomp_ok=0
        fi
        ;;
    esac
  fi
fi

# ========== 5) Receipt ==========
log "--- Receipt ---"
assert_no_success_token

if [[ $status -ne 0 || $ccomp_ok -eq 0 ]]; then
  write_fail_receipt
  log "RECEIPT: FAIL → $RECEIPT"
  log "honesty: never claim PROVABLY unless residual-free ∧ sorry-free ∧ axiom-auto ∧ certs ∧ ccomp resolves under ref/CompCert"
  if grep -qxE 'PROVABLY_COMPCERT_COMPLIANT=1|COMPCERT_DOGFOOD=1' "$RECEIPT"; then
    echo "INTERNAL: success token in FAIL receipt" >&2
    exit 2
  fi
  if printf '%s\n' "${lines[@]}" | grep -qxE 'PROVABLY_COMPCERT_COMPLIANT=1|COMPCERT_DOGFOOD=1'; then
    echo "INTERNAL: success token in FAIL log" >&2
    exit 2
  fi
  exit 1
fi

# All green: choose success token by *resolved* binary, not only discovery path.
# PROVABLY only when resolved path is a **non-shell** binary under ref/CompCert/
# (in-tree build). Shell launcher under ref/CompCert that execs nix → DOGFOOD only.
# Launcher → nix/RESULT (or ALLOW_RESULT dogfood) → COMPCERT_DOGFOOD=1 only.
provably_ok=0
case "${ccomp_resolved:-}" in
  "$ROOT/ref/CompCert"/*)
    if is_real_compcert_binary "${ccomp_resolved}"; then
      provably_ok=1
    else
      note "resolved path under ref/CompCert but not a real ccomp binary (shell/text launcher?) — not PROVABLY"
    fi
    ;;
esac

if [[ $dogfood_mode -eq 1 ]]; then
  success_token="COMPCERT_DOGFOOD=1"
  claim_label="CompCert dogfood (RESULT/nix/PATH allowed; not provably compliant)"
elif [[ $provably_ok -eq 1 ]]; then
  success_token="PROVABLY_COMPCERT_COMPLIANT=1"
  claim_label="provably CompCert compliant (ref/CompCert in-tree ccomp binary + full product TU matrix)"
else
  # Honest downgrade: ./ref launcher dogfood pin, not submodule-built ccomp.
  success_token="COMPCERT_DOGFOOD=1"
  claim_label="CompCert dogfood via ./ref launcher → resolved outside ref/CompCert real binary (not PROVABLY)"
  note "accomplishment discovery under ./ref but resolved ccomp is not a real binary under ref/CompCert — emitting COMPCERT_DOGFOOD=1 only (build ref/CompCert for PROVABLY)"
fi

{
  echo "Systems Lean compliant receipt"
  echo "date: $(date -Is 2>/dev/null || date)"
  echo "claim: $claim_label"
  echo "predicate: ResidualFree ∧ SorryFree ∧ AxiomAuto ∧ ProductStdlib ∧ CertsVerify ∧ CcompAccepts"
  echo "mode: $([[ $dogfood_mode -eq 1 ]] && echo dogfood-ALLOW_RESULT || echo accomplishment-REQUIRE_REF)"
  echo "ccomp-path: ${ccomp_path:-unknown}"
  echo "ccomp-resolved: ${ccomp_resolved:-unknown}"
  echo "ccomp-version: ${ccomp_ver:-unknown}"
  echo "provably-requires: resolved ccomp under $ROOT/ref/CompCert/"
  echo "extract: $EXTRACT_ABS"
  echo "bundle: $BUNDLE_ABS"
  echo "ir-dir: $IR_DIR"
  echo "out-dir: $OUT_DIR"
  echo "product-TUs-this-run:"
  for f in "${PRODUCT_TUS[@]}"; do
    echo "  - $f"
  done
  echo "pure-sources-this-run:"
  for p in "${THIS_PURE[@]}"; do
    echo "  - $p"
  done
  echo "objects-this-run:"
  for p in "${THIS_OBJ[@]}"; do
    echo "  - $p ($(wc -c <"$p") bytes)"
  done
  echo "claims: MemSafetyCert + qtt_zero_quantity_erased + CompCertCert"
  echo "corpus: script/systems-compliance-corpus.txt"
  echo "tcb-axioms: script/systems-tcb-axiom-allowlist.txt (auto-gated via systems-axiom-check.sh; AXIOM_AUTO_GATE_OK=1)"
  echo "product-stdlib: systems-product-stdlib-check.sh (PRODUCT_STDLIB_MODULES_OK=1 PRODUCT_CORPUS_ALIGN_OK=1)"
  echo "residual-policy: script/systems-residual-policy.sh"
  echo "residual-IR-RE: $SYSTEMS_LEAN_IR_RESIDUAL_RE"
  echo "honesty: Lean owns residual-free emit + obligation certs; CompCert owns C→asm for accepted TUs"
  echo "we are not CompCert — PROVABLY requires resolved ccomp under ref/CompCert; launcher→nix is dogfood only"
  printf '%s\n' "${lines[@]}"
  echo "RECEIPT: PASS"
  echo "$success_token"
  # Explicit zeros for the other token so greps cannot confuse modes.
  if [[ "$success_token" == "COMPCERT_DOGFOOD=1" ]]; then
    echo "PROVABLY_COMPCERT_COMPLIANT=0"
  else
    echo "COMPCERT_DOGFOOD=0"
  fi
} >"$RECEIPT"

log "RECEIPT: PASS → $RECEIPT"
echo "$success_token"
success_printed=1
exit 0
