; The EA memory manager. Allocating and freeing the blocks the game asks for.
bits 32
%include "hockey.inc"
section s_8D2F0 progbits alloc exec nowrite align=1
extern str_GetmemblockNOMEMORYBLOCKS, memblocklist, FreeSpaceList, dword_EDAAC, MemLockHandle, dword_EDAB4, FatalError, findmemblock
extern memlist1, reservemem, sub_8E3F8, sub_8E44C, MemUnlock, bcopy, unknown_libname_22
global PushMemDescriptorLocked, sub_8D31C, loc_8D340, sub_8D344, sub_8D35C, loc_8D379, loc_8D38E, sub_8D3A0
global MergeFreeSpace, loc_8D40C, loc_8D427, loc_8D438, loc_8D45C, loc_8D45E, sub_8D468, sub_8D484
global sub_8D494, sub_8D4B0, sub_8D4E8, loc_8D521, loc_8D53A, loc_8D542, sub_8D548, sub_8D558
global loc_8D591, loc_8D5B0, loc_8D5B8, sub_8D5C0, sub_8D5D0, FindFreeSpace, loc_8D640, loc_8D653
global loc_8D670, loc_8D683, loc_8D697, loc_8D6AA, loc_8D6D8, loc_8D708, loc_8D70A, FindCachedFileData
global loc_8D727, FindCachedFile, loc_8D78F, loc_8D79E, loc_8D7EA, loc_8D803, sub_8D80C, sub_8D844
global loc_8D85F, loc_8D861, loc_8D874, loc_8D87F, loc_8D88C, loc_8D898, loc_8D8AB, loc_8D8EC
global loc_8D93F, loc_8D946, loc_8D94E, sub_8D958, sub_8D990, loc_8D9A6, loc_8D9AC, loc_8D9C0
global loc_8D9CA, loc_8D9D6, loc_8D9E6, loc_8DA16, loc_8DA6E, loc_8DA8F, sub_8DA98, loc_8DAAD
global sub_8DAB8, sub_8DAE4, loc_8DB05, loc_8DB12, sub_8DB20, sub_8DB2C, loc_8DB39, loc_8DB42
global loc_8DB49, sub_8DB4C, loc_8DB60, loc_8DB6D, sub_8DB78, getmemblock, loc_8DBB1, MemPtrSize
global sub_8DBD4, MemDescSize
PushMemDescriptorLocked:
        mov edx, dword [MemLockHandle]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov ebx, dword [byte esp+04h]
        push ebx
        call sub_8D31C
        add esp, byte 4
        mov ecx, dword [MemLockHandle]
        push ecx
        call MemUnlock
        add esp, byte 4
        ret
sub_8D31C:
        mov eax, dword [byte esp+04h]
        test byte [byte eax+019h], 80h
        jne short loc_8D340
        mov ebx, dword [byte eax+024h]
        mov edx, dword [byte eax+020h]
        mov dword [byte ebx+020h], edx
        mov ebx, edx
        mov edx, dword [byte eax+024h]
        mov dword [byte ebx+024h], edx
        push eax
        call sub_8DB78
        add esp, byte 4
loc_8D340:
        ret
        db 08Dh,040h,00h
sub_8D344:
        mov edx, dword [byte esp+04h]
        push edx
        call findmemblock
        add esp, byte 4
        push eax
        call sub_8D35C
        add esp, byte 4
        ret
        db 090h
sub_8D35C:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov esi, dword [byte esp+08h]
        mov esi, dword [byte esi+020h]
        test byte [byte esi+018h], 20h
        jne short loc_8D38E
loc_8D379:
        mov esi, dword [byte esi+020h]
        mov ebx, dword [byte esi+024h]
        push ebx
        call sub_8D31C
        add esp, byte 4
        test byte [byte esi+018h], 20h
        je short loc_8D379
loc_8D38E:
        mov ecx, dword [MemLockHandle]
        push ecx
        call MemUnlock
        add esp, byte 4
        pop esi
        ret
        db 090h
sub_8D3A0:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov ebx, dword [byte esp+08h]
        push ebx
        call MergeFreeSpace
        mov esi, eax
        add esp, byte 4
        mov ecx, dword [MemLockHandle]
        push ecx
        call MemUnlock
        add esp, byte 4
        mov eax, esi
        pop esi
        ret
        db 08Bh,0C0h
