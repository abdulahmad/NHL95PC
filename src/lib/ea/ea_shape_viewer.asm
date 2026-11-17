; EA debug console: the shape and palette viewers and screenshots.
bits 32
%include "hockey.inc"
section s_95147 progbits alloc exec nowrite align=1
extern _os_handle, _os_handle_0, _os_handle_1, DebugClearScreen, DebugGetKey, DebugPressAnyKey, DebugPrintf, DebugWaitKey
extern DrawArtAnyFormatAt, DrawArtAnyFormatOwnPos, DrawBitmap, fclose_, FillRect, FindShape, fopen_, FormatDateTime
extern fprintf_, KbdGetKey, MemFreeBytes, MemMapRulePtr, MemViewBlack, MemViewCount, MemViewList, MemViewMode
extern MemViewStrings, MemViewWhite, MemViewYellow, NextFreeFileName, PaletteCursorColours, PrintBoxedText, PutBlock, ReturnFalse
extern SelectBitmap, SetPalette, SetScreenTarget, SetTickDeadline, ShapeBankCount, ShapeBankEntry, ShapeBankEntryId, ShowMessageBox
extern SnapScreenToShape, str_033d022X, str_3d3d3d3dS, str_44s05x, str_44s66ld, str_B022d, str_Bad, str_Bytes3dRows3d
extern str_Bytes3dRows3d2, str_CxCy3d3d, str_DATES2, str_ErrorDumpingShapesList, str_FILES2, str_G022d, str_MEMSHPTXT, str_Newline
extern str_NotDrawn, str_NumberOfShapesD, str_NumDPackedD, str_Packed, str_R022d, str_SCREEN2, str_ShapeFileIsInvalid, str_ShapeFileName0
extern str_ShapeFileSizeLd, str_ShapeIsInvalidDraw, str_Spacked, str_StrNewline, str_ThereAreNoShapes, str_TIMES3, str_TwoDigitFmt, str_Un
extern str_Unpacked, str_W_DumpMemoryMap, str_XY3d3d, TextPrintCentered, TextSetColors, VgaSetPalette, ViewScreenHeight, ViewScreenWidth
extern WaitTickDeadline, XorRectOutline
global ShapeViewerFindShape, ShapeViewer, ReadShapeFileHeader, ShapeInfo, DumpShapesList, PaletteViewer, PaletteViewerLabel, SaveScreenshot
global MemViewerShowArt
        db 090h
;-----------------------------------------------------------------------------
; ShapeViewerFindShape                            95148  95 PC, low confidence
; Looks up the shape under the cursor in the shape viewer
;-----------------------------------------------------------------------------
ShapeViewerFindShape:
        push ebx
        push ecx
        push edx
        push eax
        call FindShape
        add esp, byte 8
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; ShapeViewer                                  95158  95 PC, medium confidence
; Debug shape viewer: steps through the shapes of a shape file and draws them
;-----------------------------------------------------------------------------
ShapeViewer:
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov dword [byte esp+034h], eax
        mov ebp, ecx
        lea eax, [byte esp+010h]
        push eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [byte esp+020h]
        push eax
        lea ecx, [byte esp+028h]
        lea ebx, [byte esp+02Ch]
        lea edx, [byte esp+030h]
        mov eax, dword [byte esp+040h]
        call ReadShapeFileHeader
        mov edx, dword [byte esp+024h]
        push edx
        call ShapeBankCount
        add esp, byte 4
        mov dword [byte esp+030h], eax
        xor ah, ah
        mov byte [byte esp+04h], ah
        mov eax, dword [byte esp+020h]
        cmp dword [eax], byte 0
        jl short .1
        mov eax, dword [byte esp+01Ch]
        cmp dword [eax], byte 0
        jge short .2
.1:
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
        mov esi, dword [MemViewBlack]
        push esi
        mov edi, dword [MemViewYellow]
        push edi
        call TextSetColors
        add esp, byte 8
        call ReturnFalse
        push byte 60h
        push str_ShapeFileIsInvalid
        call TextPrintCentered
        add esp, byte 8
        call ReturnFalse
        call DebugPressAnyKey
        cmp eax, byte 59h
        jne near .34
