; The saved-game name, the palette cycle on the loading picture, and the trade roster.
bits 32
%include "hockey.inc"
section s_DC834 nobits alloc noexec write align=1
global awayremap, awayremap_e43, awayremap_eFF, homeremap, homeremap_e05, homeremap_e07, homeremap_e10
global homeremap_e11, homeremap_e13, homeremap_e14, homeremap_e16, homeremap_e43, homeremap_e49, homeremap_e50, homeremap_e51
global homeremap_e60, homeremap_eFB, homeremap_eFC, homeremap_eFD, homeremap_eFE, homeremap_eFF, menuremap, menuremap2
global savefname, fdlgmask, leaguedbfmt2, leaguedbfmt, othergames, othergamesb
global otherscores, otherscoresb, leagueflags, lgteamflags, lgteam_17, lgteam_18, lgteam_19, savedname
global lgschedrec, lgschedrec_b1, lgschedrec_b2, lgschedrec_b3, lgschedrec_b5, traderoster, tradejersey, tradeslot
global MergeResult, loadpals, palcyclephase, palcycledelay, statsfilepos, lgstatsfilepos, otherperiodprev, deskptry
global deskptrx, StreamHandle, CurStream, dirtyrectptr, statspalshape, statsbgshapes, statsteamrecs, statsteambuf
global statsskaterbuf, statsgoaliebuf, statssortkeys, statsplayerbuf, statspal, exhfiles
global exhfilenames, pofiles, pofilenames, lgfiles
global lgfilenames, fdlg_tabexh, fdlg_none, fdlg_tabpo, fdlg_open
global fdlg_del, fdlg_up, fdlg_cancel, fdlg_tabnone, fdlg_down, fdlgtab, fdlg_arrow, fdlg_tablp
global fdlg_noarrow, hmcrestbmp, vscrestbmp, dlgsavex, dlgsavey, editcurw, editpos, editmaxw
global editbuf, editcuron, edity, editx, rinkwtiles, rinkhtiles, bgscrolly
global otherperiod, floppyok, dbextension, calsel, floppyprobe, calexit, teamselresult
global traderesult, calmonth, criterrflag, leaguemaster, leaguesaved, lgteamver, humancount, calselday
global calredraw, calselmonth, lgoppteam, lgplayteam, lgopphuman, lgschedrec_b4, gridcelly, gridcellx
global lgplayeridfile, tradeclick, traderemap1, traderemap2, tradecursor, jerseymsg
global tradeside, tradebitmap, palcyclelock, plcareergoals, statsplayer
global deskbankname, awayremap_eC0, homeremap_eC0, printfbuf, leagueteams, treeteamnames, poseriestext
global masterpw, savleague1, savleague2, scrolly, scrollx, bgscrollx, bgscrolly8
global lgteamver_hi, lggameidx, lggamecount, lgoppgamecount
statsplayer:                                    ; copy of picked player record; used by CalStandingsMenu,
                                                ; CalStandingsMenu_player, CalStandingsMenu_player2 ...
        resb 2
        resb 1
        resb 16
        resb 21
statsfilepos:                                   ; stats cards: file position of the record (game stats); used
                                                ; by GoalieStatsCard, SkaterStatsCard
        resb 4
lgstatsfilepos:                                 ; stats cards: file position of the record when
                                                ; statsfromleague; used by GoalieStatsCard, SkaterStatsCard
        resb 8
otherperiodprev:                                ; Copy of otherperiod (six dwords) used by the intermission
                                                ; desk to spot changes
        resb 32
deskptry:                                       ; used by MenuSaveGame, SportsDesk
        resb 4
deskptrx:                                       ; used by MenuSaveGame, SportsDesk
        resb 4
deskbankname:                                   ; SportsDesk: 'EADESK%1d' bank name buffer; used by
                                                ; LoadCrestsPalette, SportsDesk
        resb 16
