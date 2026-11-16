; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_EDF04 nobits alloc noexec write align=1
global RowTableDefault
RowTableDefault:
        resb 8444
