; File names and menu strings for the teams, the desk, and the statistics screens.
bits 32
%include "hockey.inc"
section s_C0A18 progbits alloc noexec write align=1
global str_teams, str_key, str_att, str_season, str_career, str_GsummaryDb2, str_scrbrd1, str_LineCodes0
global str_LineCodes1, str_LineCodes2, str_VisLineTags, str_HomeLineTags, str_Visp, str_Homp, str_LineNames, str_PointerMenu
global str_menubuff, str_sfh, str_shape, str_embpal, str_Pal6, str_tstat, str_keys, str_pstat
global str_gstat, str_embpal2, str_Pal7, str_easndesk2, str_tstat2, str_keys2, str_pstat2, str_gstat2
global str_calendar, str_embpal3, str_Pal8, str_tstat3, str_keys3, str_pstat3, str_gstat3, str_PORTR
global str_Pstatbar3, str_Pst1, str_Pst22, str_PlayerStats, str_SS2, str_D2, str_Center2, str_Defense
global str_LeftWing2, str_RightWing2, str_G2, str_A2, str_Pt2, str_PIM2, str_PlusMinus2, str_PPG2
global str_SHG2, str_Shots2, str_Pct2, str_Ratings2, str_Shoots2, str_L2, str_R, str_PORTR2
global str_Pstatbar4, str_Pst12, str_Pst23, str_PlayerStats2, str_SS3, str_DGoalie, str_Min2, str_GAA2
global str_SA, str_Pct3, str_Ratings3, str_GloveHand2, str_L3, str_R2, str_Teams, str_Addsort
global str_Pstatbar5, str_Pst24, str_StatsUnavailable, str_ANA2, str_MightyDucksOfAnaheim, str_Dashes39, str_Dashes36, str_KeyDb
global str_Pstatbar6, str_Pst25, str_Trad, str_Regi, str_MightyDucksOfAnaheim2, str_Pos, str_Name, str_G3
global str_A3, str_PT, str_Shots3, str_PIM3, str_PlusMinus3, str_Min3, str_GAA3, str_GA
global str_SA2, str_PCT, str_Keys, str_Pstat, str_Gstat, str_Addsort2, str_KeyDb2, str_Pstatbar7
global str_Pst26, str_StatsUnavailable2, str_POS, str_PLAYER2, str_TEAM, str_Pstatbar8, str_Pst27, str_Standings
global str_Western, str_Conference, str_Eastern, str_Team, str_GF, str_GA2, str_P, str_Pct4
global str_Embpal2, str_Pal9, str_PlayoffsHaveNotBeen2, str_Rst12, str_Rst22, str_Scuparrw2, str_WesternConference2, str_EasternConference2
global str_C3, str_Aup12, str_Aup22, str_Aup32, str_Midl2, str_Adn32, str_Adn22, str_Adn12
global str_Apal, str_Pal10, str_Arena, str_Pal11, str_Rink, str_Srlogo, str_SAtS, str_Pointer4
global str_Iff4, str_Scouting, str_Screen, str_Ctlogo, str_Logohome, str_Logoaway, str_Ctbkgd, str_Bkgd4
global str_Pal12, str_Cttitle1, str_Def, str_Fowa, str_Scra, str_Tlu, str_Top, str_Indus030
global str_GIPK, str_Iff5, str_Tonights, str_Injured, str_OpenBut, str_None, str_Del, str_Open
global str_Can, str_Noar, str_Up, str_Down, str_Arro, str_Gtno, str_Gtex, str_Gtlp
global str_Gtpo, str_Buf, str_Nhl, str_GsummaryDb3, str_Gsummary, str_Sav, str_Db2, str_PoGameSav
global str_LpGameSav, str_Open2, str_Delete, str_Done, str_Exhibition, str_Playoffs, str_League, str_Lp
global str_Po, str_Nhl2, str_Dialogbx, str_Dbox, str_Pointer5, str_Po2, str_ScheduleDb2, str_Lp2
global str_GameSet3, str_fedd2, str_GameSav3, str_Indus0302, str_Ctlogo2, str_Ctbkgd2, str_Bkgd5, str_Pal13
global str_Cttitle2, str_Summ2, str_OtShape, str_Per1, str_Per2, str_Per3, str_Top2, str_Cttitle12
global str_Def2, str_Fowa2, str_Scra2, str_Tlu2, str_Cttitle3, str_Ots, str_Colm, str_Gsummary2
global str_Iff6, str_Gamesum, str_Mtsum, str_Adsum, str_1st2, str_2nd2, str_3rd2, str_FinalOT
global str_Final, str_Period, str_Injured2, str_EVNT, str_PRDS, str_D5, str_St, str_Nd
global str_Rd, str_Th, str_SH, str_PP, str_02d02d, str_S2, str_SS4, str_DMinS
global str_ShotsOnGoal, str_SDD, str_Ctbkgd3, str_Pal14, str_Bkgd6, str_Cttitle32, str_Colm2, str_Gsta
global str_Ctlogo3, str_DD, str_D02d2, str_DDD, str_Iff7, str_Leaguetm, str_Mtsum2, str_Adsum2
global str_Pointer6, str_DBOX, str_Pointer7, str_Iff8, str_Maindesk, str_Tonights2, str_Easndesk, str_Desk2
global str_Pal15, str_Menubuff4, str_GameSet4, str_Game, str_Set, str_Palette2, str_Temp4, str_GameSav4
global str_Rink2, str_Til, str_InvalidFileSize, str_TILES, str_ErrorLoadingFile, str_Map, str_CRESTS3, str_Pal16
global str_Boxr, str_Boxb, str_Bkgd7, str_02d9D, str_Home, str_Away, str_SDD2, str_Pal17
global str_Calendar, str_Callogo, str_Iff9, str_Pointer8, str_Menubuff5, str_02d, str_GSUMMARY, str_Pal18
global str_Temp5, str_Easndesk2, str_GAME, str_SAV, str_Back, str_Callogo2, str_PLST, str_PTLS
global str_Pal19, str_TPI, str_Embnhl, str_Bkgd8, str_Pointer9, str_Iff10, str_Leaguetm2, str_Tspal
global str_Pal20, str_Menubuff6, str_WhoWillPlayThe, str_MightyDucksOfAnaheim3, str_02d2, str_SAV2, str_GAME2, str_SET
global str_GAME3, str_SAV3, str_02d3, str_Game2, str_Sav2, str_NHL2, str_CannotOpenNhlCfg, str_fmt4x
global str_Temp6, str_Tstat, str_Keys2, str_Pstat2, str_Gstat2, str_Embpal3, str_Pal21, str_Donepal
global str_TheJerseyNumber2d2, str_EnterJerseyNumberFor, str_Pal22, str_C2dS, str_HOMEPALS2, str_Embnhl2, str_Bkgd9, str_Pntr2
global str_Pointer10, str_Menubuff7, str_Lineditp, str_Shrt, str_fe1, str_fe2, str_fe3, str_fe4
global str_fe5, str_fe7, str_fe8, str_feB1, str_feB5, str_feB8, str_feD, str_feE
global str_feF, str_feG, str_feH, str_feI, str_feL, str_feM, str_feN, str_feO
global str_feP, str_feQ, str_fe9, str_feA, str_feB, str_feC, str_feJ, str_feK
global str_backslash3, str_PacificDivision, str_CentralDivision, str_NortheastDivision, str_AtlanticDivision, str_Season3, str_Playoff3, str_RegSeason
global str_Playoff4, str_Actual, str_Accumulated, str_embnhl, str_embscup, str_careerdb, str_seasondb, str_carteamsdb
global str_teamsdb, str_Speed, str_Agility, str_Weight, str_ShotPower, str_Checking2, str_StickHandling, str_Accuracy
global str_Passing2, str_OffensiveAwareness, str_DefensiveAwareness, str_Aggressiveness, str_Endurance, str_ShootPassBias, str_Faceoffs, str_GP2
global str_GloveLeft, str_GloveRight, str_StickLeft, str_StickRight, str_PuckControl, str_Speed2, str_Agility2, str_Weight2
global str_OffensiveAwareness2, str_DefensiveAwareness2, str_GP3, str_W2, str_L4, str_T2, str_SO2, str_EN2
global str_WesternConference3, str_EasternConference3, str_TeamScoring, str_TeamDefense, str_TeamPenaltyKilling, str_TeamPowerPlay, str_TeamPenalties, str_TeamStandings
global str_spW, str_SpL4, str_SpT, str_GF2, str_GA4, str_TSH, str_PPGA, str_PCT5
global str_BlankTeamColumn, str_ADV, str_PPG3, str_PIM5, str_AVG, str_PTS, str_WINS, str_GP4
global str_S, str_No, str_GP5, str_C, str_W3, str_L5, str_T3, str_PointLeaders
global str_GoalLeaders, str_AssistLeaders, str_PowerPlayGoalLeaders, str_ShorthandedGoalLeaders, str_PlusMinusLeaders, str_PenaltyMinuteLeaders, str_ShootingPercentageLeaders, str_GoalsAgainstAverageLeaders
global str_GoaltenderWinLeaders, str_SavePercentageLeaders, str_spG, str_spA, str_Pt3, str_BlankLeaderColumn, str_PP2, str_SHG3
global str_PlusMinus5, str_PIM6, str_Shots5, str_Pct6, str_MIN5, str_GA5, str_AVG2, str_spW2
global str_SpL5, str_SpT2, str_SA4, str_PCT7, str_NO, str_GP6, str_C2, str_LSSCEDDB
global str_SCHEDULEDB3, str_GP7, str_W4, str_L6, str_T4, str_D3, str_TwoSpaces, str_Space2
global str_D4, str_NHL, str_PO2, str_LP, str_fek1, str_fek2, str_fek3, str_fek4
global str_fek5, str_fek6, str_fek7, str_fek8, str_feh7, str_feA1, str_fel1, str_feA2
global str_fel2, str_fec6, str_fed2, str_fed3, str_fed4, str_D6, str_OT, str_S3
global str_CommaSp, str_RParen2, str_D7, str_Dot, str_Space, str_fee2, str_fee3, str_fee4
global TradeLabelText, str_D8, str_W5, str_L7, str_T5, str_qmark, str_wildcard, str_ID
global str_L1, str_L22, str_A5, str_DriveB, str_R3, str_S12
str_teams:                                      ; string 'teams'; used by LoadGameTeams
        db 074h,065h,061h,06Dh,073h,00h
str_fe1:                                        ; FatalError code "1" (key_team_db); used by LoadGameTeams
        db 031h,00h
