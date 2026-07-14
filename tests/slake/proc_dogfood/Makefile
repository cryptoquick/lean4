# Freestanding Systems.Proc dogfood for Slake (links product extract bundle).
#
# From repo root:
#   make -C tests/slake/proc_dogfood check
# or:
#   make -C tests/lake/examples/systems check-slake-proc-dogfood
#
# Requires prior freestanding product extract build (libfs_extract_bundle.a).

ROOT := $(abspath ../../..)
SYSTEMS_EX := $(ROOT)/tests/lake/examples/systems
LAKE ?= lake
# Prefer stage1 lake when present
ifneq ($(wildcard $(ROOT)/build/release/stage1/bin/lake),)
  LAKE := $(ROOT)/build/release/stage1/bin/lake
endif

FS_BUNDLE = $(shell $(LAKE) --dir=$(SYSTEMS_EX)/lib query Extract:freestanding.bundle 2>/dev/null)

.PHONY: all check clean

all: proc_dogfood

proc_dogfood: main.c
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle — build systems example first (make -C tests/lake/examples/systems lake)"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing $(FS_BUNDLE)"; exit 1; }
	cc -std=c11 -o $@ main.c $(FS_BUNDLE)

check: proc_dogfood
	./proc_dogfood
	@echo "check-slake-proc-dogfood: OK"

clean:
	rm -f proc_dogfood
