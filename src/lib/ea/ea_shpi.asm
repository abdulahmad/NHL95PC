; The index of a shape file.
bits 32
%include "hockey.inc"
section s_A2000 progbits alloc exec nowrite align=1
extern _os_handle_0, _os_handle_1, str_SHPI2, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, DrawDestBuffer
extern dword_F6138, strncpy_, strrchr_, AllocMemBlockEx, ResizeMemBlock, FindCachedFile, sub_9762C, unpack
extern DosFileInfo, sub_B0100, sub_B0148, bcopy, DosOpenFile, DosCloseFile, DosReadFile, DosSeekFile
extern SetBlitSource, sub_B72E9
global sub_A2000, loc_A2057, loc_A206E, loc_A207C, loc_A20F3, loc_A20F9, loc_A21D1, loc_A21DD
global loc_A220B, loc_A22A7, loc_A22DC, loc_A22E5, loc_A2338, loc_A2358, loc_A237C, loc_A23A6
global loc_A23C4, loc_A23C6, loc_A2404, loc_A242C, loc_A249C, loc_A253F, loc_A254A, loc_A257E
global loc_A2598, loc_A259A, loc_A25D8, loc_A25FB, SplitFileExt, loc_A261E, loc_A2636, loc_A2666
global loc_A2679, loc_A2682, loc_A26A5, loc_A26A8, loc_A26AA, ReadFileRange, loc_A26E9, loc_A26FF
global loc_A2704, loc_A2727, sub_A2744, sub_A275C, sub_A2774, loc_A2791, sub_A2794, sub_A27AC
global LoadPackedCore, loc_A280B, loc_A283C, loc_A2846, loc_A287A, loc_A28DF, ConvertShapeBank, loc_A29C6
global loc_A2AAA, ConvertShapeBankInPlace
sub_A2000:
        push esi
        push edi
        push ebp
        sub esp, byte 6Ch
        mov eax, dword [byte esp+07Ch]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov dword [byte esp+054h], edx
        push dword_F6138
        add eax, byte 10h
        push eax
        call SetBlitSource
        add esp, byte 8
        xor esi, esi
        xor edi, edi
        mov ecx, dword [dword esp+084h]
        mov ecx, dword [byte ecx+04h]
        mov dword [byte esp+05Ch], ecx
        mov eax, dword [dword esp+084h]
        mov eax, dword [eax]
        mov dword [byte esp+03Ch], eax
        mov dword [byte esp+020h], eax
        mov eax, 1
        mov edx, dword [dword esp+084h]
        add edx, byte 8
loc_A2057:
        mov ebx, dword [byte edx+04h]
        cmp ebx, dword [byte esp+05Ch]
        jle short loc_A206E
        mov dword [byte esp+05Ch], ebx
        mov ebx, dword [edx]
        mov dword [byte esp+020h], ebx
        mov esi, eax
        jmp short loc_A207C
loc_A206E:
        cmp ebx, ecx
        jge short loc_A207C
        mov ecx, ebx
        mov ebx, dword [edx]
        mov dword [byte esp+03Ch], ebx
        mov edi, eax
loc_A207C:
        inc eax
        add edx, byte 8
        cmp eax, byte 3
        jl short loc_A2057
        mov eax, dword [byte esp+020h]
        mov edx, dword [byte esp+03Ch]
        sub eax, edx
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+05Ch]
        sub eax, ecx
        mov dword [byte esp+018h], eax
        je near loc_A25FB
        mov ebp, edi
        or ebp, esi
        mov eax, 3
        sub eax, ebp
        mov ebp, eax
        shl eax, 3
        add eax, dword [dword esp+084h]
        mov edx, dword [byte eax+04h]
        mov dword [byte esp+040h], edx
        mov eax, dword [eax]
        mov dword [byte esp+08h], eax
        sub edx, ecx
        mov ebx, dword [byte esp+04h]
        imul edx, ebx
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+018h]
        add eax, dword [byte esp+03Ch]
        mov ebx, dword [byte esp+08h]
        sub ebx, eax
        test ebx, ebx
        jge short loc_A20F3
        neg ebx
        mov dword [byte esp+0Ch], 1
        jmp short loc_A20F9
loc_A20F3:
        xor eax, eax
        mov dword [byte esp+0Ch], eax
