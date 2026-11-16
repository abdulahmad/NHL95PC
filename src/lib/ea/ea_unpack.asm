; RefPack unpack.
bits 32
%include "hockey.inc"
section s_97300 progbits alloc exec nowrite align=1
extern __STOSB, str_Copyright, str_UnpackINVALIDPACKCODE, dword_EDEE0, dword_EDEE4, UnpackSrcPtr, dword_EDEEC, UnpackPairState
extern dword_EDEF4, dword_EDEF8, FatalError, off_D3088, off_D308C, strncmp_, bcopy
global SkipCopyrightHeader, UnpackReadBE, PackedTypeOf, UnpackedSize, HuffGetBits, HuffGetLength, UnpackHuffman, ExpandBytePair
global UnpackBytePair, UnpackDelta, UnpackRunLength, UnpackRefPack, unpack, UnpackTo, UnpackQuiet
SkipCopyrightHeader:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, eax
        mov ebx, 9
        mov edx, str_Copyright
        call strncmp_
        test eax, eax
        jne short .1
        mov edi, esi
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        inc ecx
        add esi, ecx
.1:
        mov eax, esi
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
UnpackReadBE:
        push ebx
        push ecx
        xor ebx, ebx
.1:
        dec edx
        cmp edx, byte 0FFFFFFFFh
        je short .2
        xor ecx, ecx
        mov cl, byte [eax]
        shl ebx, 8
        inc eax
        add ebx, ecx
        jmp short .1
.2:
        mov eax, ebx
        pop ecx
        pop ebx
        ret
        db 090h
PackedTypeOf:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        call SkipCopyrightHeader
        mov edx, eax
        mov ebx, eax
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        cmp ecx, 0FBh
        jne near .30
        xor eax, eax
        mov al, byte [edx]
        and eax, 0FEh
        cmp eax, byte 44h
        jb near .4
        jbe near .24
        cmp eax, byte 72h
        jb short .2
        jbe near .15
        cmp eax, byte 78h
        jb short .1
        jbe near .8
        cmp eax, byte 7Ah
        jb near .29
        jbe near .17
        cmp eax, 0C0h
        je near .20
        jmp near .29
.1:
        cmp eax, byte 74h
        jb near .29
        jbe near .16
        cmp eax, byte 76h
        je near .26
        jmp near .29
.2:
        cmp eax, byte 6Ah
        jb short .3
        jbe near .20
        cmp eax, byte 6Eh
        jb near .29
        jbe near .13
        cmp eax, byte 70h
        je near .14
        mov edx, 12h
        jmp near .32
.3:
        cmp eax, byte 46h
        jb near .29
        jbe near .12
        cmp eax, byte 66h
        je near .25
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cmp eax, byte 2Ch
        jb short .6
        jbe near .23
        cmp eax, byte 32h
        jb short .5
        jbe near .10
        cmp eax, byte 34h
        jb near .29
        jbe near .11
        cmp eax, byte 42h
        je near .24
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.5:
        cmp eax, byte 2Eh
        jb near .29
        jbe near .22
        cmp eax, byte 30h
        je short .9
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.6:
        cmp eax, byte 26h
        jb short .7
        jbe near .21
        cmp eax, byte 28h
        jb near .29
        jbe near .22
        cmp eax, byte 2Ah
        je near .21
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        cmp eax, byte 10h
        jne near .29
.8:
        mov edx, 0Ch
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.9:
        mov edx, 7
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.10:
        mov edx, 9
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.11:
        mov edx, 0Ah
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.12:
        mov edx, 5
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.13:
        mov edx, 1
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.14:
        mov edx, 11h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.15:
        mov edx, 0Bh
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.16:
        mov edx, 10h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.17:
        mov edx, 2
        mov ecx, 5
        test ah, 1
        je short .18
        mov ecx, 8
.18:
        lea eax, [ebx+ecx]
        cmp byte [eax], 1
        jne short .19
        cmp byte [byte eax+01h], 1
        jne short .19
        mov edx, 3
