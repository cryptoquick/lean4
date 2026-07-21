# parallel_shaped

Tiny multi-root TOML package for A12 parallel native olean dogfood
(`SLAKE_NATIVE_OLEAN_JOBS=N`).

- `A.lean` and `B.lean` are independent (no mutual import).
- `Top.lean` imports both → plan-import DAG places A and B before Top.
- With `JOBS≥2`, ready-set wave1 can compile A and B concurrently; Top waits
  until both finished.

Honesty: fixture for **parallel host-lean olean wave subset** only — not
freestanding build TCB / not Lake job server TCB / not CLAIMED.
