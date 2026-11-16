; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_9AA66 progbits alloc exec nowrite align=1
extern __brk_, __unlink_, _nfree_, _Extender, _ExtenderSubtype, Is8087, HeapList, _curbrk
extern __heap_enabled, dword_D5674, RationalAllocLimit, RationalAllocFlags
global __FreeDPMIBlocks_, loc_9AA71, loc_9AAAF, loc_9AABF, __ReAllocDPMIBlock_, loc_9AADD, loc_9AB45, loc_9AB97
global loc_9AB9B, loc_9AB9E, loc_9ABA6, loc_9ABA8, __LinkUpNewMHeap_, loc_9ABBB, loc_9ABC4, loc_9ABC8
global loc_9ABD7, loc_9ABDD, loc_9ABE4, __LastFree_, loc_9AC5E, loc_9AC6B, RationalAlloc_, loc_9ACA1
global loc_9ACBE, loc_9ACD3, loc_9AD38, loc_9AD3A, loc_9AD3D, __CreateNewNHeap_, loc_9AD52, loc_9AD56
global loc_9AD8A, loc_9ADA5, __ExpandDGROUP_, loc_9AE0A, loc_9AE13, loc_9AE20, loc_9AE29, loc_9AE30
global loc_9AE6E, loc_9AE82, loc_9AEB0, loc_9AEBF, loc_9AEC2, loc_9AEC6, loc_9AEF0, loc_9AF0F
global loc_9AF2D, __AdjustAmount_, loc_9AF47, loc_9AF4D, loc_9AF5F, loc_9AF68, loc_9AF6D, loc_9AF74
global loc_9AF8C
__FreeDPMIBlocks_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, dword [HeapList]
loc_9AA71:
        test edx, edx
        je near loc_9AD3D
        mov eax, dword [byte edx+024h]
        mov eax, dword [eax]
        mov ebx, dword [edx]
        add eax, byte 2Ch
        cmp eax, ebx
        jne short loc_9AABF
        lea ebx, [byte edx-08h]
        mov eax, edx
        mov ecx, dword [byte edx+08h]
        call __unlink_
        mov edx, ecx
        mov ecx, dword [byte ebx+04h]
        test ecx, ecx
        jne short loc_9AAAF
        mov eax, dword [ebx]
        shr eax, 10h
        mov di, word [ebx]
        mov esi, eax
        mov ah, 5
        mov al, 2
        int 31h
        jmp short loc_9AA71
loc_9AAAF:
        mov eax, ecx
        push es
        mov es, eax
        mov ah, 49h
        int 21h
        rcl eax, 1
        ror eax, 1
        pop es
        jmp short loc_9AA71
loc_9AABF:
        mov edx, dword [byte edx+08h]
        jmp short loc_9AA71
__ReAllocDPMIBlock_:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebx, eax
        mov ebp, edx
        call __FreeDPMIBlocks_
        mov edx, dword [HeapList]
        jmp near loc_9AB9E
loc_9AADD:
        cmp edx, ebx
        ja near loc_9ABA6
        lea eax, [byte edx+02Ch]
        cmp eax, ebx
        jne near loc_9AB9B
        mov eax, edx
        call __unlink_
        lea eax, [byte edx-08h]
        cmp dword [byte eax+04h], byte 0
        jne near loc_9ABA6
        mov edx, dword [edx]
        mov esi, dword [ebx]
        mov ebx, ebp
        add edx, byte 0Ch
        sub ebx, esi
        add edx, ebx
        add edx, 0FFFh
        and dh, 0F0h
        xor dl, dl
        mov ebx, edx
        mov ecx, edx
        shr ebx, 10h
        mov di, word [eax]
        mov si, word [byte eax+02h]
        mov ah, 5
        mov al, 3
        int 31h
        sbb eax, eax
        inc eax
        je short loc_9AB45
        mov ax, bx
        shl eax, 10h
        mov ax, cx
        mov word [eax], di
        mov word [byte eax+02h], si
