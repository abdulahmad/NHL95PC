; The PC speaker driver.
bits 32
%include "hockey.inc"
section s_9D68E progbits alloc exec nowrite align=1
extern __GETDS, abs_, byte_D5224, byte_F24D9, byte_F27EE, byte_F27EF, byte_F27FD, _STACKLOW
extern dword_D4F9A, dword_F27F6, sub_8F114, sub_9F685, sub_9F725, sub_9FA5D, sub_9FC24, sub_9FC94
extern sub_A65E8, sub_A6612, sub_A6635, sub_A6672, sub_A6684, sub_A677B, unk_F21FC, unk_F24D8
extern unk_F27D8
global CMainHook, sub_9D698, sub_9D69E, loc_9D6A2, loc_9D6B8, loc_9D6C4, loc_9D6D9, sub_9D6E6
global sub_9D6EC, sub_9D6F3, sub_9D6F9, sub_9D700, loc_9D723, loc_9D73E, loc_9D802, sub_9D805
global loc_9D81C, loc_9D82B, loc_9D82C, loc_9D832, loc_9D852, loc_9D856, sub_9D858, sub_9D880
global loc_9D897, loc_9D8D4, loc_9D8D8, loc_9D8FE, loc_9D90F, loc_9D951, loc_9D970, loc_9D98A
global loc_9D9C8, loc_9D9D0, loc_9D9FC, loc_9DA03, loc_9DA1B, loc_9DA3B, loc_9DA59, loc_9DA70
global loc_9DA76, sub_9DA99, loc_9DAA6, sub_9DAAC, sub_9DAB2, loc_9DAF3, loc_9DAFE, loc_9DB06
global loc_9DB36, loc_9DB3D, loc_9DB55, loc_9DBB8, loc_9DBBD, loc_9DBD4, loc_9DBD9, loc_9DBF7
global loc_9DC1B, loc_9DC40, loc_9DC42, loc_9DC44, loc_9DC5F, loc_9DC8C, loc_9DC91, sub_9DC9F
global sub_9DCA5, loc_9DCE6, loc_9DCF2, loc_9DCFA, loc_9DD32, loc_9DD39, loc_9DD51, loc_9DDB4
global loc_9DDB9, loc_9DDD0, loc_9DDD5, loc_9DDEF, loc_9DE0F, loc_9DE2F, loc_9DE31, loc_9DE53
global loc_9DE6A, loc_9DE89, loc_9DE8E
CMainHook:
        mov eax, esp
        sub eax, dword [_STACKLOW]
        ret
        db 00h
sub_9D698:
        push ds
        call __GETDS
sub_9D69E:
        xor eax, eax
        jmp short loc_9D6B8
loc_9D6A2:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 4
        xor bl, bl
        mov byte [dword edx+byte_F24D9], bl
        inc eax
loc_9D6B8:
        cmp ax, 10h
        jl short loc_9D6A2
        xor eax, eax
        mov cl, 10h
        jmp short loc_9D6D9
loc_9D6C4:
        movsx edx, ax
        imul edx, byte 4Eh
        xor bh, bh
        mov byte [dword edx+byte_F27EE], bh
        mov byte [dword edx+byte_F27EF], cl
        inc eax
loc_9D6D9:
        cmp ax, 18h
        jl short loc_9D6C4
        call sub_A65E8
        pop ds
        ret
sub_9D6E6:
        push ds
        call __GETDS
sub_9D6EC:
        call sub_A6612
        pop ds
        ret
sub_9D6F3:
        push ds
        call __GETDS
sub_9D6F9:
        call sub_9D880
        pop ds
        ret
sub_9D700:
        push ds
        call __GETDS
        push esi
        xor eax, eax
        mov al, byte [byte esp+0Ch]
        imul eax, byte 4Eh
        mov esi, unk_F27D8
        add esi, eax
        cmp byte [byte esp+0Ch], 9
        je short loc_9D723
        mov edx, dword [byte esi+01Eh]
        jmp short loc_9D73E
loc_9D723:
        mov al, byte [byte esp+010h]
        add al, 5Ch
        and eax, 0FFh
        push eax
        call sub_8F114
        add esp, byte 4
        mov edx, eax
        mov byte [byte esp+010h], 3Ch
