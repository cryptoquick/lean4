# Systems Lean prelude

In-tree **Systems Lean** library: freestanding scalars, thin systems IO, and first-wave
stdlib helpers (R7).

Canonical guide: [`doc/dev/systems-lean.md`](../../doc/dev/systems-lean.md)  
Inventory / dual-path: [`doc/dev/systems-lean-stdlib-inventory.md`](../../doc/dev/systems-lean-stdlib-inventory.md)

## Modules

| Module | Public surface (summary) |
|--------|---------------------------|
| **`Systems.Scalars`** | `U8`/`U16`/`U32`/`U64`/`USize`/`Bool`, arithmetic/bitwise ops, `U8.load`, loop helpers (`bif*`, `checksumGo`, `memEqGo`, …) |
| **`Systems.Sys`** | Identity `Sys`; affine `Fd`, `Arena`, `BytePtr`, `MallocBuf`, `Log`, `MMap`; open/read/write/close, arenas, append log, mmap |
| **`Systems.Bytes`** | Byte memory: `memCopy` / `memFill` / `memFindU8` / `memXorFold` (dual addr/len params; no managed arrays) |
| **`Systems.Numerics`** | Fixed-width extras: U16 ops, U32/U64 bitwise+shifts/`lnot`, min/max, `U32`/`U64` `satAdd`/`satSub`/`rotateLeft`/`rotateRight`/`clamp`, `USize.satAdd`/`clamp` |
| **`Systems.Status`** | Result/Option-style dual-value patterns without Init products (`isOk`, `andThen`, sentinel optionals) |
| **`Systems.Mem`** | `memCmp` / `memMove` / `memZero` (overlap-safe move; dual addr/len) |
| **`Systems.BitOps`** | Bit test/set/clear, `lowMask`, `popcount`, `bswap` |
| **`Systems.Hash`** | FNV-1a + finalizer hash-lite (non-crypto) |
| **`Systems.ByteSpan`** | ByteArray-**shaped** dual `addr`/`len`: bounds `getU8`/`setU8`, `eq`, `prefixEq`, `hash32`, subspan views (not managed `ByteArray`) |
| **`Systems.Map`** | HashMap-**shaped** fixed-cap open-addressing over raw U32 keys/vals + tags; tombstone erase + dual-buffer rehash (not `Std.HashMap`) |
| **`Systems.BitVec`** | BitVec-**shaped** ops over freestanding `U64` (truncate/extract/concat/test/set/clear/rotate/signExtend/popcount; not full `BitVec`) |
| **`Systems.Set`** | HashSet-**shaped** fixed-cap open-addressing over raw U32 keys + tags; tombstone erase + dual-buffer rehash (not `Std.HashSet`) |
| **`Systems.Queue`** | Queue-**shaped** fixed-cap ring over raw U32 slots + caller head/count (not managed queue / `Array`) |
| **`Systems.Vector`** | Array-**shaped** fixed-cap vector over raw U32 slots + caller length (not managed `Array`) |
| **`Systems.Sort`** | In-place U32 insertion sort over dual slots/`n` (not full sort library) |
| **`Systems.Crc`** | CRC-32-shaped byte-range fold (IEEE reflected; not crypto) |
| **`Systems.String`** | Freestanding byte-string view over dual `addr`/`len` (not Init/`Std` managed `String` / UTF-8; ABI `lean_fs_str_*`) |
| **`Systems.BinarySearch`** | Binary search over sorted U32 prefix (not full search library) |
| **`Systems.Deque`** | Deque-**shaped** fixed-cap double-ended ring over raw U32 slots + caller head/count |
| **`Systems.Stack`** | Stack-**shaped** fixed-cap over raw U32 slots + caller length (not managed stack / `Array`) |
| **`Systems.Ascii`** | ASCII ctype-**shaped** classifiers/case maps over U8/U32 (not locale / Unicode) |
| **`Systems.MemRegion`** | Dual `base`/`len` region view: contains/subregion/load/store/overlap (not OS mmap) |
| **`Systems.BitSet`** | Fixed 64-bit word bitset (set/clear/test/count/and/or/xor; not multi-word / growable / Init collections) |
| **`Systems.Parse`** | Decimal U32/U64 parse over dual `addr`/`len` (not strtol / locale / hex) |
| **`Systems.RingBuf`** | Ring-**shaped** fixed-cap U8 buffer over caller slots + head/count (not managed queue) |
| **`Systems.Fmt`** | Decimal U32/U64 format into caller `addr`/`cap` buffer (not printf / locale / float) |
| **`Systems.List`** | Fixed-cap dense U32 list slots + caller length (not Init/`Std` managed `List` / GC cons) |
| **`Systems.Path`** | Path-**shaped** POSIX-ish helpers over dual `addr`/`len` (not full Path / Windows / UTF-8) |
| **`Systems.Hex`** | ASCII hex encode/decode into caller buffers (not crypto / full hexdump) |
| **`Systems.Utf8`** | UTF-8 scan/validate/count over dual `addr`/`len` (not full Unicode / NFC / graphemes) |
| **`Systems.Tree`** | Fixed-cap U32 binary **min-heap** over caller slots (not TreeMap / RB / managed) |
| **`Systems.Json`** | JSON scan/validate over dual `addr`/`len` with fixed depth (not full JSON / DOM) |
| **`Systems.Base64`** | Standard base64 encode/decode into caller buffers (not MIME / URL-safe / crypto) |
| **`Systems.Graph`** | Fixed-cap U32 adjacency list + BFS marks (not general graph lib / dynamic alloc) |
| **`Systems.Regex`** | Regex-**shaped** scan (literal / `.` / `*` / escapes; not full PCRE) |
| **`Systems.Url`** | URL-**shaped** scheme/host/path offsets (not full URI RFC) |
| **`Systems.ArenaPool`** | Fixed-cap bump allocator over caller buffer (not general heap / Sys.Arena malloc) |
| **`Systems.Ini`** | INI-**shaped** section/key scan over dual `addr`/`len` (not ConfigParser / malloc maps) |
| **`Systems.Csv`** | CSV-**shaped** row/field scan (not full RFC 4180 / dataframe) |
| **`Systems.Bloom`** | Fixed-cap Bloom filter over caller U64 words (not crypto hash filter) |
| **`Systems.Toml`** | TOML-**shaped** key/table scan over dual `addr`/`len` (not full TOML 1.0) |
| **`Systems.Xml`** | XML-**shaped** tag-balance scan (not full XML/DOM) |
| **`Systems.SkipList`** | Fixed-cap skiplist-**shaped** ordered U32 multiset (not concurrent skiplist) |
| **`Systems.Yaml`** | YAML-**shaped** line/indent scan over dual `addr`/`len` (not full YAML 1.2) |
| **`Systems.Http`** | HTTP-**shaped** first-line + header offsets (not full HTTP stack) |
| **`Systems.BTree`** | Fixed-cap B-tree-**shaped** ordered U32 map (not full B+tree DB) |
| **`Systems.Dns`** | DNS-**shaped** dotted QNAME label scan (not full DNS resolver / EDNS) |
| **`Systems.Sexp`** | S-expression-**shaped** paren/atom scan (not full Lisp reader) |
| **`Systems.Avl`** | Fixed-cap AVL-**shaped** ordered U32 map (not concurrent AVL / TreeMap) |
| **`Systems.Md`** | Markdown-**shaped** line scan (not full CommonMark / HTML) |
| **`Systems.Icmp`** | ICMP-**shaped** header field parse (not full ICMP stack / echo server) |
| **`Systems.RbTree`** | Fixed-cap red-black-**shaped** ordered U32 map (not multi-node RB / concurrent) |
| **`Systems.Pem`** | PEM-**shaped** armor block scan (not full OpenSSL PEM / X.509) |
| **`Systems.Ntp`** | NTP-**shaped** header field parse (not full NTP client/server) |
| **`Systems.Trie`** | Fixed-cap trie-**shaped** ordered U32 map (not concurrent radix / Patricia) |
| **`Systems.Jwt`** | JWT-**shaped** header/payload/sig base64url scan (not JWS crypto verify) |
| **`Systems.Dhcp`** | DHCP/BOOTP-**shaped** header field parse (not full DHCP client/server) |
| **`Systems.BinaryHeap`** | Fixed-cap U32 binary **min-heap** over caller slots (not concurrent heap allocator) |
| **`Systems.Uuid`** | UUID-**shaped** canonical 8-4-4-4-12 hex scan (not generator / full RFC variants) |
| **`Systems.Arp`** | ARP-**shaped** Ethernet/IPv4 header field parse (not full ARP stack) |
| **`Systems.IntervalTree`** | Fixed-cap ordered U32 **intervals** (not concurrent stabbing DB) |
| **`Systems.Semver`** | SemVer-**shaped** `MAJOR.MINOR.PATCH` scan (not full SemVer 2.0 precedence) |
| **`Systems.Gre`** | GRE-**shaped** min-4 header field parse (not full GRE tunnel stack) |
| **`Systems.Splay`** | Fixed-cap splay-**shaped** ordered U32 map (not concurrent amortized splay) |
| **`Systems.Cbor`** | CBOR-**shaped** major-type scan + small uint (not full RFC 8949 codec) |
| **`Systems.Ip`** | IPv4-**shaped** min-20 header field parse (not full IP stack / not IPv6) |
| **`Systems.BTreeMap`** | Fixed-cap B-tree-map-**shaped** ordered U32 map (not multi-node concurrent B+tree) |
| **`Systems.TomlQuery`** | TOML-**shaped** key lookup / query scan (not full TOML 1.0 document model) |
| **`Systems.Udp`** | UDP-**shaped** min-8 header field parse (not full UDP stack / sockets) |
| **`Systems.SkipListMap`** | Fixed-cap skip-list-map-**shaped** ordered U32 map (not multi-level concurrent skip list) |
| **`Systems.Edn`** | EDN-**shaped** balanced bracket/brace/paren + keyword/atom scan (not full Clojure EDN reader) |
| **`Systems.Tcp`** | TCP-**shaped** min-20 header field parse (not full TCP stack / sockets) |
| **`Systems.HashMap`** | Fixed-cap hash-map-**shaped** ordered U32 map (not concurrent hash map / not resize heap) |
| **`Systems.MsgPack`** | MessagePack-**shaped** first-byte family scan + pos fixint (not full MessagePack codec) |
| **`Systems.Icmpv6`** | ICMPv6-**shaped** min-8 header field parse (not full ICMPv6 stack / not ND suite) |
| **`Systems.LinkedHashMap`** | Fixed-cap linked-hash-map-**shaped** ordered U32 map (not concurrent LRU / not resize heap) |
| **`Systems.Protobuf`** | Protobuf-**shaped** wire key / small-varint scan (not full protobuf codec / not schema) |
| **`Systems.Sctp`** | SCTP-**shaped** min-12 common header field parse (not full SCTP stack / not chunks) |
| **`Systems.OrderedMap`** | Fixed-cap ordered U32 map dense leaf (not concurrent ordered map / not heap resize) |
| **`Systems.Avro`** | Avro-**shaped** first-byte bool/zigzag/varint scan (not full Avro schema/codec) |
| **`Systems.Dccp`** | DCCP-**shaped** min-12 generic header field parse (not full DCCP stack / not options) |
| **`Systems.TreeMap`** | Fixed-cap tree-map-**shaped** ordered U32 map dense leaf (not concurrent tree map / not heap nodes) |
| **`Systems.Capnp`** | Cap'n Proto-**shaped** first-word pointer family scan (not full Cap'n Proto codec / not segments) |
| **`Systems.Quic`** | QUIC-**shaped** min-7 long-header field parse (not full QUIC stack / not frames) |
| **`Systems.FlatBuffers`** | FlatBuffers-**shaped** root uoffset / soffset scan (not full FlatBuffers codec / not schema) |
| **`Systems.Mqtt`** | MQTT-**shaped** min-2 fixed-header type/flags/remaining-length parse (not full MQTT stack) |
| **`Systems.RadixTree`** | Fixed-cap radix-tree-**shaped** ordered U32 set dense leaf (not concurrent radix / not multi-node) |
| **`Systems.Asn1`** | ASN.1 DER-**shaped** first-tag TLV short-form scan (not full DER codec / not X.509) |
| **`Systems.Coap`** | CoAP-**shaped** min-4 header field parse (not full CoAP stack / not options) |
| **`Systems.YamlQuery`** | YAML-**shaped** key lookup / `key:` value-offset scan (not full YAML 1.2 document model) |
| **`Systems.WebSocket`** | WebSocket-**shaped** min-2 frame header FIN/opcode/MASK/len7 parse (not full WebSocket stack) |
| **`Systems.BitMap`** | Fixed-cap multi-word U32 bitmap set/clear/test (distinct from single-word `BitSet`; not growable / not concurrent) |
| **`Systems.Lz4`** | LZ4-**shaped** frame magic / flags / LE block-size scan (not full LZ4 codec) |
| **`Systems.Socks5`** | SOCKS5-**shaped** greeting/request min-header parse (not full SOCKS5 proxy) |
| **`Systems.Snappy`** | Snappy-**shaped** stream magic / chunk type / 24-bit LE len scan (not full Snappy codec) |
| **`Systems.Rtsp`** | RTSP-**shaped** request-line method/URI/version parse (not full RTSP stack) |
| **`Systems.Zstd`** | Zstd-**shaped** frame magic / descriptor / window / LE field scan (not full Zstd codec) |
| **`Systems.Sip`** | SIP-**shaped** request-line method/URI/version parse (not full SIP stack) |
| **`Systems.Brotli`** | Brotli-**shaped** stream window-bits / meta-prefix scan (not full Brotli codec) |
| **`Systems.NtpQuery`** | NTP-**query-shaped** min-48 request/response first-byte + key field parse (not full NTP client) |
| **`Systems.Ogg`** | Ogg-**shaped** page capture `"OggS"` / version / type / granule / serial / seq / checksum / nseg scan (not full Ogg demux) |
| **`Systems.Smtp`** | SMTP-**shaped** first-line command/reply method/code + optional text parse (not full SMTP stack) |
| **`Systems.BitSetMulti`** | Fixed-cap multi-word U32 bitset set/clear/test (BitMap twin; not growable / not concurrent) |
| **`Systems.Webm`** | WebM/EBML-**shaped** magic `0x1A45DFA3` + ID/size VINT class scan (not full WebM demux) |
| **`Systems.Pop3`** | POP3-**shaped** first-line `+OK`/`-ERR`/command parse (not full POP3 stack) |
| **`Systems.Roaring`** | Fixed-cap roaring-**shaped** ordered U32 set dense leaf (not multi-container / not concurrent) |
| **`Systems.Matroska`** | Matroska/EBML-**shaped** magic `0x1A45DFA3` + ID/size VINT class scan (not full Matroska demux) |
| **`Systems.Imap`** | IMAP-**shaped** first-line tagged/untagged OK/NO/BAD reply/command parse (not full IMAP stack) |
| **`Systems.IntervalSet`** | Fixed-cap ordered U32 interval set insert/contains/overlaps (not concurrent / not tree-augmented) |
| **`Systems.Flac`** | FLAC-**shaped** stream marker `"fLaC"` + optional STREAMINFO block header scan (not full FLAC codec) |
| **`Systems.Nntp`** | NNTP-**shaped** first-line 3-digit reply / command parse (not full NNTP stack) |
| **`Systems.OpusLite`** | Opus-**shaped** `OpusHead` magic + optional ID-header field scan (not full Opus codec) |
| **`Systems.Ldap`** | LDAP-**shaped** BER SEQUENCE + messageID + protocolOp min header (not full LDAP stack) |
| **`Systems.Vorbis`** | Vorbis-**shaped** type `0x01` + `"vorbis"` ID-packet magic + optional ID fields (not full Vorbis codec) |
| **`Systems.Radius`** | RADIUS-**shaped** min-20 code/identifier/length/authenticator header (not full RADIUS stack) |
| **`Systems.OrderedU32Set`** | Fixed-cap ordered unique **U32** set (dense sorted array; keys only; not concurrent / not tree-balanced) |
| **`Systems.SpeexLite`** | Speex-**shaped** `"Speex   "` magic + optional mode-header field scan (not full Speex codec) |
| **`Systems.Diameter`** | Diameter-**shaped** min-20 version/length/flags/command/app-id header (not full Diameter stack) |
| **`Systems.AmrLite`** | AMR storage-**shaped** `"#!AMR\n"` magic + optional first TOC/mode scan (not full AMR codec) |
| **`Systems.SctpCommon`** | SCTP common-header-**shaped** min-12 ports/vtag/checksum parse (distinct from `Sctp`; not full SCTP stack) |
| **`Systems.GsmLite`** | GSM storage-**shaped** `"#!GSM\n"` magic + optional first mode-header scan (not full GSM codec) |
| **`Systems.M3ua`** | M3UA common-header-**shaped** min-8 version/reserved/class/type/length parse (not full SS7/SIGTRAN) |
| **`Systems.G729Lite`** | G.729 storage-**shaped** `"#!G729"` magic + optional first mode-header scan (not full G.729 codec) |
| **`Systems.Sua`** | SUA common-header-**shaped** min-8 version/reserved/class/type/length parse (distinct from `M3ua`; not full SS7/SIGTRAN) |
| **`Systems.G711Lite`** | G.711 storage-**shaped** `"#!G711"` magic + optional first mode-header scan (not full G.711 codec) |
| **`Systems.Iua`** | IUA common-header-**shaped** min-8 version/reserved/class/type/length parse (distinct from `M3ua`/`Sua`; not full SS7/SIGTRAN) |
| **`Systems.G722Lite`** | G.722 storage-**shaped** `"#!G722"` magic + optional first mode-header scan (not full G.722 codec) |
| **`Systems.V5ua`** | V5UA common-header-**shaped** min-8 version/reserved/class/type/length parse (distinct from `M3ua`/`Sua`/`Iua`; not full SS7/SIGTRAN) |
| **`Systems.G726Lite`** | G.726 storage-**shaped** `"#!G726"` magic + optional first mode-header scan (not full G.726 codec) |
| **`Systems.H248`** | H.248/Megaco text first-line-**shaped** version/mid/method parse (not full H.248 stack / not ASN.1) |
| **`Systems.G728Lite`** | G.728 storage-**shaped** `"#!G728"` magic + optional first mode-header scan (not full G.728 codec) |
| **`Systems.Megaco`** | Megaco short-form transaction-token-**shaped** `T=`/`P=`/`R=`/`K=` scan (complementary to `H248` first-line version/mid/method; not full Megaco stack) |
| **`Systems.G729aLite`** | G.729 Annex A storage-**shaped** `"#!G729A"` magic + optional first mode-header scan (distinct from `G729Lite` `"#!G729"`; not full G.729A codec) |
| **`Systems.Mgcp`** | MGCP-**shaped** first-line command/response method/txn/version parse (not full MGCP softswitch stack) |
| **`Systems.IlbcLite`** | iLBC storage-**shaped** `"#!ILBC"` magic + optional first mode-header scan (distinct from Speex/G729; not full iLBC codec) |
| **`Systems.Sdp`** | SDP-**shaped** first-line `v=`/`o=`/`m=` type/version/media parse (not full SDP offer/answer stack) |
| **`Systems.SpeexNbLite`** | Speex NB annex-**shaped** `"SpeexNB"` magic + optional first mode-header scan (distinct from `SpeexLite` `"Speex   "`; not full Speex NB codec) |
| **`Systems.Rtcp`** | RTCP-**shaped** min-4 version/padding/RC/PT/length header (not full RTCP stack / not RTP media) |
| **`Systems.OpusNbLite`** | Opus NB annex-**shaped** `"OpusNB"` magic + optional first mode-header scan (distinct from `OpusLite` `"OpusHead"`; not full Opus NB codec) |
| **`Systems.Stun`** | STUN-**shaped** min-20 message type/length/magic cookie/transaction-id header (not full STUN/ICE stack) |
| **`Systems.OpusWbLite`** | Opus WB annex-**shaped** `"OpusWB"` magic + optional first mode-header scan (distinct from `OpusLite`/`OpusNbLite`; not full Opus WB codec) |
| **`Systems.Turn`** | TURN STUN-family min-20 message type/length/magic cookie/transaction-id header (distinct from `Stun`; not full TURN/ICE stack) |
| **`Systems.SpeexWbLite`** | Speex WB annex-**shaped** `"SpeexWB"` magic + optional first mode-header scan (distinct from `SpeexLite`/`SpeexNbLite`; not full Speex WB codec) |
| **`Systems.Ice`** | ICE/STUN-family connectivity-check min-20 message type/length/magic cookie/transaction-id header (distinct from `Stun`/`Turn`; not full ICE agent) |
| **`Systems.AmrWbLite`** | AMR-WB storage-**shaped** `"#!AMR-WB\n"` magic + optional first TOC/mode scan (distinct from `AmrLite` `"#!AMR\n"`; not full AMR-WB codec) |
| **`Systems.Rtp`** | RTP-**shaped** min-12 V/P/X/CC/M/PT/seq/timestamp/SSRC header (distinct from `Rtcp` min-4; not full RTP stack) |
| **`Systems.G723Lite`** | G.723 storage-**shaped** `"#!G723"` magic + optional first mode-header scan (distinct from `G722Lite` `"#!G722"`; not full G.723 codec) |
| **`Systems.Srtp`** | SRTP/RTP-family min-12 V/P/X/CC/M/PT/seq/timestamp/SSRC header (distinct from `Rtp`; **not full SRTP crypto**) |
| **`Systems.SilkLite`** | SILK storage-**shaped** `"#!SILK"` magic + optional first mode-header scan (distinct from `G723Lite` `"#!G723"`; not full SILK codec) |
| **`Systems.Srtcp`** | SRTCP/RTCP-family min-4 V/P/RC/PT/length header (distinct from `Rtcp`/`Srtp`; **not full SRTCP crypto**) |
| **`Systems.MelpLite`** | MELP storage-**shaped** `"#!MELP"` magic + optional first mode-header scan (distinct from `SilkLite` `"#!SILK"`; not full MELP codec) |
| **`Systems.Dtls`** | DTLS-**shaped** min-13 content/version/epoch/seq/length header (distinct from `Rtp`/`Srtp` min-12; **not full DTLS handshake/crypto**) |
| **`Systems.EvrcLite`** | EVRC storage-**shaped** `"#!EVRC"` magic + optional first mode-header scan (distinct from `MelpLite` `"#!MELP"`; not full EVRC codec) |
| **`Systems.Tls`** | TLS-**shaped** min-5 content/version/length header (distinct from `Dtls` min-13; **not full TLS handshake/crypto**) |
| **`Systems.QcelpLite`** | QCELP storage-**shaped** `"#!QCELP"` magic + optional first mode-header scan (distinct from `EvrcLite` `"#!EVRC"`; not full QCELP codec) |
| **`Systems.Ipsec`** | IPsec AH-**shaped** min-12 next-header/SPI/seq header (distinct from `Gre` min-4 / `Ip` min-20; **not full IPsec crypto/SAD**) |
| **`Systems.DepGraph`** | Fixed-cap dep DAG + Kahn topo/cycle (Slake build-order core; not Graph BFS / not dynamic alloc) |
| **`Systems.Trace`** | Fixed-cap rebuild-skip / hash-mix trace set (`mixPut`/`traceAt`; not Lake BuildTrace IO / not crypto) |
| **`Systems.TomlConfig`** | lakefile.toml-**subset** decode (package `name`/`version`, `[[lean_lib]]`/`[[lean_exe]]`/`[[require]]` counts, drivers, `weakLeanArgs`/`moreLeanArgs`/`leanArgs`/`moreLinkArgs`/`weakLinkArgs` quote counts, `firstLeanLibName*`/`firstLeanLibRoot*`/`firstLeanExeName*`/`firstLeanExeRoot*`/`firstRequireName*`/`firstRequirePath*`/`firstRequireRev*`/`firstRequireGit*`/`firstRequireUrl*`/`firstRequireVersion*`, `platformIndependent`/`preferReleaseBuild`/`buildArchive`/`supportInterpreter`/`enableArtifactCache`/`precompileModules`/`packagesDir`/`reservoir`/`buildDir`/`wrappersDir`/`nativeLibDir`/`testDriverArgs`/`lintDriverArgs`/`moreLinkArgs`/`leanOptions`/`moreServerOptions`/`manifest`/`versionTags` first-match (`manifest` shaped presence only), `description`/`keywords`/`homepage`/`license`/`readmeFile`/`licenseFiles`/`leanLibDir`/`binDir`/`irDir` presence-only, `firstRequireScope*`/`firstRequireSubDir*`/`firstRequireOpts*`, `requirePath*` scoped, `buildType`, `srcDir*`; not full TOML 1.0 / not Lean DSL; W72–W84 more7–more19 `hasBootstrap`/`hasMoreServerArgs`/`hasReleaseRepo`/`hasLeanLibDir`/`hasBinDir`/`hasIrDir`; more18 `hasExtraDepTargets`/`hasRestoreAllArtifacts`/`hasLibPrefixOnWindows`; more19 `hasAllowImportAll`/`hasFixedToolchain`/`hasVersion`; more20 `hasBuiltinLint`/`hasMoreLeancArgs`/`hasAllowNonModules`; more21 `hasRequiresModuleSystem`/`hasWeakLeancArgs`/`hasMoreLinkObjs` (`weakLeancArgs` ≠ `weakLeanArgs`; `moreLinkObjs` ≠ `moreLinkArgs`)); more22 presence-only `hasMoreLinkLibs`/`hasDynlibs`/`hasPlugins` (`moreLinkLibs` ≠ `moreLinkArgs`/`moreLinkObjs`/`moreLeancArgs`; `dynlibs` ≠ `plugins`); more23 presence-only `hasDefaultFacets`/`hasMoreGlobalServerArgs`/`hasLibName` (`moreGlobalServerArgs` ≠ `moreServerArgs`/`moreServerOptions`; `libName` ≠ `nativeLibDir`/`leanLibDir`); more24 presence-only `hasScope`/`hasRemoteUrl`/`hasWeakLeanArgs` (`weakLeanArgs` ≠ `weakLeancArgs`; presence twin of `weakLeanArgsCount`); more25 `hasFreestanding`/`hasRoots`/`hasGlobs` (presence-only); more26 `hasNeeds`/`hasWeakLinkArgs`/`hasExeName` (presence-only); … more56 `hasIr`/`hasTraceArgs`/`hasDebugAssertions`; more57 `hasVerLike`/`hasMappings`/`hasDefault` (presence-only; Lake greppable named keys); next more58 |
| **`Systems.Proc`** | Freestanding process spawn/wait (`fork`+`execve`+`waitpid`; affine `Pid`; argv0 + multi-arg + pipe/stdio redirect; not shell/PTY) |
| **`Systems.Manifest`** | lake-manifest / lockfile-**shaped** JSON-ish `"name"`/`"url"`/`"rev"`/`"version"` scan (not full Lake manifest / not Json) |
| **`Systems.IsacLite`** | iSAC storage-**shaped** `"#!ISAC"` magic + optional first mode-header scan (distinct from `QcelpLite` `"#!QCELP"`; not full iSAC codec) |
| **`Systems.CacheIndex`** | Fixed-cap rebuild-skip **cache-index** ordered U32 set (`mixPut`/`indexAt`; Trace twin; not Lake cache IO / not crypto) |
| **`Systems.L2tp`** | L2TP-**shaped** min-6/8 flags/version/tunnel/session header (RFC 2661-ish; distinct from `Gre` min-4 / `Ipsec` min-12; **not full L2TP control plane**) |
| **`Systems.Pptp`** | PPTP control-**shaped** min-8 length/type/magic-cookie header (RFC 2637-ish; distinct from `L2tp`/`Gre`; **not full PPTP**) |
| **`Systems.L2f`** | L2F-**shaped** min-4 flags/version/U8-protocol header (RFC 2341-ish; distinct from `L2tp`/`Gre`/`Pptp`; **not full L2F**) |
| **`Systems.Ppp`** | PPP-**shaped** min-4 address/control/BE protocol header (RFC 1661-ish; distinct from L2f/L2tp/Pptp; **not full PPP**) |
| **`Systems.GsmHrLite`** | GSM half-rate storage-**shaped** magic `"#!GSMHR"` (distinct from `GsmLite` `"#!GSM\n"`; **not full GSM-HR codec**) |
| **`Systems.Hdlc`** | HDLC-**shaped** min-4 opening-flag/address/control header (distinct from Ppp/L2f/L2tp; **not full HDLC**) |
| **`Systems.AmrNbLite`** | AMR-NB annex storage-**shaped** magic `"#!AMR-NB\n"` (distinct from `AmrLite`/`AmrWbLite`; **not full AMR-NB codec**) |
| **`Systems.V42Lite`** | V.42/LAPM-**shaped** min-4 address/control/seq/spare header (distinct from Ppp/Hdlc; not full V.42) |
| **`Systems.OpusSwbLite`** | Opus super-wideband annex magic `"OpusSWB"` + optional mode-header (distinct from Opus/OpusNb/OpusWb; not full codec) |
| **`Systems.V27Lite`** | V.27-**shaped** min-4 sync/rate/ctrl/spare header (distinct from V42/Hdlc/Ppp; not full V.27 modem) |
| **`Systems.AmrWbPlusLite`** | AMR-WB+ storage magic `"#!AMR-WB+\n"` + optional TOC (distinct from AmrWb/AmrNb/Amr; not full codec) |
| **`Systems.V32Lite`** | V.32-**shaped** min-4 sync/rate/ctrl/spare header (sync `0x5A`; distinct from V27/V42/Hdlc/Ppp; not full V.32 modem) |
| **`Systems.GsmEfrLite`** | GSM-EFR storage magic `"#!GSMEFR"` + optional mode-header (distinct from Gsm/GsmHr; not full codec) |
| **`Systems.V34Lite`** | V.34-**shaped** min-4 sync/rate/ctrl/spare header (sync `0x3C`; distinct from V32/V27/V42; not full V.34 modem) |
| **`Systems.SilkSwbLite`** | SILK SWB annex magic `"SilkSWB"` + optional mode-header (distinct from Silk/Speex*; not full codec) |
| **`Systems.V22Lite`** | V.22-**shaped** min-4 sync/rate/ctrl/spare header (sync `0x22`; distinct from V21/V23/V32/V34/V42; not full V.22 modem) |
| **`Systems.SpeexUwbLite`** | Speex UWB annex magic `"SpeexUW"` + optional mode-header (distinct from Speex/SpeexNb/SpeexWb; not full codec) |
| **`Systems.V21Lite`** | V.21-**shaped** min-4 sync/rate/ctrl/spare header (sync `0x21`; distinct from V22/V23/V32/V34/V42; not full V.21 modem) |
| **`Systems.SilkUwbLite`** | SILK UWB annex magic `"SilkUWB"` + optional mode-header (distinct from Silk/SilkSwb/SpeexUwb; not full codec) |
| **`Systems.V23Lite`** | V.23-**shaped** min-4 sync/rate/ctrl/spare header (sync `0x23`; distinct from V21/V22/V32/V34/V42; not full V.23 modem) |
| **`Systems.IsacUwbLite`** | iSAC UWB annex magic `"IsacUWB"` + optional mode-header (distinct from Isac/SilkUwb/SpeexUwb; not full codec) |
| **`Systems.V26Lite`** | V.26-**shaped** min-4 sync/rate/ctrl/spare header (sync `0x26`; distinct from V21/V22/V23/V32/V34/V42; not full V.26 modem) |
| **`Systems.IsacSwbLite`** | iSAC SWB annex magic `"IsacSWB"` + optional mode-header (distinct from Isac/IsacUwb/SilkSwb; not full codec) |
| **`Systems.V29Lite`** | V.29-**shaped** min-4 sync/rate/ctrl/spare header (sync `0x29`; ctrl `0x08`; distinct from V21–V26/V32/V34/V42; not full V.29 modem) |
| **`Systems.SpeexSwbLite`** | Speex SWB annex magic `"SpeexSW"` + optional mode-header (distinct from Speex/SpeexNb/SpeexWb/SpeexUwb; not full codec) |
| **`Systems.V17Lite`** | V.17-**shaped** min-4 sync/rate/ctrl/spare header (sync `0x17`; ctrl `0x09`; distinct from V21–V29/V32/V34/V42; not full V.17 modem) |
| **`Systems.QcelpUwbLite`** | QCELP UWB annex magic `"QcelpUW"` + optional mode-header (distinct from Qcelp/Speex/SpeexNb/SpeexWb/SpeexUwb/SpeexSwb; not full codec) |
| **`Systems.V33Lite`** | V.33-shaped min-4 sync/rate/ctrl/spare header (sync `0x33` / train ctrl `0x0B`; not full V.33 modem) |
| **`Systems.MelpUwbLite`** | MELP UWB annex magic `"MelpUWB"` + optional mode-header (distinct from Melp/QcelpUwb/IsacUwb/SilkUwb/SpeexUwb/SpeexSwb; not full MELP codec) |
| **`Systems.V18Lite`** | V.18-shaped min-4 sync/rate/ctrl/spare header (sync `0x18` / train ctrl `0x0C`; not full V.18 modem) |
| **`Systems.MelpSwbLite`** | MELP SWB annex magic `"MelpSWB"` + optional mode-header (distinct from Melp/MelpUwb/QcelpUwb/IsacUwb/IsacSwb/SilkUwb/SilkSwb/SpeexUwb/SpeexSwb; not full MELP codec) |
| **`Systems.V19Lite`** | V.19-shaped min-4 sync/rate/ctrl/spare header (sync `0x19` / train ctrl `0x0D`; not full V.19 modem) |
| **`Systems.MelpNbLite`** | MELP NB annex magic `"MelpNB"` + optional mode-header (distinct from Melp/MelpUwb/MelpSwb/QcelpUwb/IsacUwb/IsacSwb/SilkUwb/SilkSwb/SpeexUwb/SpeexSwb; not full MELP codec) |
| **`Systems.V28Lite`** | V.28-shaped min-4 sync/rate/ctrl/spare header (sync `0x28` / ctrl train `0x0F`; distinct from V24/V19/…) |
| **`Systems.LapmLite`** | LAPM-shaped `"#!LAPM"` annex magic + optional first mode-header / LE field scan (distinct from OpusFb/Melp/Hdlc peers) |
| **`Systems.V31Lite`** | V.31-shaped min-4 sync/rate/ctrl/spare header (sync `0x31` / ctrl train `0x10`; distinct from V28/V24/…) |
| **`Systems.AmrNbPlusLite`** | AMR-NB+-shaped `"#!AMRNB+"` annex magic + optional first mode-header / LE field scan (distinct from AmrNb/Lapm/OpusFb peers) |
| **`Systems.V30Lite`** | V.30-shaped min-4 sync/rate/ctrl/spare header (sync `0x30` / ctrl train `0x11`; distinct from V31/V28/V24/…) |
| **`Systems.SilkNbLite`** | Silk-NB-shaped `"SilkNB"` annex magic + optional first mode-header / LE field scan (distinct from SilkSwb/SilkUwb/Silk/OpusFb/AmrNbPlus/Lapm peers) |
| **`Systems.V25Lite`** | V.25-shaped min-4 sync/rate/ctrl/spare header (sync `0x25` / train ctrl `0x12`; distinct from V.30/V.31/V.28/V.24) |
| **`Systems.QcelpNbLite`** | QCELP-NB-shaped `"QcelpNB"` annex magic + optional first mode-header / LE field scan (distinct from Qcelp/QcelpUW/SilkNb/OpusNb peers) |
| **`Systems.V15Lite`** | V.15-shaped min-4 sync `0x15`/rate/ctrl `0x0A`/spare header |
| **`Systems.GsmNbLite`** | GSM-NB annex magic `"GsmNB0"` + optional first mode-header |
| **`Systems.V14Lite`** | V.14-shaped min-4 sync `0x14`/rate/ctrl `0x16`/spare header |
| **`Systems.G729NbLite`** | G.729-NB annex magic `"G729NB"` + optional first mode-header |
| **`Systems.V13Lite`** | V.13-shaped min-4 sync `0x13`/rate/ctrl `0x17`/spare header |
| **`Systems.IlbcNbLite`** | iLBC-NB annex magic `"IlbcNB"` + optional first mode-header |
| **`Systems.V12Lite`** | V.12 min-4 sync `0x12` / ctrl `0x18` header |
| **`Systems.G711NbLite`** | G.711-NB annex magic `"G711NB"` + optional first mode-header |
| **`Systems.V6Lite`** | V.6-shaped min-4 sync `0x06` / train ctrl `0x1E` header (distinct from V7/V8 peers; not full V.6 modem) |
| **`Systems.G721NbLite`** | G.721-NB annex magic `"G721NB"` + optional first mode-header / LE field scan (distinct from G727/G728 peers; not full G.721 codec) |
| **`Systems.V5Lite`** | V.5-shaped min-4 sync `0x05` / train ctrl `0x1F` header (distinct from V6/V7 peers; not full V.5 modem) |
| **`Systems.G724NbLite`** | G.724-NB annex magic `"G724NB"` + optional first mode-header / LE field scan (distinct from G721/G727 peers; not full G.724 codec) |
| **`Systems.V7Lite`** | V.7-shaped min-4 sync `0x07` / train ctrl `0x1D` header |
| **`Systems.G727NbLite`** | G.727-NB annex magic `"G727NB"` + optional first mode-header |
| **`Systems.V11Lite, V10Lite, V9Lite`** | V.11/V.10/V.9-shaped min-4 headers (sync `0x11`/`0x10`/`0x09`) |
| **`Systems.G722NbLite, G723NbLite, G726NbLite`** | G.722/G.723/G.726-NB annex magics `"G722NB"`/`"G723NB"`/`"G726NB"` |
| **`Systems.V16Lite`** | V.16-shaped min-4 sync `0x16` / train ctrl `0x14` header (distinct from V20/V25 peers) |
| **`Systems.IsacNbLite`** | iSAC-NB-shaped `"IsacNB"` annex magic + optional mode-header / LE field scan (distinct from EvrcNb/Isac peers) |
| **`Systems.V20Lite`** | V.20-shaped min-4 sync `0x20` / train ctrl `0x13` header (distinct from V25/V30/V31 peers) |
| **`Systems.EvrcNbLite`** | EVRC-NB-shaped `"EvrcNB"` annex magic + optional first mode-header / LE field scan (distinct from Evrc/QcelpNb/SilkNb peers) |
| **`Systems.V24Lite`** | V.24-**shaped** min-4 modem header (sync `0x24` / train ctrl `0x0E`; distinct from V.19 `0x19` / V.18 `0x18` / V.17–V.34 peers; not full V.24) |
| **`Systems.OpusFbLite`** | Opus FB annex magic `"OpusFB"` + optional mode-header (distinct from OpusHead/OpusSWB/OpusWB/OpusNB/MelpNB peers; not full Opus codec) |
| **`Systems.Parallelism.Simd`** | L1 data-parallel map/fold + **4-wide chunked** sequential path (SIMD-**shaped**; not hardware SIMD)
| **`Systems.Parallelism.ForkJoin`** | L2 ownership-partition API (**sequential product default**; opt-in pthread dogfood via `par_pthread.c`) |
| **`Systems.Parallelism.Channel`** | L3 linear one-cell send/recv (`@[affine]` Chan; try/send + dual-payload smoke; sequential) |

