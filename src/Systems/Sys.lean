/-
Copyright (c) 2026 Lean FRO, LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars

/-!
# Systems.Sys (Systems Lean)

Thin POSIX-first `Sys` surface for **Systems Lean** extracts.
Canonical docs: `doc/dev/systems-lean.md`. Part of the in-tree optional `Systems` Lake lib.
Not Lean `IO` / `lean_io_*`.

* `Sys α` is an identity effect marker (no world token / no `lean_object*`).
* `Fd` is an `@[affine]` single-field handle over a raw POSIX `int` (C ABI `size_t`).
* `Arena` / `BytePtr` / `MallocBuf` are `@[affine]` single-field handles (K19 — no multi-field products).
* **`BytePtr`** = arena-derived view only (no `free`); **`MallocBuf`** = libc `malloc` owner (`bufFree`).
* **`Log`** = affine single-file append-only log handle (owns a POSIX fd).
* **`MMap`** = affine file mapping address (size is a separate `USize` param). `munmap` consumes it.
* Runtime sizes are **`USize`** only (K8 — no freestanding runtime `Nat`).
* Errors: raw C return codes as freestanding scalars. No Lean exception objects.
* Paths: C string pointer as `USize` (pointer bitcast), not heap `String`.
* Primops expand to libc `open`/`close`/`read`/`write`/`malloc`/`free`/`memset`/`fsync`/`lseek`/
  `mmap`/`munmap`/`msync`/`ftruncate` with explicit casts (named allowlist only).
* All effectful primops are `@[never_extract]` so pure LCNF DCE/CSE cannot erase sequenced
  syscalls / free after the affine checker.
-/

namespace Systems.Sys

open Systems.Scalars

/-- Effect marker; identity at runtime (no BaseIO world / no `lean_object*`). -/
@[expose] public def Sys (α : Type) : Type := α

/-- Affine file descriptor (POSIX `int` as freestanding scalar handle; C ABI `size_t`). -/
@[affine]
public structure Fd where
  raw : USize

/-- Consume affine `Fd` into a raw size_t for FFI. Explicit — projection `fd.raw` is rejected by
the freestanding affine checker. Prefer `sysClose` for normal paths. -/
@[never_extract, extern c inline "(#1)"]
public axiom intoUSize (fd : Fd) : USize

/-- `open(path, flags, mode)` — path is a null-terminated C string pointer. -/
@[never_extract, extern c inline "((size_t)open((const char*)(#1), (int)(#2), (int)(#3)))"]
public axiom sysOpen (path : USize) (flags : U32) (mode : U32) : Sys Fd

/-- `close(fd)` — **consumes** affine `Fd`. Returns `0` on success, non-zero on failure. -/
@[never_extract, extern c inline "((uint32_t)close((int)(#1)))"]
public axiom sysClose (fd : Fd) : Sys U32

/-- `read(fd, buf, len)` — freestanding **borrow** of `Fd` (not RC `@&`, K15). -/
@[fs_borrow, never_extract, extern c inline "((size_t)read((int)(#1), (void*)(#2), (size_t)(#3)))"]
public axiom sysRead (fd : Fd) (buf : USize) (len : USize) : Sys USize

/-- `write(fd, buf, len)` — freestanding **borrow** of `Fd` (not RC `@&`, K15). -/
@[fs_borrow, never_extract, extern c inline "((size_t)write((int)(#1), (const void*)(#2), (size_t)(#3)))"]
public axiom sysWrite (fd : Fd) (buf : USize) (len : USize) : Sys USize

/-- O_RDONLY (POSIX). Prefer portable fcntl macros in inline patterns when possible. -/
@[extern c inline "0"] public axiom oRdonly : U32
/-- O_WRONLY. -/
@[extern c inline "1"] public axiom oWronly : U32
/-- O_RDWR. -/
@[extern c inline "2"] public axiom oRdwr : U32
/-- O_CREAT (Linux value; portable code should use fcntl macros in inline patterns). -/
@[extern c inline "64"] public axiom oCreat : U32
/-- O_TRUNC (Linux value). -/
@[extern c inline "512"] public axiom oTrunc : U32
/-- Flag or. -/
@[extern c inline "((#1) | (#2))"] public axiom orFlags : U32 → U32 → U32
/-- Mode 0644. -/
@[extern c inline "420"] public axiom mode644 : U32

/-- Portable `O_WRONLY|O_CREAT|O_TRUNC` for write-all open. -/
@[extern c inline "(O_WRONLY|O_CREAT|O_TRUNC)"]
public axiom oWronlyCreatTrunc : U32

/-- True when a POSIX fd handle is negative (`(ssize_t)fd < 0`). -/
@[fs_borrow, extern c inline "(uint8_t)((ssize_t)(#1) < 0)"]
public axiom fdIsNegU8 (fd : Fd) : U8

/-- True when a `size_t` bit-pattern is a negative `ssize_t` (e.g. write error). -/
@[extern c inline "(uint8_t)((ssize_t)(#1) < 0)"]
public axiom usizeIsNegU8 (n : USize) : U8

@[fs_borrow, inline] public def fdIsNeg (fd : Fd) : Bool :=
  Bool.ofU8 (fdIsNegU8 fd)

@[inline] public def usizeIsNeg (n : USize) : Bool :=
  Bool.ofU8 (usizeIsNegU8 n)

/-- Self-TCO write-remaining loop: write `left` bytes from `buf + done`.

