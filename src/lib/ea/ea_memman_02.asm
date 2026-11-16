; The EA memory manager. Allocating and freeing the blocks the game asks for.
bits 32
%include "hockey.inc"
section s_8D2F0 progbits alloc exec nowrite align=1
extern str_GetmemblockNOMEMORYBLOCKS, memblocklist, FreeSpaceList, MemDescriptorTop, MemLockHandle, dword_EDAB4, FatalError, findmemblock
extern memlist1, reservemem, StrCompareN, FileNameOnly, MemUnlock, bcopy, MemLock
global PushMemDescriptorLocked, UnlinkMemBlockLocked, FreeMemBlocksAfter, FreeBlocksAfter, MergeFreeSpaceLocked, MergeFreeSpace, MarkBlockPurgeable, MarkDescPurgeable
global SetMemBlockPurgeLevel, SetMemBlockPurge, FindNamedBlock, FindMemBlockNamed, FindNamedBlockNext, FindMemBlockNamedNext, FindFreeSpaceLocked, FindFreeSpace
global FindCachedFileData, FindCachedFile, CompactDownLocked, CompactMemListDown, CompactUpLocked, CompactMemListUp, MemTrackLargestFree, MemLargestFree
global MemLargestFreeOfList, MemLargestFreeParas, MemFreeSize, InitMemDescriptors, PushMemDescriptor, getmemblock, MemPtrSize, MemDescPtr
global MemDescSize
PushMemDescriptorLocked:
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
        add esp, byte 4
        mov ebx, dword [byte esp+04h]
        push ebx
        call UnlinkMemBlockLocked
        add esp, byte 4
        mov ecx, dword [MemLockHandle]
        push ecx
        call MemUnlock
        add esp, byte 4
        ret
UnlinkMemBlockLocked:
        mov eax, dword [byte esp+04h]
        test byte [byte eax+019h], 80h
        jne short .1
        mov ebx, dword [byte eax+024h]
        mov edx, dword [byte eax+020h]
        mov dword [byte ebx+020h], edx
        mov ebx, edx
        mov edx, dword [byte eax+024h]
        mov dword [byte ebx+024h], edx
        push eax
        call PushMemDescriptor
        add esp, byte 4
.1:
        ret
        db 08Dh,040h,00h
FreeMemBlocksAfter:
        mov edx, dword [byte esp+04h]
        push edx
        call findmemblock
        add esp, byte 4
        push eax
        call FreeBlocksAfter
        add esp, byte 4
        ret
        db 090h
FreeBlocksAfter:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
        add esp, byte 4
        mov esi, dword [byte esp+08h]
        mov esi, dword [byte esi+020h]
        test byte [byte esi+018h], 20h
        jne short .2
.1:
        mov esi, dword [byte esi+020h]
        mov ebx, dword [byte esi+024h]
        push ebx
        call UnlinkMemBlockLocked
        add esp, byte 4
        test byte [byte esi+018h], 20h
        je short .1
.2:
        mov ecx, dword [MemLockHandle]
        push ecx
        call MemUnlock
        add esp, byte 4
        pop esi
        ret
        db 090h
MergeFreeSpaceLocked:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
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
.1:
        test byte [byte eax+018h], 8
        je short .3
        mov edx, dword [byte eax+018h]
        and edx, byte 7
        cmp edx, ebx
        ja short .2
        jne short .3
        mov edx, esi
        sub edx, dword [byte eax+01Ch]
        cmp edx, ecx
        jl short .3
.2:
        mov edi, eax
        mov ebx, dword [byte eax+018h]
        and ebx, byte 7
        mov edx, esi
        mov ecx, dword [byte eax+01Ch]
        sub edx, ecx
        mov ecx, edx
.3:
        mov eax, dword [byte eax+020h]
        mov edx, dword [byte ebp+04h]
        cmp eax, edx
        jne short .1
        mov dword [FreeSpaceList], esi
        test edi, edi
        je short .4
        push edi
        call UnlinkMemBlockLocked
        add esp, byte 4
        mov eax, 1
        jmp short .5
.4:
        xor eax, edx
.5:
        mov esi, dword [FreeSpaceList]
        pop ebp
        pop edi
        pop esi
        ret