.2:
        xor edi, edi
        mov dword [byte esp+08h], edi
        mov dword [byte esp+02Ch], edi
        xor esi, esi
        cmp dword [byte esp+030h], byte 0
        jle short .7
.3:
        mov eax, esp
        push eax
        push esi
        mov ecx, dword [byte esp+02Ch]
        push ecx
        call ShapeBankEntryId
        add esp, byte 0Ch
        cmp byte [esp], 21h
        jne short .4
        inc edi
.4:
        mov edx, esp
        mov eax, dword [byte esp+024h]
        call ShapeViewerFindShape
        mov eax, dword [eax]
        shl eax, 18h
        sar eax, 18h
        test al, 80h
        je short .5
        inc dword [byte esp+08h]
        jmp short .6
.5:
        inc dword [byte esp+02Ch]
.6:
        inc esi
        cmp esi, dword [byte esp+030h]
        jl short .3
.7:
        call DebugClearScreen
        push edi
        mov ecx, dword [byte esp+030h]
        push ecx
        mov esi, dword [byte esp+010h]
        push esi
        mov eax, dword [byte esp+03Ch]
        push eax
        push str_NumDPackedD
        call DebugPrintf
        add esp, byte 14h
        cmp edi, dword [byte esp+030h]
        jne short .8
        push str_ThereAreNoShapes
        call DebugPrintf
        add esp, byte 4
        jmp near .34
.8:
        cmp ebp, byte 5Bh
        je short .9
        cmp ebp, 4B00h
        jne short .10
.9:
        mov edi, dword [byte esp+030h]
        dec edi
        jmp short .11
.10:
        xor edi, edi
        mov ebp, 5Dh
.11:
        xor ebx, ebx
        mov dword [byte esp+028h], ebx
        mov eax, dword [byte esp+030h]
        dec eax
        mov dword [byte esp+0Ch], eax
.12:
        mov eax, esp
        push eax
        push edi
        mov ecx, dword [byte esp+02Ch]
        push ecx
        call ShapeBankEntryId
        add esp, byte 0Ch
        push edi
        mov esi, dword [byte esp+028h]
        push esi
        call ShapeBankEntry
        mov esi, eax
        add esp, byte 8
        push eax
        call _os_handle_0
        add esp, byte 4
        sub eax, dword [byte esp+034h]
        push eax
        lea eax, [byte esp+04h]
        push eax
        push str_44s05x
        call DebugPrintf
        add esp, byte 0Ch
        mov ebx, dword [MemViewBlack]
        push ebx
        mov ecx, dword [MemViewYellow]
        push ecx
        call TextSetColors
        add esp, byte 8
        push esi
        call _os_handle_0
        add esp, byte 4
        sub eax, dword [byte esp+034h]
        push eax
        lea eax, [byte esp+04h]
        push eax
        push str_44s05x
        push dword 0C0h
        push byte 0
        call PrintBoxedText
        add esp, byte 14h
        call ReturnFalse
        cmp byte [esp], 21h
        je near .19
        mov eax, esi
        call ShapeInfo
        mov dword [byte esp+03Ch], eax
        test eax, eax
        je short .18
        mov eax, dword [esi]
        shl eax, 18h
        sar eax, 18h
        and eax, 80h
        mov dword [byte esp+038h], eax
        call SetScreenTarget
        cmp dword [byte esp+03Ch], byte 2
        jne short .14
        mov ebx, dword [byte esp+038h]
        test ebx, ebx
        je short .13
        push byte 0
        push byte 0
        push esi
        call DrawArtAnyFormatAt
        add esp, byte 0Ch
        jmp short .17
.13:
        push ebx
        push ebx
        push esi
        call PutBlock
        add esp, byte 0Ch
        jmp short .17
.14:
        cmp dword [byte esp+038h], byte 0
        je short .15
        push esi
        call DrawArtAnyFormatOwnPos
        jmp short .16
.15:
        push esi
        call DrawBitmap
.16:
        add esp, byte 4
.17:
        call ReturnFalse
        jmp near .23
.18:
        push str_Bad
        call DebugPrintf
        add esp, byte 4
        mov eax, dword [MemViewBlack]
        call DebugGetKey
        jmp short .23
