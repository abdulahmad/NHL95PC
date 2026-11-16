; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_91FE0 progbits alloc exec nowrite align=1
extern KeyedDraw, RowCopyFunc, PutBlock, RemapRowKeyed, bcopy, BlitArtKeyColour
global DrawArtKeyColour, loc_92001, DrawArtKeyColourAtOwnPos
DrawArtKeyColour:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short loc_92001
        push eax
        push ebx
        push edx
        call BlitArtKeyColour
        add esp, byte 0Ch
        ret
loc_92001:
        mov dword [RowCopyFunc], RemapRowKeyed
        push eax
        push ebx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
DrawArtKeyColourAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtKeyColour
        add esp, byte 0Ch
        ret
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+08h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        sub ebx, eax
        push ebx
        mov eax, dword [byte edx+06h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        sub ebx, eax
        push ebx
        push edx
        call DrawArtKeyColour
        add esp, byte 0Ch
        ret
