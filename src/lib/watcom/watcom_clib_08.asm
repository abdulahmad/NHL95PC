; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_90392 progbits alloc exec nowrite align=1
extern unlink_
global strcpy_, loc_90394, loc_903AE, strcat_, loc_903C4, loc_903E0, j_unlink_
strcpy_:
        push ecx
        push eax
loc_90394:
        mov cl, byte [edx]
        mov byte [eax], cl
        cmp cl, 0
        je short loc_903AE
        mov cl, byte [byte edx+01h]
        add edx, byte 2
        mov byte [byte eax+01h], cl
        add eax, byte 2
        cmp cl, 0
        jne short loc_90394
loc_903AE:
        pop eax
        pop ecx
        ret
strcat_:
        push ecx
        push esi
        push edi
        mov edi, eax
        mov esi, edx
        push es
        push ds
        pop es
        push edi
        LD sub, ecx, ecx
        dec ecx
        mov al, 0
        repne scasb
        dec edi
loc_903C4:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je near loc_903E0
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short loc_903C4
loc_903E0:
        pop edi
        pop es
        mov eax, edi
        pop edi
        pop esi
        pop ecx
        ret
j_unlink_:
        jmp near unlink_
        db 00h,00h,00h