MergeFreeSpace:
        push esi
        push edi
        push ebp
        mov esi, dword [FreeSpaceList]
        mov ebx, dword [byte esp+010h]
        mov edx, ebx
        and edx, 700h
        sar edx, 8
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 2
        mov ebp, memlist1
        add ebp, eax
        and ebx, byte 7
        xor edi, edi
        xor ecx, ecx
        mov eax, dword [byte ebp+00h]
        mov eax, dword [byte eax+020h]
loc_8D40C:
        test byte [byte eax+018h], 8
        je short loc_8D438
        mov edx, dword [byte eax+018h]
        and edx, byte 7
        cmp edx, ebx
        ja short loc_8D427
        jne short loc_8D438
        mov edx, esi
        sub edx, dword [byte eax+01Ch]
        cmp edx, ecx
        jl short loc_8D438
loc_8D427:
        mov edi, eax
        mov ebx, dword [byte eax+018h]
        and ebx, byte 7
        mov edx, esi
        mov ecx, dword [byte eax+01Ch]
        sub edx, ecx
        mov ecx, edx
loc_8D438:
        mov eax, dword [byte eax+020h]
        mov edx, dword [byte ebp+04h]
        cmp eax, edx
        jne short loc_8D40C
        mov dword [FreeSpaceList], esi
        test edi, edi
        je short loc_8D45C
        push edi
        call sub_8D31C
        add esp, byte 4
        mov eax, 1
        jmp short loc_8D45E
loc_8D45C:
        xor eax, edx
loc_8D45E:
        mov esi, dword [FreeSpaceList]
        pop ebp
        pop edi
        pop esi
        ret
sub_8D468:
        push byte 1
        mov edx, dword [byte esp+08h]
        push edx
        call findmemblock
        add esp, byte 4
        push eax
        call sub_8D4B0
        add esp, byte 8
        ret
        db 08Dh,040h,00h
sub_8D484:
        push byte 1
        mov edx, dword [byte esp+08h]
        push edx
        call sub_8D4B0
        add esp, byte 8
        ret
sub_8D494:
        mov edx, dword [byte esp+08h]
        push edx
        mov ebx, dword [byte esp+08h]
        push ebx
        call findmemblock
        add esp, byte 4
        push eax
        call sub_8D4B0
        add esp, byte 8
        ret
sub_8D4B0:
        push esi
        mov esi, dword [byte esp+08h]
        mov edx, dword [MemLockHandle]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov eax, dword [byte esi+018h]
        and al, 0F0h
        or al, 8
        mov edx, dword [byte esp+0Ch]
        or edx, eax
        mov dword [byte esi+018h], edx
        mov ebx, dword [MemLockHandle]
        push ebx
        call MemUnlock
        add esp, byte 4
        mov eax, esi
        pop esi
        ret
        db 090h
sub_8D4E8:
        push esi
        push edi
        push ebp
        mov esi, dword [byte esp+014h]
        and esi, 700h
        sar esi, 8
        lea eax, [nosplit esi*4+00h]
        add eax, esi
        shl eax, 2
        mov edi, memlist1
        add edi, eax
        mov edx, dword [byte esp+010h]
        push edx
        call sub_8E44C
        add esp, byte 4
        mov ebp, eax
        mov esi, dword [edi]
        cmp esi, dword [byte edi+04h]
        je short loc_8D542
loc_8D521:
        push byte 0Ch
        lea eax, [byte esi+04h]
        push eax
        push ebp
        call sub_8E3F8
        add esp, byte 0Ch
        test eax, eax
        jne short loc_8D53A
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        ret
loc_8D53A:
        mov esi, dword [byte esi+020h]
        cmp esi, dword [byte edi+04h]
        jne short loc_8D521
loc_8D542:
        xor eax, eax
        pop ebp
        pop edi
        pop esi
        ret
sub_8D548:
        push byte 0
        mov edx, dword [byte esp+08h]
        push edx
        call sub_8D4E8
        add esp, byte 8
        ret
sub_8D558:
        push esi
        push edi
        push ebp
        mov esi, dword [byte esp+014h]
        and esi, 700h
        sar esi, 8
        lea eax, [nosplit esi*4+00h]
        add eax, esi
        shl eax, 2
        mov edi, memlist1
        add edi, eax
        mov edx, dword [byte esp+010h]
        push edx
        call sub_8E44C
        add esp, byte 4
        mov ebp, eax
        mov esi, dword [edi]
        cmp esi, dword [byte edi+04h]
        je short loc_8D5B8
