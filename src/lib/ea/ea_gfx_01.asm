; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_903F0 progbits alloc exec nowrite align=1
extern cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, ScreenWidth, KeyedDraw, DrawVideoBase, ScreenRowTable
extern dword_D4108, RowCopyFunc, bcopy, VesaSetBankArg, BlitBlock, BlitBlockXor, BlitBlockAnd, AndPixel
extern BlitBlockOr, OrPixel
global PutBlock, loc_9041B, loc_9045A, loc_9046C, loc_90483, loc_9049B, loc_904F1, loc_90512
global loc_9051E, loc_9053F, loc_90566, loc_905C8, loc_905E0, loc_90607, loc_90614, DrawBitmap
global PutBlockHotspot, loc_9065F, loc_90660, loc_9066F, loc_90681, loc_90688, DrawArtXor, loc_906B9
global DrawArtXorAtOwnPos, DrawArtAnd, loc_9074B, loc_9078C, loc_907A8, loc_907C6, loc_907E5, loc_907F3
global loc_90808, loc_90825, DrawArtAndAtOwnPos, DrawArtOr, loc_908A9, loc_908EA, loc_90906
global loc_90924, loc_90943, loc_90959, loc_90972, loc_9098F, DrawArtOrAtOwnPos
PutBlock:
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov eax, dword [byte esp+034h]
        mov esi, dword [byte esp+038h]
        cmp dword [KeyedDraw], byte 0
        jne short loc_9041B
        mov ebx, dword [byte esp+03Ch]
        push ebx
        push esi
        push eax
        call BlitBlock
        add esp, byte 0Ch
        jmp near loc_90614
loc_9041B:
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
        jle short loc_9045A
        imul edx, eax
        add edi, edx
        sub ebp, eax
        lea edx, [ecx+eax]
        mov dword [byte esp+03Ch], edx
loc_9045A:
        mov eax, dword [byte esp+03Ch]
        add eax, ebp
        sub eax, dword [cliprect_y1]
        test eax, eax
        jle short loc_9046C
        sub ebp, eax
loc_9046C:
        mov eax, dword [cliprect_x0]
        sub eax, esi
        test eax, eax
        jle short loc_90483
        add edi, eax
        sub dword [byte esp+020h], eax
        add esi, eax
        add dword [byte esp+04h], eax
loc_90483:
        mov eax, dword [byte esp+020h]
        add eax, esi
        sub eax, dword [cliprect_x1]
        test eax, eax
        jle short loc_9049B
        add dword [byte esp+04h], eax
        sub dword [byte esp+020h], eax
loc_9049B:
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
        jle near loc_90614
        mov ecx, dword [esp]
        lea eax, [edx+ecx]
        mov dword [byte esp+014h], eax
        mov ebp, dword [byte esp+04h]
        lea eax, [edx+ebp]
        mov dword [byte esp+018h], eax
loc_904F1:
        mov eax, dword [byte esp+0Ch]
        test eax, eax
        jle near loc_90614
        mov ebp, dword [byte esp+010h]
        mov ebp, dword [nosplit ebp*4+dword_D4108]
        sub ebp, dword [byte esp+03Ch]
        cmp ebp, eax
        jle short loc_90512
        mov ebp, eax
loc_90512:
        test ebp, ebp
        je short loc_9053F
        add dword [byte esp+03Ch], ebp
        sub dword [byte esp+0Ch], ebp
loc_9051E:
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
        jne short loc_9051E
