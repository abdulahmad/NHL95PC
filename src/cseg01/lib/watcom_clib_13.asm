; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_91350 progbits alloc exec nowrite align=1
extern __STOSB
global memset_
memset_:
push eax	; 91350
push ecx	; 91351
mov dh, dl	; 91352
shl edx, 8	; 91354
mov dl, dh	; 91357
shl edx, 8	; 91359
mov dl, dh	; 9135C
mov ecx, ebx	; 9135E
call __STOSB	; 91360
pop ecx	; 91365
pop eax	; 91366
ret	; 91367
db 00h,00h,00h,00h,00h,00h,00h,00h