loc_9AB45:
        test eax, eax
        je short loc_9ABA8
        lea ebx, [byte eax+08h]
        sub edx, byte 0Ch
        mov dword [byte eax+04h], 0
        mov eax, ebx
        mov dword [ebx], edx
        call __LinkUpNewMHeap_
        mov dword [byte ebx+018h], 1
        mov edx, dword [eax]
        mov ecx, eax
        sub edx, ebp
        mov esi, eax
        cmp edx, byte 0Ch
        jb short loc_9AB97
        or ebp, byte 1
        mov dword [eax], ebp
        add eax, ebp
        and al, 0FEh
        or dl, 1
        mov dword [eax], edx
        mov edi, dword [byte ebx+018h]
        mov dword [byte ebx+014h], 0FFFFFFFFh
        inc edi
        add eax, byte 4
        mov dword [byte ebx+018h], edi
        call _nfree_
loc_9AB97:
        mov eax, esi
        jmp short loc_9ABA8
loc_9AB9B:
        mov edx, dword [byte edx+08h]
loc_9AB9E:
        test edx, edx
        jne near loc_9AADD
loc_9ABA6:
        xor eax, eax
loc_9ABA8:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
__LinkUpNewMHeap_:
        push ebx
        push edx
        mov edx, eax
        mov eax, dword [HeapList]
        xor ebx, ebx
        jmp short loc_9ABC4
loc_9ABBB:
        cmp edx, eax
        jb short loc_9ABC8
        mov ebx, eax
        mov eax, dword [byte eax+08h]
loc_9ABC4:
        test eax, eax
        jne short loc_9ABBB
loc_9ABC8:
        mov dword [byte edx+04h], ebx
        mov dword [byte edx+08h], eax
        test ebx, ebx
        je short loc_9ABD7
        mov dword [byte ebx+08h], edx
        jmp short loc_9ABDD
loc_9ABD7:
        mov dword [HeapList], edx
loc_9ABDD:
        test eax, eax
        je short loc_9ABE4
        mov dword [byte eax+04h], edx
loc_9ABE4:
        lea ebx, [byte edx+020h]
        mov eax, dword [edx]
        add edx, byte 2Ch
        mov dword [byte edx-0Ch], 0
        mov dword [byte edx-01Ch], 0
        mov dword [byte edx-014h], 0
        mov dword [byte edx-010h], 0
        mov dword [byte edx-08h], ebx
        mov dword [byte edx-04h], ebx
        sub eax, byte 2Ch
        mov dword [byte edx-020h], ebx
        mov dword [edx], eax
        mov dword [edx+eax], 0FFFFFFFFh
        mov eax, edx
        pop edx
        pop ebx
        ret
__LastFree_:
        push ebx
        push edx
        mov edx, dword [HeapList]
        test edx, edx
        je short loc_9AC6B
        mov edx, dword [byte edx+024h]
        mov ebx, dword [edx]
        add ebx, edx
        mov ah, byte [_Extender]
        add ebx, byte 4
        cmp ah, 2
        jb short loc_9AC5E
        cmp ah, 8
        ja short loc_9AC5E
        cmp byte [Is8087], 0
        jne short loc_9AC5E
        xor eax, eax
        mov eax, ds
        lsl eax, eax
        inc eax
        mov dword [_curbrk], eax
loc_9AC5E:
        cmp ebx, dword [_curbrk]
        jne short loc_9AC6B
        mov eax, dword [edx]
        pop edx
        pop ebx
        ret
loc_9AC6B:
        xor eax, eax
        pop edx
        pop ebx
        ret
RationalAlloc_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push eax
        call __FreeDPMIBlocks_
        mov eax, dword [esp]
        shr eax, 10h
        mov ecx, dword [esp]
        mov ebx, eax
        mov ah, 5
        mov al, 1
        int 31h
        sbb eax, eax
        inc eax
        je short loc_9ACA1
        mov ax, bx
        shl eax, 10h
        mov ax, cx
        mov word [eax], di
        mov word [byte eax+02h], si
loc_9ACA1:
        test eax, eax
        je short loc_9ACBE
        mov ebx, dword [esp]
        lea edx, [byte eax+08h]
        sub ebx, byte 8
        mov dword [edx], ebx
        mov dword [byte eax+04h], 0
        mov eax, edx
        jmp near loc_9AD3A
