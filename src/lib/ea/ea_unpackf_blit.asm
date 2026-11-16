; Unpacking a picture and blitting it.
bits 32
%include "hockey.inc"
section s_9C594 progbits alloc exec nowrite align=1
extern str_Unpackf, str_Unpacking, byte_D506C, cliprect_x0, cliprect_x1, DebugPrintf, dword_D5064, dword_D5068
extern fputchar, FreeMemBlock, off_D516C, AllocMemBlock, SetPalette, FixedMulRound, TextPrintAt, FlipArtHorizontal
extern FlipArtVertical, RemapArt, bcopy, UnpackArtRle
global ToUpperChar, ReturnFalse, FindNearestColor, TextPrintCentered, ShapePixelSize, DrawArtAnyFormat, DrawArtAnyFormatAt, DrawArtAnyFormatOwnPos
ToUpperChar:
        mov eax, dword [byte esp+04h]
        cmp eax, byte 61h
        jb short .1
        cmp eax, byte 7Ah
        ja short .1
        sub al, 20h
.1:
        ret
        db 00h,00h,00h
ReturnFalse:
        mov eax, 0
        ret
        db 00h,00h
FindNearestColor:
        push esi
        push edi
        push ebp
        sub esp, 330h
        mov edx, dword [dword_D5068]
        test edx, edx
        je short .1
        mov ecx, dword [dword esp+0340h]
        shr ecx, 10h
        and ecx, 0FFh
        shr ecx, 4
        mov edx, dword [dword esp+0340h]
        shr edx, 8
        and edx, 0FFh
        shr edx, 4
        mov eax, dword [dword esp+0340h]
        and eax, 0FFh
        shr eax, 4
        shl ecx, 8
        shl edx, 4
        or edx, ecx
        or eax, edx
        mov edx, dword [dword_D5068]
        movzx edi, byte [edx+eax]
        jmp near .13
.1:
        cmp dword [dword_D5064], byte 0
        jne short .2
        mov eax, esp
        push eax
        push dword 100h
        push edx
        call SetPalette
        add esp, byte 0Ch
.2:
        mov eax, dword [dword esp+0340h]
        shr eax, 12h
        and eax, byte 3Fh
        movsx eax, al
        add eax, byte 4
        mov byte [dword esp+030Ch], al
        mov eax, dword [dword esp+0340h]
        shr eax, 0Ah
        and eax, byte 3Fh
        movsx eax, al
        add eax, byte 4
        mov byte [dword esp+0318h], al
        mov eax, dword [dword esp+0340h]
        shr eax, 2
        and eax, byte 3Fh
        movsx eax, al
        add eax, byte 4
        mov byte [dword esp+0308h], al
        mov esi, 9
        mov eax, dword [dword_D5064]
        test eax, eax
        jne short .3
        mov eax, esp
.3:
        xor edx, edx
        mov bl, byte [dword esp+0308h]
        sub bl, 4
        mov byte [dword esp+0320h], bl
        mov bl, byte [dword esp+030Ch]
        sub bl, 4
        mov byte [dword esp+031Ch], bl
        mov bl, byte [dword esp+0318h]
        sub bl, 4
        mov byte [dword esp+0324h], bl
.4:
        cmp byte [dword edx+byte_D506C], 0
        je near .8
        mov bl, byte [dword esp+0318h]
        mov bh, byte [byte eax+01h]
        sub bl, bh
        cmp bl, 9
        jae near .8
        mov bl, byte [dword esp+030Ch]
        sub bl, byte [eax]
        cmp bl, 9
        jae short .8
        mov bl, byte [dword esp+0308h]
        sub bl, byte [byte eax+02h]
        cmp bl, 9
        jae short .8
        mov bl, byte [dword esp+0324h]
        sub bl, bh
        test bl, bl
        jge short .5
        neg bl
.5:
        mov bh, byte [dword esp+031Ch]
        sub bh, byte [eax]
        test bh, bh
        jge short .6
        neg bh
