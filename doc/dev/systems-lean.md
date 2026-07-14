# Systems Lean

**Systems Lean** is Lean 4 configured for systems programming: ownership-safe resources, thin syscalls, and ahead-of-time compilation to a normal C static library — without the Lean object runtime on the consumer link line. Proofs stay on a full host Lean toolchain and are erased from the embed trusted computing base (TCB).

| Term | Meaning |
|------|---------|
| **Systems Lean** | Product name for this project / capability |
| **Freestanding** | Technical mode: closed subset + fail-closed codegen + no managed runtime |
| **Host** | Full Lean (Init, tactics, `Prop`) used for proofs and tooling only |
| **Extract** | Freestanding modules that become the embed static library |

**One-sentence goal.** A closed Lean subset AOT-compiles to a small static `.a` with:

- no `libleanshared` / Lean object runtime in the consumer  
- no automatic memory management (no refcount, no GC) in the embed TCB  
- memory safety from types (affine discipline + dependent sizes), not from a managed heap  

**Naming.** Product modules use **plain, intentional names**. The legacy `Lite` suffix is being drained deliberately — not via bulk rename. Thesaurus heaps, fake `V*` headers, and magic-only `G7*Nb` annexes are **frozen** as PRODUCT growth and scheduled for audit+delete. See **[systems-naming.md](systems-naming.md)**.

### Maturity waves

| Wave | Name | Status |
|-----:|------|--------|
| **0** | Foundation — freestanding compiler + no runtime on the wire | **done** |
| **1** | Systems surface — Sys, affine, arenas, log, mmap, host proofs | **done** |
| **2** | Usable shape — control-flow, in-tree prelude, Lake freestanding packaging | **done** |
| **3** | Polished — one story, one happy-path link, green example | **done** (on this branch) |
| **4** | Adoption — real embed consumers | **later** |

Wave 3 is the polish bar for this branch: one narrative, `freestanding.bundle` happy path, green example. Wave 4 is real embed consumers outside this spike — not required here.

### Implementation roadmap

Honest status on this branch. **R1–R7 product paths are done.** The **CompCert compliant gate is shipped** (full product TU matrix + residual/sorry/axiom-auto/cert/ccomp). **PROVABLY** requires resolved `ccomp` under `ref/CompCert/` (in-tree build); a `./ref` launcher that only execs nix/RESULT yields **`COMPCERT_DOGFOOD=1` only**. Three-Layer Cake **L1–L3 freestanding modules shipped**: product bodies stay **sequential** residual-free (L1 includes SIMD-**shaped** chunked-4 loops; L2 sequential partitions; L3 affine channel). **Track C dual-path shipped:** product isolation gate (`systems-par-dual-path-check.sh` / `PARALLELISM_DUAL_PATH_OK=1`); opt-in **pthread L2** host dogfood (`par_pthread.c` / `make check-par-pthread`; compile define `-DSYSTEMS_LEAN_PAR_PTHREAD=1`, not residual/ccomp product matrix); opt-in **HW SIMD L1** host dogfood (`par_simd_hw.c` / `make check-par-simd-hw`; SSE2 or scalar fallback). Concurrent memory model remains **assumed host dogfood**, not CompCert-proved product residual (`CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1`). Dual flakes **shipped**. TCB **axiom auto-gate shipped** (`systems-axiom-check.sh` / `GATE axiom_auto`). **TCB honesty gate shipped** (`systems-tcb-inventory.sh` / `GATE tcb_honesty`). **G3 host elaborator residual measurement shipped** (`systems-host-elaborator-residual.sh` / `GATE host_elaborator`) — stage1 still links classic RC/shared runtime so **measured `GC_FREE_ELABORATOR=0`** (earned `=1` only when NEEDED proves no `leanshared`/`Init_shared`; full elaborator rewrite **not** claimed). Product embed aims residual-free (`PRODUCT_GC_FREE`, separate token). Remaining **W-series**: verified concurrent runtime / memory model (beyond assumed dogfood), fuller FS ports, residual reduction toward a freestanding host driver. Classic Lean users are unaffected (opt-in only; **semver-minor** additive APIs).

| Step | Deliverable | Status |
|------|-------------|--------|
| **R1** | QTT multiplicities 0/1/ω + binder mult API | **done** — `Multiplicity.lean`, `QTT/ElabCheck.lean` |
| **R2** | Elaborator use-check (linear drop/double-use, borrow, splitters) | **done** — `QTT/UseCheck.lean`, PreDefinition hook (flake: **must** track `QTT/UseCheck.lean`) |
| **R3** | CompCert-oriented certs + real `ccomp` dogfood | **done** — `CompCertCert.lean`, `make check-compcert` / `check-full` |
| **R4** | End-to-end proof receipt (Lean verify ∧ ccomp ∧ optional nm) | **done** — `script/systems-proof-receipt.sh` |
| **R5** | Product integration (this doc, harness, nix smoke, integration matrix) | **done** on this branch |
| **R6** | Self-host `lean-systems` product without mandatory GC | **done** (product path) — elaborator still classic ([systems-lean-selfhost.md](systems-lean-selfhost.md)) |
| **R7** | Full Init/Std under freestanding constraints | **product path done** — first-wave FS + inventory; ports ongoing ([systems-lean-stdlib-inventory.md](systems-lean-stdlib-inventory.md)) |
| **PRODUCT_STDLIB** | Closed freestanding product module manifest + validate gate | **done** — `script/systems-product-stdlib-modules.txt`, `GATE product_stdlib` |
| **Compliant gate** | ResidualFree ∧ SorryFree ∧ AxiomAuto ∧ CertsVerify ∧ ccomp on **full** product TU matrix | **done** — dogfood token always available; PROVABLY only if resolved ccomp ∈ `ref/CompCert/` |
| **Dual flakes** | `packages.lean` (classic, default) + `packages.systems-lean` | **shipped** — both dogfoodable; hermetic completeness may still grow |
| **systems.nix front door** | **Single Systems tooling entry** (shells, light checks, apps) | **shipped** — prefer `systems.nix` over new `script/systems-*.sh` gates; **light** = pure-sandbox `nix build .#checks.<system>.systems-light` (= `checks.systems` / `packages.systems-check-light`) or host `nix run .#systems-check` (SKIP dual-path without bundle; no stage1); **full SCORE (primary)** = `systems-validate` / docs alias `systems-score` when stage1 + freestanding bundle at `tests/lake/examples/systems` present (not pure-sandbox packaged SCORE; T4+); apps `systems-status` / `systems-check` / `systems-validate`; shell aliases `systems-dev` |
| **Three-Layer Cake** | L1 Simd / L2 ForkJoin / L3 Channel freestanding modules | **shipped** — product sequential residual-free; L1 chunked-4 shape; L2 opt-in pthread dogfood; L3 richer affine API |
| **Track C dual-path** | Product Parallelism isolation + opt-in pthread / HW SIMD dogfood | **shipped** — `PARALLELISM_DUAL_PATH_OK` (modules still under `Systems/Parallelism/`); `make check-par-pthread` / `check-par-simd-hw`; concurrent runtime **assumed not proved** |
| **P5 / TCB honesty** | Host vs product TCB greppable tokens + validate gate | **shipped** — `GATE tcb_honesty`; dual-path honesty (classic / earned residual_free) |
| **G1 / product GC-free** | Product wire residual greppable tokens + validate gate | **shipped** — link-check emits tokens on **nm residual success**; validate `GATE product_gc_free` requires residual_nm ∧ residual_ir ∧ those tokens (scoreboard authoritative); **not** elaborator GC-free |
| **G2 / linear residual metrics** | Mult-policy / FreeSafety greppable residual metrics + validate gate | **shipped** — `systems-linear-residual-metrics.sh` / `GATE linear_metrics`; second-use impossible, mult-0 non-runtime, product residual mult policy markers; **not** elaborator completeness; **not** `GC_FREE_ELABORATOR=1` |
| **G3 / host elaborator residual** | Measure host lean residual + earned `GC_FREE_ELABORATOR` + validate gate | **shipped (staged residual measurement / earned token)** — `systems-host-elaborator-residual.sh` / `GATE host_elaborator`; stage1 → measured `GC_FREE_ELABORATOR=0`; non-ELF fail-closed unmeasured; full elaborator without GC **not** claimed |
| **Track F / tooling honesty** | Inventory SSoT, docs honesty, opt-in CI, systems.nix dogfood | **shipped** — `systems-stdlib-inventory.sh --write/--require`, `systems-status.sh`, `.github/workflows/systems-lean.yml` primary `checks.systems-light`, hermetic `nix develop .#systems` |
| **W0+** | Axiom **auto**-gate **done**; TCB honesty **done**; product GC-free tokens **done**; G2 linear metrics **done**; G3 host residual measure **done**; Track C dual-path dogfood **done** (host pthread / HW SIMD off residual); Track F tooling/docs/CI honesty **done**; **backlog:** product residual HW SIMD (on residual/ccomp matrix), verified concurrent runtime / memory model, more FS ports, freestanding host driver | axiom + honesty + product GC + G2 + G3 + Track C dogfood + Track F **shipped**; product residual HW SIMD + verified concurrent **not claimed** |

Do **not** claim a GC-free elaborator, full FS Init, or **provably CompCert compliant** unless the formal predicate below holds **and** the greppable line is exactly `PROVABLY_COMPCERT_COMPLIANT=1` (resolved `ccomp` under `ref/CompCert/`, full product TU matrix). `COMPCERT_DOGFOOD=1` is weaker. Dual path: product `PRODUCT_GC_FREE` (embed wire residual) vs host `GC_FREE_ELABORATOR` (measured elaborator residual — `=1` only when NEEDED proves no `leanshared`/`Init_shared`). `GATE tcb_honesty` + `GATE host_elaborator` make host TCB greppable so it cannot be confused with product residual-free embed TCB. Product wire tokens: link-check emits `PRODUCT_GC_FREE=1` / `PRODUCT_NO_LEANSHARED=1` after **nm residual success** only; validate scoreboard lines (after `GATE product_gc_free`) are authoritative and require residual_nm ∧ residual_ir ∧ those tokens. Inventory may mirror product GC tokens from a full nm residual scan (advisory; not residual_ir). **Stage1 today still measures `GC_FREE_ELABORATOR=0`.**

### End-to-end dogfood path (start here)

From the lean4 root, with a local stage1 (or after `nix build .#systems-lean` and putting `result/bin` on `PATH`):

