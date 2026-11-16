; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9A874 progbits alloc exec nowrite align=1
extern HeapList, HeapRover
global __MemAllocator, loc_9A8A7, loc_9A8C3, loc_9A8C7, loc_9A8F5, loc_9A90A, loc_9A912, loc_9A917
global __MemFree, loc_9A947, loc_9A95E, loc_9A975, loc_9A984, loc_9A9A1, loc_9A9A5, loc_9A9B9
global loc_9A9C3, loc_9A9DA, loc_9A9F5, loc_9A9F9, loc_9AA0A, loc_9AA1A, loc_9AA22, __unlink_
global loc_9AA3C, loc_9AA4F, loc_9AA5C, loc_9AA63
__MemAllocator:
        push esi
        push edi
        push ecx
        push ds
        mov ds, edx
        or eax, eax
        je short loc_9A8C3
        add eax, byte 7
        jb short loc_9A8C3
        and al, 0FCh
        mov edx, 0Ch
        sub eax, edx
        cmc
        sbb ecx, ecx
        and eax, ecx
        add eax, edx
        cmp eax, dword [byte ebx+014h]
        ja short loc_9A8C3
        mov esi, dword [byte ebx+0Ch]
        mov edi, dword [byte ebx+010h]
        cmp eax, edi
        ja short loc_9A8A7
        mov esi, dword [byte ebx+028h]
        sub edi, edi
loc_9A8A7:
        mov edx, dword [esi]
        cmp eax, edx
        jbe short loc_9A8C7
        sub edi, edx
        cmc
        sbb ecx, ecx
        and edi, ecx
        add edi, edx
        lea edx, [byte ebx+020h]
        mov esi, dword [byte esi+08h]
        cmp esi, edx
        jne short loc_9A8A7
        mov dword [byte ebx+014h], edi
loc_9A8C3:
        sub eax, eax
        jmp short loc_9A912
loc_9A8C7:
        sub edx, eax
        mov dword [byte ebx+010h], edi
        inc dword [byte ebx+018h]
        mov ecx, dword [byte esi+08h]
        cmp edx, byte 0Ch
        jb short loc_9A8F5
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
        jmp short loc_9A90A
loc_9A8F5:
        dec dword [byte ebx+01Ch]
        mov eax, esi
        mov edi, ecx
        mov esi, dword [byte esi+04h]
        mov dword [byte esi+08h], edi
        mov dword [byte edi+04h], esi
        mov dword [byte ebx+0Ch], esi
        mov esi, eax
loc_9A90A:
        or dword [esi], byte 1
        mov eax, esi
        add eax, byte 4
loc_9A912:
        pop ds
        pop ecx
        pop edi
        pop esi
        ret
loc_9A917:
        jmp near loc_9AA22
__MemFree:
        push esi
        push edi
        push ecx
        push ds
        mov ds, edx
        or eax, eax
        je short loc_9A917
        mov esi, eax
        sub esi, byte 4
        mov eax, dword [esi]
        test al, 1
        je short loc_9A917
        and al, 0FEh
        mov edi, esi
        add edi, eax
        test dword [edi], 1
        jne short loc_9A95E
        cmp edi, dword [byte ebx+0Ch]
        jne short loc_9A947
        mov dword [byte ebx+0Ch], esi
loc_9A947:
        add eax, dword [edi]
        mov dword [esi], eax
        push ebx
        mov ebx, dword [byte edi+04h]
        mov edi, dword [byte edi+08h]
        mov dword [byte ebx+08h], edi
        mov dword [byte edi+04h], ebx
        pop ebx
        dec dword [byte ebx+01Ch]
        jmp short loc_9A9DA
loc_9A95E:
        mov dword [esi], eax
        mov edi, dword [byte ebx+0Ch]
        cmp esi, edi
        jae short loc_9A975
        cmp esi, dword [byte edi+04h]
        ja short loc_9A9DA
        mov edi, dword [byte ebx+028h]
        cmp esi, edi
        jb short loc_9A9DA
        jmp short loc_9A984
loc_9A975:
        mov edi, dword [byte edi+08h]
        cmp esi, edi
        jb short loc_9A9DA
        lea edi, [byte ebx+020h]
        cmp esi, dword [byte ebx+024h]
        ja short loc_9A9DA
loc_9A984:
        sub edx, edx
        mov eax, dword [byte ebx+018h]
        mov ecx, dword [byte ebx+01Ch]
        inc ecx
        div ecx
        dec ecx
        cmp eax, ecx
        jae short loc_9A9B9
        mov edx, dword [byte ebx+018h]
        sub edx, ecx
        add eax, eax
        cmp edx, ecx
        ja short loc_9A9A1
        sub eax, eax
loc_9A9A1:
        mov edi, esi
        add edi, dword [esi]
loc_9A9A5:
        mov edx, dword [edi]
        test dl, 1
        je short loc_9A9DA
        cmp edx, byte 0FFFFFFFFh
        je short loc_9A9B9
        and dl, 0FEh
        add edi, edx
        dec eax
        jne short loc_9A9A5
loc_9A9B9:
        mov edi, dword [byte ebx+0Ch]
        cmp esi, edi
        jae short loc_9A9C3
        mov edi, dword [byte ebx+028h]
loc_9A9C3:
        cmp esi, edi
        jb short loc_9A9DA
        mov edi, dword [byte edi+08h]
        cmp esi, edi
        jb short loc_9A9DA
        mov edi, dword [byte edi+08h]
        cmp esi, edi
        jb short loc_9A9DA
        mov edi, dword [byte edi+08h]
        jmp short loc_9A9C3
loc_9A9DA:
        mov edx, dword [byte edi+04h]
        mov ecx, dword [esi]
        db 087h,0FAh                            ; insn: xchg edi,edx
        mov eax, edi
        add eax, dword [edi]
        cmp eax, esi
        jne short loc_9A9F9
        add ecx, dword [edi]
        mov dword [edi], ecx
        cmp esi, dword [byte ebx+0Ch]
        jne short loc_9A9F5
        mov dword [byte ebx+0Ch], edi
loc_9A9F5:
        mov esi, edi
        jmp short loc_9AA0A
loc_9A9F9:
        inc dword [byte ebx+01Ch]
        mov dword [byte esi+08h], edx
        mov dword [byte esi+04h], edi
        mov dword [byte edi+08h], esi
        mov edi, edx
        mov dword [byte edi+04h], esi
loc_9AA0A:
        dec dword [byte ebx+018h]
        cmp esi, dword [byte ebx+0Ch]
        jae short loc_9AA1A
        cmp ecx, dword [byte ebx+010h]
        jbe short loc_9AA1A
        mov dword [byte ebx+010h], ecx
loc_9AA1A:
        cmp ecx, dword [byte ebx+014h]
        jbe short loc_9AA22
        mov dword [byte ebx+014h], ecx
loc_9AA22:
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
        jne short loc_9AA3C
        mov edx, dword [byte edx+08h]
        mov dword [HeapRover], edx
loc_9AA3C:
        mov ebx, dword [HeapList]
        cmp eax, ebx
        jne short loc_9AA4F
        mov edx, dword [byte ebx+08h]
        mov dword [HeapList], edx
loc_9AA4F:
        mov edx, dword [byte eax+04h]
        mov eax, dword [byte eax+08h]
        test edx, edx
        je short loc_9AA5C
        mov dword [byte edx+08h], eax
loc_9AA5C:
        test eax, eax
        je short loc_9AA63
        mov dword [byte eax+04h], edx
loc_9AA63:
        pop edx
        pop ebx
        ret
