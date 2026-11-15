; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B07D0 progbits alloc exec nowrite align=1
extern _dos_close_, _dos_getvect_, _dos_open_, _dos_read_, _dos_setvect_, byte_D86C8, byte_D877A, byte_D8AE4
extern byte_F79A4, byte_F79A6, byte_F79C8, dword_D86DC, dword_D8784, dword_F79BC, dword_F79C0, dword_F79C4
extern inp_, lseek_, outp_, outpw_, sub_B13A1, sub_B14AC, sub_B16BC, sub_B1F9C
extern sub_B2720, unk_F7978, word_D86DA, word_D86E0, word_D8762, word_D8772, word_D8774, word_D8776
extern word_D8788, word_D8ACC, word_F799C, word_F799E, word_F79A0, word_F79A2, word_F79B8, word_F79BA
extern word_F79C9
global sub_B07D0, loc_B0815, loc_B083B, sub_B085C, loc_B08B5, loc_B08D7, sub_B097C, sub_B09A4
global loc_B0A09, sub_B0A14, sub_B0A40, loc_B0A58, sub_B0A5C, loc_B0A71, sub_B0A78, loc_B0A9A
global loc_B0A9D, sub_B0AA4, sub_B0AB0, sub_B0ABC, loc_B0B2F, loc_B0B4B, sub_B0B5C, loc_B0B98
global loc_B0BB4, loc_B0BB9, sub_B0BE4, loc_B0BFD, sub_B0C10, loc_B0C23, loc_B0C2C, sub_B0C34
global loc_B0C47, loc_B0C53, sub_B0C5C, loc_B0C7F, loc_B0C98, loc_B0CAF, sub_B0CB8, loc_B0D14
global loc_B0D3D, loc_B0D4F, sub_B0D6C, loc_B0DA1, loc_B0DDA, loc_B0DEF, loc_B0E02, loc_B0E22
global loc_B0E4B, loc_B0E50, loc_B0E69, loc_B0E72, sub_B0E7C, loc_B0E95, loc_B0EBB, loc_B0EDB
global loc_B0F0B, loc_B0F10, loc_B0F2B, loc_B0F59, loc_B0F9F, sub_B0FA8, loc_B0FB6, loc_B0FE0
global loc_B0FE6, loc_B0FFC, loc_B1003, loc_B1019, loc_B101B, sub_B1024, sub_B103C, loc_B10BB
global sub_B10D0, loc_B10F6, loc_B10F8, loc_B1129, loc_B112B, loc_B116E, loc_B11BA, loc_B11C0
global sub_B121C, sub_B122F, sub_B1237, loc_B1250, loc_B1252, sub_B1256, loc_B126E, loc_B1289
sub_B07D0:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        mov ebx, eax
        shl eax, 4
        add eax, ebx
        add eax, unk_F7978
        mov word [byte eax+0Fh], dx
        mov ebx, edx
        and bl, 3
        xor bh, dh
        cmp edx, byte 3
        jg short loc_B0815
        mov word [byte eax+09h], 0Ah
        mov word [byte eax+0Bh], 0Bh
        mov word [byte eax+0Dh], 0Ch
        mov ecx, ebx
        add ecx, ebx
        mov word [byte eax+05h], cx
        mov cx, word [byte eax+05h]
        or cl, 1
        jmp short loc_B083B
loc_B0815:
        mov word [byte eax+09h], 0D4h
        mov word [byte eax+0Bh], 0D6h
        mov word [byte eax+0Dh], 0D8h
        mov ecx, ebx
        shl ecx, 2
        mov esi, ecx
        or esi, 0C0h
        mov word [byte eax+05h], si
        or cl, 0C2h
loc_B083B:
        mov word [byte eax+07h], cx
        mov byte [byte eax+01h], bl
        or bl, 4
        mov byte [eax], bl
        mov dl, byte [nosplit edx*2+byte_D86C8]
        mov byte [byte eax+02h], dl
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
sub_B085C:
        push ebp
        mov ebp, esp
        push esi
        sub esp, byte 10h
        mov esi, ebx
        mov ebx, eax
        shl ebx, 4
        add ebx, eax
        add ebx, unk_F7978
        mov ax, word [byte ebx+0Fh]
        and al, 3
        xor ah, ah
        or esi, eax
        cmp word [byte ebx+0Fh], byte 4
        jb short loc_B08B5
        sub edx, byte 2
        mov eax, edx
        shr eax, 1
        mov byte [byte ebp-0Ch], al
        xor eax, eax
        shr edx, 9
        mov ax, word [byte ebp+08h]
        mov byte [byte ebp-014h], dl
        mov edx, eax
        sar edx, 1
        sar eax, 9
        mov byte [byte ebp-010h], dl
        mov byte [byte ebp-08h], al
        test cl, 1
        je short loc_B08D7
        mov ah, al
        or ah, 80h
        mov byte [byte ebp-08h], ah
        jmp short loc_B08D7
