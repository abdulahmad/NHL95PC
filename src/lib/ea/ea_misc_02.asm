; Small helpers from the EA libraries.
bits 32
%include "hockey.inc"
section s_9BA18 progbits alloc exec nowrite align=1
extern __FDFS, byte_C4B6C, byte_C4C78, memset_, off_D566C, tolower_
global ScanFormat, loc_9BA37, loc_9BA6E, loc_9BA7B, loc_9BA8F, loc_9BA95, loc_9BAB1, loc_9BAE3
global loc_9BAF1, loc_9BB01, loc_9BB0B, loc_9BB23, loc_9BB31, loc_9BB42, loc_9BB50, loc_9BB55
global loc_9BB5E, loc_9BB65, loc_9BB72, loc_9BB79, loc_9BB86, loc_9BB8D, loc_9BB98, loc_9BBA3
global loc_9BBB0, loc_9BBB9, loc_9BBCD, loc_9BBDA, loc_9BBE6, loc_9BC1A, loc_9BC2E, loc_9BC32
global ScanParseSpec, loc_9BC69, loc_9BC86, loc_9BCAC, loc_9BCBC, loc_9BCC5, loc_9BCC7, loc_9BCE1
global loc_9BCE8, loc_9BCF5, loc_9BD01, loc_9BD0C, ScanSkipSpace, loc_9BD1B, loc_9BD34, loc_9BD41
global ScanStoreCount, loc_9BD69, loc_9BD7E, loc_9BD8C, loc_9BD9B, loc_9BDC0, loc_9BDC6, loc_9BDC8
global ScanChars, loc_9BDE4, loc_9BDEC, loc_9BE03, loc_9BE17, loc_9BE25, loc_9BE27, loc_9BE3E
global loc_9BE48, loc_9BE55, loc_9BE68, loc_9BE6C, loc_9BE73, loc_9BE8F, loc_9BE96, loc_9BEAC
global loc_9BEB2, ScanStoreInt, loc_9BED9, loc_9BEEE, loc_9BEFE, loc_9BF0F, loc_9BF15, ScanBuildCharSet
global loc_9BF38, loc_9BF57, ScanCharSet, loc_9BF80, loc_9BFA4, loc_9BFB9, loc_9BFC7, loc_9BFD4
global loc_9C012, loc_9C025, loc_9C036, ScanFloatField, loc_9C05A, loc_9C078, loc_9C09D, loc_9C0BB
global loc_9C0D6, loc_9C0FA, loc_9C113, loc_9C136, loc_9C171, loc_9C172, loc_9C196, loc_9C1A4
global loc_9C1CA, loc_9C1D3, loc_9C1DC, loc_9C1F4, loc_9C212, loc_9C224, loc_9C23A, loc_9C25C
global loc_9C263, loc_9C28E, loc_9C29A, loc_9C2B2, loc_9C2CB, loc_9C2DD, loc_9C2EB, loc_9C2F5
global loc_9C306, loc_9C313, loc_9C316, ScanIntegerField, loc_9C33E, loc_9C357, loc_9C38C, loc_9C3A2
global loc_9C3CE, loc_9C3EC, loc_9C3F3, loc_9C3FA, loc_9C427, loc_9C433, loc_9C43A, loc_9C45C
global loc_9C467, loc_9C490, loc_9C497, loc_9C4A1, loc_9C4C8, loc_9C4E1, loc_9C4F3, loc_9C505
global loc_9C50F, HexDigitValue, loc_9C527, loc_9C53A, ScanGetCharWidth, loc_9C55B, loc_9C560
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
loc_9BA37:
        mov ebx, dword [esp]
        lea ecx, [byte ebx+01h]
        mov dword [esp], ecx
        mov bl, byte [ebx]
        and ebx, 0FFh
        je near loc_9BC1A
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short loc_9BA6E
        mov eax, esi
        call ScanSkipSpace
        add ebp, eax
        jmp near loc_9BBE6
