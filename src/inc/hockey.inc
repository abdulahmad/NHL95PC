; NHL 95 PC: common include of every src/ file (the PC analogue of the Genesis stubinc includes).
; Only equates and macros: nothing here emits bytes, so adding a name never moves code.
%include "x86enc.inc"     ; LD op, dst, src: load-form reg,reg encodings
%include "structs.inc"    ; structure field offsets (player struct ...), from tools/struct_fieldmap.csv
