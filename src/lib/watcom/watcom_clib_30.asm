; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_99A12 progbits alloc exec nowrite align=1
extern __set_doserrno_, __set_errno_, _osmajor, dword_D4CF0, dword_D4CF4, dword_D4FF1, dword_F243C, dword_F2440
extern dword_F24C0, dword_F58D8, dword_F58DC, exit_, itoa_, ltoa_, main_, off_D2F68
extern off_D5668, CMainHook, __CommonInit_, toupper_, ultoa_, unk_D8B14, unk_D8B3E, unk_D8B4A
global copypart_, loc_99A21, loc_99A41, _splitpath_, loc_99A6C, loc_99A71, loc_99A78, loc_99A7C
global loc_99A7E, loc_99A8D, loc_99A96, loc_99A9A, loc_99AB2, pickup_, loc_99AEA, loc_99AF1
global loc_99AF3, _makepath_, loc_99B15, loc_99B21, loc_99B40, loc_99B4B, loc_99B4D, loc_99B57
global loc_99B76, loc_99B8D, loc_99B96, loc_99BA8, loc_99BA9, loc_99BB4, _Full_at_exit_rtn_, loc_99BDA
global loc_99BF0, atexit_, loc_99C29, __CMain, loc_99C53, loc_99C55, sub_99C77, __InitRtns
global loc_99C89, loc_99C99, loc_99CAC, loc_99CB1, loc_99CC2, loc_99CC7, __FiniRtns, loc_99CD5
global loc_99CE5, loc_99CF8, loc_99CFD, loc_99D12, loc_99D17, __prtf_, loc_99D46, loc_99D82
global loc_99D8B, loc_99D99, loc_99D9F, loc_99DC1, loc_99DCC, loc_99DEA, loc_99DF8, loc_99E01
global loc_99E0C, loc_99E20, loc_99E33, loc_99E41, loc_99E66, loc_99E83, loc_99E87, loc_99E9C
global loc_99EBA, loc_99EC8, loc_99EE5, loc_99EF3, loc_99EFA, loc_99F1B, loc_99F3A, loc_99F59
global loc_99F6F, loc_99F91, getprintspecs_, loc_99FC6, loc_99FE5, loc_9A00B, loc_9A00C, loc_9A03D
global loc_9A040, loc_9A05F, loc_9A07B, loc_9A084, loc_9A094, loc_9A0A2, loc_9A0B1, loc_9A0B5
global loc_9A0BB, loc_9A0C1, loc_9A0CC, evalflags_, loc_9A0D6, loc_9A0E3, loc_9A0EE, loc_9A106
global loc_9A11D, loc_9A125, loc_9A128, far_strlen_, loc_9A137, loc_9A14A, far_other_strlen_, loc_9A15B
global fmt4hex_, loc_9A1AA, loc_9A1B2, loc_9A1B9, loc_9A1C4, FixedPoint_Format_, loc_9A1EF, loc_9A1FC
global loc_9A211, loc_9A21E, loc_9A22D, loc_9A248, loc_9A250, loc_9A257, loc_9A261, loc_9A26F
global loc_9A27C, loc_9A284, loc_9A28D, loc_9A294, loc_9A2A2, loc_9A2A7, float_format_, formstring_
global loc_9A2EE, loc_9A2F2, loc_9A2F6, loc_9A302, loc_9A316, loc_9A328, loc_9A332, loc_9A336
global loc_9A340, loc_9A381, loc_9A38E, loc_9A3A5, loc_9A3CC, loc_9A3D9, loc_9A3E1, loc_9A3E8
global loc_9A3EC, loc_9A416, loc_9A42A, loc_9A43A, loc_9A443, loc_9A452, loc_9A45B, loc_9A465
global loc_9A478, loc_9A47F, loc_9A492, loc_9A4A5, loc_9A4C4, loc_9A4C8, loc_9A4CF, loc_9A4E2
global loc_9A4E6, loc_9A4F9, loc_9A4FB, loc_9A524, loc_9A52F, loc_9A545, loc_9A551, loc_9A569
global loc_9A56E, loc_9A58D, loc_9A5A2, loc_9A5A9, loc_9A5E8, loc_9A5F1, loc_9A60C, loc_9A639
global loc_9A663, loc_9A67D, loc_9A68B, loc_9A694, loc_9A698, loc_9A6A4, loc_9A6A9, loc_9A6BC
global loc_9A6C8, loc_9A6D1, zupstr_, loc_9A701, loc_9A714, __doserror_, loc_9A726, loc_9A728
global sub_9A729, _dosretax_, __set_errno_dos_, loc_9A75E, loc_9A767, loc_9A76E, loc_9A775, loc_9A784
global loc_9A78E
copypart_:
        push esi
        push edi
        push ebp
        mov ebp, eax
        test eax, eax
        je short loc_99A41
        cmp ebx, ecx
        jle short loc_99A21
        mov ebx, ecx
loc_99A21:
        mov edi, ebp
        mov esi, edx
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
        mov byte [ebx+ebp], 0
loc_99A41:
        pop ebp
        pop edi
        pop esi
        ret
_splitpath_:
        push esi
        db 057h                                 ; insn: push edi
        db 055h                                 ; insn: push ebp
        sub esp, byte 4
        mov esi, eax
        mov dword [esp], ecx
        cmp byte [eax], 0
        je short loc_99A71
        mov cl, byte [byte esi+01h]
        cmp cl, 3Ah
        jne short loc_99A71
        test edx, edx
        je short loc_99A6C
        mov al, byte [esi]
        mov byte [byte edx+02h], 0
        mov byte [edx], al
        mov byte [byte edx+01h], cl
loc_99A6C:
        add esi, byte 2
        jmp short loc_99A78
loc_99A71:
        test edx, edx
        je short loc_99A78
        mov byte [edx], 0
loc_99A78:
        mov ebp, esi
        mov edx, esi
