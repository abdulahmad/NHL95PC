; The EA debug console.
bits 32
%include "hockey.inc"
section s_93938 progbits alloc exec nowrite align=1
extern _dos_getdate_, _dos_gettime_, _os_handle, _os_handle_0, _os_handle_1, str_DBUGTXT, str_FILES, str_DATES
extern str_TIMES, str_CLOSED, str_TIMES2, str_DateStampFmt, str_2d02d02d, str_CS44xDS, str_CS44xDS2, str_Used66xFree
extern str_Used7uFree7u, str_NAMESIZEADREND, str_IDXNAMESIZEADR, str_80s, str_StrNewline, str_S_MemViewerDrawList, str_SPACE9x8s8s, str_SPACE9d8s8s
extern str_SPACE66x6, str_SPACE7d66s, str_MemListRowFmt, str_1212s9d8s8s, str_33d1212s66x66s66s44x, str_MemBlockRowFmt, str_MEMMANAGER, str_044X00000000
extern str_SYSTEM, str_SPACE3, str_HIGHMemoryBlock, str_LOWMemoryBlock, str_ConventionalMemory, str_RelocatableBlock, str_NonRelocatableBlock, str_ALIGNFlagIsSet
extern str_PRIORITY1d, str_SequenceD, str_BlockIsPURGABLE, str_04x2, str_02x, str_FourSpaces, str_FILES2, str_DATES2
extern str_TIMES3, str_HexmemdspOS, str_XxMMAPTXT, str_ErrorDumpingMemoryMap, str_ShapeFileIsInvalid, str_NumDPackedD, str_ThereAreNoShapes, str_44s05x
extern str_Bad, str_CxCy3d3d, str_NotDrawn, str_Bytes3dRows3d, str_Spacked, str_Packed, str_Unpacked, str_3d3d3d3dS
extern str_ShapeIsInvalidDraw, str_MEMSHPTXT, str_ErrorDumpingShapesList, str_ShapeFileName0, str_ShapeFileSizeLd, str_NumberOfShapesD, str_44s66ld, str_Bytes3dRows3d2
extern str_XY3d3d, str_033d022X, str_R022d, str_G022d, str_B022d, str_TwoDigitFmt, str_SCREEN2, str_DateTimeFmt
extern str_2d02d02d2, DebugRow, MemViewAttrFlags, DebugPrintf, StartupCs, StartupDs, MemDescriptors, GraphicsReady
extern ViewScreenWidth, ViewScreenHeight, DebugMode, DebugLogOn, MemViewBlack, MemViewWhite, MemViewYellow, MemViewGreen
extern MemViewRed, MemViewShowDetail, MemViewOpen, MemViewCursor, MemViewRowY, MemViewRowX, PaletteCursorColours, DebugLastKey
extern MemFreeBytes, MemViewTop, MemViewCount, MemViewSel, MemViewTitle, MemViewRow, MemViewList, MemViewKey
extern MemViewFlags, MemViewMode, MemViewPrevSel, fclose_, fopen_, fprintf_, fputs_, j___fprtf_
extern memlist0, memlist1, SetTickDeadline, sprintf_, strncpy_, PushMemDescriptorLocked, MarkDescPurgeable, TextSetColors
extern TextSaveState, TextRestoreState, TextSetFont, SetPalette, ShapeBankCount, ShapeBankEntry, ShapeBankEntryId, PutBlock
extern DrawBitmap, FillRect, TextPrintAt, XorRectOutline, DrawFrameClipped, PrintBoxedText, DebugSetLine, DebugShowLines
extern DebugClearScreen, DebugSetRow, DebugSetAttr, ShowMessageBox, ToUpperChar, ReturnFalse, FindNearestColor, TextPrintCentered
extern DrawArtAnyFormatAt, DrawArtAnyFormatOwnPos, SnapScreenToShape, SelectBitmap, FindShape, ClearScreen, KbdGetKey, KbdFlush
extern SaveDrawState, RestoreDrawState, FindFirstFile, PollHotkeys, VgaSetPalette, SetScreenTarget, SetClipWindow, FillRectColor
extern str_Wt2, str_Asterisks, str_Fs, str_Jan2, str_Feb3, str_Mar2, str_Apr2, str_May3
extern str_Jun2, str_Jul2, str_Aug2, str_Sep2, str_Oct2, str_Nov2, str_Dec2, str_CharFmt
extern MemViewStrings, str_X_DebugSprintf, str_One, str_Asterisk, str_SpaceChar, str_N, str_FF, str_W_DumpMemoryMap
extern str_Un, str_Newline, DefaultFont, vsprintf_, WaitTickDeadline
global DebugLogOpen, DebugLogClose, DebugLog, DebugLogPrintf, FindWildcardDigits, FormatDateStamp, MemMapRulePtr, MonthNameTable
global DebugWaitKey, DebugGetKey, MemViewerGetMode, MemViewer, MemViewer, MemViewerStart, MemViewerListHead, MemViewerDrawRows
global MemViewerCountBlocks, MemViewerSelectRow, MemViewerDrawList, MemPoolTotals, MemViewerDrawTitle, DebugSprintf, MemViewerBlockInfo, MemViewerHexDump
global HexDumpRow, WriteMemMap, DumpMemoryMap, ShapeViewerFindShape, ShapeViewer, ReadShapeFileHeader, ShapeInfo, DumpShapesList
global PaletteViewer, PaletteViewerLabel, SaveScreenshot, MemViewerShowArt, FormatDateTime, NextFreeFileName, DebugGetKeyUpper, DebugPressAnyKey
global DebugKbdFlush, DebugFlushAndWait
;-----------------------------------------------------------------------------
; DebugLogOpen                                    93938  95 PC, low confidence
; Opens the debug log file unless it is already open
;-----------------------------------------------------------------------------
DebugLogOpen:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 0B0h
        cmp dword [DebugLogOn], byte 0
        jne near .7
        mov esi, eax
        mov edi, esp
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
        mov edi, esp
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        test cx, cx
        jle short .3
        movsx eax, cx
        mov dl, byte [byte esp+eax-01h]
        cmp dl, 5Ch
        je short .3
        cmp dl, 3Ah
        je short .3
        mov byte [esp+eax], 5Ch
        xor bh, bh
        mov byte [byte esp+eax+01h], bh
.3:
        mov esi, str_DBUGTXT
        mov edi, esp
        push edi
        LD sub, ecx, ecx
        dec ecx
        mov al, 0
        repne scasb
        dec edi
.4:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short .5
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short .4
.5:
        pop edi
        mov eax, esp
        call FindWildcardDigits
        mov edx, str_Wt2
        mov eax, esp
        call fopen_
        mov dword [DebugLogOn], eax
        test eax, eax
        je short .6
        lea edx, [dword esp+09Ch]
        lea eax, [dword esp+088h]
        call FormatDateStamp
        mov eax, esp
        push eax
        push str_FILES
        call DebugLog
        add esp, byte 8
        lea eax, [dword esp+088h]
        push eax
        push str_DATES
        call DebugLog
        add esp, byte 8
        lea eax, [dword esp+09Ch]
        push eax
        push str_TIMES
        call DebugLog
        add esp, byte 8
        jmp short .7
.6:
        call fclose_
.7:
        add esp, 0B0h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugLogClose                                93A40  95 PC, medium confidence
; Writes the closing date and time to the debug log and closes it
;-----------------------------------------------------------------------------
DebugLogClose:
        push ebx
        push ecx
        push edx
        sub esp, byte 28h
        cmp dword [DebugLogOn], byte 0
        je short .1
        mov edx, esp
        lea eax, [byte esp+014h]
        call FormatDateStamp
        push str_CLOSED
        call DebugLog
        add esp, byte 4
        lea eax, [byte esp+014h]
        push eax
        push str_DATES
        call DebugLog
        add esp, byte 8
        mov eax, esp
        push eax
        push str_TIMES2
        call DebugLog
        add esp, byte 8
        mov eax, dword [DebugLogOn]
        call fclose_
        xor ebx, ebx
        mov dword [DebugLogOn], ebx
