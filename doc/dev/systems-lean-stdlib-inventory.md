# Systems Lean full stdlib inventory (R7)

**Status (R7 product path):** **done** for inventory + first-wave freestanding stdlib + build path.
Remaining module ports are an **ongoing expansion** backlog (not “inventory only”). Classic
Init/Std/Lean builds are **unchanged**. This document tracks **Systems Lean / freestanding**
enablement honesty — it does **not** claim every Init file is freestanding.

Canonical product doc: [systems-lean.md](systems-lean.md). Self-host (R6): [systems-lean-selfhost.md](systems-lean-selfhost.md).

## What R7 product acceptance means

| Deliverable | Status |
|-------------|--------|
| Scripted Init/Std/(Lean) inventory with status buckets | **done** — `script/systems-stdlib-inventory.sh` |
| First-wave `Systems.*` beyond Scalars/Sys | **done** — Bytes, Numerics, Status |
| `systems-stdlib` product path (build + nm gate) | **done** — `script/systems-stdlib.sh`, `make check-stdlib` |
| **PRODUCT_STDLIB_MODULES** closed manifest + validate gate | **done** — `script/systems-product-stdlib-modules.txt`, `GATE product_stdlib` |
| Dual-path docs (product FS vs host classic) | **done** (this file + systems-lean.md) |
| Every Init/Std module recompiled under freestanding | **not a goal** of this product path |
| GC-free elaborator / full Lean library under FS | **not claimed** (R6 residual / future) |

### PRODUCT_STDLIB_MODULES (greppable product set)

Authoritative closed list of freestanding modules on the product residual / ccomp matrix:

| Artifact | Role |
|----------|------|
| `script/systems-product-stdlib-modules.txt` | One path per line under `Systems/` (e.g. `Parallelism/Simd`) |
| `script/systems-product-stdlib-check.sh` | Sources + lakefile roots + residual-policy match + optional IR |
| `script/systems-residual-policy.sh` | Loads the same manifest into `SYSTEMS_LEAN_PRODUCT_FS_MODULES` |
| `./script/systems-validate.sh` | Emits `GATE product_stdlib=PASS` when `PRODUCT_STDLIB_MODULES_OK=1` |

```bash
# Single greppable gate (from lean4 root; systems.nix front door for hermetic tools)
nix develop .#systems   # portable: rg, nm, make, file, python3 (alias: .#systems-dev)
./script/systems-product-stdlib-check.sh
# success line: PRODUCT_STDLIB_MODULES_OK=1
# live size: PRODUCT_STDLIB_MODULES_COUNT=149  (150 TUs with Extract; Phase D1–D21 intentional renames @149 flat — see inventory table row / doc/dev/systems-naming.md; Phase C −38 ordered-leaf *SetLite after B3 −69 magic codecs after B2 −45 V*Lite after B1 −39 HeapLite)

# Refresh generated inventory section (SSoT) + optional drift check
./script/systems-stdlib-inventory.sh --write
./script/systems-stdlib-inventory.sh --require   # fails if doc/PRODUCT ≠ live fs-ready
./script/systems-status.sh                       # fast: FS_READY=149 SYSTEMS_STATUS_OK=1
# or: nix develop .#systems --command systems-status

./script/systems-validate.sh | rg 'product_stdlib|PRODUCT_STDLIB|inventory_fs_ready'
# GATE product_stdlib=PASS
# GATE inventory_fs_ready=149
```

Grow the manifest **only** when a new module passes freestanding build + residual + certs.
Do **not** list classic Init/Std modules until they are ported under `src/Systems/`.
Track F: keep inventory honest with `--write` after every new `Systems.*` module; CI opt-in
workflow is `.github/workflows/systems-lean.yml` (not classic `ci.yml`).

## Layers

