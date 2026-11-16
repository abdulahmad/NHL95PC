; Small helpers from the EA libraries.
bits 32
%include "hockey.inc"
section s_9BA18 progbits alloc exec nowrite align=1
extern __FDFS, byte_C4B6C, ScanBitMasks, memset_, off_D566C, tolower_
global ScanFormat, ScanParseSpec, ScanSkipSpace, ScanStoreCount, ScanChars, ScanStoreInt, ScanBuildCharSet, ScanCharSet
global ScanFloatField, ScanIntegerField, HexDigitValue, ScanGetCharWidth
ScanFormat:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov dword [esp], edx
        mov edi, ebx
        mov ah, byte [byte eax+010h]
        xor edx, edx
        xor ebp, ebp
        and ah, 0FDh
        mov dword [byte esp+04h], edx
        mov byte [byte esi+010h], ah
.1:
        mov ebx, dword [esp]
        lea ecx, [byte ebx+01h]
        mov dword [esp], ecx
        mov bl, byte [ebx]
        and ebx, 0FFh
        je near .29
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short .2
        mov eax, esi
        call ScanSkipSpace
        add ebp, eax
        jmp near .28
.2:
        cmp ebx, byte 25h
        je short .5
        mov eax, esi
        call dword [esi]
        cmp eax, ebx
        je short .4
.3:
        test byte [byte esi+010h], 2
        jne near .29
        mov edx, esi
        call dword [byte esi+04h]
        jmp near .29
.4:
        inc ebp
        jmp near .28
.5:
        mov eax, ecx
        mov edx, esi
        call ScanParseSpec
        xor ebx, ebx
        mov dword [esp], eax
        mov bl, byte [eax]
        mov edx, eax
        test ebx, ebx
        je short .6
        lea edx, [byte eax+01h]
        mov dword [esp], edx
.6:
        cmp ebx, byte 65h
        jb short .10
        cmp ebx, byte 67h
        jbe near .21
        cmp ebx, byte 70h
        jb short .8
        jbe near .20
        cmp ebx, byte 75h
        jb short .7
        jbe near .19
        cmp ebx, byte 78h
        je near .20
        jmp near .28
.7:
        cmp ebx, byte 73h
        je near .22
        jmp near .28
.8:
        cmp ebx, byte 6Eh
        jb short .9
        jbe near .26
        jmp near .18
.9:
        cmp ebx, byte 69h
        je short .17
        jmp near .28
.10:
        cmp ebx, byte 58h
        jb short .12
        jbe near .20
        cmp ebx, byte 63h
        jb short .11
        jbe near .24
        jmp short .14
.11:
        cmp ebx, byte 5Bh
        je near .23
        jmp near .28
.12:
        cmp ebx, byte 45h
        jb short .13
        jbe short .21
        cmp ebx, byte 47h
        je short .21
        jmp near .28
.13:
        cmp ebx, byte 25h
        je near .27
        jmp near .28
.14:
        mov ebx, 0Ah
.15:
        mov ecx, 1
        mov eax, esi
        mov edx, edi
.16:
        call ScanIntegerField
        jmp short .25
.17:
        mov ecx, 1
        mov eax, esi
        mov edx, edi
        xor ebx, ebx
        jmp short .16
.18:
        mov ebx, 8
        jmp short .15
.19:
        mov ebx, 0Ah
        mov eax, esi
        mov edx, edi
        xor ecx, ecx
        jmp short .16
.20:
        mov ebx, 10h
        jmp short .15
.21:
        mov eax, esi
        mov edx, edi
        call ScanFloatField
        jmp short .25
.22:
        mov eax, esi
        mov edx, edi
        call ScanChars
        jmp short .25
.23:
        mov ebx, esp
        mov eax, esi
        mov edx, edi
        call ScanCharSet
        jmp short .25
.24:
        mov eax, esi
        mov edx, edi
        call ScanStoreCount
