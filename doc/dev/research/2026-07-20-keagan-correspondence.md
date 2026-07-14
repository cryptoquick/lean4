# Research note: Keagan on “Don’t Trust. Verify.” and Lean C extraction

**Kind:** fork research (analysis only). Not residual implementation work.  
**Date:** 2026-07-20  
**Source:** [Keagan McClelland, “Taking Don’t Trust. Verify. Seriously”](https://proofofkeags.com/research/2026-07-20-taking-dont-trust-verify-seriously.html)  
**Audience:** people asking whether Systems Lean already answers the “run the Lean code so you don’t re-implement the spec” gap.  
**Primary implementor:** optional reading if stuck on correspondence / TCB honesty. Do not treat this note as a residual backlog item or a reason to invent wave work.

---

## What Keagan claims (the passage we care about)

After arguing for a Lean formalization of Bitcoin protocol design (`btc-verified`), he is careful about **what that does not buy you**:

1. A complete Lean description of the protocol does **not** mean Bitcoin Core (or any other C++ node) is bug-free.
2. Guarantees only transfer to running software if you **connect** the formalization to the implementation people actually run.
3. The “easy” connection path he names: use **Lean’s C extraction** (he links Lake’s build/distribution docs) and **run that extracted code directly**.
4. That path **removes a separate handwritten implementation** from the correspondence problem (one artifact instead of “Lean spec + hand C++”).
5. The resulting program still depends on the **correctness of Lean’s compiler, runtime, and native toolchain**.
6. Even then, a verified Lean implementation may be **too inefficient** to run in production for a long time.

He also separately discusses resource bounds, network assumptions, and game-theoretic limits — those matter for Bitcoin security stories, but the extract/run claim is the one that maps onto Systems Lean.

---

## What he is pointing at vs what Lean actually ships

| Phrase in the post | What people often hear | What upstream Lean mainly is |
|--------------------|------------------------|------------------------------|
| “C extraction facility” + Lake link | Coq-style “extract to pure C and throw away the proof assistant” | **AOT compile** Lean → native code that still **expects the managed Lean runtime** (RC heap, `lean_object*`, shared libs such as `libleanshared`) |
| “Run that code directly” | Spec becomes the node | You can ship a Lean-built binary; you have **not** automatically removed the runtime from the trust base |
| “Depends on compiler, runtime, and toolchain” | Correct residual TCB list for classic AOT | Accurate for default Lean products |

So the post is right about the **shape** of the problem (spec ≠ Core; extract-and-run narrows the dual-implementation gap; TCB remains large). It is easy to over-read the Lake link as “Lean already has a freestanding C extract path.” **Default Lean does not.** AOT is not freestanding.

---

## What this tree already answers (honestly)

Systems Lean on the `systems` branch is a deliberate product path for **embedded / freestanding** cores: write the core in Lean, emit C-callable static archives, link from ordinary C **without** the Lean object runtime on the product wire.

Canonical docs: [systems-lean.md](../systems-lean.md), [systems-lean-selfhost.md](../systems-lean-selfhost.md).

### 1. Correspondence: one Lean source → product C ABI (partial “yes”)

| Goal Keagan wants | Systems Lean stance | Status on this branch (as of this note) |
|-------------------|---------------------|----------------------------------------|
| Avoid a second handwritten implementation of the same logic | Product bodies live under `src/Systems/`; consumers call `@[export_c]` / `lean_fs_*` symbols from a static bundle | **Product path exists** and is exercised by `tests/lake/examples/systems` |
| Spec theorems and runtime code in the same language | Host can hold `Prop`/proofs; freestanding extract erases proofs from the embed TCB | **Architecture matches** dual pipeline (host proofs vs extract product) |
| End-to-end “the node is the theorem” for Bitcoin | Not claimed; no Bitcoin consensus product in this tree | **Out of scope** here |

**Answer to the dual-implementation gap:** for **freestanding product modules we actually extract**, yes — the intent is that the Lean module is the semantic source and C is generated, not re-authored. That is exactly non-goal avoidance of “hand-written C as the semantic single source of truth” in `systems-lean.md`.

**What we do *not* claim:** that every theorem proved on the host is linked into the binary, or that Bitcoin Core has been replaced.

### 2. Runtime in the TCB: classic extract “no”; freestanding product “mostly yes”

Keagan lists **compiler + runtime + native toolchain** as remaining trust.

Systems Lean **splits** that carefully:

| Layer | What is trusted today | Greppable honesty |
|-------|----------------------|-------------------|
| **Product / embed wire** | Freestanding static archive + libc (and optional CompCert dogfood on pure C TUs) — **not** `libleanshared` / `Init_shared` on a successful residual | Measured: `PRODUCT_GC_FREE=1`, `PRODUCT_NO_LEANSHARED=1` after nm residual success |
| **Host elaborator / stage1 driver** | Still classic Lean + shared RC runtime | Measured: `GC_FREE_ELABORATOR=0`, residual `classic_RC_shared_runtime` |
| **Compiler / EmitC / freestanding gates** | In-tree Lean compiler changes that fail-closed on residual RC/object ABI in freestanding mode | Process/gates, **not** a machine-checked compiler correctness proof |
| **Native C toolchain** | Still in the TCB (cc, linker, libc); optional CompCert path is dogfood / compliance gates, not “Lean is CompCert-verified” | `PROVABLY_COMPCERT_COMPLIANT` only under its own predicate |

**Answer to “still depends on runtime”:**

- If “runtime” means **Lean’s managed RC object runtime on the product you ship**, freestanding product residual is designed so a clean product **does not** need it. That is a **stronger** answer than classic Lake AOT extract-and-run.
- If “runtime” means **whatever builds and elaborates the Lean sources**, we still depend on classic stage1 Lean today. Host elaborator GC-free is **not earned**.
- If “runtime” means **C standard library / OS**, still yes for any real node.

So: Keagan’s three-part residual TCB is the right checklist; we **already separate** product wire from host elaborator so people cannot smuggle “product residual free” into “compiler is trusted-free.”

### 3. Efficiency: freestanding is a different bet than “extract classic Lean”

Keagan warns that verified Lean may be **too slow** to run for a long time.

That warning is aimed at **proof-oriented / library Lean** compiled the normal way (heap objects, RC, full Init). Systems Lean’s product surface is **not** that:

- Unboxed freestanding scalars (`U8`…`U64`, `USize`, …)
- Affine resources + explicit free / arenas (not automatic refcount on the product hot path)
- Fail-closed emit if residual `lean_alloc_*` / object ABI shows up
- Shape is “static `.a` + C header,” like a normal embedded library

**Answer:** for the **product cores we extract**, the project’s efficiency story is “looks like C,” not “run Mathlib-shaped code under RC and hope.” That does **not** prove a full Bitcoin node written this way is production-fast; it does mean the “verified Lean is forever too slow” objection is **not automatically true** of freestanding extract the way it is of naive classic AOT of proof-heavy code.

Still honest: many `Systems.*` modules are **shaped** scanners/codecs, not full protocol stacks; inventory forbids claiming full Init parity.

### 4. Connecting formal claims to the running artifact (partial)

Keagan’s deeper point: **proofs about a model only protect the model.**

Systems Lean’s related pieces:

| Mechanism | Helps with | Does not prove |
|-----------|------------|----------------|
| Dual pipeline (host proofs erased at extract) | Proofs do not bloat or leak into embed TCB | That the extracted C matches a deep semantic model of Bitcoin |
| Residual nm / IR gates on product archives | No Lean RC/object symbols on the wire | Compiler correctness |
| CompCert dogfood / compliance gates on product C TUs | C-side tool chain story for pure C units | Full verified compilation of Lean → asm |
| Golden / example harness under `tests/lake/examples/systems` | Executable smoke for freestanding exports | Consensus equivalence with Bitcoin Core |

**Answer:** we have a serious **product residual and TCB honesty** story for freestanding extract. We do **not** have “btc-verified theorems imply `bitcoind` behavior” — and we should not pretend extract-and-run alone is that bridge for a full node.

---

## Direct answers to the quoted claim

> The only other way to easily achieve this would be to use Lean’s C extraction facility … and run that code directly.

**Our gloss:** For **default Lean**, “extract and run” still leaves you with the **managed runtime** in the operational TCB. For **Systems Lean freestanding**, you can run **generated product code** as a C-linked static library **without** that managed runtime on the product wire — which is closer to what “run the formalization” wants for embedded cores.

> This would remove a separate handwritten implementation from the correspondence problem

**Our gloss:** **Yes, by design, for freestanding product modules** that are the single source and export a C ABI. **No** for bridging an abstract Bitcoin Lean model to Bitcoin Core without a separate refinement/correspondence effort.

> … still depend on the correctness of Lean’s compiler, runtime, and native toolchain

**Our gloss:** **Compiler + native toolchain: yes.** **Lean managed runtime on the product wire: no, when product residual is clean** (`PRODUCT_GC_FREE` / no shared Lean libs). **Host elaborator runtime: still yes today** (`GC_FREE_ELABORATOR=0`).

> … verified Lean implementation may be too inefficient to run practically for quite a while

**Our gloss:** Fair for classic/proof-heavy Lean. **Freestanding product is aimed at practical C-like performance**; efficiency is an engineering property of each module, not a permanent sentence on all Lean extract. Not a free lunch for a full consensus node.

---

## Gaps we should not paper over

1. **No Bitcoin product** in this tree — correspondence answers apply to Systems freestanding cores, not to Keagan’s full protocol project.
2. **Compiler not verified** — freestanding gates and residuals reduce *classes* of bad emit; they are not a proof of EmitC.
3. **Host still classic** — building freestanding modules still trusts stage1 Lean + RC.
4. **Shaped stdlib** — freestanding library surface is closed and partial; not “all of Lean runs freestanding.”
5. **Resource / network / game theory** bounds he discusses remain open research even if extract-and-run is solid.

---

## Practical takeaway for this repo

| Question | Short answer |
|----------|--------------|
| Do we already have Keagan’s “easy extract-and-run” path? | **We have a stronger freestanding extract path for product cores** than classic Lake AOT, with measured product residual free of Lean shared runtime. |
| Does that close “spec vs Core”? | **Only for the artifact you extract and run.** It does not auto-verify Bitcoin Core. |
| What trust remains? | Compiler, freestanding codegen, C toolchain, OS; **host elaborator RC** while measuring build; **not** product Lean RC when residual is green. |
| Should the primary residual treadmill change because of this post? | **No.** This is analysis. Residual work stays whatever the living residual tracker says; this note is for correspondence/TCB questions. |

---

## How to re-check measurements (optional)

From repo root, with stage1 and freestanding bundle available:

```bash
bash script/systems-status.sh
# Expect product residual free while host elaborator still classic, e.g.:
#   PRODUCT_GC_FREE=1
#   PRODUCT_NO_LEANSHARED=1
#   GC_FREE_ELABORATOR=0
```

Deeper product residual: `script/systems-selfhost-link-check.sh` / example `make check-selfhost` (see selfhost doc).

---

## Changelog

| Date | Note |
|------|------|
| 2026-07-20 | Initial fork research note responding to Keagan’s extract-and-run TCB paragraph. |
