; Unpacking a picture and blitting it.
bits 32
%include "hockey.inc"
section s_9C594 progbits alloc exec nowrite align=1
extern str_Unpackf, str_Unpacking, byte_D506C, cliprect_x0, cliprect_x1, DebugPrintf, dword_D5064, dword_D5068
extern fputchar, FreeMemBlock, off_D516C, AllocMemBlock, SetPalette, sub_91FA4, sub_92CD0, sub_A2FD0
extern sub_A3050, _EFG_Format_, bcopy, UnpackArtRle
global sub_9C594, loc_9C5A4, ReturnFalse, sub_9C5B0, loc_9C611, loc_9C62B, loc_9C689, loc_9C6BE
global loc_9C70C, loc_9C71B, loc_9C72B, loc_9C748, loc_9C7AD, loc_9C7AF, loc_9C86F, loc_9C873
global loc_9C880, sub_9C890, sub_9C8D0, DrawArtAnyFormat, loc_9C924, loc_9C969, loc_9C97D, loc_9C97F
global loc_9C991, loc_9C9C1, loc_9C9D3, loc_9CA00, loc_9CA2B, loc_9CA3B, loc_9CA60, DrawArtAnyFormatAt
global DrawArtAnyFormatOwnPos, sub_9CAB4, sub_9CADC, sub_9CB00, sub_9CB24, sub_9CB4C, sub_9CB70, sub_9CB94
global sub_9CBBC, sub_9CBE0, sub_9CC04, sub_9CC2C, sub_9CC50, sub_9CC74, sub_9CC9C, sub_9CCC0
global sub_9CCE4, sub_9CD0C, sub_9CD30, sub_9CD54, sub_9CD7C, sub_9CDA0, sub_9CDC4, sub_9CDEC
global sub_9CE10, sub_9CE34, sub_9CE5C, sub_9CE80, sub_9CEA4, sub_9CECC, sub_9CEF0, sub_9CF14
global sub_9CF3C, sub_9CF60, sub_9CF84, sub_9CFAC, sub_9CFD0, sub_9CFF4, sub_9D01C, sub_9D040
global sub_9D064
sub_9C594:
        mov eax, dword [byte esp+04h]
        cmp eax, byte 61h
        jb short loc_9C5A4
        cmp eax, byte 7Ah
        ja short loc_9C5A4
        sub al, 20h
loc_9C5A4:
        ret
        db 00h,00h,00h
ReturnFalse:
        mov eax, 0
        ret
        db 00h,00h
sub_9C5B0:
        push esi
        push edi
        push ebp
        sub esp, 330h
        mov edx, dword [dword_D5068]
        test edx, edx
        je short loc_9C611
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
        jmp near loc_9C880
loc_9C611:
        cmp dword [dword_D5064], byte 0
        jne short loc_9C62B
        mov eax, esp
        push eax
        push dword 100h
        push edx
        call SetPalette
        add esp, byte 0Ch
loc_9C62B:
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
        jne short loc_9C689
        mov eax, esp
loc_9C689:
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
loc_9C6BE:
        cmp byte [dword edx+byte_D506C], 0
        je near loc_9C748
        mov bl, byte [dword esp+0318h]
        mov bh, byte [byte eax+01h]
        sub bl, bh
        cmp bl, 9
        jae near loc_9C748
        mov bl, byte [dword esp+030Ch]
        sub bl, byte [eax]
        cmp bl, 9
        jae short loc_9C748
        mov bl, byte [dword esp+0308h]
        sub bl, byte [byte eax+02h]
        cmp bl, 9
        jae short loc_9C748
        mov bl, byte [dword esp+0324h]
        sub bl, bh
        test bl, bl
        jge short loc_9C70C
        neg bl
loc_9C70C:
        mov bh, byte [dword esp+031Ch]
        sub bh, byte [eax]
        test bh, bh
        jge short loc_9C71B
        neg bh
loc_9C71B:
        mov cl, byte [dword esp+0320h]
        sub cl, byte [byte eax+02h]
        test cl, cl
        jge short loc_9C72B
        neg cl
loc_9C72B:
        movsx ebp, bh
        movsx ebx, bl
        add ebx, ebp
        movsx ecx, cl
        add ebx, ecx
        cmp ebx, esi
        jge short loc_9C748
        mov esi, ebx
        mov edi, edx
        test ebx, ebx
        je near loc_9C880
loc_9C748:
        add eax, byte 3
        inc edx
        cmp edx, 100h
        jl near loc_9C6BE
        cmp esi, byte 9
        jl near loc_9C880
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
        jne short loc_9C7AD
        mov eax, esp
loc_9C7AD:
        xor edx, edx
loc_9C7AF:
        mov cl, byte [eax]
        inc eax
        mov ch, byte [eax]
        inc eax
        mov bl, byte [eax]
        mov byte [dword esp+0314h], bl
        inc eax
        cmp byte [dword edx+byte_D506C], 0
        je near loc_9C873
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
        jge short loc_9C873
        test cl, cl
        jne short loc_9C86F
        test ch, ch
        jne short loc_9C86F
        cmp byte [dword esp+0314h], 0
        je short loc_9C873