.1:
        add esp, byte 28h
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DebugLog                                     93AA4  95 PC, medium confidence
; Prints a formatted line to the debug log file when the debug level is 2 or
; more
;-----------------------------------------------------------------------------
DebugLog:
        sub esp, byte 4
        cmp dword [DebugMode], byte 2
        jl short .1
        mov ebx, dword [DebugLogOn]
        test ebx, ebx
        je short .1
        lea eax, [byte esp+0Ch]
        mov dword [esp], eax
        mov eax, ebx
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        call j___fprtf_
        xor ecx, ecx
        mov dword [esp], ecx
.1:
        add esp, byte 4
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugLogPrintf                               93AD8  95 PC, medium confidence
; Formats a line with vsprintf and writes it to the debug log
;-----------------------------------------------------------------------------
DebugLogPrintf:
        sub esp, 104h
        cmp dword [DebugMode], byte 2
        jl short .2
        lea eax, [dword esp+010Ch]
        mov dword [dword esp+0100h], eax
        lea ebx, [dword esp+0100h]
        mov edx, dword [dword esp+0108h]
        mov eax, esp
        call vsprintf_
        xor ebx, ebx
        mov dword [dword esp+0100h], ebx
        mov ecx, dword [DebugLogOn]
        test ecx, ecx
        je short .1
        mov edx, ecx
        mov eax, esp
        call fputs_
.1:
        mov eax, esp
        call DebugShowLines
.2:
        add esp, 104h
        ret
;-----------------------------------------------------------------------------
; FindWildcardDigits                           93B34  95 PC, medium confidence
; Finds the run of ? characters in a file name pattern
;-----------------------------------------------------------------------------
FindWildcardDigits:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov dword [esp], eax
        xor edi, edi
        mov esi, eax
        cmp byte [eax], 3Fh
        je short .2
.1:
        cmp byte [esi], 0
        je short .2
        inc esi
        inc edi
        cmp byte [esi], 3Fh
        jne short .1
.2:
        mov ebp, dword [esp]
        add ebp, edi
        cmp byte [byte ebp+00h], 0
        je short .3
        cmp byte [byte ebp+01h], 3Fh
        je short .4
.3:
        xor eax, eax
        jmp short .8
.4:
        xor esi, esi
.5:
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        mov ebx, 0Ah
        idiv ebx
        add eax, byte 30h
        mov byte [byte ebp+00h], al
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        add edx, byte 30h
        mov byte [byte ebp+01h], dl
        mov edx, dword [esp]
        push edx
        call FindFirstFile
        add esp, byte 4
        test eax, eax
        je short .6
        inc esi
        cmp esi, byte 64h
        jl short .5
.6:
        cmp esi, byte 64h
        jl short .7
        add edi, dword [esp]
        mov byte [byte edi+01h], 78h
        mov al, byte [byte edi+01h]
        mov byte [edi], al
        mov eax, 2
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov eax, 1
.8:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; FormatDateStamp                              93BD4  95 PC, medium confidence
; Formats the current DOS date and time as a short stamp
;-----------------------------------------------------------------------------
FormatDateStamp:
        push ebx
        push ecx
        push esi
        sub esp, byte 0Ch
        mov ebx, eax
        mov ecx, edx
        mov eax, esp
        call _dos_getdate_
        lea eax, [byte esp+08h]
        call _dos_gettime_
        xor edx, edx
        mov dx, word [byte esp+02h]
        mov esi, 64h
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        push edx
        xor eax, eax
        mov al, byte [byte esp+05h]
        mov edx, dword [nosplit eax*4+DebugLogOn]
        push edx
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        push str_DateStampFmt
        push ebx
        call sprintf_
        add esp, byte 14h
        xor eax, eax
        mov al, byte [byte esp+0Ah]
        push eax
        xor eax, eax
        mov al, byte [byte esp+0Dh]
        push eax
        xor eax, eax
        mov al, byte [byte esp+010h]
        push eax
        push str_2d02d02d
        push ecx
        call sprintf_
        add esp, byte 14h
        add esp, byte 0Ch
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h
MemMapRulePtr:                                  ; used by DumpShapesList, WriteMemMap
        dd str_Asterisks
MonthNameTable:                                 ; used by FormatDateTime
        dd str_Fs
        dd str_Jan2
        dd str_Feb3
        dd str_Mar2
        dd str_Apr2
        dd str_May3
        dd str_Jun2
        dd str_Jul2
        dd str_Aug2
        dd str_Sep2
        dd str_Oct2
        dd str_Nov2
        dd str_Dec2
;-----------------------------------------------------------------------------
; DebugWaitKey                                    93C88  95 PC, low confidence
; Waits for a key in the debug viewers and returns it in upper case
;-----------------------------------------------------------------------------
DebugWaitKey:
        push ebx
        push ecx
        push edx
        call PollHotkeys
        push eax
        call ToUpperChar
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DebugGetKey                                  93CA0  95 PC, medium confidence
; Debug viewers: polls the hotkeys and returns the key pressed in upper case
;-----------------------------------------------------------------------------
DebugGetKey:
        push ebx
        push ecx
        push edx
        push eax
        call ClearScreen
        add esp, byte 4
        call ReturnFalse
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; MemViewerGetMode                                93CB8  95 PC, low confidence
; Returns the memory viewer mode
;-----------------------------------------------------------------------------
MemViewerGetMode:
        mov eax, dword [MemViewOpen]
        lea eax, [byte eax+00h]
;-----------------------------------------------------------------------------
; MemViewer                                       93CC0  95 PC, low confidence
; Memory viewer screen: block list, totals, hex dump and art view
;-----------------------------------------------------------------------------
MemViewer:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 0C4h
        mov dword [dword esp+0B8h], eax
        mov eax, esp
        push eax
        call SaveDrawState
        add esp, byte 4
        lea eax, [byte esp+060h]
        push eax
        call TextSaveState
        add esp, byte 4
        push DefaultFont
        call TextSetFont
        add esp, byte 4
        mov al, byte [DebugRow]
        mov byte [dword esp+0C0h], al
        push byte 0
        call DebugSetRow
        add esp, byte 4
        cmp dword [GraphicsReady], byte 0
        jne short .1
        mov dword [dword esp+0B8h], 1
.1:
        push byte 0
        call FindNearestColor
        add esp, byte 4
        mov dword [MemViewBlack], eax
        push dword 0FCFCFCh
        call FindNearestColor
        add esp, byte 4
        mov dword [MemViewWhite], eax
        push dword 0FCFC54h
        call FindNearestColor
        add esp, byte 4
        mov dword [MemViewYellow], eax
        push dword 80A8h
        call FindNearestColor
        add esp, byte 4
        mov dword [MemViewGreen], eax
        push dword 0A80000h
        call FindNearestColor
        add esp, byte 4
        mov dword [MemViewRed], eax
        mov ebp, dword [MemViewRowY]
        mov edi, dword [MemViewRowX]
        cmp dword [dword esp+0B8h], byte 0
        sete al
        and eax, 0FFh
        mov dword [dword esp+0B0h], eax
        xor esi, esi
        mov dword [dword esp+0BCh], esi
        mov eax, dword [MemViewOpen]
        mov ebx, dword [dword esp+0B8h]
        cmp eax, ebx
        je short .2
        mov dword [MemViewRowY], ebp
        mov dword [MemViewRowX], edi
        mov dword [MemViewOpen], ebx
        cmp dword [dword esp+0B0h], byte 0
        jne short .2
        test ebx, ebx
        sete al
        and eax, 0FFh
        mov dword [dword esp+0B0h], eax