.19:
        add ebx, ecx
        cmp byte [ebx], 2
        jne near .32
        cmp byte [byte ebx+01h], 1
        jne near .32
        mov edx, 4
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.20:
        mov edx, 1Fh
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.21:
        mov edx, 18h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.22:
        mov edx, 1Ah
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.23:
        mov edx, 19h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.24:
        mov edx, 17h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.25:
        mov edx, 1Bh
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.26:
        mov edx, 14h
        mov ecx, 5
        test ah, 1
        je short .27
        mov ecx, 8
.27:
        lea eax, [ebx+ecx]
        cmp byte [eax], 1
        jne short .28
        cmp byte [byte eax+01h], 1
        jne short .28
        mov edx, 15h
.28:
        add ebx, ecx
        cmp byte [ebx], 2
        jne short .32
        cmp byte [byte ebx+01h], 1
        jne short .32
        mov edx, 16h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.29:
        mov edx, 12h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.30:
        xor eax, eax
        mov al, byte [edx]
        shl eax, 8
        add eax, ecx
        xor ebx, edx
        mov bl, byte [byte edx+02h]
        shl eax, 8
        add eax, ebx
        mov dl, byte [byte edx+03h]
        and edx, 0FFh
        shl eax, 8
        add eax, edx
        cmp eax, 3F3h
        jne short .31
        mov edx, 21h
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.31:
        xor edx, edx
.32:
        mov eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
UnpackedSize:
        push esi
        push edi
        mov edi, dword [byte esp+0Ch]
        mov esi, dword [byte esp+010h]
        cmp esi, byte 2
        jle short .1
        push esi
        push edi
        call dword [off_D3088]
        add esp, byte 8
        test eax, eax
        jne short .2
        mov eax, edi
        call SkipCopyrightHeader
        mov edx, eax
        sub eax, edi
        sub esi, eax
        mov eax, edx
        call PackedTypeOf
        test eax, eax
        jle short .1
        cmp eax, byte 1Eh
        jg short .1
        lea eax, [byte edx+02h]
        mov edx, 3
        call UnpackReadBE
        pop edi
        pop esi
        ret
.1:
        mov eax, esi
.2:
        pop edi
        pop esi
        ret
HuffGetBits:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, dword [dword_EDEE0]
        mov edi, dword [dword_EDEE4]
        mov ebp, dword [UnpackPairState]
        cmp eax, byte 10h
        jle short .1
        sub eax, byte 10h
        call HuffGetBits
        mov edx, eax
        shl edx, 10h
        mov eax, 10h
        call HuffGetBits
        or eax, edx
        jmp short .4
.1:
        mov ecx, 20h
        sub ecx, eax
        mov edx, edi
        shr edx, cl
        mov dword [esp], edx
        mov cl, al
        shl edi, cl
        sub esi, eax
        cmp esi, byte 10h
        jge short .3
        mov eax, esi
        neg eax
        add eax, byte 18h
.2:
        xor ebx, ebx
        mov bl, byte [byte ebp+00h]
        inc ebp
        mov cl, al
        shl ebx, cl
        or edi, ebx
        sub eax, byte 8
        add esi, byte 8
        cmp eax, byte 8
        jg short .2
.3:
        mov eax, dword [esp]
        mov dword [dword_EDEE0], esi
        mov dword [dword_EDEE4], edi
        mov dword [UnpackPairState], ebp
.4:
        mov esi, dword [dword_EDEE0]
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
HuffGetLength:
        push ebx
        push edx
        mov ebx, 2
        mov edx, 1
.1:
        add ebx, ebx
        inc edx
        mov eax, 1
        call HuffGetBits
        test eax, eax
        je short .1
        mov eax, edx
        call HuffGetBits
        add eax, ebx
        sub eax, byte 4
        pop edx
        pop ebx
        ret
