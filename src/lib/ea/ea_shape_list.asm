; EA graphics: shape lists and projected point lists.
bits 32
%include "hockey.inc"
section s_90B50 progbits alloc exec nowrite align=1
extern FindShape, FindShapeQuiet
global FindShapeList, ProjectPointList
;-----------------------------------------------------------------------------
; FindShapeList                                90B50  95 PC, medium confidence
; Looks up a list of shape ids in a bank
;-----------------------------------------------------------------------------
FindShapeList:
        push esi
        push edi
        push ebp
        mov ebp, dword [byte esp+010h]
        mov esi, dword [byte esp+014h]
        mov edi, dword [byte esp+018h]
        cmp byte [esi], 0
        je short .2
.1:
        push esi
        push ebp
        call FindShapeQuiet
        add esp, byte 8
        mov dword [edi], eax
        add edi, byte 4
        add esi, byte 4
        cmp byte [esi], 0
        jne short .1
.2:
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
;-----------------------------------------------------------------------------
; ProjectPointList                             90B80  95 PC, medium confidence
; Projects a list of 3D points to the screen through ProjectPoint
;-----------------------------------------------------------------------------
ProjectPointList:
        push esi
        push edi
        push ebp
        mov ebp, dword [byte esp+010h]
        mov esi, dword [byte esp+014h]
        mov edi, dword [byte esp+018h]
        cmp byte [esi], 0
        je short .2
.1:
        push esi
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [edi], eax
        add edi, byte 4
        add esi, byte 4
        cmp byte [esi], 0
        jne short .1
.2:
        pop ebp
        pop edi
        pop esi
        ret
        db 00h
