; Stand-alone Play-Off mode. Seeding the teams, building the series, and simulating the games you do not play.
bits 32
%include "hockey.inc"
section s_86696 progbits alloc exec nowrite align=1
extern __CHK, __STOSD, AskDatabaseChoice, awscore, boxfillcolor, boxlitecolor, boxshadecolor, btn_LeagueExists
extern btn_POHumanOut, BuildSavedGameLabels, careerdb, careerdb_size, cddriveptr, CheckGameDiskSpace, ClearInputQueue, confteams
extern cont2team, CopyFile, CountSeriesWins, ctl1side, ctl1team, ctl2side, ctl2team, ctlavailmask
extern curleague, dbextension, DeleteDir, DeskHomeLines, DeskVisitorLines, DiskSpaceShort, dlgtextbg, dlgtextfg
extern DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, embscupbank, dword_C6D26, potreeseeds, menusub_hmgoalie
extern menusub_awgoalie, dword_D2884, poseriesfmt, poslotx, posloty, EasnGoalieStatsScreen, EasnSkaterStatsScreen, EasnStandingsMenu
extern EasnStandingsScreen, EasnTeamStatsScreen, EditPlayoffSettings, exhstate, FadePalStep, FatalError, FileClose, FileExists
extern fileoncd, FileOpenRead, FileOpenRW, FileOpenWrite, FileWriteAt, fputchar, FreeMemBlock, GameGoalieStatsScreen
extern gamemode, gameopts, gameresult, GameSkaterStatsScreen, GameStandingsMenu, GameStandingsScreen, GameTeamStatsScreen, GetInputEvent
extern GetLeagueDBSizes, goaliestatscb, hmscore, hmteamrec, HomeTeam, InitGameSummary, InputInstall, InputRemove
extern j_unlink_, kaufmfont, keydb, keydb_size, leaguedbfmt, leaguedbfmt2, leaguedbnames, lgstate
extern LoadModeState, LockerRoomScreen, mainfont, MakePath, menuact_nextpo, menuact_pohilights, menuact_posettings, MenuHitTest
extern MenuPlayNextGame, MessageBox, mkdir_, mousepollfn, MouseSetPos, msg_PODiskSpace, msg_PODiskSpace_arg, msg_POExists
extern msg_POGenFinal, msg_POHumanOut, msg_POSettingUp, msg_POSetupError, msg_POTeamOut, msg_POTeamOut_arg, msg_POTeamOut_arg2, musichandle
extern musicon, musicslot, off_C6D22, menuact_homelines, menuact_visitorlines, menuact_playnextgame, PlayGame, playofftree
extern playofftree_p1, pochampion, pointerspr, postate, PostGameToTeamDb, PreGameScreen, PrintCenteredText, PrintOutlinedText
extern PrintShadowText, ptrupdatefn, randomd0, RestoreDialogBg, rmdir_, SaveModeState, savenamedefault, schedgameidx
extern scrpitch, seasondb, seasondb_size, seriesgameno, SetDialogColors, SetScreenTitle, SetTextColors, SetTickDeadline
extern SetupControllers, SetupStatsSourceMenu, ShowLoadingScreen, SimulateGame, skaterstatscb, songdata, sprintf_, standingscb
extern standingsmenucb, str_4dKbytesOfFree, str_Adn1, str_Adn2, str_Adn3, str_Aup1, str_Aup2, str_Aup3
extern str_BangPal, str_Bkgd, str_Bkgd2, str_D, str_Db, str_dot, str_E1, str_E2
extern str_E31, str_E32, str_EasternConference, str_Embpal, str_Embscup, str_extDB, str_F1, str_F2
extern str_fmtcsp, str_fmtSlashDb, str_GameSav, str_GameSet, str_Menubuff2, str_Midl, str_Palette, str_PlayoffsHaveNotBeen
extern str_PleaseEnterNewPlay, str_PO, str_Pointer, str_POTitle, str_Pstatbar2, str_Rst1, str_Rst2, str_Schedule
extern str_ScheduleDb, str_Scuparrw, str_Temp2, str_Tied, str_WesternConference, strcat_, strcpy_, AllocMemBlock
extern sub_8D2F0, LoadBank, sub_8E8A0, sub_8E8B8, TextSetColors, TextSaveState, TextRestoreState, TextSetFont
extern SndQuery, sub_8FCDF, SetPalette, PutBlock, sub_910B0, sub_9121C, DrawArt, DrawShape
extern GrabBlock, GetFileSize, sub_92F50, WriteFile, MouseRead, SetViewRect, FindShape, VgaSetPalette
extern sub_B4BA8, SetClipWindow, teamabbrevs, teamcitynames, teamconf, teamdivflags, teamstatscb, TextGridOff
extern TextGridOpen, TextInputDialog, treecol_Er1, treecol_Er2, treecol_Wr2, treecolslots, treecolx, treeteamnames
extern str_space4, str_space5, hmgoaliemenu, awgoaliemenu, playoffmenubar, podbsizes, poseriestext, poseriesbuf
extern unknown_libname_1, ViewPlayoffHilights, VisTeam, WaitTickDeadline, potreeround, WriteModeState
global CreatePlayoffs, POSeedTeams, POPickConfTeams, POCreateSchedule, POCreateSchedule_x, POSetSeriesTeams, POInitSchedule, SeriesWinner
global POSeriesScore, POSeedRound2, POSeedRound2_x30, POSeedRound2_x, POSeedConfFinals, POSeedConfFinals_pair, POSeedConfFinals_x, POSeedFinal
global POSimSeriesTeamWins, POSimSeries, POPreSimRound1, POPreSimRound2, POPreSimConfFinals, POHandleElimination, POSimSeriesTo, POAfterGame
global LoadScheduleDB, LoadScheduleDB_x, SaveScheduleDB, PlayoffModeLoop, POReturnZero, POHiliteSlot, PlayoffTreeMenu, DrawPlayoffTree
global SetSideControls, WriteCurModeState, ClearPlayerFromLines
;-----------------------------------------------------------------------------
; CreatePlayoffs                                                  86696  95 PC
; Main-menu handler (frontend menu table CDxxx dd entry): asks 'Please Enter
; New Play-Off Name' (TextInputDialog), confirms replacing an existing .PO
; dir (msg 'There is already a Play-Off with that name!'), mkdir <name>.PO,
; checks free disk space ('Insufficient disk space to setup a Playoff
; Series'), copies the 7 league DBs, seeds 16 teams (POSeedTeams), builds
; schedule.db (POCreateSchedule) and installs PlayoffModeLoop as the mode
; loop (menuact_nextpo)
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSeedRound2.c (CreatePlayoffs)
%ifdef CBUILD
%include "c/front/playoff_mode/POSeedRound2.CreatePlayoffs.inc"
%else
CreatePlayoffs:
        push dword 0F8h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 0C8h
        lea edi, [dword esp+08Ch]
        mov esi, savenamedefault
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [boxfillcolor]
        mov dword [dword esp+0ACh], eax
        mov eax, dword [boxlitecolor]
        mov dword [dword esp+0B0h], eax
        mov eax, dword [boxshadecolor]
        mov dword [dword esp+0B8h], eax
        mov eax, dword [dlgtextfg]
        mov dword [dword esp+0BCh], eax
        mov eax, dword [dlgtextbg]
        mov dword [dword esp+0B4h], eax
        mov dword [boxfillcolor], 41h
        mov ebx, 40h
        mov dword [boxlitecolor], ebx
        mov dword [boxshadecolor], 42h
        mov dword [dlgtextfg], ebx
        mov dword [dlgtextbg], 43h
        mov eax, exhstate
        call SaveModeState
        push byte 20h
        push dword 300h
        push str_Palette
        call AllocMemBlock
        mov edi, eax
        add esp, byte 0Ch
        mov esi, eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, edi
        mov eax, 1
        call FadePalStep
        call sub_B4BA8
        mov ebp, dword [embscupbank]
        test ebp, ebp
        jne short .3
        xor ecx, ecx
        mov ebx, str_Embscup
        cmp byte [fileoncd+08Dh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [byte esp+06Ch]
        call MakePath
        push byte 0
        lea eax, [byte esp+070h]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push str_Bkgd
        push edi
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push edi
        call FreeMemBlock
        jmp short .4
.3:
        push str_Bkgd
        push ebp
        call FindShape
        add esp, byte 8
        push eax
        call sub_9121C
.4:
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Embpal
        cmp byte [fileoncd+08Eh], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp short .6
.5:
        xor edx, edx
.6:
        lea eax, [byte esp+06Ch]
        call MakePath
        push byte 0
        lea eax, [byte esp+070h]
        push eax
        call LoadBank
        add esp, byte 8
        mov ebp, eax
        push str_BangPal
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        push byte 41h
        push byte 40h
        call TextSetColors
        add esp, byte 8
        push byte 43h
        mov ecx, 40h
        mov ebx, 42h
        mov edx, ecx
        mov eax, 41h
        call SetDialogColors
        mov dh, 3Fh
        mov byte [dword esp+0C2h], dh
        mov byte [dword esp+0C1h], dh
        mov byte [dword esp+0C0h], dh
        lea eax, [dword esp+0C4h]
        push eax
        push byte 1
        push byte 3
        call SetPalette
        add esp, byte 0Ch
        lea eax, [dword esp+0C0h]
        push eax
        push byte 1
        push byte 3
        call VgaSetPalette
        add esp, byte 0Ch
        push byte 5
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 36h
        mov ebx, 8
        lea edx, [dword esp+0A0h]
        mov eax, str_PleaseEnterNewPlay
        call TextInputDialog
        mov edi, eax
        lea eax, [dword esp+0C4h]
        push eax
        push byte 1
        push byte 3
        call VgaSetPalette
        add esp, byte 0Ch
        lea eax, [dword esp+0A0h]
        push eax
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+0A4h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        cmp edi, byte 1Bh
        je near .14
        cmp byte [dword esp+08Ch], 0
        je near .14
        mov dword [postate], 1
        mov dword [postate+51h], 0Ch
        mov dword [postate+55h], 15h
        mov dx, word [postate+59h]
        xor dl, dl
        and dh, 80h
        mov word [postate+59h], dx
        mov ebx, edx
        or ebx, 79FFh
        mov word [postate+59h], bx
        mov ch, byte [ctlavailmask]
        test ch, 2
        je short .7
        mov dword [postate+65h], 2
        jmp short .11
.7:
        test ch, 4
        je short .8
        mov dword [postate+65h], 4
        jmp short .11
.8:
        test ch, 8
        je short .9
        mov dword [postate+65h], 8
        jmp short .11
.9:
        test ch, 1
        je short .10
        mov dword [postate+65h], 1
        jmp short .11
.10:
        mov dword [postate+65h], 10h
.11:
        cmp dword [postate+65h], byte 10h
        je short .12
        mov dword [postate+5Dh], 0Ch
        jmp short .13
.12:
        mov dword [postate+5Dh], 0FFFFFFFFh
.13:
        mov dword [postate+69h], 10h
        mov dword [postate+61h], 0FFFFFFFEh
        xor edi, edi
        mov dword [postate+6Dh], edi
        mov dword [postate+71h], 1
        mov eax, postate
        call LoadModeState
        mov edx, str_PO
        lea eax, [dword esp+08Ch]
        call strcat_
        lea ebx, [byte esp+040h]
        mov edx, 10h
        lea eax, [dword esp+08Ch]
        call unknown_libname_1
        test eax, eax
        jne short .15
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        push byte 2
        push btn_LeagueExists
        mov ecx, 2
        mov ebx, msg_POExists
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        test eax, eax
        sete al
        and eax, 0FFh
        mov edi, eax
        jne short .14
        lea eax, [dword esp+08Ch]
        call DeleteDir
        jmp short .15
.14:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov edi, 1
.15:
        test edi, edi
        jne near .29
        lea edx, [dword esp+08Ch]
        mov eax, curleague
        call strcpy_
        lea edx, [dword esp+08Ch]
        mov eax, leaguedbfmt
        call strcpy_
        mov edx, str_fmtSlashDb
        mov eax, leaguedbfmt
        call strcat_
        mov edx, leaguedbfmt
        mov eax, leaguedbfmt2
        call strcpy_
        lea eax, [dword esp+08Ch]
        call mkdir_
        test eax, eax
        je short .16
        push dword 190h
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        push edi
        push edi
        mov ecx, 4
        mov ebx, msg_POSetupError
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov edi, 1
.16:
        test edi, edi
        jne near .29
        call AskDatabaseChoice
        mov edi, eax
        test eax, eax
        jl near .18
        mov ebx, dword [dbextension]
        mov edx, podbsizes
        xor eax, eax
        call GetLeagueDBSizes
        xor ecx, ecx
        mov ebx, str_GameSet
        mov edx, curleague
        lea eax, [byte esp+06Ch]
        call MakePath
        lea eax, [byte esp+06Ch]
        call FileExists
        test eax, eax
        je short .17
        xor edx, edx
        mov dword [dword_D2884], edx
.17:
        mov edx, podbsizes
        xor eax, eax
        call DiskSpaceShort
        mov edi, eax
        test eax, eax
        je short .18
        push eax
        push str_4dKbytesOfFree
        push msg_PODiskSpace_arg
        call sprintf_
        add esp, byte 0Ch
        push dword 258h
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_PODiskSpace
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov edi, 1
.18:
        test edi, edi
        jne near .28
        call LockerRoomScreen
        cmp eax, byte 3
        je near .28
        push esi
        push dword 100h
        push edi
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        mov ebx, dword [embscupbank]
        test ebx, ebx
        jne short .21
        xor ecx, ecx
        mov ebx, str_Embscup
        cmp byte [fileoncd+08Dh], 1
        jne short .19
        mov edx, dword [cddriveptr]
        jmp short .20
.19:
        xor edx, edx
.20:
        lea eax, [byte esp+06Ch]
        call MakePath
        push byte 0
        lea eax, [byte esp+070h]
        push eax
        call LoadBank
        mov dword [dword esp+0B0h], eax
        add esp, byte 8
        push str_Bkgd
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call sub_9121C
        add esp, byte 4
        mov edx, dword [dword esp+0A8h]
        push edx
        call FreeMemBlock
        jmp short .22
.21:
        push str_Bkgd
        push ebx
        call FindShape
        add esp, byte 8
        push eax
        call sub_9121C
.22:
        add esp, byte 4
        push str_BangPal
        push ebp
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        push ebp
        call FreeMemBlock
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, esp
        call POSeedTeams
        push byte 0
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msg_POSettingUp
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        xor esi, esi
.23:
        push curleague
        mov edx, dword [dbextension]
        mov eax, dword [nosplit esi*4+leaguedbnames]
        mov ecx, str_dot
        mov ebx, str_extDB
        call CopyFile
        test eax, eax
        je short .24
        push dword 190h
        call SetTickDeadline
        add esp, byte 4
        lea eax, [dword esp+08Ch]
        call DeleteDir
        mov edi, 1
        call WaitTickDeadline
        jmp short .25
.24:
        inc esi
        cmp esi, byte 7
        jl short CreatePlayoffs.23
.25:
        test edi, edi
        jne near .27
        lea edx, [dword esp+08Ch]
        mov eax, esp
        call POCreateSchedule
        test eax, eax
        je short .26
        push dword 190h
        call SetTickDeadline
        add esp, byte 4
        push edi
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        push edi
        push edi
        mov ecx, 4
        mov ebx, msg_POSetupError
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        lea eax, [dword esp+08Ch]
        call DeleteDir
        call WaitTickDeadline
        call RestoreDialogBg
.26:
        mov eax, postate
        call WriteModeState
        call BuildSavedGameLabels
        xor eax, eax
        call SetupStatsSourceMenu
        mov dword [menuact_nextpo], PlayoffModeLoop
        mov dword [menuact_posettings], EditPlayoffSettings
        mov dword [menuact_pohilights], ViewPlayoffHilights
        xor edi, edi
        mov dword [seriesgameno], edi
.27:
        call RestoreDialogBg
        jmp short .29
.28:
        lea eax, [dword esp+08Ch]
        call rmdir_
        push ebp
        call FreeMemBlock
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
.29:
        push byte 20h
        push dword 300h
        push str_Temp2
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, exhstate
        call LoadModeState
        mov eax, dword [dword esp+0ACh]
        mov dword [boxfillcolor], eax
        mov eax, dword [dword esp+0B0h]
        mov dword [boxlitecolor], eax
        mov eax, dword [dword esp+0B8h]
        mov dword [boxshadecolor], eax
        mov eax, dword [dword esp+0BCh]
        mov dword [dlgtextfg], eax
        mov eax, dword [dword esp+0B4h]
        mov dword [dlgtextbg], eax
        mov eax, 2
        add esp, 0C8h
        jmp near POSeedRound2_x
%endif ; C
;-----------------------------------------------------------------------------
; POSeedTeams                                  86E8B  95 PC, medium confidence
; Fills the 16 seed slots: 8 placeholders per conference (-3 west / -12 east,
; random slots), puts HomeTeam and VisTeam into their conference's slots
; (opposite ends if same conference), then POPickConfTeams fills the
; remaining placeholders with random teams of each conference
;-----------------------------------------------------------------------------
POSeedTeams:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        xor ebx, ebx
.1:
        mov eax, ebx
        mov dword [esi+eax*4], 0FFFFFFF0h
        inc ebx
        cmp ebx, byte 10h
        jl short POSeedTeams.1
        xor ebx, ebx
.2:
        mov eax, 10h
        call randomd0
        movsx edx, ax
        jmp short .4
.3:
        inc edx
        mov ecx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
.4:
        mov eax, edx
        shl eax, 2
        add eax, esi
        cmp dword [eax], byte 0FFFFFFF0h
        jne short POSeedTeams.3
        mov dword [eax], 0FFFFFFFDh
        mov eax, 10h
        call randomd0
        movsx edx, ax
        mov ecx, 10h
        jmp short .6
.5:
        inc edx
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
.6:
        mov eax, edx
        shl eax, 2
        add eax, esi
        cmp dword [eax], byte 0FFFFFFF0h
        jne short POSeedTeams.5
        mov dword [eax], 0FFFFFFF4h
        add ebx, byte 2
        cmp ebx, byte 10h
        jl short POSeedTeams.2
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [nosplit eax*4+teamconf]
        cmp eax, dword [nosplit edx*4+teamconf]
        jne short .11
        xor ebx, ebx
        jmp short .8
.7:
        inc ebx
.8:
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov ecx, dword [nosplit edx*4+teamconf]
        neg ecx
        mov eax, ebx
        shl eax, 2
        add eax, esi
        cmp ecx, dword [eax]
        jne short POSeedTeams.7
        mov dword [eax], edx
        mov ebx, 0Fh
        jmp short .10
.9:
        dec ebx
.10:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov ecx, dword [nosplit edx*4+teamconf]
        neg ecx
        mov eax, ebx
        shl eax, 2
        add eax, esi
        cmp ecx, dword [eax]
        jne short POSeedTeams.9
        mov dword [eax], edx
        jmp near .21
.11:
        mov eax, 3
        call randomd0
        movsx ecx, ax
        xor ebx, ebx
        mov edx, 0FFFFFFFFh
        jmp short .14
.12:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edi, dword [nosplit eax*4+teamconf]
        neg edi
        mov eax, ebx
        cmp edi, dword [esi+eax*4]
        jne short .13
        inc edx
.13:
        inc ebx
.14:
        cmp edx, ecx
        jne short POSeedTeams.12
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        dec ebx
        mov eax, ebx
        mov dword [esi+eax*4], edx
        mov dword [esp], ebx
        mov eax, 4
        sub eax, ecx
        cwde
        call randomd0
        cwde
        add ecx, eax
        xor ebx, ebx
        mov edx, 0FFFFFFFFh
        jmp short .17
.15:
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov edi, dword [nosplit eax*4+teamconf]
        neg edi
        mov eax, ebx
        cmp edi, dword [esi+eax*4]
        jne short .16
        inc edx
.16:
        inc ebx
.17:
        cmp edx, ecx
        jne short POSeedTeams.15
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        dec ebx
        mov edx, ebx
        shl edx, 2
        add edx, esi
        mov dword [edx], eax
        mov eax, dword [esp]
        cmp ebx, eax
        jge short .21
        mov ebx, dword [esi+eax*4]
        mov ecx, dword [edx]
        xor ebx, ecx
        mov dword [esi+eax*4], ebx
        mov edi, dword [edx]
        xor ebx, edi
        mov dword [edx], ebx
        mov ebx, dword [esi+eax*4]
        mov ebp, dword [edx]
        xor ebx, ebp
        mov dword [esi+eax*4], ebx
        xor ebx, ebx
.18:
        mov ecx, dword [HomeTeam-2]
        sar ecx, 10h
        mov ecx, dword [nosplit ecx*4+teamconf]
        neg ecx
        mov eax, ebx
        shl eax, 2
        add eax, esi
        cmp ecx, dword [eax]
        jne short .19
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*4+teamconf]
        neg edx
        mov dword [eax], edx
        jmp short .20
.19:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*4+teamconf]
        neg edx
        cmp edx, dword [eax]
        jne short .20
        mov dword [eax], ecx
