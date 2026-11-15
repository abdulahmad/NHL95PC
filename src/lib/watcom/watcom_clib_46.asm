; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_AF6D3 progbits alloc exec nowrite align=1
extern __set_doserrno_, __set_errno_, _dosretax_, _nfree_, _nmalloc_, dword_D4D00, _Envptr, _environ
extern ___env_mask, dword_D5674, dword_D8690, dword_D8696, dword_D869C, dword_D86A2, dword_D86A8, dword_D86AC
extern dword_D86B0, memset_, strcpy_, strlen_, _Envptr_w4, word_D8694, word_D869A, word_D86A0
extern word_D86A6, word_D86B4, word_D86B6
global __setenvp_, loc_AF6FE, loc_AF703, loc_AF711, loc_AF716, loc_AF71F, loc_AF752, loc_AF761
global loc_AF772, loc_AF797, loc_AF79E, stpcpy_, loc_AF7A8, loc_AF7B4, __cenvarg_, loc_AF7CD
global loc_AF7D7, loc_AF7E4, loc_AF7E9, loc_AF7FC, loc_AF843, loc_AF84D, loc_AF86E, loc_AF879
global loc_AF87E, loc_AF891, loc_AF89D, loc_AF8A2, loc_AF8AC, loc_AF8B2, loc_AF8DA, loc_AF8E8
global __ccmdline_, loc_AF8FD, loc_AF90A, loc_AF927, loc_AF931, __dospawn, loc_AF9BD, loc_AF9BF
global loc_AF9FE, pcopy_, loc_AFA1E, loc_AFA31, _splitpath2_, loc_AFA7A, loc_AFA7F, loc_AFA89
global loc_AFA8D, loc_AFA8F, loc_AFA9E, loc_AFAA7, loc_AFAAB, loc_AFABC
__setenvp_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push es
        push fs
        cmp dword [_environ], byte 0
        jne near loc_AF79E
        mov fs, word [_Envptr_w4]
        xor ecx, ecx
        xor dl, dl
        mov eax, fs
        mov edi, dword [_Envptr]
        mov es, eax
        mov eax, edi
loc_AF6FE:
        cmp dl, byte [es:eax]
        je short loc_AF716
loc_AF703:
        mov dh, byte [es:eax]
        lea ebx, [byte eax+01h]
        cmp dl, dh
        je short loc_AF711
        mov eax, ebx
        jmp short loc_AF703
loc_AF711:
        inc ecx
        mov eax, ebx
        jmp short loc_AF6FE
loc_AF716:
        sub eax, edi
        jne short loc_AF71F
        mov eax, 1
loc_AF71F:
        call _nmalloc_
        mov edx, eax
        mov ebx, eax
        test eax, eax
        je near loc_AF79E
        mov eax, ecx
        shl eax, 2
        add eax, byte 4
        add eax, ecx
        call _nmalloc_
        test eax, eax
        je short loc_AF797
        mov dword [_environ], eax
        xor esi, esi
        mov eax, fs
        xor ecx, ecx
        mov es, eax
        mov eax, edi
loc_AF752:
        cmp byte [es:eax], 0
        je short loc_AF772
        mov edx, dword [_environ]
        mov dword [ecx+edx], ebx
loc_AF761:
        mov dl, byte [es:eax]
        inc eax
        mov byte [ebx], dl
        inc ebx
        test dl, dl
        jne short loc_AF761
        add ecx, byte 4
        inc esi
        jmp short loc_AF752
loc_AF772:
        mov edx, dword [_environ]
        mov dword [ecx+edx], 0
        add ecx, byte 4
        add edx, ecx
        mov ebx, esi
        mov dword [___env_mask], edx
        mov eax, edx
        xor edx, edx
        call memset_
        jmp short loc_AF79E
loc_AF797:
        mov eax, edx
        call _nfree_
loc_AF79E:
        pop fs
        pop es
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
stpcpy_:
        push ebx
loc_AF7A8:
        mov bl, byte [edx]
        mov byte [eax], bl
        test bl, bl
        je short loc_AF7B4
        inc eax
        inc edx
        jmp short loc_AF7A8
loc_AF7B4:
        pop ebx
        ret
__cenvarg_:
        push esi
        push edi
        enter 8, 0
        mov esi, eax
        mov edi, edx
        mov dword [byte ebp-04h], ebx
        test edx, edx
        jne short loc_AF7CD
        mov edi, dword [_environ]
