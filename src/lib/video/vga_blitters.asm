; The VGA blitters.
bits 32
%include "hockey.inc"
section s_B4CD8 progbits alloc exec nowrite align=1
extern byte_D42E4, cliprect_y0, cliprect_y1, dword_D30A4, dword_D30BC, dword_D30C0, dword_D30CC, dword_D30D0
extern sub_9A7A0, sub_9B498, sub_B40E2
global sub_B4CD8, sub_B4CF2, loc_B4D0C, loc_B4D1A, loc_B4D3C, loc_B4D49, loc_B4D53, loc_B4D5B
global loc_B4D7A, loc_B4D80, loc_B4D9E, loc_B4DA5, loc_B4DAD, SetColorRemap, sub_B4DEC, loc_B4E17
global loc_B4E23, sub_B4E50, loc_B4E84, loc_B4E92, loc_B4EB4, loc_B4EC1, loc_B4ED4, loc_B4EDC
global loc_B4EFB, loc_B4F01, loc_B4F1F, loc_B4F26, loc_B4F2A, loc_B4F3C, loc_B4F40, SetDrawBitmap
global CreateBitmap, sub_B4FA6, sub_B4FAC, loc_B4FE6, sub_B4FE8, sub_B500C, loc_B5040, loc_B5072
global loc_B5077, loc_B509C, loc_B50CA, loc_B50EC, loc_B50F2, loc_B5104, loc_B512F, loc_B513D
global loc_B514A, loc_B515D, loc_B5175, loc_B5178, loc_B5183, loc_B5189, loc_B5193, loc_B519B
global loc_B51BD, loc_B51C8, loc_B51CD, loc_B51D3, loc_B51D6, loc_B51E1, loc_B51FE, loc_B520E
global loc_B5215, loc_B5220, loc_B5242, loc_B524F, loc_B5254, loc_B5256, loc_B525A, loc_B5267
global loc_B5271, loc_B527F, loc_B5284, sub_B5290, sub_B52B4, loc_B52E8, loc_B531A, loc_B531F
global loc_B5344, loc_B5372, loc_B5394, loc_B539A, loc_B53AC, loc_B53D7, loc_B53E5, loc_B53F2
global loc_B5403, loc_B541B, loc_B541E, loc_B5429, loc_B542F, loc_B5442, loc_B544A, loc_B546C
global loc_B5477, loc_B547C, loc_B5482, loc_B5485, loc_B5490, loc_B54AD, loc_B54BD, loc_B54C4
global loc_B54C8, loc_B54DA, loc_B54DE, loc_B5507, loc_B5514, loc_B5519, loc_B551B, loc_B551F
global loc_B552C, loc_B5536, loc_B554D, loc_B5552, sub_B555C, sub_B5584, loc_B55B8, loc_B55C9
global loc_B55EC, loc_B55FC, loc_B5608, loc_B5610, loc_B562F, loc_B5635, loc_B5653, loc_B565A
global loc_B565E, loc_B5666, loc_B566A, sub_B5690, sub_B56B8, loc_B56EC, loc_B571D, loc_B5722
global loc_B5747, loc_B5778, loc_B5797, loc_B579D, loc_B57B2, loc_B57DE, loc_B57ED, loc_B57FC
global loc_B580E, loc_B5827, loc_B582A, loc_B5833, loc_B583A, loc_B5846, loc_B584E, loc_B5870
global loc_B587B, loc_B5880, loc_B5886, loc_B5889, loc_B5894, loc_B58B1, loc_B58B8, loc_B58BC
global loc_B58C7, loc_B58D7, loc_B58DB, loc_B58FD, loc_B590A, loc_B590F, loc_B5911, loc_B5915
global loc_B5924, loc_B592E, loc_B593C, loc_B5941, sub_B594C, sub_B5974, loc_B59A8, loc_B59B9
global loc_B59DC, loc_B59EC, loc_B5A01, loc_B5A09, loc_B5A28, loc_B5A2E, loc_B5A4C, loc_B5A53
global loc_B5A57, loc_B5A6B, loc_B5A6F, sub_B5AA0, sub_B5AC8, loc_B5AFC, loc_B5B2D, loc_B5B32
global loc_B5B57, loc_B5B88, loc_B5BA7, loc_B5BAD, loc_B5BC2, loc_B5BEE, loc_B5BFD, loc_B5C0A
global loc_B5C1C, loc_B5C35, loc_B5C38, loc_B5C45, loc_B5C4C, loc_B5C61, loc_B5C69, loc_B5C8B
global loc_B5C96, loc_B5C9B, loc_B5CA1, loc_B5CA4, loc_B5CAF, loc_B5CCC, loc_B5CD3, loc_B5CD7
global loc_B5CEB, loc_B5CFB, loc_B5CFF, loc_B5D2A, loc_B5D37, loc_B5D3C, loc_B5D3E, loc_B5D42
global loc_B5D51, loc_B5D5B, loc_B5D72, loc_B5D77
sub_B4CD8:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B4D0C
sub_B4CF2:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B4D0C:
        cld
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
loc_B4D1A:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [dword_D30CC]
        db 089h,05Dh,0E0h                       ; insn: mov [ebp-20h],ebx
        db 08Bh,03Bh                            ; insn: mov edi,[ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
loc_B4D3C:
        lodsb
        LD or, al, al
        jg short loc_B4D49
        jl short loc_B4D9E
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B4D49:
        LD xor, ah, ah
        movsx ecx, ax
        lodsb
        cmp al, 0FFh
        je short loc_B4D7A
loc_B4D53:
        LD sub, edx, ecx
        jle short loc_B4D5B
        rep stosb
        jmp short loc_B4D3C
loc_B4D5B:
        LD add, ecx, edx
        neg edx
        rep stosb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B4D53
loc_B4D7A:
        LD add, edi, ecx
        LD sub, edx, ecx
        jg short loc_B4D3C
loc_B4D80:
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-0Ch]
        jle short loc_B4D80
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        add edi, dword [byte ebp-0Ch]
        LD sub, edi, edx
        jmp short loc_B4D3C
