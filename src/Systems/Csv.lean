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

/-!
# Systems.Csv (Systems Lean)

CSV-**shaped** row / field scan over dual caller `addr`/`len` byte views — not full
RFC 4180, not a dataframe, not malloc-backed records.

Field rules (byte-oriented):

* **unquoted** — runs until `,` / LF / CR / end
* **quoted** — `"…"` with `""` as an escaped quote; closes at unpaired `"`
* **row end** — LF, CR, or CR LF (after optional CR before LF)
* **field sep** — `,`

Ops:

* **scanRow** — end index of the first row (past line ending), or `n` if no line end
* **fieldCount** — fields in the first row
* **fieldOff** / **fieldLen** — span of field `i` in the first row (content without
  surrounding quotes when quoted; embedded `""` left as two quote bytes — no unescape copy)
* **rowCount** — number of rows (trailing data without final newline counts as a row)
* **validate** — balanced quotes and well-formed separators; `0` ok, `1` invalid

Honesty:

* **Shaped scan only** — no RFC 4180 header dialect, no multi-char delimiters, no UTF-8
  awareness, no type inference, no write API.
* Not claimed: full RFC 4180 (e.g. no newline-inside-quoted-field product API beyond
  scanning — a quoted field may contain LF; `scanRow` / `fieldCount` treat the first
  row only and stop at unquoted line ends).
* Miss sentinel for offsets is `USize.neg1` (**LP64 harness**).

## Intentional TCB (Csv-local)

Structural ASCII markers are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`).
-/

namespace Systems.Csv

open Systems.Scalars
open Systems.Bytes
open Systems.Status

/-- ASCII `','` (44). -/
@[extern c inline "((uint32_t)44)"] public axiom cComma : U32
/-- ASCII `'"'` (34). -/
@[extern c inline "((uint32_t)34)"] public axiom cQuote : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- Two as `USize` (quoted-field open+close width). -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize

/-- Load byte at index as `U32`. Caller ensures bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n) (U32.ofU8 (U8.load (USize.add addr i))) U32.zero

/-- Advance past CR LF or single LF/CR at `i`. Returns next index. -/
public unsafe def afterEol (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr i))) cCr)
      (let j := USize.add i USize.one
       bifUSize (USize.blt j n)
         (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr j))) cLf)
           (USize.add j USize.one) j)
         j)
      (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr i))) cLf)
        (USize.add i USize.one) i))
    i

/-- End index of an unquoted field starting at `i` (index of `,`/EOL/end). -/
public unsafe def unquotedEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifUSize (U32.beq c cComma) i
       (bifUSize (U32.beq c cLf) i
         (bifUSize (U32.beq c cCr) i
           (unquotedEnd addr (USize.add i USize.one) n))))
    n

/-- Scan quoted field body from `i` (first char after opening `"`).

Returns end index past the closing quote, or `USize.neg1` if unclosed. -/
public unsafe def quotedEndGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr i))) cQuote)
      (let j := USize.add i USize.one
       bifUSize (USize.blt j n)
         (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr j))) cQuote)
           (quotedEndGo addr (USize.add j USize.one) n)
           j)
         j)
      (quotedEndGo addr (USize.add i USize.one) n))
    USize.neg1

/-- Field end + next-scan index for field starting at `i`.

Returns next index after the field and separator handling is done by callers.
On quote error returns miss for the end. Pair with `fieldScan`. -/
public unsafe def fieldEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr i))) cQuote)
      (quotedEndGo addr (USize.add i USize.one) n)
      (unquotedEnd addr i n))
    i

/-- Content start of field at `i` (skips opening quote when quoted). -/
public unsafe def fieldContentOff (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr i))) cQuote)
      (USize.add i USize.one) i)
    i

/-- Content length for field at `i` given `fEnd` from `fieldEnd`.

Quoted: bytes strictly between the opening quote at `i` and the closing quote at
`fEnd - 1` (length `fEnd - i - 2`). Unquoted: `fEnd - i`. -/
public unsafe def fieldContentLen (addr : USize) (i : USize) (n : USize) (fEnd : USize) : USize :=
  bifUSize (USize.beq fEnd USize.neg1) USize.zero
    (bifUSize (USize.blt i n)
      (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr i))) cQuote)
        -- need fEnd ≥ i + 2 for empty `""` content or more
        (bifUSize (USize.blt fEnd (USize.add i twoUSize)) USize.zero
          (USize.sub (USize.sub fEnd i) twoUSize))
        (bifUSize (USize.blt fEnd i) USize.zero (USize.sub fEnd i)))
      USize.zero)

/-- Index after field ending at `fEnd`: skip optional comma; do not skip EOL. -/
public unsafe def afterField (addr : USize) (fEnd : USize) (n : USize) : USize :=
  bifUSize (USize.beq fEnd USize.neg1) USize.neg1
    (bifUSize (USize.blt fEnd n)
      (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr fEnd))) cComma)
        (USize.add fEnd USize.one)
        fEnd)
      fEnd)

/-- `1` if index `i` is at unquoted row end or past `n`. -/
public unsafe def atRowEnd (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let c := U32.ofU8 (U8.load (USize.add addr i))
     bifU32 (U32.beq c cLf) U32.one
       (bifU32 (U32.beq c cCr) U32.one U32.zero))
    U32.one

