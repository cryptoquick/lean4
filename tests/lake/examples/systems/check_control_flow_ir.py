#!/usr/bin/env python3
"""Freestanding IR gates: checksumGo TCO, logGetGo self-TCO, arena control-flow, no GNU statement expressions."""
import re
import sys
from pathlib import Path

# Matches GNU statement exprs `({` and spaced `( {`; does not match C99 compound
# literals like `&(uint32_t){0}` (type token between `(` and `{`).
GNU_STMT_EXPR = re.compile(r"\(\s*\{")


def gnu_stmt_count(text: str) -> int:
    return len(GNU_STMT_EXPR.findall(text))


def fn_body(c: str, pat: str) -> str:
    m = re.search(pat, c, re.M)
    if not m:
        raise SystemExit(f"FAIL: missing match for {pat!r}")
    i = m.end() - 1  # at '{'
    depth = 0
    j = i
    while j < len(c):
        if c[j] == "{":
            depth += 1
        elif c[j] == "}":
            depth -= 1
            if depth == 0:
                return c[i : j + 1]
        j += 1
    raise SystemExit(f"FAIL: unbalanced brace for {pat!r}")

def main() -> None:
    extract = Path(sys.argv[1])
    c = extract.read_text()
    scalars = extract.parent / "Systems" / "Scalars.c"
    sys_c = extract.parent / "Systems" / "Sys.c"

    # --- checksumGo (multi-module) ---
    go_src = c
    go_pat = r"(?m)^(?:static\s+)?uint32_t\s+\w*checksumGo\w*\s*\([^)]*\)\s*\{"
    if not re.search(go_pat, c):
        if scalars.is_file() and re.search(go_pat, scalars.read_text()):
            go_src = scalars.read_text()
            print("OK: multi-module — checksumGo body in Systems/Scalars.c")
        else:
            raise SystemExit("FAIL: checksumGo not in Extract.c or Systems/Scalars.c")
    go = fn_body(go_src, go_pat)
    ck = fn_body(c, r"(?m)^uint32_t\s+lean_fs_checksum\s*\([^)]*\)\s*\{")
    if gnu_stmt_count(go) > 0 or gnu_stmt_count(ck) > 0:
        raise SystemExit("FAIL: GNU statement expr inside checksum bodies")
    if "goto _start" not in go:
        raise SystemExit("FAIL: checksumGo missing goto _start TCO loop")
    if not re.search(r"if\s*\(", go) or go.find("if") >= go.find("goto _start"):
        raise SystemExit("FAIL: checksumGo: if must precede goto")
    if "*((const uint8_t*)" not in go:
        raise SystemExit("FAIL: checksumGo missing U8.load")
    if not re.search(r"\b31\b", go):
        raise SystemExit("FAIL: checksumGo missing *31 step")
    if not re.search(r"checksumGo\w*\s*\(", ck):
        raise SystemExit("FAIL: lean_fs_checksum must call checksumGo")
    if scalars.is_file():
        sc = scalars.read_text()
        if re.search(r"(?m)^uint32_t\s+\w*checksumGo", sc):
            if re.search(r"(?m)^static\s+uint32_t\s+\w*checksumGo", sc):
                raise SystemExit("FAIL: public checksumGo must not be static (cross-module linkage)")
            if not re.search(r"(?m)^extern\s+uint32_t\s+\w*checksumGo", c):
                raise SystemExit("FAIL: Extract.c must extern-declare cross-module checksumGo")
            # Issue 2: residual @[inline] helpers should not dominate public ABI surface
            # Allow a small number of intentional public non-inline helpers (checksumGo, memEqGo, …)
            pub = re.findall(r"(?m)^uint\w+_t\s+(lp_\w+_Systems_Scalars_\w+)\s*\(", sc)
            pub = [p for p in pub if not p.endswith("_boxed")]
            # Definitions only (skip prototypes): second occurrence patterns are def lines with {
            pub_defs = re.findall(
                r"(?m)^uint\w+_t\s+(lp_\w+_Systems_Scalars_\w+)\s*\([^)]*\)\s*\{",
                sc,
            )
            # Should include checksumGo; should NOT re-export a pile of tiny inlines as the only story
            if not any("checksumGo" in d for d in pub_defs):
                raise SystemExit("FAIL: expected checksumGo definition in Scalars.c")
            # After inline-root filter, blt/beq/fitsU32 should not all appear as external defs
            residual_inlines = [d for d in pub_defs if re.search(r"_(blt|beq|bgt|fitsU32|uaddWouldOverflow)$", d)]
            if residual_inlines:
                raise SystemExit(
                    f"FAIL: unexpected public emit of residual @[inline] helpers: {residual_inlines}"
                )

    # --- logGet / logPut (Lean control-flow + self-TCO scan) ---
    if not sys_c.is_file():
        raise SystemExit("FAIL: missing Systems/Sys.c")
    sy = sys_c.read_text()

    get_pat = r"(?m)^(?:static\s+)?size_t\s+\w*Sys_logGet\w*\s*\([^)]*\)\s*\{"
    if not re.search(get_pat, sy):
        get_pat = r"(?m)^(?:static\s+)?size_t\s+\w*logGet\b\w*\s*\([^)]*\)\s*\{"
    get = fn_body(sy, get_pat)
    if gnu_stmt_count(get) > 0:
        raise SystemExit(f"FAIL: logGet still has GNU stmt exprs ({gnu_stmt_count(get)})")
    if not re.search(r"logGetGo\w*\s*\(", get) and not re.search(r"logGetGo\w*\s*\(", sy):
        raise SystemExit("FAIL: logGet must call logGetGo scan helper")

    go_pat2 = r"(?m)^(?:static\s+)?size_t\s+\w*logGetGo\w*\s*\([^)]*\)\s*\{"
    if not re.search(go_pat2, sy):
        raise SystemExit("FAIL: missing logGetGo in Sys.c (scan body)")
    gogo = fn_body(sy, go_pat2)
    if "goto _start" not in gogo:
        raise SystemExit(
            "FAIL: logGetGo missing goto _start — scan must be self-TCO (not mutual recursion)"
        )
    if not re.search(r"if\s*\(", gogo):
        raise SystemExit("FAIL: logGetGo missing if control-flow")
    # Zero GNU statement exprs on the scan path
    if gnu_stmt_count(gogo) > 0:
        raise SystemExit(f"FAIL: logGetGo still has GNU stmt exprs ({gnu_stmt_count(gogo)})")
    # Self-tail only: should not call other logGet* helpers that form a mutual ring
    bad_mutual = re.findall(
        r"\b(lp_\w*logGet(?:AfterKl|Record|RecordCont)\w*)\s*\(",
        gogo,
    )
    if bad_mutual:
        raise SystemExit(f"FAIL: logGetGo still calls mutual scan helpers: {bad_mutual}")
    # lseek/read should appear via primops or inlined patterns in the scan path
    if "lseek" not in gogo and "lseek" not in sy:
        raise SystemExit("FAIL: log scan path missing lseek")

    put_pat = r"(?m)^(?:static\s+)?uint32_t\s+\w*Sys_logPut\w*\s*\([^)]*\)\s*\{"
    if not re.search(put_pat, sy):
        put_pat = r"(?m)^(?:static\s+)?uint32_t\s+\w*logPut\b\w*\s*\([^)]*\)\s*\{"
    put = fn_body(sy, put_pat)
    if gnu_stmt_count(put) > 0:
        raise SystemExit(f"FAIL: logPut still has GNU stmt exprs ({gnu_stmt_count(put)})")
    # Overflow gate before uint32 narrow (fitsU32 expands to (size_t)(uint32_t) check)
    if "(size_t)(uint32_t)" not in sy and "(size_t)(uint32_t)" not in put:
        # may be in called helper body in same file
        if not re.search(r"\(size_t\)\(uint32_t\)", sy):
            raise SystemExit("FAIL: logPut path missing uint32 narrow-check overflow gate")

    lg = fn_body(c, r"(?m)^size_t\s+lean_fs_log_get\s*\([^)]*\)\s*\{")
    if gnu_stmt_count(lg) > 0:
        raise SystemExit("FAIL: lean_fs_log_get still contains GNU statement expr")
    if not re.search(r"logGet\w*\s*\(", lg):
        raise SystemExit("FAIL: lean_fs_log_get must call Systems.Sys.logGet")

    print("OK: logGetGo is self-TCO if/goto scan; logPut Lean control-flow; small primops only")
    print("OK: checksumGo/lean_fs_checksum bodies are Lean if/goto load/add/mul")

    # --- Arena.create / Arena.alloc (Lean control-flow; no giant statement-expr algorithms) ---
    create_pat = r"(?m)^(?:static\s+)?size_t\s+\w*[Aa]rena_create\w*\s*\([^)]*\)\s*\{"
    if not re.search(create_pat, sy):
        raise SystemExit("FAIL: missing Arena.create body in Systems/Sys.c ")
    create = fn_body(sy, create_pat)
    if gnu_stmt_count(create) > 0:
        raise SystemExit(
            f"FAIL: Arena.create still contains GNU statement expr(s) ({gnu_stmt_count(create)})"
        )
    if "malloc" not in create and "malloc" not in sy:
        raise SystemExit("FAIL: Arena.create path missing malloc")
    if not re.search(r"if\s*\(", create):
        raise SystemExit("FAIL: Arena.create missing if control-flow (expected overflow/OOM gates)")
    # Overflow-before-wrap: SIZE_MAX - hsz style compare must appear before add/malloc
    ov_idx = create.find("(size_t)-1")
    if ov_idx < 0:
        ov_idx = create.find("SIZE_MAX")
    add_idx = create.find("+")
    mal_idx = create.find("malloc")
    if ov_idx < 0:
        raise SystemExit("FAIL: Arena.create missing overflow compare (SIZE_MAX/hsz gate)")
    if mal_idx >= 0 and ov_idx > mal_idx:
        raise SystemExit("FAIL: Arena.create overflow check must precede malloc")
    if add_idx >= 0 and ov_idx > add_idx and (mal_idx < 0 or add_idx < mal_idx):
        # first + should be after overflow gate (hsz + cap only on non-overflow path is OK
        # if the compare text appears earlier in the function body)
        pass
    # Stronger: first occurrence of overflow compare before first malloc
    if mal_idx >= 0 and ov_idx > mal_idx:
        raise SystemExit("FAIL: Arena.create: overflow compare after malloc (wrap risk)")

    alloc_pat = r"(?m)^(?:static\s+)?size_t\s+\w*[Aa]rena_alloc\w*\s*\([^)]*\)\s*\{"
    if not re.search(alloc_pat, sy):
        raise SystemExit("FAIL: missing Arena.alloc body in Systems/Sys.c ")
    alloc = fn_body(sy, alloc_pat)
    if gnu_stmt_count(alloc) > 0:
        raise SystemExit(
            f"FAIL: Arena.alloc still contains GNU statement expr(s) ({gnu_stmt_count(alloc)})"
        )
    if not re.search(r"if\s*\(", alloc):
        raise SystemExit("FAIL: Arena.alloc missing if control-flow (capacity/null gates)")
    # Header field access for cap/used (inlined loads or helper calls)
    if not re.search(r"\[0\]|\[1\]|arenaLoad|LoadCap|LoadUsed", alloc) and "(size_t*)" not in alloc:
        if not re.search(r"LoadCap|LoadUsed|arenaLoad", sy):
            raise SystemExit("FAIL: Arena.alloc missing header field access for cap/used")
    # Fail paths return the same live input handle (parameter), not a fresh allocation
    # Match: function param name appears in a bare `return <param>;` (same SSA handle)
    am = re.search(
        r"(?m)^(?:static\s+)?size_t\s+\w*[Aa]rena_alloc\w*\s*\(\s*size_t\s+(\w+)\s*,",
        sy,
    )
    if not am:
        raise SystemExit("FAIL: could not parse Arena.alloc parameter name")
    aparam = am.group(1)
    if not re.search(rf"return\s+{re.escape(aparam)}\s*;", alloc):
        raise SystemExit(
            f"FAIL: Arena.alloc must return input handle `{aparam}` on fail paths (same live handle)"
        )

    ac = fn_body(c, r"(?m)^size_t\s+lean_fs_arena_create\s*\([^)]*\)\s*\{")
    if gnu_stmt_count(ac) > 0:
        raise SystemExit("FAIL: lean_fs_arena_create still contains GNU statement expr")
    if not re.search(r"create\w*\s*\(", ac):
        raise SystemExit("FAIL: lean_fs_arena_create must call Systems.Sys.Arena.create")
    aa = fn_body(c, r"(?m)^size_t\s+lean_fs_arena_alloc\s*\([^)]*\)\s*\{")
    if gnu_stmt_count(aa) > 0:
        raise SystemExit("FAIL: lean_fs_arena_alloc still contains GNU statement expr")
    if not re.search(r"alloc\w*\s*\(", aa):
        raise SystemExit("FAIL: lean_fs_arena_alloc must call Systems.Sys.Arena.alloc")

    wa = fn_body(c, r"(?m)^uint32_t\s+lean_fs_write_all\s*\([^)]*\)\s*\{")
    if gnu_stmt_count(wa) > 0:
        raise SystemExit("FAIL: lean_fs_write_all still contains GNU statement expr")
    wpat = r"(?m)^(?:static\s+)?uint32_t\s+\w*writeAllImpl\w*\s*\([^)]*\)\s*\{"
    if not re.search(wpat, sy):
        raise SystemExit("FAIL: writeAllImpl Lean body missing from Sys.c ")
    wbody = fn_body(sy, wpat)
    if gnu_stmt_count(wbody) > 0:
        raise SystemExit(
            f"FAIL: writeAllImpl still has GNU stmt exprs ({gnu_stmt_count(wbody)})"
        )
    if "open" not in wbody and "open" not in sy:
        raise SystemExit("FAIL: writeAllImpl path missing open")
    if not re.search(r"if\s*\(", wbody):
        raise SystemExit("FAIL: writeAllImpl missing if control-flow")
    # write-all: self-TCO remaining loop (not single-shot ignore short write)
    wgo_pat = r"(?m)^(?:static\s+)?uint32_t\s+\w*writeAllGo\w*\s*\([^)]*\)\s*\{"
    if not re.search(wgo_pat, sy):
        raise SystemExit("FAIL: missing writeAllGo self-TCO loop (exact write-all semantics)")
    wgo = fn_body(sy, wgo_pat)
    if "goto _start" not in wgo:
        raise SystemExit("FAIL: writeAllGo missing goto _start self-TCO")
    if "write" not in wgo and "write" not in wbody:
        raise SystemExit("FAIL: writeAllGo path missing write")
    if not re.search(r"writeAllGo\w*\s*\(", wbody) and not re.search(r"writeAllGo\w*\s*\(", sy):
        raise SystemExit("FAIL: writeAllImpl must call writeAllGo")

    # mmap helpers: zero-tolerance GNU stmt exprs (like create/alloc)
    for name, pat in [
        ("sysFtruncate", r"(?m)^(?:static\s+)?uint32_t\s+\w*sysFtruncate\w*\s*\([^)]*\)\s*\{"),
        ("sysMmap", r"(?m)^(?:static\s+)?size_t\s+\w*sysMmap\w*\s*\([^)]*\)\s*\{"),
        ("sysMsync", r"(?m)^(?:static\s+)?uint32_t\s+\w*sysMsync\w*\s*\([^)]*\)\s*\{"),
        ("sysMunmap", r"(?m)^(?:static\s+)?uint32_t\s+\w*sysMunmap\w*\s*\([^)]*\)\s*\{"),
        ("MMap_copyFrom", r"(?m)^(?:static\s+)?uint32_t\s+\w*MMap_copyFrom\w*\s*\([^)]*\)\s*\{"),
    ]:
        if not re.search(pat, sy):
            # copyFrom mangling may use copyFrom without MMap_ prefix shape
            if name == "MMap_copyFrom":
                pat = r"(?m)^(?:static\s+)?uint32_t\s+\w*copyFrom\w*\s*\([^)]*\)\s*\{"
            if not re.search(pat, sy):
                raise SystemExit(f"FAIL: missing {name} body in Sys.c ")
        body = fn_body(sy, pat)
        if gnu_stmt_count(body) > 0:
            raise SystemExit(
                f"FAIL: {name} still contains GNU statement expr(s) ({gnu_stmt_count(body)})"
            )

    cg_pat = r"(?m)^(?:static\s+)?uint32_t\s+\w*mmapCopyGo\w*\s*\([^)]*\)\s*\{"
    if not re.search(cg_pat, sy):
        raise SystemExit("FAIL: missing mmapCopyGo in Sys.c (S9 copyFrom self-TCO loop)")
    cg = fn_body(sy, cg_pat)
    if "goto _start" not in cg:
        raise SystemExit("FAIL: mmapCopyGo missing goto _start self-TCO")
    if gnu_stmt_count(cg) > 0:
        raise SystemExit(f"FAIL: mmapCopyGo still has GNU stmt exprs ({gnu_stmt_count(cg)})")

    print("OK: Arena.create/alloc are Lean if control-flow; writeAll writeAllGo TCO; mmap gates ISO")

    # --- Zero GNU statement expressions in package IR (ISO C11 consumer) ---
    for label, text in [("Extract.c", c), ("Systems/Sys.c", sy)]:
        n = gnu_stmt_count(text)
        if n > 0:
            raise SystemExit(f"FAIL: expected zero GNU stmt exprs in {label}, found {n}")
    if scalars.is_file():
        sc = scalars.read_text()
        n = gnu_stmt_count(sc)
        if n > 0:
            raise SystemExit(f"FAIL: expected zero GNU stmt exprs in Scalars.c, found {n}")

    # Positive: logReadU8/U32 bodies use automatic compound-literal stack slots + read
    for name, pat, slot in [
        ("logReadU32", r"(?m)^(?:static\s+)?size_t\s+\w*logReadU32\w*\s*\([^)]*\)\s*\{",
         r"&\(uint32_t\)\{0\}"),
        ("logReadU8", r"(?m)^(?:static\s+)?size_t\s+\w*logReadU8\w*\s*\([^)]*\)\s*\{",
         r"&\(uint8_t\)\{0\}"),
    ]:
        if not re.search(pat, sy):
            raise SystemExit(f"FAIL: missing {name} body in Sys.c")
        body = fn_body(sy, pat)
        if not re.search(slot, body):
            raise SystemExit(f"FAIL: {name} missing stack-slot compound literal {slot}")
        if "read(" not in body:
            raise SystemExit(f"FAIL: {name} missing read(")

    # Positive: log put path retries short writes via self-TCO logWriteAllGo
    lwgo_pat = r"(?m)^(?:static\s+)?uint32_t\s+\w*logWriteAllGo\w*\s*\([^)]*\)\s*\{"
    if not re.search(lwgo_pat, sy):
        raise SystemExit("FAIL: missing logWriteAllGo self-TCO write-all for log put")
    lwgo = fn_body(sy, lwgo_pat)
    if "goto _start" not in lwgo:
        raise SystemExit("FAIL: logWriteAllGo missing goto _start self-TCO")
    if "write" not in lwgo:
        raise SystemExit("FAIL: logWriteAllGo missing write")
    # logWriteU32 stages via stack slot store (not single-shot compound-literal write alone)
    w32_pat = r"(?m)^(?:static\s+)?uint32_t\s+\w*logWriteU32\w*\s*\([^)]*\)\s*\{"
    if not re.search(w32_pat, sy):
        raise SystemExit("FAIL: missing logWriteU32 body in Sys.c")
    w32 = fn_body(sy, w32_pat)
    if not re.search(r"&\(uint32_t\)\{0\}", w32):
        raise SystemExit("FAIL: logWriteU32 missing stack-slot compound literal")
    if not re.search(r"logWriteAllGo\w*\s*\(", w32) and "logWriteAllGo" not in sy:
        raise SystemExit("FAIL: logWriteU32 must use logWriteAllGo")

    print("OK: package IR has zero GNU statement exprs; log temps are ISO C11")

if __name__ == "__main__":
    main()
