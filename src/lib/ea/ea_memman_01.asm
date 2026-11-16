; The EA memory manager. Allocating and freeing the blocks the game asks for.
bits 32
%include "hockey.inc"
section s_8C990 progbits alloc exec nowrite align=1
extern str_LOWMEM, str_HIGHMEM, str_GAP, str_ReleaseMemoryNotFound, str_ReservememINVALIDSIZE, str_ReservememOUTOFMEMORY, str_ReservememOUTOFMEMORY2, str_ReservememINVALIDTYPEFLAGS
extern str_ResizememINVALIDSIZE, str_ResizememblockNOROOMTO, str_FindmemblockBLOCKNOTFOUND, memblocklist, RowTableSize, RowTableBuffer, FreeSpaceList, MemLockHandle
extern FatalError, memlist1, FindFreeSpace, CompactMemListDown, CompactMemListUp, MemTrackLargestFree, MemLargestFree, PushMemDescriptor
extern getmemblock, StrCopyN, FileNamePart, MemUnlock, MemLock
global InitMemList, AddMemListRegion, AddHighMemList, FindMemListBlock, SetRowTableBuffer, AllocMemHandleLocked, AllocMemHandle, AllocMemBlock
global AllocMemBlockUnlocked, AllocMemBlockFlags, AllocMemBlockEx, reservemem, ResizeMemPtr, ResizeMemPtrLocked, ResizeMemPtrUnlocked, ResizeMemHandleLocked
global ResizeMemHandleUnlocked, ResizeMemBlock, findmemblock
;-----------------------------------------------------------------------------
; InitMemList                                     8C990  95 PC, low confidence
; Sets up one memory list type: alignment, base and size
;-----------------------------------------------------------------------------
InitMemList:
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
        call StrCopyN
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
        call StrCopyN
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
;-----------------------------------------------------------------------------
; AddMemListRegion                                8CA6C  95 PC, low confidence
; Adds a region of memory to one memory list type
;-----------------------------------------------------------------------------
AddMemListRegion:
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
        call InitMemList
        add esp, byte 18h
        mov ecx, eax
        mov edx, dword [byte esi+04h]
        mov ebx, dword [esi]
        mov ebx, dword [ebx]
        cmp ebx, dword [edx]
        jne short .1
        mov edx, dword [eax]
        mov dword [esi], edx
        jmp short .2
.1:
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
.2:
        mov eax, dword [byte eax+04h]
        mov dword [byte esi+04h], eax
        mov eax, ecx
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; AddHighMemList                                  8CAF4  95 PC, low confidence
; Adds the HIGHMEM region to one memory list type
;-----------------------------------------------------------------------------
AddHighMemList:
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
        call StrCopyN
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
        call StrCopyN
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
;-----------------------------------------------------------------------------
; FindMemListBlock                                8CBA4  95 PC, low confidence
; Looks for a block in one memory list type
;-----------------------------------------------------------------------------
FindMemListBlock:
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
        je short .2
.1:
        mov eax, dword [esi]
        add eax, dword [byte esi+010h]
        cmp edx, eax
        je short .2
        mov esi, dword [byte esi+020h]
        cmp esi, dword [byte edi+04h]
        jne short .1
.2:
        cmp esi, dword [byte edi+04h]
        jne short .3
        push str_ReleaseMemoryNotFound
        call FatalError
        add esp, byte 4
.3:
        mov eax, dword [byte esi+020h]
        mov ebp, dword [eax]
        sub ebp, dword [esi]
        sub ebp, dword [byte esi+010h]
        cmp eax, dword [byte edi+04h]
        jne short .4
        mov dword [byte esi+010h], 0
        mov edx, dword [byte esi+010h]
        mov dword [byte esi+014h], edx
        mov dword [byte esi+020h], 0
        mov dword [byte edi+04h], esi
        jmp short .5
.4:
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
.5:
        push eax
        call PushMemDescriptor
        add esp, byte 4
        mov ebx, dword [edi]
        cmp esi, ebx
        jne short .6
        mov dword [byte ebx+010h], 0
        mov eax, dword [byte ebx+010h]
        mov dword [byte ebx+014h], eax
.6:
        mov eax, ebp
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; SetRowTableBuffer                            8CC5C  95 PC, medium confidence
; Sets the row table buffer and its size before initmemman
;-----------------------------------------------------------------------------
SetRowTableBuffer:
        mov eax, dword [byte esp+04h]
        mov dword [RowTableBuffer], eax
        mov eax, dword [byte esp+08h]
        mov dword [RowTableSize], eax
        ret
        db 090h
