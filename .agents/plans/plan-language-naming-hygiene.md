# Plan: Language and naming hygiene (chat, files, identifiers)

**Slug:** `language-naming-hygiene`  
**Created:** 2026-07-20  
**Status:** draft — awaiting approval  

**Workspace:** `/home/hunter/Projects/cryptoquick/lean4`

---

## Context

### Problem

Two naming regimes already exist, and they do not cover the same failures:

| Layer | Where it lives today | What it governs | Gap |
|-------|----------------------|-----------------|-----|
| **Product module names** | `doc/dev/systems-naming.md` (+ Phase E gates) | `src/Systems/*.lean` basenames, PRODUCT manifest, no bulk rename | Mostly solved for modules |
| **Chat language** | Short “How to talk” in `~/.grok/AGENTS.md` | Prefer plain English; gloss tech names | Thin; implementation chats still default to `more89` / `W154` as the *topic* |
| **Identifiers in code and docs** | Implicit / ad hoc | Functions, C symbols, Makefile tokens, residual backlog strings, test names | No durable rules agents re-read |
| **Living residual prose** | `RESIDUAL.md`, `doc/dev/slake.md`, status scripts | Dense wave ledgers | Optimized for greppability, not for a human reading “what shipped?” |

The recent friction was not “rename `TomlConfig`.” It was treating **batch counters and internal tokens** (`moreN`, `Wn`, `PRODUCT_FS_NEXT` trios, `H5_host`, `CLAIMED`) as the main vocabulary of work, instead of **what the change does** (e.g. “presence checks for Lake log keys `warn` / `warning` / `information`”).

Lossy jargon fails in three ways:

1. **Chat** — user cannot follow progress without a decoder ring.
2. **Files and symbols** — vague or fashion names hide intent (already partially fixed for PRODUCT modules).
3. **Agent continuity** — after compaction, models re-adopt the densest tokens in living docs as the “real” language.

### Goals

1. Document **intentional, descriptive, natural-language-first** rules for:
   - how agents **speak** about work
   - how we **name** files, modules, functions, flags, and residual backlog tokens
2. Put those rules in **places agents load early** (global AGENTS, project AGENTS, living Systems nav, systems-naming).
3. Separate **stable identity** (what the feature is) from **process bookkeeping** (which residual batch it rode in on).
4. Prefer **extend existing docs** over new parallel “hygiene blogs.”
5. Make rules **actionable in one sentence** so implementers can apply them mid-wave without a design digression.

### Non-goals

- Bulk rename of existing `moreN` ledger history in `slake.md` / RESIDUAL (optional later; not required for hygiene to ship).
- Reopening product de-`Lite` / nonsense-farm delete work (owned by `plan-systems-naming-cleanup.md`).
- Renaming stable freestanding ABI prefixes (`lean_fs_*`) or Lake’s own option spellings.
- Forcing every Makefile/status token into prose English (machine-facing tokens may stay short if **glossed** when human-facing).
- Implementing the next residual wave in this plan.

### Assumptions

- Global `~/.grok/AGENTS.md` is the right pin for **all** chats on this machine; project `AGENTS.md` is the pin for **lean4-specific** Systems residual language.
- `doc/dev/systems-naming.md` remains the **product-module** authority; this plan **extends** it with identifier + language layers, not replaces it.
- Residual batch labels (`more89`, wave indexes) may still exist for **ledger continuity**, but must not be the headline of user-facing or agent-facing summaries.

### Constraints

- **Read-only product code until plan approval** (this file only until then).
- Do not invent a third naming “framework.” One short policy surface, cross-linked.
- Documentation hygiene rule already in global AGENTS: process corrections must land in durable files **same turn** — this plan operationalizes that for naming.
- Keep dual residual honesty vocabulary (`PRODUCT_GC_FREE` vs elaborator) precise when needed; plain English does not mean imprecise claims.

---

## Approach

**Recommended path:** write a small **layered policy**, then wire **discovery pointers** so agents hit it without searching.

