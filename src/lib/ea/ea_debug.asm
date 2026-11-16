; The EA debug console.
bits 32
%include "hockey.inc"
section s_93938 progbits alloc exec nowrite align=1
extern _dos_getdate_, _dos_gettime_, _os_handle, _os_handle_0, _os_handle_1, str_DBUGTXT, str_FILES, str_DATES
extern str_TIMES, str_CLOSED, str_TIMES2, asc_C4080, str_2d02d02d, str_CS44xDS, str_CS44xDS2, str_Used66xFree
extern str_Used7uFree7u, str_NAMESIZEADREND, str_IDXNAMESIZEADR, str_80s, asc_C4200, str_S_MemViewerDrawList, str_SPACE9x8s8s, str_SPACE9d8s8s
extern str_SPACE66x6, str_SPACE7d66s, asc_C428C, str_1212s9d8s8s, str_33d1212s66x66s66s44x, asc_C42E4, str_MEMMANAGER, str_044X00000000
extern str_SYSTEM, str_SPACE3, str_HIGHMemoryBlock, str_LOWMemoryBlock, str_ConventionalMemory, str_RelocatableBlock, str_NonRelocatableBlock, str_ALIGNFlagIsSet
extern str_PRIORITY1d, str_SequenceD, str_BlockIsPURGABLE, str_04x2, str_02x, asc_C441C, str_FILES2, str_DATES2
extern str_TIMES3, str_HexmemdspOS, str_XxMMAPTXT, str_ErrorDumpingMemoryMap, str_ShapeFileIsInvalid, str_NumDPackedD, str_ThereAreNoShapes, str_44s05x
extern str_Bad, str_CxCy3d3d, str_NotDrawn, str_Bytes3dRows3d, str_Spacked, str_Packed, str_Unpacked, str_3d3d3d3dS
extern str_ShapeIsInvalidDraw, str_MEMSHPTXT, str_ErrorDumpingShapesList, str_ShapeFileName0, str_ShapeFileSizeLd, str_NumberOfShapesD, str_44s66ld, str_Bytes3dRows3d2
extern str_XY3d3d, str_033d022X, str_R022d, str_G022d, str_B022d, asc_C46F8, str_SCREEN2, asc_C470C
extern str_2d02d02d2, DebugRow, byte_EDE7D, DebugPrintf, dword_D2F78, dword_D2F7A, dword_D2F80, GraphicsReady
extern dword_D3044, dword_D3048, DebugMode, DebugLogOn, MemViewBlack, MemViewWhite, MemViewYellow, MemViewGreen
extern MemViewRed, MemViewShowDetail, dword_D4594, dword_D4598, dword_D459C, dword_D45A0, dword_D45A4, dword_D45B0
extern dword_EDAB4, MemViewTop, MemViewCount, dword_EDE68, MemViewTitle, MemViewRow, MemViewList, dword_EDE78
extern dword_EDE7C, MemViewMode, dword_EDE84, fclose_, fopen_, fprintf_, fputs_, j___fprtf_
extern memlist0, memlist1, SetTickDeadline, sprintf_, strncpy_, PushMemDescriptorLocked, sub_8D484, TextSetColors
extern TextSaveState, TextRestoreState, TextSetFont, SetPalette, ShapeBankCount, ShapeBankEntry, ShapeBankEntryId, PutBlock
extern DrawBitmap, FillRect, TextPrintAt, XorRectOutline, sub_93000, PrintBoxedText, DebugSetLine, sub_936C0
extern DebugClearScreen, DebugSetRow, DebugSetAttr, ShowMessageBox, ToUpperChar, ReturnFalse, sub_9C5B0, sub_9C890
extern DrawArtAnyFormatAt, DrawArtAnyFormatOwnPos, sub_9D090, sub_9D2E0, FindShape, ClearScreen, KbdGetKey, KbdFlush
extern SaveDrawState, RestoreDrawState, FindFirstFile, PollHotkeys, VgaSetPalette, SetScreenTarget, SetClipWindow, FillRectColor
extern str_Wt2, unk_C40A0, str_Fs, str_Jan2, str_Feb3, str_Mar2, str_Apr2, str_May3
extern str_Jun2, str_Jul2, str_Aug2, str_Sep2, str_Oct2, str_Nov2, str_Dec2, unk_C41F0
extern MemViewStrings, str_X_DebugSprintf, unk_C433C, unk_C4414, unk_C4418, unk_C4448, str_FF, str_W_DumpMemoryMap
extern str_Un, unk_C46C0, DefaultFont, vsprintf_, WaitTickDeadline
global sub_93938, loc_93955, loc_9396D, loc_9399A, loc_939AA, loc_939C2, loc_93A2E, loc_93A33
global sub_93A40, loc_93A9B, DebugLog, loc_93AD3, sub_93AD8, loc_93B26, loc_93B2D, FindWildcardDigits
global loc_93B49, loc_93B55, loc_93B66, loc_93B6A, loc_93B6C, loc_93BA5, loc_93BC5, loc_93BCA
global FormatDateStamp, unk_93C50, unk_93C54, sub_93C88, DebugGetKey, sub_93CB8, sub_93CC0, loc_93D22
global loc_93DA5, loc_93DE2, loc_93E09, loc_93E26, loc_93E28, sub_93E38, MemViewerListHead, loc_93E70
global sub_93E79, loc_93E88, loc_93E9A, loc_93EB1, loc_93EBF, loc_93EC1, loc_93EDC, loc_93EE1
global loc_93EF1, loc_93F0D, loc_93F21, loc_93F2E, loc_93F3A, loc_93F56, loc_93F60, loc_93F6A
global loc_93F6F, loc_93F8E, loc_93FB0, loc_93FBA, loc_93FCB, loc_93FE1, loc_93FEE, loc_93FFB
global loc_9401B, loc_9405B, loc_9406D, loc_94075, loc_94082, loc_940BA, sub_940F4, loc_94105
global loc_9410D, MemViewerSelectRow, loc_94124, loc_9412C, loc_9416D, loc_94181, MemViewerDrawList, loc_941DF
global loc_941E4, loc_9420D, loc_94212, loc_94316, loc_9439B, loc_943EE, loc_943FC, loc_94488
global loc_9448D, loc_944D4, loc_944ED, loc_944F2, loc_94534, loc_94551, loc_94552, loc_94594
global loc_945D3, loc_945D8, loc_94624, loc_94649, loc_9464E, loc_946A0, loc_946C0, loc_946CB
global loc_946FB, loc_94710, loc_94729, loc_94753, loc_9476E, MemPoolTotals, loc_947A7, loc_947B9
global loc_947C1, loc_947CA, MemViewerDrawTitle, loc_9485F, loc_948B7, loc_948B9, loc_948C7, DebugSprintf
global MemViewerBlockInfo, loc_94987, loc_949A4, loc_949BF, loc_94A1D, loc_94A54, loc_94A5E, loc_94A86
global loc_94A8D, loc_94AC6, loc_94ACD, loc_94AFA, loc_94B20, loc_94B57, loc_94B62, MemViewerHexDump
global loc_94B85, loc_94B9A, loc_94BBC, loc_94BD3, loc_94BDE, loc_94C1A, loc_94C49, loc_94C51
global loc_94C61, loc_94C6F, loc_94C71, loc_94C89, loc_94C95, loc_94CA5, loc_94CA7, loc_94CB1
global loc_94CC1, loc_94CC9, loc_94CCF, loc_94CE3, loc_94CF3, loc_94D00, loc_94D1F, loc_94D2C
global loc_94D44, loc_94D5C, loc_94D91, loc_94DA8, loc_94DC1, loc_94DD6, loc_94DE5, loc_94DEC
global loc_94DFC, loc_94E06, loc_94E18, loc_94E1E, loc_94E29, HexDumpRow, loc_94E68, loc_94E7C
global loc_94E91, loc_94ECB, loc_94EDF, loc_94EF9, loc_94F16, loc_94F31, loc_94F40, loc_94F91
global loc_94F98, loc_94FB0, WriteMemMap, loc_9506F, loc_95074, loc_950A3, DumpMemoryMap, loc_950ED
global loc_9511A, loc_95122, loc_9513E, sub_95148, ShapeViewer, loc_951B1, loc_951FD, loc_95210
global loc_95228, loc_95245, loc_95249, loc_95250, loc_9528A, loc_95297, loc_9529E, loc_952A5
global loc_952B4, loc_95384, loc_95391, loc_953A0, loc_953A6, loc_953A9, loc_953B3, loc_953CC
global loc_95401, loc_9540C, loc_9541E, loc_95427, loc_95436, loc_9544E, loc_9545B, loc_95464
global loc_95476, loc_9547F, loc_95493, loc_9549D, loc_954AB, loc_954B5, loc_954C0, ReadShapeFileHeader
global ShapeInfo, loc_9559A, loc_9559F, loc_955C0, loc_955C5, loc_95665, loc_956AC, loc_956B3
global loc_956B8, DumpShapesList, loc_9576B, loc_9585D, loc_9590C, loc_95911, loc_95937, loc_95955
global loc_9595F, PaletteViewer, loc_959D4, loc_959E7, loc_95A92, loc_95AD4, loc_95AE3, loc_95B03
global loc_95B05, loc_95B17, loc_95B35, loc_95B47, loc_95B67, loc_95B69, loc_95B7B, loc_95B97
global loc_95B99, loc_95BAB, loc_95BC7, loc_95BC9, loc_95BDB, loc_95BF5, loc_95C07, loc_95C11
global loc_95C16, loc_95C26, loc_95C28, loc_95C3C, loc_95C3E, loc_95C51, loc_95C62, loc_95C75
global loc_95C86, loc_95C91, loc_95C98, loc_95CA3, loc_95CAA, loc_95CF0, loc_95D5D, PaletteViewerLabel
global loc_95EF1, SaveScreenshot, MemViewerShowArt, loc_95FE7, loc_95FF4, loc_96000, loc_96006, loc_96009
global loc_96010, loc_96026, loc_9602A, FormatDateTime, NextFreeFileName, loc_960BF, loc_960C6, loc_960CA
global loc_9610C, loc_9611D, sub_9612C, sub_96144, sub_96164, sub_96170, loc_96178
sub_93938:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 0B0h
        cmp dword [DebugLogOn], byte 0
        jne near loc_93A33
        mov esi, eax
        mov edi, esp
        push edi
