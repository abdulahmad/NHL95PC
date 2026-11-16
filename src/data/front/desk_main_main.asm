; Which device each pad is, the hot-key state, and the shot and goal counters for the two teams.
bits 32
%include "hockey.inc"
section s_C4D18 progbits alloc noexec write align=1
extern TeamList, str_ArtHart, str_ArtRoss, str_ArtNorr, str_ArtSelk, str_ArtVezi, str_ArtJenn, str_ArtCald
extern str_ArtPres, str_ArtConn, str_ArtEasn, str_ArtStan, str_Hart, str_ArtRoss2, str_Norris, str_Selke
extern str_Vezina, str_Jennings, str_Calder, str_Presidents, str_ConnSmythe, str_EASportsCup, str_StanleyCup, str_MostValuablePlayer
extern str_PointsLeader, str_RegularSeason, str_BestDefenseman, str_BestDefensiveForward, str_BestGoalkeeper, str_BestGoalsAgainstAverage, str_BestRookie, str_BestRegularSeasonRecord
extern str_InThePlayoffs, str_Most3StarSelections, str_StanleyCupChampions, str_Season2, str_Playoff2, BOS, BUF, CGY
extern CHI, DET, EDM, HFD, LA, DAL, MTL, NJ
extern NYI, NYR, OTT, PHI, PIT, QUE, STL, SJ
extern TB, TOR, VAN, WSH, WPG, ANA, FLA, ASW
extern ASE, Buffalo, Calgary, Chicago, Detroit, Edmonton, Hartford, LosAngeles
extern Dallas, Montreal, NewJersey, NYIslanders, NYRangers, Ottawa, Philadelphia, Pittsburgh
extern Quebec, StLouis, SanJose, TampaBay, Toronto, Vancouver, Washington, Winnipeg
extern Anaheim, Florida, AllStarsWest, AllStarsEast, awardstats5, awardstats4, awardstats8, awardstats2
extern awardstats1, awardstats9, awardstats3, awardstats0, awardstats6
global str_D02d, str_D01d, pad1dev, pad2dev, lasthotkey, fadeendlvl, awardtype, keydirtab
global sndcardmissing, gsumheader_b1
global gsumheader_b2, gsumheader_b3, gsumheader_b4, hmgoalcnt, hmshotcnt, awgoalcnt, awshotcnt, joyqtick
global samesideflag, inputframes, escrequest, joyrec, palfadedin, screenw, screenh, demomode
global fadestart_m3, fadestep_m3, fadestart_e1, awardtextcolors, awardartfiles
global postate
global lgstate
global gameresult, gamemode, gameopts, ctl1team, ctl2team, ctl1dev, ctl2dev, ctl1side
global ctl2side, sounddev, awardart, awardnames, awardtitles, awardstatsptrs, awardstatsptrs_e01, awardstatsptrs_e02
global awardstatsptrs_e03, awardstatsptrs_e04, awardstatsptrs_e05, awardstatsptrs_e06, awardstatsptrs_e08, awardstatsptrs_e09, awardscopenames, teamabbrevs
global TeamAbbrevsAllStar, teamcitynames, blackpal, str_fmtpd, exhstate, gsumheader, gsumtail
global gsumcount
joyqtick:                                       ; ISR countdown: a pad sample every 5 ticks (reset to 4); used
                                                ; by SampleInputTick, joyq_flush
        db 00h,00h,00h,00h
pad1dev:                                        ; controller 1 pad device code (0 none, 1 mouse, 2 joystick 1,
                                                ; 4 joystick 2, 8 keyboard), set by SetupControllers; used by
                                                ; ControlsDlgInGame_setside, DrawRinkOverlays, Gameloop ...
        db 08h
pad2dev:                                        ; controller 2 pad device code; used by DrawRinkOverlays,
                                                ; Gameloop, HandleHotKey ...
        db 02h
lasthotkey:                                     ; used by ReadHotKeys, ReadSkipKeys
        db 00h
