#!/usr/bin/env bash
# Systems Lean TCB honesty inventory (host elaborator vs product embed).
#
# Contrasts:
#   1) Host elaborator binary (`lean`) dynamic deps (G3 measured residual)
#   2) Product freestanding archive (`libfs_extract_bundle.a`) nm surface — residual-free goal
#
# Track H / H1 host dep map (lean-systems compile/check/selfhost):
#   doc/dev/systems-lean-selfhost.md § "Host dependency map (Track H / H1)"
# Earn rules SSoT (do not duplicate / weaken here):
#   script/systems-host-elaborator-residual.sh  — GC_FREE_ELABORATOR=1 only residual_free
# H2–H5: product without host GC → slim host driver NEEDED clean → shrink Meta/RC → earn flip.
# H2 dual path: PRODUCT_GC_FREE=1 can hold while GC_FREE_ELABORATOR=0 (independent axes).
# Stage1 today → GC_FREE_ELABORATOR=0; never forge =1.
#
# Host elaborator GC-free is **measured** (G3), never hardcoded forever:
#   GC_FREE_ELABORATOR=1 only when residual_free is earned via successful readelf and/or
#   objdump NEEDED parse with no leanshared/Init_shared (multi-scanner agreement when both).
#   ldd alone never earns residual_free (ldd+shared → classic; ldd+clean → unmeasured).
#   Stage1 today dynamically links libleanshared* / Init_shared → GC_FREE_ELABORATOR=0.
# Product path is separate: PRODUCT_GC_FREE is nm-advisory product residual (not elaborator).
#
# Machine tokens always include:
#   HOST_ELABORATOR_TCB=classic_RC_shared_runtime|residual_free
#   HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime|residual_free|unmeasured
#   PRODUCT_EMBED_TCB=residual_free_goal
#   GC_FREE_ELABORATOR=0|1   (measured; earn requires readelf/objdump)
#   TCB_HONESTY_OK=0|1
#   HOST_HAS_LEANSHARED=0|1   (when lean present and residual scan classified shared)
#   PRODUCT_GC_FREE=0|1       (1 only if residual was scanned ∧ clean ∧ bundle present)
#   PRODUCT_NO_LEANSHARED=0|1 (same predicate; nm residual only — not residual_ir)
#   PRODUCT_FS_NEXT=...       (curated next-port backlog; always emitted; not required by validate)
#
# **Advisory by default:** exit 0 after printing the inventory even when product
# residual markers are present (labels use ADVISORY, not FAIL). This is intentionally
# weaker than `systems-selfhost-link-check.sh` / residual_nm — use those gates for
# product integrity. Do not treat this script as a residual_nm substitute.
#
# When SYSTEMS_LEAN_TCB_REQUIRE=1:
#   * missing lean/bundle (or empty/unreadable bundle) → exit 1, TCB_HONESTY_OK=0
#   * nm missing (cannot check residual) → exit 1, TCB_HONESTY_OK=0
#   * product residual per full link-check policy (U lean_*/l_*, Init_shared/leanshared,
#     defined RC entry points) → exit 1, TCB_HONESTY_OK=0
#   * host residual unmeasured (no scanner) → exit 1, TCB_HONESTY_OK=0
#
# SYSTEMS_LEAN_TCB_LEAN: if set, that path is used as-is (no PATH fallback when missing).
# PATH / stage1 fallback applies only when the env var is unset.
# SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 without earned residual_free → FAIL.
#
# Product GC tokens here are nm-advisory (aligned with link-check residual policy).
# Authoritative product GC claim for validate is the scoreboard after GATE lines
# (`GATE product_gc_free` + stdout PRODUCT_*= from systems-validate.sh), which also
# requires residual_ir. Inventory PRODUCT_*=1 never means host elaborator GC-free.
#
# Validate GATE tcb_honesty uses script/systems-tcb-honesty-check.sh (shared with negatives).
# Validate GATE host_elaborator uses systems-host-elaborator-residual.sh measurement.
#
# Usage:
#   ./script/systems-tcb-inventory.sh
#   SYSTEMS_LEAN_TCB_REQUIRE=1 ./script/systems-tcb-inventory.sh
#   ./script/systems-validate.sh   # GATE tcb_honesty + GATE host_elaborator
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# shellcheck source=systems-host-elaborator-residual.sh
source "$ROOT/script/systems-host-elaborator-residual.sh"

# Explicit SYSTEMS_LEAN_TCB_LEAN never falls back to PATH (fail closed for negatives).
if [[ -n "${SYSTEMS_LEAN_TCB_LEAN+x}" ]]; then
  LEAN_BIN="${SYSTEMS_LEAN_TCB_LEAN}"