loc_B4D9E:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
loc_B4DA5:
        LD sub, edx, ecx
        jle short loc_B4DAD
        rep movsb
        jmp short loc_B4D3C
loc_B4DAD:
        LD add, ecx, edx
        neg edx
        rep movsb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        LD or, ecx, ecx
        jg short loc_B4DA5
        jmp near loc_B4D3C
        db 00h
SetColorRemap:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edi, byte_D42E4
        mov esi, dword [byte ebp+08h]
        mov ecx, 40h
        rep movsd
        pop edi
        pop esi
        leave
        ret
sub_B4DEC:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov edi, dword [byte ebp+08h]
        mov esi, byte_D42E4
        mov ecx, 40h
        rep movsd
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+010h]
        mov edi, byte_D42E4
        add edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+0Ch]
loc_B4E17:
        test ecx, 3
        je short loc_B4E23
        movsb
        dec ecx
        jmp short loc_B4E17
loc_B4E23:
        shr ecx, 2
        rep movsd
        pop edi
        pop esi
        leave
        ret
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B4E84
sub_B4E50:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B4E84
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B4E84:
        cld
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
loc_B4E92:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [dword_D30CC]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
loc_B4EB4:
        lodsb
        LD or, al, al
        jg short loc_B4EC1
        jl short loc_B4F1F
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B4EC1:
        LD xor, ah, ah
        movsx ecx, ax
        lodsb
        cmp al, 0FFh
        je short loc_B4EFB
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
loc_B4ED4:
        LD sub, edx, ecx
        jle short loc_B4EDC
        rep stosb
        jmp short loc_B4EB4
loc_B4EDC:
        LD add, ecx, edx
        neg edx
        rep stosb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B4ED4
loc_B4EFB:
        LD add, edi, ecx
        LD sub, edx, ecx
        jg short loc_B4EB4
loc_B4F01:
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-0Ch]
        jle short loc_B4F01
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        add edi, dword [byte ebp-0Ch]
        LD sub, edi, edx
        jmp short loc_B4EB4
loc_B4F1F:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
loc_B4F26:
        LD sub, edx, ecx
        jle short loc_B4F3C
loc_B4F2A:
        lodsb
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        stosb
        loop loc_B4F2A
        jmp near loc_B4EB4
loc_B4F3C:
        LD add, ecx, edx
        neg edx
loc_B4F40:
        lodsb
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        stosb
        loop loc_B4F40
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        LD or, ecx, ecx
        jg short loc_B4F26
        jmp near loc_B4EB4
        db 00h,00h,00h