loc_99A7C:
        xor edi, edi
loc_99A7E:
        mov al, byte [esi]
        test al, al
        je short loc_99A9A
        cmp al, 2Eh
        jne short loc_99A8D
        mov edi, esi
        inc esi
        jmp short loc_99A7E
loc_99A8D:
        inc esi
        cmp al, 5Ch
        je short loc_99A96
        cmp al, 2Fh
        jne short loc_99A7E
loc_99A96:
        mov ebp, esi
        jmp short loc_99A7C
loc_99A9A:
        mov ecx, ebp
        sub ecx, edx
        mov eax, ebx
        mov ebx, ecx
        mov ecx, 81h
        call copypart_
        test edi, edi
        jne short loc_99AB2
        mov edi, esi
loc_99AB2:
        mov eax, dword [esp]
        mov ecx, 8
        mov ebx, edi
        mov edx, ebp
        sub ebx, ebp
        call copypart_
        mov eax, dword [byte esp+014h]
        mov ecx, 4
        mov ebx, esi
        mov edx, edi
        sub ebx, edi
        call copypart_
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret 4
pickup_:
        cmp al, 5Ch
        je short loc_99AEA
        cmp al, 2Fh
        jne short loc_99AF3
loc_99AEA:
        cmp byte [edx], 0
        jne short loc_99AF1
        mov byte [edx], al
loc_99AF1:
        mov al, byte [edx]
loc_99AF3:
        ret
_makepath_:
        push esi
        push edi
        sub esp, byte 4
        mov edi, dword [byte esp+010h]
        mov esi, eax
        xor ah, ah
        mov byte [esp], ah
        test edx, edx
        je short loc_99B15
        mov al, byte [edx]
        test al, al
        je short loc_99B15
        mov byte [esi], al
        inc esi
        mov byte [esi], 3Ah
        inc esi
loc_99B15:
        mov byte [esi], 0
        test ebx, ebx
        je short loc_99B4D
        cmp byte [ebx], 0
        je short loc_99B4D
loc_99B21:
        xor eax, eax
        mov edx, esp
        mov al, byte [ebx]
        inc ebx
        call pickup_
        mov byte [esi], al
        mov dl, byte [ebx]
        inc esi
        test dl, dl
        jne short loc_99B21
        cmp byte [esp], 0
        jne short loc_99B40
        mov byte [esp], 5Ch
loc_99B40:
        mov bh, byte [esp]
        cmp bh, byte [byte esi-01h]
        jne short loc_99B4B
        dec esi
        jmp short loc_99B4D
loc_99B4B:
        mov byte [esi], bh
loc_99B4D:
        cmp byte [esp], 0
        jne short loc_99B57
        mov byte [esp], 5Ch
loc_99B57:
        lea ebx, [byte esi+01h]
        test ecx, ecx
        je short loc_99B8D
        xor eax, eax
        mov edx, esp
        mov al, byte [ecx]
        call pickup_
        mov dh, byte [esp]
        cmp al, dh
        je short loc_99B76
        cmp dh, byte [esi]
        jne short loc_99B76
        mov esi, ebx
loc_99B76:
        mov dl, byte [ecx]
        test dl, dl
        je short loc_99B96
        xor eax, eax
        mov al, dl
        mov edx, esp
        inc ecx
        call pickup_
        mov byte [esi], al
        inc esi
        jmp short loc_99B76
loc_99B8D:
        mov dl, byte [esp]
        cmp dl, byte [esi]
        jne short loc_99B96
        mov esi, ebx
loc_99B96:
        test edi, edi
        je short loc_99BB4
        mov dh, byte [edi]
        test dh, dh
        je short loc_99BB4
        cmp dh, 2Eh
        je short loc_99BA9
        mov byte [esi], 2Eh
loc_99BA8:
        inc esi
loc_99BA9:
        mov bh, byte [edi]
        test bh, bh
        je short loc_99BB4
        inc edi
        mov byte [esi], bh
        jmp short loc_99BA8
loc_99BB4:
        mov byte [esi], 0
        add esp, byte 4
        pop edi
        pop esi
        ret 4
_Full_at_exit_rtn_:
        push ebx
        push edx
        sub esp, byte 4
        mov edx, 20h
        mov ebx, dword [dword_F24C0]
        mov dword [dword_F24C0], edx
        mov edx, ebx
        shl edx, 2
loc_99BDA:
        test edx, edx
        je short loc_99BF0
        mov eax, dword [dword edx+dword_F243C]
        sub edx, byte 4
        mov dword [esp], eax
        dec ebx
        call dword [esp]
        jmp short loc_99BDA
loc_99BF0:
        add esp, byte 4
        pop edx
        pop ebx
        ret
atexit_:
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov edx, _Full_at_exit_rtn_
        mov ecx, dword [dword_F24C0]
        mov dword [off_D2F68], edx
        cmp ecx, byte 20h
        jge short loc_99C29
        mov eax, ecx
        lea edx, [byte ecx+01h]
        mov dword [nosplit ecx*4+dword_F2440], ebx
        mov dword [dword_F24C0], edx
        xor eax, ecx
        pop edx
        pop ecx
        pop ebx
        ret
loc_99C29:
        mov eax, 0FFFFFFFFh
        pop edx
        pop ecx
        pop ebx
        ret
__CMain:
        push edx
        push ebp
        mov ebp, esp
        mov edx, dword [dword_D4CF0]
        add edx, byte 3
        and dl, 0FCh
        call CMainHook
        cmp edx, eax
        jae short loc_99C53
        mov eax, edx
        sub esp, eax
        mov eax, esp
        jmp short loc_99C55
loc_99C53:
        xor eax, eax
loc_99C55:
        mov edx, dword [dword_D4CF0]
        add eax, edx
        mov dword [dword_D4CF4], eax
        call __CommonInit_
        mov edx, dword [dword_F58DC]
        mov eax, dword [dword_F58D8]
        call main_