| Layer | Path | FS status |
|-------|------|-----------|
| Prelude + FS product surface | `src/Systems/` | **fs-ready** (**149** modules / **150** TUs with Extract; Phase B1 −39 thesaurus `*HeapLite`; Phase B2 −45 `V[0-9]+Lite` header toys; Phase B3 −69 magic codec toys; Phase C −38 ordered-leaf `*SetLite`; Phase D1–D21 intentional renames @149 flat — D1 `BinaryHeap`/`OrderedU32Set`; D2 `TomlConfig`/`BitSet`; D3 `Manifest`/`IntervalSet`/`Set`; D4 `DepGraph`/`Trace`/`Map`/`Queue`; D5 `CacheIndex`/`Vector`/`Deque`/`Stack`/`HashMap`; D6 `LinkedHashMap`/`OrderedMap`/`TreeMap`/`BitMap`/`List`/`String`; D7 `BTreeMap`/`SkipListMap`/`Sort`/`Tree`/`Graph`/`Json`; D8 `Path`/`SkipList`/`BTree`/`RbTree`/`Avl`/`Splay`; D9 `Trie`/`IntervalTree`/`RadixTree`/`Bloom`/`Fmt`/`Hex`/`Utf8`; D10 `Base64`/`Regex`/`Url`/`Ascii`/`Parse`/`Crc`/`BitVec`/`BitSetMulti`/`Roaring`; D11 `Toml`/`Xml`/`Yaml`/`Ini`/`Csv`/`Http`/`Dns`/`Sexp`; D12 `Md`/`Pem`/`Jwt`/`Semver`/`Edn`/`Uuid`; D13 `Cbor`/`MsgPack`/`Protobuf`/`Avro`/`Capnp`/`FlatBuffers`/`Asn1`; D14 `Ip`/`Udp`/`Tcp`/`Icmp`/`Icmpv6`/`Arp`/`Gre`/`Dhcp`/`Ntp`; D15 `Sctp`/`Dccp`/`Quic`/`Mqtt`/`Coap`/`WebSocket`/`Socks5`/`Sip`/`Tls`/`Dtls`; D16 `Rtp`/`Rtcp`/`Srtp`/`Srtcp`/`Stun`/`Turn`/`Ice`/`L2tp`/`Pptp`/`L2f`/`Ppp`/`Hdlc`; D17 `Rtsp`/`Ogg`/`Flac`/`Vorbis`/`Webm`/`Matroska`; D18 `Smtp`/`Pop3`/`Imap`/`Nntp`/`Ldap`; D19 `Lz4`/`Snappy`/`Zstd`/`Brotli`; D20 `M3ua`/`Sua`/`Iua`/`V5ua`/`H248`/`Megaco`/`Mgcp`/`Sdp`/`Diameter`/`Radius`; D21 `TomlQuery`/`YamlQuery`/`NtpQuery`/`SctpCommon`/`Ipsec`. Survivors include those plain renames; product `*Lite` leaves remain **0** (D21 residual completion; UA/sigtran already plain D20; compression already plain D19; mail already plain D18) and Parallelism.*; authoritative live list = `script/systems-product-stdlib-modules.txt`; rename ledger = `doc/dev/systems-naming.md`) |
| Init | `src/Init/` | Classic default; inventory classifies roots as dual-host / host-only / fs-planned |
| Std | `src/Std/` | Classic default; collections mostly **fs-planned**, tactics/async **host-only** |
| Lean library | `src/Lean/` | Classic default; optional inventory with `--lean` |

## Dual path (product vs host)

| Path | What you import | How you build | Runtime on the wire |
|------|-----------------|---------------|---------------------|
| **Product extract** | `Systems.*` only | Lake `freestanding := true` / `compiler.freestanding=true` | No GC / no `lean_object` / no `Init_shared` |
| **Host proofs/tools** | Classic `Init` / `Std` / `Lean` | Default stage1 | Full RC runtime + `libleanshared` |

Rules:

1. Systems product modules (compiled freestanding) may **only import freestanding modules** (import gate).
2. Classic `src/Init`, `src/Std`, and default stage1 compilation stay as they are.
3. Host specs (e.g. freestanding `host/`) typecheck with Init; they are **not** linked into the product `.a`.

### How modules move buckets