loc_93955:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short loc_9396D
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short loc_93955
loc_9396D:
        pop edi
        mov edi, esp
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        test cx, cx
        jle short loc_9399A
        movsx eax, cx
        mov dl, byte [byte esp+eax-01h]
        cmp dl, 5Ch
        je short loc_9399A
        cmp dl, 3Ah
        je short loc_9399A
        mov byte [esp+eax], 5Ch
        xor bh, bh
        mov byte [byte esp+eax+01h], bh
loc_9399A:
        mov esi, str_DBUGTXT
        mov edi, esp
        push edi
        LD sub, ecx, ecx
        dec ecx
        mov al, 0
        repne scasb
        dec edi
loc_939AA:
        mov al, byte [esi]
        mov byte [edi], al
        cmp al, 0
        je short loc_939C2
        mov al, byte [byte esi+01h]
        add esi, byte 2
        mov byte [byte edi+01h], al
        add edi, byte 2
        cmp al, 0
        jne short loc_939AA
loc_939C2:
        pop edi
        mov eax, esp
        call FindWildcardDigits
        mov edx, str_Wt2
        mov eax, esp
        call fopen_
        mov dword [DebugLogOn], eax
        test eax, eax
        je short loc_93A2E
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
        jmp short loc_93A33
loc_93A2E:
        call fclose_
loc_93A33:
        add esp, 0B0h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
sub_93A40:
        push ebx
        push ecx
        push edx
        sub esp, byte 28h
        cmp dword [DebugLogOn], byte 0
        je short loc_93A9B
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
loc_93A9B:
        add esp, byte 28h
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
DebugLog:
        sub esp, byte 4
        cmp dword [DebugMode], byte 2
        jl short loc_93AD3
        mov ebx, dword [DebugLogOn]
        test ebx, ebx
        je short loc_93AD3
        lea eax, [byte esp+0Ch]
        mov dword [esp], eax
        mov eax, ebx
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        call j___fprtf_
        xor ecx, ecx
        mov dword [esp], ecx
loc_93AD3:
        add esp, byte 4
        ret
        db 090h
sub_93AD8:
        sub esp, 104h
        cmp dword [DebugMode], byte 2
        jl short loc_93B2D
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
        je short loc_93B26
        mov edx, ecx
        mov eax, esp
        call fputs_
loc_93B26:
        mov eax, esp
        call sub_936C0
loc_93B2D:
        add esp, 104h
        ret
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
        je short loc_93B55
loc_93B49:
        cmp byte [esi], 0
        je short loc_93B55
        inc esi
        inc edi
        cmp byte [esi], 3Fh
        jne short loc_93B49
loc_93B55:
        mov ebp, dword [esp]
        add ebp, edi
        cmp byte [byte ebp+00h], 0
        je short loc_93B66
        cmp byte [byte ebp+01h], 3Fh
        je short loc_93B6A
loc_93B66:
        xor eax, eax
        jmp short loc_93BCA
loc_93B6A:
        xor esi, esi
loc_93B6C:
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
        je short loc_93BA5
        inc esi
        cmp esi, byte 64h
        jl short loc_93B6C
loc_93BA5:
        cmp esi, byte 64h
        jl short loc_93BC5
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
loc_93BC5:
        mov eax, 1
loc_93BCA:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
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
        push asc_C4080
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
unk_93C50:
        dd unk_C40A0
unk_93C54:
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
sub_93C88:
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
sub_93CB8:
        mov eax, dword [dword_D4594]
        lea eax, [byte eax+00h]
sub_93CC0:
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
        jne short loc_93D22
        mov dword [dword esp+0B8h], 1
loc_93D22:
        push byte 0
        call sub_9C5B0
        add esp, byte 4
        mov dword [MemViewBlack], eax
        push dword 0FCFCFCh
        call sub_9C5B0
        add esp, byte 4
        mov dword [MemViewWhite], eax
        push dword 0FCFC54h
        call sub_9C5B0
        add esp, byte 4
        mov dword [MemViewYellow], eax
        push dword 80A8h
        call sub_9C5B0
        add esp, byte 4
        mov dword [MemViewGreen], eax
        push dword 0A80000h
        call sub_9C5B0
        add esp, byte 4
        mov dword [MemViewRed], eax
        mov ebp, dword [dword_D459C]
        mov edi, dword [dword_D45A0]
        cmp dword [dword esp+0B8h], byte 0
        sete al
        and eax, 0FFh
        mov dword [dword esp+0B0h], eax
        xor esi, esi
        mov dword [dword esp+0BCh], esi
loc_93DA5:
        mov eax, dword [dword_D4594]
        mov ebx, dword [dword esp+0B8h]
        cmp eax, ebx
        je short loc_93DE2
        mov dword [dword_D459C], ebp
        mov dword [dword_D45A0], edi
        mov dword [dword_D4594], ebx
        cmp dword [dword esp+0B0h], byte 0
        jne short loc_93DE2
        test ebx, ebx
        sete al
        and eax, 0FFh
        mov dword [dword esp+0B0h], eax
loc_93DE2:
        call sub_940F4
        mov ecx, dword [dword esp+0B8h]
        mov ebx, eax
        mov edx, ebp
        mov eax, edi
        call MemViewerDrawList
        mov dword [dword esp+0B4h], eax
        lea edx, [byte ebp+014h]
        cmp edx, eax
        jle short loc_93E09
        mov edx, eax
loc_93E09:
        call sub_93C88
        mov esi, eax
        test eax, eax
        je short loc_93E09
        cmp eax, 4900h
        jne short loc_93E28
        cmp edi, ebp
        jne short loc_93E26
        test ebp, ebp
        jle short loc_93E26
        sub ebp, byte 15h
loc_93E26:
        mov edi, ebp
loc_93E28:
        cmp esi, 5100h
        jne short loc_93E88
        cmp edi, edx
        je short sub_93E79
        mov edi, edx
        jmp short loc_93E88
sub_93E38:
        mov edx, 1
        mov dword [dword_D4594], edx
        mov eax, edx
        jmp near sub_93CC0
        db 08Bh,0C0h
