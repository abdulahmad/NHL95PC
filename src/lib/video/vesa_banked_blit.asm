; Blitting through a banked VESA mode.
bits 32
%include "hockey.inc"
section s_B5D80 progbits alloc exec nowrite align=1
extern ColourRemap, VesaBankShift, RemapTable, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, DrawClipLeft
extern DrawClipRight, DrawRowBytes, KeyedDraw, DrawDestBuffer, DrawVideoBase, ScreenRowTable, VesaBank, VesaWindowGranularity
extern BlitColumnOffsets, BlitSourcePtr
global PutPixel, PlotPixel, VesaSetBankArg, VesaSetBank, VesaSetBankJumpTable, VesaSetMode, VgaSetModeTwice, VesaSetDisplayStart
global BlitBlockHot, BlitBlock, BlitBlockXorHot, BlitBlockXor, BlitBlockXor, BlitBlockAndHot, BlitBlockAnd, AndPixelClipped
global AndPixel, BlitBlockOrHot, BlitBlockOr, BlitBlockOr, OrPixelClipped, OrPixel, FillRectClippedCore, FillRectClippedCore
global FillRectCore, jpt_B66B3, XorRectClippedCore, XorRectClippedCore, XorRectCore, jpt_B67CB, BlitArtOpaqueHot, BlitArtOpaque
global BlitArtKeyFFHot, BlitArtKeyFF, BlitArtHot, BlitArt, BlitShapeFastHot, BlitShapeFast, BlitShapeFast, BlitArtKeyColourHot
global BlitArtKeyColour, BlitArtMaskedHot, BlitArtMasked, BlitShapeClippedHot, BlitShapeClipped, SetBitmapClip, ShapeWidth, ShapeHeight
global ShapeDataSize, FillRectSpansCore, FillRectSpansJumpTable, UnpackArtRle, SetBlitSource, CopyRowKeyFF, CopyRowRemapKeyed, CopyRowFast
global unk_B74AA, BlitBlockShadowHot, BlitBlockShadow, SetRemapTable, BlitBlockRemapKeyedHot, BlitBlockRemapKeyed
PutPixel:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp eax, dword [DrawClipLeft]
        jl short .1
        cmp eax, dword [DrawClipRight]
        jge short .1
        cmp edx, dword [cliprect_y0]
        jl short .1
        cmp edx, dword [cliprect_y1]
        jl short PlotPixel+0Ch
.1:
        ret
        db 02Eh,0C0h,08Bh
PlotPixel:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .2
        mov ecx, dword [DrawDestBuffer]
        add eax, dword [ecx+edx*4]
        add eax, dword [DrawVideoBase]
        mov byte [eax], bl
        ret
        db 090h
.1:
        call VesaSetBank
        mov byte [edx], bl
        ret
.2:
        add eax, dword [nosplit edx*4+ScreenRowTable]
        movzx edx, ax
        add edx, dword [DrawVideoBase]
        shr eax, 10h
        cmp al, byte [VesaBankShift]
        jne short .1
        mov byte [edx], bl
        ret
        db 00h,00h
VesaSetBankArg:
        mov eax, dword [byte esp+04h]
VesaSetBank:
        cmp al, byte [VesaBankShift]
        je short VesaSetBankJumpTable+02Ah
        mov byte [VesaBankShift], al
        push edx
        mov edx, dword [VesaBank]
        jmp dword [nosplit edx*4+VesaSetBankJumpTable]
VesaSetBankJumpTable:
        dd .1
        dd .2
        dd .3
.1:
        push ebx
        push ecx
        push ebp
        push esi
        push edi
        mov ecx, dword [VesaWindowGranularity]
        shl al, cl
        movzx edx, al
        mov ax, 4F05h
        LD xor, ebx, ebx
        int 10h
        pop edi
        pop esi
        pop ebp
        pop ecx
        pop ebx
        pop edx
        ret
.2:
        push ebx
        push ecx
        push ebp
        push esi
        push edi
        mov ecx, dword [VesaWindowGranularity]
        shl al, cl
        movzx edx, al
        push edx
        mov ax, 4F05h
        LD xor, ebx, ebx
        int 10h
        pop edx
        mov ax, 4F05h
        mov ebx, 1
        int 10h
        pop edi
        pop esi
        pop ebp
        pop ecx
        pop ebx
        pop edx
        ret
.3:
        mov dx, 1CEh
        mov al, 0BEh
        out dx, al
        inc dl
        in al, dx
        LD mov, ah, al
        and ah, 0F7h
        dec dl
        mov al, 0BEh
        out dx, ax
        mov dx, 1CEh
        mov al, 0B2h
        out dx, al
        inc dl
        in al, dx
        and al, 0E1h
        mov ah, byte [byte esp+08h]
        LD add, ah, ah
        LD or, ah, al
        mov al, 0B2h
        dec dl
        out dx, ax
        pop edx
        ret
VesaSetMode:
        mov ebx, dword [byte esp+04h]
        mov ax, 4F02h
        push ebp
        push esi
        push edi
        int 10h
        pop edi
        pop esi
        pop ebp
        ret
VgaSetModeTwice:
        mov eax, dword [byte esp+04h]
        push ebp
        push esi
        push edi
        int 10h
        pop edi
        pop esi
        pop ebp
        ret
VesaSetDisplayStart:
        push ecx
        LD mov, ecx, eax
        mov eax, 4F07h
        mov ebx, 0
        int 10h
        pop ecx
        ret
        push ecx
        movzx ebx, al
        movzx edx, dx
        mov eax, 4F05h
        int 10h
        pop ecx
        ret
        db 00h,00h
BlitBlockHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short BlitBlock+032h
BlitBlock:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitBlock+032h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        leave
        ret
