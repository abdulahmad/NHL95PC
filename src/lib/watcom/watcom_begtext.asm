; Watcom C startup stub. The first bytes of the program, before main.
bits 32
%include "hockey.inc"
section s_10000 progbits alloc exec nowrite align=1
global sub_10000, unk_10003
sub_10000:
int3	; 10000
jmp short sub_10000	; 10001
unk_10003:
db 090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h
