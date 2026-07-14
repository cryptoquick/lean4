/-
Copyright (c) 2026 Hunter Beast. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Hunter Beast
-/
module
prelude
public import Systems.Scalars
public import Systems.Numerics
public import Systems.Sys

/-!
# Systems.Proc (Systems Lean)

Freestanding **process spawn/wait** surface for Systems Lean extracts — affine `Pid`
handle over a raw POSIX `pid_t` (C ABI `size_t`), dual-param path/argv pointers as
null-terminated C string pointers (`USize`). Required core for Slake tool invocation
(Phase 1 MVP: argv0-only, multi-arg `argv` table, and residual-green **pipe/stdio
redirect** spawn).

Ops:

* **sysSpawn** / **sysSpawnArgv0** — `fork` + `execve(path, [argv0], empty env)`; child
  `_exit(127)` if exec fails; parent returns affine `Pid` (negative on fork failure)
* **sysSpawnArgv** — multi-arg spawn: `argvBase` is an array of `argc` C string pointers
  (`size_t` slots); builds a NULL-terminated `char* argv[argc+1]` for `execve`
* **sysPipe** — `pipe(2)` into a caller-owned `size_t[2]` buffer (`pipeFds[0]`=read,
  `pipeFds[1]`=write). Status `0` ok, `1` fail. No multi-field product return.
* **sysSpawnArgvPipe** — multi-arg spawn with optional stdin/stdout redirect: raw fd
  `USize` ends (`fdNone` / negative = no redirect). Child `dup2` then `execve`; parent
  returns `Pid`. Caller closes unused pipe ends honestly after spawn.
* **sysCloseRaw** — `close` a raw fd number (for pipe ends held as `USize`)
* **sysWait** — `waitpid`; **consumes** `Pid`; returns exit status encoded as `U32`
  (exited → exit code `0…255`; signaled → `256 | signal`; `0xFFFFFFFF` on invalid pid /
  wait fail / OOM after reap). **Fail-closed:** negative, zero, or out-of-range pid
  (not in `1…INT_MAX` for the cast-to-`int` waitpid ABI) never calls `waitpid` with a
  truncated id that could become `-1`/`0` (would reap unrelated children). **LP64**
  contract: product harness treats `Pid` as `size_t` but wait only accepts positive
  `pid_t`-shaped values.
* **pidIsNeg** / **pidIsZero** / **pidIsInvalidWait** / **intoUSize** — handle predicates
  and explicit raw unwrap

Honesty:

* **Not** a full shell, **not** PTY, **not** async job control, **not** full plumbing
  (no stderr redirect product, no shell `|` parser).
* **No PATH search claimed** — pass absolute or relative path pointer; `execve` does not
  search `PATH` (unlike `execvp`).
* Empty child environment (`envp = NULL`) — intentional; not a full process-image clone.
* Multi-arg: caller owns `argvBase` pointer slots; this module mallocs a private
  NULL-terminated table (freed on the parent path). Fail-closed: `argc == 0`,
  `argc ≥ maxArgc` (overflow fence before `malloc((argc+1)*sizeof(size_t))`), table OOM,
  or argv copy/store failure → free table when allocated and return `pidNeg1`.
* Pipe ends are raw `size_t` slots (not dual affine `Fd` products). **`sysPipe` sets
  `FD_CLOEXEC` on both ends** so unused opposite ends close on child `execve` (stdin-
  from-pipe EOF honesty). Parent may still use ends (CLOEXEC only fires on exec). Parent
  must still close ends it does not need after spawn. Feed a read end into
  `Systems.Sys.sysRead` / `sysClose` (ABI `size_t` ≡ `Fd`).
* CompCert dogfood: product TUs residual-clean; libc `fork`/`execve`/`_exit`/`waitpid`/
  `pipe`/`dup2`/`fcntl`/`close` are intentional TCB (freestanding EmitC includes
  `<unistd.h>` / `<fcntl.h>` / `<sys/wait.h>`).