MemViewerListHead:
        push ebx
        push edx
        mov ebx, eax
        mov edx, dword [dword_D4598]
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        shl eax, 2
        cmp ebx, byte 1
        jne short loc_93E70
        mov eax, dword [dword eax+memlist1]
        pop edx
        pop ebx
        ret
loc_93E70:
        mov eax, dword [dword eax+memlist0]
        pop edx
        pop ebx
        ret
sub_93E79:
        cmp edx, dword [dword esp+0B4h]
        jge short loc_93E88
        add ebp, byte 15h
        lea edi, [byte edx+015h]
loc_93E88:
        cmp esi, 4800h
        jne short loc_93E9A
        test edi, edi
        jle short loc_93E9A
        dec edi
        cmp edi, ebp
        jge short loc_93E9A
        dec ebp
loc_93E9A:
        cmp esi, 5000h
        jne short loc_93EB1
        cmp edi, dword [dword esp+0B4h]
        jge short loc_93EB1
        inc edi
        cmp edi, edx
        jle short loc_93EB1
        inc ebp
loc_93EB1:
        cmp esi, 4700h
        jne short loc_93EC1
        cmp edi, ebp
        jne short loc_93EBF
        xor ebp, ebp
loc_93EBF:
        mov edi, ebp
loc_93EC1:
        cmp esi, 4F00h
        jne short loc_93EE1
        mov ecx, dword [dword esp+0B4h]
        cmp edi, ecx
        je short loc_93EE1
        cmp edi, edx
        je short loc_93EDC
        mov edi, edx
        jmp short loc_93EE1
loc_93EDC:
        lea ebp, [byte ecx-014h]
        mov edi, ecx
loc_93EE1:
        cmp esi, byte 1Bh
        jne short loc_93EF1
        mov dword [dword esp+0BCh], 1
loc_93EF1:
        cmp esi, byte 0Dh
        jne short loc_93F0D
        mov edx, dword [dword_EDE84]
        mov eax, dword [dword_EDE68]
        mov ebx, dword [dword esp+0B8h]
        call MemViewerHexDump
loc_93F0D:
        cmp esi, byte 43h
        jne short loc_93F21
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
loc_93F21:
        cmp esi, byte 46h
        jne short loc_93F2E
        xor edx, edx
        mov dword [dword_EDAB4], edx
loc_93F2E:
        cmp esi, byte 44h
        jne short loc_93F3A
        xor byte [MemViewShowDetail], 1
loc_93F3A:
        cmp esi, byte 42h
        jne short loc_93F56
        mov edx, dword [dword_EDE78]
        mov eax, dword [dword_EDE7C]
        mov ebx, dword [dword esp+0B8h]
        call MemViewerBlockInfo
loc_93F56:
        cmp esi, byte 4Dh
        jne short loc_93F60
        call DebugClearScreen
loc_93F60:
        cmp esi, byte 50h
        je short loc_93F6A
        cmp esi, byte 20h
        jne short loc_93F6F
loc_93F6A:
        call DumpMemoryMap
loc_93F6F:
        cmp esi, byte 53h
        je short loc_93F8E
        cmp esi, byte 5Bh
        je short loc_93F8E
        cmp esi, byte 5Dh
        je short loc_93F8E
        cmp esi, 4B00h
        je short loc_93F8E
        cmp esi, 4D00h
        jne short loc_93FB0
loc_93F8E:
        test byte [byte_EDE7D], 80h
        jne short loc_93FB0
        mov edx, dword [dword_EDE84]
        mov eax, dword [dword_EDE68]
        mov ecx, esi
        mov ebx, dword [dword esp+0B8h]
        call ShapeViewer
loc_93FB0:
        cmp esi, byte 56h
        jne short loc_93FBA
        call SaveScreenshot
loc_93FBA:
        cmp esi, byte 54h
        jne short loc_93FCB
        mov eax, dword [dword esp+0B8h]
        call PaletteViewer
loc_93FCB:
        cmp esi, byte 57h
        jne short loc_93FE1
        mov eax, dword [dword_EDE68]
        mov edx, dword [dword esp+0B8h]
        call MemViewerShowArt
loc_93FE1:
        cmp esi, byte 41h
        jne short loc_93FEE
        xor byte [dword esp+0B8h], 1
loc_93FEE:
        cmp esi, byte 9
        jne short loc_93FFB
        xor byte [dword esp+0B8h], 1
loc_93FFB:
        cmp esi, 5300h
        jne short loc_9401B
        test byte [byte_EDE7D], 80h
        jne short loc_9401B
        mov ebx, dword [MemViewMode]
        push ebx
        call PushMemDescriptorLocked
        add esp, byte 4
loc_9401B:
        cmp esi, 5200h
        jne short loc_9405B
        test byte [byte_EDE7D], 80h
        jne short loc_9405B
        mov edx, dword [MemViewCount]
        mov ebx, 0Ch
        lea eax, [dword esp+0A0h]
        call strncpy_
        xor ch, ch
        mov byte [dword esp+0ACh], ch
        mov ecx, dword [MemViewMode]
        push ecx
        call sub_8D484
        add esp, byte 4
loc_9405B:
        mov esi, dword [dword esp+0B4h]
        cmp ebp, esi
        jle short loc_9406D
        mov edi, esi
        sub ebp, byte 15h
        jmp short loc_94075
loc_9406D:
        test ebp, ebp
        jge short loc_94075
        xor ebp, ebp
        xor edi, edi
loc_94075:
        mov eax, dword [dword esp+0B4h]
        cmp edi, eax
        jle short loc_94082
        mov edi, eax
loc_94082:
        cmp dword [dword esp+0BCh], byte 0
        je near loc_93DA5
        mov dword [dword_D459C], ebp
        mov dword [dword_D45A0], edi
        call sub_96164
        cmp dword [dword esp+0B0h], byte 0
        je short loc_940BA
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
loc_940BA:
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
sub_940F4:
        push edx
        xor edx, edx
        mov eax, 1
        call MemViewerListHead
        test eax, eax
        je short loc_9410D
loc_94105:
        mov eax, dword [byte eax+020h]
        inc edx
        test eax, eax
        jne short loc_94105
loc_9410D:
        lea eax, [byte edx+01h]
        pop edx
        ret
        db 08Bh,0C0h
MemViewerSelectRow:
        cmp edx, byte 2
        je short loc_94181
        cmp eax, ebx
        jl short loc_94124
        add ebx, byte 15h
        cmp eax, ebx
        jl short loc_9412C
loc_94124:
        mov eax, 1
        ret 10h
loc_9412C:
        cmp eax, ecx
        jne short loc_9416D
        mov eax, dword [MemViewWhite]
        mov dword [MemViewRow], eax
        mov dword [MemViewTop], 70h
        mov eax, dword [byte esp+04h]
        mov dword [dword_EDE68], eax
        mov eax, dword [byte esp+08h]
        mov dword [dword_EDE84], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [dword_EDE7C], eax
        mov eax, dword [byte esp+010h]
        mov dword [dword_EDE78], eax
        xor eax, eax
        ret 10h
loc_9416D:
        mov eax, dword [MemViewBlack]
        mov dword [MemViewRow], eax
        mov dword [MemViewTop], 7
loc_94181:
        xor eax, eax
        ret 10h
        db 08Bh,0C0h
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
        mov ebx, dword [dword_EDAB4]
        push ebx
        mov ecx, dword [dword_D2F7A]
        push ecx
        mov esi, dword [dword_D2F78]
        push esi
        cmp dword [MemViewShowDetail], byte 0
        je short loc_941DF
        mov eax, str_CS44xDS
        jmp short loc_941E4
loc_941DF:
        mov eax, str_CS44xDS2
loc_941E4:
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
        je short loc_9420D
        mov eax, str_Used66xFree
        jmp short loc_94212
loc_9420D:
        mov eax, str_Used7uFree7u
loc_94212:
        push eax
        lea eax, [dword ebp-082h]
        push eax
        call sprintf_
        add esp, byte 14h
        cmp dword [byte ebp+07Eh], byte 0
        jne near loc_94316
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
        mov edx, dword [dword_D3044]
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
        mov ecx, dword [dword_D3044]
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
        mov edi, dword [dword_D3044]
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
        mov edx, dword [dword_D3044]
        push edx
        push byte 1Ah
        push byte 0
        call FillRect
        add esp, byte 14h
        call ReturnFalse
        jmp near loc_943EE