loc_9BA6E:
        cmp ebx, byte 25h
        je short loc_9BA95
        mov eax, esi
        call dword [esi]
        cmp eax, ebx
        je short loc_9BA8F
loc_9BA7B:
        test byte [byte esi+010h], 2
        jne near loc_9BC1A
        mov edx, esi
        call dword [byte esi+04h]
        jmp near loc_9BC1A
loc_9BA8F:
        inc ebp
        jmp near loc_9BBE6
loc_9BA95:
        mov eax, ecx
        mov edx, esi
        call ScanParseSpec
        xor ebx, ebx
        mov dword [esp], eax
        mov bl, byte [eax]
        mov edx, eax
        test ebx, ebx
        je short loc_9BAB1
        lea edx, [byte eax+01h]
        mov dword [esp], edx
loc_9BAB1:
        cmp ebx, byte 65h
        jb short loc_9BB0B
        cmp ebx, byte 67h
        jbe near loc_9BB8D
        cmp ebx, byte 70h
        jb short loc_9BAF1
        jbe near loc_9BB86
        cmp ebx, byte 75h
        jb short loc_9BAE3
        jbe near loc_9BB79
        cmp ebx, byte 78h
        je near loc_9BB86
        jmp near loc_9BBE6
loc_9BAE3:
        cmp ebx, byte 73h
        je near loc_9BB98
        jmp near loc_9BBE6
loc_9BAF1:
        cmp ebx, byte 6Eh
        jb short loc_9BB01
        jbe near loc_9BBCD
        jmp near loc_9BB72
loc_9BB01:
        cmp ebx, byte 69h
        je short loc_9BB65
        jmp near loc_9BBE6
loc_9BB0B:
        cmp ebx, byte 58h
        jb short loc_9BB31
        jbe near loc_9BB86
        cmp ebx, byte 63h
        jb short loc_9BB23
        jbe near loc_9BBB0
        jmp short loc_9BB50
loc_9BB23:
        cmp ebx, byte 5Bh
        je near loc_9BBA3
        jmp near loc_9BBE6
loc_9BB31:
        cmp ebx, byte 45h
        jb short loc_9BB42
        jbe short loc_9BB8D
        cmp ebx, byte 47h
        je short loc_9BB8D
        jmp near loc_9BBE6
loc_9BB42:
        cmp ebx, byte 25h
        je near loc_9BBDA
        jmp near loc_9BBE6
loc_9BB50:
        mov ebx, 0Ah
loc_9BB55:
        mov ecx, 1
        mov eax, esi
        mov edx, edi
loc_9BB5E:
        call ScanIntegerField
        jmp short loc_9BBB9
loc_9BB65:
        mov ecx, 1
        mov eax, esi
        mov edx, edi
        xor ebx, ebx
        jmp short loc_9BB5E
loc_9BB72:
        mov ebx, 8
        jmp short loc_9BB55
loc_9BB79:
        mov ebx, 0Ah
        mov eax, esi
        mov edx, edi
        xor ecx, ecx
        jmp short loc_9BB5E
loc_9BB86:
        mov ebx, 10h
        jmp short loc_9BB55
loc_9BB8D:
        mov eax, esi
        mov edx, edi
        call ScanFloatField
        jmp short loc_9BBB9
loc_9BB98:
        mov eax, esi
        mov edx, edi
        call ScanChars
        jmp short loc_9BBB9
loc_9BBA3:
        mov ebx, esp
        mov eax, esi
        mov edx, edi
        call ScanCharSet
        jmp short loc_9BBB9
loc_9BBB0:
        mov eax, esi
        mov edx, edi
        call ScanStoreCount
loc_9BBB9:
        test eax, eax
        jle short loc_9BC1A
        mov dh, byte [byte esi+010h]
        add ebp, eax
        test dh, 1
        je short loc_9BBE6
        inc dword [byte esp+04h]
        jmp short loc_9BBE6
loc_9BBCD:
        mov eax, esi
        mov edx, edi
        mov ebx, ebp
        call ScanStoreInt
        jmp short loc_9BBE6
