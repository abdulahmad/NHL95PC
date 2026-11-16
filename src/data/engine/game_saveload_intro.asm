; Per-player stat lines for the game in progress.
bits 32
%include "hockey.inc"
section s_DAC40 nobits alloc noexec write align=1
global hmplattr_b13, awplattr_b13, hmplstats_m2, hmplstats, hmglattr, awglattr, hmplattr, awplattr
hmglattr:                                       ; home goalie attribute records, 3 x 10h bytes, filled by
                                                ; LoadTeamRoster; clearteams points hmtmglattr here; used by
                                                ; LoadGameState, LoadTeamRoster, clearteams
        resb 48
awglattr:                                       ; visitor goalie attribute records (hmglattr+30h); used by
                                                ; LoadGameState, clearteams
        resb 48
hmplattr:                                       ; home skater attribute records, 25 x 14h bytes, filled by
                                                ; LoadTeamRoster; clearteams points hmtmplattr here; used by
                                                ; BuildDefaultLines, LoadGameState, LoadTeamRoster ...
        resb 19
hmplattr_b13:                                   ; hmplattr+13h: byte 13h of a skater attribute record,
                                                ; Endfaceoff indexes it [pnum*14h]; used by Endfaceoff
        resb 481
awplattr:                                       ; visitor skater attribute records (hmplattr + 25*14h); used
                                                ; by LoadGameState, clearteams
        resb 19
awplattr_b13:                                   ; awplattr+13h; used by Endfaceoff
        resb 479
hmplstats_m2:                                   ; hmplstats-2: -5r short-load base
        resb 2
hmplstats:                                      ; home skater game stats, 25 x 10h bytes (words g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); clearteams points hmtmplstats
                                                ; here; used by BuildEventLines, ChkScorerMilestone,
                                                ; InitGameSummary ...
        resb 2
