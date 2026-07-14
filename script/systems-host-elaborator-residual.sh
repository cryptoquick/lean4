#!/usr/bin/env bash
# Systems Lean G3: staged host elaborator residual measurement / earned token.
#
# Measures a real lean binary for Lean shared-runtime residues
# (`leanshared` / `Init_shared` in ELF NEEDED via readelf/objdump; ldd last-resort
# classic-only / unmeasured — never residual_free earn). Product residual
# (`PRODUCT_GC_FREE`) is separate — this path is host elaborator only.
#
# This is **not** a claim that the host elaborator is GC-free. Stage1 today still
# links libleanshared / Init_shared → measured GC_FREE_ELABORATOR=0. Full elaborator
# rewrite without RC is out of scope for this staged gate.
#
# Greppable tokens (stdout; always emitted once before exit, including hard-fail):
#   HOST_HAS_LEANSHARED=0|1          (when scan ran; omitted only if lean missing)
#   HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime|residual_free|unmeasured
#   HOST_ELABORATOR_TCB=classic_RC_shared_runtime|residual_free
#   GC_FREE_ELABORATOR=0|1           **measured** — =1 only if residual_free
#   HOST_ELABORATOR_RESIDUAL_OK=0|1  1 when lean present ∧ ELF deps scanned OK
#
# Earn rules (fail-closed):
#   * GC_FREE_ELABORATOR=1 ⇔ residual_free earned via pinned readelf and/or objdump
#     (ELF magic independent of readelf; multi-scanner agreement when both present)
#   * ldd alone never earns residual_free (last-resort classic-only if shared seen, else unmeasured)
#   * Missing lean → GC_FREE=0, residual=unmeasured, OK=0; FAIL if REQUIRE
#   * Non-ELF / failed scanners / disagreement → unmeasured, GC_FREE=0, OK=0
#   * SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 without earned residual_free → FAIL
#     (checked on **all** exit paths)
#   * Never hardcodes GC_FREE_ELABORATOR=1
#
# Env:
#   SYSTEMS_LEAN_TCB_LEAN / SYSTEMS_LEAN_HOST_ELAB_LEAN — lean binary path
#     Explicit path never falls back to PATH (fail-closed).
#   SYSTEMS_LEAN_TCB_REQUIRE / SYSTEMS_LEAN_HOST_ELAB_REQUIRE — 1 = hard fail
#   SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR — refuse unless residual_free earned
#   SYSTEMS_LEAN_HOST_READELF / SYSTEMS_LEAN_HOST_OBJDUMP / SYSTEMS_LEAN_HOST_OD /
#   SYSTEMS_LEAN_HOST_LDD — optional absolute tool pins (else prefer /usr/bin then /bin)
#
# Usage (lean4 root):
#   ./script/systems-host-elaborator-residual.sh
#   SYSTEMS_LEAN_TCB_LEAN=path/to/lean ./script/systems-host-elaborator-residual.sh
#
# Sourced helpers (inventory / honesty / negatives):
#   systems_lean_host_resolve_tool <name>
#   systems_lean_host_file_is_elf <bin>   — magic only (independent of readelf)
#   systems_lean_host_needed_scan <bin>   → sets host_needed_* ; return 0 if scan OK
#   systems_lean_host_elab_scan_needed <needed_text>  → sets host_scan_has_shared
#   systems_lean_host_elab_measure <bin>              → sets measure_* globals
#   systems_lean_host_elab_tokens_ok <file|stdin>     → 0 if residual tokens consistent
#
# Note: set -euo is applied only in main (not when sourced as helpers).

