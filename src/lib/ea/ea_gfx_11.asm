; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_92F50 progbits alloc exec nowrite align=1
extern FillRectClipped, XorRectClipped
global XorRectOutline, DrawFrameClipped
;-----------------------------------------------------------------------------
; XorRectOutline                               92F50  95 PC, medium confidence
; XORs the outline of a rectangle as four edges
;-----------------------------------------------------------------------------
XorRectOutline:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, dword [byte esp+018h]
        mov edi, dword [byte esp+01Ch]
        mov ebp, dword [byte esp+020h]
        cmp ebp, esi
        jge short .1
        mov eax, esi
        mov esi, ebp
        mov ebp, eax
.1:
        mov eax, ebp
        sub eax, esi
        inc eax
        mov dword [byte esp+04h], eax
        mov edx, dword [byte esp+024h]
        cmp edi, edx
        jle short .2
        mov dword [esp], edi
        mov edi, edx
        mov eax, dword [esp]
        mov dword [byte esp+024h], eax
.2:
        mov eax, dword [byte esp+024h]
        sub eax, edi
        dec eax
        mov dword [esp], eax
        mov ebx, dword [byte esp+028h]
        push ebx
        push byte 1
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push edi
        push esi
        call XorRectClipped
        add esp, byte 14h
        mov eax, dword [byte esp+028h]
        push eax
        mov edx, dword [byte esp+04h]
        push edx
        push byte 1
        inc edi
        push edi
        push ebp
        call XorRectClipped
        add esp, byte 14h
        mov ebx, dword [byte esp+028h]
        push ebx
        mov ecx, dword [byte esp+04h]
        push ecx
        push byte 1
        push edi
        push esi
        call XorRectClipped
        add esp, byte 14h
        mov edi, dword [byte esp+028h]
        push edi
        push byte 1
        mov ebp, dword [byte esp+0Ch]
        push ebp
        mov eax, dword [byte esp+030h]
        push eax
        push esi
        call XorRectClipped
        add esp, byte 14h
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; DrawFrameClipped                             93000  95 PC, medium confidence
; Draws a rectangle outline with four clipped fills
;-----------------------------------------------------------------------------
DrawFrameClipped:
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, dword [byte esp+018h]
        mov edi, dword [byte esp+01Ch]
        mov ebp, dword [byte esp+020h]
        cmp ebp, esi
        jge short .1
        mov eax, esi
        mov esi, ebp
        mov ebp, eax
.1:
        mov eax, ebp
        sub eax, esi
        inc eax
        mov dword [byte esp+04h], eax
        mov edx, dword [byte esp+024h]
        cmp edi, edx
        jle short .2
        mov dword [esp], edi
        mov edi, edx
        mov eax, dword [esp]
        mov dword [byte esp+024h], eax
.2:
        mov eax, dword [byte esp+024h]
        sub eax, edi
        dec eax
        mov dword [esp], eax
        mov ebx, dword [byte esp+028h]
        push ebx
        push byte 1
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push edi
        push esi
        call FillRectClipped
        add esp, byte 14h
        mov eax, dword [byte esp+028h]
        push eax
        mov edx, dword [byte esp+04h]
        push edx
        push byte 1
        inc edi
        push edi
        push ebp
        call FillRectClipped
        add esp, byte 14h
        mov ebx, dword [byte esp+028h]
        push ebx
        mov ecx, dword [byte esp+04h]
        push ecx
        push byte 1
        push edi
        push esi
        call FillRectClipped
        add esp, byte 14h
        mov edi, dword [byte esp+028h]
        push edi
        push byte 1
        mov ebp, dword [byte esp+0Ch]
        push ebp
        mov eax, dword [byte esp+030h]
        push eax
        push esi
        call FillRectClipped
        add esp, byte 14h
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
