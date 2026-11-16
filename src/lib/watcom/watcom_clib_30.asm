; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_99A12 progbits alloc exec nowrite align=1
extern __set_doserrno_, __set_errno_, _osmajor, CMainEnv, CMainResult, DosErrnoTable, dword_F243C, AtexitTable
extern SpeechBankCount, CMainArgc, CMainArgv, exit_, itoa_, ltoa_, main_, ExitHook
extern __EFG_printf, CMainHook, __CommonInit_, toupper_, ultoa_, InitRtnsEntry, FiniRtnsEntry, GusInitTable
global copypart_, _splitpath_, pickup_, _makepath_, _Full_at_exit_rtn_, atexit_, __CMain, __InitRtns
global __FiniRtns, __prtf_, getprintspecs_, evalflags_, far_strlen_, far_other_strlen_, fmt4hex_, FixedPoint_Format_
global float_format_, formstring_, zupstr_, __doserror_, _dosret0_, _dosretax_, __set_errno_dos_
copypart_:
        push esi
        push edi
        push ebp
        mov ebp, eax
        test eax, eax
        je short .2
        cmp ebx, ecx
        jle short .1
        mov ebx, ecx
.1:
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
.2:
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
        je short .2
        mov cl, byte [byte esi+01h]
        cmp cl, 3Ah
        jne short .2
        test edx, edx
        je short .1
        mov al, byte [esi]
        mov byte [byte edx+02h], 0
        mov byte [edx], al
        mov byte [byte edx+01h], cl
.1:
        add esi, byte 2
        jmp short .3
.2:
        test edx, edx
        je short .3
        mov byte [edx], 0
.3:
        mov ebp, esi
        mov edx, esi
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
        mov ecx, ebp
        sub ecx, edx
        mov eax, ebx
        mov ebx, ecx
        mov ecx, 81h
        call copypart_
        test edi, edi
        jne short .9
        mov edi, esi
.9:
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
        je short .1
        cmp al, 2Fh
        jne short .3
.1:
        cmp byte [edx], 0
        jne short .2
        mov byte [edx], al
.2:
        mov al, byte [edx]
.3:
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
        je short .1
        mov al, byte [edx]
        test al, al
        je short .1
        mov byte [esi], al
        inc esi
        mov byte [esi], 3Ah
        inc esi
.1:
        mov byte [esi], 0
        test ebx, ebx
        je short .5
        cmp byte [ebx], 0
        je short .5
.2:
        xor eax, eax
        mov edx, esp
        mov al, byte [ebx]
        inc ebx
        call pickup_
        mov byte [esi], al
        mov dl, byte [ebx]
        inc esi
        test dl, dl
        jne short .2
        cmp byte [esp], 0
        jne short .3
        mov byte [esp], 5Ch
.3:
        mov bh, byte [esp]
        cmp bh, byte [byte esi-01h]
        jne short .4
        dec esi
        jmp short .5
.4:
        mov byte [esi], bh
.5:
        cmp byte [esp], 0
        jne short .6
        mov byte [esp], 5Ch
.6:
        lea ebx, [byte esi+01h]
        test ecx, ecx
        je short .8
        xor eax, eax
        mov edx, esp
        mov al, byte [ecx]
        call pickup_
        mov dh, byte [esp]
        cmp al, dh
        je short .7
        cmp dh, byte [esi]
        jne short .7
        mov esi, ebx
.7:
        mov dl, byte [ecx]
        test dl, dl
        je short .9
        xor eax, eax
        mov al, dl
        mov edx, esp
        inc ecx
        call pickup_
        mov byte [esi], al
        inc esi
        jmp short .7
.8:
        mov dl, byte [esp]
        cmp dl, byte [esi]
        jne short .9
        mov esi, ebx
.9:
        test edi, edi
        je short .12
        mov dh, byte [edi]
        test dh, dh
        je short .12
        cmp dh, 2Eh
        je short .11
        mov byte [esi], 2Eh
.10:
        inc esi
.11:
        mov bh, byte [edi]
        test bh, bh
        je short .12
        inc edi
        mov byte [esi], bh
        jmp short .10
.12:
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
        mov ebx, dword [SpeechBankCount]
        mov dword [SpeechBankCount], edx
        mov edx, ebx
        shl edx, 2
.1:
        test edx, edx
        je short .2
        mov eax, dword [dword edx+dword_F243C]
        sub edx, byte 4
        mov dword [esp], eax
        dec ebx
        call dword [esp]
        jmp short .1
