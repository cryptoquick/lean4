# Systems Lean — design seed

**Product name:** Systems Lean  
**Canonical documentation:** [`doc/dev/systems-lean.md`](doc/dev/systems-lean.md)  
**Prelude:** [`src/Systems/`](src/Systems/)  
**Example harness:** [`tests/lake/examples/systems/`](tests/lake/examples/systems/)  
**Integration smoke:** [`script/systems-lean-smoke.sh`](script/systems-lean-smoke.sh) (QTT + memsafe elab + freestanding checks + R6 self-host; no CompCert)  
**Self-host product path (R6):** [`script/systems-selfhost.sh`](script/systems-selfhost.sh) / [`script/lean-systems`](script/lean-systems) — see [`doc/dev/systems-lean-selfhost.md`](doc/dev/systems-lean-selfhost.md)  
**Nix package:** `packages.systems-lean` in [`flake.nix`](flake.nix) — other flakes can take this tree as an input (no elan); see the Nix section in the canonical doc.  
**Systems tooling front door:** [`systems.nix`](systems.nix) — prefer this over new `script/systems-*.sh` gates.
- **Light (no stage1; pure sandbox or host):** `nix build .#checks.<sys>.systems-light` (alias `checks.systems` / `packages.systems-check-light`); `nix run .#systems-check`
- **Full SCORE (primary; stage1 + freestanding bundle at `tests/lake/examples/systems`):** `nix develop .#systems --command systems-validate` / `nix run .#systems-validate` (docs alias `packages.systems-score` / `apps.systems-score` — same app; not a pure-sandbox SCORE check)
- **Status / shell:** `nix develop .#systems --command systems-status`; apps `systems-status` / `systems-check` / `systems-validate`

This file is a **short design seed** (historically “freestanding systems extract” / Option E).  
Prefer the canonical doc above for goals, architecture, Lake freestanding packaging, R1–R6 product status, and R7 product path (inventory + first-wave FS stdlib; module ports ongoing).

---

## One-sentence goal

A closed Lean subset AOT-compiles to a small static library with:

- **no** Lean object runtime (`libleanshared` / RC heap) on the consumer link line  
- **no** automatic memory management in the embed TCB  
- **memory safety from types** (affine resources + dependent sizes), not from a managed heap  

**AOT ≠ freestanding.** AOT only means “not an interpreter.” Systems Lean freestanding means **no Lean managed runtime on the wire**.

---

## Minimum feature set (design ranking)

| ID | Feature | Role |
|----|---------|------|
| N1 | Unboxed systems types + ABI | No `lean_object*` on the hot path |
| N2 | Affine resources + freestanding borrows | Free-safety without GC |
| N3 | Arenas / regions | Bulk page lifetime |
| N4 | Thin `Sys` effect | IO without Lean `IO` runtime |
| N5 | `@[export_c]` | Stable C library surface |
| N6 | Freestanding codegen gate | Fail closed on boxing / RC / Lean dynlibs |
| N7 | Control-flow / mut-equivalent locals | Tight byte loops without managed spines |

**Strategic core:** *unboxed lowering + affine resources + arenas + thin Sys + freestanding link gate.*

---

## Acceptance (good enough for embed)

Systems Lean is **usable enough for an embed spine** when:

1. A documented freestanding subset compiles with **zero** Lean runtime link deps.  
2. Affine resources enforce free/close discipline in the checker.  
3. `@[export_c]` smoke covers open/put/get/sync-class APIs over bytes + files/mmap.  
4. Consumer `ldd` / `readelf -d` / `nm` evidence is part of the example harness.  
5. Host proofs can sit beside the extract without entering the embed TCB.  

Until that is true on a given pin, default Lean remains export + managed runtime.

---

## Forbidden on the extract path (summary)

`lean_object*`, automatic RC, `libleanshared` / Lean shared dynlibs, unrestricted Lean `IO`, managed `List`/`String`/`Array` on the product hot path, exception objects as control flow.

**Keep on host / erased:** `Prop`, tactics, proof-only predicates, dependent indices as proofs.

---

## Complexity traps (do not invent)

1. Full borrow checker before freestanding scalars work  
2. “Safe subset of all of Lean” instead of a **closed fragment**  
3. True linear IR as day-one requirement  
4. Fat runtime metadata on every pointer  
5. Implicit global allocator  
6. Dual semantic engines (hand-written C as SSOT)  

---

## See also

- **[Systems Lean (canonical)](doc/dev/systems-lean.md)**  
- Example: `tests/lake/examples/systems/`  
- Integration smoke: `./script/systems-lean-smoke.sh`  
- Self-host product path (R6): `doc/dev/systems-lean-selfhost.md` / `./script/systems-selfhost.sh`  
- Stdlib inventory + R7 product path: `doc/dev/systems-lean-stdlib-inventory.md`  
- Development index: `doc/dev/index.md`  
