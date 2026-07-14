#!/usr/bin/env bash
# Build or pin CompCert `ccomp` for Systems Lean compliance gates.
#
# PROVABLY path (preferred order):
#   1. Real ELF already at `ref/CompCert/ccomp`
#   2. Coq/OCaml in-tree rebuild of the submodule
#   3. Prebuilt ELF pin: copy RESULT/nix `.ccomp-wrapped` → `ref/CompCert/ccomp`
#      (real machine code under ref/CompCert; **not** a Coq-from-source rebuild)
# Dogfood path: shell launcher under `ref/bin` that only execs RESULT/nix
# (never eligible for the PROVABLY token).
#
# Usage (from lean4 root):
#   ./ref/build-ccomp.sh              # auto: real binary / rebuild / flake pin / dogfood
#   ./ref/build-ccomp.sh --flake      # hermetic: nix build .#compcert → pin ELF under ref/CompCert/
#   ./ref/build-ccomp.sh --pin-elf    # force prebuilt ELF pin from RESULT/nix
#   ./ref/build-ccomp.sh --nix        # RESULT/nix launcher only (DOGFOOD)
#   ./ref/build-ccomp.sh --status     # discovery / resolved paths only
#
# Hermetic multi-platform path (no host Rocq/OCaml required):
#   nix build .#compcert -o result-compcert   # or: ./ref/build-ccomp.sh --flake
#   # packages: .#compcert / .#systems-compcert ; app: nix run .#ccomp -- -version
#   # shell:    nix develop .#compcert          # ccomp + coqc + ocaml on PATH
#
# Env:
#   SYSTEMS_LEAN_COMPCERT_RESULT  — path to result-compcert-style prefix (bin/ccomp)
#   NIX_BUILD_CORES               — passed through to make when set
#
# Honesty:
#   * PROVABLY requires a non-shell binary under ref/CompCert/ (ELF/Mach-O)
#   * A launcher under ref/bin or even ref/CompCert that only execs nix/RESULT
#     is DOGFOOD only — never PROVABLY
#   * Prebuilt ELF pin satisfies the path criterion but is **not** a claim that
#     we rebuilt CompCert from Coq sources in this tree (see ref/ccomp.PIN.txt)
#   * This script never prints PROVABLY_* tokens
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
CCERT="$ROOT/ref/CompCert"
BIN_DIR="$ROOT/ref/bin"
RESULT="${SYSTEMS_LEAN_COMPCERT_RESULT:-$ROOT/result-compcert}"

mode="auto"
for a in "$@"; do
  case "$a" in
    --nix) mode="nix" ;;
    --pin-elf) mode="pin-elf" ;;
    --flake) mode="flake" ;;
    --status) mode="status" ;;
    --help|-h)
      sed -n '2,40p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "usage: $0 [--flake|--pin-elf|--nix|--status|--help]" >&2
      exit 2
      ;;
  esac
done

is_shell_script() {
  local p="$1"
  [[ -f "$p" ]] || return 1
  head -c 2 "$p" 2>/dev/null | grep -q $'#!' && return 0
  head -n1 "$p" 2>/dev/null | grep -qE '^#!.*\b(ba)?sh\b' && return 0
  if command -v file >/dev/null 2>&1; then
    file -b "$p" 2>/dev/null | grep -qiE 'shell script|Bourne|bash script|ASCII text|UTF-8 Unicode text' && return 0
  fi
  return 1
}

is_real_compcert_binary() {
  local p="$1"
  [[ -n "$p" && -f "$p" && -x "$p" ]] || return 1
  is_shell_script "$p" && return 1
  if command -v file >/dev/null 2>&1; then
    local desc
    desc="$(file -b "$p" 2>/dev/null || true)"
    printf '%s' "$desc" | grep -qiE 'ELF|Mach-O|PE32|executable' || return 1
    return 0
  fi
  return 0
}

