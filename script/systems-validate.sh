#!/usr/bin/env bash
# Systems Lean strategic validation harness (feedback loop / validation-harness slice).
#
# This is **not** a claim that all W-series roadmap items are complete. It re-runs
# residual, product_stdlib (incl. B2 PRODUCT_CORPUS_ALIGN_OK), sorry-free, **axiom_auto** (TCB axiom allowlist / B1 name pins), **tcb_honesty**
# (host vs product TCB tokens; measured GC_FREE_ELABORATOR), **host_elaborator** (G3 measured
# host residual), **linear_metrics** (G2 Mult/FreeSafety mult-policy residual greps), **qtt_depth**
# (Track D UseCheck pure-fvar + freestanding bif* splitter completeness), QTT elab,
# freestanding subset, CompCert dogfood/PROVABLY discovery, inventory, and (by default) existing
# negative suites (incl. systems-axiom-check-negatives, systems-tcb-inventory-negatives,
# systems-host-elaborator-residual-negatives, systems-linear-residual-metrics-negatives,
# systems-qtt-depth-check-negatives).
#
# Machine-readable scoreboard (stdout):
#
#   GATE residual_nm=PASS|FAIL
#   GATE residual_ir=PASS|FAIL
#   GATE product_gc_free=PASS|FAIL
#   GATE product_stdlib=PASS|FAIL
#   GATE sorry_free=PASS|FAIL
#   GATE axiom_auto=PASS|FAIL
#   GATE tcb_honesty=PASS|FAIL
#   GATE host_elaborator=PASS|FAIL
#   GATE linear_metrics=PASS|FAIL
#   GATE qtt_depth=PASS|FAIL
#   GATE qtt_elab=PASS|FAIL
#   GATE freestanding_check=PASS|FAIL
#   GATE compcert_dogfood=PASS|FAIL|SKIP
#   GATE compcert_provably=PASS|FAIL|SKIP
#   GATE negatives=PASS|FAIL|SKIP
#   GATE inventory_fs_ready=N
#   SCORE pass=A fail=B skip=C
#
# Greppable product GC/RC-free wire tokens on the **scoreboard stdout** (authoritative):
#   PRODUCT_GC_FREE=1
#   PRODUCT_NO_LEANSHARED=1
# Emitted only when GATE product_gc_free=PASS. Prefer `rg` on scoreboard stdout after
# GATE lines — inventory may also print PRODUCT_*= (nm-advisory only) on its stderr/stdout
# transcript during GATE tcb_honesty; that is not the product integrity claim.
#
# Greppable host elaborator residual tokens (G3; scoreboard; match GATE host_elaborator):
#   HOST_HAS_LEANSHARED=0|1
#   HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime|residual_free
#   GC_FREE_ELABORATOR=0|1          measured — =1 only if residual_free (no shared NEEDED)
#   HOST_ELABORATOR_RESIDUAL_OK=0|1
# Stage1 today → GC_FREE_ELABORATOR=0 + classic residual (staged G3 PASS, not elaborator rewrite).
# Product PRODUCT_GC_FREE is independent of host GC_FREE_ELABORATOR.
#
# Greppable G2 linear residual mult-policy tokens (scoreboard; only when GATE linear_metrics=PASS):
#   LINEAR_RESIDUAL_METRICS_OK=1
#   LINEAR_SECOND_USE_IMPOSSIBLE=1
#   MULT0_NON_RUNTIME_POLICY=1
#   PRODUCT_RESIDUAL_MULT_POLICY=1
#   LINEAR_NO_SILENT_DROP=1
#   FREE_SAFETY_FORMAL_LAYER=1
# Source greps of Multiplicity/FreeSafety markers (not elaborator completeness; not GC_FREE_ELABORATOR).
#
# Greppable Track D QTT UseCheck depth tokens (scoreboard; only when GATE qtt_depth=PASS):
#   QTT_USECHECK_DISTINCT_PURE_FVAR=1
#   QTT_SPLITTER_BIF_COMPLETE=1
#   QTT_DEPTH_OK=1
# UseCheck pure-fvar residual + freestanding bif* ⊆ splitterLayout SSoT — surface hardening only.
#
# Greppable Track C Parallelism dual-path isolation tokens (scoreboard; freestanding_check PASS):
#   PRODUCT_PARALLELISM_L2_SEQUENTIAL=1
#   PRODUCT_PARALLELISM_NO_PTHREAD=1
#   PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1
#   PARALLELISM_DUAL_PATH_OK=1
#   CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1
# Product residual is sequential only; pthread / HW SIMD are host dogfood, not proved concurrent runtime.
# Primary PARALLELISM_* tokens only (no PAR_* / PRODUCT_PAR_* transition aliases).
#
# Gate notes:
#   residual_nm — nm residual only (link-check exit 0); not alone a product GC-free claim.
#   residual_ir — product IR residual matrix.
#   product_gc_free — residual_nm ∧ residual_ir ∧ link-check tokens from residual_nm transcript.
#     FAIL coverage: residual fail → this gate FAIL; link-check-negatives reject tokens on residual
#     FAIL; residual PASS always emits tokens today (re-grep would FAIL if tokens missing).
#   host_elaborator — G3 measure lean NEEDED for leanshared/Init_shared; PASS when residual tokens
#     consistent (classic shared + GC_FREE=0 is PASS; forged GC_FREE=1 with shared is FAIL).
#   linear_metrics — Mult/FreeSafety definitional mult-policy markers (G2); local source greps only.
#   SCORE fail= counts each gate independently (dependent residual_nm + product_gc_free both FAIL
#     may double-count; integrity is core_ok, not fail_n alone).
#
# Exit 0 only when core product integrity holds:
#   residual_nm ∧ residual_ir ∧ product_gc_free ∧ product_stdlib ∧ sorry_free ∧ axiom_auto ∧
#   tcb_honesty ∧ host_elaborator ∧ linear_metrics ∧ qtt_depth ∧ qtt_elab ∧ freestanding_check
#   and compcert_dogfood ≠ FAIL
#   and negatives ≠ FAIL
# CompCert may SKIP when tools are missing (not a product residual failure).
# Dogfood product/gate failures are FAIL (never remapped to SKIP via broad greps).
#
# product_stdlib is the greppable “mults / residual matrix implemented for stdlib”
# gate: script/systems-product-stdlib-modules.txt + systems-product-stdlib-check.sh
# (sources, lakefile roots, residual-policy single source of truth, optional IR).
# axiom_auto is the TCB axiom auto-gate (W7.C5): systems-axiom-check.sh +
# systems-tcb-axiom-allowlist.txt over ComplianceCorpus (AXIOM_AUTO_GATE_OK=1).
# tcb_honesty is host elaborator vs product embed TCB honesty (P5 / G3 measured dual path):
#   systems-tcb-inventory.sh exit 0 + systems_lean_tcb_honesty_tokens_ok (shared checker):
#   classic path: GC_FREE_ELABORATOR=0 + classic TCB; earn path: GC_FREE=1 only with residual_free
#   evidence. Exactly one TCB_HONESTY_OK=1, no TCB_HONESTY_OK=0, product embed TCB.
#   Does **not** require PRODUCT_FS_NEXT or SYSTEMS_LEAN_TCB_REQUIRE=1 by default.
# host_elaborator is G3 host residual measurement (systems-host-elaborator-residual.sh).
# linear_metrics is G2 Mult free-safety residual greps (systems-linear-residual-metrics.sh).
# qtt_depth is Track D UseCheck pure-fvar + bif* splitter completeness (systems-qtt-depth-check.sh).
#
# Env:
#   SYSTEMS_LEAN_VALIDATE_FULL=1       — freestanding `make check` (heavier: run main.c + gates)
#   SYSTEMS_LEAN_VALIDATE_SKIP_FS=1    — skip freestanding_check Makefile targets
#   SYSTEMS_LEAN_VALIDATE_SKIP_NEG=1   — skip negative suites
#   SYSTEMS_LEAN_VALIDATE_QUIET=1      — less per-gate chatter (scoreboard still prints)
#   SYSTEMS_LEAN_COMPLIANT_*           — forwarded to compliant scripts
#   SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST / SYSTEMS_LEAN_PRODUCT_IR_ROOT — product_stdlib
#   SYSTEMS_LEAN_TCB_*                 — forwarded to systems-tcb-inventory (REQUIRE optional)
#   SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR — refuse unless residual_free earned
#
# freestanding_check default vs FULL:
#   Default (FULL unset/0): `make check-nm` + residual IR greps + Par dual-path isolation
#   (`systems-par-dual-path-check.sh`) — pins T lean_fs_* / Track A exports; product Par
#   sequential isolation tokens; does **not** execute main.c stdout smokes.
#   SYSTEMS_LEAN_VALIDATE_FULL=1: `make check` (run + check-nm + gates + host + dual-path)
#   so main.c Track A printf markers (u64_*/bv_*/set_*) are grepped. Prefer FULL after PRODUCT growth.
#   Export existence alone is already covered by check-nm T-symbol pins (Track A included).
#   Opt-in Par host dogfood (`make check-par-pthread` / `check-par-simd-hw`) is **not** validate.
#
# Usage (lean4 root; stage1 lean preferred on PATH):
#   ./script/systems-validate.sh
#   SYSTEMS_LEAN_VALIDATE_FULL=1 ./script/systems-validate.sh
#   make -C tests/lake/examples/systems validate-systems
#   nix develop .#systems --command systems-validate   # systems.nix front door
#   # alias shell: nix develop .#systems-dev  (portable rg, nm, make, …)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export PATH="${PATH:-}"
if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
  export PATH="$ROOT/build/release/stage1/bin:$PATH"