else
  LEAN_BIN="$ROOT/build/release/stage1/bin/lean"
  if [[ ! -x "$LEAN_BIN" ]] && command -v lean >/dev/null 2>&1; then
    LEAN_BIN="$(command -v lean)"
  fi
fi
BUNDLE="${SYSTEMS_LEAN_TCB_BUNDLE:-$ROOT/tests/lake/examples/systems/lib/.lake/build/lib/libfs_extract_bundle.a}"
REQUIRE="${SYSTEMS_LEAN_TCB_REQUIRE:-0}"
FORCE_GC_FREE="${SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR:-0}"

# Host tokens start fail-closed; G3 measure overwrites when lean is scannable.
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
HOST_ELABORATOR_RESIDUAL=unmeasured
PRODUCT_EMBED_TCB=residual_free_goal

# Curated next freestanding ports (shaped residual-free candidates; hand-maintained).
# Not a claim that these are on PRODUCT_STDLIB yet — grow that manifest only after
# freestanding build + residual_nm + residual_ir + certs are green.
# Not derived live from systems-stdlib-inventory buckets (planning labels only).
# See doc/dev/systems-lean-selfhost.md and systems-lean-stdlib-inventory.md.
PRODUCT_FS_NEXT="H5_host,TomlConfig_more89,Slake_parity_more"

honesty_ok=1
# product_residual=1 means residual dirty (forbidden symbols). Defaults 0 only until scanned.
product_residual=0
# product_residual_checked=1 only after a successful full nm residual scan (not missing nm / empty).
product_residual_checked=0
host_has_leanshared=""
lean_present=0
bundle_present=0

emit_tokens() {
  # Machine-readable block (rg-friendly). Always printed before exit.
  # PRODUCT_GC_FREE / PRODUCT_NO_LEANSHARED here are nm-advisory only; validate
  # scoreboard PRODUCT_* after GATE lines is authoritative for product_gc_free.
  # GC_FREE_ELABORATOR is host residual (measured G3), not product.
  echo "HOST_ELABORATOR_TCB=${HOST_ELABORATOR_TCB}"
  echo "HOST_ELABORATOR_RESIDUAL=${HOST_ELABORATOR_RESIDUAL}"
  echo "PRODUCT_EMBED_TCB=${PRODUCT_EMBED_TCB}"
  echo "GC_FREE_ELABORATOR=${GC_FREE_ELABORATOR}"
  if [[ -n "$host_has_leanshared" ]]; then
    echo "HOST_HAS_LEANSHARED=${host_has_leanshared}"
  fi
  # Fail-closed: PRODUCT_*=1 only when residual was actually scanned, clean, and bundle present.
  # Unchecked (missing nm / empty nm / no bundle) → =0 (never default-to-clean).
  if [[ "$product_residual_checked" -eq 1 && "$product_residual" -eq 0 && "$bundle_present" -eq 1 ]]; then
    echo "PRODUCT_GC_FREE=1"
    echo "PRODUCT_NO_LEANSHARED=1"
  else
    echo "PRODUCT_GC_FREE=0"
    echo "PRODUCT_NO_LEANSHARED=0"
  fi
  echo "PRODUCT_FS_NEXT=${PRODUCT_FS_NEXT}"
  echo "TCB_HONESTY_OK=${honesty_ok}"
}

fail_hard() {
  local msg="$1"
  echo "FAIL: $msg"
  honesty_ok=0
  # Never leave a success GC_FREE=1 claim on hard fail.
  if [[ "$GC_FREE_ELABORATOR" -eq 1 ]]; then
    GC_FREE_ELABORATOR=0
    HOST_ELABORATOR_RESIDUAL=unmeasured
    HOST_ELABORATOR_TCB=classic_RC_shared_runtime
  fi
  emit_tokens
  exit 1
}

echo "=== Systems Lean TCB inventory ==="
echo "date: $(date -Is 2>/dev/null || date)"
echo "lean: $LEAN_BIN"
echo "bundle: $BUNDLE"
echo "mode: $([[ "$REQUIRE" == "1" ]] && echo require || echo advisory)"
echo ""

echo "--- Honesty ---"
echo "Host elaborator residual is **measured** (G3 systems-host-elaborator-residual helpers)."
echo "GC_FREE_ELABORATOR=1 only when readelf and/or objdump NEEDED proves no leanshared/Init_shared"
echo "(ELF magic independent of readelf; multi-scanner agreement when both present)."
echo "ldd alone never earns residual_free (ldd+shared → classic; ldd+clean → unmeasured)."
echo "Stage1 today links shared runtime → GC_FREE_ELABORATOR=0 (classic RC)."
echo "Product embed path aims at residual-free AOT C (PRODUCT_GC_FREE; separate token)."
echo ""

