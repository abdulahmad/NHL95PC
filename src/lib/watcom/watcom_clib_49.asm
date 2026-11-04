; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B128C progbits alloc exec nowrite align=1
global inp_
inp_:
push edx	; B128C
mov edx, eax	; B128D
sub eax, eax	; B128F
in al, dx	; B1291
pop edx	; B1292
ret	; B1293
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