# Resolve launcher/symlink to the path that will actually run (best-effort).
resolve_ccomp() {
  local p="$1"
  local rp target line
  [[ -e "$p" ]] || { echo ""; return 0; }

  if [[ -L "$p" ]]; then
    rp="$(readlink -f "$p" 2>/dev/null || readlink "$p")"
    # Recurse once if the target is another launcher.
    if [[ -n "$rp" && -e "$rp" ]]; then
      if is_shell_script "$rp"; then
        resolve_ccomp "$rp"
        return 0
      fi
      echo "$rp"
      return 0
    fi
    echo "$p"
    return 0
  fi

  if is_shell_script "$p"; then
    # Prefer real in-tree CompCert binary if present.
    if is_real_compcert_binary "$CCERT/ccomp"; then
      echo "$CCERT/ccomp"
      return 0
    fi
    # Parse explicit absolute exec paths from the launcher (RESULT / nix store).
    # Prefer lines that look like real binaries, not the launcher itself.
    while IFS= read -r line; do
      case "$line" in
        *result-compcert*/bin/ccomp*|*"/bin/ccomp"*)
          # Extract first absolute path ending in /ccomp
          target="$(printf '%s\n' "$line" | grep -oE '/[[:alnum:]_./+-]+/ccomp' | head -1 || true)"
          if [[ -n "$target" && -e "$target" && "$target" != "$p" ]]; then
            if [[ -L "$target" ]]; then
              readlink -f "$target" 2>/dev/null || echo "$target"
            else
              echo "$target"
            fi
            return 0
          fi
          ;;
      esac
    done <"$p"
    # Known RESULT pin
    if [[ -x "$RESULT/bin/ccomp" ]]; then
      if [[ -L "$RESULT/bin/ccomp" ]]; then
        readlink -f "$RESULT/bin/ccomp" 2>/dev/null || echo "$RESULT/bin/ccomp"
      else
        echo "$RESULT/bin/ccomp"
      fi
      return 0
    fi
    echo "$p (shell launcher; unresolved target)"
    return 0
  fi

  # Real binary path
  echo "$p"
}

status_report() {
  local resolved=""
  echo "=== CompCert discovery status ==="
  echo "ref/CompCert present: $([[ -d "$CCERT" ]] && echo yes || echo no)"
  if [[ -e "$CCERT/ccomp" ]]; then
    echo "ref/CompCert/ccomp:   yes ($(file -b "$CCERT/ccomp" 2>/dev/null || echo present))"
    echo "  real-binary?:       $(is_real_compcert_binary "$CCERT/ccomp" && echo yes || echo no)"
  else
    echo "ref/CompCert/ccomp:   no"
  fi
  echo "ref/bin/ccomp:        $([[ -e "$BIN_DIR/ccomp" ]] && echo yes || echo no)"
  if [[ -e "$BIN_DIR/ccomp" ]]; then
    resolved="$(resolve_ccomp "$BIN_DIR/ccomp")"
    echo "ref/bin/ccomp resolved: $resolved"
  fi
  echo "RESULT ccomp:         $([[ -x "$RESULT/bin/ccomp" ]] && echo "$RESULT/bin/ccomp" || echo no)"
  if [[ -x "$RESULT/bin/ccomp" ]]; then
    echo "RESULT resolved:      $(resolve_ccomp "$RESULT/bin/ccomp")"
  fi
  if command -v ccomp >/dev/null 2>&1; then
    echo "PATH ccomp:           $(command -v ccomp)"
  else
    echo "PATH ccomp:           no"
  fi
  if command -v coqc >/dev/null 2>&1; then
    echo "coqc:                 $(command -v coqc) ($(coqc --version 2>/dev/null | head -1 || true))"
  else
    echo "coqc:                 no"
  fi
  if command -v nix >/dev/null 2>&1; then
    echo "nix:                  $(command -v nix)"
  else
    echo "nix:                  no"
  fi
  if is_real_compcert_binary "$CCERT/ccomp"; then
    echo "PROVABLY-eligible:    yes (real binary under ref/CompCert/)"
  else
    echo "PROVABLY-eligible:    no (need non-shell binary under ref/CompCert/)"
  fi
  echo "DOGFOOD-eligible:     $([[ -x "$RESULT/bin/ccomp" || -e "$BIN_DIR/ccomp" ]] && echo yes || echo maybe)"
}

if [[ "$mode" == "status" ]]; then
  status_report
  exit 0
fi

mkdir -p "$BIN_DIR"

