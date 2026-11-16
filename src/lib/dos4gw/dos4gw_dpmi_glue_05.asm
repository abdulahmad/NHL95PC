; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_A1877 progbits alloc exec nowrite align=1
extern byte_D5440
global __EnterWVIDEO_
__EnterWVIDEO_:
        cmp byte [byte_D5440], 0
        je short .2
        and edx, 0FFFFh
        push edx
        push eax
        int3
        jmp short .1
        push edi
        push esi
        dec ecx
        inc esp
        inc ebp
        dec edi
.1:
        mov eax, 1
        add esp, byte 8
        ret
.2:
        xor eax, eax
        ret
