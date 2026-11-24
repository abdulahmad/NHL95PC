; BSS of engine/intro (src/engine/intro).
bits 32
%include "hockey.inc"
section s_DC240 nobits alloc noexec write align=1
global hmglstats, hmglstats_w2, hmglstats_w4, hmglstats_w8, hmglstats_w14
hmglstats:                                      ; home goalie game stats, 3 x 6 bytes (words min, sht, sav);
                                                ; clearteams points hmtmglstats here; used by InitGameSummary,
                                                ; LoadGameState, PostGameToTeamDb ...
        resb 2
hmglstats_w2:                                   ; hmglstats+2: shots word; used by InitGameSummary,
                                                ; PickThreeStars, PostGameToTeamDb
        resb 2
hmglstats_w4:                                   ; hmglstats+4: saves word; used by InitGameSummary,
                                                ; PickThreeStars, PostGameToTeamDb
        resb 4
hmglstats_w8:                                   ; hmglstats+8; used by PickThreeStars
        resb 6
hmglstats_w14:                                  ; hmglstats+0Eh; used by PickThreeStars
        resb 4
