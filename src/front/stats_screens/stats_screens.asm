; Statistics screens opened from a game, from the EA Sports desk, and from the calendar.
bits 32
%include "hockey.inc"
section s_20016 progbits alloc exec nowrite align=1
extern __CHK, calendarshapes, cddriveptr, deskexit, DrawMenuBar, easnfontbuf, embscupbank, PoStandingsMode
extern StatsLastSel, RosterFromStandings, leaguestatsmode, calredraw, FadePalStep, fileoncd, FreeDeskBuffers, FreeMemBlock
extern gamemode, GoalieStatsCard, InitMenuRemap, keepdesksong, LeadersScreen, MakePath, memcpy_, photoremap
extern playofftree, RunMenu, RunPlayerPickMenu, RunTeamPickMenu, ShowPlayoffTree, SkaterStatsCard, standingscb, StandingsScreen
extern statsbgnames, statsbgshapes, statscategory, statsgoaliebuf, statspal, statspalshape, statspalvalid, statsplayer
extern statsplayerbuf, statsplayoffs, statsredrawcb, statsskaterbuf, statsteambuf, statsteamorder, statsteamsel, str_calendar
extern str_easndesk2, str_EASNvfn, str_embpal, str_embpal2, str_embpal3, str_gstat, str_gstat2, str_gstat3
extern str_keys, str_keys2, str_keys3, str_Pal6, str_Pal7, str_Pal8, str_pstat, str_pstat2
extern str_pstat3, str_tstat, str_tstat2, str_tstat3, AllocMemBlock, MemLargestFree, LoadBank, OpenArtArchiveErr
extern SetPalette, DrawArtKeyColour, FindShape, ClearScreen, VgaSetPalette, SetScreenTarget, SetColorRemap, TeamRosterScreen
extern TeamStatsScreen, standingsmenubar, rostermenubar, playercardmenubar, teamstatsmenubar, skaterstatsmenubar, goaliestatsmenubar
global GameTeamStatsScreen, GameTeamStatsScreen_common, GameSkaterStatsScreen, GameSkaterStatsScreen_x, GameGoalieStatsScreen, GameStandingsScreen, GameStandingsMenu_jt, GameStandingsMenu
global GameStandingsMenu_standings, GameStandingsMenu_roster, GameStandingsMenu_player, GameStandingsMenu_player2, EasnTeamStatsScreen, EasnTeamStatsScreen_m, EasnTeamStatsScreen_x, EasnSkaterStatsScreen
global EasnSkaterStatsScreen_m, EasnGoalieStatsScreen, EasnGoalieStatsScreen_m, EasnGoalieStatsScreen_common, EasnStandingsScreen, EasnStandingsMenu_jt, EasnStandingsMenu, EasnStandingsMenu_m
global EasnStandingsMenu_standings, EasnStandingsMenu_roster, EasnStandingsMenu_player, EasnStandingsMenu_player2, FreeCalendarIfLowMem, LoadCalendarShapes, CalTeamStatsScreen, CalTeamStatsScreen_common
global CalTeamStatsScreen_x, CalSkaterStatsScreen, CalGoalieStatsScreen, CalStandingsScreen, CalStandingsMenu_jt, CalStandingsMenu, CalStandingsMenu_standings, CalStandingsMenu_roster
global CalStandingsMenu_player, CalStandingsMenu_player2, DrawPhotoWithPal
;-----------------------------------------------------------------------------
; GameTeamStatsScreen                          20016  95 PC, medium confidence
; Teamstatscb set around PlayGame: team stats screen (TeamStatsScreen) with
; embpal / !pal palette fade and RunMenu on the 4-item menu
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/GameTeamStatsScreen.c
%ifdef CBUILD
%include "c/front/stats_screens/GameTeamStatsScreen.inc"
%else
GameTeamStatsScreen:
        push dword 330h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, 310h
        mov esi, eax
        mov dword [leaguestatsmode], 1
        mov dword [statscategory], eax
        mov dword [statsredrawcb], TeamStatsScreen
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
        call SetScreenTarget
        mov eax, 1
        call InitMenuRemap
        mov eax, esi
        call TeamStatsScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, teamstatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal6
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        mov ecx, dword [statsbgshapes]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, teamstatsmenubar
GameTeamStatsScreen_common:
        call RunMenu
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
        xor esi, esi
        mov dword [leaguestatsmode], esi
        mov dword [statsredrawcb], esi
        mov eax, 2
        add esp, 310h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GameSkaterStatsScreen                        20171  95 PC, medium confidence
