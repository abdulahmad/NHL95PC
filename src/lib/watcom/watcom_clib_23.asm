; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_972F0 progbits alloc exec nowrite align=1
global _os_handle_3, sub_972F5
_os_handle_3:
        mov eax, dword [byte esp+04h]
        ret
sub_972F5:
        LD xor, eax, eax
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