Returns `0` when all bytes written (including `left == 0` no-op); `1` on error, short zero
progress, or impossible `n > left`. Matches `logWriteExact` exactness while retrying partial
writes (`0 < n < left`). EmitC TCO → `goto _start` (O(1) stack). -/
@[fs_borrow]
private unsafe def writeAllGo (fd : Fd) (buf : USize) (done : USize) (left : USize) : U32 :=
  bifU32 (USize.beq left USize.zero) U32.zero
    (let n := sysWrite fd (USize.add buf done) left;
     bifU32 (usizeIsNeg n) U32.one
       (bifU32 (USize.beq n USize.zero) U32.one
         (bifU32 (USize.bgt n left) U32.one
           (writeAllGo fd buf (USize.add done n) (USize.sub left n)))))

/-- open(O_WRONLY|O_CREAT|O_TRUNC, 0644) + **write all** bytes + close.

Lean freestanding control-flow over `sysOpen` / self-TCO `writeAllGo` / `sysClose` (not
one GNU statement-expr blob). Affine: always consumes the open result via `sysClose` (including
open failure, where `close` of a negative fd is harmless).

Status: `0` ok (all `len` bytes written, or `len == 0`); `1` open fail; `2` write fail / short
stuck progress (close ok); `3` close fail (overrides write status). Partial writes are retried
until complete or error — same exactness spirit as `logWriteExact`. -/
@[never_extract]
public unsafe def writeAllImpl (path : USize) (buf : USize) (len : USize) : Sys U32 :=
  let fd := sysOpen path oWronlyCreatTrunc mode644
  bifU32 (fdIsNeg fd)
    (let _c := sysClose fd; U32.one)
    (let we := writeAllGo fd buf USize.zero len;
     let ce := sysClose fd;
     bifU32 (U32.beq we U32.zero)
       (bifU32 (U32.beq ce U32.zero) U32.zero U32.three)
       (bifU32 (U32.beq ce U32.zero) U32.two U32.three))

/-! ## Arena + BytePtr + MallocBuf

Bump arena as a single `malloc`'d block. Header layout (all `size_t` words):

* `[0]` capacity of payload
* `[1]` bytes used
* `[2]` last allocation address (as `size_t`, 0 if none)

Payload starts at `3 * sizeof(size_t)`. Sequential API only — no `Arena × BytePtr` products.
`Arena.free` bulk-frees and the affine/region checker invalidates derived `BytePtr`s.

**Ownership split:** `BytePtr` is only an arena-derived view (no libc `free`). Standalone heap
buffers use `MallocBuf` + `bufFree` so `free(lastPtr)` cannot type-check.

`Arena.create` / `Arena.alloc` are Lean freestanding control-flow (`bifArena` +
overflow checks) over tiny header/malloc primops (ISO C comma / casts — not giant `({…})`
algorithms).
-/

/-- Affine arena handle (single field → C `size_t`). -/
@[affine]
public structure Arena where
  raw : USize

/-- Affine arena-derived pointer view (single field). Length is a separate `USize` parameter (K19).
Not a malloc owner — do not `free`. Use `MallocBuf` for standalone heap buffers. -/
@[affine]
public structure BytePtr where
  addr : USize

/-- Affine owner of a libc `malloc` block (explicit `bufFree` only). Distinct from `BytePtr`. -/
@[affine]
public structure MallocBuf where
  raw : USize

/-- Branch on freestanding `Bool` for `Arena` results. -/
@[macro_inline, expose] public def bifArena (c : Bool) (t e : Arena) : Arena :=
  Bool.casesOn (motive := fun _ => Arena) c e t

/-- Arena header size: three `size_t` words. -/
@[extern c inline "(3 * sizeof(size_t))"]
public axiom arenaHdrSize : USize

/-- Null arena handle (`(size_t)0`). -/
@[extern c inline "((size_t)0)"]
public axiom arenaNull : Arena

/-- Non-null test for an arena handle (borrow). -/
@[fs_borrow, extern c inline "(uint8_t)((size_t)(#1) != 0)"]
public axiom arenaIsNonNullU8 (a : Arena) : U8

@[fs_borrow, inline] public def arenaIsNonNull (a : Arena) : Bool :=
  Bool.ofU8 (arenaIsNonNullU8 a)

/-- `malloc(n)` as an arena-shaped handle (0 on OOM). -/
@[never_extract, extern c inline "((size_t)malloc((size_t)(#1)))"]
public axiom arenaMalloc (n : USize) : Sys Arena

/-- Initialize header after malloc: `[0]=cap`, `[1]=0`, `[2]=0`. Returns same handle.
ISO C comma operator (no GNU statement expr). -/
@[never_extract, extern c inline "(((size_t*)(#1))[0] = (size_t)(#2), ((size_t*)(#1))[1] = 0, ((size_t*)(#1))[2] = 0, (size_t)(#1))"]
public axiom arenaInitHdr (a : Arena) (cap : USize) : Sys Arena

/-- Load capacity word `[0]` (borrow; caller must ensure non-null). -/
@[fs_borrow, never_extract, extern c inline "(((size_t*)(#1))[0])"]
public axiom arenaLoadCap (a : Arena) : USize

/-- Load used word `[1]` (borrow; caller must ensure non-null). -/
@[fs_borrow, never_extract, extern c inline "(((size_t*)(#1))[1])"]
public axiom arenaLoadUsed (a : Arena) : USize