loc_9BBDA:
        mov eax, esi
        call dword [esi]
        cmp eax, ebx
        jne near loc_9BA7B
loc_9BBE6:
        test byte [byte esi+010h], 2
        je near loc_9BA37
        mov eax, dword [esp]
        cmp byte [eax], 25h
        jne short loc_9BC1A
        lea edx, [byte eax+01h]
        mov dword [esp], edx
        mov eax, edx
        mov edx, esi
        call ScanParseSpec
        mov dword [esp], eax
        cmp byte [eax], 6Eh
        jne short loc_9BC1A
        mov eax, esi
        mov edx, edi
        mov ebx, ebp
        call ScanStoreInt
loc_9BC1A:
        cmp dword [byte esp+04h], byte 0
        jne short loc_9BC2E
        test byte [byte esi+010h], 2
        je short loc_9BC2E
        mov eax, 0FFFFFFFFh
        jmp short loc_9BC32
loc_9BC2E:
        mov eax, dword [byte esp+04h]
loc_9BC32:
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
        jne short loc_9BC69
        mov ch, byte [byte ebx+010h]
        and ch, 0FEh
        inc eax
        mov byte [byte ebx+010h], ch
loc_9BC69:
        xor edx, edx
        mov dl, byte [eax]
        mov dword [esp], edx
        mov dl, byte [esp]
        inc dl
        and edx, 0FFh
        test byte [dword edx+byte_C4B6C], 20h
        je short loc_9BCAC
        xor edx, edx
loc_9BC86:
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
        jne short loc_9BC86
        mov dword [byte ebx+0Ch], edx
loc_9BCAC:
        mov cl, byte [eax]
        lea edx, [byte eax+01h]
        cmp cl, 4Eh
        jne short loc_9BCBC
        or byte [byte ebx+010h], 8
        jmp short loc_9BCC5
loc_9BCBC:
        cmp cl, 46h
        jne short loc_9BCC7
        or byte [byte ebx+010h], 4
loc_9BCC5:
        mov eax, edx
loc_9BCC7:
        mov cl, byte [eax]
        lea edx, [byte eax+01h]
        cmp cl, 68h
        jb short loc_9BCE1
        jbe short loc_9BCE8
        cmp cl, 6Ch
        jb short loc_9BD0C
        jbe short loc_9BCF5
        cmp cl, 77h
        je short loc_9BCF5
        jmp short loc_9BD0C
loc_9BCE1:
        cmp cl, 4Ch
        je short loc_9BD01
        jmp short loc_9BD0C
loc_9BCE8:
        mov cl, byte [byte ebx+010h]
        or cl, 10h
        mov eax, edx
        mov byte [byte ebx+010h], cl
        jmp short loc_9BD0C
loc_9BCF5:
        mov dl, byte [byte ebx+010h]
        or dl, 20h
        inc eax
        mov byte [byte ebx+010h], dl
        jmp short loc_9BD0C
loc_9BD01:
        mov ch, byte [byte ebx+010h]
        or ch, 40h
        mov eax, edx
        mov byte [byte ebx+010h], ch
loc_9BD0C:
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
loc_9BD1B:
        mov eax, ebx
        call dword [ebx]
        mov esi, eax
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short loc_9BD34
        inc ecx
        jmp short loc_9BD1B
loc_9BD34:
        test byte [byte ebx+010h], 2
        jne short loc_9BD41
        mov eax, esi
        mov edx, ebx
        call dword [byte ebx+04h]
loc_9BD41:
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
        je short loc_9BD8C
        mov cl, byte [byte ebx+010h]
        test cl, 4
        je short loc_9BD69
        mov edi, dword [edx]
        add edi, byte 8
        mov dword [edx], edi
        les ecx, [byte edi-08h]
        jmp short loc_9BD8C
loc_9BD69:
        test cl, 8
        je short loc_9BD7E
        mov esi, dword [edx]
        add esi, byte 4
        mov eax, ds
        mov dword [edx], esi
        mov es, eax
        mov ecx, dword [byte esi-04h]
        jmp short loc_9BD8C