.6:
        mov cl, byte [dword esp+0320h]
        sub cl, byte [byte eax+02h]
        test cl, cl
        jge short .7
        neg cl
.7:
        movsx ebp, bh
        movsx ebx, bl
        add ebx, ebp
        movsx ecx, cl
        add ebx, ecx
        cmp ebx, esi
        jge short .8
        mov esi, ebx
        mov edi, edx
        test ebx, ebx
        je near .13
.8:
        add eax, byte 3
        inc edx
        cmp edx, 100h
        jl near .4
        cmp esi, byte 9
        jl near .13
        mov eax, dword [dword esp+0340h]
        shr eax, 12h
        and eax, byte 3Fh
        mov byte [dword esp+032Ch], al
        mov eax, dword [dword esp+0340h]
        shr eax, 0Ah
        and eax, byte 3Fh
        mov byte [dword esp+0328h], al
        mov eax, dword [dword esp+0340h]
        shr eax, 2
        and eax, byte 3Fh
        mov byte [dword esp+0310h], al
        mov ebp, 270Fh
        mov eax, dword [dword_D5064]
        test eax, eax
        jne short .9
        mov eax, esp
.9:
        xor edx, edx
.10:
        mov cl, byte [eax]
        inc eax
        mov ch, byte [eax]
        inc eax
        mov bl, byte [eax]
        mov byte [dword esp+0314h], bl
        inc eax
        cmp byte [dword edx+byte_D506C], 0
        je near .12
        mov ebx, dword [dword esp+0325h]
        sar ebx, 18h
        mov dword [dword esp+0300h], ebx
        movsx ebx, ch
        mov esi, dword [dword esp+0300h]
        sub esi, ebx
        mov ebx, esi
        imul ebx, esi
        mov dword [dword esp+0304h], ebx
        mov ebx, dword [dword esp+0329h]
        sar ebx, 18h
        mov dword [dword esp+0300h], ebx
        movsx ebx, cl
        mov esi, dword [dword esp+0300h]
        sub esi, ebx
        mov ebx, esi
        imul ebx, esi
        mov esi, dword [dword esp+0304h]
        add esi, ebx
        mov dword [dword esp+0304h], esi
        mov ebx, dword [dword esp+030Dh]
        sar ebx, 18h
        mov dword [dword esp+0300h], ebx
        mov ebx, dword [dword esp+0311h]
        sar ebx, 18h
        mov esi, dword [dword esp+0300h]
        sub esi, ebx
        mov ebx, esi
        imul ebx, esi
        mov esi, dword [dword esp+0304h]
        add esi, ebx
        cmp esi, ebp
        jge short .12
        test cl, cl
        jne short .11
        test ch, ch
        jne short .11
        cmp byte [dword esp+0314h], 0
        je short .12
.11:
        mov ebp, esi
        mov edi, edx
.12:
        inc edx
        cmp edx, 100h
        jl near .10
.13:
        mov eax, edi
        add esp, 330h
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h
TextPrintCentered:
        push esi
        push edi
        mov esi, dword [cliprect_x1]
        sub esi, dword [cliprect_x0]
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call fputchar
        add esp, byte 4
        sub esi, eax
        mov eax, esi
        sar eax, 1
        add eax, dword [cliprect_x0]
        mov esi, dword [byte esp+010h]
        push esi
        inc eax
        push eax
        mov edi, dword [byte esp+014h]
        push edi
        call TextPrintAt
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 00h,00h
ShapePixelSize:
        push edx
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        imul eax, edx
        add eax, byte 10h
        pop edx
        ret
        db 08Dh,040h,00h
DrawArtAnyFormat:
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov edi, eax
        mov dword [byte esp+08h], edx
        mov ebp, ebx
        mov dword [byte esp+04h], ecx
        xor edx, edx
        mov dword [esp], edx
        mov eax, dword [eax]
        shl eax, 18h
        sar eax, 18h
        test al, 80h
        jne short .1
        mov ebx, dword [byte esp+024h]
        cmp ebx, 10000h
        jne short .1
        cmp ebx, dword [byte esp+028h]
        jne short .1
        cmp dword [byte esp+020h], byte 0
        je short .3