.2:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [DrawClipLeft]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [DrawClipRight]
        jl short .6
        LD sub, ecx, eax
        jle short .1
        LD mov, edx, eax
        jmp short .6
.4:
        mov ebx, dword [DrawClipLeft]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [DrawClipRight]
        LD sub, esi, ebx
        jle short .1
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        LD or, ecx, ecx
        jle short .8
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jb short .9
.7:
        LD mov, ecx, eax
        shr ecx, 1
        rep movsd
        LD adc, ecx, ecx
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .7
.8:
        pop edi
        pop esi
        leave
        ret
.9:
        je short .11
.10:
        LD mov, ecx, eax
        shr ecx, 1
        rep movsd
        LD adc, ecx, ecx
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        movsb
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .10
        pop edi
        pop esi
        leave
        ret
.11:
        movsb
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .11
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
BlitBlockXorHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockXor+032h
BlitBlockXor:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockXor+032h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        leave
        ret
.2:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [DrawClipLeft]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [DrawClipRight]
        jl short .6
        LD sub, ecx, eax
        jle short .1
        LD mov, edx, eax
        jmp short .6
.4:
        mov ebx, dword [DrawClipLeft]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [DrawClipRight]
        LD sub, esi, ebx
        jle short .1
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        LD or, ecx, ecx
        jle short .9
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jb short .10
        mov dword [byte ebp-01Ch], eax
.7:
        mov ecx, dword [byte ebp-01Ch]
.8:
        lodsw
        xor word [edi], ax
        add edi, byte 2
        loop .8
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .7
.9:
        pop edi
        pop esi
        leave
        ret
.10:
        je short .13
        mov dword [byte ebp-01Ch], eax
        inc ebx
.11:
        mov ecx, dword [byte ebp-01Ch]
.12:
        lodsw
        xor word [edi], ax
        add edi, byte 2
        loop .12
        lodsb
        xor byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .11
        pop edi
        pop esi
        leave
        ret
.13:
        inc ebx
.14:
        lodsb
        xor byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .14
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
BlitBlockAndHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockAnd+032h
BlitBlockAnd:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockAnd+032h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        leave
        ret
.2:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [DrawClipLeft]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [DrawClipRight]
        jl short .6
        LD sub, ecx, eax
        jle short .1
        LD mov, edx, eax
        jmp short .6
.4:
        mov ebx, dword [DrawClipLeft]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [DrawClipRight]
        LD sub, esi, ebx
        jle short .1
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        LD or, ecx, ecx
        jle short .9
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jb short .10
        mov dword [byte ebp-01Ch], eax
.7:
        mov ecx, dword [byte ebp-01Ch]
.8:
        lodsw
        and word [edi], ax
        add edi, byte 2
        loop .8
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .7
.9:
        pop edi
        pop esi
        leave
        ret
.10:
        je short .13
        mov dword [byte ebp-01Ch], eax
        inc ebx
.11:
        mov ecx, dword [byte ebp-01Ch]
.12:
        lodsw
        and word [edi], ax
        add edi, byte 2
        loop .12
        lodsb
        and byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .11
        pop edi
        pop esi
        leave
        ret
.13:
        inc ebx
.14:
        lodsb
        and byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .14
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
AndPixelClipped:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp eax, dword [DrawClipLeft]
        jl short .1
        cmp eax, dword [DrawClipRight]
        jge short .1
        cmp edx, dword [cliprect_y0]
        jl short .1
        cmp edx, dword [cliprect_y1]
        jl short AndPixel+0Ch
.1:
        ret
        db 02Eh,0C0h,08Bh
AndPixel:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .2
        mov ecx, dword [DrawDestBuffer]
        add eax, dword [ecx+edx*4]
        add eax, dword [DrawVideoBase]
        and byte [eax], bl
        ret
        db 090h
.1:
        call VesaSetBank
        and byte [edx], bl
        ret
.2:
        add eax, dword [nosplit edx*4+ScreenRowTable]
        movzx edx, ax
        add edx, dword [DrawVideoBase]
        shr eax, 10h
        cmp al, byte [VesaBankShift]
        jne short .1
        and byte [edx], bl
        ret
        db 00h,00h
BlitBlockOrHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockOr+032h
BlitBlockOr:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockOr+032h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        leave
        ret
.2:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [DrawClipLeft]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [DrawClipRight]
        jl short .6
        LD sub, ecx, eax
        jle short .1
        LD mov, edx, eax
        jmp short .6
.4:
        mov ebx, dword [DrawClipLeft]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [DrawClipRight]
        LD sub, esi, ebx
        jle short .1
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        LD or, ecx, ecx
        jle short .9
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jb short .10
        mov dword [byte ebp-01Ch], eax
.7:
        mov ecx, dword [byte ebp-01Ch]
.8:
        lodsw
        or word [edi], ax
        add edi, byte 2
        loop .8
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .7
.9:
        pop edi
        pop esi
        leave
        ret
.10:
        je short .13
        mov dword [byte ebp-01Ch], eax
        inc ebx
.11:
        mov ecx, dword [byte ebp-01Ch]
.12:
        lodsw
        or word [edi], ax
        add edi, byte 2
        loop .12
        lodsb
        or byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .11
        pop edi
        pop esi
        leave
        ret
.13:
        inc ebx
.14:
        lodsb
        or byte [edi], al
        add esi, dword [byte ebp-010h]
        LD add, edi, ebx
        dec edx
        jg short .14
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
OrPixelClipped:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp eax, dword [DrawClipLeft]
        jl short .1
        cmp eax, dword [DrawClipRight]
        jge short .1
        cmp edx, dword [cliprect_y0]
        jl short .1
        cmp edx, dword [cliprect_y1]
        jl short OrPixel+0Ch
.1:
        ret
        db 02Eh,0C0h,08Bh
