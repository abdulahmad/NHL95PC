; Per-player stat lines for the game in progress.
bits 32
%include "hockey.inc"
section s_DAC40 nobits alloc noexec write align=1
global byte_DACB3, byte_DAEA7, dword_DB086, dword_DB088, unk_DAC40, unk_DAC70, unk_DACA0, unk_DAE94
unk_DAC40:
resb 48
unk_DAC70:
resb 48
unk_DACA0:
resb 19
byte_DACB3:
resb 481
unk_DAE94:
resb 19
byte_DAEA7:
resb 479
dword_DB086:
resb 2
dword_DB088:
resb 2
