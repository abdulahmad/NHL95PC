; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_90C0F progbits alloc exec nowrite align=1
extern _Extender
global CopyDtaIn
CopyDtaIn:
        cmp byte [_Extender], 9
        jne short .1
        push eax
        push ebx
        push ecx
        push esi
        push edi
        mov ah, 2Fh
        int 21h
        mov edi, ebx
        mov esi, edx
        mov ecx, 2Bh
        rep movsb
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop eax
.1:
        ret
