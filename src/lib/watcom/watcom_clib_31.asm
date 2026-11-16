; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9A874 progbits alloc exec nowrite align=1
extern HeapList, HeapRover
global __MemAllocator, __MemFree, __MemFree, __unlink_
__MemAllocator:
        push esi
        push edi
        push ecx
        push ds
        mov ds, edx
        or eax, eax
        je short .2
        add eax, byte 7
        jb short .2
        and al, 0FCh
        mov edx, 0Ch
        sub eax, edx
        cmc
        sbb ecx, ecx
        and eax, ecx
        add eax, edx
        cmp eax, dword [byte ebx+014h]
        ja short .2
        mov esi, dword [byte ebx+0Ch]
        mov edi, dword [byte ebx+010h]
        cmp eax, edi
        ja short .1
        mov esi, dword [byte ebx+028h]
        sub edi, edi
.1:
        mov edx, dword [esi]
        cmp eax, edx
        jbe short .3
        sub edi, edx
        cmc
        sbb ecx, ecx
        and edi, ecx
        add edi, edx
        lea edx, [byte ebx+020h]
        mov esi, dword [byte esi+08h]
        cmp esi, edx
        jne short .1
        mov dword [byte ebx+014h], edi
.2:
        sub eax, eax
        jmp short .6
.3:
        sub edx, eax
        mov dword [byte ebx+010h], edi
        inc dword [byte ebx+018h]
        mov ecx, dword [byte esi+08h]
        cmp edx, byte 0Ch
        jb short .4
        mov edi, esi
        add edi, eax
        mov dword [byte ebx+0Ch], edi
        mov dword [edi], edx
        mov dword [esi], eax
        mov ebx, dword [byte esi+04h]
        mov dword [byte edi+04h], ebx
        mov dword [byte edi+08h], ecx
        mov dword [byte ebx+08h], edi
        mov ebx, ecx
        mov dword [byte ebx+04h], edi
        jmp short .5
.4:
        dec dword [byte ebx+01Ch]
        mov eax, esi
        mov edi, ecx
        mov esi, dword [byte esi+04h]
        mov dword [byte esi+08h], edi
        mov dword [byte edi+04h], esi
        mov dword [byte ebx+0Ch], esi
        mov esi, eax
.5:
        or dword [esi], byte 1
        mov eax, esi
        add eax, byte 4
.6:
        pop ds
        pop ecx
        pop edi
        pop esi
        ret
        jmp near __MemFree+0106h
__MemFree:
        push esi
        push edi
        push ecx
        push ds
        mov ds, edx
        or eax, eax
        je short __MemAllocator+0A3h
        mov esi, eax
        sub esi, byte 4
        mov eax, dword [esi]
        test al, 1
        je short __MemAllocator+0A3h
        and al, 0FEh
        mov edi, esi
        add edi, eax
        test dword [edi], 1
        jne short .2
        cmp edi, dword [byte ebx+0Ch]
        jne short .1
        mov dword [byte ebx+0Ch], esi
.1:
        add eax, dword [edi]
        mov dword [esi], eax
        push ebx
        mov ebx, dword [byte edi+04h]
        mov edi, dword [byte edi+08h]
        mov dword [byte ebx+08h], edi
        mov dword [byte edi+04h], ebx
        pop ebx
        dec dword [byte ebx+01Ch]
        jmp short .9
.2:
        mov dword [esi], eax
        mov edi, dword [byte ebx+0Ch]
        cmp esi, edi
        jae short .3
        cmp esi, dword [byte edi+04h]
        ja short .9
        mov edi, dword [byte ebx+028h]
        cmp esi, edi
        jb short .9
        jmp short .4
.3:
        mov edi, dword [byte edi+08h]
        cmp esi, edi
        jb short .9
        lea edi, [byte ebx+020h]
        cmp esi, dword [byte ebx+024h]
        ja short .9
.4:
        sub edx, edx
        mov eax, dword [byte ebx+018h]
        mov ecx, dword [byte ebx+01Ch]
        inc ecx
        div ecx
        dec ecx
        cmp eax, ecx
        jae short .7
        mov edx, dword [byte ebx+018h]
        sub edx, ecx
        add eax, eax
        cmp edx, ecx
        ja short .5
        sub eax, eax
.5:
        mov edi, esi
        add edi, dword [esi]
.6:
        mov edx, dword [edi]
        test dl, 1
        je short .9
        cmp edx, byte 0FFFFFFFFh
        je short .7
        and dl, 0FEh
        add edi, edx
        dec eax
        jne short .6
.7:
        mov edi, dword [byte ebx+0Ch]
        cmp esi, edi
        jae short .8
        mov edi, dword [byte ebx+028h]
.8:
        cmp esi, edi
        jb short .9
        mov edi, dword [byte edi+08h]
        cmp esi, edi
        jb short .9
        mov edi, dword [byte edi+08h]
        cmp esi, edi
        jb short .9
        mov edi, dword [byte edi+08h]
        jmp short .8
.9:
        mov edx, dword [byte edi+04h]
        mov ecx, dword [esi]
        db 087h,0FAh                            ; insn: xchg edi,edx
        mov eax, edi
        add eax, dword [edi]
        cmp eax, esi
        jne short .11
        add ecx, dword [edi]
        mov dword [edi], ecx
        cmp esi, dword [byte ebx+0Ch]
        jne short .10
        mov dword [byte ebx+0Ch], edi
.10:
        mov esi, edi
        jmp short .12
.11:
        inc dword [byte ebx+01Ch]
        mov dword [byte esi+08h], edx
        mov dword [byte esi+04h], edi
        mov dword [byte edi+08h], esi
        mov edi, edx
        mov dword [byte edi+04h], esi
.12:
        dec dword [byte ebx+018h]
        cmp esi, dword [byte ebx+0Ch]
        jae short .13
        cmp ecx, dword [byte ebx+010h]
        jbe short .13
        mov dword [byte ebx+010h], ecx
.13:
        cmp ecx, dword [byte ebx+014h]
        jbe short __MemFree+0106h
        mov dword [byte ebx+014h], ecx
        pop ds
        pop ecx
        pop edi
        pop esi
        ret
__unlink_:
        push ebx
        push edx
        mov edx, dword [HeapRover]
        cmp eax, edx
        jne short .1
        mov edx, dword [byte edx+08h]
        mov dword [HeapRover], edx
.1:
        mov ebx, dword [HeapList]
        cmp eax, ebx
        jne short .2
        mov edx, dword [byte ebx+08h]
        mov dword [HeapList], edx
.2:
        mov edx, dword [byte eax+04h]
        mov eax, dword [byte eax+08h]
        test edx, edx
        je short .3
        mov dword [byte edx+08h], eax
.3:
        test eax, eax
        je short .4
        mov dword [byte eax+04h], edx
.4:
        pop edx
        pop ebx
        ret
