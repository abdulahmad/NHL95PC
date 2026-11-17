; EA graphics: text printing at a position.
bits 32
%include "hockey.inc"
section s_92890 progbits alloc exec nowrite align=1
extern cliprect_y0, cliprect_y1, FillRectClipped, fontcolor, PutBlock, PutPixel, ScreenHeight, ScreenWidth
extern SetClipWindow, TextBackColor, TextBottom, TextCharH, TextCharW, TextCursorX, TextCursorY, TextFirstChar
extern TextFont, TextFontTag, TextLastChar, TextLeft, TextOriginX, TextOriginY, TextRight, TextSetCursor
extern TextSpacing, TextTop, TextWidthTable
global TextPrint, TextPrintAt, TextPutCharAt
;-----------------------------------------------------------------------------
; TextPrint                                    92890  95 PC, medium confidence
; Prints a string at the text cursor with the current font
;-----------------------------------------------------------------------------
TextPrint:
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov eax, dword [TextFont]
        mov dword [byte esp+02Ch], eax
        xor eax, eax
        mov al, byte [TextLastChar]
        movzx esi, byte [TextFirstChar]
        sub eax, esi
        inc eax
        mov dword [byte esp+014h], eax
        xor eax, eax
        mov esi, dword [byte esp+02Ch]
        mov al, byte [byte esi+03h]
        sub eax, byte 30h
        mov dword [byte esp+010h], eax
        mov eax, dword [fontcolor]
        mov dword [byte esp+03Ch], eax
        mov eax, dword [TextBackColor]
        mov dword [byte esp+0Ch], eax
        cmp dword [TextFontTag], 464E544Dh
        sete al
        and eax, 0FFh
        mov dword [byte esp+04h], eax
        mov eax, dword [TextRight]
        mov dword [esp], eax
        mov eax, dword [byte esp+050h]
        cmp byte [eax], 0
        je near .44
.1:
        mov eax, dword [byte esp+050h]
        lea ebx, [byte eax+01h]
        mov dword [byte esp+050h], ebx
        mov al, byte [eax]
        sub al, byte [TextFirstChar]
        movzx esi, al
        cmp esi, dword [byte esp+014h]
        jge near .43
        mov edi, dword [TextWidthTable]
        test edi, edi
        je short .2
        mov ah, byte [edi+esi]
        jmp short .3
.2:
        mov ah, byte [TextCharW]
.3:
        movzx esi, ah
        mov dword [byte esp+038h], esi
        mov ebp, dword [TextCursorX]
        test ebp, ebp
        je short .4
        movzx esi, al
        mov edi, ebp
        mov ah, byte [edi+esi]
        jmp short .5
.4:
        mov ah, byte [TextCharH]
.5:
        movzx esi, ah
        mov edx, dword [TextCursorY]
        test edx, edx
        je short .6
        movzx edi, al
        mov ebp, edx
        movzx edi, byte [edi+ebp]
        jmp short .7
.6:
        movzx edi, byte [TextSpacing]
        add edi, dword [byte esp+038h]
.7:
        mov dword [byte esp+08h], edi
        mov ecx, dword [TextLeft]
        test ecx, ecx
        je short .8
        movzx edi, al
        mov ebp, ecx
        movzx edi, byte [edi+ebp]
        jmp short .9
.8:
        xor edi, edi
.9:
        mov ebp, dword [TextOriginX]
        add ebp, edi
        mov dword [byte esp+01Ch], ebp
        cmp dword [TextTop], byte 0
        je short .10
        movzx edi, al
        mov ebp, dword [TextTop]
        movzx ebp, byte [edi+ebp]
        jmp short .11
.10:
        xor ebp, ebp
