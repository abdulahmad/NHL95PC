; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_AF6D3 progbits alloc exec nowrite align=1
extern __set_doserrno_, __set_errno_, _dosretax_, _nfree_, _nmalloc_, dword_D4D00, _Envptr, _environ
extern ___env_mask, __amblksiz, dword_D8690, dword_D8696, dword_D869C, dword_D86A2, dword_D86A8, dword_D86AC
extern dword_D86B0, memset_, strcpy_, strlen_, _Envptr_w4, word_D8694, word_D869A, word_D86A0
extern word_D86A6, word_D86B4, word_D86B6
global __setenvp_, stpcpy_, __cenvarg_, __ccmdline_, __dospawn, pcopy_, _splitpath2_
__setenvp_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push es
        push fs
        cmp dword [_environ], byte 0
        jne near .10
        mov fs, word [_Envptr_w4]
        xor ecx, ecx
        xor dl, dl
        mov eax, fs
        mov edi, dword [_Envptr]
        mov es, eax
        mov eax, edi
.1:
        cmp dl, byte [es:eax]
        je short .4
.2:
        mov dh, byte [es:eax]
        lea ebx, [byte eax+01h]
        cmp dl, dh
        je short .3
        mov eax, ebx
        jmp short .2
.3:
        inc ecx
        mov eax, ebx
        jmp short .1
.4:
        sub eax, edi
        jne short .5
        mov eax, 1
.5:
        call _nmalloc_
        mov edx, eax
        mov ebx, eax
        test eax, eax
        je near .10
        mov eax, ecx
        shl eax, 2
        add eax, byte 4
        add eax, ecx
        call _nmalloc_
        test eax, eax
        je short .9
        mov dword [_environ], eax
        xor esi, esi
        mov eax, fs
        xor ecx, ecx
        mov es, eax
        mov eax, edi
.6:
        cmp byte [es:eax], 0
        je short .8
        mov edx, dword [_environ]
        mov dword [ecx+edx], ebx
.7:
        mov dl, byte [es:eax]
        inc eax
        mov byte [ebx], dl
        inc ebx
        test dl, dl
        jne short .7
        add ecx, byte 4
        inc esi
        jmp short .6
.8:
        mov edx, dword [_environ]
        mov dword [ecx+edx], 0
        add ecx, byte 4
        add edx, ecx
        mov ebx, esi
        mov dword [___env_mask], edx
        mov eax, edx
        xor edx, edx
        call memset_
        jmp short .10
.9:
        mov eax, edx
        call _nfree_
.10:
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
.1:
        mov bl, byte [edx]
        mov byte [eax], bl
        test bl, bl
        je short .2
        inc eax
        inc edx
        jmp short .1
.2:
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
        jne short .1
        mov edi, dword [_environ]
.1:
        xor ebx, ebx
        test edi, edi
        je short .4
        mov edx, edi
        jmp short .3
.2:
        mov eax, dword [edx]
        call strlen_
        inc eax
        add edx, byte 4
        add ebx, eax
.3:
        cmp dword [edx], byte 0
        jne short .2
.4:
        inc ebx
        cmp dword [byte ebp+018h], byte 0
        je short .5
        mov eax, dword [esi]
        call strlen_
        add eax, byte 3
        add ebx, eax
.5:
        mov eax, dword [__amblksiz]
        add ebx, byte 0Fh
        mov dword [byte ebp-08h], eax
        mov eax, ebx
        mov dword [__amblksiz], 10h
        call _nmalloc_
        test eax, eax
        jne short .7
        mov eax, ebx
        call _nmalloc_
        test eax, eax
        jne short .7
        mov eax, 5
        call __set_errno_
        mov eax, 8
        call __set_doserrno_
        mov eax, dword [byte ebp-08h]
        mov dword [__amblksiz], eax
.6:
        mov eax, 0FFFFFFFFh
        jmp near .17
.7:
        mov edx, dword [byte ebp-08h]
        mov dword [__amblksiz], edx
        mov edx, dword [byte ebp-04h]
        mov dword [edx], eax
        mov edx, dword [byte ebp+010h]
        mov dword [edx], 0
        mov dword [ecx], eax
        test edi, edi
        je short .10
        mov ecx, edi
        jmp short .9
.8:
        mov edx, dword [ecx]
        call stpcpy_
        inc eax
        add ecx, byte 4
.9:
        cmp dword [ecx], byte 0
        jne short .8
.10:
        mov byte [eax], 0
        inc eax
        cmp dword [byte ebp+018h], byte 0
        je short .11
        inc eax
        inc eax
        mov edx, dword [esi]
        call strcpy_
.11:
        xor edx, edx
        cmp dword [esi], byte 0
        je short .15
        add esi, byte 4
        jmp short .14
.12:
        test edx, edx
        je short .13
        inc edx
.13:
        call strlen_
        add esi, byte 4
        add edx, eax
.14:
        mov eax, dword [esi]
        test eax, eax
        jne short .12
.15:
        cmp edx, byte 7Eh
        jbe short .16
        mov eax, 2
        call __set_errno_
        mov eax, 0Ah
        call __set_doserrno_
        mov eax, dword [byte ebp-04h]
        mov eax, dword [eax]
        call _nfree_
        jmp near .6
.16:
        mov eax, dword [byte ebp+014h]
        mov dword [eax], 90h
        mov eax, ebx
        shr eax, 4
.17:
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
        jne short .1
        inc ebx
.1:
        cmp dword [esi], byte 0
        je short .3
        add esi, byte 4
        cmp dword [esi], byte 0
        je short .3
.2:
        mov eax, ebx
        mov edx, dword [esi]
        call stpcpy_
        add esi, byte 4
        mov edx, eax
        mov ebx, eax
        cmp dword [esi], byte 0
        je short .3
        lea ebx, [byte eax+01h]
        mov byte [eax], 20h
        jmp short .2
.3:
        test ecx, ecx
        je short .4
        mov byte [ebx], 0
        leave
        pop esi
        ret
.4:
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
        jne short .1
        mov al, 4
        xor ecx, ecx
        jmp short .2
.1:
        xor al, al
.2:
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
        jb short .3
        mov ah, 4Dh
        int 21h
.3:
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
        jne short .1
        mov eax, edx
        pop edi
        pop esi
        ret
.1:
        mov ebx, ecx
        sub ebx, esi
        mov dword [eax], edx
        cmp ebx, 93h
        jb short .2
        mov ebx, 92h
.2:
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
        je short .2
        cmp byte [byte esi+01h], 3Ah
        jne short .2
        test ebx, ebx
        je short .1
        mov dword [ebx], edx
        mov al, byte [esi]
        mov byte [byte edx+01h], 3Ah
        mov byte [byte edx+02h], 0
        mov byte [edx], al
        add edx, byte 3
.1:
        add esi, byte 2
        jmp short .3
.2:
        test ebx, ebx
        je short .3
        mov dword [ebx], edx
        mov byte [edx], 0
        inc edx
.3:
        mov ebp, esi
        mov ebx, esi
.4:
        xor edi, edi
.5:
        mov al, byte [esi]
        test al, al
        je short .8
        cmp al, 2Eh
        jne short .6
        mov edi, esi
        inc esi
        jmp short .5
.6:
        inc esi
        cmp al, 5Ch
        je short .7
        cmp al, 2Fh
        jne short .5
.7:
        mov ebp, esi
        jmp short .4
.8:
        mov eax, ecx
        mov ecx, ebp
        call pcopy_
        mov edx, eax
        test edi, edi
        jne short .9
        mov edi, esi
.9:
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