keydirtab:                                      ; used by ReadJoyPad, ReadKeyboardPad
        db 08h,00h,04h,08h,02h,01h,03h,02h,06h,07h,05h,06h,08h,00h,04h
        db 08h,00h,0DCh,07Bh,00h,00h,0CFh,0BDh,00h,00h,0F7h,00h,00h,00h,0C0h,08h
        db 00h,00h,062h,04h,00h,00h,00h,00h,00h,00h,0DFh,0FFh,00h,00h,0FFh,0DFh
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FEh,0EFh,00h,00h,0FFh,0FFh
        db 00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh
        db 00h,00h,0FCh,0FCh,00h,00h,0FFh,0FFh,00h,00h,0FBh,0FFh,00h,00h,0FFh,0FFh
        db 00h,00h,0FBh,0FFh,00h,00h,0FFh,0FFh,00h,00h,01Fh,00h,00h,00h,07Ch,0FEh
        db 00h,00h,051h,013h,00h,00h,0DBh,0B6h,00h,00h,0EDh,0FFh,00h,00h,0FFh,0FFh
        db 00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh
        db 00h,00h,00h,00h,00h,00h,080h,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh
        db 00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh
        db 00h,00h,0FFh,03h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
samesideflag:                                   ; 1 when both controllers play the same side
                                                ; (SetupControllers); used by ControlsDlgInGame_setside,
                                                ; ControlsDlgPlayoff, SetupControllers
        db 00h,00h,00h,00h
inputframes:                                    ; frames left for the current joyqueue record (3 per record)
                                                ; in RunGameFrames; used by Gameloop, PreGameIntro,
                                                ; ResetGameVars ...
        db 00h,00h,00h,00h
escrequest:                                     ; set by HandleHotKey on Esc; the game frame code checks and
                                                ; clears it; used by Gameloop, HandleHotKey_ret, PlayGame ...
        db 00h,00h,00h,00h
joyrec:                                         ; pointer to the input record of this frame (joyq_peek), read
                                                ; by Readjoy1 (byte 0) and Readjoy2 (byte 1); used by
                                                ; ReadJoy1, ReadJoy2, RunGameFrames
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
palfadedin:                                     ; FadePalette: palette currently faded in; used by
                                                ; FadePalStep, FadePalStepSlow, FadePalette
        db 00h,00h,00h,00h
screenw:                                        ; current screen width (SetScreenSize; 280h); used by
                                                ; SetScreenSize
        db 080h,02h,00h,00h
screenh:                                        ; current screen height (1E0h); used by SetScreenSize
        db 0E0h,01h,00h,00h
blackpal:                                       ; all-black palette: SetScreenSize sets it around a mode
                                                ; change, RunIntro and ShowCredits fade from it; used by
                                                ; RunIntro, SetScreenSize, ShowCredits
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
demomode:                                       ; 1 while RunDemoGame runs the attract-mode game (GameLoop
                                                ; ends it on a key); used by Gameloop, MenuSaveGame,
                                                ; RunDemoGame ...
        db 00h
fadestart_m3:                                   ; used by FadePalette
        db 00h,00h
fadestep_m3:                                    ; used by FadePalette
        db 00h,01h
fadestart_e1:                                   ; FadePalette: fadestart[1], the fade-out start level, set to
                                                ; steps-1; used by FadePalette
        db 0Fh,01h,0FFh
fadeendlvl:                                     ; FadePalette: end level by direction (steps+1 fading in, -1
                                                ; fading out); used by FadePalette
        db 011h,0FFh,00h,00h
awardtextcolors:                                ; ShowAwardScreens: text colour of each award (SetTextColors);
                                                ; used by ShowAwardScreens
        db 0E9h,00h,00h,00h,09Dh,00h,00h,00h,01h,00h,00h,00h,0ACh,00h,00h,00h
        db 0C4h,00h,00h,00h,0C2h,00h,00h,00h,0E3h,00h,00h,00h,062h,00h,00h,00h
        db 04h,00h,00h,00h,05Bh,00h,00h,00h,014h,00h,00h,00h
awardartfiles:                                  ; ShowAwardScreens: file number (fileoncd index) of each
                                                ; award's art; used by ShowAwardScreens
        db 0CEh,01h,00h,00h,0CFh,01h,00h,00h,0CBh,01h,00h,00h,0CCh,01h,00h,00h
        db 0C9h,01h,00h,00h,0CAh,01h,00h,00h,0D1h,01h,00h,00h,0CDh,01h,00h,00h
        db 0D2h,01h,00h,00h,0D0h,01h,00h,00h,0D3h,01h,00h,00h