# Resolve host residual tools with absolute pins first (hostile-PATH resistant).
# Prefers: env pin → /usr/bin → /bin → command -v (absolute if possible).
# If the env pin variable is **set** (even empty / missing path), do not fall through —
# that disables the tool for disposable-tree negatives (ldd-only).
systems_lean_host_resolve_tool() {
  local name="$1" pinned="" pinned_set=0 c p
  case "$name" in
    readelf)
      if [[ -n "${SYSTEMS_LEAN_HOST_READELF+x}" ]]; then
        pinned_set=1
        pinned="${SYSTEMS_LEAN_HOST_READELF}"
      fi
      ;;
    objdump)
      if [[ -n "${SYSTEMS_LEAN_HOST_OBJDUMP+x}" ]]; then
        pinned_set=1
        pinned="${SYSTEMS_LEAN_HOST_OBJDUMP}"
      fi
      ;;
    od)
      if [[ -n "${SYSTEMS_LEAN_HOST_OD+x}" ]]; then
        pinned_set=1
        pinned="${SYSTEMS_LEAN_HOST_OD}"
      fi
      ;;
    ldd)
      if [[ -n "${SYSTEMS_LEAN_HOST_LDD+x}" ]]; then
        pinned_set=1
        pinned="${SYSTEMS_LEAN_HOST_LDD}"
      fi
      ;;
    head)
      if [[ -n "${SYSTEMS_LEAN_HOST_HEAD+x}" ]]; then
        pinned_set=1
        pinned="${SYSTEMS_LEAN_HOST_HEAD}"
      fi
      ;;
    cmp)
      if [[ -n "${SYSTEMS_LEAN_HOST_CMP+x}" ]]; then
        pinned_set=1
        pinned="${SYSTEMS_LEAN_HOST_CMP}"
      fi
      ;;
  esac
  if [[ "$pinned_set" -eq 1 ]]; then
    if [[ -n "$pinned" && -x "$pinned" ]]; then
      printf '%s\n' "$pinned"
      return 0
    fi
    return 1
  fi
  for p in "/usr/bin/$name" "/bin/$name"; do
    if [[ -x "$p" ]]; then
      printf '%s\n' "$p"
      return 0
    fi
  done
  if command -v "$name" >/dev/null 2>&1; then
    c="$(command -v "$name" 2>/dev/null || true)"
    if [[ -n "$c" && -x "$c" ]]; then
      printf '%s\n' "$c"
      return 0
    fi
  fi
  return 1
}

# ELF magic 0x7f 'E' 'L' 'F' — independent of readelf (hostile PATH cannot forge via readelf alone).
systems_lean_host_file_is_elf() {
  local bin="$1" hdr od_bin head_bin cmp_bin
  [[ -f "$bin" && -r "$bin" ]] || return 1

  if od_bin="$(systems_lean_host_resolve_tool od 2>/dev/null)"; then
    hdr="$("$od_bin" -An -N4 -tx1 -- "$bin" 2>/dev/null | tr -d ' \n')"
    [[ "$hdr" == "7f454c46" ]] && return 0
    return 1
  fi

  head_bin="$(systems_lean_host_resolve_tool head 2>/dev/null || true)"
  cmp_bin="$(systems_lean_host_resolve_tool cmp 2>/dev/null || true)"
  if [[ -n "$head_bin" && -n "$cmp_bin" ]]; then
    if "$head_bin" -c 4 -- "$bin" 2>/dev/null | "$cmp_bin" -s - <(printf '\177ELF'); then
      return 0
    fi
    return 1
  fi
  # No independent magic checker → fail-closed.
  return 1
}

# Filter lines containing NEEDED (bash-only; no external grep dependency).
systems_lean_host_filter_needed_lines() {
  local line
  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      *NEEDED*) printf '%s\n' "$line" ;;
    esac
  done
}

# Args: needed/ldd text. Sets host_scan_has_shared=0|1, host_scan_ok=0|1.
# Uses bash pattern matching only (fail-closed without external grep).
systems_lean_host_elab_scan_needed() {
  local text="$1"
  host_scan_ok=1
  case "$text" in
    *leanshared*|*Init_shared*)
      host_scan_has_shared=1
      ;;
    *)
      host_scan_has_shared=0
      ;;
  esac
  return 0
}

