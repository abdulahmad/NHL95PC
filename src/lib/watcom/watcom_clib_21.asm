; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_96185 progbits alloc exec nowrite align=1
extern __delay_, __fprtf_, __IOMode_, __set_errno_, __set_errno_dos_, __sys_fini_387_emulator, __sys_init_387_emulator, fputc_
extern fputs_, strerror_, __STKOVF, ErrnoPtr, CMainHook, unk_C472C, unk_D4D4C
global fprintf_, strupr_, loc_961B4, loc_961C7, loc_961CA, __CHP, j___sys_init_387_emulator, j___sys_fini_387_emulator
global strlwr_, loc_961FC, loc_9620F, loc_96212, j___delay_, perror_, loc_96240, write_
global loc_96286, loc_96295, loc_962A0, loc_962C7, loc_962D7, loc_96312, loc_96325, loc_96337
global loc_96351, loc_96391, loc_963A5, loc_963AD, loc_963F8, loc_9642E, loc_96431
fprintf_:
        push ebx
        push edx
        sub esp, byte 4
        lea ebx, [byte esp+018h]
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        mov dword [esp], ebx
        mov ebx, esp
        call __fprtf_
        add esp, byte 4
        pop edx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
strupr_:
        push ebx
        push edx
        mov ebx, eax
loc_961B4:
        mov dl, byte [eax]
        test dl, dl
        je short loc_961CA
        sub dl, 61h
        cmp dl, 19h
        ja short loc_961C7
        add dl, 41h
        mov byte [eax], dl
loc_961C7:
        inc eax
        jmp short loc_961B4
loc_961CA:
        mov eax, ebx
        pop edx
        pop ebx
        ret
        db 00h
__CHP:
        push eax
        wait
        fnstcw word [esp]
        wait
        push dword [esp]
        mov byte [byte esp+01h], 1Fh
        fldcw word [esp]
        frndint
        fldcw word [byte esp+04h]
        wait
        lea esp, [byte esp+08h]
        ret
        db 00h
j___sys_init_387_emulator:
        jmp near __sys_init_387_emulator
j___sys_fini_387_emulator:
        jmp near __sys_fini_387_emulator
strlwr_:
        push ebx
        push edx
        mov ebx, eax
loc_961FC:
        mov dl, byte [eax]
        test dl, dl
        je short loc_96212
        sub dl, 41h
        cmp dl, 19h
        ja short loc_9620F
        add dl, 61h
        mov byte [eax], dl
loc_9620F:
        inc eax
        jmp short loc_961FC
loc_96212:
        mov eax, ebx
        pop edx
        pop ebx
        ret
        db 00h
j___delay_:
        jmp near __delay_
perror_:
        push edx
        test eax, eax
        je short loc_96240
        cmp byte [eax], 0
        je short loc_96240
        mov edx, unk_D4D4C
        call fputs_
        mov eax, unk_C472C
        mov edx, unk_D4D4C
        call fputs_
loc_96240:
        call ErrnoPtr
        mov eax, dword [eax]
        mov edx, unk_D4D4C
        call strerror_
        call fputs_
        mov eax, 0Ah
        mov edx, unk_D4D4C
        call fputc_
        pop edx
        ret
write_:
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 18h
        push eax
        push edx
        push ebx
        call __IOMode_
        mov edx, eax
        mov dword [byte ebp-018h], eax
        test eax, eax
        jne short loc_96295
        mov eax, 4
loc_96286:
        call __set_errno_
        mov eax, 0FFFFFFFFh
        jmp near loc_96431
loc_96295:
        test al, 2
        jne short loc_962A0
        mov eax, 6
        jmp short loc_96286
loc_962A0:
        test al, 80h
        je short loc_962D7
        mov ebx, dword [byte ebp-01Ch]
        xor edx, eax
        mov al, 2
        mov ah, 42h
        mov ecx, edx
        shr ecx, 10h
        int 21h
        rcl dx, 1
        ror dx, 1
        shl edx, 10h
        mov dx, ax
        mov dword [byte ebp-010h], edx
        test edx, edx
        jge short loc_962D7
loc_962C7:
        xor eax, eax
        mov ax, word [byte ebp-010h]
        call __set_errno_dos_
        jmp near loc_96431
loc_962D7:
        test byte [byte ebp-018h], 40h
        je short loc_96312
        mov ebx, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-020h]
        mov ecx, dword [byte ebp-024h]
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov edx, eax
        mov dword [byte ebp-010h], eax
        test eax, eax
        jl short loc_962C7
        cmp eax, dword [byte ebp-024h]
        je near loc_9642E
        mov eax, 0Ch
        call __set_errno_
        mov dword [byte ebp-024h], edx
        jmp near loc_9642E
loc_96312:
        call CMainHook
        mov edx, eax
        cmp eax, 0B0h
        jae short loc_96325
        call __STKOVF
loc_96325:
        mov edi, 200h
        cmp edx, 230h
        jae short loc_96337
        mov edi, 80h
loc_96337:
        lea eax, [byte edi+03h]
        xor edx, edx
        and al, 0FCh
        xor esi, esi
        sub esp, eax
        mov dword [byte ebp-04h], edx
        mov dword [byte ebp-014h], edx
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-08h], esp
        mov dword [byte ebp-0Ch], eax
loc_96351:
        mov eax, dword [byte ebp-04h]
        cmp eax, dword [byte ebp-024h]
        jae near loc_963F8
        mov eax, dword [byte ebp-0Ch]
        cmp byte [eax], 0Ah
        jne short loc_963AD
        mov eax, dword [byte ebp-08h]
        mov byte [esi+eax], 0Dh
        inc esi
        cmp esi, edi
        jne short loc_963AD
        mov ebx, dword [byte ebp-01Ch]
        mov edx, eax
        mov ecx, edi
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov dword [byte ebp-010h], eax
        test eax, eax
        jl near loc_962C7
        cmp eax, edi
        je short loc_963A5
loc_96391:
        mov eax, 0Ch
        call __set_errno_
        mov eax, dword [byte ebp-014h]
        add eax, esi
        jmp near loc_96431
loc_963A5:
        mov eax, dword [byte ebp-04h]
        xor esi, edi
        mov dword [byte ebp-014h], eax
loc_963AD:
        mov eax, dword [byte ebp-08h]
        mov edx, dword [byte ebp-0Ch]
        mov ebx, dword [byte ebp-0Ch]
        mov ecx, dword [byte ebp-04h]
        inc ebx
        inc ecx
        mov dl, byte [edx]
        mov dword [byte ebp-0Ch], ebx
        mov byte [esi+eax], dl
        inc esi
        mov dword [byte ebp-04h], ecx
        cmp esi, edi
        jne short loc_96351
        mov ebx, dword [byte ebp-01Ch]
        mov edx, eax
        mov ecx, edi
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov dword [byte ebp-010h], eax
        test eax, eax
        jl near loc_962C7
        cmp eax, edi
        jne short loc_96391
        mov eax, dword [byte ebp-04h]
        xor esi, edi
        mov dword [byte ebp-014h], eax
        jmp near loc_96351
loc_963F8:
        test esi, esi
        je short loc_9642E
        mov ebx, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-08h]
        mov ecx, esi
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov edx, eax
        mov dword [byte ebp-010h], eax
        test eax, eax
        jl near loc_962C7
        cmp eax, esi
        je short loc_9642E
        mov eax, 0Ch
        call __set_errno_
        mov eax, dword [byte ebp-014h]
        add eax, edx
        jmp short loc_96431
loc_9642E:
        mov eax, dword [byte ebp-024h]
loc_96431:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