loc_94316:
        mov ecx, 0Bh
        lea edi, [dword ebp-0D6h]
        mov esi, str_IDXNAMESIZEADR
        rep movsd
        mov edi, dword [byte ebp+07Eh]
        cmp edi, byte 1
        jne short loc_9439B
        push byte 0Bh
        push unk_C41F0
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
        jmp short loc_943EE
loc_9439B:
        cmp edi, byte 2
        jne short loc_943EE
        lea eax, [byte ebp-02Eh]
        push eax
        push asc_C4200
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
        lea eax, [dword ebp-082h]
        push eax
        push asc_C4200
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
loc_943EE:
        xor esi, esi
        xor edi, edi
        cmp dword [byte ebp+06Eh], byte 0
        jle near loc_946CB
loc_943FC:
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
        je near loc_94552
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
        jne near loc_94551
        lea edx, [byte ebp+032h]
        mov eax, dword [byte ebp+056h]
        call DebugSprintf
        lea edx, [byte ebp+026h]
        mov eax, dword [byte ebp+03Eh]
        call DebugSprintf
        mov eax, dword [byte ebp+03Eh]
        sub eax, dword [byte ebp+056h]
        cmp dword [byte ebp+07Eh], byte 0
        jne short loc_944D4
        lea edx, [byte ebp+026h]
        push edx
        lea edx, [byte ebp+032h]
        push edx
        push eax
        cmp dword [MemViewShowDetail], byte 0
        je short loc_94488
        mov eax, str_SPACE9x8s8s
        jmp short loc_9448D
loc_94488:
        mov eax, str_SPACE9d8s8s
loc_9448D:
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
        jmp near loc_94551
loc_944D4:
        lea edx, [byte ebp+026h]
        push edx
        lea edx, [byte ebp+032h]
        push edx
        push eax
        cmp dword [MemViewShowDetail], byte 0
        je short loc_944ED
        mov eax, str_SPACE66x6
        jmp short loc_944F2
loc_944ED:
        mov eax, str_SPACE7d66s
loc_944F2:
        push eax
        lea eax, [byte ebp-02Eh]
        push eax
        call sprintf_
        add esp, byte 14h
        mov ecx, dword [byte ebp+07Eh]
        cmp ecx, byte 1
        jne short loc_94534
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
        jmp short loc_94551
loc_94534:
        cmp ecx, byte 2
        jne short loc_94551
        lea eax, [byte ebp-02Eh]
        push eax
        push asc_C4200
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
loc_94551:
        inc esi
loc_94552:
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
        jne near loc_946C0
        cmp esi, dword [byte ebp+076h]
        jne short loc_94594
        mov eax, dword [MemViewTitle]
        mov eax, dword [byte eax+024h]
        mov dword [MemViewMode], eax
        add eax, byte 4
        mov dword [MemViewCount], eax
loc_94594:
        lea edx, [byte ebp+032h]
        mov eax, dword [byte ebp+03Eh]
        call DebugSprintf
        mov eax, dword [byte ebp+03Eh]
        add eax, dword [byte ebp+04Eh]
        lea edx, [byte ebp+026h]
        call DebugSprintf
        cmp dword [byte ebp+07Eh], byte 0
        jne short loc_94624
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+032h]
        push eax
        mov eax, dword [byte ebp+04Ah]
        push eax
        mov edx, dword [byte ebp+052h]
        push edx
        cmp dword [MemViewShowDetail], byte 0
        je short loc_945D3
        mov eax, asc_C428C
        jmp short loc_945D8
loc_945D3:
        mov eax, str_1212s9d8s8s
loc_945D8:
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
        jmp near loc_946C0
loc_94624:
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
        je short loc_94649
        mov eax, str_33d1212s66x66s66s44x
        jmp short loc_9464E
loc_94649:
        mov eax, asc_C42E4
loc_9464E:
        push eax
        lea eax, [dword ebp-082h]
        push eax
        call sprintf_
        add esp, byte 20h
        mov ecx, dword [byte ebp+07Eh]
        cmp ecx, byte 1
        jne short loc_946A0
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
        jmp short loc_946C0
loc_946A0:
        cmp ecx, byte 2
        jne short loc_946C0
        lea eax, [dword ebp-082h]
        push eax
        push asc_C4200
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
loc_946C0:
        inc esi
        inc edi
        cmp edi, dword [byte ebp+06Eh]
        jl near loc_943FC
loc_946CB:
        mov eax, dword [byte ebp+07Ah]
        add eax, byte 15h
        mov dword [byte ebp+06Ah], eax
        mov edi, dword [byte ebp+07Eh]
        test edi, edi
        jne short loc_94729
        cmp esi, eax
        jge short loc_946FB
        mov eax, dword [dword_D3048]
        push eax
        mov eax, esi
        sub eax, dword [byte ebp+07Ah]
        shl eax, 3
        add eax, byte 1Ch
        push eax
        mov ebx, dword [dword_D3044]
        push ebx
        push edi
        jmp short loc_94710
loc_946FB:
        mov ecx, dword [dword_D3048]
        push ecx
        push dword 0C4h
        mov edi, dword [dword_D3044]
        push edi
        push byte 0
loc_94710:
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [MemViewBlack]
        call DebugGetKey
        call SetScreenTarget
        jmp short loc_9476E
loc_94729:
        cmp edi, byte 1
        jne short loc_9476E
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
        jge short loc_9476E
loc_94753:
        push MemViewStrings
        push str_80s
        push edi
        push byte 0
        call DebugSetLine
        add esp, byte 10h
        inc edi
        cmp edi, dword [byte ebp+072h]
        jl short loc_94753
loc_9476E:
        lea eax, [byte esi-01h]
        lea esp, [dword ebp+082h]
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
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
        je short loc_947CA
loc_947A7:
        mov edx, dword [eax]
        sub edx, dword [ebx]
        sub edx, dword [byte ebx+010h]
        test byte [byte eax+019h], 80h
        jne short loc_947B9
        mov ebx, dword [byte eax+010h]
        add dword [edi], ebx
loc_947B9:
        add dword [esi], edx
        cmp edx, dword [ecx]
        jbe short loc_947C1
        mov dword [ecx], edx
loc_947C1:
        mov ebx, eax
        mov eax, dword [byte eax+020h]
        test eax, eax
        jne short loc_947A7
loc_947CA:
        mov eax, dword [edi]
        mov ecx, dword [esi]
        add eax, ecx
        mov dword [byte ebp+00h], eax
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
MemViewerDrawTitle:
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov eax, edx
        mov esi, ebx
        mov edi, ecx
        test ebp, ebp
        jne short loc_9485F
        mov dword [edx], str_MEMMANAGER
        mov ebp, dword [dword_D2F80]
        push ebp
        call _os_handle_0
        add esp, byte 4
        mov dword [esi], eax
        mov ebp, dword [dword_D4598]
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
        mov edx, dword [dword_D4598]
        lea eax, [nosplit edx*4+00h]
        add eax, edx
        mov eax, dword [nosplit eax*4+memlist1]
        jmp short loc_948C7
loc_9485F:
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
        jle short loc_948B7
        mov esi, dword [byte eax+024h]
        mov ecx, dword [esi]
        push ecx
        call _os_handle_0
        add esp, byte 4
        mov edx, dword [byte esi+010h]
        add eax, edx
        jmp short loc_948B9
loc_948B7:
        mov eax, dword [esi]
loc_948B9:
        mov edx, dword [byte esp+01Ch]
        mov dword [edx], eax
        mov eax, dword [MemViewTitle]
        mov eax, dword [byte eax+020h]
loc_948C7:
        mov dword [MemViewTitle], eax
        pop ebp
        pop edi
        pop esi
        ret 10h
        db 08Bh,0C0h
DebugSprintf:
        push eax
        push str_X_DebugSprintf
        push edx
        call sprintf_
        add esp, byte 0Ch
        ret
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
        call sub_93000
        add esp, byte 14h
        mov ebx, dword [MemViewRed]
        push ebx
        push dword 0A3h
        push dword 110h
        push byte 38h
        push byte 2Fh
        call sub_93000
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
loc_94987:
        test ebp, 1
        je short loc_949A4
        push byte 3Dh
        push edi
        push unk_C433C
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
loc_949A4:
        sar ebp, 1
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        mov ebx, 4
        idiv ebx
        sub edi, byte 8
        cmp edx, byte 3
        jne short loc_949BF
        sub edi, byte 8