awardart:                                       ; 11 pointers to the trophy art file names ("hart", "ross",
                                                ; "norr", "selk", "vezi", "jenn", "cald", "pres", "conn",
                                                ; "easn", "stan"); ShowAwardScreens; used by ShowAwardScreens
        dd str_ArtHart
        dd str_ArtRoss
        dd str_ArtNorr
        dd str_ArtSelk
        dd str_ArtVezi
        dd str_ArtJenn
        dd str_ArtCald
        dd str_ArtPres
        dd str_ArtConn
        dd str_ArtEasn
        dd str_ArtStan
awardnames:                                     ; 11 pointers to the trophy names ("Hart" .. "Stanley Cup");
                                                ; ShowAwardScreens, DrawAwardsSummary; used by
                                                ; DrawAwardsSummary
        dd str_Hart
        dd str_ArtRoss2
        dd str_Norris
        dd str_Selke
        dd str_Vezina
        dd str_Jennings
        dd str_Calder
        dd str_Presidents
        dd str_ConnSmythe
        dd str_EASportsCup
        dd str_StanleyCup
awardtitles:                                    ; 11 pairs of string pointers (title, optional line above) for
                                                ; the trophy screens ("Most Valuable Player", "Points Leader"
                                                ; ...); ShowAwardScreens; used by ShowAwardScreens
        dd str_MostValuablePlayer
        db 00h,00h,00h,00h
        dd str_PointsLeader
        dd str_RegularSeason
        dd str_BestDefenseman
        db 00h,00h,00h,00h
        dd str_BestDefensiveForward
        db 00h,00h,00h,00h
        dd str_BestGoalkeeper
        db 00h,00h,00h,00h
        dd str_BestGoalsAgainstAverage
        db 00h,00h,00h,00h
        dd str_BestRookie
        db 00h,00h,00h,00h
        dd str_BestRegularSeasonRecord
        db 00h,00h,00h,00h
        dd str_MostValuablePlayer
        dd str_InThePlayoffs
        dd str_Most3StarSelections
        db 00h,00h,00h,00h
        dd str_StanleyCupChampions
        db 00h,00h,00h,00h
awardtype:                                      ; 11 bytes, kind of winner per trophy: 0 goalie, 1 skater, 2
                                                ; team; ShowAwardScreens, DrawAwardsSummary; used by
                                                ; DrawAwardsSummary, PickAwardWinners, ShowAwardScreens
        db 01h,01h,01h,01h,00h,00h,01h,02h,01h
        db 01h,02h
awardstatsptrs:                                 ; PickAwardWinners: pointer to the stats record of each
                                                ; award's winner; used by PickAwardWinners, ShowAwardScreens
        dd awardstats0
awardstatsptrs_e01:                             ; awardstatsptrs[1]; used by PickAwardWinners
        dd awardstats1
awardstatsptrs_e02:                             ; awardstatsptrs[2]; used by PickAwardWinners
        dd awardstats2
awardstatsptrs_e03:                             ; awardstatsptrs[3]; used by PickAwardWinners
        dd awardstats3
awardstatsptrs_e04:                             ; awardstatsptrs[4]; used by PickAwardWinners
        dd awardstats4
awardstatsptrs_e05:                             ; awardstatsptrs[5]; used by PickAwardWinners
        dd awardstats5
awardstatsptrs_e06:                             ; awardstatsptrs[6]; used by PickAwardWinners
        dd awardstats6
        db 00h,00h,00h,00h
awardstatsptrs_e08:                             ; awardstatsptrs[8]; used by PickAwardWinners
        dd awardstats8
awardstatsptrs_e09:                             ; awardstatsptrs[9]; used by PickAwardWinners
        dd awardstats9
        db 00h,00h,00h,00h
awardscopenames:                                ; ShowAwardScreens: 'Season' / 'Playoff' labels; used by
                                                ; ShowAwardScreens
        dd str_Season2
        dd str_Playoff2
str_fmtpd:                                      ; string '%d'; used by EditGoalieRating, EditSkaterRating,
                                                ; ShowAwardScreens
        db 025h,064h,00h
str_D02d:                                       ; string '%d.%02d'; used by ShowAwardScreens
        db 025h,064h,02Eh,025h,030h,032h,064h,00h
str_D01d:                                       ; string '%d.%01d'; used by ShowAwardScreens
        db 025h,064h,02Eh,025h,030h,031h,064h,00h,00h,00h
