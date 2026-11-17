; DOS/4GW heap: DPMI memory blocks for the near heap, sbrk growth.
bits 32
%include "hockey.inc"
section s_9AA66 progbits alloc exec nowrite align=1
extern __amblksiz, __brk_, __heap_enabled, __unlink_, _curbrk, _Extender, _ExtenderSubtype, _nfree_
extern HeapList, Is8087, RationalAllocFlags, RationalAllocLimit
global __FreeDPMIBlocks_, __ReAllocDPMIBlock_, __LinkUpNewMHeap_, __LastFree_, RationalAlloc_, __CreateNewNHeap_, __ExpandDGROUP_, __AdjustAmount_
;-----------------------------------------------------------------------------
; __FreeDPMIBlocks_                                             9AA66  library
; Run-time heap: frees the DPMI memory blocks of the near heap
;-----------------------------------------------------------------------------
__FreeDPMIBlocks_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, dword [HeapList]
.1:
        test edx, edx
        je near RationalAlloc_+0CDh
        mov eax, dword [byte edx+024h]
        mov eax, dword [eax]
        mov ebx, dword [edx]
        add eax, byte 2Ch
        cmp eax, ebx
        jne short .3
        lea ebx, [byte edx-08h]
        mov eax, edx
        mov ecx, dword [byte edx+08h]
        call __unlink_
        mov edx, ecx
        mov ecx, dword [byte ebx+04h]
        test ecx, ecx
        jne short .2
        mov eax, dword [ebx]
        shr eax, 10h
        mov di, word [ebx]
        mov esi, eax
        mov ah, 5
        mov al, 2
        int 31h
        jmp short .1
.2:
        mov eax, ecx
        push es
        mov es, eax
        mov ah, 49h
        int 21h
        rcl eax, 1
        ror eax, 1
        pop es
        jmp short .1
.3:
        mov edx, dword [byte edx+08h]
        jmp short .1
;-----------------------------------------------------------------------------
; __ReAllocDPMIBlock_                                           9AAC4  library
; Run-time heap: resizes a DPMI memory block
;-----------------------------------------------------------------------------
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
        jmp near .5
.1:
        cmp edx, ebx
        ja near .6
        lea eax, [byte edx+02Ch]
        cmp eax, ebx
        jne near .4
        mov eax, edx
        call __unlink_
        lea eax, [byte edx-08h]
        cmp dword [byte eax+04h], byte 0
        jne near .6
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
        je short .2
        mov ax, bx
        shl eax, 10h
        mov ax, cx
        mov word [eax], di
        mov word [byte eax+02h], si
.2:
        test eax, eax
        je short .7
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
        jb short .3
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
.3:
        mov eax, esi
        jmp short .7
.4:
        mov edx, dword [byte edx+08h]
.5:
        test edx, edx
        jne near .1
.6:
        xor eax, eax
.7:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __LinkUpNewMHeap_                                             9ABAE  library
; Run-time heap: links a new memory block into the near heap list
;-----------------------------------------------------------------------------
__LinkUpNewMHeap_:
        push ebx
        push edx
        mov edx, eax
        mov eax, dword [HeapList]
        xor ebx, ebx
        jmp short .2
.1:
        cmp edx, eax
        jb short .3
        mov ebx, eax
        mov eax, dword [byte eax+08h]
.2:
        test eax, eax
        jne short .1
.3:
        mov dword [byte edx+04h], ebx
        mov dword [byte edx+08h], eax
        test ebx, ebx
        je short .4
        mov dword [byte ebx+08h], edx
        jmp short .5
.4:
        mov dword [HeapList], edx
.5:
        test eax, eax
        je short .6
        mov dword [byte eax+04h], edx
.6:
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
;-----------------------------------------------------------------------------
; __LastFree_                                                   9AC22  library
; Run-time heap: finds the last free entry of the heap
;-----------------------------------------------------------------------------
__LastFree_:
        push ebx
        push edx
        mov edx, dword [HeapList]
        test edx, edx
        je short .2
        mov edx, dword [byte edx+024h]
        mov ebx, dword [edx]
        add ebx, edx
        mov ah, byte [_Extender]
        add ebx, byte 4
        cmp ah, 2
        jb short .1
        cmp ah, 8
        ja short .1
        cmp byte [Is8087], 0
        jne short .1
        xor eax, eax
        mov eax, ds
        lsl eax, eax
        inc eax
        mov dword [_curbrk], eax
.1:
        cmp ebx, dword [_curbrk]
        jne short .2
        mov eax, dword [edx]
        pop edx
        pop ebx
        ret
.2:
        xor eax, eax
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; RationalAlloc_                                                9AC70  library
; DOS/4GW: allocates memory through the extender
;-----------------------------------------------------------------------------
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
        je short .1
        mov ax, bx
        shl eax, 10h
        mov ax, cx
        mov word [eax], di
        mov word [byte eax+02h], si
.1:
        test eax, eax
        je short .2
        mov ebx, dword [esp]
        lea edx, [byte eax+08h]
        sub ebx, byte 8
        mov dword [edx], ebx
        mov dword [byte eax+04h], 0
        mov eax, edx
        jmp near RationalAlloc_+0CAh
.2:
        test word [RationalAllocFlags], 0FFF0h
        je short .3
        mov dword [RationalAllocLimit], 0FFFFFh
.3:
        cmp dword [esp], 10000h
        ja short .4
        mov ebx, dword [RationalAllocLimit]
        shr ebx, 4
        or bl, 1
        mov ah, 48h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov edx, eax
        test eax, eax
        jl short .4
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
        jl short .4
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
        jmp short RationalAlloc_+0CAh
