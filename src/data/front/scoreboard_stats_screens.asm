; The credits, the disk-space warnings, and the titles for each statistics source.
bits 32
%include "hockey.inc"
section s_C5679 progbits alloc noexec write align=1
extern exhfiles, pofiles, lgfiles, StatsSel9394Season, StatsSel9394Playoffs, StatsSelLeague, StatsSelLeaguePlayoffs, StatsSelPlayoffMode
extern NullBlit, CmpPoints, CmpGAA, CmpTeamStandings, CmpTeamScoring, CmpTeamDefense, CmpTeamPP, CmpTeamPK
extern CmpTeamPenalties, CmpGoals, CmpAssists, CmpPPGoals, CmpSHGoals, CmpPlusMinus, CmpPIM, CmpShootPct
extern CmpGoalieWins, CmpSavePct, VgaBlitKeyed, VgaBlitRemap, VgaBlitKeyedFlipV, VgaBlitRemapFlipV, VgaBlitKeyedFlipH, VgaBlitKeyedFlipHV
extern VgaBlitRemapFlipH, VgaBlitRemapFlipHV, str_3000, str_3001, str_3002, str_3003, str_3004, str_3005
extern str_3006, str_3007, str_3008, str_3009, str_300, str_OT2, str_BOS, str_BUF3
extern str_CGY, str_CHI, str_DET, str_EDM, str_HFD, str_LA, str_DAL, str_MTL
extern str_NJ, str_NYI, str_NYR, str_OTT, str_PHI, str_PIT, str_QUE, str_STL
extern str_SJ, str_TB, str_TOR, str_VAN, str_WSH, str_WPG, str_ANA3, str_FLA
extern str_ASW, str_ASE, CreditBlankTitle, str_Credit19, str_Credit10, str_Credit09, str_Credit17, str_Credit01
extern str_Credit15, str_Credit12, str_Credit08, str_Credit02, str_Credit11, str_Credit05, str_Credit06, str_Credit07
extern str_Credit18, str_Credit14, str_Credit13, str_Credit16, str_Credit00, str_Credit04, str_Credit03, str_PacificDivision
extern str_CentralDivision, str_NortheastDivision, str_AtlanticDivision, str_Season3, str_Playoff3, str_RegSeason, str_Playoff4, str_Actual
extern str_Accumulated, str_embnhl, str_embscup, str_careerdb, str_seasondb, str_carteamsdb, str_teamsdb, str_Speed
extern str_Agility, str_Weight, str_ShotPower, str_Checking2, str_StickHandling, str_Accuracy, str_Passing2, str_OffensiveAwareness
extern str_DefensiveAwareness, str_Aggressiveness, str_Endurance, str_ShootPassBias, str_Faceoffs, str_GloveLeft, str_GloveRight, str_StickLeft
extern str_StickRight, str_PuckControl, str_Speed2, str_Agility2, str_Weight2, str_OffensiveAwareness2, str_DefensiveAwareness2, str_WesternConference3
extern str_EasternConference3, str_TeamScoring, str_TeamDefense, str_TeamPenaltyKilling, str_TeamPowerPlay, str_TeamPenalties, str_TeamStandings, str_spW
extern str_SpL4, str_SpT, str_GF2, str_GA4, str_TSH, str_PPGA, str_PCT5, str_BlankTeamColumn
extern str_ADV, str_PPG3, str_PIM5, str_AVG, str_PTS, str_WINS, str_PointLeaders, str_GoalLeaders
extern str_AssistLeaders, str_PowerPlayGoalLeaders, str_ShorthandedGoalLeaders, str_PlusMinusLeaders, str_PenaltyMinuteLeaders, str_ShootingPercentageLeaders, str_GoalsAgainstAverageLeaders, str_GoaltenderWinLeaders
extern str_SavePercentageLeaders, str_spG, str_spA, str_Pt3, str_BlankLeaderColumn, str_PP2, str_SHG3, str_PlusMinus5
extern str_PIM6, str_Shots5, str_Pct6, str_MIN5, str_GA5, str_AVG2, str_spW2, str_SpL5
extern str_SpT2, str_SA4, str_PCT7, str_LSSCEDDB, str_SCHEDULEDB3, str_InsufficientDiskSpace3
global CreditsList, msg_NeedKbytes, msg_NeedKbytes2, str_ReturningToSportsCentral, str_ReturningOutOfThe, str_ReturningToThePlayoff, str_ExitingTheGame, str_DoYouWishToReturn
global str_DoYouWishToExit, str_9394Season, str_9394PlayOffs, str_LgSeasonTitle, str_LgPlayoffsTitle, str_POTitle
global str_SeasonSfx, str_SeasonPlayOffsSfx, str_PlayOffsSfx, str_AttDb, str_fmt2d, str_fmt3d, str_fmt4d
global str_fmt5d, str_fmtTenths, str_fmtPct, str_fmtPct0, str_fmtMinSec, str_fmtEmb, str_Bkgd2, str_EASNvfn
global str_ExhibitionGameCalled, str_LeagueCalled, str_PlayOffSeriesCalled, str_NoScoring, str_NoPenalties, rinkarenas, RosterStatusByInjury, mi_9394Season
global mi_9394Playoffs, mi_LeagueSeason, mi_LeaguePlayoffs, mi_PlayoffMode, str_Dashes, treecolslots, treecol_Wr2, treecol_Wr3, treecol_Er3
global treecol_Er2, treecol_Er1
global scoutcatidx, desksongalt, awlineenergies, hmlineenergies, hudclockmin, hudclocksec, hudclockhund, panelprevmin
global panelprevsec, panelprevhund, panelhund, deferpending, hmpanellines, awpanellines, hudhomeline, hudawayline
global hmpanelpens, awpanelpens, hmlinetimer, awlinetimer, demomatchups_m1, demomatchups, demoteammode, nhlintrosaid
global textgrid, textgridon, textcolor, textshadow, textoutlinedx, textoutlinedy, easnfontbuf, embscupbank
global statscategory, statsteamsel, statsredrawcb, deskexit, teamstatscb, skaterstatscb, goaliestatscb, standingscb
global standingsmenucb, hlplayedmask, msg_DeskExit, msg_DeskExit_e02, CdStreamRateFactor, screenbm, dirtyrectcount, DeskRedrawAll
global DeskRedrawFlag, lastsprremap, StatsSourceLastBottom, StatsSourceMenuRight, StatsSourceMenuBottom, statsplayoffs, statsfromleague, statspalvalid
global westconfteams, eastconfteams, PoStandingsMode, potreeseeds, treerowy, divx, divy
global fdlgshapes, fdlgrects
global boxfillcolor, boxlitecolor, boxshadecolor, dlgtextfg, dlgtextbg
global EditRostersState, dlgsavebuf, listscroll
global keepdesksong, songdata, rinktilebm
global rinkbm, rinkfileidx, currink, rinkscrollx, rinkscrolly, msg_GameDiskSpace, perioddigits, hudotname
global crestnames, creditpages, msg_FileExists, msg_StatsDiskSpace, menutext_statsleague, menuact_statsleague, menutext_statslgplayoffs, menuact_statslgplayoffs
global menutext_statsplayoff, menuact_statsplayoff, divisionnames, statslabels, statsbgnames, statsplayerdbs, statsteamdbs
global skaterratingnames, skatercardattrs_m3, goalieratingnames, goaliecardattrs_m3, teamsortfns, westconfname, eastconfname, teamstattitles
global teamcolhdrs, leadersortfns, leadertitles, leadercolhdrs, leadercolhdrs_c1
global leadercolhdrs_c2, leadercolhdrs_c3, leadercolhdrs_c4, potreeround_m2, scoutcatnames, fdlgfilelists, fdlgfilelists_e01, fdlgfilelists_e02
global gamestatlabels, setdiskmsg, dbchoicelines, str_OfFreeDiskSpace, CreditBlankLine, str_OfficiallyLicensed, str_ProductOfThe, str_NationalHockeyLeague
global str_NationalHockeyLeagueNHL, str_TheLogoOfThe, str_TrademarksOfTheNational, str_LeagueAndAreUsed, CreditPageNhlLicense, str_StanleyCupIsA, str_TrademarkOfTheNational, str_LeagueAndIsUsed
global str_ByElectronicArtsInc, str_TeamNamesAndLogos, str_AreOfficiallyLicensed, str_OfTheNationalHockey, str_CopyrightNHL1994, CreditPageStanleyCup, str_OfficiallyLicensedProductOf, str_NationalHockeyLeaguePlayers
global str_Association, str_NHLPANationalHockeyLeague, str_PlayersAssociationAndThe, str_OfTheNHLPAAre, str_TheNHLPAAndAre, str_LicenseByElectronicArts, CreditPageNhlpaLicense, str_EASportsTheEA
global str_IfItSIn, str_AreTrademarksOfElectronic, CreditPageEaSports, str_ThisHasBeenA, str_ThePIONEERPRODUCTIONSGroup, str_ElectronicArtsCanada, CreditPagePresentedBy, str_OriginalGameConcept
global str_JimSimmons, str_ScottOrr, str_RichardHilleman, CreditPageGameConcept, str_OriginalPCVersionGame, str_DaveWarfield, str_RichardHilleman2, CreditPagePcDesign
global str_LanceWall, str_LeadProgrammer, CreditPageLeadProgrammer, str_VictoriaWong, str_Programmer, CreditPageProgrammerWong, str_RobertPenner, str_Programmer2
global CreditPageProgrammerPenner, str_KurtKennett, str_Programmer3, CreditPageProgrammerKennett, str_GerardDeSouza, str_Artist, CreditPageArtistDeSouza, str_PhilChow
global str_Artist2, CreditPageArtistChow, str_KentMaclagan, str_Artist3DAnimations, CreditPageAnimator, str_MichaelJSokyrka, str_Composer, CreditPageComposer
global str_AlanStewart, str_AudioProgrammer, CreditPageAudioStewart, str_IainMacanulty, str_AudioProgrammer2, CreditPageAudioMacanulty, str_SerenaMcCabe, str_AdministrativeAssistant
global CreditPageAdminAssistant, str_RodHigo, str_LeadTester, CreditPageLeadTester, str_RichardRadarMul, str_AssistantProducer, CreditPageAssistantProducer, str_FosterHall
global str_DirectorOfDevelopment, CreditPageDevDirector, str_KenSayler, str_ProducerDesign, CreditPageProducerDesign, str_HannoLemke, str_Producer, CreditPageProducer
global str_Testers, str_PaulSmith, str_JohnBrydon, str_TonyLam, str_DavidLee, str_QASupport, str_JonBruce, str_JohnSantamaria
global CreditPageTesters, str_RosterVerification, str_DaveWarfield2, str_JohnBrydon2, str_ProductManager, str_ChipLange, str_RatingsByJohnRosasco, str_AndNeilSmithOf
global str_NewYorkRangers, CreditPageRosters, str_AudioTechnician, str_SteveRoyea, str_AudioProgrammers, str_PaulChernikhowsky, str_JasonLeeSteere, str_AdvancedGravis
global CreditPageAudioTeam, str_SportsDeskAnnouncer, str_MichaelDonovan, str_RinkAnnouncer, str_BruceJamieson, str_PlayerProfilePhotographs, str_SteveBabineau, CreditPageAnnouncers
global str_VideoProvidedBy, str_NHLProductions, str_SpecialThanks, str_ScottJackson, str_CatherineOBrien, str_DougReid, str_MottLinn, CreditPageSpecialThanks
global CreditPageEnd, str_TheFileYouSpecified, str_DoYouWantTo, str_No3, btn_FileExists, str_TheStatsWereSuccessfully, msg_StatsWritten, str_ERROROutputFileWas
global msg_OutputFileError, str_InsufficientDiskSpaceTo, str_TheDisplayedStatisticsTo, statsleague, str_MayLoseThisGame, str_StatsSourceDivider, StatsSourceMenu, photoremap
global str_AwayLines, str_Play, str_Cancel, str_HomeLines, pregamebuttons, str_PenaltyKilling, str_PowerPlay
global str_Shooting, str_Skating, str_Passing, str_Defense2, str_Checking, str_Goaltending, str_Overall, str_ConfirmDeletionOfThe
global delmsgbox, str_gsScore, str_gsShots, str_gsPowerPlay, str_gsPenalties, str_gsFaceoffsWon, str_gsBodyChecks, str_gsAttackZone
global str_gsPassing, str_gsOneTimers, str_gsPPMinutes, str_gsPPShots, str_gsOffFaceoffs, str_InsufficientDiskSpace, str_ToSaveTheSettings, str_1KbytesFree
global str_Yes, str_No4, str_DoYouWishToUse, str_CurrentDbOr, str_OriginalNHLDb, str_Current, str_Original, dbchoicebtns
global str_AllTheTeamsAre, hudpenhome, hmpanelpen_time, hmpanelpen_w4, hmpanelpen_w6, hudpenaway, awpanelpen_time, awpanelpen_w4
global awpanelpen_w6, potreeround, treecolx, scrpitch
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
nhlintrosaid:                                   ; used by TitleScreen
        db 01h,00h,00h,00h