exhstate:                                       ; mode state block for gamemode 0 (75h bytes, see
                                                ; SaveModeState); CreatePlayoffs saves the current state here
                                                ; and restores it on exit; used by CreatePlayoffs,
                                                ; EditPlayoffSettings, LoadGameState ...
        db 00h,00h,00h,00h
        db 02Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
        db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
        db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0Ch,00h,00h,00h
        db 015h,00h,00h,00h,0FFh
        db 07Bh,00h,00h
        db 0FFh,0FFh,0FFh,0FFh
        db 0FEh,0FFh,0FFh,0FFh
        db 010h,00h,00h,00h
        db 010h,00h,00h,00h
        db 00h,00h,00h,00h
        db 01h,00h,00h,00h
postate:                                        ; mode state block for gamemode 1 (Play-Off): CreatePlayoffs
                                                ; sets it up (+51h home 0Ch, +55h visitor 15h, controller
                                                ; fields) and loads it with LoadModeState; used by
                                                ; BuildSavedGameLabels, CreatePlayoffs, DeleteSavedGame ...
        db 01h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
        db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
        db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0Ch,00h,00h,00h
        db 015h,00h,00h,00h
        db 0FFh
        db 079h,00h,00h
        db 0FFh,0FFh,0FFh,0FFh
        db 0FEh,0FFh,0FFh,0FFh
        db 010h,00h,00h,00h
        db 010h,00h,00h,00h
        db 00h,00h,00h,00h
        db 01h,00h,00h,00h
lgstate:                                        ; mode state block for gamemode 2 (league; temp_files sets +0
                                                ; = 2); used by BuildSavedGameLabels, CreateNewLeague,
                                                ; DeleteSavedGame ...
        db 02h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
        db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
        db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0Ch,00h,00h,00h
        db 015h,00h,00h,00h
        db 0FFh
        db 07Bh,00h,00h
        db 0FFh,0FFh,0FFh,0FFh
        db 0FEh,0FFh,0FFh,0FFh
        db 010h,00h,00h,00h
        db 010h,00h,00h,00h
        db 00h,00h,00h,00h
        db 01h,00h,00h,00h
gameresult:                                     ; result of the last game: 0 running, 1 completed, 2 quit /
                                                ; cancelled (GameLoop, PlayGame; PlayoffModeLoop calls
                                                ; POAfterGame only on 1); used by GameSummaryScreen_period,
                                                ; Gameloop, MenuOpenSaved ...
        db 00h,00h,00h,00h
gamemode:                                       ; current game mode: 0 exhibition, 1 Play-Off, 2 league
                                                ; (LoadModeState sets it from state +0; WriteCurModeState
                                                ; switches on it); used by BuildEventLines,
                                                ; ChkScorerMilestone, ControlsDlgExh ...
        db 00h,00h,00h,00h
gameopts:                                       ; used by AddPenalty, AdvancePlayoffs, AwardsCeremony ...
        db 0FFh
        db 07Bh,00h,00h
ctl1team:                                       ; team of controller 1 (-1 none, -2 eliminated in Play-Off);
                                                ; mode state +5Dh; used by ControlsDlgInGame,
                                                ; ControlsDlgInGame_setside, ControlsDlgLoop ...
        db 0FFh,0FFh,0FFh,0FFh
ctl2team:                                       ; team of controller 2 (-1 none, -2 eliminated); mode state
                                                ; +61h; used by ControlsDlgInGame_setside, ControlsDlgPlayoff,
                                                ; InstantReplay ...
        db 0FEh,0FFh,0FFh,0FFh
ctl1dev:                                        ; input device of controller 1 (1/2/4/8, 10h = none, from
                                                ; ctlavailmask); mode state +65h; used by
                                                ; ControlsDlgInGame_setside, ControlsDlgLoop, DrawControlsOpts
                                                ; ...
        db 010h,00h,00h,00h
ctl2dev:                                        ; input device of controller 2; mode state +69h; used by
                                                ; LoadGameState, LoadModeState, SaveGameState ...
        db 010h,00h,00h,00h
ctl1side:                                       ; side controller 1 plays (0 home, 1 away); mode state +6Dh;
                                                ; SetSideControls; used by ControlsDlgInGame_setside,
                                                ; ControlsDlgInGame_side, ControlsDlgLoop ...
        db 00h,00h,00h,00h