```bash
# 0) Build stage1 (dev loop; incremental)
make -j$(nproc) -C build/release
export PATH="$PWD/build/release/stage1/bin:$PATH"
# If stage1 `lean` fails to load host libs, set LD_LIBRARY_PATH for the *host* only.
# Do not export a blanket LD_LIBRARY_PATH into CompCert/nix `ccomp` steps — the harness unsets it.

# 0b) Hermetic multi-gate — systems.nix is the Systems tooling front door
# Prefer systems.nix apps/shells over ad-hoc script/systems-*.sh invocation.
#
# Light gates (no stage1 lean; dual-path SKIP if no .lake bundle / pure flake self):
#   nix build .#checks.x86_64-linux.systems-light
#   # aliases: .#checks.x86_64-linux.systems  |  nix build .#systems-check-light
#   nix run .#systems-check                  # same light body on host tree
# Fast status only (no full scoreboard):
#   nix develop .#systems --command systems-status
# Full SCORE PRIMARY (needs stage1 lean + freestanding product bundle at
# tests/lake/examples/systems; pure Nix packaging of SCORE = T4+ still open):
#   systems-validate puts build/release/stage1/bin on PATH when present.
#   Docs alias: nix run .#systems-score  ≡  systems-validate (same program; not a new gate).
#   SCORE line: pass=A fail=B skip=C  (exit 0 only when core integrity + non-FAIL CompCert/negatives).
nix develop .#systems --command systems-validate
# Optional CompCert shell: nix develop .#systems-full
# Honesty: PRODUCT_GC_FREE (embed wire) ≠ GC_FREE_ELABORATOR (host stage1 residual; still 0).

# 1) Minimal integration matrix (QTT + memsafe elab + freestanding + R6 self-host; no CompCert)
./script/systems-lean-smoke.sh
#    includes make -C tests/lake/examples/systems check (no clean)
#    and ./script/systems-selfhost.sh (lean-systems + nm gate); skip R6 with SYSTEMS_LEAN_SMOKE_SELFHOST=0

# 2) Classic freestanding harness only (includes check-selfhost nm gate; no clean)
make -C tests/lake/examples/systems check
#    From-scratch harness: cd tests/lake/examples/systems && ./test.sh
#    (./test.sh runs clean.sh then make check — not identical to smoke)

# 2b) R6 self-host product path only
./script/systems-selfhost.sh
#    installs out/systems-selfhost/bin/lean-systems

# 3) Optional full gate when CompCert is available (unfree nix ccomp)
#    export SYSTEMS_LEAN_COMPCERT_RESULT=...  # see CompCert dogfood below
make -C tests/lake/examples/systems check-full

# 4) Nix package smoke (eval / dry-run; full bootstrap is slow)
nix eval .#packages.x86_64-linux.systems-lean.name
nix build .#systems-lean --dry-run
```

#### Dogfood path — gates and greppable success tokens

| Target / script | CompCert? | What it covers | Greppable success |
|-----------------|-----------|----------------|-------------------|
| `./script/systems-status.sh` | No | Fast inventory + PRODUCT count + key honesty tokens (not full validate) | `SYSTEMS_STATUS_OK=1`, `FS_READY=149` |
| `./script/systems-stdlib-inventory.sh` | No | Live Init/Std/FS buckets; `--write` refreshes doc; `--require` drift-checks doc | `fs-ready=149` (stderr OK line; Phase C after ordered-leaf `*SetLite` delete) |
| `./script/systems-lean-smoke.sh` | No (unless `SYSTEMS_LEAN_SMOKE_FULL=1`) | Elab QTT/memsafe + freestanding `make check` + R6 self-host (no clean) | script exit 0 |
| `./script/systems-selfhost.sh` | No | R6 product path: FS build + `lean-systems` install + nm gate + negatives | exit 0; nm residual clean |
| `./script/systems-product-stdlib-check.sh` | No | Closed FS set vs sources/lake/policy/corpus | `PRODUCT_STDLIB_MODULES_OK=1`, `PRODUCT_CORPUS_ALIGN_OK=1` |
| `./script/systems-axiom-check.sh` | No | TCB axiom allowlist over ComplianceCorpus | `AXIOM_AUTO_GATE_OK=1` |
| `./script/systems-selfhost-link-check.sh` | No | Product nm residual | `PRODUCT_GC_FREE=1`, `PRODUCT_NO_LEANSHARED=1` (on residual success) |
| `./script/systems-tcb-inventory.sh` | No | Host vs product TCB honesty (advisory by default) | `TCB_HONESTY_OK=1`, `GC_FREE_ELABORATOR=0` (stage1 today) |
| `./script/systems-host-elaborator-residual.sh` | No | G3 measured host residual | `HOST_ELABORATOR_RESIDUAL_OK=1`, measured `GC_FREE_ELABORATOR` |
| `./script/systems-linear-residual-metrics.sh` | No | G2 Mult/FreeSafety mult-policy source greps | `LINEAR_RESIDUAL_METRICS_OK=1` |
| `./script/systems-qtt-depth-check.sh` | No | Track D UseCheck pure-fvar + bif* splitter | `QTT_DEPTH_OK=1` |
| `./script/systems-par-dual-path-check.sh` | No | Track C product Parallelism isolation (needs freestanding bundle; honest SKIP if absent) | `PARALLELISM_DUAL_PATH_OK=1`, `CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1` |
| `./script/systems-validate.sh` | Optional | Full scoreboard (all core gates + negatives + CompCert discovery) | `SCORE … fail=0`; per-gate `GATE *=PASS` |
| `make check` | **No** | Classic Systems Lean checks incl. `check-selfhost` (no clean) | make exit 0 |
| `make check-selfhost` | No | nm gate only on freestanding bundle | exit 0 |
| `./test.sh` | **No** | `clean.sh` then `make check` (from-scratch harness) | exit 0 |
| `make check-full` | **Required** | check + CompCert negatives + real ccomp + proof receipt | exit 0 |
| `make check-proof-receipt` | Required by default | R4 aggregate receipt | exit 0 / receipt tokens |
| `make check-compcert` | Optional (skip unless REQUIRE) | Real ccomp on sealed C | exit 0 or honest SKIP |
| `make check-compcert-compliant` | `./ref` discovery | Full **149-module / 150-TU** product matrix; **PROVABLY** iff resolved ccomp ∈ `ref/CompCert/`; else honest **DOGFOOD** | `PROVABLY_COMPCERT_COMPLIANT=1` or `COMPCERT_DOGFOOD=1` |
| `make check-compcert-dogfood` | RESULT/nix/PATH | Same conjuncts with RESULT allowed → dogfood only | `COMPCERT_DOGFOOD=1` (never PROVABLY) |
| `./script/systems-compcert-compliant.sh` | `./ref` discovery by default | Same as above from lean4 root; `ALLOW_RESULT=1` forces dogfood mode | same tokens |
| GitHub `systems-lean.yml` | No (ccomp optional) | **Opt-in** workflow (`workflow_dispatch` + `systems` branch path filters); does **not** touch classic `ci.yml` | light suite green; full validate when stage1 present |

**Honesty (non-claims):** stage1 still measures `GC_FREE_ELABORATOR=0` until residual_free is earned; PRODUCT_STDLIB is **shaped freestanding** (149 modules / 150 TUs with Extract; Phase C deleted 38 ordered-leaf `*SetLite` after B3 −69 magic codec toys, B2 −45 `V*Lite`, B1 −39 thesaurus `*HeapLite`), not full Init; concurrent Parallelism host dogfood is **assumed not proved** (`CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1`).

---

## Why it exists

Default Lean AOT is **native code + managed runtime**. That is fine for many tools; it is not freestanding.

| Fact | Implication |
|------|-------------|
| `@[export]` product path links Lean shared libs | Consumer hosts object model + RC |
| Init needs `lean_initialize_runtime_module`, module `initialize_*` | Runtime is mandatory for classic export |
| Values default to `lean_object*` | Lists, strings, `IO` world tokens are managed |
| **AOT ≠ freestanding** | AOT means “not an interpreter.” Freestanding means **no Lean managed runtime on the link line** |

Systems Lean is the **minimum language + compiler + library surface** so an embedded systems core (for example a key-value engine) can be written in Lean and linked from C like any other static library.

---

## Goals and non-goals

### Goals

1. **Fail-closed freestanding codegen** — residual `lean_alloc_*` / RC / object ABI is a hard error.  
2. **Unboxed C ABI** — `@[export_c]` → `extern "C"` without `lean_object*` in product signatures.  
3. **Affine resource types** — buffers, file descriptors, mmap regions, arenas (move-only + explicit free).  
4. **Thin `Sys` effect** — sequenced syscalls / libc, not full Lean `IO`.  
5. **Proofs on host, erased at runtime** — `Prop` / tactics stay out of the embed TCB.  
6. **Enough surface for an embed store spine** — open / put / get / sync-class APIs, byte buffers, file + mmap IO.

### Non-goals

- Full Lean compatibility on the freestanding target  
- Replacing all of `IO` / tasks / networking / the Lake ecosystem  
- Refcount “only for convenience” inside the embed TCB  
- Full Rust lifetime polymorphism / complete borrow checker as day-one requirement  
- Hand-written C as the semantic single source of truth for the product  
- Claiming Systems Lean is already on every published Lean pin  

---

## Architecture: dual pipeline

```text
                 ┌── Host Lean ── Init, Prop, tactics ── typecheck only (erased)
Lean sources ────┤
                 └── Systems Lean extract ── freestanding modules ── static .a + C header
                                              (no lean.h object runtime)
```

| | Host | Extract (Systems Lean) |
|--|------|-------------------------|
| Option | normal Lean | `compiler.freestanding=true` (via Lake `freestanding := true`) |
| Imports | Full Init / libraries | Closed freestanding DAG only (`Systems.*`, extract modules) |
| Memory | RC heap OK | Affine + explicit free / arenas only |
| Artifact | `.olean` / tools | `lib*.a` for `cc -std=c11` consumers |
| Link deps | Lean shared libs OK | **libc only** (no `Init_shared` / `leanshared*`) |

---

## Capability map (what exists)

These map the original design features (N1–N7) to the current tree.

| ID | Capability | Where |
|----|------------|--------|
| N1 | Unboxed freestanding scalars (`U8`…`U64`, `USize`, `Bool`) | `src/Systems/Scalars.lean`, compiler type table |
| N5 | `@[export_c]` freestanding C exports | `src/Lean/Compiler/ExportCAttr.lean` |
| N6 | Fail-closed freestanding EmitC / import gate | `src/Lean/Compiler/LCNF/EmitC.lean`, `Freestanding.lean` (compiler mode tables; product brand is Systems), import checks |
| N2 | Affine resources + freestanding borrows | `AffineAttr.lean`, `LCNF/AffineCheck.lean` |
| N4 | Thin `Sys` (open/read/write/close, …) | `src/Systems/Sys.lean` |
| N3 | Arenas / region stamps / derived-buffer UAF | `Sys.lean` + affine region checker |
| N7 | Control-flow for scalar loops (TCO → C `if`/`goto`) | freestanding `Bool` / `bif*` / recursive helpers |
| — | Append log put/get/sync | `Sys.lean` log API + example extract |
| — | mmap / msync / munmap durability | `Sys.lean` MMap API |
| — | Host-only proofs about the spine | example `host/` package |
| — | Lake freestanding packaging | `freestanding := true`, `freestanding` / `freestanding.bundle` facets |