loc_8D591:
        push byte 0Ch
        lea eax, [byte esi+04h]
        push eax
        push ebp
        call sub_8E3F8
        add esp, byte 0Ch
        test eax, eax
        jne short loc_8D5B0
        test byte [byte esi+018h], 8
        je short loc_8D5B0
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        ret
loc_8D5B0:
        mov esi, dword [byte esi+020h]
        cmp esi, dword [byte edi+04h]
        jne short loc_8D591
loc_8D5B8:
        xor eax, eax
        pop ebp
        pop edi
        pop esi
        ret
        db 08Bh,0C0h
sub_8D5C0:
        push byte 0
        mov edx, dword [byte esp+08h]
        push edx
        call sub_8D558
        add esp, byte 8
        ret
sub_8D5D0:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov ebx, dword [byte esp+08h]
        push ebx
        call FindFreeSpace
        mov esi, eax
        add esp, byte 4
        mov ecx, dword [MemLockHandle]
        push ecx
        call MemUnlock
        add esp, byte 4
        mov eax, esi
        pop esi
        ret
        db 08Bh,0C0h
FindFreeSpace:
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov esi, dword [byte esp+024h]
        mov edx, esi
        and edx, 700h
        sar edx, 8
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 2
        mov ebx, memlist1
        add ebx, eax
        cmp dword [byte ebx+010h], byte 0
        jne short loc_8D640
        push esi
        call MergeFreeSpace
        add esp, byte 4
        jmp near loc_8D70A
loc_8D640:
        mov edi, esi
        and edi, byte 7
        xor ebp, ebp
        xor edx, edx
        mov esi, dword [ebx]
        mov esi, dword [byte esi+020h]
        mov ecx, 7
loc_8D653:
        test byte [byte esi+018h], 8
        je short loc_8D683
        mov eax, dword [byte esi+018h]
        and eax, ecx
        cmp eax, edi
        ja short loc_8D670
        jne short loc_8D683
        mov eax, dword [FreeSpaceList]
        sub eax, dword [byte esi+01Ch]
        cmp eax, edx
        jl short loc_8D683
loc_8D670:
        mov ebp, esi
        mov edi, dword [byte esi+018h]
        and edi, ecx
        mov eax, dword [FreeSpaceList]
        mov edx, dword [byte esi+01Ch]
        sub eax, edx
        mov edx, eax
loc_8D683:
        mov esi, dword [byte esi+020h]
        cmp esi, dword [byte ebx+04h]
        jne short loc_8D653
        test ebp, ebp
        je near loc_8D708
        xor eax, eax
        mov edx, esi
loc_8D697:
        mov bl, byte [byte edx+04h]
        mov byte [esp+eax], bl
        inc edx
        inc eax
        cmp eax, byte 0Ch
        jl short loc_8D697
        xor dl, dl
        mov byte [byte esp+0Ch], dl
loc_8D6AA:
        push byte 0
        mov eax, dword [byte esi+018h]
        or al, 8
        push eax
        mov edx, dword [byte ebp+014h]
        push edx
        lea eax, [byte esp+0Ch]
        push eax
        call reservemem
        add esp, byte 10h
        mov dword [byte esp+010h], eax
        test eax, eax
        jne short loc_8D6D8
        push edi
        call FindFreeSpace
        add esp, byte 4
        test eax, eax
        jne short loc_8D6AA
loc_8D6D8:
        mov ebx, dword [byte esp+010h]
        test ebx, ebx
        je short loc_8D708
        mov ecx, dword [byte ebp+014h]
        push ecx
        mov esi, dword [ebx]
        push esi
        mov edi, dword [byte ebp+00h]
        push edi
        call bcopy
        add esp, byte 0Ch
        push ebp
        call sub_8D31C
        add esp, byte 4
        mov eax, 1
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        ret
loc_8D708:
        xor eax, eax
loc_8D70A:
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
FindCachedFileData:
        mov edx, dword [byte esp+04h]
        push edx
        call FindCachedFile
        add esp, byte 4
        test eax, eax
        je short loc_8D727
        mov eax, dword [eax]
