; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_A1877 progbits alloc exec nowrite align=1
extern byte_D5440
global __EnterWVIDEO_, loc_A1891, loc_A189A
__EnterWVIDEO_:
        cmp byte [byte_D5440], 0
        je short loc_A189A
        and edx, 0FFFFh
        push edx
        push eax
        int3
        jmp short loc_A1891
        push edi
        push esi
        dec ecx
        inc esp
        inc ebp
        dec edi
loc_A1891:
        mov eax, 1
        add esp, byte 8
        ret
loc_A189A:
        xor eax, eax
        ret