str_fe2:                                        ; FatalError code "2" (key_team_db); used by LoadGameTeams
        db 032h,00h
str_fe3:                                        ; FatalError code "3" (key_team_db); used by LoadGameTeams
        db 033h,00h
str_fe4:                                        ; FatalError code "4" (key_team_db); used by LoadGameTeams
        db 034h,00h
str_fe5:                                        ; FatalError code "5" (key_team_db); used by LoadGameTeams
        db 035h,00h
str_fe7:                                        ; FatalError code "7" (key_team_db); used by LoadGameTeams
        db 037h,00h
str_fe8:                                        ; FatalError code "8" (key_team_db); used by LoadGameTeams
        db 038h,00h
str_feB1:                                       ; FatalError code "B1" (key_team_db); used by InitGameSummary
        db 042h,031h,00h
str_feB5:                                       ; FatalError code "B5" (key_team_db); used by InitGameSummary
        db 042h,035h,00h
str_feB8:                                       ; FatalError code "B8" (key_team_db); used by InitGameSummary
        db 042h,038h,00h
str_feD:                                        ; FatalError code "D" (key_team_db); used by ReadPlayerRecs
        db 044h,00h
str_feE:                                        ; FatalError code "E" (key_team_db); used by ReadPlayerRecs
        db 045h,00h
str_feF:                                        ; FatalError code "F" (key_team_db); used by ReadPlayerRecs
        db 046h,00h
str_feG:                                        ; FatalError code "G" (key_team_db); used by ReadPlayerRecs
        db 047h,00h
str_feH:                                        ; FatalError code "H" (key_team_db); used by ReadPlayerRecs
        db 048h,00h
str_feI:                                        ; FatalError code "I" (key_team_db); used by ReadPlayerRecs
        db 049h,00h
str_feL:                                        ; FatalError code "L" (key_team_db); used by OpenPlayerDBs,
                                                ; ReadPlayerRecs
        db 04Ch,00h
str_feM:                                        ; FatalError code "M" (key_team_db); used by OpenPlayerDBs,
                                                ; ReadPlayerRecs
        db 04Dh,00h
str_feN:                                        ; FatalError code "N" (key_team_db); used by ReadPlayerRecs
        db 04Eh,00h
str_feO:                                        ; FatalError code "O" (key_team_db); used by ReadPlayerRecs
        db 04Fh,00h
str_feP:                                        ; FatalError code "P" (key_team_db); used by ReadPlayerRecs
        db 050h,00h
str_feQ:                                        ; FatalError code "Q" (key_team_db); used by ReadPlayerRecs
        db 051h,00h
str_key:                                        ; string 'key'; used by OpenPlayerDBs
        db 06Bh,065h,079h,00h
str_fe9:                                        ; FatalError code "9" (key_team_db); used by OpenPlayerDBs
        db 039h,00h
str_feA:                                        ; FatalError code "A" (key_team_db); used by OpenPlayerDBs
        db 041h,00h
str_att:                                        ; string 'att'; used by OpenPlayerDBs
        db 061h,074h,074h,00h
str_feB:                                        ; FatalError code "B" (key_team_db); used by OpenPlayerDBs
        db 042h,00h
str_feC:                                        ; FatalError code "C" (key_team_db); used by OpenPlayerDBs
        db 043h,00h
str_season:                                     ; string 'season'; used by OpenPlayerDBs
        db 073h,065h,061h,073h,06Fh,06Eh,00h
str_feJ:                                        ; FatalError code "J" (key_team_db); used by OpenPlayerDBs
        db 04Ah,00h
str_feK:                                        ; FatalError code "K" (key_team_db); used by OpenPlayerDBs
        db 04Bh,00h
str_career:                                     ; string 'career'; used by OpenPlayerDBs
        db 063h,061h,072h,065h,065h,072h,00h
str_backslash3:                                 ; string '\\'; used by MakeGSummaryPath
        db 05Ch,00h
str_GsummaryDb2:                                ; string 'gsummary.db'; used by MakeGSummaryPath
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,02Eh,064h,062h,00h,00h,00h,00h
str_scrbrd1:                                    ; string; used by LoadScoreboardGfx
        db 073h,063h,072h,062h,072h,064h,031h,00h
str_LineCodes0:                                 ; string "0000000100020003000400050006000700080009000 "; used
                                                ; by LoadScoreboardGfx
        db 030h,030h,030h,030h,030h,030h,030h,031h,030h,030h,030h,032h,030h,030h,030h,033h
        db 030h,030h,030h,034h,030h,030h,030h,035h,030h,030h,030h,036h,030h,030h,030h,037h
        db 030h,030h,030h,038h,030h,030h,030h,039h,030h,030h,030h,020h,00h
str_LineCodes1:                                 ; string "1000100110021003100410051006100710081009100 "; used
                                                ; by LoadScoreboardGfx
        db 031h,030h,030h,030h,031h,030h,030h,031h,031h,030h,030h,032h,031h,030h,030h,033h
        db 031h,030h,030h,034h,031h,030h,030h,035h,031h,030h,030h,036h,031h,030h,030h,037h
        db 031h,030h,030h,038h,031h,030h,030h,039h,031h,030h,030h,020h,00h
str_LineCodes2:                                 ; string "2000200120022003200420052006200720082009200 "; used
                                                ; by LoadScoreboardGfx
        db 032h,030h,030h,030h,032h,030h,030h,031h,032h,030h,030h,032h,032h,030h,030h,033h
        db 032h,030h,030h,034h,032h,030h,030h,035h,032h,030h,030h,036h,032h,030h,030h,037h
        db 032h,030h,030h,038h,032h,030h,030h,039h,032h,030h,030h,020h,00h
str_VisLineTags:                                ; string 'vlinvpp vpk '; used by LoadScoreboardGfx
        db 076h,06Ch,069h,06Eh,076h,070h,070h,020h,076h,070h,06Bh,020h,00h
str_HomeLineTags:                               ; string 'hlinhpp hpk '; used by LoadScoreboardGfx
        db 068h,06Ch,069h,06Eh,068h,070h,070h,020h,068h,070h,06Bh,020h,00h
str_Visp:                                       ; string 'visp'; used by LoadScoreboardGfx
        db 076h,069h,073h,070h,00h
str_Homp:                                       ; string 'homp'; used by LoadScoreboardGfx
        db 068h,06Fh,06Dh,070h,00h
str_LineNames:                                  ; string 'lin1lin2lin3lin4PP1 PP2 PK1 PK2 '; used by
                                                ; LoadScoreboardGfx
        db 06Ch,069h,06Eh,031h,06Ch,069h,06Eh,032h,06Ch,069h,06Eh,033h,06Ch,069h,06Eh,034h
        db 050h,050h,031h,020h,050h,050h,032h,020h,050h,04Bh,031h,020h,050h,04Bh,032h,020h
        db 00h
str_PointerMenu:                                ; string; used by RunMenu, RunPlayerPickMenu, RunTeamPickMenu
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_menubuff:                                   ; string; used by RunMenu, RunPlayerPickMenu, RunTeamPickMenu
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h,00h,00h,00h
str_PacificDivision:                            ; "Pacific Division" string literal
        db 050h,061h,063h,069h,066h,069h,063h,020h,044h,069h,076h,069h,073h,069h,06Fh,06Eh
        db 00h
str_CentralDivision:                            ; "Central Division" string literal
        db 043h,065h,06Eh,074h,072h,061h,06Ch,020h,044h,069h,076h,069h,073h,069h,06Fh,06Eh
        db 00h
str_NortheastDivision:                          ; "Northeast Division" string literal
        db 04Eh,06Fh,072h,074h,068h,065h,061h,073h,074h,020h,044h,069h,076h,069h,073h,069h
        db 06Fh,06Eh,00h
str_AtlanticDivision:                           ; "Atlantic Division" string literal
        db 041h,074h,06Ch,061h,06Eh,074h,069h,063h,020h,044h,069h,076h,069h,073h,069h,06Fh
        db 06Eh,00h
str_Season3:                                    ; "Season:" string literal
        db 053h,065h,061h,073h,06Fh,06Eh,03Ah,00h
str_Playoff3:                                   ; "Playoff:" string literal
        db 050h,06Ch,061h,079h,06Fh,066h,066h,03Ah,00h
str_RegSeason:                                  ; "reg. season" string literal
        db 072h,065h,067h,02Eh,020h,073h,065h,061h,073h,06Fh,06Eh,00h
str_Playoff4:                                   ; "playoff " string literal
        db 070h,06Ch,061h,079h,06Fh,066h,066h,020h,020h,020h,020h,00h
str_Actual:                                     ; "actual " string literal
        db 061h,063h,074h,075h,061h,06Ch,020h,020h,020h,020h,020h,00h
str_Accumulated:                                ; "accumulated" string literal
        db 061h,063h,063h,075h,06Dh,075h,06Ch,061h,074h,065h,064h,00h
str_embnhl:                                     ; string
        db 065h,06Dh,062h,06Eh,068h,06Ch,00h
str_embscup:                                    ; string
        db 065h,06Dh,062h,073h,063h,075h,070h,00h
str_careerdb:                                   ; string
        db 063h,061h,072h,065h,065h,072h,02Eh,064h,062h,00h
str_seasondb:                                   ; string
        db 073h,065h,061h,073h,06Fh,06Eh,02Eh,064h,062h,00h
str_carteamsdb:                                 ; string
        db 063h,061h,072h,074h,065h,061h,06Dh,073h,02Eh,064h,062h,00h
str_teamsdb:                                    ; string
        db 074h,065h,061h,06Dh,073h,02Eh,064h,062h,00h
str_sfh:                                        ; string; used by LoadShapeByTag
        db 073h,066h,068h,00h
str_shape:                                      ; string; used by LoadShapeByTag
        db 073h,068h,061h,070h,065h,00h,00h,00h
str_embpal:                                     ; string; used by GameGoalieStatsScreen,
                                                ; GameSkaterStatsScreen, GameStandingsMenu ...
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal6:                                       ; string; used by GameGoalieStatsScreen,
                                                ; GameSkaterStatsScreen, GameStandingsMenu ...
        db 021h,070h,061h,06Ch,00h
str_tstat:                                      ; string; used by GameStandingsMenu
        db 074h,073h,074h,061h,074h,00h
str_keys:                                       ; string; used by GameStandingsMenu
        db 06Bh,065h,079h,073h,00h
str_pstat:                                      ; string; used by GameStandingsMenu
        db 070h,073h,074h,061h,074h,00h
str_gstat:                                      ; string; used by GameStandingsMenu
        db 067h,073h,074h,061h,074h,00h,00h