loc_9BD7E:
        mov ecx, dword [edx]
        add ecx, byte 4
        mov eax, ds
        mov dword [edx], ecx
        mov es, eax
        mov ecx, dword [byte ecx-04h]
loc_9BD8C:
        mov edx, dword [byte ebx+0Ch]
        xor esi, esi
        cmp edx, byte 0FFFFFFFFh
        jne short loc_9BD9B
        mov edx, 1
loc_9BD9B:
        test edx, edx
        jle short loc_9BDC6
        mov eax, ebx
        call dword [ebx]
        test byte [byte ebx+010h], 2
        jne short loc_9BDC6
        inc esi
        dec edx
        test byte [byte ebx+010h], 1
        je short loc_9BD9B
        test byte [byte ebx+010h], 20h
        je short loc_9BDC0
        db 066h,026h,089h,01h                   ; insn: mov [es:ecx],ax
        add ecx, byte 2
        jmp short loc_9BD9B
loc_9BDC0:
        mov byte [es:ecx], al
        inc ecx
        jmp short loc_9BD9B
loc_9BDC6:
        mov eax, esi
loc_9BDC8:
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
        je short loc_9BDE4
        mov byte [esp], 2
        jmp short loc_9BDEC
loc_9BDE4:
        test byte [byte ebx+010h], 10h
        mov byte [esp], 1
loc_9BDEC:
        mov al, byte [byte ebx+010h]
        test al, 1
        je short loc_9BE25
        test al, 4
        je short loc_9BE03
        mov edi, dword [edx]
        add edi, byte 8
        mov dword [edx], edi
        les ecx, [byte edi-08h]
        jmp short loc_9BE25
loc_9BE03:
        test al, 8
        je short loc_9BE17
        mov esi, dword [edx]
        add esi, byte 4
        mov dword [edx], esi
        mov edx, ds
        mov es, edx
        mov ecx, dword [byte esi-04h]
        jmp short loc_9BE25
loc_9BE17:
        mov ecx, dword [edx]
        add ecx, byte 4
        mov dword [edx], ecx
        mov edx, ds
        mov es, edx
        mov ecx, dword [byte ecx-04h]
loc_9BE25:
        xor esi, esi
loc_9BE27:
        mov eax, ebx
        call dword [ebx]
        mov edx, eax
        inc al
        movzx edi, al
        test byte [dword edi+byte_C4B6C], 2
        je short loc_9BE3E
        inc esi
        jmp short loc_9BE27
loc_9BE3E:
        test byte [byte ebx+010h], 2
        je short loc_9BE48
        xor esi, esi
        jmp short loc_9BE96
loc_9BE48:
        mov edi, dword [byte ebx+0Ch]
        lea eax, [byte edi-01h]
        mov dword [byte ebx+0Ch], eax
        test edi, edi
        je short loc_9BE8F
loc_9BE55:
        mov al, byte [byte ebx+010h]
        inc esi
        test al, 1
        je short loc_9BE73
        cmp byte [esp], 1
        jne short loc_9BE68
        mov byte [es:ecx], dl
        jmp short loc_9BE6C
loc_9BE68:
        db 066h,026h,089h,011h                  ; insn: mov [es:ecx],dx
loc_9BE6C:
        xor edx, edx
        mov dl, byte [esp]
        add ecx, edx
loc_9BE73:
        mov eax, ebx
        call ScanGetCharWidth
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_9BE96
        inc al
        movzx edi, al
        test byte [dword edi+byte_C4B6C], 2
        je short loc_9BE55
loc_9BE8F:
        mov eax, edx
        mov edx, ebx
        call dword [byte ebx+04h]
loc_9BE96:
        test byte [byte ebx+010h], 1
        je short loc_9BEB2
        test esi, esi
        jle short loc_9BEB2
        cmp byte [esp], 1
        jne short loc_9BEAC
        mov byte [es:ecx], 0
        jmp short loc_9BEB2
loc_9BEAC:
        db 066h,026h,0C7h,01h,00h,00h           ; insn: mov word [es:ecx],0
