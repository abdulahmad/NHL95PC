; A few words at the start of the per-player stat lines.
bits 32
%include "hockey.inc"
section s_DB08A nobits alloc noexec write align=1
global hmplstats_w2, hmplstats_w4, hmplstats_w6, hmplstats_w8, hmplstats_w10, hmplstats_w12, hmplstats_w14
hmplstats_w2:                                   ; hmplstats+2: stats word 1 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by ChkScorerMilestone,
                                                ; InitGameSummary, PickThreeStars ...
        resb 2
hmplstats_w4:                                   ; hmplstats+4: stats word 2 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 2
hmplstats_w6:                                   ; hmplstats+6: stats word 3 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 2
hmplstats_w8:                                   ; hmplstats+8: stats word 4 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 2
hmplstats_w10:                                  ; hmplstats+10: stats word 5 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 2
hmplstats_w12:                                  ; hmplstats+12: stats word 6 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary
        resb 2
hmplstats_w14:                                  ; hmplstats+14: stats word 7 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 386
