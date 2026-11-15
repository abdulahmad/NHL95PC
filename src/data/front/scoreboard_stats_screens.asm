; The credits, the disk-space warnings, and the titles for each statistics source.
bits 32
%include "hockey.inc"
section s_C5679 progbits alloc noexec write align=1
extern exhfiles, pofiles, lgfiles, StatsSel9394Season, StatsSel9394Playoffs, StatsSelLeague, StatsSelLeaguePlayoffs, StatsSelPlayoffMode
extern NullBlit, CmpPoints, CmpGAA, CmpTeamStandings, CmpTeamScoring, CmpTeamDefense, CmpTeamPP, CmpTeamPK
extern CmpTeamPenalties, CmpGoals, CmpAssists, CmpPPGoals, CmpSHGoals, CmpPlusMinus, CmpPIM, CmpShootPct
extern CmpGoalieWins, CmpSavePct, sub_B4CD8, sub_B4E50, sub_B500C, sub_B52B4, sub_B5584, sub_B56B8
extern sub_B5974, sub_B5AC8, str_3000, str_3001, str_3002, str_3003, str_3004, str_3005
extern str_3006, str_3007, str_3008, str_3009, str_300, str_OT2, str_BOS, str_BUF3
extern str_CGY, str_CHI, str_DET, str_EDM, str_HFD, str_LA, str_DAL, str_MTL
extern str_NJ, str_NYI, str_NYR, str_OTT, str_PHI, str_PIT, str_QUE, str_STL
extern str_SJ, str_TB, str_TOR, str_VAN, str_WSH, str_WPG, str_ANA3, str_FLA
extern str_ASW, str_ASE, unk_C07A4, str_Credit19, str_Credit10, str_Credit09, str_Credit17, str_Credit01
extern str_Credit15, str_Credit12, str_Credit08, str_Credit02, str_Credit11, str_Credit05, str_Credit06, str_Credit07
extern str_Credit18, str_Credit14, str_Credit13, str_Credit16, str_Credit00, str_Credit04, str_Credit03, str_PacificDivision
extern str_CentralDivision, str_NortheastDivision, str_AtlanticDivision, str_Season3, str_Playoff3, str_RegSeason, str_Playoff4, str_Actual
extern str_Accumulated, str_embnhl, str_embscup, str_careerdb, str_seasondb, str_carteamsdb, str_teamsdb, str_Speed
extern str_Agility, str_Weight, str_ShotPower, str_Checking2, str_StickHandling, str_Accuracy, str_Passing2, str_OffensiveAwareness
extern str_DefensiveAwareness, str_Aggressiveness, str_Endurance, str_ShootPassBias, str_Faceoffs, str_GloveLeft, str_GloveRight, str_StickLeft
extern str_StickRight, str_PuckControl, str_Speed2, str_Agility2, str_Weight2, str_OffensiveAwareness2, str_DefensiveAwareness2, str_WesternConference3
extern str_EasternConference3, str_TeamScoring, str_TeamDefense, str_TeamPenaltyKilling, str_TeamPowerPlay, str_TeamPenalties, str_TeamStandings, str_spW
extern str_SpL4, str_SpT, str_GF2, str_GA4, str_TSH, str_PPGA, str_PCT5, unk_C0F89
extern str_ADV, str_PPG3, str_PIM5, str_AVG, str_PTS, str_WINS, str_PointLeaders, str_GoalLeaders
extern str_AssistLeaders, str_PowerPlayGoalLeaders, str_ShorthandedGoalLeaders, str_PlusMinusLeaders, str_PenaltyMinuteLeaders, str_ShootingPercentageLeaders, str_GoalsAgainstAverageLeaders, str_GoaltenderWinLeaders
extern str_SavePercentageLeaders, str_spG, str_spA, str_Pt3, unk_C11D1, str_PP2, str_SHG3, str_PlusMinus5
extern str_PIM6, str_Shots5, str_Pct6, str_MIN5, str_GA5, str_AVG2, str_spW2, str_SpL5
extern str_SpT2, str_SA4, str_PCT7, str_LSSCEDDB, str_SCHEDULEDB3, str_InsufficientDiskSpace3
global CreditsList, msg_NeedKbytes, msg_NeedKbytes2, str_ReturningToSportsCentral, str_ReturningOutOfThe, str_ReturningToThePlayoff, str_ExitingTheGame, str_DoYouWishToReturn
global str_DoYouWishToExit, str_9394Season, str_9394PlayOffs, str_LgSeasonTitle, str_LgPlayoffsTitle, str_POTitle
global str_SeasonSfx, str_SeasonPlayOffsSfx, str_PlayOffsSfx, str_AttDb, str_fmt2d, str_fmt3d, str_fmt4d
global str_fmt5d, str_fmtTenths, str_fmtPct, str_fmtPct0, str_fmtMinSec, str_fmtEmb, str_Bkgd2, str_EASNvfn
global str_ExhibitionGameCalled, str_LeagueCalled, str_PlayOffSeriesCalled, str_NoScoring, str_NoPenalties, rinkarenas, byte_C66B4, mi_9394Season
global mi_9394Playoffs, mi_LeagueSeason, mi_LeaguePlayoffs, mi_PlayoffMode, str_Dashes, treecolslots, treecol_Wr2, treecol_Wr3, treecol_Er3
global treecol_Er2, treecol_Er1
global scoutcatidx, desksongalt, awlineenergies, hmlineenergies, hudclockmin, hudclocksec, hudclockhund, panelprevmin
global panelprevsec, panelprevhund, panelhund, deferpending, hmpanellines, awpanellines, hudhomeline, hudawayline
global hmpanelpens, awpanelpens, hmlinetimer, awlinetimer, demomatchups_m1, demomatchups, demoteammode, nhlintrosaid
global textgrid, textgridon, textcolor, textshadow, textoutlinedx, textoutlinedy, easnfontbuf, embscupbank
global statscategory, statsteamsel, statsredrawcb, deskexit, teamstatscb, skaterstatscb, goaliestatscb, standingscb
global standingsmenucb, hlplayedmask, msg_DeskExit, msg_DeskExit_e02, dword_C66B0, screenbm, dirtyrectcount, dword_C66D0
global dword_C66D4, lastsprremap, dword_C679D, dword_C67B9, dword_C67BD, statsplayoffs, statsfromleague, statspalvalid
global westconfteams, eastconfteams, dword_C6D26, potreeseeds, dword_C6E20, treerowy, divx, divy
global fdlgshapes, fdlgrects
global boxfillcolor, boxlitecolor, boxshadecolor, dlgtextfg, dlgtextbg
global dword_C71E0, dlgsavebuf, listscroll
global keepdesksong, songdata, rinktilebm
global rinkbm, rinkfileidx, currink, rinkscrollx, rinkscrolly, msg_GameDiskSpace, perioddigits, hudotname
global crestnames, creditpages, msg_FileExists, msg_StatsDiskSpace, menutext_statsleague, menuact_statsleague, menutext_statslgplayoffs, menuact_statslgplayoffs
global menutext_statsplayoff, menuact_statsplayoff, divisionnames, statslabels, statsbgnames, statsplayerdbs, statsteamdbs
global skaterratingnames, skatercardattrs_m3, goalieratingnames, goaliecardattrs_m3, teamsortfns, westconfname, eastconfname, teamstattitles
global teamcolhdrs, leadersortfns, leadertitles, leadercolhdrs, leadercolhdrs_c1
global leadercolhdrs_c2, leadercolhdrs_c3, leadercolhdrs_c4, off_C6D22, scoutcatnames, fdlgfilelists, fdlgfilelists_e01, fdlgfilelists_e02
global gamestatlabels, setdiskmsg, dbchoicelines, str_OfFreeDiskSpace, unk_C588E, str_OfficiallyLicensed, str_ProductOfThe, str_NationalHockeyLeague
global str_NationalHockeyLeagueNHL, str_TheLogoOfThe, str_TrademarksOfTheNational, str_LeagueAndAreUsed, unk_C5969, unk_C5996, str_TrademarkOfTheNational, str_LeagueAndIsUsed
global str_ByElectronicArtsInc, str_TeamNamesAndLogos, str_AreOfficiallyLicensed, str_OfTheNationalHockey, unk_C5A6C, unk_C5A78, str_OfficiallyLicensedProductOf, str_NationalHockeyLeaguePlayers
global str_Association, str_NHLPANationalHockeyLeague, str_PlayersAssociationAndThe, str_OfTheNHLPAAre, str_TheNHLPAAndAre, str_LicenseByElectronicArts, unk_C5B93, str_EASportsTheEA
global str_IfItSIn, str_AreTrademarksOfElectronic, unk_C5C33, str_ThisHasBeenA, str_ThePIONEERPRODUCTIONSGroup, str_ElectronicArtsCanada, unk_C5CA1, str_OriginalGameConcept
global str_JimSimmons, str_ScottOrr, str_RichardHilleman, unk_C5CF4, str_OriginalPCVersionGame, str_DaveWarfield, str_RichardHilleman2, unk_C5D51
global str_LanceWall, str_LeadProgrammer, unk_C5D85, str_VictoriaWong, str_Programmer, unk_C5DB3, str_RobertPenner, str_Programmer2
global unk_C5DE1, str_KurtKennett, str_Programmer3, unk_C5E0E, str_GerardDeSouza, str_Artist, unk_C5E39, str_PhilChow
global str_Artist2, unk_C5E5F, str_KentMaclagan, str_Artist3DAnimations, unk_C5E99, str_MichaelJSokyrka, str_Composer, unk_C5ECA
global str_AlanStewart, str_AudioProgrammer, unk_C5EFD, str_IainMacanulty, str_AudioProgrammer2, unk_C5F32, str_SerenaMcCabe, str_AdministrativeAssistant
global unk_C5F6E, str_RodHigo, str_LeadTester, unk_C5F98, str_RichardRadarMul, str_AssistantProducer, unk_C5FD4, str_FosterHall
global str_DirectorOfDevelopment, unk_C600D, str_KenSayler, str_ProducerDesign, unk_C603F, str_HannoLemke, str_Producer, unk_C6069
global str_Testers, str_PaulSmith, str_JohnBrydon, str_TonyLam, str_DavidLee, str_QASupport, str_JonBruce, str_JohnSantamaria
global unk_C60D7, str_RosterVerification, str_DaveWarfield2, str_JohnBrydon2, str_ProductManager, str_ChipLange, str_RatingsByJohnRosasco, str_AndNeilSmithOf
global str_NewYorkRangers, unk_C619A, str_AudioTechnician, str_SteveRoyea, str_AudioProgrammers, str_PaulChernikhowsky, str_JasonLeeSteere, str_AdvancedGravis
global unk_C6232, str_SportsDeskAnnouncer, str_MichaelDonovan, str_RinkAnnouncer, str_BruceJamieson, str_PlayerProfilePhotographs, str_SteveBabineau, unk_C62D3
global str_VideoProvidedBy, str_NHLProductions, str_SpecialThanks, str_ScottJackson, str_CatherineOBrien, str_DougReid, str_MottLinn, unk_C6363
global unk_C638C, str_TheFileYouSpecified, str_DoYouWantTo, str_No3, btn_FileExists, str_TheStatsWereSuccessfully, msg_StatsWritten, str_ERROROutputFileWas
global msg_OutputFileError, str_InsufficientDiskSpaceTo, str_TheDisplayedStatisticsTo, statsleague, str_MayLoseThisGame, unk_C678E, unk_C67B1, photoremap
global str_AwayLines, str_Play, str_Cancel, str_HomeLines, pregamebuttons, str_PenaltyKilling, str_PowerPlay
global str_Shooting, str_Skating, str_Passing, str_Defense2, str_Checking, str_Goaltending, str_Overall, str_ConfirmDeletionOfThe
global delmsgbox, str_gsScore, str_gsShots, str_gsPowerPlay, str_gsPenalties, str_gsFaceoffsWon, str_gsBodyChecks, str_gsAttackZone
global str_gsPassing, str_gsOneTimers, str_gsPPMinutes, str_gsPPShots, str_gsOffFaceoffs, str_InsufficientDiskSpace, str_ToSaveTheSettings, str_1KbytesFree
global str_Yes, str_No4, str_DoYouWishToUse, str_CurrentDbOr, str_OriginalNHLDb, str_Current, str_Original, dbchoicebtns
global str_AllTheTeamsAre, hudpenhome, hmpanelpen_time, hmpanelpen_w4, hmpanelpen_w6, hudpenaway, awpanelpen_time, awpanelpen_w4
global awpanelpen_w6, potreeround, treecolx, scrpitch
msg_NeedKbytes:
        db 070h,06Ch,061h,079h,020h,074h,068h,065h,020h,067h,061h,06Dh,065h,02Ch,020h,079h
        db 06Fh,075h,020h,072h,065h,071h,075h,069h,072h,065h,020h,058h,058h,020h,04Bh,062h
        db 079h,074h,065h,073h,020h,020h,020h,00h
