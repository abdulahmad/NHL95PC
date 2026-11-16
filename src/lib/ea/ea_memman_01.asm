; The EA memory manager. Allocating and freeing the blocks the game asks for.
bits 32
%include "hockey.inc"
section s_8C990 progbits alloc exec nowrite align=1
extern str_LOWMEM, str_HIGHMEM, str_GAP, str_ReleaseMemoryNotFound, str_ReservememINVALIDSIZE, str_ReservememOUTOFMEMORY, str_ReservememOUTOFMEMORY2, str_ReservememINVALIDTYPEFLAGS
extern str_ResizememINVALIDSIZE, str_ResizememblockNOROOMTO, str_FindmemblockBLOCKNOTFOUND, memblocklist, dword_D2F5C, dword_D2F60, dword_D2F64, dword_EDAB0
extern FatalError, memlist1, FindFreeSpace, sub_8D844, sub_8D990, sub_8DA98, sub_8DAB8, sub_8DB78
extern getmemblock, sub_8E3E4, sub_8E424, MemUnlock, unknown_libname_22
global sub_8C990, sub_8CA6C, loc_8CAC8, loc_8CAE8, sub_8CAF4, sub_8CBA4, loc_8CBD2, loc_8CBE3
global loc_8CBF5, loc_8CC1D, loc_8CC37, loc_8CC53, sub_8CC5C, sub_8CC70, sub_8CC8C, AllocMemBlock
global sub_8CCC4, sub_8CCE0, AllocMemBlockEx, reservemem, loc_8CD90, loc_8CDDC, loc_8CDEE, loc_8CE17
global loc_8CE32, loc_8CE3D, loc_8CE43, loc_8CE5A, loc_8CE68, loc_8CEC9, loc_8CEE4, loc_8CEFA
global loc_8CF54, loc_8CF66, loc_8CF7D, loc_8CF82, loc_8CF84, loc_8CF9B, loc_8CFA5, loc_8CFB4
global loc_8CFBD, loc_8D022, loc_8D035, loc_8D03D, loc_8D08F, loc_8D097, loc_8D0BF, loc_8D0C1
global sub_8D0C8, sub_8D0EC, sub_8D10C, sub_8D12C, sub_8D144, ResizeMemBlock, loc_8D1CB, loc_8D202
global loc_8D227, loc_8D241, loc_8D257, loc_8D271, loc_8D29A, findmemblock, loc_8D2AE, loc_8D2B9
global sub_8D2D2
sub_8C990:
        push esi
        push edi
        push ebp
        mov ebp, dword [byte esp+014h]
        mov edi, dword [byte esp+010h]
        and edi, 700h
        sar edi, 8
        lea esi, [nosplit edi*4+00h]
        add esi, edi
        shl esi, 2
        add esi, memlist1
        mov eax, dword [byte esp+01Ch]
        dec eax
        mov dword [byte esi+08h], eax
        add ebp, eax
        mov edi, eax
        not edi
        and ebp, edi
        and dword [byte esp+018h], edi
        mov eax, dword [byte esp+020h]
        dec eax
        mov dword [byte esi+0Ch], eax
        mov eax, dword [byte esp+024h]
        mov dword [byte esi+010h], eax
        call getmemblock
        mov edi, eax
        push byte 0Ch
        push str_LOWMEM
        add eax, byte 4
        push eax
        call sub_8E3E4
        add esp, byte 0Ch
        mov dword [edi], ebp
        mov dword [byte edi+014h], 0
        mov dword [byte edi+010h], 0
        mov dword [byte edi+024h], 0
        mov eax, dword [byte esp+010h]
        or ah, 80h
        mov dword [byte edi+018h], eax
        mov dword [esi], edi
        call getmemblock
        mov edi, eax
        push byte 0Ch
        push str_HIGHMEM
        add eax, byte 4
        push eax
        call sub_8E3E4
        add esp, byte 0Ch
        mov eax, dword [byte esp+018h]
        mov dword [edi], eax
        mov dword [byte edi+014h], 0
        mov dword [byte edi+010h], 0
        mov dword [byte edi+020h], 0
        mov eax, dword [byte esp+010h]
        or ax, 8020h
        mov dword [byte edi+018h], eax
        mov dword [byte esi+04h], edi
        mov eax, dword [esi]
        mov dword [byte eax+020h], edi
        mov eax, dword [esi]
        mov dword [byte edi+024h], eax
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_8CA6C:
        push esi
        push edi
        push ebp
        mov edx, dword [byte esp+010h]
        and edx, 700h
        sar edx, 8
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 2
        mov esi, memlist1
        add esi, eax
        mov edx, dword [byte esp+028h]
        push edx
        mov ebx, dword [byte esp+028h]
        push ebx
        mov ecx, dword [byte esp+028h]
        push ecx
        mov edi, dword [byte esp+028h]
        push edi
        mov ebp, dword [byte esp+028h]
        push ebp
        mov eax, dword [byte esp+028h]
        push eax
        call sub_8C990
        add esp, byte 18h
        mov ecx, eax
        mov edx, dword [byte esi+04h]
        mov ebx, dword [esi]
        mov ebx, dword [ebx]
        cmp ebx, dword [edx]
        jne short loc_8CAC8
        mov edx, dword [eax]
        mov dword [esi], edx
        jmp short loc_8CAE8
