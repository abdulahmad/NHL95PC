; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_90C32 progbits alloc exec nowrite align=1
extern __doserror_, __set_errno_dos_
global rmdir_, loc_90C4D, _dos_close_, _dos_commit_, _dos_open_, loc_90C7A, _dos_creat_, loc_90C8D
global _dos_creatnew_, loc_90CA1, lseek_, loc_90CE0, loc_90CE3, _dos_read_, loc_90CEF, loc_90D08
global _dos_write_
rmdir_:
        push edx
        mov edx, eax
        mov ah, 3Ah
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jge short loc_90C4D
        and eax, 0FFFFh
        call __set_errno_dos_
        pop edx
        ret
loc_90C4D:
        xor eax, eax
        pop edx
        ret
        db 00h
_dos_close_:
        push ebx
        mov bx, ax
        mov ah, 3Eh
        int 21h
        call __doserror_
        pop ebx
        ret
_dos_commit_:
        push ebx
        mov bx, ax
        mov ah, 68h
        clc
        int 21h
        call __doserror_
        pop ebx
        ret
_dos_open_:
        xchg edx, eax
        mov ah, 3Dh
        int 21h
        jb short loc_90C7A
        mov dword [ebx], eax
loc_90C7A:
        call __doserror_
        ret
_dos_creat_:
        push ecx
        mov ecx, edx
        mov edx, eax
        mov ah, 3Ch
        int 21h
        jb short loc_90C8D
        mov dword [ebx], eax
loc_90C8D:
        call __doserror_
        pop ecx
        ret
_dos_creatnew_:
        push ecx
        mov ecx, edx
        mov edx, eax
        mov ah, 5Bh
        int 21h
        jb short loc_90CA1
        mov dword [ebx], eax
loc_90CA1:
        call __doserror_
        pop ecx
        ret
lseek_:
        push ecx
        push edi
        sub esp, byte 4
        mov ecx, eax
        mov eax, ebx
        mov edi, esp
        mov ebx, ecx
        mov ah, 42h
        mov ecx, edx
        shr ecx, 10h
        int 21h
        db 066h,036h,089h,07h                   ; insn: mov [ss:edi],ax
        db 066h,036h,089h,057h,02h              ; insn: mov [ss:edi+2],dx
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jge short loc_90CE0
        and eax, 0FFFFh
        call __set_errno_dos_
        mov eax, 0FFFFFFFFh
        jmp short loc_90CE3
loc_90CE0:
        mov eax, dword [esp]
loc_90CE3:
        add esp, byte 4
        pop edi
        pop ecx
        ret
        db 00h
_dos_read_:
        push dword 3F00h
loc_90CEF:
        push ds
        mov ds, ecx
        mov ecx, edx
        mov edx, ebx
        mov ebx, eax
        mov eax, dword [byte esp+04h]
        int 21h
        pop ds
        push ds
        jb short loc_90D08
        mov ebx, dword [byte esp+0Ch]
        mov dword [ebx], eax
loc_90D08:
        call __doserror_
        pop ds
        add esp, byte 4
        ret 4
_dos_write_:
        push dword 4000h
        jmp short loc_90CEF
        db 00h,00h,00h,00h,00h
