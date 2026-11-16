; The home roster, and the jersey numbers that go with it.
bits 32
%include "hockey.inc"
section s_DB218 nobits alloc noexec write align=1
global hmroster, hmrosterjersey, hmrosterpos, awplstats
awplstats:                                      ; visitor skater game stats (hmplstats+190h); clearteams
                                                ; points awtmplstats here; used by LoadGameState, clearteams
        resb 400
hmroster:                                       ; home roster records, 27h bytes per player (byte 0 = status:
                                                ; 3 bench, 4 on ice, 7 penalty over); clearteams stores it in
                                                ; hmtmstruct+tmroster; used by BuildDefaultLines,
                                                ; BuildEventLines, CanFillLineSlot ...
        resb 5
hmrosterjersey:                                 ; hmroster entry (27h bytes) +5 jersey; used by
                                                ; BuildEventLines, GameLineEditorLoop, LoadTeamRoster ...
        resb 1
hmrosterpos:                                    ; hmroster entry (27h bytes) +6: the position letter (D, C, L,
                                                ; R, G), as hmrosterjersey is +5; used by CanFillLineSlot,
                                                ; FillDressedSlots, LoadTeamRoster ...
        resb 1086