loc_B08B5:
        mov al, dl
        dec al
        mov byte [byte ebp-0Ch], al
        lea eax, [byte edx-01h]
        shr eax, 8
        mov byte [byte ebp-014h], al
        mov al, byte [byte ebp+08h]
        mov byte [byte ebp-010h], al
        xor eax, eax
        mov ax, word [byte ebp+08h]
        sar eax, 8
        mov byte [byte ebp-08h], al
loc_B08D7:
        xor edx, edx
        pushfw
        cli
        mov dl, byte [ebx]
        xor eax, eax
        mov ax, word [byte ebx+09h]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, si
        mov ax, word [byte ebx+0Bh]
        call outp_
        xor eax, eax
        mov ax, word [byte ebx+0Dh]
        xor edx, edx
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-010h]
        mov ax, word [byte ebx+05h]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-08h]
        mov ax, word [byte ebx+05h]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, cx
        mov al, byte [byte ebx+02h]
        call outp_
        xor eax, eax
        mov ax, word [byte ebx+0Dh]
        xor edx, edx
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-0Ch]
        mov ax, word [byte ebx+07h]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-014h]
        mov ax, word [byte ebx+07h]
        call outp_
        xor edx, edx
        mov dl, byte [byte ebx+01h]
        xor eax, eax
        mov ax, word [byte ebx+09h]
        call outp_
        popfw
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 4
sub_B097C:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        shl eax, 4
        add eax, edx
        add eax, unk_F7978
        xor edx, edx
        mov dl, byte [eax]
        mov ax, word [byte eax+09h]
        and eax, 0FFFFh
        call outp_
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
sub_B09A4:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        shl eax, 4
        add eax, ebx
        mov ebx, unk_F7978
        add ebx, eax
        pushfw
        cli
        xor eax, eax
        mov ax, word [byte ebx+0Dh]
        xor edx, edx
        call outp_
        xor eax, eax
        mov ax, word [byte ebx+07h]
        call inp_
        mov edx, eax
        xor eax, eax
        mov ax, word [byte ebx+07h]
        call inp_
        mov ecx, eax
        popfw
        mov al, cl
        xor ah, ah
        and eax, 0FFFFh
        xor dh, dh
        shl eax, 8
        and edx, 0FFFFh
        add eax, edx
        inc eax
        and eax, 0FFFFh
        cmp word [byte ebx+0Fh], byte 4
        jb short loc_B0A09
        add eax, eax
loc_B0A09:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
sub_B0A14:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        sub esp, byte 4
        lea esi, [byte ebp-0Ch]
        push esi
        xor esi, esi
        mov ecx, ds
        mov si, bx
        mov ebx, edx
        mov edx, esi
        call _dos_read_
        mov word [word_F799C], ax
        mov eax, dword [byte ebp-0Ch]
        lea esp, [byte ebp-08h]
        pop esi
        pop ecx
        pop ebp
        ret
sub_B0A40:
        push ebp
        mov ebp, esp
        call _dos_close_
        mov word [word_F799C], ax
        test ax, ax
        je short loc_B0A58
        mov eax, 10h
loc_B0A58:
        mov esp, ebp
        pop ebp
        ret
sub_B0A5C:
        push ebp
        mov ebp, esp
        call lseek_
        test eax, eax
        jge short loc_B0A71
        mov eax, 10h
        mov esp, ebp
        pop ebp
        ret
loc_B0A71:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret
        db 090h
sub_B0A78:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        sub esp, byte 4
        lea ebx, [byte ebp-0Ch]
        xor edx, edx
        call _dos_open_
        mov word [word_F799C], ax
        test ax, ax
        jne short loc_B0A9A
        mov eax, dword [byte ebp-0Ch]
        jmp short loc_B0A9D
loc_B0A9A:
        cwde
        neg eax
