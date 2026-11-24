; Initialised data of front/playoff (src/front/playoff).
bits 32
%include "hockey.inc"
section s_C6D26 progbits alloc noexec write align=1
global PoStandingsMode, treecolslots, treecol_Wr2, treecol_Wr3, treecol_Er3, treecol_Er2, treecol_Er1, potreeseeds
global treecolx, treerowy, divx, divy, str_AwayLines, str_Play, str_Cancel, str_HomeLines
PoStandingsMode:                                ; Set while the standings and tree screens show playoff mode
                                                ; data; used by CalStandingsMenu, CalStandingsMenu_player2,
                                                ; CalStandingsMenu_standings ...
        db 00h,00h,00h,00h,00h,02h,04h,06h,08h,0Ah,0Ch,0Eh,01h,05h,09h,0Dh
        db 0FFh,0FFh,0FFh,0FFh,03h,0Bh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07h,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,07h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07h,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,03h,0Bh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,01h,05h,09h,0Dh
        db 0FFh,0FFh,0FFh,0FFh,00h,02h,04h,06h,08h,0Ah,0Ch,0Eh
treecolslots:                                   ; 9 columns x 8 playofftree slot indices (FFh = none): W r1, W
                                                ; r2, W final, W champ, Cup, E champ, E final, E r2, E r1;
                                                ; used by DrawPlayoffTree, HighlightTreeSlot,
                                                ; PlayoffTreeScreen ...
        db 00h
        db 01h,02h,03h,04h,05h,06h,07h
treecol_Wr2:                                    ; treecolslots row 1 (West round 2), own name because of
                                                ; nosplit indexing; used by DrawPlayoffTree,
                                                ; HighlightTreeSlot, PlayoffTreeScreen ...
        db 010h
        db 011h
        db 012h
        db 013h,0FFh,0FFh,0FFh,0FFh
treecol_Wr3:                                    ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 018h
        db 019h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 01Ch,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 01Eh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 01Dh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
treecol_Er3:                                    ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 01Ah
        db 01Bh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
treecol_Er2:                                    ; treecolslots row 7 (East round 2); used by DrawPlayoffTree,
                                                ; HighlightTreeSlot, PlayoffTreeScreen ...
        db 014h
        db 015h
        db 016h
        db 017h,0FFh,0FFh,0FFh,0FFh
treecol_Er1:                                    ; treecolslots row 8 (East round 1); used by DrawPlayoffTree,
                                                ; HighlightTreeSlot, PlayoffTreeScreen ...
        db 08h
        db 09h,0Ah,0Bh,0Ch,0Dh,0Eh,0Fh
potreeseeds:                                    ; DrawPlayoffTree: seed numbers of the first-round teams; used
                                                ; by DrawPlayoffTree, PlayoffTreeScreen
        db 01h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h,04h,00h,00h,00h
        db 05h,00h,00h,00h,06h,00h,00h,00h,07h,00h,00h,00h,08h,00h,00h,00h
        db 09h,00h,00h,00h,0Ah,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h
        db 0Dh,00h,00h,00h,0Eh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h
        db 011h,00h,00h,00h,012h,00h,00h,00h,013h,00h,00h,00h,014h,00h,00h,00h
        db 015h,00h,00h,00h,016h,00h,00h,00h,017h,00h,00h,00h,018h,00h,00h,00h
        db 019h,00h,00h,00h,01Ah,00h
        db 00h,00h
treecolx:                                       ; column x (dword per column pair); used by DrawPlayoffTree,
                                                ; HighlightTreeSlot, PlayoffTreeScreen ...
        db 014h,00h,00h,00h,0B7h,00h,00h,00h,05Ch,01h,00h,00h,0FEh,01h,00h,00h
treerowy:                                       ; tree y bases; used by HighlightTreeSlot, TeamFromMouse
        db 030h,00h,00h,00h,0DCh,00h,00h,00h
divx:                                           ; division block x; used by StandingsScreen
        db 0Ah,00h,00h,00h,0Ah,00h,00h,00h,04Ah,01h,00h,00h,04Ah,01h,00h,00h
divy:                                           ; division block y; used by StandingsScreen
        db 07Dh,00h,00h,00h,022h,01h,00h,00h,07Dh,00h,00h,00h,022h,01h,00h,00h
        db 00h,00h
str_AwayLines:                                  ; string
        db 041h,077h,061h,079h,020h,06Ch,069h,06Eh,065h,073h,00h
str_Play:                                       ; string
        db 050h,06Ch,061h,079h,00h
str_Cancel:                                     ; string
        db 043h,061h,06Eh,063h,065h,06Ch,00h
str_HomeLines:                                  ; string
        db 048h,06Fh,06Dh,065h,020h,06Ch,069h,06Eh,065h,073h,00h