.2:
        call MemViewerCountBlocks
        mov ecx, dword [dword esp+0B8h]
        mov ebx, eax
        mov edx, ebp
        mov eax, edi
        call MemViewerDrawList
        mov dword [dword esp+0B4h], eax
        lea edx, [byte ebp+014h]
        cmp edx, eax
        jle short .3
        mov edx, eax
.3:
        call DebugWaitKey
        mov esi, eax
        test eax, eax
        je short .3
        cmp eax, 4900h
        jne short .5
        cmp edi, ebp
        jne short .4
        test ebp, ebp
        jle short .4
        sub ebp, byte 15h
.4:
        mov edi, ebp
.5:
        cmp esi, 5100h
        jne short MemViewerDrawRows+0Fh
        cmp edi, edx
        je short MemViewerDrawRows
        mov edi, edx
        jmp short MemViewerDrawRows+0Fh
;-----------------------------------------------------------------------------
; MemViewerStart                                  93E38  95 PC, low confidence
; Opens the memory viewer in mode 1
;-----------------------------------------------------------------------------
MemViewerStart:
        mov edx, 1
        mov dword [MemViewOpen], edx
        mov eax, edx
        jmp near MemViewer
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; MemViewerListHead                            93E4C  95 PC, medium confidence
; Returns the head of the current memory list, or of its guard list
;-----------------------------------------------------------------------------
MemViewerListHead:
        push ebx
        push edx
        mov ebx, eax
        mov edx, dword [MemViewCursor]
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 2
        cmp ebx, byte 1
        jne short .1
        mov eax, dword [dword eax+memlist1]
        pop edx
        pop ebx
        ret
.1:
        mov eax, dword [dword eax+memlist0]
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; MemViewerDrawRows                               93E79  95 PC, low confidence
; Draws the rows of the memory viewer block list
;-----------------------------------------------------------------------------
MemViewerDrawRows:
        cmp edx, dword [dword esp+0B4h]
        jge short MemViewerDrawRows+0Fh
        add ebp, byte 15h
        lea edi, [byte edx+015h]
        cmp esi, 4800h
        jne short .1
        test edi, edi
        jle short .1
        dec edi
        cmp edi, ebp
        jge short .1
        dec ebp
.1:
        cmp esi, 5000h
        jne short .2
        cmp edi, dword [dword esp+0B4h]
        jge short .2
        inc edi
        cmp edi, edx
        jle short .2
        inc ebp
.2:
        cmp esi, 4700h
        jne short .4
        cmp edi, ebp
        jne short .3
        xor ebp, ebp
.3:
        mov edi, ebp
.4:
        cmp esi, 4F00h
        jne short .6
        mov ecx, dword [dword esp+0B4h]
        cmp edi, ecx
        je short .6
        cmp edi, edx
        je short .5
        mov edi, edx
        jmp short .6
.5:
        lea ebp, [byte ecx-014h]
        mov edi, ecx
.6:
        cmp esi, byte 1Bh
        jne short .7
        mov dword [dword esp+0BCh], 1
.7:
        cmp esi, byte 0Dh
        jne short .8
        mov edx, dword [MemViewPrevSel]
        mov eax, dword [MemViewSel]
        mov ebx, dword [dword esp+0B8h]
        call MemViewerHexDump
.8:
        cmp esi, byte 43h
        jne short .9
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
.9:
        cmp esi, byte 46h
        jne short .10
        xor edx, edx
        mov dword [MemFreeBytes], edx
.10:
        cmp esi, byte 44h
        jne short .11
        xor byte [MemViewShowDetail], 1
.11:
        cmp esi, byte 42h
        jne short .12
        mov edx, dword [MemViewKey]
        mov eax, dword [MemViewFlags]
        mov ebx, dword [dword esp+0B8h]
        call MemViewerBlockInfo
.12:
        cmp esi, byte 4Dh
        jne short .13
        call DebugClearScreen
.13:
        cmp esi, byte 50h
        je short .14
        cmp esi, byte 20h
        jne short .15
.14:
        call DumpMemoryMap
.15:
        cmp esi, byte 53h
        je short .16
        cmp esi, byte 5Bh
        je short .16
        cmp esi, byte 5Dh
        je short .16
        cmp esi, 4B00h
        je short .16
        cmp esi, 4D00h
        jne short .17
.16:
        test byte [MemViewAttrFlags], 80h
        jne short .17
        mov edx, dword [MemViewPrevSel]
        mov eax, dword [MemViewSel]
        mov ecx, esi
        mov ebx, dword [dword esp+0B8h]
        call ShapeViewer
.17:
        cmp esi, byte 56h
        jne short .18
        call SaveScreenshot
.18:
        cmp esi, byte 54h
        jne short .19
        mov eax, dword [dword esp+0B8h]
        call PaletteViewer
.19:
        cmp esi, byte 57h
        jne short .20
        mov eax, dword [MemViewSel]
        mov edx, dword [dword esp+0B8h]
        call MemViewerShowArt
.20:
        cmp esi, byte 41h
        jne short .21
        xor byte [dword esp+0B8h], 1
.21:
        cmp esi, byte 9
        jne short .22
        xor byte [dword esp+0B8h], 1
.22:
        cmp esi, 5300h
        jne short .23
        test byte [MemViewAttrFlags], 80h
        jne short .23
        mov ebx, dword [MemViewMode]
        push ebx
        call PushMemDescriptorLocked
        add esp, byte 4
.23:
        cmp esi, 5200h
        jne short .24
        test byte [MemViewAttrFlags], 80h
        jne short .24
        mov edx, dword [MemViewCount]
        mov ebx, 0Ch
        lea eax, [dword esp+0A0h]
        call strncpy_
        xor ch, ch
        mov byte [dword esp+0ACh], ch
        mov ecx, dword [MemViewMode]
        push ecx
        call MarkDescPurgeable
        add esp, byte 4
.24:
        mov esi, dword [dword esp+0B4h]
        cmp ebp, esi
        jle short .25
        mov edi, esi
        sub ebp, byte 15h
        jmp short .26
.25:
        test ebp, ebp
        jge short .26
        xor ebp, ebp
        xor edi, edi
.26:
        mov eax, dword [dword esp+0B4h]
        cmp edi, eax
        jle short .27
        mov edi, eax
