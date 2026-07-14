# Systems Lean example

End-to-end **Systems Lean** demo: freestanding Lean → one static C library → C consumer, plus host-only proofs.

**Canonical docs:** [`doc/dev/systems-lean.md`](../../../../doc/dev/systems-lean.md)

---

## What this shows

| You get | Example |
|---------|---------|
| Unboxed C exports | `lean_fs_add` |
| Dual-param buffers | `lean_fs_checksum`, `lean_fs_load_u8` |
| Thin Sys + affine Fd | open / write_all / close |
| Arenas | create / alloc / free (+ UAF gates) |
| Append log | put / get / sync / close |
| mmap durability | map → write → msync → unmap → reopen |
| Host proofs | `host/Specs/*` typecheck only (not in the `.a`) |

**Consumer link:** ISO C11, **one** freestanding archive, **no** Lean runtime dynlibs.

### Main C exports (from `lib/Extract.lean`)

Handles (`Fd`, `Arena`, `Log`, `MMap`, pointers) are `size_t` at the C boundary.

```c
uint64_t lean_fs_add(uint64_t x, uint64_t y);
uint32_t lean_fs_checksum(size_t addr, size_t len);
uint32_t lean_fs_load_u8(size_t addr);
size_t   lean_fs_open(size_t path, uint32_t flags, uint32_t mode);
uint32_t lean_fs_close(size_t fd);
size_t   lean_fs_read(size_t fd, size_t buf, size_t len);
size_t   lean_fs_write(size_t fd, size_t buf, size_t len);
uint32_t lean_fs_write_all(size_t path, size_t buf, size_t len);
size_t   lean_fs_arena_create(size_t cap);
size_t   lean_fs_arena_alloc(size_t arena, size_t nbytes);
size_t   lean_fs_arena_last_ptr(size_t arena);
uint32_t lean_fs_arena_free(size_t arena);
size_t   lean_fs_log_open(size_t path);
uint32_t lean_fs_log_put(size_t log, size_t k, size_t klen, size_t v, size_t vlen);
size_t   lean_fs_log_get(size_t log, size_t k, size_t klen, size_t out, size_t out_cap);
uint32_t lean_fs_log_sync(size_t log);
uint32_t lean_fs_log_close(size_t log);
size_t   lean_fs_mmap(size_t fd, size_t len, uint32_t prot, uint32_t flags, size_t off);
uint32_t lean_fs_msync(size_t addr, size_t len, uint32_t flags);
uint32_t lean_fs_munmap(size_t addr, size_t len);
```

Full prototypes (including smoke helpers) are declared in `main.c`.

---

## Quick start

```bash
# lean4 root, stage1 on PATH
export PATH="$PWD/build/release/stage1/bin:$PATH"
cd tests/lake/examples/systems
./test.sh
```

### Validate vs local `make check`

| Path | What runs |
|------|-----------|
| `./script/systems-validate.sh` (default) | `freestanding_check` = `make check-nm` + residual IR greps — pins **T** `lean_fs_*` exports (incl. Track A `u64_*`/`bv_*`/`set_*`); does **not** execute `main.c` |
| `SYSTEMS_LEAN_VALIDATE_FULL=1 ./script/systems-validate.sh` | `make check` — full harness including `run` (main.c stdout greps for Track A smokes) |
| `make run` / `make check` (this dir) | Always builds/links/runs `main.c` and greps stdout markers |

Prefer `FULL=1` after PRODUCT_STDLIB growth so behavioral smokes cannot drift silently.

Happy-path link (Systems Lean packaging):

```bash
cc -std=c11 -o out/main main.c \
  $(lake --dir=lib query Extract:freestanding.bundle)
```

Multi-archive list (tooling / debugging only):

```bash
lake --dir=lib query Extract:freestanding
```

---

## Layout

| Path | Role |
|------|------|
| `src/Systems/` (lean4 tree) | Systems Lean prelude — built via this package’s `srcDir` |
| `lib/Extract.lean` | `@[export_c]` product surface |
| `lib/lakefile.lean` | `freestanding := true` + bundle default facet |
| `host/` | Host specs (full Init; **not** freestanding) |
| `main.c` | C consumer (no `lean.h`) |
| `Makefile` / `test.sh` | Build, link, nm/readelf, gates, host isolation |

