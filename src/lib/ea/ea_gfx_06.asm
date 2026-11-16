; Drawing. Blits, text, and filled boxes.
bits 32
%include "hockey.inc"
section s_91370 progbits alloc exec nowrite align=1
extern byte_D42C0, byte_D42C1, byte_D42C2, byte_D42C3, byte_D42C4, cliprect_y0, cliprect_y1, ScreenWidth
extern dword_D30A8, KeyedDraw, DrawVideoBase, ScreenRowTable, dword_D42B0, dword_D42B4, dword_D42BC, dword_D42C8
extern dword_D42CC, dword_D42D0, dword_D42D4, dword_D42D8, dword_D42DC, dword_D42E0, RowCopyFunc, fontcolor
extern DrawArtOpaqueHotspot, off_D42A4, TextSetCursor, PutBlock, bcopy, SetClipWindow, PutPixel, VesaSetBankArg
extern BlitArt, BlitShapeFast
global DrawArt, DrawShape, DrawArtHotspot, GrabBlock, DrawShapeAtOwnPos, GrabBlockHotspot, PrintStringAtCursor, PrintString
DrawArt:
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push eax
        push ebx
        push edx
        call BlitArt
        add esp, byte 0Ch
        ret
.1:
        mov dword [RowCopyFunc], DrawArtOpaqueHotspot+028h
        push eax
        push ebx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov dword [RowCopyFunc], bcopy
        ret
        db 08Dh,040h,00h
DrawShape:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call DrawArt
        add esp, byte 0Ch
        ret
DrawArtHotspot:
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
        call DrawArt
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
GrabBlock:
        push esi
        push edi
        push ebp
        sub esp, byte 18h
        mov eax, dword [byte esp+028h]
        mov edx, dword [byte esp+02Ch]
        mov esi, dword [byte esp+030h]
        cmp dword [KeyedDraw], byte 0
        jne short .1
        push esi
        push edx
        push eax
        call BlitShapeFast
        add esp, byte 0Ch
        jmp near .6
.1:
        mov word [byte eax+0Ch], dx
        mov word [byte eax+0Eh], si
        lea edi, [byte eax+010h]
        mov ebp, dword [byte eax+04h]
        sar ebp, 10h
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        mov dword [byte esp+0Ch], eax
        mov eax, dword [DrawVideoBase]
        mov dword [byte esp+04h], eax
        mov esi, dword [nosplit esi*4+ScreenRowTable]
        add esi, edx
        mov eax, dword [ScreenWidth]
        mov ecx, dword [byte esp+0Ch]
        sub eax, ecx
        mov dword [esp], eax
        mov eax, esi
        shr eax, 10h
        mov dword [byte esp+014h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
        and esi, 0FFFFh
        mov dword [byte esp+08h], ebp
        test ebp, ebp
        jle near .6
.2:
        mov eax, dword [byte esp+0Ch]
        add eax, esi
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+04h]
        add eax, esi
        test byte [byte esp+012h], 1
        je short .3
        mov ebp, 10000h
        sub ebp, esi
        push ebp
        push edi
        push eax
        call bcopy
        add esp, byte 0Ch
        add edi, ebp
        mov ebp, dword [byte esp+010h]
        and ebp, 0FFFFh
        mov eax, dword [byte esp+014h]
        inc eax
        mov dword [byte esp+014h], eax
        push eax
        call VesaSetBankArg
        add esp, byte 4
        push ebp
        push edi
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call bcopy
        add esp, byte 0Ch
        mov esi, ebp
        add edi, ebp
        jmp short .4
.3:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push edi
        push eax
        call bcopy
        add esp, byte 0Ch
        mov esi, dword [byte esp+010h]
        add edi, dword [byte esp+0Ch]
.4:
        add esi, dword [esp]
        test esi, 10000h
        je short .5
        and esi, 0FFFFh
        mov ebp, dword [byte esp+014h]
        inc ebp
        mov dword [byte esp+014h], ebp
        push ebp
        call VesaSetBankArg
        add esp, byte 4
.5:
        mov edx, dword [byte esp+08h]
        dec edx
        mov dword [byte esp+08h], edx
        test edx, edx
        jg near .2
.6:
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
DrawShapeAtOwnPos:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        call GrabBlock
        add esp, byte 0Ch
        ret
GrabBlockHotspot:
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
        call GrabBlock
        add esp, byte 0Ch
        ret
        db 00h,00h,00h,00h
