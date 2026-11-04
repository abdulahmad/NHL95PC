; Tables for the sound drivers.
bits 32
%include "hockey.inc"
section s_F0000 nobits alloc noexec write align=1
global unk_F0000
unk_F0000:
resb 5892
