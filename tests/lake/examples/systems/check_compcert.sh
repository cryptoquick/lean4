#!/usr/bin/env bash
# Real CompCert pipeline on freestanding-generated C (Systems Lean dogfood only).
# Classic Lean users never need this; default `make check` does not invoke CompCert.
#
# Requires: ccomp via optional ./ref CompCert, SYSTEMS_LEAN_COMPCERT_RESULT, nix, or PATH.
# Env:
#   SYSTEMS_LEAN_COMPCERT_RESULT  — dir with bin/ccomp (escape hatch / CI cache)
#   SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 — only accept ccomp from lean4 ./ref (accomplishment gate)
#   SYSTEMS_LEAN_ALLOW_NO_COMPCERT=1 — exit 0 with SKIP if ccomp unavailable (not R3 success)
#   SYSTEMS_LEAN_COMPCERT_REQUIRE=1 — refuse SKIP even if ALLOW_NO_COMPCERT is set (for check-full)
# Discovery order: ./ref ccomp → RESULT → result-compcert → flake pkgs.compcert → PATH
# With REQUIRE_REF=1, only ./ref is accepted (fail closed as tool discovery; never SKIP).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
LEAN4_ROOT="$(cd "$ROOT/../../../.." && pwd)"
# Override for disposable trees / compliant negatives (must contain Extract.c + Systems/).
IR_DIR="${SYSTEMS_LEAN_COMPCERT_IR_DIR:-$ROOT/lib/.lake/build/ir}"
EXTRACT_C="${1:-$IR_DIR/Extract.c}"
OUT_DIR="${2:-$ROOT/out/compcert}"
mkdir -p "$OUT_DIR"

# Product TU matrix: Extract + every PRODUCT_STDLIB_MODULES companion (SSoT).
# Loaded via systems-residual-policy (nested Par modules use path segments).
# shellcheck source=../../../script/systems-residual-policy.sh
source "$LEAN4_ROOT/script/systems-residual-policy.sh"
if ! systems_lean_require_product_fs_modules; then
  echo "FAIL: cannot load PRODUCT_STDLIB_MODULES for CompCert dogfood matrix" >&2
  exit 1
fi
PRODUCT_FS_MODULES=("${SYSTEMS_LEAN_PRODUCT_FS_MODULES[@]}")

die() { echo "FAIL: $*" >&2; exit 1; }

if [[ ! -f "$EXTRACT_C" ]]; then
  die "missing $EXTRACT_C (build freestanding extract first: lake --dir=lib build)"
fi

require_claims() {
  local f="$1"
  grep -q 'SYSTEMS_LEAN_MEMSAFE_CERT' "$f" \
    || die "$f missing MemSafetyCert (SYSTEMS_LEAN_MEMSAFE_CERT)"
  grep -q 'qtt_zero_quantity_erased' "$f" \
    || die "$f missing QTT 0-qty claim (qtt_zero_quantity_erased)"
  # CompCert-oriented obligation cert is required for the dogfood path (Lean layer).
  grep -q 'SYSTEMS_LEAN_COMPCERT_MEMCERT' "$f" \
    || die "$f missing CompCert-oriented cert (SYSTEMS_LEAN_COMPCERT_MEMCERT)"
}

require_claims "$EXTRACT_C"
SOURCES=("$EXTRACT_C")
for _m in "${PRODUCT_FS_MODULES[@]}"; do
  _f="$IR_DIR/Systems/${_m}.c"
  # Fail-closed: every manifest module must exist (matches residual-policy / CcompAccepts).
  if [[ ! -f "$_f" ]]; then
    die "missing product Freestanding IR $_f (build freestanding extract first)"
  fi
  require_claims "$_f"
  SOURCES+=("$_f")
done
unset _m _f

