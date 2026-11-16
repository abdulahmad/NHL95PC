; Watcom C startup stub. The first bytes of the program, before main.
bits 32
%include "hockey.inc"
section s_10000 progbits alloc exec nowrite align=1
global begtext_forever, ___begtext
;-----------------------------------------------------------------------------
; begtext_forever                                                 10000  95 PC
; Watcom BEGTEXT: the int3 / jmp forever loop at the first code address
; (Watcom's label is forever); the port uses it as the base of the game image
;-----------------------------------------------------------------------------
begtext_forever:
        int3
        jmp short begtext_forever
___begtext:                                     ; used by start
        db 090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h,090h
