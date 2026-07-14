import Lake
open System Lake DSL

/-!
# Systems Lean example package

`Extract` is the `@[export_c]` surface. The Systems Lean prelude lives in the lean4
tree (`src/Systems/`) and is built here via `srcDir` (no local Scalars/Sys copy).

Packaging (happy path for C consumers):
* `freestanding := true` forces freestanding compile.
* Default facet `freestanding.bundle` → **one** combined static archive.
* `lake query Extract:freestanding` still lists the ordered multi-archive set (tooling).
-/

package systems

/-- Relative path from this package dir (`…/systems/lib`) to lean4 `src/`. -/
def lean4Src : System.FilePath :=
  "../../../../.." / "src"

/-- In-tree Systems Lean prelude. -/
lean_lib Systems where
  srcDir := lean4Src
  roots := #[
    `Systems.Scalars,
    `Systems.Sys,
    `Systems.Bytes,
    `Systems.Numerics,
    `Systems.Status,
    `Systems.Mem,
    `Systems.BitOps,
    `Systems.Hash,
    `Systems.ByteSpan,
    `Systems.Map,
    `Systems.BitVec,
    `Systems.Set,
    `Systems.Queue,
    `Systems.Vector,
    `Systems.Sort,
    `Systems.Crc,
    `Systems.String,
    `Systems.BinarySearch,
    `Systems.Deque,
    `Systems.Stack,
    `Systems.Ascii,
    `Systems.MemRegion,
    `Systems.BitSet,
    `Systems.Parse,
    `Systems.RingBuf,
    `Systems.Fmt,
    `Systems.List,
    `Systems.Path,
    `Systems.Hex,
    `Systems.Utf8,
    `Systems.Tree,
    `Systems.Json,
    `Systems.Base64,
    `Systems.Graph,
    `Systems.Regex,
    `Systems.Url,
    `Systems.ArenaPool,
    `Systems.Ini,
    `Systems.Csv,
    `Systems.Bloom,
    `Systems.Toml,
    `Systems.Xml,
    `Systems.SkipList,
    `Systems.Yaml,
    `Systems.Http,
    `Systems.BTree,
    `Systems.Dns,
    `Systems.Sexp,
    `Systems.Avl,
    `Systems.Md,
    `Systems.Icmp,
    `Systems.RbTree,
    `Systems.Pem,
    `Systems.Ntp,
    `Systems.Trie,
    `Systems.Jwt,
    `Systems.Dhcp,
    `Systems.BinaryHeap,
    `Systems.Uuid,
    `Systems.Arp,
    `Systems.IntervalTree,
    `Systems.Semver,
    `Systems.Gre,
    `Systems.Splay,
    `Systems.Cbor,
    `Systems.Ip,
    `Systems.BTreeMap,
    `Systems.TomlQuery,
    `Systems.Udp,
    `Systems.SkipListMap,
    `Systems.Edn,
    `Systems.Tcp,
    `Systems.HashMap,
    `Systems.MsgPack,
    `Systems.Icmpv6,
    `Systems.LinkedHashMap,
    `Systems.Protobuf,
    `Systems.Sctp,
    `Systems.OrderedMap,
    `Systems.Avro,
    `Systems.Dccp,
    `Systems.TreeMap,
    `Systems.Capnp,
    `Systems.Quic,
    `Systems.FlatBuffers,
    `Systems.Mqtt,
    `Systems.RadixTree,
    `Systems.Asn1,
    `Systems.Coap,
    `Systems.YamlQuery,
    `Systems.WebSocket,
    `Systems.BitMap,
    `Systems.Lz4,
    `Systems.Socks5,
    `Systems.Snappy,
    `Systems.Rtsp,
    `Systems.Zstd,
    `Systems.Sip,
    `Systems.Brotli,
    `Systems.NtpQuery,
    `Systems.Ogg,
    `Systems.Smtp,
    `Systems.BitSetMulti,
    `Systems.Webm,
    `Systems.Pop3,
    `Systems.Roaring,
    `Systems.Matroska,
    `Systems.Imap,
    `Systems.IntervalSet,
    `Systems.Flac,
    `Systems.Nntp,
    `Systems.Ldap,
    `Systems.Vorbis,
    `Systems.Radius,
    `Systems.OrderedU32Set,
    `Systems.Diameter,
    `Systems.SctpCommon,
    `Systems.M3ua,
    `Systems.Sua,
    `Systems.Iua,
    `Systems.V5ua,
    `Systems.H248,
    `Systems.Megaco,
    `Systems.Mgcp,
    `Systems.Sdp,
    `Systems.Rtcp,
    `Systems.Stun,
    `Systems.Turn,
    `Systems.Ice,
    `Systems.Rtp,
    `Systems.Srtp,
    `Systems.Srtcp,
    `Systems.Dtls,
    `Systems.Tls,
    `Systems.Ipsec,
    `Systems.DepGraph,
    `Systems.Trace,
    `Systems.TomlConfig,
    `Systems.Proc,
    `Systems.Manifest,
    `Systems.CacheIndex,
    `Systems.L2tp,
    `Systems.Pptp,
    `Systems.L2f,
    `Systems.Ppp,
    `Systems.Hdlc,
    `Systems.Parallelism.Simd,
    `Systems.Parallelism.ForkJoin,
    `Systems.Parallelism.Channel]
  libName := "Systems"
  freestanding := true
  defaultFacets := #[LeanLib.freestandingFacet]

@[default_target]
lean_lib Extract where
  roots := #[`Extract]
  libName := "fs_extract"
  freestanding := true
  -- Happy path: single combined archive for `cc` consumers.
  defaultFacets := #[LeanLib.freestandingBundleFacet]
  needs := #[`@/Systems]
