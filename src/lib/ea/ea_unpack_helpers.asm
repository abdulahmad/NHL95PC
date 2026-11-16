; RefPack unpack.
bits 32
%include "hockey.inc"
section s_A2F40 progbits alloc exec nowrite align=1
extern _FtoS_, ColourRemap, KeyedDraw, RowCopyFunc, forcedecpt_, ShapeBankCount, ShapeBankEntry, ShapeBankEntryId
extern PutBlock, CopyRowShadowKeyed, RemapBytes, bcopy, BlitBlockShadow
global DrawArtShadow, DrawArtShadowOwnPos, FlipArtHorizontal, FlipArtVertical, RemapArt, RemapShapeBank, RemapShapeBank
;-----------------------------------------------------------------------------
; DrawArtShadow                                A2F40  95 PC, medium confidence
; Draws art keyed with colour 0FEh darkening the screen under it
;-----------------------------------------------------------------------------
DrawArtShadow:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push eax
        push ebx
        push edx
        call BlitBlockShadow
        add esp, byte 0Ch
        ret
.1:
        mov dword [RowCopyFunc], CopyRowShadowKeyed
        push eax
        push ebx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawArtShadowOwnPos                          A2F84  95 PC, medium confidence
; Draws shadow art at the position stored in its header
;-----------------------------------------------------------------------------
DrawArtShadowOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtShadow
        add esp, byte 0Ch
        ret
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+08h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        sub ebx, eax
        push ebx
        mov eax, dword [byte edx+06h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        sub ebx, eax
        push ebx
        push edx
        call DrawArtShadow
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; FlipArtHorizontal                            A2FD0  95 PC, medium confidence
; Mirrors art left to right and fixes its hotspot
;-----------------------------------------------------------------------------
FlipArtHorizontal:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov eax, dword [byte esp+018h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+018h]
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        mov dword [esp], eax
        mov eax, dword [byte esp+018h]
        add eax, byte 10h
        xor edi, edi
        cmp dword [esp], byte 0
        jle short .4
        mov esi, dword [byte esp+04h]
        sar esi, 1
.1:
        mov ebp, dword [byte esp+04h]
        add ebp, eax
        lea edx, [byte ebp-01h]
        xor ebx, ebx
        test esi, esi
        jle short .3
.2:
        mov cl, byte [eax]
        mov ch, byte [edx]
        mov byte [eax], ch
        mov byte [edx], cl
        inc eax
        dec edx
        inc ebx
        cmp ebx, esi
        jl short .2
.3:
        mov eax, ebp
        inc edi
        cmp edi, dword [esp]
        jl short .1
.4:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+018h]
        mov bx, word [byte edx+08h]
        sub eax, ebx
        mov word [byte edx+08h], ax
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; FlipArtVertical                              A3050  95 PC, medium confidence
; Mirrors art top to bottom and fixes its hotspot
;-----------------------------------------------------------------------------
FlipArtVertical:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, dword [byte esp+018h]
        mov esi, dword [byte esi+02h]
        sar esi, 10h
        mov eax, dword [byte esp+018h]
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        mov dword [esp], eax
        mov edx, dword [byte esp+018h]
        add edx, byte 10h
        dec eax
        imul eax, esi
        add eax, edx
        xor edi, edi
        lea ebx, [esi+esi]
        mov dword [byte esp+04h], ebx
        mov ebp, dword [esp]
        sar ebp, 1
        test ebp, ebp
        jle short .4
.1:
        xor ebx, ebx
        test esi, esi
        jle short .3
.2:
        mov cl, byte [edx]
        mov ch, byte [eax]
        mov byte [edx], ch
        mov byte [eax], cl
        inc edx
        inc eax
        inc ebx
        cmp ebx, esi
        jl short .2
.3:
        sub eax, dword [byte esp+04h]
        inc edi
        cmp edi, ebp
        jl short .1
.4:
        mov eax, dword [esp]
        mov edx, dword [byte esp+018h]
        mov bx, word [byte edx+0Ah]
        sub eax, ebx
        mov word [byte edx+0Ah], ax
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; RemapArt                                     A30D0  95 PC, medium confidence
; Translates every pixel of an art through the colour remap
;-----------------------------------------------------------------------------
RemapArt:
        mov ebx, dword [byte esp+04h]
        mov edx, dword [byte ebx+02h]
        sar edx, 10h
        mov eax, dword [byte ebx+04h]
        sar eax, 10h
        imul eax, edx
        push eax
        push ColourRemap
        lea eax, [byte ebx+010h]
        push eax
        call RemapBytes
        add esp, byte 0Ch
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; RemapShapeBank                               A30F8  95 PC, medium confidence
; Remaps every art in a shape bank except the '!' entries
;-----------------------------------------------------------------------------
RemapShapeBank:
        push esi
        push edi
        sub esp, byte 8
        mov edi, dword [byte esp+014h]
        xor esi, esi
        jmp short .3
.1:
        mov eax, esp
        push eax
        push esi
        push edi
        call ShapeBankEntryId
        add esp, byte 0Ch
        cmp byte [esp], 21h
        je short .2
        push esi
        push edi
        call ShapeBankEntry
        add esp, byte 8
        push eax
        call RemapArt
        add esp, byte 4
.2:
        inc esi
.3:
        push edi
        call ShapeBankCount
        add esp, byte 4
        cmp esi, eax
        jl short .1
        add esp, byte 8
        pop edi
        pop esi
        ret
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, ebx
        mov dword [byte ebx+0Ch], 0
        mov word [byte esp+08h], ds
        mov cl, byte [byte edi+015h]
        xor ebx, ebx
        cmp cl, 47h
        jb short .5
        jbe short .6
        cmp cl, 66h
        jb short .4
        jbe short .9
        cmp cl, 67h
        je short .6
        jmp near .14
.4:
        cmp cl, 65h
        je short .8
        jmp near .14
.5:
        cmp cl, 45h
        jb near .14
        jbe short .8
        jmp short .9
.6:
        cmp dword [byte edi+08h], byte 0
        jne short .7
        mov dword [byte edi+08h], 1
.7:
        sub cl, 2
.8:
        mov ebx, 1
.9:
        mov ebp, dword [edx]
        add ebp, byte 8
        mov dword [edx], ebp
        mov eax, dword [byte ebp-08h]
        mov dword [esp], eax
        mov eax, dword [byte ebp-04h]
        mov dword [byte esp+04h], eax
        cmp dword [byte edi+08h], byte 0FFFFFFFFh
        jne short .10
        mov dword [byte edi+08h], 6
.10:
        mov al, byte [byte edi+015h]
        and al, 5Fh
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, cl
        push eax
        push byte 3
        push ebx
        lea edx, [byte esp+010h]
        xor ecx, ecx
        push byte 27h
        mov eax, esi
        mov ebx, dword [byte edi+08h]
        call _FtoS_
        mov ah, byte [esi]
        cmp ah, 2Ah
        jne short .11
        mov byte [byte edi+016h], ah
.11:
        mov byte [byte esi+027h], 0
.12:
        cmp byte [esi], 20h
        jne short .13
        inc esi
        jmp short .12
.13:
        mov eax, esi
        mov edx, edi
        call forcedecpt_
        mov word [byte esp+08h], ds
        mov eax, esi
        mov dword [byte edi+08h], 0FFFFFFFFh
.14:
        mov edx, dword [byte esp+08h]
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