loc_8CAC8:
        mov ebx, dword [eax]
        mov dword [byte edx+020h], ebx
        mov edx, ebx
        mov ebx, dword [byte esi+04h]
        mov dword [byte edx+024h], ebx
        mov edx, dword [eax]
        mov edx, dword [edx]
        mov ebp, dword [ebx]
        sub edx, ebp
        mov dword [byte ebx+010h], edx
        mov ebx, edx
        mov edx, dword [byte esi+04h]
        mov dword [byte edx+014h], ebx
loc_8CAE8:
        mov eax, dword [byte eax+04h]
        mov dword [byte esi+04h], eax
        mov eax, ecx
        pop ebp
        pop edi
        pop esi
        ret
sub_8CAF4:
        push esi
        push edi
        push ebp
        mov ebp, dword [byte esp+014h]
        mov eax, dword [byte esp+010h]
        and eax, 700h
        sar eax, 8
        lea esi, [nosplit eax*4+00h]
        add esi, eax
        shl esi, 2
        mov edi, memlist1
        add edi, esi
        mov edx, dword [byte edi+08h]
        add ebp, edx
        mov eax, edx
        not eax
        and ebp, eax
        and dword [byte esp+018h], eax
        call getmemblock
        mov esi, eax
        push byte 0Ch
        push str_HIGHMEM
        add eax, byte 4
        push eax
        call sub_8E3E4
        add esp, byte 0Ch
        mov eax, dword [byte esp+018h]
        mov dword [esi], eax
        mov dword [byte esi+014h], 0
        mov dword [byte esi+010h], 0
        mov dword [byte esi+020h], 0
        mov eax, dword [byte esp+010h]
        or ax, 8020h
        mov dword [byte esi+018h], eax
        push byte 0Ch
        push str_GAP
        mov eax, dword [byte edi+04h]
        add eax, byte 4
        push eax
        call sub_8E3E4
        add esp, byte 0Ch
        mov eax, dword [byte edi+04h]
        mov dword [byte eax+020h], esi
        mov eax, dword [byte edi+04h]
        mov dword [byte esi+024h], eax
        mov ebx, dword [eax]
        mov edx, ebp
        sub edx, ebx
        mov dword [byte eax+010h], edx
        mov eax, edx
        mov edx, dword [byte esi+024h]
        mov dword [byte edx+014h], eax
        mov dword [byte edi+04h], esi
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
sub_8CBA4:
        push esi
        push edi
        push ebp
        mov edx, dword [byte esp+014h]
        mov esi, dword [byte esp+010h]
        and esi, 700h
        sar esi, 8
        lea eax, [nosplit esi*4+00h]
        add eax, esi
        shl eax, 2
        mov edi, memlist1
        add edi, eax
        mov esi, dword [edi]
        cmp esi, dword [byte edi+04h]
        je short loc_8CBE3
loc_8CBD2:
        mov eax, dword [esi]
        add eax, dword [byte esi+010h]
        cmp edx, eax
        je short loc_8CBE3
        mov esi, dword [byte esi+020h]
        cmp esi, dword [byte edi+04h]
        jne short loc_8CBD2
loc_8CBE3:
        cmp esi, dword [byte edi+04h]
        jne short loc_8CBF5
        push str_ReleaseMemoryNotFound
        call FatalError
        add esp, byte 4
