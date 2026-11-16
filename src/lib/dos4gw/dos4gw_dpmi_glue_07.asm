; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_A18FB progbits alloc exec nowrite align=1
extern IntrLoadRegs
global _DoINTR_
_DoINTR_:
        pusha
        push gs
        push fs
        push es
        push ds
        push edx
        call IntrLoadRegs
        push ebx
        push ds
        push ebp
        mov ebp, esp
        mov ebx, dword [byte ebp+0Ch]
        mov ds, word [byte ebp+010h]
        mov dword [ebx], eax
        pushf
        pop eax
        mov word [byte ebx+024h], ax
        mov dword [byte ebx+08h], ecx
        mov dword [byte ebx+0Ch], edx
        mov dword [byte ebx+014h], esi
        mov dword [byte ebx+018h], edi
        pop dword [byte ebx+010h]
        pop eax
        mov word [byte ebx+01Ch], ax
        pop dword [byte ebx+04h]
        o16 mov word [byte ebx+01Eh], es
        o16 mov word [byte ebx+020h], fs
        o16 mov word [byte ebx+022h], gs
        add esp, byte 8
        pop es
        pop fs
        pop gs
        popa
        ret