loc_A20F9:
        test ebx, ebx
        je near loc_A25FB
        cmp ebx, 600h
        jge near loc_A25FB
        shl ebp, 3
        add ebx, byte 2
        mov eax, dword [dword esp+080h]
        add eax, ebp
        mov dword [byte esp+010h], eax
        shl edi, 3
        mov eax, dword [dword esp+080h]
        add eax, edi
        mov dword [byte esp+014h], eax
        shl esi, 3
        mov eax, dword [dword esp+080h]
        add eax, esi
        mov dword [byte esp+01Ch], eax
        mov eax, dword [byte esp+014h]
        mov eax, dword [eax]
        mov edx, dword [byte esp+01Ch]
        mov esi, dword [edx]
        mov edx, eax
        sub edx, esi
        mov esi, dword [byte esp+05Ch]
        sub esi, dword [byte esp+040h]
        imul edx, esi
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+018h]
        mov edi, dword [byte esp+01Ch]
        mov edi, dword [edi]
        add edi, eax
        mov eax, dword [byte esp+014h]
        mov eax, dword [byte eax+04h]
        mov edx, dword [byte esp+01Ch]
        mov ebp, dword [byte edx+04h]
        mov edx, eax
        sub edx, ebp
        imul edx, esi
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+018h]
        mov esi, dword [byte esp+01Ch]
        mov esi, dword [byte esi+04h]
        add esi, eax
        mov edx, dword [byte esp+010h]
        mov edx, dword [edx]
        sub edx, edi
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+028h], eax
        mov edx, dword [byte esp+010h]
        mov edx, dword [byte edx+04h]
        sub edx, esi
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+024h], eax
        cmp dword [byte esp+0Ch], byte 0
        je short loc_A21D1
        neg dword [byte esp+028h]
        neg eax
        mov dword [byte esp+024h], eax
loc_A21D1:
        mov eax, dword_F6138
        mov edx, 8000h
        mov esi, edx
loc_A21DD:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short loc_A220B
        mov edi, edx
        sar edi, 10h
        mov dword [byte esp+044h], edi
        mov edi, esi
        sar edi, 10h
        imul edi, dword [byte esp+054h]
        mov ebp, dword [byte esp+044h]
        add edi, ebp
        mov dword [eax], edi
        add eax, byte 4
        add edx, dword [byte esp+028h]
        add esi, dword [byte esp+024h]
        jmp short loc_A21DD
loc_A220B:
        mov esi, ecx
        mov edi, dword [byte esp+03Ch]
        shl edi, 10h
        add edi, 8000h
        mov dword [byte esp+064h], edi
        mov ebp, dword [byte esp+014h]
        mov ebp, dword [byte ebp+00h]
        shl ebp, 10h
        add edi, 8000h
        add ebp, 8000h
        mov eax, dword [byte esp+014h]
        mov eax, dword [byte eax+04h]
        shl eax, 10h
        add eax, 8000h
        mov dword [byte esp+060h], eax
        xor eax, eax
        mov dword [byte esp+048h], eax
        mov dword [byte esp+04Ch], eax
        cmp dword [byte esp+0Ch], byte 0
        je short loc_A22A7
        mov ebx, ecx
        sub ebx, dword [byte esp+040h]
        je near loc_A22E5
        mov eax, dword [byte esp+014h]
        mov eax, dword [eax]
        mov dword [byte esp+068h], eax
        mov eax, dword [byte esp+010h]
        mov eax, dword [eax]
        mov edx, dword [byte esp+068h]
        sub edx, eax
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+04Ch], eax
        mov eax, dword [byte esp+014h]
        mov eax, dword [byte eax+04h]
        mov dword [byte esp+068h], eax
        mov eax, dword [byte esp+010h]
        mov eax, dword [byte eax+04h]
        mov edx, dword [byte esp+068h]
        sub edx, eax
        shl edx, 10h
        mov eax, edx
        jmp short loc_A22DC
loc_A22A7:
        mov ebx, ecx
        sub ebx, dword [byte esp+05Ch]
        je short loc_A22E5
        mov eax, dword [byte esp+014h]
        mov eax, dword [eax]
        mov edx, dword [byte esp+01Ch]
        sub eax, dword [edx]
        shl eax, 10h
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+04Ch], eax
        mov eax, dword [byte esp+014h]
        mov eax, dword [byte eax+04h]
        mov edx, dword [byte esp+01Ch]
        sub eax, dword [byte edx+04h]
        shl eax, 10h
        mov edx, eax