loc_9D73E:
        test edx, edx
        je near loc_9D802
        mov eax, edx
        call sub_9DA99
        mov ecx, eax
        cwde
        cmp eax, byte 0FFFFFFFFh
        je near loc_9D802
        mov ebx, eax
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        add eax, unk_F24D8
        mov dword [byte eax+010h], edx
        mov bl, byte [byte esp+0Ch]
        mov byte [eax], bl
        mov dword [byte eax+02Ah], esi
        mov byte [byte eax+01h], 1
        mov byte [byte eax+016h], 1
        mov ebx, dword [byte eax+010h]
        mov bx, word [byte ebx+01Ch]
        mov word [byte eax+014h], bx
        mov bl, byte [byte esi+024h]
        mov byte [byte eax+02h], bl
        mov dword [byte eax+08h], 0
        mov dword [byte eax+0Ch], 64h
        mov bx, word [byte edx+02Ah]
        mov word [byte eax+018h], bx
        mov bx, word [byte edx+02Ch]
        mov word [byte eax+01Ah], bx
        mov bx, word [byte edx+030h]
        mov word [byte eax+024h], bx
        mov word [byte eax+01Ch], 0
        mov bl, byte [byte edx+034h]
        mov byte [byte eax+026h], bl
        mov byte [byte eax+027h], 0
        mov bx, word [byte edx+036h]
        mov word [byte eax+01Eh], bx
        mov bx, word [byte edx+038h]
        mov word [byte eax+020h], bx
        mov byte [byte eax+028h], 0
        mov byte [byte eax+022h], 0
        mov byte [byte eax+029h], 0
        mov byte [byte eax+02Eh], cl
        mov bl, byte [byte esp+010h]
        mov bh, byte [byte edx+010h]
        mov dl, bl
        add dl, bh
        movsx edx, dl
        push edx
        push eax
        mov al, cl
        and eax, 0FFh
        push eax
        call sub_A6635
        add esp, byte 0Ch
loc_9D802:
        pop esi
        pop ds
        ret
sub_9D805:
        push ds
        call __GETDS
        mov bh, byte [byte esp+08h]
        mov bl, byte [byte esp+0Ch]
        mov eax, unk_F24D8
        xor edx, edx
        jmp short loc_9D82C
loc_9D81C:
        cmp byte [byte eax+01h], 0
        je short loc_9D82B
        cmp bl, byte [byte eax+03h]
        jne short loc_9D82B
        cmp bh, byte [eax]
        je short loc_9D832
loc_9D82B:
        inc edx
loc_9D82C:
        cmp dx, byte 10h
        jl short loc_9D81C
loc_9D832:
        cmp dx, byte 10h
        jge short loc_9D856
        mov byte [byte eax+01h], 2
        xor edx, edx
        mov dl, byte [eax]
        imul edx, byte 4Eh
        cmp byte [dword edx+byte_F27FD], 0
        je short loc_9D852
        mov byte [byte eax+016h], 3
        pop ds
        ret
loc_9D852:
        mov byte [byte eax+016h], 4
loc_9D856:
        pop ds
        ret
sub_9D858:
        push ds
        call __GETDS
        xor eax, eax
        mov al, byte [byte esp+0Ch]
        push eax
        call sub_8F114
        mov edx, eax
        add esp, byte 4
        xor eax, eax
        mov al, byte [byte esp+08h]
        imul eax, byte 4Eh
        mov dword [dword eax+dword_F27F6], edx
        pop ds
        ret
sub_9D880:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov esi, unk_F24D8
        xor edx, edx
        mov dword [esp], edx
        jmp near loc_9DA76
loc_9D897:
        cmp byte [byte esi+01h], 0
        je near loc_9DA70
        inc dword [byte esi+08h]
        mov edi, dword [byte esi+010h]
        cmp byte [byte esi+016h], 1
        jne short loc_9D8D8
        mov ax, word [byte edi+020h]
        mov bx, word [byte esi+014h]
        add ebx, eax
        mov word [byte esi+014h], bx
        mov cx, word [byte edi+01Eh]
        cmp bx, cx
        jl short loc_9D8D8
        mov word [byte esi+014h], cx
        cmp cx, word [byte edi+024h]
        jg short loc_9D8D4
        mov byte [byte esi+016h], 3
        jmp short loc_9D8D8
loc_9D8D4:
        mov byte [byte esi+016h], 2
loc_9D8D8:
        cmp byte [byte esi+016h], 2
        jne short loc_9D8FE
        mov ax, word [byte edi+022h]
        mov bx, word [byte esi+014h]
        sub ebx, eax
        mov word [byte esi+014h], bx
        cmp bx, word [byte edi+024h]
        jg short loc_9D8FE
        mov byte [byte esi+016h], 3
        mov ax, word [byte edi+024h]
        mov word [byte esi+014h], ax
