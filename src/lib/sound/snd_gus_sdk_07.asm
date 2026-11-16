; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B195C progbits alloc exec nowrite align=1
extern kaufmfont, GusInitTable
global GusRunInitTable
GusRunInitTable:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, GusInitTable
        mov edi, kaufmfont
        LD mov, ebx, esi
.1:
        LD cmp, ebx, edi
        je short .2
        nop
        nop
        nop
        nop
        and byte [ebx], 1
        add ebx, byte 6
        jmp short .1
.2:
        mov eax, 100h
        LD mov, edx, edi
        LD mov, ebx, esi
.3:
        LD cmp, ebx, edi
        je short .5
        nop
        nop
        nop
        nop
        test byte [ebx], 2
        jne short .4
        movzx ecx, byte [byte ebx+01h]
        LD cmp, ecx, eax
        jae short .4
        LD mov, eax, ecx
        LD mov, edx, ebx
.4:
        add ebx, byte 6
        jmp short .3
.5:
        LD cmp, edx, edi
        je short .6
        nop
        nop
        nop
        nop
        LD mov, ebx, edx
        or byte [ebx], 2
        call dword [byte ebx+02h]
        cmp eax, byte 0
        jne short .7
        nop
        nop
        nop
        nop
        jmp short .2
.6:
        LD xor, eax, eax
.7:
        pop edi
        pop esi
        pop edx
        pop ecx
        db 05Bh                                 ; insn: pop ebx
        db 0C3h                                 ; insn: ret