### Forbidden on the freestanding extract path

| Forbidden | Why |
|-----------|-----|
| `lean_object*` / boxed heap values | Object model is the rejected TCB |
| Automatic refcount (`lean_inc` / `lean_dec`) | Automatic memory management |
| Link of Lean shared libs (`Init_shared`, `leanshared*`) | Full runtime |
| Unrestricted Lean `IO` / `lean_io_*` | IO runtime |
| Default `List` / `String` / RC `Array` on product hot path | Managed containers |
| Multi-field freestanding product *values* (MVP) | LCNF trivial structure = one field; use dual params |

**Still allowed on host (or erased):** `Prop`, tactics, proof-only predicates, dependent indices as type-level / host-only refinements.

---

## Memory safety model

Systems Lean approximates **Rust ownership guarantees**, not full Rust feature parity:

| Technique | Role |
|-----------|------|
| Affine resources | No unrestricted copy; consume via close/free |
| Freestanding borrows (`@[fs_borrow]`) | Non-owning; distinct from RC `@&` |
| Region stamps | Arena free invalidates derived views |
| Explicit free | No RC finalizers for durability |
| Dependent sizes / host proofs | Bounds and protocols; erased from runtime |
| Full borrow checker / lifetime vars | **Not** required for MVP |

---

## How to use Systems Lean

### 1. Build a stage1 Lean with Systems Lean support

**Local incremental (dev loop):**

```bash
make -j$(nproc) -C build/release
export PATH="$PWD/build/release/stage1/bin:$PATH"
```

Optional: build the in-tree prelude lib (not a default stage1 target):

```bash
lake --dir=src build Systems
```

**Self-host / full stdlib (Systems Lean only):** see [systems-lean-selfhost.md](systems-lean-selfhost.md) and [systems-lean-stdlib-inventory.md](systems-lean-stdlib-inventory.md). Classic `stage1` with RC runtime is unchanged; GC is **not required** only for freestanding / self-host FS products.

**Nix packages (other flakes, no elan):** this repo exposes **hermetic** stage0→stage1 toolchains (shared [`nix/lean-toolchain.nix`](../../nix/lean-toolchain.nix); mimalloc ON; cadical/leantar from Nix) **and** a hermetic CompCert package. Lean packages do **not** require CompCert or `./ref`.

| Package | Identity | Default? |
|---------|----------|----------|
| `packages.<sys>.lean` | Classic Lean 4 (RC runtime defaults) | **yes** (`default`) |
| `packages.<sys>.systems-lean` | Systems Lean (same tree; freestanding/QTT opt-in) | no — use `.#systems-lean` |
| `packages.<sys>.compcert` | Hermetic CompCert `ccomp` (nixpkgs Coq+OCaml sandbox; **unfree**) | no — `.#compcert` / alias `.#systems-compcert` |

**Hermetic CompCert (multi-platform, no host Rocq/OCaml):**

```bash
# Build CompCert with Coq + OCaml *inside* Nix (works without Arch rocq/ocaml installs)
nix build .#compcert -o result-compcert
nix run .#ccomp -- -version
nix develop .#compcert   # optional: ccomp + coqc + ocaml for submodule rebuilds

# Pin real ELF under ref/CompCert/ for Systems Lean PROVABLY path criterion
./ref/build-ccomp.sh --flake
./script/systems-validate.sh   # expect GATE compcert_provably=PASS when product green
```

**`systems.nix` is the Systems tooling front door** (no full Lean bootstrap): hermetic tools for product gates (`rg`, `nm`, `make`, `file`, `python3`, bash), Nix checks, and thin apps wrapping existing scoreboard scripts. Prefer extending `systems.nix` / flake checks over adding new free-standing `script/systems-*.sh` gates. `script/systems-validate.sh` remains the full SCORE aggregator until packaged (T4). Run from a lean4 checkout; put stage1 `lean`/`lake` on `PATH` separately when needed.

**T4 pure-Nix SCORE progress (honest):** light pure check + host `systems-check` + thin `systems-validate` / docs alias `systems-score` (same app) are shipped. **Host honesty:** `nix run .#systems-score` still requires **host stage1** lean + freestanding product bundle (not pure Nix SCORE); `checks.<sys>.systems-score-pure` remains **NOT YET** — do not invent a pure SCORE derivation. **SCORE gate count:** full scoreboard has **15** `set_gate` names (`residual_nm` … `negatives`; `compcert_dogfood` and `compcert_provably` are two). **Light vs full:** `systems-light` / `systems-check` is a **pure-sandbox** subset (inventory / product-stdlib / axiom / QTT-depth / linear / tcb + optional dual-path SKIP) — no stage1; it is **not** the 15-gate aggregator. Full SCORE needs host stage1 + bundle. Full SCORE is **not** yet a pure flake check: it still needs (1) in-store stage1 lean, (2) freestanding product bundle in-store (pure `self` has no `.lake/`), and (3) lean-backed gates that consume those inputs. Dual-path under light is honest **SKIP** without bundle — never forge `PARALLELISM_DUAL_PATH_OK`. **Future pure check name (NOT YET):** `checks.<sys>.systems-score-pure` — documented in `systems.nix` only; **not** shipped; always **system-qualified** (never an unqualified invent). **Stage1 lean suppliers (existing flake packages):** `packages.<sys>.systems-lean` (`${systems-lean}/bin/lean`, preferred Systems identity) or `packages.<sys>.lean` (`${lean}/bin/lean`, classic default) — both already ship stage1 lean; pure SCORE would wire one as a buildInput. **T4.2 hard blocker (after package lean):** even once stage1 lean is an in-store buildInput, pure SCORE still needs dependent **in-store freestanding Lake** of `tests/lake/examples/systems` producing `libfs_extract_bundle.a` — that bundle path is the hard residual after package lean is available; no new bash gates; prefer systems.nix packaging. **T4.2 sub-step (docs only):** future pure check must invoke that Lake freestanding build **inside the derivation** (sandbox + in-store lake/lean), never reading a host checkout `.lake/` tree. **T4.2 acceptance criterion (docs only):** pure SCORE derivation may **not** import host PATH lean or host checkout `.lake/`; only Nix **store paths** for stage1 lean/lake and the freestanding bundle. **T4.3 precondition (docs only):** once those store paths exist, pure SCORE must still re-run residual_nm / residual_ir **style** product residual gates on the **store** bundle (same residual scripts with store paths, or in-derivation equivalent) — a pure check **cannot skip** product residual and still claim full SCORE (light inventory/axiom/QTT subset is a different check). **T4.4 packaging fail-closed (docs only):** pure SCORE must be system-qualified (`checks.<sys>.systems-score-pure`) and **fail-closed** if stage1 lean or freestanding product bundle is missing — never soft-skip residual_nm / residual_ir / product_gc_free (or other lean-backed residual gates) to pretend SCORE green without those inputs (light may honest-SKIP dual-path; pure SCORE may not). Until packaging lands, prefer host `systems-validate` for the scoreboard; `systems-score-pure` remains **NOT YET**. No invented pure SCORE; no new bash gates.

**Q residual (honest):** UseCheck multi-arm fail-closed edges include `Lean.Name.num.elim` (sibling sparse ctor-elim of `Name.str.elim`; `isSparseCasesOn`; sparse path never sequential-consumed; not covered by `Name.str.elim` alone) plus `Lean.Name.str.elim` plus `Lean.Literal.natVal.elim` / `Lean.Literal.strVal.elim` plus prior Acc.recOn/Acc.rec/HEq.recOn/HEq.rec/rec/recOn/brecOn/ndrec/ndrec_symm/noConfusion/WF.fix·fixF/Quot.lift·ind·liftOn in `tests/elab/qtt_use_check.lean`. Surface still not complete.

**Light ≠ full SCORE (honest):** A green `systems-light` / `systems-check` result is **not** a full SCORE claim. Light is a pure-sandbox subset (inventory / product-stdlib / axiom / QTT-depth / linear / tcb; dual-path may honest-SKIP without bundle) and needs no stage1. Full SCORE is the 15-gate `systems-validate` / `systems-score` aggregator and needs host stage1 + freestanding product bundle. `checks.<sys>.systems-score-pure` remains **NOT YET** — no invented pure SCORE; no new bash gates.

```bash
# Mental model (one entry: systems.nix → flake outputs)
nix develop .#systems            # free: rg + binutils + make + file + apps
nix develop .#systems-full       # systems + hermetic ccomp (unfree)
nix build .#checks.x86_64-linux.systems-light   # pure sandbox light gates (= checks.systems)
nix run .#systems-status         # thin app → script/systems-status.sh
nix run .#systems-check          # host light gates (no stage1; SYSTEMS_CHECK_LIGHT_OK=1)
nix run .#systems-validate       # PRIMARY full SCORE → script/systems-validate.sh (needs stage1)
# nix run .#systems-score        # docs alias ≡ systems-validate (HOST stage1 required; not pure; systems-score-pure NOT YET)
# aliases still work: .#systems-dev / .#systems-dev-full
./script/systems-status.sh                 # fast: FS_READY / PRODUCT / GC_FREE_ELABORATOR
./script/systems-product-stdlib-check.sh   # greppable: PRODUCT_STDLIB_MODULES_OK=1
./script/systems-validate.sh               # full SCORE aggregator; product example tests/lake/examples/systems

# Hermetic multi-gate one-liner (systems.nix dogfood)
nix develop .#systems --command bash -lc '
  export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
  systems-status && systems-validate
'
```

| Output | Purpose |
|--------|---------|
| `devShells.<sys>.systems` (`systems-dev` alias) | Hermetic gate tooling via `systems.nix` (no Lean rebuild, no CompCert) |
| `devShells.<sys>.systems-full` (`systems-dev-full` alias) | Gate tooling + hermetic `ccomp` (unfree) |
| `checks.<sys>.systems-light` (= `checks.systems`) | Sandbox light gates as Nix checks (inventory, product list, axioms, QTT depth, linear metrics; Parallelism dual-path SKIP when bundle absent) |
| `apps.<sys>.systems-check` | Host light wrapper (same gates as `systems-light`; no stage1) |
| `apps.<sys>.systems-status` / `systems-validate` | Status + **primary** full SCORE; validate needs host stage1 + freestanding bundle at `tests/lake/examples/systems` |
| `packages/apps.<sys>.systems-score` | Docs-facing alias for full SCORE (= `systems-validate`; no second implementation; not a pure Nix SCORE check) |
| `.#compcert` | CompCert + Coq/OCaml for submodule rebuilds |
| `.#systems-lean` | Full Systems Lean stage1 package on PATH (slow first build) |
| `.#lean` | Classic Lean stage1 package on PATH |

