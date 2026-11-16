; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_ADEE8 progbits alloc exec nowrite align=1
global GusStreamNoOp
;-----------------------------------------------------------------------------
; GusStreamNoOp                                   ADEE8  95 PC, low confidence
; Empty routine called during the GUS stream refill
;-----------------------------------------------------------------------------
GusStreamNoOp:
        ret