if [[ ! -x "$LEAN_BIN" ]]; then
  echo "WARN: lean binary not found at $LEAN_BIN"
  HOST_ELABORATOR_RESIDUAL=unmeasured
  HOST_ELABORATOR_TCB=classic_RC_shared_runtime
  GC_FREE_ELABORATOR=0
  if [[ "$REQUIRE" == "1" ]]; then
    fail_hard "SYSTEMS_LEAN_TCB_REQUIRE=1 and lean missing at $LEAN_BIN"
  fi
else
  lean_present=1
  systems_lean_host_elab_measure "$LEAN_BIN"
  if [[ "$measure_scanned" -eq 1 ]]; then
    host_has_leanshared="$measure_has_leanshared"
    HOST_ELABORATOR_RESIDUAL="$measure_residual"
    HOST_ELABORATOR_TCB="$measure_tcb"
    GC_FREE_ELABORATOR="$measure_gc_free"
    echo "--- lean dynamic dependencies (${measure_method}) ---"
    if [[ -n "$measure_needed_out" ]]; then
      printf '%s\n' "$measure_needed_out" | sed 's/^/  /'
    else
      echo "  (no NEEDED/ldd lines; static ELF or empty dynamic section)"
    fi
    echo ""
    echo "Shared-runtime residues (measured G3):"
    if [[ "$host_has_leanshared" == "1" ]]; then
      printf '%s\n' "$measure_needed_out" | grep -E 'leanshared|Init_shared|libgmp|libuv|libc\+\+|libstdc\+\+' 2>/dev/null | sed 's/^/  /' || true
      echo "  HOST_HAS_LEANSHARED=1 → GC_FREE_ELABORATOR=0"
    else
      printf '%s\n' "$measure_needed_out" | grep -E 'libgmp|libuv|libc\+\+|libstdc\+\+' 2>/dev/null | sed 's/^/  /' || true
      echo "  HOST_HAS_LEANSHARED=0 → residual_free (earned GC_FREE_ELABORATOR=1 via readelf/objdump)"
    fi
  else
    echo "--- lean dynamic dependencies ---"
    case "${measure_fail_reason:-scan_fail}" in
      non_elf)
        echo "  non-ELF / empty / non-file lean path — host residual unmeasured (fail-closed GC_FREE=0)"
        ;;
      ldd_only_clean)
        echo "  ldd-only clean scan — unmeasured (readelf/objdump required to earn residual_free)"
        ;;
      *)
        echo "  dep scan failed, scanner disagree, or no earn-capable scanner — unmeasured (fail-closed GC_FREE=0)"
        ;;
    esac
    HOST_ELABORATOR_RESIDUAL=unmeasured
    HOST_ELABORATOR_TCB=classic_RC_shared_runtime
    GC_FREE_ELABORATOR=0
    if [[ "$REQUIRE" == "1" ]]; then
      fail_hard "SYSTEMS_LEAN_TCB_REQUIRE=1 and host residual unmeasured (${measure_fail_reason:-scan_fail})"
    fi
  fi
fi

# Refuse forced GC-free claim without earned residual_free evidence (all paths, incl. missing lean).
if [[ "$FORCE_GC_FREE" == "1" && "$GC_FREE_ELABORATOR" -ne 1 ]]; then
  fail_hard "SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 refused (measured GC_FREE_ELABORATOR=${GC_FREE_ELABORATOR}, residual=${HOST_ELABORATOR_RESIDUAL})"
fi

# Internal consistency: never emit =1 with shared present.
if [[ "$GC_FREE_ELABORATOR" -eq 1 && "$host_has_leanshared" == "1" ]]; then
  fail_hard "internal: GC_FREE_ELABORATOR=1 with HOST_HAS_LEANSHARED=1"
fi

echo ""
echo "--- product archive nm (advisory; residual_nm is the product gate) ---"
if [[ ! -f "$BUNDLE" ]]; then
  echo "WARN: freestanding bundle missing: $BUNDLE"
  echo "  build: lake --dir=tests/lake/examples/systems/lib build"
  if [[ "$REQUIRE" == "1" ]]; then
    fail_hard "SYSTEMS_LEAN_TCB_REQUIRE=1 and freestanding bundle missing: $BUNDLE"
  fi
