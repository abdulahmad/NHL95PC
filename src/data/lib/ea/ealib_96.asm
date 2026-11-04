; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_F1704 nobits alloc noexec write align=1
global byte_F1704, byte_F1705, byte_F1784, byte_F188C, byte_F188D, byte_F188E, dword_F1888, dword_F1890
global dword_F189C, unk_F1884
byte_F1704:
resb 1
byte_F1705:
resb 127
byte_F1784:
resb 256
unk_F1884:
resb 4
dword_F1888:
resb 4
byte_F188C:
resb 1
byte_F188D:
resb 1
byte_F188E:
resb 2
dword_F1890:
resb 12
dword_F189C:
resb 8
