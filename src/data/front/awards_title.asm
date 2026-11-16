; Startup strings and the team lists: disk and memory messages, award and title art
; names, the 28 on-screen abbreviations (BOS through ASE), and the city names.
bits 32
%include "hockey.inc"
section s_C0004 progbits alloc noexec write align=1
global TeamList, str_NoDiskSpaceC, str_ErrDiskFree2, str_NoDiskSpaceCur, str_NoMemory, str_CheckRefCard, str_NoConvMemory, str_CheckRefCard2
global str_Pointer3, str_Pntr, str_Scor2b, str_Scor3b, str_Kaufm020, str_ConfigureLeftJoystick, str_ConfigureRightJoystick, str_GameSet2
global str_Temp3, str_ErrDiskFree3, str_GameSav2, str_ANA, str_Cal, str_Flo, str_SS, str_Min
global str_GAA, str_Shots, str_Pct, str_PIM, str_PlusMinus, str_PPG, str_SHG, str_Pal3
global str_Palmem, str_Awardsi, str_Scrn, str_Titl, str_Iff, str_Awards, str_Mtafan, str_Adafan
global str_Awasong, str_Mtawards, str_Adawards, str_Summ, str_04d, str_F000149, str_D50D99, str_D00D49
global str_D50_D99, str_D00_D49, str_Trinknd, str_0000, str_HILIGHT, str_Numshp, str_GfxIdList, str_ErrDiskFree4
global str_ErrDiskFree5, str_GsummaryDb, str_NeedKbytesFmt, str_Scrbrd2, str_Srb3, str_Crests4, str_Stanley, str_Eascrn
global str_Pal4, str_Scrn2, str_Msk1, str_MASK, str_Iff2, str_Title30, str_Mttitle, str_Adtitle
global str_Cmv, str_Title, str_Pioneer1, str_Pl2, str_Pl1, str_Bkgd3, str_Pioneer2, str_Pioneer4
global str_Pioneer3, str_FlaD, str_Pion, str_Pio, str_Eaopen, str_Easports, str_Backwin, str_Credits
global str_Rockditi, str_Shp0, str_OUT, str_NeedKbytesFmt2, str_SfPal1, str_SfPal2, str_PleaseEnterOutputFile, str_Eadesk1d
global str_Desk, str_Pal5, str_Pointer2, str_Iff3, str_Pause, str_Menubuff3, str_ArtHart, str_S1
global str_errd3, str_errd4, str_backslash, str_ArtRoss, str_ArtNorr, str_ArtSelk, str_ArtVezi, str_ArtJenn
global str_ArtCald, str_ArtPres, str_ArtConn, str_ArtEasn, str_ArtStan, str_Hart, str_ArtRoss2, str_Norris
global str_Selke, str_Vezina, str_Jennings, str_Calder, str_Presidents, str_ConnSmythe, str_EASportsCup, str_StanleyCup
global str_MostValuablePlayer, str_PointsLeader, str_RegularSeason, str_BestDefenseman, str_BestDefensiveForward, str_BestGoalkeeper, str_BestGoalsAgainstAverage, str_BestRookie
global str_BestRegularSeasonRecord, str_InThePlayoffs, str_Most3StarSelections, str_StanleyCupChampions, str_Season2, str_Playoff2, str_MightyDucks, str_ctl07
global str_ctl06, str_GP, str_W, str_L, str_T, str_SO, str_EN, str_G
global str_A, str_Pt, BOS, BUF, CGY, CHI, DET, EDM
global HFD, LA, DAL, MTL, NJ, NYI, NYR, OTT
global PHI, PIT, QUE, STL, SJ, TB, TOR, VAN
global WSH, WPG, ANA, FLA, ASW, ASE, Buffalo, Calgary
global Chicago, Detroit, Edmonton, Hartford, LosAngeles, Dallas, Montreal, NewJersey
global NYIslanders, NYRangers, Ottawa, Philadelphia, Pittsburgh, Quebec, StLouis, SanJose
global TampaBay, Toronto, Vancouver, Washington, Winnipeg, Anaheim, Florida, AllStarsWest
global AllStarsEast, str_3000, str_3001, str_3002, str_3003, str_3004, str_3005, str_3006
global str_3007, str_3008, str_3009, str_300, str_OT2, str_BOS, str_BUF3, str_CGY
global str_CHI, str_DET, str_EDM, str_HFD, str_LA, str_DAL, str_MTL, str_NJ
global str_NYI, str_NYR, str_OTT, str_PHI, str_PIT, str_QUE, str_STL, str_SJ
global str_TB, str_TOR, str_VAN, str_WSH, str_WPG, str_ANA3, str_FLA, str_ASW
global str_ASE, CreditBlankTitle, str_Credit19, str_Credit10, str_Credit09, str_Credit17, str_Credit01, str_Credit15
global str_Credit12, str_Credit08, str_Credit02, str_Credit11, str_Credit05, str_Credit06, str_Credit07, str_Credit18
global str_Credit14, str_Credit13, str_Credit16, str_Credit00, str_Credit04, str_Credit03, str_rt, str_wt
str_NoDiskSpaceC:                               ; string "\nInsufficient Disk Space free on 'C:'.\nPlease free
                                                ; up at least 2 Kbytes of disk space\n"; used by main_
        db 0Ah,049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,044h,069h
        db 073h,06Bh,020h,053h,070h,061h,063h,065h,020h,066h,072h,065h,065h,020h,06Fh,06Eh
        db 020h,027h,043h,03Ah,027h,02Eh,0Ah,050h,06Ch,065h,061h,073h,065h,020h,066h,072h
        db 065h,065h,020h,075h,070h,020h,061h,074h,020h,06Ch,065h,061h,073h,074h,020h,032h
        db 020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,064h,069h,073h,06Bh,020h
        db 073h,070h,061h,063h,065h,0Ah,00h
