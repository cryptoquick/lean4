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
public import Systems.Ascii
public import Systems.Numerics

/-!
# Systems.Dns (Systems Lean)

DNS-**shaped** label / QNAME scan over dual caller `addr`/`len` byte views — not a full
DNS resolver, not EDNS, not recursive queries, not wire compression pointers.

Recognized shape (ASCII dotted QNAME, optional trailing `.` for absolute):

* **label** — one or more LDH bytes: `isAlnum` or `-` (hyphen not first/last of label)
* **separator** — `.` between labels
* **absolute** — trailing `.` after the last label (or sole `.` = root)

Ops:

* **validate** / **scan** — structural label scan; `0` ok, `1` invalid
* **labelCount** — number of non-empty labels
* **labelOff** / **labelLen** — span of label at index (`0..labelCount-1`), or miss
* **isAbsolute** — `1` if input ends with `.` (and validates)

Honesty:

* **Dotted ASCII only** — no wire length-prefixed labels, no compression (`0xC0`), no
  CLASS/TYPE RR product API, no UDP transport, no IDNA / Unicode hostnames.
* Empty labels in the middle (`a..b`) and leading `.` (non-root) are invalid.
* Labels longer than 63 bytes are rejected (DNS-shaped bound, not a full name budget).
* Miss sentinel is `USize.neg1` (**LP64 harness**).
* **loadAt dual-param honesty:** ops take caller `(addr, n)`; every `loadAt` index is
  produced only after an `i < n` guard (or an index derived from a prior in-range scan).
  `loadAt` itself is **not** bounds-parameterized (unlike Xml/Csv
  `loadAt addr i n`) — caller `n` is the sole length bound for all loads.

## Intentional TCB (Dns-local)

Structural ASCII markers and the 63-byte label bound are freestanding `@[extern]` axioms
kept **here**. Name-pinned on ComplianceCorpus (`path name=Ident`). Classifiers reuse
`Ascii`.
-/

namespace Systems.Dns

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii
open Systems.Numerics

/-- ASCII `'.'` (46). -/
@[extern c inline "((uint32_t)46)"] public axiom cDot : U32
/-- ASCII `'-'` (45). -/
@[extern c inline "((uint32_t)45)"] public axiom cHyphen : U32
/-- Max DNS label length (63). -/
@[extern c inline "((size_t)63)"] public axiom maxLabelLen : USize

/-- Load byte at index as `U32`.

Caller ensures `i < n` for the dual-param range that owns `addr` — this helper does not
take `n` (dual-param honesty: bounds live at the scan entrypoints). -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is allowed inside a label body (`alnum` or `-`). -/
public unsafe def isLabelByte (c : U32) : U32 :=
  bifU32 (U32.beq (isAlnum c) U32.one) U32.one
    (bifU32 (U32.beq c cHyphen) U32.one U32.zero)

/-- Accept label `[start, end)` if length in `1..63` and last byte not hyphen. -/
public unsafe def finishLabel (addr : USize) (start : USize) (end_ : USize) : USize :=
  let len := USize.sub end_ start
  bifUSize (USize.beq len USize.zero) USize.neg1
    (bifUSize (USize.blt maxLabelLen len) USize.neg1
      (bifUSize (U32.beq (loadAt addr (USize.sub end_ USize.one)) cHyphen) USize.neg1 end_))

/-- Continue label after first alnum at `start`. Ends at first non-label or `n`. -/
public unsafe def scanLabelGo (addr : USize) (j : USize) (n : USize) (start : USize) : USize :=
  bifUSize (USize.blt j n)
    (let c := loadAt addr j
     bifUSize (U32.beq (isLabelByte c) U32.one)
       (scanLabelGo addr (USize.add j USize.one) n start)
       (finishLabel addr start j))
    (finishLabel addr start j)

/-- Scan one label starting at `i`. Returns index just past label, or miss.

Requires non-empty label; first and last bytes must not be hyphen; length ≤ 63. -/
public unsafe def scanLabel (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c0 := loadAt addr i
     bifUSize (U32.beq (isAlnum c0) U32.one)
       (scanLabelGo addr (USize.add i USize.one) n i)
       USize.neg1)
    USize.neg1

/-- Validate from index `i` with `needLabel` (`1` = must start a label, `0` = after a label).

After a label: `.` continues (optional absolute), or end. After `.` that is not absolute
end: require another label. Sole `.` (root) accepted when `i==0` and next is end. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) (needLabel : U32) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U32.beq needLabel U32.one)
      -- must start label, or sole root "."
      (bifU32 (U32.beq (loadAt addr i) cDot)
        (bifU32 (USize.beq (USize.add i USize.one) n)
          (bifU32 (USize.beq i USize.zero) ok err)
          err)
        (let j := scanLabel addr i n
         bifU32 (USize.beq j USize.neg1) err
           (validateGo addr j n U32.zero)))
      -- after label: end ok, or '.' then maybe more
      (bifU32 (U32.beq (loadAt addr i) cDot)
        (let next := USize.add i USize.one
         bifU32 (USize.beq next n) ok
           (validateGo addr next n U32.one))
        err))
    -- end of input: ok only if we already had a label (relative name)
    (bifU32 (U32.beq needLabel U32.one) err ok)

/-- Structural validate: `0` ok, `1` invalid. Empty input is invalid. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (validateGo addr USize.zero n U32.one)

/-- Alias of `validate`. -/
public unsafe def scan (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- `1` if validates and last byte is `.`, else `0`. -/
public unsafe def isAbsolute (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (validate addr n) ok)
    (bifU32 (USize.blt USize.zero n)
      (bifU32 (U32.beq (loadAt addr (USize.sub n USize.one)) cDot) U32.one U32.zero)
      U32.zero)
    U32.zero

/-- Count non-empty labels from `i`. Assumes input validates. -/
public unsafe def labelCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i) cDot)
      -- skip absolute trailing / root-only dots without counting
      (labelCountGo addr (USize.add i USize.one) n acc)
      (let j := scanLabel addr i n
       bifUSize (USize.beq j USize.neg1) acc
         (labelCountGo addr j n (USize.add acc USize.one))))
    acc

/-- Number of non-empty labels, or `0` if invalid. -/
public unsafe def labelCount (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (labelCountGo addr USize.zero n USize.zero)
    USize.zero

/-- Find start of label index `want` (0-based). Returns off or miss. -/
public unsafe def labelOffGo (addr : USize) (i : USize) (n : USize)
    (want : USize) (cur : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (loadAt addr i) cDot)
      (labelOffGo addr (USize.add i USize.one) n want cur)
      (bifUSize (USize.beq cur want) i
        (let j := scanLabel addr i n
         bifUSize (USize.beq j USize.neg1) USize.neg1
           (labelOffGo addr j n want (USize.add cur USize.one)))))
    USize.neg1

/-- Byte offset of label `idx`, or miss. **LP64 miss.** -/
public unsafe def labelOff (addr : USize) (n : USize) (idx : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (labelOffGo addr USize.zero n idx USize.zero)
    USize.neg1

/-- Length of label at `idx`, or `0` on miss/invalid. -/
public unsafe def labelLen (addr : USize) (n : USize) (idx : USize) : USize :=
  let off := labelOff addr n idx
  bifUSize (USize.beq off USize.neg1) USize.zero
    (let j := scanLabel addr off n
     bifUSize (USize.beq j USize.neg1) USize.zero (USize.sub j off))

end Systems.Dns