try_in_tree_build() {
  if [[ ! -d "$CCERT" ]]; then
    echo "NOTE: ref/CompCert missing — init submodule: git submodule update --init --recursive ref/CompCert" >&2
    return 1
  fi
  if is_real_compcert_binary "$CCERT/ccomp"; then
    echo "OK: already have real binary $CCERT/ccomp"
    ln -sfn ../CompCert/ccomp "$BIN_DIR/ccomp"
    return 0
  fi
  if [[ -e "$CCERT/ccomp" ]] && is_shell_script "$CCERT/ccomp"; then
    echo "NOTE: $CCERT/ccomp is a shell launcher (not PROVABLY); will try rebuild or dogfood" >&2
  fi
  if ! command -v coqc >/dev/null 2>&1; then
    echo "NOTE: coqc not on PATH — cannot build CompCert from sources in this environment" >&2
    return 1
  fi
  if ! command -v ocamlopt >/dev/null 2>&1 && ! command -v ocamlc >/dev/null 2>&1; then
    echo "NOTE: OCaml not found — cannot build CompCert" >&2
    return 1
  fi
  echo "=== Building CompCert in-tree (PROVABLY path) ==="
  (
    cd "$CCERT"
    if [[ ! -f Makefile.config ]]; then
      ./configure x86_64-linux
    fi
    make -j"${NIX_BUILD_CORES:-$(nproc 2>/dev/null || echo 4)}"
  )
  if is_real_compcert_binary "$CCERT/ccomp"; then
    ln -sfn ../CompCert/ccomp "$BIN_DIR/ccomp"
    echo "OK: built $CCERT/ccomp and linked ref/bin/ccomp"
    echo "NOTE: systems-compcert-compliant.sh can emit PROVABLY_COMPCERT_COMPLIANT=1 when product gates are green"
    return 0
  fi
  echo "FAIL: in-tree build did not produce a real ccomp binary" >&2
  return 1
}

# Hermetic multi-platform: nix build this flake's packages.compcert (Coq+OCaml in sandbox).
try_flake_compcert() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "NOTE: nix not available — cannot use --flake hermetic CompCert" >&2
    return 1
  fi
  if [[ ! -f "$ROOT/flake.nix" ]]; then
    echo "NOTE: no flake.nix at lean4 root" >&2
    return 1
  fi
  echo "=== Hermetic CompCert via flake packages.compcert (nixpkgs Coq/OCaml) ==="
  # Unfree is enabled inside the flake for CompCert; dirty tree is OK for this package
  # (does not depend on lean sources).
  if ! nix build "$ROOT#compcert" -o "$RESULT"; then
    echo "FAIL: nix build .#compcert failed" >&2
    echo "hint: multi-platform package; ensure your system is in flake outputs" >&2
    echo "hint: CompCert is unfree (INRIA Non-Commercial) — flake sets allowUnfree for this attr" >&2
    return 1
  fi
  if [[ ! -x "$RESULT/bin/ccomp" ]]; then
    echo "FAIL: flake result missing bin/ccomp at $RESULT" >&2
    return 1
  fi
  echo "OK: flake CompCert at $RESULT/bin/ccomp"
  "$RESULT/bin/ccomp" -version 2>&1 | head -n1 || true
  # Pin real ELF under ref/CompCert for PROVABLY path criterion.
  try_pin_real_elf
}

# Locate the real machine-code ccomp ELF behind a RESULT/nix public `bin/ccomp` wrapper.
find_result_ccomp_elf() {
  local wrap launcher
  if [[ -x "$RESULT/bin/.ccomp-wrapped" ]] && is_real_compcert_binary "$RESULT/bin/.ccomp-wrapped"; then
    echo "$RESULT/bin/.ccomp-wrapped"
    return 0
  fi
  launcher="$RESULT/bin/ccomp"
  if [[ -f "$launcher" ]] && is_shell_script "$launcher"; then
    wrap="$(grep -oE '/[[:alnum:]_./+-]+/\.ccomp-wrapped' "$launcher" 2>/dev/null | head -1 || true)"
    if [[ -n "$wrap" && -x "$wrap" ]] && is_real_compcert_binary "$wrap"; then
      echo "$wrap"
      return 0
    fi
    # Follow one symlink hop from RESULT and re-check wrapped name.
    if [[ -L "$launcher" ]]; then
      launcher="$(readlink -f "$launcher" 2>/dev/null || true)"
      if [[ -f "$launcher" ]]; then
        wrap="$(grep -oE '/[[:alnum:]_./+-]+/\.ccomp-wrapped' "$launcher" 2>/dev/null | head -1 || true)"
        if [[ -n "$wrap" && -x "$wrap" ]] && is_real_compcert_binary "$wrap"; then
          echo "$wrap"
          return 0
        fi
      fi
    fi
  fi
  if command -v nix >/dev/null 2>&1; then
    # Last resort: resolve nixpkgs#compcert if RESULT missing (best-effort; may be slow).
    if [[ ! -x "$RESULT/bin/ccomp" ]]; then
      echo "NOTE: RESULT missing; try: nix build nixpkgs#compcert -o result-compcert" >&2
    fi
  fi
  return 1
}

