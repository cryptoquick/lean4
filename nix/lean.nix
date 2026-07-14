# Classic Lean 4 package: stage1 toolchain with RC runtime defaults.
# Built hermetically for flake consumers (no elan). Does not require ./ref CompCert
# or freestanding-only inputs. Systems Lean features in-tree remain opt-in.
{ callPackage, src, version ? "4.33.0", ... }@args:
callPackage ./lean-toolchain.nix (
  (builtins.removeAttrs args [ "callPackage" ])
  // {
    inherit src version;
    systemsLean = false;
  }
)