StreamHandle:                                   ; CD stream handle; used by CdStreamCreate,
                                                ; CdStreamCreateSecondary, CdStreamService ...
        resb 40
CurStream:                                      ; Stream record the CD stream service is working on; used by
                                                ; CdStreamCreate, CdStreamService
        resb 8
dirtyrectptr:                                   ; per-page rect list ptr (AddDirtyRect); used by AddDirtyRect
        resb 8
awayremap:                                      ; 256-byte colour remap table of the visiting team
                                                ; (LoadTeamPalette builds it from AWAYPALS.BIN, DrawSprite
                                                ; loads it); used by DrawHudPanel, DrawSprite, DrawTradeScreen
                                                ; ...
        resb 67
awayremap_e43:                                  ; awayremap+43h: entry 43h of the visitors' remap table; used
                                                ; by DrawHudPanel
        resb 125
awayremap_eC0:                                  ; awayremap+C0h: entry C0h of the visitors' remap table; used
                                                ; by DrawSprite
        resb 63
awayremap_eFF:                                  ; awayremap+FFh: entry FFh of the visitors' remap table; used
                                                ; by DrawHudPanel
        resb 1
homeremap:                                      ; 256-byte colour remap table of the home team
                                                ; (LoadTeamPalette builds it from HOMEPALS.BIN); used by
                                                ; DrawHudPanel, DrawLockerRoom, DrawSprite ...
        resb 5
homeremap_e05:                                  ; homeremap+5h: entry 5h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 2
homeremap_e07:                                  ; homeremap+7h: entry 7h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 9
homeremap_e10:                                  ; homeremap+10h: entry 10h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_e11:                                  ; homeremap+11h: entry 11h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 2
homeremap_e13:                                  ; homeremap+13h: entry 13h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_e14:                                  ; homeremap+14h: entry 14h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 2
homeremap_e16:                                  ; homeremap+16h: entry 16h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 45
homeremap_e43:                                  ; homeremap+43h: entry 43h of the home remap table; used by
                                                ; DrawHudPanel
        resb 6
homeremap_e49:                                  ; homeremap+49h: entry 49h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 7
homeremap_e50:                                  ; homeremap+50h: entry 50h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_e51:                                  ; homeremap+51h: entry 51h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 15
homeremap_e60:                                  ; homeremap+60h: entry 60h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 96
homeremap_eC0:                                  ; homeremap+C0h: entry C0h of the home remap table; used by
                                                ; DrawSprite
        resb 59
homeremap_eFB:                                  ; homeremap+FBh: entry FBh of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_eFC:                                  ; homeremap+FCh: entry FCh of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_eFD:                                  ; homeremap+FDh: entry FDh of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_eFE:                                  ; homeremap+FEh: entry FEh of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_eFF:                                  ; homeremap+FFh: entry FFh of the home remap table; used by
                                                ; DrawHudPanel
        resb 1281
menuremap:                                      ; remap table; used by InitMenuRemap
        resb 128
menuremap2:                                     ; second half/remap table written in identity mode; used by
                                                ; InitMenuRemap
        resb 128
printfbuf:                                      ; sprintf scratch for screen text; used by GoalieStatsCard,
                                                ; LeadersScreen, SkaterStatsCard ...
        resb 40
statspalshape:                                  ; "!pal" shape from embpal; used by CalGoalieStatsScreen,
                                                ; CalSkaterStatsScreen, CalStandingsMenu ...
        resb 4
statsbgshapes:                                  ; embpal shape file handle; used by CalGoalieStatsScreen,
                                                ; CalSkaterStatsScreen, CalStandingsMenu ...
        resb 4
statsteamrecs:                                  ; "teams" buffer, 4Ch-byte team stat records; used by
                                                ; CmpTeamDefense, CmpTeamPK, CmpTeamPP ...
        resb 4
statsteambuf:                                   ; team stat records (1Ah bytes); used by CalStandingsMenu,
                                                ; CalStandingsMenu_player2, CalStandingsScreen ...
        resb 4
