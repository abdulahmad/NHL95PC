; The movie player. Reads a CMV file and draws its frames.
bits 32
%include "hockey.inc"
section s_1AC25 progbits alloc exec nowrite align=1
extern __CHK, str_CmvMemBlock, str_CmvPalette, FreeMemBlock, AllocMemBlock, AllocMemBlockUnlocked, FreeBitmap, bcopy
extern CreateBitmap
global CmvCreate, CmvFreeBuffers, CmvDestroy, CmvReadHeader, CmvDecodeBlocks, CmvDecodeFrame, CmvFrameCount, CmvWidth
global CmvHeight, CmvFrameRate, CmvPaletteFirst, CmvPaletteCount, CmvPalette
;-----------------------------------------------------------------------------
; CmvCreate                                    1AC25  95 PC, medium confidence
; Allocates a CMV movie decoder
;-----------------------------------------------------------------------------
CmvCreate:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push byte 0
        push dword 42Ch
        push str_CmvMemBlock
        call AllocMemBlockUnlocked
        add esp, byte 0Ch
        test eax, eax
        je short .1
        mov dword [eax], 0
        mov dword [byte eax+04h], 0
        mov dword [byte eax+08h], 0
        mov dword [byte eax+0Ch], 0
        mov dword [byte eax+010h], 0
        mov dword [byte eax+014h], 0
        mov dword [byte eax+018h], 0
        mov dword [byte eax+01Ch], 0
        mov dword [byte eax+020h], 0
        mov dword [byte eax+024h], 0
        mov dword [byte eax+028h], 0
.1:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; CmvFreeBuffers                               1AC9A  95 PC, medium confidence
; Frees a CMV decoder's frame buffers
;-----------------------------------------------------------------------------
CmvFreeBuffers:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov esi, eax
        mov edx, dword [byte eax+01Ch]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
.1:
        mov ecx, dword [byte esi+020h]
        test ecx, ecx
        je short .2
        push ecx
        call FreeBitmap
        add esp, byte 4
.2:
        mov ebp, dword [byte esi+024h]
        test ebp, ebp
        je short .3
        push ebp
        call FreeBitmap
        add esp, byte 4
.3:
        mov edx, dword [byte esi+028h]
        test edx, edx
        je short .4
        push edx
        call FreeBitmap
        add esp, byte 4
.4:
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; CmvDestroy                                   1ACF1  95 PC, medium confidence
; Frees a CMV decoder
;-----------------------------------------------------------------------------
CmvDestroy:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, eax
        test eax, eax
        je short .1
        call CmvFreeBuffers
        push edx
        call FreeMemBlock
        add esp, byte 4
.1:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; CmvReadHeader                                1AD16  95 PC, medium confidence
; Reads a movie header chunk: frame count, size, rate and palette
;-----------------------------------------------------------------------------
CmvReadHeader:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov ebp, eax
        lea esi, [byte edx+0Ah]
        call CmvFreeBuffers
        xor eax, eax
        mov al, byte [esi]
        mov dword [edi], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [edi], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+04h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+04h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+08h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+08h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+010h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+010h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+0Ch], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+0Ch], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+014h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        add dword [byte edi+014h], eax
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte edi+018h], eax
        inc esi
        xor eax, eax
        mov al, byte [esi]
        shl eax, 8
        inc esi
        mov edx, dword [byte edi+018h]
        add edx, eax
        mov dword [byte edi+018h], edx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov dword [esp], eax
        push byte 0
        push eax
        push str_CmvPalette
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte edi+01Ch], eax
        xor eax, eax
        mov ecx, dword [esp]
        jmp short .2
.1:
        movzx edi, byte [esi]
        mov edx, edi
        sar edx, 2
        mov edi, dword [byte ebp+01Ch]
        inc esi
        mov byte [edi+eax], dl
        inc eax
.2:
        cmp eax, ecx
        jl short .1
        push byte 0
        mov esi, dword [byte ebp+08h]
        push esi
        mov edi, dword [byte ebp+04h]
        push edi
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte ebp+020h], eax
        push byte 0
        mov eax, dword [byte ebp+08h]
        push eax
        mov edx, dword [byte ebp+04h]
        push edx
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte ebp+024h], eax
        push byte 0
        mov ebx, dword [byte ebp+08h]
        push ebx
        mov ecx, dword [byte ebp+04h]
        push ecx
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [byte ebp+028h], eax
        mov edx, dword [byte ebp+020h]
        mov edx, dword [byte edx+020h]
        xor esi, esi
