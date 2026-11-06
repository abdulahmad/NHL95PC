; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_8DC9C progbits alloc exec nowrite align=1
extern int386x_, segread_
global int386_
int386_:
push ecx	; 8DC9C
sub esp, byte 0Ch	; 8DC9D
mov ecx, eax	; 8DCA0
mov eax, esp	; 8DCA2
call segread_	; 8DCA4
mov eax, ecx	; 8DCA9
mov ecx, esp	; 8DCAB
call int386x_	; 8DCAD
add esp, byte 0Ch	; 8DCB2
pop ecx	; 8DCB5
ret	; 8DCB6
