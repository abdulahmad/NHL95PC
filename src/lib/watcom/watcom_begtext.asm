; Watcom C startup stub. The first bytes of the program, before main.
bits 32
%include "hockey.inc"
section s_10000 progbits alloc exec nowrite align=1
global ___begtext, unk_10003
___begtext:
int3	; 10000
jmp short ___begtext	; 10001
unk_10003:
db 090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h