loc_8D727:
        ret
FindCachedFile:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, dword [byte esp+014h]
        push ebp
        call sub_8D5C0
        mov edi, eax
        add esp, byte 4
        test eax, eax
        je short loc_8D78F
        mov ah, byte [byte eax+018h]
        and ah, 0F7h
        mov byte [byte edi+018h], ah
        test ah, 10h
        jne near loc_8D803
        push byte 0
        mov edx, dword [byte edi+018h]
        push edx
        mov ebx, dword [byte edi+014h]
        push ebx
        push ebp
        call reservemem
        mov esi, eax
        add esp, byte 10h
        test eax, eax
        je near loc_8D803
        mov ecx, dword [byte edi+014h]
        push ecx
        mov ebp, dword [eax]
        push ebp
        mov eax, dword [edi]
        push eax
        call bcopy
        add esp, byte 0Ch
        push edi
        call PushMemDescriptorLocked
        add esp, byte 4
        mov edi, esi
        jmp short loc_8D803
loc_8D78F:
        mov esi, dword [memblocklist]
        mov esi, dword [byte esi+010h]
        mov edi, dword [byte eax+018h]
        mov dword [esp], edi
loc_8D79E:
        push esi
        push ebp
        call sub_8D558
        mov edi, eax
        add esp, byte 8
        test eax, eax
        je short loc_8D7EA
        and byte [byte eax+018h], 0F7h
        push byte 0
        mov edx, dword [byte eax+018h]
        push edx
        mov ebx, dword [byte eax+014h]
        push ebx
        push ebp
        call reservemem
        mov esi, eax
        add esp, byte 10h
        mov ebp, dword [esp]
        mov dword [byte edi+018h], ebp
        mov ecx, dword [byte edi+014h]
        push ecx
        mov ebp, dword [eax]
        push ebp
        mov eax, dword [edi]
        push eax
        call bcopy
        add esp, byte 0Ch
        mov edi, esi
        mov eax, edi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
loc_8D7EA:
        and esi, 700h
        sar esi, 8
        imul esi, byte 14h
        add esi, memlist1
        mov esi, dword [byte esi+010h]
        test esi, esi
        jne short loc_8D79E
loc_8D803:
        mov eax, edi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
sub_8D80C:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov eax, dword [memblocklist]
        mov ebx, dword [eax]
        push ebx
        mov ecx, dword [byte eax+04h]
        push ecx
        call sub_8D844
        add esp, byte 8
        mov esi, dword [MemLockHandle]
        push esi
        call MemUnlock
        add esp, byte 4
        pop esi
        ret
        db 08Dh,040h,00h
sub_8D844:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, dword [byte esp+020h]
        mov ebp, dword [byte esp+024h]
        xor edx, edx
        mov dword [byte esp+08h], edx
        mov eax, dword [esi]
        mov edi, dword [byte esi+024h]
        mov esi, edi
loc_8D85F:
        xor ecx, ecx
loc_8D861:
        mov edx, dword [edi]
        mov ebx, dword [byte edi+010h]
        add ebx, edx
        cmp ebx, eax
        jae short loc_8D874
        mov ecx, eax
        sub ecx, ebx
        mov eax, ebx
        jmp short loc_8D87F
loc_8D874:
        cmp edi, ebp
        je short loc_8D87F
        mov eax, edx
        mov edi, dword [byte edi+024h]
        jmp short loc_8D861
loc_8D87F:
        test ecx, ecx
        jne short loc_8D88C
        mov eax, dword [byte esp+08h]
        jmp near loc_8D94E
loc_8D88C:
        test byte [byte esi+018h], 18h
        je short loc_8D898
        mov ebx, dword [esi]
        cmp eax, ebx
        jae short loc_8D8AB
loc_8D898:
        cmp esi, ebp
        jne near loc_8D946
        mov eax, dword [byte esp+08h]
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
loc_8D8AB:
        mov edx, ebx
        mov ebx, dword [byte esi+010h]
        add ebx, edx
        mov dword [byte esp+04h], ebx
        lea ebx, [eax+ecx]
        mov dword [byte esp+0Ch], ebx
        cmp eax, dword [byte esp+04h]
        jne short loc_8D8EC
        mov eax, dword [byte esp+0Ch]
        mov ebx, dword [byte esi+010h]
        sub eax, ebx
        mov dword [esp], eax
        push ebx
        push eax
        push edx
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [esp]
        mov dword [esi], eax
        mov dword [byte esp+08h], 1
        jmp near loc_8D85F