loc_9BEB2:
        mov eax, esi
        add esp, byte 4
        jmp near loc_9BDC8
ScanStoreInt:
        push ecx
        push esi
        push edi
        push es
        mov cl, byte [byte eax+010h]
        test cl, 1
        je short loc_9BF15
        test cl, 4
        je short loc_9BED9
        mov edi, dword [edx]
        add edi, byte 8
        mov dword [edx], edi
        les edx, [byte edi-08h]
        jmp short loc_9BEFE
loc_9BED9:
        test cl, 8
        je short loc_9BEEE
        mov esi, dword [edx]
        add esi, byte 4
        mov ecx, ds
        mov dword [edx], esi
        mov es, ecx
        mov edx, dword [byte esi-04h]
        jmp short loc_9BEFE
loc_9BEEE:
        mov ecx, dword [edx]
        add ecx, byte 4
        mov dword [edx], ecx
        mov edx, ecx
        mov ecx, ds
        mov es, ecx
        mov edx, dword [byte edx-04h]
loc_9BEFE:
        mov ch, byte [byte eax+010h]
        test ch, 10h
        je short loc_9BF0F
        db 066h,026h,089h,01Ah                  ; insn: mov [es:edx],bx
        pop es
        pop edi
        pop esi
        pop ecx
        ret
loc_9BF0F:
        test ch, 20h
        mov dword [es:edx], ebx
loc_9BF15:
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
        je short loc_9BF57
loc_9BF38:
        mov edx, eax
        and eax, byte 7
        sar edx, 3
        mov al, byte [dword eax+byte_C4C78]
        or byte [edx+esi], al
        xor eax, eax
        mov al, byte [ecx]
        test eax, eax
        je short loc_9BF57
        inc ecx
        cmp eax, byte 5Dh
        jne short loc_9BF38
loc_9BF57:
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
        je short loc_9BF80
        inc eax
        mov dword [ebx], eax
loc_9BF80:
        mov edx, esp
        mov eax, dword [ebx]
        call ScanBuildCharSet
        mov dword [ebx], eax
        mov bl, byte [byte ecx+010h]
        test bl, 1
        je short loc_9BFC7
        test bl, 4
        je short loc_9BFA4
        mov esi, dword [edi]
        add esi, byte 8
        mov dword [edi], esi
        les esi, [byte esi-08h]
        jmp short loc_9BFC7
loc_9BFA4:
        test bl, 8
        je short loc_9BFB9
        mov ebx, dword [edi]
        add ebx, byte 4
        mov eax, ds
        mov dword [edi], ebx
        mov es, eax
        mov esi, dword [byte ebx-04h]
        jmp short loc_9BFC7
loc_9BFB9:
        mov edx, dword [edi]
        add edx, byte 4
        mov eax, ds
        mov dword [edi], edx
        mov es, eax
        mov esi, dword [byte edx-04h]
loc_9BFC7:
        mov ebp, dword [byte esp+020h]
        xor edi, edi
        mov ebx, dword [byte ecx+0Ch]
        mov dword [byte esp+024h], edi
loc_9BFD4:
        test ebx, ebx
        jbe short loc_9C025
        mov eax, ecx
        call dword [ecx]
        mov edx, eax
        test byte [byte ecx+010h], 2
        jne short loc_9C025
        mov edi, eax
        and edx, byte 7
        sar edi, 3
        mov dl, byte [dword edx+byte_C4C78]
        movzx edi, byte [esp+edi]
        and edx, 0FFh
        test edi, edx
        sete dl
        and edx, 0FFh
        cmp edx, ebp
        je short loc_9C012
        mov edx, ecx
        call dword [byte ecx+04h]
        jmp short loc_9C025
loc_9C012:
        inc dword [byte esp+024h]
        mov dl, byte [byte ecx+010h]
        dec ebx
        test dl, 1
        je short loc_9BFD4
        mov byte [es:esi], al
        inc esi
        jmp short loc_9BFD4