OrPixel:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .2
        mov ecx, dword [DrawDestBuffer]
        add eax, dword [ecx+edx*4]
        add eax, dword [DrawVideoBase]
        or byte [eax], bl
        ret
        db 090h
.1:
        call VesaSetBank
        or byte [edx], bl
        ret
.2:
        add eax, dword [nosplit edx*4+ScreenRowTable]
        movzx edx, ax
        add edx, dword [DrawVideoBase]
        shr eax, 10h
        cmp al, byte [VesaBankShift]
        jne short .1
        or byte [edx], bl
        ret
        db 00h,00h
FillRectClippedCore:
        push ebp
        LD mov, ebp, esp
        push edi
        mov edx, dword [cliprect_x0]
        LD mov, eax, edx
        sub eax, dword [byte ebp+08h]
        jle short .1
        mov dword [byte ebp+08h], edx
        sub dword [byte ebp+010h], eax
        jle short FillRectClippedCore+05Ah
.1:
        mov eax, dword [byte ebp+08h]
        add eax, dword [byte ebp+010h]
        sub eax, dword [cliprect_x1]
        jle short .2
        sub dword [byte ebp+010h], eax
        jle short FillRectClippedCore+05Ah
.2:
        mov eax, dword [cliprect_y0]
        sub eax, dword [byte ebp+0Ch]
        jle short .3
        sub dword [byte ebp+014h], eax
        jle short FillRectClippedCore+05Ah
        mov eax, dword [cliprect_y0]
        mov dword [byte ebp+0Ch], eax
.3:
        mov eax, dword [byte ebp+0Ch]
        add eax, dword [byte ebp+014h]
        mov ebx, dword [cliprect_y1]
        LD sub, eax, ebx
        jle short FillRectCore+04h
        sub dword [byte ebp+014h], eax
        jle short FillRectClippedCore+05Ah
        jmp short FillRectCore+04h
        pop edi
        leave
        ret
FillRectCore:
        push ebp
        LD mov, ebp, esp
        push edi
        cld
        cmp dword [byte ebp+010h], byte 0
        jle short FillRectClippedCore+05Ah
        cmp dword [byte ebp+014h], byte 0
        jle short FillRectClippedCore+05Ah
        mov dl, byte [byte ebp+018h]
        LD mov, dh, dl
        shrd eax, edx, 10h
        LD mov, ax, dx
        mov ebx, dword [byte ebp+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp+08h]
        mov ebx, dword [byte ebp+014h]
        mov ecx, dword [byte ebp+010h]
        mov edx, dword [DrawRowBytes]
        LD sub, edx, ecx
        shr dword [byte ebp+010h], 2
        and ecx, byte 3
        jmp dword [nosplit ecx*4+jpt_B66B3]
jpt_B66B3:
        dd .1
        dd .2
        dd .4
        dd .5
.1:
        mov ecx, dword [byte ebp+010h]
        rep stosd
        LD add, edi, edx
        dec ebx
        jg short .1
        pop edi
        leave
        ret
.2:
        cmp dword [byte ebp+010h], byte 0
        je short .6
.3:
        mov ecx, dword [byte ebp+010h]
        rep stosd
        stosb
        LD add, edi, edx
        dec ebx
        jg short .3
        pop edi
        leave
        ret
.4:
        mov ecx, dword [byte ebp+010h]
        rep stosd
        stosw
        LD add, edi, edx
        dec ebx
        jg short .4
        pop edi
        leave
        ret
.5:
        mov ecx, dword [byte ebp+010h]
        rep stosd
        stosw
        stosb
        LD add, edi, edx
        dec ebx
        jg short .5
        pop edi
        leave
        ret
.6:
        inc edx
        LD mov, ecx, ebx
        shr ecx, 1
        jae short .7
        mov byte [edi], al
        LD add, edi, edx
.7:
        jecxz .9
.8:
        mov byte [edi], al
        mov byte [edx+edi], al
        lea edi, [edi+edx*2]
        loop .8
.9:
        pop edi
        leave
        ret
        db 00h,00h,00h
XorRectClippedCore:
        push ebp
        LD mov, ebp, esp
        push edi
        mov edx, dword [cliprect_x0]
        LD mov, eax, edx
        sub eax, dword [byte ebp+08h]
        jle short .1
        mov dword [byte ebp+08h], edx
        sub dword [byte ebp+010h], eax
        jle short XorRectClippedCore+05Ah
.1:
        mov eax, dword [byte ebp+08h]
        add eax, dword [byte ebp+010h]
        sub eax, dword [cliprect_x1]
        jle short .2
        sub dword [byte ebp+010h], eax
        jle short XorRectClippedCore+05Ah
.2:
        mov eax, dword [cliprect_y0]
        sub eax, dword [byte ebp+0Ch]
        jle short .3
        sub dword [byte ebp+014h], eax
        jle short XorRectClippedCore+05Ah
        mov eax, dword [cliprect_y0]
        mov dword [byte ebp+0Ch], eax
.3:
        mov eax, dword [byte ebp+0Ch]
        add eax, dword [byte ebp+014h]
        mov ebx, dword [cliprect_y1]
        LD sub, eax, ebx
        jle short XorRectCore+04h
        sub dword [byte ebp+014h], eax
        jle short XorRectClippedCore+05Ah
        jmp short XorRectCore+04h
        pop edi
        leave
        ret
XorRectCore:
        push ebp
        LD mov, ebp, esp
        push edi
        cld
        cmp dword [byte ebp+010h], byte 0
        jle short XorRectClippedCore+05Ah
        cmp dword [byte ebp+014h], byte 0
        jle short XorRectClippedCore+05Ah
        mov dl, byte [byte ebp+018h]
        LD mov, dh, dl
        shrd eax, edx, 10h
        LD mov, ax, dx
        mov ebx, dword [byte ebp+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp+08h]
        mov ebx, dword [byte ebp+014h]
        mov ecx, dword [byte ebp+010h]
        mov edx, dword [DrawRowBytes]
        LD sub, edx, ecx
        shr dword [byte ebp+010h], 2
        and ecx, byte 3
        jmp dword [nosplit ecx*4+jpt_B67CB]
