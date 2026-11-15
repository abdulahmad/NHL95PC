; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_98801 progbits alloc exec nowrite align=1
extern __ExpandDGROUP_, _nfree_, _Extender, _ExtenderSubtype, byte_F24C4, dword_D43E8
global _nexpand_, loc_98811, __HeapManager_expand_, loc_98850, loc_9885A, loc_98876, loc_98889, loc_988B8
global loc_988C0, loc_988C3, loc_988CA, loc_988D7, loc_988E6, loc_9891A, loc_98955, loc_98960
global loc_98967, loc_9899C, loc_989A4, loc_989A7, loc_989AE, loc_989BD, loc_989BF, loc_989C8
global loc_989DF, loc_989E8, loc_989EC, loc_989F1, loc_98A21, loc_98A23, _nmsize_
_nexpand_:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov esi, eax
        mov edi, edx
        and byte [byte esp+04h], 0FEh
loc_98811:
        mov eax, dword_D43E8
        mov edx, ds
        mov ecx, esp
        xor eax, eax
        mov ebx, edi
        mov ax, dx
        mov edx, esi
        call __HeapManager_expand_
        mov edx, eax
        test eax, eax
        jne near loc_989C8
        mov eax, esi
        jmp near loc_98A23
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
        jae short loc_98850
        mov eax, 0FFFFFFFFh
loc_98850:
        cmp eax, byte 0Ch
        jae short loc_9885A
        mov eax, 0Ch
loc_9885A:
        lea edx, [byte edi-04h]
        mov dword [byte esp+04h], edx
        mov edx, dword [edx]
        and dl, 0FEh
        cmp eax, edx
        jbe near loc_98967
        mov ebx, dword [byte esp+04h]
        sub eax, edx
        add ebx, edx
loc_98876:
        mov dword [ecx], eax
        mov ebp, dword [ebx]
        cmp ebp, byte 0FFFFFFFFh
        jne short loc_98889
        mov ebp, 2
        jmp near loc_989BF
loc_98889:
        test ebp, 1
        jne near loc_98960
        mov eax, dword [byte ebx+08h]
        mov dword [byte esp+08h], eax
        mov eax, dword [byte ebx+04h]
        mov edx, ds
        mov dword [byte esp+0Ch], eax
        mov eax, dword_D43E8
        cmp dx, word [esp]
        jne short loc_988CA
        mov esi, dword [dword_D43E8]
        jmp short loc_988C3
loc_988B8:
        cmp esi, edi
        ja short loc_988C0
        cmp edi, edx
        jb short loc_988CA
loc_988C0:
        mov esi, dword [byte esi+08h]
loc_988C3:
        mov edx, dword [byte esi+08h]
        test edx, edx
        jne short loc_988B8
loc_988CA:
        mov edx, dword [byte esi+0Ch]
        cmp ebx, edx
        jne short loc_988D7
        mov eax, dword [byte edx+04h]
        mov dword [byte esi+0Ch], eax
loc_988D7:
        cmp ebp, dword [ecx]
        jb short loc_988E6
        mov eax, ebp
        mov edx, dword [ecx]
        sub eax, edx
        cmp eax, byte 0Ch
        jae short loc_9891A
loc_988E6:
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
        mov byte [byte_F24C4], dl
        mov edx, dword [ecx]
        cmp ebp, edx
        jb short loc_98955
        jmp near loc_989BD
loc_9891A:
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
        mov byte [byte_F24C4], ah
        jmp near loc_989BF
loc_98955:
        mov eax, edx
        sub eax, ebp
        add ebx, ebp
        jmp near loc_98876
loc_98960:
        mov ebp, 1
        jmp short loc_989BF
loc_98967:
        sub edx, eax
        cmp edx, byte 0Ch
        jb short loc_989BD
        mov ebx, eax
        mov ecx, dword [byte esp+04h]
        or bl, 1
        or dl, 1
        mov dword [ecx], ebx
        lea ebx, [ecx+eax]
        mov eax, dword_D43E8
        mov dword [byte esp+04h], ebx
        mov dword [ebx], edx
        mov edx, ds
        mov ebx, dword [esp]
        cmp dx, bx
        jne short loc_989AE
        mov esi, dword [dword_D43E8]
        jmp short loc_989A7
loc_9899C:
        cmp esi, edi
        ja short loc_989A4
        cmp edi, ecx
        jb short loc_989AE
loc_989A4:
        mov esi, dword [byte esi+08h]
loc_989A7:
        mov ecx, dword [byte esi+08h]
        test ecx, ecx
        jne short loc_9899C
loc_989AE:
        inc dword [byte esi+018h]
        mov eax, dword [byte esp+04h]
        add eax, byte 4
        call _nfree_
loc_989BD:
        xor ebp, ebp
loc_989BF:
        mov eax, ebp
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
loc_989C8:
        cmp eax, byte 1
        je short loc_98A21
        cmp byte [_Extender], 1
        jne short loc_989DF
        cmp byte [_ExtenderSubtype], 0
        je short loc_989E8
loc_989DF:
        cmp byte [_Extender], 9
        jne short loc_989EC
loc_989E8:
        xor edx, edx
        jmp short loc_989F1
loc_989EC:
        mov edx, 1
loc_989F1:
        test edx, edx
        je short loc_98A21
        cmp eax, byte 2
        jne near loc_98811
        mov bh, byte [byte esp+04h]
        test bh, 1
        jne short loc_98A21
        mov eax, dword [esp]
        call __ExpandDGROUP_
        test eax, eax
        je short loc_98A21
        mov cl, bh
        or cl, 1
        mov byte [byte esp+04h], cl
        jmp near loc_98811
loc_98A21:
        xor eax, eax
loc_98A23:
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
_nmsize_:
        mov eax, dword [byte eax-04h]
        and al, 0FEh
        sub eax, byte 4
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