statsskaterbuf:                                 ; skater stat records (2Fh bytes, playoffs +12h); used by
                                                ; CalStandingsMenu, CalStandingsMenu_player2, CmpAssists ...
        resb 4
statsgoaliebuf:                                 ; goalie stat records (36h bytes, playoffs +16h); used by
                                                ; CalStandingsMenu, CalStandingsMenu_player2, CmpGAA ...
        resb 4
statssortkeys:                                  ; "addsort" buffer, per-entry sort keys; used by CmpShootPct,
                                                ; CmpTeamPK, CmpTeamPP ...
        resb 4
statsplayerbuf:                                 ; player records (34h bytes; +2 pos, +3 first, +13h last
                                                ; name); used by CalStandingsMenu, CalStandingsMenu_player2,
                                                ; EasnStandingsMenu_m ...
        resb 4
statspal:                                       ; saved 300h palette; used by DrawPhotoWithPal,
                                                ; EasnStandingsMenu_player2, GameSkaterStatsScreen ...
        resb 4
exhfiles:                                       ; *.nhl list block (90h); used by DeleteSavedGame,
                                                ; DrawFileDlg, MenuOpenSaved ...
        resb 4
        resb 4
        resb 4
        resb 4
exhfilenames:                                   ; *.nhl name pointer array (exhfiles+10h); used by
                                                ; MenuOpenSaved, ScanSavedGames, SelectSavedFile
        resb 128
pofiles:                                        ; *.po list block; used by DeleteSavedGame, DrawFileDlg,
                                                ; MenuOpenSaved ...
        resb 4
        resb 4
        resb 4
        resb 4
pofilenames:                                    ; *.po name pointer array; used by MenuOpenSaved,
                                                ; ScanSavedGames, SelectSavedFile
        resb 128
lgfiles:                                        ; *.lp list block; used by DeleteSavedGame, DrawFileDlg,
                                                ; MenuOpenSaved ...
        resb 4
        resb 4
        resb 4
        resb 4
lgfilenames:                                    ; *.lp name pointer array; used by MenuOpenSaved,
                                                ; ScanSavedGames, SelectSavedFile
        resb 128
savefname:                                      ; current save file name buffer (also database_dialogs); used
                                                ; by ScanDbFiles, ScanSavedGames
        resb 8
        resb 856
fdlg_tabexh:                                    ; "gtex" shape; used by DrawDbDialogButtons, DrawDbList_n1,
                                                ; DrawFileDlgList_n1 ...
        resb 4
fdlg_none:                                      ; "none" shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlg_tabpo:                                     ; "gtpo" shape; used by DrawDbDialogButtons, DrawDbList_n1,
                                                ; DrawFileDlgList_n1 ...
        resb 4
fdlg_open:                                      ; "open" shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlg_del:                                       ; "del " shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlg_up:                                        ; "up " shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlg_cancel:                                    ; "can " shape; used by DbDialogLoop, ExhSetEditLoop,
                                                ; LeagueSetEditLoop ...
        resb 4
fdlg_tabnone:                                   ; "gtno" shape; used by DrawFileDlgTabs, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes
        resb 4
fdlg_down:                                      ; "down" shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlgtab:                                        ; current tab 0 exhibition / 1 playoffs / 2 league; used by
                                                ; DbDialogLoop, DeleteSavedGame, DeleteSelectedDb ...
        resb 4
fdlg_arrow:                                     ; "arro" shape; used by DrawFileDlgList_n1, DrawFileDlgTabs,
                                                ; LoadDbDialogShapes ...
        resb 4
fdlg_tablp:                                     ; "gtlp" shape; used by DrawDbDialogButtons, DrawDbList_n1,
                                                ; DrawFileDlgList_n1 ...
        resb 4
fdlg_noarrow:                                   ; "noar" shape; used by DbDialogLoop, DrawDbDialogButtons,
                                                ; DrawFileDlgList_n1 ...
        resb 4