; Skaterstatscb in game: skater stats (LeadersScreen) + RunMenu
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/GameSkaterStatsScreen.c
%ifdef CBUILD
%include "c/front/stats_screens/GameSkaterStatsScreen.inc"
%else
GameSkaterStatsScreen:
        push dword 334h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 310h
        mov esi, eax
        mov edx, 1
        mov dword [leaguestatsmode], edx
        mov dword [statscategory], eax
        mov dword [statsredrawcb], LeadersScreen
        mov dword [statspalvalid], edx
        mov eax, esp
        mov dword [statspal], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        call SetScreenTarget
        mov eax, 1
        call InitMenuRemap
        mov eax, esi
        call LeadersScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, skaterstatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal6
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        mov esi, dword [statsbgshapes]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        xor edi, edi
        mov dword [statspalvalid], edi
        mov dword [statspal], edi
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, skaterstatsmenubar
        call RunMenu
        mov eax, esp
        push eax
        push dword 100h
        push edi
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov dword [leaguestatsmode], edi
        mov dword [statsredrawcb], edi
        mov eax, 2
        add esp, 310h
GameSkaterStatsScreen_x:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GameGoalieStatsScreen                        202E5  95 PC, medium confidence
; Goaliestatscb in game: goalie stats (LeadersScreen) + menu
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/GameTeamStatsScreen.c (GameGoalieStatsScreen)
%ifdef CBUILD
%include "c/front/stats_screens/GameTeamStatsScreen.GameGoalieStatsScreen.inc"
%else
GameGoalieStatsScreen:
        push dword 330h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, 310h
        mov esi, eax
        mov dword [leaguestatsmode], 1
        mov dword [statscategory], eax
        mov dword [statsredrawcb], LeadersScreen
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
        mov eax, 1
        call InitMenuRemap
        mov eax, esi
        call LeadersScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, goaliestatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal6
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        mov ecx, dword [statsbgshapes]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, goaliestatsmenubar
        jmp near GameTeamStatsScreen_common
%endif ; C
;-----------------------------------------------------------------------------
; GameStandingsScreen                          203FA  95 PC, medium confidence
; Standingscb in game: loads EASN.vfn, draws standings via StandingsScreen
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/GameStandingsScreen.c
%ifdef CBUILD
%include "c/front/stats_screens/GameStandingsScreen.inc"
%else
GameStandingsScreen:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 10h
        cmp dword [statsplayoffs], byte 0
        je near .7
        mov ebx, dword [easnfontbuf]
        test ebx, ebx
        jne short .1
        push ebx
        push str_EASNvfn
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [easnfontbuf], eax
.1:
        mov ecx, dword [embscupbank]
        test ecx, ecx
        jne short .6
        mov eax, dword [statsplayoffs]
        shl eax, 2
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Ch], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .5
.2:
        xor edx, edx
        jmp short .5
.3:
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Dh], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [embscupbank], eax
.6:
        mov eax, dword [statsteambuf]
        mov edx, statsteamorder
        call ShowPlayoffTree
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        jmp short .8
.7:
        call FreeDeskBuffers
        call SetScreenTarget
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        mov eax, dword [statsteambuf]
        mov edx, statsteamorder
        call StandingsScreen
.8:
        xor eax, eax
        add esp, byte 10h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
        db 08Dh,040h,00h
GameStandingsMenu_jt:                           ; used by GameStandingsMenu
        dd GameStandingsMenu_standings
        dd GameStandingsMenu_roster
        dd GameStandingsMenu_player
        dd GameStandingsMenu_player2
;-----------------------------------------------------------------------------
; GameStandingsMenu                            2051A  95 PC, medium confidence
; Standingsmenucb in game: allocs tstat / keys / pstat / gstat, Overall
; Standings + team picker, Team Roster player picker, player screens;
;
; loops on deskexit
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/GameSkaterStatsScreen.c (GameStandingsMenu)
%ifdef CBUILD
%include "c/front/stats_screens/GameSkaterStatsScreen.GameStandingsMenu.inc"
%else
GameStandingsMenu:
        push dword 338h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 310h
        mov dword [leaguestatsmode], 1
        mov eax, dword [standingscb]
        mov dword [statsredrawcb], eax
        xor ebx, ebx
        mov dword [statsteamsel], ebx
        mov dword [statscategory], ebx
        xor ah, ah
        mov byte [statsplayer+2], ah
        mov eax, esp
        push eax
        push dword 100h
        push ebx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        xor esi, esi
        mov dword [PoStandingsMode], esi
        mov eax, 1
        call InitMenuRemap
        push byte 20h
        push dword 2A4h
        push str_tstat
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsteambuf], eax
        push byte 20h
        push dword 5B0h
        push str_keys
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsplayerbuf], eax
        push byte 20h
        push dword 497h
        push str_pstat
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsskaterbuf], eax
        push byte 20h
        push dword 10Eh
        push str_gstat
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsgoaliebuf], eax
        xor eax, eax
        call dword [standingscb]
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        mov dword [statscategory], esi
        mov dword [statsteamsel], esi
        xor ecx, ecx
        mov ebx, str_embpal
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal6
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        add eax, byte 10h
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        mov eax, dword [statsbgshapes]
        push eax
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call RunTeamPickMenu
        call FreeDeskBuffers
        mov edi, GoalieStatsCard
        mov esi, 1