```
Layer 0 — How we talk (chat + status summaries)
Layer 1 — How we name durable things (files, modules, functions, exports)
Layer 2 — How we name process-only things (waves, moreN, backlog tokens)
Layer 3 — Where agents find this (AGENTS pins + systems-naming + living-nav one-liners)
```

### Layer 0 — How we talk

**Rule:** Lead with the **job**, not the **batch id**.

| Prefer | Avoid as primary vocabulary |
|--------|-----------------------------|
| “Add TomlConfig presence checks for Lake keys `warn`, `warning`, and `information`.” | “Ship more89 / W154.” |
| “Host still uses classic RC; do not claim GC-free elaborator.” | Bare `H5_host` with no gloss |
| “No new freestanding Lake command runners.” | Bare `Slake_parity_more` as if it were a feature name |

**Allowed:** mention batch/ledger ids **once**, in parentheses or a “ledger:” footnote, when continuity with RESIDUAL requires it.

**Gloss once:** when a machine token is unavoidable (`PRODUCT_FS_NEXT`, `FS_READY`, `CLAIMED`), give a short plain gloss the first time in the reply.

Expand the existing global “How to talk” from three lines into a short normative subsection with **good/bad examples** drawn from Systems residual (not abstract platitudes).

Mirror a **leaner** “Systems residual language” subsection in project `AGENTS.md` so lean4-only agents that only load repo AGENTS still see it.

### Layer 1 — How we name durable things

Extend `systems-naming.md` (or a clearly titled section therein / sibling `systems-language.md` only if systems-naming would bloat past “product modules”) with rules for:

| Kind | Principle | Examples |
|------|-----------|----------|
| **Module / file** | Name the algorithm or responsibility a caller would search for | `TomlConfig.lean`, not `ConfigMore.lean` |
| **Function / method** | Verb or predicate + domain noun; match Lake/host spelling when mirroring greppable keys | `hasWarn`, `hasInformation` (key presence), not `more89a` |
| **C export** | Stable family prefix + short stem; do not encode wave numbers | `lean_fs_tomlcfg_has_warn`, not `lean_fs_tomlcfg_more89` |
| **Test / smoke name** | Behavior under test | `tomlcfg_has_warn_absent`, not `test_w154` |
| **Doc title / section** | Human sentence fragment | “Presence checks for log keys”, not “more89 trio” |

**Anti-patterns (identifiers):**

- Encoding residual wave or `moreN` into permanent symbol names
- Thesaurus / fashion synonyms for the same behavior (already forbidden for PRODUCT)
- Abbreviations that need a private legend (`H5` alone in a public module name — host honesty stays a **process** label, not a product basename)
- Jargon stacks in filenames: `Systems/FsNextH5HostParity.lean`

**Test for a good name:** a reader who never saw the residual ledger can still guess what the file/function does.

### Layer 2 — How we name process-only things

Keep machine-oriented ledger tokens, but **quarantine** them:

| Token class | Role | Human-facing rule |
|-------------|------|-------------------|
| Wave index (`W154`) | Internal implement/review loop counter | Never headline; optional ledger footnote |
| `TomlConfig_moreN` | Backlog progress marker for “next greppable Lake keys” | Speak as “next TomlConfig key presence checks”; keep token in `PRODUCT_FS_NEXT` / RESIDUAL only |
| `H5_host` | Dual residual honesty work on host elaborator | Speak as “host elaborator honesty (classic RC; do not forge GC-free)” |
| `Slake_parity_more` | Slake command parity residual | Speak as “Slake parity / no new freestanding Lake runners” |
| `FS_READY`, `PRODUCT_GC_FREE=1` | Gate measurements | Gloss on first use; never imply count growth is the goal |

**Hard rule:** **do not** create new permanent files, functions, or product modules whose **primary** name is a process token.

**Soft rule for living docs:** when appending a residual ledger line, start the prose clause with **what changed**, then attach wave/more tokens for grep continuity.