str_ErrDiskFree2:                               ; string 'error getting disk space free\n'; used by main_
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_NoDiskSpaceCur:                             ; string '\nInsufficient Disk Space free on current
                                                ; drive.\nPlease free up at least %d Kbytes of disk space\n';
                                                ; used by main_
        db 0Ah,049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,044h,069h
        db 073h,06Bh,020h,053h,070h,061h,063h,065h,020h,066h,072h,065h,065h,020h,06Fh,06Eh
        db 020h,063h,075h,072h,072h,065h,06Eh,074h,020h,064h,072h,069h,076h,065h,02Eh,0Ah
        db 050h,06Ch,065h,061h,073h,065h,020h,066h,072h,065h,065h,020h,075h,070h,020h,061h
        db 074h,020h,06Ch,065h,061h,073h,074h,020h,025h,064h,020h,04Bh,062h,079h,074h,065h
        db 073h,020h,06Fh,066h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,0Ah
        db 00h
str_NoMemory:                                   ; string '\nInsufficient memory available.'; used by main_
        db 0Ah,049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,06Dh,065h
        db 06Dh,06Fh,072h,079h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,02Eh,00h
str_CheckRefCard:                               ; string '\nPlease check your reference card.\n\n'; used by
                                                ; main_
        db 0Ah,050h,06Ch,065h,061h,073h,065h,020h,063h,068h,065h,063h,06Bh,020h,079h,06Fh
        db 075h,072h,020h,072h,065h,066h,065h,072h,065h,06Eh,063h,065h,020h,063h,061h,072h
        db 064h,02Eh,0Ah,0Ah,00h
str_NoConvMemory:                               ; string '\nInsufficient conventional memory available.'; used
                                                ; by main_
        db 0Ah,049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,063h,06Fh
        db 06Eh,076h,065h,06Eh,074h,069h,06Fh,06Eh,061h,06Ch,020h,06Dh,065h,06Dh,06Fh,072h
        db 079h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,02Eh,00h
str_CheckRefCard2:                              ; string '\nPlease check your reference card.\n\n'; used by
                                                ; main_
        db 0Ah,050h,06Ch,065h,061h,073h,065h,020h,063h,068h,065h,063h,06Bh,020h,079h,06Fh
        db 075h,072h,020h,072h,065h,066h,065h,072h,065h,06Eh,063h,065h,020h,063h,061h,072h
        db 064h,02Eh,0Ah,0Ah,00h
str_Pointer3:                                   ; string 'pointer3'; used by main_
        db 070h,06Fh,069h,06Eh,074h,065h,072h,033h,00h
str_Pntr:                                       ; string 'pntr'; used by main_
        db 070h,06Eh,074h,072h,00h
str_S1:                                         ; string 's1'; used by main_
        db 073h,031h,00h
str_Scor2b:                                     ; string 'scor2b'; used by main_
        db 073h,063h,06Fh,072h,032h,062h,00h
str_Scor3b:                                     ; string 'scor3b'; used by main_
        db 073h,063h,06Fh,072h,033h,062h,00h
str_Kaufm020:                                   ; string 'kaufm020'; used by main_
        db 06Bh,061h,075h,066h,06Dh,030h,032h,030h,00h
str_ConfigureLeftJoystick:                      ; string 'Configure Left Joystick'; used by main_
        db 043h,06Fh,06Eh,066h,069h,067h,075h,072h,065h,020h,04Ch,065h,066h,074h,020h,04Ah
        db 06Fh,079h,073h,074h,069h,063h,06Bh,00h
str_ConfigureRightJoystick:                     ; string 'Configure Right Joystick'; used by main_
        db 043h,06Fh,06Eh,066h,069h,067h,075h,072h,065h,020h,052h,069h,067h,068h,074h,020h
        db 04Ah,06Fh,079h,073h,074h,069h,063h,06Bh,00h
str_GameSet2:                                   ; string 'game.set'; used by main_
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_errd3:                                      ; string 'd3'; used by main_
        db 064h,033h,00h
str_errd4:                                      ; string 'd4'; used by main_
        db 064h,034h,00h
str_Temp3:                                      ; string 'temp'; used by main_
        db 074h,065h,06Dh,070h,00h
str_ErrDiskFree3:                               ; string 'error getting disk space free\n'; used by
                                                ; DiskFreeBytes
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h,00h
        db 00h
str_backslash:                                  ; string '\\'; used by PlayGame
        db 05Ch,00h
str_GameSav2:                                   ; string 'game.sav'; used by PlayGame
        db 067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h,00h
str_ArtHart:                                    ; string 'hart'
        db 068h,061h,072h,074h,00h
str_ArtRoss:                                    ; string 'ross'
        db 072h,06Fh,073h,073h,00h
str_ArtNorr:                                    ; string 'norr'
        db 06Eh,06Fh,072h,072h,00h
str_ArtSelk:                                    ; string 'selk'
        db 073h,065h,06Ch,06Bh,00h
str_ArtVezi:                                    ; string 'vezi'
        db 076h,065h,07Ah,069h,00h
str_ArtJenn:                                    ; string 'jenn'
        db 06Ah,065h,06Eh,06Eh,00h
str_ArtCald:                                    ; string 'cald'
        db 063h,061h,06Ch,064h,00h