# Strip Lean certificate footers so ccomp sees pure ISO C (certs are /* … */ comments,
# but we also drop them for a clean TU and smaller log surface).
# Also drop clang/GCC diagnostic pragmas and the empty #if guards that wrap them.
strip_to_pure() {
  local src="$1" dest="$2"
  python3 - "$src" "$dest" <<'PY'
from pathlib import Path
import re
import sys

src_path = Path(sys.argv[1])
dest_path = Path(sys.argv[2])
text = src_path.read_text()
for marker in (
    "/* SYSTEMS_LEAN_MEMSAFE_CERT begin",
    "/* SYSTEMS_LEAN_COMPCERT_MEMCERT begin",
):
    i = text.find(marker)
    if i >= 0:
        text = text[:i]
# Drop compiler-specific diagnostic pragmas (not part of CompCert's ISO subset focus).
text = re.sub(
    r"^[ \t]*#pragma\s+(?:clang|GCC)\s+diagnostic\b[^\n]*\n",
    "",
    text,
    flags=re.MULTILINE,
)
# Drop empty clang/GCC diagnostic guard blocks left after pragma strip, e.g.
#   #if defined(__clang__)
#   #elif defined(__GNUC__) && !defined(__CLANG__)
#   #endif
# Only matches shallow empty guards (no nested #if inside the span).
text = re.sub(
    r"^[ \t]*#if[ \t]+defined\(__clang__\)[ \t]*\n"
    r"(?:[ \t]*\n)*"
    r"(?:[ \t]*#elif[^\n]*\n(?:[ \t]*\n)*)*"
    r"[ \t]*#endif[ \t]*\n",
    "",
    text,
    flags=re.MULTILINE,
)
if not text.endswith("\n"):
    text += "\n"
dest_path.write_text(text)
print(f"OK: pure C for CompCert: {dest_path}")
PY
}

PURE_FILES=()
OBJ_FILES=()
for src in "${SOURCES[@]}"; do
  base="$(basename "$src" .c)"
  pure="$OUT_DIR/${base}.pure.c"
  obj="$OUT_DIR/${base}.o"
  strip_to_pure "$src" "$pure"
  PURE_FILES+=("$pure")
  OBJ_FILES+=("$obj")
done

# Resolve bindir containing an executable ccomp. Never invent Cachix.
# Prints the directory to put first on PATH (parent of ccomp).
# Order: ./ref → SYSTEMS_LEAN_COMPCERT_RESULT → result-compcert.
# REQUIRE_REF=1 accepts only ./ref (tool discovery fail-closed if missing).
find_ccomp_bindir() {
  local cand g ref_c
  local require_ref="${SYSTEMS_LEAN_COMPCERT_REQUIRE_REF:-0}"

  # Optional ./ref CompCert (accomplishment path; preferred; exclusive under REQUIRE_REF).
  for ref_c in \
      "$LEAN4_ROOT/ref/ccomp" \
      "$LEAN4_ROOT/ref/bin/ccomp" \
      "$LEAN4_ROOT/ref/ccomp.opt"; do
    if [[ -x "$ref_c" ]]; then
      dirname "$ref_c"
      return 0
    fi
  done

  if [[ "$require_ref" == "1" ]]; then
    echo "FAIL: tool discovery: SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 but no ccomp under $LEAN4_ROOT/ref" >&2
    echo "hint: see ref/README.md (git submodule / manual CompCert build). Tool discovery, not a product residual." >&2
    return 1
  fi

  if [[ -n "${SYSTEMS_LEAN_COMPCERT_RESULT:-}" ]]; then
    cand="${SYSTEMS_LEAN_COMPCERT_RESULT}"
    if [[ -x "$cand/bin/ccomp" ]]; then
      echo "$cand/bin"
      return 0
    fi
    echo "WARN: SYSTEMS_LEAN_COMPCERT_RESULT=$cand has no bin/ccomp; ignoring" >&2
  fi

  for g in "$LEAN4_ROOT/result-compcert" "$ROOT/result-compcert"; do
    if [[ -x "$g/bin/ccomp" ]]; then
      echo "$g/bin"
      return 0
    fi
  done
  return 1
}