str_embpal2:                                    ; string; used by EasnGoalieStatsScreen_common,
                                                ; EasnGoalieStatsScreen_m, EasnSkaterStatsScreen_m ...
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal7:                                       ; string; used by EasnGoalieStatsScreen_common,
                                                ; EasnGoalieStatsScreen_m, EasnSkaterStatsScreen_m ...
        db 021h,070h,061h,06Ch,00h
str_easndesk2:                                  ; string; used by EasnGoalieStatsScreen_m,
                                                ; EasnSkaterStatsScreen_m
        db 065h,061h,073h,06Eh,064h,065h,073h,06Bh,00h
str_tstat2:                                     ; string; used by EasnStandingsMenu_m
        db 074h,073h,074h,061h,074h,00h
str_keys2:                                      ; string; used by EasnStandingsMenu_m
        db 06Bh,065h,079h,073h,00h
str_pstat2:                                     ; string; used by EasnStandingsMenu_m
        db 070h,073h,074h,061h,074h,00h
str_gstat2:                                     ; string; used by EasnStandingsMenu_m
        db 067h,073h,074h,061h,074h,00h
str_calendar:                                   ; string; used by LoadCalendarShapes
        db 063h,061h,06Ch,065h,06Eh,064h,061h,072h,00h
str_embpal3:                                    ; string; used by CalGoalieStatsScreen, CalSkaterStatsScreen,
                                                ; CalStandingsMenu ...
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal8:                                       ; string; used by CalGoalieStatsScreen, CalSkaterStatsScreen,
                                                ; CalStandingsMenu ...
        db 021h,070h,061h,06Ch,00h
str_tstat3:                                     ; string; used by CalStandingsMenu
        db 074h,073h,074h,061h,074h,00h
str_keys3:                                      ; string; used by CalStandingsMenu
        db 06Bh,065h,079h,073h,00h
str_pstat3:                                     ; string; used by CalStandingsMenu
        db 070h,073h,074h,061h,074h,00h
str_gstat3:                                     ; string; used by CalStandingsMenu
        db 067h,073h,074h,061h,074h,00h
str_Speed:                                      ; "Speed" string literal
        db 053h,070h,065h,065h,064h,00h
str_Agility:                                    ; "Agility" string literal
        db 041h,067h,069h,06Ch,069h,074h,079h,00h
str_Weight:                                     ; "Weight" string literal
        db 057h,065h,069h,067h,068h,074h,00h
str_ShotPower:                                  ; "Shot Power" string literal
        db 053h,068h,06Fh,074h,020h,050h,06Fh,077h,065h,072h,00h
str_Checking2:                                  ; "Checking" string literal
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_StickHandling:                              ; "StickHandling" string literal
        db 053h,074h,069h,063h,06Bh,048h,061h,06Eh,064h,06Ch,069h,06Eh,067h,00h
str_Accuracy:                                   ; "Accuracy" string literal
        db 041h,063h,063h,075h,072h,061h,063h,079h,00h
str_Passing2:                                   ; "Passing" string literal
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_OffensiveAwareness:                         ; "Offensive Awareness" string literal
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_DefensiveAwareness:                         ; "Defensive Awareness" string literal
        db 044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_Aggressiveness:                             ; "Aggressiveness" string literal
        db 041h,067h,067h,072h,065h,073h,073h,069h,076h,065h,06Eh,065h,073h,073h,00h
str_Endurance:                                  ; "Endurance" string literal
        db 045h,06Eh,064h,075h,072h,061h,06Eh,063h,065h,00h
str_ShootPassBias:                              ; "Shoot/Pass Bias" string literal
        db 053h,068h,06Fh,06Fh,074h,02Fh,050h,061h,073h,073h,020h,042h,069h,061h,073h,00h
str_Faceoffs:                                   ; "Faceoffs" string literal
        db 046h,061h,063h,065h,06Fh,066h,066h,073h,00h
str_PORTR:                                      ; string 'PORTR'; used by SkaterStatsCard
        db 050h,04Fh,052h,054h,052h,00h
str_Pstatbar3:                                  ; string 'pstatbar'; used by SkaterStatsCard
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst1:                                       ; string 'pst1'; used by SkaterStatsCard
        db 070h,073h,074h,031h,00h
str_Pst22:                                      ; string 'pst2'; used by SkaterStatsCard
        db 070h,073h,074h,032h,00h
str_PlayerStats:                                ; string 'Player Stats'; used by SkaterStatsCard
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,073h,00h
str_SS2:                                        ; string '%s %s'; used by SkaterStatsCard
        db 025h,073h,020h,025h,073h,00h
str_D2:                                         ; string '%d '; used by SkaterStatsCard
        db 025h,064h,020h,00h
str_Center2:                                    ; string 'Center'; used by SkaterStatsCard
        db 043h,065h,06Eh,074h,065h,072h,00h
str_Defense:                                    ; string 'Defense'; used by SkaterStatsCard
        db 044h,065h,066h,065h,06Eh,073h,065h,00h
str_LeftWing2:                                  ; string 'Left Wing'; used by SkaterStatsCard
        db 04Ch,065h,066h,074h,020h,057h,069h,06Eh,067h,00h
str_RightWing2:                                 ; string 'Right Wing'; used by SkaterStatsCard
        db 052h,069h,067h,068h,074h,020h,057h,069h,06Eh,067h,00h
str_GP2:                                        ; string 'GP'; used by SkaterStatsCard
        db 047h,050h,00h
str_G2:                                         ; string ' G'; used by SkaterStatsCard
        db 020h,020h,047h,00h
str_A2:                                         ; string ' A'; used by SkaterStatsCard
        db 020h,020h,041h,00h
str_Pt2:                                        ; string ' Pt'; used by SkaterStatsCard
        db 020h,050h,074h,00h
str_PIM2:                                       ; string 'PIM'; used by SkaterStatsCard
        db 050h,049h,04Dh,00h
str_PlusMinus2:                                 ; " +/-"; used by SkaterStatsCard
        db 020h,02Bh,02Fh,02Dh,00h
str_PPG2:                                       ; string 'PPG'; used by SkaterStatsCard
        db 050h,050h,047h,00h
str_SHG2:                                       ; string 'SHG'; used by SkaterStatsCard
        db 053h,048h,047h,00h
str_Shots2:                                     ; string 'Shots'; used by SkaterStatsCard
        db 053h,068h,06Fh,074h,073h,00h
str_Pct2:                                       ; string ' Pct'; used by SkaterStatsCard
        db 020h,020h,050h,063h,074h,00h
str_Ratings2:                                   ; string 'Ratings:'; used by SkaterStatsCard
        db 052h,061h,074h,069h,06Eh,067h,073h,03Ah,00h
str_Shoots2:                                    ; string 'Shoots'; used by SkaterStatsCard
        db 053h,068h,06Fh,06Fh,074h,073h,00h
str_L2:                                         ; string ' L'; used by SkaterStatsCard
        db 020h,020h,04Ch,00h
str_R:                                          ; string ' R'; used by SkaterStatsCard
        db 020h,020h,052h,00h,00h,00h
str_GloveLeft:                                  ; "Glove Left" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,04Ch,065h,066h,074h,00h
str_GloveRight:                                 ; "Glove Right" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,052h,069h,067h,068h,074h,00h
str_StickLeft:                                  ; "Stick Left" string literal
        db 053h,074h,069h,063h,06Bh,020h,04Ch,065h,066h,074h,00h
str_StickRight:                                 ; "Stick Right" string literal
        db 053h,074h,069h,063h,06Bh,020h,052h,069h,067h,068h,074h,00h
str_PuckControl:                                ; "Puck Control" string literal
        db 050h,075h,063h,06Bh,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch,00h
str_Speed2:                                     ; "Speed" string literal
        db 053h,070h,065h,065h,064h,00h
str_Agility2:                                   ; "Agility" string literal
        db 041h,067h,069h,06Ch,069h,074h,079h,00h
str_Weight2:                                    ; "Weight" string literal
        db 057h,065h,069h,067h,068h,074h,00h
str_OffensiveAwareness2:                        ; "Offensive Awareness" string literal
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_DefensiveAwareness2:                        ; "Defensive Awareness" string literal
        db 044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_PORTR2:                                     ; string 'PORTR'; used by GoalieStatsCard
        db 050h,04Fh,052h,054h,052h,00h
str_Pstatbar4:                                  ; string 'pstatbar'; used by GoalieStatsCard
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst12:                                      ; string 'pst1'; used by GoalieStatsCard
        db 070h,073h,074h,031h,00h
str_Pst23:                                      ; string 'pst2'; used by GoalieStatsCard
        db 070h,073h,074h,032h,00h
str_PlayerStats2:                               ; string 'Player Stats'; used by GoalieStatsCard
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,073h,00h
str_SS3:                                        ; string '%s %s'; used by GoalieStatsCard
        db 025h,073h,020h,025h,073h,00h
str_DGoalie:                                    ; string '%d Goalie'; used by GoalieStatsCard
        db 025h,064h,020h,047h,06Fh,061h,06Ch,069h,065h,00h
str_GP3:                                        ; string 'GP'; used by GoalieStatsCard
        db 047h,050h,00h
str_Min2:                                       ; string ' Min'; used by GoalieStatsCard
        db 020h,04Dh,069h,06Eh,00h
str_GAA2:                                       ; string ' GAA'; used by GoalieStatsCard
        db 020h,020h,047h,041h,041h,00h
str_W2:                                         ; string ' W'; used by GoalieStatsCard
        db 020h,057h,00h
str_L4:                                         ; string ' L'; used by GoalieStatsCard
        db 020h,04Ch,00h
str_T2:                                         ; string ' T'; used by GoalieStatsCard
        db 020h,054h,00h
str_SO2:                                        ; string 'SO'; used by GoalieStatsCard
        db 053h,04Fh,00h
str_EN2:                                        ; string 'EN'; used by GoalieStatsCard
        db 045h,04Eh,00h
str_SA:                                         ; string ' SA'; used by GoalieStatsCard
        db 020h,020h,020h,053h,041h,00h
str_Pct3:                                       ; string ' Pct'; used by GoalieStatsCard
        db 020h,020h,050h,063h,074h,00h
str_Ratings3:                                   ; string 'Ratings:'; used by GoalieStatsCard
        db 052h,061h,074h,069h,06Eh,067h,073h,03Ah,00h
str_GloveHand2:                                 ; string 'Glove Hand'; used by GoalieStatsCard
        db 047h,06Ch,06Fh,076h,065h,020h,048h,061h,06Eh,064h,00h