.3:
        mov edx, dword [deskexit]
        cmp edx, byte 1
        je near GameStandingsMenu_player2.1
        lea eax, [byte edx-02h]
        cmp eax, byte 3
        ja short GameStandingsMenu.3
        jmp dword [nosplit cs:eax*4+GameStandingsMenu_jt]
GameStandingsMenu_standings:
        mov eax, dword [standingscb]
        mov dword [statsredrawcb], eax
        xor eax, eax
        call dword [standingscb]
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call RunTeamPickMenu
        cmp dword [statsplayoffs], byte 0
        je short .1
        call FreeDeskBuffers
.1:
        xor ecx, ecx
        mov dword [PoStandingsMode], ecx
        jmp short GameStandingsMenu.3
GameStandingsMenu_roster:
        xor eax, eax
        mov dword [RosterFromStandings], eax
        mov dword [statsredrawcb], TeamRosterScreen
        mov eax, dword [statscategory]
        call TeamRosterScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, rostermenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, rostermenubar
        call RunPlayerPickMenu
        jmp near GameStandingsMenu.3
GameStandingsMenu_player:
        mov dword [statsredrawcb], edi
        xor ebp, ebp
        mov dword [StatsLastSel], ebp
        mov eax, statsplayer
        call GoalieStatsCard
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call RunMenu
        jmp near GameStandingsMenu.3
GameStandingsMenu_player2:
        mov dword [statsredrawcb], SkaterStatsCard
        xor ecx, ecx
        mov dword [StatsLastSel], ecx
        mov eax, statsplayer
        call SkaterStatsCard
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call RunMenu
        mov dword [PoStandingsMode], esi
        jmp near GameStandingsMenu.3
.1:
        xor esi, esi
        mov dword [PoStandingsMode], esi
        mov eax, esp
        push eax
        push dword 100h
        push esi
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        call FreeDeskBuffers
        mov edi, dword [statsteambuf]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [statsgoaliebuf]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsskaterbuf]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [statsplayerbuf]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov dword [statsplayerbuf], esi
        mov dword [statsteambuf], esi
        mov dword [statsgoaliebuf], esi
        mov dword [statsskaterbuf], esi
        mov dword [leaguestatsmode], esi
        mov dword [statsredrawcb], esi
        mov eax, 2
        add esp, 310h
        pop ebp
        jmp near GameSkaterStatsScreen_x
%endif ; C
;-----------------------------------------------------------------------------
; EasnTeamStatsScreen                                             208EF  95 PC
; The desk's team-stats page.
;
; Fill the palette buffer and fade out after the menu remap, draw
; TeamStatsScreen, and load embpal2 (from the CD when fileoncd 8Eh says so).
;
; Pal7 is faded in from the shape itself. keepdesksong stays set so the desk
; music is not freed. Returns 2.
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/EasnTeamStatsScreen.c
%ifdef CBUILD
%include "c/front/stats_screens/EasnTeamStatsScreen.inc"
%else
EasnTeamStatsScreen:
        push dword 334h
EasnTeamStatsScreen_m:
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 310h
        mov esi, eax
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, 1
        mov dword [keepdesksong], edx
        mov dword [leaguestatsmode], edx
        mov dword [statscategory], esi
        mov dword [statsredrawcb], TeamStatsScreen
        call SetScreenTarget
        mov eax, 1
        call InitMenuRemap
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov eax, esi
        call TeamStatsScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, teamstatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal2
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal7
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [statsbgshapes]
        push esi
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, teamstatsmenubar
        call RunMenu
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
        xor edi, edi
        mov dword [leaguestatsmode], edi
        mov dword [statsredrawcb], edi
        mov eax, 2
        add esp, 310h
EasnTeamStatsScreen_x:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
EasnSkaterStatsScreen:                          ; used by MainDeskLoop, MenuNewExhibition, MenuNextLeagueGame
                                                ; ...
        db 068h,034h,03h,00h,00h,0E8h
