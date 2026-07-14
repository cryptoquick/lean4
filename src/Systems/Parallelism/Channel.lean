/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics

/-!
# Systems.Parallelism.Channel (Three-Layer Cake L3)

**L3 — linear send/recv API** for a single-slot freestanding channel.

* `Chan` is `@[affine]` (multiplicity 1): open once, close once; no silent drop.
* Payload is a freestanding `U64` (ω scalar) in a one-cell buffer — **no RC queues**.
* **Sequential / synchronous** product default (no OS threads, no Lean `Task`):
  `send` stores, `recv` loads. Not a verified concurrent runtime.
* Types enforce linear ownership of the channel handle only — not a pthread memory model.
* Export name `lean_fs_par_chan_*` marks Three-Layer Cake layer id, not pthread.

## Product emit discipline

Effectful open/send/recv/close are `@[never_extract]`. Composites that sequence them
(`pingPong`, `pingPongPair`, `trySmoke`) are also `@[never_extract]` and **use** the
`chanClose` result in the return value so freestanding DCE cannot drop `free`.
-/

namespace Systems.Parallelism.Channel

open Systems.Scalars
open Systems.Numerics

/-- Affine one-cell channel handle (backing storage is a `U64*` as `USize`). -/
@[affine]
public structure Chan where
  raw : USize

/-- Consume channel handle to raw pointer bits (explicit; for close paths). -/
@[never_extract, extern c inline "(#1)"]
public axiom intoUSize (c : Chan) : USize

/-- Borrow channel address as `USize` (for dual-param out slots; does not consume). -/
@[fs_borrow, extern c inline "((size_t)(#1))"]
public axiom chanAddr (c : Chan) : USize

/-- Null channel (`(size_t)0`) — OOM / failed open. -/
@[extern c inline "((size_t)0)"]
public axiom chanNull : Chan

/-- Non-null test (borrow). -/
@[fs_borrow, extern c inline "(uint8_t)((size_t)(#1) != 0)"]
public axiom chanIsNonNullU8 (c : Chan) : U8

@[fs_borrow, inline] public def chanIsNonNull (c : Chan) : Bool :=
  Bool.ofU8 (chanIsNonNullU8 c)

/-- Allocate a one-cell `U64` buffer and wrap as affine `Chan` (`0` on OOM).

Caller must `chanClose` exactly once (including OOM null — `free(NULL)` is a no-op).
Named `chanOpen` (not `open`) — Lean keyword. -/
@[never_extract, extern c inline "((size_t)malloc(sizeof(uint64_t)))"]
public axiom chanOpen : Chan

/-- Free the channel buffer (**consumes** affine `Chan`). Returns `0`. `free(NULL)` is OK. -/
@[never_extract, extern c inline "((uint32_t)(free((void*)(#1)), 0))"]
public axiom chanClose (c : Chan) : U32

/-- Store payload into the channel cell (**borrow** channel; payload is ω).

Caller must ensure non-null (see `pingPong` OOM path). -/
@[fs_borrow, never_extract, extern c inline "((uint32_t)((*((uint64_t*)(#1)) = (uint64_t)(#2)), 0))"]
public axiom send (c : Chan) (v : U64) : U32

/-- Load payload from the channel cell (**borrow** channel). Non-null required. -/
@[fs_borrow, never_extract, extern c inline "((uint64_t)(*((uint64_t*)(#1))))"]
public axiom recv (c : Chan) : U64

/-- Status-returning try-send: `0` stored, `1` null channel (no store).

Sequential one-cell has no full/empty bit — non-null is the only soft failure. -/
@[fs_borrow, never_extract]
public def trySend (c : Chan) (v : U64) : U32 :=
  bifU32 (chanIsNonNull c) (send c v) U32.one

/-- Status-returning try-recv into dual-param out slot.

Returns:

* `0` — non-null channel; wrote `*out` from the cell
* `1` — null channel (out untouched)
* `2` — non-null channel but `out == 0` (null out; no write — avoids UB)

**Caller contract:** when the channel is non-null, `out` must be a valid non-null
`U64*` (or you get status `2`). Sequential only — always "ready" when the cell is
non-null (no empty state). -/
@[fs_borrow, never_extract, extern c inline
  "((uint32_t)(((size_t)(#1) == 0) ? 1u : (((size_t)(#2) == 0) ? 2u : ((*((uint64_t*)(#2)) = *((const uint64_t*)(#1))), 0u))))"]
public axiom tryRecv (c : Chan) (out : USize) : U32

/-- Constant 4 for try-path status combinations (avoid closed `2+2` ground terms). -/
@[extern c inline "4"]
public axiom u32Four : U32

/-- Smoke: open → (OOM check) → send → recv → close.

Returns:

* `0` — match and free ok
* `1` — value mismatch (still frees)
* `2` — OOM (`malloc` null; frees null, no send/recv)

