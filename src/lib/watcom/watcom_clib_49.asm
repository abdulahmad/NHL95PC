; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B128C progbits alloc exec nowrite align=1
global inp_
inp_:
        push edx
        mov edx, eax
        sub eax, eax
        in al, dx
        pop edx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
