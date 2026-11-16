; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_90D20 progbits alloc exec nowrite align=1
extern cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, ScreenWidth, KeyedDraw, DrawVideoBase, ScreenRowTable
extern dword_D4108, RowCopyFunc, FreeMemBlock, PushMemDescriptorLocked, removewindow, ClearScreen, SaveDrawState, RestoreDrawState
extern bcopy, FillMem, SetScreenTarget, VesaSetBankArg, FillRectCore, XorRectCore, BlitArtOpaque, BlitArtKeyFF
global FillRect, FillRectClipped, FillRectClipped, XorRowBytes, XorBar, XorRectClipped, ClearScreenColour, DrawArtOpaque
global DrawArtOpaqueAtOwnPos, DrawArtOpaqueHotspot, DrawArtKeyFF, DrawArtKeyFFAtOwnPos, DrawArtKeyFFHotspot, FreeWindowBitmap, FreeBitmap
FillRect:
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov esi, dword [byte esp+024h]
        mov edi, dword [byte esp+030h]
        mov ebp, dword [byte esp+034h]
        mov edx, dword [byte esp+02Ch]
        test edx, edx
        jle near .11
        test edi, edi
        jle near .11
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push ebp
        push edi
        push edx
        mov edi, dword [byte esp+034h]
        push edi
        push esi
        call FillRectCore
        add esp, byte 14h
        jmp near .11
