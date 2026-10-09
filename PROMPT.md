# Segment prompt

Paste this into a new Copilot Agent session. Opus 5.5, High. One segment only. Run it again for the next file. Do not edit this prompt.

```text
Read SEGMENT_AGENT.md before you edit any asm. It is the queue. Take the first row in the Queue that is not marked done. That file is the only segment this session. Do not start the file after it.

Build before you edit anything. Your retail HOCKEY.EXE must be in the repo root (sha1 3961e0eba6b0338fad1613bb534efafd9406ed4a). Run make. It must end with "MATCH: build/HOCKEY.EXE is byte-identical to the retail HOCKEY.EXE". If HOCKEY.EXE is missing or make does not MATCH, stop and say what you ran and what it printed.

src/ is the source. There is no listing in the repo. Every instruction line ends with "; <address>", the address in the EXE. Do not disassemble HOCKEY.EXE. Do not write a disassembler. Do not run tools/gen_src.py on src/. Do not delete an asm file. Edit the segment file in place. Do not edit src/segments.txt or a section line. Do not rewrite SEGMENT_AGENT.md as a whole file. Edit the current row in place. Do not append a history entry.

Follow the rules already in SEGMENT_AGENT.md. Style source is the matching routine in https://github.com/abdulahmad/NHLPA93Genesis (the PC engine follows 93 Genesis). Use https://github.com/abdulahmad/NHL94Genesis for what 94 added and https://github.com/abdulahmad/NHL95Genesis for what 95 added.

1. The data segments (src/dseg02) are not queue segments. If SEGMENT_AGENT.md names one as the current segment, move past it and take the next row. Data is not off limits: name every data and BSS label the current segment uses, in the dseg02 file that defines it, this session. src/inc/symbols.inc is the shared index of those names; tools/rename_symbol.py and tools/update_symbols.py keep it current. Never edit it by hand.
2. Library segments (Watcom runtime, DOS/4GW glue, EACSNDF, sound drivers, EA graphics/file/memory libraries) are not in the queue. You may name a library routine or its data when you know what it is.
3. Run python3 tools/auto_names.py <module>. For each function in the file, read its name_map_94.csv row, open the Genesis routine it points to, and line up the instruction sequences (calls, constants, structure fields, branch shape). Keep the Genesis name only when the body is the same routine. Reject a wrong generated name with a manual-reject row in tools/manual_names.csv.
4. Rename with tools/rename_symbol.py (one name) or tools/rename_symbol.py --batch (many; local labels in address order; per-line {source_game=..,confidence=..} or {no_record} options). Give --evidence for every function. A -5r alias label folds into its base with NEW = BASE-2 (dword_E03BA regd0-2). Function entries get the Genesis name or a name from what they do. loc_ labels become NASM locals (.x exit, .loop back-branch target, .1 .2 ... else; the 93G local where the routine lines up). A loc_ another function jumps to stays global with a name. Write structure fields as src/inc/structs.inc names with the same displacement size ([byte ecx+SCnum]).
5. Do not change a byte. Keep every encoding hint (byte, dword, short, near, strict, nosplit), every LD macro line, every db fallback, every "equ $+k" and every "; <address>" comment. Add comments: the 93G comment when the routine matches, else what it does, its register arguments (eax, edx, ebx, ecx) and its result.
6. Run make. It must print MATCH. Run python3 tools/update_symbols.py --check (up to date) and python3 tools/auto_names.py <module> (0 auto names defined in the file).
7. In SEGMENT_AGENT.md, mark that row done with the date, the number of functions named, and anything left. Set Current segment to the next row that is not done. Do not mark the next row done. Commit that segment alone: its file, the data files and src/inc files its names touched, the other src files where a renamed global is used, tools/manual_names.csv, name_map_94.csv (repo root, so `git add src tools` misses it), tools/global_map.csv, tools/struct_fieldmap.csv, SEGMENT_AGENT.md.

Stop after 5 failed builds. Report the file, the first differing address make printed, the built byte, the retail byte, and the line you changed. Do not continue.
```
