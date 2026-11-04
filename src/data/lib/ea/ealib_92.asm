; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_EDAA8 nobits alloc noexec write align=1
global byte_EDABB, byte_EDCC0, byte_EDCC1, byte_EDCC3, byte_EDCC5, byte_EDCC7, dword_EDAA8, dword_EDAAC
global dword_EDAB0, dword_EDAB4, dword_EDABA, dword_EDCB8, dword_EDCBC, timercallbacks, unk_EDAB8, unk_EDBB8
global word_EDBCA
dword_EDAA8:
resb 4
dword_EDAAC:
resb 4
dword_EDAB0:
resb 4
dword_EDAB4:
resb 4
unk_EDAB8:
resb 2
dword_EDABA:
resb 1
byte_EDABB:
resb 253
unk_EDBB8:
resb 18
word_EDBCA:
resb 238
dword_EDCB8:
resb 4
dword_EDCBC:
resb 4
byte_EDCC0:
resb 1
byte_EDCC1:
resb 2
byte_EDCC3:
resb 2
byte_EDCC5:
resb 2
byte_EDCC7:
resb 21
timercallbacks:
resb 32