.25:
        test eax, eax
        jle short .29
        mov dh, byte [byte esi+010h]
        add ebp, eax
        test dh, 1
        je short .28
        inc dword [byte esp+04h]
        jmp short .28
.26:
        mov eax, esi
        mov edx, edi
        mov ebx, ebp
        call ScanStoreInt
        jmp short .28
.27:
        mov eax, esi
        call dword [esi]
        cmp eax, ebx
        jne near .3
.28:
        test byte [byte esi+010h], 2
        je near .1
        mov eax, dword [esp]
        cmp byte [eax], 25h
        jne short .29
        lea edx, [byte eax+01h]
        mov dword [esp], edx
        mov eax, edx
        mov edx, esi
        call ScanParseSpec
        mov dword [esp], eax
        cmp byte [eax], 6Eh
        jne short .29
        mov eax, esi
        mov edx, edi
        mov ebx, ebp
        call ScanStoreInt
.29:
        cmp dword [byte esp+04h], byte 0
        jne short .30
        test byte [byte esi+010h], 2
        je short .30
        mov eax, 0FFFFFFFFh
        jmp short .31
.30:
        mov eax, dword [byte esp+04h]
.31:
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
ScanParseSpec:
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov ebx, edx
        mov dl, byte [byte edx+010h]
        or dl, 1
        mov dword [byte ebx+0Ch], 0FFFFFFFFh
        mov dh, dl
        mov byte [byte ebx+010h], dl
        and dh, 3
        mov byte [byte ebx+010h], dh
        cmp byte [eax], 2Ah
        jne short .1
        mov ch, byte [byte ebx+010h]
        and ch, 0FEh
        inc eax
        mov byte [byte ebx+010h], ch
.1:
        xor edx, edx
        mov dl, byte [eax]
        mov dword [esp], edx
        mov dl, byte [esp]
        inc dl
        and edx, 0FFh
        test byte [dword edx+byte_C4B6C], 20h
        je short .3
        xor edx, edx
.2:
        imul edx, byte 0Ah
        mov esi, dword [esp]
        sub esi, byte 30h
        inc eax
        add edx, esi
        movzx esi, byte [eax]
        mov dword [esp], esi
        mov cl, byte [esp]
        inc cl
        movzx esi, cl
        test byte [dword esi+byte_C4B6C], 20h
        jne short .2
        mov dword [byte ebx+0Ch], edx
.3:
        mov cl, byte [eax]
        lea edx, [byte eax+01h]
        cmp cl, 4Eh
        jne short .4
        or byte [byte ebx+010h], 8
        jmp short .5
.4:
        cmp cl, 46h
        jne short .6
        or byte [byte ebx+010h], 4
.5:
        mov eax, edx
.6:
        mov cl, byte [eax]
        lea edx, [byte eax+01h]
        cmp cl, 68h
        jb short .7
        jbe short .8
        cmp cl, 6Ch
        jb short .11
        jbe short .9
        cmp cl, 77h
        je short .9
        jmp short .11
.7:
        cmp cl, 4Ch
        je short .10
        jmp short .11
.8:
        mov cl, byte [byte ebx+010h]
        or cl, 10h
        mov eax, edx
        mov byte [byte ebx+010h], cl
        jmp short .11
.9:
        mov dl, byte [byte ebx+010h]
        or dl, 20h
        inc eax
        mov byte [byte ebx+010h], dl
        jmp short .11
.10:
        mov ch, byte [byte ebx+010h]
        or ch, 40h
        mov eax, edx
        mov byte [byte ebx+010h], ch
.11:
        add esp, byte 4
        pop esi
        pop ecx
        pop ebx
        ret
ScanSkipSpace:
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        xor ecx, ecx
.1:
        mov eax, ebx
        call dword [ebx]
        mov esi, eax
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short .2
        inc ecx
        jmp short .1
.2:
        test byte [byte ebx+010h], 2
        jne short .3
        mov eax, esi
        mov edx, ebx
        call dword [byte ebx+04h]