CreditBlankLine:                                ; Empty string used as a blank line on the credit pages
        db 00h
str_OfficiallyLicensed:                         ; "Officially Licensed" string literal
        db 04Fh,066h,066h,069h,063h,069h,061h,06Ch,06Ch,079h,020h,04Ch,069h,063h,065h,06Eh
        db 073h,065h,064h,00h
str_ProductOfThe:                               ; "Product of the" string literal
        db 050h,072h,06Fh,064h,075h,063h,074h,020h,06Fh,066h,020h,074h,068h,065h,00h
str_NationalHockeyLeague:                       ; "National Hockey League." string literal
        db 04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h,079h,020h
        db 04Ch,065h,061h,067h,075h,065h,02Eh,00h
str_NationalHockeyLeagueNHL:                    ; "National Hockey League, NHL and" string literal
        db 04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h,079h,020h
        db 04Ch,065h,061h,067h,075h,065h,02Ch,020h,04Eh,048h,04Ch,020h,061h,06Eh,064h,00h
str_TheLogoOfThe:                               ; "the logo of the NHL are registered" string literal
        db 074h,068h,065h,020h,06Ch,06Fh,067h,06Fh,020h,06Fh,066h,020h,074h,068h,065h,020h
        db 04Eh,048h,04Ch,020h,061h,072h,065h,020h,072h,065h,067h,069h,073h,074h,065h,072h
        db 065h,064h,00h
str_TrademarksOfTheNational:                    ; "trademarks of the National Hockey" string literal
        db 074h,072h,061h,064h,065h,06Dh,061h,072h,06Bh,073h,020h,06Fh,066h,020h,074h,068h
        db 065h,020h,04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h
        db 079h,00h
str_LeagueAndAreUsed:                           ; "League and are used under license" string literal
        db 04Ch,065h,061h,067h,075h,065h,020h,061h,06Eh,064h,020h,061h,072h,065h,020h,075h
        db 073h,065h,064h,020h,075h,06Eh,064h,065h,072h,020h,06Ch,069h,063h,065h,06Eh,073h
        db 065h,00h
CreditsList:                                    ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 062h,079h,020h,045h,06Ch,065h,063h,074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h
        db 074h,073h,020h,049h,06Eh,063h,02Eh,00h
CreditPageNhlLicense:                           ; Credit page: NHL licence notice
        db 09h,0DCh,00h,00h,00h
        dd CreditBlankTitle
        dd str_OfficiallyLicensed
        dd str_ProductOfThe
        dd str_NationalHockeyLeague
        dd CreditBlankLine
        dd str_NationalHockeyLeagueNHL
        dd str_TheLogoOfThe
        dd str_TrademarksOfTheNational
        dd str_LeagueAndAreUsed
        dd CreditsList
str_StanleyCupIsA:                              ; Credits text: Stanley Cup registered trademark line
        db 053h,074h,061h,06Eh,06Ch,065h,079h,020h,043h,075h,070h,0A8h,020h,069h,073h,020h
        db 061h,020h,072h,065h,067h,069h,073h,074h,065h,072h,065h,064h,00h
str_TrademarkOfTheNational:                     ; "Trademark of the National Hockey" string literal
        db 054h,072h,061h,064h,065h,06Dh,061h,072h,06Bh,020h,06Fh,066h,020h,074h,068h,065h
        db 020h,04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h,079h
        db 00h
str_LeagueAndIsUsed:                            ; "League and is used under licence" string literal
        db 04Ch,065h,061h,067h,075h,065h,020h,061h,06Eh,064h,020h,069h,073h,020h,075h,073h
        db 065h,064h,020h,075h,06Eh,064h,065h,072h,020h,06Ch,069h,063h,065h,06Eh,063h,065h
        db 00h
str_ByElectronicArtsInc:                        ; "by Electronic Arts Inc." string literal
        db 062h,079h,020h,045h,06Ch,065h,063h,074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h
        db 074h,073h,020h,049h,06Eh,063h,02Eh,00h
str_TeamNamesAndLogos:                          ; "Team Names and logos depicted" string literal
        db 054h,065h,061h,06Dh,020h,04Eh,061h,06Dh,065h,073h,020h,061h,06Eh,064h,020h,06Ch
        db 06Fh,067h,06Fh,073h,020h,064h,065h,070h,069h,063h,074h,065h,064h,00h
str_AreOfficiallyLicensed:                      ; "are Officially Licensed Trademarks" string literal
        db 061h,072h,065h,020h,04Fh,066h,066h,069h,063h,069h,061h,06Ch,06Ch,079h,020h,04Ch
        db 069h,063h,065h,06Eh,073h,065h,064h,020h,054h,072h,061h,064h,065h,06Dh,061h,072h
        db 06Bh,073h,00h
str_OfTheNationalHockey:                        ; "of the National Hockey League" string literal
        db 06Fh,066h,020h,074h,068h,065h,020h,04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h
        db 048h,06Fh,063h,06Bh,065h,079h,020h,04Ch,065h,061h,067h,075h,065h,00h
str_CopyrightNHL1994:                           ; Credits text: NHL 1994 copyright line
        db 0A9h,020h,04Eh,048h,04Ch,020h,031h,039h,039h,034h,02Eh,00h
CreditPageStanleyCup:                           ; Credit page: Stanley Cup and team logo trademarks
        db 09h,0DCh,00h,00h,00h
        dd str_Credit19
        dd str_StanleyCupIsA
        dd str_TrademarkOfTheNational
        dd str_LeagueAndIsUsed
        dd str_ByElectronicArtsInc
        dd CreditBlankLine
        dd str_TeamNamesAndLogos
        dd str_AreOfficiallyLicensed
        dd str_OfTheNationalHockey
        dd str_CopyrightNHL1994
str_OfficiallyLicensedProductOf:                ; "Officially Licensed Product of the" string literal
        db 04Fh,066h,066h,069h,063h,069h,061h,06Ch,06Ch,079h,020h,04Ch,069h,063h,065h,06Eh
        db 073h,065h,064h,020h,050h,072h,06Fh,064h,075h,063h,074h,020h,06Fh,066h,020h,074h
        db 068h,065h,00h
str_NationalHockeyLeaguePlayers:                ; "National Hockey League Players'" string literal
        db 04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h,079h,020h
        db 04Ch,065h,061h,067h,075h,065h,020h,050h,06Ch,061h,079h,065h,072h,073h,027h,00h
str_Association:                                ; "Association." string literal
        db 041h,073h,073h,06Fh,063h,069h,061h,074h,069h,06Fh,06Eh,02Eh,00h
str_NHLPANationalHockeyLeague:                  ; "NHLPA, National Hockey League" string literal
        db 04Eh,048h,04Ch,050h,041h,02Ch,020h,04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h
        db 048h,06Fh,063h,06Bh,065h,079h,020h,04Ch,065h,061h,067h,075h,065h,00h
str_PlayersAssociationAndThe:                   ; "Players' Association and the logo" string literal
        db 050h,06Ch,061h,079h,065h,072h,073h,027h,020h,041h,073h,073h,06Fh,063h,069h,061h
        db 074h,069h,06Fh,06Eh,020h,061h,06Eh,064h,020h,074h,068h,065h,020h,06Ch,06Fh,067h
        db 06Fh,00h
str_OfTheNHLPAAre:                              ; "of the NHLPA are Trademarks of" string literal
        db 06Fh,066h,020h,074h,068h,065h,020h,04Eh,048h,04Ch,050h,041h,020h,061h,072h,065h
        db 020h,054h,072h,061h,064h,065h,06Dh,061h,072h,06Bh,073h,020h,06Fh,066h,00h
str_TheNHLPAAndAre:                             ; "the NHLPA and are used, under" string literal
        db 074h,068h,065h,020h,04Eh,048h,04Ch,050h,041h,020h,061h,06Eh,064h,020h,061h,072h
        db 065h,020h,075h,073h,065h,064h,02Ch,020h,075h,06Eh,064h,065h,072h,00h
str_LicenseByElectronicArts:                    ; "license, by Electronic Arts Inc." string literal
        db 06Ch,069h,063h,065h,06Eh,073h,065h,02Ch,020h,062h,079h,020h,045h,06Ch,065h,063h
        db 074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h,074h,073h,020h,049h,06Eh,063h,02Eh
        db 00h
CreditPageNhlpaLicense:                         ; Credit page: NHLPA licence notice
        db 09h,0FAh,00h,00h,00h
        dd str_Credit10
        dd str_OfficiallyLicensedProductOf
        dd str_NationalHockeyLeaguePlayers
        dd str_Association
        dd CreditBlankLine
        dd str_NHLPANationalHockeyLeague
        dd str_PlayersAssociationAndThe
        dd str_OfTheNHLPAAre
        dd str_TheNHLPAAndAre
        dd str_LicenseByElectronicArts
