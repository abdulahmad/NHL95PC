; Blitting into an MCGA window.
bits 32
%include "hockey.inc"
section s_9AFAD progbits alloc exec nowrite align=1
global McgaNoWindow
McgaNoWindow:
        xor eax, eax
        ret
