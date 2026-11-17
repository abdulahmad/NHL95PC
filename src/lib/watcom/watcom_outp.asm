; Watcom C runtime: outp.
bits 32
%include "hockey.inc"
section s_AA200 progbits alloc exec nowrite align=1
global outp_
;-----------------------------------------------------------------------------
; outp_                                                         AA200  library
; Run-time library outp: writes a byte to an I/O port
;-----------------------------------------------------------------------------
outp_:
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        mov edx, eax
        mov al, cl
        out dx, al
        pop ecx
        pop ebx
        ret
        db 00h,00h