loc_B0A9D:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
sub_B0AA4:
        push ebp
        mov ebp, esp
        call _dos_setvect_
        mov esp, ebp
        pop ebp
        ret
sub_B0AB0:
        push ebp
        mov ebp, esp
        call _dos_getvect_
        mov esp, ebp
        pop ebp
        ret
sub_B0ABC:
        push ebp
        mov ebp, esp
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov dword [byte ebp-010h], eax
        mov edi, ecx
        mov esi, ebx
        mov ecx, dword [byte ebp-010h]
        xor ebx, ebx
        pushfw
        cli
        mov bx, word [nosplit ecx*8+word_D86DA]
        mov eax, ebx
        call sub_B0AB0
        mov word [nosplit ecx*8+word_D86E0], dx
        mov dword [nosplit ecx*8+dword_D86DC], eax
        mov eax, ebx
        mov ecx, edi
        mov ebx, esi
        call sub_B0AA4
        mov cl, byte [byte ebp-010h]
        mov dl, 1
        and cl, 7
        shl dl, cl
        mov ebx, dword [byte ebp-010h]
        not dl
        cmp ebx, byte 7
        jg short loc_B0B2F
        mov eax, 21h
        call inp_
        and eax, 0FFh
        and edx, 0FFh
        and edx, eax
        mov eax, 21h
        jmp short loc_B0B4B
loc_B0B2F:
        mov eax, 0A1h
        call inp_
        and eax, 0FFh
        and edx, 0FFh
        and edx, eax
        mov eax, 0A1h
loc_B0B4B:
        call outp_
        popfw
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop edx
        pop ebp
        ret
        db 08Bh,0C0h
sub_B0B5C:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        pushfw
        cli
        cmp ebx, byte 2
        je short loc_B0BB9
        mov cl, bl
        mov dl, 1
        and cl, 7
        shl dl, cl
        cmp ebx, byte 7
        jg short loc_B0B98
        mov eax, 21h
        call inp_
        and eax, 0FFh
        and edx, 0FFh
        or edx, eax
        mov eax, 21h
        jmp short loc_B0BB4
loc_B0B98:
        mov eax, 0A1h
        call inp_
        and eax, 0FFh
        and edx, 0FFh
        or edx, eax
        mov eax, 0A1h
loc_B0BB4:
        call outp_
loc_B0BB9:
        xor eax, eax
        mov cx, word [nosplit ebx*8+word_D86E0]
        mov ax, word [nosplit ebx*8+word_D86DA]
        mov ebx, dword [nosplit ebx*8+dword_D86DC]
        call sub_B0AA4
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
sub_B0BE4:
        push ebp
        mov ebp, esp
        push edx
        cmp ax, 7
        jbe short loc_B0BFD
        mov eax, 0A0h
        mov edx, 20h
        call outp_
loc_B0BFD:
        mov eax, 20h
        mov edx, eax
        call outp_
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 00h
sub_B0C10:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        cmp byte [dword eax+byte_D877A], 0
        jne short loc_B0C23
        mov al, 3
        jmp short loc_B0C2C
loc_B0C23:
        xor eax, eax
        call sub_B07D0
        xor al, al
loc_B0C2C:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Bh,0C0h
sub_B0C34:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        cmp byte [dword eax+byte_D877A], 0
        jne short loc_B0C47
        mov al, 3
        jmp short loc_B0C53
loc_B0C47:
        mov eax, 1
        call sub_B07D0
        xor al, al
loc_B0C53:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Dh,040h,00h
sub_B0C5C:
        push ebp
        mov ebp, esp
        mov byte [byte_D8AE4], 1
        xor eax, eax
        mov al, byte [byte_F79A4]
        call sub_B0C10
        test al, al
        je short loc_B0C7F
        and eax, 0FFh
        mov esp, ebp
        pop ebp
        ret
loc_B0C7F:
        xor eax, eax
        mov al, byte [byte_F79A6]
        call sub_B0C34
        test al, al
        je short loc_B0C98
        and eax, 0FFh
        mov esp, ebp
        pop ebp
        ret
loc_B0C98:
        mov eax, sub_B0E7C
        call sub_B14AC
        test eax, eax
        je short loc_B0CAF
        mov eax, 8
        mov esp, ebp
        pop ebp
        ret
loc_B0CAF:
        mov dword [dword_D8784], eax
        mov esp, ebp
        pop ebp
        ret