.3:
        mov eax, ecx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
ScanStoreCount:
        push ebx
        push ecx
        push esi
        push edi
        push es
        mov ebx, eax
        test byte [byte eax+010h], 1
        je short .3
        mov cl, byte [byte ebx+010h]
        test cl, 4
        je short .1
        mov edi, dword [edx]
        add edi, byte 8
        mov dword [edx], edi
        les ecx, [byte edi-08h]
        jmp short .3
.1:
        test cl, 8
        je short .2
        mov esi, dword [edx]
        add esi, byte 4
        mov eax, ds
        mov dword [edx], esi
        mov es, eax
        mov ecx, dword [byte esi-04h]
        jmp short .3
.2:
        mov ecx, dword [edx]
        add ecx, byte 4
        mov eax, ds
        mov dword [edx], ecx
        mov es, eax
        mov ecx, dword [byte ecx-04h]
.3:
        mov edx, dword [byte ebx+0Ch]
        xor esi, esi
        cmp edx, byte 0FFFFFFFFh
        jne short .4
        mov edx, 1
.4:
        test edx, edx
        jle short .6
        mov eax, ebx
        call dword [ebx]
        test byte [byte ebx+010h], 2
        jne short .6
        inc esi
        dec edx
        test byte [byte ebx+010h], 1
        je short .4
        test byte [byte ebx+010h], 20h
        je short .5
        db 066h,026h,089h,01h                   ; insn: mov [es:ecx],ax
        add ecx, byte 2
        jmp short .4
.5:
        mov byte [es:ecx], al
        inc ecx
        jmp short .4
.6:
        mov eax, esi
        pop es
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
ScanChars:
        push ebx
        push ecx
        push esi
        push edi
        push es
        sub esp, byte 4
        mov ebx, eax
        test byte [byte eax+010h], 20h
        je short .1
        mov byte [esp], 2
        jmp short .2
.1:
        test byte [byte ebx+010h], 10h
        mov byte [esp], 1
.2:
        mov al, byte [byte ebx+010h]
        test al, 1
        je short .5
        test al, 4
        je short .3
        mov edi, dword [edx]
        add edi, byte 8
        mov dword [edx], edi
        les ecx, [byte edi-08h]
        jmp short .5
.3:
        test al, 8
        je short .4
        mov esi, dword [edx]
        add esi, byte 4
        mov dword [edx], esi
        mov edx, ds
        mov es, edx
        mov ecx, dword [byte esi-04h]
        jmp short .5
.4:
        mov ecx, dword [edx]
        add ecx, byte 4
        mov dword [edx], ecx
        mov edx, ds
        mov es, edx
        mov ecx, dword [byte ecx-04h]
.5:
        xor esi, esi
.6:
        mov eax, ebx
        call dword [ebx]
        mov edx, eax
        inc al
        movzx edi, al
        test byte [dword edi+byte_C4B6C], 2
        je short .7
        inc esi
        jmp short .6
.7:
        test byte [byte ebx+010h], 2
        je short .8
        xor esi, esi
        jmp short .14
.8:
        mov edi, dword [byte ebx+0Ch]
        lea eax, [byte edi-01h]
        mov dword [byte ebx+0Ch], eax
        test edi, edi
        je short .13
.9:
        mov al, byte [byte ebx+010h]
        inc esi
        test al, 1
        je short .12
        cmp byte [esp], 1
        jne short .10
        mov byte [es:ecx], dl
        jmp short .11
.10:
        db 066h,026h,089h,011h                  ; insn: mov [es:ecx],dx
.11:
        xor edx, edx
        mov dl, byte [esp]
        add ecx, edx
.12:
        mov eax, ebx
        call ScanGetCharWidth
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .14
        inc al
        movzx edi, al
        test byte [dword edi+byte_C4B6C], 2
        je short .9
.13:
        mov eax, edx
        mov edx, ebx
        call dword [byte ebx+04h]
