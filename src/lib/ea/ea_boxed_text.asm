; EA graphics: boxed text, keyed row remap and masked art.
bits 32
%include "hockey.inc"
section s_93170 progbits alloc exec nowrite align=1
extern bcopy, BlitArtMasked, ColourRemap, DrawArtOpaque, KeyedDraw, RowCopyFunc, TextPrintAt, vsprintf_
global PrintBoxedText, RemapRowKeyed, DrawArtMasked, DrawArtMaskedAtOwnPos
;-----------------------------------------------------------------------------
; PrintBoxedText                               93170  95 PC, medium confidence
; Formats text like printf and draws it on a box at x, y
;-----------------------------------------------------------------------------
PrintBoxedText:
        sub esp, 104h
        lea eax, [dword esp+0114h]
        mov dword [dword esp+0100h], eax
        lea ebx, [dword esp+0100h]
        mov edx, dword [dword esp+0110h]
        mov eax, esp
        call vsprintf_
        mov edx, dword [dword esp+010Ch]
        push edx
        mov ebx, dword [dword esp+010Ch]
        push ebx
        lea eax, [byte esp+08h]
        push eax
        call TextPrintAt
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [dword esp+0100h], ecx
        add esp, 104h
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; RemapRowKeyed                                   931D0  95 PC, low confidence
; Copies bytes through the text remap table, skipping colour FFh
;-----------------------------------------------------------------------------
RemapRowKeyed:
        mov ebx, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov edx, dword [byte esp+04h]
        mov eax, ebx
        test ecx, ecx
        je short .3
        add ecx, ebx
.1:
        xor ebx, ebx
        mov bl, byte [edx]
        mov bl, byte [dword ebx+ColourRemap]
        inc edx
        cmp bl, 0FFh
        je short .2
        mov byte [eax], bl
.2:
        inc eax
        cmp eax, ecx
        jb short .1
.3:
        ret
;-----------------------------------------------------------------------------
; DrawArtMasked                                931FC  95 PC, medium confidence
; Graphics library: draw art at x, y masked (line editor slots)
;-----------------------------------------------------------------------------
DrawArtMasked:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push eax
        push ebx
        push edx
        call BlitArtMasked
        add esp, byte 0Ch
        ret
.1:
        mov dword [RowCopyFunc], RemapRowKeyed
        push eax
        push ebx
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawArtMaskedAtOwnPos                           93240  95 PC, low confidence
; DrawArtMasked at the shape's own position
;-----------------------------------------------------------------------------
DrawArtMaskedAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArtMasked
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
        call DrawArtMasked
        add esp, byte 0Ch
        ret