loc_8CBF5:
        mov eax, dword [byte esi+020h]
        mov ebp, dword [eax]
        sub ebp, dword [esi]
        sub ebp, dword [byte esi+010h]
        cmp eax, dword [byte edi+04h]
        jne short loc_8CC1D
        mov dword [byte esi+010h], 0
        mov edx, dword [byte esi+010h]
        mov dword [byte esi+014h], edx
        mov dword [byte esi+020h], 0
        mov dword [byte edi+04h], esi
        jmp short loc_8CC37
loc_8CC1D:
        mov edx, dword [eax]
        mov ebx, dword [byte eax+010h]
        add ebx, edx
        mov edx, dword [esi]
        sub ebx, edx
        mov dword [byte esi+010h], ebx
        mov dword [byte esi+014h], ebx
        mov edx, dword [byte eax+020h]
        mov dword [byte esi+020h], edx
        mov dword [byte eax+024h], esi
loc_8CC37:
        push eax
        call sub_8DB78
        add esp, byte 4
        mov ebx, dword [edi]
        cmp esi, ebx
        jne short loc_8CC53
        mov dword [byte ebx+010h], 0
        mov eax, dword [byte ebx+010h]
        mov dword [byte ebx+014h], eax
loc_8CC53:
        mov eax, ebp
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_8CC5C:
        mov eax, dword [byte esp+04h]
        mov dword [dword_D2F60], eax
        mov eax, dword [byte esp+08h]
        mov dword [dword_D2F5C], eax
        ret
        db 090h
sub_8CC70:
        push byte 1
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call AllocMemBlockEx
        add esp, byte 10h
        ret
        db 08Bh,0C0h
sub_8CC8C:
        push byte 0
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call AllocMemBlockEx
        add esp, byte 10h
        ret
        db 08Bh,0C0h
AllocMemBlock:
        push byte 1
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call AllocMemBlockEx
        add esp, byte 10h
        mov eax, dword [eax]
        ret
sub_8CCC4:
        push byte 0
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call AllocMemBlockEx
        add esp, byte 10h
        mov eax, dword [eax]
        ret
sub_8CCE0:
        push esi
        mov edx, dword [byte esp+014h]
        push edx
        mov ebx, dword [byte esp+014h]
        push ebx
        mov ecx, dword [byte esp+014h]
        push ecx
        mov esi, dword [byte esp+014h]
        push esi
        call AllocMemBlockEx
        add esp, byte 10h
        mov eax, dword [eax]
        pop esi
        ret
        db 08Dh,040h,00h
AllocMemBlockEx:
        push esi
        push edi
        push ebp
        mov edx, dword [dword_EDAB0]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov ebx, dword [byte esp+01Ch]
        push ebx
        mov ecx, dword [byte esp+01Ch]
        push ecx
        mov esi, dword [byte esp+01Ch]
        push esi
        mov edi, dword [byte esp+01Ch]
        push edi
        call reservemem
        mov esi, eax
        add esp, byte 10h
        mov ebp, dword [dword_EDAB0]
        push ebp
        call MemUnlock
        add esp, byte 4
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
reservemem:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        cmp dword [byte esp+018h], byte 0
        jge short loc_8CD90
        cmp dword [byte esp+020h], byte 0
        je near loc_8D0BF
        mov edi, dword [dword_EDAB0]
        push edi
        call MemUnlock
        add esp, byte 4
        call sub_8DAB8
        push eax
        mov ebp, dword [byte esp+01Ch]
        push ebp
        push str_ReservememINVALIDSIZE
        call FatalError
        add esp, byte 0Ch
        jmp near loc_8D0BF
loc_8CD90:
        mov edx, dword [byte esp+01Ch]
        and edx, 700h
        sar edx, 8
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 2
        mov esi, memlist1
        add esi, eax
        mov ebx, dword [byte esp+014h]
        push ebx
        call sub_8E424
        add esp, byte 4
        mov dword [byte esp+014h], eax
        test byte [byte esp+01Ch], 40h
        je short loc_8CDDC
        mov edx, dword [byte esp+018h]
        mov edi, dword [byte esi+0Ch]
        add edx, edi
        mov eax, edi
        not eax
        and edx, eax
        mov dword [esp], edx
        jmp short loc_8CDEE