jpt_B67CB:
        dd .1
        dd .4
        dd .8
        dd .12
.1:
        mov ecx, dword [byte ebp+010h]
        jecxz .3
.2:
        xor dword [edi], eax
        add edi, byte 4
        loop .2
.3:
        LD add, edi, edx
        dec ebx
        jg short .1
        pop edi
        leave
        ret
.4:
        cmp dword [byte ebp+010h], byte 0
        je short .16
        inc edx
.5:
        mov ecx, dword [byte ebp+010h]
        jecxz .7
.6:
        xor dword [edi], eax
        add edi, byte 4
        loop .6
.7:
        xor byte [edi], al
        LD add, edi, edx
        dec ebx
        jg short .5
        pop edi
        leave
        ret
.8:
        add edx, byte 2
.9:
        mov ecx, dword [byte ebp+010h]
        jecxz .11
.10:
        xor dword [edi], eax
        add edi, byte 4
        loop .10
.11:
        xor word [edi], ax
        LD add, edi, edx
        dec ebx
        jg short .9
        pop edi
        leave
        ret
.12:
        add edx, byte 3
.13:
        mov ecx, dword [byte ebp+010h]
        jecxz .15
.14:
        xor dword [edi], eax
        add edi, byte 4
        loop .14
.15:
        xor word [edi], ax
        xor byte [byte edi+02h], al
        LD add, edi, edx
        dec ebx
        jg short .13
        pop edi
        leave
        ret
.16:
        inc edx
        LD mov, ecx, ebx
        shr ecx, 1
        jae short .17
        xor byte [edi], al
        LD add, edi, edx
.17:
        jecxz .19
.18:
        xor byte [edi], al
        xor byte [edx+edi], al
        lea edi, [edi+edx*2]
        loop .18
.19:
        pop edi
        leave
        ret
        db 00h,00h,00h
BlitArtOpaqueHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short BlitArtOpaque+032h
BlitArtOpaque:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitArtOpaque+032h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov edi, dword [ebx]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-04h]
        cld
        movsx edx, word [byte esi+06h]
        LD or, edx, edx
        je short .2
        mov ebx, dword [DrawRowBytes]
        movsx eax, word [byte esi+04h]
        LD sub, ebx, eax
        add esi, byte 10h
        shr eax, 1
        jb short .3
.1:
        LD mov, ecx, eax
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        LD add, edi, ebx
        dec edx
        jg short .1
.2:
        pop edi
        pop esi
        leave
        ret
.3:
        je short .5
.4:
        LD mov, ecx, eax
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        movsb
        LD add, edi, ebx
        dec edx
        jg short .4
        pop edi
        pop esi
        leave
        ret
.5:
        movsb
        LD add, edi, ebx
        dec edx
        jg short .5
        pop edi
        pop esi
        leave
        ret
        db 00h,00h,00h
BlitArtKeyFFHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
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
        jmp short BlitArtKeyFF+034h
BlitArtKeyFF:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitArtKeyFF+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov edx, dword [DrawRowBytes]
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD sub, edx, eax
        movsx eax, word [byte esi+06h]
        mov dword [byte ebp-010h], eax
        cld
        add esi, byte 10h
        LD xor, ebx, ebx
.1:
        mov ecx, dword [byte ebp-0Ch]
.2:
        lodsb
        cmp al, 0FFh
        je short .3
        stosb
        loop .2
        jmp short .4
.3:
        inc edi
        loop .2
.4:
        LD add, edi, edx
        dec dword [byte ebp-010h]
        jg short .1
        pop edi
        pop esi
        pop ds
        leave
        ret
        db 00h
BlitArtHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
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
        jmp short BlitArt+034h
BlitArt:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitArt+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        pop ds
        leave
        ret
