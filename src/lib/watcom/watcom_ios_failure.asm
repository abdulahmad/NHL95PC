; Watcom C++ runtime: ios failure cause.
bits 32
%include "hockey.inc"
section s_96A58 progbits alloc exec nowrite align=1
global ios__failure__cause
;-----------------------------------------------------------------------------
; ios__failure__cause                                           96A58  library
; C++ run-time: returns the cause stored in an ios failure exception
;-----------------------------------------------------------------------------
ios__failure__cause:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+04h]
        ret