* Affine: double-wait / use-after-wait is fail-closed at the type checker (same spirit as `Fd`).
* Classic `slake` CLI still uses `IO.Process` → `lake`; freestanding pipe spawn is available
  via extract/`tests/slake/proc_dogfood` without claiming residual_free host or full Lake parity.

## Intentional TCB (Proc-local)

POSIX process primops + width/exit constants + argv table load/store/alloc + pipe/dup2
are freestanding `@[extern]` axioms kept **here** (name-pinned on ComplianceCorpus).
Effect marker reuses `Systems.Sys.Sys`.
-/

namespace Systems.Proc

open Systems.Scalars
open Systems.Numerics
open Systems.Sys

/-- Affine process id (POSIX `pid_t` as freestanding scalar handle; C ABI `size_t`). -/
@[affine]
public structure Pid where
  raw : USize

/-- Consume affine `Pid` into a raw size_t for FFI. Explicit — projection is rejected by
the freestanding affine checker. Prefer `sysWait` for normal paths. -/
@[never_extract, extern c inline "(#1)"]
public axiom intoUSize (pid : Pid) : USize

/-- `fork()` — returns child pid to parent, `0` to child, negative on failure. -/
@[never_extract, extern c inline "((size_t)fork())"]
public axiom sysFork : Sys Pid

/-- `execve(path, argv={argv0, NULL}, envp=NULL)` — path/argv0 are C string pointers.
Empty environment. Returns only on failure (errno path); success replaces the process. -/
@[never_extract, extern c inline
  "((uint32_t)execve((const char*)(#1), (char *const[]){ (char*)(#2), (char*)0 }, (char *const*)0))"]
public axiom sysExecveArgv0 (path : USize) (argv0 : USize) : Sys U32

/-- `execve(path, argv, envp=NULL)` — `argv` is a NULL-terminated `char* const*` table. -/
@[never_extract, extern c inline
  "((uint32_t)execve((const char*)(#1), (char *const*)(#2), (char *const*)0))"]
public axiom sysExecveArgv (path : USize) (argv : USize) : Sys U32

/-- Load `size_t` slot `i` from a pointer table at `base` (argv string pointer). -/
@[extern c inline "((size_t)((const size_t*)(#1))[(size_t)(#2)])"]
public axiom loadArgvSlot (base : USize) (i : USize) : USize

/-- Store `size_t` slot `i` at pointer table `base`; returns `0` (dataflow-live). -/
@[never_extract, extern c inline
  "(((size_t*)(#1))[(size_t)(#2)] = (size_t)(#3), (uint32_t)0)"]
public axiom storeArgvSlot (base : USize) (i : USize) (v : USize) : U32

/-- `malloc(nSlots * sizeof(size_t))` for a private argv pointer table (0 on OOM). -/
@[never_extract, extern c inline "((size_t)malloc(((size_t)(#1)) * sizeof(size_t)))"]
public axiom allocArgvTable (nSlots : USize) : Sys USize

/-- `free(p)` then return `pid | (fold & 0)` so free + prior store status stay dataflow-live. -/
@[never_extract, extern c inline
  "((void)free((void*)(#1)), (size_t)((size_t)(#2) | (size_t)((uint32_t)(#3) & 0u)))"]
public axiom freeThenPid (p : USize) (pid : Pid) (fold : U32) : Pid

/-- `_exit(code)` — never returns; comma yields `0` for type-checking residual paths. -/
@[never_extract, extern c inline "((void)_exit((int)(#1)), (uint32_t)0)"]
public axiom sysExit (code : U32) : Sys U32

/-- `malloc(sizeof(int))` as raw pointer for wait status storage (0 on OOM). -/
@[never_extract, extern c inline "((size_t)malloc(sizeof(int)))"]
public axiom allocInt : Sys USize

/-- `malloc(2 * sizeof(int))` for a temporary `pipe(2)` pair buffer (0 on OOM). -/
@[never_extract, extern c inline "((size_t)malloc((size_t)2 * sizeof(int)))"]
public axiom allocInt2 : Sys USize

