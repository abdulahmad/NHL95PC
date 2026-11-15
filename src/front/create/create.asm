; Edit Rosters and Create Player. The roster panel, lines, free agents, ratings, which hand a player
; shoots with, and his jersey number (95G front/create95).
bits 32
%include "hockey.inc"
section s_6CC20 progbits alloc exec nowrite align=1
extern __CHK, __CHP, _dos_getdiskfree_, attdb, attdb_size, boxfillcolor, boxlitecolor, boxshadecolor
extern btn_LeagueExists, BuildFreeAgentList, BuildFreeAgentList_ret, BuildTeamRosterList, byte_C4B6C, teamratingidx, newskatershoots, newgoalieglove
extern byte_D42C3, byte_EAC86, byte_EAF99, byte_EAFB5, careerdb, careerdb_size, CarTeamRecPtr, carteamsdb
extern carteamsdb_size, cddriveptr, ClearInputQueue, curdbname, dbdirty, dbexistsmsg, DbLineEditor, DeleteDir
extern divisionteams, dlgtextbg, dlgtextfg, DrawButtons, DrawDlgFrame, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm
extern DrawMenuItemSel, DrawScrollBar, fp_1000, fp_84, fp_300, fp_390, fp_200, fp_100
extern fp_m50, fp_500, fp_90, fp_10, fp_70, fp_30, fp_58, fp_347
extern dword_C4B69, rostereditmode, fascrollbar_len, fascrollbar_thumb, fascrollbar_top, fascrollbar_count, dword_D0C20, dword_D0CDA
extern dword_EA2B0, dword_EA994, dword_EAF7C, falisttop, editptrspr, editrosters_exit, facount, FadePalStep
extern falist, falistsel, FatalError, FileClose, fileoncd, FileOpenWrite, FileWriteAt, FitPlayerName
extern fputchar, FreeLeagueDbsMem, FreeMemBlock, fullscrbmp, GetInputEvent, hmteamrec, HomeTeam, InitScrollBar
extern InputDialog, j_unlink_, kaufmfont, keydb, keydb_size, KeyDbPtr, leaguedbnames, ListDialog
extern LoadLeagueDbsMem, mainfont, MakePath, memcpy_, memset_, menu_r1_editlines, menu_r1_freeagents, menu_r1_tofa
extern menu_r1_toroster2, menu_r2_editlines, menu_r2_freeagents, menu_r2_tofa, menu_r2_toroster1, MenuHitTest, MessageBox, mkdir_
extern mousepollfn, MouseSetPos, msglines, musichandle, musicon, musicslot, nodiskspacemsg, newskaterratingnames
extern newskaterattrs_m3, newgoalieratingnames, newgoalieattrs_m3, teamratingnames, msg_FreeAgentDiskSpace, pointerspr, PrintCenteredText, PrintFmt1
extern PrintOutlinedText, PrintShadowText, ptrupdatefn, qword_C2CE0, qword_C2CE8, randomd0, RestoreDialogBg, rmdir_
extern roster1divmenus, roster2divmenus, rosterisfa, rosterjersey, rosterlist, rostersel, rosterslot, rosterstat
extern rosterteam, rosterteamptr, rosterteamrec, savedbbtns, savepal, seasondb, seasondb_size, SetDrawBitmap
extern SetTextColors, songdata, sprintf_, str_3dKbytesOfFree, str_3dKbytesOfFree2, str_AddAllSelectedPlayers, str_ANewFreeAgent, str_AreYouSureYou
extern str_C4, str_Center, str_ChooseWhichTeamTo, str_CreateAPlayerOr, str_Current2, str_Current3, str_DATABASE, str_DBX
extern str_Defence, str_DoesNotExist, str_ea, str_ea2, str_EnterAJerseyNumber, str_EnterANewDatabase, str_EnterANewRating, str_EnterAPositionFor
extern str_EnterNameOfPlayer, str_EnterNewGoalieName, str_EnterNewPlayerName, str_ErrDiskFree, str_ErrorGettingDiskSpace, str_ErrorsFoundInDatabases, str_ErrorWhileMakingNew, str_extDB
extern str_fmt2d, str_fmt3d, str_fmtD, str_fmtpd, str_fmtSS, str_ForAllSelectedPlayers, str_FreeAgent, str_FreeAgentList
extern str_FreeAgents, str_GloveHand, str_GloveHandLeftOr, str_Goalie, str_Goalies, str_InTheFreeAgent, str_IsAlreadyDisplayedOn, str_LCRD
extern str_LeftWing, str_Menubuff, str_Move, str_MustBeTheSame, str_NewPlayer, str_NotAddedToDatabases, str_NotEnoughDefence, str_NotEnoughForwards
extern str_NotEnoughGoalies, str_NotEnoughPlayers, str_NotEnoughRatingUnits, str_NotEnoughSpaceFA, str_NotEnoughSpaceTo, str_NotEnoughSpaceTo2, str_Pal, str_Pal2
extern str_Players, str_PlayersAndGoalies, str_PleaseEnterANew, str_Pointer11, str_Prez2, str_Prez22, str_Pst2, str_Pstatbar
extern str_RatingRange, str_Ratings, str_RatingUnitsAvailable3d, str_RightWing, str_Roster1, str_Roster2, str_S5, str_SaveAsGameDatabases
extern str_SavingDatabases, str_Shoots, str_ShootsLeftOrRight, str_space, str_spL, str_spR, str_Temp, str_Temp7
extern str_TheDatabaseHasNot, str_TheDefenceLinesAre, str_TheExtraAttackerLines, str_TheForwardLinesAre, str_TheGoalieLinesAre, str_TheJerseyNumber2d, str_TheNumberOfSelected, str_ThePenaltyKillingLines
extern str_ThePowerPlayLines, str_ThereIsNoSpace, str_TheSelectedPlayer, str_TMP, str_ToFreeAgentList, str_Two, str_Uar, str_Uarm
extern str_XXXKbytesOfFree, str_XXXKbytesOfFree2, strcat_, strcmp_, strcpy_, strlen_, strlwr_, strupr_
extern AllocMemBlock, sub_8D2F0, LoadBank, sub_8E8A0, TextSaveState, TextRestoreState, TextSetFont, SndQuery
extern sub_8FCDF, SetPalette, PutBlock, DrawBitmap, FillRect, XorBar, sub_9121C, DrawArt
extern DrawShape, GrabBlock, PrintString, GetFileSize, WriteFile, KeyDown, SetViewRect, FindShape
extern ClearScreen, sub_B4BA8, SetClipWindow, CreateBitmap, sub_B4FAC, PlotPixel, teamcitynames, teamdivflags
extern TeamRecPtr, teamsdb, teamsdb_size, TextInputDialog, TrackButtons, TrackScrollBars, unk13_6BF3D, editrostersmenubar
extern dblinesmenubar, btn_EditRosters, btn_RosterList, fascrollbar, btn_DBError, btn_CreateFreeAgent, newskaterdefaults, skaterratingmin
extern skaterratingmax, newgoaliedefaults, goalieratingmin, goalieratingmax, tmpdbpath, unk_EAC84, unk_EAFB8, unknown_libname_1
extern VisTeam, str_L9, str_R5, WriteLeagueDbsMem
global RunEditRosters, RunEditRosters_ret6, RunEditRosters_ret5, DrawRosterTitle, DrawRosterList, DrawDatabaseName, DrawRosterPanel, DrawEditRosters
global EditRostersReturn, SelectRosterTeam, ShowFreeAgents, ComparePlayerEntry, ShellSortBytes, LoadRosterList_fa, LoadRosterList_faloop, LoadRosterList_team
global CountSelected, RosterPanelClick, RosterPanelClick_ret, FixJerseyNumber, CopyRoster1Rec, LoadBothRosterLists, LoadRosterList, EditTeamLines
global EditRosters, ErrorScreenWait, DrawDBErrorsScreen, ShowDBError, CheckTeamLines, CheckDatabases, SplitPlayerName, MoveToOtherRoster
global RatingToFloat, RandomizeNewRatings, CreatePlayerNop, DrawShootsField, DrawShootsField_tail, DrawShootsField_pop, DrawGloveField, AskLeftRight
global EditSkaterRating, EditSkaterRating_tail, EditGoalieRating, DrawCreatePlayer, CreatePlayerLoop, CreateFreeAgent, MoveToFreeAgents, RemovePlayerFromTeam
global LoadTempDatabases, DeleteTempDatabases, SwapSelectedPlayers, SelectMatchingPlayers, SetRosterTeamMenus, FindPlayer
;-----------------------------------------------------------------------------
; RunEditRosters                                                  6CC20  95 PC
; Edit Rosters session: dialog colours, music fade, "Current" DBs into memory
; (LoadLeagueDbsMem), enlarged pointer copy, EditRosters, FreeLeagueDbsMem,
; restore
;-----------------------------------------------------------------------------
; C: src/front/create/RunEditRosters.c
%ifdef CBUILD
%include "c/front/create/RunEditRosters.inc"
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
        call sub_8FCDF
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
        call sub_B4BA8
        mov eax, dword [mainfont]
        mov dword [dword_EA2B0], eax
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
        call sub_8D2F0
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
        call sub_8FCDF
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
        call sub_8D2F0
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
; C: src/front/create/DrawRosterTitle.c
%ifdef CBUILD
%include "c/front/create/DrawRosterTitle.inc"
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
; C: src/front/create/DrawRosterList.c
%ifdef CBUILD
%include "c/front/create/DrawRosterList.inc"
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
        mov al, byte [byte_D42C3]
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
        mov al, byte [byte_D42C3]
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
        mov al, byte [byte_D42C3]
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
        mov al, byte [byte_D42C3]
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
        mov al, byte [byte_D42C3]
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
        mov al, byte [byte_D42C3]
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
        mov al, byte [byte_D42C3]
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
        mov al, byte [byte_D42C3]
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
        cmp dword [dword_D0C20], byte 0
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
; C: src/front/create/DrawDatabaseName.c
%ifdef CBUILD
%include "c/front/create/DrawDatabaseName.inc"
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
; C: src/front/create/DrawRosterPanel.c
%ifdef CBUILD
%include "c/front/create/DrawRosterPanel.inc"
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
; panels with 'Ratings:' and jersey numbers); called after every roster
; change and from database_dialogs
;-----------------------------------------------------------------------------
; C: src/front/create/RunEditRosters.c (DrawEditRosters)
%ifdef CBUILD
%include "c/front/create/RunEditRosters.DrawEditRosters.inc"
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
        call sub_B4FAC
        add esp, byte 14h
        push byte 40h
        push dword 153h
        push dword 0B4h
        push dword 8Ch
        push dword 0B4h
        call sub_B4FAC
        add esp, byte 14h
        push byte 42h
        push dword 154h
        push dword 1CCh
        push dword 8Dh
        push dword 1CCh
        call sub_B4FAC
        add esp, byte 14h
        push byte 42h
        push dword 154h
        push dword 1CCh
        push dword 154h
        push dword 0B5h
        call sub_B4FAC
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
        call sub_B4BA8
        mov eax, dword [fullscrbmp]
        mov ecx, dword [byte eax+02Ch]
        push ecx
        call sub_9121C
        add esp, byte 4
        add esp, byte 54h
        jmp near RunEditRosters_ret5
%endif ; C
;-----------------------------------------------------------------------------
; EditRostersReturn                                               6D5BB  95 PC
; 'Return' menu item (frontend_46 menu table): sets editrosters_exit to -1
;-----------------------------------------------------------------------------
; C: src/front/create/EditRostersReturn.c
%ifdef CBUILD
%include "c/front/create/EditRostersReturn.inc"
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
; in rosterteam[side], re-enables the previous team's item and 'Free Agents
; ...', disables the new one, enables 'Edit Team Lines ...', reloads the list
; (LoadRosterList) and redraws
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
; C: src/front/create/RunEditRosters.c (ShowFreeAgents)
%ifdef CBUILD
%include "c/front/create/RunEditRosters.ShowFreeAgents.inc"
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
; C: src/front/create/ComparePlayerEntry.c
%ifdef CBUILD
%include "c/front/create/ComparePlayerEntry.inc"
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
; C: src/front/create/ShellSortBytes.c
%ifdef CBUILD
%include "c/front/create/ShellSortBytes.inc"
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
;-----------------------------------------------------------------------------
; C: src/front/create/ShellSortBytes.c (LoadRosterList_fa)
%ifdef CBUILD
%include "c/front/create/ShellSortBytes.LoadRosterList_fa.inc"
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
        mov dword [dword_D0C20], edi
        jmp short .6
