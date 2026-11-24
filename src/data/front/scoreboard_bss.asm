; BSS of front/scoreboard (src/front/scoreboard).
bits 32
%include "hockey.inc"
section s_DC26C nobits alloc noexec write align=1
global linesprites, hudhundstep, penaltydigits, PenaltyBlankDigit, hmpanelspr, awpanelspr, scoredigits, scrbrdshapes
global hmlineind, awlineind, clockdigits, clockcolon, cupseries
linesprites:                                    ; line indicator shapes (DrawPanelLine); used by DrawHudPanel,
                                                ; DrawPanelLine, LoadScoreboardGfx
        resb 32
hudhundstep:                                    ; used by Gameloop, LoadGameState, StartHL2 ...
        resb 4
penaltydigits:                                  ; digit sprites "2000".."2009"; indexed in DrawPanelPenalties;
                                                ; used by DrawPanelPenalties, LoadScoreboardGfx
        resb 40
PenaltyBlankDigit:                              ; Shape drawn in place of the tens digit when a penalty time
                                                ; is under ten; used by DrawPanelPenalties
        resb 4
hmpanelspr:                                     ; "homp" sprite; used by LoadScoreboardGfx, UpdateHudPanel
        resb 4
awpanelspr:                                     ; "visp" sprite; used by LoadScoreboardGfx, UpdateHudPanel
        resb 4
scoredigits:                                    ; 10 digit shapes for the panel score (DrawPanelScore); used
                                                ; by DrawPanelScore, LoadScoreboardGfx
        resb 44
scrbrdshapes:                                   ; handle returned by OpenArtArchiveErr for scrbrd1.PPV; used
                                                ; by FreeGameMemory, LoadScoreboardGfx, PlayHilight
        resb 4
hmlineind:                                      ; hlin/hpp/hpk sprites; used by LoadScoreboardGfx,
                                                ; UpdateHudPanel
        resb 12
awlineind:                                      ; vlin/vpp/vpk sprites, used by UpdateHudPanel
        resb 12
clockdigits:                                    ; 10 digit shapes for the panel clock (DrawPanelClock,
                                                ; DrawPanelClockDigits); used by DrawPanelClock,
                                                ; DrawPanelClockDigits, LoadScoreboardGfx
        resb 40
clockcolon:                                     ; clock separator shape (DrawPanelClock); used by
                                                ; DrawPanelClock, DrawPanelClockDigits
        resb 4
cupseries:                                      ; "Stanley" copy of the 7 Stanley Cup final games during a
                                                ; final game, else 0 (LoadCupFinalSeries, IsCupClinched); used
                                                ; by FreeGameMemory, IsCupClinched, LoadCupFinalSeries
        resb 4
