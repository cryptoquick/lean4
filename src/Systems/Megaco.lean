/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Bytes
public import Systems.Status
public import Systems.Numerics

/-!
# Systems.Megaco (Systems Lean)

Megaco-**shaped** short-form **transaction token** scan over dual caller `addr`/`len`
byte views — not a full Megaco/H.248 stack, not context/termination descriptors, not
ASN.1 binary encoding product, not SDP/body product.

**Distinction from `H248`:** H248 is the **first-line version / mid / method**
peer (`MEGACO/` / `!/` + major digit + mid `'['` + first-token length). This module is
the complementary **transaction short-form token** peer on the same text family:

```
T=  TransactionRequest
P=  TransactionPending
R=  TransactionReply
K=  TransactionResponseAck
```

Typical text fragments (ASCII; may appear after a H.248 first-line mid):

```
T=10001{...}
P=10001
R=10001{...}
K=10001{...}
```

Minimum fence is **4** bytes (shaped lower bound for a tiny `T=1\n`-class token).

Ops:

* **validate** / **parse** — `0` if `n ≥ 4`, else `1` (too short); when long enough,
  probes first byte and folds it with `land 0` so dual-param `addr` is live
* **hasTxn** — `1` if a short-form `T=`/`P=`/`R=`/`K=` token is present, else `0`
* **txnKind** — `1`=`T`, `2`=`P`, `3`=`R`, `4`=`K`, else `0` (or short / absent)
* **txnId** — decimal digits after `=` as `U32` when present, else `0`
* **length** — first-line / fragment byte length until CR/LF (or `n` if no line end)
  as `U32` when long enough, else `0` (layout only; not a wire length field)
* **txnOff** — offset of the short-form txn marker when present, else miss

Honesty:

* **Short-form transaction token scan only** — no first-line `MEGACO/` version product
  (that is H248), no long-form `Transaction` keyword, no context/termination body
  walk, not a Megaco client/server, not binary ASN.1.
* **validate status is length-class only** (`ok`/`err`); the first-byte probe never
  changes the status value (`land` with zero) but keeps `addr` on the EmitC result path
  when `n ≥ 4`. Token legality is **not** enforced by validate.
* **loadAt dual-param honesty:** every load index is under `i < n` after fences.
  `loadAt` is **not** bounds-parameterized.

## Intentional TCB (Megaco-local)