.5:
        mov dword [dword_D0C20], 0FFFFFFFFh
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
;-----------------------------------------------------------------------------
; C: src/front/create/ShellSortBytes.c (LoadRosterList_team)
%ifdef CBUILD
%include "c/front/create/ShellSortBytes.LoadRosterList_team.inc"
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
; C: src/front/create/CountSelected.c
%ifdef CBUILD
%include "c/front/create/CountSelected.inc"
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
; row (y from 35h), toggles that player's selection, then enables 'Move to
; Free Agent List' (MoveToFreeAgents) / 'Move to Roster N'
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
        mov bl, byte [byte_D42C3]
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
; C: src/front/create/RosterPanelClick.c (FixJerseyNumber)
%ifdef CBUILD
%include "c/front/create/RosterPanelClick.FixJerseyNumber.inc"
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
; record to unk_EAFB8 and redraws
;-----------------------------------------------------------------------------
; C: src/front/create/CopyRoster1Rec.c
%ifdef CBUILD
%include "c/front/create/CopyRoster1Rec.inc"
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
        mov edi, unk_EAFB8
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
; C: src/front/create/ShellSortBytes.c (LoadBothRosterLists)
%ifdef CBUILD
%include "c/front/create/ShellSortBytes.LoadBothRosterLists.inc"
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
; (keydb_size/34h entries), team panel builds the sorted 1Ch-player list of
; rosterteam[side]; resets the selections and the move menu items
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
; copies its team record into the hmteamrec slot and runs the line editor
; DbLineEditor, then restores and redraws
;-----------------------------------------------------------------------------
; C: src/front/create/RunEditRosters.c (EditTeamLines)
%ifdef CBUILD
%include "c/front/create/RunEditRosters.EditTeamLines.inc"
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
        call sub_B4BA8
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
; Database_save 6CE03: Edit Rosters screen loop (menubuff menus, panel
; clicks, keys); on exit 'The database has not been saved. Are you sure you
; want to exit?'
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
        call sub_8D2F0
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
        cmp dword [dword_D0C20], byte 0
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
;-----------------------------------------------------------------------------
; ErrorScreenWait                                 6EAB5  95 PC, low confidence
; Mouse/keyboard wait loop used by ShowDBError
;-----------------------------------------------------------------------------
; C: src/front/create/ErrorScreenWait.c
%ifdef CBUILD
%include "c/front/create/ErrorScreenWait.inc"
%else
ErrorScreenWait:
        push dword 3Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        push eax
        push edx
        push ebx
        push ecx
        mov dword [byte esp+018h], 0FFFFFFFFh
        mov esi, dword [eax]
        mov dword [byte esp+014h], esi
        mov edi, dword [byte esp+08h]
        mov edi, dword [edi]
        mov dword [byte esp+010h], edi
        push edi
        push esi
        call MouseSetPos
        add esp, byte 8
        push edi
        push esi
        mov ebx, dword [editptrspr]
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArt
        add esp, byte 0Ch
.1:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short ErrorScreenWait.1
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short ErrorScreenWait.1
        call ClearInputQueue
        xor ebp, ebp
.2:
        call GetInputEvent
        test eax, eax
        je near .9
        lea ebx, [byte esp+010h]
        lea edx, [byte esp+014h]
        call dword [ptrupdatefn]
        mov dword [byte esp+01Ch], eax
        mov ah, byte [byte esp+01Ch]
        test ah, 4
        je short .3
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+018h], edx
        mov ebp, edx
        jmp short .7
.3:
        test ah, 3
        je short .7
        push edi
        push esi
        mov eax, dword [editptrspr]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [esp]
        test edx, edx
        jle short .4
        mov ebx, dword [byte esp+01Ch]
        push ebx
        mov ecx, dword [byte esp+014h]
        mov ebx, dword [byte esp+018h]
        mov eax, dword [byte esp+08h]
        call TrackButtons
        mov dword [byte esp+018h], eax
        test eax, eax
        jl short .6
        jmp short .5
.4:
        test byte [byte esp+01Ch], 2
        je short .6
.5:
        mov ebp, 0FFFFFFFFh
.6:
        push edi
        push esi
        mov ecx, dword [editptrspr]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        push esi
        mov eax, dword [pointerspr]
        push eax
        call DrawArt
        add esp, byte 0Ch
.7:
        cmp esi, dword [byte esp+014h]
        jne short .8
        cmp edi, dword [byte esp+010h]
        je short .9
.8:
        push edi
        push esi
        mov esi, dword [editptrspr]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+010h]
        push edi
        mov eax, dword [byte esp+018h]
        push eax
        mov edx, dword [editptrspr]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+018h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov esi, dword [byte esp+014h]
        mov edi, dword [byte esp+010h]
.9:
        test ebp, ebp
        je near ErrorScreenWait.2
.10:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short ErrorScreenWait.10
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short ErrorScreenWait.10
        call ClearInputQueue
        push edi
        push esi
        mov edi, dword [editptrspr]
        push edi
        call PutBlock
        add esp, byte 0Ch
        call ClearInputQueue
        mov ebp, dword [byte esp+010h]
        push ebp
        mov eax, dword [byte esp+018h]
        push eax
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [byte esp+014h]
        mov edx, dword [byte esp+0Ch]
        mov dword [edx], eax
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+08h]
        mov dword [edx], eax
        mov eax, dword [byte esp+018h]
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawDBErrorsScreen                           6EC95  95 PC, medium confidence
; Draws the 'Errors found in databases!' screen
;-----------------------------------------------------------------------------
; C: src/front/create/DrawDBErrorsScreen.c
%ifdef CBUILD
%include "c/front/create/DrawDBErrorsScreen.inc"
%else
DrawDBErrorsScreen:
        push dword 28h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov esi, edx
        mov edi, ebx
        mov edx, dword [fullscrbmp]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        push byte 41h
        call ClearScreen
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 5
        mov eax, editrostersmenubar
        call DrawMenuBar
        push byte 41h
        push dword 1CDh
        push dword 280h
        push byte 13h
        push byte 0
        call FillRect
        add esp, byte 14h
        mov edx, 2
        mov eax, btn_DBError
        call DrawButtons
        mov dword [byte ebp+00h], 0
        cmp dword [edi], byte 0
        je short .x
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, byte 1Fh
        mov edx, str_ErrorsFoundInDatabases
        call PrintCenteredText
        add dword [esi], byte 2
        mov dword [edi], 0
.x:
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShowDBError                                  6ED39  95 PC, medium confidence
; Prints one error line on the database-errors screen and waits
; (ErrorScreenWait)
;-----------------------------------------------------------------------------
; C: src/front/create/ShowDBError.c
%ifdef CBUILD
%include "c/front/create/ShowDBError.inc"
%else
ShowDBError:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        mov dword [esp], ebx
        mov ebp, ecx
        call sub_B4BA8
        mov eax, dword [fullscrbmp]
        mov edx, dword [byte eax+02Ch]
        push edx
        call sub_9121C
        add esp, byte 4
        mov dword [edi], 0FFFFFFFFh
        mov dword [esi], 0
        mov ecx, 2
        mov ebx, btn_DBError
        mov edx, ebp
        mov eax, dword [esp]
        call ErrorScreenWait
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CheckTeamLines                                                  6ED8F  95 PC
; Checks one team: 'The forward/defence/power play/penalty
; killing/goalie/extra attacker lines are not complete on', 'There are not
; enough players/goalies/forwards/defence on' + team name
;-----------------------------------------------------------------------------
; C: src/front/create/CheckTeamLines.c
%ifdef CBUILD
%include "c/front/create/CheckTeamLines.inc"
%else
CheckTeamLines:
        push dword 78h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 68h
        mov ebp, edx
        mov dword [byte esp+05Ch], ebx
        mov dword [byte esp+054h], ecx
        mov dword [byte esp+064h], 0FFFFFFFEh
        call TeamRecPtr
        mov dword [byte esp+058h], eax
        xor ebx, ebx
        mov dword [byte esp+060h], ebx
        jmp near .20
.1:
        mov dword [byte esp+064h], 0FFFFFFFEh
        mov eax, dword [byte esp+05Ch]
        cmp dword [eax], byte 0
        je short .2
        mov ebx, dword [byte esp+054h]
        mov edx, ebp
        call DrawDBErrorsScreen
.2:
        mov eax, dword [byte esp+060h]
        mov ecx, dword [byte esp+078h]
        and ecx, dword [nosplit eax*4+dword_D0CDA]
        je near .19
        cmp ecx, byte 10h
        jb short .4
        jbe near .11
        cmp ecx, 80h
        jb short .3
        jbe near .14
        cmp ecx, 100h
        jb near .18
        jbe near .15
        cmp ecx, 200h
        je near .16
        jmp near .18
.3:
        cmp ecx, byte 20h
        jb near .18
        jbe near .12
        cmp ecx, byte 40h
        je near .13
        jmp near .18
.4:
        cmp ecx, byte 2
        jb short .5
        jbe short .7
        cmp ecx, byte 4
        jb near .18
        jbe short .8
        cmp ecx, byte 8
        je short .10
        jmp near .18
.5:
        cmp ecx, byte 1
        jne near .18
        mov ecx, 9
        mov edi, esp
        mov esi, str_TheForwardLinesAre
.6:
        rep movsd
        movsw
        movsb
        jmp near .18
.7:
        mov ecx, 9
        mov edi, esp
        mov esi, str_TheDefenceLinesAre
        jmp short CheckTeamLines.6
.8:
        mov ecx, 0Ah
        mov edi, esp
        mov esi, str_ThePowerPlayLines
.9:
        rep movsd
        movsw
        jmp short .18
.10:
        mov ecx, 0Bh
        mov edi, esp
        mov esi, str_ThePenaltyKillingLines
        jmp short CheckTeamLines.6
.11:
        mov ecx, 9
        mov edi, esp
        mov esi, str_TheGoalieLinesAre
        jmp short CheckTeamLines.9
.12:
        mov ecx, 0Bh
        mov edi, esp
        mov esi, str_TheExtraAttackerLines
        jmp short CheckTeamLines.9
.13:
        mov ecx, 8
        mov edi, esp
        mov esi, str_NotEnoughPlayers
        jmp short .17
.14:
        mov ecx, 8
        mov edi, esp
        mov esi, str_NotEnoughGoalies
        jmp short .17
.15:
        mov ecx, 8
        mov edi, esp
        mov esi, str_NotEnoughForwards
        jmp short CheckTeamLines.9
.16:
        mov ecx, 8
        mov edi, esp
        mov esi, str_NotEnoughDefence
.17:
        rep movsd
        movsb
.18:
        mov edx, dword [byte esp+058h]
        add edx, byte 1Ah
        mov eax, esp
        call strcat_
        mov eax, dword [byte ebp+00h]
        mov ecx, eax
        shl ecx, 2
        sub ecx, eax
        shl ecx, 2
        add ecx, eax
        lea eax, [byte ecx+01Fh]
        mov edx, esp
        call PrintCenteredText
        mov ecx, dword [byte ebp+00h]
        inc ecx
        mov dword [byte ebp+00h], ecx
        cmp ecx, byte 1Eh
        jl short .19
        mov ecx, dword [dword esp+080h]
        mov ebx, dword [byte esp+07Ch]
        mov edx, ebp
        mov eax, dword [byte esp+05Ch]
        call ShowDBError
        mov dword [byte esp+064h], eax
.19:
        inc dword [byte esp+060h]
.20:
        cmp dword [byte esp+060h], byte 0Ah
        jge short .21
        mov esi, dword [byte esp+064h]
        cmp esi, byte 1
        je short .21
        cmp esi, byte 0FFFFFFFFh
        jne near CheckTeamLines.1
.21:
        mov eax, dword [byte esp+064h]
        add esp, byte 68h
        pop ebp
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; CheckDatabases                               6EF84  95 PC, medium confidence
; Database_save 6C353: runs CheckTeamLines over the teams and shows the
; errors before saving
;-----------------------------------------------------------------------------
; C: src/front/create/CheckDatabases.c
%ifdef CBUILD
%include "c/front/create/CheckDatabases.inc"
%else
CheckDatabases:
        push dword 48h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        push eax
        push edx
        xor edx, edx
        mov dword [byte esp+010h], edx
        mov ebx, 0FFFFFFFFh
        mov dword [byte esp+014h], ebx
        mov dword [byte esp+0Ch], ebx
        mov dword [byte esp+08h], ebx
        mov dword [byte esp+018h], edx
.1:
        xor ebx, ebx
        xor ebp, ebp
        mov dword [byte esp+020h], ebx
        xor edx, edx
        mov dword [byte esp+01Ch], ebx
        xor edi, edi
        mov eax, dword [byte esp+018h]
        call TeamRecPtr
        mov esi, eax
.2:
        mov eax, edx
        shl eax, 2
        add eax, esi
        mov ecx, dword [byte eax+04Ch]
        cmp ecx, byte 0FFFFFFFFh
        je short .4
        inc ebp
        mov eax, ecx
        call KeyDbPtr
        cmp byte [byte eax+02h], 44h
        jne short .3
        inc edi
        jmp short .4
.3:
        inc dword [byte esp+01Ch]
.4:
        inc edx
        cmp edx, byte 19h
        jl short CheckDatabases.2
        xor edx, edx
.5:
        mov eax, edx
        cmp dword [dword esi+eax*4+0B0h], byte 0FFFFFFFFh
        je short .6
        inc dword [byte esp+020h]
.6:
        inc edx
        cmp edx, byte 3
        jl short CheckDatabases.5
        lea eax, [dword esi+0BCh]
        xor edx, edx
.7:
        cmp byte [edx+eax], 64h
        jne short .8
        or bl, 1
.8:
        inc edx
        cmp edx, byte 0Ch
        jl short CheckDatabases.7
        lea eax, [dword esi+0C8h]
        xor edx, edx
.9:
        cmp byte [edx+eax], 64h
        jne short .10
        or bl, 2
.10:
        inc edx
        cmp edx, byte 6
        jl short CheckDatabases.9
        lea eax, [dword esi+0CEh]
        xor edx, edx
.11:
        cmp byte [edx+eax], 64h
        jne short .12
        or bl, 4
.12:
        inc edx
        cmp edx, byte 0Ah
        jl short CheckDatabases.11
        lea eax, [dword esi+0D8h]
        xor edx, edx
.13:
        cmp byte [edx+eax], 64h
        jne short .14
        or bl, 8
.14:
        inc edx
        cmp edx, byte 8
        jl short CheckDatabases.13
        lea eax, [dword esi+0E0h]
        xor edx, edx
.15:
        cmp byte [edx+eax], 64h
        jne short .16
        or bl, 10h
.16:
        inc edx
        cmp edx, byte 2
        jl short CheckDatabases.15
        lea eax, [dword esi+0E2h]
        xor edx, edx
.17:
        cmp byte [edx+eax], 64h
        jne short .18
        or bl, 20h
.18:
        inc edx
        cmp edx, byte 2
        jl short CheckDatabases.17
        cmp ebp, byte 5
        jge short .19
        or bl, 40h
.19:
        cmp dword [byte esp+01Ch], byte 3
        jge short .20
        or bh, 1
.20:
        cmp edi, byte 2
        jge short .21
        or bh, 2
.21:
        cmp dword [byte esp+020h], byte 2
        jge short .22
        or bl, 80h
