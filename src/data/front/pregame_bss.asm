; BSS of front/pregame (src/front/pregame).
bits 32
%include "hockey.inc"
section s_DC234 nobits alloc noexec write align=1
global schedgameidx, pointerspr
schedgameidx:                                   ; schedule game index of the current game (444h + playoff game
                                                ; number); set by PlayoffModeLoop and temp_files; used by
                                                ; GameSummaryScreen_period, MenuNewExhibition, PlayLeagueGame
                                                ; ...
        resb 4
pointerspr:                                     ; mouse pointer sprite, bg saved as "Pointer"; used by
                                                ; CalendarScreen, ControlsDlgExh, ControlsDlgInGame ...
        resb 6
        resb 2
