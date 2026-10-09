# NHL 95 PC: build HOCKEY.EXE from the NASM sources in src/ and check it is byte-identical to the retail EXE.
#
#   make                      build/HOCKEY.EXE from src/ (needs your HOCKEY.EXE in the repo root, see README)
#   make HOCKEY_EXE=/path/to/HOCKEY.EXE
#   make -j8                  assemble in parallel
#   make clean
#
# Needs: nasm (2.15+), python3. The third-party DOS/16M loader, DOS/4GW kernel and Watcom wstub, the LE header
# fields and the fixup record order are taken from your HOCKEY.EXE (rebuild_exe.py extract); everything inside the
# LE objects (code, data, fixups) comes from src/.

HOCKEY_EXE ?= HOCKEY.EXE
PYTHON     ?= python3
NASM       ?= nasm
NASMFLAGS  := -O0 -f elf32 -I src/inc/

SRCS := $(wildcard src/cseg01/*.asm src/dseg02/*.asm)
OBJS := $(patsubst src/%.asm,build/obj/%.o,$(SRCS))
INCS := $(wildcard src/inc/*.inc)

.PHONY: all check extract clean
all: build/HOCKEY.EXE

# stubs + LE metadata + fixup order from your EXE (also checks its sha1)
build/parts/manifest.json: $(HOCKEY_EXE) segmap95pc.json tools/rebuild_exe.py
	$(PYTHON) tools/rebuild_exe.py extract $(HOCKEY_EXE) build/parts
extract: build/parts/manifest.json

build/obj/%.o: src/%.asm $(INCS)
	@mkdir -p $(dir $@)
	@$(NASM) $(NASMFLAGS) -o $@ $<

# link (Python), order the fixups like wlink, write the EXE, sha1 check (fails the build on mismatch)
build/HOCKEY.EXE: $(OBJS) build/parts/manifest.json src/segments.txt tools/link_src.py
	$(PYTHON) tools/link_src.py --obj build/obj --parts build/parts --out $@ || { rm -f $@; exit 1; }

check: build/HOCKEY.EXE

clean:
	rm -rf build/obj build/link build/HOCKEY.EXE
