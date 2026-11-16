; The index of a shape file.
bits 32
%include "hockey.inc"
section s_A2000 progbits alloc exec nowrite align=1
extern _os_handle_0, _os_handle_1, str_SHPI2, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, DrawDestBuffer
extern ScaledRowBuffer, strncpy_, strrchr_, AllocMemBlockEx, ResizeMemBlock, FindCachedFile, UnpackedSize, unpack
extern DosFileInfo, GetBytesLE, PutBytesLE, bcopy, DosOpenFile, DosCloseFile, DosReadFile, DosSeekFile
extern SetBlitSource, CopyRowKeyFF
global DrawShapeQuad, SplitFileExt, ReadFileRange, LoadPackedAlloc, LoadPackedAllocQuiet, LoadPackedAllocFlag, LoadPackedHandle, LoadPackedHandleQuiet
global LoadPackedCore, ConvertShapeBank, ConvertShapeBankInPlace
;-----------------------------------------------------------------------------
; DrawShapeQuad                                   A2000  95 PC, low confidence
; Draws a shape warped into a four-point outline
;-----------------------------------------------------------------------------
DrawShapeQuad:
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
        call CopyRowKeyFF
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
        call CopyRowKeyFF
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
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; SplitFileExt                                 A2610  95 PC, medium confidence
; Copies a file name and returns its extension
;-----------------------------------------------------------------------------
SplitFileExt:
        push esi
        push edi
        push ebp
        mov esi, dword [byte esp+010h]
        mov ebp, dword [byte esp+014h]
        mov edi, ebp
        push edi
.1:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short .2
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short .1
.2:
        pop edi
        mov edx, 2Eh
        mov eax, ebp
        call strrchr_
        test eax, eax
        jne short .8
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        lea edi, [ecx+ebp]
        mov byte [byte edi+04h], 0
        mov ecx, dword [byte esp+018h]
        cmp byte [ecx], 0
        je short .4
        mov esi, 4
.3:
        mov ebx, esi
        mov edx, ecx
        mov eax, edi
        call strncpy_
        add ecx, byte 4
        cmp byte [ecx], 0
        jne short .3
.4:
        mov esi, dword [byte esp+018h]
        cmp byte [esi], 0
        je short .6
.5:
        mov ebx, 4
        mov edx, esi
        mov eax, edi
        call strncpy_
        push ebp
        call DosFileInfo
        add esp, byte 4
        test eax, eax
        jne short .7
        add esi, byte 4
        cmp byte [esi], 0
        jne short .5
.6:
        mov byte [edi], 0
.7:
        mov eax, edi
.8:
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h
;-----------------------------------------------------------------------------
; ReadFileRange                                A26B0  95 PC, medium confidence
; Reads part of an open file into memory, unpacking it when packed
;-----------------------------------------------------------------------------
ReadFileRange:
        push esi
        push edi
        push ebp
        sub esp, 100h
        mov edi, dword [dword esp+0110h]
        mov ebp, dword [dword esp+0118h]
        xor esi, esi
        mov edx, dword [dword esp+0114h]
        push edx
        push edi
        call DosSeekFile
        add esp, byte 8
        lea eax, [byte ebp-08h]
        cmp eax, 100h
        jl short .1
        mov eax, 100h
.1:
        cmp eax, byte 8
        jle short .2
        lea eax, [byte ebp-08h]
        cmp eax, 100h
        jl short .3
        mov eax, 100h
        jmp short .3
.2:
        mov eax, 8
.3:
        push eax
        lea eax, [byte esp+04h]
        push eax
        push edi
        call DosReadFile
        add esp, byte 0Ch
        test eax, eax
        je short .4
        push ebp
        lea eax, [byte esp+04h]
        push eax
        call UnpackedSize
        mov esi, eax
        add esp, byte 8
