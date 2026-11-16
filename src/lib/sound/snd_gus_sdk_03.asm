; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_AFAE0 progbits alloc exec nowrite align=1
extern cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, DrawDestBuffer, ScaledRowBuffer, SetBlitSource, CopyRowFast
global RasterMappedTriangle
;-----------------------------------------------------------------------------
; RasterMappedTriangle                            AFAE0  95 PC, low confidence
; Texture maps a triangle of art onto the screen row by row
;-----------------------------------------------------------------------------
RasterMappedTriangle:
        push esi
        push edi
        push ebp
        sub esp, byte 6Ch
        mov eax, dword [byte esp+07Ch]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov dword [byte esp+054h], edx
        push ScaledRowBuffer
        add eax, byte 10h
        push eax
        call SetBlitSource
        add esp, byte 8
        xor esi, esi
        xor edi, edi
        mov ecx, dword [dword esp+084h]
        mov ecx, dword [byte ecx+04h]
        mov dword [byte esp+05Ch], ecx
        mov eax, dword [dword esp+084h]
        mov eax, dword [eax]
        mov dword [byte esp+03Ch], eax
        mov dword [byte esp+020h], eax
        mov eax, 1
        mov edx, dword [dword esp+084h]
        add edx, byte 8
.1:
        mov ebx, dword [byte edx+04h]
        cmp ebx, dword [byte esp+05Ch]
        jle short .2
        mov dword [byte esp+05Ch], ebx
        mov ebx, dword [edx]
        mov dword [byte esp+020h], ebx
        mov esi, eax
        jmp short .3
.2:
        cmp ebx, ecx
        jge short .3
        mov ecx, ebx
        mov ebx, dword [edx]
        mov dword [byte esp+03Ch], ebx
        mov edi, eax
.3:
        inc eax
        add edx, byte 8
        cmp eax, byte 3
        jl short .1
        mov eax, dword [byte esp+020h]
        mov edx, dword [byte esp+03Ch]
        sub eax, edx
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+05Ch]
        sub eax, ecx
        mov dword [byte esp+018h], eax
        je near .27
        mov ebp, edi
        or ebp, esi
        mov eax, 3
        sub eax, ebp
        mov ebp, eax
        shl eax, 3
        add eax, dword [dword esp+084h]
        mov edx, dword [byte eax+04h]
        mov dword [byte esp+040h], edx
        mov eax, dword [eax]
        mov dword [byte esp+08h], eax
        sub edx, ecx
        mov ebx, dword [byte esp+04h]
        imul edx, ebx
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+018h]
        add eax, dword [byte esp+03Ch]
        mov ebx, dword [byte esp+08h]
        sub ebx, eax
        test ebx, ebx
        jge short .4
        neg ebx
        mov dword [byte esp+0Ch], 1
        jmp short .5
.4:
        xor eax, eax
        mov dword [byte esp+0Ch], eax
.5:
        test ebx, ebx
        je near .27
        cmp ebx, 600h
        jge near .27
        shl ebp, 3
        add ebx, byte 2
        mov eax, dword [dword esp+080h]
        add eax, ebp
        mov dword [byte esp+010h], eax
        shl edi, 3
        mov eax, dword [dword esp+080h]
        add eax, edi
        mov dword [byte esp+014h], eax
        shl esi, 3
        mov eax, dword [dword esp+080h]
        add eax, esi
        mov dword [byte esp+01Ch], eax
        mov eax, dword [byte esp+014h]
        mov eax, dword [eax]
        mov edx, dword [byte esp+01Ch]
        mov esi, dword [edx]
        mov edx, eax
        sub edx, esi
        mov esi, dword [byte esp+05Ch]
        sub esi, dword [byte esp+040h]
        imul edx, esi
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+018h]
        mov edi, dword [byte esp+01Ch]
        mov edi, dword [edi]
        add edi, eax
        mov eax, dword [byte esp+014h]
        mov eax, dword [byte eax+04h]
        mov edx, dword [byte esp+01Ch]
        mov ebp, dword [byte edx+04h]
        mov edx, eax
        sub edx, ebp
        imul edx, esi
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+018h]
        mov esi, dword [byte esp+01Ch]
        mov esi, dword [byte esi+04h]
        add esi, eax
        mov edx, dword [byte esp+010h]
        mov edx, dword [edx]
        sub edx, edi
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+028h], eax
        mov edx, dword [byte esp+010h]
        mov edx, dword [byte edx+04h]
        sub edx, esi
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+024h], eax
        cmp dword [byte esp+0Ch], byte 0
        je short .6
        neg dword [byte esp+028h]
        neg eax
        mov dword [byte esp+024h], eax
.6:
        mov eax, ScaledRowBuffer
        mov edx, 8000h
        mov esi, edx