MarkBlockPurgeable:
        push byte 1
        mov edx, dword [byte esp+08h]
        push edx
        call findmemblock
        add esp, byte 4
        push eax
        call SetMemBlockPurge
        add esp, byte 8
        ret
        db 08Dh,040h,00h
MarkDescPurgeable:
        push byte 1
        mov edx, dword [byte esp+08h]
        push edx
        call SetMemBlockPurge
        add esp, byte 8
        ret
SetMemBlockPurgeLevel:
        mov edx, dword [byte esp+08h]
        push edx
        mov ebx, dword [byte esp+08h]
        push ebx
        call findmemblock
        add esp, byte 4
        push eax
        call SetMemBlockPurge
        add esp, byte 8
        ret
SetMemBlockPurge:
        push esi
        mov esi, dword [byte esp+08h]
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
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
FindNamedBlock:
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
        call FileNameOnly
        add esp, byte 4
        mov ebp, eax
        mov esi, dword [edi]
        cmp esi, dword [byte edi+04h]
        je short .3
.1:
        push byte 0Ch
        lea eax, [byte esi+04h]
        push eax
        push ebp
        call StrCompareN
        add esp, byte 0Ch
        test eax, eax
        jne short .2
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        ret
.2:
        mov esi, dword [byte esi+020h]
        cmp esi, dword [byte edi+04h]
        jne short .1
.3:
        xor eax, eax
        pop ebp
        pop edi
        pop esi
        ret
FindMemBlockNamed:
        push byte 0
        mov edx, dword [byte esp+08h]
        push edx
        call FindNamedBlock
        add esp, byte 8
        ret
FindNamedBlockNext:
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
        call FileNameOnly
        add esp, byte 4
        mov ebp, eax
        mov esi, dword [edi]
        cmp esi, dword [byte edi+04h]
        je short .3
.1:
        push byte 0Ch
        lea eax, [byte esi+04h]
        push eax
        push ebp
        call StrCompareN
        add esp, byte 0Ch
        test eax, eax
        jne short .2
        test byte [byte esi+018h], 8
        je short .2
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        ret
.2:
        mov esi, dword [byte esi+020h]
        cmp esi, dword [byte edi+04h]
        jne short .1
.3:
        xor eax, eax
        pop ebp
        pop edi
        pop esi
        ret
        db 08Bh,0C0h
FindMemBlockNamedNext:
        push byte 0
        mov edx, dword [byte esp+08h]
        push edx
        call FindNamedBlockNext
        add esp, byte 8
        ret
FindFreeSpaceLocked:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
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
        jne short .1
        push esi
        call MergeFreeSpace
        add esp, byte 4
        jmp near .9
.1:
        mov edi, esi
        and edi, byte 7
        xor ebp, ebp
        xor edx, edx
        mov esi, dword [ebx]
        mov esi, dword [byte esi+020h]
        mov ecx, 7
.2:
        test byte [byte esi+018h], 8
        je short .4
        mov eax, dword [byte esi+018h]
        and eax, ecx
        cmp eax, edi
        ja short .3
        jne short .4
        mov eax, dword [FreeSpaceList]
        sub eax, dword [byte esi+01Ch]
        cmp eax, edx
        jl short .4
.3:
        mov ebp, esi
        mov edi, dword [byte esi+018h]
        and edi, ecx
        mov eax, dword [FreeSpaceList]
        mov edx, dword [byte esi+01Ch]
        sub eax, edx
        mov edx, eax
.4:
        mov esi, dword [byte esi+020h]
        cmp esi, dword [byte ebx+04h]
        jne short .2
        test ebp, ebp
        je near .8
        xor eax, eax
        mov edx, esi
.5:
        mov bl, byte [byte edx+04h]
        mov byte [esp+eax], bl
        inc edx
        inc eax
        cmp eax, byte 0Ch
        jl short .5
        xor dl, dl
        mov byte [byte esp+0Ch], dl
.6:
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
        jne short .7
        push edi
        call FindFreeSpace
        add esp, byte 4
        test eax, eax
        jne short .6
.7:
        mov ebx, dword [byte esp+010h]
        test ebx, ebx
        je short .8
        mov ecx, dword [byte ebp+014h]
        push ecx
        mov esi, dword [ebx]
        push esi
        mov edi, dword [byte ebp+00h]
        push edi
        call bcopy
        add esp, byte 0Ch
        push ebp
        call UnlinkMemBlockLocked
        add esp, byte 4
        mov eax, 1
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        ret
.8:
        xor eax, eax