.2:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-018h], edx
        movsx edx, word [byte esi+04h]
        mul edx
        mov edx, dword [byte ebp-018h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov eax, dword [byte ebp-04h]
        LD mov, ebx, eax
        cmp eax, dword [DrawClipLeft]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [DrawClipRight]
        jl short .6
        LD sub, ecx, eax
        jle short .1
        LD mov, edx, eax
        jmp short .6
.4:
        mov ebx, dword [DrawClipLeft]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [DrawClipRight]
        LD sub, esi, ebx
        jle short .1
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        LD or, ecx, ecx
        jle short .11
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [DrawRowBytes]
        sub edx, dword [byte ebp-0Ch]
        LD xor, bh, bh
        mov ah, 0FFh
.7:
        mov ecx, dword [byte ebp-0Ch]
.8:
        lodsb
        LD cmp, al, ah
        je short .9
        stosb
        loop .8
        jmp short .10
.9:
        inc edi
        loop .8
.10:
        add esi, dword [byte ebp-010h]
        LD add, edi, edx
        dec dword [byte ebp-014h]
        jg short .7
.11:
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
        db 00h,00h
BlitShapeFastHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF4h
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte edi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte edi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short BlitShapeFast+03Ah
BlitShapeFast:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF4h
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov word [byte edi+0Ch], ax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        mov word [byte edi+0Eh], ax
        jmp short BlitShapeFast+03Ah
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF4h
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        movsx eax, word [byte edi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte edi+0Eh]
        mov dword [byte ebp-08h], eax
        movsx eax, word [byte edi+04h]
        mov dword [byte ebp-0Ch], eax
        movsx edx, word [byte edi+06h]
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        add edi, byte 10h
        cld
.1:
        mov esi, dword [ebx]
        add esi, dword [DrawVideoBase]
        add esi, dword [byte ebp-04h]
        mov ecx, dword [byte ebp-0Ch]
.2:
        test ecx, 3
        je short .3
        movsb
        dec ecx
        jmp short .2
.3:
        shr ecx, 2
        rep movsd
        add ebx, byte 4
        dec edx
        jg short .1
        pop edi
        pop esi
        leave
        ret
        db 00h,00h,00h
BlitArtKeyColourHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push es
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
        jmp short BlitArtKeyColour+036h
BlitArtKeyColour:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push es
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitArtKeyColour+036h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push es
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        pop ds
        pop es
        leave
        ret
.2:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-018h], edx
        movsx edx, word [byte esi+04h]
        mul edx
        mov edx, dword [byte ebp-018h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov eax, dword [byte ebp-04h]
        LD mov, ebx, eax
        cmp eax, dword [DrawClipLeft]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [DrawClipRight]
        jl short .6
        LD sub, ecx, eax
        jle short .1
        LD mov, edx, eax
        jmp short .6
.4:
        mov ebx, dword [DrawClipLeft]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [DrawClipRight]
        LD sub, esi, ebx
        jle short .1
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        LD or, ecx, ecx
        jle short .11
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [DrawRowBytes]
        sub edx, dword [byte ebp-0Ch]
        LD xor, bh, bh
        mov ah, 0FFh
.7:
        mov ecx, dword [byte ebp-0Ch]
.8:
        lodsb
        LD mov, bl, al
        mov al, byte [dword ebx+ColourRemap]
        LD cmp, al, ah
        je short .9
        stosb
        loop .8
        jmp short .10
.9:
        inc edi
        loop .8
.10:
        add esi, dword [byte ebp-010h]
        LD add, edi, edx
        dec dword [byte ebp-014h]
        jg short .7
.11:
        cwde
        pop edi
        pop esi
        pop ds
        pop es
        leave
        ret
        db 00h
BlitArtMaskedHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
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
        jmp short BlitArtMasked+032h
BlitArtMasked:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitArtMasked+032h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov edi, dword [ebx]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-04h]
        mov edx, dword [DrawRowBytes]
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD sub, edx, eax
        movsx eax, word [byte esi+06h]
        mov dword [byte ebp-010h], eax
        cld
        add esi, byte 10h
        LD xor, eax, eax
.1:
        mov ecx, dword [byte ebp-0Ch]
.2:
        lodsb
        mov al, byte [dword eax+ColourRemap]
        cmp al, 0FFh
        je short .3
        stosb
        loop .2
        jmp short .4
.3:
        inc edi
        loop .2
.4:
        LD add, edi, edx
        dec dword [byte ebp-010h]
        jg short .1
        pop edi
        pop esi
        leave
        ret
        db 00h,00h,00h
BlitShapeClippedHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push edi
        push esi
        mov edi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte edi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte edi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short BlitShapeClipped+03Ah
BlitShapeClipped:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push edi
        push esi
        mov edi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov word [byte edi+0Ch], ax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        mov word [byte edi+0Eh], ax
        jmp short BlitShapeClipped+03Ah
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE4h
        push edi
        push esi
        mov edi, dword [byte ebp+08h]
        movsx eax, word [byte edi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte edi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte edi+06h]
        lea edx, [byte edi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jg short .3
.1:
        pop esi
        pop edi
        leave
        ret
.2:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-010h], edx
        movsx edx, word [byte edi+04h]
        imul edx
        mov edx, dword [byte ebp-010h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte edi+04h]
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_x0]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [cliprect_x1]
        jl short .6
        LD sub, ecx, eax
        jle short .1
        LD mov, edx, eax
        jmp short .6
.4:
        mov ebx, dword [cliprect_x0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, edi, ecx
        LD sub, edi, eax
        add dword [byte ebp-018h], edi
        mov edi, dword [cliprect_x1]
        LD sub, edi, ebx
        jle short .1
        LD cmp, eax, edi
        jl short .5
        LD mov, eax, edi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        LD or, ecx, ecx
        jle short .10
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov esi, dword [ebx]
        add esi, dword [DrawVideoBase]
        add esi, dword [byte ebp-04h]
        mov edi, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        mov ebx, dword [DrawRowBytes]
        sub ebx, dword [byte ebp-0Ch]
        cmp dword [byte ebp-010h], byte 0
        je short .11
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        jae short .9
        je short .8
.7:
        LD mov, ecx, eax
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        movsb
        add edi, dword [byte ebp-010h]
        LD add, esi, ebx
        dec edx
        jg short .7
        jmp short .10
.8:
        movsb
        add edi, dword [byte ebp-010h]
        LD add, esi, ebx
        dec edx
        jg short .8
        jmp short .10
.9:
        LD mov, ecx, eax
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        add edi, dword [byte ebp-010h]
        LD add, esi, ebx
        dec edx
        jg short .9
.10:
        jmp near .1
.11:
        mov eax, dword [byte ebp-0Ch]
        shr eax, 1
        mov dword [byte ebp-01Ch], eax
        jae short .13
        je short .14
.12:
        mov ecx, dword [byte ebp-01Ch]
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        movsb
        LD add, esi, ebx
        dec edx
        jg short .12
        jmp near .1
.13:
        mov ecx, dword [byte ebp-01Ch]
        db 0F3h,066h,0A5h                       ; insn: rep movsw (nasm 3 emits 66h F3h)
        LD add, esi, ebx
        dec edx
        jg short .13
        jmp near .1
.14:
        movsb
        LD add, esi, ebx
        inc ebx
        dec edx
        jg short .14
        jmp near .1
SetBitmapClip:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte esi+02Ch]
        cmp dword [DrawVideoBase], eax
        je short .1
        mov eax, dword [byte ebp+0Ch]
        mov edx, dword [byte ebp+010h]
        mov ecx, dword [byte ebp+014h]
        mov ebx, dword [byte ebp+018h]
        mov dword [byte esi+08h], eax
        mov dword [byte esi+010h], edx
        mov dword [byte esi+0Ch], ecx
        mov dword [byte esi+014h], ebx
        mov dword [byte esi+018h], eax
        mov dword [byte esi+01Ch], edx
        pop esi
        leave
        ret