;-----------------------------------------------------------------------------
; EasnSkaterStatsScreen_m                                         20A4C  95 PC
; EASN skater stats screen: sets the palette, league stats mode and category,
; and redraws through LeadersScreen.
;-----------------------------------------------------------------------------
EasnSkaterStatsScreen_m:
        cld
        mov esi, 51530006h
        push edx
        push esi
        push ebp
        sub esp, 310h
        mov esi, eax
        mov dword [keepdesksong], 1
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov dword [leaguestatsmode], 1
        mov dword [statscategory], esi
        mov dword [statsredrawcb], LeadersScreen
        call SetScreenTarget
        mov eax, 1
        call InitMenuRemap
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov eax, esi
        call LeadersScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, skaterstatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal2
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal7
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [statsbgshapes]
        push esi
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, skaterstatsmenubar
        call RunMenu
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        cmp dword [gamemode], byte 1
        je short .4
        xor ecx, ecx
        mov ebx, str_easndesk2
        cmp byte [fileoncd+06Ah], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp near EasnGoalieStatsScreen_common
.3:
        xor edx, edx
        jmp near EasnGoalieStatsScreen_common
.4:
        xor ecx, ecx
        mov ebx, str_embpal2
        cmp byte [fileoncd+08Eh], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp near EasnGoalieStatsScreen_common
.5:
        xor edx, edx
        jmp near EasnGoalieStatsScreen_common
;-----------------------------------------------------------------------------
; EasnGoalieStatsScreen                                           20BBD  95 PC
; EASN goalie stats screen (goaliestatscb of the playoff and league menus).
;-----------------------------------------------------------------------------
EasnGoalieStatsScreen:
        push dword 334h
EasnGoalieStatsScreen_m:
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        sub esp, 310h
        mov esi, eax
        mov dword [keepdesksong], 1
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov dword [leaguestatsmode], 1
        mov dword [statscategory], esi
        mov dword [statsredrawcb], LeadersScreen
        call SetScreenTarget
        mov eax, 1
        call InitMenuRemap
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov eax, esi
        call LeadersScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, goaliestatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal2
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal7
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [statsbgshapes]
        push esi
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, goaliestatsmenubar
        call RunMenu
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        cmp dword [gamemode], byte 1
        je near EasnGoalieStatsScreen_common.2
        xor ecx, ecx
        mov ebx, str_easndesk2
        cmp byte [fileoncd+06Ah], 1
.3:
        jne short EasnGoalieStatsScreen_common.1
        mov edx, dword [cddriveptr]
EasnGoalieStatsScreen_common:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal7
        push eax
        call FindShape
        add esp, byte 8
        add eax, byte 10h
        mov dword [statspalshape], eax
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov ebp, dword [statsbgshapes]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [leaguestatsmode], eax
        mov dword [statsredrawcb], eax
        mov eax, 2
        add esp, 310h
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        xor edx, edx
        jmp short EasnGoalieStatsScreen_common
.2:
        xor ecx, ecx
        mov ebx, str_embpal2
        cmp byte [fileoncd+08Eh], 1
        jmp near EasnGoalieStatsScreen_m.3
;-----------------------------------------------------------------------------
; EasnStandingsScreen                          20D97  95 PC, medium confidence
; Standingscb front-end variant (EASN.vfn, StandingsScreen)
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/EasnStandingsScreen.c
%ifdef CBUILD
%include "c/front/stats_screens/EasnStandingsScreen.inc"
%else
EasnStandingsScreen:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 10h
        cmp dword [statsplayoffs], byte 0
        je near .7
        mov ebx, dword [easnfontbuf]
        test ebx, ebx
        jne short .1
        push ebx
        push str_EASNvfn
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [easnfontbuf], eax
.1:
        mov ecx, dword [embscupbank]
        test ecx, ecx
        jne short .6
        mov eax, dword [statsplayoffs]
        shl eax, 2
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Ch], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .5
.2:
        xor edx, edx
        jmp short .5
.3:
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Dh], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [embscupbank], eax
.6:
        mov eax, dword [statsteambuf]
        mov edx, statsteamorder
        call ShowPlayoffTree
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        jmp short .8
.7:
        call FreeDeskBuffers
        call SetScreenTarget
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        mov eax, dword [statsteambuf]
        mov edx, statsteamorder
        call StandingsScreen
.8:
        xor eax, eax
        add esp, byte 10h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
        db 08Dh,040h,00h
EasnStandingsMenu_jt:                           ; used by EasnStandingsMenu_m
        dd EasnStandingsMenu_standings
        dd EasnStandingsMenu_roster
        dd EasnStandingsMenu_player
        dd EasnStandingsMenu_player2
EasnStandingsMenu:                              ; used by MainDeskLoop, MenuNewExhibition, MenuNextLeagueGame
                                                ; ...
        db 068h,0B4h,03h,00h,00h