str_OfFreeDiskSpace:
        db 06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h
        db 063h,065h,02Eh,00h
msg_GameDiskSpace:
        dd str_InsufficientDiskSpace3
        dd msg_NeedKbytes
        dd str_OfFreeDiskSpace
        db 00h,00h,00h
awlineenergies:
        db 0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h
        db 0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h
hmlineenergies:
        db 0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h
        db 0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h,0A0h,0Fh,00h,00h
hudclockmin:
        db 05h,00h,00h,00h
hudclocksec:
        db 00h,00h,00h,00h
hudclockhund:
        db 00h,00h,00h,00h
panelprevmin:
        db 063h,00h,00h,00h
panelprevsec:
        db 063h,00h,00h,00h
panelprevhund:
        db 063h,00h,00h,00h
hudpenhome:
        db 0FFh,0FFh
hmpanelpen_time:
        db 00h,00h
hmpanelpen_w4:
        db 00h,00h
hmpanelpen_w6:
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h
hudpenaway:
        db 0FFh,0FFh
awpanelpen_time:
        db 00h,00h
awpanelpen_w4:
        db 00h,00h
awpanelpen_w6:
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,00h,00h
        db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h
perioddigits:
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
hudotname:
        dd str_OT2
crestnames:
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
panelhund:
        db 00h,00h,00h,00h
deferpending:
        db 00h,00h,00h,00h
hmpanellines:
        db 00h,00h,00h,00h
awpanellines:
        db 00h,00h,00h,00h
hudhomeline:
        db 00h,00h,00h,00h
hudawayline:
        db 00h,00h,00h,00h
hmpanelpens:
        db 00h,00h,00h,00h
awpanelpens:
        db 00h,00h,00h,00h
hmlinetimer:
        db 00h,00h,00h,00h
awlinetimer:
        db 00h
demomatchups_m1:
        db 00h
demomatchups:
        db 00h,00h,08h,011h,04h,012h,02h,015h,014h,03h,0Fh,016h,0Ch,015h,0Ch,0Bh
        db 00h,09h,0Ah,01h,08h,015h,014h,012h,0Ch,015h,0Ch,016h,0Ah,00h,0Ch,0Ah
        db 014h,015h,0Ch,015h
demoteammode:
        db 02h,00h,00h,00h
nhlintrosaid:
        db 01h,00h,00h,00h
unk_C588E:
        db 00h
str_OfficiallyLicensed:
        db 04Fh,066h,066h,069h,063h,069h,061h,06Ch,06Ch,079h,020h,04Ch,069h,063h,065h,06Eh
        db 073h,065h,064h,00h
str_ProductOfThe:
        db 050h,072h,06Fh,064h,075h,063h,074h,020h,06Fh,066h,020h,074h,068h,065h,00h
str_NationalHockeyLeague:
        db 04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h,079h,020h
        db 04Ch,065h,061h,067h,075h,065h,02Eh,00h
str_NationalHockeyLeagueNHL:
        db 04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h,079h,020h
        db 04Ch,065h,061h,067h,075h,065h,02Ch,020h,04Eh,048h,04Ch,020h,061h,06Eh,064h,00h
str_TheLogoOfThe:
        db 074h,068h,065h,020h,06Ch,06Fh,067h,06Fh,020h,06Fh,066h,020h,074h,068h,065h,020h
        db 04Eh,048h,04Ch,020h,061h,072h,065h,020h,072h,065h,067h,069h,073h,074h,065h,072h
        db 065h,064h,00h
str_TrademarksOfTheNational:
        db 074h,072h,061h,064h,065h,06Dh,061h,072h,06Bh,073h,020h,06Fh,066h,020h,074h,068h
        db 065h,020h,04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h
        db 079h,00h
