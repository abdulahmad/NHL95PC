; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8DBE4 progbits alloc exec nowrite align=1
extern __fprtf_, __set_EINVAL_, loc_90265, off_D2F68, off_D2F6C, off_D2F70, unk_D4D32
global type_info__raw_name, sub_8DBEC, _dos_getdrive_, _dos_setdrive_, printf_, __null_int23_exit_, exit_, sub_8DC55
global _exit_, _dos_getdiskfree_, loc_8DC92, loc_8DC97
type_info__raw_name:
        mov eax, dword [byte esp+04h]
        add eax, byte 4
        ret
sub_8DBEC:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+018h]
        ret
_dos_getdrive_:
        push ebx
        mov ebx, eax
        sub eax, eax
        mov ah, 19h
        int 21h
        inc ax
        mov ah, 0
        mov dword [ebx], eax
        sub ax, ax
        pop ebx
        ret
_dos_setdrive_:
        push ebx
        mov ebx, edx
        mov edx, eax
        dec edx
        sub eax, eax
        mov ah, 0Eh
        int 21h
        mov ah, 0
        mov dword [ebx], eax
        sub eax, eax
        pop ebx
        ret
printf_:
        push ebx
        push edx
        sub esp, byte 4
        lea ebx, [byte esp+014h]
        mov eax, unk_D4D32
        mov edx, dword [byte esp+010h]
        mov dword [esp], ebx
        mov ebx, esp
        call __fprtf_
        add esp, byte 4
        pop edx
        pop ebx
        ret
__null_int23_exit_:
        ret
exit_:
        push edx
        mov edx, eax
        call dword [off_D2F68]
        call dword [off_D2F6C]
        mov eax, edx
        call _exit_
sub_8DC55:
        pop edx
        ret
_exit_:
        push edx
        mov edx, eax
        call dword [off_D2F6C]
        call dword [off_D2F70]
        mov eax, edx
        jmp near loc_90265
        db 00h
_dos_getdiskfree_:
        push edi
        push ecx
        push ebx
        mov edi, edx
        mov edx, eax
        mov ah, 36h
        int 21h
        cmp ax, 0FFFFh
        je short loc_8DC92
        mov word [edi], dx
        mov word [byte edi+02h], bx
        mov word [byte edi+04h], ax
        mov word [byte edi+06h], cx
        sub eax, eax
        jmp short loc_8DC97
loc_8DC92:
        call __set_EINVAL_
loc_8DC97:
        pop ebx
        pop ecx
        pop edi
        ret
        db 00h