str_ArtPres:                                    ; string 'pres'
        db 070h,072h,065h,073h,00h
str_ArtConn:                                    ; string 'conn'
        db 063h,06Fh,06Eh,06Eh,00h
str_ArtEasn:                                    ; string 'easn'
        db 065h,061h,073h,06Eh,00h
str_ArtStan:                                    ; string 'stan'
        db 073h,074h,061h,06Eh,00h
str_Hart:                                       ; "Hart" string literal
        db 048h,061h,072h,074h,00h
str_ArtRoss2:                                   ; "Art Ross" string literal
        db 041h,072h,074h,020h,052h,06Fh,073h,073h,00h
str_Norris:                                     ; "Norris" string literal
        db 04Eh,06Fh,072h,072h,069h,073h,00h
str_Selke:                                      ; "Selke" string literal
        db 053h,065h,06Ch,06Bh,065h,00h
str_Vezina:                                     ; "Vezina" string literal
        db 056h,065h,07Ah,069h,06Eh,061h,00h
str_Jennings:                                   ; "Jennings" string literal
        db 04Ah,065h,06Eh,06Eh,069h,06Eh,067h,073h,00h
str_Calder:                                     ; "Calder" string literal
        db 043h,061h,06Ch,064h,065h,072h,00h
str_Presidents:                                 ; "Presidents" string literal
        db 050h,072h,065h,073h,069h,064h,065h,06Eh,074h,073h,00h
str_ConnSmythe:                                 ; "Conn Smythe" string literal
        db 043h,06Fh,06Eh,06Eh,020h,053h,06Dh,079h,074h,068h,065h,00h
str_EASportsCup:                                ; "EA Sports Cup" string literal
        db 045h,041h,020h,053h,070h,06Fh,072h,074h,073h,020h,043h,075h,070h,00h
str_StanleyCup:                                 ; string 'Stanley Cup '
        db 053h,074h,061h,06Eh,06Ch,065h,079h,020h,043h,075h,070h,06h,00h
str_MostValuablePlayer:                         ; "Most Valuable Player" string literal
        db 04Dh,06Fh,073h,074h,020h,056h,061h,06Ch,075h,061h,062h,06Ch,065h,020h,050h,06Ch
        db 061h,079h,065h,072h,00h
str_PointsLeader:                               ; "Points Leader" string literal
        db 050h,06Fh,069h,06Eh,074h,073h,020h,04Ch,065h,061h,064h,065h,072h,00h
str_RegularSeason:                              ; "Regular Season" string literal
        db 052h,065h,067h,075h,06Ch,061h,072h,020h,053h,065h,061h,073h,06Fh,06Eh,00h
str_BestDefenseman:                             ; "Best Defenseman" string literal
        db 042h,065h,073h,074h,020h,044h,065h,066h,065h,06Eh,073h,065h,06Dh,061h,06Eh,00h
str_BestDefensiveForward:                       ; "Best Defensive Forward" string literal
        db 042h,065h,073h,074h,020h,044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,046h
        db 06Fh,072h,077h,061h,072h,064h,00h
str_BestGoalkeeper:                             ; "Best Goalkeeper" string literal
        db 042h,065h,073h,074h,020h,047h,06Fh,061h,06Ch,06Bh,065h,065h,070h,065h,072h,00h
str_BestGoalsAgainstAverage:                    ; "Best Goals Against Average" string literal
        db 042h,065h,073h,074h,020h,047h,06Fh,061h,06Ch,073h,020h,041h,067h,061h,069h,06Eh
        db 073h,074h,020h,041h,076h,065h,072h,061h,067h,065h,00h
str_BestRookie:                                 ; "Best Rookie" string literal
        db 042h,065h,073h,074h,020h,052h,06Fh,06Fh,06Bh,069h,065h,00h
str_BestRegularSeasonRecord:                    ; "Best Regular Season Record" string literal
        db 042h,065h,073h,074h,020h,052h,065h,067h,075h,06Ch,061h,072h,020h,053h,065h,061h
        db 073h,06Fh,06Eh,020h,052h,065h,063h,06Fh,072h,064h,00h
str_InThePlayoffs:                              ; "in the Playoffs" string literal
        db 069h,06Eh,020h,074h,068h,065h,020h,050h,06Ch,061h,079h,06Fh,066h,066h,073h,00h
str_Most3StarSelections:                        ; "Most 3 Star Selections" string literal
        db 04Dh,06Fh,073h,074h,020h,033h,020h,053h,074h,061h,072h,020h,053h,065h,06Ch,065h
        db 063h,074h,069h,06Fh,06Eh,073h,00h
str_StanleyCupChampions:                        ; string 'Stanley Cup Champions'
        db 053h,074h,061h,06Eh,06Ch,065h,079h,020h,043h,075h,070h,06h,020h,043h,068h,061h
        db 06Dh,070h,069h,06Fh,06Eh,073h,00h
str_Season2:                                    ; "Season" string literal
        db 053h,065h,061h,073h,06Fh,06Eh,00h
str_Playoff2:                                   ; "Playoff" string literal
        db 050h,06Ch,061h,079h,06Fh,066h,066h,00h
str_ANA:                                        ; string 'ANA'; used by DrawAwardsSummary, ShowAwardScreens
        db 041h,04Eh,041h,00h
str_MightyDucks:                                ; string 'Mighty Ducks\x07 of Anaheim'; used by
                                                ; DrawAwardsSummary, ShowAwardScreens
        db 04Dh,069h,067h,068h,074h,079h,020h,044h,075h,063h,06Bh,073h,07h,020h,06Fh,066h
        db 020h,041h,06Eh,061h,068h,065h,069h,06Dh,00h