loc_8D8EC:
        cmp ecx, dword [byte esi+010h]
        jl short loc_8D93F
        mov eax, dword [byte esp+0Ch]
        mov ebx, dword [byte esi+010h]
        sub eax, ebx
        mov dword [esp], eax
        push ebx
        push eax
        push edx
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [esp]
        mov dword [esi], eax
        mov edx, dword [byte esi+024h]
        mov eax, dword [byte esi+020h]
        mov dword [byte edx+020h], eax
        mov edx, eax
        mov eax, dword [byte esi+024h]
        mov dword [byte edx+024h], eax
        mov eax, dword [byte edi+020h]
        mov dword [byte esi+020h], eax
        mov dword [byte esi+024h], edi
        mov eax, dword [byte edi+020h]
        mov dword [byte eax+024h], esi
        mov dword [byte edi+020h], esi
        mov eax, dword [esi]
        mov dword [byte esp+08h], 1
        jmp near loc_8D85F
loc_8D93F:
        mov eax, dword [edi]
        jmp near loc_8D85F
loc_8D946:
        mov esi, dword [byte esi+024h]
        jmp near loc_8D88C
loc_8D94E:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_8D958:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call unknown_libname_22
        add esp, byte 4
        mov eax, dword [memblocklist]
        mov ebx, dword [byte eax+04h]
        push ebx
        mov ecx, dword [eax]
        push ecx
        call sub_8D990
        add esp, byte 8
        mov esi, dword [MemLockHandle]
        push esi
        call MemUnlock
        add esp, byte 4
        pop esi
        ret
        db 08Dh,040h,00h
sub_8D990:
        push esi
        push edi
        push ebp
        mov edi, dword [byte esp+010h]
        xor edx, edx
        mov ebp, dword [edi]
        mov esi, dword [byte edi+020h]
        mov edi, esi
        xor eax, eax
        cmp ebp, dword [esi]
        jae short loc_8D9AC
loc_8D9A6:
        mov eax, dword [esi]
        sub eax, ebp
        jmp short loc_8D9C0
loc_8D9AC:
        cmp esi, dword [byte esp+014h]
        je short loc_8D9C0
        mov ebp, dword [esi]
        add ebp, dword [byte esi+010h]
        mov esi, dword [byte esi+020h]
        cmp ebp, dword [esi]
        jb short loc_8D9A6
        jmp short loc_8D9AC
loc_8D9C0:
        test eax, eax
        jne short loc_8D9CA
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
loc_8D9CA:
        test byte [byte edi+018h], 18h
        je short loc_8D9D6
        mov ebx, dword [edi]
        cmp ebp, ebx
        jbe short loc_8D9E6
loc_8D9D6:
        cmp edi, dword [byte esp+014h]
        jne near loc_8DA8F
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
loc_8D9E6:
        cmp edi, esi
        jne short loc_8DA16
        mov ecx, dword [byte esi+010h]
        push ecx
        push ebp
        push ebx
        call bcopy
        add esp, byte 0Ch
        mov dword [esi], ebp
        add ebp, dword [byte esi+010h]
        mov edx, 1
        xor eax, eax
        cmp ebp, dword [esi]
        jae short loc_8D9AC
        mov eax, dword [esi]
        sub eax, ebp
        test eax, eax
        jne short loc_8D9CA
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
loc_8DA16:
        mov ecx, dword [byte edi+010h]
        cmp eax, ecx
        jl short loc_8DA6E
        push ecx
        push ebp
        push ebx
        call bcopy
        add esp, byte 0Ch
        mov dword [edi], ebp
        mov edx, dword [byte edi+024h]
        mov eax, dword [byte edi+020h]
        mov dword [byte edx+020h], eax
        mov edx, eax
        mov eax, dword [byte edi+024h]
        mov dword [byte edx+024h], eax
        mov dword [byte edi+020h], esi
        mov eax, dword [byte esi+024h]
        mov dword [byte edi+024h], eax
        mov dword [byte eax+020h], edi
        mov dword [byte esi+024h], edi
        add ebp, dword [byte edi+010h]
        mov edx, 1
        xor eax, eax
        cmp ebp, dword [esi]
        jae near loc_8D9AC
        mov eax, dword [esi]
        sub eax, ebp
        test eax, eax
        jne near loc_8D9CA
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
loc_8DA6E:
        mov ebp, dword [esi]
        add ebp, dword [byte esi+010h]
        xor eax, eax
        cmp ebp, dword [esi]
        jae near loc_8D9AC
        mov eax, dword [esi]
        sub eax, ebp
        test eax, eax
        jne near loc_8D9CA
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
loc_8DA8F:
        mov edi, dword [byte edi+020h]
        jmp near loc_8D9CA
        db 090h