.27:
        cmp dword [dword esp+0BCh], byte 0
        je near MemViewer+0E5h
        mov dword [MemViewRowY], ebp
        mov dword [MemViewRowX], edi
        call DebugKbdFlush
        cmp dword [dword esp+0B0h], byte 0
        je short .28
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
.28:
        xor eax, eax
        mov al, byte [dword esp+0C0h]
        push eax
        call DebugSetRow
        add esp, byte 4
        lea eax, [byte esp+060h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov eax, esp
        push eax
        call RestoreDrawState
        add esp, byte 4
        add esp, 0C4h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; MemViewerCountBlocks                            940F4  95 PC, low confidence
; Counts the blocks the memory viewer will list
;-----------------------------------------------------------------------------
MemViewerCountBlocks:
        push edx
        xor edx, edx
        mov eax, 1
        call MemViewerListHead
        test eax, eax
        je short .2
.1:
        mov eax, dword [byte eax+020h]
        inc edx
        test eax, eax
        jne short .1
.2:
        lea eax, [byte edx+01h]
        pop edx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; MemViewerSelectRow                           94114  95 PC, medium confidence
; Debug memory viewer: records the block on the cursor row while drawing the
; list
;-----------------------------------------------------------------------------
MemViewerSelectRow:
        cmp edx, byte 2
        je short .4
        cmp eax, ebx
        jl short .1
        add ebx, byte 15h
        cmp eax, ebx
        jl short .2
.1:
        mov eax, 1
        ret 10h
.2:
        cmp eax, ecx
        jne short .3
        mov eax, dword [MemViewWhite]
        mov dword [MemViewRow], eax
        mov dword [MemViewTop], 70h
        mov eax, dword [byte esp+04h]
        mov dword [MemViewSel], eax
        mov eax, dword [byte esp+08h]
        mov dword [MemViewPrevSel], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [MemViewFlags], eax
        mov eax, dword [byte esp+010h]
        mov dword [MemViewKey], eax
        xor eax, eax
        ret 10h
.3:
        mov eax, dword [MemViewBlack]
        mov dword [MemViewRow], eax
        mov dword [MemViewTop], 7
.4:
        xor eax, eax
        ret 10h
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; MemViewerDrawList                            94188  95 PC, medium confidence
; Debug memory viewer: draws the memory totals and the list of blocks
;-----------------------------------------------------------------------------
MemViewerDrawList:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 158h
        sub ebp, 82h
        mov dword [byte ebp+076h], eax
        mov dword [byte ebp+07Ah], edx
        mov dword [byte ebp+06Eh], ebx
        mov dword [byte ebp+07Eh], ecx
        lea ecx, [byte ebp+05Ah]
        lea ebx, [byte ebp+062h]
        lea edx, [byte ebp+066h]
        lea eax, [byte ebp+05Eh]
        call MemPoolTotals
        mov edx, dword [byte ebp+05Eh]
        push edx
        mov ebx, dword [MemFreeBytes]
        push ebx
        mov ecx, dword [StartupDs]
        push ecx
        mov esi, dword [StartupCs]
        push esi
        cmp dword [MemViewShowDetail], byte 0
        je short .1
        mov eax, str_CS44xDS
        jmp short .2
.1:
        mov eax, str_CS44xDS2
.2:
        push eax
        lea eax, [byte ebp-02Eh]
        push eax
        call sprintf_
        add esp, byte 18h
        mov eax, dword [byte ebp+05Ah]
        push eax
        mov edx, dword [byte ebp+062h]
        push edx
        mov ebx, dword [byte ebp+066h]
        push ebx
        cmp dword [MemViewShowDetail], byte 0
        je short .3
        mov eax, str_Used66xFree
        jmp short .4
.3:
        mov eax, str_Used7uFree7u
.4:
        push eax
        lea eax, [dword ebp-082h]
        push eax
        call sprintf_
        add esp, byte 14h
        cmp dword [byte ebp+07Eh], byte 0
        jne near .5
        mov ecx, 0Ah
        lea edi, [dword ebp-0D6h]
        mov esi, str_NAMESIZEADREND
        rep movsd
        call SetScreenTarget
        mov esi, dword [MemViewBlack]
        push esi
        mov edi, dword [MemViewYellow]
        push edi
        call TextSetColors
        add esp, byte 8
        mov eax, dword [MemViewBlack]
        push eax
        push byte 0
        mov edx, dword [ViewScreenWidth]
        push edx
        push byte 0
        push byte 0
        call FillRect
        add esp, byte 14h
        push byte 0
        push byte 0
        lea eax, [byte ebp-02Eh]
        push eax
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        mov ebx, dword [MemViewBlack]
        push ebx
        push byte 1
        mov ecx, dword [ViewScreenWidth]
        push ecx
        push byte 8
        push byte 0
        call FillRect
        add esp, byte 14h
        push byte 9
        push byte 0
        lea eax, [dword ebp-082h]
        push eax
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        mov esi, dword [MemViewBlack]
        push esi
        push byte 1
        mov edi, dword [ViewScreenWidth]
        push edi
        push byte 11h
        push byte 0
        call FillRect
        add esp, byte 14h
        push byte 12h
        push byte 0
        lea eax, [dword ebp-0D6h]
        push eax
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        mov eax, dword [MemViewBlack]
        push eax
        push byte 2
        mov edx, dword [ViewScreenWidth]
        push edx
        push byte 1Ah
        push byte 0
        call FillRect
        add esp, byte 14h
        call ReturnFalse
        jmp near .7
.5:
        mov ecx, 0Bh
        lea edi, [dword ebp-0D6h]
        mov esi, str_IDXNAMESIZEADR
        rep movsd
        mov edi, dword [byte ebp+07Eh]
        cmp edi, byte 1
        jne short .6
        push byte 0Bh
        push str_CharFmt
        call DebugPrintf
        add esp, byte 8
        lea eax, [byte ebp-02Eh]
        push eax
        push str_80s
        push byte 0
        push byte 0
        call DebugSetLine
        add esp, byte 10h
        lea eax, [dword ebp-082h]
        push eax
        push str_80s
        push edi
        push byte 0
        call DebugSetLine
        add esp, byte 10h
        lea eax, [dword ebp-0D6h]
        push eax
        push str_80s
        push byte 2
        push byte 0
        call DebugSetLine
        add esp, byte 10h
        push MemViewStrings
        push str_80s
        push byte 3
        push byte 0
        call DebugSetLine
        add esp, byte 10h
        jmp short .7
.6:
        cmp edi, byte 2
        jne short .7
        lea eax, [byte ebp-02Eh]
        push eax
        push str_StrNewline
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
        lea eax, [dword ebp-082h]
        push eax
        push str_StrNewline
        mov ebx, dword [MemViewList]
        push ebx
        call fprintf_
        add esp, byte 0Ch
        lea eax, [dword ebp-0D6h]
        push eax
        push str_S_MemViewerDrawList
        mov ecx, dword [MemViewList]
        push ecx
        call fprintf_
        add esp, byte 0Ch
.7:
        xor esi, esi
        xor edi, edi
        cmp dword [byte ebp+06Eh], byte 0
        jle near .25
.8:
        lea eax, [byte ebp+056h]
        push eax
        lea eax, [byte ebp+042h]
        push eax
        lea eax, [byte ebp+046h]
        push eax
        lea eax, [byte ebp+04Ah]
        push eax
        lea ecx, [byte ebp+04Eh]
        lea ebx, [byte ebp+03Eh]
        lea edx, [byte ebp+052h]
        mov eax, edi
        call MemViewerDrawTitle
        mov eax, dword [byte ebp+03Eh]
        mov ecx, dword [byte ebp+056h]
        cmp eax, ecx
        je near .16
        push byte 0
        push dword 0A000h
        sub eax, ecx
        push eax
        push ecx
        mov ecx, dword [byte ebp+076h]
        mov ebx, dword [byte ebp+07Ah]
        mov edx, dword [byte ebp+07Eh]
        mov eax, esi
        call MemViewerSelectRow
        test eax, eax
        jne near .15
        lea edx, [byte ebp+032h]
        mov eax, dword [byte ebp+056h]
        call DebugSprintf
        lea edx, [byte ebp+026h]
        mov eax, dword [byte ebp+03Eh]
        call DebugSprintf
        mov eax, dword [byte ebp+03Eh]
        sub eax, dword [byte ebp+056h]
        cmp dword [byte ebp+07Eh], byte 0
        jne short .11
        lea edx, [byte ebp+026h]
        push edx
        lea edx, [byte ebp+032h]
        push edx
        push eax
        cmp dword [MemViewShowDetail], byte 0
        je short .9
        mov eax, str_SPACE9x8s8s
        jmp short .10
.9:
        mov eax, str_SPACE9d8s8s
.10:
        push eax
        lea eax, [byte ebp-02Eh]
        push eax
        call sprintf_
        add esp, byte 14h
        mov edx, dword [MemViewRed]
        push edx
        mov ebx, dword [MemViewRow]
        push ebx
        call TextSetColors
        add esp, byte 8
        mov eax, esi
        sub eax, dword [byte ebp+07Ah]
        shl eax, 3
        add eax, byte 1Ch
        push eax
        push byte 0
        lea eax, [byte ebp-02Eh]
        push eax
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        jmp near .15
.11:
        lea edx, [byte ebp+026h]
        push edx
        lea edx, [byte ebp+032h]
        push edx
        push eax
        cmp dword [MemViewShowDetail], byte 0
        je short .12
        mov eax, str_SPACE66x6
        jmp short .13
.12:
        mov eax, str_SPACE7d66s
.13:
        push eax
        lea eax, [byte ebp-02Eh]
        push eax
        call sprintf_
        add esp, byte 14h
        mov ecx, dword [byte ebp+07Eh]
        cmp ecx, byte 1
        jne short .14
        mov ebx, dword [MemViewTop]
        push ebx
        call DebugSetAttr
        add esp, byte 4
        lea eax, [byte ebp-02Eh]
        push eax
        push str_80s
        mov eax, esi
        sub eax, dword [byte ebp+07Ah]
        add eax, byte 4
        push eax
        push byte 0
        call DebugSetLine
        add esp, byte 10h
        jmp short .15
.14:
        cmp ecx, byte 2
        jne short .15
        lea eax, [byte ebp-02Eh]
        push eax
        push str_StrNewline
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
.15:
        inc esi
.16:
        mov eax, dword [byte ebp+042h]
        push eax
        mov edx, dword [byte ebp+046h]
        push edx
        mov ebx, dword [byte ebp+04Ah]
        push ebx
        mov ecx, dword [byte ebp+03Eh]
        push ecx
        mov ecx, dword [byte ebp+076h]
        mov ebx, dword [byte ebp+07Ah]
        mov edx, dword [byte ebp+07Eh]
        mov eax, esi
        call MemViewerSelectRow
        test eax, eax
        jne near .24
        cmp esi, dword [byte ebp+076h]
        jne short .17
        mov eax, dword [MemViewTitle]
        mov eax, dword [byte eax+024h]
        mov dword [MemViewMode], eax
        add eax, byte 4
        mov dword [MemViewCount], eax
.17:
        lea edx, [byte ebp+032h]
        mov eax, dword [byte ebp+03Eh]
        call DebugSprintf
        mov eax, dword [byte ebp+03Eh]
        add eax, dword [byte ebp+04Eh]
        lea edx, [byte ebp+026h]
        call DebugSprintf
        cmp dword [byte ebp+07Eh], byte 0
        jne short .20
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+032h]
        push eax
        mov eax, dword [byte ebp+04Ah]
        push eax
        mov edx, dword [byte ebp+052h]
        push edx
        cmp dword [MemViewShowDetail], byte 0
        je short .18
        mov eax, str_MemListRowFmt
        jmp short .19