.20:
        inc ebx
        cmp ebx, byte 10h
        jl short POSeedTeams.18
.21:
        mov ecx, 0Ch
        xor ebx, ebx
        mov edx, 3
        mov eax, esi
        call POPickConfTeams
        mov ecx, 0Eh
        mov ebx, 0Ch
        mov edx, ebx
        mov eax, esi
        call POPickConfTeams
        jmp near POSeedConfFinals_x
;-----------------------------------------------------------------------------
; POPickConfTeams                              870B6  95 PC, medium confidence
; (slots, confflag, first, count): picks 8 distinct random teams from
; confteams[first..first+count) excluding HomeTeam/VisTeam, keeps the first
; two from different divisions, and writes them over the -confflag
; placeholders
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POPickConfTeams.c
%ifdef CBUILD
%include "c/front/playoff_mode/POPickConfTeams.inc"
%else
POPickConfTeams:
        push dword 38h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        push eax
        push edx
        mov ebp, ebx
        mov edi, ecx
        xor esi, esi
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        test dword [nosplit eax*4+teamdivflags], edx
        je short .4
        xor ebx, ebx
        jmp short .2
.1:
        lea eax, [ebx+ebp]
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        cmp edx, dword [nosplit eax*4+confteams]
        je short .3
        inc ebx
.2:
        cmp ebx, edi
        jl short POPickConfTeams.1
.3:
        mov cl, bl
        mov eax, 1
        shl eax, cl
        or esi, eax
.4:
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+teamdivflags]
        test dword [esp], eax
        je short .8
        xor ebx, ebx
        jmp short .6
.5:
        lea eax, [ebx+ebp]
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        cmp edx, dword [nosplit eax*4+confteams]
        je short .7
        inc ebx
.6:
        cmp ebx, edi
        jl short POPickConfTeams.5
.7:
        mov cl, bl
        mov eax, 1
        shl eax, cl
        or esi, eax
.8:
        xor ebx, ebx
.9:
        movsx eax, di
        call randomd0
        movsx edx, ax
        mov dword [byte esp+ebx*4+08h], edx
.10:
        mov edx, ebx
        shl edx, 2
        mov cl, byte [byte esp+edx+08h]
        mov eax, 1
        shl eax, cl
        test esi, eax
        je short .11
        movsx eax, di
        call randomd0
        cwde
        mov dword [byte esp+edx+08h], eax
        jmp short POPickConfTeams.10
.11:
        or esi, eax
        inc ebx
        cmp ebx, byte 8
        jl short POPickConfTeams.9
        mov eax, dword [byte esp+0Ch]
        mov eax, dword [nosplit eax*4+confteams]
        mov edx, dword [byte esp+08h]
        mov edx, dword [nosplit edx*4+confteams]
        mov edx, dword [nosplit edx*4+teamdivflags]
        cmp edx, dword [nosplit eax*4+teamdivflags]
        jne short .14
        mov ebx, 2
        jmp short .13
.12:
        inc ebx
.13:
        mov edx, ebx
        shl edx, 2
        mov eax, dword [byte esp+edx+08h]
        mov eax, dword [nosplit eax*4+confteams]
        mov esi, dword [byte esp+08h]
        mov esi, dword [nosplit esi*4+confteams]
        mov esi, dword [nosplit esi*4+teamdivflags]
        cmp esi, dword [nosplit eax*4+teamdivflags]
        je short POPickConfTeams.12
        mov esi, dword [byte esp+0Ch]
        mov eax, dword [byte esp+edx+08h]
        mov dword [byte esp+0Ch], eax
        mov dword [byte esp+edx+08h], esi
.14:
        xor ebx, ebx
        xor esi, esi
        jmp short .17
.15:
        mov eax, ebx
        shl eax, 2
        add eax, dword [byte esp+04h]
        mov edx, dword [esp]
        neg edx
        cmp edx, dword [eax]
        jne short .16
        mov edx, dword [byte esp+esi*4+08h]
        add edx, ebp
        mov edx, dword [nosplit edx*4+confteams]
        mov dword [eax], edx
        inc esi
.16:
        inc ebx
.17:
        cmp ebx, byte 10h
        jl short POPickConfTeams.15
        add esp, byte 28h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POCreateSchedule                                                8721F  95 PC
; Allocates schedule.db, POInitSchedule; if HomeTeam and VisTeam are in
; different conferences pre-simulates rounds 1-3 with them winning
; (POPreSimRound1/2/ConfFinals) so they meet in the final; finds their game
; (+40h current game, +44h current series) and writes schedule.db
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POCreateSchedule.c
%ifdef CBUILD
%include "c/front/playoff_mode/POCreateSchedule.inc"
%else
POCreateSchedule:
        push dword 0A8h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 84h
        mov ebp, eax
        mov edi, edx
        xor ecx, ecx
        mov ebx, str_ScheduleDb
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8B8
        add esp, byte 8
        lea esi, [byte eax+02h]
        test esi, esi
        jne short .1
        mov eax, 1
        jmp near .10
