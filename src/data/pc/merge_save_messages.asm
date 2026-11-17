; File extensions, and the messages for a saved game and for the first team.
bits 32
%include "hockey.inc"
section s_C7F07 progbits alloc noexec write align=1
extern str_Yes, str_No4, str_MasterDatabasesFor2, str_MustBeCompletelyMerged, str_PlayersDatabasesMustBe, str_DoYouWishTo
global str_PINFO, str_PLAYER, str_LSSCHED, str_GAME4, str_extDB, str_ORG, str_HI2, str_SET2
global str_PPV, str_KMS, str_CFG, str_VFN, str_extBIN, str_extxx, str_Xx, str_extLP
global str_extID, str_space, str_dot, str_floppydrv, msg_MergeNeeded_e01, msg_SavedGame_arg, firstteammsg, pwmismatchmsg
global leaguedbnames, msg_MergeNeeded
global btn_MergeNeeded, str_MergingPlayersToMaster, mergingmsg, str_UpdatingSchedule, updschedmsg, str_PleasePutAFloppy, insertfloppymsg, str_UseFloppyDriveA
global whichdrivemsg, str_FirstTeamSelected, str_PlayMustBeImported, str_PasswordEnteredDifferently, str_SecondTimeTryAgain, str_ThereIsASaved, str_WhichMustBePlayed, msg_SavedGame
global str_KEY2, str_CAREER2, str_ATT2, str_CARTEAMS, str_TEAMS3, str_SEASON4, str_SCHEDULE2, str_star
global str_backslash2, str_S4
msg_MergeNeeded:                                ; PlayLeagueGame message 'Master databases for' ... 'must be
                                                ; completely merged'; used by PlayLeagueGame
        dd str_MasterDatabasesFor2
msg_MergeNeeded_e01:                            ; msg_MergeNeeded[1], patched with the league name; used by
                                                ; PlayLeagueGame
        db 00h,00h,00h,00h
        dd str_MustBeCompletelyMerged
        dd str_PlayersDatabasesMustBe
        dd str_DoYouWishTo
btn_MergeNeeded:                                ; PlayLeagueGame: the two buttons of msg_MergeNeeded; used by
                                                ; PlayLeagueGame
        db 010h,00h,00h,00h,06Ch,00h,00h,00h,050h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Yes
        db 0F0h,0FFh,0FFh,0FFh,06Ch,00h,00h,00h,050h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_No4
str_MergingPlayersToMaster:                     ; "Merging players to master database." string literal
        db 04Dh,065h,072h,067h,069h,06Eh,067h,020h,070h,06Ch,061h,079h,065h,072h,073h,020h
        db 074h,06Fh,020h,06Dh,061h,073h,074h,065h,072h,020h,064h,061h,074h,061h,062h,061h
        db 073h,065h,02Eh,00h
mergingmsg:                                     ; "Merging players to master database."; used by
                                                ; MergeLeagueFiles
        dd str_MergingPlayersToMaster
str_UpdatingSchedule:                           ; "Updating schedule." string literal
        db 055h,070h,064h,061h,074h,069h,06Eh,067h,020h,073h,063h,068h,065h,064h,075h,06Ch
        db 065h,02Eh,00h
updschedmsg:                                    ; "Updating schedule."; used by MergeLeagueFiles,
                                                ; PlayLeagueGame
        dd str_UpdatingSchedule
str_PleasePutAFloppy:                           ; "Please put a floppy disk in any drive." string literal
        db 050h,06Ch,065h,061h,073h,065h,020h,070h,075h,074h,020h,061h,020h,066h,06Ch,06Fh
        db 070h,070h,079h,020h,064h,069h,073h,06Bh,020h,069h,06Eh,020h,061h,06Eh,079h,020h
        db 064h,072h,069h,076h,065h,02Eh,00h
insertfloppymsg:                                ; "Please put a floppy disk in any drive."; used by
                                                ; SelectFloppyDrive
        dd str_PleasePutAFloppy
str_UseFloppyDriveA:                            ; "Use floppy drive A or B?" string literal
        db 055h,073h,065h,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,072h,069h,076h,065h
        db 020h,041h,020h,06Fh,072h,020h,042h,03Fh,00h
