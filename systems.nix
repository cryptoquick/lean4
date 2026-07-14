# Systems Lean — single Nix entry for tooling, checks, and dogfood shells.
#
# Prefer this file over adding new script/systems-*.sh gates.
#
# Product example path (canonical; do not reintroduce old freestanding example dirs):
#   tests/lake/examples/systems/
#   Lake package under tests/lake/examples/systems/lib (freestanding := true).
#
# Dogfood lanes (do not confuse):
#   Light (no stage1 lean required; pure sandbox for Nix check):
#     nix build .#checks.x86_64-linux.systems-light
#     # aliases: checks.systems, packages.systems-check-light
#     nix run .#systems-check              # host-tree light wrapper (same gates)
#     # SKIP when no freestanding .lake bundle in source (honest; never forge dual-path OK).
#     # No stage1: light gates still run; full SCORE is not claimed here.
#     # systems-light covers inventory / product-stdlib / axiom / QTT-depth-style gates
#     # that are source-grep or tool-only — no host stage1 required.
#     # HONESTY: light is **pure sandbox** only (patchShebangs; no stage1 lean binary).
#     #   It is a **subset** of product hygiene — not the 15-gate full SCORE aggregator.
#   Full SCORE (primary product dogfood — needs host stage1 lean + product bundle):
#     nix develop .#systems --command systems-validate   # preferred
#     nix run .#systems-validate                         # same app
#     # packages.systems-score / apps.systems-score — docs-facing aliases (= systems-validate;
#     #   same writeShellApplication; not a second implementation; not pure-sandbox SCORE).
#     # HONESTY: `nix run .#systems-score` is still **host** dogfood — it needs host stage1 lean
#     #   (build/release/stage1/bin on PATH, or whatever lean SCORE finds) **and** the freestanding
#     #   product bundle. It is **not** pure Nix SCORE.
#     #   `checks.<sys>.systems-score-pure` remains **NOT YET** (do not invent it).
#     # systems-validate prefers build/release/stage1/bin/lean on PATH when present;
#     # never forge GC_FREE_ELABORATOR=1 — product residual (PRODUCT_GC_FREE) is independent.
#     #
#     # T4 pure-Nix SCORE (OPEN — do not claim checks.systems == full SCORE yet):
#     #   Blockers for packaging systems-validate as a pure flake check:
#     #     (1) stage1 lean binary must be an in-store input (bootstrap cost / hermetic PATH)
#     #     (2) freestanding product bundle (.lake/build libfs_extract_bundle.a) must be
#     #         built or fixed-output in-store — pure flake `self` has no .lake tree
#     #     (3) lean-backed gates (freestanding_check, residual_nm/ir, product_gc_free,
#     #         host_elaborator, …) need that lean + built product, not just bash tools
#     #   Shipped toward T4: light pure check (systems-light), host systems-check ≡ light,
#     #   thin systems-validate/systems-score apps, honest SKIP dual-path without bundle.
#     #   Until (1)+(2) land, full SCORE stays host dogfood via systems-validate.
#     #
#     #   Future pure flake check name (NOT YET — do not invent this derivation):
#     #     checks.<sys>.systems-score-pure
#     #   Stage1 lean suppliers for that pure check (existing flake packages only):
#     #     packages.<sys>.systems-lean  → store path …/bin/lean (Systems stage1; preferred
#     #                                   for product dogfood identity when pure SCORE ships)
#     #     packages.<sys>.lean          → store path …/bin/lean (classic stage1; flake default)
#     #   Prerequisites before that name may ship (docs only; no pure SCORE derivation yet):
#     #     • wire one of the above packages as an in-store stage1 lean/lake buildInput
#     #       (blocker 1 / T4.1 — hermetic PATH from that package's /bin)
#     #     • dependent in-store Lake freestanding build of
#     #       `tests/lake/examples/systems` producing `libfs_extract_bundle.a`
#     #       (blocker 2 / **T4.2 hard blocker after package lean is available**)
#     #     • lean-backed SCORE gates consuming those two store paths (blocker 3)
#     #   After package lean lands, T4.2 (in-store freestanding Lake of the systems example)
#     #   remains the hard packaging residual. Until all three exist and gates consume them,
#     #   keep SCORE on host `systems-validate` / docs alias `systems-score` — never invent a
#     #   pure check that pretends lean/bundle are present. `checks.<sys>.systems-score-pure`
#     #   is NOT YET. No new bash gates — extend systems.nix packaging only.
#     #
#     #   T4.2 concrete sub-step (docs only — systems-score-pure still NOT YET):
#     #     When packaging pure SCORE, the derivation must invoke Lake freestanding of
#     #     `tests/lake/examples/systems` **inside the sandbox** (build
#     #     `libfs_extract_bundle.a` from package sources + in-store lake/lean as
#     #     buildInputs). Never read a host checkout `.lake/` tree — pure flake `self`
#     #     has no `.lake`, and host `.lake` is impure. Do not invent pure SCORE until
#     #     that in-derivation Lake step lands; no new bash gates.
#     #
#     #   T4.2 acceptance criterion (docs only — systems-score-pure still NOT YET):
#     #     Pure SCORE derivation may **not** import host PATH lean or host checkout `.lake/`.
#     #     Only Nix **store paths** are allowed for stage1 lean/lake and the freestanding
#     #     product bundle (e.g. `${packages.systems-lean}/bin/lean` + in-derivation
#     #     `libfs_extract_bundle.a`). Host PATH lean and host `.lake` fail acceptance.
#     #     No invented pure SCORE; no new bash gates — systems.nix packaging only.
#     #
#     #   T4.3 precondition (docs only — systems-score-pure still NOT YET):
#     #     After in-store lean + freestanding bundle exist, pure SCORE must still re-run
#     #     residual_nm / residual_ir **style** product residual gates on that **store**
#     #     bundle (invoke the same residual scripts / link-check with store paths, or
#     #     equivalent in-derivation wiring of those gates). A pure check that packages
#     #     inventory/axiom/QTT-only light gates while **skipping** product residual is
#     #     not full SCORE and must not claim SCORE pass. Light (`systems-light`) remains
#     #     a different, smaller pure-sandbox subset. No invented pure SCORE derivation;
#     #     no new bash gates — systems.nix packaging of existing residual gates only.
#     #
#     #   T4.4 packaging fail-closed (docs only — systems-score-pure still NOT YET):
#     #     The pure SCORE flake check name is **system-qualified**:
#     #       checks.<sys>.systems-score-pure
#     #     (never an unqualified `checks.systems-score-pure` / invented alias).
#     #     When stage1 lean or freestanding product bundle inputs are **missing**, that
#     #     pure check must be **fail-closed** — exit non-zero / do not ship a green
#     #     SCORE. Never soft-skip residual_nm / residual_ir / product_gc_free (or other
#     #     lean-backed residual gates) to pretend full SCORE pass without those inputs.
#     #     Light (`systems-light`) may honest-SKIP dual-path without bundle; pure SCORE
#     #     may not borrow that SKIP as residual green. `checks.<sys>.systems-score-pure`
#     #     remains **NOT YET**. No invented pure SCORE; no new bash gates.
#
# Full SCORE (script/systems-validate.sh aggregator) is the primary product scoreboard.
# Exit 0 only when core integrity holds (see systems-validate.sh header). Machine-readable:
#   GATE residual_nm / residual_ir / product_gc_free / product_stdlib / sorry_free /
#        axiom_auto / tcb_honesty / host_elaborator / linear_metrics / qtt_depth /
#        qtt_elab / freestanding_check / compcert_dogfood|provably / negatives
#   SCORE pass=A fail=B skip=C
# SCORE gate count: **15** set_gate names above (residual_nm … negatives; dogfood + provably
#   are two gates). Light (`systems-light` / `systems-check`) is a **different**, smaller
#   pure-sandbox subset (inventory/status/product-stdlib/axiom/qtt-depth/linear/tcb + optional
#   dual-path SKIP) — **not** those 15. Full SCORE needs **host stage1 lean + freestanding
#   product bundle**; light does not. `checks.<sys>.systems-score-pure` remains **NOT YET**.
# Greppable product wire: PRODUCT_GC_FREE=1 PRODUCT_NO_LEANSHARED=1 (on product_gc_free PASS).
# Host elaborator residual is independent: GC_FREE_ELABORATOR=0|1 (measured; never forge =1).
# freestanding_check uses the product example at tests/lake/examples/systems (nm + dual-path).
#
# Other entry points:
#   nix develop .#systems   # apps: systems-status / systems-check / systems-validate / inventory
#   nix develop .#systems --command systems-status
#   nix run .#systems-status
# Optional CompCert (unfree): nix develop .#systems-full
#
# Function args (from flake.nix):
#   pkgs       — free nixpkgs for this system
#   pkgsUnfree — nixpkgs with allowUnfree (CompCert only)
#   self       — flake self (source tree)
#   system     — e.g. x86_64-linux
#
# Returns: { packages, apps, devShells, checks }

