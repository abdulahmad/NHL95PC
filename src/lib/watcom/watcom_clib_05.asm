; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_8E3C0 progbits alloc exec nowrite align=1
global AssetLoadNoOp, _os_handle, _os_handle_0, _os_handle_1
;-----------------------------------------------------------------------------
; AssetLoadNoOp                                   8E3C0  95 PC, low confidence
; Empty routine called after the player photos load
;-----------------------------------------------------------------------------
AssetLoadNoOp:
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; _os_handle                                                    8E3C4  library
; Run-time library: returns the operating system handle of a file handle
;-----------------------------------------------------------------------------
_os_handle:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; _os_handle_0                                                  8E3CC  library
;-----------------------------------------------------------------------------
_os_handle_0:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; _os_handle_1                                                  8E3D4  library
;-----------------------------------------------------------------------------
_os_handle_1:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
