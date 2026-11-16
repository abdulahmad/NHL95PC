; Watcom helper that starts another program.
bits 32
%include "hockey.inc"
section s_A1CA2 progbits alloc exec nowrite align=1
extern __ccmdline_, __cenvarg_, __CHK, __dospawn, __set_doserrno_, __set_errno_, __Slash_C_, _makepath_
extern _nfree_, _nmalloc_, _splitpath2_, str_Bat, str_Com, str_Exe, str_COMSPEC, str_CMD
extern str_COMMAND, _osmajor, getenv_, off_D6600, off_D6604, spawnl_, stricmp_, strlen_
extern ErrnoPtr, CMainHook, unk_C4AB4, unknown_libname_1
global SpawnPathExists, SpawnCommand, spawnve_, loc_A1D26, loc_A1D30, loc_A1D87, loc_A1D89, loc_A1D9A
global loc_A1D9D, loc_A1DF6, loc_A1DF8, loc_A1E1F, loc_A1E22, loc_A1E42, loc_A1E92, loc_A1EB2
global loc_A1ED4, loc_A1EFD, loc_A1F60, loc_A1FA4, loc_A1FA9, loc_A1FC0, loc_A1FC3, loc_A1FE7
SpawnPathExists:
        push ebx
        push edx
        enter 2Ch, 0
        mov edx, 7
        lea ebx, [byte ebp-02Ch]
        call unknown_libname_1
        test eax, eax
        sete al
        movzx eax, al
        leave
        pop edx
        pop ebx
        ret
SpawnCommand:
        push esi
        push edi
        enter 4, 0
        push eax
        mov esi, edx
        mov edi, ebx
        mov dword [byte ebp-04h], ecx
        mov eax, edx
        xor ecx, ecx
        mov edx, dword [byte ebp+010h]
        call __ccmdline_
        push dword [byte ebp+010h]
        push dword [byte ebp-04h]
        push edi
        push esi
        push dword [byte ebp-08h]
        call __dospawn
        add esp, byte 14h
        leave
        pop edi
        pop esi
        ret 4
spawnve_:
        push dword 0E4h
        call __CHK
        push esi
        push edi
        push es
        enter 0B0h, 0
        push eax
        sub ebp, 82h
        mov esi, edx
        mov dword [byte ebp+06Eh], ebx
        mov edx, ecx
        mov byte [byte ebp+07Eh], 0
        cmp eax, byte 2
        jb short loc_A1D30
        mov eax, 9
        call __set_errno_
loc_A1D26:
        mov eax, 0FFFFFFFFh
        jmp near loc_A1FE7
loc_A1D30:
        push byte 0
        lea eax, [byte ebp+052h]
        push eax
        lea eax, [byte ebp+056h]
        lea ecx, [byte ebp+05Ah]
        push eax
        mov eax, ebx
        lea ebx, [byte ebp+05Eh]
        call __cenvarg_
        mov dword [byte ebp+076h], eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_A1FE7
        mov eax, esi
        call strlen_
        lea edx, [dword eax+09Ah]
        mov eax, edx
        call _nmalloc_
        mov ebx, eax
        mov dword [byte ebp+066h], eax
        test eax, eax
        jne short loc_A1D9A
        lea ebx, [byte edx+03h]
        and bl, 0FCh
        call CMainHook
        cmp ebx, eax
        jae short loc_A1D87
        mov eax, ebx
        sub esp, eax
        mov eax, esp
        jmp short loc_A1D89
loc_A1D87:
        xor eax, eax
loc_A1D89:
        mov dword [byte ebp+07Ah], eax
        test eax, eax
        jne short loc_A1D9D
        mov eax, dword [byte ebp+05Eh]
        call _nfree_
        jmp short loc_A1D26
loc_A1D9A:
        mov dword [byte ebp+07Ah], eax
loc_A1D9D:
        lea eax, [byte ebp+042h]
        lea ebx, [byte ebp+046h]
        lea ecx, [byte ebp+04Ah]
        push eax
        lea eax, [byte ebp+03Eh]
        sub edx, 93h
        push eax
        add edx, dword [byte ebp+07Ah]
        mov eax, esi
        call _splitpath2_
        lea eax, [byte ebp-02Eh]
        call dword [off_D6600]
        mov eax, dword [byte ebp+052h]
        call _nmalloc_
        mov edx, eax
        mov dword [byte ebp+062h], eax
        test eax, eax
        jne short loc_A1E1F
        mov eax, dword [byte ebp+052h]
        add eax, byte 3
        and al, 0FCh
        mov edx, eax
        call CMainHook
        cmp edx, eax
        jae short loc_A1DF6
        mov eax, dword [byte ebp+052h]
        add eax, byte 3
        and al, 0FCh
        sub esp, eax
        mov eax, esp
        jmp short loc_A1DF8
loc_A1DF6:
        xor eax, eax
loc_A1DF8:
        mov dword [byte ebp+072h], eax
        test eax, eax
        jne short loc_A1E22
        mov eax, 2
        call __set_errno_
        mov eax, 0Ah
        mov dword [byte ebp+076h], 0FFFFFFFFh
        call __set_doserrno_
        jmp near loc_A1FC3