sub_99C77:
        call exit_
        db 089h,0ECh,05Dh,05Ah,0C3h,00h
__InitRtns:
        push esi
        push edi
        push ebx
        push edx
        push es
        mov edx, eax
loc_99C89:
        db 03Eh,0BEh                            ; insn: mov esi,18B14h
        dd unk_D8B14
        db 03Eh,0BFh                            ; insn: mov edi,18B3Eh
        dd unk_D8B3E
        mov ebx, edi
        mov al, dl
loc_99C99:
        cmp esi, edi
        jae short loc_99CB1
        cmp byte [esi], 2
        je short loc_99CAC
        cmp byte [byte esi+01h], al
        ja short loc_99CAC
        mov ebx, esi
        mov al, byte [byte esi+01h]
loc_99CAC:
        add esi, byte 6
        jmp short loc_99C99
loc_99CB1:
        cmp ebx, edi
        je short loc_99CC7
        mov eax, dword [byte ebx+02h]
        or eax, eax
        je short loc_99CC2
        push ds
        pop es
        push edx
        call eax
        pop edx
loc_99CC2:
        mov byte [ebx], 2
        jmp short loc_99C89
loc_99CC7:
        pop es
        pop edx
        pop ebx
        pop edi
        pop esi
        ret
__FiniRtns:
        push esi
        push edi
        push ebx
        push es
        mov dh, dl
        mov dl, al
loc_99CD5:
        db 03Eh,0BEh                            ; insn: mov esi,18B3Eh
        dd unk_D8B3E
        db 03Eh,0BFh                            ; insn: mov edi,18B4Ah
        dd unk_D8B4A
        mov ebx, edi
        mov al, dl
loc_99CE5:
        cmp esi, edi
        jae short loc_99CFD
        cmp byte [esi], 2
        je short loc_99CF8
        cmp al, byte [byte esi+01h]
        ja short loc_99CF8
        mov ebx, esi
        mov al, byte [byte esi+01h]
loc_99CF8:
        add esi, byte 6
        jmp short loc_99CE5
loc_99CFD:
        cmp ebx, edi
        je short loc_99D17
        cmp al, dh
        ja short loc_99D12
        mov eax, dword [byte ebx+02h]
        or eax, eax
        je short loc_99D12
        push ds
        pop es
        push edx
        call eax
        pop edx
loc_99D12:
        mov byte [ebx], 2
        jmp short loc_99CD5
loc_99D17:
        pop es
        pop ebx
        pop edi
        pop esi
        ret
__prtf_:
        push esi
        push edi
        push es
        push ebp
        sub esp, byte 4Ch
        mov esi, ebx
        mov dword [byte esp+044h], ecx
        xor bl, bl
        mov dword [byte esp+028h], eax
        mov byte [byte esp+048h], bl
        mov byte [byte esp+03Ch], bl
        xor ebx, ebx
        mov edi, edx
        mov dword [byte esp+038h], ebx
        mov ebp, 4
        jmp short loc_99D9F
loc_99D46:
        lea ebx, [byte esp+028h]
        mov edx, esi
        call getprintspecs_
        mov edi, eax
        mov al, byte [eax]
        inc edi
        mov byte [byte esp+03Dh], al
        test al, al
        je near loc_99F91
        cmp al, 6Eh
        jne near loc_99E41
        mov bl, byte [byte esp+03Ch]
        test bl, 20h
        je short loc_99DCC
        test bl, 80h
        je short loc_99D8B
        mov ecx, dword [esi]
        add ecx, byte 8
        mov dword [esi], ecx
        les edx, [byte ecx-08h]
loc_99D82:
        mov eax, dword [byte esp+038h]
        mov dword [es:edx], eax
        jmp short loc_99D9F
loc_99D8B:
        test bl, 40h
        je short loc_99DC1
        mov ebx, dword [esi]
        add ebx, ebp
        mov dword [esi], ebx
        mov edx, dword [byte ebx-04h]
loc_99D99:
        mov eax, dword [byte esp+038h]
        mov dword [edx], eax
loc_99D9F:
        mov cl, byte [edi]
        test cl, cl
        je near loc_99F91
        lea eax, [byte edi+01h]
        cmp cl, 25h
        je short loc_99D46
        mov edi, eax
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, cl
        call dword [byte esp+044h]
        jmp short loc_99D9F
loc_99DC1:
        mov edx, dword [esi]
        add edx, ebp
        mov dword [esi], edx
        mov edx, dword [byte edx-04h]
        jmp short loc_99D99
loc_99DCC:
        test bl, 10h
        je short loc_99E0C
        test bl, 80h
        je short loc_99DEA
        mov eax, dword [esi]
        add eax, byte 8
        mov dword [esi], eax
        les edx, [byte eax-08h]
        mov eax, dword [byte esp+038h]
        db 066h,026h,089h,02h                   ; insn: mov [es:edx],ax
        jmp short loc_99D9F
loc_99DEA:
        test bl, 40h
        je short loc_99E01
        mov ecx, dword [esi]
        add ecx, ebp
        mov dword [esi], ecx
        mov edx, dword [byte ecx-04h]
loc_99DF8:
        mov eax, dword [byte esp+038h]
        mov word [edx], ax
        jmp short loc_99D9F
loc_99E01:
        mov ebx, dword [esi]
        add ebx, ebp
        mov dword [esi], ebx
        mov edx, dword [byte ebx-04h]
        jmp short loc_99DF8
loc_99E0C:
        test bl, 80h
        je short loc_99E20
        mov edx, dword [esi]
        add edx, byte 8
        mov dword [esi], edx
        les edx, [byte edx-08h]
        jmp near loc_99D82
