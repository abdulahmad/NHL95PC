; Saved highlights: save, list, play (PC only).
bits 32
%include "hockey.inc"
section s_7F724 progbits alloc exec nowrite align=1
extern __CHK, _dos_getdiskfree_, AllocMemBlock, awteamrec, bothneitherstrs, byte_DB7F1, byte_DC267, byte_DC268
extern ClearInputQueue, curleague, curperiod, DrawGadgetButton, DrawGadgetButton_ret, FadeOutPalCycle, FadePalStep, FatalError
extern FileClose, FileCreate, FileOpenRead, FileOpenWrite, FileReadAt, FileWriteAt, FillRect, fontcolor
extern fputchar, FreeMemBlock, FreeRinkGfx, FreeRockMusic, gamepal, GetFileSize, hilightfont, hilightrec
extern hmrosterjersey, hmteamrec, HomeTeam, hudclockhund, hudclockmin, hudclocksec, InstantReplay, ListDialog
extern LoadGameGfx, LoadRink, LoadRockMusic, LoadTeamPalette, lseek_, MakePath, MessageBox, MouseRead
extern msg_NoHilights, musichandle, musicon, musicslot, numshpbank, PlotPixel, PrintString, qsort_
extern recbpr, replaynosave, replaystart, rinkendbank, rinkscrollx, rinkscrolly, s1font, scrbrdshapes
extern SetDialogColors, SetPalette, SetScreenSize, sflags, ShowLoadingScreen, SndQuery, songdata, sprintf_
extern str_backslash4, str_CantOpenFile, str_dot4, str_F12, str_F3, str_F4, str_HI, str_HI2
extern str_HilightDescFmt, str_HilightsReel, str_HLT, str_HLTL, str_HLTS, str_K1, str_SaveTo, str_SelectAHilight
extern str_SelectATeam, str_star, strcat_, strcpy_, strcspn_, stricmp_, sub_1BAB1, PushMemDescriptorLocked
extern SetDigiChannelVolume, sub_93000, FillRectColor, teamabbrevs, teamcitynames, TextSaveState, TextSetFont, unknown_libname_1
extern unknown_libname_2, VisTeam
global HilightSaveToDlg, SaveHilight, NudgeRinkScroll, CmpInt, TeamFromHiName, FormatHilightDesc, SelectHilight, ViewHilights
global PlayHilight
;-----------------------------------------------------------------------------
; HilightSaveToDlg                             7F724  95 PC, medium confidence
; "Save To" / "Hilights Reel" dialog with team / Both Teams / Neither Teams
; choices (hilightfont); called by ReplaySaveHilight
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/DrawGadgetButton.c (HilightSaveToDlg)
%ifdef CBUILD
%include "c/front/replay_controls/DrawGadgetButton.HilightSaveToDlg.inc"
%else
HilightSaveToDlg:
        push dword 80h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 50h
        lea edi, [byte esp+040h]
        mov esi, bothneitherstrs
        movsd
        movsd
        mov eax, esp
        push eax
        call TextSaveState
        add esp, byte 4
        mov edx, dword [hilightfont]
        push edx
        call TextSetFont
        add esp, byte 4
        push byte 14h
        push byte 4Ch
        push dword 140h
        push byte 4Bh
        push byte 0
        call FillRect
        add esp, byte 14h
        push byte 9
        push dword 95h
        push dword 13Eh
        push byte 4Ch
        push byte 1
        call sub_93000
        add esp, byte 14h
        push byte 10h
        push dword 96h
        push dword 13Dh
        push byte 4Dh
        push byte 2
        call sub_93000
        add esp, byte 14h
        mov edi, 4Eh
        mov esi, 50h
        xor ebx, ebx
        mov dword [byte esp+04Ch], ebx
        jmp short .2