.4:
        xor eax, eax
        add esp, byte 4
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __CreateNewNHeap_                                             9AD43  library
; Run-time heap: creates a new near heap segment
;-----------------------------------------------------------------------------
__CreateNewNHeap_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push eax
        cmp dword [__heap_enabled], byte 0
        jne short .2
.1:
        xor eax, eax
        jmp short RationalAlloc_+0CAh
.2:
        cmp dword [_curbrk], byte 0FFFFFFFEh
        je short .1
        mov eax, esp
        call __AdjustAmount_
        test eax, eax
        je short RationalAlloc_+0CAh
        cmp byte [_Extender], 1
        jne short .3
        mov eax, dword [esp]
        call RationalAlloc_
        mov ebx, eax
        mov edx, eax
        test eax, eax
        je short .4
        mov eax, dword [eax]
        mov dword [esp], eax
        jmp short .4
.3:
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
.4:
        test edx, edx
        je short .1
        mov eax, dword [esp]
        mov esi, dword [esp]
        sub eax, byte 4
        cmp eax, esi
        ja short .1
        mov dword [esp], eax
        cmp eax, byte 38h
        jb short .1
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
        jmp near RationalAlloc_+0CAh
;-----------------------------------------------------------------------------
; __ExpandDGROUP_                                               9ADF2  library
; Run-time heap: grows the data group for the near heap
;-----------------------------------------------------------------------------
__ExpandDGROUP_:
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        push eax
        cmp byte [_Extender], 1
        jne short .1
        cmp byte [_ExtenderSubtype], 0
        je short .2
.1:
        cmp byte [_Extender], 9
        jne short .3
.2:
        mov eax, dword [esp]
        call __CreateNewNHeap_
        jmp near .14
.3:
        cmp dword [__heap_enabled], byte 0
        jne short .5
.4:
        xor eax, eax
        jmp near .14
.5:
        cmp dword [_curbrk], byte 0FFFFFFFEh
        je short .4
        mov eax, esp
        call __AdjustAmount_
        test eax, eax
        je near .14
        mov bl, byte [_Extender]
        cmp bl, 2
        jb short .6
        cmp bl, 8
        ja short .6
        cmp byte [Is8087], 0
        jne short .6
        xor eax, eax
        mov eax, ds
        lsl eax, eax
        inc eax
        mov dword [_curbrk], eax
.6:
        mov edx, dword [esp]
        mov ecx, dword [_curbrk]
        add edx, ecx
        cmp edx, ecx
        jae short .7
        mov edx, 0FFFFFFFEh
.7:
        mov eax, edx
        call __brk_
        cmp eax, byte 0FFFFFFFFh
        je short .4
        mov ebx, eax
        cmp eax, byte 0FFFFFFF8h
        ja short .4
        cmp edx, eax
        jbe short .4
        sub edx, eax
        lea eax, [byte edx-04h]
        mov dword [esp], edx
        cmp eax, edx
        ja short .4
        mov edx, dword [HeapList]
        mov dword [esp], eax
        jmp short .10
.8:
        mov ebp, dword [byte edx+08h]
        test ebp, ebp
        je short .11
        cmp edx, ebx
        ja short .9
        cmp ebx, ebp
        jb short .11
.9:
        mov edx, dword [byte edx+08h]
.10:
        test edx, edx
        jne short .8
.11:
        test edx, edx
        je short .12
        mov eax, dword [edx]
        lea ecx, [byte ebx-04h]
        add eax, edx
        cmp ecx, eax
        jne short .12
        mov esi, dword [esp]
        add esi, byte 4
        mov dword [esp], esi
        add dword [edx], esi
        mov ebp, dword [esp]
        lea ecx, [eax+ebp]
        mov ebx, eax
        mov dword [ecx], 0FFFFFFFFh
        jmp short .13
.12:
        cmp dword [esp], byte 38h
        jb near .4
        mov eax, dword [esp]
        mov dword [ebx], eax
        mov eax, ebx
        mov edx, ebx
        call __LinkUpNewMHeap_
        mov ebx, eax
        mov eax, dword [eax]
        mov dword [esp], eax
.13:
        mov eax, dword [esp]
        or al, 1
        mov dword [ebx], eax
        inc dword [byte edx+018h]
        lea eax, [byte ebx+04h]
        mov dword [byte edx+014h], 0FFFFFFFFh
        call _nfree_
        mov eax, 1
.14:
        add esp, byte 4
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __AdjustAmount_                                               9AF36  library
; Run-time heap: rounds a request size to the heap granularity
;-----------------------------------------------------------------------------
__AdjustAmount_:
        push ebx
        push edx
        push esi
        mov ebx, eax
        mov edx, dword [eax]
        add edx, byte 3
        and dl, 0FCh
        test edx, edx
        jne short .2
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ebx
        ret
.2:
        cmp byte [_Extender], 1
        jne short .3
        cmp byte [_ExtenderSubtype], 0
        je short .4
.3:
        cmp byte [_Extender], 9
        jne short .5
.4:
        add edx, byte 8
        jmp short .6
.5:
        call __LastFree_
        sub edx, eax
.6:
        mov dword [ebx], edx
        add edx, byte 3Ch
        cmp edx, dword [ebx]
        jb short .1
        mov esi, dword [__amblksiz]
        cmp edx, esi
        jae short .7
        mov edx, esi
        and dl, 0FEh
.7:
        mov dword [ebx], edx
        add edx, 0FFFh
        cmp edx, dword [ebx]
        jb short .1
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
