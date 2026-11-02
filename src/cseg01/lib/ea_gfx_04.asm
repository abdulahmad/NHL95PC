; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_90C0F progbits alloc exec nowrite align=1
extern byte_D4D06
global loc_90C31, sub_90C0F
sub_90C0F:
cmp byte [byte_D4D06], 9	; 90C0F
jne short loc_90C31	; 90C16
push eax	; 90C18
push ebx	; 90C19
push ecx	; 90C1A
push esi	; 90C1B
push edi	; 90C1C
mov ah, 2Fh	; 90C1D
int 21h	; 90C1F
mov edi, ebx	; 90C21
mov esi, edx	; 90C23
mov ecx, 2Bh	; 90C25
rep movsb	; 90C2A
pop edi	; 90C2C
pop esi	; 90C2D
pop ecx	; 90C2E
pop ebx	; 90C2F
pop eax	; 90C30
loc_90C31:
ret	; 90C31