UnpackHuffman:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 2D8h
        mov dword [dword esp+02C8h], edx
        mov dword [UnpackPairState], eax
        mov dword [UnpackSrcPtr], edx
        xor edx, edx
        mov dword [dword esp+02C4h], edx
        test eax, eax
        je near .19
        mov dl, byte [eax]
        mov dword [dword esp+02CCh], edx
        inc eax
        mov dword [UnpackPairState], eax
        xor ecx, ecx
        mov cl, byte [eax]
        shl edx, 8
        inc eax
        mov dword [UnpackPairState], eax
        add edx, ecx
        mov dword [dword esp+02CCh], edx
        test byte [dword esp+02CDh], 1
        je short .1
        add dword [UnpackPairState], byte 3
.1:
        and byte [dword esp+02CDh], 0FEh
        xor esi, esi
        mov dword [dword_EDEE0], esi
        mov dword [dword_EDEE4], esi
        xor eax, eax
        call HuffGetBits
        mov eax, 18h
        call HuffGetBits
        mov dword [dword esp+02C4h], eax
        test ebx, ebx
        je near .19
        mov eax, 8
        call HuffGetBits
        mov byte [dword esp+02D4h], al
        mov edi, 1
        xor edx, edx
        mov dword [dword esp+02C0h], 0Fh
        mov ebx, 4
        xor ebp, ebp
.2:
        add edx, edx
        mov eax, edx
        sub eax, esi
        mov dword [dword esp+ebx+0240h], eax
        call HuffGetLength
        mov dword [dword esp+02D0h], eax
        mov dword [dword esp+ebx+0200h], eax
        add esi, eax
        add edx, eax
        mov ecx, ebp
        test eax, eax
        je short .3
        mov cl, byte [dword esp+02C0h]
        mov eax, edx
        shl eax, cl
        mov ecx, eax
        and ecx, 0FFFFh
.3:
        mov dword [dword esp+ebx+0280h], ecx
        dec dword [dword esp+02C0h]
        add ebx, byte 4
        inc edi
        cmp ebp, dword [dword esp+02D0h]
        je short .2
        test ecx, ecx
        jne short .2
        dec edi
        mov ecx, 100h
        xor edx, edx
        mov eax, esp
        call __STOSB
        mov edx, 0FFFFFFFFh
        xor ebx, ebx
        test esi, esi
        jle short .8
        xor ebp, ebp
        mov cl, 1
.4:
        call HuffGetLength
        inc eax
        je short .7
.5:
        inc edx
        and edx, 0FFh
        cmp byte [esp+edx], 0
        jne short .6
        dec eax
.6:
        test eax, eax
        jne short .5
.7:
        mov byte [esp+edx], cl
        mov byte [dword esp+ebx+0100h], dl
        inc ebx
        cmp ebx, esi
        jl short .4
.8:
        mov esi, 4
        mov ebp, 1
.9:
        mov ecx, dword [dword_EDEE4]
        shr ecx, 10h
        and ecx, 0FFFFh
        mov edx, ebp
        mov eax, esi
        lea ebx, [nosplit edi*4+00h]
        cmp ecx, dword [dword esp+0284h]
        jb short .11
.10:
        cmp eax, ebx
        jge short .11
        add eax, byte 4
        inc edx
        cmp ecx, dword [dword esp+eax+0280h]
        jae short .10
.11:
        mov eax, edx
        call HuffGetBits
        sub eax, dword [dword esp+edx*4+0240h]
        mov dl, byte [dword esp+eax+0100h]
        cmp dl, byte [dword esp+02D4h]
        je short .12
        mov eax, dword [UnpackSrcPtr]
        mov byte [eax], dl
        inc eax
        mov dword [UnpackSrcPtr], eax
        jmp short .9
.12:
        call HuffGetLength
        test eax, eax
        je short .14
        mov ebx, dword [UnpackSrcPtr]
        mov bl, byte [byte ebx-01h]
.13:
        dec eax
        cmp eax, byte 0FFFFFFFFh
        je short .9
        mov edx, dword [UnpackSrcPtr]
        mov byte [edx], bl
        inc edx
        mov dword [UnpackSrcPtr], edx
        jmp short .13