loc_AF7CD:
        xor ebx, ebx
        test edi, edi
        je short loc_AF7E9
        mov edx, edi
        jmp short loc_AF7E4
loc_AF7D7:
        mov eax, dword [edx]
        call strlen_
        inc eax
        add edx, byte 4
        add ebx, eax
loc_AF7E4:
        cmp dword [edx], byte 0
        jne short loc_AF7D7
loc_AF7E9:
        inc ebx
        cmp dword [byte ebp+018h], byte 0
        je short loc_AF7FC
        mov eax, dword [esi]
        call strlen_
        add eax, byte 3
        add ebx, eax
loc_AF7FC:
        mov eax, dword [dword_D5674]
        add ebx, byte 0Fh
        mov dword [byte ebp-08h], eax
        mov eax, ebx
        mov dword [dword_D5674], 10h
        call _nmalloc_
        test eax, eax
        jne short loc_AF84D
        mov eax, ebx
        call _nmalloc_
        test eax, eax
        jne short loc_AF84D
        mov eax, 5
        call __set_errno_
        mov eax, 8
        call __set_doserrno_
        mov eax, dword [byte ebp-08h]
        mov dword [dword_D5674], eax
loc_AF843:
        mov eax, 0FFFFFFFFh
        jmp near loc_AF8E8
loc_AF84D:
        mov edx, dword [byte ebp-08h]
        mov dword [dword_D5674], edx
        mov edx, dword [byte ebp-04h]
        mov dword [edx], eax
        mov edx, dword [byte ebp+010h]
        mov dword [edx], 0
        mov dword [ecx], eax
        test edi, edi
        je short loc_AF87E
        mov ecx, edi
        jmp short loc_AF879
loc_AF86E:
        mov edx, dword [ecx]
        call stpcpy_
        inc eax
        add ecx, byte 4
loc_AF879:
        cmp dword [ecx], byte 0
        jne short loc_AF86E
loc_AF87E:
        mov byte [eax], 0
        inc eax
        cmp dword [byte ebp+018h], byte 0
        je short loc_AF891
        inc eax
        inc eax
        mov edx, dword [esi]
        call strcpy_
loc_AF891:
        xor edx, edx
        cmp dword [esi], byte 0
        je short loc_AF8B2
        add esi, byte 4
        jmp short loc_AF8AC
loc_AF89D:
        test edx, edx
        je short loc_AF8A2
        inc edx
loc_AF8A2:
        call strlen_
        add esi, byte 4
        add edx, eax
loc_AF8AC:
        mov eax, dword [esi]
        test eax, eax
        jne short loc_AF89D
loc_AF8B2:
        cmp edx, byte 7Eh
        jbe short loc_AF8DA
        mov eax, 2
        call __set_errno_
        mov eax, 0Ah
        call __set_doserrno_
        mov eax, dword [byte ebp-04h]
        mov eax, dword [eax]
        call _nfree_
        jmp near loc_AF843
loc_AF8DA:
        mov eax, dword [byte ebp+014h]
        mov dword [eax], 90h
        mov eax, ebx
        shr eax, 4
loc_AF8E8:
        leave
        pop edi
        pop esi
        ret 0Ch
__ccmdline_:
        push esi
        enter 4, 0
        mov esi, edx
        mov dword [byte ebp-04h], ebx
        test ecx, ecx
        jne short loc_AF8FD
        inc ebx
loc_AF8FD:
        cmp dword [esi], byte 0
        je short loc_AF927
        add esi, byte 4
        cmp dword [esi], byte 0
        je short loc_AF927
loc_AF90A:
        mov eax, ebx
        mov edx, dword [esi]
        call stpcpy_
        add esi, byte 4
        mov edx, eax
        mov ebx, eax
        cmp dword [esi], byte 0
        je short loc_AF927
        lea ebx, [byte eax+01h]
        mov byte [eax], 20h
        jmp short loc_AF90A
loc_AF927:
        test ecx, ecx
        je short loc_AF931
        mov byte [ebx], 0
        leave
        pop esi
        ret
loc_AF931:
        mov dl, bl
        mov byte [ebx], 0Dh
        sub dl, byte [byte ebp-04h]
        mov ebx, dword [byte ebp-04h]
        dec dl
        mov byte [ebx], dl
        leave
        pop esi
        ret