.1:
        mov dword [dword esi+088h], 7
        mov eax, dword [dword esi+088h]
        mov dword [dword esi+084h], eax
        mov dword [dword esi+080h], eax
        mov dword [byte esi+07Ch], eax
        mov dword [byte esi+078h], eax
        mov dword [byte esi+074h], eax
        mov dword [byte esi+070h], eax
        mov dword [byte esi+06Ch], eax
        mov dword [byte esi+068h], eax
        mov dword [byte esi+064h], eax
        mov dword [byte esi+060h], eax
        mov dword [byte esi+05Ch], eax
        mov dword [byte esi+058h], eax
        mov dword [byte esi+054h], eax
        mov dword [byte esi+050h], eax
        mov edx, ebp
        mov eax, esi
        call POInitSchedule
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [nosplit eax*4+teamconf]
        cmp eax, dword [nosplit edx*4+teamconf]
        je near .5
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_extDB
        mov edx, edi
        lea eax, [byte esp+040h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+044h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [seasondb], eax
        lea eax, [byte esp+040h]
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [seasondb_size], eax
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_extDB
        mov edx, edi
        lea eax, [byte esp+040h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+044h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [careerdb], eax
        lea eax, [byte esp+040h]
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [careerdb_size], eax
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, edi
        lea eax, [byte esp+040h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+044h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [keydb], eax
        lea eax, [byte esp+040h]
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [keydb_size], eax
        mov ebx, dword [VisTeam-2]
        sar ebx, 10h
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov eax, esi
        call POPreSimRound1
        mov eax, esi
        call POSeedRound2
        mov ebx, dword [VisTeam-2]
        sar ebx, 10h
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov eax, esi
        call POPreSimRound2
        mov eax, esi
        call POSeedConfFinals
        mov ebx, dword [VisTeam-2]
        sar ebx, 10h
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov eax, esi
        call POPreSimConfFinals
        mov eax, esi
        call POSeedFinal
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_extDB
        mov edx, edi
        lea eax, [byte esp+040h]
        call MakePath
        mov ecx, dword [seasondb_size]
        push ecx
        mov edi, dword [seasondb]
        push edi
        lea eax, [byte esp+048h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov ebp, dword [seasondb]
        test ebp, ebp
        je short .2
        push ebp
        call FreeMemBlock
        add esp, byte 4
.2:
        mov edx, dword [careerdb]
        test edx, edx
        je short .3
        push edx
        call FreeMemBlock
        add esp, byte 4
.3:
        mov ecx, dword [keydb]
        test ecx, ecx
        je short .4
        push ecx
        call FreeMemBlock
        add esp, byte 4
.4:
        xor ebp, ebp
        mov dword [seasondb], ebp
        mov dword [careerdb], ebp
        mov dword [keydb], ebp
        mov dword [seasondb_size], ebp
        mov dword [careerdb_size], ebp
        mov dword [keydb_size], ebp
.5:
        xor edx, edx
        lea eax, [dword esi+01998h]
        mov di, word [VisTeam]
        mov cx, word [HomeTeam]
        jmp short .7
.6:
        add edx, byte 7
        add eax, byte 2Ah
.7:
        xor ebx, ebx
        mov bl, byte [byte eax+02h]
        cmp bx, cx
        jne short POCreateSchedule.6
        xor ebx, ecx
        mov bl, byte [byte eax+03h]
        cmp bx, di
        jne short POCreateSchedule.6
        mov dword [byte esi+040h], edx
        mov ebx, 7
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esi+044h], eax
        mov eax, esp
        push eax
        call GetFileSize
        mov ecx, eax
        add esp, byte 4
        lea edx, [dword esp+080h]
        mov eax, esp
        call FileOpenWrite
        mov edx, eax
        lea eax, [byte esi-02h]
        test edx, edx
        je short .8
        mov edi, 1
        mov esi, eax
        jmp short .9
.8:
        mov esi, eax
        xor ebx, ebx
        mov edx, eax
        mov eax, dword [dword esp+080h]
        call FileWriteAt
        mov edi, eax
        lea eax, [dword esp+080h]
        call FileClose
.9:
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, edi
.10:
        add esp, 84h
POCreateSchedule_x:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POSetSeriesTeams                                                87520  95 PC
; (series, team A, team B): writes home/away into the 7 game records of a
; 7-game series (A home in games 1,2,5,7 = 2-2-1-1-1, or games 1,2,6,7 =
; 2-3-2 when the two teams' teamdivflags OR to 3), clears the scores to FFh
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSetSeriesTeams.c
%ifdef CBUILD
%include "c/front/playoff_mode/POSetSeriesTeams.inc"
%else
POSetSeriesTeams:
        push dword 8
        call __CHK
        push ecx
        mov ecx, dword [nosplit edx*4+teamdivflags]
        or ecx, dword [nosplit ebx*4+teamdivflags]
        cmp ecx, byte 3
        jne short .1
        mov byte [byte eax+026h], dl
        mov byte [byte eax+020h], dl
        mov byte [byte eax+01Bh], dl
        mov byte [byte eax+015h], dl
        mov byte [byte eax+0Fh], dl
        mov byte [byte eax+08h], dl
        mov byte [byte eax+02h], dl
        mov byte [byte eax+027h], bl
        mov byte [byte eax+021h], bl
        mov byte [byte eax+01Ah], bl
        jmp short .2
.1:
        mov byte [byte eax+026h], dl
        mov byte [byte eax+021h], dl
        mov byte [byte eax+01Ah], dl
        mov byte [byte eax+015h], dl
        mov byte [byte eax+0Fh], dl
        mov byte [byte eax+08h], dl
        mov byte [byte eax+02h], dl
        mov byte [byte eax+027h], bl
        mov byte [byte eax+020h], bl
        mov byte [byte eax+01Bh], bl
.2:
        mov byte [byte eax+014h], bl
        mov byte [byte eax+0Eh], bl
        mov byte [byte eax+09h], bl
        mov byte [byte eax+03h], bl
        xor ebx, ebx
.3:
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        mov byte [byte eax+edx*2+04h], 0FFh
        mov byte [byte eax+edx*2+05h], 0FFh
        inc ebx
        cmp ebx, byte 7
        jl short POSetSeriesTeams.3
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POInitSchedule                                                  875A3  95 PC
; Copies the 16 seeds, dates the round-1 games (every other day from Apr
; 17/16), pairs seeds 1v8 .. 4v5 per conference into the 8 round-1 series at
; +1998h/+1A40h and clears the 7 later series (31h records)
;-----------------------------------------------------------------------------
POInitSchedule:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov ebp, eax
        mov edi, edx
        xor ebx, ebx
.1:
        mov edx, ebx
        mov eax, dword [edi+edx*4]
        mov dword [byte ebp+edx*4+00h], eax
        inc ebx
        cmp ebx, byte 10h
        jl short POInitSchedule.1
        lea ecx, [dword ebp+01998h]
        xor ebx, ebx
.2:
        mov eax, ebx
        mov esi, ebx
        shl esi, 2
        sub esi, ebx
        add esi, esi
        add esi, ecx
        mov byte [esi], 4
        mov dword [byte esp+020h], 7
        mov edx, ebx
        sar edx, 1Fh
        idiv dword [byte esp+020h]
        add edx, edx
        add edx, byte 11h
        mov byte [byte esi+01h], dl
        cmp dl, 1Eh
        jbe short .3
        inc byte [esi]
        sub byte [byte esi+01h], 1Eh
.3:
        inc ebx
        cmp ebx, byte 1Ch
        jl short POInitSchedule.2
        lea ecx, [dword ebp+01A40h]
        xor ebx, ebx
.4:
        mov esi, ebx
        shl esi, 2
        sub esi, ebx
        add esi, esi
        add esi, ecx
        mov byte [esi], 4
        mov dword [byte esp+020h], 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv dword [byte esp+020h]
        add edx, edx
        add edx, byte 10h
        mov byte [byte esi+01h], dl
        cmp dl, 1Eh
        jbe short .5
        inc byte [esi]
        sub byte [byte esi+01h], 1Eh
.5:
        inc ebx
        cmp ebx, byte 1Ch
        jl short POInitSchedule.4
        xor ebx, ebx
        xor eax, eax
        jmp short .8
.6:
        mov ecx, ebx
        shl ecx, 2
        add ecx, edi
        mov esi, dword [ecx]
        cmp dword [nosplit esi*4+teamconf], byte 3
        jne short .7
        mov dword [esp+eax*4], esi
        inc eax
.7:
        inc ebx
.8:
        cmp ebx, byte 10h
        jl short POInitSchedule.6
        lea eax, [dword ebp+01998h]
        mov ebx, dword [byte esp+01Ch]
        mov edx, dword [esp]
        call POSetSeriesTeams
        lea eax, [dword ebp+019C2h]
        mov ebx, dword [byte esp+018h]
        mov edx, dword [byte esp+04h]
        call POSetSeriesTeams
        lea eax, [dword ebp+019ECh]
        mov ebx, dword [byte esp+014h]
        mov edx, dword [byte esp+08h]
        call POSetSeriesTeams
        lea eax, [dword ebp+01A16h]
        mov ebx, dword [byte esp+010h]
        mov edx, dword [byte esp+0Ch]
        call POSetSeriesTeams
        xor ebx, ebx
        xor eax, eax
        jmp short .11
.9:
        mov ecx, ebx
        shl ecx, 2
        add ecx, edi
        mov esi, dword [ecx]
        cmp dword [nosplit esi*4+teamconf], byte 0Ch
        jne short .10
        mov dword [esp+eax*4], esi
        inc eax
.10:
        inc ebx
.11:
        cmp ebx, byte 10h
        jl short POInitSchedule.9
        lea eax, [dword ebp+01A40h]
        mov ebx, dword [byte esp+01Ch]
        mov edx, dword [esp]
        call POSetSeriesTeams
        lea eax, [dword ebp+01A6Ah]
        mov ebx, dword [byte esp+018h]
        mov edx, dword [byte esp+04h]
        call POSetSeriesTeams
        lea eax, [dword ebp+01A94h]
        mov ebx, dword [byte esp+014h]
        mov edx, dword [byte esp+08h]
        call POSetSeriesTeams
        lea eax, [dword ebp+01ABEh]
        mov ebx, dword [byte esp+010h]
        mov edx, dword [byte esp+0Ch]
        call POSetSeriesTeams
        lea ecx, [dword ebp+01AE8h]
        xor ebx, ebx
.12:
        mov byte [byte ecx+01h], 0
        mov al, byte [byte ecx+01h]
        mov byte [ecx], al
        mov byte [byte ecx+03h], 0FFh
        mov al, byte [byte ecx+03h]
        mov byte [byte ecx+02h], al
        mov byte [byte ecx+05h], 0FFh
        mov al, byte [byte ecx+05h]
        mov byte [byte ecx+04h], al
        inc ebx
        add ecx, byte 6
        cmp ebx, byte 31h
        jl short POInitSchedule.12
        add esp, byte 24h
        jmp near POCreateSchedule_x
;-----------------------------------------------------------------------------
; SeriesWinner                                 87760  95 PC, medium confidence
; (series games, best-of): counts each side's wins until one reaches
; best-of/2+1; -1 when a game is unplayed
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POCreateSchedule.c (SeriesWinner)
%ifdef CBUILD
%include "c/front/playoff_mode/POCreateSchedule.SeriesWinner.inc"
%else
SeriesWinner:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebp, edx
        shr ebp, 1
        inc ebp
        xor edx, edx
        mov dl, byte [byte eax+02h]
        mov dword [byte esp+08h], edx
        xor edx, edx
        mov dl, byte [byte eax+03h]
        mov dword [byte esp+04h], edx
        xor edx, edx
        xor ebx, ebx
        jmp short .7
.1:
        cmp byte [byte eax+04h], 0FFh
        jne short .2
        mov eax, 0FFFFFFFFh
        jmp short .10
.2:
        movzx esi, byte [byte eax+02h]
        mov dword [esp], esi
        lea edi, [byte ebx+01h]
        lea esi, [byte edx+01h]
        mov ecx, dword [esp]
        cmp ecx, dword [byte esp+08h]
        jne short .4
        mov cl, byte [byte eax+04h]
        cmp cl, byte [byte eax+05h]
        ja short .5
.3:
        mov edx, esi
        jmp short .6
.4:
        mov cl, byte [byte eax+04h]
        cmp cl, byte [byte eax+05h]
        ja short SeriesWinner.3
.5:
        mov ebx, edi
.6:
        add eax, byte 6
.7:
        cmp ebx, ebp
        jae short .8
        cmp edx, ebp
        jb short SeriesWinner.1
.8:
        cmp ebx, edx
        jle short .9
        mov eax, dword [byte esp+08h]
        jmp short .10
.9:
        mov eax, dword [byte esp+04h]
.10:
        add esp, byte 0Ch
        jmp near POCreateSchedule_x
%endif ; C
;-----------------------------------------------------------------------------
; POSeriesScore                                877E9  95 PC, medium confidence
; (series, &homewins, &awaywins, &home, &away): counts wins of the series'
; two teams until one reaches 4; returns -1 if it reaches an unplayed game
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSeriesScore.c
%ifdef CBUILD
%include "c/front/playoff_mode/POSeriesScore.inc"
%else
POSeriesScore:
        push dword 10h
        call __CHK
        push esi
        push edi
        push ebp
        mov esi, ecx
        xor ecx, ecx
        mov cl, byte [byte eax+02h]
        mov dword [esi], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov edi, dword [byte esp+010h]
        mov dword [edi], ecx
        mov dword [ebx], 0
        mov ecx, dword [ebx]
        mov dword [edx], ecx
        jmp short .6
.1:
        cmp byte [byte eax+04h], 0FFh
        jne short .2
        mov ecx, 0FFFFFFFFh
        jmp short .8
.2:
        xor ecx, ecx
        mov cl, byte [byte eax+02h]
        cmp ecx, dword [esi]
        jne short .3
        mov cl, byte [byte eax+04h]
        cmp cl, byte [byte eax+05h]
        ja short .4
        lea ebp, [byte edi+01h]
        mov dword [ebx], ebp
        jmp short .5
.3:
        mov cl, byte [byte eax+04h]
        cmp cl, byte [byte eax+05h]
        jbe short .4
        inc edi
        mov dword [ebx], edi
        jmp short .5
.4:
        inc dword [edx]
.5:
        add eax, byte 6
.6:
        cmp dword [edx], byte 4
        jge short .7
        mov edi, dword [ebx]
        cmp edi, byte 4
        jl short POSeriesScore.1
.7:
        xor ecx, ecx
.8:
        mov eax, ecx
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; POSeedRound2                                                    87863  95 PC
; Dates the round-2 games after the last round-1 date and pairs the round-1
; SeriesWinner results (two series per conference) with POSetSeriesTeams
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSeedRound2.c
%ifdef CBUILD
%include "c/front/playoff_mode/POSeedRound2.inc"
%else
POSeedRound2:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        mov esi, eax
        lea ecx, [dword eax+019BCh]
        xor ebx, ebx
.1:
        mov ah, byte [byte ecx+04h]
        cmp ah, 0FFh
        jne short .2
        mov dl, byte [byte ecx+02Eh]
        cmp dl, ah
        jne short .2
        mov dh, byte [byte ecx+058h]
        cmp dh, ah
        jne short .2
        mov al, byte [dword ecx+082h]
        cmp al, ah
        jne short .2
        mov ah, byte [dword ecx+0ACh]
        cmp ah, dl
        jne short .2
        cmp dh, byte [dword ecx+0D6h]
        jne short .2
        cmp al, byte [dword ecx+0100h]
        jne short .2
        cmp ah, byte [dword ecx+012Ah]
        jne short .2
        inc ebx
        sub ecx, byte 6
        cmp ebx, byte 6
        jl short POSeedRound2.1
.2:
        xor eax, eax
        mov al, byte [ecx]
        mov dword [byte esp+020h], eax
        xor eax, eax
        mov al, byte [byte ecx+01h]
        add eax, byte 3
        mov dword [byte esp+024h], eax
        lea ecx, [dword esi+01AE8h]
        xor ebx, ebx
.3:
        mov al, byte [byte esp+020h]
        mov byte [ecx], al
        mov edi, 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        add edx, edx
        add edx, dword [byte esp+024h]
        mov byte [byte ecx+01h], dl
        cmp dl, 1Eh
        jbe short .4
        inc byte [ecx]
        sub byte [byte ecx+01h], 1Eh
.4:
        inc ebx
        add ecx, byte 6
        cmp ebx, byte 0Eh
        jl short POSeedRound2.3
        dec dword [byte esp+024h]
        lea ecx, [dword esi+01B3Ch]
        xor ebx, ebx
        mov edi, 7
.5:
        mov al, byte [byte esp+020h]
        mov byte [ecx], al
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        add edx, edx
        add edx, dword [byte esp+024h]
        mov byte [byte ecx+01h], dl
        cmp dl, 1Eh
        jbe short .6
        inc byte [ecx]
        sub byte [byte ecx+01h], 1Eh
.6:
        inc ebx
        add ecx, byte 6
        cmp ebx, byte 0Eh
        jl short POSeedRound2.5
        mov ecx, 8
        mov edx, 0FFFFFFFFh
        mov eax, esp
        call __STOSD
        lea ecx, [dword esi+01998h]
        mov edx, dword [byte esi+050h]
        mov eax, ecx
        call SeriesWinner
        mov dword [byte esp+020h], eax
        xor edx, edx
        mov dl, byte [byte ecx+02h]
        cmp eax, edx
        jne short .7
        mov dword [esp], edx
        jmp short .8
.7:
        mov dword [byte esp+01Ch], eax
.8:
        mov edx, dword [byte esi+054h]
        add ecx, byte 2Ah
        mov eax, ecx
        call SeriesWinner
        mov dword [byte esp+024h], eax
        xor edx, edx
        mov dl, byte [byte ecx+02h]
        cmp eax, edx
        jne short .9
        mov dword [byte esp+04h], edx
        jmp short .10
.9:
        mov dword [byte esp+018h], eax
.10:
        mov edx, dword [byte esi+058h]
        add ecx, byte 2Ah
        mov eax, ecx
        call SeriesWinner
        mov dword [byte esp+028h], eax
        xor edx, edx
        mov dl, byte [byte ecx+02h]
        cmp eax, edx
        jne short .11
        mov dword [byte esp+08h], edx
        jmp short .12
.11:
        mov dword [byte esp+014h], eax
.12:
        mov edx, dword [byte esi+05Ch]
        add ecx, byte 2Ah
        mov eax, ecx
        call SeriesWinner
        mov dword [byte esp+02Ch], eax
        xor edx, edx
        mov dl, byte [byte ecx+02h]
        cmp eax, edx
        jne short .13
        mov dword [byte esp+0Ch], edx
        jmp short .14
.13:
        mov dword [byte esp+010h], eax
.14:
        xor ebx, ebx
        xor edx, edx
        jmp short .17
.15:
        mov eax, ebx
        shl eax, 2
        mov ecx, dword [esp+eax]
        test ecx, ecx
        jl short .16
        cmp ecx, byte 1Ah
        jge short .16
        mov dword [byte esp+edx*4+020h], ecx
        inc edx
.16:
        inc ebx
.17:
        cmp ebx, byte 8
        jl short POSeedRound2.15
        lea ecx, [dword esi+01AE8h]
        mov ebx, dword [byte esp+02Ch]
        mov edx, dword [byte esp+020h]
        mov eax, ecx
        call POSetSeriesTeams
        lea eax, [byte ecx+02Ah]
        mov ebx, dword [byte esp+028h]
        mov edx, dword [byte esp+024h]
        call POSetSeriesTeams
        mov ecx, 8
        mov edx, 0FFFFFFFFh
        mov eax, esp
        call __STOSD
        lea ecx, [dword esi+01A40h]
        mov edx, dword [byte esi+060h]
        mov eax, ecx
        call SeriesWinner
        mov dword [byte esp+020h], eax
        xor edx, edx
        mov dl, byte [byte ecx+02h]
        cmp eax, edx
        jne short .18
        mov dword [esp], edx
        jmp short .19
.18:
        mov dword [byte esp+01Ch], eax
.19:
        mov edx, dword [byte esi+064h]
        add ecx, byte 2Ah
        mov eax, ecx
        call SeriesWinner
        mov dword [byte esp+024h], eax
        xor edx, edx
        mov dl, byte [byte ecx+02h]
        cmp eax, edx
        jne short .20
        mov dword [byte esp+04h], edx
        jmp short .21
.20:
        mov dword [byte esp+018h], eax
.21:
        mov edx, dword [byte esi+068h]
        add ecx, byte 2Ah
        mov eax, ecx
        call SeriesWinner
        mov dword [byte esp+028h], eax
        xor edx, edx
        mov dl, byte [byte ecx+02h]
        cmp eax, edx
        jne short .22
        mov dword [byte esp+08h], edx
        jmp short .23
.22:
        mov dword [byte esp+014h], eax
.23:
        mov edx, dword [byte esi+06Ch]
        add ecx, byte 2Ah
        mov eax, ecx
        call SeriesWinner
        mov dword [byte esp+02Ch], eax
        xor edx, edx
        mov dl, byte [byte ecx+02h]
        cmp eax, edx
        jne short .24
        mov dword [byte esp+0Ch], edx
        jmp short .25
.24:
        mov dword [byte esp+010h], eax
.25:
        xor ebx, ebx
        xor edx, edx
        jmp short .28
.26:
        mov eax, ebx
        shl eax, 2
        mov ebp, dword [esp+eax]
        test ebp, ebp
        jl short .27
        cmp ebp, byte 1Ah
        jge short .27
        mov dword [byte esp+edx*4+020h], ebp
        inc edx
.27:
        inc ebx
.28:
        cmp ebx, byte 8
        jl short POSeedRound2.26
        lea ecx, [dword esi+01B3Ch]
        mov ebx, dword [byte esp+02Ch]
        mov edx, dword [byte esp+020h]
        mov eax, ecx
        call POSetSeriesTeams
        lea eax, [byte ecx+02Ah]
        mov ebx, dword [byte esp+028h]
        mov edx, dword [byte esp+024h]
        call POSetSeriesTeams
POSeedRound2_x30:
        add esp, byte 30h
POSeedRound2_x:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POSeedConfFinals                                                87B33  95 PC
; Dates the conference-final games and pairs the round-2 winners, higher seed
; (earlier in the seed list) at home
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSeedRound2.c (POSeedConfFinals)
%ifdef CBUILD
%include "c/front/playoff_mode/POSeedRound2.POSeedConfFinals.inc"
%else
POSeedConfFinals:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, eax
        lea ecx, [dword eax+01B0Ch]
        xor ebx, ebx
.1:
        mov ah, byte [byte ecx+04h]
        cmp ah, 0FFh
        jne short .2
        cmp ah, byte [byte ecx+02Eh]
        jne short .2
        cmp ah, byte [byte ecx+058h]
        jne short .2
        cmp ah, byte [dword ecx+082h]
        jne short .2
        inc ebx
        sub ecx, byte 6
        cmp ebx, byte 3
        jl short POSeedConfFinals.1
.2:
        xor eax, eax
        mov al, byte [ecx]
        mov dword [esp], eax
        movzx esi, byte [byte ecx+01h]
        add esi, byte 3
        lea ecx, [dword ebp+01B90h]
        xor ebx, ebx
        mov edi, 7
.3:
        mov al, byte [esp]
        mov byte [ecx], al
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        lea eax, [edx+edx]
        add eax, esi
        mov byte [byte ecx+01h], al
        cmp al, 1Fh
        jbe short .4
        inc byte [ecx]
        sub byte [byte ecx+01h], 1Fh
.4:
        inc ebx
        add ecx, byte 6
        cmp ebx, byte 7
        jl short POSeedConfFinals.3
        dec esi
        lea ecx, [dword ebp+01BBAh]
        xor ebx, ebx
        mov edi, 7
.5:
        mov al, byte [esp]
        mov byte [ecx], al
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        lea eax, [edx+edx]
        add eax, esi
        mov byte [byte ecx+01h], al
        cmp al, 1Fh
        jbe short .6
        inc byte [ecx]
        sub byte [byte ecx+01h], 1Fh
.6:
        inc ebx
        add ecx, byte 6
        cmp ebx, byte 7
        jl short POSeedConfFinals.5
        lea ecx, [dword ebp+01AE8h]
        mov edx, dword [byte ebp+070h]
        mov eax, ecx
        call SeriesWinner
        mov dword [esp], eax
        mov edx, dword [byte ebp+074h]
        lea eax, [byte ecx+02Ah]
        call SeriesWinner
        mov esi, eax
        mov eax, ebp
        mov ebx, dword [esp]
        jmp short .8
.7:
        add eax, byte 4
.8:
        mov edx, dword [eax]
        cmp edx, ebx
        je short .9
        cmp esi, edx
        jne short POSeedConfFinals.7
.9:
        lea ecx, [dword ebp+01B90h]
        mov eax, dword [eax]
        mov edi, dword [esp]
        cmp eax, edi
        jne short .10
        mov ebx, esi
        mov edx, edi
        jmp short .11
.10:
        mov ebx, edi
        mov edx, esi
.11:
        mov eax, ecx
        call POSetSeriesTeams
        lea ecx, [dword ebp+01B3Ch]
        mov edx, dword [byte ebp+078h]
        mov eax, ecx
        call SeriesWinner
        mov dword [esp], eax
        mov edx, dword [byte ebp+07Ch]
        lea eax, [byte ecx+02Ah]
        call SeriesWinner
        mov esi, eax
        mov eax, ebp
        mov ebx, dword [esp]
        jmp short .13
.12:
        add eax, byte 4
.13:
        mov edx, dword [eax]
        cmp edx, ebx
        je short .14
        cmp esi, edx
        jne short POSeedConfFinals.12
.14:
        lea ecx, [dword ebp+01BBAh]
POSeedConfFinals_pair:
        mov eax, dword [eax]
        mov edi, dword [esp]
        cmp eax, edi
        jne short POSeedConfFinals_x.18
        mov ebx, esi
        mov edx, edi
.16:
        mov eax, ecx
        call POSetSeriesTeams
POSeedConfFinals_x:
        add esp, byte 4
        jmp near POSeedRound2_x
.18:
        mov ebx, edi
        mov edx, esi
        jmp short POSeedConfFinals_pair.16
%endif ; C
;-----------------------------------------------------------------------------
; POSeedFinal                                                     87C9E  95 PC
; Dates the Stanley Cup final games and pairs the two conference-final
; winners, higher seed at home
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSeedRound2.c (POSeedFinal)
%ifdef CBUILD
%include "c/front/playoff_mode/POSeedRound2.POSeedFinal.inc"
%else
POSeedFinal:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, eax
        lea ecx, [dword eax+01BB4h]
        xor ebx, ebx
.1:
        mov ah, byte [byte ecx+04h]
        cmp ah, 0FFh
        jne short .2
        cmp ah, byte [byte ecx+02Eh]
        jne short .2
        inc ebx
        sub ecx, byte 6
        cmp ebx, byte 3
        jl short POSeedFinal.1
.2:
        xor eax, eax
        mov al, byte [ecx]
        mov dword [esp], eax
        movzx esi, byte [byte ecx+01h]
        add esi, byte 3
        lea ecx, [dword ebp+01BE4h]
        xor ebx, ebx
        mov edi, 7
.3:
        mov al, byte [esp]
        mov byte [ecx], al
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        add edx, edx
        add edx, esi
        mov byte [byte ecx+01h], dl
        cmp dl, 1Fh
        jbe short .4
        inc byte [ecx]
        sub byte [byte ecx+01h], 1Fh
.4:
        inc ebx
        add ecx, byte 6
        cmp ebx, byte 7
        jl short POSeedFinal.3
        lea ecx, [dword ebp+01B90h]
        mov edx, dword [dword ebp+080h]
        mov eax, ecx
        call SeriesWinner
        mov dword [esp], eax
        mov edx, dword [dword ebp+084h]
        lea eax, [byte ecx+02Ah]
        call SeriesWinner
        mov esi, eax
        mov eax, ebp
        mov ebx, dword [esp]
        jmp short .6
.5:
        add eax, byte 4
.6:
        mov edx, dword [eax]
        cmp edx, ebx
        je short .7
        cmp esi, edx
        jne short POSeedFinal.5
.7:
        lea ecx, [dword ebp+01BE4h]
        jmp near POSeedConfFinals_pair
%endif ; C
;-----------------------------------------------------------------------------
; POSimSeriesTeamWins                          87D5A  95 PC, medium confidence
; Simulates a series (SimulateGame on TEAMS/CARTEAMS) forcing the given team
; to win whenever it is not ahead, until it has 4 wins (used to pre-advance
; the human teams)
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POCreateSchedule.c (POSimSeriesTeamWins)
%ifdef CBUILD
%include "c/front/playoff_mode/POCreateSchedule.POSimSeriesTeamWins.inc"
%else
POSimSeriesTeamWins:
        push dword 70h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4Ch
        mov esi, eax
        mov dword [byte esp+048h], edx
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+044h]
        mov eax, esp
        call FileOpenRW
        test eax, eax
        je short .1
        push str_E1
        call FatalError
        add esp, byte 4
.1:
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+040h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .2
        push str_E2
        call FatalError
        add esp, byte 4
.2:
        xor ebp, ebp
        xor edi, edi
        jmp near .11
.3:
        cmp ebp, edi
        jge short .4
        push byte 2
        mov ebx, dword [byte esp+044h]
        push ebx
        mov ecx, dword [byte esp+04Ch]
        push ecx
        jmp short .6
.4:
        xor eax, eax
        mov al, byte [byte esi+02h]
        cmp eax, dword [byte esp+048h]
        jne short .5
        push byte 0
        mov eax, dword [byte esp+044h]
        push eax
        mov edx, dword [byte esp+04Ch]
        push edx
        jmp short .6
.5:
        push byte 1
        mov ebx, dword [byte esp+044h]
        push ebx
        mov ecx, dword [byte esp+04Ch]
        push ecx
.6:
        mov ecx, esi
        mov ebx, 44Ch
        mov edx, str_extDB
        mov eax, curleague
        call SimulateGame
        xor ebx, ebx
        mov bl, byte [byte esi+02h]
        lea eax, [byte edi+01h]
        lea edx, [byte ebp+01h]
        cmp ebx, dword [byte esp+048h]
        jne short .8
        mov bl, byte [byte esi+04h]
        cmp bl, byte [byte esi+05h]
        jbe short .9
.7:
        mov edi, eax
        jmp short .10
.8:
        mov bl, byte [byte esi+05h]
        cmp bl, byte [byte esi+04h]
        ja short POSimSeriesTeamWins.7
.9:
        mov ebp, edx
.10:
        add esi, byte 6
.11:
        cmp edi, byte 4
        jl short POSimSeriesTeamWins.3
        lea eax, [byte esp+044h]
        call FileClose
        lea eax, [byte esp+040h]
        call FileClose
        add esp, byte 4Ch
        jmp near POCreateSchedule_x
%endif ; C
;-----------------------------------------------------------------------------
; POSimSeries                                                     87E77  95 PC
; (series, length): simulates the series' unplayed games until one team
; reaches length/2+1 wins
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POCreateSchedule.c (POSimSeries)
%ifdef CBUILD
%include "c/front/playoff_mode/POCreateSchedule.POSimSeries.inc"
%else
POSimSeries:
        push dword 74h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 50h
        mov esi, eax
        mov dword [byte esp+04Ch], edx
        mov eax, edx
        shr eax, 1
        inc eax
        mov dword [byte esp+04Ch], eax
        xor eax, eax
        mov al, byte [byte esi+02h]
        mov dword [byte esp+048h], eax
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+044h]
        mov eax, esp
        call FileOpenRW
        test eax, eax
        je short .1
        push str_F1
        call FatalError
        add esp, byte 4
.1:
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+040h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .2
        push str_F2
        call FatalError
        add esp, byte 4
.2:
        xor edi, edi
        xor ebp, ebp
        jmp short .9
.3:
        cmp byte [byte esi+04h], 0FFh
        jne short .4
        push byte 2
        mov ecx, dword [byte esp+044h]
        push ecx
        mov eax, dword [byte esp+04Ch]
        push eax
        mov ecx, esi
        mov ebx, 44Ch
        mov edx, str_extDB
        mov eax, curleague
        call SimulateGame
.4:
        xor ebx, ebx
        mov bl, byte [byte esi+02h]
        lea eax, [byte ebp+01h]
        lea edx, [byte edi+01h]
        cmp ebx, dword [byte esp+048h]
        jne short .6
        mov bl, byte [byte esi+04h]
        cmp bl, byte [byte esi+05h]
        ja short .7
.5:
        mov edi, edx
        jmp short .8
.6:
        mov bl, byte [byte esi+04h]
        cmp bl, byte [byte esi+05h]
        ja short POSimSeries.5
.7:
        mov ebp, eax
.8:
        add esi, byte 6
.9:
        mov edx, dword [byte esp+04Ch]
        cmp ebp, edx
        jae short .10
        cmp edi, edx
        jb short POSimSeries.3
.10:
        lea eax, [byte esp+044h]
        call FileClose
        lea eax, [byte esp+040h]
        call FileClose
        add esp, byte 50h
        jmp near POCreateSchedule_x
%endif ; C
;-----------------------------------------------------------------------------
; POPreSimRound1                               87F85  95 PC, medium confidence
; The 8 round-1 series: POSimSeriesTeamWins for the series holding HomeTeam
; or VisTeam, POSimSeries (best of 7) for the rest
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POPreSimRound1.c
%ifdef CBUILD
%include "c/front/playoff_mode/POPreSimRound1.inc"
%else
POPreSimRound1:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov esi, edx
        mov ecx, ebx
        lea ebx, [dword eax+01998h]
        xor edi, edi
.1:
        xor edx, edx
        mov dl, byte [byte ebx+02h]
        cmp edx, esi
        je short .2
        xor eax, eax
        mov al, byte [byte ebx+03h]
        cmp eax, esi
        jne short .4
.2:
        mov edx, esi
.3:
        mov eax, ebx
        call POSimSeriesTeamWins
        jmp short .7
.4:
        cmp edx, ecx
        je short .5
        cmp eax, ecx
        jne short .6
.5:
        mov edx, ecx
        jmp short POPreSimRound1.3
.6:
        mov edx, 7
        mov eax, ebx
        call POSimSeries
.7:
        inc edi
        add ebx, byte 2Ah
        cmp edi, byte 8
        jl short POPreSimRound1.1
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POPreSimRound2                               87FE0  95 PC, medium confidence
; As POPreSimRound1 for the 4 round-2 series at +1AE8h
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POPreSimRound2.c
%ifdef CBUILD
%include "c/front/playoff_mode/POPreSimRound2.inc"
%else
POPreSimRound2:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov esi, edx
        mov ecx, ebx
        lea ebx, [dword eax+01AE8h]
        xor edi, edi
.1:
        xor edx, edx
        mov dl, byte [byte ebx+02h]
        cmp edx, esi
        je short .2
        xor eax, eax
        mov al, byte [byte ebx+03h]
        cmp eax, esi
        jne short .4
.2:
        mov edx, esi
.3:
        mov eax, ebx
        call POSimSeriesTeamWins
        jmp short .7
.4:
        cmp edx, ecx
        je short .5
        cmp eax, ecx
        jne short .6
.5:
        mov edx, ecx
        jmp short POPreSimRound2.3
.6:
        mov edx, 7
        mov eax, ebx
        call POSimSeries
.7:
        inc edi
        add ebx, byte 2Ah
        cmp edi, byte 4
        jl short POPreSimRound2.1
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POPreSimConfFinals                           8803B  95 PC, medium confidence
; As POPreSimRound1 for the 2 conference-final series at +1B90h
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POPreSimConfFinals.c
%ifdef CBUILD
%include "c/front/playoff_mode/POPreSimConfFinals.inc"
%else
POPreSimConfFinals:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov esi, edx
        mov ecx, ebx
        lea ebx, [dword eax+01B90h]
        xor edi, edi
.1:
        xor edx, edx
        mov dl, byte [byte ebx+02h]
        cmp edx, esi
        je short .2
        xor eax, eax
        mov al, byte [byte ebx+03h]
        cmp eax, esi
        jne short .4
.2:
        mov edx, esi
.3:
        mov eax, ebx
        call POSimSeriesTeamWins
        jmp short .7
.4:
        cmp edx, ecx
        je short .5
        cmp eax, ecx
        jne short .6
.5:
        mov edx, ecx
        jmp short POPreSimConfFinals.3
.6:
        mov edx, 7
        mov eax, ebx
        call POSimSeries
.7:
        inc edi
        add ebx, byte 2Ah
        cmp edi, byte 2
        jl short POPreSimConfFinals.1
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POHandleElimination                                             88096  95 PC
; (result, sched): 0 = just redraw the playoff tree; 1 = asks 'Your team has
; been eliminated ... see the final results?' and simulates every remaining
; series ('Generating the final results.'); 2 = 'The X have been eliminated
; ... The Y will continue'; updates playofftree / pochampion and saves
;-----------------------------------------------------------------------------
POHandleElimination:
        push dword 9Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 70h
        mov esi, eax
        mov ebp, edx
        mov dword [byte esp+064h], 0A0h
        mov dword [byte esp+060h], 64h
        xor ecx, ecx
        mov dword [dword_C6D26], ecx
        call DrawPlayoffTree
        mov ebx, str_Embpal
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [byte esp+040h]
        call MakePath
        push byte 0
        lea eax, [byte esp+044h]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        mov dword [byte esp+068h], eax
        push str_BangPal
        push eax
        call FindShape
        add esp, byte 8
        add eax, byte 10h
        mov dword [byte esp+06Ch], eax
        test esi, esi
        jne short .3
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 3
        mov eax, playoffmenubar
        call DrawMenuBar
        mov ebx, 10h
        mov edx, dword [byte esp+06Ch]
        xor eax, eax
        call FadePalStep
        push edi
        jmp near .34
.3:
        push byte 0
        mov ecx, 40h
        mov ebx, 42h
        mov edx, ecx
        mov eax, 41h
        call SetDialogColors
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [seasondb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [seasondb_size], eax
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [careerdb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [careerdb_size], eax
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [keydb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [keydb_size], eax
        cmp esi, byte 1
        jne near .29
        mov ebx, 10h
        mov edx, dword [byte esp+06Ch]
        xor eax, eax
        call FadePalStep
        push byte 0FFFFFFFFh
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 2
        push btn_POHumanOut
        mov ecx, 4
        mov ebx, msg_POHumanOut
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        test eax, eax
        je near .30
        push byte 0
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, esi
        mov ebx, msg_POGenFinal
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov eax, dword [byte ebp+044h]
        cmp eax, byte 8
        jb short .4
        cmp eax, byte 0Bh
        jbe near .11
        cmp eax, byte 0Dh
        jbe near .18
        jmp near .24
.4:
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Dh
        mov dword [byte ebp+07Ch], eax
        mov dword [byte ebp+078h], eax
        mov dword [byte ebp+074h], eax
        mov dword [byte ebp+070h], eax
        lea esi, [dword ebp+01AE8h]
        mov edi, 8
.5:
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, esi
        call POSimSeries
        xor edx, edx
        jmp short .7
.6:
        inc edx
.7:
        cmp edx, byte 7
        jge short .8
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [byte esi+eax*2+04h], 0FFh
        jne short POHandleElimination.6
.8:
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Eh
        lea ebx, [byte eax+01h]
        sub edx, ebx
        jmp short .10
.9:
        lea ecx, [edx+ebx]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov byte [byte esi+eax*2+05h], 0FFh
        mov cl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], cl
        mov byte [byte esi+eax*2+03h], cl
        mov byte [byte esi+eax*2+02h], cl
        mov byte [byte esi+eax*2+01h], cl
        mov byte [esi+eax*2], cl
        inc ebx
.10:
        cmp ebx, byte 4
        jl short POHandleElimination.9
        inc edi
        add esi, byte 2Ah
        cmp edi, byte 0Ch
        jl short POHandleElimination.5
        mov eax, ebp
        call POSeedConfFinals
.11:
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Dh
        mov dword [dword ebp+084h], eax
        mov dword [dword ebp+080h], eax
        lea esi, [dword ebp+01B90h]
        mov edi, 0Ch
.12:
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, esi
        call POSimSeries
        xor edx, edx
        jmp short .14
.13:
        inc edx
.14:
        cmp edx, byte 7
        jge short .15
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [byte esi+eax*2+04h], 0FFh
        jne short POHandleElimination.13
.15:
        mov ebx, dword [gameopts]
        shl ebx, 11h
        shr ebx, 1Eh
        inc ebx
        sub edx, ebx
        jmp short .17
.16:
        lea ecx, [edx+ebx]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov byte [byte esi+eax*2+05h], 0FFh
        mov cl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], cl
        mov byte [byte esi+eax*2+03h], cl
        mov byte [byte esi+eax*2+02h], cl
        mov byte [byte esi+eax*2+01h], cl
        mov byte [esi+eax*2], cl
        inc ebx
.17:
        cmp ebx, byte 4
        jl short POHandleElimination.16
        inc edi
        add esi, byte 2Ah
        cmp edi, byte 0Eh
        jl short POHandleElimination.12
        mov eax, ebp
        call POSeedFinal
.18:
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Dh
        mov dword [dword ebp+088h], eax
        lea esi, [dword ebp+01BE4h]
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, esi
        call POSimSeries
        xor edx, edx
        jmp short .20
.19:
        inc edx
.20:
        cmp edx, byte 7
        jge short .21
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [byte esi+eax*2+04h], 0FFh
        jne short POHandleElimination.19
.21:
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Eh
        lea ebx, [byte eax+01h]
        sub edx, ebx
        jmp short .23
.22:
        lea ecx, [edx+ebx]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov byte [byte esi+eax*2+05h], 0FFh
        mov cl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], cl
        mov byte [byte esi+eax*2+03h], cl
        mov byte [byte esi+eax*2+02h], cl
        mov byte [byte esi+eax*2+01h], cl
        mov byte [esi+eax*2], cl
        inc ebx
.23:
        cmp ebx, byte 4
        jl short POHandleElimination.22
.24:
        lea esi, [dword ebp+01AE8h]
        mov edi, 10h
        mov ebx, 1Ah
.25:
        xor edx, edx
        mov dl, byte [byte esi+02h]
        mov eax, edi
        shl eax, 2
        mov dword [dword eax+playofftree], edx
        xor edx, edx
        mov dl, byte [byte esi+03h]
        mov dword [dword eax+playofftree_p1], edx
        cmp dword [dword eax+playofftree], 0FFh
        jne short .26
        mov dword [dword eax+playofftree], ebx
.26:
        mov eax, edi
        shl eax, 2
        cmp dword [dword eax+playofftree_p1], 0FFh
        jne short .27
        mov dword [dword eax+playofftree_p1], 1Ah
.27:
        add edi, byte 2
        add esi, byte 2Ah
        cmp edi, byte 1Eh
        jl short POHandleElimination.25
        lea eax, [dword ebp+01BE4h]
        mov edx, dword [dword ebp+088h]
        call SeriesWinner
        mov dword [pochampion], eax
        cmp eax, byte 0FFFFFFFFh
        jne short .28
        mov dword [pochampion], 1Ah
.28:
        call RestoreDialogBg
        jmp short .30
.29:
        push dword 3E8h
        call SetTickDeadline
        add esp, byte 4
        mov ebx, 10h
        mov edx, dword [byte esp+06Ch]
        xor eax, eax
        call FadePalStep
        push byte 0
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 6
        mov ebx, msg_POTeamOut
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        call WaitTickDeadline
        call RestoreDialogBg
.30:
        mov ebx, 10h
        mov edx, dword [byte esp+06Ch]
        mov eax, 1
        call FadePalStep
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov ecx, dword [seasondb_size]
        push ecx
        mov esi, dword [seasondb]
        push esi
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov edi, dword [seasondb]
        test edi, edi
        je short .31
        push edi
        call FreeMemBlock
        add esp, byte 4
.31:
        mov edx, dword [careerdb]
        test edx, edx
        je short .32
        push edx
        call FreeMemBlock
        add esp, byte 4
.32:
        mov ecx, dword [keydb]
        test ecx, ecx
        je short .33
        push ecx
        call FreeMemBlock
        add esp, byte 4
.33:
        xor edi, edi
        mov dword [seasondb], edi
        mov dword [careerdb], edi
        mov dword [keydb], edi
        mov dword [seasondb_size], edi
        mov dword [careerdb_size], edi
        mov dword [keydb_size], edi
        mov eax, ebp
        call SaveScheduleDB
        mov dword [dword_C6D26], edi
        call DrawPlayoffTree
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 3
        mov eax, playoffmenubar
        call DrawMenuBar
        mov ebx, 10h
        mov edx, dword [byte esp+06Ch]
        xor eax, eax
        call FadePalStep
        mov ebp, dword [byte esp+068h]
        push ebp
.34:
        call FreeMemBlock
        add esp, byte 4
        add esp, byte 70h
        jmp near POCreateSchedule_x
;-----------------------------------------------------------------------------
; POSimSeriesTo                                88625  95 PC, medium confidence
; (sched, series, n): simulates the unplayed games of a series up to game n
; unless the series is already decided
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSimSeriesTo.c
%ifdef CBUILD
%include "c/front/playoff_mode/POSimSeriesTo.inc"
%else
POSimSeriesTo:
        push dword 4Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        mov esi, eax
        mov dword [byte esp+028h], ebx
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        add eax, eax
        add esi, 1998h
        add esi, eax
        mov ebp, esi
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, esi
        call SeriesWinner
        test eax, eax
        jge near .x
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+024h]
        mov eax, esp
        call FileOpenRW
        test eax, eax
        je short .1
        push str_E31
        call FatalError
        add esp, byte 4
.1:
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+020h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .2
        push str_E32
        call FatalError
        add esp, byte 4
.2:
        xor edi, edi
        jmp short .5
.3:
        cmp byte [byte esi+04h], 0FFh
        jne short .4
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, ebp
        call SeriesWinner
        test eax, eax
        jge short .6
        push byte 2
        mov ebx, dword [byte esp+024h]
        push ebx
        mov ecx, dword [byte esp+02Ch]
        push ecx
        mov ecx, esi
        mov ebx, 4B0h
        mov edx, str_extDB
        mov eax, curleague
        call SimulateGame
.4:
        inc edi
        add esi, byte 6
.5:
        cmp edi, dword [byte esp+028h]
        jl short POSimSeriesTo.3
.6:
        lea eax, [byte esp+024h]
        call FileClose
        lea eax, [byte esp+020h]
        call FileClose
.x:
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POAfterGame                                                     8873C  95 PC
; After a human playoff game: stores hmscore/awscore in the current game,
; simulates the other series of the round up to the same game number, seeds
; the next round when the human series is decided, picks the next human game
; (+40h/+44h, HomeTeam/VisTeam), builds the series-status line ('tied' /
; leads) and updates the controller teams; returns 1 when all humans are out,
; 2 when one is
;-----------------------------------------------------------------------------
POAfterGame:
        push dword 90h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 5Ch
        push eax
        xor edx, edx
        mov dword [byte esp+048h], edx
        mov eax, dword [byte eax+040h]
        mov dword [byte esp+05Ch], eax
        push curleague
        lea esi, [dword eax+0444h]
        push esi
        mov ebx, dword [HomeTeam-2]
        sar ebx, 10h
        xor ecx, ecx
        mov edx, str_Db
        mov eax, curleague
        call PostGameToTeamDb
        push curleague
        push esi
        mov ebx, dword [VisTeam-2]
        sar ebx, 10h
        mov ecx, 1
        mov edx, str_Db
        mov eax, curleague
        call PostGameToTeamDb
        mov eax, esi
        shl eax, 2
        sub eax, esi
        add eax, eax
        mov esi, dword [esp]
        add esi, eax
        mov ebx, 7
        mov eax, dword [byte esp+05Ch]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        lea ebp, [byte edx+01h]
        mov eax, dword [byte esp+05Ch]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+05Ch], eax
        mov al, byte [hmscore]
        mov byte [byte esi+04h], al
        mov al, byte [awscore]
        mov byte [byte esi+05h], al
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [byte esp+04h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+08h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [seasondb], eax
        lea eax, [byte esp+04h]
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [seasondb_size], eax
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [byte esp+04h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+08h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [careerdb], eax
        lea eax, [byte esp+04h]
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [careerdb_size], eax
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [byte esp+04h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+08h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [keydb], eax
        lea eax, [byte esp+04h]
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [keydb_size], eax
        mov ebx, dword [byte esp+05Ch]
        cmp ebx, byte 8
        jge short .3
        xor edi, edi
.1:
        cmp edi, dword [byte esp+05Ch]
        je short .2
        mov ebx, ebp
        mov edx, edi
        mov eax, dword [esp]
        call POSimSeriesTo
.2:
        inc edi
        cmp edi, byte 8
        jl short POAfterGame.1
        jmp short .9
.3:
        cmp ebx, byte 0Ch
        jge short .6
        mov edi, 8
.4:
        cmp edi, dword [byte esp+05Ch]
        je short .5
        mov ebx, ebp
        mov edx, edi
        mov eax, dword [esp]
        call POSimSeriesTo
.5:
        inc edi
        cmp edi, byte 0Ch
        jl short POAfterGame.4
        jmp short .9
.6:
        cmp ebx, byte 0Eh
        jge short .9
        mov edi, 0Ch
.7:
        cmp edi, dword [byte esp+05Ch]
        je short .8
        mov ebx, ebp
        mov edx, edi
        mov eax, dword [esp]
        call POSimSeriesTo
.8:
        inc edi
        cmp edi, byte 0Eh
        jl short POAfterGame.7
.9:
        mov edx, dword [byte esp+05Ch]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        lea edx, [dword eax+0444h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov ebp, dword [esp]
        add ebp, eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, ebp
        call SeriesWinner
        mov edi, eax
        test eax, eax
        jl near .55
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        cmp eax, edx
        sete al
        and eax, 0FFh
        mov dword [byte esp+044h], eax
        mov ebp, dword [gameopts]
        shl ebp, 11h
        mov edx, dword [byte esp+05Ch]
        cmp edx, byte 8
        jge near .17
        shr ebp, 1Dh
        mov eax, dword [esp]
        mov dword [byte eax+06Ch], ebp
        mov dword [byte eax+068h], ebp
        mov dword [byte eax+064h], ebp
        mov dword [byte eax+060h], ebp
        mov dword [byte eax+05Ch], ebp
        mov dword [byte eax+058h], ebp
        mov dword [byte eax+054h], ebp
        mov dword [byte eax+050h], ebp
        lea esi, [dword eax+01998h]
        xor ebp, ebp
.10:
        cmp ebp, dword [byte esp+05Ch]
        je short .11
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, esi
        call POSimSeries
.11:
        xor edx, edx
        jmp short .13
.12:
        inc edx
.13:
        cmp edx, byte 7
        jge short .14
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [byte esi+eax*2+04h], 0FFh
        jne short POAfterGame.12
.14:
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Eh
        lea ebx, [byte eax+01h]
        sub edx, ebx
        jmp short .16
.15:
        lea ecx, [edx+ebx]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov byte [byte esi+eax*2+05h], 0FFh
        mov cl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], cl
        mov byte [byte esi+eax*2+03h], cl
        mov byte [byte esi+eax*2+02h], cl
        mov byte [byte esi+eax*2+01h], cl
        mov byte [esi+eax*2], cl
        inc ebx
.16:
        cmp ebx, byte 4
        jl short POAfterGame.15
        inc ebp
        add esi, byte 2Ah
        cmp ebp, byte 8
        jl short POAfterGame.10
        mov eax, dword [esp]
        call POSeedRound2
        jmp near .39
.17:
        cmp edx, byte 0Ch
        jge near .25
        shr ebp, 1Dh
        mov eax, dword [esp]
        mov dword [byte eax+07Ch], ebp
        mov dword [byte eax+078h], ebp
        mov dword [byte eax+074h], ebp
        mov dword [byte eax+070h], ebp
        lea esi, [dword eax+01AE8h]
        mov ebp, 8
.18:
        cmp ebp, dword [byte esp+05Ch]
        je short .19
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, esi
        call POSimSeries
.19:
        xor edx, edx
        jmp short .21
.20:
        inc edx
.21:
        cmp edx, byte 7
        jge short .22
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [byte esi+eax*2+04h], 0FFh
        jne short POAfterGame.20
.22:
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Eh
        lea ebx, [byte eax+01h]
        sub edx, ebx
        jmp short .24
.23:
        lea ecx, [edx+ebx]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov byte [byte esi+eax*2+05h], 0FFh
        mov cl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], cl
        mov byte [byte esi+eax*2+03h], cl
        mov byte [byte esi+eax*2+02h], cl
        mov byte [byte esi+eax*2+01h], cl
        mov byte [esi+eax*2], cl
        inc ebx
.24:
        cmp ebx, byte 4
        jl short POAfterGame.23
        inc ebp
        add esi, byte 2Ah
        cmp ebp, byte 0Ch
        jl short POAfterGame.18
        mov eax, dword [esp]
        call POSeedConfFinals
        jmp near .39
.25:
        cmp edx, byte 0Eh
        jge near .33
        shr ebp, 1Dh
        mov eax, dword [esp]
        mov dword [dword eax+084h], ebp
        mov dword [dword eax+080h], ebp
        lea esi, [dword eax+01B90h]
        mov ebp, 0Ch
.26:
        cmp ebp, dword [byte esp+05Ch]
        je short .27
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, esi
        call POSimSeries
.27:
        xor edx, edx
        jmp short .29
.28:
        inc edx
.29:
        cmp edx, byte 7
        jge short .30
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [byte esi+eax*2+04h], 0FFh
        jne short POAfterGame.28
.30:
        mov ebx, dword [gameopts]
        shl ebx, 11h
        shr ebx, 1Eh
        inc ebx
        sub edx, ebx
        jmp short .32
.31:
        lea ecx, [edx+ebx]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov byte [byte esi+eax*2+05h], 0FFh
        mov cl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], cl
        mov byte [byte esi+eax*2+03h], cl
        mov byte [byte esi+eax*2+02h], cl
        mov byte [byte esi+eax*2+01h], cl
        mov byte [esi+eax*2], cl
        inc ebx
.32:
        cmp ebx, byte 4
        jl short POAfterGame.31
        inc ebp
        add esi, byte 2Ah
        cmp ebp, byte 0Eh
        jl short POAfterGame.26
        mov eax, dword [esp]
        call POSeedFinal
        jmp short .39
.33:
        shr ebp, 1Dh
        mov eax, dword [esp]
        mov dword [dword eax+088h], ebp
        lea esi, [dword eax+01BE4h]
        xor edx, edx
        jmp short .35
.34:
        inc edx
.35:
        cmp edx, byte 7
        jge short .36
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [byte esi+eax*2+04h], 0FFh
        jne short POAfterGame.34
.36:
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Eh
        lea ebx, [byte eax+01h]
        sub edx, ebx
        jmp short .38
.37:
        lea ecx, [edx+ebx]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov byte [byte esi+eax*2+05h], 0FFh
        mov cl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], cl
        mov byte [byte esi+eax*2+03h], cl
        mov byte [byte esi+eax*2+02h], cl
        mov byte [byte esi+eax*2+01h], cl
        mov byte [esi+eax*2], cl
        inc ebx