.1:
        push byte 59h
        lea ebp, [byte esi+0Eh]
        push ebp
        push edi
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        push byte 59h
        push esi
        lea eax, [dword edi+08Ah]
        mov dword [byte esp+050h], eax
        push eax
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        push byte 10h
        push ebp
        mov eax, dword [byte esp+050h]
        push eax
        push ebp
        lea eax, [byte edi+01h]
        push eax
        call FillRectColor
        add esp, byte 14h
        push byte 10h
        push ebp
        mov edx, dword [byte esp+050h]
        push edx
        lea eax, [byte esi+01h]
        push eax
        push edx
        call FillRectColor
        add esp, byte 14h
        push byte 13h
        push esi
        mov ecx, dword [byte esp+050h]
        push ecx
        call PlotPixel
        add esp, byte 0Ch
        push byte 13h
        push ebp
        push edi
        call PlotPixel
        add esp, byte 0Ch
        inc dword [byte esp+04Ch]
        add esi, byte 11h
.2:
        cmp dword [byte esp+04Ch], byte 4
        jl short HilightSaveToDlg.1
        mov dword [fontcolor], 10h
        push byte 6Dh
        push byte 0Eh
        push str_SaveTo
        call PrintString
        add esp, byte 0Ch
        push byte 6Dh
        push dword 0DFh
        push str_HilightsReel
        call PrintString
        add esp, byte 0Ch
        push byte 54h
        push hmteamrec+5
        call fputchar
        add esp, byte 4
        mov edx, 85h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 52h
        push eax
        push hmteamrec+5
        call PrintString
        add esp, byte 0Ch
        push byte 65h
        push awteamrec+5
        call fputchar
        add esp, byte 4
        mov edx, 85h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 52h
        push eax
        push awteamrec+5
        call PrintString
        add esp, byte 0Ch
        push byte 76h
        mov edi, dword [byte esp+044h]
        push edi
        call fputchar
        add esp, byte 4
        mov edx, 85h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 52h
        push eax
        push edi
        call PrintString
        add esp, byte 0Ch
        push dword 87h
        mov eax, dword [byte esp+048h]
        push eax
        call fputchar
        add esp, byte 4
        mov edx, 85h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 52h
        push eax
        mov edx, dword [byte esp+04Ch]
        push edx
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 59h
        push byte 6Ch
        push byte 0Dh
        push str_SaveTo
        call PrintString
        add esp, byte 0Ch
        push byte 6Ch
        push dword 0DEh
        push str_HilightsReel
        call PrintString
        add esp, byte 0Ch
        push byte 53h
        push hmteamrec+5
        call fputchar
        add esp, byte 4
        mov edx, 85h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 51h
        push eax
        push hmteamrec+5
        call PrintString
        add esp, byte 0Ch
        push byte 64h
        push awteamrec+5
        call fputchar
        add esp, byte 4
        mov edx, 85h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 51h
        push eax
        push awteamrec+5
        call PrintString
        add esp, byte 0Ch
        push byte 75h
        push edi
        call fputchar
        add esp, byte 4
        mov edx, 85h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 51h
        push eax
        push edi
        call PrintString
        add esp, byte 0Ch
        push dword 86h
        mov ebx, dword [byte esp+048h]
        push ebx
        call fputchar
        add esp, byte 4
        mov edx, 85h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 51h
        push eax
        mov ecx, dword [byte esp+04Ch]
        push ecx
        call PrintString
        add esp, byte 0Ch
        add esp, byte 50h
        jmp near DrawGadgetButton_ret
%endif ; C
;-----------------------------------------------------------------------------
; SaveHilight                                  7FA10  95 PC, medium confidence
; Checks _dos_getdiskfree, builds .HI path, fills hilightrec from game state,
; appends 9652h-byte record
;-----------------------------------------------------------------------------
; C: src/front/highlights/SaveHilight.c
%ifdef CBUILD
%include "c/front/highlights/SaveHilight.inc"
%else
SaveHilight:
        push dword 74h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 58h
        mov esi, eax
        lea edx, [byte esp+04Ch]
        xor eax, eax
        call _dos_getdiskfree_
        test eax, eax
        je short .1
        push str_K1
        call FatalError
        add esp, byte 4
.1:
        xor ebx, ebx
        mov bx, word [byte esp+052h]
        xor edx, edx
        mov eax, 9652h
        div ebx
        mov edx, eax
        xor ebx, ebx
        mov bx, word [byte esp+050h]
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        xor eax, eax
        mov ax, word [byte esp+04Eh]
        cmp edx, eax
        jle short .2
        mov ebx, 1
        mov dword [replaynosave], ebx
        mov eax, ebx
        jmp near .x