str_LeagueAndAreUsed:
        db 04Ch,065h,061h,067h,075h,065h,020h,061h,06Eh,064h,020h,061h,072h,065h,020h,075h
        db 073h,065h,064h,020h,075h,06Eh,064h,065h,072h,020h,06Ch,069h,063h,065h,06Eh,073h
        db 065h,00h
CreditsList:
        db 062h,079h,020h,045h,06Ch,065h,063h,074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h
        db 074h,073h,020h,049h,06Eh,063h,02Eh,00h
unk_C5969:
        db 09h,0DCh,00h,00h,00h
        dd unk_C07A4
        dd str_OfficiallyLicensed
        dd str_ProductOfThe
        dd str_NationalHockeyLeague
        dd unk_C588E
        dd str_NationalHockeyLeagueNHL
        dd str_TheLogoOfThe
        dd str_TrademarksOfTheNational
        dd str_LeagueAndAreUsed
        dd CreditsList
unk_C5996:
        db 053h,074h,061h,06Eh,06Ch,065h,079h,020h,043h,075h,070h,0A8h,020h,069h,073h,020h
        db 061h,020h,072h,065h,067h,069h,073h,074h,065h,072h,065h,064h,00h
str_TrademarkOfTheNational:
        db 054h,072h,061h,064h,065h,06Dh,061h,072h,06Bh,020h,06Fh,066h,020h,074h,068h,065h
        db 020h,04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h,079h
        db 00h
str_LeagueAndIsUsed:
        db 04Ch,065h,061h,067h,075h,065h,020h,061h,06Eh,064h,020h,069h,073h,020h,075h,073h
        db 065h,064h,020h,075h,06Eh,064h,065h,072h,020h,06Ch,069h,063h,065h,06Eh,063h,065h
        db 00h
str_ByElectronicArtsInc:
        db 062h,079h,020h,045h,06Ch,065h,063h,074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h
        db 074h,073h,020h,049h,06Eh,063h,02Eh,00h
str_TeamNamesAndLogos:
        db 054h,065h,061h,06Dh,020h,04Eh,061h,06Dh,065h,073h,020h,061h,06Eh,064h,020h,06Ch
        db 06Fh,067h,06Fh,073h,020h,064h,065h,070h,069h,063h,074h,065h,064h,00h
str_AreOfficiallyLicensed:
        db 061h,072h,065h,020h,04Fh,066h,066h,069h,063h,069h,061h,06Ch,06Ch,079h,020h,04Ch
        db 069h,063h,065h,06Eh,073h,065h,064h,020h,054h,072h,061h,064h,065h,06Dh,061h,072h
        db 06Bh,073h,00h
str_OfTheNationalHockey:
        db 06Fh,066h,020h,074h,068h,065h,020h,04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h
        db 048h,06Fh,063h,06Bh,065h,079h,020h,04Ch,065h,061h,067h,075h,065h,00h
unk_C5A6C:
        db 0A9h,020h,04Eh,048h,04Ch,020h,031h,039h,039h,034h,02Eh,00h
unk_C5A78:
        db 09h,0DCh,00h,00h,00h
        dd str_Credit19
        dd unk_C5996
        dd str_TrademarkOfTheNational
        dd str_LeagueAndIsUsed
        dd str_ByElectronicArtsInc
        dd unk_C588E
        dd str_TeamNamesAndLogos
        dd str_AreOfficiallyLicensed
        dd str_OfTheNationalHockey
        dd unk_C5A6C
str_OfficiallyLicensedProductOf:
        db 04Fh,066h,066h,069h,063h,069h,061h,06Ch,06Ch,079h,020h,04Ch,069h,063h,065h,06Eh
        db 073h,065h,064h,020h,050h,072h,06Fh,064h,075h,063h,074h,020h,06Fh,066h,020h,074h
        db 068h,065h,00h
str_NationalHockeyLeaguePlayers:
        db 04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h,048h,06Fh,063h,06Bh,065h,079h,020h
        db 04Ch,065h,061h,067h,075h,065h,020h,050h,06Ch,061h,079h,065h,072h,073h,027h,00h
str_Association:
        db 041h,073h,073h,06Fh,063h,069h,061h,074h,069h,06Fh,06Eh,02Eh,00h
str_NHLPANationalHockeyLeague:
        db 04Eh,048h,04Ch,050h,041h,02Ch,020h,04Eh,061h,074h,069h,06Fh,06Eh,061h,06Ch,020h
        db 048h,06Fh,063h,06Bh,065h,079h,020h,04Ch,065h,061h,067h,075h,065h,00h
str_PlayersAssociationAndThe:
        db 050h,06Ch,061h,079h,065h,072h,073h,027h,020h,041h,073h,073h,06Fh,063h,069h,061h
        db 074h,069h,06Fh,06Eh,020h,061h,06Eh,064h,020h,074h,068h,065h,020h,06Ch,06Fh,067h
        db 06Fh,00h
str_OfTheNHLPAAre:
        db 06Fh,066h,020h,074h,068h,065h,020h,04Eh,048h,04Ch,050h,041h,020h,061h,072h,065h
        db 020h,054h,072h,061h,064h,065h,06Dh,061h,072h,06Bh,073h,020h,06Fh,066h,00h
str_TheNHLPAAndAre:
        db 074h,068h,065h,020h,04Eh,048h,04Ch,050h,041h,020h,061h,06Eh,064h,020h,061h,072h
        db 065h,020h,075h,073h,065h,064h,02Ch,020h,075h,06Eh,064h,065h,072h,00h
str_LicenseByElectronicArts:
        db 06Ch,069h,063h,065h,06Eh,073h,065h,02Ch,020h,062h,079h,020h,045h,06Ch,065h,063h
        db 074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h,074h,073h,020h,049h,06Eh,063h,02Eh
        db 00h
unk_C5B93:
        db 09h,0FAh,00h,00h,00h
        dd str_Credit10
        dd str_OfficiallyLicensedProductOf
        dd str_NationalHockeyLeaguePlayers
        dd str_Association
        dd unk_C588E
        dd str_NHLPANationalHockeyLeague
        dd str_PlayersAssociationAndThe
        dd str_OfTheNHLPAAre
        dd str_TheNHLPAAndAre
        dd str_LicenseByElectronicArts
str_EASportsTheEA:
        db 045h,041h,020h,053h,070h,06Fh,072h,074h,073h,02Ch,020h,074h,068h,065h,020h,045h
        db 041h,020h,053h,070h,06Fh,072h,074h,073h,020h,04Ch,06Fh,067h,06Fh,02Ch,020h,061h
        db 06Eh,064h,00h
str_IfItSIn:
        db 022h,049h,066h,020h,069h,074h,027h,073h,020h,069h,06Eh,020h,074h,068h,065h,020h
        db 067h,061h,06Dh,065h,02Ch,020h,069h,074h,027h,073h,020h,069h,06Eh,020h,074h,068h
        db 065h,020h,067h,061h,06Dh,065h,022h,00h
str_AreTrademarksOfElectronic:
        db 061h,072h,065h,020h,074h,072h,061h,064h,065h,06Dh,061h,072h,06Bh,073h,020h,06Fh
        db 066h,020h,045h,06Ch,065h,063h,074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h,074h
        db 073h,02Ch,020h,049h,06Eh,063h,02Eh,00h
unk_C5C33:
        db 03h,078h,00h,00h,00h
        dd str_Credit09
        dd str_EASportsTheEA
        dd str_IfItSIn
        dd str_AreTrademarksOfElectronic
str_ThisHasBeenA:
        db 054h,068h,069h,073h,020h,068h,061h,073h,020h,062h,065h,065h,06Eh,020h,061h,020h
        db 070h,072h,065h,073h,065h,06Eh,074h,061h,074h,069h,06Fh,06Eh,020h,062h,079h,00h
str_ThePIONEERPRODUCTIONSGroup:
        db 074h,068h,065h,020h,050h,049h,04Fh,04Eh,045h,045h,052h,020h,050h,052h,04Fh,044h
        db 055h,043h,054h,049h,04Fh,04Eh,053h,020h,067h,072h,06Fh,075h,070h,020h,06Fh,066h
        db 00h
str_ElectronicArtsCanada:
        db 045h,06Ch,065h,063h,074h,072h,06Fh,06Eh,069h,063h,020h,041h,072h,074h,073h,020h
        db 043h,061h,06Eh,061h,064h,061h,02Eh,00h