.38:
        cmp ebx, byte 4
        jl short POAfterGame.37
.39:
        mov esi, dword [esp]
        add esi, 1AE8h
        mov ebp, 10h
.40:
        xor edx, edx
        mov dl, byte [byte esi+02h]
        mov eax, ebp
        shl eax, 2
        mov dword [dword eax+playofftree], edx
        xor edx, edx
        mov dl, byte [byte esi+03h]
        mov dword [dword eax+playofftree_p1], edx
        cmp dword [dword eax+playofftree], 0FFh
        jne short .41
        mov dword [dword eax+playofftree], 1Ah
.41:
        mov eax, ebp
        shl eax, 2
        cmp dword [dword eax+playofftree_p1], 0FFh
        jne short .42
        mov dword [dword eax+playofftree_p1], 1Ah
.42:
        add ebp, byte 2
        add esi, byte 2Ah
        cmp ebp, byte 1Eh
        jl short POAfterGame.40
        mov esi, dword [esp]
        add esi, 1BE4h
        mov edx, dword [esp]
        mov edx, dword [dword edx+088h]
        mov eax, esi
        call SeriesWinner
        mov dword [pochampion], eax
        cmp eax, byte 0FFFFFFFFh
        jne short .43
        mov dword [pochampion], 1Ah