.2:
        mov al, byte [byte_DC268]
        mov byte [hilightrec], al
        mov al, byte [byte_DC267]
        mov byte [hilightrec+1], al
        mov al, byte [HomeTeam]
        mov byte [hilightrec+2], al
        mov al, byte [VisTeam]
        mov byte [hilightrec+1Fh], al
        mov eax, dword [curperiod]
        mov dword [hilightrec+3Ch], eax
        mov eax, dword [hudclockmin]
        mov dword [hilightrec+40h], eax
        mov eax, dword [hudclocksec]
        mov dword [hilightrec+44h], eax
        mov eax, dword [hudclockhund]
        mov dword [hilightrec+48h], eax
        mov ax, word [sflags]
        mov word [hilightrec+4Ch], ax
        mov eax, dword [recbpr]
        mov edx, dword [replaystart]
        sub eax, edx
        mov dword [hilightrec+4Eh], eax
        xor edx, edx
.3:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov bl, byte [dword eax+hmrosterjersey]
        mov byte [dword edx+hilightrec+3], bl
        mov al, byte [dword eax+byte_DB7F1]
        mov byte [dword edx+hilightrec+20h], al
        inc edx
        cmp edx, byte 1Ch
        jl short SaveHilight.3
        mov edx, curleague
        lea eax, [byte esp+02Ch]
        call strcpy_
        mov edx, str_backslash4
        lea eax, [byte esp+02Ch]
        call strcat_
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, hmteamrec
        add edx, eax
        lea eax, [byte esp+02Ch]
        call strcat_
        mov edx, str_HI
        lea eax, [byte esp+02Ch]
        call strcat_
        mov ebx, esp
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call unknown_libname_1
        test eax, eax
        je short .4
        lea edx, [byte esp+054h]
        lea eax, [byte esp+02Ch]
        call FileCreate
        test eax, eax
        je short .5
        push str_F12
        call FatalError
        add esp, byte 4
        jmp short .5
.4:
        lea edx, [byte esp+054h]
        lea eax, [byte esp+02Ch]
        call FileOpenWrite
        test eax, eax
        je short .5
        lea eax, [byte esp+02Ch]
        push eax
        push str_CantOpenFile
        call FatalError
        add esp, byte 8
.5:
        mov ebx, 2
        xor edx, edx
        mov eax, dword [byte esp+054h]
        call lseek_
        mov ecx, 9652h
        mov ebx, 0FFFFFFFFh
        mov edx, hilightrec
        mov eax, dword [byte esp+054h]
        call FileWriteAt
        test eax, eax
        je short .6
        push str_F3
        call FatalError
        add esp, byte 4
.6:
        lea eax, [byte esp+054h]
        call FileClose
        test eax, eax
        je short .7
        push str_F4
        call FatalError
        add esp, byte 4
.7:
        xor eax, eax
.x:
        add esp, byte 58h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; NudgeRinkScroll                                                 7FC12  95 PC
; Adds 3E8h to rinkscrollx/rinkscrolly (forces redraw); called by
; ReplaySaveHilight
;-----------------------------------------------------------------------------
; C: src/front/highlights/NudgeRinkScroll.c
%ifdef CBUILD
%include "c/front/highlights/NudgeRinkScroll.inc"
%else
NudgeRinkScroll:
        push dword 4
        call __CHK
        add dword [rinkscrollx], 3E8h
        add dword [rinkscrolly], 3E8h
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpInt                                       7FC31  95 PC, medium confidence
; Qsort comparator on ints (-1/0/1)
;-----------------------------------------------------------------------------
; C: src/front/highlights/CmpInt.c
%ifdef CBUILD
%include "c/front/highlights/CmpInt.inc"
%else
CmpInt:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        xor ebx, ebx
        mov ecx, dword [eax]
        mov esi, dword [edx]
        cmp ecx, esi
        jle short .1
        mov ebx, 1
        jmp short .2
.1:
        jge short .2
        mov ebx, 0FFFFFFFFh
