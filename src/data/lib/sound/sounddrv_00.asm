; The first four bytes of the data segment.
bits 32
%include "hockey.inc"
section s_C0000 progbits alloc noexec write align=1
global unk_C0000
unk_C0000:
db 01h,01h,01h,00h
