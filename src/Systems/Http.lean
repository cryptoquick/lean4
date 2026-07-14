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

/-!
# Systems.Http (Systems Lean)

HTTP-**shaped** parse of request/response **first line** + simple **header offsets**
over dual caller `addr`/`len` byte views — not a full HTTP/1.1 stack, not TLS, not
chunked bodies, not a connection state machine.

Recognized shapes (ASCII bytes; lines end with `\n` or `\r\n`):

* **request-line** — `METHOD SP target SP HTTP/x.y` (METHOD starts with alpha)
* **status-line** — `HTTP/x.y SP status SP reason` (status is three digits)
* **header** — `Name: value` (name non-empty; first `:` splits); blank line ends headers
* Body bytes after the blank line are **ignored** by this surface

Ops:

* **validate** / **parse** — structural first-line (+ optional headers); `0` ok, `1` invalid
* **isRequest** / **isResponse** — first-line kind
* **methodOff** / **methodLen** — request METHOD span (zeros if response/invalid)
* **targetOff** / **targetLen** — request-target span
* **versionOff** / **versionLen** — `HTTP/x.y` span on either kind
* **statusOff** / **statusLen** — three-digit status on response (zeros if request)
* **headerCount** — number of well-formed header lines before blank/end
* **findHeader** — byte offset of matching header name, or miss
* **headerValueOff** / **headerValueLen** — value span for a header name offset

Honesty:

* **Shaped offsets only** — no transfer-encoding, no chunked decoding, no pipeline,
  no absolute-form request targets special-cased beyond raw target bytes, no HTTP/2.
* Not claimed: full RFC 9110/9112, case-insensitive header fold product API beyond
  raw byte match, or cookie/multipart parsers.
* Empty input fails `validate`. Miss sentinel is `USize.neg1` (**LP64 harness**).

## Intentional TCB (Http-local)

Structural ASCII markers are freestanding `@[extern]` axioms kept **here**.
Name-pinned on ComplianceCorpus (`path name=Ident`). Classifiers reuse `Ascii`.
-/

namespace Systems.Http

open Systems.Scalars
open Systems.Bytes
open Systems.Status
open Systems.Ascii

/-- ASCII space (32). -/
@[extern c inline "((uint32_t)32)"] public axiom cSp : U32
/-- ASCII `':'` (58). -/
@[extern c inline "((uint32_t)58)"] public axiom cColon : U32
/-- ASCII `'/'` (47). -/
@[extern c inline "((uint32_t)47)"] public axiom cSlash : U32
/-- ASCII `'H'` (72). -/
@[extern c inline "((uint32_t)72)"] public axiom cH : U32
/-- ASCII `'T'` (84). -/
@[extern c inline "((uint32_t)84)"] public axiom cT : U32
/-- ASCII `'P'` (80). -/
@[extern c inline "((uint32_t)80)"] public axiom cP : U32
/-- ASCII LF (10). -/
@[extern c inline "((uint32_t)10)"] public axiom cLf : U32
/-- ASCII CR (13). -/
@[extern c inline "((uint32_t)13)"] public axiom cCr : U32
/-- Two as `USize`. -/
@[extern c inline "((size_t)2)"] public axiom twoUSize : USize
/-- Three as `USize` (status digits / `HTTP` third index). -/
@[extern c inline "((size_t)3)"] public axiom threeUSize : USize
/-- Four as `USize` (`HTTP` width). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Five as `USize` (`HTTP/` width). -/
@[extern c inline "((size_t)5)"] public axiom fiveUSize : USize

/-- Load byte at index as `U32`. Caller ensures bounds. -/
public unsafe def loadAt (addr : USize) (i : USize) : U32 :=
  U32.ofU8 (U8.load (USize.add addr i))

/-- `1` if `c` is LF or CR. -/
public unsafe def isLineEnd (c : U32) : U32 :=
  bifU32 (U32.beq c cLf) U32.one
    (bifU32 (U32.beq c cCr) U32.one U32.zero)

/-- Index of first line-end byte in `[i, n)`, or `n` if none. -/
public unsafe def findLineEnd (addr : USize) (i : USize) (n : USize) : USize :=
  bifUSize (USize.blt i n)
    (bifUSize (U32.beq (isLineEnd (loadAt addr i)) U32.one) i
      (findLineEnd addr (USize.add i USize.one) n))
    n

