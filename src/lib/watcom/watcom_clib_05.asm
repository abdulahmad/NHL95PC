; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8E3C0 progbits alloc exec nowrite align=1
global AssetLoadNoOp, _os_handle, _os_handle_0, _os_handle_1
AssetLoadNoOp:
        ret
        db 08Dh,040h,00h
_os_handle:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
_os_handle_0:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
_os_handle_1:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