str_EASportsTheEA:                              ; "EA Sports, the EA Sports Logo, and" string literal
        db 045h,041h,020h,053h,070h,06Fh,072h,074h,073h,02Ch,020h,074h,068h,065h,020h,045h
        db 041h,020h,053h,070h,06Fh,072h,074h,073h,020h,04Ch,06Fh,067h,06Fh,02Ch,020h,061h
        db 06Eh,064h,00h
str_IfItSIn:                                    ; ""If it's in the game, it's in the game"" string literal
        db 022h,049h,066h,020h,069h,074h,027h,073h,020h,069h,06Eh,020h,074h,068h,065h,020h
        db 067h,061h,06Dh,065h,02Ch,020h,069h,074h,027h,073h,020h,069h,06Eh,020h,074h,068h
        db 065h,020h,067h,061h,06Dh,065h,022h,00h
str_AreTrademarksOfElectronic:                  ; "are trademarks of Electronic Arts, Inc." string literal
        db 061h,072h,065h,020h,074h,072h,061h,064h,065h,06Dh,061h,072h,06Bh,073h,020h,06Fh
        db 066h,020h,045h,06Ch,065h,063h,074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h,074h
        db 073h,02Ch,020h,049h,06Eh,063h,02Eh,00h
CreditPageEaSports:                             ; Credit page: EA Sports trademarks
        db 03h,078h,00h,00h,00h
        dd str_Credit09
        dd str_EASportsTheEA
        dd str_IfItSIn
        dd str_AreTrademarksOfElectronic
str_ThisHasBeenA:                               ; "This has been a presentation by" string literal
        db 054h,068h,069h,073h,020h,068h,061h,073h,020h,062h,065h,065h,06Eh,020h,061h,020h
        db 070h,072h,065h,073h,065h,06Eh,074h,061h,074h,069h,06Fh,06Eh,020h,062h,079h,00h
str_ThePIONEERPRODUCTIONSGroup:                 ; "the PIONEER PRODUCTIONS group of" string literal
        db 074h,068h,065h,020h,050h,049h,04Fh,04Eh,045h,045h,052h,020h,050h,052h,04Fh,044h
        db 055h,043h,054h,049h,04Fh,04Eh,053h,020h,067h,072h,06Fh,075h,070h,020h,06Fh,066h
        db 00h
str_ElectronicArtsCanada:                       ; "Electronic Arts Canada." string literal
        db 045h,06Ch,065h,063h,074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h,074h,073h,020h
        db 043h,061h,06Eh,061h,064h,061h,02Eh,00h
CreditPagePresentedBy:                          ; Credit page: production group presentation line
        db 03h,078h,00h,00h,00h
        dd str_Credit17
        dd str_ThisHasBeenA
        dd str_ThePIONEERPRODUCTIONSGroup
        dd str_ElectronicArtsCanada
str_OriginalGameConcept:                        ; "Original Game Concept:" string literal
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,047h,061h,06Dh,065h,020h,043h,06Fh
        db 06Eh,063h,065h,070h,074h,03Ah,00h
str_JimSimmons:                                 ; "Jim Simmons" string literal
        db 04Ah,069h,06Dh,020h,053h,069h,06Dh,06Dh,06Fh,06Eh,073h,00h
str_ScottOrr:                                   ; "Scott Orr" string literal
        db 053h,063h,06Fh,074h,074h,020h,04Fh,072h,072h,00h
str_RichardHilleman:                            ; "Richard Hilleman" string literal
        db 052h,069h,063h,068h,061h,072h,064h,020h,048h,069h,06Ch,06Ch,065h,06Dh,061h,06Eh
        db 00h
CreditPageGameConcept:                          ; Credit page: original game concept
        db 05h,078h,00h,00h,00h
        dd CreditBlankTitle
        dd str_OriginalGameConcept
        dd CreditBlankLine
        dd str_JimSimmons
        dd str_ScottOrr
        dd str_RichardHilleman
str_OriginalPCVersionGame:                      ; "Original PC Version Game Design:" string literal
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,050h,043h,020h,056h,065h,072h,073h
        db 069h,06Fh,06Eh,020h,047h,061h,06Dh,065h,020h,044h,065h,073h,069h,067h,06Eh,03Ah
        db 00h
str_DaveWarfield:                               ; "Dave Warfield" string literal
        db 044h,061h,076h,065h,020h,057h,061h,072h,066h,069h,065h,06Ch,064h,00h
str_RichardHilleman2:                           ; "Richard Hilleman" string literal
        db 052h,069h,063h,068h,061h,072h,064h,020h,048h,069h,06Ch,06Ch,065h,06Dh,061h,06Eh
        db 00h
CreditPagePcDesign:                             ; Credit page: original PC version game design
        db 04h,078h,00h,00h,00h
        dd CreditBlankTitle
        dd str_OriginalPCVersionGame
        dd CreditBlankLine
        dd str_DaveWarfield
        dd str_RichardHilleman2
str_LanceWall:                                  ; "Lance Wall" string literal
        db 04Ch,061h,06Eh,063h,065h,020h,057h,061h,06Ch,06Ch,00h
str_LeadProgrammer:                             ; "Lead Programmer" string literal
        db 04Ch,065h,061h,064h,020h,050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h,00h
CreditPageLeadProgrammer:                       ; Credit page: lead programmer
        db 03h,078h,00h,00h,00h
        dd str_Credit01
        dd str_LanceWall
        dd CreditBlankLine
        dd str_LeadProgrammer
str_VictoriaWong:                               ; "Victoria Wong" string literal
        db 056h,069h,063h,074h,06Fh,072h,069h,061h,020h,057h,06Fh,06Eh,067h,00h
str_Programmer:                                 ; "Programmer" string literal
        db 050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h,00h
CreditPageProgrammerWong:                       ; Credit page: programmer
        db 03h,078h,00h,00h,00h
        dd str_Credit15
        dd str_VictoriaWong
        dd CreditBlankLine
        dd str_Programmer
str_RobertPenner:                               ; "Robert Penner" string literal
        db 052h,06Fh,062h,065h,072h,074h,020h,050h,065h,06Eh,06Eh,065h,072h,00h
str_Programmer2:                                ; "Programmer" string literal
        db 050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h,00h
CreditPageProgrammerPenner:                     ; Credit page: programmer
        db 03h,078h,00h,00h,00h
        dd str_Credit12
        dd str_RobertPenner
        dd CreditBlankLine
        dd str_Programmer2
str_KurtKennett:                                ; "Kurt Kennett" string literal
        db 04Bh,075h,072h,074h,020h,04Bh,065h,06Eh,06Eh,065h,074h,074h,00h
str_Programmer3:                                ; "Programmer" string literal
        db 050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h,00h
CreditPageProgrammerKennett:                    ; Credit page: programmer
        db 03h,078h,00h,00h,00h
        dd str_Credit08
        dd str_KurtKennett
        dd CreditBlankLine
        dd str_Programmer3
str_GerardDeSouza:                              ; "Gerard DeSouza" string literal
        db 047h,065h,072h,061h,072h,064h,020h,044h,065h,053h,06Fh,075h,07Ah,061h,00h
str_Artist:                                     ; "Artist" string literal
        db 041h,072h,074h,069h,073h,074h,00h
CreditPageArtistDeSouza:                        ; Credit page: artist
        db 03h,078h,00h,00h,00h
        dd str_Credit02
        dd str_GerardDeSouza
        dd CreditBlankLine
        dd str_Artist
str_PhilChow:                                   ; "Phil Chow" string literal
        db 050h,068h,069h,06Ch,020h,043h,068h,06Fh,077h,00h
str_Artist2:                                    ; "Artist" string literal
        db 041h,072h,074h,069h,073h,074h,00h
CreditPageArtistChow:                           ; Credit page: artist
        db 03h,078h,00h,00h,00h
        dd str_Credit11
        dd str_PhilChow
        dd CreditBlankLine
        dd str_Artist2
str_KentMaclagan:                               ; "Kent Maclagan" string literal
        db 04Bh,065h,06Eh,074h,020h,04Dh,061h,063h,06Ch,061h,067h,061h,06Eh,00h
str_Artist3DAnimations:                         ; "Artist / 3D Animations" string literal
        db 041h,072h,074h,069h,073h,074h,020h,02Fh,020h,033h,044h,020h,041h,06Eh,069h,06Dh
        db 061h,074h,069h,06Fh,06Eh,073h,00h
CreditPageAnimator:                             ; Credit page: artist and 3D animations
        db 03h,078h,00h,00h,00h
        dd str_Credit05
        dd str_KentMaclagan
        dd CreditBlankLine
        dd str_Artist3DAnimations
str_MichaelJSokyrka:                            ; "Michael J. Sokyrka" string literal
        db 04Dh,069h,063h,068h,061h,065h,06Ch,020h,04Ah,02Eh,020h,053h,06Fh,06Bh,079h,072h
        db 06Bh,061h,00h
str_Composer:                                   ; "Composer" string literal
        db 043h,06Fh,06Dh,070h,06Fh,073h,065h,072h,00h
CreditPageComposer:                             ; Credit page: composer
        db 03h,078h,00h,00h,00h
        dd str_Credit06
        dd str_MichaelJSokyrka
        dd CreditBlankLine
        dd str_Composer
str_AlanStewart:                                ; "Alan Stewart" string literal
        db 041h,06Ch,061h,06Eh,020h,053h,074h,065h,077h,061h,072h,074h,00h
str_AudioProgrammer:                            ; "Audio Programmer" string literal
        db 041h,075h,064h,069h,06Fh,020h,050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h
        db 00h
CreditPageAudioStewart:                         ; Credit page: audio programmer
        db 03h,078h,00h,00h,00h
        dd str_Credit07
        dd str_AlanStewart
        dd CreditBlankLine
        dd str_AudioProgrammer
str_IainMacanulty:                              ; "Iain Macanulty" string literal
        db 049h,061h,069h,06Eh,020h,04Dh,061h,063h,061h,06Eh,075h,06Ch,074h,079h,00h
str_AudioProgrammer2:                           ; "Audio Programmer" string literal
        db 041h,075h,064h,069h,06Fh,020h,050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h
        db 00h
CreditPageAudioMacanulty:                       ; Credit page: audio programmer
        db 03h,078h,00h,00h,00h
        dd str_Credit18
        dd str_IainMacanulty
        dd CreditBlankLine
        dd str_AudioProgrammer2
str_SerenaMcCabe:                               ; "Serena McCabe" string literal
        db 053h,065h,072h,065h,06Eh,061h,020h,04Dh,063h,043h,061h,062h,065h,00h
str_AdministrativeAssistant:                    ; "Administrative Assistant" string literal
        db 041h,064h,06Dh,069h,06Eh,069h,073h,074h,072h,061h,074h,069h,076h,065h,020h,041h
        db 073h,073h,069h,073h,074h,061h,06Eh,074h,00h
CreditPageAdminAssistant:                       ; Credit page: administrative assistant
        db 03h,078h,00h,00h,00h
        dd str_Credit14
        dd str_SerenaMcCabe
        dd CreditBlankLine
        dd str_AdministrativeAssistant