/-- Payload byte address at offset `used` from header (borrow). -/
@[fs_borrow, never_extract, extern c inline "((size_t)(((uint8_t*)(#1)) + 3 * sizeof(size_t) + (size_t)(#2)))"]
public axiom arenaPayloadAt (a : Arena) (used : USize) : USize

/-- Store used word `[1]`; returns same live handle (region transfer). -/
@[never_extract, extern c inline "(((size_t*)(#1))[1] = (size_t)(#2), (size_t)(#1))"]
public axiom arenaStoreUsed (a : Arena) (used : USize) : Sys Arena

/-- Store last-ptr word `[2]`; returns same live handle (region transfer). -/
@[never_extract, extern c inline "(((size_t*)(#1))[2] = (size_t)(#2), (size_t)(#1))"]
public axiom arenaStoreLast (a : Arena) (p : USize) : Sys Arena

/-- Create a bump arena with payload capacity `cap` (`USize`, not `Nat`).
Returns 0 on OOM or when `cap` would overflow `header + cap` size arithmetic.

Lean control-flow — overflow check **before** `malloc` size add; init only on non-null. -/
@[never_extract]
public def Arena.create (cap : USize) : Sys Arena :=
  bifArena (USize.uaddWouldOverflow cap arenaHdrSize) arenaNull
    (let h := arenaMalloc (USize.add arenaHdrSize cap);
     bifArena (arenaIsNonNull h) (arenaInitHdr h cap) h)

/-- Bump-allocate `nbytes` from the arena. **Consumes** `Arena`, returns the **same** live handle
(region transferred). On capacity overflow / null arena, returns the **unchanged** input handle
(no leak under move-only ownership; `lastPtr` unchanged). Callers detect failure by comparing
`lastPtr` before/after or by ensuring `nbytes` fits remaining capacity.

Lean control-flow — null/used/cap checks before stores; fail path returns same handle. -/
@[never_extract]
public def Arena.alloc (a : Arena) (nbytes : USize) : Sys Arena :=
  bifArena (arenaIsNonNull a)
    (let u := arenaLoadUsed a;
     let c := arenaLoadCap a;
     bifArena (USize.blt c u) a
       (bifArena (USize.bgt nbytes (USize.sub c u)) a
         (let p := arenaPayloadAt a u;
          let a := arenaStoreUsed a (USize.add u nbytes);
          arenaStoreLast a p)))
    a