sub_B0CB8:
        push ebp
        mov ebp, esp
        push esi
        mov esi, eax
        xor si, ax
        shr esi, 10h
        mov word [word_F79BA], si
        mov word [word_F79B8], ax
        mov dword [dword_F79BC], edx
        mov eax, dword [byte ebp+08h]
        mov word [word_F79C9], ax
        xor edx, edx
        mov dword [dword_F79C0], edx
        mov dword [dword_F79C4], edx
        mov dl, cl
        mov ah, byte [byte ebp+08h]
        or dl, 4
        test ah, 1
        je short loc_B0D3D
        test cl, 4
        jne short loc_B0D14
        cmp byte [byte_F79A4], 4
        jb short loc_B0D14
        mov eax, ebx
        call sub_B2720
        mov cl, dl
        mov ebx, eax
loc_B0D14:
        xor eax, eax
        mov edx, 42h
        mov ax, word [word_D8772]
        shr ebx, 4
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D8774]
        mov dx, bx
        call outpw_
        jmp short loc_B0D4F
loc_B0D3D:
        cmp byte [byte_F79A6], 4
        jb short loc_B0D4F
        mov eax, ebx
        call sub_B2720
        mov cl, dl
loc_B0D4F:
        or cl, 21h
        mov byte [byte_F79C8], cl
        xor eax, eax
        mov ax, word [byte ebp+08h]
        call sub_B0E7C
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 4
        db 090h
sub_B0D6C:
        push ebp
        mov ebp, esp
        push esi
        push edi
        sub esp, byte 14h
        mov dword [byte ebp-01Ch], eax
        mov esi, edx
        mov dword [byte ebp-010h], ebx
        mov byte [byte ebp-0Ch], cl
        pushfw
        cli
        call sub_B122F
        cmp dword [dword_D8784], byte 0
        je short loc_B0DA1
        call sub_B1256
        popfw
        mov eax, 7
        jmp near loc_B0E72
loc_B0DA1:
        mov dword [dword_D8784], 1
        mov eax, dword [byte ebp-01Ch]
        mov eax, dword [byte eax+04h]
        mov edi, dword [byte ebp-01Ch]
        mov dword [byte ebp-014h], eax
        mov ah, byte [byte ebp+08h]
        mov edi, dword [edi]
        test ah, 1
        je near loc_B0E50
        cmp byte [byte_F79A4], 4
        jb short loc_B0E02
        test byte [byte ebp-014h], 1
        je short loc_B0E02
        test byte [byte ebp-010h], 1
        jne short loc_B0E02
loc_B0DDA:
        test esi, esi
        je short loc_B0DEF
        mov edx, dword [byte ebp-010h]
        mov eax, edi
        xor ecx, ecx
        mov ebx, esi
        mov cl, byte [byte ebp-0Ch]
        call sub_B1F9C
loc_B0DEF:
        mov dx, word [word_F799E]
        or dl, 4
        mov word [word_F799E], dx
        jmp short loc_B0E69
loc_B0E02:
        mov eax, dword [byte ebp-010h]
        and al, 1Fh
        xor ah, ah
        test ax, ax
        je short loc_B0E4B
        mov ecx, 20h
        sub ecx, eax
        mov eax, ecx
        xor ecx, ecx
        mov cx, ax
        cmp ecx, esi
        jbe short loc_B0E22
        mov eax, esi
loc_B0E22:
        xor ecx, ecx
        mov cl, byte [byte ebp-0Ch]
        and eax, 0FFFFh
        mov dword [byte ebp-018h], eax
        mov edx, dword [byte ebp-010h]
        mov ebx, dword [byte ebp-018h]
        mov eax, edi
        call sub_B1F9C
        mov ecx, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        sub esi, ecx
        add edx, ecx
        add edi, ecx
        mov dword [byte ebp-014h], edx
loc_B0E4B:
        cmp esi, byte 20h
        jb short loc_B0DDA
loc_B0E50:
        mov ebx, dword [byte ebp-010h]
        xor eax, eax
        mov edx, esi
        mov ax, word [byte ebp+08h]
        xor ecx, ecx
        push eax
        mov cl, byte [byte ebp-0Ch]
        mov eax, dword [byte ebp-014h]
        call sub_B0CB8
loc_B0E69:
        call sub_B1256
        popfw
        xor eax, eax
