; The movie player. Reads a CMV file and draws its frames.
bits 32
%include "hockey.inc"
section s_1AC25 progbits alloc exec nowrite align=1
extern __CHK, str_CmvMemBlock, str_CmvPalette, FreeMemBlock, AllocMemBlock, AllocMemBlockUnlocked, FreeBitmap, bcopy
extern CreateBitmap
global sub_1AC25, loc_1AC96, sub_1AC9A, loc_1ACBB, loc_1ACCB, loc_1ACDB, loc_1ACEB, sub_1ACF1
global loc_1AD12, sub_1AD16, loc_1ADE0, loc_1ADF0, loc_1AE3B, loc_1AE65, sub_1AE6B, loc_1AEE2
global loc_1AEEF, loc_1AF62, loc_1AFB8, loc_1AFD3, loc_1AFDB, loc_1AFEF, sub_1B002, loc_1B029
global loc_1B05A, loc_1B087, loc_1B08A, sub_1B092, sub_1B09F, sub_1B0AD, sub_1B0BB, sub_1B0C9
global sub_1B0D7, sub_1B0E5
sub_1AC25:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push byte 0
        push dword 42Ch
        push str_CmvMemBlock
        call AllocMemBlockUnlocked
        add esp, byte 0Ch
        test eax, eax
        je short loc_1AC96
        mov dword [eax], 0
        mov dword [byte eax+04h], 0
        mov dword [byte eax+08h], 0
        mov dword [byte eax+0Ch], 0
        mov dword [byte eax+010h], 0
        mov dword [byte eax+014h], 0
        mov dword [byte eax+018h], 0
        mov dword [byte eax+01Ch], 0
        mov dword [byte eax+020h], 0
        mov dword [byte eax+024h], 0
        mov dword [byte eax+028h], 0
loc_1AC96:
        pop edx
        pop ecx
        pop ebx
        ret
sub_1AC9A:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov esi, eax
        mov edx, dword [byte eax+01Ch]
        test edx, edx
        je short loc_1ACBB
        push edx
        call FreeMemBlock
        add esp, byte 4
loc_1ACBB:
        mov ecx, dword [byte esi+020h]
        test ecx, ecx
        je short loc_1ACCB
        push ecx
        call FreeBitmap
        add esp, byte 4
loc_1ACCB:
        mov ebp, dword [byte esi+024h]
        test ebp, ebp
        je short loc_1ACDB
        push ebp
        call FreeBitmap
        add esp, byte 4
loc_1ACDB:
        mov edx, dword [byte esi+028h]
        test edx, edx
        je short loc_1ACEB
        push edx
        call FreeBitmap
        add esp, byte 4
loc_1ACEB:
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_1ACF1:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, eax
        test eax, eax
        je short loc_1AD12
        call sub_1AC9A
        push edx
        call FreeMemBlock
        add esp, byte 4
loc_1AD12:
        pop edx
        pop ecx
        pop ebx
        ret
sub_1AD16:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov ebp, eax
        lea esi, [byte edx+0Ah]
        call sub_1AC9A
        xor eax, eax
        mov al, byte [esi]
        mov dword [edi], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [edi], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+04h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+04h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+08h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+08h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+010h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+010h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+0Ch], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+0Ch], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+014h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+014h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+018h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        mov edx, dword [byte edi+018h]
        add edx, eax
        mov dword [byte edi+018h], edx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov dword [esp], eax
        push byte 0
        push eax
        push str_CmvPalette
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte edi+01Ch], eax
        xor eax, eax
        mov ecx, dword [esp]
        jmp short loc_1ADF0
loc_1ADE0:
        movzx edi, byte [esi]
        mov edx, edi
        sar edx, 2
        mov edi, dword [byte ebp+01Ch]
        inc esi
        mov byte [edi+eax], dl
        inc eax