str_RodHigo:                                    ; "Rod Higo" string literal
        db 052h,06Fh,064h,020h,048h,069h,067h,06Fh,00h
str_LeadTester:                                 ; "Lead Tester" string literal
        db 04Ch,065h,061h,064h,020h,054h,065h,073h,074h,065h,072h,00h
CreditPageLeadTester:                           ; Credit page: lead tester
        db 03h,078h,00h,00h,00h
        dd str_Credit13
        dd str_RodHigo
        dd CreditBlankLine
        dd str_LeadTester
str_RichardRadarMul:                            ; "Richard (Radar) Mul" string literal
        db 052h,069h,063h,068h,061h,072h,064h,020h,028h,052h,061h,064h,061h,072h,029h,020h
        db 04Dh,075h,06Ch,00h
str_AssistantProducer:                          ; "Assistant Producer" string literal
        db 041h,073h,073h,069h,073h,074h,061h,06Eh,074h,020h,050h,072h,06Fh,064h,075h,063h
        db 065h,072h,00h
CreditPageAssistantProducer:                    ; Credit page: assistant producer
        db 03h,078h,00h,00h,00h
        dd str_Credit16
        dd str_RichardRadarMul
        dd CreditBlankLine
        dd str_AssistantProducer
str_FosterHall:                                 ; "Foster Hall" string literal
        db 046h,06Fh,073h,074h,065h,072h,020h,048h,061h,06Ch,06Ch,00h
str_DirectorOfDevelopment:                      ; "Director of Development" string literal
        db 044h,069h,072h,065h,063h,074h,06Fh,072h,020h,06Fh,066h,020h,044h,065h,076h,065h
        db 06Ch,06Fh,070h,06Dh,065h,06Eh,074h,00h
CreditPageDevDirector:                          ; Credit page: director of development
        db 03h,078h,00h,00h,00h
        dd str_Credit00
        dd str_FosterHall
        dd CreditBlankLine
        dd str_DirectorOfDevelopment
str_KenSayler:                                  ; "Ken Sayler" string literal
        db 04Bh,065h,06Eh,020h,053h,061h,079h,06Ch,065h,072h,00h
str_ProducerDesign:                             ; "Producer & Design" string literal
        db 050h,072h,06Fh,064h,075h,063h,065h,072h,020h,026h,020h,044h,065h,073h,069h,067h
        db 06Eh,00h
CreditPageProducerDesign:                       ; Credit page: producer and design
        db 03h,078h,00h,00h,00h
        dd str_Credit04
        dd str_KenSayler
        dd CreditBlankLine
        dd str_ProducerDesign
str_HannoLemke:                                 ; "Hanno Lemke" string literal
        db 048h,061h,06Eh,06Eh,06Fh,020h,04Ch,065h,06Dh,06Bh,065h,00h
str_Producer:                                   ; "Producer" string literal
        db 050h,072h,06Fh,064h,075h,063h,065h,072h,00h
CreditPageProducer:                             ; Credit page: producer
        db 03h,078h,00h,00h,00h
        dd str_Credit03
        dd str_HannoLemke
        dd CreditBlankLine
        dd str_Producer
str_Testers:                                    ; "Testers:" string literal
        db 054h,065h,073h,074h,065h,072h,073h,03Ah,00h
str_PaulSmith:                                  ; "Paul Smith" string literal
        db 050h,061h,075h,06Ch,020h,053h,06Dh,069h,074h,068h,00h
str_JohnBrydon:                                 ; "John Brydon" string literal
        db 04Ah,06Fh,068h,06Eh,020h,042h,072h,079h,064h,06Fh,06Eh,00h
str_TonyLam:                                    ; "Tony Lam" string literal
        db 054h,06Fh,06Eh,079h,020h,04Ch,061h,06Dh,00h
str_DavidLee:                                   ; "David Lee" string literal
        db 044h,061h,076h,069h,064h,020h,04Ch,065h,065h,00h
str_QASupport:                                  ; "QA Support:" string literal
        db 051h,041h,020h,053h,075h,070h,070h,06Fh,072h,074h,03Ah,00h
str_JonBruce:                                   ; "Jon Bruce" string literal
        db 04Ah,06Fh,06Eh,020h,042h,072h,075h,063h,065h,00h
str_JohnSantamaria:                             ; "John Santamaria" string literal
        db 04Ah,06Fh,068h,06Eh,020h,053h,061h,06Eh,074h,061h,06Dh,061h,072h,069h,061h,00h
CreditPageTesters:                              ; Credit page: testers and QA support
        db 0Ch,0B4h,00h,00h,00h
        dd str_Credit17
        dd str_Testers
        dd CreditBlankLine
        dd str_PaulSmith
        dd str_JohnBrydon
        dd str_TonyLam
        dd str_DavidLee
        dd CreditBlankLine
        dd CreditBlankLine
        dd str_QASupport
        dd CreditBlankLine
        dd str_JonBruce
        dd str_JohnSantamaria
str_RosterVerification:                         ; "Roster Verification:" string literal
        db 052h,06Fh,073h,074h,065h,072h,020h,056h,065h,072h,069h,066h,069h,063h,061h,074h
        db 069h,06Fh,06Eh,03Ah,00h
str_DaveWarfield2:                              ; "Dave Warfield" string literal
        db 044h,061h,076h,065h,020h,057h,061h,072h,066h,069h,065h,06Ch,064h,00h
str_JohnBrydon2:                                ; "John Brydon" string literal
        db 04Ah,06Fh,068h,06Eh,020h,042h,072h,079h,064h,06Fh,06Eh,00h
str_ProductManager:                             ; "Product Manager:" string literal
        db 050h,072h,06Fh,064h,075h,063h,074h,020h,04Dh,061h,06Eh,061h,067h,065h,072h,03Ah
        db 00h
str_ChipLange:                                  ; "Chip Lange" string literal
        db 043h,068h,069h,070h,020h,04Ch,061h,06Eh,067h,065h,00h
str_RatingsByJohnRosasco:                       ; "Ratings by John Rosasco" string literal
        db 052h,061h,074h,069h,06Eh,067h,073h,020h,062h,079h,020h,04Ah,06Fh,068h,06Eh,020h
        db 052h,06Fh,073h,061h,073h,063h,06Fh,00h
str_AndNeilSmithOf:                             ; "and Neil Smith of the" string literal
        db 061h,06Eh,064h,020h,04Eh,065h,069h,06Ch,020h,053h,06Dh,069h,074h,068h,020h,06Fh
        db 066h,020h,074h,068h,065h,00h
str_NewYorkRangers:                             ; "New York Rangers" string literal
        db 04Eh,065h,077h,020h,059h,06Fh,072h,06Bh,020h,052h,061h,06Eh,067h,065h,072h,073h
        db 00h
CreditPageRosters:                              ; Credit page: roster verification and ratings
        db 0Ah,0B4h,00h,00h,00h
        dd CreditBlankTitle
        dd str_RosterVerification
        dd str_DaveWarfield2
        dd str_JohnBrydon2
        dd CreditBlankLine
        dd str_ProductManager
        dd str_ChipLange
        dd CreditBlankLine
        dd str_RatingsByJohnRosasco
        dd str_AndNeilSmithOf
        dd str_NewYorkRangers
str_AudioTechnician:                            ; "Audio Technician:" string literal
        db 041h,075h,064h,069h,06Fh,020h,054h,065h,063h,068h,06Eh,069h,063h,069h,061h,06Eh
        db 03Ah,00h
str_SteveRoyea:                                 ; "Steve Royea" string literal
        db 053h,074h,065h,076h,065h,020h,052h,06Fh,079h,065h,061h,00h
str_AudioProgrammers:                           ; "Audio Programmers:" string literal
        db 041h,075h,064h,069h,06Fh,020h,050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h
        db 073h,03Ah,00h
str_PaulChernikhowsky:                          ; "Paul Chernikhowsky" string literal
        db 050h,061h,075h,06Ch,020h,043h,068h,065h,072h,06Eh,069h,06Bh,068h,06Fh,077h,073h
        db 06Bh,079h,00h
str_JasonLeeSteere:                             ; "Jason Lee-Steere" string literal
        db 04Ah,061h,073h,06Fh,06Eh,020h,04Ch,065h,065h,02Dh,053h,074h,065h,065h,072h,065h
        db 00h
str_AdvancedGravis:                             ; "(Advanced Gravis)" string literal
        db 028h,041h,064h,076h,061h,06Eh,063h,065h,064h,020h,047h,072h,061h,076h,069h,073h
        db 029h,00h
CreditPageAudioTeam:                            ; Credit page: audio technician and audio programmers
        db 0Ah,0B4h,00h,00h,00h
        dd CreditBlankTitle
        dd str_AudioTechnician
        dd str_SteveRoyea
        dd CreditBlankLine
        dd CreditBlankLine
        dd str_AudioProgrammers
        dd CreditBlankLine
        dd str_PaulChernikhowsky
        dd CreditBlankLine
        dd str_JasonLeeSteere
        dd str_AdvancedGravis
str_SportsDeskAnnouncer:                        ; "SportsDesk Announcer:" string literal
        db 053h,070h,06Fh,072h,074h,073h,044h,065h,073h,06Bh,020h,041h,06Eh,06Eh,06Fh,075h
        db 06Eh,063h,065h,072h,03Ah,00h
str_MichaelDonovan:                             ; "Michael Donovan" string literal
        db 04Dh,069h,063h,068h,061h,065h,06Ch,020h,044h,06Fh,06Eh,06Fh,076h,061h,06Eh,00h
str_RinkAnnouncer:                              ; "Rink Announcer:" string literal
        db 052h,069h,06Eh,06Bh,020h,041h,06Eh,06Eh,06Fh,075h,06Eh,063h,065h,072h,03Ah,00h
str_BruceJamieson:                              ; "Bruce Jamieson" string literal
        db 042h,072h,075h,063h,065h,020h,04Ah,061h,06Dh,069h,065h,073h,06Fh,06Eh,00h
str_PlayerProfilePhotographs:                   ; "Player Profile Photographs:" string literal
        db 050h,06Ch,061h,079h,065h,072h,020h,050h,072h,06Fh,066h,069h,06Ch,065h,020h,050h
        db 068h,06Fh,074h,06Fh,067h,072h,061h,070h,068h,073h,03Ah,00h
str_SteveBabineau:                              ; "Steve Babineau" string literal
        db 053h,074h,065h,076h,065h,020h,042h,061h,062h,069h,06Eh,065h,061h,075h,00h
CreditPageAnnouncers:                           ; Credit page: announcers and player photographs
        db 08h,0B4h,00h,00h,00h
        dd str_Credit17
        dd str_SportsDeskAnnouncer
        dd str_MichaelDonovan
        dd CreditBlankLine
        dd str_RinkAnnouncer
        dd str_BruceJamieson
        dd CreditBlankLine
        dd str_PlayerProfilePhotographs
        dd str_SteveBabineau