# Scan ELF dynamic deps with pinned tools + multi-scanner agreement.
# Sets:
#   host_needed_text     — combined NEEDED/ldd diagnostic text
#   host_needed_method   — readelf|objdump|readelf+objdump|ldd|none
#   host_needed_raw      — raw tool output sample
#   host_needed_has_shared=0|1
#   host_needed_earn_ok=0|1  — 1 only if readelf and/or objdump succeeded (not ldd alone)
#   host_needed_scanners   — count of NEEDED scanners that ran successfully
# Return 0 if a usable classification is available (classic or earn-capable clean);
# return 1 if unmeasured (non-ELF, no scanner, scanner fail, multi-scanner disagree on clean).
systems_lean_host_needed_scan() {
  local bin="$1" out rc text has readelf_bin objdump_bin ldd_bin
  local re_ok=0 od_ok=0 re_has="" od_has="" ldd_has=""
  host_needed_text=""
  host_needed_method=none
  host_needed_raw=""
  host_needed_has_shared=""
  host_needed_earn_ok=0
  host_needed_scanners=0

  if [[ ! -f "$bin" || ! -r "$bin" ]]; then
    return 1
  fi
  # ELF magic first — never trust readelf alone for "is ELF".
  if ! systems_lean_host_file_is_elf "$bin"; then
    return 1
  fi

  readelf_bin="$(systems_lean_host_resolve_tool readelf 2>/dev/null || true)"
  objdump_bin="$(systems_lean_host_resolve_tool objdump 2>/dev/null || true)"
  ldd_bin="$(systems_lean_host_resolve_tool ldd 2>/dev/null || true)"

  if [[ -n "$readelf_bin" ]]; then
    set +e
    out="$("$readelf_bin" -d -- "$bin" 2>/dev/null)"
    rc=$?
    set -e
    if [[ $rc -eq 0 ]]; then
      re_ok=1
      text="$(printf '%s\n' "$out" | systems_lean_host_filter_needed_lines)"
      systems_lean_host_elab_scan_needed "$text"
      re_has="$host_scan_has_shared"
      host_needed_raw="${host_needed_raw}${host_needed_raw:+$'\n'}--- readelf ($readelf_bin) ---"$'\n'"$out"
      host_needed_text="${host_needed_text}${host_needed_text:+$'\n'}$text"
      host_needed_scanners=$((host_needed_scanners + 1))
    fi
  fi

  if [[ -n "$objdump_bin" ]]; then
    set +e
    out="$("$objdump_bin" -p -- "$bin" 2>/dev/null)"
    rc=$?
    set -e
    if [[ $rc -eq 0 ]]; then
      od_ok=1
      text="$(printf '%s\n' "$out" | systems_lean_host_filter_needed_lines)"
      systems_lean_host_elab_scan_needed "$text"
      od_has="$host_scan_has_shared"
      host_needed_raw="${host_needed_raw}${host_needed_raw:+$'\n'}--- objdump ($objdump_bin) ---"$'\n'"$out"
      host_needed_text="${host_needed_text}${host_needed_text:+$'\n'}$text"
      host_needed_scanners=$((host_needed_scanners + 1))
    fi
  fi

  # Multi-scanner agreement when both NEEDED scanners succeeded.
  if [[ "$re_ok" -eq 1 && "$od_ok" -eq 1 ]]; then
    if [[ "$re_has" != "$od_has" ]]; then
      # Disagree → unmeasured (fail-closed; never earn).
      host_needed_method=disagree
      return 1
    fi
    host_needed_has_shared="$re_has"
    host_needed_earn_ok=1
    host_needed_method=readelf+objdump
    return 0
  fi

  if [[ "$re_ok" -eq 1 ]]; then
    host_needed_has_shared="$re_has"
    host_needed_earn_ok=1
    host_needed_method=readelf
    return 0
  fi

  if [[ "$od_ok" -eq 1 ]]; then
    host_needed_has_shared="$od_has"
    host_needed_earn_ok=1
    host_needed_method=objdump
    return 0
  fi

  # ldd last resort: may establish classic shared residue, but never residual_free earn.
  if [[ -n "$ldd_bin" ]]; then
    set +e
    out="$("$ldd_bin" -- "$bin" 2>&1)"
    rc=$?
    set -e
    case "$out" in
      *"not ELF"*|*"No such file"*)
        return 1
        ;;
    esac
    host_needed_method=ldd
    host_needed_raw="$out"
    host_needed_text="$out"
    systems_lean_host_elab_scan_needed "$out"
    ldd_has="$host_scan_has_shared"
    host_needed_has_shared="$ldd_has"
    host_needed_earn_ok=0
    if [[ "$ldd_has" == "1" ]]; then
      # Classic only — shared seen via ldd.
      return 0
    fi
    # ldd alone + no shared → unmeasured (cannot earn residual_free without readelf/objdump).
    return 1
  fi

  return 1
}

