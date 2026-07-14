LAKE ?= lake

# Fail if any command in a pipe fails (needed so `run` cannot ignore main's exit status).
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

.PHONY: all lake lib host run check check-full check-nm check-deps check-gates check-ir check-host check-s12 check-s13 check-memsafe check-compcert check-compcert-negatives check-compcert-compliant check-compcert-dogfood check-compcert-compliant-negatives check-proof-receipt check-proof-receipt-negatives check-selfhost check-selfhost-negatives check-stdlib check-sorry-free check-par-dual-path check-par-dual-path-negatives check-par-pthread check-par-pthread-join-fail check-par-simd-hw check-par-simd-hw-scalar check-par-dogfood validate-systems clean

OUT_DIR = out
LIB_DIR = lib/.lake/build/lib
# Multi-archive list (tooling / verification): Extract first, then freestanding needs.
FS_LIBS = $(shell $(LAKE) --dir=lib query Extract:freestanding)
# Happy path for C consumers: one combined freestanding archive.
FS_BUNDLE = $(shell $(LAKE) --dir=lib query Extract:freestanding.bundle)
EXTRACT_C = lib/.lake/build/ir/Extract.c
HOST_SETUP = host/.lake/build/ir/Host.setup.json
HOST_OLEAN = host/.lake/build/lib/lean/Host.olean
# Known buffer in main.c: {1,2,3,4,5} with acc = acc*31 + byte
EXPECTED_CHECKSUM := 986115
# Per-fault-class ownership greps (QTT elab and/or LCNF AffineCheck phrasings of the *same* property).
# Do NOT use a blanket "freestanding QTT" match — that false-greens wrong error classes (e.g. silent drop for UAF).
FS_ERR_DOUBLE := double use|use-after-move
FS_ERR_DROP   := silent drop
FS_ERR_AFTER  := use-after-consume|use-after-move
FS_ERR_UAF    := use-after-free
FS_ERR_BORROW := fs_borrow|same affine type|dual ownership

all: run check

lake:
	$(LAKE) --dir=lib build

lib: lake

# host-only specs (full Init / Prop / tactics; NOT compiler.freestanding)
host: lake
	$(LAKE) --dir=host update
	$(LAKE) --dir=host build

$(OUT_DIR):
	mkdir -p $@

$(OUT_DIR)/main: main.c lake | $(OUT_DIR)
# Systems Lean: one freestanding bundle archive, ISO C11, no Lean dynlibs.
	cc -std=c11 -o $@ main.c $(FS_BUNDLE)

# Run unpiped so a non-zero exit from main fails the recipe; then assert stdout values.
run: $(OUT_DIR)/main
	$(OUT_DIR)/main > $(OUT_DIR)/run.out
	grep -q 'output: 42' $(OUT_DIR)/run.out
	grep -q 'checksum: $(EXPECTED_CHECKSUM)' $(OUT_DIR)/run.out
	grep -q 'load_u8: 7' $(OUT_DIR)/run.out
	grep -q 'write_all: 0' $(OUT_DIR)/run.out
	grep -q 'data: hello-s2' $(OUT_DIR)/run.out
	grep -q 'arena_checksum: $(EXPECTED_CHECKSUM)' $(OUT_DIR)/run.out
	grep -q 'arena_free: 0' $(OUT_DIR)/run.out
	grep -q 'arena_alloc_overflow_same: 1' $(OUT_DIR)/run.out
	grep -q 'arena_alloc_overflow_lastptr: 1' $(OUT_DIR)/run.out
	grep -q 'arena_create_overflow: 1' $(OUT_DIR)/run.out
	grep -q 'arena_smoke: 6680135' $(OUT_DIR)/run.out
	grep -q 'malloc_checksum:' $(OUT_DIR)/run.out
	grep -q 'log_put1: 0' $(OUT_DIR)/run.out
	grep -q 'log_put2: 0' $(OUT_DIR)/run.out
	grep -q 'log_get: 13 data: two-overwrite' $(OUT_DIR)/run.out
	grep -q 'log_get_stress: 10 data: stress-val' $(OUT_DIR)/run.out
	grep -q 'log_put_overflow: 1' $(OUT_DIR)/run.out
	grep -q 'log_get_toosmall: -3' $(OUT_DIR)/run.out
	grep -q 'log_sync: 0' $(OUT_DIR)/run.out
	grep -q 'log_close: 0' $(OUT_DIR)/run.out
	grep -q 'log_get_corrupt: -2' $(OUT_DIR)/run.out
	grep -q 'log_smoke: 3 data: val' $(OUT_DIR)/run.out
	grep -q 'mmap_copy: 0' $(OUT_DIR)/run.out
	grep -q 'mmap_msync: 0' $(OUT_DIR)/run.out
	grep -q 'mmap_munmap: 0' $(OUT_DIR)/run.out
	grep -q 'mmap_reopen: hello-s5-mmap' $(OUT_DIR)/run.out
	grep -q 'mmap_smoke: 0 data: smoke-s5' $(OUT_DIR)/run.out
	grep -q 'mmap_close_live: 0' $(OUT_DIR)/run.out
	grep -q 'mmap_close_live_data: close-live' $(OUT_DIR)/run.out
	grep -q 'mmap_failed_dispose: 0' $(OUT_DIR)/run.out
	grep -q 'mem_eq_same: 1' $(OUT_DIR)/run.out
	grep -q 'mem_copy_eq: 1' $(OUT_DIR)/run.out
	grep -q 'mem_fill: 171' $(OUT_DIR)/run.out
	grep -q 'mem_xor_fold: 1' $(OUT_DIR)/run.out
	grep -q 'mem_find_u8: 2' $(OUT_DIR)/run.out
	grep -q 'mem_find_miss: -1' $(OUT_DIR)/run.out
	grep -q 'u32_sat_add: 4294967295' $(OUT_DIR)/run.out
	grep -q 'u32_rotate_left1: 3' $(OUT_DIR)/run.out
	grep -q 'status_norm_ok: 0' $(OUT_DIR)/run.out
	grep -q 'status_and_then: 0' $(OUT_DIR)/run.out
	grep -q 'mem_move:' $(OUT_DIR)/run.out
	grep -q 'hash_bytes:' $(OUT_DIR)/run.out
	grep -q 'u32_popcount: 4' $(OUT_DIR)/run.out
	grep -q 'par_map_fold: 0' $(OUT_DIR)/run.out
	grep -q 'par_fork_join:' $(OUT_DIR)/run.out
	grep -q 'par_fork_join_n1: 9' $(OUT_DIR)/run.out
	grep -q 'par_fork_join_n0: ok' $(OUT_DIR)/run.out
	grep -q 'par_chan_ping: 0' $(OUT_DIR)/run.out
	grep -q 'status_or_else: 0' $(OUT_DIR)/run.out
	grep -q 'u64_wrap_add: 0' $(OUT_DIR)/run.out
	grep -q 'u64_sat_add: max' $(OUT_DIR)/run.out
	grep -q 'u64_rotate_left: ok' $(OUT_DIR)/run.out
	grep -q 'bv_truncate_edges: ok' $(OUT_DIR)/run.out
	grep -q 'bv_clear_bit: ok' $(OUT_DIR)/run.out
	grep -q 'bv_popcount: 4' $(OUT_DIR)/run.out
	grep -q 'bv_popcount_trunc: 4' $(OUT_DIR)/run.out
	grep -q 'bv_expand: ok' $(OUT_DIR)/run.out
	grep -q 'set_contains: ok' $(OUT_DIR)/run.out
	grep -q 'set_cap0: ok' $(OUT_DIR)/run.out
	grep -q 'set_full: ok' $(OUT_DIR)/run.out
	grep -q 'map_erase_rehash: ok' $(OUT_DIR)/run.out
	grep -q 'map_full: ok' $(OUT_DIR)/run.out
	grep -q 'map_collision_tomb: ok' $(OUT_DIR)/run.out
	grep -q 'set_erase_rehash: ok' $(OUT_DIR)/run.out
	grep -q 'set_collision_tomb: ok' $(OUT_DIR)/run.out
	grep -q 'span_subspan: ok' $(OUT_DIR)/run.out
	grep -q 'queue_ring: ok' $(OUT_DIR)/run.out
	grep -q 'string_view: ok' $(OUT_DIR)/run.out
	grep -q 'bsearch_u32: ok' $(OUT_DIR)/run.out
	grep -q 'deque_ring: ok' $(OUT_DIR)/run.out
	grep -q 'stack_u32: ok' $(OUT_DIR)/run.out
	grep -q 'ascii_ctype: ok' $(OUT_DIR)/run.out
	grep -q 'mem_region: ok' $(OUT_DIR)/run.out
	grep -q 'bitset_u64: ok' $(OUT_DIR)/run.out
	grep -q 'parse_dec: ok' $(OUT_DIR)/run.out
	grep -q 'ring_u8: ok' $(OUT_DIR)/run.out
	grep -q 'fmt_dec: ok' $(OUT_DIR)/run.out
	grep -q 'list_u32: ok' $(OUT_DIR)/run.out
	grep -q 'path_lite: ok' $(OUT_DIR)/run.out
	grep -q 'hex_lite: ok' $(OUT_DIR)/run.out
	grep -q 'utf8_lite: ok' $(OUT_DIR)/run.out
	grep -q 'tree_lite: ok' $(OUT_DIR)/run.out
	grep -q 'json_lite: ok' $(OUT_DIR)/run.out
	grep -q 'base64_lite: ok' $(OUT_DIR)/run.out
	grep -q 'graph_lite: ok' $(OUT_DIR)/run.out
	grep -q 'regex_lite: ok' $(OUT_DIR)/run.out
	grep -q 'url_lite: ok' $(OUT_DIR)/run.out
	grep -q 'arena_pool: ok' $(OUT_DIR)/run.out
	grep -q 'ini_lite: ok' $(OUT_DIR)/run.out
	grep -q 'csv_lite: ok' $(OUT_DIR)/run.out
	grep -q 'bloom_lite: ok' $(OUT_DIR)/run.out
	grep -q 'toml_lite: ok' $(OUT_DIR)/run.out
	grep -q 'xml_lite: ok' $(OUT_DIR)/run.out
	grep -q 'skiplist_lite: ok' $(OUT_DIR)/run.out
	grep -q 'yaml_lite: ok' $(OUT_DIR)/run.out
	grep -q 'http_lite: ok' $(OUT_DIR)/run.out
	grep -q 'btree_lite: ok' $(OUT_DIR)/run.out
	grep -q 'dns_lite: ok' $(OUT_DIR)/run.out
	grep -q 'sexp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'avl_lite: ok' $(OUT_DIR)/run.out
	grep -q 'md_lite: ok' $(OUT_DIR)/run.out
	grep -q 'icmp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'rbtree_lite: ok' $(OUT_DIR)/run.out
	grep -q 'pem_lite: ok' $(OUT_DIR)/run.out
	grep -q 'ntp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'trie_lite: ok' $(OUT_DIR)/run.out
	grep -q 'jwt_lite: ok' $(OUT_DIR)/run.out
	grep -q 'dhcp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'heap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'uuid_lite: ok' $(OUT_DIR)/run.out
	grep -q 'arp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'interval_lite: ok' $(OUT_DIR)/run.out
	grep -q 'semver_lite: ok' $(OUT_DIR)/run.out
	grep -q 'gre_lite: ok' $(OUT_DIR)/run.out
	grep -q 'splay_lite: ok' $(OUT_DIR)/run.out
	grep -q 'cbor_lite: ok' $(OUT_DIR)/run.out
	grep -q 'ip_lite: ok' $(OUT_DIR)/run.out
	grep -q 'btreemap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'tomlquery_lite: ok' $(OUT_DIR)/run.out
	grep -q 'udp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'skipmap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'edn_lite: ok' $(OUT_DIR)/run.out
	grep -q 'tcp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'hashmap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'msgpack_lite: ok' $(OUT_DIR)/run.out
	grep -q 'linkedhashmap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'protobuf_lite: ok' $(OUT_DIR)/run.out
	grep -q 'sctp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'orderedmap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'avro_lite: ok' $(OUT_DIR)/run.out
	grep -q 'dccp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'treemap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'capnp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'quic_lite: ok' $(OUT_DIR)/run.out
	grep -q 'flatbuffers_lite: ok' $(OUT_DIR)/run.out
	grep -q 'mqtt_lite: ok' $(OUT_DIR)/run.out
	grep -q 'radixtree_lite: ok' $(OUT_DIR)/run.out
	grep -q 'asn1_lite: ok' $(OUT_DIR)/run.out
	grep -q 'coap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'yamlquery_lite: ok' $(OUT_DIR)/run.out
	grep -q 'websocket_lite: ok' $(OUT_DIR)/run.out
	grep -q 'bitmap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'lz4_lite: ok' $(OUT_DIR)/run.out
	grep -q 'socks5_lite: ok' $(OUT_DIR)/run.out
	grep -q 'snappy_lite: ok' $(OUT_DIR)/run.out
	grep -q 'rtsp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'zstd_lite: ok' $(OUT_DIR)/run.out
	grep -q 'sip_lite: ok' $(OUT_DIR)/run.out
	grep -q 'brotli_lite: ok' $(OUT_DIR)/run.out
	grep -q 'ntpquery_lite: ok' $(OUT_DIR)/run.out
	grep -q 'ogg_lite: ok' $(OUT_DIR)/run.out
	grep -q 'smtp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'bitsetmulti_lite: ok' $(OUT_DIR)/run.out
	grep -q 'webm_lite: ok' $(OUT_DIR)/run.out
	grep -q 'pop3_lite: ok' $(OUT_DIR)/run.out
	grep -q 'roaring_lite: ok' $(OUT_DIR)/run.out
	grep -q 'matroska_lite: ok' $(OUT_DIR)/run.out
	grep -q 'imap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'intervalset_lite: ok' $(OUT_DIR)/run.out
	grep -q 'flac_lite: ok' $(OUT_DIR)/run.out
	grep -q 'nntp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'ldap_lite: ok' $(OUT_DIR)/run.out
	grep -q 'vorbis_lite: ok' $(OUT_DIR)/run.out
	grep -q 'radius_lite: ok' $(OUT_DIR)/run.out
	grep -q 'orderedset_lite: ok' $(OUT_DIR)/run.out
	grep -q 'diameter_lite: ok' $(OUT_DIR)/run.out
	grep -q 'sctpcommon_lite: ok' $(OUT_DIR)/run.out
	grep -q 'm3ua_lite: ok' $(OUT_DIR)/run.out
	grep -q 'sua_lite: ok' $(OUT_DIR)/run.out
	grep -q 'iua_lite: ok' $(OUT_DIR)/run.out
	grep -q 'v5ua_lite: ok' $(OUT_DIR)/run.out
	grep -q 'h248_lite: ok' $(OUT_DIR)/run.out
	grep -q 'megaco_lite: ok' $(OUT_DIR)/run.out
	grep -q 'mgcp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'sdp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'rtcp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'stun_lite: ok' $(OUT_DIR)/run.out
	grep -q 'turn_lite: ok' $(OUT_DIR)/run.out
	grep -q 'ice_lite: ok' $(OUT_DIR)/run.out
	grep -q 'rtp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'srtp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'srtcp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'dtls_lite: ok' $(OUT_DIR)/run.out
	grep -q 'tls_lite: ok' $(OUT_DIR)/run.out
	grep -q 'ipsec_lite: ok' $(OUT_DIR)/run.out
	grep -q 'depgraph_lite: ok' $(OUT_DIR)/run.out
	grep -q 'trace_lite: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_lite: ok' $(OUT_DIR)/run.out
	grep -q 'proc_lite: ok' $(OUT_DIR)/run.out
	grep -q 'proc_multi_argv: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more2: ok' $(OUT_DIR)/run.out
	grep -q 'manifest_lite: ok' $(OUT_DIR)/run.out
	grep -q 'cacheindex_lite: ok' $(OUT_DIR)/run.out
	grep -q 'l2tp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more: ok' $(OUT_DIR)/run.out
	grep -q 'pptp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'l2f_lite: ok' $(OUT_DIR)/run.out
	grep -q 'ppp_lite: ok' $(OUT_DIR)/run.out
	grep -q 'proc_pipe: ok' $(OUT_DIR)/run.out
	grep -q 'hdlc_lite: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more3: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more4: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more5: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more6: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more7: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more8: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more9: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more10: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more11: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more12: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more13: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more14: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more15: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more16: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more17: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more18: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more19: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more20: ok' $(OUT_DIR)/run.out
	grep -q 'tomlconfig_more21: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_more_link_libs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_dynlibs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_plugins: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_default_facets: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_more_global_server_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_lib_name: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_scope: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_remote_url: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_weak_lean_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_freestanding: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_roots: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_globs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_needs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_weak_link_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_exe_name: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_more_lean_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_native_facets: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_root: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_name: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_lean_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_test_runner: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_server_options: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_leanc_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_base_name: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_link_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_server_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_global_server_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more30_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_link_objs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_link_libs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_options: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more31_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_git: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_path: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_rev: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more32_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_sub_dir: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_url: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_opts: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more33_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_type: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_dir: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_source: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more34_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_kind: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_preset: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_extension: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more35_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_filter: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_text: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_file_name: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more36_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_starts_with: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_ends_with: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_not: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more37_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_any: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_all: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_api_endpoint: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more38_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_artifact_endpoint: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_revision_endpoint: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_default_service: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more39_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_service: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_repo: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_schema_version: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more40_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_data: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_manifest_file: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_lake_dir: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more41_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_config_file: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_input_rev: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_packages: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more42_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_inherited: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_git_url: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_full_name: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more43_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_default_branch: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_repo_url: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_sources: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more44_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_revision: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_host: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_hash: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more45_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_dephash: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_file: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_inputs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more46_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_outputs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_status: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_log: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more47_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_synthetic: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_message: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_error: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more48_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_http_code: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_response_code: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_errormsg: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more49_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_content_type: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_urlnum: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_size_download: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more50_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_rs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_o: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_i: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more51_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_m: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_c: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_b: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more52_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_l: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_r: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_require: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more53_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_value: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_major: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_minor: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more54_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_art: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_olean: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_ltar: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more55_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_ir: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_trace_args: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_debug_assertions: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more56_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_ver_like: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_mappings: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_default: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more57_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_objs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_cache: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_script: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more58_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_ext: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_lean: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_toml: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more59_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_env: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_help: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_cc: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more60_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_info: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_remote: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_facets: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more61_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_package: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_module: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_build: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more62_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_clean: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_test: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_serve: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more63_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_lint: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_exe: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_query: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more64_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_init: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_new: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_update: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more65_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_pack: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_unpack: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_upload: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more66_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_shake: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_run: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_scripts: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more67_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_get: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_put: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_add: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more68_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_list: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_doc: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_stage: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more69_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_exec: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_unstage: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_put_staged: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more70_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_check_build: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_check_lint: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_check_test: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more71_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_query_kind: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_setup_file: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_self_check: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more72_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_translate_config: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_resolve_deps: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_services: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more73_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_reservoir_config: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_version_tags_cli: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_upgrade: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more74_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_no_build: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_no_cache: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_try_cache: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more75_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_force_download: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_download_arts: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_mappings_only: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more76_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_no_overwrite: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_force_overwrite: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_rehash: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more77_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_keep_implied: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_keep_prefix: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_keep_public: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more78_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_add_public: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_gh_style: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_explain: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more79_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_builtin_only: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_lint_only: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_record_exceptions: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more80_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_keep_toolchain: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_allow_empty: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_max_revs: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more81_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_log_level: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_fail_level: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_no_ansi: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more82_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_reconfigure: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_quiet: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_verbose: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more83_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_offline: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_platform: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_toolchain: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more84_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_wfail: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_iofail: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_ansi: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more85_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_force: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_fix: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_only: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more86_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_trace: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_old: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_json: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more87_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_linters: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_builtin_lint_cli: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_has_linter: ok' $(OUT_DIR)/run.out
	grep -q 'tomlcfg_more88_cross_key: ok' $(OUT_DIR)/run.out
	grep -q 'u32_sat_sub: ok' $(OUT_DIR)/run.out
	grep -q 'u32_rotate_right: ok' $(OUT_DIR)/run.out
	grep -q 'u32_clamp: ok' $(OUT_DIR)/run.out
	grep -q 'u64_usize_helpers: ok' $(OUT_DIR)/run.out

