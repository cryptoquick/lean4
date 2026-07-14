module
prelude
public import Systems.Scalars
public import Systems.Sys
public import Systems.Bytes
public import Systems.Numerics
public import Systems.Status
public import Systems.Mem
public import Systems.BitOps
public import Systems.Hash
public import Systems.ByteSpan
public import Systems.Map
public import Systems.BitVec
public import Systems.Set
public import Systems.Queue
public import Systems.Vector
public import Systems.Sort
public import Systems.Crc
public import Systems.String
public import Systems.BinarySearch
public import Systems.Deque
public import Systems.Stack
public import Systems.Ascii
public import Systems.MemRegion
public import Systems.BitSet
public import Systems.Parse
public import Systems.RingBuf
public import Systems.Fmt
public import Systems.List
public import Systems.Path
public import Systems.Hex
public import Systems.Utf8
public import Systems.Tree
public import Systems.Json
public import Systems.Base64
public import Systems.Graph
public import Systems.Regex
public import Systems.Url
public import Systems.ArenaPool
public import Systems.Ini
public import Systems.Csv
public import Systems.Bloom
public import Systems.Toml
public import Systems.Xml
public import Systems.SkipList
public import Systems.Yaml
public import Systems.Http
public import Systems.BTree
public import Systems.Dns
public import Systems.Sexp
public import Systems.Avl
public import Systems.Md
public import Systems.Icmp
public import Systems.RbTree
public import Systems.Pem
public import Systems.Ntp
public import Systems.Trie
public import Systems.Jwt
public import Systems.Dhcp
public import Systems.BinaryHeap
public import Systems.Uuid
public import Systems.Arp
public import Systems.IntervalTree
public import Systems.Semver
public import Systems.Gre
public import Systems.Splay
public import Systems.Cbor
public import Systems.Ip
public import Systems.BTreeMap
public import Systems.TomlQuery
public import Systems.Udp
public import Systems.SkipListMap
public import Systems.Edn
public import Systems.Tcp
public import Systems.HashMap
public import Systems.MsgPack
public import Systems.Icmpv6
public import Systems.LinkedHashMap
public import Systems.Protobuf
public import Systems.Sctp
public import Systems.OrderedMap
public import Systems.Avro
public import Systems.Dccp
public import Systems.TreeMap
public import Systems.Capnp
public import Systems.Quic
public import Systems.FlatBuffers
public import Systems.Mqtt
public import Systems.RadixTree
public import Systems.Asn1
public import Systems.Coap
public import Systems.YamlQuery
public import Systems.WebSocket
public import Systems.BitMap
public import Systems.Lz4
public import Systems.Socks5
public import Systems.Snappy
public import Systems.Rtsp
public import Systems.Zstd
public import Systems.Sip
public import Systems.Brotli
public import Systems.NtpQuery
public import Systems.Ogg
public import Systems.Smtp
public import Systems.BitSetMulti
public import Systems.Webm
public import Systems.Pop3
public import Systems.Roaring
public import Systems.Matroska
public import Systems.Imap
public import Systems.IntervalSet
public import Systems.Flac
public import Systems.Nntp
public import Systems.Ldap
public import Systems.Vorbis
public import Systems.Radius
public import Systems.OrderedU32Set
public import Systems.Diameter
public import Systems.SctpCommon
public import Systems.M3ua
public import Systems.Sua
public import Systems.Iua
public import Systems.V5ua
public import Systems.H248
public import Systems.Megaco
public import Systems.Mgcp
public import Systems.Sdp
public import Systems.Rtcp
public import Systems.Stun
public import Systems.Turn
public import Systems.Ice
public import Systems.Rtp
public import Systems.Srtp
public import Systems.Srtcp
public import Systems.Dtls
public import Systems.Tls
public import Systems.Ipsec
public import Systems.DepGraph
public import Systems.Trace
public import Systems.TomlConfig
public import Systems.Proc
public import Systems.Manifest
public import Systems.CacheIndex
public import Systems.L2tp
public import Systems.Pptp
public import Systems.L2f
public import Systems.Ppp
public import Systems.Hdlc
public import Systems.Parallelism.Simd
public import Systems.Parallelism.ForkJoin
public import Systems.Parallelism.Channel

/-!
# Systems Lean extract surface

`@[export_c]` product roots for the example harness. Built against the in-tree
`Systems` prelude (`src/Systems/`). Consumer links one `freestanding.bundle`
archive (no Lean object runtime).

Surface groups (see C prototypes in `main.c` / example README):

* **Scalars** — unboxed arithmetic (`lean_fs_add`), dual-param checksum / load
* **Sys + Fd** — open / read / write / close (affine `Fd`; double-close fail-closed)
* **Arenas / buffers** — create / alloc / free, malloc buffers
* **Append log** — open / put / get / sync / close (unboxed status codes)
* **mmap** — map / copy / msync / unmap durability
* **R7 stdlib** — `Bytes` / `Numerics` / `Status` helpers (`lean_fs_mem_*`, `lean_fs_u32_sat_add`, …)

Control-flow on the extract path uses freestanding helpers (e.g. `checksumGo`,
`logGet`/`logPut`) that lower to C locals + `if`/`goto` — not multi-field freestanding
product values and not GNU statement-expression bodies.
-/

open Systems.Scalars
open Systems.Sys
open Systems.Bytes
open Systems.Numerics
open Systems.Status
open Systems.Mem
open Systems.BitOps
open Systems.Hash
open Systems.ByteSpan
open Systems.Map
open Systems.BitVec
open Systems.Set
open Systems.Queue
open Systems.Vector
open Systems.Sort
open Systems.Crc
open Systems.String
open Systems.BinarySearch
open Systems.Deque
open Systems.Stack
open Systems.Ascii
open Systems.MemRegion
open Systems.BitSet
open Systems.Parse
open Systems.RingBuf
open Systems.Fmt
open Systems.List
open Systems.Path
open Systems.Hex
open Systems.Utf8
open Systems.Tree
open Systems.Json
open Systems.Base64
open Systems.Graph
open Systems.Regex
open Systems.Url
open Systems.ArenaPool
open Systems.Ini
open Systems.Csv
open Systems.Bloom
open Systems.Toml
open Systems.Xml
open Systems.SkipList
open Systems.Yaml
open Systems.Http
open Systems.BTree
open Systems.Dns
open Systems.Sexp
open Systems.Avl
open Systems.Md
open Systems.Icmp
open Systems.RbTree
open Systems.Pem
open Systems.Ntp
open Systems.Trie
open Systems.Parallelism.Simd
open Systems.Parallelism.ForkJoin
open Systems.Parallelism.Channel

@[export_c lean_fs_add]
public def add (x y : U64) : U64 :=
  Systems.Scalars.U64.add x y

/-! ## Checksum (multi-module freestanding control-flow)

`checksumGo` is defined in `Systems.Scalars`. LCNF emits a C loop shape there;
this export only calls it.
-/

/-- Polynomial checksum over `len` bytes at address `addr` (no alloc).

C ABI (locked for this harness): `uint32_t lean_fs_checksum(size_t addr, size_t len);`
`addr` is a pointer bitcast through freestanding `USize` → EmitC `size_t`.
Separate Lean parameters — not a `Slice`/`Prod`.

Body: freestanding control-flow (`Systems.Scalars.checksumGo`); generated C is
load/add/mul under `if`/`goto` in the Scalars object file. -/
@[export_c lean_fs_checksum]
public unsafe def checksum (addr : USize) (len : USize) : U32 :=
  Systems.Scalars.checksumGo addr len USize.zero U32.zero

/-- Single-byte load via freestanding `U8.load`.

C ABI: `uint32_t lean_fs_load_u8(size_t addr);` -/
@[export_c lean_fs_load_u8]
public def loadU8 (addr : USize) : U32 :=
  U32.ofU8 (U8.load addr)

/-! ## Sys exports (libc only; affine Fd at Lean boundary as size_t) -/

/-- `lean_fs_open(path, flags, mode)` — path is a null-terminated C string pointer. -/
@[export_c lean_fs_open]
public def fsOpen (path : USize) (flags : U32) (mode : U32) : Fd :=
  Systems.Sys.sysOpen path flags mode

/-- `lean_fs_close(fd)` — consumes the descriptor (affine). -/
@[export_c lean_fs_close]
public def fsClose (fd : Fd) : U32 :=
  Systems.Sys.sysClose fd

/-- `lean_fs_read(fd, buf, len)` — borrows fd (`@[fs_borrow]`; not RC `@&`). -/
@[fs_borrow, export_c lean_fs_read]
public def fsRead (fd : Fd) (buf : USize) (len : USize) : USize :=
  Systems.Sys.sysRead fd buf len

/-- `lean_fs_write(fd, buf, len)` — borrows fd (`@[fs_borrow]`; not RC `@&`). -/
@[fs_borrow, export_c lean_fs_write]
public def fsWrite (fd : Fd) (buf : USize) (len : USize) : USize :=
  Systems.Sys.sysWrite fd buf len

/-- Write **all** bytes then close (libc open/write/close).

`writeAllImpl` is freestanding control-flow over portable `O_*` flag primops +
`sysOpen` / self-TCO `writeAllGo` / `sysClose` (not a giant statement expr). Partial writes are
retried until `len` bytes are written or an error; short stuck progress is failure (status `2`).

`unsafe` — write-remaining loop has no freestanding WF. Affine open/write/close is also
exercised by `fsOpen`/`fsWrite`/`fsClose` and the double-close fail test.

C ABI: `uint32_t lean_fs_write_all(size_t path, size_t buf, size_t len);`
Returns `0` on success (all bytes written), non-zero on failure. -/
@[export_c lean_fs_write_all]
public unsafe def writeAll (path : USize) (buf : USize) (len : USize) : U32 :=
  Systems.Sys.writeAllImpl path buf len

/-- Affine composition smoke: open → write (borrow) → close (consume). Takes flags/mode as
params so constants are not lifted to closed terms. -/
@[export_c lean_fs_open_write_close]
public def openWriteClose (path : USize) (flags : U32) (mode : U32) (buf : USize) (len : USize) : U32 :=
  let fd := Systems.Sys.sysOpen path flags mode
  let _n := Systems.Sys.sysWrite fd buf len
  Systems.Sys.sysClose fd

/-! ## Arena exports (sequential; USize sizes; no product returns) -/

/-- `lean_fs_arena_create(cap)` — malloc bump arena with payload capacity `cap`. -/
@[export_c lean_fs_arena_create]
public def fsArenaCreate (cap : USize) : Arena :=
  Systems.Sys.Arena.create cap

/-- `lean_fs_arena_alloc(arena, nbytes)` — consumes arena, returns updated handle (same region). -/
@[export_c lean_fs_arena_alloc]
public def fsArenaAlloc (a : Arena) (nbytes : USize) : Arena :=
  Systems.Sys.Arena.alloc a nbytes

/-- `lean_fs_arena_last_ptr(arena)` — borrow; returns affine `BytePtr` as `size_t`. -/
@[fs_borrow, export_c lean_fs_arena_last_ptr]
public def fsArenaLastPtr (a : Arena) : BytePtr :=
  Systems.Sys.Arena.lastPtr a

/-- `lean_fs_arena_free(arena)` — consumes arena; invalidates derived buffers in the checker. -/
@[export_c lean_fs_arena_free]
public def fsArenaFree (a : Arena) : U32 :=
  Systems.Sys.Arena.free a

/-- Optional typed `malloc` buffer (affine `MallocBuf` owner; must `bufFree`). -/
@[export_c lean_fs_malloc]
public def fsMalloc (n : USize) : MallocBuf :=
  Systems.Sys.bufAlloc n

/-- Explicit free of a `fsMalloc` / `MallocBuf` (not an arena `BytePtr`). -/
@[export_c lean_fs_buf_free]
public def fsBufFree (p : MallocBuf) : U32 :=
  Systems.Sys.bufFree p

/-- Arena composition: create → alloc → lastPtr → fill → checksum → free.

`BytePtr` is consumed via `intoUSize` after the last borrow (QTT exact-once); arena free then
kills the region in LCNF AffineCheck. Raw `USize` is not region-tracked after free (K11).

C ABI: `uint32_t lean_fs_arena_smoke(size_t cap, size_t nbytes, uint8_t fill);` -/
@[export_c lean_fs_arena_smoke]
public unsafe def arenaSmoke (cap : USize) (nbytes : USize) (fill : U8) : U32 :=
  let a := Systems.Sys.Arena.create cap
  let a := Systems.Sys.Arena.alloc a nbytes
  let p := Systems.Sys.Arena.lastPtr a
  let _f := Systems.Sys.BytePtr.fill p nbytes fill
  let addr := Systems.Sys.BytePtr.intoUSize p
  let sum := Systems.Scalars.checksumGo addr nbytes USize.zero U32.zero
  let _e := Systems.Sys.Arena.free a
  sum

/-! ## Append-log exports (affine `Log`; dual-param key/value; libc only) -/

/-- `lean_fs_log_open(path)` — null-terminated path; returns log handle or `(size_t)-1`. -/
@[export_c lean_fs_log_open]
public def fsLogOpen (path : USize) : Log :=
  Systems.Sys.logOpen path

/-- `lean_fs_log_put(log, k, klen, v, vlen)` — append record; borrows log. -/
@[fs_borrow, export_c lean_fs_log_put]
public unsafe def fsLogPut (log : Log) (k : USize) (klen : USize) (v : USize) (vlen : USize) : U32 :=
  Systems.Sys.logPut log k klen v vlen

/-- `lean_fs_log_get(log, k, klen, out, out_cap)` — last-write-wins scan; borrows log.
Returns value length, or `(size_t)-1`/`-2`/`-3` for not-found / IO / too-small. -/
@[fs_borrow, export_c lean_fs_log_get]
public unsafe def fsLogGet (log : Log) (k : USize) (klen : USize) (out : USize) (outCap : USize) :
    USize :=
  Systems.Sys.logGet log k klen out outCap

/-- `lean_fs_log_sync(log)` — `fsync`; borrows log. -/
@[fs_borrow, export_c lean_fs_log_sync]
public def fsLogSync (log : Log) : U32 :=
  Systems.Sys.logSync log

/-- `lean_fs_log_close(log)` — consumes affine `Log`. -/
@[export_c lean_fs_log_close]
public def fsLogClose (log : Log) : U32 :=
  Systems.Sys.logClose log

/-- Log composition smoke: open → put → get → sync → close (affine borrow/consume).

Happy-path sequencing only: always runs put/get/sync/close and **returns the get result**.
Put/sync/close status codes are not folded. Put still executes (`@[never_extract]`).

C ABI: `size_t lean_fs_log_smoke(size_t path, size_t k, size_t klen, size_t v, size_t vlen, size_t out, size_t out_cap);` -/
@[export_c lean_fs_log_smoke]
public unsafe def logSmoke (path : USize) (k : USize) (klen : USize) (v : USize) (vlen : USize)
    (out : USize) (outCap : USize) : USize :=
  let log := Systems.Sys.logOpen path
  let _pe := Systems.Sys.logPut log k klen v vlen
  let n := Systems.Sys.logGet log k klen out outCap
  let _s := Systems.Sys.logSync log
  let _c := Systems.Sys.logClose log
  n

/-! ## mmap exports (affine `MMap`; dual-param length; libc only) -/

/-- `lean_fs_ftruncate(fd, len)` — borrows fd. -/
@[fs_borrow, export_c lean_fs_ftruncate]
public def fsFtruncate (fd : Fd) (len : USize) : U32 :=
  Systems.Sys.sysFtruncate fd len

/-- `lean_fs_mmap(fd, len, prot, flags, off)` — borrows fd; returns independent `MMap` as `size_t`.
`(size_t)MAP_FAILED` on error. `@[fs_fresh_region]`: mapping does not share the fd region. -/
@[fs_borrow, fs_fresh_region, export_c lean_fs_mmap]
public def fsMmap (fd : Fd) (len : USize) (prot : U32) (flags : U32) (off : USize) : MMap :=
  Systems.Sys.sysMmap fd len prot flags off

/-- `lean_fs_msync(addr, len, flags)` — borrows mapping. -/
@[fs_borrow, export_c lean_fs_msync]
public def fsMsync (m : MMap) (len : USize) (flags : U32) : U32 :=
  Systems.Sys.sysMsync m len flags

/-- `lean_fs_munmap(addr, len)` — consumes affine `MMap`. -/
@[export_c lean_fs_munmap]
public def fsMunmap (m : MMap) (len : USize) : U32 :=
  Systems.Sys.sysMunmap m len

/-- `lean_fs_mmap_copy(addr, src, len)` — write through mapping (borrow).

`unsafe` — `copyFrom` uses a freestanding TCO byte loop (`mmapCopyGo`) without WF. -/
@[fs_borrow, export_c lean_fs_mmap_copy]
public unsafe def fsMmapCopy (m : MMap) (src : USize) (len : USize) : U32 :=
  Systems.Sys.MMap.copyFrom m src len

/-- mmap composition: open → ftruncate → mmap → copy → msync → munmap → fsync → close.

Happy-path sequencing only (no freestanding `if` on status). Returns last `close` status.
`sysMunmap` no-ops on `MAP_FAILED` so a failed map is still consumable without UB.
C consumer proves durability by reopen-and-read after this sequence.

`unsafe` — `MMap.copyFrom` is a freestanding TCO loop.

C ABI: `uint32_t lean_fs_mmap_smoke(size_t path, uint32_t oflags, uint32_t mode,
  size_t len, uint32_t prot, uint32_t map_flags, size_t off, size_t src, uint32_t ms_flags);` -/
@[export_c lean_fs_mmap_smoke]
public unsafe def mmapSmoke (path : USize) (oflags : U32) (mode : U32) (len : USize)
    (prot : U32) (mapFlags : U32) (off : USize) (src : USize) (msFlags : U32) : U32 :=
  let fd := Systems.Sys.sysOpen path oflags mode
  let _t := Systems.Sys.sysFtruncate fd len
  let m := Systems.Sys.sysMmap fd len prot mapFlags off
  let _c := Systems.Sys.MMap.copyFrom m src len
  let _s := Systems.Sys.sysMsync m len msFlags
  let _u := Systems.Sys.sysMunmap m len
  let _f := Systems.Sys.sysFsync fd
  Systems.Sys.sysClose fd

/-- Region-independence smoke: open → ftruncate → mmap → **close fd while map live** →
msync → munmap.

Only legal when `sysMmap` stamps a **fresh** region (`@[fs_fresh_region]`). Under derived-region
semantics, `close` would kill the map's stamp and msync would be use-after-free.

`unsafe` — `MMap.copyFrom` is a freestanding TCO loop.

Returns last `munmap` status. C ABI:
`uint32_t lean_fs_mmap_close_live(size_t path, uint32_t oflags, uint32_t mode,
  size_t len, uint32_t prot, uint32_t map_flags, size_t off, size_t src, uint32_t ms_flags);` -/
@[export_c lean_fs_mmap_close_live]
public unsafe def mmapCloseLive (path : USize) (oflags : U32) (mode : U32) (len : USize)
    (prot : U32) (mapFlags : U32) (off : USize) (src : USize) (msFlags : U32) : U32 :=
  let fd := Systems.Sys.sysOpen path oflags mode
  let _t := Systems.Sys.sysFtruncate fd len
  let m := Systems.Sys.sysMmap fd len prot mapFlags off
  let _cp := Systems.Sys.MMap.copyFrom m src len
  let _c := Systems.Sys.sysClose fd
  let _s := Systems.Sys.sysMsync m len msFlags
  Systems.Sys.sysMunmap m len

/-! ## R7 freestanding stdlib smoke exports (Bytes / Numerics / Status)

These pull first-wave `Systems.*` helpers into the product bundle and exercise
them from the C harness without managed `List`/`Array`/`String`.
-/

/-- Byte-range equality via `Systems.Scalars.memEqGo`.

C ABI: `uint32_t lean_fs_mem_eq(size_t a, size_t b, size_t n);` → `1` equal, `0` not. -/
@[export_c lean_fs_mem_eq]
public unsafe def fsMemEq (a : USize) (b : USize) (n : USize) : U32 :=
  bifU32 (Systems.Scalars.memEqGo a b USize.zero n) U32.one U32.zero

/-- Copy `n` bytes `src → dst` via null-safe `Systems.Mem.memCpy`.

Product export prefers the Mem null-touch gate (`n>0` ∧ null → `1`).
Low-level ungated `Bytes.memCopy` remains for internal dual-param loops.

C ABI: `uint32_t lean_fs_mem_copy(size_t dst, size_t src, size_t n);` → `0` ok, `1` null/`n>0`. -/
@[export_c lean_fs_mem_copy]
public unsafe def fsMemCopy (dst : USize) (src : USize) (n : USize) : U32 :=
  Systems.Mem.memCpy dst src n

/-- Fill `n` bytes at `dst` with `v` via `Systems.Bytes.memFill`.

**Dual ABI (intentional):** fill stays on the Bytes surface (no null gate here).
Prefer `lean_fs_mem_move` / `lean_fs_mem_copy` when null-safe status is required.
Callers must not pass null with `n > 0`.

C ABI: `uint32_t lean_fs_mem_fill(size_t dst, size_t n, uint8_t v);` → `0` ok. -/
@[export_c lean_fs_mem_fill]
public unsafe def fsMemFill (dst : USize) (n : USize) (v : U8) : U32 :=
  Systems.Bytes.memFill dst n v

/-- XOR-fold of `n` bytes as `uint32_t` (low byte significant).

C ABI: `uint32_t lean_fs_mem_xor_fold(size_t addr, size_t n);` -/
@[export_c lean_fs_mem_xor_fold]
public unsafe def fsMemXorFold (addr : USize) (n : USize) : U32 :=
  U32.ofU8 (Systems.Bytes.memXorFold addr n)

/-- Find first index of `needle` in `[addr, addr+n)`, or `(size_t)-1` if not found.

C ABI: `size_t lean_fs_mem_find_u8(size_t addr, size_t n, uint8_t needle);` -/
@[export_c lean_fs_mem_find_u8]
public unsafe def fsMemFindU8 (addr : USize) (n : USize) (needle : U8) : USize :=
  Systems.Bytes.memFindU8 addr n needle

/-- Saturating `uint32_t` add (`Systems.Numerics.U32.satAdd`).

C ABI: `uint32_t lean_fs_u32_sat_add(uint32_t a, uint32_t b);` -/
@[export_c lean_fs_u32_sat_add]
public def fsU32SatAdd (a : U32) (b : U32) : U32 :=
  Systems.Numerics.U32.satAdd a b

/-- Saturating `uint32_t` subtract (floor at 0).

C ABI: `uint32_t lean_fs_u32_sat_sub(uint32_t a, uint32_t b);` -/
@[export_c lean_fs_u32_sat_sub]
public def fsU32SatSub (a : U32) (b : U32) : U32 :=
  Systems.Numerics.U32.satSub a b

/-- Defined rotate-left (`k` masked to 5 bits; `k≡0 (mod 32)` is identity).

C ABI: `uint32_t lean_fs_u32_rotate_left(uint32_t x, uint32_t k);` -/
@[export_c lean_fs_u32_rotate_left]
public def fsU32RotateLeft (x : U32) (k : U32) : U32 :=
  Systems.Numerics.U32.rotateLeft x k

/-- Defined rotate-right (`k` masked to 5 bits; `k≡0 (mod 32)` is identity).

C ABI: `uint32_t lean_fs_u32_rotate_right(uint32_t x, uint32_t k);` -/
@[export_c lean_fs_u32_rotate_right]
public def fsU32RotateRight (x : U32) (k : U32) : U32 :=
  Systems.Numerics.U32.rotateRight x k

/-- Clamp `x` into `[lo, hi]` (unsigned; caller ensures `lo ≤ hi`).

C ABI: `uint32_t lean_fs_u32_clamp(uint32_t x, uint32_t lo, uint32_t hi);` -/
@[export_c lean_fs_u32_clamp]
public def fsU32Clamp (x : U32) (lo : U32) (hi : U32) : U32 :=
  Systems.Numerics.U32.clamp x lo hi

/-- Saturating `uint64_t` add (`Systems.Numerics.U64.satAdd`).

C ABI: `uint64_t lean_fs_u64_sat_add(uint64_t a, uint64_t b);` -/
@[export_c lean_fs_u64_sat_add]
public def fsU64SatAdd (a : U64) (b : U64) : U64 :=
  Systems.Numerics.U64.satAdd a b

/-- Saturating `uint64_t` subtract (floor at 0).

C ABI: `uint64_t lean_fs_u64_sat_sub(uint64_t a, uint64_t b);` -/
@[export_c lean_fs_u64_sat_sub]
public def fsU64SatSub (a : U64) (b : U64) : U64 :=
  Systems.Numerics.U64.satSub a b

/-- Defined `uint64_t` rotate-left (`k` masked to 6 bits).

C ABI: `uint64_t lean_fs_u64_rotate_left(uint64_t x, uint64_t k);` -/
@[export_c lean_fs_u64_rotate_left]
public def fsU64RotateLeft (x : U64) (k : U64) : U64 :=
  Systems.Numerics.U64.rotateLeft x k

/-- Defined `uint64_t` rotate-right (`k` masked to 6 bits).

C ABI: `uint64_t lean_fs_u64_rotate_right(uint64_t x, uint64_t k);` -/
@[export_c lean_fs_u64_rotate_right]
public def fsU64RotateRight (x : U64) (k : U64) : U64 :=
  Systems.Numerics.U64.rotateRight x k

/-- Clamp `x` into `[lo, hi]` (unsigned; caller ensures `lo ≤ hi`).

C ABI: `uint64_t lean_fs_u64_clamp(uint64_t x, uint64_t lo, uint64_t hi);` -/
@[export_c lean_fs_u64_clamp]
public def fsU64Clamp (x : U64) (lo : U64) (hi : U64) : U64 :=
  Systems.Numerics.U64.clamp x lo hi

/-- Saturating `size_t` add (`SIZE_MAX` on overflow).

C ABI: `size_t lean_fs_usize_sat_add(size_t a, size_t b);` -/
@[export_c lean_fs_usize_sat_add]
public def fsUSizeSatAdd (a : USize) (b : USize) : USize :=
  Systems.Numerics.USize.satAdd a b

/-- Clamp `size_t` into `[lo, hi]` (unsigned; caller ensures `lo ≤ hi`).

C ABI: `size_t lean_fs_usize_clamp(size_t x, size_t lo, size_t hi);` -/
@[export_c lean_fs_usize_clamp]
public def fsUSizeClamp (x : USize) (lo : USize) (hi : USize) : USize :=
  Systems.Numerics.USize.clamp x lo hi

/-- Status normalize: ok → `0`, any nonzero → `1`.

C ABI: `uint32_t lean_fs_status_normalize(uint32_t s);` -/
@[export_c lean_fs_status_normalize]
public def fsStatusNormalize (s : U32) : U32 :=
  Systems.Status.normalize s

/-- Sequential status composition (`andThen`).

C ABI: `uint32_t lean_fs_status_and_then(uint32_t s1, uint32_t s2);` -/
@[export_c lean_fs_status_and_then]
public def fsStatusAndThen (s1 : U32) (s2 : U32) : U32 :=
  Systems.Status.andThen s1 s2

/-- Prefer success (`orElse`): if `s1` ok return `s1`, else `s2`.

C ABI: `uint32_t lean_fs_status_or_else(uint32_t s1, uint32_t s2);` -/
@[export_c lean_fs_status_or_else]
public def fsStatusOrElse (s1 : U32) (s2 : U32) : U32 :=
  Systems.Status.orElse s1 s2

/-! ## R7 expansion + Three-Layer Cake smoke exports

`lean_fs_par_*` names mark Three-Layer Cake surface (L1–L3). Bodies are **sequential**
(no pthread / Lean `Task`); see `Systems.Parallelism.*` module docs.
-/

/-- Overlap-safe memmove.

C ABI: `uint32_t lean_fs_mem_move(size_t dst, size_t src, size_t n);` -/
@[export_c lean_fs_mem_move]
public unsafe def fsMemMove (dst : USize) (src : USize) (n : USize) : U32 :=
  Systems.Mem.memMove dst src n

/-- FNV-1a then finalize over a byte range.

C ABI: `uint32_t lean_fs_hash_bytes(size_t addr, size_t n);` -/
@[export_c lean_fs_hash_bytes]
public unsafe def fsHashBytes (addr : USize) (n : USize) : U32 :=
  Systems.Hash.hashBytes addr n

/-- Population count of a `uint32_t`.

C ABI: `uint32_t lean_fs_u32_popcount(uint32_t x);` -/
@[export_c lean_fs_u32_popcount]
public unsafe def fsU32Popcount (x : U32) : U32 :=
  Systems.BitOps.U32.popcount x

/-- L1 SIMD-shaped map-add then XOR-fold.

C ABI: `uint32_t lean_fs_par_map_fold(size_t dst, size_t src, size_t n, uint8_t addend);` -/
@[export_c lean_fs_par_map_fold]
public unsafe def fsParMapFold (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  Systems.Parallelism.Simd.mapAddThenFoldXor dst src n addend

/-- L1 chunked-4 map-add then XOR-fold (SIMD-shaped sequential; not hardware SIMD).

C ABI: `uint32_t lean_fs_par_map_fold_chunk4(size_t dst, size_t src, size_t n, uint8_t addend);` -/
@[export_c lean_fs_par_map_fold_chunk4]
public unsafe def fsParMapFoldChunk4 (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  Systems.Parallelism.Simd.mapAddThenFoldXorChunk4 dst src n addend

/-- L2 sequential fork-join map-add over partitioned halves.

C ABI: `uint32_t lean_fs_par_fork_join(size_t dst, size_t src, size_t n, uint8_t addend);` -/
@[export_c lean_fs_par_fork_join]
public unsafe def fsParForkJoin (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  Systems.Parallelism.ForkJoin.forkJoinMapAdd dst src n addend

/-- L2 backend id: `0` = sequential ownership (product default; residual-free / ccomp).

Takes a dummy `U32` so freestanding EmitC treats this as a function (nullary
`@[export_c]` would forward-declare a global `uint32_t` and redefine as `f(void)`).

C ABI: `uint32_t lean_fs_par_l2_backend(uint32_t unused);` — pass `0`. -/
@[export_c lean_fs_par_l2_backend]
public def fsParL2Backend (_unused : U32) : U32 :=
  Systems.Parallelism.ForkJoin.l2BackendSequential

/-- L2 sequential map-add then XOR-fold over partitioned halves.

C ABI: `uint32_t lean_fs_par_fork_join_fold(size_t dst, size_t src, size_t n, uint8_t addend);` -/
@[export_c lean_fs_par_fork_join_fold]
public unsafe def fsParForkJoinFold (dst : USize) (src : USize) (n : USize) (addend : U8) : U32 :=
  Systems.Parallelism.ForkJoin.forkJoinMapThenFold dst src n addend

/-- L3 linear channel ping-pong (`0` match, `1` mismatch).

C ABI: `uint32_t lean_fs_par_chan_ping(uint64_t v);` -/
@[export_c lean_fs_par_chan_ping]
public def fsParChanPing (v : U64) : U32 :=
  Systems.Parallelism.Channel.pingPong v

/-- L3 dual-payload sequential ping-pair (`0` ok).

C ABI: `uint32_t lean_fs_par_chan_ping_pair(uint64_t a, uint64_t b);` -/
@[export_c lean_fs_par_chan_ping_pair]
public def fsParChanPingPair (a : U64) (b : U64) : U32 :=
  Systems.Parallelism.Channel.pingPongPair a b

/-- L3 trySend/tryRecv smoke (`0` ok).

C ABI: `uint32_t lean_fs_par_chan_try_smoke(uint64_t v);` -/
@[export_c lean_fs_par_chan_try_smoke]
public def fsParChanTrySmoke (v : U64) : U32 :=
  Systems.Parallelism.Channel.trySmoke v

/-! ## ByteSpan / Map smoke exports

ByteArray/HashMap-**shaped** dual-buffer APIs — not managed `ByteArray` / `Std.HashMap`.
-/

/-- Bounds-safe byte load: value `0..255` as `size_t`, or `(size_t)-1` if `i ≥ n`.

C ABI: `size_t lean_fs_span_get_u8(size_t addr, size_t n, size_t i);` -/
@[export_c lean_fs_span_get_u8]
public unsafe def fsSpanGetU8 (addr : USize) (n : USize) (i : USize) : USize :=
  Systems.ByteSpan.getU8 addr n i

/-- Bounds-safe byte store: `0` ok, `3` bounds.

C ABI: `uint32_t lean_fs_span_set_u8(size_t addr, size_t n, size_t i, uint8_t v);` -/
@[export_c lean_fs_span_set_u8]
public unsafe def fsSpanSetU8 (addr : USize) (n : USize) (i : USize) (v : U8) : U32 :=
  Systems.ByteSpan.setU8 addr n i v

/-- Span equality: `0` equal, `1` differ.

C ABI: `uint32_t lean_fs_span_eq(size_t a, size_t b, size_t n);` -/
@[export_c lean_fs_span_eq]
public unsafe def fsSpanEq (a : USize) (b : USize) (n : USize) : U32 :=
  Systems.ByteSpan.eq a b n

/-- Prefix equality of length `k` (also fails if `k` exceeds either length).

C ABI: `uint32_t lean_fs_span_prefix_eq(size_t a, size_t na, size_t b, size_t nb, size_t k);` -/
@[export_c lean_fs_span_prefix_eq]
public unsafe def fsSpanPrefixEq (a : USize) (na : USize) (b : USize) (nb : USize) (k : USize) : U32 :=
  Systems.ByteSpan.prefixEq a na b nb k

/-- FNV-1a over a span.

C ABI: `uint32_t lean_fs_span_hash32(size_t addr, size_t n);` -/
@[export_c lean_fs_span_hash32]
public unsafe def fsSpanHash32 (addr : USize) (n : USize) : U32 :=
  Systems.ByteSpan.hash32 addr n

/-- Subspan bounds: `0` ok, `3` if `off`/`len` exceed parent length `n`.

C ABI: `uint32_t lean_fs_span_subspan_ok(size_t n, size_t off, size_t len);` -/
@[export_c lean_fs_span_subspan_ok]
public unsafe def fsSpanSubspanOk (n : USize) (off : USize) (len : USize) : U32 :=
  Systems.ByteSpan.subspanOk n off len

/-- Subspan base address (`addr+off`) or `(size_t)-1` if out of bounds.

C ABI: `size_t lean_fs_span_subspan_addr(size_t addr, size_t n, size_t off, size_t len);` -/
@[export_c lean_fs_span_subspan_addr]
public unsafe def fsSpanSubspanAddr (addr : USize) (n : USize) (off : USize) (len : USize) : USize :=
  Systems.ByteSpan.subspanAddr addr n off len

/-- Subspan length (`len` if ok, else `0`).

C ABI: `size_t lean_fs_span_subspan_len(size_t n, size_t off, size_t len);` -/
@[export_c lean_fs_span_subspan_len]
public unsafe def fsSpanSubspanLen (n : USize) (off : USize) (len : USize) : USize :=
  Systems.ByteSpan.subspanLen n off len

/-- Zero occupancy tags for a Map table of capacity `cap`.

C ABI: `uint32_t lean_fs_map_init(size_t tags, size_t cap);` -/
@[export_c lean_fs_map_init]
public unsafe def fsMapInit (tags : USize) (cap : USize) : U32 :=
  Systems.Map.init tags cap

/-- Insert/update `key → val` in dual-buffer open-addressing table.

C ABI: `uint32_t lean_fs_map_insert(size_t keys, size_t vals, size_t tags, size_t cap,
  uint32_t key, uint32_t val);` → `0` ok, `3` full/`cap==0`. -/
@[export_c lean_fs_map_insert]
public unsafe def fsMapInsert (keys : USize) (vals : USize) (tags : USize) (cap : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.Map.insert keys vals tags cap key val

/-- Lookup: value as `size_t`, or `(size_t)-1` if missing.

C ABI: `size_t lean_fs_map_get(size_t keys, size_t vals, size_t tags, size_t cap, uint32_t key);` -/
@[export_c lean_fs_map_get]
public unsafe def fsMapGet (keys : USize) (vals : USize) (tags : USize) (cap : USize)
    (key : U32) : USize :=
  Systems.Map.get keys vals tags cap key

/-- `1` if present, `0` otherwise.

C ABI: `uint32_t lean_fs_map_contains(size_t keys, size_t tags, size_t cap, uint32_t key);` -/
@[export_c lean_fs_map_contains]
public unsafe def fsMapContains (keys : USize) (tags : USize) (cap : USize) (key : U32) : U32 :=
  Systems.Map.contains keys tags cap key

/-- Erase by tombstone. `0` ok, `1` absent, `3` if `cap==0`.

C ABI: `uint32_t lean_fs_map_erase(size_t keys, size_t tags, size_t cap, uint32_t key);` -/
@[export_c lean_fs_map_erase]
public unsafe def fsMapErase (keys : USize) (tags : USize) (cap : USize) (key : U32) : U32 :=
  Systems.Map.erase keys tags cap key

/-- Occupied entry count (tombstones excluded).

C ABI: `size_t lean_fs_map_count(size_t tags, size_t cap);` -/
@[export_c lean_fs_map_count]
public unsafe def fsMapCount (tags : USize) (cap : USize) : USize :=
  Systems.Map.count tags cap

/-- Dual-buffer rehash / grow sink (clears `new_tags`, copies occupied entries).

C ABI: `uint32_t lean_fs_map_rehash(size_t old_keys, size_t old_vals, size_t old_tags, size_t old_cap,
  size_t new_keys, size_t new_vals, size_t new_tags, size_t new_cap);` -/
@[export_c lean_fs_map_rehash]
public unsafe def fsMapRehash (oldKeys : USize) (oldVals : USize) (oldTags : USize) (oldCap : USize)
    (newKeys : USize) (newVals : USize) (newTags : USize) (newCap : USize) : U32 :=
  Systems.Map.rehash oldKeys oldVals oldTags oldCap newKeys newVals newTags newCap

/-! ## BitVec / Set smoke exports

BitVec-shaped U64 ops and HashSet-shaped dual-buffer set — not full Init BitVec / HashSet.
-/

/-- Truncate `x` to low `w` bits (BitVec).

C ABI: `uint64_t lean_fs_bv_truncate(uint64_t x, uint64_t w);` -/
@[export_c lean_fs_bv_truncate]
public def fsBvTruncate (x : U64) (w : U64) : U64 :=
  Systems.BitVec.truncate x w

/-- Test bit `i` of `x` (`0`/`1` as `uint64_t`).

C ABI: `uint64_t lean_fs_bv_test_bit(uint64_t x, uint64_t i);` -/
@[export_c lean_fs_bv_test_bit]
public def fsBvTestBit (x : U64) (i : U64) : U64 :=
  Systems.BitVec.testBit x i

/-- Set bit `i` of `x`.

C ABI: `uint64_t lean_fs_bv_set_bit(uint64_t x, uint64_t i);` -/
@[export_c lean_fs_bv_set_bit]
public def fsBvSetBit (x : U64) (i : U64) : U64 :=
  Systems.BitVec.setBit x i

/-- Clear bit `i` of `x`.

C ABI: `uint64_t lean_fs_bv_clear_bit(uint64_t x, uint64_t i);` -/
@[export_c lean_fs_bv_clear_bit]
public def fsBvClearBit (x : U64) (i : U64) : U64 :=
  Systems.BitVec.clearBit x i

/-- Population count of low `w` bits of `x`.

C ABI: `uint64_t lean_fs_bv_popcount(uint64_t x, uint64_t w);` -/
@[export_c lean_fs_bv_popcount]
public unsafe def fsBvPopcount (x : U64) (w : U64) : U64 :=
  Systems.BitVec.popcount x w

/-- Concatenate high `wHi` bits of `hi` above low `wLo` bits of `lo`.

C ABI: `uint64_t lean_fs_bv_concat(uint64_t hi, uint64_t lo, uint64_t wHi, uint64_t wLo);` -/
@[export_c lean_fs_bv_concat]
public def fsBvConcat (hi : U64) (lo : U64) (wHi : U64) (wLo : U64) : U64 :=
  Systems.BitVec.concat hi lo wHi wLo

/-- MSB of low `w` bits (`0`/`1` as `uint64_t`).

C ABI: `uint64_t lean_fs_bv_get_msb(uint64_t x, uint64_t w);` -/
@[export_c lean_fs_bv_get_msb]
public def fsBvGetMsb (x : U64) (w : U64) : U64 :=
  Systems.BitVec.getMsb x w

/-- Rotate left within width `w`.

C ABI: `uint64_t lean_fs_bv_rotate_left(uint64_t x, uint64_t k, uint64_t w);` -/
@[export_c lean_fs_bv_rotate_left]
public unsafe def fsBvRotateLeft (x : U64) (k : U64) (w : U64) : U64 :=
  Systems.BitVec.rotateLeftW x k w

/-- Rotate right within width `w`.

C ABI: `uint64_t lean_fs_bv_rotate_right(uint64_t x, uint64_t k, uint64_t w);` -/
@[export_c lean_fs_bv_rotate_right]
public unsafe def fsBvRotateRight (x : U64) (k : U64) (w : U64) : U64 :=
  Systems.BitVec.rotateRightW x k w

/-- Sign-extend low `w` bits into full `uint64_t` (shaped; not Init BitVec).

C ABI: `uint64_t lean_fs_bv_sign_extend(uint64_t x, uint64_t w);` -/
@[export_c lean_fs_bv_sign_extend]
public def fsBvSignExtend (x : U64) (w : U64) : U64 :=
  Systems.BitVec.signExtend x w

/-- Extract `len` bits starting at `start` (LSB).

C ABI: `uint64_t lean_fs_bv_extract_lsb(uint64_t x, uint64_t start, uint64_t len);` -/
@[export_c lean_fs_bv_extract_lsb]
public def fsBvExtractLsb (x : U64) (start : U64) (len : U64) : U64 :=
  Systems.BitVec.extractLsb x start len

/-- Zero occupancy tags for a Set table of capacity `cap`.

C ABI: `uint32_t lean_fs_set_init(size_t tags, size_t cap);` -/
@[export_c lean_fs_set_init]
public unsafe def fsSetInit (tags : USize) (cap : USize) : U32 :=
  Systems.Set.init tags cap

/-- Insert `key` into dual-buffer open-addressing set.

C ABI: `uint32_t lean_fs_set_insert(size_t keys, size_t tags, size_t cap, uint32_t key);`
→ `0` ok, `3` full/`cap==0`. -/
@[export_c lean_fs_set_insert]
public unsafe def fsSetInsert (keys : USize) (tags : USize) (cap : USize) (key : U32) : U32 :=
  Systems.Set.insert keys tags cap key

/-- `1` if present, `0` otherwise.

C ABI: `uint32_t lean_fs_set_contains(size_t keys, size_t tags, size_t cap, uint32_t key);` -/
@[export_c lean_fs_set_contains]
public unsafe def fsSetContains (keys : USize) (tags : USize) (cap : USize) (key : U32) : U32 :=
  Systems.Set.contains keys tags cap key

/-- Erase by tombstone. `0` ok, `1` absent, `3` if `cap==0`.

C ABI: `uint32_t lean_fs_set_erase(size_t keys, size_t tags, size_t cap, uint32_t key);` -/
@[export_c lean_fs_set_erase]
public unsafe def fsSetErase (keys : USize) (tags : USize) (cap : USize) (key : U32) : U32 :=
  Systems.Set.erase keys tags cap key

/-- Occupied entry count (tombstones excluded).

C ABI: `size_t lean_fs_set_count(size_t tags, size_t cap);` -/
@[export_c lean_fs_set_count]
public unsafe def fsSetCount (tags : USize) (cap : USize) : USize :=
  Systems.Set.count tags cap

/-- Dual-buffer rehash / grow sink (clears `new_tags`, copies occupied keys).

C ABI: `uint32_t lean_fs_set_rehash(size_t old_keys, size_t old_tags, size_t old_cap,
  size_t new_keys, size_t new_tags, size_t new_cap);` -/
@[export_c lean_fs_set_rehash]
public unsafe def fsSetRehash (oldKeys : USize) (oldTags : USize) (oldCap : USize)
    (newKeys : USize) (newTags : USize) (newCap : USize) : U32 :=
  Systems.Set.rehash oldKeys oldTags oldCap newKeys newTags newCap

/-! ## Queue ring smoke exports

Fixed-cap ring over caller-owned U32 slots + head/count dual params — not a managed queue.
-/

/-- `1` if empty (`n == 0`), else `0`.

C ABI: `uint32_t lean_fs_queue_is_empty(size_t n);` -/
@[export_c lean_fs_queue_is_empty]
public def fsQueueIsEmpty (n : USize) : U32 :=
  Systems.Queue.isEmpty n

/-- `1` if full (`n == cap` or `cap == 0`), else `0`.

C ABI: `uint32_t lean_fs_queue_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_queue_is_full]
public def fsQueueIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Queue.isFull cap n

/-- Advance head after pop: `(head + 1) % cap`.

C ABI: `size_t lean_fs_queue_next_head(size_t cap, size_t head);` -/
@[export_c lean_fs_queue_next_head]
public unsafe def fsQueueNextHead (cap : USize) (head : USize) : USize :=
  Systems.Queue.nextHead cap head

/-- Push `val` at tail. `0` ok, `3` full/`cap==0`. Caller increments `n` on success.

C ABI: `uint32_t lean_fs_queue_push(size_t slots, size_t cap, size_t head, size_t n, uint32_t val);` -/
@[export_c lean_fs_queue_push]
public unsafe def fsQueuePush (slots : USize) (cap : USize) (head : USize) (n : USize)
    (val : U32) : U32 :=
  Systems.Queue.push slots cap head n val

/-- Pop front as `size_t`, or `(size_t)-1` if empty. Caller advances head / decrements `n`.

C ABI: `size_t lean_fs_queue_pop(size_t slots, size_t cap, size_t head, size_t n);` -/
@[export_c lean_fs_queue_pop]
public unsafe def fsQueuePop (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  Systems.Queue.pop slots cap head n

/-- Peek front without remove. Same return shape as pop.

C ABI: `size_t lean_fs_queue_peek(size_t slots, size_t cap, size_t head, size_t n);` -/
@[export_c lean_fs_queue_peek]
public unsafe def fsQueuePeek (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  Systems.Queue.peek slots cap head n

/-! ## Vector / Sort / Crc smoke exports

Fixed-cap vector, insertion sort, CRC-32-shaped fold — shaped freestanding ports, not Init.
-/

/-- Pass-through length (caller-owned `n`).

C ABI: `size_t lean_fs_vec_len(size_t n);` -/
@[export_c lean_fs_vec_len]
public def fsVecLen (n : USize) : USize :=
  Systems.Vector.len n

/-- Pass-through capacity (caller-owned `cap`).

C ABI: `size_t lean_fs_vec_cap(size_t cap);` -/
@[export_c lean_fs_vec_cap]
public def fsVecCap (cap : USize) : USize :=
  Systems.Vector.capacity cap

/-- `1` if empty (`n == 0`), else `0`.

C ABI: `uint32_t lean_fs_vec_is_empty(size_t n);` -/
@[export_c lean_fs_vec_is_empty]
public def fsVecIsEmpty (n : USize) : U32 :=
  Systems.Vector.isEmpty n

/-- `1` if full (`n == cap` or `cap == 0`), else `0`.

C ABI: `uint32_t lean_fs_vec_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_vec_is_full]
public def fsVecIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Vector.isFull cap n

/-- Push `val` at index `n`. `0` ok, `3` full/`cap==0`. Caller increments `n` on success.

C ABI: `uint32_t lean_fs_vec_push(size_t slots, size_t cap, size_t n, uint32_t val);` -/
@[export_c lean_fs_vec_push]
public unsafe def fsVecPush (slots : USize) (cap : USize) (n : USize) (val : U32) : U32 :=
  Systems.Vector.push slots cap n val

/-- Pop last as `size_t`, or `(size_t)-1` if empty. Caller decrements `n` on success.

C ABI: `size_t lean_fs_vec_pop(size_t slots, size_t n);` -/
@[export_c lean_fs_vec_pop]
public unsafe def fsVecPop (slots : USize) (n : USize) : USize :=
  Systems.Vector.pop slots n

/-- Get index `i` as `size_t`, or `(size_t)-1` if `i ≥ n`.

C ABI: `size_t lean_fs_vec_get(size_t slots, size_t n, size_t i);` -/
@[export_c lean_fs_vec_get]
public unsafe def fsVecGet (slots : USize) (n : USize) (i : USize) : USize :=
  Systems.Vector.get slots n i

/-- Set index `i`. `0` ok, `3` if `i ≥ n`.

C ABI: `uint32_t lean_fs_vec_set(size_t slots, size_t n, size_t i, uint32_t val);` -/
@[export_c lean_fs_vec_set]
public unsafe def fsVecSet (slots : USize) (n : USize) (i : USize) (val : U32) : U32 :=
  Systems.Vector.set slots n i val

/-- Occupancy clear (returns `0`; caller sets `n := 0`).

C ABI: `uint32_t lean_fs_vec_clear(size_t slots, size_t cap);` -/
@[export_c lean_fs_vec_clear]
public def fsVecClear (slots : USize) (cap : USize) : U32 :=
  Systems.Vector.clear slots cap

/-- In-place ascending insertion sort of `n` U32 words.

C ABI: `uint32_t lean_fs_sort_u32(size_t slots, size_t n);` -/
@[export_c lean_fs_sort_u32]
public unsafe def fsSortU32 (slots : USize) (n : USize) : U32 :=
  Systems.Sort.sortU32 slots n

/-- `1` if non-decreasing unsigned order, else `0`.

C ABI: `uint32_t lean_fs_sort_is_sorted_u32(size_t slots, size_t n);` -/
@[export_c lean_fs_sort_is_sorted_u32]
public unsafe def fsSortIsSortedU32 (slots : USize) (n : USize) : U32 :=
  Systems.Sort.isSortedU32 slots n

/-- CRC-32 (IEEE reflected) over `n` bytes at `addr` (non-crypto).

C ABI: `uint32_t lean_fs_crc32(size_t addr, size_t n);` -/
@[export_c lean_fs_crc32]
public unsafe def fsCrc32 (addr : USize) (n : USize) : U32 :=
  Systems.Crc.crc32 addr n

/-! ## String / BinarySearch / Deque smoke exports

Byte-string view, sorted U32 binary search, fixed-cap double-ended ring — shaped ports.
-/

/-- Pass-through length (caller-owned `n`).

C ABI: `size_t lean_fs_str_len(size_t n);` -/
@[export_c lean_fs_str_len]
public def fsStrLen (n : USize) : USize :=
  Systems.String.len n

/-- `1` if empty (`n == 0`), else `0`.

C ABI: `uint32_t lean_fs_str_is_empty(size_t n);` -/
@[export_c lean_fs_str_is_empty]
public def fsStrIsEmpty (n : USize) : U32 :=
  Systems.String.isEmpty n

/-- Bounds-safe byte load as `size_t`, or `(size_t)-1` if `i ≥ n`.

C ABI: `size_t lean_fs_str_get_u8(size_t addr, size_t n, size_t i);` -/
@[export_c lean_fs_str_get_u8]
public unsafe def fsStrGetU8 (addr : USize) (n : USize) (i : USize) : USize :=
  Systems.String.getU8 addr n i

/-- Full-range equality: `0` equal, `1` differ.

C ABI: `uint32_t lean_fs_str_eq(size_t a, size_t b, size_t n);` -/
@[export_c lean_fs_str_eq]
public unsafe def fsStrEq (a : USize) (b : USize) (n : USize) : U32 :=
  Systems.String.eq a b n

/-- Prefix equality of length `k`: `0` match, `1` differ / out of range.

C ABI: `uint32_t lean_fs_str_prefix_eq(size_t a, size_t na, size_t b, size_t nb, size_t k);` -/
@[export_c lean_fs_str_prefix_eq]
public unsafe def fsStrPrefixEq (a : USize) (na : USize) (b : USize) (nb : USize) (k : USize) : U32 :=
  Systems.String.prefixEq a na b nb k

/-- FNV-1a hash of `n` bytes at `addr`.

C ABI: `uint32_t lean_fs_str_hash32(size_t addr, size_t n);` -/
@[export_c lean_fs_str_hash32]
public unsafe def fsStrHash32 (addr : USize) (n : USize) : U32 :=
  Systems.String.hash32 addr n

/-- Subview bounds: `0` ok, `3` out of range.

C ABI: `uint32_t lean_fs_str_view_ok(size_t n, size_t off, size_t len);` -/
@[export_c lean_fs_str_view_ok]
public unsafe def fsStrViewOk (n : USize) (off : USize) (len : USize) : U32 :=
  Systems.String.viewOk n off len

/-- Subview base address, or `(size_t)-1` if out of range.

C ABI: `size_t lean_fs_str_view_addr(size_t addr, size_t n, size_t off, size_t len);` -/
@[export_c lean_fs_str_view_addr]
public unsafe def fsStrViewAddr (addr : USize) (n : USize) (off : USize) (len : USize) : USize :=
  Systems.String.viewAddr addr n off len

/-- Subview length when in bounds, else `0`.

C ABI: `size_t lean_fs_str_view_len(size_t n, size_t off, size_t len);` -/
@[export_c lean_fs_str_view_len]
public unsafe def fsStrViewLen (n : USize) (off : USize) (len : USize) : USize :=
  Systems.String.viewLen n off len

/-- Binary search for `key` in sorted U32 prefix. Index or `(size_t)-1`.

C ABI: `size_t lean_fs_bsearch_u32(size_t slots, size_t n, uint32_t key);` -/
@[export_c lean_fs_bsearch_u32]
public unsafe def fsBsearchU32 (slots : USize) (n : USize) (key : U32) : USize :=
  Systems.BinarySearch.findU32 slots n key

/-- `1` if `key` present in sorted prefix, else `0`.

C ABI: `uint32_t lean_fs_bsearch_contains_u32(size_t slots, size_t n, uint32_t key);` -/
@[export_c lean_fs_bsearch_contains_u32]
public unsafe def fsBsearchContainsU32 (slots : USize) (n : USize) (key : U32) : U32 :=
  Systems.BinarySearch.containsU32 slots n key

/-- Pass-through occupancy count.

C ABI: `size_t lean_fs_deque_count(size_t n);` -/
@[export_c lean_fs_deque_count]
public def fsDequeCount (n : USize) : USize :=
  Systems.Deque.count n

/-- `1` if empty (`n == 0`), else `0`.

C ABI: `uint32_t lean_fs_deque_is_empty(size_t n);` -/
@[export_c lean_fs_deque_is_empty]
public def fsDequeIsEmpty (n : USize) : U32 :=
  Systems.Deque.isEmpty n

/-- `1` if full (`n == cap` or `cap == 0`), else `0`.

C ABI: `uint32_t lean_fs_deque_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_deque_is_full]
public def fsDequeIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Deque.isFull cap n

/-- Advance head after popFront: `(head + 1) % cap`.

C ABI: `size_t lean_fs_deque_next_head(size_t cap, size_t head);` -/
@[export_c lean_fs_deque_next_head]
public unsafe def fsDequeNextHead (cap : USize) (head : USize) : USize :=
  Systems.Deque.nextHead cap head

/-- Previous head for pushFront.

C ABI: `size_t lean_fs_deque_prev_head(size_t cap, size_t head);` -/
@[export_c lean_fs_deque_prev_head]
public unsafe def fsDequePrevHead (cap : USize) (head : USize) : USize :=
  Systems.Deque.prevHead cap head

/-- Push at back. `0` ok, `3` full/`cap==0`. Caller increments `n` on success.

C ABI: `uint32_t lean_fs_deque_push_back(size_t slots, size_t cap, size_t head, size_t n, uint32_t val);` -/
@[export_c lean_fs_deque_push_back]
public unsafe def fsDequePushBack (slots : USize) (cap : USize) (head : USize) (n : USize)
    (val : U32) : U32 :=
  Systems.Deque.pushBack slots cap head n val

/-- Push at front. `0` ok, `3` full/`cap==0`. Caller uses `prevHead` + `n+1`.

C ABI: `uint32_t lean_fs_deque_push_front(size_t slots, size_t cap, size_t head, size_t n, uint32_t val);` -/
@[export_c lean_fs_deque_push_front]
public unsafe def fsDequePushFront (slots : USize) (cap : USize) (head : USize) (n : USize)
    (val : U32) : U32 :=
  Systems.Deque.pushFront slots cap head n val

/-- Pop front as `size_t`, or `(size_t)-1` if empty. Caller advances head / decrements `n`.

C ABI: `size_t lean_fs_deque_pop_front(size_t slots, size_t cap, size_t head, size_t n);` -/
@[export_c lean_fs_deque_pop_front]
public unsafe def fsDequePopFront (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  Systems.Deque.popFront slots cap head n

/-- Peek front without remove.

C ABI: `size_t lean_fs_deque_peek_front(size_t slots, size_t cap, size_t head, size_t n);` -/
@[export_c lean_fs_deque_peek_front]
public unsafe def fsDequePeekFront (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  Systems.Deque.peekFront slots cap head n

/-- Pop back as `size_t`, or `(size_t)-1` if empty. Caller decrements `n`.

C ABI: `size_t lean_fs_deque_pop_back(size_t slots, size_t cap, size_t head, size_t n);` -/
@[export_c lean_fs_deque_pop_back]
public unsafe def fsDequePopBack (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  Systems.Deque.popBack slots cap head n

/-- Peek back without remove.

C ABI: `size_t lean_fs_deque_peek_back(size_t slots, size_t cap, size_t head, size_t n);` -/
@[export_c lean_fs_deque_peek_back]
public unsafe def fsDequePeekBack (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  Systems.Deque.peekBack slots cap head n

/-! ## Stack / Ascii / MemRegion smoke exports

Fixed-cap stack, ASCII ctype-shaped helpers, dual base/len region view — shaped ports.
-/

/-- Pass-through occupancy count.

C ABI: `size_t lean_fs_stack_count(size_t n);` -/
@[export_c lean_fs_stack_count]
public def fsStackCount (n : USize) : USize :=
  Systems.Stack.count n

/-- Pass-through capacity.

C ABI: `size_t lean_fs_stack_cap(size_t cap);` -/
@[export_c lean_fs_stack_cap]
public def fsStackCap (cap : USize) : USize :=
  Systems.Stack.cap cap

/-- `1` if empty (`n == 0`), else `0`.

C ABI: `uint32_t lean_fs_stack_is_empty(size_t n);` -/
@[export_c lean_fs_stack_is_empty]
public def fsStackIsEmpty (n : USize) : U32 :=
  Systems.Stack.isEmpty n

/-- `1` if full (`n == cap` or `cap == 0`), else `0`.

C ABI: `uint32_t lean_fs_stack_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_stack_is_full]
public def fsStackIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Stack.isFull cap n

/-- Push `val` at top. `0` ok, `3` full/`cap==0`. Caller increments `n` on success.

C ABI: `uint32_t lean_fs_stack_push(size_t slots, size_t cap, size_t n, uint32_t val);` -/
@[export_c lean_fs_stack_push]
public unsafe def fsStackPush (slots : USize) (cap : USize) (n : USize) (val : U32) : U32 :=
  Systems.Stack.push slots cap n val

/-- Pop top as `size_t`, or `(size_t)-1` if empty. Caller decrements `n` on success.

C ABI: `size_t lean_fs_stack_pop(size_t slots, size_t n);` -/
@[export_c lean_fs_stack_pop]
public unsafe def fsStackPop (slots : USize) (n : USize) : USize :=
  Systems.Stack.pop slots n

/-- Peek top without remove. Same return shape as pop.

C ABI: `size_t lean_fs_stack_peek(size_t slots, size_t n);` -/
@[export_c lean_fs_stack_peek]
public unsafe def fsStackPeek (slots : USize) (n : USize) : USize :=
  Systems.Stack.peek slots n

/-- ASCII digit class (`1`/`0`).

C ABI: `uint32_t lean_fs_ascii_is_digit(uint32_t c);` -/
@[export_c lean_fs_ascii_is_digit]
public def fsAsciiIsDigit (c : U32) : U32 :=
  Systems.Ascii.isDigit c

/-- ASCII alpha class (`1`/`0`).

C ABI: `uint32_t lean_fs_ascii_is_alpha(uint32_t c);` -/
@[export_c lean_fs_ascii_is_alpha]
public def fsAsciiIsAlpha (c : U32) : U32 :=
  Systems.Ascii.isAlpha c

/-- ASCII alnum class (`1`/`0`).

C ABI: `uint32_t lean_fs_ascii_is_alnum(uint32_t c);` -/
@[export_c lean_fs_ascii_is_alnum]
public def fsAsciiIsAlnum (c : U32) : U32 :=
  Systems.Ascii.isAlnum c

/-- ASCII space class (`1`/`0`).

C ABI: `uint32_t lean_fs_ascii_is_space(uint32_t c);` -/
@[export_c lean_fs_ascii_is_space]
public def fsAsciiIsSpace (c : U32) : U32 :=
  Systems.Ascii.isSpace c

/-- ASCII hex class (`1`/`0`).

C ABI: `uint32_t lean_fs_ascii_is_hex(uint32_t c);` -/
@[export_c lean_fs_ascii_is_hex]
public def fsAsciiIsHex (c : U32) : U32 :=
  Systems.Ascii.isHex c

/-- ASCII to-lower (identity outside `'A'..'Z'`).

C ABI: `uint32_t lean_fs_ascii_to_lower(uint32_t c);` -/
@[export_c lean_fs_ascii_to_lower]
public def fsAsciiToLower (c : U32) : U32 :=
  Systems.Ascii.toLower c

/-- ASCII to-upper (identity outside `'a'..'z'`).

C ABI: `uint32_t lean_fs_ascii_to_upper(uint32_t c);` -/
@[export_c lean_fs_ascii_to_upper]
public def fsAsciiToUpper (c : U32) : U32 :=
  Systems.Ascii.toUpper c

/-- `1` if byte offset `off` is inside region length `n`.

C ABI: `uint32_t lean_fs_region_contains(size_t n, size_t off);` -/
@[export_c lean_fs_region_contains]
public def fsRegionContains (n : USize) (off : USize) : U32 :=
  Systems.MemRegion.contains n off

/-- Subregion bounds: `0` ok, `3` out of range.

C ABI: `uint32_t lean_fs_region_sub_ok(size_t n, size_t off, size_t sub_len);` -/
@[export_c lean_fs_region_sub_ok]
public unsafe def fsRegionSubOk (n : USize) (off : USize) (subLen : USize) : U32 :=
  Systems.MemRegion.subregionOk n off subLen

/-- Subregion base address, or `(size_t)-1` if out of range.

C ABI: `size_t lean_fs_region_sub_addr(size_t base, size_t n, size_t off, size_t sub_len);` -/
@[export_c lean_fs_region_sub_addr]
public unsafe def fsRegionSubAddr (base : USize) (n : USize) (off : USize) (subLen : USize) : USize :=
  Systems.MemRegion.subregionAddr base n off subLen

/-- Subregion length when in bounds, else `0`.

C ABI: `size_t lean_fs_region_sub_len(size_t n, size_t off, size_t sub_len);` -/
@[export_c lean_fs_region_sub_len]
public unsafe def fsRegionSubLen (n : USize) (off : USize) (subLen : USize) : USize :=
  Systems.MemRegion.subregionLen n off subLen

/-- Bounds-safe byte load as `size_t`, or `(size_t)-1` if out of range.

C ABI: `size_t lean_fs_region_load_u8(size_t base, size_t n, size_t off);` -/
@[export_c lean_fs_region_load_u8]
public unsafe def fsRegionLoadU8 (base : USize) (n : USize) (off : USize) : USize :=
  Systems.MemRegion.loadU8 base n off

/-- Bounds-safe byte store: `0` ok, `3` bounds.

C ABI: `uint32_t lean_fs_region_store_u8(size_t base, size_t n, size_t off, uint8_t v);` -/
@[export_c lean_fs_region_store_u8]
public unsafe def fsRegionStoreU8 (base : USize) (n : USize) (off : USize) (v : U8) : U32 :=
  Systems.MemRegion.storeU8 base n off v

/-- Bounds-safe U32 load as `size_t`, or `(size_t)-1` if `off+4` exceeds `n`.

C ABI: `size_t lean_fs_region_load_u32(size_t base, size_t n, size_t off);` -/
@[export_c lean_fs_region_load_u32]
public unsafe def fsRegionLoadU32 (base : USize) (n : USize) (off : USize) : USize :=
  Systems.MemRegion.loadU32 base n off

/-- Bounds-safe U32 store: `0` ok, `3` bounds.

C ABI: `uint32_t lean_fs_region_store_u32(size_t base, size_t n, size_t off, uint32_t v);` -/
@[export_c lean_fs_region_store_u32]
public unsafe def fsRegionStoreU32 (base : USize) (n : USize) (off : USize) (v : U32) : U32 :=
  Systems.MemRegion.storeU32 base n off v

/-- Half-open range overlap: `1` if ranges intersect, else `0`.

C ABI: `uint32_t lean_fs_region_overlaps(size_t a, size_t na, size_t b, size_t nb);` -/
@[export_c lean_fs_region_overlaps]
public unsafe def fsRegionOverlaps (a : USize) (na : USize) (b : USize) (nb : USize) : U32 :=
  Systems.MemRegion.overlaps a na b nb

/-! ## BitSet / Parse / RingBuf smoke exports

64-bit bitset word, decimal byte-view parse, fixed-cap U8 ring — shaped ports.
-/

/-- Empty bitset word (`0`).

Takes dummy `U32` so freestanding EmitC treats this as a function (nullary
`@[export_c]` would forward-declare a global).

C ABI: `uint64_t lean_fs_bitset_empty(uint32_t unused);` — pass `0`. -/
@[export_c lean_fs_bitset_empty]
public def fsBitsetEmpty (_unused : U32) : U64 :=
  Systems.BitSet.empty

/-- `1` if word is empty, else `0`.

C ABI: `uint32_t lean_fs_bitset_is_empty(uint64_t w);` -/
@[export_c lean_fs_bitset_is_empty]
public def fsBitsetIsEmpty (w : U64) : U32 :=
  Systems.BitSet.isEmpty w

/-- Test bit `i` (`0`/`1` as `uint32_t`; index masked to 6 bits).

C ABI: `uint32_t lean_fs_bitset_test(uint64_t w, uint64_t i);` -/
@[export_c lean_fs_bitset_test]
public def fsBitsetTest (w : U64) (i : U64) : U32 :=
  Systems.BitSet.test w i

/-- Set bit `i`.

C ABI: `uint64_t lean_fs_bitset_set(uint64_t w, uint64_t i);` -/
@[export_c lean_fs_bitset_set]
public def fsBitsetSet (w : U64) (i : U64) : U64 :=
  Systems.BitSet.set w i

/-- Clear bit `i`.

C ABI: `uint64_t lean_fs_bitset_clear(uint64_t w, uint64_t i);` -/
@[export_c lean_fs_bitset_clear]
public def fsBitsetClear (w : U64) (i : U64) : U64 :=
  Systems.BitSet.clear w i

/-- Population count of the 64-bit word.

C ABI: `uint64_t lean_fs_bitset_count(uint64_t w);` -/
@[export_c lean_fs_bitset_count]
public unsafe def fsBitsetCount (w : U64) : U64 :=
  Systems.BitSet.count w

/-- Bitwise and of two bitset words.

C ABI: `uint64_t lean_fs_bitset_and(uint64_t a, uint64_t b);` -/
@[export_c lean_fs_bitset_and]
public def fsBitsetAnd (a : U64) (b : U64) : U64 :=
  Systems.BitSet.land a b

/-- Bitwise or of two bitset words.

C ABI: `uint64_t lean_fs_bitset_or(uint64_t a, uint64_t b);` -/
@[export_c lean_fs_bitset_or]
public def fsBitsetOr (a : U64) (b : U64) : U64 :=
  Systems.BitSet.lor a b

/-- Bitwise xor of two bitset words.

C ABI: `uint64_t lean_fs_bitset_xor(uint64_t a, uint64_t b);` -/
@[export_c lean_fs_bitset_xor]
public def fsBitsetXor (a : U64) (b : U64) : U64 :=
  Systems.BitSet.lxor a b

/-- Decimal `U32` parse status: `0` ok, `1` empty/non-digit, `3` overflow.

C ABI: `uint32_t lean_fs_parse_u32_status(size_t addr, size_t n);` -/
@[export_c lean_fs_parse_u32_status]
public unsafe def fsParseU32Status (addr : USize) (n : USize) : U32 :=
  Systems.Parse.parseU32Status addr n

/-- Decimal `U32` parse as `size_t`, or `(size_t)-1` on failure.

C ABI: `size_t lean_fs_parse_u32(size_t addr, size_t n);` -/
@[export_c lean_fs_parse_u32]
public unsafe def fsParseU32 (addr : USize) (n : USize) : USize :=
  Systems.Parse.parseU32 addr n

/-- Decimal `U64` parse status: `0` ok, `1` empty/non-digit, `3` overflow.

C ABI: `uint32_t lean_fs_parse_u64_status(size_t addr, size_t n);` -/
@[export_c lean_fs_parse_u64_status]
public unsafe def fsParseU64Status (addr : USize) (n : USize) : U32 :=
  Systems.Parse.parseU64Status addr n

/-- Decimal `U64` parse, or `(uint64_t)-1` on failure.

C ABI: `uint64_t lean_fs_parse_u64(size_t addr, size_t n);` -/
@[export_c lean_fs_parse_u64]
public unsafe def fsParseU64 (addr : USize) (n : USize) : U64 :=
  Systems.Parse.parseU64 addr n

/-- Pass-through occupancy count.

C ABI: `size_t lean_fs_ring_count(size_t n);` -/
@[export_c lean_fs_ring_count]
public def fsRingCount (n : USize) : USize :=
  Systems.RingBuf.count n

/-- `1` if empty (`n == 0`), else `0`.

C ABI: `uint32_t lean_fs_ring_is_empty(size_t n);` -/
@[export_c lean_fs_ring_is_empty]
public def fsRingIsEmpty (n : USize) : U32 :=
  Systems.RingBuf.isEmpty n

/-- `1` if full (`n == cap` or `cap == 0`), else `0`.

C ABI: `uint32_t lean_fs_ring_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_ring_is_full]
public def fsRingIsFull (cap : USize) (n : USize) : U32 :=
  Systems.RingBuf.isFull cap n

/-- Advance head after pop: `(head + 1) % cap`.

C ABI: `size_t lean_fs_ring_next_head(size_t cap, size_t head);` -/
@[export_c lean_fs_ring_next_head]
public unsafe def fsRingNextHead (cap : USize) (head : USize) : USize :=
  Systems.RingBuf.nextHead cap head

/-- Push `val` at tail. `0` ok, `3` full/`cap==0`. Caller increments `n` on success.

C ABI: `uint32_t lean_fs_ring_push(size_t slots, size_t cap, size_t head, size_t n, uint8_t val);` -/
@[export_c lean_fs_ring_push]
public unsafe def fsRingPush (slots : USize) (cap : USize) (head : USize) (n : USize)
    (val : U8) : U32 :=
  Systems.RingBuf.push slots cap head n val

/-- Pop front as `size_t` (`0..255`), or `(size_t)-1` if empty. Caller advances head / decrements `n`.

C ABI: `size_t lean_fs_ring_pop(size_t slots, size_t cap, size_t head, size_t n);` -/
@[export_c lean_fs_ring_pop]
public unsafe def fsRingPop (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  Systems.RingBuf.pop slots cap head n

/-- Peek front without remove. Same return shape as pop.

C ABI: `size_t lean_fs_ring_peek(size_t slots, size_t cap, size_t head, size_t n);` -/
@[export_c lean_fs_ring_peek]
public unsafe def fsRingPeek (slots : USize) (cap : USize) (head : USize) (n : USize) : USize :=
  Systems.RingBuf.peek slots cap head n

/-! ## Fmt / List / Path smoke exports

Decimal format, dense U32 list, POSIX-ish path views — shaped ports.
-/

/-- Decimal digit width of `v` (`1` for zero).

C ABI: `size_t lean_fs_fmt_digit_count_u32(uint32_t v);` -/
@[export_c lean_fs_fmt_digit_count_u32]
public unsafe def fsFmtDigitCountU32 (v : U32) : USize :=
  Systems.Fmt.digitCountU32 v

/-- Decimal `U32` format status: `0` ok, `3` buffer too small.

C ABI: `uint32_t lean_fs_fmt_u32_status(size_t addr, size_t cap, uint32_t v);` -/
@[export_c lean_fs_fmt_u32_status]
public unsafe def fsFmtU32Status (addr : USize) (cap : USize) (v : U32) : U32 :=
  Systems.Fmt.fmtU32Status addr cap v

/-- Decimal `U32` format: write length, or `(size_t)-1` if too small.

C ABI: `size_t lean_fs_fmt_u32(size_t addr, size_t cap, uint32_t v);` -/
@[export_c lean_fs_fmt_u32]
public unsafe def fsFmtU32 (addr : USize) (cap : USize) (v : U32) : USize :=
  Systems.Fmt.fmtU32 addr cap v

/-- Decimal `U64` format status: `0` ok, `3` buffer too small.

C ABI: `uint32_t lean_fs_fmt_u64_status(size_t addr, size_t cap, uint64_t v);` -/
@[export_c lean_fs_fmt_u64_status]
public unsafe def fsFmtU64Status (addr : USize) (cap : USize) (v : U64) : U32 :=
  Systems.Fmt.fmtU64Status addr cap v

/-- Decimal `U64` format: write length, or `(size_t)-1` if too small.

C ABI: `size_t lean_fs_fmt_u64(size_t addr, size_t cap, uint64_t v);` -/
@[export_c lean_fs_fmt_u64]
public unsafe def fsFmtU64 (addr : USize) (cap : USize) (v : U64) : USize :=
  Systems.Fmt.fmtU64 addr cap v

/-- Pass-through length (caller-owned `n`).

C ABI: `size_t lean_fs_list_len(size_t n);` -/
@[export_c lean_fs_list_len]
public def fsListLen (n : USize) : USize :=
  Systems.List.len n

/-- Pass-through capacity (caller-owned `cap`).

C ABI: `size_t lean_fs_list_cap(size_t cap);` -/
@[export_c lean_fs_list_cap]
public def fsListCap (cap : USize) : USize :=
  Systems.List.capacity cap

/-- `1` if empty (`n == 0`), else `0`.

C ABI: `uint32_t lean_fs_list_is_empty(size_t n);` -/
@[export_c lean_fs_list_is_empty]
public def fsListIsEmpty (n : USize) : U32 :=
  Systems.List.isEmpty n

/-- `1` if full (`n == cap` or `cap == 0`), else `0`.

C ABI: `uint32_t lean_fs_list_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_list_is_full]
public def fsListIsFull (cap : USize) (n : USize) : U32 :=
  Systems.List.isFull cap n

/-- Push `val` at index `n`. `0` ok, `3` full/`cap==0`. Caller increments `n` on success.

C ABI: `uint32_t lean_fs_list_push(size_t slots, size_t cap, size_t n, uint32_t val);` -/
@[export_c lean_fs_list_push]
public unsafe def fsListPush (slots : USize) (cap : USize) (n : USize) (val : U32) : U32 :=
  Systems.List.push slots cap n val

/-- Pop last as `size_t`, or `(size_t)-1` if empty. Caller decrements `n` on success.

C ABI: `size_t lean_fs_list_pop(size_t slots, size_t n);` -/
@[export_c lean_fs_list_pop]
public unsafe def fsListPop (slots : USize) (n : USize) : USize :=
  Systems.List.pop slots n

/-- Get index `i` as `size_t`, or `(size_t)-1` if `i ≥ n`.

C ABI: `size_t lean_fs_list_get(size_t slots, size_t n, size_t i);` -/
@[export_c lean_fs_list_get]
public unsafe def fsListGet (slots : USize) (n : USize) (i : USize) : USize :=
  Systems.List.get slots n i

/-- Set index `i`. `0` ok, `3` if `i ≥ n`.

C ABI: `uint32_t lean_fs_list_set(size_t slots, size_t n, size_t i, uint32_t val);` -/
@[export_c lean_fs_list_set]
public unsafe def fsListSet (slots : USize) (n : USize) (i : USize) (val : U32) : U32 :=
  Systems.List.set slots n i val

/-- Occupancy clear (returns `0`; caller sets `n := 0`).

C ABI: `uint32_t lean_fs_list_clear(size_t slots, size_t cap);` -/
@[export_c lean_fs_list_clear]
public def fsListClear (slots : USize) (cap : USize) : U32 :=
  Systems.List.clear slots cap

/-- `1` if path is absolute (leading `/`), else `0`.

C ABI: `uint32_t lean_fs_path_is_abs(size_t addr, size_t n);` -/
@[export_c lean_fs_path_is_abs]
public unsafe def fsPathIsAbs (addr : USize) (n : USize) : U32 :=
  Systems.Path.isAbs addr n

/-- `1` if non-empty path ends with `/`, else `0`.

C ABI: `uint32_t lean_fs_path_has_trailing_slash(size_t addr, size_t n);` -/
@[export_c lean_fs_path_has_trailing_slash]
public unsafe def fsPathHasTrailingSlash (addr : USize) (n : USize) : U32 :=
  Systems.Path.hasTrailingSlash addr n

/-- Offset of last path component (0 if no `/`).

C ABI: `size_t lean_fs_path_basename_off(size_t addr, size_t n);` -/
@[export_c lean_fs_path_basename_off]
public unsafe def fsPathBasenameOff (addr : USize) (n : USize) : USize :=
  Systems.Path.basenameOff addr n

/-- Length of last path component.

C ABI: `size_t lean_fs_path_basename_len(size_t addr, size_t n);` -/
@[export_c lean_fs_path_basename_len]
public unsafe def fsPathBasenameLen (addr : USize) (n : USize) : USize :=
  Systems.Path.basenameLen addr n

/-- Bytes needed to join two path views (insert `/` when needed).

C ABI: `size_t lean_fs_path_join_need(size_t na, uint32_t a_trail, size_t nb);` -/
@[export_c lean_fs_path_join_need]
public unsafe def fsPathJoinNeed (na : USize) (aTrail : U32) (nb : USize) : USize :=
  Systems.Path.joinNeed na aTrail nb

/-- Capacity check for join: `0` ok, `3` if `cap` too small.

C ABI: `uint32_t lean_fs_path_join_ok(size_t cap, size_t na, uint32_t a_trail, size_t nb);` -/
@[export_c lean_fs_path_join_ok]
public unsafe def fsPathJoinOk (cap : USize) (na : USize) (aTrail : U32) (nb : USize) : U32 :=
  Systems.Path.joinOk cap na aTrail nb

/-! ## Hex / Utf8 / Tree smoke exports

ASCII hex encode/decode, UTF-8 scan/validate, fixed-cap U32 min-heap — shaped ports.
-/

/-- Fixed-width hex of `U8` (`2` digits): write length, or `(size_t)-1` if too small.

C ABI: `size_t lean_fs_hex_enc_u8(size_t addr, size_t cap, uint8_t v);` -/
@[export_c lean_fs_hex_enc_u8]
public unsafe def fsHexEncU8 (addr : USize) (cap : USize) (v : U8) : USize :=
  Systems.Hex.encU8 addr cap v

/-- Status of fixed-width `U8` hex encode: `0` ok, `3` buffer too small.

C ABI: `uint32_t lean_fs_hex_enc_u8_status(size_t addr, size_t cap, uint8_t v);` -/
@[export_c lean_fs_hex_enc_u8_status]
public unsafe def fsHexEncU8Status (addr : USize) (cap : USize) (v : U8) : U32 :=
  Systems.Hex.encU8Status addr cap v

/-- Fixed-width hex of `U32` (`8` digits): write length, or `(size_t)-1` if too small.

C ABI: `size_t lean_fs_hex_enc_u32(size_t addr, size_t cap, uint32_t v);` -/
@[export_c lean_fs_hex_enc_u32]
public unsafe def fsHexEncU32 (addr : USize) (cap : USize) (v : U32) : USize :=
  Systems.Hex.encU32 addr cap v

/-- Status of fixed-width `U32` hex encode: `0` ok, `3` buffer too small.

C ABI: `uint32_t lean_fs_hex_enc_u32_status(size_t addr, size_t cap, uint32_t v);` -/
@[export_c lean_fs_hex_enc_u32_status]
public unsafe def fsHexEncU32Status (addr : USize) (cap : USize) (v : U32) : U32 :=
  Systems.Hex.encU32Status addr cap v

/-- Fixed-width hex of `U64` (`16` digits): write length, or `(size_t)-1` if too small.

C ABI: `size_t lean_fs_hex_enc_u64(size_t addr, size_t cap, uint64_t v);` -/
@[export_c lean_fs_hex_enc_u64]
public unsafe def fsHexEncU64 (addr : USize) (cap : USize) (v : U64) : USize :=
  Systems.Hex.encU64 addr cap v

/-- Hex `U32` parse status: `0` ok, `1` empty/bad digit, `3` overflow.

C ABI: `uint32_t lean_fs_hex_parse_u32_status(size_t addr, size_t n);` -/
@[export_c lean_fs_hex_parse_u32_status]
public unsafe def fsHexParseU32Status (addr : USize) (n : USize) : U32 :=
  Systems.Hex.parseU32Status addr n

/-- Hex `U32` parse as `size_t`, or `(size_t)-1` on failure.

C ABI: `size_t lean_fs_hex_parse_u32(size_t addr, size_t n);` -/
@[export_c lean_fs_hex_parse_u32]
public unsafe def fsHexParseU32 (addr : USize) (n : USize) : USize :=
  Systems.Hex.parseU32 addr n

/-- Hex `U64` parse status: `0` ok, `1` empty/bad digit, `3` overflow.

C ABI: `uint32_t lean_fs_hex_parse_u64_status(size_t addr, size_t n);` -/
@[export_c lean_fs_hex_parse_u64_status]
public unsafe def fsHexParseU64Status (addr : USize) (n : USize) : U32 :=
  Systems.Hex.parseU64Status addr n

/-- Hex `U64` parse, or `(uint64_t)-1` on failure.

C ABI: `uint64_t lean_fs_hex_parse_u64(size_t addr, size_t n);` -/
@[export_c lean_fs_hex_parse_u64]
public unsafe def fsHexParseU64 (addr : USize) (n : USize) : U64 :=
  Systems.Hex.parseU64 addr n

/-- First UTF-8 codepoint length `1..4`, or `0` if empty/invalid.

C ABI: `size_t lean_fs_utf8_first_len(size_t addr, size_t n);` -/
@[export_c lean_fs_utf8_first_len]
public unsafe def fsUtf8FirstLen (addr : USize) (n : USize) : USize :=
  Systems.Utf8.firstLen addr n

/-- UTF-8 validate status: `0` ok, `1` invalid.

C ABI: `uint32_t lean_fs_utf8_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_utf8_validate]
public unsafe def fsUtf8Validate (addr : USize) (n : USize) : U32 :=
  Systems.Utf8.validate addr n

/-- UTF-8 codepoint count, or `(size_t)-1` if invalid.

C ABI: `size_t lean_fs_utf8_count(size_t addr, size_t n);` -/
@[export_c lean_fs_utf8_count]
public unsafe def fsUtf8Count (addr : USize) (n : USize) : USize :=
  Systems.Utf8.count addr n

/-- Pass-through occupancy count.

C ABI: `size_t lean_fs_tree_count(size_t n);` -/
@[export_c lean_fs_tree_count]
public def fsTreeCount (n : USize) : USize :=
  Systems.Tree.count n

/-- Pass-through capacity.

C ABI: `size_t lean_fs_tree_cap(size_t cap);` -/
@[export_c lean_fs_tree_cap]
public def fsTreeCap (cap : USize) : USize :=
  Systems.Tree.cap cap

/-- `1` if empty (`n == 0`), else `0`.

C ABI: `uint32_t lean_fs_tree_is_empty(size_t n);` -/
@[export_c lean_fs_tree_is_empty]
public def fsTreeIsEmpty (n : USize) : U32 :=
  Systems.Tree.isEmpty n

/-- `1` if full (`n == cap` or `cap == 0`), else `0`.

C ABI: `uint32_t lean_fs_tree_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_tree_is_full]
public def fsTreeIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Tree.isFull cap n

/-- Insert into min-heap. `0` ok, `3` full/`cap==0`. Caller increments `n` on success.

C ABI: `uint32_t lean_fs_tree_insert(size_t slots, size_t cap, size_t n, uint32_t val);` -/
@[export_c lean_fs_tree_insert]
public unsafe def fsTreeInsert (slots : USize) (cap : USize) (n : USize) (val : U32) : U32 :=
  Systems.Tree.insert slots cap n val

/-- Peek minimum as `size_t`, or `(size_t)-1` if empty.

C ABI: `size_t lean_fs_tree_peek_min(size_t slots, size_t n);` -/
@[export_c lean_fs_tree_peek_min]
public unsafe def fsTreePeekMin (slots : USize) (n : USize) : USize :=
  Systems.Tree.peekMin slots n

/-- Extract minimum as `size_t`, or `(size_t)-1` if empty. Caller decrements `n` on success.

C ABI: `size_t lean_fs_tree_extract_min(size_t slots, size_t n);` -/
@[export_c lean_fs_tree_extract_min]
public unsafe def fsTreeExtractMin (slots : USize) (n : USize) : USize :=
  Systems.Tree.extractMin slots n

/-! ## Json / Base64 / Graph smoke exports

JSON scan/validate, standard base64 enc/dec, fixed-cap U32 adjacency graph — shaped ports.
-/

/-- JSON validate (default depth 32): `0` ok, `1` invalid.

C ABI: `uint32_t lean_fs_json_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_json_validate]
public unsafe def fsJsonValidate (addr : USize) (n : USize) : U32 :=
  Systems.Json.validate addr n

/-- JSON validate with explicit depth budget: `0` ok, `1` syntax/fail.

C ABI: `uint32_t lean_fs_json_validate_depth(size_t addr, size_t n, size_t max_depth);` -/
@[export_c lean_fs_json_validate_depth]
public unsafe def fsJsonValidateDepth (addr : USize) (n : USize) (maxDepth : USize) : U32 :=
  Systems.Json.validateDepth addr n maxDepth

/-- Index after one JSON value from start, or `(size_t)-1` on error.

C ABI: `size_t lean_fs_json_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_json_scan]
public unsafe def fsJsonScan (addr : USize) (n : USize) : USize :=
  Systems.Json.scan addr n

/-- Base64 output length for `n` input bytes.

C ABI: `size_t lean_fs_b64_enc_need(size_t n);` -/
@[export_c lean_fs_b64_enc_need]
public def fsB64EncNeed (n : USize) : USize :=
  Systems.Base64.encNeed n

/-- Base64 encode: write length, or `(size_t)-1` if buffer too small.

C ABI: `size_t lean_fs_b64_encode(size_t src, size_t n, size_t out, size_t cap);` -/
@[export_c lean_fs_b64_encode]
public unsafe def fsB64Encode (src : USize) (n : USize) (out : USize) (cap : USize) : USize :=
  Systems.Base64.encode src n out cap

/-- Base64 encode status: `0` ok, `3` bounds.

C ABI: `uint32_t lean_fs_b64_encode_status(size_t src, size_t n, size_t out, size_t cap);` -/
@[export_c lean_fs_b64_encode_status]
public unsafe def fsB64EncodeStatus (src : USize) (n : USize) (out : USize) (cap : USize) : U32 :=
  Systems.Base64.encodeStatus src n out cap

/-- Base64 decode length need, or `(size_t)-1` if length not multiple of 4.

C ABI: `size_t lean_fs_b64_dec_need(size_t src, size_t n);` -/
@[export_c lean_fs_b64_dec_need]
public unsafe def fsB64DecNeed (src : USize) (n : USize) : USize :=
  Systems.Base64.decNeed src n

/-- Base64 decode: write length, or `(size_t)-1` on failure.

C ABI: `size_t lean_fs_b64_decode(size_t src, size_t n, size_t out, size_t cap);` -/
@[export_c lean_fs_b64_decode]
public unsafe def fsB64Decode (src : USize) (n : USize) (out : USize) (cap : USize) : USize :=
  Systems.Base64.decode src n out cap

/-- Base64 decode status: `0` ok, `1` bad input, `3` bounds.

C ABI: `uint32_t lean_fs_b64_decode_status(size_t src, size_t n, size_t out, size_t cap);` -/
@[export_c lean_fs_b64_decode_status]
public unsafe def fsB64DecodeStatus (src : USize) (n : USize) (out : USize) (cap : USize) : U32 :=
  Systems.Base64.decodeStatus src n out cap

/-- Zero Graph degree counters.

C ABI: `uint32_t lean_fs_graph_init(size_t degs, size_t node_cap);` -/
@[export_c lean_fs_graph_init]
public unsafe def fsGraphInit (degs : USize) (nodeCap : USize) : U32 :=
  Systems.Graph.init degs nodeCap

/-- Add directed edge `u → v`. `0` ok, `3` bounds/full.

C ABI: `uint32_t lean_fs_graph_add_edge(size_t adj, size_t degs, size_t node_cap, size_t max_deg,
  uint32_t u, uint32_t v);` -/
@[export_c lean_fs_graph_add_edge]
public unsafe def fsGraphAddEdge (adj : USize) (degs : USize) (nodeCap : USize) (maxDeg : USize)
    (u : U32) (v : U32) : U32 :=
  Systems.Graph.addEdge adj degs nodeCap maxDeg u v

/-- Degree of `u`, or `(size_t)-1` if out of range.

C ABI: `size_t lean_fs_graph_degree(size_t degs, size_t node_cap, uint32_t u);` -/
@[export_c lean_fs_graph_degree]
public unsafe def fsGraphDegree (degs : USize) (nodeCap : USize) (u : U32) : USize :=
  Systems.Graph.degree degs nodeCap u

/-- Neighbor `j` of `u`, or `(size_t)-1` if out of range.

C ABI: `size_t lean_fs_graph_neighbor(size_t adj, size_t degs, size_t node_cap, size_t max_deg,
  uint32_t u, size_t j);` -/
@[export_c lean_fs_graph_neighbor]
public unsafe def fsGraphNeighbor (adj : USize) (degs : USize) (nodeCap : USize) (maxDeg : USize)
    (u : U32) (j : USize) : USize :=
  Systems.Graph.neighbor adj degs nodeCap maxDeg u j

/-- Directed BFS from `start` into caller marks/queue. `0` ok, `3` bounds.

C ABI: `uint32_t lean_fs_graph_bfs(size_t adj, size_t degs, size_t marks, size_t queue,
  size_t node_cap, size_t max_deg, uint32_t start);` -/
@[export_c lean_fs_graph_bfs]
public unsafe def fsGraphBfs (adj : USize) (degs : USize) (marks : USize) (queue : USize)
    (nodeCap : USize) (maxDeg : USize) (start : U32) : U32 :=
  Systems.Graph.bfs adj degs marks queue nodeCap maxDeg start

/-- `1` if visit mark set, `0` clear, `3` out of range.

C ABI: `uint32_t lean_fs_graph_is_marked(size_t marks, size_t node_cap, uint32_t u);` -/
@[export_c lean_fs_graph_is_marked]
public unsafe def fsGraphIsMarked (marks : USize) (nodeCap : USize) (u : U32) : U32 :=
  Systems.Graph.isMarked marks nodeCap u

/-! ## Regex / Url / ArenaPool smoke exports

Regex-shaped scan, URL-shaped offsets, fixed-cap bump over caller buffer — shaped ports.
-/

/-- Regex full match: `0` ok, `1` no match.

C ABI: `uint32_t lean_fs_regex_full_match(size_t pat, size_t pn, size_t text, size_t tn);` -/
@[export_c lean_fs_regex_full_match]
public unsafe def fsRegexFullMatch (pat : USize) (pn : USize) (text : USize) (tn : USize) : U32 :=
  Systems.Regex.fullMatch pat pn text tn

/-- Regex scan from start: end index or `(size_t)-1`.

C ABI: `size_t lean_fs_regex_scan(size_t pat, size_t pn, size_t text, size_t tn);` -/
@[export_c lean_fs_regex_scan]
public unsafe def fsRegexScan (pat : USize) (pn : USize) (text : USize) (tn : USize) : USize :=
  Systems.Regex.scan pat pn text tn

/-- Regex find: first match start or `(size_t)-1`.

C ABI: `size_t lean_fs_regex_find(size_t pat, size_t pn, size_t text, size_t tn);` -/
@[export_c lean_fs_regex_find]
public unsafe def fsRegexFind (pat : USize) (pn : USize) (text : USize) (tn : USize) : USize :=
  Systems.Regex.find pat pn text tn

/-- Regex validate (alias of full match).

C ABI: `uint32_t lean_fs_regex_validate(size_t pat, size_t pn, size_t text, size_t tn);` -/
@[export_c lean_fs_regex_validate]
public unsafe def fsRegexValidate (pat : USize) (pn : USize) (text : USize) (tn : USize) : U32 :=
  Systems.Regex.validate pat pn text tn

/-- URL scheme length (0 if no scheme).

C ABI: `size_t lean_fs_url_scheme_len(size_t addr, size_t n);` -/
@[export_c lean_fs_url_scheme_len]
public unsafe def fsUrlSchemeLen (addr : USize) (n : USize) : USize :=
  Systems.Url.schemeLen addr n

/-- `1` if `scheme://` present.

C ABI: `uint32_t lean_fs_url_has_authority(size_t addr, size_t n);` -/
@[export_c lean_fs_url_has_authority]
public unsafe def fsUrlHasAuthority (addr : USize) (n : USize) : U32 :=
  Systems.Url.hasAuthority addr n

/-- Host byte offset (0 if no authority).

C ABI: `size_t lean_fs_url_host_off(size_t addr, size_t n);` -/
@[export_c lean_fs_url_host_off]
public unsafe def fsUrlHostOff (addr : USize) (n : USize) : USize :=
  Systems.Url.hostOff addr n

/-- Host byte length (0 if no authority).

C ABI: `size_t lean_fs_url_host_len(size_t addr, size_t n);` -/
@[export_c lean_fs_url_host_len]
public unsafe def fsUrlHostLen (addr : USize) (n : USize) : USize :=
  Systems.Url.hostLen addr n

/-- Path byte offset (0 if no authority).

C ABI: `size_t lean_fs_url_path_off(size_t addr, size_t n);` -/
@[export_c lean_fs_url_path_off]
public unsafe def fsUrlPathOff (addr : USize) (n : USize) : USize :=
  Systems.Url.pathOff addr n

/-- Path byte length (0 if none).

C ABI: `size_t lean_fs_url_path_len(size_t addr, size_t n);` -/
@[export_c lean_fs_url_path_len]
public unsafe def fsUrlPathLen (addr : USize) (n : USize) : USize :=
  Systems.Url.pathLen addr n

/-- URL validate: `0` ok (`scheme://` + non-empty host), `1` invalid.

C ABI: `uint32_t lean_fs_url_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_url_validate]
public unsafe def fsUrlValidate (addr : USize) (n : USize) : U32 :=
  Systems.Url.validate addr n

/-- ArenaPool remaining bytes.

C ABI: `size_t lean_fs_arena_pool_remaining(size_t cap, size_t used);` -/
@[export_c lean_fs_arena_pool_remaining]
public unsafe def fsArenaPoolRemaining (cap : USize) (used : USize) : USize :=
  Systems.ArenaPool.remaining cap used

/-- ArenaPool can-alloc status: `0` ok, `3` bounds.

C ABI: `uint32_t lean_fs_arena_pool_can_alloc(size_t cap, size_t used, size_t nbytes);` -/
@[export_c lean_fs_arena_pool_can_alloc]
public unsafe def fsArenaPoolCanAlloc (cap : USize) (used : USize) (nbytes : USize) : U32 :=
  Systems.ArenaPool.canAlloc cap used nbytes

/-- ArenaPool pure alloc end used, or `(size_t)-1`.

C ABI: `size_t lean_fs_arena_pool_alloc_end(size_t cap, size_t used, size_t nbytes);` -/
@[export_c lean_fs_arena_pool_alloc_end]
public unsafe def fsArenaPoolAllocEnd (cap : USize) (used : USize) (nbytes : USize) : USize :=
  Systems.ArenaPool.allocEnd cap used nbytes

/-- ArenaPool pure alloc address, or `(size_t)-1`.

C ABI: `size_t lean_fs_arena_pool_alloc_addr(size_t base, size_t cap, size_t used, size_t nbytes);` -/
@[export_c lean_fs_arena_pool_alloc_addr]
public unsafe def fsArenaPoolAllocAddr (base : USize) (cap : USize) (used : USize)
    (nbytes : USize) : USize :=
  Systems.ArenaPool.allocAddr base cap used nbytes

/-- ArenaPool reset used slot to 0.

C ABI: `uint32_t lean_fs_arena_pool_reset(size_t used_slot);` -/
@[export_c lean_fs_arena_pool_reset]
public unsafe def fsArenaPoolReset (usedSlot : USize) : U32 :=
  Systems.ArenaPool.reset usedSlot

/-- ArenaPool load used from slot.

C ABI: `size_t lean_fs_arena_pool_load_used(size_t used_slot);` -/
@[export_c lean_fs_arena_pool_load_used]
public unsafe def fsArenaPoolLoadUsed (usedSlot : USize) : USize :=
  Systems.ArenaPool.loadUsed usedSlot

/-- ArenaPool slot alloc: address or `(size_t)-1`; updates used.

C ABI: `size_t lean_fs_arena_pool_alloc(size_t base, size_t cap, size_t used_slot, size_t nbytes);` -/
@[export_c lean_fs_arena_pool_alloc]
public unsafe def fsArenaPoolAlloc (base : USize) (cap : USize) (usedSlot : USize)
    (nbytes : USize) : USize :=
  Systems.ArenaPool.alloc base cap usedSlot nbytes

/-- ArenaPool slot alloc status: `0` ok, `3` bounds.

C ABI: `uint32_t lean_fs_arena_pool_alloc_status(size_t base, size_t cap, size_t used_slot,
  size_t nbytes);` -/
@[export_c lean_fs_arena_pool_alloc_status]
public unsafe def fsArenaPoolAllocStatus (base : USize) (cap : USize) (usedSlot : USize)
    (nbytes : USize) : U32 :=
  Systems.ArenaPool.allocStatus base cap usedSlot nbytes

/-! ## Ini / Csv / Bloom smoke exports
Shaped INI/CSV/Bloom product surface (W11). -/

/-- INI structural validate: `0` ok, `1` invalid.

C ABI: `uint32_t lean_fs_ini_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ini_validate]
public unsafe def fsIniValidate (addr : USize) (n : USize) : U32 :=
  Systems.Ini.validate addr n

/-- Count well-formed `[section]` lines.

C ABI: `size_t lean_fs_ini_section_count(size_t addr, size_t n);` -/
@[export_c lean_fs_ini_section_count]
public unsafe def fsIniSectionCount (addr : USize) (n : USize) : USize :=
  Systems.Ini.sectionCount addr n

/-- Offset of matching `[section]`, or `(size_t)-1`.

C ABI: `size_t lean_fs_ini_find_section(size_t addr, size_t n, size_t name, size_t name_len);` -/
@[export_c lean_fs_ini_find_section]
public unsafe def fsIniFindSection (addr : USize) (n : USize) (nameAddr : USize)
    (nameLen : USize) : USize :=
  Systems.Ini.findSection addr n nameAddr nameLen

/-- Offset of matching key on a `key=value` line, or `(size_t)-1`.

C ABI: `size_t lean_fs_ini_find_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_ini_find_key]
public unsafe def fsIniFindKey (addr : USize) (n : USize) (keyAddr : USize)
    (keyLen : USize) : USize :=
  Systems.Ini.findKey addr n keyAddr keyLen

/-- Value byte offset for a key offset from `find_key`, or `(size_t)-1`.

C ABI: `size_t lean_fs_ini_value_off(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_ini_value_off]
public unsafe def fsIniValueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.Ini.valueOff addr n keyOff

/-- Value byte length for a key offset from `find_key`.

C ABI: `size_t lean_fs_ini_value_len(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_ini_value_len]
public unsafe def fsIniValueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.Ini.valueLen addr n keyOff

/-- `1` if section name present.

C ABI: `uint32_t lean_fs_ini_has_section(size_t addr, size_t n, size_t name, size_t name_len);` -/
@[export_c lean_fs_ini_has_section]
public unsafe def fsIniHasSection (addr : USize) (n : USize) (nameAddr : USize)
    (nameLen : USize) : U32 :=
  Systems.Ini.hasSection addr n nameAddr nameLen

/-- `1` if key present.

C ABI: `uint32_t lean_fs_ini_has_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_ini_has_key]
public unsafe def fsIniHasKey (addr : USize) (n : USize) (keyAddr : USize)
    (keyLen : USize) : U32 :=
  Systems.Ini.hasKey addr n keyAddr keyLen

/-- CSV structural validate (balanced quotes): `0` ok, `1` invalid.

C ABI: `uint32_t lean_fs_csv_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_csv_validate]
public unsafe def fsCsvValidate (addr : USize) (n : USize) : U32 :=
  Systems.Csv.validate addr n

/-- Fields in first row, or `(size_t)-1` on quote error.

C ABI: `size_t lean_fs_csv_field_count(size_t addr, size_t n);` -/
@[export_c lean_fs_csv_field_count]
public unsafe def fsCsvFieldCount (addr : USize) (n : USize) : USize :=
  Systems.Csv.fieldCount addr n

/-- Content offset of field `i` in first row, or `(size_t)-1`.

C ABI: `size_t lean_fs_csv_field_off(size_t addr, size_t n, size_t i);` -/
@[export_c lean_fs_csv_field_off]
public unsafe def fsCsvFieldOff (addr : USize) (n : USize) (i : USize) : USize :=
  Systems.Csv.fieldOff addr n i

/-- Content length of field `i` in first row.

C ABI: `size_t lean_fs_csv_field_len(size_t addr, size_t n, size_t i);` -/
@[export_c lean_fs_csv_field_len]
public unsafe def fsCsvFieldLen (addr : USize) (n : USize) (i : USize) : USize :=
  Systems.Csv.fieldLen addr n i

/-- End index past first row, or `(size_t)-1` on quote error.

C ABI: `size_t lean_fs_csv_scan_row(size_t addr, size_t n);` -/
@[export_c lean_fs_csv_scan_row]
public unsafe def fsCsvScanRow (addr : USize) (n : USize) : USize :=
  Systems.Csv.scanRow addr n

/-- Number of rows, or `(size_t)-1` on quote error.

C ABI: `size_t lean_fs_csv_row_count(size_t addr, size_t n);` -/
@[export_c lean_fs_csv_row_count]
public unsafe def fsCsvRowCount (addr : USize) (n : USize) : USize :=
  Systems.Csv.rowCount addr n

/-- Bloom bit capacity `nWords * 64`.

C ABI: `size_t lean_fs_bloom_nbits(size_t n_words);` -/
@[export_c lean_fs_bloom_nbits]
public unsafe def fsBloomNBits (nWords : USize) : USize :=
  Systems.Bloom.nBits nWords

/-- Zero all bloom words. Store status dataflow-used.

C ABI: `uint32_t lean_fs_bloom_clear(size_t words, size_t n_words);` -/
@[export_c lean_fs_bloom_clear]
public unsafe def fsBloomClear (words : USize) (nWords : USize) : U32 :=
  Systems.Bloom.clear words nWords

/-- Insert U32 key. `0` ok, `3` if n_words==0.

C ABI: `uint32_t lean_fs_bloom_add_u32(size_t words, size_t n_words, uint32_t key);` -/
@[export_c lean_fs_bloom_add_u32]
public unsafe def fsBloomAddU32 (words : USize) (nWords : USize) (key : U32) : U32 :=
  Systems.Bloom.addU32 words nWords key

/-- Query U32 key: `1` maybe, `0` no, `3` empty.

C ABI: `uint32_t lean_fs_bloom_may_contain_u32(size_t words, size_t n_words, uint32_t key);` -/
@[export_c lean_fs_bloom_may_contain_u32]
public unsafe def fsBloomMayContainU32 (words : USize) (nWords : USize) (key : U32) : U32 :=
  Systems.Bloom.mayContainU32 words nWords key

/-- Insert byte span.

C ABI: `uint32_t lean_fs_bloom_add_bytes(size_t words, size_t n_words, size_t addr, size_t len);` -/
@[export_c lean_fs_bloom_add_bytes]
public unsafe def fsBloomAddBytes (words : USize) (nWords : USize) (addr : USize)
    (len : USize) : U32 :=
  Systems.Bloom.addBytes words nWords addr len

/-- Query byte span: `1` maybe, `0` no, `3` empty.

C ABI: `uint32_t lean_fs_bloom_may_contain_bytes(size_t words, size_t n_words, size_t addr, size_t len);` -/
@[export_c lean_fs_bloom_may_contain_bytes]
public unsafe def fsBloomMayContainBytes (words : USize) (nWords : USize) (addr : USize)
    (len : USize) : U32 :=
  Systems.Bloom.mayContainBytes words nWords addr len

/-! ## Toml / Xml / SkipList smoke exports
Shaped TOML/XML/SkipList product surface (W12). -/

/-- TOML structural validate/parse: `0` ok, `1` invalid.

C ABI: `uint32_t lean_fs_toml_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_toml_validate]
public unsafe def fsTomlValidate (addr : USize) (n : USize) : U32 :=
  Systems.Toml.validate addr n

/-- Alias of validate (parse = structural scan).

C ABI: `uint32_t lean_fs_toml_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_toml_parse]
public unsafe def fsTomlParse (addr : USize) (n : USize) : U32 :=
  Systems.Toml.parse addr n

/-- Count well-formed `[table]` lines.

C ABI: `size_t lean_fs_toml_table_count(size_t addr, size_t n);` -/
@[export_c lean_fs_toml_table_count]
public unsafe def fsTomlTableCount (addr : USize) (n : USize) : USize :=
  Systems.Toml.tableCount addr n

/-- Offset of matching `[table]`, or `(size_t)-1`.

C ABI: `size_t lean_fs_toml_find_table(size_t addr, size_t n, size_t name, size_t name_len);` -/
@[export_c lean_fs_toml_find_table]
public unsafe def fsTomlFindTable (addr : USize) (n : USize) (nameAddr : USize)
    (nameLen : USize) : USize :=
  Systems.Toml.findTable addr n nameAddr nameLen

/-- Offset of matching key on a `key = value` line, or `(size_t)-1`.

C ABI: `size_t lean_fs_toml_find_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_toml_find_key]
public unsafe def fsTomlFindKey (addr : USize) (n : USize) (keyAddr : USize)
    (keyLen : USize) : USize :=
  Systems.Toml.findKey addr n keyAddr keyLen

/-- Value byte offset for a key offset from `find_key`, or `(size_t)-1`.

C ABI: `size_t lean_fs_toml_value_off(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_toml_value_off]
public unsafe def fsTomlValueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.Toml.valueOff addr n keyOff

/-- Value byte length for a key offset from `find_key`.

C ABI: `size_t lean_fs_toml_value_len(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_toml_value_len]
public unsafe def fsTomlValueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.Toml.valueLen addr n keyOff

/-- `1` if table name present.

C ABI: `uint32_t lean_fs_toml_has_table(size_t addr, size_t n, size_t name, size_t name_len);` -/
@[export_c lean_fs_toml_has_table]
public unsafe def fsTomlHasTable (addr : USize) (n : USize) (nameAddr : USize)
    (nameLen : USize) : U32 :=
  Systems.Toml.hasTable addr n nameAddr nameLen

/-- `1` if key present.

C ABI: `uint32_t lean_fs_toml_has_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_toml_has_key]
public unsafe def fsTomlHasKey (addr : USize) (n : USize) (keyAddr : USize)
    (keyLen : USize) : U32 :=
  Systems.Toml.hasKey addr n keyAddr keyLen

/-- XML structural validate (tag balance): `0` ok, `1` invalid.

C ABI: `uint32_t lean_fs_xml_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_xml_validate]
public unsafe def fsXmlValidate (addr : USize) (n : USize) : U32 :=
  Systems.Xml.validate addr n

/-- Alias of validate (scan = well-formedness).

C ABI: `uint32_t lean_fs_xml_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_xml_scan]
public unsafe def fsXmlScan (addr : USize) (n : USize) : U32 :=
  Systems.Xml.scan addr n

/-- Max open-tag nesting, or `(size_t)-1` on invalid.

C ABI: `size_t lean_fs_xml_max_depth(size_t addr, size_t n);` -/
@[export_c lean_fs_xml_max_depth]
public unsafe def fsXmlMaxDepth (addr : USize) (n : USize) : USize :=
  Systems.Xml.maxDepth addr n

/-- Number of open (non-empty) tags, or `(size_t)-1` on invalid.

C ABI: `size_t lean_fs_xml_open_count(size_t addr, size_t n);` -/
@[export_c lean_fs_xml_open_count]
public unsafe def fsXmlOpenCount (addr : USize) (n : USize) : USize :=
  Systems.Xml.openCount addr n

/-- Number of element starts (open + empty), or `(size_t)-1` on invalid.

C ABI: `size_t lean_fs_xml_elem_count(size_t addr, size_t n);` -/
@[export_c lean_fs_xml_elem_count]
public unsafe def fsXmlElemCount (addr : USize) (n : USize) : USize :=
  Systems.Xml.elemCount addr n

/-- SkipList lower-bound index, or `n` if all smaller.

C ABI: `size_t lean_fs_skiplist_lower_bound(size_t slots, size_t n, uint32_t key);` -/
@[export_c lean_fs_skiplist_lower_bound]
public unsafe def fsSkipListLowerBound (slots : USize) (n : USize) (key : U32) : USize :=
  Systems.SkipList.lowerBound slots n key

/-- `1` if key present in ordered multiset.

C ABI: `uint32_t lean_fs_skiplist_contains(size_t slots, size_t n, uint32_t key);` -/
@[export_c lean_fs_skiplist_contains]
public unsafe def fsSkipListContains (slots : USize) (n : USize) (key : U32) : U32 :=
  Systems.SkipList.contains slots n key

/-- Multiplicity of key.

C ABI: `size_t lean_fs_skiplist_count_key(size_t slots, size_t n, uint32_t key);` -/
@[export_c lean_fs_skiplist_count_key]
public unsafe def fsSkipListCountKey (slots : USize) (n : USize) (key : U32) : USize :=
  Systems.SkipList.countKey slots n key

/-- Insert key keeping order. `0` ok, `3` full. Caller uses `n+1` on success.

C ABI: `uint32_t lean_fs_skiplist_insert(size_t slots, size_t cap, size_t n, uint32_t key);` -/
@[export_c lean_fs_skiplist_insert]
public unsafe def fsSkipListInsert (slots : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  Systems.SkipList.insert slots cap n key

/-- Remove one occurrence. `0` ok, `1` absent. Caller uses `n-1` on success.

C ABI: `uint32_t lean_fs_skiplist_remove(size_t slots, size_t n, uint32_t key);` -/
@[export_c lean_fs_skiplist_remove]
public unsafe def fsSkipListRemove (slots : USize) (n : USize) (key : U32) : U32 :=
  Systems.SkipList.remove slots n key

/-- Get value at index as size_t, or `(size_t)-1`.

C ABI: `size_t lean_fs_skiplist_get(size_t slots, size_t n, size_t i);` -/
@[export_c lean_fs_skiplist_get]
public unsafe def fsSkipListGet (slots : USize) (n : USize) (i : USize) : USize :=
  Systems.SkipList.get slots n i

/-- `1` if empty.

C ABI: `uint32_t lean_fs_skiplist_is_empty(size_t n);` -/
@[export_c lean_fs_skiplist_is_empty]
public unsafe def fsSkipListIsEmpty (n : USize) : U32 :=
  Systems.SkipList.isEmpty n

/-- `1` if full.

C ABI: `uint32_t lean_fs_skiplist_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_skiplist_is_full]
public unsafe def fsSkipListIsFull (cap : USize) (n : USize) : U32 :=
  Systems.SkipList.isFull cap n

/-! ## Yaml / Http / BTree smoke exports
Shaped YAML/HTTP/BTree product surface (W13). -/

/-- YAML structural validate: `0` ok, `1` invalid.

C ABI: `uint32_t lean_fs_yaml_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_yaml_validate]
public unsafe def fsYamlValidate (addr : USize) (n : USize) : U32 :=
  Systems.Yaml.validate addr n

/-- Alias of validate (scan = line/indent scan).

C ABI: `uint32_t lean_fs_yaml_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_yaml_scan]
public unsafe def fsYamlScan (addr : USize) (n : USize) : U32 :=
  Systems.Yaml.scan addr n

/-- Max leading-space indent, or `(size_t)-1` on invalid.

C ABI: `size_t lean_fs_yaml_max_indent(size_t addr, size_t n);` -/
@[export_c lean_fs_yaml_max_indent]
public unsafe def fsYamlMaxIndent (addr : USize) (n : USize) : USize :=
  Systems.Yaml.maxIndent addr n

/-- Number of `key:` lines.

C ABI: `size_t lean_fs_yaml_key_count(size_t addr, size_t n);` -/
@[export_c lean_fs_yaml_key_count]
public unsafe def fsYamlKeyCount (addr : USize) (n : USize) : USize :=
  Systems.Yaml.keyCount addr n

/-- Number of `- ` list lines.

C ABI: `size_t lean_fs_yaml_list_count(size_t addr, size_t n);` -/
@[export_c lean_fs_yaml_list_count]
public unsafe def fsYamlListCount (addr : USize) (n : USize) : USize :=
  Systems.Yaml.listCount addr n

/-- Offset of matching key, or `(size_t)-1`.

C ABI: `size_t lean_fs_yaml_find_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_yaml_find_key]
public unsafe def fsYamlFindKey (addr : USize) (n : USize) (keyAddr : USize)
    (keyLen : USize) : USize :=
  Systems.Yaml.findKey addr n keyAddr keyLen

/-- Value offset for key offset from `find_key`, or `(size_t)-1`.

C ABI: `size_t lean_fs_yaml_value_off(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_yaml_value_off]
public unsafe def fsYamlValueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.Yaml.valueOff addr n keyOff

/-- Value length for key offset from `find_key`.

C ABI: `size_t lean_fs_yaml_value_len(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_yaml_value_len]
public unsafe def fsYamlValueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.Yaml.valueLen addr n keyOff

/-- `1` if key present.

C ABI: `uint32_t lean_fs_yaml_has_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_yaml_has_key]
public unsafe def fsYamlHasKey (addr : USize) (n : USize) (keyAddr : USize)
    (keyLen : USize) : U32 :=
  Systems.Yaml.hasKey addr n keyAddr keyLen

/-- HTTP structural parse: `0` ok, `1` invalid.

C ABI: `uint32_t lean_fs_http_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_http_validate]
public unsafe def fsHttpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Http.validate addr n

/-- Alias of validate.

C ABI: `uint32_t lean_fs_http_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_http_parse]
public unsafe def fsHttpParse (addr : USize) (n : USize) : U32 :=
  Systems.Http.parse addr n

/-- `1` if first line is a request-line.

C ABI: `uint32_t lean_fs_http_is_request(size_t addr, size_t n);` -/
@[export_c lean_fs_http_is_request]
public unsafe def fsHttpIsRequest (addr : USize) (n : USize) : U32 :=
  Systems.Http.isRequest addr n

/-- `1` if first line is a status-line.

C ABI: `uint32_t lean_fs_http_is_response(size_t addr, size_t n);` -/
@[export_c lean_fs_http_is_response]
public unsafe def fsHttpIsResponse (addr : USize) (n : USize) : U32 :=
  Systems.Http.isResponse addr n

/-- Method length (request), else `0`.

C ABI: `size_t lean_fs_http_method_len(size_t addr, size_t n);` -/
@[export_c lean_fs_http_method_len]
public unsafe def fsHttpMethodLen (addr : USize) (n : USize) : USize :=
  Systems.Http.methodLen addr n

/-- Target offset (request), else `0`.

C ABI: `size_t lean_fs_http_target_off(size_t addr, size_t n);` -/
@[export_c lean_fs_http_target_off]
public unsafe def fsHttpTargetOff (addr : USize) (n : USize) : USize :=
  Systems.Http.targetOff addr n

/-- Target length (request), else `0`.

C ABI: `size_t lean_fs_http_target_len(size_t addr, size_t n);` -/
@[export_c lean_fs_http_target_len]
public unsafe def fsHttpTargetLen (addr : USize) (n : USize) : USize :=
  Systems.Http.targetLen addr n

/-- Version length, else `0`.

C ABI: `size_t lean_fs_http_version_len(size_t addr, size_t n);` -/
@[export_c lean_fs_http_version_len]
public unsafe def fsHttpVersionLen (addr : USize) (n : USize) : USize :=
  Systems.Http.versionLen addr n

/-- Status code length (`3` on response), else `0`.

C ABI: `size_t lean_fs_http_status_len(size_t addr, size_t n);` -/
@[export_c lean_fs_http_status_len]
public unsafe def fsHttpStatusLen (addr : USize) (n : USize) : USize :=
  Systems.Http.statusLen addr n

/-- Header count before blank line.

C ABI: `size_t lean_fs_http_header_count(size_t addr, size_t n);` -/
@[export_c lean_fs_http_header_count]
public unsafe def fsHttpHeaderCount (addr : USize) (n : USize) : USize :=
  Systems.Http.headerCount addr n

/-- Header name offset, or `(size_t)-1`.

C ABI: `size_t lean_fs_http_find_header(size_t addr, size_t n, size_t name, size_t name_len);` -/
@[export_c lean_fs_http_find_header]
public unsafe def fsHttpFindHeader (addr : USize) (n : USize) (nameAddr : USize)
    (nameLen : USize) : USize :=
  Systems.Http.findHeader addr n nameAddr nameLen

/-- Header value offset for name offset from `find_header`.

C ABI: `size_t lean_fs_http_header_value_off(size_t addr, size_t n, size_t name_off);` -/
@[export_c lean_fs_http_header_value_off]
public unsafe def fsHttpHeaderValueOff (addr : USize) (n : USize) (nameOff : USize) : USize :=
  Systems.Http.headerValueOff addr n nameOff

/-- Header value length for name offset from `find_header`.

C ABI: `size_t lean_fs_http_header_value_len(size_t addr, size_t n, size_t name_off);` -/
@[export_c lean_fs_http_header_value_len]
public unsafe def fsHttpHeaderValueLen (addr : USize) (n : USize) (nameOff : USize) : USize :=
  Systems.Http.headerValueLen addr n nameOff

/-- BTree lower-bound index, or `n` if all smaller.

C ABI: `size_t lean_fs_btree_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_btree_lower_bound]
public unsafe def fsBTreeLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.BTree.lowerBound keys n key

/-- `1` if key present.

C ABI: `uint32_t lean_fs_btree_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_btree_contains]
public unsafe def fsBTreeContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.BTree.contains keys n key

/-- Value for key as size_t, or `(size_t)-1`.

C ABI: `size_t lean_fs_btree_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_btree_get]
public unsafe def fsBTreeGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.BTree.get keys vals n key

/-- Value at index as size_t, or `(size_t)-1`.

C ABI: `size_t lean_fs_btree_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_btree_get_at]
public unsafe def fsBTreeGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.BTree.getAt vals n i

/-- Insert key→val. `0` ok, `3` full for new key. Caller uses `n+1` on growth.

C ABI: `uint32_t lean_fs_btree_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_btree_insert]
public unsafe def fsBTreeInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.BTree.insert keys vals cap n key val

/-- Remove key. `0` ok, `1` absent. Caller uses `n-1` on success.

C ABI: `uint32_t lean_fs_btree_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_btree_remove]
public unsafe def fsBTreeRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.BTree.remove keys vals n key

/-- `1` if empty.

C ABI: `uint32_t lean_fs_btree_is_empty(size_t n);` -/
@[export_c lean_fs_btree_is_empty]
public unsafe def fsBTreeIsEmpty (n : USize) : U32 :=
  Systems.BTree.isEmpty n

/-- `1` if full.

C ABI: `uint32_t lean_fs_btree_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_btree_is_full]
public unsafe def fsBTreeIsFull (cap : USize) (n : USize) : U32 :=
  Systems.BTree.isFull cap n

/-! ## Dns / Sexp / Avl smoke exports
Shaped DNS/S-exp/AVL product surface (W14). -/

/-- DNS-shaped validate.

C ABI: `uint32_t lean_fs_dns_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_dns_validate]
public unsafe def fsDnsValidate (addr : USize) (n : USize) : U32 :=
  Systems.Dns.validate addr n

/-- DNS-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_dns_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_dns_scan]
public unsafe def fsDnsScan (addr : USize) (n : USize) : U32 :=
  Systems.Dns.scan addr n

/-- DNS label count.

C ABI: `size_t lean_fs_dns_label_count(size_t addr, size_t n);` -/
@[export_c lean_fs_dns_label_count]
public unsafe def fsDnsLabelCount (addr : USize) (n : USize) : USize :=
  Systems.Dns.labelCount addr n

/-- DNS label byte offset at index, or miss.

C ABI: `size_t lean_fs_dns_label_off(size_t addr, size_t n, size_t idx);` -/
@[export_c lean_fs_dns_label_off]
public unsafe def fsDnsLabelOff (addr : USize) (n : USize) (idx : USize) : USize :=
  Systems.Dns.labelOff addr n idx

/-- DNS label length at index.

C ABI: `size_t lean_fs_dns_label_len(size_t addr, size_t n, size_t idx);` -/
@[export_c lean_fs_dns_label_len]
public unsafe def fsDnsLabelLen (addr : USize) (n : USize) (idx : USize) : USize :=
  Systems.Dns.labelLen addr n idx

/-- DNS absolute (trailing dot) flag.

C ABI: `uint32_t lean_fs_dns_is_absolute(size_t addr, size_t n);` -/
@[export_c lean_fs_dns_is_absolute]
public unsafe def fsDnsIsAbsolute (addr : USize) (n : USize) : U32 :=
  Systems.Dns.isAbsolute addr n

/-- S-expression-shaped validate.

C ABI: `uint32_t lean_fs_sexp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_sexp_validate]
public unsafe def fsSexpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Sexp.validate addr n

/-- S-expression-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_sexp_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_sexp_scan]
public unsafe def fsSexpScan (addr : USize) (n : USize) : U32 :=
  Systems.Sexp.scan addr n

/-- S-expression max paren depth, or miss.

C ABI: `size_t lean_fs_sexp_max_depth(size_t addr, size_t n);` -/
@[export_c lean_fs_sexp_max_depth]
public unsafe def fsSexpMaxDepth (addr : USize) (n : USize) : USize :=
  Systems.Sexp.maxDepth addr n

/-- S-expression atom count, or miss.

C ABI: `size_t lean_fs_sexp_atom_count(size_t addr, size_t n);` -/
@[export_c lean_fs_sexp_atom_count]
public unsafe def fsSexpAtomCount (addr : USize) (n : USize) : USize :=
  Systems.Sexp.atomCount addr n

/-- S-expression list open count, or miss.

C ABI: `size_t lean_fs_sexp_list_count(size_t addr, size_t n);` -/
@[export_c lean_fs_sexp_list_count]
public unsafe def fsSexpListCount (addr : USize) (n : USize) : USize :=
  Systems.Sexp.listCount addr n

/-- AVL lower-bound index, or `n` if all smaller.

C ABI: `size_t lean_fs_avl_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_avl_lower_bound]
public unsafe def fsAvlLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.Avl.lowerBound keys n key

/-- AVL contains.

C ABI: `uint32_t lean_fs_avl_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_avl_contains]
public unsafe def fsAvlContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.Avl.contains keys n key

/-- AVL get value as USize, or miss.

C ABI: `size_t lean_fs_avl_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_avl_get]
public unsafe def fsAvlGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.Avl.get keys vals n key

/-- AVL get-at index as USize, or miss.

C ABI: `size_t lean_fs_avl_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_avl_get_at]
public unsafe def fsAvlGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.Avl.getAt vals n i

/-- AVL insert (status dataflow-used).

C ABI: `uint32_t lean_fs_avl_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_avl_insert]
public unsafe def fsAvlInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.Avl.insert keys vals cap n key val

/-- AVL remove.

C ABI: `uint32_t lean_fs_avl_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_avl_remove]
public unsafe def fsAvlRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.Avl.remove keys vals n key

/-- AVL is-empty occupancy helper.

C ABI: `uint32_t lean_fs_avl_is_empty(size_t n);` -/
@[export_c lean_fs_avl_is_empty]
public unsafe def fsAvlIsEmpty (n : USize) : U32 :=
  Systems.Avl.isEmpty n

/-- AVL is-full occupancy helper.

C ABI: `uint32_t lean_fs_avl_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_avl_is_full]
public unsafe def fsAvlIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Avl.isFull cap n

/-- Markdown-shaped validate (fence balance).

C ABI: `uint32_t lean_fs_md_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_md_validate]
public unsafe def fsMdValidate (addr : USize) (n : USize) : U32 :=
  Systems.Md.validate addr n

/-- Markdown-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_md_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_md_scan]
public unsafe def fsMdScan (addr : USize) (n : USize) : U32 :=
  Systems.Md.scan addr n

/-- Markdown heading count.

C ABI: `size_t lean_fs_md_heading_count(size_t addr, size_t n);` -/
@[export_c lean_fs_md_heading_count]
public unsafe def fsMdHeadingCount (addr : USize) (n : USize) : USize :=
  Systems.Md.headingCount addr n

/-- Markdown list item count.

C ABI: `size_t lean_fs_md_list_count(size_t addr, size_t n);` -/
@[export_c lean_fs_md_list_count]
public unsafe def fsMdListCount (addr : USize) (n : USize) : USize :=
  Systems.Md.listCount addr n

/-- Markdown max heading level, or miss.

C ABI: `size_t lean_fs_md_max_heading_level(size_t addr, size_t n);` -/
@[export_c lean_fs_md_max_heading_level]
public unsafe def fsMdMaxHeadingLevel (addr : USize) (n : USize) : USize :=
  Systems.Md.maxHeadingLevel addr n

/-- Markdown find heading by title, or miss.

C ABI: `size_t lean_fs_md_find_heading(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_md_find_heading]
public unsafe def fsMdFindHeading (addr : USize) (n : USize) (key : USize) (keyLen : USize)
    : USize :=
  Systems.Md.findHeading addr n key keyLen

/-- Markdown fence marker count.

C ABI: `size_t lean_fs_md_fence_count(size_t addr, size_t n);` -/
@[export_c lean_fs_md_fence_count]
public unsafe def fsMdFenceCount (addr : USize) (n : USize) : USize :=
  Systems.Md.fenceCount addr n

/-- ICMP-shaped validate (min 8 bytes).

C ABI: `uint32_t lean_fs_icmp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_icmp_validate]
public unsafe def fsIcmpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Icmp.validate addr n

/-- ICMP-shaped parse (alias of validate).

C ABI: `uint32_t lean_fs_icmp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_icmp_parse]
public unsafe def fsIcmpParse (addr : USize) (n : USize) : U32 :=
  Systems.Icmp.parse addr n

/-- ICMP type field.

C ABI: `uint32_t lean_fs_icmp_type(size_t addr, size_t n);` -/
@[export_c lean_fs_icmp_type]
public unsafe def fsIcmpType (addr : USize) (n : USize) : U32 :=
  Systems.Icmp.type addr n

/-- ICMP code field.

C ABI: `uint32_t lean_fs_icmp_code(size_t addr, size_t n);` -/
@[export_c lean_fs_icmp_code]
public unsafe def fsIcmpCode (addr : USize) (n : USize) : U32 :=
  Systems.Icmp.code addr n

/-- ICMP checksum field (BE U16 as U32).

C ABI: `uint32_t lean_fs_icmp_checksum(size_t addr, size_t n);` -/
@[export_c lean_fs_icmp_checksum]
public unsafe def fsIcmpChecksum (addr : USize) (n : USize) : U32 :=
  Systems.Icmp.checksum addr n

/-- ICMP echo-shaped identifier (BE U16 as U32).

C ABI: `uint32_t lean_fs_icmp_id(size_t addr, size_t n);` -/
@[export_c lean_fs_icmp_id]
public unsafe def fsIcmpId (addr : USize) (n : USize) : U32 :=
  Systems.Icmp.id addr n

/-- ICMP echo-shaped sequence (BE U16 as U32).

C ABI: `uint32_t lean_fs_icmp_seq(size_t addr, size_t n);` -/
@[export_c lean_fs_icmp_seq]
public unsafe def fsIcmpSeq (addr : USize) (n : USize) : U32 :=
  Systems.Icmp.seq addr n

/-- RB-tree lower-bound index, or `n` if all smaller.

C ABI: `size_t lean_fs_rbtree_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_rbtree_lower_bound]
public unsafe def fsRbTreeLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.RbTree.lowerBound keys n key

/-- RB-tree contains.

C ABI: `uint32_t lean_fs_rbtree_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_rbtree_contains]
public unsafe def fsRbTreeContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.RbTree.contains keys n key

/-- RB-tree get value as USize, or miss.

C ABI: `size_t lean_fs_rbtree_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_rbtree_get]
public unsafe def fsRbTreeGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.RbTree.get keys vals n key

/-- RB-tree get-at index as USize, or miss.

C ABI: `size_t lean_fs_rbtree_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_rbtree_get_at]
public unsafe def fsRbTreeGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.RbTree.getAt vals n i

/-- RB-tree insert (status dataflow-used).

C ABI: `uint32_t lean_fs_rbtree_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_rbtree_insert]
public unsafe def fsRbTreeInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.RbTree.insert keys vals cap n key val

/-- RB-tree remove.

C ABI: `uint32_t lean_fs_rbtree_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_rbtree_remove]
public unsafe def fsRbTreeRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.RbTree.remove keys vals n key

/-- RB-tree is-empty occupancy helper.

C ABI: `uint32_t lean_fs_rbtree_is_empty(size_t n);` -/
@[export_c lean_fs_rbtree_is_empty]
public unsafe def fsRbTreeIsEmpty (n : USize) : U32 :=
  Systems.RbTree.isEmpty n

/-- RB-tree is-full occupancy helper.

C ABI: `uint32_t lean_fs_rbtree_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_rbtree_is_full]
public unsafe def fsRbTreeIsFull (cap : USize) (n : USize) : U32 :=
  Systems.RbTree.isFull cap n

/-- PEM-shaped validate.

C ABI: `uint32_t lean_fs_pem_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_pem_validate]
public unsafe def fsPemValidate (addr : USize) (n : USize) : U32 :=
  Systems.Pem.validate addr n

/-- PEM-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_pem_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_pem_scan]
public unsafe def fsPemScan (addr : USize) (n : USize) : U32 :=
  Systems.Pem.scan addr n

/-- PEM is-pem helper.

C ABI: `uint32_t lean_fs_pem_is_pem(size_t addr, size_t n);` -/
@[export_c lean_fs_pem_is_pem]
public unsafe def fsPemIsPem (addr : USize) (n : USize) : U32 :=
  Systems.Pem.isPem addr n

/-- PEM block count.

C ABI: `size_t lean_fs_pem_block_count(size_t addr, size_t n);` -/
@[export_c lean_fs_pem_block_count]
public unsafe def fsPemBlockCount (addr : USize) (n : USize) : USize :=
  Systems.Pem.blockCount addr n

/-- PEM first-label offset, or miss.

C ABI: `size_t lean_fs_pem_label_off(size_t addr, size_t n);` -/
@[export_c lean_fs_pem_label_off]
public unsafe def fsPemLabelOff (addr : USize) (n : USize) : USize :=
  Systems.Pem.labelOff addr n

/-- PEM first-label length.

C ABI: `size_t lean_fs_pem_label_len(size_t addr, size_t n);` -/
@[export_c lean_fs_pem_label_len]
public unsafe def fsPemLabelLen (addr : USize) (n : USize) : USize :=
  Systems.Pem.labelLen addr n

/-- PEM find label by key, or miss.

C ABI: `size_t lean_fs_pem_find_label(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_pem_find_label]
public unsafe def fsPemFindLabel (addr : USize) (n : USize) (key : USize) (keyLen : USize)
    : USize :=
  Systems.Pem.findLabel addr n key keyLen

/-- PEM body line count.

C ABI: `size_t lean_fs_pem_body_line_count(size_t addr, size_t n);` -/
@[export_c lean_fs_pem_body_line_count]
public unsafe def fsPemBodyLineCount (addr : USize) (n : USize) : USize :=
  Systems.Pem.bodyLineCount addr n

/-- NTP-shaped validate (min 48 bytes).

C ABI: `uint32_t lean_fs_ntp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ntp_validate]
public unsafe def fsNtpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Ntp.validate addr n

/-- NTP-shaped parse (alias of validate).

C ABI: `uint32_t lean_fs_ntp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_ntp_parse]
public unsafe def fsNtpParse (addr : USize) (n : USize) : U32 :=
  Systems.Ntp.parse addr n

/-- NTP leap indicator field.

C ABI: `uint32_t lean_fs_ntp_li(size_t addr, size_t n);` -/
@[export_c lean_fs_ntp_li]
public unsafe def fsNtpLi (addr : USize) (n : USize) : U32 :=
  Systems.Ntp.li addr n

/-- NTP version field.

C ABI: `uint32_t lean_fs_ntp_version(size_t addr, size_t n);` -/
@[export_c lean_fs_ntp_version]
public unsafe def fsNtpVersion (addr : USize) (n : USize) : U32 :=
  Systems.Ntp.version addr n

/-- NTP mode field.

C ABI: `uint32_t lean_fs_ntp_mode(size_t addr, size_t n);` -/
@[export_c lean_fs_ntp_mode]
public unsafe def fsNtpMode (addr : USize) (n : USize) : U32 :=
  Systems.Ntp.mode addr n

/-- NTP stratum field.

C ABI: `uint32_t lean_fs_ntp_stratum(size_t addr, size_t n);` -/
@[export_c lean_fs_ntp_stratum]
public unsafe def fsNtpStratum (addr : USize) (n : USize) : U32 :=
  Systems.Ntp.stratum addr n

/-- NTP poll field.

C ABI: `uint32_t lean_fs_ntp_poll(size_t addr, size_t n);` -/
@[export_c lean_fs_ntp_poll]
public unsafe def fsNtpPoll (addr : USize) (n : USize) : U32 :=
  Systems.Ntp.poll addr n

/-- NTP precision field.

C ABI: `uint32_t lean_fs_ntp_precision(size_t addr, size_t n);` -/
@[export_c lean_fs_ntp_precision]
public unsafe def fsNtpPrecision (addr : USize) (n : USize) : U32 :=
  Systems.Ntp.precision addr n

/-- NTP root-delay wire offset (layout helper).

C ABI: `size_t lean_fs_ntp_root_delay_off(size_t n);` (`n` unused). -/
@[export_c lean_fs_ntp_root_delay_off]
public def fsNtpRootDelayOff (n : USize) : USize :=
  Systems.Ntp.rootDelayOff n

/-- NTP root-dispersion wire offset (layout helper).

C ABI: `size_t lean_fs_ntp_root_disp_off(size_t n);` (`n` unused). -/
@[export_c lean_fs_ntp_root_disp_off]
public def fsNtpRootDispOff (n : USize) : USize :=
  Systems.Ntp.rootDispOff n

/-- Trie lower-bound index, or `n` if all smaller.

C ABI: `size_t lean_fs_trie_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_trie_lower_bound]
public unsafe def fsTrieLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.Trie.lowerBound keys n key

/-- Trie contains.

C ABI: `uint32_t lean_fs_trie_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_trie_contains]
public unsafe def fsTrieContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.Trie.contains keys n key

/-- Trie get value as USize, or miss.

C ABI: `size_t lean_fs_trie_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_trie_get]
public unsafe def fsTrieGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.Trie.get keys vals n key

/-- Trie get-at index as USize, or miss.

C ABI: `size_t lean_fs_trie_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_trie_get_at]
public unsafe def fsTrieGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.Trie.getAt vals n i

/-- Trie insert (status dataflow-used).

C ABI: `uint32_t lean_fs_trie_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_trie_insert]
public unsafe def fsTrieInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.Trie.insert keys vals cap n key val

/-- Trie remove.

C ABI: `uint32_t lean_fs_trie_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_trie_remove]
public unsafe def fsTrieRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.Trie.remove keys vals n key

/-- Trie is-empty occupancy helper.

C ABI: `uint32_t lean_fs_trie_is_empty(size_t n);` -/
@[export_c lean_fs_trie_is_empty]
public unsafe def fsTrieIsEmpty (n : USize) : U32 :=
  Systems.Trie.isEmpty n

/-- Trie is-full occupancy helper.

C ABI: `uint32_t lean_fs_trie_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_trie_is_full]
public unsafe def fsTrieIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Trie.isFull cap n

/-- JWT-shaped validate.

C ABI: `uint32_t lean_fs_jwt_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_jwt_validate]
public unsafe def fsJwtValidate (addr : USize) (n : USize) : U32 :=
  Systems.Jwt.validate addr n

/-- JWT-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_jwt_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_jwt_scan]
public unsafe def fsJwtScan (addr : USize) (n : USize) : U32 :=
  Systems.Jwt.scan addr n

/-- JWT part count.

C ABI: `size_t lean_fs_jwt_part_count(size_t addr, size_t n);` -/
@[export_c lean_fs_jwt_part_count]
public unsafe def fsJwtPartCount (addr : USize) (n : USize) : USize :=
  Systems.Jwt.partCount addr n

/-- JWT part offset, or miss.

C ABI: `size_t lean_fs_jwt_part_off(size_t addr, size_t n, size_t idx);` -/
@[export_c lean_fs_jwt_part_off]
public unsafe def fsJwtPartOff (addr : USize) (n : USize) (idx : USize) : USize :=
  Systems.Jwt.partOff addr n idx

/-- JWT part length.

C ABI: `size_t lean_fs_jwt_part_len(size_t addr, size_t n, size_t idx);` -/
@[export_c lean_fs_jwt_part_len]
public unsafe def fsJwtPartLen (addr : USize) (n : USize) (idx : USize) : USize :=
  Systems.Jwt.partLen addr n idx

/-- JWT is-three-parts helper (classic compact JWS shape).

C ABI: `uint32_t lean_fs_jwt_is_three_parts(size_t addr, size_t n);` -/
@[export_c lean_fs_jwt_is_three_parts]
public unsafe def fsJwtIsThreeParts (addr : USize) (n : USize) : U32 :=
  Systems.Jwt.isThreeParts addr n

/-- DHCP-shaped validate (min 236 bytes).

C ABI: `uint32_t lean_fs_dhcp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_dhcp_validate]
public unsafe def fsDhcpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Dhcp.validate addr n

/-- DHCP-shaped parse (alias of validate).

C ABI: `uint32_t lean_fs_dhcp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_dhcp_parse]
public unsafe def fsDhcpParse (addr : USize) (n : USize) : U32 :=
  Systems.Dhcp.parse addr n

/-- DHCP op field.

C ABI: `uint32_t lean_fs_dhcp_op(size_t addr, size_t n);` -/
@[export_c lean_fs_dhcp_op]
public unsafe def fsDhcpOp (addr : USize) (n : USize) : U32 :=
  Systems.Dhcp.op addr n

/-- DHCP htype field.

C ABI: `uint32_t lean_fs_dhcp_htype(size_t addr, size_t n);` -/
@[export_c lean_fs_dhcp_htype]
public unsafe def fsDhcpHtype (addr : USize) (n : USize) : U32 :=
  Systems.Dhcp.htype addr n

/-- DHCP hlen field.

C ABI: `uint32_t lean_fs_dhcp_hlen(size_t addr, size_t n);` -/
@[export_c lean_fs_dhcp_hlen]
public unsafe def fsDhcpHlen (addr : USize) (n : USize) : U32 :=
  Systems.Dhcp.hlen addr n

/-- DHCP hops field.

C ABI: `uint32_t lean_fs_dhcp_hops(size_t addr, size_t n);` -/
@[export_c lean_fs_dhcp_hops]
public unsafe def fsDhcpHops (addr : USize) (n : USize) : U32 :=
  Systems.Dhcp.hops addr n

/-- DHCP xid field (big-endian).

C ABI: `uint32_t lean_fs_dhcp_xid(size_t addr, size_t n);` -/
@[export_c lean_fs_dhcp_xid]
public unsafe def fsDhcpXid (addr : USize) (n : USize) : U32 :=
  Systems.Dhcp.xid addr n

/-- DHCP magic-cookie present helper.

C ABI: `uint32_t lean_fs_dhcp_has_magic_cookie(size_t addr, size_t n);` -/
@[export_c lean_fs_dhcp_has_magic_cookie]
public unsafe def fsDhcpHasMagicCookie (addr : USize) (n : USize) : U32 :=
  Systems.Dhcp.hasMagicCookie addr n

/-- Heap occupancy count (pass-through).

C ABI: `size_t lean_fs_heap_count(size_t n);` -/
@[export_c lean_fs_heap_count]
public def fsHeapCount (n : USize) : USize :=
  Systems.BinaryHeap.count n

/-- Heap capacity (pass-through).

C ABI: `size_t lean_fs_heap_cap(size_t cap);` -/
@[export_c lean_fs_heap_cap]
public def fsHeapCap (cap : USize) : USize :=
  Systems.BinaryHeap.cap cap

/-- Heap is-empty occupancy helper.

C ABI: `uint32_t lean_fs_heap_is_empty(size_t n);` -/
@[export_c lean_fs_heap_is_empty]
public def fsHeapIsEmpty (n : USize) : U32 :=
  Systems.BinaryHeap.isEmpty n

/-- Heap is-full occupancy helper.

C ABI: `uint32_t lean_fs_heap_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_heap_is_full]
public def fsHeapIsFull (cap : USize) (n : USize) : U32 :=
  Systems.BinaryHeap.isFull cap n

/-- Heap insert (status dataflow-used).

C ABI: `uint32_t lean_fs_heap_insert(size_t slots, size_t cap, size_t n, uint32_t val);` -/
@[export_c lean_fs_heap_insert]
public unsafe def fsHeapInsert (slots : USize) (cap : USize) (n : USize) (val : U32) : U32 :=
  Systems.BinaryHeap.insert slots cap n val

/-- Heap peek-min as USize, or miss.

C ABI: `size_t lean_fs_heap_peek_min(size_t slots, size_t n);` -/
@[export_c lean_fs_heap_peek_min]
public unsafe def fsHeapPeekMin (slots : USize) (n : USize) : USize :=
  Systems.BinaryHeap.peekMin slots n

/-- Heap extract-min as USize, or miss.

C ABI: `size_t lean_fs_heap_extract_min(size_t slots, size_t n);` -/
@[export_c lean_fs_heap_extract_min]
public unsafe def fsHeapExtractMin (slots : USize) (n : USize) : USize :=
  Systems.BinaryHeap.extractMin slots n

/-- UUID-shaped validate (canonical 36-char form).

C ABI: `uint32_t lean_fs_uuid_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_uuid_validate]
public unsafe def fsUuidValidate (addr : USize) (n : USize) : U32 :=
  Systems.Uuid.validate addr n

/-- UUID-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_uuid_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_uuid_scan]
public unsafe def fsUuidScan (addr : USize) (n : USize) : U32 :=
  Systems.Uuid.scan addr n

/-- UUID version nibble (`0..15`), or `0` if invalid.

C ABI: `uint32_t lean_fs_uuid_version(size_t addr, size_t n);` -/
@[export_c lean_fs_uuid_version]
public unsafe def fsUuidVersion (addr : USize) (n : USize) : U32 :=
  Systems.Uuid.version addr n

/-- UUID variant nibble (`0..15`), or `0` if invalid.

C ABI: `uint32_t lean_fs_uuid_variant(size_t addr, size_t n);` -/
@[export_c lean_fs_uuid_variant]
public unsafe def fsUuidVariant (addr : USize) (n : USize) : U32 :=
  Systems.Uuid.variant addr n

/-- ARP-shaped validate (min 28 bytes).

C ABI: `uint32_t lean_fs_arp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_arp_validate]
public unsafe def fsArpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Arp.validate addr n

/-- ARP-shaped parse (alias of validate).

C ABI: `uint32_t lean_fs_arp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_arp_parse]
public unsafe def fsArpParse (addr : USize) (n : USize) : U32 :=
  Systems.Arp.parse addr n

/-- ARP htype field (BE).

C ABI: `uint32_t lean_fs_arp_htype(size_t addr, size_t n);` -/
@[export_c lean_fs_arp_htype]
public unsafe def fsArpHtype (addr : USize) (n : USize) : U32 :=
  Systems.Arp.htype addr n

/-- ARP ptype field (BE).

C ABI: `uint32_t lean_fs_arp_ptype(size_t addr, size_t n);` -/
@[export_c lean_fs_arp_ptype]
public unsafe def fsArpPtype (addr : USize) (n : USize) : U32 :=
  Systems.Arp.ptype addr n

/-- ARP hlen field.

C ABI: `uint32_t lean_fs_arp_hlen(size_t addr, size_t n);` -/
@[export_c lean_fs_arp_hlen]
public unsafe def fsArpHlen (addr : USize) (n : USize) : U32 :=
  Systems.Arp.hlen addr n

/-- ARP plen field.

C ABI: `uint32_t lean_fs_arp_plen(size_t addr, size_t n);` -/
@[export_c lean_fs_arp_plen]
public unsafe def fsArpPlen (addr : USize) (n : USize) : U32 :=
  Systems.Arp.plen addr n

/-- ARP oper field (BE).

C ABI: `uint32_t lean_fs_arp_oper(size_t addr, size_t n);` -/
@[export_c lean_fs_arp_oper]
public unsafe def fsArpOper (addr : USize) (n : USize) : U32 :=
  Systems.Arp.oper addr n

/-- ARP sender hardware address offset (layout helper).

C ABI: `size_t lean_fs_arp_sha_off(size_t n);` -/
@[export_c lean_fs_arp_sha_off]
public def fsArpShaOff (n : USize) : USize :=
  Systems.Arp.shaOff n

/-- ARP sender protocol address offset (layout helper).

C ABI: `size_t lean_fs_arp_spa_off(size_t n);` -/
@[export_c lean_fs_arp_spa_off]
public def fsArpSpaOff (n : USize) : USize :=
  Systems.Arp.spaOff n

/-- ARP target hardware address offset (layout helper).

C ABI: `size_t lean_fs_arp_tha_off(size_t n);` -/
@[export_c lean_fs_arp_tha_off]
public def fsArpThaOff (n : USize) : USize :=
  Systems.Arp.thaOff n

/-- ARP target protocol address offset (layout helper).

C ABI: `size_t lean_fs_arp_tpa_off(size_t n);` -/
@[export_c lean_fs_arp_tpa_off]
public def fsArpTpaOff (n : USize) : USize :=
  Systems.Arp.tpaOff n

/-- Interval occupancy count (pass-through).

C ABI: `size_t lean_fs_interval_count(size_t n);` -/
@[export_c lean_fs_interval_count]
public def fsIntervalCount (n : USize) : USize :=
  Systems.IntervalTree.count n

/-- Interval capacity (pass-through).

C ABI: `size_t lean_fs_interval_cap(size_t cap);` -/
@[export_c lean_fs_interval_cap]
public def fsIntervalCap (cap : USize) : USize :=
  Systems.IntervalTree.cap cap

/-- Interval is-empty occupancy helper.

C ABI: `uint32_t lean_fs_interval_is_empty(size_t n);` -/
@[export_c lean_fs_interval_is_empty]
public def fsIntervalIsEmpty (n : USize) : U32 :=
  Systems.IntervalTree.isEmpty n

/-- Interval is-full occupancy helper.

C ABI: `uint32_t lean_fs_interval_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_interval_is_full]
public def fsIntervalIsFull (cap : USize) (n : USize) : U32 :=
  Systems.IntervalTree.isFull cap n

/-- Interval insert (status dataflow-used).

C ABI: `uint32_t lean_fs_interval_insert(size_t los, size_t his, size_t cap, size_t n, uint32_t lo, uint32_t hi);` -/
@[export_c lean_fs_interval_insert]
public unsafe def fsIntervalInsert (los : USize) (his : USize) (cap : USize) (n : USize)
    (lo : U32) (hi : U32) : U32 :=
  Systems.IntervalTree.insert los his cap n lo hi

/-- Interval point-contains query.

C ABI: `uint32_t lean_fs_interval_contains(size_t los, size_t his, size_t n, uint32_t p);` -/
@[export_c lean_fs_interval_contains]
public unsafe def fsIntervalContains (los : USize) (his : USize) (n : USize) (p : U32) : U32 :=
  Systems.IntervalTree.contains los his n p

/-- Interval overlap query (closed ranges).

C ABI: `uint32_t lean_fs_interval_overlaps(size_t los, size_t his, size_t n, uint32_t qlo, uint32_t qhi);` -/
@[export_c lean_fs_interval_overlaps]
public unsafe def fsIntervalOverlaps (los : USize) (his : USize) (n : USize)
    (qlo : U32) (qhi : U32) : U32 :=
  Systems.IntervalTree.overlaps los his n qlo qhi

/-- SemVer-shaped validate.

C ABI: `uint32_t lean_fs_semver_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_validate]
public unsafe def fsSemverValidate (addr : USize) (n : USize) : U32 :=
  Systems.Semver.validate addr n

/-- SemVer-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_semver_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_scan]
public unsafe def fsSemverScan (addr : USize) (n : USize) : U32 :=
  Systems.Semver.scan addr n

/-- SemVer major component as U32 (0 if invalid/overflow).

C ABI: `uint32_t lean_fs_semver_major(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_major]
public unsafe def fsSemverMajor (addr : USize) (n : USize) : U32 :=
  Systems.Semver.major addr n

/-- SemVer minor component as U32 (0 if invalid/overflow).

C ABI: `uint32_t lean_fs_semver_minor(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_minor]
public unsafe def fsSemverMinor (addr : USize) (n : USize) : U32 :=
  Systems.Semver.minor addr n

/-- SemVer patch component as U32 (0 if invalid/overflow).

C ABI: `uint32_t lean_fs_semver_patch(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_patch]
public unsafe def fsSemverPatch (addr : USize) (n : USize) : U32 :=
  Systems.Semver.patch addr n

/-- SemVer major offset (0 if valid), or miss.

C ABI: `size_t lean_fs_semver_major_off(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_major_off]
public unsafe def fsSemverMajorOff (addr : USize) (n : USize) : USize :=
  Systems.Semver.majorOff addr n

/-- SemVer major length, or 0 if invalid.

C ABI: `size_t lean_fs_semver_major_len(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_major_len]
public unsafe def fsSemverMajorLen (addr : USize) (n : USize) : USize :=
  Systems.Semver.majorLen addr n

/-- SemVer minor offset, or miss.

C ABI: `size_t lean_fs_semver_minor_off(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_minor_off]
public unsafe def fsSemverMinorOff (addr : USize) (n : USize) : USize :=
  Systems.Semver.minorOff addr n

/-- SemVer minor length, or 0 if invalid.

C ABI: `size_t lean_fs_semver_minor_len(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_minor_len]
public unsafe def fsSemverMinorLen (addr : USize) (n : USize) : USize :=
  Systems.Semver.minorLen addr n

/-- SemVer patch offset, or miss.

C ABI: `size_t lean_fs_semver_patch_off(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_patch_off]
public unsafe def fsSemverPatchOff (addr : USize) (n : USize) : USize :=
  Systems.Semver.patchOff addr n

/-- SemVer patch length, or 0 if invalid.

C ABI: `size_t lean_fs_semver_patch_len(size_t addr, size_t n);` -/
@[export_c lean_fs_semver_patch_len]
public unsafe def fsSemverPatchLen (addr : USize) (n : USize) : USize :=
  Systems.Semver.patchLen addr n

/-- GRE-shaped validate (min 4 bytes).

C ABI: `uint32_t lean_fs_gre_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_gre_validate]
public unsafe def fsGreValidate (addr : USize) (n : USize) : U32 :=
  Systems.Gre.validate addr n

/-- GRE-shaped parse (alias of validate).

C ABI: `uint32_t lean_fs_gre_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_gre_parse]
public unsafe def fsGreParse (addr : USize) (n : USize) : U32 :=
  Systems.Gre.parse addr n

/-- GRE flags high nibble.

C ABI: `uint32_t lean_fs_gre_flags(size_t addr, size_t n);` -/
@[export_c lean_fs_gre_flags]
public unsafe def fsGreFlags (addr : USize) (n : USize) : U32 :=
  Systems.Gre.flags addr n

/-- GRE version (low 3 bits of byte 1).

C ABI: `uint32_t lean_fs_gre_version(size_t addr, size_t n);` -/
@[export_c lean_fs_gre_version]
public unsafe def fsGreVersion (addr : USize) (n : USize) : U32 :=
  Systems.Gre.version addr n

/-- GRE protocol type (BE).

C ABI: `uint32_t lean_fs_gre_protocol(size_t addr, size_t n);` -/
@[export_c lean_fs_gre_protocol]
public unsafe def fsGreProtocol (addr : USize) (n : USize) : U32 :=
  Systems.Gre.protocol addr n

/-- Splay occupancy length (pass-through).

C ABI: `size_t lean_fs_splay_len(size_t n);` -/
@[export_c lean_fs_splay_len]
public def fsSplayLen (n : USize) : USize :=
  Systems.Splay.len n

/-- Splay capacity (pass-through).

C ABI: `size_t lean_fs_splay_capacity(size_t cap);` -/
@[export_c lean_fs_splay_capacity]
public def fsSplayCapacity (cap : USize) : USize :=
  Systems.Splay.capacity cap

/-- Splay is-empty occupancy helper.

C ABI: `uint32_t lean_fs_splay_is_empty(size_t n);` -/
@[export_c lean_fs_splay_is_empty]
public def fsSplayIsEmpty (n : USize) : U32 :=
  Systems.Splay.isEmpty n

/-- Splay is-full occupancy helper.

C ABI: `uint32_t lean_fs_splay_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_splay_is_full]
public def fsSplayIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Splay.isFull cap n

/-- Splay lower-bound index.

C ABI: `size_t lean_fs_splay_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_splay_lower_bound]
public unsafe def fsSplayLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.Splay.lowerBound keys n key

/-- Splay contains.

C ABI: `uint32_t lean_fs_splay_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_splay_contains]
public unsafe def fsSplayContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.Splay.contains keys n key

/-- Splay get as USize, or miss.

C ABI: `size_t lean_fs_splay_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_splay_get]
public unsafe def fsSplayGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.Splay.get keys vals n key

/-- Splay get-at as USize, or miss.

C ABI: `size_t lean_fs_splay_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_splay_get_at]
public unsafe def fsSplayGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.Splay.getAt vals n i

/-- Splay insert (status dataflow-used).

C ABI: `uint32_t lean_fs_splay_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_splay_insert]
public unsafe def fsSplayInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.Splay.insert keys vals cap n key val

/-- Splay remove.

C ABI: `uint32_t lean_fs_splay_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_splay_remove]
public unsafe def fsSplayRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.Splay.remove keys vals n key

/-- CBOR-shaped validate (min 1 byte).

C ABI: `uint32_t lean_fs_cbor_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_cbor_validate]
public unsafe def fsCborValidate (addr : USize) (n : USize) : U32 :=
  Systems.Cbor.validate addr n

/-- CBOR-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_cbor_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_cbor_scan]
public unsafe def fsCborScan (addr : USize) (n : USize) : U32 :=
  Systems.Cbor.scan addr n

/-- CBOR major type at offset as USize, or miss.

C ABI: `size_t lean_fs_cbor_major_type(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_cbor_major_type]
public unsafe def fsCborMajorType (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Cbor.majorType addr n off

/-- CBOR additional info (low 5 bits) at offset.

C ABI: `uint32_t lean_fs_cbor_additional_info(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_cbor_additional_info]
public unsafe def fsCborAdditionalInfo (addr : USize) (n : USize) (off : USize) : U32 :=
  Systems.Cbor.additionalInfo addr n off

/-- CBOR small unsigned (type 0, addi < 24) as USize, or miss.

C ABI: `size_t lean_fs_cbor_uint_small(size_t addr, size_t n);` -/
@[export_c lean_fs_cbor_uint_small]
public unsafe def fsCborUintSmall (addr : USize) (n : USize) : USize :=
  Systems.Cbor.uintSmall addr n

/-- IPv4-shaped validate (min 20 bytes).

C ABI: `uint32_t lean_fs_ip_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ip_validate]
public unsafe def fsIpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Ip.validate addr n

/-- IPv4-shaped parse (alias of validate).

C ABI: `uint32_t lean_fs_ip_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_ip_parse]
public unsafe def fsIpParse (addr : USize) (n : USize) : U32 :=
  Systems.Ip.parse addr n

/-- IPv4 version (high nibble of byte 0).

C ABI: `uint32_t lean_fs_ip_version(size_t addr, size_t n);` -/
@[export_c lean_fs_ip_version]
public unsafe def fsIpVersion (addr : USize) (n : USize) : U32 :=
  Systems.Ip.version addr n

/-- IPv4 IHL (low nibble of byte 0).

C ABI: `uint32_t lean_fs_ip_ihl(size_t addr, size_t n);` -/
@[export_c lean_fs_ip_ihl]
public unsafe def fsIpIhl (addr : USize) (n : USize) : U32 :=
  Systems.Ip.ihl addr n

/-- IPv4 total length (BE U16).

C ABI: `uint32_t lean_fs_ip_total_length(size_t addr, size_t n);` -/
@[export_c lean_fs_ip_total_length]
public unsafe def fsIpTotalLength (addr : USize) (n : USize) : U32 :=
  Systems.Ip.totalLength addr n

/-- IPv4 protocol (byte 9).

C ABI: `uint32_t lean_fs_ip_protocol(size_t addr, size_t n);` -/
@[export_c lean_fs_ip_protocol]
public unsafe def fsIpProtocol (addr : USize) (n : USize) : U32 :=
  Systems.Ip.protocol addr n

/-- IPv4 source address offset (always 12).

C ABI: `size_t lean_fs_ip_src_off(size_t n);` -/
@[export_c lean_fs_ip_src_off]
public def fsIpSrcOff (n : USize) : USize :=
  Systems.Ip.srcOff n

/-- IPv4 destination address offset (always 16).

C ABI: `size_t lean_fs_ip_dst_off(size_t n);` -/
@[export_c lean_fs_ip_dst_off]
public def fsIpDstOff (n : USize) : USize :=
  Systems.Ip.dstOff n

/-- BTreeMap occupancy length (pass-through).

C ABI: `size_t lean_fs_btreemap_len(size_t n);` -/
@[export_c lean_fs_btreemap_len]
public def fsBTreeMapLen (n : USize) : USize :=
  Systems.BTreeMap.len n

/-- BTreeMap capacity (pass-through).

C ABI: `size_t lean_fs_btreemap_capacity(size_t cap);` -/
@[export_c lean_fs_btreemap_capacity]
public def fsBTreeMapCapacity (cap : USize) : USize :=
  Systems.BTreeMap.capacity cap

/-- BTreeMap is-empty occupancy helper.

C ABI: `uint32_t lean_fs_btreemap_is_empty(size_t n);` -/
@[export_c lean_fs_btreemap_is_empty]
public def fsBTreeMapIsEmpty (n : USize) : U32 :=
  Systems.BTreeMap.isEmpty n

/-- BTreeMap is-full occupancy helper.

C ABI: `uint32_t lean_fs_btreemap_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_btreemap_is_full]
public def fsBTreeMapIsFull (cap : USize) (n : USize) : U32 :=
  Systems.BTreeMap.isFull cap n

/-- BTreeMap lower-bound index.

C ABI: `size_t lean_fs_btreemap_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_btreemap_lower_bound]
public unsafe def fsBTreeMapLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.BTreeMap.lowerBound keys n key

/-- BTreeMap contains.

C ABI: `uint32_t lean_fs_btreemap_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_btreemap_contains]
public unsafe def fsBTreeMapContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.BTreeMap.contains keys n key

/-- BTreeMap get as USize, or miss.

C ABI: `size_t lean_fs_btreemap_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_btreemap_get]
public unsafe def fsBTreeMapGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.BTreeMap.get keys vals n key

/-- BTreeMap get-at as USize, or miss.

C ABI: `size_t lean_fs_btreemap_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_btreemap_get_at]
public unsafe def fsBTreeMapGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.BTreeMap.getAt vals n i

/-- BTreeMap insert (status dataflow-used).

C ABI: `uint32_t lean_fs_btreemap_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_btreemap_insert]
public unsafe def fsBTreeMapInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.BTreeMap.insert keys vals cap n key val

/-- BTreeMap remove.

C ABI: `uint32_t lean_fs_btreemap_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_btreemap_remove]
public unsafe def fsBTreeMapRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.BTreeMap.remove keys vals n key

/-- TOML query-shaped validate.

C ABI: `uint32_t lean_fs_tomlq_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlq_validate]
public unsafe def fsTomlQValidate (addr : USize) (n : USize) : U32 :=
  Systems.TomlQuery.validate addr n

/-- TOML query-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_tomlq_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlq_scan]
public unsafe def fsTomlQScan (addr : USize) (n : USize) : U32 :=
  Systems.TomlQuery.scan addr n

/-- TOML query find key offset, or miss.

C ABI: `size_t lean_fs_tomlq_find_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_tomlq_find_key]
public unsafe def fsTomlQFindKey (addr : USize) (n : USize) (key : USize) (keyLen : USize) : USize :=
  Systems.TomlQuery.findKey addr n key keyLen

/-- TOML query value offset for key start.

C ABI: `size_t lean_fs_tomlq_value_off(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_tomlq_value_off]
public unsafe def fsTomlQValueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.TomlQuery.valueOff addr n keyOff

/-- TOML query value length for key start.

C ABI: `size_t lean_fs_tomlq_value_len(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_tomlq_value_len]
public unsafe def fsTomlQValueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.TomlQuery.valueLen addr n keyOff

/-- TOML query has-key.

C ABI: `uint32_t lean_fs_tomlq_has_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_tomlq_has_key]
public unsafe def fsTomlQHasKey (addr : USize) (n : USize) (key : USize) (keyLen : USize) : U32 :=
  Systems.TomlQuery.hasKey addr n key keyLen

/-- UDP-shaped validate (min 8 bytes).

C ABI: `uint32_t lean_fs_udp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_udp_validate]
public unsafe def fsUdpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Udp.validate addr n

/-- UDP-shaped parse (alias of validate).

C ABI: `uint32_t lean_fs_udp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_udp_parse]
public unsafe def fsUdpParse (addr : USize) (n : USize) : U32 :=
  Systems.Udp.parse addr n

/-- UDP source port (BE U16).

C ABI: `uint32_t lean_fs_udp_src_port(size_t addr, size_t n);` -/
@[export_c lean_fs_udp_src_port]
public unsafe def fsUdpSrcPort (addr : USize) (n : USize) : U32 :=
  Systems.Udp.srcPort addr n

/-- UDP destination port (BE U16).

C ABI: `uint32_t lean_fs_udp_dst_port(size_t addr, size_t n);` -/
@[export_c lean_fs_udp_dst_port]
public unsafe def fsUdpDstPort (addr : USize) (n : USize) : U32 :=
  Systems.Udp.dstPort addr n

/-- UDP length field (BE U16).

C ABI: `uint32_t lean_fs_udp_length(size_t addr, size_t n);` -/
@[export_c lean_fs_udp_length]
public unsafe def fsUdpLength (addr : USize) (n : USize) : U32 :=
  Systems.Udp.length addr n

/-- UDP checksum field (BE U16; layout only).

C ABI: `uint32_t lean_fs_udp_checksum(size_t addr, size_t n);` -/
@[export_c lean_fs_udp_checksum]
public unsafe def fsUdpChecksum (addr : USize) (n : USize) : U32 :=
  Systems.Udp.checksum addr n

/-- SkipListMap occupancy length (pass-through).

C ABI: `size_t lean_fs_skipmap_len(size_t n);` -/
@[export_c lean_fs_skipmap_len]
public def fsSkipMapLen (n : USize) : USize :=
  Systems.SkipListMap.len n

/-- SkipListMap capacity (pass-through).

C ABI: `size_t lean_fs_skipmap_capacity(size_t cap);` -/
@[export_c lean_fs_skipmap_capacity]
public def fsSkipMapCapacity (cap : USize) : USize :=
  Systems.SkipListMap.capacity cap

/-- SkipListMap is-empty occupancy helper.

C ABI: `uint32_t lean_fs_skipmap_is_empty(size_t n);` -/
@[export_c lean_fs_skipmap_is_empty]
public def fsSkipMapIsEmpty (n : USize) : U32 :=
  Systems.SkipListMap.isEmpty n

/-- SkipListMap is-full occupancy helper.

C ABI: `uint32_t lean_fs_skipmap_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_skipmap_is_full]
public def fsSkipMapIsFull (cap : USize) (n : USize) : U32 :=
  Systems.SkipListMap.isFull cap n

/-- SkipListMap lower-bound index.

C ABI: `size_t lean_fs_skipmap_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_skipmap_lower_bound]
public unsafe def fsSkipMapLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.SkipListMap.lowerBound keys n key

/-- SkipListMap contains.

C ABI: `uint32_t lean_fs_skipmap_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_skipmap_contains]
public unsafe def fsSkipMapContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.SkipListMap.contains keys n key

/-- SkipListMap get as USize, or miss.

C ABI: `size_t lean_fs_skipmap_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_skipmap_get]
public unsafe def fsSkipMapGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.SkipListMap.get keys vals n key

/-- SkipListMap get-at as USize, or miss.

C ABI: `size_t lean_fs_skipmap_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_skipmap_get_at]
public unsafe def fsSkipMapGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.SkipListMap.getAt vals n i

/-- SkipListMap insert (status dataflow-used).

C ABI: `uint32_t lean_fs_skipmap_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_skipmap_insert]
public unsafe def fsSkipMapInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.SkipListMap.insert keys vals cap n key val

/-- SkipListMap remove.

C ABI: `uint32_t lean_fs_skipmap_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_skipmap_remove]
public unsafe def fsSkipMapRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.SkipListMap.remove keys vals n key

/-- EDN-shaped validate.

C ABI: `uint32_t lean_fs_edn_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_edn_validate]
public unsafe def fsEdnValidate (addr : USize) (n : USize) : U32 :=
  Systems.Edn.validate addr n

/-- EDN-shaped scan (alias of validate).

C ABI: `uint32_t lean_fs_edn_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_edn_scan]
public unsafe def fsEdnScan (addr : USize) (n : USize) : U32 :=
  Systems.Edn.scan addr n

/-- EDN max nesting depth, or miss.

C ABI: `size_t lean_fs_edn_max_depth(size_t addr, size_t n);` -/
@[export_c lean_fs_edn_max_depth]
public unsafe def fsEdnMaxDepth (addr : USize) (n : USize) : USize :=
  Systems.Edn.maxDepth addr n

/-- EDN atom count, or miss.

C ABI: `size_t lean_fs_edn_atom_count(size_t addr, size_t n);` -/
@[export_c lean_fs_edn_atom_count]
public unsafe def fsEdnAtomCount (addr : USize) (n : USize) : USize :=
  Systems.Edn.atomCount addr n

/-- TCP-shaped validate (min 20 bytes).

C ABI: `uint32_t lean_fs_tcp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_validate]
public unsafe def fsTcpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.validate addr n

/-- TCP-shaped parse (alias of validate).

C ABI: `uint32_t lean_fs_tcp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_parse]
public unsafe def fsTcpParse (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.parse addr n

/-- TCP source port (BE U16).

C ABI: `uint32_t lean_fs_tcp_src_port(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_src_port]
public unsafe def fsTcpSrcPort (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.srcPort addr n

/-- TCP destination port (BE U16).

C ABI: `uint32_t lean_fs_tcp_dst_port(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_dst_port]
public unsafe def fsTcpDstPort (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.dstPort addr n

/-- TCP sequence number (BE U32).

C ABI: `uint32_t lean_fs_tcp_seq(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_seq]
public unsafe def fsTcpSeq (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.seq addr n

/-- TCP acknowledgment number (BE U32).

C ABI: `uint32_t lean_fs_tcp_ack(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_ack]
public unsafe def fsTcpAck (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.ack addr n

/-- TCP data offset (high nibble of byte 12).

C ABI: `uint32_t lean_fs_tcp_data_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_data_off]
public unsafe def fsTcpDataOff (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.dataOff addr n

/-- TCP flags byte.

C ABI: `uint32_t lean_fs_tcp_flags(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_flags]
public unsafe def fsTcpFlags (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.flags addr n

/-- TCP window (BE U16).

C ABI: `uint32_t lean_fs_tcp_window(size_t addr, size_t n);` -/
@[export_c lean_fs_tcp_window]
public unsafe def fsTcpWindow (addr : USize) (n : USize) : U32 :=
  Systems.Tcp.window addr n

/-- HashMap occupancy length (pass-through).

C ABI: `size_t lean_fs_hashmap_len(size_t n);` -/
@[export_c lean_fs_hashmap_len]
public def fsHashMapLen (n : USize) : USize :=
  Systems.HashMap.len n

/-- HashMap capacity (pass-through).

C ABI: `size_t lean_fs_hashmap_capacity(size_t cap);` -/
@[export_c lean_fs_hashmap_capacity]
public def fsHashMapCapacity (cap : USize) : USize :=
  Systems.HashMap.capacity cap

/-- HashMap is-empty occupancy helper.

C ABI: `uint32_t lean_fs_hashmap_is_empty(size_t n);` -/
@[export_c lean_fs_hashmap_is_empty]
public def fsHashMapIsEmpty (n : USize) : U32 :=
  Systems.HashMap.isEmpty n

/-- HashMap is-full occupancy helper.

C ABI: `uint32_t lean_fs_hashmap_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_hashmap_is_full]
public def fsHashMapIsFull (cap : USize) (n : USize) : U32 :=
  Systems.HashMap.isFull cap n

/-- HashMap lower-bound index.

C ABI: `size_t lean_fs_hashmap_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_hashmap_lower_bound]
public unsafe def fsHashMapLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.HashMap.lowerBound keys n key

/-- HashMap contains.

C ABI: `uint32_t lean_fs_hashmap_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_hashmap_contains]
public unsafe def fsHashMapContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.HashMap.contains keys n key

/-- HashMap get as USize, or miss.

C ABI: `size_t lean_fs_hashmap_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_hashmap_get]
public unsafe def fsHashMapGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.HashMap.get keys vals n key

/-- HashMap get-at as USize, or miss.

C ABI: `size_t lean_fs_hashmap_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_hashmap_get_at]
public unsafe def fsHashMapGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.HashMap.getAt vals n i

/-- HashMap insert (status dataflow-used).

C ABI: `uint32_t lean_fs_hashmap_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_hashmap_insert]
public unsafe def fsHashMapInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.HashMap.insert keys vals cap n key val

/-- HashMap remove.

C ABI: `uint32_t lean_fs_hashmap_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_hashmap_remove]
public unsafe def fsHashMapRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.HashMap.remove keys vals n key

/-- MsgPack first-byte validate (length-class).

C ABI: `uint32_t lean_fs_msgpack_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_msgpack_validate]
public unsafe def fsMsgPackValidate (addr : USize) (n : USize) : U32 :=
  Systems.MsgPack.validate addr n

/-- MsgPack first-byte scan (alias of validate).

C ABI: `uint32_t lean_fs_msgpack_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_msgpack_scan]
public unsafe def fsMsgPackScan (addr : USize) (n : USize) : U32 :=
  Systems.MsgPack.scan addr n

/-- MsgPack first-byte family (`0..5`), or miss.

C ABI: `size_t lean_fs_msgpack_family(size_t addr, size_t n);` -/
@[export_c lean_fs_msgpack_family]
public unsafe def fsMsgPackFamily (addr : USize) (n : USize) : USize :=
  Systems.MsgPack.family addr n

/-- MsgPack first-byte marker.

C ABI: `uint32_t lean_fs_msgpack_marker(size_t addr, size_t n);` -/
@[export_c lean_fs_msgpack_marker]
public unsafe def fsMsgPackMarker (addr : USize) (n : USize) : U32 :=
  Systems.MsgPack.marker addr n

/-- MsgPack positive fixint small decode, or miss.

C ABI: `size_t lean_fs_msgpack_pos_int_small(size_t addr, size_t n);` -/
@[export_c lean_fs_msgpack_pos_int_small]
public unsafe def fsMsgPackPosIntSmall (addr : USize) (n : USize) : USize :=
  Systems.MsgPack.posIntSmall addr n

/-- ICMPv6 header validate (min 8).

C ABI: `uint32_t lean_fs_icmpv6_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_icmpv6_validate]
public unsafe def fsIcmpv6Validate (addr : USize) (n : USize) : U32 :=
  Systems.Icmpv6.validate addr n

/-- ICMPv6 header parse (alias of validate).

C ABI: `uint32_t lean_fs_icmpv6_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_icmpv6_parse]
public unsafe def fsIcmpv6Parse (addr : USize) (n : USize) : U32 :=
  Systems.Icmpv6.parse addr n

/-- ICMPv6 type.

C ABI: `uint32_t lean_fs_icmpv6_type(size_t addr, size_t n);` -/
@[export_c lean_fs_icmpv6_type]
public unsafe def fsIcmpv6Type (addr : USize) (n : USize) : U32 :=
  Systems.Icmpv6.type addr n

/-- ICMPv6 code.

C ABI: `uint32_t lean_fs_icmpv6_code(size_t addr, size_t n);` -/
@[export_c lean_fs_icmpv6_code]
public unsafe def fsIcmpv6Code (addr : USize) (n : USize) : U32 :=
  Systems.Icmpv6.code addr n

/-- ICMPv6 checksum (BE U16).

C ABI: `uint32_t lean_fs_icmpv6_checksum(size_t addr, size_t n);` -/
@[export_c lean_fs_icmpv6_checksum]
public unsafe def fsIcmpv6Checksum (addr : USize) (n : USize) : U32 :=
  Systems.Icmpv6.checksum addr n

/-- ICMPv6 echo-shaped identifier (BE U16).

C ABI: `uint32_t lean_fs_icmpv6_id(size_t addr, size_t n);` -/
@[export_c lean_fs_icmpv6_id]
public unsafe def fsIcmpv6Id (addr : USize) (n : USize) : U32 :=
  Systems.Icmpv6.id addr n

/-- ICMPv6 echo-shaped sequence (BE U16).

C ABI: `uint32_t lean_fs_icmpv6_seq(size_t addr, size_t n);` -/
@[export_c lean_fs_icmpv6_seq]
public unsafe def fsIcmpv6Seq (addr : USize) (n : USize) : U32 :=
  Systems.Icmpv6.seq addr n

/-- LinkedHashMap occupancy length (pass-through).

C ABI: `size_t lean_fs_lhm_len(size_t n);` -/
@[export_c lean_fs_lhm_len]
public def fsLhmLen (n : USize) : USize :=
  Systems.LinkedHashMap.len n

/-- LinkedHashMap capacity (pass-through).

C ABI: `size_t lean_fs_lhm_capacity(size_t cap);` -/
@[export_c lean_fs_lhm_capacity]
public def fsLhmCapacity (cap : USize) : USize :=
  Systems.LinkedHashMap.capacity cap

/-- LinkedHashMap is-empty occupancy helper.

C ABI: `uint32_t lean_fs_lhm_is_empty(size_t n);` -/
@[export_c lean_fs_lhm_is_empty]
public def fsLhmIsEmpty (n : USize) : U32 :=
  Systems.LinkedHashMap.isEmpty n

/-- LinkedHashMap is-full occupancy helper.

C ABI: `uint32_t lean_fs_lhm_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_lhm_is_full]
public def fsLhmIsFull (cap : USize) (n : USize) : U32 :=
  Systems.LinkedHashMap.isFull cap n

/-- LinkedHashMap lower-bound index.

C ABI: `size_t lean_fs_lhm_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_lhm_lower_bound]
public unsafe def fsLhmLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.LinkedHashMap.lowerBound keys n key

/-- LinkedHashMap contains.

C ABI: `uint32_t lean_fs_lhm_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_lhm_contains]
public unsafe def fsLhmContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.LinkedHashMap.contains keys n key

/-- LinkedHashMap get as USize, or miss.

C ABI: `size_t lean_fs_lhm_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_lhm_get]
public unsafe def fsLhmGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.LinkedHashMap.get keys vals n key

/-- LinkedHashMap get-at as USize, or miss.

C ABI: `size_t lean_fs_lhm_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_lhm_get_at]
public unsafe def fsLhmGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.LinkedHashMap.getAt vals n i

/-- LinkedHashMap insert (status dataflow-used).

C ABI: `uint32_t lean_fs_lhm_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_lhm_insert]
public unsafe def fsLhmInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.LinkedHashMap.insert keys vals cap n key val

/-- LinkedHashMap remove.

C ABI: `uint32_t lean_fs_lhm_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_lhm_remove]
public unsafe def fsLhmRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.LinkedHashMap.remove keys vals n key

/-- Protobuf wire-key validate (length-class).

C ABI: `uint32_t lean_fs_pb_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_pb_validate]
public unsafe def fsPbValidate (addr : USize) (n : USize) : U32 :=
  Systems.Protobuf.validate addr n

/-- Protobuf wire-key scan (alias of validate).

C ABI: `uint32_t lean_fs_pb_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_pb_scan]
public unsafe def fsPbScan (addr : USize) (n : USize) : U32 :=
  Systems.Protobuf.scan addr n

/-- Protobuf raw field-key byte at offset.

C ABI: `uint32_t lean_fs_pb_field_key(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_pb_field_key]
public unsafe def fsPbFieldKey (addr : USize) (n : USize) (off : USize) : U32 :=
  Systems.Protobuf.fieldKey addr n off

/-- Protobuf wire type (low 3 bits) at offset.

C ABI: `uint32_t lean_fs_pb_wire_type(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_pb_wire_type]
public unsafe def fsPbWireType (addr : USize) (n : USize) (off : USize) : U32 :=
  Systems.Protobuf.wireType addr n off

/-- Protobuf field number from single-byte key, or miss.

C ABI: `size_t lean_fs_pb_field_number(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_pb_field_number]
public unsafe def fsPbFieldNumber (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Protobuf.fieldNumber addr n off

/-- Protobuf single-byte varint small decode, or miss.

C ABI: `size_t lean_fs_pb_varint_small(size_t addr, size_t n);` -/
@[export_c lean_fs_pb_varint_small]
public unsafe def fsPbVarintSmall (addr : USize) (n : USize) : USize :=
  Systems.Protobuf.varintSmall addr n

/-- SCTP common-header validate (length-class).

C ABI: `uint32_t lean_fs_sctp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_sctp_validate]
public unsafe def fsSctpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Sctp.validate addr n

/-- SCTP common-header parse (alias of validate).

C ABI: `uint32_t lean_fs_sctp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_sctp_parse]
public unsafe def fsSctpParse (addr : USize) (n : USize) : U32 :=
  Systems.Sctp.parse addr n

/-- SCTP source port (BE U16).

C ABI: `uint32_t lean_fs_sctp_src_port(size_t addr, size_t n);` -/
@[export_c lean_fs_sctp_src_port]
public unsafe def fsSctpSrcPort (addr : USize) (n : USize) : U32 :=
  Systems.Sctp.srcPort addr n

/-- SCTP destination port (BE U16).

C ABI: `uint32_t lean_fs_sctp_dst_port(size_t addr, size_t n);` -/
@[export_c lean_fs_sctp_dst_port]
public unsafe def fsSctpDstPort (addr : USize) (n : USize) : U32 :=
  Systems.Sctp.dstPort addr n

/-- SCTP verification tag (BE U32).

C ABI: `uint32_t lean_fs_sctp_vtag(size_t addr, size_t n);` -/
@[export_c lean_fs_sctp_vtag]
public unsafe def fsSctpVtag (addr : USize) (n : USize) : U32 :=
  Systems.Sctp.vtag addr n

/-- SCTP checksum field (BE U32; layout only).

C ABI: `uint32_t lean_fs_sctp_checksum(size_t addr, size_t n);` -/
@[export_c lean_fs_sctp_checksum]
public unsafe def fsSctpChecksum (addr : USize) (n : USize) : U32 :=
  Systems.Sctp.checksum addr n

/-- OrderedMap occupancy length (pass-through).

C ABI: `size_t lean_fs_ordmap_len(size_t n);` -/
@[export_c lean_fs_ordmap_len]
public def fsOrdmapLen (n : USize) : USize :=
  Systems.OrderedMap.len n

/-- OrderedMap capacity (pass-through).

C ABI: `size_t lean_fs_ordmap_capacity(size_t cap);` -/
@[export_c lean_fs_ordmap_capacity]
public def fsOrdmapCapacity (cap : USize) : USize :=
  Systems.OrderedMap.capacity cap

/-- OrderedMap is-empty occupancy helper.

C ABI: `uint32_t lean_fs_ordmap_is_empty(size_t n);` -/
@[export_c lean_fs_ordmap_is_empty]
public def fsOrdmapIsEmpty (n : USize) : U32 :=
  Systems.OrderedMap.isEmpty n

/-- OrderedMap is-full occupancy helper.

C ABI: `uint32_t lean_fs_ordmap_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_ordmap_is_full]
public def fsOrdmapIsFull (cap : USize) (n : USize) : U32 :=
  Systems.OrderedMap.isFull cap n

/-- OrderedMap lower-bound index.

C ABI: `size_t lean_fs_ordmap_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_ordmap_lower_bound]
public unsafe def fsOrdmapLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.OrderedMap.lowerBound keys n key

/-- OrderedMap contains.

C ABI: `uint32_t lean_fs_ordmap_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_ordmap_contains]
public unsafe def fsOrdmapContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.OrderedMap.contains keys n key

/-- OrderedMap get as USize, or miss.

C ABI: `size_t lean_fs_ordmap_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_ordmap_get]
public unsafe def fsOrdmapGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.OrderedMap.get keys vals n key

/-- OrderedMap get-at as USize, or miss.

C ABI: `size_t lean_fs_ordmap_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_ordmap_get_at]
public unsafe def fsOrdmapGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.OrderedMap.getAt vals n i

/-- OrderedMap insert (status dataflow-used).

C ABI: `uint32_t lean_fs_ordmap_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_ordmap_insert]
public unsafe def fsOrdmapInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.OrderedMap.insert keys vals cap n key val

/-- OrderedMap remove.

C ABI: `uint32_t lean_fs_ordmap_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_ordmap_remove]
public unsafe def fsOrdmapRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.OrderedMap.remove keys vals n key

/-- Avro first-byte validate (length-class).

C ABI: `uint32_t lean_fs_avro_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_avro_validate]
public unsafe def fsAvroValidate (addr : USize) (n : USize) : U32 :=
  Systems.Avro.validate addr n

/-- Avro first-byte scan (alias of validate).

C ABI: `uint32_t lean_fs_avro_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_avro_scan]
public unsafe def fsAvroScan (addr : USize) (n : USize) : U32 :=
  Systems.Avro.scan addr n

/-- Avro first-byte marker.

C ABI: `uint32_t lean_fs_avro_marker(size_t addr, size_t n);` -/
@[export_c lean_fs_avro_marker]
public unsafe def fsAvroMarker (addr : USize) (n : USize) : U32 :=
  Systems.Avro.marker addr n

/-- Avro boolean small decode, or miss.

C ABI: `size_t lean_fs_avro_bool_small(size_t addr, size_t n);` -/
@[export_c lean_fs_avro_bool_small]
public unsafe def fsAvroBoolSmall (addr : USize) (n : USize) : USize :=
  Systems.Avro.boolSmall addr n

/-- Avro non-negative zigzag small decode, or miss.

C ABI: `size_t lean_fs_avro_zigzag_nonneg_small(size_t addr, size_t n);` -/
@[export_c lean_fs_avro_zigzag_nonneg_small]
public unsafe def fsAvroZigzagNonnegSmall (addr : USize) (n : USize) : USize :=
  Systems.Avro.zigzagNonnegSmall addr n

/-- Avro single-byte varint small decode, or miss.

C ABI: `size_t lean_fs_avro_varint_small(size_t addr, size_t n);` -/
@[export_c lean_fs_avro_varint_small]
public unsafe def fsAvroVarintSmall (addr : USize) (n : USize) : USize :=
  Systems.Avro.varintSmall addr n

/-- DCCP generic-header validate (length-class).

C ABI: `uint32_t lean_fs_dccp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_dccp_validate]
public unsafe def fsDccpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Dccp.validate addr n

/-- DCCP generic-header parse (alias of validate).

C ABI: `uint32_t lean_fs_dccp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_dccp_parse]
public unsafe def fsDccpParse (addr : USize) (n : USize) : U32 :=
  Systems.Dccp.parse addr n

/-- DCCP source port (BE U16).

C ABI: `uint32_t lean_fs_dccp_src_port(size_t addr, size_t n);` -/
@[export_c lean_fs_dccp_src_port]
public unsafe def fsDccpSrcPort (addr : USize) (n : USize) : U32 :=
  Systems.Dccp.srcPort addr n

/-- DCCP destination port (BE U16).

C ABI: `uint32_t lean_fs_dccp_dst_port(size_t addr, size_t n);` -/
@[export_c lean_fs_dccp_dst_port]
public unsafe def fsDccpDstPort (addr : USize) (n : USize) : U32 :=
  Systems.Dccp.dstPort addr n

/-- DCCP packet type (bits 4–1 of byte 8).

C ABI: `uint32_t lean_fs_dccp_type(size_t addr, size_t n);` -/
@[export_c lean_fs_dccp_type]
public unsafe def fsDccpType (addr : USize) (n : USize) : U32 :=
  Systems.Dccp.pktType addr n

/-- DCCP CCVal (high 4 bits of byte 5).

C ABI: `uint32_t lean_fs_dccp_ccval(size_t addr, size_t n);` -/
@[export_c lean_fs_dccp_ccval]
public unsafe def fsDccpCcVal (addr : USize) (n : USize) : U32 :=
  Systems.Dccp.ccVal addr n

/-- DCCP X bit (bit 0 of byte 8).

C ABI: `uint32_t lean_fs_dccp_x_bit(size_t addr, size_t n);` -/
@[export_c lean_fs_dccp_x_bit]
public unsafe def fsDccpXBit (addr : USize) (n : USize) : U32 :=
  Systems.Dccp.xBit addr n

/-- TreeMap occupancy length (pass-through).

C ABI: `size_t lean_fs_treemap_len(size_t n);` -/
@[export_c lean_fs_treemap_len]
public def fsTreemapLen (n : USize) : USize :=
  Systems.TreeMap.len n

/-- TreeMap capacity (pass-through).

C ABI: `size_t lean_fs_treemap_capacity(size_t cap);` -/
@[export_c lean_fs_treemap_capacity]
public def fsTreemapCapacity (cap : USize) : USize :=
  Systems.TreeMap.capacity cap

/-- TreeMap is-empty occupancy helper.

C ABI: `uint32_t lean_fs_treemap_is_empty(size_t n);` -/
@[export_c lean_fs_treemap_is_empty]
public def fsTreemapIsEmpty (n : USize) : U32 :=
  Systems.TreeMap.isEmpty n

/-- TreeMap is-full occupancy helper.

C ABI: `uint32_t lean_fs_treemap_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_treemap_is_full]
public def fsTreemapIsFull (cap : USize) (n : USize) : U32 :=
  Systems.TreeMap.isFull cap n

/-- TreeMap lower-bound index.

C ABI: `size_t lean_fs_treemap_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_treemap_lower_bound]
public unsafe def fsTreemapLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.TreeMap.lowerBound keys n key

/-- TreeMap contains.

C ABI: `uint32_t lean_fs_treemap_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_treemap_contains]
public unsafe def fsTreemapContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.TreeMap.contains keys n key

/-- TreeMap get as USize, or miss.

C ABI: `size_t lean_fs_treemap_get(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_treemap_get]
public unsafe def fsTreemapGet (keys : USize) (vals : USize) (n : USize) (key : U32) : USize :=
  Systems.TreeMap.get keys vals n key

/-- TreeMap get-at as USize, or miss.

C ABI: `size_t lean_fs_treemap_get_at(size_t vals, size_t n, size_t i);` -/
@[export_c lean_fs_treemap_get_at]
public unsafe def fsTreemapGetAt (vals : USize) (n : USize) (i : USize) : USize :=
  Systems.TreeMap.getAt vals n i

/-- TreeMap insert (status dataflow-used).

C ABI: `uint32_t lean_fs_treemap_insert(size_t keys, size_t vals, size_t cap, size_t n, uint32_t key, uint32_t val);` -/
@[export_c lean_fs_treemap_insert]
public unsafe def fsTreemapInsert (keys : USize) (vals : USize) (cap : USize) (n : USize)
    (key : U32) (val : U32) : U32 :=
  Systems.TreeMap.insert keys vals cap n key val

/-- TreeMap remove.

C ABI: `uint32_t lean_fs_treemap_remove(size_t keys, size_t vals, size_t n, uint32_t key);` -/
@[export_c lean_fs_treemap_remove]
public unsafe def fsTreemapRemove (keys : USize) (vals : USize) (n : USize) (key : U32) : U32 :=
  Systems.TreeMap.remove keys vals n key

/-- Cap'n Proto first-word validate (length-class).

C ABI: `uint32_t lean_fs_capnp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_capnp_validate]
public unsafe def fsCapnpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Capnp.validate addr n

/-- Cap'n Proto first-word scan (alias of validate).

C ABI: `uint32_t lean_fs_capnp_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_capnp_scan]
public unsafe def fsCapnpScan (addr : USize) (n : USize) : U32 :=
  Systems.Capnp.scan addr n

/-- Cap'n Proto pointer type (low 2 bits).

C ABI: `uint32_t lean_fs_capnp_ptr_type(size_t addr, size_t n);` -/
@[export_c lean_fs_capnp_ptr_type]
public unsafe def fsCapnpPtrType (addr : USize) (n : USize) : U32 :=
  Systems.Capnp.ptrType addr n

/-- Cap'n Proto is-struct helper.

C ABI: `uint32_t lean_fs_capnp_is_struct(size_t addr, size_t n);` -/
@[export_c lean_fs_capnp_is_struct]
public unsafe def fsCapnpIsStruct (addr : USize) (n : USize) : U32 :=
  Systems.Capnp.isStruct addr n

/-- Cap'n Proto is-list helper.

C ABI: `uint32_t lean_fs_capnp_is_list(size_t addr, size_t n);` -/
@[export_c lean_fs_capnp_is_list]
public unsafe def fsCapnpIsList (addr : USize) (n : USize) : U32 :=
  Systems.Capnp.isList addr n

/-- Cap'n Proto is-far helper.

C ABI: `uint32_t lean_fs_capnp_is_far(size_t addr, size_t n);` -/
@[export_c lean_fs_capnp_is_far]
public unsafe def fsCapnpIsFar (addr : USize) (n : USize) : U32 :=
  Systems.Capnp.isFar addr n

/-- Cap'n Proto first 4 LE bytes of word0.

C ABI: `uint32_t lean_fs_capnp_word0_lo(size_t addr, size_t n);` -/
@[export_c lean_fs_capnp_word0_lo]
public unsafe def fsCapnpWord0Lo (addr : USize) (n : USize) : U32 :=
  Systems.Capnp.word0Lo addr n

/-- Cap'n Proto struct offset-in-words (small), or miss.

C ABI: `size_t lean_fs_capnp_offset_words_small(size_t addr, size_t n);` -/
@[export_c lean_fs_capnp_offset_words_small]
public unsafe def fsCapnpOffsetWordsSmall (addr : USize) (n : USize) : USize :=
  Systems.Capnp.offsetWordsSmall addr n

/-- QUIC long-header validate (length-class).

C ABI: `uint32_t lean_fs_quic_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_quic_validate]
public unsafe def fsQuicValidate (addr : USize) (n : USize) : U32 :=
  Systems.Quic.validate addr n

/-- QUIC long-header parse (alias of validate).

C ABI: `uint32_t lean_fs_quic_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_quic_parse]
public unsafe def fsQuicParse (addr : USize) (n : USize) : U32 :=
  Systems.Quic.parse addr n

/-- QUIC is-long-header helper.

C ABI: `uint32_t lean_fs_quic_is_long_header(size_t addr, size_t n);` -/
@[export_c lean_fs_quic_is_long_header]
public unsafe def fsQuicIsLongHeader (addr : USize) (n : USize) : U32 :=
  Systems.Quic.isLongHeader addr n

/-- QUIC version (BE U32).

C ABI: `uint32_t lean_fs_quic_version(size_t addr, size_t n);` -/
@[export_c lean_fs_quic_version]
public unsafe def fsQuicVersion (addr : USize) (n : USize) : U32 :=
  Systems.Quic.version addr n

/-- QUIC DCID length byte.

C ABI: `uint32_t lean_fs_quic_dcid_len(size_t addr, size_t n);` -/
@[export_c lean_fs_quic_dcid_len]
public unsafe def fsQuicDcidLen (addr : USize) (n : USize) : U32 :=
  Systems.Quic.dcidLen addr n

/-- QUIC SCID length byte.

C ABI: `uint32_t lean_fs_quic_scid_len(size_t addr, size_t n);` -/
@[export_c lean_fs_quic_scid_len]
public unsafe def fsQuicScidLen (addr : USize) (n : USize) : U32 :=
  Systems.Quic.scidLen addr n

/-- QUIC long-header packet type (bits 5–4).

C ABI: `uint32_t lean_fs_quic_type(size_t addr, size_t n);` -/
@[export_c lean_fs_quic_type]
public unsafe def fsQuicType (addr : USize) (n : USize) : U32 :=
  Systems.Quic.pktType addr n

/-- FlatBuffers root-offset validate (length-class).

C ABI: `uint32_t lean_fs_flatbuffers_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_flatbuffers_validate]
public unsafe def fsFlatbuffersValidate (addr : USize) (n : USize) : U32 :=
  Systems.FlatBuffers.validate addr n

/-- FlatBuffers root-offset scan (alias of validate).

C ABI: `uint32_t lean_fs_flatbuffers_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_flatbuffers_scan]
public unsafe def fsFlatbuffersScan (addr : USize) (n : USize) : U32 :=
  Systems.FlatBuffers.scan addr n

/-- FlatBuffers root uoffset (LE U32).

C ABI: `uint32_t lean_fs_flatbuffers_root_uoffset(size_t addr, size_t n);` -/
@[export_c lean_fs_flatbuffers_root_uoffset]
public unsafe def fsFlatbuffersRootUOffset (addr : USize) (n : USize) : U32 :=
  Systems.FlatBuffers.rootUOffset addr n

/-- FlatBuffers root-in-bounds helper.

C ABI: `uint32_t lean_fs_flatbuffers_root_in_bounds(size_t addr, size_t n);` -/
@[export_c lean_fs_flatbuffers_root_in_bounds]
public unsafe def fsFlatbuffersRootInBounds (addr : USize) (n : USize) : U32 :=
  Systems.FlatBuffers.rootInBounds addr n

/-- FlatBuffers root-table soffset raw bits as USize, or miss.

C ABI: `size_t lean_fs_flatbuffers_vtable_offset_at(size_t addr, size_t n);` -/
@[export_c lean_fs_flatbuffers_vtable_offset_at]
public unsafe def fsFlatbuffersVtableOffsetAt (addr : USize) (n : USize) : USize :=
  Systems.FlatBuffers.vtableOffsetAt addr n

/-- MQTT fixed-header validate (length-class).

C ABI: `uint32_t lean_fs_mqtt_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_mqtt_validate]
public unsafe def fsMqttValidate (addr : USize) (n : USize) : U32 :=
  Systems.Mqtt.validate addr n

/-- MQTT fixed-header parse (alias of validate).

C ABI: `uint32_t lean_fs_mqtt_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_mqtt_parse]
public unsafe def fsMqttParse (addr : USize) (n : USize) : U32 :=
  Systems.Mqtt.parse addr n

/-- MQTT packet type (high nibble).

C ABI: `uint32_t lean_fs_mqtt_type(size_t addr, size_t n);` -/
@[export_c lean_fs_mqtt_type]
public unsafe def fsMqttType (addr : USize) (n : USize) : U32 :=
  Systems.Mqtt.pktType addr n

/-- MQTT flags (low nibble).

C ABI: `uint32_t lean_fs_mqtt_flags(size_t addr, size_t n);` -/
@[export_c lean_fs_mqtt_flags]
public unsafe def fsMqttFlags (addr : USize) (n : USize) : U32 :=
  Systems.Mqtt.flags addr n

/-- MQTT remaining length (single-byte form), or miss.

C ABI: `size_t lean_fs_mqtt_remaining_len_small(size_t addr, size_t n);` -/
@[export_c lean_fs_mqtt_remaining_len_small]
public unsafe def fsMqttRemainingLenSmall (addr : USize) (n : USize) : USize :=
  Systems.Mqtt.remainingLenSmall addr n

/-- RadixTree occupancy length (pass-through).

C ABI: `size_t lean_fs_radixtree_len(size_t n);` -/
@[export_c lean_fs_radixtree_len]
public def fsRadixtreeLen (n : USize) : USize :=
  Systems.RadixTree.len n

/-- RadixTree capacity (pass-through).

C ABI: `size_t lean_fs_radixtree_capacity(size_t cap);` -/
@[export_c lean_fs_radixtree_capacity]
public def fsRadixtreeCapacity (cap : USize) : USize :=
  Systems.RadixTree.capacity cap

/-- RadixTree is-empty occupancy helper.

C ABI: `uint32_t lean_fs_radixtree_is_empty(size_t n);` -/
@[export_c lean_fs_radixtree_is_empty]
public def fsRadixtreeIsEmpty (n : USize) : U32 :=
  Systems.RadixTree.isEmpty n

/-- RadixTree is-full occupancy helper.

C ABI: `uint32_t lean_fs_radixtree_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_radixtree_is_full]
public def fsRadixtreeIsFull (cap : USize) (n : USize) : U32 :=
  Systems.RadixTree.isFull cap n

/-- RadixTree lower-bound index.

C ABI: `size_t lean_fs_radixtree_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_radixtree_lower_bound]
public unsafe def fsRadixtreeLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.RadixTree.lowerBound keys n key

/-- RadixTree contains.

C ABI: `uint32_t lean_fs_radixtree_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_radixtree_contains]
public unsafe def fsRadixtreeContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.RadixTree.contains keys n key

/-- RadixTree get-by-index as USize, or miss.

C ABI: `size_t lean_fs_radixtree_get(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_radixtree_get]
public unsafe def fsRadixtreeGet (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.RadixTree.get keys n i

/-- RadixTree insert (status dataflow-used).

C ABI: `uint32_t lean_fs_radixtree_insert(size_t keys, size_t cap, size_t n, uint32_t key);` -/
@[export_c lean_fs_radixtree_insert]
public unsafe def fsRadixtreeInsert (keys : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  Systems.RadixTree.insert keys cap n key

/-- RadixTree remove.

C ABI: `uint32_t lean_fs_radixtree_remove(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_radixtree_remove]
public unsafe def fsRadixtreeRemove (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.RadixTree.remove keys n key

/-- Asn1 validate (length-class only).

C ABI: `uint32_t lean_fs_asn1_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_asn1_validate]
public unsafe def fsAsn1Validate (addr : USize) (n : USize) : U32 :=
  Systems.Asn1.validate addr n

/-- Asn1 scan (alias of validate).

C ABI: `uint32_t lean_fs_asn1_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_asn1_scan]
public unsafe def fsAsn1Scan (addr : USize) (n : USize) : U32 :=
  Systems.Asn1.scan addr n

/-- Asn1 tag byte.

C ABI: `uint32_t lean_fs_asn1_tag(size_t addr, size_t n);` -/
@[export_c lean_fs_asn1_tag]
public unsafe def fsAsn1Tag (addr : USize) (n : USize) : U32 :=
  Systems.Asn1.tag addr n

/-- Asn1 isConstructed (tag bit5).

C ABI: `uint32_t lean_fs_asn1_is_constructed(size_t addr, size_t n);` -/
@[export_c lean_fs_asn1_is_constructed]
public unsafe def fsAsn1IsConstructed (addr : USize) (n : USize) : U32 :=
  Systems.Asn1.isConstructed addr n

/-- Asn1 short-form length.

C ABI: `size_t lean_fs_asn1_length_small(size_t addr, size_t n);` -/
@[export_c lean_fs_asn1_length_small]
public unsafe def fsAsn1LengthSmall (addr : USize) (n : USize) : USize :=
  Systems.Asn1.lengthSmall addr n

/-- Asn1 content start offset (2 if short length ok).

C ABI: `size_t lean_fs_asn1_content_start(size_t addr, size_t n);` -/
@[export_c lean_fs_asn1_content_start]
public unsafe def fsAsn1ContentStart (addr : USize) (n : USize) : USize :=
  Systems.Asn1.contentStart addr n

/-- Coap validate (length-class only).

C ABI: `uint32_t lean_fs_coap_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_coap_validate]
public unsafe def fsCoapValidate (addr : USize) (n : USize) : U32 :=
  Systems.Coap.validate addr n

/-- Coap parse (alias of validate).

C ABI: `uint32_t lean_fs_coap_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_coap_parse]
public unsafe def fsCoapParse (addr : USize) (n : USize) : U32 :=
  Systems.Coap.parse addr n

/-- Coap version (high 2 bits of byte0).

C ABI: `uint32_t lean_fs_coap_version(size_t addr, size_t n);` -/
@[export_c lean_fs_coap_version]
public unsafe def fsCoapVersion (addr : USize) (n : USize) : U32 :=
  Systems.Coap.version addr n

/-- Coap type (bits 5–4 of byte0).

C ABI: `uint32_t lean_fs_coap_type(size_t addr, size_t n);` -/
@[export_c lean_fs_coap_type]
public unsafe def fsCoapType (addr : USize) (n : USize) : U32 :=
  Systems.Coap.type addr n

/-- Coap token length (low 4 bits of byte0).

C ABI: `uint32_t lean_fs_coap_token_len(size_t addr, size_t n);` -/
@[export_c lean_fs_coap_token_len]
public unsafe def fsCoapTokenLen (addr : USize) (n : USize) : U32 :=
  Systems.Coap.tokenLen addr n

/-- Coap code (byte1).

C ABI: `uint32_t lean_fs_coap_code(size_t addr, size_t n);` -/
@[export_c lean_fs_coap_code]
public unsafe def fsCoapCode (addr : USize) (n : USize) : U32 :=
  Systems.Coap.code addr n

/-- Coap message ID (bytes 2–3 BE).

C ABI: `uint32_t lean_fs_coap_msg_id(size_t addr, size_t n);` -/
@[export_c lean_fs_coap_msg_id]
public unsafe def fsCoapMsgId (addr : USize) (n : USize) : U32 :=
  Systems.Coap.msgId addr n

/-- YamlQuery validate (length-class only).

C ABI: `uint32_t lean_fs_yamlquery_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_yamlquery_validate]
public unsafe def fsYamlqueryValidate (addr : USize) (n : USize) : U32 :=
  Systems.YamlQuery.validate addr n

/-- YamlQuery scan (alias of validate).

C ABI: `uint32_t lean_fs_yamlquery_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_yamlquery_scan]
public unsafe def fsYamlqueryScan (addr : USize) (n : USize) : U32 :=
  Systems.YamlQuery.scan addr n

/-- YamlQuery findKey (value-start offset after key:).

C ABI: `size_t lean_fs_yamlquery_find_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_yamlquery_find_key]
public unsafe def fsYamlqueryFindKey (addr : USize) (n : USize) (key : USize) (keyLen : USize) : USize :=
  Systems.YamlQuery.findKey addr n key keyLen

/-- YamlQuery hasKey.

C ABI: `uint32_t lean_fs_yamlquery_has_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_yamlquery_has_key]
public unsafe def fsYamlqueryHasKey (addr : USize) (n : USize) (key : USize) (keyLen : USize) : U32 :=
  Systems.YamlQuery.hasKey addr n key keyLen

/-- YamlQuery findKeyEq (span equality helper).

C ABI: `uint32_t lean_fs_yamlquery_find_key_eq(size_t a, size_t b, size_t n);` -/
@[export_c lean_fs_yamlquery_find_key_eq]
public unsafe def fsYamlqueryFindKeyEq (a : USize) (b : USize) (n : USize) : U32 :=
  Systems.YamlQuery.findKeyEq a b n

/-- WebSocket validate (length-class only).

C ABI: `uint32_t lean_fs_ws_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ws_validate]
public unsafe def fsWsValidate (addr : USize) (n : USize) : U32 :=
  Systems.WebSocket.validate addr n

/-- WebSocket parse (alias of validate).

C ABI: `uint32_t lean_fs_ws_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_ws_parse]
public unsafe def fsWsParse (addr : USize) (n : USize) : U32 :=
  Systems.WebSocket.parse addr n

/-- WebSocket FIN bit.

C ABI: `uint32_t lean_fs_ws_fin(size_t addr, size_t n);` -/
@[export_c lean_fs_ws_fin]
public unsafe def fsWsFin (addr : USize) (n : USize) : U32 :=
  Systems.WebSocket.fin addr n

/-- WebSocket opcode.

C ABI: `uint32_t lean_fs_ws_opcode(size_t addr, size_t n);` -/
@[export_c lean_fs_ws_opcode]
public unsafe def fsWsOpcode (addr : USize) (n : USize) : U32 :=
  Systems.WebSocket.opcode addr n

/-- WebSocket MASK bit.

C ABI: `uint32_t lean_fs_ws_masked(size_t addr, size_t n);` -/
@[export_c lean_fs_ws_masked]
public unsafe def fsWsMasked (addr : USize) (n : USize) : U32 :=
  Systems.WebSocket.masked addr n

/-- WebSocket 7-bit payload length (or miss).

C ABI: `size_t lean_fs_ws_payload_len7(size_t addr, size_t n);` -/
@[export_c lean_fs_ws_payload_len7]
public unsafe def fsWsPayloadLen7 (addr : USize) (n : USize) : USize :=
  Systems.WebSocket.payloadLen7 addr n

/-- WebSocket isControl (opcode ≥ 8).

C ABI: `uint32_t lean_fs_ws_is_control(size_t addr, size_t n);` -/
@[export_c lean_fs_ws_is_control]
public unsafe def fsWsIsControl (addr : USize) (n : USize) : U32 :=
  Systems.WebSocket.isControl addr n

/-- BitMap nBits (`cap * 32`).

C ABI: `size_t lean_fs_bitmap_nbits(size_t cap);` -/
@[export_c lean_fs_bitmap_nbits]
public unsafe def fsBitmapNbits (cap : USize) : USize :=
  Systems.BitMap.nBits cap

/-- BitMap clearAll.

C ABI: `uint32_t lean_fs_bitmap_clear_all(size_t words, size_t cap);` -/
@[export_c lean_fs_bitmap_clear_all]
public unsafe def fsBitmapClearAll (words : USize) (cap : USize) : U32 :=
  Systems.BitMap.clearAll words cap

/-- BitMap set bit.

C ABI: `uint32_t lean_fs_bitmap_set(size_t words, size_t cap, size_t bit);` -/
@[export_c lean_fs_bitmap_set]
public unsafe def fsBitmapSet (words : USize) (cap : USize) (bit : USize) : U32 :=
  Systems.BitMap.set words cap bit

/-- BitMap clear bit.

C ABI: `uint32_t lean_fs_bitmap_clear(size_t words, size_t cap, size_t bit);` -/
@[export_c lean_fs_bitmap_clear]
public unsafe def fsBitmapClear (words : USize) (cap : USize) (bit : USize) : U32 :=
  Systems.BitMap.clear words cap bit

/-- BitMap test bit.

C ABI: `uint32_t lean_fs_bitmap_test(size_t words, size_t cap, size_t bit);` -/
@[export_c lean_fs_bitmap_test]
public unsafe def fsBitmapTest (words : USize) (cap : USize) (bit : USize) : U32 :=
  Systems.BitMap.test words cap bit

/-- BitMap isEmpty.

C ABI: `uint32_t lean_fs_bitmap_is_empty(size_t words, size_t cap);` -/
@[export_c lean_fs_bitmap_is_empty]
public unsafe def fsBitmapIsEmpty (words : USize) (cap : USize) : U32 :=
  Systems.BitMap.isEmpty words cap

/-- BitMap wordAt.

C ABI: `size_t lean_fs_bitmap_word_at(size_t words, size_t cap, size_t i);` -/
@[export_c lean_fs_bitmap_word_at]
public unsafe def fsBitmapWordAt (words : USize) (cap : USize) (i : USize) : USize :=
  Systems.BitMap.wordAt words cap i

/-- Lz4 validate (length-class only).

C ABI: `uint32_t lean_fs_lz4_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_lz4_validate]
public unsafe def fsLz4Validate (addr : USize) (n : USize) : U32 :=
  Systems.Lz4.validate addr n

/-- Lz4 scan (alias of validate).

C ABI: `uint32_t lean_fs_lz4_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_lz4_scan]
public unsafe def fsLz4Scan (addr : USize) (n : USize) : U32 :=
  Systems.Lz4.scan addr n

/-- Lz4 hasMagic (frame magic LE match).

C ABI: `uint32_t lean_fs_lz4_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_lz4_has_magic]
public unsafe def fsLz4HasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Lz4.hasMagic addr n

/-- Lz4 frameFlags (byte at offset 4 when n≥7).

C ABI: `uint32_t lean_fs_lz4_frame_flags(size_t addr, size_t n);` -/
@[export_c lean_fs_lz4_frame_flags]
public unsafe def fsLz4FrameFlags (addr : USize) (n : USize) : U32 :=
  Systems.Lz4.frameFlags addr n

/-- Lz4 blockSizeAt (LE U32 at off, or miss).

C ABI: `size_t lean_fs_lz4_block_size_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_lz4_block_size_at]
public unsafe def fsLz4BlockSizeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Lz4.blockSizeAt addr n off

/-- Socks5 validate (greeting length-class only).

C ABI: `uint32_t lean_fs_socks5_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_socks5_validate]
public unsafe def fsSocks5Validate (addr : USize) (n : USize) : U32 :=
  Systems.Socks5.validate addr n

/-- Socks5 parse (alias of validate).

C ABI: `uint32_t lean_fs_socks5_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_socks5_parse]
public unsafe def fsSocks5Parse (addr : USize) (n : USize) : U32 :=
  Systems.Socks5.parse addr n

/-- Socks5 version (byte0).

C ABI: `uint32_t lean_fs_socks5_version(size_t addr, size_t n);` -/
@[export_c lean_fs_socks5_version]
public unsafe def fsSocks5Version (addr : USize) (n : USize) : U32 :=
  Systems.Socks5.version addr n

/-- Socks5 nmethods (byte1).

C ABI: `uint32_t lean_fs_socks5_nmethods(size_t addr, size_t n);` -/
@[export_c lean_fs_socks5_nmethods]
public unsafe def fsSocks5Nmethods (addr : USize) (n : USize) : U32 :=
  Systems.Socks5.nmethods addr n

/-- Socks5 request validate (min-4 length-class).

C ABI: `uint32_t lean_fs_socks5_req_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_socks5_req_validate]
public unsafe def fsSocks5ReqValidate (addr : USize) (n : USize) : U32 :=
  Systems.Socks5.reqValidate addr n

/-- Socks5 request CMD.

C ABI: `uint32_t lean_fs_socks5_cmd(size_t addr, size_t n);` -/
@[export_c lean_fs_socks5_cmd]
public unsafe def fsSocks5Cmd (addr : USize) (n : USize) : U32 :=
  Systems.Socks5.cmd addr n

/-- Socks5 request RSV.

C ABI: `uint32_t lean_fs_socks5_rsv(size_t addr, size_t n);` -/
@[export_c lean_fs_socks5_rsv]
public unsafe def fsSocks5Rsv (addr : USize) (n : USize) : U32 :=
  Systems.Socks5.rsv addr n

/-- Socks5 request ATYP.

C ABI: `uint32_t lean_fs_socks5_atyp(size_t addr, size_t n);` -/
@[export_c lean_fs_socks5_atyp]
public unsafe def fsSocks5Atyp (addr : USize) (n : USize) : U32 :=
  Systems.Socks5.atyp addr n

/-- Snappy validate (length-class only).

C ABI: `uint32_t lean_fs_snappy_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_snappy_validate]
public unsafe def fsSnappyValidate (addr : USize) (n : USize) : U32 :=
  Systems.Snappy.validate addr n

/-- Snappy scan (alias of validate).

C ABI: `uint32_t lean_fs_snappy_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_snappy_scan]
public unsafe def fsSnappyScan (addr : USize) (n : USize) : U32 :=
  Systems.Snappy.scan addr n

/-- Snappy hasMagic (stream-id type/len/`sNaPpY`).

C ABI: `uint32_t lean_fs_snappy_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_snappy_has_magic]
public unsafe def fsSnappyHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Snappy.hasMagic addr n

/-- Snappy chunkType (byte0 when n≥4).

C ABI: `uint32_t lean_fs_snappy_chunk_type(size_t addr, size_t n);` -/
@[export_c lean_fs_snappy_chunk_type]
public unsafe def fsSnappyChunkType (addr : USize) (n : USize) : U32 :=
  Systems.Snappy.chunkType addr n

/-- Snappy chunkLen (24-bit LE at offs 1–3, or miss).

C ABI: `size_t lean_fs_snappy_chunk_len(size_t addr, size_t n);` -/
@[export_c lean_fs_snappy_chunk_len]
public unsafe def fsSnappyChunkLen (addr : USize) (n : USize) : USize :=
  Systems.Snappy.chunkLen addr n

/-- Rtsp validate (request-line length-class only).

C ABI: `uint32_t lean_fs_rtsp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_rtsp_validate]
public unsafe def fsRtspValidate (addr : USize) (n : USize) : U32 :=
  Systems.Rtsp.validate addr n

/-- Rtsp parse (alias of validate).

C ABI: `uint32_t lean_fs_rtsp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_rtsp_parse]
public unsafe def fsRtspParse (addr : USize) (n : USize) : U32 :=
  Systems.Rtsp.parse addr n

/-- Rtsp methodLen (first token until SP).

C ABI: `size_t lean_fs_rtsp_method_len(size_t addr, size_t n);` -/
@[export_c lean_fs_rtsp_method_len]
public unsafe def fsRtspMethodLen (addr : USize) (n : USize) : USize :=
  Systems.Rtsp.methodLen addr n

/-- Rtsp uriOff (second token start).

C ABI: `size_t lean_fs_rtsp_uri_off(size_t addr, size_t n);` -/
@[export_c lean_fs_rtsp_uri_off]
public unsafe def fsRtspUriOff (addr : USize) (n : USize) : USize :=
  Systems.Rtsp.uriOff addr n

/-- Rtsp uriLen (second token length).

C ABI: `size_t lean_fs_rtsp_uri_len(size_t addr, size_t n);` -/
@[export_c lean_fs_rtsp_uri_len]
public unsafe def fsRtspUriLen (addr : USize) (n : USize) : USize :=
  Systems.Rtsp.uriLen addr n

/-- Rtsp hasVersion (`RTSP/` third token).

C ABI: `uint32_t lean_fs_rtsp_has_version(size_t addr, size_t n);` -/
@[export_c lean_fs_rtsp_has_version]
public unsafe def fsRtspHasVersion (addr : USize) (n : USize) : U32 :=
  Systems.Rtsp.hasVersion addr n

/-- Rtsp versionOff (third token start, or miss).

C ABI: `size_t lean_fs_rtsp_version_off(size_t addr, size_t n);` -/
@[export_c lean_fs_rtsp_version_off]
public unsafe def fsRtspVersionOff (addr : USize) (n : USize) : USize :=
  Systems.Rtsp.versionOff addr n

/-- Zstd validate (length-class only).

C ABI: `uint32_t lean_fs_zstd_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_zstd_validate]
public unsafe def fsZstdValidate (addr : USize) (n : USize) : U32 :=
  Systems.Zstd.validate addr n

/-- Zstd scan (alias of validate).

C ABI: `uint32_t lean_fs_zstd_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_zstd_scan]
public unsafe def fsZstdScan (addr : USize) (n : USize) : U32 :=
  Systems.Zstd.scan addr n

/-- Zstd hasMagic (frame magic LE match).

C ABI: `uint32_t lean_fs_zstd_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_zstd_has_magic]
public unsafe def fsZstdHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Zstd.hasMagic addr n

/-- Zstd frameDesc (descriptor byte when n≥6).

C ABI: `uint32_t lean_fs_zstd_frame_desc(size_t addr, size_t n);` -/
@[export_c lean_fs_zstd_frame_desc]
public unsafe def fsZstdFrameDesc (addr : USize) (n : USize) : U32 :=
  Systems.Zstd.frameDesc addr n

/-- Zstd windowDesc (window byte when n≥6).

C ABI: `uint32_t lean_fs_zstd_window_desc(size_t addr, size_t n);` -/
@[export_c lean_fs_zstd_window_desc]
public unsafe def fsZstdWindowDesc (addr : USize) (n : USize) : U32 :=
  Systems.Zstd.windowDesc addr n

/-- Zstd fieldU32At (LE U32 field as USize, or miss).

C ABI: `size_t lean_fs_zstd_field_u32_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_zstd_field_u32_at]
public unsafe def fsZstdFieldU32At (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Zstd.fieldU32At addr n off

/-- Sip validate (request-line length-class only).

C ABI: `uint32_t lean_fs_sip_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_sip_validate]
public unsafe def fsSipValidate (addr : USize) (n : USize) : U32 :=
  Systems.Sip.validate addr n

/-- Sip parse (alias of validate).

C ABI: `uint32_t lean_fs_sip_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_sip_parse]
public unsafe def fsSipParse (addr : USize) (n : USize) : U32 :=
  Systems.Sip.parse addr n

/-- Sip methodLen (first token until SP).

C ABI: `size_t lean_fs_sip_method_len(size_t addr, size_t n);` -/
@[export_c lean_fs_sip_method_len]
public unsafe def fsSipMethodLen (addr : USize) (n : USize) : USize :=
  Systems.Sip.methodLen addr n

/-- Sip uriOff (second token start).

C ABI: `size_t lean_fs_sip_uri_off(size_t addr, size_t n);` -/
@[export_c lean_fs_sip_uri_off]
public unsafe def fsSipUriOff (addr : USize) (n : USize) : USize :=
  Systems.Sip.uriOff addr n

/-- Sip uriLen (second token length).

C ABI: `size_t lean_fs_sip_uri_len(size_t addr, size_t n);` -/
@[export_c lean_fs_sip_uri_len]
public unsafe def fsSipUriLen (addr : USize) (n : USize) : USize :=
  Systems.Sip.uriLen addr n

/-- Sip hasVersion (`SIP/` third token).

C ABI: `uint32_t lean_fs_sip_has_version(size_t addr, size_t n);` -/
@[export_c lean_fs_sip_has_version]
public unsafe def fsSipHasVersion (addr : USize) (n : USize) : U32 :=
  Systems.Sip.hasVersion addr n

/-- Sip versionOff (third token start, or miss).

C ABI: `size_t lean_fs_sip_version_off(size_t addr, size_t n);` -/
@[export_c lean_fs_sip_version_off]
public unsafe def fsSipVersionOff (addr : USize) (n : USize) : USize :=
  Systems.Sip.versionOff addr n

/-- Brotli validate (length-class only).

C ABI: `uint32_t lean_fs_brotli_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_brotli_validate]
public unsafe def fsBrotliValidate (addr : USize) (n : USize) : U32 :=
  Systems.Brotli.validate addr n

/-- Brotli scan (alias of validate).

C ABI: `uint32_t lean_fs_brotli_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_brotli_scan]
public unsafe def fsBrotliScan (addr : USize) (n : USize) : U32 :=
  Systems.Brotli.scan addr n

/-- Brotli hasMagic (simple 1-byte WBITS form).

C ABI: `uint32_t lean_fs_brotli_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_brotli_has_magic]
public unsafe def fsBrotliHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Brotli.hasMagic addr n

/-- Brotli windowBits (decoded simple WBITS).

C ABI: `uint32_t lean_fs_brotli_window_bits(size_t addr, size_t n);` -/
@[export_c lean_fs_brotli_window_bits]
public unsafe def fsBrotliWindowBits (addr : USize) (n : USize) : U32 :=
  Systems.Brotli.windowBits addr n

/-- Brotli metaPrefix (byte at offset 1 when n≥2).

C ABI: `uint32_t lean_fs_brotli_meta_prefix(size_t addr, size_t n);` -/
@[export_c lean_fs_brotli_meta_prefix]
public unsafe def fsBrotliMetaPrefix (addr : USize) (n : USize) : U32 :=
  Systems.Brotli.metaPrefix addr n

/-- NtpQuery validate (query/response length-class only).

C ABI: `uint32_t lean_fs_ntpquery_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ntpquery_validate]
public unsafe def fsNtpqueryValidate (addr : USize) (n : USize) : U32 :=
  Systems.NtpQuery.validate addr n

/-- NtpQuery parse (alias of validate).

C ABI: `uint32_t lean_fs_ntpquery_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_ntpquery_parse]
public unsafe def fsNtpqueryParse (addr : USize) (n : USize) : U32 :=
  Systems.NtpQuery.parse addr n

/-- NtpQuery li.

C ABI: `uint32_t lean_fs_ntpquery_li(size_t addr, size_t n);` -/
@[export_c lean_fs_ntpquery_li]
public unsafe def fsNtpqueryLi (addr : USize) (n : USize) : U32 :=
  Systems.NtpQuery.li addr n

/-- NtpQuery version.

C ABI: `uint32_t lean_fs_ntpquery_version(size_t addr, size_t n);` -/
@[export_c lean_fs_ntpquery_version]
public unsafe def fsNtpqueryVersion (addr : USize) (n : USize) : U32 :=
  Systems.NtpQuery.version addr n

/-- NtpQuery mode.

C ABI: `uint32_t lean_fs_ntpquery_mode(size_t addr, size_t n);` -/
@[export_c lean_fs_ntpquery_mode]
public unsafe def fsNtpqueryMode (addr : USize) (n : USize) : U32 :=
  Systems.NtpQuery.mode addr n

/-- NtpQuery isClientQuery (mode 3).

C ABI: `uint32_t lean_fs_ntpquery_is_client_query(size_t addr, size_t n);` -/
@[export_c lean_fs_ntpquery_is_client_query]
public unsafe def fsNtpqueryIsClientQuery (addr : USize) (n : USize) : U32 :=
  Systems.NtpQuery.isClientQuery addr n

/-- NtpQuery isServerReply (mode 4).

C ABI: `uint32_t lean_fs_ntpquery_is_server_reply(size_t addr, size_t n);` -/
@[export_c lean_fs_ntpquery_is_server_reply]
public unsafe def fsNtpqueryIsServerReply (addr : USize) (n : USize) : U32 :=
  Systems.NtpQuery.isServerReply addr n

/-- NtpQuery stratum.

C ABI: `uint32_t lean_fs_ntpquery_stratum(size_t addr, size_t n);` -/
@[export_c lean_fs_ntpquery_stratum]
public unsafe def fsNtpqueryStratum (addr : USize) (n : USize) : U32 :=
  Systems.NtpQuery.stratum addr n

/-- NtpQuery originTsOff (layout helper).

C ABI: `size_t lean_fs_ntpquery_origin_ts_off(size_t n);` (`n` unused). -/
@[export_c lean_fs_ntpquery_origin_ts_off]
public def fsNtpqueryOriginTsOff (n : USize) : USize :=
  Systems.NtpQuery.originTsOff n

/-- NtpQuery recvTsOff (layout helper).

C ABI: `size_t lean_fs_ntpquery_recv_ts_off(size_t n);` (`n` unused). -/
@[export_c lean_fs_ntpquery_recv_ts_off]
public def fsNtpqueryRecvTsOff (n : USize) : USize :=
  Systems.NtpQuery.recvTsOff n

/-- NtpQuery xmitTsOff (layout helper).

C ABI: `size_t lean_fs_ntpquery_xmit_ts_off(size_t n);` (`n` unused). -/
@[export_c lean_fs_ntpquery_xmit_ts_off]
public def fsNtpqueryXmitTsOff (n : USize) : USize :=
  Systems.NtpQuery.xmitTsOff n

/-- Ogg validate (length-class min-27).

C ABI: `uint32_t lean_fs_ogg_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_validate]
public unsafe def fsOggValidate (addr : USize) (n : USize) : U32 :=
  Systems.Ogg.validate addr n

/-- Ogg scan (alias of validate).

C ABI: `uint32_t lean_fs_ogg_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_scan]
public unsafe def fsOggScan (addr : USize) (n : USize) : U32 :=
  Systems.Ogg.scan addr n

/-- Ogg hasMagic (`"OggS"`).

C ABI: `uint32_t lean_fs_ogg_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_has_magic]
public unsafe def fsOggHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Ogg.hasMagic addr n

/-- Ogg version byte.

C ABI: `uint32_t lean_fs_ogg_version(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_version]
public unsafe def fsOggVersion (addr : USize) (n : USize) : U32 :=
  Systems.Ogg.version addr n

/-- Ogg header type flag.

C ABI: `uint32_t lean_fs_ogg_header_type(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_header_type]
public unsafe def fsOggHeaderType (addr : USize) (n : USize) : U32 :=
  Systems.Ogg.headerType addr n

/-- Ogg granule low LE dword as `USize`.

C ABI: `size_t lean_fs_ogg_granule_lo(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_granule_lo]
public unsafe def fsOggGranuleLo (addr : USize) (n : USize) : USize :=
  Systems.Ogg.granuleLo addr n

/-- Ogg stream serial number LE as `USize`.

C ABI: `size_t lean_fs_ogg_serial(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_serial]
public unsafe def fsOggSerial (addr : USize) (n : USize) : USize :=
  Systems.Ogg.serial addr n

/-- Ogg page sequence number LE as `USize`.

C ABI: `size_t lean_fs_ogg_seq(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_seq]
public unsafe def fsOggSeq (addr : USize) (n : USize) : USize :=
  Systems.Ogg.seq addr n

/-- Ogg page checksum LE as `USize`.

C ABI: `size_t lean_fs_ogg_checksum(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_checksum]
public unsafe def fsOggChecksum (addr : USize) (n : USize) : USize :=
  Systems.Ogg.checksum addr n

/-- Ogg page_segments count.

C ABI: `uint32_t lean_fs_ogg_n_segments(size_t addr, size_t n);` -/
@[export_c lean_fs_ogg_n_segments]
public unsafe def fsOggNSegments (addr : USize) (n : USize) : U32 :=
  Systems.Ogg.nSegments addr n

/-- Smtp validate (length-class min-4).

C ABI: `uint32_t lean_fs_smtp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_smtp_validate]
public unsafe def fsSmtpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Smtp.validate addr n

/-- Smtp parse (alias of validate).

C ABI: `uint32_t lean_fs_smtp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_smtp_parse]
public unsafe def fsSmtpParse (addr : USize) (n : USize) : U32 :=
  Systems.Smtp.parse addr n

/-- Smtp isReply (first three digits).

C ABI: `uint32_t lean_fs_smtp_is_reply(size_t addr, size_t n);` -/
@[export_c lean_fs_smtp_is_reply]
public unsafe def fsSmtpIsReply (addr : USize) (n : USize) : U32 :=
  Systems.Smtp.isReply addr n

/-- Smtp three-digit reply code.

C ABI: `uint32_t lean_fs_smtp_code(size_t addr, size_t n);` -/
@[export_c lean_fs_smtp_code]
public unsafe def fsSmtpCode (addr : USize) (n : USize) : U32 :=
  Systems.Smtp.code addr n

/-- Smtp method token length (command lines).

C ABI: `size_t lean_fs_smtp_method_len(size_t addr, size_t n);` -/
@[export_c lean_fs_smtp_method_len]
public unsafe def fsSmtpMethodLen (addr : USize) (n : USize) : USize :=
  Systems.Smtp.methodLen addr n

/-- Smtp optional text offset.

C ABI: `size_t lean_fs_smtp_text_off(size_t addr, size_t n);` -/
@[export_c lean_fs_smtp_text_off]
public unsafe def fsSmtpTextOff (addr : USize) (n : USize) : USize :=
  Systems.Smtp.textOff addr n

/-- Smtp hasText.

C ABI: `uint32_t lean_fs_smtp_has_text(size_t addr, size_t n);` -/
@[export_c lean_fs_smtp_has_text]
public unsafe def fsSmtpHasText (addr : USize) (n : USize) : U32 :=
  Systems.Smtp.hasText addr n

/-- BitSetMulti nBits (`cap * 32`).

C ABI: `size_t lean_fs_bsmulti_nbits(size_t cap);` -/
@[export_c lean_fs_bsmulti_nbits]
public unsafe def fsBsmultiNbits (cap : USize) : USize :=
  Systems.BitSetMulti.nBits cap

/-- BitSetMulti clearAll (store status dataflow-used).

C ABI: `uint32_t lean_fs_bsmulti_clear_all(size_t words, size_t cap);` -/
@[export_c lean_fs_bsmulti_clear_all]
public unsafe def fsBsmultiClearAll (words : USize) (cap : USize) : U32 :=
  Systems.BitSetMulti.clearAll words cap

/-- BitSetMulti set bit.

C ABI: `uint32_t lean_fs_bsmulti_set(size_t words, size_t cap, size_t bit);` -/
@[export_c lean_fs_bsmulti_set]
public unsafe def fsBsmultiSet (words : USize) (cap : USize) (bit : USize) : U32 :=
  Systems.BitSetMulti.set words cap bit

/-- BitSetMulti clear bit.

C ABI: `uint32_t lean_fs_bsmulti_clear(size_t words, size_t cap, size_t bit);` -/
@[export_c lean_fs_bsmulti_clear]
public unsafe def fsBsmultiClear (words : USize) (cap : USize) (bit : USize) : U32 :=
  Systems.BitSetMulti.clear words cap bit

/-- BitSetMulti test bit.

C ABI: `uint32_t lean_fs_bsmulti_test(size_t words, size_t cap, size_t bit);` -/
@[export_c lean_fs_bsmulti_test]
public unsafe def fsBsmultiTest (words : USize) (cap : USize) (bit : USize) : U32 :=
  Systems.BitSetMulti.test words cap bit

/-- BitSetMulti isEmpty.

C ABI: `uint32_t lean_fs_bsmulti_is_empty(size_t words, size_t cap);` -/
@[export_c lean_fs_bsmulti_is_empty]
public unsafe def fsBsmultiIsEmpty (words : USize) (cap : USize) : U32 :=
  Systems.BitSetMulti.isEmpty words cap

/-- BitSetMulti wordAt.

C ABI: `size_t lean_fs_bsmulti_word_at(size_t words, size_t cap, size_t i);` -/
@[export_c lean_fs_bsmulti_word_at]
public unsafe def fsBsmultiWordAt (words : USize) (cap : USize) (i : USize) : USize :=
  Systems.BitSetMulti.wordAt words cap i

/-- Webm validate (length-class min-4).
C ABI: `uint32_t lean_fs_webm_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_webm_validate]
public unsafe def webmValidate (addr : USize) (n : USize) : U32 :=
  Systems.Webm.validate addr n

/-- Webm scan (alias of validate).
C ABI: `uint32_t lean_fs_webm_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_webm_scan]
public unsafe def webmScan (addr : USize) (n : USize) : U32 :=
  Systems.Webm.scan addr n

/-- Webm hasMagic (EBML `0x1A45DFA3`).
C ABI: `uint32_t lean_fs_webm_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_webm_has_magic]
public unsafe def webmHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Webm.hasMagic addr n

/-- Webm magicBe (BE dword as USize).
C ABI: `size_t lean_fs_webm_magic_be(size_t addr, size_t n);` -/
@[export_c lean_fs_webm_magic_be]
public unsafe def webmMagicBe (addr : USize) (n : USize) : USize :=
  Systems.Webm.magicBe addr n

/-- Webm idClass (VINT width of first byte).
C ABI: `uint32_t lean_fs_webm_id_class(size_t addr, size_t n);` -/
@[export_c lean_fs_webm_id_class]
public unsafe def webmIdClass (addr : USize) (n : USize) : U32 :=
  Systems.Webm.idClass addr n

/-- Webm sizeClass (VINT width at offset 4).
C ABI: `uint32_t lean_fs_webm_size_class(size_t addr, size_t n);` -/
@[export_c lean_fs_webm_size_class]
public unsafe def webmSizeClass (addr : USize) (n : USize) : U32 :=
  Systems.Webm.sizeClass addr n

/-- Webm fieldBeAt (BE U32 at off).
C ABI: `size_t lean_fs_webm_field_be_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_webm_field_be_at]
public unsafe def webmFieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Webm.fieldBeAt addr n off

/-- Pop3 validate (length-class min-3).
C ABI: `uint32_t lean_fs_pop3_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_pop3_validate]
public unsafe def pop3Validate (addr : USize) (n : USize) : U32 :=
  Systems.Pop3.validate addr n

/-- Pop3 parse (alias of validate).
C ABI: `uint32_t lean_fs_pop3_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_pop3_parse]
public unsafe def pop3Parse (addr : USize) (n : USize) : U32 :=
  Systems.Pop3.parse addr n

/-- Pop3 isOk (`+OK`).
C ABI: `uint32_t lean_fs_pop3_is_ok(size_t addr, size_t n);` -/
@[export_c lean_fs_pop3_is_ok]
public unsafe def pop3IsOk (addr : USize) (n : USize) : U32 :=
  Systems.Pop3.isOk addr n

/-- Pop3 isErr (`-ERR`).
C ABI: `uint32_t lean_fs_pop3_is_err(size_t addr, size_t n);` -/
@[export_c lean_fs_pop3_is_err]
public unsafe def pop3IsErr (addr : USize) (n : USize) : U32 :=
  Systems.Pop3.isErr addr n

/-- Pop3 isReply.
C ABI: `uint32_t lean_fs_pop3_is_reply(size_t addr, size_t n);` -/
@[export_c lean_fs_pop3_is_reply]
public unsafe def pop3IsReply (addr : USize) (n : USize) : U32 :=
  Systems.Pop3.isReply addr n

/-- Pop3 methodLen (command lines).
C ABI: `size_t lean_fs_pop3_method_len(size_t addr, size_t n);` -/
@[export_c lean_fs_pop3_method_len]
public unsafe def pop3MethodLen (addr : USize) (n : USize) : USize :=
  Systems.Pop3.methodLen addr n

/-- Pop3 textOff.
C ABI: `size_t lean_fs_pop3_text_off(size_t addr, size_t n);` -/
@[export_c lean_fs_pop3_text_off]
public unsafe def pop3TextOff (addr : USize) (n : USize) : USize :=
  Systems.Pop3.textOff addr n

/-- Pop3 hasText.
C ABI: `uint32_t lean_fs_pop3_has_text(size_t addr, size_t n);` -/
@[export_c lean_fs_pop3_has_text]
public unsafe def pop3HasText (addr : USize) (n : USize) : U32 :=
  Systems.Pop3.hasText addr n

/-- Roaring len (pass-through).
C ABI: `size_t lean_fs_roaring_len(size_t n);` -/
@[export_c lean_fs_roaring_len]
public def roaringLen (n : USize) : USize :=
  Systems.Roaring.len n

/-- Roaring capacity (pass-through).
C ABI: `size_t lean_fs_roaring_capacity(size_t cap);` -/
@[export_c lean_fs_roaring_capacity]
public def roaringCapacity (cap : USize) : USize :=
  Systems.Roaring.capacity cap

/-- Roaring isEmpty.
C ABI: `uint32_t lean_fs_roaring_is_empty(size_t n);` -/
@[export_c lean_fs_roaring_is_empty]
public def roaringIsEmpty (n : USize) : U32 :=
  Systems.Roaring.isEmpty n

/-- Roaring isFull.
C ABI: `uint32_t lean_fs_roaring_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_roaring_is_full]
public def roaringIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Roaring.isFull cap n

/-- Roaring lowerBound.
C ABI: `size_t lean_fs_roaring_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_roaring_lower_bound]
public unsafe def roaringLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.Roaring.lowerBound keys n key

/-- Roaring contains.
C ABI: `uint32_t lean_fs_roaring_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_roaring_contains]
public unsafe def roaringContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.Roaring.contains keys n key

/-- Roaring get.
C ABI: `size_t lean_fs_roaring_get(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_roaring_get]
public unsafe def roaringGet (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.Roaring.get keys n i

/-- Roaring roaringAt.
C ABI: `size_t lean_fs_roaring_at(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_roaring_at]
public unsafe def roaringAt (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.Roaring.roaringAt keys n i

/-- Roaring insert.
C ABI: `uint32_t lean_fs_roaring_insert(size_t keys, size_t cap, size_t n, uint32_t key);` -/
@[export_c lean_fs_roaring_insert]
public unsafe def roaringInsert (keys : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  Systems.Roaring.insert keys cap n key

/-- Roaring remove.
C ABI: `uint32_t lean_fs_roaring_remove(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_roaring_remove]
public unsafe def roaringRemove (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.Roaring.remove keys n key

/-- Matroska validate (length-class min-4).
C ABI: `uint32_t lean_fs_matroska_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_matroska_validate]
public unsafe def matroskaValidate (addr : USize) (n : USize) : U32 :=
  Systems.Matroska.validate addr n

/-- Matroska scan (alias of validate).
C ABI: `uint32_t lean_fs_matroska_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_matroska_scan]
public unsafe def matroskaScan (addr : USize) (n : USize) : U32 :=
  Systems.Matroska.scan addr n

/-- Matroska hasMagic (EBML `0x1A45DFA3`).
C ABI: `uint32_t lean_fs_matroska_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_matroska_has_magic]
public unsafe def matroskaHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Matroska.hasMagic addr n

/-- Matroska magicBe (BE dword as USize).
C ABI: `size_t lean_fs_matroska_magic_be(size_t addr, size_t n);` -/
@[export_c lean_fs_matroska_magic_be]
public unsafe def matroskaMagicBe (addr : USize) (n : USize) : USize :=
  Systems.Matroska.magicBe addr n

/-- Matroska idClass (VINT width of first byte).
C ABI: `uint32_t lean_fs_matroska_id_class(size_t addr, size_t n);` -/
@[export_c lean_fs_matroska_id_class]
public unsafe def matroskaIdClass (addr : USize) (n : USize) : U32 :=
  Systems.Matroska.idClass addr n

/-- Matroska sizeClass (VINT width at offset 4).
C ABI: `uint32_t lean_fs_matroska_size_class(size_t addr, size_t n);` -/
@[export_c lean_fs_matroska_size_class]
public unsafe def matroskaSizeClass (addr : USize) (n : USize) : U32 :=
  Systems.Matroska.sizeClass addr n

/-- Matroska fieldBeAt (BE U32 at off).
C ABI: `size_t lean_fs_matroska_field_be_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_matroska_field_be_at]
public unsafe def matroskaFieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Matroska.fieldBeAt addr n off

/-- Imap validate (length-class min-4).
C ABI: `uint32_t lean_fs_imap_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_validate]
public unsafe def imapValidate (addr : USize) (n : USize) : U32 :=
  Systems.Imap.validate addr n

/-- Imap parse (alias of validate).
C ABI: `uint32_t lean_fs_imap_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_parse]
public unsafe def imapParse (addr : USize) (n : USize) : U32 :=
  Systems.Imap.parse addr n

/-- Imap isUntagged (`* `).
C ABI: `uint32_t lean_fs_imap_is_untagged(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_is_untagged]
public unsafe def imapIsUntagged (addr : USize) (n : USize) : U32 :=
  Systems.Imap.isUntagged addr n

/-- Imap tagLen (tagged lines).
C ABI: `size_t lean_fs_imap_tag_len(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_tag_len]
public unsafe def imapTagLen (addr : USize) (n : USize) : USize :=
  Systems.Imap.tagLen addr n

/-- Imap isOk (`OK` status).
C ABI: `uint32_t lean_fs_imap_is_ok(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_is_ok]
public unsafe def imapIsOk (addr : USize) (n : USize) : U32 :=
  Systems.Imap.isOk addr n

/-- Imap isNo (`NO` status).
C ABI: `uint32_t lean_fs_imap_is_no(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_is_no]
public unsafe def imapIsNo (addr : USize) (n : USize) : U32 :=
  Systems.Imap.isNo addr n

/-- Imap isBad (`BAD` status).
C ABI: `uint32_t lean_fs_imap_is_bad(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_is_bad]
public unsafe def imapIsBad (addr : USize) (n : USize) : U32 :=
  Systems.Imap.isBad addr n

/-- Imap isReply.
C ABI: `uint32_t lean_fs_imap_is_reply(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_is_reply]
public unsafe def imapIsReply (addr : USize) (n : USize) : U32 :=
  Systems.Imap.isReply addr n

/-- Imap textOff.
C ABI: `size_t lean_fs_imap_text_off(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_text_off]
public unsafe def imapTextOff (addr : USize) (n : USize) : USize :=
  Systems.Imap.textOff addr n

/-- Imap hasText.
C ABI: `uint32_t lean_fs_imap_has_text(size_t addr, size_t n);` -/
@[export_c lean_fs_imap_has_text]
public unsafe def imapHasText (addr : USize) (n : USize) : U32 :=
  Systems.Imap.hasText addr n

/-- IntervalSet count (pass-through).
C ABI: `size_t lean_fs_intervalset_count(size_t n);` -/
@[export_c lean_fs_intervalset_count]
public def intervalsetCount (n : USize) : USize :=
  Systems.IntervalSet.count n

/-- IntervalSet cap (pass-through).
C ABI: `size_t lean_fs_intervalset_cap(size_t cap);` -/
@[export_c lean_fs_intervalset_cap]
public def intervalsetCap (cap : USize) : USize :=
  Systems.IntervalSet.cap cap

/-- IntervalSet isEmpty.
C ABI: `uint32_t lean_fs_intervalset_is_empty(size_t n);` -/
@[export_c lean_fs_intervalset_is_empty]
public def intervalsetIsEmpty (n : USize) : U32 :=
  Systems.IntervalSet.isEmpty n

/-- IntervalSet isFull.
C ABI: `uint32_t lean_fs_intervalset_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_intervalset_is_full]
public def intervalsetIsFull (cap : USize) (n : USize) : U32 :=
  Systems.IntervalSet.isFull cap n

/-- IntervalSet insert.
C ABI: `uint32_t lean_fs_intervalset_insert(size_t los, size_t his, size_t cap, size_t n, uint32_t lo, uint32_t hi);` -/
@[export_c lean_fs_intervalset_insert]
public unsafe def intervalsetInsert (los : USize) (his : USize) (cap : USize) (n : USize)
    (lo : U32) (hi : U32) : U32 :=
  Systems.IntervalSet.insert los his cap n lo hi

/-- IntervalSet contains.
C ABI: `uint32_t lean_fs_intervalset_contains(size_t los, size_t his, size_t n, uint32_t p);` -/
@[export_c lean_fs_intervalset_contains]
public unsafe def intervalsetContains (los : USize) (his : USize) (n : USize) (p : U32) : U32 :=
  Systems.IntervalSet.contains los his n p

/-- IntervalSet overlaps.
C ABI: `uint32_t lean_fs_intervalset_overlaps(size_t los, size_t his, size_t n, uint32_t qlo, uint32_t qhi);` -/
@[export_c lean_fs_intervalset_overlaps]
public unsafe def intervalsetOverlaps (los : USize) (his : USize) (n : USize)
    (qlo : U32) (qhi : U32) : U32 :=
  Systems.IntervalSet.overlaps los his n qlo qhi

/-- Flac validate (length-class min-4).
C ABI: `uint32_t lean_fs_flac_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_flac_validate]
public unsafe def flacValidate (addr : USize) (n : USize) : U32 :=
  Systems.Flac.validate addr n

/-- Flac scan (alias of validate).
C ABI: `uint32_t lean_fs_flac_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_flac_scan]
public unsafe def flacScan (addr : USize) (n : USize) : U32 :=
  Systems.Flac.scan addr n

/-- Flac hasMagic (`"fLaC"`).
C ABI: `uint32_t lean_fs_flac_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_flac_has_magic]
public unsafe def flacHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Flac.hasMagic addr n

/-- Flac magicBe (BE dword as USize).
C ABI: `size_t lean_fs_flac_magic_be(size_t addr, size_t n);` -/
@[export_c lean_fs_flac_magic_be]
public unsafe def flacMagicBe (addr : USize) (n : USize) : USize :=
  Systems.Flac.magicBe addr n

/-- Flac isStreamInfo (block type 0).
C ABI: `uint32_t lean_fs_flac_is_streaminfo(size_t addr, size_t n);` -/
@[export_c lean_fs_flac_is_streaminfo]
public unsafe def flacIsStreamInfo (addr : USize) (n : USize) : U32 :=
  Systems.Flac.isStreamInfo addr n

/-- Flac isLastMeta (last-metadata flag).
C ABI: `uint32_t lean_fs_flac_is_last_meta(size_t addr, size_t n);` -/
@[export_c lean_fs_flac_is_last_meta]
public unsafe def flacIsLastMeta (addr : USize) (n : USize) : U32 :=
  Systems.Flac.isLastMeta addr n

/-- Flac blockType (type bits).
C ABI: `uint32_t lean_fs_flac_block_type(size_t addr, size_t n);` -/
@[export_c lean_fs_flac_block_type]
public unsafe def flacBlockType (addr : USize) (n : USize) : U32 :=
  Systems.Flac.blockType addr n

/-- Flac blockDataLen (24-bit BE length).
C ABI: `size_t lean_fs_flac_block_data_len(size_t addr, size_t n);` -/
@[export_c lean_fs_flac_block_data_len]
public unsafe def flacBlockDataLen (addr : USize) (n : USize) : USize :=
  Systems.Flac.blockDataLen addr n

/-- Flac fieldBeAt (BE U32 at off).
C ABI: `size_t lean_fs_flac_field_be_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_flac_field_be_at]
public unsafe def flacFieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Flac.fieldBeAt addr n off

/-- Nntp validate (length-class min-4).
C ABI: `uint32_t lean_fs_nntp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_nntp_validate]
public unsafe def nntpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Nntp.validate addr n

/-- Nntp parse (alias of validate).
C ABI: `uint32_t lean_fs_nntp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_nntp_parse]
public unsafe def nntpParse (addr : USize) (n : USize) : U32 :=
  Systems.Nntp.parse addr n

/-- Nntp isReply (3-digit code).
C ABI: `uint32_t lean_fs_nntp_is_reply(size_t addr, size_t n);` -/
@[export_c lean_fs_nntp_is_reply]
public unsafe def nntpIsReply (addr : USize) (n : USize) : U32 :=
  Systems.Nntp.isReply addr n

/-- Nntp code (3-digit reply).
C ABI: `uint32_t lean_fs_nntp_code(size_t addr, size_t n);` -/
@[export_c lean_fs_nntp_code]
public unsafe def nntpCode (addr : USize) (n : USize) : U32 :=
  Systems.Nntp.code addr n

/-- Nntp methodLen (command lines).
C ABI: `size_t lean_fs_nntp_method_len(size_t addr, size_t n);` -/
@[export_c lean_fs_nntp_method_len]
public unsafe def nntpMethodLen (addr : USize) (n : USize) : USize :=
  Systems.Nntp.methodLen addr n

/-- Nntp textOff.
C ABI: `size_t lean_fs_nntp_text_off(size_t addr, size_t n);` -/
@[export_c lean_fs_nntp_text_off]
public unsafe def nntpTextOff (addr : USize) (n : USize) : USize :=
  Systems.Nntp.textOff addr n

/-- Nntp hasText.
C ABI: `uint32_t lean_fs_nntp_has_text(size_t addr, size_t n);` -/
@[export_c lean_fs_nntp_has_text]
public unsafe def nntpHasText (addr : USize) (n : USize) : U32 :=
  Systems.Nntp.hasText addr n

/-- Ldap validate (length-class min-6).
C ABI: `uint32_t lean_fs_ldap_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_validate]
public unsafe def ldapValidate (addr : USize) (n : USize) : U32 :=
  Systems.Ldap.validate addr n

/-- Ldap parse (alias of validate).
C ABI: `uint32_t lean_fs_ldap_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_parse]
public unsafe def ldapParse (addr : USize) (n : USize) : U32 :=
  Systems.Ldap.parse addr n

/-- Ldap isSequence (tag 0x30).
C ABI: `uint32_t lean_fs_ldap_is_sequence(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_is_sequence]
public unsafe def ldapIsSequence (addr : USize) (n : USize) : U32 :=
  Systems.Ldap.isSequence addr n

/-- Ldap lengthSmall (short-form SEQUENCE length).
C ABI: `size_t lean_fs_ldap_length_small(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_length_small]
public unsafe def ldapLengthSmall (addr : USize) (n : USize) : USize :=
  Systems.Ldap.lengthSmall addr n

/-- Ldap hasMessageId (INTEGER length-1 shape).
C ABI: `uint32_t lean_fs_ldap_has_message_id(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_has_message_id]
public unsafe def ldapHasMessageId (addr : USize) (n : USize) : U32 :=
  Systems.Ldap.hasMessageId addr n

/-- Ldap messageId (1-byte INTEGER value).
C ABI: `uint32_t lean_fs_ldap_message_id(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_message_id]
public unsafe def ldapMessageId (addr : USize) (n : USize) : U32 :=
  Systems.Ldap.messageId addr n

/-- Ldap protocolOpTag.
C ABI: `uint32_t lean_fs_ldap_protocol_op_tag(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_protocol_op_tag]
public unsafe def ldapProtocolOpTag (addr : USize) (n : USize) : U32 :=
  Systems.Ldap.protocolOpTag addr n

/-- Ldap isBindRequest (0x60).
C ABI: `uint32_t lean_fs_ldap_is_bind_request(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_is_bind_request]
public unsafe def ldapIsBindRequest (addr : USize) (n : USize) : U32 :=
  Systems.Ldap.isBindRequest addr n

/-- Ldap isSearchRequest (0x63).
C ABI: `uint32_t lean_fs_ldap_is_search_request(size_t addr, size_t n);` -/
@[export_c lean_fs_ldap_is_search_request]
public unsafe def ldapIsSearchRequest (addr : USize) (n : USize) : U32 :=
  Systems.Ldap.isSearchRequest addr n

/-- Vorbis validate (length-class min-7).
C ABI: `uint32_t lean_fs_vorbis_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_vorbis_validate]
public unsafe def vorbisValidate (addr : USize) (n : USize) : U32 :=
  Systems.Vorbis.validate addr n

/-- Vorbis scan (alias of validate).
C ABI: `uint32_t lean_fs_vorbis_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_vorbis_scan]
public unsafe def vorbisScan (addr : USize) (n : USize) : U32 :=
  Systems.Vorbis.scan addr n

/-- Vorbis hasMagic (type 0x01 + "vorbis").
C ABI: `uint32_t lean_fs_vorbis_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_vorbis_has_magic]
public unsafe def vorbisHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Vorbis.hasMagic addr n

/-- Vorbis magicBe ("vorb" BE as USize).
C ABI: `size_t lean_fs_vorbis_magic_be(size_t addr, size_t n);` -/
@[export_c lean_fs_vorbis_magic_be]
public unsafe def vorbisMagicBe (addr : USize) (n : USize) : USize :=
  Systems.Vorbis.magicBe addr n

/-- Vorbis version (LE32 as USize).
C ABI: `size_t lean_fs_vorbis_version(size_t addr, size_t n);` -/
@[export_c lean_fs_vorbis_version]
public unsafe def vorbisVersion (addr : USize) (n : USize) : USize :=
  Systems.Vorbis.version addr n

/-- Vorbis channelCount.
C ABI: `uint32_t lean_fs_vorbis_channel_count(size_t addr, size_t n);` -/
@[export_c lean_fs_vorbis_channel_count]
public unsafe def vorbisChannelCount (addr : USize) (n : USize) : U32 :=
  Systems.Vorbis.channelCount addr n

/-- Vorbis sampleRate (LE32 as USize).
C ABI: `size_t lean_fs_vorbis_sample_rate(size_t addr, size_t n);` -/
@[export_c lean_fs_vorbis_sample_rate]
public unsafe def vorbisSampleRate (addr : USize) (n : USize) : USize :=
  Systems.Vorbis.sampleRate addr n

/-- Vorbis fieldLeAt (LE U32 at off).
C ABI: `size_t lean_fs_vorbis_field_le_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_vorbis_field_le_at]
public unsafe def vorbisFieldLeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Vorbis.fieldLeAt addr n off

/-- Radius validate (length-class min-20).
C ABI: `uint32_t lean_fs_radius_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_validate]
public unsafe def radiusValidate (addr : USize) (n : USize) : U32 :=
  Systems.Radius.validate addr n

/-- Radius parse (alias of validate).
C ABI: `uint32_t lean_fs_radius_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_parse]
public unsafe def radiusParse (addr : USize) (n : USize) : U32 :=
  Systems.Radius.parse addr n

/-- Radius code.
C ABI: `uint32_t lean_fs_radius_code(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_code]
public unsafe def radiusCode (addr : USize) (n : USize) : U32 :=
  Systems.Radius.code addr n

/-- Radius identifier.
C ABI: `uint32_t lean_fs_radius_identifier(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_identifier]
public unsafe def radiusIdentifier (addr : USize) (n : USize) : U32 :=
  Systems.Radius.identifier addr n

/-- Radius length (BE U16 as U32).
C ABI: `uint32_t lean_fs_radius_length(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_length]
public unsafe def radiusLength (addr : USize) (n : USize) : U32 :=
  Systems.Radius.length addr n

/-- Radius authBe0 (first 4 authenticator bytes BE).
C ABI: `size_t lean_fs_radius_auth_be0(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_auth_be0]
public unsafe def radiusAuthBe0 (addr : USize) (n : USize) : USize :=
  Systems.Radius.authBe0 addr n

/-- Radius isAccessRequest (code 1).
C ABI: `uint32_t lean_fs_radius_is_access_request(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_is_access_request]
public unsafe def radiusIsAccessRequest (addr : USize) (n : USize) : U32 :=
  Systems.Radius.isAccessRequest addr n

/-- Radius isAccessAccept (code 2).
C ABI: `uint32_t lean_fs_radius_is_access_accept(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_is_access_accept]
public unsafe def radiusIsAccessAccept (addr : USize) (n : USize) : U32 :=
  Systems.Radius.isAccessAccept addr n

/-- Radius isAccessReject (code 3).
C ABI: `uint32_t lean_fs_radius_is_access_reject(size_t addr, size_t n);` -/
@[export_c lean_fs_radius_is_access_reject]
public unsafe def radiusIsAccessReject (addr : USize) (n : USize) : U32 :=
  Systems.Radius.isAccessReject addr n

/-- OrderedU32Set len.
C ABI: `size_t lean_fs_orderedset_len(size_t n);` -/
@[export_c lean_fs_orderedset_len]
public def orderedsetLen (n : USize) : USize :=
  Systems.OrderedU32Set.len n

/-- OrderedU32Set capacity.
C ABI: `size_t lean_fs_orderedset_capacity(size_t cap);` -/
@[export_c lean_fs_orderedset_capacity]
public def orderedsetCapacity (cap : USize) : USize :=
  Systems.OrderedU32Set.capacity cap

/-- OrderedU32Set isEmpty.
C ABI: `uint32_t lean_fs_orderedset_is_empty(size_t n);` -/
@[export_c lean_fs_orderedset_is_empty]
public def orderedsetIsEmpty (n : USize) : U32 :=
  Systems.OrderedU32Set.isEmpty n

/-- OrderedU32Set isFull.
C ABI: `uint32_t lean_fs_orderedset_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_orderedset_is_full]
public def orderedsetIsFull (cap : USize) (n : USize) : U32 :=
  Systems.OrderedU32Set.isFull cap n

/-- OrderedU32Set lowerBound.
C ABI: `size_t lean_fs_orderedset_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_orderedset_lower_bound]
public unsafe def orderedsetLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.OrderedU32Set.lowerBound keys n key

/-- OrderedU32Set contains.
C ABI: `uint32_t lean_fs_orderedset_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_orderedset_contains]
public unsafe def orderedsetContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.OrderedU32Set.contains keys n key

/-- OrderedU32Set get.
C ABI: `size_t lean_fs_orderedset_get(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_orderedset_get]
public unsafe def orderedsetGet (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.OrderedU32Set.get keys n i

/-- OrderedU32Set orderedAt.
C ABI: `size_t lean_fs_orderedset_at(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_orderedset_at]
public unsafe def orderedsetAt (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.OrderedU32Set.orderedAt keys n i

/-- OrderedU32Set insert.
C ABI: `uint32_t lean_fs_orderedset_insert(size_t keys, size_t cap, size_t n, uint32_t key);` -/
@[export_c lean_fs_orderedset_insert]
public unsafe def orderedsetInsert (keys : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  Systems.OrderedU32Set.insert keys cap n key

/-- OrderedU32Set remove.
C ABI: `uint32_t lean_fs_orderedset_remove(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_orderedset_remove]
public unsafe def orderedsetRemove (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.OrderedU32Set.remove keys n key

/-- Diameter validate (length-class min-20).
C ABI: `uint32_t lean_fs_diameter_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_diameter_validate]
public unsafe def diameterValidate (addr : USize) (n : USize) : U32 :=
  Systems.Diameter.validate addr n

/-- Diameter parse (alias of validate).
C ABI: `uint32_t lean_fs_diameter_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_diameter_parse]
public unsafe def diameterParse (addr : USize) (n : USize) : U32 :=
  Systems.Diameter.parse addr n

/-- Diameter version.
C ABI: `uint32_t lean_fs_diameter_version(size_t addr, size_t n);` -/
@[export_c lean_fs_diameter_version]
public unsafe def diameterVersion (addr : USize) (n : USize) : U32 :=
  Systems.Diameter.version addr n

/-- Diameter length (24-bit BE as U32).
C ABI: `uint32_t lean_fs_diameter_length(size_t addr, size_t n);` -/
@[export_c lean_fs_diameter_length]
public unsafe def diameterLength (addr : USize) (n : USize) : U32 :=
  Systems.Diameter.length addr n

/-- Diameter flags.
C ABI: `uint32_t lean_fs_diameter_flags(size_t addr, size_t n);` -/
@[export_c lean_fs_diameter_flags]
public unsafe def diameterFlags (addr : USize) (n : USize) : U32 :=
  Systems.Diameter.flags addr n

/-- Diameter commandCode (24-bit BE as U32).
C ABI: `uint32_t lean_fs_diameter_command_code(size_t addr, size_t n);` -/
@[export_c lean_fs_diameter_command_code]
public unsafe def diameterCommandCode (addr : USize) (n : USize) : U32 :=
  Systems.Diameter.commandCode addr n

/-- Diameter appId (BE U32 as USize).
C ABI: `size_t lean_fs_diameter_app_id(size_t addr, size_t n);` -/
@[export_c lean_fs_diameter_app_id]
public unsafe def diameterAppId (addr : USize) (n : USize) : USize :=
  Systems.Diameter.appId addr n

/-- Diameter isRequest (R flag 0x80).
C ABI: `uint32_t lean_fs_diameter_is_request(size_t addr, size_t n);` -/
@[export_c lean_fs_diameter_is_request]
public unsafe def diameterIsRequest (addr : USize) (n : USize) : U32 :=
  Systems.Diameter.isRequest addr n

/-- SctpCommon validate (length-class min-12).
C ABI: `uint32_t lean_fs_sctpcommon_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_sctpcommon_validate]
public unsafe def sctpcommonValidate (addr : USize) (n : USize) : U32 :=
  Systems.SctpCommon.validate addr n

/-- SctpCommon parse (alias of validate).
C ABI: `uint32_t lean_fs_sctpcommon_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_sctpcommon_parse]
public unsafe def sctpcommonParse (addr : USize) (n : USize) : U32 :=
  Systems.SctpCommon.parse addr n

/-- SctpCommon srcPort.
C ABI: `uint32_t lean_fs_sctpcommon_src_port(size_t addr, size_t n);` -/
@[export_c lean_fs_sctpcommon_src_port]
public unsafe def sctpcommonSrcPort (addr : USize) (n : USize) : U32 :=
  Systems.SctpCommon.srcPort addr n

/-- SctpCommon dstPort.
C ABI: `uint32_t lean_fs_sctpcommon_dst_port(size_t addr, size_t n);` -/
@[export_c lean_fs_sctpcommon_dst_port]
public unsafe def sctpcommonDstPort (addr : USize) (n : USize) : U32 :=
  Systems.SctpCommon.dstPort addr n

/-- SctpCommon vtag.
C ABI: `uint32_t lean_fs_sctpcommon_vtag(size_t addr, size_t n);` -/
@[export_c lean_fs_sctpcommon_vtag]
public unsafe def sctpcommonVtag (addr : USize) (n : USize) : U32 :=
  Systems.SctpCommon.vtag addr n

/-- SctpCommon checksum (layout only).
C ABI: `uint32_t lean_fs_sctpcommon_checksum(size_t addr, size_t n);` -/
@[export_c lean_fs_sctpcommon_checksum]
public unsafe def sctpcommonChecksum (addr : USize) (n : USize) : U32 :=
  Systems.SctpCommon.checksum addr n

/-- SctpCommon fieldBeAt (BE U32 at off).
C ABI: `size_t lean_fs_sctpcommon_field_be_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_sctpcommon_field_be_at]
public unsafe def sctpcommonFieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.SctpCommon.fieldBeAt addr n off

/-- M3ua validate (length-class min-8).
C ABI: `uint32_t lean_fs_m3ua_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_m3ua_validate]
public unsafe def m3uaValidate (addr : USize) (n : USize) : U32 :=
  Systems.M3ua.validate addr n

/-- M3ua parse (alias of validate).
C ABI: `uint32_t lean_fs_m3ua_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_m3ua_parse]
public unsafe def m3uaParse (addr : USize) (n : USize) : U32 :=
  Systems.M3ua.parse addr n

/-- M3ua version.
C ABI: `uint32_t lean_fs_m3ua_version(size_t addr, size_t n);` -/
@[export_c lean_fs_m3ua_version]
public unsafe def m3uaVersion (addr : USize) (n : USize) : U32 :=
  Systems.M3ua.version addr n

/-- M3ua reserved.
C ABI: `uint32_t lean_fs_m3ua_reserved(size_t addr, size_t n);` -/
@[export_c lean_fs_m3ua_reserved]
public unsafe def m3uaReserved (addr : USize) (n : USize) : U32 :=
  Systems.M3ua.reserved addr n

/-- M3ua msgClass.
C ABI: `uint32_t lean_fs_m3ua_msg_class(size_t addr, size_t n);` -/
@[export_c lean_fs_m3ua_msg_class]
public unsafe def m3uaMsgClass (addr : USize) (n : USize) : U32 :=
  Systems.M3ua.msgClass addr n

/-- M3ua msgType.
C ABI: `uint32_t lean_fs_m3ua_msg_type(size_t addr, size_t n);` -/
@[export_c lean_fs_m3ua_msg_type]
public unsafe def m3uaMsgType (addr : USize) (n : USize) : U32 :=
  Systems.M3ua.msgType addr n

/-- M3ua length (BE message length).
C ABI: `uint32_t lean_fs_m3ua_length(size_t addr, size_t n);` -/
@[export_c lean_fs_m3ua_length]
public unsafe def m3uaLength (addr : USize) (n : USize) : U32 :=
  Systems.M3ua.length addr n

/-- M3ua fieldBeAt (BE U32 at off).
C ABI: `size_t lean_fs_m3ua_field_be_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_m3ua_field_be_at]
public unsafe def m3uaFieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.M3ua.fieldBeAt addr n off

/-- Sua validate (length-class min-8).
C ABI: `uint32_t lean_fs_sua_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_sua_validate]
public unsafe def suaValidate (addr : USize) (n : USize) : U32 :=
  Systems.Sua.validate addr n

/-- Sua parse (alias of validate).
C ABI: `uint32_t lean_fs_sua_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_sua_parse]
public unsafe def suaParse (addr : USize) (n : USize) : U32 :=
  Systems.Sua.parse addr n

/-- Sua version.
C ABI: `uint32_t lean_fs_sua_version(size_t addr, size_t n);` -/
@[export_c lean_fs_sua_version]
public unsafe def suaVersion (addr : USize) (n : USize) : U32 :=
  Systems.Sua.version addr n

/-- Sua reserved.
C ABI: `uint32_t lean_fs_sua_reserved(size_t addr, size_t n);` -/
@[export_c lean_fs_sua_reserved]
public unsafe def suaReserved (addr : USize) (n : USize) : U32 :=
  Systems.Sua.reserved addr n

/-- Sua msgClass.
C ABI: `uint32_t lean_fs_sua_msg_class(size_t addr, size_t n);` -/
@[export_c lean_fs_sua_msg_class]
public unsafe def suaMsgClass (addr : USize) (n : USize) : U32 :=
  Systems.Sua.msgClass addr n

/-- Sua msgType.
C ABI: `uint32_t lean_fs_sua_msg_type(size_t addr, size_t n);` -/
@[export_c lean_fs_sua_msg_type]
public unsafe def suaMsgType (addr : USize) (n : USize) : U32 :=
  Systems.Sua.msgType addr n

/-- Sua length (BE message length).
C ABI: `uint32_t lean_fs_sua_length(size_t addr, size_t n);` -/
@[export_c lean_fs_sua_length]
public unsafe def suaLength (addr : USize) (n : USize) : U32 :=
  Systems.Sua.length addr n

/-- Sua fieldBeAt (BE U32 at off).
C ABI: `size_t lean_fs_sua_field_be_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_sua_field_be_at]
public unsafe def suaFieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Sua.fieldBeAt addr n off

/-- Iua validate (length-class min-8).
C ABI: `uint32_t lean_fs_iua_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_iua_validate]
public unsafe def iuaValidate (addr : USize) (n : USize) : U32 :=
  Systems.Iua.validate addr n

/-- Iua parse (alias of validate).
C ABI: `uint32_t lean_fs_iua_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_iua_parse]
public unsafe def iuaParse (addr : USize) (n : USize) : U32 :=
  Systems.Iua.parse addr n

/-- Iua version.
C ABI: `uint32_t lean_fs_iua_version(size_t addr, size_t n);` -/
@[export_c lean_fs_iua_version]
public unsafe def iuaVersion (addr : USize) (n : USize) : U32 :=
  Systems.Iua.version addr n

/-- Iua reserved.
C ABI: `uint32_t lean_fs_iua_reserved(size_t addr, size_t n);` -/
@[export_c lean_fs_iua_reserved]
public unsafe def iuaReserved (addr : USize) (n : USize) : U32 :=
  Systems.Iua.reserved addr n

/-- Iua msgClass.
C ABI: `uint32_t lean_fs_iua_msg_class(size_t addr, size_t n);` -/
@[export_c lean_fs_iua_msg_class]
public unsafe def iuaMsgClass (addr : USize) (n : USize) : U32 :=
  Systems.Iua.msgClass addr n

/-- Iua msgType.
C ABI: `uint32_t lean_fs_iua_msg_type(size_t addr, size_t n);` -/
@[export_c lean_fs_iua_msg_type]
public unsafe def iuaMsgType (addr : USize) (n : USize) : U32 :=
  Systems.Iua.msgType addr n

/-- Iua length (BE message length).
C ABI: `uint32_t lean_fs_iua_length(size_t addr, size_t n);` -/
@[export_c lean_fs_iua_length]
public unsafe def iuaLength (addr : USize) (n : USize) : U32 :=
  Systems.Iua.length addr n

/-- Iua fieldBeAt (BE U32 at off).
C ABI: `size_t lean_fs_iua_field_be_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_iua_field_be_at]
public unsafe def iuaFieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.Iua.fieldBeAt addr n off

/-- V5ua validate (length-class min-8).
C ABI: `uint32_t lean_fs_v5ua_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_v5ua_validate]
public unsafe def v5uaValidate (addr : USize) (n : USize) : U32 :=
  Systems.V5ua.validate addr n

/-- V5ua parse (alias of validate).
C ABI: `uint32_t lean_fs_v5ua_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_v5ua_parse]
public unsafe def v5uaParse (addr : USize) (n : USize) : U32 :=
  Systems.V5ua.parse addr n

/-- V5ua version.
C ABI: `uint32_t lean_fs_v5ua_version(size_t addr, size_t n);` -/
@[export_c lean_fs_v5ua_version]
public unsafe def v5uaVersion (addr : USize) (n : USize) : U32 :=
  Systems.V5ua.version addr n

/-- V5ua reserved.
C ABI: `uint32_t lean_fs_v5ua_reserved(size_t addr, size_t n);` -/
@[export_c lean_fs_v5ua_reserved]
public unsafe def v5uaReserved (addr : USize) (n : USize) : U32 :=
  Systems.V5ua.reserved addr n

/-- V5ua msgClass.
C ABI: `uint32_t lean_fs_v5ua_msg_class(size_t addr, size_t n);` -/
@[export_c lean_fs_v5ua_msg_class]
public unsafe def v5uaMsgClass (addr : USize) (n : USize) : U32 :=
  Systems.V5ua.msgClass addr n

/-- V5ua msgType.
C ABI: `uint32_t lean_fs_v5ua_msg_type(size_t addr, size_t n);` -/
@[export_c lean_fs_v5ua_msg_type]
public unsafe def v5uaMsgType (addr : USize) (n : USize) : U32 :=
  Systems.V5ua.msgType addr n

/-- V5ua length (BE message length).
C ABI: `uint32_t lean_fs_v5ua_length(size_t addr, size_t n);` -/
@[export_c lean_fs_v5ua_length]
public unsafe def v5uaLength (addr : USize) (n : USize) : U32 :=
  Systems.V5ua.length addr n

/-- V5ua fieldBeAt (BE U32 at off).
C ABI: `size_t lean_fs_v5ua_field_be_at(size_t addr, size_t n, size_t off);` -/
@[export_c lean_fs_v5ua_field_be_at]
public unsafe def v5uaFieldBeAt (addr : USize) (n : USize) (off : USize) : USize :=
  Systems.V5ua.fieldBeAt addr n off

/-- H248 validate (length-class min-4).
C ABI: `uint32_t lean_fs_h248_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_h248_validate]
public unsafe def h248Validate (addr : USize) (n : USize) : U32 :=
  Systems.H248.validate addr n

/-- H248 parse (alias of validate).
C ABI: `uint32_t lean_fs_h248_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_h248_parse]
public unsafe def h248Parse (addr : USize) (n : USize) : U32 :=
  Systems.H248.parse addr n

/-- H248 hasVersion (MEGACO/ or !/).
C ABI: `uint32_t lean_fs_h248_has_version(size_t addr, size_t n);` -/
@[export_c lean_fs_h248_has_version]
public unsafe def h248HasVersion (addr : USize) (n : USize) : U32 :=
  Systems.H248.hasVersion addr n

/-- H248 version (major digit after slash).
C ABI: `uint32_t lean_fs_h248_version(size_t addr, size_t n);` -/
@[export_c lean_fs_h248_version]
public unsafe def h248Version (addr : USize) (n : USize) : U32 :=
  Systems.H248.version addr n

/-- H248 length (first-line byte span).
C ABI: `uint32_t lean_fs_h248_length(size_t addr, size_t n);` -/
@[export_c lean_fs_h248_length]
public unsafe def h248Length (addr : USize) (n : USize) : U32 :=
  Systems.H248.length addr n

/-- H248 methodLen (first token until SP/[).
C ABI: `size_t lean_fs_h248_method_len(size_t addr, size_t n);` -/
@[export_c lean_fs_h248_method_len]
public unsafe def h248MethodLen (addr : USize) (n : USize) : USize :=
  Systems.H248.methodLen addr n

/-- H248 midOff (first '[' offset).
C ABI: `size_t lean_fs_h248_mid_off(size_t addr, size_t n);` -/
@[export_c lean_fs_h248_mid_off]
public unsafe def h248MidOff (addr : USize) (n : USize) : USize :=
  Systems.H248.midOff addr n

/-- Megaco validate (length-class min-4).
C ABI: `uint32_t lean_fs_megaco_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_megaco_validate]
public unsafe def megacoValidate (addr : USize) (n : USize) : U32 :=
  Systems.Megaco.validate addr n

/-- Megaco parse (alias of validate).
C ABI: `uint32_t lean_fs_megaco_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_megaco_parse]
public unsafe def megacoParse (addr : USize) (n : USize) : U32 :=
  Systems.Megaco.parse addr n

/-- Megaco hasTxn (T=/P=/R=/K= short-form).
C ABI: `uint32_t lean_fs_megaco_has_txn(size_t addr, size_t n);` -/
@[export_c lean_fs_megaco_has_txn]
public unsafe def megacoHasTxn (addr : USize) (n : USize) : U32 :=
  Systems.Megaco.hasTxn addr n

/-- Megaco txnKind (1=T 2=P 3=R 4=K).
C ABI: `uint32_t lean_fs_megaco_txn_kind(size_t addr, size_t n);` -/
@[export_c lean_fs_megaco_txn_kind]
public unsafe def megacoTxnKind (addr : USize) (n : USize) : U32 :=
  Systems.Megaco.txnKind addr n

/-- Megaco txnId (decimal after =).
C ABI: `uint32_t lean_fs_megaco_txn_id(size_t addr, size_t n);` -/
@[export_c lean_fs_megaco_txn_id]
public unsafe def megacoTxnId (addr : USize) (n : USize) : U32 :=
  Systems.Megaco.txnId addr n

/-- Megaco length (first-line / fragment byte span).
C ABI: `uint32_t lean_fs_megaco_length(size_t addr, size_t n);` -/
@[export_c lean_fs_megaco_length]
public unsafe def megacoLength (addr : USize) (n : USize) : U32 :=
  Systems.Megaco.length addr n

/-- Megaco txnOff (first short-form txn marker offset).
C ABI: `size_t lean_fs_megaco_txn_off(size_t addr, size_t n);` -/
@[export_c lean_fs_megaco_txn_off]
public unsafe def megacoTxnOff (addr : USize) (n : USize) : USize :=
  Systems.Megaco.txnOff addr n

/-- Mgcp validate (length-class min-4).
C ABI: `uint32_t lean_fs_mgcp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_mgcp_validate]
public unsafe def mgcpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Mgcp.validate addr n

/-- Mgcp parse (alias of validate).
C ABI: `uint32_t lean_fs_mgcp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_mgcp_parse]
public unsafe def mgcpParse (addr : USize) (n : USize) : U32 :=
  Systems.Mgcp.parse addr n

/-- Mgcp isResponse (three leading digits).
C ABI: `uint32_t lean_fs_mgcp_is_response(size_t addr, size_t n);` -/
@[export_c lean_fs_mgcp_is_response]
public unsafe def mgcpIsResponse (addr : USize) (n : USize) : U32 :=
  Systems.Mgcp.isResponse addr n

/-- Mgcp code (three-digit response code).
C ABI: `uint32_t lean_fs_mgcp_code(size_t addr, size_t n);` -/
@[export_c lean_fs_mgcp_code]
public unsafe def mgcpCode (addr : USize) (n : USize) : U32 :=
  Systems.Mgcp.code addr n

/-- Mgcp method (VERB token length).
C ABI: `size_t lean_fs_mgcp_method(size_t addr, size_t n);` -/
@[export_c lean_fs_mgcp_method]
public unsafe def mgcpMethod (addr : USize) (n : USize) : USize :=
  Systems.Mgcp.method addr n

/-- Mgcp txnId (decimal after first SP).
C ABI: `uint32_t lean_fs_mgcp_txn_id(size_t addr, size_t n);` -/
@[export_c lean_fs_mgcp_txn_id]
public unsafe def mgcpTxnId (addr : USize) (n : USize) : U32 :=
  Systems.Mgcp.txnId addr n

/-- Mgcp hasVersion (MGCP/ token).
C ABI: `uint32_t lean_fs_mgcp_has_version(size_t addr, size_t n);` -/
@[export_c lean_fs_mgcp_has_version]
public unsafe def mgcpHasVersion (addr : USize) (n : USize) : U32 :=
  Systems.Mgcp.hasVersion addr n

/-- Mgcp versionOff (first MGCP/ offset).
C ABI: `size_t lean_fs_mgcp_version_off(size_t addr, size_t n);` -/
@[export_c lean_fs_mgcp_version_off]
public unsafe def mgcpVersionOff (addr : USize) (n : USize) : USize :=
  Systems.Mgcp.versionOff addr n

/-- Sdp validate (length-class min-3).
C ABI: `uint32_t lean_fs_sdp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_sdp_validate]
public unsafe def sdpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Sdp.validate addr n

/-- Sdp parse (alias of validate).
C ABI: `uint32_t lean_fs_sdp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_sdp_parse]
public unsafe def sdpParse (addr : USize) (n : USize) : U32 :=
  Systems.Sdp.parse addr n

/-- Sdp method (first-line type letter).
C ABI: `uint32_t lean_fs_sdp_method(size_t addr, size_t n);` -/
@[export_c lean_fs_sdp_method]
public unsafe def sdpMethod (addr : USize) (n : USize) : U32 :=
  Systems.Sdp.method addr n

/-- Sdp isVersion (v= first line).
C ABI: `uint32_t lean_fs_sdp_is_version(size_t addr, size_t n);` -/
@[export_c lean_fs_sdp_is_version]
public unsafe def sdpIsVersion (addr : USize) (n : USize) : U32 :=
  Systems.Sdp.isVersion addr n

/-- Sdp version (digit after v=).
C ABI: `uint32_t lean_fs_sdp_version(size_t addr, size_t n);` -/
@[export_c lean_fs_sdp_version]
public unsafe def sdpVersion (addr : USize) (n : USize) : U32 :=
  Systems.Sdp.version addr n

/-- Sdp hasOrigin (o= first line).
C ABI: `uint32_t lean_fs_sdp_has_origin(size_t addr, size_t n);` -/
@[export_c lean_fs_sdp_has_origin]
public unsafe def sdpHasOrigin (addr : USize) (n : USize) : U32 :=
  Systems.Sdp.hasOrigin addr n

/-- Sdp mediaLen (first media token length after m=).
C ABI: `size_t lean_fs_sdp_media_len(size_t addr, size_t n);` -/
@[export_c lean_fs_sdp_media_len]
public unsafe def sdpMediaLen (addr : USize) (n : USize) : USize :=
  Systems.Sdp.mediaLen addr n

/-- Sdp valueOff (offset after first X=).
C ABI: `size_t lean_fs_sdp_value_off(size_t addr, size_t n);` -/
@[export_c lean_fs_sdp_value_off]
public unsafe def sdpValueOff (addr : USize) (n : USize) : USize :=
  Systems.Sdp.valueOff addr n

/-- Rtcp validate (length-class min-4).
C ABI: `uint32_t lean_fs_rtcp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_rtcp_validate]
public unsafe def rtcpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Rtcp.validate addr n

/-- Rtcp parse (alias of validate).
C ABI: `uint32_t lean_fs_rtcp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_rtcp_parse]
public unsafe def rtcpParse (addr : USize) (n : USize) : U32 :=
  Systems.Rtcp.parse addr n

/-- Rtcp version (high 2 bits of byte0).
C ABI: `uint32_t lean_fs_rtcp_version(size_t addr, size_t n);` -/
@[export_c lean_fs_rtcp_version]
public unsafe def rtcpVersion (addr : USize) (n : USize) : U32 :=
  Systems.Rtcp.version addr n

/-- Rtcp padding (bit 5 of byte0).
C ABI: `uint32_t lean_fs_rtcp_padding(size_t addr, size_t n);` -/
@[export_c lean_fs_rtcp_padding]
public unsafe def rtcpPadding (addr : USize) (n : USize) : U32 :=
  Systems.Rtcp.padding addr n

/-- Rtcp rc (low 5 bits of byte0).
C ABI: `uint32_t lean_fs_rtcp_rc(size_t addr, size_t n);` -/
@[export_c lean_fs_rtcp_rc]
public unsafe def rtcpRc (addr : USize) (n : USize) : U32 :=
  Systems.Rtcp.rc addr n

/-- Rtcp pt (packet type byte1).
C ABI: `uint32_t lean_fs_rtcp_pt(size_t addr, size_t n);` -/
@[export_c lean_fs_rtcp_pt]
public unsafe def rtcpPt (addr : USize) (n : USize) : U32 :=
  Systems.Rtcp.pt addr n

/-- Rtcp length (bytes 2–3 BE).
C ABI: `uint32_t lean_fs_rtcp_length(size_t addr, size_t n);` -/
@[export_c lean_fs_rtcp_length]
public unsafe def rtcpLength (addr : USize) (n : USize) : U32 :=
  Systems.Rtcp.length addr n

/-- Stun validate (length-class min-20).
C ABI: `uint32_t lean_fs_stun_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_stun_validate]
public unsafe def stunValidate (addr : USize) (n : USize) : U32 :=
  Systems.Stun.validate addr n

/-- Stun parse (alias of validate).
C ABI: `uint32_t lean_fs_stun_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_stun_parse]
public unsafe def stunParse (addr : USize) (n : USize) : U32 :=
  Systems.Stun.parse addr n

/-- Stun method (message type BE U16).
C ABI: `uint32_t lean_fs_stun_method(size_t addr, size_t n);` -/
@[export_c lean_fs_stun_method]
public unsafe def stunMethod (addr : USize) (n : USize) : U32 :=
  Systems.Stun.method addr n

/-- Stun length (message length BE U16).
C ABI: `uint32_t lean_fs_stun_length(size_t addr, size_t n);` -/
@[export_c lean_fs_stun_length]
public unsafe def stunLength (addr : USize) (n : USize) : U32 :=
  Systems.Stun.length addr n

/-- Stun magicCookie (bytes 4–7 BE as USize).
C ABI: `size_t lean_fs_stun_magic_cookie(size_t addr, size_t n);` -/
@[export_c lean_fs_stun_magic_cookie]
public unsafe def stunMagicCookie (addr : USize) (n : USize) : USize :=
  Systems.Stun.magicCookie addr n

/-- Stun hasMagic (cookie 0x2112A442).
C ABI: `uint32_t lean_fs_stun_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_stun_has_magic]
public unsafe def stunHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Stun.hasMagic addr n

/-- Stun txnId0 (first 4 txn-id bytes BE as USize).
C ABI: `size_t lean_fs_stun_txn_id0(size_t addr, size_t n);` -/
@[export_c lean_fs_stun_txn_id0]
public unsafe def stunTxnId0 (addr : USize) (n : USize) : USize :=
  Systems.Stun.txnId0 addr n

/-- Turn validate (length-class min-20).
C ABI: `uint32_t lean_fs_turn_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_turn_validate]
public unsafe def turnValidate (addr : USize) (n : USize) : U32 :=
  Systems.Turn.validate addr n

/-- Turn parse (alias of validate).
C ABI: `uint32_t lean_fs_turn_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_turn_parse]
public unsafe def turnParse (addr : USize) (n : USize) : U32 :=
  Systems.Turn.parse addr n

/-- Turn method (message type BE U16).
C ABI: `uint32_t lean_fs_turn_method(size_t addr, size_t n);` -/
@[export_c lean_fs_turn_method]
public unsafe def turnMethod (addr : USize) (n : USize) : U32 :=
  Systems.Turn.method addr n

/-- Turn length (message length BE U16).
C ABI: `uint32_t lean_fs_turn_length(size_t addr, size_t n);` -/
@[export_c lean_fs_turn_length]
public unsafe def turnLength (addr : USize) (n : USize) : U32 :=
  Systems.Turn.length addr n

/-- Turn magicCookie (bytes 4–7 BE as USize).
C ABI: `size_t lean_fs_turn_magic_cookie(size_t addr, size_t n);` -/
@[export_c lean_fs_turn_magic_cookie]
public unsafe def turnMagicCookie (addr : USize) (n : USize) : USize :=
  Systems.Turn.magicCookie addr n

/-- Turn hasMagic (cookie 0x2112A442).
C ABI: `uint32_t lean_fs_turn_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_turn_has_magic]
public unsafe def turnHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Turn.hasMagic addr n

/-- Turn txnId0 (first 4 txn-id bytes BE as USize).
C ABI: `size_t lean_fs_turn_txn_id0(size_t addr, size_t n);` -/
@[export_c lean_fs_turn_txn_id0]
public unsafe def turnTxnId0 (addr : USize) (n : USize) : USize :=
  Systems.Turn.txnId0 addr n

/-- Ice validate (length-class min-20).
C ABI: `uint32_t lean_fs_ice_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ice_validate]
public unsafe def iceValidate (addr : USize) (n : USize) : U32 :=
  Systems.Ice.validate addr n

/-- Ice parse (alias of validate).
C ABI: `uint32_t lean_fs_ice_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_ice_parse]
public unsafe def iceParse (addr : USize) (n : USize) : U32 :=
  Systems.Ice.parse addr n

/-- Ice method (message type BE U16).
C ABI: `uint32_t lean_fs_ice_method(size_t addr, size_t n);` -/
@[export_c lean_fs_ice_method]
public unsafe def iceMethod (addr : USize) (n : USize) : U32 :=
  Systems.Ice.method addr n

/-- Ice length (message length BE U16).
C ABI: `uint32_t lean_fs_ice_length(size_t addr, size_t n);` -/
@[export_c lean_fs_ice_length]
public unsafe def iceLength (addr : USize) (n : USize) : U32 :=
  Systems.Ice.length addr n

/-- Ice magicCookie (bytes 4–7 BE as USize).
C ABI: `size_t lean_fs_ice_magic_cookie(size_t addr, size_t n);` -/
@[export_c lean_fs_ice_magic_cookie]
public unsafe def iceMagicCookie (addr : USize) (n : USize) : USize :=
  Systems.Ice.magicCookie addr n

/-- Ice hasMagic (cookie 0x2112A442).
C ABI: `uint32_t lean_fs_ice_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_ice_has_magic]
public unsafe def iceHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Ice.hasMagic addr n

/-- Ice txnId0 (first 4 txn-id bytes BE as USize).
C ABI: `size_t lean_fs_ice_txn_id0(size_t addr, size_t n);` -/
@[export_c lean_fs_ice_txn_id0]
public unsafe def iceTxnId0 (addr : USize) (n : USize) : USize :=
  Systems.Ice.txnId0 addr n

/-- Rtp validate (length-class min-12).
C ABI: `uint32_t lean_fs_rtp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_validate]
public unsafe def rtpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.validate addr n

/-- Rtp parse (alias of validate).
C ABI: `uint32_t lean_fs_rtp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_parse]
public unsafe def rtpParse (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.parse addr n

/-- Rtp version (high 2 bits of byte0).
C ABI: `uint32_t lean_fs_rtp_version(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_version]
public unsafe def rtpVersion (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.version addr n

/-- Rtp padding (bit 5 of byte0).
C ABI: `uint32_t lean_fs_rtp_padding(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_padding]
public unsafe def rtpPadding (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.padding addr n

/-- Rtp extension (bit 4 of byte0).
C ABI: `uint32_t lean_fs_rtp_extension(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_extension]
public unsafe def rtpExtension (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.extension addr n

/-- Rtp cc (low 4 bits of byte0).
C ABI: `uint32_t lean_fs_rtp_cc(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_cc]
public unsafe def rtpCc (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.cc addr n

/-- Rtp marker (high bit of byte1).
C ABI: `uint32_t lean_fs_rtp_marker(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_marker]
public unsafe def rtpMarker (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.marker addr n

/-- Rtp pt (low 7 bits of byte1).
C ABI: `uint32_t lean_fs_rtp_pt(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_pt]
public unsafe def rtpPt (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.pt addr n

/-- Rtp seq (bytes 2–3 BE).
C ABI: `uint32_t lean_fs_rtp_seq(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_seq]
public unsafe def rtpSeq (addr : USize) (n : USize) : U32 :=
  Systems.Rtp.seq addr n

/-- Rtp timestamp (bytes 4–7 BE as USize).
C ABI: `size_t lean_fs_rtp_timestamp(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_timestamp]
public unsafe def rtpTimestamp (addr : USize) (n : USize) : USize :=
  Systems.Rtp.timestamp addr n

/-- Rtp ssrc (bytes 8–11 BE as USize).
C ABI: `size_t lean_fs_rtp_ssrc(size_t addr, size_t n);` -/
@[export_c lean_fs_rtp_ssrc]
public unsafe def rtpSsrc (addr : USize) (n : USize) : USize :=
  Systems.Rtp.ssrc addr n

/-- Srtp validate (length-class min-12; not full SRTP crypto).
C ABI: `uint32_t lean_fs_srtp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_validate]
public unsafe def srtpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.validate addr n

/-- Srtp parse (alias of validate).
C ABI: `uint32_t lean_fs_srtp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_parse]
public unsafe def srtpParse (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.parse addr n

/-- Srtp version (high 2 bits of byte0).
C ABI: `uint32_t lean_fs_srtp_version(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_version]
public unsafe def srtpVersion (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.version addr n

/-- Srtp padding (bit 5 of byte0).
C ABI: `uint32_t lean_fs_srtp_padding(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_padding]
public unsafe def srtpPadding (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.padding addr n

/-- Srtp extension (bit 4 of byte0).
C ABI: `uint32_t lean_fs_srtp_extension(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_extension]
public unsafe def srtpExtension (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.extension addr n

/-- Srtp cc (low 4 bits of byte0).
C ABI: `uint32_t lean_fs_srtp_cc(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_cc]
public unsafe def srtpCc (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.cc addr n

/-- Srtp marker (high bit of byte1).
C ABI: `uint32_t lean_fs_srtp_marker(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_marker]
public unsafe def srtpMarker (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.marker addr n

/-- Srtp pt (low 7 bits of byte1).
C ABI: `uint32_t lean_fs_srtp_pt(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_pt]
public unsafe def srtpPt (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.pt addr n

/-- Srtp seq (bytes 2–3 BE).
C ABI: `uint32_t lean_fs_srtp_seq(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_seq]
public unsafe def srtpSeq (addr : USize) (n : USize) : U32 :=
  Systems.Srtp.seq addr n

/-- Srtp timestamp (bytes 4–7 BE as USize).
C ABI: `size_t lean_fs_srtp_timestamp(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_timestamp]
public unsafe def srtpTimestamp (addr : USize) (n : USize) : USize :=
  Systems.Srtp.timestamp addr n

/-- Srtp ssrc (bytes 8–11 BE as USize).
C ABI: `size_t lean_fs_srtp_ssrc(size_t addr, size_t n);` -/
@[export_c lean_fs_srtp_ssrc]
public unsafe def srtpSsrc (addr : USize) (n : USize) : USize :=
  Systems.Srtp.ssrc addr n

/-- Srtcp validate (length-class min-4; not full SRTCP crypto).
C ABI: `uint32_t lean_fs_srtcp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_srtcp_validate]
public unsafe def srtcpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Srtcp.validate addr n

/-- Srtcp parse (alias of validate).
C ABI: `uint32_t lean_fs_srtcp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_srtcp_parse]
public unsafe def srtcpParse (addr : USize) (n : USize) : U32 :=
  Systems.Srtcp.parse addr n

/-- Srtcp version (high 2 bits of byte0).
C ABI: `uint32_t lean_fs_srtcp_version(size_t addr, size_t n);` -/
@[export_c lean_fs_srtcp_version]
public unsafe def srtcpVersion (addr : USize) (n : USize) : U32 :=
  Systems.Srtcp.version addr n

/-- Srtcp padding (bit 5 of byte0).
C ABI: `uint32_t lean_fs_srtcp_padding(size_t addr, size_t n);` -/
@[export_c lean_fs_srtcp_padding]
public unsafe def srtcpPadding (addr : USize) (n : USize) : U32 :=
  Systems.Srtcp.padding addr n

/-- Srtcp rc (low 5 bits of byte0).
C ABI: `uint32_t lean_fs_srtcp_rc(size_t addr, size_t n);` -/
@[export_c lean_fs_srtcp_rc]
public unsafe def srtcpRc (addr : USize) (n : USize) : U32 :=
  Systems.Srtcp.rc addr n

/-- Srtcp pt (byte1).
C ABI: `uint32_t lean_fs_srtcp_pt(size_t addr, size_t n);` -/
@[export_c lean_fs_srtcp_pt]
public unsafe def srtcpPt (addr : USize) (n : USize) : U32 :=
  Systems.Srtcp.pt addr n

/-- Srtcp length (bytes 2–3 BE).
C ABI: `uint32_t lean_fs_srtcp_length(size_t addr, size_t n);` -/
@[export_c lean_fs_srtcp_length]
public unsafe def srtcpLength (addr : USize) (n : USize) : U32 :=
  Systems.Srtcp.length addr n

/-- Dtls validate (length-class min-13; not full DTLS handshake/crypto).
C ABI: `uint32_t lean_fs_dtls_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_dtls_validate]
public unsafe def dtlsValidate (addr : USize) (n : USize) : U32 :=
  Systems.Dtls.validate addr n

/-- Dtls parse (alias of validate).
C ABI: `uint32_t lean_fs_dtls_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_dtls_parse]
public unsafe def dtlsParse (addr : USize) (n : USize) : U32 :=
  Systems.Dtls.parse addr n

/-- Dtls contentType (byte0).
C ABI: `uint32_t lean_fs_dtls_content_type(size_t addr, size_t n);` -/
@[export_c lean_fs_dtls_content_type]
public unsafe def dtlsContentType (addr : USize) (n : USize) : U32 :=
  Systems.Dtls.contentType addr n

/-- Dtls version (bytes 1–2 BE).
C ABI: `uint32_t lean_fs_dtls_version(size_t addr, size_t n);` -/
@[export_c lean_fs_dtls_version]
public unsafe def dtlsVersion (addr : USize) (n : USize) : U32 :=
  Systems.Dtls.version addr n

/-- Dtls epoch (bytes 3–4 BE).
C ABI: `uint32_t lean_fs_dtls_epoch(size_t addr, size_t n);` -/
@[export_c lean_fs_dtls_epoch]
public unsafe def dtlsEpoch (addr : USize) (n : USize) : U32 :=
  Systems.Dtls.epoch addr n

/-- Dtls seqHi (bytes 5–8 BE).
C ABI: `uint32_t lean_fs_dtls_seq_hi(size_t addr, size_t n);` -/
@[export_c lean_fs_dtls_seq_hi]
public unsafe def dtlsSeqHi (addr : USize) (n : USize) : U32 :=
  Systems.Dtls.seqHi addr n

/-- Dtls seqLo (bytes 9–10 BE).
C ABI: `uint32_t lean_fs_dtls_seq_lo(size_t addr, size_t n);` -/
@[export_c lean_fs_dtls_seq_lo]
public unsafe def dtlsSeqLo (addr : USize) (n : USize) : U32 :=
  Systems.Dtls.seqLo addr n

/-- Dtls length (bytes 11–12 BE).
C ABI: `uint32_t lean_fs_dtls_length(size_t addr, size_t n);` -/
@[export_c lean_fs_dtls_length]
public unsafe def dtlsLength (addr : USize) (n : USize) : U32 :=
  Systems.Dtls.length addr n

/-- Tls validate (length-class min-5; not full TLS handshake/crypto).
C ABI: `uint32_t lean_fs_tls_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_tls_validate]
public unsafe def tlsValidate (addr : USize) (n : USize) : U32 :=
  Systems.Tls.validate addr n

/-- Tls parse (alias of validate).
C ABI: `uint32_t lean_fs_tls_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_tls_parse]
public unsafe def tlsParse (addr : USize) (n : USize) : U32 :=
  Systems.Tls.parse addr n

/-- Tls contentType (byte0).
C ABI: `uint32_t lean_fs_tls_content_type(size_t addr, size_t n);` -/
@[export_c lean_fs_tls_content_type]
public unsafe def tlsContentType (addr : USize) (n : USize) : U32 :=
  Systems.Tls.contentType addr n

/-- Tls version (bytes 1–2 BE).
C ABI: `uint32_t lean_fs_tls_version(size_t addr, size_t n);` -/
@[export_c lean_fs_tls_version]
public unsafe def tlsVersion (addr : USize) (n : USize) : U32 :=
  Systems.Tls.version addr n

/-- Tls length (bytes 3–4 BE).
C ABI: `uint32_t lean_fs_tls_length(size_t addr, size_t n);` -/
@[export_c lean_fs_tls_length]
public unsafe def tlsLength (addr : USize) (n : USize) : U32 :=
  Systems.Tls.length addr n

/-- Ipsec validate (length-class min-12; not full IPsec crypto/SAD).
C ABI: `uint32_t lean_fs_ipsec_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ipsec_validate]
public unsafe def ipsecValidate (addr : USize) (n : USize) : U32 :=
  Systems.Ipsec.validate addr n

/-- Ipsec parse (alias of validate).
C ABI: `uint32_t lean_fs_ipsec_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_ipsec_parse]
public unsafe def ipsecParse (addr : USize) (n : USize) : U32 :=
  Systems.Ipsec.parse addr n

/-- Ipsec nextHeader (byte0).
C ABI: `uint32_t lean_fs_ipsec_next_header(size_t addr, size_t n);` -/
@[export_c lean_fs_ipsec_next_header]
public unsafe def ipsecNextHeader (addr : USize) (n : USize) : U32 :=
  Systems.Ipsec.nextHeader addr n

/-- Ipsec payloadLen (byte1).
C ABI: `uint32_t lean_fs_ipsec_payload_len(size_t addr, size_t n);` -/
@[export_c lean_fs_ipsec_payload_len]
public unsafe def ipsecPayloadLen (addr : USize) (n : USize) : U32 :=
  Systems.Ipsec.payloadLen addr n

/-- Ipsec spi (bytes 4–7 BE as USize).
C ABI: `size_t lean_fs_ipsec_spi(size_t addr, size_t n);` -/
@[export_c lean_fs_ipsec_spi]
public unsafe def ipsecSpi (addr : USize) (n : USize) : USize :=
  Systems.Ipsec.spi addr n

/-- Ipsec seq (bytes 8–11 BE as USize).
C ABI: `size_t lean_fs_ipsec_seq(size_t addr, size_t n);` -/
@[export_c lean_fs_ipsec_seq]
public unsafe def ipsecSeq (addr : USize) (n : USize) : USize :=
  Systems.Ipsec.seq addr n

/-- DepGraph init (zero out-degrees).
C ABI: `uint32_t lean_fs_depgraph_init(size_t degs, size_t node_cap);` -/
@[export_c lean_fs_depgraph_init]
public unsafe def depgraphInit (degs : USize) (nodeCap : USize) : U32 :=
  Systems.DepGraph.init degs nodeCap

/-- DepGraph addEdge (src precedes dst).
C ABI: `uint32_t lean_fs_depgraph_add_edge(size_t adj, size_t degs, size_t node_cap, size_t max_deg,
  uint32_t src, uint32_t dst);` -/
@[export_c lean_fs_depgraph_add_edge]
public unsafe def depgraphAddEdge (adj : USize) (degs : USize) (nodeCap : USize) (maxDeg : USize)
    (src : U32) (dst : U32) : U32 :=
  Systems.DepGraph.addEdge adj degs nodeCap maxDeg src dst

/-- DepGraph degree.
C ABI: `size_t lean_fs_depgraph_degree(size_t degs, size_t node_cap, uint32_t u);` -/
@[export_c lean_fs_depgraph_degree]
public unsafe def depgraphDegree (degs : USize) (nodeCap : USize) (u : U32) : USize :=
  Systems.DepGraph.degree degs nodeCap u

/-- DepGraph neighbor.
C ABI: `size_t lean_fs_depgraph_neighbor(size_t adj, size_t degs, size_t node_cap, size_t max_deg,
  uint32_t u, size_t j);` -/
@[export_c lean_fs_depgraph_neighbor]
public unsafe def depgraphNeighbor (adj : USize) (degs : USize) (nodeCap : USize) (maxDeg : USize)
    (u : U32) (j : USize) : USize :=
  Systems.DepGraph.neighbor adj degs nodeCap maxDeg u j

/-- DepGraph outAt (topo output slot).
C ABI: `size_t lean_fs_depgraph_out_at(size_t out, size_t node_cap, size_t i);` -/
@[export_c lean_fs_depgraph_out_at]
public unsafe def depgraphOutAt (out : USize) (nodeCap : USize) (i : USize) : USize :=
  Systems.DepGraph.outAt out nodeCap i

/-- DepGraph topo (Kahn).
C ABI: `uint32_t lean_fs_depgraph_topo(size_t adj, size_t degs, size_t indeg, size_t queue, size_t out,
  size_t node_cap, size_t max_deg);` -/
@[export_c lean_fs_depgraph_topo]
public unsafe def depgraphTopo (adj : USize) (degs : USize) (indeg : USize) (queue : USize)
    (out : USize) (nodeCap : USize) (maxDeg : USize) : U32 :=
  Systems.DepGraph.topo adj degs indeg queue out nodeCap maxDeg

/-- Trace init.
C ABI: `uint32_t lean_fs_trace_init(size_t keys, size_t cap);` -/
@[export_c lean_fs_trace_init]
public def traceInit (keys : USize) (cap : USize) : U32 :=
  Systems.Trace.init keys cap

/-- Trace clear.
C ABI: `uint32_t lean_fs_trace_clear(size_t keys, size_t cap);` -/
@[export_c lean_fs_trace_clear]
public def traceClear (keys : USize) (cap : USize) : U32 :=
  Systems.Trace.clear keys cap

/-- Trace len.
C ABI: `size_t lean_fs_trace_len(size_t n);` -/
@[export_c lean_fs_trace_len]
public def traceLen (n : USize) : USize :=
  Systems.Trace.len n

/-- Trace capacity.
C ABI: `size_t lean_fs_trace_capacity(size_t cap);` -/
@[export_c lean_fs_trace_capacity]
public def traceCapacity (cap : USize) : USize :=
  Systems.Trace.capacity cap

/-- Trace isEmpty.
C ABI: `uint32_t lean_fs_trace_is_empty(size_t n);` -/
@[export_c lean_fs_trace_is_empty]
public def traceIsEmpty (n : USize) : U32 :=
  Systems.Trace.isEmpty n

/-- Trace isFull.
C ABI: `uint32_t lean_fs_trace_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_trace_is_full]
public def traceIsFull (cap : USize) (n : USize) : U32 :=
  Systems.Trace.isFull cap n

/-- Trace lowerBound.
C ABI: `size_t lean_fs_trace_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_trace_lower_bound]
public unsafe def traceLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.Trace.lowerBound keys n key

/-- Trace contains.
C ABI: `uint32_t lean_fs_trace_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_trace_contains]
public unsafe def traceContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.Trace.contains keys n key

/-- Trace get.
C ABI: `size_t lean_fs_trace_get(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_trace_get]
public unsafe def traceGet (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.Trace.get keys n i

/-- Trace traceAt.
C ABI: `size_t lean_fs_trace_at(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_trace_at]
public unsafe def traceAt (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.Trace.traceAt keys n i

/-- Trace insert / put (precomputed hash).
C ABI: `uint32_t lean_fs_trace_put(size_t keys, size_t cap, size_t n, uint32_t key);` -/
@[export_c lean_fs_trace_put]
public unsafe def tracePut (keys : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  Systems.Trace.put keys cap n key

/-- Trace mixPut (hashBytes + insert).
C ABI: `uint32_t lean_fs_trace_mix_put(size_t keys, size_t cap, size_t n, size_t addr, size_t len);` -/
@[export_c lean_fs_trace_mix_put]
public unsafe def traceMixPut (keys : USize) (cap : USize) (n : USize)
    (addr : USize) (len : USize) : U32 :=
  Systems.Trace.mixPut keys cap n addr len

/-- Trace remove.
C ABI: `uint32_t lean_fs_trace_remove(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_trace_remove]
public unsafe def traceRemove (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.Trace.remove keys n key

/-- TomlConfig validate.
C ABI: `uint32_t lean_fs_tomlcfg_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_validate]
public unsafe def tomlcfgValidate (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.validate addr n

/-- TomlConfig scan.
C ABI: `uint32_t lean_fs_tomlcfg_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_scan]
public unsafe def tomlcfgScan (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.scan addr n

/-- TomlConfig packageNameOff.
C ABI: `size_t lean_fs_tomlcfg_package_name_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_package_name_off]
public unsafe def tomlcfgPackageNameOff (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.packageNameOff addr n

/-- TomlConfig packageNameLen.
C ABI: `size_t lean_fs_tomlcfg_package_name_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_package_name_len]
public unsafe def tomlcfgPackageNameLen (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.packageNameLen addr n

/-- TomlConfig leanLibCount.
C ABI: `size_t lean_fs_tomlcfg_lean_lib_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_lean_lib_count]
public unsafe def tomlcfgLeanLibCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.leanLibCount addr n

/-- TomlConfig requireCount.
C ABI: `size_t lean_fs_tomlcfg_require_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_require_count]
public unsafe def tomlcfgRequireCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.requireCount addr n

/-- TomlConfig findKey.
C ABI: `size_t lean_fs_tomlcfg_find_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_tomlcfg_find_key]
public unsafe def tomlcfgFindKey (addr : USize) (n : USize) (key : USize) (keyLen : USize) : USize :=
  Systems.TomlConfig.findKey addr n key keyLen

/-- TomlConfig valueOff.
C ABI: `size_t lean_fs_tomlcfg_value_off(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_tomlcfg_value_off]
public unsafe def tomlcfgValueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.TomlConfig.valueOff addr n keyOff

/-- TomlConfig valueLen.
C ABI: `size_t lean_fs_tomlcfg_value_len(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_tomlcfg_value_len]
public unsafe def tomlcfgValueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.TomlConfig.valueLen addr n keyOff

/-- TomlConfig hasKey.
C ABI: `uint32_t lean_fs_tomlcfg_has_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_tomlcfg_has_key]
public unsafe def tomlcfgHasKey (addr : USize) (n : USize) (key : USize) (keyLen : USize) : U32 :=
  Systems.TomlConfig.hasKey addr n key keyLen

/-- TomlConfig leanExeCount.
C ABI: `size_t lean_fs_tomlcfg_lean_exe_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_lean_exe_count]
public unsafe def tomlcfgLeanExeCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.leanExeCount addr n

/-- TomlConfig defaultTargetsCount.
C ABI: `size_t lean_fs_tomlcfg_default_targets_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_default_targets_count]
public unsafe def tomlcfgDefaultTargetsCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.defaultTargetsCount addr n

/-- TomlConfig hasSrcDir.
C ABI: `uint32_t lean_fs_tomlcfg_has_src_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_src_dir]
public unsafe def tomlcfgHasSrcDir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSrcDir addr n

/-- TomlConfig srcDirOff.
C ABI: `size_t lean_fs_tomlcfg_src_dir_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_src_dir_off]
public unsafe def tomlcfgSrcDirOff (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.srcDirOff addr n

/-- TomlConfig srcDirLen.
C ABI: `size_t lean_fs_tomlcfg_src_dir_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_src_dir_len]
public unsafe def tomlcfgSrcDirLen (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.srcDirLen addr n

/-- TomlConfig versionOff.
C ABI: `size_t lean_fs_tomlcfg_version_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_version_off]
public unsafe def tomlcfgVersionOff (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.versionOff addr n

/-- TomlConfig versionLen.
C ABI: `size_t lean_fs_tomlcfg_version_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_version_len]
public unsafe def tomlcfgVersionLen (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.versionLen addr n

/-- TomlConfig hasBuildType.
C ABI: `uint32_t lean_fs_tomlcfg_has_build_type(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_build_type]
public unsafe def tomlcfgHasBuildType (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBuildType addr n

/-- TomlConfig requirePathCount.
C ABI: `size_t lean_fs_tomlcfg_require_path_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_require_path_count]
public unsafe def tomlcfgRequirePathCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.requirePathCount addr n

/-- TomlConfig requirePathScopedCount (path= only under [[require]]).
C ABI: `size_t lean_fs_tomlcfg_require_path_scoped_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_require_path_scoped_count]
public unsafe def tomlcfgRequirePathScopedCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.requirePathScopedCount addr n

/-- TomlConfig hasDefaultTargets.
C ABI: `uint32_t lean_fs_tomlcfg_has_default_targets(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_default_targets]
public unsafe def tomlcfgHasDefaultTargets (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDefaultTargets addr n

/-- TomlConfig moreLeanArgsCount (quote-count style).
C ABI: `size_t lean_fs_tomlcfg_more_lean_args_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_more_lean_args_count]
public unsafe def tomlcfgMoreLeanArgsCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.moreLeanArgsCount addr n

/-- TomlConfig hasBackend.
C ABI: `uint32_t lean_fs_tomlcfg_has_backend(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_backend]
public unsafe def tomlcfgHasBackend (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBackend addr n

/-- TomlConfig hasTestDriver.
C ABI: `uint32_t lean_fs_tomlcfg_has_test_driver(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_test_driver]
public unsafe def tomlcfgHasTestDriver (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasTestDriver addr n

/-- TomlConfig hasLintDriver.
C ABI: `uint32_t lean_fs_tomlcfg_has_lint_driver(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lint_driver]
public unsafe def tomlcfgHasLintDriver (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLintDriver addr n

/-- TomlConfig weakLeanArgsCount (quote-count style).
C ABI: `size_t lean_fs_tomlcfg_weak_lean_args_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_weak_lean_args_count]
public unsafe def tomlcfgWeakLeanArgsCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.weakLeanArgsCount addr n

/-- TomlConfig firstLeanLibNameOff (scoped under first [[lean_lib]]).
C ABI: `size_t lean_fs_tomlcfg_first_lean_lib_name_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_lean_lib_name_off]
public unsafe def tomlcfgFirstLeanLibNameOff (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstLeanLibNameOff addr n

/-- TomlConfig firstLeanLibNameLen (scoped under first [[lean_lib]]).
C ABI: `size_t lean_fs_tomlcfg_first_lean_lib_name_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_lean_lib_name_len]
public unsafe def tomlcfgFirstLeanLibNameLen (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstLeanLibNameLen addr n

/-- TomlConfig hasPlatformIndependent (top-level key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_platform_independent(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_platform_independent]
public unsafe def tomlcfgHasPlatformIndependent (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPlatformIndependent addr n

/-- TomlConfig hasPreferReleaseBuild (top-level key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_prefer_release_build(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_prefer_release_build]
public unsafe def tomlcfgHasPreferReleaseBuild (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPreferReleaseBuild addr n

/-- TomlConfig leanArgsCount (fail-closed quote count).
C ABI: `size_t lean_fs_tomlcfg_lean_args_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_lean_args_count]
public unsafe def tomlcfgLeanArgsCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.leanArgsCount addr n

/-- TomlConfig firstLeanExeNameOff (scoped under first [[lean_exe]]).
C ABI: `size_t lean_fs_tomlcfg_first_lean_exe_name_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_lean_exe_name_off]
public unsafe def tomlcfgFirstLeanExeNameOff (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstLeanExeNameOff addr n

/-- TomlConfig firstLeanExeNameLen (scoped under first [[lean_exe]]).
C ABI: `size_t lean_fs_tomlcfg_first_lean_exe_name_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_lean_exe_name_len]
public unsafe def tomlcfgFirstLeanExeNameLen (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstLeanExeNameLen addr n

/-- Proc spawn (argv0 = path). Affine `Pid` as `size_t` at C ABI.
C ABI: `size_t lean_fs_proc_spawn(size_t path);` -/
@[export_c lean_fs_proc_spawn]
public unsafe def procSpawn (path : USize) : Systems.Proc.Pid :=
  Systems.Proc.sysSpawn path

/-- Proc spawn with explicit argv0.
C ABI: `size_t lean_fs_proc_spawn_argv0(size_t path, size_t argv0);` -/
@[export_c lean_fs_proc_spawn_argv0]
public unsafe def procSpawnArgv0 (path : USize) (argv0 : USize) : Systems.Proc.Pid :=
  Systems.Proc.sysSpawnArgv0 path argv0

/-- Proc multi-arg spawn (`argvBase` = `size_t[argc]` C string pointers).
C ABI: `size_t lean_fs_proc_spawn_argv(size_t path, size_t argv_base, size_t argc);` -/
@[export_c lean_fs_proc_spawn_argv]
public unsafe def procSpawnArgv (path : USize) (argvBase : USize) (argc : USize) : Systems.Proc.Pid :=
  Systems.Proc.sysSpawnArgv path argvBase argc

/-- Proc pipe(2) into caller `size_t[2]` (read, write).
C ABI: `uint32_t lean_fs_proc_pipe(size_t pipe_fds);` -/
@[export_c lean_fs_proc_pipe]
public unsafe def procPipe (pipeFds : USize) : U32 :=
  Systems.Proc.sysPipe pipeFds

/-- Proc multi-arg spawn with optional stdin/stdout redirect (raw fds; negative = none).
C ABI: `size_t lean_fs_proc_spawn_argv_pipe(size_t path, size_t argv_base, size_t argc,
  size_t stdin_fd, size_t stdout_fd);` -/
@[export_c lean_fs_proc_spawn_argv_pipe]
public unsafe def procSpawnArgvPipe (path : USize) (argvBase : USize) (argc : USize)
    (stdinFd : USize) (stdoutFd : USize) : Systems.Proc.Pid :=
  Systems.Proc.sysSpawnArgvPipe path argvBase argc stdinFd stdoutFd

/-- Proc close raw fd (pipe ends held as size_t).
C ABI: `uint32_t lean_fs_proc_close_raw(size_t fd);` -/
@[export_c lean_fs_proc_close_raw]
public unsafe def procCloseRaw (fd : USize) : U32 :=
  Systems.Proc.sysCloseRaw fd

/-- Proc wait (consumes affine Pid; returns encoded exit status).
C ABI: `uint32_t lean_fs_proc_wait(size_t pid);` -/
@[export_c lean_fs_proc_wait]
public unsafe def procWait (pid : Systems.Proc.Pid) : U32 :=
  Systems.Proc.sysWait pid

/-- Proc pidIsNeg (borrow; does not consume).
C ABI: `uint32_t lean_fs_proc_pid_is_neg(size_t pid);` -/
@[fs_borrow, export_c lean_fs_proc_pid_is_neg]
public unsafe def procPidIsNeg (pid : Systems.Proc.Pid) : U32 :=
  bifU32 (Systems.Proc.pidIsNeg pid) U32.one U32.zero

/-- Manifest validate (JSON-ish lockfile balance).
C ABI: `uint32_t lean_fs_manifest_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_manifest_validate]
public unsafe def manifestValidate (addr : USize) (n : USize) : U32 :=
  Systems.Manifest.validate addr n

/-- Manifest scan (alias of validate).
C ABI: `uint32_t lean_fs_manifest_scan(size_t addr, size_t n);` -/
@[export_c lean_fs_manifest_scan]
public unsafe def manifestScan (addr : USize) (n : USize) : U32 :=
  Systems.Manifest.scan addr n

/-- Manifest findKey (`"key"` opening quote).
C ABI: `size_t lean_fs_manifest_find_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_manifest_find_key]
public unsafe def manifestFindKey (addr : USize) (n : USize) (key : USize) (keyLen : USize) : USize :=
  Systems.Manifest.findKey addr n key keyLen

/-- Manifest valueOff (string value content start).
C ABI: `size_t lean_fs_manifest_value_off(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_manifest_value_off]
public unsafe def manifestValueOff (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.Manifest.valueOff addr n keyOff

/-- Manifest valueLen (string value content length).
C ABI: `size_t lean_fs_manifest_value_len(size_t addr, size_t n, size_t key_off);` -/
@[export_c lean_fs_manifest_value_len]
public unsafe def manifestValueLen (addr : USize) (n : USize) (keyOff : USize) : USize :=
  Systems.Manifest.valueLen addr n keyOff

/-- Manifest hasKey.
C ABI: `uint32_t lean_fs_manifest_has_key(size_t addr, size_t n, size_t key, size_t key_len);` -/
@[export_c lean_fs_manifest_has_key]
public unsafe def manifestHasKey (addr : USize) (n : USize) (key : USize) (keyLen : USize) : U32 :=
  Systems.Manifest.hasKey addr n key keyLen

/-- Manifest packageNameOff.
C ABI: `size_t lean_fs_manifest_package_name_off(size_t addr, size_t n);` -/
@[export_c lean_fs_manifest_package_name_off]
public unsafe def manifestPackageNameOff (addr : USize) (n : USize) : USize :=
  Systems.Manifest.packageNameOff addr n

/-- Manifest packageNameLen.
C ABI: `size_t lean_fs_manifest_package_name_len(size_t addr, size_t n);` -/
@[export_c lean_fs_manifest_package_name_len]
public unsafe def manifestPackageNameLen (addr : USize) (n : USize) : USize :=
  Systems.Manifest.packageNameLen addr n

/-- Manifest hasUrl.
C ABI: `uint32_t lean_fs_manifest_has_url(size_t addr, size_t n);` -/
@[export_c lean_fs_manifest_has_url]
public unsafe def manifestHasUrl (addr : USize) (n : USize) : U32 :=
  Systems.Manifest.hasUrl addr n

/-- Manifest hasRev.
C ABI: `uint32_t lean_fs_manifest_has_rev(size_t addr, size_t n);` -/
@[export_c lean_fs_manifest_has_rev]
public unsafe def manifestHasRev (addr : USize) (n : USize) : U32 :=
  Systems.Manifest.hasRev addr n

/-- Manifest hasVersion.
C ABI: `uint32_t lean_fs_manifest_has_version(size_t addr, size_t n);` -/
@[export_c lean_fs_manifest_has_version]
public unsafe def manifestHasVersion (addr : USize) (n : USize) : U32 :=
  Systems.Manifest.hasVersion addr n

/-- CacheIndex init.
C ABI: `uint32_t lean_fs_cacheindex_init(size_t keys, size_t cap);` -/
@[export_c lean_fs_cacheindex_init]
public def cacheindexInit (keys : USize) (cap : USize) : U32 :=
  Systems.CacheIndex.init keys cap

/-- CacheIndex clear.
C ABI: `uint32_t lean_fs_cacheindex_clear(size_t keys, size_t cap);` -/
@[export_c lean_fs_cacheindex_clear]
public def cacheindexClear (keys : USize) (cap : USize) : U32 :=
  Systems.CacheIndex.clear keys cap

/-- CacheIndex len.
C ABI: `size_t lean_fs_cacheindex_len(size_t n);` -/
@[export_c lean_fs_cacheindex_len]
public def cacheindexLen (n : USize) : USize :=
  Systems.CacheIndex.len n

/-- CacheIndex capacity.
C ABI: `size_t lean_fs_cacheindex_capacity(size_t cap);` -/
@[export_c lean_fs_cacheindex_capacity]
public def cacheindexCapacity (cap : USize) : USize :=
  Systems.CacheIndex.capacity cap

/-- CacheIndex isEmpty.
C ABI: `uint32_t lean_fs_cacheindex_is_empty(size_t n);` -/
@[export_c lean_fs_cacheindex_is_empty]
public def cacheindexIsEmpty (n : USize) : U32 :=
  Systems.CacheIndex.isEmpty n

/-- CacheIndex isFull.
C ABI: `uint32_t lean_fs_cacheindex_is_full(size_t cap, size_t n);` -/
@[export_c lean_fs_cacheindex_is_full]
public def cacheindexIsFull (cap : USize) (n : USize) : U32 :=
  Systems.CacheIndex.isFull cap n

/-- CacheIndex lowerBound.
C ABI: `size_t lean_fs_cacheindex_lower_bound(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_cacheindex_lower_bound]
public unsafe def cacheindexLowerBound (keys : USize) (n : USize) (key : U32) : USize :=
  Systems.CacheIndex.lowerBound keys n key

/-- CacheIndex contains.
C ABI: `uint32_t lean_fs_cacheindex_contains(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_cacheindex_contains]
public unsafe def cacheindexContains (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.CacheIndex.contains keys n key

/-- CacheIndex get.
C ABI: `size_t lean_fs_cacheindex_get(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_cacheindex_get]
public unsafe def cacheindexGet (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.CacheIndex.get keys n i

/-- CacheIndex indexAt.
C ABI: `size_t lean_fs_cacheindex_at(size_t keys, size_t n, size_t i);` -/
@[export_c lean_fs_cacheindex_at]
public unsafe def cacheindexAt (keys : USize) (n : USize) (i : USize) : USize :=
  Systems.CacheIndex.indexAt keys n i

/-- CacheIndex insert / put (precomputed key).
C ABI: `uint32_t lean_fs_cacheindex_put(size_t keys, size_t cap, size_t n, uint32_t key);` -/
@[export_c lean_fs_cacheindex_put]
public unsafe def cacheindexPut (keys : USize) (cap : USize) (n : USize) (key : U32) : U32 :=
  Systems.CacheIndex.put keys cap n key

/-- CacheIndex mixPut (hashBytes + insert).
C ABI: `uint32_t lean_fs_cacheindex_mix_put(size_t keys, size_t cap, size_t n, size_t addr, size_t len);` -/
@[export_c lean_fs_cacheindex_mix_put]
public unsafe def cacheindexMixPut (keys : USize) (cap : USize) (n : USize)
    (addr : USize) (len : USize) : U32 :=
  Systems.CacheIndex.mixPut keys cap n addr len

/-- CacheIndex remove.
C ABI: `uint32_t lean_fs_cacheindex_remove(size_t keys, size_t n, uint32_t key);` -/
@[export_c lean_fs_cacheindex_remove]
public unsafe def cacheindexRemove (keys : USize) (n : USize) (key : U32) : U32 :=
  Systems.CacheIndex.remove keys n key

/-- L2tp validate (length-class min-6; not full L2TP control plane).
C ABI: `uint32_t lean_fs_l2tp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_l2tp_validate]
public unsafe def l2tpValidate (addr : USize) (n : USize) : U32 :=
  Systems.L2tp.validate addr n

/-- L2tp parse (alias of validate).
C ABI: `uint32_t lean_fs_l2tp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_l2tp_parse]
public unsafe def l2tpParse (addr : USize) (n : USize) : U32 :=
  Systems.L2tp.parse addr n

/-- L2tp flags (byte0).
C ABI: `uint32_t lean_fs_l2tp_flags(size_t addr, size_t n);` -/
@[export_c lean_fs_l2tp_flags]
public unsafe def l2tpFlags (addr : USize) (n : USize) : U32 :=
  Systems.L2tp.flags addr n

/-- L2tp version (low 4 bits of byte1).
C ABI: `uint32_t lean_fs_l2tp_version(size_t addr, size_t n);` -/
@[export_c lean_fs_l2tp_version]
public unsafe def l2tpVersion (addr : USize) (n : USize) : U32 :=
  Systems.L2tp.version addr n

/-- L2tp hasLength (L bit).
C ABI: `uint32_t lean_fs_l2tp_has_length(size_t addr, size_t n);` -/
@[export_c lean_fs_l2tp_has_length]
public unsafe def l2tpHasLength (addr : USize) (n : USize) : U32 :=
  Systems.L2tp.hasLength addr n

/-- L2tp length (optional BE U16 when L set).
C ABI: `uint32_t lean_fs_l2tp_length(size_t addr, size_t n);` -/
@[export_c lean_fs_l2tp_length]
public unsafe def l2tpLength (addr : USize) (n : USize) : U32 :=
  Systems.L2tp.length addr n

/-- L2tp tunnelId (L-adaptive BE U16 as USize).
C ABI: `size_t lean_fs_l2tp_tunnel_id(size_t addr, size_t n);` -/
@[export_c lean_fs_l2tp_tunnel_id]
public unsafe def l2tpTunnelId (addr : USize) (n : USize) : USize :=
  Systems.L2tp.tunnelId addr n

/-- L2tp sessionId (L-adaptive BE U16 as USize).
C ABI: `size_t lean_fs_l2tp_session_id(size_t addr, size_t n);` -/
@[export_c lean_fs_l2tp_session_id]
public unsafe def l2tpSessionId (addr : USize) (n : USize) : USize :=
  Systems.L2tp.sessionId addr n

/-- Pptp validate (length-class min-8; not full PPTP).
C ABI: `uint32_t lean_fs_pptp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_pptp_validate]
public unsafe def pptpValidate (addr : USize) (n : USize) : U32 :=
  Systems.Pptp.validate addr n

/-- Pptp parse (alias of validate).
C ABI: `uint32_t lean_fs_pptp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_pptp_parse]
public unsafe def pptpParse (addr : USize) (n : USize) : U32 :=
  Systems.Pptp.parse addr n

/-- Pptp length (BE U16).
C ABI: `uint32_t lean_fs_pptp_length(size_t addr, size_t n);` -/
@[export_c lean_fs_pptp_length]
public unsafe def pptpLength (addr : USize) (n : USize) : U32 :=
  Systems.Pptp.length addr n

/-- Pptp messageType (BE U16).
C ABI: `uint32_t lean_fs_pptp_message_type(size_t addr, size_t n);` -/
@[export_c lean_fs_pptp_message_type]
public unsafe def pptpMessageType (addr : USize) (n : USize) : U32 :=
  Systems.Pptp.messageType addr n

/-- Pptp magicCookie (BE U32 as USize).
C ABI: `size_t lean_fs_pptp_magic_cookie(size_t addr, size_t n);` -/
@[export_c lean_fs_pptp_magic_cookie]
public unsafe def pptpMagicCookie (addr : USize) (n : USize) : USize :=
  Systems.Pptp.magicCookie addr n

/-- Pptp hasMagic (cookie 0x1A2B3C4D).
C ABI: `uint32_t lean_fs_pptp_has_magic(size_t addr, size_t n);` -/
@[export_c lean_fs_pptp_has_magic]
public unsafe def pptpHasMagic (addr : USize) (n : USize) : U32 :=
  Systems.Pptp.hasMagic addr n

/-- L2f validate (length-class min-4; not full L2F).
C ABI: `uint32_t lean_fs_l2f_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_l2f_validate]
public unsafe def l2fValidate (addr : USize) (n : USize) : U32 :=
  Systems.L2f.validate addr n

/-- L2f parse (alias of validate).
C ABI: `uint32_t lean_fs_l2f_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_l2f_parse]
public unsafe def l2fParse (addr : USize) (n : USize) : U32 :=
  Systems.L2f.parse addr n

/-- L2f flags (byte0).
C ABI: `uint32_t lean_fs_l2f_flags(size_t addr, size_t n);` -/
@[export_c lean_fs_l2f_flags]
public unsafe def l2fFlags (addr : USize) (n : USize) : U32 :=
  Systems.L2f.flags addr n

/-- L2f version (low 3 bits of byte1).
C ABI: `uint32_t lean_fs_l2f_version(size_t addr, size_t n);` -/
@[export_c lean_fs_l2f_version]
public unsafe def l2fVersion (addr : USize) (n : USize) : U32 :=
  Systems.L2f.version addr n

/-- L2f protocol (U8 at offset 2).
C ABI: `uint32_t lean_fs_l2f_protocol(size_t addr, size_t n);` -/
@[export_c lean_fs_l2f_protocol]
public unsafe def l2fProtocol (addr : USize) (n : USize) : U32 :=
  Systems.L2f.protocol addr n

/-- L2f hasKey (K bit).
C ABI: `uint32_t lean_fs_l2f_has_key(size_t addr, size_t n);` -/
@[export_c lean_fs_l2f_has_key]
public unsafe def l2fHasKey (addr : USize) (n : USize) : U32 :=
  Systems.L2f.hasKey addr n

/-- L2f hasSeq (S bit).
C ABI: `uint32_t lean_fs_l2f_has_seq(size_t addr, size_t n);` -/
@[export_c lean_fs_l2f_has_seq]
public unsafe def l2fHasSeq (addr : USize) (n : USize) : U32 :=
  Systems.L2f.hasSeq addr n

/-- Ppp validate.
C ABI: `uint32_t lean_fs_ppp_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_ppp_validate]
public unsafe def pppValidate (addr : USize) (n : USize) : U32 :=
  Systems.Ppp.validate addr n

/-- Ppp parse.
C ABI: `uint32_t lean_fs_ppp_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_ppp_parse]
public unsafe def pppParse (addr : USize) (n : USize) : U32 :=
  Systems.Ppp.parse addr n

/-- Ppp address.
C ABI: `uint32_t lean_fs_ppp_address(size_t addr, size_t n);` -/
@[export_c lean_fs_ppp_address]
public unsafe def pppAddress (addr : USize) (n : USize) : U32 :=
  Systems.Ppp.address addr n

/-- Ppp control.
C ABI: `uint32_t lean_fs_ppp_control(size_t addr, size_t n);` -/
@[export_c lean_fs_ppp_control]
public unsafe def pppControl (addr : USize) (n : USize) : U32 :=
  Systems.Ppp.control addr n

/-- Ppp protocol (BE U16).
C ABI: `uint32_t lean_fs_ppp_protocol(size_t addr, size_t n);` -/
@[export_c lean_fs_ppp_protocol]
public unsafe def pppProtocol (addr : USize) (n : USize) : U32 :=
  Systems.Ppp.protocol addr n

/-- Ppp hasAllStations.
C ABI: `uint32_t lean_fs_ppp_has_all_stations(size_t addr, size_t n);` -/
@[export_c lean_fs_ppp_has_all_stations]
public unsafe def pppHasAllStations (addr : USize) (n : USize) : U32 :=
  Systems.Ppp.hasAllStations addr n

/-- Ppp hasUiControl.
C ABI: `uint32_t lean_fs_ppp_has_ui_control(size_t addr, size_t n);` -/
@[export_c lean_fs_ppp_has_ui_control]
public unsafe def pppHasUiControl (addr : USize) (n : USize) : U32 :=
  Systems.Ppp.hasUiControl addr n

/-- Hdlc validate.
C ABI: `uint32_t lean_fs_hdlc_validate(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_validate]
public unsafe def hdlcValidate (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.validate addr n

/-- Hdlc parse.
C ABI: `uint32_t lean_fs_hdlc_parse(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_parse]
public unsafe def hdlcParse (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.parse addr n

/-- Hdlc flag.
C ABI: `uint32_t lean_fs_hdlc_flag(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_flag]
public unsafe def hdlcFlag (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.flag addr n

/-- Hdlc address.
C ABI: `uint32_t lean_fs_hdlc_address(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_address]
public unsafe def hdlcAddress (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.address addr n

/-- Hdlc control.
C ABI: `uint32_t lean_fs_hdlc_control(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_control]
public unsafe def hdlcControl (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.control addr n

/-- Hdlc info0.
C ABI: `uint32_t lean_fs_hdlc_info0(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_info0]
public unsafe def hdlcInfo0 (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.info0 addr n

/-- Hdlc hasOpenFlag.
C ABI: `uint32_t lean_fs_hdlc_has_open_flag(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_has_open_flag]
public unsafe def hdlcHasOpenFlag (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.hasOpenFlag addr n

/-- Hdlc hasAllStations.
C ABI: `uint32_t lean_fs_hdlc_has_all_stations(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_has_all_stations]
public unsafe def hdlcHasAllStations (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.hasAllStations addr n

/-- Hdlc hasUiControl.
C ABI: `uint32_t lean_fs_hdlc_has_ui_control(size_t addr, size_t n);` -/
@[export_c lean_fs_hdlc_has_ui_control]
public unsafe def hdlcHasUiControl (addr : USize) (n : USize) : U32 :=
  Systems.Hdlc.hasUiControl addr n

/-- TomlConfig moreLinkArgsCount (fail-closed quote count).
C ABI: `size_t lean_fs_tomlcfg_more_link_args_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_more_link_args_count]
public unsafe def tomlcfgMoreLinkArgsCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.moreLinkArgsCount addr n

/-- TomlConfig hasBuildArchive (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_build_archive(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_build_archive]
public unsafe def tomlcfgHasBuildArchive (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBuildArchive addr n

/-- TomlConfig hasSupportInterpreter (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_support_interpreter(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_support_interpreter]
public unsafe def tomlcfgHasSupportInterpreter (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSupportInterpreter addr n

/-- TomlConfig firstRequireNameOff (scoped under first [[require]]).
C ABI: `size_t lean_fs_tomlcfg_first_require_name_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_name_off]
public unsafe def tomlcfgFirstRequireNameOff (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireNameOff addr n

/-- TomlConfig firstRequireNameLen (scoped under first [[require]]).
C ABI: `size_t lean_fs_tomlcfg_first_require_name_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_name_len]
public unsafe def tomlcfgFirstRequireNameLen (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireNameLen addr n

/-- TomlConfig weakLinkArgsCount (fail-closed quote count).
C ABI: `size_t lean_fs_tomlcfg_weak_link_args_count(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_weak_link_args_count]
public unsafe def tomlcfgWeakLinkArgsCount (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.weakLinkArgsCount addr n

/-- TomlConfig hasEnableArtifactCache (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_enable_artifact_cache(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_enable_artifact_cache]
public unsafe def tomlcfgHasEnableArtifactCache (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasEnableArtifactCache addr n

/-- TomlConfig hasPrecompileModules (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_precompile_modules(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_precompile_modules]
public unsafe def tomlcfgHasPrecompileModules (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPrecompileModules addr n

/-- TomlConfig firstLeanLibRootOff (scoped under first [[lean_lib]]).
C ABI: `size_t lean_fs_tomlcfg_first_lean_lib_root_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_lean_lib_root_off]
public unsafe def tomlcfgFirstLeanLibRootOff (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstLeanLibRootOff addr n

/-- TomlConfig firstLeanLibRootLen (scoped under first [[lean_lib]]).
C ABI: `size_t lean_fs_tomlcfg_first_lean_lib_root_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_lean_lib_root_len]
public unsafe def tomlcfgFirstLeanLibRootLen (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstLeanLibRootLen addr n

/-- TomlConfig hasPackagesDir (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_packages_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_packages_dir]
public unsafe def tomlcfgHasPackagesDir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPackagesDir addr n

/-- TomlConfig hasReservoir (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_reservoir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_reservoir]
public unsafe def tomlcfgHasReservoir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasReservoir addr n

/-- TomlConfig firstLeanExeRootOff (scoped under first [[lean_exe]]).
C ABI: `size_t lean_fs_tomlcfg_first_lean_exe_root_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_lean_exe_root_off]
public unsafe def tomlcfgFirstLeanExeRootOff (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstLeanExeRootOff addr n

/-- TomlConfig firstLeanExeRootLen (scoped under first [[lean_exe]]).
C ABI: `size_t lean_fs_tomlcfg_first_lean_exe_root_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_lean_exe_root_len]
public unsafe def tomlcfgFirstLeanExeRootLen (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstLeanExeRootLen addr n

/-- TomlConfig hasBuildDir (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_build_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_build_dir]
public unsafe def lean_fs_tomlcfg_has_build_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBuildDir addr n

/-- TomlConfig hasWrappersDir (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_wrappers_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_wrappers_dir]
public unsafe def lean_fs_tomlcfg_has_wrappers_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasWrappersDir addr n

/-- TomlConfig firstRequirePathOff (scoped under first [[require]]).
C ABI: `size_t lean_fs_tomlcfg_first_require_path_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_path_off]
public unsafe def lean_fs_tomlcfg_first_require_path_off (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequirePathOff addr n

/-- TomlConfig firstRequirePathLen (scoped under first [[require]]).
C ABI: `size_t lean_fs_tomlcfg_first_require_path_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_path_len]
public unsafe def lean_fs_tomlcfg_first_require_path_len (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequirePathLen addr n

/-- TomlConfig hasNativeLibDir (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_native_lib_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_native_lib_dir]
public unsafe def lean_fs_tomlcfg_has_native_lib_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNativeLibDir addr n

/-- TomlConfig hasTestDriverArgs (first non-comment key presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_test_driver_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_test_driver_args]
public unsafe def lean_fs_tomlcfg_has_test_driver_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasTestDriverArgs addr n

/-- TomlConfig firstRequireRevOff (scoped under first [[require]]).
C ABI: `size_t lean_fs_tomlcfg_first_require_rev_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_rev_off]
public unsafe def lean_fs_tomlcfg_first_require_rev_off (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireRevOff addr n

/-- TomlConfig firstRequireRevLen (scoped under first [[require]]).
C ABI: `size_t lean_fs_tomlcfg_first_require_rev_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_rev_len]
public unsafe def lean_fs_tomlcfg_first_require_rev_len (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireRevLen addr n

/-- TomlConfig hasLintDriverArgs (W75 more10).
C ABI: `uint32_t lean_fs_tomlcfg_has_lint_driver_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lint_driver_args]
public unsafe def lean_fs_tomlcfg_has_lint_driver_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLintDriverArgs addr n

/-- TomlConfig hasMoreLinkArgs (W75 more10 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_more_link_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_more_link_args]
public unsafe def lean_fs_tomlcfg_has_more_link_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMoreLinkArgs addr n

/-- TomlConfig firstRequireGitOff (W75 more10).
C ABI: `size_t lean_fs_tomlcfg_first_require_git_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_git_off]
public unsafe def lean_fs_tomlcfg_first_require_git_off (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireGitOff addr n

/-- TomlConfig firstRequireGitLen (W75 more10).
C ABI: `size_t lean_fs_tomlcfg_first_require_git_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_git_len]
public unsafe def lean_fs_tomlcfg_first_require_git_len (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireGitLen addr n

/-- TomlConfig hasLeanOptions (W76 more11).
C ABI: `uint32_t lean_fs_tomlcfg_has_lean_options(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lean_options]
public unsafe def lean_fs_tomlcfg_has_lean_options (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLeanOptions addr n

/-- TomlConfig hasMoreServerOptions (W76 more11 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_more_server_options(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_more_server_options]
public unsafe def lean_fs_tomlcfg_has_more_server_options (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMoreServerOptions addr n

/-- TomlConfig firstRequireUrlOff (W76 more11).
C ABI: `size_t lean_fs_tomlcfg_first_require_url_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_url_off]
public unsafe def lean_fs_tomlcfg_first_require_url_off (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireUrlOff addr n

/-- TomlConfig firstRequireUrlLen (W76 more11).
C ABI: `size_t lean_fs_tomlcfg_first_require_url_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_url_len]
public unsafe def lean_fs_tomlcfg_first_require_url_len (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireUrlLen addr n

/-- TomlConfig hasManifest (W77 more12).
C ABI: `uint32_t lean_fs_tomlcfg_has_manifest(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_manifest]
public unsafe def lean_fs_tomlcfg_has_manifest (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasManifest addr n

/-- TomlConfig hasVersionTags (W77 more12 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_version_tags(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_version_tags]
public unsafe def lean_fs_tomlcfg_has_version_tags (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasVersionTags addr n

/-- TomlConfig firstRequireVersionOff (W77 more12).
C ABI: `size_t lean_fs_tomlcfg_first_require_version_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_version_off]
public unsafe def lean_fs_tomlcfg_first_require_version_off (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireVersionOff addr n

/-- TomlConfig firstRequireVersionLen (W77 more12).
C ABI: `size_t lean_fs_tomlcfg_first_require_version_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_version_len]
public unsafe def lean_fs_tomlcfg_first_require_version_len (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireVersionLen addr n

/-- TomlConfig hasDescription (W78 more13).
C ABI: `uint32_t lean_fs_tomlcfg_has_description(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_description]
public unsafe def lean_fs_tomlcfg_has_description (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDescription addr n

/-- TomlConfig hasKeywords (W78 more13).
C ABI: `uint32_t lean_fs_tomlcfg_has_keywords(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_keywords]
public unsafe def lean_fs_tomlcfg_has_keywords (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasKeywords addr n

/-- TomlConfig firstRequireScopeOff (W78 more13).
C ABI: `size_t lean_fs_tomlcfg_first_require_scope_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_scope_off]
public unsafe def lean_fs_tomlcfg_first_require_scope_off (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireScopeOff addr n

/-- TomlConfig firstRequireScopeLen (W78 more13).
C ABI: `size_t lean_fs_tomlcfg_first_require_scope_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_scope_len]
public unsafe def lean_fs_tomlcfg_first_require_scope_len (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireScopeLen addr n

/-- TomlConfig hasHomepage (W79 more14).
C ABI: `uint32_t lean_fs_tomlcfg_has_homepage(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_homepage]
public unsafe def lean_fs_tomlcfg_has_homepage (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasHomepage addr n

/-- TomlConfig hasLicense (W79 more14).
C ABI: `uint32_t lean_fs_tomlcfg_has_license(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_license]
public unsafe def lean_fs_tomlcfg_has_license (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLicense addr n

/-- TomlConfig firstRequireSubDirOff (W79 more14).
C ABI: `size_t lean_fs_tomlcfg_first_require_subdir_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_subdir_off]
public unsafe def lean_fs_tomlcfg_first_require_subdir_off (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireSubDirOff addr n

/-- TomlConfig firstRequireSubDirLen (W79 more14).
C ABI: `size_t lean_fs_tomlcfg_first_require_subdir_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_subdir_len]
public unsafe def lean_fs_tomlcfg_first_require_subdir_len (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireSubDirLen addr n

/-- TomlConfig hasReadmeFile (W80 more15).
C ABI: `uint32_t lean_fs_tomlcfg_has_readme_file(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_readme_file]
public unsafe def lean_fs_tomlcfg_has_readme_file (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasReadmeFile addr n

/-- TomlConfig hasLicenseFiles (W80 more15).
C ABI: `uint32_t lean_fs_tomlcfg_has_license_files(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_license_files]
public unsafe def lean_fs_tomlcfg_has_license_files (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLicenseFiles addr n

/-- TomlConfig firstRequireOptsOff (W80 more15).
C ABI: `size_t lean_fs_tomlcfg_first_require_opts_off(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_opts_off]
public unsafe def lean_fs_tomlcfg_first_require_opts_off (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireOptsOff addr n

/-- TomlConfig firstRequireOptsLen (W80 more15).
C ABI: `size_t lean_fs_tomlcfg_first_require_opts_len(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_first_require_opts_len]
public unsafe def lean_fs_tomlcfg_first_require_opts_len (addr : USize) (n : USize) : USize :=
  Systems.TomlConfig.firstRequireOptsLen addr n

/-- TomlConfig hasBootstrap (W81 more16).
C ABI: `uint32_t lean_fs_tomlcfg_has_bootstrap(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_bootstrap]
public unsafe def lean_fs_tomlcfg_has_bootstrap (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBootstrap addr n

/-- TomlConfig hasMoreServerArgs (W81 more16).
C ABI: `uint32_t lean_fs_tomlcfg_has_more_server_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_more_server_args]
public unsafe def lean_fs_tomlcfg_has_more_server_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMoreServerArgs addr n

/-- TomlConfig hasReleaseRepo (W81 more16).
C ABI: `uint32_t lean_fs_tomlcfg_has_release_repo(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_release_repo]
public unsafe def lean_fs_tomlcfg_has_release_repo (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasReleaseRepo addr n

/-- TomlConfig hasLeanLibDir (W82 more17).
C ABI: `uint32_t lean_fs_tomlcfg_has_lean_lib_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lean_lib_dir]
public unsafe def lean_fs_tomlcfg_has_lean_lib_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLeanLibDir addr n

/-- TomlConfig hasBinDir (W82 more17).
C ABI: `uint32_t lean_fs_tomlcfg_has_bin_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_bin_dir]
public unsafe def lean_fs_tomlcfg_has_bin_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBinDir addr n

/-- TomlConfig hasIrDir (W82 more17).
C ABI: `uint32_t lean_fs_tomlcfg_has_ir_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_ir_dir]
public unsafe def lean_fs_tomlcfg_has_ir_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasIrDir addr n

/-- TomlConfig hasExtraDepTargets (W83 more18).
C ABI: `uint32_t lean_fs_tomlcfg_has_extra_dep_targets(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_extra_dep_targets]
public unsafe def lean_fs_tomlcfg_has_extra_dep_targets (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasExtraDepTargets addr n

/-- TomlConfig hasRestoreAllArtifacts (W83 more18).
C ABI: `uint32_t lean_fs_tomlcfg_has_restore_all_artifacts(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_restore_all_artifacts]
public unsafe def lean_fs_tomlcfg_has_restore_all_artifacts (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRestoreAllArtifacts addr n

/-- TomlConfig hasLibPrefixOnWindows (W83 more18).
C ABI: `uint32_t lean_fs_tomlcfg_has_lib_prefix_on_windows(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lib_prefix_on_windows]
public unsafe def lean_fs_tomlcfg_has_lib_prefix_on_windows (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLibPrefixOnWindows addr n

/-- TomlConfig hasAllowImportAll (W84 more19 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_allow_import_all(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_allow_import_all]
public unsafe def lean_fs_tomlcfg_has_allow_import_all (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasAllowImportAll addr n

/-- TomlConfig hasFixedToolchain (W84 more19 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_fixed_toolchain(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_fixed_toolchain]
public unsafe def lean_fs_tomlcfg_has_fixed_toolchain (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFixedToolchain addr n

/-- TomlConfig hasVersion (W84 more19 presence-only; not SemVer decode).
C ABI: `uint32_t lean_fs_tomlcfg_has_version(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_version]
public unsafe def lean_fs_tomlcfg_has_version (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasVersion addr n

/-- TomlConfig hasBuiltinLint (W85 more20 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_builtin_lint(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_builtin_lint]
public unsafe def lean_fs_tomlcfg_has_builtin_lint (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBuiltinLint addr n

/-- TomlConfig hasMoreLeancArgs (W85 more20 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_more_leanc_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_more_leanc_args]
public unsafe def lean_fs_tomlcfg_has_more_leanc_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMoreLeancArgs addr n

/-- TomlConfig hasAllowNonModules (W85 more20 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_allow_non_modules(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_allow_non_modules]
public unsafe def lean_fs_tomlcfg_has_allow_non_modules (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasAllowNonModules addr n

/-- TomlConfig hasRequiresModuleSystem (W86 more21 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_requires_module_system(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_requires_module_system]
public unsafe def lean_fs_tomlcfg_has_requires_module_system (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRequiresModuleSystem addr n

/-- TomlConfig hasWeakLeancArgs (W86 more21 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_weak_leanc_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_weak_leanc_args]
public unsafe def lean_fs_tomlcfg_has_weak_leanc_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasWeakLeancArgs addr n

/-- TomlConfig hasMoreLinkObjs (W86 more21 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_more_link_objs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_more_link_objs]
public unsafe def lean_fs_tomlcfg_has_more_link_objs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMoreLinkObjs addr n

/-- TomlConfig hasMoreLinkLibs (W87 more22).
C ABI: `uint32_t lean_fs_tomlcfg_has_more_link_libs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_more_link_libs]
public unsafe def lean_fs_tomlcfg_has_more_link_libs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMoreLinkLibs addr n

/-- TomlConfig hasDynlibs (W87 more22).
C ABI: `uint32_t lean_fs_tomlcfg_has_dynlibs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_dynlibs]
public unsafe def lean_fs_tomlcfg_has_dynlibs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDynlibs addr n

/-- TomlConfig hasPlugins (W87 more22).
C ABI: `uint32_t lean_fs_tomlcfg_has_plugins(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_plugins]
public unsafe def lean_fs_tomlcfg_has_plugins (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPlugins addr n

/-- TomlConfig hasDefaultFacets (W88 more23).
C ABI: `uint32_t lean_fs_tomlcfg_has_default_facets(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_default_facets]
public unsafe def lean_fs_tomlcfg_has_default_facets (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDefaultFacets addr n

/-- TomlConfig hasMoreGlobalServerArgs (W88 more23).
C ABI: `uint32_t lean_fs_tomlcfg_has_more_global_server_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_more_global_server_args]
public unsafe def lean_fs_tomlcfg_has_more_global_server_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMoreGlobalServerArgs addr n

/-- TomlConfig hasLibName (W88 more23).
C ABI: `uint32_t lean_fs_tomlcfg_has_lib_name(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lib_name]
public unsafe def lean_fs_tomlcfg_has_lib_name (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLibName addr n

/-- TomlConfig hasScope (W89 more24).
C ABI: `uint32_t lean_fs_tomlcfg_has_scope(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_scope]
public unsafe def lean_fs_tomlcfg_has_scope (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasScope addr n

/-- TomlConfig hasRemoteUrl (W89 more24).
C ABI: `uint32_t lean_fs_tomlcfg_has_remote_url(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_remote_url]
public unsafe def lean_fs_tomlcfg_has_remote_url (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRemoteUrl addr n

/-- TomlConfig hasWeakLeanArgs (W89 more24).
C ABI: `uint32_t lean_fs_tomlcfg_has_weak_lean_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_weak_lean_args]
public unsafe def lean_fs_tomlcfg_has_weak_lean_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasWeakLeanArgs addr n

/-- TomlConfig hasFreestanding (W90 more25).
C ABI: `uint32_t lean_fs_tomlcfg_has_freestanding(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_freestanding]
public unsafe def lean_fs_tomlcfg_has_freestanding (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFreestanding addr n

/-- TomlConfig hasRoots (W90 more25).
C ABI: `uint32_t lean_fs_tomlcfg_has_roots(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_roots]
public unsafe def lean_fs_tomlcfg_has_roots (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRoots addr n

/-- TomlConfig hasGlobs (W90 more25).
C ABI: `uint32_t lean_fs_tomlcfg_has_globs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_globs]
public unsafe def lean_fs_tomlcfg_has_globs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasGlobs addr n

/-- TomlConfig hasNeeds (W91 more26).
C ABI: `uint32_t lean_fs_tomlcfg_has_needs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_needs]
public unsafe def lean_fs_tomlcfg_has_needs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNeeds addr n

/-- TomlConfig hasWeakLinkArgs (W91 more26 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_weak_link_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_weak_link_args]
public unsafe def lean_fs_tomlcfg_has_weak_link_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasWeakLinkArgs addr n

/-- TomlConfig hasExeName (W91 more26).
C ABI: `uint32_t lean_fs_tomlcfg_has_exe_name(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_exe_name]
public unsafe def lean_fs_tomlcfg_has_exe_name (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasExeName addr n

/-- TomlConfig hasMoreLeanArgs (W92 more27 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_more_lean_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_more_lean_args]
public unsafe def lean_fs_tomlcfg_has_more_lean_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMoreLeanArgs addr n

/-- TomlConfig hasNativeFacets (W92 more27).
C ABI: `uint32_t lean_fs_tomlcfg_has_native_facets(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_native_facets]
public unsafe def lean_fs_tomlcfg_has_native_facets (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNativeFacets addr n

/-- TomlConfig hasRoot (W92 more27).
C ABI: `uint32_t lean_fs_tomlcfg_has_root(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_root]
public unsafe def lean_fs_tomlcfg_has_root (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRoot addr n

/-- TomlConfig hasName (W93 more28 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_name(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_name]
public unsafe def lean_fs_tomlcfg_has_name (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasName addr n

/-- TomlConfig hasLeanArgs (W93 more28 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_lean_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lean_args]
public unsafe def lean_fs_tomlcfg_has_lean_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLeanArgs addr n

/-- TomlConfig hasTestRunner (W93 more28 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_test_runner(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_test_runner]
public unsafe def lean_fs_tomlcfg_has_test_runner (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasTestRunner addr n

/-- TomlConfig hasServerOptions (W94 more29 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_server_options(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_server_options]
public unsafe def lean_fs_tomlcfg_has_server_options (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasServerOptions addr n

/-- TomlConfig hasLeancArgs (W94 more29 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_leanc_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_leanc_args]
public unsafe def lean_fs_tomlcfg_has_leanc_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLeancArgs addr n

/-- TomlConfig hasBaseName (W94 more29 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_base_name(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_base_name]
public unsafe def lean_fs_tomlcfg_has_base_name (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBaseName addr n

/-- TomlConfig hasLinkArgs (W95 more30 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_link_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_link_args]
public unsafe def lean_fs_tomlcfg_has_link_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLinkArgs addr n

/-- TomlConfig hasServerArgs (W95 more30 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_server_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_server_args]
public unsafe def lean_fs_tomlcfg_has_server_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasServerArgs addr n

/-- TomlConfig hasGlobalServerArgs (W95 more30 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_global_server_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_global_server_args]
public unsafe def lean_fs_tomlcfg_has_global_server_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasGlobalServerArgs addr n

/-- TomlConfig hasLinkObjs (W96 more31 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_link_objs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_link_objs]
public unsafe def lean_fs_tomlcfg_has_link_objs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLinkObjs addr n

/-- TomlConfig hasLinkLibs (W96 more31 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_link_libs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_link_libs]
public unsafe def lean_fs_tomlcfg_has_link_libs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLinkLibs addr n

/-- TomlConfig hasOptions (W96 more31 presence).
C ABI: `uint32_t lean_fs_tomlcfg_has_options(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_options]
public unsafe def lean_fs_tomlcfg_has_options (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasOptions addr n

/-- TomlConfig hasGit (W97 more32).
C ABI: `uint32_t lean_fs_tomlcfg_has_git(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_git]
public unsafe def lean_fs_tomlcfg_has_git (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasGit addr n

/-- TomlConfig hasPath (W97 more32).
C ABI: `uint32_t lean_fs_tomlcfg_has_path(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_path]
public unsafe def lean_fs_tomlcfg_has_path (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPath addr n

/-- TomlConfig hasRev (W97 more32).
C ABI: `uint32_t lean_fs_tomlcfg_has_rev(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_rev]
public unsafe def lean_fs_tomlcfg_has_rev (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRev addr n

/-- TomlConfig hasSubDir (W98 more33).
C ABI: `uint32_t lean_fs_tomlcfg_has_sub_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_sub_dir]
public unsafe def lean_fs_tomlcfg_has_sub_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSubDir addr n

/-- TomlConfig hasUrl (W98 more33).
C ABI: `uint32_t lean_fs_tomlcfg_has_url(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_url]
public unsafe def lean_fs_tomlcfg_has_url (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasUrl addr n

/-- TomlConfig hasOpts (W98 more33).
C ABI: `uint32_t lean_fs_tomlcfg_has_opts(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_opts]
public unsafe def lean_fs_tomlcfg_has_opts (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasOpts addr n

/-- TomlConfig hasType (W99 more34).
C ABI: `uint32_t lean_fs_tomlcfg_has_type(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_type]
public unsafe def lean_fs_tomlcfg_has_type (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasType addr n

/-- TomlConfig hasDir (W99 more34).
C ABI: `uint32_t lean_fs_tomlcfg_has_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_dir]
public unsafe def lean_fs_tomlcfg_has_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDir addr n

/-- TomlConfig hasSource (W99 more34).
C ABI: `uint32_t lean_fs_tomlcfg_has_source(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_source]
public unsafe def lean_fs_tomlcfg_has_source (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSource addr n

/-- TomlConfig hasKind (W100 more35).
C ABI: `uint32_t lean_fs_tomlcfg_has_kind(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_kind]
public unsafe def lean_fs_tomlcfg_has_kind (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasKind addr n

/-- TomlConfig hasPreset (W100 more35).
C ABI: `uint32_t lean_fs_tomlcfg_has_preset(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_preset]
public unsafe def lean_fs_tomlcfg_has_preset (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPreset addr n

/-- TomlConfig hasExtension (W100 more35).
C ABI: `uint32_t lean_fs_tomlcfg_has_extension(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_extension]
public unsafe def lean_fs_tomlcfg_has_extension (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasExtension addr n

/-- TomlConfig hasFilter (W101 more36).
C ABI: `uint32_t lean_fs_tomlcfg_has_filter(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_filter]
public unsafe def lean_fs_tomlcfg_has_filter (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFilter addr n

/-- TomlConfig hasText (W101 more36).
C ABI: `uint32_t lean_fs_tomlcfg_has_text(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_text]
public unsafe def lean_fs_tomlcfg_has_text (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasText addr n

/-- TomlConfig hasFileName (W101 more36).
C ABI: `uint32_t lean_fs_tomlcfg_has_file_name(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_file_name]
public unsafe def lean_fs_tomlcfg_has_file_name (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFileName addr n

/-- TomlConfig hasStartsWith (W102 more37).
C ABI: `uint32_t lean_fs_tomlcfg_has_starts_with(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_starts_with]
public unsafe def lean_fs_tomlcfg_has_starts_with (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasStartsWith addr n

/-- TomlConfig hasEndsWith (W102 more37).
C ABI: `uint32_t lean_fs_tomlcfg_has_ends_with(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_ends_with]
public unsafe def lean_fs_tomlcfg_has_ends_with (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasEndsWith addr n

/-- TomlConfig hasNot (W102 more37).
C ABI: `uint32_t lean_fs_tomlcfg_has_not(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_not]
public unsafe def lean_fs_tomlcfg_has_not (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNot addr n

/-- TomlConfig hasAny (W103 more38).
C ABI: `uint32_t lean_fs_tomlcfg_has_any(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_any]
public unsafe def lean_fs_tomlcfg_has_any (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasAny addr n

/-- TomlConfig hasAll (W103 more38).
C ABI: `uint32_t lean_fs_tomlcfg_has_all(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_all]
public unsafe def lean_fs_tomlcfg_has_all (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasAll addr n

/-- TomlConfig hasApiEndpoint (W103 more38).
C ABI: `uint32_t lean_fs_tomlcfg_has_api_endpoint(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_api_endpoint]
public unsafe def lean_fs_tomlcfg_has_api_endpoint (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasApiEndpoint addr n

/-- TomlConfig hasArtifactEndpoint (W104 more39).
C ABI: `uint32_t lean_fs_tomlcfg_has_artifact_endpoint(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_artifact_endpoint]
public unsafe def lean_fs_tomlcfg_has_artifact_endpoint (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasArtifactEndpoint addr n

/-- TomlConfig hasRevisionEndpoint (W104 more39).
C ABI: `uint32_t lean_fs_tomlcfg_has_revision_endpoint(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_revision_endpoint]
public unsafe def lean_fs_tomlcfg_has_revision_endpoint (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRevisionEndpoint addr n

/-- TomlConfig hasDefaultService (W104 more39).
C ABI: `uint32_t lean_fs_tomlcfg_has_default_service(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_default_service]
public unsafe def lean_fs_tomlcfg_has_default_service (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDefaultService addr n

/-- TomlConfig hasService (W105 more40).
C ABI: `uint32_t lean_fs_tomlcfg_has_service(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_service]
public unsafe def lean_fs_tomlcfg_has_service (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasService addr n

/-- TomlConfig hasRepo (W105 more40).
C ABI: `uint32_t lean_fs_tomlcfg_has_repo(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_repo]
public unsafe def lean_fs_tomlcfg_has_repo (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRepo addr n

/-- TomlConfig hasSchemaVersion (W105 more40).
C ABI: `uint32_t lean_fs_tomlcfg_has_schema_version(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_schema_version]
public unsafe def lean_fs_tomlcfg_has_schema_version (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSchemaVersion addr n

/-- TomlConfig hasData (W106 more41).
C ABI: `uint32_t lean_fs_tomlcfg_has_data(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_data]
public unsafe def lean_fs_tomlcfg_has_data (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasData addr n

/-- TomlConfig hasManifestFile (W106 more41).
C ABI: `uint32_t lean_fs_tomlcfg_has_manifest_file(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_manifest_file]
public unsafe def lean_fs_tomlcfg_has_manifest_file (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasManifestFile addr n

/-- TomlConfig hasLakeDir (W106 more41).
C ABI: `uint32_t lean_fs_tomlcfg_has_lake_dir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lake_dir]
public unsafe def lean_fs_tomlcfg_has_lake_dir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLakeDir addr n

/-- TomlConfig hasConfigFile (W107 more42).
C ABI: `uint32_t lean_fs_tomlcfg_has_config_file(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_config_file]
public unsafe def lean_fs_tomlcfg_has_config_file (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasConfigFile addr n

/-- TomlConfig hasInputRev (W107 more42).
C ABI: `uint32_t lean_fs_tomlcfg_has_input_rev(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_input_rev]
public unsafe def lean_fs_tomlcfg_has_input_rev (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasInputRev addr n

/-- TomlConfig hasPackages (W107 more42).
C ABI: `uint32_t lean_fs_tomlcfg_has_packages(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_packages]
public unsafe def lean_fs_tomlcfg_has_packages (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPackages addr n

/-- TomlConfig hasInherited.
C ABI: `uint32_t lean_fs_tomlcfg_has_inherited(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_inherited]
public unsafe def lean_fs_tomlcfg_has_inherited (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasInherited addr n

/-- TomlConfig hasGitUrl.
C ABI: `uint32_t lean_fs_tomlcfg_has_git_url(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_git_url]
public unsafe def lean_fs_tomlcfg_has_git_url (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasGitUrl addr n

/-- TomlConfig hasFullName.
C ABI: `uint32_t lean_fs_tomlcfg_has_full_name(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_full_name]
public unsafe def lean_fs_tomlcfg_has_full_name (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFullName addr n

/-- TomlConfig hasDefaultBranch.
C ABI: `uint32_t lean_fs_tomlcfg_has_default_branch(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_default_branch]
public unsafe def lean_fs_tomlcfg_has_default_branch (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDefaultBranch addr n

/-- TomlConfig hasRepoUrl.
C ABI: `uint32_t lean_fs_tomlcfg_has_repo_url(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_repo_url]
public unsafe def lean_fs_tomlcfg_has_repo_url (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRepoUrl addr n

/-- TomlConfig hasSources.
C ABI: `uint32_t lean_fs_tomlcfg_has_sources(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_sources]
public unsafe def lean_fs_tomlcfg_has_sources (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSources addr n

/-- TomlConfig hasRevision.
C ABI: `uint32_t lean_fs_tomlcfg_has_revision(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_revision]
public unsafe def lean_fs_tomlcfg_has_revision (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRevision addr n

/-- TomlConfig hasHost.
C ABI: `uint32_t lean_fs_tomlcfg_has_host(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_host]
public unsafe def lean_fs_tomlcfg_has_host (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasHost addr n

/-- TomlConfig hasHash.
C ABI: `uint32_t lean_fs_tomlcfg_has_hash(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_hash]
public unsafe def lean_fs_tomlcfg_has_hash (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasHash addr n

/-- TomlConfig hasDepHash.
C ABI: `uint32_t lean_fs_tomlcfg_has_dephash(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_dephash]
public unsafe def lean_fs_tomlcfg_has_dephash (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDepHash addr n

/-- TomlConfig hasFile.
C ABI: `uint32_t lean_fs_tomlcfg_has_file(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_file]
public unsafe def lean_fs_tomlcfg_has_file (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFile addr n

/-- TomlConfig hasInputs.
C ABI: `uint32_t lean_fs_tomlcfg_has_inputs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_inputs]
public unsafe def lean_fs_tomlcfg_has_inputs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasInputs addr n

/-- TomlConfig hasOutputs.
C ABI: `uint32_t lean_fs_tomlcfg_has_outputs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_outputs]
public unsafe def lean_fs_tomlcfg_has_outputs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasOutputs addr n

/-- TomlConfig hasStatus.
C ABI: `uint32_t lean_fs_tomlcfg_has_status(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_status]
public unsafe def lean_fs_tomlcfg_has_status (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasStatus addr n

/-- TomlConfig hasLog.
C ABI: `uint32_t lean_fs_tomlcfg_has_log(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_log]
public unsafe def lean_fs_tomlcfg_has_log (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLog addr n

/-- TomlConfig hasSynthetic.
C ABI: `uint32_t lean_fs_tomlcfg_has_synthetic(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_synthetic]
public unsafe def lean_fs_tomlcfg_has_synthetic (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSynthetic addr n

/-- TomlConfig hasMessage.
C ABI: `uint32_t lean_fs_tomlcfg_has_message(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_message]
public unsafe def lean_fs_tomlcfg_has_message (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMessage addr n

/-- TomlConfig hasError.
C ABI: `uint32_t lean_fs_tomlcfg_has_error(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_error]
public unsafe def lean_fs_tomlcfg_has_error (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasError addr n

/-- TomlConfig hasHttpCode.
C ABI: `uint32_t lean_fs_tomlcfg_has_http_code(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_http_code]
public unsafe def lean_fs_tomlcfg_has_http_code (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasHttpCode addr n

/-- TomlConfig hasResponseCode.
C ABI: `uint32_t lean_fs_tomlcfg_has_response_code(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_response_code]
public unsafe def lean_fs_tomlcfg_has_response_code (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasResponseCode addr n

/-- TomlConfig hasErrormsg.
C ABI: `uint32_t lean_fs_tomlcfg_has_errormsg(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_errormsg]
public unsafe def lean_fs_tomlcfg_has_errormsg (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasErrormsg addr n

/-- TomlConfig hasContentType.
C ABI: `uint32_t lean_fs_tomlcfg_has_content_type(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_content_type]
public unsafe def lean_fs_tomlcfg_has_content_type (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasContentType addr n

/-- TomlConfig hasUrlnum.
C ABI: `uint32_t lean_fs_tomlcfg_has_urlnum(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_urlnum]
public unsafe def lean_fs_tomlcfg_has_urlnum (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasUrlnum addr n

/-- TomlConfig hasSizeDownload.
C ABI: `uint32_t lean_fs_tomlcfg_has_size_download(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_size_download]
public unsafe def lean_fs_tomlcfg_has_size_download (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSizeDownload addr n

/-- TomlConfig hasRs.
C ABI: `uint32_t lean_fs_tomlcfg_has_rs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_rs]
public unsafe def lean_fs_tomlcfg_has_rs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRs addr n

/-- TomlConfig hasO.
C ABI: `uint32_t lean_fs_tomlcfg_has_o(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_o]
public unsafe def lean_fs_tomlcfg_has_o (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasO addr n

/-- TomlConfig hasI.
C ABI: `uint32_t lean_fs_tomlcfg_has_i(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_i]
public unsafe def lean_fs_tomlcfg_has_i (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasI addr n

/-- TomlConfig hasM.
C ABI: `uint32_t lean_fs_tomlcfg_has_m(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_m]
public unsafe def lean_fs_tomlcfg_has_m (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasM addr n

/-- TomlConfig hasC.
C ABI: `uint32_t lean_fs_tomlcfg_has_c(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_c]
public unsafe def lean_fs_tomlcfg_has_c (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasC addr n

/-- TomlConfig hasB.
C ABI: `uint32_t lean_fs_tomlcfg_has_b(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_b]
public unsafe def lean_fs_tomlcfg_has_b (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasB addr n

/-- TomlConfig hasL (W118 more53; ModuleArtifacts `"l"` ltar).
C ABI: `uint32_t lean_fs_tomlcfg_has_l(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_l]
public unsafe def lean_fs_tomlcfg_has_l (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasL addr n

/-- TomlConfig hasR (W118 more53; ModuleArtifacts `"r"` ir — distinct from hasRs).
C ABI: `uint32_t lean_fs_tomlcfg_has_r(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_r]
public unsafe def lean_fs_tomlcfg_has_r (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasR addr n

/-- TomlConfig hasRequire (W118 more53; package-table `require`).
C ABI: `uint32_t lean_fs_tomlcfg_has_require(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_require]
public unsafe def lean_fs_tomlcfg_has_require (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRequire addr n

/-- TomlConfig hasValue (W119 more54; real Lake TOML LeanOption table key `value` — Load/Toml.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_value(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_value]
public unsafe def lean_fs_tomlcfg_has_value (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasValue addr n

/-- TomlConfig hasMajor (W119 more54; residual literal key-text `major` — Version parse label, not object key).
C ABI: `uint32_t lean_fs_tomlcfg_has_major(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_major]
public unsafe def lean_fs_tomlcfg_has_major (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMajor addr n

/-- TomlConfig hasMinor (W119 more54; residual literal key-text `minor` — Version parse label, not object key).
C ABI: `uint32_t lean_fs_tomlcfg_has_minor(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_minor]
public unsafe def lean_fs_tomlcfg_has_minor (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMinor addr n

/-- TomlConfig hasArt (W120 more55; Lake cache/artifact ext identity `art` — Artifact.lean / Cache.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_art(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_art]
public unsafe def lean_fs_tomlcfg_has_art (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasArt addr n

/-- TomlConfig hasOlean (W120 more55; Lake cache/compute facet ext `olean` — Module.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_olean(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_olean]
public unsafe def lean_fs_tomlcfg_has_olean (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasOlean addr n

/-- TomlConfig hasLtar (W120 more55; Lake cache/compute facet ext `ltar` — Module.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_ltar(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_ltar]
public unsafe def lean_fs_tomlcfg_has_ltar (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLtar addr n

/-- TomlConfig hasIr (W121 more56; Lake cache/compute facet ext `ir` — Module.lean / Defaults.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_ir(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_ir]
public unsafe def lean_fs_tomlcfg_has_ir (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasIr addr n

/-- TomlConfig hasTraceArgs (W121 more56; Lake build-trace caption `traceArgs` — Common.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_trace_args(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_trace_args]
public unsafe def lean_fs_tomlcfg_has_trace_args (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasTraceArgs addr n

/-- TomlConfig hasDebugAssertions (W121 more56; Lean option NameMap key `debugAssertions` — LeanConfig.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_debug_assertions(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_debug_assertions]
public unsafe def lean_fs_tomlcfg_has_debug_assertions (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDebugAssertions addr n

/-- TomlConfig hasVerLike (W122 more57; Lake version-tag preset `verLike` — Pattern.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_ver_like(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_ver_like]
public unsafe def lean_fs_tomlcfg_has_ver_like (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasVerLike addr n

/-- TomlConfig hasMappings (W122 more57; Lake CLI token `mappings` — CLI/Main.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_mappings(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_mappings]
public unsafe def lean_fs_tomlcfg_has_mappings (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMappings addr n

/-- TomlConfig hasDefault (W122 more57; Lake version-tag preset `default` — Pattern.lean; exact len-7).
C ABI: `uint32_t lean_fs_tomlcfg_has_default(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_default]
public unsafe def lean_fs_tomlcfg_has_default (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDefault addr n

/-- TomlConfig hasObjs (W123 more58; Lake job caption `objs` — Build/Common.lean / Library.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_objs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_objs]
public unsafe def lean_fs_tomlcfg_has_objs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasObjs addr n

/-- TomlConfig hasCache (W123 more58; Lake CLI token `cache` — CLI/Main.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_cache(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_cache]
public unsafe def lean_fs_tomlcfg_has_cache (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasCache addr n

/-- TomlConfig hasScript (W123 more58; Lake CLI/DSL token `script` — CLI/Main.lean / AttributesCore).
C ABI: `uint32_t lean_fs_tomlcfg_has_script(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_script]
public unsafe def lean_fs_tomlcfg_has_script (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasScript addr n

/-- TomlConfig hasExt (W124 more59; Lake artifact/cache field `ext` — Config/Artifact.lean; exact len-3).
C ABI: `uint32_t lean_fs_tomlcfg_has_ext(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_ext]
public unsafe def lean_fs_tomlcfg_has_ext (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasExt addr n

/-- TomlConfig hasLean (W124 more59; Lake CLI/configLang token `lean` — CLI/Main.lean / Load/Package.lean).
C ABI: `uint32_t lean_fs_tomlcfg_has_lean(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lean]
public unsafe def lean_fs_tomlcfg_has_lean (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLean addr n

/-- TomlConfig hasToml (W124 more59; Lake configLang token `toml` — Load/Package.lean / Help).
C ABI: `uint32_t lean_fs_tomlcfg_has_toml(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_toml]
public unsafe def lean_fs_tomlcfg_has_toml (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasToml addr n

/-- TomlConfig hasEnv (W125 more60; Lake CLI token `env` — CLI/Main.lean `| "env" => lake.env`).
C ABI: `uint32_t lean_fs_tomlcfg_has_env(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_env]
public unsafe def lean_fs_tomlcfg_has_env (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasEnv addr n

/-- TomlConfig hasHelp (W125 more60; Lake CLI token `help` — CLI/Main.lean `| "help" => lake.help`).
C ABI: `uint32_t lean_fs_tomlcfg_has_help(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_help]
public unsafe def lean_fs_tomlcfg_has_help (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasHelp addr n

/-- TomlConfig hasCc (W125 more60; Lake install/linker `cc` — Config/InstallPath.lean; exact len-2).
C ABI: `uint32_t lean_fs_tomlcfg_has_cc(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_cc]
public unsafe def lean_fs_tomlcfg_has_cc (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasCc addr n

/-- TomlConfig hasInfo (W126 more61; Lake log token `info` — Util/Log.lean `| "info" | "information"`).
C ABI: `uint32_t lean_fs_tomlcfg_has_info(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_info]
public unsafe def lean_fs_tomlcfg_has_info (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasInfo addr n

/-- TomlConfig hasRemote (W126 more61; Lake git `remote` — Util/Git.lean; exact len-6 vs remoteUrl).
C ABI: `uint32_t lean_fs_tomlcfg_has_remote(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_remote]
public unsafe def lean_fs_tomlcfg_has_remote (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRemote addr n

/-- TomlConfig hasFacets (W126 more61; Lake facet identity — encodeFacets/defaultFacets; exact len-6).
C ABI: `uint32_t lean_fs_tomlcfg_has_facets(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_facets]
public unsafe def lean_fs_tomlcfg_has_facets (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFacets addr n

/-- TomlConfig hasPackage (W127 more62; Lake facet-kind `package` — CLI/Build.lean; exact len-7 vs packages).
C ABI: `uint32_t lean_fs_tomlcfg_has_package(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_package]
public unsafe def lean_fs_tomlcfg_has_package (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPackage addr n

/-- TomlConfig hasModule (W127 more62; Lake facet-kind `module` — CLI/Build.lean; exact len-6).
C ABI: `uint32_t lean_fs_tomlcfg_has_module(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_module]
public unsafe def lean_fs_tomlcfg_has_module (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasModule addr n

/-- TomlConfig hasBuild (W127 more62; Lake CLI/default-dir `build` — CLI/Main.lean; exact len-5 vs buildDir).
C ABI: `uint32_t lean_fs_tomlcfg_has_build(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_build]
public unsafe def lean_fs_tomlcfg_has_build (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBuild addr n

/-- TomlConfig hasClean (W128 more63; Lake CLI `clean` — CLI/Main.lean; exact len-5).
C ABI: `uint32_t lean_fs_tomlcfg_has_clean(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_clean]
public unsafe def lean_fs_tomlcfg_has_clean (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasClean addr n

/-- TomlConfig hasTest (W128 more63; Lake CLI `test` — CLI/Main.lean; exact len-4 vs testDriver).
C ABI: `uint32_t lean_fs_tomlcfg_has_test(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_test]
public unsafe def lean_fs_tomlcfg_has_test (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasTest addr n

/-- TomlConfig hasServe (W128 more63; Lake CLI `serve` — CLI/Main.lean; exact len-5 vs serverArgs).
C ABI: `uint32_t lean_fs_tomlcfg_has_serve(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_serve]
public unsafe def lean_fs_tomlcfg_has_serve (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasServe addr n

/-- TomlConfig hasLint (W129 more64; Lake CLI `lint` — CLI/Main.lean; exact len-4 vs lintDriver).
C ABI: `uint32_t lean_fs_tomlcfg_has_lint(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lint]
public unsafe def lean_fs_tomlcfg_has_lint (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLint addr n

/-- TomlConfig hasExe (W129 more64; Lake CLI `exe` — CLI/Main.lean; exact len-3 vs exeName).
C ABI: `uint32_t lean_fs_tomlcfg_has_exe(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_exe]
public unsafe def lean_fs_tomlcfg_has_exe (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasExe addr n

/-- TomlConfig hasQuery (W129 more64; Lake CLI `query` — CLI/Main.lean; exact len-5).
C ABI: `uint32_t lean_fs_tomlcfg_has_query(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_query]
public unsafe def lean_fs_tomlcfg_has_query (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasQuery addr n

/-- TomlConfig hasInit (W130 more65; Lake CLI `init` — CLI/Main.lean; exact len-4).
C ABI: `uint32_t lean_fs_tomlcfg_has_init(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_init]
public unsafe def lean_fs_tomlcfg_has_init (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasInit addr n

/-- TomlConfig hasNew (W130 more65; Lake CLI `new` — CLI/Main.lean; exact len-3).
C ABI: `uint32_t lean_fs_tomlcfg_has_new(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_new]
public unsafe def lean_fs_tomlcfg_has_new (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNew addr n

/-- TomlConfig hasUpdate (W130 more65; Lake CLI `update` — CLI/Main.lean; exact len-6).
C ABI: `uint32_t lean_fs_tomlcfg_has_update(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_update]
public unsafe def lean_fs_tomlcfg_has_update (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasUpdate addr n

/-- TomlConfig hasPack (W131 more66; Lake CLI `pack` — CLI/Main.lean; exact len-4).
C ABI: `uint32_t lean_fs_tomlcfg_has_pack(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_pack]
public unsafe def lean_fs_tomlcfg_has_pack (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPack addr n

/-- TomlConfig hasUnpack (W131 more66; Lake CLI `unpack` — CLI/Main.lean; exact len-6).
C ABI: `uint32_t lean_fs_tomlcfg_has_unpack(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_unpack]
public unsafe def lean_fs_tomlcfg_has_unpack (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasUnpack addr n

/-- TomlConfig hasUpload (W131 more66; Lake CLI `upload` — CLI/Main.lean; exact len-6 vs update).
C ABI: `uint32_t lean_fs_tomlcfg_has_upload(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_upload]
public unsafe def lean_fs_tomlcfg_has_upload (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasUpload addr n

/-- TomlConfig hasShake (W132 more67; Lake CLI `shake` — CLI/Main.lean; exact len-5).
C ABI: `uint32_t lean_fs_tomlcfg_has_shake(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_shake]
public unsafe def lean_fs_tomlcfg_has_shake (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasShake addr n

/-- TomlConfig hasRun (W132 more67; Lake CLI `run` — CLI/Main.lean; exact len-3).
C ABI: `uint32_t lean_fs_tomlcfg_has_run(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_run]
public unsafe def lean_fs_tomlcfg_has_run (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRun addr n

/-- TomlConfig hasScripts (W132 more67; Lake CLI `scripts` — CLI/Main.lean; exact len-7 vs script).
C ABI: `uint32_t lean_fs_tomlcfg_has_scripts(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_scripts]
public unsafe def lean_fs_tomlcfg_has_scripts (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasScripts addr n

/-- TomlConfig hasGet (W133 more68; Lake CLI `get` — CLI/Main.lean; exact len-3).
C ABI: `uint32_t lean_fs_tomlcfg_has_get(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_get]
public unsafe def lean_fs_tomlcfg_has_get (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasGet addr n

/-- TomlConfig hasPut (W133 more68; Lake CLI `put` — CLI/Main.lean; exact len-3).
C ABI: `uint32_t lean_fs_tomlcfg_has_put(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_put]
public unsafe def lean_fs_tomlcfg_has_put (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPut addr n

/-- TomlConfig hasAdd (W133 more68; Lake CLI `add` — CLI/Main.lean; exact len-3).
C ABI: `uint32_t lean_fs_tomlcfg_has_add(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_add]
public unsafe def lean_fs_tomlcfg_has_add (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasAdd addr n

/-- TomlConfig hasList (W134 more69; Lake CLI `list` — CLI/Main.lean; exact len-4).
C ABI: `uint32_t lean_fs_tomlcfg_has_list(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_list]
public unsafe def lean_fs_tomlcfg_has_list (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasList addr n

/-- TomlConfig hasDoc (W134 more69; Lake CLI `doc` — CLI/Main.lean; exact len-3).
C ABI: `uint32_t lean_fs_tomlcfg_has_doc(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_doc]
public unsafe def lean_fs_tomlcfg_has_doc (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDoc addr n

/-- TomlConfig hasStage (W134 more69; Lake CLI `stage` — CLI/Main.lean; exact len-5).
C ABI: `uint32_t lean_fs_tomlcfg_has_stage(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_stage]
public unsafe def lean_fs_tomlcfg_has_stage (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasStage addr n

/-- TomlConfig hasExec (W135 more70; Lake CLI `exec` — CLI/Main.lean; exact len-4).
C ABI: `uint32_t lean_fs_tomlcfg_has_exec(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_exec]
public unsafe def lean_fs_tomlcfg_has_exec (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasExec addr n

/-- TomlConfig hasUnstage (W135 more70; Lake CLI `unstage` — CLI/Main.lean; exact len-7).
C ABI: `uint32_t lean_fs_tomlcfg_has_unstage(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_unstage]
public unsafe def lean_fs_tomlcfg_has_unstage (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasUnstage addr n

/-- TomlConfig hasPutStaged (W135 more70; Lake CLI `put-staged` — CLI/Main.lean; exact len-10).
C ABI: `uint32_t lean_fs_tomlcfg_has_put_staged(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_put_staged]
public unsafe def lean_fs_tomlcfg_has_put_staged (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPutStaged addr n

/-- TomlConfig hasCheckBuild (W136 more71; Lake CLI `check-build` — CLI/Main.lean; exact len-11).
C ABI: `uint32_t lean_fs_tomlcfg_has_check_build(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_check_build]
public unsafe def lean_fs_tomlcfg_has_check_build (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasCheckBuild addr n

/-- TomlConfig hasCheckLint (W136 more71; Lake CLI `check-lint` — CLI/Main.lean; exact len-10).
C ABI: `uint32_t lean_fs_tomlcfg_has_check_lint(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_check_lint]
public unsafe def lean_fs_tomlcfg_has_check_lint (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasCheckLint addr n

/-- TomlConfig hasCheckTest (W136 more71; Lake CLI `check-test` — CLI/Main.lean; exact len-10).
C ABI: `uint32_t lean_fs_tomlcfg_has_check_test(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_check_test]
public unsafe def lean_fs_tomlcfg_has_check_test (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasCheckTest addr n

/-- TomlConfig hasQueryKind (W137 more72; Lake CLI `query-kind` — CLI/Main.lean; exact len-10).
C ABI: `uint32_t lean_fs_tomlcfg_has_query_kind(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_query_kind]
public unsafe def lean_fs_tomlcfg_has_query_kind (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasQueryKind addr n

/-- TomlConfig hasSetupFile (W137 more72; Lake CLI `setup-file` — CLI/Main.lean; exact len-10).
C ABI: `uint32_t lean_fs_tomlcfg_has_setup_file(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_setup_file]
public unsafe def lean_fs_tomlcfg_has_setup_file (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSetupFile addr n

/-- TomlConfig hasSelfCheck (W137 more72; Lake CLI `self-check` — CLI/Main.lean; exact len-10).
C ABI: `uint32_t lean_fs_tomlcfg_has_self_check(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_self_check]
public unsafe def lean_fs_tomlcfg_has_self_check (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasSelfCheck addr n

/-- TomlConfig hasTranslateConfig (W138 more73; Lake CLI `translate-config` — CLI/Main.lean; exact len-16).
C ABI: `uint32_t lean_fs_tomlcfg_has_translate_config(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_translate_config]
public unsafe def lean_fs_tomlcfg_has_translate_config (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasTranslateConfig addr n

/-- TomlConfig hasResolveDeps (W138 more73; Lake CLI `resolve-deps` — CLI/Main.lean; exact len-12).
C ABI: `uint32_t lean_fs_tomlcfg_has_resolve_deps(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_resolve_deps]
public unsafe def lean_fs_tomlcfg_has_resolve_deps (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasResolveDeps addr n

/-- TomlConfig hasServices (W138 more73; Lake CLI `services` — CLI/Main.lean; exact len-8; ≠ more40 `service`).
C ABI: `uint32_t lean_fs_tomlcfg_has_services(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_services]
public unsafe def lean_fs_tomlcfg_has_services (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasServices addr n

/-- TomlConfig hasReservoirConfig (W139 more74; Lake CLI `reservoir-config` — CLI/Main.lean; exact len-16; ≠ more7 `reservoir`).
C ABI: `uint32_t lean_fs_tomlcfg_has_reservoir_config(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_reservoir_config]
public unsafe def lean_fs_tomlcfg_has_reservoir_config (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasReservoirConfig addr n

/-- TomlConfig hasVersionTagsCli (W139 more74; Lake CLI `version-tags` hyphen — CLI/Main.lean; exact len-12; ≠ more12 camelCase `versionTags`).
C ABI: `uint32_t lean_fs_tomlcfg_has_version_tags_cli(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_version_tags_cli]
public unsafe def lean_fs_tomlcfg_has_version_tags_cli (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasVersionTagsCli addr n

/-- TomlConfig hasUpgrade (W139 more74; Lake CLI `upgrade` — CLI/Main.lean; exact len-7; ≠ more65 `update`).
C ABI: `uint32_t lean_fs_tomlcfg_has_upgrade(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_upgrade]
public unsafe def lean_fs_tomlcfg_has_upgrade (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasUpgrade addr n

/-- TomlConfig hasNoBuild (W140 more75; Lake long-option `no-build` stem — CLI/Main.lean `--no-build`; exact len-8; ≠ more62 `build`).
C ABI: `uint32_t lean_fs_tomlcfg_has_no_build(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_no_build]
public unsafe def lean_fs_tomlcfg_has_no_build (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNoBuild addr n

/-- TomlConfig hasNoCache (W140 more75; Lake long-option `no-cache` stem — CLI/Main.lean `--no-cache`; exact len-8; ≠ more58 `cache`).
C ABI: `uint32_t lean_fs_tomlcfg_has_no_cache(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_no_cache]
public unsafe def lean_fs_tomlcfg_has_no_cache (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNoCache addr n

/-- TomlConfig hasTryCache (W140 more75; Lake long-option `try-cache` stem — CLI/Main.lean `--try-cache`; exact len-9; ≠ more58 `cache` / peer `no-cache`).
C ABI: `uint32_t lean_fs_tomlcfg_has_try_cache(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_try_cache]
public unsafe def lean_fs_tomlcfg_has_try_cache (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasTryCache addr n

/-- TomlConfig hasForceDownload (W141 more76; Lake long-option `force-download` stem — CLI/Main.lean `--force-download`; exact len-14).
C ABI: `uint32_t lean_fs_tomlcfg_has_force_download(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_force_download]
public unsafe def lean_fs_tomlcfg_has_force_download (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasForceDownload addr n

/-- TomlConfig hasDownloadArts (W141 more76; Lake long-option `download-arts` stem — CLI/Main.lean `--download-arts`; exact len-13; ≠ more55 `art`).
C ABI: `uint32_t lean_fs_tomlcfg_has_download_arts(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_download_arts]
public unsafe def lean_fs_tomlcfg_has_download_arts (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasDownloadArts addr n

/-- TomlConfig hasMappingsOnly (W141 more76; Lake long-option `mappings-only` stem — CLI/Main.lean `--mappings-only`; exact len-13; ≠ more57 `mappings`).
C ABI: `uint32_t lean_fs_tomlcfg_has_mappings_only(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_mappings_only]
public unsafe def lean_fs_tomlcfg_has_mappings_only (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMappingsOnly addr n

/-- TomlConfig hasNoOverwrite (W142 more77; Lake long-option `no-overwrite` stem — CLI/Main.lean `--no-overwrite`; exact len-12; reverse peer `force-overwrite`).
C ABI: `uint32_t lean_fs_tomlcfg_has_no_overwrite(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_no_overwrite]
public unsafe def lean_fs_tomlcfg_has_no_overwrite (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNoOverwrite addr n

/-- TomlConfig hasForceOverwrite (W142 more77; Lake long-option `force-overwrite` stem — CLI/Main.lean `--force-overwrite`; exact len-15; ≠ more76 `force-download` len-14; reverse peer `no-overwrite`).
C ABI: `uint32_t lean_fs_tomlcfg_has_force_overwrite(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_force_overwrite]
public unsafe def lean_fs_tomlcfg_has_force_overwrite (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasForceOverwrite addr n

/-- TomlConfig hasRehash (W142 more77; Lake long-option `rehash` stem — CLI/Main.lean `--rehash`; exact len-6; no shipped reverse peer).
C ABI: `uint32_t lean_fs_tomlcfg_has_rehash(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_rehash]
public unsafe def lean_fs_tomlcfg_has_rehash (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRehash addr n

/-- TomlConfig hasKeepImplied (W143 more78; Lake long-option `keep-implied` stem — CLI/Main.lean `--keep-implied`; exact len-12; reverse peers `keep-prefix`/`keep-public`).
C ABI: `uint32_t lean_fs_tomlcfg_has_keep_implied(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_keep_implied]
public unsafe def lean_fs_tomlcfg_has_keep_implied (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasKeepImplied addr n

/-- TomlConfig hasKeepPrefix (W143 more78; Lake long-option `keep-prefix` stem — CLI/Main.lean `--keep-prefix`; exact len-11; reverse peers `keep-implied`/`keep-public`).
C ABI: `uint32_t lean_fs_tomlcfg_has_keep_prefix(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_keep_prefix]
public unsafe def lean_fs_tomlcfg_has_keep_prefix (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasKeepPrefix addr n

/-- TomlConfig hasKeepPublic (W143 more78; Lake long-option `keep-public` stem — CLI/Main.lean `--keep-public`; exact len-11; reverse peers `keep-implied`/`keep-prefix`).
C ABI: `uint32_t lean_fs_tomlcfg_has_keep_public(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_keep_public]
public unsafe def lean_fs_tomlcfg_has_keep_public (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasKeepPublic addr n

/-- TomlConfig hasAddPublic (W144 more79; Lake long-option `add-public` stem — CLI/Main.lean `--add-public`; exact len-10; reverse peers `keep-public`/`gh-style`/`explain`).
C ABI: `uint32_t lean_fs_tomlcfg_has_add_public(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_add_public]
public unsafe def lean_fs_tomlcfg_has_add_public (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasAddPublic addr n

/-- TomlConfig hasGhStyle (W144 more79; Lake long-option `gh-style` stem — CLI/Main.lean `--gh-style`; exact len-8; reverse peers `add-public`/`explain`/`keep-public`).
C ABI: `uint32_t lean_fs_tomlcfg_has_gh_style(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_gh_style]
public unsafe def lean_fs_tomlcfg_has_gh_style (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasGhStyle addr n

/-- TomlConfig hasExplain (W144 more79; Lake long-option `explain` stem — CLI/Main.lean `--explain`; exact len-7; reverse peers `add-public`/`gh-style`).
C ABI: `uint32_t lean_fs_tomlcfg_has_explain(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_explain]
public unsafe def lean_fs_tomlcfg_has_explain (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasExplain addr n

/-- TomlConfig hasBuiltinOnly (W145 more80; Lake long-option `builtin-only` stem — CLI/Main.lean `--builtin-only`; exact len-12; reverse peers `builtinLint`/`lint-only`/`record-exceptions`/`lint`).
C ABI: `uint32_t lean_fs_tomlcfg_has_builtin_only(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_builtin_only]
public unsafe def lean_fs_tomlcfg_has_builtin_only (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBuiltinOnly addr n

/-- TomlConfig hasLintOnly (W145 more80; Lake long-option `lint-only` stem — CLI/Main.lean `--lint-only`; exact len-9; reverse peers `lint`/`builtin-only`/`record-exceptions`).
C ABI: `uint32_t lean_fs_tomlcfg_has_lint_only(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_lint_only]
public unsafe def lean_fs_tomlcfg_has_lint_only (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLintOnly addr n

/-- TomlConfig hasRecordExceptions (W145 more80; Lake long-option `record-exceptions` stem — CLI/Main.lean `--record-exceptions`; exact len-17; reverse peers `builtin-only`/`lint-only`).
C ABI: `uint32_t lean_fs_tomlcfg_has_record_exceptions(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_record_exceptions]
public unsafe def lean_fs_tomlcfg_has_record_exceptions (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasRecordExceptions addr n

/-- TomlConfig hasKeepToolchain (W146 more81; Lake long-option `keep-toolchain` stem — CLI/Main.lean `--keep-toolchain`; exact len-14; reverse peers `fixedToolchain`/`toolchain`/`allow-empty`/`max-revs`).
C ABI: `uint32_t lean_fs_tomlcfg_has_keep_toolchain(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_keep_toolchain]
public unsafe def lean_fs_tomlcfg_has_keep_toolchain (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasKeepToolchain addr n

/-- TomlConfig hasAllowEmpty (W146 more81; Lake long-option `allow-empty` stem — CLI/Main.lean `--allow-empty`; exact len-11; reverse peers `keep-toolchain`/`max-revs`/`update`).
C ABI: `uint32_t lean_fs_tomlcfg_has_allow_empty(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_allow_empty]
public unsafe def lean_fs_tomlcfg_has_allow_empty (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasAllowEmpty addr n

/-- TomlConfig hasMaxRevs (W146 more81; Lake long-option `max-revs` stem — CLI/Main.lean `--max-revs`; exact len-8; reverse peers `rev`/`keep-toolchain`/`allow-empty`).
C ABI: `uint32_t lean_fs_tomlcfg_has_max_revs(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_max_revs]
public unsafe def lean_fs_tomlcfg_has_max_revs (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasMaxRevs addr n

/-- TomlConfig hasLogLevel (W147 more82; Lake long-option `log-level` stem — CLI/Main.lean `--log-level`; exact len-9; reverse peers `fail-level`/`no-ansi`/`info`).
C ABI: `uint32_t lean_fs_tomlcfg_has_log_level(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_log_level]
public unsafe def lean_fs_tomlcfg_has_log_level (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLogLevel addr n

/-- TomlConfig hasFailLevel (W147 more82; Lake long-option `fail-level` stem — CLI/Main.lean `--fail-level`; exact len-10; reverse peers `log-level`/`no-ansi`).
C ABI: `uint32_t lean_fs_tomlcfg_has_fail_level(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_fail_level]
public unsafe def lean_fs_tomlcfg_has_fail_level (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFailLevel addr n

/-- TomlConfig hasNoAnsi (W147 more82; Lake long-option `no-ansi` stem — CLI/Main.lean `--no-ansi`; exact len-7; reverse peers free `ansi`/`log-level`/`fail-level`).
C ABI: `uint32_t lean_fs_tomlcfg_has_no_ansi(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_no_ansi]
public unsafe def lean_fs_tomlcfg_has_no_ansi (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasNoAnsi addr n

/-- TomlConfig hasReconfigure (W148 more83; Lake long-option `reconfigure` stem — CLI/Main.lean `--reconfigure` / short `-R`; exact len-11; reverse peers `quiet`/`verbose`/`update`).
C ABI: `uint32_t lean_fs_tomlcfg_has_reconfigure(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_reconfigure]
public unsafe def lean_fs_tomlcfg_has_reconfigure (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasReconfigure addr n

/-- TomlConfig hasQuiet (W148 more83; Lake long-option `quiet` stem — CLI/Main.lean `--quiet`; exact len-5; reverse peers `verbose`/`reconfigure`).
C ABI: `uint32_t lean_fs_tomlcfg_has_quiet(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_quiet]
public unsafe def lean_fs_tomlcfg_has_quiet (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasQuiet addr n

/-- TomlConfig hasVerbose (W148 more83; Lake long-option `verbose` stem — CLI/Main.lean `--verbose`; exact len-7; reverse peers `quiet`/`reconfigure`).
C ABI: `uint32_t lean_fs_tomlcfg_has_verbose(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_verbose]
public unsafe def lean_fs_tomlcfg_has_verbose (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasVerbose addr n

/-- TomlConfig hasOffline (W149 more84; Lake long-option `offline` stem — CLI/Main.lean `--offline`; exact len-7; reverse peers `platform`/`toolchain`).
C ABI: `uint32_t lean_fs_tomlcfg_has_offline(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_offline]
public unsafe def lean_fs_tomlcfg_has_offline (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasOffline addr n

/-- TomlConfig hasPlatform (W149 more84; Lake long-option `platform` stem — CLI/Main.lean `--platform`; exact len-8; reverse peers `offline`/`toolchain`; ≠ more4 `hasPlatformIndependent`).
C ABI: `uint32_t lean_fs_tomlcfg_has_platform(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_platform]
public unsafe def lean_fs_tomlcfg_has_platform (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasPlatform addr n

/-- TomlConfig hasToolchain (W149 more84; Lake long-option `toolchain` stem — CLI/Main.lean `--toolchain`; exact len-9; reverse peers `offline`/`platform`; ≠ more81 `hasKeepToolchain` / more19 `hasFixedToolchain`).
C ABI: `uint32_t lean_fs_tomlcfg_has_toolchain(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_toolchain]
public unsafe def lean_fs_tomlcfg_has_toolchain (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasToolchain addr n

/-- TomlConfig hasWfail (W150 more85; Lake long-option `wfail` stem — CLI/Main.lean `--wfail`; exact len-5; reverse peers `iofail`/`ansi`/more82 `hasFailLevel`).
C ABI: `uint32_t lean_fs_tomlcfg_has_wfail(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_wfail]
public unsafe def lean_fs_tomlcfg_has_wfail (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasWfail addr n

/-- TomlConfig hasIofail (W150 more85; Lake long-option `iofail` stem — CLI/Main.lean `--iofail`; exact len-6; reverse peers `wfail`/`ansi`/more82 `hasFailLevel`).
C ABI: `uint32_t lean_fs_tomlcfg_has_iofail(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_iofail]
public unsafe def lean_fs_tomlcfg_has_iofail (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasIofail addr n

/-- TomlConfig hasAnsi (W150 more85; Lake long-option `ansi` stem — CLI/Main.lean `--ansi`; exact len-4; reverse peers more82 `hasNoAnsi`; ≠ `no-ansi` len-7).
C ABI: `uint32_t lean_fs_tomlcfg_has_ansi(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_ansi]
public unsafe def lean_fs_tomlcfg_has_ansi (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasAnsi addr n

/-- TomlConfig hasForce (W151 more86; Lake long-option `force` stem — CLI/Main.lean `--force`; exact len-5; reverse peers more76 `hasForceDownload` / more77 `hasForceOverwrite`; ≠ force-download/force-overwrite).
C ABI: `uint32_t lean_fs_tomlcfg_has_force(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_force]
public unsafe def lean_fs_tomlcfg_has_force (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasForce addr n

/-- TomlConfig hasFix (W151 more86; Lake long-option `fix` stem — CLI/Main.lean `--fix`; exact len-3; reverse peers `force`/`only`).
C ABI: `uint32_t lean_fs_tomlcfg_has_fix(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_fix]
public unsafe def lean_fs_tomlcfg_has_fix (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasFix addr n

/-- TomlConfig hasOnly (W151 more86; Lake long-option `only` stem — CLI/Main.lean `--only`; exact len-4; reverse peers more76 `hasMappingsOnly` / more80 `hasBuiltinOnly` / `hasLintOnly`; ≠ mappings-only/builtin-only/lint-only).
C ABI: `uint32_t lean_fs_tomlcfg_has_only(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_only]
public unsafe def lean_fs_tomlcfg_has_only (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasOnly addr n

/-- TomlConfig hasTrace (W152 more87; Lake long-option `trace` stem — CLI/Main.lean `--trace`; exact len-5; reverse peers more56 `hasTraceArgs`; ≠ `traceArgs` len-9).
C ABI: `uint32_t lean_fs_tomlcfg_has_trace(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_trace]
public unsafe def lean_fs_tomlcfg_has_trace (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasTrace addr n

/-- TomlConfig hasOld (W152 more87; Lake long-option `old` stem — CLI/Main.lean `--old`; exact len-3; reverse peers `trace`/`json`).
C ABI: `uint32_t lean_fs_tomlcfg_has_old(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_old]
public unsafe def lean_fs_tomlcfg_has_old (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasOld addr n

/-- TomlConfig hasJson (W152 more87; Lake long-option `json` stem — CLI/Main.lean `--json`; exact len-4; reverse peers more36 `hasText`; ≠ only/ansi content peers).
C ABI: `uint32_t lean_fs_tomlcfg_has_json(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_json]
public unsafe def lean_fs_tomlcfg_has_json (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasJson addr n

/-- TomlConfig hasLinters (W153 more88; Lake long-option `linters` stem — CLI/Main.lean `--linters`; exact len-7; reverse peers `linter`/`builtin-lint`/`lint`/`lint-only`).
C ABI: `uint32_t lean_fs_tomlcfg_has_linters(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_linters]
public unsafe def lean_fs_tomlcfg_has_linters (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLinters addr n

/-- TomlConfig hasBuiltinLintCli (W153 more88; Lake long-option `builtin-lint` stem — CLI/Main.lean `--builtin-lint`; exact len-12; `*Cli` vs more20 camel `hasBuiltinLint`/`builtinLint` len-11; ≠ more80 `builtin-only` len-12 content peer).
C ABI: `uint32_t lean_fs_tomlcfg_has_builtin_lint_cli(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_builtin_lint_cli]
public unsafe def lean_fs_tomlcfg_has_builtin_lint_cli (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasBuiltinLintCli addr n

/-- TomlConfig hasLinter (W153 more88; Lake greppable identity `linter` — CLI/Main.lean parseLintersSpec `"linter" ++ s`; exact len-6; reverse peers `linters` len-7 / `lint` len-4 / `builtin-lint`).
C ABI: `uint32_t lean_fs_tomlcfg_has_linter(size_t addr, size_t n);` -/
@[export_c lean_fs_tomlcfg_has_linter]
public unsafe def lean_fs_tomlcfg_has_linter (addr : USize) (n : USize) : U32 :=
  Systems.TomlConfig.hasLinter addr n