/-- Index just past the line ending at `le` (consumes optional CR LF pair). -/
public unsafe def afterLineEnd (addr : USize) (le : USize) (n : USize) : USize :=
  bifUSize (USize.beq le n) n
    (bifUSize (U32.beq (loadAt addr le) cCr)
      (let j := USize.add le USize.one
       bifUSize (USize.blt j n)
         (bifUSize (U32.beq (loadAt addr j) cLf) (USize.add j USize.one) j)
         j)
      (USize.add le USize.one))

/-- First space in `[lo, hi)`, or miss. -/
public unsafe def findSp (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (bifUSize (U32.beq (loadAt addr lo) cSp) lo
      (findSp addr (USize.add lo USize.one) hi))
    USize.neg1

/-- First `:` in `[lo, hi)`, or miss. -/
public unsafe def findColon (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (bifUSize (U32.beq (loadAt addr lo) cColon) lo
      (findColon addr (USize.add lo USize.one) hi))
    USize.neg1

/-- Skip spaces in `[i, hi)`. -/
public unsafe def skipSp (addr : USize) (i : USize) (hi : USize) : USize :=
  bifUSize (USize.blt i hi)
    (bifUSize (U32.beq (loadAt addr i) cSp)
      (skipSp addr (USize.add i USize.one) hi) i)
    i

/-- Trim trailing spaces/CR from exclusive end `hi` down to `lo`. -/
public unsafe def rtrimSp (addr : USize) (lo : USize) (hi : USize) : USize :=
  bifUSize (USize.blt lo hi)
    (let p := USize.sub hi USize.one
     let c := loadAt addr p
     bifUSize (U32.beq c cSp)
       (rtrimSp addr lo p)
       (bifUSize (U32.beq c cCr) (rtrimSp addr lo p) hi))
    hi

/-- `1` if spans `[a,a+n)` and `[b,b+n)` are equal. -/
public unsafe def spanEqGo (a : USize) (b : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (bifU32 (U8.beq (U8.load (USize.add a i)) (U8.load (USize.add b i)))
      (spanEqGo a b (USize.add i USize.one) n)
      U32.zero)
    U32.one

/-- `1` if equal length-`n` spans match. -/
public unsafe def spanEq (a : USize) (b : USize) (n : USize) : U32 :=
  spanEqGo a b USize.zero n

/-- `1` if bytes at `i` start `HTTP` (needs `i+3 < n`). -/
public unsafe def isHttpPrefix (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt (USize.add i threeUSize) n)
    (bifU32 (U32.beq (loadAt addr i) cH)
      (bifU32 (U32.beq (loadAt addr (USize.add i USize.one)) cT)
        (bifU32 (U32.beq (loadAt addr (USize.add i twoUSize)) cT)
          (bifU32 (U32.beq (loadAt addr (USize.add i threeUSize)) cP) U32.one U32.zero)
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if `[lo, hi)` is `HTTP/` + non-empty version token (no spaces). -/
public unsafe def isHttpVersion (addr : USize) (lo : USize) (hi : USize) : U32 :=
  bifU32 (USize.blt (USize.add lo fourUSize) hi)
    (bifU32 (U32.beq (isHttpPrefix addr lo hi) U32.one)
      (bifU32 (U32.beq (loadAt addr (USize.add lo fourUSize)) cSlash)
        (bifU32 (USize.blt (USize.add lo fiveUSize) hi)
          -- remaining bytes until hi must be non-space (already line body)
          U32.one
          U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- `1` if `[lo, lo+3)` are three digits and `lo+3 == hi`. -/
public unsafe def isStatusCode (addr : USize) (lo : USize) (hi : USize) : U32 :=
  bifU32 (USize.beq (USize.sub hi lo) threeUSize)
    (bifU32 (U32.beq (isDigit (loadAt addr lo)) U32.one)
      (bifU32 (U32.beq (isDigit (loadAt addr (USize.add lo USize.one))) U32.one)
        (bifU32 (U32.beq (isDigit (loadAt addr (USize.add lo twoUSize))) U32.one)
          U32.one U32.zero)
        U32.zero)
      U32.zero)
    U32.zero

/-- First line end exclusive index (content before CR/LF). -/
public unsafe def firstLineHi (addr : USize) (n : USize) : USize :=
  findLineEnd addr USize.zero n

/-- `1` if first line is a response status-line. -/
public unsafe def isResponse (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.blt USize.zero n)
    (let hi := firstLineHi addr n
     bifU32 (U32.beq (isHttpPrefix addr USize.zero n) U32.one)
       (let sp1 := findSp addr USize.zero hi
        bifU32 (USize.beq sp1 USize.neg1) U32.zero
          (bifU32 (U32.beq (isHttpVersion addr USize.zero sp1) U32.one)
            (let st := USize.add sp1 USize.one
             let sp2 := findSp addr st hi
             bifU32 (USize.beq sp2 USize.neg1) U32.zero
               (bifU32 (U32.beq (isStatusCode addr st sp2) U32.one) U32.one U32.zero))
            U32.zero))
       U32.zero)
    U32.zero

/-- `1` if first line is a request-line (METHOD starts alpha; third token is HTTP/…). -/
public unsafe def isRequest (addr : USize) (n : USize) : U32 :=
  bifU32 (U32.beq (isResponse addr n) U32.one) U32.zero
    (bifU32 (USize.blt USize.zero n)
      (let hi := firstLineHi addr n
       bifU32 (U32.beq (isAlpha (loadAt addr USize.zero)) U32.one)
         (let sp1 := findSp addr USize.zero hi
          bifU32 (USize.beq sp1 USize.neg1) U32.zero
            (bifU32 (USize.beq sp1 USize.zero) U32.zero
              (let tgt := USize.add sp1 USize.one
               let sp2 := findSp addr tgt hi
               bifU32 (USize.beq sp2 USize.neg1) U32.zero
                 (bifU32 (USize.beq sp2 tgt) U32.zero
                   (let ver := USize.add sp2 USize.one
                    bifU32 (U32.beq (isHttpVersion addr ver hi) U32.one) U32.one U32.zero)))))
         U32.zero)
      U32.zero)

/-- Method start offset (always `0` when request). -/
public unsafe def methodOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isRequest addr n) U32.one) USize.zero USize.zero

/-- Method length, or `0` if not request. -/
public unsafe def methodLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isRequest addr n) U32.one)
    (let hi := firstLineHi addr n
     let sp1 := findSp addr USize.zero hi
     bifUSize (USize.beq sp1 USize.neg1) USize.zero sp1)
    USize.zero

/-- Request-target offset, or `0` if not request. -/
public unsafe def targetOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isRequest addr n) U32.one)
    (let hi := firstLineHi addr n
     let sp1 := findSp addr USize.zero hi
     bifUSize (USize.beq sp1 USize.neg1) USize.zero (USize.add sp1 USize.one))
    USize.zero

/-- Request-target length, or `0` if not request. -/
public unsafe def targetLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isRequest addr n) U32.one)
    (let hi := firstLineHi addr n
     let sp1 := findSp addr USize.zero hi
     bifUSize (USize.beq sp1 USize.neg1) USize.zero
       (let tgt := USize.add sp1 USize.one
        let sp2 := findSp addr tgt hi
        bifUSize (USize.beq sp2 USize.neg1) USize.zero (USize.sub sp2 tgt)))
    USize.zero

/-- Version token offset on request or response, or `0` if neither. -/
public unsafe def versionOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isResponse addr n) U32.one) USize.zero
    (bifUSize (U32.beq (isRequest addr n) U32.one)
      (let hi := firstLineHi addr n
       let sp1 := findSp addr USize.zero hi
       bifUSize (USize.beq sp1 USize.neg1) USize.zero
         (let sp2 := findSp addr (USize.add sp1 USize.one) hi
          bifUSize (USize.beq sp2 USize.neg1) USize.zero (USize.add sp2 USize.one)))
      USize.zero)