SetDrawBitmap:
        LD mov, edx, edi
        LD mov, eax, esi
        mov esi, dword [byte esp+04h]
        mov edi, dword_D30A4
        mov ecx, 0Ch
        rep movsd
        LD mov, edi, edx
        LD mov, esi, eax
        ret
        db 00h,00h,00h
CreateBitmap:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push edx
        push eax
        call sub_9A7A0
        add esp, byte 0Ch
        mov eax, dword [eax]
        ret
sub_B4FA6:
        jmp near sub_9A7A0
        db 00h
sub_B4FAC:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFC8h
        lea eax, [byte ebp-038h]
        push eax
        push dword [byte ebp+014h]
        push dword [byte ebp+010h]
        push dword [byte ebp+0Ch]
        push dword [byte ebp+08h]
        call sub_B40E2
        add esp, byte 14h
        LD or, eax, eax
        jne short loc_B4FE6
        lea ebx, [byte ebp-038h]
        cmp dword [byte ebx+018h], byte 0
        jle short loc_B4FE6
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebx+01Ch], eax
        push ebx
        call sub_9B498
        add esp, byte 4
loc_B4FE6:
        leave
        ret
sub_B4FE8:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B5040
sub_B500C:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B5040
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B5040:
        cld
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD xor, edi, edi
        LD xor, edx, edx
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B5077
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B509C
        inc edi
        LD sub, ecx, eax
        jg short loc_B509C
loc_B5072:
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5077:
        inc edi
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B5072
        xchg ecx, eax
        LD sub, eax, ecx
        mul dword [byte ebp-0Ch]
        LD mov, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B509C
        LD sub, ecx, eax
        jle short loc_B5072
loc_B509C:
        mov dword [byte ebp-010h], ecx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-014h], edx
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        mov ecx, dword [byte ebp-0Ch]
        cmp eax, dword [dword_D30BC]
        jl short loc_B50CA
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jle short loc_B50F2
        LD sub, ecx, eax
        jle short loc_B5072
        inc edi
        LD mov, edx, eax
        jmp short loc_B50F2
loc_B50CA:
        inc edi
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B5072
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-014h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        LD cmp, eax, esi
        jl short loc_B50EC
        LD mov, eax, esi
loc_B50EC:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B50F2:
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-04h], ebx
        LD or, edi, edi
        jne short loc_B5104
        jmp near loc_B4D1A
loc_B5104:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [dword_D30CC]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-014h]
        LD or, edx, edx
        je short loc_B5175
        jl short loc_B512F
        jmp near loc_B525A
loc_B512F:
        LD mov, ebx, edx
        and ebx, 7FFFh
        inc ebx
        mov edx, 7FFFh
loc_B513D:
        lodsb
        LD or, al, al
        jg short loc_B514A
        jl short loc_B515D
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B514A:
        LD xor, ah, ah
        LD mov, cx, ax
        inc esi
        LD sub, dx, cx
        jg short loc_B513D
        LD add, dx, bx
        jmp near loc_B5271
loc_B515D:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        LD add, esi, ecx
        LD sub, edx, ecx
        jg short loc_B513D
        LD add, edx, ecx
        LD sub, esi, ecx
        LD add, edx, ebx
        jmp near loc_B5242
loc_B5175:
        mov edx, dword [byte ebp-0Ch]
loc_B5178:
        lodsb
        LD or, al, al
        jg short loc_B5189
        jl near loc_B520E
loc_B5183:
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5189:
        LD xor, ah, ah
        movsx ecx, ax
        lodsb
        cmp al, 0FFh
        je short loc_B51CD
loc_B5193:
        LD sub, edx, ecx
        jle short loc_B519B
        rep stosb
        jmp short loc_B5178
loc_B519B:
        LD add, ecx, edx
        neg edx
        rep stosb
        dec dword [byte ebp-010h]
        je short loc_B5183
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
loc_B51BD:
        LD sub, ecx, edx
        je short loc_B5175
        jl short loc_B51C8
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B5193
loc_B51C8:
        jmp near loc_B5256
loc_B51CD:
        LD add, edi, ecx
        LD sub, edx, ecx
        jg short loc_B5178
loc_B51D3:
        dec dword [byte ebp-010h]