.2:
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
        mov ecx, dword [SpeechBankCount]
        mov dword [ExitHook], edx
        cmp ecx, byte 20h
        jge short .1
        mov eax, ecx
        lea edx, [byte ecx+01h]
        mov dword [nosplit ecx*4+AtexitTable], ebx
        mov dword [SpeechBankCount], edx
        xor eax, ecx
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, 0FFFFFFFFh
        pop edx
        pop ecx
        pop ebx
        ret
__CMain:
        push edx
        push ebp
        mov ebp, esp
        mov edx, dword [CMainEnv]
        add edx, byte 3
        and dl, 0FCh
        call CMainHook
        cmp edx, eax
        jae short .1
        mov eax, edx
        sub esp, eax
        mov eax, esp
        jmp short .2
.1:
        xor eax, eax
.2:
        mov edx, dword [CMainEnv]
        add eax, edx
        mov dword [CMainResult], eax
        call __CommonInit_
        mov edx, dword [CMainArgv]
        mov eax, dword [CMainArgc]
        call main_
        call exit_
        db 089h,0ECh,05Dh,05Ah,0C3h,00h
__InitRtns:
        push esi
        push edi
        push ebx
        push edx
        push es
        mov edx, eax
.1:
        db 03Eh,0BEh                            ; insn: mov esi,18B14h
        dd InitRtnsEntry
        db 03Eh,0BFh                            ; insn: mov edi,18B3Eh
        dd FiniRtnsEntry
        mov ebx, edi
        mov al, dl
.2:
        cmp esi, edi
        jae short .4
        cmp byte [esi], 2
        je short .3
        cmp byte [byte esi+01h], al
        ja short .3
        mov ebx, esi
        mov al, byte [byte esi+01h]
.3:
        add esi, byte 6
        jmp short .2
.4:
        cmp ebx, edi
        je short .6
        mov eax, dword [byte ebx+02h]
        or eax, eax
        je short .5
        push ds
        pop es
        push edx
        call eax
        pop edx
.5:
        mov byte [ebx], 2
        jmp short .1
.6:
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
.1:
        db 03Eh,0BEh                            ; insn: mov esi,18B3Eh
        dd FiniRtnsEntry
        db 03Eh,0BFh                            ; insn: mov edi,18B4Ah
        dd GusInitTable
        mov ebx, edi
        mov al, dl
.2:
        cmp esi, edi
        jae short .4
        cmp byte [esi], 2
        je short .3
        cmp al, byte [byte esi+01h]
        ja short .3
        mov ebx, esi
        mov al, byte [byte esi+01h]
.3:
        add esi, byte 6
        jmp short .2
.4:
        cmp ebx, edi
        je short .6
        cmp al, dh
        ja short .5
        mov eax, dword [byte ebx+02h]
        or eax, eax
        je short .5
        push ds
        pop es
        push edx
        call eax
        pop edx
.5:
        mov byte [ebx], 2
        jmp short .1
.6:
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
        jmp short .5
.1:
        lea ebx, [byte esp+028h]
        mov edx, esi
        call getprintspecs_
        mov edi, eax
        mov al, byte [eax]
        inc edi
        mov byte [byte esp+03Dh], al
        test al, al
        je near .28
        cmp al, 6Eh
        jne near .14
        mov bl, byte [byte esp+03Ch]
        test bl, 20h
        je short .7
        test bl, 80h
        je short .3
        mov ecx, dword [esi]
        add ecx, byte 8
        mov dword [esi], ecx
        les edx, [byte ecx-08h]
.2:
        mov eax, dword [byte esp+038h]
        mov dword [es:edx], eax
        jmp short .5
.3:
        test bl, 40h
        je short .6
        mov ebx, dword [esi]
        add ebx, ebp
        mov dword [esi], ebx
        mov edx, dword [byte ebx-04h]
.4:
        mov eax, dword [byte esp+038h]
        mov dword [edx], eax
.5:
        mov cl, byte [edi]
        test cl, cl
        je near .28
        lea eax, [byte edi+01h]
        cmp cl, 25h
        je short .1
        mov edi, eax
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, cl
        call dword [byte esp+044h]
        jmp short .5
.6:
        mov edx, dword [esi]
        add edx, ebp
        mov dword [esi], edx
        mov edx, dword [byte edx-04h]
        jmp short .4
