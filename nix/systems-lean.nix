# Systems Lean package: stage1 Lean toolchain with freestanding / Systems Lean support.
# Built hermetically for flake consumers (no elan). Does not require ./ref CompCert.
{ callPackage, src, version ? "4.33.0-systems", ... }@args:
callPackage ./lean-toolchain.nix (
  (builtins.removeAttrs args [ "callPackage" ])
  // {
    inherit src version;
    systemsLean = true;
  }
)