Rules:

- Compiled only with **`compiler.freestanding=true`** (prefer Lake `freestanding := true`).  
- **No `Init` import** — closed freestanding fragment; freestanding modules import freestanding only.  
- Prefer **dual scalar params** (`addr`, `len`) over multi-field freestanding product values.  
- Own resources are **affine**; free/close explicitly.  
- **No** managed `List` / `String` / `Array` RC types on the product path.

## Dual path

| Path | Modules | Runtime |
|------|---------|---------|
| Product extract | `Systems.*` only | No GC on the link line |
| Host proofs/tools | Classic Init/Std | Full stage1 + `libleanshared` |

Classic `src/Init` / `src/Std` are unchanged. Ports move inventory buckets
`fs-planned` → `fs-ready` by adding modules here.

### Three-Layer Cake (Parallelism) honesty

| Layer | Product path | Opt-in host dogfood |
|-------|--------------|---------------------|
| **L1 Simd** | Residual-free sequential scalar + chunked-4 loops (SIMD-**shaped**; no `_mm_*` / `immintrin` on product IR) | `make -C tests/lake/examples/systems check-par-simd-hw` links `par_simd_hw.c` (SSE2 when available, else scalar fallback); export `lean_fs_par_map_add_u8_simd_hw` |
| **L2 ForkJoin** | Sequential L-then-R partitions; `lean_fs_par_l2_backend` → `0` | `make -C tests/lake/examples/systems check-par-pthread` links `par_pthread.c` with `-DSYSTEMS_LEAN_PAR_PTHREAD=1 -pthread` (compile define, not env); backend id `1` |
| **L3 Channel** | Affine one-cell sequential send/recv; no RC queue | No OS threads on product path |

**Product isolation:** `./script/systems-par-dual-path-check.sh` / `make check-par-dual-path` greps product bundle + Parallelism IR and emits `PARALLELISM_DUAL_PATH_OK=1`, `PRODUCT_PARALLELISM_NO_PTHREAD=1`, `PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1`, `CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1`. Default `make check` includes dual-path isolation; **does not** require pthread or HW dogfood.

Not claimed: verified concurrent runtime / formal memory model, autovectorization as a product residual property, GC-free elaborator.

## Build

```bash
# Optional (not a default stage1 target)
lake --dir=src build Systems

# Product path (freestanding + nm gate + inventory)
./script/systems-stdlib.sh
```

In a consumer package (recommended):

```lean
lean_lib Systems where
  freestanding := true
  defaultFacets := #[LeanLib.freestandingFacet]
  -- roots / srcDir as needed

lean_lib MyEngine where
  freestanding := true
  defaultFacets := #[LeanLib.freestandingBundleFacet]  -- one .a for cc
  needs := #[`@/Systems]
```

Link:

```bash
cc -std=c11 -o app main.c $(lake query MyEngine:freestanding.bundle)
```

## Example

End-to-end C consumer + host proofs: `tests/lake/examples/systems/`