fi
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-/usr/lib:/lib:/usr/lib/x86_64-linux-gnu}"

FS_EXAMPLE="$ROOT/tests/lake/examples/systems"
IR_DIR="${SYSTEMS_LEAN_COMPLIANT_IR_DIR:-$FS_EXAMPLE/lib/.lake/build/ir}"
EXTRACT="${SYSTEMS_LEAN_COMPLIANT_EXTRACT:-$IR_DIR/Extract.c}"
BUNDLE="${SYSTEMS_LEAN_COMPLIANT_BUNDLE:-$FS_EXAMPLE/lib/.lake/build/lib/libfs_extract_bundle.a}"

# shellcheck source=systems-residual-policy.sh
source "$ROOT/script/systems-residual-policy.sh"
# shellcheck source=systems-tcb-honesty-check.sh
source "$ROOT/script/systems-tcb-honesty-check.sh"
# shellcheck source=systems-host-elaborator-residual.sh
source "$ROOT/script/systems-host-elaborator-residual.sh"

pass_n=0
fail_n=0
skip_n=0
declare -A GATE_STATUS=()

quiet=0
[[ "${SYSTEMS_LEAN_VALIDATE_QUIET:-0}" == "1" ]] && quiet=1

log() {
  if [[ "$quiet" -eq 0 ]]; then
    printf '%s\n' "$*" >&2
  fi
}

set_gate() {
  local name="$1" status="$2"
  GATE_STATUS["$name"]="$status"
  case "$status" in
    PASS) pass_n=$((pass_n + 1)) ;;
    FAIL) fail_n=$((fail_n + 1)) ;;
    SKIP) skip_n=$((skip_n + 1)) ;;
    *)
      echo "INTERNAL: bad gate status $status for $name" >&2
      exit 2
      ;;
  esac
}

run_capture() {
  local -a cmd=("$@")
  set +e
  OUT="$("${cmd[@]}" 2>&1)"
  RC=$?
  set -e
}

# True when ccomp is discoverable for dogfood (RESULT / ref launcher / PATH / in-tree).
has_ccomp_tool() {
  [[ -x "$ROOT/ref/bin/ccomp" ]] && return 0
  [[ -x "$ROOT/ref/CompCert/ccomp" ]] && return 0
  [[ -x "$ROOT/result-compcert/bin/ccomp" ]] && return 0
  [[ -n "${SYSTEMS_LEAN_COMPCERT_RESULT:-}" && -x "${SYSTEMS_LEAN_COMPCERT_RESULT}/bin/ccomp" ]] && return 0
  command -v ccomp >/dev/null 2>&1 && return 0
  return 1
}

# --- residual_nm (nm residual only; product GC claim is GATE product_gc_free / scoreboard) ---
log "--- residual_nm (systems-selfhost-link-check; nm residual only) ---"
chmod +x "$ROOT/script/systems-selfhost-link-check.sh" 2>/dev/null || true
NM_OUT=""
NM_RC=1
if [[ ! -f "$BUNDLE" ]]; then
  log "NOTE: missing bundle $BUNDLE — attempting freestanding lake build"
  if command -v lake >/dev/null 2>&1 || [[ -x "$ROOT/build/release/stage1/bin/lake" ]]; then
    LAKE_BIN="${LAKE_BIN:-}"
    if [[ -z "$LAKE_BIN" ]]; then
      if [[ -x "$ROOT/build/release/stage1/bin/lake" ]]; then
        LAKE_BIN="$ROOT/build/release/stage1/bin/lake"
      else
        LAKE_BIN="$(command -v lake)"
      fi
    fi
    run_capture "$LAKE_BIN" --dir="$FS_EXAMPLE/lib" build
    log "$OUT"
  fi
fi
if [[ ! -f "$BUNDLE" ]]; then
  log "FAIL: freestanding bundle missing: $BUNDLE"
  set_gate residual_nm FAIL