.3:
        mov edi, esi
        and edi, byte 0Fh
        sub edi, byte 7
        mov eax, esi
        sar eax, 4
        and eax, byte 0Fh
        sub eax, byte 7
        imul eax, edx
        add edi, eax
        mov eax, esi
        mov dword [byte ebp+eax*4+02Ch], edi
        inc esi
        cmp esi, 0FFh
        jle short .3
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; CmvDecodeBlocks                                 1AE6B  95 PC, low confidence
; Decodes the blocks of one CMV frame
;-----------------------------------------------------------------------------
CmvDecodeBlocks:
        push dword 4Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 38h
        mov esi, eax
        mov ecx, edx
        mov eax, dword [byte eax+020h]
        mov edx, dword [byte eax+02Ch]
        mov dword [byte esp+018h], edx
        mov edx, dword [byte esi+024h]
        mov edx, dword [byte edx+02Ch]
        mov dword [byte esp+014h], edx
        mov edx, dword [byte esi+028h]
        mov edx, dword [byte edx+02Ch]
        mov dword [byte esp+010h], edx
        mov edi, dword [byte eax+020h]
        mov edx, edi
        shl edx, 2
        sub edx, edi
        mov dword [byte esp+08h], edx
        mov edx, esi
        add edx, byte 2Ch
        mov dword [byte esp+01Ch], edx
        mov edx, dword [byte esi+04h]
        mov dword [byte esp+030h], edx
        mov ebp, edx
        add edx, edx
        mov dword [byte esp+028h], edx
        add edx, ebp
        mov dword [byte esp+024h], edx
        mov eax, dword [byte eax+028h]
        mov edx, dword [byte esp+018h]
        mov edi, dword [eax]
        lea eax, [edx+edi]
        mov edx, dword [byte esi+08h]
        mov dword [byte esp+0Ch], edx
        jmp near .7
.1:
        mov edx, dword [byte esp+030h]
        mov dword [byte esp+02Ch], edx
        jmp near .6
.2:
        lea edx, [byte ecx+01h]
        mov dword [byte esp+034h], edx
        mov ebp, dword [byte esp+024h]
        add ebp, eax
        mov edi, dword [byte esp+028h]
        add edi, eax
        mov esi, dword [byte esp+030h]
        add esi, eax
        mov edx, eax
        sub edx, dword [byte esp+018h]
        mov dword [byte esp+020h], edx
        mov dl, byte [ecx]
        cmp dl, 0FFh
        je short .3
        mov cl, dl
        and ecx, 0FFh
        shl ecx, 2
        mov edx, dword [byte esp+01Ch]
        add edx, ecx
        mov ecx, dword [byte esp+014h]
        add ecx, dword [byte esp+020h]
        add ecx, dword [edx]
        mov dword [esp], ecx
        mov edx, dword [ecx]
        mov dword [eax], edx
        mov edx, ecx
        add edx, dword [byte esp+030h]
        mov edx, dword [edx]
        mov dword [esi], edx
        mov edx, dword [esp]
        add edx, dword [byte esp+028h]
        mov edx, dword [edx]
        mov dword [edi], edx
        mov edx, dword [esp]
        add edx, dword [byte esp+024h]
        mov edx, dword [edx]
        mov dword [byte ebp+00h], edx
        mov ecx, dword [byte esp+034h]
        jmp short .5
.3:
        lea edx, [byte ebx+01h]
        mov cl, byte [ebx]
        cmp cl, 0FFh
        je short .4
        mov bl, cl
        and ebx, 0FFh
        shl ebx, 2
        add ebx, dword [byte esp+01Ch]
        mov ecx, dword [byte esp+010h]
        add ecx, dword [byte esp+020h]
        add ecx, dword [ebx]
        mov dword [byte esp+04h], ecx
        mov ebx, dword [ecx]
        mov dword [eax], ebx
        mov ebx, ecx
        add ebx, dword [byte esp+030h]
        mov ebx, dword [ebx]
        mov dword [esi], ebx
        mov ebx, dword [byte esp+04h]
        add ebx, dword [byte esp+028h]
        mov ebx, dword [ebx]
        mov dword [edi], ebx
        mov ebx, dword [byte esp+04h]
        add ebx, dword [byte esp+024h]
        mov ebx, dword [ebx]
        mov dword [byte ebp+00h], ebx
        mov ecx, dword [byte esp+034h]
        mov ebx, edx
        jmp short .5