# Back-compat name: prints store-style dir with bin/ccomp, or empty.
find_compcert_result() {
  local bindir
  if bindir="$(find_ccomp_bindir 2>/dev/null)"; then
    # Prefer parent when bindir ends with /bin
    if [[ "$(basename "$bindir")" == "bin" ]]; then
      echo "$(dirname "$bindir")"
      return 0
    fi
    # ./ref ccomp lives in ref/ — synthesize a "result" only for messaging
    echo "$bindir"
    return 0
  fi
  return 1
}

# Build compile command list for all pure TUs → objects (ccomp must be on PATH).
ccomp_compile_cmds() {
  local i pure obj base
  echo "set -euo pipefail"
  echo "ccomp -version > '$OUT_DIR/ccomp-version.txt'"
  echo "cat '$OUT_DIR/ccomp-version.txt'"
  echo ": > '$OUT_DIR/ccomp.log'"
  for i in "${!PURE_FILES[@]}"; do
    pure="${PURE_FILES[$i]}"
    obj="${OBJ_FILES[$i]}"
    base="$(basename "$pure" .pure.c)"
    # Object is the hard requirement; assembly is best-effort for inspection.
    echo "echo '=== ccomp -c $base ==='"
    echo "echo '=== ccomp -c $base ===' >> '$OUT_DIR/ccomp.log'"
    echo "ccomp -c -o '$obj' '$pure' >>'$OUT_DIR/ccomp.log' 2>&1"
    echo "ccomp -S -o '$OUT_DIR/${base}.s' '$pure' >>'$OUT_DIR/ccomp.log' 2>&1 || true"
  done
}

# Run compile cmds with a fixed PATH prefix and without host LD_LIBRARY_PATH
# (host /usr/lib paths make nix-wrapped ccomp segfault).
# Write cmds to a temp script — `bash -lc "$cmds"` hits ARG_MAX once the product
# matrix is large (~167 TUs / ~130KB of shell text).
run_ccomp_with_bin() {
  local bindir="$1"
  local cmds script
  cmds="$(ccomp_compile_cmds)"
  # Record which ccomp ran for compliant receipts (this-run only).
  printf '%s\n' "${bindir}/ccomp" >"$OUT_DIR/ccomp-path.txt"
  script="$OUT_DIR/ccomp-run.sh"
  printf '%s\n' "$cmds" >"$script"
  env -u LD_LIBRARY_PATH PATH="${bindir}:/usr/bin:/bin" bash "$script"
}

# Flake nixpkgs pkgs.compcert only — requires working nix; failures should fall through.
run_ccomp_flake() {
  local cmds script
  cmds="$(ccomp_compile_cmds)"
  # Record discovery path for receipts (refined to store path if `command -v ccomp` works in shell).
  printf '%s\n' "nix-shell:flake-pkgs.compcert" >"$OUT_DIR/ccomp-path.txt"
  # Prepend path capture without breaking ccomp_compile_cmds quoting.
  cmds="command -v ccomp >/dev/null 2>&1 && command -v ccomp >'$OUT_DIR/ccomp-path.txt' || true
$cmds"
  script="$OUT_DIR/ccomp-run.sh"
  printf '%s\n' "$cmds" >"$script"
  env -u LD_LIBRARY_PATH NIXPKGS_ALLOW_UNFREE="${NIXPKGS_ALLOW_UNFREE:-1}" \
    nix shell --impure --expr "
      let
        flake = builtins.getFlake \"$LEAN4_ROOT\";
        pkgs = import flake.inputs.nixpkgs {
          system = builtins.currentSystem;
          config.allowUnfree = true;
        };
      in pkgs.compcert
    " -c env -u LD_LIBRARY_PATH bash "$script"
}

# Track whether ccomp actually started (for error messages).
CCOMP_ATTEMPTED=0

