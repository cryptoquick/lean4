# Self-Hosted Systems Lean & full FS stdlib

**Status (R6):** **done for the product self-host path** on the `systems` branch — usable `lean-systems` driver, freestanding product build, and fail-closed nm gate (no Init_shared / leanshared / lean_inc on product objects). Classic Lean remains the default; nothing here is required for existing users.

**P5 / TCB honesty (shipped):** `script/systems-tcb-inventory.sh` + validate `GATE tcb_honesty` make host elaborator vs product embed TCB greppable. See [systems-lean.md](systems-lean.md) honesty bullets.

**B1–B2 / TCB axiom pins + PRODUCT corpus align (shipped):** name-level `path name=Ident` pins on low-churn freestanding residual (`systems-tcb-axiom-allowlist.txt`); path-only **INTENTIONAL_TCB_PATH_ALLOW** only for dense `Scalars`/`Sys`; dual path-only+`name=` rejected. `PRODUCT_CORPUS_ALIGN_OK=1` means PRODUCT ⊆ ComplianceCorpus **membership only** (not name-pin completeness). Allowlist coverage for PRODUCT modules that declare axioms is separate (`PRODUCT_STDLIB_MODULES_OK`). CompCert compliant / PROVABLY requires both.

**G1 / product GC-free tokens (shipped):** `systems-selfhost-link-check.sh` emits `PRODUCT_GC_FREE=1` and `PRODUCT_NO_LEANSHARED=1` **only** after **nm residual success** (not IR). Validate `GATE product_gc_free=PASS` requires residual_nm ∧ residual_ir ∧ those tokens from the residual_nm transcript (scoreboard stdout is authoritative; not greppable tokens alone). Inventory mirrors product GC tokens only after a full nm residual scan aligned with link-check (undef + shared + defined RC); unscanned → `=0`. Negatives reject success tokens on FAIL cases. **Product `PRODUCT_GC_FREE` is not host elaborator GC-free.**

**G2 / linear residual metrics (shipped):** `systems-linear-residual-metrics.sh` greps Multiplicity/FreeSafety mult-policy **source markers** (exact-once second-use impossible, mult-0 non-runtime, `productResidualMultPolicyChecked`, silent-drop policy, `algebraChecked`) and emits `LINEAR_*=1` / `MULT0_*=1` / `PRODUCT_RESIDUAL_MULT_POLICY=1` only after checks pass. Validate `GATE linear_metrics=PASS` is core integrity. These are mult-policy residual greps — **not** elaborator completeness and **not** `GC_FREE_ELABORATOR=1`.

**Track D / QTT UseCheck depth (shipped):** `systems-qtt-depth-check.sh` greps UseCheck pure-fvar residual (same-fvar exclusive consume; distinct pure-fvar → path merge) and freestanding `bif*` ⊆ `splitterLayout?`; emits `QTT_USECHECK_DISTINCT_PURE_FVAR=1` / `QTT_SPLITTER_BIF_COMPLETE=1` / `QTT_DEPTH_OK=1` only after checks pass. Validate `GATE qtt_depth=PASS` is core integrity; proof-receipt gate 8 requires the same tokens (SKIP incomplete unless REQUIRE). **Distinct from Mult algebra tables** (definitional finite tables vs surface residual hardening). **Not** full elaborator completeness; **not** `GC_FREE_ELABORATOR=1`.

**G3 / host elaborator residual measurement (staged, shipped):** `systems-host-elaborator-residual.sh` **measures** stage1/`SYSTEMS_LEAN_TCB_LEAN` for `leanshared` / `Init_shared` NEEDED. Earn rules: successful **readelf and/or objdump** NEEDED parse with no shared residues (ELF magic independent of readelf; multi-scanner agreement when both present); **ldd alone never earns** residual_free (ldd+shared → classic; ldd+clean → unmeasured). Non-ELF (shell scripts / empty +x) → unmeasured, never earn. Tools prefer absolute `/usr/bin` pins (hostile-PATH resistant). Emits greppable `HOST_HAS_LEANSHARED`, `HOST_ELABORATOR_RESIDUAL`, measured `GC_FREE_ELABORATOR`, `HOST_ELABORATOR_RESIDUAL_OK`. Validate `GATE host_elaborator=PASS` when residual tokens are consistent — **classic shared runtime + `GC_FREE_ELABORATOR=0` is staged PASS** (not an elaborator rewrite). `GC_FREE_ELABORATOR=1` is never hardcoded; `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without earned residual_free → FAIL on all exit paths. Product validate pins stage1 lean (and residual tools when present) unless `SYSTEMS_LEAN_HOST_ELAB_ALLOW_OVERRIDE=1`. Dual path: product `PRODUCT_GC_FREE` vs host `GC_FREE_ELABORATOR`. Full elaborator without GC is **not claimed** while stage1 links shared runtime.

**H2 / product consumable without host GC (shipped honesty + dogfood path):** product-only nm gate (`systems-selfhost-link-check.sh` / `lean-systems check` / systems example `make check-selfhost`) and C consumer recipe (`cc -std=c11 … libfs_extract_bundle.a`, no `libleanshared`) do **not** require elaborator GC-free. Greppable dual path: PRODUCT_GC_FREE=1 can hold while GC_FREE_ELABORATOR=0. Does **not** forge elaborator=1; host residual earn gates unchanged (H5 still open after H3–H4 plan docs).

**H3 / host-driver residual plan (docs + isolation options; not earned):** concrete isolation options for a Systems host driver that can eventually drop `libleanshared` / `Init_shared` NEEDED under pinned readelf/objdump. Today stage1 still measures `HOST_HAS_LEANSHARED=1` / `GC_FREE_ELABORATOR=0`. Marker `HOST_DRIVER_RESIDUAL_PLAN=1` is plan honesty only — **never** mints `GC_FREE_ELABORATOR=1`. See § H3 below.

**H4 / host residual reduction plan (measurement checklist; not earned):** concrete checklist for a future residual_free host ELF (readelf/objdump NEEDED empty of `leanshared*`/`Init_shared`; multi-scanner agreement; stage1 link-line changes). Marker `HOST_RESIDUAL_REDUCTION_PLAN=1` is plan honesty only — **never** mints `GC_FREE_ELABORATOR=1`. See § H4 below.

**H5 / host elaborator earn path (progress docs + prototype worklist + measured baseline + W0 verified dry-run + W1 experiment protocol + W1 candidate measure protocol + next experiment step + negative candidates + earn checklist + FORCE refusal contract + FORCE negative measured receipt + status-quo stage1 summary + docs ladder complete; not earned):** ordered prototype worklist toward a residual_free host ELF (CMake `-lleanshared*` sources → static-link / thin non-elaborator driver sketches → multi-scanner residual_free gate). Markers `HOST_ELABORATOR_EARN_PATH=1`, `HOST_ELABORATOR_PROTOTYPE_WORKLIST=1`, `HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared`, `HOST_ELABORATOR_W0_VERIFIED_DOCS=1`, `HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1`, `HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1`, `HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1`, `HOST_ELABORATOR_NEGATIVE_CANDIDATES=1`, `HOST_ELABORATOR_EARN_CHECKLIST=1`, `HOST_ELABORATOR_FORCE_REFUSAL=1`, `HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1`, `HOST_ELABORATOR_STATUS_QUO=1`, and `HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1` are **plan/path/baseline/docs honesty only** — **not** residual_free, **not** `GC_FREE_ELABORATOR=1`. Measured stage1 snapshot + W0 CMake inject re-verify (H5.E1) + W0 verification dry-run transcript + W1 static-link / thin-driver experiment protocol + **measurable candidate protocol** (H5.E2; pin via `SYSTEMS_LEAN_HOST_ELF`) + **concrete next experiment step** (H5.E3; first-candidate binary identity) + **negative candidate identities** (H5.E4; `lean-systems` product shell / scripts / non-ELF must never be residual_free host candidates) + **fail-closed residual_free earn checklist** (`HOST_ELABORATOR_EARN_CHECKLIST=1`; ELF magic, NEEDED empty under readelf/objdump agreement, no FORCE, product independence) + **FORCE/negative refusal contract** (`HOST_ELABORATOR_FORCE_REFUSAL=1`; `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without residual_free must **FAIL**) + **FORCE negative measured receipt** (`HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1`; classic stage1 FORCE dry-run fail-closed tokens) + **status-quo stage1 summary box** (`HOST_ELABORATOR_STATUS_QUO=1`; resting measured tokens until earn) + **docs ladder complete** (`HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1`; path/worklist/E1–E4/checklist/FORCE/STATUS_QUO docs-complete; only real residual_free ELF remains for earn) documented in § H5. Earn flips **only** when `systems-host-elaborator-residual.sh` measures residual_free under multi-scanner agreement. Stage1 today still NEEDs `libleanshared*` / `Init_shared` → measured `GC_FREE_ELABORATOR=0`.

**Track C / Par dual-path (shipped):** product residual keeps sequential L1–L3 only (`PARALLELISM_DUAL_PATH_OK=1` via `script/systems-par-dual-path-check.sh`). Opt-in host dogfood: `make -C tests/lake/examples/systems check-par-pthread` (pthread L2) and `check-par-simd-hw` (HW SIMD L1). Concurrent runtime / memory model is **assumed host dogfood** (`CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1`) — not CompCert-proved product residual.

