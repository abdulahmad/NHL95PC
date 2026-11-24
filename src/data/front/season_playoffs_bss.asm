; BSS of front/season_playoffs (src/front/season_playoffs).
bits 32
%include "hockey.inc"
section s_DD7CB nobits alloc noexec write align=1
global lgteam_17, lgteam_18, lgteam_19, lgteamver, lgteamver_hi, humancount, treeteamnames, poseriestext
global savedname, masterpw
lgteam_17:                                      ; leagueteams entry +17h; used by CreateNewLeague,
                                                ; MergeLeagueFiles, PlayLeagueGame ...
        resb 1
lgteam_18:                                      ; leagueteams entry +18h (2 at creation; 1 = local copy in
                                                ; LocateTeamDbCopy); used by CreateNewLeague
        resb 1
lgteam_19:                                      ; leagueteams entry +19h; used by CreateNewLeague
        resb 1
lgteamver:                                      ; leagueteams entry +1Ah dword stamp compared with the floppy
                                                ; copy (high word = export count); used by CreateNewLeague,
                                                ; ImportPlayerTeam, MergeLeagueFiles
        resb 2
lgteamver_hi:                                   ; high word of lgteamver, incremented by ExportDbs; used by
                                                ; ExportDbs
        resb 752
humancount:                                     ; PINFO +0: 'only one human controlled team' when 1, 'All the
                                                ; teams are already human' when >= 1Ah; used by AddHumanTeam,
                                                ; CheckMasterPassword, CreateNewLeague ...
        resb 4
treeteamnames:                                  ; 26 x 21-byte team names for the playoff tree (+ blank at
                                                ; +222h); used by AddHumanTeam, CreateNewLeague,
                                                ; DrawAwardsSummary ...
        resb 546
        resb 21
poseriestext:                                   ; POAfterGame: copy of poseriesbuf kept for the screen; used
                                                ; by POAfterGame
        resb 21
savedname:                                      ; PINFO +6 (0Dh bytes): SaveLeagueGameRef writes 'saved'; used
                                                ; by AddHumanTeam, CheckMasterPassword, ChooseLeagueController
                                                ; ...
        resb 13
masterpw:                                       ; PINFO +15h (0Bh bytes): AskMasterPassword strcmp's the input
                                                ; with it; used by AddHumanTeam, AskMasterPassword,
                                                ; CheckMasterPassword ...
        resb 11
