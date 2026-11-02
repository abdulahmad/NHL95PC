; Keyboard handlers run on the way out of the program.
bits 32
%include "hockey.inc"
section s_98A40 progbits alloc exec nowrite align=1
extern sub_B3B2E, sub_B3C60
global loc_98A79, sub_98A40
sub_98A40:
sub esp, byte 0Ch	; 98A40
mov eax, esp	; 98A43
push eax	; 98A45
lea eax, [byte esp+08h]	; 98A46
push eax	; 98A4A
lea eax, [byte esp+010h]	; 98A4B
push eax	; 98A4F
mov edx, dword [byte esp+01Ch]	; 98A50
push edx	; 98A54
call sub_B3B2E	; 98A55
add esp, byte 10h	; 98A5A
mov ebx, dword [byte esp+08h]	; 98A5D
push ebx	; 98A61
call sub_B3C60	; 98A62
add esp, byte 4	; 98A67
cmp dword [byte esp+08h], byte 0	; 98A6A
je short loc_98A79	; 98A6F
mov dword [byte esp+08h], 1	; 98A71
loc_98A79:
mov eax, dword [byte esp+08h]	; 98A79
add esp, byte 0Ch	; 98A7D
ret	; 98A80