loc_1ADF0:
        cmp eax, ecx
        jl short loc_1ADE0
        push byte 0
        mov esi, dword [byte ebp+08h]
        push esi
        mov edi, dword [byte ebp+04h]
        push edi
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte ebp+020h], eax
        push byte 0
        mov eax, dword [byte ebp+08h]
        push eax
        mov edx, dword [byte ebp+04h]
        push edx
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte ebp+024h], eax
        push byte 0
        mov ebx, dword [byte ebp+08h]
        push ebx
        mov ecx, dword [byte ebp+04h]
        push ecx
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte ebp+028h], eax
        mov edx, dword [byte ebp+020h]
        mov edx, dword [byte edx+020h]
        xor esi, esi
loc_1AE3B:
        mov edi, esi
        and edi, byte 0Fh
        sub edi, byte 7
        mov eax, esi
        sar eax, 4
        and eax, byte 0Fh
        sub eax, byte 7
        imul eax, edx
        add edi, eax
        mov eax, esi
        mov dword [byte ebp+eax*4+02Ch], edi
        inc esi
        cmp esi, 0FFh
        jle short loc_1AE3B
        add esp, byte 4
loc_1AE65:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
sub_1AE6B:
        push dword 4Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 38h
        mov esi, eax
        mov ecx, edx
        mov eax, dword [byte eax+020h]
        mov edx, dword [byte eax+02Ch]
        mov dword [byte esp+018h], edx
        mov edx, dword [byte esi+024h]
        mov edx, dword [byte edx+02Ch]
        mov dword [byte esp+014h], edx
        mov edx, dword [byte esi+028h]
        mov edx, dword [byte edx+02Ch]
        mov dword [byte esp+010h], edx
        mov edi, dword [byte eax+020h]
        mov edx, edi
        shl edx, 2
        sub edx, edi
        mov dword [byte esp+08h], edx
        mov edx, esi
        add edx, byte 2Ch
        mov dword [byte esp+01Ch], edx
        mov edx, dword [byte esi+04h]
        mov dword [byte esp+030h], edx
        mov ebp, edx
        add edx, edx
        mov dword [byte esp+028h], edx
        add edx, ebp
        mov dword [byte esp+024h], edx
        mov eax, dword [byte eax+028h]
        mov edx, dword [byte esp+018h]
        mov edi, dword [eax]
        lea eax, [edx+edi]
        mov edx, dword [byte esi+08h]
        mov dword [byte esp+0Ch], edx
        jmp near loc_1AFEF
loc_1AEE2:
        mov edx, dword [byte esp+030h]
        mov dword [byte esp+02Ch], edx
        jmp near loc_1AFDB
loc_1AEEF:
        lea edx, [byte ecx+01h]
        mov dword [byte esp+034h], edx
        mov ebp, dword [byte esp+024h]
        add ebp, eax
        mov edi, dword [byte esp+028h]
        add edi, eax
        mov esi, dword [byte esp+030h]
        add esi, eax
        mov edx, eax
        sub edx, dword [byte esp+018h]
        mov dword [byte esp+020h], edx
        mov dl, byte [ecx]
        cmp dl, 0FFh
        je short loc_1AF62
        mov cl, dl
        and ecx, 0FFh
        shl ecx, 2
        mov edx, dword [byte esp+01Ch]
        add edx, ecx
        mov ecx, dword [byte esp+014h]
        add ecx, dword [byte esp+020h]
        add ecx, dword [edx]
        mov dword [esp], ecx
        mov edx, dword [ecx]
        mov dword [eax], edx
        mov edx, ecx
        add edx, dword [byte esp+030h]
        mov edx, dword [edx]
        mov dword [esi], edx
        mov edx, dword [esp]
        add edx, dword [byte esp+028h]
        mov edx, dword [edx]
        mov dword [edi], edx
        mov edx, dword [esp]
        add edx, dword [byte esp+024h]
        mov edx, dword [edx]
        mov dword [byte ebp+00h], edx
        mov ecx, dword [byte esp+034h]
        jmp short loc_1AFD3