.18:
        mov eax, str_1212s9d8s8s
.19:
        push eax
        lea eax, [dword ebp-082h]
        push eax
        call sprintf_
        add esp, byte 18h
        mov ecx, dword [MemViewRow]
        push ecx
        mov eax, dword [MemViewGreen]
        push eax
        call TextSetColors
        add esp, byte 8
        mov eax, esi
        sub eax, dword [byte ebp+07Ah]
        shl eax, 3
        add eax, byte 1Ch
        push eax
        push byte 0
        lea eax, [dword ebp-082h]
        push eax
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        jmp near .24
.20:
        mov ecx, dword [byte ebp+046h]
        push ecx
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+032h]
        push eax
        mov eax, dword [byte ebp+04Ah]
        push eax
        mov edx, dword [byte ebp+052h]
        push edx
        push edi
        cmp dword [MemViewShowDetail], byte 0
        je short .21
        mov eax, str_33d1212s66x66s66s44x
        jmp short .22
.21:
        mov eax, str_MemBlockRowFmt
.22:
        push eax
        lea eax, [dword ebp-082h]
        push eax
        call sprintf_
        add esp, byte 20h
        mov ecx, dword [byte ebp+07Eh]
        cmp ecx, byte 1
        jne short .23
        mov ebx, dword [MemViewTop]
        push ebx
        call DebugSetAttr
        add esp, byte 4
        lea eax, [dword ebp-082h]
        push eax
        push str_80s
        mov eax, esi
        sub eax, dword [byte ebp+07Ah]
        add eax, byte 4
        push eax
        push byte 0
        call DebugSetLine
        add esp, byte 10h
        push byte 7
        call DebugSetAttr
        add esp, byte 4
        jmp short .24
.23:
        cmp ecx, byte 2
        jne short .24
        lea eax, [dword ebp-082h]
        push eax
        push str_StrNewline
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
.24:
        inc esi
        inc edi
        cmp edi, dword [byte ebp+06Eh]
        jl near .8
.25:
        mov eax, dword [byte ebp+07Ah]
        add eax, byte 15h
        mov dword [byte ebp+06Ah], eax
        mov edi, dword [byte ebp+07Eh]
        test edi, edi
        jne short .28
        cmp esi, eax
        jge short .26
        mov eax, dword [ViewScreenHeight]
        push eax
        mov eax, esi
        sub eax, dword [byte ebp+07Ah]
        shl eax, 3
        add eax, byte 1Ch
        push eax
        mov ebx, dword [ViewScreenWidth]
        push ebx
        push edi
        jmp short .27
.26:
        mov ecx, dword [ViewScreenHeight]
        push ecx
        push dword 0C4h
        mov edi, dword [ViewScreenWidth]
        push edi
        push byte 0
.27:
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [MemViewBlack]
        call DebugGetKey
        call SetScreenTarget
        jmp short .30
.28:
        cmp edi, byte 1
        jne short .30
        push byte 7
        call DebugSetAttr
        add esp, byte 4
        lea eax, [byte esi+04h]
        mov edx, dword [byte ebp+07Ah]
        neg edx
        add eax, edx
        mov edi, eax
        mov ebx, dword [byte ebp+06Ah]
        add ebx, byte 4
        add edx, ebx
        mov dword [byte ebp+072h], edx
        cmp eax, edx
        jge short .30
.29:
        push MemViewStrings
        push str_80s
        push edi
        push byte 0
        call DebugSetLine
        add esp, byte 10h
        inc edi
        cmp edi, dword [byte ebp+072h]
        jl short .29
.30:
        lea eax, [byte esi-01h]
        lea esp, [dword ebp+082h]
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
;-----------------------------------------------------------------------------
; MemPoolTotals                                9477C  95 PC, medium confidence
; Adds up the used, free and largest free sizes of the current memory list
;-----------------------------------------------------------------------------
MemPoolTotals:
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov edi, edx
        mov esi, ebx
        mov eax, 1
        call MemViewerListHead
        mov ebx, eax
        mov eax, dword [byte eax+020h]
        mov dword [ecx], 0
        mov edx, dword [ecx]
        mov dword [esi], edx
        mov dword [edi], edx
        mov dword [byte ebp+00h], edx
        test eax, eax
        je short .4
.1:
        mov edx, dword [eax]
        sub edx, dword [ebx]
        sub edx, dword [byte ebx+010h]
        test byte [byte eax+019h], 80h
        jne short .2
        mov ebx, dword [byte eax+010h]
        add dword [edi], ebx
.2:
        add dword [esi], edx
        cmp edx, dword [ecx]
        jbe short .3
        mov dword [ecx], edx
.3:
        mov ebx, eax
        mov eax, dword [byte eax+020h]
        test eax, eax
        jne short .1
.4:
        mov eax, dword [edi]
        mov ecx, dword [esi]
        add eax, ecx
        mov dword [byte ebp+00h], eax
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
;-----------------------------------------------------------------------------
; MemViewerDrawTitle                           947D8  95 PC, medium confidence
; Debug memory viewer: draws the "MEM MANAGER" title bar
;-----------------------------------------------------------------------------
MemViewerDrawTitle:
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov eax, edx
        mov esi, ebx
        mov edi, ecx
        test ebp, ebp
        jne short .1
        mov dword [edx], str_MEMMANAGER
        mov ebp, dword [MemDescriptors]
        push ebp
        call _os_handle_0
        add esp, byte 4
        mov dword [esi], eax
        mov ebp, dword [MemViewCursor]
        lea eax, [nosplit ebp*4+00h]
        add eax, ebp
        mov eax, dword [nosplit eax*4+memlist1]
        mov edx, dword [eax]
        push edx
        call _os_handle_0
        add esp, byte 4
        mov edx, dword [esi]
        sub eax, edx
        mov dword [edi], eax
        mov edx, dword [byte esp+010h]
        mov dword [edx], eax
        mov eax, dword [byte esp+014h]
        mov dword [eax], 8000h
        mov eax, dword [byte esp+018h]
        mov dword [eax], 0
        mov eax, dword [esi]
        mov edx, dword [byte esp+01Ch]
        mov dword [edx], eax
        mov edx, dword [MemViewCursor]
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        mov eax, dword [nosplit eax*4+memlist1]
        jmp short .4
