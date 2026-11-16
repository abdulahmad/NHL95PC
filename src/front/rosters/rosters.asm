; Edit rosters: roster lists, roster panel, jersey numbers.
bits 32
%include "hockey.inc"
section s_6CC20 progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, boxfillcolor, boxlitecolor, boxshadecolor, btn_EditRosters, btn_LeagueExists, btn_RosterList
extern BuildFreeAgentList, BuildTeamRosterList, TextCharH, CarTeamRecPtr, cddriveptr, ClearInputQueue, ClearScreen, CreateBitmap
extern curdbname, dbdirty, DbLineEditor, dblinesmenubar, divisionteams, dlgtextbg, dlgtextfg, DrawArt
extern DrawButtons, DrawDlgFrame, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, DrawScrollBar, DrawShape
extern FaListScrolls, RosterFont, editptrspr, editrosters_exit, editrostersmenubar, facount, FadePalStep, falist
extern falistsel, falisttop, fascrollbar, fascrollbar_count, fascrollbar_len, fascrollbar_thumb, fascrollbar_top, fileoncd
extern FillRect, FindShape, FitPlayerName, fputchar, FreeLeagueDbsMem, FreeMemBlock, fullscrbmp, GetInputEvent
extern GrabBlock, hmteamrec, HomeTeam, InitScrollBar, InputDialog, keydb, keydb_size, KeyDbPtr
extern LoadBank, LoadLeagueDbsMem, mainfont, MakePath, memcpy_, menu_r1_editlines, menu_r1_freeagents, menu_r1_tofa
extern menu_r1_toroster2, menu_r2_editlines, menu_r2_freeagents, menu_r2_tofa, menu_r2_toroster1, MenuHitTest, MessageBox, mousepollfn
extern MouseSetPos, MoveToFreeAgents, MoveToOtherRoster, msglines, musichandle, musicon, musicslot, PlotPixel
extern pointerspr, PrintCenteredText, PrintShadowText, PrintString, ptrupdatefn, PutBlock, roster1divmenus, roster2divmenus
extern rostereditmode, rosterisfa, rosterjersey, rosterlist, rostersel, rosterslot, rosterteam, rosterteamptr
extern rosterteamrec, savepal, SetClipWindow, SetDrawBitmap, SetPalette, SetTextColors, SetViewRect, SndQuery
extern songdata, sprintf_, str_AreYouSureYou, str_C4, str_Current3, str_DATABASE, str_ea, str_extDB
extern str_fmt2d, str_FreeAgents, str_Menubuff, str_Pal, str_PleaseEnterANew, str_Pointer11, str_Prez2, str_Ratings
extern str_S5, str_space, str_Temp7, str_TheDatabaseHasNot, str_TheJerseyNumber2d, str_Uar, str_Uarm, strcat_
extern strcmp_, strcpy_, strlen_, strupr_, PushMemDescriptorLocked, SetDigiChannelVolume, DrawArtOpaqueAtOwnPos, SetScreenTarget
extern FillRectColor, teamdivflags, teamratingidx, teamratingnames, TextRestoreState, TextSaveState, TextSetFont, TrackButtons
extern TrackScrollBars, rosterteamcopy, VisTeam, XorBar
global RunEditRosters, RunEditRosters_ret6, RunEditRosters_ret5, DrawRosterTitle, DrawRosterList, DrawDatabaseName, DrawRosterPanel, DrawEditRosters
global EditRostersReturn, SelectRosterTeam, ShowFreeAgents, ComparePlayerEntry, ShellSortBytes, LoadRosterList_fa, LoadRosterList_faloop, LoadRosterList_team
global CountSelected, RosterPanelClick, RosterPanelClick_ret, FixJerseyNumber, CopyRoster1Rec, LoadBothRosterLists, LoadRosterList, EditTeamLines
global EditRosters
;-----------------------------------------------------------------------------
; RunEditRosters                                                  6CC20  95 PC
; Edit Rosters session: dialog colours, music fade, "Current" DBs into memory
; (LoadLeagueDbsMem), enlarged pointer copy, EditRosters, FreeLeagueDbsMem,
;
; restore
;-----------------------------------------------------------------------------
; C: src/front/rosters/RunEditRosters.c
%ifdef CBUILD
%include "c/front/rosters/RunEditRosters.inc"
%else
RunEditRosters:
        push dword 7Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 54h
        mov eax, dword [boxlitecolor]
        mov dword [byte esp+040h], eax
        mov eax, dword [boxshadecolor]
        mov dword [byte esp+04Ch], eax
        mov eax, dword [boxfillcolor]
        mov dword [byte esp+050h], eax
        mov eax, dword [dlgtextfg]
        mov dword [byte esp+048h], eax
        mov eax, dword [dlgtextbg]
        mov dword [byte esp+044h], eax
        mov dword [boxfillcolor], 41h
        mov ebx, 40h
        mov dword [boxlitecolor], ebx
        mov ecx, 42h
        mov dword [boxshadecolor], ecx
        mov dword [dlgtextfg], ebx
        mov dword [dlgtextbg], ecx
        xor ebp, ebp
        mov dword [editrosters_exit], ebp
        mov dword [rostereditmode], ebp
        push byte 20h
        push dword 300h
        push str_Temp7
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        cmp byte [musicon], 0
        je short .1
        cmp dword [songdata], byte 0
        je short .1
        mov eax, dword [musichandle]
        mov ebx, 32h
        mov edx, 3
        call SetDigiChannelVolume
.1:
        push ebp
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, ebp
        mov eax, 1
        call FadePalStep
        mov edi, curdbname
        mov esi, str_Current3
        movsd
        movsd
        call SetScreenTarget
        mov eax, dword [mainfont]
        mov dword [RosterFont], eax
        push eax
        call TextSetFont
        add esp, byte 4
        mov eax, esp
        push eax
        call TextSaveState
        add esp, byte 4
        cmp byte [musicon], 0
        je short .3
        cmp dword [songdata], byte 0
        je short .3
.2:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short RunEditRosters.2
        mov esi, dword [songdata]
        push esi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor edi, edi
        mov dword [songdata], edi
.3:
        push byte 20h
        push dword 1E0h
        push dword 280h
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [fullscrbmp], eax
        mov eax, dword [pointerspr]
        mov esi, dword [byte eax+02h]
        sar esi, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        lea edx, [byte eax+01h]
        lea eax, [byte esi+01h]
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer11
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [editptrspr], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [pointerspr]
        mov si, word [byte eax+04h]
        inc esi
        mov eax, dword [editptrspr]
        mov word [byte eax+04h], si
        mov eax, dword [pointerspr]
        mov si, word [byte eax+06h]
        inc esi
        mov eax, dword [editptrspr]
        mov word [byte eax+06h], si
        mov eax, str_extDB
        call LoadLeagueDbsMem
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 6
        mov eax, editrostersmenubar
        call EditRosters
        call FreeLeagueDbsMem
        mov eax, dword [editptrspr]
        push eax
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .4
        cmp dword [songdata], byte 0
        je short .4
        mov eax, dword [musichandle]
        mov ebx, 32h
        mov edx, 3
        call SetDigiChannelVolume
.4:
        push ebp
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, ebp
        mov eax, 1
        call FadePalStep
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, esp
        push eax
        call TextRestoreState
        add esp, byte 4
        mov ebx, dword [fullscrbmp]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [byte esp+050h]
        mov dword [boxfillcolor], eax
        mov eax, dword [byte esp+040h]
        mov dword [boxlitecolor], eax
        mov eax, dword [byte esp+04Ch]
        mov dword [boxshadecolor], eax
        mov eax, dword [byte esp+048h]
        mov dword [dlgtextfg], eax
        mov eax, dword [byte esp+044h]
        mov dword [dlgtextbg], eax
        cmp byte [musicon], 0
        je short .6
        cmp dword [songdata], byte 0
        je short .6
.5:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short RunEditRosters.5
        mov esi, dword [songdata]
        push esi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor edi, edi
        mov dword [songdata], edi
.6:
        add esp, byte 54h
RunEditRosters_ret6:
        pop ebp