unk_C5CA1:
        db 03h,078h,00h,00h,00h
        dd str_Credit17
        dd str_ThisHasBeenA
        dd str_ThePIONEERPRODUCTIONSGroup
        dd str_ElectronicArtsCanada
str_OriginalGameConcept:
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,047h,061h,06Dh,065h,020h,043h,06Fh
        db 06Eh,063h,065h,070h,074h,03Ah,00h
str_JimSimmons:
        db 04Ah,069h,06Dh,020h,053h,069h,06Dh,06Dh,06Fh,06Eh,073h,00h
str_ScottOrr:
        db 053h,063h,06Fh,074h,074h,020h,04Fh,072h,072h,00h
str_RichardHilleman:
        db 052h,069h,063h,068h,061h,072h,064h,020h,048h,069h,06Ch,06Ch,065h,06Dh,061h,06Eh
        db 00h
unk_C5CF4:
        db 05h,078h,00h,00h,00h
        dd unk_C07A4
        dd str_OriginalGameConcept
        dd unk_C588E
        dd str_JimSimmons
        dd str_ScottOrr
        dd str_RichardHilleman
str_OriginalPCVersionGame:
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,050h,043h,020h,056h,065h,072h,073h
        db 069h,06Fh,06Eh,020h,047h,061h,06Dh,065h,020h,044h,065h,073h,069h,067h,06Eh,03Ah
        db 00h
str_DaveWarfield:
        db 044h,061h,076h,065h,020h,057h,061h,072h,066h,069h,065h,06Ch,064h,00h
str_RichardHilleman2:
        db 052h,069h,063h,068h,061h,072h,064h,020h,048h,069h,06Ch,06Ch,065h,06Dh,061h,06Eh
        db 00h
unk_C5D51:
        db 04h,078h,00h,00h,00h
        dd unk_C07A4
        dd str_OriginalPCVersionGame
        dd unk_C588E
        dd str_DaveWarfield
        dd str_RichardHilleman2
str_LanceWall:
        db 04Ch,061h,06Eh,063h,065h,020h,057h,061h,06Ch,06Ch,00h
str_LeadProgrammer:
        db 04Ch,065h,061h,064h,020h,050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h,00h
unk_C5D85:
        db 03h,078h,00h,00h,00h
        dd str_Credit01
        dd str_LanceWall
        dd unk_C588E
        dd str_LeadProgrammer
str_VictoriaWong:
        db 056h,069h,063h,074h,06Fh,072h,069h,061h,020h,057h,06Fh,06Eh,067h,00h
str_Programmer:
        db 050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h,00h
unk_C5DB3:
        db 03h,078h,00h,00h,00h
        dd str_Credit15
        dd str_VictoriaWong
        dd unk_C588E
        dd str_Programmer
str_RobertPenner:
        db 052h,06Fh,062h,065h,072h,074h,020h,050h,065h,06Eh,06Eh,065h,072h,00h
str_Programmer2:
        db 050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h,00h
unk_C5DE1:
        db 03h,078h,00h,00h,00h
        dd str_Credit12
        dd str_RobertPenner
        dd unk_C588E
        dd str_Programmer2
str_KurtKennett:
        db 04Bh,075h,072h,074h,020h,04Bh,065h,06Eh,06Eh,065h,074h,074h,00h
str_Programmer3:
        db 050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h,00h
unk_C5E0E:
        db 03h,078h,00h,00h,00h
        dd str_Credit08
        dd str_KurtKennett
        dd unk_C588E
        dd str_Programmer3
str_GerardDeSouza:
        db 047h,065h,072h,061h,072h,064h,020h,044h,065h,053h,06Fh,075h,07Ah,061h,00h
str_Artist:
        db 041h,072h,074h,069h,073h,074h,00h
unk_C5E39:
        db 03h,078h,00h,00h,00h
        dd str_Credit02
        dd str_GerardDeSouza
        dd unk_C588E
        dd str_Artist
str_PhilChow:
        db 050h,068h,069h,06Ch,020h,043h,068h,06Fh,077h,00h
str_Artist2:
        db 041h,072h,074h,069h,073h,074h,00h
unk_C5E5F:
        db 03h,078h,00h,00h,00h
        dd str_Credit11
        dd str_PhilChow
        dd unk_C588E
        dd str_Artist2
str_KentMaclagan:
        db 04Bh,065h,06Eh,074h,020h,04Dh,061h,063h,06Ch,061h,067h,061h,06Eh,00h
str_Artist3DAnimations:
        db 041h,072h,074h,069h,073h,074h,020h,02Fh,020h,033h,044h,020h,041h,06Eh,069h,06Dh
        db 061h,074h,069h,06Fh,06Eh,073h,00h
unk_C5E99:
        db 03h,078h,00h,00h,00h
        dd str_Credit05
        dd str_KentMaclagan
        dd unk_C588E
        dd str_Artist3DAnimations
str_MichaelJSokyrka:
        db 04Dh,069h,063h,068h,061h,065h,06Ch,020h,04Ah,02Eh,020h,053h,06Fh,06Bh,079h,072h
        db 06Bh,061h,00h
str_Composer:
        db 043h,06Fh,06Dh,070h,06Fh,073h,065h,072h,00h
unk_C5ECA:
        db 03h,078h,00h,00h,00h
        dd str_Credit06
        dd str_MichaelJSokyrka
        dd unk_C588E
        dd str_Composer
str_AlanStewart:
        db 041h,06Ch,061h,06Eh,020h,053h,074h,065h,077h,061h,072h,074h,00h
str_AudioProgrammer:
        db 041h,075h,064h,069h,06Fh,020h,050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h
        db 00h
unk_C5EFD:
        db 03h,078h,00h,00h,00h
        dd str_Credit07
        dd str_AlanStewart
        dd unk_C588E
        dd str_AudioProgrammer
str_IainMacanulty:
        db 049h,061h,069h,06Eh,020h,04Dh,061h,063h,061h,06Eh,075h,06Ch,074h,079h,00h
str_AudioProgrammer2:
        db 041h,075h,064h,069h,06Fh,020h,050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h
        db 00h
unk_C5F32:
        db 03h,078h,00h,00h,00h
        dd str_Credit18
        dd str_IainMacanulty
        dd unk_C588E
        dd str_AudioProgrammer2
str_SerenaMcCabe:
        db 053h,065h,072h,065h,06Eh,061h,020h,04Dh,063h,043h,061h,062h,065h,00h
str_AdministrativeAssistant:
        db 041h,064h,06Dh,069h,06Eh,069h,073h,074h,072h,061h,074h,069h,076h,065h,020h,041h
        db 073h,073h,069h,073h,074h,061h,06Eh,074h,00h
unk_C5F6E:
        db 03h,078h,00h,00h,00h
        dd str_Credit14
        dd str_SerenaMcCabe
        dd unk_C588E
        dd str_AdministrativeAssistant
str_RodHigo:
        db 052h,06Fh,064h,020h,048h,069h,067h,06Fh,00h
str_LeadTester:
        db 04Ch,065h,061h,064h,020h,054h,065h,073h,074h,065h,072h,00h
unk_C5F98:
        db 03h,078h,00h,00h,00h
        dd str_Credit13
        dd str_RodHigo
        dd unk_C588E
        dd str_LeadTester
str_RichardRadarMul:
        db 052h,069h,063h,068h,061h,072h,064h,020h,028h,052h,061h,064h,061h,072h,029h,020h
        db 04Dh,075h,06Ch,00h
str_AssistantProducer:
        db 041h,073h,073h,069h,073h,074h,061h,06Eh,074h,020h,050h,072h,06Fh,064h,075h,063h
        db 065h,072h,00h
unk_C5FD4:
        db 03h,078h,00h,00h,00h
        dd str_Credit16
        dd str_RichardRadarMul
        dd unk_C588E
        dd str_AssistantProducer
str_FosterHall:
        db 046h,06Fh,073h,074h,065h,072h,020h,048h,061h,06Ch,06Ch,00h
str_DirectorOfDevelopment:
        db 044h,069h,072h,065h,063h,074h,06Fh,072h,020h,06Fh,066h,020h,044h,065h,076h,065h
        db 06Ch,06Fh,070h,06Dh,065h,06Eh,074h,00h