.1:
        mov eax, dword [byte ebp+0Ch]
        mov edx, dword [byte ebp+010h]
        mov ecx, dword [byte ebp+014h]
        mov ebx, dword [byte ebp+018h]
        mov dword [byte esi+08h], eax
        mov dword [byte esi+010h], edx
        mov dword [byte esi+0Ch], ecx
        mov dword [byte esi+014h], ebx
        mov dword [cliprect_x0], eax
        mov dword [cliprect_x1], edx
        mov dword [cliprect_y0], ecx
        mov dword [cliprect_y1], ebx
        mov dword [byte esi+018h], eax
        mov dword [byte esi+01Ch], edx
        mov dword [DrawClipLeft], eax
        mov dword [DrawClipRight], edx
        pop esi
        leave
        ret
        db 00h,00h
ShapeWidth:
        mov ebx, dword [byte esp+04h]
        movsx eax, word [byte ebx+04h]
        ret
ShapeHeight:
        mov ebx, dword [byte esp+04h]
        movsx eax, word [byte ebx+06h]
        ret
ShapeDataSize:
        mov ebx, dword [byte esp+04h]
        mov al, byte [ebx]
        LD or, al, al
        js short .1
        movsx eax, word [byte ebx+04h]
        movsx ebx, word [byte ebx+06h]
        imul eax, ebx
        add eax, byte 10h
        ret
.1:
        LD mov, edx, ebx
        add ebx, byte 0Eh
.2:
        add ebx, byte 2
        LD xor, ecx, ecx
        or cl, byte [ebx]
        je short .4
        jns short .2
.3:
        neg cl
        lea ebx, [byte ebx+ecx+01h]
        LD xor, ecx, ecx
        or cl, byte [ebx]
        js short .3
        jne short .2
.4:
        neg edx
        lea eax, [byte ebx+edx+01h]
        ret
FillRectSpansCore:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF0h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [esi]
        mov edx, dword [byte esi+04h]
        add eax, 80000000h
        adc edx, byte 0
        mov dword [byte ebp-04h], eax
        mov dword [byte ebp-08h], edx
        mov eax, dword [byte esi+08h]
        mov edx, dword [byte esi+0Ch]
        add eax, 80000000h
        adc edx, byte 0
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-010h], edx
        mov ecx, dword [byte esi+018h]
        mov al, byte [byte esi+01Ch]
        mov ebx, dword [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+FillRectSpansJumpTable]
FillRectSpansJumpTable:
        dd .2
        dd .2
        dd .4
        dd .10
        dd .9
        dd .13
        dd .11
        dd .19
        dd .15
        dd .1
.1:
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov byte [edi], al
        pop edi
        pop esi
        leave
        ret
.2:
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        test ecx, 3
        jne short .3
        shr ecx, 2
        LD mov, ah, al
        LD mov, edx, eax
        shl eax, 10h
        LD mov, ax, dx
        rep stosd
        pop edi
        pop esi
        leave
        ret
.3:
        LD mov, ah, al
        shr ecx, 1
        db 0F3h,066h,0ABh                       ; insn: rep stosw (nasm 3 emits 66h F3h)
        LD adc, ecx, ecx
        rep stosb
        pop edi
        pop esi
        leave
        ret
.4:
        mov ebx, dword [DrawRowBytes]
