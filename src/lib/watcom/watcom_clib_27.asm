; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_98801 progbits alloc exec nowrite align=1
extern __ExpandDGROUP_, _nfree_, _Extender, _ExtenderSubtype, __HeapFlags, HeapList
global _nexpand_, __HeapManager_expand_, __HeapManager_expand_, __HeapManager_expand_, _nmsize_
;-----------------------------------------------------------------------------
; _nexpand_                                                     98801  library
; Run-time library: grows a near heap block in place
;-----------------------------------------------------------------------------
_nexpand_:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov esi, eax
        mov edi, edx
        and byte [byte esp+04h], 0FEh
        mov eax, HeapList
        mov edx, ds
        mov ecx, esp
        xor eax, eax
        mov ebx, edi
        mov ax, dx
        mov edx, esi
        call __HeapManager_expand_
        mov edx, eax
        test eax, eax
        jne near __HeapManager_expand_+018Fh
        mov eax, esi
        jmp near __HeapManager_expand_+01EAh
;-----------------------------------------------------------------------------
; __HeapManager_expand_                                         98839  library
; Run-time heap: grows a block in place
;-----------------------------------------------------------------------------
__HeapManager_expand_:
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        push eax
        mov edi, edx
        lea eax, [byte ebx+07h]
        and al, 0FCh
        cmp eax, ebx
        jae short .1
        mov eax, 0FFFFFFFFh
.1:
        cmp eax, byte 0Ch
        jae short .2
        mov eax, 0Ch
.2:
        lea edx, [byte edi-04h]
        mov dword [byte esp+04h], edx
        mov edx, dword [edx]
        and dl, 0FEh
        cmp eax, edx
        jbe near .14
        mov ebx, dword [byte esp+04h]
        sub eax, edx
        add ebx, edx
.3:
        mov dword [ecx], eax
        mov ebp, dword [ebx]
        cmp ebp, byte 0FFFFFFFFh
        jne short .4
        mov ebp, 2
        jmp near .20
.4:
        test ebp, 1
        jne near .13
        mov eax, dword [byte ebx+08h]
        mov dword [byte esp+08h], eax
        mov eax, dword [byte ebx+04h]
        mov edx, ds
        mov dword [byte esp+0Ch], eax
        mov eax, HeapList
        cmp dx, word [esp]
        jne short .8
        mov esi, dword [HeapList]
        jmp short .7
.5:
        cmp esi, edi
        ja short .6
        cmp edi, edx
        jb short .8
.6:
        mov esi, dword [byte esi+08h]
.7:
        mov edx, dword [byte esi+08h]
        test edx, edx
        jne short .5
.8:
        mov edx, dword [byte esi+0Ch]
        cmp ebx, edx
        jne short .9
        mov eax, dword [byte edx+04h]
        mov dword [byte esi+0Ch], eax
.9:
        cmp ebp, dword [ecx]
        jb short .10
        mov eax, ebp
        mov edx, dword [ecx]
        sub eax, edx
        cmp eax, byte 0Ch
        jae short .11
.10:
        mov eax, dword [byte esp+0Ch]
        mov edx, dword [byte esp+08h]
        mov dword [byte eax+08h], edx
        mov eax, edx
        mov edx, dword [byte esp+0Ch]
        mov dword [byte eax+04h], edx
        mov eax, dword [byte esp+04h]
        add dword [eax], ebp
        mov eax, dword [byte esi+01Ch]
        dec eax
        xor dl, dl
        mov dword [byte esi+01Ch], eax
        mov byte [__HeapFlags], dl
        mov edx, dword [ecx]
        cmp ebp, edx
        jb short .12
        jmp near .19
.11:
        add ebx, edx
        mov dword [ebx], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [byte ebx+04h], eax
        mov eax, dword [byte esp+08h]
        mov dword [byte ebx+08h], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [byte eax+08h], ebx
        mov eax, dword [byte esp+08h]
        mov dword [byte eax+04h], ebx
        mov edx, dword [byte esp+04h]
        mov eax, dword [ecx]
        mov edi, dword [edx]
        xor ebp, ebp
        add edi, eax
        xor ah, ah
        mov dword [edx], edi
        mov byte [__HeapFlags], ah
        jmp near .20
.12:
        mov eax, edx
        sub eax, ebp
        add ebx, ebp
        jmp near .3
.13:
        mov ebp, 1
        jmp short .20
.14:
        sub edx, eax
        cmp edx, byte 0Ch
        jb short .19
        mov ebx, eax
        mov ecx, dword [byte esp+04h]
        or bl, 1
        or dl, 1
        mov dword [ecx], ebx
        lea ebx, [ecx+eax]
        mov eax, HeapList
        mov dword [byte esp+04h], ebx
        mov dword [ebx], edx
        mov edx, ds
        mov ebx, dword [esp]
        cmp dx, bx
        jne short .18
        mov esi, dword [HeapList]
        jmp short .17
.15:
        cmp esi, edi
        ja short .16
        cmp edi, ecx
        jb short .18
.16:
        mov esi, dword [byte esi+08h]
.17:
        mov ecx, dword [byte esi+08h]
        test ecx, ecx
        jne short .15
.18:
        inc dword [byte esi+018h]
        mov eax, dword [byte esp+04h]
        add eax, byte 4
        call _nfree_
.19:
        xor ebp, ebp
.20:
        mov eax, ebp
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
        cmp eax, byte 1
        je short .25
        cmp byte [_Extender], 1
        jne short .21
        cmp byte [_ExtenderSubtype], 0
        je short .22
.21:
        cmp byte [_Extender], 9
        jne short .23
.22:
        xor edx, edx
        jmp short .24
.23:
        mov edx, 1
.24:
        test edx, edx
        je short .25
        cmp eax, byte 2
        jne near _nexpand_+010h
        mov bh, byte [byte esp+04h]
        test bh, 1
        jne short .25
        mov eax, dword [esp]
        call __ExpandDGROUP_
        test eax, eax
        je short .25
        mov cl, bh
        or cl, 1
        mov byte [byte esp+04h], cl
        jmp near _nexpand_+010h
.25:
        xor eax, eax
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; _nmsize_                                                      98A2B  library
; Run-time library: the size of a near heap block
;-----------------------------------------------------------------------------
_nmsize_:
        mov eax, dword [byte eax-04h]
        and al, 0FEh
        sub eax, byte 4
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