unk_C600D:
        db 03h,078h,00h,00h,00h
        dd str_Credit00
        dd str_FosterHall
        dd unk_C588E
        dd str_DirectorOfDevelopment
str_KenSayler:
        db 04Bh,065h,06Eh,020h,053h,061h,079h,06Ch,065h,072h,00h
str_ProducerDesign:
        db 050h,072h,06Fh,064h,075h,063h,065h,072h,020h,026h,020h,044h,065h,073h,069h,067h
        db 06Eh,00h
unk_C603F:
        db 03h,078h,00h,00h,00h
        dd str_Credit04
        dd str_KenSayler
        dd unk_C588E
        dd str_ProducerDesign
str_HannoLemke:
        db 048h,061h,06Eh,06Eh,06Fh,020h,04Ch,065h,06Dh,06Bh,065h,00h
str_Producer:
        db 050h,072h,06Fh,064h,075h,063h,065h,072h,00h
unk_C6069:
        db 03h,078h,00h,00h,00h
        dd str_Credit03
        dd str_HannoLemke
        dd unk_C588E
        dd str_Producer
str_Testers:
        db 054h,065h,073h,074h,065h,072h,073h,03Ah,00h
str_PaulSmith:
        db 050h,061h,075h,06Ch,020h,053h,06Dh,069h,074h,068h,00h
str_JohnBrydon:
        db 04Ah,06Fh,068h,06Eh,020h,042h,072h,079h,064h,06Fh,06Eh,00h
str_TonyLam:
        db 054h,06Fh,06Eh,079h,020h,04Ch,061h,06Dh,00h
str_DavidLee:
        db 044h,061h,076h,069h,064h,020h,04Ch,065h,065h,00h
str_QASupport:
        db 051h,041h,020h,053h,075h,070h,070h,06Fh,072h,074h,03Ah,00h
str_JonBruce:
        db 04Ah,06Fh,06Eh,020h,042h,072h,075h,063h,065h,00h
str_JohnSantamaria:
        db 04Ah,06Fh,068h,06Eh,020h,053h,061h,06Eh,074h,061h,06Dh,061h,072h,069h,061h,00h
unk_C60D7:
        db 0Ch,0B4h,00h,00h,00h
        dd str_Credit17
        dd str_Testers
        dd unk_C588E
        dd str_PaulSmith
        dd str_JohnBrydon
        dd str_TonyLam
        dd str_DavidLee
        dd unk_C588E
        dd unk_C588E
        dd str_QASupport
        dd unk_C588E
        dd str_JonBruce
        dd str_JohnSantamaria
str_RosterVerification:
        db 052h,06Fh,073h,074h,065h,072h,020h,056h,065h,072h,069h,066h,069h,063h,061h,074h
        db 069h,06Fh,06Eh,03Ah,00h
str_DaveWarfield2:
        db 044h,061h,076h,065h,020h,057h,061h,072h,066h,069h,065h,06Ch,064h,00h
str_JohnBrydon2:
        db 04Ah,06Fh,068h,06Eh,020h,042h,072h,079h,064h,06Fh,06Eh,00h
str_ProductManager:
        db 050h,072h,06Fh,064h,075h,063h,074h,020h,04Dh,061h,06Eh,061h,067h,065h,072h,03Ah
        db 00h
str_ChipLange:
        db 043h,068h,069h,070h,020h,04Ch,061h,06Eh,067h,065h,00h
str_RatingsByJohnRosasco:
        db 052h,061h,074h,069h,06Eh,067h,073h,020h,062h,079h,020h,04Ah,06Fh,068h,06Eh,020h
        db 052h,06Fh,073h,061h,073h,063h,06Fh,00h
str_AndNeilSmithOf:
        db 061h,06Eh,064h,020h,04Eh,065h,069h,06Ch,020h,053h,06Dh,069h,074h,068h,020h,06Fh
        db 066h,020h,074h,068h,065h,00h
str_NewYorkRangers:
        db 04Eh,065h,077h,020h,059h,06Fh,072h,06Bh,020h,052h,061h,06Eh,067h,065h,072h,073h
        db 00h
unk_C619A:
        db 0Ah,0B4h,00h,00h,00h
        dd unk_C07A4
        dd str_RosterVerification
        dd str_DaveWarfield2
        dd str_JohnBrydon2
        dd unk_C588E
        dd str_ProductManager
        dd str_ChipLange
        dd unk_C588E
        dd str_RatingsByJohnRosasco
        dd str_AndNeilSmithOf
        dd str_NewYorkRangers
str_AudioTechnician:
        db 041h,075h,064h,069h,06Fh,020h,054h,065h,063h,068h,06Eh,069h,063h,069h,061h,06Eh
        db 03Ah,00h
str_SteveRoyea:
        db 053h,074h,065h,076h,065h,020h,052h,06Fh,079h,065h,061h,00h
str_AudioProgrammers:
        db 041h,075h,064h,069h,06Fh,020h,050h,072h,06Fh,067h,072h,061h,06Dh,06Dh,065h,072h
        db 073h,03Ah,00h
str_PaulChernikhowsky:
        db 050h,061h,075h,06Ch,020h,043h,068h,065h,072h,06Eh,069h,06Bh,068h,06Fh,077h,073h
        db 06Bh,079h,00h
str_JasonLeeSteere:
        db 04Ah,061h,073h,06Fh,06Eh,020h,04Ch,065h,065h,02Dh,053h,074h,065h,065h,072h,065h
        db 00h
str_AdvancedGravis:
        db 028h,041h,064h,076h,061h,06Eh,063h,065h,064h,020h,047h,072h,061h,076h,069h,073h
        db 029h,00h
unk_C6232:
        db 0Ah,0B4h,00h,00h,00h
        dd unk_C07A4
        dd str_AudioTechnician
        dd str_SteveRoyea
        dd unk_C588E
        dd unk_C588E
        dd str_AudioProgrammers
        dd unk_C588E
        dd str_PaulChernikhowsky
        dd unk_C588E
        dd str_JasonLeeSteere
        dd str_AdvancedGravis
str_SportsDeskAnnouncer:
        db 053h,070h,06Fh,072h,074h,073h,044h,065h,073h,06Bh,020h,041h,06Eh,06Eh,06Fh,075h
        db 06Eh,063h,065h,072h,03Ah,00h
str_MichaelDonovan:
        db 04Dh,069h,063h,068h,061h,065h,06Ch,020h,044h,06Fh,06Eh,06Fh,076h,061h,06Eh,00h
str_RinkAnnouncer:
        db 052h,069h,06Eh,06Bh,020h,041h,06Eh,06Eh,06Fh,075h,06Eh,063h,065h,072h,03Ah,00h
str_BruceJamieson:
        db 042h,072h,075h,063h,065h,020h,04Ah,061h,06Dh,069h,065h,073h,06Fh,06Eh,00h
str_PlayerProfilePhotographs:
        db 050h,06Ch,061h,079h,065h,072h,020h,050h,072h,06Fh,066h,069h,06Ch,065h,020h,050h
        db 068h,06Fh,074h,06Fh,067h,072h,061h,070h,068h,073h,03Ah,00h
str_SteveBabineau:
        db 053h,074h,065h,076h,065h,020h,042h,061h,062h,069h,06Eh,065h,061h,075h,00h
unk_C62D3:
        db 08h,0B4h,00h,00h,00h
        dd str_Credit17
        dd str_SportsDeskAnnouncer
        dd str_MichaelDonovan
        dd unk_C588E
        dd str_RinkAnnouncer
        dd str_BruceJamieson
        dd unk_C588E
        dd str_PlayerProfilePhotographs
        dd str_SteveBabineau
str_VideoProvidedBy:
        db 056h,069h,064h,065h,06Fh,020h,050h,072h,06Fh,076h,069h,064h,065h,064h,020h,042h
        db 079h,03Ah,00h
str_NHLProductions:
        db 04Eh,048h,04Ch,020h,050h,072h,06Fh,064h,075h,063h,074h,069h,06Fh,06Eh,073h,00h
str_SpecialThanks:
        db 053h,070h,065h,063h,069h,061h,06Ch,020h,054h,068h,061h,06Eh,06Bh,073h,03Ah,00h
str_ScottJackson:
        db 053h,063h,06Fh,074h,074h,020h,04Ah,061h,063h,06Bh,073h,06Fh,06Eh,00h