find_result_compcert_ini() {
  if [[ -f "$RESULT/share/compcert.ini" ]]; then
    echo "$RESULT/share/compcert.ini"
    return 0
  fi
  local elf share
  elf="$(find_result_ccomp_elf 2>/dev/null || true)"
  if [[ -n "$elf" ]]; then
    # nix layout: …/bin/.ccomp-wrapped → …/share/compcert.ini
    share="$(cd "$(dirname "$elf")/.." && pwd)/share/compcert.ini"
    if [[ -f "$share" ]]; then
      echo "$share"
      return 0
    fi
  fi
  return 1
}

# Copy real ELF (+ ini) under ref/CompCert so gates can resolve PROVABLY path.
# Honesty: prebuilt pin, not Coq-from-source (see ref/ccomp.PIN.txt outside submodule).
try_pin_real_elf() {
  local elf ini
  if [[ ! -d "$CCERT" ]]; then
    echo "NOTE: ref/CompCert missing — init submodule first" >&2
    return 1
  fi
  if is_real_compcert_binary "$CCERT/ccomp"; then
    echo "OK: already have real binary $CCERT/ccomp"
    ln -sfn ../CompCert/ccomp "$BIN_DIR/ccomp"
    return 0
  fi
  if ! elf="$(find_result_ccomp_elf)"; then
    echo "NOTE: no real ccomp ELF under RESULT=$RESULT (need bin/.ccomp-wrapped or wrapper)" >&2
    return 1
  fi
  if ! is_real_compcert_binary "$elf"; then
    echo "NOTE: candidate is not a real binary: $elf" >&2
    return 1
  fi
  echo "=== Pinning prebuilt ccomp ELF under ref/CompCert (not Coq-from-source) ==="
  echo "NOTE: source ELF: $elf"
  cp -f "$elf" "$CCERT/ccomp"
  chmod +x "$CCERT/ccomp"
  if ini="$(find_result_compcert_ini)"; then
    cp -f "$ini" "$CCERT/compcert.ini"
    echo "NOTE: also pinned $CCERT/compcert.ini from $ini"
  else
    echo "WARN: no compcert.ini found next to RESULT — ccomp may fail without -conf" >&2
  fi
  # Write pin metadata *outside* the CompCert submodule so `git status` stays clean.
  cat >"$ROOT/ref/ccomp.PIN.txt" <<'EOF'
Systems Lean: prebuilt ccomp binary pin (not Coq-from-source rebuild)
--------------------------------------------------------------------
ref/CompCert/ccomp is a real ELF binary so the PROVABLY gate can resolve a
non-shell machine-code path under ref/CompCert/.

Source: hermetic flake packages.compcert (nixpkgs CompCert, typically v3.16,
Coq+OCaml in the Nix sandbox) → result-compcert → …/bin/.ccomp-wrapped.

Honesty:
* Hermetic Nix-built binary pin — not host Arch rocq/ocaml, not necessarily
  a local `make` of the submodule tree.
* Nix *does* use Coq+OCaml inside the sandbox (hermetic build graph).
* Full submodule rebuild: `nix develop .#compcert` then configure+make in
  ref/CompCert.
* Gate criterion for PROVABLY: real ELF under ref/CompCert/ + product green.
* This note lives at ref/ccomp.PIN.txt (parent tree), never inside the submodule.
EOF
  # Remove any legacy pin note inside the submodule (caused "untracked content").
  rm -f "$CCERT/ccomp.PIN.txt"
  if ! is_real_compcert_binary "$CCERT/ccomp"; then
    echo "FAIL: pin did not produce a real binary at $CCERT/ccomp" >&2
    return 1
  fi
  ln -sfn ../CompCert/ccomp "$BIN_DIR/ccomp"
  echo "OK: pinned real ELF $CCERT/ccomp and linked ref/bin/ccomp"
  echo "NOTE: pin metadata → $ROOT/ref/ccomp.PIN.txt (outside submodule)"
  echo "NOTE: prebuilt pin — not Coq-from-source; systems-compcert-compliant.sh may emit the PROVABLY token when product gates are green"
  return 0
}