.43:
        mov eax, dword [byte esp+05Ch]
        cmp eax, byte 8
        jb short .44
        cmp eax, byte 9
        jbe near .50
        cmp eax, byte 0Ch
        jb near .51
        cmp eax, byte 0Dh
        jbe near .52
        cmp eax, byte 0Eh
        je near .53
        jmp near .54
.44:
        cmp eax, byte 3
        ja short .47
        xor eax, eax
        mov edx, dword [esp]
        mov al, byte [dword edx+01AEAh]
        cmp eax, edi
        je short .45
        xor eax, eax
        mov al, byte [dword edx+01AEBh]
        cmp eax, edi
        jne short .46
.45:
        mov dword [byte esp+05Ch], 8
        mov esi, dword [esp]
        add esi, 1AE8h
        jmp near .54
.46:
        mov dword [byte esp+05Ch], 9
        lea esi, [dword edx+01B12h]
        jmp near .54
.47:
        xor eax, eax
        mov edx, dword [esp]
        mov al, byte [dword edx+01B3Eh]
        cmp eax, edi
        je short .48
        xor eax, eax
        mov al, byte [dword edx+01B3Fh]
        cmp eax, edi
        jne short .49
.48:
        mov dword [byte esp+05Ch], 0Ah
        mov esi, dword [esp]
        add esi, 1B3Ch
        jmp short .54
.49:
        mov dword [byte esp+05Ch], 0Bh
        lea esi, [dword edx+01B66h]
        jmp short .54
.50:
        mov dword [byte esp+05Ch], 0Ch
        mov esi, dword [esp]
        add esi, 1B90h
        jmp short .54
.51:
        mov dword [byte esp+05Ch], 0Dh
        mov esi, dword [esp]
        add esi, 1BBAh
        jmp short .54
.52:
        mov dword [byte esp+05Ch], 0Eh
        mov esi, dword [esp]
        add esi, 1BE4h
        jmp short .54
.53:
        mov dword [byte esp+05Ch], 0Fh
        xor edx, edx
        mov dword [menuact_playnextgame], edx
        mov eax, dword [esp]
        mov dword [byte eax+040h], 69h
        call SaveScheduleDB
.54:
        mov edx, dword [byte esp+05Ch]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        mov edx, dword [esp]
        mov dword [byte edx+040h], eax
        mov eax, postate
        call WriteModeState
        jmp near .59