### Layer 3 — Agent discoverability (where to write)

| Pin | Action | Why agents find it |
|-----|--------|--------------------|
| `~/.grok/AGENTS.md` | Expand **How to talk** + pointer to project naming docs | Loaded for every chat on this machine |
| `AGENTS.md` (repo root) | New short section **Language and naming** with links | Loaded for lean4 work; today has **zero** naming/language text |
| `doc/dev/systems-naming.md` | Add sections: **Identifiers**, **Process vs product names**, **Chat and living-doc language** (or “See also” to a thin sibling if cleaner) | Already linked from systems-lean, index, RESIDUAL |
| `doc/dev/index.md` | One-line expand if needed | Dev doc map |
| `doc/dev/systems-lean.md` | Keep existing naming pointer; add one sentence that language hygiene applies to residual prose too | Primary Systems entry |
| `RESIDUAL.md` (top or “Conventions”) | 3–5 line **How to read / how to write updates** | Highest-traffic living tracker |
| Optional: implement skill / residual prompts | One bullet: “Lead with behavior; batch ids secondary” | Only if implement prompts are maintained in-repo |

**Not recommended:** a new top-level `LANGUAGE.md` with no inbound links — agents will not open it.

### Material alternatives rejected

- **Not “rename everything historical moreN in slake.md” first** — huge diff, low agent-discoverability payoff; policy + future lines first.
- **Not only chat rules** — user explicitly asked for file names and identifiers.
- **Not a new gate script for English** — unenforceable; gates stay for PRODUCT basename patterns already covered.
- **Not replacing systems-naming.md** — product module policy is good; extend it.

---

## Critical files

| Path | Why |
|------|-----|
| `~/.grok/AGENTS.md` | Global “How to talk” — first agent-visible chat pin |
| `AGENTS.md` | Project pin; currently missing language/naming |
| `doc/dev/systems-naming.md` | Product naming authority; natural home for identifier + process-token sections |
| `doc/dev/systems-lean.md` | Systems entry; already points at naming |
| `doc/dev/index.md` | Dev index link |
| `RESIDUAL.md` | Living residual; sets tone of every wave update |
| `.agents/plans/plan-systems-naming-cleanup.md` | Sibling plan; cross-link only (no phase rewrite) |
| `.agents/plans/plan-language-naming-hygiene.md` | This plan |

---

## Reuse

| Artifact | Path | How |
|----------|------|-----|
| Product naming principles | `doc/dev/systems-naming.md` | Keep; add identifier + language layers |
| How to talk | `~/.grok/AGENTS.md` | Expand with examples; link to systems-naming |
| Documentation hygiene | `~/.grok/AGENTS.md` | Already requires durable write-down; cite from new sections |
| Dev index | `doc/dev/index.md` | Ensure naming/language entry is findable |
| Naming cleanup plan | `.agents/plans/plan-systems-naming-cleanup.md` | “See also” for product surface work vs this language plan |

---

## Steps

Ordered; documentation-only until any optional later enforcement.

1. **Lock vocabulary split** — In the plan (done above): product identity vs process ledger vs chat lead sentence. No code.

2. **Expand global How to talk** (`~/.grok/AGENTS.md`)  
   - Good/bad examples for residual work  
   - “Batch ids are footnotes”  
   - Link: `doc/dev/systems-naming.md` (and after step 3, the new sections)  
   - Keep short enough to re-read after compaction (~15–25 lines, not an essay)

3. **Add project Language and naming** (`AGENTS.md`)  
   - 10–20 lines: lead with behavior; no wave-as-filename; pointer to `systems-naming.md`  
   - Note: dual residual honesty phrases stay precise when claiming freestanding vs elaborator

4. **Extend `systems-naming.md`**  
   - New sections (proposed titles):  
     - **Identifiers** (files, functions, C stems, tests)  
     - **Process tokens vs product names** (`moreN`, waves, `PRODUCT_FS_NEXT` components)  
     - **Living docs and agent chat** (lead sentence pattern for RESIDUAL / status)  
   - Cross-link this plan and global AGENTS  
   - Do **not** weaken existing hard rule (no bulk rename)