__dospawn:
        push ebp
        mov ebp, esp
        push esi
        push edi
        push edx
        push ecx
        push ebx
        push es
        push ds
        mov ax, ss
        mov ds, eax
        mov eax, dword [byte ebp+014h]
        mov dword [dword_D8690], eax
        o16 mov word [word_D8694], ds
        sub eax, eax
        mov dword [dword_D869C], eax
        mov dword [dword_D86A2], eax
        mov word [word_D86A0], ax
        mov word [word_D86A6], ax
        mov dword [dword_D86A8], eax
        mov dword [dword_D86AC], eax
        mov eax, dword [byte ebp+010h]
        mov dword [dword_D8696], eax
        o16 mov word [word_D869A], ds
        push ds
        pop es
        push ebp
        push es
        push ds
        o16 mov word [word_D86B4], ss
        mov dword [dword_D86B0], esp
        o16 mov word [word_D86B6], ds
        db 03Eh,0BBh                            ; insn: mov ebx,18690h
        dd dword_D8690
        cmp dword [byte ebp+08h], byte 1
        jne short loc_AF9BD
        mov al, 4
        xor ecx, ecx
        jmp short loc_AF9BF
loc_AF9BD:
        xor al, al
loc_AF9BF:
        clc
        push eax
        mov ah, 0Bh
        int 21h
        pop eax
        mov dword [dword_D4D00], 1
        mov edx, dword [byte ebp+0Ch]
        mov ah, 4Bh
        int 21h
        o16 mov ss, word [word_D86B4]
        mov esp, dword [dword_D86B0]
        o16 mov ds, word [word_D86B6]
        pop ds
        mov dword [dword_D4D00], 0
        pop es
        pop ebp
        jb short loc_AF9FE
        mov ah, 4Dh
        int 21h
loc_AF9FE:
        sbb edx, edx
        movzx eax, ax
        call _dosretax_
        pop ds
        pop es
        pop ebx
        pop ecx
        pop edx
        pop edi
        pop esi
        pop ebp
        ret
pcopy_:
        push esi
        push edi
        mov esi, ebx
        test eax, eax
        jne short loc_AFA1E
        mov eax, edx
        pop edi
        pop esi
        ret
loc_AFA1E:
        mov ebx, ecx
        sub ebx, esi
        mov dword [eax], edx
        cmp ebx, 93h
        jb short loc_AFA31
        mov ebx, 92h
loc_AFA31:
        mov edi, edx
        mov ecx, ebx
        push es
        mov eax, ds
        mov es, eax
        push edi
        mov eax, ecx
        shr ecx, 2
        repne movsd
        LD mov, cl, al
        and cl, 3
        repne movsb
        pop edi
        pop es
        lea eax, [edx+ebx]
        mov byte [eax], 0
        inc eax
        pop edi
        pop esi
        ret
_splitpath2_:
        push esi
        push edi
        push ebp
        mov esi, eax
        cmp byte [eax], 0
        je short loc_AFA7F
        cmp byte [byte esi+01h], 3Ah
        jne short loc_AFA7F
        test ebx, ebx
        je short loc_AFA7A
        mov dword [ebx], edx
        mov al, byte [esi]
        mov byte [byte edx+01h], 3Ah
        mov byte [byte edx+02h], 0
        mov byte [edx], al
        add edx, byte 3
loc_AFA7A:
        add esi, byte 2
        jmp short loc_AFA89
loc_AFA7F:
        test ebx, ebx
        je short loc_AFA89
        mov dword [ebx], edx
        mov byte [edx], 0
        inc edx
loc_AFA89:
        mov ebp, esi
        mov ebx, esi
loc_AFA8D:
        xor edi, edi
loc_AFA8F:
        mov al, byte [esi]
        test al, al
        je short loc_AFAAB
        cmp al, 2Eh
        jne short loc_AFA9E
        mov edi, esi
        inc esi
        jmp short loc_AFA8F
loc_AFA9E:
        inc esi
        cmp al, 5Ch
        je short loc_AFAA7
        cmp al, 2Fh
        jne short loc_AFA8F
loc_AFAA7:
        mov ebp, esi
        jmp short loc_AFA8D
loc_AFAAB:
        mov eax, ecx
        mov ecx, ebp
        call pcopy_
        mov edx, eax
        test edi, edi
        jne short loc_AFABC
        mov edi, esi
loc_AFABC:
        mov eax, dword [byte esp+010h]
        mov ebx, ebp
        mov ecx, edi
        call pcopy_
        mov edx, eax
        mov ebx, edi
        mov ecx, esi
        mov eax, dword [byte esp+014h]
        call pcopy_
        pop ebp
        pop edi
        pop esi
        ret 8
        db 00h,00h