.19:
        mov eax, dword [byte esi+08h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push str_CxCy3d3d
        call DebugPrintf
        add esp, byte 0Ch
        push str_NotDrawn
        call DebugPrintf
        add esp, byte 4
        cmp ebp, byte 5Bh
        je short .20
        cmp ebp, 4B00h
        jne short .21
.20:
        dec edi
        test edi, edi
        jge short .23
        mov edi, dword [byte esp+0Ch]
        jmp short .23
.21:
        cmp ebp, byte 5Dh
        je short .22
        cmp ebp, byte 53h
        je short .22
        cmp ebp, 4D00h
        jne short .23
.22:
        inc edi
        cmp edi, dword [byte esp+030h]
        jl short .23
        xor edi, edi
.23:
        cmp byte [esp], 21h
        je near .12
        call ReturnFalse
.24:
        call DebugWaitKey
        mov ebp, eax
        test eax, eax
        je short .24
        cmp eax, byte 1Bh
        jne short .25
        mov dword [byte esp+028h], 1
.25:
        cmp ebp, byte 5Bh
        je short .26
        cmp ebp, 4B00h
        jne short .27
.26:
        dec edi
        test edi, edi
        jge short .27
        mov edi, dword [byte esp+0Ch]
.27:
        cmp ebp, byte 5Dh
        je short .28
        cmp ebp, byte 53h
        je short .28
        cmp ebp, 4D00h
        jne short .29
.28:
        inc edi
        cmp edi, dword [byte esp+030h]
        jl short .29
        xor edi, edi
.29:
        cmp ebp, byte 43h
        jne short .30
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
.30:
        cmp ebp, byte 4Dh
        jne short .31
        call DebugClearScreen
.31:
        cmp ebp, byte 50h
        jne short .32
        mov eax, dword [byte esp+034h]
        call DumpShapesList
.32:
        cmp ebp, byte 56h
        jne short .33
        call SaveScreenshot
.33:
        cmp dword [byte esp+028h], byte 0
        je near .12
.34:
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
;-----------------------------------------------------------------------------
; ReadShapeFileHeader                          954C8  95 PC, medium confidence
; Reads a shape file's name, size, count and directory
;-----------------------------------------------------------------------------
ReadShapeFileHeader:
        push esi
        push edi
        push ebp
        mov edi, edx
        mov ebp, ebx
        mov esi, ecx
        push eax
        call _os_handle_1
        add esp, byte 4
        mov dword [edi], eax
        push eax
        call _os_handle
        add esp, byte 4
        mov dword [byte ebp+00h], eax
        add eax, byte 4
        push eax
        call _os_handle
        add esp, byte 4
        mov dword [esi], eax
        add eax, byte 4
        push eax
        call _os_handle
        add esp, byte 4
        mov edi, dword [byte esp+010h]
        mov dword [edi], eax
        mov eax, dword [esi]
        mov edi, dword [eax]
        shl edi, 2
        mov eax, dword [byte esp+010h]
        mov eax, dword [eax]
        add eax, edi
        push eax
        call _os_handle
        add esp, byte 4
        mov edi, dword [byte esp+014h]
        mov dword [edi], eax
        mov eax, dword [esi]
        mov eax, dword [eax]
        shl eax, 2
        mov esi, dword [edi]
        add eax, esi
        push eax
        call _os_handle
        add esp, byte 4
        mov esi, dword [byte esp+018h]
        mov dword [esi], eax
        pop ebp
        pop edi
        pop esi
        ret 0Ch
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; ShapeInfo                                    95548  95 PC, medium confidence
; Debug shape viewer: shows a shape's size, position and packing
;-----------------------------------------------------------------------------
ShapeInfo:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov eax, dword [byte eax+08h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+0Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+04h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+02h]
        sar eax, 10h
        push eax
        push str_Bytes3dRows3d
        call DebugPrintf
        add esp, byte 1Ch
        mov eax, dword [esi]
        shl eax, 18h
        sar eax, 18h
        test al, 80h
        je short .1
        mov eax, MemViewStrings
        jmp short .2
.1:
        mov eax, str_Un
.2:
        push eax
        push str_Spacked
        call DebugPrintf
        add esp, byte 8
        mov eax, dword [esi]
        shl eax, 18h
        sar eax, 18h
        test al, 80h
        je short .3
        mov eax, str_Packed
        jmp short .4
.3:
        mov eax, str_Unpacked
.4:
        push eax
        mov eax, dword [byte esi+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+0Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+04h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+02h]
        sar eax, 10h
        push eax
        push str_3d3d3d3dS
        push dword 0C0h
        push byte 70h
        call PrintBoxedText
        add esp, byte 20h
        call ReturnFalse
        cmp word [byte esi+04h], byte 0
        jl near .5
        mov edx, dword [byte esi+02h]
        sar edx, 10h
        cmp edx, dword [ViewScreenWidth]
        jg short .5
        cmp word [byte esi+06h], byte 0
        jl short .5
        mov eax, dword [byte esi+04h]
        sar eax, 10h
        cmp eax, dword [ViewScreenHeight]
        jg short .5
        cmp word [byte esi+0Ch], byte 0
        jl short .5
        mov ebx, dword [byte esi+0Ah]
        sar ebx, 10h
        cmp ebx, dword [ViewScreenWidth]
        jg short .5
        cmp word [byte esi+0Eh], byte 0
        jl short .5
        mov esi, dword [byte esi+0Ch]
        sar esi, 10h
        mov ebp, dword [ViewScreenHeight]
        cmp esi, ebp
        jg short .5
        add edx, ebx
        cmp edx, dword [ViewScreenWidth]
        jg short .5
        add eax, esi
        cmp eax, ebp
        jle short .7
.5:
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
        mov esi, dword [MemViewBlack]
        push esi
        mov edi, dword [MemViewWhite]
        push edi
        call TextSetColors
        add esp, byte 8
        push byte 60h
        push str_ShapeIsInvalidDraw
        call TextPrintCentered
        add esp, byte 8
        call ReturnFalse
        call DebugPressAnyKey
        cmp eax, byte 59h
        je short .6
        xor eax, eax
        jmp short .8
.6:
        mov eax, 2
        jmp short .8
.7:
        mov eax, 1
.8:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; DumpShapesList                               956C0  95 PC, medium confidence
; Writes a shape file's list of shapes to the next free "MEMSHP??.TXT" file
;-----------------------------------------------------------------------------
DumpShapesList:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 8Ch
        lea edx, [byte esp+070h]
        push edx
        lea edx, [byte esp+078h]
        push edx
        lea edx, [dword esp+080h]
        push edx
        lea ecx, [dword esp+088h]
        lea ebx, [dword esp+08Ch]
        lea edx, [dword esp+090h]
        call ReadShapeFileHeader
        mov eax, dword [byte esp+07Ch]
        mov eax, dword [eax]
        mov dword [dword esp+088h], eax
        xor ah, ah
        mov byte [byte esp+06Ch], ah
        mov edi, esp
        mov esi, str_MEMSHPTXT
        movsd
        movsd
        movsd
        movsb
        mov eax, esp
        call NextFreeFileName
        mov esi, dword [MemFreeBytes]
        push byte 14h
        lea eax, [byte esp+04h]
        push eax
        call ShowMessageBox
        add esp, byte 8
        call ReturnFalse
        mov edx, str_W_DumpMemoryMap
        mov eax, esp
        call fopen_
        mov dword [MemViewList], eax
        test eax, eax
        jne short .1
        push byte 14h
        push str_ErrorDumpingShapesList
        call ShowMessageBox
        add esp, byte 8
        call ReturnFalse
        mov dword [MemFreeBytes], esi
        jmp near .7
.1:
        mov dword [MemFreeBytes], esi
        lea edx, [byte esp+040h]
        lea eax, [byte esp+054h]
        call FormatDateTime
        mov edx, dword [MemMapRulePtr]
        push edx
        push str_StrNewline
        mov ebx, dword [MemViewList]
        push ebx
        call fprintf_
        add esp, byte 0Ch
        mov eax, esp
        push eax
        push str_FILES2
        mov ecx, dword [MemViewList]
        push ecx
        call fprintf_
        add esp, byte 0Ch
        lea eax, [byte esp+054h]
        push eax
        push str_DATES2
        mov esi, dword [MemViewList]
        push esi
        call fprintf_
        add esp, byte 0Ch
        lea eax, [byte esp+040h]
        push eax
        push str_TIMES3
        mov edi, dword [MemViewList]
        push edi
        call fprintf_
        add esp, byte 0Ch
        mov ebp, dword [MemMapRulePtr]
        push ebp
        push str_StrNewline
        mov eax, dword [MemViewList]
        push eax
        call fprintf_
        add esp, byte 0Ch
        mov edx, dword [MemViewCount]
        push edx
        push str_ShapeFileName0
        mov ebx, dword [MemViewList]
        push ebx
        call fprintf_
        add esp, byte 0Ch
        mov eax, dword [dword esp+080h]
        mov ecx, dword [eax]
        push ecx
        push str_ShapeFileSizeLd
        mov esi, dword [MemViewList]
        push esi
        call fprintf_
        add esp, byte 0Ch
        mov edi, dword [dword esp+088h]
        push edi
        push str_NumberOfShapesD
        mov ebp, dword [MemViewList]
        push ebp
        call fprintf_
        add esp, byte 0Ch
        xor esi, esi
        test edi, edi
        jle near .5
        xor edi, edi
.2:
        lea eax, [byte esp+068h]
        push eax
        push esi
        mov ebp, dword [dword esp+08Ch]
        push ebp
        call ShapeBankEntryId
        add esp, byte 0Ch
        mov eax, dword [byte esp+074h]
        mov ebp, dword [edi+eax]
        push esi
        mov eax, dword [dword esp+088h]
        push eax
        call ShapeBankEntry
        mov edx, eax
        add esp, byte 8
        push ebp
        lea eax, [byte esp+06Ch]
        push eax
        push str_44s66ld
        mov ebx, dword [MemViewList]
        push ebx
        call fprintf_
        add esp, byte 10h
        mov eax, dword [byte edx+04h]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+02h]
        sar eax, 10h
        push eax
        push str_Bytes3dRows3d2
        mov ecx, dword [MemViewList]
        push ecx
        call fprintf_
        add esp, byte 10h
        mov eax, dword [byte edx+08h]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+06h]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push str_XY3d3d
        mov ebp, dword [MemViewList]
        push ebp
        call fprintf_
        add esp, byte 18h
        mov eax, dword [edx]
        shl eax, 18h
        sar eax, 18h
        test al, 80h
        je short .3
        mov eax, MemViewStrings
        jmp short .4
