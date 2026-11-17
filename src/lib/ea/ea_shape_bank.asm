; EA graphics: shape bank entries.
bits 32
%include "hockey.inc"
section s_90354 progbits alloc exec nowrite align=1
global ShapeBankCount, ShapeBankEntry, ShapeBankEntryId
;-----------------------------------------------------------------------------
; ShapeBankCount                               90354  95 PC, medium confidence
; Returns the number of shapes in a shape bank
;-----------------------------------------------------------------------------
ShapeBankCount:
        mov ebx, dword [byte esp+04h]
        mov eax, dword [byte ebx+08h]
        ret
;-----------------------------------------------------------------------------
; ShapeBankEntry                               9035C  95 PC, medium confidence
; Returns a shape in a bank by index, or 0
;-----------------------------------------------------------------------------
ShapeBankEntry:
        mov eax, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov ecx, dword [byte eax+08h]
        LD cmp, ebx, ecx
        jae short .1
        add eax, dword [byte eax+ebx*8+014h]
        ret
.1:
        LD xor, eax, eax
        ret
;-----------------------------------------------------------------------------
; ShapeBankEntryId                             90373  95 PC, medium confidence
; Stores a shape's id in a bank by index, or 0
;-----------------------------------------------------------------------------
ShapeBankEntryId:
        mov ebx, dword [byte esp+04h]
        mov eax, dword [byte esp+08h]
        mov edx, dword [byte esp+0Ch]
        mov ecx, dword [byte ebx+08h]
        LD cmp, eax, ecx
        jae short .1
        mov eax, dword [byte ebx+eax*8+010h]
        mov dword [edx], eax
        ret
.1:
        LD xor, eax, eax
        mov dword [edx], eax
        ret