run_ccomp() {
  local bindir ec
  local require_ref="${SYSTEMS_LEAN_COMPCERT_REQUIRE_REF:-0}"

  # 1) ./ref, RESULT, or result-compcert (see find_ccomp_bindir).
  # stderr from find_ccomp_bindir (tool-discovery FAIL / WARNs) still reaches the terminal.
  if bindir="$(find_ccomp_bindir)"; then
    echo "=== CompCert via $bindir/ccomp ==="
    CCOMP_ATTEMPTED=1
    run_ccomp_with_bin "$bindir"
    return $?
  fi

  if [[ "$require_ref" == "1" ]]; then
    # find_ccomp_bindir already printed tool-discovery FAIL for missing ref.
    # Distinct from 127 (generic missing ccomp) so main never SKIP under ALLOW_NO_COMPCERT.
    return 126
  fi

  # 2) Flake nixpkgs pkgs.compcert (unfree). On nix/eval failure, fall through to PATH.
  if command -v nix >/dev/null 2>&1 && [[ -f "$LEAN4_ROOT/flake.nix" ]]; then
    echo "=== CompCert via nix shell (flake nixpkgs pkgs.compcert, allowUnfree) ==="
    export NIXPKGS_ALLOW_UNFREE=1
    set +e
    run_ccomp_flake
    ec=$?
    set -e
    if [[ $ec -eq 0 ]]; then
      CCOMP_ATTEMPTED=1
      return 0
    fi
    # Distinguish "ccomp ran and rejected C" (log has TU markers) from "nix failed".
    if [[ -s "$OUT_DIR/ccomp.log" ]] && grep -q '=== ccomp -c ' "$OUT_DIR/ccomp.log" 2>/dev/null; then
      CCOMP_ATTEMPTED=1
      return "$ec"
    fi
    echo "WARN: flake pkgs.compcert path failed (exit $ec); trying host PATH ccomp" >&2
    # Reset empty version/log leftovers from a failed nix shell that never reached ccomp.
    if [[ ! -s "$OUT_DIR/ccomp-version.txt" ]]; then
      : > "$OUT_DIR/ccomp-version.txt"
    fi
  fi

  # 3) Host PATH last: often broken (mismatched glibc); prefer result pin above.
  if command -v ccomp >/dev/null 2>&1; then
    echo "=== CompCert via host PATH ccomp (fallback; prefer SYSTEMS_LEAN_COMPCERT_RESULT) ==="
    local host_bin
    host_bin="$(dirname "$(command -v ccomp)")"
    if env -u LD_LIBRARY_PATH PATH="$host_bin:/usr/bin:/bin" ccomp -version >/dev/null 2>&1; then
      CCOMP_ATTEMPTED=1
      run_ccomp_with_bin "$host_bin"
      return $?
    fi
    if ccomp -version >/dev/null 2>&1; then
      # Ambient LD_LIBRARY_PATH may be required for this host ccomp; still avoid
      # `bash -lc "$(ccomp_compile_cmds)"` (ARG_MAX at ~167 TUs). Write script and
      # keep PATH pin; do not strip LD_LIBRARY_PATH here.
      CCOMP_ATTEMPTED=1
      local cmds script
      cmds="$(ccomp_compile_cmds)"
      printf '%s\n' "${host_bin}/ccomp" >"$OUT_DIR/ccomp-path.txt"
      script="$OUT_DIR/ccomp-run.sh"
      printf '%s\n' "$cmds" >"$script"
      env PATH="$host_bin:/usr/bin:/bin" bash "$script"
      return $?
    fi
    echo "WARN: host ccomp -version failed; not using PATH ccomp" >&2
    return 127
  fi

  return 127
}

set +e
run_ccomp
ec=$?
set -e

# On failure after a real ccomp attempt, dump the log.
if [[ $ec -ne 0 && $ec -ne 126 && $ec -ne 127 && -s "$OUT_DIR/ccomp.log" ]]; then
  echo "--- ccomp.log ---" >&2
  cat "$OUT_DIR/ccomp.log" >&2 || true
