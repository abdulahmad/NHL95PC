; The messages that the database already exists, and that there is not enough disk space.
bits 32
%include "hockey.inc"
section s_CFA4B progbits alloc noexec write align=1
extern MenuSaveDbs, MenuSaveDbsAs, EditRostersReturn, SelectRosterTeam, MenuOpenDatabase, EasnStandingsMenu, str_Standings2, str_TeamsSortedBy2
extern str_PlayersSortedBy2, str_GoaliesSortedBy2, TeamStatsSortMenu, SkaterStatsSortMenu, GoalieStatsSortMenu
global str_XXXKbytesOfFree2, playoffstatsmenu_srccnt, dbexistsmsg, nodiskspacemsg, str_ThereIsAlreadyA2, str_DoYouWantTo5, str_InsufficientDiskSpace2, str_ToSaveTheDatabases
global str_Anaheim, str_Calgary, str_Edmonton, str_LosAngeles, str_SanJose, str_Vancouver, RosterPacificMenu, str_Chicago
global str_Dallas, str_Detroit, str_StLouis, str_Toronto, str_Winnipeg, RosterCentralMenu, str_Boston, str_Buffalo
global str_Hartford, str_Montreal, str_Ottawa, str_Pittsburgh, str_Quebec, RosterNortheastMenu, str_Florida, str_NewJersey
global str_NYIslanders, str_NYRangers, str_Philadelphia, str_TampaBay, str_Washington, RosterAtlanticMenu, str_SaveToGame, str_TemporarySave
global str_LoadDatabase, str_Return2, EditRostersFileMenu, str_FreeAgents2, str_FindPlayer, str_Pacific, str_Central, str_Northeast
global str_Atlantic, Roster1TeamMenu
playoffstatsmenu_srccnt:
        db 02h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,08Ch,00h,00h,00h
        db 023h,00h,00h,00h
        dd str_Standings2
        dd EasnStandingsMenu
        db 00h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 08Ch,00h,00h,00h,035h,00h,00h,00h
        dd str_TeamsSortedBy2
        db 00h,00h,00h,00h
        dd TeamStatsSortMenu
        db 06h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,08Ch,00h,00h,00h
        db 047h,00h,00h,00h
        dd str_PlayersSortedBy2
        db 00h,00h,00h,00h
        dd SkaterStatsSortMenu
        db 08h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,08Ch,00h,00h,00h
        db 05Ah,00h,00h,00h
        dd str_GoaliesSortedBy2
        db 00h,00h,00h,00h
        dd GoalieStatsSortMenu
        db 03h,00h,00h,00h,00h,02Eh,074h,078h,074h,00h
str_ThereIsAlreadyA2:
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
        db 020h,061h,020h,064h,061h,074h,061h,062h,061h,073h,065h,020h,077h,069h,074h,068h
        db 020h,074h,068h,061h,074h,020h,06Eh,061h,06Dh,065h,021h,00h
str_DoYouWantTo5:
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,072h
        db 065h,070h,06Ch,061h,063h,065h,020h,069h,074h,03Fh,00h
dbexistsmsg:
        dd str_ThereIsAlreadyA2
        dd str_DoYouWantTo5
str_InsufficientDiskSpace2:
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_ToSaveTheDatabases:
        db 074h,06Fh,020h,073h,061h,076h,065h,020h,074h,068h,065h,020h,064h,061h,074h,061h
        db 062h,061h,073h,065h,073h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h,069h
        db 072h,065h,00h
str_XXXKbytesOfFree2:
        db 058h,058h,058h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h
        db 065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,020h,020h
        db 00h
nodiskspacemsg:
        dd str_InsufficientDiskSpace2
        dd str_ToSaveTheDatabases
        dd str_XXXKbytesOfFree2
        db 00h,00h
str_Anaheim:
        db 041h,06Eh,061h,068h,065h,069h,06Dh,020h,02Eh,02Eh,02Eh,00h
str_Calgary:
        db 043h,061h,06Ch,067h,061h,072h,079h,020h,02Eh,02Eh,02Eh,00h
str_Edmonton:
        db 045h,064h,06Dh,06Fh,06Eh,074h,06Fh,06Eh,020h,02Eh,02Eh,02Eh,00h