.1:
        mov edx, dword [MemViewTitle]
        lea ebx, [byte edx+04h]
        mov dword [eax], ebx
        mov ebx, dword [edx]
        push ebx
        call _os_handle_0
        add esp, byte 4
        mov dword [esi], eax
        mov eax, dword [MemViewTitle]
        mov edx, dword [byte eax+010h]
        mov dword [edi], edx
        mov edx, dword [byte eax+014h]
        mov ebx, dword [byte esp+010h]
        mov dword [ebx], edx
        mov edx, dword [byte eax+018h]
        mov ebx, dword [byte esp+014h]
        mov dword [ebx], edx
        mov edx, dword [byte esp+018h]
        mov dword [edx], 0
        cmp ebp, byte 1
        jle short .2
        mov esi, dword [byte eax+024h]
        mov ecx, dword [esi]
        push ecx
        call _os_handle_0
        add esp, byte 4
        mov edx, dword [byte esi+010h]
        add eax, edx
        jmp short .3
.2:
        mov eax, dword [esi]
.3:
        mov edx, dword [byte esp+01Ch]
        mov dword [edx], eax
        mov eax, dword [MemViewTitle]
        mov eax, dword [byte eax+020h]
.4:
        mov dword [MemViewTitle], eax
        pop ebp
        pop edi
        pop esi
        ret 10h
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DebugSprintf                                 948D4  95 PC, medium confidence
; Formats a string through sprintf for the debug viewers
;-----------------------------------------------------------------------------
DebugSprintf:
        push eax
        push str_X_DebugSprintf
        push edx
        call sprintf_
        add esp, byte 0Ch
        ret
;-----------------------------------------------------------------------------
; MemViewerBlockInfo                           948E4  95 PC, medium confidence
; Debug memory viewer: shows a popup describing a memory block's flags
;-----------------------------------------------------------------------------
MemViewerBlockInfo:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov dword [byte esp+08h], eax
        mov dword [byte esp+04h], edx
        mov dword [esp], ebx
        call SetScreenTarget
        mov edx, dword [MemViewWhite]
        push edx
        push dword 0A4h
        push dword 111h
        push byte 37h
        push byte 2Eh
        call DrawFrameClipped
        add esp, byte 14h
        mov ebx, dword [MemViewRed]
        push ebx
        push dword 0A3h
        push dword 110h
        push byte 38h
        push byte 2Fh
        call DrawFrameClipped
        add esp, byte 14h
        mov ecx, dword [MemViewBlack]
        push ecx
        push byte 6Ah
        push dword 0E0h
        push byte 39h
        push byte 30h
        call FillRect
        add esp, byte 14h
        mov esi, dword [MemViewBlack]
        push esi
        mov edi, dword [MemViewYellow]
        push edi
        call TextSetColors
        add esp, byte 8
        mov ebp, dword [byte esp+08h]
        push ebp
        push str_044X00000000
        push byte 3Dh
        push byte 38h
        call PrintBoxedText
        add esp, byte 10h
        call ReturnFalse
        mov edi, 0F8h
        xor esi, esi
.1:
        test ebp, 1
        je short .2
        push byte 3Dh
        push edi
        push str_One
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
.2:
        sar ebp, 1
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        mov ebx, 4
        idiv ebx
        sub edi, byte 8
        cmp edx, byte 3
        jne short .3
        sub edi, byte 8
.3:
        inc esi
        cmp esi, byte 10h
        jl short .1
        mov eax, dword [MemViewRed]
        push eax
        mov edx, dword [MemViewBlack]
        push edx
        call TextSetColors
        add esp, byte 8
        mov edi, 50h
        mov esi, 4Dh
        test byte [byte esp+09h], 80h
        je short .4
        mov ebx, dword [MemViewRed]
        push ebx
        push byte 4Ch
        push dword 8Fh
        push byte 4Ch
        push edi
        call FillRectColor
        add esp, byte 14h
        push esi
        push edi
        push str_SYSTEM
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        mov esi, 55h
.4:
        test byte [byte esp+09h], 20h
        je short .5
        mov ecx, dword [MemViewRed]
        push ecx
        lea edx, [byte esi-01h]
        push edx
        lea ebp, [byte edi+037h]
        push ebp
        push edx
        push edi
        call FillRectColor
        add esp, byte 14h
        push esi
        push edi
        push str_SPACE3
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        add esi, byte 8
.5:
        test byte [byte esp+09h], 0A0h
        je short .6
        add esi, byte 8
.6:
        mov ebp, dword [MemViewBlack]
        push ebp
        mov eax, dword [MemViewWhite]
        push eax
        call TextSetColors
        add esp, byte 8
        lea ebp, [byte esi+0Ah]
        test byte [byte esp+08h], 20h
        je short .7
        push esi
        push edi
        push str_HIGHMemoryBlock
        jmp short .8
.7:
        push esi
        push edi
        push str_LOWMemoryBlock
.8:
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        mov esi, ebp
        push esi
        push edi
        push str_ConventionalMemory
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        lea ebp, [byte esi+014h]
        add esi, byte 0Ah
        test byte [byte esp+08h], 10h
        je short .9
        push esi
        push edi
        push str_RelocatableBlock
        jmp short .10
.9:
        push esi
        push edi
        push str_NonRelocatableBlock
.10:
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        mov esi, ebp
        test byte [byte esp+08h], 40h
        je short .11
        push esi
        push edi
        push str_ALIGNFlagIsSet
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        add esi, byte 0Ah
.11:
        test byte [byte esp+08h], 0Fh
        je short .12
        mov edx, dword [byte esp+08h]
        and edx, byte 7
        push edx
        push str_PRIORITY1d
        push esi
        push edi
        call PrintBoxedText
        add esp, byte 10h
        call ReturnFalse
        add esi, byte 0Ah
.12:
        mov edx, dword [byte esp+04h]
        push edx
        push str_SequenceD
        push esi
        push edi
        call PrintBoxedText
        add esp, byte 10h
        call ReturnFalse
        add esi, byte 0Ah
        test byte [byte esp+08h], 8
        je short .13
        push esi
        push edi
        push str_BlockIsPURGABLE
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
.13:
        cmp dword [esp], byte 0
        jne short .14
        call DebugPressAnyKey
.14:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; MemViewerHexDump                             94B6C  95 PC, medium confidence
; Debug memory viewer: hex dump of a memory block with paging keys
;-----------------------------------------------------------------------------
MemViewerHexDump:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        mov dword [byte esp+08h], eax
        test edx, edx
        jne short .1
        call DebugClearScreen
        jmp near .37
.1:
        mov eax, edx
        shr eax, 4
        mov dword [byte esp+024h], eax
        test dl, 0Fh
        je short .2
        lea edx, [byte eax+01h]
        mov dword [byte esp+024h], edx
.2:
        xor esi, esi
        cmp dword [byte esp+024h], byte 19h
        xor ebp, ebp
        xor edi, edi
        mov dword [byte esp+028h], ebp
        mov dword [byte esp+020h], ebp
        mov dword [byte esp+018h], ebp
        mov eax, dword [byte esp+024h]
        sub eax, byte 19h
        mov dword [byte esp+04h], eax
.3:
        mov eax, dword [byte esp+024h]
        sub eax, esi
        mov dword [byte esp+02Ch], eax
        cmp eax, byte 19h
        jle short .4
        mov dword [byte esp+02Ch], 19h