{ pkgs, pkgsUnfree ? pkgs, self, system }:

let
  inherit (pkgs) lib;

  # Portable gate tools (no Lean bootstrap). stage1 lean stays host-provided.
  systemsTools = with pkgs; [
    ripgrep
    bashInteractive
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    gnumake
    gcc
    binutils # nm, ar, objdump for residual / link gates
    file
    git
    which
    python3 # inventory --require / systems-status doc parse
  ];

  systemsToolsFull = systemsTools ++ [ pkgsUnfree.compcert ];

  # Shared light gate body (sandbox check + host `systems-check` app).
  # No stage1 lean. Dual-path is honest SKIP when product bundle is absent.
  lightGateScript = ''
    echo "=== systems.nix light checks ==="
    command -v rg && command -v nm && command -v python3
    bash ./script/systems-stdlib-inventory.sh --require
    bash ./script/systems-status.sh | tee status.out
    rg -q "SYSTEMS_STATUS_OK=1" status.out
    bash ./script/systems-product-stdlib-check.sh | tee product_stdlib.out
    rg -qx "PRODUCT_STDLIB_MODULES_OK=1" product_stdlib.out
    bash ./script/systems-axiom-check.sh | tee axiom.out
    rg -q "AXIOM_AUTO_GATE_OK=1" axiom.out
    bash ./script/systems-qtt-depth-check.sh | tee qtt_depth.out
    rg -q "QTT_DEPTH_OK=1" qtt_depth.out
    bash ./script/systems-linear-residual-metrics.sh | tee linear.out
    rg -q "LINEAR_RESIDUAL_METRICS_OK=1" linear.out
    # Parallelism dual-path needs freestanding product bundle (Lake build output).
    # Under pure flake `self` the `.lake/` tree is not in the flake source, so this
    # arm is an honest SKIP in the sandbox — never forge PARALLELISM_DUAL_PATH_OK here.
    # Full SCORE (host stage1 + built bundle via systems-validate) enforces it.
    # No stage1 lean: also SKIP dual-path here; do not claim full SCORE without stage1.
    BUNDLE="tests/lake/examples/systems/lib/.lake/build/lib/libfs_extract_bundle.a"
    if [[ -f "$BUNDLE" && -s "$BUNDLE" ]]; then
      bash ./script/systems-par-dual-path-check.sh | tee par.out
      rg -q "PARALLELISM_DUAL_PATH_OK=1" par.out
    else
      echo "SKIP: parallelism dual-path (missing product bundle at $BUNDLE; expected under pure flake self / no stage1 dogfood yet)"
    fi
    # Fail-closed: non-zero exit fails the check; require honesty token on success.
    bash ./script/systems-tcb-inventory.sh | tee tcb.out
    rg -q "TCB_HONESTY_OK=1" tcb.out
    echo "OK: systems.nix light checks"
    echo "SYSTEMS_CHECK_LIGHT_OK=1"
  '';

  # Run a short gate command against the flake source tree (sandbox-friendly).
  # Full SCORE (systems-validate) needs stage1 lean + freestanding bundle — use
  # the systems dev shell locally, not a pure derivation, until those are packaged.
  mkLightCheck =
    name: script:
    pkgs.runCommand "systems-check-${name}"
      {
        nativeBuildInputs = systemsTools;
        src = self;
      }
      ''
        set -euo pipefail
        # Writable copy: inventory/status may chmod +x helpers.
        cp -a "$src" ./src
        chmod -R u+w ./src
        cd ./src
        export PATH="${lib.makeBinPath systemsTools}:$PATH"
        # Pure sandbox has no /usr/bin/env — rewrite script shebangs to store bash/python.
        patchShebangs ./script
        ${script}
        mkdir -p "$out"
        echo "OK: systems-check-${name}" > "$out/result"
      '';

  # Scripts use #!/usr/bin/env bash — invoke via bash so pure Nix sandbox works.
  statusApp = pkgs.writeShellApplication {
    name = "systems-status";
    runtimeInputs = systemsTools;
    text = ''
      set -euo pipefail
      root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
      cd "$root"
      exec bash ./script/systems-status.sh "$@"
    '';
  };

  # Primary full-SCORE dogfood entry (Track T). Host stage1 + freestanding bundle.
  validateApp = pkgs.writeShellApplication {
    name = "systems-validate";
    runtimeInputs = systemsTools;
    text = ''
      set -euo pipefail
      root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
      cd "$root"
      # Prefer in-tree stage1 when present (not forged GC_FREE_ELABORATOR).
      if [[ -x "$root/build/release/stage1/bin/lean" ]]; then
        export PATH="$root/build/release/stage1/bin:''${PATH:-}"
      else
        echo "note: no stage1 lean at build/release/stage1/bin/lean — full SCORE may skip/fail lean-backed gates; use systems-check for light-only" >&2
      fi
      export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:-/usr/lib:/lib:/usr/lib/x86_64-linux-gnu}"
      exec bash ./script/systems-validate.sh "$@"
    '';
  };

  inventoryRequireApp = pkgs.writeShellApplication {
    name = "systems-inventory-require";
    runtimeInputs = systemsTools;
    text = ''
      set -euo pipefail
      root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
      cd "$root"
      exec bash ./script/systems-stdlib-inventory.sh --require "$@"
    '';
  };

  # Host-tree light gate wrapper (same body as checks.systems-light; not a new .sh gate).
  # Prefer systems-validate for full SCORE; this is the no-stage1 dogfood path.
  checkApp = pkgs.writeShellApplication {
    name = "systems-check";
    runtimeInputs = systemsTools;
    text = ''
      set -euo pipefail
      root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
      cd "$root"
      ${lightGateScript}
    '';
  };

  shellHookCommon = ''
    echo "Systems Lean shell (systems.nix front door)"
    echo "  rg:      $(command -v rg || true)"
    echo "  nm:      $(command -v nm || true)"
    echo "  make:    $(command -v make || true)"
    echo "  python3: $(command -v python3 || true)"
    echo "Lanes:"
    echo "  systems-status                 # fast status (no full SCORE)"
    echo "  systems-check                  # light gates on host tree (no stage1 required)"
    echo "  systems-inventory-require      # inventory SSoT drift"
    echo "  systems-validate               # PRIMARY full SCORE fail=0 (stage1 lean + freestanding bundle)"
    echo "  # docs alias: nix run .#systems-score ≡ systems-validate (HOST stage1 required; not pure)"
    echo "  # systems-score-pure (checks.<sys>) remains NOT YET — do not invent pure SCORE"
    echo "  nix build .#checks.x86_64-linux.systems-light   # pure-sandbox light (no stage1; inventory/product/axiom/QTT)"
    echo "  product example: tests/lake/examples/systems"
    echo "Validate gates (SCORE; 15 gates; host stage1+bundle — not pure Nix yet / T4 open):"
    echo "  residual_nm residual_ir product_gc_free product_stdlib sorry_free axiom_auto"
    echo "  tcb_honesty host_elaborator linear_metrics qtt_depth qtt_elab freestanding_check"
    echo "  compcert_dogfood|provably + negatives  (SCORE pass=A fail=B skip=C; 15 set_gate)"
    echo "  Light = pure sandbox subset (no stage1); full SCORE needs host stage1+bundle."
    echo "  systems-score-pure (checks) remains NOT YET — stage1 would come from"
    echo "    packages.systems-lean or packages.lean (existing flake pkgs); no pure SCORE drv yet."
    echo "Honesty: PRODUCT residual (PRODUCT_GC_FREE / embed wire) is independent of host"
    echo "  elaborator residual (GC_FREE_ELABORATOR measured on stage1; today still 0)."
    echo "  Never forge GC_FREE_ELABORATOR=1; earn it only when NEEDED proves residual_free."
    echo "  Light dual-path: honest SKIP without .lake bundle (never forge PARALLELISM_DUAL_PATH_OK)."
  '';

  systemsShell = pkgs.mkShell {
    name = "systems";
    packages = systemsTools ++ [
      statusApp
      checkApp
      validateApp
      inventoryRequireApp
    ];
    hardeningDisable = [ "all" ];
    shellHook = shellHookCommon + ''
      echo "CompCert: nix develop .#systems-full  (unfree ccomp)"
    '';
  };

  systemsFullShell = pkgsUnfree.mkShell {
    name = "systems-full";
    packages = systemsToolsFull ++ [
      statusApp
      checkApp
      validateApp
      inventoryRequireApp
    ];
    hardeningDisable = [ "all" ];
    shellHook = shellHookCommon + ''
      echo "  ccomp: $(command -v ccomp || true)"
      ccomp -version 2>/dev/null | head -n1 || true
      echo "Pin real ELF for PROVABLY: ./ref/build-ccomp.sh --flake"
    '';
  };

  # Light suite: no stage1 lean required. Mirrors opt-in CI non-lean-heavy gates.
  # Always `bash script` (no /usr/bin/env in pure sandbox). Fail-closed on gate
  # tokens (including TCB_HONESTY_OK); advisory tcb-inventory still exits 0 with
  # that token when lean/bundle are absent.
  systemsLightCheck = mkLightCheck "light" lightGateScript;

