; Initialised data of front/desk_stats (src/front/desk_stats).
bits 32
%include "hockey.inc"
section s_C648E progbits alloc noexec write align=1
extern str_DoYouWantTo, str_TheFileYouSpecified, str_Yes
global msg_FileExists, str_No3, btn_FileExists, str_TheStatsWereSuccessfully, msg_StatsWritten, str_ERROROutputFileWas, msg_OutputFileError, str_InsufficientDiskSpaceTo
global str_TheDisplayedStatisticsTo, msg_NeedKbytes2, msg_StatsDiskSpace, easnfontbuf, embscupbank, statscategory, statsteamsel, statsredrawcb
global deskexit, teamstatscb, skaterstatscb, goaliestatscb, standingscb, standingsmenucb, statsleague
msg_FileExists:                                 ; WriteScreenTextFile message 'The file you specified' / 'Do
                                                ; you want to'; used by WriteScreenTextFile
        dd str_TheFileYouSpecified
        dd str_DoYouWantTo
str_No3:                                        ; "No" string literal
        db 04Eh,06Fh,00h
btn_FileExists:                                 ; WriteScreenTextFile: the two buttons of msg_FileExists; used
                                                ; by WriteScreenTextFile
        db 010h,00h,00h,00h,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_No3
        db 0F0h,0FFh,0FFh,0FFh,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Yes
str_TheStatsWereSuccessfully:                   ; "The stats were successfully written" string literal
        db 054h,068h,065h,020h,073h,074h,061h,074h,073h,020h,077h,065h,072h,065h,020h,073h
        db 075h,063h,063h,065h,073h,073h,066h,075h,06Ch,06Ch,079h,020h,077h,072h,069h,074h
        db 074h,065h,06Eh,00h
msg_StatsWritten:                               ; WriteScreenTextFile message 'The stats were successfully';
                                                ; used by WriteScreenTextFile
        dd str_TheStatsWereSuccessfully
str_ERROROutputFileWas:                         ; string "ERROR : Output file was not successfully written";
                                                ; not referenced by name
        db 045h,052h,052h,04Fh,052h,020h,03Ah,020h,04Fh,075h,074h,070h,075h,074h,020h,066h
        db 069h,06Ch,065h,020h,077h,061h,073h,020h,06Eh,06Fh,074h,020h,073h,075h,063h,063h
        db 065h,073h,073h,066h,075h,06Ch,06Ch,079h,020h,077h,072h,069h,074h,074h,065h,06Eh
        db 00h
msg_OutputFileError:                            ; used by WriteScreenTextFile
        dd str_ERROROutputFileWas
str_InsufficientDiskSpaceTo:                    ; "Insufficient disk space to print" string literal
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,020h,070h,072h,069h,06Eh,074h
        db 00h
str_TheDisplayedStatisticsTo:                   ; "the displayed statistics to, you" string literal
        db 074h,068h,065h,020h,064h,069h,073h,070h,06Ch,061h,079h,065h,064h,020h,073h,074h
        db 061h,074h,069h,073h,074h,069h,063h,073h,020h,074h,06Fh,02Ch,020h,079h,06Fh,075h
        db 00h
msg_NeedKbytes2:                                ; message text (sprintf target) for the WriteScreenTextFile
                                                ; free-space MessageBox; used by WriteScreenTextFile
        db 072h,065h,071h,075h,069h,072h,065h,020h,058h,058h,020h,04Bh,062h,079h,074h,065h
        db 073h,020h,06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h
        db 070h,061h,063h,065h,02Eh,020h,020h,020h,020h,00h
msg_StatsDiskSpace:                             ; WriteScreenTextFile message 'Insufficient disk space to' /
                                                ; 'the displayed statistics to'; used by WriteScreenTextFile
        dd str_InsufficientDiskSpaceTo
        dd str_TheDisplayedStatisticsTo
        dd msg_NeedKbytes2
        db 00h,00h
easnfontbuf:                                    ; loaded EASN.VFN font of the in-game standings screens, freed
                                                ; by FreeDeskBuffers; used by CalStandingsScreen,
                                                ; EasnStandingsScreen, FreeDeskBuffers ...
        db 00h,00h,00h,00h
embscupbank:                                    ; loaded EMBSCUP background bank of the playoff screens, freed
                                                ; by FreeDeskBuffers; used by CalStandingsScreen,
                                                ; CreatePlayoffs, DrawPlayoffTree ...
        db 00h,00h,00h,00h
statscategory:                                  ; stats category picked in the stats menu (StatsMenu*; team
                                                ; 0-5, skater 0-7, goalie 8-10); used by CalGoalieStatsScreen,
                                                ; CalSkaterStatsScreen, CalStandingsMenu ...
        db 00h,00h,00h,00h
statsteamsel:                                   ; selected team index in stats pickers; used by
                                                ; CalStandingsMenu, EasnStandingsMenu_m, GameStandingsMenu ...
        db 00h,00h,00h,00h
statsredrawcb:                                  ; callback (statscategory) that redraws the current stats
                                                ; screen after a Statistics Type change (StatsSel*); used by
                                                ; CalGoalieStatsScreen, CalSkaterStatsScreen, CalStandingsMenu
                                                ; ...
        db 00h,00h,00h,00h
deskexit:                                       ; sports desk menu result set by the DeskSetExit* items (read
                                                ; by easn_stats and palette_fx); used by CalStandingsMenu,
                                                ; DeskSetExit1, DeskSetExit2 ...
        db 00h,00h,00h,00h
teamstatscb:                                    ; redraw callback for the team stats screen (StatsMenu* team
                                                ; items); used by CalendarScreen, MainDeskLoop,
                                                ; MenuNewExhibition ...
        db 00h,00h,00h,00h
skaterstatscb:                                  ; redraw callback for the skater stats screen; used by
                                                ; CalendarScreen, MainDeskLoop, MenuNewExhibition ...
        db 00h,00h,00h,00h
goaliestatscb:                                  ; redraw callback for the goalie stats screen; used by
                                                ; CalendarScreen, MainDeskLoop, MenuNewExhibition ...
        db 00h,00h,00h,00h
standingscb:                                    ; standings screen callback (Game/Easn/CalStandingsScreen);
                                                ; used by CalStandingsMenu, CalStandingsMenu_standings,
                                                ; CalendarScreen ...
        db 00h,00h,00h,00h
standingsmenucb:                                ; standings + roster menu callback; used by CalendarScreen,
                                                ; MainDeskLoop, MenuNewExhibition ...
        db 00h,00h,00h,00h
statsleague:                                    ; name of the league / Play-Off whose stats are shown
                                                ; (StatsSel*); used by GoalieStatsCard, LeadersScreen,
                                                ; LoadLeagueTree ...
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