str_Cal:                                        ; string 'Cal'; used by DrawAwardsSummary, ShowAwardScreens
        db 043h,061h,06Ch,00h
str_Flo:                                        ; string 'Flo'; used by DrawAwardsSummary, ShowAwardScreens
        db 046h,06Ch,06Fh,00h
str_ctl07:                                      ; one-byte control string 07h (text colour code) of the award
                                                ; screens; used by DrawAwardsSummary, ShowAwardScreens
        db 07h,00h
str_ctl06:                                      ; one-byte control string 06h (text colour code) of the award
                                                ; screens; used by DrawAwardsSummary, ShowAwardScreens
        db 06h,00h
str_SS:                                         ; string '%s %s'; used by ShowAwardScreens
        db 025h,073h,020h,025h,073h,00h
str_GP:                                         ; string 'GP'; used by ShowAwardScreens
        db 047h,050h,00h
str_Min:                                        ; string 'Min'; used by ShowAwardScreens
        db 04Dh,069h,06Eh,00h
str_GAA:                                        ; string 'GAA'; used by ShowAwardScreens
        db 047h,041h,041h,00h
str_W:                                          ; string 'W'; used by ShowAwardScreens
        db 057h,00h
str_L:                                          ; string 'L'; used by ShowAwardScreens
        db 04Ch,00h
str_T:                                          ; string 'T'; used by ShowAwardScreens
        db 054h,00h
str_SO:                                         ; string 'SO'; used by ShowAwardScreens
        db 053h,04Fh,00h
str_EN:                                         ; string 'EN'; used by ShowAwardScreens
        db 045h,04Eh,00h
str_Shots:                                      ; string 'Shots'; used by ShowAwardScreens
        db 053h,068h,06Fh,074h,073h,00h
str_Pct:                                        ; string 'Pct'; used by ShowAwardScreens
        db 050h,063h,074h,00h
str_G:                                          ; string 'G'; used by ShowAwardScreens
        db 047h,00h
str_A:                                          ; string 'A'; used by ShowAwardScreens
        db 041h,00h
str_Pt:                                         ; string 'Pt'; used by ShowAwardScreens
        db 050h,074h,00h
str_PIM:                                        ; string 'PIM'; used by ShowAwardScreens
        db 050h,049h,04Dh,00h
str_PlusMinus:                                  ; string '+/-'; used by ShowAwardScreens
        db 02Bh,02Fh,02Dh,00h
str_PPG:                                        ; string 'PPG'; used by ShowAwardScreens
        db 050h,050h,047h,00h
str_SHG:                                        ; string 'SHG'; used by ShowAwardScreens
        db 053h,048h,047h,00h
str_Pal3:                                       ; string '!pal'; used by AwardsCeremony, ShowAwardScreens
        db 021h,070h,061h,06Ch,00h
str_Palmem:                                     ; string 'palmem'; used by AwardsCeremony, ShowAwardScreens
        db 070h,061h,06Ch,06Dh,065h,06Dh,00h
str_Awardsi:                                    ; string 'awardsi'; used by AwardsCeremony
        db 061h,077h,061h,072h,064h,073h,069h,00h
str_Scrn:                                       ; string 'scrn'; used by AwardsCeremony
        db 073h,063h,072h,06Eh,00h
str_Titl:                                       ; string 'titl'; used by AwardsCeremony
        db 074h,069h,074h,06Ch,00h
str_Iff:                                        ; string '.iff'; used by AwardsCeremony
        db 02Eh,069h,066h,066h,00h
str_Awards:                                     ; string 'awards'; used by AwardsCeremony
        db 061h,077h,061h,072h,064h,073h,00h
str_Mtafan:                                     ; string 'mtafan'; used by AwardsCeremony
        db 06Dh,074h,061h,066h,061h,06Eh,00h
str_Adafan:                                     ; string 'adafan'; used by AwardsCeremony
        db 061h,064h,061h,066h,061h,06Eh,00h
str_Awasong:                                    ; string 'awasong'; used by AwardsCeremony
        db 061h,077h,061h,073h,06Fh,06Eh,067h,00h
str_Mtawards:                                   ; string 'mtawards'; used by AwardsCeremony
        db 06Dh,074h,061h,077h,061h,072h,064h,073h,00h
str_Adawards:                                   ; string 'adawards'; used by AwardsCeremony
        db 061h,064h,061h,077h,061h,072h,064h,073h,00h
str_Summ:                                       ; string 'summ'; used by AwardsCeremony
        db 073h,075h,06Dh,06Dh,00h,00h,00h,00h
str_04d:                                        ; string '%04d'; used by IndexPhotoBank, LoadGameGfx,
                                                ; LoadPhotoBankF ...
        db 025h,030h,034h,064h,00h
str_F000149:                                    ; string 'f000_149'; used by LoadPhotoBankF
        db 066h,030h,030h,030h,05Fh,031h,034h,039h,00h
str_D50D99:                                     ; string '%d50%d99'; used by LoadPlayerPhotos
        db 025h,064h,035h,030h,025h,064h,039h,039h,00h
str_D00D49:                                     ; string '%d00%d49'; used by LoadPlayerPhotos
        db 025h,064h,030h,030h,025h,064h,034h,039h,00h
str_D50_D99:                                    ; string '%d50_%d99'; used by LoadPlayerPhotos
        db 025h,064h,035h,030h,05Fh,025h,064h,039h,039h,00h