/-- `pipe(fds)` into an `int[2]` buffer. Returns `0` on success, `1` on failure. -/
@[never_extract, extern c inline "((uint32_t)((pipe((int*)(#1)) == 0) ? 0u : 1u))"]
public axiom pipeRaw (fds : USize) : Sys U32

/-- Load `int` slot `i` from an `int*` base as `size_t` (pipe ends). -/
@[extern c inline "((size_t)((const int*)(#1))[(size_t)(#2)])"]
public axiom loadIntSlot (base : USize) (i : USize) : USize

/-- `fcntl(fd, F_SETFD, FD_CLOEXEC)` — mark raw fd close-on-exec. `0` ok, `1` fail. -/
@[never_extract, extern c inline
  "((uint32_t)((fcntl((int)(#1), F_SETFD, FD_CLOEXEC) < 0) ? 1u : 0u))"]
public axiom setFdCloexec (fd : USize) : Sys U32

/-- `dup2(oldfd, newfd)` — returns `0` on success, `1` on failure.
`dup2` clears CLOEXEC on the **new** fd number; the old fd keeps its flags. -/
@[never_extract, extern c inline
  "((uint32_t)((dup2((int)(#1), (int)(#2)) < 0) ? 1u : 0u))"]
public axiom sysDup2Raw (oldFd : USize) (newFd : U32) : Sys U32

/-- `close(fd)` on a raw fd number (pipe ends held as `USize`). -/
@[never_extract, extern c inline "((uint32_t)close((int)(#1)))"]
public axiom sysCloseRaw (fd : USize) : Sys U32

/-- `free(p)` — comma yields `0`. -/
@[never_extract, extern c inline "((void)free((void*)(#1)), (uint32_t)0)"]
public axiom freePtr (p : USize) : Sys U32

/-- `waitpid(pid, st, 0)` — **consumes** affine `Pid`; writes status to `st` (`int*`).
Returns wait result as `USize` (pid or `(size_t)-1`). Requires freestanding `<sys/wait.h>`.
Caller must not pass negative/zero pid (use `sysWait` which fail-closes first). -/
@[never_extract, extern c inline "((size_t)waitpid((int)(#1), (int*)(#2), 0))"]
public axiom waitpidRaw (pid : Pid) (st : USize) : Sys USize

/-- `waitpid(pid, NULL, 0)` — **consumes** `Pid`; reaps without status storage (OOM path). -/
@[never_extract, extern c inline "((size_t)waitpid((int)(#1), (int*)0, 0))"]
public axiom waitpidNull (pid : Pid) : Sys USize

/-- Load `int` at pointer as `U32` bit-pattern. -/
@[extern c inline "((uint32_t)*(const int*)(#1))"]
public axiom loadInt (p : USize) : U32

/-- `1` if wait status looks exited (`(st & 127) == 0`). -/
@[extern c inline "((uint32_t)(((((int)(#1)) & 127) == 0) ? 1u : 0u))"]
public axiom waitIfExited (st : U32) : U32

/-- `1` if wait status looks signaled (POSIX `WIFSIGNALED` shape). -/
@[extern c inline "((uint32_t)(((((((int)(#1)) & 127) + 1) >> 1) > 0) ? 1u : 0u))"]
public axiom waitIfSignaled (st : U32) : U32

/-- Exit code bits `((st >> 8) & 255)` (WEXITSTATUS shape). -/
@[extern c inline "((uint32_t)((((unsigned int)((int)(#1))) >> 8) & 255u))"]
public axiom waitExitCode (st : U32) : U32

/-- Terminating signal bits `(st & 127)` (WTERMSIG shape). -/
@[extern c inline "((uint32_t)(((int)(#1)) & 127))"]
public axiom waitTermSig (st : U32) : U32