.7:
        dec ebx
        cmp ebx, byte 0FFFFFFFFh
        je short .8
        mov edi, edx
        sar edi, 10h
        mov dword [byte esp+044h], edi
        mov edi, esi
        sar edi, 10h
        imul edi, dword [byte esp+054h]
        mov ebp, dword [byte esp+044h]
        add edi, ebp
        mov dword [eax], edi
        add eax, byte 4
        add edx, dword [byte esp+028h]
        add esi, dword [byte esp+024h]
        jmp short .7
.8:
        mov esi, ecx
        mov edi, dword [byte esp+03Ch]
        shl edi, 10h
        add edi, 8000h
        mov dword [byte esp+064h], edi
        mov ebp, dword [byte esp+014h]
        mov ebp, dword [byte ebp+00h]
        shl ebp, 10h
        add edi, 8000h
        add ebp, 8000h
        mov eax, dword [byte esp+014h]
        mov eax, dword [byte eax+04h]
        shl eax, 10h
        add eax, 8000h
        mov dword [byte esp+060h], eax
        xor eax, eax
        mov dword [byte esp+048h], eax
        mov dword [byte esp+04Ch], eax
        cmp dword [byte esp+0Ch], byte 0
        je short .9
        mov ebx, ecx
        sub ebx, dword [byte esp+040h]
        je near .11
        mov eax, dword [byte esp+014h]
        mov eax, dword [eax]
        mov dword [byte esp+068h], eax
        mov eax, dword [byte esp+010h]
        mov eax, dword [eax]
        mov edx, dword [byte esp+068h]
        sub edx, eax
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+04Ch], eax
        mov eax, dword [byte esp+014h]
        mov eax, dword [byte eax+04h]
        mov dword [byte esp+068h], eax
        mov eax, dword [byte esp+010h]
        mov eax, dword [byte eax+04h]
        mov edx, dword [byte esp+068h]
        sub edx, eax
        shl edx, 10h
        mov eax, edx
        jmp short .10
.9:
        mov ebx, ecx
        sub ebx, dword [byte esp+05Ch]
        je short .11
        mov eax, dword [byte esp+014h]
        mov eax, dword [eax]
        mov edx, dword [byte esp+01Ch]
        sub eax, dword [edx]
        shl eax, 10h
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+04Ch], eax
        mov eax, dword [byte esp+014h]
        mov eax, dword [byte eax+04h]
        mov edx, dword [byte esp+01Ch]
        sub eax, dword [byte edx+04h]
        shl eax, 10h
        mov edx, eax
.10:
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+048h], eax
.11:
        xor ebx, ebx
        mov dword [byte esp+02Ch], ebx
        mov dword [byte esp+038h], ebx
        cmp esi, dword [byte esp+040h]
        je near .19
        mov edx, dword [byte esp+03Ch]
        sub edx, dword [byte esp+08h]
        sub ecx, dword [byte esp+040h]
        mov ebx, dword [byte esp+04h]
        shl ebx, 10h
        shl edx, 10h
        cmp dword [byte esp+0Ch], byte 0
        jne short .12
        test ecx, ecx
        je short .13
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+038h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        mov ecx, dword [byte esp+018h]
        idiv ecx
        mov dword [byte esp+02Ch], eax
        jmp short .13
.12:
        test ecx, ecx
        je short .13
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+02Ch], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        mov ebx, dword [byte esp+018h]
        idiv ebx
        mov dword [byte esp+038h], eax
.13:
        mov eax, dword [byte esp+038h]
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add edi, eax
        cmp esi, dword [byte esp+040h]
        jge near .19
        lea eax, [nosplit esi*4+00h]
        mov dword [byte esp+058h], eax
.14:
        cmp esi, dword [cliprect_y1]
        jge near .27
        mov ebx, dword [byte esp+064h]
        sar ebx, 10h
        mov eax, edi
        sar eax, 10h
        sub eax, ebx
        inc eax
        lea edx, [ebx+eax]
        sub edx, dword [cliprect_x1]
        test edx, edx
        jle short .15
        sub eax, edx
.15:
        mov edx, dword [cliprect_x0]
        sub edx, ebx
        test edx, edx
        jle short .16
        sub eax, edx
        add ebx, edx
        cmp edx, 600h
        jg near .27
        jmp short .17
.16:
        xor edx, edx
.17:
        test eax, eax
        jle short .18
        cmp esi, dword [cliprect_y0]
        jle short .18
        push eax
        mov eax, dword [byte esp+064h]
        sar eax, 10h
        mov ecx, dword [byte esp+058h]
        imul ecx, eax
        mov eax, ebp
        sar eax, 10h
        add eax, ecx
        add eax, dword [nosplit edx*4+ScaledRowBuffer]
        push eax
        mov eax, dword [DrawDestBuffer]
        add eax, dword [byte esp+060h]
        add ebx, dword [eax]
        push ebx
        call CopyRowFast
        add esp, byte 0Ch