.4:
        mov ebx, dword [dword esp+0114h]
        push ebx
        push edi
        call DosSeekFile
        add esp, byte 8
        mov eax, esi
        add esp, 100h
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; LoadPackedAlloc                              A2744  95 PC, medium confidence
; Loads a file into a new memory block and returns its data, stopping on an
; error
;-----------------------------------------------------------------------------
LoadPackedAlloc:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadPackedAllocFlag
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; LoadPackedAllocQuiet                         A275C  95 PC, medium confidence
; Loads a file into a new memory block and returns its data, or 0 on an error
;-----------------------------------------------------------------------------
LoadPackedAllocQuiet:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadPackedAllocFlag
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; LoadPackedAllocFlag                          A2774  95 PC, medium confidence
; Loads a file into a new memory block and returns its data; the flag picks
; whether errors stop
;-----------------------------------------------------------------------------
LoadPackedAllocFlag:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        call LoadPackedCore
        add esp, byte 0Ch
        test eax, eax
        je short .1
        mov eax, dword [eax]
.1:
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; LoadPackedHandle                             A2794  95 PC, medium confidence
; Loads a file into a new memory block and returns its descriptor, stopping
; on an error
;-----------------------------------------------------------------------------
LoadPackedHandle:
        push byte 1
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadPackedCore
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; LoadPackedHandleQuiet                        A27AC  95 PC, medium confidence
; Loads a file into a new memory block and returns its descriptor, or 0 on an
; error
;-----------------------------------------------------------------------------
LoadPackedHandleQuiet:
        push byte 0
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call LoadPackedCore
        add esp, byte 0Ch
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; LoadPackedCore                               A27C4  95 PC, medium confidence
; Loads a file, from the file cache when it is there, unpacking it when
; packed
;-----------------------------------------------------------------------------
LoadPackedCore:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, dword [byte esp+020h]
        mov edi, dword [byte esp+028h]
        push esi
        call FindCachedFile
        add esp, byte 4
        test eax, eax
        jne near .5
        push edi
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        push esi
        call DosOpenFile
        add esp, byte 14h
        mov edx, dword [byte esp+08h]
        test edx, edx
        jne short .1
        xor eax, eax
        jmp near .5
.1:
        push edi
        push edx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        mov ebp, dword [byte esp+0Ch]
        push ebp
        call ReadFileRange
        add esp, byte 10h
        mov dword [byte esp+0Ch], eax
        test eax, eax
        jne short .2
        mov eax, dword [esp]
        push eax
        call DosCloseFile
        add esp, byte 4
        xor eax, eax
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
.2:
        mov edx, dword [byte esp+08h]
        cmp eax, edx
        jg short .3
        mov eax, edx
.3:
        add eax, 3EBh
        and al, 0FCh
        mov ebp, eax
        push edi
        mov ebx, dword [byte esp+028h]
        push ebx
        push eax
        push esi
        call AllocMemBlockEx
        mov esi, eax
        add esp, byte 10h
        test eax, eax
        jne short .4
        mov ebp, dword [esp]
        push ebp
        call DosCloseFile
        add esp, byte 4
        xor eax, eax
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
.4:
        mov ecx, dword [eax]
        push ecx
        call _os_handle_0
        add esp, byte 4
        add eax, ebp
        sub eax, dword [byte esp+08h]
        and al, 0FCh
        push eax
        call _os_handle_1
        mov ebp, eax
        add esp, byte 4
        mov eax, dword [byte esp+08h]
        add eax, byte 3
        and al, 0FCh
        push eax
        push ebp
        mov eax, dword [byte esp+08h]
        push eax
        call DosReadFile
        add esp, byte 0Ch
        push edi
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [esi]
        push ebx
        push ebp
        call unpack
        add esp, byte 10h
        push edi
        mov ecx, dword [byte esp+010h]
        push ecx
        push esi
        call ResizeMemBlock
        add esp, byte 0Ch
        mov edi, dword [esp]
        push edi
        call DosCloseFile
        add esp, byte 4
        mov eax, esi