.2:
        mov eax, ebx
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TeamFromHiName                               7FC5C  95 PC, medium confidence
; Strips extension at '.', matches teamabbrevs (26) -> team index or -1
;-----------------------------------------------------------------------------
; C: src/front/highlights/TeamFromHiName.c
%ifdef CBUILD
%include "c/front/highlights/TeamFromHiName.inc"
%else
TeamFromHiName:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        mov esi, 0FFFFFFFFh
        mov edx, str_dot4
        call strcspn_
        mov byte [ecx+eax], 0
        xor ebx, ebx
.1:
        mov edx, dword [nosplit ebx*4+teamabbrevs]
        mov eax, ecx
        call stricmp_
        test eax, eax
        jne short .2
        mov esi, ebx
.2:
        inc ebx
        cmp ebx, byte 1Ah
        jl short TeamFromHiName.1
        mov eax, esi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FormatHilightDesc                            7FCA2  95 PC, medium confidence
; Sprintf "%d %d, %s vs %s, Period %d, Time %02d:%02d." from a hilight record
;-----------------------------------------------------------------------------
; C: src/front/highlights/FormatHilightDesc.c
%ifdef CBUILD
%include "c/front/highlights/FormatHilightDesc.inc"
%else
FormatHilightDesc:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebx, eax
        mov ecx, dword [byte edx+044h]
        push ecx
        mov esi, dword [byte edx+040h]
        push esi
        mov edi, dword [byte edx+03Ch]
        push edi
        xor eax, eax
        mov al, byte [byte edx+01Fh]
        mov ebp, dword [nosplit eax*4+teamcitynames]
        push ebp
        xor eax, eax
        mov al, byte [byte edx+02h]
        mov ecx, dword [nosplit eax*4+teamcitynames]
        push ecx
        xor eax, eax
        mov al, byte [byte edx+01h]
        push eax
        xor eax, eax
        mov al, byte [edx]
        push eax
        push str_HilightDescFmt
        push ebx
        call sprintf_
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SelectHilight                                7FCF8  95 PC, medium confidence
; Scans *.HI, ListDialog "Select a team" then "Select a hilight", "There are
; no hilights!" message
;-----------------------------------------------------------------------------
SelectHilight:
        push dword 204h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 1D0h
        push eax
        push edx
        push ebx
        push ecx
        mov ebp, dword [dword esp+01F0h]
        mov dword [dword esp+01C8h], 0FFFFFFFFh
        xor esi, esi
        mov ecx, str_HI2
        mov ebx, str_star
        mov edx, dword [byte esp+04h]
        lea eax, [dword esp+0E0h]
        call MakePath
        lea ebx, [dword esp+0180h]
        xor edx, edx
        lea eax, [dword esp+0E0h]
        call unknown_libname_1
        test eax, eax
        jne short .3
        lea eax, [dword esp+019Eh]
        call TeamFromHiName
        mov dword [byte esp+078h], eax
        mov eax, dword [nosplit eax*4+teamcitynames]
        mov dword [byte esp+010h], eax
        mov esi, 1
.1:
        lea eax, [dword esp+0180h]
        call unknown_libname_2
        mov edi, eax
        test eax, eax
        jne short .2
        lea eax, [dword esp+019Eh]
        call TeamFromHiName
        mov dword [byte esp+esi*4+078h], eax
        inc esi
.2:
        test edi, edi
        je short SelectHilight.1
.3:
        test esi, esi
        je near .15
        mov ecx, CmpInt
        mov ebx, 4
        mov edx, esi
        lea eax, [byte esp+078h]
        call qsort_
        xor ebx, ebx
        jmp short .5
.4:
        mov edx, dword [byte esp+ecx*4+078h]
        mov edx, dword [nosplit edx*4+teamcitynames]
        mov dword [byte esp+ecx*4+010h], edx
        lea ebx, [byte ecx+01h]