RunEditRosters_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawRosterTitle                                                 6CEFB  95 PC
; (x, y, side): team name or "Free Agents", trimmed to 91h pixels
;-----------------------------------------------------------------------------
; C: src/front/rosters/DrawRosterTitle.c
%ifdef CBUILD
%include "c/front/rosters/DrawRosterTitle.inc"
%else
DrawRosterTitle:
        push dword 70h
        call __CHK
        push ecx
        push esi
        push edi
        sub esp, byte 54h
        mov edi, eax
        mov esi, edx
        cmp byte [dword ebx+rosterisfa], 1
        je short .3
        mov eax, dword [nosplit ebx*4+rosterteamptr]
        add eax, byte 1Ah
        push eax
        push str_S5
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
.1:
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        cmp eax, 91h
        jle short .2
        mov eax, esp
        call strlen_
        xor dl, dl
        mov byte [byte esp+eax-01h], dl
        jmp short DrawRosterTitle.1
.2:
        mov ebx, esp
        mov edx, esi
        jmp short .4
.3:
        mov ebx, str_FreeAgents
.4:
        mov eax, edi
        call PrintShadowText
        add esp, byte 54h
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawRosterList                               6CF6F  95 PC, medium confidence
; Roster panel rows (position, jersey, FitPlayerName), buttons and scroll bar
;-----------------------------------------------------------------------------
; C: src/front/rosters/DrawRosterList.c
%ifdef CBUILD
%include "c/front/rosters/DrawRosterList.inc"
%else
DrawRosterList:
        push dword 94h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 60h
        push eax
        push edx
        push ebx
        cmp byte [dword ebx+rosterisfa], 1
        je near .6
        xor esi, esi
