; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B1951 progbits alloc exec nowrite align=1
global inpw_
inpw_:
push edx	; B1951
mov edx, eax	; B1952
sub eax, eax	; B1954
in ax, dx	; B1956
pop edx	; B1958
ret	; B1959
db 00h,00h