loc_99E20:
        test bl, 40h
        je short loc_99E33
        mov eax, dword [esi]
        add eax, ebp
        mov dword [esi], eax
        mov edx, dword [byte eax-04h]
        jmp near loc_99D99
loc_99E33:
        mov ecx, dword [esi]
        add ecx, ebp
        mov dword [esi], ecx
        mov edx, dword [byte ecx-04h]
        jmp near loc_99D99
loc_99E41:
        mov eax, esp
        lea ebx, [byte esp+028h]
        lea ecx, [byte esp+048h]
        mov edx, esi
        call formstring_
        mov es, edx
        mov dl, byte [byte esp+03Ch]
        mov ebx, eax
        test dl, 8
        jne short loc_99E83
        cmp byte [byte esp+03Eh], 20h
        jne short loc_99E83
loc_99E66:
        mov eax, dword [byte esp+02Ch]
        dec eax
        mov dword [byte esp+02Ch], eax
        test eax, eax
        jl short loc_99E83
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [byte esp+03Eh]
        call dword [byte esp+044h]
        jmp short loc_99E66
loc_99E83:
        lea ecx, [byte esp+03Fh]
loc_99E87:
        mov al, byte [ecx]
        test al, al
        je short loc_99E9C
        xor edx, edx
        mov dl, al
        lea eax, [byte esp+028h]
        inc ecx
        call dword [byte esp+044h]
        jmp short loc_99E87
loc_99E9C:
        mov eax, dword [byte esp+034h]
        lea ecx, [byte eax-01h]
        mov dword [byte esp+034h], ecx
        test eax, eax
        je short loc_99EBA
        lea eax, [byte esp+028h]
        mov edx, 30h
        call dword [byte esp+044h]
        jmp short loc_99E9C
loc_99EBA:
        test byte [byte esp+03Ch], 8
        jne short loc_99EE5
        cmp byte [byte esp+03Eh], 20h
        je short loc_99EE5
loc_99EC8:
        mov eax, dword [byte esp+02Ch]
        dec eax
        mov dword [byte esp+02Ch], eax
        test eax, eax
        jl short loc_99EE5
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [byte esp+03Eh]
        call dword [byte esp+044h]
        jmp short loc_99EC8
loc_99EE5:
        mov dh, byte [byte esp+03Dh]
        cmp dh, 73h
        je short loc_99EF3
        cmp dh, 53h
        jne short loc_99F3A
loc_99EF3:
        test byte [byte esp+03Ch], 20h
        je short loc_99F1B
loc_99EFA:
        mov eax, dword [byte esp+030h]
        lea ecx, [byte eax-01h]
        mov dword [byte esp+030h], ecx
        test eax, eax
        je short loc_99F59
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [es:ebx]
        call dword [byte esp+044h]
        add ebx, byte 2
        jmp short loc_99EFA
loc_99F1B:
        mov eax, dword [byte esp+030h]
        lea edx, [byte eax-01h]
        mov dword [byte esp+030h], edx
        test eax, eax
        je short loc_99F59
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [es:ebx]
        call dword [byte esp+044h]
        inc ebx
        jmp short loc_99F1B
loc_99F3A:
        mov eax, dword [byte esp+030h]
        lea ecx, [byte eax-01h]
        mov dword [byte esp+030h], ecx
        test eax, eax
        je short loc_99F59
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [es:ebx]
        call dword [byte esp+044h]
        inc ebx
        jmp short loc_99F3A
loc_99F59:
        test byte [byte esp+03Ch], 8
        je near loc_99D9F
        cmp dword [byte esp+02Ch], byte 0
        jle near loc_99D9F
loc_99F6F:
        mov eax, dword [byte esp+02Ch]
        lea edx, [byte eax-01h]
        mov dword [byte esp+02Ch], edx
        test eax, eax
        je near loc_99D9F
        lea eax, [byte esp+028h]
        mov edx, 20h
        call dword [byte esp+044h]
        jmp short loc_99F6F
loc_99F91:
        mov eax, dword [byte esp+038h]
        add esp, byte 4Ch
        pop ebp
        pop es
        pop edi
        pop esi
        ret
getprintspecs_:
        push ecx
        push esi
        push edi
        mov esi, edx
        mov byte [byte ebx+017h], 0
        mov edx, ebx
        mov byte [byte ebx+016h], 20h
        call evalflags_
        mov dword [byte ebx+04h], 0
        mov cl, byte [eax]
        mov edx, eax
        cmp cl, 30h
        jb short loc_99FE5
        cmp cl, 39h
        ja short loc_99FE5
loc_99FC6:
        imul ecx, dword [byte ebx+04h], byte 0Ah
        xor edx, edx
        mov dl, byte [eax]
        sub edx, byte 30h
        add ecx, edx
        inc eax
        mov dword [byte ebx+04h], ecx
        mov cl, byte [eax]
        cmp cl, 30h
        jb short loc_9A00C
        cmp cl, 39h
        jbe short loc_99FC6
        jmp short loc_9A00C
loc_99FE5:
        cmp byte [eax], 2Ah
        jne short loc_9A00C
        mov edx, dword [esi]
        add edx, byte 4
        mov dword [esi], edx
        mov edx, dword [byte edx-04h]
        mov dword [byte ebx+04h], edx
        test edx, edx
        jge short loc_9A00B
        mov edi, edx
        mov dh, byte [byte ebx+014h]
        neg edi
        or dh, 8
        mov dword [byte ebx+04h], edi
        mov byte [byte ebx+014h], dh
loc_9A00B:
        inc eax
loc_9A00C:
        mov dword [byte ebx+08h], 0FFFFFFFFh
        cmp byte [eax], 2Eh
        jne short loc_9A05F
        inc eax
        mov dword [byte ebx+08h], 0
        cmp byte [eax], 2Ah
        jne short loc_9A040
        mov edx, dword [esi]
        add edx, byte 4
        mov dword [esi], edx
        mov edx, dword [byte edx-04h]
        mov dword [byte ebx+08h], edx
        test edx, edx
        jge short loc_9A03D
        mov dword [byte ebx+08h], 0FFFFFFFFh