loc_949BF:
        inc esi
        cmp esi, byte 10h
        jl short loc_94987
        mov eax, dword [MemViewRed]
        push eax
        mov edx, dword [MemViewBlack]
        push edx
        call TextSetColors
        add esp, byte 8
        mov edi, 50h
        mov esi, 4Dh
        test byte [byte esp+09h], 80h
        je short loc_94A1D
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
loc_94A1D:
        test byte [byte esp+09h], 20h
        je short loc_94A54
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
loc_94A54:
        test byte [byte esp+09h], 0A0h
        je short loc_94A5E
        add esi, byte 8
loc_94A5E:
        mov ebp, dword [MemViewBlack]
        push ebp
        mov eax, dword [MemViewWhite]
        push eax
        call TextSetColors
        add esp, byte 8
        lea ebp, [byte esi+0Ah]
        test byte [byte esp+08h], 20h
        je short loc_94A86
        push esi
        push edi
        push str_HIGHMemoryBlock
        jmp short loc_94A8D
loc_94A86:
        push esi
        push edi
        push str_LOWMemoryBlock
loc_94A8D:
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
        je short loc_94AC6
        push esi
        push edi
        push str_RelocatableBlock
        jmp short loc_94ACD
loc_94AC6:
        push esi
        push edi
        push str_NonRelocatableBlock
loc_94ACD:
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        mov esi, ebp
        test byte [byte esp+08h], 40h
        je short loc_94AFA
        push esi
        push edi
        push str_ALIGNFlagIsSet
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
        add esi, byte 0Ah
loc_94AFA:
        test byte [byte esp+08h], 0Fh
        je short loc_94B20
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
loc_94B20:
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
        je short loc_94B57
        push esi
        push edi
        push str_BlockIsPURGABLE
        call TextPrintAt
        add esp, byte 0Ch
        call ReturnFalse
loc_94B57:
        cmp dword [esp], byte 0
        jne short loc_94B62
        call sub_96144
loc_94B62:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 08Bh,0C0h
MemViewerHexDump:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        mov dword [byte esp+08h], eax
        test edx, edx
        jne short loc_94B85
        call DebugClearScreen
        jmp near loc_94E29
loc_94B85:
        mov eax, edx
        shr eax, 4
        mov dword [byte esp+024h], eax
        test dl, 0Fh
        je short loc_94B9A
        lea edx, [byte eax+01h]
        mov dword [byte esp+024h], edx
loc_94B9A:
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
loc_94BBC:
        mov eax, dword [byte esp+024h]
        sub eax, esi
        mov dword [byte esp+02Ch], eax
        cmp eax, byte 19h
        jle short loc_94BD3
        mov dword [byte esp+02Ch], 19h
loc_94BD3:
        mov eax, dword [byte esp+02Ch]
        cmp edi, eax
        jl short loc_94BDE
        lea edi, [byte eax-01h]
loc_94BDE:
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
loc_94C1A:
        call KbdGetKey
        mov dword [byte esp+030h], eax
        push eax
        call ToUpperChar
        add esp, byte 4
        mov edx, eax
        test eax, eax
        je short loc_94C1A
        xor ebx, ebx
        mov dword [esp], ebx
        cmp eax, byte 1Bh
        jne short loc_94C51
        cmp dword [byte esp+028h], byte 0
        je short loc_94C49
        mov dword [byte esp+028h], ebx
        jmp short loc_94C51
loc_94C49:
        mov dword [byte esp+018h], 1
loc_94C51:
        cmp edx, 4900h
        jne short loc_94C71
        test edi, edi
        je short loc_94C61
        xor edi, edi
        jmp short loc_94C71
loc_94C61:
        test esi, esi
        jbe short loc_94C71
        cmp esi, byte 19h
        jbe short loc_94C6F
        sub esi, byte 19h
        jmp short loc_94C71
loc_94C6F:
        xor esi, esi
loc_94C71:
        cmp edx, 5100h
        jne short loc_94C95
        mov eax, dword [byte esp+02Ch]
        dec eax
        cmp edi, eax
        je short loc_94C89
        mov edi, 18h
        jmp short loc_94C95
loc_94C89:
        lea eax, [byte esi+019h]
        cmp eax, dword [byte esp+024h]
        jae short loc_94C95
        add esi, byte 19h
loc_94C95:
        cmp edx, 4800h
        je short loc_94CA5
        cmp edx, 5000h
        jne short loc_94CA7
loc_94CA5:
        mov ebx, edx
loc_94CA7:
        cmp edx, byte 8
        jne short loc_94CB1
        mov ebx, 4B00h
loc_94CB1:
        cmp edx, 4700h
        jne short loc_94CCF
        test ebp, ebp
        je short loc_94CC1
        xor ebp, ebp
        jmp short loc_94CCF
loc_94CC1:
        test edi, edi
        je short loc_94CC9
        xor edi, edi
        jmp short loc_94CCF
loc_94CC9:
        test esi, esi
        je short loc_94CCF
        xor esi, esi
loc_94CCF:
        cmp edx, 4F00h
        jne short loc_94D00
        cmp ebp, byte 0Fh
        je short loc_94CE3
        mov ebp, 0Fh
        jmp short loc_94D00
loc_94CE3:
        mov eax, dword [byte esp+02Ch]
        dec eax
        cmp edi, eax
        je short loc_94CF3
        mov edi, 18h
        jmp short loc_94D00
loc_94CF3:
        lea eax, [byte esi+018h]
        cmp eax, dword [byte esp+024h]
        jae short loc_94D00
        mov esi, dword [byte esp+04h]
loc_94D00:
        cmp dword [byte esp+028h], byte 1
        jne short loc_94D1F
        mov ebx, dword [byte esp+01Ch]
        add ebx, ebp
        mov eax, edi
        shl eax, 4
        add eax, ebx
        mov bl, byte [byte esp+030h]
        mov byte [eax], bl
        mov ebx, 4D00h
loc_94D1F:
        cmp edx, byte 4Dh
        jne short loc_94D2C
        mov dword [byte esp+028h], 1
loc_94D2C:
        cmp edx, byte 30h
        jl short loc_94D44
        cmp edx, byte 39h
        jg short loc_94D44
        lea eax, [byte edx-030h]
        mov dword [byte esp+030h], eax
        mov dword [esp], 1
loc_94D44:
        cmp edx, byte 41h
        jl short loc_94D5C
        cmp edx, byte 46h
        jg short loc_94D5C
        sub edx, byte 37h
        mov dword [byte esp+030h], edx
        mov dword [esp], 1
loc_94D5C:
        cmp dword [esp], byte 0
        je short loc_94DA8
        mov eax, dword [byte esp+01Ch]
        add eax, ebp
        mov edx, edi
        shl edx, 4
        add eax, edx
        mov edx, dword [byte esp+020h]
        test edx, edx
        jne short loc_94D91
        mov dh, byte [eax]
        and dh, 0Fh
        mov dl, byte [byte esp+030h]
        shl dl, 4
        add dh, dl
        mov byte [eax], dh
        mov dword [byte esp+020h], 1
        jmp short loc_94DA8
loc_94D91:
        cmp edx, byte 1
        jne short loc_94DA8
        mov dl, byte [eax]
        and dl, 0F0h
        mov dh, byte [byte esp+030h]
        add dh, dl
        mov byte [eax], dh
        mov ebx, 4D00h
loc_94DA8:
        cmp ebx, 4B00h
        jne short loc_94DC1
        dec ebp
        test ebp, ebp
        jge short loc_94DD6
        mov ebp, 0Fh
        mov ebx, 4800h
        jmp short loc_94DD6
loc_94DC1:
        cmp ebx, 4D00h
        jne short loc_94DD6
        inc ebp
        cmp ebp, byte 0Fh
        jle short loc_94DD6
        xor ebp, ebp
        mov ebx, 5000h
loc_94DD6:
        cmp ebx, 4800h
        jne short loc_94DEC
        test edi, edi
        jle short loc_94DE5
        dec edi
        jmp short loc_94E06