else
  run_capture "$ROOT/script/systems-selfhost-link-check.sh" "$BUNDLE"
  NM_OUT="$OUT"
  NM_RC="$RC"
  log "$OUT"
  if [[ "$RC" -eq 0 ]]; then
    set_gate residual_nm PASS
  else
    set_gate residual_nm FAIL
  fi
fi

# --- residual_ir ---
log "--- residual_ir (systems-residual-policy product matrix) ---"
if [[ ! -f "$EXTRACT" ]]; then
  log "FAIL: missing Extract C: $EXTRACT"
  set_gate residual_ir FAIL
else
  set +e
  ir_out="$(systems_lean_check_product_ir_residuals "$IR_DIR" "$EXTRACT" 2>&1)"
  ir_rc=$?
  set -e
  log "$ir_out"
  if [[ "$ir_rc" -eq 0 ]]; then
    set_gate residual_ir PASS
  else
    set_gate residual_ir FAIL
  fi
fi

# --- product_gc_free (residual_nm ∧ residual_ir ∧ tokens from residual_nm link-check transcript) ---
# Proves Lean GC/RC is not on the product embed link/IR path. Not host elaborator GC-free.
# Reuses NM_OUT from residual_nm (no second nm pass). Scoreboard PRODUCT_* is authoritative.
log "--- product_gc_free (product wire GC/RC residual) ---"
if [[ "${GATE_STATUS[residual_nm]:-}" == "PASS" && "${GATE_STATUS[residual_ir]:-}" == "PASS" ]]; then
  if [[ "$NM_RC" -eq 0 ]] \
    && printf '%s\n' "$NM_OUT" | grep -qx 'PRODUCT_GC_FREE=1' \
    && printf '%s\n' "$NM_OUT" | grep -qx 'PRODUCT_NO_LEANSHARED=1'; then
    set_gate product_gc_free PASS
  elif [[ "$NM_RC" -ne 0 ]]; then
    log "FAIL: product_gc_free: residual_nm was PASS but link-check transcript RC=$NM_RC (internal inconsistency)"
    set_gate product_gc_free FAIL
  else
    log "FAIL: residual_nm∧residual_ir PASS but link-check transcript missing PRODUCT_GC_FREE=1 / PRODUCT_NO_LEANSHARED=1"
    set_gate product_gc_free FAIL
  fi
else
  log "FAIL: product_gc_free requires residual_nm=${GATE_STATUS[residual_nm]:-unset} and residual_ir=${GATE_STATUS[residual_ir]:-unset} both PASS"
  set_gate product_gc_free FAIL
fi

# --- product_stdlib (PRODUCT_STDLIB_MODULES manifest gate + B2 corpus align) ---
# Greppable: PRODUCT_STDLIB_MODULES_OK=1 and PRODUCT_CORPUS_ALIGN_OK=1
log "--- product_stdlib (PRODUCT_STDLIB_MODULES) ---"
chmod +x "$ROOT/script/systems-product-stdlib-check.sh" 2>/dev/null || true
if [[ ! -f "$ROOT/script/systems-product-stdlib-check.sh" ]]; then
  log "FAIL: missing systems-product-stdlib-check.sh"
  set_gate product_stdlib FAIL
else
  run_capture env \
    SYSTEMS_LEAN_PRODUCT_IR_ROOT="${SYSTEMS_LEAN_PRODUCT_IR_ROOT:-$IR_DIR}" \
    "$ROOT/script/systems-product-stdlib-check.sh"
  log "$OUT"
  if [[ "$RC" -eq 0 ]] \
    && printf '%s\n' "$OUT" | grep -qx 'PRODUCT_STDLIB_MODULES_OK=1' \
    && printf '%s\n' "$OUT" | grep -qx 'PRODUCT_CORPUS_ALIGN_OK=1'; then
    set_gate product_stdlib PASS
  else
    set_gate product_stdlib FAIL
  fi
fi

# --- sorry_free ---
log "--- sorry_free (ComplianceCorpus) ---"
chmod +x "$ROOT/script/systems-sorry-free-check.sh" 2>/dev/null || true
run_capture "$ROOT/script/systems-sorry-free-check.sh"
log "$OUT"
if [[ "$RC" -eq 0 ]]; then
  set_gate sorry_free PASS
else
  set_gate sorry_free FAIL
fi

# --- axiom_auto (TCB axiom allowlist over ComplianceCorpus; W7.C5) ---
log "--- axiom_auto (ComplianceCorpus TCB allowlist) ---"
chmod +x "$ROOT/script/systems-axiom-check.sh" 2>/dev/null || true
if [[ ! -f "$ROOT/script/systems-axiom-check.sh" ]]; then
  log "FAIL: missing systems-axiom-check.sh"
  set_gate axiom_auto FAIL
else
  run_capture "$ROOT/script/systems-axiom-check.sh"
  log "$OUT"
  # Production pin policy: path-only dense FFI is exactly Scalars+Sys (count=2).
  # Fixtures may use other counts when SYSTEMS_LEAN_TCB_AXIOM_ALLOWLIST is overridden;
  # validate uses the default allowlist only.
  if [[ "$RC" -eq 0 ]] \
    && printf '%s\n' "$OUT" | grep -qx 'AXIOM_AUTO_GATE_OK=1' \
    && printf '%s\n' "$OUT" | grep -qx 'AXIOM_ALLOWLIST_PATH_ONLY_COUNT=2' \
    && printf '%s\n' "$OUT" | grep -qE '^AXIOM_ALLOWLIST_NAME_PIN_COUNT=[1-9][0-9]*$'; then
    set_gate axiom_auto PASS
  else
    set_gate axiom_auto FAIL
  fi
fi

# --- tcb_honesty (host elaborator vs product embed; G3 measured dual path) ---
# Shared checker: script/systems-tcb-honesty-check.sh (also used by negatives).
# Classic path: GC_FREE_ELABORATOR=0 + classic TCB. Earn path: GC_FREE=1 only with
# residual_free evidence. Exactly one TCB_HONESTY_OK=1. No PRODUCT_FS_NEXT / REQUIRE=1.
# Product validate pins stage1 lean unless SYSTEMS_LEAN_HOST_ELAB_ALLOW_OVERRIDE=1.
log "--- tcb_honesty (host vs product TCB tokens) ---"
chmod +x "$ROOT/script/systems-tcb-inventory.sh" 2>/dev/null || true
if [[ ! -f "$ROOT/script/systems-tcb-inventory.sh" ]]; then
  log "FAIL: missing systems-tcb-inventory.sh"
  set_gate tcb_honesty FAIL
elif ! declare -F systems_lean_tcb_honesty_tokens_ok >/dev/null 2>&1; then
  log "FAIL: systems_lean_tcb_honesty_tokens_ok not loaded (systems-tcb-honesty-check.sh)"
  set_gate tcb_honesty FAIL