loc_B0E72:
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 4
        db 090h
sub_B0E7C:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        cmp dword [dword_D8784], byte 0
        jne short loc_B0E95
        xor eax, eax
        jmp near loc_B0F9F
loc_B0E95:
        mov eax, dword [dword_F79C0]
        add dword [dword_F79C4], eax
        mov esi, dword [dword_F79BC]
        test esi, esi
        jne short loc_B0EBB
        mov dword [dword_D8784], esi
        xor eax, eax
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_B0EBB:
        xor esi, esi
        mov si, word [word_F79B8]
        mov eax, 10000h
        sub eax, esi
        mov esi, eax
        cmp esi, dword [dword_F79BC]
        jbe short loc_B0EDB
        mov esi, dword [dword_F79BC]
loc_B0EDB:
        mov dword [dword_F79C0], esi
        pushfw
        cli
        test dl, 1
        je short loc_B0F2B
        xor eax, eax
        mov ax, word [word_F79B8]
        xor ecx, ecx
        mov cx, word [word_F79BA]
        push eax
        test byte [byte_F79C8], 2
        je short loc_B0F0B
        mov eax, 44h
        jmp short loc_B0F10
loc_B0F0B:
        mov eax, 48h
loc_B0F10:
        xor ebx, ebx
        mov bx, ax
        mov edx, dword [dword_F79C0]
        xor eax, eax
        call sub_B085C
        xor eax, eax
        mov edx, 41h
        jmp short loc_B0F59
loc_B0F2B:
        xor eax, eax
        mov ax, word [word_F79B8]
        xor ecx, ecx
        mov cx, word [word_F79BA]
        push eax
        mov edx, dword [dword_F79C0]
        mov eax, 1
        mov ebx, 44h
        call sub_B085C
        xor eax, eax
        mov edx, 49h
loc_B0F59:
        mov ax, word [word_D8772]
        call outp_
        xor edx, edx
        mov dl, byte [byte_F79C8]
        xor eax, eax
        mov ax, word [word_D8776]
        call outp_
        call sub_B13A1
        popfw
        sub dword [dword_F79BC], esi
        add word [word_F79B8], si
        mov ax, word [word_F79BA]
        inc word [word_F79BA]
        mov eax, 1
loc_B0F9F:
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
sub_B0FA8:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        pushfw
        cli
        mov edx, 1D4C0h
loc_B0FB6:
        cmp dword [dword_D8784], byte 0
        je short loc_B1003
        dec edx
        je short loc_B1003
        xor eax, eax
        cli
        mov ax, word [word_D8762]
        call inp_
        test al, 80h
        jne short loc_B0FE0
        mov bx, word [word_F799E]
        test bl, 4
        je short loc_B0FE6
loc_B0FE0:
        call sub_B16BC
        cli
loc_B0FE6:
        mov cx, word [word_F799E]
        test cl, 2
        je short loc_B0FFC
        and word [word_F799E], byte 0FFFDh
        jmp short loc_B0FE0
loc_B0FFC:
        call sub_B13A1
        jmp short loc_B0FB6
loc_B1003:
        popfw
        cmp dword [dword_D8784], byte 0
        je short loc_B1019
        test edx, edx
        jne short loc_B1019
        mov eax, 9
        jmp short loc_B101B
loc_B1019:
        xor eax, eax
loc_B101B:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
sub_B1024:
        push ebp
        mov ebp, esp
        cmp dword [dword_D8784], byte 0
        sete al
        and eax, 0FFh
        mov esp, ebp
        pop ebp
        ret
        db 08Bh,0C0h
sub_B103C:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        pushfw
        cli
        cmp dword [dword_D8784], byte 0
        je short loc_B10BB
        xor ebx, ebx
        mov dword [dword_D8784], ebx
        xor eax, eax
        call sub_B097C
        mov eax, 1
        call sub_B097C
        and byte [byte_F79C8], 0DEh
        xor eax, eax
        mov edx, 41h
        mov ax, word [word_D8772]
        call outp_
        xor edx, edx
        mov dl, byte [byte_F79C8]
        xor eax, eax
        mov ax, word [word_D8776]
        call outp_
        xor eax, eax
        mov edx, 49h
        mov ax, word [word_D8772]
        call outp_
        xor edx, edx
        mov dl, byte [byte_F79C8]
        xor eax, eax
        mov ax, word [word_D8776]
        call outp_