**Track F / tooling honesty (shipped):** inventory SSoT (`./script/systems-stdlib-inventory.sh --write`, optional `--require` drift), fast `./script/systems-status.sh`, hermetic **`systems.nix` front door** (`nix develop .#systems` / `nix build .#checks.<sys>.systems-light`; alias `.#systems-dev`), opt-in `.github/workflows/systems-lean.yml` (never forces classic CI). Live product surface: **fs-ready=149** = **149 PRODUCT_STDLIB** modules (**150 TUs** with Extract; Phase C −38 ordered-leaf `*Set`; Phase B3 (−69 magic codecs; prior B2 −45 `V*Lite`; B1 −39 thesaurus HeapLite). `PRODUCT_FS_NEXT=H5_host,TomlConfig_more89,Slake_parity_more` is the curated next backlog (W153 shipped H5 honesty + TomlConfig more88 + Slake CLAIMED residual honesty @149 — linters/builtin-lint/linter; W152 shipped H5 honesty + TomlConfig more87 + Slake CLAIMED residual honesty @149 — trace/old/json; W151 shipped H5 honesty + TomlConfig more86 + Slake CLAIMED residual honesty @149 — force/fix/only; W150 shipped H5 honesty + TomlConfig more85 + Slake CLAIMED residual honesty @149 — wfail/iofail/ansi; W149 shipped H5 honesty + TomlConfig more84 + offline/platform/toolchain; W148 shipped H5 honesty + TomlConfig more83 + Slake CLAIMED residual honesty @149 — reconfigure/quiet/verbose; W147 shipped H5 honesty + TomlConfig more82 + Slake CLAIMED residual honesty @149 — log-level/fail-level/no-ansi; W146 shipped H5 honesty + TomlConfig more81 + Slake CLAIMED residual honesty @149 — keep-toolchain/allow-empty/max-revs; W145 shipped H5 honesty + TomlConfig more80 + Slake CLAIMED residual honesty @149 — builtin-only/lint-only/record-exceptions; W144 shipped H5 honesty + TomlConfig more79 + Slake CLAIMED residual honesty @149 — add-public/gh-style/explain; W143 shipped H5 honesty + TomlConfig more78 + Slake CLAIMED residual honesty @149 — keep-implied/keep-prefix/keep-public; W142 shipped H5 honesty + TomlConfig more77 + Slake CLAIMED residual honesty @149 — no-overwrite/force-overwrite/rehash; W141 shipped H5 honesty + TomlConfig more76 + Slake CLAIMED residual honesty @149 — force-download/download-arts/mappings-only; W140 shipped H5 honesty + TomlConfig more75 + Slake CLAIMED residual honesty @149 — no-build/no-cache/try-cache; W139 shipped H5 honesty + TomlConfig more74 + Slake CLAIMED residual honesty @149 — reservoir-config/version-tags/upgrade; W138 shipped H5 honesty + TomlConfig more73 + Slake CLAIMED residual honesty @149 — translate-config/resolve-deps/services; W137 shipped H5 honesty + TomlConfig more72 + Slake CLAIMED residual honesty @149 — query-kind/setup-file/self-check; W136 shipped H5 honesty + TomlConfig more71 + Slake CLAIMED residual honesty @149 — check-build/check-lint/check-test; W135 shipped H5 honesty + TomlConfig more70 + Slake CLAIMED residual honesty @149 — exec/unstage/put-staged; W134 shipped H5 honesty + TomlConfig more69 + Slake CLAIMED residual honesty @149 — list/doc/stage; W133 shipped H5 honesty + TomlConfig more68 + Slake CLAIMED residual honesty @149 — get/put/add; W132 shipped H5 honesty + TomlConfig more67 + Slake CLAIMED residual honesty @149 — shake/run/scripts; W131 shipped H5 honesty + TomlConfig more66 + Slake CLAIMED residual honesty @149 — pack/unpack/upload; W130 shipped H5 honesty + TomlConfig more65 + Slake CLAIMED residual honesty @149 — init/new/update; W129 shipped H5 honesty + TomlConfig more64 + Slake CLAIMED residual honesty @149 — lint/exe/query; W128 shipped H5 honesty + TomlConfig more63 + Slake CLAIMED residual honesty @149 — clean/test/serve; W127 shipped H5 honesty + TomlConfig more62 + Slake CLAIMED residual honesty @149 — package/module/build; W126 shipped H5 honesty + TomlConfig more61 + Slake CLAIMED residual honesty @149 — info/remote/facets; W125 shipped H5 honesty + TomlConfig more60 + Slake CLAIMED residual honesty @149 — env/help/cc; W124 shipped H5 honesty + TomlConfig more59 + Slake CLAIMED residual honesty @149 — ext/lean/toml; W123 shipped H5 honesty + TomlConfig more58 + Slake CLAIMED residual honesty @149 — objs/cache/script; W122 shipped H5 honesty + TomlConfig more57 + Slake CLAIMED residual honesty @149 — verLike/mappings/default; W121 shipped H5 honesty + TomlConfig more56 + Slake CLAIMED residual honesty @149 — ir/traceArgs/debugAssertions; W120 shipped H5 honesty + TomlConfig more55 + Slake CLAIMED residual honesty @149 — art/olean/ltar cache/artifact ext identity tokens; W119 shipped H5 honesty + TomlConfig more54 + Slake CLAIMED residual honesty @149 — value (Load/Toml LeanOption) + residual major/minor labels; W118 shipped H5 honesty + TomlConfig more53 + Slake CLAIMED residual honesty @149 — ModuleArtifacts short keys complete; W117 shipped H5 honesty + TomlConfig more52 + Slake CLAIMED residual honesty @149; W116 shipped H5 honesty + TomlConfig more51 + Slake FS_PROC upgrade @149; classic-only FS_PROC queue empty; W115 shipped more50 + reservoir-config @149; W114 shipped more49 + resolve-deps @149; W113 shipped more48 + query-kind @149; W107 shipped H5 honesty + TomlConfig more42 + Slake FS_PROC new + BraidHeapLite/V39Lite/G713NbLite → FS_READY=325; W112 shipped H5 honesty + TomlConfig more47 + Slake FS_PROC exec + SkeinHeapLite/V45Lite/G707NbLite → FS_READY=340; W111 shipped H5 honesty + TomlConfig more46 + Slake FS_PROC check-lint + YarnHeapLite/V44Lite/G708NbLite → FS_READY=337; W110 shipped H5 honesty + TomlConfig more45 + Slake FS_PROC check-test + CableHeapLite/V43Lite/G709NbLite → FS_READY=334; W109 shipped H5 honesty + TomlConfig more44 + Slake FS_PROC check-build + WeaveHeapLite/V41Lite/G710NbLite → FS_READY=331; W108 shipped H5 honesty + TomlConfig more43 + Slake FS_PROC init + PlaitHeapLite/V40Lite/G712NbLite → FS_READY=328; W106 shipped H5 honesty + TomlConfig more41 + Slake FS_PROC run + TwineHeapLite/V38Lite/G714NbLite → FS_READY=322; W105 shipped H5 honesty + TomlConfig more40 + Slake FS_PROC translate-config + RopeHeapLite/V37Lite/G715NbLite → FS_READY=319; W104 shipped H5 honesty + TomlConfig more39 + Slake FS_PROC version-tags + CordHeapLite/V36Lite/G716NbLite → FS_READY=316; W103 shipped H5 honesty + TomlConfig more38 + Slake FS_PROC self-check + ThreadHeapLite/V35Lite/G717NbLite → FS_READY=313; W102 shipped H5 honesty + TomlConfig more37 + Slake FS_PROC setup-file + FiberHeapLite/V1Lite/G718NbLite → FS_READY=310; W101 shipped H5 honesty + TomlConfig more36 + Slake FS_PROC scripts + BeamHeapLite/V2Lite/G719NbLite → FS_READY=307; W100 shipped H5 honesty + TomlConfig more35 + Slake FS_PROC lean + SpineHeapLite/V3Lite/G720NbLite → FS_READY=304; W99 shipped H5 honesty + TomlConfig more34 + Slake FS_PROC upload + RibHeapLite/V4Lite/G725NbLite → FS_READY=301; W98 shipped H5 honesty + TomlConfig more33 + Slake FS_PROC serve + StrandHeapLite/V5Lite/G724NbLite → FS_READY=298; W97 shipped H5 honesty + TomlConfig more32 + Slake FS_PROC shake + LatticeHeapLite/V6Lite/G721NbLite → FS_READY=295; W96 shipped H5 honesty + TomlConfig more31 + Slake FS_PROC query + MeshHeapLite/V7Lite/G727NbLite → FS_READY=292; W95 shipped H5 honesty + TomlConfig more30 + Slake FS_PROC unpack + GraphHeapLite/V8Lite/G728NbLite → FS_READY=289; W94 shipped H5 honesty + TomlConfig more29 + Slake FS_PROC cache + TileHeapLite/V9Lite/G726NbLite → FS_READY=286; W93 shipped H5 honesty + TomlConfig more28 + Slake FS_PROC pack + PathHeapLite/V10Lite/G723NbLite → FS_READY=283; W92 shipped H5 honesty + TomlConfig more27 + Slake FS_PROC update + CellHeapLite/V11Lite/G722NbLite → FS_READY=280; W91 shipped H5 honesty + TomlConfig more26 + Slake FS_PROC clean + ZoneHeapLite/V12Lite/G711NbLite → FS_READY=277; W90 shipped H5 honesty + TomlConfig more25 + Slake FS_PROC script + BranchHeapLite/V13Lite/IlbcNbLite → FS_READY=274; W89 shipped H5 honesty + TomlConfig more24 + Slake FS_PROC lint + ForestHeapLite/V14Lite/G729NbLite → FS_READY=271; W88 shipped H5 honesty + TomlConfig more23 + Slake FS_PROC exe + RootHeapLite/V15Lite/GsmNbLite → FS_READY=268; W87 shipped H5 honesty + TomlConfig more22 + Slake FS_PROC test + EdgeHeapLite/V16Lite/IsacNbLite → FS_READY=265; W86 shipped H5 honesty + TomlConfig more21 + Slake FS_PROC multi-arg rest + NodeHeapLite/V20Lite/EvrcNbLite → FS_READY=262; W85 shipped H5 honesty + TomlConfig more20 + Slake argv plumbing + LeafHeapLite/V25Lite/QcelpNbLite → FS_READY=259; W84 shipped H5 honesty + TomlConfig more19 + Slake exec/upgrade + SpanHeapLite/V30Lite/SilkNbLite → FS_READY=256; W83 shipped H5 honesty + TomlConfig more18 + Slake query-kind/resolve-deps/reservoir-config + PoolHeapLite/V31Lite/AmrNbPlusLite → FS_READY=253; W82 shipped H5 honesty + TomlConfig more17 + Slake setup-file/self-check/version-tags + ChunkHeapLite/V28Lite/LapmLite → FS_READY=250; W81 shipped H5 honesty + TomlConfig more16 + Slake translate-config/run + BufferHeapLite/V24Lite/OpusFbLite → FS_READY=247; W80 shipped H5 honesty + TomlConfig more15 + Slake serve/upload + RegionHeapLite/V19Lite/MelpNbLite → FS_READY=244; W79 shipped H5 honesty + TomlConfig more14 + Slake new/init + BlockHeapLite/V18Lite/MelpSwbLite → FS_READY=241; W78 shipped H5 honesty + TomlConfig more13 + Slake lean/scripts + SlabHeapLite/V33Lite/MelpUwbLite → FS_READY=238; W77 shipped H5 honesty + TomlConfig more12 + Slake unpack/cache + FrameHeapLite/V17Lite/QcelpUwbLite → FS_READY=235).

**Not done (R7 / future):** full freestanding Lean *library* / elaborator without GC. Host elaboration still uses classic stage1 `lean` + `libleanshared` (`GC_FREE_ELABORATOR=0` until earned). The “no mandatory GC” claim is for freestanding **product / embed** objects only (`PRODUCT_GC_FREE=1` is product wire residual, not elaborator). PRODUCT is **shaped** Freestanding, not full Init.

Canonical product doc: [systems-lean.md](systems-lean.md). Full FS stdlib (R7): [systems-lean-stdlib-inventory.md](systems-lean-stdlib-inventory.md).

## How to run

From the lean4 root (prefer in-tree stage1 on `PATH`):

```bash
export PATH="$PWD/build/release/stage1/bin:$PATH"

# Full R6 product path: build freestanding bundle, install lean-systems,
# nm gate (no U lean_* / U l_*), negatives, tiny freestanding compile
./script/systems-selfhost.sh
# Same gates via: ./script/lean-systems selfhost

# After freestanding is already built (e.g. make check), skip lake rebuild:
SYSTEMS_LEAN_SELFHOST_SKIP_BUILD=1 ./script/systems-selfhost.sh

# Entry point (also installed under out/systems-selfhost/bin/lean-systems)
./script/lean-systems --version
./script/lean-systems --help
./script/lean-systems build
./script/lean-systems check
out/systems-selfhost/bin/lean-systems check

# freestanding Makefile targets (both included in `make check`)
make -C tests/lake/examples/systems check-selfhost
make -C tests/lake/examples/systems check-selfhost-negatives

# Integration smoke includes R6 by default (skip with SYSTEMS_LEAN_SMOKE_SELFHOST=0)
# Smoke runs make check then selfhost with SKIP_BUILD=1 (no double lake rebuild)
./script/systems-lean-smoke.sh
```

Optional tiny freestanding C emit via the driver (passes `-Dcompiler.systemsSelfHost=true` and freestanding/QTT flags):

```bash
./script/lean-systems compile path/to/Tiny.lean
```

## Classic vs Systems Lean

| | Classic Lean (default) | Systems Lean (opt-in) |
|--|------------------------|------------------------|
| Runtime / GC | Required for AOT product | **Not required** for freestanding / self-host **product** |
| QTT 0/1/ω | Off | On with `compiler.freestanding` or `compiler.qtt` |
| Stdlib | Init/Std with RC | Full stdlib under FS constraints (R7); dual-path where needed |
| Self-host | stage1 + `libleanshared` | Additional `lean-systems` product path; product objects without GC dynlibs |

Runtime libraries remain in-tree and fully supported for classic builds.

## Options (opt-in only)

- `compiler.freestanding` — extract mode + QTT + closed imports / emit gates (**this is the gate**)  
- `compiler.qtt` — QTT without full freestanding import gate (where enabled)  
- `compiler.systemsSelfHost` — **informational product preference** marker for self-host FS builds  

**Important:** `compiler.systemsSelfHost=true` **alone does not** enable freestanding extract gates (import close, AffineCheck, EmitC, `@[export_c]`). Emit paths still key on `compiler.freestanding` / module freestanding bit (and QTT via freestanding or `compiler.qtt`). Use:

- `lean-systems` / `lean-systems lean …` (always passes **all three** flags), or  
- Lake `freestanding := true` (forces `compiler.freestanding=true`), or  
- explicit `-Dcompiler.freestanding=true` (and usually `-Dcompiler.qtt=true`).

Classic default builds ignore these options.

## TCB inventory (host vs product)

Honest split for R6. **Do not** treat “self-host product path” as “GC-free elaborator.”

### Host elaborator TCB (classic stage1 — still allowed)

Used today to elaborate freestanding modules and drive Lake / `lean` codegen:

| Artifact / component | Role |
|----------------------|------|
| `build/release/stage1/bin/lean` | Elaborator + compiler driver |
| `build/release/stage1/bin/lake` | Package builds (`freestanding := true`) |
| `libleanshared` / Lean RC runtime | Host process memory management |
| Init / Std / Lean `.olean`s | Host stdlib + compiler implementation |
| `compiler.freestanding` gates in-tree | Closed imports, AffineCheck, EmitC, certs |

This TCB **uses GC/RC**. R6 does **not** remove it.

### Product / embed TCB (freestanding extract — no mandatory GC)

What a C consumer (or CompCert dogfood) links:

| Artifact / component | Role |
|----------------------|------|
| `libfs_extract_bundle.a` (freestanding) | Combined freestanding static archive |
| `libfs_extract.a` + `libSystems.a` | Multi-archive form (`Extract:freestanding`) |
| Generated `Extract.c` / `Systems/{Scalars,Sys}.c` | ISO C11 product IR (+ memsafe / CompCert cert footers) |
| libc / POSIX (`open`, `malloc`, `mmap`, …) | Allowlisted externs only |
| **Not** in product TCB | `Init_shared`, `leanshared*`, `lean_inc` / `lean_object` / RC |

Gate: `script/systems-selfhost-link-check.sh` (also `make check-selfhost`, proof-receipt optional nm, `lean-systems check`). On residual success only, link-check prints greppable product wire tokens:

```
PRODUCT_NO_LEANSHARED=1
PRODUCT_GC_FREE=1
```

Validate `GATE product_gc_free` requires those tokens **and** residual_nm ∧ residual_ir PASS. Link-check negatives assert FAIL cases never emit the tokens and that a clean freestanding-shaped object does.

### Module / tree inventory (self-host product surface)

| Path | Host vs product | Notes |
|------|-----------------|-------|
| `src/Systems/` | Product (FS) | Scalars, Sys, Bytes, Numerics, Status, Mem, BitOps, Hash, ByteSpan, Map, BitVec, Set, Queue, Vector, Sort, Crc, String, BinarySearch, Deque, Stack, Ascii, MemRegion, BitSet, Parse, RingBuf, Fmt, List, Path, Hex, Utf8, Tree, Json, Base64, Graph, Regex, Url, ArenaPool, Par.{Simd,ForkJoin,Channel} |
| `tests/lake/examples/systems/lib/` | Product build | Lake `freestanding := true` + bundle |
| `tests/lake/examples/systems/host/` | Host only | Specs / proofs; not in `.a` |
| `src/Lean/Compiler/{Freestanding,QTT,Options,…}` | Host compiler | Implements FS/QTT gates |
| `script/lean-systems` | Product driver | Version / build / check / compile |
| `script/systems-selfhost.sh` | Product path | Install prefix + full gate |
| `out/systems-selfhost/bin/lean-systems` | Installed entry | Created by `systems-selfhost.sh` |
| `ref/CompCert` + `ref/bin/ccomp` | Tool pin (optional) | CompCert sources + ccomp for PROVABLY gate — **not** elaborator verification |

### Host elaborator TCB — honesty gate + next ports

The elaborator / Lake / codegen still run on **classic stage1 + `libleanshared` (RC/GC)**.
This is **not** CompCert-verified and **not** GC-free.

#### Greppable TCB honesty tokens (`./script/systems-tcb-inventory.sh`)

Emitted by the inventory script (host residual **measured** via G3 helpers):

```
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
PRODUCT_EMBED_TCB=residual_free_goal
GC_FREE_ELABORATOR=0
HOST_HAS_LEANSHARED=1
TCB_HONESTY_OK=1
PRODUCT_FS_NEXT=H5_host,TomlConfig_more89,Slake_parity_more
```

Stage1 today measures `HOST_HAS_LEANSHARED=1` → `GC_FREE_ELABORATOR=0`. Earn path (only when **readelf and/or objdump** NEEDED proves no `leanshared`/`Init_shared` on a real ELF; **ldd alone never earns**): `HOST_ELABORATOR_TCB=residual_free`, `HOST_ELABORATOR_RESIDUAL=residual_free`, `HOST_HAS_LEANSHARED=0`, `GC_FREE_ELABORATOR=1`. When the product bundle is present **and** a full nm residual scan was performed and clean: `PRODUCT_GC_FREE=1` / `PRODUCT_NO_LEANSHARED=1` (else `=0`). Inventory product GC is nm-advisory only (not residual_ir). **Integrity gate remains** `GATE product_gc_free` / scoreboard `PRODUCT_*`, not inventory alone.

**`GATE tcb_honesty=PASS` (validate)** uses the shared checker `script/systems-tcb-honesty-check.sh` and requires inventory exit 0 plus dual-path honesty:

- Classic: `HOST_ELABORATOR_TCB=classic_RC_shared_runtime` + `GC_FREE_ELABORATOR=0` (never `=1` without earn tokens)
- Earn: `HOST_ELABORATOR_TCB=residual_free` + `HOST_ELABORATOR_RESIDUAL=residual_free` + `HOST_HAS_LEANSHARED=0` + `GC_FREE_ELABORATOR=1`
- Always: `PRODUCT_EMBED_TCB=residual_free_goal`, exactly one `TCB_HONESTY_OK=1`, **no** `TCB_HONESTY_OK=0`

**`GATE host_elaborator=PASS` (validate, G3)** runs `systems-host-elaborator-residual.sh` and requires consistent residual tokens (`systems_lean_host_elab_tokens_ok`). Measured classic shared + `GC_FREE_ELABORATOR=0` is staged PASS. Scoreboard re-emits measured host residual tokens (not forged defaults).

Validate does **not** require `PRODUCT_FS_NEXT` or `SYSTEMS_LEAN_TCB_REQUIRE=1`.

| Token | Meaning | Required by validate? |
|-------|---------|----------------------:|
| `HOST_ELABORATOR_TCB` | Measured host class (`classic_RC_shared_runtime` or earned `residual_free`) | **yes** (honesty dual path) |
| `HOST_ELABORATOR_RESIDUAL` | G3 residual class (same values + `unmeasured`) | **yes** for `GATE host_elaborator` |
| `PRODUCT_EMBED_TCB` | Product embed goal is residual-free AOT C (not elaborator) | **yes** |
| `GC_FREE_ELABORATOR` | **Measured** host residual — `=1` only if residual_free earned via readelf/objdump | **yes** (classic `=0` today) |
| `TCB_HONESTY_OK` | `1` on success; `0` on REQUIRE hard-fail | **yes** (exactly one `=1`, no `=0`) |
| `PRODUCT_FS_NEXT` | Curated next-port backlog (hand-maintained; **not** auto PRODUCT_STDLIB growth) | no (always emitted by inventory) |
| `HOST_HAS_LEANSHARED` | Measured NEEDED residue (readelf/objdump; ldd may set classic only) | **yes** for residual earn / host_elaborator |
| `PRODUCT_GC_FREE` / `PRODUCT_NO_LEANSHARED` | Nm-advisory product residual (independent of host GC_FREE) | no for `tcb_honesty` (required by `GATE product_gc_free` / scoreboard) |

`SYSTEMS_LEAN_TCB_REQUIRE=1` optionally fails on missing lean/bundle (empty/unreadable), missing `nm`, host residual unmeasured, or product residual undefs; default advisory still prints tokens and exits 0. Explicit `SYSTEMS_LEAN_TCB_LEAN` never falls back to `PATH`. `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without earned residual_free → FAIL. Product residual integrity remains owned by `residual_nm` / `systems-selfhost-link-check.sh`. Negatives: `script/systems-tcb-inventory-negatives.sh`, `script/systems-host-elaborator-residual-negatives.sh`.

#### Next freestanding ports (curated backlog; PRODUCT_STDLIB deferred)

P5 prefers honesty gates over forcing a risky new PRODUCT_STDLIB module this pass. Grow `script/systems-product-stdlib-modules.txt` **only** after freestanding build + residual + certs are green.

`PRODUCT_FS_NEXT` is a **curated** planning string in `systems-tcb-inventory.sh` (not a live dump of `fs-planned` inventory buckets). Update it when the preferred next port changes.

| Greppable id (`PRODUCT_FS_NEXT`) | Shape | Why deferred / next |
|------|-------|---------------------|
| `Slake_Proc_dogfood` | freestanding `Systems.Proc` spawn dogfood | **shipped** W65 as `tests/slake/proc_dogfood` (argv0); multi-arg W66; pipe W67; classic CLI still `IO.Process`→`lake` |
| `TomlConfig_more` (W65 shipped version/buildType/path) | richer lakefile.toml subset beyond W64 expand | **shipped** W65 |
| `TomlConfig_more2` | scoped `requirePathScopedCount` + `hasDefaultTargets` / `moreLeanArgsCount` / `hasBackend` | **shipped** W66 (not full TOML 1.0 / Lean DSL) |
| `TomlConfig_more3` | `hasTestDriver` / `hasLintDriver` / `weakLeanArgsCount` / `firstLeanLibName*` | **shipped** W68 (not full TOML 1.0 / Lean DSL) |
| `TomlConfig_more4` | `hasPlatformIndependent` / `hasPreferReleaseBuild` / `leanArgsCount` / `firstLeanExeName*` | **shipped** W69 (not full TOML 1.0 / Lean DSL) |
| `Slake_FS_Proc_CLI` | classic `SLAKE_USE_FS_PROC=1` → freestanding multi-arg Proc (Option C) | **shipped** W68 (default still IO.Process; not freestanding TCB) |
| `Slake_multi_argv` | multi-arg freestanding spawn | **shipped** W66 (`sysSpawnArgv` / dogfood); pipe freestanding **shipped** W67 (`sysPipe` / `sysSpawnArgvPipe`); classic CLI residual |
| `H5_host` | residual_free host elaborator earn | not forged GC_FREE_ELABORATOR |
| `L2tp_peer` | Track L L2TP-family twin beyond L2tpLite | **shipped** W65 as `PptpLite` + `L2fLite` peers (not full control plane) |

#### Priority table

| Priority | Module / area | Why next |
|----------|---------------|----------|
| P1 | Keep product path residual-free as FS surface grows | Mem/BitOps/Hash/Par already on product TUs |
| P2 | More `fs-planned` → `Systems.*` ports | **… + W112** H5 honesty + TomlConfig more47 + Slake FS_PROC exec + SkeinHeapLite/V45Lite/G707NbLite (FS_READY=340); **W111** H5 honesty + TomlConfig more46 + Slake FS_PROC check-lint + YarnHeapLite/V44Lite/G708NbLite (FS_READY=337); **W110** H5 honesty + TomlConfig more45 + Slake FS_PROC check-test + CableHeapLite/V43Lite/G709NbLite (FS_READY=334); **W109** H5 honesty + TomlConfig more44 + Slake FS_PROC check-build + WeaveHeapLite/V41Lite/G710NbLite (FS_READY=331); **W108** H5 honesty + TomlConfig more43 + Slake FS_PROC init + PlaitHeapLite/V40Lite/G712NbLite (FS_READY=328); W107@325 BraidHeap/V39/G713Nb + more42 + new; W106@322 TwineHeap/V38/G714Nb + more41 + run; W105@319 RopeHeap/V37/G715Nb + more40 + translate-config; W104@316 CordHeap/V36/G716Nb + more39 + version-tags; W103@313 ThreadHeap/V35/G717Nb + more38 + self-check; W102@310 FiberHeap/V1/G718Nb + more37 + setup-file; W101@307 BeamHeap/V2/G719Nb + more36 + scripts; W100@304 SpineHeap/V3/G720Nb + more35 + lean; W99@301 RibHeap/V4/G725Nb + more34 + upload; W98@298 StrandHeap/V5/G724Nb + more33 + serve; W97@295 LatticeHeap/V6/G721Nb + more32 + shake; W96@292 MeshHeap/V7/G727Nb; W95@289 GraphHeap/V8/G728Nb; W94@286 TileHeap/V9/G726Nb; W93@283 PathHeap/V10/G723Nb; next: H5_host/TomlConfig_more89/Slake_parity_more only (W153 more88 linters/builtin-lint/linter; W152 more87 trace/old/json; W151 more86 force/fix/only; W150 more85 wfail/iofail/ansi; W149 more84 offline/platform/toolchain; W148 more83; W147 shipped more82 log-level/fail-level/no-ansi; W146 shipped more81 keep-toolchain/allow-empty/max-revs; W145 shipped more80 builtin-only/lint-only/record-exceptions; W144 shipped more79 add-public/gh-style/explain; W143 shipped more78 keep-implied/keep-prefix/keep-public; W142 shipped more77 no-overwrite/force-overwrite/rehash; W141 shipped more76 force-download/download-arts/mappings-only; W140 shipped more75 no-build/no-cache/try-cache; W139 shipped more74 reservoir-config/version-tags/upgrade; W138 shipped more73 translate-config/resolve-deps/services; W137 shipped more72 query-kind/setup-file/self-check; W136 shipped more71 check-build/check-lint/check-test; W135 shipped more70 exec/unstage/put-staged; W134 shipped more69 list/doc/stage; W133 shipped more68 get/put/add; W132 shipped more67 shake/run/scripts; greppable e.g. other Lake CLI tokens after more77 (no-overwrite/force-overwrite/rehash shipped; more76 force-download/download-arts/mappings-only shipped; more75 no-build/no-cache/try-cache shipped); W131 shipped more66 pack/unpack/upload; W130 shipped more65 + Slake CLAIMED residual honesty @149 — init/new/update; W129 shipped more64 + Slake CLAIMED residual honesty @149 — lint/exe/query; W128 shipped more63 + Slake CLAIMED residual honesty @149 — clean/test/serve; W127 shipped more62 + Slake CLAIMED residual honesty @149 — package/module/build; W126 shipped more61 + Slake CLAIMED residual honesty @149 — info/remote/facets; W125 shipped more60 + Slake CLAIMED residual honesty @149 — env/help/cc; W124 shipped more59 + Slake CLAIMED residual honesty @149 — ext/lean/toml; W123 shipped more58 + Slake CLAIMED residual honesty @149 — objs/cache/script; W122 shipped more57 + Slake CLAIMED residual honesty @149 — verLike/mappings/default; W121 shipped more56 + Slake CLAIMED residual honesty @149 — ir/traceArgs/debugAssertions; W120 shipped more55 + Slake CLAIMED residual honesty @149 — art/olean/ltar; W119 shipped more54 + Slake CLAIMED residual honesty @149 — value/major/minor; W118 shipped more53 + Slake CLAIMED residual honesty @149 — ModuleArtifacts short keys complete; W117 shipped more52 + Slake CLAIMED residual honesty @149; W116 shipped more51+upgrade @149; classic-only FS_PROC queue empty; W115 shipped more50+reservoir-config @149; W114 shipped more49+resolve-deps @149; W113 shipped more48+query-kind @149; **no** FS_READY growth target — Track L frozen; baseline **149** after Phase C (−38 ordered-leaf `*Set`; prior B3 −69 magic codecs; B2 −45 `V*Lite`; historical Phase B1 @301 after −39 thesaurus HeapLite); historical **W112** H5 honesty + TomlConfig more47 + Slake FS_PROC exec + SkeinHeapLite/V45Lite/G707NbLite (FS_READY=340 pre-B1) |
| P3 | Optional: freestanding-friendly LCNF helpers without Meta RC | Incremental; not full elaborator rewrite |
| P4 | GC-free elaborator | **Not claimed** — G3 ships measurement + earned-token dual path only |
| **P5** | Host vs product TCB honesty gate | **Shipped** — greppable tokens + `GATE tcb_honesty`; elaborator still classic |
| **G3** | Host elaborator residual measurement | **Shipped (staged)** — measure NEEDED; `GC_FREE_ELABORATOR=0` on stage1; earn `=1` only residual_free |
| **Track F** | Tooling / docs / CI / inventory honesty | **Shipped** — inventory `--write/--require`, `systems-status.sh`, opt-in `systems-lean.yml`, `systems.nix` front door (`.#systems` / `checks.systems-light`) |

### Roadmap residual (after G / A–D / F)

| Residual | Honesty |
|----------|---------|
| `GC_FREE_ELABORATOR=1` | Not earned on stage1 (classic shared RC) |
| Full Init under freestanding | Not claimed — PRODUCT shaped (149 modules / 150 TUs; Phase C −38 ordered-leaf `*Set`; Phase B1 −39 thesaurus HeapLite; Phase B3 (−69 magic codecs; prior B2 −45 `V*Lite`) |
| Verified concurrent runtime | Assumed host dogfood only |
| `PRODUCT_FS_NEXT` ports | Planning string only until residual-green growth |
| CompCert-verified elaborator | Never claimed |

### Host dependency map (Track H / H1)

Honest inventory of what `lean-systems` **compile / check / selfhost** need on the **host** today, and what stays independent. This is documentation only — it does **not** change gates or mint `GC_FREE_ELABORATOR=1`.

#### Command → host deps (stage1 today)

| Command | Host binary deps | Shared runtime (NEEDED) | Product artifact |
|---------|------------------|-------------------------|------------------|
| `lean-systems build` | stage1 `lean` on `PATH` + stage1 `lake` (`LAKE` or `build/release/stage1/bin/lake`) | **yes** — elaborating freestanding modules uses `lean` → `libInit_shared.so`, `libleanshared{,_1,_2}.so` (and usual libc/libgmp/libuv/…) | writes `libfs_extract_bundle.a` under freestanding Lake build |
| `lean-systems compile FILE.lean` | stage1 `lean` + `python3` (setup.json helper) | **yes** — same `lean` process / NEEDED as above | emits freestanding `.c` only; IR greps reject RC residues |
| `lean-systems check` | **no** elaborator required for the nm scan itself (`systems-selfhost-link-check.sh` + `nm`) | **n/a for product** — scans product archive, not host `lean` | requires existing bundle (`SYSTEMS_LEAN_BUNDLE` or default path) |
| `lean-systems selfhost` | `build` + install + `check` + link-check negatives + tiny `compile` | **yes** for build/compile legs; check/negatives are product-side | install prefix `out/systems-selfhost/`; product residual independent |
| `./script/systems-selfhost.sh` | thin wrapper → `lean-systems selfhost` (+ stage1 PATH prefer) | same as selfhost | same |

Measured stage1 NEEDED (re-check with `readelf -d build/release/stage1/bin/lean | grep NEEDED`): includes **`libInit_shared.so`**, **`libleanshared.so`**, **`libleanshared_1.so`**, **`libleanshared_2.so`**. That is why residual measurement emits:

```
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
```

`lake` is the package driver for freestanding `lib/` builds only; it is **not** part of the product embed TCB and is **not** what `GC_FREE_ELABORATOR` measures (G3 measures the **lean** ELF).

#### Freestanding product path independence

| Axis | Host elaborator | Product / embed |
|------|-----------------|-----------------|
| Gate scripts | `systems-host-elaborator-residual.sh`, `systems-tcb-inventory.sh` (`GATE host_elaborator` / `tcb_honesty`) | `systems-selfhost-link-check.sh`, residual_nm / residual_ir (`GATE product_gc_free`) |
| Greppable success | `GC_FREE_ELABORATOR=0` staged PASS on classic stage1 | `PRODUCT_GC_FREE=1` / `PRODUCT_NO_LEANSHARED=1` after nm residual success |
| Runtime libs | `libleanshared*` / `Init_shared` still NEEDED on stage1 | **must not** appear as product undefs / shared residues |
| Forging | `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without residual_free → **FAIL** | product tokens only on residual success; negatives refuse forge |

**Dual path rule:** product residual-free (`PRODUCT_GC_FREE=1`) does **not** imply elaborator GC-free. Host measurement stays `GC_FREE_ELABORATOR=0` until earned under H5.

#### Earn path (H2–H5) — concrete next steps

SSoT earn rules live in `script/systems-host-elaborator-residual.sh` (header + measure helpers). Do not weaken them.

| Step | Goal | Done when |
|------|------|-----------|
| **H1** (this section) | Map host deps of compile / check / selfhost | docs + greppable pointers; classic residual still measured `=0` |
| **H2** (below) | Keep product artifacts consumable without host GC | product-only link/check + consumer recipe green **without** `libleanshared` on the product link line; host stays `GC_FREE_ELABORATOR=0` |
| **H3** (below) | Prototype slim Systems host driver without `libleanshared` / `Init_shared` NEEDED | isolation options + `HOST_DRIVER_RESIDUAL_PLAN=1` documented; residual_free only when real ELF under pinned readelf/objdump is clean |
| **H4** (below) | Residual reduction checklist + entrypoint Meta/RC shrink plan | measurement checklist + `HOST_RESIDUAL_REDUCTION_PLAN=1`; no claim without measured residual_free |
| **H5** (below) | Flip `GC_FREE_ELABORATOR=1` **only** with fail-closed earn + forge negatives | residual script + honesty checker accept earn tokens; forge cases still FAIL; path/worklist markers `HOST_ELABORATOR_EARN_PATH=1` / `HOST_ELABORATOR_PROTOTYPE_WORKLIST=1` are **not** earn |

Until H4–H5 evidence exists on a real residual_free host binary: **leave `GC_FREE_ELABORATOR=0`**. Validate `GATE host_elaborator=PASS` with classic shared + `=0` is correct staged behavior, not a bug.

#### H2 — product consumable without host GC (shipped path; honesty only)

**Goal:** a C consumer (or CompCert dogfood) can link freestanding product archives **without** `libleanshared` / `Init_shared` / Lean RC on the product link line, **while** the host elaborator remains classic (`GC_FREE_ELABORATOR=0`). H2 does **not** mint elaborator GC-free; it dogfoods the product residual path that already exists.

**Honesty dual path (greppable):** PRODUCT_GC_FREE=1 can hold while GC_FREE_ELABORATOR=0. These tokens are independent axes — product wire residual vs host elaborator NEEDED. Never forge `GC_FREE_ELABORATOR=1` to “match” product success; never weaken host residual earn gates.

##### Product-only link / check path (no elaborator GC-free required)

These commands scan or link **product** artifacts only. They do **not** require a GC-free elaborator and do **not** re-measure stage1 NEEDED:

| Path | What it does | Host elaborator needed? | Success tokens |
|------|--------------|-------------------------|----------------|
| `./script/systems-selfhost-link-check.sh` | nm residual on bundle/object | **no** (needs `nm` + existing archive) | `PRODUCT_GC_FREE=1` `PRODUCT_NO_LEANSHARED=1` |
| `./script/lean-systems check` | thin wrapper → link-check on `SYSTEMS_LEAN_BUNDLE` (or default FS bundle) | **no** elaborator for the nm gate | same product tokens |
| `make -C tests/lake/examples/systems check-selfhost` | link-check on `FS_BUNDLE` | lake only if rebuilding; gate itself is product nm | same + Makefile OK line |
| `make -C tests/lake/examples/systems check-selfhost-negatives` | fail-closed forge refusals | **no** lean | negatives refuse `PRODUCT_GC_FREE=1` on FAIL cases |
| `make -C tests/lake/examples/systems check-deps` | consumer binary NEEDED must not include Lean shared libs | needs prior `run` (cc + bundle; no leanshared on **link line**) | `OK: no NEEDED Init_shared/leanshared*` |
| Full dogfood (optional) | `make -C tests/lake/examples/systems check` | elaborator only for Lake rebuild legs; residual gates stay product-side | product residual + IR + host specs |

Minimal greppable product residual (bundle must already exist):

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"   # optional; not required for nm gate
./script/systems-selfhost-link-check.sh
# or: ./script/lean-systems check
# expect: PRODUCT_GC_FREE=1 and PRODUCT_NO_LEANSHARED=1
./script/systems-host-elaborator-residual.sh
# expect on stage1 today: GC_FREE_ELABORATOR=0  (independent; still honest)
```

##### Consumer recipe without `libleanshared`

ISO C11 consumer link line is **one** freestanding bundle + libc (no Lean dynlibs):

```bash
# After freestanding Lake product build (once):
#   lake --dir=tests/lake/examples/systems/lib build
# Bundle path (default):
#   tests/lake/examples/systems/lib/.lake/build/lib/libfs_extract_bundle.a

cd tests/lake/examples/systems
# Happy path used by Makefile `run` / `check-deps`:
cc -std=c11 -o out/main main.c \
  lib/.lake/build/lib/libfs_extract_bundle.a
# Do **not** add -lleanshared / Init_shared / Lean runtime paths.
./out/main
# Optional NEEDED audit (Makefile check-deps):
#   readelf -d out/main | grep -E 'NEEDED.*(Init_shared|leanshared)'  → must be empty
```

Multi-archive form (`Extract:freestanding` → `libfs_extract.a` + `libSystems.a`) is supported for tooling; the **consumer happy path** is the single `libfs_extract_bundle.a` from `Extract:freestanding.bundle`.

**Not on the product link line:** `libleanshared*`, `libInit_shared`, `-lleanshared`, Lean RC entry points (`lean_inc` / `lean_object` / …). Those remain **host** elaborator deps for stage1 `lean` / Lake when *building* freestanding modules — orthogonal to linking the product archive into a C binary.

##### What H2 is not

- Not H3 (slim host driver without shared NEEDED).
- Not H5 / not `GC_FREE_ELABORATOR=1`.
- Not a claim that compiling Lean sources is GC-free — only that **product embed objects** are consumable without Lean shared runtime.

#### H3 — host-driver residual reduction (plan / isolation options; not earned)

**Goal:** progress toward a Systems **host driver** whose real ELF no longer NEEDs `libleanshared*` / `Init_shared`, so G3 can honestly measure `HOST_HAS_LEANSHARED=0` and (only then) `GC_FREE_ELABORATOR=1` under existing fail-closed earn rules. H3 is **prototype + isolation planning** — it does **not** ship a residual_free host binary and does **not** flip earn tokens.

```
HOST_DRIVER_RESIDUAL_PLAN=1
```

That marker is greppable plan honesty only (docs / driver comments). It is **not** an earn token, **not** `HOST_ELABORATOR_RESIDUAL=residual_free`, and **must never** be treated as `GC_FREE_ELABORATOR=1`.

**SSoT earn rules unchanged:** `script/systems-host-elaborator-residual.sh` (header + measure helpers). Do not weaken them for H3.

| Still true on stage1 today | Token |
|----------------------------|--------|
| Shared RC runtime NEEDED | `HOST_HAS_LEANSHARED=1` |
| Host residual class | `HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime` |
| Measured elaborator GC-free | `GC_FREE_ELABORATOR=0` |
| Product wire (independent) | `PRODUCT_GC_FREE=1` possible via H2 nm path |

##### Isolation options (concrete)

Three layered options; only option C can earn residual_free under scanners, and only when a real measured ELF is clean.

| Option | What it is | Drops host NEEDED? | Earns `GC_FREE_ELABORATOR=1`? |
|--------|------------|--------------------|------------------------------|
| **A. Thin product wrapper** (today) | `script/lean-systems` shells to product tools only for `check` / link-check; build/compile still call classic stage1 `lean` | **no** — wrapper is shell, not the elaborator ELF | **no** |
| **B. Host-driver isolation (process boundary)** | Keep elaborator as classic stage1; expose Systems entrypoints that only exec product gates / install / consumer recipes without linking Lean into *this* process | **no** for stage1 `lean` itself; yes for the *driver process* (shell/script) | **no** — G3 measures the **lean** binary, not the wrapper |
| **C. Future static / freestanding host lean** | Real host ELF built without `libleanshared` / `Init_shared` on the link line (static lean or FS host driver that does not NEED shared RC) | **yes** when NEEDED is clean under scanners | **only if** G3 residual_free earn passes (readelf and/or objdump; ldd never earns) |

**Option A (shipped honesty, H1/H2):** `lean-systems check` is product nm only; `selfhost` rebuilds with classic lean then product-gates. Dual residual print after product path:

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
./script/lean-systems check
# product: PRODUCT_GC_FREE=1 / PRODUCT_NO_LEANSHARED=1  (when bundle residual-clean)
# dual honesty block re-measures host (never forges elaborator=1):
#   HOST_HAS_LEANSHARED=1
#   GC_FREE_ELABORATOR=0
```

**Option B (isolation, no earn):** document and keep the product path free of host dynlibs; never claim the elaborator is residual_free because a wrapper has no NEEDED. G3 continues to point `SYSTEMS_LEAN_TCB_LEAN` / stage1 `bin/lean`.

**Option C (future earn path for H3→H5):**

1. Produce a candidate host ELF (static lean, experimental FS host driver, or link line that omits `libleanshared*` / `Init_shared`).
2. Measure with pinned tools (prefer absolute `/usr/bin` pins; hostile-PATH resistant as in residual script):

```bash
# Measure NEEDED (manual audit; residual script is SSoT for tokens)
readelf -d path/to/candidate-lean | grep NEEDED
# or: objdump -p path/to/candidate-lean | grep NEEDED
# Expect absence of: Init_shared, leanshared, leanshared_1, leanshared_2

SYSTEMS_LEAN_TCB_LEAN=path/to/candidate-lean ./script/systems-host-elaborator-residual.sh
# Earn only when residual script prints residual_free + HOST_HAS_LEANSHARED=0 + GC_FREE_ELABORATOR=1
# Classic stage1 still prints:
#   HOST_HAS_LEANSHARED=1
#   GC_FREE_ELABORATOR=0
```

3. Multi-scanner agreement when both readelf and objdump are present; non-ELF / shell / empty +x → unmeasured, never earn. `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without residual_free → **FAIL**.
4. Negatives stay fail-closed: `script/systems-host-elaborator-residual-negatives.sh`.

##### What H3 is not

- Not a shipped residual_free host binary (stage1 still classic).
- Not H5 / not `GC_FREE_ELABORATOR=1` until G3 earns it on a real ELF.
- Not a product residual claim (product stays H2 / `PRODUCT_GC_FREE`).
- Not permission to weaken residual earn rules or hardcode elaborator=1 in drivers.

##### Done when (H3 prototype evidence)

| Checkpoint | Evidence |
|------------|----------|
| Isolation options documented | this section + `HOST_DRIVER_RESIDUAL_PLAN=1` |
| Dual residual greppable on product path | `lean-systems check` / `selfhost` re-emits product + measured host tokens |
| Residual_free candidate (later) | real ELF under readelf/objdump shows no shared residues → residual class may become residual_free |
| Earn flip | **H5 only** — residual script + honesty checker + forge negatives |

Until option C evidence exists: **leave `GC_FREE_ELABORATOR=0`**. Classic shared + staged `GATE host_elaborator=PASS` remains correct.

#### H4 — host residual reduction (measurement checklist; not earned)

**Goal:** make the path from “classic stage1 with shared RC NEEDED” to a **measured residual_free host ELF** greppable and fail-closed — without forging tokens, without rewriting the elaborator in this step, and without weakening G3 earn rules. H4 documents **what to measure** and **what stage1 would have to change**; it does **not** ship a residual_free host binary and does **not** flip `GC_FREE_ELABORATOR=1`.

```
HOST_RESIDUAL_REDUCTION_PLAN=1
```

That marker is greppable plan honesty only (docs / driver comments). It is **not** an earn token, **not** `HOST_ELABORATOR_RESIDUAL=residual_free`, and **must never** be treated as `GC_FREE_ELABORATOR=1`. It is complementary to H3’s `HOST_DRIVER_RESIDUAL_PLAN=1` (isolation options) — H4 is the **measurement + stage1 change checklist** for residual reduction.

**SSoT earn rules unchanged:** `script/systems-host-elaborator-residual.sh` (header + measure helpers). Do not weaken them for H4. `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without earned residual_free still **FAIL**s.

| Still true on stage1 today | Token |
|----------------------------|--------|
| Shared RC runtime NEEDED | `HOST_HAS_LEANSHARED=1` |
| Host residual class | `HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime` |
| Measured elaborator GC-free | `GC_FREE_ELABORATOR=0` |
| Product wire (independent) | `PRODUCT_GC_FREE=1` possible via H2 nm path |

##### Measurement checklist — future residual_free host ELF

Use this checklist against a **real candidate host ELF** (never a shell wrapper, never an empty +x stub). G3 SSoT remains `./script/systems-host-elaborator-residual.sh` with `SYSTEMS_LEAN_TCB_LEAN=<candidate>`.

| # | Check | Pass criterion | Fail-closed notes |
|---|--------|----------------|-------------------|
| 1 | **ELF magic** | File is a regular ELF (`0x7f 'E' 'L' 'F'`) independent of readelf | Non-ELF / script / missing → `unmeasured`, never earn |
| 2 | **readelf NEEDED empty of Lean shared** | `readelf -d candidate \| NEEDED` has **no** `leanshared`, `leanshared_1`, `leanshared_2`, `Init_shared` substrings | Today stage1 **fails** this (has all four shared libs) |
| 3 | **objdump NEEDED empty of Lean shared** | `objdump -p candidate \| NEEDED` same absence | Same residue set as readelf |
| 4 | **Multi-scanner agreement** | When **both** readelf and objdump succeed, they must agree on shared-residue presence | Disagreement → `unmeasured`, never earn (`host_needed_method=disagree`) |
| 5 | **Earn method** | residual script method is `readelf`, `objdump`, or `readelf+objdump` with `earn_ok=1` | **ldd alone never earns** residual_free (ldd+shared → classic; ldd+clean → unmeasured) |
| 6 | **Residual script tokens** | Prints `HOST_HAS_LEANSHARED=0`, `HOST_ELABORATOR_RESIDUAL=residual_free`, `HOST_ELABORATOR_TCB=residual_free`, `GC_FREE_ELABORATOR=1`, `HOST_ELABORATOR_RESIDUAL_OK=1` | Exactly one of each axis; dual 0/1 rejected by honesty checker |
| 7 | **FORCE negative** | `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without residual_free still **FAIL**s | Negatives: `script/systems-host-elaborator-residual-negatives.sh` |
| 8 | **Product independence** | Candidate host residual does **not** change product wire | `PRODUCT_GC_FREE` remains product nm / IR only |

Greppable measure recipe (classic stage1 today vs future candidate):

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"

# --- Today (honest classic residual) ---
./script/systems-host-elaborator-residual.sh | tee /tmp/host-residual.out
# expect:
#   HOST_HAS_LEANSHARED=1
#   HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
#   GC_FREE_ELABORATOR=0

# Manual NEEDED audit (must match residual script scanners):
readelf -d build/release/stage1/bin/lean | grep NEEDED
objdump -p build/release/stage1/bin/lean | grep NEEDED
# stage1 today includes: libInit_shared.so, libleanshared{,_1,_2}.so

# --- Future residual_free candidate (do not forge tokens by hand) ---
# SYSTEMS_LEAN_TCB_LEAN=/path/to/candidate-lean ./script/systems-host-elaborator-residual.sh
# Earn only when residual script itself prints residual_free + HOST_HAS_LEANSHARED=0 + GC_FREE_ELABORATOR=1
# with method readelf and/or objdump (never ldd alone).
```

What “NEEDED empty of leanshared/Init_shared” means under scanners (bash pattern match in residual script):

- Residue substrings: `leanshared` **or** `Init_shared` anywhere in NEEDED/ldd text
- Covers: `libleanshared.so`, `libleanshared_1.so`, `libleanshared_2.so`, `libInit_shared.so` (and Darwin `.dylib` forms)
- Other NEEDED (libc, libstdc++, libgmp, libuv, libssl, …) are **out of scope** for G3 residual class — they do not block residual_free earn

##### What stage1 would need to change (not done)

Stage1 `bin/lean` is a thin ELF whose dynamic deps come from the Lean shared runtime split. Relevant link/build facts (see `src/CMakeLists.txt`, `src/shell/`):

| Layer | Today | Residual reduction would require |
|-------|--------|-----------------------------------|
| `bin/lean` link line | `CMAKE_EXE_LINKER_FLAGS` includes `-lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared` | Link line **without** those shared libs (static host, or non-shared host driver that does not NEED them) |
| Shell entry | `src/shell/lean.cpp` + `leanmain`; real `main` lives in shared runtime (`util/shell.cpp` in `libleanshared`) to avoid cross-lib C++ issues | Relocate / re-link shell so the host ELF does not dynlink `libleanshared*` for entry |
| Shared targets | CMake builds `Init_shared`, `leanshared{,_1,_2}` as shared libraries consumed by `lean` | Either static archive host build, freestanding host driver, or experimental non-shared lean — **out of band for H4 docs** |
| Plugin / leanc model | Plugins and leanc assume shared lean symbols at load time | Any residual_free host must preserve or re-specify plugin ABI honestly (do not silently break classic) |
| Measure pin | G3 measures `SYSTEMS_LEAN_TCB_LEAN` / stage1 `bin/lean` | Point measure at the **new** host ELF only after it is a real residual_free candidate |

This is intentionally a **multi-year / large rewrite surface** if the goal is a full elaborator without RC. H4 does **not** require that rewrite to complete; it only requires the measurement path stay honest while reduction work proceeds.

Honest intermediate steps that still leave `GC_FREE_ELABORATOR=0`:

1. Shrink Meta/RC **use** on product-facing host entrypoints (less RC traffic) without dropping NEEDED — **metrics only**, not residual_free.
2. Keep `lean-systems` as a thin shell (H3 option A/B) so **product** gates need no elaborator.
3. Only a real host ELF with clean NEEDED under multi-scanner agreement can proceed to H5 earn.

##### lean-systems subcommands vs elaborator need

Which driver commands need classic stage1 `lean` today, and which could stay lean-free even after residual reduction:

| Subcommand | Needs stage1 `lean` today? | After residual reduction (eventual) | Notes |
|------------|---------------------------|--------------------------------------|--------|
| `--version` / `-v` | optional (`lean --version` if on PATH) | **can avoid** lean | Driver identity + honesty banner only |
| `--help` / `-h` | **no** | **avoids** lean | Pure shell help |
| `check` | **no** (product nm only) | **avoids** lean | Already product-only; dual honesty re-measures host as advisory |
| `build` | **yes** (`lake` → elaborates FS modules via `lean`) | **still needs** a host elaborator ELF | Residual_free earn applies to that ELF, not to skipping elaboration |
| `compile FILE.lean` | **yes** (`lean` emit C) | **still needs** a host elaborator ELF | Same as build for Meta/RC NEEDED |
| `lean …` / `-- …` | **yes** (forwards to stage1 lean) | **still needs** host elaborator | Explicit elaborator front door |
| `selfhost` | **yes** for build + tiny compile legs; check/negatives product-side | build/compile still need elaborator; check stays product-only | Mixed path; product residual independent |

**Feasible without multi-year rewrite:** keep expanding product-only surfaces (`check`, link-check, consumer recipes, inventory) so operators can validate embed residual without invoking lean. **Not feasible without host rewrite:** claiming `GC_FREE_ELABORATOR=1` while `build`/`compile` still dynlink `libleanshared*` / `Init_shared`.

##### What H4 is not

- Not a shipped residual_free host binary (stage1 still classic).
- Not H5 / not `GC_FREE_ELABORATOR=1` until G3 earns it on a real ELF.
- Not permission to hardcode elaborator=1, weaken FORCE negatives, or treat plan markers as earn tokens.
- Not a product residual claim (product stays H2 / `PRODUCT_GC_FREE`).
- Not “wrapper has no NEEDED ⇒ elaborator residual_free” (G3 measures the **lean** ELF).

##### Done when (H4 plan evidence vs later earn)

| Checkpoint | Evidence |
|------------|----------|
| Measurement checklist documented | this section + greppable `HOST_RESIDUAL_REDUCTION_PLAN=1` |
| Multi-scanner / NEEDED criteria explicit | readelf+objdump agreement; ldd never earns; residual substrings listed |
| stage1 change surface named | CMake link flags + shell/shared split (above table) |
| Subcommand lean-need matrix | table above; `check` already product-only |
| Residual_free candidate (later) | real ELF under checklist rows 1–6 |
| Earn flip | **H5 only** — residual script + honesty checker + forge negatives |

Until a candidate passes the residual script earn path: **leave `GC_FREE_ELABORATOR=0`**. Classic shared + staged `GATE host_elaborator=PASS` remains correct.

#### H5 — host elaborator residual earn path (progress / prototype worklist / measured baseline / W0 verified docs / W1 experiment + candidate protocol / next experiment step / negative candidates / earn checklist / FORCE refusal contract / FORCE negative measured receipt / status-quo stage1 summary / docs ladder complete; not earned)

**Goal:** make the **next engineering steps** from H1–H4 plan docs to a **measured residual_free host ELF** greppable and fail-closed — without forging tokens, without claiming elaborator GC-free on stage1, and without weakening G3 earn rules. H5 path documentation is **progress toward earn**, not earn itself. Today stage1 still NEEDs shared Lean RC → `GC_FREE_ELABORATOR=0`.

```
HOST_ELABORATOR_EARN_PATH=1
HOST_ELABORATOR_PROTOTYPE_WORKLIST=1
HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared
HOST_ELABORATOR_W0_VERIFIED_DOCS=1
HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1
HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1
HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1
HOST_ELABORATOR_NEGATIVE_CANDIDATES=1
HOST_ELABORATOR_EARN_CHECKLIST=1
HOST_ELABORATOR_FORCE_REFUSAL=1
HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1
HOST_ELABORATOR_STATUS_QUO=1
HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1
```

Those markers are greppable **plan/path/baseline/docs honesty only** (docs / `lean-systems` dual residual block). They are **not** earn tokens, **not** `HOST_ELABORATOR_RESIDUAL=residual_free`, and **must never** be treated as `GC_FREE_ELABORATOR=1`. `HOST_ELABORATOR_W0_VERIFIED_DOCS=1` means § H5 includes a **verified classic residual snapshot** dry-run transcript (W0) — documentation that stage1 still measures classic RC shared, **not** residual_free. `HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1` means § H5 includes the **W1 static-link / thin-driver experiment protocol** (ordered try → measure → residual_free-only success rules) — **docs honesty only**, not residual_free. `HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1` means § H5 includes the **measurable candidate protocol** (how to pin a future static lean / lean-systems-only thin driver via `SYSTEMS_LEAN_HOST_ELF` and re-measure; classic stage1 dry-run still `=0`) — **docs honesty only**, not residual_free. `HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1` means § H5 names the **concrete first-candidate binary identity** for the next out-of-band experiment (H5.E3) — **docs honesty only**, not residual_free. `HOST_ELABORATOR_NEGATIVE_CANDIDATES=1` means § H5 lists **binaries and paths that must never be treated as residual_free host elaborator candidates** (H5.E4: `lean-systems` product shell, other scripts, non-ELF / empty +x) — **docs honesty only**, not residual_free. `HOST_ELABORATOR_EARN_CHECKLIST=1` means § H5 includes the **fail-closed residual_free candidate checklist** (what a residual_free host ELF must prove: ELF magic, NEEDED empty of `leanshared`/`Init_shared` under readelf and/or objdump agreement, no FORCE forge, product independence) — **docs honesty only**, not residual_free. `HOST_ELABORATOR_FORCE_REFUSAL=1` means § H5 documents the **FORCE/negative refusal contract** — `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without earned residual_free must **FAIL** on all residual-script exit paths; greppable docs honesty only, **not** residual_free earn. `HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1` means § H5 includes a **measured FORCE-without-residual_free fail receipt** (classic stage1 dry-run + negatives suite) — greppable measured honesty only, **not** residual_free earn. `HOST_ELABORATOR_STATUS_QUO=1` means § H5 includes a **status-quo stage1 summary box** consolidating the resting measured tokens (`HOST_HAS_LEANSHARED=1`, `GC_FREE_ELABORATOR=0`, classic_RC) until earn — greppable docs honesty only, **not** residual_free earn. `HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1` means the H5 **docs ladder** (path / worklist / baseline / W0–W1 / E1–E4 / earn checklist / FORCE refusal + measured receipt / STATUS_QUO) is **docs-complete** — only a real residual_free host ELF remains for earn; greppable docs honesty only, **not** residual_free earn. Complementary markers: H3 `HOST_DRIVER_RESIDUAL_PLAN=1` (isolation options), H4 `HOST_RESIDUAL_REDUCTION_PLAN=1` (measurement checklist). H5 is the **prototype worklist + earn path + measured stage1 baseline + W0 verified dry-run + W1 experiment protocol + W1 candidate measure protocol + next experiment step + negative candidates + fail-closed earn checklist + FORCE refusal contract + FORCE negative measured receipt + status-quo stage1 summary + docs ladder complete** that reuses the H4 checklist against a real candidate ELF.

**SSoT earn rules unchanged:** `script/systems-host-elaborator-residual.sh` (header + measure helpers). Do not weaken them for H5. `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without earned residual_free still **FAIL**s. Earn flips **only** when that script measures residual_free under multi-scanner agreement (readelf and/or objdump; ldd never earns).

| Still true on stage1 today | Token |
|----------------------------|--------|
| Shared RC runtime NEEDED | `HOST_HAS_LEANSHARED=1` |
| Host residual class | `HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime` |
| Measured elaborator GC-free | `GC_FREE_ELABORATOR=0` |
| Path honesty (not earn) | `HOST_ELABORATOR_EARN_PATH=1` |
| Prototype worklist honesty (not earn) | `HOST_ELABORATOR_PROTOTYPE_WORKLIST=1` |
| Stage1 residual baseline honesty (not earn) | `HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared` |
| W0 verified docs honesty (not earn) | `HOST_ELABORATOR_W0_VERIFIED_DOCS=1` |
| W1 experiment protocol honesty (not earn) | `HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1` |
| W1 candidate measure protocol honesty (not earn) | `HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1` |
| Next experiment step honesty (not earn) | `HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1` |
| Negative candidate identities honesty (not earn) | `HOST_ELABORATOR_NEGATIVE_CANDIDATES=1` |
| Fail-closed residual_free earn checklist honesty (not earn) | `HOST_ELABORATOR_EARN_CHECKLIST=1` |
| FORCE/negative refusal contract honesty (not earn) | `HOST_ELABORATOR_FORCE_REFUSAL=1` |
| FORCE negative measured receipt honesty (not earn) | `HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1` |
| Status-quo stage1 summary honesty (not earn) | `HOST_ELABORATOR_STATUS_QUO=1` |
| Docs ladder complete honesty (not earn) | `HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1` |
| Product wire (independent) | `PRODUCT_GC_FREE=1` possible via H2 nm path |

##### Measured stage1 residual snapshot (honest baseline; re-run after rebuild)

This subsection records the **measured** classic stage1 residual class. It is plan honesty + audit trail — **not** residual_free earn. Re-run the recipe after any stage1 link change; if scanners disagree with the expected tokens below, treat the snapshot as stale and update docs (do **not** forge `GC_FREE_ELABORATOR=1`).

**Exact measure recipe** (repo root; prefer stage1 on `PATH`):

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
# SSoT residual script on default stage1 lean (or pin explicitly):
./script/systems-host-elaborator-residual.sh
# equivalent pin:
# SYSTEMS_LEAN_TCB_LEAN="$PWD/build/release/stage1/bin/lean" ./script/systems-host-elaborator-residual.sh
```

**Expected tokens on classic stage1 today** (must match residual script stdout):

```
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=1
```

**Greppable baseline marker** (docs / `lean-systems` dual residual only; **not** an earn token):

```
HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared
```

Meaning: measured host class is classic shared RC (`HOST_HAS_LEANSHARED=1` / `GC_FREE_ELABORATOR=0`). Short form `classic_RC_shared` is plan honesty; residual script still emits the full class `classic_RC_shared_runtime`.

**Greppable W0 verified-docs marker** (docs / `lean-systems` dual residual only; **not** residual_free, **not** earn):

```
HOST_ELABORATOR_W0_VERIFIED_DOCS=1
```

Meaning: this section includes a **verified classic residual snapshot** dry-run transcript for W0 (exact commands + greppable stage1 tokens). It documents honesty of the classic baseline — **never** treat as `HOST_ELABORATOR_RESIDUAL=residual_free` or `GC_FREE_ELABORATOR=1`.

**Manual NEEDED audit** (must agree with residual script scanners; prefer `/usr/bin` pins):

```bash
/usr/bin/readelf -d build/release/stage1/bin/lean | grep NEEDED
/usr/bin/objdump -p build/release/stage1/bin/lean | grep NEEDED
/usr/bin/readelf -d build/release/stage1/bin/lean \
  | rg -o 'lib(Init_shared|leanshared(_[0-9]+)?)\.so' | sort -u
# → libInit_shared.so / libleanshared.so / libleanshared_1.so / libleanshared_2.so
```

**W0 CMake lines that currently inject shared Lean RC on the host link line** (cite in-tree sources; do not invent flags):

| Path | Role |
|------|------|
| `src/CMakeLists.txt` **line 933** | Non-Emscripten: `string(APPEND CMAKE_EXE_LINKER_FLAGS " -lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared")` — primary host-exe NEEDED inject |
| `src/CMakeLists.txt` **line 611** | Windows: `string(APPEND LEANC_SHARED_LINKER_FLAGS " -lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared")` — plugins / leanc shared |
| `src/shell/CMakeLists.txt` **line 41** | `lean ALL DEPENDS leanshared leanmain` — shell target depends on shared stack (not the `-l` flags themselves) |
| `src/CMakeLists.txt` custom targets `Init_shared` / `leanshared` | Built via `$(MAKE) -f ${CMAKE_BINARY_DIR}/stdlib.make …` (shared libs that stage1 dynlinks) |

**H5.E1 — W0 CMake inject re-verify (no drift):** re-ran
`rg -n 'lInit_shared|lleanshared|Init_shared|leanshared' src/CMakeLists.txt src/shell/CMakeLists.txt`
against in-tree sources. Primary inject strings and line cites still match reality:

| Cite (this re-verify) | Status |
|-----------------------|--------|
| `src/CMakeLists.txt:933` `CMAKE_EXE_LINKER_FLAGS` `-lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared` | **unchanged** (still primary host-exe NEEDED inject) |
| `src/CMakeLists.txt:611` `LEANC_SHARED_LINKER_FLAGS` same `-l` quartet | **unchanged** (Windows plugins / leanc shared) |
| `src/shell/CMakeLists.txt:41` `DEPENDS leanshared leanmain` | **unchanged** (shell target depends on shared stack) |

No line-number drift on these three inject sites at re-verify time. If a future CMake edit moves them, update the table above and the W0 dry-run transcript comments with new line cites — **do not** invent alternate inject flags. Residual class on classic stage1 remains blocked by those NEEDED sonames regardless of exact line numbers.

```bash
# Re-confirm inject sites after CMake edits:
rg -n 'lInit_shared|lleanshared|Init_shared|leanshared' src/CMakeLists.txt src/shell/CMakeLists.txt
```

| Snapshot field | Classic stage1 value |
|----------------|----------------------|
| Measured ELF | `build/release/stage1/bin/lean` |
| Lean shared NEEDED | `libInit_shared.so`, `libleanshared.so`, `libleanshared_1.so`, `libleanshared_2.so` |
| Residual class | `classic_RC_shared_runtime` |
| Baseline marker | `HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared` |
| `GC_FREE_ELABORATOR` | **0** (honest; never forged) |

##### What still blocks earn today

| Blocker | Evidence |
|---------|----------|
| stage1 `bin/lean` NEEDs Lean shared runtime | `readelf -d` / `objdump -p` show `libInit_shared.so`, `libleanshared{,_1,_2}.so` |
| Residual script class on stage1 | `HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime` |
| Measured flag | `GC_FREE_ELABORATOR=0` (honest; never forged) |
| Baseline marker | `HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared` (plan honesty; matches measure) |
| Shell entry lives in shared runtime | `main` / shell glue in `libleanshared` — thin `bin/lean` dynlinks shared stack (see H4 stage1 change table) |
| Plugin / leanc model assumes shared symbols | Residual_free host must re-specify plugin ABI honestly (do not silently break classic) |

**Bottom line:** no residual_free host ELF exists in-tree yet. Path/worklist/baseline markers and dual residual print do **not** flip earn. Classic shared + `GATE host_elaborator=PASS` with `=0` remains correct staged behavior.

##### Prototype worklist (ordered; plan only — not earn)

Marker for this worklist (docs / `lean-systems` dual residual / help):

```
HOST_ELABORATOR_PROTOTYPE_WORKLIST=1
```

**Never** treat this marker as residual_free or as `GC_FREE_ELABORATOR=1`. Steps below are ordered, fail-closed experiments. None mint earn tokens until G3 residual script agrees on a **real ELF** under multi-scanner agreement. Prefer extending docs + `lean-systems` over new `script/systems-*.sh` gates.

| Step | Action | Earn? | Done when |
|------|--------|-------|-----------|
| **W0** | Identify stage1 link-line sources that pull `-lleanshared*` / `-lInit_shared` (CMake + shell) | **no** | Grep recipe below matches in-tree sources; expected NEEDED tokens match stage1 |
| **W1** | Experimental **static-link sketch** *or* thin **non-elaborator** host driver (product path only); experiment protocol below | **no** | Protocol documented (`HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1`); optional out-of-band binary; never claims elaborator GC-free |
| **W2** | Measurement gate on any `SYSTEMS_LEAN_HOST_ELF` / `SYSTEMS_LEAN_TCB_LEAN` candidate | **only if residual_free** | Residual script multi-scanner; **ldd never earns** |
| **W3** | Residual_free host ELF under scanners + honesty checker + FORCE negatives | **yes (H5 earn)** | Residual script prints residual_free + `HOST_HAS_LEANSHARED=0` + `GC_FREE_ELABORATOR=1` |

###### W0 — Identify stage1 link-line sources (CMake)

Exact fail-closed dry-run (re-run after CMake edits; do **not** invent link lines):

```bash
# From lean4 repo root — sources that inject shared Lean RC on the host link line
rg -n 'lInit_shared|lleanshared|Init_shared|leanshared' src/CMakeLists.txt src/shell/CMakeLists.txt

# Primary host-exe inject (non-Emscripten):
#   src/CMakeLists.txt ≈ line with:
#     string(APPEND CMAKE_EXE_LINKER_FLAGS " -lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared")
# Windows plugins (leanc shared) also use the same -l quartet via LEANC_SHARED_LINKER_FLAGS.
# Shell target depends on shared stack (not the -l flags themselves):
#   src/shell/CMakeLists.txt: lean ALL DEPENDS leanshared leanmain
# Shared libs themselves are built via stdlib.make targets Init_shared / leanshared
#   (src/CMakeLists.txt custom targets → $(MAKE) -f ${CMAKE_BINARY_DIR}/stdlib.make …).
```

**Expected NEEDED residue tokens on classic stage1 `bin/lean` today** (Linux; re-check after rebuild):

| NEEDED soname | Residual class impact |
|---------------|----------------------|
| `libInit_shared.so` | blocks residual_free (`Init_shared` substring) |
| `libleanshared_2.so` | blocks residual_free (`leanshared` substring) |
| `libleanshared_1.so` | blocks residual_free (`leanshared` substring) |
| `libleanshared.so` | blocks residual_free (`leanshared` substring) |
| `libstdc++.so.6`, `libgmp.so.10`, `libuv.so.1`, `libssl.so.3`, `libcrypto.so.3`, `libm.so.6`, `libc.so.6` | **out of scope** for G3 residual class (do not block earn) |

```bash
# Manual NEEDED audit (must match residual script scanners; prefer /usr/bin pins)
/usr/bin/readelf -d build/release/stage1/bin/lean | grep NEEDED
/usr/bin/objdump -p build/release/stage1/bin/lean | grep NEEDED
# Residue extract (expect exactly these four Lean shared names on classic stage1):
/usr/bin/readelf -d build/release/stage1/bin/lean \
  | rg -o 'lib(Init_shared|leanshared(_[0-9]+)?)\.so' | sort -u
# → libInit_shared.so / libleanshared.so / libleanshared_1.so / libleanshared_2.so

# Residual script SSoT (must stay =0 on stage1):
./script/systems-host-elaborator-residual.sh
# → HOST_HAS_LEANSHARED=1  HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime  GC_FREE_ELABORATOR=0
```

A residual_free **candidate** would need a link line that **omits** `-lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared` (and produces no `leanshared` / `Init_shared` NEEDED). Keep classic stage1 green; any prototype uses a **separate** CMake option / output path (do **not** break default stage1).

###### W0 verification dry-run transcript template (classic stage1; not residual_free)

Copy-paste dry-run against **current stage1** (repo root). Purpose: re-verify W0 CMake inject sites + residual script classic tokens after rebuilds. Expected result is **still classic** (`HOST_HAS_LEANSHARED=1` / `GC_FREE_ELABORATOR=0`). This template documents a verified classic residual snapshot — marker `HOST_ELABORATOR_W0_VERIFIED_DOCS=1` — **not** residual_free earn.

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"

# --- (1) W0 CMake inject sites (must still match in-tree sources) ---
rg -n 'lInit_shared|lleanshared|Init_shared|leanshared' src/CMakeLists.txt src/shell/CMakeLists.txt
# greppable inject lines (line numbers may drift; strings must remain):
#   src/CMakeLists.txt:933: string(APPEND CMAKE_EXE_LINKER_FLAGS " -lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared")
#   src/CMakeLists.txt:611: string(APPEND LEANC_SHARED_LINKER_FLAGS " -lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared")
#   src/shell/CMakeLists.txt:41: DEPENDS leanshared leanmain

# --- (2) Manual NEEDED residue extract (Lean shared only) ---
/usr/bin/readelf -d build/release/stage1/bin/lean \
  | rg -o 'lib(Init_shared|leanshared(_[0-9]+)?)\.so' | sort -u
# expected greppable lines (classic stage1; blocks earn):
#   libInit_shared.so
#   libleanshared.so
#   libleanshared_1.so
#   libleanshared_2.so

# --- (3) Residual script SSoT (stdout tokens; advisory measure) ---
./script/systems-host-elaborator-residual.sh
# expected greppable stdout (exact keys=values on classic stage1 today):
#   HOST_HAS_LEANSHARED=1
#   HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
#   HOST_ELABORATOR_TCB=classic_RC_shared_runtime
#   GC_FREE_ELABORATOR=0
#   HOST_ELABORATOR_RESIDUAL_OK=1

# --- (4) Dual residual honesty (product may be 1; host measured =0) ---
./script/lean-systems check
# expected greppable plan/docs markers (not earn):
#   HOST_DRIVER_RESIDUAL_PLAN=1
#   HOST_RESIDUAL_REDUCTION_PLAN=1
#   HOST_ELABORATOR_EARN_PATH=1
#   HOST_ELABORATOR_PROTOTYPE_WORKLIST=1
#   HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared
#   HOST_ELABORATOR_W0_VERIFIED_DOCS=1
#   HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1
#   HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1
#   HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1
#   HOST_ELABORATOR_NEGATIVE_CANDIDATES=1
# expected greppable measured host (still classic):
#   HOST_HAS_LEANSHARED=1
#   HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
#   GC_FREE_ELABORATOR=0
# product axis independent (when bundle residual-clean):
#   PRODUCT_GC_FREE=1
```

**Verified classic residual snapshot tokens** (paste-target for re-runs; from residual script stdout, not forged):

```
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=1
```

If a re-run diverges (missing Lean shared NEEDED, residual_free, or `GC_FREE_ELABORATOR=1` on default stage1 without a deliberate prototype), treat the snapshot as **stale or suspicious** — update docs only after multi-scanner agreement; never hand-edit residual script tokens to match this template.

###### W1 — Static-link / thin-driver experiment protocol (docs only; not residual_free)

**Greppable W1 experiment-protocol marker** (docs / `lean-systems` dual residual only; **not** residual_free, **not** earn):

```
HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1
```

Meaning: this section includes the ordered W1 **static-link shell vs product-only thin-driver** experiment protocol (what to try → how to measure with `SYSTEMS_LEAN_HOST_ELF` → success only under multi-scanner residual_free). **Never** treat as `HOST_ELABORATOR_RESIDUAL=residual_free` or `GC_FREE_ELABORATOR=1`. Protocol docs do **not** mint earn tokens.

Two complementary sketches; neither claims elaborator GC-free:

| Sketch | Idea | Claims elaborator GC-free? |
|--------|------|----------------------------|
| **Static-link lean shell (experimental, out-of-band)** | Build lean (or a slim host binary) against **static archives** of runtime objects instead of `libleanshared*.so` / `libInit_shared.so` (omit `-lInit_shared -lleanshared_*` on a **separate** CMake option / output path; keep classic stage1 green). Measure the resulting ELF with the residual script / H4 checklist. Static-with-RC is **not** residual_free if NEEDED still lists shared Lean residues; static-without-shared-NEEDED is only a **candidate** for residual-script measure. | **never by hand** — residual script only |
| **Product-only thin driver (shipped honesty)** | `script/lean-systems` is a shell wrapper (H3 option A). Product `check` is nm-only and needs no elaborator. Driver may print path/worklist/W1-protocol markers and re-measure host residual; it **must not** print `GC_FREE_ELABORATOR=1` unless the residual script earned it. `build` / `compile` still need a host elaborator ELF. Product path residual (`PRODUCT_GC_FREE`) stays independent of host. | **no** — product path only |

**Ordered experiment protocol** (try → measure → accept only residual_free):

1. **What to try**
   - **A. Static archive lean shell:** out-of-band host binary linked against static runtime archives (no dynlink of `libleanshared*` / `Init_shared`). Prefer a separate CMake option / install path so default stage1 stays classic.
   - **B. Product-only lean-systems path:** keep using thin driver for product embed/check; do **not** treat wrapper absence of NEEDED as elaborator residual_free. Use this path to re-measure host honesty while product stays residual-clean.
2. **How to measure a candidate with `SYSTEMS_LEAN_HOST_ELF`**
   - Pin the candidate ELF (real file path; not a shell wrapper):
     ```bash
     # Residual script SSoT (preferred direct pin):
     SYSTEMS_LEAN_TCB_LEAN=/path/to/candidate-lean ./script/systems-host-elaborator-residual.sh
     # Dual honesty alias (maps SYSTEMS_LEAN_HOST_ELF → SYSTEMS_LEAN_TCB_LEAN for that call only):
     SYSTEMS_LEAN_HOST_ELF=/path/to/candidate-lean ./script/lean-systems check
     # Unset → classic stage1 measure → expect GC_FREE_ELABORATOR=0
     ```
   - Manual NEEDED audit must agree with residual script scanners (prefer `/usr/bin` pins):
     ```bash
     /usr/bin/readelf -d /path/to/candidate-lean | grep NEEDED
     /usr/bin/objdump -p /path/to/candidate-lean | grep NEEDED
     ```
3. **Success criteria (explicit — no false earn)**
   - Success **only if** residual script measures **`residual_free` under multi-scanner agreement** (readelf and/or objdump NEEDED empty of `leanshared` / `Init_shared`; agreement when both present).
   - **`ldd` never earns** residual_free (ldd+shared → classic; ldd+clean → unmeasured). Do not treat `ldd` “not a dynamic executable” / clean output as earn.
   - Earn tokens come **only** from residual script stdout (`HOST_HAS_LEANSHARED=0`, `HOST_ELABORATOR_RESIDUAL=residual_free`, `GC_FREE_ELABORATOR=1`). Hand-edited tokens / FORCE without residual_free → **FAIL**.
   - Non-ELF (shell scripts / empty +x / `lean-systems` itself) → **unmeasured**, never earn.
4. **Honest failure modes on today’s tree**
   - Classic stage1 still NEEDs Lean shared → `GC_FREE_ELABORATOR=0` (correct).
   - Product-only thin driver success (`PRODUCT_GC_FREE=1`) does **not** imply host residual_free.
   - W1 protocol marker greppable while host still measured `=0` is **expected** path progress, not earn.

Do **not** ship a forged residual_free host. Shell wrappers / empty +x stubs are non-ELF → residual script **unmeasured**, never earn.

###### W1 — Measurable candidate protocol (H5.E2; docs only; not residual_free)

**Greppable W1 candidate-protocol marker** (docs / `lean-systems` dual residual only; **not** residual_free, **not** earn):

```
HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1
```

Meaning: this subsection documents a **measurable** way to point residual scanners at a future host-ELF candidate (static lean shell **or** lean-systems-only thin driver product path) via `SYSTEMS_LEAN_HOST_ELF`, plus an optional classic-stage1 dry-run that **must still measure `GC_FREE_ELABORATOR=0`**. Complementary to `HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1` (what to try / success rules): this marker is the **pin → measure → record** recipe only. **Never** treat as earn.

**Candidate shapes (future; none residual_free in-tree today)**

| Candidate shape | How it would exist | How to point measure |
|-----------------|--------------------|----------------------|
| **Static lean host ELF** (out-of-band) | Separate CMake option / install path: link lean shell against static runtime archives; **omit** `-lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared` on that path only (keep default stage1 classic green). Primary inject sites still at `src/CMakeLists.txt:933` / `:611` / `src/shell/CMakeLists.txt:41` for classic. | `SYSTEMS_LEAN_HOST_ELF=/path/to/static-lean` or `SYSTEMS_LEAN_TCB_LEAN=…` |
| **lean-systems-only thin driver** (product path; shipped honesty) | `script/lean-systems` is a shell wrapper (not a lean elaborator ELF). Product `check` needs no elaborator. Do **not** pass the wrapper itself as `SYSTEMS_LEAN_HOST_ELF` (non-ELF → unmeasured). Use the driver to **re-measure** classic stage1 or a real candidate ELF. | Unset → classic stage1; or pin a **real** candidate ELF path |
| **Classic stage1** (today's honest baseline) | `build/release/stage1/bin/lean` dynlinks Lean shared RC | Unset `SYSTEMS_LEAN_HOST_ELF` **or** pin stage1 path; expect `=0` |

**Pin recipe (`SYSTEMS_LEAN_HOST_ELF`)**

```bash
# Residual script SSoT (direct pin; preferred for earn attempts):
SYSTEMS_LEAN_TCB_LEAN=/path/to/candidate-lean ./script/systems-host-elaborator-residual.sh

# Dual honesty alias: lean-systems maps SYSTEMS_LEAN_HOST_ELF → SYSTEMS_LEAN_TCB_LEAN
# for the residual-script call only (product nm gate still independent):
SYSTEMS_LEAN_HOST_ELF=/path/to/candidate-lean ./script/lean-systems check

# Unset / classic stage1 → measured classic residual (honest):
unset SYSTEMS_LEAN_HOST_ELF
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
./script/systems-host-elaborator-residual.sh
# → HOST_HAS_LEANSHARED=1  HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime  GC_FREE_ELABORATOR=0
```

**Optional classic dry-run (still measures host =0; not residual_free)**

Copy-paste against **current stage1**. Purpose: prove the candidate-protocol pin path is live while default host remains classic. Expected result is **still** `GC_FREE_ELABORATOR=0`. Marker `HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1` documents the protocol — **not** earn.

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"

# (1) Explicit classic pin via SYSTEMS_LEAN_HOST_ELF (same ELF residual script would default to)
SYSTEMS_LEAN_HOST_ELF="$PWD/build/release/stage1/bin/lean" \
  ./script/systems-host-elaborator-residual.sh
# expected greppable (classic; blocks earn):
#   HOST_HAS_LEANSHARED=1
#   HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
#   GC_FREE_ELABORATOR=0

# (2) Dual residual honesty with classic pin (product may be 1; host measured =0)
SYSTEMS_LEAN_HOST_ELF="$PWD/build/release/stage1/bin/lean" ./script/lean-systems check
# expected greppable plan/docs markers (not earn):
#   HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1
#   HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1
#   HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1
#   HOST_ELABORATOR_NEGATIVE_CANDIDATES=1
# expected greppable measured host (still classic):
#   HOST_HAS_LEANSHARED=1
#   GC_FREE_ELABORATOR=0
# product axis independent (when bundle residual-clean):
#   PRODUCT_GC_FREE=1

# (3) Unset pin — same classic measure (default stage1 / SYSTEMS_LEAN_TCB_LEAN)
unset SYSTEMS_LEAN_HOST_ELF
./script/systems-host-elaborator-residual.sh
# → still GC_FREE_ELABORATOR=0 on classic stage1
```

**Success vs dry-run honesty**

| Outcome | When | Earn? |
|---------|------|-------|
| Classic dry-run (`HOST_HAS_LEANSHARED=1` / `GC_FREE_ELABORATOR=0`) | stage1 pin or unset today | **no** (expected path progress) |
| residual_free under multi-scanner agreement | real candidate ELF; residual script prints residual_free + `HOST_HAS_LEANSHARED=0` + `GC_FREE_ELABORATOR=1` | **yes (W3 / H5 earn)** — residual script only |
| Non-ELF / wrapper / empty +x as `SYSTEMS_LEAN_HOST_ELF` | e.g. pointing at `lean-systems` itself | **never** (unmeasured) |
| `ldd` clean alone | any candidate | **never** (ldd never earns) |

Until a real residual_free candidate ELF exists: leave `GC_FREE_ELABORATOR=0`. This protocol does **not** mint tokens; it only documents how a future static lean or thin-driver-adjacent host ELF would be measured.

###### H5.E3 — Concrete next experiment step (docs only; not residual_free)

**Greppable next-experiment-step marker** (docs / `lean-systems` dual residual only; **not** residual_free, **not** earn):

```
HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1
```

Meaning: this subsection names **what binary is (and is not) the first residual-measure candidate**, so the next out-of-band experiment is concrete rather than aspirational. Complementary to H5.E2 (pin → measure recipe) and W1 experiment protocol (what to try / success rules). **Never** treat as earn.

**Binary identity (first candidate vs anti-candidates)**

| Artifact | Role | Pin as `SYSTEMS_LEAN_HOST_ELF`? | Expected measure today |
|----------|------|--------------------------------|------------------------|
| `build/release/stage1/bin/lean` | **Classic elaborator host** (default stage1) | yes (or leave unset) | `HOST_HAS_LEANSHARED=1` / `GC_FREE_ELABORATOR=0` — **honest baseline** |
| `script/lean-systems` (and installed `out/systems-selfhost/bin/lean-systems`) | **Product path driver only** — Bourne shell wrapper; freestanding embed/check; **not** an elaborator ELF | **never** (non-ELF → unmeasured) | product may still print `PRODUCT_GC_FREE=1`; host axis independent |
| Future out-of-band **`lean-host-static`** (suggested first real candidate name) | Separately-built host shell linked against **static** runtime archives; **omit** `-lInit_shared -lleanshared_2 -lleanshared_1 -lleanshared` on a **non-default** CMake option / install path | **yes** when a real ELF exists | residual script alone; earn **only** if residual_free under multi-scanner |
| Optional future static archive (suggested name only) | e.g. `liblean_host_static.a` — inputs to link `lean-host-static`; **not** itself a host ELF measure target | **no** (archive ≠ ELF) | n/a until linked into a candidate ELF |

**Concrete next experiment step (ordered; still not earn)**

1. **Keep default stage1 classic green.** Do not remove the shared `-l` quartet from default `CMAKE_EXE_LINKER_FLAGS` (`src/CMakeLists.txt:933`) / Windows `LEANC_SHARED_LINKER_FLAGS` (`:611`) / shell `DEPENDS` (`src/shell/CMakeLists.txt:41`). Prototypes stay out-of-band.
2. **Do not measure `lean-systems` as host elaborator.** Re-confirm with `file script/lean-systems` → shell script. Product `lean-systems check` remains the dual residual honesty printer (`PRODUCT_GC_FREE` vs measured host); it never substitutes for residual-script earn on a lean ELF.
3. **Sketch first candidate binary name:** install / output path such as `build/release/stage1-host-static/bin/lean-host-static` (name is a planning suggestion — not shipped). Link against static Lean runtime objects only; NEEDED must not list `libInit_shared.so` / `libleanshared{,_1,_2}.so`. Optional intermediate archive name: `liblean_host_static.a` (planning only).
4. **Measure the candidate only when a real ELF exists:**
   ```bash
   # Classic baseline must remain =0 (re-run any time):
   export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
   ./script/systems-host-elaborator-residual.sh
   # → HOST_HAS_LEANSHARED=1
   # → HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
   # → HOST_ELABORATOR_TCB=classic_RC_shared_runtime
   # → GC_FREE_ELABORATOR=0
   # → HOST_ELABORATOR_RESIDUAL_OK=1

   # Future (do not forge; path must be a real ELF):
   # SYSTEMS_LEAN_TCB_LEAN=/path/to/lean-host-static ./script/systems-host-elaborator-residual.sh
   # SYSTEMS_LEAN_HOST_ELF=/path/to/lean-host-static ./script/lean-systems check
   # Earn only when residual script prints residual_free + HOST_HAS_LEANSHARED=0 + GC_FREE_ELABORATOR=1
   # under multi-scanner agreement (ldd never earns).
   ```
5. **Record results honestly.** Classic stage1 tokens stay the baseline (`HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared`). A failed static-link experiment still leaves `GC_FREE_ELABORATOR=0`. Success is W2/W3 residual_free only — never hand-edited tokens.

**Classic stage1 residual baseline tokens** (re-verified this pass; residual script stdout; **not** residual_free):

```
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=1
```

**What H5.E3 does not claim**

- Not a shipped `lean-host-static` binary or `liblean_host_static.a`.
- Not residual_free / not `GC_FREE_ELABORATOR=1`.
- Not permission to pin `lean-systems` (shell) as host ELF.
- Not a change to default stage1 link lines or residual earn rules.

###### H5.E4 — Negative candidate identities (docs only; not residual_free)

**Greppable negative-candidates marker** (docs / `lean-systems` dual residual only; **not** residual_free, **not** earn):

```
HOST_ELABORATOR_NEGATIVE_CANDIDATES=1
```

Meaning: this subsection enumerates **identities that must never be treated as residual_free host elaborator candidates**. Complementary to H5.E3 (first-candidate identity: what *could* be measured later) and H5.E2 (how to pin a real candidate via `SYSTEMS_LEAN_HOST_ELF`). **Never** treat this marker as earn, residual_free, or `GC_FREE_ELABORATOR=1`.

**Negative candidates (must not be residual_free host elaborator targets)**

| Identity | Why it is a negative | If pinned as `SYSTEMS_LEAN_HOST_ELF` / `SYSTEMS_LEAN_TCB_LEAN` | Honest outcome |
|----------|----------------------|----------------------------------------------------------------|----------------|
| `script/lean-systems` | Product path **shell** driver (Bourne script); freestanding embed/check only; **not** an elaborator ELF | **never** for residual_free earn | residual script → **unmeasured** (non-ELF); never earn |
| Installed `out/systems-selfhost/bin/lean-systems` (or `$SYSTEMS_LEAN_PREFIX/bin/lean-systems`) | Same product shell wrapper after install | **never** | same as in-tree `lean-systems` |
| Other product / driver **scripts** under `script/` (e.g. `systems-selfhost.sh`, `systems-selfhost-link-check.sh`, residual helpers) | Shell or tooling; not host elaborator ELF | **never** | unmeasured or product-only; never host residual_free |
| Non-ELF paths (empty +x, text files, directories, archives) | G3 requires real ELF magic before NEEDED parse | **never** | **unmeasured**, never earn |
| Product static archive alone (e.g. `libfs_extract_bundle.a`, optional future `liblean_host_static.a`) | Archive ≠ host elaborator ELF measure target | **no** (not an ELF) | n/a until linked into a real host ELF |
| `ldd`-only “clean” view of any path | **ldd alone never earns** residual_free | n/a | classic if shared seen; else unmeasured — never residual_free from ldd alone |

**Rules (fail-closed)**

1. **Product shell ≠ elaborator.** `lean-systems check` may print `PRODUCT_GC_FREE=1` and dual residual honesty markers while host remains `GC_FREE_ELABORATOR=0`. That dual path is H2 honesty — **not** host residual_free.
2. **Do not pin negative identities for earn.** Pointing residual measure at `lean-systems` or any non-ELF must not be reported as residual_free success. Residual script stays SSoT: non-ELF → unmeasured.
3. **Only a real host lean ELF** (classic stage1 today; future out-of-band `lean-host-static` sketch when built) may ever reach residual_free under multi-scanner agreement (readelf and/or objdump; ldd never earns).
4. **Classic stage1 is still the measured host.** Negative-candidate docs do not change stage1 NEEDED or mint tokens:

```
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=1
```

**Quick re-check (negative path must not earn)**

```bash
# Product shell is not a residual_free host candidate:
file script/lean-systems
# → Bourne-Again shell script / ASCII text executable (not ELF)

# Pinning the shell must not mint residual_free:
# SYSTEMS_LEAN_TCB_LEAN="$PWD/script/lean-systems" ./script/systems-host-elaborator-residual.sh
# → unmeasured (or non-earn); never GC_FREE_ELABORATOR=1 from a non-ELF

# Default stage1 remains classic =0:
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
./script/systems-host-elaborator-residual.sh
# → HOST_HAS_LEANSHARED=1 / GC_FREE_ELABORATOR=0
```

**What H5.E4 does not claim**

- Not residual_free / not `GC_FREE_ELABORATOR=1`.
- Not a shipped residual_free host ELF.
- Not permission to treat `lean-systems` product success as elaborator GC-free.
- Not a change to G3 earn rules (non-ELF still unmeasured; ldd still never earns).

###### W2 — Measurement gate (fail-closed; ldd never earns)

Any `SYSTEMS_LEAN_HOST_ELF` / `SYSTEMS_LEAN_TCB_LEAN` candidate **must**:

1. Be a **real ELF** (ELF magic; not shell wrapper / empty +x).
2. Pass **readelf and/or objdump** NEEDED parse with no `leanshared` / `Init_shared` residues.
3. When **both** scanners are present: multi-scanner **agreement** (disagreement → not residual_free).
4. **ldd alone never earns** residual_free (ldd+shared → classic; ldd+clean → unmeasured).
5. Residual script alone may emit `HOST_HAS_LEANSHARED=0` + `HOST_ELABORATOR_RESIDUAL=residual_free` + `GC_FREE_ELABORATOR=1`.

```bash
# Point measure at a candidate (fail-closed pin; no PATH fallback when set)
SYSTEMS_LEAN_TCB_LEAN=/path/to/candidate-lean ./script/systems-host-elaborator-residual.sh
# or dual honesty alias (maps to SYSTEMS_LEAN_TCB_LEAN for that call only):
SYSTEMS_LEAN_HOST_ELF=/path/to/candidate-lean ./script/lean-systems check
# Unset → classic stage1 / default TCB lean → expect GC_FREE_ELABORATOR=0
```

###### W3 — Earn only on residual script multi-scanner agreement

Candidate must pass H4 checklist rows 1–7: real ELF magic; readelf/objdump NEEDED empty of `leanshared*` / `Init_shared`; agreement when both scanners present; residual script emits residual_free + `HOST_HAS_LEANSHARED=0` + `GC_FREE_ELABORATOR=1`; FORCE without residual_free still FAIL. Hand-editing tokens or `FORCE=1` without residual_free is **forge** and must FAIL.

##### Measurement recipe (reuse H4 checklist)

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"

# --- Today (honest classic residual; H5 still blocked) ---
./script/systems-host-elaborator-residual.sh | tee /tmp/host-residual.out
# expect:
#   HOST_HAS_LEANSHARED=1
#   HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
#   GC_FREE_ELABORATOR=0

# Manual NEEDED audit (must match residual script scanners):
readelf -d build/release/stage1/bin/lean | grep NEEDED
objdump -p build/release/stage1/bin/lean | grep NEEDED
# stage1 today includes: libInit_shared.so, libleanshared{,_1,_2}.so

# Dual residual on product path (plan / worklist / baseline / W0-docs / W1-protocol / W1-candidate / next-step / negative-candidates / earn-checklist / FORCE-refusal / status-quo markers only; not earn):
./script/lean-systems check
# expect greppable:
#   HOST_DRIVER_RESIDUAL_PLAN=1
#   HOST_RESIDUAL_REDUCTION_PLAN=1
#   HOST_ELABORATOR_EARN_PATH=1
#   HOST_ELABORATOR_PROTOTYPE_WORKLIST=1
#   HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared
#   HOST_ELABORATOR_W0_VERIFIED_DOCS=1
#   HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1
#   HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1
#   HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1
#   HOST_ELABORATOR_NEGATIVE_CANDIDATES=1
#   HOST_ELABORATOR_EARN_CHECKLIST=1
#   HOST_ELABORATOR_FORCE_REFUSAL=1
#   HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1
#   HOST_ELABORATOR_STATUS_QUO=1
#   HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1
#   PRODUCT_GC_FREE=1   (when bundle residual-clean)
#   GC_FREE_ELABORATOR=0

# --- Future residual_free candidate (do not forge tokens by hand) ---
# SYSTEMS_LEAN_TCB_LEAN=/path/to/candidate-lean ./script/systems-host-elaborator-residual.sh
# or via lean-systems dual honesty:
# SYSTEMS_LEAN_HOST_ELF=/path/to/candidate-lean ./script/lean-systems check
# Earn only when residual script itself prints:
#   HOST_HAS_LEANSHARED=0
#   HOST_ELABORATOR_RESIDUAL=residual_free
#   HOST_ELABORATOR_TCB=residual_free
#   GC_FREE_ELABORATOR=1
# with method readelf and/or objdump (never ldd alone).
# FORCE without residual_free → FAIL:
#   SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 ./script/systems-host-elaborator-residual.sh
```

Full checklist criteria (ELF magic, multi-scanner agreement, residue substrings, stage1 change surface): **§ H4** above. H5 does not replace H4; it is the **earn path** that runs that checklist against a candidate and refuses forge.

##### Fail-closed candidate dry-run (no new bash gate)

Prefer extending docs + `lean-systems` over new `script/systems-*.sh` gates (`systems.nix` preference). Optional env:

| Env | Behavior |
|-----|----------|
| `SYSTEMS_LEAN_HOST_ELF` unset | Measure default stage1 / `SYSTEMS_LEAN_TCB_LEAN` → classic → `GC_FREE_ELABORATOR=0` |
| `SYSTEMS_LEAN_HOST_ELF=/path/to/elf` | `lean-systems` dual honesty measures that path via residual script (`SYSTEMS_LEAN_TCB_LEAN` for that call only) |
| Path missing / non-ELF / classic NEEDED | Residual script: unmeasured or classic; **still** `GC_FREE_ELABORATOR=0` |
| Residual_free earned under scanners | Residual script alone may print `GC_FREE_ELABORATOR=1` — never hardcoded in drivers |

There is **no** in-tree residual_free host candidate today. Dry-run against stage1 must keep product=1 (when clean) and host=0. Baseline marker stays `HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared` until earn.

##### Fail-closed residual_free candidate checklist (acceptance criteria; not an earn forge)

```
HOST_ELABORATOR_EARN_CHECKLIST=1
```

Meaning: this subsection is the greppable **fail-closed residual_free candidate checklist** — what a residual_free host ELF must prove before earn. **Docs honesty only** (docs / `lean-systems` dual residual). Complementary to H5.E4 (negatives that must never be candidates) and H4 (measurement rows). **Never** treat as residual_free, **never** as `GC_FREE_ELABORATOR=1`, and **never** as a second earn script.

Use this **before** claiming residual_free earn. This is a documentation gate only — it does **not** mint tokens, does **not** replace `systems-host-elaborator-residual.sh`, and must **not** be implemented by hardcoding `GC_FREE_ELABORATOR=1` in drivers. A future residual_free candidate must pass **all** bullets:

| # | Must prove | Pass criterion | Fail-closed notes |
|---|------------|----------------|-------------------|
| 1 | **ELF magic** | Real host ELF (not shell wrapper, not empty +x, not `lean-systems` product shell) | Non-ELF → unmeasured, never earn (H5.E4) |
| 2 | **NEEDED empty of residues** | No `leanshared` / `Init_shared` substrings under **readelf and/or objdump** | Out-of-scope NEEDED (libc, libstdc++, libgmp, …) may remain |
| 3 | **Scanner agreement** | When **both** readelf and objdump present: multi-scanner **agreement** | Disagreement → not residual_free; **ldd alone never earns** |
| 4 | **No FORCE forge** | `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without residual_free still **FAIL**s | Hand-edited tokens / wrapper-only “clean” never count |
| 5 | **Product independence** | `PRODUCT_GC_FREE` remains product nm/IR only (H2 dual path) | Product=1 does **not** imply elaborator residual_free |

**Candidate identity**

- [ ] Artifact is a **real host ELF** (ELF magic; not a shell wrapper, not empty +x, not `lean-systems` itself).
- [ ] Path is pinned for measure: `SYSTEMS_LEAN_TCB_LEAN=<candidate>` and/or `SYSTEMS_LEAN_HOST_ELF=<candidate>` (explicit pin; no PATH forge).
- [ ] Candidate is built on a **separate** CMake option / output path — default stage1 remains classic green.

**NEEDED / scanners (H4 rows 1–5)**

- [ ] `/usr/bin/readelf -d <candidate> | grep NEEDED` (when readelf present) has **no** `leanshared` / `Init_shared` substrings.
- [ ] `/usr/bin/objdump -p <candidate> | grep NEEDED` (when objdump present) agrees — same residue absence.
- [ ] When **both** scanners present: multi-scanner **agreement** (disagreement → not residual_free).
- [ ] Earn method is `readelf`, `objdump`, or `readelf+objdump` — **ldd alone never earns**.
- [ ] Out-of-scope NEEDED (libc, libstdc++, libgmp, libuv, libssl, …) may remain; they do not block residual_free.

**Residual script tokens (only source of earn)**

- [ ] `./script/systems-host-elaborator-residual.sh` with the candidate pin prints **exactly**:
  - `HOST_HAS_LEANSHARED=0`
  - `HOST_ELABORATOR_RESIDUAL=residual_free`
  - `HOST_ELABORATOR_TCB=residual_free`
  - `GC_FREE_ELABORATOR=1`
  - `HOST_ELABORATOR_RESIDUAL_OK=1`
- [ ] Honesty checker accepts that transcript (`systems_lean_host_elab_tokens_ok` / `systems-tcb-honesty-check`).
- [ ] Dual 0/1 on any axis is rejected (no mixed classic + residual_free tokens).

**Forge / negative resistance**

- [ ] `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` **without** residual_free evidence still **FAIL**s.
- [ ] Hand-edited tokens / wrapper-only “clean” paths never count as earn.
- [ ] Negatives still green: `script/systems-host-elaborator-residual-negatives.sh`.

**Product independence**

- [ ] Product wire unchanged: `PRODUCT_GC_FREE` remains product nm/IR only (H2 dual path).
- [ ] `lean-systems check` may still print plan markers (incl. `HOST_ELABORATOR_EARN_CHECKLIST=1`); earn comes only from residual script measure.
- [ ] Stage1 classic baseline snapshot (`HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared`) remains valid documentation of **default** stage1 until/unless default stage1 itself earns (unlikely short-term — prototypes stay out-of-band).

**Only when all bullets pass:** residual script may honestly emit `GC_FREE_ELABORATOR=1`. Until then: **leave `=0`**. Do not invent a second earn script.

**What the earn checklist does not claim**

- Not residual_free / not `GC_FREE_ELABORATOR=1`.
- Not a shipped residual_free host ELF (stage1 still classic).
- Not permission to treat checklist marker or product success as elaborator GC-free.
- Not a change to G3 earn rules (SSoT remains `systems-host-elaborator-residual.sh`).

##### FORCE / negative refusal contract (docs honesty; not earn)

```
HOST_ELABORATOR_FORCE_REFUSAL=1
```

Meaning: this subsection is the greppable **FORCE/negative refusal contract** for host elaborator residual. **Docs honesty only** (docs / `lean-systems` dual residual). It records the fail-closed rule that already lives in residual-script SSoT — it does **not** mint residual_free, does **not** flip `GC_FREE_ELABORATOR=1`, and must **not** be treated as a second earn gate.

**Contract (must never weaken):**

| Case | Env / input | Required outcome |
|------|-------------|------------------|
| FORCE without residual_free | `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` and measured residual is **not** residual_free (`gc_free≠1`) | residual script **FAIL**s on **all** exit paths (classic stage1, missing lean, non-ELF, unmeasured, …) |
| FORCE + earned residual_free | `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` **and** residual script itself earned residual_free under scanners | residual script **may** exit 0 (FORCE does not block a true earn) |
| No FORCE | unset / `0` | measure as usual; classic stage1 → `GC_FREE_ELABORATOR=0` staged PASS |
| Hand-edited tokens | any forge of `GC_FREE_ELABORATOR=1` without residual script earn | **invalid** — honesty checker / negatives refuse |

**SSoT implementation (do not reimplement in drivers):**

- `script/systems-host-elaborator-residual.sh` — `force_refuse_if_needed` before successful exits; header: `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without earned residual_free → FAIL.
- `script/systems-host-elaborator-residual-negatives.sh` — FORCE refused on classic stage1 + advisory early exits; FORCE + synthetic residual_free allowed.

**Greppable dry-run (classic stage1 must refuse FORCE):**

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
# Must FAIL (non-zero) and mention FORCE/refused — not residual_free earn:
SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 ./script/systems-host-elaborator-residual.sh
# Negatives suite (includes FORCE cases):
./script/systems-host-elaborator-residual-negatives.sh
# Dual residual still prints docs marker only; host measure remains =0:
./script/lean-systems check
# expect: HOST_ELABORATOR_FORCE_REFUSAL=1  and  GC_FREE_ELABORATOR=0
```

**What FORCE refusal docs do not claim**

- Not residual_free / not `GC_FREE_ELABORATOR=1`.
- Not permission to set FORCE and treat failure as earn, or to skip FORCE negatives.
- Not a product residual claim; product success never satisfies FORCE earn.
- Not a change to G3 earn rules (SSoT remains residual script + negatives).

##### FORCE negative measured receipt (classic stage1 fail-closed; not earn)

```
HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1
```

Meaning: this subsection records a **measured** FORCE-without-residual_free fail receipt against classic stage1. **Docs honesty only** (docs / `lean-systems` dual residual). It proves the residual script still FAIL-closes forge attempts — it does **not** mint residual_free and does **not** flip `GC_FREE_ELABORATOR=1`.

**Measured receipt** (re-run; do not hand-edit tokens to green):

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
# Direct FORCE dry-run (must exit non-zero; greppable FAIL line):
SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 ./script/systems-host-elaborator-residual.sh
# → exit non-zero
# → FAIL: SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 refused (measurement GC_FREE_ELABORATOR=0, residual=classic_RC_shared_runtime)
# → HOST_HAS_LEANSHARED=1
# → HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
# → HOST_ELABORATOR_TCB=classic_RC_shared_runtime
# → GC_FREE_ELABORATOR=0
# → HOST_ELABORATOR_RESIDUAL_OK=0
# Negatives suite (includes FORCE on classic + advisory early exits; must stay green):
./script/systems-host-elaborator-residual-negatives.sh
# → OK: FORCE_GC_FREE refused on classic stage1
# → OK: FORCE refused on advisory missing-lean early exit
# → OK: FORCE refused on advisory non-ELF early exit
# → OK: FORCE + earned residual_free allowed
# → OK: systems-host-elaborator-residual negatives (fail-closed; measured G3 dual path)
```

**Last measured greppable lines** (classic stage1 + `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1`; date in residual script header when re-run):

```
FAIL: SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1 refused (measurement GC_FREE_ELABORATOR=0, residual=classic_RC_shared_runtime)
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_ELABORATOR_RESIDUAL_OK=0
```

**What the FORCE measured receipt does not claim**

- Not residual_free / not `GC_FREE_ELABORATOR=1`.
- Not permission to skip re-measure after residual-script or stage1 link changes.
- Not a product residual claim.
- Not a change to G3 earn rules (SSoT remains residual script + negatives).

##### Status-quo stage1 summary box (resting truth until earn; docs only)

```
HOST_ELABORATOR_STATUS_QUO=1
HOST_HAS_LEANSHARED=1
HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime
HOST_ELABORATOR_TCB=classic_RC_shared_runtime
GC_FREE_ELABORATOR=0
HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared
```

Meaning: this is the greppable **status-quo stage1 summary box** — the resting measured truth for default stage1 until residual_free is earned. **Docs honesty only** (docs / `lean-systems` dual residual). Marker `HOST_ELABORATOR_STATUS_QUO=1` consolidates the live measured axes (`HOST_HAS_LEANSHARED=1`, classic_RC residual class, `GC_FREE_ELABORATOR=0`) so operators can grep one block without mistaking plan/path markers for earn. **Never** treat as residual_free, **never** as `GC_FREE_ELABORATOR=1`, and **never** as a second earn gate.

**Resting truth (re-measure; do not hand-edit):**

| Axis | Status-quo value | Earn would require |
|------|------------------|--------------------|
| Shared RC NEEDED | `HOST_HAS_LEANSHARED=1` | `HOST_HAS_LEANSHARED=0` under readelf/objdump |
| Residual class | `classic_RC_shared_runtime` | `residual_free` |
| Measured elaborator GC-free | `GC_FREE_ELABORATOR=0` | `GC_FREE_ELABORATOR=1` only from residual script |
| Baseline short form | `classic_RC_shared` | superseded only if default stage1 itself earns |

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
./script/systems-host-elaborator-residual.sh
# → HOST_HAS_LEANSHARED=1  HOST_ELABORATOR_RESIDUAL=classic_RC_shared_runtime  GC_FREE_ELABORATOR=0
./script/lean-systems check
# expect: HOST_ELABORATOR_STATUS_QUO=1  and  GC_FREE_ELABORATOR=0  (host still measured classic)
```

**What the status-quo box does not claim**

- Not residual_free / not `GC_FREE_ELABORATOR=1`.
- Not permission to hardcode tokens or skip re-measure after stage1 link changes.
- Not a product residual claim; product may still be `PRODUCT_GC_FREE=1` independently (H2 dual path).
- Not a change to G3 earn rules (SSoT remains `systems-host-elaborator-residual.sh`).

##### Docs ladder complete (path docs only; residual_free earn still open)

```
HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1
```

Meaning: the H5 **docs ladder** is greppably complete through path / worklist / baseline / W0 verified docs / W1 experiment + candidate protocols / next experiment step / negative candidates / earn checklist / FORCE refusal + **measured FORCE negative receipt** / STATUS_QUO. **Docs honesty only** (docs / `lean-systems` dual residual). This marker summarizes that only a **real residual_free host ELF** under residual scanners remains for earn — it does **not** mint residual_free, does **not** flip `GC_FREE_ELABORATOR=1`, and must **not** be treated as a second earn gate.

**Ladder members (all greppable; all not earn):**

| Marker | Ladder step |
|--------|-------------|
| `HOST_ELABORATOR_EARN_PATH=1` | earn path docs |
| `HOST_ELABORATOR_PROTOTYPE_WORKLIST=1` | W0–W3 worklist |
| `HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared` | measured classic baseline |
| `HOST_ELABORATOR_W0_VERIFIED_DOCS=1` | W0 classic dry-run transcript |
| `HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1` | W1 experiment protocol |
| `HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1` | W1 candidate pin protocol |
| `HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1` | H5.E3 first-candidate identity |
| `HOST_ELABORATOR_NEGATIVE_CANDIDATES=1` | H5.E4 must-not-be candidates |
| `HOST_ELABORATOR_EARN_CHECKLIST=1` | fail-closed residual_free prove-list |
| `HOST_ELABORATOR_FORCE_REFUSAL=1` | FORCE without residual_free must FAIL |
| `HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1` | measured FORCE fail receipt |
| `HOST_ELABORATOR_STATUS_QUO=1` | resting stage1 measured tokens |
| `HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1` | this summary (docs only) |

```bash
export PATH="$PWD/build/release/stage1/bin:${PATH:-}"
./script/systems-host-elaborator-residual.sh
# → GC_FREE_ELABORATOR=0 (host still classic)
./script/lean-systems check
# expect: HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1  and  GC_FREE_ELABORATOR=0
rg -n 'DOCS_LADDER|FORCE_NEGATIVE_MEASURED|STATUS_QUO' doc/dev/systems-lean-selfhost.md script/lean-systems | head
```

**What docs-ladder-complete does not claim**

- Not residual_free / not `GC_FREE_ELABORATOR=1`.
- Not permission to treat any ladder marker as earn, or to skip residual scanners.
- Not a product residual claim; product may still be `PRODUCT_GC_FREE=1` independently.
- Not a change to G3 earn rules — only a real residual_free host ELF earns.

##### What H5 is not

- Not a shipped residual_free host binary (stage1 still classic).
- Not permission to hardcode `GC_FREE_ELABORATOR=1`, weaken FORCE negatives, or treat `HOST_ELABORATOR_EARN_PATH=1` / `HOST_ELABORATOR_PROTOTYPE_WORKLIST=1` / `HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared` / `HOST_ELABORATOR_W0_VERIFIED_DOCS=1` / `HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1` / `HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1` / `HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1` / `HOST_ELABORATOR_NEGATIVE_CANDIDATES=1` / `HOST_ELABORATOR_EARN_CHECKLIST=1` / `HOST_ELABORATOR_FORCE_REFUSAL=1` / `HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1` / `HOST_ELABORATOR_STATUS_QUO=1` / `HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1` as earn.
- Not “wrapper / plan marker / baseline marker / W0 verified-docs marker / W1 experiment-protocol marker / W1 candidate-protocol marker / next-experiment-step marker / negative-candidates marker / earn-checklist marker / FORCE-refusal marker / FORCE-negative-measured marker / status-quo marker / docs-ladder-complete marker ⇒ elaborator residual_free” (G3 measures the **lean** ELF).
- Not a product residual claim (product stays H2 / `PRODUCT_GC_FREE`); `lean-systems` is product path, not elaborator (H5.E4 negative candidate).
- Not a multi-year elaborator rewrite completed in docs — only the prototype worklist + measured baseline + W0 verified dry-run + W1 experiment protocol + W1 candidate measure protocol + next experiment step + negative candidates + fail-closed earn checklist + FORCE refusal contract + FORCE negative measured receipt + status-quo stage1 summary + docs ladder complete + earn gate stay honest while that work proceeds.

##### Done when (H5 path progress vs residual_free earn)

| Checkpoint | Evidence | Status intent |
|------------|----------|---------------|
| Earn path documented | this section + greppable `HOST_ELABORATOR_EARN_PATH=1` | **path progress** |
| Prototype worklist ordered | W0–W3 + `HOST_ELABORATOR_PROTOTYPE_WORKLIST=1` | **path progress** |
| Measured stage1 residual snapshot | recipe + expected tokens + W0 CMake line cites | **path progress** |
| Baseline marker greppable | `HOST_STAGE1_RESIDUAL_BASELINE=classic_RC_shared` | **honest baseline** |
| W0 verification dry-run transcript | exact commands + expected classic greppable lines | **path progress** |
| W0 verified-docs marker greppable | `HOST_ELABORATOR_W0_VERIFIED_DOCS=1` (docs honesty; not residual_free) | **path progress** |
| H5.E1 W0 CMake inject re-verify | line cites still match `src/CMakeLists.txt:933`/`:611` + `src/shell/CMakeLists.txt:41` (no drift) | **path progress** |
| W1 experiment protocol documented | ordered static-link / thin-driver try→measure→residual_free-only success | **path progress** |
| W1 experiment-protocol marker greppable | `HOST_ELABORATOR_W1_EXPERIMENT_PROTOCOL=1` (docs honesty; not residual_free) | **path progress** |
| H5.E2 W1 candidate measure protocol | pin via `SYSTEMS_LEAN_HOST_ELF`; classic dry-run still `=0`; greppable `HOST_ELABORATOR_W1_CANDIDATE_PROTOCOL=1` | **path progress** |
| H5.E3 next experiment step | first-candidate identity (`lean-host-static` sketch; `lean-systems` = product path not elaborator; stage1 classic); greppable `HOST_ELABORATOR_NEXT_EXPERIMENT_STEP=1` | **path progress** |
| H5.E4 negative candidates | identities that must never be residual_free host candidates (`lean-systems` shell, scripts, non-ELF); greppable `HOST_ELABORATOR_NEGATIVE_CANDIDATES=1` | **path progress** |
| Fail-closed residual_free earn checklist | what residual_free host ELF must prove (ELF magic, NEEDED empty under readelf/objdump agreement, no FORCE, product independence); greppable `HOST_ELABORATOR_EARN_CHECKLIST=1` | **path progress** |
| FORCE/negative refusal contract | `SYSTEMS_LEAN_FORCE_GC_FREE_ELABORATOR=1` without residual_free must FAIL; greppable `HOST_ELABORATOR_FORCE_REFUSAL=1` | **path progress** (docs only; not earn) |
| FORCE negative measured receipt | classic stage1 FORCE dry-run fail-closed greppable lines + negatives suite; greppable `HOST_ELABORATOR_FORCE_NEGATIVE_MEASURED=1` | **path progress** (measured docs; not earn) |
| Status-quo stage1 summary box | greppable block with measured tokens + `HOST_ELABORATOR_STATUS_QUO=1` (resting truth until earn) | **path progress** (docs only; not earn) |
| Docs ladder complete | path/worklist/E1–E4/checklist/FORCE/STATUS_QUO docs-complete; greppable `HOST_ELABORATOR_DOCS_LADDER_COMPLETE=1` | **path progress** (docs only; only real residual_free ELF remains for earn) |
| CMake link sources + expected NEEDED | W0 grep recipe + stage1 soname table | **path progress** |
| Reuses H4 measurement checklist | recipe above + residual script SSoT | **path progress** |
| Blocks today named | stage1 NEEDED leanshared / Init_shared | **path progress** |
| Dual residual still host=0 | `lean-systems check` → product may be 1; `GC_FREE_ELABORATOR=0` | **honest baseline** |
| Residual_free candidate ELF | real host ELF passes residual_free checklist + residual script | **later** |
| Earn flip | residual script + honesty checker + forge negatives accept residual_free | **earn only then** |

Until a candidate passes the residual script earn path: **leave `GC_FREE_ELABORATOR=0`**. Classic shared + staged `GATE host_elaborator=PASS` remains correct.

### Phases (R6 vs R7)

1. **TCB inventory** — this section (R6 **done** for product vs host split; **P5 honesty tokens shipped**; **G3 measured residual shipped**).  
2. **FS product path** — freestanding bundle + `lean-systems` (R6 **done**).  
3. **Link without GC** — nm gate fail-closed (R6 **done**).  
4. **Full stdlib / FS elaborator** — Init → Std → Lean under FS (R7; **not** claimed here).  
5. **CompCert-verified elaborator** — **never claimed**; only product pure C TUs may be ccomp'd. 

## `lean-systems` shape

- **In-tree:** `script/lean-systems`  
- **Installed:** `out/systems-selfhost/bin/lean-systems` (prefix overridable via `SYSTEMS_LEAN_PREFIX`)  
- **Commands:** `--version`, `--help`, `build`, `check`, `selfhost`, `compile FILE.lean`, `lean …`  
- **Honesty banners** state that the elaborator host still uses classic runtime  

## Performance intent

Self-host Systems Lean aims for fewer RC operations on the **product** hot path (linear/unboxed freestanding extract). Measure with a small compile/link workload when comparing classic managed AOT vs freestanding product archives; classic remains the default distribution.

## CompCert

See freestanding `check_compcert.sh` / `make check-compcert` (optional; `make check-full` hard-requires): real `ccomp` on freestanding Extract/Scalars/Sys C after Lean MemSafetyCert + CompCertCert. Documented in `doc/dev/systems-lean.md` (CompCert dogfood). Not a claim that Lean’s elaborator is CompCert-verified end-to-end.

## Proof receipt

Pipeline success = MemSafetyCert verify ∧ CompCertCert verify ∧ CompCert `ccomp` success (when required) ∧ optional self-host nm. Algebra: private definitional lemmas in `Multiplicity.Theorems` (markers re-exported from `Lean.Compiler.QTT.Theorems`). End-to-end fail-closed script: `script/systems-proof-receipt.sh` (`make -C tests/lake/examples/systems check-proof-receipt`) — Lean `verifyEmbedded` covers the actual EXTRACT path. Honest proved/assumed/CompCert split: `doc/dev/systems-lean.md` (Formal correctness layer).

Self-host nm can be required with `SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_SELFHOST=1`, or skipped with `SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST=1`.