.3:
        mov eax, str_Un
.4:
        push eax
        push str_Spacked
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
        add edi, byte 4
        inc esi
        cmp esi, dword [dword esp+088h]
        jl near .2
.5:
        cmp dword [dword esp+088h], byte 0
        je short .6
        push str_Newline
        mov esi, dword [MemViewList]
        push esi
        call fprintf_
        add esp, byte 8
.6:
        mov eax, dword [MemViewList]
        call fclose_
.7:
        add esp, 8Ch
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; PaletteViewer                                9596C  95 PC, medium confidence
; Debug palette viewer: shows the palette and lets each colour's RGB be
; edited
;-----------------------------------------------------------------------------
PaletteViewer:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 330h
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
        xor eax, eax
        call PaletteViewerLabel
        push dword 0FFh
        push dword 0A3h
        push dword 120h
        push byte 16h
        push byte 18h
        call FillRect
        add esp, byte 14h
        call ReturnFalse
        mov dword [dword esp+0308h], 19h
        xor ebx, ebx
        mov dword [dword esp+0310h], ebx
.1:
        mov ebp, dword [dword esp+0308h]
        mov esi, 1Dh
        mov edi, dword [dword esp+0310h]
.2:
        push edi
        push byte 7
        push byte 8
        push ebp
        push esi
        call FillRect
        add esp, byte 14h
        add esi, byte 12h
        inc edi
        cmp esi, 13Dh
        jne short .2
        add dword [dword esp+0308h], byte 0Ah
        mov edi, dword [dword esp+0310h]
        add edi, byte 10h
        mov dword [dword esp+0310h], edi
        cmp edi, 100h
        jne short .1
        call ReturnFalse
        xor esi, esi
        xor edi, edi
        mov dword [dword esp+031Ch], esi
        mov edx, 1Bh
        mov dword [dword esp+0314h], edx
        mov ebx, 17h
        mov dword [dword esp+030Ch], ebx
        mov ecx, dword [PaletteCursorColours]
        push ecx
        push byte 21h
        push byte 26h
        push ebx
        push edx
        call XorRectOutline
        add esp, byte 14h
        call ReturnFalse
        mov dword [dword esp+0318h], esi
        xor eax, eax
        mov al, byte [esp]
        mov dword [dword esp+032Ch], eax
        xor eax, eax
        mov al, byte [byte esp+01h]
        mov dword [dword esp+0328h], eax
        xor eax, eax
        mov al, byte [byte esp+02h]
        mov dword [dword esp+0324h], eax