;-----------------------------------------------------------------------------
; EasnStandingsMenu_m                                             20EBC  95 PC
; EASN standings menu: copies the playoff tree, sets league stats mode and
; draws the standings through standingscb.
;-----------------------------------------------------------------------------
EasnStandingsMenu_m:
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 38Ch
        xor eax, eax
.1:
        mov ebx, dword [nosplit eax*4+playofftree]
        mov dword [dword esp+eax*4+0300h], ebx
        inc eax
        cmp eax, byte 1Fh
        jl short EasnStandingsMenu_m.1
        mov edx, 1
        mov dword [leaguestatsmode], edx
        mov eax, dword [standingscb]
        mov dword [statsredrawcb], eax
        xor ebx, ebx
        mov dword [statsteamsel], ebx
        mov dword [statscategory], ebx
        mov dword [PoStandingsMode], ebx
        mov edi, edx
        mov dword [keepdesksong], edx
        xor ah, ah
        mov byte [statsplayer+2], ah
        mov eax, esp
        push eax
        push dword 100h
        push ebx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, edi
        call FadePalStep
        mov eax, edi
        call InitMenuRemap
        push byte 20h
        push dword 2A4h
        push str_tstat2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsteambuf], eax
        push byte 20h
        push dword 5B0h
        push str_keys2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsplayerbuf], eax
        push byte 20h
        push dword 497h
        push str_pstat2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsskaterbuf], eax
        push byte 20h
        push dword 10Eh
        push str_gstat2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsgoaliebuf], eax
        xor eax, eax
        call dword [standingscb]
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        xor ebp, ebp
        mov dword [statscategory], ebp
        mov dword [statsteamsel], ebp
        xor ecx, ecx
        mov ebx, str_embpal2
        cmp byte [fileoncd+08Eh], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        lea eax, [dword esp+037Ch]
        call MakePath
        push byte 0
        lea eax, [dword esp+0380h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal7
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov edx, dword [statsbgshapes]
        push edx
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call RunTeamPickMenu
        call FreeDeskBuffers
        call SetScreenTarget
        mov edi, GoalieStatsCard
        mov esi, 1
.4:
        mov ebx, dword [deskexit]
        cmp ebx, byte 1
        je near EasnStandingsMenu_player2.1
        lea eax, [byte ebx-02h]
        cmp eax, byte 3
        ja short EasnStandingsMenu_m.4
        jmp dword [nosplit cs:eax*4+EasnStandingsMenu_jt]
;-----------------------------------------------------------------------------
; EasnStandingsMenu_standings                                     21093  95 PC
; EasnStandingsMenu item: the standings page and its menu bar.
;-----------------------------------------------------------------------------
EasnStandingsMenu_standings:
        mov eax, dword [standingscb]
        mov dword [statsredrawcb], eax
        xor eax, eax
        call dword [standingscb]
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call RunTeamPickMenu
        cmp dword [statsplayoffs], byte 0
        je short .1
        call FreeDeskBuffers
        call SetScreenTarget
.1:
        xor ecx, ecx
        mov dword [PoStandingsMode], ecx
        jmp near EasnStandingsMenu_m.4
;-----------------------------------------------------------------------------
; EasnStandingsMenu_roster                                        210FB  95 PC
; EasnStandingsMenu item: the team roster page (TeamRosterScreen) and its
; menu bar.
;-----------------------------------------------------------------------------
EasnStandingsMenu_roster:
        xor eax, eax
        mov dword [RosterFromStandings], eax
        mov dword [statsredrawcb], TeamRosterScreen
        mov eax, dword [statscategory]
        call TeamRosterScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, rostermenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, rostermenubar
        call RunPlayerPickMenu
        jmp near EasnStandingsMenu_m.4
;-----------------------------------------------------------------------------
; EasnStandingsMenu_player                                        21151  95 PC
; EasnStandingsMenu item: a goalie's stats card and the player card menu bar.
;-----------------------------------------------------------------------------
EasnStandingsMenu_player:
        mov dword [statsredrawcb], edi
        xor ebp, ebp
        mov dword [StatsLastSel], ebp
        mov eax, statsplayer
        call GoalieStatsCard
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call RunMenu
        jmp near EasnStandingsMenu_m.4
;-----------------------------------------------------------------------------
; EasnStandingsMenu_player2                                       211A4  95 PC
; EasnStandingsMenu item: a skater's stats card and the player card menu bar.
;-----------------------------------------------------------------------------
EasnStandingsMenu_player2:
        mov dword [statsredrawcb], SkaterStatsCard
        xor edx, edx
        mov dword [StatsLastSel], edx
        mov dword [statspalvalid], edx
        mov dword [statspal], edx
        mov eax, statsplayer
        call SkaterStatsCard
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call RunMenu
        mov dword [PoStandingsMode], esi
        jmp near EasnStandingsMenu_m.4
.1:
        xor ecx, ecx
        mov dword [PoStandingsMode], ecx
        call FreeDeskBuffers
        mov esi, dword [statsteambuf]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov edi, dword [statsgoaliebuf]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [statsskaterbuf]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsplayerbuf]
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor edx, edx
        mov dword [statsplayerbuf], edx
        mov dword [statsteambuf], edx
        mov dword [statsgoaliebuf], edx
        mov dword [statsskaterbuf], edx
        mov eax, esp
        push eax
        push dword 100h
        push edx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        xor edi, edi
        mov dword [leaguestatsmode], edi
        mov dword [statsredrawcb], edi
        xor eax, eax
