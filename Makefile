# NHL 95 PC: build HOCKEY.EXE from the NASM sources in src/ and check it is byte-identical to the retail EXE.
#
#   make                      build/HOCKEY.EXE from src/ (needs retail/HOCKEY.EXE, see README)
#   make HOCKEY_EXE=/path/to/HOCKEY.EXE
#   make -j8                  assemble in parallel
#   make clean
#   make CBUILD=0             asm only (default: C sources are compiled when the Watcom toolchain is found)
#   make FAST=1               C objects depend only on their .c file, not on src/include/*.h (quick loop while
#                             adding functions; header edits do not recompile every C file)
#   make fullcheck            from scratch: both builds (CBUILD=1 and CBUILD=0) with every C file recompiled;
#                             run this before every push
#   make WATCOM_VER=la        compile the C with the 10.0 LA wcc386 instead of 10.0 GA (the default and the
#                             compiler HOCKEY.EXE was built with); the matched C is tuned for GA, so an LA build
#                             of CBUILD=1 is not expected to be byte-identical (BUILD_NOTES.md)
#
# C matching decompilation (docs/C_MATCHING.md): a function written in src/engine|front|pc/<mod>/<Func>.c
# (headers stay in src/include) replaces its asm block when CBUILD=1.
# Both builds must give the same sha1.
#
# Needs: nasm (2.15+), python3. The third-party DOS/16M loader, DOS/4GW kernel and Watcom wstub, the LE header
# fields and the fixup record order are taken from your HOCKEY.EXE (rebuild_exe.py extract); everything inside the
# LE objects (code, data, fixups) comes from src/.

HOCKEY_EXE ?= retail/HOCKEY.EXE
PYTHON     ?= python3
NASM       ?= nasm
NASMFLAGS  := -O0 -f elf32 -I src/inc/

WATCOM_VER ?= ga
export WATCOM_VER
CBUILD     ?= $(shell $(PYTHON) tools/cc.py check && echo 1 || echo 0)

# each mode has its own object tree, so switching CBUILD only reassembles what changed
OBJDIR := build/obj$(if $(filter 1,$(CBUILD)),,0)
SRCS := $(shell find src/engine src/front src/pc src/lib src/data -name '*.asm' 2>/dev/null | sort)
OBJS := $(patsubst src/%.asm,$(OBJDIR)/%.o,$(SRCS))
INCS := $(wildcard src/inc/*.inc)

.PHONY: all check extract clean cinfo fullcheck
all: build/HOCKEY.EXE

# C fragments the asm includes (only marked = matched functions are built)
ifeq ($(CBUILD),1)
NASMFLAGS += -DCBUILD -I build/
CINCS := $(addprefix build/,$(sort $(shell grep -rho '^%include "c/[^"]*\.inc"' src/engine src/front src/pc --include='*.asm' 2>/dev/null | cut -d'"' -f2)))
endif
CHDRS := $(if $(FAST),,$(wildcard src/include/*.h))
cinfo:
	@echo "CBUILD=$(CBUILD), WATCOM_VER=$(WATCOM_VER), $(words $(CINCS)) C files spliced"

# recompile the C (and relink) when the compiler changes
build/watcom.$(WATCOM_VER):
	@mkdir -p build; rm -f build/watcom.*; touch $@

.SECONDEXPANSION:
.PRECIOUS: build/c/%.obj build/c/%.inc build/c/engine/%.obj build/c/engine/%.inc build/c/front/%.obj build/c/front/%.inc build/c/pc/%.obj build/c/pc/%.inc
build/c/%.obj: src/c/%.c $(CHDRS) tools/cc.py build/watcom.$(WATCOM_VER)
	@$(PYTHON) tools/cc.py compile $< -o $@
build/c/engine/%.obj: src/engine/%.c $(CHDRS) tools/cc.py build/watcom.$(WATCOM_VER)
	@$(PYTHON) tools/cc.py compile $< -o $@
build/c/front/%.obj: src/front/%.c $(CHDRS) tools/cc.py build/watcom.$(WATCOM_VER)
	@$(PYTHON) tools/cc.py compile $< -o $@
build/c/pc/%.obj: src/pc/%.c $(CHDRS) tools/cc.py build/watcom.$(WATCOM_VER)
	@$(PYTHON) tools/cc.py compile $< -o $@
# build/c/<module>/<File>.inc, or build/c/<module>/<File>.<Func>.inc for a further function of a multi-block file
# leftover src/c: the asm is src/cseg01/<module>.asm
build/c/%.inc: build/c/$$(basename $$*).obj $$(subst /.asm,.asm,src/cseg01/$$(dir $$*).asm) tools/cc.py tools/cobj.py | build/parts/manifest.json
	@$(PYTHON) tools/cc.py frag src/c/$(basename $*).c $< $@
# colocated engine/front/pc: src/<top>/<mod>/<mod>.asm; fragments stay under build/c/<top>/
build/c/engine/%.inc: build/c/engine/$$(basename $$*).obj src/engine/$$(firstword $$(subst /, ,$$*))/$$(firstword $$(subst /, ,$$*)).asm tools/cc.py tools/cobj.py | build/parts/manifest.json
	@$(PYTHON) tools/cc.py frag src/engine/$(basename $*).c $< $@
build/c/front/%.inc: build/c/front/$$(basename $$*).obj src/front/$$(firstword $$(subst /, ,$$*))/$$(firstword $$(subst /, ,$$*)).asm tools/cc.py tools/cobj.py | build/parts/manifest.json
	@$(PYTHON) tools/cc.py frag src/front/$(basename $*).c $< $@
build/c/pc/%.inc: build/c/pc/$$(basename $$*).obj src/pc/$$(firstword $$(subst /, ,$$*))/$$(firstword $$(subst /, ,$$*)).asm tools/cc.py tools/cobj.py | build/parts/manifest.json
	@$(PYTHON) tools/cc.py frag src/pc/$(basename $*).c $< $@

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
	rm -rf build/obj build/obj0 build/c build/HOCKEY.EXE build/cbuild.* build/watcom.*
	$(MAKE) -j$$(nproc) CBUILD=1
	$(MAKE) -j$$(nproc) CBUILD=0

clean:
	rm -rf build/obj build/obj0 build/link build/c build/HOCKEY.EXE build/cbuild.* build/watcom.*