loc_9053F:
        cmp dword [byte esp+0Ch], byte 0
        je short loc_904F1
        test esi, 10000h
        je short loc_90566
        and esi, 0FFFFh
        mov eax, dword [byte esp+010h]
        inc eax
        mov dword [byte esp+010h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
loc_90566:
        mov eax, dword [byte esp+020h]
        add eax, esi
        mov dword [byte esp+08h], eax
        lea ebp, [byte eax-01h]
        mov eax, dword [byte esp+01Ch]
        add eax, esi
        test ebp, 10000h
        je short loc_905C8
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
        jmp short loc_905E0
loc_905C8:
        mov ebx, dword [byte esp+020h]
        push ebx
        push eax
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        mov esi, dword [byte esp+08h]
        add edi, dword [byte esp+020h]
loc_905E0:
        add esi, dword [esp]
        add edi, dword [byte esp+04h]
        test esi, 10000h
        je short loc_90607
        and esi, 0FFFFh
        mov ebp, dword [byte esp+010h]
        inc ebp
        mov dword [byte esp+010h], ebp
        push ebp
        call VesaSetBankArg
        add esp, byte 4
loc_90607:
        dec dword [byte esp+0Ch]
        inc dword [byte esp+03Ch]
        jmp near loc_904F1
loc_90614:
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
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
loc_9065F:
        ret
loc_90660:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        sar ebx, 2
loc_9066F:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short loc_90681
        mov ecx, dword [edx]
        xor dword [eax], ecx
        add eax, byte 4
        add edx, byte 4
        jmp short loc_9066F
loc_90681:
        mov ebx, dword [byte esp+0Ch]
        and ebx, byte 3
loc_90688:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short loc_9065F
        mov cl, byte [edx]
        xor byte [eax], cl
        inc eax
        inc edx
        jmp short loc_90688
        db 08Bh,0C0h
DrawArtXor:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short loc_906B9
        push eax
        push ebx
        push edx
        call BlitBlockXor
        add esp, byte 0Ch
        ret
loc_906B9:
        mov dword [RowCopyFunc], loc_90660
        push eax
        push ebx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
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
DrawArtAnd:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov eax, dword [byte esp+020h]
        mov edi, dword [byte esp+024h]
        cmp dword [KeyedDraw], byte 0
        jne short loc_9074B
        mov esi, dword [byte esp+028h]
        push esi
        push edi
        push eax
        call BlitBlockAnd
        add esp, byte 0Ch
        jmp near DrawArtAnd+010Fh
loc_9074B:
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
        jle short loc_9078C
        mov edi, ebp
        imul edi, eax
        add esi, edi
        sub dword [byte esp+0Ch], eax
        lea ebp, [ecx+eax]
        mov dword [byte esp+028h], ebp
loc_9078C:
        mov eax, dword [byte esp+028h]
        mov edx, dword [byte esp+0Ch]
        add eax, edx
        sub eax, dword [cliprect_y1]
        test eax, eax
        jle short loc_907A8
        mov ecx, edx
        sub ecx, eax
        mov dword [byte esp+0Ch], ecx
loc_907A8:
        mov eax, dword [cliprect_x0]
        mov edi, dword [esp]
        sub eax, edi
        test eax, eax
        jle short loc_907C6
        add esi, eax
        sub dword [byte esp+08h], eax
        lea edx, [edi+eax]
        mov dword [esp], edx
        add dword [byte esp+04h], eax
loc_907C6:
        mov eax, dword [esp]
        mov ecx, dword [byte esp+08h]
        add eax, ecx
        sub eax, dword [cliprect_x1]
        test eax, eax
        jle short loc_907E5
        add dword [byte esp+04h], eax
        mov edx, ecx
        sub edx, eax
        mov dword [byte esp+08h], edx
loc_907E5:
        cmp dword [byte esp+08h], byte 0
        jle short DrawArtAnd+010Fh
        cmp dword [byte esp+0Ch], byte 0
        jle short DrawArtAnd+010Fh
loc_907F3:
        mov edi, dword [byte esp+0Ch]
        dec edi
        mov dword [byte esp+0Ch], edi
        cmp edi, byte 0FFFFFFFFh
        je short DrawArtAnd+010Fh
        mov ebp, dword [esp]
        mov edi, dword [byte esp+08h]
loc_90808:
        dec edi
        cmp edi, byte 0FFFFFFFFh
        je short loc_90825
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
        jmp short loc_90808
loc_90825:
        inc dword [byte esp+028h]
        add esi, dword [byte esp+04h]
        jmp short loc_907F3
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Bh,0C0h
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
DrawArtOr:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov eax, dword [byte esp+020h]
        mov edi, dword [byte esp+024h]
        cmp dword [KeyedDraw], byte 0
        jne short loc_908A9
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
loc_908A9:
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
        jle short loc_908EA
        mov edi, ebp
        imul edi, eax
        add esi, edi
        sub dword [byte esp+0Ch], eax
        lea ebp, [ecx+eax]
        mov dword [byte esp+028h], ebp
loc_908EA:
        mov eax, dword [byte esp+028h]
        mov edx, dword [byte esp+0Ch]
        add eax, edx
        sub eax, dword [cliprect_y1]
        test eax, eax
        jle short loc_90906
        mov ecx, edx
        sub ecx, eax
        mov dword [byte esp+0Ch], ecx
loc_90906:
        mov eax, dword [cliprect_x0]
        mov edi, dword [esp]
        sub eax, edi
        test eax, eax
        jle short loc_90924
        add esi, eax
        sub dword [byte esp+08h], eax
        lea edx, [edi+eax]
        mov dword [esp], edx
        add dword [byte esp+04h], eax
loc_90924:
        mov eax, dword [esp]
        mov ecx, dword [byte esp+08h]
        add eax, ecx
        sub eax, dword [cliprect_x1]
        test eax, eax
        jle short loc_90943
        add dword [byte esp+04h], eax
        mov edx, ecx
        sub edx, eax
        mov dword [byte esp+08h], edx
loc_90943:
        cmp dword [byte esp+08h], byte 0
        jle near DrawArtAnd+010Fh
        cmp dword [byte esp+0Ch], byte 0
        jle near DrawArtAnd+010Fh
loc_90959:
        mov edi, dword [byte esp+0Ch]
        dec edi
        mov dword [byte esp+0Ch], edi
        cmp edi, byte 0FFFFFFFFh
        je near DrawArtAnd+010Fh
        mov ebp, dword [esp]
        mov edi, dword [byte esp+08h]
loc_90972:
        dec edi
        cmp edi, byte 0FFFFFFFFh
        je short loc_9098F
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
        jmp short loc_90972
loc_9098F:
        inc dword [byte esp+028h]
        add esi, dword [byte esp+04h]
        jmp short loc_90959
        db 08Dh,040h,00h
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