.4:
        mov ecx, dword [byte esp+034h]
        mov ebx, dword [edx]
        mov dword [eax], ebx
        mov ebx, dword [byte edx+04h]
        mov dword [esi], ebx
        mov ebx, dword [byte edx+08h]
        mov dword [edi], ebx
        mov ebx, dword [byte edx+0Ch]
        mov dword [byte ebp+00h], ebx
        lea ebx, [byte edx+010h]
.5:
        add eax, byte 4
        sub dword [byte esp+02Ch], byte 4
.6:
        cmp dword [byte esp+02Ch], byte 0
        jg near .2
        add eax, dword [byte esp+08h]
        sub dword [byte esp+0Ch], byte 4
.7:
        cmp dword [byte esp+0Ch], byte 0
        jg near .1
        add esp, byte 38h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; CmvDecodeFrame                               1B002  95 PC, medium confidence
; Decodes a frame chunk and returns its picture
;-----------------------------------------------------------------------------
CmvDecodeFrame:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov esi, edx
        mov edi, eax
        mov edx, dword [byte eax+04h]
        mov ebx, dword [byte eax+08h]
        lea eax, [byte esi+08h]
        test esi, esi
        jne short .1
        mov eax, dword [byte ecx+020h]
        jmp short .4
.1:
        mov ebp, dword [byte ecx+028h]
        mov esi, dword [byte ecx+024h]
        mov dword [byte ecx+028h], esi
        mov esi, dword [byte ecx+020h]
        mov dword [byte ecx+024h], esi
        mov dword [byte ecx+020h], ebp
        lea esi, [byte eax+02h]
        cmp word [eax], byte 0
        jne short .2
        imul edx, ebx
        push edx
        mov eax, dword [byte ebp+02Ch]
        add eax, byte 10h
        push eax
        push esi
        call bcopy
        add esp, byte 0Ch
        jmp short .3
.2:
        mov eax, edx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        mov ebp, eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        imul eax, ebp
        lea ebx, [esi+eax]
        mov edx, esi
        mov eax, ecx
        call CmvDecodeBlocks
.3:
        mov eax, dword [byte edi+020h]
.4:
        mov eax, dword [byte eax+02Ch]
        jmp near CmvReadHeader+014Fh
;-----------------------------------------------------------------------------
; CmvFrameCount                                1B092  95 PC, medium confidence
; Returns the movie's frame count
;-----------------------------------------------------------------------------
CmvFrameCount:
        push dword 4
        call __CHK
        mov eax, dword [eax]
        ret
;-----------------------------------------------------------------------------
; CmvWidth                                     1B09F  95 PC, medium confidence
; Returns the movie's width
;-----------------------------------------------------------------------------
CmvWidth:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+04h]
        ret
;-----------------------------------------------------------------------------
; CmvHeight                                    1B0AD  95 PC, medium confidence
; Returns the movie's height
;-----------------------------------------------------------------------------
CmvHeight:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+08h]
        ret
;-----------------------------------------------------------------------------
; CmvFrameRate                                 1B0BB  95 PC, medium confidence
; Returns the movie's frame rate
;-----------------------------------------------------------------------------
CmvFrameRate:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+0Ch]
        ret
;-----------------------------------------------------------------------------
; CmvPaletteFirst                              1B0C9  95 PC, medium confidence
; Returns the first palette entry the movie sets
;-----------------------------------------------------------------------------
CmvPaletteFirst:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+014h]
        ret
;-----------------------------------------------------------------------------
; CmvPaletteCount                              1B0D7  95 PC, medium confidence
; Returns the number of palette entries the movie sets
;-----------------------------------------------------------------------------
CmvPaletteCount:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+018h]
        ret
;-----------------------------------------------------------------------------
; CmvPalette                                   1B0E5  95 PC, medium confidence
; Returns the movie's palette
;-----------------------------------------------------------------------------
CmvPalette:
        push dword 4
        call __CHK
        mov eax, dword [byte eax+01Ch]
        ret
