; BSS of front/summary (src/front/summary): the module's second run in link order.
bits 32
%include "hockey.inc"
section s_DD710 nobits alloc noexec write align=1
global leaguedbfmt2, otherperiod, floppyok, leaguedbfmt, dbextension, othergames, othergamesb, calsel
global floppyprobe, otherscores, otherscoresb
leaguedbfmt2:                                   ; copy of leaguedbfmt used as the fallback path by
                                                ; LoadScheduleDB; used by CreatePlayoffs, ExecuteTrade,
                                                ; GameSummaryScreen ...
        resb 32
otherperiod:                                    ; 6 dwords: period / state of each other game (5 final OT, 6
                                                ; final); used by GameSummaryScreen, IntermissionDesk,
                                                ; MenuOpenSaved ...
        resb 24
floppyok:                                       ; [2] drive A / B readable (SelectFloppyDrive); used by
                                                ; FindLeagueFloppy, SelectFloppyDrive
        resb 4
        resb 4
leaguedbfmt:                                    ; league DB path format '<league>\%s.db' built by
                                                ; CreatePlayoffs; LoadScheduleDB sprintf's 'schedule' into it;
                                                ; used by CreatePlayoffs, ExecuteTrade, GameSummaryScreen ...
        resb 32
dbextension:                                    ; ".DB" or ".ORG" from AskDatabaseChoice; used by
                                                ; AskDatabaseChoice, CreateNewLeague, CreatePlayoffs
        resb 4
othergames:                                     ; 6 team pairs (byte, byte) of the other games; used by
                                                ; GameSummaryScreen, MenuOpenSaved, MenuSaveGame ...
        resb 1
othergamesb:                                    ; second team of each other-game pair (othergames+1); used by
                                                ; GameSummaryScreen, PickOtherGames, PlayRandomHighlight
        resb 11
calsel:                                         ; selected calendar day (-1 none); used by CalNextMonth,
                                                ; CalPrevMonth, CalReturn ...
        resb 4
floppyprobe:                                    ; -1 while probing floppy drives; used by FindLeagueFloppy,
                                                ; SelectFloppyDrive
        resb 4
otherscores:                                    ; 6 score pairs; used by GameSummaryScreen, MenuOpenSaved,
                                                ; MenuSaveGame ...
        resb 1
otherscoresb:                                   ; second score of each pair (otherscores+1); used by
                                                ; GameSummaryScreen, PickOtherGames, PlayRandomHighlight ...
        resb 11
