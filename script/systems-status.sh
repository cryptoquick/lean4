#!/usr/bin/env bash
# Systems Lean fast status (Track F) — greppable inventory + PRODUCT + key honesty tokens
# without a full ./script/systems-validate.sh run.
#
# Use for local feedback loops. Does **not** claim SCORE fail=0 or full product integrity;
# run systems-validate.sh for the authoritative scoreboard.
#
# Usage (lean4 root):
#   ./script/systems-status.sh
#   nix develop .#systems --command systems-status   # systems.nix front door
#   # alias: nix develop .#systems-dev --command ./script/systems-status.sh
#
# Greppable tokens (stdout):
#   SYSTEMS_STATUS_OK=0|1
#   FS_READY=N
#   FS_PLANNED=N DUAL_HOST=N HOST_ONLY=N
#   PRODUCT_STDLIB_MODULES_COUNT=N
#   PRODUCT_FS_NEXT=...
#   GC_FREE_ELABORATOR=0|1          (measured if lean scannable; else 0 unmeasured path)
#   HOST_ELABORATOR_RESIDUAL=...
#   PRODUCT_GC_FREE=0|1             (nm-advisory from inventory when bundle scanned)
#   PRODUCT_NO_LEANSHARED=0|1
#   # H2 dual path: PRODUCT_GC_FREE=1 can hold while GC_FREE_ELABORATOR=0
#   STAGE1_LEAN=0|1
#   BUNDLE_PRESENT=0|1
#   INVENTORY_DOC_FS_READY=N|MISSING
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

status_ok=1
emit_fail() {
  status_ok=0
  echo "FAIL: $*" >&2
}

# --- Inventory (live) ---
chmod +x "$ROOT/script/systems-stdlib-inventory.sh" 2>/dev/null || true
inv_err="$(mktemp)"
set +e
inv_out="$("$ROOT/script/systems-stdlib-inventory.sh" 2>"$inv_err")"
inv_rc=$?
set -e
inv_combined="$(cat "$inv_err"; printf '%s\n' "$inv_out")"
rm -f "$inv_err"

fs_ready=0 fs_planned=0 dual_host=0 host_only=0
if [[ "$inv_rc" -ne 0 ]]; then
  emit_fail "systems-stdlib-inventory.sh exit $inv_rc"
else
  if [[ "$inv_combined" =~ fs-ready=([0-9]+) ]]; then fs_ready="${BASH_REMATCH[1]}"; fi
  if [[ "$inv_combined" =~ fs-planned=([0-9]+) ]]; then fs_planned="${BASH_REMATCH[1]}"; fi
  if [[ "$inv_combined" =~ dual-host=([0-9]+) ]]; then dual_host="${BASH_REMATCH[1]}"; fi
  if [[ "$inv_combined" =~ host-only=([0-9]+) ]]; then host_only="${BASH_REMATCH[1]}"; fi
fi

disk_fs="$(find "$ROOT/src/Systems" -name '*.lean' 2>/dev/null | wc -l | tr -d ' ')"
if [[ -n "$disk_fs" && "$disk_fs" != "$fs_ready" ]]; then
  emit_fail "disk Systems=$disk_fs ≠ inventory fs-ready=$fs_ready"
fi

# --- PRODUCT_STDLIB count (fail-closed: empty/missing manifest is not OK) ---
PRODUCT_MANIFEST="${SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST:-$ROOT/script/systems-product-stdlib-modules.txt}"
product_n=0
if [[ ! -f "$PRODUCT_MANIFEST" ]]; then
  emit_fail "missing PRODUCT manifest: $PRODUCT_MANIFEST"
else
  # grep exit 1 on zero matches must not abort under pipefail.
  product_n="$(grep -vE '^(#|[[:space:]]*$)' "$PRODUCT_MANIFEST" 2>/dev/null | wc -l | tr -d ' ' || true)"
  product_n="${product_n:-0}"
  if [[ "$product_n" -eq 0 ]]; then
    emit_fail "PRODUCT_STDLIB empty (comment-only or blank): $PRODUCT_MANIFEST"
  elif [[ "$fs_ready" -gt 0 && "$product_n" != "$fs_ready" ]]; then
    emit_fail "PRODUCT_STDLIB=$product_n ≠ fs-ready=$fs_ready"
  fi
fi

# --- Doc generated fs-ready (advisory parse; FAIL only if unreadable when present markers) ---
OUT_DOC="$ROOT/doc/dev/systems-lean-stdlib-inventory.md"
doc_ready="MISSING"
if [[ -f "$OUT_DOC" ]] && command -v python3 >/dev/null 2>&1; then
  doc_ready="$(python3 - "$OUT_DOC" <<'PY'
import re, sys
from pathlib import Path
text = Path(sys.argv[1]).read_text(encoding="utf-8")
start = "<!-- GENERATED-BY script/systems-stdlib-inventory.sh"
end = "<!-- END GENERATED inventory -->"
if start not in text or end not in text:
    print("MISSING", end="")
    raise SystemExit(0)
section = text[text.index(start):text.index(end)]
m = re.search(r"`fs-ready`[^|]*\|\s*(\d+)\s*\|", section)
if not m:
    m = re.search(r"\|\s*`fs-ready`\s*\|[^|]*\|\s*(\d+)\s*\|", section)
if not m:
    m = re.search(r"\|\s*Systems\s*\|\s*(\d+)\s*\|", section)
