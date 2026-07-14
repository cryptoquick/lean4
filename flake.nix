{
  description = "Lean 4 development flake: packages.lean, packages.systems-lean, hermetic packages.compcert, Systems tooling via systems.nix.";

  # We use channels so we're not affected by GitHub's rate limits
  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
  # old nixpkgs used for portable release with older glibc (2.27)
  inputs.nixpkgs-old.url = "https://channels.nixos.org/nixos-19.03/nixexprs.tar.xz";
  inputs.nixpkgs-old.flake = false;
  # old nixpkgs used for portable release with older glibc (2.26)
  inputs.nixpkgs-older.url = "https://channels.nixos.org/nixos-18.03/nixexprs.tar.xz";
  inputs.nixpkgs-older.flake = false;

  outputs = inputs: builtins.foldl' inputs.nixpkgs.lib.attrsets.recursiveUpdate {} (builtins.map (system:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
      # CompCert is unfree (INRIA Non-Commercial). Isolated pkgs so classic Lean
      # packages never require allowUnfree.
      # Isolated unfree pkgs for CompCert only (INRIA Non-Commercial). Classic
      # `pkgs` stays free so lean/systems-lean never pull unfree by default.
      pkgsUnfree = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      # An old nixpkgs for creating releases with an old glibc
      pkgsDist-old = import inputs.nixpkgs-older { inherit system; };
      # An old nixpkgs for creating releases with an old glibc
      pkgsDist-old-aarch = import inputs.nixpkgs-old { localSystem.config = "aarch64-unknown-linux-gnu"; };

      llvmPackages = pkgs.llvmPackages_19;

      # Stage1 toolchains for other flakes (no elan). First build is a full bootstrap.
      # Classic lean and systems-lean share nix/lean-toolchain.nix; neither requires ./ref CompCert.
      lean = pkgs.callPackage ./nix/lean.nix {
        src = inputs.self;
        version = "4.33.0";
      };
      systems-lean = pkgs.callPackage ./nix/systems-lean.nix {
        src = inputs.self;
        version = "4.33.0-systems";
      };

      # Hermetic CompCert (ccomp): nixpkgs builds CompCert from sources with Coq + OCaml
      # in the sandbox. Multi-platform (see pkgs.compcert.meta.platforms). Unfree.
      # Does not depend on lean sources or host Arch rocq/ocaml packages.
      compcert = pkgsUnfree.callPackage ./nix/compcert.nix {
        compcert = pkgsUnfree.compcert;
      };

      # Systems Lean front door (shells, light checks, apps). Prefer systems.nix over
      # adding new script/systems-*.sh gates. See systems.nix header.
      systems = import ./systems.nix {
        inherit pkgs pkgsUnfree system;
        self = inputs.self;
      };

      devShellWithDist = pkgsDist: pkgs.mkShell.override {
          stdenv = pkgs.overrideCC pkgs.stdenv llvmPackages.clang;
        } ({
          buildInputs = with pkgs; [
            cmake gmp libuv ccache pkg-config openssl openssl.dev
            llvmPackages.bintools  # wrapped lld
            llvmPackages.llvm  # llvm-symbolizer for asan/lsan
            gdb
            tree  # for CI
          ];
          # https://github.com/NixOS/nixpkgs/issues/60919
          hardeningDisable = [ "all" ];
          # more convenient `ctest` output
          CTEST_OUTPUT_ON_FAILURE = 1;
        } // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux (let
          # Build OpenSSL 3 statically using pkgsDist's old-glibc stdenv,
          # so the resulting static libs don't require newer glibc symbols.
          opensslForDist = pkgsDist.stdenv.mkDerivation {
            name = "openssl-static-3.6.0";
            src = pkgs.fetchFromGitHub {
              owner = "openssl";
              repo = "openssl";
              rev = "openssl-3.6.0";
              hash = "sha256-EJnbK9ZMdN2ztTTQtb7VsEQvvbMYnY5HJ2LMJlw5FRg=";
            };
            nativeBuildInputs = [ pkgsDist.perl ];
            configurePhase = ''
              patchShebangs .
              ./config --prefix=$out no-shared no-tests
            '';
            buildPhase = "make -j$NIX_BUILD_CORES";
            installPhase = "make install_sw";
          };
        in {
          GMP = (pkgsDist.gmp.override { withStatic = true; }).overrideAttrs (attrs:
            pkgs.lib.optionalAttrs (pkgs.stdenv.system == "aarch64-linux") {
              # would need additional linking setup on Linux aarch64, we don't use it anywhere else either
              hardeningDisable = [ "stackprotector" ];
            });
          LIBUV = pkgsDist.libuv.overrideAttrs (attrs: {
            configureFlags = ["--enable-static"];
            hardeningDisable = [ "stackprotector" ];
            # Sync version with CMakeLists.txt
            version = "1.48.0";
            src = pkgs.fetchFromGitHub {
              owner = "libuv";
              repo = "libuv";
              rev = "v1.48.0";
              sha256 = "100nj16fg8922qg4m2hdjh62zv4p32wyrllsvqr659hdhjc03bsk";
            };
            doCheck = false;
          });
          OPENSSL = opensslForDist;
          OPENSSL_DEV = opensslForDist;
          GLIBC = pkgsDist.glibc;
          GLIBC_DEV = pkgsDist.glibc.dev;
          GCC_LIB = pkgsDist.gcc.cc.lib;
          ZLIB = pkgsDist.zlib;
          # for CI coredumps
          GDB = pkgsDist.gdb;
        }));
    in {
      packages.${system} = {
        # Classic Lean 4 identity (default). Systems Lean is opt-in: .#systems-lean
        lean = lean;
        systems-lean = systems-lean;
        # Hermetic CompCert (unfree). Alias systems-compcert for Systems Lean docs.
        compcert = compcert;
        systems-compcert = compcert;
        default = lean;
      } // systems.packages;

      # `nix run . -- --version` → classic lean; `nix run .#systems-lean -- --version`
      # `nix run .#ccomp -- -version` → hermetic CompCert
      # Systems apps: `nix run .#systems-status` / `systems-check` / `systems-validate` (systems.nix)
      apps.${system} = {
        lean = {
          type = "app";
          program = "${lean}/bin/lean";
        };
        systems-lean = {
          type = "app";
          program = "${systems-lean}/bin/lean";
        };
        ccomp = {
          type = "app";
          program = "${compcert}/bin/ccomp";
        };
        compcert = {
          type = "app";
          program = "${compcert}/bin/ccomp";
        };
        default = {
          type = "app";
          program = "${lean}/bin/lean";
        };
      } // systems.apps;

      # Systems: light = pure sandbox (checks.systems-light / packages.systems-check-light)
      # or host `nix run .#systems-check`. Full SCORE primary: systems-validate (host stage1;
      # docs alias packages/apps.systems-score ≡ systems-validate; T4 pure-Nix SCORE still open —
      # needs in-store stage1+bundle; product example tests/lake/examples/systems).
      checks.${system} = systems.checks;

      devShells.${system} = {
        # The default development shell for working on lean itself
        default = devShellWithDist pkgs;
        oldGlibc = devShellWithDist pkgsDist-old;
        oldGlibcAArch = devShellWithDist pkgsDist-old-aarch;
        # Prebuilt toolchains on PATH (builds the package first).
        lean = pkgs.mkShell {
          packages = [ lean ];
          hardeningDisable = [ "all" ];
        };
        systems-lean = pkgs.mkShell {
          packages = [ systems-lean ];
          hardeningDisable = [ "all" ];
        };
        # Hermetic CompCert + Coq/OCaml so you can rebuild submodule sources if desired.
        # Host Arch `rocq`/`ocaml` packages are unnecessary inside this shell.
        compcert = pkgsUnfree.mkShell {
          packages = with pkgsUnfree; [
            compcert
            coq
            ocaml
            ocamlPackages.findlib
            gnumake
            gcc
            file
          ];
          shellHook = ''
            echo "Systems Lean hermetic CompCert shell"
            echo "  ccomp: $(command -v ccomp || true)"
            ccomp -version 2>/dev/null | head -n1 || true
            echo "  coqc:  $(command -v coqc || true)"
            echo "Pin for PROVABLY (from lean4 root): ./ref/build-ccomp.sh --flake"
          '';
        };
      } // systems.devShells;
    # Platforms aligned with lean4 dogfood + CompCert availability on nixpkgs.
    # (pkgs.compcert also supports x86_64-darwin / some riscv; extend here as needed.)
    }) ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"]);
}