loc_8CDDC:
        mov eax, dword [byte esp+018h]
        mov ecx, dword [byte esi+08h]
        add eax, ecx
        mov edx, ecx
        not edx
        and eax, edx
        mov dword [esp], eax
loc_8CDEE:
        mov ebp, dword [esi]
        test ebp, ebp
        je near loc_8D097
        mov dl, byte [byte esp+01Ch]
        test dl, 20h
        jne near loc_8CF54
        test dl, 10h
        jne short loc_8CE17
        push ebp
        mov ecx, dword [byte esi+04h]
        push ecx
        call sub_8D844
        add esp, byte 8
loc_8CE17:
        mov ebp, dword [esi]
        mov edi, dword [byte ebp+020h]
        mov ebp, dword [byte ebp+00h]
        test byte [byte esp+01Ch], 40h
        je short loc_8CE32
        mov eax, dword [byte esi+0Ch]
        add eax, ebp
        mov ebp, dword [byte esi+0Ch]
        not ebp
        and ebp, eax
loc_8CE32:
        mov ebx, 40h
        xor edx, edx
        cmp ebp, dword [edi]
        jae short loc_8CE43
loc_8CE3D:
        mov edx, dword [edi]
        sub edx, ebp
        jmp short loc_8CE68
loc_8CE43:
        mov ebp, dword [edi]
        add ebp, dword [byte edi+010h]
        test dword [byte esp+01Ch], ebx
        je short loc_8CE5A
        mov eax, dword [byte esi+0Ch]
        add eax, ebp
        mov ebp, dword [byte esi+0Ch]
        not ebp
        and ebp, eax
loc_8CE5A:
        cmp edi, dword [byte esi+04h]
        je short loc_8CE68
        mov edi, dword [byte edi+020h]
        cmp ebp, dword [edi]
        jb short loc_8CE3D
        jmp short loc_8CE43
loc_8CE68:
        cmp edx, dword [esp]
        jl short loc_8CEC9
        call getmemblock
        mov esi, eax
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esi+018h], eax
        mov eax, dword [dword_D2F64]
        mov dword [byte esi+01Ch], eax
        mov edx, dword [byte esp+018h]
        mov dword [byte esi+014h], edx
        mov edx, dword [esp]
        mov dword [byte esi+010h], edx
        push byte 0Ch
        mov ebx, dword [byte esp+018h]
        push ebx
        inc eax
        mov dword [dword_D2F64], eax
        lea eax, [byte esi+04h]
        push eax
        call sub_8E3E4
        add esp, byte 0Ch
        mov dword [esi], ebp
        mov eax, dword [byte edi+024h]
        mov dword [byte esi+024h], eax
        mov dword [byte esi+020h], edi
        mov eax, dword [byte edi+024h]
        mov dword [byte eax+020h], esi
        mov dword [byte edi+024h], esi
        call sub_8DA98
        mov eax, esi
        jmp near loc_8D0C1
loc_8CEC9:
        cmp edi, dword [byte esi+04h]
        je short loc_8CEFA
        mov ebp, dword [edi]
        add ebp, dword [byte edi+010h]
        test dword [byte esp+01Ch], ebx
        je short loc_8CEE4
        mov edx, dword [byte esi+0Ch]
        add ebp, edx
        mov eax, edx
        not eax
        and ebp, eax
loc_8CEE4:
        mov edi, dword [byte edi+020h]
        xor edx, edx
        cmp ebp, dword [edi]
        jae near loc_8CE43
        mov edx, dword [edi]
        sub edx, ebp
        jmp near loc_8CE68
loc_8CEFA:
        mov ebx, dword [byte esp+01Ch]
        push ebx
        call FindFreeSpace
        add esp, byte 4
        test eax, eax
        jne near loc_8CE17
        mov ecx, dword [esi]
        push ecx
        mov edi, dword [byte esi+04h]
        push edi
        call sub_8D844
        add esp, byte 8
        test eax, eax
        jne near loc_8CE17
        cmp dword [byte esp+020h], byte 0
        je near loc_8D097
        mov eax, dword [dword_EDAB0]
        push eax
        call MemUnlock
        add esp, byte 4
        call sub_8DAB8
        push eax
        mov edx, dword [byte esp+01Ch]
        push edx
        push str_ReservememOUTOFMEMORY
        jmp near loc_8D08F
