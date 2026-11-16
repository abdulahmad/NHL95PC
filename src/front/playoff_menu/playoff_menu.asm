; Playoff mode screens: the mode loop, the tree menu, side controls (PC only).
bits 32
%include "hockey.inc"
section s_89268 progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, awgoaliemenu, cddriveptr, CheckGameDiskSpace, ClearInputQueue, CountSeriesWins, ctl1side
extern ctl1team, ctl2side, ctl2team, curleague, DeskHomeLines, DeskVisitorLines, DrawArt, DrawMenuBar
extern DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, DrawShape, PoStandingsMode, EasnGoalieStatsScreen, EasnSkaterStatsScreen, EasnStandingsMenu
extern EasnStandingsScreen, EasnTeamStatsScreen, embscupbank, exhstate, FadePalStep, FileClose, fileoncd, FileOpenRead
extern FindShape, fputchar, FreeMemBlock, GameGoalieStatsScreen, gamemode, gameopts, gameresult, GameSkaterStatsScreen
extern GameStandingsMenu, GameStandingsScreen, GameTeamStatsScreen, GetInputEvent, goaliestatscb, GrabBlock, hmgoaliemenu, HomeTeam
extern InitGameSummary, InputInstall, InputRemove, j_unlink_, kaufmfont, lgstate, LoadBank, LoadModeState
extern LoadScheduleDB, mainfont, MakePath, menuact_homelines, menuact_playnextgame, menuact_visitorlines, MenuHitTest, MenuPlayNextGame
extern menusub_awgoalie, menusub_hmgoalie, mousepollfn, MouseSetPos, musichandle, musicon, musicslot, PlayGame
extern playoffmenubar, playofftree, playofftree_p1, POAfterGame, pochampion, POCreateSchedule, POCreateSchedule_x, POHandleElimination
extern pointerspr, POSeedRound2, POSeedRound2_x, POSeedRound2_x30, poslotx, posloty, postate, potreeround
extern potreeseeds, PreGameScreen, PrintCenteredText, PrintOutlinedText, PrintShadowText, ptrupdatefn, PutBlock, SaveModeState
extern SaveScheduleDB, schedgameidx, scrpitch, seriesgameno, SeriesWinner, SetClipWindow, SetDialogColors, SetPalette
extern SetScreenTitle, SetTextColors, SetupControllers, SetupStatsSourceMenu, SetViewRect, ShowLoadingScreen, skaterstatscb, SndQuery
extern songdata, sprintf_, standingscb, standingsmenucb, str_Adn1, str_Adn2, str_Adn3, str_Aup1
extern str_Aup2, str_Aup3, str_BangPal, str_Bkgd2, str_D, str_EasternConference, str_Embpal, str_Embscup
extern str_fmtcsp, str_GameSav, str_Menubuff2, str_Midl, str_Palette, str_PlayoffsHaveNotBeen, str_Pointer, str_POTitle
extern str_Pstatbar2, str_Rst1, str_Rst2, str_Scuparrw, str_space4, str_space5, str_WesternConference, strcat_
extern strcpy_, PushMemDescriptorLocked, SetDigiChannelVolume, ClearScreenColour, XorRectOutline, SetScreenTarget, teamcitynames, teamconf
extern teamstatscb, TextGridOff, TextGridOpen, TextRestoreState, TextSaveState, TextSetFont, treecol_Er1, treecol_Er2
extern treecol_Wr2, treecolslots, treecolx, treeteamnames, VgaSetPalette, VisTeam, WriteModeState
global PlayoffModeLoop, POReturnZero, POHiliteSlot, PlayoffTreeMenu, DrawPlayoffTree, SetSideControls, WriteCurModeState, ClearPlayerFromLines
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
        call SetDigiChannelVolume
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
        call PushMemDescriptorLocked
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
        call SetDigiChannelVolume
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
        call PushMemDescriptorLocked
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
        mov dword [PoStandingsMode], eax
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
        call ClearScreenColour
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
        mov dword [PoStandingsMode], ecx
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
; C: src/front/playoff_menu/POReturnZero.c
%ifdef CBUILD
%include "c/front/playoff_menu/POReturnZero.inc"
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
        call XorRectOutline
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
        call XorRectOutline
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
        call SetScreenTarget
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
        call SetScreenTarget
        xor ebp, ebp
        mov dword [PoStandingsMode], ebp
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
        call SetScreenTarget
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
        call SetScreenTarget
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
        cmp dword [PoStandingsMode], byte 1
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
        mov dword [PoStandingsMode], edi
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
; C: src/front/playoff_menu/SetSideControls.c
%ifdef CBUILD
%include "c/front/playoff_menu/SetSideControls.inc"
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
; C: src/front/playoff_menu/WriteCurModeState.c
%ifdef CBUILD
%include "c/front/playoff_menu/WriteCurModeState.inc"
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
; C: src/front/playoff_menu/ClearPlayerFromLines.c
%ifdef CBUILD
%include "c/front/playoff_menu/ClearPlayerFromLines.inc"
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