Minimum length, ASCII markers, kind codes, offsets, and `U32.ofUSize` are freestanding
`@[extern]` axioms kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`).
Byte loads reuse `Scalars`/`Bytes`.
-/

namespace Systems.Megaco

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Numerics

/-- Megaco transaction-token shaped minimum length (4). -/
@[extern c inline "((size_t)4)"] public axiom minLen : USize
/-- Short-form token width (`X=` = 2). -/
@[extern c inline "((size_t)2)"] public axiom tokLen : USize
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- ASCII `'='` (61). -/
@[extern c inline "((uint32_t)61)"] public axiom cEq : U32
/-- ASCII `'T'` (84) — TransactionRequest short form. -/
@[extern c inline "((uint32_t)84)"] public axiom cT : U32
/-- ASCII `'P'` (80) — TransactionPending short form. -/
@[extern c inline "((uint32_t)80)"] public axiom cP : U32
/-- ASCII `'R'` (82) — TransactionReply short form. -/
@[extern c inline "((uint32_t)82)"] public axiom cR : U32
/-- ASCII `'K'` (75) — TransactionResponseAck short form. -/
@[extern c inline "((uint32_t)75)"] public axiom cK : U32
/-- ASCII `'0'` (48). -/
@[extern c inline "((uint32_t)48)"] public axiom cZero : U32
/-- ASCII `'9'` (57). -/
@[extern c inline "((uint32_t)57)"] public axiom cNine : U32
/-- Kind code for `T=` (1). -/
@[extern c inline "((uint32_t)1)"] public axiom kindT : U32
/-- Kind code for `P=` (2). -/
@[extern c inline "((uint32_t)2)"] public axiom kindP : U32
/-- Kind code for `R=` (3). -/
@[extern c inline "((uint32_t)3)"] public axiom kindR : U32
/-- Kind code for `K=` (4). -/
@[extern c inline "((uint32_t)4)"] public axiom kindK : U32
/-- Offset of second byte (1). -/
@[extern c inline "((size_t)1)"] public axiom off1 : USize
/-- Ten as `U32` (decimal accumulate). -/
@[extern c inline "((uint32_t)10)"] public axiom tenU32 : U32
/-- Narrow `USize` → `U32` (fragment length class; LP64 low 32). -/
@[extern c inline "((uint32_t)(size_t)(#1))"]
public axiom U32.ofUSize : USize → U32

/-- Load byte at index as `U32`. Caller ensures `i < n`. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is LF or CR. -/
public unsafe def isLineEnd (c : U32) : U32 :=
  bifU32 (U32.beq c cLf) U32.one
    (bifU32 (U32.beq c cCr) U32.one U32.zero)

/-- `1` if `c` is ASCII digit `'0'..'9'`. -/
public unsafe def isDigit (c : U32) : U32 :=
  bifU32 (U32.blt c cZero) U32.zero
    (bifU32 (U32.blt cNine c) U32.zero U32.one)

/-- Kind for byte `c` when followed by `'='`: T/P/R/K → 1..4, else 0. -/
public unsafe def kindOf (c : U32) : U32 :=
  bifU32 (U32.beq c cT) kindT
    (bifU32 (U32.beq c cP) kindP
      (bifU32 (U32.beq c cR) kindR
        (bifU32 (U32.beq c cK) kindK U32.zero)))

/-- First CR/LF in `[0, n)`, or `n` if none. -/
public unsafe def findLineEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isLineEnd (loadAt addr i)) U32.one) i
      (findLineEnd addr (USize.add i USize.one) n))
    n

/-- First short-form txn marker offset in `[i, n)`, or `n` if none (stops at line-end).

Looks for `X=` where `X` ∈ {T,P,R,K}. Needs two bytes at each candidate. -/
public unsafe def findTxn (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := loadAt addr i
     bifUSize (U32.beq (isLineEnd c) U32.one) n
       (bifUSize (USize.blt (USize.add i off1) n)
         (let k := kindOf c
          bifUSize (U32.beq k U32.zero)
            (findTxn addr (USize.add i USize.one) n)
            (bifUSize (U32.beq (loadAt addr (USize.add i off1)) cEq) i
              (findTxn addr (USize.add i USize.one) n)))
         n))
    n

/-- Decimal digits from `i` until non-digit / end / brace / line-end; value as `U32`. -/
public unsafe def parseDec (addr : USize) (i : USize) (n : USize) (acc : U32) : U32 :=
  bifU32 (USize.blt i n)
    (let c := loadAt addr i
     bifU32 (U32.beq (isDigit c) U32.one)
       (parseDec addr (USize.add i USize.one) n
         (U32.add (U32.mul acc tenU32) (U32.sub c cZero)))
       acc)
    acc

/-- `0` if `n ≥ 4`, else `1`.

When `n ≥ 4`, loads first byte and folds it with `U32.land _ U32.zero` so dual-param
`addr` stays on the EmitC result path. Status remains length-class only (probe never
contributes a nonzero bit). Does not require a txn token match. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) err
    (U32.land (loadAt addr USize.zero) U32.zero)

/-- Alias of `validate`. -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if a short-form `T=`/`P=`/`R=`/`K=` token is present on the first line, else `0`. -/
public unsafe def hasTxn (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (let i := findTxn addr USize.zero n
     bifU32 (USize.blt i n) U32.one U32.zero)

/-- Transaction kind code when a short-form token is present: 1=T 2=P 3=R 4=K, else 0. -/
public unsafe def txnKind (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (let i := findTxn addr USize.zero n
     bifU32 (USize.blt i n) (kindOf (loadAt addr i)) U32.zero)

/-- Decimal transaction id after `=` when present and digit-shaped, else `0`.

Starts at marker + 2 (`X=` width name-pinned as `tokLen`). -/
public unsafe def txnId (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (let i := findTxn addr USize.zero n
     bifU32 (USize.blt i n)
       (let j := USize.add i tokLen
        bifU32 (USize.blt j n)
          (bifU32 (U32.beq (isDigit (loadAt addr j)) U32.one)
            (parseDec addr j n U32.zero)
            U32.zero)
          U32.zero)
       U32.zero)

/-- Fragment / first-line byte length until CR/LF, or `n` if no line end (`0` if short).

Layout-only span — not a binary wire length field. -/
public unsafe def length (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt n minLen) U32.zero
    (let e := findLineEnd addr USize.zero n
     U32.ofUSize e)

/-- Offset of first short-form txn marker, or miss. **LP64**. -/
public unsafe def txnOff (addr : USize) (n : USize) : USize :=
  bifUSize (USize.blt n minLen) USize.neg1
    (let i := findTxn addr USize.zero n
     bifUSize (USize.blt i n) i USize.neg1)

end Systems.Megaco
