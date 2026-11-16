; Starting the EA memory manager.
bits 32
%include "hockey.inc"
section s_8DCF8 progbits alloc exec nowrite align=1
extern _nmalloc_, str_InitmemmanINSUFFICIENTROW, dword_D2F5C, dword_D2F60, dword_D2F7C, dword_D2F80, dword_EDAA8, MemLockHandle
extern dword_EDAB4, FatalError, int386_, InitMemList, AddHighMemList, MemLargestFree, InitMemDescriptors, GrabLargestBlock
extern MemLockHandleInit, MemUnlock, DetectCPU, unk_EDF04, MemLock
global initmemman, loc_8DD2F, loc_8DD58, loc_8DD71, loc_8DDF4, loc_8DEAD, loc_8DED0, loc_8DF06
global InitMemoryPoolDefault, SetupMemoryPool, SetupMemoryPoolReserve
initmemman:
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov esi, dword [byte esp+054h]
        mov edi, dword [byte esp+058h]
        call MemLockHandleInit
        mov dword [MemLockHandle], eax
        push eax
        call MemLock
        add esp, byte 4
        call DetectCPU
        call GrabLargestBlock
        mov edx, eax
        test esi, esi
        jle short loc_8DD2F
        cmp eax, esi
        jle short loc_8DD2F
        mov edx, esi
loc_8DD2F:
        and dl, 0F0h
        mov eax, edx
        call _nmalloc_
        mov dword [dword_D2F80], eax
        add eax, edx
        mov dword [dword_D2F7C], eax
        cmp dword [dword_D2F60], byte 0
        jne short loc_8DD58
        mov dword [dword_D2F60], unk_EDF04
loc_8DD58:
        cmp dword [dword_D2F5C], 0CCh
        jge short loc_8DD71
        push str_InitmemmanINSUFFICIENTROW
        call FatalError
        add esp, byte 4
loc_8DD71:
        mov edx, dword [dword_D2F5C]
        shl edx, 2
        mov eax, dword [dword_D2F60]
        lea ebx, [eax+edx]
        mov dword [dword_EDAA8], ebx
        mov edx, dword [dword_D2F5C]
        sub edx, byte 2
        mov dword [eax], edx
        mov dword [byte eax+04h], 0
        mov edx, dword [byte esp+050h]
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 3
        mov dword [byte esp+03Ch], eax
        push edx
        mov edx, dword [dword_D2F80]
        push edx
        call InitMemDescriptors
        add esp, byte 8
        push byte 0
        push byte 8
        push byte 8
        mov ebx, dword [dword_D2F7C]
        push ebx
        mov eax, dword [dword_D2F80]
        add eax, dword [byte esp+04Ch]
        push eax
        push byte 0
        call InitMemList
        add esp, byte 18h
        test esi, esi
        jne near loc_8DF06
        cmp edi, 3E80h
        jge short loc_8DDF4
        mov edi, 3E80h
loc_8DDF4:
        mov word [byte esp+01Ch], 100h
        mov word [byte esp+020h], 0A000h
        mov ebx, esp
        lea edx, [byte esp+01Ch]
        mov eax, 31h
        call int386_
        mov ecx, 100h
        mov word [byte esp+01Ch], cx
        xor eax, eax
        mov ax, word [byte esp+04h]
        mov esi, eax
        shl esi, 4
        sub esi, edi
        test esi, esi
        jle near loc_8DEAD
        lea edx, [byte edi+0Fh]
        sar edx, 4
        sub eax, edx
        mov word [byte esp+020h], ax
        mov ebx, esp
        lea edx, [byte esp+01Ch]
        mov eax, 31h
        call int386_
        xor eax, eax
        mov ax, word [esp]
        mov ebp, eax
        shl ebp, 4
        xor esi, esi
        mov si, word [byte esp+020h]
        shl esi, 4
        test edi, edi
        je short loc_8DEAD
        mov word [byte esp+01Ch], cx
        mov word [byte esp+020h], 0A000h
        mov ebx, esp
        lea edx, [byte esp+01Ch]
        mov eax, 31h
        call int386_
        mov word [byte esp+01Ch], cx
        mov eax, dword [byte esp+04h]
        mov word [byte esp+020h], ax
        mov ebx, esp
        lea edx, [byte esp+01Ch]
        mov eax, 31h
        call int386_
        xor eax, eax
        mov ax, word [byte esp+0Ch]
        mov dword [byte esp+038h], eax
loc_8DEAD:
        call GrabLargestBlock
        mov edx, eax
        cmp eax, 2710h
        jl short loc_8DED0
        call _nmalloc_
        add edx, eax
        push edx
        push eax
        push byte 0
        call AddHighMemList
        add esp, byte 0Ch
        jmp short loc_8DEAD
loc_8DED0:
        test esi, esi
        jle short loc_8DF06
        add esi, ebp
        push esi
        push ebp
        push byte 0
        call AddHighMemList
        add esp, byte 0Ch
        test edi, edi
        je short loc_8DF06
        mov word [byte esp+01Ch], 101h
        mov eax, dword [byte esp+038h]
        mov word [byte esp+028h], ax
        mov ebx, esp
        lea edx, [byte esp+01Ch]
        mov eax, 31h
        call int386_
loc_8DF06:
        mov esi, dword [MemLockHandle]
        push esi
        call MemUnlock
        add esp, byte 4
        call MemLargestFree
        mov dword [dword_EDAB4], eax
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Bh,0C0h
InitMemoryPoolDefault:
        push byte 0
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        call initmemman
        add esp, byte 0Ch
        ret
        db 08Bh,0C0h
SetupMemoryPool:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call initmemman
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
SetupMemoryPoolReserve:
        mov edx, dword [byte esp+08h]
        push edx
        push byte 0
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call initmemman
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h,00h,00h,00h
