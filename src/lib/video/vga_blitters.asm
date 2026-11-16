; The VGA blitters.
bits 32
%include "hockey.inc"
section s_B4CD8 progbits alloc exec nowrite align=1
extern ColourRemap, cliprect_y0, cliprect_y1, ScreenWidth, dword_D30BC, dword_D30C0, DrawDestBuffer, DrawVideoBase
extern CreateMcgaWindow, FillRectSpans, SetupRectFill
global VgaBlitKeyed, VgaBlitKeyedAtOwnPos, SetColorRemap, GetColorRemap, VgaBlitRemap, SetDrawBitmap, CreateBitmap, CreateBitmapJump
global FillRectColor, VgaBlitKeyedFlipVHot, VgaBlitKeyedFlipV, VgaBlitRemapFlipVHot, VgaBlitRemapFlipV, VgaBlitKeyedFlipHHot, VgaBlitKeyedFlipH, VgaBlitKeyedFlipHVHot
global VgaBlitKeyedFlipHV, VgaBlitRemapFlipHHot, VgaBlitRemapFlipH, VgaBlitRemapFlipHVHot, VgaBlitRemapFlipHV
VgaBlitKeyed:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitKeyedAtOwnPos+01Ah
VgaBlitKeyedAtOwnPos:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        cld
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        db 089h,05Dh,0E0h                       ; insn: mov [ebp-20h],ebx
        db 08Bh,03Bh                            ; insn: mov edi,[ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
.1:
        lodsb
        LD or, al, al
        jg short .2
        jl short .7
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        LD xor, ah, ah
        movsx ecx, ax
        lodsb
        cmp al, 0FFh
        je short .5
.3:
        LD sub, edx, ecx
        jle short .4
        rep stosb
        jmp short .1
.4:
        LD add, ecx, edx
        neg edx
        rep stosb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        jmp short .3
.5:
        LD add, edi, ecx
        LD sub, edx, ecx
        jg short .1
.6:
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-0Ch]
        jle short .6
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-0Ch]
        LD sub, edi, edx
        jmp short .1
.7:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
.8:
        LD sub, edx, ecx
        jle short .9
        rep movsb
        jmp short .1
.9:
        LD add, ecx, edx
        neg edx
        rep movsb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        LD or, ecx, ecx
        jg short .8
        jmp near .1
        db 00h
SetColorRemap:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edi, ColourRemap
        mov esi, dword [byte ebp+08h]
        mov ecx, 40h
        rep movsd
        pop edi
        pop esi
        leave
        ret
GetColorRemap:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        mov esi, ColourRemap
        mov ecx, 40h
        rep movsd
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+010h]
        mov edi, ColourRemap
        add edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+0Ch]
.1:
        test ecx, 3
        je short .2
        movsb
        dec ecx
        jmp short .1
.2:
        shr ecx, 2
        rep movsd
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitRemap+034h
VgaBlitRemap:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitRemap+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        cld
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
.1:
        lodsb
        LD or, al, al
        jg short .2
        jl short .7
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        LD xor, ah, ah
        movsx ecx, ax
        lodsb
        cmp al, 0FFh
        je short .5
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
.3:
        LD sub, edx, ecx
        jle short .4
        rep stosb
        jmp short .1
.4:
        LD add, ecx, edx
        neg edx
        rep stosb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        jmp short .3
.5:
        LD add, edi, ecx
        LD sub, edx, ecx
        jg short .1
.6:
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-0Ch]
        jle short .6
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-0Ch]
        LD sub, edi, edx
        jmp short .1
.7:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
.8:
        LD sub, edx, ecx
        jle short .10
.9:
        lodsb
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        stosb
        loop .9
        jmp near .1
.10:
        LD add, ecx, edx
        neg edx
.11:
        lodsb
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        stosb
        loop .11
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        LD or, ecx, ecx
        jg short .8
        jmp near .1
        db 00h,00h,00h
SetDrawBitmap:
        LD mov, edx, edi
        LD mov, eax, esi
        mov esi, dword [byte esp+04h]
        mov edi, ScreenWidth
        mov ecx, 0Ch
        rep movsd
        LD mov, edi, edx
        LD mov, esi, eax
        ret
        db 00h,00h,00h
CreateBitmap:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push edx
        push eax
        call CreateMcgaWindow
        add esp, byte 0Ch
        mov eax, dword [eax]
        ret