/-- Count fields in first row starting at `i` (accum `acc`). Miss → `USize.neg1`.

A trailing comma introduces one more empty field (`,` → 2 fields). -/
public unsafe def fieldCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (U32.beq (atRowEnd addr i n) U32.one)
    (bifUSize (USize.beq acc USize.zero)
      (bifUSize (USize.beq i n) USize.zero
        -- Row is only EOL (e.g. lone `\n`): zero fields.
        USize.zero)
      acc)
    (let fEnd := fieldEnd addr i n
     bifUSize (USize.beq fEnd USize.neg1) USize.neg1
       (let next := afterField addr fEnd n
        bifUSize (USize.beq next USize.neg1) USize.neg1
          (bifUSize (USize.beq next fEnd)
            -- no comma: end of row after this field
            (USize.add acc USize.one)
            -- comma: continue; if next is already row-end, count the empty field after it
            (bifUSize (U32.beq (atRowEnd addr next n) U32.one)
              (USize.add (USize.add acc USize.one) USize.one)
              (fieldCountGo addr next n (USize.add acc USize.one))))))

/-- Number of fields in the first row, or `USize.neg1` on quote error. **LP64 miss.**

Empty input → `0`. A single empty field on an empty line is not distinguished from
empty input (both yield `0`). A lone comma yields two empty fields. -/
public unsafe def fieldCount (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.zero
    (fieldCountGo addr USize.zero n USize.zero)

/-- Locate field `want` (0-based) in first row: set `*off`/`*len` via returns.

Returns content offset of field `want`, or miss. -/
public unsafe def fieldOffGo (addr : USize) (i : USize) (n : USize)
    (idx : USize) (want : USize) : USize :=
  bifUSize (U32.beq (atRowEnd addr i n) U32.one) USize.neg1
    (let fEnd := fieldEnd addr i n
     bifUSize (USize.beq fEnd USize.neg1) USize.neg1
       (bifUSize (USize.beq idx want) (fieldContentOff addr i n)
         (let next := afterField addr fEnd n
          bifUSize (USize.beq next USize.neg1) USize.neg1
            (bifUSize (USize.beq next fEnd) USize.neg1
              (fieldOffGo addr next n (USize.add idx USize.one) want)))))

/-- Content offset of field `want` in first row, or miss. **LP64 miss.** -/
public unsafe def fieldOff (addr : USize) (n : USize) (want : USize) : USize :=
  fieldOffGo addr USize.zero n USize.zero want

/-- Content length of field `want` in first row, or `0` on miss/error. -/
public unsafe def fieldLenGo (addr : USize) (i : USize) (n : USize)
    (idx : USize) (want : USize) : USize :=
  bifUSize (U32.beq (atRowEnd addr i n) U32.one) USize.zero
    (let fEnd := fieldEnd addr i n
     bifUSize (USize.beq fEnd USize.neg1) USize.zero
       (bifUSize (USize.beq idx want) (fieldContentLen addr i n fEnd)
         (let next := afterField addr fEnd n
          bifUSize (USize.beq next USize.neg1) USize.zero
            (bifUSize (USize.beq next fEnd) USize.zero
              (fieldLenGo addr next n (USize.add idx USize.one) want)))))

/-- Content length of field `want` in the first row. -/
public unsafe def fieldLen (addr : USize) (n : USize) (want : USize) : USize :=
  fieldLenGo addr USize.zero n USize.zero want

/-- End index past first row (after EOL), or `n` if the buffer is one row without EOL. -/
public unsafe def scanRowGo (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (U32.ofU8 (U8.load (USize.add addr i))) cQuote)
      (let qe := quotedEndGo addr (USize.add i USize.one) n
       bifUSize (USize.beq qe USize.neg1) USize.neg1
         (scanRowGo addr qe n))
      (let c := U32.ofU8 (U8.load (USize.add addr i))
       bifUSize (U32.beq c cLf) (afterEol addr i n)
         (bifUSize (U32.beq c cCr) (afterEol addr i n)
           (scanRowGo addr (USize.add i USize.one) n))))
    n

/-- Scan first row: end index after line ending, `n` if no EOL, miss on bad quotes. -/
public unsafe def scanRow (addr : USize) (n : USize) : USize :=
  scanRowGo addr USize.zero n

/-- Count rows from `i` with accumulator. -/
public unsafe def rowCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let stop := scanRowGo addr i n
     bifUSize (USize.beq stop USize.neg1) USize.neg1
       (bifUSize (USize.beq stop i) USize.neg1
         (rowCountGo addr stop n (USize.add acc USize.one))))
    acc

/-- Number of rows, or miss on quote error. Empty → `0`. **LP64 miss.** -/
public unsafe def rowCount (addr : USize) (n : USize) : USize :=
  bifUSize (USize.beq n USize.zero) USize.zero
    (rowCountGo addr USize.zero n USize.zero)

/-- Validate quotes/separators from `i`. -/
public unsafe def validateGo (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U32.beq (U32.ofU8 (U8.load (USize.add addr i))) cQuote)
      (let qe := quotedEndGo addr (USize.add i USize.one) n
       bifU32 (USize.beq qe USize.neg1) err (validateGo addr qe n))
      (validateGo addr (USize.add i USize.one) n))
    ok

/-- Structural validate (balanced quotes): `0` ok, `1` invalid. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  validateGo addr USize.zero n

end Systems.Csv