elif [[ ! -r "$BUNDLE" || ! -s "$BUNDLE" ]]; then
  echo "WARN: freestanding bundle empty or unreadable: $BUNDLE"
  if [[ "$REQUIRE" == "1" ]]; then
    fail_hard "SYSTEMS_LEAN_TCB_REQUIRE=1 and freestanding bundle empty/unreadable: $BUNDLE"
  fi
else
  bundle_present=1
  if ! command -v nm >/dev/null 2>&1; then
    echo "  nm not available"
    if [[ "$REQUIRE" == "1" ]]; then
      fail_hard "SYSTEMS_LEAN_TCB_REQUIRE=1 and nm not available (cannot check product residual)"
    fi
  else
    # shellcheck source=systems-residual-policy.sh
    source "$ROOT/script/systems-residual-policy.sh"
    # Collect nm output; treat total silence as empty/unreadable (unchecked residual).
    undef="$(nm -u -- "$BUNDLE" 2>/dev/null || nm -u -A -- "$BUNDLE" 2>/dev/null || true)"
    nm_all="$(nm -- "$BUNDLE" 2>/dev/null || nm -A -- "$BUNDLE" 2>/dev/null || true)"
    if [[ -z "${nm_all//[[:space:]]/}" && -z "${undef//[[:space:]]/}" ]]; then
      echo "WARN: nm produced no symbols for $BUNDLE (empty/unreadable archive?)"
      if [[ "$REQUIRE" == "1" ]]; then
        fail_hard "SYSTEMS_LEAN_TCB_REQUIRE=1 and nm produced no symbols for bundle: $BUNDLE"
      fi
    else
      # Full residual scan aligned with systems-selfhost-link-check.sh (not undef-only).
      product_residual_checked=1
      echo "Undefined symbols (sample, first 40):"
      # pipefail: head may SIGPIPE printf; never abort without emit_tokens.
      printf '%s\n' "$undef" | head -n 40 | sed 's/^/  /' || true
      echo ""
      if systems_lean_nm_undef_has_runtime "$undef"; then
        echo "ADVISORY: product undefs match residual U lean_* / U l_* policy"
        product_residual=1
      fi
      bad_shared="$(printf '%s\n%s\n' "$undef" "$nm_all" | grep -E "$SYSTEMS_LEAN_SHARED_RE" || true)"
      if [[ -n "$bad_shared" ]]; then
        echo "ADVISORY: product references Init_shared / leanshared* residues"
        product_residual=1
      fi
      bad_def="$(printf '%s\n' "$nm_all" | grep -E '[[:space:]][TtWw][[:space:]]+('"$SYSTEMS_LEAN_RC_DEF_RE"')' || true)"
      if [[ -n "$bad_def" ]]; then
        echo "ADVISORY: product defines Lean RC/runtime symbols (not freestanding-clean)"
        product_residual=1
      fi
      if [[ "$product_residual" -eq 0 ]]; then
        echo "ADVISORY: no U lean_*/l_*, shared residues, or defined RC entry points (aligns with residual_nm)"
      fi
      echo ""
      echo "Defined freestanding exports (lean_fs_* sample):"
      printf '%s\n' "$nm_all" | grep -E '[[:space:]]T[[:space:]]+lean_fs_' | head -n 20 | sed 's/^/  /' || true
    fi
  fi
fi

echo ""
echo "--- Summary ---"
echo "mode: $([[ "$REQUIRE" == "1" ]] && echo require || echo advisory)"
echo "host_elaborator_tcb: $HOST_ELABORATOR_TCB"
echo "host_elaborator_residual: $HOST_ELABORATOR_RESIDUAL"
echo "gc_free_elaborator: $GC_FREE_ELABORATOR (measured G3)"
echo "product_embed_goal: residual_free_aot_c_no_gc_rc"
echo "compcert_scope: C_to_asm_for_accepted_pure_TUs_only"
echo "product_gate: use ./script/systems-selfhost-link-check.sh (residual_nm), not this inventory"
echo "lean_present: $lean_present"
echo "bundle_present: $bundle_present"
echo "product_residual_checked: $product_residual_checked"
echo "product_residual_advisory: $product_residual"
echo "next freestanding ports (curated backlog; not PRODUCT_STDLIB): $PRODUCT_FS_NEXT"

if [[ "$REQUIRE" == "1" && "$product_residual" -eq 1 ]]; then
  fail_hard "SYSTEMS_LEAN_TCB_REQUIRE=1 and product residual present (undef/shared/defined RC)"
fi

echo "OK: systems-tcb-inventory complete ($([[ "$REQUIRE" == "1" ]] && echo require || echo advisory))"
emit_tokens
exit 0