---

## Lake packaging

```lean
lean_lib Systems where
  freestanding := true
  defaultFacets := #[LeanLib.freestandingFacet]

lean_lib Extract where
  freestanding := true
  defaultFacets := #[LeanLib.freestandingBundleFacet]  -- one archive for cc
  needs := #[`@/Systems]
```

- `freestanding := true` **forces** `compiler.freestanding=true`.  
- **`freestanding.bundle`** — single combined static archive (happy path for `cc`).  
- **`freestanding`** — ordered multi-archive list (Extract + needs).  
- Non-freestanding `needs` lean_libs are a **hard error**.

---

## Dual pipeline

| | Host (`host/`) | Extract (`lib/`) |
|--|----------------|------------------|
| Freestanding? | No | Yes |
| Linked into C app? | No | Yes |

---

## Checks

Behavioral smoke, `nm` on the **bundle**, dynamic deps (libc only), negative ownership/symbol gates, IR/ISO C11 gates, host isolation, memory-safety + CompCert-oriented certificates. Success line: **`Systems Lean checks passed`**.

**Ownership fail suite (honest):** affine handles get `fail_*` elab gates under `make check` (Fd / Arena / Buf / Log / MMap — double-close, silent drop, UAF, borrow). **`Systems.ArenaPool` and `Systems.Mem` are dual-param / caller-owned** (no affine handle type product-side): coverage is IR presence + extract smoke, **not** a `fail_arena_pool_*` / `fail_mem_*` ownership gate — free-safety stays with the caller buffer / `Sys.Arena`.

Default `make check` / `./test.sh` does **not** require CompCert (`ccomp`). That keeps classic CI and hosts without unfree CompCert green.

| Target | CompCert? | Meaning |
|--------|-----------|---------|
| `./test.sh` | No | `clean.sh` then `make check` (from-scratch; **not** what root smoke runs) |
| `make check` | **No** | Classic Systems Lean checks (run, nm, deps, gates, IR, host, packaging, memsafe, **selfhost + selfhost-negatives**, **Par dual-path isolation**; no clean). Smoke’s freestanding half. Ownership gates use **per-fault-class** greps (`FS_ERR_DOUBLE` / `DROP` / `AFTER` / `UAF` / `BORROW`) — not a blanket QTT match. **Does not** require pthread or HW SIMD dogfood |
| `make check-par-dual-path` | No | Product Par isolation: sequential L2, no pthread / HW-SIMD on residual matrix (`script/systems-par-dual-path-check.sh` → `PARALLELISM_DUAL_PATH_OK=1`) |
| `make check-par-pthread` | No | **Opt-in host dogfood:** link `par_pthread.c` with `-DSYSTEMS_LEAN_PAR_PTHREAD=1 -pthread` (compile define, not env); smoke L2 backend id `1`. Not on residual/ccomp product matrix |
| `make check-par-pthread-join-fail` | No | Induce join-fail (`-DSYSTEMS_LEAN_PAR_PTHREAD_FORCE_JOIN_FAIL=1`); expects rc=`2`; **no** buffer content asserts |
| `make check-par-simd-hw` | No | **Opt-in host dogfood:** `par_simd_hw.c` SSE2 (or scalar fallback); export `lean_fs_par_map_add_u8_simd_hw`. Product L1 stays sequential chunked-4. Force scalar: `SYSTEMS_LEAN_PAR_SIMD_FORCE_SCALAR=1` or `make check-par-simd-hw-scalar` (backend id `2`) |
| `make check-par-simd-hw-scalar` | No | Force-scalar compile define dogfood (backend id `2`) |
| `make check-par-dogfood` | No | Runs `check-par-pthread` + `check-par-simd-hw` + `check-par-simd-hw-scalar` |
| `make check-selfhost` | No | R6 nm gate: product bundle needs no `U lean_*` / `U l_*` / Init_shared / leanshared (`script/systems-selfhost-link-check.sh`) |
| `make check-selfhost-negatives` | No | Missing/empty/`lean_ctor_get`/`lean_apply_*`/`lean_io_*`/`l_*`/shared residues must fail the nm gate (requires host `cc`) |
| `make check-memsafe` | No | Certificate attachment + `verify_memsafe.lean` |
| `make check-compcert` | Optional | Real `ccomp` on sealed freestanding C |
| `make check-compcert-negatives` | No | Missing extract / certs fail closed |
| `make check-proof-receipt` | Required by default | R4 aggregate: Lean verify ∧ ccomp ∧ optional nm |
| `make check-proof-receipt-negatives` | No | Incomplete / missing certs exit ≠ 0 |
| `make check-full` | **Required** | `check` + negatives + hard-require ccomp + proof receipt |

Repo-root integration matrix (elab QTT/memsafe + this `make check` + R6 self-host, no CompCert):

```bash
# From lean4 root, stage1 on PATH
./script/systems-lean-smoke.sh
# Optional: SYSTEMS_LEAN_SMOKE_SELFHOST=0 to skip R6 product path
# Optional: SYSTEMS_LEAN_SMOKE_FULL=1 ./script/systems-lean-smoke.sh  # → make check-full
# R6 only: ./script/systems-selfhost.sh   # installs out/systems-selfhost/bin/lean-systems
```

### Optional: real CompCert dogfood

After Lean seals freestanding C with `MemSafetyCert` + `CompCertCert`, strip cert footers and compile the pure TUs with CompCert:

```bash
# From lean4 root (prefer a nix result — host PATH ccomp / host LD_LIBRARY_PATH can segfault)
export NIXPKGS_ALLOW_UNFREE=1
# check_compcert.sh clears LD_LIBRARY_PATH when invoking nix ccomp
nix build --impure --expr "
  let flake = builtins.getFlake \"$PWD\";
      pkgs = import flake.inputs.nixpkgs {
        system = builtins.currentSystem; config.allowUnfree = true;
      };
  in pkgs.compcert