else
  # Build env: clear FORCE; pin lean path + residual tools for product validate.
  tcb_env=(env -u SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR)
  if [[ "${SYSTEMS_LEAN_HOST_ELAB_ALLOW_OVERRIDE:-0}" != "1" ]]; then
    tcb_env+=(-u SYSTEMS_LEAN_HOST_ELAB_LEAN)
    if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
      tcb_env+=(
        SYSTEMS_LEAN_TCB_LEAN="$ROOT/build/release/stage1/bin/lean"
        SYSTEMS_LEAN_HOST_ELAB_LEAN="$ROOT/build/release/stage1/bin/lean"
      )
    else
      tcb_env+=(-u SYSTEMS_LEAN_TCB_LEAN)
    fi
    [[ -x /usr/bin/readelf ]] && tcb_env+=(SYSTEMS_LEAN_HOST_READELF=/usr/bin/readelf)
    [[ -x /usr/bin/objdump ]] && tcb_env+=(SYSTEMS_LEAN_HOST_OBJDUMP=/usr/bin/objdump)
    [[ -x /usr/bin/od ]] && tcb_env+=(SYSTEMS_LEAN_HOST_OD=/usr/bin/od)
  fi
  run_capture "${tcb_env[@]}" "$ROOT/script/systems-tcb-inventory.sh"
  log "$OUT"
  tcb_ok=1
  if [[ "$RC" -ne 0 ]]; then
    tcb_ok=0
  fi
  if ! printf '%s\n' "$OUT" | systems_lean_tcb_honesty_tokens_ok; then
    log "FAIL: tcb_honesty token check failed (classic: GC_FREE=0+classic TCB; earn: residual_free evidence; exactly one TCB_HONESTY_OK=1)"
    tcb_ok=0
  fi
  # Refuse inventory claiming GC_FREE=1 while HOST_HAS_LEANSHARED=1 (forged dual path).
  if printf '%s\n' "$OUT" | grep -qx 'GC_FREE_ELABORATOR=1' \
    && printf '%s\n' "$OUT" | grep -qx 'HOST_HAS_LEANSHARED=1'; then
    log "FAIL: tcb_honesty GC_FREE_ELABORATOR=1 with HOST_HAS_LEANSHARED=1"
    tcb_ok=0
  fi
  if [[ "$tcb_ok" -eq 1 ]]; then
    set_gate tcb_honesty PASS
  else
    set_gate tcb_honesty FAIL
  fi
fi

# --- host_elaborator (G3 measured host residual; staged — classic shared is PASS) ---
# systems-host-elaborator-residual.sh measures lean NEEDED (readelf/objdump earn; ldd never earns).
# PASS when residual tokens consistent: measured GC_FREE=0 + classic shared runtime is staged
# G3 PASS; FAIL if GC_FREE=1 while shared present / residual tokens inconsistent.
# Not a claim that the elaborator was rewritten without RC.
# Product validate pins stage1 lean (same ALLOW_OVERRIDE as tcb_honesty).
log "--- host_elaborator (G3 host residual measurement) ---"
HOST_ELAB_OUT=""
HOST_ELAB_RC=1
chmod +x "$ROOT/script/systems-host-elaborator-residual.sh" 2>/dev/null || true
if [[ ! -f "$ROOT/script/systems-host-elaborator-residual.sh" ]]; then
  log "FAIL: missing systems-host-elaborator-residual.sh"
  set_gate host_elaborator FAIL
elif ! declare -F systems_lean_host_elab_tokens_ok >/dev/null 2>&1; then
  log "FAIL: systems_lean_host_elab_tokens_ok not loaded"
  set_gate host_elaborator FAIL
else
  host_env=(env -u SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR)
  if [[ "${SYSTEMS_LEAN_HOST_ELAB_ALLOW_OVERRIDE:-0}" != "1" ]]; then
    host_env+=(-u SYSTEMS_LEAN_HOST_ELAB_LEAN)
    if [[ -x "$ROOT/build/release/stage1/bin/lean" ]]; then
      host_env+=(
        SYSTEMS_LEAN_TCB_LEAN="$ROOT/build/release/stage1/bin/lean"
        SYSTEMS_LEAN_HOST_ELAB_LEAN="$ROOT/build/release/stage1/bin/lean"
      )
    else
      host_env+=(-u SYSTEMS_LEAN_TCB_LEAN)
    fi
    # Pin residual tools to absolute /usr/bin paths when present (hostile-PATH resistant).
    [[ -x /usr/bin/readelf ]] && host_env+=(SYSTEMS_LEAN_HOST_READELF=/usr/bin/readelf)
    [[ -x /usr/bin/objdump ]] && host_env+=(SYSTEMS_LEAN_HOST_OBJDUMP=/usr/bin/objdump)
    [[ -x /usr/bin/od ]] && host_env+=(SYSTEMS_LEAN_HOST_OD=/usr/bin/od)
  fi
  run_capture "${host_env[@]}" "$ROOT/script/systems-host-elaborator-residual.sh"
  HOST_ELAB_OUT="$OUT"
  HOST_ELAB_RC="$RC"
  log "$OUT"
  host_elab_ok=1
  if [[ "$RC" -ne 0 ]]; then
    host_elab_ok=0
  fi
  if ! printf '%s\n' "$OUT" | systems_lean_host_elab_tokens_ok; then
    log "FAIL: host_elaborator residual token check failed"
    host_elab_ok=0
  fi
  if printf '%s\n' "$OUT" | grep -qx 'GC_FREE_ELABORATOR=1' \
    && printf '%s\n' "$OUT" | grep -qx 'HOST_HAS_LEANSHARED=1'; then
    log "FAIL: host_elaborator GC_FREE_ELABORATOR=1 with HOST_HAS_LEANSHARED=1"
    host_elab_ok=0
  fi
  if [[ "$host_elab_ok" -eq 1 ]]; then
    set_gate host_elaborator PASS
  else
    set_gate host_elaborator FAIL
  fi
fi

# --- linear_metrics (G2 Mult/FreeSafety mult-policy residual; local source greps) ---
# Cheap + deterministic: greps Multiplicity/FreeSafety markers + theorem bodies.
# Not elaborator UseCheck completeness; not GC_FREE_ELABORATOR; not residual_nm/ir.
# Product path: pin $ROOT/src (clear ambient SYSTEMS_LEAN_LINEAR_METRICS_* overrides).
log "--- linear_metrics (G2 Mult free-safety residual greps) ---"
chmod +x "$ROOT/script/systems-linear-residual-metrics.sh" 2>/dev/null || true
LINEAR_OUT=""
LINEAR_RC=1
if [[ ! -f "$ROOT/script/systems-linear-residual-metrics.sh" ]]; then
  log "FAIL: missing systems-linear-residual-metrics.sh"
  set_gate linear_metrics FAIL