Flake systems currently include `x86_64-linux`, `aarch64-linux`, `aarch64-darwin`, `x86_64-darwin`. CompCert is INRIA Non-Commercial (unfree); the flake enables `allowUnfree` only for the isolated CompCert package set, not for classic Lean or `systems` shells.

```bash
# Package smoke (fast; does not compile Lean)
nix eval .#packages.x86_64-linux.lean.name            # → "lean-4.33.0"
nix eval .#packages.x86_64-linux.systems-lean.name    # → "systems-lean-4.33.0-systems"
nix build .#lean --dry-run
nix build .#systems-lean --dry-run

# Full package build (first build = full Lean bootstrap — slow; then store-cached)
nix build .#lean && ./result/bin/lean --version
nix build .#systems-lean
nix develop .#lean            # classic toolchain on PATH
nix develop .#systems-lean
nix develop .#systems         # portable gate tools only (systems.nix front door)
nix run .#lean -- --version
nix run .#systems-lean -- --version
```

Consumer flake (path or git input — no elan):

```nix
{
  inputs.lean4.url = "path:/home/hunter/Projects/cryptoquick/lean4";
  # or: inputs.lean4.url = "github:cryptoquick/lean4/systems";

  outputs = { self, nixpkgs, lean4, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      leanClassic = lean4.packages.${system}.lean;
      systemsLean = lean4.packages.${system}.systems-lean;
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ leanClassic pkgs.gcc ];  # or systemsLean for FS dogfood
      };
    };
}
```

**API discipline:** Systems Lean extends Lean 4 in a **semver-minor** spirit — new options, modules, and Lake facets only; classic public APIs and defaults stay stable.

Notes:

- Flake sources include **git-tracked / staged** files only (`inputs.self`). Untracked files are **invisible** to the flake even if present on disk. Before `nix build .#systems-lean`, stage/commit everything R1–R4 claim, at least:

  | Area | Paths that must be tracked |
  |------|----------------------------|
  | R1 multiplicity | `src/Lean/Compiler/Multiplicity.lean` |
  | R1–R2 QTT | `src/Lean/Compiler/QTT.lean`, `src/Lean/Compiler/QTT/ElabCheck.lean`, **`src/Lean/Compiler/QTT/UseCheck.lean`**, `src/Lean/Compiler/QTT/Theorems.lean` |
  | R2 PreDefinition hook | `src/Lean/Elab/PreDefinition/Basic.lean` (and related elab changes) |
  | Affine / freestanding | `src/Lean/Compiler/LCNF/AffineCheck.lean`, `src/Lean/Compiler/AffineAttr.lean`, … |
  | R3–R4 certs | `src/Lean/Compiler/LCNF/MemSafetyCert.lean`, `src/Lean/Compiler/LCNF/CompCertCert.lean` |
  | Prelude | `src/Systems/**` |
  | Product scripts | `script/systems-lean-smoke.sh`, `script/systems-proof-receipt.sh`, freestanding harness |
  | Elab tests | `tests/elab/qtt_*.lean`, `tests/elab/memsafe_cert.lean` (+ `.out.expected`) |

  Brace globs like `Compiler/{Multiplicity,QTT}.lean` do **not** include `QTT/UseCheck.lean` — list the `QTT/` directory explicitly. Forgetting `UseCheck.lean` ships a package without elaborator use-check while docs claim R2 done.
- There is no source filter that deliberately drops Multiplicity/QTT/MemSafetyCert; missing features in a nix build almost always mean “not in the git tree flake saw.”
- Put `lean` / `lake` on `PATH` from the package; do not rely on elan `lean-toolchain` for pure Nix consumers.
- For day-to-day hacking on this repo, prefer `make -C build/release` (incremental). Use the package when **another** flake should pin this tree.
- **Dirty tree:** `nix eval` / `nix build --dry-run` succeed with a dirty worktree (you may see a warning). Full `nix build .#systems-lean` is a multi-hour bootstrap if the store path is cold — prefer eval/dry-run for smoke; document full build only when caching is available.
- **Binary reuse:** this project’s CI uses `nix develop` for toolchains only — there is no Cachix (or other flake package cache) in-tree. After one successful `nix build .#systems-lean`, the store path is reused locally and by any path/git consumer on the **same machine**. Multi-machine binary cache is out of scope unless project CI gains one later (needs explicit project approval).

### 2. Declare freestanding packages in Lake

```lean
import Lake
open Lake DSL

package my_engine

lean_lib Systems where
  -- When using sources from this tree, point at lean4's src/ or depend on the package that owns them
  freestanding := true
  defaultFacets := #[LeanLib.freestandingFacet]
  roots := #[`Systems.Scalars, `Systems.Sys]

lean_lib Engine where
  freestanding := true
  -- Happy path for C consumers: one combined static archive
  defaultFacets := #[LeanLib.freestandingBundleFacet]
  needs := #[`@/Systems]
  roots := #[`Engine]
```

`freestanding := true` **forces** `compiler.freestanding=true` (fail-closed). Non-freestanding `lean_lib` entries on `needs` of a freestanding package are rejected at packaging time.

| Facet | Result |
|-------|--------|
| `freestanding` | Ordered list of static `.a` files (this lib + freestanding `needs`) |
| `freestanding.bundle` | **One** combined `.a` (`lib{name}_bundle.a`) — prefer for `cc` |

### 3. Write extract code

```lean
module
prelude
public import Systems.Scalars

