; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8D2D8 progbits alloc exec nowrite align=1
extern findmemblock, sub_8D2F0
global FreeMemBlock
FreeMemBlock:
mov edx, dword [byte esp+04h]	; 8D2D8
push edx	; 8D2DC
call findmemblock	; 8D2DD
add esp, byte 4	; 8D2E2
push eax	; 8D2E5
call sub_8D2F0	; 8D2E6
add esp, byte 4	; 8D2EB
ret	; 8D2EE
db 090h