`@[never_extract]` + `chanClose` result fed into return so product C retains `free`. -/
@[never_extract]
public def pingPong (v : U64) : U32 :=
  let c := chanOpen
  bifU32 (chanIsNonNull c)
    (let _s := send c v
     let got := recv c
     let cl := chanClose c
     bifU32 (U64.beq got v) cl (U32.add cl U32.one))
    (let cl := chanClose c
     U32.add cl U32.two)

/-- Dual-payload sequential rendezvous via `trySend`/`tryRecv` (keeps try* live in IR).

open → trySend a → tryRecv → compare → trySend b → tryRecv → compare → close.

Compares each payload **before** the next store so freestanding emit cannot float
`recv` loads past later `trySend`/`tryRecv` effects.

Returns:

* `0` — both payloads match and free ok
* `1` — first payload mismatch (still frees)
* `3` — second payload mismatch (still frees)
* `2` — OOM
* `4` — trySend/tryRecv status failure (still frees)

Still **sequential** product path; no OS threads. Free result is dataflow-used. -/
@[never_extract]
public def pingPongPair (a : U64) (b : U64) : U32 :=
  let c := chanOpen
  bifU32 (chanIsNonNull c)
    (let out := chanOpen
     bifU32 (chanIsNonNull out)
       (let s1 := trySend c a
        bifU32 (U32.beq s1 U32.zero)
          (let r1 := tryRecv c (chanAddr out)
           bifU32 (U32.beq r1 U32.zero)
             (let gotA := recv out
              -- Branch on gotA before next effect (prevents load reordering past store).
              bifU32 (U64.beq gotA a)
                (let s2 := trySend c b
                 bifU32 (U32.beq s2 U32.zero)
                   (let r2 := tryRecv c (chanAddr out)
                    bifU32 (U32.beq r2 U32.zero)
                      (let gotB := recv out
                       let clO := chanClose out
                       let cl := chanClose c
                       bifU32 (U64.beq gotB b)
                         (U32.add cl clO)
                         (U32.add (U32.add cl clO) U32.three))
                      (let clO := chanClose out
                       let cl := chanClose c
                       U32.add (U32.add cl clO) u32Four))
                   (let clO := chanClose out
                    let cl := chanClose c
                    U32.add (U32.add cl clO) u32Four))
                (let clO := chanClose out
                 let cl := chanClose c
                 U32.add (U32.add cl clO) U32.one))
             (let clO := chanClose out
              let cl := chanClose c
              U32.add (U32.add cl clO) u32Four))
          (let clO := chanClose out
           let cl := chanClose c
           U32.add (U32.add cl clO) u32Four))
       (let clO := chanClose out
        let cl := chanClose c
        U32.add (U32.add cl clO) U32.two))
    (let cl := chanClose c
     U32.add cl U32.two)

/-- Try-path smoke: null trySend/tryRecv + null-out tryRecv + happy trySend/tryRecv.

Returns `0` on expected statuses; non-zero on mismatch. Forces try* into product IR.
Null handle is closed once (`free(NULL)` is a no-op) so affine ownership stays exact. -/
@[never_extract]
public def trySmoke (v : U64) : U32 :=
  let n := chanNull
  let sNull := trySend n v
  let rNull := tryRecv n USize.zero
  let clN := chanClose n
  let c := chanOpen
  bifU32 (chanIsNonNull c)
    (let rBadOut := tryRecv c USize.zero
     let sOk := trySend c v
     let out := chanOpen
     bifU32 (chanIsNonNull out)
       (let rOk := tryRecv c (chanAddr out)
        let got := recv out
        let clO := chanClose out
        let cl := chanClose c
        -- expect sNull=1, rNull=1, rBadOut=2, sOk=0, rOk=0, closes=0
        bifU32 (U32.beq sNull U32.one)
          (bifU32 (U32.beq rNull U32.one)
            (bifU32 (U32.beq rBadOut U32.two)
              (bifU32 (U32.beq sOk U32.zero)
                (bifU32 (U32.beq rOk U32.zero)
                  (bifU32 (U64.beq got v)
                    (U32.add clN (U32.add cl clO))
                    (U32.add (U32.add clN (U32.add cl clO)) U32.one))
                  (U32.add (U32.add clN (U32.add cl clO)) U32.one))
                (U32.add (U32.add clN (U32.add cl clO)) U32.one))
              (U32.add (U32.add clN (U32.add cl clO)) U32.one))
            (U32.add (U32.add clN (U32.add cl clO)) U32.one))
          (U32.add (U32.add clN (U32.add cl clO)) U32.one))
       (let clO := chanClose out
        let cl := chanClose c
        U32.add clN (U32.add cl (U32.add clO U32.two))))
    (let cl := chanClose c
     bifU32 (U32.beq sNull U32.one)
       (bifU32 (U32.beq rNull U32.one)
         (U32.add clN (U32.add cl U32.two))
         (U32.add clN (U32.add cl U32.one)))
       (U32.add clN (U32.add cl U32.one)))

end Systems.Parallelism.Channel
