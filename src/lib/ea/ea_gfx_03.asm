; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_90B50 progbits alloc exec nowrite align=1
extern FindShape, FindShapeQuiet
global FindShapeList, loc_90B64, loc_90B7B, ProjectPointList, loc_90B94, loc_90BAB
FindShapeList:
        push esi
        push edi
        push ebp
        mov ebp, dword [byte esp+010h]
        mov esi, dword [byte esp+014h]
        mov edi, dword [byte esp+018h]
        cmp byte [esi], 0
        je short loc_90B7B
loc_90B64:
        push esi
        push ebp
        call FindShapeQuiet
        add esp, byte 8
        mov dword [edi], eax
        add edi, byte 4
        add esi, byte 4
        cmp byte [esi], 0
        jne short loc_90B64
loc_90B7B:
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
ProjectPointList:
        push esi
        push edi
        push ebp
        mov ebp, dword [byte esp+010h]
        mov esi, dword [byte esp+014h]
        mov edi, dword [byte esp+018h]
        cmp byte [esi], 0
        je short loc_90BAB
loc_90B94:
        push esi
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [edi], eax
        add edi, byte 4
        add esi, byte 4
        cmp byte [esi], 0
        jne short loc_90B94
loc_90BAB:
        pop ebp
        pop edi
        pop esi
        ret
        db 00h