.18:
        add ebp, dword [byte esp+04Ch]
        mov eax, dword [byte esp+048h]
        add dword [byte esp+060h], eax
        mov eax, dword [byte esp+02Ch]
        add dword [byte esp+064h], eax
        add edi, dword [byte esp+038h]
        add dword [byte esp+058h], byte 4
        inc esi
        cmp esi, dword [byte esp+040h]
        jl near .14
.19:
        mov eax, dword [byte esp+05Ch]
        cmp esi, eax
        je near .27
        mov edx, dword [byte esp+08h]
        sub edx, dword [byte esp+020h]
        mov ecx, dword [byte esp+040h]
        sub ecx, eax
        mov eax, dword [byte esp+08h]
        shl eax, 10h
        mov dword [esp], eax
        mov ebx, dword [byte esp+04h]
        shl ebx, 10h
        shl edx, 10h
        mov eax, dword [byte esp+0Ch]
        test eax, eax
        jne short .20
        mov dword [byte esp+034h], eax
        mov dword [byte esp+030h], eax
        test ecx, ecx
        je near .21
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+030h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        mov ebx, dword [byte esp+018h]
        idiv ebx
        mov dword [byte esp+034h], eax
        mov edi, dword [esp]
        add edi, 100h
        jmp near .21
.20:
        xor eax, eax
        mov dword [byte esp+048h], eax
        mov dword [byte esp+04Ch], eax
        mov dword [byte esp+034h], eax
        mov dword [byte esp+030h], eax
        test ecx, ecx
        je near .21
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+034h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        mov ebx, dword [byte esp+018h]
        idiv ebx
        mov dword [byte esp+030h], eax
        mov eax, dword [esp]
        add eax, 8000h
        mov dword [byte esp+064h], eax
        mov ebp, dword [byte esp+010h]
        mov ebp, dword [byte ebp+00h]
        shl ebp, 10h
        add ebp, 8000h
        mov eax, dword [byte esp+010h]
        mov eax, dword [byte eax+04h]
        shl eax, 10h
        add eax, 8000h
        mov dword [byte esp+060h], eax
        mov eax, dword [byte esp+010h]
        mov eax, dword [eax]
        mov edx, dword [byte esp+01Ch]
        mov ebx, dword [edx]
        mov edx, eax
        sub edx, ebx
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+04Ch], eax
        mov eax, dword [byte esp+010h]
        mov eax, dword [byte eax+04h]
        mov edx, dword [byte esp+01Ch]
        mov ebx, dword [byte edx+04h]
        mov edx, eax
        sub edx, ebx
        shl edx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+048h], eax
.21:
        lea eax, [nosplit esi*4+00h]
        mov dword [byte esp+050h], eax
.22:
        cmp esi, dword [byte esp+05Ch]
        jge near .27
        cmp esi, dword [cliprect_y1]
        jge near .27
        mov edx, dword [byte esp+064h]
        sar edx, 10h
        mov eax, edi
        sar eax, 10h
        sub eax, edx
        inc eax
        lea ebx, [edx+eax]
        sub ebx, dword [cliprect_x1]
        test ebx, ebx
        jle short .23
        sub eax, ebx
.23:
        mov ebx, dword [cliprect_x0]
        sub ebx, edx
        test ebx, ebx
        jle short .24
        sub eax, ebx
        add edx, ebx
        cmp ebx, 600h
        jg short .27
        jmp short .25
.24:
        xor ebx, ebx
.25:
        test eax, eax
        jle short .26
        cmp esi, dword [cliprect_y0]
        jl short .26
        push eax
        mov eax, dword [byte esp+064h]
        sar eax, 10h
        mov ecx, dword [byte esp+058h]
        imul ecx, eax
        mov eax, ebp
        sar eax, 10h
        add eax, ecx
        add eax, dword [nosplit ebx*4+ScaledRowBuffer]
        push eax
        mov eax, dword [DrawDestBuffer]
        add eax, dword [byte esp+058h]
        add edx, dword [eax]
        push edx
        call CopyRowFast
        add esp, byte 0Ch
.26:
        add ebp, dword [byte esp+04Ch]
        mov eax, dword [byte esp+048h]
        add dword [byte esp+060h], eax
        mov eax, dword [byte esp+034h]
        add dword [byte esp+064h], eax
        add edi, dword [byte esp+030h]
        add dword [byte esp+050h], byte 4
        inc esi
        jmp near .22
.27:
        add esp, byte 6Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h
