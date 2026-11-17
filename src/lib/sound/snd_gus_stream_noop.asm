; Gravis UltraSound: the empty stream callback.
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