else
  run_capture env -u SYSTEMS_LEAN_LINEAR_METRICS_MULT \
    -u SYSTEMS_LEAN_LINEAR_METRICS_FREESAFETY \
    -u SYSTEMS_LEAN_LINEAR_METRICS_THEOREMS \
    -u SYSTEMS_LEAN_LINEAR_METRICS_ALLOW_OVERRIDE \
    "$ROOT/script/systems-linear-residual-metrics.sh"
  LINEAR_OUT="$OUT"
  LINEAR_RC="$RC"
  log "$OUT"
  if [[ "$RC" -eq 0 ]] \
    && printf '%s\n' "$OUT" | grep -qx 'LINEAR_RESIDUAL_METRICS_OK=1' \
    && printf '%s\n' "$OUT" | grep -qx 'LINEAR_SECOND_USE_IMPOSSIBLE=1' \
    && printf '%s\n' "$OUT" | grep -qx 'MULT0_NON_RUNTIME_POLICY=1' \
    && printf '%s\n' "$OUT" | grep -qx 'PRODUCT_RESIDUAL_MULT_POLICY=1' \
    && printf '%s\n' "$OUT" | grep -qx 'LINEAR_NO_SILENT_DROP=1' \
    && printf '%s\n' "$OUT" | grep -qx 'FREE_SAFETY_FORMAL_LAYER=1'; then
    set_gate linear_metrics PASS
  else
    set_gate linear_metrics FAIL
  fi
fi

# --- qtt_depth (Track D UseCheck pure-fvar + freestanding bif* splitter SSoT) ---
# Cheap + deterministic: greps UseCheck + Systems product sources only.
# Not Mult algebra tables; not full elaborator completeness; not GC_FREE_ELABORATOR.
log "--- qtt_depth (Track D UseCheck pure-fvar + bif* splitter completeness) ---"
chmod +x "$ROOT/script/systems-qtt-depth-check.sh" 2>/dev/null || true
QTT_DEPTH_OUT=""
QTT_DEPTH_RC=1
if [[ ! -f "$ROOT/script/systems-qtt-depth-check.sh" ]]; then
  log "FAIL: missing systems-qtt-depth-check.sh"
  set_gate qtt_depth FAIL
else
  run_capture env -u SYSTEMS_LEAN_QTT_DEPTH_USECHECK \
    -u SYSTEMS_LEAN_QTT_DEPTH_FREESTANDING \
    -u SYSTEMS_LEAN_QTT_DEPTH_ALLOW_OVERRIDE \
    "$ROOT/script/systems-qtt-depth-check.sh"
  QTT_DEPTH_OUT="$OUT"
  QTT_DEPTH_RC="$RC"
  log "$OUT"
  if [[ "$RC" -eq 0 ]] \
    && printf '%s\n' "$OUT" | grep -qx 'QTT_DEPTH_OK=1' \
    && printf '%s\n' "$OUT" | grep -qx 'QTT_USECHECK_DISTINCT_PURE_FVAR=1' \
    && printf '%s\n' "$OUT" | grep -qx 'QTT_SPLITTER_BIF_COMPLETE=1'; then
    set_gate qtt_depth PASS
  else
    set_gate qtt_depth FAIL
  fi
fi

# --- qtt_elab ---
log "--- qtt_elab (elab tests: formal + binder + use_check) ---"
qtt_ok=1
if [[ ! -f "$ROOT/tests/with_stage1_test_env.sh" ]]; then
  log "FAIL: missing tests/with_stage1_test_env.sh"
  qtt_ok=0
else
  chmod +x "$ROOT/tests/with_stage1_test_env.sh" 2>/dev/null || true
  for t in qtt_formal_layer.lean qtt_binder_mult.lean qtt_use_check.lean; do
    log "  elab: $t"
    run_capture "$ROOT/tests/with_stage1_test_env.sh" "$ROOT/tests/elab/run_test.sh" "$t"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: elab test $t (exit $RC)"
      qtt_ok=0
    fi
  done
fi
if [[ "$qtt_ok" -eq 1 ]]; then
  set_gate qtt_elab PASS
else
  set_gate qtt_elab FAIL
fi

# --- freestanding_check ---
# Track C Par dual-path tokens (optional re-emit on scoreboard).
PAR_DUAL_OUT=""
log "--- freestanding_check ---"
if [[ "${SYSTEMS_LEAN_VALIDATE_SKIP_FS:-0}" == "1" ]]; then
  log "NOTE: freestanding_check skipped (SYSTEMS_LEAN_VALIDATE_SKIP_FS=1)"
  set_gate freestanding_check SKIP
elif [[ ! -d "$FS_EXAMPLE" ]]; then
  log "FAIL: missing freestanding at $FS_EXAMPLE"
  set_gate freestanding_check FAIL
else
  if [[ "${SYSTEMS_LEAN_VALIDATE_FULL:-0}" == "1" ]]; then
    log "FULL: make -C freestanding check"
    run_capture make -C "$FS_EXAMPLE" check
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 40 >&2 || true
    fi
    if [[ "$RC" -eq 0 ]]; then
      # FULL includes check-par-dual-path; require dual-path transcript for scoreboard
      # (never invent PARALLELISM_*=1). Missing dual-path OK → freestanding_check FAIL.
      chmod +x "$ROOT/script/systems-par-dual-path-check.sh" 2>/dev/null || true
      if [[ -f "$BUNDLE" && -f "$ROOT/script/systems-par-dual-path-check.sh" ]]; then
        set +e
        PAR_DUAL_OUT="$("$ROOT/script/systems-par-dual-path-check.sh" "$BUNDLE" 2>&1)"
        par_rc=$?
        set -e
        if [[ "$par_rc" -ne 0 ]] || ! printf '%s\n' "$PAR_DUAL_OUT" | grep -qx 'PARALLELISM_DUAL_PATH_OK=1'; then
          log "FAIL: systems-par-dual-path-check after FULL make check"
          if [[ "$quiet" -eq 0 ]]; then
            printf '%s\n' "$PAR_DUAL_OUT" | tail -n 20 >&2 || true
          fi
          PAR_DUAL_OUT=""
          set_gate freestanding_check FAIL
        else
          set_gate freestanding_check PASS
        fi
      else
        log "FAIL: missing bundle or systems-par-dual-path-check.sh for FULL scoreboard"
        PAR_DUAL_OUT=""
        set_gate freestanding_check FAIL
      fi
    else
      set_gate freestanding_check FAIL
    fi
  else
    fs_ok=1
    run_capture make -C "$FS_EXAMPLE" check-nm
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 15 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      fs_ok=0
    fi
    run_capture make -C "$FS_EXAMPLE" check-ir
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 15 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      fs_ok=0
    fi
    # Track C1: product Par dual-path isolation (sequential L2; no pthread on residual).
    chmod +x "$ROOT/script/systems-par-dual-path-check.sh" 2>/dev/null || true
    if [[ -f "$ROOT/script/systems-par-dual-path-check.sh" ]]; then
      run_capture "$ROOT/script/systems-par-dual-path-check.sh" "$BUNDLE"
      if [[ "$quiet" -eq 0 ]]; then
        printf '%s\n' "$OUT" | tail -n 20 >&2 || true
      fi
      if [[ "$RC" -ne 0 ]] || ! printf '%s\n' "$OUT" | grep -qx 'PARALLELISM_DUAL_PATH_OK=1'; then
        log "FAIL: systems-par-dual-path-check (product Parallelism isolation)"
        fs_ok=0
      else
        # Stash tokens for scoreboard re-emit (product sequential honesty).
        PAR_DUAL_OUT="$OUT"
      fi
    else
      log "FAIL: missing systems-par-dual-path-check.sh"
      fs_ok=0
    fi
    if [[ "$fs_ok" -eq 1 ]]; then
      set_gate freestanding_check PASS
    else
      set_gate freestanding_check FAIL
    fi
  fi