# Measure lean binary. Sets:
#   measure_lean_present=0|1
#   measure_scanned=0|1
#   measure_has_leanshared=""|0|1
#   measure_residual=classic_RC_shared_runtime|residual_free|unmeasured
#   measure_tcb=classic_RC_shared_runtime|residual_free
#   measure_gc_free=0|1
#   measure_ok=0|1
#   measure_needed_out (human-readable NEEDED/ldd sample)
#   measure_method=readelf|objdump|readelf+objdump|ldd|none
#   measure_fail_reason= (empty|non_elf|scan_fail|missing|ldd_only_clean)
#   measure_earn_ok=0|1
systems_lean_host_elab_measure() {
  local bin="$1"
  measure_lean_present=0
  measure_scanned=0
  measure_has_leanshared=""
  measure_residual=unmeasured
  measure_tcb=classic_RC_shared_runtime
  measure_gc_free=0
  measure_ok=0
  measure_needed_out=""
  measure_method=none
  measure_fail_reason=missing
  measure_earn_ok=0

  if [[ ! -x "$bin" ]]; then
    return 0
  fi
  measure_lean_present=1
  measure_fail_reason=""

  # Non-regular file or non-ELF magic → unmeasured (never residual_free earn).
  if [[ ! -f "$bin" ]] || ! systems_lean_host_file_is_elf "$bin"; then
    measure_fail_reason=non_elf
    measure_residual=unmeasured
    measure_tcb=classic_RC_shared_runtime
    measure_gc_free=0
    measure_ok=0
    measure_scanned=0
    return 0
  fi

  if ! systems_lean_host_needed_scan "$bin"; then
    measure_fail_reason=scan_fail
    # ldd-only clean path leaves method=ldd but returns 1 — tag clearly.
    if [[ "${host_needed_method:-}" == "ldd" ]]; then
      measure_fail_reason=ldd_only_clean
      measure_method=ldd
      measure_needed_out="${host_needed_text:-}"
    fi
    measure_residual=unmeasured
    measure_tcb=classic_RC_shared_runtime
    measure_gc_free=0
    measure_ok=0
    measure_scanned=0
    return 0
  fi

  measure_method="$host_needed_method"
  measure_needed_out="$host_needed_text"
  if [[ -z "$measure_needed_out" && -n "$host_needed_raw" ]]; then
    measure_needed_out="$host_needed_raw"
  fi
  measure_has_leanshared="$host_needed_has_shared"
  measure_earn_ok="${host_needed_earn_ok:-0}"
  measure_scanned=1

  if [[ "$measure_has_leanshared" == "1" ]]; then
    # Classic shared runtime (may come from readelf/objdump or ldd-only classic).
    measure_residual=classic_RC_shared_runtime
    measure_tcb=classic_RC_shared_runtime
    measure_gc_free=0
    measure_ok=1
    return 0
  fi

  # Clean NEEDED: earn residual_free only via readelf/objdump success (not ldd alone).
  if [[ "$measure_earn_ok" -eq 1 ]]; then
    measure_residual=residual_free
    measure_tcb=residual_free
    measure_gc_free=1
    measure_ok=1
    return 0
  fi

  # Should not reach: scan return 0 with earn_ok=0 and has_shared=0.
  measure_fail_reason=scan_fail
  measure_residual=unmeasured
  measure_tcb=classic_RC_shared_runtime
  measure_gc_free=0
  measure_ok=0
  measure_scanned=0
  return 0
}