loc_94DE5:
        test esi, esi
        jbe short loc_94E06
        dec esi
        jmp short loc_94E06
loc_94DEC:
        cmp ebx, 5000h
        jne short loc_94E06
        cmp edi, byte 18h
        jge short loc_94DFC
        inc edi
        jmp short loc_94E06
loc_94DFC:
        lea eax, [byte esi+019h]
        cmp eax, dword [byte esp+024h]
        jae short loc_94E06
        inc esi
loc_94E06:
        cmp ebp, dword [byte esp+014h]
        jne short loc_94E18
        cmp edi, dword [byte esp+010h]
        jne short loc_94E18
        cmp esi, dword [byte esp+0Ch]
        je short loc_94E1E
loc_94E18:
        xor edx, edx
        mov dword [byte esp+020h], edx
loc_94E1E:
        cmp dword [byte esp+018h], byte 0
        je near loc_94BBC
loc_94E29:
        add esp, byte 34h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 08Dh,040h,00h
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
        push unk_C41F0
        call DebugPrintf
        add esp, byte 8
        shl edi, 4
        mov dword [byte esp+08h], edi
        xor ebp, ebp
        cmp dword [byte esp+04h], byte 0
        jle near loc_94F91
loc_94E68:
        mov edi, dword [byte esp+08h]
        push edi
        push str_04x2
        call DebugPrintf
        add esp, byte 8
        xor edi, edi
loc_94E7C:
        cmp edi, dword [esp]
        jne short loc_94E91
        cmp ebp, dword [byte esp+020h]
        jne short loc_94E91
        push byte 70h
        call DebugSetAttr
        add esp, byte 4
loc_94E91:
        xor eax, eax
        mov al, byte [esi]
        push eax
        push str_02x
        call DebugPrintf
        add esp, byte 8
        cmp edi, dword [esp]
        jne short loc_94ECB
        cmp ebp, dword [byte esp+020h]
        jne short loc_94ECB
        cmp dword [byte esp+024h], byte 0
        je short loc_94ECB
        push unk_C4414
        call DebugPrintf
        add esp, byte 4
        push byte 7
        call DebugSetAttr
        jmp short loc_94EDF
loc_94ECB:
        push byte 7
        call DebugSetAttr
        add esp, byte 4
        push unk_C4418
        call DebugPrintf
loc_94EDF:
        add esp, byte 4
        mov eax, edi
        and eax, byte 3
        cmp eax, byte 3
        jne short loc_94EF9
        push unk_C4418
        call DebugPrintf
        add esp, byte 4
loc_94EF9:
        inc esi
        inc edi
        cmp edi, byte 10h
        jl near loc_94E7C
        push unk_C4418
        call DebugPrintf
        add esp, byte 4
        xor edi, edi
        sub esi, byte 10h
loc_94F16:
        mov al, byte [esi]
        and al, 7Fh
        mov byte [byte esp+0Ch], al
        mov dword [MemViewTop], 7
        cmp al, 20h
        jae short loc_94F31
        mov byte [byte esp+0Ch], 2Eh
loc_94F31:
        test byte [esi], 80h
        je short loc_94F40
        mov dword [MemViewTop], 70h
loc_94F40:
        mov ecx, dword [MemViewTop]
        push ecx
        call DebugSetAttr
        add esp, byte 4
        xor eax, eax
        mov al, byte [byte esp+0Ch]
        push eax
        push unk_C41F0
        call DebugPrintf
        add esp, byte 8
        inc esi
        inc edi
        cmp edi, byte 10h
        jl short loc_94F16
        push byte 7
        call DebugSetAttr
        add esp, byte 4
        push asc_C441C
        call DebugPrintf
        add esp, byte 4
        add dword [byte esp+08h], byte 10h
        inc ebp
        cmp ebp, dword [byte esp+04h]
        jl near loc_94E68
loc_94F91:
        mov edi, ebp
        cmp ebp, byte 19h
        jge short loc_94FB0
loc_94F98:
        push MemViewStrings
        push str_80s
        call DebugPrintf
        add esp, byte 8
        inc edi
        cmp edi, byte 19h
        jl short loc_94F98
loc_94FB0:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret 8
        db 08Dh,040h,00h
WriteMemMap:
        push esi
        push edi
        push ebp
        sub esp, byte 28h
        mov edx, dword [byte esp+038h]
        xor eax, eax
        test edx, edx
        je near loc_950A3
        mov dword [MemViewList], edx
        mov edx, esp
        lea eax, [byte esp+014h]
        call FormatDateTime
        mov edx, dword [unk_93C50]
        push edx
        push asc_C4200
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
        mov eax, dword [unk_93C50]
        push eax
        push asc_C4200
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
        cmp dword [MemViewShowDetail], byte 0
        je short loc_9506F
        mov eax, unk_C4448
        jmp short loc_95074
loc_9506F:
        mov eax, str_FF
loc_95074:
        push eax
        push str_HexmemdspOS
        mov ecx, dword [MemViewList]
        push ecx
        call fprintf_
        add esp, byte 0Ch
        call sub_940F4
        mov ecx, 2
        mov ebx, eax
        xor edx, edx
        xor eax, eax
        call MemViewerDrawList
        mov eax, 1
loc_950A3:
        add esp, byte 28h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Bh,0C0h
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
        mov esi, dword [dword_EDAB4]
        cmp dword [GraphicsReady], byte 0
        je short loc_950ED
        push byte 14h
        lea eax, [byte esp+04h]
        push eax
        call ShowMessageBox
        add esp, byte 8
loc_950ED:
        mov edx, str_W_DumpMemoryMap
        mov eax, esp
        call fopen_
        mov dword [MemViewList], eax
        test eax, eax
        jne short loc_95122
        cmp dword [GraphicsReady], byte 0
        je short loc_9511A
        push byte 14h
        push str_ErrorDumpingMemoryMap
        call ShowMessageBox
        add esp, byte 8
loc_9511A:
        mov dword [dword_EDAB4], esi
        jmp short loc_9513E
loc_95122:
        mov dword [dword_EDAB4], esi
        mov esi, esp
        push esi
        push eax
        call WriteMemMap
        add esp, byte 8
        mov eax, dword [MemViewList]
        call fclose_
loc_9513E:
        add esp, byte 40h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
sub_95148:
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
        jl short loc_951B1
        mov eax, dword [byte esp+01Ch]
        cmp dword [eax], byte 0
        jge short loc_951FD
loc_951B1:
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
        call sub_9C890
        add esp, byte 8
        call ReturnFalse
        call sub_96144
        cmp eax, byte 59h
        jne near loc_954C0
loc_951FD:
        xor edi, edi
        mov dword [byte esp+08h], edi
        mov dword [byte esp+02Ch], edi
        xor esi, esi
        cmp dword [byte esp+030h], byte 0
        jle short loc_95250
loc_95210:
        mov eax, esp
        push eax
        push esi
        mov ecx, dword [byte esp+02Ch]
        push ecx
        call ShapeBankEntryId
        add esp, byte 0Ch
        cmp byte [esp], 21h
        jne short loc_95228
        inc edi
loc_95228:
        mov edx, esp
        mov eax, dword [byte esp+024h]
        call sub_95148
        mov eax, dword [eax]
        shl eax, 18h
        sar eax, 18h
        test al, 80h
        je short loc_95245
        inc dword [byte esp+08h]
        jmp short loc_95249
loc_95245:
        inc dword [byte esp+02Ch]
loc_95249:
        inc esi
        cmp esi, dword [byte esp+030h]
        jl short loc_95210
loc_95250:
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
        jne short loc_9528A
        push str_ThereAreNoShapes
        call DebugPrintf
        add esp, byte 4
        jmp near loc_954C0
loc_9528A:
        cmp ebp, byte 5Bh
        je short loc_95297
        cmp ebp, 4B00h
        jne short loc_9529E
loc_95297:
        mov edi, dword [byte esp+030h]
        dec edi
        jmp short loc_952A5
loc_9529E:
        xor edi, edi
        mov ebp, 5Dh
loc_952A5:
        xor ebx, ebx
        mov dword [byte esp+028h], ebx
        mov eax, dword [byte esp+030h]
        dec eax
        mov dword [byte esp+0Ch], eax