ctl2side:                                       ; side controller 2 plays; mode state +71h; used by
                                                ; ControlsDlgInGame_setside, ControlsDlgPlayoff, LoadModeState
                                                ; ...
        db 01h,00h,00h,00h
sndcardmissing:                                 ; sound card dialog: a set bit greys out that card (not
                                                ; present); used by DrawSoundCardOpts, RedrawSoundCardOpts,
                                                ; SoundCardDlgLoop_poll
        db 0FFh,00h,00h,00h
sounddev:                                       ; sound device bits 1 PC speaker, 2 Sound Blaster, 4 AdLib, 8
                                                ; MT-32, 20h UltraSound (set by SetSoundDevice, saved to
                                                ; nhl.cfg); used by AwardsCeremony, CrowdFadeOut,
                                                ; CrowdNoiseOff ...
        db 010h,00h,00h,00h
gsumheader:                                     ; 11-byte header of the game summary file (InitGameSummary
                                                ; fills it, WriteGSumHeader writes it); used by
                                                ; AppendGSumRecord, InitGameSummary, LoadGameState ...
        db 00h
gsumheader_b1:                                  ; gsumheader+1; used by InitGameSummary
        db 00h
gsumheader_b2:                                  ; gsumheader+2; used by InitGameSummary
        db 00h
gsumheader_b3:                                  ; gsumheader+3; used by InitGameSummary
        db 00h
gsumheader_b4:                                  ; gsumheader+4; used by InitGameSummary
        db 00h
gsumcount:                                      ; gsumheader+5: record count of the game summary file
                                                ; (AppendGSumRecord and WriteGSumHeader add 1); used by
                                                ; AppendGSumRecord, InitGameSummary, WriteGSumHeader
        db 00h,00h,00h,00h,00h,00h
gsumtail:                                       ; 11-byte block kept at the end of the game summary file
                                                ; (ReadGSumTail, WriteGSumHeader); used by AppendGSumRecord,
                                                ; InitGameSummary, LoadGameState ...
        db 04h
hmgoalcnt:                                      ; used by DumpStatsLog, InitGameSummary, IntermissionDesk ...
        db 00h
hmshotcnt:                                      ; used by ChkShotStat, DumpStatsLog, InitGameSummary ...
        db 00h
awgoalcnt:                                      ; DumpStatsLog away [shots score] 'score'; used by
                                                ; DumpStatsLog, InitGameSummary, IntermissionDesk ...
        db 00h
awshotcnt:                                      ; used by ChkShotStat, DumpStatsLog, InitGameSummary ...
        db 00h,00h,00h,00h,00h,00h,00h
teamabbrevs:                                    ; team abbreviation pointers ("BOS", "BUF", ...); used by
                                                ; Gameloop, LoadModeState, POAfterGame ...
        dd BOS
        dd BUF
TeamAbbrevsAllStar:                             ; Team abbreviation list two entries past teamabbrevs: indexed
                                                ; by team numbers from 24 up to reach the all-star
                                                ; abbreviations; used by SelectSavedFile
        dd CGY
        dd CHI
        dd DET
        dd EDM
        dd HFD
        dd LA
        dd DAL
        dd MTL
        dd NJ
        dd NYI
        dd NYR
        dd OTT
        dd PHI
        dd PIT
        dd QUE
        dd STL
        dd SJ
        dd TB
        dd TOR
        dd VAN
        dd WSH
        dd WPG
        dd ANA
        dd FLA
        dd ASW
        dd ASE
teamcitynames:                                  ; pointer table of team city names ('BOSTON', 'BUFFALO',
                                                ; 'CALGARY', ...); TradePlayers builds 'Show <city>
                                                ; Statistics...' from it; used by DrawControlsDlg,
                                                ; DrawLockerJersey, DrawLockerRoom ...
        dd TeamList
        dd Buffalo
        dd Calgary
        dd Chicago
        dd Detroit
        dd Edmonton
        dd Hartford
        dd LosAngeles
        dd Dallas
        dd Montreal
        dd NewJersey
        dd NYIslanders
        dd NYRangers
        dd Ottawa
        dd Philadelphia
        dd Pittsburgh
        dd Quebec
        dd StLouis
        dd SanJose
        dd TampaBay
        dd Toronto
        dd Vancouver
        dd Washington
        dd Winnipeg
        dd Anaheim
        dd Florida
        dd AllStarsWest
        dd AllStarsEast