.3:
        push byte 0Ah
        call SetTickDeadline
        add esp, byte 4
        mov eax, dword [dword esp+0314h]
        mov dword [dword esp+0300h], eax
        mov eax, dword [dword esp+030Ch]
        mov dword [dword esp+0304h], eax
        xor eax, eax
        mov dword [dword esp+0320h], eax
        call KbdGetKey
        mov ebp, eax
        cmp eax, byte 30h
        jne short .4
        xor eax, eax
        call PaletteViewerLabel
.4:
        cmp ebp, byte 31h
        jne short .5
        mov eax, 1
        call PaletteViewerLabel
.5:
        cmp ebp, byte 52h
        jne short .8
        mov edx, dword [dword esp+032Ch]
        inc edx
        mov dword [dword esp+032Ch], edx
        cmp edx, byte 3Fh
        jle short .6
        mov eax, 3Fh
        jmp short .7
.6:
        mov eax, edx
.7:
        mov dword [dword esp+032Ch], eax
        mov dword [dword esp+0320h], 1
.8:
        cmp ebp, byte 47h
        jne short .10
        mov eax, dword [dword esp+0328h]
        inc eax
        mov dword [dword esp+0328h], eax
        cmp eax, byte 3Fh
        jle short .9
        mov eax, 3Fh