fdlgmask:                                       ; visible-row / button mask; used by DbDialogLoop,
                                                ; DeleteSavedGame, DeleteSelectedDb ...
        resb 1
        resb 3
hmcrestbmp:                                     ; home crest bitmap (crestnames[HomeTeam]); used by
                                                ; GameSummaryScreen, GameSummaryScreen_period
        resb 4
vscrestbmp:                                     ; visitor crest bitmap; used by GameSummaryScreen,
                                                ; GameSummaryScreen_period
        resb 8
dlgsavex:                                       ; string ''; used by RestoreDialogBg, SaveDialogBg
        resb 16
dlgsavey:                                       ; string ''; used by RestoreDialogBg, SaveDialogBg
        resb 4
editcurw:                                       ; string ''; used by DrawEditCursor, EditTextField
        resb 4
editpos:                                        ; string ''; used by DrawEditCursor, DrawEditText,
                                                ; EditTextField
        resb 4
editmaxw:                                       ; string ''; used by DrawEditText, EditTextField
        resb 4
editbuf:                                        ; string ''; used by DrawEditCursor, DrawEditText,
                                                ; EditTextField
        resb 4
editcuron:                                      ; string ''; used by DrawEditCursor, EditTextField
        resb 4
edity:                                          ; string ''; used by DrawEditCursor, DrawEditText,
                                                ; EditTextField
        resb 4
editx:                                          ; string ''; used by DrawEditCursor, DrawEditText,
                                                ; EditTextField
        resb 2
        resb 2
rinkwtiles:                                     ; word: rink width in tiles (30h); used by BlitTileMap,
                                                ; LoadRink
        resb 2
scrolly:                                        ; vgaflip: CRTC start = scrpitch*scrolly + scrollx/4 + page
                                                ; base; used by DrawCallBanner, DrawTextOverlay, Gameloop ...
        resb 2
scrollx:                                        ; vgaflip: low 2 bits -> attribute 33h pixel panning; used by
                                                ; DrawCallBanner, DrawTextOverlay, Gameloop ...
        resb 2
rinkhtiles:                                     ; word: rink height in tiles (4Ah); used by LoadRink
        resb 2
bgscrolly:                                      ; word: background tile scroll y (pairs with bgscrollx); used
                                                ; by Gameloop, InstantReplay, LoadRink ...
        resb 2
bgscrollx:                                      ; background x offset (added twice, words) in the circular
                                                ; VRAM background buffer; used by Gameloop, InstantReplay,
                                                ; LoadRink ...
        resb 90
bgscrolly8:                                     ; background top row in 8-line units in the circular VRAM
                                                ; background buffer (vgacopy_bg, vgacopy_bgfull: *8 rows /
                                                ; *300h bytes); used by vgacopy_bg, vgacopy_bgfull
        resb 4
leaguedbfmt2:                                   ; copy of leaguedbfmt used as the fallback path by
                                                ; LoadScheduleDB; used by CreatePlayoffs, ExecuteTrade,
                                                ; GameSummaryScreen ...
        resb 32
otherperiod:                                    ; 6 dwords: period / state of each other game (5 final OT, 6
                                                ; final); used by GameSummaryScreen, IntermissionDesk,
                                                ; MenuOpenSaved ...
        resb 24
floppyok:                                       ; [2] drive A / B readable (SelectFloppyDrive); used by
                                                ; FindLeagueFloppy, SelectFloppyDrive
        resb 4
        resb 4
leaguedbfmt:                                    ; league DB path format '<league>\%s.db' built by
                                                ; CreatePlayoffs; LoadScheduleDB sprintf's 'schedule' into it;
                                                ; used by CreatePlayoffs, ExecuteTrade, GameSummaryScreen ...
        resb 32
dbextension:                                    ; ".DB" or ".ORG" from AskDatabaseChoice; used by
                                                ; AskDatabaseChoice, CreateNewLeague, CreatePlayoffs
        resb 4