```
host-only  ──(product need identified)──►  fs-planned
fs-planned ──(port under src/Systems/)──►  fs-ready
dual-host  ──(optional; only if product hot path)──►  fs-planned → fs-ready
```

| Status | Meaning |
|--------|---------|
| `fs-ready` | Exists as freestanding module under `src/Systems/` (product path) |
| `fs-planned` | **Heuristic** product-critical name prefixes; port candidates (not a proof) |
| `dual-host` | **Heuristic** host proofs/tools; not flagged as embed hot path |
| `host-only` | **Heuristic** tactics / meta / IO / async-style prefixes — stay classic |

Classification is done by `script/systems-stdlib-inventory.sh` via **module-name prefixes**
only (no import-graph / content analysis). e.g. `Init.Data.List` / `Array` / `String` often
land in `dual-host` while a fixed UInt/BitVec/ByteArray/HashMap/Sat slice is `fs-planned` —
that can understate RC-shaped product needs. Treat non-`fs-ready` buckets as planning
labels; promote modules deliberately when product-critical.

## First-wave freestanding surface (`fs-ready`)

| Module | Role |
|--------|------|
| `Systems.Scalars` | Unboxed `U8`…`U64`/`USize`/`Bool`, `bif*`, checksum / memEq loops |
| `Systems.Sys` | Affine `Fd` / Arena / Log / MMap + thin POSIX libc |
| `Systems.Bytes` | Byte memory: copy / fill / find / XOR-fold (no managed arrays) |
| `Systems.Numerics` | Fixed-width bitwise, shifts, min/max, saturating add/sub, clamp, rotate L/R |
| `Systems.Status` | Result/Option-style **dual-value patterns** without Init products |
| `Systems.Mem` | `memCmp` / `memMove` / `memZero` |
| `Systems.BitOps` | Bit test/set/clear, popcount, bswap |
| `Systems.Hash` | FNV-1a hash-lite (non-crypto) |
| `Systems.ByteSpan` | ByteArray-shaped dual `addr`/`len` (`eq`, bounds get/set, `hash32`, subspan) — not managed `ByteArray` |
| `Systems.Map` | HashMap-shaped fixed-cap open-addressing + tombstone erase + dual-buffer rehash — not `Std.HashMap` |
| `Systems.BitVec` | BitVec-shaped ops over freestanding `U64` (truncate/extract/concat/test/set/rotate/signExtend/popcount) — not full `BitVec` |
| `Systems.Set` | HashSet-shaped fixed-cap open-addressing set + tombstone erase + dual-buffer rehash — not `Std.HashSet` |
| `Systems.Queue` | Queue-shaped fixed-cap ring over raw U32 slots + caller head/count — not managed queue |
| `Systems.Vector` | Array-shaped fixed-cap vector over raw U32 slots + caller length — not managed `Array` |
| `Systems.Sort` | In-place U32 insertion sort (not full sort library) |
| `Systems.Crc` | CRC-32-shaped byte-range fold (IEEE reflected; not crypto) |
| `Systems.String` | String-shaped byte view over dual `addr`/`len` — not managed `String` / UTF-8 |
| `Systems.BinarySearch` | Binary search over sorted U32 prefix — not full search library |
| `Systems.Deque` | Deque-shaped fixed-cap double-ended ring over raw U32 slots — not managed deque |
| `Systems.Stack` | Stack-shaped fixed-cap over raw U32 slots + caller length — not managed stack |
| `Systems.Ascii` | ASCII ctype-shaped classifiers/case maps over U8/U32 — not locale / Unicode |
| `Systems.MemRegion` | Dual base/len region view (contains/subregion/load/store/overlap) — not OS mmap |
| `Systems.Parallelism.Simd` | L1 map/fold + chunked-4 sequential (SIMD-shaped; not hardware SIMD) |
| `Systems.Parallelism.ForkJoin` | L2 partition API (sequential product default; opt-in pthread dogfood only) |
| `Systems.Parallelism.Channel` | L3 linear one-cell send/recv + try/dual-payload smokes (sequential) |

