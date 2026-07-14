#!/usr/bin/env bash
# Shared TCB honesty token checker for systems-tcb-inventory / systems-validate.
#
# Sourced by:
#   script/systems-validate.sh
#   script/systems-tcb-inventory-negatives.sh
#   script/systems-host-elaborator-residual-negatives.sh (optional)
#
#   # shellcheck source=systems-tcb-honesty-check.sh
#   source "$ROOT/script/systems-tcb-honesty-check.sh"
#
# Dual path (G3 measured host residual vs product embed):
#
# Classic host (stage1 today — measured shared runtime present):
#   HOST_ELABORATOR_TCB=classic_RC_shared_runtime
#   PRODUCT_EMBED_TCB=residual_free_goal
#   GC_FREE_ELABORATOR=0   (and never =1)
#   TCB_HONESTY_OK=1       (exactly one =1 line; no TCB_HONESTY_OK=0)
#
# Residual-free host (earned only when measurement proves no leanshared/Init_shared):
#   HOST_ELABORATOR_TCB=residual_free
#   HOST_ELABORATOR_RESIDUAL=residual_free
#   HOST_HAS_LEANSHARED=0
#   PRODUCT_EMBED_TCB=residual_free_goal
#   GC_FREE_ELABORATOR=1   (exactly one =1; no =0)
#   TCB_HONESTY_OK=1
#
# Always reject:
#   * dual TCB_HONESTY_OK=0 and =1
#   * GC_FREE_ELABORATOR=1 with classic TCB / classic residual / HOST_HAS_LEANSHARED=1
#   * GC_FREE_ELABORATOR=1 without residual_free evidence tokens
#
# PRODUCT_FS_NEXT= is inventory emission only — not required by this checker.
# HOST_HAS_LEANSHARED= is required for residual_free earn path; optional for classic.
#
# Usage:
#   systems_lean_tcb_honesty_tokens_ok /path/to/out.txt
#   systems_lean_tcb_honesty_tokens_ok <<<"$OUT"
#   printf '%s\n' "$OUT" | systems_lean_tcb_honesty_tokens_ok
# Returns 0 on PASS-quality tokens, 1 otherwise.

systems_lean_tcb_honesty_tokens_ok() {
  local text
  if [[ $# -ge 1 && -n "${1:-}" && "$1" != "-" ]]; then
    if [[ ! -f "$1" ]]; then
      return 1
    fi
    text="$(cat -- "$1")"
  else
    text="$(cat)"
  fi

  local ok1 ok0 gc0 gc1 host_classic host_free prod has0 has1 residual_free residual_classic

  ok1="$(printf '%s\n' "$text" | grep -cx 'TCB_HONESTY_OK=1' || true)"
  ok0="$(printf '%s\n' "$text" | grep -cx 'TCB_HONESTY_OK=0' || true)"
  gc0="$(printf '%s\n' "$text" | grep -cx 'GC_FREE_ELABORATOR=0' || true)"
  gc1="$(printf '%s\n' "$text" | grep -cx 'GC_FREE_ELABORATOR=1' || true)"
  host_classic="$(printf '%s\n' "$text" | grep -cx 'HOST_ELABORATOR_TCB=classic_RC_shared_runtime' || true)"
  host_free="$(printf '%s\n' "$text" | grep -cx 'HOST_ELABORATOR_TCB=residual_free' || true)"
  prod="$(printf '%s\n' "$text" | grep -cx 'PRODUCT_EMBED_TCB=residual_free_goal' || true)"
  has0="$(printf '%s\n' "$text" | grep -cx 'HOST_HAS_LEANSHARED=0' || true)"
  has1="$(printf '%s\n' "$text" | grep -cx 'HOST_HAS_LEANSHARED=1' || true)"
  residual_free="$(printf '%s\n' "$text" | grep -cx 'HOST_ELABORATOR_RESIDUAL=residual_free' || true)"
  residual_classic="$(printf '%s\n' "$text" | grep -cx 'HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime' || true)"

  # Exactly one success honesty line; dual OK=0+OK=1 or missing OK=1 → fail.
  [[ "${ok1:-0}" -eq 1 ]] || return 1
  [[ "${ok0:-0}" -eq 0 ]] || return 1
  # Product embed goal always required.
  [[ "${prod:-0}" -ge 1 ]] || return 1

  # Exactly one GC_FREE line.
  if [[ "$(( ${gc0:-0} + ${gc1:-0} ))" -ne 1 ]]; then
    return 1
  fi

  # Dual HOST_HAS_LEANSHARED=0 and =1 → reject.
  if [[ "${has0:-0}" -ge 1 && "${has1:-0}" -ge 1 ]]; then
    return 1
  fi
  [[ "${has0:-0}" -le 1 ]] || return 1
  [[ "${has1:-0}" -le 1 ]] || return 1

  # --- residual_free earn path (GC_FREE_ELABORATOR=1) ---
  if [[ "${gc1:-0}" -ge 1 ]]; then
    # Refuse forged =1 without measurement evidence.
    [[ "${has1:-0}" -eq 0 ]] || return 1
    [[ "${has0:-0}" -eq 1 ]] || return 1
    [[ "${host_free:-0}" -ge 1 ]] || return 1
    [[ "${host_classic:-0}" -eq 0 ]] || return 1
    [[ "${residual_free:-0}" -ge 1 ]] || return 1
    [[ "${residual_classic:-0}" -eq 0 ]] || return 1
    return 0
  fi

  # --- classic host path (GC_FREE_ELABORATOR=0; stage1 today) ---
  [[ "${gc0:-0}" -ge 1 ]] || return 1
  [[ "${host_classic:-0}" -ge 1 ]] || return 1
  [[ "${host_free:-0}" -eq 0 ]] || return 1
  # Classic TCB must not also claim residual_free residual class.
  [[ "${residual_free:-0}" -eq 0 ]] || return 1
  return 0
}