.22:
        mov eax, 0FFFFFFFEh
        test ebx, ebx
        je short .23
        xor esi, esi
        mov dword [byte esp+014h], esi
        mov edi, dword [esp]
        push edi
        mov ebp, dword [byte esp+08h]
        push ebp
        push ebx
        lea ecx, [byte esp+014h]
        lea ebx, [byte esp+018h]
        lea edx, [byte esp+01Ch]
        mov eax, dword [byte esp+024h]
        call CheckTeamLines
        mov edx, dword [byte esp+010h]
        test edx, edx
        je short .23
        lea ebx, [byte edx+01h]
        mov dword [byte esp+010h], ebx
.23:
        cmp eax, byte 0FFFFFFFEh
        jne short .25
        mov ecx, dword [byte esp+010h]
        cmp ecx, byte 1Eh
        jge short .24
        test ecx, ecx
        jle short .25
        cmp dword [byte esp+018h], byte 1Bh
        jne short .25
.24:
        mov ecx, dword [esp]
        mov ebx, dword [byte esp+04h]
        lea edx, [byte esp+010h]
        lea eax, [byte esp+0Ch]
        call ShowDBError
.25:
        cmp eax, byte 0FFFFFFFFh
        je short .26
        cmp eax, byte 1
        jne short .27
.26:
        mov dword [byte esp+018h], 1Ch
.27:
        mov eax, dword [byte esp+018h]
        inc eax
        mov dword [byte esp+018h], eax
        cmp eax, byte 1Ch
        jl near CheckDatabases.1
        mov eax, dword [byte esp+014h]
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SplitPlayerName                                                 6F159  95 PC
; Splits a full name at the first non-letter run into first name (max 15) and
; last name using the ctype table (C4B69 bit C0h)
;-----------------------------------------------------------------------------
; C: src/front/create/SplitPlayerName.c
%ifdef CBUILD
%include "c/front/create/SplitPlayerName.inc"
%else
SplitPlayerName:
        push dword 20h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ecx, eax
        mov dword [byte esp+04h], edx
        mov dword [byte esp+08h], ebx
        call strlen_
        mov esi, eax
        xor eax, eax
.1:
        mov dl, byte [ecx+eax]
        inc dl
        and edx, 0FFh
        mov edx, dword [dword edx+byte_C4B6C-3]
        sar edx, 18h
        test dl, 0C0h
        jne short .2
        cmp eax, esi
        jge short .2
        inc eax
        jmp short SplitPlayerName.1
.2:
        xor edx, edx
        mov dword [esp], edx
        jmp short .6
.3:
        lea edi, [ecx+eax]
        mov bl, byte [edi]
        inc bl
        and ebx, 0FFh
        mov ebx, dword [dword ebx+byte_C4B6C-3]
        sar ebx, 18h
        test bl, 0C0h
        je short .4
        mov ebp, dword [byte esp+04h]
        mov bl, byte [edi]
        mov byte [edx+ebp], bl
        inc edx
        jmp short .5
.4:
        mov dword [esp], 0FFFFFFFFh
.5:
        inc eax
.6:
        cmp eax, esi
        jge short .7
        cmp edx, byte 0Fh
        jge short .7
        cmp dword [esp], byte 0
        je short SplitPlayerName.3
.7:
        mov ebx, dword [byte esp+04h]
        mov byte [edx+ebx], 0
        cmp edx, byte 0Fh
        jne short .9
        mov dl, byte [ecx+eax]
        inc dl
        and edx, 0FFh
        mov edx, dword [dword edx+byte_C4B6C-3]
        sar edx, 18h
        test dl, 0C0h
        je short .9
.8:
        mov dl, byte [ecx+eax]
        inc dl
        and edx, 0FFh
        mov edx, dword [dword edx+byte_C4B6C-3]
        sar edx, 18h
        test dl, 0C0h
        je short .9
        cmp eax, esi
        jge short .9
        inc eax
        jmp short SplitPlayerName.8
.9:
        mov dl, byte [ecx+eax]
        inc dl
        and edx, 0FFh
        mov edx, dword [dword edx+byte_C4B6C-3]
        sar edx, 18h
        test dl, 0C0h
        jne short .10
        cmp eax, esi
        jge short .10
        inc eax
        jmp short SplitPlayerName.9
.10:
        xor edx, edx
        mov dword [esp], edx
        jmp short .14
.11:
        lea edi, [ecx+eax]
        mov bl, byte [edi]
        inc bl
        and ebx, 0FFh
        mov ebx, dword [dword ebx+byte_C4B6C-3]
        sar ebx, 18h
        test bl, 0C0h
        je short .12
        mov ebp, dword [byte esp+08h]
        mov bl, byte [edi]
        mov byte [edx+ebp], bl
        inc edx
        jmp short .13
.12:
        mov dword [esp], 0FFFFFFFFh
.13:
        inc eax
.14:
        cmp eax, esi
        jge short .15
        cmp edx, byte 0Fh
        jge short .15
        cmp dword [esp], byte 0
        je short SplitPlayerName.11
.15:
        add edx, dword [byte esp+08h]
        mov byte [edx], 0
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MoveToOtherRoster                                               6F29C  95 PC
; 'Move to Roster N' menu item: moves the selected players to the other
; panel's team ('There is no space to add the selected player' / 'There is
; not enough space to add all selected players'), FixJerseyNumber, reloads
; and redraws
;-----------------------------------------------------------------------------
MoveToOtherRoster:
        push dword 4Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        push edx
        push ebx
        cmp dword [eax], byte 3
        setne al
        and eax, 0FFh
        mov dword [byte esp+010h], eax
        sete al
        mov ecx, eax
        and ecx, 0FFh
        xor ebx, ebx
        mov dword [byte esp+0Ch], ebx
        mov dword [byte esp+014h], ebx
        xor ebp, ebp
        mov eax, dword [byte esp+010h]
        cmp byte [dword eax+rosterisfa], 0
        jne near .14
        mov dword [byte esp+01Ch], ebx
        jmp near .13
.1:
        mov edx, dword [byte esp+010h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        add eax, esi
        cmp byte [dword eax+rostersel], 0
        je near .12
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        sub eax, esi
        inc dword [byte esp+014h]
        lea edx, [ebx+eax]
        mov eax, dword [dword edx+dword_EA994]
        mov dword [byte esp+018h], eax
        call KeyDbPtr
        mov esi, eax
        mov dword [byte esp+020h], 0FFFFFFFFh
        cmp byte [dword edx+rosterlist], 47h
        jne short .5
        xor ebx, ebx
        jmp short .4
.2:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        cmp dword [dword edx+eax*4+0B0h], byte 0FFFFFFFFh
        jne short .3
        lea eax, [byte ebx+019h]
        mov dword [byte esp+020h], eax
.3:
        inc ebx
.4:
        cmp ebx, byte 3
        jge short .9
        cmp dword [byte esp+020h], byte 0
        jl short MoveToOtherRoster.2
        jmp short .9
.5:
        xor ebx, ebx
        jmp short .8
.6:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        cmp dword [byte edx+eax*4+04Ch], byte 0FFFFFFFFh
        jne short .7
        mov dword [byte esp+020h], ebx
.7:
        inc ebx
.8:
        cmp ebx, byte 19h
        jge short .9
        cmp dword [byte esp+020h], byte 0
        jl short MoveToOtherRoster.6
.9:
        cmp dword [byte esp+020h], byte 0
        jl near .12
        mov dword [byte esp+0Ch], 0FFFFFFFFh
        mov al, byte [dword ecx+rosterteam]
        mov byte [esi], al
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, dword [byte esp+020h]
        shl eax, 2
        inc ebp
        add eax, edx
        mov edx, dword [byte esp+018h]
        mov dword [byte eax+04Ch], edx
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte esp+020h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword ebx+eax+rosterstat], 2
        xor eax, eax
        mov edx, dword [byte esp+010h]
        mov al, byte [dword edx+rosterteam]
        mov edx, dword [byte esp+018h]
        call RemovePlayerFromTeam
        xor ebx, ebx
.10:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        mov eax, dword [byte edx+eax*4+04Ch]
        call KeyDbPtr
        mov dl, byte [byte esi+01h]
        cmp dl, byte [byte eax+01h]
        jne short .11
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov edx, eax
        shl eax, 6
        sub eax, edx
        mov dword [byte esp+08h], eax
        mov edi, 1Ch
        sub edi, ebp
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        sub eax, edi
        add eax, dword [byte esp+08h]
        mov dl, byte [byte esi+01h]
        mov byte [dword eax+rosterjersey], dl
        mov dl, byte [byte esp+020h]
        mov byte [dword eax+rosterslot], dl
        mov edx, edi
        mov eax, ecx
        call FixJerseyNumber
.11:
        inc ebx
        cmp ebx, byte 1Ch
        jl short MoveToOtherRoster.10
.12:
        inc dword [byte esp+01Ch]
.13:
        mov esi, dword [byte esp+01Ch]
        cmp esi, byte 1Ch
        jl near MoveToOtherRoster.1
        jmp near .28
.14:
        mov dword [byte esp+01Ch], ebx
        jmp near .27
.15:
        mov eax, dword [falistsel]
        mov ebx, dword [byte esp+01Ch]
        add eax, ebx
        cmp byte [eax], 0
        je near .26
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov eax, dword [falist]
        inc dword [byte esp+014h]
        mov eax, dword [byte edx+eax+04h]
        mov dword [byte esp+018h], eax
        call KeyDbPtr
        mov esi, eax
        mov dword [byte esp+020h], 0FFFFFFFFh
        mov eax, dword [falist]
        cmp byte [edx+eax], 47h
        jne short .19
        xor ebx, ebx
        jmp short .18
.16:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        cmp dword [dword edx+eax*4+0B0h], byte 0FFFFFFFFh
        jne short .17
        lea eax, [byte ebx+019h]
        mov dword [byte esp+020h], eax
.17:
        inc ebx
.18:
        cmp ebx, byte 3
        jge short .23
        cmp dword [byte esp+020h], byte 0
        jl short MoveToOtherRoster.16
        jmp short .23
.19:
        xor ebx, ebx
        jmp short .22
.20:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        cmp dword [byte edx+eax*4+04Ch], byte 0FFFFFFFFh
        jne short .21
        mov dword [byte esp+020h], ebx
.21:
        inc ebx
.22:
        cmp ebx, byte 19h
        jge short .23
        cmp dword [byte esp+020h], byte 0
        jl short MoveToOtherRoster.20
.23:
        cmp dword [byte esp+020h], byte 0
        jl near .26
        mov dword [byte esp+0Ch], 0FFFFFFFFh
        mov al, byte [dword ecx+rosterteam]
        mov byte [esi], al
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, dword [byte esp+020h]
        shl eax, 2
        inc ebp
        add eax, edx
        mov edx, dword [byte esp+018h]
        mov dword [byte eax+04Ch], edx
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte esp+020h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword ebx+eax+rosterstat], 2
        xor ebx, ebx
.24:
        mov eax, dword [nosplit ecx*4+rosterteamrec]
        mov edx, ebx
        mov eax, dword [byte eax+edx*4+04Ch]
        call KeyDbPtr
        mov dl, byte [byte esi+01h]
        cmp dl, byte [byte eax+01h]
        jne short .25
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov edx, eax
        shl eax, 6
        sub eax, edx
        mov dword [byte esp+08h], eax
        mov edi, 1Ch
        sub edi, ebp
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        sub eax, edi
        add eax, dword [byte esp+08h]
        mov dl, byte [byte esi+01h]
        mov byte [dword eax+rosterjersey], dl
        mov dl, byte [byte esp+020h]
        mov byte [dword eax+rosterslot], dl
        mov edx, edi
        mov eax, ecx
        call FixJerseyNumber
.25:
        inc ebx
        cmp ebx, byte 1Ch
        jl short MoveToOtherRoster.24
.26:
        inc dword [byte esp+01Ch]
.27:
        mov eax, dword [byte esp+01Ch]
        cmp eax, dword [facount]
        jl near MoveToOtherRoster.15
.28:
        mov ecx, dword [byte esp+014h]
        cmp ebp, ecx
        je short .31
        cmp ecx, byte 1
        jne short .29
        mov dword [msglines], str_ThereIsNoSpace
        mov dword [msglines+4], str_TheSelectedPlayer
        push byte 0FFFFFFFFh
        mov esi, dword [byte esp+04h]
        push esi
        mov edi, dword [byte esp+0Ch]
        push edi
        jmp short .30
.29:
        mov dword [msglines], str_NotEnoughSpaceTo2
        mov dword [msglines+4], str_AddAllSelectedPlayers
        push byte 0FFFFFFFFh
        mov eax, dword [byte esp+04h]
        push eax
        mov edx, dword [byte esp+0Ch]
        push edx
.30:
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.31:
        cmp dword [byte esp+0Ch], byte 0
        je short .x
        mov dword [dbdirty], 1
        xor eax, eax
        call LoadRosterList
        mov eax, 1
        call LoadRosterList
        call DrawEditRosters