.5:
        mov edx, dword [byte esi+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        shr ecx, 1
        jae short .6
        mov byte [edi], al
        LD add, edi, ebx
.6:
        LD or, ecx, ecx
        je short .8
        lea edx, [nosplit ebx*2+00h]
.7:
        mov byte [edi], al
        mov byte [ebx+edi], al
        LD add, edi, edx
        loop .7
.8:
        pop edi
        pop esi
        leave
        ret
.9:
        mov ebx, dword [DrawRowBytes]
        inc ebx
        jmp short .5
.10:
        mov ebx, dword [DrawRowBytes]
        dec ebx
        jmp short .5
.11:
        mov edx, dword [byte esi+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov edx, dword [byte esi+030h]
        mov esi, dword [DrawRowBytes]
        mov ebx, dword [byte ebp-04h]
.12:
        mov byte [edi], al
        LD add, ebx, edx
        LD adc, edi, esi
        loop .12
        pop edi
        pop esi
        leave
        ret
.13:
        mov edx, dword [byte esi+0Ch]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov edx, dword [byte esi+030h]
        mov esi, dword [DrawRowBytes]
        neg esi
        mov ebx, dword [byte ebp-04h]
.14:
        mov byte [edi], al
        LD add, ebx, edx
        LD sbb, edi, esi
        loop .14
        pop edi
        pop esi
        leave
        ret
.15:
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov edx, dword [byte esi+030h]
        mov esi, dword [DrawRowBytes]
        mov ebx, dword [byte ebp-0Ch]
.16:
        mov byte [edi], al
        inc edi
        LD add, ebx, edx
        jb short .18
        loop .16
.17:
        pop edi
        pop esi
        leave
        ret
.18:
        LD add, edi, esi
        loop .16
        jmp short .17
.19:
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+edx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-08h]
        mov edx, dword [byte esi+030h]
        mov esi, dword [DrawRowBytes]
        mov ebx, dword [byte ebp-0Ch]
.20:
        mov byte [edi], al
        dec edi
        LD add, ebx, edx
        jb short .22
        loop .20
.21:
        pop edi
        pop esi
        leave
        ret
.22:
        LD add, edi, esi
        loop .20
        jmp short .21
        db 00h,00h
UnpackArtRle:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFFCh
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov edi, dword [byte ebp+0Ch]
        LD mov, edx, edi
        mov ecx, 4
        rep movsd
        cmp dword [byte ebp+010h], byte 0
        jne short .7
        LD xor, ecx, ecx
        jmp short .5
.1:
        add esi, byte 2
        mov al, byte [byte esi-01h]
        push ecx
        LD mov, ah, al
        shl eax, 8
        LD mov, al, ah
        shl eax, 8
        LD mov, al, ah
        shr ecx, 2
        rep stosd
        pop ecx
        and ecx, byte 3
        rep stosb
        or cl, byte [esi]
        je short .6
        jns short .1
.2:
        inc esi
        neg cl
.3:
        test ecx, 3
        je short .4
        movsb
        dec ecx
        jmp short .3
.4:
        shr ecx, 2
        rep movsd
.5:
        or cl, byte [esi]
        js short .2
        jne short .1
.6:
        LD mov, eax, edx
        and byte [eax], 7Fh
        pop edi
        pop esi
        leave
        ret
.7:
        mov eax, dword [byte edi-0Ch]
        sub eax, dword [byte edi-08h]
        mov dword [byte edi-08h], eax
        LD mov, ebx, edi
        mov edx, dword [byte edi-0Ch]
        mov dword [byte ebp-04h], edx
        LD add, edi, edx
        dec edi
        LD xor, ecx, ecx
.8:
        mov cl, byte [esi]
        inc esi
        LD or, cl, cl
        jg short .9
        jl short .12
        jmp short .15
.9:
        mov al, byte [esi]
        std
.10:
        stosb
        dec edx
        jne short .11
        mov edx, dword [byte ebp-04h]
        LD add, ebx, edx
        LD mov, edi, ebx
        LD add, edi, edx
        dec edi
.11:
        loop .10
        cld
        inc esi
        jmp short .8
.12:
        neg cl
.13:
        lodsb
        std
        stosb
        cld
        dec edx
        jne short .14
        mov edx, dword [byte ebp-04h]
        LD add, ebx, edx
        LD mov, edi, ebx
        LD add, edi, edx
        dec edi
.14:
        loop .13
        jmp short .8
.15:
        mov edx, dword [byte ebp+0Ch]
        jmp short .6
SetBlitSource:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov dword [BlitSourcePtr], eax
        mov eax, dword [byte ebp+0Ch]
        mov dword [BlitColumnOffsets], eax
        leave
        ret
CopyRowKeyFF:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
.1:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        cmp al, 0FFh
        je short .2
        mov byte [edi], al
.2:
        add edx, byte 4
        inc edi
        loop .1
        pop edi
        pop esi
        leave
        ret
CopyRowRemapKeyed:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        LD xor, eax, eax
.1:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov al, byte [dword eax+ColourRemap]
        mov byte [edi], al
        add edx, byte 4
        inc edi
        loop .1
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        LD xor, eax, eax
.2:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov al, byte [dword eax+ColourRemap]
        cmp al, 0FFh
        je short .3
        mov byte [edi], al
.3:
        add edx, byte 4
        inc edi
        loop .2
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        LD xor, eax, eax
.4:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        cmp al, 0FFh
        je short .6
        cmp al, 0FEh
        jne short .5
        mov al, byte [edi]
        mov al, byte [dword eax+RemapTable]
.5:
        mov byte [edi], al
.6:
        add edx, byte 4
        inc edi
        loop .4
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        LD xor, eax, eax
.7:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov al, byte [dword eax+ColourRemap]
        cmp al, 0FFh
        je short .9
        cmp al, 0FEh
        jne short .8
        mov al, byte [edi]
        mov al, byte [dword eax+RemapTable]
.8:
        mov byte [edi], al
.9:
        add edx, byte 4
        inc edi
        loop .7
        pop edi
        pop esi
        leave
        ret
CopyRowFast:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+0Ch]
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+010h]
        add esi, dword [BlitSourcePtr]
        add edi, dword [DrawVideoBase]
        mov edx, dword [BlitColumnOffsets]
        cmp ecx, byte 8
        jg short .3
.1:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov byte [edi], al
        add edx, byte 4
        inc edi
        loop .1
        pop edi
        pop esi
        leave
        ret
.2:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov byte [edi], al
        inc edi
        add edx, byte 4
        dec ecx
        LD mov, ebx, ecx
        and ebx, byte 0FFFFFFFEh
        neg ebx
        and ebx, byte 1Eh
        sub ecx, byte 20h
        LD add, ecx, ebx
        LD sub, edi, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        jmp dword [nosplit ebx*2+unk_B74AA]
.3:
        test edi, 1
        jne short .2
        LD mov, ebx, ecx
        and ebx, byte 0FFFFFFFEh
        neg ebx
        and ebx, byte 1Eh
        sub ecx, byte 20h
        LD add, ecx, ebx
        LD sub, edi, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        LD sub, edx, ebx
        jmp dword [nosplit ebx*2+unk_B74AA]
unk_B74AA:
        dd .2
        dd .3
        dd .4
        dd .5
        dd .6
        dd .7
        dd .8
        dd .9
        dd .10
        dd .11
        dd .12
        dd .13
        dd .14
        dd .15
        dd .16
        dd .17
.1:
        add edi, byte 20h
        add edx, 80h
.2:
        mov ebx, dword [edx]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+04h]
        mov ah, byte [ebx+esi]
        mov word [edi], ax
.3:
        mov ebx, dword [byte edx+08h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+0Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+02h], ax