loc_9C025:
        test byte [byte ecx+010h], 1
        je short loc_9C036
        cmp dword [byte esp+024h], byte 0
        jle short loc_9C036
        mov byte [es:esi], 0
loc_9C036:
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
loc_9C05A:
        mov eax, ecx
        call dword [ecx]
        mov ebp, eax
        mov ebx, eax
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short loc_9C078
        inc dword [byte esp+06Ch]
        jmp short loc_9C05A
loc_9C078:
        test byte [byte ecx+010h], 2
        jne near loc_9C263
        mov eax, dword [byte ecx+0Ch]
        lea edx, [byte eax-01h]
        mov dword [byte ecx+0Ch], edx
        test eax, eax
        je near loc_9C25C
        cmp ebp, byte 2Bh
        je short loc_9C09D
        cmp ebp, byte 2Dh
        jne short loc_9C0BB
loc_9C09D:
        mov ebp, dword [byte esp+06Ch]
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        inc ebp
        mov ebx, eax
        mov dword [byte esp+06Ch], ebp
        cmp eax, byte 0FFFFFFFFh
        je near loc_9C263
loc_9C0BB:
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short loc_9C0D6
        cmp ebx, byte 2Eh
        jne near loc_9C25C
loc_9C0D6:
        xor eax, eax
        mov dword [byte esp+068h], eax
        mov dword [byte esp+05Ch], eax
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        je short loc_9C136
        mov dword [byte esp+05Ch], 1
loc_9C0FA:
        mov byte [esi], bl
        mov al, byte [byte ecx+010h]
        inc esi
        test al, 10h
        je short loc_9C113
        imul eax, dword [byte esp+06Ah], byte 0Ah
        add ebx, eax
        sub ebx, byte 30h
        mov word [byte esp+06Ah], bx
loc_9C113:
        mov eax, ecx
        inc edi
        call ScanGetCharWidth
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_9C263
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short loc_9C0FA
loc_9C136:
        cmp ebx, byte 2Eh
        jne near loc_9C1DC
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_9C263
        cmp dword [byte esp+05Ch], byte 0
        jne short loc_9C171
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        je near loc_9C25C
loc_9C171:
        inc edi
loc_9C172:
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        je short loc_9C196
        inc edi
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        jne short loc_9C172
loc_9C196:
        test byte [byte ecx+010h], 10h
        je short loc_9C1D3
        xor edx, edx
        mov ebp, esi
        mov dword [byte esp+064h], edx
loc_9C1A4:
        dec ebp
        mov al, byte [byte ebp+00h]
        cmp al, 2Eh
        je short loc_9C1CA
        sub al, 30h
        mov dword [byte esp+060h], 0Ah
        mov byte [byte esp+066h], al
        xor edx, edx
        mov eax, dword [byte esp+064h]
        div dword [byte esp+060h]
        mov dword [byte esp+064h], eax
        jmp short loc_9C1A4
loc_9C1CA:
        mov eax, dword [byte esp+064h]
        mov word [byte esp+068h], ax
loc_9C1D3:
        cmp ebx, byte 0FFFFFFFFh
        je near loc_9C263
loc_9C1DC:
        test byte [byte ecx+010h], 10h
        jne near loc_9C25C
        cmp ebx, byte 65h
        je short loc_9C1F4
        cmp ebx, byte 45h
        jne near loc_9C25C
loc_9C1F4:
        inc edi
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebp, eax
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_9C263
        cmp eax, byte 2Bh
        je short loc_9C212
        cmp eax, byte 2Dh
        jne short loc_9C224
loc_9C212:
        inc edi
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_9C263
loc_9C224:
        mov al, bl
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short loc_9C23A
        xor edi, edi
        jmp short loc_9C25C
loc_9C23A:
        inc edi
        mov eax, ecx
        mov byte [esi], bl
        call ScanGetCharWidth
        inc esi
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_9C263
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 20h
        jne short loc_9C23A
loc_9C25C:
        mov eax, ebx
        mov edx, ecx
        call dword [byte ecx+04h]
