; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B1951 progbits alloc exec nowrite align=1
global inpw_
;-----------------------------------------------------------------------------
; inpw_                                                         B1951  library
; Run-time library inpw: reads a word from an I/O port
;-----------------------------------------------------------------------------
inpw_:
        push edx
        mov edx, eax
        sub eax, eax
        in ax, dx
        pop edx
        ret
        db 00h,00h