.5:
        mov dword [dword esp+01D4h], ebx
        mov ecx, dword [dword esp+01D4h]
        cmp esi, ecx
        jg short SelectHilight.4
        lea eax, [dword esp+01ACh]
        push eax
        push byte 0
        mov ecx, 2
        mov ebx, str_SelectATeam
        mov edx, esi
        lea eax, [byte esp+018h]
        call ListDialog
        test eax, eax
        jl near .16
        mov ebx, dword [byte esp+eax*4+078h]
        mov ebx, dword [nosplit ebx*4+teamabbrevs]
        mov ecx, str_HI2
        xor edx, edx
        mov eax, dword [byte esp+0Ch]
        call MakePath
        xor ecx, ecx
        mov ebx, dword [byte esp+0Ch]
        mov edx, dword [byte esp+04h]
        lea eax, [dword esp+0E0h]
        call MakePath
        lea eax, [dword esp+0E0h]
        push eax
        call GetFileSize
        mov ebx, eax
        add esp, byte 4
        lea edx, [dword esp+01C8h]
        lea eax, [dword esp+0E0h]
        call FileOpenRead
        mov edi, eax
        test eax, eax
        jne near .14
        mov esi, 9652h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        mov esi, eax
        push byte 20h
        shl eax, 2
        push eax
        push str_HLTL
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+01D8h], eax
        push byte 20h
        mov edx, esi
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 4
        add eax, edx
        push eax
        push str_HLT
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+01DCh], eax
        cmp dword [esp], byte 0
        je short .8
        push byte 20h
        push esi
        push str_HLTS
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte ebp+00h], eax
        xor edx, edx
        mov dword [dword esp+01D4h], edx
        jmp short .7
.6:
        mov eax, dword [byte ebp+00h]
        add eax, ecx
        mov byte [eax], 0
        inc dword [dword esp+01D4h]
.7:
        mov ecx, dword [dword esp+01D4h]
        cmp esi, ecx
        jle short .8
        test edi, edi
        je short SelectHilight.6
.8:
        xor ecx, ecx
        mov dword [dword esp+01D4h], ecx
        jmp near .10
.9:
        imul ebx, eax, dword 9652h
        mov ecx, 4Ch
        lea edx, [dword esp+0134h]
        mov eax, dword [dword esp+01C8h]
        call FileReadAt
        mov edi, eax
        mov edx, dword [dword esp+01D4h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 4
        add eax, edx
        mov edx, dword [dword esp+01DCh]
        add edx, eax
        mov eax, dword [dword esp+01D4h]
        shl eax, 2
        add eax, dword [dword esp+01D8h]
        mov dword [eax], edx
        lea edx, [dword esp+0134h]
        lea eax, [dword esp+0E0h]
        call FormatHilightDesc
        mov edx, dword [dword esp+01D4h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 4
        add eax, edx
        add eax, dword [dword esp+01DCh]
        lea edx, [dword esp+0E0h]
        call strcpy_
        inc dword [dword esp+01D4h]
.10:
        mov eax, dword [dword esp+01D4h]
        cmp esi, eax
        jle short .11
        test edi, edi
        je near SelectHilight.9
.11:
        test edi, edi
        jne short .13
        mov edx, dword [byte ebp+00h]
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        mov ecx, 2
        mov ebx, str_SelectAHilight
        mov edx, esi
        mov eax, dword [dword esp+01E0h]
        call ListDialog
        mov edx, dword [byte esp+08h]
        mov dword [edx], eax
        test eax, eax
        jge short .12
        mov edi, 0FFFFFFFFh
.12:
        cmp dword [esp], byte 0
        je short .13
        mov eax, dword [byte esp+08h]
        mov dword [eax], esi
.13:
        mov eax, dword [dword esp+01DCh]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [dword esp+01D8h]
        push edx
        call FreeMemBlock
        add esp, byte 4
.14:
        lea eax, [dword esp+01C8h]
        call FileClose
        jmp short .17
.15:
        lea eax, [dword esp+01CCh]
        push eax
        lea eax, [dword esp+01D4h]
        push eax
        lea eax, [dword esp+01DCh]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+01D0h]
        push eax
        lea eax, [dword esp+01D8h]
        push eax
        push esi
        push esi
        mov ecx, 1
        mov ebx, msg_NoHilights
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.16:
        mov edi, 0FFFFFFFFh
.17:
        mov eax, edi
        add esp, 1E0h
        pop ebp
        pop edi
        pop esi
        ret 4
;-----------------------------------------------------------------------------
; ViewHilights                                 80075  95 PC, medium confidence
; SelectHilight, reads chosen 9652h-byte record into hilightrec, PlayHilight;
; called by MenuLeagueHilights and demo
;-----------------------------------------------------------------------------
; C: src/front/highlights/ViewHilights.c
%ifdef CBUILD
%include "c/front/highlights/ViewHilights.inc"
%else
ViewHilights:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 38h
        mov dword [byte esp+034h], 0FFFFFFFFh
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        push byte 0
        xor ecx, ecx
        mov ebx, curleague
        lea edx, [byte esp+034h]
        lea eax, [byte esp+024h]
        call SelectHilight
        mov edx, eax
        test eax, eax
        jne short .1
        xor ecx, ecx
        lea ebx, [byte esp+020h]
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+034h]
        mov eax, esp
        call FileOpenRead
        mov edx, eax
