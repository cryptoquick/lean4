/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Hash
public import Systems.Status

/-!
# Systems.Map (Systems Lean)

Fixed-capacity open-addressing table over **raw memory** — HashMap-**shaped**, not
`Std.HashMap` and not a managed collection.

Layout (caller-owned dual buffers):

* `keys` — `cap` host-endian `U32` slots (`cap * 4` bytes), **4-byte aligned**
* `vals` — `cap` host-endian `U32` slots, **4-byte aligned**
* `tags` — `cap` bytes: `0` empty, `1` occupied, `2` tombstone

Ops use linear probe from `finalizeU32(key) % cap`. Status codes follow
`Systems.Status` (`0` ok, `1` not found (erase), `3` bounds/full, …).

## Tombstones / erase / rehash (caller-owned grow)

* **Erase** marks the slot tombstone (`2`) so probes that passed through it stay valid.
* **Insert** reuses the first tombstone on the probe chain when the key is new.
* **Rehash** copies occupied slots into a **caller-provided** destination table
  (typically larger). There is **no** freestanding allocator inside Map — grow is
  dual-buffer rehash, not an in-place realloc of managed storage.

## Portability / ABI

* **LP64 product harness:** `get` miss uses `USize.neg1` (`(size_t)-1`). On ILP32 that
  collides with storing `UINT32_MAX` as a value — treat this surface as **LP64-only**
  (same class of sentinels as `Sys` log APIs). Prefer `contains` when only presence matters.
* **Alignment:** `U32.load` / `U32.store` are host-endian word accesses; unaligned
  `keys`/`vals` bases are ISO C undefined behavior. Callers must pass 4-byte-aligned buffers
  (e.g. `uint32_t[]` / arena with natural alignment).
* **Capacity contract:** `u32Slot` uses `USize.mul i 4` without overflow checks. Callers must
  keep `cap` small enough that `cap * 4` and probe arithmetic fit in `size_t` (practical embed
  caps ≪ `SIZE_MAX/4`). Adversarial huge `cap` can wrap offsets — not a product harness claim.
* **Rehash buffers:** source and destination ranges must not overlap. Destination tags are
  cleared by `rehash`; destination key/val slots need only be writable (contents overwritten
  for occupied inserts).
* **Not claimed:** full HashMap API, load-factor policy, concurrent maps, or collision-free
  guarantees. Full table (no empty/tomb for a new key) → `errBounds` without writing past
  capacity. Not `Std.HashMap`.

## Intentional TCB (Map-local)

`U32.load`/`store`, `USize.ofU32`/`mod`/`mul`, and `tagOcc`/`tagTomb` are freestanding
`@[extern]` axioms kept **here** (not promoted into Scalars) so the HashMap-shaped surface
owns its word memory/arithmetic FFI. Name-pinned on ComplianceCorpus (`path name=Ident` in
`systems-tcb-axiom-allowlist.txt`; not path-only — silent TCB growth blocked).
-/

namespace Systems.Map

open Systems.Scalars
open Systems.Bytes
open Systems.Hash
open Systems.Status

/-- Host-endian `uint32_t` load (`addr` must be 4-byte aligned). -/
@[extern c inline "(*((const uint32_t*)(#1)))"]
public axiom U32.load : USize → U32

/-- Host-endian `uint32_t` store; returns `0` (`addr` must be 4-byte aligned). -/
@[never_extract, extern c inline "(*((uint32_t*)(#1)) = (uint32_t)(#2), (uint32_t)0)"]
public axiom U32.store : USize → U32 → U32

/-- Widen `U32` → `USize`. -/
@[extern c inline "((size_t)(uint32_t)(#1))"]
public axiom USize.ofU32 : U32 → USize

/-- Unsigned modulo (`a % b`). Caller must keep `b ≠ 0`. -/
@[extern c inline "((size_t)((size_t)(#1) % (size_t)(#2)))"]
public axiom USize.mod : USize → USize → USize

/-- Unsigned multiply. -/
@[extern c inline "((size_t)((size_t)(#1) * (size_t)(#2)))"]
public axiom USize.mul : USize → USize → USize