CreateBitmapJump:
        jmp near CreateMcgaWindow
        db 00h
FillRectColor:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFC8h
        lea eax, [byte ebp-038h]
        push eax
        push dword [byte ebp+014h]
        push dword [byte ebp+010h]
        push dword [byte ebp+0Ch]
        push dword [byte ebp+08h]
        call SetupRectFill
        add esp, byte 14h
        LD or, eax, eax
        jne short .1
        lea ebx, [byte ebp-038h]
        cmp dword [byte ebx+018h], byte 0
        jle short .1
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebx+01Ch], eax
        push ebx
        call FillRectSpans
        add esp, byte 4
.1:
        leave
        ret
VgaBlitKeyedFlipVHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitKeyedFlipV+034h
VgaBlitKeyedFlipV:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitKeyedFlipV+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        cld
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD xor, edi, edi
        LD xor, edx, edx
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        inc edi
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        inc edi
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mul dword [byte ebp-0Ch]
        LD mov, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-010h], ecx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-014h], edx
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        mov ecx, dword [byte ebp-0Ch]
        cmp eax, dword [dword_D30BC]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jle short .6
        LD sub, ecx, eax
        jle short .1
        inc edi
        LD mov, edx, eax
        jmp short .6
.4:
        inc edi
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-014h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-04h], ebx
        LD or, edi, edi
        jne short .7
        jmp near VgaBlitKeyedAtOwnPos+028h
.7:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-014h]
        LD or, edx, edx
        je short .12
        jl short .8
        jmp near .32
.8:
        LD mov, ebx, edx
        and ebx, 7FFFh
        inc ebx
        mov edx, 7FFFh
.9:
        lodsb
        LD or, al, al
        jg short .10
        jl short .11
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.10:
        LD xor, ah, ah
        LD mov, cx, ax
        inc esi
        LD sub, dx, cx
        jg short .9
        LD add, dx, bx
        jmp near .34
.11:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        LD add, esi, ecx
        LD sub, edx, ecx
        jg short .9
        LD add, edx, ecx
        LD sub, esi, ecx
        LD add, edx, ebx
        jmp near .28
.12:
        mov edx, dword [byte ebp-0Ch]
.13:
        lodsb
        LD or, al, al
        jg short .15
        jl near .25
.14:
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.15:
        LD xor, ah, ah
        movsx ecx, ax
        lodsb
        cmp al, 0FFh
        je short .20
.16:
        LD sub, edx, ecx
        jle short .17
        rep stosb
        jmp short .13
.17:
        LD add, ecx, edx
        neg edx
        rep stosb
        dec dword [byte ebp-010h]
        je short .14
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
.18:
        LD sub, ecx, edx
        je short .12
        jl short .19
        mov edx, dword [byte ebp-0Ch]
        jmp short .16
.19:
        jmp near .31
.20:
        LD add, edi, ecx
        LD sub, edx, ecx
        jg short .13
.21:
        dec dword [byte ebp-010h]
.22:
        je short .14
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-018h]
        jg short .24
.23:
        add edx, dword [byte ebp-0Ch]
        jle short .21
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-0Ch]
        LD sub, edi, edx
        jmp near .13
.24:
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        jmp short .32
.25:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
.26:
        LD sub, edx, ecx
        jle short .27
        rep movsb
        jmp near .13
.27:
        LD add, ecx, edx
        neg edx
        rep movsb
        dec dword [byte ebp-010h]
        je short .22
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
.28:
        LD add, esi, edx
        LD sub, ecx, edx
        je short .29
        jl short .30
        mov edx, dword [byte ebp-0Ch]
        jmp short .26
.29:
        jmp near .12
.30:
        LD add, esi, ecx
.31:
        neg ecx
        LD mov, edx, ecx
.32:
        lodsb
        LD or, al, al
        jg short .33
        jl short .36
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.33:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short .32
.34:
        mov al, byte [byte esi-01h]
        cmp al, 0FFh
        je short .35
        LD add, edx, ecx
        jmp near .18
.35:
        jmp near .23
.36:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        jmp short .28
        db 00h,00h,00h
VgaBlitRemapFlipVHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitRemapFlipV+034h
VgaBlitRemapFlipV:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitRemapFlipV+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        cld
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD xor, edi, edi
        LD xor, edx, edx
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        inc edi
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        inc edi
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mul dword [byte ebp-0Ch]
        LD mov, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-010h], ecx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-014h], edx
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        mov ecx, dword [byte ebp-0Ch]
        cmp eax, dword [dword_D30BC]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jle short .6
        LD sub, ecx, eax
        jle short .1
        inc edi
        LD mov, edx, eax
        jmp short .6
.4:
        inc edi
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-014h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-04h], ebx
        LD or, edi, edi
        jne short .7
        jmp near VgaBlitRemap+042h
.7:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-014h]
        LD or, edx, edx
        je short .12
        jl short .8
        jmp near .34
.8:
        LD mov, ebx, edx
        and ebx, 7FFFh
        inc ebx
        mov edx, 7FFFh
.9:
        lodsb
        LD or, al, al
        jg short .10
        jl short .11
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.10:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short .9
        LD add, edx, ebx
        jmp near .36
.11:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        LD add, esi, ecx
        LD sub, edx, ecx
        jg short .9
        LD add, edx, ecx
        LD sub, esi, ecx
        LD add, edx, ebx
        jmp near .30
.12:
        mov edx, dword [byte ebp-0Ch]
.13:
        lodsb
        LD or, al, al
        jg short .15
        jl near .25
.14:
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.15:
        LD xor, ah, ah
        movsx ecx, ax
        lodsb
        cmp al, 0FFh
        je short .20
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
.16:
        LD sub, edx, ecx
        jle short .17
        rep stosb
        jmp short .13
.17:
        LD add, ecx, edx
        neg edx
        rep stosb
        dec dword [byte ebp-010h]
        je short .14
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
.18:
        LD sub, ecx, edx
        je short .12
        jl short .19
        mov edx, dword [byte ebp-0Ch]
        jmp short .16
.19:
        jmp near .33
.20:
        LD add, edi, ecx
        LD sub, edx, ecx
        jg short .13
.21:
        dec dword [byte ebp-010h]
.22:
        je short .14
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-018h]
        jg short .24
.23:
        add edx, dword [byte ebp-0Ch]
        jle short .21
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-0Ch]
        LD sub, edi, edx
        jmp near .13
.24:
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        jmp short .34
.25:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
.26:
        LD sub, edx, ecx
        jle short .28
.27:
        lodsb
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        stosb
        loop .27
        jmp near .13
.28:
        LD add, ecx, edx
        neg edx
.29:
        lodsb
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        stosb
        loop .29
        dec dword [byte ebp-010h]
        je short .22
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
.30:
        LD add, esi, edx
        LD sub, ecx, edx
        je short .31
        jl short .32
        mov edx, dword [byte ebp-0Ch]
        jmp short .26
.31:
        jmp near .12
.32:
        LD add, esi, ecx
.33:
        neg ecx
        LD mov, edx, ecx
.34:
        lodsb
        LD or, al, al
        jg short .35
        jl short .38
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.35:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short .34
.36:
        mov al, byte [byte esi-01h]
        cmp al, 0FFh
        je short .37
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        LD add, edx, ecx
        jmp near .18
.37:
        jmp near .23
.38:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        jmp short .30
        db 00h
VgaBlitKeyedFlipHHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+04h]
        add ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitKeyedFlipH+034h
VgaBlitKeyedFlipH:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitKeyedFlipH+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        dec eax
        add dword [byte ebp-04h], eax
        std
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
.1:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short .2
        jl short .7
        cld
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        LD xor, ah, ah
        movsx ecx, ax
        mov al, byte [esi]
        inc esi
        cmp al, 0FFh
        je short .5
.3:
        LD sub, edx, ecx
        jle short .4
        rep stosb
        jmp short .1
.4:
        LD add, ecx, edx
        neg edx
        rep stosb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        jmp short .3
.5:
        LD sub, edi, ecx
        LD sub, edx, ecx
        jg short .1
.6:
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-0Ch]
        jle short .6
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        sub edi, dword [byte ebp-0Ch]
        LD add, edi, edx
        jmp short .1
.7:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
.8:
        LD sub, edx, ecx
        jle short .10
.9:
        mov al, byte [esi]
        inc esi
        stosb
        loop .9
        jmp short .1
.10:
        LD add, ecx, edx
        neg edx
.11:
        mov al, byte [esi]
        inc esi
        stosb
        loop .11
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        LD or, ecx, ecx
        jg short .8
        jmp near .1
VgaBlitKeyedFlipHVHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+04h]
        add ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitKeyedFlipHV+034h
VgaBlitKeyedFlipHV:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitKeyedFlipHV+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD xor, edi, edi
        LD xor, edx, edx
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        inc edi
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        inc edi
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mul dword [byte ebp-0Ch]
        LD mov, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-010h], ecx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-014h], edx
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        mov ecx, dword [byte ebp-0Ch]
        cmp eax, dword [dword_D30BC]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jle short .6
        add dword [byte ebp-014h], eax
        LD sub, ecx, eax
        jle short .1
        inc edi
        LD mov, edx, eax
        jmp short .6
.4:
        inc edi
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-018h], edx
        LD add, ebx, ecx
        dec ebx
        mov dword [byte ebp-04h], ebx
        LD or, edi, edi
        jne short .7
        jmp near VgaBlitKeyedFlipH+045h
.7:
        std
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-014h]
        LD or, edx, edx
        je short .12
        jl short .8
        jmp near .34
.8:
        cld
        LD mov, ebx, edx
        and ebx, 7FFFh
        inc ebx
        mov edx, 7FFFh
.9:
        lodsb
        LD or, al, al
        jg short .10
        jl short .11
        movsx eax, ax
        pop edi
        pop esi
        pop ds
        leave
        ret
.10:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short .9
        LD add, edx, ebx
        std
        jmp near .36
.11:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        LD add, esi, ecx
        LD sub, edx, ecx
        jg short .9
        LD add, edx, ecx
        LD sub, esi, ecx
        LD add, edx, ebx
        std
        jmp near .30
.12:
        mov edx, dword [byte ebp-0Ch]
.13:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short .15
        jl short .24
.14:
        cld
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.15:
        LD xor, ah, ah
        movsx ecx, ax
        mov al, byte [esi]
        inc esi
        cmp al, 0FFh
        je short .20
.16:
        LD sub, edx, ecx
        jle short .17
        rep stosb
        jmp short .13
.17:
        LD add, ecx, edx
        neg edx
        rep stosb
        dec dword [byte ebp-010h]
        je short .14
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
.18:
        LD sub, ecx, edx
        je short .12
        jl short .19
        mov edx, dword [byte ebp-0Ch]
        jmp short .16
.19:
        jmp near .33
.20:
        LD sub, edi, ecx
        LD sub, edx, ecx
        jg short .13
.21:
        dec dword [byte ebp-010h]
.22:
        je short .14
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-018h]
        jg short .27
.23:
        add edx, dword [byte ebp-0Ch]
        jle short .21
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        sub edi, dword [byte ebp-0Ch]
        LD add, edi, edx
        jmp near .13
.24:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
.25:
        LD sub, edx, ecx
        jle short .28
.26:
        mov al, byte [esi]
        inc esi
        stosb
        loop .26
        jmp near .13
.27:
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        jmp short .34
.28:
        LD add, ecx, edx
        neg edx
.29:
        mov al, byte [esi]
        inc esi
        stosb
        loop .29
        dec dword [byte ebp-010h]
        je short .22
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
.30:
        LD add, esi, edx
        LD sub, ecx, edx
        je short .31
        jl short .32
        mov edx, dword [byte ebp-0Ch]
        jmp short .25
.31:
        jmp near .12
.32:
        LD add, esi, ecx
.33:
        neg ecx
        LD mov, edx, ecx
.34:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short .35
        jl short .38
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.35:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short .34
.36:
        mov al, byte [byte esi-01h]
        cmp al, 0FFh
        je short .37
        LD add, edx, ecx
        jmp near .18
.37:
        jmp near .23
.38:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        jmp short .30
        db 00h,00h
VgaBlitRemapFlipHHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+04h]
        add ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitRemapFlipH+034h
VgaBlitRemapFlipH:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitRemapFlipH+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        dec eax
        add dword [byte ebp-04h], eax
        std
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
.1:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short .2
        jl short .7
        cld
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        LD xor, ah, ah
        movsx ecx, ax
        mov al, byte [esi]
        inc esi
        cmp al, 0FFh
        je short .5
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
.3:
        LD sub, edx, ecx
        jle short .4
        rep stosb
        jmp short .1
.4:
        LD add, ecx, edx
        neg edx
        rep stosb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        jmp short .3