.9:
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
        je short .1
        mov eax, dword [eax]
.1:
        ret
FindCachedFile:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, dword [byte esp+014h]
        push ebp
        call FindMemBlockNamedNext
        mov edi, eax
        add esp, byte 4
        test eax, eax
        je short .1
        mov ah, byte [byte eax+018h]
        and ah, 0F7h
        mov byte [byte edi+018h], ah
        test ah, 10h
        jne near .4
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
        je near .4
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
        jmp short .4
.1:
        mov esi, dword [memblocklist]
        mov esi, dword [byte esi+010h]
        mov edi, dword [byte eax+018h]
        mov dword [esp], edi
.2:
        push esi
        push ebp
        call FindNamedBlockNext
        mov edi, eax
        add esp, byte 8
        test eax, eax
        je short .3
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
.3:
        and esi, 700h
        sar esi, 8
        imul esi, byte 14h
        add esi, memlist1
        mov esi, dword [byte esi+010h]
        test esi, esi
        jne short .2
.4:
        mov eax, edi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
CompactDownLocked:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
        add esp, byte 4
        mov eax, dword [memblocklist]
        mov ebx, dword [eax]
        push ebx
        mov ecx, dword [byte eax+04h]
        push ecx
        call CompactMemListDown
        add esp, byte 8
        mov esi, dword [MemLockHandle]
        push esi
        call MemUnlock
        add esp, byte 4
        pop esi
        ret
        db 08Dh,040h,00h
CompactMemListDown:
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
.1:
        xor ecx, ecx
.2:
        mov edx, dword [edi]
        mov ebx, dword [byte edi+010h]
        add ebx, edx
        cmp ebx, eax
        jae short .3
        mov ecx, eax
        sub ecx, ebx
        mov eax, ebx
        jmp short .4
.3:
        cmp edi, ebp
        je short .4
        mov eax, edx
        mov edi, dword [byte edi+024h]
        jmp short .2
.4:
        test ecx, ecx
        jne short .5
        mov eax, dword [byte esp+08h]
        jmp near .11
.5:
        test byte [byte esi+018h], 18h
        je short .6
        mov ebx, dword [esi]
        cmp eax, ebx
        jae short .7
.6:
        cmp esi, ebp
        jne near .10
        mov eax, dword [byte esp+08h]
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
.7:
        mov edx, ebx
        mov ebx, dword [byte esi+010h]
        add ebx, edx
        mov dword [byte esp+04h], ebx
        lea ebx, [eax+ecx]
        mov dword [byte esp+0Ch], ebx
        cmp eax, dword [byte esp+04h]
        jne short .8
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
        jmp near .1
.8:
        cmp ecx, dword [byte esi+010h]
        jl short .9
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
        jmp near .1
.9:
        mov eax, dword [edi]
        jmp near .1
.10:
        mov esi, dword [byte esi+024h]
        jmp near .5
.11:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
CompactUpLocked:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
        add esp, byte 4
        mov eax, dword [memblocklist]
        mov ebx, dword [byte eax+04h]
        push ebx
        mov ecx, dword [eax]
        push ecx
        call CompactMemListUp
        add esp, byte 8
        mov esi, dword [MemLockHandle]
        push esi
        call MemUnlock
        add esp, byte 4
        pop esi
        ret
        db 08Dh,040h,00h
CompactMemListUp:
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
        jae short .2
.1:
        mov eax, dword [esi]
        sub eax, ebp
        jmp short .3
.2:
        cmp esi, dword [byte esp+014h]
        je short .3
        mov ebp, dword [esi]
        add ebp, dword [byte esi+010h]
        mov esi, dword [byte esi+020h]
        cmp ebp, dword [esi]
        jb short .1
        jmp short .2
.3:
        test eax, eax
        jne short .4
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
.4:
        test byte [byte edi+018h], 18h
        je short .5
        mov ebx, dword [edi]
        cmp ebp, ebx
        jbe short .6