.7:
        test bl, 10h
        je short .11
        test bl, 80h
        je short .8
        mov eax, dword [esi]
        add eax, byte 8
        mov dword [esi], eax
        les edx, [byte eax-08h]
        mov eax, dword [byte esp+038h]
        db 066h,026h,089h,02h                   ; insn: mov [es:edx],ax
        jmp short .5
.8:
        test bl, 40h
        je short .10
        mov ecx, dword [esi]
        add ecx, ebp
        mov dword [esi], ecx
        mov edx, dword [byte ecx-04h]
.9:
        mov eax, dword [byte esp+038h]
        mov word [edx], ax
        jmp short .5
.10:
        mov ebx, dword [esi]
        add ebx, ebp
        mov dword [esi], ebx
        mov edx, dword [byte ebx-04h]
        jmp short .9
.11:
        test bl, 80h
        je short .12
        mov edx, dword [esi]
        add edx, byte 8
        mov dword [esi], edx
        les edx, [byte edx-08h]
        jmp near .2
.12:
        test bl, 40h
        je short .13
        mov eax, dword [esi]
        add eax, ebp
        mov dword [esi], eax
        mov edx, dword [byte eax-04h]
        jmp near .4
.13:
        mov ecx, dword [esi]
        add ecx, ebp
        mov dword [esi], ecx
        mov edx, dword [byte ecx-04h]
        jmp near .4
.14:
        mov eax, esp
        lea ebx, [byte esp+028h]
        lea ecx, [byte esp+048h]
        mov edx, esi
        call formstring_
        mov es, edx
        mov dl, byte [byte esp+03Ch]
        mov ebx, eax
        test dl, 8
        jne short .16
        cmp byte [byte esp+03Eh], 20h
        jne short .16
.15:
        mov eax, dword [byte esp+02Ch]
        dec eax
        mov dword [byte esp+02Ch], eax
        test eax, eax
        jl short .16
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [byte esp+03Eh]
        call dword [byte esp+044h]
        jmp short .15
.16:
        lea ecx, [byte esp+03Fh]
.17:
        mov al, byte [ecx]
        test al, al
        je short .18
        xor edx, edx
        mov dl, al
        lea eax, [byte esp+028h]
        inc ecx
        call dword [byte esp+044h]
        jmp short .17
.18:
        mov eax, dword [byte esp+034h]
        lea ecx, [byte eax-01h]
        mov dword [byte esp+034h], ecx
        test eax, eax
        je short .19
        lea eax, [byte esp+028h]
        mov edx, 30h
        call dword [byte esp+044h]
        jmp short .18
.19:
        test byte [byte esp+03Ch], 8
        jne short .21
        cmp byte [byte esp+03Eh], 20h
        je short .21
.20:
        mov eax, dword [byte esp+02Ch]
        dec eax
        mov dword [byte esp+02Ch], eax
        test eax, eax
        jl short .21
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [byte esp+03Eh]
        call dword [byte esp+044h]
        jmp short .20
.21:
        mov dh, byte [byte esp+03Dh]
        cmp dh, 73h
        je short .22
        cmp dh, 53h
        jne short .25
.22:
        test byte [byte esp+03Ch], 20h
        je short .24
.23:
        mov eax, dword [byte esp+030h]
        lea ecx, [byte eax-01h]
        mov dword [byte esp+030h], ecx
        test eax, eax
        je short .26
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [es:ebx]
        call dword [byte esp+044h]
        add ebx, byte 2
        jmp short .23
.24:
        mov eax, dword [byte esp+030h]
        lea edx, [byte eax-01h]
        mov dword [byte esp+030h], edx
        test eax, eax
        je short .26
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [es:ebx]
        call dword [byte esp+044h]
        inc ebx
        jmp short .24
.25:
        mov eax, dword [byte esp+030h]
        lea ecx, [byte eax-01h]
        mov dword [byte esp+030h], ecx
        test eax, eax
        je short .26
        xor edx, edx
        lea eax, [byte esp+028h]
        mov dl, byte [es:ebx]
        call dword [byte esp+044h]
        inc ebx
        jmp short .25
.26:
        test byte [byte esp+03Ch], 8
        je near .5
        cmp dword [byte esp+02Ch], byte 0
        jle near .5
