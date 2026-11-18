; Watcom C runtime: the operating system handle of a file handle.
bits 32
%include "hockey.inc"
section s_972F0 progbits alloc exec nowrite align=1
global _os_handle_3
;-----------------------------------------------------------------------------
; _os_handle_3                                                  972F0  library
; C run-time: returns the operating system handle of a file handle
;-----------------------------------------------------------------------------
_os_handle_3:
        mov eax, dword [byte esp+04h]
        ret
        LD xor, eax, eax
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