Packaging roots: `tests/lake/examples/systems/lib/lakefile.lean` and optional
`src/lakefile.toml` Systems product lib (`freestanding := true` compile mode; not a default stage1 target).

## Build targets

| Target | Meaning |
|--------|---------|
| `stage1` | Classic (default, with runtime) — **unchanged** |
| `./script/systems-stdlib.sh` | Build freestanding stdlib via freestanding + nm gate + inventory refresh |
| `make -C tests/lake/examples/systems check-stdlib` | SKIP_BUILD + nm + residual IR greps; **no** inventory rewrite (`INVENTORY=0`) + negatives |
| `./script/systems-product-stdlib-check.sh` | PRODUCT_STDLIB_MODULES_OK (manifest ↔ sources ↔ lake ↔ residual-policy) |
| `./script/systems-validate.sh` | Scoreboard including `GATE product_stdlib` |
| `./script/systems-stdlib-inventory.sh` | Emit / `--write` inventory section; `--require` doc+PRODUCT drift |
| `./script/systems-status.sh` | Fast greppable FS/PRODUCT/honesty tokens (not full validate) |
| `lean-systems` | R6 product driver (see self-host doc) |

```bash
export PATH="$PWD/build/release/stage1/bin:$PATH"
./script/systems-stdlib.sh
./script/systems-stdlib-inventory.sh --write
./script/systems-selfhost-link-check.sh
```

## Ongoing expansion (not done in one PR)

- **P2 shaped ports on PRODUCT_STDLIB:** `ByteSpan`, `Map`, `BitVec` (U64 BitVec-shaped),
  `Set` (HashSet-shaped), `Queue` (ring queue), `Vector` (fixed-cap vector),
  `Sort` (insertion sort), `Crc` (CRC-32), `String` (byte view), `BinarySearch`
  (sorted U32 find), `Deque` (double-ended ring), `Stack` (fixed-cap stack),
  `Ascii` (ASCII ctype), and `MemRegion` (dual base/len region view). These are **not** managed
  `ByteArray` / `Std.HashMap` / `BitVec` / `HashSet` / `Array` / `String` drop-ins — fuller APIs remain backlog.
- **P5 next-port backlog (greppable):** curated
  `PRODUCT_FS_NEXT=H5_host,TomlConfig_more89,Slake_parity_more`
  from `./script/systems-tcb-inventory.sh` (hand-maintained planning string — **not** a live
  `fs-planned` dump; **not** required by `GATE tcb_honesty`). Prefer residual-green honesty
  gates over risky PRODUCT_STDLIB growth; see [systems-lean-selfhost.md](systems-lean-selfhost.md).
- Port remaining **fs-planned** roots (broader UInt/BitVec APIs, richer maps/sets, …) into
  freestanding modules **without** smuggling `List`/`String`/`Array` RC types on the product path.
- After each new fs-ready port: append to `script/systems-product-stdlib-modules.txt`,
  wire lakefile roots, then re-run `./script/systems-product-stdlib-check.sh` and validate.
- Self-host TCB growth remains separate from this stdlib product path (R6 residual).
- Re-run `./script/systems-stdlib-inventory.sh --write` after adding `Systems.*` modules.

## Module counts (snapshot; prefer generated section)

Hand snapshot only — prefer the generated inventory below for authoritative bucket counts:

- Init `.lean` files: ~630
- Std `.lean` files: ~482
- Lean `.lean` files: ~1210 (optional `--lean`)
- Systems product surface: first-wave modules under `src/Systems/` (compile mode: freestanding)


<!-- GENERATED-BY script/systems-stdlib-inventory.sh — do not hand-edit this section -->
## Generated inventory (scripted)

Generated: `2026-07-19T05:12Z`
Command: `./script/systems-stdlib-inventory.sh`
Include Lean library: `0`