.14:
        test byte [byte ebx+010h], 1
        je short .16
        test esi, esi
        jle short .16
        cmp byte [esp], 1
        jne short .15
        mov byte [es:ecx], 0
        jmp short .16
.15:
        db 066h,026h,0C7h,01h,00h,00h           ; insn: mov word [es:ecx],0
.16:
        mov eax, esi
        add esp, byte 4
        jmp near ScanStoreCount+080h
ScanStoreInt:
        push ecx
        push esi
        push edi
        push es
        mov cl, byte [byte eax+010h]
        test cl, 1
        je short .5
        test cl, 4
        je short .1
        mov edi, dword [edx]
        add edi, byte 8
        mov dword [edx], edi
        les edx, [byte edi-08h]
        jmp short .3
.1:
        test cl, 8
        je short .2
        mov esi, dword [edx]
        add esi, byte 4
        mov ecx, ds
        mov dword [edx], esi
        mov es, ecx
        mov edx, dword [byte esi-04h]
        jmp short .3
.2:
        mov ecx, dword [edx]
        add ecx, byte 4
        mov dword [edx], ecx
        mov edx, ecx
        mov ecx, ds
        mov es, ecx
        mov edx, dword [byte edx-04h]
.3:
        mov ch, byte [byte eax+010h]
        test ch, 10h
        je short .4
        db 066h,026h,089h,01Ah                  ; insn: mov [es:edx],bx
        pop es
        pop edi
        pop esi
        pop ecx
        ret
.4:
        test ch, 20h
        mov dword [es:edx], ebx
.5:
        pop es
        pop edi
        pop esi
        pop ecx
        ret
ScanBuildCharSet:
        push ebx
        push ecx
        push esi
        mov ecx, eax
        mov esi, edx
        mov ebx, 20h
        mov eax, edx
        xor edx, edx
        call memset_
        xor eax, eax
        mov al, byte [ecx]
        inc ecx
        test eax, eax
        je short .2
.1:
        mov edx, eax
        and eax, byte 7
        sar edx, 3
        mov al, byte [dword eax+ScanBitMasks]
        or byte [edx+esi], al
        xor eax, eax
        mov al, byte [ecx]
        test eax, eax
        je short .2
        inc ecx
        cmp eax, byte 5Dh
        jne short .1
.2:
        mov eax, ecx
        pop esi
        pop ecx
        pop ebx
        ret
ScanCharSet:
        push ecx
        push esi
        push edi
        push es
        push ebp
        sub esp, byte 28h
        mov ecx, eax
        mov edi, edx
        mov eax, dword [ebx]
        cmp byte [eax], 5Eh
        sete dl
        and edx, 0FFh
        mov dword [byte esp+020h], edx
        je short .1
        inc eax
        mov dword [ebx], eax
.1:
        mov edx, esp
        mov eax, dword [ebx]
        call ScanBuildCharSet
        mov dword [ebx], eax
        mov bl, byte [byte ecx+010h]
        test bl, 1
        je short .4
        test bl, 4
        je short .2
        mov esi, dword [edi]
        add esi, byte 8
        mov dword [edi], esi
        les esi, [byte esi-08h]
        jmp short .4
.2:
        test bl, 8
        je short .3
        mov ebx, dword [edi]
        add ebx, byte 4
        mov eax, ds
        mov dword [edi], ebx
        mov es, eax
        mov esi, dword [byte ebx-04h]
        jmp short .4
.3:
        mov edx, dword [edi]
        add edx, byte 4
        mov eax, ds
        mov dword [edi], edx
        mov es, eax
        mov esi, dword [byte edx-04h]
.4:
        mov ebp, dword [byte esp+020h]
        xor edi, edi
        mov ebx, dword [byte ecx+0Ch]
        mov dword [byte esp+024h], edi