/-- Pointer of the most recent successful `alloc` (borrow arena; produces affine `BytePtr`
stamped with the arena's region). Null arena → 0 without dereference. Before any alloc, 0.
ISO C ternary (no GNU statement expr). -/
@[fs_borrow, never_extract, extern c inline "((size_t)(#1) ? ((size_t*)(#1))[2] : (size_t)0)"]
public axiom Arena.lastPtr (a : Arena) : BytePtr

/-- Bulk-free the arena. **Consumes** `Arena`; checker kills the region (UAF on derived buffers).
Returns `0`. `free(NULL)` is a no-op. ISO C comma (no GNU statement expr). -/
@[never_extract, extern c inline "(free((void*)(#1)), (uint32_t)0)"]
public axiom Arena.free (a : Arena) : Sys U32

/-- **Unchecked** cast: borrow `BytePtr` as raw `USize` for dual-param APIs (`checksum`, libc, …).

Erases region tracking: holding the `USize` across `Arena.free` is **not** rejected by the
affine/region checker (K11 dual-param ABI). Prefer keeping `BytePtr` live until the last use,
then free the arena. Not a safe escape hatch for free-safety proofs. -/
@[fs_borrow, never_extract, extern c inline "((size_t)(#1))"]
public axiom BytePtr.asUSizeUnchecked (p : BytePtr) : USize

/-- Consume affine `BytePtr` into raw `USize` (ownership end for the derived view).

Does **not** free the arena. Use after the last `@[fs_borrow]` use when QTT elab requires an
exact-once consume (region kill on `Arena.free` is LCNF AffineCheck; QTT elab does not
auto-drop derived views). Same raw cast as `asUSizeUnchecked`. -/
@[never_extract, extern c inline "((size_t)(#1))"]
public axiom BytePtr.intoUSize (p : BytePtr) : USize

/-- Fill `n` bytes at `p` with byte value `v` (borrow pointer; libc `memset`).
Caller must ensure `p` is non-null and `n` is in range. ISO C comma. -/
@[fs_borrow, never_extract, extern c inline "(memset((void*)(#1), (int)(uint8_t)(#3), (size_t)(#2)), (uint32_t)0)"]
public axiom BytePtr.fill (p : BytePtr) (n : USize) (v : U8) : Sys U32

/-- Optional libc `malloc` as a typed affine **owner** buffer (never a Lean object).

Returns null-shaped handle (`0`) on OOM. Caller must `bufFree` exactly once (including
null — `free(NULL)` is a no-op). -/
@[never_extract, extern c inline "((size_t)malloc((size_t)(#1)))"]
public axiom bufAlloc (n : USize) : Sys MallocBuf

/-- Explicit `free` of a `bufAlloc` buffer. **Consumes** `MallocBuf` only (not arena `BytePtr`).

`free(NULL)` is OK. Always use the return value (or feed it into a later status) so freestanding
DCE cannot drop free from the product C wire. -/
@[never_extract, extern c inline "(free((void*)(#1)), (uint32_t)0)"]
public axiom bufFree (p : MallocBuf) : Sys U32

/-- Non-null test for a malloc owner (borrow). -/
@[fs_borrow, extern c inline "(uint8_t)((size_t)(#1) != 0)"]
public axiom MallocBuf.isNonNullU8 (p : MallocBuf) : U8

@[fs_borrow, inline] public def MallocBuf.isNonNull (p : MallocBuf) : Bool :=
  Bool.ofU8 (MallocBuf.isNonNullU8 p)

/-- Zero `n` bytes of a non-null malloc owner (borrow). Caller ensures non-null when `n > 0`. -/
@[fs_borrow, never_extract, extern c inline "(memset((void*)(#1), 0, (size_t)(#2)), (uint32_t)0)"]
public axiom MallocBuf.memZero (p : MallocBuf) (n : USize) : Sys U32

/-- If `p` non-null, zero `n` bytes and return `p`; if null, return null (no touch).

ISO C ternary + comma — no GNU statement-expr. Consumes and re-yields the same owner
so free-on-wire still requires a later `bufFree`. -/
@[never_extract, extern c inline "((size_t)(((void*)(size_t)(#1) == (void*)0) ? (size_t)0 : (memset((void*)(size_t)(#1), 0, (size_t)(#2)), (size_t)(#1))))"]
public axiom mallocBufZeroIfNonNull (p : MallocBuf) (n : USize) : Sys MallocBuf

/-- Alloc + zero-fill when non-null. Returns owner (may be null on OOM).

Free-on-wire: still requires a later `bufFree` consume on every path (including OOM null). -/
@[never_extract]
public unsafe def bufAllocZero (n : USize) : Sys MallocBuf :=
  mallocBufZeroIfNonNull (bufAlloc n) n

/-- Borrow `MallocBuf` as raw address for dual-param APIs. Same unchecked footgun as
`BytePtr.asUSizeUnchecked` (raw `USize` is not region-tracked after free). -/
@[fs_borrow, never_extract, extern c inline "((size_t)(#1))"]
public axiom MallocBuf.asUSizeUnchecked (p : MallocBuf) : USize

/-! ## extras: fsync / lseek (named allowlist; used by the append log)

`fsync` for durability. `lseek` for end-append and full-file scan. Whence is `U32`
(`SEEK_SET` / `SEEK_CUR` / `SEEK_END` via portable macros in inline patterns).
Returns seek offset as `USize` (or `(size_t)-1` on error).
-/

/-- `fsync(fd)` — freestanding borrow of `Fd`. Returns `0` on success. -/
@[fs_borrow, never_extract, extern c inline "((uint32_t)fsync((int)(#1)))"]
public axiom sysFsync (fd : Fd) : Sys U32

/-- `lseek(fd, off, whence)` — freestanding borrow of `Fd`. -/
@[fs_borrow, never_extract, extern c inline "((size_t)lseek((int)(#1), (long)(#2), (int)(#3)))"]
public axiom sysLseek (fd : Fd) (off : USize) (whence : U32) : Sys USize

/-! ## single-file append-only log

On-disk format (host endian, length-prefixed records):

```
uint32_t klen; uint32_t vlen; uint8_t key[klen]; uint8_t val[vlen];
```

* **put** appends a record (last-write-wins for equal keys on subsequent **get**).
* **get** scans from offset 0 and returns the **last** matching value.
* **sync** calls `fsync` on the owned fd.
* **Log** is a single-field `@[affine]` owner (K19); close consumes it.

`logPut` / `logGet` are Lean freestanding control-flow (`bifU32`/`bifUSize` +
`unsafe` scan loops) over tiny IO primops (`logLseek` / `logRead` / `logWriteU32` / …).
Generated C is Lean SSA (`if`/`goto`/libc calls) — not one giant GNU statement expression.

log read/write temps are ISO C11 — C99 compound literals for write slots, automatic
compound-literal stack slots + Lean `bif*` for reads, ternary expressions for exact read/write.
No GNU `({…})` statement expressions remain in the extract package IR.

Errors are unboxed `U32`/`USize` status codes — not Lean exceptions.

**Portability (LP64 harness):** file offsets for scan are tracked as `size_t`; `lseek` takes
`(long)` casts that are correct when `sizeof(long) >= 8` and on-disk lengths fit in `uint32_t`.
Get return codes (all-bits-one / minus 2 / minus 3 as `size_t`) are disjoint from successful
lengths on 64-bit `size_t` (on-disk max length is `UINT32_MAX`); on 32-bit `size_t` those
sentinels can collide with large value lengths — out of scope for this spike (do not claim ILP32).
-/

/-- Affine append-log handle (single field → C `size_t`; owns a POSIX fd). -/
@[affine]
public structure Log where
  raw : USize

/-- `SEEK_SET` for log scan/put (portable macro in inline pattern). -/
@[extern c inline "SEEK_SET"] public axiom seekSet : U32
/-- `SEEK_CUR`. -/
@[extern c inline "SEEK_CUR"] public axiom seekCur : U32
/-- `SEEK_END`. -/
@[extern c inline "SEEK_END"] public axiom seekEnd : U32

/-- Open or create an append log at null-terminated path. Returns all-bits-one `size_t` on open failure.
ISO C cast form (same shape as `sysOpen`; no GNU statement expr). -/
@[never_extract, extern c inline "((size_t)open((const char*)(#1), O_RDWR|O_CREAT, 0644))"]
public axiom logOpen (path : USize) : Sys Log

/-- `lseek` on log fd (borrow). Returns offset or `(size_t)-1` on error. -/
@[fs_borrow, never_extract, extern c inline "((size_t)lseek((int)(#1), (long)(#2), (int)(#3)))"]
public axiom logLseek (log : Log) (off : USize) (whence : U32) : Sys USize

/-- Raw `read` on log fd into caller buffer (borrow). Returns byte count as `size_t` (or
all-bits-one on error). ISO C single call — no statement expr. -/
@[fs_borrow, never_extract, extern c inline "((size_t)read((int)(#1), (void*)(#2), (size_t)(#3)))"]
public axiom logRead (log : Log) (buf : USize) (len : USize) : Sys USize

/-- Raw `write` on log fd from caller buffer (borrow). Returns byte count as `size_t`
(or all-bits-one on error). ISO C single call. -/
@[fs_borrow, never_extract, extern c inline "((size_t)write((int)(#1), (const void*)(#2), (size_t)(#3)))"]
public axiom logWrite (log : Log) (buf : USize) (len : USize) : Sys USize

/-- Private automatic 1-byte compound-literal slot (`&(uint8_t){0}`).

Lifetime = enclosing C block of the **same** Lean `def` / C function that materializes the
pattern. Bind once, then `logRead` + load in that function only — never return or store the
address across calls (dangling-stack UB). Not an affine heap owner. -/
@[never_extract, extern c inline "((size_t)&(uint8_t){0})"]
private axiom stackSlotU8 : USize

/-- Private automatic 4-byte compound-literal slot (`&(uint32_t){0}`). Same lifetime rules as
`stackSlotU8`. -/
@[never_extract, extern c inline "((size_t)&(uint32_t){0})"]
private axiom stackSlotU32 : USize

/-- Store low 32 bits of `v` at address `p` (ISO C comma). Used to stage `logWriteU32` temps. -/
@[never_extract, extern c inline "(*(uint32_t*)(#1) = (uint32_t)(#2), (uint32_t)0)"]
private axiom storeU32At (p : USize) (v : USize) : U32

/-- Read 4 bytes as host-endian `uint32_t` promoted to `size_t`.
`(size_t)-3` = EOF (0 bytes); `(size_t)-2` = short/IO error; else value in `0..UINT32_MAX`.

Lean control-flow over private ISO C stack slot + `logRead` + `USize.loadU32`. -/
@[fs_borrow, never_extract]
public def logReadU32 (log : Log) : Sys USize :=
  let p := stackSlotU32
  let n := logRead log p USize.four
  bifUSize (USize.beq n USize.zero) USize.neg3
    (bifUSize (USize.beq n USize.four) (USize.loadU32 p) USize.neg2)

/-- Read one byte. `(size_t)-1` on failure; else `0..255`.

Lean control-flow over private ISO C stack slot + `logRead` + `U8.load`. -/
@[fs_borrow, never_extract]
public def logReadU8 (log : Log) : Sys USize :=
  let p := stackSlotU8
  let n := logRead log p USize.one
  bifUSize (USize.beq n USize.one) (USize.ofU8 (U8.load p)) USize.neg1

/-- Self-TCO write-remaining loop on a log fd (same exactness as `writeAllGo`).

Returns `0` when all `left` bytes written (including `left == 0`); `1` on error, zero progress,
or `n > left`. Retries partial writes (`0 < n < left`). EmitC TCO → `goto _start`. -/
@[fs_borrow]
private unsafe def logWriteAllGo (log : Log) (buf : USize) (done : USize) (left : USize) : U32 :=
  bifU32 (USize.beq left USize.zero) U32.zero
    (let n := logWrite log (USize.add buf done) left;
     bifU32 (usizeIsNeg n) U32.one
       (bifU32 (USize.beq n USize.zero) U32.one
         (bifU32 (USize.bgt n left) U32.one
           (logWriteAllGo log buf (USize.add done n) (USize.sub left n)))))

/-- Write 4-byte host-endian length (low 32 bits of `v`). Returns `0` ok, `1` failure.

private stack slot + store + self-TCO `logWriteAllGo` (retries short writes). -/
@[fs_borrow, never_extract]
public unsafe def logWriteU32 (log : Log) (v : USize) : Sys U32 :=
  let p := stackSlotU32
  let _s := storeU32At p v
  logWriteAllGo log p USize.zero USize.four

/-- Write exactly `len` bytes (no-op success if `len == 0`). Returns `0` ok, `1` failure.

self-TCO `logWriteAllGo` — retries short writes until exact or hard error (no silent
truncated on-disk records from a single short `write` of key/val payloads). -/
@[fs_borrow, never_extract]
public unsafe def logWriteExact (log : Log) (buf : USize) (len : USize) : Sys U32 :=
  logWriteAllGo log buf USize.zero len

/-- Read exactly `len` bytes (no-op success if `len == 0`). Returns `0` ok, `(size_t)-2` failure.

ISO C ternary (no GNU statement expr). Single-shot exactness (short read = fail). -/
@[fs_borrow, never_extract, extern c inline "(((size_t)(#3) > 0 && read((int)(#1), (void*)(#2), (size_t)(#3)) != (ssize_t)(size_t)(#3)) ? (size_t)-2 : (size_t)0)"]
public axiom logReadExact (log : Log) (buf : USize) (len : USize) : Sys USize

/-- Consume `n` key bytes from the log, comparing to memory at `k` when `eq` is still true.

Returns `0` equal, `1` not equal, `2` IO error. Always drains `n` bytes on success path.
`@[fs_borrow]`: does not consume affine `Log`. -/
@[fs_borrow]
private unsafe def logKeyCmpGo (log : Log) (k : USize) (i : USize) (n : USize) (eq : Bool) : U32 :=
  bifU32 (USize.blt i n)
    (let b := logReadU8 log;
     bifU32 (USize.beq b USize.neg1) U32.two
       (logKeyCmpGo log k (USize.add i USize.one) n
         (bifBool eq (U8.beq (U8.ofUSize b) (U8.load (USize.add k i))) Bool.false)))
    (bifU32 eq U32.zero U32.one)

@[fs_borrow]
private unsafe def logGetFinishRead (log : Log) (out : USize) (best : USize) (bestv : USize) : USize :=
  let s := logLseek log best seekSet
  bifUSize (USize.beq s USize.neg1) USize.neg2
    (let e := logReadExact log out bestv;
     bifUSize (USize.beq e USize.neg2) USize.neg2 bestv)

/-- After EOF: materialize last matching value or status (not the hot scan path). -/
@[fs_borrow]
private unsafe def logGetFinish (log : Log) (out : USize) (outCap : USize)
    (best : USize) (bestv : USize) : USize :=
  bifUSize (USize.beq best USize.neg1) USize.neg1
    (bifUSize (USize.bgt bestv outCap) USize.neg3 (logGetFinishRead log out best bestv))

/-- Per-record scan loop: **self-tail-recursive only** so EmitC TCO → `goto _start` (O(1) stack).

Must not call other scan helpers that later call back into this function (mutual freestanding
recursion is **not** TCO'd — only same-function tail calls become `goto`). Intermediate work is
`let`s + `bifUSize` in this body; the only recursive edge is the final `logGetGo` on success path.

`pos` / `best` / `bestv`: file position, last matching value offset (`neg1` = none), value length. -/
@[fs_borrow]
private unsafe def logGetGo (log : Log) (k : USize) (klen : USize) (out : USize) (outCap : USize)
    (pos : USize) (best : USize) (bestv : USize) : USize :=
  let kl := logReadU32 log
  bifUSize (USize.beq kl USize.neg3) (logGetFinish log out outCap best bestv)
    (bifUSize (USize.beq kl USize.neg2) USize.neg2
      (let vl := logReadU32 log;
       bifUSize (USize.beq vl USize.neg2) USize.neg2
         (bifUSize (USize.beq vl USize.neg3) USize.neg2
           (bifUSize (USize.uaddWouldOverflow kl USize.eight) USize.neg2
             (bifUSize (USize.uaddWouldOverflow vl (USize.add USize.eight kl)) USize.neg2
               (bifUSize (USize.uaddWouldOverflow pos
                   (USize.add (USize.add USize.eight kl) vl)) USize.neg2
                 (let cmp := logKeyCmpGo log k USize.zero kl (USize.beq kl klen);
                  bifUSize (U32.beq cmp U32.two) USize.neg2
                    (let best' :=
                      bifUSize (U32.beq cmp U32.zero)
                        (USize.add pos (USize.add USize.eight kl)) best;
                     let bestv' := bifUSize (U32.beq cmp U32.zero) vl bestv;
                     let sk := logLseek log vl seekCur;
                     bifUSize (USize.beq sk USize.neg1) USize.neg2
                       (logGetGo log k klen out outCap
                         (USize.add pos (USize.add (USize.add USize.eight kl) vl))
                         best' bestv')))))))))

@[fs_borrow]
private unsafe def logPutWrites5 (log : Log) (v : USize) (vlen : USize) : U32 :=
  let e4 := logWriteExact log v vlen
  bifU32 (U32.beq e4 U32.zero) U32.zero U32.three

@[fs_borrow]
private unsafe def logPutWrites4 (log : Log) (k : USize) (klen : USize) (v : USize) (vlen : USize) : U32 :=
  let e3 := logWriteExact log k klen
  bifU32 (U32.beq e3 U32.zero) (logPutWrites5 log v vlen) U32.three

@[fs_borrow]
private unsafe def logPutWrites3 (log : Log) (k : USize) (klen : USize) (v : USize) (vlen : USize) : U32 :=
  let e2 := logWriteU32 log vlen
  bifU32 (U32.beq e2 U32.zero) (logPutWrites4 log k klen v vlen) U32.three

@[fs_borrow]
private unsafe def logPutWrites2 (log : Log) (k : USize) (klen : USize) (v : USize) (vlen : USize) : U32 :=
  let e1 := logWriteU32 log klen
  bifU32 (U32.beq e1 U32.zero) (logPutWrites3 log k klen v vlen) U32.three

/-- Append writes after overflow/seek checks. -/
@[fs_borrow]
private unsafe def logPutWrites (log : Log) (k : USize) (klen : USize) (v : USize) (vlen : USize) : U32 :=
  let se := logLseek log USize.zero seekEnd
  bifU32 (USize.beq se USize.neg1) U32.two (logPutWrites2 log k klen v vlen)

/-- Append one length-prefixed record. Borrows `Log`.

Returns `0` on success; `1` size overflow (klen/vlen not representable as `uint32_t`, or
`8+klen+vlen` overflows `size_t`); `2` seek failure; `3` write failure.

Lengths are checked **before** narrowing to `uint32_t` so high bits of `USize` cannot produce
a truncated on-disk length with a success status.

Lean freestanding control-flow; key/val/header writes retry short `write`s via
`logWriteAllGo` (same exactness as `writeAllGo`). Hard write errors still fail closed with `3`
(a partial record may remain only if a retryable short write is followed by a hard error mid-record —
same class as interrupted multi-write sequences). -/
@[fs_borrow, never_extract]
public unsafe def logPut (log : Log) (k : USize) (klen : USize) (v : USize) (vlen : USize) : Sys U32 :=
  bifU32 (USize.fitsU32 klen)
    (bifU32 (USize.fitsU32 vlen)
      (bifU32 (USize.uaddWouldOverflow klen USize.eight) U32.one
        (bifU32 (USize.uaddWouldOverflow vlen (USize.add USize.eight klen)) U32.one
          (logPutWrites log k klen v vlen)))
      U32.one)
    U32.one

/-- Scan log for key; last-write-wins. Borrows `Log`.

Writes value into `out` (capacity `outCap`). Returns value length on success;
all-bits-one `size_t` if not found; minus 2 if IO/corrupt; minus 3 if buffer too small.

Scan offsets are `size_t` with overflow checks before advance. See module note on LP64.

Lean freestanding scan — self-tail-recursive `logGetGo` (EmitC `if`/`goto` TCO, O(1) stack)
plus self-TCO `logKeyCmpGo`; small read/lseek primops only. Not one opaque statement expression.
Mutual freestanding recursion is **not** TCO'd; do not reintroduce a helper ring for the scan. -/
@[fs_borrow, never_extract]
public unsafe def logGet (log : Log) (k : USize) (klen : USize) (out : USize) (outCap : USize) :
    Sys USize :=
  let s0 := logLseek log USize.zero seekSet
  bifUSize (USize.beq s0 USize.neg1) USize.neg2
    (logGetGo log k klen out outCap USize.zero USize.neg1 USize.zero)

/-- `fsync` the log file. Borrows `Log`. Returns `0` on success. -/
@[fs_borrow, never_extract, extern c inline "((uint32_t)fsync((int)(#1)))"]
public axiom logSync (log : Log) : Sys U32

/-- Close the log. **Consumes** affine `Log`. Returns `0` on success. -/
@[never_extract, extern c inline "((uint32_t)close((int)(#1)))"]
public axiom logClose (log : Log) : Sys U32

/-! ## mmap + durability (no RC finalizers)

`MMap` is a single-field affine address (`size_t`). Mapping **length** is always a separate
`USize` parameter (K19 — no multi-field freestanding products).

**Ownership:** `sysMmap` is `@[fs_borrow]` + `@[fs_fresh_region]`: it borrows `Fd` but stamps a
**fresh** region on the result so `close` does not invalidate the mapping and `munmap` does not
invalidate the fd (POSIX: mapping outlives the descriptor).

**Durability protocol (MVP):** open → `ftruncate` → `mmap(MAP_SHARED)` → write through mapping →
`msync(MS_SYNC)` → `munmap` → optional `fsync` → `close` → reopen and read. No hidden finalizers.
Also legal: close the fd **while the map is still live**, then msync/munmap (proves fresh region).

**MAP_FAILED dispose:** `mmap` failure returns `(size_t)MAP_FAILED` as a live affine `MMap`.
`sysMunmap` **no-ops** on `NULL`/`MAP_FAILED` and still **consumes** the handle (safe error-path
dispose; avoids munmap(MAP_FAILED) UB and silent-drop rejection). `msync`/`copyFrom` return
non-zero without touching a failed map.

**Range checks:** `ftruncate` length and `mmap` offset are checked to fit in `long` before the
syscall (reject with status / MAP_FAILED) so high bits are not truncated into a negative `off_t`.
-/

/-- Affine file-mapping handle (single field → C `size_t` address). Length is a dual-param. -/
@[affine]
public structure MMap where
  addr : USize

/-- Branch on freestanding `Bool` for `MMap` results. -/
@[macro_inline, expose] public def bifMMap (c : Bool) (t e : MMap) : MMap :=
  Bool.casesOn (motive := fun _ => MMap) c e t

/-- `(size_t)MAP_FAILED` as a live affine `MMap` (error-path dispose via `sysMunmap`). -/
@[extern c inline "((size_t)MAP_FAILED)"]
public axiom mmapFailed : MMap

/-- True when `x` fits in `long` without truncation (`x == (size_t)(long)x`). -/
@[extern c inline "(uint8_t)((size_t)(#1) == (size_t)(long)(#1))"]
public axiom usizeFitsLongU8 (x : USize) : U8

@[inline] public def usizeFitsLong (x : USize) : Bool :=
  Bool.ofU8 (usizeFitsLongU8 x)

/-- True when mapping address is null or `MAP_FAILED` (borrow). -/
@[fs_borrow, extern c inline "(uint8_t)(!(void*)(#1) || (void*)(#1) == MAP_FAILED)"]
public axiom mmapIsBadU8 (m : MMap) : U8

@[fs_borrow, inline] public def mmapIsBad (m : MMap) : Bool :=
  Bool.ofU8 (mmapIsBadU8 m)

/-- True when raw pointer is null. -/
@[extern c inline "(uint8_t)((void*)(#1) == (void*)0)"]
public axiom usizeIsNullU8 (p : USize) : U8

@[inline] public def usizeIsNull (p : USize) : Bool :=
  Bool.ofU8 (usizeIsNullU8 p)

/-- Raw `ftruncate` after range check (borrow `Fd`). -/
@[fs_borrow, never_extract, extern c inline "((uint32_t)ftruncate((int)(#1), (long)(#2)))"]
public axiom ftruncateRaw (fd : Fd) (len : USize) : Sys U32

/-- `ftruncate(fd, len)` — freestanding borrow of `Fd`.
Returns `0` on success; `1` if `len` does not fit in `long` (no truncated cast); else errno-style
cast of `ftruncate` (non-zero on failure).

Lean range gate + tiny primop (no giant statement expr). -/
@[fs_borrow, never_extract]
public def sysFtruncate (fd : Fd) (len : USize) : Sys U32 :=
  bifU32 (usizeFitsLong len) (ftruncateRaw fd len) U32.one

/-- Raw `mmap` (borrow `Fd`; fresh region on result). -/
@[fs_borrow, fs_fresh_region, never_extract,
  extern c inline "((size_t)mmap((void*)0, (size_t)(#2), (int)(#3), (int)(#4), (int)(#1), (long)(#5)))"]
public axiom mmapRaw (fd : Fd) (len : USize) (prot : U32) (flags : U32) (off : USize) : Sys MMap

/-- `mmap(NULL, len, prot, flags, fd, off)` — borrows `Fd`; result is an **independent** `MMap`
region (`@[fs_fresh_region]`). Returns `(size_t)MAP_FAILED` on error or if `off` does not fit
in `long`.

Lean off-range gate + tiny `mmap` primop. -/
@[fs_borrow, fs_fresh_region, never_extract]
public def sysMmap (fd : Fd) (len : USize) (prot : U32) (flags : U32) (off : USize) : Sys MMap :=
  bifMMap (usizeFitsLong off) (mmapRaw fd len prot flags off) mmapFailed

/-- Raw `msync` (borrow; caller ensures address is live). -/
@[fs_borrow, never_extract, extern c inline "((uint32_t)msync((void*)(#1), (size_t)(#2), (int)(#3)))"]
public axiom msyncRaw (m : MMap) (len : USize) (flags : U32) : Sys U32

/-- `msync(addr, len, flags)` — freestanding borrow of `MMap`.
Returns `0` on success; `1` if `m` is null/`MAP_FAILED` (no touch); else cast of `msync`. -/
@[fs_borrow, never_extract]
public def sysMsync (m : MMap) (len : USize) (flags : U32) : Sys U32 :=
  bifU32 (mmapIsBad m) U32.one (msyncRaw m len flags)

/-- Raw `munmap` (consumes; caller ensures not MAP_FAILED/null). -/
@[never_extract, extern c inline "((uint32_t)munmap((void*)(#1), (size_t)(#2)))"]
public axiom munmapRaw (m : MMap) (len : USize) : Sys U32

/-- No-op dispose that still **consumes** a bad `MMap` (MAP_FAILED/null).
Names `#1` so the consume is visible at the C primop surface (ISO comma; not a free). -/
@[never_extract, extern c inline "((void)(size_t)(#1), (uint32_t)0)"]
public axiom munmapNop (m : MMap) : Sys U32

/-- `munmap(addr, len)` — **consumes** affine `MMap` (kills mapping region).
**MAP_FAILED / null:** no-op (returns `0`) so error-path dispose is legal without UB.
Valid maps: returns cast of `munmap` (`0` on success).

Lean gate + tiny primops (MAP_FAILED never passed to `munmap`). -/
@[never_extract]
public def sysMunmap (m : MMap) (len : USize) : Sys U32 :=
  bifU32 (mmapIsBad m) (munmapNop m) (munmapRaw m len)

/-- **Unchecked** cast: borrow `MMap` as raw address for dual-param APIs / pointer writes.

Same footgun as `BytePtr.asUSizeUnchecked`: raw `USize` is not region-tracked after `munmap`. -/
@[fs_borrow, never_extract, extern c inline "((size_t)(#1))"]
public axiom MMap.asUSizeUnchecked (m : MMap) : USize

/-- Store one byte at `dst + i` (ISO C comma; returns 0). -/
@[never_extract, extern c inline "(((uint8_t*)(#1))[(size_t)(#2)] = (uint8_t)(#3), (uint32_t)0)"]
public axiom ptrStoreU8 (dst : USize) (i : USize) (v : U8) : Sys U32

/-- Self-TCO byte copy into a raw destination address (EmitC `goto _start`). -/
private unsafe def mmapCopyGo (dst : USize) (src : USize) (i : USize) (n : USize) : U32 :=
  bifU32 (USize.blt i n)
    (let _w := ptrStoreU8 dst i (U8.load (USize.add src i));
     mmapCopyGo dst src (USize.add i USize.one) n)
    U32.zero

/-- Copy `len` bytes from `src` into the mapping (borrow `MMap`).

Returns `0` on success; `1` if dest is null/`MAP_FAILED`, or `src` is null with `len > 0`.

Lean guards + self-tail-recursive byte loop over `U8.load`/`ptrStoreU8` (not a C `for`
inside one statement expr). -/
@[fs_borrow, never_extract]
public unsafe def MMap.copyFrom (m : MMap) (src : USize) (len : USize) : Sys U32 :=
  bifU32 (mmapIsBad m) U32.one
    (bifU32 (usizeIsNull src)
      (bifU32 (USize.bgt len USize.zero) U32.one U32.zero)
      (mmapCopyGo (MMap.asUSizeUnchecked m) src USize.zero len))

end Systems.Sys