/-- Signaled-status base `256` (`0x100`); result is `256 | signal`. -/
@[extern c inline "((uint32_t)256)"] public axiom statusSigBase : U32

/-- Child `_exit` code when `execve` fails (127). -/
@[extern c inline "((uint32_t)127)"] public axiom exit127 : U32
/-- Wait/invalid/OOM failure sentinel (`0xFFFFFFFF` as decimal). -/
@[extern c inline "((uint32_t)4294967295u)"] public axiom waitFail : U32
/-- Four as `USize` (width pin for residual tables). -/
@[extern c inline "((size_t)4)"] public axiom fourUSize : USize
/-- Hard cap on multi-arg `argc` (4096). Fence before `malloc((argc+1)*sizeof(size_t))`. -/
@[extern c inline "((size_t)4096)"] public axiom maxArgc : USize
/-- Null/dummy pid after child exit path (unreachable). -/
@[extern c inline "((size_t)0)"] public axiom pidZero : Pid
/-- Fork-failure shaped negative pid (`(size_t)-1`). -/
@[extern c inline "((size_t)-1)"] public axiom pidNeg1 : Pid
/-- No-redirect sentinel for pipe spawn (`(size_t)-1`). -/
@[extern c inline "((size_t)-1)"] public axiom fdNone : USize
/-- POSIX `STDIN_FILENO` (0). -/
@[extern c inline "((uint32_t)0)"] public axiom stdinFileno : U32
/-- POSIX `STDOUT_FILENO` (1). -/
@[extern c inline "((uint32_t)1)"] public axiom stdoutFileno : U32
/-- One as `USize` (pipe write index / STDOUT raw compare). -/
@[extern c inline "((size_t)1)"] public axiom oneUSize : USize

/-- True when pid bit-pattern is negative (`(ssize_t)pid < 0`). -/
@[fs_borrow, extern c inline "(uint8_t)((ssize_t)(#1) < 0)"]
public axiom pidIsNegU8 (pid : Pid) : U8

/-- True when pid is zero (child after fork). -/
@[fs_borrow, extern c inline "(uint8_t)((ssize_t)(#1) == 0)"]
public axiom pidIsZeroU8 (pid : Pid) : U8

/-- True when raw pid `size_t > INT_MAX` (`2147483647`) — unsafe for cast-to-`int` waitpid. -/
@[fs_borrow, extern c inline "(uint8_t)((size_t)(#1) > (size_t)2147483647u)"]
public axiom pidIsAboveIntMaxU8 (pid : Pid) : U8

/-- True when a `size_t` bit-pattern is a negative `ssize_t` (waitpid error). -/
@[extern c inline "(uint8_t)((ssize_t)(#1) < 0)"]
public axiom usizeIsNegU8 (n : USize) : U8

/-- True when a raw fd `USize` is negative (`fdNone` / no redirect). -/
@[extern c inline "(uint8_t)((ssize_t)(#1) < 0)"]
public axiom fdRawIsNegU8 (fd : USize) : U8

@[fs_borrow, inline] public def pidIsNeg (pid : Pid) : Bool :=
  Bool.ofU8 (pidIsNegU8 pid)

@[fs_borrow, inline] public def pidIsZero (pid : Pid) : Bool :=
  Bool.ofU8 (pidIsZeroU8 pid)

@[fs_borrow, inline] public def pidIsAboveIntMax (pid : Pid) : Bool :=
  Bool.ofU8 (pidIsAboveIntMaxU8 pid)

/-- True when `sysWait` must fail-closed without calling `waitpid`.

**LP64 waitpid cast safety:** reject zero, negative (`ssize_t < 0`), or raw
`size_t > INT_MAX` (would truncate to a wrong `int`, e.g. `-1`/`0`, reaping
unrelated children). -/
@[fs_borrow, inline] public def pidIsInvalidWait (pid : Pid) : Bool :=
  Bool.casesOn (motive := fun _ => Bool) (pidIsNeg pid)
    (Bool.casesOn (motive := fun _ => Bool) (pidIsZero pid)
      (pidIsAboveIntMax pid)
      Bool.true)
    Bool.true