loc_9A03D:
        inc eax
        jmp short loc_9A05F
loc_9A040:
        mov cl, byte [eax]
        cmp cl, 30h
        jb short loc_9A05F
        cmp cl, 39h
        ja short loc_9A05F
        imul ecx, dword [byte ebx+08h], byte 0Ah
        xor edx, edx
        mov dl, byte [eax]
        sub edx, byte 30h
        add ecx, edx
        inc eax
        mov dword [byte ebx+08h], ecx
        jmp short loc_9A040
loc_9A05F:
        mov cl, byte [eax]
        lea edx, [byte eax+01h]
        cmp cl, 4Eh
        jb short loc_9A084
        jbe short loc_9A0C1
        cmp cl, 6Ch
        jb short loc_9A07B
        jbe short loc_9A094
        cmp cl, 77h
        je short loc_9A094
        pop edi
        pop esi
        pop ecx
        ret
loc_9A07B:
        cmp cl, 68h
        je short loc_9A0A2
        pop edi
        pop esi
        pop ecx
        ret
loc_9A084:
        cmp cl, 46h
        jb short loc_9A0CC
        jbe short loc_9A0BB
        cmp cl, 4Ch
        je short loc_9A0B1
        pop edi
        pop esi
        pop ecx
        ret
loc_9A094:
        mov dl, byte [byte ebx+014h]
        or dl, 20h
        inc eax
        mov byte [byte ebx+014h], dl
        pop edi
        pop esi
        pop ecx
        ret
loc_9A0A2:
        mov cl, byte [byte ebx+014h]
        or cl, 10h
        mov eax, edx
        mov byte [byte ebx+014h], cl
        pop edi
        pop esi
        pop ecx
        ret
loc_9A0B1:
        or byte [byte ebx+014h], 40h
loc_9A0B5:
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        ret
loc_9A0BB:
        or byte [byte ebx+014h], 80h
        jmp short loc_9A0B5
loc_9A0C1:
        mov ch, byte [byte ebx+014h]
        or ch, 40h
        mov eax, edx
        mov byte [byte ebx+014h], ch
loc_9A0CC:
        pop edi
        pop esi
        pop ecx
        ret
evalflags_:
        push ebx
        push ecx
        mov byte [byte edx+014h], 0
loc_9A0D6:
        mov bl, byte [eax]
        cmp bl, 2Dh
        jne short loc_9A0E3
        or byte [byte edx+014h], 8
        jmp short loc_9A125
loc_9A0E3:
        cmp bl, 23h
        jne short loc_9A0EE
        or byte [byte edx+014h], 1
        jmp short loc_9A125
loc_9A0EE:
        cmp bl, 2Bh
        jne short loc_9A106
        mov ch, byte [byte edx+014h]
        or ch, 4
        mov bl, ch
        mov byte [byte edx+014h], ch
        and bl, 0FDh
        mov byte [byte edx+014h], bl
        jmp short loc_9A125
loc_9A106:
        cmp bl, 20h
        jne short loc_9A11D
        mov bh, byte [byte edx+014h]
        test bh, 4
        jne short loc_9A125
        mov cl, bh
        or cl, 2
        mov byte [byte edx+014h], cl
        jmp short loc_9A125
loc_9A11D:
        cmp bl, 30h
        jne short loc_9A128
        mov byte [byte edx+016h], bl
loc_9A125:
        inc eax
        jmp short loc_9A0D6
loc_9A128:
        pop ecx
        pop ebx
        ret
far_strlen_:
        push ecx
        push esi
        push edi
        push es
        mov esi, edx
        mov edi, ebx
        mov edx, eax
        xor eax, eax
loc_9A137:
        mov es, esi
        mov ebx, edx
        mov cl, byte [es:ebx]
        inc edx
        test cl, cl
        je short loc_9A14A
        cmp eax, edi
        je short loc_9A14A
        inc eax
        jmp short loc_9A137
loc_9A14A:
        pop es
        pop edi
        pop esi
        pop ecx
        ret
far_other_strlen_:
        push ecx
        push esi
        push edi
        push es
        mov ecx, edx
        mov esi, ebx
        mov edx, eax
        xor eax, eax
loc_9A15B:
        mov es, ecx
        mov ebx, edx
        db 066h,026h,08Bh,03Bh                  ; insn: mov di,[es:ebx]
        add edx, byte 2
        test di, di
        je short loc_9A14A
        cmp eax, esi
        je short loc_9A14A
        inc eax
        jmp short loc_9A15B
fmt4hex_:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, edx
        mov dword [esp], ebx
        mov ebx, 10h
        mov edi, ebp
        call itoa_
        push es
        mov eax, ds
        mov es, eax
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        pop es
        mov eax, dword [esp]
        mov esi, ecx
        mov edi, ebp
        dec eax
        lea edx, [ecx+ebp]
        lea ebx, [eax+ebp]
        jmp short loc_9A1B2
loc_9A1AA:
        dec edx
        dec esi
        mov cl, byte [edx]
        dec eax
        mov byte [ebx], cl
        dec ebx
loc_9A1B2:
        cmp edx, edi
        jne short loc_9A1AA
        lea edx, [eax+ebp]
loc_9A1B9:
        test eax, eax
        jl short loc_9A1C4
        dec eax
        mov byte [edx], 30h
        dec edx
        jmp short loc_9A1B9
loc_9A1C4:
        add ebp, dword [esp]
        mov byte [byte ebp+00h], 0
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
FixedPoint_Format_:
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov ecx, eax
        mov esi, ebx
        mov dword [esp], edx
        test edx, edx
        jge short loc_9A1EF
        neg edx
        lea ecx, [byte eax+01h]
        mov byte [eax], 2Dh
        mov dword [esp], edx