loc_9ACBE:
        test word [RationalAllocFlags], 0FFF0h
        je short loc_9ACD3
        mov dword [RationalAllocLimit], 0FFFFFh
loc_9ACD3:
        cmp dword [esp], 10000h
        ja short loc_9AD38
        mov ebx, dword [RationalAllocLimit]
        shr ebx, 4
        or bl, 1
        mov ah, 48h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov edx, eax
        test eax, eax
        jl short loc_9AD38
        mov ebx, dword [esp]
        shr ebx, 4
        mov ah, 48h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov ebx, eax
        mov eax, edx
        push es
        mov es, eax
        mov ah, 49h
        int 21h
        rcl eax, 1
        ror eax, 1
        pop es
        test esi, esi
        jl short loc_9AD38
        mov ah, 0
        mov al, 6
        int 31h
        mov eax, ecx
        shl eax, 10h
        mov ax, dx
        add eax, byte 8
        mov edx, dword [esp]
        mov dword [byte eax-04h], esi
        sub edx, byte 8
        mov dword [eax], edx
        jmp short loc_9AD3A
loc_9AD38:
        xor eax, eax
loc_9AD3A:
        add esp, byte 4
loc_9AD3D:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__CreateNewNHeap_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push eax
        cmp dword [__heap_enabled], byte 0
        jne short loc_9AD56
loc_9AD52:
        xor eax, eax
        jmp short loc_9AD3A
loc_9AD56:
        cmp dword [_curbrk], byte 0FFFFFFFEh
        je short loc_9AD52
        mov eax, esp
        call __AdjustAmount_
        test eax, eax
        je short loc_9AD3A
        cmp byte [_Extender], 1
        jne short loc_9AD8A
        mov eax, dword [esp]
        call RationalAlloc_
        mov ebx, eax
        mov edx, eax
        test eax, eax
        je short loc_9ADA5
        mov eax, dword [eax]
        mov dword [esp], eax
        jmp short loc_9ADA5
loc_9AD8A:
        mov ebx, dword [esp]
        mov eax, 80004800h
        int 21h
        sbb ebx, ebx
        not ebx
        and eax, ebx
        mov ecx, dword [esp]
        sub ecx, byte 4
        mov edx, eax
        mov dword [esp], ecx
loc_9ADA5:
        test edx, edx
        je short loc_9AD52
        mov eax, dword [esp]
        mov esi, dword [esp]
        sub eax, byte 4
        cmp eax, esi
        ja short loc_9AD52
        mov dword [esp], eax
        cmp eax, byte 38h
        jb short loc_9AD52
        mov dword [edx], eax
        mov eax, edx
        call __LinkUpNewMHeap_
        mov ebx, eax
        mov eax, dword [eax]
        mov dword [esp], eax
        or al, 1
        mov dword [ebx], eax
        mov edi, dword [byte edx+018h]
        mov dword [byte edx+014h], 0FFFFFFFFh
        inc edi
        lea eax, [byte ebx+04h]
        mov dword [byte edx+018h], edi
        call _nfree_
        mov eax, 1
        jmp near loc_9AD3A
__ExpandDGROUP_:
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        push eax
        cmp byte [_Extender], 1
        jne short loc_9AE0A
        cmp byte [_ExtenderSubtype], 0
        je short loc_9AE13
loc_9AE0A:
        cmp byte [_Extender], 9
        jne short loc_9AE20
loc_9AE13:
        mov eax, dword [esp]
        call __CreateNewNHeap_
        jmp near loc_9AF2D
loc_9AE20:
        cmp dword [__heap_enabled], byte 0
        jne short loc_9AE30
loc_9AE29:
        xor eax, eax
        jmp near loc_9AF2D
loc_9AE30:
        cmp dword [_curbrk], byte 0FFFFFFFEh
        je short loc_9AE29
        mov eax, esp
        call __AdjustAmount_
        test eax, eax
        je near loc_9AF2D
        mov bl, byte [_Extender]
        cmp bl, 2
        jb short loc_9AE6E
        cmp bl, 8
        ja short loc_9AE6E
        cmp byte [Is8087], 0
        jne short loc_9AE6E
        xor eax, eax
        mov eax, ds
        lsl eax, eax
        inc eax
        mov dword [_curbrk], eax