loc_8CF54:
        test dl, 10h
        jne short loc_8CF66
        mov eax, dword [byte esi+04h]
        push eax
        push ebp
        call sub_8D990
        add esp, byte 8
loc_8CF66:
        mov ebp, dword [byte esi+04h]
        mov edi, dword [byte ebp+024h]
        mov ebp, dword [byte ebp+00h]
        test byte [byte esp+01Ch], 40h
        je short loc_8CF7D
        mov eax, dword [byte esi+0Ch]
        not eax
        and ebp, eax
loc_8CF7D:
        mov ecx, 40h
loc_8CF82:
        xor ebx, ebx
loc_8CF84:
        mov eax, dword [edi]
        add eax, dword [byte edi+010h]
        test dword [byte esp+01Ch], ecx
        je short loc_8CF9B
        mov edx, dword [byte esi+0Ch]
        add edx, eax
        mov eax, dword [byte esi+0Ch]
        not eax
        and eax, edx
loc_8CF9B:
        cmp eax, ebp
        jae short loc_8CFA5
        mov ebx, ebp
        sub ebx, eax
        jmp short loc_8CFBD
loc_8CFA5:
        mov ebp, dword [edi]
        test dword [byte esp+01Ch], ecx
        je short loc_8CFB4
        mov eax, dword [byte esi+0Ch]
        not eax
        and ebp, eax
loc_8CFB4:
        cmp edi, dword [esi]
        je short loc_8CFBD
        mov edi, dword [byte edi+024h]
        jmp short loc_8CF84
loc_8CFBD:
        cmp ebx, dword [esp]
        jl short loc_8D022
        call getmemblock
        mov esi, eax
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esi+018h], eax
        mov eax, dword [dword_D2F64]
        mov dword [byte esi+01Ch], eax
        mov edx, dword [byte esp+018h]
        mov dword [byte esi+014h], edx
        mov edx, dword [esp]
        mov dword [byte esi+010h], edx
        push byte 0Ch
        mov ecx, dword [byte esp+018h]
        push ecx
        inc eax
        mov dword [dword_D2F64], eax
        lea eax, [byte esi+04h]
        push eax
        call sub_8E3E4
        add esp, byte 0Ch
        mov eax, dword [esp]
        sub ebp, eax
        mov dword [esi], ebp
        mov dword [byte esi+024h], edi
        mov eax, dword [byte edi+020h]
        mov dword [byte esi+020h], eax
        mov dword [byte eax+024h], esi
        mov dword [byte edi+020h], esi
        call sub_8DA98
        mov eax, esi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
loc_8D022:
        cmp edi, dword [esi]
        je short loc_8D03D
        mov ebp, dword [edi]
        test dword [byte esp+01Ch], ecx
        je short loc_8D035
        mov eax, dword [byte esi+0Ch]
        not eax
        and ebp, eax
loc_8D035:
        mov edi, dword [byte edi+024h]
        jmp near loc_8CF82
loc_8D03D:
        mov ecx, dword [byte esp+01Ch]
        push ecx
        call FindFreeSpace
        add esp, byte 4
        test eax, eax
        jne near loc_8CF66
        mov edi, dword [byte esi+04h]
        push edi
        mov ebp, dword [esi]
        push ebp
        call sub_8D990
        add esp, byte 8
        test eax, eax
        jne near loc_8CF66
        cmp dword [byte esp+020h], byte 0
        je short loc_8D097
        mov edx, dword [dword_EDAB0]
        push edx
        call MemUnlock
        add esp, byte 4
        call sub_8DAB8
        push eax
        mov ebx, dword [byte esp+01Ch]
        push ebx
        push str_ReservememOUTOFMEMORY2
loc_8D08F:
        call FatalError
        add esp, byte 0Ch
loc_8D097:
        cmp dword [byte esp+020h], byte 0
        je short loc_8D0BF
        mov esi, dword [dword_EDAB0]
        push esi
        call MemUnlock
        add esp, byte 4
        mov edi, dword [byte esp+01Ch]
        push edi
        push str_ReservememINVALIDTYPEFLAGS
        call FatalError
        add esp, byte 8
loc_8D0BF:
        xor eax, eax
loc_8D0C1:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
sub_8D0C8:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        call findmemblock
        add esp, byte 4
        push eax
        call ResizeMemBlock
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_8D0EC:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call findmemblock
        add esp, byte 4
        push eax
        call ResizeMemBlock
        add esp, byte 0Ch
        ret
        db 08Bh,0C0h