str_LosAngeles:
        db 04Ch,06Fh,073h,020h,041h,06Eh,067h,065h,06Ch,065h,073h,020h,02Eh,02Eh,02Eh,00h
str_SanJose:
        db 053h,061h,06Eh,020h,04Ah,06Fh,073h,065h,020h,02Eh,02Eh,02Eh,00h
str_Vancouver:
        db 056h,061h,06Eh,063h,06Fh,075h,076h,065h,072h,020h,02Eh,02Eh,02Eh,00h
RosterPacificMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,066h,00h,00h,00h,011h,00h,00h,00h
        dd str_Anaheim
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 066h,00h,00h,00h,023h,00h,00h,00h
        dd str_Calgary
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 066h,00h,00h,00h,035h,00h,00h,00h
        dd str_Edmonton
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 066h,00h,00h,00h,047h,00h,00h,00h
        dd str_LosAngeles
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 066h,00h,00h,00h,059h,00h,00h,00h
        dd str_SanJose
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 066h,00h,00h,00h,06Ch,00h,00h,00h
        dd str_Vancouver
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
str_Chicago:
        db 043h,068h,069h,063h,061h,067h,06Fh,020h,02Eh,02Eh,02Eh,00h
str_Dallas:
        db 044h,061h,06Ch,06Ch,061h,073h,020h,02Eh,02Eh,02Eh,00h
str_Detroit:
        db 044h,065h,074h,072h,06Fh,069h,074h,020h,02Eh,02Eh,02Eh,00h
str_StLouis:
        db 053h,074h,02Eh,020h,04Ch,06Fh,075h,069h,073h,020h,02Eh,02Eh,02Eh,00h
str_Toronto:
        db 054h,06Fh,072h,06Fh,06Eh,074h,06Fh,020h,02Eh,02Eh,02Eh,00h
str_Winnipeg:
        db 057h,069h,06Eh,06Eh,069h,070h,065h,067h,020h,02Eh,02Eh,02Eh,00h
RosterCentralMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,053h,00h,00h,00h,011h,00h,00h,00h
        dd str_Chicago
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 053h,00h,00h,00h,023h,00h,00h,00h
        dd str_Dallas
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 053h,00h,00h,00h,035h,00h,00h,00h
        dd str_Detroit
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 053h,00h,00h,00h,047h,00h,00h,00h
        dd str_StLouis
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 053h,00h,00h,00h,059h,00h,00h,00h
        dd str_Toronto
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 053h,00h,00h,00h,06Ch,00h,00h,00h
        dd str_Winnipeg
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_Boston:
        db 042h,06Fh,073h,074h,06Fh,06Eh,020h,02Eh,02Eh,02Eh,00h
str_Buffalo:
        db 042h,075h,066h,066h,061h,06Ch,06Fh,020h,02Eh,02Eh,02Eh,00h
str_Hartford:
        db 048h,061h,072h,074h,066h,06Fh,072h,064h,020h,02Eh,02Eh,02Eh,00h
str_Montreal:
        db 04Dh,06Fh,06Eh,074h,072h,065h,061h,06Ch,020h,02Eh,02Eh,02Eh,00h
str_Ottawa:
        db 04Fh,074h,074h,061h,077h,061h,020h,02Eh,02Eh,02Eh,00h
str_Pittsburgh:
        db 050h,069h,074h,074h,073h,062h,075h,072h,067h,068h,020h,02Eh,02Eh,02Eh,00h
str_Quebec:
        db 051h,075h,065h,062h,065h,063h,020h,02Eh,02Eh,02Eh,00h
RosterNortheastMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,05Ch,00h,00h,00h,011h,00h,00h,00h
        dd str_Boston
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 05Ch,00h,00h,00h,023h,00h,00h,00h
        dd str_Buffalo
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 05Ch,00h,00h,00h,035h,00h,00h,00h
        dd str_Hartford
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 05Ch,00h,00h,00h,047h,00h,00h,00h
        dd str_Montreal
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 05Ch,00h,00h,00h,059h,00h,00h,00h
        dd str_Ottawa
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 05Ch,00h,00h,00h,06Bh,00h,00h,00h
        dd str_Pittsburgh
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06Ch,00h,00h,00h
        db 05Ch,00h,00h,00h,07Eh,00h,00h,00h
        dd str_Quebec
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_Florida:
        db 046h,06Ch,06Fh,072h,069h,064h,061h,020h,02Eh,02Eh,02Eh,00h
