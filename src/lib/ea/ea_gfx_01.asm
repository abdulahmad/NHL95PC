; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_903F0 progbits alloc exec nowrite align=1
extern cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, ScreenWidth, KeyedDraw, DrawVideoBase, ScreenRowTable
extern PutBlockScaleSteps, RowCopyFunc, bcopy, VesaSetBankArg, BlitBlock, BlitBlockXor, BlitBlockAnd, AndPixel
extern BlitBlockOr, OrPixel
global PutBlock, DrawBitmap, PutBlockHotspot, DrawArtXor, DrawArtXorAtOwnPos, DrawArtAnd, DrawArtAndAtOwnPos, DrawArtOr
global DrawArtOrAtOwnPos
;-----------------------------------------------------------------------------
; PutBlock                                     903F0  95 PC, medium confidence
; Graphics library: put a saved screen block back (buf, x, y)
;-----------------------------------------------------------------------------
PutBlock:
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov eax, dword [byte esp+034h]
        mov esi, dword [byte esp+038h]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        mov ebx, dword [byte esp+03Ch]
        push ebx
        push esi
        push eax
        call BlitBlock
        add esp, byte 0Ch
        jmp near .14
.1:
        lea edi, [byte eax+010h]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov dword [byte esp+020h], edx
        mov ebp, dword [byte eax+04h]
        sar ebp, 10h
        mov eax, dword [DrawVideoBase]
        mov dword [byte esp+01Ch], eax
        xor ebx, ebx
        mov dword [byte esp+04h], ebx
        mov eax, dword [cliprect_y0]
        mov ecx, dword [byte esp+03Ch]
        sub eax, ecx
        test eax, eax
        jle short .2
        imul edx, eax
        add edi, edx
        sub ebp, eax
        lea edx, [ecx+eax]
        mov dword [byte esp+03Ch], edx
.2:
        mov eax, dword [byte esp+03Ch]
        add eax, ebp
        sub eax, dword [cliprect_y1]
        test eax, eax
        jle short .3
        sub ebp, eax
.3:
        mov eax, dword [cliprect_x0]
        sub eax, esi
        test eax, eax
        jle short .4
        add edi, eax
        sub dword [byte esp+020h], eax
        add esi, eax
        add dword [byte esp+04h], eax
.4:
        mov eax, dword [byte esp+020h]
        add eax, esi
        sub eax, dword [cliprect_x1]
        test eax, eax
        jle short .5
        add dword [byte esp+04h], eax
        sub dword [byte esp+020h], eax