.27:
        mov eax, dword [byte esp+02Ch]
        lea edx, [byte eax-01h]
        mov dword [byte esp+02Ch], edx
        test eax, eax
        je near .5
        lea eax, [byte esp+028h]
        mov edx, 20h
        call dword [byte esp+044h]
        jmp short .27
.28:
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
        jb short .2
        cmp cl, 39h
        ja short .2
.1:
        imul ecx, dword [byte ebx+04h], byte 0Ah
        xor edx, edx
        mov dl, byte [eax]
        sub edx, byte 30h
        add ecx, edx
        inc eax
        mov dword [byte ebx+04h], ecx
        mov cl, byte [eax]
        cmp cl, 30h
        jb short .4
        cmp cl, 39h
        jbe short .1
        jmp short .4
.2:
        cmp byte [eax], 2Ah
        jne short .4
        mov edx, dword [esi]
        add edx, byte 4
        mov dword [esi], edx
        mov edx, dword [byte edx-04h]
        mov dword [byte ebx+04h], edx
        test edx, edx
        jge short .3
        mov edi, edx
        mov dh, byte [byte ebx+014h]
        neg edi
        or dh, 8
        mov dword [byte ebx+04h], edi
        mov byte [byte ebx+014h], dh
.3:
        inc eax
.4:
        mov dword [byte ebx+08h], 0FFFFFFFFh
        cmp byte [eax], 2Eh
        jne short .7
        inc eax
        mov dword [byte ebx+08h], 0
        cmp byte [eax], 2Ah
        jne short .6
        mov edx, dword [esi]
        add edx, byte 4
        mov dword [esi], edx
        mov edx, dword [byte edx-04h]
        mov dword [byte ebx+08h], edx
        test edx, edx
        jge short .5
        mov dword [byte ebx+08h], 0FFFFFFFFh
.5:
        inc eax
        jmp short .7
.6:
        mov cl, byte [eax]
        cmp cl, 30h
        jb short .7
        cmp cl, 39h
        ja short .7
        imul ecx, dword [byte ebx+08h], byte 0Ah
        xor edx, edx
        mov dl, byte [eax]
        sub edx, byte 30h
        add ecx, edx
        inc eax
        mov dword [byte ebx+08h], ecx
        jmp short .6
.7:
        mov cl, byte [eax]
        lea edx, [byte eax+01h]
        cmp cl, 4Eh
        jb short .9
        jbe short .15
        cmp cl, 6Ch
        jb short .8
        jbe short .10
        cmp cl, 77h
        je short .10
        pop edi
        pop esi
        pop ecx
        ret
.8:
        cmp cl, 68h
        je short .11
        pop edi
        pop esi
        pop ecx
        ret
.9:
        cmp cl, 46h
        jb short .16
        jbe short .14
        cmp cl, 4Ch
        je short .12
        pop edi
        pop esi
        pop ecx
        ret
.10:
        mov dl, byte [byte ebx+014h]
        or dl, 20h
        inc eax
        mov byte [byte ebx+014h], dl
        pop edi
        pop esi
        pop ecx
        ret
.11:
        mov cl, byte [byte ebx+014h]
        or cl, 10h
        mov eax, edx
        mov byte [byte ebx+014h], cl
        pop edi
        pop esi
        pop ecx
        ret
.12:
        or byte [byte ebx+014h], 40h
.13:
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        ret
.14:
        or byte [byte ebx+014h], 80h
        jmp short .13
.15:
        mov ch, byte [byte ebx+014h]
        or ch, 40h
        mov eax, edx
        mov byte [byte ebx+014h], ch
.16:
        pop edi
        pop esi
        pop ecx
        ret
evalflags_:
        push ebx
        push ecx
        mov byte [byte edx+014h], 0
.1:
        mov bl, byte [eax]
        cmp bl, 2Dh
        jne short .2
        or byte [byte edx+014h], 8
        jmp short .6
.2:
        cmp bl, 23h
        jne short .3
        or byte [byte edx+014h], 1
        jmp short .6
.3:
        cmp bl, 2Bh
        jne short .4
        mov ch, byte [byte edx+014h]
        or ch, 4
        mov bl, ch
        mov byte [byte edx+014h], ch
        and bl, 0FDh
        mov byte [byte edx+014h], bl
        jmp short .6
.4:
        cmp bl, 20h
        jne short .5
        mov bh, byte [byte edx+014h]
        test bh, 4
        jne short .6
        mov cl, bh
        or cl, 2
        mov byte [byte edx+014h], cl
        jmp short .6