str_D00_D49:                                    ; string '%d00_%d49'; used by LoadPlayerPhotos
        db 025h,064h,030h,030h,05Fh,025h,064h,034h,039h,00h
str_Trinknd:                                    ; string 'trinknd'; used by LoadTransparentRinkEndOverlay
        db 074h,072h,069h,06Eh,06Bh,06Eh,064h,00h
str_0000:                                       ; string '0000'; used by LoadTransparentRinkEndOverlay
        db 030h,030h,030h,030h,00h
str_HILIGHT:                                    ; string 'HILIGHT'; used by LoadGameGfx, ReloadGameGfx
        db 048h,049h,04Ch,049h,047h,048h,054h,00h
str_Numshp:                                     ; string 'numshp'; used by LoadGameGfx, ReloadGameGfx
        db 06Eh,075h,06Dh,073h,068h,070h,00h
str_GfxIdList:                                  ; string '000G000D000D000L000C000R000X'; used by
                                                ; LoadGameGfx_common
        db 030h,030h,030h,047h,030h,030h,030h,044h,030h,030h,030h,044h,030h,030h,030h,04Ch
        db 030h,030h,030h,043h,030h,030h,030h,052h,030h,030h,030h,058h,00h,00h,00h,00h
BOS:                                            ; on-screen team abbreviation in teamabbrevs
        db 042h,04Fh,053h,00h
BUF:                                            ; on-screen team abbreviation in teamabbrevs
        db 042h,055h,046h,00h
CGY:                                            ; on-screen team abbreviation in teamabbrevs
        db 043h,047h,059h,00h
CHI:                                            ; on-screen team abbreviation in teamabbrevs
        db 043h,048h,049h,00h
DET:                                            ; on-screen team abbreviation in teamabbrevs
        db 044h,045h,054h,00h
EDM:                                            ; on-screen team abbreviation in teamabbrevs
        db 045h,044h,04Dh,00h
HFD:                                            ; on-screen team abbreviation in teamabbrevs
        db 048h,046h,044h,00h
LA:                                             ; on-screen team abbreviation in teamabbrevs
        db 04Ch,041h,00h
DAL:                                            ; on-screen team abbreviation in teamabbrevs
        db 044h,041h,04Ch,00h
MTL:                                            ; on-screen team abbreviation in teamabbrevs
        db 04Dh,054h,04Ch,00h
NJ:                                             ; on-screen team abbreviation in teamabbrevs
        db 04Eh,04Ah,00h
NYI:                                            ; on-screen team abbreviation in teamabbrevs
        db 04Eh,059h,049h,00h
NYR:                                            ; on-screen team abbreviation in teamabbrevs
        db 04Eh,059h,052h,00h
OTT:                                            ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 04Fh,054h,054h,00h
PHI:                                            ; on-screen team abbreviation in teamabbrevs
        db 050h,048h,049h,00h
PIT:                                            ; on-screen team abbreviation in teamabbrevs
        db 050h,049h,054h,00h
QUE:                                            ; on-screen team abbreviation in teamabbrevs
        db 051h,055h,045h,00h
STL:                                            ; on-screen team abbreviation in teamabbrevs
        db 053h,054h,04Ch,00h
SJ:                                             ; on-screen team abbreviation in teamabbrevs
        db 053h,04Ah,00h
TB:                                             ; on-screen abbreviation TB
        db 054h,042h,00h
TOR:                                            ; on-screen team abbreviation in teamabbrevs
        db 054h,04Fh,052h,00h
VAN:                                            ; on-screen team abbreviation in teamabbrevs
        db 056h,041h,04Eh,00h
WSH:                                            ; on-screen team abbreviation in teamabbrevs
        db 057h,053h,048h,00h
WPG:                                            ; on-screen team abbreviation in teamabbrevs
        db 057h,050h,047h,00h
ANA:                                            ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 041h,04Eh,041h,00h
FLA:                                            ; on-screen team abbreviation in teamabbrevs
        db 046h,04Ch,041h,00h
ASW:                                            ; on-screen abbreviation for West All Stars
        db 041h,053h,057h,00h
ASE:                                            ; on-screen abbreviation for East All Stars
        db 041h,053h,045h,00h
TeamList:                                       ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 042h,04Fh,053h,054h,04Fh,04Eh,00h
Buffalo:                                        ; city string BUFFALO
        db 042h,055h,046h,046h,041h,04Ch,04Fh,00h
Calgary:                                        ; city string CALGARY
        db 043h,041h,04Ch,047h,041h,052h,059h,00h
Chicago:                                        ; city string CHICAGO
        db 043h,048h,049h,043h,041h,047h,04Fh,00h
Detroit:                                        ; city string DETROIT
        db 044h,045h,054h,052h,04Fh,049h,054h,00h
Edmonton:                                       ; city string EDMONTON
        db 045h,044h,04Dh,04Fh,04Eh,054h,04Fh,04Eh,00h
Hartford:                                       ; city string HARTFORD
        db 048h,041h,052h,054h,046h,04Fh,052h,044h,00h
LosAngeles:                                     ; city string LOS ANGELES
        db 04Ch,04Fh,053h,020h,041h,04Eh,047h,045h,04Ch,045h,053h,00h
Dallas:                                         ; city string DALLAS
        db 044h,041h,04Ch,04Ch,041h,053h,00h
Montreal:                                       ; city string MONTREAL
        db 04Dh,04Fh,04Eh,054h,052h,045h,041h,04Ch,00h
NewJersey:                                      ; city string NEW JERSEY
        db 04Eh,045h,057h,020h,04Ah,045h,052h,053h,045h,059h,00h