.4:
        mov ebx, dword [byte edx+010h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+014h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+04h], ax
.5:
        mov ebx, dword [byte edx+018h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+01Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+06h], ax
.6:
        mov ebx, dword [byte edx+020h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+024h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+08h], ax
.7:
        mov ebx, dword [byte edx+028h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+02Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+0Ah], ax
.8:
        mov ebx, dword [byte edx+030h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+034h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+0Ch], ax
.9:
        mov ebx, dword [byte edx+038h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+03Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+0Eh], ax
.10:
        mov ebx, dword [byte edx+040h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+044h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+010h], ax
.11:
        mov ebx, dword [byte edx+048h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+04Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+012h], ax
.12:
        mov ebx, dword [byte edx+050h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+054h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+014h], ax
.13:
        mov ebx, dword [byte edx+058h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+05Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+016h], ax
.14:
        mov ebx, dword [byte edx+060h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+064h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+018h], ax
.15:
        mov ebx, dword [byte edx+068h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+06Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+01Ah], ax
.16:
        mov ebx, dword [byte edx+070h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+074h]
        mov ah, byte [ebx+esi]
        mov word [byte edi+01Ch], ax
.17:
        mov ebx, dword [byte edx+078h]
        mov al, byte [ebx+esi]
        mov ebx, dword [byte edx+07Ch]
        mov ah, byte [ebx+esi]
        mov word [byte edi+01Eh], ax
        sub ecx, byte 20h
        jns near .1
        and ecx, byte 1
        jne short .18
        pop edi
        pop esi
        leave
        ret
.18:
        mov ebx, dword [dword edx+080h]
        mov al, byte [ebx+esi]
        mov byte [byte edi+020h], al
        pop edi
        pop esi
        leave
        ret
        db 00h
BlitBlockShadowHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        movsx eax, ax
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        movsx eax, ax
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockShadow+032h
BlitBlockShadow:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockShadow+032h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE8h
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        lea edx, [byte esi+010h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short .2
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jg short .3
.1:
        pop edi
        pop esi
        leave
        ret
.2:
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        xchg ecx, eax
        LD sub, eax, ecx
        mov dword [byte ebp-018h], edx
        movsx edx, word [byte esi+04h]
        imul edx
        mov edx, dword [byte ebp-018h]
        LD add, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short .3
        LD sub, ecx, eax
        jle short .1
.3:
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ecx
        mov dword [byte ebp-08h], ebx
        movsx ecx, word [byte esi+04h]
        LD xor, edx, edx
        mov eax, dword [byte ebp-04h]
        LD mov, ebx, eax
        cmp eax, dword [DrawClipLeft]
        jl short .4
        LD add, eax, ecx
        sub eax, dword [DrawClipRight]
        jl short .6
        LD sub, ecx, eax
        jle short .1
        LD mov, edx, eax
        jmp short .6
.4:
        mov ebx, dword [DrawClipLeft]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short .1
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-018h], esi
        mov esi, dword [DrawClipRight]
        LD sub, esi, ebx
        jle short .1
        LD cmp, eax, esi
        jl short .5
        LD mov, eax, esi
.5:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
.6:
        LD or, ecx, ecx
        jle short .12
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        cld
        mov ebx, dword [byte ebp-08h]
        mov edi, dword [DrawDestBuffer]
        mov edi, dword [edi+ebx*4]
        add edi, dword [DrawVideoBase]
        add edi, dword [byte ebp-04h]
        mov esi, dword [byte ebp-018h]
        mov edx, dword [DrawRowBytes]
        sub edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
.7:
        mov ecx, dword [byte ebp-0Ch]
.8:
        lodsb
        cmp al, 0FEh
        ja short .10
        je short .9
        stosb
        loop .8
        jmp short .11
.9:
        mov al, byte [edi]
        mov al, byte [dword eax+RemapTable]
        stosb
        loop .8
        jmp short .11
.10:
        inc edi
        loop .8
.11:
        add esi, dword [byte ebp-010h]
        LD add, edi, edx
        dec dword [byte ebp-014h]
        jg short .7
.12:
        pop edi
        pop esi
        leave
        ret
        db 00h,00h,00h
SetRemapTable:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov ecx, 40h
        mov esi, dword [byte ebp+08h]
        mov edi, RemapTable
        rep movsd
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        mov esi, RemapTable
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
        mov ecx, dword [byte ebp+0Ch]
        mov esi, dword [byte ebp+010h]
        mov edi, RemapTable
        mov ebx, dword [byte ebp+08h]
        lea edi, [ebx+edi]
        shr ecx, 2
        rep movsd
        mov ecx, dword [byte ebp+0Ch]
        and ecx, byte 3
        rep movsb
        pop edi
        pop esi
        leave
        ret
        db 00h
BlitBlockRemapKeyedHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
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
        jmp short BlitBlockRemapKeyed+034h
BlitBlockRemapKeyed:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short BlitBlockRemapKeyed+034h
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFECh
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [DrawDestBuffer]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [DrawVideoBase]
        mov edx, dword [DrawRowBytes]
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD sub, edx, eax
        movsx eax, word [byte esi+06h]
        mov dword [byte ebp-010h], eax
        cld
        add esi, byte 10h
        mov ah, 0FEh
        mov ebx, RemapTable
.1:
        mov ecx, dword [byte ebp-0Ch]
.2:
        lodsb
        LD cmp, al, ah
        ja short .4
        je short .3
        stosb
        loop .2
        jmp short .5
.3:
        mov al, byte [edi]
        xlatb
        stosb
        loop .2
        jmp short .5
.4:
        inc edi
        loop .2
.5:
        LD add, edi, edx
        dec dword [byte ebp-010h]
        jg short .1
        pop edi
        pop esi
        pop ds
        leave
        ret