str_L3:                                         ; string ' L'; used by GoalieStatsCard
        db 020h,020h,04Ch,00h
str_R2:                                         ; string ' R'; used by GoalieStatsCard
        db 020h,020h,052h,00h,00h
str_WesternConference3:                         ; "Western Conference" string literal
        db 057h,065h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_EasternConference3:                         ; "Eastern Conference" string literal
        db 045h,061h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_TeamScoring:                                ; " Team Scoring" string literal
        db 020h,054h,065h,061h,06Dh,020h,053h,063h,06Fh,072h,069h,06Eh,067h,00h
str_TeamDefense:                                ; " Team Defense" string literal
        db 020h,054h,065h,061h,06Dh,020h,044h,065h,066h,065h,06Eh,073h,065h,00h
str_TeamPenaltyKilling:                         ; " Team Penalty Killing" string literal
        db 020h,054h,065h,061h,06Dh,020h,050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h
        db 06Ch,06Ch,069h,06Eh,067h,00h
str_TeamPowerPlay:                              ; " Team Power Play" string literal
        db 020h,054h,065h,061h,06Dh,020h,050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h
        db 00h
str_TeamPenalties:                              ; " Team Penalties" string literal
        db 020h,054h,065h,061h,06Dh,020h,050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,00h
str_TeamStandings:                              ; " Team Standings" string literal
        db 020h,054h,065h,061h,06Dh,020h,053h,074h,061h,06Eh,064h,069h,06Eh,067h,073h,00h
str_spW:                                        ; string ' W'
        db 020h,057h,00h
str_SpL4:                                       ; string ' L'
        db 020h,04Ch,00h
str_SpT:                                        ; string ' T'
        db 020h,054h,00h
str_GF2:                                        ; " GF" string literal
        db 020h,047h,046h,00h
str_GA4:                                        ; " GA" string literal
        db 020h,047h,041h,00h
str_TSH:                                        ; "TSH" string literal
        db 054h,053h,048h,00h
str_PPGA:                                       ; "PPGA" string literal
        db 050h,050h,047h,041h,00h
str_PCT5:                                       ; " PCT" string literal
        db 020h,020h,050h,043h,054h,00h
str_BlankTeamColumn:                            ; Empty team statistics column header
        db 00h
str_ADV:                                        ; "ADV" string literal
        db 041h,044h,056h,00h
str_PPG3:                                       ; "PPG" string literal
        db 050h,050h,047h,00h
str_PIM5:                                       ; " PIM" string literal
        db 020h,050h,049h,04Dh,00h
str_AVG:                                        ; " AVG" string literal
        db 020h,020h,041h,056h,047h,00h
str_PTS:                                        ; "PTS" string literal
        db 050h,054h,053h,00h
str_WINS:                                       ; "WINS" string literal
        db 057h,049h,04Eh,053h,00h
str_Teams:                                      ; string 'teams'; used by TeamStatsScreen
        db 074h,065h,061h,06Dh,073h,00h
str_Addsort:                                    ; string 'addsort'; used by TeamStatsScreen
        db 061h,064h,064h,073h,06Fh,072h,074h,00h
str_Pstatbar5:                                  ; string 'pstatbar'; used by TeamStatsScreen_keyPen
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst24:                                      ; string 'pst2'; used by TeamStatsScreen_keyPen
        db 070h,073h,074h,032h,00h
str_StatsUnavailable:                           ; string 'Stats Unavailable'; used by TeamStatsScreen_keyPen
        db 053h,074h,061h,074h,073h,020h,055h,06Eh,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_GP4:                                        ; string 'GP'; used by TeamStatsScreen_keyPen
        db 047h,050h,00h
str_ANA2:                                       ; string 'ANA'; used by TeamStatsScreen_keyPen
        db 041h,04Eh,041h,00h
str_MightyDucksOfAnaheim:                       ; string 'Mighty Ducks of Anaheim'; used by
                                                ; TeamStatsScreen_keyPen
        db 04Dh,069h,067h,068h,074h,079h,020h,044h,075h,063h,06Bh,073h,020h,06Fh,066h,020h
        db 041h,06Eh,061h,068h,065h,069h,06Dh,00h
str_Dashes39:                                   ; 39 dashes; used by TeamStatsScreen_keyPen
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,00h
str_Dashes36:                                   ; 36 dashes; used by TeamStatsScreen_keyPen
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,00h
str_KeyDb:                                      ; string 'key.db'; used by TeamRosterScreen
        db 06Bh,065h,079h,02Eh,064h,062h,00h
str_Pstatbar6:                                  ; string 'pstatbar'; used by TeamRosterScreen
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst25:                                      ; string 'pst2'; used by TeamRosterScreen
        db 070h,073h,074h,032h,00h
str_S:                                          ; string '%s'; used by TeamRosterScreen
        db 025h,073h,00h
str_Trad:                                       ; string 'trad'; used by TeamRosterScreen
        db 074h,072h,061h,064h,00h
str_Regi:                                       ; string 'regi'; used by TeamRosterScreen
        db 072h,065h,067h,069h,00h
str_MightyDucksOfAnaheim2:                      ; string 'Mighty Ducks of Anaheim'; used by TeamRosterScreen
        db 04Dh,069h,067h,068h,074h,079h,020h,044h,075h,063h,06Bh,073h,020h,020h,06Fh,066h
        db 020h,041h,06Eh,061h,068h,065h,069h,06Dh,00h
str_Pos:                                        ; string 'Pos'; used by TeamRosterScreen
        db 050h,06Fh,073h,00h
str_No:                                         ; string 'No'; used by TeamRosterScreen
        db 04Eh,06Fh,00h
str_Name:                                       ; string 'Name'; used by TeamRosterScreen
        db 04Eh,061h,06Dh,065h,00h
str_GP5:                                        ; string 'GP'; used by TeamRosterScreen
        db 047h,050h,00h
str_G3:                                         ; string ' G'; used by TeamRosterScreen
        db 020h,020h,047h,00h
str_A3:                                         ; string ' A'; used by TeamRosterScreen
        db 020h,020h,041h,00h
str_PT:                                         ; string ' PT'; used by TeamRosterScreen
        db 020h,050h,054h,00h
str_Shots3:                                     ; string 'Shots'; used by TeamRosterScreen
        db 053h,068h,06Fh,074h,073h,00h
str_PIM3:                                       ; string 'PIM'; used by TeamRosterScreen
        db 050h,049h,04Dh,00h
str_PlusMinus3:                                 ; " +/-"; used by TeamRosterScreen
        db 020h,02Bh,02Fh,02Dh,00h
str_C:                                          ; string '%c'; used by TeamRosterScreen
        db 025h,063h,00h
str_Min3:                                       ; string ' Min'; used by TeamRosterScreen
        db 020h,04Dh,069h,06Eh,00h
str_GAA3:                                       ; string ' GAA'; used by TeamRosterScreen
        db 020h,020h,047h,041h,041h,00h
str_W3:                                         ; string ' W'; used by TeamRosterScreen
        db 020h,057h,00h
str_L5:                                         ; string ' L'; used by TeamRosterScreen
        db 020h,04Ch,00h
str_T3:                                         ; string ' T'; used by TeamRosterScreen
        db 020h,054h,00h
str_GA:                                         ; string ' GA'; used by TeamRosterScreen
        db 020h,047h,041h,00h
str_SA2:                                        ; string ' SA'; used by TeamRosterScreen
        db 020h,020h,053h,041h,00h
str_PCT:                                        ; string ' PCT'; used by TeamRosterScreen
        db 020h,020h,050h,043h,054h,00h,00h
str_PointLeaders:                               ; " Point Leaders" string literal
        db 020h,050h,06Fh,069h,06Eh,074h,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_GoalLeaders:                                ; " Goal Leaders" string literal
        db 020h,047h,06Fh,061h,06Ch,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_AssistLeaders:                              ; " Assist Leaders" string literal
        db 020h,041h,073h,073h,069h,073h,074h,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_PowerPlayGoalLeaders:                       ; " Power Play Goal Leaders" string literal
        db 020h,050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,047h,06Fh,061h,06Ch
        db 020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_ShorthandedGoalLeaders:                     ; " Shorthanded Goal Leaders" string literal
        db 020h,053h,068h,06Fh,072h,074h,068h,061h,06Eh,064h,065h,064h,020h,047h,06Fh,061h
        db 06Ch,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_PlusMinusLeaders:                           ; " Plus/Minus Leaders" string literal
        db 020h,050h,06Ch,075h,073h,02Fh,04Dh,069h,06Eh,075h,073h,020h,04Ch,065h,061h,064h
        db 065h,072h,073h,00h
str_PenaltyMinuteLeaders:                       ; " Penalty Minute Leaders" string literal
        db 020h,050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Dh,069h,06Eh,075h,074h,065h,020h
        db 04Ch,065h,061h,064h,065h,072h,073h,00h
str_ShootingPercentageLeaders:                  ; " Shooting Percentage Leaders" string literal
        db 020h,053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,020h,050h,065h,072h,063h,065h,06Eh
        db 074h,061h,067h,065h,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_GoalsAgainstAverageLeaders:                 ; " Goals Against Average Leaders" string literal
        db 020h,047h,06Fh,061h,06Ch,073h,020h,041h,067h,061h,069h,06Eh,073h,074h,020h,041h
        db 076h,065h,072h,061h,067h,065h,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_GoaltenderWinLeaders:                       ; " Goaltender Win Leaders" string literal
        db 020h,047h,06Fh,061h,06Ch,074h,065h,06Eh,064h,065h,072h,020h,057h,069h,06Eh,020h
        db 04Ch,065h,061h,064h,065h,072h,073h,00h
str_SavePercentageLeaders:                      ; " Save Percentage Leaders" string literal
        db 020h,053h,061h,076h,065h,020h,050h,065h,072h,063h,065h,06Eh,074h,061h,067h,065h
        db 020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_spG:                                        ; string ' G'
        db 020h,020h,047h,00h
str_spA:                                        ; string ' A'
        db 020h,020h,041h,00h
str_Pt3:                                        ; " Pt" string literal
        db 020h,050h,074h,00h
str_BlankLeaderColumn:                          ; Empty league leader column header
        db 00h
str_PP2:                                        ; "PP" string literal
        db 050h,050h,00h
str_SHG3:                                       ; "SHG" string literal
        db 053h,048h,047h,00h
str_PlusMinus5:                                 ; string ' +/-'
        db 020h,02Bh,02Fh,02Dh,00h
str_PIM6:                                       ; "PIM" string literal
        db 050h,049h,04Dh,00h
