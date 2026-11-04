; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B19C7 progbits alloc exec nowrite align=1
global outpw_
outpw_:
push ebx	; B19C7
mov ebx, edx	; B19C8
mov edx, eax	; B19CA
mov eax, ebx	; B19CC
out dx, ax	; B19CE
pop ebx	; B19D0
ret	; B19D1
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
