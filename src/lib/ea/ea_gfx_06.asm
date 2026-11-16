; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_91370 progbits alloc exec nowrite align=1
extern byte_D42C0, byte_D42C1, byte_D42C2, byte_D42C3, byte_D42C4, cliprect_y0, cliprect_y1, ScreenWidth
extern dword_D30A8, KeyedDraw, DrawVideoBase, ScreenRowTable, dword_D42B0, dword_D42B4, dword_D42BC, dword_D42C8
extern dword_D42CC, dword_D42D0, dword_D42D4, dword_D42D8, dword_D42DC, dword_D42E0, RowCopyFunc, fontcolor
extern loc_91260, off_D42A4, sub_8E9D4, PutBlock, bcopy, SetClipWindow, sub_B5D80, sub_B5E00
extern sub_B69E4, BlitShapeFast
global DrawArt, loc_91391, DrawShape, sub_913D0, GrabBlock, loc_9142B, loc_9148A, loc_914E6
global loc_914FD, loc_91520, loc_91531, DrawShapeAtOwnPos, sub_91554, sub_91580, loc_915E7, loc_91616
global loc_9161C, loc_91637, loc_9163D, loc_91655, loc_91660, loc_91679, loc_9167B, loc_9169F
global loc_916A1, loc_91722, loc_9174E, loc_91765, loc_91787, loc_91790, loc_917A4, loc_917B8
global loc_917CD, loc_917E2, loc_917F7, loc_9180C, loc_91821, loc_91836, loc_9184B, loc_91860
global loc_91866, loc_91871, loc_91893, loc_91899, loc_918A9, loc_918BF, loc_918DB, loc_918EC
global loc_918EF, loc_918FB, loc_9191A, loc_91921, loc_91922, loc_91940, loc_91946, loc_91950
global loc_9195D, PrintString
DrawArt:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short loc_91391
        push eax
        push ebx
        push edx
        call sub_B69E4
        add esp, byte 0Ch
        ret
loc_91391:
        mov dword [RowCopyFunc], loc_91260
        push eax
        push ebx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
DrawShape:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArt
        add esp, byte 0Ch
        ret
sub_913D0:
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
        call DrawArt
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
GrabBlock:
        push esi
        push edi
        push ebp
        sub esp, byte 18h
        mov eax, dword [byte esp+028h]
        mov edx, dword [byte esp+02Ch]
        mov esi, dword [byte esp+030h]
        cmp dword [KeyedDraw], byte 0
        jne short loc_9142B
        push esi
        push edx
        push eax
        call BlitShapeFast
        add esp, byte 0Ch
        jmp near loc_91531
loc_9142B:
        mov word [byte eax+0Ch], dx
        mov word [byte eax+0Eh], si
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
        test ebp, ebp
        jle near loc_91531
loc_9148A:
        mov eax, dword [byte esp+0Ch]
        add eax, esi
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+04h]
        add eax, esi
        test byte [byte esp+012h], 1
        je short loc_914E6
        mov ebp, 10000h
        sub ebp, esi
        push ebp
        push edi
        push eax
        call bcopy
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
        push edi
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call bcopy
        add esp, byte 0Ch
        mov esi, ebp
        add edi, ebp
        jmp short loc_914FD
loc_914E6:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push edi
        push eax
        call bcopy
        add esp, byte 0Ch
        mov esi, dword [byte esp+010h]
        add edi, dword [byte esp+0Ch]
loc_914FD:
        add esi, dword [esp]
        test esi, 10000h
        je short loc_91520
        and esi, 0FFFFh
        mov ebp, dword [byte esp+014h]
        inc ebp
        mov dword [byte esp+014h], ebp
        push ebp
        call sub_B5E00
        add esp, byte 4
loc_91520:
        mov edx, dword [byte esp+08h]
        dec edx
        mov dword [byte esp+08h], edx
        test edx, edx
        jg near loc_9148A
loc_91531:
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
DrawShapeAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call GrabBlock
        add esp, byte 0Ch
        ret
sub_91554:
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
        call GrabBlock
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h
sub_91580:
        push esi
        push edi
        push ebp
        sub esp, byte 3Ch
        mov eax, dword [off_D42A4]
        mov dword [esp], eax
        xor eax, eax
        mov al, byte [byte_D42C1]
        movzx esi, byte [byte_D42C0]
        sub eax, esi
        inc eax
        mov dword [byte esp+02Ch], eax
        xor eax, eax
        mov esi, dword [esp]
        mov al, byte [byte esi+03h]
        sub eax, byte 30h
        mov dword [byte esp+08h], eax
        mov eax, dword [fontcolor]
        mov dword [byte esp+038h], eax
        cmp dword [dword_D42BC], 464E544Dh
        sete al
        and eax, 0FFh
        mov dword [byte esp+01Ch], eax
        mov eax, dword [dword_D42DC]
        mov dword [byte esp+028h], eax
        mov eax, dword [byte esp+04Ch]
        cmp byte [eax], 0
        je near loc_9195D