loc_A1E1F:
        mov dword [byte ebp+072h], eax
loc_A1E22:
        cmp byte [_osmajor], 3
        jb short loc_A1E42
        mov eax, dword [byte ebp+046h]
        cmp byte [eax], 0
        jne short loc_A1E42
        mov eax, dword [byte ebp+04Ah]
        cmp byte [eax], 0
        jne short loc_A1E42
        mov dword [byte ebp+04Ah], unk_C4AB4
loc_A1E42:
        push dword [byte ebp+042h]
        mov eax, dword [byte ebp+07Ah]
        mov edx, dword [byte ebp+046h]
        mov ebx, dword [byte ebp+04Ah]
        mov ecx, dword [byte ebp+03Eh]
        call _makepath_
        mov eax, 1
        call __set_errno_
        mov eax, dword [byte ebp+042h]
        cmp byte [eax], 0
        je short loc_A1EB2
        mov edx, str_Bat
        call stricmp_
        test eax, eax
        jne short loc_A1E92
        mov eax, dword [byte ebp+07Ah]
        mov dword [byte ebp+076h], 0FFFFFFFFh
        call SpawnPathExists
        test eax, eax
        jne near loc_A1F60
        jmp near loc_A1FC3
loc_A1E92:
        mov edx, dword [byte ebp+07Ah]
        xor eax, eax
        mov ebx, dword [byte ebp+072h]
        call __set_errno_
        push dword [byte ebp+06Eh]
        mov eax, dword [byte ebp-032h]
        mov ecx, dword [byte ebp+05Eh]
        call SpawnCommand
        jmp near loc_A1FC0
loc_A1EB2:
        mov eax, dword [byte ebp+07Ah]
        mov edx, dword [byte ebp+07Ah]
        call strlen_
        add edx, eax
        mov dword [byte ebp+06Ah], edx
        cmp byte [byte ebp+07Eh], 0
        je short loc_A1ED4
        mov eax, 1
        call __set_errno_
        jmp short loc_A1EFD
loc_A1ED4:
        mov ebx, dword [byte ebp+072h]
        push ds
        pop es
        mov edi, edx
        mov esi, str_Com
        xor eax, eax
        mov edx, dword [byte ebp+07Ah]
        movsd
        movsb
        call __set_errno_
        push dword [byte ebp+06Eh]
        mov eax, dword [byte ebp-032h]
        mov ecx, dword [byte ebp+05Eh]
        call SpawnCommand
        mov dword [byte ebp+076h], eax
loc_A1EFD:
        call ErrnoPtr
        cmp dword [eax], byte 1
        jne near loc_A1FC3
        mov edi, dword [byte ebp+06Ah]
        mov edx, dword [byte ebp+07Ah]
        xor eax, eax
        mov ebx, dword [byte ebp+072h]
        call __set_errno_
        push ds
        pop es
        mov esi, str_Exe
        push dword [byte ebp+06Eh]
        movsd
        movsb
        mov eax, dword [byte ebp-032h]
        mov ecx, dword [byte ebp+05Eh]
        call SpawnCommand
        mov dword [byte ebp+076h], eax
        call ErrnoPtr
        cmp dword [eax], byte 1
        jne near loc_A1FC3
        mov edi, dword [byte ebp+06Ah]
        xor eax, eax
        mov esi, str_Bat
        call __set_errno_
        mov eax, dword [byte ebp+07Ah]
        movsd
        movsb
        call SpawnPathExists
        test eax, eax
        je short loc_A1FC3
loc_A1F60:
        mov eax, dword [byte ebp+05Eh]
        mov edx, dword [byte ebp+06Eh]
        mov ebx, dword [byte ebp+072h]
        mov ecx, 1
        call _nfree_
        mov eax, dword [byte ebp+07Ah]
        mov dword [byte ebp+05Eh], 0
        call __ccmdline_
        push byte 0
        push dword [byte ebp+072h]
        movzx edx, byte [byte ebp+07Eh]
        push dword [byte ebp+07Ah]
        lea eax, [byte ebp+04Eh]
        call __Slash_C_
        push eax
        cmp byte [byte ebp+07Eh], 0
        je short loc_A1FA4
        mov eax, str_CMD
        jmp short loc_A1FA9
loc_A1FA4:
        mov eax, str_COMMAND
loc_A1FA9:
        push eax
        mov eax, str_COMSPEC
        call getenv_
        push eax
        push dword [byte ebp-032h]
        call spawnl_
        add esp, byte 1Ch
loc_A1FC0:
        mov dword [byte ebp+076h], eax
loc_A1FC3:
        mov eax, dword [byte ebp+062h]
        call _nfree_
        mov eax, dword [byte ebp+066h]
        call _nfree_
        mov eax, dword [byte ebp+05Eh]
        call _nfree_
        lea eax, [byte ebp-02Eh]
        call dword [off_D6604]
        mov eax, dword [byte ebp+076h]
loc_A1FE7:
        lea esp, [dword ebp+082h]
        pop ebp
        pop es
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