try_nix_or_result() {
  if [[ -x "$RESULT/bin/ccomp" ]]; then
    echo "OK: using RESULT pin $RESULT/bin/ccomp (DOGFOOD only — shell launcher path)"
  else
    echo "NOTE: no $RESULT/bin/ccomp" >&2
    return 1
  fi

  cat >"$BIN_DIR/ccomp" <<EOF
#!/usr/bin/env bash
# Systems Lean ccomp launcher under ./ref (accomplishment discovery path).
# Order: real CompCert in-tree binary → RESULT pin → fail.
# Shell launcher → never PROVABLY (resolved binary outside ref/CompCert or nix).
set -euo pipefail
HERE="\$(cd "\$(dirname "\$0")" && pwd)"
ROOT="\$(cd "\$HERE/../.." && pwd)"
if [[ -x "\$HERE/../CompCert/ccomp" ]]; then
  # Prefer real binary; if CompCert/ccomp is itself a script, still exec (dogfood).
  exec "\$HERE/../CompCert/ccomp" "\$@"
fi
if [[ -n "\${SYSTEMS_LEAN_COMPCERT_RESULT:-}" && -x "\${SYSTEMS_LEAN_COMPCERT_RESULT}/bin/ccomp" ]]; then
  exec "\${SYSTEMS_LEAN_COMPCERT_RESULT}/bin/ccomp" "\$@"
fi
if [[ -x "\$ROOT/result-compcert/bin/ccomp" ]]; then
  exec "\$ROOT/result-compcert/bin/ccomp" "\$@"
fi
if [[ -x "$RESULT/bin/ccomp" ]]; then
  exec "$RESULT/bin/ccomp" "\$@"
fi
echo "ccomp: no in-tree CompCert build and no RESULT pin" >&2
exit 127
EOF
  chmod +x "$BIN_DIR/ccomp"
  echo "OK: wrote $BIN_DIR/ccomp launcher → DOGFOOD path"
  echo "NOTE: for PROVABLY, re-run without --nix (auto pin-elf or Coq rebuild)"
  echo "NOTE: resolved target: $(resolve_ccomp "$BIN_DIR/ccomp")"
  return 0
}

case "$mode" in
  nix)
    try_nix_or_result || {
      status_report
      exit 1
    }
    ;;
  pin-elf)
    try_pin_real_elf || {
      status_report
      exit 1
    }
    ;;
  flake)
    try_flake_compcert || {
      status_report
      exit 1
    }
    ;;
  auto)
    if try_in_tree_build; then
      :
    elif try_flake_compcert; then
      :
    elif try_pin_real_elf; then
      :
    elif try_nix_or_result; then
      :
    else
      echo "FAIL: could not build or pin ccomp" >&2
      status_report
      echo ""
      echo "Manual PROVABLY paths (hermetic multi-platform preferred):"
      echo "  # A) flake hermetic CompCert (Coq+OCaml in Nix sandbox — no host Rocq/OCaml):"
      echo "  nix build .#compcert -o result-compcert"
      echo "  ./ref/build-ccomp.sh --flake    # or --pin-elf after nix build"
      echo "  # B) prebuilt RESULT pin:"
      echo "  export SYSTEMS_LEAN_COMPCERT_RESULT=\$PWD/result-compcert"
      echo "  ./ref/build-ccomp.sh --pin-elf"
      echo "  # C) Coq-from-source rebuild (host or nix develop .#compcert):"
      echo "  nix develop .#compcert"
      echo "  git submodule update --init --recursive ref/CompCert"
      echo "  cd ref/CompCert && ./configure x86_64-linux && make -j\$(nproc)"
      echo "  # result must be a real ELF/Mach-O binary at ref/CompCert/ccomp (not a shell script)"
      exit 1
    fi
    ;;
esac

status_report
exit 0