whichdrivemsg:                                  ; "Use floppy drive A or B?"; used by SelectFloppyDrive
        dd str_UseFloppyDriveA
str_FirstTeamSelected:                          ; string 'The first team selected to'
        db 054h,068h,065h,020h,066h,069h,072h,073h,074h,020h,074h,065h,061h,06Dh,020h,073h
        db 065h,06Ch,065h,063h,074h,065h,064h,020h,074h,06Fh,00h
str_PlayMustBeImported:                         ; string 'play must be imported!'
        db 070h,06Ch,061h,079h,020h,06Dh,075h,073h,074h,020h,062h,065h,020h,069h,06Dh,070h
        db 06Fh,072h,074h,065h,064h,021h,00h
firstteammsg:                                   ; "The first team selected to play must be imported!"; used by
                                                ; CheckLeagueDiskSync
        dd str_FirstTeamSelected
        dd str_PlayMustBeImported
str_PasswordEnteredDifferently:                 ; string "The password was entered differently"; not
                                                ; referenced by name
        db 054h,068h,065h,020h,070h,061h,073h,073h,077h,06Fh,072h,064h,020h,077h,061h,073h
        db 020h,065h,06Eh,074h,065h,072h,065h,064h,020h,064h,069h,066h,066h,065h,072h,065h
        db 06Eh,074h,06Ch,079h,00h
str_SecondTimeTryAgain:                         ; string 'the second time! Try again.'
        db 074h,068h,065h,020h,073h,065h,063h,06Fh,06Eh,064h,020h,074h,069h,06Dh,065h,021h
        db 020h,054h,072h,079h,020h,061h,067h,061h,069h,06Eh,02Eh,00h
pwmismatchmsg:                                  ; password verify mismatch lines; used by
                                                ; ChooseLeagueController, LeagueTeamSelect
        dd str_PasswordEnteredDifferently
        dd str_SecondTimeTryAgain
str_ThereIsASaved:                              ; "There is a saved game in the league" string literal
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,061h,020h,073h,061h,076h,065h,064h
        db 020h,067h,061h,06Dh,065h,020h,069h,06Eh,020h,074h,068h,065h,020h,06Ch,065h,061h
        db 067h,075h,065h,00h
str_WhichMustBePlayed:                          ; "which must be played first!" string literal
        db 077h,068h,069h,063h,068h,020h,06Dh,075h,073h,074h,020h,062h,065h,020h,070h,06Ch
        db 061h,079h,065h,064h,020h,066h,069h,072h,073h,074h,021h,00h
msg_SavedGame:                                  ; message box line table; used by AddHumanTeam, ExportDbs,
                                                ; ImportPlayerTeam ...
        dd str_ThereIsASaved
msg_SavedGame_arg:                              ; msg_SavedGame fill-in string pointer for the message box;
                                                ; used by AddHumanTeam, ExportDbs, ImportPlayerTeam ...
        db 00h,00h,00h,00h
        dd str_WhichMustBePlayed
str_KEY2:                                       ; "KEY" string literal
        db 04Bh,045h,059h,00h
str_CAREER2:                                    ; "CAREER" string literal
        db 043h,041h,052h,045h,045h,052h,00h
str_ATT2:                                       ; "ATT" string literal
        db 041h,054h,054h,00h
str_CARTEAMS:                                   ; "CARTEAMS" string literal
        db 043h,041h,052h,054h,045h,041h,04Dh,053h,00h
str_TEAMS3:                                     ; "TEAMS" string literal
        db 054h,045h,041h,04Dh,053h,00h
str_SEASON4:                                    ; "SEASON" string literal
        db 053h,045h,041h,053h,04Fh,04Eh,00h
str_SCHEDULE2:                                  ; "SCHEDULE" string literal
        db 053h,043h,048h,045h,044h,055h,04Ch,045h,00h
leaguedbnames:                                  ; 7 league database names KEY, CAREER, ATT, CARTEAMS, TEAMS,
                                                ; SEASON, SCHEDULE; CopyHumanTeamDBs copies all 7; used by
                                                ; AddHumanTeam, AdvancePlayoffs, BuildPlayoffs ...
        dd str_KEY2
        dd str_CAREER2
        dd str_ATT2
        dd str_CARTEAMS
        dd str_TEAMS3
        dd str_SEASON4
        dd str_SCHEDULE2