**Heuristic honesty:** buckets below are **name-prefix planning labels** (not import-graph
analysis and not machine-checked freestanding proofs). e.g. `Init.Data.List` may be
`dual-host` while UInt/BitVec/HashMap roots are `fs-planned`; renames can change buckets.
Only `fs-ready` lists real `src/Systems/*.lean` modules.

### Counts

| Bucket | Meaning | Count |
|--------|---------|------:|
| `fs-ready` | Exists as freestanding module under `src/Systems/` | 149 |
| `fs-planned` | Heuristic: product-critical name prefixes (port candidates) | 239 |
| `dual-host` | Heuristic: host proofs/tools; not flagged as product hot path | 507 |
| `host-only` | Heuristic: tactics / meta / IO / async-style prefixes | 366 |
| **Total scanned** | | **1261** |

### Tree sizes

| Layer | `.lean` files |
|-------|---------------:|
| Systems | 149 |
| Init | 630 |
| Std | 482 |
| Lean (optional) | 0 |

### `fs-ready` modules (Systems product surface)

- `Systems.ArenaPool`
- `Systems.Arp`
- `Systems.Ascii`
- `Systems.Asn1`
- `Systems.Avl`
- `Systems.Avro`
- `Systems.Base64`
- `Systems.BinaryHeap`
- `Systems.BinarySearch`
- `Systems.BitMap`
- `Systems.BitOps`
- `Systems.BitSet`
- `Systems.BitSetMulti`
- `Systems.BitVec`
- `Systems.Bloom`
- `Systems.Brotli`
- `Systems.BTree`
- `Systems.BTreeMap`
- `Systems.Bytes`
- `Systems.ByteSpan`
- `Systems.CacheIndex`
- `Systems.Capnp`
- `Systems.Cbor`
- `Systems.Coap`
- `Systems.Crc`
- `Systems.Csv`
- `Systems.Dccp`
- `Systems.DepGraph`
- `Systems.Deque`
- `Systems.Dhcp`
- `Systems.Diameter`
- `Systems.Dns`
- `Systems.Dtls`
- `Systems.Edn`
- `Systems.Flac`
- `Systems.FlatBuffers`
- `Systems.Fmt`
- `Systems.Graph`
- `Systems.Gre`
- `Systems.H248`
- `Systems.Hash`
- `Systems.HashMap`
- `Systems.Hdlc`
- `Systems.Hex`
- `Systems.Http`
- `Systems.Ice`
- `Systems.Icmp`
- `Systems.Icmpv6`
- `Systems.Imap`
- `Systems.Ini`
- `Systems.IntervalSet`
- `Systems.IntervalTree`
- `Systems.Ip`
- `Systems.Ipsec`
- `Systems.Iua`
- `Systems.Json`
- `Systems.Jwt`
- `Systems.L2f`
- `Systems.L2tp`
- `Systems.Ldap`
- `Systems.LinkedHashMap`
- `Systems.List`
- `Systems.Lz4`
- `Systems.M3ua`
- `Systems.Manifest`
- `Systems.Map`
- `Systems.Matroska`
- `Systems.Md`
- `Systems.Megaco`
- `Systems.Mem`
- `Systems.MemRegion`
- `Systems.Mgcp`
- `Systems.Mqtt`
- `Systems.MsgPack`
- `Systems.Nntp`
- `Systems.Ntp`
- `Systems.NtpQuery`
- `Systems.Numerics`
- `Systems.Ogg`
- `Systems.OrderedMap`
- `Systems.OrderedU32Set`
- `Systems.Parallelism.Channel`
- `Systems.Parallelism.ForkJoin`
- `Systems.Parallelism.Simd`
- `Systems.Parse`
- `Systems.Path`
- `Systems.Pem`
- `Systems.Pop3`
- `Systems.Ppp`
- `Systems.Pptp`
- `Systems.Proc`
- `Systems.Protobuf`
- `Systems.Queue`
- `Systems.Quic`
- `Systems.Radius`
- `Systems.RadixTree`
- `Systems.RbTree`
- `Systems.Regex`
- `Systems.RingBuf`
- `Systems.Roaring`
- `Systems.Rtcp`
- `Systems.Rtp`
- `Systems.Rtsp`
- `Systems.Scalars`
- `Systems.SctpCommon`
- `Systems.Sctp`
- `Systems.Sdp`
- `Systems.Semver`
- `Systems.Set`
- `Systems.Sexp`
- `Systems.Sip`
- `Systems.SkipList`
- `Systems.SkipListMap`
- `Systems.Smtp`
- `Systems.Snappy`
- `Systems.Socks5`
- `Systems.Sort`
- `Systems.Splay`
- `Systems.Srtcp`
- `Systems.Srtp`
- `Systems.Stack`
- `Systems.Status`
- `Systems.String`
- `Systems.Stun`
- `Systems.Sua`
- `Systems.Sys`
- `Systems.Tcp`
- `Systems.Tls`
- `Systems.TomlConfig`
- `Systems.Toml`
- `Systems.TomlQuery`
- `Systems.Trace`
- `Systems.Tree`
- `Systems.TreeMap`
- `Systems.Trie`
- `Systems.Turn`
- `Systems.Udp`
- `Systems.Url`
- `Systems.Utf8`
- `Systems.Uuid`
- `Systems.V5ua`
- `Systems.Vector`
- `Systems.Vorbis`
- `Systems.Webm`
- `Systems.WebSocket`
- `Systems.Xml`
- `Systems.Yaml`
- `Systems.YamlQuery`
- `Systems.Zstd`