print(m.group(1) if m else "MISSING", end="")
PY
)"
  if [[ "$doc_ready" != "MISSING" && "$doc_ready" != "$fs_ready" && "$fs_ready" -gt 0 ]]; then
    emit_fail "inventory doc fs-ready=$doc_ready drifts from live=$fs_ready (run inventory --write)"
  fi
fi

# --- Stage1 / bundle presence ---
LEAN_BIN="${SYSTEMS_LEAN_TCB_LEAN:-$ROOT/build/release/stage1/bin/lean}"
if [[ ! -x "$LEAN_BIN" ]] && command -v lean >/dev/null 2>&1; then
  LEAN_BIN="$(command -v lean)"
fi
stage1=0
[[ -x "$LEAN_BIN" ]] && stage1=1
BUNDLE="${SYSTEMS_LEAN_TCB_BUNDLE:-$ROOT/tests/lake/examples/systems/lib/.lake/build/lib/libfs_extract_bundle.a}"
bundle=0
[[ -f "$BUNDLE" && -s "$BUNDLE" ]] && bundle=1

# --- PRODUCT_FS_NEXT + measured host residual + product GC tokens (light; no full validate) ---
PRODUCT_FS_NEXT="H5_host,TomlConfig_more89,Slake_parity_more"
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL=unmeasured
# Product residual tokens: nm-advisory via inventory when scannable; else 0 (unchecked).
# H2: PRODUCT_GC_FREE is independent of GC_FREE_ELABORATOR (can be 1 while host stays 0).
PRODUCT_GC_FREE=0
PRODUCT_NO_LEANSHARED=0
if [[ -f "$ROOT/script/systems-tcb-inventory.sh" && "$stage1" -eq 1 ]]; then
  chmod +x "$ROOT/script/systems-tcb-inventory.sh" 2>/dev/null || true
  set +e
  tcb_out="$(SYSTEMS_LEAN_TCB_LEAN="$LEAN_BIN" "$ROOT/script/systems-tcb-inventory.sh" 2>&1)"
  tcb_rc=$?
  set -e
  if [[ "$tcb_rc" -eq 0 ]]; then
    line="$(printf '%s\n' "$tcb_out" | grep -E '^PRODUCT_FS_NEXT=' | tail -n 1 || true)"
    [[ -n "$line" ]] && PRODUCT_FS_NEXT="${line#PRODUCT_FS_NEXT=}"
    line="$(printf '%s\n' "$tcb_out" | grep -E '^GC_FREE_ELABORATOR=' | tail -n 1 || true)"
    [[ -n "$line" ]] && GC_FREE_ELABORATOR="${line#GC_FREE_ELABORATOR=}"
    line="$(printf '%s\n' "$tcb_out" | grep -E '^HOST_ELABORATOR_RESIDUAL=' | tail -n 1 || true)"
    [[ -n "$line" ]] && HOST_ELABORATOR_RESIDUAL="${line#HOST_ELABORATOR_RESIDUAL=}"
    line="$(printf '%s\n' "$tcb_out" | grep -E '^PRODUCT_GC_FREE=' | tail -n 1 || true)"
    [[ -n "$line" ]] && PRODUCT_GC_FREE="${line#PRODUCT_GC_FREE=}"
    line="$(printf '%s\n' "$tcb_out" | grep -E '^PRODUCT_NO_LEANSHARED=' | tail -n 1 || true)"
    [[ -n "$line" ]] && PRODUCT_NO_LEANSHARED="${line#PRODUCT_NO_LEANSHARED=}"
  fi
elif [[ -f "$ROOT/script/systems-tcb-inventory.sh" ]]; then
  # Parse curated PRODUCT_FS_NEXT from script source when lean absent.
  line="$(grep -E '^PRODUCT_FS_NEXT=' "$ROOT/script/systems-tcb-inventory.sh" | head -n 1 || true)"
  [[ -n "$line" ]] && PRODUCT_FS_NEXT="${line#PRODUCT_FS_NEXT=}"
  PRODUCT_FS_NEXT="${PRODUCT_FS_NEXT//\"/}"
fi

echo "=== Systems Lean status (fast; not full validate) ==="
echo "FS_READY=${fs_ready}"
# FS_PLANNED is an Init/Std inventory heuristic (host-side planned count), not PRODUCT_STDLIB / FS_READY.
echo "FS_PLANNED=${fs_planned}"
echo "DUAL_HOST=${dual_host}"
echo "HOST_ONLY=${host_only}"
echo "PRODUCT_STDLIB_MODULES_COUNT=${product_n}"
echo "PRODUCT_FS_NEXT=${PRODUCT_FS_NEXT}"
echo "GC_FREE_ELABORATOR=${GC_FREE_ELABORATOR}"
echo "HOST_ELABORATOR_RESIDUAL=${HOST_ELABORATOR_RESIDUAL}"
echo "PRODUCT_GC_FREE=${PRODUCT_GC_FREE}"
echo "PRODUCT_NO_LEANSHARED=${PRODUCT_NO_LEANSHARED}"
# H2 dual-path honesty: product residual free does not require elaborator GC-free.
echo "note: PRODUCT_GC_FREE=1 can hold while GC_FREE_ELABORATOR=0 (independent axes; H2)"
echo "STAGE1_LEAN=${stage1}"
echo "BUNDLE_PRESENT=${bundle}"
echo "INVENTORY_DOC_FS_READY=${doc_ready}"
echo "SYSTEMS_STATUS_OK=${status_ok}"

if [[ "$status_ok" -ne 1 ]]; then
  exit 1
fi
exit 0
