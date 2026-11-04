; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_932D0 progbits alloc exec nowrite align=1
extern sub_93308
global sub_932D0, sub_932EC
sub_932D0:
push byte 1	; 932D0
mov edx, dword [byte esp+010h]	; 932D2
push edx	; 932D6
mov ebx, dword [byte esp+010h]	; 932D7
push ebx	; 932DB
mov ecx, dword [byte esp+010h]	; 932DC
push ecx	; 932E0
call sub_93308	; 932E1
add esp, byte 10h	; 932E6
ret	; 932E9
db 08Bh,0C0h
sub_932EC:
push byte 0	; 932EC
mov edx, dword [byte esp+010h]	; 932EE
push edx	; 932F2
mov ebx, dword [byte esp+010h]	; 932F3
push ebx	; 932F7
mov ecx, dword [byte esp+010h]	; 932F8
push ecx	; 932FC
call sub_93308	; 932FD
add esp, byte 10h	; 93302
ret	; 93305
db 08Bh,0C0h
