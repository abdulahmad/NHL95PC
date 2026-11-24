; Initialised data of front/stats_cards (src/front/stats_cards).
bits 32
%include "hockey.inc"
section s_C68CC progbits alloc noexec write align=1
extern str_Accumulated, str_Accuracy, str_Actual, str_Aggressiveness, str_Agility, str_Agility2, str_careerdb, str_carteamsdb
extern str_Checking2, str_DefensiveAwareness, str_DefensiveAwareness2, str_embnhl, str_embscup, str_Endurance, str_Faceoffs, str_GloveLeft
extern str_GloveRight, str_OffensiveAwareness, str_OffensiveAwareness2, str_Passing2, str_Playoff3, str_Playoff4, str_PuckControl, str_RegSeason
extern str_Season3, str_seasondb, str_ShootPassBias, str_ShotPower, str_Speed, str_Speed2, str_StickHandling, str_StickLeft
extern str_StickRight, str_teamsdb, str_Weight, str_Weight2
global statslabels, statsbgnames, statsplayerdbs, statsteamdbs, str_AttDb, str_fmt2d, str_fmt3d, str_fmt4d
global str_fmt5d, str_fmtTenths, str_fmtPct, str_fmtPct0, str_fmtMinSec, str_fmtEmb, str_Bkgd2, str_EASNvfn
global statsplayoffs, statsfromleague, photoremap, statspalvalid, skaterratingnames, skatercardattrs_m3, goalieratingnames, goaliecardattrs_m3
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