NYIslanders:                                    ; city string NY ISLANDERS; long name, not NYI
        db 04Eh,059h,020h,049h,053h,04Ch,041h,04Eh,044h,045h,052h,053h,00h
NYRangers:                                      ; city string NY RANGERS; long name, not NYR
        db 04Eh,059h,020h,052h,041h,04Eh,047h,045h,052h,053h,00h
Ottawa:                                         ; city string OTTAWA
        db 04Fh,054h,054h,041h,057h,041h,00h
Philadelphia:                                   ; city string PHILADELPHIA
        db 050h,048h,049h,04Ch,041h,044h,045h,04Ch,050h,048h,049h,041h,00h
Pittsburgh:                                     ; city string PITTSBURGH
        db 050h,049h,054h,054h,053h,042h,055h,052h,047h,048h,00h
Quebec:                                         ; city string QUEBEC
        db 051h,055h,045h,042h,045h,043h,00h
StLouis:                                        ; city string ST LOUIS
        db 053h,054h,020h,04Ch,04Fh,055h,049h,053h,00h
SanJose:                                        ; city string SAN JOSE
        db 053h,041h,04Eh,020h,04Ah,04Fh,053h,045h,00h
TampaBay:                                       ; city string TAMPA BAY
        db 054h,041h,04Dh,050h,041h,020h,042h,041h,059h,00h
Toronto:                                        ; city string TORONTO
        db 054h,04Fh,052h,04Fh,04Eh,054h,04Fh,00h
Vancouver:                                      ; city string VANCOUVER
        db 056h,041h,04Eh,043h,04Fh,055h,056h,045h,052h,00h
Washington:                                     ; city string WASHINGTON
        db 057h,041h,053h,048h,049h,04Eh,047h,054h,04Fh,04Eh,00h
Winnipeg:                                       ; city string WINNIPEG
        db 057h,049h,04Eh,04Eh,049h,050h,045h,047h,00h
Anaheim:                                        ; city string ANAHEIM
        db 041h,04Eh,041h,048h,045h,049h,04Dh,00h
Florida:                                        ; city string FLORIDA
        db 046h,04Ch,04Fh,052h,049h,044h,041h,00h
AllStarsWest:                                   ; city string WEST ALL STARS
        db 057h,045h,053h,054h,020h,041h,04Ch,04Ch,020h,053h,054h,041h,052h,053h,00h
AllStarsEast:                                   ; city string EAST ALL STARS
        db 045h,041h,053h,054h,020h,041h,04Ch,04Ch,020h,053h,054h,041h,052h,053h,00h,00h
        db 00h
str_ErrDiskFree4:                               ; string 'error getting disk space free\n'; used by
                                                ; DiskSpaceShort
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_ErrDiskFree5:                               ; string 'error getting disk space free\n'; used by
                                                ; CheckGameDiskSpace
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_GsummaryDb:                                 ; string 'gsummary.db'; used by CheckGameDiskSpace
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,02Eh,064h,062h,00h
str_NeedKbytesFmt:                              ; string 'play the game, you require %2d Kbytes'; used by
                                                ; CheckGameDiskSpace
        db 070h,06Ch,061h,079h,020h,074h,068h,065h,020h,067h,061h,06Dh,065h,02Ch,020h,079h
        db 06Fh,075h,020h,072h,065h,071h,075h,069h,072h,065h,020h,025h,032h,064h,020h,04Bh
        db 062h,079h,074h,065h,073h,00h
str_3000:                                       ; string '3000'
        db 033h,030h,030h,030h,00h
str_3001:                                       ; string '3001'
        db 033h,030h,030h,031h,00h
str_3002:                                       ; string '3002'
        db 033h,030h,030h,032h,00h
str_3003:                                       ; string '3003'
        db 033h,030h,030h,033h,00h
str_3004:                                       ; string '3004'
        db 033h,030h,030h,034h,00h
str_3005:                                       ; string '3005'
        db 033h,030h,030h,035h,00h
str_3006:                                       ; string '3006'
        db 033h,030h,030h,036h,00h
str_3007:                                       ; string '3007'
        db 033h,030h,030h,037h,00h
str_3008:                                       ; string '3008'
        db 033h,030h,030h,038h,00h
str_3009:                                       ; string '3009'
        db 033h,030h,030h,039h,00h
str_300:                                        ; string '300 '
        db 033h,030h,030h,020h,00h
str_OT2:                                        ; "OT " string literal
        db 04Fh,054h,020h,020h,00h
str_BOS:                                        ; "BOS " string literal
        db 042h,04Fh,053h,020h,00h
str_BUF3:                                       ; "BUF " string literal
        db 042h,055h,046h,020h,00h
str_CGY:                                        ; "CGY " string literal
        db 043h,047h,059h,020h,00h
str_CHI:                                        ; "CHI " string literal
        db 043h,048h,049h,020h,00h
str_DET:                                        ; "DET " string literal
        db 044h,045h,054h,020h,00h
str_EDM:                                        ; "EDM " string literal
        db 045h,044h,04Dh,020h,00h
str_HFD:                                        ; "HFD " string literal
        db 048h,046h,044h,020h,00h
str_LA:                                         ; "LA " string literal
        db 04Ch,041h,020h,020h,00h
str_DAL:                                        ; "DAL " string literal
        db 044h,041h,04Ch,020h,00h
str_MTL:                                        ; "MTL " string literal
        db 04Dh,054h,04Ch,020h,00h
str_NJ:                                         ; "NJ " string literal
        db 04Eh,04Ah,020h,020h,00h
str_NYI:                                        ; "NYI " string literal
        db 04Eh,059h,049h,020h,00h