str_VideoProvidedBy:                            ; "Video Provided By:" string literal
        db 056h,069h,064h,065h,06Fh,020h,050h,072h,06Fh,076h,069h,064h,065h,064h,020h,042h
        db 079h,03Ah,00h
str_NHLProductions:                             ; "NHL Productions" string literal
        db 04Eh,048h,04Ch,020h,050h,072h,06Fh,064h,075h,063h,074h,069h,06Fh,06Eh,073h,00h
str_SpecialThanks:                              ; "Special Thanks:" string literal
        db 053h,070h,065h,063h,069h,061h,06Ch,020h,054h,068h,061h,06Eh,06Bh,073h,03Ah,00h
str_ScottJackson:                               ; "Scott Jackson" string literal
        db 053h,063h,06Fh,074h,074h,020h,04Ah,061h,063h,06Bh,073h,06Fh,06Eh,00h
str_CatherineOBrien:                            ; "Catherine O'Brien" string literal
        db 043h,061h,074h,068h,065h,072h,069h,06Eh,065h,020h,04Fh,027h,042h,072h,069h,065h
        db 06Eh,00h
str_DougReid:                                   ; "Doug Reid" string literal
        db 044h,06Fh,075h,067h,020h,052h,065h,069h,064h,00h
str_MottLinn:                                   ; "Mott Linn" string literal
        db 04Dh,06Fh,074h,074h,020h,04Ch,069h,06Eh,06Eh,00h
CreditPageSpecialThanks:                        ; Credit page: video credit and special thanks
        db 08h,0B4h,00h,00h,00h
        dd str_Credit17
        dd str_VideoProvidedBy
        dd str_NHLProductions
        dd CreditBlankLine
        dd str_SpecialThanks
        dd str_ScottJackson
        dd str_CatherineOBrien
        dd str_DougReid
        dd str_MottLinn
CreditPageEnd:                                  ; Empty credit page that ends the credits; ShowCredits stops
                                                ; when it reaches it; used by ShowCredits
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
creditpages:                                    ; ShowCredits: pointers to the 29 credit pages; used by
                                                ; ShowCredits
        dd CreditPageNhlLicense
        dd CreditPageNhlpaLicense
        dd CreditPageStanleyCup
        dd CreditPageEaSports
        dd CreditPagePresentedBy
        dd CreditPageGameConcept
        dd CreditPagePcDesign
        dd CreditPageLeadProgrammer
        dd CreditPageProgrammerWong
        dd CreditPageProgrammerPenner
        dd CreditPageProgrammerKennett
        dd CreditPageArtistDeSouza
        dd CreditPageArtistChow
        dd CreditPageAnimator
        dd CreditPageComposer
        dd CreditPageAudioStewart
        dd CreditPageAudioMacanulty
        dd CreditPageAdminAssistant
        dd CreditPageAssistantProducer
        dd CreditPageDevDirector
        dd CreditPageProducerDesign
        dd CreditPageProducer
        dd CreditPageLeadTester
        dd CreditPageTesters
        dd CreditPageRosters
        dd CreditPageAudioTeam
        dd CreditPageAnnouncers
        dd CreditPageSpecialThanks
        dd CreditPageEnd
        db 00h,00h,00h
textgrid:                                       ; 100 x 36 character copy of the screen text (TextGridOpen /
                                                ; TextGridPut); used by TextGridFree, TextGridOpen,
                                                ; TextGridPut ...
        db 00h,00h,00h,00h
textgridon:                                     ; 1 while TextGridPut logs text; used by TextGridOff,
                                                ; TextGridOpen, TextGridPut
        db 00h,00h,00h,00h
textcolor:                                      ; text colour for the Print* routines (SetTextColors); used by
                                                ; PrintCenteredText, PrintOutlinedText, PrintShadowText ...
        db 0Fh,00h,00h,00h
textshadow:                                     ; shadow / outline colour for the Print* routines
                                                ; (SetTextColors); used by PrintCenteredText,
                                                ; PrintOutlinedText, PrintShadowText ...
        db 00h,00h,00h,00h
textoutlinedx:                                  ; 4 x offsets for PrintOutlinedText; used by PrintOutlinedText
        db 0FFh,0FFh,0FFh,0FFh,01h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
textoutlinedy:                                  ; 4 y offsets for PrintOutlinedText; used by PrintOutlinedText
        db 00h,00h,00h,00h,00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,01h,00h,00h,00h
str_TheFileYouSpecified:                        ; "The file you specified already exists!" string literal
        db 054h,068h,065h,020h,066h,069h,06Ch,065h,020h,079h,06Fh,075h,020h,073h,070h,065h
        db 063h,069h,066h,069h,065h,064h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,065h
        db 078h,069h,073h,074h,073h,021h,00h
str_DoYouWantTo:                                ; "Do you want to overwrite the old file?" string literal
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,06Fh
        db 076h,065h,072h,077h,072h,069h,074h,065h,020h,074h,068h,065h,020h,06Fh,06Ch,064h
        db 020h,066h,069h,06Ch,065h,03Fh,00h
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
hlplayedmask:                                   ; bits of the 6 highlights already shown (PlayRandomHighlight,
                                                ; IntermissionDesk); used by IntermissionDesk,
                                                ; PlayRandomHighlight
        db 00h,00h,00h,00h
str_ReturningToSportsCentral:                   ; string 'Returning to sports central'; used by
                                                ; DeskReturnConfirm
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,074h,06Fh,020h,073h,070h,06Fh
        db 072h,074h,073h,020h,063h,065h,06Eh,074h,072h,061h,06Ch,00h
str_ReturningOutOfThe:                          ; string 'Returning out of the game'; used by
                                                ; DeskReturnConfirm
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,06Fh,075h,074h,020h,06Fh,066h
        db 020h,074h,068h,065h,020h,067h,061h,06Dh,065h,00h
str_ReturningToThePlayoff:                      ; string 'Returning to the playoff tree'; used by
                                                ; DeskReturnConfirm
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,074h,06Fh,020h,074h,068h,065h
        db 020h,070h,06Ch,061h,079h,06Fh,066h,066h,020h,074h,072h,065h,065h,00h
str_ExitingTheGame:                             ; string 'Exiting the game'; used by DeskExitGame
        db 045h,078h,069h,074h,069h,06Eh,067h,020h,074h,068h,065h,020h,067h,061h,06Dh,065h
        db 00h
str_MayLoseThisGame:                            ; "may lose this game's data." string literal
        db 06Dh,061h,079h,020h,06Ch,06Fh,073h,065h,020h,074h,068h,069h,073h,020h,067h,061h
        db 06Dh,065h,027h,073h,020h,064h,061h,074h,061h,02Eh,00h
str_DoYouWishToReturn:                          ; string 'Do you wish to return?'; used by DeskReturnConfirm
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,072h
        db 065h,074h,075h,072h,06Eh,03Fh,00h
str_DoYouWishToExit:                            ; string 'Do you wish to exit?'; used by DeskExitGame
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,065h
        db 078h,069h,074h,03Fh,00h
msg_DeskExit:                                   ; DeskExitGame / DeskReturnConfirm message lines; line 0 is
                                                ; patched; used by DeskExitGame, DeskReturnConfirm
        db 00h,00h,00h,00h
        dd str_MayLoseThisGame
msg_DeskExit_e02:                               ; msg_DeskExit[2], patched with 'Do you wish to exit /
                                                ; return'; used by DeskExitGame, DeskReturnConfirm
        db 00h,00h,00h,00h
CdStreamRateFactor:                             ; Rate factor (0Dh) the CD stream code scales its read sizes
                                                ; by; used by CdStreamCreate, CdStreamService
        db 0Dh,00h,00h,00h
RosterStatusByInjury:                           ; Roster status code per injury value (word entries) used by
                                                ; LoadTeamRoster
        db 07h,00h,04h,00h,03h,00h,06h,00h,01h,00h,08h,00h,02h,00h,00h,00h
screenbm:                                       ; pointer to the screen bitmap descriptor (set in main_
                                                ; startup), selected by SelectScreenBM; used by
                                                ; SelectScreenBM, main_
        db 00h,00h,00h,00h
dirtyrectcount:                                 ; per-page rect count; used by AddDirtyRect
        db 00h,00h,00h,00h,00h,00h,00h,00h
DeskRedrawAll:                                  ; Flag set when the desk and replay screens must be redrawn in
                                                ; full; used by DeskGoToReplay, DeskReloadGame,
                                                ; DeskReturnConfirm ...
        db 00h,00h,00h,00h
DeskRedrawFlag:                                 ; Flag set after the desk photos load and fade in so the desk
                                                ; redraws; used by DeskGoToReplay, DeskReloadGame,
                                                ; DeskReturnConfirm ...
        db 00h,00h,00h,00h
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd VgaBlitKeyed
        dd VgaBlitKeyedFlipV
        dd VgaBlitRemap
        dd VgaBlitRemapFlipV
        dd VgaBlitKeyedFlipH
        dd VgaBlitKeyedFlipHV
        dd VgaBlitRemapFlipH
        dd VgaBlitRemapFlipHV
lastsprremap:                                   ; cached remap selection in DrawSprite; used by DrawSprite
        db 0FFh,0FFh,0FFh,0FFh
mi_9394Season:                                  ; "Statistics Type" menu item text (first byte 1 = selected, 2
                                                ; = not); used by MakeStatsTitle, SetupStatsSourceMenu_all,
                                                ; SetupStatsSourceMenu_exh ...
        db 01h,020h
str_9394Season:                                 ; string; used by MakeStatsTitle
        db 027h,039h,033h,020h,02Dh,020h,027h,039h,034h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 00h
mi_9394Playoffs:                                ; menu item "'93 - '94 Play-Offs"; used by MakeStatsTitle,
                                                ; SetupStatsSourceMenu_all, SetupStatsSourceMenu_exh ...
        db 02h,020h
str_9394PlayOffs:                               ; string; used by MakeStatsTitle
        db 027h,039h,033h,020h,02Dh,020h,027h,039h,034h,020h,050h,06Ch,061h,079h,02Dh,04Fh
        db 066h,066h,073h,00h
mi_LeagueSeason:                                ; menu item "<league> Season"; used by BuildSavedGameLabels,
                                                ; MakeStatsTitle, SetupStatsSourceMenu_all ...
        db 02h,020h
str_LgSeasonTitle:                              ; '"' + league name + '" Season'; used by
                                                ; BuildSavedGameLabels, MakeStatsTitle
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 00h
mi_LeaguePlayoffs:                              ; menu item "<league> Season Play-Offs"; used by
                                                ; BuildSavedGameLabels, MakeStatsTitle,
                                                ; SetupStatsSourceMenu_all ...
        db 02h,020h
str_LgPlayoffsTitle:                            ; string; used by BuildSavedGameLabels, MakeStatsTitle
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,073h,00h
mi_PlayoffMode:                                 ; menu item "<name> Play-Offs"; used by BuildSavedGameLabels,
                                                ; MakeStatsTitle, SetupStatsSourceMenu_all ...
        db 02h,020h
