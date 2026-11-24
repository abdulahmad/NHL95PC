; BSS of front/desk_stats (src/front/desk_stats): the module's second run in link order.
bits 32
%include "hockey.inc"
section s_DC834 nobits alloc noexec write align=1
global statsplayer, statsfilepos, lgstatsfilepos
statsplayer:                                    ; copy of picked player record; used by CalStandingsMenu,
                                                ; CalStandingsMenu_player, CalStandingsMenu_player2 ...
        resb 2
        resb 1
        resb 16
        resb 21
statsfilepos:                                   ; stats cards: file position of the record (game stats); used
                                                ; by GoalieStatsCard, SkaterStatsCard
        resb 4
lgstatsfilepos:                                 ; stats cards: file position of the record when
                                                ; statsfromleague; used by GoalieStatsCard, SkaterStatsCard
        resb 8