sub_8D10C:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call findmemblock
        add esp, byte 4
        push eax
        call ResizeMemBlock
        add esp, byte 0Ch
        ret
        db 08Bh,0C0h
sub_8D12C:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call ResizeMemBlock
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
sub_8D144:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call ResizeMemBlock
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
ResizeMemBlock:
        push esi
        push edi
        push ebp
        mov esi, dword [byte esp+010h]
        mov edx, dword [byte esi+018h]
        and edx, 700h
        shr edx, 8
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 2
        mov edi, memlist1
        add edi, eax
        mov edx, dword [dword_EDAB0]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov ebp, dword [byte esi+020h]
        mov ebp, dword [byte ebp+00h]
        sub ebp, dword [esi]
        mov eax, dword [byte esp+014h]
        mov ecx, dword [byte edi+08h]
        add eax, ecx
        mov edx, ecx
        not edx
        and eax, edx
        cmp dword [byte esp+014h], byte 0
        jge short loc_8D202
        mov ebx, dword [dword_EDAB0]
        push ebx
        call MemUnlock
        add esp, byte 4
        cmp dword [byte esp+014h], byte 0FFFFFFFFh
        jne short loc_8D1CB
        mov eax, ebp
        pop ebp
        pop edi
        pop esi
        ret
loc_8D1CB:
        cmp dword [byte esp+018h], byte 0
        je near loc_8D29A
        mov edi, dword [dword_EDAB0]
        push edi
        call MemUnlock
        add esp, byte 4
        call sub_8DAB8
        push eax
        mov ebp, dword [byte esp+018h]
        push ebp
        push str_ResizememINVALIDSIZE
        call FatalError
        add esp, byte 0Ch
        jmp near loc_8D29A
loc_8D202:
        cmp eax, ebp
        jge short loc_8D227
        mov edx, dword [byte esp+014h]
        mov dword [byte esi+014h], edx
        mov dword [byte esi+010h], eax
        mov edx, dword [dword_EDAB0]
        push edx
        call MemUnlock
        add esp, byte 4
        mov eax, dword [byte esp+014h]
        pop ebp
        pop edi
        pop esi
        ret
loc_8D227:
        mov eax, dword [byte esi+020h]
        test byte [byte eax+018h], 18h
        je short loc_8D241
        push eax
        mov eax, dword [byte edi+04h]
        push eax
        call sub_8D844
        add esp, byte 8
        test eax, eax
        jne short loc_8D257
loc_8D241:
        test byte [byte esi+018h], 18h
        je short loc_8D271
        push esi
        mov edx, dword [edi]
        push edx
        call sub_8D990
        add esp, byte 8
        test eax, eax
        je short loc_8D271
loc_8D257:
        mov eax, dword [byte esi+020h]
        mov eax, dword [eax]
        mov ebp, dword [esi]
        sub eax, ebp
        mov ebp, eax
        mov edx, dword [byte esp+014h]
        mov eax, dword [byte edi+08h]
        add edx, eax
        not eax
        and eax, edx
        jmp short loc_8D202
loc_8D271:
        mov ebx, dword [dword_EDAB0]
        push ebx
        call MemUnlock
        add esp, byte 4
        cmp dword [byte esp+018h], byte 0
        je short loc_8D29A
        push ebp
        mov esi, dword [byte esp+018h]
        push esi
        push str_ResizememblockNOROOMTO
        call FatalError
        add esp, byte 0Ch
loc_8D29A:
        xor eax, eax
        pop ebp
        pop edi
        pop esi
        ret
findmemblock:
        mov ebx, dword [byte esp+04h]
        mov eax, dword [memblocklist]
        mov eax, dword [eax]
        mov eax, dword [byte eax+020h]
loc_8D2AE:
        cmp ebx, dword [eax]
        jne short loc_8D2B9
        test byte [byte eax+019h], 80h
        jne short loc_8D2B9
        ret
loc_8D2B9:
        mov eax, dword [byte eax+020h]
        mov edx, dword [memblocklist]
        cmp eax, dword [byte edx+04h]
        jne short loc_8D2AE
        push ebx
        push str_FindmemblockBLOCKNOTFOUND
        call FatalError
sub_8D2D2:
        add esp, byte 8
        xor eax, eax
        ret