str_POTitle:                                    ; string; used by BuildSavedGameLabels, DrawPlayoffTree,
                                                ; MakeStatsTitle
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,050h,06Ch,061h,079h,02Dh,04Fh
        db 066h,066h,073h,00h
str_StatsSourceDivider:                         ; Dashed divider text between statistics source groups
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
StatsSourceLastBottom:                          ; Base that reaches the bottom edge of the last statistics
                                                ; source item when indexed by the item count; used by
                                                ; SetupStatsSourceMenu_all
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
str_Dashes:                                     ; string '-------'; used by SetupStatsSourceMenu_all
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,00h
StatsSourceMenu:                                ; Statistics Type pull-down: 93-94 season playoffs league and
                                                ; playoff mode sources
        db 00h,00h,00h,00h,00h,00h,00h,00h
StatsSourceMenuRight:                           ; Right edge of each statistics source item (32-byte stride);
                                                ; used by SetupStatsSourceMenu_all
        db 0F7h,00h,00h,00h
StatsSourceMenuBottom:                          ; Bottom edge of each statistics source item (32-byte stride);
                                                ; used by SetupStatsSourceMenu_all
        db 011h,00h,00h,00h
        dd mi_9394Season
        dd StatsSel9394Season
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0F7h,00h,00h,00h,023h,00h,00h,00h
        dd mi_9394Playoffs
        dd StatsSel9394Playoffs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 0F7h,00h,00h,00h,035h,00h,00h,00h
        dd str_StatsSourceDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 036h,00h,00h,00h,0F7h,00h,00h,00h,047h,00h,00h,00h
menutext_statsleague:                           ; stats source menu: text slot of the league item
                                                ; (SetupStatsSourceMenu); used by SetupStatsSourceMenu_all,
                                                ; SetupStatsSourceMenu_lg, SetupStatsSourceMenu_po
        dd mi_LeagueSeason
menuact_statsleague:                            ; stats source menu: action slot of the league item; used by
                                                ; SetupStatsSourceMenu_all, SetupStatsSourceMenu_lg,
                                                ; SetupStatsSourceMenu_po
        dd StatsSelLeague
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 0F7h,00h,00h,00h,059h,00h,00h,00h
menutext_statslgplayoffs:                       ; stats source menu: text slot of the league playoffs item;
                                                ; used by SetupStatsSourceMenu_all, SetupStatsSourceMenu_lg
        dd mi_LeaguePlayoffs
menuact_statslgplayoffs:                        ; stats source menu: action slot of the league playoffs item;
                                                ; used by SetupStatsSourceMenu_all, SetupStatsSourceMenu_lg
        dd StatsSelLeaguePlayoffs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 0F7h,00h,00h,00h,06Bh,00h,00h,00h
        dd str_StatsSourceDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 06Ch,00h,00h,00h,0F7h,00h,00h,00h,07Eh,00h,00h,00h
menutext_statsplayoff:                          ; stats source menu: text slot of the playoff mode item; used
                                                ; by SetupStatsSourceMenu_all
        dd mi_PlayoffMode
menuact_statsplayoff:                           ; stats source menu: action slot of the playoff mode item;
                                                ; used by SetupStatsSourceMenu_all
        dd StatsSelPlayoffMode
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_SeasonSfx:                                  ; string; used by BuildSavedGameLabels
        db 022h,020h,053h,065h,061h,073h,06Fh,06Eh,00h
str_SeasonPlayOffsSfx:                          ; string; used by BuildSavedGameLabels
        db 022h,020h,053h,065h,061h,073h,06Fh,06Eh,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h
        db 066h,073h,00h
str_PlayOffsSfx:                                ; string; used by BuildSavedGameLabels
        db 022h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,073h,00h,00h,00h,00h
divisionnames:                                  ; Pacific / Central / Northeast / Atlantic Division; used by
                                                ; StandingsScreen
        dd str_PacificDivision
        dd str_CentralDivision
        dd str_NortheastDivision
        dd str_AtlanticDivision
statslabels:                                    ; Season: / Playoff: / reg. season / playoff / actual /
                                                ; accumulated; used by GoalieStatsCard, SkaterStatsCard
        dd str_Season3
        dd str_Playoff3
        dd str_RegSeason
        dd str_Playoff4
        dd str_Actual
        dd str_Accumulated
statsbgnames:                                   ; embnhl / embscup; used by CalStandingsScreen,
                                                ; EasnStandingsScreen, GameStandingsScreen ...
        dd str_embnhl
        dd str_embscup
statsplayerdbs:                                 ; career.db / season.db by statsfromleague; used by
                                                ; GoalieStatsCard, LeadersScreen, SkaterStatsCard ...
        dd str_careerdb
        dd str_seasondb
statsteamdbs:                                   ; carteams.db / teams.db; used by GoalieStatsCard,
                                                ; LeadersScreen, SkaterStatsCard ...
        dd str_carteamsdb
        dd str_teamsdb
str_AttDb:                                      ; string 'att.db'; used by GoalieStatsCard, SkaterStatsCard
        db 061h,074h,074h,02Eh,064h,062h,00h
str_fmt2d:                                      ; string '%2d'; used by DrawEditRosters, DrawRosterList,
                                                ; GoalieStatsCard ...
        db 025h,032h,064h,00h
str_fmt3d:                                      ; string '%3d'; used by DrawGloveField, DrawShootsField,
                                                ; GoalieStatsCard ...
        db 025h,033h,064h,00h
str_fmt4d:                                      ; string '%4d'; used by GoalieStatsCard, LeadersScreen,
                                                ; LeadersScreen_colPlusMinus ...
        db 025h,034h,064h,00h
str_fmt5d:                                      ; string '%5d'; used by GoalieStatsCard,
                                                ; LeadersScreen_colShootPct, SkaterStatsCard ...
        db 025h,035h,064h,00h
str_fmtTenths:                                  ; string '%3d.%1d'; used by LeadersScreen_colShootPct,
                                                ; ShowRosterStats, SkaterStatsCard ...
        db 025h,033h,064h,02Eh,025h,031h,064h,00h
str_fmtPct:                                     ; string '%1d.%03d'; used by GoalieStatsCard,
                                                ; LeadersScreen_colSavePct, StandingsScreen ...
        db 025h,031h,064h,02Eh,025h,030h,033h,064h,00h
str_fmtPct0:                                    ; string ' .%03d'; used by GoalieStatsCard,
                                                ; LeadersScreen_colSavePct, StandingsScreen ...
        db 020h,02Eh,025h,030h,033h,064h,00h
str_fmtMinSec:                                  ; string '%2d.%2.2d'; used by GoalieStatsCard,
                                                ; LeadersScreen_colGAA, ShowRosterStats ...
        db 025h,032h,064h,02Eh,025h,032h,02Eh,032h,064h,00h
str_fmtEmb:                                     ; string 'emb%s'; used by GoalieStatsCard, ShowRosterStats,
                                                ; SkaterStatsCard ...
        db 065h,06Dh,062h,025h,073h,00h
str_Bkgd2:                                      ; string 'bkgd'; used by DrawPlayoffTree, GoalieStatsCard,
                                                ; LeadersScreen ...
        db 062h,06Bh,067h,064h,00h
str_EASNvfn:                                    ; string; used by CalStandingsScreen, EasnStandingsScreen,
                                                ; GameStandingsScreen
        db 045h,041h,053h,04Eh,02Eh,076h,066h,06Eh,00h,077h,069h,074h,074h,06Ch,065h,030h
        db 036h,02Eh,076h,066h,06Eh,00h
statsplayoffs:                                  ; 1 for play-off stats (StatsSel*); used by
                                                ; CalStandingsMenu_standings, CalStandingsScreen, CmpAssists
                                                ; ...
        db 00h,00h,00h,00h
statsfromleague:                                ; stats source: 0 the built-in '93 - '94 data, 1 a user league
                                                ; / Play-Off file (StatsSel*); used by GoalieStatsCard,
                                                ; LeadersScreen, OpenStatsSchedule ...
        db 00h,00h,00h,00h,00h,00h
photoremap:                                     ; remap table for photos; used by DrawPhotoWithPal
        db 044h,045h,046h,047h,048h,049h,04Ah,04Bh,04Ch,04Dh,04Eh,04Fh,050h,051h,052h,053h
        db 054h,055h,056h,057h,058h,059h,05Ah,05Bh,05Ch,05Dh,05Eh,05Fh,060h,061h,062h,063h
        db 064h,065h,066h,067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh,070h,071h,072h,073h
        db 074h,075h,076h,077h,078h,079h,07Ah,07Bh,07Ch,07Dh,07Eh,07Fh,0C4h,0C5h,0C6h,0C7h
        db 0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh,0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h
        db 0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh,0E0h,0E1h,0E2h,0E3h,0E4h,0E5h,0E6h,0E7h
        db 0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh,0F0h,0F1h,0F2h,0F3h,0F4h,0F5h,0F6h,0F7h
        db 0F8h,0F9h,0FAh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
statspalvalid:                                  ; nonzero = use statspal copy (cleared by RunPlayerPickMenu);
                                                ; used by DrawPhotoWithPal, EasnStandingsMenu_player2,
                                                ; GameSkaterStatsScreen ...
        db 00h,00h,00h,00h
skaterratingnames:                              ; Speed .. Faceoffs; used by SkaterStatsCard
        dd str_Speed
        dd str_Agility
        dd str_Weight
        dd str_ShotPower
        dd str_Checking2
        dd str_StickHandling
        dd str_Accuracy
        dd str_Passing2
        dd str_OffensiveAwareness
        dd str_DefensiveAwareness
        dd str_Aggressiveness
        dd str_Endurance
        dd str_ShootPassBias
skatercardattrs_m3 equ $+1
        dd str_Faceoffs
        db 01h,02h,03h,04h,05h,06h,07h,09h,0Ah,0Bh,0Ch,0Dh,0Eh,013h,00h,00h
goalieratingnames:                              ; Glove Left .. Defensive Awareness; used by GoalieStatsCard
        dd str_GloveLeft
        dd str_GloveRight
        dd str_StickLeft
        dd str_StickRight
        dd str_PuckControl
        dd str_Speed2
        dd str_Agility2
        dd str_Weight2
        dd str_OffensiveAwareness2
goaliecardattrs_m3 equ $+1
        dd str_DefensiveAwareness2
        db 01h,02h,03h,04h,05h,06h,07h,08h,0Ah,0Bh,00h,00h
teamsortfns:                                    ; team stats comparators by statscategory; used by
                                                ; TeamStatsScreen_keyPen
        dd CmpTeamScoring
        dd CmpTeamDefense
        dd CmpTeamPK
        dd CmpTeamPP
        dd CmpTeamPenalties
        dd CmpTeamStandings
westconfteams:                                  ; 12 team indices + 63h pad (Western, 12 teams in 94-95); used
                                                ; by TeamStatsScreen_keyPen
        db 04h,00h,00h,00h,02h,00h,00h,00h,014h,00h,00h,00h,08h,00h,00h,00h
        db 011h,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,012h,00h,00h,00h
        db 018h,00h,00h,00h,07h,00h,00h,00h,05h,00h,00h,00h,017h,00h,00h,00h
        db 063h,00h,00h,00h,063h,00h,00h,00h