.14:
        mov eax, ebp
        call HuffGetBits
        test eax, eax
        jne short .15
        mov eax, 8
        call HuffGetBits
        mov edx, dword [UnpackSrcPtr]
        mov byte [edx], al
        inc edx
        mov dword [UnpackSrcPtr], edx
        jmp near .9
.15:
        mov eax, dword [dword esp+02C8h]
        add eax, dword [dword esp+02C4h]
        mov esi, dword [dword esp+02CCh]
        cmp esi, 32FBh
        jne short .17
        xor ebx, ebx
        mov edx, dword [dword esp+02C8h]
        mov dword [UnpackSrcPtr], edx
        mov ecx, eax
        cmp eax, edx
        jbe short .19
.16:
        mov eax, dword [UnpackSrcPtr]
        xor edx, edx
        mov dl, byte [eax]
        add ebx, edx
        mov byte [eax], bl
        inc eax
        mov dword [UnpackSrcPtr], eax
        cmp ecx, eax
        ja short .16
        jmp short .19
.17:
        cmp esi, 34FBh
        jne short .19
        xor ebx, ebx
        xor edx, edx
        mov ecx, dword [dword esp+02C8h]
        mov dword [UnpackSrcPtr], ecx
        mov esi, eax
        cmp eax, ecx
        jbe short .19
.18:
        mov eax, dword [UnpackSrcPtr]
        xor ecx, ecx
        mov cl, byte [eax]
        add ebx, ecx
        add edx, ebx
        mov byte [eax], dl
        inc eax
        mov dword [UnpackSrcPtr], eax
        cmp esi, eax
        ja short .18
.19:
        mov eax, dword [dword esp+02C4h]
        add esp, 2D8h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
ExpandBytePair:
        push ebx
        push edx
.1:
        xor edx, edx
        mov dl, al
        mov ebx, dword [dword_EDEF8]
        cmp byte [edx+ebx], 0
        je short .2
        mov eax, dword [dword_EDEEC]
        mov al, byte [edx+eax]
        and eax, 0FFh
        call ExpandBytePair
        mov eax, dword [dword_EDEF4]
        mov al, byte [edx+eax]
        jmp short .1
.2:
        mov edx, dword [UnpackSrcPtr]
        mov byte [edx], al
        inc edx
        mov dword [UnpackSrcPtr], edx
        pop edx
        pop ebx
        ret
UnpackBytePair:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 304h
        mov ebx, eax
        mov dword [UnpackSrcPtr], edx
        xor edx, edx
        mov dword [dword esp+0300h], edx
        lea edx, [dword esp+0200h]
        mov dword [dword_EDEF8], edx
        lea edx, [dword esp+0100h]
        mov dword [dword_EDEEC], edx
        mov edx, esp
        mov dword [dword_EDEF4], edx
        test eax, eax
        je near .8
        xor edx, edx
        mov dl, byte [eax]
        lea ebx, [byte eax+01h]
        xor eax, eax
        mov al, byte [ebx]
        shl edx, 8
        inc ebx
        add edx, eax
        cmp edx, 47FBh
        jne short .1
        add ebx, byte 3
.1:
        xor eax, eax
        mov al, byte [ebx]
        mov dword [dword esp+0300h], eax
        inc ebx
        xor edx, edx
        mov dl, byte [ebx]
        shl eax, 8
        inc ebx
        add eax, edx
        mov dword [dword esp+0300h], eax
        xor eax, eax
        mov al, byte [ebx]
        mov edx, dword [dword esp+0300h]
        shl edx, 8
        inc ebx
        add edx, eax
        mov dword [dword esp+0300h], edx
        xor edx, edx
.2:
        mov eax, dword [dword_EDEF8]
        mov byte [edx+eax], 0
        inc edx
        cmp edx, 100h
        jl short .2
        xor edx, edx
        mov dl, byte [ebx]
        inc ebx
        mov byte [edx+eax], 1
        movzx ebp, byte [ebx]
        xor eax, eax
        inc ebx
        test ebp, ebp
        jle short .4
