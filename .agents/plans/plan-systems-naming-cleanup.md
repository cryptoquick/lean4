# Plan: Systems product naming cleanup (intentional names, delete nonsense)

**Slug:** `systems-naming-cleanup`  
**Created:** 2026-07-19  
**Revised:** 2026-07-19 (eliminate header/magic farms; no bulk rename; no parameterized stand-ins)  
**Status:** Phase A complete (policy + freeze + implement stub cleaned); Phases B–E pending  

**Workspace:** `/home/hunter/Projects/cryptoquick/lean4`

### User decisions (locked)

| Decision | Choice |
|----------|--------|
| Long-term naming | **Drop `Lite` entirely** — plain names; honesty in module docs, not a suffix |
| Track L / nonsense farms | **Eliminate** — not “collapse into SyncHeader/MagicTag generics” |
| 4-byte V* headers / 6-byte G*Nb magics | **Nonsense to remove** — do the work to delete them from PRODUCT |
| First stack | **Policy + freeze first**, then thoughtful per-module cleanup |
| Rename mechanics | **No bulk find-and-replace** — hard, persistent requirement |

---

## Context

### Problem

Residual waves grew `FS_READY` by shipping **named clones** and **fake standards modules** as if they were a stdlib:

| Farm | Approx count | What it actually is | Why the name is a lie |
|------|--------------|---------------------|------------------------|
| Thesaurus `*HeapLite` (Yarn…Skein, Plait, Cable, …) | ~39 | Same ordered unique U32 set | Fashion-word “heap” ≠ algorithm |
| Synonym `*SetLite` leaves (Unique/Distinct/Equal/…) | many | Same or near-same set shape | Thesaurus ≠ data structure |
| `V1Lite`…`V45Lite` | ~45 | 4-byte “modem header” with a different sync byte | Not ITU V-series implementations |
| `G7*NbLite` (and peers) | ~25+ | 6-byte ASCII magic + tiny helpers | Not G.7xx codecs |
| Blanket `*Lite` suffix | ~323 / ~340 product | “Shaped / not full X” honesty tag | Hides real vs clone; core already omits it (`Proc`, `Bytes`, …) |

Poor naming is not cosmetic. It:

- **Inflates PRODUCT** and residual “progress” with modules nobody should depend on
- **Duplicates effort** — the same ordered-set body was re-exported dozens of times under new names; we cannot yet quantify how much review/harness/allowlist work was wasted until we audit family-by-family
- **Blocks intentional design** — real names (`OrderedU32Set`, `TomlConfig`, `BinaryHeap`) cannot win while `SkeinHeapLite` still counts as product

### Goals