othergames:                                     ; 6 team pairs (byte, byte) of the other games; used by
                                                ; GameSummaryScreen, MenuOpenSaved, MenuSaveGame ...
        resb 1
othergamesb:                                    ; second team of each other-game pair (othergames+1); used by
                                                ; GameSummaryScreen, PickOtherGames, PlayRandomHighlight
        resb 11
calsel:                                         ; selected calendar day (-1 none); used by CalNextMonth,
                                                ; CalPrevMonth, CalReturn ...
        resb 4
floppyprobe:                                    ; -1 while probing floppy drives; used by FindLeagueFloppy,
                                                ; SelectFloppyDrive
        resb 4
otherscores:                                    ; 6 score pairs; used by GameSummaryScreen, MenuOpenSaved,
                                                ; MenuSaveGame ...
        resb 1
otherscoresb:                                   ; second score of each pair (otherscores+1); used by
                                                ; GameSummaryScreen, PickOtherGames, PlayRandomHighlight ...
        resb 11
calexit:                                        ; set by CalReturn; used by CalReturn, CalendarScreen
        resb 4
teamselresult:                                  ; 1 Done / -1 Cancel; used by LeagueTeamSelect, TeamSelCancel,
                                                ; TeamSelDone
        resb 4
traderesult:                                    ; trade screen result (Done / Cancel); used by TradeCancel,
                                                ; TradeDone, TradeScreenLoop
        resb 4
calmonth:                                       ; calendar month 0-11; used by CalNextMonth, CalPrevMonth,
                                                ; CalendarScreen
        resb 4
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
calselday:                                      ; day of the selected game; used by CalendarScreen,
                                                ; DrawCalendarDay
        resb 4
calredraw:                                      ; CalendarScreen: set to redraw the month; used by
                                                ; CalStandingsMenu_player2, CalTeamStatsScreen_common,
                                                ; CalendarScreen
        resb 4
calselmonth:                                    ; month of the selected game (1-based); used by
                                                ; CalendarScreen, DrawCalendarDay
        resb 4
lgoppteam:                                      ; Opponent of the league team being played; saved with the
                                                ; league game reference; used by LoadLeagueGameRef,
                                                ; PlayLeagueGame, SaveLeagueGameRef
        resb 4