str_NYR:                                        ; "NYR " string literal
        db 04Eh,059h,052h,020h,00h
str_OTT:                                        ; "OTT " string literal
        db 04Fh,054h,054h,020h,00h
str_PHI:                                        ; "PHI " string literal
        db 050h,048h,049h,020h,00h
str_PIT:                                        ; "PIT " string literal
        db 050h,049h,054h,020h,00h
str_QUE:                                        ; "QUE " string literal
        db 051h,055h,045h,020h,00h
str_STL:                                        ; "STL " string literal
        db 053h,054h,04Ch,020h,00h
str_SJ:                                         ; "SJ " string literal
        db 053h,04Ah,020h,020h,00h
str_TB:                                         ; "TB " string literal
        db 054h,042h,020h,020h,00h
str_TOR:                                        ; "TOR " string literal
        db 054h,04Fh,052h,020h,00h
str_VAN:                                        ; "VAN " string literal
        db 056h,041h,04Eh,020h,00h
str_WSH:                                        ; "WSH " string literal
        db 057h,053h,048h,020h,00h
str_WPG:                                        ; "WPG " string literal
        db 057h,050h,047h,020h,00h
str_ANA3:                                       ; "ANA " string literal
        db 041h,04Eh,041h,020h,00h
str_FLA:                                        ; "FLA " string literal
        db 046h,04Ch,041h,020h,00h
str_ASW:                                        ; "ASW " string literal
        db 041h,053h,057h,020h,00h
str_ASE:                                        ; "ASE " string literal
        db 041h,053h,045h,020h,00h
str_Scrbrd2:                                    ; string 'scrbrd2'; used by DrawHudPanel
        db 073h,063h,072h,062h,072h,064h,032h,00h
str_Srb3:                                       ; string 'srb3'; used by DrawHudPanel
        db 073h,072h,062h,033h,00h
str_Crests4:                                    ; string 'crests4'; used by DrawHudPanel
        db 063h,072h,065h,073h,074h,073h,034h,00h,00h,00h,00h
str_Stanley:                                    ; string 'Stanley'; used by LoadCupFinalSeries
        db 053h,074h,061h,06Eh,06Ch,065h,079h,00h
CreditBlankTitle:                               ; Empty string used as the title line of credit pages that
                                                ; have no title art
        db 00h,00h
str_Credit19:                                   ; "credit19" string literal
        db 063h,072h,065h,064h,069h,074h,031h,039h,00h
str_Credit10:                                   ; "credit10" string literal
        db 063h,072h,065h,064h,069h,074h,031h,030h,00h
str_Credit09:                                   ; "credit09" string literal
        db 063h,072h,065h,064h,069h,074h,030h,039h,00h
str_Credit17:                                   ; "credit17" string literal
        db 063h,072h,065h,064h,069h,074h,031h,037h,00h
str_Credit01:                                   ; "credit01" string literal
        db 063h,072h,065h,064h,069h,074h,030h,031h,00h
str_Credit15:                                   ; "credit15" string literal
        db 063h,072h,065h,064h,069h,074h,031h,035h,00h
str_Credit12:                                   ; "credit12" string literal
        db 063h,072h,065h,064h,069h,074h,031h,032h,00h
str_Credit08:                                   ; "credit08" string literal
        db 063h,072h,065h,064h,069h,074h,030h,038h,00h
str_Credit02:                                   ; "credit02" string literal
        db 063h,072h,065h,064h,069h,074h,030h,032h,00h
str_Credit11:                                   ; "credit11" string literal
        db 063h,072h,065h,064h,069h,074h,031h,031h,00h
str_Credit05:                                   ; "credit05" string literal
        db 063h,072h,065h,064h,069h,074h,030h,035h,00h
str_Credit06:                                   ; "credit06" string literal
        db 063h,072h,065h,064h,069h,074h,030h,036h,00h
str_Credit07:                                   ; "credit07" string literal
        db 063h,072h,065h,064h,069h,074h,030h,037h,00h
str_Credit18:                                   ; "credit18" string literal
        db 063h,072h,065h,064h,069h,074h,031h,038h,00h
str_Credit14:                                   ; "credit14" string literal
        db 063h,072h,065h,064h,069h,074h,031h,034h,00h
str_Credit13:                                   ; "credit13" string literal
        db 063h,072h,065h,064h,069h,074h,031h,033h,00h
str_Credit16:                                   ; "credit16" string literal
        db 063h,072h,065h,064h,069h,074h,031h,036h,00h
str_Credit00:                                   ; "credit00" string literal
        db 063h,072h,065h,064h,069h,074h,030h,030h,00h
str_Credit04:                                   ; "credit04" string literal
        db 063h,072h,065h,064h,069h,074h,030h,034h,00h
str_Credit03:                                   ; "credit03" string literal
        db 063h,072h,065h,064h,069h,074h,030h,033h,00h
str_Eascrn:                                     ; string 'eascrn'; used by TitleScreen
        db 065h,061h,073h,063h,072h,06Eh,00h
str_Pal4:                                       ; string '!pal'; used by RunIntro, ShowCredits, TitleScreen
        db 021h,070h,061h,06Ch,00h
str_Scrn2:                                      ; string 'scrn'; used by RunIntro, TitleScreen
        db 073h,063h,072h,06Eh,00h
str_Msk1:                                       ; string 'msk1'; used by TitleScreen
        db 06Dh,073h,06Bh,031h,00h
str_MASK:                                       ; string 'MASK'; used by TitleScreen
        db 04Dh,041h,053h,04Bh,00h