fi

# REQUIRE_REF tool discovery: fail closed (never SKIP, even with ALLOW_NO_COMPCERT).
if [[ $ec -eq 126 ]]; then
  die "tool discovery: SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 requires ccomp under $LEAN4_ROOT/ref (see ref/README.md)"
fi

if [[ $ec -eq 127 ]]; then
  echo "How to obtain CompCert (Systems Lean dogfood only; not required for classic Lean):" >&2
  echo "  # Preferred accomplishment path: optional ./ref CompCert (see $LEAN4_ROOT/ref/README.md)" >&2
  echo "  # From lean4 root ($LEAN4_ROOT):" >&2
  echo "  export NIXPKGS_ALLOW_UNFREE=1" >&2
  echo "  # Or pinned result (avoids host PATH ccomp / host LD_LIBRARY_PATH issues):" >&2
  cat <<EOF >&2
  nix build --impure --expr "
    let flake = builtins.getFlake \"$LEAN4_ROOT\";
        pkgs = import flake.inputs.nixpkgs {
          system = builtins.currentSystem; config.allowUnfree = true;
        };
    in pkgs.compcert
  " -o result-compcert
  export SYSTEMS_LEAN_COMPCERT_RESULT=\"\$PWD/result-compcert\"
  # Then: make -C tests/lake/examples/systems check-compcert
EOF
  if [[ "${SYSTEMS_LEAN_COMPCERT_REQUIRE:-}" == "1" ]]; then
    die "CompCert required (SYSTEMS_LEAN_COMPCERT_REQUIRE=1); install ccomp as above"
  fi
  if [[ "${SYSTEMS_LEAN_ALLOW_NO_COMPCERT:-}" == "1" ]]; then
    echo "SKIP: CompCert not installed (SYSTEMS_LEAN_ALLOW_NO_COMPCERT=1)"
    echo "NOTE: SKIP is not R3 success; use make check-compcert with ccomp available, or make check-full"
    exit 0
  fi
  die "CompCert (ccomp) not available; install as above"
fi

if [[ $ec -ne 0 ]]; then
  if [[ "${CCOMP_ATTEMPTED:-0}" -eq 1 ]] || { [[ -s "$OUT_DIR/ccomp.log" ]] && grep -q '=== ccomp -c ' "$OUT_DIR/ccomp.log" 2>/dev/null; }; then
    die "CompCert rejected freestanding C (exit $ec; see $OUT_DIR/ccomp.log)"
  fi
  die "could not run CompCert (exit $ec; ccomp may not have started — see install help / $OUT_DIR/ccomp.log)"
fi

for obj in "${OBJ_FILES[@]}"; do
  [[ -f "$obj" ]] || die "missing object $obj after ccomp"
done

# Proof receipt: Lean memsafe+CompCert certs + real ccomp success.
{
  echo "OK: real CompCert pipeline passed"
  echo "date: $(date -Is 2>/dev/null || date)"
  echo "ccomp: $(head -n1 "$OUT_DIR/ccomp-version.txt" 2>/dev/null || echo unknown)"
  echo "sources:"
  for src in "${SOURCES[@]}"; do
    echo "  - $src"
  done
  echo "objects:"
  for obj in "${OBJ_FILES[@]}"; do
    echo "  - $obj ($(wc -c <"$obj") bytes)"
  done
  echo "claims: MemSafetyCert + qtt_zero_quantity_erased + CompCertCert (stripped before ccomp)"
  echo "receipt: memsafe+QTT+compcert-cert claims; ccomp -c success; objects under $OUT_DIR"
} | tee "$OUT_DIR/proof-receipt.txt"

echo "OK: CompCert compiled freestanding C → ${OBJ_FILES[*]}"
echo "OK: real CompCert pipeline passed"
exit 0