loc_9C263:
        test edi, edi
        jle near loc_9C316
        add edi, dword [byte esp+06Ch]
        test byte [byte ecx+010h], 1
        je near loc_9C316
        mov byte [esi], 0
        test byte [byte ecx+010h], 10h
        je short loc_9C28E
        cmp byte [esp], 2Dh
        jne short loc_9C29A
        neg dword [byte esp+068h]
        jmp short loc_9C29A
loc_9C28E:
        mov eax, esp
        lea edx, [byte esp+050h]
        call dword [off_D566C]
loc_9C29A:
        mov ah, byte [byte ecx+010h]
        test ah, 4
        je short loc_9C2B2
        mov eax, dword [byte esp+058h]
        mov ebx, dword [eax]
        add ebx, byte 8
        mov dword [eax], ebx
        les ebx, [byte ebx-08h]
        jmp short loc_9C2DD
loc_9C2B2:
        test ah, 8
        je short loc_9C2CB
        mov eax, dword [byte esp+058h]
        mov edx, dword [eax]
        add edx, byte 4
        mov dword [eax], edx
        mov eax, ds
        mov es, eax
        mov ebx, dword [byte edx-04h]
        jmp short loc_9C2DD
loc_9C2CB:
        mov eax, dword [byte esp+058h]
        mov ebp, dword [eax]
        add ebp, byte 4
        mov dword [eax], ebp
        mov eax, ds
        mov es, eax
        mov ebx, dword [byte ebp-04h]
loc_9C2DD:
        mov dh, byte [byte ecx+010h]
        test dh, 10h
        je short loc_9C2EB
        mov eax, dword [byte esp+068h]
        jmp short loc_9C313
loc_9C2EB:
        test dh, 20h
        jne short loc_9C2F5
        test dh, 40h
        je short loc_9C306
loc_9C2F5:
        mov eax, dword [byte esp+050h]
        mov dword [es:ebx], eax
        mov eax, dword [byte esp+054h]
        mov dword [byte es:ebx+04h], eax
        jmp short loc_9C316
loc_9C306:
        mov eax, dword [byte esp+050h]
        mov edx, dword [byte esp+054h]
        call __FDFS
loc_9C313:
        mov dword [es:ebx], eax
loc_9C316:
        mov eax, edi
        add esp, byte 70h
        pop ebp
        jmp near loc_9BDC8
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
loc_9C33E:
        mov eax, esi
        call dword [esi]
        mov edx, eax
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short loc_9C357
        inc ebp
        jmp short loc_9C33E
loc_9C357:
        test byte [byte esi+010h], 2
        jne near loc_9C497
        mov eax, dword [byte esi+0Ch]
        lea ecx, [byte eax-01h]
        mov dword [byte esi+0Ch], ecx
        test eax, eax
        je near loc_9C490
        mov ecx, 2Bh
        mov eax, dword [byte esp+04h]
        mov dword [esp], ecx
        test eax, eax
        je short loc_9C3A2
        cmp edx, byte 2Bh
        je short loc_9C38C
        cmp edx, byte 2Dh
        jne short loc_9C3A2
loc_9C38C:
        mov dword [esp], edx
        mov eax, esi
        inc ebp
        call ScanGetCharWidth
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_9C497
loc_9C3A2:
        test edi, edi
        jne short loc_9C3FA
        cmp edx, byte 30h
        jne short loc_9C3F3
        mov eax, esi
        mov ebx, 1
        call ScanGetCharWidth
        mov ecx, eax
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_9C497
        cmp eax, byte 78h
        je short loc_9C3CE
        cmp eax, byte 58h
        jne short loc_9C3EC
loc_9C3CE:
        mov eax, esi
        add ebp, byte 2
        call ScanGetCharWidth
        xor ebx, ebx
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_9C497
        mov edi, 10h
        jmp short loc_9C43A
loc_9C3EC:
        mov edi, 8
        jmp short loc_9C43A
loc_9C3F3:
        mov edi, 0Ah
        jmp short loc_9C43A