PrintStringAtCursor:
        push esi
        push edi
        push ebp
        sub esp, byte 3Ch
        mov eax, dword [off_D42A4]
        mov dword [esp], eax
        xor eax, eax
        mov al, byte [byte_D42C1]
        movzx esi, byte [byte_D42C0]
        sub eax, esi
        inc eax
        mov dword [byte esp+02Ch], eax
        xor eax, eax
        mov esi, dword [esp]
        mov al, byte [byte esi+03h]
        sub eax, byte 30h
        mov dword [byte esp+08h], eax
        mov eax, dword [fontcolor]
        mov dword [byte esp+038h], eax
        cmp dword [dword_D42BC], 464E544Dh
        sete al
        and eax, 0FFh
        mov dword [byte esp+01Ch], eax
        mov eax, dword [dword_D42DC]
        mov dword [byte esp+028h], eax
        mov eax, dword [byte esp+04Ch]
        cmp byte [eax], 0
        je near .43
.1:
        mov eax, dword [byte esp+04Ch]
        lea ebx, [byte eax+01h]
        mov dword [byte esp+04Ch], ebx
        mov al, byte [eax]
        sub al, byte [byte_D42C0]
        movzx esi, al
        cmp esi, dword [byte esp+02Ch]
        jge near .42
        mov edi, dword [dword_D42C8]
        test edi, edi
        je short .2
        mov ah, byte [edi+esi]
        jmp short .3
.2:
        mov ah, byte [byte_D42C2]
.3:
        movzx esi, ah
        mov dword [byte esp+014h], esi
        mov ebp, dword [dword_D42CC]
        test ebp, ebp
        je short .4
        movzx esi, al
        mov edi, ebp
        mov ah, byte [edi+esi]
        jmp short .5
.4:
        mov ah, byte [byte_D42C3]
.5:
        movzx esi, ah
        mov edx, dword [dword_D42D0]
        test edx, edx
        je short .6
        movzx edi, al
        mov ebp, edx
        movzx edi, byte [edi+ebp]
        jmp short .7
.6:
        movzx edi, byte [byte_D42C4]
        add edi, dword [byte esp+014h]
.7:
        mov dword [byte esp+04h], edi
        mov ecx, dword [dword_D42D4]
        test ecx, ecx
        je short .8
        movzx edi, al
        mov ebp, ecx
        movzx edi, byte [edi+ebp]
        jmp short .9
.8:
        xor edi, edi
.9:
        mov ebp, dword [dword_D42B0]
        add ebp, edi
        mov dword [byte esp+030h], ebp
        cmp dword [dword_D42D8], byte 0
        je short .10
        movzx edi, al
        mov ebp, dword [dword_D42D8]
        movzx ebp, byte [edi+ebp]
        jmp short .11
.10:
        xor ebp, ebp
.11:
        add ebp, dword [dword_D42B4]
        and eax, 0FFh
        lea edi, [nosplit eax*4+00h]
        mov eax, dword [dword_D42E0]
        mov edi, dword [edi+eax]
        cmp dword [byte esp+01Ch], byte 0
        je short .12
        mov ecx, dword [byte esp+014h]
        test ecx, ecx
        jle near .41
        test esi, esi
        jle near .41
        add esi, ebp
        push esi
        push ebp
        mov eax, dword [byte esp+038h]
        add eax, ecx
        push eax
        mov eax, dword [byte esp+03Ch]
        push eax
        call SetClipWindow
        add esp, byte 10h
        push ebp
        mov eax, dword [byte esp+034h]
        sub eax, edi
        push eax
        mov edx, dword [byte esp+030h]
        push edx
        call DrawArt
        add esp, byte 0Ch
        mov ebx, dword [dword_D30A8]
        push ebx
        push byte 0
        mov ecx, dword [ScreenWidth]
        push ecx
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        jmp near .41
.12:
        test edi, edi
        je near .41
        add edi, dword [esp]
        mov dword [byte esp+034h], esi
        mov esi, dword [byte esp+08h]
        cmp esi, byte 4
        jb short .13
        jbe near .27
        cmp esi, byte 8
        je near .39
        jmp near .41
.13:
        cmp esi, byte 1
        jne near .41
        mov eax, dword [byte esp+014h]
        add eax, byte 7
        sar eax, 3
        mov dword [byte esp+010h], eax