str_CatherineOBrien:
        db 043h,061h,074h,068h,065h,072h,069h,06Eh,065h,020h,04Fh,027h,042h,072h,069h,065h
        db 06Eh,00h
str_DougReid:
        db 044h,06Fh,075h,067h,020h,052h,065h,069h,064h,00h
str_MottLinn:
        db 04Dh,06Fh,074h,074h,020h,04Ch,069h,06Eh,06Eh,00h
unk_C6363:
        db 08h,0B4h,00h,00h,00h
        dd str_Credit17
        dd str_VideoProvidedBy
        dd str_NHLProductions
        dd unk_C588E
        dd str_SpecialThanks
        dd str_ScottJackson
        dd str_CatherineOBrien
        dd str_DougReid
        dd str_MottLinn
unk_C638C:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
creditpages:
        dd unk_C5969
        dd unk_C5B93
        dd unk_C5A78
        dd unk_C5C33
        dd unk_C5CA1
        dd unk_C5CF4
        dd unk_C5D51
        dd unk_C5D85
        dd unk_C5DB3
        dd unk_C5DE1
        dd unk_C5E0E
        dd unk_C5E39
        dd unk_C5E5F
        dd unk_C5E99
        dd unk_C5ECA
        dd unk_C5EFD
        dd unk_C5F32
        dd unk_C5F6E
        dd unk_C5FD4
        dd unk_C600D
        dd unk_C603F
        dd unk_C6069
        dd unk_C5F98
        dd unk_C60D7
        dd unk_C619A
        dd unk_C6232
        dd unk_C62D3
        dd unk_C6363
        dd unk_C638C
        db 00h,00h,00h
textgrid:
        db 00h,00h,00h,00h
textgridon:
        db 00h,00h,00h,00h
textcolor:
        db 0Fh,00h,00h,00h
textshadow:
        db 00h,00h,00h,00h
textoutlinedx:
        db 0FFh,0FFh,0FFh,0FFh,01h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
textoutlinedy:
        db 00h,00h,00h,00h,00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,01h,00h,00h,00h
str_TheFileYouSpecified:
        db 054h,068h,065h,020h,066h,069h,06Ch,065h,020h,079h,06Fh,075h,020h,073h,070h,065h
        db 063h,069h,066h,069h,065h,064h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,065h
        db 078h,069h,073h,074h,073h,021h,00h
str_DoYouWantTo:
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,06Fh
        db 076h,065h,072h,077h,072h,069h,074h,065h,020h,074h,068h,065h,020h,06Fh,06Ch,064h
        db 020h,066h,069h,06Ch,065h,03Fh,00h
msg_FileExists:
        dd str_TheFileYouSpecified
        dd str_DoYouWantTo
str_No3:
        db 04Eh,06Fh,00h
btn_FileExists:
        db 010h,00h,00h,00h,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_No3
        db 0F0h,0FFh,0FFh,0FFh,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Yes
str_TheStatsWereSuccessfully:
        db 054h,068h,065h,020h,073h,074h,061h,074h,073h,020h,077h,065h,072h,065h,020h,073h
        db 075h,063h,063h,065h,073h,073h,066h,075h,06Ch,06Ch,079h,020h,077h,072h,069h,074h
        db 074h,065h,06Eh,00h
msg_StatsWritten:
        dd str_TheStatsWereSuccessfully
str_ERROROutputFileWas:
        db 045h,052h,052h,04Fh,052h,020h,03Ah,020h,04Fh,075h,074h,070h,075h,074h,020h,066h
        db 069h,06Ch,065h,020h,077h,061h,073h,020h,06Eh,06Fh,074h,020h,073h,075h,063h,063h
        db 065h,073h,073h,066h,075h,06Ch,06Ch,079h,020h,077h,072h,069h,074h,074h,065h,06Eh
        db 00h
msg_OutputFileError:
        dd str_ERROROutputFileWas
str_InsufficientDiskSpaceTo:
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,020h,070h,072h,069h,06Eh,074h
        db 00h
str_TheDisplayedStatisticsTo:
        db 074h,068h,065h,020h,064h,069h,073h,070h,06Ch,061h,079h,065h,064h,020h,073h,074h
        db 061h,074h,069h,073h,074h,069h,063h,073h,020h,074h,06Fh,02Ch,020h,079h,06Fh,075h
        db 00h
msg_NeedKbytes2:
        db 072h,065h,071h,075h,069h,072h,065h,020h,058h,058h,020h,04Bh,062h,079h,074h,065h
        db 073h,020h,06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h
        db 070h,061h,063h,065h,02Eh,020h,020h,020h,020h,00h
msg_StatsDiskSpace:
        dd str_InsufficientDiskSpaceTo
        dd str_TheDisplayedStatisticsTo
        dd msg_NeedKbytes2
        db 00h,00h
easnfontbuf:
        db 00h,00h,00h,00h
embscupbank:
        db 00h,00h,00h,00h
statscategory:
        db 00h,00h,00h,00h
statsteamsel:
        db 00h,00h,00h,00h
statsredrawcb:
        db 00h,00h,00h,00h
deskexit:
        db 00h,00h,00h,00h
teamstatscb:
        db 00h,00h,00h,00h
skaterstatscb:
        db 00h,00h,00h,00h
goaliestatscb:
        db 00h,00h,00h,00h
standingscb:
        db 00h,00h,00h,00h
standingsmenucb:
        db 00h,00h,00h,00h
statsleague:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
hlplayedmask:
        db 00h,00h,00h,00h
str_ReturningToSportsCentral:
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,074h,06Fh,020h,073h,070h,06Fh
        db 072h,074h,073h,020h,063h,065h,06Eh,074h,072h,061h,06Ch,00h
str_ReturningOutOfThe:
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,06Fh,075h,074h,020h,06Fh,066h
        db 020h,074h,068h,065h,020h,067h,061h,06Dh,065h,00h
str_ReturningToThePlayoff:
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,074h,06Fh,020h,074h,068h,065h
        db 020h,070h,06Ch,061h,079h,06Fh,066h,066h,020h,074h,072h,065h,065h,00h
str_ExitingTheGame:
        db 045h,078h,069h,074h,069h,06Eh,067h,020h,074h,068h,065h,020h,067h,061h,06Dh,065h
        db 00h
str_MayLoseThisGame:
        db 06Dh,061h,079h,020h,06Ch,06Fh,073h,065h,020h,074h,068h,069h,073h,020h,067h,061h
        db 06Dh,065h,027h,073h,020h,064h,061h,074h,061h,02Eh,00h
str_DoYouWishToReturn:
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,072h
        db 065h,074h,075h,072h,06Eh,03Fh,00h
str_DoYouWishToExit:
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,065h
        db 078h,069h,074h,03Fh,00h
msg_DeskExit:
        db 00h,00h,00h,00h
        dd str_MayLoseThisGame
msg_DeskExit_e02:
        db 00h,00h,00h,00h
dword_C66B0:
        db 0Dh,00h,00h,00h
byte_C66B4:
        db 07h,00h,04h,00h,03h,00h,06h,00h,01h,00h,08h,00h,02h,00h,00h,00h
screenbm:
        db 00h,00h,00h,00h
dirtyrectcount:
        db 00h,00h,00h,00h,00h,00h,00h,00h
dword_C66D0:
        db 00h,00h,00h,00h
dword_C66D4:
        db 00h,00h,00h,00h
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd sub_B4CD8
        dd sub_B500C
        dd sub_B4E50
        dd sub_B52B4
        dd sub_B5584
        dd sub_B56B8
        dd sub_B5974
        dd sub_B5AC8
lastsprremap:
        db 0FFh,0FFh,0FFh,0FFh
mi_9394Season:
        db 01h,020h
str_9394Season:
        db 027h,039h,033h,020h,02Dh,020h,027h,039h,034h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 00h
mi_9394Playoffs:
        db 02h,020h
str_9394PlayOffs:
        db 027h,039h,033h,020h,02Dh,020h,027h,039h,034h,020h,050h,06Ch,061h,079h,02Dh,04Fh
        db 066h,066h,073h,00h
mi_LeagueSeason:
        db 02h,020h
str_LgSeasonTitle:
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 00h
mi_LeaguePlayoffs:
        db 02h,020h
str_LgPlayoffsTitle:
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,073h,00h
mi_PlayoffMode:
        db 02h,020h
str_POTitle:
        db 022h
        db 057h,057h,057h,057h,057h,057h,057h,057h,022h,020h,050h,06Ch,061h,079h,02Dh,04Fh
        db 066h,066h,073h,00h