.4:
        mov eax, dword [byte esp+02Ch]
        cmp edi, eax
        jl short .5
        lea edi, [byte eax-01h]
.5:
        mov eax, esi
        shl eax, 4
        add eax, dword [byte esp+08h]
        push eax
        call _os_handle_1
        add esp, byte 4
        mov dword [byte esp+01Ch], eax
        mov ebx, dword [byte esp+028h]
        push ebx
        push edi
        mov ecx, ebp
        mov ebx, eax
        mov edx, esi
        mov eax, dword [byte esp+034h]
        call HexDumpRow
        mov dword [byte esp+014h], ebp
        mov dword [byte esp+010h], edi
        mov dword [byte esp+0Ch], esi
        call ReturnFalse
.6:
        call KbdGetKey
        mov dword [byte esp+030h], eax
        push eax
        call ToUpperChar
        add esp, byte 4
        mov edx, eax
        test eax, eax
        je short .6
        xor ebx, ebx
        mov dword [esp], ebx
        cmp eax, byte 1Bh
        jne short .8
        cmp dword [byte esp+028h], byte 0
        je short .7
        mov dword [byte esp+028h], ebx
        jmp short .8
.7:
        mov dword [byte esp+018h], 1
.8:
        cmp edx, 4900h
        jne short .11
        test edi, edi
        je short .9
        xor edi, edi
        jmp short .11
.9:
        test esi, esi
        jbe short .11
        cmp esi, byte 19h
        jbe short .10
        sub esi, byte 19h
        jmp short .11
.10:
        xor esi, esi
.11:
        cmp edx, 5100h
        jne short .13
        mov eax, dword [byte esp+02Ch]
        dec eax
        cmp edi, eax
        je short .12
        mov edi, 18h
        jmp short .13
.12:
        lea eax, [byte esi+019h]
        cmp eax, dword [byte esp+024h]
        jae short .13
        add esi, byte 19h
.13:
        cmp edx, 4800h
        je short .14
        cmp edx, 5000h
        jne short .15
.14:
        mov ebx, edx
.15:
        cmp edx, byte 8
        jne short .16
        mov ebx, 4B00h
.16:
        cmp edx, 4700h
        jne short .19
        test ebp, ebp
        je short .17
        xor ebp, ebp
        jmp short .19
.17:
        test edi, edi
        je short .18
        xor edi, edi
        jmp short .19
.18:
        test esi, esi
        je short .19
        xor esi, esi
.19:
        cmp edx, 4F00h
        jne short .22
        cmp ebp, byte 0Fh
        je short .20
        mov ebp, 0Fh
        jmp short .22
.20:
        mov eax, dword [byte esp+02Ch]
        dec eax
        cmp edi, eax
        je short .21
        mov edi, 18h
        jmp short .22
.21:
        lea eax, [byte esi+018h]
        cmp eax, dword [byte esp+024h]
        jae short .22
        mov esi, dword [byte esp+04h]
.22:
        cmp dword [byte esp+028h], byte 1
        jne short .23
        mov ebx, dword [byte esp+01Ch]
        add ebx, ebp
        mov eax, edi
        shl eax, 4
        add eax, ebx
        mov bl, byte [byte esp+030h]
        mov byte [eax], bl
        mov ebx, 4D00h
.23:
        cmp edx, byte 4Dh
        jne short .24
        mov dword [byte esp+028h], 1
.24:
        cmp edx, byte 30h
        jl short .25
        cmp edx, byte 39h
        jg short .25
        lea eax, [byte edx-030h]
        mov dword [byte esp+030h], eax
        mov dword [esp], 1
.25:
        cmp edx, byte 41h
        jl short .26
        cmp edx, byte 46h
        jg short .26
        sub edx, byte 37h
        mov dword [byte esp+030h], edx
        mov dword [esp], 1
.26:
        cmp dword [esp], byte 0
        je short .28
        mov eax, dword [byte esp+01Ch]
        add eax, ebp
        mov edx, edi
        shl edx, 4
        add eax, edx
        mov edx, dword [byte esp+020h]
        test edx, edx
        jne short .27
        mov dh, byte [eax]
        and dh, 0Fh
        mov dl, byte [byte esp+030h]
        shl dl, 4
        add dh, dl
        mov byte [eax], dh
        mov dword [byte esp+020h], 1
        jmp short .28
.27:
        cmp edx, byte 1
        jne short .28
        mov dl, byte [eax]
        and dl, 0F0h
        mov dh, byte [byte esp+030h]
        add dh, dl
        mov byte [eax], dh
        mov ebx, 4D00h
.28:
        cmp ebx, 4B00h
        jne short .29
        dec ebp
        test ebp, ebp
        jge short .30
        mov ebp, 0Fh
        mov ebx, 4800h
        jmp short .30
.29:
        cmp ebx, 4D00h
        jne short .30
        inc ebp
        cmp ebp, byte 0Fh
        jle short .30
        xor ebp, ebp
        mov ebx, 5000h
.30:
        cmp ebx, 4800h
        jne short .32
        test edi, edi
        jle short .31
        dec edi
        jmp short .34
.31:
        test esi, esi
        jbe short .34
        dec esi
        jmp short .34
.32:
        cmp ebx, 5000h
        jne short .34
        cmp edi, byte 18h
        jge short .33
        inc edi
        jmp short .34
.33:
        lea eax, [byte esi+019h]
        cmp eax, dword [byte esp+024h]
        jae short .34
        inc esi
.34:
        cmp ebp, dword [byte esp+014h]
        jne short .35
        cmp edi, dword [byte esp+010h]
        jne short .35
        cmp esi, dword [byte esp+0Ch]
        je short .36
.35:
        xor edx, edx
        mov dword [byte esp+020h], edx
.36:
        cmp dword [byte esp+018h], byte 0
        je near .3
.37:
        add esp, byte 34h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; HexDumpRow                                   94E34  95 PC, medium confidence
; Prints one row of a hex dump: offset, bytes and characters
;-----------------------------------------------------------------------------
HexDumpRow:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov dword [byte esp+04h], eax
        mov edi, edx
        mov esi, ebx
        mov dword [esp], ecx
        push byte 0Bh
        push str_CharFmt
        call DebugPrintf
        add esp, byte 8
        shl edi, 4
        mov dword [byte esp+08h], edi
        xor ebp, ebp
        cmp dword [byte esp+04h], byte 0
        jle near .10
.1:
        mov edi, dword [byte esp+08h]
        push edi
        push str_04x2
        call DebugPrintf
        add esp, byte 8
        xor edi, edi
.2:
        cmp edi, dword [esp]
        jne short .3
        cmp ebp, dword [byte esp+020h]
        jne short .3
        push byte 70h
        call DebugSetAttr
        add esp, byte 4
.3:
        xor eax, eax
        mov al, byte [esi]
        push eax
        push str_02x
        call DebugPrintf
        add esp, byte 8
        cmp edi, dword [esp]
        jne short .4
        cmp ebp, dword [byte esp+020h]
        jne short .4
        cmp dword [byte esp+024h], byte 0
        je short .4
        push str_Asterisk
        call DebugPrintf
        add esp, byte 4
        push byte 7
        call DebugSetAttr
        jmp short .5
.4:
        push byte 7
        call DebugSetAttr
        add esp, byte 4
        push str_SpaceChar
        call DebugPrintf
.5:
        add esp, byte 4
        mov eax, edi
        and eax, byte 3
        cmp eax, byte 3
        jne short .6
        push str_SpaceChar
        call DebugPrintf
        add esp, byte 4
.6:
        inc esi
        inc edi
        cmp edi, byte 10h
        jl near .2
        push str_SpaceChar
        call DebugPrintf
        add esp, byte 4
        xor edi, edi
        sub esi, byte 10h
.7:
        mov al, byte [esi]
        and al, 7Fh
        mov byte [byte esp+0Ch], al
        mov dword [MemViewTop], 7
        cmp al, 20h
        jae short .8
        mov byte [byte esp+0Ch], 2Eh
