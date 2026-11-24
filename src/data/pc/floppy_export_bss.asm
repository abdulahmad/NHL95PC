; BSS of pc/floppy_export (src/pc/floppy_export).
bits 32
%include "hockey.inc"
section s_DD7A4 nobits alloc noexec write align=1
global criterrflag, leaguemaster, leaguesaved, leagueflags, leagueteams, lgteamflags
criterrflag:                                    ; set by CritErrHandler; used by CritErrHandler,
                                                ; FindLeagueFloppy, SelectFloppyDrive
        resb 4
leaguemaster:                                   ; PINFO +2: team index CheckMasterPassword passes to
                                                ; AskMasterPassword; used by AddHumanTeam,
                                                ; CheckMasterPassword, ChooseLeagueController ...
        resb 4
leaguesaved:                                    ; PINFO +4: non-zero gives 'There is a saved game in the
                                                ; league'; SaveLeagueGameRef writes -1; used by AddHumanTeam,
                                                ; CheckMasterPassword, ChooseLeagueController ...
        resb 4
leagueflags:                                    ; PINFO +13h: bit 2 set skips the 'Master databases for'
                                                ; prompt; used by AddHumanTeam, CheckMasterPassword,
                                                ; ChooseLeagueController ...
        resb 4
leagueteams:                                    ; PINFO +20h: 1Ah team entries of 1Eh bytes (name, +16h copied
                                                ; flag, +17h human, +18h on disk); used by AddHumanTeam,
                                                ; CheckMasterPassword, CreateNewLeague ...
        resb 22
lgteamflags:                                    ; leagueteams entry (1Eh) +16h flags: 1 human, 2 checked by
                                                ; merge/import, 4 merged; used by CreateNewLeague, ExportDbs,
                                                ; ImportPlayerTeam ...
        resb 1