.5:
        test ebx, ebx
        jbe short .7
        mov eax, ecx
        call dword [ecx]
        mov edx, eax
        test byte [byte ecx+010h], 2
        jne short .7
        mov edi, eax
        and edx, byte 7
        sar edi, 3
        mov dl, byte [dword edx+ScanBitMasks]
        movzx edi, byte [esp+edi]
        and edx, 0FFh
        test edi, edx
        sete dl
        and edx, 0FFh
        cmp edx, ebp
        je short .6
        mov edx, ecx
        call dword [byte ecx+04h]
        jmp short .7
.6:
        inc dword [byte esp+024h]
        mov dl, byte [byte ecx+010h]
        dec ebx
        test dl, 1
        je short .5
        mov byte [es:esi], al
        inc esi
        jmp short .5
.7:
        test byte [byte ecx+010h], 1
        je short .8
        cmp dword [byte esp+024h], byte 0
        jle short .8
        mov byte [es:esi], 0
.8:
        mov eax, dword [byte esp+024h]
        add esp, byte 28h
        pop ebp
        pop es
        pop edi
        pop esi
        pop ecx
        ret
ScanFloatField:
        push ebx
        push ecx
        push esi
        push edi
        push es
        push ebp
        sub esp, byte 70h
        mov ecx, eax
        mov dword [byte esp+058h], edx
        xor edi, edi
        mov esi, esp
        mov dword [byte esp+06Ch], edi
.1:
        mov eax, ecx
        call dword [ecx]
        mov ebp, eax
        mov ebx, eax
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short .2
        inc dword [byte esp+06Ch]
        jmp short .1
.2:
        test byte [byte ecx+010h], 2
        jne near .21
        mov eax, dword [byte ecx+0Ch]
        lea edx, [byte eax-01h]
        mov dword [byte ecx+0Ch], edx
        test eax, eax
        je near .20
        cmp ebp, byte 2Bh
        je short .3
        cmp ebp, byte 2Dh
        jne short .4
.3:
        mov ebp, dword [byte esp+06Ch]
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        inc ebp
        mov ebx, eax
        mov dword [byte esp+06Ch], ebp
        cmp eax, byte 0FFFFFFFFh
        je near .21
.4:
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short .5
        cmp ebx, byte 2Eh
        jne near .20
.5:
        xor eax, eax
        mov dword [byte esp+068h], eax
        mov dword [byte esp+05Ch], eax
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        je short .8
        mov dword [byte esp+05Ch], 1
.6:
        mov byte [esi], bl
        mov al, byte [byte ecx+010h]
        inc esi
        test al, 10h
        je short .7
        imul eax, dword [byte esp+06Ah], byte 0Ah
        add ebx, eax
        sub ebx, byte 30h
        mov word [byte esp+06Ah], bx
.7:
        mov eax, ecx
        inc edi
        call ScanGetCharWidth
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je near .21
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short .6
.8:
        cmp ebx, byte 2Eh
        jne near .15
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je near .21
        cmp dword [byte esp+05Ch], byte 0
        jne short .9
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        je near .20
.9:
        inc edi
.10:
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        je short .11
        inc edi
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        jne short .10
.11:
        test byte [byte ecx+010h], 10h
        je short .14
        xor edx, edx
        mov ebp, esi
        mov dword [byte esp+064h], edx
.12:
        dec ebp
        mov al, byte [byte ebp+00h]
        cmp al, 2Eh
        je short .13
        sub al, 30h
        mov dword [byte esp+060h], 0Ah
        mov byte [byte esp+066h], al
        xor edx, edx
        mov eax, dword [byte esp+064h]
        div dword [byte esp+060h]
        mov dword [byte esp+064h], eax
        jmp short .12
.13:
        mov eax, dword [byte esp+064h]
        mov word [byte esp+068h], ax
.14:
        cmp ebx, byte 0FFFFFFFFh
        je near .21
.15:
        test byte [byte ecx+010h], 10h
        jne near .20
        cmp ebx, byte 65h
        je short .16
        cmp ebx, byte 45h
        jne near .20