/-- Version token length, or `0` if neither. -/
public unsafe def versionLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isResponse addr n) U32.one)
    (let hi := firstLineHi addr n
     let sp1 := findSp addr USize.zero hi
     bifUSize (USize.beq sp1 USize.neg1) USize.zero sp1)
    (bifUSize (U32.beq (isRequest addr n) U32.one)
      (let hi := firstLineHi addr n
       let vo := versionOff addr n
       bifUSize (USize.blt hi vo) USize.zero (USize.sub hi vo))
      USize.zero)

/-- Status code offset on response, or `0` if not response. -/
public unsafe def statusOff (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isResponse addr n) U32.one)
    (let hi := firstLineHi addr n
     let sp1 := findSp addr USize.zero hi
     bifUSize (USize.beq sp1 USize.neg1) USize.zero (USize.add sp1 USize.one))
    USize.zero

/-- Status code length (`3` on well-formed response), else `0`. -/
public unsafe def statusLen (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (isResponse addr n) U32.one) threeUSize USize.zero

/-- Header block starts after first line. -/
public unsafe def headersStart (addr : USize) (n : USize) : USize :=
  afterLineEnd addr (firstLineHi addr n) n

/-- Status of one header line `[line, le)`: `0` ok, `1` invalid, `2` blank (end headers).