/-- Address of `U32` slot `i` in a contiguous word array at `base` (base 4-byte aligned). -/
@[inline] public def u32Slot (base : USize) (i : USize) : USize :=
  USize.add base (USize.mul i USize.four)

/-- Occupied tag byte (`1`) — freestanding constant (no closed Lean term). -/
@[extern c inline "1"] public axiom tagOcc : U8

/-- Tombstone tag byte (`2`) — deleted slot; probe continues past it. -/
@[extern c inline "2"] public axiom tagTomb : U8

/-- Zero `cap` tag bytes starting at `tags` (self-TCO). Internal loop helper. -/
private unsafe def clearGo (tags : USize) (i : USize) (cap : USize) : U32 :=
  bifU32 (USize.blt i cap)
    (let _s := U8.store (USize.add tags i) U8.zero
     clearGo tags (USize.add i USize.one) cap)
    U32.zero

/-- Initialize / clear table occupancy (`cap == 0` is a no-op success).

`@[never_extract]` — tag stores are effects; rehash sequences this result so EmitC
cannot DCE a discarded clear before `rehashGo`. -/
@[never_extract]
public unsafe def clear (tags : USize) (cap : USize) : U32 :=
  clearGo tags USize.zero cap

/-- Alias of `clear` (document init-as-zero-tags). -/
@[never_extract]
public unsafe def init (tags : USize) (cap : USize) : U32 :=
  clear tags cap

/-- Home slot for `key`. If `cap == 0`, returns `0` without modulo (no `% 0` UB).

Internal: public `insert`/`get`/`contains`/`erase` still refuse `cap == 0` before probing. -/
private unsafe def homeSlot (key : U32) (cap : USize) : USize :=
  bifUSize (USize.beq cap USize.zero) USize.zero
    (USize.mod (USize.ofU32 (finalizeU32 key)) cap)

/-- Probe for an existing occupied key. Skips tombstones; stops on empty.

Returns slot index, or `USize.neg1` if absent. Internal. -/
private unsafe def findGo (keys : USize) (tags : USize) (key : U32) (cap : USize)
    (start : USize) (steps : USize) : USize :=
  bifUSize (USize.beq steps cap) USize.neg1
    (let s := USize.mod (USize.add start steps) cap
     let t := U8.load (USize.add tags s)
     bifUSize (U8.beq t U8.zero) USize.neg1
       (bifUSize (U8.beq t tagOcc)
         (bifUSize (U32.beq (U32.load (u32Slot keys s)) key) s
           (findGo keys tags key cap start (USize.add steps USize.one)))
         (findGo keys tags key cap start (USize.add steps USize.one))))

/-- Probe for insert: match → slot; else first tombstone on chain, else empty.

`firstTomb` is `USize.neg1` until a tombstone is seen. Full circle with no reusable slot
→ `USize.neg1`. Internal. -/
private unsafe def insertProbeGo (keys : USize) (tags : USize) (key : U32) (cap : USize)
    (start : USize) (steps : USize) (firstTomb : USize) : USize :=
  bifUSize (USize.beq steps cap) firstTomb
    (let s := USize.mod (USize.add start steps) cap
     let t := U8.load (USize.add tags s)
     bifUSize (U8.beq t U8.zero)
       (bifUSize (USize.beq firstTomb USize.neg1) s firstTomb)
       (bifUSize (U8.beq t tagOcc)
         (bifUSize (U32.beq (U32.load (u32Slot keys s)) key) s
           (insertProbeGo keys tags key cap start (USize.add steps USize.one) firstTomb))
         (bifUSize (U8.beq t tagTomb)
           (bifUSize (USize.beq firstTomb USize.neg1)
             (insertProbeGo keys tags key cap start (USize.add steps USize.one) s)
             (insertProbeGo keys tags key cap start (USize.add steps USize.one) firstTomb))
           (insertProbeGo keys tags key cap start (USize.add steps USize.one) firstTomb))))

