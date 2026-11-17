; Watcom C runtime: inp.
bits 32
%include "hockey.inc"
section s_B128C progbits alloc exec nowrite align=1
global inp_
;-----------------------------------------------------------------------------
; inp_                                                          B128C  library
; Run-time library inp: reads a byte from an I/O port
;-----------------------------------------------------------------------------
inp_:
        push edx
        mov edx, eax
        sub eax, eax
        in al, dx
        pop edx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
