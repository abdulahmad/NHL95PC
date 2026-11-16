; The saved mouse position, the saved palette, and the home team's live struct.
bits 32
%include "hockey.inc"
section s_DF00C nobits alloc noexec write align=1
global savedmousex, savedmousey, hmtmstruct, hmpassatt, hmpasscmp
global savepal, gamepal, hmscore
savedmousex:                                    ; HandleHotKey pause saves mousex here when a pad device is
                                                ; mouse (pad1dev/pad2dev==1); in the saved game state; used by
                                                ; Gameloop, HandleHotKey, LoadGameState ...
        resb 4
savedmousey:                                    ; HandleHotKey pause saves mousey here; in the saved game
                                                ; state; used by Gameloop, HandleHotKey, LoadGameState ...
        resb 4
savepal:                                        ; 256-entry palette buffer: SetPalette(0,100h,buf) captures it
                                                ; before fades; passed to FadePalette by pause, desk,
                                                ; highlight and intermission code; used by CalendarScreen,
                                                ; DeskExitGame, DeskGameStats ...
        resb 768
gamepal:                                        ; 256-entry palette passed to FadePalette when fading the rink
                                                ; back in (GameLoop, StartHL2, replay, intro); used by
                                                ; Gameloop, InstantReplay, LoadGameState ...
        resb 766
        resb 2
hmtmstruct:                                     ; used by ChkGoalies, ChkOffsides, ChkPullGoalieLate ...
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
hmscore:                                        ; home tmscore (team+10h): PeriodOver/clockcont_0 subtract
                                                ; awscore to find a tie; used by CtlSwapScoreFix,
                                                ; DrawHudPanel, DumpStatsLog ...
        resb 2
        resb 4
        resb 12
        resb 2
        resb 2
hmpassatt:                                      ; hmtmstruct+26h word: passing attempts (stats screen
                                                ; 'Passing' %d/%d (%d%%) denominator); used by GameStatsScreen
        resb 2
hmpasscmp:                                      ; hmtmstruct+28h word: passes completed (stats screen
                                                ; 'Passing' numerator); used by GameStatsScreen
        resb 2