.2:
        mov ebx, dword [dword esp+eax*4+0300h]
        mov dword [nosplit eax*4+playofftree], ebx
        inc eax
        cmp eax, byte 1Fh
        jl short EasnStandingsMenu_player2.2
        mov eax, 2
        add esp, 38Ch
        pop ebp
        jmp near EasnTeamStatsScreen_x
;-----------------------------------------------------------------------------
; FreeCalendarIfLowMem                         212C6  95 PC, medium confidence
; Frees calendarshapes when free memory <= 4B708h
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/FreeCalendarIfLowMem.c
%ifdef CBUILD
%include "c/front/stats_screens/FreeCalendarIfLowMem.inc"
%else
FreeCalendarIfLowMem:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        call MemLargestFree
        cmp eax, 4B708h
        jg short .x
        mov edx, dword [calendarshapes]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
.1:
        xor ecx, ecx
        mov dword [calendarshapes], ecx
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadCalendarShapes                                              212FE  95 PC
; Loads "calendar" shape file into calendarshapes if not loaded
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/LoadCalendarShapes.c
%ifdef CBUILD
%include "c/front/stats_screens/LoadCalendarShapes.inc"
%else
LoadCalendarShapes:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 20h
        mov edx, dword [calendarshapes]
        test edx, edx
        jne short .x
        xor ecx, ecx
        mov ebx, str_calendar
        cmp byte [fileoncd+01C1h], 1
        jne short .1
        mov edx, dword [cddriveptr]
.1:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [calendarshapes], eax
.x:
        add esp, byte 20h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalTeamStatsScreen                           21350  95 PC, medium confidence
; Teamstatscb set by calendar (CalendarScreen): frees calendar, team stats screen,
; reloads calendar
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/CalTeamStatsScreen.c
%ifdef CBUILD
%include "c/front/stats_screens/CalTeamStatsScreen.inc"
%else
CalTeamStatsScreen:
        push dword 334h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 310h
        mov esi, eax
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov dword [leaguestatsmode], 1
        mov dword [statscategory], esi
        mov dword [statsredrawcb], TeamStatsScreen
        call SetScreenTarget
        mov eax, 1
        call InitMenuRemap
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        call FreeCalendarIfLowMem
        mov eax, esi
        call TeamStatsScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, teamstatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal3
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal8
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov ecx, dword [statsbgshapes]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, teamstatsmenubar
CalTeamStatsScreen_common:
        call RunMenu
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
        mov dword [calredraw], 0FFFFFFFFh
        call LoadCalendarShapes
        xor edi, edi
        mov dword [leaguestatsmode], edi
        mov dword [statsredrawcb], edi
        xor eax, eax
        add esp, 310h
CalTeamStatsScreen_x:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalSkaterStatsScreen                         214B1  95 PC, medium confidence
; Calendar skater stats
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/CalTeamStatsScreen.c (CalSkaterStatsScreen)
%ifdef CBUILD
%include "c/front/stats_screens/CalTeamStatsScreen.CalSkaterStatsScreen.inc"
%else
CalSkaterStatsScreen:
        push dword 334h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 310h
        mov esi, eax
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov dword [leaguestatsmode], 1
        mov dword [statscategory], esi
        mov dword [statsredrawcb], LeadersScreen
        call SetScreenTarget
        mov eax, 1
        call InitMenuRemap
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        call FreeCalendarIfLowMem
        mov eax, esi
        call LeadersScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, skaterstatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal3
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal8
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov ecx, dword [statsbgshapes]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, skaterstatsmenubar
        jmp near CalTeamStatsScreen_common