# No Lean runtime / mangled Lean symbols required by the archives; exports must be defined.
# may have U open/close/read/write/malloc/free/fsync/lseek/mmap/munmap/msync/ftruncate from libc — those are allowed; lean_*/l_* are not.
# Scan the combined freestanding bundle (contains Extract + Freestanding objects).
check-nm: lake
	@echo "=== nm on freestanding bundle (undefs + defined exports) ==="
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }; \
	  n_bundle=$$(echo $(FS_BUNDLE) | wc -w); \
	  test "$$n_bundle" -eq 1 || { echo "FAIL: freestanding.bundle must be exactly 1 path, got $$n_bundle: $(FS_BUNDLE)"; exit 1; }; \
	  test -n "$(FS_LIBS)" || { echo "FAIL: empty freestanding link list from lake query Extract:freestanding"; exit 1; }; \
	  for f in $(FS_LIBS); do \
	    test -f "$$f" || { echo "FAIL: missing freestanding archive $$f"; exit 1; }; \
	  done; \
	  n=$$(echo $(FS_LIBS) | wc -w); \
	  test "$$n" -ge 2 || { echo "FAIL: freestanding multi-list expected ≥2 archives, got $$n: $(FS_LIBS)"; exit 1; }; \
	  undef=$$(nm -u $(FS_BUNDLE) 2>/dev/null || nm -u -A $(FS_BUNDLE) 2>/dev/null || true); \
	  echo "$$undef"; \
	  bad_lean=$$(echo "$$undef" | grep -E '[[:space:]]U[[:space:]]+lean_' || true); \
	  bad_l=$$(echo "$$undef" | grep -E '[[:space:]]U[[:space:]]+l_' || true); \
	  if [ -n "$$bad_lean" ] || [ -n "$$bad_l" ]; then \
	    echo "FAIL: Lean runtime / mangled undefs:"; echo "$$bad_lean"; echo "$$bad_l"; exit 1; \
	  fi; \
	  defs=$$(nm $(FS_BUNDLE) 2>/dev/null || nm -g $(FS_BUNDLE) 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_add$$' >/dev/null \
	    || { echo "FAIL: lean_fs_add not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_checksum$$' >/dev/null \
	    || { echo "FAIL: lean_fs_checksum not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_load_u8$$' >/dev/null \
	    || { echo "FAIL: lean_fs_load_u8 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_open$$' >/dev/null \
	    || { echo "FAIL: lean_fs_open not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_close$$' >/dev/null \
	    || { echo "FAIL: lean_fs_close not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_write_all$$' >/dev/null \
	    || { echo "FAIL: lean_fs_write_all not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_read$$' >/dev/null \
	    || { echo "FAIL: lean_fs_read not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_write$$' >/dev/null \
	    || { echo "FAIL: lean_fs_write not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_arena_create$$' >/dev/null \
	    || { echo "FAIL: lean_fs_arena_create not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_arena_alloc$$' >/dev/null \
	    || { echo "FAIL: lean_fs_arena_alloc not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_arena_free$$' >/dev/null \
	    || { echo "FAIL: lean_fs_arena_free not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_arena_smoke$$' >/dev/null \
	    || { echo "FAIL: lean_fs_arena_smoke not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_log_open$$' >/dev/null \
	    || { echo "FAIL: lean_fs_log_open not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_log_put$$' >/dev/null \
	    || { echo "FAIL: lean_fs_log_put not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_log_get$$' >/dev/null \
	    || { echo "FAIL: lean_fs_log_get not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_log_sync$$' >/dev/null \
	    || { echo "FAIL: lean_fs_log_sync not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_log_close$$' >/dev/null \
	    || { echo "FAIL: lean_fs_log_close not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_log_smoke$$' >/dev/null \
	    || { echo "FAIL: lean_fs_log_smoke not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mmap$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mmap not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_munmap$$' >/dev/null \
	    || { echo "FAIL: lean_fs_munmap not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_msync$$' >/dev/null \
	    || { echo "FAIL: lean_fs_msync not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ftruncate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ftruncate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mmap_smoke$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mmap_smoke not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mmap_close_live$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mmap_close_live not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mem_eq$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mem_eq not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mem_copy$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mem_copy not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mem_fill$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mem_fill not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mem_xor_fold$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mem_xor_fold not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u32_sat_add$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u32_sat_add not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u32_sat_sub$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u32_sat_sub not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_status_normalize$$' >/dev/null \
	    || { echo "FAIL: lean_fs_status_normalize not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_status_and_then$$' >/dev/null \
	    || { echo "FAIL: lean_fs_status_and_then not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mem_find_u8$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mem_find_u8 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u32_rotate_left$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u32_rotate_left not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u32_rotate_right$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u32_rotate_right not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u32_clamp$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u32_clamp not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_status_or_else$$' >/dev/null \
	    || { echo "FAIL: lean_fs_status_or_else not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mem_move$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mem_move not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_hash_bytes$$' >/dev/null \
	    || { echo "FAIL: lean_fs_hash_bytes not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u32_popcount$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u32_popcount not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_par_map_fold$$' >/dev/null \
	    || { echo "FAIL: lean_fs_par_map_fold not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_par_fork_join$$' >/dev/null \
	    || { echo "FAIL: lean_fs_par_fork_join not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_par_chan_ping$$' >/dev/null \
	    || { echo "FAIL: lean_fs_par_chan_ping not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u64_sat_add$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u64_sat_add not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u64_sat_sub$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u64_sat_sub not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u64_rotate_left$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u64_rotate_left not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u64_rotate_right$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u64_rotate_right not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_u64_clamp$$' >/dev/null \
	    || { echo "FAIL: lean_fs_u64_clamp not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_usize_sat_add$$' >/dev/null \
	    || { echo "FAIL: lean_fs_usize_sat_add not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_usize_clamp$$' >/dev/null \
	    || { echo "FAIL: lean_fs_usize_clamp not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_map_erase$$' >/dev/null \
	    || { echo "FAIL: lean_fs_map_erase not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_map_rehash$$' >/dev/null \
	    || { echo "FAIL: lean_fs_map_rehash not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_map_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_map_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_truncate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_truncate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_test_bit$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_test_bit not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_set_bit$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_set_bit not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_clear_bit$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_clear_bit not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_popcount$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_popcount not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_concat$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_concat not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_get_msb$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_get_msb not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_rotate_left$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_rotate_left not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_rotate_right$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_rotate_right not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_sign_extend$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_sign_extend not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bv_extract_lsb$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bv_extract_lsb not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_span_subspan_ok$$' >/dev/null \
	    || { echo "FAIL: lean_fs_span_subspan_ok not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_span_subspan_addr$$' >/dev/null \
	    || { echo "FAIL: lean_fs_span_subspan_addr not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_span_subspan_len$$' >/dev/null \
	    || { echo "FAIL: lean_fs_span_subspan_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_set_init$$' >/dev/null \
	    || { echo "FAIL: lean_fs_set_init not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_set_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_set_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_set_contains$$' >/dev/null \
	    || { echo "FAIL: lean_fs_set_contains not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_set_erase$$' >/dev/null \
	    || { echo "FAIL: lean_fs_set_erase not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_set_rehash$$' >/dev/null \
	    || { echo "FAIL: lean_fs_set_rehash not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_set_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_set_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_queue_is_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_queue_is_empty not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_queue_is_full$$' >/dev/null \
	    || { echo "FAIL: lean_fs_queue_is_full not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_queue_next_head$$' >/dev/null \
	    || { echo "FAIL: lean_fs_queue_next_head not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_queue_push$$' >/dev/null \
	    || { echo "FAIL: lean_fs_queue_push not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_queue_pop$$' >/dev/null \
	    || { echo "FAIL: lean_fs_queue_pop not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_queue_peek$$' >/dev/null \
	    || { echo "FAIL: lean_fs_queue_peek not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_len$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_cap$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_cap not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_is_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_is_empty not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_is_full$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_is_full not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_push$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_push not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_pop$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_pop not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_get$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_get not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_set$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_set not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vec_clear$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vec_clear not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sort_u32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sort_u32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sort_is_sorted_u32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sort_is_sorted_u32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_crc32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_crc32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_len$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_is_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_is_empty not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_get_u8$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_get_u8 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_eq$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_eq not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_prefix_eq$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_prefix_eq not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_hash32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_hash32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_view_ok$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_view_ok not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_view_addr$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_view_addr not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_str_view_len$$' >/dev/null \
	    || { echo "FAIL: lean_fs_str_view_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bsearch_u32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bsearch_u32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bsearch_contains_u32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bsearch_contains_u32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_is_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_is_empty not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_is_full$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_is_full not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_next_head$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_next_head not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_prev_head$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_prev_head not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_push_back$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_push_back not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_push_front$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_push_front not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_pop_front$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_pop_front not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_peek_front$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_peek_front not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_pop_back$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_pop_back not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_deque_peek_back$$' >/dev/null \
	    || { echo "FAIL: lean_fs_deque_peek_back not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stack_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stack_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stack_cap$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stack_cap not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stack_is_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stack_is_empty not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stack_is_full$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stack_is_full not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stack_push$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stack_push not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stack_pop$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stack_pop not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stack_peek$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stack_peek not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ascii_is_digit$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ascii_is_digit not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ascii_is_alpha$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ascii_is_alpha not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ascii_is_alnum$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ascii_is_alnum not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ascii_is_space$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ascii_is_space not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ascii_is_hex$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ascii_is_hex not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ascii_to_lower$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ascii_to_lower not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ascii_to_upper$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ascii_to_upper not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_contains$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_contains not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_sub_ok$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_sub_ok not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_sub_addr$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_sub_addr not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_sub_len$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_sub_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_load_u8$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_load_u8 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_store_u8$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_store_u8 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_load_u32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_load_u32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_store_u32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_store_u32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_region_overlaps$$' >/dev/null \
	    || { echo "FAIL: lean_fs_region_overlaps not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_empty not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_is_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_is_empty not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_test$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_test not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_set$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_set not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_clear$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_clear not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_and$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_and not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_or$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_or not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bitset_xor$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bitset_xor not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_parse_u32_status$$' >/dev/null \
	    || { echo "FAIL: lean_fs_parse_u32_status not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_parse_u32$$' >/dev/null \
	    || { echo "FAIL: lean_fs_parse_u32 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_parse_u64_status$$' >/dev/null \
	    || { echo "FAIL: lean_fs_parse_u64_status not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_parse_u64$$' >/dev/null \
	    || { echo "FAIL: lean_fs_parse_u64 not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ring_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ring_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ring_is_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ring_is_empty not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ring_is_full$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ring_is_full not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ring_next_head$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ring_next_head not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ring_push$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ring_push not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ring_pop$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ring_pop not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ring_peek$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ring_peek not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_dns_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_dns_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_dns_label_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_dns_label_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sexp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sexp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sexp_max_depth$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sexp_max_depth not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_avl_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_avl_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_avl_get$$' >/dev/null \
	    || { echo "FAIL: lean_fs_avl_get not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_md_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_md_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_md_find_heading$$' >/dev/null \
	    || { echo "FAIL: lean_fs_md_find_heading not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_icmp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_icmp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_icmp_type$$' >/dev/null \
	    || { echo "FAIL: lean_fs_icmp_type not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_rbtree_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_rbtree_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_rbtree_get$$' >/dev/null \
	    || { echo "FAIL: lean_fs_rbtree_get not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_pem_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_pem_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_pem_find_label$$' >/dev/null \
	    || { echo "FAIL: lean_fs_pem_find_label not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ntp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ntp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ntp_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ntp_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_trie_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_trie_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_trie_get$$' >/dev/null \
	    || { echo "FAIL: lean_fs_trie_get not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_jwt_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_jwt_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_jwt_part_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_jwt_part_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_dhcp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_dhcp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_dhcp_xid$$' >/dev/null \
	    || { echo "FAIL: lean_fs_dhcp_xid not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_heap_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_heap_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_heap_extract_min$$' >/dev/null \
	    || { echo "FAIL: lean_fs_heap_extract_min not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_uuid_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_uuid_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_uuid_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_uuid_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_arp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_arp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_arp_oper$$' >/dev/null \
	    || { echo "FAIL: lean_fs_arp_oper not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_interval_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_interval_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_interval_contains$$' >/dev/null \
	    || { echo "FAIL: lean_fs_interval_contains not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_semver_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_semver_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_semver_major$$' >/dev/null \
	    || { echo "FAIL: lean_fs_semver_major not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_gre_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_gre_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_gre_protocol$$' >/dev/null \
	    || { echo "FAIL: lean_fs_gre_protocol not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_splay_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_splay_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_splay_remove$$' >/dev/null \
	    || { echo "FAIL: lean_fs_splay_remove not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_cbor_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_cbor_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_cbor_uint_small$$' >/dev/null \
	    || { echo "FAIL: lean_fs_cbor_uint_small not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ip_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ip_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ip_protocol$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ip_protocol not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_btreemap_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_btreemap_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_btreemap_remove$$' >/dev/null \
	    || { echo "FAIL: lean_fs_btreemap_remove not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlq_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlq_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlq_find_key$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlq_find_key not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_udp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_udp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_udp_src_port$$' >/dev/null \
	    || { echo "FAIL: lean_fs_udp_src_port not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_skipmap_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_skipmap_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_skipmap_remove$$' >/dev/null \
	    || { echo "FAIL: lean_fs_skipmap_remove not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_edn_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_edn_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_edn_max_depth$$' >/dev/null \
	    || { echo "FAIL: lean_fs_edn_max_depth not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tcp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tcp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tcp_src_port$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tcp_src_port not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_hashmap_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_hashmap_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_hashmap_remove$$' >/dev/null \
	    || { echo "FAIL: lean_fs_hashmap_remove not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_msgpack_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_msgpack_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_msgpack_pos_int_small$$' >/dev/null \
	    || { echo "FAIL: lean_fs_msgpack_pos_int_small not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_icmpv6_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_icmpv6_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_icmpv6_type$$' >/dev/null \
	    || { echo "FAIL: lean_fs_icmpv6_type not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_lhm_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_lhm_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_lhm_remove$$' >/dev/null \
	    || { echo "FAIL: lean_fs_lhm_remove not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_pb_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_pb_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_pb_varint_small$$' >/dev/null \
	    || { echo "FAIL: lean_fs_pb_varint_small not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sctp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sctp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sctp_vtag$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sctp_vtag not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ordmap_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ordmap_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ordmap_remove$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ordmap_remove not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_avro_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_avro_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_avro_zigzag_nonneg_small$$' >/dev/null \
	    || { echo "FAIL: lean_fs_avro_zigzag_nonneg_small not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_dccp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_dccp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_dccp_type$$' >/dev/null \
	    || { echo "FAIL: lean_fs_dccp_type not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_treemap_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_treemap_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_treemap_remove$$' >/dev/null \
	    || { echo "FAIL: lean_fs_treemap_remove not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_capnp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_capnp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_capnp_offset_words_small$$' >/dev/null \
	    || { echo "FAIL: lean_fs_capnp_offset_words_small not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_quic_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_quic_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_quic_type$$' >/dev/null \
	    || { echo "FAIL: lean_fs_quic_type not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_flatbuffers_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_flatbuffers_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_flatbuffers_vtable_offset_at$$' >/dev/null \
	    || { echo "FAIL: lean_fs_flatbuffers_vtable_offset_at not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mqtt_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mqtt_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mqtt_type$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mqtt_type not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_radixtree_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_radixtree_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_radixtree_remove$$' >/dev/null \
	    || { echo "FAIL: lean_fs_radixtree_remove not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_asn1_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_asn1_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_asn1_content_start$$' >/dev/null \
	    || { echo "FAIL: lean_fs_asn1_content_start not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_coap_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_coap_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_coap_msg_id$$' >/dev/null \
	    || { echo "FAIL: lean_fs_coap_msg_id not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_lz4_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_lz4_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_lz4_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_lz4_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_socks5_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_socks5_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_socks5_atyp$$' >/dev/null \
	    || { echo "FAIL: lean_fs_socks5_atyp not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_snappy_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_snappy_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_snappy_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_snappy_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_rtsp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_rtsp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_rtsp_has_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_rtsp_has_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_zstd_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_zstd_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_zstd_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_zstd_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sip_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sip_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sip_has_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sip_has_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_brotli_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_brotli_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_brotli_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_brotli_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ntpquery_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ntpquery_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ntpquery_is_client_query$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ntpquery_is_client_query not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ogg_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ogg_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ogg_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ogg_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_smtp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_smtp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_smtp_is_reply$$' >/dev/null \
	    || { echo "FAIL: lean_fs_smtp_is_reply not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bsmulti_set$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bsmulti_set not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_bsmulti_test$$' >/dev/null \
	    || { echo "FAIL: lean_fs_bsmulti_test not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_webm_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_webm_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_webm_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_webm_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_pop3_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_pop3_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_pop3_is_ok$$' >/dev/null \
	    || { echo "FAIL: lean_fs_pop3_is_ok not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_roaring_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_roaring_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_roaring_contains$$' >/dev/null \
	    || { echo "FAIL: lean_fs_roaring_contains not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_matroska_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_matroska_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_matroska_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_matroska_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_imap_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_imap_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_imap_is_ok$$' >/dev/null \
	    || { echo "FAIL: lean_fs_imap_is_ok not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_intervalset_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_intervalset_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_intervalset_contains$$' >/dev/null \
	    || { echo "FAIL: lean_fs_intervalset_contains not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_flac_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_flac_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_flac_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_flac_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_nntp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_nntp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_nntp_code$$' >/dev/null \
	    || { echo "FAIL: lean_fs_nntp_code not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ldap_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ldap_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ldap_message_id$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ldap_message_id not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vorbis_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vorbis_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_vorbis_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_vorbis_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_radius_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_radius_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_radius_code$$' >/dev/null \
	    || { echo "FAIL: lean_fs_radius_code not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_orderedset_insert$$' >/dev/null \
	    || { echo "FAIL: lean_fs_orderedset_insert not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_orderedset_contains$$' >/dev/null \
	    || { echo "FAIL: lean_fs_orderedset_contains not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_diameter_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_diameter_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_diameter_command_code$$' >/dev/null \
	    || { echo "FAIL: lean_fs_diameter_command_code not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sctpcommon_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sctpcommon_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sctpcommon_vtag$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sctpcommon_vtag not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_m3ua_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_m3ua_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_m3ua_length$$' >/dev/null \
	    || { echo "FAIL: lean_fs_m3ua_length not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sua_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sua_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sua_length$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sua_length not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_iua_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_iua_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_iua_length$$' >/dev/null \
	    || { echo "FAIL: lean_fs_iua_length not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_v5ua_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_v5ua_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_v5ua_length$$' >/dev/null \
	    || { echo "FAIL: lean_fs_v5ua_length not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_h248_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_h248_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_h248_length$$' >/dev/null \
	    || { echo "FAIL: lean_fs_h248_length not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_megaco_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_megaco_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_megaco_length$$' >/dev/null \
	    || { echo "FAIL: lean_fs_megaco_length not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mgcp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mgcp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_mgcp_method$$' >/dev/null \
	    || { echo "FAIL: lean_fs_mgcp_method not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sdp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sdp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_sdp_method$$' >/dev/null \
	    || { echo "FAIL: lean_fs_sdp_method not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_rtcp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_rtcp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_rtcp_length$$' >/dev/null \
	    || { echo "FAIL: lean_fs_rtcp_length not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stun_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stun_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_stun_method$$' >/dev/null \
	    || { echo "FAIL: lean_fs_stun_method not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_turn_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_turn_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_turn_method$$' >/dev/null \
	    || { echo "FAIL: lean_fs_turn_method not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ice_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ice_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ice_method$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ice_method not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_rtp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_rtp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_rtp_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_rtp_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_srtp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_srtp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_srtp_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_srtp_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_srtcp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_srtcp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_srtcp_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_srtcp_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_dtls_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_dtls_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_dtls_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_dtls_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tls_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tls_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tls_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tls_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ipsec_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ipsec_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ipsec_spi$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ipsec_spi not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_proc_spawn$$' >/dev/null \
	    || { echo "FAIL: lean_fs_proc_spawn not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_proc_spawn_argv$$' >/dev/null \
	    || { echo "FAIL: lean_fs_proc_spawn_argv not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_proc_pipe$$' >/dev/null \
	    || { echo "FAIL: lean_fs_proc_pipe not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_proc_spawn_argv_pipe$$' >/dev/null \
	    || { echo "FAIL: lean_fs_proc_spawn_argv_pipe not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_proc_close_raw$$' >/dev/null \
	    || { echo "FAIL: lean_fs_proc_close_raw not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_proc_wait$$' >/dev/null \
	    || { echo "FAIL: lean_fs_proc_wait not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_proc_pid_is_neg$$' >/dev/null \
	    || { echo "FAIL: lean_fs_proc_pid_is_neg not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_manifest_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_manifest_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_manifest_has_url$$' >/dev/null \
	    || { echo "FAIL: lean_fs_manifest_has_url not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_cacheindex_put$$' >/dev/null \
	    || { echo "FAIL: lean_fs_cacheindex_put not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_cacheindex_contains$$' >/dev/null \
	    || { echo "FAIL: lean_fs_cacheindex_contains not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_l2tp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_l2tp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_l2tp_tunnel_id$$' >/dev/null \
	    || { echo "FAIL: lean_fs_l2tp_tunnel_id not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_lean_exe_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_lean_exe_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_default_targets_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_default_targets_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_src_dir$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_src_dir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_src_dir_off$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_src_dir_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_src_dir_len$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_src_dir_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_version_off$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_version_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_build_type$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_build_type not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_require_path_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_require_path_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_require_path_scoped_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_require_path_scoped_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_default_targets$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_default_targets not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_more_lean_args_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_more_lean_args_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_backend$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_backend not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_test_driver$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_test_driver not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lint_driver$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_lint_driver not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_weak_lean_args_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_weak_lean_args_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_lean_lib_name_off$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_first_lean_lib_name_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_lean_lib_name_len$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_first_lean_lib_name_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_pptp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_pptp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_pptp_has_magic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_pptp_has_magic not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_l2f_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_l2f_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_l2f_protocol$$' >/dev/null \
	    || { echo "FAIL: lean_fs_l2f_protocol not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ppp_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ppp_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_ppp_protocol$$' >/dev/null \
	    || { echo "FAIL: lean_fs_ppp_protocol not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_hdlc_validate$$' >/dev/null \
	    || { echo "FAIL: lean_fs_hdlc_validate not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_hdlc_has_open_flag$$' >/dev/null \
	    || { echo "FAIL: lean_fs_hdlc_has_open_flag not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_platform_independent$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_platform_independent not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_prefer_release_build$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_prefer_release_build not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_lean_args_count$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_lean_args_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_lean_exe_name_off$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_first_lean_exe_name_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_lean_exe_name_len$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_first_lean_exe_name_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_more_link_args_count$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_more_link_args_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_build_archive$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_build_archive not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_support_interpreter$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_support_interpreter not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_name_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_name_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_name_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_name_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_weak_link_args_count$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_weak_link_args_count not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_enable_artifact_cache$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_enable_artifact_cache not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_precompile_modules$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_precompile_modules not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_lean_lib_root_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_lean_lib_root_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_lean_lib_root_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_lean_lib_root_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_packages_dir$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_packages_dir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_reservoir$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_reservoir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_lean_exe_root_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_lean_exe_root_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_lean_exe_root_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_lean_exe_root_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_build_dir$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_build_dir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_wrappers_dir$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_wrappers_dir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_path_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_path_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_path_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_path_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_native_lib_dir$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_native_lib_dir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_test_driver_args$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_test_driver_args not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_rev_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_rev_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_rev_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_rev_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lint_driver_args$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_lint_driver_args not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_more_link_args$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_more_link_args not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_git_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_git_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_git_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_git_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lean_options$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_lean_options not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_more_server_options$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_more_server_options not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_url_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_url_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_url_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_url_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_manifest$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_manifest not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_version_tags$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_version_tags not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_version_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_version_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_version_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_version_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_description$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_description not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_keywords$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_keywords not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_scope_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_scope_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_scope_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_scope_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_homepage$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_homepage not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_license$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_license not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_subdir_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_subdir_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_subdir_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_subdir_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_readme_file$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_readme_file not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_license_files$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_license_files not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_opts_off$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_opts_off not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_first_require_opts_len$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_first_require_opts_len not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_bootstrap$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_bootstrap not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_more_server_args$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_more_server_args not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_release_repo$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_release_repo not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lean_lib_dir$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_lean_lib_dir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_bin_dir$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_bin_dir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_ir_dir$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_ir_dir not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_extra_dep_targets$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_extra_dep_targets not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_restore_all_artifacts$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_restore_all_artifacts not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lib_prefix_on_windows$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_lib_prefix_on_windows not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_allow_import_all$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_allow_import_all not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_fixed_toolchain$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_fixed_toolchain not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_version$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_version not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_builtin_lint$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_builtin_lint not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_more_leanc_args$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_more_leanc_args not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_allow_non_modules$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_allow_non_modules not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_requires_module_system$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_requires_module_system not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_weak_leanc_args$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_weak_leanc_args not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_more_link_objs$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_more_link_objs not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_more_link_libs$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_more_link_libs not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_dynlibs$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_dynlibs not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_plugins$$' >/dev/null \
	  || { echo "FAIL: lean_fs_tomlcfg_has_plugins not defined (T) in archive"; echo "$$defs"; exit 1; }; \
	  bad_other=$$(echo "$$undef" | grep -E '[[:space:]]U[[:space:]]+' | grep -Ev '[[:space:]]U[[:space:]]+(open|close|read|write|malloc|calloc|free|memset|fsync|lseek|mmap|munmap|msync|ftruncate|fork|execve|_exit|waitpid|pipe|dup2|fcntl|syscall|__stack_chk_fail|lp_systems_)' || true); \
	  if [ -n "$$bad_other" ]; then \
	    echo "FAIL: unexpected non-libc undefs (libc allowlist + lp_systems_* in freestanding.bundle):"; echo "$$bad_other"; exit 1; \
	  fi; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lp_systems_.*checksumGo' >/dev/null \
	    || { echo "FAIL: expected T checksumGo in freestanding.bundle"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lp_systems_.*logGet' >/dev/null \
	    || { echo "FAIL: expected T logGet in freestanding.bundle"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lp_systems_.*logPut' >/dev/null \
	    || { echo "FAIL: expected T logPut in freestanding.bundle"; exit 1; }; \
	  missing_t=$$(echo "$$undef" | grep -oE 'lp_systems_[A-Za-z0-9_]+' | sort -u | while read -r s; do \
	    echo "$$defs" | grep -E "[[:space:]]T[[:space:]]+$$s$$" >/dev/null || echo "$$s"; \
	  done); \
	  if [ -n "$$missing_t" ]; then \
	    echo "FAIL: U lp_systems_* without matching T in freestanding.bundle:"; echo "$$missing_t"; exit 1; \
	  fi; \
	  echo "OK: no U lean_*/l_*; libc U + lp_systems_* (each U has T in freestanding.bundle); defined T lean_fs_* helpers"; \
	else \
	  echo "nm not found; skip"; \
	fi
# Dynamic deps of the consumer binary: no Lean shared libs

	@# W88 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like first shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W88 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W88 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_default_facets$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_default_facets not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_more_global_server_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_more_global_server_args not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lib_name$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_lib_name not defined (T) in archive"; exit 1; }; \
	echo "OK: W88 T-pins"; \
	fi
	@# W89 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like first shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W89 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W89 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_scope$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_scope not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_remote_url$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_remote_url not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_weak_lean_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_weak_lean_args not defined (T) in archive"; exit 1; }; \
	echo "OK: W89 T-pins"; \
	fi
	@# W90 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like first shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W90 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W90 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_freestanding$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_freestanding not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_roots$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_roots not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_globs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_globs not defined (T) in archive"; exit 1; }; \
	echo "OK: W90 T-pins"; \
	fi
	@# W91 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like first shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W91 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W91 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_needs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_needs not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_weak_link_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_weak_link_args not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_exe_name$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_exe_name not defined (T) in archive"; exit 1; }; \
	echo "OK: W91 T-pins"; \
	fi
	@# W92 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W91 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W92 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W92 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_more_lean_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_more_lean_args not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_native_facets$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_native_facets not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_root$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_root not defined (T) in archive"; exit 1; }; \
	echo "OK: W92 T-pins"; \
	fi
	@# W93 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W92 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W93 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W93 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_name$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_name not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lean_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_lean_args not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_test_runner$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_test_runner not defined (T) in archive"; exit 1; }; \
	echo "OK: W93 T-pins"; \
	fi
	@# W94 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W93 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W94 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W94 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_server_options$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_server_options not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_leanc_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_leanc_args not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_base_name$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_base_name not defined (T) in archive"; exit 1; }; \
	echo "OK: W94 T-pins"; \
	fi
	@# W95 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W94 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W95 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W95 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_link_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_link_args not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_server_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_server_args not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_global_server_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_global_server_args not defined (T) in archive"; exit 1; }; \
	echo "OK: W95 T-pins"; \
	fi
	@# W96 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W95 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W96 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W96 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_link_objs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_link_objs not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_link_libs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_link_libs not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_options$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_options not defined (T) in archive"; exit 1; }; \
	echo "OK: W96 T-pins"; \
	fi
	@# W97 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W96 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W97 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W97 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_git$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_git not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_path$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_path not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_rev$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_rev not defined (T) in archive"; exit 1; }; \
	echo "OK: W97 T-pins"; \
	fi
	@# W98 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W97 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W98 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W98 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_sub_dir$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_sub_dir not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_url$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_url not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_opts$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_opts not defined (T) in archive"; exit 1; }; \
	echo "OK: W98 T-pins"; \
	fi
	@# W99 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W98 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W99 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W99 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_type$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_type not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_dir$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_dir not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_source$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_source not defined (T) in archive"; exit 1; }; \
	echo "OK: W99 T-pins"; \
	fi
	@# W100 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W98 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W100 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W100 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_kind$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_kind not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_preset$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_preset not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_extension$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_extension not defined (T) in archive"; exit 1; }; \
	echo "OK: W100 T-pins"; \
	fi
	@# W101 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W100 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W101 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W101 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_filter$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_filter not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_text$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_text not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_file_name$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_file_name not defined (T) in archive"; exit 1; }; \
	echo "OK: W101 T-pins"; \
	fi
	@# W102 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W101 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W102 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W102 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_starts_with$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_starts_with not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_ends_with$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_ends_with not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_not$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_not not defined (T) in archive"; exit 1; }; \
	echo "OK: W102 T-pins"; \
	fi
	@# W103 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W102 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W103 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W103 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_any$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_any not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_all$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_all not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_api_endpoint$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_api_endpoint not defined (T) in archive"; exit 1; }; \
	echo "OK: W103 T-pins"; \
	fi
	@# W104 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W103 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W104 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W104 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_artifact_endpoint$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_artifact_endpoint not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_revision_endpoint$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_revision_endpoint not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_default_service$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_default_service not defined (T) in archive"; exit 1; }; \
	echo "OK: W104 T-pins"; \
	fi
	@# W105 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W104 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W105 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W105 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_service$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_service not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_repo$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_repo not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_schema_version$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_schema_version not defined (T) in archive"; exit 1; }; \
	echo "OK: W105 T-pins"; \
	fi
	@# W106 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W105 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W106 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W106 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_data$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_data not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_manifest_file$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_manifest_file not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lake_dir$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_lake_dir not defined (T) in archive"; exit 1; }; \
	echo "OK: W106 T-pins"; \
	fi
	@# W107 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W105 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W107 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W107 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_config_file$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_config_file not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_input_rev$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_input_rev not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_packages$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_packages not defined (T) in archive"; exit 1; }; \
	echo "OK: W107 T-pins"; \
	fi
# W108 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W107 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W108 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W108 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_inherited$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_inherited not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_git_url$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_git_url not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_full_name$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_full_name not defined (T) in archive"; exit 1; }; \
	echo "OK: W108 T-pins"; \
	fi
# W109 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W108 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W109 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W109 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_default_branch$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_default_branch not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_repo_url$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_repo_url not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_sources$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_sources not defined (T) in archive"; exit 1; }; \
	echo "OK: W109 T-pins"; \
	fi
# W110 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W109 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W110 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W110 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_revision$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_revision not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_host$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_host not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_hash$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_hash not defined (T) in archive"; exit 1; }; \
	echo "OK: W110 T-pins"; \
	fi
# W111 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W110 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W111 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W111 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_dephash$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_dephash not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_file$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_file not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_inputs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_inputs not defined (T) in archive"; exit 1; }; \
	echo "OK: W111 T-pins"; \
	fi
# W112 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W110 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W112 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W112 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_outputs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_outputs not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_status$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_status not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_log$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_log not defined (T) in archive"; exit 1; }; \
	echo "OK: W112 T-pins"; \
	fi
# W113 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W112 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W113 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W113 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_synthetic$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_synthetic not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_message$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_message not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_error$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_error not defined (T) in archive"; exit 1; }; \
	echo "OK: W113 T-pins"; \
	fi
# W114 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W113 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W114 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W114 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_http_code$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_http_code not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_response_code$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_response_code not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_errormsg$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_errormsg not defined (T) in archive"; exit 1; }; \
	echo "OK: W114 T-pins"; \
	fi
	# W115 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W114 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W115 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W115 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_content_type$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_content_type not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_urlnum$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_urlnum not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_size_download$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_size_download not defined (T) in archive"; exit 1; }; \
	echo "OK: W115 T-pins"; \
	fi
	# W116 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W115 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W116 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W116 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_rs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_rs not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_o$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_o not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_i$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_i not defined (T) in archive"; exit 1; }; \
	echo "OK: W116 T-pins"; \
	fi
	# W117 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W116 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W117 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W117 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_m$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_m not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_c$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_c not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_b$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_b not defined (T) in archive"; exit 1; }; \
	echo "OK: W117 T-pins"; \
	fi
	# W118 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W117 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W118 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W118 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_l$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_l not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_r$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_r not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_require$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_require not defined (T) in archive"; exit 1; }; \
	echo "OK: W118 T-pins"; \
	fi
	# W119 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W118 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W119 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W119 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_value$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_value not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_major$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_major not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_minor$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_minor not defined (T) in archive"; exit 1; }; \
	echo "OK: W119 T-pins"; \
	fi
	# W120 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W119 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W120 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W120 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_art$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_art not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_olean$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_olean not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_ltar$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_ltar not defined (T) in archive"; exit 1; }; \
	echo "OK: W120 T-pins"; \
	fi
	# W121 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W120 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W121 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W121 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_ir$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_ir not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_trace_args$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_trace_args not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_debug_assertions$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_debug_assertions not defined (T) in archive"; exit 1; }; \
	echo "OK: W121 T-pins"; \
	fi
	# W122 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W121 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W122 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W122 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_ver_like$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_ver_like not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_mappings$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_mappings not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_default$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_default not defined (T) in archive"; exit 1; }; \
	echo "OK: W122 T-pins"; \
	fi
	# W123 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W122 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W123 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W123 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_objs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_objs not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_cache$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_cache not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_script$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_script not defined (T) in archive"; exit 1; }; \
	echo "OK: W123 T-pins"; \
	fi
	# W124 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W123 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W124 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W124 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_ext$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_ext not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lean$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_lean not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_toml$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_toml not defined (T) in archive"; exit 1; }; \
	echo "OK: W124 T-pins"; \
	fi
	# W125 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W124 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W125 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W125 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_env$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_env not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_help$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_help not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_cc$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_cc not defined (T) in archive"; exit 1; }; \
	echo "OK: W125 T-pins"; \
	fi
	# W126 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W125 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W126 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W126 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_info$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_info not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_remote$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_remote not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_facets$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_facets not defined (T) in archive"; exit 1; }; \
	echo "OK: W126 T-pins"; \
	fi
	# W127 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W126 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W127 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W127 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_package$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_package not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_module$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_module not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_build$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_build not defined (T) in archive"; exit 1; }; \
	echo "OK: W127 T-pins"; \
	fi
	# W128 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W127 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W128 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W128 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_clean$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_clean not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_test$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_test not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_serve$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_serve not defined (T) in archive"; exit 1; }; \
	echo "OK: W128 T-pins"; \
	fi
	# W129 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W128 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W129 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W129 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lint$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_lint not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_exe$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_exe not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_query$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_query not defined (T) in archive"; exit 1; }; \
	echo "OK: W129 T-pins"; \
	fi
# W130 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W129 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W130 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W130 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_init$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_init not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_new$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_new not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_update$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_update not defined (T) in archive"; exit 1; }; \
	echo "OK: W130 T-pins"; \
	fi
# W131 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W130 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W131 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W131 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_pack$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_pack not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_unpack$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_unpack not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_upload$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_upload not defined (T) in archive"; exit 1; }; \
	echo "OK: W131 T-pins"; \
	fi
# W132 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W131 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W132 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W132 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_shake$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_shake not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_run$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_run not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_scripts$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_scripts not defined (T) in archive"; exit 1; }; \
	echo "OK: W132 T-pins"; \
	fi
# W133 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W132 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W133 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W133 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_get$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_get not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_put$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_put not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_add$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_add not defined (T) in archive"; exit 1; }; \
	echo "OK: W133 T-pins"; \
	fi
# W134 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W133 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W134 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W134 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_list$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_list not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_doc$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_doc not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_stage$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_stage not defined (T) in archive"; exit 1; }; \
	echo "OK: W134 T-pins"; \
	fi
# W135 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W134 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W135 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W135 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_exec$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_exec not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_unstage$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_unstage not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_put_staged$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_put_staged not defined (T) in archive"; exit 1; }; \
	echo "OK: W135 T-pins"; \
	fi
# W136 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W135 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W136 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W136 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_check_build$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_check_build not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_check_lint$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_check_lint not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_check_test$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_check_test not defined (T) in archive"; exit 1; }; \
	echo "OK: W136 T-pins"; \
	fi
# W137 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W136 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W138 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W138 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_query_kind$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_query_kind not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_setup_file$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_setup_file not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_self_check$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_self_check not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_translate_config$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_translate_config not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_resolve_deps$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_resolve_deps not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_services$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_services not defined (T) in archive"; exit 1; }; \
	echo "OK: W138 T-pins"; \
	fi
# W139 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W138 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W139 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W139 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_reservoir_config$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_reservoir_config not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_version_tags_cli$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_version_tags_cli not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_upgrade$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_upgrade not defined (T) in archive"; exit 1; }; \
	echo "OK: W139 T-pins"; \
	fi
# W140 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W139 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W140 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W140 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_no_build$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_no_build not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_no_cache$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_no_cache not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_try_cache$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_try_cache not defined (T) in archive"; exit 1; }; \
	echo "OK: W140 T-pins"; \
	fi
# W141 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W140 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W141 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W141 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_force_download$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_force_download not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_download_arts$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_download_arts not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_mappings_only$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_mappings_only not defined (T) in archive"; exit 1; }; \
	echo "OK: W141 T-pins"; \
	fi
# W142 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W141 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W142 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W142 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_no_overwrite$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_no_overwrite not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_force_overwrite$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_force_overwrite not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_rehash$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_rehash not defined (T) in archive"; exit 1; }; \
	echo "OK: W142 T-pins"; \
	fi
# W143 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W142 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W143 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W143 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_keep_implied$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_keep_implied not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_keep_prefix$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_keep_prefix not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_keep_public$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_keep_public not defined (T) in archive"; exit 1; }; \
	echo "OK: W143 T-pins"; \
	fi
# W144 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W143 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W144 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W144 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_add_public$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_add_public not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_gh_style$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_gh_style not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_explain$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_explain not defined (T) in archive"; exit 1; }; \
	echo "OK: W144 T-pins"; \
	fi
	@# W145 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W144 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W145 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W145 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_builtin_only$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_builtin_only not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_lint_only$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_lint_only not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_record_exceptions$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_record_exceptions not defined (T) in archive"; exit 1; }; \
	echo "OK: W145 T-pins"; \
	fi
	@# W146 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W145 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W146 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W146 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_keep_toolchain$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_keep_toolchain not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_allow_empty$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_allow_empty not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_max_revs$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_max_revs not defined (T) in archive"; exit 1; }; \
	echo "OK: W146 T-pins"; \
	fi
	@# W147 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W146 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W147 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W147 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_log_level$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_log_level not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_fail_level$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_fail_level not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_no_ansi$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_no_ansi not defined (T) in archive"; exit 1; }; \
	echo "OK: W147 T-pins"; \
	fi
	@# W148 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W147 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W148 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W148 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_reconfigure$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_reconfigure not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_quiet$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_quiet not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_verbose$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_verbose not defined (T) in archive"; exit 1; }; \
	echo "OK: W148 T-pins"; \
	fi
	@# W149 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W148 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W149 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W149 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_offline$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_offline not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_platform$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_platform not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_toolchain$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_toolchain not defined (T) in archive"; exit 1; }; \
	echo "OK: W149 T-pins"; \
	fi
	@# W150 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W149 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W150 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W150 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_wfail$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_wfail not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_iofail$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_iofail not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_ansi$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_ansi not defined (T) in archive"; exit 1; }; \
	echo "OK: W150 T-pins"; \
	fi
	@# W151 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W150 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W151 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W151 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_force$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_force not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_fix$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_fix not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_only$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_only not defined (T) in archive"; exit 1; }; \
	echo "OK: W151 T-pins"; \
	fi
	@# W152 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W151 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W152 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W152 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_trace$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_trace not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_old$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_old not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_json$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_json not defined (T) in archive"; exit 1; }; \
	echo "OK: W152 T-pins"; \
	fi
	@# W153 T-pins (separate shell - keeps check-nm under ARG_MAX; fail-closed like W152 shell)
	@if command -v nm >/dev/null 2>&1; then \
	  test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query Extract:freestanding.bundle (W153 T-pins)"; exit 1; }; \
	  test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE) (W153 T-pins)"; exit 1; }; \
	  defs=$$(nm "$(FS_BUNDLE)" 2>/dev/null || nm -g "$(FS_BUNDLE)" 2>/dev/null || true); \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_linters$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_linters not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_builtin_lint_cli$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_builtin_lint_cli not defined (T) in archive"; exit 1; }; \
	  echo "$$defs" | grep -E '[[:space:]]T[[:space:]]+lean_fs_tomlcfg_has_linter$$' >/dev/null \
	    || { echo "FAIL: lean_fs_tomlcfg_has_linter not defined (T) in archive"; exit 1; }; \
	echo "OK: W153 T-pins"; \
	fi

check-deps: run
	@echo "=== dynamic dependencies of consumer ==="
	@if command -v readelf >/dev/null 2>&1; then \
	  readelf -d $(OUT_DIR)/main; \
	  readelf -d $(OUT_DIR)/main | grep -E 'NEEDED.*(Init_shared|leanshared)' \
	    && { echo "FAIL: NEEDED Lean dynlib"; exit 1; } || echo "OK: no NEEDED Init_shared/leanshared*"; \
	elif command -v otool >/dev/null 2>&1; then \
	  otool -L $(OUT_DIR)/main; \
	  otool -L $(OUT_DIR)/main | grep -E 'Init_shared|leanshared' \
	    && { echo "FAIL: load Lean dynlib"; exit 1; } || echo "OK: no Init_shared/leanshared* loads"; \
	else \
	  echo "readelf/otool not found; skip"; \
	fi
	@echo "=== defined freestanding exports on consumer ==="
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_add || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_add
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_checksum || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_checksum
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_load_u8 || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_load_u8
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_write_all || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_write_all
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_arena_smoke || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_arena_smoke
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_log_smoke || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_log_smoke
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_log_sync || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_log_sync
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_mmap_smoke || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_mmap_smoke
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_mmap_close_live || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_mmap_close_live
	nm $(OUT_DIR)/main 2>/dev/null | grep lean_fs_msync || nm -g $(OUT_DIR)/main 2>/dev/null | grep lean_fs_msync

# Gate: forbidden lean_*/l_* inline patterns, lean_io_*, and affine/region fail tests
check-gates: lake
	@echo "=== freestanding gate: reject lean_* inline extern ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_inline_lean_runtime.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_inline_lean_runtime","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_inline_lean_runtime.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json 2>$$tmpdir/err; then \
	  echo "FAIL: expected freestanding emit error for lean_uint64_add inline"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -q 'forbidden Lean runtime\|allowlist\|freestanding emit' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: lean_* inline extern rejected at emit"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject embedded l_* in statement expr ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_inline_embedded_l_mangle.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_inline_embedded_l_mangle","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_inline_embedded_l_mangle.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json 2>$$tmpdir/err; then \
	  echo "FAIL: expected freestanding emit error for embedded l_* call"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -q 'forbidden Lean runtime\|allowlist\|freestanding emit' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: embedded l_* in ({...}) rejected at emit"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject lean_io_* standard extern ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_lean_io_extern.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_lean_io_extern","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_lean_io_extern.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json 2>$$tmpdir/err; then \
	  echo "FAIL: expected freestanding emit error for lean_io_*"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -q 'forbidden Lean runtime\|allowlist\|freestanding emit' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: lean_io_* standard extern rejected at emit"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject double-close (affine use-after-move) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_double_close.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_double_close","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_double_close.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected double-use / use-after-move for double-close"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DOUBLE)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: double-close rejected (double-use / use-after-move)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject silent drop of let-bound Fd ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_silent_drop.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_silent_drop","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_silent_drop.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected silent-drop error"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DROP)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: silent drop of let-bound Fd rejected"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject use-after-close (write after close) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_use_after_close.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_use_after_close","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_use_after_close.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected use-after-consume / use-after-move for write-after-close"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_AFTER)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: write-after-close rejected (use-after-consume / use-after-move)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject affine param ownership sink ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_affine_param_drop.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_affine_param_drop","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_affine_param_drop.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected silent-drop for ownership-sink param"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DROP)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: affine param ownership sink rejected (silent drop)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject arena UAF (use BytePtr after Arena.free) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_arena_uaf.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_arena_uaf","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_arena_uaf.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected use-after-free for arena UAF"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_UAF)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output (need use-after-free, not silent drop):"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: arena UAF rejected (region use-after-free)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject arena double-free ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_arena_double_free.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_arena_double_free","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_arena_double_free.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected double-use / use-after-move for arena double-free"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DOUBLE)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: arena double-free rejected (double-use / use-after-move)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject silent drop of Arena ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_arena_silent_drop.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_arena_silent_drop","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_arena_silent_drop.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected silent-drop for Arena"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DROP)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: silent drop of Arena rejected"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject MallocBuf double-free ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_buf_double_free.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_buf_double_free","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_buf_double_free.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected double-use / use-after-move for buf double-free"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DOUBLE)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: MallocBuf double-free rejected (double-use / use-after-move)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject silent drop of MallocBuf ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_buf_silent_drop.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_buf_silent_drop","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_buf_silent_drop.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected silent-drop for MallocBuf"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DROP)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: silent drop of MallocBuf rejected"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject free of derived BytePtr dropping Arena ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_arena_buf_free_derived.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_arena_buf_free_derived","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_arena_buf_free_derived.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected silent-drop of Arena after free of derived BytePtr"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DROP)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: free of derived BytePtr does not sink Arena ownership (silent drop of Arena)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject same-type @[fs_borrow] affine return (peek dual-own) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_fs_borrow_same_type.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_fs_borrow_same_type","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_fs_borrow_same_type.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected reject for same-type fs_borrow peek"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_BORROW)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: same-type @[fs_borrow] affine return rejected"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject log double-close (affine use-after-move) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_log_double_close.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_log_double_close","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_log_double_close.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected double-use / use-after-move for log double-close"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DOUBLE)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: log double-close rejected (double-use / use-after-move)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject silent drop of Log ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_log_silent_drop.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_log_silent_drop","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_log_silent_drop.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected silent-drop for Log"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DROP)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: silent drop of Log rejected"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject log use-after-close (put after close) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_log_use_after_close.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_log_use_after_close","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_log_use_after_close.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected use-after-consume / use-after-move for put-after-logClose"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_AFTER)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: log put-after-close rejected (use-after-consume / use-after-move)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject non-allowlisted libc (socket not on the list) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_non_allowlisted_socket.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_non_allowlisted_socket","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_non_allowlisted_socket.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected freestanding emit error for socket"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE 'forbidden Lean runtime|allowlist|freestanding emit' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: socket rejected (not on the libc allowlist)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject inline dlopen pattern ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_inline_dlopen.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_inline_dlopen","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_inline_dlopen.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected freestanding emit error for inline dlopen"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE 'forbidden Lean runtime|allowlist|freestanding emit' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: inline dlopen pattern rejected at emit"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject mmap double-unmap (affine use-after-move) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_mmap_double_unmap.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_mmap_double_unmap","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_mmap_double_unmap.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected double-use / use-after-move for double-unmap"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DOUBLE)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: mmap double-unmap rejected (double-use / use-after-move)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject silent drop of MMap ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_mmap_silent_drop.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_mmap_silent_drop","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_mmap_silent_drop.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected silent-drop for MMap"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_DROP)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: silent drop of MMap rejected"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: reject msync after munmap (use-after-move) ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_mmap_use_after_unmap.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_mmap_use_after_unmap","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_mmap_use_after_unmap.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected use-after-consume / use-after-move for msync-after-munmap"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_AFTER)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output:"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: msync-after-munmap rejected (use-after-consume / use-after-move)"; \
	rm -rf $$tmpdir
	@echo "=== freestanding gate: derived-region mmap (no fs_fresh_region) → UAF after close ==="
	@set -e; \
	tmpdir=$$(mktemp -d); \
	cp fail_mmap_derived_region.lean $$tmpdir/; \
	python3 -c 'import json,sys; print(json.dumps({"plugins":[],"package":"fs_gate","options":{"compiler.freestanding":True},"name":"fail_mmap_derived_region","isModule":True,"importArts":{},"dynlibs":[]}))' > $$tmpdir/setup.json; \
	if lean -Dcompiler.freestanding=true $$tmpdir/fail_mmap_derived_region.lean -c $$tmpdir/out.c --setup $$tmpdir/setup.json >$$tmpdir/err 2>&1; then \
	  echo "FAIL: expected use-after-free for close-then-msync without fs_fresh_region"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	if ! grep -qE '$(FS_ERR_UAF)' $$tmpdir/err; then \
	  echo "FAIL: unexpected error output (need use-after-free):"; cat $$tmpdir/err; rm -rf $$tmpdir; exit 1; \
	fi; \
	echo "OK: derived-region mmap after close rejected (use-after-free; fs_fresh_region load-bearing)"; \
	rm -rf $$tmpdir

# freestanding IR/C has dual scalar params, Sys/Arena/Log/MMap exports, no object product / lean_object / init / lean.h
# S8 multi-module + S9 Arena Lean bodies + S10 zero GNU stmt exprs: inspect Systems/*.c
SCALARS_C = lib/.lake/build/ir/Systems/Scalars.c
SYS_C = lib/.lake/build/ir/Systems/Sys.c
BYTES_C = lib/.lake/build/ir/Systems/Bytes.c
NUMERICS_C = lib/.lake/build/ir/Systems/Numerics.c
STATUS_C = lib/.lake/build/ir/Systems/Status.c
MEM_C = lib/.lake/build/ir/Systems/Mem.c
BITOPS_C = lib/.lake/build/ir/Systems/BitOps.c
HASH_C = lib/.lake/build/ir/Systems/Hash.c
SIMD_C = lib/.lake/build/ir/Systems/Parallelism/Simd.c
FORKJOIN_C = lib/.lake/build/ir/Systems/Parallelism/ForkJoin.c
CHANNEL_C = lib/.lake/build/ir/Systems/Parallelism/Channel.c
BYTESPAN_C = lib/.lake/build/ir/Systems/ByteSpan.c
MAP_C = lib/.lake/build/ir/Systems/Map.c
BITVEC_C = lib/.lake/build/ir/Systems/BitVec.c
SET_C = lib/.lake/build/ir/Systems/Set.c
QUEUE_C = lib/.lake/build/ir/Systems/Queue.c
VECTOR_C = lib/.lake/build/ir/Systems/Vector.c
SORT_C = lib/.lake/build/ir/Systems/Sort.c
CRC_C = lib/.lake/build/ir/Systems/Crc.c
STRING_C = lib/.lake/build/ir/Systems/String.c
BINARYSEARCH_C = lib/.lake/build/ir/Systems/BinarySearch.c
DEQUE_C = lib/.lake/build/ir/Systems/Deque.c
STACK_C = lib/.lake/build/ir/Systems/Stack.c
ASCII_C = lib/.lake/build/ir/Systems/Ascii.c
MEMREGION_C = lib/.lake/build/ir/Systems/MemRegion.c
BITSET_C = lib/.lake/build/ir/Systems/BitSet.c
PARSE_C = lib/.lake/build/ir/Systems/Parse.c
RINGBUF_C = lib/.lake/build/ir/Systems/RingBuf.c
FMT_C = lib/.lake/build/ir/Systems/Fmt.c
LIST_C = lib/.lake/build/ir/Systems/List.c
PATH_C = lib/.lake/build/ir/Systems/Path.c
HEX_C = lib/.lake/build/ir/Systems/Hex.c
UTF8_C = lib/.lake/build/ir/Systems/Utf8.c
TREE_C = lib/.lake/build/ir/Systems/Tree.c
JSON_C = lib/.lake/build/ir/Systems/Json.c
BASE64_C = lib/.lake/build/ir/Systems/Base64.c
GRAPH_C = lib/.lake/build/ir/Systems/Graph.c
REGEX_C = lib/.lake/build/ir/Systems/Regex.c
URL_C = lib/.lake/build/ir/Systems/Url.c
ARENAPOOL_C = lib/.lake/build/ir/Systems/ArenaPool.c
INI_C = lib/.lake/build/ir/Systems/Ini.c
CSV_C = lib/.lake/build/ir/Systems/Csv.c
BLOOM_C = lib/.lake/build/ir/Systems/Bloom.c
TOML_C = lib/.lake/build/ir/Systems/Toml.c
XML_C = lib/.lake/build/ir/Systems/Xml.c
SKIPLIST_C = lib/.lake/build/ir/Systems/SkipList.c
YAML_C = lib/.lake/build/ir/Systems/Yaml.c
HTTP_C = lib/.lake/build/ir/Systems/Http.c
BTREE_C = lib/.lake/build/ir/Systems/BTree.c
DNS_C = lib/.lake/build/ir/Systems/Dns.c
SEXP_C = lib/.lake/build/ir/Systems/Sexp.c
AVL_C = lib/.lake/build/ir/Systems/Avl.c
MD_C = lib/.lake/build/ir/Systems/Md.c
ICMP_C = lib/.lake/build/ir/Systems/Icmp.c
RBTREE_C = lib/.lake/build/ir/Systems/RbTree.c
PEM_C = lib/.lake/build/ir/Systems/Pem.c
NTP_C = lib/.lake/build/ir/Systems/Ntp.c
TRIE_C = lib/.lake/build/ir/Systems/Trie.c
JWT_C = lib/.lake/build/ir/Systems/Jwt.c
DHCP_C = lib/.lake/build/ir/Systems/Dhcp.c
BINARYHEAP_C = lib/.lake/build/ir/Systems/BinaryHeap.c
UUID_C = lib/.lake/build/ir/Systems/Uuid.c
ARP_C = lib/.lake/build/ir/Systems/Arp.c
INTERVALTREE_C = lib/.lake/build/ir/Systems/IntervalTree.c
SEMVER_C = lib/.lake/build/ir/Systems/Semver.c
GRE_C = lib/.lake/build/ir/Systems/Gre.c
SPLAY_C = lib/.lake/build/ir/Systems/Splay.c
CBOR_C = lib/.lake/build/ir/Systems/Cbor.c
IP_C = lib/.lake/build/ir/Systems/Ip.c
BTREEMAP_C = lib/.lake/build/ir/Systems/BTreeMap.c
TOMLQUERYLITE_C = lib/.lake/build/ir/Systems/TomlQuery.c
UDP_C = lib/.lake/build/ir/Systems/Udp.c
SKIPLISTMAP_C = lib/.lake/build/ir/Systems/SkipListMap.c
EDN_C = lib/.lake/build/ir/Systems/Edn.c
TCP_C = lib/.lake/build/ir/Systems/Tcp.c
HASHMAP_C = lib/.lake/build/ir/Systems/HashMap.c
MSGPACK_C = lib/.lake/build/ir/Systems/MsgPack.c
ICMPV6_C = lib/.lake/build/ir/Systems/Icmpv6.c
LINKEDHASHMAP_C = lib/.lake/build/ir/Systems/LinkedHashMap.c
PROTOBUF_C = lib/.lake/build/ir/Systems/Protobuf.c
SCTP_C = lib/.lake/build/ir/Systems/Sctp.c
ORDEREDMAP_C = lib/.lake/build/ir/Systems/OrderedMap.c
AVRO_C = lib/.lake/build/ir/Systems/Avro.c
DCCP_C = lib/.lake/build/ir/Systems/Dccp.c
TREEMAP_C = lib/.lake/build/ir/Systems/TreeMap.c
CAPNP_C = lib/.lake/build/ir/Systems/Capnp.c
QUIC_C = lib/.lake/build/ir/Systems/Quic.c
FLATBUFFERS_C = lib/.lake/build/ir/Systems/FlatBuffers.c
MQTT_C = lib/.lake/build/ir/Systems/Mqtt.c
RADIXTREE_C = lib/.lake/build/ir/Systems/RadixTree.c
ASN1_C = lib/.lake/build/ir/Systems/Asn1.c
COAP_C = lib/.lake/build/ir/Systems/Coap.c
YAMLQUERYLITE_C = lib/.lake/build/ir/Systems/YamlQuery.c
WEBSOCKET_C = lib/.lake/build/ir/Systems/WebSocket.c
BITMAP_C = lib/.lake/build/ir/Systems/BitMap.c
LZ4LITE_C = lib/.lake/build/ir/Systems/Lz4.c
SOCKS5_C = lib/.lake/build/ir/Systems/Socks5.c
SNAPPYLITE_C = lib/.lake/build/ir/Systems/Snappy.c
RTSPLITE_C = lib/.lake/build/ir/Systems/Rtsp.c
ZSTDLITE_C = lib/.lake/build/ir/Systems/Zstd.c
SIP_C = lib/.lake/build/ir/Systems/Sip.c
BROTLILITE_C = lib/.lake/build/ir/Systems/Brotli.c
NTPQUERYLITE_C = lib/.lake/build/ir/Systems/NtpQuery.c
OGGLITE_C = lib/.lake/build/ir/Systems/Ogg.c
SMTPLITE_C = lib/.lake/build/ir/Systems/Smtp.c
BITSETMULTI_C = lib/.lake/build/ir/Systems/BitSetMulti.c
WEBMLITE_C = lib/.lake/build/ir/Systems/Webm.c
POP3LITE_C = lib/.lake/build/ir/Systems/Pop3.c
ROARING_C = lib/.lake/build/ir/Systems/Roaring.c
MATROSKALITE_C = lib/.lake/build/ir/Systems/Matroska.c
IMAPLITE_C = lib/.lake/build/ir/Systems/Imap.c
INTERVALSET_C = lib/.lake/build/ir/Systems/IntervalSet.c
FLACLITE_C = lib/.lake/build/ir/Systems/Flac.c
NNTPLITE_C = lib/.lake/build/ir/Systems/Nntp.c
LDAPLITE_C = lib/.lake/build/ir/Systems/Ldap.c
VORBISLITE_C = lib/.lake/build/ir/Systems/Vorbis.c
RADIUSLITE_C = lib/.lake/build/ir/Systems/Radius.c
ORDEREDU32SET_C = lib/.lake/build/ir/Systems/OrderedU32Set.c
DIAMETERLITE_C = lib/.lake/build/ir/Systems/Diameter.c
SCTPCOMMONLITE_C = lib/.lake/build/ir/Systems/SctpCommon.c
M3UALITE_C = lib/.lake/build/ir/Systems/M3ua.c
SUALITE_C = lib/.lake/build/ir/Systems/Sua.c
IUALITE_C = lib/.lake/build/ir/Systems/Iua.c
V5UALITE_C = lib/.lake/build/ir/Systems/V5ua.c
H248LITE_C = lib/.lake/build/ir/Systems/H248.c
MEGACOLITE_C = lib/.lake/build/ir/Systems/Megaco.c
MGCPLITE_C = lib/.lake/build/ir/Systems/Mgcp.c
SDPLITE_C = lib/.lake/build/ir/Systems/Sdp.c
RTCPLITE_C = lib/.lake/build/ir/Systems/Rtcp.c
STUNLITE_C = lib/.lake/build/ir/Systems/Stun.c
TURNLITE_C = lib/.lake/build/ir/Systems/Turn.c
ICELITE_C = lib/.lake/build/ir/Systems/Ice.c
RTPLITE_C = lib/.lake/build/ir/Systems/Rtp.c
SRTPLITE_C = lib/.lake/build/ir/Systems/Srtp.c
SRTCPLITE_C = lib/.lake/build/ir/Systems/Srtcp.c
DTLS_C = lib/.lake/build/ir/Systems/Dtls.c
TLS_C = lib/.lake/build/ir/Systems/Tls.c
IPSECLITE_C = lib/.lake/build/ir/Systems/Ipsec.c
DEPGRAPH_C = lib/.lake/build/ir/Systems/DepGraph.c
TRACE_C = lib/.lake/build/ir/Systems/Trace.c
TOMLCONFIG_C = lib/.lake/build/ir/Systems/TomlConfig.c
PROC_C = lib/.lake/build/ir/Systems/Proc.c
MANIFEST_C = lib/.lake/build/ir/Systems/Manifest.c
CACHEINDEX_C = lib/.lake/build/ir/Systems/CacheIndex.c
L2TPLITE_C = lib/.lake/build/ir/Systems/L2tp.c
PPTPLITE_C = lib/.lake/build/ir/Systems/Pptp.c
L2FLITE_C = lib/.lake/build/ir/Systems/L2f.c
PPPLITE_C = lib/.lake/build/ir/Systems/Ppp.c
HDLCLITE_C = lib/.lake/build/ir/Systems/Hdlc.c
# Full product freestanding matrix (aligned with systems-residual-policy).
FS_IR = $(EXTRACT_C) $(SCALARS_C) $(SYS_C) $(BYTES_C) $(NUMERICS_C) $(STATUS_C) \
	$(MEM_C) $(BITOPS_C) $(HASH_C) $(BYTESPAN_C) $(MAP_C) $(BITVEC_C) $(SET_C) \
	$(QUEUE_C) $(VECTOR_C) $(SORT_C) $(CRC_C) \
	$(STRING_C) $(BINARYSEARCH_C) $(DEQUE_C) \
	$(STACK_C) $(ASCII_C) $(MEMREGION_C) \
	$(BITSET_C) $(PARSE_C) $(RINGBUF_C) \
	$(FMT_C) $(LIST_C) $(PATH_C) \
	$(HEX_C) $(UTF8_C) $(TREE_C) \
	$(JSON_C) $(BASE64_C) $(GRAPH_C) \
	$(REGEX_C) $(URL_C) $(ARENAPOOL_C) \
	$(INI_C) $(CSV_C) $(BLOOM_C) \
	$(TOML_C) $(XML_C) $(SKIPLIST_C) \
	$(YAML_C) $(HTTP_C) $(BTREE_C) \
	$(DNS_C) $(SEXP_C) $(AVL_C) \
	$(MD_C) $(ICMP_C) $(RBTREE_C) \
	$(PEM_C) $(NTP_C) $(TRIE_C) \
	$(JWT_C) $(DHCP_C) $(BINARYHEAP_C) \
	$(UUID_C) $(ARP_C) $(INTERVALTREE_C) \
	$(SEMVER_C) $(GRE_C) $(SPLAY_C) \
	$(CBOR_C) $(IP_C) $(BTREEMAP_C) \
	$(TOMLQUERYLITE_C) $(UDP_C) $(SKIPLISTMAP_C) \
	$(EDN_C) $(TCP_C) $(HASHMAP_C) \
	$(MSGPACK_C) $(ICMPV6_C) $(LINKEDHASHMAP_C) \
	$(PROTOBUF_C) $(SCTP_C) $(ORDEREDMAP_C) \
	$(AVRO_C) $(DCCP_C) $(TREEMAP_C) \
	$(CAPNP_C) $(QUIC_C) \
	$(FLATBUFFERS_C) $(MQTT_C) $(RADIXTREE_C) \
	$(ASN1_C) $(COAP_C) \
	$(YAMLQUERYLITE_C) $(WEBSOCKET_C) $(BITMAP_C) \
	$(LZ4LITE_C) $(SOCKS5_C) \
	$(SNAPPYLITE_C) $(RTSPLITE_C) \
	$(ZSTDLITE_C) $(SIP_C) \
	$(BROTLILITE_C) $(NTPQUERYLITE_C) \
	$(OGGLITE_C) $(SMTPLITE_C) $(BITSETMULTI_C) \
	$(WEBMLITE_C) $(POP3LITE_C) $(ROARING_C) \
	$(MATROSKALITE_C) $(IMAPLITE_C) $(INTERVALSET_C) \
	$(FLACLITE_C) $(NNTPLITE_C) \
	$(LDAPLITE_C) \
	$(VORBISLITE_C) $(RADIUSLITE_C) $(ORDEREDU32SET_C) \
	$(DIAMETERLITE_C) \
	$(SCTPCOMMONLITE_C) \
	$(M3UALITE_C) \
	$(SUALITE_C) \
	$(IUALITE_C) \
	$(V5UALITE_C) \
	$(H248LITE_C) \
	$(MEGACOLITE_C) \
	$(MGCPLITE_C) \
	$(SDPLITE_C) \
	$(RTCPLITE_C) \
	$(STUNLITE_C) \
	$(TURNLITE_C) \
	$(ICELITE_C) \
	$(RTPLITE_C) \
	$(SRTPLITE_C) \
	$(SRTCPLITE_C) \
	$(DTLS_C) \
	$(TLS_C) \
	$(IPSECLITE_C) \
	$(DEPGRAPH_C) \
	$(TRACE_C) $(TOMLCONFIG_C) \
	$(PROC_C) $(MANIFEST_C) \
	$(CACHEINDEX_C) $(L2TPLITE_C) \
	$(PPTPLITE_C) $(L2FLITE_C) \
	$(PPPLITE_C) \
	$(HDLCLITE_C) \
	$(SIMD_C) $(FORKJOIN_C) $(CHANNEL_C)
check-ir: lake
	@echo "=== freestanding IR: full product matrix (Scalars…Par) dual params, no object product ==="
	@test -f $(EXTRACT_C) || { echo "FAIL: missing $(EXTRACT_C)"; exit 1; }
	@test -f $(SCALARS_C) || { echo "FAIL: missing $(SCALARS_C) (S8 multi-module)"; exit 1; }
	@test -f $(SYS_C) || { echo "FAIL: missing $(SYS_C) (S8 log Lean body)"; exit 1; }
	@test -f $(BYTES_C) || { echo "FAIL: missing $(BYTES_C) (R7 Bytes)"; exit 1; }
	@test -f $(NUMERICS_C) || { echo "FAIL: missing $(NUMERICS_C) (R7 Numerics)"; exit 1; }
	@test -f $(STATUS_C) || { echo "FAIL: missing $(STATUS_C) (R7 Status)"; exit 1; }
	@test -f $(MEM_C) || { echo "FAIL: missing $(MEM_C) (Mem expansion)"; exit 1; }
	@test -f $(BITOPS_C) || { echo "FAIL: missing $(BITOPS_C) (BitOps expansion)"; exit 1; }
	@test -f $(HASH_C) || { echo "FAIL: missing $(HASH_C) (Hash expansion)"; exit 1; }
	@test -f $(SIMD_C) || { echo "FAIL: missing $(SIMD_C) (Par L1)"; exit 1; }
	@test -f $(FORKJOIN_C) || { echo "FAIL: missing $(FORKJOIN_C) (Par L2)"; exit 1; }
	@test -f $(CHANNEL_C) || { echo "FAIL: missing $(CHANNEL_C) (Par L3)"; exit 1; }
	@test -f $(MAP_C) || { echo "FAIL: missing $(MAP_C) (Map)"; exit 1; }
	@test -f $(SET_C) || { echo "FAIL: missing $(SET_C) (Set)"; exit 1; }
	@test -f $(QUEUE_C) || { echo "FAIL: missing $(QUEUE_C) (Queue)"; exit 1; }
	@test -f $(VECTOR_C) || { echo "FAIL: missing $(VECTOR_C) (Vector)"; exit 1; }
	@test -f $(SORT_C) || { echo "FAIL: missing $(SORT_C) (Sort)"; exit 1; }
	@test -f $(CRC_C) || { echo "FAIL: missing $(CRC_C) (Crc)"; exit 1; }
	@test -f $(STRING_C) || { echo "FAIL: missing $(STRING_C) (String)"; exit 1; }
	@test -f $(BINARYSEARCH_C) || { echo "FAIL: missing $(BINARYSEARCH_C) (BinarySearch)"; exit 1; }
	@test -f $(DEQUE_C) || { echo "FAIL: missing $(DEQUE_C) (Deque)"; exit 1; }
	@test -f $(STACK_C) || { echo "FAIL: missing $(STACK_C) (Stack)"; exit 1; }
	@test -f $(ASCII_C) || { echo "FAIL: missing $(ASCII_C) (Ascii)"; exit 1; }
	@test -f $(MEMREGION_C) || { echo "FAIL: missing $(MEMREGION_C) (MemRegion)"; exit 1; }
	@test -f $(BITSET_C) || { echo "FAIL: missing $(BITSET_C) (BitSet)"; exit 1; }
	@test -f $(PARSE_C) || { echo "FAIL: missing $(PARSE_C) (Parse)"; exit 1; }
	@test -f $(RINGBUF_C) || { echo "FAIL: missing $(RINGBUF_C) (RingBuf)"; exit 1; }
	@test -f $(FMT_C) || { echo "FAIL: missing $(FMT_C) (Fmt)"; exit 1; }
	@test -f $(LIST_C) || { echo "FAIL: missing $(LIST_C) (List)"; exit 1; }
	@test -f $(PATH_C) || { echo "FAIL: missing $(PATH_C) (Path)"; exit 1; }
	@test -f $(HEX_C) || { echo "FAIL: missing $(HEX_C) (Hex)"; exit 1; }
	@test -f $(UTF8_C) || { echo "FAIL: missing $(UTF8_C) (Utf8)"; exit 1; }
	@test -f $(TREE_C) || { echo "FAIL: missing $(TREE_C) (Tree)"; exit 1; }
	@test -f $(JSON_C) || { echo "FAIL: missing $(JSON_C) (Json)"; exit 1; }
	@test -f $(BASE64_C) || { echo "FAIL: missing $(BASE64_C) (Base64)"; exit 1; }
	@test -f $(GRAPH_C) || { echo "FAIL: missing $(GRAPH_C) (Graph)"; exit 1; }
	@test -f $(REGEX_C) || { echo "FAIL: missing $(REGEX_C) (Regex)"; exit 1; }
	@test -f $(URL_C) || { echo "FAIL: missing $(URL_C) (Url)"; exit 1; }
	@test -f $(ARENAPOOL_C) || { echo "FAIL: missing $(ARENAPOOL_C) (ArenaPool)"; exit 1; }
	@test -f $(INI_C) || { echo "FAIL: missing $(INI_C) (Ini)"; exit 1; }
	@test -f $(CSV_C) || { echo "FAIL: missing $(CSV_C) (Csv)"; exit 1; }
	@test -f $(BLOOM_C) || { echo "FAIL: missing $(BLOOM_C) (Bloom)"; exit 1; }
	@test -f $(TOML_C) || { echo "FAIL: missing $(TOML_C) (Toml)"; exit 1; }
	@test -f $(XML_C) || { echo "FAIL: missing $(XML_C) (Xml)"; exit 1; }
	@test -f $(SKIPLIST_C) || { echo "FAIL: missing $(SKIPLIST_C) (SkipList)"; exit 1; }
	@test -f $(YAML_C) || { echo "FAIL: missing $(YAML_C) (Yaml)"; exit 1; }
	@test -f $(HTTP_C) || { echo "FAIL: missing $(HTTP_C) (Http)"; exit 1; }
	@test -f $(BTREE_C) || { echo "FAIL: missing $(BTREE_C) (BTree)"; exit 1; }
	@test -f $(DNS_C) || { echo "FAIL: missing $(DNS_C) (Dns)"; exit 1; }
	@test -f $(SEXP_C) || { echo "FAIL: missing $(SEXP_C) (Sexp)"; exit 1; }
	@test -f $(AVL_C) || { echo "FAIL: missing $(AVL_C) (Avl)"; exit 1; }
	@test -f $(MD_C) || { echo "FAIL: missing $(MD_C) (Md)"; exit 1; }
	@test -f $(ICMP_C) || { echo "FAIL: missing $(ICMP_C) (Icmp)"; exit 1; }
	@test -f $(RBTREE_C) || { echo "FAIL: missing $(RBTREE_C) (RbTree)"; exit 1; }
	@test -f $(PEM_C) || { echo "FAIL: missing $(PEM_C) (Pem)"; exit 1; }
	@test -f $(NTP_C) || { echo "FAIL: missing $(NTP_C) (Ntp)"; exit 1; }
	@test -f $(TRIE_C) || { echo "FAIL: missing $(TRIE_C) (Trie)"; exit 1; }
	@test -f $(JWT_C) || { echo "FAIL: missing $(JWT_C) (Jwt)"; exit 1; }
	@test -f $(DHCP_C) || { echo "FAIL: missing $(DHCP_C) (Dhcp)"; exit 1; }
	@test -f $(BINARYHEAP_C) || { echo "FAIL: missing $(BINARYHEAP_C) (BinaryHeap)"; exit 1; }
	@test -f $(UUID_C) || { echo "FAIL: missing $(UUID_C) (Uuid)"; exit 1; }
	@test -f $(ARP_C) || { echo "FAIL: missing $(ARP_C) (Arp)"; exit 1; }
	@test -f $(INTERVALTREE_C) || { echo "FAIL: missing $(INTERVALTREE_C) (IntervalTree)"; exit 1; }
	@test -f $(SEMVER_C) || { echo "FAIL: missing $(SEMVER_C) (Semver)"; exit 1; }
	@test -f $(GRE_C) || { echo "FAIL: missing $(GRE_C) (Gre)"; exit 1; }
	@test -f $(SPLAY_C) || { echo "FAIL: missing $(SPLAY_C) (Splay)"; exit 1; }
	@test -f $(CBOR_C) || { echo "FAIL: missing $(CBOR_C) (Cbor)"; exit 1; }
	@test -f $(IP_C) || { echo "FAIL: missing $(IP_C) (Ip)"; exit 1; }
	@test -f $(BTREEMAP_C) || { echo "FAIL: missing $(BTREEMAP_C) (BTreeMap)"; exit 1; }
	@test -f $(TOMLQUERYLITE_C) || { echo "FAIL: missing $(TOMLQUERYLITE_C) (TomlQuery)"; exit 1; }
	@test -f $(UDP_C) || { echo "FAIL: missing $(UDP_C) (Udp)"; exit 1; }
	@test -f $(SKIPLISTMAP_C) || { echo "FAIL: missing $(SKIPLISTMAP_C) (SkipListMap)"; exit 1; }
	@test -f $(EDN_C) || { echo "FAIL: missing $(EDN_C) (Edn)"; exit 1; }
	@test -f $(TCP_C) || { echo "FAIL: missing $(TCP_C) (Tcp)"; exit 1; }
	@test -f $(HASHMAP_C) || { echo "FAIL: missing $(HASHMAP_C) (HashMap)"; exit 1; }
	@test -f $(MSGPACK_C) || { echo "FAIL: missing $(MSGPACK_C) (MsgPack)"; exit 1; }
	@test -f $(ICMPV6_C) || { echo "FAIL: missing $(ICMPV6_C) (Icmpv6)"; exit 1; }
	@test -f $(LINKEDHASHMAP_C) || { echo "FAIL: missing $(LINKEDHASHMAP_C) (LinkedHashMap)"; exit 1; }
	@test -f $(PROTOBUF_C) || { echo "FAIL: missing $(PROTOBUF_C) (Protobuf)"; exit 1; }
	@test -f $(SCTP_C) || { echo "FAIL: missing $(SCTP_C) (Sctp)"; exit 1; }
	@test -f $(ORDEREDMAP_C) || { echo "FAIL: missing $(ORDEREDMAP_C) (OrderedMap)"; exit 1; }
	@test -f $(AVRO_C) || { echo "FAIL: missing $(AVRO_C) (Avro)"; exit 1; }
	@test -f $(DCCP_C) || { echo "FAIL: missing $(DCCP_C) (Dccp)"; exit 1; }
	@test -f $(TREEMAP_C) || { echo "FAIL: missing $(TREEMAP_C) (TreeMap)"; exit 1; }
	@test -f $(CAPNP_C) || { echo "FAIL: missing $(CAPNP_C) (Capnp)"; exit 1; }
	@test -f $(QUIC_C) || { echo "FAIL: missing $(QUIC_C) (Quic)"; exit 1; }
	@test -f $(FLATBUFFERS_C) || { echo "FAIL: missing $(FLATBUFFERS_C) (FlatBuffers)"; exit 1; }
	@test -f $(MQTT_C) || { echo "FAIL: missing $(MQTT_C) (Mqtt)"; exit 1; }
	@test -f $(RADIXTREE_C) || { echo "FAIL: missing $(RADIXTREE_C) (RadixTree)"; exit 1; }
	@test -f $(ASN1_C) || { echo "FAIL: missing $(ASN1_C) (Asn1)"; exit 1; }
	@test -f $(COAP_C) || { echo "FAIL: missing $(COAP_C) (Coap)"; exit 1; }
	@test -f $(YAMLQUERYLITE_C) || { echo "FAIL: missing $(YAMLQUERYLITE_C) (YamlQuery)"; exit 1; }
	@test -f $(WEBSOCKET_C) || { echo "FAIL: missing $(WEBSOCKET_C) (WebSocket)"; exit 1; }
	@test -f $(BITMAP_C) || { echo "FAIL: missing $(BITMAP_C) (BitMap)"; exit 1; }
	@test -f $(LZ4LITE_C) || { echo "FAIL: missing $(LZ4LITE_C) (Lz4)"; exit 1; }
	@test -f $(SOCKS5_C) || { echo "FAIL: missing $(SOCKS5_C) (Socks5)"; exit 1; }
	@test -f $(SNAPPYLITE_C) || { echo "FAIL: missing $(SNAPPYLITE_C) (Snappy)"; exit 1; }
	@test -f $(RTSPLITE_C) || { echo "FAIL: missing $(RTSPLITE_C) (Rtsp)"; exit 1; }
	@test -f $(ZSTDLITE_C) || { echo "FAIL: missing $(ZSTDLITE_C) (Zstd)"; exit 1; }
	@test -f $(SIP_C) || { echo "FAIL: missing $(SIP_C) (Sip)"; exit 1; }
	@test -f $(BROTLILITE_C) || { echo "FAIL: missing $(BROTLILITE_C) (Brotli)"; exit 1; }
	@test -f $(NTPQUERYLITE_C) || { echo "FAIL: missing $(NTPQUERYLITE_C) (NtpQuery)"; exit 1; }
	@test -f $(OGGLITE_C) || { echo "FAIL: missing $(OGGLITE_C) (Ogg)"; exit 1; }
	@test -f $(SMTPLITE_C) || { echo "FAIL: missing $(SMTPLITE_C) (Smtp)"; exit 1; }
	@test -f $(BITSETMULTI_C) || { echo "FAIL: missing $(BITSETMULTI_C) (BitSetMulti)"; exit 1; }
	@test -f $(WEBMLITE_C) || { echo "FAIL: missing $(WEBMLITE_C) (Webm)"; exit 1; }
	@test -f $(POP3LITE_C) || { echo "FAIL: missing $(POP3LITE_C) (Pop3)"; exit 1; }
	@test -f $(ROARING_C) || { echo "FAIL: missing $(ROARING_C) (Roaring)"; exit 1; }
	@test -f $(MATROSKALITE_C) || { echo "FAIL: missing $(MATROSKALITE_C) (Matroska)"; exit 1; }
	@test -f $(IMAPLITE_C) || { echo "FAIL: missing $(IMAPLITE_C) (Imap)"; exit 1; }
	@test -f $(INTERVALSET_C) || { echo "FAIL: missing $(INTERVALSET_C) (IntervalSet)"; exit 1; }
	@test -f $(FLACLITE_C) || { echo "FAIL: missing $(FLACLITE_C) (Flac)"; exit 1; }
	@test -f $(NNTPLITE_C) || { echo "FAIL: missing $(NNTPLITE_C) (Nntp)"; exit 1; }
	@test -f $(LDAPLITE_C) || { echo "FAIL: missing $(LDAPLITE_C) (Ldap)"; exit 1; }
	@test -f $(VORBISLITE_C) || { echo "FAIL: missing $(VORBISLITE_C) (Vorbis)"; exit 1; }
	@test -f $(RADIUSLITE_C) || { echo "FAIL: missing $(RADIUSLITE_C) (Radius)"; exit 1; }
	@test -f $(ORDEREDU32SET_C) || { echo "FAIL: missing $(ORDEREDU32SET_C) (OrderedU32Set)"; exit 1; }
	@test -f $(DIAMETERLITE_C) || { echo "FAIL: missing $(DIAMETERLITE_C) (Diameter)"; exit 1; }
	@test -f $(SCTPCOMMONLITE_C) || { echo "FAIL: missing $(SCTPCOMMONLITE_C) (SctpCommon)"; exit 1; }
	@test -f $(M3UALITE_C) || { echo "FAIL: missing $(M3UALITE_C) (M3ua)"; exit 1; }
	@test -f $(SUALITE_C) || { echo "FAIL: missing $(SUALITE_C) (Sua)"; exit 1; }
	@test -f $(IUALITE_C) || { echo "FAIL: missing $(IUALITE_C) (Iua)"; exit 1; }
	@test -f $(V5UALITE_C) || { echo "FAIL: missing $(V5UALITE_C) (V5ua)"; exit 1; }
	@test -f $(H248LITE_C) || { echo "FAIL: missing $(H248LITE_C) (H248)"; exit 1; }
	@test -f $(MEGACOLITE_C) || { echo "FAIL: missing $(MEGACOLITE_C) (Megaco)"; exit 1; }
	@test -f $(MGCPLITE_C) || { echo "FAIL: missing $(MGCPLITE_C) (Mgcp)"; exit 1; }
	@test -f $(SDPLITE_C) || { echo "FAIL: missing $(SDPLITE_C) (Sdp)"; exit 1; }
	@test -f $(RTCPLITE_C) || { echo "FAIL: missing $(RTCPLITE_C) (Rtcp)"; exit 1; }
	@test -f $(STUNLITE_C) || { echo "FAIL: missing $(STUNLITE_C) (Stun)"; exit 1; }
	@test -f $(TURNLITE_C) || { echo "FAIL: missing $(TURNLITE_C) (Turn)"; exit 1; }
	@test -f $(ICELITE_C) || { echo "FAIL: missing $(ICELITE_C) (Ice)"; exit 1; }
	@test -f $(RTPLITE_C) || { echo "FAIL: missing $(RTPLITE_C) (Rtp)"; exit 1; }
	@test -f $(SRTPLITE_C) || { echo "FAIL: missing $(SRTPLITE_C) (Srtp)"; exit 1; }
	@test -f $(SRTCPLITE_C) || { echo "FAIL: missing $(SRTCPLITE_C) (Srtcp)"; exit 1; }
	@test -f $(DTLS_C) || { echo "FAIL: missing $(DTLS_C) (Dtls)"; exit 1; }
	@test -f $(TLS_C) || { echo "FAIL: missing $(TLS_C) (Tls)"; exit 1; }
	@test -f $(IPSECLITE_C) || { echo "FAIL: missing $(IPSECLITE_C) (Ipsec)"; exit 1; }
	@test -f $(DEPGRAPH_C) || { echo "FAIL: missing $(DEPGRAPH_C) (DepGraph)"; exit 1; }
	@test -f $(TRACE_C) || { echo "FAIL: missing $(TRACE_C) (Trace)"; exit 1; }
	@test -f $(TOMLCONFIG_C) || { echo "FAIL: missing $(TOMLCONFIG_C) (TomlConfig)"; exit 1; }
	@test -f $(PROC_C) || { echo "FAIL: missing $(PROC_C) (Proc)"; exit 1; }
	@test -f $(MANIFEST_C) || { echo "FAIL: missing $(MANIFEST_C) (Manifest)"; exit 1; }
	@test -f $(CACHEINDEX_C) || { echo "FAIL: missing $(CACHEINDEX_C) (CacheIndex)"; exit 1; }
	@test -f $(L2TPLITE_C) || { echo "FAIL: missing $(L2TPLITE_C) (L2tp)"; exit 1; }
	@test -f $(PPTPLITE_C) || { echo "FAIL: missing $(PPTPLITE_C) (Pptp)"; exit 1; }
	@test -f $(L2FLITE_C) || { echo "FAIL: missing $(L2FLITE_C) (L2f)"; exit 1; }
	@test -f $(PPPLITE_C) || { echo "FAIL: missing $(PPPLITE_C) (Ppp)"; exit 1; }
	@test -f $(HDLCLITE_C) || { echo "FAIL: missing $(HDLCLITE_C) (Hdlc)"; exit 1; }
	@test -f $(BYTESPAN_C) || { echo "FAIL: missing $(BYTESPAN_C) (ByteSpan)"; exit 1; }
	@test -f $(BITVEC_C) || { echo "FAIL: missing $(BITVEC_C) (BitVec)"; exit 1; }
	@# rehash must call clear (DCE regress: discarded clear drops dirty-dest zeroing)
	@python3 check_rehash_clears.py $(MAP_C) Map $(SET_C) Set
	@# Channel product path must retain free (chanClose) — no malloc without free
	@grep -E '\bfree\s*\(' $(CHANNEL_C) >/dev/null \
	  || { echo "FAIL: Channel.c missing free (chanClose DCE regress)"; exit 1; }
	@grep -E '\bmalloc\s*\(' $(CHANNEL_C) >/dev/null \
	  || { echo "FAIL: Channel.c missing malloc (chanOpen)"; exit 1; }
	@grep -E '^uint32_t lean_fs_checksum\(size_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing exact checksum prototype (size_t, size_t)"; exit 1; }
	@grep -E '^uint32_t lean_fs_checksum\(size_t [^,]+, size_t [^)]+\)\{$$' $(EXTRACT_C) \
	  || { echo "FAIL: unexpected checksum definition signature"; exit 1; }
	# Freestanding IR: scope IR checks to checksumGo / logGet / Arena / writeAll / zero GNU stmt exprs
	@python3 check_control_flow_ir.py $(EXTRACT_C)
	@# hard fail if any ({ or spaced ( { remains (ISO C11 gate; not compound literals)
	@if grep -E '\(\s*\{' $(FS_IR) 2>/dev/null; then \
	  echo "FAIL: residual GNU statement expr (\\(\\s*\\{) in package IR"; exit 1; \
	fi
	@echo "OK: zero GNU statement exprs in full product Freestanding matrix"
	@grep -E '^uint32_t lean_fs_load_u8\(size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_load_u8 prototype"; exit 1; }
	@grep -E '^size_t lean_fs_open\(size_t, uint32_t, uint32_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_open prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_close\(size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_close prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_write_all\(size_t, size_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_write_all prototype"; exit 1; }
	@grep -E '^size_t lean_fs_arena_create\(size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_arena_create prototype"; exit 1; }
	@grep -E '^size_t lean_fs_arena_alloc\(size_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_arena_alloc prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_arena_free\(size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_arena_free prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_arena_smoke\(size_t, size_t, uint8_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_arena_smoke prototype"; exit 1; }
	@grep -E '^size_t lean_fs_log_open\(size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_log_open prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_log_put\(size_t, size_t, size_t, size_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_log_put prototype"; exit 1; }
	@grep -E '^size_t lean_fs_log_get\(size_t, size_t, size_t, size_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_log_get prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_log_sync\(size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_log_sync prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_log_close\(size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_log_close prototype"; exit 1; }
	@grep -E '^size_t lean_fs_log_smoke\(size_t, size_t, size_t, size_t, size_t, size_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_log_smoke prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_ftruncate\(size_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_ftruncate prototype"; exit 1; }
	@grep -E '^size_t lean_fs_mmap\(size_t, size_t, uint32_t, uint32_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_mmap prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_msync\(size_t, size_t, uint32_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_msync prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_munmap\(size_t, size_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_munmap prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_mmap_smoke\(size_t, uint32_t, uint32_t, size_t, uint32_t, uint32_t, size_t, size_t, uint32_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_mmap_smoke prototype"; exit 1; }
	@grep -E '^uint32_t lean_fs_mmap_close_live\(size_t, uint32_t, uint32_t, size_t, uint32_t, uint32_t, size_t, size_t, uint32_t\);$$' $(EXTRACT_C) \
	  || { echo "FAIL: missing lean_fs_mmap_close_live prototype"; exit 1; }
	# MAP_FAILED-safe dispose / guards present in munmap/msync/copy paths
	@grep -E 'MAP_FAILED' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected MAP_FAILED guards in Extract.c / Sys.c munmap/msync/copy"; exit 1; }
	@grep -E '\b(open|close|read|write|malloc|free)\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected libc open/close/read/write/malloc/free calls in Extract.c/Sys.c"; exit 1; }
	@grep -E '\bmemset\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected memset in arena fill path"; exit 1; }
	@grep -E '\bfsync\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected fsync in log sync path"; exit 1; }
	@grep -E '\blseek\s*\(' $(SYS_C) $(EXTRACT_C) >/dev/null \
	  || { echo "FAIL: expected lseek in log put/get path (Sys.c / Extract.c)"; exit 1; }
	@grep -E '\bmmap\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected mmap in Extract.c/Sys.c"; exit 1; }
	@grep -E '\bmunmap\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected munmap in Extract.c/Sys.c"; exit 1; }
	@grep -E '\bmsync\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected msync in Extract.c/Sys.c"; exit 1; }
	@grep -E '\bftruncate\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected ftruncate in Extract.c/Sys.c"; exit 1; }
	@grep -E 'sys/mman\.h' $(EXTRACT_C) >/dev/null \
	  || { echo "FAIL: expected #include <sys/mman.h> in freestanding Extract.c"; exit 1; }
	@grep -E 'SEEK_(SET|CUR|END)' $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected SEEK_* macros in log put/get (Sys.c)"; exit 1; }
	@grep -E '\(size_t\)\(uint32_t\)' $(SYS_C) $(SCALARS_C) >/dev/null \
	  || { echo "FAIL: expected uint32 narrow-check before put write (overflow gate in Sys/Scalars)"; exit 1; }
	@grep -E 'lean_fs_open_write_close' $(EXTRACT_C) >/dev/null \
	  || { echo "FAIL: missing lean_fs_open_write_close"; exit 1; }
	# openWriteClose composition must keep write( after pure DCE (never_extract Sys ops)
	@grep -E 'write\s*\(\s*\(int\)' $(EXTRACT_C) >/dev/null \
	  || { echo "FAIL: expected casted write((int)…) in openWriteClose composition"; grep -n write $(EXTRACT_C); exit 1; }
	# arena smoke must keep malloc/free after DCE (may live in Sys.c create body)
	@grep -E 'malloc\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected malloc in Extract.c/Sys.c"; exit 1; }
	@grep -E 'free\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected free in Extract.c/Sys.c"; exit 1; }
	# log smoke must keep fsync after DCE
	@grep -E 'fsync\s*\(\s*\(int\)' $(EXTRACT_C) >/dev/null \
	  || { echo "FAIL: expected casted fsync((int)…) after never_extract sequencing"; grep -n fsync $(EXTRACT_C); exit 1; }
	# mmap smoke must keep msync/munmap after DCE (may be in Sys.c after Lean helpers)
	@grep -E '\bmsync\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected msync(…) after never_extract sequencing"; grep -n msync $(EXTRACT_C) $(SYS_C); exit 1; }
	@grep -E '\bmunmap\s*\(' $(EXTRACT_C) $(SYS_C) >/dev/null \
	  || { echo "FAIL: expected munmap(…) after never_extract sequencing"; grep -n munmap $(EXTRACT_C) $(SYS_C); exit 1; }
	@grep -E 'lean_fs_mmap_close_live' $(EXTRACT_C) >/dev/null \
	  || { echo "FAIL: missing lean_fs_mmap_close_live in Extract.c"; exit 1; }
	@if grep -E 'lean_object|lean_inc|lean_dec|lean_alloc|initialize_|lean/lean\.h|lean_io_' $(EXTRACT_C) $(BYTES_C) $(NUMERICS_C) $(STATUS_C); then \
	  echo "FAIL: residual Lean object/RC/init/header/io in freestanding IR"; exit 1; \
	fi
	@if grep -E 'Prod|Slice|lean_ctor' $(EXTRACT_C) $(BYTES_C) $(NUMERICS_C) $(STATUS_C); then \
	  echo "FAIL: product/ctor residue in freestanding IR"; exit 1; \
	fi
	@grep -E 'memCopyGo|memFillGo' $(BYTES_C) >/dev/null \
	  || { echo "FAIL: R7 expected memCopyGo/memFillGo in Systems/Bytes.c"; exit 1; }
	@grep -E 'satAdd|satSub|rotateLeft|rotateRight' $(NUMERICS_C) >/dev/null \
	  || { echo "FAIL: R7 expected satAdd/satSub/rotateLeft/rotateRight in Systems/Numerics.c"; exit 1; }
	@grep -E 'andThen|orElse|valueOr' $(STATUS_C) >/dev/null \
	  || { echo "FAIL: R7 expected andThen/orElse/valueOr in Systems/Status.c"; exit 1; }
	@# no giant logGet/logPut statement expr in Extract; multi-module checksumGo extern
	@if grep -E 'lean_fs_log_get' $(EXTRACT_C) >/dev/null; then \
	  if grep -E 'lean_fs_log_get\([^)]*\)\{[^}]*\(\{' $(EXTRACT_C); then \
	    echo "FAIL: lean_fs_log_get still looks like a giant statement expr"; exit 1; \
	  fi; \
	fi
	@grep -E 'checksumGo' $(SCALARS_C) >/dev/null \
	  || { echo "FAIL: expected checksumGo in Systems/Scalars.c"; exit 1; }
	@grep -E 'extern.*checksumGo|checksumGo' $(EXTRACT_C) >/dev/null \
	  || { echo "FAIL: expected Extract to reference cross-module checksumGo"; exit 1; }
	@echo "OK: dual size_t checksum; multi-module Lean logGet; Arena Lean bodies; ISO C11; Sys; Log; MMap; no lean_object/product/init/lean.h"

# host proofs typecheck; dual-pipeline isolation both ways (host ¬FS; extract is FS)
EXTRACT_SETUP = lib/.lake/build/ir/Extract.setup.json
FS_SCALARS_SETUP = lib/.lake/build/ir/Systems/Scalars.setup.json
FS_SYS_SETUP = lib/.lake/build/ir/Systems/Sys.setup.json
FS_BYTES_SETUP = lib/.lake/build/ir/Systems/Bytes.setup.json
FS_NUMERICS_SETUP = lib/.lake/build/ir/Systems/Numerics.setup.json
FS_STATUS_SETUP = lib/.lake/build/ir/Systems/Status.setup.json
check-host: host
	@echo "=== S6 host specs typecheck (K9 dual pipeline) ==="
	@test -f $(HOST_OLEAN) || { echo "FAIL: missing $(HOST_OLEAN)"; exit 1; }
	@test -f $(HOST_SETUP) || { echo "FAIL: missing $(HOST_SETUP)"; exit 1; }
	@test -f $(EXTRACT_C) || { echo "FAIL: missing extract IR $(EXTRACT_C) (build lib first)"; exit 1; }
	@test -n "$(FS_LIBS)" || { echo "FAIL: empty freestanding link list from lake query"; exit 1; }
	@for f in $(FS_LIBS); do \
	  test -f "$$f" || { echo "FAIL: missing freestanding archive $$f"; exit 1; }; \
	done
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }
	@test -f $(EXTRACT_SETUP) || { echo "FAIL: missing $(EXTRACT_SETUP)"; exit 1; }
	@test -f $(FS_SCALARS_SETUP) || { echo "FAIL: missing $(FS_SCALARS_SETUP)"; exit 1; }
	@test -f $(FS_SYS_SETUP) || { echo "FAIL: missing $(FS_SYS_SETUP)"; exit 1; }
	@test -f $(FS_BYTES_SETUP) || { echo "FAIL: missing $(FS_BYTES_SETUP)"; exit 1; }
	@test -f $(FS_NUMERICS_SETUP) || { echo "FAIL: missing $(FS_NUMERICS_SETUP)"; exit 1; }
	@test -f $(FS_STATUS_SETUP) || { echo "FAIL: missing $(FS_STATUS_SETUP)"; exit 1; }
	@# Host package must NOT enable freestanding codegen
	@if grep -q '"compiler.freestanding"[[:space:]]*:[[:space:]]*true' $(HOST_SETUP); then \
	  echo "FAIL: host Host.setup.json has compiler.freestanding=true (must be host-only)"; \
	  cat $(HOST_SETUP); exit 1; \
	fi
	@echo "OK: host specs built without compiler.freestanding"
	@# Extract package MUST enable freestanding (other half of dual pipeline)
	@if ! grep -q '"compiler.freestanding"[[:space:]]*:[[:space:]]*true' $(EXTRACT_SETUP); then \
	  echo "FAIL: extract Extract.setup.json missing compiler.freestanding=true"; \
	  cat $(EXTRACT_SETUP); exit 1; \
	fi
	@echo "OK: extract built with compiler.freestanding=true"
	@# S11: Freestanding prelude modules must also be freestanding (symmetric to Extract)
	@if ! grep -q '"compiler.freestanding"[[:space:]]*:[[:space:]]*true' $(FS_SCALARS_SETUP); then \
	  echo "FAIL: Systems/Scalars.setup.json missing compiler.freestanding=true"; \
	  cat $(FS_SCALARS_SETUP); exit 1; \
	fi
	@if ! grep -q '"compiler.freestanding"[[:space:]]*:[[:space:]]*true' $(FS_SYS_SETUP); then \
	  echo "FAIL: Systems/Sys.setup.json missing compiler.freestanding=true"; \
	  cat $(FS_SYS_SETUP); exit 1; \
	fi
	@for setup in $(FS_BYTES_SETUP) $(FS_NUMERICS_SETUP) $(FS_STATUS_SETUP); do \
	  if ! grep -q '"compiler.freestanding"[[:space:]]*:[[:space:]]*true' "$$setup"; then \
	    echo "FAIL: $$setup missing compiler.freestanding=true"; cat "$$setup"; exit 1; \
	  fi; \
	done
	@echo "OK: Freestanding prelude + R7 stdlib built with compiler.freestanding=true"
	@# Structural: freestanding Extract.c must not name host Specs / host package
	@if grep -E 'Specs\.(Scalars|Checksum|Log)|systems_host|lp_systems__host_' $(EXTRACT_C); then \
	  echo "FAIL: freestanding Extract.c references host Specs/package (proofs must stay host-only)"; exit 1; \
	fi
	@# Structural packaging: archives must not carry host Lake mangling / host package symbols
	@# Real host computational mangles look like lp_systems__host_Specs_* (not Specs_* folklore).
	@if command -v nm >/dev/null 2>&1; then \
	  defs=$$(nm $(FS_BUNDLE) $(FS_LIBS) 2>/dev/null || nm -g $(FS_BUNDLE) $(FS_LIBS) 2>/dev/null || true); \
	  if echo "$$defs" | grep -E 'lp_systems__host_|systems__host_Specs|initialize_systems__host_'; then \
	    echo "FAIL: host Lake symbols leaked into freestanding static archives:"; \
	    echo "$$defs" | grep -E 'lp_systems__host_|systems__host_Specs|initialize_systems__host_'; \
	    exit 1; \
	  fi; \
	fi
	@# Negative: host lakefile must keep leanOptions empty of freestanding (explicit leanOptions := #[])
	@if grep -E '⟨`compiler\.freestanding|compiler\.freestanding[[:space:]]*,[[:space:]]*true' host/lakefile.lean; then \
	  echo "FAIL: host/lakefile.lean must not set compiler.freestanding"; exit 1; \
	fi
	@if ! grep -q 'leanOptions := #\[\]' host/lakefile.lean; then \
	  echo "FAIL: host/lakefile.lean must keep explicit leanOptions := #[]"; exit 1; \
	fi
	@echo "OK: dual pipeline isolated (host ¬FS; extract FS; host proofs ∉ Extract.c / .a)"

# Systems Lean packaging: ordered multi-archive list + compiler.freestanding injection
check-s12: lake
	@echo "=== Systems Lean packaging: multi-archive freestanding list ==="
	@test -n "$(FS_LIBS)" || { echo "FAIL: lake query Extract:freestanding empty"; exit 1; }
	@echo "FS_LIBS=$(FS_LIBS)"
	@for f in $(FS_LIBS); do \
	  test -f "$$f" || { echo "FAIL: missing freestanding archive $$f"; exit 1; }; \
	done
	@# Link list is Extract archive first, then freestanding needs (prelude)
	@first=$$(echo $(FS_LIBS) | awk '{print $$1}'); \
	  echo "$$first" | grep -q 'libfs_extract\.a$$' \
	    || { echo "FAIL: first archive should be Extract's libfs_extract.a, got $$first"; exit 1; }
	@n=$$(echo $(FS_LIBS) | wc -w); \
	  test "$$n" -ge 2 || { echo "FAIL: expected ≥2 archives from needs expansion, got $$n"; exit 1; }
	@# freestanding := true injects option even without manual leanOptions
	@test -f $(EXTRACT_SETUP) || { echo "FAIL: missing $(EXTRACT_SETUP)"; exit 1; }
	@if ! grep -q '"compiler.freestanding"[[:space:]]*:[[:space:]]*true' $(EXTRACT_SETUP); then \
	  echo "FAIL: Extract.setup.json missing compiler.freestanding=true from freestanding := true"; \
	  cat $(EXTRACT_SETUP); exit 1; \
	fi
	@if ! grep -q '"compiler.freestanding"[[:space:]]*:[[:space:]]*true' $(FS_SCALARS_SETUP); then \
	  echo "FAIL: Systems/Scalars.setup.json missing freestanding option"; \
	  cat $(FS_SCALARS_SETUP); exit 1; \
	fi
	@# Harness lakefile uses freestanding facet / flag, not only raw static + manual options
	@grep -q 'freestanding := true' lib/lakefile.lean \
	  || { echo "FAIL: lib/lakefile.lean should set freestanding := true"; exit 1; }
	@grep -qE 'LeanLib\.(freestandingFacet|freestandingBundleFacet)' lib/lakefile.lean \
	  || { echo "FAIL: lib/lakefile.lean should use freestandingFacet or freestandingBundleFacet"; exit 1; }
	@! grep -E 'leanOptions := #\[⟨`compiler\.freestanding' lib/lakefile.lean \
	  || { echo "FAIL: lib/lakefile.lean should not hand-roll compiler.freestanding leanOptions"; exit 1; }
	@echo "OK: freestanding multi-archive list + option injection"

# Systems Lean packaging: single combined freestanding.bundle for the consumer link line
check-s13: lake
	@echo "=== Systems Lean packaging: freestanding.bundle (one archive) ==="
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: lake query Extract:freestanding.bundle empty"; exit 1; }
	@echo "FS_BUNDLE=$(FS_BUNDLE)"
	@n=$$(echo $(FS_BUNDLE) | wc -w); \
	  test "$$n" -eq 1 || { echo "FAIL: expected exactly 1 path from freestanding.bundle, got $$n"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing bundle archive $(FS_BUNDLE)"; exit 1; }
	@echo "$(FS_BUNDLE)" | grep -q 'libfs_extract_bundle\.a$$' \
	  || { echo "FAIL: bundle path should end with libfs_extract_bundle.a, got $(FS_BUNDLE)"; exit 1; }
	@# Bundle must be larger than Extract-only archive (includes Freestanding objects)
	@extract_a=$$(echo $(FS_LIBS) | awk '{print $$1}'); \
	  bsz=$$(wc -c < "$(FS_BUNDLE)"); \
	  esz=$$(wc -c < "$$extract_a"); \
	  test "$$bsz" -gt "$$esz" \
	    || { echo "FAIL: bundle size $$bsz should exceed Extract-only $$esz"; exit 1; }
	@grep -q 'LeanLib.freestandingBundleFacet' lib/lakefile.lean \
	  || { echo "FAIL: lib/lakefile.lean should use LeanLib.freestandingBundleFacet"; exit 1; }
	@# Smoke: linking only the bundle already done by run/check-deps; confirm no multi-path in FS_BUNDLE
	@echo "OK: single freestanding.bundle archive"

# `run` is a dependency so behavioral exit status is part of `check`.
# Memory-safety certificates on all freestanding-generated C (embedded + sidecar + independent verify).
check-memsafe: lake
	@echo "=== freestanding memory-safety certificates ==="
	@set -e; \
	test -f $(EXTRACT_C) || { echo "FAIL: missing $(EXTRACT_C)"; exit 1; }; \
	grep -q 'SYSTEMS_LEAN_MEMSAFE_CERT' $(EXTRACT_C) \
	  || { echo "FAIL: Extract.c missing embedded memory-safety certificate"; exit 1; }; \
	echo "OK: Extract.c embeds SYSTEMS_LEAN_MEMSAFE_CERT"; \
	for f in $(EXTRACT_C) \
	         lib/.lake/build/ir/Systems/Scalars.c \
	         lib/.lake/build/ir/Systems/Sys.c \
	         lib/.lake/build/ir/Systems/Bytes.c \
	         lib/.lake/build/ir/Systems/Numerics.c \
	         lib/.lake/build/ir/Systems/Status.c \
	         lib/.lake/build/ir/Systems/Mem.c \
	         lib/.lake/build/ir/Systems/BitOps.c \
	         lib/.lake/build/ir/Systems/Hash.c \
	         lib/.lake/build/ir/Systems/Parallelism/Simd.c \
	         lib/.lake/build/ir/Systems/Parallelism/ForkJoin.c \
	         lib/.lake/build/ir/Systems/Parallelism/Channel.c; do \
	  test -f "$$f" || { echo "FAIL: missing product C $$f (full matrix hard-required)"; exit 1; }; \
	  grep -q 'SYSTEMS_LEAN_MEMSAFE_CERT' "$$f" \
	    || { echo "FAIL: $$f missing embedded certificate"; exit 1; }; \
	  grep -q 'qtt_zero_quantity_erased' "$$f" \
	    || { echo "FAIL: $$f missing QTT 0-qty claim"; exit 1; }; \
	  grep -q 'SYSTEMS_LEAN_COMPCERT_MEMCERT' "$$f" \
	    || { echo "FAIL: $$f missing CompCert-oriented certificate"; exit 1; }; \
	  test -f "$$f.memsafe.cert" \
	    || { echo "FAIL: missing sidecar $$f.memsafe.cert"; exit 1; }; \
	  test -f "$$f.compcert.memcert" \
	    || { echo "FAIL: missing sidecar $$f.compcert.memcert"; exit 1; }; \
	  echo "OK: QTT memsafe + CompCert certs for $$f (+ sidecars)"; \
	done
	@lean verify_memsafe.lean
	@echo "OK: independent MemSafetyCert + CompCert-oriented certs on freestanding C"

# Real CompCert (ccomp) on freestanding-generated C after MemSafetyCert + CompCertCert claims.
# Optional for default `check` (classic / CI without unfree CompCert stay green).
# Prefer: export SYSTEMS_LEAN_COMPCERT_RESULT=/path/to/nix-result-with-bin-ccomp
# See check_compcert.sh header and doc/dev/systems-lean.md.
check-compcert: lake
	@chmod +x check_compcert.sh
	@./check_compcert.sh

# Negative: missing extract / missing certs must hard-fail (no ccomp required).
check-compcert-negatives:
	@chmod +x check_compcert_negatives.sh check_compcert.sh
	@./check_compcert_negatives.sh

# End-to-end proof receipt: Lean verifyEmbedded + CompCert ccomp + optional self-host nm.
# Fail-closed (exit ≠ 0) unless every required gate passes. See script/systems-proof-receipt.sh.
check-proof-receipt: lake
	@chmod +x $(abspath ../../../..)/script/systems-proof-receipt.sh check_compcert.sh
	@SYSTEMS_LEAN_COMPCERT_REQUIRE=1 \
	  $(abspath ../../../..)/script/systems-proof-receipt.sh \
	    $(OUT_DIR)/proof-receipt-full.txt $(EXTRACT_C) $(FS_BUNDLE)
	@echo "OK: proof receipt PASS → $(OUT_DIR)/proof-receipt-full.txt"

# Negative: incomplete / missing certs must make the receipt exit non-zero (no ccomp required).
check-proof-receipt-negatives:
	@chmod +x check_proof_receipt_negatives.sh $(abspath ../../../..)/script/systems-proof-receipt.sh
	@./check_proof_receipt_negatives.sh

# R6 self-host product gate: freestanding bundle must not need Init_shared/leanshared / U lean_* / U l_*.
# Standalone: ./script/systems-selfhost-link-check.sh  (from lean4 root)
# Full product path (install lean-systems + negatives + tiny): ./script/systems-selfhost.sh
check-selfhost: lake
	@chmod +x $(abspath ../../../..)/script/systems-selfhost-link-check.sh
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }
	@$(abspath ../../../..)/script/systems-selfhost-link-check.sh $(FS_BUNDLE)
	@echo "OK: check-selfhost (product nm gate)"

# Fail-closed negatives for the R6 nm gate (no Lake; requires cc for object fixtures).
check-selfhost-negatives:
	@chmod +x $(abspath ../../../..)/script/systems-selfhost-link-check-negatives.sh
	@$(abspath ../../../..)/script/systems-selfhost-link-check-negatives.sh

# R7 systems-stdlib product path (build already done by `lake`; nm + residual IR greps).
# INVENTORY=0: do not rewrite doc/dev inventory on every make check (refresh via systems-stdlib.sh).
check-stdlib: lake
	@chmod +x $(abspath ../../../..)/script/systems-stdlib.sh \
	  $(abspath ../../../..)/script/systems-stdlib-negatives.sh
	@SYSTEMS_LEAN_STDLIB_SKIP_BUILD=1 SYSTEMS_LEAN_STDLIB_INVENTORY=0 \
	  $(abspath ../../../..)/script/systems-stdlib.sh $(FS_BUNDLE)
	@$(abspath ../../../..)/script/systems-stdlib-negatives.sh
	@echo "OK: check-stdlib (R7 freestanding stdlib path + negatives)"

# Track C1: product Parallelism dual-path isolation (sequential L2, no pthread, L1 shaped-only).
# Product residual / ccomp matrix only — never requires -pthread or HW SIMD dogfood TUs.
check-par-dual-path: lake
	@chmod +x $(abspath ../../../..)/script/systems-par-dual-path-check.sh
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }
	@out=$$($(abspath ../../../..)/script/systems-par-dual-path-check.sh "$(FS_BUNDLE)" 2>&1); \
	  ec=$$?; \
	  printf '%s\n' "$$out"; \
	  if [ $$ec -ne 0 ]; then exit $$ec; fi; \
	  printf '%s\n' "$$out" | grep -qx 'PARALLELISM_DUAL_PATH_OK=1' \
	    || { echo "FAIL: missing greppable PARALLELISM_DUAL_PATH_OK=1"; exit 1; }; \
	  if printf '%s\n' "$$out" | grep -qE '^(PAR_DUAL_PATH_OK|PRODUCT_PAR_[A-Z0-9_]+)='; then \
	    echo "FAIL: dropped PAR_* / PRODUCT_PAR_* transition aliases must not be emitted"; exit 1; \
	  fi; \
	  printf '%s\n' "$$out" | grep -qx 'PRODUCT_PARALLELISM_L2_SEQUENTIAL=1' \
	    || { echo "FAIL: missing PRODUCT_PARALLELISM_L2_SEQUENTIAL=1"; exit 1; }; \
	  printf '%s\n' "$$out" | grep -qx 'PRODUCT_PARALLELISM_NO_PTHREAD=1' \
	    || { echo "FAIL: missing PRODUCT_PARALLELISM_NO_PTHREAD=1"; exit 1; }; \
	  printf '%s\n' "$$out" | grep -qx 'PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1' \
	    || { echo "FAIL: missing PRODUCT_PARALLELISM_L1_SHAPED_ONLY=1"; exit 1; }; \
	  printf '%s\n' "$$out" | grep -qx 'CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1' \
	    || { echo "FAIL: missing CONCURRENT_RUNTIME_ASSUMED_NOT_PROVED=1"; exit 1; }
	@echo "OK: check-par-dual-path (product sequential Parallelism isolation)"

check-par-dual-path-negatives:
	@chmod +x $(abspath ../../../..)/script/systems-par-dual-path-check-negatives.sh \
	  $(abspath ../../../..)/script/systems-par-dual-path-check.sh
	@$(abspath ../../../..)/script/systems-par-dual-path-check-negatives.sh
	@echo "OK: check-par-dual-path-negatives"

# Track C2: opt-in L2 pthread dogfood. NOT on product residual/ccomp matrix.
# Compile define SYSTEMS_LEAN_PAR_PTHREAD=1 (not an env var). Default `check` does not run this.
# Requires host pthread (Linux); fail closed if -pthread cannot link.
$(OUT_DIR)/main_par_pthread: main_par_pthread_smoke.c par_pthread.c lake | $(OUT_DIR)
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }
	cc -std=c11 -DSYSTEMS_LEAN_PAR_PTHREAD=1 -pthread \
	  -o $@ main_par_pthread_smoke.c par_pthread.c $(FS_BUNDLE) -pthread

check-par-pthread: $(OUT_DIR)/main_par_pthread
	$(OUT_DIR)/main_par_pthread > $(OUT_DIR)/run_par_pthread.out
	grep -q 'par_l2_backend: 0' $(OUT_DIR)/run_par_pthread.out
	grep -q 'par_l2_backend_pthread: 1' $(OUT_DIR)/run_par_pthread.out
	grep -q 'par_fork_join_pthread: 2 3 4 5' $(OUT_DIR)/run_par_pthread.out
	grep -q 'par_fork_join_pthread_n1: 10' $(OUT_DIR)/run_par_pthread.out
	grep -q 'par_fork_join_pthread_n0: ok' $(OUT_DIR)/run_par_pthread.out
	grep -q 'par_fork_join_n1: 5' $(OUT_DIR)/run_par_pthread.out
	grep -q 'par_fork_join_n0: ok' $(OUT_DIR)/run_par_pthread.out
	grep -q 'check-par-pthread: OK' $(OUT_DIR)/run_par_pthread.out
	@echo "OK: check-par-pthread (host dogfood; not product residual)"

# Join-fail induction (compile define FORCE_JOIN_FAIL). Not default check-par-pthread.
# Smoke expects rc=2 and must not grep buffer contents (fail-closed contract).
check-par-pthread-join-fail: lake | $(OUT_DIR)
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }
	cc -std=c11 -DSYSTEMS_LEAN_PAR_PTHREAD=1 -DSYSTEMS_LEAN_PAR_PTHREAD_FORCE_JOIN_FAIL=1 -pthread \
	  -o $(OUT_DIR)/main_par_pthread_join_fail \
	  main_par_pthread_join_fail_smoke.c par_pthread.c $(FS_BUNDLE) -pthread
	$(OUT_DIR)/main_par_pthread_join_fail > $(OUT_DIR)/run_par_pthread_join_fail.out
	grep -q 'par_fork_join_pthread_join_fail: 2' $(OUT_DIR)/run_par_pthread_join_fail.out
	grep -q 'par_fork_join_pthread_join_fail_buffers: untrusted' $(OUT_DIR)/run_par_pthread_join_fail.out
	grep -q 'par_fork_join_pthread_join_fail_n1_ok: 0' $(OUT_DIR)/run_par_pthread_join_fail.out
	grep -q 'check-par-pthread-join-fail: OK' $(OUT_DIR)/run_par_pthread_join_fail.out
	@# Must not claim complete map-add buffer contents on join-fail path.
	@! grep -qE 'par_fork_join_pthread: 2 3 4 5' $(OUT_DIR)/run_par_pthread_join_fail.out \
	  || { echo "FAIL: join-fail smoke must not assert buffer contents"; exit 1; }
	@echo "OK: check-par-pthread-join-fail (induced rc=2; buffers untrusted)"

# Track C3: opt-in L1 hardware SIMD dogfood (SSE2 when available; scalar fallback else).
# NOT on product residual/ccomp matrix. Product Simd.lean stays sequential chunked-4.
# SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1 → compile define forces scalar backend id=2.
PAR_SIMD_FORCE_SCALAR ?= 0
PAR_SIMD_CFLAGS := -std=c11 -O2
ifeq ($(SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR),1)
PAR_SIMD_CFLAGS += -DSYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1
endif
ifeq ($(PAR_SIMD_FORCE_SCALAR),1)
PAR_SIMD_CFLAGS += -DSYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1
endif

# Always recompile so SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1 is not stale-cached.
check-par-simd-hw: lake | $(OUT_DIR)
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }
	cc $(PAR_SIMD_CFLAGS) -o $(OUT_DIR)/main_par_simd_hw \
	  main_par_simd_hw_smoke.c par_simd_hw.c $(FS_BUNDLE)
	$(OUT_DIR)/main_par_simd_hw > $(OUT_DIR)/run_par_simd_hw.out
	@if [ "$(SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR)" = "1" ] || [ "$(PAR_SIMD_FORCE_SCALAR)" = "1" ]; then \
	  grep -q 'par_l1_backend_simd_hw: 2' $(OUT_DIR)/run_par_simd_hw.out \
	    || { echo "FAIL: force-scalar expected backend id 2"; cat $(OUT_DIR)/run_par_simd_hw.out; exit 1; }; \
	else \
	  grep -qE 'par_l1_backend_simd_hw: [12]' $(OUT_DIR)/run_par_simd_hw.out; \
	fi
	grep -q 'par_map_add_u8_simd_hw_n0: ok' $(OUT_DIR)/run_par_simd_hw.out
	grep -q 'par_map_add_u8_simd_hw_n1: 10' $(OUT_DIR)/run_par_simd_hw.out
	grep -q 'par_map_add_u8_simd_hw: OK' $(OUT_DIR)/run_par_simd_hw.out
	grep -q 'check-par-simd-hw: OK' $(OUT_DIR)/run_par_simd_hw.out
	@echo "OK: check-par-simd-hw (host dogfood; product L1 remains shaped-only)"

# Force-scalar dogfood path (always backend id=2; portable on x86_64).
check-par-simd-hw-scalar: lake | $(OUT_DIR)
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }
	cc -std=c11 -O2 -DSYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1 \
	  -o $(OUT_DIR)/main_par_simd_hw_scalar \
	  main_par_simd_hw_smoke.c par_simd_hw.c $(FS_BUNDLE)
	$(OUT_DIR)/main_par_simd_hw_scalar > $(OUT_DIR)/run_par_simd_hw_scalar.out
	grep -q 'par_l1_backend_simd_hw: 2' $(OUT_DIR)/run_par_simd_hw_scalar.out
	grep -q 'par_map_add_u8_simd_hw_n0: ok' $(OUT_DIR)/run_par_simd_hw_scalar.out
	grep -q 'par_map_add_u8_simd_hw_n1: 10' $(OUT_DIR)/run_par_simd_hw_scalar.out
	grep -q 'check-par-simd-hw: OK' $(OUT_DIR)/run_par_simd_hw_scalar.out
	@echo "OK: check-par-simd-hw-scalar (force-scalar backend id=2)"

# Unified host Par dogfood (pthread L2 + join-fail + HW SIMD L1 + force-scalar).
# Never part of default `check`. Default check-par-pthread stays without FORCE_JOIN_FAIL.
check-par-dogfood: check-par-pthread check-par-pthread-join-fail check-par-simd-hw check-par-simd-hw-scalar
	@echo "OK: check-par-dogfood (pthread + join-fail + simd-hw + force-scalar host paths)"

# ComplianceCorpus must be sorry/admit free (provably CompCert claim ladder).
check-sorry-free:
	@chmod +x $(abspath ../../../..)/script/systems-sorry-free-check.sh
	@$(abspath ../../../..)/script/systems-sorry-free-check.sh
	@echo "OK: check-sorry-free (ComplianceCorpus)"

# Provably CompCert compliant (accomplishment): ResidualFree ∧ SorryFree ∧ CertsVerify ∧ CcompAccepts
# with ccomp from ./ref only (REQUIRE_REF). Not on default `make check`.
# Greppable success: PROVABLY_COMPCERT_COMPLIANT=1 (never on failure; never with RESULT-only ccomp).
# Without ./ref ccomp this target fail-closes as tool discovery — use check-compcert-dogfood for RESULT.
check-compcert-compliant: lake
	@chmod +x $(abspath ../../../..)/script/systems-compcert-compliant.sh check_compcert.sh
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle from lake query"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing freestanding bundle $(FS_BUNDLE)"; exit 1; }
	@out=$$(SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
	  SYSTEMS_LEAN_COMPLIANT_BUNDLE="$(FS_BUNDLE)" \
	  SYSTEMS_LEAN_COMPCERT_REQUIRE=1 \
	  SYSTEMS_LEAN_COMPCERT_REQUIRE_REF=1 \
	  $(abspath ../../../..)/script/systems-compcert-compliant.sh 2>&1); \
	  ec=$$?; \
	  printf '%s\n' "$$out"; \
	  if [ $$ec -ne 0 ]; then exit $$ec; fi; \
	  printf '%s\n' "$$out" | grep -qx 'PROVABLY_COMPCERT_COMPLIANT=1' \
	    || { echo "FAIL: missing greppable PROVABLY_COMPCERT_COMPLIANT=1 on success"; exit 1; }; \
	  printf '%s\n' "$$out" | grep -q 'COMPCERT_DOGFOOD=1' \
	    && { echo "FAIL: dogfood token on accomplishment path"; exit 1; } || true
	@echo "OK: check-compcert-compliant"

# Dogfood only: RESULT/nix/PATH ccomp allowed. Prints COMPCERT_DOGFOOD=1 — never PROVABLY_…=1.
check-compcert-dogfood: lake
	@chmod +x $(abspath ../../../..)/script/systems-compcert-compliant.sh check_compcert.sh
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle"; exit 1; }
	@out=$$(SYSTEMS_LEAN_COMPLIANT_SKIP_BUILD=1 \
	  SYSTEMS_LEAN_COMPLIANT_ALLOW_RESULT=1 \
	  SYSTEMS_LEAN_COMPLIANT_BUNDLE="$(FS_BUNDLE)" \
	  SYSTEMS_LEAN_COMPCERT_REQUIRE=1 \
	  $(abspath ../../../..)/script/systems-compcert-compliant.sh 2>&1); \
	  ec=$$?; \
	  printf '%s\n' "$$out"; \
	  if [ $$ec -ne 0 ]; then exit $$ec; fi; \
	  printf '%s\n' "$$out" | grep -qx 'COMPCERT_DOGFOOD=1' \
	    || { echo "FAIL: missing greppable COMPCERT_DOGFOOD=1 on dogfood success"; exit 1; }; \
	  printf '%s\n' "$$out" | grep -q 'PROVABLY_COMPCERT_COMPLIANT=1' \
	    && { echo "FAIL: PROVABLY token on dogfood path"; exit 1; } || true
	@echo "OK: check-compcert-dogfood"

# Negatives: residual/sorry/missing/REQUIRE_REF must exit ≠ 0 and never print success tokens.
check-compcert-compliant-negatives:
	@chmod +x $(abspath ../../../..)/script/systems-compcert-compliant-negatives.sh \
	  $(abspath ../../../..)/script/systems-compcert-compliant.sh
	@$(abspath ../../../..)/script/systems-compcert-compliant-negatives.sh
	@echo "OK: check-compcert-compliant-negatives"

# check includes selfhost positives + negatives (cheap; negatives need host cc).
# check-stdlib reuses the freestanding build (SKIP_BUILD; no inventory rewrite).
# check-par-dual-path: product sequential Par isolation (no pthread on residual matrix).
# check-compcert-compliant is opt-in (needs ccomp); not forced on default check.
# check-par-pthread / check-par-simd-hw are host dogfood only — NOT default check.
check: run check-nm check-deps check-gates check-ir check-host check-s12 check-s13 check-memsafe check-selfhost check-selfhost-negatives check-stdlib check-sorry-free check-par-dual-path
	@echo "Systems Lean checks passed"
	@echo "Note: optional CompCert dogfood: \`make check-compcert\` or \`make check-full\` (see README / systems-lean.md)"
	@echo "Note: provably CompCert compliant: \`make check-compcert-compliant\` (needs ccomp; see systems-lean.md)"
	@echo "Note: opt-in Par host dogfood: \`make check-par-pthread\` / \`make check-par-simd-hw\` / \`make check-par-dogfood\`"

# Full Systems Lean dogfood gate: classic checks + CompCert + end-to-end proof receipt.
# SYSTEMS_LEAN_ALLOW_NO_COMPCERT is ignored when SYSTEMS_LEAN_COMPCERT_REQUIRE=1.
check-full: check check-compcert-negatives check-proof-receipt-negatives
	@chmod +x check_compcert.sh
	@SYSTEMS_LEAN_COMPCERT_REQUIRE=1 ./check_compcert.sh
	@$(MAKE) check-proof-receipt
	@echo "Systems Lean full checks passed (including CompCert + proof receipt)"
	@echo "Note: accomplishment predicate: \`make check-compcert-compliant\`"

# Strategic validation scoreboard (root script). Core integrity gates must PASS.
# Optional: SYSTEMS_LEAN_VALIDATE_FULL=1 for full \`make check\` inside the harness.
# From lean4 root: ./script/systems-validate.sh
validate-systems:
	@chmod +x $(abspath ../../../..)/script/systems-validate.sh
	@$(abspath ../../../..)/script/systems-validate.sh
	@echo "OK: validate-systems (scoreboard above)"

clean:
	rm -rf $(OUT_DIR) lib/.lake lib/lake-manifest.json host/.lake host/lake-manifest.json

# Slake freestanding Proc dogfood (links FS_BUNDLE; independent of classic slake CLI).
.PHONY: check-slake-proc-dogfood
check-slake-proc-dogfood: lake
	$(MAKE) -C $(abspath ../../../slake/proc_dogfood) check

.PHONY: check-slake-depgraph-wire
check-slake-depgraph-wire: lake
	$(MAKE) -C $(abspath ../../../slake/depgraph_wire) check

.PHONY: check-slake-depgraph-cli
check-slake-depgraph-cli: lake
	$(MAKE) -C $(abspath ../../../slake/driver) >/dev/null 2>&1 || true
	cd $(abspath ../../../slake) && ./depgraph_cli_smoke.sh