.5:
        LD sub, edi, ecx
        LD sub, edx, ecx
        jg short .1
.6:
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-0Ch]
        jle short .6
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        sub edi, dword [byte ebp-0Ch]
        LD add, edi, edx
        jmp short .1
.7:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
.8:
        LD sub, edx, ecx
        jle short .10
.9:
        mov al, byte [esi]
        inc esi
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        stosb
        loop .9
        jmp near .1
.10:
        LD add, ecx, edx
        neg edx
.11:
        mov al, byte [esi]
        inc esi
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        stosb
        loop .11
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        LD or, ecx, ecx
        jg short .8
        jmp near .1
        db 00h,00h
VgaBlitRemapFlipHVHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+04h]
        add ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitRemapFlipHV+034h
VgaBlitRemapFlipHV:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitRemapFlipHV+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD xor, edi, edi
        LD xor, edx, edx
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        inc edi
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        inc edi
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mul dword [byte ebp-0Ch]
        LD mov, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-010h], ecx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-014h], edx
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        mov ecx, dword [byte ebp-0Ch]
        cmp eax, dword [dword_D30BC]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jle short .6
        add dword [byte ebp-014h], eax
        LD sub, ecx, eax
        jle short .1
        inc edi
        LD mov, edx, eax
        jmp short .6
.4:
        inc edi
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-018h], edx
        LD add, ebx, ecx
        dec ebx
        mov dword [byte ebp-04h], ebx
        LD or, edi, edi
        jne short .7
        jmp near VgaBlitRemapFlipH+045h
.7:
        std
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-014h]
        LD or, edx, edx
        je short .12
        jl short .8
        jmp near .34
.8:
        cld
        LD mov, ebx, edx
        and ebx, 7FFFh
        inc ebx
        mov edx, 7FFFh
.9:
        lodsb
        LD or, al, al
        jg short .10
        jl short .11
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.10:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short .9
        LD add, edx, ebx
        std
        jmp near .36
.11:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        LD add, esi, ecx
        LD sub, edx, ecx
        jg short .9
        LD add, edx, ecx
        LD sub, esi, ecx
        LD add, edx, ebx
        std
        jmp near .30
.12:
        mov edx, dword [byte ebp-0Ch]
.13:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short .15
        jl near .24
.14:
        cld
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.15:
        LD xor, ah, ah
        movsx ecx, ax
        mov al, byte [esi]
        inc esi
        cmp al, 0FFh
        je short .20
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
.16:
        LD sub, edx, ecx
        jle short .17
        rep stosb
        jmp short .13
.17:
        LD add, ecx, edx
        neg edx
        rep stosb
        dec dword [byte ebp-010h]
        je short .14
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
.18:
        LD sub, ecx, edx
        je short .12
        jl short .19
        mov edx, dword [byte ebp-0Ch]
        jmp short .16
.19:
        jmp near .33
.20:
        LD sub, edi, ecx
        LD sub, edx, ecx
        jg short .13
.21:
        dec dword [byte ebp-010h]
.22:
        je short .14
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-018h]
        jg short .27
.23:
        add edx, dword [byte ebp-0Ch]
        jle short .21
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        sub edi, dword [byte ebp-0Ch]
        LD add, edi, edx
        jmp near .13
.24:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
.25:
        LD sub, edx, ecx
        jle short .28
.26:
        mov al, byte [esi]
        inc esi
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        stosb
        loop .26
        jmp near .13
.27:
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        jmp short .34
.28:
        LD add, ecx, edx
        neg edx
.29:
        mov al, byte [esi]
        inc esi
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        stosb
        loop .29
        dec dword [byte ebp-010h]
        je short .22
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
.30:
        LD add, esi, edx
        LD sub, ecx, edx
        je short .31
        jl short .32
        mov edx, dword [byte ebp-0Ch]
        jmp short .25
.31:
        jmp near .12
.32:
        LD add, esi, ecx
.33:
        neg ecx
        LD mov, edx, ecx
.34:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short .35
        jl short .38
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
.35:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short .34
.36:
        mov al, byte [byte esi-01h]
        cmp al, 0FFh
        je short .37
        movsx ebx, ax
        mov al, byte [dword ebx+ColourRemap]
        LD add, edx, ecx
        jmp near .18
.37:
        jmp near .23
.38:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        jmp short .30
