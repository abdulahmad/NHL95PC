; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_932D0 progbits alloc exec nowrite align=1
extern SaveDataFile
global WriteFile, WriteFileQuiet
;-----------------------------------------------------------------------------
; WriteFile                                    932D0  95 PC, medium confidence
; File library: write a buffer to a file (path, buf, size)
;-----------------------------------------------------------------------------
WriteFile:
        push byte 1
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call SaveDataFile
        add esp, byte 10h
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; WriteFileQuiet                                  932EC  95 PC, low confidence
; Saves a file without the error message
;-----------------------------------------------------------------------------
WriteFileQuiet:
        push byte 0
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call SaveDataFile
        add esp, byte 10h
        ret
        db 08Bh,0C0h