loc_9D8FE:
        cmp byte [byte esi+016h], 3
        jne short loc_9D90F
        cmp word [byte edi+024h], byte 0
        jne short loc_9D90F
        mov byte [byte esi+016h], 4
loc_9D90F:
        cmp byte [byte esi+016h], 4
        jne short loc_9D951
        mov ax, word [byte edi+026h]
        mov dx, word [byte esi+014h]
        sub edx, eax
        mov word [byte esi+014h], dx
        test dx, dx
        jg short loc_9D951
        mov word [byte esi+014h], 0
        mov byte [byte esi+016h], 0
        mov byte [byte esi+01h], 0
        xor eax, eax
        mov al, byte [esi]
        imul eax, byte 4Eh
        dec byte [dword eax+byte_F27EE]
        xor eax, eax
        mov al, byte [byte esi+02Eh]
        push eax
        call sub_A6672
        add esp, byte 4
loc_9D951:
        cmp byte [byte edi+028h], 0
        je near loc_9DA03
        mov cx, word [byte esi+018h]
        test cx, cx
        je short loc_9D970
        mov ebx, ecx
        dec ebx
        mov word [byte esi+018h], bx
        jmp near loc_9DA03
loc_9D970:
        mov ax, word [byte esi+01Ah]
        test ax, ax
        je near loc_9DA03
        cmp ax, 7FFFh
        je short loc_9D98A
        mov ebx, eax
        dec ebx
        mov word [byte esi+01Ah], bx
loc_9D98A:
        mov al, byte [byte esi+027h]
        test al, al
        jne near loc_9D9FC
        mov al, byte [byte edi+029h]
        mov byte [byte esi+027h], al
        cmp byte [byte esi+026h], 2
        jne short loc_9D9D0
        mov ax, word [byte esi+024h]
        sub word [byte esi+01Ch], ax
        xor edx, edx
        mov dx, word [byte edi+02Eh]
        movsx eax, word [byte esi+01Ch]
        call abs_
        cmp eax, edx
        jl short loc_9DA03
        test byte [byte edi+034h], 1
        je short loc_9D9C8
        mov byte [byte esi+026h], 1
        jmp short loc_9DA03
loc_9D9C8:
        mov word [byte esi+01Ch], 0
        jmp short loc_9DA03
loc_9D9D0:
        mov ax, word [byte esi+024h]
        mov cx, word [byte esi+01Ch]
        add ecx, eax
        mov word [byte esi+01Ch], cx
        xor edx, edx
        mov dx, word [byte edi+02Eh]
        movsx eax, cx
        call abs_
        cmp eax, edx
        jl short loc_9DA03
        test byte [byte edi+034h], 2
        je short loc_9D9C8
        mov byte [byte esi+026h], 2
        jmp short loc_9DA03
loc_9D9FC:
        mov ah, al
        dec ah
        mov byte [byte esi+027h], ah
loc_9DA03:
        cmp byte [byte edi+035h], 0
        je short loc_9DA59
        mov cx, word [byte esi+01Eh]
        test cx, cx
        je short loc_9DA1B
        mov ebx, ecx
        dec ebx
        mov word [byte esi+01Eh], bx
        jmp short loc_9DA59
loc_9DA1B:
        mov ax, word [byte esi+020h]
        test ax, ax
        je short loc_9DA59
        mov edx, eax
        dec edx
        mov word [byte esi+020h], dx
        mov cl, byte [byte esi+028h]
        test cl, cl
        je short loc_9DA3B
        mov ch, cl
        dec ch
        mov byte [byte esi+028h], ch
        jmp short loc_9DA59
loc_9DA3B:
        mov al, byte [byte edi+03Ah]
        mov byte [byte esi+028h], al
        mov al, byte [byte esi+029h]
        mov ah, al
        and ah, 7
        xor edx, edx
        mov dl, ah
        inc al
        mov byte [byte esi+029h], al
        mov al, byte [byte edx+edi+03Bh]
        mov byte [byte esi+022h], al
loc_9DA59:
        mov ebx, dword [byte esi+010h]
        push ebx
        mov ecx, dword [byte esi+02Ah]
        push ecx
        push esi
        xor eax, eax
        mov al, byte [byte esi+02Eh]
        push eax
        call sub_A6684
        add esp, byte 10h
loc_9DA70:
        add esi, byte 30h
        inc dword [esp]
