; Blitting into an MCGA window.
bits 32
%include "hockey.inc"
section s_9AFAD progbits alloc exec nowrite align=1
global McgaNoWindow
;-----------------------------------------------------------------------------
; McgaNoWindow                                 9AFAD  95 PC, medium confidence
; Returns 0: the MCGA screen needs no window
;-----------------------------------------------------------------------------
McgaNoWindow:
        xor eax, eax
        ret