@[inline] public def usizeIsNeg (n : USize) : Bool :=
  Bool.ofU8 (usizeIsNegU8 n)

/-- True when raw fd is negative — treat as **no redirect** (`fdNone`). -/
@[inline] public def fdRawIsNone (fd : USize) : Bool :=
  Bool.ofU8 (fdRawIsNegU8 fd)

/-- Encode raw wait status:

* exited → exit code `0…255`
* signaled → `256 | signal` (documented `0x100 | signal`)
* else → raw status bits -/
public unsafe def encodeWaitStatus (st : U32) : U32 :=
  bifU32 (U32.beq (waitIfExited st) U32.one) (waitExitCode st)
    (bifU32 (U32.beq (waitIfSignaled st) U32.one)
      (U32.lor statusSigBase (waitTermSig st))
      st)

/-- `fork` + child `execve(path, [argv0], NULL)` / `_exit(127)`; parent returns `Pid`.

Path and argv0 are null-terminated C string pointers. No PATH search. Empty child env.

Uses `Bool.casesOn` (same residual path as `bifArena` / `bifU32`) so each arm consumes
`pid` exactly once: child discards zero-pid then exec/exit; parent returns the live pid.
Child path folds exec/exit results so EmitC cannot DCE the required side effects. -/
@[never_extract]
public unsafe def sysSpawnArgv0 (path : USize) (argv0 : USize) : Sys Pid :=
  let pid := sysFork
  Bool.casesOn (motive := fun _ => Pid) (pidIsZero pid)
    pid
    (let _d := intoUSize pid
     let ee := sysExecveArgv0 path argv0
     let _x := sysExit (U32.lor exit127 (U32.land ee U32.zero))
     pidNeg1)

/-- Spawn with `argv0 = path` (conventional single-arg image). -/
@[never_extract]
public unsafe def sysSpawn (path : USize) : Sys Pid :=
  sysSpawnArgv0 path path

/-- Copy `argc` pointer slots from `src` into `dst` (store status dataflow-used). -/
public unsafe def copyArgvGo (dst : USize) (src : USize) (i : USize) (argc : USize) : U32 :=
  bifU32 (USize.blt i argc)
    (let p := loadArgvSlot src i
     let st := storeArgvSlot dst i p
     bifU32 (U32.beq st U32.zero)
       (copyArgvGo dst src (USize.add i USize.one) argc)
       st)
    U32.zero

/-- `fork` + child `execve(path, argv[argc]+NULL, NULL)` / `_exit(127)`; parent returns `Pid`.

`argvBase` points to `argc` host `size_t` slots each holding a C string pointer.
Builds a private NULL-terminated table (`malloc((argc+1)*sizeof(size_t))`), copies
slots, then execs. Parent frees the table after fork. Fail-closed:

* `argc == 0` → `pidNeg1` (no empty multi-arg spawn; use `sysSpawn` / `sysSpawnArgv0`)
* `argc ≥ maxArgc` (4096) → `pidNeg1` (overflow fence before size multiply/malloc)
* table OOM → `pidNeg1`
* argv copy or NULL-terminator store failure → free table, `pidNeg1`
* No PATH search; empty child env. -/
@[never_extract]
public unsafe def sysSpawnArgv (path : USize) (argvBase : USize) (argc : USize) : Sys Pid :=
  Bool.casesOn (motive := fun _ => Pid) (USize.beq argc USize.zero)
    (Bool.casesOn (motive := fun _ => Pid) (USize.blt argc maxArgc)
      pidNeg1
      (let nSlots := USize.add argc USize.one
       let tab := allocArgvTable nSlots
       Bool.casesOn (motive := fun _ => Pid) (USize.beq tab USize.zero)
         (let stc := copyArgvGo tab argvBase USize.zero argc
          let stn := storeArgvSlot tab argc USize.zero
          let fold := U32.lor stc stn
          Bool.casesOn (motive := fun _ => Pid) (U32.beq fold U32.zero)
            (freeThenPid tab pidNeg1 fold)
            (let pid := sysFork
             Bool.casesOn (motive := fun _ => Pid) (pidIsZero pid)
               (freeThenPid tab pid fold)
               (let _d := intoUSize pid
                let ee := sysExecveArgv path tab
                let _x := sysExit (U32.lor exit127 (U32.land ee (U32.land fold U32.zero)))
                pidNeg1)))
         pidNeg1))
    pidNeg1

