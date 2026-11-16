; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A2D16 progbits alloc exec nowrite align=1
extern __fatal_runtime_error_, __flush_, __IOMode_, __set_errno_, __set_errno_dos_, __shutdown_stream_, _nmalloc_, str_NotEnoughMemoryTo
extern byte_D4D59, UngetChar, dword_EDF00, dword_F24C8, loc_9B09F, lseek_, unk_D4D18, unk_D4D9A
global tell_, __InitFiles_, loc_A2D4B, loc_A2D7A, loc_A2D8E, __full_io_exit_, fcloseall_, docloseall_
global loc_A2DD2, loc_A2DEF, loc_A2DF5, loc_A2DF7, __qwrite_, loc_A2E3F, loc_A2E46, loc_A2E66
global loc_A2E74, loc_A2E76, sub_A2E80, __flushall_, loc_A2E94, loc_A2EA8, loc_A2EAA, getche_
global loc_A2ECF, __qread_, loc_A2EEE, __FDFS, loc_A2F2F, loc_A2F38
tell_:
        push ebx
        push edx
        mov ebx, 1
        xor edx, edx
        call lseek_
        pop edx
        pop ebx
        ret
__InitFiles_:
        push ebx
        push ecx
        push edx
        mov ah, byte [byte_D4D59]
        and ah, 0F8h
        mov dl, ah
        mov byte [byte_D4D59], ah
        or dl, 4
        mov ecx, unk_D4D18
        mov byte [byte_D4D59], dl
        jmp short loc_A2D8E
loc_A2D4B:
        mov eax, 8
        call _nmalloc_
        mov ebx, eax
        test eax, eax
        jne short loc_A2D7A
        mov eax, 8
        call _nmalloc_
        mov ebx, eax
        test eax, eax
        jne short loc_A2D7A
        mov eax, str_NotEnoughMemoryTo
        mov edx, 1
        call __fatal_runtime_error_
loc_A2D7A:
        mov edx, dword [dword_F24C8]
        mov dword [byte ebx+04h], ecx
        mov dword [dword_F24C8], ebx
        add ecx, byte 1Ah
        mov dword [ebx], edx
loc_A2D8E:
        mov edx, dword [byte ecx+0Ch]
        test edx, edx
        jne short loc_A2D4B
        mov dword [dword_EDF00], edx
        pop edx
        pop ecx
        pop ebx
        ret
__full_io_exit_:
        xor eax, eax
        call docloseall_
        jmp near loc_9B09F
fcloseall_:
        mov eax, 5
docloseall_:
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov esi, unk_D4D18
        add eax, eax
        xor ebx, ebx
        add esi, eax
        mov eax, dword [dword_F24C8]
        jmp short loc_A2DF7
loc_A2DD2:
        mov ecx, dword [eax]
        mov eax, dword [byte eax+04h]
        mov edx, 1
        test byte [byte eax+0Dh], 40h
        jne short loc_A2DEF
        cmp eax, esi
        jb short loc_A2DF5
        cmp eax, unk_D4D9A
        jae short loc_A2DEF
        xor edx, edx
loc_A2DEF:
        call __shutdown_stream_
        inc ebx
loc_A2DF5:
        mov eax, ecx
loc_A2DF7:
        test eax, eax
        jne short loc_A2DD2
        mov eax, ebx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__qwrite_:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov dword [esp], edx
        mov ebp, ebx
        call __IOMode_
        test al, 80h
        je short loc_A2E46
        mov al, 2
        mov ebx, esi
        xor edx, edx
        mov ah, 42h
        mov ecx, edx
        shr ecx, 10h
        int 21h
        rcl dx, 1
        ror dx, 1
        shl edx, 10h
        mov dx, ax
        mov edi, edx
        test edx, edx
        jge short loc_A2E46
        xor eax, eax
        mov ax, dx
loc_A2E3F:
        call __set_errno_dos_
        jmp short loc_A2E76
loc_A2E46:
        mov edx, dword [esp]
        mov ebx, esi
        mov ecx, ebp
        mov ah, 40h
        int 21h
        rcl eax, 1
        ror eax, 1
        mov esi, eax
        mov edi, eax
        mov edx, eax
        test eax, eax
        jge short loc_A2E66
        xor eax, eax
        mov ax, si
        jmp short loc_A2E3F
loc_A2E66:
        cmp eax, ebp
        je short loc_A2E74
        mov eax, 0Ch
        call __set_errno_
loc_A2E74:
        mov eax, edx
loc_A2E76:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 00h,00h
sub_A2E80:
        mov eax, 0FFFFFFFFh
__flushall_:
        push ebx
        push ecx
        push edx
        mov ecx, eax
        mov edx, dword [dword_F24C8]
        xor ebx, ebx
        jmp short loc_A2EAA
loc_A2E94:
        mov eax, dword [byte edx+04h]
        test dword [byte eax+0Ch], ecx
        je short loc_A2EA8
        inc ebx
        test byte [byte eax+0Dh], 10h
        je short loc_A2EA8
        call __flush_
loc_A2EA8:
        mov edx, dword [edx]
loc_A2EAA:
        test edx, edx
        jne short loc_A2E94
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
getche_:
        push edx
        xor edx, edx
        mov eax, dword [UngetChar]
        mov dword [UngetChar], edx
        test eax, eax
        jne short loc_A2ECF
        mov ah, 1
        int 21h
        and eax, 0FFh
loc_A2ECF:
        pop edx
        ret
__qread_:
        push ecx
        mov ecx, ebx
        mov ebx, eax
        mov ah, 3Fh
        int 21h
        rcl eax, 1
        ror eax, 1
        mov edx, eax
        test eax, eax
        jge short loc_A2EEE
        and eax, 0FFFFh
        call __set_errno_dos_
loc_A2EEE:
        pop ecx
        ret
__FDFS:
        push ebx
        test edx, 7FF00000h
        je short loc_A2F38
        sub ebx, ebx
        add eax, eax
        adc edx, edx
        rcr ebx, 1
        add eax, 20000000h
        adc edx, byte 0
        je short loc_A2F2F
        cmp edx, 8FE00000h
        jae short loc_A2F2F
        cmp edx, 70200000h
        jb short loc_A2F38
        sub edx, 70000000h
        add eax, eax
        adc edx, edx
        add eax, eax
        adc edx, edx
        or edx, ebx
        mov eax, edx
        pop ebx
        ret
loc_A2F2F:
        mov eax, 7F800000h
        or eax, ebx
        pop ebx
        ret
loc_A2F38:
        sub eax, eax
        pop ebx
        ret
        db 00h,00h,00h,00h