.11:
        add ebp, dword [TextOriginY]
        and eax, 0FFh
        lea edi, [nosplit eax*4+00h]
        mov eax, dword [TextBottom]
        mov edi, dword [edi+eax]
        cmp dword [byte esp+04h], byte 0
        je short .12
        cmp dword [byte esp+038h], byte 0
        jle near .42
        test esi, esi
        jle near .42
        add esi, ebp
        push esi
        push ebp
        mov eax, dword [byte esp+024h]
        add eax, dword [byte esp+040h]
        push eax
        mov ebx, dword [byte esp+028h]
        push ebx
        call SetClipWindow
        add esp, byte 10h
        push ebp
        mov eax, dword [byte esp+020h]
        sub eax, edi
        push eax
        mov ecx, dword [byte esp+08h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [ScreenHeight]
        push esi
        push byte 0
        mov edi, dword [ScreenWidth]
        push edi
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        jmp near .42
.12:
        test edi, edi
        je near .42
        add edi, dword [byte esp+02Ch]
        mov dword [byte esp+020h], esi
        mov eax, dword [byte esp+010h]
        cmp eax, byte 4
        jb short .13
        jbe near .27
        cmp eax, byte 8
        je near .35
        jmp near .42
.13:
        cmp eax, byte 1
        jne near .42
        mov edx, dword [byte esp+0Ch]
        push edx
        push esi
        mov ebx, dword [byte esp+040h]
        push ebx
        push ebp
        mov ecx, dword [byte esp+02Ch]
        push ecx
        call FillRectClipped
        add esp, byte 14h
        mov eax, dword [byte esp+038h]
        add eax, byte 7
        sar eax, 3
        mov dword [byte esp+018h], eax
.14:
        mov edx, dword [byte esp+020h]
        dec edx
        mov dword [byte esp+020h], edx
        cmp edx, byte 0FFFFFFFFh
        je near .42
        cmp ebp, dword [cliprect_y0]
        jl short .15
        cmp ebp, dword [cliprect_y1]
        jl short .16
.15:
        add edi, dword [byte esp+018h]
        jmp near .26
.16:
        mov esi, dword [byte esp+01Ch]
        mov eax, dword [byte esp+038h]
        mov dword [byte esp+030h], eax
        test eax, eax
        jle near .26
.17:
        test byte [edi], 80h
        je short .18
        mov eax, dword [byte esp+03Ch]
        push eax
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.18:
        inc esi
        test byte [edi], 40h
        je short .19
        mov edx, dword [byte esp+03Ch]
        push edx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.19:
        inc esi
        test byte [edi], 20h
        je short .20
        mov ebx, dword [byte esp+03Ch]
        push ebx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.20:
        inc esi
        test byte [edi], 10h
        je short .21
        mov ecx, dword [byte esp+03Ch]
        push ecx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.21:
        inc esi
        test byte [edi], 8
        je short .22
        mov eax, dword [byte esp+03Ch]
        push eax
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.22:
        inc esi
        test byte [edi], 4
        je short .23
        mov edx, dword [byte esp+03Ch]
        push edx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.23:
        inc esi
        test byte [edi], 2
        je short .24
        mov ebx, dword [byte esp+03Ch]
        push ebx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.24:
        inc esi
        test byte [edi], 1
        je short .25
        mov ecx, dword [byte esp+03Ch]
        push ecx
        push ebp
        push esi
        call PutPixel
        add esp, byte 0Ch
.25:
        inc esi
        mov ebx, dword [byte esp+030h]
        sub ebx, byte 8
        mov dword [byte esp+030h], ebx
        inc edi
        test ebx, ebx
        jg near .17
.26:
        inc ebp
        jmp near .14
.27:
        mov edx, dword [byte esp+0Ch]
        push edx
        push esi
        mov ebx, dword [byte esp+040h]
        push ebx
        push ebp
        mov ecx, dword [byte esp+02Ch]
        push ecx
        call FillRectClipped
        add esp, byte 14h
        mov eax, dword [byte esp+038h]
        inc eax
        sar eax, 1
        mov dword [byte esp+034h], eax
.28:
        mov ebx, dword [byte esp+020h]
        dec ebx
        mov dword [byte esp+020h], ebx
        cmp ebx, byte 0FFFFFFFFh
        je near .42
        cmp ebp, dword [cliprect_y0]
        jl short .29
        cmp ebp, dword [cliprect_y1]
        jl short .30
.29:
        add edi, dword [byte esp+034h]
        jmp short .34
.30:
        mov esi, dword [byte esp+01Ch]
        mov eax, dword [byte esp+038h]
        mov dword [byte esp+024h], eax
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
        mov ecx, dword [byte esp+024h]
        sub ecx, byte 2
        mov dword [byte esp+024h], ecx
        inc edi
        test ecx, ecx
        jg short .31
.34:
        inc ebp
        jmp short .28
.35:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push esi
        mov esi, dword [byte esp+040h]
        push esi
        push ebp
        mov eax, dword [byte esp+02Ch]
        push eax
        call FillRectClipped
        add esp, byte 14h
.36:
        mov eax, dword [byte esp+020h]
        dec eax
        mov dword [byte esp+020h], eax
        cmp eax, byte 0FFFFFFFFh
        je short .42
        cmp ebp, dword [cliprect_y0]
        jl short .37
        cmp ebp, dword [cliprect_y1]
        jl short .38
.37:
        add edi, dword [byte esp+038h]
        jmp short .41
.38:
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esp+028h], eax
        mov esi, dword [byte esp+038h]
.39:
        dec esi
        cmp esi, byte 0FFFFFFFFh
        je short .41
        mov bh, byte [edi]
        test bh, bh
        je short .40
        xor eax, eax
        mov al, bh
        push eax
        push ebp
        mov eax, dword [byte esp+030h]
        push eax
        call PutPixel
        add esp, byte 0Ch
.40:
        inc dword [byte esp+028h]
        inc edi
        jmp short .39
.41:
        inc ebp
        jmp short .36
.42:
        mov eax, dword [byte esp+08h]
        add dword [TextOriginX], eax
.43:
        mov eax, dword [byte esp+050h]
        cmp byte [eax], 0
        jne near .1
.44:
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; TextPrintAt                                  92CD0  95 PC, medium confidence
; Sets the text origin and draws a string there
;-----------------------------------------------------------------------------
TextPrintAt:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call TextSetCursor
        add esp, byte 8
        mov ecx, dword [byte esp+04h]
        push ecx
        call TextPrint
        add esp, byte 4
        ret
;-----------------------------------------------------------------------------
; TextPutCharAt                                   92CF0  95 PC, low confidence
; Prints one character at a position
;-----------------------------------------------------------------------------
TextPutCharAt:
        sub esp, byte 4
        mov edx, dword [byte esp+010h]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        call TextSetCursor
        add esp, byte 8
        mov al, byte [byte esp+08h]
        mov byte [esp], al
        xor ah, ah
        mov byte [byte esp+01h], ah
        mov eax, esp
        push eax
        call TextPrint
        add esp, byte 4
        add esp, byte 4
        ret
