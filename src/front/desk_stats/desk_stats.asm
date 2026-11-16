; Sports Central's statistics menu. Writing the current screen out as a text file, the desk exits,
; and one action for each team, skater and goalie category. One module (shared exits).
bits 32
%include "hockey.inc"
section s_17816 progbits alloc exec nowrite align=1
extern __CHK, deskexit, DiskSpaceShort, easnfontbuf, embscupbank, statsmenuresult, StatsLastSel, leaguestatsmode
extern exhstate, FadePalStep, fclose_, FileExists, fopen_, fputs_, FreeMemBlock, goaliestatscb
extern LeadersScreen, lgstate, MessageBox, mi_9394Playoffs, mi_9394Season, mi_LeaguePlayoffs, mi_LeagueSeason, mi_PlayoffMode
extern msg_NeedKbytes2, msg_FileExists, msg_StatsDiskSpace, postate, sfpal1, sfpal2, skaterstatscb, sprintf_
extern statscategory, statsfromleague, statsleague, statspal, statspalvalid, statsplayer, statsplayoffs, statsredrawcb
extern statsteamsel, str_NeedKbytesFmt2, str_OUT, str_rt, str_SfPal1, str_SfPal2, str_wt, strcat_
extern strcmp_, strcpy_, strncpy_, AllocMemBlock, SetPalette, teamstatscb, TeamStatsScreen, textgrid
extern btn_FileExists, msg_StatsWritten, msg_OutputFileError, statsscreenpal
global WriteScreenTextFile, DeskSetExit1, DeskSetExit2, DeskSetExit3, DeskSetExit3_body, DeskSetExit_ret1, StatsSel9394Season, StatsSel9394Playoffs
global StatsSel_common, StatsSel_x, StatsSelLeague, StatsSelLeaguePlayoffs, StatsSelPlayoffMode, StatsMenuStandings, StatsMenuTeamScoring, StatsMenuTeamDefense
global StatsMenuPenaltyKilling, StatsMenuPowerPlay, StatsMenuTeamPenalties, StatsMenuPoints, StatsMenuGoals, StatsMenuAssists, StatsMenuPPGoals, StatsMenuSHGoals
global StatsMenuPlusMinus, StatsMenuPIM, StatsMenuShootPct, StatsMenuGAA, StatsMenuGoalieWins, StatsMenuSavePct, DeskSetExit3b, ShowPlayerStatsItem
global FreeDeskBuffers
;-----------------------------------------------------------------------------
; WriteScreenTextFile                                             17816  95 PC
; (name): "Output Current Data" on the sports desk: writes the 36 text rows
; of textgrid as 100-column lines to name.OUT (fopen "wt"), checking free
; space first (FileExists / DiskSpaceShort, "require %2d Kbytes of free disk
; space." MessageBox) and asking before overwriting an existing file; reports
; the result with a MessageBox
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/WriteScreenTextFile.c
%ifdef CBUILD
%include "c/front/desk_stats/WriteScreenTextFile.inc"
%else
WriteScreenTextFile:
        push dword 0B8h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 8Ch
        cmp dword [textgrid], byte 0
        je near .x
        mov dword [byte esp+07Ch], 4
        xor ecx, ecx
        mov dword [dword esp+080h], ecx
        mov edx, eax
        lea eax, [byte esp+068h]
        call strcpy_
        mov edx, str_OUT
        lea eax, [byte esp+068h]
        call strcat_
        lea eax, [byte esp+068h]
        call FileExists
        test eax, eax
        jne short .1
        lea edx, [byte esp+07Ch]
        call DiskSpaceShort
        jmp short .2
.1:
        xor eax, eax
.2:
        test eax, eax
        je short .3
        push eax
        push str_NeedKbytesFmt2
        push msg_NeedKbytes2
        call sprintf_
        add esp, byte 0Ch
        push dword 320h
        lea eax, [dword esp+088h]
        push eax
        lea eax, [dword esp+090h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_StatsDiskSpace
        jmp near .7
.3:
        xor ah, ah
        mov byte [byte esp+065h], ah
        mov edx, str_rt
        lea eax, [byte esp+068h]
        call fopen_
        test eax, eax
        je short .4
        call fclose_
        push byte 0FFFFFFFFh
        lea eax, [dword esp+088h]
        push eax
        lea eax, [dword esp+090h]
        push eax
        push byte 2
        push btn_FileExists
        mov ecx, 2
        mov ebx, msg_FileExists
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        cmp eax, byte 1
        jne near .x
.4:
        mov edx, str_wt
        lea eax, [byte esp+068h]
        call fopen_
        mov edi, eax
        test eax, eax
        je short .6
        mov ecx, dword [textgrid]
        xor esi, esi
.5:
        mov ebx, 64h
        mov edx, ecx
        mov eax, esp
        call strncpy_
        mov byte [byte esp+064h], 0Ah
        xor dh, dh
        mov byte [byte esp+065h], dh
        mov edx, edi
        mov eax, esp
        call fputs_
        add ecx, byte 64h
        inc esi
        cmp esi, byte 24h
        jl short WriteScreenTextFile.5
        mov eax, edi
        call fclose_
        push byte 0FFFFFFFFh
        lea eax, [dword esp+088h]
        push eax
        lea eax, [dword esp+090h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msg_StatsWritten
        jmp short .7
.6:
        push byte 0FFFFFFFFh
        lea eax, [dword esp+088h]
        push eax
        lea eax, [dword esp+090h]
        push eax
        push edi
        push edi
        mov ecx, 1
        mov ebx, msg_OutputFileError
.7:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.x:
        add esp, 8Ch
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeskSetExit1                                                    179B6  95 PC
; Menu action: deskexit = 1, return 1 (the "Sports Desk" item of the sports
; desk menus)
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/DeskSetExit1.c
%ifdef CBUILD
%include "c/front/desk_stats/DeskSetExit1.inc"
%else
DeskSetExit1:
        push dword 8
        call __CHK
        push edx
        mov edx, 1
        mov dword [deskexit], edx
        mov eax, edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeskSetExit2                                                    179D0  95 PC
; Menu action: deskexit = 2, return 1
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/DeskSetExit2.c
%ifdef CBUILD
%include "c/front/desk_stats/DeskSetExit2.inc"
%else
DeskSetExit2:
        push dword 4
        call __CHK
        mov dword [deskexit], 2
        jmp short DeskSetExit_ret1
%endif ; C
;-----------------------------------------------------------------------------
; DeskSetExit3                                                    179E6  95 PC
; Menu action: deskexit = 3, return 1 (palette_fx also jumps into its body)
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/DeskSetExit2.c (DeskSetExit3)
%ifdef CBUILD
%include "c/front/desk_stats/DeskSetExit2.DeskSetExit3.inc"
%else
DeskSetExit3:
        push dword 4
DeskSetExit3_body:
        call __CHK
        mov dword [deskexit], 3
DeskSetExit_ret1:
        mov eax, 1
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsSel9394Season                                              17A00  95 PC
; "Statistics Type" menu item "'93 - '94 Season": marks it (byte 1, the
; others 2), statsfromleague = 0, statsplayoffs = 0, copies the league name
; (exhstate+4) to statsleague and redraws the stats screen through the
; statsredrawcb callback with a fade
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsSel9394Season.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Season.inc"
%else
StatsSel9394Season:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push ebp
        cmp dword [statsfromleague], byte 0
        jne short .1
        cmp dword [statsplayoffs], byte 0
        je near .x
.1:
        mov byte [mi_9394Season], 1
        mov dl, 2
        mov byte [mi_PlayoffMode], dl
        mov byte [mi_LeaguePlayoffs], dl
        mov byte [mi_LeagueSeason], dl
        mov byte [mi_9394Playoffs], dl
        xor ecx, ecx
        mov dword [statsfromleague], ecx
        cmp dword [statsplayoffs], byte 0
        je short .2
        mov dword [statsteamsel], ecx
.2:
        xor ebp, ebp
        mov dword [statsplayoffs], ebp
        mov ebx, 1Fh
        mov edx, exhstate+4
        mov eax, statsleague
        call strncpy_
        cmp dword [leaguestatsmode], byte 0
        je short .x
        push statsscreenpal
        push dword 100h
        push ebp
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, statsscreenpal
        mov eax, 1
        call FadePalStep
        mov dword [statspalvalid], 1
        mov dword [statspal], statsscreenpal
        mov dword [StatsLastSel], 0FFFFFFFFh
        mov eax, dword [statscategory]
        call dword [statsredrawcb]
        mov dword [statspalvalid], ebp
        mov dword [statspal], ebp
        mov ebx, 10h
        mov edx, statsscreenpal
        xor eax, eax
        call FadePalStep
.x:
        pop ebp
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsSel9394Playoffs                                            17AF3  95 PC
; "'93 - '94 Play-Offs" item: statsfromleague = 0, statsplayoffs = 1,
; exhstate+4 name, redraw
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsSel9394Playoffs.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.inc"
%else
StatsSel9394Playoffs:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        cmp dword [statsfromleague], byte 0
        jne short .1
        cmp dword [statsplayoffs], byte 1
        je near StatsSel_x
.1:
        mov byte [mi_9394Playoffs], 1
        mov dl, 2
        mov byte [mi_PlayoffMode], dl
        mov byte [mi_LeaguePlayoffs], dl
        mov byte [mi_LeagueSeason], dl
        mov byte [mi_9394Season], dl
        xor ecx, ecx
        mov dword [statsfromleague], ecx
        cmp dword [statsplayoffs], byte 0
        jne short .2
        mov dword [statsteamsel], ecx
.2:
        mov ebp, 1
        mov dword [statsplayoffs], ebp
        mov ebx, 1Fh
        mov edx, exhstate+4
StatsSel_common:
        mov eax, statsleague
        call strncpy_
        cmp dword [leaguestatsmode], byte 0
        je short StatsSel_x
        push statsscreenpal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, statsscreenpal
        mov eax, ebp
        call FadePalStep
        mov dword [statspalvalid], ebp
        mov dword [statspal], statsscreenpal
        mov dword [StatsLastSel], 0FFFFFFFFh
        mov eax, dword [statscategory]
        call dword [statsredrawcb]
        xor esi, esi
        mov dword [statspalvalid], esi
        mov dword [statspal], esi
        mov ebx, 10h
        mov edx, statsscreenpal
        xor eax, eax
        call FadePalStep
StatsSel_x:
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsSelLeague                                                  17BE7  95 PC
; "<league> Season" item: statsfromleague = 1, statsplayoffs = 0, league name
; from lgstate+4, redraw
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsSel9394Playoffs.c (StatsSelLeague)
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.StatsSelLeague.inc"
%else
StatsSelLeague:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        push ebp
        cmp dword [statsfromleague], byte 1
        jne short .1
        cmp dword [statsplayoffs], byte 0
        je near .x
.1:
        mov byte [mi_LeagueSeason], 1
        mov dl, 2
        mov byte [mi_PlayoffMode], dl
        mov byte [mi_LeaguePlayoffs], dl
        mov byte [mi_9394Playoffs], dl
        mov byte [mi_9394Season], dl
        mov dword [statsfromleague], 1
        cmp dword [statsplayoffs], byte 0
        je short .2
        xor edi, edi
        mov dword [statsteamsel], edi
.2:
        xor ebp, ebp
        mov dword [statsplayoffs], ebp
        mov ebx, 1Fh
        mov edx, lgstate+4
        mov eax, statsleague
        call strncpy_
        cmp dword [leaguestatsmode], byte 0
        je short .x
        push statsscreenpal
        push dword 100h
        push ebp
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, statsscreenpal
        mov eax, 1
        call FadePalStep
        mov dword [statspalvalid], 1
        mov dword [statspal], statsscreenpal
        mov dword [StatsLastSel], 0FFFFFFFFh
        mov eax, dword [statscategory]
        call dword [statsredrawcb]
        mov dword [statspalvalid], ebp
        mov dword [statspal], ebp
        mov ebx, 10h
        mov edx, statsscreenpal
        xor eax, eax
        call FadePalStep
.x:
        pop ebp
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsSelLeaguePlayoffs                                          17CE0  95 PC
; "<league> Season Play-Offs" item: statsfromleague = 1, statsplayoffs = 1,
; lgstate+4 name (skipped when already selected), redraw
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsSel9394Playoffs.c (StatsSelLeaguePlayoffs)
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.StatsSelLeaguePlayoffs.inc"
%else
StatsSelLeaguePlayoffs:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov edx, dword [statsfromleague]
        cmp edx, byte 1
        jne short .1
        cmp edx, dword [statsplayoffs]
        jne short .1
        mov edx, lgstate+4
        mov eax, statsleague
        call strcmp_
        test eax, eax
        je near StatsSel_x
.1:
        mov byte [mi_LeaguePlayoffs], 1
        mov dl, 2
        mov byte [mi_PlayoffMode], dl
        mov byte [mi_LeagueSeason], dl
        mov byte [mi_9394Playoffs], dl
        mov byte [mi_9394Season], dl
        mov dword [statsfromleague], 1
        mov esi, dword [statsplayoffs]
        test esi, esi
        jne short .2
        mov dword [statsteamsel], esi
.2:
        mov ebp, 1
        mov dword [statsplayoffs], ebp
        mov ebx, 1Fh
        mov edx, lgstate+4
        jmp near StatsSel_common
%endif ; C
;-----------------------------------------------------------------------------
; StatsSelPlayoffMode                                             17D6E  95 PC
; "<name> Play-Offs" item (stand-alone Play-Off mode): statsfromleague = 1,
; statsplayoffs = 1, name from postate+4, redraw
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsSel9394Playoffs.c (StatsSelPlayoffMode)
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.StatsSelPlayoffMode.inc"
%else
StatsSelPlayoffMode:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov edx, dword [statsfromleague]
        cmp edx, byte 1
        jne short .1
        cmp edx, dword [statsplayoffs]
        jne short .1
        mov edx, postate+4
        mov eax, statsleague
        call strcmp_
        test eax, eax
        je near StatsSel_x
.1:
        mov byte [mi_PlayoffMode], 1
        mov dl, 2
        mov byte [mi_LeaguePlayoffs], dl
        mov byte [mi_LeagueSeason], dl
        mov byte [mi_9394Playoffs], dl
        mov byte [mi_9394Season], dl
        mov dword [statsfromleague], 1
        mov esi, dword [statsplayoffs]
        test esi, esi
        jne short .2
        mov dword [statsteamsel], esi
.2:
        mov ebp, 1
        mov dword [statsplayoffs], ebp
        mov ebx, 1Fh
        mov edx, postate+4
        jmp near StatsSel_common
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuStandings                                              17DFC  95 PC
; Menu action for the "Standings ..." stats item: statscategory = 5; on first
; entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes into the
; team stats screen (TeamStatsScreen), else redraws through teamstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuStandings.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuStandings.inc"
%else
StatsMenuStandings:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 5
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 5
        call TeamStatsScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [teamstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuTeamScoring                                            17EDF  95 PC
; Menu action for the "Scoring ..." stats item: statscategory = 0; on first
; entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes into the
; team stats screen (TeamStatsScreen), else redraws through teamstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuTeamScoring.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuTeamScoring.inc"
%else
StatsMenuTeamScoring:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        xor edx, edx
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        call TeamStatsScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        xor eax, eax
        call dword [teamstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuTeamDefense                                            17FBC  95 PC
; Menu action for the "Defense ..." stats item: statscategory = 1; on first
; entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes into the
; team stats screen (TeamStatsScreen), else redraws through teamstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuTeamDefense.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuTeamDefense.inc"
%else
StatsMenuTeamDefense:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 1
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 1
        call TeamStatsScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [teamstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuPenaltyKilling                                         1809F  95 PC
; Menu action for the "Penalty Killing ..." stats item: statscategory = 2; on
; first entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes
; into the team stats screen (TeamStatsScreen), else redraws through
; teamstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuPenaltyKilling.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPenaltyKilling.inc"
%else
StatsMenuPenaltyKilling:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 2
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 2
        call TeamStatsScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [teamstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuPowerPlay                                              18182  95 PC
; Menu action for the "Power Play ..." stats item: statscategory = 3; on
; first entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes
; into the team stats screen (TeamStatsScreen), else redraws through
; teamstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuPowerPlay.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPowerPlay.inc"
%else
StatsMenuPowerPlay:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 3
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 3
        call TeamStatsScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [teamstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuTeamPenalties                                          18265  95 PC
; Menu action for the "Penalties ..." stats item: statscategory = 4; on first
; entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes into the
; team stats screen (TeamStatsScreen), else redraws through teamstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuTeamPenalties.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuTeamPenalties.inc"
%else
StatsMenuTeamPenalties:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 4
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 4
        call TeamStatsScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [teamstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuPoints                                                 18348  95 PC
; Menu action for the "Points ..." stats item: statscategory = 0; on first
; entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes into the
; skater stats screen (LeadersScreen), else redraws through skaterstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuPoints.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPoints.inc"
%else
StatsMenuPoints:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        xor edx, edx
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        xor eax, eax
        call dword [skaterstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuGoals                                                  18425  95 PC
; Menu action for the "Goals ..." stats item: statscategory = 1; on first
; entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes into the
; skater stats screen (LeadersScreen), else redraws through skaterstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuGoals.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuGoals.inc"
%else
StatsMenuGoals:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 1
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 1
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [skaterstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuAssists                                                18508  95 PC
; Menu action for the "Assists ..." stats item: statscategory = 2; on first
; entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes into the
; skater stats screen (LeadersScreen), else redraws through skaterstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuAssists.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuAssists.inc"
%else
StatsMenuAssists:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 2
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 2
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [skaterstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuPPGoals                                                185EB  95 PC
; Menu action for the "Power Play Goals ..." stats item: statscategory = 3;
; on first entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes
; into the skater stats screen (LeadersScreen), else redraws through
; skaterstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuPPGoals.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPPGoals.inc"
%else
StatsMenuPPGoals:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 3
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 3
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [skaterstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuSHGoals                                                186CE  95 PC
; Menu action for the "Shorthanded Goals ..." stats item: statscategory = 4;
; on first entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes
; into the skater stats screen (LeadersScreen), else redraws through
; skaterstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuSHGoals.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuSHGoals.inc"
%else
StatsMenuSHGoals:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 4
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 4
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [skaterstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuPlusMinus                                              187B1  95 PC
; Menu action for the "Plus/Minus ..." stats item: statscategory = 5; on
; first entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes
; into the skater stats screen (LeadersScreen), else redraws through
; skaterstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuPlusMinus.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPlusMinus.inc"
%else
StatsMenuPlusMinus:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 5
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 5
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [skaterstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuPIM                                                    18894  95 PC
; Menu action for the "Penalty Minutes ..." stats item: statscategory = 6; on
; first entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes
; into the skater stats screen (LeadersScreen), else redraws through
; skaterstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuPIM.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPIM.inc"
%else
StatsMenuPIM:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 6
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 6
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [skaterstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuShootPct                                               18977  95 PC
; Menu action for the "Shooting Percentage ..." stats item: statscategory =
; 7; on first entry (leaguestatsmode) fades through the SfPal1 / SfPal2
; palettes into the skater stats screen (LeadersScreen), else redraws through
; skaterstatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuShootPct.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuShootPct.inc"
%else
StatsMenuShootPct:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 7
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 7
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [skaterstatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuGAA                                                    18A5A  95 PC
; Menu action for the "Goals Against Average ..." stats item: statscategory =
; 8; on first entry (leaguestatsmode) fades through the SfPal1 / SfPal2
; palettes into the goalie stats screen (LeadersScreen), else redraws through
; goaliestatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuGAA.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuGAA.inc"
%else
StatsMenuGAA:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 8
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 8
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [goaliestatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuGoalieWins                                             18B3D  95 PC
; Menu action for the "Wins ..." stats item: statscategory = 9; on first
; entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes into the
; goalie stats screen (LeadersScreen), else redraws through goaliestatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuGoalieWins.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuGoalieWins.inc"
%else
StatsMenuGoalieWins:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 9
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 9
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [goaliestatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StatsMenuSavePct                                                18C20  95 PC
; Menu action for the "Save Percentage ..." stats item: statscategory = 10;
; on first entry (leaguestatsmode) fades through the SfPal1 / SfPal2 palettes
; into the goalie stats screen (LeadersScreen), else redraws through
; goaliestatscb
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsMenuSavePct.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuSavePct.inc"
%else
StatsMenuSavePct:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, 0Ah
        mov dword [statscategory], edx
        cmp dword [leaguestatsmode], byte 0
        je near .1
        push byte 20h
        push dword 300h
        push str_SfPal1
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal1], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        push byte 20h
        push dword 300h
        push str_SfPal2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sfpal2], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov edx, dword [sfpal1]
        mov ebx, 10h
        mov eax, 1
        call FadePalStep
        mov ecx, dword [sfpal1]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 0Ah
        call LeadersScreen
        mov dword [statsmenuresult], eax
        mov edx, dword [sfpal2]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov esi, dword [sfpal2]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [statsmenuresult]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, edx
        call dword [goaliestatscb]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeskSetExit3b                                                   18D03  95 PC
; Second entry to the DeskSetExit3 body (deskexit = 3, return 1), used by a
; sports desk menu item
;-----------------------------------------------------------------------------
DeskSetExit3b:
        push dword 4
        jmp near DeskSetExit3_body
;-----------------------------------------------------------------------------
; ShowPlayerStatsItem                          18D0D  95 PC, medium confidence
; "Show Player Statistics And Attributes" menu action: deskexit = 4, or 5
; when byte_DC836 is not 'G'; returns 1 via DeskSetExit_ret1
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/ShowPlayerStatsItem.c
%ifdef CBUILD
%include "c/front/desk_stats/ShowPlayerStatsItem.inc"
%else
ShowPlayerStatsItem:
        push dword 4
        call __CHK
        cmp byte [statsplayer+2], 47h
        setne al
        and eax, 0FFh
        add eax, byte 4
        mov dword [deskexit], eax
        jmp near DeskSetExit_ret1
%endif ; C
;-----------------------------------------------------------------------------
; FreeDeskBuffers                              18D33  95 PC, medium confidence
; Releases the two buffers in embscupbank / easnfontbuf (jctime) and clears
; them; returns 0 (easn_stats)
;-----------------------------------------------------------------------------
; C: src/front/desk_stats/StatsSel9394Playoffs.c (FreeDeskBuffers)
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.FreeDeskBuffers.inc"
%else
FreeDeskBuffers:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov edx, dword [embscupbank]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [embscupbank], ecx
.1:
        mov esi, dword [easnfontbuf]
        test esi, esi
        je short .2
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ebp, ebp
        mov dword [easnfontbuf], ebp
.2:
        xor eax, eax
        jmp near StatsSel_x
%endif ; C