/-- Close two raw fds then free a temp buffer; status folds free into `base`. -/
public unsafe def close2Free (a : USize) (b : USize) (p : USize) (base : U32) : U32 :=
  let _c0 := sysCloseRaw a
  let _c1 := sysCloseRaw b
  let fe := freePtr p
  U32.lor base (U32.land (U32.lor _c0 (U32.lor _c1 fe)) U32.zero)

/-- `pipe(2)` into caller-owned `size_t[2]` at `pipeFds` (index 0 = read, 1 = write).

Uses a temporary `int[2]` for the libc call, sets **`FD_CLOEXEC` on both ends** (so
unused opposite ends close on child `execve`), then widens ends into the caller buffer.
Fail-closed: null `pipeFds`, OOM of temp pair, `pipe` failure, or cloexec failure → `1`
(and closes both ends on cloexec fail). Success → `0`.
Does **not** return a multi-field product (freestanding dual-param honesty).

**Opposite-end honesty:** after `sysSpawnArgvPipe` + `execve`, any pipe end still open
in the child that still has CLOEXEC is closed automatically. Parent CLOEXEC does not
block parent `read`/`write`/`close`. Parent must still close ends it does not need. -/
@[never_extract]
public unsafe def sysPipe (pipeFds : USize) : Sys U32 :=
  bifU32 (USize.beq pipeFds USize.zero) U32.one
    (let p := allocInt2
     bifU32 (USize.beq p USize.zero) U32.one
       (let st := pipeRaw p
        bifU32 (U32.beq st U32.zero)
          (let rd := loadIntSlot p USize.zero
           let wr := loadIntSlot p oneUSize
           let c0 := setFdCloexec rd
           bifU32 (U32.beq c0 U32.zero)
             (let c1 := setFdCloexec wr
              bifU32 (U32.beq c1 U32.zero)
                (let s0 := storeArgvSlot pipeFds USize.zero rd
                 let s1 := storeArgvSlot pipeFds oneUSize wr
                 let fe := freePtr p
                 U32.lor (U32.lor s0 s1) (U32.land fe U32.zero))
                (close2Free rd wr p U32.one))
             (close2Free rd wr p U32.one))
          (let fe := freePtr p
           U32.lor st (U32.land fe U32.zero))))

/-- Child stdin redirect: no-op when `stdinFd` is negative (`fdNone`); else `dup2` to 0
and close the original when it is not already stdin.

Opposite pipe ends created by `sysPipe` keep `FD_CLOEXEC` and close on `execve`. -/
public unsafe def childRedirectStdin (stdinFd : USize) : U32 :=
  bifU32 (fdRawIsNone stdinFd) U32.zero
    (let d := sysDup2Raw stdinFd stdinFileno
     bifU32 (U32.beq d U32.zero)
       (bifU32 (USize.beq stdinFd USize.zero) U32.zero (sysCloseRaw stdinFd))
       d)

/-- Child stdout redirect: no-op when `stdoutFd` is negative (`fdNone`); else `dup2` to 1
and close the original when it is not already stdout.

Opposite pipe ends created by `sysPipe` keep `FD_CLOEXEC` and close on `execve`. -/
public unsafe def childRedirectStdout (stdoutFd : USize) : U32 :=
  bifU32 (fdRawIsNone stdoutFd) U32.zero
    (let d := sysDup2Raw stdoutFd stdoutFileno
     bifU32 (U32.beq d U32.zero)
       (bifU32 (USize.beq stdoutFd oneUSize) U32.zero (sysCloseRaw stdoutFd))
       d)