loc_915E7:
        mov eax, dword [byte esp+04Ch]
        lea ebx, [byte eax+01h]
        mov dword [byte esp+04Ch], ebx
        mov al, byte [eax]
        sub al, byte [byte_D42C0]
        movzx esi, al
        cmp esi, dword [byte esp+02Ch]
        jge near loc_91950
        mov edi, dword [dword_D42C8]
        test edi, edi
        je short loc_91616
        mov ah, byte [edi+esi]
        jmp short loc_9161C
loc_91616:
        mov ah, byte [byte_D42C2]
loc_9161C:
        movzx esi, ah
        mov dword [byte esp+014h], esi
        mov ebp, dword [dword_D42CC]
        test ebp, ebp
        je short loc_91637
        movzx esi, al
        mov edi, ebp
        mov ah, byte [edi+esi]
        jmp short loc_9163D
loc_91637:
        mov ah, byte [byte_D42C3]
loc_9163D:
        movzx esi, ah
        mov edx, dword [dword_D42D0]
        test edx, edx
        je short loc_91655
        movzx edi, al
        mov ebp, edx
        movzx edi, byte [edi+ebp]
        jmp short loc_91660
loc_91655:
        movzx edi, byte [byte_D42C4]
        add edi, dword [byte esp+014h]
loc_91660:
        mov dword [byte esp+04h], edi
        mov ecx, dword [dword_D42D4]
        test ecx, ecx
        je short loc_91679
        movzx edi, al
        mov ebp, ecx
        movzx edi, byte [edi+ebp]
        jmp short loc_9167B
loc_91679:
        xor edi, edi
loc_9167B:
        mov ebp, dword [dword_D42B0]
        add ebp, edi
        mov dword [byte esp+030h], ebp
        cmp dword [dword_D42D8], byte 0
        je short loc_9169F
        movzx edi, al
        mov ebp, dword [dword_D42D8]
        movzx ebp, byte [edi+ebp]
        jmp short loc_916A1
loc_9169F:
        xor ebp, ebp
loc_916A1:
        add ebp, dword [dword_D42B4]
        and eax, 0FFh
        lea edi, [nosplit eax*4+00h]
        mov eax, dword [dword_D42E0]
        mov edi, dword [edi+eax]
        cmp dword [byte esp+01Ch], byte 0
        je short loc_91722
        mov ecx, dword [byte esp+014h]
        test ecx, ecx
        jle near loc_91946
        test esi, esi
        jle near loc_91946
        add esi, ebp
        push esi
        push ebp
        mov eax, dword [byte esp+038h]
        add eax, ecx
        push eax
        mov eax, dword [byte esp+03Ch]
        push eax
        call SetClipWindow
        add esp, byte 10h
        push ebp
        mov eax, dword [byte esp+034h]
        sub eax, edi
        push eax
        mov edx, dword [byte esp+030h]
        push edx
        call DrawArt
        add esp, byte 0Ch
        mov ebx, dword [dword_D30A8]
        push ebx
        push byte 0
        mov ecx, dword [ScreenWidth]
        push ecx
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        jmp near loc_91946
loc_91722:
        test edi, edi
        je near loc_91946
        add edi, dword [esp]
        mov dword [byte esp+034h], esi
        mov esi, dword [byte esp+08h]
        cmp esi, byte 4
        jb short loc_9174E
        jbe near loc_91866
        cmp esi, byte 8
        je near loc_91922
        jmp near loc_91946
loc_9174E:
        cmp esi, byte 1
        jne near loc_91946
        mov eax, dword [byte esp+014h]
        add eax, byte 7
        sar eax, 3
        mov dword [byte esp+010h], eax
loc_91765:
        mov edx, dword [byte esp+034h]
        dec edx
        mov dword [byte esp+034h], edx
        cmp edx, byte 0FFFFFFFFh
        je near loc_91946
        cmp ebp, dword [cliprect_y0]
        jl short loc_91787
        cmp ebp, dword [cliprect_y1]
        jl short loc_91790
loc_91787:
        add edi, dword [byte esp+010h]
        jmp near loc_91860
loc_91790:
        mov esi, dword [byte esp+030h]
        mov eax, dword [byte esp+014h]
        mov dword [byte esp+018h], eax
        test eax, eax
        jle near loc_91860