loc_A22DC:
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+048h], eax
loc_A22E5:
        xor ebx, ebx
        mov dword [byte esp+02Ch], ebx
        mov dword [byte esp+038h], ebx
        cmp esi, dword [byte esp+040h]
        je near loc_A242C
        mov edx, dword [byte esp+03Ch]
        sub edx, dword [byte esp+08h]
        sub ecx, dword [byte esp+040h]
        mov ebx, dword [byte esp+04h]
        shl ebx, 10h
        shl edx, 10h
        cmp dword [byte esp+0Ch], byte 0
        jne short loc_A2338
        test ecx, ecx
        je short loc_A2358
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+038h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        mov ecx, dword [byte esp+018h]
        idiv ecx
        mov dword [byte esp+02Ch], eax
        jmp short loc_A2358
loc_A2338:
        test ecx, ecx
        je short loc_A2358
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+02Ch], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        mov ebx, dword [byte esp+018h]
        idiv ebx
        mov dword [byte esp+038h], eax
loc_A2358:
        mov eax, dword [byte esp+038h]
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add edi, eax
        cmp esi, dword [byte esp+040h]
        jge near loc_A242C
        lea eax, [nosplit esi*4+00h]
        mov dword [byte esp+058h], eax
loc_A237C:
        cmp esi, dword [cliprect_y1]
        jge near loc_A25FB
        mov ebx, dword [byte esp+064h]
        sar ebx, 10h
        mov eax, edi
        sar eax, 10h
        sub eax, ebx
        inc eax
        lea edx, [ebx+eax]
        sub edx, dword [cliprect_x1]
        test edx, edx
        jle short loc_A23A6
        sub eax, edx
loc_A23A6:
        mov edx, dword [cliprect_x0]
        sub edx, ebx
        test edx, edx
        jle short loc_A23C4
        sub eax, edx
        add ebx, edx
        cmp edx, 600h
        jg near loc_A25FB
        jmp short loc_A23C6
loc_A23C4:
        xor edx, edx
loc_A23C6:
        test eax, eax
        jle short loc_A2404
        cmp esi, dword [cliprect_y0]
        jle short loc_A2404
        push eax
        mov eax, dword [byte esp+064h]
        sar eax, 10h
        mov ecx, dword [byte esp+058h]
        imul ecx, eax
        mov eax, ebp
        sar eax, 10h
        add eax, ecx
        add eax, dword [nosplit edx*4+dword_F6138]
        push eax
        mov eax, dword [DrawDestBuffer]
        add eax, dword [byte esp+060h]
        add ebx, dword [eax]
        push ebx
        call sub_B72E9
        add esp, byte 0Ch
loc_A2404:
        add ebp, dword [byte esp+04Ch]
        mov eax, dword [byte esp+048h]
        add dword [byte esp+060h], eax
        mov eax, dword [byte esp+02Ch]
        add dword [byte esp+064h], eax
        add edi, dword [byte esp+038h]
        add dword [byte esp+058h], byte 4
        inc esi
        cmp esi, dword [byte esp+040h]
        jl near loc_A237C
loc_A242C:
        mov eax, dword [byte esp+05Ch]
        cmp esi, eax
        je near loc_A25FB
        mov edx, dword [byte esp+08h]
        sub edx, dword [byte esp+020h]
        mov ecx, dword [byte esp+040h]
        sub ecx, eax
        mov eax, dword [byte esp+08h]
        shl eax, 10h
        mov dword [esp], eax
        mov ebx, dword [byte esp+04h]
        shl ebx, 10h
        shl edx, 10h
        mov eax, dword [byte esp+0Ch]
        test eax, eax
        jne short loc_A249C
        mov dword [byte esp+034h], eax
        mov dword [byte esp+030h], eax
        test ecx, ecx
        je near loc_A253F
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+030h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        mov ebx, dword [byte esp+018h]
        idiv ebx
        mov dword [byte esp+034h], eax
        mov edi, dword [esp]
        add edi, 100h
        jmp near loc_A253F