.5:
        cmp edi, dword [byte esp+014h]
        jne near .9
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
.6:
        cmp edi, esi
        jne short .7
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
        jae short .2
        mov eax, dword [esi]
        sub eax, ebp
        test eax, eax
        jne short .4
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
.7:
        mov ecx, dword [byte edi+010h]
        cmp eax, ecx
        jl short .8
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
        jae near .2
        mov eax, dword [esi]
        sub eax, ebp
        test eax, eax
        jne near .4
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
.8:
        mov ebp, dword [esi]
        add ebp, dword [byte esi+010h]
        xor eax, eax
        cmp ebp, dword [esi]
        jae near .2
        mov eax, dword [esi]
        sub eax, ebp
        test eax, eax
        jne near .4
        mov eax, edx
        pop ebp
        pop edi
        pop esi
        ret
.9:
        mov edi, dword [byte edi+020h]
        jmp near .4
        db 090h
MemTrackLargestFree:
        push ebx
        push ecx
        push edx
        call MemLargestFreeOfList
        cmp eax, dword [dword_EDAB4]
        jge short .1
        mov dword [dword_EDAB4], eax
.1:
        mov eax, dword [dword_EDAB4]
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
MemLargestFree:
        push esi
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
        add esp, byte 4
        call MemLargestFreeOfList
        mov esi, eax
        mov ebx, dword [MemLockHandle]
        push ebx
        call MemUnlock
        add esp, byte 4
        mov eax, esi
        pop esi
        ret
        db 08Bh,0C0h
MemLargestFreeOfList:
        mov eax, dword [memblocklist]
        mov edx, dword [eax]
        push edx
        mov ebx, dword [byte eax+04h]
        push ebx
        call CompactMemListDown
        add esp, byte 8
        mov ebx, dword [memblocklist]
        mov ebx, dword [ebx]
        mov eax, dword [byte ebx+020h]
        xor ecx, ecx
.1:
        mov edx, dword [eax]
        sub edx, dword [ebx]
        sub edx, dword [byte ebx+010h]
        cmp edx, ecx
        jle short .2
        mov ecx, edx
.2:
        mov ebx, eax
        mov eax, dword [byte eax+020h]
        test eax, eax
        jne short .1
        mov eax, ecx
        ret
        db 08Bh,0C0h
MemLargestFreeParas:
        call MemLargestFree
        sar eax, 4
        ret
        db 08Dh,040h,00h
MemFreeSize:
        mov eax, dword [memblocklist]
        mov eax, dword [eax]
        xor edx, edx
        test eax, eax
        je short .3
.1:
        test byte [byte eax+018h], 18h
        jne short .2
        add edx, dword [byte eax+010h]
.2:
        mov eax, dword [byte eax+020h]
        test eax, eax
        jne short .1
.3:
        mov eax, edx
        ret
InitMemDescriptors:
        mov eax, dword [byte esp+04h]
        mov dword [MemDescriptorTop], eax
        xor edx, edx
        mov ebx, dword [byte esp+08h]
        dec ebx
        test ebx, ebx
        jle short .2
.1:
        lea ecx, [byte eax+028h]
        mov dword [byte eax+020h], ecx
        mov eax, ecx
        inc edx
        cmp edx, ebx
        jl short .1
.2:
        mov dword [byte eax+020h], 0
        ret
        db 08Dh,040h,00h
PushMemDescriptor:
        mov edx, dword [byte esp+04h]
        mov eax, dword [MemDescriptorTop]
        mov dword [byte edx+020h], eax
        mov dword [MemDescriptorTop], edx
        ret
        db 090h
getmemblock:
        cmp dword [MemDescriptorTop], byte 0
        jne short .1
        mov ebx, dword [MemLockHandle]
        push ebx
        call MemUnlock
        add esp, byte 4
        push str_GetmemblockNOMEMORYBLOCKS
        call FatalError
        add esp, byte 4
.1:
        mov eax, dword [MemDescriptorTop]
        mov edx, dword [byte eax+020h]
        mov dword [MemDescriptorTop], edx
        ret
MemPtrSize:
        mov edx, dword [byte esp+04h]
        push edx
        call findmemblock
        add esp, byte 4
        mov eax, dword [byte eax+014h]
        ret
        db 08Dh,040h,00h
MemDescPtr:
        mov eax, dword [byte esp+04h]
        mov eax, dword [eax]
        ret
        db 090h
MemDescSize:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+014h]
        ret