loc_B51D6:
        je short loc_B5183
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-018h]
        jg short loc_B51FE
loc_B51E1:
        add edx, dword [byte ebp-0Ch]
        jle short loc_B51D3
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        add edi, dword [byte ebp-0Ch]
        LD sub, edi, edx
        jmp near loc_B5178
loc_B51FE:
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        jmp short loc_B525A
loc_B520E:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
loc_B5215:
        LD sub, edx, ecx
        jle short loc_B5220
        rep movsb
        jmp near loc_B5178
loc_B5220:
        LD add, ecx, edx
        neg edx
        rep movsb
        dec dword [byte ebp-010h]
        je short loc_B51D6
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
loc_B5242:
        LD add, esi, edx
        LD sub, ecx, edx
        je short loc_B524F
        jl short loc_B5254
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B5215
loc_B524F:
        jmp near loc_B5175
loc_B5254:
        LD add, esi, ecx
loc_B5256:
        neg ecx
        LD mov, edx, ecx
loc_B525A:
        lodsb
        LD or, al, al
        jg short loc_B5267
        jl short loc_B5284
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5267:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short loc_B525A
loc_B5271:
        mov al, byte [byte esi-01h]
        cmp al, 0FFh
        je short loc_B527F
        LD add, edx, ecx
        jmp near loc_B51BD
loc_B527F:
        jmp near loc_B51E1
loc_B5284:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        jmp short loc_B5242
        db 00h,00h,00h
sub_B5290:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B52E8
sub_B52B4:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B52E8
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B52E8:
        cld
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD xor, edi, edi
        LD xor, edx, edx
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B531F
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B5344
        inc edi
        LD sub, ecx, eax
        jg short loc_B5344
loc_B531A:
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B531F:
        inc edi
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B531A
        xchg ecx, eax
        LD sub, eax, ecx
        mul dword [byte ebp-0Ch]
        LD mov, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B5344
        LD sub, ecx, eax
        jle short loc_B531A
loc_B5344:
        mov dword [byte ebp-010h], ecx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-014h], edx
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        mov ecx, dword [byte ebp-0Ch]
        cmp eax, dword [dword_D30BC]
        jl short loc_B5372
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jle short loc_B539A
        LD sub, ecx, eax
        jle short loc_B531A
        inc edi
        LD mov, edx, eax
        jmp short loc_B539A
loc_B5372:
        inc edi
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B531A
        LD mov, esi, ecx
        LD sub, esi, eax
        add dword [byte ebp-014h], esi
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        LD cmp, eax, esi
        jl short loc_B5394
        LD mov, eax, esi
loc_B5394:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B539A:
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-04h], ebx
        LD or, edi, edi
        jne short loc_B53AC
        jmp near loc_B4E92
loc_B53AC:
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [dword_D30CC]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-014h]
        LD or, edx, edx
        je short loc_B541B
        jl short loc_B53D7
        jmp near loc_B551F
loc_B53D7:
        LD mov, ebx, edx
        and ebx, 7FFFh
        inc ebx
        mov edx, 7FFFh
loc_B53E5:
        lodsb
        LD or, al, al
        jg short loc_B53F2
        jl short loc_B5403
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B53F2:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short loc_B53E5
        LD add, edx, ebx
        jmp near loc_B5536
loc_B5403:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        LD add, esi, ecx
        LD sub, edx, ecx
        jg short loc_B53E5
        LD add, edx, ecx
        LD sub, esi, ecx
        LD add, edx, ebx
        jmp near loc_B5507
loc_B541B:
        mov edx, dword [byte ebp-0Ch]
loc_B541E:
        lodsb
        LD or, al, al
        jg short loc_B542F
        jl near loc_B54BD
loc_B5429:
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B542F:
        LD xor, ah, ah
        movsx ecx, ax
        lodsb
        cmp al, 0FFh
        je short loc_B547C
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
loc_B5442:
        LD sub, edx, ecx
        jle short loc_B544A
        rep stosb
        jmp short loc_B541E
loc_B544A:
        LD add, ecx, edx
        neg edx
        rep stosb
        dec dword [byte ebp-010h]
        je short loc_B5429
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
loc_B546C:
        LD sub, ecx, edx
        je short loc_B541B
        jl short loc_B5477
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B5442
loc_B5477:
        jmp near loc_B551B
