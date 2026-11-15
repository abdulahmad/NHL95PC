; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B195C progbits alloc exec nowrite align=1
extern kaufmfont, unk_D8B4A
global sub_B195C, loc_B196D, loc_B197D, loc_B1986, loc_B199F, loc_B19A4, loc_B19BF, loc_B19C1
sub_B195C:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, unk_D8B4A
        mov edi, kaufmfont
        LD mov, ebx, esi
loc_B196D:
        LD cmp, ebx, edi
        je short loc_B197D
        nop
        nop
        nop
        nop
        and byte [ebx], 1
        add ebx, byte 6
        jmp short loc_B196D
loc_B197D:
        mov eax, 100h
        LD mov, edx, edi
        LD mov, ebx, esi
loc_B1986:
        LD cmp, ebx, edi
        je short loc_B19A4
        nop
        nop
        nop
        nop
        test byte [ebx], 2
        jne short loc_B199F
        movzx ecx, byte [byte ebx+01h]
        LD cmp, ecx, eax
        jae short loc_B199F
        LD mov, eax, ecx
        LD mov, edx, ebx
loc_B199F:
        add ebx, byte 6
        jmp short loc_B1986
loc_B19A4:
        LD cmp, edx, edi
        je short loc_B19BF
        nop
        nop
        nop
        nop
        LD mov, ebx, edx
        or byte [ebx], 2
        call dword [byte ebx+02h]
        cmp eax, byte 0
        jne short loc_B19C1
        nop
        nop
        nop
        nop
        jmp short loc_B197D
loc_B19BF:
        LD xor, eax, eax
loc_B19C1:
        pop edi
        pop esi
        pop edx
        pop ecx
        db 05Bh                                 ; insn: pop ebx
        db 0C3h                                 ; insn: ret