fi

# --- compcert_dogfood ---
# SKIP only when no ccomp tool is discoverable *before* running the gate.
# Non-zero from the gate is always FAIL (product/cert residual) — never remapped to SKIP.
log "--- compcert_dogfood ---"
chmod +x "$ROOT/script/systems-compcert-compliant.sh" 2>/dev/null || true
if ! has_ccomp_tool; then
  log "NOTE: no ccomp tool discoverable — SKIP dogfood (tool missing, not product FAIL)"
  set_gate compcert_dogfood SKIP
else
  run_capture env SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
    SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD="${SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD:-1}" \
    "$ROOT/script/systems-compcert-compliant.sh"
  if [[ "$quiet" -eq 0 ]]; then
    printf '%s\n' "$OUT" | tail -n 30 >&2 || true
  fi
  if [[ "$RC" -eq 0 ]] && printf '%s\n' "$OUT" | grep -qE '^(COMPCERT_DOGFOOD=1|PROVABLY_COMPCERT_COMPLIANT=1)$'; then
    set_gate compcert_dogfood PASS
  else
    log "FAIL: dogfood gate exit=$RC (product/cert failure; not remapped to SKIP)"
    set_gate compcert_dogfood FAIL
  fi
fi

# --- compcert_provably ---
# SKIP when no real in-tree binary; never treat shell launcher under CompCert as ready.
log "--- compcert_provably ---"
provably_bin="$ROOT/ref/CompCert/ccomp"
provably_ready=0
if [[ -x "$provably_bin" || -f "$provably_bin" ]]; then
  # Match systems-compcert-compliant.sh is_real_compcert_binary intent (no shebang).
  if ! head -c 2 "$provably_bin" 2>/dev/null | grep -q $'#!'; then
    if command -v file >/dev/null 2>&1; then
      desc="$(file -b "$provably_bin" 2>/dev/null || true)"
      if ! printf '%s' "$desc" | grep -qiE 'shell script|ASCII text|UTF-8 Unicode text|Bourne|bash script'; then
        if printf '%s' "$desc" | grep -qiE 'ELF|Mach-O|PE32|executable'; then
          provably_ready=1
        fi
      fi
    else
      # No file(1): non-shebang executable counts as candidate; compliant script re-checks.
      provably_ready=1
    fi
  else
    log "NOTE: ref/CompCert/ccomp is a shell launcher — not PROVABLY-eligible"
  fi
fi
if [[ "$provably_ready" -eq 0 ]]; then
  log "NOTE: no real in-tree ref/CompCert/ccomp binary — SKIP PROVABLY (./ref/build-ccomp.sh)"
  set_gate compcert_provably SKIP
else
  run_capture env SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 \
    SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD="${SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD:-1}" \
    "$ROOT/script/systems-compcert-compliant.sh"
  if [[ "$quiet" -eq 0 ]]; then
    printf '%s\n' "$OUT" | tail -n 30 >&2 || true
  fi
  if [[ "$RC" -eq 0 ]] && printf '%s\n' "$OUT" | grep -qx 'PROVABLY_COMPCERT_COMPLIANT=1'; then
    set_gate compcert_provably PASS
  elif [[ "$RC" -eq 0 ]] && printf '%s\n' "$OUT" | grep -qx 'COMPCERT_DOGFOOD=1'; then
    log "NOTE: gate emitted DOGFOOD not PROVABLY — SKIP (resolved binary not real under ref/CompCert)"
    set_gate compcert_provably SKIP
  else
    set_gate compcert_provably FAIL
  fi
fi

# --- negatives (fail-closed suites) ---
log "--- negatives ---"
if [[ "${SYSTEMS_LEAN_VALIDATE_SKIP_NEG:-0}" == "1" ]]; then
  log "NOTE: negatives skipped (SYSTEMS_LEAN_VALIDATE_SKIP_NEG=1)"
  set_gate negatives SKIP