loc_B547C:
        LD add, edi, ecx
        LD sub, edx, ecx
        jg short loc_B541E
loc_B5482:
        dec dword [byte ebp-010h]
loc_B5485:
        je short loc_B5429
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-018h]
        jg short loc_B54AD
loc_B5490:
        add edx, dword [byte ebp-0Ch]
        jle short loc_B5482
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        add edi, dword [byte ebp-0Ch]
        LD sub, edi, edx
        jmp near loc_B541E
loc_B54AD:
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        jmp short loc_B551F
loc_B54BD:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
loc_B54C4:
        LD sub, edx, ecx
        jle short loc_B54DA
loc_B54C8:
        lodsb
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        stosb
        loop loc_B54C8
        jmp near loc_B541E
loc_B54DA:
        LD add, ecx, edx
        neg edx
loc_B54DE:
        lodsb
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        stosb
        loop loc_B54DE
        dec dword [byte ebp-010h]
        je short loc_B5485
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
loc_B5507:
        LD add, esi, edx
        LD sub, ecx, edx
        je short loc_B5514
        jl short loc_B5519
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B54C4
loc_B5514:
        jmp near loc_B541B
loc_B5519:
        LD add, esi, ecx
loc_B551B:
        neg ecx
        LD mov, edx, ecx
loc_B551F:
        lodsb
        LD or, al, al
        jg short loc_B552C
        jl short loc_B5552
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B552C:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short loc_B551F
loc_B5536:
        mov al, byte [byte esi-01h]
        cmp al, 0FFh
        je short loc_B554D
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        LD add, edx, ecx
        jmp near loc_B546C
loc_B554D:
        jmp near loc_B5490
loc_B5552:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        jmp short loc_B5507
        db 00h
sub_B555C:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+04h]
        add ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B55B8
sub_B5584:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B55B8
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B55B8:
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        dec eax
        add dword [byte ebp-04h], eax
loc_B55C9:
        std
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [dword_D30CC]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
loc_B55EC:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short loc_B55FC
        jl short loc_B5653
        cld
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B55FC:
        LD xor, ah, ah
        movsx ecx, ax
        mov al, byte [esi]
        inc esi
        cmp al, 0FFh
        je short loc_B562F
loc_B5608:
        LD sub, edx, ecx
        jle short loc_B5610
        rep stosb
        jmp short loc_B55EC
loc_B5610:
        LD add, ecx, edx
        neg edx
        rep stosb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B5608
loc_B562F:
        LD sub, edi, ecx
        LD sub, edx, ecx
        jg short loc_B55EC
loc_B5635:
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-0Ch]
        jle short loc_B5635
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        sub edi, dword [byte ebp-0Ch]
        LD add, edi, edx
        jmp short loc_B55EC
loc_B5653:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
loc_B565A:
        LD sub, edx, ecx
        jle short loc_B5666
loc_B565E:
        mov al, byte [esi]
        inc esi
        stosb
        loop loc_B565E
        jmp short loc_B55EC
loc_B5666:
        LD add, ecx, edx
        neg edx
loc_B566A:
        mov al, byte [esi]
        inc esi
        stosb
        loop loc_B566A
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        LD or, ecx, ecx
        jg short loc_B565A
        jmp near loc_B55EC
sub_B5690:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+04h]
        add ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B56EC
sub_B56B8:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B56EC
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B56EC:
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD xor, edi, edi
        LD xor, edx, edx
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B5722
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B5747
        inc edi
        LD sub, ecx, eax
        jg short loc_B5747
loc_B571D:
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5722:
        inc edi
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B571D
        xchg ecx, eax
        LD sub, eax, ecx
        mul dword [byte ebp-0Ch]
        LD mov, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B5747
        LD sub, ecx, eax
        jle short loc_B571D
loc_B5747:
        mov dword [byte ebp-010h], ecx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-014h], edx
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        mov ecx, dword [byte ebp-0Ch]
        cmp eax, dword [dword_D30BC]
        jl short loc_B5778
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jle short loc_B579D
        add dword [byte ebp-014h], eax
        LD sub, ecx, eax
        jle short loc_B571D
        inc edi
        LD mov, edx, eax
        jmp short loc_B579D
loc_B5778:
        inc edi
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B571D
        LD mov, esi, ecx
        LD sub, esi, eax
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        LD cmp, eax, esi
        jl short loc_B5797
        LD mov, eax, esi