sub_8DA98:
        push ebx
        push ecx
        push edx
        call sub_8DAE4
        cmp eax, dword [dword_EDAB4]
        jge short loc_8DAAD
        mov dword [dword_EDAB4], eax
loc_8DAAD:
        mov eax, dword [dword_EDAB4]
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
sub_8DAB8:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call unknown_libname_22
        add esp, byte 4
        call sub_8DAE4
        mov esi, eax
        mov ebx, dword [MemLockHandle]
        push ebx
        call MemUnlock
        add esp, byte 4
        mov eax, esi
        pop esi
        ret
        db 08Bh,0C0h
sub_8DAE4:
        mov eax, dword [memblocklist]
        mov edx, dword [eax]
        push edx
        mov ebx, dword [byte eax+04h]
        push ebx
        call sub_8D844
        add esp, byte 8
        mov ebx, dword [memblocklist]
        mov ebx, dword [ebx]
        mov eax, dword [byte ebx+020h]
        xor ecx, ecx
loc_8DB05:
        mov edx, dword [eax]
        sub edx, dword [ebx]
        sub edx, dword [byte ebx+010h]
        cmp edx, ecx
        jle short loc_8DB12
        mov ecx, edx
loc_8DB12:
        mov ebx, eax
        mov eax, dword [byte eax+020h]
        test eax, eax
        jne short loc_8DB05
        mov eax, ecx
        ret
        db 08Bh,0C0h
sub_8DB20:
        call sub_8DAB8
        sar eax, 4
        ret
        db 08Dh,040h,00h
sub_8DB2C:
        mov eax, dword [memblocklist]
        mov eax, dword [eax]
        xor edx, edx
        test eax, eax
        je short loc_8DB49
loc_8DB39:
        test byte [byte eax+018h], 18h
        jne short loc_8DB42
        add edx, dword [byte eax+010h]
loc_8DB42:
        mov eax, dword [byte eax+020h]
        test eax, eax
        jne short loc_8DB39
loc_8DB49:
        mov eax, edx
        ret
sub_8DB4C:
        mov eax, dword [byte esp+04h]
        mov dword [dword_EDAAC], eax
        xor edx, edx
        mov ebx, dword [byte esp+08h]
        dec ebx
        test ebx, ebx
        jle short loc_8DB6D
loc_8DB60:
        lea ecx, [byte eax+028h]
        mov dword [byte eax+020h], ecx
        mov eax, ecx
        inc edx
        cmp edx, ebx
        jl short loc_8DB60
loc_8DB6D:
        mov dword [byte eax+020h], 0
        ret
        db 08Dh,040h,00h
sub_8DB78:
        mov edx, dword [byte esp+04h]
        mov eax, dword [dword_EDAAC]
        mov dword [byte edx+020h], eax
        mov dword [dword_EDAAC], edx
        ret
        db 090h
getmemblock:
        cmp dword [dword_EDAAC], byte 0
        jne short loc_8DBB1
        mov ebx, dword [MemLockHandle]
        push ebx
        call MemUnlock
        add esp, byte 4
        push str_GetmemblockNOMEMORYBLOCKS
        call FatalError
        add esp, byte 4
loc_8DBB1:
        mov eax, dword [dword_EDAAC]
        mov edx, dword [byte eax+020h]
        mov dword [dword_EDAAC], edx
        ret
MemPtrSize:
        mov edx, dword [byte esp+04h]
        push edx
        call findmemblock
        add esp, byte 4
        mov eax, dword [byte eax+014h]
        ret
        db 08Dh,040h,00h
sub_8DBD4:
        mov eax, dword [byte esp+04h]
        mov eax, dword [eax]
        ret
        db 090h
MemDescSize:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+014h]
        ret