lgplayteam:                                     ; human team chosen in PlayLeagueGame ("Select a team to
                                                ; play."); used by LoadLeagueGameRef, PlayLeagueGame,
                                                ; SaveLeagueGameRef
        resb 4
lgopphuman:                                     ; Non-zero when the league opponent has its own human team
                                                ; file; saved with the league game reference; used by
                                                ; LoadLeagueGameRef, PlayLeagueGame, SaveLeagueGameRef
        resb 4
lgschedrec:                                     ; PlayLeagueGame: the schedule record of the league game being
                                                ; played; used by LoadLeagueGameRef, PlayLeagueGame,
                                                ; SaveLeagueGameRef
        resb 1
lgschedrec_b1:                                  ; lgschedrec+1; used by PlayLeagueGame
        resb 1
lgschedrec_b2:                                  ; lgschedrec+2; used by PlayLeagueGame
        resb 1
lgschedrec_b3:                                  ; lgschedrec+3; used by PlayLeagueGame
        resb 1
lgschedrec_b4:                                  ; lgschedrec+4: a finished game keeps the first score here;
                                                ; used by PlayLeagueGame
        resb 1
lgschedrec_b5:                                  ; lgschedrec+5: the second score; used by PlayLeagueGame
        resb 1
lggameidx:                                      ; schedule game picked in CalendarScreen (-1 none); used by
                                                ; LoadLeagueGameRef, PlayLeagueGame, SaveLeagueGameRef
        resb 2
lggamecount:                                    ; Number of league games played (from the league file);
                                                ; compared with lggameidx; used by LoadLeagueGameRef,
                                                ; PlayLeagueGame, SaveLeagueGameRef
        resb 2
lgoppgamecount:                                 ; Number of league games played in the opponent's file; used
                                                ; by LoadLeagueGameRef, PlayLeagueGame, SaveLeagueGameRef
        resb 2
savleague1:                                     ; saved-game league path (0Dh): SaveLeagueGameRef writes it
                                                ; and opens its PINFO.DB; used by LoadLeagueGameRef,
                                                ; PlayLeagueGame, SaveLeagueGameRef
        resb 13
savleague2:                                     ; second saved-game league path (0Dh), used when lgopphuman is
                                                ; set; used by LoadLeagueGameRef, PlayLeagueGame,
                                                ; SaveLeagueGameRef
        resb 15
gridcelly:                                      ; string ''; used by RestoreGridCellBg, SaveGridCellBg
        resb 4
gridcellx:                                      ; string ''; used by RestoreGridCellBg, SaveGridCellBg
        resb 4
lgplayeridfile:                                 ; PLAYER.ID exists in the league dir (floppy player copy, not
                                                ; master); used by MergeLeagueFiles, MergeUpdateDbs
        resb 4
tradeclick:                                     ; [2] last clicked row per side (-1 none); used by
                                                ; TradeScreen, TradeScreenLoop
        resb 4
        resb 4
traderemap1:                                    ; colour remap of team 1 (homeremap); used by DrawTradeScreen,
                                                ; TradeScreenLoop
        resb 4
traderemap2:                                    ; colour remap of team 2 (awayremap); used by DrawTradeScreen
        resb 4
tradecursor:                                    ; [2] cursor row per side (-1 none); used by DrawTradeRow,
                                                ; DrawTradeScreen, TradeScreen ...
        resb 4
        resb 4
traderoster:                                    ; [2][28] 16h-byte trade entries (side 2 at +268h); used by
                                                ; DrawTradeRow, DrawTradeScreen, TradeScreen ...
        resb 1
tradejersey:                                    ; traderoster entry +1 jersey (indexed with two registers,
                                                ; kept as its own label); used by DrawTradeRow,
                                                ; DrawTradeScreen, TradeScreenLoop
        resb 1
tradeslot:                                      ; traderoster entry +2 roster slot (two-register index, own
                                                ; label); used by FindTradeSlot, TradeScreenLoop
        resb 614
        resb 616
jerseymsg:                                      ; one-line message table (sprintf buffer) for the jersey
                                                ; conflict; used by FixJerseyConflict
        resb 4
tradeside:                                      ; active side (0 / 1, -1 none); used by TradeScreen,
                                                ; TradeScreenLoop
        resb 4
tradebitmap:                                    ; the 640 x 480 bitmap of the trade screen (TradePlayers makes
                                                ; it); used by DrawTradeScreen, TradePlayers, TradeScreen
        resb 1
        resb 3
MergeResult:                                    ; Result byte of the league file merge and human team dialogs;
                                                ; used by AddHumanTeam, AdvancePlayoffs, BuildPlayoffs ...
        resb 4
loadpals:                                       ; [3][300h] rotated loading-screen palettes; used by
                                                ; FadeOutPalCycle, LoadScreenPalTick, ShowLoadingScreen
        resb 2304
palcyclelock:                                   ; 1 while the palette cycle is busy / disabled; used by
                                                ; FadeOutPalCycle, LoadScreenPalTick, ShowLoadingScreen
        resb 4
palcyclephase:                                  ; current palette 0..2; used by LoadScreenPalTick,
                                                ; ShowLoadingScreen
        resb 1
palcycledelay:                                  ; ticks until the next palette step (reload 3); used by
                                                ; LoadScreenPalTick, ShowLoadingScreen
        resb 3
plcareergoals:                                  ; per player (10h each, 25 a team): career goals before this
                                                ; game (LoadTeamRoster); ChkScorerMilestone; used by
                                                ; ChkScorerMilestone, LoadTeamRoster
        resb 4