eastconfteams:                                  ; 14 team indices (Eastern); used by TeamStatsScreen_keyPen
        db 0Ch,00h,00h,00h,0Fh,00h,00h,00h,0Ah,00h,00h,00h,00h,00h,00h,00h
        db 09h,00h,00h,00h,01h,00h,00h,00h,016h,00h,00h,00h,0Bh,00h,00h,00h
        db 019h,00h,00h,00h,0Eh,00h,00h,00h,010h,00h,00h,00h,013h,00h,00h,00h
        db 06h,00h,00h,00h,0Dh,00h,00h,00h
westconfname:                                   ; -> "Western Conference"; used by TeamStatsScreen_keyPen
        dd str_WesternConference3
eastconfname:                                   ; -> "Eastern Conference"; used by TeamStatsScreen_keyPen
        dd str_EasternConference3
teamstattitles:                                 ; " Team Scoring" .. " Team Standings"; used by
                                                ; TeamStatsScreen_keyPen
        dd str_TeamScoring
        dd str_TeamDefense
        dd str_TeamPenaltyKilling
        dd str_TeamPowerPlay
        dd str_TeamPenalties
        dd str_TeamStandings
teamcolhdrs:                                    ; team stats column header pointers; used by
                                                ; TeamStatsScreen_keyPen
        dd str_spW
        dd str_SpL4
        dd str_SpT
        dd str_GF2
        dd str_spW
        dd str_SpL4
        dd str_SpT
        dd str_GA4
        dd str_TSH
        dd str_PPGA
        dd str_PCT5
        dd str_BlankTeamColumn
        dd str_ADV
        dd str_PPG3
        dd str_PCT5
        dd str_BlankTeamColumn
        dd str_PIM5
        dd str_AVG
        dd str_BlankTeamColumn
        dd str_BlankTeamColumn
        dd str_PTS
        dd str_WINS
        dd str_BlankTeamColumn
        dd str_BlankTeamColumn
leadersortfns:                                  ; leader comparators by statscategory; used by LeadersScreen
        dd CmpPoints
        dd CmpGoals
        dd CmpAssists
        dd CmpPPGoals
        dd CmpSHGoals
        dd CmpPlusMinus
        dd CmpPIM
        dd CmpShootPct
        dd CmpGAA
        dd CmpGoalieWins
        dd CmpSavePct
leadertitles:                                   ; " Point Leaders" .. " Save Percentage Leaders"; used by
                                                ; LeadersScreen
        dd str_PointLeaders
        dd str_GoalLeaders
        dd str_AssistLeaders
        dd str_PowerPlayGoalLeaders
        dd str_ShorthandedGoalLeaders
        dd str_PlusMinusLeaders
        dd str_PenaltyMinuteLeaders
        dd str_ShootingPercentageLeaders
        dd str_GoalsAgainstAverageLeaders
        dd str_GoaltenderWinLeaders
        dd str_SavePercentageLeaders
leadercolhdrs:                                  ; LeadersScreen: column header strings, five per category;
                                                ; first column; used by LeadersScreen
        dd str_spG
leadercolhdrs_c1:                               ; leadercolhdrs+4: second column; used by LeadersScreen
        dd str_spA
leadercolhdrs_c2:                               ; leadercolhdrs+8: third column; used by LeadersScreen
        dd str_Pt3
leadercolhdrs_c3:                               ; leadercolhdrs+0Ch: fourth column; used by LeadersScreen
        dd str_BlankLeaderColumn
leadercolhdrs_c4:                               ; leadercolhdrs+10h: fifth column; used by LeadersScreen
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_BlankLeaderColumn
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_BlankLeaderColumn
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PP2
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_SHG3
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PlusMinus5
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PIM6
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_Shots5
        dd str_Pct6
        dd str_MIN5
        dd str_GA5
        dd str_AVG2
        dd str_BlankLeaderColumn
        dd str_BlankLeaderColumn
        dd str_MIN5
        dd str_spW2
        dd str_SpL5
        dd str_SpT2
        dd str_BlankLeaderColumn
        dd str_MIN5
        dd str_GA5
        dd str_SA4
        dd str_PCT7
        dd str_BlankLeaderColumn
        dd str_LSSCEDDB
potreeround_m2 equ $+2
        dd str_SCHEDULEDB3
potreeround:                                    ; PlayoffTreeMenu: the round the playoff tree shows; the tree
                                                ; is redrawn when it changes; used by PlayoffTreeMenu
        db 070h,0FFh
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
pregamebuttons:                                 ; 4 x 1Ch buttons (x, y, w, h, .., text); used by
                                                ; PreGameScreen
        db 030h,00h,00h,00h,0BCh,01h,00h,00h,064h,00h,00h,00h,018h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_AwayLines
        db 0C4h,00h,00h,00h,0BCh,01h,00h,00h,064h,00h,00h,00h,018h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Play
        db 058h,01h,00h,00h,0BCh,01h,00h,00h,064h,00h,00h,00h,018h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Cancel
        db 0ECh,01h,00h,00h,0BCh,01h,00h,00h,064h,00h,00h,00h,018h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_HomeLines
str_PenaltyKilling:                             ; string
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h,06Ch,06Ch,069h,06Eh,067h,00h
str_PowerPlay:                                  ; string
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,00h
str_Shooting:                                   ; string
        db 053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,00h
str_Skating:                                    ; string
        db 053h,06Bh,061h,074h,069h,06Eh,067h,00h
str_Passing:                                    ; string
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_Defense2:                                   ; string
        db 044h,065h,066h,065h,06Eh,073h,065h,00h
str_Checking:                                   ; string
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_Goaltending:                                ; string
        db 047h,06Fh,061h,06Ch,074h,065h,06Eh,064h,069h,06Eh,067h,00h
str_Overall:                                    ; string
        db 04Fh,076h,065h,072h,020h,061h,06Ch,06Ch,00h
scoutcatnames:                                  ; Penalty Killing .. Over all (9); used by PreGameScreen
        dd str_PenaltyKilling
        dd str_PowerPlay
        dd str_Shooting
        dd str_Skating
        dd str_Passing
        dd str_Defense2
        dd str_Checking
        dd str_Goaltending
        dd str_Overall
scoutcatidx:                                    ; team rating index per scouting category; used by
                                                ; PreGameScreen
        db 00h,01h,04h,05h,06h,07h,08h,0Ah,0Bh,00h,00h,00h
fdlgshapes:                                     ; open_but shape file handle; used by LoadDbDialogShapes,
                                                ; LoadFileDlgShapes, MenuOpenDatabase ...
        db 00h,00h,00h,00h
fdlgfilelists:                                  ; file dialog: file list of each tab (lgfiles, pofiles,
                                                ; exhfiles), by fdlgtab; used by DrawFileDlg,
                                                ; DrawFileDlgList_n1, DrawFileDlgTabs ...
        dd lgfiles
fdlgfilelists_e01:                              ; fdlgfilelists[1] (pofiles); used by RunFileDlg
        dd pofiles
fdlgfilelists_e02:                              ; fdlgfilelists[2] (exhfiles); used by RunFileDlg
        dd exhfiles
fdlgrects:                                      ; 16 hotspot rects (x0, y0, x1, y1); used by DrawFileDlg,
                                                ; DrawFileDlgList, DrawFileDlgList_n1 ...
        db 0Eh,00h,00h,00h
        db 033h,00h,00h,00h
        db 01Ah,00h,00h,00h
        db 03Dh,00h,00h,00h,0Eh,00h,00h,00h,094h,00h,00h,00h,01Ah,00h,00h,00h
        db 09Eh,00h,00h,00h,016h,00h,00h,00h,0ACh,00h,00h,00h,048h,00h,00h,00h
        db 0BCh,00h,00h,00h,05Dh,00h,00h,00h,0ACh,00h,00h,00h,08Fh,00h,00h,00h
        db 0BCh,00h,00h,00h,0A4h,00h,00h,00h,0ACh,00h,00h,00h,0D6h,00h,00h,00h
        db 0BCh,00h,00h,00h,099h,00h,00h,00h,038h,00h,00h,00h,0DFh,00h,00h,00h
        db 049h,00h,00h,00h,099h,00h,00h,00h,050h,00h,00h,00h,0DFh,00h,00h,00h
        db 061h,00h,00h,00h,099h,00h,00h,00h,068h,00h,00h,00h,0DFh,00h,00h,00h
        db 079h,00h,00h,00h
        db 0Fh,00h,00h,00h
        db 041h,00h,00h,00h
        db 019h,00h,00h,00h
        db 090h,00h,00h,00h
        db 081h,00h,00h,00h
        db 09h,00h,00h,00h
        db 0E4h,00h,00h,00h
        db 01Ah,00h,00h,00h
        db 025h,00h,00h,00h
        db 03Bh,00h,00h,00h
        db 082h,00h,00h,00h
        db 046h,00h,00h,00h,025h,00h,00h,00h,04Bh,00h,00h,00h,082h,00h,00h,00h
        db 056h,00h,00h,00h,025h,00h,00h,00h,05Bh,00h,00h,00h,082h,00h,00h,00h
        db 066h,00h,00h,00h,025h,00h,00h,00h,06Bh,00h,00h,00h,082h,00h,00h,00h
        db 076h,00h,00h,00h,025h,00h,00h,00h,07Bh,00h,00h,00h,082h,00h,00h,00h
        db 086h,00h,00h,00h,025h,00h,00h,00h,08Bh,00h,00h,00h,082h,00h,00h,00h
        db 096h,00h,00h,00h
str_ConfirmDeletionOfThe:                       ; "Confirm Deletion of the" string literal
        db 043h,06Fh,06Eh,066h,069h,072h,06Dh,020h,044h,065h,06Ch,065h,074h,069h,06Fh,06Eh
        db 020h,06Fh,066h,020h,074h,068h,065h,00h
str_ExhibitionGameCalled:                       ; string 'Exhibition Game Called:'; used by DeleteSavedGame
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,020h,047h,061h,06Dh,065h,020h
        db 043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
str_LeagueCalled:                               ; string 'League Called:'; used by DeleteSavedGame
        db 04Ch,065h,061h,067h,075h,065h,020h,043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
str_PlayOffSeriesCalled:                        ; string 'Play-Off Series Called:'; used by DeleteSavedGame
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,053h,065h,072h,069h,065h,073h,020h
        db 043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
delmsgbox:                                      ; DeleteSavedGame MessageBox args (title at +4); used by
                                                ; DeleteSavedGame
        dd str_ConfirmDeletionOfThe
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h
str_NoScoring:                                  ; string 'No Scoring.'; used by GameSummaryScreen_period
        db 04Eh,06Fh,020h,053h,063h,06Fh,072h,069h,06Eh,067h,02Eh,00h
str_NoPenalties:                                ; string 'No Penalties.'; used by GameSummaryScreen_period
        db 04Eh,06Fh,020h,050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,02Eh,00h,00h,00h