loc_952B4:
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
        je near loc_953CC
        mov eax, esi
        call ShapeInfo
        mov dword [byte esp+03Ch], eax
        test eax, eax
        je short loc_953B3
        mov eax, dword [esi]
        shl eax, 18h
        sar eax, 18h
        and eax, 80h
        mov dword [byte esp+038h], eax
        call SetScreenTarget
        cmp dword [byte esp+03Ch], byte 2
        jne short loc_95391
        mov ebx, dword [byte esp+038h]
        test ebx, ebx
        je short loc_95384
        push byte 0
        push byte 0
        push esi
        call DrawArtAnyFormatAt
        add esp, byte 0Ch
        jmp short loc_953A9
loc_95384:
        push ebx
        push ebx
        push esi
        call PutBlock
        add esp, byte 0Ch
        jmp short loc_953A9
loc_95391:
        cmp dword [byte esp+038h], byte 0
        je short loc_953A0
        push esi
        call DrawArtAnyFormatOwnPos
        jmp short loc_953A6
loc_953A0:
        push esi
        call DrawBitmap
loc_953A6:
        add esp, byte 4
loc_953A9:
        call ReturnFalse
        jmp near loc_95427
loc_953B3:
        push str_Bad
        call DebugPrintf
        add esp, byte 4
        mov eax, dword [MemViewBlack]
        call DebugGetKey
        jmp short loc_95427
loc_953CC:
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
        je short loc_95401
        cmp ebp, 4B00h
        jne short loc_9540C
loc_95401:
        dec edi
        test edi, edi
        jge short loc_95427
        mov edi, dword [byte esp+0Ch]
        jmp short loc_95427
loc_9540C:
        cmp ebp, byte 5Dh
        je short loc_9541E
        cmp ebp, byte 53h
        je short loc_9541E
        cmp ebp, 4D00h
        jne short loc_95427
loc_9541E:
        inc edi
        cmp edi, dword [byte esp+030h]
        jl short loc_95427
        xor edi, edi
loc_95427:
        cmp byte [esp], 21h
        je near loc_952B4
        call ReturnFalse
loc_95436:
        call sub_93C88
        mov ebp, eax
        test eax, eax
        je short loc_95436
        cmp eax, byte 1Bh
        jne short loc_9544E
        mov dword [byte esp+028h], 1
loc_9544E:
        cmp ebp, byte 5Bh
        je short loc_9545B
        cmp ebp, 4B00h
        jne short loc_95464
loc_9545B:
        dec edi
        test edi, edi
        jge short loc_95464
        mov edi, dword [byte esp+0Ch]
loc_95464:
        cmp ebp, byte 5Dh
        je short loc_95476
        cmp ebp, byte 53h
        je short loc_95476
        cmp ebp, 4D00h
        jne short loc_9547F
loc_95476:
        inc edi
        cmp edi, dword [byte esp+030h]
        jl short loc_9547F
        xor edi, edi
loc_9547F:
        cmp ebp, byte 43h
        jne short loc_95493
        call SetScreenTarget
        mov eax, dword [MemViewBlack]
        call DebugGetKey
loc_95493:
        cmp ebp, byte 4Dh
        jne short loc_9549D
        call DebugClearScreen
loc_9549D:
        cmp ebp, byte 50h
        jne short loc_954AB
        mov eax, dword [byte esp+034h]
        call DumpShapesList
loc_954AB:
        cmp ebp, byte 56h
        jne short loc_954B5
        call SaveScreenshot
loc_954B5:
        cmp dword [byte esp+028h], byte 0
        je near loc_952B4
loc_954C0:
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret
        db 090h
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
        je short loc_9559A
        mov eax, MemViewStrings
        jmp short loc_9559F
loc_9559A:
        mov eax, str_Un
loc_9559F:
        push eax
        push str_Spacked
        call DebugPrintf
        add esp, byte 8
        mov eax, dword [esi]
        shl eax, 18h
        sar eax, 18h
        test al, 80h
        je short loc_955C0
        mov eax, str_Packed
        jmp short loc_955C5
loc_955C0:
        mov eax, str_Unpacked
loc_955C5:
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
        jl near loc_95665
        mov edx, dword [byte esi+02h]
        sar edx, 10h
        cmp edx, dword [dword_D3044]
        jg short loc_95665
        cmp word [byte esi+06h], byte 0
        jl short loc_95665
        mov eax, dword [byte esi+04h]
        sar eax, 10h
        cmp eax, dword [dword_D3048]
        jg short loc_95665
        cmp word [byte esi+0Ch], byte 0
        jl short loc_95665
        mov ebx, dword [byte esi+0Ah]
        sar ebx, 10h
        cmp ebx, dword [dword_D3044]
        jg short loc_95665
        cmp word [byte esi+0Eh], byte 0
        jl short loc_95665
        mov esi, dword [byte esi+0Ch]
        sar esi, 10h
        mov ebp, dword [dword_D3048]
        cmp esi, ebp
        jg short loc_95665
        add edx, ebx
        cmp edx, dword [dword_D3044]
        jg short loc_95665
        add eax, esi
        cmp eax, ebp
        jle short loc_956B3
loc_95665:
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
        call sub_9C890
        add esp, byte 8
        call ReturnFalse
        call sub_96144
        cmp eax, byte 59h
        je short loc_956AC
        xor eax, eax
        jmp short loc_956B8
loc_956AC:
        mov eax, 2
        jmp short loc_956B8
loc_956B3:
        mov eax, 1
loc_956B8:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
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
        mov esi, dword [dword_EDAB4]
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
        jne short loc_9576B
        push byte 14h
        push str_ErrorDumpingShapesList
        call ShowMessageBox
        add esp, byte 8
        call ReturnFalse
        mov dword [dword_EDAB4], esi
        jmp near loc_9595F
loc_9576B:
        mov dword [dword_EDAB4], esi
        lea edx, [byte esp+040h]
        lea eax, [byte esp+054h]
        call FormatDateTime
        mov edx, dword [unk_93C50]
        push edx
        push asc_C4200
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
        mov ebp, dword [unk_93C50]
        push ebp
        push asc_C4200
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
        jle near loc_95937
        xor edi, edi
loc_9585D:
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
        je short loc_9590C
        mov eax, MemViewStrings
        jmp short loc_95911
loc_9590C:
        mov eax, str_Un
loc_95911:
        push eax
        push str_Spacked
        mov edx, dword [MemViewList]
        push edx
        call fprintf_
        add esp, byte 0Ch
        add edi, byte 4
        inc esi
        cmp esi, dword [dword esp+088h]
        jl near loc_9585D
loc_95937:
        cmp dword [dword esp+088h], byte 0
        je short loc_95955
        push unk_C46C0
        mov esi, dword [MemViewList]
        push esi
        call fprintf_
        add esp, byte 8
loc_95955:
        mov eax, dword [MemViewList]
        call fclose_
loc_9595F:
        add esp, 8Ch
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
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
loc_959D4:
        mov ebp, dword [dword esp+0308h]
        mov esi, 1Dh
        mov edi, dword [dword esp+0310h]
loc_959E7:
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
        jne short loc_959E7
        add dword [dword esp+0308h], byte 0Ah
        mov edi, dword [dword esp+0310h]
        add edi, byte 10h
        mov dword [dword esp+0310h], edi
        cmp edi, 100h
        jne short loc_959D4
        call ReturnFalse
        xor esi, esi
        xor edi, edi
        mov dword [dword esp+031Ch], esi
        mov edx, 1Bh
        mov dword [dword esp+0314h], edx
        mov ebx, 17h
        mov dword [dword esp+030Ch], ebx
        mov ecx, dword [dword_D45A4]
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
loc_95A92:
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
        jne short loc_95AD4
        xor eax, eax
        call PaletteViewerLabel
loc_95AD4:
        cmp ebp, byte 31h
        jne short loc_95AE3
        mov eax, 1
        call PaletteViewerLabel
loc_95AE3:
        cmp ebp, byte 52h
        jne short loc_95B17
        mov edx, dword [dword esp+032Ch]
        inc edx
        mov dword [dword esp+032Ch], edx
        cmp edx, byte 3Fh
        jle short loc_95B03
        mov eax, 3Fh
        jmp short loc_95B05
loc_95B03:
        mov eax, edx