.55:
        xor ecx, ecx
        mov dword [byte esp+058h], ecx
        mov dword [byte esp+054h], ecx
        mov edx, dword [esp]
        mov edx, dword [byte edx+040h]
        add edx, 445h
        mov eax, dword [esp]
        inc dword [byte eax+040h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov esi, dword [esp]
        add esi, eax
        lea eax, [byte esp+04Ch]
        push eax
        lea ecx, [byte esp+054h]
        lea ebx, [byte esp+058h]
        lea edx, [byte esp+05Ch]
        mov eax, ebp
        call POSeriesScore
        mov eax, dword [byte esp+058h]
        mov ecx, dword [byte esp+054h]
        cmp eax, ecx
        jne short .56
        push ecx
        mov ebp, dword [byte esp+05Ch]
        push ebp
        push str_Tied
        mov eax, dword [poseriesfmt]
        push eax
        jmp short .58
.56:
        jle short .57
        push ecx
        push eax
        mov eax, dword [byte esp+058h]
        mov edx, dword [nosplit eax*4+teamabbrevs]
        push edx
        mov ebx, dword [poseriesfmt]
        push ebx
        jmp short .58
.57:
        push eax
        push ecx
        mov eax, dword [byte esp+054h]
        mov ebx, dword [nosplit eax*4+teamabbrevs]
        push ebx
        mov ecx, dword [poseriesfmt]
        push ecx
.58:
        push poseriesbuf
        call sprintf_
        add esp, byte 14h
        mov edx, poseriesbuf
        mov eax, poseriestext
        call strcpy_
.59:
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [byte esp+04h]
        call MakePath
        mov ebp, dword [seasondb_size]
        push ebp
        mov eax, dword [seasondb]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        call WriteFile
        add esp, byte 0Ch
        mov edx, dword [seasondb]
        test edx, edx
        je short .60
        push edx
        call FreeMemBlock
        add esp, byte 4
.60:
        mov ecx, dword [careerdb]
        test ecx, ecx
        je short .61
        push ecx
        call FreeMemBlock
        add esp, byte 4
.61:
        mov eax, dword [keydb]
        test eax, eax
        je short .62
        push eax
        call FreeMemBlock
        add esp, byte 4
.62:
        xor ebx, ebx
        mov dword [seasondb], ebx
        mov dword [careerdb], ebx
        mov dword [keydb], ebx
        mov dword [seasondb_size], ebx
        mov dword [careerdb_size], ebx
        mov dword [keydb_size], ebx
        cmp dword [byte esp+05Ch], byte 0Fh
        jge near .83
        test edi, edi
        jl near .76
        mov eax, dword [ctl1side]
        cmp eax, dword [ctl2side]
        jne short .64
.63:
        mov eax, 1
        jmp short .66
.64:
        cmp dword [ctl2team], byte 0
        setl al
        and eax, 0FFh
        mov ebx, dword [ctl1team]
        test ebx, ebx
        setl dl
        and edx, 0FFh
        xor eax, edx
        jne short POAfterGame.63
        test ebx, ebx
        jge short .65
        cmp dword [ctl2team], byte 0
        jl short .66
.65:
        mov eax, 2
.66:
        cmp eax, byte 1
        jne short .67
        cmp edi, dword [ctl1team]
        je near .70
        cmp edi, dword [ctl2team]
        je near .70
        mov eax, dword [esp]
        mov dword [byte eax+040h], 69h
        xor eax, eax
        mov dword [menuact_playnextgame], eax
        mov eax, dword [esp]
        call SaveScheduleDB
        mov eax, 1
        jmp near .84
.67:
        cmp eax, byte 2
        jne near .70
        mov edx, dword [byte esp+044h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        add eax, hmteamrec
        lea edx, [byte eax+05h]
        mov eax, msg_POTeamOut_arg
        call strcpy_
        cmp dword [byte esp+044h], byte 0
        sete al
        and eax, 0FFh
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, hmteamrec
        add edx, eax
        add edx, byte 5
        mov eax, msg_POTeamOut_arg2
        call strcpy_
        cmp edi, dword [ctl1team]
        je short .68
        cmp dword [ctl1side], byte 0
        sete al
        and eax, 0FFh
        sub eax, byte 2
        mov dword [ctl1team], eax
        jmp short .69
.68:
        cmp dword [ctl2side], byte 0
        sete al
        and eax, 0FFh
        sub eax, byte 2
        mov dword [ctl2team], eax
.69:
        mov dword [byte esp+048h], 2
.70:
        mov eax, dword [byte esp+05Ch]
        mov edx, dword [esp]
        mov dword [byte edx+044h], eax
        xor eax, eax
        mov al, byte [byte esi+02h]
        mov word [HomeTeam], ax
        xor eax, eax
        mov al, byte [byte esi+03h]
        mov word [VisTeam], ax
        mov ecx, dword [ctl1team]
        cmp edi, ecx
        jne short .72
        mov ebp, dword [ctl2team]
        cmp ecx, ebp
        jne short .72
        xor eax, eax
        mov al, byte [byte esi+02h]
        cmp eax, dword [ctl1team]
        jne short .71
        xor edi, ebp
        mov dword [ctl2side], edi
        xor ebp, ebp
        mov dword [ctl1side], ebp
        jmp near .83
.71:
        mov ecx, 1
        mov dword [ctl2side], ecx
        mov dword [ctl1side], ecx
        jmp near .83
.72:
        cmp edi, dword [ctl1team]
        jne short .74
        xor eax, eax
        mov al, byte [byte esi+02h]
        cmp eax, edi
        jne short .73
        xor ebp, ebp
        mov dword [ctl1side], ebp
        mov dword [ctl2team], 0FFFFFFFEh
        jmp near .82
.73:
        mov dword [ctl1side], 1
        mov dword [ctl2team], 0FFFFFFFFh
        xor edi, edi
        mov dword [ctl2side], edi
        jmp near .83
.74:
        mov edx, dword [ctl2team]
        cmp edi, edx
        jne near .83
        xor eax, eax
        mov al, byte [byte esi+02h]
        cmp eax, edx
        jne short .75
        xor ebp, ebp
        mov dword [ctl2side], ebp
        mov dword [ctl1team], 0FFFFFFFEh
        mov dword [ctl1side], 1
        jmp near .83
.75:
        mov dword [ctl2side], 1
        mov dword [ctl1team], 0FFFFFFFFh
        xor edi, edx
        mov dword [ctl1side], edi
        jmp near .83
.76:
        xor eax, eax
        mov al, byte [byte esi+02h]
        mov word [HomeTeam], ax
        xor eax, eax
        mov al, byte [byte esi+03h]
        mov word [VisTeam], ax
        mov esi, dword [ctl1team]
        cmp esi, byte 0FFFFFFFFh
        jne short .78
.77:
        mov dword [ctl1side], ebx
        jmp short .80
.78:
        cmp esi, byte 0FFFFFFFEh
        je short .79
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        cmp eax, esi
        je short POAfterGame.77
.79:
        mov dword [ctl1side], 1
.80:
        mov esi, dword [ctl2team]
        cmp esi, byte 0FFFFFFFFh
        jne short .81
        xor ecx, ecx
        mov dword [ctl2side], ecx
        jmp short .83
.81:
        cmp esi, byte 0FFFFFFFEh
        je short .82
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        cmp eax, esi
        jne short .82
        xor edx, edx
        mov dword [ctl2side], edx
        jmp short .83
.82:
        mov dword [ctl2side], 1
.83:
        mov eax, dword [byte esp+048h]
.84:
        add esp, byte 60h
        jmp near POSeedRound2_x
;-----------------------------------------------------------------------------
; LoadScheduleDB                                                  891B2  95 PC
; Loads 'schedule' through the league DB path format (leaguedbfmt, falling
; back to leaguedbfmt2); also used by the standings and scoreboard screens
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/LoadScheduleDB.c
%ifdef CBUILD
%include "c/front/playoff_mode/LoadScheduleDB.inc"
%else
LoadScheduleDB:
        push dword 60h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 40h
        mov esi, eax
        push str_Schedule
        push leaguedbfmt
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8B8
        add esp, byte 8
        mov dword [esi], eax
        test eax, eax
        jne short .1
        push str_Schedule
        push leaguedbfmt2
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8B8
        add esp, byte 8
        mov dword [esi], eax
.1:
        xor eax, eax
LoadScheduleDB_x:
        add esp, byte 40h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SaveScheduleDB                                                  89223  95 PC
; Writes the schedule buffer (minus its 2-byte header offset) back to
; <league>\schedule.db
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/LoadScheduleDB.c (SaveScheduleDB)
%ifdef CBUILD
%include "c/front/playoff_mode/LoadScheduleDB.SaveScheduleDB.inc"
%else
SaveScheduleDB:
        push dword 60h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 40h
        mov esi, eax
        xor ecx, ecx
        mov ebx, str_ScheduleDb
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        push eax
        sub esi, byte 2
        push esi
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        jmp short LoadScheduleDB_x
%endif ; C
;-----------------------------------------------------------------------------
; PlayoffModeLoop                                                 89268  95 PC
; Play-Off mode loop installed in menuact_nextpo by CreatePlayoffs (also
; entered from the file dialogs when loading): loads schedule.db, runs the
; game for the current series game, POAfterGame / POHandleElimination after
; it, then the playoff tree menu until the user leaves
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSeedRound2.c (PlayoffModeLoop)
%ifdef CBUILD
%include "c/front/playoff_mode/POSeedRound2.PlayoffModeLoop.inc"
%else
PlayoffModeLoop:
        push dword 58h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        mov ebp, eax
        xor edx, edx
        mov dword [byte esp+028h], edx
        mov dword [byte esp+024h], edx
        mov dword [byte esp+020h], edx
        mov eax, exhstate
        call SaveModeState
        mov eax, postate
        call LoadModeState
        mov eax, 2
        call SetupStatsSourceMenu
        mov eax, 1
        call SetScreenTitle
        cmp dword [byte ebp+00h], byte 0
        jge short .1
        xor ecx, ecx
        mov ebx, str_GameSav
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov edx, ebp
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .1
        mov dword [byte ebp+00h], 0FFFFFFFFh
.1:
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        cmp dword [byte ebp+00h], byte 0
        jl near .8
        call CheckGameDiskSpace
        test eax, eax
        jne near .8
        lea eax, [byte esp+020h]
        call LoadScheduleDB
        mov eax, dword [byte esp+020h]
        add eax, byte 2
        mov dword [byte esp+020h], eax
        mov eax, dword [byte eax+040h]
        add eax, 444h
        mov dword [schedgameidx], eax
        mov eax, dword [byte esp+020h]
        sub eax, byte 2
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor edx, edx
        mov dword [byte esp+020h], edx
        cmp byte [musicon], 0
        je short .2
        cmp dword [songdata], byte 0
        je short .2
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.2:
        push byte 20h
        push dword 300h
        push str_Palette
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
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
        je short PlayoffModeLoop.3
        mov esi, dword [songdata]
        push esi
        call sub_8D2F0
        add esp, byte 4
        xor edi, edi
        mov dword [songdata], edi
        mov dword [byte esp+024h], 1
.4:
        call ShowLoadingScreen
        call SetSideControls
        call SetupControllers
        mov dword [teamstatscb], GameTeamStatsScreen
        mov dword [skaterstatscb], GameSkaterStatsScreen
        mov dword [goaliestatscb], GameGoalieStatsScreen
        mov dword [standingscb], GameStandingsScreen
        mov dword [standingsmenucb], GameStandingsMenu
        mov eax, ebp
        call PlayGame
        mov dword [teamstatscb], EasnTeamStatsScreen
        mov dword [skaterstatscb], EasnSkaterStatsScreen
        mov dword [goaliestatscb], EasnGoalieStatsScreen
        mov dword [standingscb], EasnStandingsScreen
        mov dword [standingsmenucb], EasnStandingsMenu
        mov word [scrpitch], 50h
        cmp dword [byte esp+020h], byte 0
        jne short .5
        lea eax, [byte esp+020h]
        call LoadScheduleDB
        add dword [byte esp+020h], byte 2
.5:
        cmp dword [gameresult], byte 1
        jne short .7
        xor ecx, ecx
        mov ebx, str_GameSav
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov edx, ebp
        mov eax, esp
        call FileOpenRead
        test eax, eax
        jne short .6
        mov eax, esp
        call j_unlink_
        and byte [postate+5Ah], 7Fh
        and byte [gameopts+1], 7Fh
.6:
        mov eax, dword [byte esp+020h]
        call POAfterGame
        mov dword [byte esp+028h], eax
        mov eax, dword [byte esp+020h]
        call SaveScheduleDB
.7:
        push byte 20h
        push dword 300h
        push str_Palette
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        call InputInstall
.8:
        cmp dword [byte ebp+00h], byte 0
        jl short .9
        mov eax, ebp
        call FileClose
.9:
        cmp dword [byte esp+020h], byte 0
        jne short .10
        lea eax, [byte esp+020h]
        call LoadScheduleDB
        add dword [byte esp+020h], byte 2
.10:
        mov edi, dword [byte esp+020h]
        add edi, 1998h
        xor esi, esi
        mov ebx, 1Ah
.11:
        xor edx, edx
        mov dl, byte [byte edi+02h]
        mov eax, esi
        shl eax, 2
        mov dword [dword eax+playofftree], edx
        xor edx, edx
        mov dl, byte [byte edi+03h]
        mov dword [dword eax+playofftree_p1], edx
        cmp dword [dword eax+playofftree], 0FFh
        jne short .12
        mov dword [dword eax+playofftree], ebx
.12:
        mov eax, esi
        shl eax, 2
        cmp dword [dword eax+playofftree_p1], 0FFh
        jne short .13
        mov dword [dword eax+playofftree_p1], 1Ah
.13:
        add esi, byte 2
        add edi, byte 2Ah
        cmp esi, byte 1Eh
        jl short PlayoffModeLoop.11
        mov edi, dword [byte esp+020h]
        add edi, 1BE4h
        mov eax, dword [byte esp+020h]
        mov edx, dword [dword eax+088h]
        mov eax, edi
        call SeriesWinner
        mov dword [pochampion], eax
        cmp eax, byte 0FFFFFFFFh
        jne short .14
        mov dword [pochampion], 1Ah
.14:
        xor esi, esi
.15:
        mov edx, dword [nosplit esi*4+teamcitynames]
        mov edi, esi
        shl edi, 2
        add edi, esi
        shl edi, 2
        add edi, esi
        mov eax, treeteamnames
        add eax, edi
        call strcpy_
        inc esi
        cmp esi, byte 1Ah
        jl short PlayoffModeLoop.15
        mov edx, str_space4
        mov eax, treeteamnames+222h
        call strcpy_
        mov ecx, dword [embscupbank]
        test ecx, ecx
        jne short .18
        mov ebx, str_Embscup
        cmp byte [fileoncd+08Dh], 1
        jne short .16
        mov edx, dword [cddriveptr]
        jmp short .17
.16:
        xor edx, edx
.17:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [embscupbank], eax
.18:
        cmp dword [byte esp+024h], byte 0
        jne short .19
        cmp byte [musicon], 0
        je short .19
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.19:
        push byte 20h
        push dword 300h
        push str_Palette
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp dword [byte esp+024h], byte 0
        jne short .22
        cmp byte [musicon], 0
        je short .22
.20:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short PlayoffModeLoop.20
        mov eax, dword [songdata]
        test eax, eax
        je short .21
        push eax
        call sub_8D2F0
        add esp, byte 4
.21:
        xor ebx, ebx
        mov dword [songdata], ebx
.22:
        mov edx, dword [byte esp+020h]
        mov eax, dword [byte esp+028h]
        call POHandleElimination
        mov eax, dword [byte esp+020h]
        call SaveScheduleDB
        mov ebx, dword [byte esp+020h]
        mov ebx, dword [byte ebx+040h]
        lea edx, [dword ebx+0444h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edi, dword [byte esp+020h]
        add edi, eax
        mov ecx, 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov dword [seriesgameno], edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        cmp eax, byte 0Fh
        jge short .23
        mov dword [menuact_playnextgame], MenuPlayNextGame
        jmp short .24
.23:
        xor ecx, ecx
        mov dword [menuact_playnextgame], ecx
.24:
        xor eax, eax
        mov dword [dword_C6D26], eax
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 3
        mov eax, playoffmenubar
        call DrawMenuBar
        mov eax, dword [byte esp+020h]
        mov edx, dword [byte eax+044h]
        push edx
.25:
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 3
        mov eax, playoffmenubar
        call PlayoffTreeMenu
        test eax, eax
        jne near .38
        mov eax, dword [embscupbank]
        test eax, eax
        je short .26
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [embscupbank], ebx
.26:
        push byte 20h
        push dword 300h
        push str_Palette
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push byte 43h
        mov ecx, 40h
        mov ebx, 42h
        mov edx, ecx
        mov eax, 41h
        call SetDialogColors
        push byte 0
        call sub_910B0
        add esp, byte 4
        push esi
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        call CheckGameDiskSpace
        test eax, eax
        jne near .30
        mov ebx, 1
        mov edx, esi
        mov eax, ebx
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        call SetupControllers
        mov eax, postate
        call WriteModeState
        mov eax, dword [byte esp+020h]
        call SaveScheduleDB
        mov eax, dword [byte esp+020h]
        mov eax, dword [byte eax+040h]
        add eax, 444h
        mov dword [schedgameidx], eax
        call SetSideControls
        xor ecx, ecx
        mov ebx, str_GameSav
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov edx, ebp
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .27
        mov dword [byte ebp+00h], 0FFFFFFFFh
        xor edx, edx
        mov dl, byte [byte edi+01h]
        xor eax, eax
        mov al, byte [edi]
        call InitGameSummary
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        call PreGameScreen
        mov dword [byte esp+02Ch], eax
        call InputRemove
        jmp short .28
.27:
        mov dword [byte esp+02Ch], eax
        call ShowLoadingScreen
.28:
        mov eax, dword [byte esp+020h]
        sub eax, byte 2
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor edi, edi
        mov dword [byte esp+020h], edi
        test byte [byte esp+02Ch], 4
        jne short .29
        mov dword [teamstatscb], GameTeamStatsScreen
        mov dword [skaterstatscb], GameSkaterStatsScreen
        mov dword [goaliestatscb], GameGoalieStatsScreen
        mov dword [standingscb], GameStandingsScreen
        mov dword [standingsmenucb], GameStandingsMenu
        mov eax, ebp
        call PlayGame
        mov dword [teamstatscb], EasnTeamStatsScreen
        mov dword [skaterstatscb], EasnSkaterStatsScreen
        mov dword [goaliestatscb], EasnGoalieStatsScreen
        mov dword [standingscb], EasnStandingsScreen
        mov dword [standingsmenucb], EasnStandingsMenu
.29:
        mov word [scrpitch], 50h
        jmp short .31
.30:
        mov ebx, 1
        mov edx, esi
        mov eax, ebx
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov dword [byte esp+02Ch], 4
.31:
        cmp dword [byte esp+020h], byte 0
        jne short .32
        lea eax, [byte esp+020h]
        call LoadScheduleDB
        add dword [byte esp+020h], byte 2
.32:
        cmp dword [gameresult], byte 1
        jne short .33
        test byte [byte esp+02Ch], 4
        jne short .33
        mov eax, dword [byte esp+020h]
        call POAfterGame
        mov dword [byte esp+028h], eax
        mov eax, dword [byte esp+020h]
        call SaveScheduleDB
        jmp short .34
.33:
        xor edx, edx
        mov dword [byte esp+028h], edx
.34:
        mov eax, dword [byte esp+020h]
        mov edx, dword [byte eax+040h]
        add edx, 444h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edi, dword [byte esp+020h]
        add edi, eax
        cmp dword [embscupbank], byte 0
        jne short .37
        xor ecx, ecx
        mov ebx, str_Embscup
        cmp byte [fileoncd+08Dh], 1
        jne short .35
        mov edx, dword [cddriveptr]
        jmp short .36
.35:
        xor edx, edx
.36:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [embscupbank], eax
.37:
        push byte 20h
        push dword 300h
        push str_Palette
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [dword_C6D26], ecx
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 3
        mov eax, playoffmenubar
        call DrawMenuBar
        call InputInstall
        mov edx, dword [byte esp+020h]
        mov eax, dword [byte esp+028h]
        call POHandleElimination
        mov eax, dword [byte esp+020h]
        call SaveScheduleDB
        mov edx, dword [byte esp+020h]
        mov edx, dword [byte edx+040h]
        mov ebx, 7
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [seriesgameno], edx
        mov eax, dword [byte esp+020h]
        mov esi, dword [byte eax+044h]
        push esi
        jmp near PlayoffModeLoop.25
.38:
        mov eax, dword [byte esp+020h]
        sub eax, byte 2
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [embscupbank]
        test ebx, ebx
        je short .39
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [embscupbank], esi
.39:
        push byte 20h
        push dword 300h
        push str_Palette
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        call SetupStatsSourceMenu
        mov eax, postate
        call WriteModeState
        mov eax, exhstate
        call LoadModeState
        mov eax, 2
        jmp near POSeedRound2_x30
%endif ; C
;-----------------------------------------------------------------------------
; POReturnZero                                                    89B5C  95 PC
; Unreferenced stub that returns 0
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POReturnZero.c
%ifdef CBUILD
%include "c/front/playoff_mode/POReturnZero.inc"
%else
POReturnZero:
        push dword 4
        call __CHK
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; POHiliteSlot                                 89B69  95 PC, medium confidence
; Draws the highlight box around playoff tree slot eax (coordinates from
; poslotx / posloty, taller box for slots >= 1Ch)
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POCreateSchedule.c (POHiliteSlot)
%ifdef CBUILD
%include "c/front/playoff_mode/POCreateSchedule.POHiliteSlot.inc"
%else
POHiliteSlot:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, dword [nosplit eax*4+poslotx]
        mov dword [esp], edi
        mov esi, dword [nosplit eax*4+posloty]
        add edi, byte 74h
        cmp eax, byte 1Ch
        jge short .1
        lea ebp, [byte esi+01Fh]
        jmp short .2
.1:
        lea ebp, [byte esi+03Ch]
.2:
        push dword 80h
        push ebp
        push edi
        push esi
        mov edx, dword [byte esp+010h]
        push edx
        call sub_92F50
        add esp, byte 14h
        push dword 80h
        inc ebp
        push ebp
        inc edi
        push edi
        dec esi
        push esi
        mov eax, dword [byte esp+010h]
        dec eax
        push eax
        call sub_92F50
        add esp, byte 14h
        add esp, byte 4
        jmp near POCreateSchedule_x
%endif ; C
;-----------------------------------------------------------------------------
; PlayoffTreeMenu                              89BD2  95 PC, medium confidence
; Mouse/keyboard loop over the playoff tree screen with the 'Pointer' cursor
; and 'menubuff' menu (ClearInputQueue / MenuHitTest), highlighting slots
; with POHiliteSlot
;-----------------------------------------------------------------------------
PlayoffTreeMenu:
        push dword 0F4h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0C4h
        push eax
        push edx
        push ebx
        push ecx
        xor edx, edx
        mov dword [dword esp+0B8h], edx
        mov dword [byte esp+070h], eax
        mov eax, dword [byte esp+08h]
        mov dword [dword esp+080h], eax
        mov dword [byte esp+07Ch], edx
        mov dword [byte esp+078h], edx
        mov dword [byte esp+074h], edx
        mov dword [byte esp+06Ch], edx
        mov dword [byte esp+068h], edx
        mov dword [byte esp+064h], edx
        mov dword [byte esp+060h], edx
        mov dword [byte esp+05Ch], edx
        mov dword [byte esp+058h], edx
        mov dword [byte esp+054h], edx
        mov dword [byte esp+050h], edx
        mov dword [byte esp+014h], edx
        mov dword [byte esp+010h], edx
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        add edx, byte 4
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer
        call AllocMemBlock
        mov ebp, eax
        add esp, byte 0Ch
        mov dword [dword esp+0B0h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+04h]
        inc eax
        mov word [byte ebp+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte ebp+06h], ax
        mov edx, dword [byte esp+070h]
        mov edx, dword [edx]
        mov eax, dword [byte esp+070h]
        mov ebx, dword [byte eax+08h]
        add edx, ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+0B4h], eax
        mov dword [dword esp+0A8h], eax
        mov edx, dword [byte esp+070h]
        mov edx, dword [byte edx+04h]
        mov eax, dword [byte esp+070h]
        mov ecx, dword [byte eax+0Ch]
        add edx, ecx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+0D0h], eax
        mov dword [dword esp+0A4h], eax
        call sub_B4BA8
        mov esi, dword [dword esp+0D0h]
        push esi
        mov edi, dword [dword esp+0B8h]
        push edi
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        push esi
        push edi
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        push esi
        push edi
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call ClearInputQueue
        mov eax, dword [dword esp+0E8h]
        add eax, eax
        mov dword [dword esp+0C8h], eax
        cmp eax, byte 1Eh
        jne short .1
        mov edx, 0FFFFFFFFh
        jmp short .2
.1:
        lea edx, [byte eax+01h]
.2:
        mov dword [dword esp+0C4h], edx
        mov eax, dword [dword esp+0C8h]
        call POHiliteSlot
.3:
        xor ecx, ecx
.4:
        call GetInputEvent
        test eax, eax
        je short .5
        lea ebx, [dword esp+0A4h]
        lea edx, [dword esp+0A8h]
        call dword [ptrupdatefn]
        mov ecx, eax
        test al, 2
        je short PlayoffTreeMenu.4
.5:
        test cl, 2
        jne near .8
        mov eax, dword [dword esp+0A8h]
        cmp eax, dword [dword esp+0B4h]
        jne short .6
        mov eax, dword [dword esp+0A4h]
        cmp eax, dword [dword esp+0D0h]
        je short PlayoffTreeMenu.3
.6:
        mov ecx, dword [dword esp+0D0h]
        push ecx
        mov esi, dword [dword esp+0B8h]
        push esi
        mov edi, dword [dword esp+0B8h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov ebp, dword [dword esp+0A4h]
        push ebp
        mov eax, dword [dword esp+0ACh]
        push eax
        push edi
.7:
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+0A4h]
        push ebx
        mov ecx, dword [dword esp+0ACh]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [dword esp+0A8h]
        mov dword [dword esp+0B4h], eax
        mov eax, dword [dword esp+0A4h]
        mov dword [dword esp+0D0h], eax
        jmp near PlayoffTreeMenu.3
.8:
        mov edi, dword [dword esp+0D0h]
        push edi
        mov ebp, dword [dword esp+0B8h]
        push ebp
        mov eax, dword [dword esp+0B8h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        lea eax, [dword esp+09Ch]
        push eax
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [dword esp+08Ch]
        push eax
        mov ecx, dword [dword esp+0C8h]
        lea ebx, [dword esp+080h]
        mov edx, dword [dword esp+0B4h]
        mov eax, dword [dword esp+0B8h]
        call MenuHitTest
        test eax, eax
        je near .33
        mov edx, dword [dword esp+0A0h]
        shl edx, 2
        mov eax, dword [dword esp+09Ch]
        shl eax, 5
        mov ebx, dword [byte esp+edx+070h]
        add eax, ebx
        cmp dword [byte eax+014h], byte 0
        je near .23
        mov eax, dword [dword esp+09Ch]
        cmp eax, dword [byte esp+edx+050h]
        jne near .20
        mov edi, dword [dword esp+0D0h]
        push edi
        push ebp
        mov eax, dword [dword esp+0B8h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov esi, 3
        jmp short .11
.9:
        mov ebp, esi
        shl ebp, 2
        mov edi, dword [byte esp+ebp+060h]
        test edi, edi
        je short .10
        mov eax, dword [byte esp+esi*8+014h]
        push eax
        mov edx, dword [byte esp+esi*8+014h]
        push edx
        push edi
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+014h], ecx
        mov dword [byte esp+esi*8+010h], ecx
        mov edi, dword [byte esp+ebp+060h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.10:
        dec esi
.11:
        test esi, esi
        jge short PlayoffTreeMenu.9
        xor edi, edi
        mov dword [dword esp+0B8h], edi
        mov edx, dword [dword esp+0C4h]
        mov eax, dword [dword esp+0C8h]
        call POHiliteSlot
        mov eax, dword [potreeround-2]
        sar eax, 10h
        mov dword [dword esp+0CCh], eax
        mov ebp, dword [dword esp+0B0h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov byte [dword esp+090h], 18h
        xor dl, dl
        mov byte [dword esp+091h], dl
        xor dh, dh
        mov byte [dword esp+092h], dh
        mov byte [dword esp+093h], 2Ah
        xor bh, bh
        mov byte [dword esp+094h], bh
        xor cl, cl
        mov byte [dword esp+095h], cl
        mov ch, 3Bh
        mov byte [dword esp+096h], ch
        mov byte [dword esp+097h], 12h
        xor ah, ah
        mov byte [dword esp+098h], ah
        mov byte [dword esp+099h], ch
        mov byte [dword esp+09Ah], ch
        mov byte [dword esp+09Bh], ch
        lea eax, [dword esp+090h]
        push eax
        push byte 4
        push dword 0FBh
        call VgaSetPalette
        add esp, byte 0Ch
        mov eax, dword [dword esp+0A0h]
        mov edx, dword [dword esp+09Ch]
        shl edx, 5
        mov eax, dword [byte esp+eax*4+070h]
        call dword [byte edx+eax+014h]
        mov ebp, eax
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        add edx, byte 4
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0B0h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        inc word [byte eax+04h]
        inc word [byte eax+06h]
        xor edx, edx
        mov dword [byte esp+07Ch], edx
        mov dword [byte esp+078h], edx
        mov dword [byte esp+074h], edx
        mov dword [byte esp+068h], edx
        mov dword [byte esp+064h], edx
        mov dword [byte esp+060h], edx
        mov dword [byte esp+05Ch], edx
        mov dword [byte esp+058h], edx
        mov dword [byte esp+054h], edx
        mov dword [dword esp+08Ch], edx
        mov dword [dword esp+088h], edx
        mov dword [dword esp+084h], edx
        cmp ebp, byte 1
        jne short .12
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov eax, ebp
        jmp near .x
.12:
        cmp ebp, byte 4
        jne short .13
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        jmp near .x
.13:
        cmp ebp, byte 2
        jne near .18
        mov ecx, dword [embscupbank]
        test ecx, ecx
        jne short .15
        mov ebx, str_Embscup
        cmp byte [fileoncd+08Dh], 1
        jne short .14
        mov edx, dword [cddriveptr]
.14:
        lea eax, [byte esp+030h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+034h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [embscupbank], eax
.15:
        xor ecx, ecx
        mov ebx, str_Embpal
        cmp byte [fileoncd+08Eh], 1
        jne short .16
        mov edx, dword [cddriveptr]
        jmp short .17
.16:
        xor edx, edx
.17:
        lea eax, [byte esp+030h]
        call MakePath
        push byte 0
        lea eax, [byte esp+034h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_BangPal
        push eax
        call FindShape
        add esp, byte 8
        lea edi, [byte eax+010h]
        call sub_B4BA8
        xor ebp, ebp
        mov dword [dword_C6D26], ebp
        call DrawPlayoffTree
        mov eax, dword [dword esp+0E4h]
        push eax
        mov ecx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov edx, dword [byte esp+0Ch]
        mov eax, dword [byte esp+010h]
        call DrawMenuBar
        mov ebx, 10h
        mov edx, edi
        xor eax, eax
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
.18:
        call sub_B4BA8
        mov eax, dword [potreeround-2]
        sar eax, 10h
        cmp eax, dword [dword esp+0CCh]
        je short .19
        mov eax, dword [dword esp+0CCh]
        mov word [potreeround], ax
        call DrawPlayoffTree
.19:
        mov edx, dword [dword esp+0C4h]
        mov eax, dword [dword esp+0C8h]
        call POHiliteSlot
        mov ebx, dword [dword esp+0D0h]
        push ebx
        mov ecx, dword [dword esp+0B8h]
        push ecx
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [dword esp+0B4h]
        mov dword [dword esp+0A8h], eax
        mov eax, dword [dword esp+0D0h]
        mov dword [dword esp+0A4h], eax
        call ClearInputQueue
        jmp near .37
.20:
        mov edi, dword [dword esp+0D0h]
        push edi
        push ebp
        mov eax, dword [dword esp+0B8h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+0E4h]
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        mov eax, dword [dword esp+0A8h]
        mov ebx, dword [byte esp+eax*8+01Ch]
        mov edx, dword [byte esp+eax*8+018h]
        mov ecx, dword [byte esp+eax*4+058h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+078h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov edx, dword [dword esp+0A0h]
        mov eax, dword [dword esp+09Ch]
        mov dword [byte esp+edx*4+050h], eax
        mov ecx, dword [dword esp+0E4h]
        push ecx
        mov esi, dword [byte esp+04h]
        push esi
        mov ebx, dword [byte esp+edx*8+01Ch]
        mov eax, dword [byte esp+edx*8+018h]
        mov esi, dword [byte esp+edx*4+058h]
        shl esi, 5
        mov edx, dword [byte esp+edx*4+078h]
        add esi, edx
.21:
        mov ecx, dword [byte esp+0Ch]
        mov edx, eax
        mov eax, esi
.22:
        call DrawMenuItemNorm
        jmp near .37
.23:
        cmp dword [byte eax+018h], byte 0
        je near .32
        mov eax, dword [dword esp+0D0h]
        push eax
        mov edx, dword [dword esp+0B8h]
        push edx
        mov ebx, dword [dword esp+0B8h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0B8h]
        cmp eax, dword [dword esp+0A0h]
        je short .27
        mov esi, eax
        jmp short .26
.24:
        mov edi, esi
        shl edi, 2
        xor ebp, ebp
        mov dword [byte esp+edi+050h], ebp
        mov eax, dword [byte esp+edi+060h]
        test eax, eax
        je short .25
        mov ebp, esi
        mov edx, dword [byte esp+esi*8+014h]
        push edx
        mov ebx, dword [byte esp+esi*8+014h]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [byte esp+esi*8+014h], eax
        mov dword [byte esp+esi*8+010h], eax
        mov edx, dword [byte esp+edi+060h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [byte esp+edi+060h], ebx
        mov dword [byte esp+edi+070h], ebx
        xor ebp, esi
        mov dword [dword esp+edi+080h], ebp
.25:
        dec esi
.26:
        mov ecx, dword [dword esp+0A0h]
        cmp esi, ecx
        jg short PlayoffTreeMenu.24
        mov dword [dword esp+0B8h], ecx
.27:
        mov eax, dword [dword esp+0E4h]
        push eax
        mov edx, dword [byte esp+04h]
        push edx
        mov esi, dword [dword esp+0C0h]
        mov ebx, dword [byte esp+esi*8+01Ch]
        mov edx, dword [byte esp+esi*8+018h]
        mov ecx, dword [byte esp+esi*4+058h]
        shl ecx, 5
        mov eax, dword [byte esp+esi*4+078h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov eax, dword [dword esp+09Ch]
        mov dword [byte esp+esi*4+050h], eax
        mov ebx, dword [dword esp+0E4h]
        push ebx
        mov ecx, dword [byte esp+04h]
        push ecx
        mov ebx, dword [byte esp+esi*8+01Ch]
        mov edx, dword [byte esp+esi*8+018h]
        mov ecx, eax
        shl ecx, 5
        mov eax, dword [byte esp+esi*4+078h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemNorm
        mov eax, dword [dword esp+0A0h]
        mov ecx, dword [dword esp+09Ch]
        shl ecx, 5
        mov ebx, dword [byte esp+eax*4+070h]
        inc esi
        mov dword [dword esp+0B8h], esi
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [byte esp+esi*4+070h], ebx
        mov eax, dword [byte esp+eax*4+070h]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [dword esp+esi*4+080h], ebx
        cmp esi, byte 1
        je short .28
        mov edx, dword [byte eax+08h]
        jmp short .29
.28:
        mov edx, dword [eax]
.29:
        mov eax, dword [dword esp+0B8h]
        mov ebp, dword [byte esp+eax*8+08h]
        add edx, ebp
        mov dword [byte esp+eax*8+010h], edx
        mov edx, dword [dword esp+09Ch]
        shl edx, 5
        mov eax, dword [dword esp+0A0h]
        shl eax, 2
        cmp dword [dword esp+0B8h], byte 1
        je short .30
        mov eax, dword [byte esp+eax+070h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .31
.30:
        mov eax, dword [byte esp+eax+070h]
        mov eax, dword [byte edx+eax+0Ch]
.31:
        mov edx, dword [dword esp+0B8h]
        shl edx, 3
        mov dword [dword esp+0ACh], edx
        mov ecx, dword [byte esp+edx+0Ch]
        add eax, ecx
        mov dword [byte esp+edx+014h], eax
        mov ebp, dword [dword esp+0B8h]
        mov edx, dword [dword esp+ebp*4+080h]
        shl edx, 5
        mov eax, dword [byte esp+ebp*4+070h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [dword esp+0C0h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [dword esp+0BCh], edx
        push byte 20h
        mov eax, ebx
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+ebp*4+060h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte esp+ebp*4+060h]
        mov edx, dword [dword esp+0C0h]
        mov word [byte eax+04h], dx
        mov eax, dword [byte esp+ebp*4+060h]
        mov edx, dword [dword esp+0BCh]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+0ACh]
        mov ebx, dword [byte esp+eax+014h]
        push ebx
        mov ecx, dword [byte esp+eax+014h]
        push ecx
        mov esi, dword [byte esp+ebp*4+068h]
        push esi
        call GrabBlock
        add esp, byte 0Ch
        mov edi, dword [dword esp+0E4h]
        push edi
        mov eax, dword [byte esp+04h]
        push eax
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ecx, dword [dword esp+0B8h]
        mov ecx, dword [byte esp+ecx+020h]
        mov ebx, dword [dword esp+0B8h]
        mov ebx, dword [byte esp+ebx+01Ch]
        mov edx, dword [dword esp+ebp*4+08Ch]
        mov eax, dword [byte esp+ebp*4+07Ch]
        call DrawMenuDropdown
        xor ebx, ebx
        mov dword [byte esp+ebp*4+050h], ebx
        push edi
        mov esi, dword [byte esp+04h]
        push esi
        mov ebx, dword [dword esp+0B4h]
        mov ebx, dword [byte esp+ebx+01Ch]
        mov edx, dword [dword esp+0B4h]
        mov edx, dword [byte esp+edx+018h]
        mov eax, dword [byte esp+ebp*4+078h]
        mov ecx, dword [byte esp+0Ch]
        jmp near PlayoffTreeMenu.22
.32:
        mov eax, dword [dword esp+0D0h]
        push eax
        mov edx, dword [dword esp+0B8h]
        push edx
        mov ebx, dword [dword esp+0B8h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [dword esp+0E4h]
        push ecx
        mov esi, dword [byte esp+04h]
        push esi
        mov eax, dword [dword esp+0A8h]
        mov ebx, dword [byte esp+eax*8+01Ch]
        mov edx, dword [byte esp+eax*8+018h]
        mov ecx, dword [byte esp+eax*4+058h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+078h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov edx, dword [dword esp+0A0h]
        mov eax, dword [dword esp+09Ch]
        mov dword [byte esp+edx*4+050h], eax
        mov edi, dword [dword esp+0E4h]
        push edi
        push esi
        mov ebx, dword [byte esp+edx*8+01Ch]
        mov eax, dword [byte esp+edx*8+018h]
        mov ecx, dword [byte esp+edx*4+058h]
        shl ecx, 5
        mov esi, dword [byte esp+edx*4+078h]
        add esi, ecx
        jmp near PlayoffTreeMenu.21
.33:
        push edi
        push ebp
        mov ecx, dword [dword esp+0B8h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+0B8h]
        test esi, esi
        je short .37
        jmp short .36
.34:
        mov edi, esi
        shl edi, 2
        mov ebp, dword [byte esp+edi+060h]
        test ebp, ebp
        je short .35
        mov eax, dword [byte esp+esi*8+014h]
        push eax
        mov edx, dword [byte esp+esi*8+014h]
        push edx
        push ebp
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+014h], ecx
        mov dword [byte esp+esi*8+010h], ecx
        mov ebp, dword [byte esp+edi+060h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [byte esp+edi+060h], eax
        mov dword [byte esp+edi+070h], eax
        mov dword [dword esp+edi+080h], eax
.35:
        dec esi
.36:
        test esi, esi
        jge short PlayoffTreeMenu.34
        xor edi, edi
        mov dword [dword esp+0B8h], edi
.37:
        call sub_B4BA8
        mov ebp, dword [dword esp+0A4h]
        push ebp
        mov eax, dword [dword esp+0ACh]
        push eax
        mov edx, dword [dword esp+0B8h]
        push edx
        jmp near PlayoffTreeMenu.7
.x:
        add esp, 0D4h
        pop ebp
        pop edi
        pop esi
        ret 8
;-----------------------------------------------------------------------------
; DrawPlayoffTree                                                 8A652  95 PC
; Draws the playoff tree screen: 'Playoffs have not been seeded yet' when
; playofftree is empty, otherwise 'Western Conference' / 'Eastern Conference'
; brackets with series scores, pstatbar / rst1 / rst2 / scuparrw / aup / adn
; art
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/POSeedRound2.c (DrawPlayoffTree)
%ifdef CBUILD
%include "c/front/playoff_mode/POSeedRound2.DrawPlayoffTree.inc"
%else
DrawPlayoffTree:
        push dword 120h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 0F4h
        xor edx, edx
        mov dword [dword esp+0E8h], edx
        mov ebp, dword [mainfont]
        mov esi, dword [kaufmfont]
        push dword 1E0h
        push byte 13h
        push dword 280h
        push edx
        call SetClipWindow
        add esp, byte 10h
        push str_Bkgd2
        mov ebx, dword [embscupbank]
        push ebx
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        cmp dword [dword_C6D26], byte 1
        jne short .3
        xor ecx, ecx
        mov ebx, str_Embpal
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0D8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0DCh]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        push str_BangPal
        push eax
        call FindShape
        add esp, byte 8
        add eax, byte 10h
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor edi, edi
        mov dword [dword_C6D26], edi
.3:
        mov ebx, 1
        mov edx, esp
        mov eax, playofftree
        call CountSeriesWins
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        xor eax, eax
        mov al, byte [treecolslots]
        cmp dword [nosplit eax*4+playofftree], byte 19h
        jle short .4
        push esi
        call TextSetFont
        add esp, byte 4
        mov ecx, 8
        lea edi, [dword esp+0B8h]
        mov esi, str_PlayoffsHaveNotBeen
        rep movsd
        movsw
        lea eax, [dword esp+0B8h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        lea ebx, [dword esp+0B8h]
        mov edx, 0F0h
        call PrintOutlinedText
        push ebp
        call TextSetFont
        jmp near .76
.4:
        xor ecx, ecx
        mov ebx, str_Pstatbar2
        cmp byte [fileoncd+013Ch], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp short .6
.5:
        xor edx, edx
.6:
        lea eax, [dword esp+0D8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0DCh]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        push str_Rst1
        push eax
        call FindShape
        add esp, byte 8
        push byte 1Ah
        push byte 0
        push eax
        call DrawArt
        add esp, byte 0Ch
        push str_Rst2
        push edi
        call FindShape
        add esp, byte 8
        push dword 192h
        push byte 0Fh
        push eax
        call DrawArt
        add esp, byte 0Ch
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Scuparrw
        cmp byte [fileoncd+016Eh], 1
        jne short .7
        mov edx, dword [cddriveptr]
        jmp short .8
.7:
        xor edx, edx
.8:
        lea eax, [dword esp+0D8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0DCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [dword esp+0ECh], eax
        call TextGridOpen
        lea eax, [byte esp+078h]
        push eax
        call TextSaveState
        add esp, byte 4
        push ebp
        call TextSetFont
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov edx, str_POTitle
        lea eax, [dword esp+0B8h]
        call strcpy_
        lea edx, [dword esp+0B8h]
        mov eax, 16h
        call PrintCenteredText
        push esi
        call TextSetFont
        add esp, byte 4
        lea edi, [dword esp+0B8h]
        mov esi, str_WesternConference
        movsd
        movsd
        movsd
        movsd
        movsw
        movsb
        lea eax, [dword esp+0B8h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        lea ebx, [dword esp+0B8h]
        mov edx, 2Fh
        call PrintOutlinedText
        lea edi, [dword esp+0B8h]
        mov esi, str_EasternConference
        movsd
        movsd
        movsd
        movsd
        movsw
        movsb
        lea eax, [dword esp+0B8h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        lea ebx, [dword esp+0B8h]
        mov edx, 1A7h
        call PrintOutlinedText
        push ebp
        call TextSetFont
        add esp, byte 4
        xor ecx, ecx
        jmp near .14
.9:
        cmp cx, byte 4
        jge short .10
        movsx eax, cx
        movzx si, byte [nosplit eax*2+treecolslots]
        jmp short .11
.10:
        movsx eax, cx
        add eax, eax
        sub eax, byte 8
        mov edx, 7
        sub edx, eax
        movzx si, byte [dword edx+treecolslots]
.11:
        movsx edx, cx
        movsx eax, si
        mov eax, dword [nosplit eax*4+playofftree]
        mov dword [nosplit eax*4+potreeseeds], edx
        lea eax, [edx+edx]
        cmp cx, byte 4
        jge short .12
        movzx si, byte [dword eax+treecol_Er1]
        jmp short .13
.12:
        sub eax, byte 8
        mov edx, 7
        sub edx, eax
        movzx si, byte [dword edx+treecol_Er1]
.13:
        movsx edx, cx
        movsx eax, si
        mov eax, dword [nosplit eax*4+playofftree]
        mov dword [nosplit eax*4+potreeseeds], edx
        inc ecx
.14:
        cmp cx, byte 8
        jl short DrawPlayoffTree.9
        mov word [dword esp+0F0h], 48h
        xor ecx, ecx
        jmp near .22
.15:
        cmp cx, byte 4
        jge short .16
        mov ebx, ecx
        movsx eax, cx
        movzx si, byte [nosplit eax*2+treecolslots]
        jmp short .17
.16:
        mov ebx, 7
        sub ebx, ecx
        movsx eax, cx
        add eax, eax
        sub eax, byte 8
        mov edx, 7
        sub edx, eax
        movzx si, byte [dword edx+treecolslots]
.17:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        movsx edi, si
        shl edi, 2
        mov eax, dword [dword edi+playofftree]
        mov eax, dword [nosplit eax*4+potreeseeds]
        add eax, 91h
        push eax
        push str_fmtcsp
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov ebp, dword [dword edi+playofftree]
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        add eax, ebp
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        movsx ebp, bx
        mov eax, dword [nosplit ebp*4+treecolx]
        lea ebx, [dword esp+0B8h]
        call PrintShadowText
        mov bx, word [nosplit ebp*4+treecolx]
        add ebx, byte 6Ah
        xor eax, eax
        mov al, byte [treecol_Wr2]
        mov eax, dword [nosplit eax*4+playofftree]
        mov edx, dword [dword edi+playofftree]
        cmp eax, edx
        je short .18
        xor eax, eax
        mov al, byte [treecol_Wr2+1]
        cmp edx, dword [nosplit eax*4+playofftree]
        je short .18
        xor eax, eax
        mov al, byte [treecol_Wr2+2]
        cmp edx, dword [nosplit eax*4+playofftree]
        je short .18
        xor eax, eax
        mov al, byte [treecol_Wr2+3]
        cmp edx, dword [nosplit eax*4+playofftree]
        jne short .19
.18:
        mov edx, 43h
        mov eax, 44h
        jmp short .20
.19:
        mov edx, 43h
        mov eax, 40h
.20:
        call SetTextColors
        movsx eax, si
        mov edx, dword [esp+eax*4]
        push edx
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        movsx eax, bx
        lea ebx, [dword esp+0B8h]
        call PrintShadowText
        cmp cx, byte 3
        jne short .21
        add word [dword esp+0F0h], byte 10h
.21:
        inc ecx
.22:
        cmp cx, byte 8
        jl near DrawPlayoffTree.15
        xor eax, eax
        mov al, byte [treecol_Wr2]
        add word [dword esp+0F0h], byte 3Fh
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .37
        xor eax, eax
        mov al, byte [treecol_Wr2+1]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .37
        xor eax, eax
        mov al, byte [treecol_Wr2+2]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .37
        xor eax, eax
        mov al, byte [treecol_Wr2+3]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .37
        push str_Aup1
        mov ebp, dword [dword esp+0F0h]
        push ebp
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        xor ecx, ecx
        jmp near .30
.23:
        cmp cx, byte 2
        jge short .24
        mov ebx, ecx
        add ebx, byte 4
        movsx eax, cx
        movzx si, byte [nosplit eax*2+treecol_Wr2]
        jmp short .25
.24:
        mov ebx, 7
        sub ebx, ecx
        movsx eax, cx
        add eax, eax
        sub eax, byte 4
        mov edx, 3
        sub edx, eax
        movzx si, byte [dword edx+treecol_Wr2]
.25:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        movsx edi, si
        shl edi, 2
        mov eax, dword [dword edi+playofftree]
        mov eax, dword [nosplit eax*4+potreeseeds]
        add eax, 91h
        push eax
        push str_fmtcsp
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov ebp, dword [dword edi+playofftree]
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        add eax, ebp
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        movsx ebp, bx
        mov eax, dword [nosplit ebp*4+treecolx]
        lea ebx, [dword esp+0B8h]
        call PrintShadowText
        mov bx, word [nosplit ebp*4+treecolx]
        add ebx, byte 6Ah
        xor eax, eax
        mov al, byte [treecolslots+10h]
        mov eax, dword [nosplit eax*4+playofftree]
        mov ebp, dword [dword edi+playofftree]
        cmp eax, ebp
        je short .26
        xor eax, eax
        mov al, byte [treecolslots+11h]
        cmp ebp, dword [nosplit eax*4+playofftree]
        jne short .27
.26:
        mov edx, 43h
        mov eax, 44h
        jmp short .28
.27:
        mov edx, 43h
        mov eax, 40h
.28:
        call SetTextColors
        movsx eax, si
        mov esi, dword [esp+eax*4]
        push esi
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        movsx eax, bx
        lea ebx, [dword esp+0B8h]
        call PrintShadowText
        cmp cx, byte 1
        jne short .29
        add word [dword esp+0F0h], byte 10h
.29:
        inc ecx
.30:
        cmp cx, byte 4
        jl near DrawPlayoffTree.23
        xor eax, eax
        mov al, byte [treecolslots+10h]
        add word [dword esp+0F0h], byte 3Dh
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .38
        xor eax, eax
        mov al, byte [treecolslots+11h]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .38
        push str_Aup2
        mov esi, dword [dword esp+0F0h]
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        movzx si, byte [treecolslots+10h]
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        movsx edi, si
        shl edi, 2
        mov eax, dword [dword edi+playofftree]
        mov eax, dword [nosplit eax*4+potreeseeds]
        add eax, 91h
        push eax
        push str_fmtcsp
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword edi+playofftree]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        dec edx
        lea ebx, [dword esp+0B8h]
        mov eax, 48h
        call PrintShadowText
        xor eax, eax
        mov al, byte [treecolslots+18h]
        mov eax, dword [nosplit eax*4+playofftree]
        mov ebp, dword [dword edi+playofftree]
        cmp eax, ebp
        je short .31
        xor eax, eax
        mov al, byte [treecolslots+28h]
        cmp ebp, dword [nosplit eax*4+playofftree]
        jne short .32
.31:
        mov edx, 43h
        mov eax, 44h
        jmp short .33
.32:
        mov edx, 43h
        mov eax, 40h
.33:
        call SetTextColors
        movsx eax, si
        mov ebx, dword [esp+eax*4]
        push ebx
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        dec edx
        lea ebx, [dword esp+0B8h]
        mov eax, 0B2h
        call PrintShadowText
        movzx si, byte [treecolslots+11h]
        add word [dword esp+0F0h], byte 10h
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        movsx edi, si
        shl edi, 2
        mov eax, dword [dword edi+playofftree]
        mov eax, dword [nosplit eax*4+potreeseeds]
        add eax, 91h
        push eax
        push str_fmtcsp
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword edi+playofftree]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        dec edx
        lea ebx, [dword esp+0B8h]
        mov eax, 48h
        call PrintShadowText
        xor eax, eax
        mov al, byte [treecolslots+18h]
        mov eax, dword [nosplit eax*4+playofftree]
        mov ecx, dword [dword edi+playofftree]
        cmp eax, ecx
        je short .34
        xor eax, eax
        mov al, byte [treecolslots+28h]
        cmp ecx, dword [nosplit eax*4+playofftree]
        jne short .35
.34:
        mov edx, 43h
        mov eax, 44h
        jmp short .36
.35:
        mov edx, 43h
        mov eax, 40h
.36:
        call SetTextColors
        movsx eax, si
        mov edx, dword [esp+eax*4]
        push edx
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        dec edx
        lea ebx, [dword esp+0B8h]
        mov eax, 0B2h
        call PrintShadowText
        sub word [dword esp+0F0h], byte 10h
        jmp short .38
.37:
        add word [dword esp+0F0h], byte 4Dh
.38:
        xor eax, eax
        mov al, byte [treecolslots+18h]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .42
        push str_Aup3
        mov ebp, dword [dword esp+0F0h]
        push ebp
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        mov dword [dword esp+0E8h], 1
        push str_Midl
        push ebp
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        lea edi, [dword esp+0B8h]
        mov esi, str_space5
        movsw
        movsb
        movzx si, byte [treecolslots+18h]
        xor edx, edx
        mov dl, byte [treecolslots+18h]
        mov edx, dword [nosplit edx*4+playofftree]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        sub edx, byte 4
        lea ebx, [dword esp+0B8h]
        mov eax, 102h
        call PrintShadowText
        movsx edx, si
        shl edx, 2
        mov ebx, dword [esp+edx]
        push ebx
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [treecolslots+20h]
        mov eax, dword [nosplit eax*4+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .40
        cmp dword [dword edx+teamconf], byte 3
        jne short .39
        mov edx, 43h
        mov eax, 44h
        jmp short .41
.39:
        mov edx, 43h
        mov eax, 0C4h
        jmp short .41
.40:
        mov edx, 43h
        mov eax, 40h
.41:
        call SetTextColors
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        sub edx, byte 4
        lea ebx, [dword esp+0B8h]
        mov eax, 16Ch
        call PrintShadowText
.42:
        xor eax, eax
        mov al, byte [treecolslots+28h]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .47
        push str_Adn3
        mov ebp, dword [dword esp+0F0h]
        push ebp
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        cmp dword [dword esp+0E8h], byte 0
        jne short .43
        push str_Midl
        push ebp
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
.43:
        add word [dword esp+0F0h], byte 10h
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        lea edi, [dword esp+0B8h]
        mov esi, str_space5
        movsw
        movsb
        movzx si, byte [treecolslots+28h]
        xor edx, edx
        mov dl, byte [treecolslots+28h]
        mov edx, dword [nosplit edx*4+playofftree]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        sub edx, byte 4
        lea ebx, [dword esp+0B8h]
        mov eax, 102h
        call PrintShadowText
        movsx edx, si
        shl edx, 2
        mov ebx, dword [esp+edx]
        push ebx
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [treecolslots+20h]
        mov eax, dword [nosplit eax*4+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .45
        cmp dword [dword edx+teamconf], byte 3
        jne short .44
        mov edx, 43h
        mov eax, 44h
        jmp short .46
.44:
        mov edx, 43h
        mov eax, 0C4h
        jmp short .46
.45:
        mov edx, 43h
        mov eax, 40h
.46:
        call SetTextColors
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        sub edx, byte 4
        lea ebx, [dword esp+0B8h]
        mov eax, 16Ch
        call PrintShadowText
        sub word [dword esp+0F0h], byte 10h
.47:
        xor eax, eax
        mov al, byte [treecolslots+30h]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .54
        xor eax, eax
        mov al, byte [treecolslots+31h]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .54
        movzx si, byte [treecolslots+30h]
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        movsx edi, si
        shl edi, 2
        mov eax, dword [dword edi+playofftree]
        mov eax, dword [nosplit eax*4+potreeseeds]
        add eax, 91h
        push eax
        push str_fmtcsp
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword edi+playofftree]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        dec edx
        lea ebx, [dword esp+0B8h]
        mov eax, 1C6h
        call PrintShadowText
        xor eax, eax
        mov al, byte [treecolslots+18h]
        mov eax, dword [nosplit eax*4+playofftree]
        mov edx, dword [dword edi+playofftree]
        cmp eax, edx
        je short .48
        xor eax, eax
        mov al, byte [treecolslots+28h]
        cmp edx, dword [nosplit eax*4+playofftree]
        jne short .49
.48:
        mov edx, 43h
        mov eax, 0C4h
        jmp short .50
.49:
        mov edx, 43h
        mov eax, 40h
.50:
        call SetTextColors
        movsx eax, si
        mov ecx, dword [esp+eax*4]
        push ecx
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        dec edx
        lea ebx, [dword esp+0B8h]
        mov eax, 230h
        call PrintShadowText
        movzx si, byte [treecolslots+31h]
        add word [dword esp+0F0h], byte 10h
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        movsx edi, si
        shl edi, 2
        mov eax, dword [dword edi+playofftree]
        mov eax, dword [nosplit eax*4+potreeseeds]
        add eax, 91h
        push eax
        push str_fmtcsp
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword edi+playofftree]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        dec edx
        lea ebx, [dword esp+0B8h]
        mov eax, 1C6h
        call PrintShadowText
        xor eax, eax
        mov al, byte [treecolslots+18h]
        mov eax, dword [nosplit eax*4+playofftree]
        mov ebp, dword [dword edi+playofftree]
        cmp eax, ebp
        je short .51
        xor eax, eax
        mov al, byte [treecolslots+28h]
        cmp ebp, dword [nosplit eax*4+playofftree]
        jne short .52
.51:
        mov edx, 43h
        mov eax, 0C4h
        jmp short .53
.52:
        mov edx, 43h
        mov eax, 40h
.53:
        call SetTextColors
        movsx eax, si
        mov ebx, dword [esp+eax*4]
        push ebx
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        dec edx
        lea ebx, [dword esp+0B8h]
        mov eax, 230h
        call PrintShadowText
        push str_Adn2
        mov ecx, dword [dword esp+0F0h]
        push ecx
        add word [dword esp+0F8h], byte 3Dh
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        jmp short .55
.54:
        add word [dword esp+0F0h], byte 4Dh
.55:
        xor eax, eax
        mov al, byte [treecol_Er2]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .66
        xor eax, eax
        mov al, byte [treecol_Er2+1]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .66
        xor eax, eax
        mov al, byte [treecol_Er2+2]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .66
        xor eax, eax
        mov al, byte [treecol_Er2+3]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        jge near .66
        xor ecx, ecx
        jmp near .65
.56:
        cmp cx, byte 2
        jge short .57
        mov ebx, ecx
        jmp short .58
.57:
        mov ebx, 3
        sub ebx, ecx
.58:
        cmp cx, byte 2
        jge short .59
        movsx eax, cx
        movzx si, byte [nosplit eax*2+treecol_Er2]
        jmp short .60
.59:
        movsx eax, cx
        add eax, eax
        sub eax, byte 4
        mov edx, 3
        sub edx, eax
        movzx si, byte [dword edx+treecol_Er2]
.60:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        movsx edi, si
        shl edi, 2
        mov eax, dword [dword edi+playofftree]
        mov eax, dword [nosplit eax*4+potreeseeds]
        add eax, 91h
        push eax
        push str_fmtcsp
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov ebp, dword [dword edi+playofftree]
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        add eax, ebp
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        movsx ebp, bx
        mov eax, 5
        sub eax, ebp
        mov ebp, eax
        mov eax, dword [nosplit eax*4+treecolx]
        add eax, byte 64h
        mov ebx, 280h
        sub ebx, eax
        mov eax, ebx
        lea ebx, [dword esp+0B8h]
        call PrintShadowText
        mov ebx, 286h
        sub bx, word [nosplit ebp*4+treecolx]
        xor eax, eax
        mov al, byte [treecolslots+30h]
        mov eax, dword [nosplit eax*4+playofftree]
        mov ebp, dword [dword edi+playofftree]
        cmp eax, ebp
        je short .61
        xor eax, eax
        mov al, byte [treecolslots+31h]
        cmp ebp, dword [nosplit eax*4+playofftree]
        jne short .62
.61:
        mov edx, 43h
        mov eax, 0C4h
        jmp short .63
.62:
        mov edx, 43h
        mov eax, 40h
.63:
        call SetTextColors
        movsx eax, si
        mov esi, dword [esp+eax*4]
        push esi
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        movsx eax, bx
        lea ebx, [dword esp+0B8h]
        call PrintShadowText
        cmp cx, byte 1
        jne short .64
        add word [dword esp+0F0h], byte 10h
.64:
        inc ecx
.65:
        cmp cx, byte 4
        jl near DrawPlayoffTree.56
        push str_Adn1
        mov ebx, dword [dword esp+0F0h]
        push ebx
        add word [dword esp+0F8h], byte 3Dh
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        jmp short .67
.66:
        add word [dword esp+0F0h], byte 4Dh
.67:
        xor ecx, ecx
        jmp near .75
.68:
        cmp cx, byte 4
        jge short .69
        mov ebx, ecx
        movsx eax, cx
        movzx si, byte [nosplit eax*2+treecol_Er1]
        jmp short .70
.69:
        mov ebx, 7
        sub ebx, ecx
        movsx eax, cx
        add eax, eax
        sub eax, byte 8
        mov edx, 7
        sub edx, eax
        movzx si, byte [dword edx+treecol_Er1]
.70:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        movsx edi, si
        shl edi, 2
        mov eax, dword [dword edi+playofftree]
        mov eax, dword [nosplit eax*4+potreeseeds]
        add eax, 91h
        push eax
        push str_fmtcsp
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov ebp, dword [dword edi+playofftree]
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        add eax, ebp
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword esp+0B8h]
        call strcat_
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        movsx ebp, bx
        mov eax, dword [nosplit ebp*4+treecolx]
        lea ebx, [dword esp+0B8h]
        call PrintShadowText
        mov bx, word [nosplit ebp*4+treecolx]
        add ebx, byte 6Ah
        xor eax, eax
        mov al, byte [treecol_Er2]
        mov eax, dword [nosplit eax*4+playofftree]
        mov ebp, dword [dword edi+playofftree]
        cmp eax, ebp
        je short .71
        xor eax, eax
        mov al, byte [treecol_Er2+1]
        cmp ebp, dword [nosplit eax*4+playofftree]
        je short .71
        xor eax, eax
        mov al, byte [treecol_Er2+2]
        cmp ebp, dword [nosplit eax*4+playofftree]
        je short .71
        xor eax, eax
        mov al, byte [treecol_Er2+3]
        cmp ebp, dword [nosplit eax*4+playofftree]
        jne short .72
.71:
        mov edx, 43h
        mov eax, 0C4h
        jmp short .73
.72:
        mov edx, 43h
        mov eax, 40h
.73:
        call SetTextColors
        movsx eax, si
        mov esi, dword [esp+eax*4]
        push esi
        push str_D
        lea eax, [dword esp+0C0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, dword [dword esp+0EEh]
        sar edx, 10h
        movsx eax, bx
        lea ebx, [dword esp+0B8h]
        call PrintShadowText
        cmp cx, byte 3
        jne short .74
        add word [dword esp+0F0h], byte 10h
.74:
        inc ecx
.75:
        cmp cx, byte 8
        jl near DrawPlayoffTree.68
        call TextGridOff
        mov edi, dword [dword esp+0ECh]
        push edi
        call FreeMemBlock
        add esp, byte 4
        lea eax, [byte esp+078h]
        push eax
        call TextRestoreState
.76:
        add esp, byte 4
        add esp, 0F4h
        jmp near POSeedRound2_x
%endif ; C
;-----------------------------------------------------------------------------
; SetSideControls                              8B85B  95 PC, medium confidence
; Installs the home / away input handlers (menuact_homelines /
; menuact_visitorlines, code_1A8AA / code_1A922) from the controller sides
; ctl1side / ctl2side and teams (-1 none, -2 eliminated)
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/SetSideControls.c
%ifdef CBUILD
%include "c/front/playoff_mode/SetSideControls.inc"
%else
SetSideControls:
        push dword 10h
        call __CHK
        push edx
        push edi
        push ebp
        mov eax, dword [ctl1side]
        cmp eax, dword [ctl2side]
        jne short .2
        mov eax, dword [ctl1side]
        test eax, eax
        jne short .1
        mov dword [menuact_homelines], DeskHomeLines
        mov dword [menuact_visitorlines], eax
        mov dword [menusub_hmgoalie], hmgoaliemenu
        xor edx, edx
        mov dword [menusub_awgoalie], edx
        pop ebp
        pop edi
        pop edx
        ret
.1:
        xor edx, edx
        mov dword [menuact_homelines], edx
        mov dword [menuact_visitorlines], DeskVisitorLines
        mov dword [menusub_hmgoalie], edx
        jmp short .8
.2:
        cmp dword [ctl1team], byte 0FFFFFFFFh
        je short .3
        cmp dword [ctl2team], byte 0FFFFFFFFh
        jne short .4
.3:
        xor ebp, ebp
        mov dword [menuact_homelines], ebp
        mov dword [menusub_hmgoalie], ebp
        jmp short .5
.4:
        mov dword [menuact_homelines], DeskHomeLines
        mov dword [menusub_hmgoalie], hmgoaliemenu
.5:
        cmp dword [ctl1team], byte 0FFFFFFFEh
        je short .6
        cmp dword [ctl2team], byte 0FFFFFFFEh
        jne short .7
.6:
        xor edi, edi
        mov dword [menuact_visitorlines], edi
        mov dword [menusub_awgoalie], edi
        pop ebp
        pop edi
        pop edx
        ret
.7:
        mov dword [menuact_visitorlines], DeskVisitorLines
.8:
        mov dword [menusub_awgoalie], awgoaliemenu
        pop ebp
        pop edi
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; WriteCurModeState                            8B92F  95 PC, medium confidence
; WriteModeState on the state block for gamemode (0 exhstate, 1 postate, 2
; lgstate)
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/WriteCurModeState.c
%ifdef CBUILD
%include "c/front/playoff_mode/WriteCurModeState.inc"
%else
WriteCurModeState:
        push dword 4
        call __CHK
        mov eax, dword [gamemode]
        cmp eax, byte 1
        jb short .1
        jbe short .2
        cmp eax, byte 2
        je short .3
.x:
        ret
.1:
        test eax, eax
        jne short WriteCurModeState.x
        mov eax, exhstate
        jmp near WriteModeState
.2:
        mov eax, postate
        jmp near WriteModeState
.3:
        mov eax, lgstate
        jmp near WriteModeState
%endif ; C
;-----------------------------------------------------------------------------
; ClearPlayerFromLines                         8B96D  95 PC, medium confidence
; (player, lines): replaces the player's index with 64h (empty) in the 4x3
; forward lines, 3 defence pairs and the special-team slots (+12h..+27h);
; called four times from the roster screens
;-----------------------------------------------------------------------------
; C: src/front/playoff_mode/ClearPlayerFromLines.c
%ifdef CBUILD
%include "c/front/playoff_mode/ClearPlayerFromLines.inc"
%else
ClearPlayerFromLines:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov cl, al
        xor ebx, ebx
.1:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, edx
        cmp cl, byte [eax]
        jne short .2
        mov byte [eax], 64h
        jmp short .4
.2:
        cmp cl, byte [byte eax+01h]
        jne short .3
        mov byte [byte eax+01h], 64h
        jmp short .4
.3:
        cmp cl, byte [byte eax+02h]
        jne short .4
        mov byte [byte eax+02h], 64h
.4:
        inc ebx
        cmp ebx, byte 4
        jl short ClearPlayerFromLines.1
        xor ebx, ebx
.5:
        lea eax, [ebx+ebx]
        add eax, edx
        cmp cl, byte [byte eax+0Ch]
        jne short .6
        mov byte [byte eax+0Ch], 64h
        jmp short .7
.6:
        cmp cl, byte [byte eax+0Dh]
        jne short .7
        mov byte [byte eax+0Dh], 64h
.7:
        inc ebx
        cmp ebx, byte 3
        jl short ClearPlayerFromLines.5
        cmp cl, byte [byte edx+012h]
        jne short .8
        mov byte [byte edx+012h], 64h
        jmp short .12
.8:
        cmp cl, byte [byte edx+013h]
        jne short .9
        mov byte [byte edx+013h], 64h
        jmp short .12
.9:
        cmp cl, byte [byte edx+014h]
        jne short .10
        mov byte [byte edx+014h], 64h
        jmp short .12
.10:
        cmp cl, byte [byte edx+015h]
        jne short .11
        mov byte [byte edx+015h], 64h
        jmp short .12
.11:
        cmp cl, byte [byte edx+016h]
        jne short .12
        mov byte [byte edx+016h], 64h
.12:
        cmp cl, byte [byte edx+017h]
        jne short .13
        mov byte [byte edx+017h], 64h
        jmp short .17
.13:
        cmp cl, byte [byte edx+018h]
        jne short .14
        mov byte [byte edx+018h], 64h
        jmp short .17
.14:
        cmp cl, byte [byte edx+019h]
        jne short .15
        mov byte [byte edx+019h], 64h
        jmp short .17
.15:
        cmp cl, byte [byte edx+01Ah]
        jne short .16
        mov byte [byte edx+01Ah], 64h
        jmp short .17
.16:
        cmp cl, byte [byte edx+01Bh]
        jne short .17
        mov byte [byte edx+01Bh], 64h
.17:
        cmp cl, byte [byte edx+01Ch]
        jne short .18
        mov byte [byte edx+01Ch], 64h
        jmp short .21
.18:
        cmp cl, byte [byte edx+01Dh]
        jne short .19
        mov byte [byte edx+01Dh], 64h
        jmp short .21
.19:
        cmp cl, byte [byte edx+01Eh]
        jne short .20
        mov byte [byte edx+01Eh], 64h
        jmp short .21
.20:
        cmp cl, byte [byte edx+01Fh]
        jne short .21
        mov byte [byte edx+01Fh], 64h
.21:
        cmp cl, byte [byte edx+020h]
        jne short .22
        mov byte [byte edx+020h], 64h
        jmp short .25
.22:
        cmp cl, byte [byte edx+021h]
        jne short .23
        mov byte [byte edx+021h], 64h
        jmp short .25
.23:
        cmp cl, byte [byte edx+022h]
        jne short .24
        mov byte [byte edx+022h], 64h
        jmp short .25
.24:
        cmp cl, byte [byte edx+023h]
        jne short .25
        mov byte [byte edx+023h], 64h
.25:
        cmp cl, byte [byte edx+024h]
        jne short .26
        mov byte [byte edx+024h], 64h
.26:
        cmp cl, byte [byte edx+025h]
        jne short .27
        mov byte [byte edx+025h], 64h
.27:
        cmp cl, byte [byte edx+026h]
        jne short .28
        mov byte [byte edx+026h], 64h
.28:
        cmp cl, byte [byte edx+027h]
        jne short .x
        mov byte [byte edx+027h], 64h
.x:
        pop ecx
        pop ebx
        ret
%endif ; C