# Consistency checker for residual / G3 tokens (validate GATE host_elaborator).
# Accepts classic residual (GC_FREE=0 + shared present) and residual_free (earned).
# Rejects forged GC_FREE=1 with shared / classic residual / dual tokens.
systems_lean_host_elab_tokens_ok() {
  local text
  if [[ $# -ge 1 && -n "${1:-}" && "$1" != "-" ]]; then
    if [[ ! -f "$1" ]]; then
      return 1
    fi
    text="$(cat -- "$1")"
  else
    text="$(cat)"
  fi

  local ok1 ok0 gc0 gc1 residual_classic residual_free residual_unmeas has0 has1 tcb_classic tcb_free

  # Prefer bash line counts when possible; use grep -c with fail-closed on tool error.
  _g3_count_exact() {
    local pat="$1" n rc
    set +e
    n="$(printf '%s\n' "$text" | grep -cx -- "$pat" 2>/dev/null)"
    rc=$?
    set -e
    # grep: 0=matches, 1=no match, 2+=error → treat error as fail (return empty → 0 via :-0 later fails counts)
    if [[ $rc -ge 2 ]]; then
      echo "ERR"
      return 0
    fi
    echo "${n:-0}"
  }

  ok1="$(_g3_count_exact 'HOST_ELABORATOR_RESIDUAL_OK=1')"
  ok0="$(_g3_count_exact 'HOST_ELABORATOR_RESIDUAL_OK=0')"
  gc0="$(_g3_count_exact 'GC_FREE_ELABORATOR=0')"
  gc1="$(_g3_count_exact 'GC_FREE_ELABORATOR=1')"
  residual_classic="$(_g3_count_exact 'HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime')"
  residual_free="$(_g3_count_exact 'HOST_ELABORATOR_RESIDUAL=residual_free')"
  residual_unmeas="$(_g3_count_exact 'HOST_ELABORATOR_RESIDUAL=unmeasured')"
  has0="$(_g3_count_exact 'HOST_HAS_LEANSHARED=0')"
  has1="$(_g3_count_exact 'HOST_HAS_LEANSHARED=1')"
  tcb_classic="$(_g3_count_exact 'HOST_ELABORATOR_TCB=classic_RC_shared_runtime')"
  tcb_free="$(_g3_count_exact 'HOST_ELABORATOR_TCB=residual_free')"

  # grep tool failure → reject.
  for v in ok1 ok0 gc0 gc1 residual_classic residual_free residual_unmeas has0 has1 tcb_classic tcb_free; do
    if [[ "${!v}" == "ERR" ]]; then
      return 1
    fi
  done

  # Exactly one residual_ok=1; no dual 0/1.
  [[ "${ok1:-0}" -eq 1 ]] || return 1
  [[ "${ok0:-0}" -eq 0 ]] || return 1

  # Exactly one GC_FREE line.
  if [[ "$(( ${gc0:-0} + ${gc1:-0} ))" -ne 1 ]]; then
    return 1
  fi

  # Exactly one residual class among the three.
  if [[ "$(( ${residual_classic:-0} + ${residual_free:-0} + ${residual_unmeas:-0} ))" -ne 1 ]]; then
    return 1
  fi

  # Dual HOST_HAS_LEANSHARED=0 and =1 → reject (Issue 8).
  if [[ "${has0:-0}" -ge 1 && "${has1:-0}" -ge 1 ]]; then
    return 1
  fi
  # At most one of each.
  [[ "${has0:-0}" -le 1 ]] || return 1
  [[ "${has1:-0}" -le 1 ]] || return 1

  # Forged GC_FREE=1 while shared runtime present / classic residual / unmeasured.
  if [[ "${gc1:-0}" -ge 1 ]]; then
    [[ "${has1:-0}" -eq 0 ]] || return 1
    [[ "${residual_classic:-0}" -eq 0 ]] || return 1
    [[ "${residual_unmeas:-0}" -eq 0 ]] || return 1
    [[ "${residual_free:-0}" -eq 1 ]] || return 1
    [[ "${has0:-0}" -eq 1 ]] || return 1
    [[ "${tcb_free:-0}" -ge 1 ]] || return 1
    [[ "${tcb_classic:-0}" -eq 0 ]] || return 1
    return 0
  fi

  # GC_FREE=0 path: staged G3 honesty (classic shared runtime present is PASS).
  # residual may be classic (shared) — unmeasured is NOT residual_ok=1 quality.
  [[ "${residual_unmeas:-0}" -eq 0 ]] || return 1
  if [[ "${residual_classic:-0}" -eq 1 ]]; then
    [[ "${has1:-0}" -eq 1 ]] || return 1
    [[ "${has0:-0}" -eq 0 ]] || return 1
    [[ "${tcb_classic:-0}" -ge 1 ]] || return 1
    [[ "${tcb_free:-0}" -eq 0 ]] || return 1
    return 0
  fi
  # residual_free with GC_FREE=0 is inconsistent (should be =1).
  return 1
}

# --- Main (only when executed, not sourced) ---
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  return 0 2>/dev/null || true
fi

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Explicit lean path never falls back to PATH.
if [[ -n "${SYSTEMS_LEAN_HOST_ELAB_LEAN+x}" ]]; then
  LEAN_BIN="${SYSTEMS_LEAN_HOST_ELAB_LEAN}"
elif [[ -n "${SYSTEMS_LEAN_TCB_LEAN+x}" ]]; then
  LEAN_BIN="${SYSTEMS_LEAN_TCB_LEAN}"
else
  LEAN_BIN="$ROOT/build/release/stage1/bin/lean"
  if [[ ! -x "$LEAN_BIN" ]] && command -v lean >/dev/null 2>&1; then
    LEAN_BIN="$(command -v lean)"
  fi
fi

if [[ -n "${SYSTEMS_LEAN_HOST_ELAB_REQUIRE+x}" ]]; then
  REQUIRE="${SYSTEMS_LEAN_HOST_ELAB_REQUIRE}"
else
  REQUIRE="${SYSTEMS_LEAN_TCB_REQUIRE:-0}"
fi

FORCE_GC_FREE="${SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR:-0}"

host_has_leanshared=""
host_residual=unmeasured
host_tcb=classic_RC_shared_runtime
gc_free=0
residual_ok=0

emit_tokens() {
  if [[ -n "$host_has_leanshared" ]]; then
    echo "HOST_HAS_LEANSHARED=${host_has_leanshared}"
  fi
  echo "HOST_ELABORATOR_RESIDUAL=${host_residual}"
  echo "HOST_ELABORATOR_TCB=${host_tcb}"
  echo "GC_FREE_ELABORATOR=${gc_free}"
  echo "HOST_ELABORATOR_RESIDUAL_OK=${residual_ok}"
}

# FORCE refuse without earned residual_free — call before every successful exit.
force_refuse_if_needed() {
  if [[ "$FORCE_GC_FREE" == "1" && "$gc_free" -ne 1 ]]; then
    fail_hard "SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 refused (measurement GC_FREE_ELABORATOR=${gc_free}, residual=${host_residual})"
  fi
}

fail_hard() {
  printf 'FAIL: %s\n' "$1" >&2
  residual_ok=0
  gc_free=0
  # Never claim residual_free after a hard fail that voids the claim.
  if [[ "$host_residual" == "residual_free" ]]; then
    host_residual=unmeasured
    host_tcb=classic_RC_shared_runtime
  fi
  emit_tokens
  exit 1
}

finish_ok() {
  force_refuse_if_needed
  # Internal consistency: never emit =1 with shared present.
  if [[ "$gc_free" -eq 1 && "$host_has_leanshared" == "1" ]]; then
    fail_hard "internal: GC_FREE_ELABORATOR=1 with HOST_HAS_LEANSHARED=1"
  fi
  emit_tokens
  exit 0
}

echo "=== Systems Lean host elaborator residual (G3) ===" >&2
echo "date: $(date -Is 2>/dev/null || date)" >&2
echo "lean: $LEAN_BIN" >&2
echo "mode: $([[ "$REQUIRE" == "1" ]] && echo require || echo advisory)" >&2
echo "product_path: separate (PRODUCT_GC_FREE is not this measurement)" >&2
echo "note: staged residual measurement / earned token — not a GC-free elaborator claim" >&2
echo "" >&2

systems_lean_host_elab_measure "$LEAN_BIN"

if [[ "$measure_lean_present" -ne 1 ]]; then
  echo "WARN: lean binary not found or not executable: $LEAN_BIN" >&2
  host_residual=unmeasured
  host_tcb=classic_RC_shared_runtime
  gc_free=0
  residual_ok=0
  if [[ "$REQUIRE" == "1" ]]; then
    fail_hard "SYSTEMS_LEAN_HOST_ELAB_REQUIRE/TCB_REQUIRE=1 and lean missing at $LEAN_BIN"
  fi
  echo "OK: host elaborator residual (advisory; lean missing; GC_FREE_ELABORATOR=0)" >&2
  finish_ok
fi

if [[ "$measure_scanned" -ne 1 ]]; then
  case "${measure_fail_reason:-scan_fail}" in
    non_elf)
      echo "WARN: lean path is not a readable ELF (shell script / empty / non-ELF) — unmeasured" >&2
      ;;
    ldd_only_clean)
      echo "WARN: ldd-only scan without shared residue — unmeasured (readelf/objdump required to earn residual_free)" >&2
      ;;
    scan_fail)
      echo "WARN: ELF dep scan failed, scanner disagree, or no readelf/objdump — unmeasured" >&2
      ;;
    *)
      echo "WARN: host residual unmeasured (${measure_fail_reason:-unknown})" >&2
      ;;
  esac
  host_residual=unmeasured
  host_tcb=classic_RC_shared_runtime
  gc_free=0
  residual_ok=0
  if [[ "$REQUIRE" == "1" ]]; then
    fail_hard "REQUIRE=1 and host residual unmeasured (${measure_fail_reason:-scan_fail}) at $LEAN_BIN"
  fi
  echo "OK: host elaborator residual (advisory; unmeasured; GC_FREE_ELABORATOR=0)" >&2
  finish_ok