str_gsScore:                                    ; string 'Score'
        db 053h,063h,06Fh,072h,065h,00h
str_gsShots:                                    ; string 'Shots'
        db 053h,068h,06Fh,074h,073h,00h
str_gsPowerPlay:                                ; string 'Power play'
        db 050h,06Fh,077h,065h,072h,020h,070h,06Ch,061h,079h,00h
str_gsPenalties:                                ; string 'Penalties'
        db 050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,00h
str_gsFaceoffsWon:                              ; string 'Faceoffs won'
        db 046h,061h,063h,065h,06Fh,066h,066h,073h,020h,077h,06Fh,06Eh,00h
str_gsBodyChecks:                               ; string 'Body checks'
        db 042h,06Fh,064h,079h,020h,063h,068h,065h,063h,06Bh,073h,00h
str_gsAttackZone:                               ; string 'Attack zone'
        db 041h,074h,074h,061h,063h,06Bh,020h,07Ah,06Fh,06Eh,065h,00h
str_gsPassing:                                  ; string 'Passing'
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_gsOneTimers:                                ; string 'One Timers'
        db 04Fh,06Eh,065h,020h,054h,069h,06Dh,065h,072h,073h,00h
str_gsPPMinutes:                                ; string 'Power Play Minutes'
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,04Dh,069h,06Eh,075h,074h
        db 065h,073h,00h
str_gsPPShots:                                  ; string 'Power Play Shots'
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,053h,068h,06Fh,074h,073h
        db 00h
str_gsOffFaceoffs:                              ; string 'Offensive Faceoffs won'
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,046h,061h,063h,065h,06Fh,066h
        db 066h,073h,020h,077h,06Fh,06Eh,00h
gamestatlabels:                                 ; 12 GameStatsScreen row labels; used by GameStatsScreen
        dd str_gsScore
        dd str_gsShots
        dd str_gsOneTimers
        dd str_gsPowerPlay
        dd str_gsPPMinutes
        dd str_gsPPShots
        dd str_gsPenalties
        dd str_gsFaceoffsWon
        dd str_gsOffFaceoffs
        dd str_gsBodyChecks
        dd str_gsAttackZone
        dd str_gsPassing
boxfillcolor:                                   ; DrawBevelBox fill; used by CreatePlayoffs, DrawBevelBox,
                                                ; DrawButton ...
        db 02Ah,00h,00h,00h
boxlitecolor:                                   ; DrawBevelBox top/left; used by CreatePlayoffs, DrawBevelBox,
                                                ; DrawButton ...
        db 03Fh,00h,00h,00h
boxshadecolor:                                  ; DrawBevelBox bottom/right; used by CreatePlayoffs,
                                                ; DrawBevelBox, DrawButton ...
        db 017h,00h,00h,00h
dlgtextfg:                                      ; string '?'; used by CreatePlayoffs, DrawListItem,
                                                ; DrawTeamGridName ...
        db 03Fh,00h,00h,00h
dlgtextbg:                                      ; string ''; used by CreatePlayoffs, DrawListItem,
                                                ; DrawTeamGridName ...
        db 00h,00h,00h,00h
EditRostersState:                               ; Cleared before the roster editor runs from the central
                                                ; registry; used by MenuCentralRegistry
        db 00h,00h,00h,00h
dlgsavebuf:                                     ; DBOX screen save; used by MergeLeagueFiles, RestoreDialogBg,
                                                ; SaveDialogBg
        db 00h,00h,00h,00h
listscroll:                                     ; ListDialog scroll bar (30h-byte struct); used by ListDialog
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
desksongalt:                                    ; alternates the desk song between maindesk and tonights; used
                                                ; by MainDeskLoop
        db 01h
keepdesksong:                                   ; set by easn_stats so returning to the desk keeps the song
                                                ; playing; used by EasnGoalieStatsScreen_m,
                                                ; EasnSkaterStatsScreen_m, EasnStandingsMenu_m ...
        db 00h,00h,00h,00h
songdata:                                       ; pointer to the loaded song (0 = none); freed and cleared
                                                ; after a fade in arena_logos; played with musichandle; used
                                                ; by AwardsCeremony, CalendarScreen, CoachCutScene ...
        db 00h,00h,00h,00h
str_InsufficientDiskSpace:                      ; string 'Insufficient disk space available'
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_ToSaveTheSettings:                          ; string 'to save the settings, you require'
        db 074h,06Fh,020h,073h,061h,076h,065h,020h,074h,068h,065h,020h,073h,065h,074h,074h
        db 069h,06Eh,067h,073h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h,069h,072h
        db 065h,00h
str_1KbytesFree:                                ; string '1 Kbytes of free disk space.'
        db 031h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h,065h,065h
        db 020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h
setdiskmsg:                                     ; 3 MessageBox lines: not enough disk space for game.set; used
                                                ; by WriteModeState
        dd str_InsufficientDiskSpace
        dd str_ToSaveTheSettings
        dd str_1KbytesFree
        db 00h,00h
scrpitch:                                       ; planar VGA bytes per row (50h): every vga* routine
                                                ; multiplies y by it; used by FreeGameMemory, LoadGameGfx,
                                                ; MainDeskLoop ...
        db 050h,00h,00h,00h,00h,00h,00h,00h
rinkarenas:                                     ; 12-byte arena entries: abbrev[4] ("BOS"), map x, y, second
                                                ; map x, y (FFFFh none); used by LoadRink
        db 042h,04Fh
        db 053h,00h
        db 015h,00h
        db 026h,00h
        db 0FFh,0FFh,0FFh,0FFh,042h,055h,046h,00h,016h,00h,024h,00h,0FFh,0FFh,0FFh,0FFh
        db 043h,047h,059h,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,043h,048h,049h,00h
        db 016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,044h,045h,054h,00h,015h,00h,025h,00h
        db 0FFh,0FFh,0FFh,0FFh,045h,044h,04Dh,00h,016h,00h,02Ch,00h,019h,00h,023h,00h
        db 048h,046h,044h,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,04Ch,041h,020h,00h
        db 020h,00h,02Dh,00h,0Fh,00h,022h,00h,04Dh,049h,04Eh,00h,015h,00h,025h,00h
        db 0FFh,0FFh,0FFh,0FFh,04Dh,054h,04Ch,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh
        db 04Eh,04Ah,020h,00h,01Eh,00h,02Dh,00h,011h,00h,022h,00h,04Eh,059h,049h,00h
        db 016h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh,04Eh,059h,052h,00h,016h,00h,024h,00h
        db 0FFh,0FFh,0FFh,0FFh,04Fh,054h,054h,00h,015h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh
        db 050h,048h,049h,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,050h,049h,054h,00h
        db 0Dh,00h,01Fh,00h,022h,00h,030h,00h,051h,055h,045h,00h,016h,00h,024h,00h
        db 0FFh,0FFh,0FFh,0FFh,053h,054h,04Ch,00h,015h,00h,024h,00h,0FFh,0FFh,0FFh,0FFh
        db 053h,04Ah,020h,00h,015h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh,054h,042h,020h,00h
        db 016h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh,054h,04Fh,052h,00h,016h,00h,026h,00h
        db 0FFh,0FFh,0FFh,0FFh,056h,041h,04Eh,00h,015h,00h,024h,00h,0FFh,0FFh,0FFh,0FFh
        db 057h,053h,048h,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,057h,050h,047h,00h
        db 015h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh,041h,04Eh,048h,00h,015h,00h,025h,00h
        db 0FFh,0FFh,0FFh,0FFh,046h,04Ch,04Fh,00h,015h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh
rinktilebm:                                     ; rink bitmap built by LoadRink; used by BlitTileMap,
                                                ; FreeRinkGfx, LoadRink
        db 00h,00h,00h,00h
rinkbm:                                         ; used by EnsureFreeMemory, FreeRinkGfx, LoadRink ...
        db 00h,00h,00h,00h
rinkfileidx:                                    ; used by LoadRink
        db 02Ch,00h,00h,00h,035h,00h,00h,00h,048h,00h,00h,00h,04Ah,00h,00h,00h
        db 05Dh,00h,00h,00h,06Eh,00h,00h,00h,09Eh,00h,00h,00h,0DDh,00h,00h,00h
        db 0EBh,00h,00h,00h,0FDh,00h,00h,00h,05h,01h,00h,00h,0Eh,01h,00h,00h
        db 010h,01h,00h,00h,012h,01h,00h,00h,01Fh,01h,00h,00h,02Dh,01h,00h,00h
        db 057h,01h,00h,00h,092h,01h,00h,00h,086h,01h,00h,00h,097h,01h,00h,00h
        db 0A3h,01h,00h,00h,0B1h,01h,00h,00h,0BFh,01h,00h,00h,0BCh,01h,00h,00h
        db 025h,00h,00h,00h,093h,00h,00h,00h
currink:                                        ; rink loaded in rinktilebm (-1 none); used by FreeRinkGfx,
                                                ; LoadRink
        db 0FFh,0FFh,0FFh,0FFh
rinkscrollx:                                    ; last SetRinkScroll x (negated; +3E8h forces a redraw); used
                                                ; by Gameloop, HandleHotKey, InstantReplay ...
        db 00h,00h,00h,00h
rinkscrolly:                                    ; last SetRinkScroll y; used by Gameloop, HandleHotKey,
                                                ; InstantReplay ...
        db 00h,00h,00h,00h
str_Yes:                                        ; "Yes" string literal
        db 059h,065h,073h,00h
str_No4:                                        ; "No" string literal
        db 04Eh,06Fh,00h
str_DoYouWishToUse:                             ; string 'Do you wish to use your'
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,075h
        db 073h,065h,020h,079h,06Fh,075h,072h,00h
str_CurrentDbOr:                                ; string 'Current database or the'
        db 043h,075h,072h,072h,065h,06Eh,074h,020h,064h,061h,074h,061h,062h,061h,073h,065h
        db 020h,06Fh,072h,020h,074h,068h,065h,00h
str_OriginalNHLDb:                              ; string 'Original NHL database?'
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,04Eh,048h,04Ch,020h,064h,061h,074h
        db 061h,062h,061h,073h,065h,03Fh,00h
str_Current:                                    ; string 'Current'
        db 043h,075h,072h,072h,065h,06Eh,074h,00h
str_Original:                                   ; string 'Original'
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,00h
dbchoicelines:                                  ; 3 prompt lines; used by AskDatabaseChoice
        dd str_DoYouWishToUse
        dd str_CurrentDbOr
        dd str_OriginalNHLDb
dbchoicebtns:                                   ; 2 buttons (Current / Original); used by AskDatabaseChoice
        db 010h,00h,00h,00h,050h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Current
        db 0F0h,0FFh,0FFh,0FFh,050h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Original
str_AllTheTeamsAre:                             ; "All the teams are already human" string literal
        db 041h,06Ch,06Ch,020h,074h,068h,065h,020h,074h,065h,061h,06Dh,073h,020h,061h,072h
        db 065h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,068h,075h,06Dh,061h,06Eh,00h