.x:
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; RatingToFloat                                6F6AD  95 PC, medium confidence
; Returns (rating + 5) * 5 as a float (fild)
;-----------------------------------------------------------------------------
; C: src/front/create/RatingToFloat.c
%ifdef CBUILD
%include "c/front/create/RatingToFloat.inc"
%else
RatingToFloat:
        push dword 0Ch
        call __CHK
        push edx
        sub esp, byte 4
        xor edx, edx
        mov dl, al
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov dword [esp], eax
        fild dword [esp]
        add esp, byte 4
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RandomizeNewRatings                          6F6D4  95 PC, medium confidence
; CreateFreeAgent: builds the new player's ratings from the chosen values
; with randomd0 and the C2CAC-C2CF0 float tables (RatingToFloat)
;-----------------------------------------------------------------------------
; C: src/front/create/RandomizeNewRatings.c
%ifdef CBUILD
%include "c/front/create/RandomizeNewRatings.inc"
%else
RandomizeNewRatings:
        push dword 64h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 50h
        mov esi, eax
        xor eax, eax
        mov al, byte [byte edx+01h]
        call RatingToFloat
        fstp dword [byte esp+01Ch]
        xor eax, eax
        mov al, byte [byte edx+02h]
        call RatingToFloat
        fstp dword [byte esp+0Ch]
        xor eax, eax
        mov al, byte [byte edx+04h]
        call RatingToFloat
        fstp dword [byte esp+014h]
        xor eax, eax
        mov al, byte [byte edx+05h]
        call RatingToFloat
        fstp dword [byte esp+02Ch]
        xor eax, eax
        mov al, byte [byte edx+06h]
        call RatingToFloat
        fstp dword [byte esp+024h]
        xor eax, eax
        mov al, byte [byte edx+07h]
        call RatingToFloat
        fstp dword [byte esp+010h]
        xor eax, eax
        mov al, byte [byte edx+09h]
        call RatingToFloat
        fstp dword [byte esp+020h]
        xor eax, eax
        mov al, byte [byte edx+0Ah]
        call RatingToFloat
        fstp dword [byte esp+034h]
        xor eax, eax
        mov al, byte [byte edx+0Bh]
        call RatingToFloat
        fstp dword [byte esp+018h]
        xor eax, eax
        mov al, byte [byte edx+0Ch]
        call RatingToFloat
        fstp dword [byte esp+03Ch]
        xor eax, eax
        mov al, byte [byte edx+0Dh]
        call RatingToFloat
        fstp dword [byte esp+028h]
        xor eax, eax
        mov al, byte [byte edx+0Eh]
        call RatingToFloat
        fstp dword [byte esp+044h]
        xor eax, eax
        mov al, byte [byte edx+013h]
        call RatingToFloat
        fstp dword [byte esp+04Ch]
        mov eax, 14Dh
        call randomd0
        mov dword [byte esp+04Ch], eax
        fild dword [byte esp+04Ch]
        fdiv dword [fp_1000]
        fld1
        fsubrp
        fstp dword [byte esp+040h]
        mov eax, 15h
        call randomd0
        add eax, byte 40h
        mov dword [byte esp+04Ch], eax
        fild dword [byte esp+04Ch]
        fstp dword [byte esp+048h]
        fld dword [byte esp+048h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov word [ebx], ax
        fld dword [byte esp+048h]
        fdiv dword [fp_84]
        fstp dword [byte esp+048h]
        fld dword [byte esp+034h]
        fadd dword [byte esp+028h]
        fadd dword [byte esp+044h]
        fdiv dword [fp_300]
        fmul dword [fp_390]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov word [byte ebx+0Eh], ax
        fld dword [byte esp+034h]
        fadd dword [byte esp+018h]
        fdiv dword [fp_200]
        fmul dword [fp_100]
        fadd dword [fp_m50]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov word [byte ebx+010h], ax
        fld dword [byte esp+0Ch]
        fadd dword [byte esp+034h]
        fadd dword [byte esp+024h]
        fadd dword [byte esp+01Ch]
        fadd dword [byte esp+028h]
        fdiv dword [fp_500]
        fstp dword [byte esp+08h]
        cmp byte [byte esi+02h], 44h
        je short .1
        fld dword [byte esp+044h]
        fdiv dword [fp_70]
        fstp dword [byte esp+038h]
        fld dword [fp_100]
        fsub dword [byte esp+044h]
        fdiv dword [fp_30]
        jmp short .2
.1:
        fld dword [byte esp+044h]
        fdiv dword [fp_90]
        fstp dword [byte esp+038h]
        fld dword [fp_100]
        fsub dword [byte esp+044h]
        fdiv dword [fp_10]
.2:
        fstp dword [byte esp+030h]
        fld1
        fcomp dword [byte esp+038h]
        fnstsw ax
        sahf
        jbe short .3
        fld dword [byte esp+038h]
        fmul dword [fp_58]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        xor ecx, ecx
        mov cx, ax
        jmp short .4
.3:
        mov ecx, 3Ah
.4:
        fld1
        fcomp dword [byte esp+030h]
        fnstsw ax
        sahf
        jbe short .5
        fld dword [byte esp+030h]
        fmul dword [fp_90]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        xor edx, edx
        mov dx, ax
        jmp short .6
.5:
        mov edx, 5Ah
.6:
        fld dword [byte esp+014h]
        fadd dword [byte esp+010h]
        fdiv dword [fp_200]
        xor eax, eax
        mov ax, cx
        mov dword [byte esp+04Ch], eax
        fild dword [byte esp+04Ch]
        fmulp
        fstp dword [byte esp+04h]
        fld dword [byte esp+020h]
        fdiv dword [fp_100]
        xor eax, eax
        mov ax, dx
        mov dword [byte esp+04Ch], eax
        fild dword [byte esp+04Ch]
        fmulp
        fstp dword [esp]
        fld dword [byte esp+08h]
        fmul dword [byte esp+04h]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov ecx, eax
        fld dword [byte esp+08h]
        fmul dword [esp]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov edx, eax
        xor edi, edi
        mov di, cx
        xor esi, esi
        mov si, ax
        lea ebp, [edi+esi]
        cmp ebp, 80h
        jle short .7
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        shl edx, 7
        LD sbb, eax, edx
        sar eax, 7
        mov ebp, eax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebp
        mov ecx, eax
        xor edx, edx
        mov dx, ax
        add edx, esi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 7
        LD sbb, eax, edx
        sar eax, 7
        mov edi, eax
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv edi
        mov edx, eax
.7:
        mov word [byte ebx+02h], cx
        mov word [byte ebx+04h], dx
        mov ax, word [byte ebx+02h]
        add eax, edx
        mov word [byte ebx+06h], ax
        xor edx, edx
        mov dx, word [byte ebx+02h]
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov word [byte ebx+08h], ax
        xor eax, eax
        mov ax, word [byte ebx+08h]
        call randomd0
        mov word [byte ebx+0Ah], ax
        fld dword [byte esp+03Ch]
        fmul qword [qword_C2CE0]
        fstp dword [byte esp+03Ch]
        fld dword [byte esp+02Ch]
        fmul qword [qword_C2CE8]
        fstp dword [byte esp+02Ch]
        fld dword [byte esp+03Ch]
        fadd dword [byte esp+02Ch]
        fdiv dword [fp_100]
        fmul dword [fp_347]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov word [byte ebx+0Ch], ax
        add esp, byte 50h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CreatePlayerNop                                                 6FA72  95 PC
; Empty function (ret only), unreferenced
;-----------------------------------------------------------------------------
; C: src/front/create/CreatePlayerNop.c
%ifdef CBUILD
%include "c/front/create/CreatePlayerNop.inc"
%else
CreatePlayerNop:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawShootsField                                                 6FA7D  95 PC
; Draws 'Shoots' and '  L' / '  R' with its value on the create-player screen
;-----------------------------------------------------------------------------
; C: src/front/create/DrawShootsField.c
%ifdef CBUILD
%include "c/front/create/DrawShootsField.inc"
%else
DrawShootsField:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, 12Ah
        mov dword [byte esp+04h], newskatershoots
        mov ebx, str_Shoots
        mov edx, esi
        mov eax, 1Eh
        call PrintShadowText
        cmp byte [newskatershoots], 0
        je short .1
        mov ebx, str_spL
        jmp short .2
.1:
        mov ebx, str_spR
.2:
        mov edx, esi
        mov eax, 0C8h
        call PrintShadowText
        xor ebp, ebp
        mov edi, 1
        add esi, byte 0Dh
.3:
        cmp edi, byte 8
        jne short .4
        mov ebp, 136h
        sub esi, byte 68h
.4:
        mov ebx, dword [nosplit edi*4+newskaterratingnames]
        lea eax, [byte ebp+01Eh]
        mov edx, esi
        call PrintShadowText
        mov eax, dword [byte esp+04h]
        xor ebx, ebx
        mov bl, byte [edi+eax]
        add ebx, byte 5
        mov ecx, ebx
        shl ecx, 2
        add ecx, ebx
        lea ebx, [dword ebp+0C8h]
        mov dword [esp], ebx
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, dword [esp]
        call PrintFmt1
        add esi, byte 0Dh
        inc edi
        cmp edi, byte 0Fh
        jl short DrawShootsField.3
DrawShootsField_tail:
        add esp, byte 8
DrawShootsField_pop:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawGloveField                                                  6FB35  95 PC
; Draws 'Glove Hand' and '  L' / '  R' on the create-goalie screen
;-----------------------------------------------------------------------------
; C: src/front/create/DrawShootsField.c (DrawGloveField)
%ifdef CBUILD
%include "c/front/create/DrawShootsField.DrawGloveField.inc"
%else
DrawGloveField:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, 12Ah
        mov dword [byte esp+04h], newgoalieglove
        mov ebx, str_GloveHand
        mov edx, esi
        mov eax, 1Eh
        call PrintShadowText
        cmp byte [newgoalieglove], 0
        je short .1
        mov ebx, str_spL
        jmp short .2
.1:
        mov ebx, str_spR
.2:
        mov edx, esi
        mov eax, 0C8h
        call PrintShadowText
        xor ebp, ebp
        mov edi, 1
        add esi, byte 0Dh
.3:
        cmp edi, byte 6
        jne short .4
        mov ebp, 136h
        sub esi, byte 4Eh
.4:
        mov ebx, dword [nosplit edi*4+newgoalieratingnames]
        lea eax, [byte ebp+01Eh]
        mov edx, esi
        call PrintShadowText
        mov eax, dword [byte esp+04h]
        xor ebx, ebx
        mov bl, byte [edi+eax]
        add ebx, byte 5
        mov ecx, ebx
        shl ecx, 2
        add ecx, ebx
        lea ebx, [dword ebp+0C8h]
        mov dword [esp], ebx
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, dword [esp]
        call PrintFmt1
        add esi, byte 0Dh
        inc edi
        cmp edi, byte 0Bh
        jl short DrawGloveField.3
        jmp near DrawShootsField_tail
%endif ; C
;-----------------------------------------------------------------------------
; AskLeftRight                                                    6FBE8  95 PC
; (&flag, prompt): one-key input dialog, L/l sets 1, R/r sets 0
;-----------------------------------------------------------------------------
; C: src/front/create/AskLeftRight.c
%ifdef CBUILD
%include "c/front/create/AskLeftRight.inc"
%else
AskLeftRight:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov esi, eax
        cmp byte [eax], 0
        je short .1
        mov ax, word [str_L9]
        jmp short .2
.1:
        mov ax, word [str_R5]
.2:
        mov word [esp], ax
        mov dword [msglines], edx
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 10h
        mov ecx, 1
        lea ebx, [byte esp+014h]
        mov edx, ecx
        mov eax, msglines
        call InputDialog
        cmp al, 0FFh
        je short .x
        mov dl, byte [esp]
        cmp dl, 4Ch
        je short .3
        cmp dl, 6Ch
        jne short .4
.3:
        mov byte [esi], 1
        jmp short .x
.4:
        cmp dl, 52h
        je short .5
        cmp dl, 72h
        jne short .x
.5:
        mov byte [esi], 0
.x:
        add esp, byte 4
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EditSkaterRating                                                6FC60  95 PC
; Create-player rating click: 'Enter a new rating:' with '%2d < %s < %2d'
; limits, 'Shoots Left or Right?' (AskLeftRight), 'Not enough Rating Units'
;-----------------------------------------------------------------------------
EditSkaterRating:
        push dword 0D4h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 0A0h
        push eax
        push edx
        push ebx
        xor edx, edx
        mov dword [dword esp+098h], edx
        mov dword [dword esp+09Ch], edx
        mov dword [dword esp+0A8h], 12Ah
        xor ebp, ebp
        jmp near .8
.1:
        cmp ebp, byte 8
        jne short .2
        mov dword [dword esp+09Ch], 136h
        sub dword [dword esp+0A8h], byte 68h
.2:
        mov eax, dword [dword esp+09Ch]
        add eax, 0C8h
        mov edx, dword [byte esp+08h]
        mov ebx, dword [edx]
        cmp eax, ebx
        jg near .7
        mov eax, dword [dword esp+09Ch]
        add eax, 0E4h
        cmp eax, ebx
        jle near .7
        mov eax, dword [byte esp+04h]
        mov eax, dword [eax]
        mov esi, dword [dword esp+0A8h]
        cmp eax, esi
        jl near .7
        lea eax, [byte esi+0Dh]
        mov edx, dword [byte esp+04h]
        cmp eax, dword [edx]
        jle near .7
        mov dword [dword esp+098h], 1
        mov dword [dword esp+094h], newskatershoots
        lea edi, [byte esp+040h]
        mov esi, str_EnterANewRating
        movsd
        movsd
        movsd
        movsd
        movsd
        lea eax, [byte esp+040h]
        mov dword [msglines], eax
        mov edi, skaterratingmax
        add edi, ebp
        xor eax, eax
        mov al, byte [edi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        mov ebx, dword [nosplit ebp*4+newskaterratingnames]
        push ebx
        mov eax, skaterratingmin
        add eax, ebp
        mov dword [dword esp+0A8h], eax
        xor eax, eax
        mov edx, dword [dword esp+0A8h]
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push str_RatingRange
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 14h
        lea eax, [byte esp+0Ch]
        mov dword [msglines+4], eax
        mov esi, newskatershoots
        add esi, ebp
        test ebp, ebp
        jne short .3
        mov edx, str_ShootsLeftOrRight
        mov eax, esi
        call AskLeftRight
        jmp near .7
.3:
        xor eax, eax
        mov al, byte [esi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push str_fmtpd
        lea eax, [byte esp+07Ch]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor edx, edx
        mov dl, byte [esi]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov dword [dword esp+0A4h], eax
        push byte 0
        xor eax, eax
        mov al, byte [edi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        xor eax, eax
        mov edx, dword [dword esp+0A8h]
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push byte 0FFFFFFFFh
        push byte 1Ch
        mov ecx, 2
        lea ebx, [dword esp+088h]
        mov edx, ecx
        mov eax, msglines
        call InputDialog
        xor ebx, ebx
        mov bl, al
        cmp ebx, 0FFh
        je near .7
        xor edx, edx
        mov eax, dword [dword esp+0A0h]
        mov dl, byte [eax]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        cmp ebx, eax
        jl near .7
        xor edx, edx
        mov dl, byte [edi]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        cmp ebx, eax
        jg near .7
        mov edi, 5
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        sub eax, edi
        mov ecx, dword [dword esp+0A4h]
        cmp ebx, ecx
        jge short .4
        mov byte [esi], al
        test ebp, ebp
        je near .7
        cmp ebp, byte 3
        je near .7
        cmp ebp, byte 0Dh
        je near .7
        xor eax, eax
        mov al, byte [esi]
        add eax, edi
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        mov eax, ecx
        sub eax, ebx
        mov edx, dword [esp]
        add dword [edx], eax
        jmp near .7
.4:
        mov edx, ebx
        sub edx, ecx
        test ebp, ebp
        je short .6
        cmp ebp, byte 3
        je short .6
        cmp ebp, byte 0Dh
        je short .6
        mov ebx, dword [esp]
        cmp edx, dword [ebx]
        jg short .5
        mov byte [esi], al
        xor eax, eax
        mov al, byte [esi]
        add eax, edi
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        sub ebx, dword [dword esp+0A4h]
        mov eax, dword [esp]
        sub dword [eax], ebx
        jmp short .7
.5:
        mov dword [msglines], str_NotEnoughRatingUnits
        push byte 0FFFFFFFFh
        mov edi, dword [byte esp+08h]
        push edi
        mov eax, dword [byte esp+010h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp short .7
.6:
        mov esi, 5
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        sub eax, esi
        mov dl, al
        mov eax, dword [dword esp+094h]
        mov byte [eax+ebp], dl
.7:
        inc ebp
        add dword [dword esp+0A8h], byte 0Dh
.8:
        cmp ebp, byte 0Fh
        jge short EditSkaterRating_tail
        cmp dword [dword esp+098h], byte 0
        je near EditSkaterRating.1
EditSkaterRating_tail:
        mov eax, dword [dword esp+098h]
        add esp, 0ACh
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; EditGoalieRating                                                6FF69  95 PC
; Goalie version of EditSkaterRating ('Glove hand Left or Right?')
;-----------------------------------------------------------------------------
EditGoalieRating:
        push dword 0D4h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 0A0h
        push eax
        push edx
        push ebx
        xor edx, edx
        mov dword [dword esp+098h], edx
        mov dword [dword esp+09Ch], edx
        mov dword [dword esp+0A8h], 12Ah
        xor ebp, ebp
        jmp near .8
.1:
        cmp ebp, byte 6
        jne short .2
        mov dword [dword esp+09Ch], 136h
        sub dword [dword esp+0A8h], byte 4Eh
.2:
        mov eax, dword [dword esp+09Ch]
        add eax, 0C8h
        mov edx, dword [byte esp+08h]
        mov ebx, dword [edx]
        cmp eax, ebx
        jg near .7
        mov eax, dword [dword esp+09Ch]
        add eax, 0E4h
        cmp eax, ebx
        jle near .7
        mov eax, dword [byte esp+04h]
        mov eax, dword [eax]
        mov esi, dword [dword esp+0A8h]
        cmp eax, esi
        jl near .7
        lea eax, [byte esi+0Dh]
        mov edx, dword [byte esp+04h]
        cmp eax, dword [edx]
        jle near .7
        mov dword [dword esp+098h], 1
        mov dword [dword esp+094h], newgoalieglove
        lea edi, [byte esp+040h]
        mov esi, str_EnterANewRating
        movsd
        movsd
        movsd
        movsd
        movsd
        lea eax, [byte esp+040h]
        mov dword [msglines], eax
        mov edi, goalieratingmax
        add edi, ebp
        xor eax, eax
        mov al, byte [edi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        mov ebx, dword [nosplit ebp*4+newgoalieratingnames]
        push ebx
        mov eax, goalieratingmin
        add eax, ebp
        mov dword [dword esp+0A8h], eax
        xor eax, eax
        mov edx, dword [dword esp+0A8h]
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push str_RatingRange
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 14h
        lea eax, [byte esp+0Ch]
        mov dword [msglines+4], eax
        mov esi, newgoalieglove
        add esi, ebp
        test ebp, ebp
        jne short .3
        mov edx, str_GloveHandLeftOr
        mov eax, esi
        call AskLeftRight
        jmp near .7
.3:
        xor eax, eax
        mov al, byte [esi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push str_fmtpd
        lea eax, [byte esp+07Ch]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor edx, edx
        mov dl, byte [esi]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov dword [dword esp+0A4h], eax
        push byte 0
        xor eax, eax
        mov al, byte [edi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        xor eax, eax
        mov edx, dword [dword esp+0A8h]
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push byte 0FFFFFFFFh
        push byte 1Ch
        mov ecx, 2
        lea ebx, [dword esp+088h]
        mov edx, ecx
        mov eax, msglines
        call InputDialog
        xor ebx, ebx
        mov bl, al
        cmp ebx, 0FFh
        je near .7
        xor edx, edx
        mov eax, dword [dword esp+0A0h]
        mov dl, byte [eax]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        cmp ebx, eax
        jl near .7
        xor edx, edx
        mov dl, byte [edi]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        cmp ebx, eax
        jg near .7
        mov edi, 5
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        sub eax, edi
        mov ecx, dword [dword esp+0A4h]
        cmp ebx, ecx
        jge short .4
        mov byte [esi], al
        test ebp, ebp
        je near .7
        cmp ebp, byte 8
        je near .7
        xor eax, eax
        mov al, byte [esi]
        add eax, edi
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        mov eax, ecx
        sub eax, ebx
        mov edx, dword [esp]
        add dword [edx], eax
        jmp near .7
.4:
        mov edx, ebx
        sub edx, ecx
        test ebp, ebp
        je short .6
        cmp ebp, byte 8
        je short .6
        mov ebx, dword [esp]
        cmp edx, dword [ebx]
        jg short .5
        mov byte [esi], al
        xor eax, eax
        mov al, byte [esi]
        add eax, edi
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        sub ebx, dword [dword esp+0A4h]
        mov eax, dword [esp]
        sub dword [eax], ebx
        jmp short .7
.5:
        mov dword [msglines], str_NotEnoughRatingUnits
        push byte 0FFFFFFFFh
        mov edi, dword [byte esp+08h]
        push edi
        mov eax, dword [byte esp+010h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp short .7
.6:
        mov esi, 5
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        sub eax, esi
        mov dl, al
        mov eax, dword [dword esp+094h]
        mov byte [eax+ebp], dl
.7:
        inc ebp
        add dword [dword esp+0A8h], byte 0Dh
.8:
        cmp ebp, byte 0Fh
        jge near EditSkaterRating_tail
        cmp dword [dword esp+098h], byte 0
        je near EditGoalieRating.1
        jmp near EditSkaterRating_tail
;-----------------------------------------------------------------------------
; DrawCreatePlayer                                                7025B  95 PC
; Draws the create-player screen (pstatbar, 'Free Agent', name, position
; Center/Defence/Left Wing/Right Wing/Goalie, ratings, 'Rating Units
; Available <%3d>')
;-----------------------------------------------------------------------------
; C: src/front/create/DrawCreatePlayer.c
%ifdef CBUILD
%include "c/front/create/DrawCreatePlayer.inc"
%else
DrawCreatePlayer:
        push dword 6Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 44h
        mov ebp, eax
        mov dword [byte esp+040h], edx
        mov edx, dword [fullscrbmp]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Prez22
        cmp byte [fileoncd+01C3h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pal2
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, savepal
        call memcpy_
        push str_ea2
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar
        cmp byte [fileoncd+013Ch], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pst2
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [kaufmfont]
        push ebx
        call TextSetFont
        add esp, byte 4
        mov edx, 42h
        mov eax, 40h
        call SetTextColors
        mov edi, esp
        mov esi, str_FreeAgent
        movsd
        movsd
        movsw
        movsb
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        mov ebx, esp
        mov edx, 52h
        call PrintOutlinedText
        mov edx, 42h
        mov eax, 40h
        call SetTextColors
        lea eax, [byte ebp+013h]
        push eax
        lea eax, [byte ebp+03h]
        push eax
        push str_fmtSS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov edx, esp
        mov eax, 98h
        call PrintCenteredText
        xor eax, eax
        mov al, byte [byte ebp+01h]
        push eax
        push str_fmtD
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov al, byte [byte ebp+02h]
        cmp al, 47h
        jb short .5
        jbe short .10
        cmp al, 4Ch
        jb short .12
        jbe short .8
        cmp al, 52h
        je short .9
        jmp short .12
.5:
        cmp al, 43h
        jb short .12
        jbe short .6
        cmp al, 44h
        je short .7
        jmp short .12
.6:
        mov edx, str_Center
        jmp short .11
.7:
        mov edx, str_Defence
        jmp short .11
.8:
        mov edx, str_LeftWing
        jmp short .11
.9:
        mov edx, str_RightWing
        jmp short .11
.10:
        mov edx, str_Goalie
.11:
        mov eax, esp
        call strcat_
.12:
        mov edx, esp
        mov eax, 0B2h
        call PrintCenteredText
        mov ecx, dword [mainfont]
        push ecx
        call TextSetFont
        add esp, byte 4
        cmp byte [byte ebp+02h], 47h
        jne short .13
        call DrawGloveField
        jmp short .14
.13:
        call DrawShootsField
.14:
        mov esi, dword [byte esp+040h]
        push esi
        push str_RatingUnitsAvailable3d
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, esp
        mov eax, 110h
        call PrintCenteredText
        mov edx, 2
        mov eax, str_Two
        call DrawButtons
        call sub_B4BA8
        mov eax, dword [fullscrbmp]
        mov edi, dword [byte eax+02Ch]
        push edi
        call DrawBitmap
        add esp, byte 4
        add esp, byte 44h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CreatePlayerLoop                             704A6  95 PC, medium confidence
; Create-player screen loop: DrawCreatePlayer, mouse clicks to
; EditSkaterRating / EditGoalieRating
;-----------------------------------------------------------------------------
; C: src/front/create/DrawShootsField.c (CreatePlayerLoop)
%ifdef CBUILD
%include "c/front/create/DrawShootsField.CreatePlayerLoop.inc"
%else
CreatePlayerLoop:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        mov ebp, eax
        mov dword [byte esp+08h], 118h
        xor ebx, ebx
        mov dword [byte esp+014h], ebx
        push byte 20h
        push dword 300h
        push str_Temp
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov dword [byte esp+0Ch], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        cmp byte [byte ebp+02h], 47h
        jne short .1
        mov dword [byte esp+08h], 104h
        mov edi, newgoalieglove
        mov esi, newgoaliedefaults
        movsd
        movsd
        movsd
        movsd
        jmp short .2
.1:
        mov edi, newskatershoots
        mov esi, newskaterdefaults
        movsd
        movsd
        movsd
        movsd
        movsd
.2:
        mov edx, dword [byte esp+08h]
        mov eax, ebp
        call DrawCreatePlayer
        mov esi, 0F0h
        push esi
        mov edi, 140h
        push edi
        mov eax, dword [editptrspr]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        push esi
        push edi
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, dword [byte esp+0Ch]
        xor eax, eax
        call FadePalStep
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov dword [esp], esi
        push esi
        mov dword [byte esp+08h], edi
        push edi
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call ClearInputQueue
.3:
        xor edx, edx
        mov dword [byte esp+018h], edx
.4:
        call GetInputEvent
        mov ecx, eax
        test eax, eax
        je short .5
        mov ebx, esp
        lea edx, [byte esp+04h]
        call dword [ptrupdatefn]
        mov dword [byte esp+018h], eax
.5:
        test ecx, ecx
        je short .6
        test byte [byte esp+018h], 2
        je short CreatePlayerLoop.4
.6:
        test byte [byte esp+018h], 2
        jne short .8
        cmp edi, dword [byte esp+04h]
        jne short .7
        cmp esi, dword [esp]
        je near .14
.7:
        push esi
        push edi
        mov ebx, dword [editptrspr]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [esp]
        push ecx
        mov esi, dword [byte esp+08h]
        push esi
        mov edi, dword [editptrspr]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [esp]
        push eax
        mov edx, dword [byte esp+08h]
        push edx
        mov ebx, dword [pointerspr]
        push ebx
        jmp near .13
.8:
        push esi
        push edi
        mov ebx, dword [editptrspr]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        cmp byte [byte ebp+02h], 47h
        jne short .9
        lea ebx, [byte esp+08h]
        mov edx, esp
        lea eax, [byte esp+04h]
        call EditGoalieRating
        jmp short .10
.9:
        lea ebx, [byte esp+08h]
        mov edx, esp
        lea eax, [byte esp+04h]
        call EditSkaterRating
.10:
        test eax, eax
        je short .11
        mov edx, dword [byte esp+08h]
        mov eax, ebp
        call DrawCreatePlayer
        jmp short .12
.11:
        mov ecx, dword [byte esp+018h]
        push ecx
        mov ecx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov edx, 2
        mov eax, str_Two
        call TrackButtons
        mov dword [byte esp+010h], eax
        test eax, eax
        jl short .12
        mov dword [byte esp+014h], 1
.12:
        mov edi, dword [esp]
        push edi
        mov eax, dword [byte esp+08h]
        push eax
        mov edx, dword [editptrspr]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [esp]
        push ebx
        mov ecx, dword [byte esp+08h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
.13:
        call DrawArt
        add esp, byte 0Ch
        mov edi, dword [byte esp+04h]
        mov esi, dword [esp]
.14:
        cmp dword [byte esp+014h], byte 0
        je near CreatePlayerLoop.3
        mov eax, dword [byte esp+010h]
        add esp, byte 1Ch
        jmp near DrawShootsField_pop
%endif ; C
;-----------------------------------------------------------------------------
; CreateFreeAgent                                                 706E2  95 PC
; 'Create Free Agent ...' menu item: disk-space check ('Not enough space to
; create a new free agent.'), 'Enter the name of the new player/goalie',
; 'Enter a position for (L,C,R,D)', 'Enter a jersey number for',
; CreatePlayerLoop, writes the player into .TMP database copies ('Error while
; making new databases!')
;-----------------------------------------------------------------------------
; C: src/front/create/CreateFreeAgent.c
%ifdef CBUILD
%include "c/front/create/CreateFreeAgent.inc"
%else
CreateFreeAgent:
        push dword 20Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 1DCh
        push edx
        push ebx
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+01DCh], edx
        mov dword [dword esp+01D8h], edx
        mov dword [dword esp+01D4h], edx
        mov dword [dword esp+01E0h], edx
        lea edx, [dword esp+01CCh]
        xor eax, eax
        call _dos_getdiskfree_
        test eax, eax
        je short .1
        push str_ErrDiskFree
        call FatalError
        add esp, byte 4
.1:
        xor esi, esi
        mov si, word [dword esp+01D0h]
        xor eax, eax
        mov ax, word [dword esp+01D2h]
        imul esi, eax
        mov eax, dword [seasondb_size]
        add eax, byte 36h
        mov dword [dword esp+018Ch], eax
        mov eax, dword [careerdb_size]
        add eax, byte 2Ch
        mov dword [dword esp+0190h], eax
        mov eax, dword [attdb_size]
        add eax, byte 14h
        mov dword [dword esp+01A0h], eax
        mov eax, dword [keydb_size]
        add eax, byte 34h
        mov dword [dword esp+0198h], eax
        mov eax, dword [carteamsdb_size]
        mov dword [dword esp+0194h], eax
        mov eax, dword [teamsdb_size]
        mov dword [dword esp+019Ch], eax
        xor edi, edi
        mov dword [dword esp+01A4h], edi
        xor ecx, ecx
        xor ebx, ebx
.2:
        mov edx, dword [dword esp+ebx*4+018Ch]
        add edx, esi
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        add ecx, eax
        inc ebx
        cmp ebx, byte 6
        jl short CreateFreeAgent.2
        xor eax, eax
        mov ax, word [dword esp+01CEh]
        cmp ecx, eax
        jle short .4
        mov edx, ecx
        imul edx, esi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        push eax
        push str_3dKbytesOfFree
        push str_XXXKbytesOfFree
        call sprintf_
        add esp, byte 0Ch
        push dword 320h
        mov edi, dword [byte esp+04h]
        push edi
        mov ebp, dword [byte esp+0Ch]
        push ebp
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_FreeAgentDiskSpace
.3:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .x
.4:
        cmp dword [facount], byte 1Eh
        jl short .5
        mov dword [msglines], str_NotEnoughSpaceTo
        mov dword [msglines+4], str_ANewFreeAgent
        push byte 0FFFFFFFFh
        mov ecx, dword [byte esp+04h]
        push ecx
        mov esi, dword [byte esp+0Ch]
        push esi
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        jmp short CreateFreeAgent.3
.5:
        mov dword [msglines], str_CreateAPlayerOr
        push byte 0FFFFFFFFh
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push byte 2
        push btn_CreateFreeAgent
        mov ecx, 1
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov esi, eax
        test eax, eax
        jl near .x
        jne short .6
        mov dword [msglines], str_EnterNewPlayerName
        jmp short .7
.6:
        mov dword [msglines], str_EnterNewGoalieName
.7:
        xor ah, ah
        mov byte [dword esp+014Ch], ah
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push dword 0BAh
        mov ecx, 1Fh
        lea ebx, [dword esp+0160h]
        mov edx, 1
        mov eax, msglines
        call InputDialog
        cmp eax, byte 0FFFFFFFFh
        je near .x
        lea eax, [dword esp+014Ch]
        call strlen_
        test eax, eax
        je near .x
        xor dl, dl
        mov byte [dword esp+097h], dl
        mov byte [dword esp+0A7h], dl
        lea ebx, [dword esp+0A7h]
        lea edx, [dword esp+097h]
        lea eax, [dword esp+014Ch]
        call SplitPlayerName
        lea edx, [dword esp+097h]
        lea eax, [dword esp+016Ch]
        call strcpy_
        mov edx, str_space
        lea eax, [dword esp+016Ch]
        call strcat_
        lea edx, [dword esp+0A7h]
        lea eax, [dword esp+016Ch]
        call strcat_
        test esi, esi
        jne near .11
        mov dword [msglines], str_EnterAPositionFor
        lea eax, [dword esp+016Ch]
        mov dword [msglines+4], eax
        mov dword [msglines+8], str_LCRD
        xor bh, bh
        mov byte [dword esp+014Ch], bh
.8:
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0Eh
        mov ecx, 1
        lea ebx, [dword esp+0160h]
        mov edx, 3
        mov eax, msglines
        call InputDialog
        cmp eax, byte 0FFFFFFFFh
        je near .x
        lea eax, [dword esp+014Ch]
        call strlen_
        test eax, eax
        je near .x
        lea eax, [dword esp+014Ch]
        call strupr_
        mov cl, byte [dword esp+014Ch]
        cmp cl, 43h
        je short .9
        cmp cl, 4Ch
        je short .9
        cmp cl, 52h
        je short .9
        cmp cl, 44h
        je short .9
        mov eax, 1
        jmp short .10
.9:
        xor eax, eax
.10:
        test eax, eax
        setne al
        and eax, 0FFh
        jne short CreateFreeAgent.8
        mov ebx, 1
        lea edx, [dword esp+014Ch]
        lea eax, [dword esp+096h]
        call memcpy_
        jmp short .12
.11:
        mov byte [dword esp+096h], 47h
.12:
        mov eax, dword [seasondb_size]
        mov dword [dword esp+0C0h], eax
        mov eax, dword [careerdb_size]
        mov dword [dword esp+0BCh], eax
        mov eax, dword [attdb_size]
        mov dword [dword esp+0B8h], eax
        mov ebx, 4
        xor edx, edx
        lea eax, [dword esp+0C4h]
        call memset_
        mov dword [msglines], str_EnterAJerseyNumber
        lea eax, [dword esp+016Ch]
        mov dword [msglines+4], eax
        xor dl, dl
        mov byte [dword esp+014Ch], dl
        push byte 0
        push byte 63h
        push byte 0
        push byte 0FFFFFFFFh
        push byte 16h
        mov ecx, 2
        lea ebx, [dword esp+0160h]
        mov edx, ecx
        mov eax, msglines
        call InputDialog
        test eax, eax
        jl near .x
        mov byte [dword esp+095h], al
        mov byte [dword esp+094h], 0FFh
        push byte 20h
        push dword 300h
        push str_Temp
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov edi, eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        lea eax, [dword esp+094h]
        call CreatePlayerLoop
        cmp eax, byte 1
        jl near .26
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov eax, str_TMP
        call WriteLeagueDbsMem
        mov ebx, dword [leaguedbnames]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        lea edx, [dword esp+01DCh]
        mov eax, tmpdbpath
        call FileOpenWrite
        mov ebx, eax
        test eax, eax
        jne short .13
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        lea edx, [dword esp+01D8h]
        mov eax, tmpdbpath
        call FileOpenWrite
        mov ebx, eax
.13:
        test ebx, ebx
        jne short .14
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        lea edx, [dword esp+01D4h]
        mov eax, tmpdbpath
        call FileOpenWrite
        mov ebx, eax
.14:
        test ebx, ebx
        jne short .15
        mov ebx, dword [leaguedbnames+8]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        lea edx, [dword esp+01E0h]
        mov eax, tmpdbpath
        call FileOpenWrite
        mov ebx, eax
.15:
        test ebx, ebx
        jne near .23
        cmp byte [dword esp+096h], 47h
        je near .18
        mov ebx, 2Fh
        xor edx, edx
        lea eax, [dword esp+0C8h]
        call memset_
        mov ebx, 28h
        xor edx, edx
        lea eax, [dword esp+0124h]
        call memset_
        mov ecx, 2Fh
        mov ebx, dword [dword esp+0C0h]
        lea edx, [dword esp+0C8h]
        mov eax, dword [dword esp+01D8h]
        call FileWriteAt
        mov ebx, eax
        test eax, eax
        jne short .17
        lea ecx, [dword esp+01A8h]
        mov esi, newskatershoots
.16:
        mov ebx, dword [dword eax+newskaterattrs_m3]
        sar ebx, 18h
        mov dl, byte [esi+eax]
        mov byte [ecx+ebx], dl
        inc eax
        cmp eax, byte 0Fh
        jl short CreateFreeAgent.16
        lea ebx, [dword esp+0124h]
        lea edx, [dword esp+01A8h]
        lea eax, [dword esp+094h]
        call RandomizeNewRatings
        mov ecx, 28h
        mov ebx, dword [dword esp+0BCh]
        lea edx, [dword esp+0124h]
        mov eax, dword [dword esp+01D4h]
        call FileWriteAt
        mov ebx, eax
.17:
        test ebx, ebx
        jne near .22
        mov ecx, 14h
        mov ebx, dword [dword esp+0B8h]
        lea edx, [dword esp+01A8h]
        jmp near .21
.18:
        mov ebx, 36h
        xor edx, edx
        lea eax, [byte esp+05Ch]
        call memset_
        mov ebx, 2Ch
        xor edx, edx
        lea eax, [dword esp+0F8h]
        call memset_
        mov ecx, 36h
        mov ebx, dword [dword esp+0C0h]
        lea edx, [byte esp+05Ch]
        mov eax, dword [dword esp+01D8h]
        call FileWriteAt
        mov ebx, eax
        test eax, eax
        jne short .20
        lea esi, [dword esp+01BCh]
        mov ecx, newgoalieglove
.19:
        mov edx, dword [dword eax+newgoalieattrs_m3]
        sar edx, 18h
        mov bl, byte [ecx+eax]
        mov byte [edx+esi], bl
        inc eax
        cmp eax, byte 0Bh
        jl short CreateFreeAgent.19
        mov ecx, 2Ch
        mov ebx, dword [dword esp+0BCh]
        lea edx, [dword esp+0F8h]
        mov eax, dword [dword esp+01D4h]
        call FileWriteAt
        mov ebx, eax
.20:
        test ebx, ebx
        jne short .22
        mov ecx, 10h
        mov ebx, dword [dword esp+0B8h]
        lea edx, [dword esp+01BCh]
.21:
        mov eax, dword [dword esp+01E0h]
        call FileWriteAt
        mov ebx, eax
.22:
        test ebx, ebx
        jne short .23
        mov ebx, dword [keydb_size]
        mov ecx, 34h
        lea edx, [dword esp+094h]
        mov eax, dword [dword esp+01DCh]
        call FileWriteAt
        mov ebx, eax
.23:
        lea eax, [dword esp+01E0h]
        call FileClose
        lea eax, [dword esp+01D4h]
        call FileClose
        lea eax, [dword esp+01D8h]
        call FileClose
        lea eax, [dword esp+01DCh]
        call FileClose
        test ebx, ebx
        jne short .24
        call LoadTempDatabases
        xor eax, eax
        call LoadRosterList
        mov eax, 1
        call LoadRosterList
.24:
        call DeleteTempDatabases
        test ebx, ebx
        je short .25
        mov dword [msglines], str_ErrorWhileMakingNew
        mov edx, str_NewPlayer
        lea eax, [byte esp+08h]
        call strcpy_
        mov edx, str_NotAddedToDatabases
        lea eax, [byte esp+08h]
        call strcat_
        mov ebx, 10h
        mov edx, edi
        xor eax, eax
        call FadePalStep
        lea eax, [byte esp+08h]
        mov dword [msglines+4], eax
        push byte 0FFFFFFFFh
        mov ecx, dword [byte esp+04h]
        push ecx
        mov esi, dword [byte esp+0Ch]
        push esi
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ebx, 10h
        mov edx, edi
        jmp short .27
.25:
        mov dword [dbdirty], 1
        jmp short .28
.26:
        mov ebx, 10h
        mov edx, esi
.27:
        mov eax, 1
        call FadePalStep
.28:
        call DrawEditRosters
        mov ebx, 10h
        mov edx, edi
        xor eax, eax
        call FadePalStep
        push edi
        call FreeMemBlock
        add esp, byte 4
.x:
        add esp, 1E4h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MoveToFreeAgents                                                70E8D  95 PC
; 'Move to Free Agent List' menu item: 'Move <name> to free agent list?',
; 'There is not enough space in the free agent list for all selected
; players', RemovePlayerFromTeam, reload and redraw
;-----------------------------------------------------------------------------
; C: src/front/create/MoveToFreeAgents.c
%ifdef CBUILD
%include "c/front/create/MoveToFreeAgents.inc"
%else
MoveToFreeAgents:
        push dword 64h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        push edx
        push ebx
        xor edx, edx
        mov dword [byte esp+030h], edx
        mov dword [byte esp+028h], edx
        mov dword [byte esp+034h], edx
        cmp dword [eax], byte 3
        setne al
        and eax, 0FFh
        mov esi, eax
        sete al
        and eax, 0FFh
        mov dword [byte esp+02Ch], eax
        xor ebp, ebp
.1:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        cmp byte [dword ebp+eax*4+rostersel], 0
        je near .2
        inc dword [byte esp+028h]
        cmp dword [facount], byte 1Eh
        jge near .2
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        mov edx, eax
        shl edx, 6
        sub edx, eax
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        inc dword [byte esp+034h]
        mov eax, dword [dword edx+eax+dword_EA994]
        mov dword [byte esp+038h], eax
        call KeyDbPtr
        mov edi, eax
        mov dword [msglines], str_Move
        lea edx, [byte eax+03h]
        lea eax, [byte esp+08h]
        call strcpy_
        mov edx, str_space
        lea eax, [byte esp+08h]
        call strcat_
        lea edx, [byte edi+013h]
        lea eax, [byte esp+08h]
        call strcat_
        lea eax, [byte esp+08h]
        mov dword [msglines+4], eax
        mov dword [msglines+8], str_ToFreeAgentList
        push byte 0FFFFFFFFh
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push byte 2
        push btn_LeagueExists
        mov ecx, 3
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        cmp eax, byte 1
        jne short .2
        mov dword [byte esp+030h], eax
        cmp byte [dword esi+rosterteam], 1Ah
        jae short .2
        mov byte [edi], 0FFh
        xor eax, eax
        mov al, byte [dword esi+rosterteam]
        mov edx, dword [byte esp+038h]
        call RemovePlayerFromTeam
.2:
        inc ebp
        cmp ebp, byte 1Ch
        jl near MoveToFreeAgents.1
        mov eax, dword [byte esp+028h]
        cmp eax, dword [byte esp+034h]
        je short .3
        mov dword [msglines], str_NotEnoughSpaceFA
        mov dword [msglines+4], str_InTheFreeAgent
        mov dword [msglines+8], str_ForAllSelectedPlayers
        push byte 0FFFFFFFFh
        mov ebx, dword [byte esp+04h]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.3:
        cmp dword [byte esp+030h], byte 0
        je short .x
        mov dword [dbdirty], 1
        mov eax, esi
        call LoadRosterList
        mov eax, dword [byte esp+02Ch]
        cmp byte [dword eax+rosterisfa], 1
        jne short .4
        call LoadRosterList
.4:
        call DrawEditRosters
.x:
        add esp, byte 3Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RemovePlayerFromTeam                         71043  95 PC, medium confidence
; Finds the player (name keys +24h/+28h/+2Ch) in the team's 1Ch roster slots
; (+4Ch), clears it (-1), facount++, and replaces it in the line table
; (+0BCh, 30h bytes) with 64h
;-----------------------------------------------------------------------------
; C: src/front/create/RemovePlayerFromTeam.c
%ifdef CBUILD
%include "c/front/create/RemovePlayerFromTeam.inc"
%else
RemovePlayerFromTeam:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        and eax, 0FFh
        call TeamRecPtr
        mov edi, eax
        mov eax, edx
        call KeyDbPtr
        mov ebx, eax
        mov dh, 0FFh
        xor dl, dl
        jmp short .3
.1:
        xor ecx, ecx
        mov cl, dl
        shl ecx, 2
        add ecx, edi
        mov eax, dword [byte ecx+04Ch]
        call KeyDbPtr
        mov esi, dword [byte ebx+024h]
        cmp esi, dword [byte eax+024h]
        jne short .2
        mov esi, dword [byte ebx+028h]
        cmp esi, dword [byte eax+028h]
        jne short .2
        mov esi, dword [byte ebx+02Ch]
        cmp esi, dword [byte eax+02Ch]
        jne short .2
        inc dword [facount]
        mov dword [byte ecx+04Ch], 0FFFFFFFFh
        mov dh, dl
.2:
        inc dl
.3:
        cmp dl, 1Ch
        jae short .4
        cmp dh, 0FFh
        je short RemovePlayerFromTeam.1
.4:
        cmp dh, 0FFh
        je short .x
        lea esi, [dword edi+0BCh]
        xor dl, dl
        jmp short .7
.5:
        xor eax, eax
        mov al, dl
        add eax, esi
        cmp dh, byte [eax]
        jne short .6
        mov byte [eax], 64h
.6:
        inc dl
.7:
        cmp dl, 30h
        jb short RemovePlayerFromTeam.5
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadTempDatabases                            710D8  95 PC, medium confidence
; Loads the league databases' .TMP copies into buffers
; (carteamsdb/D07CB/D07CF with sizes D07DB/D07E3/D07E7)
;-----------------------------------------------------------------------------
; C: src/front/create/LoadTempDatabases.c
%ifdef CBUILD
%include "c/front/create/LoadTempDatabases.inc"
%else
LoadTempDatabases:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        call FreeLeagueDbsMem
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call sub_8E8A0
        add esp, byte 8
        mov dword [seasondb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [seasondb_size], eax
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call sub_8E8A0
        add esp, byte 8
        mov dword [careerdb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [careerdb_size], eax
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call sub_8E8A0
        add esp, byte 8
        mov dword [carteamsdb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [carteamsdb_size], eax
        mov ebx, dword [leaguedbnames]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call sub_8E8A0
        add esp, byte 8
        mov dword [keydb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [keydb_size], eax
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call sub_8E8A0
        add esp, byte 8
        mov dword [teamsdb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [teamsdb_size], eax
        mov ebx, dword [leaguedbnames+8]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call sub_8E8A0
        add esp, byte 8
        mov dword [attdb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [attdb_size], eax
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeleteTempDatabases                                             7125C  95 PC
; Unlinks the .TMP copies of the league databases
;-----------------------------------------------------------------------------
; C: src/front/create/DeleteTempDatabases.c
%ifdef CBUILD
%include "c/front/create/DeleteTempDatabases.inc"
%else
DeleteTempDatabases:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames+8]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SwapSelectedPlayers                             71333  95 PC, low confidence
; Unreferenced: checks 'The number of selected players and goalies must be
; the same on both teams!' and exchanges the selected players between the two
; panels
;-----------------------------------------------------------------------------
SwapSelectedPlayers:
        push dword 114h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 0E4h
        push edx
        push ebx
        xor edx, edx
        mov dword [dword esp+0E8h], edx
        xor ebp, ebp
        xor eax, eax
        xor ebx, ebx
.1:
        cmp byte [dword ebx+rostersel], 0
        je short .2
        inc dword [dword esp+0E8h]
.2:
        cmp byte [dword ebx+rostersel+1Ch], 0
        je short .3
        inc edx
.3:
        inc ebx
        cmp ebx, byte 19h
        jl short SwapSelectedPlayers.1
        xor ebx, ebx
.4:
        cmp byte [dword ebx+byte_EAF99], 0
        je short .5
        inc ebp
.5:
        cmp byte [dword ebx+byte_EAFB5], 0
        je short .6
        inc eax
.6:
        inc ebx
        cmp ebx, byte 3
        jl short SwapSelectedPlayers.4
        cmp edx, dword [dword esp+0E8h]
        jne short .7
        cmp ebp, eax
        je near .12
.7:
        mov ecx, 6
        lea edi, [byte esp+08h]
        mov esi, str_TheNumberOfSelected
        rep movsd
        cmp edx, dword [dword esp+0E8h]
        je short .8
        cmp ebp, eax
        je short .8
        mov edx, str_PlayersAndGoalies
        jmp short .10
.8:
        cmp edx, dword [dword esp+0E8h]
        je short .9
        mov edx, str_Players
        jmp short .10
.9:
        cmp ebp, eax
        je short .11
        mov edx, str_Goalies
.10:
        lea eax, [byte esp+08h]
        call strcat_
.11:
        lea eax, [byte esp+08h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_MustBeTheSame
        push byte 0FFFFFFFFh
        mov esi, dword [byte esp+04h]
        push esi
        mov edi, dword [byte esp+0Ch]
        push edi
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .x
.12:
        xor eax, eax
        xor ecx, ecx
        xor ebx, ebx
.13:
        cmp byte [dword ebx+rostersel], 0
        je short .14
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov dl, byte [dword edx+rosterslot]
        mov byte [dword esp+eax+0B0h], dl
        mov byte [byte esp+eax+078h], bl
        inc eax
.14:
        cmp byte [dword ebx+rostersel+1Ch], 0
        je short .15
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov dl, byte [dword edx+byte_EAC86]
        mov byte [dword esp+ecx+0CCh], dl
        mov byte [dword esp+ecx+094h], bl
        inc ecx
.15:
        inc ebx
        cmp ebx, byte 1Ch
        jl short SwapSelectedPlayers.13
        add dword [dword esp+0E8h], ebp
        xor ebx, ebx
        jmp near .21
.16:
        xor eax, eax
        mov al, byte [dword esp+ebx+0B0h]
        mov edx, dword [rosterteamrec]
        mov eax, dword [byte edx+eax*4+04Ch]
        call KeyDbPtr
        mov edx, eax
        xor eax, eax
        mov al, byte [dword esp+ebx+0CCh]
        mov ecx, eax
        shl ecx, 2
        mov eax, dword [dword_EAF7C]
        mov eax, dword [byte ecx+eax+04Ch]
        call KeyDbPtr
        mov cl, byte [eax]
        mov ch, byte [edx]
        xor ch, cl
        mov byte [edx], ch
        mov cl, ch
        mov ch, byte [eax]
        xor ch, cl
        mov byte [eax], ch
        xor byte [edx], ch
        xor eax, eax
        mov al, byte [dword esp+ebx+0B0h]
        mov edx, eax
        shl edx, 2
        mov eax, dword [rosterteamrec]
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0CCh]
        mov ecx, edx
        shl ecx, 2
        mov edx, dword [dword_EAF7C]
        mov edx, dword [byte ecx+edx+04Ch]
        xor dword [byte eax+04Ch], edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0CCh]
        shl edx, 2
        mov eax, dword [dword_EAF7C]
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0B0h]
        mov ecx, dword [rosterteamrec]
        mov edx, dword [byte ecx+edx*4+04Ch]
        xor dword [byte eax+04Ch], edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0B0h]
        shl edx, 2
        mov eax, dword [rosterteamrec]
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0CCh]
        mov ecx, edx
        shl ecx, 2
        mov edx, dword [dword_EAF7C]
        mov edx, dword [byte ecx+edx+04Ch]
        xor dword [byte eax+04Ch], edx
        movzx ebp, byte [byte esp+ebx+078h]
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        xor ecx, ecx
        mov cl, byte [dword esp+ebx+094h]
        mov edx, ecx
        shl edx, 3
        sub edx, ecx
        shl edx, 2
        sub edx, ecx
        mov cl, byte [dword edx+byte_EAC86]
        mov ch, byte [dword eax+rosterslot]
        xor ch, cl
        mov byte [dword eax+rosterslot], ch
        mov cl, ch
        mov ch, byte [dword edx+byte_EAC86]
        xor ch, cl
        mov byte [dword edx+byte_EAC86], ch
        mov cl, ch
        xor byte [dword eax+rosterslot], cl
        mov ecx, 6
        lea edi, [byte esp+05Ch]
        lea esi, [dword eax+rosterlist]
        rep movsd
        movsw
        movsb
        mov ecx, 6
        lea edi, [dword eax+rosterlist]
        lea esi, [dword edx+unk_EAC84]
        rep movsd
        movsw
        movsb
        mov ecx, 6
        lea edi, [dword edx+unk_EAC84]
        lea esi, [byte esp+05Ch]
        rep movsd
        movsw
        movsb
        mov edx, ebp
        xor eax, eax
        call FixJerseyNumber
        xor edx, edx
        mov dl, byte [dword esp+ebx+094h]
        mov eax, 1
        call FixJerseyNumber
        mov esi, dword [rosterteamrec]
        add esi, 0BCh
        xor eax, eax
.17:
        lea edx, [esi+eax]
        mov cl, byte [edx]
        cmp cl, byte [dword esp+ebx+0B0h]
        jne short .18
        mov byte [edx], 64h
.18:
        inc eax
        cmp eax, byte 30h
        jl short SwapSelectedPlayers.17
        mov esi, dword [dword_EAF7C]
        add esi, 0BCh
        xor eax, eax
.19:
        lea edx, [esi+eax]
        mov cl, byte [edx]
        cmp cl, byte [dword esp+ebx+0CCh]
        jne short .20
        mov byte [edx], 64h
.20:
        inc eax
        cmp eax, byte 30h
        jl short SwapSelectedPlayers.19
        inc ebx
.21:
        cmp ebx, dword [dword esp+0E8h]
        jl near SwapSelectedPlayers.16
        mov ebx, 1
        mov dword [dbdirty], ebx
        xor eax, eax
        call LoadRosterList
        mov eax, ebx
        call LoadRosterList
        call DrawEditRosters
.x:
        add esp, 0ECh
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; SelectMatchingPlayers                                           71690  95 PC
; (first, last, side): selects the panel's players whose lower-cased
; first/last name match (last only when first is empty)
;-----------------------------------------------------------------------------
; C: src/front/create/SelectMatchingPlayers.c
%ifdef CBUILD
%include "c/front/create/SelectMatchingPlayers.inc"
%else
SelectMatchingPlayers:
        push dword 34h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        cmp byte [dword ebx+rosterisfa], 1
        je near .6
        xor ecx, ecx
.1:
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        xor dh, dh
        mov byte [dword ecx+eax*4+rostersel], dh
        inc ecx
        cmp ecx, byte 1Ch
        jl short SelectMatchingPlayers.1
        xor ecx, ecx
.2:
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        mov eax, dword [dword ebx+eax+dword_EA994]
        call KeyDbPtr
        mov ebx, eax
        lea edx, [byte eax+03h]
        lea eax, [byte esp+010h]
        call strcpy_
        lea edx, [byte ebx+013h]
        mov eax, esp
        call strcpy_
        lea eax, [byte esp+010h]
        call strlwr_
        mov eax, esp
        call strlwr_
        lea edx, [byte esp+010h]
        mov eax, esi
        call strcmp_
        test eax, eax
        jne short .3
        mov edx, esp
        mov eax, edi
        call strcmp_
        test eax, eax
        je short .4
.3:
        cmp byte [edi], 0
        jne short .5
        mov edx, esp
        mov eax, esi
        call strcmp_
        test eax, eax
        jne short .5
.4:
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        mov dl, byte [dword ecx+eax*4+rostersel]
        not dl
        mov byte [dword ecx+eax*4+rostersel], dl
.5:
        inc ecx
        cmp ecx, byte 1Ch
        jl near SelectMatchingPlayers.2
        jmp near .x
.6:
        xor ecx, ecx
        jmp short .8
.7:
        mov eax, dword [falistsel]
        mov byte [ecx+eax], 0
        inc ecx
.8:
        cmp ecx, dword [facount]
        jl short SelectMatchingPlayers.7
        cmp dword [dword_D0C20], byte 0
        je short .9
        mov dword [falisttop], 0FFFFFFFFh
.9:
        xor ecx, ecx
        jmp near .14
.10:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        mov edx, dword [falist]
        add eax, edx
        add eax, byte 8
        mov ebx, esp
        lea edx, [byte esp+010h]
        call SplitPlayerName
        lea eax, [byte esp+010h]
        call strlwr_
        mov eax, esp
        call strlwr_
        lea edx, [byte esp+010h]
        mov eax, esi
        call strcmp_
        test eax, eax
        jne short .11
        mov edx, esp
        mov eax, edi
        call strcmp_
        test eax, eax
        je short .12
.11:
        cmp byte [edi], 0
        jne short .13
        mov edx, esp
        mov eax, esi
        call strcmp_
        test eax, eax
        jne short .13
.12:
        mov eax, dword [falistsel]
        mov dl, byte [ecx+eax]
        not dl
        mov byte [ecx+eax], dl
        cmp dword [dword_D0C20], byte 0
        je short .13
        cmp dword [falisttop], byte 0FFFFFFFFh
        jne short .13
        mov dword [falisttop], ecx
.13:
        inc ecx
.14:
        cmp ecx, dword [facount]
        jl near SelectMatchingPlayers.10
.x:
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetRosterTeamMenus                                              7183D  95 PC
; (side, team): re-enables the old team's division item (or 'Free Agents
; ...'), disables the new one and sets 'Edit Team Lines ...'
;-----------------------------------------------------------------------------
SetRosterTeamMenus:
        push dword 14h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov esi, edx
        movzx edi, byte [dword eax+rosterteam]
        cmp edi, 0FFh
        jne short .1
        mov edx, ShowFreeAgents
        mov dword [menu_r1_freeagents], edx
        mov dword [menu_r2_freeagents], edx
        jmp short .5
.1:
        mov ecx, dword [nosplit edi*4+teamdivflags]
        sar ecx, 1
        cmp ecx, byte 4
        jne short .2
        dec ecx
.2:
        xor edx, edx
.3:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        mov al, byte [dword edx+eax+divisionteams]
        and eax, 0FFh
        cmp eax, edi
        je short .4
        inc edx
        cmp edx, byte 7
        jl short SetRosterTeamMenus.3
.4:
        shl ecx, 5
        shl edx, 5
        mov eax, dword [dword ecx+roster1divmenus]
        mov dword [byte edx+eax+014h], SelectRosterTeam
        mov eax, dword [dword ecx+roster2divmenus]
        mov dword [byte edx+eax+014h], SelectRosterTeam
.5:
        cmp esi, byte 64h
        jne short .8
        test ebp, ebp
        jne short .6
        mov dword [menu_r1_editlines], ebp
        jmp short .7
.6:
        xor ecx, ecx
        mov dword [menu_r2_editlines], ecx
.7:
        xor edi, edi
        mov dword [menu_r1_freeagents], edi
        mov dword [menu_r2_freeagents], edi
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
.8:
        mov ecx, dword [nosplit esi*4+teamdivflags]
        sar ecx, 1
        cmp ecx, byte 4
        jne short .9
        dec ecx
.9:
        xor edx, edx
.10:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        mov al, byte [dword edx+eax+divisionteams]
        and eax, 0FFh
        cmp eax, esi
        je short .11
        inc edx
        cmp edx, byte 7
        jl short SetRosterTeamMenus.10
.11:
        shl ecx, 5
        mov eax, edx
        shl eax, 5
        mov edx, dword [dword ecx+roster1divmenus]
        mov dword [byte edx+eax+014h], 0
        mov edx, dword [dword ecx+roster2divmenus]
        mov dword [byte edx+eax+014h], 0
        test ebp, ebp
        jne short .12
        mov dword [menu_r1_editlines], EditTeamLines
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
.12:
        mov dword [menu_r2_editlines], EditTeamLines
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; FindPlayer                                                      71961  95 PC
; 'Find Player ...' menu item: 'Enter name of player to find:', searches the
; free-agent list and the teams, 'Choose which team to display' / 'is already
; displayed on Roster N' / 'does not exist!', then SetRosterTeamMenus,
; LoadRosterList and SelectMatchingPlayers
;-----------------------------------------------------------------------------
; C: src/front/create/FindPlayer.c
%ifdef CBUILD
%include "c/front/create/FindPlayer.inc"
%else
FindPlayer:
        push dword 1E8h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 1B8h
        push edx
        push ebx
        cmp dword [eax], byte 1
        setne al
        and eax, 0FFh
        mov dword [dword esp+01BCh], eax
        sete al
        and eax, 0FFh
        mov dword [dword esp+01B4h], eax
        xor ah, ah
        mov byte [dword esp+0154h], ah
        mov dword [msglines], str_EnterNameOfPlayer
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push dword 0BAh
        mov ecx, 1Fh
        lea ebx, [dword esp+0168h]
        mov edx, 1
        mov eax, msglines
        call InputDialog
        lea eax, [dword esp+0154h]
        call strlwr_
        lea ebx, [dword esp+0174h]
        lea edx, [dword esp+01A4h]
        lea eax, [dword esp+0154h]
        call SplitPlayerName
        cmp byte [dword esp+0174h], 0
        jne short .1
        cmp byte [dword esp+01A4h], 0
        je near .x
.1:
        xor esi, esi
        xor edi, edi
.2:
        mov eax, edi
        call TeamRecPtr
        mov ebp, eax
        mov dword [dword esp+esi*4+0E8h], 0FFFFFFFFh
        xor ebx, ebx
        jmp near .7
.3:
        mov eax, ebx
        mov eax, dword [byte ebp+eax*4+04Ch]
        call KeyDbPtr
        mov ecx, eax
        lea edx, [byte eax+03h]
        lea eax, [dword esp+0184h]
        call strcpy_
        lea edx, [byte ecx+013h]
        lea eax, [dword esp+0194h]
        call strcpy_
        lea eax, [dword esp+0184h]
        call strlwr_
        lea eax, [dword esp+0194h]
        call strlwr_
        lea edx, [dword esp+0184h]
        lea eax, [dword esp+01A4h]
        call strcmp_
        test eax, eax
        jne short .4
        lea edx, [dword esp+0194h]
        lea eax, [dword esp+0174h]
        call strcmp_
        test eax, eax
        je short .5
.4:
        cmp byte [dword esp+0174h], 0
        jne short .6
        lea edx, [dword esp+0194h]
        lea eax, [dword esp+01A4h]
        call strcmp_
        test eax, eax
        jne short .6
.5:
        mov dword [dword esp+esi*4+0E8h], edi
        inc esi
.6:
        inc ebx
.7:
        cmp ebx, byte 1Ch
        jge short .8
        cmp dword [dword esp+esi*4+0E8h], byte 0
        jl near FindPlayer.3
.8:
        inc edi
        cmp edi, byte 1Ah
        jl near FindPlayer.2
        mov ebx, 34h
        xor edx, edx
        mov eax, dword [keydb_size]
        div ebx
        mov edi, eax
        mov dword [dword esp+esi*4+0E8h], 0FFFFFFFFh
        xor ecx, ecx
        jmp near .13
.9:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        mov ebx, dword [keydb]
        add ebx, eax
        cmp byte [ebx], 0FFh
        jne near .12
        lea edx, [byte ebx+03h]
        lea eax, [dword esp+0184h]
        call strcpy_
        lea edx, [byte ebx+013h]
        lea eax, [dword esp+0194h]
        call strcpy_
        lea eax, [dword esp+0184h]
        call strlwr_
        lea eax, [dword esp+0194h]
        call strlwr_
        lea edx, [dword esp+0184h]
        lea eax, [dword esp+01A4h]
        call strcmp_
        test eax, eax
        jne short .10
        lea edx, [dword esp+0194h]
        lea eax, [dword esp+0174h]
        call strcmp_
        test eax, eax
        je short .11
.10:
        cmp byte [dword esp+0174h], 0
        jne short .12
        lea edx, [dword esp+0194h]
        lea eax, [dword esp+01A4h]
        call strcmp_
        test eax, eax
        jne short .12
.11:
        mov dword [dword esp+esi*4+0E8h], 64h
        inc esi
.12:
        inc ecx
.13:
        cmp ecx, edi
        jge short .14
        cmp dword [dword esp+esi*4+0E8h], byte 0
        jl near FindPlayer.9
.14:
        test esi, esi
        jle near .36
        cmp esi, byte 1
        jle short .19
        xor ebx, ebx
        xor edi, edi
        jmp short .18
.15:
        mov eax, edi
        shl eax, 2
        mov edx, ebx
        shl edx, 2
        mov ecx, dword [dword esp+eax+0E8h]
        cmp ecx, byte 64h
        jne short .16
        mov dword [byte esp+edx+08h], str_FreeAgentList
        jmp short .17
.16:
        cmp ecx, byte 1Ah
        jge short .17
        mov eax, dword [nosplit ecx*4+teamcitynames]
        mov dword [byte esp+edx+08h], eax
.17:
        inc ebx
        inc edi
.18:
        cmp edi, esi
        jl short FindPlayer.15
        lea eax, [byte esp+078h]
        push eax
        push byte 0
        xor ecx, ecx
        mov ebx, str_ChooseWhichTeamTo
        mov edx, esi
        lea eax, [byte esp+010h]
        call ListDialog
        mov eax, dword [dword esp+eax*4+0E8h]
        jmp short .20
.19:
        mov eax, dword [dword esp+0E8h]
.20:
        mov dword [dword esp+01B8h], eax
        cmp dword [dword esp+01B8h], byte 64h
        jne near .24
        mov eax, dword [dword esp+01B4h]
        cmp byte [dword eax+rosterisfa], 1
        jne short .23
        lea eax, [dword esp+0154h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_IsAlreadyDisplayedOn
        cmp dword [dword esp+01BCh], byte 0
        jne short .21
        mov eax, str_Roster2
        jmp short .22
.21:
        mov eax, str_Roster1
.22:
        mov dword [msglines+8], eax
        push byte 0FFFFFFFFh
        mov ecx, dword [byte esp+04h]
        push ecx
        mov esi, dword [byte esp+0Ch]
        push esi
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .28
.23:
        mov eax, dword [dword esp+01BCh]
        cmp byte [dword eax+rosterisfa], 1
        je near .28
        mov edx, dword [dword esp+01B8h]
        call SetRosterTeamMenus
        mov eax, dword [dword esp+01BCh]
        mov byte [dword eax+rosterisfa], 1
        call LoadRosterList
        mov eax, dword [dword esp+01BCh]
        mov byte [dword eax+rosterteam], 0FFh
        jmp near .28
.24:
        xor eax, eax
        mov edx, dword [dword esp+01B4h]
        mov al, byte [dword edx+rosterteam]
        mov ebx, dword [dword esp+01B8h]
        cmp eax, ebx
        jne short .27
        lea eax, [dword esp+0154h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_IsAlreadyDisplayedOn
        cmp dword [dword esp+01BCh], byte 0
        jne short .25
        mov eax, str_Roster2
        jmp short .26
.25:
        mov eax, str_Roster1
.26:
        mov dword [msglines+8], eax
        push byte 0FFFFFFFFh
        mov ebp, dword [byte esp+04h]
        push ebp
        mov eax, dword [byte esp+0Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov eax, dword [dword esp+01B4h]
        mov dword [dword esp+01BCh], eax
        jmp short .28
.27:
        xor eax, eax
        mov edx, dword [dword esp+01BCh]
        mov al, byte [dword edx+rosterteam]
        cmp eax, ebx
        je short .28
        mov edx, ebx
        mov eax, dword [dword esp+01BCh]
        call SetRosterTeamMenus
        mov eax, dword [dword esp+01BCh]
        xor dl, dl
        mov byte [dword eax+rosterisfa], dl
        mov al, byte [dword esp+01B8h]
        mov edx, dword [dword esp+01BCh]
        mov byte [dword edx+rosterteam], al
        mov eax, edx
        call LoadRosterList
.28:
        mov ebx, dword [dword esp+01BCh]
        lea edx, [dword esp+0174h]
        lea eax, [dword esp+01A4h]
        call SelectMatchingPlayers
        call DrawEditRosters
        mov eax, dword [dword esp+01BCh]
        cmp byte [dword eax+rosterisfa], 1
        jne short .29
        mov eax, dword [falistsel]
        jmp short .30
.29:
        mov edx, eax
        shl eax, 3
        sub eax, edx
        shl eax, 2
        add eax, rostersel
.30:
        call CountSelected
        test eax, eax
        jle near .34
        cmp dword [dword esp+01BCh], byte 0
        jne short .32
        cmp byte [rosterisfa], 1
        je short .31
        cmp dword [facount], byte 1Eh
        jge short .31
        mov dword [menu_r1_tofa], MoveToFreeAgents
.31:
        cmp byte [rosterisfa+1], 1
        je near .x
        mov dword [menu_r1_toroster2], MoveToOtherRoster
        jmp near .x
.32:
        cmp byte [rosterisfa+1], 1
        je short .33
        cmp dword [facount], byte 1Eh
        jge short .33
        mov dword [menu_r2_tofa], MoveToFreeAgents
.33:
        cmp byte [rosterisfa], 1
        je near .x
        mov dword [menu_r2_toroster1], MoveToOtherRoster
        jmp short .x
.34:
        mov edi, dword [dword esp+01BCh]
        test edi, edi
        jne short .35
        mov dword [menu_r1_tofa], edi
        mov dword [menu_r1_toroster2], edi
        jmp short .x
.35:
        xor ebp, ebp
        mov dword [menu_r2_tofa], ebp
        mov dword [menu_r2_toroster1], ebp
        jmp short .x
.36:
        lea eax, [dword esp+0154h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_DoesNotExist
        push byte 0FFFFFFFFh
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.x:
        add esp, 1C0h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