.1:
        push byte 20h
        mov eax, edi
        call ShapePixelSize
        push eax
        push str_Unpackf
        call AllocMemBlock
        mov edx, eax
        add esp, byte 0Ch
        mov dword [esp], eax
        mov esi, eax
        mov eax, dword [edi]
        shl eax, 18h
        sar eax, 18h
        test al, 80h
        je short .2
        push byte 0
        push edx
        push edi
        call UnpackArtRle
        add esp, byte 0Ch
        push str_Unpacking
        call DebugPrintf
        add esp, byte 4
        jmp short .4
.2:
        mov eax, edi
        call ShapePixelSize
        push eax
        push edx
        push edi
        call bcopy
        add esp, byte 0Ch
        jmp short .4
.3:
        mov esi, edi
.4:
        mov edi, dword [byte esp+04h]
        cmp edi, byte 1
        jb short .7
        jbe short .5
        cmp edi, byte 2
        je short .6
        jmp short .7
.5:
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        mov ecx, dword [byte esp+028h]
        push ecx
        call FixedMulRound
        add esp, byte 8
        sub dword [byte esp+08h], eax
        mov eax, dword [byte esi+08h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+02Ch]
        push eax
        call FixedMulRound
        add esp, byte 8
        sub ebp, eax
        jmp short .7
.6:
        mov eax, dword [byte esi+0Ah]
        sar eax, 10h
        add dword [byte esp+08h], eax
        mov eax, dword [byte esi+0Ch]
        sar eax, 10h
        add ebp, eax
.7:
        mov edx, dword [byte esp+024h]
        test edx, edx
        jge short .8
        mov ebx, edx
        neg ebx
        mov dword [byte esp+024h], ebx
        mov eax, dword [byte esi+02h]
        sar eax, 10h
        push eax
        push ebx
        call FixedMulRound
        add esp, byte 8
        sub dword [byte esp+08h], eax
        push esi
        call FlipArtHorizontal
        add esp, byte 4
.8:
        mov eax, dword [byte esp+028h]
        test eax, eax
        jge short .9
        mov edx, eax
        neg edx
        mov dword [byte esp+028h], edx
        mov eax, dword [byte esi+04h]
        sar eax, 10h
        push eax
        push edx
        call FixedMulRound
        add esp, byte 8
        sub ebp, eax
        push esi
        call FlipArtVertical
        add esp, byte 4
.9:
        cmp dword [byte esp+020h], byte 0
        je short .10
        push esi
        call RemapArt
        add esp, byte 4
.10:
        mov eax, dword [byte esp+01Ch]
        push ebp
        mov edi, dword [byte esp+0Ch]
        push edi
        push esi
        call dword [nosplit eax*4+off_D516C]
        add esp, byte 0Ch
        mov ebp, dword [esp]
        test ebp, ebp
        je short .11
        push ebp
        call FreeMemBlock
        add esp, byte 4
.11:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret 10h
        db 08Dh,040h,00h
DrawArtAnyFormatAt:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
DrawArtAnyFormatOwnPos:
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 1
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 2
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 2
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 2
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 2
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 2
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 0
        push byte 2
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 1
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 1
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 1
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 1
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 1
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 1
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 2
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 2
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 2
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 2
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 2
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 0FFFF0000h
        push byte 0
        push byte 2
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 1
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 1
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 1
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 1
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 1
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 1
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 2
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 2
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 2
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 2
        xor ecx, ecx
        call DrawArtAnyFormat
        ret
        db 08Bh,0C0h
        mov eax, dword [byte esp+04h]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 2
        mov ecx, 2
        xor ebx, ebx
        xor edx, edx
        call DrawArtAnyFormat
        ret
        db 08Dh,040h,00h
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push dword 10000h
        push dword 10000h
        push byte 1
        push byte 2
        mov ecx, 1
        call DrawArtAnyFormat
        ret
        db 00h,00h,00h,00h,00h,00h,00h
