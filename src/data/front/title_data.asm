; Initialised data of front/title (src/front/title).
bits 32
%include "hockey.inc"
section s_C588A progbits alloc noexec write align=1
extern CreditBlankTitle, str_Credit00, str_Credit01, str_Credit02, str_Credit03, str_Credit04, str_Credit05, str_Credit06
extern str_Credit07, str_Credit08, str_Credit09, str_Credit10, str_Credit11, str_Credit12, str_Credit13, str_Credit14
extern str_Credit15, str_Credit16, str_Credit17, str_Credit18, str_Credit19
global nhlintrosaid, CreditBlankLine, str_OfficiallyLicensed, str_ProductOfThe, str_NationalHockeyLeague, str_NationalHockeyLeagueNHL, str_TheLogoOfThe, str_TrademarksOfTheNational
global str_LeagueAndAreUsed, CreditsList, CreditPageNhlLicense, str_StanleyCupIsA, str_TrademarkOfTheNational, str_LeagueAndIsUsed, str_ByElectronicArtsInc, str_TeamNamesAndLogos
global str_AreOfficiallyLicensed, str_OfTheNationalHockey, str_CopyrightNHL1994, CreditPageStanleyCup, str_OfficiallyLicensedProductOf, str_NationalHockeyLeaguePlayers, str_Association, str_NHLPANationalHockeyLeague
global str_PlayersAssociationAndThe, str_OfTheNHLPAAre, str_TheNHLPAAndAre, str_LicenseByElectronicArts, CreditPageNhlpaLicense, str_EASportsTheEA, str_IfItSIn, str_AreTrademarksOfElectronic
global CreditPageEaSports, str_ThisHasBeenA, str_ThePIONEERPRODUCTIONSGroup, str_ElectronicArtsCanada, CreditPagePresentedBy, str_OriginalGameConcept, str_JimSimmons, str_ScottOrr
global str_RichardHilleman, CreditPageGameConcept, str_OriginalPCVersionGame, str_DaveWarfield, str_RichardHilleman2, CreditPagePcDesign, str_LanceWall, str_LeadProgrammer
global CreditPageLeadProgrammer, str_VictoriaWong, str_Programmer, CreditPageProgrammerWong, str_RobertPenner, str_Programmer2, CreditPageProgrammerPenner, str_KurtKennett
global str_Programmer3, CreditPageProgrammerKennett, str_GerardDeSouza, str_Artist, CreditPageArtistDeSouza, str_PhilChow, str_Artist2, CreditPageArtistChow
global str_KentMaclagan, str_Artist3DAnimations, CreditPageAnimator, str_MichaelJSokyrka, str_Composer, CreditPageComposer, str_AlanStewart, str_AudioProgrammer
global CreditPageAudioStewart, str_IainMacanulty, str_AudioProgrammer2, CreditPageAudioMacanulty, str_SerenaMcCabe, str_AdministrativeAssistant, CreditPageAdminAssistant, str_RodHigo
global str_LeadTester, CreditPageLeadTester, str_RichardRadarMul, str_AssistantProducer, CreditPageAssistantProducer, str_FosterHall, str_DirectorOfDevelopment, CreditPageDevDirector
global str_KenSayler, str_ProducerDesign, CreditPageProducerDesign, str_HannoLemke, str_Producer, CreditPageProducer, str_Testers, str_PaulSmith
global str_JohnBrydon, str_TonyLam, str_DavidLee, str_QASupport, str_JonBruce, str_JohnSantamaria, CreditPageTesters, str_RosterVerification
global str_DaveWarfield2, str_JohnBrydon2, str_ProductManager, str_ChipLange, str_RatingsByJohnRosasco, str_AndNeilSmithOf, str_NewYorkRangers, CreditPageRosters
global str_AudioTechnician, str_SteveRoyea, str_AudioProgrammers, str_PaulChernikhowsky, str_JasonLeeSteere, str_AdvancedGravis, CreditPageAudioTeam, str_SportsDeskAnnouncer
global str_MichaelDonovan, str_RinkAnnouncer, str_BruceJamieson, str_PlayerProfilePhotographs, str_SteveBabineau, CreditPageAnnouncers, str_VideoProvidedBy, str_NHLProductions
global str_SpecialThanks, str_ScottJackson, str_CatherineOBrien, str_DougReid, str_MottLinn, CreditPageSpecialThanks, CreditPageEnd, creditpages
global textgrid, textgridon, textcolor, textshadow, textoutlinedx, textoutlinedy, str_TheFileYouSpecified, str_DoYouWantTo
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