%endif ; C
;-----------------------------------------------------------------------------
; CalGoalieStatsScreen                         215C4  95 PC, medium confidence
; Calendar goalie stats
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/CalTeamStatsScreen.c (CalGoalieStatsScreen)
%ifdef CBUILD
%include "c/front/stats_screens/CalTeamStatsScreen.CalGoalieStatsScreen.inc"
%else
CalGoalieStatsScreen:
        push dword 334h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 310h
        mov esi, eax
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov dword [leaguestatsmode], 1
        mov dword [statscategory], esi
        mov dword [statsredrawcb], LeadersScreen
        call SetScreenTarget
        mov eax, 1
        call InitMenuRemap
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        call FreeCalendarIfLowMem
        mov eax, esi
        call LeadersScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, goaliestatsmenubar
        call DrawMenuBar
        xor ecx, ecx
        mov ebx, str_embpal3
        cmp byte [fileoncd+08Eh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal8
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov ecx, dword [statsbgshapes]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, goaliestatsmenubar
        jmp near CalTeamStatsScreen_common
%endif ; C
;-----------------------------------------------------------------------------
; CalStandingsScreen                           216D7  95 PC, medium confidence
; Calendar standings
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/CalStandingsScreen.c
%ifdef CBUILD
%include "c/front/stats_screens/CalStandingsScreen.inc"
%else
CalStandingsScreen:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 10h
        call FreeCalendarIfLowMem
        cmp dword [statsplayoffs], byte 0
        je near .7
        mov ebx, dword [easnfontbuf]
        test ebx, ebx
        jne short .1
        push ebx
        push str_EASNvfn
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [easnfontbuf], eax
.1:
        mov ecx, dword [embscupbank]
        test ecx, ecx
        jne short .6
        mov eax, dword [statsplayoffs]
        shl eax, 2
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Ch], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .5
.2:
        xor edx, edx
        jmp short .5
.3:
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Dh], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [embscupbank], eax
.6:
        mov eax, dword [statsteambuf]
        mov edx, statsteamorder
        call ShowPlayoffTree
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        jmp short .8
.7:
        call FreeDeskBuffers
        call SetScreenTarget
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        mov eax, dword [statsteambuf]
        mov edx, statsteamorder
        call StandingsScreen
.8:
        call LoadCalendarShapes
        xor eax, eax
        add esp, byte 10h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
CalStandingsMenu_jt:                            ; used by CalStandingsMenu
        dd CalStandingsMenu_standings
        dd CalStandingsMenu_roster
        dd CalStandingsMenu_player
        dd CalStandingsMenu_player2
;-----------------------------------------------------------------------------
; CalStandingsMenu                             217FE  95 PC, medium confidence
; Standingsmenucb set by calendar; also in a menu table
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/CalTeamStatsScreen.c (CalStandingsMenu)
%ifdef CBUILD
%include "c/front/stats_screens/CalTeamStatsScreen.CalStandingsMenu.inc"
%else
CalStandingsMenu:
        push dword 3B4h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 38Ch
        xor eax, eax
