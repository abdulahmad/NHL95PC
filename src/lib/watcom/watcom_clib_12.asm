; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_90C32 progbits alloc exec nowrite align=1
extern __doserror_, __set_errno_dos_
global rmdir_, _dos_close_, _dos_commit_, _dos_open_, _dos_creat_, _dos_creatnew_, lseek_, _dos_read_
global _dos_write_
;-----------------------------------------------------------------------------
; rmdir_                                                        90C32  library
; Run-time library rmdir: removes a directory
;-----------------------------------------------------------------------------
rmdir_:
        push edx
        mov edx, eax
        mov ah, 3Ah
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jge short .1
        and eax, 0FFFFh
        call __set_errno_dos_
        pop edx
        ret
.1:
        xor eax, eax
        pop edx
        ret
        db 00h
;-----------------------------------------------------------------------------
; _dos_close_                                                   90C52  library
; Run-time library _dos_close: closes a DOS file handle
;-----------------------------------------------------------------------------
_dos_close_:
        push ebx
        mov bx, ax
        mov ah, 3Eh
        int 21h
        call __doserror_
        pop ebx
        ret
;-----------------------------------------------------------------------------
; _dos_commit_                                                  90C61  library
; Run-time library _dos_commit: flushes a DOS file to disk
;-----------------------------------------------------------------------------
_dos_commit_:
        push ebx
        mov bx, ax
        mov ah, 68h
        clc
        int 21h
        call __doserror_
        pop ebx
        ret
;-----------------------------------------------------------------------------
; _dos_open_                                                    90C71  library
; Run-time library _dos_open: opens a DOS file
;-----------------------------------------------------------------------------
_dos_open_:
        xchg edx, eax
        mov ah, 3Dh
        int 21h
        jb short .1
        mov dword [ebx], eax
.1:
        call __doserror_
        ret
;-----------------------------------------------------------------------------
; _dos_creat_                                                   90C80  library
; Run-time library _dos_creat: creates or truncates a file and returns its
; handle
;-----------------------------------------------------------------------------
_dos_creat_:
        push ecx
        mov ecx, edx
        mov edx, eax
        mov ah, 3Ch
        int 21h
        jb short .1
        mov dword [ebx], eax
.1:
        call __doserror_
        pop ecx
        ret
;-----------------------------------------------------------------------------
; _dos_creatnew_                               90C94  95 PC, medium confidence
; DOS create-new-file call (function 5Bh)
;-----------------------------------------------------------------------------
_dos_creatnew_:
        push ecx
        mov ecx, edx
        mov edx, eax
        mov ah, 5Bh
        int 21h
        jb short .1
        mov dword [ebx], eax
.1:
        call __doserror_
        pop ecx
        ret
;-----------------------------------------------------------------------------
; lseek_                                                        90CA8  library
; Run-time library lseek: moves a file handle's position
;-----------------------------------------------------------------------------
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
        jge short .1
        and eax, 0FFFFh
        call __set_errno_dos_
        mov eax, 0FFFFFFFFh
        jmp short .2
.1:
        mov eax, dword [esp]
.2:
        add esp, byte 4
        pop edi
        pop ecx
        ret
        db 00h
;-----------------------------------------------------------------------------
; _dos_read_                                                    90CEA  library
; Run-time library _dos_read: reads from a DOS file handle
;-----------------------------------------------------------------------------
_dos_read_:
        push dword 3F00h
        push ds
        mov ds, ecx
        mov ecx, edx
        mov edx, ebx
        mov ebx, eax
        mov eax, dword [byte esp+04h]
        int 21h
        pop ds
        push ds
        jb short .1
        mov ebx, dword [byte esp+0Ch]
        mov dword [ebx], eax
.1:
        call __doserror_
        pop ds
        add esp, byte 4
        ret 4
;-----------------------------------------------------------------------------
; _dos_write_                                                   90D14  library
; Run-time library _dos_write: writes to a DOS file handle through the shared
; read and write code
;-----------------------------------------------------------------------------
_dos_write_:
        push dword 4000h
        jmp short _dos_read_+05h
        db 00h,00h,00h,00h,00h
