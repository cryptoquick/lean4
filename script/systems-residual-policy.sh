#!/usr/bin/env bash
# Systems Lean unified residual policy (W0).
#
# Source this file from product gates so nm / IR greps stay aligned:
#   # shellcheck source=systems-residual-policy.sh
#   source "$(dirname "$0")/systems-residual-policy.sh"
#
# ResidualFree product objects must not require Lean GC/RC dynlibs and must not
# embed Lean object runtime symbols. Classic stage1 is untouched.
#
# Forbidden (product path):
#   - nm undefined: U lean_* , U l_*  (not U lp_* freestanding mangles)
#   - Init_shared / leanshared name residues
#   - defined [TtWw] symbols matching residual RC/object entry points
#   - IR/C text: aligned with freestanding check-ir + MemSafetyCert.forbiddenRuntimePatterns
#     (lean_object, lean_inc/dec, lean_alloc*, lean_box/unbox, initialize_, lean_io_,
#      lean_ctor*, lean_apply*, lean/lean.h, Prod|Slice, Init_shared/libleanshared)
#
# Allowed product exports include lean_fs_* / lean_systems_* and freestanding
# mangled roots (lp_systems__*); those are not U lean_* / U l_*.
#
# Do not invent S14+ slices here; keep patterns tight and fail-closed.

# Regex: defined residual RC/object entry points (nm type letters matched by caller).
# shellcheck disable=SC2034
SYSTEMS_LEAN_RC_DEF_RE='lean_inc|lean_dec|lean_alloc_ctor|lean_box|lean_unbox|lean_object|lean_initialize|lean_mark_persistent|lean_alloc_small|lean_alloc_object|lean_free_object|lean_is_exclusive|lean_is_scalar|lean_ctor_get|lean_ctor_set|lean_apply_|lean_mk_string|lean_io_'

# Regex: residual markers in freestanding IR / C text (check-ir + MemSafetyCert overlap).
# Product lean_fs_* helpers alone are not matched (no bare lean_fs in this RE).
# shellcheck disable=SC2034
SYSTEMS_LEAN_IR_RESIDUAL_RE='lean_object|lean_inc|lean_dec|lean_alloc|lean_box|lean_unbox|initialize_|lean_io_|lean_ctor|lean_apply|lean/lean\.h|Prod|Slice|libleanshared|Init_shared'

# Shared-lib name residues.
# shellcheck disable=SC2034
SYSTEMS_LEAN_SHARED_RE='Init_shared|leanshared'

# Product freestanding C modules — loaded from PRODUCT_STDLIB_MODULES manifest
# (script/systems-product-stdlib-modules.txt). Nested Par modules use path segments
# (ir/Systems/Parallelism/Simd.c). Single source of truth for residual / ccomp matrix.
# shellcheck disable=SC2034
SYSTEMS_LEAN_PRODUCT_FS_MODULES=()
_systems_lean_load_product_fs_modules() {
  local root manifest line
  # When sourced from script/, dirname is script/; repo root is parent.
  root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  manifest="${SYSTEMS_LEAN_PRODUCT_STDLIB_MANIFEST:-$root/script/systems-product-stdlib-modules.txt}"
  SYSTEMS_LEAN_PRODUCT_FS_MODULES=()
  if [[ ! -f "$manifest" ]]; then
    echo "FAIL: missing PRODUCT_STDLIB_MODULES manifest: $manifest" >&2
    return 1
  fi
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue
    SYSTEMS_LEAN_PRODUCT_FS_MODULES+=("$line")
  done <"$manifest"
  if [[ "${#SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}" -eq 0 ]]; then
    echo "FAIL: PRODUCT_STDLIB_MODULES manifest empty: $manifest" >&2
    return 1
  fi
  return 0
}
# Soft load at source time (regex helpers still work if manifest is absent in disposable trees).
# Product IR / residual gates must call systems_lean_require_product_fs_modules (fail-closed).
_systems_lean_load_product_fs_modules || true

# Fail-closed: non-empty SYSTEMS_LEAN_PRODUCT_FS_MODULES (reload once if empty).
systems_lean_require_product_fs_modules() {
  if [[ "${#SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}" -eq 0 ]]; then
    _systems_lean_load_product_fs_modules || return 1
  fi
  if [[ "${#SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}" -eq 0 ]]; then
    echo "FAIL: PRODUCT_STDLIB_MODULES empty (residual matrix cannot run)" >&2
    return 1
  fi
  return 0
}

# Return 0 if nm undef text has forbidden U lean_* or U l_* (not U lp_*).
systems_lean_nm_undef_has_runtime() {
  local undef="$1"
  echo "$undef" | grep -qE '[[:space:]]U[[:space:]]+lean_' && return 0
  echo "$undef" | grep -qE '[[:space:]]U[[:space:]]+l_' && return 0
  return 1
}

# Return 0 if file text matches residual IR markers (product must not contain these).
systems_lean_ir_file_has_residual() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  grep -qE "$SYSTEMS_LEAN_IR_RESIDUAL_RE" "$f"
}

# Grep product freestanding IR/C files under a root (e.g. lib/.lake/build/ir).
# Prints FAIL lines to stderr and returns 1 if any residual is found or required files missing.
# Args: ir_root [extract_c]
systems_lean_check_product_ir_residuals() {
  local ir_root="$1"
  local extract_c="${2:-$ir_root/Extract.c}"
  local bad=0
  local f m
  # Fail-closed: never IR-check with an empty product matrix (load failure / missing manifest).
  if ! systems_lean_require_product_fs_modules; then
    return 1
  fi
  if [[ ! -f "$extract_c" ]]; then
    echo "FAIL: missing product Extract C for residual IR check: $extract_c" >&2
    return 1
  fi
  if systems_lean_ir_file_has_residual "$extract_c"; then
    echo "FAIL: residual Lean RC/object markers in product IR: $extract_c" >&2
    grep -nE "$SYSTEMS_LEAN_IR_RESIDUAL_RE" "$extract_c" >&2 || true
    bad=1
  fi
  # Hard-require companion directory + every listed product module (no fail-open).
  if [[ ! -d "$ir_root/Systems" ]]; then
    echo "FAIL: missing Systems companion directory: $ir_root/Systems" >&2
    return 1
  fi
  for m in "${SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}"; do
    f="$ir_root/Systems/${m}.c"
    if [[ ! -f "$f" ]]; then
      echo "FAIL: missing freestanding companion IR $f" >&2
      bad=1
      continue
    fi
    if systems_lean_ir_file_has_residual "$f"; then
      echo "FAIL: residual Lean RC/object markers in product IR: $f" >&2
      grep -nE "$SYSTEMS_LEAN_IR_RESIDUAL_RE" "$f" >&2 || true
      bad=1
    fi
  done
  [[ "$bad" -eq 0 ]]
}

# Print paths of product C TUs (Extract + every listed Systems module).
# Always emits the full expected matrix (paths even if missing) so callers see complete counts.
# Returns 1 if any Systems companion is missing (fail-closed listing).
# Args: ir_root extract_c
systems_lean_list_product_c_tus() {
  local ir_root="$1"
  local extract_c="$2"
  local m f bad=0
  if ! systems_lean_require_product_fs_modules; then
    return 1
  fi
  printf '%s\n' "$extract_c"
  for m in "${SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}"; do
    f="$ir_root/Systems/${m}.c"
    printf '%s\n' "$f"
    if [[ ! -f "$f" ]]; then
      echo "FAIL: missing product TU $f" >&2
      bad=1
    fi
  done
  [[ "$bad" -eq 0 ]]
}