/-- Insert or update `key → val`. `0` ok; `errBounds` if `cap == 0` or table full. -/
public unsafe def insert (keys : USize) (vals : USize) (tags : USize) (cap : USize)
    (key : U32) (val : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (let start := homeSlot key cap
     let s := insertProbeGo keys tags key cap start USize.zero USize.neg1
     bifU32 (USize.beq s USize.neg1) errBounds
       (let _k := U32.store (u32Slot keys s) key
        let _v := U32.store (u32Slot vals s) val
        let _t := U8.store (USize.add tags s) tagOcc
        ok))

/-- Lookup: value as `USize` (`0..UINT32_MAX`), or `USize.neg1` if missing / `cap == 0`.

**LP64 only** for the miss sentinel (see module docs). -/
public unsafe def get (keys : USize) (vals : USize) (tags : USize) (cap : USize)
    (key : U32) : USize :=
  bifUSize (USize.beq cap USize.zero) USize.neg1
    (let start := homeSlot key cap
     let s := findGo keys tags key cap start USize.zero
     bifUSize (USize.beq s USize.neg1) USize.neg1
       (USize.ofU32 (U32.load (u32Slot vals s))))

/-- `1` if key is present, `0` otherwise. -/
public unsafe def contains (keys : USize) (tags : USize) (cap : USize) (key : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) U32.zero
    (let start := homeSlot key cap
     let s := findGo keys tags key cap start USize.zero
     bifU32 (USize.beq s USize.neg1) U32.zero U32.one)

/-- Erase `key` by writing a tombstone. `0` ok; `err` if absent; `errBounds` if `cap == 0`. -/
public unsafe def erase (keys : USize) (tags : USize) (cap : USize) (key : U32) : U32 :=
  bifU32 (USize.beq cap USize.zero) errBounds
    (let start := homeSlot key cap
     let s := findGo keys tags key cap start USize.zero
     bifU32 (USize.beq s USize.neg1) err
       (let _t := U8.store (USize.add tags s) tagTomb
        ok))

/-- Count occupied slots (tombstones excluded). Self-TCO. -/
private unsafe def countGo (tags : USize) (i : USize) (cap : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i cap)
    (bifUSize (U8.beq (U8.load (USize.add tags i)) tagOcc)
      (countGo tags (USize.add i USize.one) cap (USize.add acc USize.one))
      (countGo tags (USize.add i USize.one) cap acc))
    acc

/-- Occupied entry count (`cap == 0` → `0`). -/
public unsafe def count (tags : USize) (cap : USize) : USize :=
  countGo tags USize.zero cap USize.zero

/-- Rehash occupied entries from old buffers into a fresh destination table.

Clears `newTags` then inserts each occupied `(key,val)`. Fails with `errBounds` if
`newCap == 0` or a destination insert fails (destination too small for occupied count).
Source and destination must not overlap. -/
private unsafe def rehashGo (oldKeys : USize) (oldVals : USize) (oldTags : USize)
    (oldCap : USize) (newKeys : USize) (newVals : USize) (newTags : USize) (newCap : USize)
    (i : USize) : U32 :=
  bifU32 (USize.blt i oldCap)
    (bifU32 (U8.beq (U8.load (USize.add oldTags i)) tagOcc)
      (let k := U32.load (u32Slot oldKeys i)
       let v := U32.load (u32Slot oldVals i)
       let st := insert newKeys newVals newTags newCap k v
       bifU32 (isOk st)
         (rehashGo oldKeys oldVals oldTags oldCap newKeys newVals newTags newCap
           (USize.add i USize.one))
         st)
      (rehashGo oldKeys oldVals oldTags oldCap newKeys newVals newTags newCap
        (USize.add i USize.one)))
    ok

/-- Dual-buffer rehash / grow sink: clear `newTags`, copy occupied entries from old table.

Clear status is **dataflow-used** (`bifU32 (isOk stClear) …`) so freestanding EmitC keeps
the tag-zeroing stores on the wire (a discarded `let _c := clear …` is DCE'd). -/
@[never_extract]
public unsafe def rehash (oldKeys : USize) (oldVals : USize) (oldTags : USize) (oldCap : USize)
    (newKeys : USize) (newVals : USize) (newTags : USize) (newCap : USize) : U32 :=
  bifU32 (USize.beq newCap USize.zero) errBounds
    (let stClear := clear newTags newCap
     bifU32 (isOk stClear)
       (rehashGo oldKeys oldVals oldTags oldCap newKeys newVals newTags newCap USize.zero)
       stClear)

end Systems.Map