unk_C678E:
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
dword_C679D:
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
str_Dashes:
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,00h
unk_C67B1:
        db 00h,00h,00h,00h,00h,00h,00h,00h
dword_C67B9:
        db 0F7h,00h,00h,00h
dword_C67BD:
        db 011h,00h,00h,00h
        dd mi_9394Season
        dd StatsSel9394Season
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0F7h,00h,00h,00h,023h,00h,00h,00h
        dd mi_9394Playoffs
        dd StatsSel9394Playoffs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 0F7h,00h,00h,00h,035h,00h,00h,00h
        dd unk_C678E
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 036h,00h,00h,00h,0F7h,00h,00h,00h,047h,00h,00h,00h
menutext_statsleague:
        dd mi_LeagueSeason
menuact_statsleague:
        dd StatsSelLeague
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 0F7h,00h,00h,00h,059h,00h,00h,00h
menutext_statslgplayoffs:
        dd mi_LeaguePlayoffs
menuact_statslgplayoffs:
        dd StatsSelLeaguePlayoffs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 0F7h,00h,00h,00h,06Bh,00h,00h,00h
        dd unk_C678E
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 06Ch,00h,00h,00h,0F7h,00h,00h,00h,07Eh,00h,00h,00h
menutext_statsplayoff:
        dd mi_PlayoffMode
menuact_statsplayoff:
        dd StatsSelPlayoffMode
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_SeasonSfx:
        db 022h,020h,053h,065h,061h,073h,06Fh,06Eh,00h
str_SeasonPlayOffsSfx:
        db 022h,020h,053h,065h,061h,073h,06Fh,06Eh,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h
        db 066h,073h,00h
str_PlayOffsSfx:
        db 022h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,073h,00h,00h,00h,00h
divisionnames:
        dd str_PacificDivision
        dd str_CentralDivision
        dd str_NortheastDivision
        dd str_AtlanticDivision
statslabels:
        dd str_Season3
        dd str_Playoff3
        dd str_RegSeason
        dd str_Playoff4
        dd str_Actual
        dd str_Accumulated
statsbgnames:
        dd str_embnhl
        dd str_embscup
statsplayerdbs:
        dd str_careerdb
        dd str_seasondb
statsteamdbs:
        dd str_carteamsdb
        dd str_teamsdb
str_AttDb:
        db 061h,074h,074h,02Eh,064h,062h,00h
str_fmt2d:
        db 025h,032h,064h,00h
str_fmt3d:
        db 025h,033h,064h,00h
str_fmt4d:
        db 025h,034h,064h,00h
str_fmt5d:
        db 025h,035h,064h,00h
str_fmtTenths:
        db 025h,033h,064h,02Eh,025h,031h,064h,00h
str_fmtPct:
        db 025h,031h,064h,02Eh,025h,030h,033h,064h,00h
str_fmtPct0:
        db 020h,02Eh,025h,030h,033h,064h,00h
str_fmtMinSec:
        db 025h,032h,064h,02Eh,025h,032h,02Eh,032h,064h,00h
str_fmtEmb:
        db 065h,06Dh,062h,025h,073h,00h
str_Bkgd2:
        db 062h,06Bh,067h,064h,00h
str_EASNvfn:
        db 045h,041h,053h,04Eh,02Eh,076h,066h,06Eh,00h,077h,069h,074h,074h,06Ch,065h,030h
        db 036h,02Eh,076h,066h,06Eh,00h
statsplayoffs:
        db 00h,00h,00h,00h
statsfromleague:
        db 00h,00h,00h,00h,00h,00h
photoremap:
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
statspalvalid:
        db 00h,00h,00h,00h
skaterratingnames:
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
goalieratingnames:
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
teamsortfns:
        dd CmpTeamScoring
        dd CmpTeamDefense
        dd CmpTeamPK
        dd CmpTeamPP
        dd CmpTeamPenalties
        dd CmpTeamStandings
westconfteams:
        db 04h,00h,00h,00h,02h,00h,00h,00h,014h,00h,00h,00h,08h,00h,00h,00h
        db 011h,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,012h,00h,00h,00h
        db 018h,00h,00h,00h,07h,00h,00h,00h,05h,00h,00h,00h,017h,00h,00h,00h
        db 063h,00h,00h,00h,063h,00h,00h,00h
eastconfteams:
        db 0Ch,00h,00h,00h,0Fh,00h,00h,00h,0Ah,00h,00h,00h,00h,00h,00h,00h
        db 09h,00h,00h,00h,01h,00h,00h,00h,016h,00h,00h,00h,0Bh,00h,00h,00h
        db 019h,00h,00h,00h,0Eh,00h,00h,00h,010h,00h,00h,00h,013h,00h,00h,00h
        db 06h,00h,00h,00h,0Dh,00h,00h,00h
westconfname:
        dd str_WesternConference3
eastconfname:
        dd str_EasternConference3
teamstattitles:
        dd str_TeamScoring
        dd str_TeamDefense
        dd str_TeamPenaltyKilling
        dd str_TeamPowerPlay
        dd str_TeamPenalties
        dd str_TeamStandings
teamcolhdrs:
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
        dd unk_C0F89
        dd str_ADV
        dd str_PPG3
        dd str_PCT5
        dd unk_C0F89
        dd str_PIM5
        dd str_AVG
        dd unk_C0F89
        dd unk_C0F89
        dd str_PTS
        dd str_WINS
        dd unk_C0F89
        dd unk_C0F89
leadersortfns:
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
leadertitles:
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
leadercolhdrs:
        dd str_spG
leadercolhdrs_c1:
        dd str_spA
leadercolhdrs_c2:
        dd str_Pt3
leadercolhdrs_c3:
        dd unk_C11D1
leadercolhdrs_c4:
        dd unk_C11D1
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd unk_C11D1
        dd unk_C11D1
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd unk_C11D1
        dd unk_C11D1
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PP2
        dd unk_C11D1
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_SHG3
        dd unk_C11D1
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PlusMinus5
        dd unk_C11D1
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PIM6
        dd unk_C11D1
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_Shots5
        dd str_Pct6
        dd str_MIN5
        dd str_GA5
        dd str_AVG2
        dd unk_C11D1
        dd unk_C11D1
        dd str_MIN5
        dd str_spW2
        dd str_SpL5
        dd str_SpT2
        dd unk_C11D1
        dd str_MIN5
        dd str_GA5
        dd str_SA4
        dd str_PCT7
        dd unk_C11D1
        dd str_LSSCEDDB
off_C6D22 equ $+2
        dd str_SCHEDULEDB3
potreeround:
        db 070h,0FFh
dword_C6D26:
        db 00h,00h,00h,00h,00h,02h,04h,06h,08h,0Ah,0Ch,0Eh,01h,05h,09h,0Dh
        db 0FFh,0FFh,0FFh,0FFh,03h,0Bh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07h,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,07h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,07h,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,03h,0Bh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,01h,05h,09h,0Dh
        db 0FFh,0FFh,0FFh,0FFh,00h,02h,04h,06h,08h,0Ah,0Ch,0Eh
treecolslots:
        db 00h
        db 01h,02h,03h,04h,05h,06h,07h
treecol_Wr2:
        db 010h
        db 011h
        db 012h
        db 013h,0FFh,0FFh,0FFh,0FFh
treecol_Wr3:
        db 018h
        db 019h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 01Ch,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 01Eh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 01Dh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
treecol_Er3:
        db 01Ah
        db 01Bh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
treecol_Er2:
        db 014h
        db 015h
        db 016h
        db 017h,0FFh,0FFh,0FFh,0FFh
treecol_Er1:
        db 08h
        db 09h,0Ah,0Bh,0Ch,0Dh,0Eh,0Fh
potreeseeds:
        db 01h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h,04h,00h,00h,00h
        db 05h,00h,00h,00h,06h,00h,00h,00h,07h,00h,00h,00h,08h,00h,00h,00h
        db 09h,00h,00h,00h,0Ah,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h
        db 0Dh,00h,00h,00h,0Eh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h
        db 011h,00h,00h,00h,012h,00h,00h,00h,013h,00h,00h,00h,014h,00h,00h,00h
        db 015h,00h,00h,00h,016h,00h,00h,00h,017h,00h,00h,00h,018h,00h,00h,00h
        db 019h,00h,00h,00h,01Ah,00h