5. **Light living-nav pointers**  
   - `systems-lean.md`: one sentence that residual **prose** follows language hygiene  
   - `doc/dev/index.md`: ensure “Product naming” blurb mentions identifiers + plain language  
   - `RESIDUAL.md`: short **Update style** note at top or conventions: “what changed first; ledger tokens second”

6. **Optional same-PR: one exemplar residual line rewrite**  
   - Rewrite **only** the current/next Remaining / Options lines to model the style (not the full historical ledger)  
   - Proves the convention without a history rewrite

7. **Stop for use** — After docs land, next residual implement uses the style; no product rename required by this plan.

**Dependencies:** 2–3 can be parallel; 4 should land with or immediately after 2–3 so links resolve; 5 after 4; 6 optional last.

---

## Risks

| Risk | Mitigation |
|------|------------|
| Docs grow but agents still say `more89` | Put rules in AGENTS (always loaded), not only deep doc/dev |
| Over-long AGENTS section ignored | Cap length; examples over theory |
| Conflict with greppable residual ledger | Allow tokens in RESIDUAL/scripts; forbid them as **lead** language and as **permanent** symbol names |
| Scope creep into bulk history rewrite | Explicit non-goal; optional exemplar only |
| Confusing with product de-Lite plan | Cross-link; this plan does not rename modules |

---

## Verification

Documentation-only acceptance:

1. **Findability check (manual):** From a cold agent bootstrap, paths above answer:  
   - How should I title this work for the user?  
   - May I name a function `more89_check`?  
   - Where do product module name rules live?
2. **Grep check:**  
   - `How to talk` / `Language and naming` / `Process tokens` present in the pins  
   - `systems-naming.md` links from project `AGENTS.md` and systems-lean  
3. **Style smoke (optional):** Draft one fake status sentence before/after; human prefers after.  
4. **No product/test regression required** for pure doc steps — if step 6 touches RESIDUAL only, no build.

---

## Open questions

1. **Sibling file vs extend systems-naming?**  
   - **Default recommendation:** extend `systems-naming.md` (one authority).  
   - Switch to `doc/dev/systems-language.md` only if the product-module sections would become hard to scan.

2. **Historical ledger rewrite?**  
   - **Default:** no. Future lines only (+ optional current Remaining exemplar).

3. **Should implement/residual slash prompts in-repo get a one-liner?**  
   - **Default:** yes if such prompts exist in-repo; skip if they live only in chat.

4. **Global vs project weight:**  
   - Chat examples that are Systems-specific: prefer project AGENTS + systems-naming; global AGENTS stays domain-agnostic with 1–2 generic examples + “for lean4 Systems see …”.

---

## Implementation todos (for post-approval handoff)

| Id | Step |
|----|------|
| `impl:global-how-to-talk` | Expand `~/.grok/AGENTS.md` How to talk |
| `impl:project-agents-language` | Add Language and naming to repo `AGENTS.md` |
| `impl:systems-naming-extend` | Identifiers + process tokens + living-doc sections |
| `impl:living-nav-pointers` | systems-lean, index, RESIDUAL update-style note |
| `impl:optional-exemplar` | Optional rewrite of current Remaining lines only |
| `impl:verify-findability` | Grep + cold-read checklist |

---

## Present summary (for user)

This plan documents **how we name and how we talk**, in the places agents already load:

1. **Chat:** lead with the real job; wave/`moreN` tokens are ledger footnotes.  
2. **Code:** files/functions/exports describe behavior, never batch numbers.  
3. **Product modules:** keep existing `systems-naming.md` policy.  
4. **Pins:** global AGENTS → project AGENTS → systems-naming → light RESIDUAL/systems-lean pointers.

No residual feature work and no bulk renames in this plan.