loc_B10BB:
        popfw
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
sub_B10D0:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        pushfw
        cli
        call sub_B122F
        mov ah, byte [byte ebx+048h]
        mov ecx, dword [byte ebx+014h]
        test ah, 1
        je short loc_B10F6
        mov eax, ecx
        call sub_B2720
        mov edx, eax
        jmp short loc_B10F8
loc_B10F6:
        mov edx, ecx
loc_B10F8:
        mov eax, edx
        xor ah, dh
        shr edx, 7
        and edx, 1FFFh
        mov word [byte ebx+020h], dx
        and al, 7Fh
        mov edx, dword [ebx]
        shl eax, 9
        add ecx, edx
        mov dl, byte [byte ebx+048h]
        mov word [byte ebx+01Eh], ax
        test dl, 1
        je short loc_B1129
        mov eax, ecx
        call sub_B2720
        mov edx, eax
        jmp short loc_B112B
loc_B1129:
        mov edx, ecx
loc_B112B:
        mov eax, edx
        and al, 7Fh
        xor ah, dh
        shl eax, 9
        shr edx, 7
        mov word [byte ebx+022h], ax
        and edx, 1FFFh
        mov al, byte [byte ebx+034h]
        xor ah, ah
        mov word [byte ebx+024h], dx
        and al, 0Fh
        mov dx, word [byte ebx+022h]
        shl eax, 5
        or edx, eax
        mov word [byte ebx+022h], dx
        mov ecx, dword [byte ebx+04h]
        mov eax, dword [byte ebx+014h]
        mov dh, byte [byte ebx+048h]
        add eax, ecx
        test dh, 1
        je short loc_B116E
        call sub_B2720
loc_B116E:
        mov edx, eax
        mov eax, edx
        and al, 7Fh
        xor ah, dh
        shl eax, 9
        mov word [byte ebx+026h], ax
        mov eax, edx
        shr eax, 7
        and eax, 1FFFh
        mov word [byte ebx+028h], ax
        mov al, byte [byte ebx+034h]
        xor ah, ah
        and al, 0F0h
        mov cx, word [byte ebx+026h]
        add eax, eax
        or ecx, eax
        mov word [byte ebx+026h], cx
        mov cl, byte [byte ebx+048h]
        mov eax, dword [byte ebx+014h]
        test cl, 1
        je short loc_B11BA
        mov edx, dword [byte ebx+030h]
        sub edx, byte 2
        add eax, edx
        call sub_B2720
        mov edx, eax
        jmp short loc_B11C0
loc_B11BA:
        add eax, dword [byte ebx+030h]
        lea edx, [byte eax-01h]
loc_B11C0:
        mov eax, edx
        and al, 7Fh
        xor ah, dh
        shr edx, 7
        shl eax, 9
        and edx, 1FFFh
        mov word [byte ebx+02Ah], ax
        xor eax, eax
        mov word [byte ebx+02Ch], dx
        mov ax, word [word_F79A0]
        mov ax, word [nosplit eax*2+word_D8ACC]
        and eax, 0FFFFh
        xor edx, edx
        xor ecx, ecx
        mov dx, word [byte ebx+01Ah]
        shl eax, 9
        sar edx, 1
        mov cx, word [byte ebx+01Ah]
        add eax, edx
        xor edx, edx
        div ecx
        mov word [byte ebx+02Eh], ax
        call sub_B1256
        popfw
        xor eax, eax
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h
sub_B121C:
        mov word [word_D8788], 0
        mov word [word_F79A2], 0
        ret
sub_B122F:
        inc word [word_F79A2]
        ret
sub_B1237:
        pushfw
        cli
        cmp word [word_F79A2], byte 0
        jne short loc_B1250
        call sub_B122F
        mov eax, 1
        jmp short loc_B1252
loc_B1250:
        LD xor, eax, eax
loc_B1252:
        popfw
        ret
        ret
sub_B1256:
        pushfw
        cli
        dec word [word_F79A2]
        cmp word [word_F79A2], byte 0
        jne short loc_B1289
        nop
        nop
        nop
        nop
loc_B126E:
        test byte [word_F799E], 6
        je short loc_B1289
        nop
        nop
        nop
        nop
        and byte [word_F799E], 0FDh
        call sub_B16BC
        jmp short loc_B126E
loc_B1289:
        popfw
        ret