.14:
        mov edx, dword [byte esp+034h]
        dec edx
        mov dword [byte esp+034h], edx
        cmp edx, byte 0FFFFFFFFh
        je near .41
        cmp ebp, dword [cliprect_y0]
        jl short .15
        cmp ebp, dword [cliprect_y1]
        jl short .16
.15:
        add edi, dword [byte esp+010h]
        jmp near .26
.16:
        mov esi, dword [byte esp+030h]
        mov eax, dword [byte esp+014h]
        mov dword [byte esp+018h], eax
        test eax, eax
        jle near .26
.17:
        test byte [edi], 80h
        je short .18
        mov eax, dword [byte esp+038h]
        push eax
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.18:
        inc esi
        test byte [edi], 40h
        je short .19
        mov edx, dword [byte esp+038h]
        push edx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.19:
        inc esi
        test byte [edi], 20h
        je short .20
        mov ebx, dword [byte esp+038h]
        push ebx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.20:
        inc esi
        test byte [edi], 10h
        je short .21
        mov ecx, dword [byte esp+038h]
        push ecx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.21:
        inc esi
        test byte [edi], 8
        je short .22
        mov eax, dword [byte esp+038h]
        push eax
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.22:
        inc esi
        test byte [edi], 4
        je short .23
        mov edx, dword [byte esp+038h]
        push edx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.23:
        inc esi
        test byte [edi], 2
        je short .24
        mov ebx, dword [byte esp+038h]
        push ebx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.24:
        inc esi
        test byte [edi], 1
        je short .25
        mov ecx, dword [byte esp+038h]
        push ecx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.25:
        inc esi
        mov ebx, dword [byte esp+018h]
        sub ebx, byte 8
        mov dword [byte esp+018h], ebx
        inc edi
        test ebx, ebx
        jg near .17
.26:
        inc ebp
        jmp near .14
.27:
        mov eax, dword [byte esp+014h]
        inc eax
        sar eax, 1
        mov dword [byte esp+0Ch], eax
.28:
        mov ebx, dword [byte esp+034h]
        dec ebx
        mov dword [byte esp+034h], ebx
        cmp ebx, byte 0FFFFFFFFh
        je near .41
        cmp ebp, dword [cliprect_y0]
        jl short .29
        cmp ebp, dword [cliprect_y1]
        jl short .30
.29:
        add edi, dword [byte esp+0Ch]
        jmp short .34
.30:
        mov esi, dword [byte esp+030h]
        mov eax, dword [byte esp+014h]
        mov dword [byte esp+020h], eax
        test eax, eax
        jle short .34
.31:
        xor eax, eax
        mov al, byte [edi]
        sar eax, 4
        test eax, eax
        je short .32
        push eax
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.32:
        inc esi
        mov cl, byte [edi]
        test cl, 0Fh
        je short .33
        mov al, cl
        and al, 0Fh
        and eax, 0FFh
        push eax
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.33:
        inc esi
        mov ecx, dword [byte esp+020h]
        sub ecx, byte 2
        mov dword [byte esp+020h], ecx
        inc edi
        test ecx, ecx
        jg short .31
.34:
        inc ebp
        jmp short .28
.35:
        mov eax, dword [byte esp+030h]
        mov dword [byte esp+024h], eax
        mov esi, dword [byte esp+014h]
.36:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je short .38
        mov bh, byte [edi]
        test bh, bh
        je short .37
        xor eax, eax
        mov al, bh
        push eax
        push ebp
        mov eax, dword [byte esp+02Ch]
        push eax
        call PutPixel
        add esp, byte 0Ch
.37:
        inc dword [byte esp+024h]
        inc edi
        jmp short .36
.38:
        inc ebp
.39:
        mov esi, dword [byte esp+034h]
        dec esi
        mov dword [byte esp+034h], esi
        cmp esi, byte 0FFFFFFFFh
        je short .41
        cmp ebp, dword [cliprect_y0]
        jl short .40
        cmp ebp, dword [cliprect_y1]
        jl short .35
.40:
        add edi, dword [byte esp+014h]
        jmp short .38
.41:
        mov eax, dword [byte esp+04h]
        add dword [dword_D42B0], eax
.42:
        mov eax, dword [byte esp+04Ch]
        cmp byte [eax], 0
        jne near .1
.43:
        add esp, byte 3Ch
        pop ebp
        pop edi
        pop esi
        ret
PrintString:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call TextSetCursor
        add esp, byte 8
        mov ecx, dword [byte esp+04h]
        push ecx
        call PrintStringAtCursor
        add esp, byte 4
        ret