.9:
        mov dword [dword esp+0328h], eax
        mov dword [dword esp+0320h], 1
.10:
        cmp ebp, byte 42h
        jne short .13
        mov ecx, dword [dword esp+0324h]
        inc ecx
        mov dword [dword esp+0324h], ecx
        cmp ecx, byte 3Fh
        jle short .11
        mov eax, 3Fh
        jmp short .12
.11:
        mov eax, ecx
.12:
        mov dword [dword esp+0324h], eax
        mov dword [dword esp+0320h], 1
.13:
        cmp ebp, byte 72h
        jne short .16
        mov ebx, dword [dword esp+032Ch]
        dec ebx
        mov dword [dword esp+032Ch], ebx
        test ebx, ebx
        jge short .14
        xor eax, eax
        jmp short .15
.14:
        mov eax, ebx
.15:
        mov dword [dword esp+032Ch], eax
        mov dword [dword esp+0320h], 1
.16:
        cmp ebp, byte 67h
        jne short .19
        mov edx, dword [dword esp+0328h]
        dec edx
        mov dword [dword esp+0328h], edx
        test edx, edx
        jge short .17
        xor eax, eax
        jmp short .18
.17:
        mov eax, edx
.18:
        mov dword [dword esp+0328h], eax
        mov dword [dword esp+0320h], 1
.19:
        cmp ebp, byte 62h
        jne short .21
        mov eax, dword [dword esp+0324h]
        dec eax
        mov dword [dword esp+0324h], eax
        test eax, eax
        jge short .20
        xor eax, eax
.20:
        mov dword [dword esp+0324h], eax
        mov dword [dword esp+0320h], 1
.21:
        cmp ebp, byte 56h
        je short .22
        cmp ebp, byte 76h
        jne short .23
.22:
        call SaveScreenshot
.23:
        cmp ebp, 4700h
        jne short .25
        test esi, esi
        je short .24
        xor esi, esi
        jmp short .25
.24:
        xor edi, edi