.1:
        mov edi, dword [byte ebp-06Ch]
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 2
        mov edi, eax
        shl eax, 6
        sub eax, edi
        mov dword [byte ebp-08h], eax
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        sub eax, esi
        mov dword [byte ebp-04h], eax
        mov edi, dword [byte ebp-08h]
        add edi, eax
        cmp byte [dword edi+rosterlist], 0
        je near .4
        xor eax, eax
        mov al, byte [dword edi+rosterjersey]
        push eax
        push str_fmt2d
        lea eax, [byte ebp-060h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [TextCharH]
        imul eax, esi
        add eax, dword [byte ebp-068h]
        push eax
        mov ebx, dword [byte ebp-064h]
        push ebx
        lea eax, [byte ebp-060h]
        push eax
        call PrintString
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [dword edi+rosterlist]
        push eax
        push str_C4
        lea eax, [byte ebp-060h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [TextCharH]
        imul eax, esi
        add eax, dword [byte ebp-068h]
        push eax
        mov eax, dword [byte ebp-064h]
        add eax, byte 28h
        push eax
        lea eax, [byte ebp-060h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov ebx, rosterlist
        add ebx, dword [byte ebp-08h]
        add ebx, dword [byte ebp-04h]
        add ebx, byte 8
        mov ecx, 91h
        xor edx, edx
        lea eax, [byte ebp-060h]
        call FitPlayerName
        xor eax, eax
        mov al, byte [TextCharH]
        imul eax, esi
        add eax, dword [byte ebp-068h]
        push eax
        mov eax, dword [byte ebp-064h]
        add eax, byte 50h
        push eax
        lea eax, [byte ebp-060h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov edx, dword [byte ebp-06Ch]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        cmp byte [dword esi+eax*4+rostersel], 0
        je short .5
        push dword 80h
        xor eax, eax
        mov al, byte [TextCharH]
        push eax
        push dword 0F0h
        imul eax, esi
        add eax, byte 35h
        push eax
        test edx, edx
        je short .2
        mov eax, 15Eh
        jmp short .3
.2:
        mov eax, 23h
.3:
        push eax
        call XorBar
        add esp, byte 14h
        jmp short .5
.4:
        mov esi, 1Ch
.5:
        inc esi
        cmp esi, byte 1Ch
        jl near DrawRosterList.1
        jmp near .x
.6:
        mov edi, dword [falisttop]
        xor esi, esi
        jmp near .11
.7:
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        sub eax, edi
        mov dword [byte ebp-0Ch], eax
        mov eax, dword [falist]
        add eax, dword [byte ebp-0Ch]
        mov al, byte [byte eax+01h]
        and eax, 0FFh
        push eax
        push str_fmt2d
        lea eax, [byte ebp-060h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [TextCharH]
        imul eax, esi
        add eax, dword [byte ebp-068h]
        push eax
        mov ecx, dword [byte ebp-064h]
        push ecx
        lea eax, [byte ebp-060h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov eax, dword [falist]
        add eax, dword [byte ebp-0Ch]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        push str_C4
        lea eax, [byte ebp-060h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [TextCharH]
        imul eax, esi
        add eax, dword [byte ebp-068h]
        push eax
        mov eax, dword [byte ebp-064h]
        add eax, byte 28h
        push eax
        lea eax, [byte ebp-060h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov ebx, dword [falist]
        add ebx, dword [byte ebp-0Ch]
        add ebx, byte 8
        mov ecx, 91h
        xor edx, edx
        lea eax, [byte ebp-060h]
        call FitPlayerName
        xor eax, eax
        mov al, byte [TextCharH]
        imul eax, esi
        add eax, dword [byte ebp-068h]
        push eax
        mov eax, dword [byte ebp-064h]
        add eax, byte 50h
        push eax
        lea eax, [byte ebp-060h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov eax, dword [falistsel]
        cmp byte [edi+eax], 0
        je short .10
        push dword 80h
        xor eax, eax
        mov al, byte [TextCharH]
        push eax
        push dword 0F0h
        imul eax, esi
        add eax, byte 35h
        push eax
        cmp dword [byte ebp-06Ch], byte 0
        je short .8
        mov eax, 15Eh
        jmp short .9
.8:
        mov eax, 23h
.9:
        push eax
        call XorBar
        add esp, byte 14h
.10:
        inc edi
        inc esi
.11:
        cmp esi, byte 1Ch
        jge short .12
        cmp edi, dword [facount]
        jl near DrawRosterList.7
.12:
        cmp dword [FaListScrolls], byte 0
        je short .x
        mov edx, 2
        mov eax, btn_RosterList
        call DrawButtons
        mov eax, dword [falisttop]
        mov dword [fascrollbar_top], eax
        mov eax, dword [fascrollbar_len]
        sub eax, byte 4
        imul eax, dword [fascrollbar_top]
        mov ebx, dword [fascrollbar_count]
        xor edx, edx
        div ebx
        mov dword [fascrollbar_thumb], eax
        mov eax, fascrollbar
        call DrawScrollBar
.x:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawDatabaseName                                                6D256  95 PC
; "DATABASE : " + upper-cased current database name, centred
;-----------------------------------------------------------------------------
; C: src/front/rosters/DrawDatabaseName.c
%ifdef CBUILD
%include "c/front/rosters/DrawDatabaseName.inc"
%else
DrawDatabaseName:
        push dword 44h
        call __CHK
        push edx
        push esi
        push edi
        sub esp, byte 34h
        mov edi, esp
        mov esi, str_DATABASE
        movsd
        movsd
        movsd
        mov eax, curdbname
        call strupr_
        mov edx, curdbname
        mov eax, esp
        call strcat_
        mov edx, esp
        mov eax, 18h
        call PrintCenteredText
        add esp, byte 34h
        pop edi
        pop esi
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawRosterPanel                                                 6D299  95 PC
; (side): DrawRosterTitle, DrawRosterList and DrawDatabaseName for the left
; or right panel
;-----------------------------------------------------------------------------
; C: src/front/rosters/DrawRosterPanel.c
%ifdef CBUILD
%include "c/front/rosters/DrawRosterPanel.inc"
%else
DrawRosterPanel:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        test eax, eax
        jne short .1
        xor ebx, ebx
        mov edx, 25h
        mov eax, 64h
        call DrawRosterTitle
        xor ebx, ebx
        mov edx, 35h
        mov eax, 2Dh
        jmp short .2
.1:
        mov ebx, 1
        mov edx, 25h
        mov eax, 19Eh
        call DrawRosterTitle
        mov ebx, 1
        mov edx, 35h
        mov eax, 167h
.2:
        call DrawRosterList
        call DrawDatabaseName
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawEditRosters                              6D2F8  95 PC, medium confidence
; Redraws the Edit Rosters screen (prez2 background and palette, both roster
; panels with 'Ratings:' and jersey numbers); called after every roster change
;
; and from database_dialogs
;-----------------------------------------------------------------------------
; C: src/front/rosters/RunEditRosters.c (DrawEditRosters)
%ifdef CBUILD
%include "c/front/rosters/RunEditRosters.DrawEditRosters.inc"
%else
DrawEditRosters:
        push dword 80h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 54h
        mov edx, dword [fullscrbmp]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 5
        mov eax, editrostersmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_Prez2
        cmp byte [fileoncd+01C3h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pal
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, savepal
        call memcpy_
        push str_ea
        push esi
        call FindShape
        mov edi, eax
        add esp, byte 8
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push edi
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        call DrawRosterPanel
        mov eax, 1
        call DrawRosterPanel
        cmp dword [rostereditmode], byte 2
        jne near .4
        push byte 1
        mov ecx, 154h
        mov ebx, 1CCh
        mov edx, 8Ch
        mov eax, 0B4h
        call DrawDlgFrame
        push byte 41h
        push dword 0C9h
        push dword 119h
        push dword 8Ch
        push dword 0B4h
        call FillRect
        add esp, byte 14h
        push byte 40h
        push dword 8Ch
        push dword 1CBh
        push dword 8Ch
        push dword 0B4h
        call FillRectColor
        add esp, byte 14h
        push byte 40h
        push dword 153h
        push dword 0B4h
        push dword 8Ch
        push dword 0B4h
        call FillRectColor
        add esp, byte 14h
        push byte 42h
        push dword 154h
        push dword 1CCh
        push dword 8Dh
        push dword 1CCh
        call FillRectColor
        add esp, byte 14h
        push byte 42h
        push dword 154h
        push dword 1CCh
        push dword 154h
        push dword 0B5h
        call FillRectColor
        add esp, byte 14h
        push byte 41h
        push dword 154h
        push dword 0B4h
        call PlotPixel
        add esp, byte 0Ch
        push byte 41h
        push dword 8Ch
        push dword 1CCh
        call PlotPixel
        add esp, byte 0Ch
        mov edx, str_Ratings
        mov eax, esp
        call strcpy_
        mov edx, str_space
        mov eax, esp
        call strcat_
        mov edx, dword [rosterteamrec]
        add edx, byte 1Ah
        mov eax, esp
        call strcat_
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        mov edx, 118h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, 0B4h
        mov ebx, esp
        mov edx, 99h
        call PrintShadowText
        mov edi, dword [rosterteamrec]
        add edi, 2DCh
        mov esi, 0B0h
        xor ecx, ecx
.3:
        mov ebx, dword [nosplit ecx*4+teamratingnames]
        mov edx, esi
        mov eax, 0D2h
        call PrintShadowText
        xor eax, eax
        mov al, byte [dword ecx+teamratingidx]
        mov al, byte [edi+eax]
        and eax, 0FFh
        push eax
        push str_fmt2d
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov ebx, esp
        mov edx, esi
        mov eax, 1A9h
        call PrintShadowText
        inc ecx
        add esi, byte 0Dh
        cmp ecx, byte 9
        jl short DrawEditRosters.3
        mov edx, 2
        mov eax, btn_EditRosters
        call DrawButtons
.4:
        call SetScreenTarget
        mov eax, dword [fullscrbmp]
        mov ecx, dword [byte eax+02Ch]
        push ecx
        call DrawArtOpaqueAtOwnPos
        add esp, byte 4
        add esp, byte 54h
        jmp near RunEditRosters_ret5
%endif ; C
;-----------------------------------------------------------------------------
; EditRostersReturn                                               6D5BB  95 PC
; 'Return' menu item (league_db_strings_1 menu table): sets editrosters_exit to -1
;-----------------------------------------------------------------------------
; C: src/front/rosters/EditRostersReturn.c
%ifdef CBUILD
%include "c/front/rosters/EditRostersReturn.inc"
%else
EditRostersReturn:
        push dword 4
        call __CHK
        mov dword [editrosters_exit], 0FFFFFFFFh
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SelectRosterTeam                                                6D5D0  95 PC
; Division-submenu team item: puts the picked team (divisionteams[div][slot])
; in rosterteam[side], re-enables the previous team's item
;
; and 'Free Agents ...', disables the new one, enables 'Edit Team Lines ...',
; reloads the list (LoadRosterList) and redraws
;-----------------------------------------------------------------------------
SelectRosterTeam:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        cmp dword [eax], byte 1
        setne dl
        and edx, 0FFh
        mov esi, edx
        mov edi, dword [byte eax+04h]
        mov ebp, dword [byte eax+08h]
        mov al, byte [dword edx+rosterteam]
        mov byte [esp], al
        mov eax, edi
        shl eax, 3
        sub eax, edi
        mov al, byte [dword eax+ebp+divisionteams]
        mov byte [dword edx+rosterteam], al
        mov ah, byte [esp]
        cmp ah, 0FFh
        jne short .1
        mov ecx, ShowFreeAgents
        mov dword [menu_r1_freeagents], ecx
        mov dword [menu_r2_freeagents], ecx
        jmp short .5
.1:
        xor ecx, ecx
        mov cl, ah
        mov ecx, dword [nosplit ecx*4+teamdivflags]
        sar ecx, 1
        cmp ecx, byte 4
        jne short .2
        dec ecx
.2:
        xor edx, edx
        mov bl, byte [esp]
.3:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        cmp bl, byte [dword edx+eax+divisionteams]
        je short .4
        inc edx
        cmp edx, byte 7
        jl short SelectRosterTeam.3
.4:
        shl ecx, 5
        shl edx, 5
        mov eax, dword [dword ecx+roster1divmenus]
        mov dword [byte edx+eax+014h], SelectRosterTeam
        mov eax, dword [dword ecx+roster2divmenus]
        mov dword [byte edx+eax+014h], SelectRosterTeam
.5:
        mov eax, edi
        shl eax, 5
        mov edx, ebp
        shl edx, 5
        mov ebx, dword [dword eax+roster1divmenus]
        mov dword [byte edx+ebx+014h], 0
        mov eax, dword [dword eax+roster2divmenus]
        mov dword [byte edx+eax+014h], 0
        test esi, esi
        jne short .6
        mov dword [menu_r1_editlines], EditTeamLines
        jmp short .7
.6:
        mov dword [menu_r2_editlines], EditTeamLines
.7:
        xor bh, bh
        mov byte [dword esi+rosterisfa], bh
        mov eax, esi
        call LoadRosterList
        call DrawEditRosters
        add esp, byte 4
        jmp near RunEditRosters_ret6
;-----------------------------------------------------------------------------
; ShowFreeAgents                                                  6D6DB  95 PC
; 'Free Agents ...' menu item: rosterteam[side] = FFh, rosterisfa[side] = 1,
; disables the item and 'Edit Team Lines ...', LoadRosterList and redraw
;-----------------------------------------------------------------------------
; C: src/front/rosters/RunEditRosters.c (ShowFreeAgents)
%ifdef CBUILD
%include "c/front/rosters/RunEditRosters.ShowFreeAgents.inc"
%else
ShowFreeAgents:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        cmp dword [eax], byte 1
        setne al
        movzx esi, al
        mov edi, esi
        movzx esi, byte [dword esi+rosterteam]
        mov ecx, dword [nosplit esi*4+teamdivflags]
        sar ecx, 1
        cmp ecx, byte 4
        jne short .1
        dec ecx
.1:
        xor edx, edx
.2:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        mov al, byte [dword edx+eax+divisionteams]
        and eax, 0FFh
        cmp eax, esi
        je short .3
        inc edx
        cmp edx, byte 7
        jl short ShowFreeAgents.2
.3:
        shl ecx, 5
        shl edx, 5
        mov eax, dword [dword ecx+roster1divmenus]
        mov dword [byte edx+eax+014h], SelectRosterTeam
        mov eax, dword [dword ecx+roster2divmenus]
        mov dword [byte edx+eax+014h], SelectRosterTeam
        xor ebx, ebx
        mov dword [menu_r1_freeagents], ebx
        mov dword [menu_r2_freeagents], ebx
        test edi, edi
        jne short .4
        mov dword [menu_r1_editlines], ebx
        jmp short .5
.4:
        mov dword [menu_r2_editlines], ebx
.5:
        mov byte [dword edi+rosterteam], 0FFh
        mov byte [dword edi+rosterisfa], 1
        mov eax, edi
        call LoadRosterList
        call DrawEditRosters
        jmp near RunEditRosters_ret5
%endif ; C
;-----------------------------------------------------------------------------
; ComparePlayerEntry                           6D78B  95 PC, medium confidence
; Sort compare for 1Bh-byte list entries: by position byte (L, C, R, D order,
; empty last), then strcmp of the name at +0Bh
;-----------------------------------------------------------------------------
; C: src/front/rosters/ComparePlayerEntry.c
%ifdef CBUILD
%include "c/front/rosters/ComparePlayerEntry.inc"
%else
ComparePlayerEntry:
        push dword 8
        call __CHK
        push ebx
        mov bl, byte [eax]
        mov bh, byte [edx]
        cmp bl, bh
        jne short .2
        cmp byte [eax], 0
        jne short .1
        xor eax, eax
        pop ebx
        ret
.1:
        add edx, byte 0Bh
        add eax, byte 0Bh
        call strcmp_
        pop ebx
        ret
.2:
        test bl, bl
        je short .5
        test bh, bh
        jne short .4
.3:
        mov eax, 0FFFFFFFFh
        pop ebx
        ret
.4:
        cmp bl, 4Ch
        je short ComparePlayerEntry.3
        cmp bh, 4Ch
        je short .5
        cmp bl, 43h
        je short ComparePlayerEntry.3
        cmp bh, 43h
        je short .5
        cmp bl, 52h
        je short ComparePlayerEntry.3
        cmp bh, 52h
        je short .5
        cmp bl, 44h
        je short ComparePlayerEntry.3
.5:
        mov eax, 1
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShellSortBytes                                                  6D7ED  95 PC
; Shell sort (base, count, element size, compare fn) swapping elements byte
; by byte with xor
;-----------------------------------------------------------------------------
; C: src/front/rosters/ShellSortBytes.c
%ifdef CBUILD
%include "c/front/rosters/ShellSortBytes.inc"
%else
ShellSortBytes:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        push edx
        mov ebp, ebx
        mov dword [byte esp+08h], ecx
        mov dword [byte esp+0Ch], eax
        mov eax, edx
        sar eax, 1
        mov dword [byte esp+010h], eax
        jmp near .9
.1:
        mov dword [byte esp+04h], edx
        jmp short .8
.2:
        mov esi, dword [byte esp+010h]
        sub eax, esi
        mov dword [byte esp+014h], eax
        jmp short .6
.3:
        imul edi, ebp
        add edi, dword [byte esp+0Ch]
        mov eax, dword [byte esp+014h]
        add eax, dword [byte esp+010h]
        imul eax, ebp
        mov esi, dword [byte esp+0Ch]
        add esi, eax
        mov edx, esi
        mov eax, edi
        call dword [byte esp+08h]
        test eax, eax
        jl short .7
        xor ebx, ebx
        jmp short .5
.4:
        mov cl, byte [esi+ebx]
        mov ah, byte [edi+ebx]
        xor ah, cl
        mov byte [edi+ebx], ah
        mov dl, byte [esi+ebx]
        xor dl, ah
        mov byte [esi+ebx], dl
        xor byte [edi+ebx], dl
        inc ebx
.5:
        cmp ebx, ebp
        jl short ShellSortBytes.4
        mov eax, dword [byte esp+010h]
        sub dword [byte esp+014h], eax
.6:
        mov edi, dword [byte esp+014h]
        test edi, edi
        jge short ShellSortBytes.3
.7:
        inc dword [byte esp+04h]
.8:
        mov eax, dword [byte esp+04h]
        cmp eax, dword [esp]
        jl short ShellSortBytes.2
        sar dword [byte esp+010h], 1
.9:
        mov edx, dword [byte esp+010h]
        test edx, edx
        jg short ShellSortBytes.1
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadRosterList_fa                                               6D89A  95 PC
; LoadRosterList entry for the free-agent list.
;-----------------------------------------------------------------------------
; C: src/front/rosters/ShellSortBytes.c (LoadRosterList_fa)
%ifdef CBUILD
%include "c/front/rosters/ShellSortBytes.LoadRosterList_fa.inc"
%else
LoadRosterList_fa:
        mov edx, eax
        shl edx, 2
        sub edx, eax
        shl edx, 2
        add edx, eax
        mov ebx, dword [keydb]
        cmp byte [ebx+edx*4], 0FFh
        jne short .1
        inc dword [facount]
.1:
        inc eax
LoadRosterList_faloop:
        cmp eax, ecx
        jl short LoadRosterList_fa
        push byte 0
        mov edx, dword [facount]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        push eax
        push str_Uar
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [falist], eax
        push byte 0
        mov edx, dword [facount]
        push edx
        push str_Uarm
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [falistsel], eax
        call BuildFreeAgentList
        mov edx, dword [facount]
        mov eax, dword [falist]
        mov ecx, ComparePlayerEntry
        mov ebx, 1Bh
        call ShellSortBytes
        xor eax, eax
        jmp short .4
.3:
        mov edx, dword [falistsel]
        mov byte [edx+eax], 0
        inc eax
.4:
        mov ecx, dword [facount]
        cmp eax, ecx
        jl short LoadRosterList_faloop.3
        xor edi, edi
        mov dword [falisttop], edi
        cmp ecx, byte 1Ch
        jg short .5
        mov dword [FaListScrolls], edi
        jmp short .6
.5:
        mov dword [FaListScrolls], 0FFFFFFFFh
        mov ebx, ecx
        mov edx, 1Ch
        mov eax, fascrollbar
        call InitScrollBar
.6:
        test esi, esi
        jne short .7
        mov dword [menu_r1_tofa], esi
        jmp short .8
.7:
        xor ebx, ebx
        mov dword [menu_r2_tofa], ebx
.8:
        xor esi, esi
        mov dword [menu_r1_toroster2], esi
        mov dword [menu_r2_toroster1], esi
        jmp near RunEditRosters_ret5
%endif ; C
;-----------------------------------------------------------------------------
; LoadRosterList_team                                             6D98E  95 PC
; LoadRosterList entry for a team's roster list.
;-----------------------------------------------------------------------------
; C: src/front/rosters/ShellSortBytes.c (LoadRosterList_team)
%ifdef CBUILD
%include "c/front/rosters/ShellSortBytes.LoadRosterList_team.inc"
%else
LoadRosterList_team:
        xor eax, eax
        mov al, byte [dword esi+rosterteam]
        call CarTeamRecPtr
        mov edx, eax
        mov eax, esi
        shl eax, 2
        mov dword [dword eax+rosterteamptr], edx
        mov ebx, rosterteamrec
        add ebx, eax
        mov edx, esi
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, eax
        shl eax, 6
        sub eax, edx
        mov edi, rosterlist
        add edi, eax
        xor eax, eax
        mov al, byte [dword esi+rosterteam]
        mov edx, edi
        call BuildTeamRosterList
        mov ecx, ComparePlayerEntry
        mov ebx, 1Bh
        mov edx, 1Ch
        mov eax, edi
        call ShellSortBytes
        xor eax, eax
        jmp short .11
.10:
        mov edx, esi
        shl edx, 3
        sub edx, esi
        xor bl, bl
        mov byte [dword eax+edx*4+rostersel], bl
        inc eax
.11:
        cmp eax, byte 1Ch
        jl short LoadRosterList_team.10
        test esi, esi
        jne short .14
        mov dword [menu_r1_tofa], esi
        mov dword [menu_r1_toroster2], esi
        cmp byte [rosterisfa+1], 1
        jne short .12
        mov eax, dword [falistsel]
        jmp short .13
.12:
        mov eax, rostersel+1Ch
.13:
        call CountSelected
        test eax, eax
        je near RunEditRosters_ret5
        mov dword [menu_r2_toroster1], MoveToOtherRoster
        jmp near RunEditRosters_ret5
.14:
        xor ebx, ebx
        mov dword [menu_r2_tofa], ebx
        mov dword [menu_r2_toroster1], ebx
        cmp byte [rosterisfa], 1
        jne short .15
        mov eax, dword [falistsel]
        jmp short .16
.15:
        mov eax, rostersel
.16:
        call CountSelected
        test eax, eax
        je near RunEditRosters_ret5
        mov dword [menu_r1_toroster2], MoveToOtherRoster
        jmp near RunEditRosters_ret5
%endif ; C
;-----------------------------------------------------------------------------
; CountSelected                                                   6DA88  95 PC
; Counts the non-zero selection flags of a panel (falistsel uses facount
; entries, a roster panel 1Ch)
;-----------------------------------------------------------------------------
; C: src/front/rosters/CountSelected.c
%ifdef CBUILD
%include "c/front/rosters/CountSelected.inc"
%else
CountSelected:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        xor ecx, ecx
        mov edx, eax
        cmp eax, dword [falistsel]
        jne short .1
        mov eax, dword [facount]
        jmp short .2
.1:
        mov eax, 1Ch
.2:
        test eax, eax
        jle short .3
        mov ebx, edx
        dec eax
        inc edx
        cmp byte [ebx], 0
        je short CountSelected.2
        inc ecx
        jmp short CountSelected.2
.3:
        mov eax, ecx
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RosterPanelClick                             6DAC3  95 PC, medium confidence
; Mouse click (x, y): picks panel 0 (x 23h-113h) or 1 (x 15Eh-24Eh) and the
; row (y from 35h), toggles that player's selection, then enables 'Move
;
; to Free Agent List' (MoveToFreeAgents) / 'Move to Roster N'
; (MoveToOtherRoster) by the selection count
;-----------------------------------------------------------------------------
RosterPanelClick:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 4
        mov esi, 0FFFFFFFFh
        cmp eax, byte 23h
        jl short .1
        cmp eax, 113h
        jg short .1
        xor esi, esi
        jmp short .2
.1:
        cmp eax, 15Eh
        jl short .2
        cmp eax, 24Eh
        jg short .2
        mov esi, 1
.2:
        test esi, esi
        jl near .16
        cmp edx, byte 35h
        jl near .8
        xor ebx, ebx
        mov bl, byte [TextCharH]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        add eax, byte 35h
        cmp edx, eax
        jge near .8
        sub edx, byte 35h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edi, eax
        mov ecx, eax
        imul ecx, ebx
        add ecx, byte 35h
        cmp byte [dword esi+rosterisfa], 1
        jne short .5
        mov eax, dword [falisttop]
        add eax, edi
        cmp eax, dword [facount]
        jge near .8
        push dword 80h
        push ebx
        push dword 0F0h
        push ecx
        test esi, esi
        je short .3
        mov eax, 15Eh
        jmp short .4
.3:
        mov eax, 23h
.4:
        push eax
        call XorBar
        add esp, byte 14h
        add edi, dword [falisttop]
        mov eax, dword [falistsel]
        mov dl, byte [edi+eax]
        not dl
        mov byte [edi+eax], dl
        jmp short .8
.5:
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        mov edx, eax
        shl eax, 6
        sub eax, edx
        mov dword [byte ebp-04h], eax
        mov edx, edi
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, dword [byte ebp-04h]
        cmp byte [dword eax+rosterlist], 0
        je short .8
        push dword 80h
        push ebx
        push dword 0F0h
        push ecx
        test esi, esi
        je short .6
        mov eax, 15Eh
        jmp short .7
.6:
        mov eax, 23h
.7:
        push eax
        call XorBar
        add esp, byte 14h
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        add edi, eax
        mov al, byte [dword edi+rostersel]
        not al
        mov byte [dword edi+rostersel], al
.8:
        cmp byte [dword esi+rosterisfa], 1
        jne short .9
        mov eax, dword [falistsel]
        jmp short .10
.9:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        add eax, rostersel
.10:
        call CountSelected
        test eax, eax
        jle near .14
        test esi, esi
        jne short .12
        cmp byte [rosterisfa], 1
        je short .11
        cmp dword [facount], byte 1Eh
        jge short .11
        mov dword [menu_r1_tofa], MoveToFreeAgents
.11:
        cmp byte [rosterisfa+1], 1
        je short .16
        mov dword [menu_r1_toroster2], MoveToOtherRoster
        jmp short .16
.12:
        cmp byte [rosterisfa+1], 1
        je short .13
        cmp dword [facount], byte 1Eh
        jge short .13
        mov dword [menu_r2_tofa], MoveToFreeAgents
.13:
        cmp byte [rosterisfa], 1
        je short .16
        mov dword [menu_r2_toroster1], MoveToOtherRoster
        jmp short .16
.14:
        test esi, esi
        jne short .15
        mov dword [menu_r1_tofa], esi
        mov dword [menu_r1_toroster2], esi
        jmp short .16
.15:
        xor ecx, ecx
        mov dword [menu_r2_tofa], ecx
        mov dword [menu_r2_toroster1], ecx
.16:
        mov esp, ebp
RosterPanelClick_ret:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; FixJerseyNumber                                                 6DCBE  95 PC
; 'The jersey number %2d is already used!' / 'Please enter a new jersey
; number for' input dialog for a player moved onto a team
;-----------------------------------------------------------------------------
; C: src/front/rosters/RosterPanelClick.c (FixJerseyNumber)
%ifdef CBUILD
%include "c/front/rosters/RosterPanelClick.FixJerseyNumber.inc"
%else
FixJerseyNumber:
        push dword 0ACh
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 7Ch
        push eax
        mov ebp, edx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, ebp
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        xor edx, edx
        mov dl, byte [dword ebx+eax+rosterslot]
        mov eax, dword [esp]
        mov ebx, dword [nosplit eax*4+rosterteamrec]
        mov eax, edx
        mov eax, dword [byte ebx+eax*4+04Ch]
        call KeyDbPtr
        mov dword [byte esp+07Ch], eax
.1:
        xor edi, edi
        xor edx, edx
        jmp short .4
.2:
        cmp edx, ebp
        je short .3
        mov ebx, dword [esp]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov esi, eax
        shl esi, 6
        sub esi, eax
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        lea ecx, [esi+eax]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov bl, byte [dword ecx+rosterjersey]
        cmp bl, byte [dword esi+eax+rosterjersey]
        jne short .3
        mov edi, 0FFFFFFFFh
.3:
        inc edx
.4:
        cmp edx, byte 1Ch
        jge short .5
        test edi, edi
        je short FixJerseyNumber.2
.5:
        test edi, edi
        je near .6
        mov edx, dword [byte esp+07Ch]
        add edx, byte 3
        lea eax, [byte esp+058h]
        call strcpy_
        mov edx, str_space
        lea eax, [byte esp+058h]
        call strcat_
        mov edx, dword [byte esp+07Ch]
        add edx, byte 13h
        lea eax, [byte esp+058h]
        call strcat_
        xor eax, eax
        mov edx, dword [byte esp+07Ch]
        mov al, byte [byte edx+01h]
        push eax
        push str_TheJerseyNumber2d
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte esp+04h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_PleaseEnterANew
        lea eax, [byte esp+058h]
        mov dword [msglines+8], eax
        xor ah, ah
        mov byte [byte esp+078h], ah
        push byte 0FFFFFFFFh
        push byte 63h
        push byte 0
        push byte 0FFFFFFFFh
        push byte 16h
        mov ecx, 2
        lea ebx, [dword esp+08Ch]
        mov edx, 3
        mov eax, msglines
        call InputDialog
        mov edx, dword [byte esp+07Ch]
        mov byte [byte edx+01h], al
        mov edx, dword [esp]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        mov edx, dword [byte esp+07Ch]
        mov dl, byte [byte edx+01h]
        mov byte [dword ebx+eax+rosterjersey], dl
.6:
        test edi, edi
        jne near FixJerseyNumber.1
        add esp, 80h
        jmp near RosterPanelClick_ret
%endif ; C
;-----------------------------------------------------------------------------
; CopyRoster1Rec                                  6DE4C  95 PC, low confidence
; Unreferenced: rostereditmode = 2, copies 2E8h bytes from the roster-1 team
; record to rosterteamcopy and redraws
;-----------------------------------------------------------------------------
; C: src/front/rosters/CopyRoster1Rec.c
%ifdef CBUILD
%include "c/front/rosters/CopyRoster1Rec.inc"
%else
CopyRoster1Rec:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov dword [rostereditmode], 2
        mov esi, dword [rosterteamrec]
        mov ecx, 0BAh
        mov edi, rosterteamcopy
        rep movsd
        call DrawEditRosters
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadBothRosterLists                                             6DE7E  95 PC
; LoadRosterList(0) then falls into LoadRosterList(1); database_dialogs 732F4
; and EditRosters
;-----------------------------------------------------------------------------
; C: src/front/rosters/ShellSortBytes.c (LoadBothRosterLists)
%ifdef CBUILD
%include "c/front/rosters/ShellSortBytes.LoadBothRosterLists.inc"
%else
LoadBothRosterLists:
        push dword 4
        call __CHK
        xor eax, eax
        call LoadRosterList
        mov eax, 1
;-----------------------------------------------------------------------------
; LoadRosterList                                                  6DE94  95 PC
; (side): free-agent panel frees and rebuilds falist from KEY.DB
; (keydb_size/34h entries),
;
; team panel builds the sorted 1Ch-player list of rosterteam[side]; resets the
; selections and the move menu items
;-----------------------------------------------------------------------------
LoadRosterList:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, eax
        cmp byte [dword eax+rosterisfa], 1
        jne near LoadRosterList_team
        mov edx, dword [falistsel]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [falistsel], ecx
.1:
        mov edi, dword [falist]
        test edi, edi
        je short .2
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [falist], eax
.2:
        mov ebx, 34h
        xor edx, edx
        mov eax, dword [keydb_size]
        div ebx
        mov ecx, eax
        xor edx, edx
        mov dword [facount], edx
        xor eax, eax
        jmp near LoadRosterList_faloop
%endif ; C
;-----------------------------------------------------------------------------
; EditTeamLines                                                   6DF06  95 PC
; 'Edit Team Lines ...' menu item: sets HomeTeam/VisTeam to the panel's team,
; copies its team record into the hmteamrec slot
;
; and runs the line editor DbLineEditor, then restores and redraws
;-----------------------------------------------------------------------------
; C: src/front/rosters/RunEditRosters.c (EditTeamLines)
%ifdef CBUILD
%include "c/front/rosters/RunEditRosters.EditTeamLines.inc"
%else
EditTeamLines:
        push dword 30Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 2F0h
        cmp dword [eax], byte 3
        setne al
        and eax, 0FFh
        mov dword [dword esp+02E8h], eax
        jne short .1
        mov ax, word [HomeTeam]
        mov dword [dword esp+02ECh], eax
        xor eax, eax
        mov al, byte [rosterteam]
        mov word [HomeTeam], ax
        jmp short .2
.1:
        mov ax, word [VisTeam]
        mov dword [dword esp+02ECh], eax
        xor eax, eax
        mov al, byte [rosterteam+1]
        mov word [VisTeam], ax
.2:
        mov ebx, dword [falistsel]
        test ebx, ebx
        je short .3
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [falistsel], esi
.3:
        mov edi, dword [falist]
        test edi, edi
        je short .4
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [falist], eax
.4:
        mov edx, dword [dword esp+02E8h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov ecx, 0BAh
        mov edi, esp
        lea esi, [dword eax+hmteamrec]
        rep movsd
        mov edx, dword [dword esp+02E8h]
        mov edx, dword [nosplit edx*4+rosterteamrec]
        mov ecx, 0BAh
        lea edi, [dword eax+hmteamrec]
        mov esi, edx
        rep movsd
        add edx, 0BCh
        xor eax, eax
        mov al, byte [dword esp+02E8h]
        mov ecx, 3
        mov ebx, dblinesmenubar
        call DbLineEditor
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov ecx, 0BAh
        mov edi, hmteamrec
        mov esi, esp
        rep movsd
        cmp dword [dword esp+02E8h], byte 0
        jne short .5
        mov eax, dword [dword esp+02ECh]
        mov word [HomeTeam], ax
        jmp short .6
.5:
        mov eax, dword [dword esp+02ECh]
        mov word [VisTeam], ax
.6:
        mov ebx, dword [dword esp+02E8h]
        test ebx, ebx
        sete al
        and eax, 0FFh
        cmp byte [dword eax+rosterteam], 0FFh
        jne short .7
        test ebx, ebx
        sete al
        and eax, 0FFh
        call LoadRosterList
.7:
        call DrawEditRosters
        mov ebx, 10h
        mov edx, savepal
        xor eax, eax
        call FadePalStep
        add esp, 2F0h
        jmp near RunEditRosters_ret5
%endif ; C
;-----------------------------------------------------------------------------
; EditRosters                                  6E089  95 PC, medium confidence
; Database_save 6CE03: Edit Rosters screen loop (menubuff menus, panel clicks,
; keys); on exit 'The database has not been saved.
;
; Are you sure you want to exit?'
;-----------------------------------------------------------------------------
EditRosters:
        push dword 0A0h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 7Ch
        mov esi, eax
        mov dword [byte esp+06Ch], ebx
        mov dword [byte esp+068h], ecx
        xor ebx, ebx
        mov dword [byte esp+074h], ebx
        mov dword [dbdirty], ebx
        call LoadBothRosterLists
        call DrawEditRosters
        mov dword [byte esp+018h], esi
        mov dword [byte esp+03Ch], edx
        xor esi, esi
        mov dword [esp], ebx
        mov dword [byte esp+04h], ebx
.1:
        mov eax, esi
        shl eax, 2
        xor ebp, ebp
        mov dword [byte esp+eax+024h], ebp
        mov dword [byte esp+eax+030h], ebp
        test esi, esi
        jle short .2
        mov dword [byte esp+eax+018h], ebp
        mov dword [byte esp+eax+03Ch], ebp
.2:
        inc esi
        cmp esi, byte 3
        jl short EditRosters.1
        mov edx, dword [byte esp+018h]
        mov edx, dword [edx]
        mov eax, dword [byte esp+018h]
        mov esi, dword [byte eax+08h]
        add edx, esi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte esp+064h], eax
        mov dword [byte esp+05Ch], eax
        mov edx, dword [byte esp+018h]
        mov edx, dword [byte edx+04h]
        mov eax, dword [byte esp+018h]
        mov edi, dword [byte eax+0Ch]
        add edx, edi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte esp+060h], eax
        mov dword [byte esp+058h], eax
        push eax
        mov eax, dword [byte esp+068h]
        push eax
        mov edx, dword [editptrspr]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+060h]
        push ebx
        mov ecx, dword [byte esp+068h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        xor eax, eax
        call FadePalStep
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        mov edi, dword [byte esp+060h]
        push edi
        mov ebp, dword [byte esp+068h]
        push ebp
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call ClearInputQueue
.3:
        cmp byte [musicon], 0
        je short .4
        cmp dword [songdata], byte 0
        je short .4
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short .4
        mov edx, dword [songdata]
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebx, ebx
        mov dword [songdata], ebx
.4:
        xor ecx, ecx
        mov dword [byte esp+078h], ecx
.5:
        call GetInputEvent
        mov esi, eax
        test eax, eax
        je short .6
        lea ebx, [byte esp+058h]
        lea edx, [byte esp+05Ch]
        call dword [ptrupdatefn]
        mov dword [byte esp+078h], eax
.6:
        test esi, esi
        je short .7
        test byte [byte esp+078h], 2
        je short EditRosters.5
.7:
        cmp dword [FaListScrolls], byte 0
        je near .13
        cmp byte [rosterisfa], 1
        je short .8
        cmp byte [rosterisfa+1], 1
        jne near .13
.8:
        cmp dword [rostereditmode], byte 2
        je near .13
        mov ebp, dword [byte esp+078h]
        test ebp, ebp
        je near .13
        mov eax, dword [byte esp+060h]
        push eax
        mov edx, dword [byte esp+068h]
        push edx
        mov ebx, dword [editptrspr]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        push ebp
        mov ecx, dword [byte esp+05Ch]
        mov ebx, dword [byte esp+060h]
        mov edx, 2
        mov eax, btn_RosterList
        call TrackButtons
        mov edx, eax
        test eax, eax
        jne short .9
        mov esi, dword [falisttop]
        test esi, esi
        jle short .9
        lea eax, [byte esi-01h]
        mov dword [falisttop], eax
        jmp short .10
.9:
        cmp edx, byte 1
        jne short .11
        mov eax, dword [facount]
        sub eax, byte 1Ch
        mov edi, dword [falisttop]
        cmp eax, edi
        jle short .11
        lea ebp, [edi+edx]
        mov dword [falisttop], ebp
.10:
        call DrawEditRosters
.11:
        mov edx, dword [byte esp+078h]
        push edx
        mov ecx, dword [byte esp+05Ch]
        mov ebx, dword [byte esp+060h]
        mov edx, 1
        mov eax, fascrollbar
        call TrackScrollBars
        test eax, eax
        jl short .12
        mov eax, dword [falisttop]
        mov ebx, dword [fascrollbar_top]
        cmp eax, ebx
        je short .12
        mov dword [falisttop], ebx
        call DrawEditRosters
.12:
        mov ecx, dword [byte esp+058h]
        push ecx
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [editptrspr]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov ebp, dword [byte esp+058h]
        push ebp
        mov eax, dword [byte esp+060h]
        push eax
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+05Ch]
        mov dword [byte esp+064h], eax
        mov eax, dword [byte esp+058h]
        mov dword [byte esp+060h], eax
.13:
        cmp dword [rostereditmode], byte 2
        jne short .14
        test byte [byte esp+078h], 1
        je short .14
        mov ebp, dword [byte esp+060h]
        push ebp
        mov eax, dword [byte esp+068h]
        push eax
        mov edx, dword [editptrspr]
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+078h]
        push ebx
        mov ecx, dword [byte esp+05Ch]
        mov ebx, dword [byte esp+060h]
        mov edx, 2
        mov eax, btn_EditRosters
        call TrackButtons
        mov ecx, dword [byte esp+058h]
        push ecx
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [editptrspr]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov ebp, dword [byte esp+058h]
        push ebp
        mov eax, dword [byte esp+060h]
        push eax
        mov edx, dword [pointerspr]
        push edx
        jmp near .47
.14:
        test byte [byte esp+078h], 2
        jne short .16
        mov eax, dword [byte esp+05Ch]
        cmp eax, dword [byte esp+064h]
        jne short .15
        mov eax, dword [byte esp+058h]
        cmp eax, dword [byte esp+060h]
        je near .48
.15:
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [byte esp+068h]
        push edi
        mov ebp, dword [editptrspr]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte esp+058h]
        push eax
        mov edx, dword [byte esp+060h]
        push edx
        mov ebx, dword [editptrspr]
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, dword [byte esp+058h]
        push ecx
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [pointerspr]
        push edi
        jmp near .47
.16:
        cmp dword [rostereditmode], byte 2
        jne short .18
        mov ecx, dword [byte esp+060h]
        push ecx
        mov esi, dword [byte esp+068h]
        push esi
        mov edi, dword [editptrspr]
        push edi
        call PutBlock
        add esp, byte 0Ch
.17:
        mov ebp, dword [byte esp+060h]
        push ebp
        mov eax, dword [byte esp+068h]
        push eax
        mov edx, dword [editptrspr]
        push edx
        jmp near .46
.18:
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+048h]
        push eax
        mov ecx, dword [dword esp+084h]
        lea ebx, [byte esp+028h]
        mov edx, dword [byte esp+068h]
        mov eax, dword [byte esp+06Ch]
        call MenuHitTest
        test eax, eax
        je near .40
        mov edx, dword [byte esp+054h]
        shl edx, 2
        mov eax, dword [byte esp+050h]
        shl eax, 5
        mov ebx, dword [byte esp+edx+018h]
        add eax, ebx
        cmp dword [byte eax+014h], byte 0
        je near .29
        mov eax, dword [byte esp+050h]
        cmp eax, dword [byte esp+edx+030h]
        jne near .24
        mov eax, dword [byte esp+060h]
        push eax
        mov edx, dword [byte esp+068h]
        push edx
        mov ebx, dword [editptrspr]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov esi, 2
        jmp short .21
.19:
        mov ebp, esi
        shl ebp, 2
        mov edi, dword [byte esp+ebp+024h]
        test edi, edi
        je short .20
        mov eax, dword [byte esp+esi*8+04h]
        push eax
        mov edx, dword [byte esp+esi*8+04h]
        push edx
        push edi
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+04h], ecx
        mov dword [esp+esi*8], ecx
        mov edi, dword [byte esp+ebp+024h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.20:
        dec esi
.21:
        test esi, esi
        jge short EditRosters.19
        xor esi, esi
        mov dword [byte esp+074h], esi
        mov eax, dword [byte esp+054h]
        mov edx, dword [byte esp+050h]
        shl edx, 5
        mov ecx, dword [byte esp+eax*4+018h]
        add ecx, edx
        lea ebx, [byte esp+060h]
        lea edx, [byte esp+064h]
        lea eax, [byte esp+030h]
        call dword [byte ecx+014h]
.22:
        mov eax, esi
        shl eax, 2
        xor ebp, ebp
        mov dword [byte esp+eax+024h], ebp
        test esi, esi
        jle short .23
        mov dword [byte esp+eax+018h], ebp
        mov dword [byte esp+eax+030h], ebp
        mov dword [byte esp+eax+03Ch], ebp
.23:
        inc esi
        cmp esi, byte 3
        jl short EditRosters.22
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [byte esp+068h]
        push edi
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [byte esp+064h]
        mov dword [byte esp+05Ch], eax
        mov eax, dword [byte esp+060h]
        mov dword [byte esp+058h], eax
        call ClearInputQueue
        jmp near EditRosters.17
.24:
        mov ecx, dword [byte esp+060h]
        push ecx
        mov esi, dword [byte esp+068h]
        push esi
        mov edi, dword [editptrspr]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte esp+074h]
        cmp eax, dword [byte esp+054h]
        je short .28
        mov esi, eax
        jmp short .27
.25:
        mov edi, esi
        shl edi, 2
        xor ebp, ebp
        mov dword [byte esp+edi+030h], ebp
        mov eax, dword [byte esp+edi+024h]
        test eax, eax
        je short .26
        mov ebp, esi
        mov edx, dword [byte esp+esi*8+04h]
        push edx
        mov ebx, dword [byte esp+esi*8+04h]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [byte esp+esi*8+04h], eax
        mov dword [esp+esi*8], eax
        mov edx, dword [byte esp+edi+024h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [byte esp+edi+024h], ebx
        mov dword [byte esp+edi+018h], ebx
        xor ebp, esi
        mov dword [byte esp+edi+03Ch], ebp
.26:
        dec esi
.27:
        mov edi, dword [byte esp+054h]
        cmp esi, edi
        jg short EditRosters.25
        mov dword [byte esp+074h], edi
.28:
        mov eax, dword [dword esp+08Ch]
        push eax
        mov edx, dword [byte esp+06Ch]
        push edx
        mov eax, dword [byte esp+05Ch]
        mov ebx, dword [byte esp+eax*8+0Ch]
        mov edx, dword [byte esp+eax*8+08h]
        mov ecx, dword [byte esp+eax*4+038h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+020h]
        add eax, ecx
        mov ecx, dword [byte esp+074h]
        call DrawMenuItemSel
        mov edx, dword [byte esp+054h]
        mov eax, dword [byte esp+050h]
        mov dword [byte esp+edx*4+030h], eax
        mov ebx, dword [dword esp+08Ch]
        push ebx
        mov ecx, dword [byte esp+06Ch]
        push ecx
        mov ebx, dword [byte esp+edx*8+0Ch]
        mov eax, dword [byte esp+edx*8+08h]
        mov esi, dword [byte esp+edx*4+038h]
        shl esi, 5
        mov edx, dword [byte esp+edx*4+020h]
        add esi, edx
        mov ecx, dword [byte esp+074h]
        mov edx, eax
        mov eax, esi
        jmp near .39
.29:
        cmp dword [byte eax+018h], byte 0
        je near .38
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [byte esp+068h]
        push edi
        mov ebp, dword [editptrspr]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte esp+074h]
        cmp eax, dword [byte esp+054h]
        je short .33
        mov esi, eax
        jmp short .32
.30:
        mov edi, esi
        shl edi, 2
        xor edx, edx
        mov dword [byte esp+edi+030h], edx
        mov ebx, dword [byte esp+edi+024h]
        test ebx, ebx
        je short .31
        mov ebp, esi
        mov ecx, dword [byte esp+esi*8+04h]
        push ecx
        mov eax, dword [byte esp+esi*8+04h]
        push eax
        push ebx
        call PutBlock
        add esp, byte 0Ch
        xor ebx, ebx
        mov dword [byte esp+esi*8+04h], ebx
        mov dword [esp+esi*8], ebx
        mov ecx, dword [byte esp+edi+024h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor ebp, esi
        mov dword [byte esp+edi+024h], ebp
        xor eax, eax
        mov dword [byte esp+edi+018h], eax
        mov dword [byte esp+edi+03Ch], eax
.31:
        dec esi
.32:
        mov eax, dword [byte esp+054h]
        cmp esi, eax
        jg short EditRosters.30
        mov dword [byte esp+074h], eax
.33:
        mov ebx, dword [dword esp+08Ch]
        push ebx
        mov ecx, dword [byte esp+06Ch]
        push ecx
        mov esi, dword [byte esp+07Ch]
        mov ebx, dword [byte esp+esi*8+0Ch]
        mov edx, dword [byte esp+esi*8+08h]
        mov edi, esi
        mov eax, dword [byte esp+esi*4+038h]
        shl eax, 5
        mov ecx, dword [byte esp+esi*4+020h]
        add eax, ecx
        mov ecx, dword [byte esp+074h]
        call DrawMenuItemSel
        mov eax, dword [byte esp+050h]
        mov dword [byte esp+esi*4+030h], eax
        mov ebp, dword [dword esp+08Ch]
        push ebp
        mov eax, dword [byte esp+06Ch]
        push eax
        mov ebx, dword [byte esp+esi*8+0Ch]
        mov edx, dword [byte esp+esi*8+08h]
        mov eax, dword [byte esp+058h]
        shl eax, 5
        mov ecx, dword [byte esp+esi*4+020h]
        add eax, ecx
        mov ecx, dword [byte esp+074h]
        call DrawMenuItemNorm
        mov eax, dword [byte esp+054h]
        mov ebx, dword [byte esp+050h]
        shl ebx, 5
        mov esi, dword [byte esp+eax*4+018h]
        mov edx, edi
        inc edx
        mov dword [byte esp+074h], edx
        mov ecx, dword [byte esi+ebx+018h]
        mov dword [byte esp+edx*4+018h], ecx
        mov eax, dword [byte esp+eax*4+018h]
        add eax, ebx
        mov ebx, dword [byte eax+01Ch]
        mov dword [byte esp+edx*4+03Ch], ebx
        cmp edx, byte 1
        je short .34
        mov edx, dword [byte eax+08h]
        jmp short .35
.34:
        mov edx, dword [eax]
.35:
        mov eax, dword [byte esp+074h]
        mov ecx, dword [byte esp+eax*8-08h]
        add edx, ecx
        mov dword [esp+eax*8], edx
        mov edx, dword [byte esp+050h]
        shl edx, 5
        mov eax, dword [byte esp+054h]
        shl eax, 2
        cmp dword [byte esp+074h], byte 1
        je short .36
        mov eax, dword [byte esp+eax+018h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .37
.36:
        mov eax, dword [byte esp+eax+018h]
        mov eax, dword [byte edx+eax+0Ch]
.37:
        mov edx, dword [byte esp+074h]
        shl edx, 3
        mov dword [byte esp+070h], edx
        mov edi, dword [byte esp+edx-04h]
        add eax, edi
        mov dword [byte esp+edx+04h], eax
        mov ebp, dword [byte esp+074h]
        mov edx, dword [byte esp+ebp*4+03Ch]
        shl edx, 5
        mov eax, dword [byte esp+ebp*4+018h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [byte esp+04Ch], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [byte esp+048h], edx
        push byte 0
        mov eax, ebx
        shl eax, 2
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+ebp*4+024h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte esp+ebp*4+024h]
        mov edx, dword [byte esp+04Ch]
        mov word [byte eax+04h], dx
        mov eax, dword [byte esp+ebp*4+024h]
        mov edx, dword [byte esp+048h]
        mov word [byte eax+06h], dx
        mov eax, dword [byte esp+070h]
        mov edx, dword [byte esp+eax+04h]
        push edx
        mov ebx, dword [byte esp+eax+04h]
        push ebx
        mov ecx, dword [byte esp+ebp*4+02Ch]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+08Ch]
        push esi
        mov edi, dword [byte esp+06Ch]
        push edi
        mov eax, dword [byte esp+074h]
        push eax
        mov ecx, dword [byte esp+07Ch]
        mov ecx, dword [byte esp+ecx+010h]
        mov ebx, dword [byte esp+07Ch]
        mov ebx, dword [byte esp+ebx+0Ch]
        mov edx, dword [byte esp+ebp*4+048h]
        mov eax, dword [byte esp+ebp*4+024h]
        call DrawMenuDropdown
        xor edx, edx
        mov dword [byte esp+ebp*4+030h], edx
        push esi
        push edi
        mov ebx, dword [byte esp+078h]
        mov ebx, dword [byte esp+ebx+0Ch]
        mov edx, dword [byte esp+078h]
        mov edx, dword [byte esp+edx+08h]
        mov eax, dword [byte esp+ebp*4+020h]
        mov ecx, dword [byte esp+074h]
        jmp short .39
.38:
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [byte esp+068h]
        push edi
        mov ebp, dword [editptrspr]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+08Ch]
        push eax
        mov edx, dword [byte esp+06Ch]
        push edx
        mov eax, dword [byte esp+05Ch]
        mov ebx, dword [byte esp+eax*8+0Ch]
        mov edx, dword [byte esp+eax*8+08h]
        mov ecx, dword [byte esp+eax*4+038h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+020h]
        add eax, ecx
        mov ecx, dword [byte esp+074h]
        call DrawMenuItemSel
        mov edx, dword [byte esp+054h]
        mov eax, dword [byte esp+050h]
        mov dword [byte esp+edx*4+030h], eax
        mov ebx, dword [dword esp+08Ch]
        push ebx
        mov ecx, dword [byte esp+06Ch]
        push ecx
        mov ebx, dword [byte esp+edx*8+0Ch]
        mov esi, dword [byte esp+edx*8+08h]
        shl eax, 5
        mov edx, dword [byte esp+edx*4+020h]
        add eax, edx
        mov ecx, dword [byte esp+074h]
        mov edx, esi
.39:
        call DrawMenuItemNorm
        jmp near EditRosters.17
.40:
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [byte esp+068h]
        push edi
        mov ebp, dword [editptrspr]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov esi, 2
        jmp short .43
.41:
        mov ebp, esi
        shl ebp, 2
        mov ecx, dword [byte esp+ebp+024h]
        test ecx, ecx
        je short .42
        mov eax, dword [byte esp+esi*8+04h]
        push eax
        mov edx, dword [byte esp+esi*8+04h]
        push edx
        push ecx
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+04h], ecx
        mov dword [esp+esi*8], ecx
        mov edi, dword [byte esp+ebp+024h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.42:
        dec esi
.43:
        test esi, esi
        jge short EditRosters.41
        xor ebx, ebx
        mov dword [byte esp+074h], ebx
        xor esi, esi
.44:
        mov eax, esi
        shl eax, 2
        xor ebp, ebp
        mov dword [byte esp+eax+024h], ebp
        test esi, esi
        jle short .45
        mov dword [byte esp+eax+018h], ebp
        mov dword [byte esp+eax+030h], ebp
        mov dword [byte esp+eax+03Ch], ebp
.45:
        inc esi
        cmp esi, byte 3
        jl short EditRosters.44
        mov edx, dword [byte esp+058h]
        mov eax, dword [byte esp+05Ch]
        call RosterPanelClick
        mov esi, dword [byte esp+060h]
        push esi
        mov edi, dword [byte esp+068h]
        push edi
        mov ebp, dword [editptrspr]
        push ebp
.46:
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+060h]
        push ebx
        mov ecx, dword [byte esp+068h]
        push ecx
        mov esi, dword [editptrspr]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+058h]
        push edi
        mov ebp, dword [byte esp+060h]
        push ebp
        mov eax, dword [editptrspr]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [byte esp+058h]
        push edx
        mov ebx, dword [byte esp+060h]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
.47:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+05Ch]
        mov dword [byte esp+064h], eax
        mov eax, dword [byte esp+058h]
        mov dword [byte esp+060h], eax
.48:
        mov esi, dword [editrosters_exit]
        cmp esi, byte 0FFFFFFFFh
        jne short .49
        mov edi, dword [byte esp+060h]
        push edi
        mov ebp, dword [byte esp+068h]
        push ebp
        mov eax, dword [editptrspr]
        push eax
        call PutBlock
        add esp, byte 0Ch
        cmp dword [dbdirty], byte 0
        je short .49
        mov dword [msglines], str_TheDatabaseHasNot
        mov dword [msglines+4], str_AreYouSureYou
        push esi
        lea eax, [byte esp+05Ch]
        push eax
        lea eax, [byte esp+064h]
        push eax
        push byte 2
        push btn_LeagueExists
        mov ecx, 2
        mov ebx, msglines
        mov edx, esi
        mov eax, esi
        call MessageBox
        test eax, eax
        jg short .49
        xor esi, esi
        mov dword [editrosters_exit], esi
.49:
        cmp dword [editrosters_exit], byte 0
        je near EditRosters.3
        xor eax, eax
        add esp, byte 7Ch
        pop ebp
        pop edi
        pop esi
        ret 4
