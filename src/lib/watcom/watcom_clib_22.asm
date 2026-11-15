; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_96A58 progbits alloc exec nowrite align=1
global ios__failure__cause
ios__failure__cause:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+04h]
        ret