.3:
        xor edx, edx
        mov dl, byte [ebx]
        lea esi, [byte ebx+01h]
        mov ecx, dword [dword_EDEEC]
        add ebx, byte 2
        lea edi, [ecx+edx]
        mov cl, byte [esi]
        mov byte [edi], cl
        mov esi, ebx
        mov edi, dword [dword_EDEF4]
        inc ebx
        mov cl, byte [esi]
        mov byte [edx+edi], cl
        mov ecx, dword [dword_EDEF8]
        mov byte [ecx+edx], 0FFh
        inc eax
        cmp eax, ebp
        jl short .3
.4:
        mov dword [UnpackPairState], ebx
.5:
        mov ebx, dword [UnpackPairState]
        xor edx, edx
        mov dl, byte [ebx]
        mov eax, dword [dword_EDEF8]
        inc ebx
        mov al, byte [edx+eax]
        test al, al
        jne short .6
        mov eax, dword [UnpackSrcPtr]
        mov byte [eax], dl
        inc eax
        mov dword [UnpackSrcPtr], eax
        jmp short .4
.6:
        mov dword [UnpackPairState], ebx
        jge short .7
        mov eax, dword [dword_EDEEC]
        mov al, byte [edx+eax]
        and eax, 0FFh
        call ExpandBytePair
        mov eax, dword [dword_EDEF4]
        mov al, byte [edx+eax]
        and eax, 0FFh
        call ExpandBytePair
        jmp short .5
.7:
        xor edx, edx
        mov dl, byte [ebx]
        inc ebx
        test edx, edx
        je short .8
        mov eax, dword [UnpackSrcPtr]
        mov byte [eax], dl
        inc eax
        mov dword [UnpackSrcPtr], eax
        jmp short .4
.8:
        mov eax, dword [dword esp+0300h]
        mov dword [UnpackPairState], ebx
        add esp, 304h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
UnpackDelta:
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, eax
        mov eax, edx
        xor edi, edi
        test ebx, ebx
        je short .4
        xor ecx, ecx
        mov cl, byte [ebx]
        lea edx, [byte ebx+01h]
        xor ebx, ebx
        mov bl, byte [edx]
        shl ecx, 8
        inc edx
        add ecx, ebx
        cmp ecx, 62FBh
        jne short .1
        add edx, byte 3
        jmp short .2
.1:
        cmp ecx, 66FBh
        jne short .2
        add edx, byte 4
.2:
        movzx edi, byte [edx]
        inc edx
        xor ebx, ebx
        mov bl, byte [edx]
        shl edi, 8
        inc edx
        add edi, ebx
        xor ebx, ebx
        mov bl, byte [edx]
        shl edi, 8
        inc edx
        add edi, ebx
        lea esi, [eax+edi]
        xor ebx, ebx
        cmp eax, esi
        jae short .4
.3:
        xor ecx, ecx
        mov cl, byte [edx]
        inc edx
        add ebx, ecx
        and ebx, 0FFh
        mov byte [eax], bl
        inc eax
        cmp eax, esi
        jb short .3
.4:
        mov eax, edi
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 090h
UnpackRunLength:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        xor ebx, ebx
        mov dword [esp], ebx
        test eax, eax
        je near .10
        mov bl, byte [eax]
        inc eax
        movzx esi, byte [eax]
        shl ebx, 8
        inc eax
        add ebx, esi
        cmp ebx, 7BFBh
        jne short .1
        add eax, byte 3
.1:
        xor ebx, ebx
        mov bl, byte [eax]
        mov dword [esp], ebx
        inc eax
        movzx esi, byte [eax]
        shl ebx, 8
        inc eax
        add ebx, esi
        mov dword [esp], ebx
        xor ebx, ebx
        mov bl, byte [eax]
        mov esi, dword [esp]
        shl esi, 8
        inc eax
        add esi, ebx
        mov dword [esp], esi
        movzx ebp, byte [eax]
        inc eax
        xor ebx, ebx
        mov bl, byte [eax]
        inc eax
        dec ebx
        mov dword [byte esp+04h], ebx
