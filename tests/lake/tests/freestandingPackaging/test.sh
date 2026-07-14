#!/usr/bin/env bash
source ../common.sh

./clean.sh

# S12 negative (also covered in targets): facet requires freestanding := true
# HostLib is not freestanding.
test_err 'is not freestanding' build HostLib:freestanding

# S12 fail-closed: freestanding packaging must not silently drop a non-freestanding lean_lib needs edge
test_err 'is not freestanding' build FsBad:freestanding

# S12 positive: freestanding := true injects compiler.freestanding into setup
# (FsA even sets leanOptions freestanding=false; flag forces true last).
test_run build FsA:freestanding
test -f .lake/build/ir/FsA.setup.json
match_pat '"compiler\.freestanding"[[:space:]]*:[[:space:]]*true' .lake/build/ir/FsA.setup.json
match_pat '"compiler\.freestanding"[[:space:]]*:[[:space:]]*true' .lake/build/ir/FsD.setup.json

# Archives exist
test -f .lake/build/lib/${LIB_PREFIX}fs_a.a
test -f .lake/build/lib/${LIB_PREFIX}fs_b.a
test -f .lake/build/lib/${LIB_PREFIX}fs_c.a
test -f .lake/build/lib/${LIB_PREFIX}fs_d.a

# Ordered multi-archive query: FsA first, then needs expansion with diamond dedup (FsD once)
mapfile -t paths < <($LAKE query FsA:freestanding)
echo "query FsA:freestanding -> ${paths[*]}"
test "${#paths[@]}" -eq 4 || {
  echo "FAIL: expected 4 unique freestanding archives (A,B,D,C), got ${#paths[@]}: ${paths[*]}"
  exit 1
}
echo "${paths[0]}" | grep -E "${LIB_PREFIX}fs_a\.a$" >/dev/null \
  || { echo "FAIL: first path should be fs_a.a, got ${paths[0]}"; exit 1; }
# All four present exactly once
for name in fs_a fs_b fs_c fs_d; do
  n=$(printf '%s\n' "${paths[@]}" | grep -cE "${LIB_PREFIX}${name}\.a$" || true)
  test "$n" -eq 1 || { echo "FAIL: expected exactly one ${name}.a, got $n in ${paths[*]}"; exit 1; }
done

# Non-library needs remain allowed (extraDep-style); HostLib arts build still works
test_run build HostLib

# Wave 3 packaging: single combined freestanding.bundle archive
test_run build FsA:freestanding.bundle
mapfile -t bundle < <($LAKE query FsA:freestanding.bundle)
echo "query FsA:freestanding.bundle -> ${bundle[*]}"
test "${#bundle[@]}" -eq 1 || {
  echo "FAIL: freestanding.bundle should return exactly 1 path, got ${#bundle[@]}: ${bundle[*]}"
  exit 1
}
test -f "${bundle[0]}" || { echo "FAIL: missing bundle archive ${bundle[0]}"; exit 1; }
echo "${bundle[0]}" | grep -E "${LIB_PREFIX}fs_a_bundle\.a$" >/dev/null \
  || { echo "FAIL: bundle path should be *fs_a_bundle.a, got ${bundle[0]}"; exit 1; }
# Bundle larger than Extract/FsA-only archive (includes deps)
asz=$(wc -c < .lake/build/lib/${LIB_PREFIX}fs_a.a)
bsz=$(wc -c < "${bundle[0]}")
test "$bsz" -gt "$asz" || {
  echo "FAIL: bundle size $bsz should exceed FsA-only $asz"
  exit 1
}
# Bundle facet also fail-closed without freestanding
test_err 'is not freestanding' build HostLib:freestanding.bundle

echo "Systems Lean freestanding packaging Lake unit tests OK"
rm -f produced.out