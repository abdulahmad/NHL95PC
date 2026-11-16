; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_AFAE0 progbits alloc exec nowrite align=1
extern cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, DrawDestBuffer, dword_F6138, SetBlitSource, sub_B7420
global sub_AFAE0, loc_AFB37, loc_AFB4E, loc_AFB5C, loc_AFBD3, loc_AFBD9, loc_AFCB1, loc_AFCBD
global loc_AFCEB, loc_AFD87, loc_AFDBC, loc_AFDC5, loc_AFE18, loc_AFE38, loc_AFE5C, loc_AFE86
global loc_AFEA4, loc_AFEA6, loc_AFEE4, loc_AFF0C, loc_AFF7C, loc_B001F, loc_B002A, loc_B005E
global loc_B0078, loc_B007A, loc_B00B8, loc_B00DB
sub_AFAE0:
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
loc_AFB37:
        mov ebx, dword [byte edx+04h]
        cmp ebx, dword [byte esp+05Ch]
        jle short loc_AFB4E
        mov dword [byte esp+05Ch], ebx
        mov ebx, dword [edx]
        mov dword [byte esp+020h], ebx
        mov esi, eax
        jmp short loc_AFB5C
loc_AFB4E:
        cmp ebx, ecx
        jge short loc_AFB5C
        mov ecx, ebx
        mov ebx, dword [edx]
        mov dword [byte esp+03Ch], ebx
        mov edi, eax
loc_AFB5C:
        inc eax
        add edx, byte 8
        cmp eax, byte 3
        jl short loc_AFB37
        mov eax, dword [byte esp+020h]
        mov edx, dword [byte esp+03Ch]
        sub eax, edx
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+05Ch]
        sub eax, ecx
        mov dword [byte esp+018h], eax
        je near loc_B00DB
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
        jge short loc_AFBD3
        neg ebx
        mov dword [byte esp+0Ch], 1
        jmp short loc_AFBD9
loc_AFBD3:
        xor eax, eax
        mov dword [byte esp+0Ch], eax
loc_AFBD9:
        test ebx, ebx
        je near loc_B00DB
        cmp ebx, 600h
        jge near loc_B00DB
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
        je short loc_AFCB1
        neg dword [byte esp+028h]
        neg eax
        mov dword [byte esp+024h], eax
loc_AFCB1:
        mov eax, dword_F6138
        mov edx, 8000h
        mov esi, edx
loc_AFCBD:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short loc_AFCEB
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
        jmp short loc_AFCBD
loc_AFCEB:
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
        je short loc_AFD87
        mov ebx, ecx
        sub ebx, dword [byte esp+040h]
        je near loc_AFDC5
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
        jmp short loc_AFDBC
loc_AFD87:
        mov ebx, ecx
        sub ebx, dword [byte esp+05Ch]
        je short loc_AFDC5
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
loc_AFDBC:
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+048h], eax
loc_AFDC5:
        xor ebx, ebx
        mov dword [byte esp+02Ch], ebx
        mov dword [byte esp+038h], ebx
        cmp esi, dword [byte esp+040h]
        je near loc_AFF0C
        mov edx, dword [byte esp+03Ch]
        sub edx, dword [byte esp+08h]
        sub ecx, dword [byte esp+040h]
        mov ebx, dword [byte esp+04h]
        shl ebx, 10h
        shl edx, 10h
        cmp dword [byte esp+0Ch], byte 0
        jne short loc_AFE18
        test ecx, ecx
        je short loc_AFE38
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
        jmp short loc_AFE38
loc_AFE18:
        test ecx, ecx
        je short loc_AFE38
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
loc_AFE38:
        mov eax, dword [byte esp+038h]
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add edi, eax
        cmp esi, dword [byte esp+040h]
        jge near loc_AFF0C
        lea eax, [nosplit esi*4+00h]
        mov dword [byte esp+058h], eax
loc_AFE5C:
        cmp esi, dword [cliprect_y1]
        jge near loc_B00DB
        mov ebx, dword [byte esp+064h]
        sar ebx, 10h
        mov eax, edi
        sar eax, 10h
        sub eax, ebx
        inc eax
        lea edx, [ebx+eax]
        sub edx, dword [cliprect_x1]
        test edx, edx
        jle short loc_AFE86
        sub eax, edx
loc_AFE86:
        mov edx, dword [cliprect_x0]
        sub edx, ebx
        test edx, edx
        jle short loc_AFEA4
        sub eax, edx
        add ebx, edx
        cmp edx, 600h
        jg near loc_B00DB
        jmp short loc_AFEA6
loc_AFEA4:
        xor edx, edx
loc_AFEA6:
        test eax, eax
        jle short loc_AFEE4
        cmp esi, dword [cliprect_y0]
        jle short loc_AFEE4
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
        call sub_B7420
        add esp, byte 0Ch
loc_AFEE4:
        add ebp, dword [byte esp+04Ch]
        mov eax, dword [byte esp+048h]
        add dword [byte esp+060h], eax
        mov eax, dword [byte esp+02Ch]
        add dword [byte esp+064h], eax
        add edi, dword [byte esp+038h]
        add dword [byte esp+058h], byte 4
        inc esi
        cmp esi, dword [byte esp+040h]
        jl near loc_AFE5C
loc_AFF0C:
        mov eax, dword [byte esp+05Ch]
        cmp esi, eax
        je near loc_B00DB
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
        jne short loc_AFF7C
        mov dword [byte esp+034h], eax
        mov dword [byte esp+030h], eax
        test ecx, ecx
        je near loc_B001F
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
        jmp near loc_B001F
loc_AFF7C:
        xor eax, eax
        mov dword [byte esp+048h], eax
        mov dword [byte esp+04Ch], eax
        mov dword [byte esp+034h], eax
        mov dword [byte esp+030h], eax
        test ecx, ecx
        je near loc_B001F
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
loc_B001F:
        lea eax, [nosplit esi*4+00h]
        mov dword [byte esp+050h], eax
loc_B002A:
        cmp esi, dword [byte esp+05Ch]
        jge near loc_B00DB
        cmp esi, dword [cliprect_y1]
        jge near loc_B00DB
        mov edx, dword [byte esp+064h]
        sar edx, 10h
        mov eax, edi
        sar eax, 10h
        sub eax, edx
        inc eax
        lea ebx, [edx+eax]
        sub ebx, dword [cliprect_x1]
        test ebx, ebx
        jle short loc_B005E
        sub eax, ebx
loc_B005E:
        mov ebx, dword [cliprect_x0]
        sub ebx, edx
        test ebx, ebx
        jle short loc_B0078
        sub eax, ebx
        add edx, ebx
        cmp ebx, 600h
        jg short loc_B00DB
        jmp short loc_B007A
loc_B0078:
        xor ebx, ebx
loc_B007A:
        test eax, eax
        jle short loc_B00B8
        cmp esi, dword [cliprect_y0]
        jl short loc_B00B8
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
        call sub_B7420
        add esp, byte 0Ch
loc_B00B8:
        add ebp, dword [byte esp+04Ch]
        mov eax, dword [byte esp+048h]
        add dword [byte esp+060h], eax
        mov eax, dword [byte esp+034h]
        add dword [byte esp+064h], eax
        add edi, dword [byte esp+030h]
        add dword [byte esp+050h], byte 4
        inc esi
        jmp near loc_B002A
loc_B00DB:
        add esp, byte 6Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h