.5:
        cmp bl, 30h
        jne short .7
        mov byte [byte edx+016h], bl
.6:
        inc eax
        jmp short .1
.7:
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
.1:
        mov es, esi
        mov ebx, edx
        mov cl, byte [es:ebx]
        inc edx
        test cl, cl
        je short far_strlen_+01Fh
        cmp eax, edi
        je short far_strlen_+01Fh
        inc eax
        jmp short .1
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
.1:
        mov es, ecx
        mov ebx, edx
        db 066h,026h,08Bh,03Bh                  ; insn: mov di,[es:ebx]
        add edx, byte 2
        test di, di
        je short far_strlen_+01Fh
        cmp eax, esi
        je short far_strlen_+01Fh
        inc eax
        jmp short .1
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
        jmp short .2
.1:
        dec edx
        dec esi
        mov cl, byte [edx]
        dec eax
        mov byte [ebx], cl
        dec ebx
.2:
        cmp edx, edi
        jne short .1
        lea edx, [eax+ebp]
.3:
        test eax, eax
        jl short .4
        dec eax
        mov byte [edx], 30h
        dec edx
        jmp short .3
.4:
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
        jge short .1
        neg edx
        lea ecx, [byte eax+01h]
        mov byte [eax], 2Dh
        mov dword [esp], edx
.1:
        cmp dword [byte esi+08h], byte 0FFFFFFFFh
        jne short .2
        mov dword [byte esi+08h], 4
.2:
        mov ebx, 0Ah
        xor eax, eax
        mov edx, ecx
        mov ax, word [byte esp+02h]
        call itoa_
        mov ebx, ecx
.3:
        mov ah, byte [ecx]
        lea edx, [byte ecx+01h]
        test ah, ah
        je short .4
        mov ecx, edx
        jmp short .3
.4:
        cmp dword [byte esi+08h], byte 0
        je short .7
        mov byte [ecx], 2Eh
        xor eax, eax
        mov ecx, edx
        jmp short .6
.5:
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
.6:
        cmp eax, dword [byte esi+08h]
        jl short .5
        mov byte [ecx], 0
.7:
        test byte [byte esp+01h], 80h
        je short .16
.8:
        cmp ecx, ebx
        jne short .13
        lea ecx, [byte ebx+01h]
        mov byte [ebx], 31h
.9:
        mov dl, byte [ecx]
        lea eax, [byte ecx+01h]
        cmp dl, 30h
        jne short .10
        mov ecx, eax
        jmp short .9
.10:
        cmp dl, 2Eh
        jne short .12
        mov byte [ecx], 30h
        lea ecx, [byte eax+01h]
        mov byte [eax], dl
.11:
        cmp byte [ecx], 30h
        jne short .12
        inc ecx
        jmp short .11
.12:
        mov byte [ecx], 30h
        inc ecx
        mov byte [ecx], 0
        jmp short .16
.13:
        dec ecx
        cmp byte [ecx], 2Eh
        jne short .14
        dec ecx
.14:
        mov al, byte [ecx]
        cmp al, 39h
        je short .15
        mov ah, al
        inc ah
        mov byte [ecx], ah
        jmp short .16
.15:
        mov byte [ecx], 30h
        jmp short .8
.16:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        ret
float_format_:
        call dword [__EFG_printf]
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
        jb short .3
        jbe near .8
        cmp al, 75h
        jb short .2
        jbe short .4
        cmp al, 78h
.1:
        je short .4
        jmp short .9
.2:
        cmp al, 6Fh
        jmp short .1
.3:
        cmp al, 58h
        jb short .9
        jbe short .4
        cmp al, 64h
        je short .8
        jmp short .9
.4:
        mov ah, byte [byte esi+014h]
        test ah, 20h
        je short .5
        mov ebx, dword [edx]
        add ebx, byte 4
        mov dword [edx], ebx
        mov ebp, dword [byte ebx-04h]
        jmp short .7
.5:
        test ah, 10h
        je short .6
        mov eax, dword [edx]
        add eax, byte 4
        mov dword [edx], eax
        movzx ebp, word [byte eax-04h]
        jmp short .7
.6:
        mov ebp, dword [edx]
        add ebp, byte 4
        mov dword [edx], ebp
        mov ebp, dword [byte ebp-04h]
