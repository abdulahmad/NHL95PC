; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B19C7 progbits alloc exec nowrite align=1
global outpw_
;-----------------------------------------------------------------------------
; outpw_                                                        B19C7  library
; Run-time library outpw: writes a word to an I/O port
;-----------------------------------------------------------------------------
outpw_:
        push ebx
        mov ebx, edx
        mov edx, eax
        mov eax, ebx
        out dx, ax
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