@[export_c lean_fs_add]
public def add (x y : U64) : U64 := U64.add x y
```

Rules of thumb:

- Import only freestanding modules.  
- Prefer dual scalar params (`addr`, `len`) over multi-field freestanding products.  
- Own resources are affine; free/close explicitly.  
- Use `@[export_c]` for the C ABI (not classic `@[export]` for freestanding product roots).

### 4. Link from C (happy path)

```bash
# One freestanding archive for this extract + freestanding needs (no Lean dynlibs)
cc -std=c11 -o app main.c $(lake query Engine:freestanding.bundle)
```

Multi-archive list (tooling / debugging):

```bash
lake query Engine:freestanding
```

Consumer C should **not** include `lean/lean.h` or call `lean_initialize_runtime_module`.

### 5. Optional: host proofs

Keep a second package **without** freestanding for specs. Typecheck only; do not link host oleans into the embed archive. See the example under `tests/lake/examples/systems/host/`.

---

## Project layout

| Path | Role |
|------|------|
| `src/Systems/` | Systems Lean prelude (PRODUCT_STDLIB **149** modules: Scalars… + `BinaryHeap` (binary min-heap) + `OrderedU32Set`/`BitSet`/`IntervalSet`/`Set` + `TomlConfig`/`Manifest` + `Hdlc`/`Ppp` + `Flac`/`Ogg`/`Vorbis`/`Rtsp`/`Webm`/`Matroska` + Parallelism.*; Phase B1 −39 thesaurus `*HeapLite`; Phase B2 −45 `V[0-9]+Lite` header toys; Phase B3 −69 magic codec toys; Phase C −38 ordered-leaf `*SetLite`; Phase D1 renames `HeapLite`→`BinaryHeap`, `OrderedSetLite`→`OrderedU32Set`; Phase D2 renames `TomlConfigLite`→`TomlConfig`, `BitSetLite`→`BitSet`; Phase D3 renames `ManifestLite`→`Manifest`, `IntervalSetLite`→`IntervalSet`, `SetLite`→`Set`; Phase D4–D6 renames DepGraph/Trace/Map/Queue/CacheIndex/Vector/Deque/Stack/HashMap/LinkedHashMap/OrderedMap/TreeMap/BitMap/List/String; live list = `script/systems-product-stdlib-modules.txt`) |
| `src/Lean/Compiler/Freestanding.lean` | Freestanding **compile mode** tables/allowlists (product modules are `Systems.*`; module file name stays Freestanding) |
| `src/Lean/Compiler/ExportCAttr.lean` | `@[export_c]` |
| `src/Lean/Compiler/AffineAttr.lean` | `@[affine]`, `@[fs_borrow]`, `@[fs_fresh_region]` |
| `src/Lean/Compiler/LCNF/AffineCheck.lean` | Freestanding affine / region checker |
| `src/Lean/Compiler/LCNF/EmitC.lean` | Freestanding emit + ISO C11 posture |
| `src/Lean/Compiler/Multiplicity.lean` | QTT multiplicities 0/1/ω (Idris 2–class freestanding core) |
| `src/Lean/Compiler/QTT/` | Elab-facing QTT helpers + formal algebra markers |
| `src/Lean/Compiler/LCNF/MemSafetyCert.lean` | Memory-safety certificates (incl. QTT 0-qty erasure) |
| `src/Lean/Compiler/LCNF/CompCertCert.lean` | CompCert-oriented formal cert layer on top of memsafe |
| `doc/dev/systems-lean-selfhost.md` | Self-host without mandatory GC; classic runtime kept |
| `doc/dev/systems-lean-stdlib-inventory.md` | R7 inventory + dual-path + first-wave FS stdlib |
| `script/systems-stdlib.sh` | R7 freestanding stdlib build + nm gate |
| `script/systems-stdlib-inventory.sh` | Scripted Init/Std/(Lean) status buckets; `--write` SSoT doc; `--require` doc/PRODUCT drift |
| `script/systems-status.sh` | Fast greppable inventory + PRODUCT count + key tokens (not full validate) |
| `script/systems-product-stdlib-modules.txt` | Closed PRODUCT_STDLIB_MODULES manifest (authoritative product set; **149** modules → **150** TUs with Extract) |
| `script/systems-product-stdlib-check.sh` | Manifest ↔ sources ↔ lake ↔ residual-policy (`PRODUCT_STDLIB_MODULES_OK`) |
| `script/systems-validate.sh` | Strategic scoreboard (`GATE product_gc_free`, `GATE product_stdlib`, `GATE tcb_honesty`, `GATE host_elaborator`, `GATE linear_metrics`, `GATE qtt_depth`, residual, CompCert, …) |
| `.github/workflows/systems-lean.yml` | Opt-in Systems Lean gates (`workflow_dispatch` / `systems` branch paths); never forces classic `ci.yml` |
| `script/systems-linear-residual-metrics.sh` | G2 Mult/FreeSafety mult-policy residual greps; emits `LINEAR_*=1` / `MULT0_*=1` / `PRODUCT_RESIDUAL_MULT_POLICY=1` **only** on success |
| `script/systems-linear-residual-metrics-negatives.sh` | Fail-closed negatives for G2 metrics (forged free-true markers, stripped lemmas) |
| `script/systems-qtt-depth-check.sh` | Track D UseCheck pure-fvar residual + freestanding `bif*` ⊆ splitter allowlist; emits `QTT_*=1` **only** on success |
| `script/systems-qtt-depth-check-negatives.sh` | Fail-closed negatives for Track D depth (stripped pure-fvar path, missing bif allowlist) |
| `script/systems-host-elaborator-residual.sh` | G3 host elaborator residual measure (readelf/objdump NEEDED earn; ldd never earns residual_free); measured `GC_FREE_ELABORATOR` + `HOST_ELABORATOR_RESIDUAL` |
| `script/systems-host-elaborator-residual-negatives.sh` | Fail-closed negatives for G3 host residual (forged `GC_FREE=1`, FORCE refuse, REQUIRE missing lean) |
| `script/systems-selfhost-link-check.sh` | Product residual nm gate; emits `PRODUCT_GC_FREE=1` / `PRODUCT_NO_LEANSHARED=1` **only** on success |
| `script/systems-tcb-inventory.sh` | Host vs product TCB honesty tokens (`TCB_HONESTY_OK`, measured `GC_FREE_ELABORATOR`); mirrors product GC tokens from advisory residual |
| `script/systems-tcb-honesty-check.sh` | Shared token checker (validate + negatives; dual-path classic / residual_free) |
| `script/systems-residual-policy.sh` | Shared nm/IR residual regex + loads PRODUCT_STDLIB_MODULES |
| `src/lake/Lake/…` | `freestanding` lib flag + `freestandingFacet` packaging |
| `tests/lake/examples/systems/` | End-to-end **Systems Lean** example (extract + C + host proofs) |
| `tests/lake/tests/freestandingPackaging/` | Lake packaging unit tests |
| `tests/elab_fail/freestanding_*.lean` | Negative elab/import/export gates |
| `LEAN4.md` | Short pointer / design seed (see below) |
| `doc/dev/systems-lean.md` | **This document** (canonical) |

---

## Example: run the Systems Lean harness

```bash
# From lean4 root, stage1 on PATH
cd tests/lake/examples/systems
make check                # classic gates; no CompCert; no clean (smoke-equivalent)
# or: ./test.sh           # clean.sh then make check (from-scratch)
# or: make check-full     # when CompCert available (hard-requires ccomp + proof receipt)
```

The harness builds freestanding archives, links a C consumer with `-std=c11`, checks `nm` / dynamic deps, runs negative gates (double-close, UAF, non-allowlisted symbols), typechecks host specs, asserts dual-pipeline isolation, and verifies memsafe + CompCert-oriented certificate attachment.

| Makefile target | Role |
|-----------------|------|
| `make check` | Classic Systems Lean checks (**no** forced CompCert; no clean) |
| `./test.sh` | `clean.sh` then `make check` (from-scratch harness) |
| `make check-memsafe` | Embedded + sidecar certs + `verify_memsafe.lean` |
| `make check-compcert` | Optional real `ccomp` (SKIP unless REQUIRE / no ALLOW_NO) |
| `make check-compcert-negatives` | Missing extract/certs fail closed (no ccomp needed) |
| `make check-compcert-compliant` | Full 149-module / 150-TU gate; PROVABLY iff resolved ccomp under `ref/CompCert/`, else DOGFOOD |
| `make check-compcert-dogfood` | RESULT dogfood (`COMPCERT_DOGFOOD=1` only; never PROVABLY) |
| `make check-compcert-compliant-negatives` | residual/sorry/missing/REQUIRE_REF must not print success tokens |
| `./script/systems-compcert-compliant.sh` | Same gates from lean4 root |
| `make check-proof-receipt` | R4 end-to-end receipt (Lean verify + ccomp + optional nm) |
| `make check-proof-receipt-negatives` | Incomplete certs must exit ≠ 0 |
| `make check-full` | `check` + negatives + hard-require ccomp + proof receipt |

Env: `SYSTEMS_LEAN_COMPCERT_RESULT`, `SYSTEMS_LEAN_ALLOW_NO_COMPCERT=1`, `SYSTEMS_LEAN_COMPCERT_REQUIRE=1`, `SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST=1`, `SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_SELFHOST=1`. Details: harness [README](../../tests/lake/examples/systems/README.md).

### Integration smoke (elab + classic harness)

```bash
# From lean4 root, stage1 on PATH — no CompCert required
./script/systems-lean-smoke.sh
# Full matrix including CompCert + proof receipt when available:
# SYSTEMS_LEAN_SMOKE_FULL=1 ./script/systems-lean-smoke.sh
```

Runs `tests/elab/{qtt_binder_mult,qtt_use_check,qtt_formal_layer,memsafe_cert}.lean` then freestanding `make check`. Classic Lean CI never requires this script.

---

## Design discipline (do not invent)

1. **Closed fragment**, not “safe subset of all of Lean.”  
2. **Fail closed** on residual boxing / RC / Lean dynlibs.  
3. **Affine + explicit drop** before full linear IR or lifetime polymorphism.  
4. **No implicit global allocator** — pass arenas / capabilities.  
5. **No dual semantic engines** (hand-written C as SSOT) for the product core.  
6. Prefer **ownership guarantees** over Rust syntax/feature parity.

---

## QTT multiplicities (Idris 2–class, freestanding)

Systems Lean freestanding embeds **quantitative type theory multiplicities** (as in Idris 2):

| Qty | Meaning | Freestanding default |
|-----|---------|----------------------|
| **0** | Erased — proofs/types only; **no runtime residual** in product C | sorts / Prop / `@[erased]` |
| **1** | Linear — use **exactly once** (free-safety) | `@[affine]` / `@[linear]` resources |
| **ω** | Unrestricted — free copy/drop | scalars / ordinary data / `@[unrestricted]` |

Algebra: `1+1=ω`, `0*q=0`, `0≤1≤ω`. Enforced at **elaboration** (`QTT.UseCheck`) and on the
freestanding **LCNF** path (`AffineCheck` + `Multiplicity`). Core algebra:
`src/Lean/Compiler/Multiplicity.lean`.

### Binder multiplicities (every binder under QTT)

When `compiler.freestanding` or `compiler.qtt` is on, lookup always assigns each binder a
multiplicity **0**, **1**, or **ω** (defaults fill in; no binder is “unclassified”):

| Mechanism | Role |
|-----------|------|
| Type defaults (pure / LCNF) | Attrs (`@[affine]`/`@[linear]`/…) → 1; `Prop` const / sorts / **`lcErased`** → 0; else ω |
| Meta elab defaults | Same as pure, plus `isProp` → 0 for Prop-valued types (e.g. `True`, `n = n`) |
| Explicit mdata | `annotateMult m type` stores `qtt.mult`; overrides defaults **when present on the type** |
| Lookup API | Pure: `getBinderMult` / `getBinderMultOfType`. Meta: `getLocalBinderMult` / `multOfLocalType` |
| Introduce helpers | `withQttLocalDecl` / `withQttLetDecl` / `forallTelescopeQtt` write explicit mdata under QTT |

### Elaborator use rules (Idris-class, R2)

When `isQttMode` (`compiler.freestanding` **or** `compiler.qtt`), `checkQttUses` walks elaborated
terms (Meta) with a remaining-multiplicity map:

| Rule | Behavior |
|------|----------|
| Linear (**1**) | Each runtime use **consumes** once; **double-use** and **silent drop** are errors |
| Unrestricted (**ω**) | Free copy / drop |
| Erased (**0**) | Must not appear in a **runtime** argument / value position |
| Application | Runtime args consume nested uses; binder mult **0** positions skip consume |
| `@[fs_borrow]` | Callee **borrows** linear args (use without consume); enclosing `@[fs_borrow]` params may remain at exit — **borrow ≠ consume** (not RC `@&`) |
| Control-flow **split** (recognized only) | `ite`/`dite` (alts after type+condition+`Decidable`); `cond` (after type+Bool); freestanding `bif*` (after Bool); `I.casesOn` via `InductiveVal` params/indices/major; registered **matchers** via `MatcherInfo` |
| Merge | Paths must agree on **outer** linear remainders only (λ/let locals inside arms are forgotten before merge) |

**Match / residual (honest):** elaborated `match` that lowers to a **registered matcher** is split using matcher arity. **Unrecognized multi-arm CF** (raw `.rec` / `.recOn` / `.brecOn` / sparse casesOn) is **fail-closed** (error) — never silent sequential consume. AffineCheck still owns freestanding regions / UAF on extract.

**Production hook:** `Elab.PreDefinition` runs `checkQttUsesDecl` on definition values under
`isQttMode` (theorems / Prop-valued decls skipped). Public Meta API: `Lean.Compiler.QTT.checkQttUses`.

**Elab vs LCNF (honest):**
- Elab use-check covers double-use, drop, 0-qty runtime leak, borrow, let-bound linears,
  `borrowTopParams` / `@[fs_borrow]`, and the splitter table above; introduce helpers still
  opt-in for explicit mdata (defaults alone classify mult without mdata).
- `toLCNFType` / ToLCNF **drop most mdata** and rewrite propositions to `lcErased`. AffineCheck
  therefore enforces via **`getBinderMultOfType`** on LCNF types: attrs, `lcErased` → 0, and
  any surviving mdata — plus freestanding region stamps.
- Classic Lean (`compiler.freestanding` and `compiler.qtt` both **false**): helpers and
  `checkQttUses` are no-ops; AffineCheck is a no-op; no new failures.
- **Depth residual (honest):** Mult algebra tables are finite/definitional; UseCheck is **not**
  full elaborator-surface completeness. Covered surface is what `tests/elab/qtt_use_check.lean`
  + `systems-qtt-depth-check.sh` pin (incl. letE once / silent-drop / double-use, borrowTopParams,
  pure-fvar path-merge, bif* allowlist, fail-closed multi-arm CF incl. `noConfusion` / named
  `WellFounded.fix`·`fixF` / `Quot.lift`·`ind`·`liftOn`). Still **not** a completeness proof of every elaborator
  surface (e.g. all matchers, nested introduces, full attribute interaction matrix); remaining
  named multi-arm residuals stay allowlist-enforced and fail-closed when unrecognized.

See `src/Lean/Compiler/QTT/ElabCheck.lean`, `QTT/UseCheck.lean`, `LCNF/AffineCheck.lean`,
`tests/elab/qtt_binder_mult.lean`, `tests/elab/qtt_use_check.lean`.

## Memory-safety certificates (freestanding C)

Every successful freestanding extract that emits consumer C is **sealed** with:

1. **`SYSTEMS_LEAN_MEMSAFE_CERT`** (v2) — full freestanding memory safety **including QTT 0-quantity
   erasure** and linear resource exact-once use (Rust/Idris-class free-safety claims).
2. **`SYSTEMS_LEAN_COMPCERT_MEMCERT`** — CompCert-oriented formal layer (Clight-style block ownership
   claims) that **requires** a valid memsafe cert first. This is **not** a full CompCert verified
   compiler proof; it is a machine-checkable, CompCert-aligned obligation certificate.

| Property | Behavior |
|----------|----------|
| Universal coverage | `emitC` freestanding: `MemSafetyCert.sealCertificate` then `CompCertCert.sealCompCert` |
| QTT 0-qty | Claim `qtt_zero_quantity_erased` required on parse |
| Independent check | Re-hash, re-scan, re-check signatures; CompCert layer re-verifies memsafe first |
| Sidecars | `*.c.memsafe.cert` and `*.c.compcert.memcert` |
| Dogfood | Harness `check-memsafe` |

Implementation: `MemSafetyCert.lean`, `CompCertCert.lean`. Tests: `tests/elab/memsafe_cert.lean`.

**Soundness note:** certificates **assert** freestanding+QTT memory-safety claims and are independently
**checkable**. CompCert-oriented certs are formal *obligation* artifacts aligned with CompCert’s
memory-model vocabulary — not a drop-in replacement for CompCert’s verified compilation theorems.
Libc contracts and dual-param length respect at C call sites remain residual assumptions.

### Formal correctness layer (proved / assumed / CompCert)

Honest split of the freestanding extract + cert + optional CompCert pipeline. **We are not CompCert.**

| Layer | **Proved** (in-tree Lean / harness) | **Assumed** (residual) | **CompCert’s responsibility** |
|-------|-------------------------------------|------------------------|-------------------------------|
| QTT mult algebra `0/1/ω` | Private definitional lemmas in `Multiplicity.Theorems` (same module as algebra: full 3×3 add/mul tables, full 3³ assoc/left-right distrib via `rfl`, discard/useOnce, …) witnessed by public marker `algebraChecked`; `QTT.Theorems` re-exports that marker. **P4 / D4 formal depth:** definitional mult algebra is product-greppable via G2 `systems-linear-residual-metrics.sh` (`algebraChecked` + full tables); finite Mult tables = **100% definitional** for the 0/1/ω carrier — **not** elaborator surface completeness | Kernel/typechecker correctness; elaborator `UseCheck` coverage of all surface syntax | — (not CompCert) |
| Free-safety / linear exact-once + 0-qty | **Definitional Mult algebra + host policy markers** (not residual_nm/residual_ir): `Multiplicity.Theorems.freeSafetyChecked` + `productResidualMultPolicyChecked` (0-qty non-runtime, zero mul annihilates incl. 0*0, linear second-use impossible); joint host marker `QTT.FreeSafety.freeSafetyFormalLayerChecked` ties those to MemSafetyCert claim inventory (`qtt_linear_resources_exact_once`, `qtt_zero_quantity_erased`, `qtt_omega_unrestricted_scalars`). Affine/partition names are **caller-contract linear policies** only — listed under Assumed for ownership/points-to. **G2 greppable metrics:** `systems-linear-residual-metrics.sh` / validate `GATE linear_metrics` re-check these source markers (tokens `LINEAR_SECOND_USE_IMPOSSIBLE`, `MULT0_NON_RUNTIME_POLICY`, `PRODUCT_RESIDUAL_MULT_POLICY`, …); mult-policy greps only — **not** elaborator completeness, **not** `GC_FREE_ELABORATOR=1`. **Track D UseCheck depth (separate):** `systems-qtt-depth-check.sh` / `GATE qtt_depth` greps pure-fvar same-fvar exclusive consume + distinct pure-fvar path-merge residual and freestanding `bif*` ⊆ `splitterLayout?` (tokens `QTT_USECHECK_DISTINCT_PURE_FVAR`, `QTT_SPLITTER_BIF_COMPLETE`, `QTT_DEPTH_OK`); surface residual hardening — **not** Mult algebra tables and **not** full elaborator completeness | Completeness of `UseCheck` / `AffineCheck` vs all surface; ISO C memory safety of emission; points-to / separation ownership; residual_nm/residual_ir (separate validate gates) | — (not CompCert) |
| Affine / region LCNF gate | Checker rejects double-free, silent drop, UAF on dogfood negatives (`check-gates`) | Completeness vs all Lean surface; residual control-flow shapes | — |
| MemSafetyCert | Independent `verifyEmbedded`: digest, forbidden-pattern scan, required claim lines (incl. `qtt_zero_quantity_erased`), signature; claim inventory typechecks | That Lean gates imply full ISO C memory safety of the emission; libc contract fidelity at call sites | — |
| CompCertCert | `verifyEmbedded` requires valid MemSafetyCert first; claim inventory (Clight-style obligations) typechecks | Same residual as memsafe; cert is an *obligation* artifact, not a Clight proof object | — |
| Pure C for `ccomp` | Footers stripped; harness fails closed on missing certs | Pure C matches ISO / CompCert C subset beyond what dogfood TUs exercise | Accept/reject C text; compile to asm/object |
| Real `ccomp` | Harness records version + objects when `ccomp` succeeds (`out/compcert/proof-receipt.txt`) | Host/nix packaging of CompCert binary | **Verified C→asm compilation** for the pure TUs it accepts (CompCert’s theorems — not re-proved here) |
| End-to-end proof receipt | `script/systems-proof-receipt.sh` / `make check-proof-receipt`: markers ∧ Lean verify ∧ `ccomp` ∧ optional nm; exit ≠ 0 on any required miss | Full FS elaborator / Init under FS (R7); host elaborator still classic | Only the `ccomp` leg |

Tests: `tests/elab/memsafe_cert.lean`, `tests/elab/qtt_formal_layer.lean`, freestanding `check-memsafe`, `check-compcert(-negatives)`, `check-proof-receipt(-negatives)`.

### CompCert dogfood (real `ccomp`, optional)

Lean’s CompCert-oriented **certificate** is not CompCert itself. The freestanding harness can
additionally run a **real** CompCert compile on sealed freestanding C (Systems Lean only — classic
Lean builds never require this).

| Item | Detail |
|------|--------|
| Script | `tests/lake/examples/systems/check_compcert.sh` |
| Targets | `make check-compcert` (optional), `make check-full` (classic checks + hard-require ccomp + proof receipt), `make check-compcert-negatives` |
| Proof receipt | `script/systems-proof-receipt.sh` → `make check-proof-receipt` (Lean `verifyEmbedded` + ccomp + optional nm); negatives: `make check-proof-receipt-negatives` |
| Default `make check` | **No** CompCert dependency (optional note only) |
| Inputs | Freestanding IR after Lake build: `Extract.c`, and when present `Systems/{Scalars,Sys}.c` |
| Preconditions | Embedded `SYSTEMS_LEAN_MEMSAFE_CERT`, `qtt_zero_quantity_erased`, and `SYSTEMS_LEAN_COMPCERT_MEMCERT` |
| Pure C | Certificate footers stripped; clang/GCC diagnostic pragmas stripped for a clean CompCert TU |
| Artifacts | `out/compcert/*.{pure.c,o}`, optional `.s`, `ccomp.log`, `ccomp-version.txt`, `proof-receipt.txt`; full receipt `out/proof-receipt-full.txt` |
| Fail closed | Missing extract, missing certs, Lean verify fail, or ccomp reject → hard error (exit ≠ 0) |

**How to get CompCert** (Nix + unfree; no new Cachix required):

```bash
# From lean4 root
export NIXPKGS_ALLOW_UNFREE=1
nix build --impure --expr "
  let flake = builtins.getFlake \"$PWD\";
      pkgs = import flake.inputs.nixpkgs {
        system = builtins.currentSystem; config.allowUnfree = true;
      };
  in pkgs.compcert
" -o result-compcert
export SYSTEMS_LEAN_COMPCERT_RESULT="$PWD/result-compcert"
# Prefer nix shell / SYSTEMS_LEAN_COMPCERT_RESULT over bare host PATH ccomp.
# The harness unsets LD_LIBRARY_PATH for nix ccomp (host lib paths segfault wrappers).
```

Alternatively, if `ccomp` is already on `PATH` and works (`ccomp -version`), the harness uses it as a
last resort after nix result / flake `pkgs.compcert`.

Env: `SYSTEMS_LEAN_COMPCERT_RESULT` (preferred store result), `SYSTEMS_LEAN_ALLOW_NO_COMPCERT=1`
(skip with note — **not** dogfood success), `SYSTEMS_LEAN_COMPCERT_REQUIRE=1` (used by
`make check-full` to forbid skip).

This is **dogfood**: freestanding emit C is accepted by CompCert’s compiler on the harness TUs. It is
**not** a claim that Lean’s elaborator or the whole stage1 toolchain is CompCert-verified end-to-end.

### Provably CompCert compliant (simple → formal)

**Simple rule (scoped).** For the freestanding **full product TU matrix** (**150 TUs** today = Extract + **149** PRODUCT_STDLIB modules; authoritative list = `script/systems-product-stdlib-modules.txt`):

* `Extract.c`
* `Systems/<each PRODUCT_STDLIB module>.c` (do not invent names; incomplete prose lists must defer to `script/systems-product-stdlib-modules.txt`)
* `Systems/Parallelism/{Simd,ForkJoin,Channel}.c`

if Systems Lean shows **ResidualFree** (nm + IR greps; **every** listed companion hard-required), ComplianceCorpus is **sorry-free** and **axiom-auto** (allowlisted / no unlisted Lean `axiom`), sealed certs **verify**, and real **`ccomp` accepts** the pure stripped TUs, then:

| Token | Condition |
|-------|-----------|
| `PROVABLY_COMPCERT_COMPLIANT=1` | All conjuncts green **and** resolved `ccomp` path is under **`ref/CompCert/`** (in-tree submodule build). |
| `COMPCERT_DOGFOOD=1` | All conjuncts green with RESULT/nix/PATH, **or** `./ref` discovery whose resolved binary is **outside** `ref/CompCert/` (launcher → nix). |

**Discovery under `./ref` is not enough for PROVABLY.** Receipt records `ccomp-path` (discovery) and `ccomp-resolved` (effective binary).

We are **not** CompCert. Lean owns residual-free emit and ownership/QTT obligations; CompCert owns verified C→asm for the pure TUs it accepts. Dual flakes (`packages.lean` + `packages.systems-lean`) are **shipped**; neither requires CompCert.

| Label | Success token | ccomp source | Meaning |
|-------|---------------|--------------|---------|
| **CompCert dogfood** | `COMPCERT_DOGFOOD=1` | RESULT / nix / PATH, **or** `./ref` launcher → nix | Conjuncts hold on **149-module / 150-TU** matrix; **not** PROVABLY |
| **CompCert-oriented sealed** | (none) | n/a | MemSafety + CompCert certs verify; may still have residual holes |
| **Provably CompCert compliant** | `PROVABLY_COMPCERT_COMPLIANT=1` | **Resolved** under **`ref/CompCert/`** | ResidualFree ∧ SorryFree ∧ AxiomAuto ∧ ProductStdlib ∧ CertsVerify ∧ CcompAccepts on full **149-module** product matrix (**150** TUs with Extract) |

**Gate from lean4 root:**

```bash
# Product built; stage1 on PATH. Prefer in-tree ccomp for PROVABLY (see ref/README.md).
export PATH="$PWD/build/release/stage1/bin:$PATH"
./script/systems-compcert-compliant.sh
# or: make -C tests/lake/examples/systems check-compcert-compliant
# Success tokens (exactly one greppable line; never on failure):
#   PROVABLY_COMPCERT_COMPLIANT=1   — only if ccomp-resolved ∈ ref/CompCert/
#   COMPCERT_DOGFOOD=1              — product green with dogfood ccomp (incl. honest ./ref launcher→nix)
# Receipt: tests/lake/examples/systems/out/compcert/compliant-receipt.txt
```

**Explicit RESULT dogfood (never PROVABLY):**

```bash
export SYSTEMS_LEAN_COMPCERT_RESULT=$PWD/result-compcert   # or nix build -o result-compcert …
SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 ./script/systems-compcert-compliant.sh
# or: make -C tests/lake/examples/systems check-compcert-dogfood
# Success line: COMPCERT_DOGFOOD=1
```

| Conjunct | Gate | Scope |
|----------|------|--------|
| **ResidualFree** | `systems-selfhost-link-check.sh` + IR greps | Bundle nm + **all 149 product modules** (hard-require companions) |
| **SorryFree** | `systems-sorry-free-check.sh` | `script/systems-compliance-corpus.txt` |
| **AxiomAuto** | `systems-axiom-check.sh` | ComplianceCorpus vs `systems-tcb-axiom-allowlist.txt` (`AXIOM_AUTO_GATE_OK=1`) |
| **ProductStdlib** | `systems-product-stdlib-check.sh` | PRODUCT ⊆ corpus (`PRODUCT_CORPUS_ALIGN_OK=1`, membership) + MODULES_OK (sources/allowlist/…) |
| **CertsVerify** | claim markers + Lean `verifyEmbedded` | **Same 149-module matrix** |
| **CcompAccepts** | `check_compcert.sh` | **Same 149-module matrix**; pure stripped TUs only |
| **Receipt** | `out/compcert/compliant-receipt.txt` | **This-run** TUs/objects + `ccomp-path` / `ccomp-resolved` |

**Residual IR RE** (single-source `script/systems-residual-policy.sh`, aligned with `check-ir`):  
`lean_object|lean_inc|lean_dec|lean_alloc|initialize_|lean_io_|lean_ctor|lean_apply|lean/lean.h`

Discovery: `./ref` → `SYSTEMS_LEAN_COMPCERT_RESULT` → `result-compcert` → flake `pkgs.compcert` → PATH.  
Default compliant script: **`REQUIRE_REF=1`** for discovery under `./ref` (fail closed as **tool discovery** if missing). Token choice still uses **resolved** path under `ref/CompCert/` for PROVABLY.

ComplianceCorpus: `script/systems-compliance-corpus.txt`.  
TCB axioms: `script/systems-tcb-axiom-allowlist.txt` (**auto-gated** via `systems-axiom-check.sh` / `GATE axiom_auto`). **Scope = ComplianceCorpus only** (not a full freestanding tree walk). **B1 pins:** low-churn freestanding modules use explicit `path name=Ident` pins (Bytes, Numerics, Mem, BitOps, Hash, Map, Set, Queue, Vector, Sort, Crc, BinarySearch, Deque, Stack, Ascii, MemRegion, Parse, RingBuf, Fmt, List, Path, Hex, Utf8, Tree, Json, Base64, Graph, Regex, Url, ArenaPool, Ini, Csv, Bloom, Toml, Xml, SkipList, Yaml, Http, BTree, Dns, Sexp, Avl, Md, Icmp, RbTree, Pem, Ntp, Trie, Jwt, Dhcp, BinaryHeap, Uuid, Arp, IntervalTree, Semver, Gre, Splay, Cbor, Ip, BTreeMap, TomlQuery, Udp, SkipListMap, Edn, Tcp, HashMap, MsgPack, Icmpv6, LinkedHashMap, Protobuf, Sctp, OrderedMap, Avro, Dccp, TreeMap, Capnp, Quic, FlatBuffers, Mqtt, RadixTree, Asn1, Coap, YamlQuery, WebSocket, BitMap, Lz4, Socks5, Snappy, Rtsp, Zstd, Sip, Brotli, NtpQuery, Ogg, Smtp, BitSetMulti, Webm, Pop3, Roaring, Matroska, Imap, IntervalSet, Flac, Nntp, Ldap, Vorbis, Radius, OrderedU32Set, Diameter, SctpCommon, M3ua, Sua, Iua, V5ua, H248, Megaco, Mgcp, Sdp, Rtcp, Stun, Turn, Ice, Rtp, Srtp, Srtcp, Dtls, Tls, Ipsec, DepGraph, Trace, TomlConfig, Proc, Manifest, CacheIndex, L2tp, Pptp, L2f, Ppp, Hdlc, Parallelism/*; BitSet has no local axioms) so a new axiom under those paths fails closed; greppable `AXIOM_ALLOWLIST_NAME_PIN_COUNT` / `AXIOM_ALLOWLIST_PATH_ONLY_COUNT`. Dual path-only + `name=` for the same path is rejected. Orphan `name=` pins (pin without a source axiom) are intentional one-way. **INTENTIONAL_TCB_PATH_ALLOW** remains path-only for dense high-churn FFI (`Scalars`, `Sys`) — new axioms there are intentional TCB growth (does not require `@[extern]`). Unlisted axioms in any corpus file fail closed. **B2 PRODUCT ↔ corpus:** `systems-product-stdlib-check.sh` requires every PRODUCT_STDLIB module on ComplianceCorpus (`PRODUCT_CORPUS_ALIGN_OK=1` = **membership only**) and, separately, allowlist coverage for PRODUCT modules that declare axioms (coverage failures set `PRODUCT_STDLIB_MODULES_OK=0` even when ALIGN stays 1). CompCert compliant / PROVABLY also requires ProductStdlib (both MODULES_OK and ALIGN). Kernel / CompCert / libc trust remain **implicit** TCB (not proved by this gate).

**Only** when the compliant gate exits 0 and prints `PROVABLY_COMPCERT_COMPLIANT=1` may docs or CI claim **provably CompCert compliant** for that product matrix. `COMPCERT_DOGFOOD=1` is a weaker label (product green, not in-tree CompCert build).

### QTT / control-flow allowlist (honest residual)

Path-merged splitters under `compiler.freestanding` / `compiler.qtt` (`QTT.UseCheck`):

| Allowed splitter | Notes |
|------------------|--------|
| `ite` / `dite` / `cond` | Full elaborator apps |
| freestanding `bif*` | `bifU32`, `bifU64`, `bifUSize`, `bifBool`, `bifU8`, `bifArena`, `bifMMap` (SSoT: `UseCheck.splitterLayout?`; gated by `systems-qtt-depth-check.sh`) |
| `I.casesOn` | Via `InductiveVal` layout |
| registered matchers | `Match.MatcherInfo` |

Product extract code should stick to this surface + recursive helpers. LCNF `AffineCheck` enforces regions/UAF on freestanding. Classic Lean (both options false) is a no-op.

**Fail-closed (not sequential-consumed):** raw `.rec` (incl. `Acc.rec`), non-`casesOn` aux recursors (`.recOn` incl. `Acc.recOn` / `.brecOn` / `Eq.ndrec*` / `HEq.recOn`), sparse casesOn / ctor-elims (incl. `Lean.Literal.strVal.elim` / `Lean.Literal.natVal.elim` / `Lean.Name.str.elim` / `Lean.Name.num.elim`), `noConfusion`, `WellFounded.fix`/`fixF`, `Quot.lift`/`ind`/`liftOn` (elab-exercised in `qtt_use_check.lean`). Remaining residual: not every exotic surface shape is product-ready; stick to the allowlist rather than inventing custom multi-arm CF.

## Known limitations (honest residual list)

- Freestanding is still an **opt-in** Lake lib / compiler mode, not the default Lean experience.  
- Control-flow on the extract path is a **restricted allowlist** (`bif*` / recognized `if`/`match`/`casesOn`; loops often use recursive helpers that lower to C locals).  
- Multi-field freestanding **values** are avoided (dual C params / sequential APIs).  
- Host proofs remain **optional correspondence / models** for dual-pipeline specs; they are separate from per-emission memory-safety certificates on freestanding C.  
- Packaging expands freestanding libs listed on Lake `needs` (not every import edge automatically).  
- Prefer `freestanding.bundle` for consumers; the multi-path `freestanding` facet remains for tooling.  
- Certificate checker soundness vs full ISO C is **not** CompCert-class (see soundness note above); attachment + independent check for **all** freestanding-generated C **is** required.  
- **R6 product path done; elaborator still classic:** `lean-systems` + nm gate cover freestanding **product** objects without GC dynlibs. Link-check emits `PRODUCT_GC_FREE=1` / `PRODUCT_NO_LEANSHARED=1` on nm residual success; validate `GATE product_gc_free` (scoreboard authoritative) additionally requires residual_ir. `GATE residual_nm` alone is nm residual only — not a product GC-free claim. Never elaborator GC-free. Host elaboration still uses stage1 `lean` + `libleanshared` ([systems-lean-selfhost.md](systems-lean-selfhost.md)).  
- **R7 product path done; module ports ongoing:** inventory + FS surface (Scalars/Sys/Bytes/Numerics/Status/Mem/BitOps/Hash/ByteSpan/Map/BitVec/Set/Queue/Vector/Sort/Crc/String/BinarySearch/Deque/Stack/Ascii/MemRegion/BitSet/Parse/RingBuf/Parallelism.*) + `systems-stdlib` path. P2 grew PRODUCT_STDLIB with ByteArray/HashMap/BitVec/HashSet/Queue/Vector/Sort/CRC/String/search/deque-**shaped** freestanding ports (not full Init parity — no managed `ByteArray`/`Std.HashMap`/`BitVec`/`HashSet`/`Array`/`String`). Not every Init file is freestanding.  
- **CompCert tokens:** `PROVABLY_COMPCERT_COMPLIANT=1` requires **resolved** `ccomp` under `ref/CompCert/` on the full product TU matrix. A `./ref` launcher that only execs nix/RESULT yields **`COMPCERT_DOGFOOD=1` only**. Not a claim that Lean’s elaborator is CompCert-verified end-to-end.  
- **TCB axiom auto-gate shipped** (`systems-axiom-check.sh`, validate `GATE axiom_auto`, CompCert `AxiomAuto`); walks **ComplianceCorpus only**. **B1:** name-level pins on low-churn freestanding residual; path-only **INTENTIONAL_TCB_PATH_ALLOW** only for dense `Scalars`/`Sys` FFI; dual path+name rejected. **B2:** PRODUCT ⊆ corpus membership (`PRODUCT_CORPUS_ALIGN_OK=1`, membership only) + PRODUCT axiom allowlist coverage (`PRODUCT_STDLIB_MODULES_OK`); CompCert `ProductStdlib` conjunct requires both. Does **not** prove kernel/CompCert correctness.  
- **TCB honesty gate shipped (P5)** (`systems-tcb-inventory.sh`, shared `systems-tcb-honesty-check.sh`, validate `GATE tcb_honesty`, negatives `systems-tcb-inventory-negatives.sh`). Inventory emits measured host residual (`HOST_ELABORATOR_TCB`, `HOST_ELABORATOR_RESIDUAL`, `GC_FREE_ELABORATOR`, optional `HOST_HAS_LEANSHARED`), `PRODUCT_EMBED_TCB=residual_free_goal`, `TCB_HONESTY_OK=…`, and curated `PRODUCT_FS_NEXT=…` (planning backlog only — **not** required by validate, **not** automatic PRODUCT_STDLIB growth). Validate PASS needs inventory exit 0 + dual-path honesty (classic `GC_FREE=0` or earned residual_free `GC_FREE=1` with evidence) + exactly one `TCB_HONESTY_OK=1` (no dual `=0`); does **not** require `SYSTEMS_LEAN_TCB_REQUIRE=1`. Classic stage1 defaults unchanged.  
- **G2 linear residual metrics shipped** (`systems-linear-residual-metrics.sh`, validate `GATE linear_metrics`, negatives `systems-linear-residual-metrics-negatives.sh`). Greps Multiplicity/FreeSafety **source** markers (`linear_exact_once_second_use`, `zero_qty_*`, `productResidualMultPolicyChecked`, `freeSafetyFormalLayerChecked`, silent-drop `mayDiscard .one = false`, `algebraChecked` mult tables) and emits scoreboard tokens only after checks pass. **Not** elaborator UseCheck completeness; **not** `GC_FREE_ELABORATOR=1`; **not** residual_nm/ir emission.  
- **Track D QTT UseCheck depth shipped** (`systems-qtt-depth-check.sh`, validate `GATE qtt_depth`, negatives `systems-qtt-depth-check-negatives.sh`, proof-receipt gate 8). Greps UseCheck pure-fvar residual (same-fvar exclusive consume; distinct pure-fvar → `mergeStates`) and freestanding `bif*` ⊆ `splitterLayout?` allowlist; tokens `QTT_USECHECK_DISTINCT_PURE_FVAR`, `QTT_SPLITTER_BIF_COMPLETE`, `QTT_DEPTH_OK`. **Distinct from Mult algebra** (definitional tables = finite 100%; UseCheck depth = surface residual hardening). **Not** full elaborator completeness; **not** `GC_FREE_ELABORATOR=1`.  

- **G3 host elaborator residual measurement shipped (staged)** (`systems-host-elaborator-residual.sh`, validate `GATE host_elaborator`, negatives `systems-host-elaborator-residual-negatives.sh`). Measures real lean binary for `leanshared`/`Init_shared`: residual_free earn requires successful **readelf and/or objdump** NEEDED (ELF magic independent of readelf; multi-scanner agreement when both); **ldd alone never earns** (ldd+shared → classic; ldd+clean → unmeasured). Scoreboard emits measured `HOST_HAS_LEANSHARED`, `HOST_ELABORATOR_RESIDUAL`, `GC_FREE_ELABORATOR`, `HOST_ELABORATOR_RESIDUAL_OK`. Stage1 today → `GC_FREE_ELABORATOR=0` + classic residual (**PASS** for staged G3). `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without evidence → FAIL. Dual path vs product `PRODUCT_GC_FREE`. **Full elaborator without GC still not claimed** while stage1 links shared runtime. Next steps: keep measuring; optional freestanding host driver that drops shared NEEDED under readelf/objdump; optional nm RC-def bar on that driver.  
- **Three-Layer Cake L1–L3 freestanding modules shipped** (`Systems.Parallelism.{Simd,ForkJoin,Channel}`): product path is **sequential** residual-free / ccomp-green (`lean_fs_par_l2_backend` → `0`). L1 adds SIMD-**shaped** chunked-4 map (not hardware SIMD on product; non-overlapping range contract). L2 opt-in pthread is a separate hand C TU (`par_pthread.c`), linked only by `make check-par-pthread` with **compile define** `-DSYSTEMS_LEAN_PAR_PTHREAD=1` and `-pthread` — not an env var and not on the residual/ccomp product matrix. L3 adds try-send/recv (+ null/null-out statuses) and dual-payload sequential rendezvous; still no RC queue / no OS threads on product.  
- **Track C dual-path (C1–C4) shipped:** product isolation gate `script/systems-par-dual-path-check.sh` (validate freestanding_check + negatives) emits `PRODUCT_PARALLELISM_L2_SEQUENTIAL=1`, `PRODUCT_PARALLELISM_NO_PTHREAD=1`, `PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1`, `CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1`, `PARALLELISM_DUAL_PATH_OK=1` (primary-only; no `PAR_*` / `PRODUCT_PAR_*` aliases). Opt-in host dogfood: `make -C tests/lake/examples/systems check-par-pthread` (L2 pthread backend id `1`) and `make check-par-simd-hw` (`par_simd_hw.c` SSE2 or portable scalar fallback; export `lean_fs_par_map_add_u8_simd_hw`). Default `make check` requires product isolation only — **not** pthread/HW dogfood. **Honest concurrent residual:** pthread/HW paths are **assumed host dogfood**, not a formal concurrent memory model or CompCert-proved product residual.  
- **Track F tooling / docs / CI honesty shipped:** inventory SSoT via `./script/systems-stdlib-inventory.sh --write` (live `fs-ready=149` = PRODUCT_STDLIB **149** / **150** TUs with Extract; Phase B1 HeapLite-farm delete; Phase B2 V*Lite header-toy delete; Phase B3 magic codec toy delete; Phase C ordered-leaf `*SetLite` delete); optional `--require` fails on doc or PRODUCT drift; fast `./script/systems-status.sh`; **`systems.nix` front door** (`nix develop .#systems`, `nix build .#checks.<sys>.systems-light`); opt-in GitHub workflow [`.github/workflows/systems-lean.yml`](../../.github/workflows/systems-lean.yml) prefers the flake light check (`workflow_dispatch` + `systems` branch path filters only — **does not** modify classic `ci.yml`).  
- Dual flakes (`lean` + `systems-lean`) are **shipped**; classic is flake `default`.  
- Work is formalized on this branch as usable freestanding product quality, not a GC-free elaborator or CompCert-verified Lean compiler.

### Roadmap residual (after G / A–D / F)

Still **not claimed** / backlog after shipped G1–G3, Tracks A–D, and Track F:

| Residual | Status |
|----------|--------|
| GC-free elaborator (`GC_FREE_ELABORATOR=1`) | **Not earned** — stage1 still NEEDs classic shared RC runtime; G3 measures only |
| Full Init/Std under freestanding | **Not a goal of product path** — PRODUCT is **shaped** Systems (149 modules / 150 TUs with Extract), not Init parity |
| Verified concurrent runtime / memory model | **Assumed host dogfood only** (`CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1`) |
| Product residual HW SIMD on ccomp matrix | Host `check-par-simd-hw` only; not product residual/ccomp TU |
| Fuller FS ports (`PRODUCT_FS_NEXT`) | Curated backlog: `H5_host,TomlConfig_more89,Slake_parity_more` (**no** Track L +3 packing; W153 shipped more88; see [systems-naming.md](systems-naming.md)) |
| Product naming | Plain names; legacy `Lite` drained deliberately; nonsense clone farms frozen then deleted | **Phase A shipped** — [systems-naming.md](systems-naming.md); `FS_READY` may fall on cleanup |
| Freestanding host driver without `leanshared` | Optional future residual reduction under readelf/objdump |
| CompCert-verified elaborator / full Lean compiler | **Never claimed** — product pure C TUs only |

---

## History / design seed

The original freestanding design note lived as repo-root `LEAN4.md` (beastdb Option E / R7-RT style goals). That content is incorporated here. `LEAN4.md` remains a short pointer to Systems Lean for external design seeds.

---

## See also

- Example harness: [`tests/lake/examples/systems/README.md`](../../tests/lake/examples/systems/README.md)  
- Integration smoke: [`script/systems-lean-smoke.sh`](../../script/systems-lean-smoke.sh)  
- Proof receipt: [`script/systems-proof-receipt.sh`](../../script/systems-proof-receipt.sh)  
- Provably CompCert compliant: [`script/systems-compcert-compliant.sh`](../../script/systems-compcert-compliant.sh) / `make check-compcert-compliant`  
- Self-host product path (R6): [systems-lean-selfhost.md](systems-lean-selfhost.md) / [`script/systems-selfhost.sh`](../../script/systems-selfhost.sh) / [`script/lean-systems`](../../script/lean-systems)  
- Stdlib inventory + R7 product path: [systems-lean-stdlib-inventory.md](systems-lean-stdlib-inventory.md)  
- Prelude sources: [`src/Systems/`](../../src/Systems/)  
- Nix package: [`flake.nix`](../../flake.nix) / [`nix/systems-lean.nix`](../../nix/systems-lean.nix) (`nix eval` / `nix build .#systems-lean`)  
- Design seed pointer: [`LEAN4.md`](../../LEAN4.md)  
- Development setup: [index.md](index.md)  
- FFI background (classic Lean): [ffi.md](ffi.md)  
- **Fork research (optional):** correspondence / extract-and-run vs freestanding TCB — [research/2026-07-20-keagan-correspondence.md](research/2026-07-20-keagan-correspondence.md) (analysis only; not residual backlog)  