loc_95B05:
        mov dword [dword esp+032Ch], eax
        mov dword [dword esp+0320h], 1
loc_95B17:
        cmp ebp, byte 47h
        jne short loc_95B47
        mov eax, dword [dword esp+0328h]
        inc eax
        mov dword [dword esp+0328h], eax
        cmp eax, byte 3Fh
        jle short loc_95B35
        mov eax, 3Fh
loc_95B35:
        mov dword [dword esp+0328h], eax
        mov dword [dword esp+0320h], 1
loc_95B47:
        cmp ebp, byte 42h
        jne short loc_95B7B
        mov ecx, dword [dword esp+0324h]
        inc ecx
        mov dword [dword esp+0324h], ecx
        cmp ecx, byte 3Fh
        jle short loc_95B67
        mov eax, 3Fh
        jmp short loc_95B69
loc_95B67:
        mov eax, ecx
loc_95B69:
        mov dword [dword esp+0324h], eax
        mov dword [dword esp+0320h], 1
loc_95B7B:
        cmp ebp, byte 72h
        jne short loc_95BAB
        mov ebx, dword [dword esp+032Ch]
        dec ebx
        mov dword [dword esp+032Ch], ebx
        test ebx, ebx
        jge short loc_95B97
        xor eax, eax
        jmp short loc_95B99
loc_95B97:
        mov eax, ebx
loc_95B99:
        mov dword [dword esp+032Ch], eax
        mov dword [dword esp+0320h], 1
loc_95BAB:
        cmp ebp, byte 67h
        jne short loc_95BDB
        mov edx, dword [dword esp+0328h]
        dec edx
        mov dword [dword esp+0328h], edx
        test edx, edx
        jge short loc_95BC7
        xor eax, eax
        jmp short loc_95BC9
loc_95BC7:
        mov eax, edx
loc_95BC9:
        mov dword [dword esp+0328h], eax
        mov dword [dword esp+0320h], 1
loc_95BDB:
        cmp ebp, byte 62h
        jne short loc_95C07
        mov eax, dword [dword esp+0324h]
        dec eax
        mov dword [dword esp+0324h], eax
        test eax, eax
        jge short loc_95BF5
        xor eax, eax
loc_95BF5:
        mov dword [dword esp+0324h], eax
        mov dword [dword esp+0320h], 1
loc_95C07:
        cmp ebp, byte 56h
        je short loc_95C11
        cmp ebp, byte 76h
        jne short loc_95C16
loc_95C11:
        call SaveScreenshot
loc_95C16:
        cmp ebp, 4700h
        jne short loc_95C28
        test esi, esi
        je short loc_95C26
        xor esi, esi
        jmp short loc_95C28
loc_95C26:
        xor edi, edi
loc_95C28:
        cmp ebp, 4F00h
        jne short loc_95C3E
        cmp esi, byte 0Fh
        je short loc_95C3C
        mov esi, 0Fh
        jmp short loc_95C3E
loc_95C3C:
        mov edi, esi
loc_95C3E:
        cmp ebp, 4800h
        jne short loc_95C51
        dec edi
        test edi, edi
        jge short loc_95C51
        mov edi, 0Fh
        dec esi
loc_95C51:
        cmp ebp, 5000h
        jne short loc_95C62
        inc edi
        cmp edi, byte 10h
        jl short loc_95C62
        xor edi, edi
        inc esi
loc_95C62:
        cmp ebp, 4B00h
        jne short loc_95C75
        dec esi
        test esi, esi
        jge short loc_95C75
        mov esi, 0Fh
        dec edi
loc_95C75:
        cmp ebp, 4D00h
        jne short loc_95C86
        inc esi
        cmp esi, byte 10h
        jl short loc_95C86
        xor esi, esi
        inc edi
loc_95C86:
        test esi, esi
        jge short loc_95C91
        mov esi, 0Fh
        jmp short loc_95C98
loc_95C91:
        cmp esi, byte 10h
        jl short loc_95C98
        xor esi, esi
loc_95C98:
        test edi, edi
        jge short loc_95CA3
        mov edi, 0Fh
        jmp short loc_95CAA
loc_95CA3:
        cmp edi, byte 10h
        jl short loc_95CAA
        xor edi, edi
loc_95CAA:
        cmp dword [dword esp+0320h], byte 0
        je short loc_95CF0
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
loc_95CF0:
        imul eax, esi, byte 12h
        add eax, byte 1Bh
        mov dword [dword esp+0314h], eax
        imul eax, edi, byte 0Ah
        add eax, byte 17h
        mov dword [dword esp+030Ch], eax
        mov eax, dword [dword esp+031Ch]
        mov edx, dword [nosplit eax*4+dword_D45A4]
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
        jb short loc_95D5D
        xor eax, eax
loc_95D5D:
        mov dword [dword esp+031Ch], eax
        mov ebx, dword [nosplit eax*4+dword_D45A4]
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
        jne near loc_95A92
        add esp, 330h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
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
loc_95EF1:
        push edi
        push asc_C46F8
        push byte 0Dh
        push esi
        call PrintBoxedText
        add esp, byte 10h
        push edi
        push asc_C46F8
        push ebp
        push byte 7
        call PrintBoxedText
        add esp, byte 10h
        call ReturnFalse
        add ebp, byte 0Ah
        add esi, byte 12h
        inc edi
        cmp esi, 139h
        jne short loc_95EF1
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
SaveScreenshot:
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov ebp, dword [dword_EDAB4]
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
        call sub_9D090
        add esp, byte 4
        mov dword [dword_EDAB4], ebp
        add esp, byte 40h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
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
        call sub_9D2E0
        add esp, byte 4
        mov esi, dword [byte eax+02Ch]
        call SetScreenTarget
        mov eax, esi
        call ShapeInfo
        test eax, eax
        je near loc_9602A
        mov edx, dword [esi]
        shl edx, 18h
        sar edx, 18h
        and edx, 80h
        cmp eax, byte 2
        jne short loc_95FF4
        test edx, edx
        je short loc_95FE7
        push byte 0
        push byte 0
        push esi
        call DrawArtAnyFormatAt
        add esp, byte 0Ch
        jmp short loc_96009
loc_95FE7:
        push edx
        push edx
        push esi
        call PutBlock
        add esp, byte 0Ch
        jmp short loc_96009
loc_95FF4:
        test edx, edx
        je short loc_96000
        push esi
        call DrawArtAnyFormatOwnPos
        jmp short loc_96006
loc_96000:
        push esi
        call DrawBitmap
loc_96006:
        add esp, byte 4
loc_96009:
        call ReturnFalse
        xor esi, esi
loc_96010:
        call sub_96144
        mov edx, 1
        cmp eax, byte 56h
        jne short loc_96026
        call SaveScreenshot
        mov edx, esi
loc_96026:
        test edx, edx
        je short loc_96010
loc_9602A:
        pop esi
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
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
        mov edx, dword [nosplit eax*4+unk_93C54]
        push edx
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        push asc_C470C
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
        je short loc_960C6
loc_960BF:
        inc eax
        inc edi
        cmp byte [eax], 3Fh
        jne short loc_960BF
loc_960C6:
        xor esi, esi
        mov ebp, eax
loc_960CA:
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
        je short loc_9610C
        inc esi
        cmp esi, byte 64h
        jl short loc_960CA
loc_9610C:
        cmp esi, byte 64h
        jl short loc_9611D
        add edi, dword [esp]
        mov byte [byte edi+01h], 78h
        mov al, byte [byte edi+01h]
        mov byte [edi], al
loc_9611D:
        mov eax, 1
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_9612C:
        push ebx
        push ecx
        push edx
        call ReturnFalse
        call sub_93C88
        mov dword [dword_D45B0], eax
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
sub_96144:
        push ebx
        push ecx
        push edx
        call ReturnFalse
        call sub_96164
        call sub_96170
        push eax
        call ToUpperChar
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
sub_96164:
        push ebx
        push ecx
        push edx
        call KbdFlush
        pop edx
        pop ecx
        pop ebx
        ret
sub_96170:
        push ebx
        push ecx
        push edx
        call KbdFlush
loc_96178:
        call sub_9612C
        test eax, eax
        je short loc_96178
        pop edx
        pop ecx
        pop ebx
        ret