.25:
        cmp ebp, 4F00h
        jne short .27
        cmp esi, byte 0Fh
        je short .26
        mov esi, 0Fh
        jmp short .27
.26:
        mov edi, esi
.27:
        cmp ebp, 4800h
        jne short .28
        dec edi
        test edi, edi
        jge short .28
        mov edi, 0Fh
        dec esi
.28:
        cmp ebp, 5000h
        jne short .29
        inc edi
        cmp edi, byte 10h
        jl short .29
        xor edi, edi
        inc esi
.29:
        cmp ebp, 4B00h
        jne short .30
        dec esi
        test esi, esi
        jge short .30
        mov esi, 0Fh
        dec edi
.30:
        cmp ebp, 4D00h
        jne short .31
        inc esi
        cmp esi, byte 10h
        jl short .31
        xor esi, esi
        inc edi
.31:
        test esi, esi
        jge short .32
        mov esi, 0Fh
        jmp short .33
.32:
        cmp esi, byte 10h
        jl short .33
        xor esi, esi
.33:
        test edi, edi
        jge short .34
        mov edi, 0Fh
        jmp short .35
.34:
        cmp edi, byte 10h
        jl short .35
        xor edi, edi
.35:
        cmp dword [dword esp+0320h], byte 0
        je short .36
        mov eax, dword [dword esp+0318h]
        lea eax, [eax+eax*2]
        mov dl, byte [dword esp+032Ch]
        mov byte [esp+eax], dl
        mov dl, byte [dword esp+0328h]
        mov byte [byte esp+eax+01h], dl
        mov dl, byte [dword esp+0324h]
        mov byte [byte esp+eax+02h], dl
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
.36:
        imul eax, esi, byte 12h
        add eax, byte 1Bh
        mov dword [dword esp+0314h], eax
        imul eax, edi, byte 0Ah
        add eax, byte 17h
        mov dword [dword esp+030Ch], eax
        mov eax, dword [dword esp+031Ch]
        mov edx, dword [nosplit eax*4+PaletteCursorColours]
        push edx
        mov eax, dword [dword esp+0308h]
        add eax, byte 0Ah
        push eax
        mov eax, dword [dword esp+0308h]
        add eax, byte 0Bh
        push eax
        mov ebx, dword [dword esp+0310h]
        push ebx
        mov ecx, dword [dword esp+0310h]
        push ecx
        call XorRectOutline
        add esp, byte 14h
        mov eax, dword [dword esp+031Ch]
        inc eax
        mov dword [dword esp+031Ch], eax
        cmp eax, byte 3
        jb short .37
        xor eax, eax
.37:
        mov dword [dword esp+031Ch], eax
        mov ebx, dword [nosplit eax*4+PaletteCursorColours]
        push ebx
        mov eax, dword [dword esp+0310h]
        add eax, byte 0Ah
        push eax
        mov eax, dword [dword esp+031Ch]
        add eax, byte 0Bh
        push eax
        mov ecx, dword [dword esp+0318h]
        push ecx
        mov eax, dword [dword esp+0324h]
        push eax
        call XorRectOutline
        add esp, byte 14h
        call ReturnFalse
        mov eax, edi
        shl eax, 4
        add eax, esi
        mov dword [dword esp+0318h], eax
        lea eax, [eax+eax*2]
        xor edx, edx
        mov dl, byte [esp+eax]
        mov dword [dword esp+032Ch], edx
        xor edx, edx
        mov dl, byte [byte esp+eax+01h]
        mov dword [dword esp+0328h], edx
        mov al, byte [byte esp+eax+02h]
        and eax, 0FFh
        mov dword [dword esp+0324h], eax
        mov edx, dword [MemViewBlack]
        push edx
        mov ebx, dword [MemViewYellow]
        push ebx
        call TextSetColors
        add esp, byte 8
        mov ecx, dword [dword esp+0318h]
        push ecx
        push ecx
        push str_033d022X
        push dword 0C0h
        push byte 44h
        call PrintBoxedText
        add esp, byte 14h
        call ReturnFalse
        mov edx, dword [MemViewBlack]
        push edx
        push byte 4
        call TextSetColors
        add esp, byte 8
        mov ebx, dword [dword esp+032Ch]
        push ebx
        push str_R022d
        push dword 0C0h
        push dword 8Ch
        call PrintBoxedText
        add esp, byte 10h
        call ReturnFalse
        mov ecx, dword [MemViewBlack]
        push ecx
        push byte 2
        call TextSetColors
        add esp, byte 8
        mov eax, dword [dword esp+0328h]
        push eax
        push str_G022d
        push dword 0C0h
        push dword 0B4h
        call PrintBoxedText
        add esp, byte 10h
        call ReturnFalse
        mov edx, dword [MemViewBlack]
        push edx
        push byte 1
        call TextSetColors
        add esp, byte 8
        mov ebx, dword [dword esp+0324h]
        push ebx
        push str_B022d
        push dword 0C0h
        push dword 0DCh
        call PrintBoxedText
        add esp, byte 10h
        call ReturnFalse
        call WaitTickDeadline
        cmp ebp, byte 1Bh
        jne near .3
        add esp, 330h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; PaletteViewerLabel                           95ECC  95 PC, medium confidence
