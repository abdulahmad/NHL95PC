; BSS of front/desk_stats (src/front/desk_stats).
bits 32
%include "hockey.inc"
section s_DC340 nobits alloc noexec write align=1
global statsscreenpal, statsteamorder, statsmenuresult, sfpal2, sfpal1, StatsLastSel
statsscreenpal:                                 ; stats screens: 768-byte palette read and faded to; used by
                                                ; StatsSel9394Season, StatsSelLeague, StatsSel_common
        resb 768
statsteamorder:                                 ; 26 team indices for the team picker; used by
                                                ; CalStandingsScreen, EasnStandingsScreen, GameStandingsScreen
                                                ; ...
        resb 104
statsmenuresult:                                ; StatsMenu*: the result of the screen just run; used by
                                                ; StatsMenuAssists, StatsMenuGAA, StatsMenuGoalieWins ...
        resb 4
sfpal2:                                         ; loaded "SfPal2" fade palette (StatsMenu*); used by
                                                ; StatsMenuAssists, StatsMenuGAA, StatsMenuGoalieWins ...
        resb 4
sfpal1:                                         ; loaded "SfPal1" fade palette (StatsMenu*); used by
                                                ; StatsMenuAssists, StatsMenuGAA, StatsMenuGoalieWins ...
        resb 4
StatsLastSel:                                   ; Statistics screen selection reset to -1 whenever a
                                                ; statistics source is chosen; used by
                                                ; CalStandingsMenu_player, CalStandingsMenu_player2,
                                                ; EasnStandingsMenu_player ...
        resb 4