loc_B5797:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B579D:
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-018h], edx
        LD add, ebx, ecx
        dec ebx
        mov dword [byte ebp-04h], ebx
        LD or, edi, edi
        jne short loc_B57B2
        jmp near loc_B55C9
loc_B57B2:
        std
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [dword_D30CC]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-014h]
        LD or, edx, edx
        je short loc_B5827
        jl short loc_B57DE
        jmp near loc_B5915
loc_B57DE:
        cld
        LD mov, ebx, edx
        and ebx, 7FFFh
        inc ebx
        mov edx, 7FFFh
loc_B57ED:
        lodsb
        LD or, al, al
        jg short loc_B57FC
        jl short loc_B580E
        movsx eax, ax
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B57FC:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short loc_B57ED
        LD add, edx, ebx
        std
        jmp near loc_B592E
loc_B580E:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        LD add, esi, ecx
        LD sub, edx, ecx
        jg short loc_B57ED
        LD add, edx, ecx
        LD sub, esi, ecx
        LD add, edx, ebx
        std
        jmp near loc_B58FD
loc_B5827:
        mov edx, dword [byte ebp-0Ch]
loc_B582A:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short loc_B583A
        jl short loc_B58B1
loc_B5833:
        cld
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B583A:
        LD xor, ah, ah
        movsx ecx, ax
        mov al, byte [esi]
        inc esi
        cmp al, 0FFh
        je short loc_B5880
loc_B5846:
        LD sub, edx, ecx
        jle short loc_B584E
        rep stosb
        jmp short loc_B582A
loc_B584E:
        LD add, ecx, edx
        neg edx
        rep stosb
        dec dword [byte ebp-010h]
        je short loc_B5833
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
loc_B5870:
        LD sub, ecx, edx
        je short loc_B5827
        jl short loc_B587B
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B5846
loc_B587B:
        jmp near loc_B5911
loc_B5880:
        LD sub, edi, ecx
        LD sub, edx, ecx
        jg short loc_B582A
loc_B5886:
        dec dword [byte ebp-010h]
loc_B5889:
        je short loc_B5833
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-018h]
        jg short loc_B58C7
loc_B5894:
        add edx, dword [byte ebp-0Ch]
        jle short loc_B5886
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        sub edi, dword [byte ebp-0Ch]
        LD add, edi, edx
        jmp near loc_B582A
loc_B58B1:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
loc_B58B8:
        LD sub, edx, ecx
        jle short loc_B58D7
loc_B58BC:
        mov al, byte [esi]
        inc esi
        stosb
        loop loc_B58BC
        jmp near loc_B582A
loc_B58C7:
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        jmp short loc_B5915
loc_B58D7:
        LD add, ecx, edx
        neg edx
loc_B58DB:
        mov al, byte [esi]
        inc esi
        stosb
        loop loc_B58DB
        dec dword [byte ebp-010h]
        je short loc_B5889
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
loc_B58FD:
        LD add, esi, edx
        LD sub, ecx, edx
        je short loc_B590A
        jl short loc_B590F
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B58B8
loc_B590A:
        jmp near loc_B5827
loc_B590F:
        LD add, esi, ecx
loc_B5911:
        neg ecx
        LD mov, edx, ecx
loc_B5915:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short loc_B5924
        jl short loc_B5941
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5924:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short loc_B5915
loc_B592E:
        mov al, byte [byte esi-01h]
        cmp al, 0FFh
        je short loc_B593C
        LD add, edx, ecx
        jmp near loc_B5870
loc_B593C:
        jmp near loc_B5894
loc_B5941:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        jmp short loc_B58FD
        db 00h,00h
sub_B594C:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+04h]
        add ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B59A8
sub_B5974:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B59A8
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B59A8:
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        dec eax
        add dword [byte ebp-04h], eax
loc_B59B9:
        std
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [dword_D30CC]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-0Ch]
        LD xor, eax, eax
loc_B59DC:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short loc_B59EC
        jl short loc_B5A4C
        cld
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B59EC:
        LD xor, ah, ah
        movsx ecx, ax
        mov al, byte [esi]
        inc esi
        cmp al, 0FFh
        je short loc_B5A28
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
loc_B5A01:
        LD sub, edx, ecx
        jle short loc_B5A09
        rep stosb
        jmp short loc_B59DC