.5:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; ConvertShapeBank                             A28F0  95 PC, medium confidence
; Converts a shape bank from its file layout to the layout in memory
;-----------------------------------------------------------------------------
ConvertShapeBank:
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        push byte 4
        mov edx, dword [byte esp+040h]
        push edx
        call GetBytesLE
        mov ebp, eax
        add esp, byte 8
        push byte 2
        mov eax, dword [byte esp+040h]
        add eax, byte 4
        push eax
        call GetBytesLE
        mov esi, eax
        add esp, byte 8
        mov dword [byte esp+010h], eax
        mov eax, ebp
        add eax, byte 0Ah
        mov dword [byte esp+024h], eax
        mov ebx, dword [byte esp+040h]
        test ebx, ebx
        je near .2
        push byte 10h
        push ebx
        push str_SHPI2
        call bcopy
        add esp, byte 0Ch
        push byte 4
        mov edi, dword [byte esp+028h]
        push edi
        mov eax, dword [byte esp+048h]
        add eax, byte 4
        push eax
        call PutBytesLE
        add esp, byte 0Ch
        push byte 4
        push esi
        mov eax, dword [byte esp+048h]
        add eax, byte 8
        push eax
        call PutBytesLE
        add esp, byte 0Ch
        lea edi, [nosplit esi*8+00h]
        sub ebp, byte 6
        sub ebp, edi
        push ebp
        mov ebp, dword [byte esp+044h]
        add ebp, byte 10h
        lea eax, [edi+ebp]
        push eax
        mov eax, dword [byte esp+044h]
        add eax, byte 6
        mov dword [byte esp+030h], eax
        add eax, edi
        push eax
        call bcopy
        add esp, byte 0Ch
        xor eax, eax
        mov dword [byte esp+01Ch], eax
        test esi, esi
        jle near .2
        mov dword [byte esp+014h], edi
        mov edi, dword [byte esp+040h]
        add edi, byte 14h
        mov eax, dword [byte esp+028h]
        mov dword [byte esp+020h], eax
        shl esi, 2
        add esi, eax
        mov dword [byte esp+018h], esi
.1:
        push byte 4
        mov edx, dword [byte esp+01Ch]
        push edx
        call GetBytesLE
        add esp, byte 8
        add eax, byte 10h
        mov esi, dword [byte esp+014h]
        add esi, eax
        push byte 4
        push byte 4
        mov ebx, dword [byte esp+028h]
        push ebx
        call GetBytesLE
        add esp, byte 8
        push eax
        push ebp
        call PutBytesLE
        add esp, byte 0Ch
        push byte 4
        push esi
        push edi
        call PutBytesLE
        add esp, byte 0Ch
        add esi, dword [byte esp+040h]
        push byte 10h
        lea eax, [byte esp+04h]
        push eax
        push esi
        call bcopy
        add esp, byte 0Ch
        mov al, byte [byte esp+0Ch]
        mov byte [esi], al
        mov al, byte [byte esp+0Dh]
        mov byte [byte esi+01h], al
        mov al, byte [byte esp+0Eh]
        mov byte [byte esi+02h], al
        mov al, byte [byte esp+0Fh]
        mov byte [byte esi+03h], al
        mov al, byte [esp]
        mov byte [byte esi+04h], al
        mov al, byte [byte esp+01h]
        mov byte [byte esi+05h], al
        mov al, byte [byte esp+02h]
        mov byte [byte esi+06h], al
        mov al, byte [byte esp+03h]
        mov byte [byte esi+07h], al
        mov al, byte [byte esp+04h]
        mov byte [byte esi+08h], al
        mov al, byte [byte esp+05h]
        mov byte [byte esi+09h], al
        mov al, byte [byte esp+06h]
        mov byte [byte esi+0Ah], al
        mov al, byte [byte esp+07h]
        mov byte [byte esi+0Bh], al
        mov al, byte [byte esp+08h]
        mov byte [byte esi+0Ch], al
        mov al, byte [byte esp+09h]
        mov byte [byte esi+0Dh], al
        mov al, byte [byte esp+0Ah]
        mov byte [byte esi+0Eh], al
        mov al, byte [byte esp+0Bh]
        mov byte [byte esi+0Fh], al
        add edi, byte 8
        add ebp, byte 8
        add dword [byte esp+020h], byte 4
        add dword [byte esp+018h], byte 4
        mov edx, dword [byte esp+01Ch]
        inc edx
        mov dword [byte esp+01Ch], edx
        cmp edx, dword [byte esp+010h]
        jl near .1
.2:
        mov eax, dword [byte esp+024h]
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; ConvertShapeBankInPlace                      A2AB8  95 PC, medium confidence
; Converts a loaded shape bank in place
;-----------------------------------------------------------------------------
ConvertShapeBankInPlace:
        push byte 0
        mov edx, dword [byte esp+08h]
        push edx
        call ConvertShapeBank
        add esp, byte 8
        ret