str_Iff2:                                       ; string '.iff'; used by RunIntro, ShowCredits, TitleScreen
        db 02Eh,069h,066h,066h,00h
str_Title30:                                    ; string 'title30'; used by TitleScreen
        db 074h,069h,074h,06Ch,065h,033h,030h,00h
str_Mttitle:                                    ; string 'mttitle'; used by TitleScreen
        db 06Dh,074h,074h,069h,074h,06Ch,065h,00h
str_Adtitle:                                    ; string 'adtitle'; used by ShowCredits, TitleScreen
        db 061h,064h,074h,069h,074h,06Ch,065h,00h
str_Cmv:                                        ; string '.cmv'; used by TitleScreen
        db 02Eh,063h,06Dh,076h,00h
str_Title:                                      ; string 'title'; used by TitleScreen
        db 074h,069h,074h,06Ch,065h,00h
str_Pioneer1:                                   ; string 'pioneer1'; used by RunIntro
        db 070h,069h,06Fh,06Eh,065h,065h,072h,031h,00h
str_Pl2:                                        ; string '!pl2'; used by RunIntro
        db 021h,070h,06Ch,032h,00h
str_Pl1:                                        ; string '!pl1'; used by RunIntro
        db 021h,070h,06Ch,031h,00h
str_Bkgd3:                                      ; string 'bkgd'; used by RunIntro, ShowCredits
        db 062h,06Bh,067h,064h,00h
str_Pioneer2:                                   ; string 'pioneer2'; used by RunIntro
        db 070h,069h,06Fh,06Eh,065h,065h,072h,032h,00h
str_Pioneer4:                                   ; string 'pioneer4'; used by RunIntro
        db 070h,069h,06Fh,06Eh,065h,065h,072h,034h,00h
str_Pioneer3:                                   ; string 'pioneer3'; used by RunIntro
        db 070h,069h,06Fh,06Eh,065h,065h,072h,033h,00h
str_FlaD:                                       ; string 'fla%d'; used by RunIntro
        db 066h,06Ch,061h,025h,064h,00h
str_Pion:                                       ; string 'pion'; used by RunIntro
        db 070h,069h,06Fh,06Eh,00h
str_Pio:                                        ; string '!pio'; used by RunIntro
        db 021h,070h,069h,06Fh,00h
str_Eaopen:                                     ; string 'eaopen'; used by RunIntro
        db 065h,061h,06Fh,070h,065h,06Eh,00h
str_Easports:                                   ; string 'easports'; used by RunIntro
        db 065h,061h,073h,070h,06Fh,072h,074h,073h,00h
str_Backwin:                                    ; string 'backwin'; used by ShowCredits
        db 062h,061h,063h,06Bh,077h,069h,06Eh,00h
str_Credits:                                    ; string 'credits'; used by ShowCredits
        db 063h,072h,065h,064h,069h,074h,073h,00h
str_Rockditi:                                   ; string 'rockditi'; used by ShowCredits
        db 072h,06Fh,063h,06Bh,064h,069h,074h,069h,00h
str_Shp0:                                       ; string 'shp0'; used by ShowCredits
        db 073h,068h,070h,030h,00h,00h,00h
str_OUT:                                        ; string '.OUT'; used by WriteScreenTextFile
        db 02Eh,04Fh,055h,054h,00h
str_NeedKbytesFmt2:                             ; string 'require %2d Kbytes of free disk space.'; used by
                                                ; WriteScreenTextFile
        db 072h,065h,071h,075h,069h,072h,065h,020h,025h,032h,064h,020h,04Bh,062h,079h,074h
        db 065h,073h,020h,06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h
        db 073h,070h,061h,063h,065h,02Eh,00h
str_rt:                                         ; string 'rt'; used by WriteScreenTextFile
        db 072h,074h,00h
str_wt:                                         ; string 'wt'; used by WriteScreenTextFile
        db 077h,074h,00h,00h,00h
str_SfPal1:                                     ; string 'SfPal1'; used by StatsMenuAssists, StatsMenuGAA,
                                                ; StatsMenuGoalieWins ...
        db 053h,066h,050h,061h,06Ch,031h,00h
str_SfPal2:                                     ; string 'SfPal2'; used by StatsMenuAssists, StatsMenuGAA,
                                                ; StatsMenuGoalieWins ...
        db 053h,066h,050h,061h,06Ch,032h,00h
str_PleaseEnterOutputFile:                      ; string 'Please enter output file name'; used by
                                                ; OutputCurrentData
        db 050h,06Ch,065h,061h,073h,065h,020h,065h,06Eh,074h,065h,072h,020h,06Fh,075h,074h
        db 070h,075h,074h,020h,066h,069h,06Ch,065h,020h,06Eh,061h,06Dh,065h,00h
str_Eadesk1d:                                   ; string 'eadesk%1d'; used by SportsDesk
        db 065h,061h,064h,065h,073h,06Bh,025h,031h,064h,00h
str_Desk:                                       ; string 'desk'; used by SportsDesk
        db 064h,065h,073h,06Bh,00h
str_Pal5:                                       ; string '!pal'; used by SportsDesk
        db 021h,070h,061h,06Ch,00h
str_Pointer2:                                   ; string 'Pointer'; used by SportsDesk
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff3:                                       ; string '.iff'; used by SportsDesk
        db 02Eh,069h,066h,066h,00h
str_Pause:                                      ; string 'pause'; used by SportsDesk
        db 070h,061h,075h,073h,065h,00h
str_Menubuff3:                                  ; string 'menubuff'; used by SportsDesk
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