loc_B5A09:
        LD add, ecx, edx
        neg edx
        rep stosb
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B5A01
loc_B5A28:
        LD sub, edi, ecx
        LD sub, edx, ecx
        jg short loc_B59DC
loc_B5A2E:
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-0Ch]
        jle short loc_B5A2E
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        sub edi, dword [byte ebp-0Ch]
        LD add, edi, edx
        jmp short loc_B59DC
loc_B5A4C:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
loc_B5A53:
        LD sub, edx, ecx
        jle short loc_B5A6B
loc_B5A57:
        mov al, byte [esi]
        inc esi
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        stosb
        loop loc_B5A57
        jmp near loc_B59DC
loc_B5A6B:
        LD add, ecx, edx
        neg edx
loc_B5A6F:
        mov al, byte [esi]
        inc esi
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        stosb
        loop loc_B5A6F
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-0Ch]
        LD or, ecx, ecx
        jg short loc_B5A53
        jmp near loc_B59DC
        db 00h,00h
sub_B5AA0:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+04h]
        add ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short loc_B5AFC
sub_B5AC8:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte ebp-08h], eax
        jmp short loc_B5AFC
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        movsx eax, word [byte esi+0Ch]
        mov dword [byte ebp-04h], eax
        movsx eax, word [byte esi+0Eh]
        mov dword [byte ebp-08h], eax
loc_B5AFC:
        lea eax, [byte esi+010h]
        mov dword [byte ebp-01Ch], eax
        movsx eax, word [byte esi+04h]
        mov dword [byte ebp-0Ch], eax
        LD xor, edi, edi
        LD xor, edx, edx
        mov ebx, dword [byte ebp-08h]
        movsx ecx, word [byte esi+06h]
        LD mov, eax, ebx
        cmp eax, dword [cliprect_y0]
        jl short loc_B5B32
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B5B57
        inc edi
        LD sub, ecx, eax
        jg short loc_B5B57
loc_B5B2D:
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5B32:
        inc edi
        mov ebx, dword [cliprect_y0]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B5B2D
        xchg ecx, eax
        LD sub, eax, ecx
        mul dword [byte ebp-0Ch]
        LD mov, edx, eax
        LD mov, eax, ebx
        LD add, eax, ecx
        sub eax, dword [cliprect_y1]
        jle short loc_B5B57
        LD sub, ecx, eax
        jle short loc_B5B2D
loc_B5B57:
        mov dword [byte ebp-010h], ecx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-014h], edx
        LD xor, edx, edx
        mov ebx, dword [byte ebp-04h]
        LD mov, eax, ebx
        mov ecx, dword [byte ebp-0Ch]
        cmp eax, dword [dword_D30BC]
        jl short loc_B5B88
        LD add, eax, ecx
        sub eax, dword [dword_D30C0]
        jle short loc_B5BAD
        add dword [byte ebp-014h], eax
        LD sub, ecx, eax
        jle short loc_B5B2D
        inc edi
        LD mov, edx, eax
        jmp short loc_B5BAD
loc_B5B88:
        inc edi
        mov ebx, dword [dword_D30BC]
        LD add, eax, ecx
        LD sub, eax, ebx
        jle short loc_B5B2D
        LD mov, esi, ecx
        LD sub, esi, eax
        mov esi, dword [dword_D30C0]
        LD sub, esi, ebx
        LD cmp, eax, esi
        jl short loc_B5BA7
        LD mov, eax, esi
loc_B5BA7:
        db 087h,0CAh                            ; insn: xchg ecx,edx
        LD sub, edx, eax
        LD add, ecx, eax
loc_B5BAD:
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-018h], edx
        LD add, ebx, ecx
        dec ebx
        mov dword [byte ebp-04h], ebx
        LD or, edi, edi
        jne short loc_B5BC2
        jmp near loc_B59B9
loc_B5BC2:
        std
        mov ebx, dword [byte ebp-08h]
        shl ebx, 2
        add ebx, dword [dword_D30CC]
        mov dword [byte ebp-020h], ebx
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        mov esi, dword [byte ebp-01Ch]
        mov edx, dword [byte ebp-014h]
        LD or, edx, edx
        je short loc_B5C35
        jl short loc_B5BEE
        jmp near loc_B5D42