loc_A249C:
        xor eax, eax
        mov dword [byte esp+048h], eax
        mov dword [byte esp+04Ch], eax
        mov dword [byte esp+034h], eax
        mov dword [byte esp+030h], eax
        test ecx, ecx
        je near loc_A253F
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+034h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        mov ebx, dword [byte esp+018h]
        idiv ebx
        mov dword [byte esp+030h], eax
        mov eax, dword [esp]
        add eax, 8000h
        mov dword [byte esp+064h], eax
        mov ebp, dword [byte esp+010h]
        mov ebp, dword [byte ebp+00h]
        shl ebp, 10h
        add ebp, 8000h
        mov eax, dword [byte esp+010h]
        mov eax, dword [byte eax+04h]
        shl eax, 10h
        add eax, 8000h
        mov dword [byte esp+060h], eax
        mov eax, dword [byte esp+010h]
        mov eax, dword [eax]
        mov edx, dword [byte esp+01Ch]
        mov ebx, dword [edx]
        mov edx, eax
        sub edx, ebx
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+04Ch], eax
        mov eax, dword [byte esp+010h]
        mov eax, dword [byte eax+04h]
        mov edx, dword [byte esp+01Ch]
        mov ebx, dword [byte edx+04h]
        mov edx, eax
        sub edx, ebx
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+048h], eax
loc_A253F:
        lea eax, [nosplit esi*4+00h]
        mov dword [byte esp+050h], eax
loc_A254A:
        cmp esi, dword [byte esp+05Ch]
        jge near loc_A25FB
        cmp esi, dword [cliprect_y1]
        jge near loc_A25FB
        mov edx, dword [byte esp+064h]
        sar edx, 10h
        mov eax, edi
        sar eax, 10h
        sub eax, edx
        inc eax
        lea ebx, [edx+eax]
        sub ebx, dword [cliprect_x1]
        test ebx, ebx
        jle short loc_A257E
        sub eax, ebx
loc_A257E:
        mov ebx, dword [cliprect_x0]
        sub ebx, edx
        test ebx, ebx
        jle short loc_A2598
        sub eax, ebx
        add edx, ebx
        cmp ebx, 600h
        jg short loc_A25FB
        jmp short loc_A259A
loc_A2598:
        xor ebx, ebx
loc_A259A:
        test eax, eax
        jle short loc_A25D8
        cmp esi, dword [cliprect_y0]
        jl short loc_A25D8
        push eax
        mov eax, dword [byte esp+064h]
        sar eax, 10h
        mov ecx, dword [byte esp+058h]
        imul ecx, eax
        mov eax, ebp
        sar eax, 10h
        add eax, ecx
        add eax, dword [nosplit ebx*4+dword_F6138]
        push eax
        mov eax, dword [DrawDestBuffer]
        add eax, dword [byte esp+058h]
        add edx, dword [eax]
        push edx
        call sub_B72E9
        add esp, byte 0Ch
loc_A25D8:
        add ebp, dword [byte esp+04Ch]
        mov eax, dword [byte esp+048h]
        add dword [byte esp+060h], eax
        mov eax, dword [byte esp+034h]
        add dword [byte esp+064h], eax
        add edi, dword [byte esp+030h]
        add dword [byte esp+050h], byte 4
        inc esi
        jmp near loc_A254A
loc_A25FB:
        add esp, byte 6Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
SplitFileExt:
        push esi
        push edi
        push ebp
        mov esi, dword [byte esp+010h]
        mov ebp, dword [byte esp+014h]
        mov edi, ebp
        push edi
loc_A261E:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short loc_A2636
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short loc_A261E
loc_A2636:
        pop edi
        mov edx, 2Eh
        mov eax, ebp
        call strrchr_
        test eax, eax
        jne short loc_A26AA
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        lea edi, [ecx+ebp]
        mov byte [byte edi+04h], 0
        mov ecx, dword [byte esp+018h]
        cmp byte [ecx], 0
        je short loc_A2679
        mov esi, 4
loc_A2666:
        mov ebx, esi
        mov edx, ecx
        mov eax, edi
        call strncpy_
        add ecx, byte 4
        cmp byte [ecx], 0
        jne short loc_A2666
loc_A2679:
        mov esi, dword [byte esp+018h]
        cmp byte [esi], 0
        je short loc_A26A5
loc_A2682:
        mov ebx, 4
        mov edx, esi
        mov eax, edi
        call strncpy_
        push ebp
        call DosFileInfo
        add esp, byte 4
        test eax, eax
        jne short loc_A26A8
        add esi, byte 4
        cmp byte [esi], 0
        jne short loc_A2682
loc_A26A5:
        mov byte [edi], 0
loc_A26A8:
        mov eax, edi
