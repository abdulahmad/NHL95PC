; Initialised data of front/scoreboard (src/front/scoreboard).
bits 32
%include "hockey.inc"
section s_C5679 progbits alloc noexec write align=1
extern str_300, str_3000, str_3001, str_3002, str_3003, str_3004, str_3005, str_3006
extern str_3007, str_3008, str_3009, str_ANA3, str_ASE, str_ASW, str_BOS, str_BUF3
extern str_CGY, str_CHI, str_DAL, str_DET, str_EDM, str_FLA, str_HFD, str_InsufficientDiskSpace3
extern str_LA, str_MTL, str_NJ, str_NYI, str_NYR, str_OT2, str_OTT, str_PHI
extern str_PIT, str_QUE, str_SJ, str_STL, str_TB, str_TOR, str_VAN, str_WPG
extern str_WSH
global msg_NeedKbytes, str_OfFreeDiskSpace, msg_GameDiskSpace, awlineenergies, hmlineenergies, hudclockmin, hudclocksec, hudclockhund
global panelprevmin, panelprevsec, panelprevhund, hudpenhome, hmpanelpen_time, hmpanelpen_w4, hmpanelpen_w6, hudpenaway
global awpanelpen_time, awpanelpen_w4, awpanelpen_w6, perioddigits, hudotname, crestnames, panelhund, deferpending
global hmpanellines, awpanellines, hudhomeline, hudawayline, hmpanelpens, awpanelpens, hmlinetimer, awlinetimer
global demomatchups_m1, demomatchups, demoteammode
msg_NeedKbytes:                                 ; message text (sprintf target) for the CheckGameDiskSpace
                                                ; MessageBox; used by CheckGameDiskSpace
        db 070h,06Ch,061h,079h,020h,074h,068h,065h,020h,067h,061h,06Dh,065h,02Ch,020h,079h
        db 06Fh,075h,020h,072h,065h,071h,075h,069h,072h,065h,020h,058h,058h,020h,04Bh,062h
        db 079h,074h,065h,073h,020h,020h,020h,00h
str_OfFreeDiskSpace:                            ; "of free disk space." string literal
        db 06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h
        db 063h,065h,02Eh,00h
msg_GameDiskSpace:                              ; CheckGameDiskSpace message lines 'Insufficient disk space' ;
                                                ; used by CheckGameDiskSpace
        dd str_InsufficientDiskSpace3
        dd msg_NeedKbytes
        dd str_OfFreeDiskSpace
        db 00h,00h,00h
awlineenergies:                                 ; UpdateHudPanel: GetLineEnergies(1) results, drawn by
                                                ; awlineind / hudawayline; used by UpdateHudPanel
        db 0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h
        db 0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h
hmlineenergies:                                 ; UpdateHudPanel: GetLineEnergies(0) results, drawn by
                                                ; hmlineind / hudhomeline; used by UpdateHudPanel
        db 0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h
        db 0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h
hudclockmin:                                    ; panel clock minutes (DrawHudPanel, TickPanelClock); used by
                                                ; DrawHudPanel, DrawPanelClock, DrawPanelClockDigits ...
        db 05h,00h,00h,00h
hudclocksec:                                    ; panel clock seconds; used by DrawHudPanel, DrawPanelClock,
                                                ; DrawPanelClockDigits ...
        db 00h,00h,00h,00h
hudclockhund:                                   ; panel clock hundredths; used by DrawHudPanel,
                                                ; DrawPanelClock, DrawPanelClockDigits ...
        db 00h,00h,00h,00h
panelprevmin:                                   ; scoreboard panel clock: minutes drawn last frame
                                                ; (DrawPanelClockDigits redraws changed digits only); used by
                                                ; DrawPanelClock, DrawPanelClockDigits, TickPanelClock
        db 063h,00h,00h,00h
panelprevsec:                                   ; scoreboard panel clock: seconds drawn last frame; used by
                                                ; DrawPanelClock, DrawPanelClockDigits, TickPanelClock
        db 063h,00h,00h,00h
panelprevhund:                                  ; scoreboard panel clock: hundredths drawn last frame; used by
                                                ; DrawPanelClock, DrawPanelClockDigits, TickPanelClock
        db 063h,00h,00h,00h
hudpenhome:                                     ; 8 penalty entries of 8 bytes (player, time, ...; -1 free)
                                                ; shown on the left of the panel (PanelAddPenalty /
                                                ; PanelRemovePenalty / UpdateHudPanel); used by
                                                ; ClearPanelPenalties, LoadGameState, PanelAddPenalty ...
        db 0FFh,0FFh
hmpanelpen_time:                                ; home penalty panel list, 8 entries of 4 words (player, time,
                                                ; 2 spare): the time word; used by ClearPanelPenalties
        db 00h,00h
hmpanelpen_w4:                                  ; home penalty panel entry +4; used by ClearPanelPenalties
        db 00h,00h
hmpanelpen_w6:                                  ; home penalty panel entry +6; used by ClearPanelPenalties
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h
hudpenaway:                                     ; 8 penalty entries of 8 bytes for the right side of the
                                                ; panel; used by ClearPanelPenalties, LoadGameState,
                                                ; PanelAddPenalty ...
        db 0FFh,0FFh