;-----------------------------------------------------------------------------
; AllocMemHandleLocked                            8CC70  95 PC, low confidence
; Allocates a locked block and returns its descriptor
;-----------------------------------------------------------------------------
AllocMemHandleLocked:
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
;-----------------------------------------------------------------------------
; AllocMemHandle                                  8CC8C  95 PC, low confidence
; Allocates an unlocked block and returns its descriptor
;-----------------------------------------------------------------------------
AllocMemHandle:
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
;-----------------------------------------------------------------------------
; AllocMemBlock                                8CCA8  95 PC, medium confidence
; Memory manager: allocate a named block (name, size, flags), e.g. the 320 KB
; 'TEMP' buffer of MenuSoundSettings; freed with FreeMemBlock
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; AllocMemBlockUnlocked                           8CCC4  95 PC, low confidence
; Allocates an unlocked block and returns its address
;-----------------------------------------------------------------------------
AllocMemBlockUnlocked:
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
;-----------------------------------------------------------------------------
; AllocMemBlockFlags                              8CCE0  95 PC, low confidence
; Allocates a block with the given lock flag and returns its address
;-----------------------------------------------------------------------------
AllocMemBlockFlags:
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
;-----------------------------------------------------------------------------
; AllocMemBlockEx                              8CD04  95 PC, medium confidence
; EA memory manager: the allocator under AllocMemBlock (name, size, flags,
; one), returns the block descriptor
;-----------------------------------------------------------------------------
AllocMemBlockEx:
        push esi
        push edi
        push ebp
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
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
        mov ebp, dword [MemLockHandle]
        push ebp
        call MemUnlock
        add esp, byte 4
        mov eax, esi
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; reservemem                                                      8CD4C  95 PC
; Prints its own name: "reservemem - INVALID SIZE REQUESTED", "reservemem -
; OUT OF MEMORY"
;-----------------------------------------------------------------------------
reservemem:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        cmp dword [byte esp+018h], byte 0
        jge short .1
        cmp dword [byte esp+020h], byte 0
        je near .27
        mov edi, dword [MemLockHandle]
        push edi
        call MemUnlock
        add esp, byte 4
        call MemLargestFree
        push eax
        mov ebp, dword [byte esp+01Ch]
        push ebp
        push str_ReservememINVALIDSIZE
        call FatalError
        add esp, byte 0Ch
        jmp near .27
.1:
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
        call FileNamePart
        add esp, byte 4
        mov dword [byte esp+014h], eax
        test byte [byte esp+01Ch], 40h
        je short .2
        mov edx, dword [byte esp+018h]
        mov edi, dword [byte esi+0Ch]
        add edx, edi
        mov eax, edi
        not eax
        and edx, eax
        mov dword [esp], edx
        jmp short .3
.2:
        mov eax, dword [byte esp+018h]
        mov ecx, dword [byte esi+08h]
        add eax, ecx
        mov edx, ecx
        not edx
        and eax, edx
        mov dword [esp], eax
.3:
        mov ebp, dword [esi]
        test ebp, ebp
        je near .26
        mov dl, byte [byte esp+01Ch]
        test dl, 20h
        jne near .13
        test dl, 10h
        jne short .4
        push ebp
        mov ecx, dword [byte esi+04h]
        push ecx
        call CompactMemListDown
        add esp, byte 8
.4:
        mov ebp, dword [esi]
        mov edi, dword [byte ebp+020h]
        mov ebp, dword [byte ebp+00h]
        test byte [byte esp+01Ch], 40h
        je short .5
        mov eax, dword [byte esi+0Ch]
        add eax, ebp
        mov ebp, dword [byte esi+0Ch]
        not ebp
        and ebp, eax
.5:
        mov ebx, 40h
        xor edx, edx
        cmp ebp, dword [edi]
        jae short .7
.6:
        mov edx, dword [edi]
        sub edx, ebp
        jmp short .9
.7:
        mov ebp, dword [edi]
        add ebp, dword [byte edi+010h]
        test dword [byte esp+01Ch], ebx
        je short .8
        mov eax, dword [byte esi+0Ch]
        add eax, ebp
        mov ebp, dword [byte esi+0Ch]
        not ebp
        and ebp, eax
.8:
        cmp edi, dword [byte esi+04h]
        je short .9
        mov edi, dword [byte edi+020h]
        cmp ebp, dword [edi]
        jb short .6
        jmp short .7
.9:
        cmp edx, dword [esp]
        jl short .10
        call getmemblock
        mov esi, eax
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esi+018h], eax
        mov eax, dword [FreeSpaceList]
        mov dword [byte esi+01Ch], eax
        mov edx, dword [byte esp+018h]
        mov dword [byte esi+014h], edx
        mov edx, dword [esp]
        mov dword [byte esi+010h], edx
        push byte 0Ch
        mov ebx, dword [byte esp+018h]
        push ebx
        inc eax
        mov dword [FreeSpaceList], eax
        lea eax, [byte esi+04h]
        push eax
        call StrCopyN
        add esp, byte 0Ch
        mov dword [esi], ebp
        mov eax, dword [byte edi+024h]
        mov dword [byte esi+024h], eax
        mov dword [byte esi+020h], edi
        mov eax, dword [byte edi+024h]
        mov dword [byte eax+020h], esi
        mov dword [byte edi+024h], esi
        call MemTrackLargestFree
        mov eax, esi
        jmp near .28