loc_9C86F:
        mov ebp, esi
        mov edi, edx
loc_9C873:
        inc edx
        cmp edx, 100h
        jl near loc_9C7AF
loc_9C880:
        mov eax, edi
        add esp, 330h
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h
sub_9C890:
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
        call sub_92CD0
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 00h,00h
sub_9C8D0:
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
        jne short loc_9C924
        mov ebx, dword [byte esp+024h]
        cmp ebx, 10000h
        jne short loc_9C924
        cmp ebx, dword [byte esp+028h]
        jne short loc_9C924
        cmp dword [byte esp+020h], byte 0
        je short loc_9C97D
loc_9C924:
        push byte 20h
        mov eax, edi
        call sub_9C8D0
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
        je short loc_9C969
        push byte 0
        push edx
        push edi
        call UnpackArtRle
        add esp, byte 0Ch
        push str_Unpacking
        call DebugPrintf
        add esp, byte 4
        jmp short loc_9C97F
loc_9C969:
        mov eax, edi
        call sub_9C8D0
        push eax
        push edx
        push edi
        call bcopy
        add esp, byte 0Ch
        jmp short loc_9C97F
loc_9C97D:
        mov esi, edi
loc_9C97F:
        mov edi, dword [byte esp+04h]
        cmp edi, byte 1
        jb short loc_9C9D3
        jbe short loc_9C991
        cmp edi, byte 2
        je short loc_9C9C1
        jmp short loc_9C9D3
loc_9C991:
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        mov ecx, dword [byte esp+028h]
        push ecx
        call sub_91FA4
        add esp, byte 8
        sub dword [byte esp+08h], eax
        mov eax, dword [byte esi+08h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+02Ch]
        push eax
        call sub_91FA4
        add esp, byte 8
        sub ebp, eax
        jmp short loc_9C9D3
loc_9C9C1:
        mov eax, dword [byte esi+0Ah]
        sar eax, 10h
        add dword [byte esp+08h], eax
        mov eax, dword [byte esi+0Ch]
        sar eax, 10h
        add ebp, eax
loc_9C9D3:
        mov edx, dword [byte esp+024h]
        test edx, edx
        jge short loc_9CA00
        mov ebx, edx
        neg ebx
        mov dword [byte esp+024h], ebx
        mov eax, dword [byte esi+02h]
        sar eax, 10h
        push eax
        push ebx
        call sub_91FA4
        add esp, byte 8
        sub dword [byte esp+08h], eax
        push esi
        call sub_A2FD0
        add esp, byte 4
loc_9CA00:
        mov eax, dword [byte esp+028h]
        test eax, eax
        jge short loc_9CA2B
        mov edx, eax
        neg edx
        mov dword [byte esp+028h], edx
        mov eax, dword [byte esi+04h]
        sar eax, 10h
        push eax
        push edx
        call sub_91FA4
        add esp, byte 8
        sub ebp, eax
        push esi
        call sub_A3050
        add esp, byte 4
loc_9CA2B:
        cmp dword [byte esp+020h], byte 0
        je short loc_9CA3B
        push esi
        call _EFG_Format_
        add esp, byte 4
loc_9CA3B:
        mov eax, dword [byte esp+01Ch]
        push ebp
        mov edi, dword [byte esp+0Ch]
        push edi
        push esi
        call dword [nosplit eax*4+off_D516C]
        add esp, byte 0Ch
        mov ebp, dword [esp]
        test ebp, ebp
        je short loc_9CA60
        push ebp
        call FreeMemBlock
        add esp, byte 4
loc_9CA60:
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
sub_9CAB4:
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
sub_9CADC:
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
sub_9CB00:
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
sub_9CB24:
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
sub_9CB4C:
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
sub_9CB70:
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
sub_9CB94:
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
sub_9CBBC:
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
sub_9CBE0:
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
sub_9CC04:
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
sub_9CC2C:
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
sub_9CC50:
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
sub_9CC74:
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
sub_9CC9C:
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
sub_9CCC0:
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
sub_9CCE4:
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
sub_9CD0C:
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
sub_9CD30:
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
sub_9CD54:
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
sub_9CD7C:
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
sub_9CDA0:
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
sub_9CDC4:
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
sub_9CDEC:
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
sub_9CE10:
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
sub_9CE34:
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
sub_9CE5C:
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
sub_9CE80:
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
sub_9CEA4:
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
sub_9CECC:
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
sub_9CEF0:
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
sub_9CF14:
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
sub_9CF3C:
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
sub_9CF60:
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
sub_9CF84:
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
sub_9CFAC:
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
sub_9CFD0:
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
sub_9CFF4:
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
sub_9D01C:
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
sub_9D040:
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
sub_9D064:
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