.5:
        mov eax, dword [byte esp+03Ch]
        add esi, dword [nosplit eax*4+ScreenRowTable]
        mov eax, dword [ScreenWidth]
        mov ecx, dword [byte esp+020h]
        sub eax, ecx
        mov dword [esp], eax
        mov eax, esi
        shr eax, 10h
        mov dword [byte esp+010h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
        and esi, 0FFFFh
        mov dword [byte esp+0Ch], ebp
        mov edx, dword [byte esp+020h]
        test edx, edx
        jle near .14
        mov ecx, dword [esp]
        lea eax, [edx+ecx]
        mov dword [byte esp+014h], eax
        mov ebp, dword [byte esp+04h]
        lea eax, [edx+ebp]
        mov dword [byte esp+018h], eax
.6:
        mov eax, dword [byte esp+0Ch]
        test eax, eax
        jle near .14
        mov ebp, dword [byte esp+010h]
        mov ebp, dword [nosplit ebp*4+PutBlockScaleSteps]
        sub ebp, dword [byte esp+03Ch]
        cmp ebp, eax
        jle short .7
        mov ebp, eax
.7:
        test ebp, ebp
        je short .9
        add dword [byte esp+03Ch], ebp
        sub dword [byte esp+0Ch], ebp
.8:
        mov edx, dword [byte esp+020h]
        push edx
        mov eax, dword [byte esp+020h]
        add eax, esi
        push eax
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        add esi, dword [byte esp+014h]
        add edi, dword [byte esp+018h]
        dec ebp
        jne short .8
.9:
        cmp dword [byte esp+0Ch], byte 0
        je short .6
        test esi, 10000h
        je short .10
        and esi, 0FFFFh
        mov eax, dword [byte esp+010h]
        inc eax
        mov dword [byte esp+010h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
.10:
        mov eax, dword [byte esp+020h]
        add eax, esi
        mov dword [byte esp+08h], eax
        lea ebp, [byte eax-01h]
        mov eax, dword [byte esp+01Ch]
        add eax, esi
        test ebp, 10000h
        je short .11
        mov ebp, 10000h
        sub ebp, esi
        push ebp
        push eax
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        add edi, ebp
        mov ebp, dword [byte esp+08h]
        and ebp, 0FFFFh
        mov esi, dword [byte esp+010h]
        inc esi
        mov dword [byte esp+010h], esi
        push esi
        call VesaSetBankArg
        add esp, byte 4
        push ebp
        mov edx, dword [byte esp+020h]
        push edx
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        mov esi, ebp
        add edi, ebp
        jmp short .12
.11:
        mov ebx, dword [byte esp+020h]
        push ebx
        push eax
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        mov esi, dword [byte esp+08h]
        add edi, dword [byte esp+020h]
.12:
        add esi, dword [esp]
        add edi, dword [byte esp+04h]
        test esi, 10000h
        je short .13
        and esi, 0FFFFh
        mov ebp, dword [byte esp+010h]
        inc ebp
        mov dword [byte esp+010h], ebp
        push ebp
        call VesaSetBankArg
        add esp, byte 4
.13:
        dec dword [byte esp+0Ch]
        inc dword [byte esp+03Ch]
        jmp near .6
.14:
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
;-----------------------------------------------------------------------------
; DrawBitmap                                   9061C  95 PC, medium confidence
; Graphics library: draw a bitmap
;-----------------------------------------------------------------------------
DrawBitmap:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call PutBlock
        add esp, byte 0Ch
        ret
;-----------------------------------------------------------------------------
; PutBlockHotspot                              90638  95 PC, medium confidence
; PutBlock at a position less the shape's hotspot
;-----------------------------------------------------------------------------
PutBlockHotspot:
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
        call PutBlock
        add esp, byte 0Ch
.1:
        ret
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        sar ebx, 2
.2:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short .3
        mov ecx, dword [edx]
        xor dword [eax], ecx
        add eax, byte 4
        add edx, byte 4
        jmp short .2
.3:
        mov ebx, dword [byte esp+0Ch]
        and ebx, byte 3
.4:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short .1
        mov cl, byte [edx]
        xor byte [eax], cl
        inc eax
        inc edx
        jmp short .4
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DrawArtXor                                      90698  95 PC, low confidence
; XORs art onto the screen (keyed when KeyedDraw is set)
;-----------------------------------------------------------------------------
DrawArtXor:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push eax
        push ebx
        push edx
        call BlitBlockXor
        add esp, byte 0Ch
        ret
.1:
        mov dword [RowCopyFunc], PutBlockHotspot+028h
        push eax
        push ebx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawArtXorAtOwnPos                              906DC  95 PC, low confidence
; DrawArtXor at the shape's own position
;-----------------------------------------------------------------------------
DrawArtXorAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtXor
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
        call DrawArtXor
        add esp, byte 0Ch
        ret
;-----------------------------------------------------------------------------
; DrawArtAnd                                   90720  95 PC, medium confidence
; ANDs art onto the draw target at x, y, pixel by pixel when keyed drawing is
; on
;-----------------------------------------------------------------------------
DrawArtAnd:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov eax, dword [byte esp+020h]
        mov edi, dword [byte esp+024h]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        mov esi, dword [byte esp+028h]
        push esi
        push edi
        push eax
        call BlitBlockAnd
        add esp, byte 0Ch
        jmp near DrawArtAnd+010Fh
.1:
        lea esi, [byte eax+010h]
        mov ebp, dword [byte eax+02h]
        sar ebp, 10h
        mov dword [byte esp+08h], ebp
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        mov dword [byte esp+0Ch], eax
        mov dword [esp], edi
        xor ebx, ebx
        mov dword [byte esp+04h], ebx
        mov eax, dword [cliprect_y0]
        mov ecx, dword [byte esp+028h]
        sub eax, ecx
        test eax, eax
        jle short .2
        mov edi, ebp
        imul edi, eax
        add esi, edi
        sub dword [byte esp+0Ch], eax
        lea ebp, [ecx+eax]
        mov dword [byte esp+028h], ebp
.2:
        mov eax, dword [byte esp+028h]
        mov edx, dword [byte esp+0Ch]
        add eax, edx
        sub eax, dword [cliprect_y1]
        test eax, eax
        jle short .3
        mov ecx, edx
        sub ecx, eax
        mov dword [byte esp+0Ch], ecx
.3:
        mov eax, dword [cliprect_x0]
        mov edi, dword [esp]
        sub eax, edi
        test eax, eax
        jle short .4
        add esi, eax
        sub dword [byte esp+08h], eax
        lea edx, [edi+eax]
        mov dword [esp], edx
        add dword [byte esp+04h], eax
.4:
        mov eax, dword [esp]
        mov ecx, dword [byte esp+08h]
        add eax, ecx
        sub eax, dword [cliprect_x1]
        test eax, eax
        jle short .5
        add dword [byte esp+04h], eax
        mov edx, ecx
        sub edx, eax
        mov dword [byte esp+08h], edx
.5:
        cmp dword [byte esp+08h], byte 0
        jle short DrawArtAnd+010Fh
        cmp dword [byte esp+0Ch], byte 0
        jle short DrawArtAnd+010Fh
.6:
        mov edi, dword [byte esp+0Ch]
        dec edi
        mov dword [byte esp+0Ch], edi
        cmp edi, byte 0FFFFFFFFh
        je short DrawArtAnd+010Fh
        mov ebp, dword [esp]
        mov edi, dword [byte esp+08h]
.7:
        dec edi
        cmp edi, byte 0FFFFFFFFh
        je short .8
        xor eax, eax
        mov al, byte [esi]
        push eax
        mov ebx, dword [byte esp+02Ch]
        push ebx
        push ebp
        inc esi
        inc ebp
        call AndPixel
        add esp, byte 0Ch
        jmp short .7
.8:
        inc dword [byte esp+028h]
        add esi, dword [byte esp+04h]
        jmp short .6
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DrawArtAndAtOwnPos                              90838  95 PC, low confidence
; DrawArtAnd at the shape's own position
;-----------------------------------------------------------------------------
DrawArtAndAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtAnd
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
        call DrawArtAnd
        add esp, byte 0Ch
        ret
;-----------------------------------------------------------------------------
; DrawArtOr                                    9087C  95 PC, medium confidence
; ORs art onto the screen
;-----------------------------------------------------------------------------
DrawArtOr:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov eax, dword [byte esp+020h]
        mov edi, dword [byte esp+024h]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        mov esi, dword [byte esp+028h]
        push esi
        push edi
        push eax
        call BlitBlockOr
        add esp, byte 0Ch
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
.1:
        lea esi, [byte eax+010h]
        mov ebp, dword [byte eax+02h]
        sar ebp, 10h
        mov dword [byte esp+08h], ebp
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        mov dword [byte esp+0Ch], eax
        mov dword [esp], edi
        xor ebx, ebx
        mov dword [byte esp+04h], ebx
        mov eax, dword [cliprect_y0]
        mov ecx, dword [byte esp+028h]
        sub eax, ecx
        test eax, eax
        jle short .2
        mov edi, ebp
        imul edi, eax
        add esi, edi
        sub dword [byte esp+0Ch], eax
        lea ebp, [ecx+eax]
        mov dword [byte esp+028h], ebp
.2:
        mov eax, dword [byte esp+028h]
        mov edx, dword [byte esp+0Ch]
        add eax, edx
        sub eax, dword [cliprect_y1]
        test eax, eax
        jle short .3
        mov ecx, edx
        sub ecx, eax
        mov dword [byte esp+0Ch], ecx
.3:
        mov eax, dword [cliprect_x0]
        mov edi, dword [esp]
        sub eax, edi
        test eax, eax
        jle short .4
        add esi, eax
        sub dword [byte esp+08h], eax
        lea edx, [edi+eax]
        mov dword [esp], edx
        add dword [byte esp+04h], eax
.4:
        mov eax, dword [esp]
        mov ecx, dword [byte esp+08h]
        add eax, ecx
        sub eax, dword [cliprect_x1]
        test eax, eax
        jle short .5
        add dword [byte esp+04h], eax
        mov edx, ecx
        sub edx, eax
        mov dword [byte esp+08h], edx
.5:
        cmp dword [byte esp+08h], byte 0
        jle near DrawArtAnd+010Fh
        cmp dword [byte esp+0Ch], byte 0
        jle near DrawArtAnd+010Fh
.6:
        mov edi, dword [byte esp+0Ch]
        dec edi
        mov dword [byte esp+0Ch], edi
        cmp edi, byte 0FFFFFFFFh
        je near DrawArtAnd+010Fh
        mov ebp, dword [esp]
        mov edi, dword [byte esp+08h]
.7:
        dec edi
        cmp edi, byte 0FFFFFFFFh
        je short .8
        xor eax, eax
        mov al, byte [esi]
        push eax
        mov ebx, dword [byte esp+02Ch]
        push ebx
        push ebp
        inc esi
        inc ebp
        call OrPixel
        add esp, byte 0Ch
        jmp short .7
.8:
        inc dword [byte esp+028h]
        add esi, dword [byte esp+04h]
        jmp short .6
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawArtOrAtOwnPos                               9099C  95 PC, low confidence
; DrawArtOr at the shape's own position
;-----------------------------------------------------------------------------
DrawArtOrAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtOr
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
        call DrawArtOr
        add esp, byte 0Ch
        ret