.10:
        cmp edi, dword [byte esi+04h]
        je short .12
        mov ebp, dword [edi]
        add ebp, dword [byte edi+010h]
        test dword [byte esp+01Ch], ebx
        je short .11
        mov edx, dword [byte esi+0Ch]
        add ebp, edx
        mov eax, edx
        not eax
        and ebp, eax
.11:
        mov edi, dword [byte edi+020h]
        xor edx, edx
        cmp ebp, dword [edi]
        jae near .7
        mov edx, dword [edi]
        sub edx, ebp
        jmp near .9
.12:
        mov ebx, dword [byte esp+01Ch]
        push ebx
        call FindFreeSpace
        add esp, byte 4
        test eax, eax
        jne near .4
        mov ecx, dword [esi]
        push ecx
        mov edi, dword [byte esi+04h]
        push edi
        call CompactMemListDown
        add esp, byte 8
        test eax, eax
        jne near .4
        cmp dword [byte esp+020h], byte 0
        je near .26
        mov eax, dword [MemLockHandle]
        push eax
        call MemUnlock
        add esp, byte 4
        call MemLargestFree
        push eax
        mov edx, dword [byte esp+01Ch]
        push edx
        push str_ReservememOUTOFMEMORY
        jmp near .25
.13:
        test dl, 10h
        jne short .14
        mov eax, dword [byte esi+04h]
        push eax
        push ebp
        call CompactMemListUp
        add esp, byte 8
.14:
        mov ebp, dword [byte esi+04h]
        mov edi, dword [byte ebp+024h]
        mov ebp, dword [byte ebp+00h]
        test byte [byte esp+01Ch], 40h
        je short .15
        mov eax, dword [byte esi+0Ch]
        not eax
        and ebp, eax
.15:
        mov ecx, 40h
.16:
        xor ebx, ebx
.17:
        mov eax, dword [edi]
        add eax, dword [byte edi+010h]
        test dword [byte esp+01Ch], ecx
        je short .18
        mov edx, dword [byte esi+0Ch]
        add edx, eax
        mov eax, dword [byte esi+0Ch]
        not eax
        and eax, edx
.18:
        cmp eax, ebp
        jae short .19
        mov ebx, ebp
        sub ebx, eax
        jmp short .21
.19:
        mov ebp, dword [edi]
        test dword [byte esp+01Ch], ecx
        je short .20
        mov eax, dword [byte esi+0Ch]
        not eax
        and ebp, eax
.20:
        cmp edi, dword [esi]
        je short .21
        mov edi, dword [byte edi+024h]
        jmp short .17
.21:
        cmp ebx, dword [esp]
        jl short .22
        call getmemblock
        mov esi, eax
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esi+018h], eax
        mov eax, dword [FreeSpaceList]
        mov dword [byte esi+01Ch], eax
        mov edx, dword [byte esp+018h]
        mov dword [byte esi+014h], edx
        mov edx, dword [esp]
        mov dword [byte esi+010h], edx
        push byte 0Ch
        mov ecx, dword [byte esp+018h]
        push ecx
        inc eax
        mov dword [FreeSpaceList], eax
        lea eax, [byte esi+04h]
        push eax
        call StrCopyN
        add esp, byte 0Ch
        mov eax, dword [esp]
        sub ebp, eax
        mov dword [esi], ebp
        mov dword [byte esi+024h], edi
        mov eax, dword [byte edi+020h]
        mov dword [byte esi+020h], eax
        mov dword [byte eax+024h], esi
        mov dword [byte edi+020h], esi
        call MemTrackLargestFree
        mov eax, esi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
.22:
        cmp edi, dword [esi]
        je short .24
        mov ebp, dword [edi]
        test dword [byte esp+01Ch], ecx
        je short .23
        mov eax, dword [byte esi+0Ch]
        not eax
        and ebp, eax
.23:
        mov edi, dword [byte edi+024h]
        jmp near .16
.24:
        mov ecx, dword [byte esp+01Ch]
        push ecx
        call FindFreeSpace
        add esp, byte 4
        test eax, eax
        jne near .14
        mov edi, dword [byte esi+04h]
        push edi
        mov ebp, dword [esi]
        push ebp
        call CompactMemListUp
        add esp, byte 8
        test eax, eax
        jne near .14
        cmp dword [byte esp+020h], byte 0
        je short .26
        mov edx, dword [MemLockHandle]
        push edx
        call MemUnlock
        add esp, byte 4
        call MemLargestFree
        push eax
        mov ebx, dword [byte esp+01Ch]
        push ebx
        push str_ReservememOUTOFMEMORY2