str_Shots5:                                     ; "Shots" string literal
        db 053h,068h,06Fh,074h,073h,00h
str_Pct6:                                       ; " Pct" string literal
        db 020h,020h,050h,063h,074h,00h
str_MIN5:                                       ; " MIN" string literal
        db 020h,04Dh,049h,04Eh,00h
str_GA5:                                        ; " GA" string literal
        db 020h,047h,041h,00h
str_AVG2:                                       ; " AVG" string literal
        db 020h,020h,041h,056h,047h,00h
str_spW2:                                       ; string ' W'
        db 020h,057h,00h
str_SpL5:                                       ; string ' L'
        db 020h,04Ch,00h
str_SpT2:                                       ; string ' T'
        db 020h,054h,00h
str_SA4:                                        ; " SA" string literal
        db 020h,020h,053h,041h,00h
str_PCT7:                                       ; " PCT" string literal
        db 020h,020h,050h,043h,054h,00h
str_Keys:                                       ; string 'keys'; used by LeadersScreen
        db 06Bh,065h,079h,073h,00h
str_Pstat:                                      ; string 'pstat'; used by LeadersScreen
        db 070h,073h,074h,061h,074h,00h
str_Gstat:                                      ; string 'gstat'; used by LeadersScreen
        db 067h,073h,074h,061h,074h,00h
str_Addsort2:                                   ; string 'addsort'; used by LeadersScreen
        db 061h,064h,064h,073h,06Fh,072h,074h,00h
str_KeyDb2:                                     ; string 'key.db'; used by LeadersScreen
        db 06Bh,065h,079h,02Eh,064h,062h,00h
str_Pstatbar7:                                  ; string 'pstatbar'; used by LeadersScreen
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst26:                                      ; string 'pst2'; used by LeadersScreen
        db 070h,073h,074h,032h,00h
str_StatsUnavailable2:                          ; string 'Stats Unavailable'; used by LeadersScreen
        db 053h,074h,061h,074h,073h,020h,055h,06Eh,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_POS:                                        ; string 'POS'; used by LeadersScreen
        db 050h,04Fh,053h,00h
str_NO:                                         ; string 'NO'; used by LeadersScreen
        db 04Eh,04Fh,00h
str_PLAYER2:                                    ; string 'PLAYER'; used by LeadersScreen
        db 050h,04Ch,041h,059h,045h,052h,00h
str_TEAM:                                       ; string 'TEAM'; used by LeadersScreen
        db 054h,045h,041h,04Dh,00h
str_GP6:                                        ; string 'GP'; used by LeadersScreen
        db 047h,050h,00h
str_C2:                                         ; string '%c'; used by LeadersScreen
        db 025h,063h,00h,00h,00h
str_LSSCEDDB:                                   ; "LSSCED.DB" string literal
        db 04Ch,053h,053h,043h,045h,044h,02Eh,044h,042h,00h
str_SCHEDULEDB3:                                ; "SCHEDULE.DB" string literal
        db 053h,043h,048h,045h,044h,055h,04Ch,045h,02Eh,044h,042h,00h
str_Pstatbar8:                                  ; string 'pstatbar'; used by PlayoffTreeScreen,
                                                ; StandingsScreen
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst27:                                      ; string 'pst2'; used by StandingsScreen
        db 070h,073h,074h,032h,00h
str_Standings:                                  ; string ' Standings'; used by PlayoffTreeScreen,
                                                ; StandingsScreen
        db 020h,053h,074h,061h,06Eh,064h,069h,06Eh,067h,073h,00h
str_Western:                                    ; string 'Western'; used by StandingsScreen
        db 057h,065h,073h,074h,065h,072h,06Eh,00h
str_Conference:                                 ; string 'Conference'; used by StandingsScreen
        db 043h,06Fh,06Eh,066h,065h,072h,065h,06Eh,063h,065h,00h
str_Eastern:                                    ; string 'Eastern'; used by StandingsScreen
        db 045h,061h,073h,074h,065h,072h,06Eh,00h
str_Team:                                       ; string 'Team'; used by StandingsScreen
        db 054h,065h,061h,06Dh,00h
str_GP7:                                        ; string 'GP'; used by StandingsScreen
        db 047h,050h,00h
str_W4:                                         ; string ' W'; used by StandingsScreen
        db 020h,057h,00h
str_L6:                                         ; string ' L'; used by StandingsScreen
        db 020h,04Ch,00h
str_T4:                                         ; string ' T'; used by StandingsScreen
        db 020h,054h,00h
str_GF:                                         ; string ' GF'; used by StandingsScreen
        db 020h,047h,046h,00h
str_GA2:                                        ; string ' GA'; used by StandingsScreen
        db 020h,047h,041h,00h
str_P:                                          ; string ' P'; used by StandingsScreen
        db 020h,020h,050h,00h
str_Pct4:                                       ; string ' Pct'; used by StandingsScreen
        db 020h,020h,050h,063h,074h,00h
str_Embpal2:                                    ; string 'embpal'; used by PlayoffTreeScreen
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal9:                                       ; string '!pal'; used by PlayoffTreeScreen
        db 021h,070h,061h,06Ch,00h
str_PlayoffsHaveNotBeen2:                       ; string 'Playoffs have not been seeded yet'; used by
                                                ; PlayoffTreeScreen
        db 050h,06Ch,061h,079h,06Fh,066h,066h,073h,020h,068h,061h,076h,065h,020h,06Eh,06Fh
        db 074h,020h,062h,065h,065h,06Eh,020h,073h,065h,065h,064h,065h,064h,020h,079h,065h
        db 074h,00h
str_Rst12:                                      ; string 'rst1'; used by PlayoffTreeScreen
        db 072h,073h,074h,031h,00h
str_Rst22:                                      ; string 'rst2'; used by PlayoffTreeScreen
        db 072h,073h,074h,032h,00h
str_Scuparrw2:                                  ; string 'scuparrw'; used by PlayoffTreeScreen
        db 073h,063h,075h,070h,061h,072h,072h,077h,00h
str_WesternConference2:                         ; string 'Western Conference'; used by PlayoffTreeScreen
        db 057h,065h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_EasternConference2:                         ; string 'Eastern Conference'; used by PlayoffTreeScreen
        db 045h,061h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_C3:                                         ; string '%c '; used by PlayoffTreeScreen
        db 025h,063h,020h,00h
str_D3:                                         ; string '%d'; used by PlayoffTreeScreen
        db 025h,064h,00h
str_Aup12:                                      ; string 'aup1'; used by PlayoffTreeScreen
        db 061h,075h,070h,031h,00h
str_Aup22:                                      ; string 'aup2'; used by PlayoffTreeScreen
        db 061h,075h,070h,032h,00h
str_Aup32:                                      ; string 'aup3'; used by PlayoffTreeScreen
        db 061h,075h,070h,033h,00h
str_Midl2:                                      ; string 'midl'; used by PlayoffTreeScreen
        db 06Dh,069h,064h,06Ch,00h
str_TwoSpaces:                                  ; " "; used by PlayoffTreeScreen
        db 020h,020h,00h
str_Adn32:                                      ; string 'adn3'; used by PlayoffTreeScreen
        db 061h,064h,06Eh,033h,00h
str_Adn22:                                      ; string 'adn2'; used by PlayoffTreeScreen
        db 061h,064h,06Eh,032h,00h
str_Adn12:                                      ; string 'adn1'; used by PlayoffTreeScreen
        db 061h,064h,06Eh,031h,00h
str_Space2:                                     ; " " blank tree name; used by LoadLeagueTree
        db 020h,00h,00h
str_Apal:                                       ; string 'apal'; used by PreGameScreen
        db 061h,070h,061h,06Ch,00h
str_Pal10:                                      ; string 'Pal'; used by PreGameScreen, PreGameScreen_homelines
        db 050h,061h,06Ch,00h
str_Arena:                                      ; string 'arena'; used by PreGameScreen
        db 061h,072h,065h,06Eh,061h,00h
str_Pal11:                                      ; string '!pal'; used by PreGameScreen
        db 021h,070h,061h,06Ch,00h
str_Rink:                                       ; string 'rink'; used by PreGameScreen
        db 072h,069h,06Eh,06Bh,00h
str_Srlogo:                                     ; string 'srlogo'; used by PreGameScreen
        db 073h,072h,06Ch,06Fh,067h,06Fh,00h
str_SAtS:                                       ; string '%s at %s'; used by PreGameScreen
        db 025h,073h,020h,020h,020h,061h,074h,020h,020h,020h,025h,073h,00h
str_D4:                                         ; string '%d'; used by PreGameScreen
        db 025h,064h,00h
str_Pointer4:                                   ; string 'Pointer'; used by PreGameScreen
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff4:                                       ; string '.iff'; used by PreGameScreen
        db 02Eh,069h,066h,066h,00h
str_Scouting:                                   ; string 'scouting'; used by PreGameScreen
        db 073h,063h,06Fh,075h,074h,069h,06Eh,067h,00h
str_Screen:                                     ; string 'Screen'; used by PreGameScreen_awaylines,
                                                ; PreGameScreen_homelines
        db 053h,063h,072h,065h,065h,06Eh,00h,00h,00h,00h
str_Ctlogo:                                     ; string 'ctlogo'; used by TonightsGameScreen
        db 063h,074h,06Ch,06Fh,067h,06Fh,00h
str_Logohome:                                   ; string 'logohome'; used by TonightsGameScreen
        db 06Ch,06Fh,067h,06Fh,068h,06Fh,06Dh,065h,00h
str_Logoaway:                                   ; string 'logoaway'; used by TonightsGameScreen
        db 06Ch,06Fh,067h,06Fh,061h,077h,061h,079h,00h
str_Ctbkgd:                                     ; string 'ctbkgd'; used by TonightsGameScreen
        db 063h,074h,062h,06Bh,067h,064h,00h
str_Bkgd4:                                      ; string 'bkgd'; used by TonightsGameScreen
        db 062h,06Bh,067h,064h,00h
str_Pal12:                                      ; string '!pal'; used by TonightsGameScreen
        db 021h,070h,061h,06Ch,00h
str_Cttitle1:                                   ; string 'cttitle1'; used by TonightsGameScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,031h,00h
str_Def:                                        ; string 'def '; used by TonightsGameScreen
        db 064h,065h,066h,020h,00h
str_Fowa:                                       ; string 'fowa'; used by TonightsGameScreen
        db 066h,06Fh,077h,061h,00h
str_Scra:                                       ; string 'scra'; used by TonightsGameScreen
        db 073h,063h,072h,061h,00h
