; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8DBE4 progbits alloc exec nowrite align=1
extern __fprtf_, __set_EINVAL_, __saved_DS, ExitHook, Int23Hook, FpuExitHook, __stdout_buf
global type_info__raw_name, _dos_getdrive_, _dos_setdrive_, printf_, __null_int23_exit_, exit_, _exit_, _dos_getdiskfree_
;-----------------------------------------------------------------------------
; type_info__raw_name                                           8DBE4  library
; Run-time library: returns the name field of a type info record
;-----------------------------------------------------------------------------
type_info__raw_name:
        mov eax, dword [byte esp+04h]
        add eax, byte 4
        ret
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+018h]
        ret
;-----------------------------------------------------------------------------
; _dos_getdrive_                                                8DBF4  library
; C run-time: returns the current DOS drive
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; _dos_setdrive_                                                8DC08  library
; C run-time: sets the current DOS drive and returns the number of drives
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; printf_                                                       8DC1C  library
; Run-time library printf: formats to standard output
;-----------------------------------------------------------------------------
printf_:
        push ebx
        push edx
        sub esp, byte 4
        lea ebx, [byte esp+014h]
        mov eax, __stdout_buf
        mov edx, dword [byte esp+010h]
        mov dword [esp], ebx
        mov ebx, esp
        call __fprtf_
        add esp, byte 4
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; __null_int23_exit_                                            8DC3E  library
; Run-time library: empty Ctrl+C exit hook
;-----------------------------------------------------------------------------
__null_int23_exit_:
        ret
;-----------------------------------------------------------------------------
; exit_                                                         8DC3F  library
; Run-time library exit: runs the exit routines and ends the program
;-----------------------------------------------------------------------------
exit_:
        push edx
        mov edx, eax
        call dword [ExitHook]
        call dword [Int23Hook]
        mov eax, edx
        call _exit_
        pop edx
        ret
;-----------------------------------------------------------------------------
; _exit_                                                        8DC57  library
; Run-time library _exit: ends the program at once
;-----------------------------------------------------------------------------
_exit_:
        push edx
        mov edx, eax
        call dword [Int23Hook]
        call dword [FpuExitHook]
        mov eax, edx
        jmp near __saved_DS+021Dh
        db 00h
;-----------------------------------------------------------------------------
; _dos_getdiskfree_                                             8DC6E  library
; Run-time library _dos_getdiskfree: free space of a drive
;-----------------------------------------------------------------------------
_dos_getdiskfree_:
        push edi
        push ecx
        push ebx
        mov edi, edx
        mov edx, eax
        mov ah, 36h
        int 21h
        cmp ax, 0FFFFh
        je short .1
        mov word [edi], dx
        mov word [byte edi+02h], bx
        mov word [byte edi+04h], ax
        mov word [byte edi+06h], cx
        sub eax, eax
        jmp short .2
.1:
        call __set_EINVAL_
.2:
        pop ebx
        pop ecx
        pop edi
        ret
        db 00h