.2:
        mov ebx, dword [byte esp+04h]
        movsx edi, byte [eax]
        inc eax
        test ebx, ebx
        je short .4
.3:
        movzx esi, byte [eax]
        shl edi, 8
        inc eax
        add edi, esi
        dec ebx
        jne short .3
.4:
        test edi, edi
        jge short .6
        mov ebx, edi
        neg ebx
        imul ebx, ebp
.5:
        mov cl, byte [eax]
        mov byte [edx], cl
        inc eax
        inc edx
        dec ebx
        je short .9
        jmp short .5
.6:
        je short .9
        lea esi, [byte edi+01h]
.7:
        mov ebx, ebp
.8:
        mov cl, byte [eax]
        mov byte [edx], cl
        inc eax
        inc edx
        dec ebx
        jne short .8
        sub eax, ebp
        dec esi
        jne short .7
        add eax, ebp
.9:
        test edi, edi
        jne short .2
.10:
        mov eax, dword [esp]
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        db 090h
UnpackRefPack:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ecx, eax
        mov eax, edx
        mov esi, ebx
        xor edx, edx
        mov dword [esp], edx
        test ecx, ecx
        je near .18
        xor ebx, ebx
        mov bl, byte [ecx]
        lea edx, [byte ecx+01h]
        xor ecx, ecx
        mov cl, byte [edx]
        shl ebx, 8
        inc edx
        add ebx, ecx
        test bh, 1
        je short .1
        add edx, byte 3
.1:
        xor ebx, ebx
        mov bl, byte [edx]
        mov dword [esp], ebx
        inc edx
        xor ecx, ecx
        mov cl, byte [edx]
        shl ebx, 8
        inc edx
        add ebx, ecx
        mov dword [esp], ebx
        xor ebx, ebx
        mov bl, byte [edx]
        mov ecx, dword [esp]
        shl ecx, 8
        inc edx
        add ecx, ebx
        mov dword [esp], ecx
        test esi, esi
        je near .18
.2:
        movzx esi, byte [edx]
        inc edx
        mov ecx, esi
        and ecx, byte 3
        test si, 80h
        jne short .6
        movzx edi, byte [edx]
        mov ebx, ecx
        inc edx
        test ecx, ecx
        je short .4