str_Tlu:                                        ; string 'tlu '; used by TonightsGameScreen
        db 074h,06Ch,075h,020h,00h
str_Top:                                        ; string 'top '; used by TonightsGameScreen
        db 074h,06Fh,070h,020h,00h
str_Indus030:                                   ; string 'indus030'; used by TonightsGameScreen
        db 069h,06Eh,064h,075h,073h,030h,033h,030h,00h
str_GIPK:                                       ; string 'GIPK'; used by TonightsGameScreen
        db 047h,049h,050h,04Bh,00h
str_Iff5:                                       ; string '.iff'; used by TonightsGameScreen
        db 02Eh,069h,066h,066h,00h
str_Tonights:                                   ; string 'tonights'; used by TonightsGameScreen
        db 074h,06Fh,06Eh,069h,067h,068h,074h,073h,00h
str_Injured:                                    ; string 'Injured'; used by TonightsGameScreen
        db 049h,06Eh,06Ah,075h,072h,065h,064h,00h
str_NHL:                                        ; string '.NHL'; used by savefileexts
        db 02Eh,04Eh,048h,04Ch,00h
str_PO2:                                        ; string '.PO'; used by savefileexts
        db 02Eh,050h,04Fh,00h
str_LP:                                         ; string '.LP'; used by savefileexts
        db 02Eh,04Ch,050h,00h
str_OpenBut:                                    ; string 'open_but'; used by LoadFileDlgShapes
        db 06Fh,070h,065h,06Eh,05Fh,062h,075h,074h,00h
str_None:                                       ; string 'none'; used by LoadFileDlgShapes
        db 06Eh,06Fh,06Eh,065h,00h
str_Del:                                        ; string 'del '; used by LoadFileDlgShapes
        db 064h,065h,06Ch,020h,00h
str_Open:                                       ; string 'open'; used by LoadFileDlgShapes
        db 06Fh,070h,065h,06Eh,00h
str_Can:                                        ; string 'can '; used by LoadFileDlgShapes
        db 063h,061h,06Eh,020h,00h
str_Noar:                                       ; string 'noar'; used by LoadFileDlgShapes
        db 06Eh,06Fh,061h,072h,00h
str_Up:                                         ; string 'up '; used by LoadFileDlgShapes
        db 075h,070h,020h,020h,00h
str_Down:                                       ; string 'down'; used by LoadFileDlgShapes
        db 064h,06Fh,077h,06Eh,00h
str_Arro:                                       ; string 'arro'; used by LoadFileDlgShapes
        db 061h,072h,072h,06Fh,00h
str_Gtno:                                       ; string 'gtno'; used by LoadFileDlgShapes
        db 067h,074h,06Eh,06Fh,00h
str_Gtex:                                       ; string 'gtex'; used by LoadFileDlgShapes
        db 067h,074h,065h,078h,00h
str_Gtlp:                                       ; string 'gtlp'; used by LoadFileDlgShapes
        db 067h,074h,06Ch,070h,00h
str_Gtpo:                                       ; string 'gtpo'; used by LoadFileDlgShapes
        db 067h,074h,070h,06Fh,00h
str_Buf:                                        ; string 'buf'; used by MenuOpenSaved
        db 062h,075h,066h,00h
str_Nhl:                                        ; string '.nhl'; used by MenuOpenSaved, SelectSavedFile
        db 02Eh,06Eh,068h,06Ch,00h
str_fek1:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,031h,00h
str_GsummaryDb3:                                ; string 'gsummary.db'; used by MenuOpenSaved
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,02Eh,064h,062h,00h
str_fek2:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,032h,00h
str_fek3:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,033h,00h
str_fek4:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,034h,00h
str_fek5:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,035h,00h
str_fek6:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,036h,00h
str_fek7:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,037h,00h
str_fek8:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,038h,00h
str_feh7:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 068h,037h,00h
str_Gsummary:                                   ; string 'gsummary'; used by MenuOpenSaved
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,00h
str_Sav:                                        ; string '.sav'; used by MenuOpenSaved
        db 02Eh,073h,061h,076h,00h
str_Db2:                                        ; string '.db'; used by MenuOpenSaved
        db 02Eh,064h,062h,00h
str_feA1:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 041h,031h,00h
str_PoGameSav:                                  ; string '.po\\game.sav'; used by MenuOpenSaved
        db 02Eh,070h,06Fh,05Ch,067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h
str_fel1:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Ch,031h,00h
str_feA2:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 041h,032h,00h
str_LpGameSav:                                  ; string '.lp\\game.sav'; used by MenuOpenSaved
        db 02Eh,06Ch,070h,05Ch,067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h
str_fel2:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Ch,032h,00h
str_Open2:                                      ; string 'Open'; used by DrawFileDlgTabs
        db 04Fh,070h,065h,06Eh,00h
str_Delete:                                     ; string 'Delete'; used by DrawFileDlgTabs
        db 044h,065h,06Ch,065h,074h,065h,00h
str_Done:                                       ; string 'Done'; used by DrawFileDlgTabs
        db 044h,06Fh,06Eh,065h,00h
str_Exhibition:                                 ; string 'Exhibition'; used by DrawFileDlgTabs
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,00h
str_Playoffs:                                   ; string 'Playoffs'; used by DrawFileDlgTabs
        db 050h,06Ch,061h,079h,06Fh,066h,066h,073h,00h
str_League:                                     ; string 'League'; used by DrawFileDlgTabs
        db 04Ch,065h,061h,067h,075h,065h,00h
str_Lp:                                         ; string '*.lp'; used by ScanSavedGames
        db 02Ah,02Eh,06Ch,070h,00h
str_Po:                                         ; string '*.po'; used by ScanSavedGames
        db 02Ah,02Eh,070h,06Fh,00h
str_Nhl2:                                       ; string '*.nhl'; used by ScanSavedGames
        db 02Ah,02Eh,06Eh,068h,06Ch,00h
str_Dialogbx:                                   ; string 'dialogbx'; used by DrawFileDlg
        db 064h,069h,061h,06Ch,06Fh,067h,062h,078h,00h
str_Dbox:                                       ; string 'dbox'; used by DrawFileDlg
        db 064h,062h,06Fh,078h,00h
str_Pointer5:                                   ; string 'Pointer'; used by RunFileDlg
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_fec6:                                       ; FatalError code (file_dialogs); used by DeleteSavedGame
        db 063h,036h,00h
str_Po2:                                        ; string '.po'; used by SelectSavedFile
        db 02Eh,070h,06Fh,00h
str_ScheduleDb2:                                ; string 'schedule.db'; used by SelectSavedFile
        db 073h,063h,068h,065h,064h,075h,06Ch,065h,02Eh,064h,062h,00h
str_Lp2:                                        ; string '.lp'; used by SelectSavedFile
        db 02Eh,06Ch,070h,00h
str_GameSet3:                                   ; string 'game.set'; used by ReadGameSettings
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_fed2:                                       ; FatalError code (file_dialogs); used by ReadGameSettings
        db 064h,032h,00h
str_fedd2:                                      ; FatalError code (file_dialogs); used by ReadGameSettings
        db 064h,064h,032h,00h
str_fed3:                                       ; FatalError code (file_dialogs); used by ReadGameSettings
        db 064h,033h,00h
str_fed4:                                       ; FatalError code (file_dialogs); used by ReadGameSettings
        db 064h,034h,00h
str_GameSav3:                                   ; string 'game.sav'; used by ReadGameSettings
        db 067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h,00h,00h
str_Indus0302:                                  ; string 'indus030'; used by GameSummaryScreen
        db 069h,06Eh,064h,075h,073h,030h,033h,030h,00h
str_Ctlogo2:                                    ; string 'ctlogo'; used by GameSummaryScreen
        db 063h,074h,06Ch,06Fh,067h,06Fh,00h
str_Ctbkgd2:                                    ; string 'ctbkgd'; used by GameSummaryScreen
        db 063h,074h,062h,06Bh,067h,064h,00h
str_Bkgd5:                                      ; string 'bkgd'; used by GameSummaryScreen
        db 062h,06Bh,067h,064h,00h
str_Pal13:                                      ; string '!pal'; used by GameSummaryScreen
        db 021h,070h,061h,06Ch,00h
str_Cttitle2:                                   ; string 'cttitle2'; used by GameSummaryScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,032h,00h
str_Summ2:                                      ; string 'summ'; used by GameSummaryScreen
        db 073h,075h,06Dh,06Dh,00h
str_OtShape:                                    ; string 'ot '; used by GameSummaryScreen
        db 06Fh,074h,020h,020h,00h
str_Per1:                                       ; string 'per1'; used by GameSummaryScreen
        db 070h,065h,072h,031h,00h
str_Per2:                                       ; string 'per2'; used by GameSummaryScreen
        db 070h,065h,072h,032h,00h
str_Per3:                                       ; string 'per3'; used by GameSummaryScreen
        db 070h,065h,072h,033h,00h
str_Top2:                                       ; string 'top '; used by GameSummaryScreen
        db 074h,06Fh,070h,020h,00h
str_Cttitle12:                                  ; string 'cttitle1'; used by GameSummaryScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,031h,00h
str_Def2:                                       ; string 'def '; used by GameSummaryScreen
        db 064h,065h,066h,020h,00h
str_Fowa2:                                      ; string 'fowa'; used by GameSummaryScreen
        db 066h,06Fh,077h,061h,00h
str_Scra2:                                      ; string 'scra'; used by GameSummaryScreen
        db 073h,063h,072h,061h,00h
str_Tlu2:                                       ; string 'tlu '; used by GameSummaryScreen
        db 074h,06Ch,075h,020h,00h
str_Cttitle3:                                   ; string 'cttitle3'; used by GameSummaryScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,033h,00h
str_Ots:                                        ; string 'ots '; used by GameSummaryScreen
        db 06Fh,074h,073h,020h,00h
str_Colm:                                       ; string 'colm'; used by GameSummaryScreen
        db 063h,06Fh,06Ch,06Dh,00h
str_Gsummary2:                                  ; string 'gsummary'; used by GameSummaryScreen
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,00h
str_Iff6:                                       ; string '.iff'; used by GameSummaryScreen
        db 02Eh,069h,066h,066h,00h
str_Gamesum:                                    ; string 'gamesum'; used by GameSummaryScreen
        db 067h,061h,06Dh,065h,073h,075h,06Dh,00h
str_Mtsum:                                      ; string 'mtsum'; used by GameSummaryScreen
        db 06Dh,074h,073h,075h,06Dh,00h
str_Adsum:                                      ; string 'adsum'; used by GameSummaryScreen
        db 061h,064h,073h,075h,06Dh,00h