loc_9A1EF:
        cmp dword [byte esi+08h], byte 0FFFFFFFFh
        jne short loc_9A1FC
        mov dword [byte esi+08h], 4
loc_9A1FC:
        mov ebx, 0Ah
        xor eax, eax
        mov edx, ecx
        mov ax, word [byte esp+02h]
        call itoa_
        mov ebx, ecx
loc_9A211:
        mov ah, byte [ecx]
        lea edx, [byte ecx+01h]
        test ah, ah
        je short loc_9A21E
        mov ecx, edx
        jmp short loc_9A211
loc_9A21E:
        cmp dword [byte esi+08h], byte 0
        je short loc_9A250
        mov byte [ecx], 2Eh
        xor eax, eax
        mov ecx, edx
        jmp short loc_9A248
loc_9A22D:
        xor edx, edx
        mov word [byte esp+02h], dx
        mov edi, dword [esp]
        imul edx, edi, byte 0Ah
        mov dword [esp], edx
        mov dl, byte [byte esp+02h]
        add dl, 30h
        inc eax
        mov byte [ecx], dl
        inc ecx
loc_9A248:
        cmp eax, dword [byte esi+08h]
        jl short loc_9A22D
        mov byte [ecx], 0
loc_9A250:
        test byte [byte esp+01h], 80h
        je short loc_9A2A7
loc_9A257:
        cmp ecx, ebx
        jne short loc_9A28D
        lea ecx, [byte ebx+01h]
        mov byte [ebx], 31h
loc_9A261:
        mov dl, byte [ecx]
        lea eax, [byte ecx+01h]
        cmp dl, 30h
        jne short loc_9A26F
        mov ecx, eax
        jmp short loc_9A261
loc_9A26F:
        cmp dl, 2Eh
        jne short loc_9A284
        mov byte [ecx], 30h
        lea ecx, [byte eax+01h]
        mov byte [eax], dl
loc_9A27C:
        cmp byte [ecx], 30h
        jne short loc_9A284
        inc ecx
        jmp short loc_9A27C
loc_9A284:
        mov byte [ecx], 30h
        inc ecx
        mov byte [ecx], 0
        jmp short loc_9A2A7
loc_9A28D:
        dec ecx
        cmp byte [ecx], 2Eh
        jne short loc_9A294
        dec ecx
loc_9A294:
        mov al, byte [ecx]
        cmp al, 39h
        je short loc_9A2A2
        mov ah, al
        inc ah
        mov byte [ecx], ah
        jmp short loc_9A2A7
loc_9A2A2:
        mov byte [ecx], 30h
        jmp short loc_9A257
loc_9A2A7:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        ret
float_format_:
        call dword [off_D5668]
        ret
formstring_:
        push esi
        push edi
        push es
        push ebp
        sub esp, byte 8
        mov edi, eax
        mov esi, ebx
        mov dword [esp], ecx
        mov ebx, 1
        mov eax, ds
        mov ecx, edi
        mov dword [byte esp+04h], ebx
        mov es, eax
        mov al, byte [byte esi+015h]
        mov dword [byte esi+0Ch], 0
        cmp al, 69h
        jb short loc_9A2F6
        jbe near loc_9A336
        cmp al, 75h
        jb short loc_9A2F2
        jbe short loc_9A302
        cmp al, 78h
loc_9A2EE:
        je short loc_9A302
        jmp short loc_9A340
loc_9A2F2:
        cmp al, 6Fh
        jmp short loc_9A2EE
loc_9A2F6:
        cmp al, 58h
        jb short loc_9A340
        jbe short loc_9A302
        cmp al, 64h
        je short loc_9A336
        jmp short loc_9A340
loc_9A302:
        mov ah, byte [byte esi+014h]
        test ah, 20h
        je short loc_9A316
        mov ebx, dword [edx]
        add ebx, byte 4
        mov dword [edx], ebx
        mov ebp, dword [byte ebx-04h]
        jmp short loc_9A332
loc_9A316:
        test ah, 10h
        je short loc_9A328
        mov eax, dword [edx]
        add eax, byte 4
        mov dword [edx], eax
        movzx ebp, word [byte eax-04h]
        jmp short loc_9A332
loc_9A328:
        mov ebp, dword [edx]
        add ebp, byte 4
        mov dword [edx], ebp
        mov ebp, dword [byte ebp-04h]
loc_9A332:
        and byte [byte esi+014h], 0F9h
loc_9A336:
        cmp dword [byte esi+08h], byte 0FFFFFFFFh
        je short loc_9A340
        mov byte [byte esi+016h], 20h
loc_9A340:
        mov al, byte [byte esi+015h]
        mov ebx, 0Ah
        cmp al, 65h
        jb short loc_9A3A5
        jbe near loc_9A416
        cmp al, 6Fh
        jb short loc_9A38E
        jbe near loc_9A42A
        cmp al, 73h
        jb short loc_9A381
        jbe near loc_9A4A5
        cmp al, 75h
        jb near loc_9A639
        jbe near loc_9A56E
        cmp al, 78h
        je near loc_9A551
        jmp near loc_9A639
loc_9A381:
        cmp al, 70h
        je near loc_9A58D
        jmp near loc_9A639
loc_9A38E:
        cmp al, 67h
        jb short loc_9A3EC
        jbe near loc_9A416
        cmp al, 69h
        je near loc_9A465
        jmp near loc_9A639
loc_9A3A5:
        cmp al, 50h
        jb short loc_9A3D9
        jbe near loc_9A58D
        cmp al, 58h
        jb short loc_9A3CC
        jbe near loc_9A551
        cmp al, 63h
        jb near loc_9A639
        jbe near loc_9A60C
        jmp near loc_9A465
loc_9A3CC:
        cmp al, 53h
        je near loc_9A4A5
        jmp near loc_9A639