loc_9AE6E:
        mov edx, dword [esp]
        mov ecx, dword [_curbrk]
        add edx, ecx
        cmp edx, ecx
        jae short loc_9AE82
        mov edx, 0FFFFFFFEh
loc_9AE82:
        mov eax, edx
        call __brk_
        cmp eax, byte 0FFFFFFFFh
        je short loc_9AE29
        mov ebx, eax
        cmp eax, byte 0FFFFFFF8h
        ja short loc_9AE29
        cmp edx, eax
        jbe short loc_9AE29
        sub edx, eax
        lea eax, [byte edx-04h]
        mov dword [esp], edx
        cmp eax, edx
        ja short loc_9AE29
        mov edx, dword [HeapList]
        mov dword [esp], eax
        jmp short loc_9AEC2
loc_9AEB0:
        mov ebp, dword [byte edx+08h]
        test ebp, ebp
        je short loc_9AEC6
        cmp edx, ebx
        ja short loc_9AEBF
        cmp ebx, ebp
        jb short loc_9AEC6
loc_9AEBF:
        mov edx, dword [byte edx+08h]
loc_9AEC2:
        test edx, edx
        jne short loc_9AEB0
loc_9AEC6:
        test edx, edx
        je short loc_9AEF0
        mov eax, dword [edx]
        lea ecx, [byte ebx-04h]
        add eax, edx
        cmp ecx, eax
        jne short loc_9AEF0
        mov esi, dword [esp]
        add esi, byte 4
        mov dword [esp], esi
        add dword [edx], esi
        mov ebp, dword [esp]
        lea ecx, [eax+ebp]
        mov ebx, eax
        mov dword [ecx], 0FFFFFFFFh
        jmp short loc_9AF0F
loc_9AEF0:
        cmp dword [esp], byte 38h
        jb near loc_9AE29
        mov eax, dword [esp]
        mov dword [ebx], eax
        mov eax, ebx
        mov edx, ebx
        call __LinkUpNewMHeap_
        mov ebx, eax
        mov eax, dword [eax]
        mov dword [esp], eax
loc_9AF0F:
        mov eax, dword [esp]
        or al, 1
        mov dword [ebx], eax
        inc dword [byte edx+018h]
        lea eax, [byte ebx+04h]
        mov dword [byte edx+014h], 0FFFFFFFFh
        call _nfree_
        mov eax, 1
loc_9AF2D:
        add esp, byte 4
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__AdjustAmount_:
        push ebx
        push edx
        push esi
        mov ebx, eax
        mov edx, dword [eax]
        add edx, byte 3
        and dl, 0FCh
        test edx, edx
        jne short loc_9AF4D
loc_9AF47:
        xor eax, eax
        pop esi
        pop edx
        pop ebx
        ret
loc_9AF4D:
        cmp byte [_Extender], 1
        jne short loc_9AF5F
        cmp byte [_ExtenderSubtype], 0
        je short loc_9AF68
loc_9AF5F:
        cmp byte [_Extender], 9
        jne short loc_9AF6D
loc_9AF68:
        add edx, byte 8
        jmp short loc_9AF74
loc_9AF6D:
        call __LastFree_
        sub edx, eax
loc_9AF74:
        mov dword [ebx], edx
        add edx, byte 3Ch
        cmp edx, dword [ebx]
        jb short loc_9AF47
        mov esi, dword [dword_D5674]
        cmp edx, esi
        jae short loc_9AF8C
        mov edx, esi
        and dl, 0FEh
loc_9AF8C:
        mov dword [ebx], edx
        add edx, 0FFFh
        cmp edx, dword [ebx]
        jb short loc_9AF47
        and dh, 0F0h
        xor dl, dl
        mov dword [ebx], edx
        test edx, edx
        setne al
        and eax, 0FFh
        pop esi
        pop edx
        pop ebx
        ret