.16:
        inc edi
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebp, eax
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .21
        cmp eax, byte 2Bh
        je short .17
        cmp eax, byte 2Dh
        jne short .18
.17:
        inc edi
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .21
.18:
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short .19
        xor edi, edi
        jmp short .20
.19:
        inc edi
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .21
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short .19
.20:
        mov eax, ebx
        mov edx, ecx
        call dword [byte ecx+04h]
.21:
        test edi, edi
        jle near .31
        add edi, dword [byte esp+06Ch]
        test byte [byte ecx+010h], 1
        je near .31
        mov byte [esi], 0
        test byte [byte ecx+010h], 10h
        je short .22
        cmp byte [esp], 2Dh
        jne short .23
        neg dword [byte esp+068h]
        jmp short .23
.22:
        mov eax, esp
        lea edx, [byte esp+050h]
        call dword [off_D566C]
.23:
        mov ah, byte [byte ecx+010h]
        test ah, 4
        je short .24
        mov eax, dword [byte esp+058h]
        mov ebx, dword [eax]
        add ebx, byte 8
        mov dword [eax], ebx
        les ebx, [byte ebx-08h]
        jmp short .26
.24:
        test ah, 8
        je short .25
        mov eax, dword [byte esp+058h]
        mov edx, dword [eax]
        add edx, byte 4
        mov dword [eax], edx
        mov eax, ds
        mov es, eax
        mov ebx, dword [byte edx-04h]
        jmp short .26
.25:
        mov eax, dword [byte esp+058h]
        mov ebp, dword [eax]
        add ebp, byte 4
        mov dword [eax], ebp
        mov eax, ds
        mov es, eax
        mov ebx, dword [byte ebp-04h]
.26:
        mov dh, byte [byte ecx+010h]
        test dh, 10h
        je short .27
        mov eax, dword [byte esp+068h]
        jmp short .30
.27:
        test dh, 20h
        jne short .28
        test dh, 40h
        je short .29
.28:
        mov eax, dword [byte esp+050h]
        mov dword [es:ebx], eax
        mov eax, dword [byte esp+054h]
        mov dword [byte es:ebx+04h], eax
        jmp short .31
.29:
        mov eax, dword [byte esp+050h]
        mov edx, dword [byte esp+054h]
        call __FDFS
.30:
        mov dword [es:ebx], eax
.31:
        mov eax, edi
        add esp, byte 70h
        pop ebp
        jmp near ScanStoreCount+080h
ScanIntegerField:
        push esi
        push edi
        push es
        push ebp
        sub esp, byte 10h
        mov esi, eax
        mov dword [byte esp+0Ch], edx
        mov edi, ebx
        mov dword [byte esp+04h], ecx
        xor edx, edx
        xor ebx, ebx
        xor ebp, ebp
        mov dword [byte esp+08h], edx
.1:
        mov eax, esi
        call dword [esi]
        mov edx, eax
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short .2
        inc ebp
        jmp short .1
.2:
        test byte [byte esi+010h], 2
        jne near .15
        mov eax, dword [byte esi+0Ch]
        lea ecx, [byte eax-01h]
        mov dword [byte esi+0Ch], ecx
        test eax, eax
        je near .14
        mov ecx, 2Bh
        mov eax, dword [byte esp+04h]
        mov dword [esp], ecx
        test eax, eax
        je short .4
        cmp edx, byte 2Bh
        je short .3
        cmp edx, byte 2Dh
        jne short .4
.3:
        mov dword [esp], edx
        mov eax, esi
        inc ebp
        call ScanGetCharWidth
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je near .15
.4:
        test edi, edi
        jne short .8
        cmp edx, byte 30h
        jne short .7
        mov eax, esi
        mov ebx, 1
        call ScanGetCharWidth
        mov ecx, eax
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je near .15
        cmp eax, byte 78h
        je short .5
        cmp eax, byte 58h
        jne short .6