loc_9A3D9:
        cmp al, 46h
        jb short loc_9A3E8
        jbe short loc_9A3EC
        cmp al, 47h
loc_9A3E1:
        je short loc_9A416
        jmp near loc_9A639
loc_9A3E8:
        cmp al, 45h
        jmp short loc_9A3E1
loc_9A3EC:
        test byte [byte esi+014h], 10h
        je short loc_9A416
        mov ebx, dword [edx]
        add ebx, byte 4
        mov dword [edx], ebx
        mov eax, edi
        mov edx, dword [byte ebx-04h]
        mov ebx, esi
        call FixedPoint_Format_
        mov ebx, 0FFFFFFFFh
        mov eax, ds
        mov edx, ds
        mov es, eax
        mov eax, edi
        mov ecx, edi
        jmp short loc_9A45B
loc_9A416:
        mov eax, edi
        mov ebx, esi
        call float_format_
        mov ebx, 0FFFFFFFFh
        mov es, edx
        mov ecx, eax
        jmp short loc_9A45B
loc_9A42A:
        mov al, byte [byte esi+014h]
        mov ebx, 8
        test al, 1
        je short loc_9A43A
        mov byte [edi], 30h
        inc edi
loc_9A43A:
        mov eax, ebp
        mov edx, edi
        call ltoa_
loc_9A443:
        cmp dword [byte esi+08h], byte 0
        jne short loc_9A452
        cmp byte [edi], 30h
        jne short loc_9A452
        mov byte [es:ecx], 0
loc_9A452:
        mov ebx, 0FFFFFFFFh
        mov edx, es
        mov eax, ecx
loc_9A45B:
        call far_strlen_
        jmp near loc_9A663
loc_9A465:
        mov al, byte [byte esi+014h]
        test al, 20h
        je short loc_9A47F
        mov ebp, dword [edx]
        add ebp, byte 4
        mov dword [edx], ebp
        mov edx, edi
        mov eax, dword [byte ebp-04h]
loc_9A478:
        call ltoa_
        jmp short loc_9A443
loc_9A47F:
        test al, 10h
        je short loc_9A492
        mov eax, dword [edx]
        add eax, byte 4
        mov dword [edx], eax
        mov edx, edi
        movsx eax, word [byte eax-04h]
        jmp short loc_9A478
loc_9A492:
        mov ebp, dword [edx]
        add ebp, byte 4
        mov dword [edx], ebp
        mov edx, edi
        mov eax, dword [byte ebp-04h]
        call itoa_
        jmp short loc_9A443
loc_9A4A5:
        mov ah, byte [byte esi+014h]
        test ah, 80h
        je short loc_9A4CF
        mov ecx, dword [edx]
        add ecx, byte 8
        mov dword [edx], ecx
        mov dx, word [byte ecx-04h]
        mov ecx, dword [byte ecx-08h]
        test ecx, ecx
        jne short loc_9A4C4
        test dx, dx
        je short loc_9A4C8
loc_9A4C4:
        mov es, edx
        jmp short loc_9A4FB
loc_9A4C8:
        mov eax, ds
        mov ecx, dword [esp]
        jmp short loc_9A4F9
loc_9A4CF:
        test ah, 40h
        je short loc_9A4E6
        mov ebx, dword [edx]
        add ebx, byte 4
        mov dword [edx], ebx
        mov ecx, dword [byte ebx-04h]
        test ecx, ecx
        je short loc_9A4C8
loc_9A4E2:
        mov eax, ds
        jmp short loc_9A4F9
loc_9A4E6:
        mov eax, dword [edx]
        add eax, byte 4
        mov dword [edx], eax
        mov ecx, dword [byte eax-04h]
        test ecx, ecx
        jne short loc_9A4E2
        mov eax, ds
        mov ecx, dword [esp]
loc_9A4F9:
        mov es, eax
loc_9A4FB:
        mov bh, byte [byte esi+014h]
        mov al, byte [byte esi+015h]
        xor edi, edi
        and bh, 0F9h
        mov dword [byte esp+04h], edi
        mov byte [byte esi+014h], bh
        cmp al, 53h
        jne short loc_9A52F
        test bh, 20h
        je short loc_9A524
        xor eax, eax
        db 066h,026h,08Bh,01h                   ; insn: mov ax,[es:ecx]
        add ecx, byte 2
        jmp near loc_9A663
loc_9A524:
        xor eax, eax
        mov al, byte [es:ecx]
        inc ecx
        jmp near loc_9A663
loc_9A52F:
        test bh, 20h
        je short loc_9A545
        mov edx, es
        mov eax, ecx
        mov ebx, dword [byte esi+08h]
        call far_other_strlen_
        jmp near loc_9A663
loc_9A545:
        mov edx, es
        mov eax, ecx
        mov ebx, dword [byte esi+08h]
        jmp near loc_9A45B
loc_9A551:
        test byte [byte esi+014h], 1
        je short loc_9A569
        test ebp, ebp
        je short loc_9A569
        mov byte [byte esi+017h], 30h
        mov al, byte [byte esi+015h]
        mov byte [byte esi+019h], 0
        mov byte [byte esi+018h], al
loc_9A569:
        mov ebx, 10h
loc_9A56E:
        mov eax, ebp
        mov edx, edi
        call ultoa_
        cmp byte [byte esi+015h], 58h
        jne near loc_9A443
        mov eax, edi
        call zupstr_
        jmp near loc_9A443
loc_9A58D:
        cmp dword [byte esi+04h], byte 0
        jne short loc_9A5A9
        test byte [byte esi+014h], 80h
        je short loc_9A5A2
        mov dword [byte esi+04h], 0Dh
        jmp short loc_9A5A9
loc_9A5A2:
        mov dword [byte esi+04h], 8