dword_C6E20:
        db 00h,00h
treecolx:
        db 014h,00h,00h,00h,0B7h,00h,00h,00h,05Ch,01h,00h,00h,0FEh,01h,00h,00h
treerowy:
        db 030h,00h,00h,00h,0DCh,00h,00h,00h
divx:
        db 0Ah,00h,00h,00h,0Ah,00h,00h,00h,04Ah,01h,00h,00h,04Ah,01h,00h,00h
divy:
        db 07Dh,00h,00h,00h,022h,01h,00h,00h,07Dh,00h,00h,00h,022h,01h,00h,00h
        db 00h,00h
str_AwayLines:
        db 041h,077h,061h,079h,020h,06Ch,069h,06Eh,065h,073h,00h
str_Play:
        db 050h,06Ch,061h,079h,00h
str_Cancel:
        db 043h,061h,06Eh,063h,065h,06Ch,00h
str_HomeLines:
        db 048h,06Fh,06Dh,065h,020h,06Ch,069h,06Eh,065h,073h,00h
pregamebuttons:
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
str_PenaltyKilling:
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h,06Ch,06Ch,069h,06Eh,067h,00h
str_PowerPlay:
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,00h
str_Shooting:
        db 053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,00h
str_Skating:
        db 053h,06Bh,061h,074h,069h,06Eh,067h,00h
str_Passing:
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_Defense2:
        db 044h,065h,066h,065h,06Eh,073h,065h,00h
str_Checking:
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_Goaltending:
        db 047h,06Fh,061h,06Ch,074h,065h,06Eh,064h,069h,06Eh,067h,00h
str_Overall:
        db 04Fh,076h,065h,072h,020h,061h,06Ch,06Ch,00h
scoutcatnames:
        dd str_PenaltyKilling
        dd str_PowerPlay
        dd str_Shooting
        dd str_Skating
        dd str_Passing
        dd str_Defense2
        dd str_Checking
        dd str_Goaltending
        dd str_Overall
scoutcatidx:
        db 00h,01h,04h,05h,06h,07h,08h,0Ah,0Bh,00h,00h,00h
fdlgshapes:
        db 00h,00h,00h,00h
fdlgfilelists:
        dd lgfiles
fdlgfilelists_e01:
        dd pofiles
fdlgfilelists_e02:
        dd exhfiles
fdlgrects:
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
str_ConfirmDeletionOfThe:
        db 043h,06Fh,06Eh,066h,069h,072h,06Dh,020h,044h,065h,06Ch,065h,074h,069h,06Fh,06Eh
        db 020h,06Fh,066h,020h,074h,068h,065h,00h
str_ExhibitionGameCalled:
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,020h,047h,061h,06Dh,065h,020h
        db 043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
str_LeagueCalled:
        db 04Ch,065h,061h,067h,075h,065h,020h,043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
str_PlayOffSeriesCalled:
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,053h,065h,072h,069h,065h,073h,020h
        db 043h,061h,06Ch,06Ch,065h,064h,03Ah,00h
delmsgbox:
        dd str_ConfirmDeletionOfThe
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h
str_NoScoring:
        db 04Eh,06Fh,020h,053h,063h,06Fh,072h,069h,06Eh,067h,02Eh,00h
str_NoPenalties:
        db 04Eh,06Fh,020h,050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,02Eh,00h,00h,00h
str_gsScore:
        db 053h,063h,06Fh,072h,065h,00h
str_gsShots:
        db 053h,068h,06Fh,074h,073h,00h
str_gsPowerPlay:
        db 050h,06Fh,077h,065h,072h,020h,070h,06Ch,061h,079h,00h
str_gsPenalties:
        db 050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,00h
str_gsFaceoffsWon:
        db 046h,061h,063h,065h,06Fh,066h,066h,073h,020h,077h,06Fh,06Eh,00h
str_gsBodyChecks:
        db 042h,06Fh,064h,079h,020h,063h,068h,065h,063h,06Bh,073h,00h
str_gsAttackZone:
        db 041h,074h,074h,061h,063h,06Bh,020h,07Ah,06Fh,06Eh,065h,00h
str_gsPassing:
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_gsOneTimers:
        db 04Fh,06Eh,065h,020h,054h,069h,06Dh,065h,072h,073h,00h
str_gsPPMinutes:
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,04Dh,069h,06Eh,075h,074h
        db 065h,073h,00h
str_gsPPShots:
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,053h,068h,06Fh,074h,073h
        db 00h
str_gsOffFaceoffs:
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,046h,061h,063h,065h,06Fh,066h
        db 066h,073h,020h,077h,06Fh,06Eh,00h
gamestatlabels:
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
boxfillcolor:
        db 02Ah,00h,00h,00h
boxlitecolor:
        db 03Fh,00h,00h,00h
boxshadecolor:
        db 017h,00h,00h,00h
dlgtextfg:
        db 03Fh,00h,00h,00h
dlgtextbg:
        db 00h,00h,00h,00h
dword_C71E0:
        db 00h,00h,00h,00h
dlgsavebuf:
        db 00h,00h,00h,00h
listscroll:
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
desksongalt:
        db 01h
keepdesksong:
        db 00h,00h,00h,00h
songdata:
        db 00h,00h,00h,00h
str_InsufficientDiskSpace:
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_ToSaveTheSettings:
        db 074h,06Fh,020h,073h,061h,076h,065h,020h,074h,068h,065h,020h,073h,065h,074h,074h
        db 069h,06Eh,067h,073h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h,069h,072h
        db 065h,00h
str_1KbytesFree:
        db 031h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h,065h,065h
        db 020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h
setdiskmsg:
        dd str_InsufficientDiskSpace
        dd str_ToSaveTheSettings
        dd str_1KbytesFree
        db 00h,00h
scrpitch:
        db 050h,00h,00h,00h,00h,00h,00h,00h
rinkarenas:
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
rinktilebm:
        db 00h,00h,00h,00h
rinkbm:
        db 00h,00h,00h,00h
rinkfileidx:
        db 02Ch,00h,00h,00h,035h,00h,00h,00h,048h,00h,00h,00h,04Ah,00h,00h,00h
        db 05Dh,00h,00h,00h,06Eh,00h,00h,00h,09Eh,00h,00h,00h,0DDh,00h,00h,00h
        db 0EBh,00h,00h,00h,0FDh,00h,00h,00h,05h,01h,00h,00h,0Eh,01h,00h,00h
        db 010h,01h,00h,00h,012h,01h,00h,00h,01Fh,01h,00h,00h,02Dh,01h,00h,00h
        db 057h,01h,00h,00h,092h,01h,00h,00h,086h,01h,00h,00h,097h,01h,00h,00h
        db 0A3h,01h,00h,00h,0B1h,01h,00h,00h,0BFh,01h,00h,00h,0BCh,01h,00h,00h
        db 025h,00h,00h,00h,093h,00h,00h,00h
currink:
        db 0FFh,0FFh,0FFh,0FFh
rinkscrollx:
        db 00h,00h,00h,00h
rinkscrolly:
        db 00h,00h,00h,00h
str_Yes:
        db 059h,065h,073h,00h
str_No4:
        db 04Eh,06Fh,00h
str_DoYouWishToUse:
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,075h
        db 073h,065h,020h,079h,06Fh,075h,072h,00h
str_CurrentDbOr:
        db 043h,075h,072h,072h,065h,06Eh,074h,020h,064h,061h,074h,061h,062h,061h,073h,065h
        db 020h,06Fh,072h,020h,074h,068h,065h,00h
str_OriginalNHLDb:
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,04Eh,048h,04Ch,020h,064h,061h,074h
        db 061h,062h,061h,073h,065h,03Fh,00h
str_Current:
        db 043h,075h,072h,072h,065h,06Eh,074h,00h
str_Original:
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,00h
dbchoicelines:
        dd str_DoYouWishToUse
        dd str_CurrentDbOr
        dd str_OriginalNHLDb
dbchoicebtns:
        db 010h,00h,00h,00h,050h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Current
        db 0F0h,0FFh,0FFh,0FFh,050h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Original
str_AllTheTeamsAre:
        db 041h,06Ch,06Ch,020h,074h,068h,065h,020h,074h,065h,061h,06Dh,073h,020h,061h,072h
        db 065h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,068h,075h,06Dh,061h,06Eh,00h
