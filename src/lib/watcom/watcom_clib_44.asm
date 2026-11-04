; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_AA200 progbits alloc exec nowrite align=1
global outp_
outp_:
push ebx	; AA200
push ecx	; AA201
mov ebx, eax	; AA202
mov ecx, edx	; AA204
mov edx, eax	; AA206
mov al, cl	; AA208
out dx, al	; AA20A
pop ecx	; AA20B
pop ebx	; AA20C
ret	; AA20D
db 00h,00h