.1:
        mov eax, dword [DrawVideoBase]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+028h]
        add esi, dword [nosplit eax*4+ScreenRowTable]
        mov eax, dword [ScreenWidth]
        sub eax, edx
        mov dword [esp], eax
        mov eax, esi
        shr eax, 10h
        mov dword [byte esp+08h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
        and esi, 0FFFFh
        mov dword [byte esp+04h], edi
        test edi, edi
        jle near .11
        mov eax, dword [byte esp+02Ch]
        mov edx, dword [esp]
        add eax, edx
        mov dword [byte esp+0Ch], eax
.2:
        mov edi, dword [byte esp+08h]
        mov edi, dword [nosplit edi*4+dword_D4108]
        sub edi, dword [byte esp+028h]
        mov ecx, dword [byte esp+04h]
        cmp edi, ecx
        jle short .3
        mov edi, ecx
.3:
        test edi, edi
        je short .5
        add dword [byte esp+028h], edi
        sub dword [byte esp+04h], edi
.4:
        push ebp
        mov ebx, dword [byte esp+030h]
        push ebx
        mov eax, dword [byte esp+018h]
        add eax, esi
        push eax
        call FillMem
        add esp, byte 0Ch
        add esi, dword [byte esp+0Ch]
        dec edi
        jne short .4
.5:
        cmp dword [byte esp+04h], byte 0
        je near .10
        test esi, 10000h
        je short .6
        and esi, 0FFFFh
        mov eax, dword [byte esp+08h]
        inc eax
        mov dword [byte esp+08h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
.6:
        mov edi, dword [byte esp+02Ch]
        add edi, esi
        mov eax, dword [byte esp+010h]
        add eax, esi
        test edi, 10000h
        je short .7
        mov edx, 10000h
        sub edx, esi
        push ebp
        push edx
        push eax
        call FillMem
        add esp, byte 0Ch
        mov esi, edi
        and esi, 0FFFFh
        mov ecx, dword [byte esp+08h]
        inc ecx
        mov dword [byte esp+08h], ecx
        push ecx
        call VesaSetBankArg
        add esp, byte 4
        push ebp
        push esi
        mov eax, dword [byte esp+018h]
        push eax
        call FillMem
        add esp, byte 0Ch
        jmp short .8
.7:
        push ebp
        mov ebx, dword [byte esp+030h]
        push ebx
        push eax
        call FillMem
        add esp, byte 0Ch
        mov esi, edi
.8:
        add esi, dword [esp]
        test esi, 10000h
        je short .9
        and esi, 0FFFFh
        mov ebx, dword [byte esp+08h]
        inc ebx
        mov dword [byte esp+08h], ebx
        push ebx
        call VesaSetBankArg
        add esp, byte 4
.9:
        dec dword [byte esp+04h]
        inc dword [byte esp+028h]
.10:
        cmp dword [byte esp+04h], byte 0
        jg near .2
.11:
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
FillRectClipped:
        push esi
        mov esi, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        mov ebx, dword [cliprect_y0]
        sub ebx, ecx
        test ebx, ebx
        jle short .1
        sub edx, ebx
        add ecx, ebx
.1:
        lea ebx, [ecx+edx]
        sub ebx, dword [cliprect_y1]
        test ebx, ebx
        jle short .2
        sub edx, ebx
.2:
        mov ebx, dword [cliprect_x0]
        sub ebx, esi
        test ebx, ebx
        jle short .3
        sub eax, ebx
        add esi, ebx
.3:
        lea ebx, [esi+eax]
        sub ebx, dword [cliprect_x1]
        test ebx, ebx
        jle short .4
        sub eax, ebx
.4:
        test eax, eax
        jle short .5
        test edx, edx
        jle short .5
        mov ebx, dword [byte esp+018h]
        push ebx
        push edx
        push eax
        push ecx
        push esi
        call FillRect
        add esp, byte 14h
.5:
        pop esi
        ret
        db 08Bh,0C0h
XorRowBytes:
        dec edx
        cmp edx, byte 0FFFFFFFFh
        je short FillRectClipped+069h
        xor byte [eax], bl
        inc eax
        jmp short XorRowBytes
        db 090h
XorBar:
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov eax, dword [byte esp+01Ch]
        mov edi, dword [byte esp+020h]
        mov ebp, dword [byte esp+028h]
        mov edx, dword [byte esp+024h]
        test edx, edx
        jle near .6
        test ebp, ebp
        jle near .6
        cmp dword [KeyedDraw], byte 0
        jne short .1
        mov esi, dword [byte esp+02Ch]
        push esi
        push ebp
        push edx
        push edi
        push eax
        call XorRectCore
        add esp, byte 14h
        jmp near .6
.1:
        mov ebx, dword [DrawVideoBase]
        mov dword [byte esp+04h], ebx
        mov esi, dword [ScreenWidth]
        imul esi, edi
        add esi, eax
        mov eax, dword [ScreenWidth]
        sub eax, edx
        mov dword [esp], eax
        mov edi, esi
        shr edi, 10h
        push edi
        call VesaSetBankArg
        add esp, byte 4
        and esi, 0FFFFh
        mov dword [byte esp+08h], ebp
        test ebp, ebp
        jle near .6
        movzx ebp, byte [byte esp+02Ch]
.2:
        mov ecx, dword [byte esp+024h]
        add ecx, esi
        mov eax, dword [byte esp+04h]
        add eax, esi
        test ecx, 10000h
        je short .3
        mov edx, 10000h
        sub edx, esi
        mov ebx, ebp
        call XorRowBytes
        mov esi, ecx
        and esi, 0FFFFh
        inc edi
        push edi
        call VesaSetBankArg
        add esp, byte 4
        mov ebx, ebp
        mov edx, esi
        mov eax, dword [byte esp+04h]
        call XorRowBytes
        jmp short .4
.3:
        xor ebx, ebx
        mov bl, byte [byte esp+02Ch]
        mov edx, dword [byte esp+024h]
        call XorRowBytes
        mov esi, ecx
.4:
        add esi, dword [esp]
        test esi, 10000h
        je short .5
        and esi, 0FFFFh
        inc edi
        push edi
        call VesaSetBankArg
        add esp, byte 4
.5:
        mov eax, dword [byte esp+08h]
        dec eax
        mov dword [byte esp+08h], eax
        test eax, eax
        jg short .2
.6:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret
XorRectClipped:
        push esi
        mov esi, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        mov ebx, dword [cliprect_y0]
        sub ebx, ecx
        test ebx, ebx
        jle short .1
        sub edx, ebx
        add ecx, ebx
.1:
        lea ebx, [ecx+edx]
        sub ebx, dword [cliprect_y1]
        test ebx, ebx
        jle short .2
        sub edx, ebx
.2:
        mov ebx, dword [cliprect_x0]
        sub ebx, esi
        test ebx, ebx
        jle short .3
        sub eax, ebx
        add esi, ebx
.3:
        lea ebx, [esi+eax]
        sub ebx, dword [cliprect_x1]
        test ebx, ebx
        jle short .4
        sub eax, ebx
.4:
        test eax, eax
        jle short .5
        test edx, edx
        jle short .5
        mov ebx, dword [byte esp+018h]
        push ebx
        push edx
        push eax
        push ecx
        push esi
        call XorBar
        add esp, byte 14h
.5:
        pop esi
        ret
        db 08Bh,0C0h
ClearScreenColour:
        sub esp, byte 60h
        mov eax, esp
        push eax
        call SaveDrawState
        add esp, byte 4
        call SetScreenTarget
        mov edx, dword [byte esp+064h]
        push edx
        call ClearScreen
        add esp, byte 4
        mov eax, esp
        push eax
        call RestoreDrawState
        add esp, byte 4
        add esp, byte 60h
        ret
        db 00h
DrawArtOpaque:
        push esi
        push edi
        push ebp
        sub esp, byte 18h
        mov eax, dword [byte esp+028h]
        mov edx, dword [byte esp+02Ch]
        mov esi, dword [byte esp+030h]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push esi
        push edx
        push eax
        call BlitArtOpaque
        add esp, byte 0Ch
        jmp near .6
.1:
        lea edi, [byte eax+010h]
        mov ebp, dword [byte eax+04h]
        sar ebp, 10h
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        mov dword [byte esp+0Ch], eax
        mov eax, dword [DrawVideoBase]
        mov dword [byte esp+04h], eax
        mov esi, dword [nosplit esi*4+ScreenRowTable]
        add esi, edx
        mov eax, dword [ScreenWidth]
        mov ecx, dword [byte esp+0Ch]
        sub eax, ecx
        mov dword [esp], eax
        mov eax, esi
        shr eax, 10h
        mov dword [byte esp+014h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
        and esi, 0FFFFh
        mov dword [byte esp+08h], ebp
        cmp dword [byte esp+0Ch], byte 0
        jle near .6
.2:
        cmp dword [byte esp+08h], byte 0
        jle near .6
        mov eax, dword [byte esp+0Ch]
        add eax, esi
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+04h]
        add eax, esi
        test byte [byte esp+012h], 1
        je short .3
        mov ebp, 10000h
        sub ebp, esi
        push ebp
        push eax
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        add edi, ebp
        mov ebp, dword [byte esp+010h]
        and ebp, 0FFFFh
        mov eax, dword [byte esp+014h]
        inc eax
        mov dword [byte esp+014h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
        push ebp
        mov ebx, dword [byte esp+08h]
        push ebx
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        mov esi, ebp
        add edi, ebp
        jmp short .4
.3:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push eax
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        mov esi, dword [byte esp+010h]
        add edi, dword [byte esp+0Ch]
.4:
        add esi, dword [esp]
        test esi, 10000h
        je short .5
        and esi, 0FFFFh
        mov ebp, dword [byte esp+014h]
        inc ebp
        mov dword [byte esp+014h], ebp
        push ebp
        call VesaSetBankArg
        add esp, byte 4
.5:
        dec dword [byte esp+08h]
        jmp near .2
.6:
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
DrawArtOpaqueAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        ret
DrawArtOpaqueHotspot:
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
        call DrawArtOpaque
        add esp, byte 0Ch
        ret
        mov ebx, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov edx, dword [byte esp+04h]
        mov eax, ebx
        test ecx, ecx
        je short .3
        add ecx, ebx
.1:
        mov bl, byte [edx]
        inc edx
        cmp bl, 0FFh
        je short .2
        mov byte [eax], bl
.2:
        inc eax
        cmp eax, ecx
        jb short .1
.3:
        ret
DrawArtKeyFF:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push eax
        push ebx
        push edx
        call BlitArtKeyFF
        add esp, byte 0Ch
        ret
.1:
        mov dword [RowCopyFunc], DrawArtOpaqueHotspot+028h
        push eax
        push ebx
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
DrawArtKeyFFAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtKeyFF
        add esp, byte 0Ch
        ret
DrawArtKeyFFHotspot:
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
        call DrawArtKeyFF
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h
FreeWindowBitmap:
        mov edx, dword [byte esp+04h]
        mov eax, dword [edx]
        mov eax, dword [byte eax+028h]
        sub eax, byte 8
        call removewindow
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        ret
        db 090h
FreeBitmap:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+028h]
        sub eax, byte 8
        call removewindow
        push edx
        call FreeMemBlock
        add esp, byte 4
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
