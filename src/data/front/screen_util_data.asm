; Initialised data of front/screen_util (src/front/screen_util).
bits 32
%include "hockey.inc"
section s_C6718 progbits alloc noexec write align=1
extern StatsSel9394Playoffs, StatsSel9394Season, StatsSelLeague, StatsSelLeaguePlayoffs, StatsSelPlayoffMode, str_AtlanticDivision, str_CentralDivision, str_NortheastDivision
extern str_PacificDivision
global lastsprremap, mi_9394Season, str_9394Season, mi_9394Playoffs, str_9394PlayOffs, mi_LeagueSeason, str_LgSeasonTitle, mi_LeaguePlayoffs
global str_LgPlayoffsTitle, mi_PlayoffMode, str_POTitle, str_StatsSourceDivider, StatsSourceLastBottom, str_Dashes, StatsSourceMenu, StatsSourceMenuRight
global StatsSourceMenuBottom, menutext_statsleague, menuact_statsleague, menutext_statslgplayoffs, menuact_statslgplayoffs, menutext_statsplayoff, menuact_statsplayoff, str_SeasonSfx
global str_SeasonPlayOffsSfx, str_PlayOffsSfx, divisionnames
lastsprremap:                                   ; cached remap selection in DrawSprite; used by DrawSprite
        db 0FFh,0FFh,0FFh,0FFh
mi_9394Season:                                  ; "Statistics Type" menu item text (first byte 1 = selected, 2
                                                ; = not); used by MakeStatsTitle, SetupStatsSourceMenu_all,
                                                ; SetupStatsSourceMenu_exh ...
        db 01h,020h
str_9394Season:                                 ; string; used by MakeStatsTitle
        db 027h,039h,033h,020h,02Dh,020h,027h,039h,034h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 00h
mi_9394Playoffs:                                ; menu item "'93 - '94 Play-Offs"; used by MakeStatsTitle,
                                                ; SetupStatsSourceMenu_all, SetupStatsSourceMenu_exh ...
        db 02h,020h
str_9394PlayOffs:                               ; string; used by MakeStatsTitle
        db 027h,039h,033h,020h,02Dh,020h,027h,039h,034h,020h,050h,06Ch,061h,079h,02Dh,04Fh
        db 066h,066h,073h,00h
mi_LeagueSeason:                                ; menu item "<league> Season"; used by BuildSavedGameLabels,
                                                ; MakeStatsTitle, SetupStatsSourceMenu_all ...
        db 02h,020h
str_LgSeasonTitle:                              ; '"' + league name + '" Season'; used by
                                                ; BuildSavedGameLabels, MakeStatsTitle
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 00h
mi_LeaguePlayoffs:                              ; menu item "<league> Season Play-Offs"; used by
                                                ; BuildSavedGameLabels, MakeStatsTitle,
                                                ; SetupStatsSourceMenu_all ...
        db 02h,020h
str_LgPlayoffsTitle:                            ; string; used by BuildSavedGameLabels, MakeStatsTitle
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,073h,00h
mi_PlayoffMode:                                 ; menu item "<name> Play-Offs"; used by BuildSavedGameLabels,
                                                ; MakeStatsTitle, SetupStatsSourceMenu_all ...
        db 02h,020h
str_POTitle:                                    ; string; used by BuildSavedGameLabels, DrawPlayoffTree,
                                                ; MakeStatsTitle
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,050h,06Ch,061h,079h,02Dh,04Fh
        db 066h,066h,073h,00h
str_StatsSourceDivider:                         ; Dashed divider text between statistics source groups
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
StatsSourceLastBottom:                          ; Base that reaches the bottom edge of the last statistics
                                                ; source item when indexed by the item count; used by
                                                ; SetupStatsSourceMenu_all
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
str_Dashes:                                     ; string '-------'; used by SetupStatsSourceMenu_all
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,00h
StatsSourceMenu:                                ; Statistics Type pull-down: 93-94 season playoffs league and
                                                ; playoff mode sources
        db 00h,00h,00h,00h,00h,00h,00h,00h
StatsSourceMenuRight:                           ; Right edge of each statistics source item (32-byte stride);
                                                ; used by SetupStatsSourceMenu_all
        db 0F7h,00h,00h,00h
StatsSourceMenuBottom:                          ; Bottom edge of each statistics source item (32-byte stride);
                                                ; used by SetupStatsSourceMenu_all
        db 011h,00h,00h,00h
        dd mi_9394Season
        dd StatsSel9394Season
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0F7h,00h,00h,00h,023h,00h,00h,00h
        dd mi_9394Playoffs
        dd StatsSel9394Playoffs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 0F7h,00h,00h,00h,035h,00h,00h,00h
        dd str_StatsSourceDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 036h,00h,00h,00h,0F7h,00h,00h,00h,047h,00h,00h,00h
menutext_statsleague:                           ; stats source menu: text slot of the league item
                                                ; (SetupStatsSourceMenu); used by SetupStatsSourceMenu_all,
                                                ; SetupStatsSourceMenu_lg, SetupStatsSourceMenu_po
        dd mi_LeagueSeason
menuact_statsleague:                            ; stats source menu: action slot of the league item; used by
                                                ; SetupStatsSourceMenu_all, SetupStatsSourceMenu_lg,
                                                ; SetupStatsSourceMenu_po
        dd StatsSelLeague
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 0F7h,00h,00h,00h,059h,00h,00h,00h
menutext_statslgplayoffs:                       ; stats source menu: text slot of the league playoffs item;
                                                ; used by SetupStatsSourceMenu_all, SetupStatsSourceMenu_lg
        dd mi_LeaguePlayoffs
menuact_statslgplayoffs:                        ; stats source menu: action slot of the league playoffs item;
                                                ; used by SetupStatsSourceMenu_all, SetupStatsSourceMenu_lg
        dd StatsSelLeaguePlayoffs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 0F7h,00h,00h,00h,06Bh,00h,00h,00h
        dd str_StatsSourceDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 06Ch,00h,00h,00h,0F7h,00h,00h,00h,07Eh,00h,00h,00h
menutext_statsplayoff:                          ; stats source menu: text slot of the playoff mode item; used
                                                ; by SetupStatsSourceMenu_all
        dd mi_PlayoffMode
menuact_statsplayoff:                           ; stats source menu: action slot of the playoff mode item;
                                                ; used by SetupStatsSourceMenu_all
        dd StatsSelPlayoffMode
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_SeasonSfx:                                  ; string; used by BuildSavedGameLabels
        db 022h,020h,053h,065h,061h,073h,06Fh,06Eh,00h
str_SeasonPlayOffsSfx:                          ; string; used by BuildSavedGameLabels
        db 022h,020h,053h,065h,061h,073h,06Fh,06Eh,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h
        db 066h,073h,00h
str_PlayOffsSfx:                                ; string; used by BuildSavedGameLabels
        db 022h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,073h,00h,00h,00h,00h
divisionnames:                                  ; Pacific / Central / Northeast / Atlantic Division; used by
                                                ; StandingsScreen
        dd str_PacificDivision
        dd str_CentralDivision
        dd str_NortheastDivision
        dd str_AtlanticDivision