str_NewJersey:
        db 04Eh,065h,077h,020h,04Ah,065h,072h,073h,065h,079h,020h,02Eh,02Eh,02Eh,00h
str_NYIslanders:
        db 04Eh,059h,020h,049h,073h,06Ch,061h,06Eh,064h,065h,072h,073h,020h,02Eh,02Eh,02Eh
        db 00h
str_NYRangers:
        db 04Eh,059h,020h,052h,061h,06Eh,067h,065h,072h,073h,020h,02Eh,02Eh,02Eh,00h
str_Philadelphia:
        db 050h,068h,069h,06Ch,061h,064h,065h,06Ch,070h,068h,069h,061h,020h,02Eh,02Eh,02Eh
        db 00h
str_TampaBay:
        db 054h,061h,06Dh,070h,061h,020h,042h,061h,079h,020h,02Eh,02Eh,02Eh,00h
str_Washington:
        db 057h,061h,073h,068h,069h,06Eh,067h,074h,06Fh,06Eh,020h,02Eh,02Eh,02Eh,00h
RosterAtlanticMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,06Ch,00h,00h,00h,011h,00h,00h,00h
        dd str_Florida
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 06Ch,00h,00h,00h,023h,00h,00h,00h
        dd str_NewJersey
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 06Ch,00h,00h,00h,035h,00h,00h,00h
        dd str_NYIslanders
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 06Ch,00h,00h,00h,047h,00h,00h,00h
        dd str_NYRangers
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 048h,00h,00h,00h,06Ch,00h,00h,00h,059h,00h,00h,00h
        dd str_Philadelphia
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 06Ch,00h,00h,00h,06Bh,00h,00h,00h
        dd str_TampaBay
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06Ch,00h,00h,00h
        db 06Ch,00h,00h,00h,07Eh,00h,00h,00h
        dd str_Washington
        dd SelectRosterTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_SaveToGame:
        db 053h,061h,076h,065h,020h,074h,06Fh,020h,047h,061h,06Dh,065h,020h,02Eh,02Eh,02Eh
        db 00h
str_TemporarySave:
        db 054h,065h,06Dh,070h,06Fh,072h,061h,072h,079h,020h,053h,061h,076h,065h,020h,02Eh
        db 02Eh,02Eh,00h
str_LoadDatabase:
        db 04Ch,06Fh,061h,064h,020h,044h,061h,074h,061h,062h,061h,073h,065h,020h,02Eh,02Eh
        db 02Eh,00h
str_Return2:
        db 052h,065h,074h,075h,072h,06Eh,00h
EditRostersFileMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,080h,00h,00h,00h,011h,00h,00h,00h
        dd str_SaveToGame
        dd MenuSaveDbs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 080h,00h,00h,00h,023h,00h,00h,00h
        dd str_TemporarySave
        dd MenuSaveDbsAs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 080h,00h,00h,00h,035h,00h,00h,00h
        dd str_LoadDatabase
        dd MenuOpenDatabase
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 080h,00h,00h,00h,048h,00h,00h,00h
        dd str_Return2
        dd EditRostersReturn
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_FreeAgents2:
        db 046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,073h,020h,02Eh,02Eh,02Eh,00h
str_FindPlayer:
        db 046h,069h,06Eh,064h,020h,050h,06Ch,061h,079h,065h,072h,020h,02Eh,02Eh,02Eh,00h
str_Pacific:
        db 050h,061h,063h,069h,066h,069h,063h,020h,03h,00h
str_Central:
        db 043h,065h,06Eh,074h,072h,061h,06Ch,020h,03h,00h
str_Northeast:
        db 04Eh,06Fh,072h,074h,068h,065h,061h,073h,074h,020h,03h,00h
str_Atlantic:
        db 041h,074h,06Ch,061h,06Eh,074h,069h,063h,020h,03h,00h
Roster1TeamMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,066h,00h,00h,00h,011h,00h,00h,00h
        dd str_Pacific
        db 00h,00h,00h,00h
