# Freestanding DepGraph wire dogfood for Slake (links product extract bundle).
#
# From repo root:
#   make -C tests/slake/depgraph_wire check
# or:
#   make -C tests/lake/examples/systems check-slake-depgraph-wire
#
# Requires prior freestanding product extract build (libfs_extract_bundle.a).

ROOT := $(abspath ../../..)
SYSTEMS_EX := $(ROOT)/tests/lake/examples/systems
LAKE ?= lake
ifneq ($(wildcard $(ROOT)/build/release/stage1/bin/lake),)
  LAKE := $(ROOT)/build/release/stage1/bin/lake
endif

FS_BUNDLE = $(shell $(LAKE) --dir=$(SYSTEMS_EX)/lib query Extract:freestanding.bundle 2>/dev/null)

.PHONY: all check clean

all: depgraph_wire

depgraph_wire: main.c
	@test -n "$(FS_BUNDLE)" || { echo "FAIL: empty freestanding.bundle — build systems example first (make -C tests/lake/examples/systems lake)"; exit 1; }
	@test -f "$(FS_BUNDLE)" || { echo "FAIL: missing $(FS_BUNDLE)"; exit 1; }
	cc -std=c11 -o $@ main.c $(FS_BUNDLE)

check: depgraph_wire
	./depgraph_wire
	@echo "check-slake-depgraph-wire: OK"

clean:
	rm -f depgraph_wire
