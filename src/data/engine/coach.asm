; Both teams while a game is on: lines, goalies, rosters, and scores.
bits 32
%include "hockey.inc"
section s_DF63E nobits alloc noexec write align=1
global hmtmgoalie_b1, hmtmflags, hmtmpbox, hmtmcoach_d2, hmtmcoach_d3, hmtmcoachflags, hmtmcoachmode, awtmflags
global hmtmextra, hmtmtouch2, hmtmtouch3, hmtmnear, hmtmpdst_m2, hmtmpdst_gl_m2, hmtmcoachenergy, hmtmlines
global hmtmplattr, hmtmglattr, hmtmplstats, hmtmglstats, hmtmroster, hmtmptrF2, hmtmsort
global awtmstruct
global awtmtouch3, awtmnear, hmtmline, hmtmlcnt, hmtmtouch1, hmtmap, hmtmgoalie
global hmtmnearpl, hmtmpde, hmtmpdst, hmtmgoaliesc, awscore, awtmline, awtmlcnt, awtmextra
global awtmtouch1, awtmtouch2, awtmap, awtmgoalie, awtmnearpl
hmtmline:                                       ; home tmline (hmtmstruct+2Ah): SetupTeamForIntermission sets
                                                ; 0/3/5; used by ClearCtlBlink, DrawHudPanel, InitCoachModes
                                                ; ...
        resb 2
hmtmlcnt:                                       ; home tmlcnt (hmtmstruct+2Ch); used by InitCoachModes,
                                                ; puckfaceoff
        resb 2
hmtmextra:                                      ; hmtmstruct+tmextra (2Eh): pnum of the extra attacker, -1
                                                ; with the goalie in; clearteams stores -1; used by clearteams
        resb 2
hmtmtouch1:                                     ; used by ChkScorerMilestone, PickThreeStars, StartHL2
        resb 2
hmtmtouch2:                                     ; used by ChkScorerMilestone, StartHL2
        resb 2
hmtmtouch3:                                     ; used by ChkScorerMilestone, StartHL2
        resb 2
hmtmap:                                         ; home tmap (hmtmstruct+36h), players in the penalty box count
                                                ; (6 = none in restoreteams); used by ClearCtlBlink,
                                                ; CrowdOnStoppage, GetLowestPen ...
        resb 2
hmtmgoalie:                                     ; home tmgoalie (hmtmstruct+38h); StartHL2 saves, zeroes and
                                                ; restores it; used by DebugMonitor, Goal, PostGameToTeamDb
                                                ; ...
        resb 1
hmtmgoalie_b1:                                  ; hmtmgoalie+1: the high byte of tmgoalie; SetTeamGoalie ORs
                                                ; FFh into it to make the word negative (goalie pulled); used
                                                ; by SetTeamGoalie
        resb 5
hmtmnear:                                       ; used by pucknorm_body, updateplayers
        resb 4
hmtmnearpl:                                     ; used by updateplayers
        resb 2
hmtmflags:                                      ; home tmflags (hmtmstruct+44h); used by ClearCtlBlink,
                                                ; MenuModeSettings, PenGoalStuff ...
        resb 2
hmtmpde:                                        ; hmtmstruct+tmpde; MenuModeSettings refills the 1Ch energy
                                                ; words to 1000h; used by MenuModeSettings, assthreestars
        resb 54
hmtmpdst_m2:                                    ; hmtmstruct+7Ch: -5r short-load base of tmpdst (7Eh), indexed
                                                ; [team*100h + pnum*2]; DebugMonitor/player_logic/key_team_db;
                                                ; used by DebugMonitor, LoadTeamRoster, StarEligible
        resb 2
hmtmpdst:                                       ; home tmpdst array (hmtmstruct+7Eh); TakePlayerFromBox
                                                ; indexes it with team*100h + player*2; used by
                                                ; TakePlayerFromBox
        resb 48
hmtmpdst_gl_m2:                                 ; hmtmpdst + 2*19h - 2: -5r short-load base of the goalies'
                                                ; tmpdst words (roster 19h up), LoadTeamRoster indexes it
                                                ; [team*100h + goalie*2]; used by LoadTeamRoster
        resb 8
hmtmpbox:                                       ; hmtmstruct+tmboxlist; clearteams stores FF, the empty
                                                ; penalty-box list; used by clearteams
        resb 28
hmtmcoach_d2:                                   ; hmtmstruct+D2h: coach AI byte (default 3, raised to 4 by
                                                ; UpdateCoachModes); meaning not traced; used by Goal,
                                                ; InitCoachModes, SetCoachMode ...
        resb 1