; Debug palette viewer: prints a colour number label
;-----------------------------------------------------------------------------
PaletteViewerLabel:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov edi, eax
        mov edx, dword [MemViewBlack]
        push edx
        mov ebx, dword [MemViewYellow]
        push ebx
        call TextSetColors
        add esp, byte 8
        mov ebp, 19h
        mov esi, ebp
.1:
        push edi
        push str_TwoDigitFmt
        push byte 0Dh
        push esi
        call PrintBoxedText
        add esp, byte 10h
        push edi
        push str_TwoDigitFmt
        push ebp
        push byte 7
        call PrintBoxedText
        add esp, byte 10h
        call ReturnFalse
        add ebp, byte 0Ah
        add esi, byte 12h
        inc edi
        cmp esi, 139h
        jne short .1
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; SaveScreenshot                               95F30  95 PC, medium confidence
; Saves the screen to the next free "SCREEN??.tga" file
;-----------------------------------------------------------------------------
SaveScreenshot:
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov ebp, dword [MemFreeBytes]
        mov edi, esp
        mov esi, str_SCREEN2
        movsd
        movsd
        movsw
        movsb
        mov eax, esp
        call NextFreeFileName
        xor ah, ah
        mov byte [byte esp+08h], ah
        push byte 14h
        lea eax, [byte esp+04h]
        push eax
        call ShowMessageBox
        add esp, byte 8
        call ReturnFalse
        mov eax, esp
        push eax
        call SnapScreenToShape
        add esp, byte 4
        mov dword [MemFreeBytes], ebp
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; MemViewerShowArt                             95F84  95 PC, medium confidence
; Debug memory viewer: draws the art in a memory block
;-----------------------------------------------------------------------------
MemViewerShowArt:
        push ebx
        push ecx
        push esi
        call DebugClearScreen
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
        mov edx, dword [MemViewMode]
        push edx
        call SelectBitmap
        add esp, byte 4
        mov esi, dword [byte eax+02Ch]
        call SetScreenTarget
        mov eax, esi
        call ShapeInfo
        test eax, eax
        je near .8
        mov edx, dword [esi]
        shl edx, 18h
        sar edx, 18h
        and edx, 80h
        cmp eax, byte 2
        jne short .2
        test edx, edx
        je short .1
        push byte 0
        push byte 0
        push esi
        call DrawArtAnyFormatAt
        add esp, byte 0Ch
        jmp short .5
.1:
        push edx
        push edx
        push esi
        call PutBlock
        add esp, byte 0Ch
        jmp short .5
.2:
        test edx, edx
        je short .3
        push esi
        call DrawArtAnyFormatOwnPos
        jmp short .4
.3:
        push esi
        call DrawBitmap
.4:
        add esp, byte 4
.5:
        call ReturnFalse
        xor esi, esi
.6:
        call DebugPressAnyKey
        mov edx, 1
        cmp eax, byte 56h
        jne short .7
        call SaveScreenshot
        mov edx, esi
.7:
        test edx, edx
        je short .6
.8:
        pop esi
        pop ecx
        pop ebx
        ret