in
{
  packages = {
    systems-status = statusApp;
    systems-check = checkApp;
    systems-validate = validateApp;
    systems-inventory-require = inventoryRequireApp;
    # Same derivation as checks.systems-light (sandbox light suite); convenient
    # `nix build .#systems-check-light` alias — not a second gate implementation.
    systems-check-light = systemsLightCheck;
    # Docs-facing full-SCORE name (= systems-validate / script/systems-validate.sh).
    # Host stage1 still required at run time (`nix run .#systems-score` is not pure).
    # systems-score-pure remains NOT YET — do not invent a pure SCORE check here.
    # Not a pure-sandbox SCORE derivation (T4+); no second bash gate.
    systems-score = validateApp;
  };

  apps = {
    systems-status = {
      type = "app";
      program = "${statusApp}/bin/systems-status";
    };
    # Host light dogfood (no stage1). Full SCORE remains systems-validate (primary).
    systems-check = {
      type = "app";
      program = "${checkApp}/bin/systems-check";
    };
    systems-validate = {
      type = "app";
      program = "${validateApp}/bin/systems-validate";
    };
    # Alias for discoverability: full SCORE entry is systems-validate (same program).
    # Host stage1 still required — not pure; systems-score-pure is NOT YET.
    systems-score = {
      type = "app";
      program = "${validateApp}/bin/systems-validate";
    };
    systems-inventory-require = {
      type = "app";
      program = "${inventoryRequireApp}/bin/systems-inventory-require";
    };
  };

  devShells = {
    # Preferred names (plan Track T / N branding)
    systems = systemsShell;
    systems-full = systemsFullShell;
    # Compatibility aliases (older docs / Track F)
    systems-dev = systemsShell;
    systems-dev-full = systemsFullShell;
  };

  checks = {
    # Pure-sandbox light suite (no stage1 lean). Default for `nix flake check` / CI.
    # Full SCORE remains: nix develop .#systems --command systems-validate (primary dogfood).
    systems-light = systemsLightCheck;
    # Alias: "systems" check = light until full SCORE is packaged with lean (T4+).
    systems = systemsLightCheck;
    # checks.<sys>.systems-score-pure — NOT YET (T4 pure SCORE). Do not invent it.
    # Stage1 lean suppliers (already-shipped flake packages; wire as buildInputs later):
    #   packages.<sys>.systems-lean  → ${systems-lean}/bin/lean  (Systems-branded stage1)
    #   packages.<sys>.lean          → ${lean}/bin/lean          (classic stage1; flake default)
    # Either supplies hermetic PATH lean/lake for pure SCORE; prefer systems-lean for product
    # dogfood identity.
    # T4.2 hard blocker (after package lean is available): in-store freestanding Lake of
    #   tests/lake/examples/systems → libfs_extract_bundle.a. Without that store path, pure
    #   SCORE cannot consume product residual/nm/ir gates hermetically. NOT YET — no pure
    #   SCORE drv; no new bash gates.
    # T4.2 sub-step (docs only): future systems-score-pure must run Lake freestanding of
    #   tests/lake/examples/systems **inside the derivation** (sandbox + in-store lake/lean),
    #   not against a host `.lake` tree. systems-score-pure remains NOT YET — no invented
    #   pure SCORE, no new bash gates.
    # T4.2 acceptance criterion (docs only — systems-score-pure still NOT YET):
    #   A pure SCORE derivation may not import host PATH lean or host checkout `.lake/`.
    #   Only Nix store paths are allowed: in-store stage1 lean/lake (e.g. packages.systems-lean
    #   or packages.lean `/bin`) + in-store freestanding bundle from the in-derivation Lake
    #   build of tests/lake/examples/systems. Host PATH lean and host `.lake` are impure and
    #   fail acceptance. Do not invent pure SCORE until both store inputs exist; no new bash
    #   gates — extend systems.nix packaging only.
    # T4.3: pure SCORE must re-run residual_nm/ir style product residual on the store bundle
    #   (cannot skip product residual). systems-score-pure remains NOT YET.
    # T4.4 packaging fail-closed (docs only — systems-score-pure still NOT YET):
    #   Pure SCORE flake check must be **system-qualified**: checks.<sys>.systems-score-pure.
    #   If stage1 lean or freestanding product bundle is missing, that pure check must
    #   **fail-closed** (non-zero) — never soft-skip residual gates to green without those
    #   inputs. Light may honest-SKIP dual-path; pure SCORE may not. No invented pure SCORE;
    #   no new bash gates — systems.nix packaging only.
  };
}