.8:
        test byte [esi], 80h
        je short .9
        mov dword [MemViewTop], 70h
.9:
        mov ecx, dword [MemViewTop]
        push ecx
        call DebugSetAttr
        add esp, byte 4
        xor eax, eax
        mov al, byte [byte esp+0Ch]
        push eax
        push str_CharFmt
        call DebugPrintf
        add esp, byte 8
        inc esi
        inc edi
        cmp edi, byte 10h
        jl short .7
        push byte 7
        call DebugSetAttr
        add esp, byte 4
        push str_FourSpaces
        call DebugPrintf
        add esp, byte 4
        add dword [byte esp+08h], byte 10h
        inc ebp
        cmp ebp, dword [byte esp+04h]
        jl near .1
.10:
        mov edi, ebp
        cmp ebp, byte 19h
        jge short .12
.11:
        push MemViewStrings
        push str_80s
        call DebugPrintf
        add esp, byte 8
        inc edi
        cmp edi, byte 19h
        jl short .11
.12:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret 8
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; WriteMemMap                                  94FBC  95 PC, medium confidence
; Writes the memory map to an open text file with a file, date and time
; header
;-----------------------------------------------------------------------------
WriteMemMap:
        push esi
        push edi
        push ebp
        sub esp, byte 28h
        mov edx, dword [byte esp+038h]
        xor eax, eax
        test edx, edx
        je near .3
        mov dword [MemViewList], edx
        mov edx, esp
        lea eax, [byte esp+014h]
        call FormatDateTime
        mov edx, dword [MemMapRulePtr]
        push edx
        push str_StrNewline
        mov ebx, dword [MemViewList]
        push ebx
        call fprintf_
        add esp, byte 0Ch
        mov ecx, dword [byte esp+03Ch]
        push ecx
        push str_FILES2
        mov esi, dword [MemViewList]
        push esi
        call fprintf_
        add esp, byte 0Ch
        lea eax, [byte esp+014h]
        push eax
        push str_DATES2
        mov edi, dword [MemViewList]
        push edi
        call fprintf_
        add esp, byte 0Ch
        mov eax, esp
        push eax
        push str_TIMES3
        mov ebp, dword [MemViewList]
        push ebp
        call fprintf_
        add esp, byte 0Ch
        mov eax, dword [MemMapRulePtr]
        push eax
        push str_StrNewline
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
        cmp dword [MemViewShowDetail], byte 0
        je short .1
        mov eax, str_N
        jmp short .2
.1:
        mov eax, str_FF
.2:
        push eax
        push str_HexmemdspOS
        mov ecx, dword [MemViewList]
        push ecx
        call fprintf_
        add esp, byte 0Ch
        call MemViewerCountBlocks
        mov ecx, 2
        mov ebx, eax
        xor edx, edx
        xor eax, eax
        call MemViewerDrawList
        mov eax, 1
.3:
        add esp, byte 28h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DumpMemoryMap                                950AC  95 PC, medium confidence
; Writes the memory map to the next free "xxMMAP??.TXT" file
;-----------------------------------------------------------------------------
DumpMemoryMap:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 40h
        mov edi, esp
        mov esi, str_XxMMAPTXT
        movsd
        movsd
        movsd
        movsb
        mov byte [esp], 4Dh
        mov byte [byte esp+01h], 45h
        mov eax, esp
        call NextFreeFileName
        mov esi, dword [MemFreeBytes]
        cmp dword [GraphicsReady], byte 0
        je short .1
        push byte 14h
        lea eax, [byte esp+04h]
        push eax
        call ShowMessageBox
        add esp, byte 8
.1:
        mov edx, str_W_DumpMemoryMap
        mov eax, esp
        call fopen_
        mov dword [MemViewList], eax
        test eax, eax
        jne short .3
        cmp dword [GraphicsReady], byte 0
        je short .2
        push byte 14h
        push str_ErrorDumpingMemoryMap
        call ShowMessageBox
        add esp, byte 8
.2:
        mov dword [MemFreeBytes], esi
        jmp short .4
.3:
        mov dword [MemFreeBytes], esi
        mov esi, esp
        push esi
        push eax
        call WriteMemMap
        add esp, byte 8
        mov eax, dword [MemViewList]
        call fclose_
.4:
        add esp, byte 40h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
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
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; FormatDateTime                               96030  95 PC, medium confidence
; Formats the current DOS date and time as strings
;-----------------------------------------------------------------------------
FormatDateTime:
        push ebx
        push ecx
        push esi
        sub esp, byte 0Ch
        mov ebx, eax
        mov ecx, edx
        mov eax, esp
        call _dos_getdate_
        lea eax, [byte esp+08h]
        call _dos_gettime_
        xor edx, edx
        mov dx, word [byte esp+02h]
        mov esi, 64h
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        push edx
        xor eax, eax
        mov al, byte [byte esp+05h]
        mov edx, dword [nosplit eax*4+MonthNameTable]
        push edx
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        push str_DateTimeFmt
        push ebx
        call sprintf_
        add esp, byte 14h
        xor eax, eax
        mov al, byte [byte esp+0Ah]
        push eax
        xor eax, eax
        mov al, byte [byte esp+0Dh]
        push eax
        xor eax, eax
        mov al, byte [byte esp+010h]
        push eax
        push str_2d02d02d2
        push ecx
        call sprintf_
        add esp, byte 14h
        add esp, byte 0Ch
        pop esi
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; NextFreeFileName                             960AC  95 PC, medium confidence
; Fills in the ?? of a file name pattern with the first number not in use
;-----------------------------------------------------------------------------
NextFreeFileName:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov dword [esp], eax
        xor edi, edi
        cmp byte [eax], 3Fh
        je short .2
.1:
        inc eax
        inc edi
        cmp byte [eax], 3Fh
        jne short .1
.2:
        xor esi, esi
        mov ebp, eax
.3:
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        mov ebx, 0Ah
        idiv ebx
        and eax, 0FFh
        add eax, byte 30h
        mov byte [byte ebp+00h], al
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        xor eax, eax
        mov al, dl
        add eax, byte 30h
        mov byte [byte ebp+01h], al
        mov edx, dword [esp]
        push edx
        call FindFirstFile
        add esp, byte 4
        test eax, eax
        je short .4
        inc esi
        cmp esi, byte 64h
        jl short .3
.4:
        cmp esi, byte 64h
        jl short .5
        add edi, dword [esp]
        mov byte [byte edi+01h], 78h
        mov al, byte [byte edi+01h]
        mov byte [edi], al
.5:
        mov eax, 1
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; DebugGetKeyUpper                                9612C  95 PC, low confidence
; Waits for a key and returns it in upper case
;-----------------------------------------------------------------------------
DebugGetKeyUpper:
        push ebx
        push ecx
        push edx
        call ReturnFalse
        call DebugWaitKey
        mov dword [DebugLastKey], eax
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DebugPressAnyKey                                96144  95 PC, low confidence
; Flushes the keyboard, waits for a key and returns it in upper case
;-----------------------------------------------------------------------------
DebugPressAnyKey:
        push ebx
        push ecx
        push edx
        call ReturnFalse
        call DebugKbdFlush
        call DebugFlushAndWait
        push eax
        call ToUpperChar
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugKbdFlush                                   96164  95 PC, low confidence
; Flushes the keyboard buffer
;-----------------------------------------------------------------------------
DebugKbdFlush:
        push ebx
        push ecx
        push edx
        call KbdFlush
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; DebugFlushAndWait                               96170  95 PC, low confidence
; Flushes the keyboard and waits for a key
;-----------------------------------------------------------------------------
DebugFlushAndWait:
        push ebx
        push ecx
        push edx
        call KbdFlush
.1:
        call DebugGetKeyUpper
        test eax, eax
        je short .1
        pop edx
        pop ecx
        pop ebx
        ret