str_D6:                                         ; string '%d'; used by GameSummaryScreen
        db 025h,064h,00h
str_1st2:                                       ; string '1st'; used by GameSummaryScreen_p1
        db 031h,073h,074h,00h
str_2nd2:                                       ; string '2nd'; used by GameSummaryScreen_p2
        db 032h,06Eh,064h,00h
str_3rd2:                                       ; string '3rd'; used by GameSummaryScreen_p3
        db 033h,072h,064h,00h
str_OT:                                         ; string 'OT'; used by GameSummaryScreen_ot
        db 04Fh,054h,00h
str_FinalOT:                                    ; string 'Final (OT)'; used by GameSummaryScreen_finalot
        db 046h,069h,06Eh,061h,06Ch,020h,028h,04Fh,054h,029h,00h
str_Final:                                      ; string 'Final'; used by GameSummaryScreen_final
        db 046h,069h,06Eh,061h,06Ch,00h
str_Period:                                     ; string ' period'; used by GameSummaryScreen_period
        db 020h,070h,065h,072h,069h,06Fh,064h,00h
str_Injured2:                                   ; string 'Injured'; used by GameSummaryScreen_period
        db 049h,06Eh,06Ah,075h,072h,065h,064h,00h
str_EVNT:                                       ; string 'EVNT'; used by GameSummaryScreen_period
        db 045h,056h,04Eh,054h,00h
str_PRDS:                                       ; string 'PRDS'; used by GameSummaryScreen_period
        db 050h,052h,044h,053h,00h
str_S3:                                         ; string '%s'; used by GameSummaryScreen_period
        db 025h,073h,00h
str_D5:                                         ; string ' (%d'; used by GameSummaryScreen_period
        db 020h,028h,025h,064h,00h
str_St:                                         ; string 'st)'; used by GameSummaryScreen_period
        db 073h,074h,029h,00h
str_Nd:                                         ; string 'nd)'; used by GameSummaryScreen_period
        db 06Eh,064h,029h,00h
str_Rd:                                         ; string 'rd)'; used by GameSummaryScreen_period
        db 072h,064h,029h,00h
str_Th:                                         ; string 'th)'; used by GameSummaryScreen_period
        db 074h,068h,029h,00h
str_SH:                                         ; string ' SH'; used by GameSummaryScreen_period
        db 020h,053h,048h,00h
str_PP:                                         ; string ' PP'; used by GameSummaryScreen_period
        db 020h,050h,050h,00h
str_02d02d:                                     ; string '%02d:%02d'; used by GameSummaryScreen_period
        db 025h,030h,032h,064h,03Ah,025h,030h,032h,064h,00h
str_S2:                                         ; string '(%s'; used by GameSummaryScreen_period
        db 028h,025h,073h,00h
str_CommaSp:                                    ; string ', '; used by GameSummaryScreen_period
        db 02Ch,020h,00h
str_RParen2:                                    ; string ')'; used by GameSummaryScreen_period
        db 029h,00h
str_SS4:                                        ; string '%s %s'; used by GameSummaryScreen_period
        db 025h,073h,020h,020h,020h,020h,025h,073h,00h
str_DMinS:                                      ; string '%d min : %s'; used by GameSummaryScreen_period
        db 025h,064h,020h,06Dh,069h,06Eh,020h,03Ah,020h,025h,073h,00h
str_ShotsOnGoal:                                ; string 'Shots on goal'; used by GameSummaryScreen_period
        db 053h,068h,06Fh,074h,073h,020h,06Fh,06Eh,020h,067h,06Fh,061h,06Ch,00h
str_SDD:                                        ; string '%s %d/%d'; used by GameSummaryScreen_period
        db 025h,073h,020h,025h,064h,02Fh,025h,064h,00h,00h,00h
str_Ctbkgd3:                                    ; string 'ctbkgd'; used by GameStatsScreen
        db 063h,074h,062h,06Bh,067h,064h,00h
str_Pal14:                                      ; string '!pal'; used by GameStatsScreen
        db 021h,070h,061h,06Ch,00h
str_Bkgd6:                                      ; string 'bkgd'; used by GameStatsScreen
        db 062h,06Bh,067h,064h,00h
str_Cttitle32:                                  ; string 'cttitle3'; used by GameStatsScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,033h,00h
str_Colm2:                                      ; string 'colm'; used by GameStatsScreen
        db 063h,06Fh,06Ch,06Dh,00h
str_Gsta:                                       ; string 'gsta'; used by GameStatsScreen
        db 067h,073h,074h,061h,00h
str_Ctlogo3:                                    ; string 'ctlogo'; used by GameStatsScreen
        db 063h,074h,06Ch,06Fh,067h,06Fh,00h
str_D7:                                         ; string '%d'; used by GameStatsScreen
        db 025h,064h,00h
str_DD:                                         ; string '%d/%d'; used by GameStatsScreen
        db 025h,064h,02Fh,025h,064h,00h
str_D02d2:                                      ; string '%d:%02d'; used by GameStatsScreen
        db 025h,064h,03Ah,025h,030h,032h,064h,00h
str_DDD:                                        ; string '%d/%d (%d%%)'; used by GameStatsScreen
        db 025h,064h,02Fh,025h,064h,020h,028h,025h,064h,025h,025h,029h,00h
str_Iff7:                                       ; string '.iff'; used by GameStatsScreen
        db 02Eh,069h,066h,066h,00h
str_Leaguetm:                                   ; string 'leaguetm'; used by GameStatsScreen
        db 06Ch,065h,061h,067h,075h,065h,074h,06Dh,00h
str_Mtsum2:                                     ; string 'mtsum'; used by GameStatsScreen
        db 06Dh,074h,073h,075h,06Dh,00h
str_Adsum2:                                     ; string 'adsum'; used by GameStatsScreen
        db 061h,064h,073h,075h,06Dh,00h,00h
str_Pointer6:                                   ; string 'Pointer'; used by ListDialog, RunMessageBox
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_DBOX:                                       ; string 'DBOX'; used by SaveDialogBg
        db 044h,042h,04Fh,058h,00h,00h,00h,00h
str_Dot:                                        ; string '.'; used by DrawEditCursor, DrawEditText
        db 02Eh,00h
str_Space:                                      ; string ' '; used by DrawEditCursor
        db 020h,00h
str_Pointer7:                                   ; string 'Pointer'; used by MainDeskLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff8:                                       ; string '.iff'; used by MainDeskLoop
        db 02Eh,069h,066h,066h,00h
str_Maindesk:                                   ; string 'maindesk'; used by MainDeskLoop
        db 06Dh,061h,069h,06Eh,064h,065h,073h,06Bh,00h
str_Tonights2:                                  ; string 'tonights'; used by MainDeskLoop
        db 074h,06Fh,06Eh,069h,067h,068h,074h,073h,00h
str_Easndesk:                                   ; string 'easndesk'; used by MainDeskLoop
        db 065h,061h,073h,06Eh,064h,065h,073h,06Bh,00h
str_Desk2:                                      ; string 'desk'; used by MainDeskLoop
        db 064h,065h,073h,06Bh,00h
str_Pal15:                                      ; string '!pal'; used by MainDeskLoop
        db 021h,070h,061h,06Ch,00h
str_Menubuff4:                                  ; string 'menubuff'; used by MainDeskLoop
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_GameSet4:                                   ; string 'game.set'; used by WriteModeState
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_Game:                                       ; string 'game'; used by WriteModeState
        db 067h,061h,06Dh,065h,00h
str_Set:                                        ; string '.set'; used by WriteModeState
        db 02Eh,073h,065h,074h,00h
str_fee2:                                       ; string 'e2'; used by WriteModeState
        db 065h,032h,00h
str_fee3:                                       ; string 'e3'; used by WriteModeState
        db 065h,033h,00h
str_fee4:                                       ; string 'e4'; used by WriteModeState
        db 065h,034h,00h
str_Palette2:                                   ; string 'palette'; used by MenuNewExhibition
        db 070h,061h,06Ch,065h,074h,074h,065h,00h
str_Temp4:                                      ; string 'temp'; used by MenuAddTeam_common,
                                                ; MenuLeagueSettings, MenuMergeLeagueFiles ...
        db 074h,065h,06Dh,070h,00h
str_GameSav4:                                   ; string '\\game.sav'; used by MenuNextLeagueGame
        db 05Ch,067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h,00h,00h
str_Rink2:                                      ; string 'rink'; used by LoadRink
        db 072h,069h,06Eh,06Bh,00h
str_Til:                                        ; string '.til'; used by LoadRink
        db 02Eh,074h,069h,06Ch,00h
str_InvalidFileSize:                            ; string "Invalid file '%s' size %d\n"; used by LoadRink
        db 049h,06Eh,076h,061h,06Ch,069h,064h,020h,066h,069h,06Ch,065h,020h,027h,025h,073h
        db 027h,020h,073h,069h,07Ah,065h,020h,025h,064h,0Ah,00h
str_TILES:                                      ; string 'TILES'; used by LoadRink
        db 054h,049h,04Ch,045h,053h,00h
str_ErrorLoadingFile:                           ; string "Error loading file '%s'\n"; used by LoadRink
        db 045h,072h,072h,06Fh,072h,020h,06Ch,06Fh,061h,064h,069h,06Eh,067h,020h,066h,069h
        db 06Ch,065h,020h,027h,025h,073h,027h,0Ah,00h
str_Map:                                        ; string '.map'; used by LoadRink
        db 02Eh,06Dh,061h,070h,00h,00h,00h,00h
str_CRESTS3:                                    ; string 'CRESTS3'; used by LoadCrestsPalette
        db 043h,052h,045h,053h,054h,053h,033h,00h
str_Pal16:                                      ; string '!pal'; used by LoadCrestsPalette
        db 021h,070h,061h,06Ch,00h,00h,00h,00h
TradeLabelText:                                 ; Empty text of the first item of the trade screen menu bar
        db 00h,00h,00h,00h
str_Boxr:                                       ; string 'boxr'; used by DrawCalendarDay
        db 062h,06Fh,078h,072h,00h
str_Boxb:                                       ; string 'boxb'; used by DrawCalendarDay
        db 062h,06Fh,078h,062h,00h
str_Bkgd7:                                      ; string 'bkgd'; used by DrawCalendarDay
        db 062h,06Bh,067h,064h,00h
str_02d9D:                                      ; string '%02d9%d'; used by DrawCalendarDay
        db 025h,030h,032h,064h,039h,025h,064h,00h
str_Home:                                       ; string 'Home'; used by DrawCalendarDay
        db 048h,06Fh,06Dh,065h,00h