.1:
        mov ebx, dword [nosplit eax*4+playofftree]
        mov dword [dword esp+eax*4+0300h], ebx
        inc eax
        cmp eax, byte 1Fh
        jl short CalStandingsMenu.1
        mov dword [leaguestatsmode], 1
        mov eax, dword [standingscb]
        mov dword [statsredrawcb], eax
        xor ebx, ebx
        mov dword [statsteamsel], ebx
        mov dword [statscategory], ebx
        xor ah, ah
        mov byte [statsplayer+2], ah
        mov eax, esp
        push eax
        push dword 100h
        push ebx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        call FreeCalendarIfLowMem
        xor esi, esi
        mov dword [PoStandingsMode], esi
        mov eax, 1
        call InitMenuRemap
        push byte 20h
        push dword 2A4h
        push str_tstat3
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsteambuf], eax
        push byte 20h
        push dword 5B0h
        push str_keys3
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsplayerbuf], eax
        push byte 20h
        push dword 497h
        push str_pstat3
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsskaterbuf], eax
        push byte 20h
        push dword 10Eh
        push str_gstat3
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsgoaliebuf], eax
        xor eax, eax
        call dword [standingscb]
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        mov dword [statscategory], esi
        mov dword [statsteamsel], esi
        xor ecx, ecx
        mov ebx, str_embpal3
        cmp byte [fileoncd+08Eh], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        lea eax, [dword esp+037Ch]
        call MakePath
        push byte 0
        lea eax, [dword esp+0380h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pal8
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov eax, dword [statsbgshapes]
        push eax
        call FreeMemBlock
        add esp, byte 4
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call RunTeamPickMenu
        call FreeDeskBuffers
        call SetScreenTarget
        mov edi, TeamRosterScreen
.4:
        mov edx, dword [deskexit]
        cmp edx, byte 1
        je near CalStandingsMenu_player2.1
        lea eax, [byte edx-02h]
        cmp eax, byte 3
        ja short CalStandingsMenu.4
        jmp dword [nosplit cs:eax*4+CalStandingsMenu_jt]
CalStandingsMenu_standings:
        mov eax, dword [standingscb]
        mov dword [statsredrawcb], eax
        xor eax, eax
        call dword [standingscb]
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, standingsmenubar
        call RunTeamPickMenu
        cmp dword [statsplayoffs], byte 0
        je short .1
        call FreeDeskBuffers
        call SetScreenTarget
.1:
        xor eax, eax
        mov dword [PoStandingsMode], eax
        jmp near CalStandingsMenu.4
CalStandingsMenu_roster:
        xor esi, esi
        mov dword [RosterFromStandings], esi
        mov dword [statsredrawcb], edi
        mov eax, dword [statscategory]
        call TeamRosterScreen
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, rostermenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 4
        mov eax, rostermenubar
        call RunPlayerPickMenu
        jmp near CalStandingsMenu.4
CalStandingsMenu_player:
        mov dword [statsredrawcb], GoalieStatsCard
        xor ecx, ecx
        mov dword [StatsLastSel], ecx
        mov eax, statsplayer
        call GoalieStatsCard
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call RunMenu
        jmp near CalStandingsMenu.4
CalStandingsMenu_player2:
        mov dword [statsredrawcb], SkaterStatsCard
        xor eax, eax
        mov dword [StatsLastSel], eax
        mov eax, statsplayer
        call SkaterStatsCard
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call DrawMenuBar
        push byte 42h
        mov ecx, 41h
        mov ebx, 40h
        mov edx, 2
        mov eax, playercardmenubar
        call RunMenu
        mov dword [PoStandingsMode], 1
        jmp near CalStandingsMenu.4
.1:
        xor ebx, ebx
        mov dword [PoStandingsMode], ebx
        call FreeDeskBuffers
        mov ecx, dword [statsteambuf]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov esi, dword [statsgoaliebuf]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov edi, dword [statsskaterbuf]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [statsplayerbuf]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [statsplayerbuf], eax
        mov dword [statsteambuf], eax
        mov dword [statsgoaliebuf], eax
        mov dword [statsskaterbuf], eax
        mov dword [leaguestatsmode], eax
        mov dword [statsredrawcb], eax
.2:
        mov ebx, dword [dword esp+eax*4+0300h]
        mov dword [nosplit eax*4+playofftree], ebx
        inc eax
        cmp eax, byte 1Fh
        jl short CalStandingsMenu_player2.2
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
        mov dword [calredraw], 0FFFFFFFFh
        call LoadCalendarShapes
        xor eax, eax
        add esp, 38Ch
        pop ebp
        jmp near CalTeamStatsScreen_x
%endif ; C
;-----------------------------------------------------------------------------
; DrawPhotoWithPal                             21C04  95 PC, medium confidence
; Copies 0B4h + 0A5h palette bytes into the stats palette, installs
; photoremap, draws photo shape (player photo by tag at 21FC7 / 22860)
;-----------------------------------------------------------------------------
; C: src/front/stats_screens/DrawPhotoWithPal.c
%ifdef CBUILD
%include "c/front/stats_screens/DrawPhotoWithPal.inc"
%else
DrawPhotoWithPal:
        push dword 320h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 304h
        mov esi, eax
        mov dword [dword esp+0300h], edx
        mov edi, ebx
        mov ebp, ecx
        mov edx, dword [statspalvalid]
        test edx, edx
        je short .1
        mov edx, dword [statspal]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        jmp short .2
.1:
        mov eax, esp
        push eax
        push dword 100h
        push edx
        call SetPalette
        add esp, byte 0Ch
.2:
        lea eax, [dword esp+0CCh]
        xor edx, edx
        jmp short .4
.3:
        mov bl, byte [esi]
        mov byte [eax], bl
        inc edx
        inc esi
        inc eax
.4:
        cmp edx, 0B4h
        jl short DrawPhotoWithPal.3
        lea eax, [dword esp+024Ch]
        xor edx, edx
        jmp short .6
.5:
        mov bl, byte [esi]
        mov byte [eax], bl
        inc edx
        inc esi
        inc eax
.6:
        cmp edx, 0A5h
        jl short DrawPhotoWithPal.5
        push photoremap
        call SetColorRemap
        add esp, byte 4
        mov ebx, dword [statspalvalid]
        test ebx, ebx
        je short .7
        mov eax, dword [statspal]
        mov ebx, 300h
        mov edx, esp
        call memcpy_
        jmp short .8
.7:
        mov eax, esp
        push eax
        push dword 100h
        push ebx
        call VgaSetPalette
        add esp, byte 0Ch
.8:
        push ebp
        push edi
        mov ecx, dword [dword esp+0308h]
        push ecx
        call DrawArtKeyColour
        add esp, byte 0Ch
        add esp, 304h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
