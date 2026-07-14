# Hermetic CompCert (`ccomp`) for Systems Lean — multi-platform.
#
# This is **not** a hand-rolled Coq derivation: it re-exports nixpkgs'
# `compcert`, which is built in the Nix sandbox from CompCert sources using a
# pinned Coq (Rocq-family) + OCaml toolchain. Host packages (Arch `rocq`,
# `ocaml`, …) are **not** required when using this flake output.
#
# License: INRIA Non-Commercial (unfree). Callers must use a nixpkgs instance
# with `config.allowUnfree = true` (the root flake does this for CompCert only).
#
# Platforms: follow `pkgs.compcert.meta.platforms` (typically x86_64/aarch64
# linux+darwin and some riscv — see `nix eval .#compcert.meta.platforms`).
#
# Systems Lean usage:
#   nix build .#compcert -o result-compcert
#   ./ref/build-ccomp.sh --flake    # pin real ELF under ref/CompCert/ for PROVABLY
#
# Honesty:
#   * Hermetic = Nix-evaluated build graph (Coq/OCaml/CompCert) from nixpkgs.
#   * PROVABLY token still requires a real non-shell binary under ref/CompCert/
#     (see ref/README.md); this package supplies that binary hermetically.
#   * CompCert owns C→asm theorems; Lean elaborator is not CompCert-verified.
{
  lib,
  compcert,
}:

compcert.overrideAttrs (old: {
  meta = (old.meta or { }) // {
    description = "Hermetic CompCert ccomp for Systems Lean (nixpkgs Coq/OCaml build)";
    longDescription = ''
      Formally verified C compiler (`ccomp`) packaged for Systems Lean freestanding
      dogfood and PROVABLY compliance pins.

      Built hermetically by nixpkgs: CompCert sources + Coq + OCaml in the Nix
      sandbox. No host Rocq/OCaml install is required for `nix build .#compcert`.

      Install layout matches SYSTEMS_LEAN_COMPCERT_RESULT expectations:
        result/bin/ccomp
        result/bin/.ccomp-wrapped   (typical unwrapped ELF on Linux)

      Pin for Systems Lean PROVABLY path criterion:
        ./ref/build-ccomp.sh --flake

      Unfree (INRIA Non-Commercial). Do not redistribute binaries in ways that
      violate CompCert's license.
    '';
    # Preserve homepage/license/platforms from nixpkgs; clarify flake role.
    homepage = old.meta.homepage or "https://compcert.org";
  };
})
