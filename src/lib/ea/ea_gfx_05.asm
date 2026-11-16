; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_90D20 progbits alloc exec nowrite align=1
extern cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, ScreenWidth, KeyedDraw, DrawVideoBase, ScreenRowTable
extern dword_D4108, RowCopyFunc, FreeMemBlock, PushMemDescriptorLocked, removewindow, ClearScreen, SaveDrawState, RestoreDrawState
extern bcopy, FillMem, SetScreenTarget, sub_B5E00, FillRectCore, sub_B677D, BlitArtOpaque, sub_B693C
global FillRect, loc_90D65, loc_90DB4, loc_90DCD, loc_90DD9, loc_90DF5, loc_90E20, loc_90E71
global loc_90E82, loc_90EA5, loc_90EAD, loc_90EB8, sub_90EC0, loc_90EE1, loc_90EF0, loc_90F00
global loc_90F0F, loc_90F28, loc_90F29, sub_90F2C, XorBar, loc_90F7D, loc_90FC1, loc_91004
global loc_91015, loc_91030, loc_9103D, sub_91044, loc_91065, loc_91074, loc_91084, loc_91093
global loc_910AC, ClearScreenColour, DrawArtOpaque, loc_9110B, loc_91165, loc_911CE, loc_911E6, loc_91209
global loc_91212, sub_9121C, sub_91238, loc_91260, loc_91274, loc_9127E, loc_91283, sub_91284
global loc_912A5, sub_912C8, sub_912E4, sub_91310, FreeBitmap
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
        jle near loc_90EB8
        test edi, edi
        jle near loc_90EB8
        cmp dword [KeyedDraw], byte 0
        jne short loc_90D65
        push ebp
        push edi
        push edx
        mov edi, dword [byte esp+034h]
        push edi
        push esi
        call FillRectCore
        add esp, byte 14h
        jmp near loc_90EB8
loc_90D65:
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
        call sub_B5E00
        add esp, byte 4
        and esi, 0FFFFh
        mov dword [byte esp+04h], edi
        test edi, edi
        jle near loc_90EB8
        mov eax, dword [byte esp+02Ch]
        mov edx, dword [esp]
        add eax, edx
        mov dword [byte esp+0Ch], eax
loc_90DB4:
        mov edi, dword [byte esp+08h]
        mov edi, dword [nosplit edi*4+dword_D4108]
        sub edi, dword [byte esp+028h]
        mov ecx, dword [byte esp+04h]
        cmp edi, ecx
        jle short loc_90DCD
        mov edi, ecx
loc_90DCD:
        test edi, edi
        je short loc_90DF5
        add dword [byte esp+028h], edi
        sub dword [byte esp+04h], edi
loc_90DD9:
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
        jne short loc_90DD9
loc_90DF5:
        cmp dword [byte esp+04h], byte 0
        je near loc_90EAD
        test esi, 10000h
        je short loc_90E20
        and esi, 0FFFFh
        mov eax, dword [byte esp+08h]
        inc eax
        mov dword [byte esp+08h], eax
        push eax
        call sub_B5E00
        add esp, byte 4
loc_90E20:
        mov edi, dword [byte esp+02Ch]
        add edi, esi
        mov eax, dword [byte esp+010h]
        add eax, esi
        test edi, 10000h
        je short loc_90E71
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
        call sub_B5E00
        add esp, byte 4
        push ebp
        push esi
        mov eax, dword [byte esp+018h]
        push eax
        call FillMem
        add esp, byte 0Ch
        jmp short loc_90E82
loc_90E71:
        push ebp
        mov ebx, dword [byte esp+030h]
        push ebx
        push eax
        call FillMem
        add esp, byte 0Ch
        mov esi, edi
loc_90E82:
        add esi, dword [esp]
        test esi, 10000h
        je short loc_90EA5
        and esi, 0FFFFh
        mov ebx, dword [byte esp+08h]
        inc ebx
        mov dword [byte esp+08h], ebx
        push ebx
        call sub_B5E00
        add esp, byte 4
loc_90EA5:
        dec dword [byte esp+04h]
        inc dword [byte esp+028h]
loc_90EAD:
        cmp dword [byte esp+04h], byte 0
        jg near loc_90DB4
loc_90EB8:
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
sub_90EC0:
        push esi
        mov esi, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        mov ebx, dword [cliprect_y0]
        sub ebx, ecx
        test ebx, ebx
        jle short loc_90EE1
        sub edx, ebx
        add ecx, ebx
loc_90EE1:
        lea ebx, [ecx+edx]
        sub ebx, dword [cliprect_y1]
        test ebx, ebx
        jle short loc_90EF0
        sub edx, ebx
loc_90EF0:
        mov ebx, dword [cliprect_x0]
        sub ebx, esi
        test ebx, ebx
        jle short loc_90F00
        sub eax, ebx
        add esi, ebx
loc_90F00:
        lea ebx, [esi+eax]
        sub ebx, dword [cliprect_x1]
        test ebx, ebx
        jle short loc_90F0F
        sub eax, ebx
loc_90F0F:
        test eax, eax
        jle short loc_90F28
        test edx, edx
        jle short loc_90F28
        mov ebx, dword [byte esp+018h]
        push ebx
        push edx
        push eax
        push ecx
        push esi
        call FillRect
        add esp, byte 14h
loc_90F28:
        pop esi
loc_90F29:
        ret
        db 08Bh,0C0h