.7:
        and byte [byte esi+014h], 0F9h
.8:
        cmp dword [byte esi+08h], byte 0FFFFFFFFh
        je short .9
        mov byte [byte esi+016h], 20h
.9:
        mov al, byte [byte esi+015h]
        mov ebx, 0Ah
        cmp al, 65h
        jb short .12
        jbe near .18
        cmp al, 6Fh
        jb short .11
        jbe near .19
        cmp al, 73h
        jb short .10
        jbe near .28
        cmp al, 75h
        jb near .48
        jbe near .41
        cmp al, 78h
        je near .39
        jmp near .48
.10:
        cmp al, 70h
        je near .42
        jmp near .48
.11:
        cmp al, 67h
        jb short .17
        jbe near .18
        cmp al, 69h
        je near .24
        jmp near .48
.12:
        cmp al, 50h
        jb short .14
        jbe near .42
        cmp al, 58h
        jb short .13
        jbe near .39
        cmp al, 63h
        jb near .48
        jbe near .47
        jmp near .24
.13:
        cmp al, 53h
        je near .28
        jmp near .48
.14:
        cmp al, 46h
        jb short .16
        jbe short .17
        cmp al, 47h
.15:
        je short .18
        jmp near .48
.16:
        cmp al, 45h
        jmp short .15
.17:
        test byte [byte esi+014h], 10h
        je short .18
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
        jmp short .23
.18:
        mov eax, edi
        mov ebx, esi
        call float_format_
        mov ebx, 0FFFFFFFFh
        mov es, edx
        mov ecx, eax
        jmp short .23
.19:
        mov al, byte [byte esi+014h]
        mov ebx, 8
        test al, 1
        je short .20
        mov byte [edi], 30h
        inc edi
.20:
        mov eax, ebp
        mov edx, edi
        call ltoa_
.21:
        cmp dword [byte esi+08h], byte 0
        jne short .22
        cmp byte [edi], 30h
        jne short .22
        mov byte [es:ecx], 0
.22:
        mov ebx, 0FFFFFFFFh
        mov edx, es
        mov eax, ecx
.23:
        call far_strlen_
        jmp near .49
.24:
        mov al, byte [byte esi+014h]
        test al, 20h
        je short .26
        mov ebp, dword [edx]
        add ebp, byte 4
        mov dword [edx], ebp
        mov edx, edi
        mov eax, dword [byte ebp-04h]
.25:
        call ltoa_
        jmp short .21
.26:
        test al, 10h
        je short .27
        mov eax, dword [edx]
        add eax, byte 4
        mov dword [edx], eax
        mov edx, edi
        movsx eax, word [byte eax-04h]
        jmp short .25
.27:
        mov ebp, dword [edx]
        add ebp, byte 4
        mov dword [edx], ebp
        mov edx, edi
        mov eax, dword [byte ebp-04h]
        call itoa_
        jmp short .21
.28:
        mov ah, byte [byte esi+014h]
        test ah, 80h
        je short .31
        mov ecx, dword [edx]
        add ecx, byte 8
        mov dword [edx], ecx
        mov dx, word [byte ecx-04h]
        mov ecx, dword [byte ecx-08h]
        test ecx, ecx
        jne short .29
        test dx, dx
        je short .30
.29:
        mov es, edx
        jmp short .35
.30:
        mov eax, ds
        mov ecx, dword [esp]
        jmp short .34
.31:
        test ah, 40h
        je short .33
        mov ebx, dword [edx]
        add ebx, byte 4
        mov dword [edx], ebx
        mov ecx, dword [byte ebx-04h]
        test ecx, ecx
        je short .30
.32:
        mov eax, ds
        jmp short .34
.33:
        mov eax, dword [edx]
        add eax, byte 4
        mov dword [edx], eax
        mov ecx, dword [byte eax-04h]
        test ecx, ecx
        jne short .32
        mov eax, ds
        mov ecx, dword [esp]
.34:
        mov es, eax
.35:
        mov bh, byte [byte esi+014h]
        mov al, byte [byte esi+015h]
        xor edi, edi
        and bh, 0F9h
        mov dword [byte esp+04h], edi
        mov byte [byte esi+014h], bh
        cmp al, 53h
        jne short .37
        test bh, 20h
        je short .36
        xor eax, eax
        db 066h,026h,08Bh,01h                   ; insn: mov ax,[es:ecx]
        add ecx, byte 2
        jmp near .49