.1:
        test edx, edx
        jne short .2
        imul ebx, dword [byte esp+030h], dword 9652h
        mov ecx, 9652h
        mov edx, hilightrec
        mov eax, dword [byte esp+034h]
        call FileReadAt
        mov edx, eax
.2:
        lea eax, [byte esp+034h]
        call FileClose
        test edx, edx
        jne short .3
        call PlayHilight
.3:
        mov eax, edx
        add esp, byte 38h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PlayHilight                                  8011C  95 PC, medium confidence
; Restores teams / clock / jerseys from hilightrec, loads rink + gfx, runs
; InstantReplay, frees
;-----------------------------------------------------------------------------
; C: src/front/highlights/PlayHilight.c
%ifdef CBUILD
%include "c/front/highlights/PlayHilight.inc"
%else
PlayHilight:
        push dword 328h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 300h
        mov al, byte [hilightrec]
        mov byte [byte_DC268], al
        mov al, byte [hilightrec+1]
        mov byte [byte_DC267], al
        xor eax, eax
        mov al, byte [hilightrec+2]
        mov word [HomeTeam], ax
        xor eax, eax
        mov al, byte [hilightrec+1Fh]
        mov word [VisTeam], ax
        mov eax, dword [hilightrec+3Ch]
        mov dword [curperiod], eax
        mov eax, dword [hilightrec+40h]
        mov dword [hudclockmin], eax
        mov eax, dword [hilightrec+44h]
        mov dword [hudclocksec], eax
        mov eax, dword [hilightrec+48h]
        mov dword [hudclockhund], eax
        mov ax, word [hilightrec+4Ch]
        mov word [sflags], ax
        mov eax, dword [replaystart]
        mov edx, dword [hilightrec+4Eh]
        add eax, edx
        mov dword [recbpr], eax
        xor edx, edx
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov bl, byte [dword edx+hilightrec+3]
        mov byte [dword eax+hmrosterjersey], bl
        mov bl, byte [dword edx+hilightrec+20h]
        mov byte [dword eax+byte_DB7F1], bl
        inc edx
        cmp edx, byte 1Ch
        jl short PlayHilight.1
        cmp byte [musicon], 0
        je short .2
        cmp dword [songdata], byte 0
        je short .2
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.2:
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .4
        cmp dword [songdata], byte 0
        je short .4
.3:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short PlayHilight.3
        mov esi, dword [songdata]
        push esi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor edi, edi
        mov dword [songdata], edi
.4:
        call ShowLoadingScreen
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, gamepal
        call LoadTeamPalette
        call LoadRockMusic
        call LoadGameGfx
        call FadeOutPalCycle
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        cmp word [HomeTeam], byte 1Ah
        jl short .5
        mov eax, 0Ch
        jmp short .6
.5:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
.6:
        call LoadRink
        xor eax, eax
        call InstantReplay
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov ebp, dword [s1font]
        push ebp
        call TextSetFont
        add esp, byte 4
        call sub_1BAB1
        mov eax, dword [rinkendbank]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [scrbrdshapes]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [numshpbank]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov ecx, dword [hilightfont]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        call FreeRockMusic
        call FreeRinkGfx
        call ClearInputQueue
        add esp, 300h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