else
  neg_ok=1
  chmod +x \
    "$ROOT/script/systems-selfhost-link-check-negatives.sh" \
    "$ROOT/script/systems-compcert-compliant-negatives.sh" \
    "$ROOT/script/systems-axiom-check-negatives.sh" \
    "$ROOT/script/systems-product-stdlib-check-negatives.sh" \
    "$ROOT/script/systems-tcb-inventory-negatives.sh" \
    "$ROOT/script/systems-host-elaborator-residual-negatives.sh" \
    "$ROOT/script/systems-linear-residual-metrics-negatives.sh" \
    "$ROOT/script/systems-qtt-depth-check-negatives.sh" \
    "$ROOT/script/systems-qtt-depth-check.sh" \
    "$ROOT/script/systems-par-dual-path-check-negatives.sh" \
    "$ROOT/script/systems-par-dual-path-check.sh" \
    2>/dev/null || true

  # Always run link-check negatives: artifact cases need no CC; object residuals
  # skip cleanly when no compiler (suite exit 0). Prefer CC/cc/gcc when present.
  VALIDATE_CC="${CC:-}"
  if [[ -z "$VALIDATE_CC" ]]; then
    if command -v cc >/dev/null 2>&1; then
      VALIDATE_CC="$(command -v cc)"
    elif command -v gcc >/dev/null 2>&1; then
      VALIDATE_CC="$(command -v gcc)"
    fi
  fi
  if [[ -n "$VALIDATE_CC" ]]; then
    log "  systems-selfhost-link-check-negatives.sh (CC=$VALIDATE_CC)"
    run_capture env CC="$VALIDATE_CC" "$ROOT/script/systems-selfhost-link-check-negatives.sh"
  else
    log "  systems-selfhost-link-check-negatives.sh (artifact-only; no CC/cc/gcc)"
    run_capture env -u CC "$ROOT/script/systems-selfhost-link-check-negatives.sh"
  fi
  if [[ "$quiet" -eq 0 ]]; then
    printf '%s\n' "$OUT" | tail -n 15 >&2 || true
  fi
  if [[ "$RC" -ne 0 ]]; then
    log "FAIL: link-check negatives exit $RC"
    neg_ok=0
  fi

  if [[ ! -f "$BUNDLE" ]]; then
    log "NOTE: no freestanding bundle — compliant negatives require product artifacts"
    # Missing bundle already fails residual_nm; treat compliant negatives as fail-closed if we got here with no bundle after nm FAIL.
    if [[ "${GATE_STATUS[residual_nm]:-FAIL}" == "PASS" ]]; then
      log "FAIL: residual_nm PASS but bundle missing for compliant negatives"
      neg_ok=0
    fi
  else
    log "  systems-compcert-compliant-negatives.sh"
    run_capture "$ROOT/script/systems-compcert-compliant-negatives.sh"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: compliant negatives exit $RC"
      neg_ok=0
    fi
  fi

  # Axiom auto-gate negatives: no freestanding artifacts required.
  if [[ -f "$ROOT/script/systems-axiom-check-negatives.sh" ]]; then
    log "  systems-axiom-check-negatives.sh"
    run_capture "$ROOT/script/systems-axiom-check-negatives.sh"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: axiom-check negatives exit $RC"
      neg_ok=0
    fi
  else
    log "FAIL: missing systems-axiom-check-negatives.sh"
    neg_ok=0
  fi

  # B2 PRODUCT ↔ corpus alignment negatives (no freestanding IR required).
  if [[ -f "$ROOT/script/systems-product-stdlib-check-negatives.sh" ]]; then
    log "  systems-product-stdlib-check-negatives.sh"
    run_capture "$ROOT/script/systems-product-stdlib-check-negatives.sh"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: product-stdlib-check negatives exit $RC"
      neg_ok=0
    fi
  else
    log "FAIL: missing systems-product-stdlib-check-negatives.sh"
    neg_ok=0
  fi

  # TCB honesty negatives: forged GC_FREE_ELABORATOR=1, REQUIRE missing lean/bundle, residual.
  if [[ -f "$ROOT/script/systems-tcb-inventory-negatives.sh" ]]; then
    log "  systems-tcb-inventory-negatives.sh"
    run_capture "$ROOT/script/systems-tcb-inventory-negatives.sh"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: tcb-inventory negatives exit $RC"
      neg_ok=0
    fi
  else
    log "FAIL: missing systems-tcb-inventory-negatives.sh"
    neg_ok=0
  fi

  # G3 host elaborator residual negatives: forged GC_FREE=1 with shared, FORCE refuse, REQUIRE.
  if [[ -f "$ROOT/script/systems-host-elaborator-residual-negatives.sh" ]]; then
    log "  systems-host-elaborator-residual-negatives.sh"
    run_capture "$ROOT/script/systems-host-elaborator-residual-negatives.sh"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: host-elaborator-residual negatives exit $RC"
      neg_ok=0
    fi
  else
    log "FAIL: missing systems-host-elaborator-residual-negatives.sh"
    neg_ok=0
  fi

  # G2 linear residual mult-policy negatives: forged free-true markers, stripped lemmas.
  if [[ -f "$ROOT/script/systems-linear-residual-metrics-negatives.sh" ]]; then
    log "  systems-linear-residual-metrics-negatives.sh"
    run_capture "$ROOT/script/systems-linear-residual-metrics-negatives.sh"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: linear-residual-metrics negatives exit $RC"
      neg_ok=0
    fi
  else
    log "FAIL: missing systems-linear-residual-metrics-negatives.sh"
    neg_ok=0
  fi

  # Track D QTT depth negatives: stripped pure-fvar path, missing bif allowlist entry.
  if [[ -f "$ROOT/script/systems-qtt-depth-check-negatives.sh" ]]; then
    log "  systems-qtt-depth-check-negatives.sh"
    run_capture "$ROOT/script/systems-qtt-depth-check-negatives.sh"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: qtt-depth-check negatives exit $RC"
      neg_ok=0
    fi
  else
    log "FAIL: missing systems-qtt-depth-check-negatives.sh"
    neg_ok=0
  fi

  # Track C1: Par dual-path isolation negatives (pthread / HW SIMD must not PASS on product).
  if [[ -f "$ROOT/script/systems-par-dual-path-check-negatives.sh" ]]; then
    log "  systems-par-dual-path-check-negatives.sh"
    run_capture "$ROOT/script/systems-par-dual-path-check-negatives.sh"
    if [[ "$quiet" -eq 0 ]]; then
      printf '%s\n' "$OUT" | tail -n 20 >&2 || true
    fi
    if [[ "$RC" -ne 0 ]]; then
      log "FAIL: par-dual-path-check negatives exit $RC"
      neg_ok=0
    fi
  else
    log "FAIL: missing systems-par-dual-path-check-negatives.sh"
    neg_ok=0
  fi

  if [[ "$neg_ok" -eq 1 ]]; then
    set_gate negatives PASS
  else
    set_gate negatives FAIL
  fi
fi

# --- inventory_fs_ready ---
log "--- inventory_fs_ready ---"
chmod +x "$ROOT/script/systems-stdlib-inventory.sh" 2>/dev/null || true
inv_n=0
if [[ -f "$ROOT/script/systems-stdlib-inventory.sh" ]]; then
  set +e
  inv_out="$("$ROOT/script/systems-stdlib-inventory.sh" 2>&1)"
  inv_rc=$?
  set -e
  if [[ "$inv_rc" -eq 0 ]]; then
    if [[ "$inv_out" =~ fs-ready=([0-9]+) ]]; then
      inv_n="${BASH_REMATCH[1]}"
    else
      inv_n="$(find "$ROOT/src/Systems" -name '*.lean' 2>/dev/null | wc -l | tr -d ' ')"
    fi
  else
    inv_n="$(find "$ROOT/src/Systems" -name '*.lean' 2>/dev/null | wc -l | tr -d ' ')"
  fi
else
  inv_n="$(find "$ROOT/src/Systems" -name '*.lean' 2>/dev/null | wc -l | tr -d ' ')"
fi

# --- Scoreboard (stdout; PRODUCT_* here is authoritative for product GC claim) ---
echo "GATE residual_nm=${GATE_STATUS[residual_nm]}"
echo "GATE residual_ir=${GATE_STATUS[residual_ir]}"
echo "GATE product_gc_free=${GATE_STATUS[product_gc_free]}"
echo "GATE product_stdlib=${GATE_STATUS[product_stdlib]}"
echo "GATE sorry_free=${GATE_STATUS[sorry_free]}"
echo "GATE axiom_auto=${GATE_STATUS[axiom_auto]}"
echo "GATE tcb_honesty=${GATE_STATUS[tcb_honesty]}"
echo "GATE host_elaborator=${GATE_STATUS[host_elaborator]}"
echo "GATE linear_metrics=${GATE_STATUS[linear_metrics]}"
echo "GATE qtt_depth=${GATE_STATUS[qtt_depth]}"
echo "GATE qtt_elab=${GATE_STATUS[qtt_elab]}"
echo "GATE freestanding_check=${GATE_STATUS[freestanding_check]}"
echo "GATE compcert_dogfood=${GATE_STATUS[compcert_dogfood]}"
echo "GATE compcert_provably=${GATE_STATUS[compcert_provably]}"
echo "GATE negatives=${GATE_STATUS[negatives]}"
echo "GATE inventory_fs_ready=${inv_n}"
# Authoritative product GC wire tokens (match GATE product_gc_free; prefer these over inventory).
if [[ "${GATE_STATUS[product_gc_free]:-}" == "PASS" ]]; then
  echo "PRODUCT_GC_FREE=1"
  echo "PRODUCT_NO_LEANSHARED=1"