hmtmcoach_d3:                                   ; hmtmstruct+D3h: coach AI byte (default 2, lowered to 1 by
                                                ; UpdateCoachModes); meaning not traced; used by Goal,
                                                ; InitCoachModes, SetCoachMode ...
        resb 1
hmtmcoachflags:                                 ; hmtmstruct+D4h: coach AI flags (bit 0 computer line changes
                                                ; in CompLine, bits 6 and 7 line change state); used by
                                                ; InitCoachModes, SetCoachMode, UpdateCoachModes ...
        resb 1
hmtmcoachmode:                                  ; hmtmstruct+D5h: coach AI mode set by
                                                ; SetCoachMode/UpdateCoachModes; CompLine picks its line order
                                                ; row with it; used by InitCoachModes, SetCoachMode,
                                                ; UpdateCoachModes
        resb 1
hmtmcoachenergy:                                ; hmtmstruct+D6h: line energy limit of the coach mode (CCCh,
                                                ; D9Ah, B33h); CompLine compares getlinee with it; used by
                                                ; InitCoachModes, SetCoachMode, UpdateCoachModes
        resb 4
hmtmlines:                                      ; used by LoadGameState, PostGameToTeamDb, PostGoalEvent ...
        resb 4
hmtmplattr:                                     ; hmtmstruct+DEh: pointer to the home skater attribute records
                                                ; (hmplattr, 14h bytes each); setplayer reads a player's
                                                ; record through it; used by LoadGameState, clearteams
        resb 4
hmtmglattr:                                     ; hmtmstruct+E2h: pointer to the home goalie attribute records
                                                ; (hmglattr, 10h bytes each, indexed pnum*10h-190h); used by
                                                ; LoadGameState, clearteams
        resb 4
hmtmplstats:                                    ; hmtmstruct+tmplstats (E6h): pointer to home skater stats,
                                                ; loaded by DumpStatsLog; separate label because it sits in
                                                ; another data file; used by DumpStatsLog, LoadGameState,
                                                ; clearteams
        resb 4
hmtmglstats:                                    ; hmtmstruct+tmglstats; clearteams stores the goalie-stats
                                                ; pointer, next to hmtmplstats; used by LoadGameState,
                                                ; clearteams
        resb 4
hmtmroster:                                     ; home roster pointer (hmtmstruct+EEh), 27h bytes per player;
                                                ; ResetBench/setplayer write status bytes there; used by
                                                ; LoadGameState, clearteams
        resb 4
hmtmptrF2:                                      ; home team struct +F2h data pointer (clearteams sets
                                                ; hmteamrec, game_state_saveload too); role not identified;
                                                ; used by LoadGameState, clearteams
        resb 4
hmtmsort:                                       ; home tmsort pointer (hmtmstruct+F6h) to the first of its 6
                                                ; SortCords entries; used by LoadGameState, clearteams
        resb 4
hmtmgoaliesc:                                   ; hmtmstruct+FAh: player index of the goalie on the ice
                                                ; (updateplayers stores the loop index when position is 0; -1
                                                ; none); used by updateplayers
        resb 4
        resb 2
awtmstruct:                                     ; used by CPgoalie, ChkGoalies, ChkOffsides ...
        resb 2
        resb 6
        resb 2
        resb 2
        resb 2
        resb 2
awscore:                                        ; visitor tmscore (awtmstruct+10h); used by DrawHudPanel,
                                                ; DumpStatsLog, Goal ...
        resb 20
        resb 2
        resb 2
        resb 2
awtmline:                                       ; visitor tmline (awtmstruct+2Ah); used by DrawHudPanel,
                                                ; InitCoachModes, StartHL2 ...
        resb 2
awtmlcnt:                                       ; visitor tmlcnt (awtmstruct+2Ch); used by InitCoachModes,
                                                ; puckfaceoff
        resb 2
awtmextra:                                      ; awtmstruct+tmextra (2Eh); used by clearteams
        resb 2
awtmtouch1:                                     ; used by StartHL2
        resb 2
awtmtouch2:                                     ; used by StartHL2
        resb 2
awtmtouch3:                                     ; used by StartHL2
        resb 2
awtmap:                                         ; visitor tmap (awtmstruct+36h); used by CrowdOnStoppage,
                                                ; GetLowestPen, PlacePlayersAtStart ...
        resb 2
awtmgoalie:                                     ; visitor tmgoalie (awtmstruct+38h); used by DebugMonitor,
                                                ; Goal, PostGameToTeamDb ...
        resb 6
awtmnear:                                       ; used by pucknorm_body, updateplayers
        resb 4
awtmnearpl:                                     ; used by updateplayers
        resb 2
awtmflags:                                      ; visitor tmflags (awtmstruct+44h); used by MenuModeSettings,
                                                ; PenGoalStuff, puckfaceoff ...
        resb 2