awpanelpen_time:                                ; visitor penalty panel list: the time word; used by
                                                ; ClearPanelPenalties
        db 00h,00h
awpanelpen_w4:                                  ; visitor penalty panel entry +4; used by ClearPanelPenalties
        db 00h,00h
awpanelpen_w6:                                  ; visitor penalty panel entry +6; used by ClearPanelPenalties
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h
perioddigits:                                   ; names of the period number shapes in scrbrd2.PPV
                                                ; ("3000".."3009") (DrawHudPanel); used by DrawHudPanel
        dd str_3000
        dd str_3001
        dd str_3002
        dd str_3003
        dd str_3004
        dd str_3005
        dd str_3006
        dd str_3007
        dd str_3008
        dd str_3009
        dd str_300
hudotname:                                      ; DrawHudPanel: name of the 'OT' shape; used by DrawHudPanel
        dd str_OT2
crestnames:                                     ; crest shape names in crests4.PPV, one per team ("BOS ", "BUF
                                                ; " ...) (DrawHudPanel); used by CalendarScreen,
                                                ; DrawCalendarDay, DrawHudPanel ...
        dd str_BOS
        dd str_BUF3
        dd str_CGY
        dd str_CHI
        dd str_DET
        dd str_EDM
        dd str_HFD
        dd str_LA
        dd str_DAL
        dd str_MTL
        dd str_NJ
        dd str_NYI
        dd str_NYR
        dd str_OTT
        dd str_PHI
        dd str_PIT
        dd str_QUE
        dd str_STL
        dd str_SJ
        dd str_TB
        dd str_TOR
        dd str_VAN
        dd str_WSH
        dd str_WPG
        dd str_ANA3
        dd str_FLA
        dd str_ASW
        dd str_ASE
panelhund:                                      ; hundredths elapsed since the last panel update
                                                ; (UpdateHudPanel passes it to TickPanelClock); used by
                                                ; DrawHudPanel, UpdateHudPanel
        db 00h,00h,00h,00h
deferpending:                                   ; set by ChkScorerMilestone after QueueDeferredCall; GameLoop
                                                ; then runs RunDeferredCalls and clears it; also stops the
                                                ; frame loop; used by ChkScorerMilestone, Gameloop,
                                                ; LoadGameState ...
        db 00h,00h,00h,00h
hmpanellines:                                   ; UpdateHudPanel: the home side of the panel shows line bars,
                                                ; not penalties; PanelAddPenalty clears it; used by
                                                ; DrawHudPanel, PanelAddPenalty, UpdateHudPanel
        db 00h,00h,00h,00h
awpanellines:                                   ; UpdateHudPanel: the away side of the panel shows line bars,
                                                ; not penalties; used by DrawHudPanel, PanelAddPenalty,
                                                ; UpdateHudPanel
        db 00h,00h,00h,00h
hudhomeline:                                    ; line indicator currently drawn on the left of the panel
                                                ; (DrawPanelLine); used by DrawHudPanel, DrawPanelLine,
                                                ; UpdateHudPanel
        db 00h,00h,00h,00h
hudawayline:                                    ; line indicator currently drawn on the right of the panel
                                                ; (DrawPanelLine); used by DrawHudPanel, DrawPanelLine,
                                                ; UpdateHudPanel
        db 00h,00h,00h,00h
hmpanelpens:                                    ; UpdateHudPanel: the home penalty backdrop (hmpanelspr) is
                                                ; drawn; used by DrawHudPanel, UpdateHudPanel
        db 00h,00h,00h,00h
awpanelpens:                                    ; UpdateHudPanel: the away penalty backdrop (awpanelspr) is
                                                ; drawn; used by DrawHudPanel, UpdateHudPanel
        db 00h,00h,00h,00h
hmlinetimer:                                    ; home line timer of the panel: DrawPanelLine resets it when
                                                ; the line group changes, RequestLineChange and
                                                ; PanelAddPenalty clear it; used by DrawHudPanel,
                                                ; DrawPanelLine, PanelAddPenalty ...
        db 00h,00h,00h,00h
awlinetimer:                                    ; visitor line timer of the panel; used by DrawHudPanel,
                                                ; DrawPanelLine, PanelAddPenalty ...
        db 00h
demomatchups_m1:                                ; demomatchups-1: load base of the second -5r dword read; used
                                                ; by RunDemoGame
        db 00h
demomatchups:                                   ; RunDemoGame: team byte pairs of the demo games, read by
                                                ; dword loads at team*2; used by RunDemoGame
        db 00h,00h,08h,011h,04h,012h,02h,015h,014h,03h,0Fh,016h,0Ch,015h,0Ch,0Bh
        db 00h,09h,0Ah,01h,08h,015h,014h,012h,0Ch,015h,0Ch,016h,0Ah,00h,0Ch,0Ah
        db 014h,015h,0Ch,015h
demoteammode:                                   ; used by RunDemoGame
        db 02h,00h,00h,00h