loc_917A4:
        test byte [edi], 80h
        je short loc_917B8
        mov eax, dword [byte esp+038h]
        push eax
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_917B8:
        inc esi
        test byte [edi], 40h
        je short loc_917CD
        mov edx, dword [byte esp+038h]
        push edx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_917CD:
        inc esi
        test byte [edi], 20h
        je short loc_917E2
        mov ebx, dword [byte esp+038h]
        push ebx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_917E2:
        inc esi
        test byte [edi], 10h
        je short loc_917F7
        mov ecx, dword [byte esp+038h]
        push ecx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_917F7:
        inc esi
        test byte [edi], 8
        je short loc_9180C
        mov eax, dword [byte esp+038h]
        push eax
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_9180C:
        inc esi
        test byte [edi], 4
        je short loc_91821
        mov edx, dword [byte esp+038h]
        push edx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_91821:
        inc esi
        test byte [edi], 2
        je short loc_91836
        mov ebx, dword [byte esp+038h]
        push ebx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_91836:
        inc esi
        test byte [edi], 1
        je short loc_9184B
        mov ecx, dword [byte esp+038h]
        push ecx
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_9184B:
        inc esi
        mov ebx, dword [byte esp+018h]
        sub ebx, byte 8
        mov dword [byte esp+018h], ebx
        inc edi
        test ebx, ebx
        jg near loc_917A4
loc_91860:
        inc ebp
        jmp near loc_91765
loc_91866:
        mov eax, dword [byte esp+014h]
        inc eax
        sar eax, 1
        mov dword [byte esp+0Ch], eax
loc_91871:
        mov ebx, dword [byte esp+034h]
        dec ebx
        mov dword [byte esp+034h], ebx
        cmp ebx, byte 0FFFFFFFFh
        je near loc_91946
        cmp ebp, dword [cliprect_y0]
        jl short loc_91893
        cmp ebp, dword [cliprect_y1]
        jl short loc_91899
loc_91893:
        add edi, dword [byte esp+0Ch]
        jmp short loc_918EC
loc_91899:
        mov esi, dword [byte esp+030h]
        mov eax, dword [byte esp+014h]
        mov dword [byte esp+020h], eax
        test eax, eax
        jle short loc_918EC
loc_918A9:
        xor eax, eax
        mov al, byte [edi]
        sar eax, 4
        test eax, eax
        je short loc_918BF
        push eax
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_918BF:
        inc esi
        mov cl, byte [edi]
        test cl, 0Fh
        je short loc_918DB
        mov al, cl
        and al, 0Fh
        and eax, 0FFh
        push eax
        push ebp
        push esi
        call sub_B5D80
        add esp, byte 0Ch
loc_918DB:
        inc esi
        mov ecx, dword [byte esp+020h]
        sub ecx, byte 2
        mov dword [byte esp+020h], ecx
        inc edi
        test ecx, ecx
        jg short loc_918A9
loc_918EC:
        inc ebp
        jmp short loc_91871
loc_918EF:
        mov eax, dword [byte esp+030h]
        mov dword [byte esp+024h], eax
        mov esi, dword [byte esp+014h]
loc_918FB:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je short loc_91921
        mov bh, byte [edi]
        test bh, bh
        je short loc_9191A
        xor eax, eax
        mov al, bh
        push eax
        push ebp
        mov eax, dword [byte esp+02Ch]
        push eax
        call sub_B5D80
        add esp, byte 0Ch
loc_9191A:
        inc dword [byte esp+024h]
        inc edi
        jmp short loc_918FB
loc_91921:
        inc ebp
loc_91922:
        mov esi, dword [byte esp+034h]
        dec esi
        mov dword [byte esp+034h], esi
        cmp esi, byte 0FFFFFFFFh
        je short loc_91946
        cmp ebp, dword [cliprect_y0]
        jl short loc_91940
        cmp ebp, dword [cliprect_y1]
        jl short loc_918EF
loc_91940:
        add edi, dword [byte esp+014h]
        jmp short loc_91921
loc_91946:
        mov eax, dword [byte esp+04h]
        add dword [dword_D42B0], eax
loc_91950:
        mov eax, dword [byte esp+04Ch]
        cmp byte [eax], 0
        jne near loc_915E7
loc_9195D:
        add esp, byte 3Ch
        pop ebp
        pop edi
        pop esi
        ret
PrintString:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call sub_8E9D4
        add esp, byte 8
        mov ecx, dword [byte esp+04h]
        push ecx
        call sub_91580
        add esp, byte 4
        ret