.3:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        jne short .3
.4:
        mov ebx, esi
        and ebx, byte 60h
        shl ebx, 3
        add ebx, edi
        inc ebx
        mov ecx, eax
        sub ecx, ebx
        mov ebx, ecx
        and esi, byte 1Ch
        shr esi, 2
        inc esi
        mov cl, byte [ecx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
.5:
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        dec esi
        je short .2
        jmp short .5
.6:
        test si, 40h
        jne short .10
        movzx edi, byte [edx]
        inc edx
        movzx ebp, byte [edx]
        mov ebx, edi
        shr ebx, 6
        inc edx
        test ebx, ebx
        je short .8
.7:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        jne short .7
.8:
        and edi, byte 3Fh
        shl edi, 8
        add edi, ebp
        lea ebx, [byte edi+01h]
        mov ecx, eax
        sub ecx, ebx
        mov ebx, ecx
        and esi, byte 3Fh
        inc esi
        mov cl, byte [ecx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
.9:
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        dec esi
        je near .2
        jmp short .9
.10:
        test si, 20h
        jne near .14
        xor ebx, ebx
        mov bl, byte [edx]
        mov dword [byte esp+08h], ebx
        inc edx
        xor ebx, ebx
        mov bl, byte [edx]
        mov dword [byte esp+04h], ebx
        inc edx
        movzx edi, byte [edx]
        mov ebx, ecx
        inc edx
        test ecx, ecx
        je short .12
.11:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        jne short .11
.12:
        mov ebx, esi
        and ebx, byte 10h
        shr ebx, 4
        shl ebx, 10h
        mov ecx, dword [byte esp+08h]
        shl ecx, 8
        add ebx, ecx
        add ebx, dword [byte esp+04h]
        inc ebx
        mov ecx, eax
        sub ecx, ebx
        mov ebx, ecx
        mov ecx, esi
        and ecx, byte 0Ch
        shr ecx, 2
        shl ecx, 8
        add ecx, edi
        lea esi, [byte ecx+01h]
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
.13:
        mov cl, byte [ebx]
        mov byte [eax], cl
        inc ebx
        inc eax
        dec esi
        je near .2
        jmp short .13
.14:
        cmp esi, 0FCh
        jae short .16
        mov ebx, esi
        and ebx, byte 1Fh
        inc ebx
.15:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        je near .2
        jmp short .15
.16:
        mov ebx, ecx
        test ecx, ecx
        je short .18
.17:
        mov cl, byte [edx]
        mov byte [eax], cl
        inc edx
        inc eax
        dec ebx
        jne short .17
.18:
        mov eax, dword [esp]
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
unpack:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, dword [byte esp+014h]
        mov esi, dword [byte esp+018h]
        mov ebp, dword [byte esp+01Ch]
        push ebp
        push esi
        push edi
        call dword [off_D308C]
        add esp, byte 0Ch
        test eax, eax
        je short .1
        mov edi, eax
        jmp near .14
.1:
        push ebp
        push edi
        call UnpackedSize
        add esp, byte 8
        mov dword [esp], eax
        mov eax, edi
        call SkipCopyrightHeader
        mov ecx, eax
        mov ebp, eax
        xor edi, edi
        cmp byte [byte eax+01h], 0FBh
        jne near .13
        mov al, byte [ecx]
        and al, 0FEh
        cmp al, 60h
        jb short .4
        jbe near .9
        cmp al, 6Ah
        jb short .3
        jbe near .10
        cmp al, 72h
        jb short .2
        jbe near .9
        cmp al, 7Ah
        jb near .12
        cmp al, 7Bh
        jbe near .11
        jmp near .12
.2:
        cmp al, 6Eh
        je near .10
        jmp near .12
.3:
        cmp al, 62h
        jb near .12
        jbe near .9
        cmp al, 66h
        je near .9
        jmp near .12
.4:
        cmp al, 32h
        jb short .5
        jbe short .7
        cmp al, 34h
        jb near .12
        jbe short .7
        cmp al, 46h
        je short .8
        jmp near .12
.5:
        cmp al, 10h
        jb near .12
        jbe short .6
        cmp al, 30h
        je short .7
        jmp short .12
.6:
        mov ebx, 1
        mov edx, esi
        mov eax, ecx
        call UnpackRefPack
        mov edi, eax
        jmp short .13
.7:
        mov ebx, 1
        mov edx, esi
        mov eax, ebp
        call UnpackHuffman
        mov edi, eax
        jmp short .13
.8:
        mov edx, esi
        mov eax, ecx
        call UnpackBytePair
        mov edi, eax
        jmp short .13
.9:
        mov edx, esi
        mov eax, ebp
        call UnpackDelta
        mov edi, eax
        jmp short .13
.10:
        mov edx, dword [esp]
        push edx
        push esi
        lea eax, [byte ebp+05h]
        push eax
        call bcopy
        add esp, byte 0Ch
        mov edi, dword [esp]
        jmp short .13
.11:
        mov edx, esi
        mov eax, ecx
        call UnpackRunLength
        mov dword [esp], eax
        jmp short .13
.12:
        cmp dword [byte esp+020h], byte 0
        je short .13
        xor eax, eax
        mov al, byte [byte ebp+00h]
        push eax
        push str_UnpackINVALIDPACKCODE
        call FatalError
        add esp, byte 8
.13:
        test edi, edi
        jne short .14
        mov ecx, dword [esp]
        push ecx
        push esi
        push ebp
        call bcopy
        add esp, byte 0Ch
        mov edi, dword [esp]
.14:
        mov eax, edi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
UnpackTo:
        push byte 1
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call unpack
        add esp, byte 10h
        ret
        db 08Bh,0C0h
UnpackQuiet:
        push byte 0
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call unpack
        add esp, byte 10h
        ret