str_Away:                                       ; string 'Away'; used by DrawCalendarDay
        db 041h,077h,061h,079h,00h
str_D8:                                         ; string '%d'; used by DrawCalendarDay
        db 025h,064h,00h
str_W5:                                         ; string 'W'; used by DrawCalendarDay
        db 057h,00h
str_SDD2:                                       ; string '%s:%d-%d'; used by DrawCalendarDay
        db 025h,073h,03Ah,025h,064h,02Dh,025h,064h,00h
str_L7:                                         ; string 'L'; used by DrawCalendarDay
        db 04Ch,00h
str_T5:                                         ; string 'T'; used by DrawCalendarDay
        db 054h,00h
str_Pal17:                                      ; string '!pal'; used by ApplyShapePalette, PlayLeagueGame
        db 021h,070h,061h,06Ch,00h
str_Calendar:                                   ; string 'calendar'; used by CalendarScreen
        db 063h,061h,06Ch,065h,06Eh,064h,061h,072h,00h
str_Callogo:                                    ; string 'callogo'; used by CalendarScreen
        db 063h,061h,06Ch,06Ch,06Fh,067h,06Fh,00h
str_Iff9:                                       ; string '.iff'; used by CalendarScreen
        db 02Eh,069h,066h,066h,00h
str_Pointer8:                                   ; string 'Pointer'; used by CalendarScreen
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Menubuff5:                                  ; string 'menubuff'; used by CalendarScreen
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_02d:                                        ; string '.%02d'; used by MakeTeamDbFmt, PlayLeagueGame
        db 02Eh,025h,030h,032h,064h,00h
str_GSUMMARY:                                   ; string 'GSUMMARY'; used by PostGameToTeamDb
        db 047h,053h,055h,04Dh,04Dh,041h,052h,059h,00h
str_Pal18:                                      ; string 'Pal'; used by PlayLeagueGame
        db 050h,061h,06Ch,00h
str_Temp5:                                      ; string 'temp'; used by PlayLeagueGame
        db 074h,065h,06Dh,070h,00h
str_Easndesk2:                                  ; string 'easndesk'; used by PlayLeagueGame
        db 065h,061h,073h,06Eh,064h,065h,073h,06Bh,00h
str_GAME:                                       ; string 'GAME'; used by PlayLeagueGame
        db 047h,041h,04Dh,045h,00h
str_SAV:                                        ; string '.SAV'; used by PlayLeagueGame
        db 02Eh,053h,041h,056h,00h,00h,00h
str_Back:                                       ; string 'back'; used by SaveGridCellBg
        db 062h,061h,063h,06Bh,00h
str_Callogo2:                                   ; string 'callogo'; used by DrawTeamGrid
        db 063h,061h,06Ch,06Ch,06Fh,067h,06Fh,00h
str_PLST:                                       ; string 'PLST'; used by ChooseLeagueController
        db 050h,04Ch,053h,054h,00h
str_PTLS:                                       ; string 'PTLS'; used by ChooseLeagueController
        db 050h,054h,04Ch,053h,00h
str_Pal19:                                      ; string 'Pal'; used by LeagueTeamSelect
        db 050h,061h,06Ch,00h
str_TPI:                                        ; string 'TPI'; used by LeagueTeamSelect
        db 054h,050h,049h,00h
str_Embnhl:                                     ; string 'embnhl'; used by LeagueTeamSelect
        db 065h,06Dh,062h,06Eh,068h,06Ch,00h
str_Bkgd8:                                      ; string 'bkgd'; used by LeagueTeamSelect
        db 062h,06Bh,067h,064h,00h
str_Pointer9:                                   ; string 'Pointer'; used by LeagueTeamSelect
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff10:                                      ; string '.iff'; used by LeagueTeamSelect
        db 02Eh,069h,066h,066h,00h
str_Leaguetm2:                                  ; string 'leaguetm'; used by LeagueTeamSelect
        db 06Ch,065h,061h,067h,075h,065h,074h,06Dh,00h
str_Tspal:                                      ; string 'tspal'; used by LeagueTeamSelect
        db 074h,073h,070h,061h,06Ch,00h
str_Pal20:                                      ; string '!pal'; used by LeagueTeamSelect
        db 021h,070h,061h,06Ch,00h
str_Menubuff6:                                  ; string 'menubuff'; used by LeagueTeamSelect
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_WhoWillPlayThe:                             ; string 'Who will play the '; used by LeagueTeamSelect
        db 057h,068h,06Fh,020h,077h,069h,06Ch,06Ch,020h,070h,06Ch,061h,079h,020h,074h,068h
        db 065h,020h,00h
str_MightyDucksOfAnaheim3:                      ; string 'Mighty Ducks of Anaheim'; used by LeagueTeamSelect
        db 04Dh,069h,067h,068h,074h,079h,020h,044h,075h,063h,06Bh,073h,020h,06Fh,066h,020h
        db 041h,06Eh,061h,068h,065h,069h,06Dh,00h
str_qmark:                                      ; string '?'; used by LeagueTeamSelect
        db 03Fh,00h,00h,00h
str_02d2:                                       ; string '.%02d'; used by MergeLeagueFiles
        db 02Eh,025h,030h,032h,064h,00h
str_SAV2:                                       ; string 'SAV'; used by RebuildLeagueDbs
        db 053h,041h,056h,00h
str_GAME2:                                      ; string 'GAME'; used by RebuildLeagueDbs
        db 047h,041h,04Dh,045h,00h,00h
str_wildcard:                                   ; string '*'; used by ExportTeamToFloppy
        db 02Ah,00h
str_ID:                                         ; string 'ID'; used by ExportTeamToFloppy
        db 049h,044h,00h
str_SET:                                        ; string '.SET'; used by ImportDbs, ImportMasterLeague
        db 02Eh,053h,045h,054h,00h
str_GAME3:                                      ; string 'GAME'; used by ImportDbs, ImportMasterLeague
        db 047h,041h,04Dh,045h,00h
str_SAV3:                                       ; string 'SAV'; used by ImportMasterLeague
        db 053h,041h,056h,00h
str_02d3:                                       ; string '.%02d'; used by ExportDbs, ImportPlayerTeam
        db 02Eh,025h,030h,032h,064h,00h
str_L1:                                         ; string 'l1'; used by ImportDbs
        db 06Ch,031h,00h
str_L22:                                        ; string 'l2'; used by ImportDbs
        db 06Ch,032h,00h,00h
str_A5:                                         ; string 'A'
        db 041h,00h
str_DriveB:                                     ; Drive button text: B
        db 042h,00h
str_Game2:                                      ; string 'game'; used by ReadLeagueInfo
        db 067h,061h,06Dh,065h,00h
str_Sav2:                                       ; string '.sav'; used by ReadLeagueInfo
        db 02Eh,073h,061h,076h,00h
str_NHL2:                                       ; string 'NHL'; used by LoadNhlCfg
        db 04Eh,048h,04Ch,00h
str_R3:                                         ; string 'r'; used by LoadNhlCfg
        db 072h,00h
str_CannotOpenNhlCfg:                           ; string 'cannot open nhl.cfg'; used by LoadNhlCfg
        db 063h,061h,06Eh,06Eh,06Fh,074h,020h,06Fh,070h,065h,06Eh,020h,06Eh,068h,06Ch,02Eh
        db 063h,066h,067h,00h
str_fmt4x:                                      ; string "%4x "; used by LoadNhlCfg
        db 025h,034h,078h,0Ah,00h,00h,00h,00h
str_Temp6:                                      ; string 'temp'; used by TradeScreen, TradeShowStats
        db 074h,065h,06Dh,070h,00h
str_Tstat:                                      ; string 'tstat'; used by TradeShowStats
        db 074h,073h,074h,061h,074h,00h
str_Keys2:                                      ; string 'keys'; used by TradeShowStats
        db 06Bh,065h,079h,073h,00h
str_Pstat2:                                     ; string 'pstat'; used by TradeShowStats
        db 070h,073h,074h,061h,074h,00h
str_Gstat2:                                     ; string 'gstat'; used by TradeShowStats
        db 067h,073h,074h,061h,074h,00h
str_Embpal3:                                    ; string 'embpal'; used by DrawTradeScreen, TradeShowStats
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal21:                                      ; string '!pal'; used by DrawTradeScreen, TradeShowStats
        db 021h,070h,061h,06Ch,00h
str_Donepal:                                    ; string 'donepal'; used by FixJerseyConflict, TradeDone
        db 064h,06Fh,06Eh,065h,070h,061h,06Ch,00h
str_TheJerseyNumber2d2:                         ; string 'The jersey number %2d is already used on %s!'; used
                                                ; by FixJerseyConflict
        db 054h,068h,065h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh,062h,065h
        db 072h,020h,025h,032h,064h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
        db 020h,075h,073h,065h,064h,020h,06Fh,06Eh,020h,025h,073h,021h,00h
str_EnterJerseyNumberFor:                       ; string 'Enter jersey number for %s'; used by
                                                ; FixJerseyConflict
        db 045h,06Eh,074h,065h,072h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh
        db 062h,065h,072h,020h,066h,06Fh,072h,020h,025h,073h,00h
str_Pal22:                                      ; string 'Pal'; used by DrawTradeScreen, ExecuteTrade
        db 050h,061h,06Ch,00h
str_C2dS:                                       ; string '%c %2d %s'; used by DrawTradeRow, DrawTradeScreen
        db 025h,063h,020h,025h,032h,064h,020h,025h,073h,00h
str_HOMEPALS2:                                  ; string 'HOMEPALS'; used by LoadTradeTeamPals
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h
str_Embnhl2:                                    ; string 'embnhl'; used by DrawTradeScreen
        db 065h,06Dh,062h,06Eh,068h,06Ch,00h
str_Bkgd9:                                      ; string 'bkgd'; used by DrawTradeScreen
        db 062h,06Bh,067h,064h,00h
str_Pntr2:                                      ; string 'pntr'; used by TradeScreenLoop
        db 070h,06Eh,074h,072h,00h
str_Pointer10:                                  ; string 'Pointer'; used by TradeScreenLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Menubuff7:                                  ; string 'menubuff'; used by TradeScreenLoop
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_S12:                                        ; string 's1'; used by TradeScreen
        db 073h,031h,00h
str_Lineditp:                                   ; string 'lineditp'; used by TradeScreen
        db 06Ch,069h,06Eh,065h,064h,069h,074h,070h,00h
str_Shrt:                                       ; string 'shrt'; used by TradeScreen
        db 073h,068h,072h,074h,00h