.25:
        call FatalError
        add esp, byte 0Ch
.26:
        cmp dword [byte esp+020h], byte 0
        je short .27
        mov esi, dword [MemLockHandle]
        push esi
        call MemUnlock
        add esp, byte 4
        mov edi, dword [byte esp+01Ch]
        push edi
        push str_ReservememINVALIDTYPEFLAGS
        call FatalError
        add esp, byte 8
.27:
        xor eax, eax
.28:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; ResizeMemPtr                                    8D0C8  95 PC, low confidence
; Resizes the block at an address, with the given lock flag
;-----------------------------------------------------------------------------
ResizeMemPtr:
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
;-----------------------------------------------------------------------------
; ResizeMemPtrLocked                              8D0EC  95 PC, low confidence
; Resizes the block at an address, locked
;-----------------------------------------------------------------------------
ResizeMemPtrLocked:
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
;-----------------------------------------------------------------------------
; ResizeMemPtrUnlocked                            8D10C  95 PC, low confidence
; Resizes the block at an address, unlocked
;-----------------------------------------------------------------------------
ResizeMemPtrUnlocked:
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
;-----------------------------------------------------------------------------
; ResizeMemHandleLocked                           8D12C  95 PC, low confidence
; Resizes a block by descriptor, locked
;-----------------------------------------------------------------------------
ResizeMemHandleLocked:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call ResizeMemBlock
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; ResizeMemHandleUnlocked                         8D144  95 PC, low confidence
; Resizes a block by descriptor, unlocked
;-----------------------------------------------------------------------------
ResizeMemHandleUnlocked:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call ResizeMemBlock
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; ResizeMemBlock                               8D15C  95 PC, medium confidence
; Changes a memory block's size, compacting its list when needed
;-----------------------------------------------------------------------------
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
        mov edx, dword [MemLockHandle]
        push edx
        call MemLock
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
        jge short .2
        mov ebx, dword [MemLockHandle]
        push ebx
        call MemUnlock
        add esp, byte 4
        cmp dword [byte esp+014h], byte 0FFFFFFFFh
        jne short .1
        mov eax, ebp
        pop ebp
        pop edi
        pop esi
        ret
.1:
        cmp dword [byte esp+018h], byte 0
        je near .7
        mov edi, dword [MemLockHandle]
        push edi
        call MemUnlock
        add esp, byte 4
        call MemLargestFree
        push eax
        mov ebp, dword [byte esp+018h]
        push ebp
        push str_ResizememINVALIDSIZE
        call FatalError
        add esp, byte 0Ch
        jmp near .7
.2:
        cmp eax, ebp
        jge short .3
        mov edx, dword [byte esp+014h]
        mov dword [byte esi+014h], edx
        mov dword [byte esi+010h], eax
        mov edx, dword [MemLockHandle]
        push edx
        call MemUnlock
        add esp, byte 4
        mov eax, dword [byte esp+014h]
        pop ebp
        pop edi
        pop esi
        ret
.3:
        mov eax, dword [byte esi+020h]
        test byte [byte eax+018h], 18h
        je short .4
        push eax
        mov eax, dword [byte edi+04h]
        push eax
        call CompactMemListDown
        add esp, byte 8
        test eax, eax
        jne short .5
.4:
        test byte [byte esi+018h], 18h
        je short .6
        push esi
        mov edx, dword [edi]
        push edx
        call CompactMemListUp
        add esp, byte 8
        test eax, eax
        je short .6
.5:
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
        jmp short .2
.6:
        mov ebx, dword [MemLockHandle]
        push ebx
        call MemUnlock
        add esp, byte 4
        cmp dword [byte esp+018h], byte 0
        je short .7
        push ebp
        mov esi, dword [byte esp+018h]
        push esi
        push str_ResizememblockNOROOMTO
        call FatalError
        add esp, byte 0Ch
.7:
        xor eax, eax
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; findmemblock                                                    8D2A0  95 PC
; EA library: finds the memory block that holds a pointer, through the block
; lists
;-----------------------------------------------------------------------------
findmemblock:
        mov ebx, dword [byte esp+04h]
        mov eax, dword [memblocklist]
        mov eax, dword [eax]
        mov eax, dword [byte eax+020h]
.1:
        cmp ebx, dword [eax]
        jne short .2
        test byte [byte eax+019h], 80h
        jne short .2
        ret
.2:
        mov eax, dword [byte eax+020h]
        mov edx, dword [memblocklist]
        cmp eax, dword [byte edx+04h]
        jne short .1
        push ebx
        push str_FindmemblockBLOCKNOTFOUND
        call FatalError
        add esp, byte 8
        xor eax, eax
        ret