sub_90F2C:
        dec edx
        cmp edx, byte 0FFFFFFFFh
        je short loc_90F29
        xor byte [eax], bl
        inc eax
        jmp short sub_90F2C
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
        jle near loc_9103D
        test ebp, ebp
        jle near loc_9103D
        cmp dword [KeyedDraw], byte 0
        jne short loc_90F7D
        mov esi, dword [byte esp+02Ch]
        push esi
        push ebp
        push edx
        push edi
        push eax
        call sub_B677D
        add esp, byte 14h
        jmp near loc_9103D
loc_90F7D:
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
        call sub_B5E00
        add esp, byte 4
        and esi, 0FFFFh
        mov dword [byte esp+08h], ebp
        test ebp, ebp
        jle near loc_9103D
        movzx ebp, byte [byte esp+02Ch]
loc_90FC1:
        mov ecx, dword [byte esp+024h]
        add ecx, esi
        mov eax, dword [byte esp+04h]
        add eax, esi
        test ecx, 10000h
        je short loc_91004
        mov edx, 10000h
        sub edx, esi
        mov ebx, ebp
        call sub_90F2C
        mov esi, ecx
        and esi, 0FFFFh
        inc edi
        push edi
        call sub_B5E00
        add esp, byte 4
        mov ebx, ebp
        mov edx, esi
        mov eax, dword [byte esp+04h]
        call sub_90F2C
        jmp short loc_91015
loc_91004:
        xor ebx, ebx
        mov bl, byte [byte esp+02Ch]
        mov edx, dword [byte esp+024h]
        call sub_90F2C
        mov esi, ecx
loc_91015:
        add esi, dword [esp]
        test esi, 10000h
        je short loc_91030
        and esi, 0FFFFh
        inc edi
        push edi
        call sub_B5E00
        add esp, byte 4
loc_91030:
        mov eax, dword [byte esp+08h]
        dec eax
        mov dword [byte esp+08h], eax
        test eax, eax
        jg short loc_90FC1
loc_9103D:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret
sub_91044:
        push esi
        mov esi, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        mov ebx, dword [cliprect_y0]
        sub ebx, ecx
        test ebx, ebx
        jle short loc_91065
        sub edx, ebx
        add ecx, ebx
loc_91065:
        lea ebx, [ecx+edx]
        sub ebx, dword [cliprect_y1]
        test ebx, ebx
        jle short loc_91074
        sub edx, ebx
loc_91074:
        mov ebx, dword [cliprect_x0]
        sub ebx, esi
        test ebx, ebx
        jle short loc_91084
        sub eax, ebx
        add esi, ebx
loc_91084:
        lea ebx, [esi+eax]
        sub ebx, dword [cliprect_x1]
        test ebx, ebx
        jle short loc_91093
        sub eax, ebx
loc_91093:
        test eax, eax
        jle short loc_910AC
        test edx, edx
        jle short loc_910AC
        mov ebx, dword [byte esp+018h]
        push ebx
        push edx
        push eax
        push ecx
        push esi
        call XorBar
        add esp, byte 14h
loc_910AC:
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
        jne short loc_9110B
        push esi
        push edx
        push eax
        call BlitArtOpaque
        add esp, byte 0Ch
        jmp near loc_91212
loc_9110B:
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
        call sub_B5E00
        add esp, byte 4
        and esi, 0FFFFh
        mov dword [byte esp+08h], ebp
        cmp dword [byte esp+0Ch], byte 0
        jle near loc_91212
loc_91165:
        cmp dword [byte esp+08h], byte 0
        jle near loc_91212
        mov eax, dword [byte esp+0Ch]
        add eax, esi
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+04h]
        add eax, esi
        test byte [byte esp+012h], 1
        je short loc_911CE
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
        call sub_B5E00
        add esp, byte 4
        push ebp
        mov ebx, dword [byte esp+08h]
        push ebx
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        mov esi, ebp
        add edi, ebp
        jmp short loc_911E6
loc_911CE:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push eax
        push edi
        call dword [RowCopyFunc]
        add esp, byte 0Ch
        mov esi, dword [byte esp+010h]
        add edi, dword [byte esp+0Ch]
loc_911E6:
        add esi, dword [esp]
        test esi, 10000h
        je short loc_91209
        and esi, 0FFFFh
        mov ebp, dword [byte esp+014h]
        inc ebp
        mov dword [byte esp+014h], ebp
        push ebp
        call sub_B5E00
        add esp, byte 4
loc_91209:
        dec dword [byte esp+08h]
        jmp near loc_91165
loc_91212:
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_9121C:
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
sub_91238:
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
loc_91260:
        mov ebx, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov edx, dword [byte esp+04h]
        mov eax, ebx
        test ecx, ecx
        je short loc_91283
        add ecx, ebx
loc_91274:
        mov bl, byte [edx]
        inc edx
        cmp bl, 0FFh
        je short loc_9127E
        mov byte [eax], bl
loc_9127E:
        inc eax
        cmp eax, ecx
        jb short loc_91274
loc_91283:
        ret
sub_91284:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short loc_912A5
        push eax
        push ebx
        push edx
        call sub_B693C
        add esp, byte 0Ch
        ret
loc_912A5:
        mov dword [RowCopyFunc], loc_91260
        push eax
        push ebx
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
sub_912C8:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call sub_91284
        add esp, byte 0Ch
        ret
sub_912E4:
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
        call sub_91284
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h
sub_91310:
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
