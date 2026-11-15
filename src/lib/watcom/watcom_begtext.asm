; Watcom C startup stub. The first bytes of the program, before main.
bits 32
%include "hockey.inc"
section s_10000 progbits alloc exec nowrite align=1
global begtext_forever, ___begtext
begtext_forever:
int3	; 10000
jmp short begtext_forever	; 10001
___begtext:
db 090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h