" -o result-compcert
export SYSTEMS_LEAN_COMPCERT_RESULT="$PWD/result-compcert"

cd tests/lake/examples/systems
lake --dir=lib build
make check-compcert          # Extract.o + Scalars.o + Sys.o under out/compcert/
# or full gate (classic checks + negatives + hard-require ccomp):
make check-full
```

Artifacts: `out/compcert/{Extract,Scalars,Sys}.{pure.c,o,s?}`, `ccomp.log`, `ccomp-version.txt`, `proof-receipt.txt`.

Negative harness (no CompCert install required): `make check-compcert-negatives` — missing extract / missing certs must fail closed.

### End-to-end proof receipt (R4)

Fail-closed aggregate gate (markers + **Lean** `MemSafetyCert.verifyEmbedded` / `CompCertCert.verifyEmbedded` via `verify_memsafe.lean` + real `ccomp` + optional self-host nm):

```bash
make check-proof-receipt            # writes out/proof-receipt-full.txt; exit 0 only on PASS
make check-proof-receipt-negatives  # missing / partial certs must exit ≠ 0
# make check-full includes both + hard-require CompCert
```

Or from lean4 root: `./script/systems-proof-receipt.sh`. Classic Lean never needs this.

Env flags:

| Variable | Meaning |
|----------|---------|
| `SYSTEMS_LEAN_COMPCERT_RESULT` | Nix result dir with `bin/ccomp` (preferred) |
| `SYSTEMS_LEAN_ALLOW_NO_COMPCERT=1` | `check-compcert` exits 0 with SKIP if no ccomp (**not** R3/R4 success) |
| `SYSTEMS_LEAN_COMPCERT_REQUIRE=1` | Refuse SKIP (`make check-full` / proof receipt sets this) |
| `SYSTEMS_LEAN_PROOF_RECEIPT_SKIP_SELFHOST=1` | Skip optional nm gate in the receipt |
| `SYSTEMS_LEAN_PROOF_RECEIPT_REQUIRE_SELFHOST=1` | Fail receipt if freestanding bundle / nm gate missing |

Canonical write-up: [`doc/dev/systems-lean.md`](../../../../doc/dev/systems-lean.md) (formal correctness layer + CompCert dogfood). **We are not CompCert.**

---

## Limitations

Restricted freestanding control-flow; dual-param buffers (not multi-field freestanding values); host models are correspondence proofs; packaging follows Lake `needs`. Usable Systems Lean spike on this branch — not a claim about every released Lean pin.
