; BSS of front/team_stats (src/front/team_stats).
bits 32
%include "hockey.inc"
section s_DD100 nobits alloc noexec write align=1
global statspalshape, statsbgshapes, statsteamrecs
statspalshape:                                  ; "!pal" shape from embpal; used by CalGoalieStatsScreen,
                                                ; CalSkaterStatsScreen, CalStandingsMenu ...
        resb 4
statsbgshapes:                                  ; embpal shape file handle; used by CalGoalieStatsScreen,
                                                ; CalSkaterStatsScreen, CalStandingsMenu ...
        resb 4
statsteamrecs:                                  ; "teams" buffer, 4Ch-byte team stat records; used by
                                                ; CmpTeamDefense, CmpTeamPK, CmpTeamPP ...
        resb 4