else
  echo "PRODUCT_GC_FREE=0"
  echo "PRODUCT_NO_LEANSHARED=0"
fi
# Authoritative G3 host elaborator residual tokens (match GATE host_elaborator measurement).
# Re-emit measured lines from residual gate transcript only (never hardcode OK=1).
if [[ "${GATE_STATUS[host_elaborator]:-}" == "PASS" && -n "${HOST_ELAB_OUT:-}" ]]; then
  _g3_reemit() {
    local key="$1" line
    line="$(printf '%s\n' "$HOST_ELAB_OUT" | grep -E "^${key}=" | tail -n 1 || true)"
    if [[ -n "$line" ]]; then
      printf '%s\n' "$line"
      return 0
    fi
    return 1
  }
  _g3_reemit 'HOST_HAS_LEANSHARED' || true
  if ! _g3_reemit 'HOST_ELABORATOR_RESIDUAL'; then
    echo "HOST_ELABORATOR_RESIDUAL=unmeasured"
  fi
  if ! _g3_reemit 'GC_FREE_ELABORATOR'; then
    echo "GC_FREE_ELABORATOR=0"
  fi
  if ! _g3_reemit 'HOST_ELABORATOR_RESIDUAL_OK'; then
    # Missing measured OK line on a PASS gate → fail-closed 0 (should not happen).
    echo "HOST_ELABORATOR_RESIDUAL_OK=0"
  fi
else
  echo "HOST_ELABORATOR_RESIDUAL=unmeasured"
  echo "GC_FREE_ELABORATOR=0"
  echo "HOST_ELABORATOR_RESIDUAL_OK=0"
fi
# Authoritative G2 linear residual mult-policy tokens (match GATE linear_metrics).
if [[ "${GATE_STATUS[linear_metrics]:-}" == "PASS" ]]; then
  echo "LINEAR_SECOND_USE_IMPOSSIBLE=1"
  echo "MULT0_NON_RUNTIME_POLICY=1"
  echo "PRODUCT_RESIDUAL_MULT_POLICY=1"
  echo "LINEAR_NO_SILENT_DROP=1"
  echo "FREE_SAFETY_FORMAL_LAYER=1"
  echo "LINEAR_RESIDUAL_METRICS_OK=1"
else
  echo "LINEAR_SECOND_USE_IMPOSSIBLE=0"
  echo "MULT0_NON_RUNTIME_POLICY=0"
  echo "PRODUCT_RESIDUAL_MULT_POLICY=0"
  echo "LINEAR_NO_SILENT_DROP=0"
  echo "FREE_SAFETY_FORMAL_LAYER=0"
  echo "LINEAR_RESIDUAL_METRICS_OK=0"
fi
# Authoritative Track D QTT UseCheck depth tokens — re-emit **only** from gate transcript.
# Never invent =1 (missing key → =0). Aligns with PAR dual-path scoreboard honesty.
_qtt_depth_scoreboard_token() {
  local key="$1"
  local line
  if [[ "${GATE_STATUS[qtt_depth]:-}" == "PASS" && -n "${QTT_DEPTH_OUT:-}" ]]; then
    line="$(printf '%s\n' "$QTT_DEPTH_OUT" | grep -E "^${key}=" | tail -n 1 || true)"
    if [[ -n "$line" ]]; then
      if [[ "$line" == "${key}=1" || "$line" == "${key}=0" ]]; then
        printf '%s\n' "$line"
        return 0
      fi
    fi
  fi
  printf '%s=0\n' "$key"
}
_qtt_depth_scoreboard_token 'QTT_USECHECK_DISTINCT_PURE_FVAR'
_qtt_depth_scoreboard_token 'QTT_SPLITTER_BIF_COMPLETE'
_qtt_depth_scoreboard_token 'QTT_DEPTH_OK'
# Track C Par dual-path isolation tokens — emit **only** from dual-path check transcript.
# Never invent =1 (missing key → =0). freestanding_check PASS requires transcript when dual-path ran.
_par_scoreboard_token() {
  local key="$1"
  local line
  if [[ -n "${PAR_DUAL_OUT:-}" ]]; then
    line="$(printf '%s\n' "$PAR_DUAL_OUT" | grep -E "^${key}=" | tail -n 1 || true)"
    if [[ -n "$line" ]]; then
      # Accept only exact =0 or =1 lines from the gate (no forged multi-token lines).
      if [[ "$line" == "${key}=1" || "$line" == "${key}=0" ]]; then
        printf '%s\n' "$line"
        return 0
      fi
    fi
  fi
  printf '%s=0\n' "$key"
}
_par_scoreboard_token 'PRODUCT_PARALLELISM_L2_SEQUENTIAL'
_par_scoreboard_token 'PRODUCT_PARALLELISM_NO_PTHREAD'
_par_scoreboard_token 'PRODUCT_PARALLELISM_L1_SHAPED_ONLY'
_par_scoreboard_token 'PARALLELISM_DUAL_PATH_OK'
_par_scoreboard_token 'CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED'
echo "SCORE pass=${pass_n} fail=${fail_n} skip=${skip_n}"

# Core integrity exit policy:
#   residual_nm + residual_ir + product_gc_free + product_stdlib + sorry_free + axiom_auto +
#   tcb_honesty + host_elaborator + linear_metrics + qtt_depth + qtt_elab + freestanding_check must PASS
#   dogfood must not FAIL (PASS or SKIP ok)
#   negatives must not FAIL (PASS or SKIP ok)
#   freestanding_check SKIP only when explicitly skipped — counts as not PASS → fail exit
core_ok=1
for g in residual_nm residual_ir product_gc_free product_stdlib sorry_free axiom_auto tcb_honesty host_elaborator linear_metrics qtt_depth qtt_elab freestanding_check; do
  if [[ "${GATE_STATUS[$g]:-}" != "PASS" ]]; then
    core_ok=0
  fi
done
if [[ "${GATE_STATUS[compcert_dogfood]:-}" == "FAIL" ]]; then
  core_ok=0
fi
if [[ "${GATE_STATUS[negatives]:-}" == "FAIL" ]]; then
  core_ok=0
fi

if [[ "$core_ok" -eq 1 ]]; then
  exit 0
fi
exit 1
