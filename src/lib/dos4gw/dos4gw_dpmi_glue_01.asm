; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_8DC9C progbits alloc exec nowrite align=1
extern int386x_, segread_
global int386_
;-----------------------------------------------------------------------------
; int386_                                                       8DC9C  library
; Run-time library int386: calls an interrupt
;-----------------------------------------------------------------------------
int386_:
        push ecx
        sub esp, byte 0Ch
        mov ecx, eax
        mov eax, esp
        call segread_
        mov eax, ecx
        mov ecx, esp
        call int386x_
        add esp, byte 0Ch
        pop ecx
        ret
