; Blitting into an MCGA window.
bits 32
%include "hockey.inc"
section s_9AFAD progbits alloc exec nowrite align=1
global sub_9AFAD
sub_9AFAD:
xor eax, eax	; 9AFAD
ret	; 9AFAF