loc_9A5A9:
        and byte [byte esi+014h], 0F9h
        mov eax, dword [edx]
        add eax, byte 4
        mov dword [edx], eax
        mov bl, byte [byte esi+014h]
        mov ebp, dword [byte eax-04h]
        test bl, 80h
        je short loc_9A5E8
        add eax, byte 4
        mov dword [edx], eax
        mov ebx, 4
        mov eax, dword [byte eax-04h]
        mov edx, edi
        and eax, 0FFFFh
        call fmt4hex_
        mov ebx, 8
        lea edx, [byte edi+05h]
        mov eax, ebp
        mov byte [byte edi+04h], 3Ah
        jmp short loc_9A5F1
loc_9A5E8:
        mov ebx, 8
        mov eax, ebp
        mov edx, edi
loc_9A5F1:
        call fmt4hex_
        cmp byte [byte esi+015h], 50h
        jne near loc_9A452
        mov eax, edi
        call zupstr_
        jmp near loc_9A452
loc_9A60C:
        mov ebx, dword [edx]
        add ebx, byte 4
        mov dword [edx], ebx
        mov al, byte [byte ebx-04h]
        mov byte [byte edi+01h], 0
        mov byte [edi], al
        mov dword [byte esi+08h], 1
        mov eax, 1
        mov dh, byte [byte esi+014h]
        xor edi, edi
        and dh, 0F9h
        mov dword [byte esp+04h], edi
        mov byte [byte esi+014h], dh
        jmp short loc_9A663
loc_9A639:
        mov dword [byte esi+04h], 0
        mov al, byte [byte esi+015h]
        mov byte [byte edi+01h], 0
        mov byte [edi], al
        mov dword [byte esi+08h], 1
        mov al, byte [byte esi+014h]
        xor edi, edi
        and al, 0F9h
        mov dword [byte esp+04h], edi
        mov byte [byte esi+014h], al
        mov eax, 1
loc_9A663:
        cmp dword [byte esp+04h], byte 0
        je short loc_9A6A9
        mov dl, byte [es:ecx]
        cmp dl, 2Dh
        jne short loc_9A67D
        inc ecx
        mov byte [byte esi+018h], 0
        dec eax
        mov byte [byte esi+017h], dl
        jmp short loc_9A698
loc_9A67D:
        mov dh, byte [byte esi+014h]
        test dh, 2
        je short loc_9A68B
        mov byte [byte esi+017h], 20h
        jmp short loc_9A694
loc_9A68B:
        test dh, 4
        je short loc_9A698
        mov byte [byte esi+017h], 2Bh
loc_9A694:
        mov byte [byte esi+018h], 0
loc_9A698:
        mov edx, dword [byte esi+08h]
        cmp eax, edx
        jle short loc_9A6A4
        mov dword [byte esi+08h], eax
        jmp short loc_9A6A9
loc_9A6A4:
        sub edx, eax
        mov dword [byte esi+0Ch], edx
loc_9A6A9:
        cmp byte [byte esi+016h], 2Ah
        jne short loc_9A6BC
        mov dl, byte [byte esi+014h]
        mov byte [byte esi+017h], 0
        and dl, 0F9h
        mov byte [byte esi+014h], dl
loc_9A6BC:
        mov ebx, dword [byte esi+08h]
        cmp ebx, byte 0FFFFFFFFh
        je short loc_9A6C8
        cmp eax, ebx
        jge short loc_9A6D1
loc_9A6C8:
        cmp byte [byte esi+015h], 63h
        je short loc_9A6D1
        mov dword [byte esi+08h], eax
loc_9A6D1:
        mov ebx, 0FFFFFFFFh
        lea eax, [byte esi+017h]
        mov edx, ds
        call far_strlen_
        mov ebp, dword [byte esi+08h]
        mov edx, dword [byte esi+0Ch]
        add eax, ebp
        mov ebx, dword [byte esi+04h]
        add eax, edx
        mov edx, es
        sub ebx, eax
        mov eax, ecx
        mov dword [byte esi+04h], ebx
        add esp, byte 8
        pop ebp
        pop es
        pop edi
        pop esi
        ret
zupstr_:
        push edx
        mov edx, eax
loc_9A701:
        cmp byte [edx], 0
        je short loc_9A714
        xor eax, eax
        mov al, byte [edx]
        call toupper_
        mov byte [edx], al
        inc edx
        jmp short loc_9A701
loc_9A714:
        pop edx
        ret
__doserror_:
        jae short loc_9A726
        and eax, 0FFFFh
        push eax
        call __set_errno_dos_
        pop eax
        jmp short loc_9A728
loc_9A726:
        sub eax, eax
loc_9A728:
        ret
sub_9A729:
        test edx, edx
        jne short _dosretax_
        xor eax, eax
        ret
_dosretax_:
        test edx, edx
        jne short __set_errno_dos_
        ret
__set_errno_dos_:
        push ebx
        push edx
        mov edx, eax
        mov bl, al
        xor eax, eax
        mov al, dl
        call __set_doserrno_
        cmp edx, 100h
        jae short loc_9A784
        cmp byte [_osmajor], 3
        jb short loc_9A76E
        cmp dl, 50h
        jne short loc_9A75E
        mov bl, 0Eh
        jmp short loc_9A76E
loc_9A75E:
        cmp dl, 22h
        jb short loc_9A767
        mov bl, 13h
        jmp short loc_9A76E
loc_9A767:
        cmp dl, 20h
        jb short loc_9A76E
        mov bl, 5
loc_9A76E:
        cmp bl, 13h
        jbe short loc_9A775
        mov bl, 13h
loc_9A775:
        xor edx, edx
        mov dl, bl
        mov eax, dword [dword edx+dword_D4FF1]
        sar eax, 18h
        jmp short loc_9A78E
loc_9A784:
        mov eax, edx
        shr eax, 8
        and eax, 0FFh
loc_9A78E:
        call __set_errno_
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h