fi

host_has_leanshared="$measure_has_leanshared"
host_residual="$measure_residual"
host_tcb="$measure_tcb"
gc_free="$measure_gc_free"
residual_ok="$measure_ok"

echo "--- lean dynamic dependencies (${measure_method}) ---" >&2
if [[ -n "$measure_needed_out" ]]; then
  printf '%s\n' "$measure_needed_out" | sed 's/^/  /' >&2
else
  echo "  (no NEEDED/ldd lines; static ELF or empty dynamic section)" >&2
fi
echo "" >&2
echo "Shared-runtime residues (leanshared / Init_shared):" >&2
if [[ "$host_has_leanshared" == "1" ]]; then
  # Diagnostic grep only (|| true); security classification already done via bash case.
  printf '%s\n' "$measure_needed_out" | grep -E 'leanshared|Init_shared' 2>/dev/null | sed 's/^/  /' >&2 || true
  echo "  HOST_HAS_LEANSHARED=1 → GC_FREE_ELABORATOR=0 (classic RC/shared runtime)" >&2
else
  echo "  (no leanshared/Init_shared match in NEEDED/ldd)" >&2
  echo "  HOST_HAS_LEANSHARED=0 → residual_free (earned GC_FREE_ELABORATOR=1)" >&2
fi
echo "" >&2

echo "Summary:" >&2
echo "  HOST_ELABORATOR_RESIDUAL=${host_residual}" >&2
echo "  HOST_ELABORATOR_TCB=${host_tcb}" >&2
echo "  GC_FREE_ELABORATOR=${gc_free} (measured; not hardcoded)" >&2
echo "  dual_path: product PRODUCT_GC_FREE is independent of host GC_FREE_ELABORATOR" >&2
echo "OK: host elaborator residual measurement complete" >&2
finish_ok