.5:
        mov eax, esi
        add ebp, byte 2
        call ScanGetCharWidth
        xor ebx, ebx
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je near .15
        mov edi, 10h
        jmp short .11
.6:
        mov edi, 8
        jmp short .11
.7:
        mov edi, 0Ah
        jmp short .11
.8:
        cmp edi, byte 10h
        jne short .11
        cmp edx, byte 30h
        jne short .11
        mov eax, esi
        mov ebx, 1
        call ScanGetCharWidth
        mov ecx, eax
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je near .15
        cmp eax, byte 78h
        je short .9
        cmp eax, byte 58h
        jne short .11
.9:
        mov eax, esi
        add ebp, byte 2
        call ScanGetCharWidth
        xor ebx, ebx
.10:
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .15
.11:
        mov eax, edx
        call HexDigitValue
        cmp eax, edi
        jge short .12
        mov edx, dword [byte esp+08h]
        imul edx, edi
        inc ebx
        add edx, eax
        mov eax, esi
        mov dword [byte esp+08h], edx
        call ScanGetCharWidth
        jmp short .10
.12:
        cmp edx, byte 3Ah
        jne short .14
        test byte [byte esi+010h], 80h
        je short .14
.13:
        mov eax, esi
        inc ebx
        call ScanGetCharWidth
        mov ecx, eax
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .15
        call HexDigitValue
        cmp eax, edi
        jge short .14
        mov edx, dword [byte esp+08h]
        imul edx, edi
        add edx, eax
        mov dword [byte esp+08h], edx
        jmp short .13
.14:
        mov eax, edx
        mov edx, esi
        call dword [byte esi+04h]
.15:
        cmp dword [esp], byte 2Dh
        jne short .16
        neg dword [byte esp+08h]
.16:
        test ebx, ebx
        jle near .21
        mov ah, byte [byte esi+010h]
        add ebx, ebp
        test ah, 1
        je short .21
        test ah, 4
        je short .17
        mov eax, dword [byte esp+0Ch]
        mov edx, dword [eax]
        add edx, byte 8
        mov dword [eax], edx
        les eax, [byte edx-08h]
        jmp short .19
.17:
        test ah, 8
        je short .18
        mov eax, dword [byte esp+0Ch]
        mov ebp, dword [eax]
        add ebp, byte 4
        mov edx, ds
        mov dword [eax], ebp
        mov es, edx
        mov eax, dword [byte ebp-04h]
        jmp short .19
.18:
        mov eax, dword [byte esp+0Ch]
        mov edi, dword [eax]
        add edi, byte 4
        mov edx, ds
        mov dword [eax], edi
        mov es, edx
        mov eax, dword [byte edi-04h]
.19:
        mov cl, byte [byte esi+010h]
        test cl, 10h
        je short .20
        mov edx, dword [byte esp+08h]
        db 066h,026h,089h,010h                  ; insn: mov [es:eax],dx
        jmp short .21
.20:
        test cl, 20h
        mov edx, dword [byte esp+08h]
        mov dword [es:eax], edx
.21:
        mov eax, ebx
        add esp, byte 10h
        pop ebp
        pop es
        pop edi
        pop esi
        ret
HexDigitValue:
        cmp eax, byte 30h
        jl short .1
        cmp eax, byte 39h
        jg short .1
        sub eax, byte 30h
        ret
.1:
        call tolower_
        cmp eax, byte 61h
        jl short .2
        cmp eax, byte 66h
        jg short .2
        sub eax, byte 57h
        ret
.2:
        mov eax, 10h
        ret
ScanGetCharWidth:
        push ebx
        push edx
        mov edx, eax
        mov eax, dword [byte eax+0Ch]
        lea ebx, [byte eax-01h]
        mov dword [byte edx+0Ch], ebx
        test eax, eax
        je short .1
        mov eax, edx
        call dword [edx]
        test byte [byte edx+010h], 2
        je short .2
.1:
        mov eax, 0FFFFFFFFh
.2:
        pop edx
        pop ebx
        ret