loc_9DA76:
        xor edx, edx
        mov dx, word [esp]
        xor eax, eax
        mov al, byte [byte_D5224]
        cmp edx, eax
        jl near loc_9D897
        call sub_A677B
        add esp, byte 4
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_9DA99:
        cmp word [byte eax+0Ch], byte 0
        jne short loc_9DAA6
        mov eax, 0FFFFFFFFh
        ret
loc_9DAA6:
        mov eax, 1
        ret
sub_9DAAC:
        push ds
        call __GETDS
sub_9DAB2:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 34h
        mov byte [byte ebp-0Ch], 0C0h
        mov byte [byte ebp-010h], 1
        mov byte [byte ebp-04h], 0
        mov dword [byte ebp-014h], 0
        mov eax, unk_F21FC
        mov edx, dword [dword_D4F9A]
        add edx, eax
        mov dword [byte ebp-028h], edx
        add dword [dword_D4F9A], byte 4
        mov eax, dword [byte ebp-028h]
        mov dword [byte ebp-02Ch], eax
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-024h], eax
loc_9DAF3:
        cmp dword [byte ebp+014h], byte 0
        jg short loc_9DB06
        jmp near loc_9DC91
loc_9DAFE:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-024h]
        jmp short loc_9DAF3
loc_9DB06:
        mov eax, dword [byte ebp-024h]
        mov al, byte [eax]
        mov byte [byte ebp-08h], al
        test byte [byte ebp-08h], 80h
        je short loc_9DB55
        mov al, byte [byte ebp-08h]
        and al, 0F0h
        mov byte [byte ebp-0Ch], al
        mov al, byte [byte ebp-08h]
        and al, 0Fh
        mov byte [byte ebp-04h], al
        mov al, byte [byte ebp-08h]
        and al, 0F0h
        cmp al, 0C0h
        jne short loc_9DB36
        mov dword [byte ebp-030h], 1
        jmp short loc_9DB3D
loc_9DB36:
        mov dword [byte ebp-030h], 2
loc_9DB3D:
        mov al, byte [byte ebp-030h]
        mov byte [byte ebp-010h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-028h]
        mov dword [byte ebp-02Ch], eax
        jmp near loc_9DC8C
loc_9DB55:
        mov al, byte [byte ebp-08h]
        mov edx, dword [byte ebp-02Ch]
        mov byte [edx], al
        inc dword [byte ebp-02Ch]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-010h]
        cmp eax, edx
        jne near loc_9DC8C
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-028h]
        mov dword [byte ebp-02Ch], eax
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-034h], al
        cmp byte [byte ebp-034h], 0B0h
        jb short loc_9DBBD
        cmp byte [byte ebp-034h], 0B0h
        jbe near loc_9DC42
        cmp byte [byte ebp-034h], 0C0h
        jb short loc_9DBB8
        cmp byte [byte ebp-034h], 0C0h
        jbe near loc_9DC44
        cmp byte [byte ebp-034h], 0E0h
        je near loc_9DC5F
        jmp near loc_9DC8C
loc_9DBB8:
        jmp near loc_9DC8C
loc_9DBBD:
        cmp byte [byte ebp-034h], 80h
        jb short loc_9DBD4
        cmp byte [byte ebp-034h], 80h
        jbe short loc_9DBD9
        cmp byte [byte ebp-034h], 90h
        je short loc_9DBF7
        jmp near loc_9DC8C
loc_9DBD4:
        jmp near loc_9DC8C
