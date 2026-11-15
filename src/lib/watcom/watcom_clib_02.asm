; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8D2D8 progbits alloc exec nowrite align=1
extern findmemblock, sub_8D2F0
global FreeMemBlock
FreeMemBlock:
        mov edx, dword [byte esp+04h]
        push edx
        call findmemblock
        add esp, byte 4
        push eax
        call sub_8D2F0
        add esp, byte 4
        ret
        db 090h
