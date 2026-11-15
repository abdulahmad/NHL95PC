; The stack the Watcom runtime uses.
bits 32
%include "hockey.inc"
section s_F7B88 nobits alloc noexec write align=1
global stackarea
stackarea:
resb 12296