loc_9DBD9:
        mov eax, dword [byte ebp-028h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call sub_9D805
        add esp, byte 8
        jmp near loc_9DC8C
loc_9DBF7:
        mov eax, dword [byte ebp-028h]
        cmp byte [byte eax+01h], 0
        jne short loc_9DC1B
        mov eax, dword [byte ebp-028h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call sub_9D805
        add esp, byte 8
        jmp short loc_9DC40
loc_9DC1B:
        mov eax, dword [byte ebp-028h]
        mov al, byte [byte eax+01h]
        and eax, 0FFh
        push eax
        mov eax, dword [byte ebp-028h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call sub_9D700
        add esp, byte 0Ch
loc_9DC40:
        jmp short loc_9DC8C
loc_9DC42:
        jmp short loc_9DC8C
loc_9DC44:
        mov eax, dword [byte ebp-028h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call sub_9D858
        add esp, byte 8
        jmp short loc_9DC8C
loc_9DC5F:
        xor ah, ah
        mov edx, dword [byte ebp-028h]
        mov al, byte [edx]
        mov dword [byte ebp-020h], eax
        xor ah, ah
        mov edx, dword [byte ebp-028h]
        mov al, byte [byte edx+01h]
        mov dword [byte ebp-018h], eax
        mov eax, dword [byte ebp-018h]
        shl eax, 7
        mov edx, dword [byte ebp-020h]
        add edx, eax
        mov dword [byte ebp-01Ch], edx
        sub dword [byte ebp-01Ch], 2000h
        shl dword [byte ebp-01Ch], 1
loc_9DC8C:
        jmp near loc_9DAFE
loc_9DC91:
        sub dword [dword_D4F9A], byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_9DC9F:
        push ds
        call __GETDS
sub_9DCA5:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov byte [byte ebp-04h], 0C0h
        mov byte [byte ebp-08h], 1
        mov byte [byte ebp-0Ch], 0
        mov dword [byte ebp-014h], 0
        mov eax, unk_F21FC
        mov edx, dword [dword_D4F9A]
        add edx, eax
        mov dword [byte ebp-020h], edx
        add dword [dword_D4F9A], byte 4
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-018h], eax
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-01Ch], eax
loc_9DCE6:
        cmp word [byte ebp+014h], byte 0
        jg short loc_9DCFA
        jmp near loc_9DE8E
loc_9DCF2:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-01Ch]
        jmp short loc_9DCE6
loc_9DCFA:
        xor ah, ah
        mov edx, dword [byte ebp-01Ch]
        mov al, byte [edx]
        mov word [byte ebp-010h], ax
        test byte [byte ebp-010h], 80h
        je short loc_9DD51
        mov al, byte [byte ebp-010h]
        and al, 0F0h
        mov byte [byte ebp-04h], al
        mov al, byte [byte ebp-010h]
        and al, 0Fh
        mov byte [byte ebp-0Ch], al
        mov eax, dword [byte ebp-010h]
        and eax, 0F0h
        cmp ax, 0C0h
        jne short loc_9DD32
        mov dword [byte ebp-024h], 1
        jmp short loc_9DD39
loc_9DD32:
        mov dword [byte ebp-024h], 2
loc_9DD39:
        mov al, byte [byte ebp-024h]
        mov byte [byte ebp-08h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-018h], eax
        jmp near loc_9DE89
loc_9DD51:
        mov al, byte [byte ebp-010h]
        mov edx, dword [byte ebp-018h]
        mov byte [edx], al
        inc dword [byte ebp-018h]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-08h]
        cmp eax, edx
        jne near loc_9DE89
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-018h], eax
        mov al, byte [byte ebp-04h]
        mov byte [byte ebp-028h], al
        cmp byte [byte ebp-028h], 0B0h
        jb short loc_9DDB9
        cmp byte [byte ebp-028h], 0B0h
        jbe near loc_9DE31
        cmp byte [byte ebp-028h], 0C0h
        jb short loc_9DDB4
        cmp byte [byte ebp-028h], 0C0h
        jbe near loc_9DE53
        cmp byte [byte ebp-028h], 0E0h
        je near loc_9DE6A
        jmp near loc_9DE89
loc_9DDB4:
        jmp near loc_9DE89
loc_9DDB9:
        cmp byte [byte ebp-028h], 80h
        jb short loc_9DDD0
        cmp byte [byte ebp-028h], 80h
        jbe short loc_9DDD5
        cmp byte [byte ebp-028h], 90h
        je short loc_9DDEF
        jmp near loc_9DE89
loc_9DDD0:
        jmp near loc_9DE89
loc_9DDD5:
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        cwde
        call sub_9F685
        jmp near loc_9DE89
loc_9DDEF:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+01h], 0
        jne short loc_9DE0F
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        cwde
        call sub_9F685
        jmp short loc_9DE2F
loc_9DE0F:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        movsx ebx, ax
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        cwde
        call sub_9F725
loc_9DE2F:
        jmp short loc_9DE89
loc_9DE31:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        movsx ebx, ax
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        cwde
        call sub_9FA5D
        jmp short loc_9DE89
loc_9DE53:
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        cwde
        call sub_9FC24
        jmp short loc_9DE89
loc_9DE6A:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        shl eax, 8
        db 081h,0E8h,00h,040h,00h,00h           ; insn: sub eax,4000h
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        cwde
        call sub_9FC94
loc_9DE89:
        jmp near loc_9DCF2
loc_9DE8E:
        sub dword [dword_D4F9A], byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
