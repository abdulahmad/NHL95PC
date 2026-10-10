# NHL 95 PC: build HOCKEY.EXE from the NASM sources in src/ and check it is byte-identical to the retail EXE.
#
#   make                      build/HOCKEY.EXE from src/ (needs your HOCKEY.EXE in the repo root, see README)
#   make HOCKEY_EXE=/path/to/HOCKEY.EXE
#   make -j8                  assemble in parallel
#   make clean
#   make CBUILD=0             asm only (default: C sources are compiled when the Watcom toolchain is found)
#   make FAST=1               C objects depend only on their .c file, not on src/c/include/*.h (quick loop while
#                             adding functions; header edits do not recompile every C file)
#   make fullcheck            from scratch: both builds (CBUILD=1 and CBUILD=0) with every C file recompiled;
#                             run this before every push
#
# C matching decompilation (docs/C_MATCHING.md): a function written in src/c/<segment>/<Func>.c replaces its asm
# block (wrapped in %ifdef CBUILD in src/cseg01/<segment>.asm) when CBUILD=1. wcc386 10.0 LA runs under DOSBox
# (tools/cc.py); the object becomes build/c/<segment>/<Func>.inc (db + dd label fixups) and is assembled in place.
# Both builds must give the same sha1.
#
# Needs: nasm (2.15+), python3. The third-party DOS/16M loader, DOS/4GW kernel and Watcom wstub, the LE header
# fields and the fixup record order are taken from your HOCKEY.EXE (rebuild_exe.py extract); everything inside the
# LE objects (code, data, fixups) comes from src/.

HOCKEY_EXE ?= HOCKEY.EXE
PYTHON     ?= python3
NASM       ?= nasm
NASMFLAGS  := -O0 -f elf32 -I src/inc/

CBUILD     ?= $(shell $(PYTHON) tools/cc.py check && echo 1 || echo 0)

# each mode has its own object tree, so switching CBUILD only reassembles what changed
OBJDIR := build/obj$(if $(filter 1,$(CBUILD)),,0)
SRCS := $(wildcard src/cseg01/*.asm src/dseg02/*.asm)
OBJS := $(patsubst src/%.asm,$(OBJDIR)/%.o,$(SRCS))
INCS := $(wildcard src/inc/*.inc)

.PHONY: all check extract clean cinfo fullcheck
all: build/HOCKEY.EXE

# C fragments the asm includes (only marked = matched functions are built)
ifeq ($(CBUILD),1)
NASMFLAGS += -DCBUILD -I build/
CINCS := $(addprefix build/,$(sort $(shell grep -ho '^%include "c/[^"]*\.inc"' src/cseg01/*.asm | cut -d'"' -f2)))
endif
CHDRS := $(if $(FAST),,$(wildcard src/c/include/*.h))
cinfo:
	@echo "CBUILD=$(CBUILD), $(words $(CINCS)) C files spliced"

.SECONDEXPANSION:
.PRECIOUS: build/c/%.obj build/c/%.inc
build/c/%.obj: src/c/%.c $(CHDRS) tools/cc.py
	@$(PYTHON) tools/cc.py compile $< -o $@
# build/c/<seg>/<File>.inc, or build/c/<seg>/<File>.<Func>.inc for a further function of a multi-block file
build/c/%.inc: build/c/$$(basename $$*).obj src/cseg01/$$(firstword $$(subst /, ,$$*)).asm tools/cc.py tools/cobj.py | build/parts/manifest.json
	@$(PYTHON) tools/cc.py frag src/c/$(basename $*).c $< $@

# stubs + LE metadata + fixup order from your EXE (also checks its sha1)
build/parts/manifest.json: $(HOCKEY_EXE) segmap95pc.json tools/rebuild_exe.py
	$(PYTHON) tools/rebuild_exe.py extract $(HOCKEY_EXE) build/parts
extract: build/parts/manifest.json

# relink (only) when the mode changes: both modes write build/HOCKEY.EXE
build/cbuild.$(CBUILD):
	@mkdir -p build; rm -f build/cbuild.*; touch $@

$(OBJDIR)/%.o: src/%.asm $(INCS) $$(if $(CINCS),$$(addprefix build/,$$(shell grep -ho '^.include "c/[^"]*\.inc"' src/$$*.asm | cut -d'"' -f2)))
	@mkdir -p $(dir $@)
	@$(NASM) $(NASMFLAGS) -o $@ $<

# link (Python), order the fixups like wlink, write the EXE, sha1 check (fails the build on mismatch)
build/HOCKEY.EXE: $(OBJS) build/parts/manifest.json src/segments.txt tools/link_src.py build/cbuild.$(CBUILD)
	$(PYTHON) tools/link_src.py --obj $(OBJDIR) --parts build/parts --out $@ || { rm -f $@; exit 1; }

check: build/HOCKEY.EXE

fullcheck:
	rm -rf build/obj build/obj0 build/c build/HOCKEY.EXE build/cbuild.*
	$(MAKE) -j$$(nproc) CBUILD=1
	$(MAKE) -j$$(nproc) CBUILD=0

clean:
	rm -rf build/obj build/obj0 build/link build/c build/HOCKEY.EXE build/cbuild.*