loc_A26AA:
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h
ReadFileRange:
        push esi
        push edi
        push ebp
        sub esp, 100h
        mov edi, dword [dword esp+0110h]
        mov ebp, dword [dword esp+0118h]
        xor esi, esi
        mov edx, dword [dword esp+0114h]
        push edx
        push edi
        call DosSeekFile
        add esp, byte 8
        lea eax, [byte ebp-08h]
        cmp eax, 100h
        jl short loc_A26E9
        mov eax, 100h
loc_A26E9:
        cmp eax, byte 8
        jle short loc_A26FF
        lea eax, [byte ebp-08h]
        cmp eax, 100h
        jl short loc_A2704
        mov eax, 100h
        jmp short loc_A2704
loc_A26FF:
        mov eax, 8
loc_A2704:
        push eax
        lea eax, [byte esp+04h]
        push eax
        push edi
        call DosReadFile
        add esp, byte 0Ch
        test eax, eax
        je short loc_A2727
        push ebp
        lea eax, [byte esp+04h]
        push eax
        call sub_9762C
        mov esi, eax
        add esp, byte 8
loc_A2727:
        mov ebx, dword [dword esp+0114h]
        push ebx
        push edi
        call DosSeekFile
        add esp, byte 8
        mov eax, esi
        add esp, 100h
        pop ebp
        pop edi
        pop esi
        ret
sub_A2744:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call sub_A2774
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_A275C:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call sub_A2774
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_A2774:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        call LoadPackedCore
        add esp, byte 0Ch
        test eax, eax
        je short loc_A2791
        mov eax, dword [eax]
loc_A2791:
        ret
        db 08Bh,0C0h
sub_A2794:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadPackedCore
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_A27AC:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadPackedCore
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
LoadPackedCore:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, dword [byte esp+020h]
        mov edi, dword [byte esp+028h]
        push esi
        call FindCachedFile
        add esp, byte 4
        test eax, eax
        jne near loc_A28DF
        push edi
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        push esi
        call DosOpenFile
        add esp, byte 14h
        mov edx, dword [byte esp+08h]
        test edx, edx
        jne short loc_A280B
        xor eax, eax
        jmp near loc_A28DF
loc_A280B:
        push edi
        push edx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        mov ebp, dword [byte esp+0Ch]
        push ebp
        call ReadFileRange
        add esp, byte 10h
        mov dword [byte esp+0Ch], eax
        test eax, eax
        jne short loc_A283C
        mov eax, dword [esp]
        push eax
        call DosCloseFile
        add esp, byte 4
        xor eax, eax
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
loc_A283C:
        mov edx, dword [byte esp+08h]
        cmp eax, edx
        jg short loc_A2846
        mov eax, edx
loc_A2846:
        add eax, 3EBh
        and al, 0FCh
        mov ebp, eax
        push edi
        mov ebx, dword [byte esp+028h]
        push ebx
        push eax
        push esi
        call AllocMemBlockEx
        mov esi, eax
        add esp, byte 10h
        test eax, eax
        jne short loc_A287A
        mov ebp, dword [esp]
        push ebp
        call DosCloseFile
        add esp, byte 4
        xor eax, eax
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
loc_A287A:
        mov ecx, dword [eax]
        push ecx
        call _os_handle_0
        add esp, byte 4
        add eax, ebp
        sub eax, dword [byte esp+08h]
        and al, 0FCh
        push eax
        call _os_handle_1
        mov ebp, eax
        add esp, byte 4
        mov eax, dword [byte esp+08h]
        add eax, byte 3
        and al, 0FCh
        push eax
        push ebp
        mov eax, dword [byte esp+08h]
        push eax
        call DosReadFile
        add esp, byte 0Ch
        push edi
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [esi]
        push ebx
        push ebp
        call unpack
        add esp, byte 10h
        push edi
        mov ecx, dword [byte esp+010h]
        push ecx
        push esi
        call ResizeMemBlock
        add esp, byte 0Ch
        mov edi, dword [esp]
        push edi
        call DosCloseFile
        add esp, byte 4
        mov eax, esi