1. **Freeze** any further nonsense product growth (no new thesaurus / V## / magic-only modules).
2. Publish a **naming policy** that demands intentional names and forbids bulk renames.
3. **Delete** nonsense PRODUCT modules (4-byte header farm, 6-byte magic farm, thesaurus heaps) after **per-module audit** — not a parameterized `SyncHeader` / `MagicTag` consolation prize.
4. **Keep one** real module only where a real freestanding data structure remains (e.g. one ordered U32 set, one binary heap).
5. **De-Lite** surviving real modules **one name at a time**, with human judgment of collisions and meaning.
6. Redefine success: **honest surface > FS_READY count**. A falling count after deletes is a win.
7. **Discover duplicated effort** as part of cleanup (inventory what was cloned vs unique) so we learn how bad the treadmill was.

### Non-goals

- Replacing deleted nonsense with new generic “header” / “magic” PRODUCT modules.
- Big-bang `sed`/`rename` across 300 files.
- Full Init/Std parity.
- Forging H5 / touching `GC_FREE_ELABORATOR`.
- Renaming stable freestanding ABI family prefix `lean_fs_*` globally (exports may die **with** their module; survivors keep stable short names unless a deliberate ABI change is justified in that PR).
- Finishing more Track L names for W113+.

### Hard requirement — thoughtful changes only

**Persistent rule for every phase of this work:**

- **Do not** bulk find-and-replace module names, export prefixes, or docstring twin lists.
- **Do not** run tree-wide `sed -i`, mass `git mv` scripts, or “rename all *Lite” codemods.
- **Do** open the module, read what it implements, decide keep / rename / delete, then update **that** module’s harness edges deliberately.
- **Do** prefer small PRs (one family or one canonical rename) with a short written rationale in the PR body.
- Automation is allowed only for **read-only inventory** (lists, diffs, similarity reports) and for **gates that fail closed** after humans edit manifests — never for choosing names.

If a change cannot be justified in one plain sentence (“this is the ordered U32 set”; “this is not a V.45 modem”), it does not land.

### Constraints

- Star-shaped coupling: product modules rarely import each other; **Extract + manifests + main.c + allowlist** are the real blast radius.
- Deletes still require coordinated updates: `systems-product-stdlib-modules.txt`, corpus, allowlist, both lakefiles, Extract, `main.c` densify, Makefile T-pins, inventory, RESIDUAL.
- Never delete `build/` or `stage0/`.
- Baseline freeze point: current tree (W112-era FS_READY≈340 including Skein/V45/G707 if present).

---

## Approach

### Phased path

```
Phase A  Policy + freeze + inventory method     (S)   ← first PR
Phase B  Audit + DELETE nonsense farms          (L)   ← stacked PRs, no stand-in modules
Phase C  Deduplicate real collections           (M)   ← one ordered set, etc.
Phase D  Intentional de-Lite of survivors       (M–L) ← one module / small family per PR
Phase E  Regression gates + effort ledger       (S)   ← prevent treadmill return
```

**Rejected approaches**

| Rejected | Why |
|----------|-----|
| Parameterize into `SyncHeader` / `MagicTag` PRODUCT modules | Still product-izes nonsense shapes; user rejected |
| Rename clones in place (`OrderedU32Set01`) | Keeps the farm |
| Bulk de-Lite codemod | Violates thoughtful-naming requirement; hides collisions |
| Keep counting Track L +3 per residual wave | Recreates the problem |

### Naming policy (Phase A — normative doc)

New file: `doc/dev/systems-naming.md`.

#### Principles

1. **Name the thing that exists** — algorithm, layout, or responsibility a caller would search for.
2. **One module per distinct behavior** — if two TUs differ only by a constant or an accessor name, they are not two product modules.
3. **Honesty in the module header** — what it is, what it is not, freestanding contract. No universal `Lite` suffix.
4. **Standards numbers only for real subsets** — `G711` / `Http` / `Tls` only if tests describe multi-field or stateful behavior worth the name. Magic-string equality is not a codec.
5. **No bulk renames** — see hard requirement above.
6. **PRODUCT is not a trophy case** — residual waves must not add modules to inflate `FS_READY`.

#### Plain names (examples)

| Legacy | Fate |
|--------|------|
| `TomlConfigLite` | Rename → `TomlConfig` (Phase D, deliberate) |
| `MapLite` / real collections | Rename to plain collection names after audit |
| `HeapLite` (binary min-heap) | Rename → `BinaryHeap` (or `MinHeap`) after audit |
| `YarnHeapLite` … `SkeinHeapLite` | **Delete** after confirming clone of ordered U32 set; keep **one** survivor under a real name |
| `V45Lite` … `V1Lite` (4-byte sync toys) | **Delete** — not replaced by a generic header module |
| `G707NbLite` … magic-only annexes | **Delete** — not replaced by a generic magic module |
| `Proc`, `Scalars`, `Bytes` | Already correct — leave alone |

#### Forbidden PRODUCT patterns (gate later)

- New `*Lite.lean` after legacy allowlist drains
- New thesaurus heap names (Yarn/Cable/Weave/Plait/Braid/Twine/Rope/Skein/…)
- New `V[0-9]+` modules whose body is only sync/rate/ctrl/spare
- New `G7*Nb` / `*Nb` modules whose body is only ASCII magic match
- Residual prompts that say “Track L free trio” or “+3 FS_READY names”

#### Residual-wave recipe (after freeze)

| In scope | Out of scope |
|----------|--------------|
| H5 honesty-only (never forge GC_FREE) | Track L +3 |
| TomlConfig moreN — **real Lake keys only** | Thesaurus / V## / magic product adds |
| Slake dual residual — **real Lake commands** | FS_READY monotonic growth as a goal |
| A new module only with a **written purpose** in the PR | “Next free name” packing |

#### FS_READY

After deletes, `FS_READY` **will drop**. That is the intended signal that PRODUCT is becoming honest. Docs and SCORE narrative must not treat a lower count as failure.

---

## Critical files

| Path | Why |
|------|-----|
| `doc/dev/systems-naming.md` | **New** policy SSoT |
| `RESIDUAL.md` | Freeze Track L; ban +3 naming; FS_READY honesty |
| `doc/dev/systems-lean.md` | Link policy; stop Lite-as-identity |
| `script/systems-product-stdlib-modules.txt` | Membership SSoT |
| `script/systems-compliance-corpus.txt` | B2 align |
| `script/systems-tcb-axiom-allowlist.txt` | Pins die with modules |
| `script/systems-status.sh`, `systems-tcb-inventory.sh` | Backlog strings |
| `src/lakefile.toml.in`, `tests/lake/examples/systems/lib/lakefile.lean` | Roots |
| `tests/lake/examples/systems/lib/Extract.lean` | Import/export hub |
| `tests/lake/examples/systems/main.c`, `Makefile` | Densify + T-pins |
| `src/Systems/V*Lite.lean`, `G*NbLite.lean`, thesaurus `*HeapLite.lean` | Delete targets after audit |
| Survivors e.g. `OrderedSetLite` / `HeapSetLite` / `HeapLite` / `TomlConfigLite` | Keep or intentional rename |

## Reuse

| What | How |
|------|-----|
| Ordered U32 set implementation | Read several clones; pick **one** body as survivor; delete others — no new framework |
| Binary heap (`HeapLite`) | Keep as the real heap; later intentional rename |
| `Bytes` / field helpers | Already exist; callers that only needed magic/header toys should use Bytes directly or go away with the module |
| Extract export style | Delete exports with modules; do not invent bulk alias tables |
| Residual process | H5 + TomlConfig + Slake only |

---

## Steps

### Phase A — Policy, freeze, inventory method (first PR)

**Effort S · Risk low**

1. Write `doc/dev/systems-naming.md` (principles, forbidden patterns, no-bulk-rename rule, residual recipe, FS_READY honesty).
2. Update `RESIDUAL.md`:
   - **Track L / nonsense product growth: FROZEN**
   - Last accepted clone-era ship called out; **do not** schedule Skein/Coil/V50/G706-style work
   - Remaining = H5 + TomlConfig + Slake (+ naming cleanup phases)
   - Explicit: FS_READY will fall in Phase B by design
3. Point `systems-lean.md` (short Naming section) at the policy; mark `Lite` as **legacy**.
4. Adjust `PRODUCT_FS_NEXT` / backlog prose so it cannot be read as “add three names.”
5. Add a **read-only inventory method** (doc section or small script used manually):
   - List candidate nonsense modules by **family**
   - For each family, human records: unique vs clone (note file sizes / API sameness — **as evidence for delete**, not as a bulk rewrite input)
   - Start an **effort ledger** stub in the naming doc or `RESIDUAL.md`: “clone TUs found / unique algorithms found / harness lines removed” — filled during B/C so we learn duplication cost
6. **No** module deletes or renames in Phase A unless a one-off blocker appears.

**Exit A:** policy merged; residual prompts must not request Track L names; inventory method agreed.

### Phase B — Audit and DELETE nonsense (stacked PRs; no stand-ins)

**Effort L · Risk med–high · Thoughtful only**

Work **family by family**. For each candidate module:

1. **Read** the module (and one peer) — do not trust the filename.
2. **Classify** with a one-line verdict:
   - `DELETE_NONSENSE` — 4-byte header toy, 6-byte magic toy, pure rename clone
   - `KEEP_UNIQUE` — real algorithm/layout; schedule Phase D rename if needed
   - `KEEP_SURVIVOR` — last copy of a real shape (e.g. ordered U32 set)
3. **Delete** `DELETE_NONSENSE` modules and **only their** harness edges (Extract exports, main.c block, Makefile pins, allowlist, corpus, lakefile roots, manifest line).
4. **Do not** add `SyncHeader`, `MagicTag`, or similar PRODUCT replacements.
5. If a test only existed to densify a nonsense module, **delete the test** with the module.
6. Update living counts downward in the **same** PR; regenerate inventory when required.
7. Fill effort ledger: modules removed, approximate LOC/harness lines removed, note if anything surprisingly unique was found.

Suggested PR split (each with written audit notes in the PR body):

| PR | Family | Action |
|----|--------|--------|
| B1 | Thesaurus `*HeapLite` clones | Delete all but one ordered-U32-set survivor (name decided in audit — may still be temporary `*Lite` until Phase D) |
| B2 | `V*Lite` 4-byte header toys | Delete all pure sync-byte clones; keep only if audit finds a **different layout** worth a real name |
| B3 | `G7*NbLite` / pure magic annexes | Delete magic-only modules; keep only real codec subsets under honest names |
| B4 | Other magic-only audio Nb twins (if same pattern) | Same standard — audit, don’t bulk |

**Exit B:** PRODUCT contains no module whose sole job is a fashion-word heap, a 4-byte fake V-header, or a 6-byte fake G-magic. No generic stand-in modules added.

### Phase C — Deduplicate remaining real collections

After B1, audit remaining `*Set*` / map / tree modules:

- Merge pure synonyms into the survivor ordered set where bodies match
- Leave **actually different** structures (`BitSet`, `HashSet`, interval/roaring/btree sets, …) alone pending Phase D naming
- Still no bulk rename

### Phase D — Intentional de-Lite / rename of survivors

One module or tight family per PR:

1. Propose the **target name** in the PR description and why it is right (and why alternatives were rejected).
2. `git mv` **that** file; update imports/manifest/allowlist/Extract for **that** name only.
3. Prefer **stable** `lean_fs_*` export names when the ABI is already short (`tomlcfg`, `heap`); change exports only when the old export encodes a deleted lie (`yarnheap`, `g707nb`).
4. Module docstring rewritten for the real name — not a twin-paste list of fifty peers.
5. Gates green before the next rename.

Priority order (suggested):

1. Config/build: `TomlConfig`, `Manifest`, `DepGraph`, `Trace`
2. Real collections: `BinaryHeap`, `OrderedU32Set`, `Map`, `Queue`, …
3. Real codecs/parsers: only after B/C so we do not polish doomed files

### Phase E — Regression gates + ledger closeout

1. Extend `systems-product-stdlib-check.sh` (or sibling) to **fail closed** on:
   - new `*Lite.lean` outside a shrinking legacy allowlist
   - new paths matching frozen nonsense patterns (thesaurus heaps, pure `V[0-9]+`, pure `G7[0-9]+Nb`)
2. Document in AGENTS.md / residual implement instructions: must follow `systems-naming.md`; no Track L packing.
3. Publish effort ledger summary in RESIDUAL (how many clone TUs removed; residual unique product count).

---

## Risks

| Risk | Mitigation |
|------|------------|
| Bulk tools sneak back in under time pressure | Hard requirement in naming doc + PR checklist; reviewers reject codemod-only PRs |
| Over-delete a unique module | Per-module read; KEEP_UNIQUE path; PR must quote the distinguishing behavior |
| Under-delete (leave V45 “for later”) | Phase B exit criteria; gate patterns in E |
| FS_READY drop panic | Phase A messaging; STATUS OK does not require count ≥ previous |
| Harness left half-wired | Same-PR delete of Extract/main.c/Makefile/allowlist/manifest |
| Survivor still named `*Lite` for a while | Allowed briefly; Phase D renames deliberately — better temporary Lite than wrong plain name |
| Duplicate-effort unknown | Ledger in A/B forces measurement instead of vibes |

---

## Verification

### Phase A

```bash
test -f doc/dev/systems-naming.md
rg -n 'bulk find-and-replace|Track L|FROZEN|FS_READY' doc/dev/systems-naming.md RESIDUAL.md | head -40
./script/systems-status.sh   # OK=1; backlog not advertising Track L trios
```

### Each Phase B/C/D PR

```bash
# Human: PR body has per-module verdicts (or per-name rationale) — not "ran rename script"
make -C tests/lake/examples/systems run
make -C tests/lake/examples/systems check-nm
./script/systems-product-stdlib-check.sh
./script/systems-status.sh
./script/systems-stdlib-inventory.sh --require
```

Spot checks:

- Deleted module path gone from manifest, Extract, main.c, allowlist
- No new PRODUCT module named like the deleted nonsense
- No `SyncHeader` / `MagicTag` “replacement” product unless a future design explicitly argues a **real** shared parser (out of scope here)

### Phase E

Intentional violation on a throwaway branch must fail the naming gate.

---

## Open questions (non-blocking for Phase A)

1. **Ordered-set survivor name** — decide at B1 audit time among `OrderedU32Set` / `OrderedSet` / temporary keep; no bulk rename to force it.
2. **How aggressive is B4 (non-G7 magic audio)?** — same delete standard once B3 proves the method.
3. **PR stacking tool** — plain git stack vs Graphite; prefer small stacked PRs either way.
4. **W112 tree state** — freeze includes already-added Skein/V45/G707; they are delete candidates in B, not names to perpetuate.

---

## Suggested PR stack

| PR | Title | Scope |
|----|-------|--------|
| 1 | `doc: Systems naming policy; freeze nonsense product growth` | Phase A |
| 2 | `refactor: remove thesaurus HeapLite product clones` | B1 audit+delete |
| 3 | `refactor: remove V*Lite four-byte header product toys` | B2 |
| 4 | `refactor: remove G7*NbLite magic-only product modules` | B3 |
| 5+ | `refactor: rename <OneModule> to <IntentionalName>` | Phase D, repeated |
| N | `test: fail-closed gate against Lite/nonsense product names` | Phase E |

---

## Implementation todos (seed after approval)

- `impl:naming-policy-doc` — systems-naming.md + RESIDUAL/systems-lean freeze + ledger stub
- `impl:freeze-backlog-strings` — PRODUCT_FS_NEXT / remaining-work without Track L
- `impl:audit-delete-heap-clones` — B1 thoughtful delete
- `impl:audit-delete-v-header-toys` — B2
- `impl:audit-delete-magic-toys` — B3
- `impl:dedupe-real-sets` — Phase C
- `impl:rename-tomlconfig` — first Phase D exemplar (pattern for the rest)
- `impl:naming-regression-gate` — Phase E

---

## Critical Files for Implementation

- `doc/dev/systems-naming.md` — policy + no-bulk-rename rule
- `RESIDUAL.md` — freeze + honest FS_READY
- `script/systems-product-stdlib-modules.txt` — membership
- `tests/lake/examples/systems/lib/Extract.lean` — exports hub
- `tests/lake/examples/systems/main.c` — densify removal per delete
- `script/systems-tcb-axiom-allowlist.txt` — pin removal per delete
