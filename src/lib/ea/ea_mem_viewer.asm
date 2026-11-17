; EA debug console: the memory viewer, block list, hex dump and memory map.
bits 32
%include "hockey.inc"
section s_93CB5 progbits alloc exec nowrite align=1
extern _os_handle_0, _os_handle_1, DebugClearScreen, DebugGetKey, DebugKbdFlush, DebugPressAnyKey, DebugPrintf, DebugRow
extern DebugSetAttr, DebugSetLine, DebugSetRow, DebugWaitKey, DefaultFont, DrawFrameClipped, fclose_, FillRect
extern FillRectColor, FindNearestColor, fopen_, FormatDateTime, fprintf_, GraphicsReady, KbdGetKey, MarkDescPurgeable
extern MemDescriptors, MemFreeBytes, memlist0, memlist1, MemMapRulePtr, MemViewAttrFlags, MemViewBlack, MemViewCount
extern MemViewCursor, MemViewerShowArt, MemViewFlags, MemViewGreen, MemViewKey, MemViewList, MemViewMode, MemViewOpen
extern MemViewPrevSel, MemViewRed, MemViewRow, MemViewRowX, MemViewRowY, MemViewSel, MemViewShowDetail, MemViewStrings
extern MemViewTitle, MemViewTop, MemViewWhite, MemViewYellow, NextFreeFileName, PaletteViewer, PrintBoxedText, PushMemDescriptorLocked
extern RestoreDrawState, ReturnFalse, SaveDrawState, SaveScreenshot, SetClipWindow, SetScreenTarget, ShapeViewer, ShowMessageBox
extern sprintf_, StartupCs, StartupDs, str_02x, str_044X00000000, str_04x2, str_1212s9d8s8s, str_33d1212s66x66s66s44x
extern str_80s, str_ALIGNFlagIsSet, str_Asterisk, str_BlockIsPURGABLE, str_CharFmt, str_ConventionalMemory, str_CS44xDS, str_CS44xDS2
extern str_DATES2, str_ErrorDumpingMemoryMap, str_FF, str_FILES2, str_FourSpaces, str_HexmemdspOS, str_HIGHMemoryBlock, str_IDXNAMESIZEADR
extern str_LOWMemoryBlock, str_MemBlockRowFmt, str_MemListRowFmt, str_MEMMANAGER, str_N, str_NAMESIZEADREND, str_NonRelocatableBlock, str_One
extern str_PRIORITY1d, str_RelocatableBlock, str_S_MemViewerDrawList, str_SequenceD, str_SPACE3, str_SPACE66x6, str_SPACE7d66s, str_SPACE9d8s8s
extern str_SPACE9x8s8s, str_SpaceChar, str_StrNewline, str_SYSTEM, str_TIMES3, str_Used66xFree, str_Used7uFree7u, str_W_DumpMemoryMap
extern str_X_DebugSprintf, str_XxMMAPTXT, strncpy_, TextPrintAt, TextRestoreState, TextSaveState, TextSetColors, TextSetFont
extern ToUpperChar, ViewScreenHeight, ViewScreenWidth
global MemViewerGetMode, MemViewer, MemViewerStart, MemViewerListHead, MemViewerDrawRows, MemViewerCountBlocks, MemViewerSelectRow, MemViewerDrawList
global MemPoolTotals, MemViewerDrawTitle, DebugSprintf, MemViewerBlockInfo, MemViewerHexDump, HexDumpRow, WriteMemMap, DumpMemoryMap
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