loc_9C3FA:
        cmp edi, byte 10h
        jne short loc_9C43A
        cmp edx, byte 30h
        jne short loc_9C43A
        mov eax, esi
        mov ebx, 1
        call ScanGetCharWidth
        mov ecx, eax
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_9C497
        cmp eax, byte 78h
        je short loc_9C427
        cmp eax, byte 58h
        jne short loc_9C43A
loc_9C427:
        mov eax, esi
        add ebp, byte 2
        call ScanGetCharWidth
        xor ebx, ebx
loc_9C433:
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_9C497
loc_9C43A:
        mov eax, edx
        call HexDigitValue
        cmp eax, edi
        jge short loc_9C45C
        mov edx, dword [byte esp+08h]
        imul edx, edi
        inc ebx
        add edx, eax
        mov eax, esi
        mov dword [byte esp+08h], edx
        call ScanGetCharWidth
        jmp short loc_9C433
loc_9C45C:
        cmp edx, byte 3Ah
        jne short loc_9C490
        test byte [byte esi+010h], 80h
        je short loc_9C490
loc_9C467:
        mov eax, esi
        inc ebx
        call ScanGetCharWidth
        mov ecx, eax
        mov edx, eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_9C497
        call HexDigitValue
        cmp eax, edi
        jge short loc_9C490
        mov edx, dword [byte esp+08h]
        imul edx, edi
        add edx, eax
        mov dword [byte esp+08h], edx
        jmp short loc_9C467
loc_9C490:
        mov eax, edx
        mov edx, esi
        call dword [byte esi+04h]
loc_9C497:
        cmp dword [esp], byte 2Dh
        jne short loc_9C4A1
        neg dword [byte esp+08h]
loc_9C4A1:
        test ebx, ebx
        jle near loc_9C50F
        mov ah, byte [byte esi+010h]
        add ebx, ebp
        test ah, 1
        je short loc_9C50F
        test ah, 4
        je short loc_9C4C8
        mov eax, dword [byte esp+0Ch]
        mov edx, dword [eax]
        add edx, byte 8
        mov dword [eax], edx
        les eax, [byte edx-08h]
        jmp short loc_9C4F3
loc_9C4C8:
        test ah, 8
        je short loc_9C4E1
        mov eax, dword [byte esp+0Ch]
        mov ebp, dword [eax]
        add ebp, byte 4
        mov edx, ds
        mov dword [eax], ebp
        mov es, edx
        mov eax, dword [byte ebp-04h]
        jmp short loc_9C4F3
loc_9C4E1:
        mov eax, dword [byte esp+0Ch]
        mov edi, dword [eax]
        add edi, byte 4
        mov edx, ds
        mov dword [eax], edi
        mov es, edx
        mov eax, dword [byte edi-04h]
loc_9C4F3:
        mov cl, byte [byte esi+010h]
        test cl, 10h
        je short loc_9C505
        mov edx, dword [byte esp+08h]
        db 066h,026h,089h,010h                  ; insn: mov [es:eax],dx
        jmp short loc_9C50F
loc_9C505:
        test cl, 20h
        mov edx, dword [byte esp+08h]
        mov dword [es:eax], edx
loc_9C50F:
        mov eax, ebx
        add esp, byte 10h
        pop ebp
        pop es
        pop edi
        pop esi
        ret
HexDigitValue:
        cmp eax, byte 30h
        jl short loc_9C527
        cmp eax, byte 39h
        jg short loc_9C527
        sub eax, byte 30h
        ret
loc_9C527:
        call tolower_
        cmp eax, byte 61h
        jl short loc_9C53A
        cmp eax, byte 66h
        jg short loc_9C53A
        sub eax, byte 57h
        ret
loc_9C53A:
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
        je short loc_9C55B
        mov eax, edx
        call dword [edx]
        test byte [byte edx+010h], 2
        je short loc_9C560
loc_9C55B:
        mov eax, 0FFFFFFFFh
loc_9C560:
        pop edx
        pop ebx
        ret
