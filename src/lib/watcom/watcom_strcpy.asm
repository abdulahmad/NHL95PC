; Watcom C runtime: strcpy, strcat, unlink jump.
bits 32
%include "hockey.inc"
section s_90392 progbits alloc exec nowrite align=1
extern unlink_
global strcpy_, strcat_, j_unlink_
;-----------------------------------------------------------------------------
; strcpy_                                                       90392  library
; Run-time library strcpy: copies a string
;-----------------------------------------------------------------------------
strcpy_:
        push ecx
        push eax
.1:
        mov cl, byte [edx]
        mov byte [eax], cl
        cmp cl, 0
        je short .2
        mov cl, byte [byte edx+01h]
        add edx, byte 2
        mov byte [byte eax+01h], cl
        add eax, byte 2
        cmp cl, 0
        jne short .1
.2:
        pop eax
        pop ecx
        ret
;-----------------------------------------------------------------------------
; strcat_                                                       903B1  library
; Run-time library strcat: appends a string
;-----------------------------------------------------------------------------
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
.1:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je near .2
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short .1
.2:
        pop edi
        pop es
        mov eax, edi
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; j_unlink_                                                     903E8  library
; Jump to unlink (deletes a file)
;-----------------------------------------------------------------------------
j_unlink_:
        jmp near unlink_
        db 00h,00h,00h
