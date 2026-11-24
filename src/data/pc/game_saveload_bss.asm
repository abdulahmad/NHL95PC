; BSS of pc/game_saveload (src/pc/game_saveload).
bits 32
%include "hockey.inc"
section s_DC252 nobits alloc noexec write align=1
global awglstats, UnusedStateFlag, UnusedStateMode, UnusedStateSpare, GameRecordDay, GameRecordMonth
awglstats:                                      ; visitor goalie game stats (hmglstats+12h); clearteams points
                                                ; awtmglstats here; used by LoadGameState, clearteams
        resb 18
UnusedStateFlag:                                ; Byte only saved and restored with the game state; used by
                                                ; LoadGameState, SaveGameState
        resb 1
UnusedStateMode:                                ; Byte only saved and restored with the game state; used by
                                                ; LoadGameState, SaveGameState
        resb 1
UnusedStateSpare:                               ; Byte only saved and restored with the game state; used by
                                                ; LoadGameState, SaveGameState
        resb 1
GameRecordDay:                                  ; Second byte of the current game record (schedule byte 1);
                                                ; InitGameSummary stores it and LoadTeamRoster compares injury
                                                ; days against it; used by InitGameSummary, LoadGameState,
                                                ; LoadTeamRoster ...
        resb 1
GameRecordMonth:                                ; Saved and restored with the game state; otherwise unused;
                                                ; used by InitGameSummary, LoadGameState, LoadTeamRoster ...
        resb 4