loc_A28DF:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
ConvertShapeBank:
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        push byte 4
        mov edx, dword [byte esp+040h]
        push edx
        call sub_B0100
        mov ebp, eax
        add esp, byte 8
        push byte 2
        mov eax, dword [byte esp+040h]
        add eax, byte 4
        push eax
        call sub_B0100
        mov esi, eax
        add esp, byte 8
        mov dword [byte esp+010h], eax
        mov eax, ebp
        add eax, byte 0Ah
        mov dword [byte esp+024h], eax
        mov ebx, dword [byte esp+040h]
        test ebx, ebx
        je near loc_A2AAA
        push byte 10h
        push ebx
        push str_SHPI2
        call bcopy
        add esp, byte 0Ch
        push byte 4
        mov edi, dword [byte esp+028h]
        push edi
        mov eax, dword [byte esp+048h]
        add eax, byte 4
        push eax
        call sub_B0148
        add esp, byte 0Ch
        push byte 4
        push esi
        mov eax, dword [byte esp+048h]
        add eax, byte 8
        push eax
        call sub_B0148
        add esp, byte 0Ch
        lea edi, [nosplit esi*8+00h]
        sub ebp, byte 6
        sub ebp, edi
        push ebp
        mov ebp, dword [byte esp+044h]
        add ebp, byte 10h
        lea eax, [edi+ebp]
        push eax
        mov eax, dword [byte esp+044h]
        add eax, byte 6
        mov dword [byte esp+030h], eax
        add eax, edi
        push eax
        call bcopy
        add esp, byte 0Ch
        xor eax, eax
        mov dword [byte esp+01Ch], eax
        test esi, esi
        jle near loc_A2AAA
        mov dword [byte esp+014h], edi
        mov edi, dword [byte esp+040h]
        add edi, byte 14h
        mov eax, dword [byte esp+028h]
        mov dword [byte esp+020h], eax
        shl esi, 2
        add esi, eax
        mov dword [byte esp+018h], esi
loc_A29C6:
        push byte 4
        mov edx, dword [byte esp+01Ch]
        push edx
        call sub_B0100
        add esp, byte 8
        add eax, byte 10h
        mov esi, dword [byte esp+014h]
        add esi, eax
        push byte 4
        push byte 4
        mov ebx, dword [byte esp+028h]
        push ebx
        call sub_B0100
        add esp, byte 8
        push eax
        push ebp
        call sub_B0148
        add esp, byte 0Ch
        push byte 4
        push esi
        push edi
        call sub_B0148
        add esp, byte 0Ch
        add esi, dword [byte esp+040h]
        push byte 10h
        lea eax, [byte esp+04h]
        push eax
        push esi
        call bcopy
        add esp, byte 0Ch
        mov al, byte [byte esp+0Ch]
        mov byte [esi], al
        mov al, byte [byte esp+0Dh]
        mov byte [byte esi+01h], al
        mov al, byte [byte esp+0Eh]
        mov byte [byte esi+02h], al
        mov al, byte [byte esp+0Fh]
        mov byte [byte esi+03h], al
        mov al, byte [esp]
        mov byte [byte esi+04h], al
        mov al, byte [byte esp+01h]
        mov byte [byte esi+05h], al
        mov al, byte [byte esp+02h]
        mov byte [byte esi+06h], al
        mov al, byte [byte esp+03h]
        mov byte [byte esi+07h], al
        mov al, byte [byte esp+04h]
        mov byte [byte esi+08h], al
        mov al, byte [byte esp+05h]
        mov byte [byte esi+09h], al
        mov al, byte [byte esp+06h]
        mov byte [byte esi+0Ah], al
        mov al, byte [byte esp+07h]
        mov byte [byte esi+0Bh], al
        mov al, byte [byte esp+08h]
        mov byte [byte esi+0Ch], al
        mov al, byte [byte esp+09h]
        mov byte [byte esi+0Dh], al
        mov al, byte [byte esp+0Ah]
        mov byte [byte esi+0Eh], al
        mov al, byte [byte esp+0Bh]
        mov byte [byte esi+0Fh], al
        add edi, byte 8
        add ebp, byte 8
        add dword [byte esp+020h], byte 4
        add dword [byte esp+018h], byte 4
        mov edx, dword [byte esp+01Ch]
        inc edx
        mov dword [byte esp+01Ch], edx
        cmp edx, dword [byte esp+010h]
        jl near loc_A29C6
loc_A2AAA:
        mov eax, dword [byte esp+024h]
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
ConvertShapeBankInPlace:
        push byte 0
        mov edx, dword [byte esp+08h]
        push edx
        call ConvertShapeBank
        add esp, byte 8
        ret