loc_B5BEE:
        cld
        LD mov, ebx, edx
        and ebx, 7FFFh
        inc ebx
        mov edx, 7FFFh
loc_B5BFD:
        lodsb
        LD or, al, al
        jg short loc_B5C0A
        jl short loc_B5C1C
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5C0A:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short loc_B5BFD
        LD add, edx, ebx
        std
        jmp near loc_B5D5B
loc_B5C1C:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        LD add, esi, ecx
        LD sub, edx, ecx
        jg short loc_B5BFD
        LD add, edx, ecx
        LD sub, esi, ecx
        LD add, edx, ebx
        std
        jmp near loc_B5D2A
loc_B5C35:
        mov edx, dword [byte ebp-0Ch]
loc_B5C38:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short loc_B5C4C
        jl near loc_B5CCC
loc_B5C45:
        cld
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5C4C:
        LD xor, ah, ah
        movsx ecx, ax
        mov al, byte [esi]
        inc esi
        cmp al, 0FFh
        je short loc_B5C9B
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
loc_B5C61:
        LD sub, edx, ecx
        jle short loc_B5C69
        rep stosb
        jmp short loc_B5C38
loc_B5C69:
        LD add, ecx, edx
        neg edx
        rep stosb
        dec dword [byte ebp-010h]
        je short loc_B5C45
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
loc_B5C8B:
        LD sub, ecx, edx
        je short loc_B5C35
        jl short loc_B5C96
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B5C61
loc_B5C96:
        jmp near loc_B5D3E
loc_B5C9B:
        LD sub, edi, ecx
        LD sub, edx, ecx
        jg short loc_B5C38
loc_B5CA1:
        dec dword [byte ebp-010h]
loc_B5CA4:
        je short loc_B5C45
        add dword [byte ebp-020h], byte 4
        add edx, dword [byte ebp-018h]
        jg short loc_B5CEB
loc_B5CAF:
        add edx, dword [byte ebp-0Ch]
        jle short loc_B5CA1
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        sub edi, dword [byte ebp-0Ch]
        LD add, edi, edx
        jmp near loc_B5C38
loc_B5CCC:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
loc_B5CD3:
        LD sub, edx, ecx
        jle short loc_B5CFB
loc_B5CD7:
        mov al, byte [esi]
        inc esi
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        stosb
        loop loc_B5CD7
        jmp near loc_B5C38
loc_B5CEB:
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        jmp short loc_B5D42
loc_B5CFB:
        LD add, ecx, edx
        neg edx
loc_B5CFF:
        mov al, byte [esi]
        inc esi
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        stosb
        loop loc_B5CFF
        dec dword [byte ebp-010h]
        je short loc_B5CA4
        add dword [byte ebp-020h], byte 4
        mov ebx, dword [byte ebp-020h]
        mov edi, dword [ebx]
        add edi, dword [byte ebp-04h]
        add edi, dword [dword_D30D0]
        LD mov, ecx, edx
        mov edx, dword [byte ebp-018h]
loc_B5D2A:
        LD add, esi, edx
        LD sub, ecx, edx
        je short loc_B5D37
        jl short loc_B5D3C
        mov edx, dword [byte ebp-0Ch]
        jmp short loc_B5CD3
loc_B5D37:
        jmp near loc_B5C35
loc_B5D3C:
        LD add, esi, ecx
loc_B5D3E:
        neg ecx
        LD mov, edx, ecx
loc_B5D42:
        mov al, byte [esi]
        inc esi
        LD or, al, al
        jg short loc_B5D51
        jl short loc_B5D77
        cwde
        pop edi
        pop esi
        pop ds
        leave
        ret
loc_B5D51:
        LD xor, ah, ah
        movsx ecx, ax
        inc esi
        LD sub, edx, ecx
        jg short loc_B5D42
loc_B5D5B:
        mov al, byte [byte esi-01h]
        cmp al, 0FFh
        je short loc_B5D72
        movsx ebx, ax
        mov al, byte [dword ebx+byte_D42E4]
        LD add, edx, ecx
        jmp near loc_B5C8B
loc_B5D72:
        jmp near loc_B5CAF
loc_B5D77:
        neg al
        LD xor, ah, ah
        movsx ecx, ax
        jmp short loc_B5D2A
