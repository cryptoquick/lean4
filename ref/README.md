# Optional CompCert reference (`./ref`)

This directory is the **optional CompCert pin** for Systems Lean compliance dogfood.

Classic Lean 4 and day-to-day Systems Lean smoke do **not** need it.

## Layout

| Path | Role |
|------|------|
| `ref/CompCert/` | **Git submodule** → [AbsInt/CompCert](https://github.com/AbsInt/CompCert) (**pinned `v3.16`**) |
| `ref/CompCert/ccomp` | **Real ELF** under the submodule tree (required for **PROVABLY** path criterion) |
| `ref/ccomp.PIN.txt` | Pin honesty note when using prebuilt ELF (**outside** submodule — keeps git clean) |
| `ref/CompCert/compcert.ini` | Config beside the pinned/binary `ccomp` (from same pin or local build) |
| `ref/bin/ccomp` | Discovery path for gates (launcher or symlink) |
| this README | Systems Lean discovery notes |

## Claim ladder (simple rule)

| Token | When |
|-------|------|
| `PROVABLY_COMPCERT_COMPLIANT=1` | Full product gate green **and** resolved `ccomp` is a **non-shell** machine-code binary under **`ref/CompCert/`**. |
| `COMPCERT_DOGFOOD=1` | Same product conjuncts with RESULT/nix/PATH, **or** discovery under `./ref` whose **resolved** binary is **outside** `ref/CompCert/` (e.g. launcher → nix). **Never** PROVABLY. |

**Discovery path ≠ PROVABLY.** A launcher or symlink at `ref/bin/ccomp` that only execs `result-compcert` / nix **satisfies tool discovery under `./ref`** for accomplishment *mode*, but the compliant script **downgrades** to `COMPCERT_DOGFOOD=1` when the resolved binary is not a real ELF under `ref/CompCert/`.

**PROVABLY path criterion ≠ Coq-from-source.** The gate checks *path + ELF*, not “we rebuilt CompCert with `coqc` here”. A prebuilt pin (copy of nix `.ccomp-wrapped` into `ref/CompCert/ccomp`) can unlock the token; honesty is recorded in **`ref/ccomp.PIN.txt`** (parent tree, not inside the submodule). Full source rebuild remains the strongest supply-chain story when Coq/OCaml are available.

## Why it exists

Systems Lean’s compliant gate (full product TU matrix — see `doc/dev/systems-lean.md`):

1. Emit freestanding product C (sealed MemSafety + CompCert-oriented certs) for **Extract + all listed Systems product modules** (341 TUs today = Extract + 340 PRODUCT_STDLIB; list = `script/systems-product-stdlib-modules.txt`).
2. **ResidualFree** (nm + IR greps; hard-require every companion), **SorryFree**, and **AxiomAuto** (ComplianceCorpus vs `systems-tcb-axiom-allowlist.txt`).
3. Compile pure stripped TUs with real `ccomp`.
4. Emit **PROVABLY** only if step 3’s resolved binary is under `ref/CompCert/`; otherwise **DOGFOOD**.

Lean owns residual-free emit and obligations; CompCert owns C→asm for accepted pure TUs. We are **not** CompCert. The **elaborator is not CompCert-verified**.

## Init

From the lean4 repository root:

```bash
# Preferred: submodule sources (pinned v3.16)
git submodule update --init --recursive ref/CompCert

# Helper:
#   ./ref/build-ccomp.sh --status
#   ./ref/build-ccomp.sh           # real ELF / Coq rebuild / prebuilt ELF pin / dogfood
#   ./ref/build-ccomp.sh --pin-elf # copy RESULT/nix real ELF → ref/CompCert/ccomp
#   ./ref/build-ccomp.sh --nix     # RESULT/nix launcher only (DOGFOOD)

# PROVABLY path A — hermetic flake (recommended; multi-platform; no host Rocq/OCaml):
#   nix build .#compcert -o result-compcert
#   ./ref/build-ccomp.sh --flake
#   # or one shot: ./ref/build-ccomp.sh --flake
#   # builds CompCert with Coq+OCaml *inside* the Nix sandbox (nixpkgs),
#   # then pins real ELF → ref/CompCert/ccomp for the PROVABLY path criterion
#
#   Also available:
#     nix run .#ccomp -- -version
#     nix develop .#compcert          # ccomp + coqc + ocaml on PATH
#     packages: .#compcert / .#systems-compcert
#
# Platforms: x86_64-linux, aarch64-linux, aarch64-darwin, x86_64-darwin
# (aligned with flake systems; nixpkgs CompCert may support more).
# License: INRIA Non-Commercial (unfree) — flake enables allowUnfree for this attr only.

# PROVABLY path B — pin an existing RESULT without flake rebuild:
#   export SYSTEMS_LEAN_COMPCERT_RESULT=$PWD/result-compcert
#   ./ref/build-ccomp.sh --pin-elf

# PROVABLY path C — Coq-from-source rebuild of the submodule (strongest local story):
#   nix develop .#compcert            # or Arch: rocq/ocaml packages
#   cd ref/CompCert && ./configure x86_64-linux && make -j$(nproc)
#   # result must be real ELF at ref/CompCert/ccomp (not a shell script)

# Dogfood-only pin (shell launcher under ref/bin → RESULT/nix):
#   ./ref/build-ccomp.sh --nix
# Result: COMPCERT_DOGFOOD=1 only — NOT PROVABLY.
```

### Honesty: binary vs sources

* **Sources:** `ref/CompCert` at tag **`v3.16`** (submodule gitlink).
* **PROVABLY binary:** must resolve to a **non-shell** machine-code binary under **`ref/CompCert/`** (ELF `ref/CompCert/ccomp`). A shell script at that path that only execs nix is **not** PROVABLY.
* **Prebuilt pin vs rebuild:** `--pin-elf` / `--flake` installs a real ELF from RESULT/nix and writes **`ref/ccomp.PIN.txt`** (outside the submodule so `git status` stays clean). That satisfies the **path/ELF** criterion for the PROVABLY token when product conjuncts are green; it is **not** a claim that CompCert was rebuilt from Coq in this tree.
* **Dogfood binary:** `ref/bin/ccomp` launcher → `result-compcert` / nix, or `ALLOW_RESULT=1` with RESULT/PATH.
* A launcher under `./ref` (or a fake `ref/CompCert/ccomp` script) that only execs nix **does not** make the product **provably** CompCert compliant.
* Prefer Coq rebuild when deps allow; otherwise prebuilt ELF pin is the honest next step.

## Discovery (harness)

`tests/lake/examples/systems/check_compcert.sh` looks for `ccomp` in this order:

1. **`./ref`** candidates: `ref/ccomp`, `ref/bin/ccomp`, `ref/ccomp.opt`
2. `SYSTEMS_LEAN_COMPCERT_RESULT` (dir with `bin/ccomp`)
3. `result-compcert`, flake `pkgs.compcert`, host `PATH` (optional dogfood only)

`systems-compcert-compliant.sh` then **resolves** that path (follow launcher/symlink) and chooses the success token:

```bash
# Default (REQUIRE_REF discovery under ./ref):
./script/systems-compcert-compliant.sh
# → PROVABLY_COMPCERT_COMPLIANT=1  only if resolved ccomp ∈ ref/CompCert/
# → else COMPCERT_DOGFOOD=1 when product conjuncts hold (honest downgrade)

# Explicit RESULT/nix dogfood (never PROVABLY):
SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
  SYSTEMS_LEAN_COMPCERT_RESULT=$PWD/result-compcert \
  ./script/systems-compcert-compliant.sh
# → COMPCERT_DOGFOOD=1
```

Missing `./ref` under `REQUIRE_REF` is a **tool discovery** failure (fail closed), not a product residual rejection.

## Non-goals

* Not required for `nix build .#lean` or classic stage1 / default tests
* Does not make Lean “be” CompCert; does not CompCert-verify the elaborator
* Full CompCert Coq rebuild is optional when a version-matched dogfood pin is enough