### Category roots by status

Categories are `Layer.Top` (or full `Systems.*` module names). Full per-file status
is reproducible by re-running this script; the lists below are the **roots** used for
planning (not a hand-waved count-only inventory).

#### fs-planned roots (product port backlog)

- `Init.Data`
- `Std.Data`
- `Std.Sat`

#### host-only roots (stay classic)

- `Init.ByCases`
- `Init.CbvSimproc`
- `Init.Classical`
- `Init.Conv`
- `Init.Ext`
- `Init.Grind`
- `Init.GrindInstances`
- `Init.Guard`
- `Init.Hints`
- `Init.LawfulBEqTactics`
- `Init.MacroTrace`
- `Init.Meta`
- `Init.MetaTypes`
- `Init.MethodSpecsSimp`
- `Init.Notation`
- `Init.NotationExtra`
- `Init.Omega`
- `Init.PropLemmas`
- `Init.RCases`
- `Init.ShareCommon`
- `Init.SimpLemmas`
- `Init.Simproc`
- `Init.Sym`
- `Init.System`
- `Init.Tactics`
- `Init.TacticsExtra`
- `Init.Task`
- `Std.Async`
- `Std.Do`
- `Std.Http`
- `Std.Internal`
- `Std.Net`
- `Std.Sync`
- `Std.Tactic`
- `Std.Time`

#### dual-host roots (host proofs/tools; not embed hot path)

- `Init.BinderNameHint`
- `Init.BinderPredicates`
- `Init.Coe`
- `Init.Control`
- `Init.Core`
- `Init.Data`
- `Init.Dynamic`
- `Init.GetElem`
- `Init.Internal`
- `Init.Prelude`
- `Init.SizeOf`
- `Init.SizeOfLemmas`
- `Init.Syntax`
- `Init.Try`
- `Init.Util`
- `Init.WF`
- `Init.WFComputable`
- `Init.WFExtrinsicFix`
- `Init.WFTactics`
- `Init.While`
- `Std.Data`

### Dual-path rules (product vs host)

| Path | Modules | Runtime |
|------|---------|---------|
| **Product extract** | `Systems.*` only (`compiler.freestanding=true`) | No GC / no `lean_object` on the link line |
| **Host proofs/tools** | Classic `Init` / `Std` / `Lean` | Full stage1 + `libleanshared` |

Promotion: `host-only` or `dual-host` → `fs-planned` (product need) → implement under
`src/Systems/` → `fs-ready`. Classic `src/Init` / `src/Std` remain **unchanged**
and classic-default.

<!-- END GENERATED inventory -->
