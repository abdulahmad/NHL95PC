; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_A189E progbits alloc exec nowrite align=1
extern sub_A18D6
global __int386x_
__int386x_:
        push ebp
        push es
        push ebx
        push ds
        push edx
        call sub_A18D6
        push ds
        push edi
        mov ebp, esp
        mov edi, dword [byte ebp+08h]
        mov ds, word [byte ebp+0Ch]
        mov dword [edi], eax
        mov dword [byte edi+04h], ebx
        mov dword [byte edi+08h], ecx
        mov dword [byte edi+0Ch], edx
        mov dword [byte edi+010h], esi
        pop dword [byte edi+014h]
        sbb eax, eax
        mov dword [byte edi+018h], eax
        pop eax
        pop ebx
        pop ebx
        pop ebx
        mov word [byte ebx+06h], ax
        o16 mov word [ebx], es
        pop es
        pop ebp
        ret