.36:
        xor eax, eax
        mov al, byte [es:ecx]
        inc ecx
        jmp near .49
.37:
        test bh, 20h
        je short .38
        mov edx, es
        mov eax, ecx
        mov ebx, dword [byte esi+08h]
        call far_other_strlen_
        jmp near .49
.38:
        mov edx, es
        mov eax, ecx
        mov ebx, dword [byte esi+08h]
        jmp near .23
.39:
        test byte [byte esi+014h], 1
        je short .40
        test ebp, ebp
        je short .40
        mov byte [byte esi+017h], 30h
        mov al, byte [byte esi+015h]
        mov byte [byte esi+019h], 0
        mov byte [byte esi+018h], al
.40:
        mov ebx, 10h
.41:
        mov eax, ebp
        mov edx, edi
        call ultoa_
        cmp byte [byte esi+015h], 58h
        jne near .21
        mov eax, edi
        call zupstr_
        jmp near .21
.42:
        cmp dword [byte esi+04h], byte 0
        jne short .44
        test byte [byte esi+014h], 80h
        je short .43
        mov dword [byte esi+04h], 0Dh
        jmp short .44
.43:
        mov dword [byte esi+04h], 8
.44:
        and byte [byte esi+014h], 0F9h
        mov eax, dword [edx]
        add eax, byte 4
        mov dword [edx], eax
        mov bl, byte [byte esi+014h]
        mov ebp, dword [byte eax-04h]
        test bl, 80h
        je short .45
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
        jmp short .46
.45:
        mov ebx, 8
        mov eax, ebp
        mov edx, edi
.46:
        call fmt4hex_
        cmp byte [byte esi+015h], 50h
        jne near .22
        mov eax, edi
        call zupstr_
        jmp near .22
.47:
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
        jmp short .49
.48:
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
.49:
        cmp dword [byte esp+04h], byte 0
        je short .55
        mov dl, byte [es:ecx]
        cmp dl, 2Dh
        jne short .50
        inc ecx
        mov byte [byte esi+018h], 0
        dec eax
        mov byte [byte esi+017h], dl
        jmp short .53
.50:
        mov dh, byte [byte esi+014h]
        test dh, 2
        je short .51
        mov byte [byte esi+017h], 20h
        jmp short .52
.51:
        test dh, 4
        je short .53
        mov byte [byte esi+017h], 2Bh
.52:
        mov byte [byte esi+018h], 0
.53:
        mov edx, dword [byte esi+08h]
        cmp eax, edx
        jle short .54
        mov dword [byte esi+08h], eax
        jmp short .55
.54:
        sub edx, eax
        mov dword [byte esi+0Ch], edx
.55:
        cmp byte [byte esi+016h], 2Ah
        jne short .56
        mov dl, byte [byte esi+014h]
        mov byte [byte esi+017h], 0
        and dl, 0F9h
        mov byte [byte esi+014h], dl
.56:
        mov ebx, dword [byte esi+08h]
        cmp ebx, byte 0FFFFFFFFh
        je short .57
        cmp eax, ebx
        jge short .58
.57:
        cmp byte [byte esi+015h], 63h
        je short .58
        mov dword [byte esi+08h], eax
.58:
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
.1:
        cmp byte [edx], 0
        je short .2
        xor eax, eax
        mov al, byte [edx]
        call toupper_
        mov byte [edx], al
        inc edx
        jmp short .1
.2:
        pop edx
        ret
__doserror_:
        jae short .1
        and eax, 0FFFFh
        push eax
        call __set_errno_dos_
        pop eax
        jmp short .2
.1:
        sub eax, eax
.2:
        ret
_dosret0_:
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
        jae short .5
        cmp byte [_osmajor], 3
        jb short .3
        cmp dl, 50h
        jne short .1
        mov bl, 0Eh
        jmp short .3
.1:
        cmp dl, 22h
        jb short .2
        mov bl, 13h
        jmp short .3
.2:
        cmp dl, 20h
        jb short .3
        mov bl, 5
.3:
        cmp bl, 13h
        jbe short .4
        mov bl, 13h
.4:
        xor edx, edx
        mov dl, bl
        mov eax, dword [dword edx+DosErrnoTable]
        sar eax, 18h
        jmp short .6
.5:
        mov eax, edx
        shr eax, 8
        and eax, 0FFh
.6:
        call __set_errno_
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h