str_PINFO:                                      ; string 'PINFO'; used by CheckLeagueDiskSync,
                                                ; CopyHumanTeamDBs, CopyLeagueFiles ...
        db 050h,049h,04Eh,046h,04Fh,00h
str_PLAYER:                                     ; string 'PLAYER'; used by CopyHumanTeamDBs, CopyLeagueFiles,
                                                ; ExportTeamToFloppy ...
        db 050h,04Ch,041h,059h,045h,052h,00h
str_LSSCHED:                                    ; string; used by LoadPlayoffModeTree, OpenStatsSchedule
        db 04Ch,053h,053h,043h,048h,045h,044h,00h,050h,047h,053h,00h
str_GAME4:                                      ; string 'GAME'; used by ExportTeamToFloppy, ImportPlayerTeam
        db 047h,041h,04Dh,045h,00h
str_space:                                      ; string ' ' (separator between first and last name); used by
                                                ; BuildFreeAgentList, BuildTeamRosterList, BuildTradeRoster
                                                ; ...
        db 020h,00h
str_star:                                       ; string '*'; used by BuildLeagueList, DeleteDir,
                                                ; SelectHilight
        db 02Ah,00h
str_backslash2:                                 ; string '\\'; used by DeleteDir, DeleteFiles, ExecuteTrade
                                                ; ...
        db 05Ch,00h
str_S4:                                         ; string '%s'; used by ExecuteTrade, MakeTeamDbFmt
        db 025h,073h,00h
str_extDB:                                      ; string '.DB'; used by AddHumanTeam, AskDatabaseChoice,
                                                ; BuildTradeRoster ...
        db 02Eh,044h,042h,00h
str_ORG:                                        ; string '.ORG'; used by AskDatabaseChoice, OpenSelectedDb
        db 02Eh,04Fh,052h,047h,00h,02Eh,04Eh,053h,048h,00h,02Eh,04Dh,056h,049h,00h
str_HI2:                                        ; string '.HI'; used by SelectHilight
        db 02Eh,048h,049h,00h
str_SET2:                                       ; string '.SET'; used by ExportTeamToFloppy, ImportPlayerTeam
        db 02Eh,053h,045h,054h,00h
str_PPV:                                        ; string '.PPV'; used by DrawHudPanel, Gameloop, InstantReplay
                                                ; ...
        db 02Eh,050h,050h,056h,00h,02Eh,056h,053h,048h,00h
str_KMS:                                        ; string '.KMS'; used by ShowCredits, TitleScreen
        db 02Eh,04Bh,04Dh,053h,00h
str_CFG:                                        ; string '.CFG'; used by LoadNhlCfg, SetSoundDevice
        db 02Eh,043h,046h,047h,00h
str_VFN:                                        ; string '.VFN'; used by GameSummaryScreen, LoadGameGfx,
                                                ; ReloadGameGfx ...
        db 02Eh,056h,046h,04Eh,00h
str_extBIN:                                     ; string '.BIN'; used by DrawLineEditorScreen,
                                                ; LoadCrestsPalette, LoadHomePals ...
        db 02Eh,042h,049h,04Eh,00h
str_extxx:                                      ; string '.xx'; used by CopyHumanTeamDBs, CopyLeagueFiles,
                                                ; ExportDbs ...
        db 02Eh,078h,078h,00h
str_Xx:                                         ; string '.xx'; used by MergeLeagueFiles, PlayLeagueGame
        db 02Eh,078h,078h,00h
str_extLP:                                      ; string '.LP'; used by BuildLeagueList, CreateNewLeague
        db 02Eh,04Ch,050h,00h,02Eh,053h,050h,00h
str_dot:                                        ; string '.'; used by AddHumanTeam, BuildFreeAgentList,
                                                ; BuildLeagueList ...
        db 02Eh,00h
str_extID:                                      ; string '.ID'; used by CopyHumanTeamDBs, CopyLeagueFiles,
                                                ; ExportTeamToFloppy ...
        db 02Eh,049h,044h,00h
str_floppydrv:                                  ; string '?:'; used by CheckLeagueDiskSync, CopyHumanTeamDBs,
                                                ; ExportTeamToFloppy ...
        db 03Fh,03Ah,00h