loc_1AF62:
        lea edx, [byte ebx+01h]
        mov cl, byte [ebx]
        cmp cl, 0FFh
        je short loc_1AFB8
        mov bl, cl
        and ebx, 0FFh
        shl ebx, 2
        add ebx, dword [byte esp+01Ch]
        mov ecx, dword [byte esp+010h]
        add ecx, dword [byte esp+020h]
        add ecx, dword [ebx]
        mov dword [byte esp+04h], ecx
        mov ebx, dword [ecx]
        mov dword [eax], ebx
        mov ebx, ecx
        add ebx, dword [byte esp+030h]
        mov ebx, dword [ebx]
        mov dword [esi], ebx
        mov ebx, dword [byte esp+04h]
        add ebx, dword [byte esp+028h]
        mov ebx, dword [ebx]
        mov dword [edi], ebx
        mov ebx, dword [byte esp+04h]
        add ebx, dword [byte esp+024h]
        mov ebx, dword [ebx]
        mov dword [byte ebp+00h], ebx
        mov ecx, dword [byte esp+034h]
        mov ebx, edx
        jmp short loc_1AFD3
loc_1AFB8:
        mov ecx, dword [byte esp+034h]
        mov ebx, dword [edx]
        mov dword [eax], ebx
        mov ebx, dword [byte edx+04h]
        mov dword [esi], ebx
        mov ebx, dword [byte edx+08h]
        mov dword [edi], ebx
        mov ebx, dword [byte edx+0Ch]
        mov dword [byte ebp+00h], ebx
        lea ebx, [byte edx+010h]
loc_1AFD3:
        add eax, byte 4
        sub dword [byte esp+02Ch], byte 4
loc_1AFDB:
        cmp dword [byte esp+02Ch], byte 0
        jg near loc_1AEEF
        add eax, dword [byte esp+08h]
        sub dword [byte esp+0Ch], byte 4
loc_1AFEF:
        cmp dword [byte esp+0Ch], byte 0
        jg near loc_1AEE2
        add esp, byte 38h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_1B002:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov esi, edx
        mov edi, eax
        mov edx, dword [byte eax+04h]
        mov ebx, dword [byte eax+08h]
        lea eax, [byte esi+08h]
        test esi, esi
        jne short loc_1B029
        mov eax, dword [byte ecx+020h]
        jmp short loc_1B08A
loc_1B029:
        mov ebp, dword [byte ecx+028h]
        mov esi, dword [byte ecx+024h]
        mov dword [byte ecx+028h], esi
        mov esi, dword [byte ecx+020h]
        mov dword [byte ecx+024h], esi
        mov dword [byte ecx+020h], ebp
        lea esi, [byte eax+02h]
        cmp word [eax], byte 0
        jne short loc_1B05A
        imul edx, ebx
        push edx
        mov eax, dword [byte ebp+02Ch]
        add eax, byte 10h
        push eax
        push esi
        call bcopy
        add esp, byte 0Ch
        jmp short loc_1B087
loc_1B05A:
        mov eax, edx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        mov ebp, eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        imul eax, ebp
        lea ebx, [esi+eax]
        mov edx, esi
        mov eax, ecx
        call sub_1AE6B
loc_1B087:
        mov eax, dword [byte edi+020h]
loc_1B08A:
        mov eax, dword [byte eax+02Ch]
        jmp near loc_1AE65
sub_1B092:
        push dword 4
        call __CHK
        mov eax, dword [eax]
        ret
sub_1B09F:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+04h]
        ret
sub_1B0AD:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+08h]
        ret
sub_1B0BB:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+0Ch]
        ret
sub_1B0C9:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+014h]
        ret
sub_1B0D7:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+018h]
        ret
sub_1B0E5:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+01Ch]
        ret