/-- Apply optional stdin then stdout redirects in the child. `0` ok; non-zero fail. -/
public unsafe def childRedirect (stdinFd : USize) (stdoutFd : USize) : U32 :=
  let rs := childRedirectStdin stdinFd
  bifU32 (U32.beq rs U32.zero) (childRedirectStdout stdoutFd) rs

/-- `fork` + optional stdin/stdout `dup2` + child `execve(path, argv[argc]+NULL, NULL)`.

`stdinFd` / `stdoutFd` are raw fd numbers; negative (`fdNone`) means no redirect.
Same multi-arg fail-closed gates as `sysSpawnArgv`. Parent does **not** close pipe ends —
caller closes unused ends after spawn (honest ownership). Prefer `sysPipe` so opposite
ends have `FD_CLOEXEC` and close on child exec. Empty child env; no PATH search. -/
@[never_extract]
public unsafe def sysSpawnArgvPipe (path : USize) (argvBase : USize) (argc : USize)
    (stdinFd : USize) (stdoutFd : USize) : Sys Pid :=
  Bool.casesOn (motive := fun _ => Pid) (USize.beq argc USize.zero)
    (Bool.casesOn (motive := fun _ => Pid) (USize.blt argc maxArgc)
      pidNeg1
      (let nSlots := USize.add argc USize.one
       let tab := allocArgvTable nSlots
       Bool.casesOn (motive := fun _ => Pid) (USize.beq tab USize.zero)
         (let stc := copyArgvGo tab argvBase USize.zero argc
          let stn := storeArgvSlot tab argc USize.zero
          let fold := U32.lor stc stn
          Bool.casesOn (motive := fun _ => Pid) (U32.beq fold U32.zero)
            (freeThenPid tab pidNeg1 fold)
            (let pid := sysFork
             Bool.casesOn (motive := fun _ => Pid) (pidIsZero pid)
               (freeThenPid tab pid fold)
               (let _d := intoUSize pid
                let rr := childRedirect stdinFd stdoutFd
                Bool.casesOn (motive := fun _ => Pid) (U32.beq rr U32.zero)
                  (let _x := sysExit (U32.lor exit127 (U32.land rr (U32.land fold U32.zero)))
                   pidNeg1)
                  (let ee := sysExecveArgv path tab
                   let _x := sysExit (U32.lor exit127 (U32.land ee (U32.land fold U32.zero)))
                   pidNeg1))))
         pidNeg1))
    pidNeg1

/-- `waitpid`; **consumes** `Pid`; returns encoded exit status as `U32`.

Fail-closed (**LP64 waitpid cast safety**):

* invalid wait pid (`pidIsInvalidWait`: zero, negative, or raw `> INT_MAX`) → consume
  handle, return `waitFail` (**no** `waitpid` — avoids cast-to-`int` becoming `-1`/`0`)
* OOM of status slot → `waitpid(pid, NULL, 0)` to reap (avoid zombie), then `waitFail`
* waitpid error → `waitFail`
* exited → exit code `0…255`; signaled → `256 | signal`

Free result is folded into the status (`lor` with `land 0`) so effectful free is not DCE'd. -/
@[never_extract]
public unsafe def sysWait (pid : Pid) : Sys U32 :=
  bifU32 (pidIsInvalidWait pid)
    (let _d := intoUSize pid; waitFail)
    (let stPtr := allocInt
     bifU32 (USize.beq stPtr USize.zero)
       (let _wr := waitpidNull pid; waitFail)
       (let wr := waitpidRaw pid stPtr
        let st := loadInt stPtr
        let fe := freePtr stPtr
        let base := bifU32 (usizeIsNeg wr) waitFail (encodeWaitStatus st)
        U32.lor base (U32.land fe U32.zero)))

end Systems.Proc