Blank = empty after optional CR strip. -/
public unsafe def headerLineKind (addr : USize) (line : USize) (le : USize) : U32 :=
  let hi := rtrimSp addr line le
  bifU32 (USize.beq line hi) U32.two
    (let col := findColon addr line hi
     bifU32 (USize.beq col USize.neg1) err
       (bifU32 (USize.beq col line) err ok))

/-- Validate headers from `i` until blank line or end. -/
public unsafe def validateHeadersGo (addr : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let le := findLineEnd addr i n
     let k := headerLineKind addr i le
     bifU32 (U32.beq k U32.two) ok
       (bifU32 (U32.beq k ok)
         (validateHeadersGo addr (afterLineEnd addr le n) n)
         err))
    ok

/-- Structural validate: first line request or response + headers; `0` ok, `1` invalid. -/
public unsafe def validate (addr : USize) (n : USize) : U32 :=
  bifU32 (USize.beq n USize.zero) err
    (bifU32 (U32.beq (isRequest addr n) U32.one)
      (validateHeadersGo addr (headersStart addr n) n)
      (bifU32 (U32.beq (isResponse addr n) U32.one)
        (validateHeadersGo addr (headersStart addr n) n)
        err))

/-- Alias of `validate` (parse = structural first-line + headers). -/
public unsafe def parse (addr : USize) (n : USize) : U32 :=
  validate addr n

/-- Count header lines from `i` until blank/end. -/
public unsafe def headerCountGo (addr : USize) (i : USize) (n : USize) (acc : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let k := headerLineKind addr i le
     bifUSize (U32.beq k U32.two) acc
       (bifUSize (U32.beq k ok)
         (headerCountGo addr (afterLineEnd addr le n) n (USize.add acc USize.one))
         acc))
    acc

/-- Number of well-formed headers before blank line (0 if first line invalid). -/
public unsafe def headerCount (addr : USize) (n : USize) : USize :=
  bifUSize (U32.beq (validate addr n) ok)
    (headerCountGo addr (headersStart addr n) n USize.zero)
    USize.zero

/-- Find header named `[nameAddr, nameLen)`: offset of name start, or miss. -/
public unsafe def findHeaderGo (addr : USize) (i : USize) (n : USize)
    (nameAddr : USize) (nameLen : USize) : USize :=
  bifUSize (USize.blt i n)
    (let le := findLineEnd addr i n
     let k := headerLineKind addr i le
     bifUSize (U32.beq k U32.two) USize.neg1
       (bifUSize (U32.beq k ok)
         (let col := findColon addr i le
          let hn := USize.sub col i
          bifUSize (USize.beq hn nameLen)
            (bifUSize (U32.beq (spanEq (USize.add addr i) nameAddr nameLen) U32.one)
              i
              (findHeaderGo addr (afterLineEnd addr le n) n nameAddr nameLen))
            (findHeaderGo addr (afterLineEnd addr le n) n nameAddr nameLen))
         USize.neg1))
    USize.neg1

/-- Offset of matching header name, or miss. **LP64 miss.** Case-sensitive raw match. -/
public unsafe def findHeader (addr : USize) (n : USize)
    (nameAddr : USize) (nameLen : USize) : USize :=
  bifUSize (USize.beq nameLen USize.zero) USize.neg1
    (bifUSize (U32.beq (validate addr n) ok)
      (findHeaderGo addr (headersStart addr n) n nameAddr nameLen)
      USize.neg1)

/-- Header value offset for a name start from `findHeader`, or miss. -/
public unsafe def headerValueOff (addr : USize) (n : USize) (nameOff : USize) : USize :=
  bifUSize (USize.blt nameOff n)
    (let le := findLineEnd addr nameOff n
     let col := findColon addr nameOff le
     bifUSize (USize.beq col USize.neg1) USize.neg1
       (skipSp addr (USize.add col USize.one) le))
    USize.neg1

/-- Header value length for a name start from `findHeader`. -/
public unsafe def headerValueLen (addr : USize) (n : USize) (nameOff : USize) : USize :=
  bifUSize (USize.blt nameOff n)
    (let le := findLineEnd addr nameOff n
     let col := findColon addr nameOff le
     bifUSize (USize.beq col USize.neg1) USize.zero
       (let vo := skipSp addr (USize.add col USize.one) le
        let ve := rtrimSp addr vo le
        bifUSize (USize.blt ve vo) USize.zero (USize.sub ve vo)))
    USize.zero

end Systems.Http
