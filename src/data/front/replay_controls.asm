; The line-editor panel, which files are on the CD, and the lists in the database dialog.
bits 32
%include "hockey.inc"
section s_EC6B8 nobits alloc noexec write align=1
global lineedpanel, fadepal, fadepal2, gamelinespal, gmroster, gmrosterjersey, gmrosterslot, gmrosterpos
global gmrosterdot, gmrosterspace, gmrostername, fileoncd
global portraitoncd
global dblistcur, dblisttemp
global dblisttempnames, dblistorig
global blitclipright, blitclipbottom, blitcliptop, blitclipleft, leaguesetimg, setbits, ControlsDlgFlags, rockteamcues
global crowdsamples, rocktunes, rockrandcues, GadgetMovie, hilightslot, gadgetfile
global gadgetptry, gadgetptrx, gadgetshape, ReplaySpeedAccum, ReplayHoverPrev, replayspotx, replayspoty, replaynosave
global replaybtnarmed, hilightfont, replayptrx, replayptry, ReplayCamFree, ReplayHoverPlayer, ReplayStartRate, ReplayCtlFlags
global pl20spr, pl05spr, pl10spr, pg07spr, na05spr, pg01spr, acptspr
global na03spr, pg03spr, chkoffspr, pg05spr, chkonspr, na01spr, titlebckspr, homebckspr
global homenamebckspr, visbckspr, visnamebckspr, SfxTestSample, SpeechMemBlock, speechq, speechbank, samplereq
global speechcopybuf, vgapage, memlist1, memlist0, curdbname, poseriesbuf, replayfrac
dblistcur:                                      ; list struct (58h): count, sel +4, top +8, last visible +0Ch,
                                                ; names[16] +10h; current DB; used by DeleteSelectedDb,
                                                ; DrawDbDialog, ScanDbFiles
        resb 4
        resb 4
        resb 4
        resb 4
        resb 72
dblisttemp:                                     ; temporary (.DBX) list struct; used by DrawDbDialog,
                                                ; OpenSelectedDb, ScanDbFiles
        resb 4
        resb 4
        resb 4
        resb 4
dblisttempnames:                                ; dblisttemp names[16] (own label, nosplit operand); used by
                                                ; OpenSelectedDb, ScanDbFiles
        resb 72
dblistorig:                                     ; original (.ORG) list struct; used by DeleteSelectedDb,
                                                ; DrawDbDialog, ScanDbFiles
        resb 4
        resb 4
        resb 4
        resb 4
        resb 72
curdbname:                                      ; current database name ("Current" or .DBX name); used by
                                                ; DrawDatabaseName, MenuSaveDbs, MenuSaveDbsAs ...
        resb 32
lineedpanel:                                    ; roster panel of the line editor; used by DbLineEditor,
                                                ; ShowRosterStats
        resb 4
fadepal:                                        ; 300h working palette of FadePalStep; used by FadePalStep
        resb 768
fadepal2:                                       ; 300h working palette of FadePalStepSlow; used by
                                                ; FadePalStepSlow
        resb 768
blitclipright:                                  ; BlitClipRect: x >= this rejects, x+w clamped to it; used by
                                                ; BlitClipRect
        resb 4
blitclipbottom:                                 ; BlitClipRect: y >= this rejects, y+h clamped to it; used by
                                                ; BlitClipRect
        resb 4
blitcliptop:                                    ; BlitClipRect: y+h < this rejects, y clamped up to it; used
                                                ; by BlitClipRect
        resb 4
blitclipleft:                                   ; BlitClipRect: x+w < this rejects, x clamped up to it; used
                                                ; by BlitClipRect
        resb 4
gamelinespal:                                   ; game line editor: 768-byte saved palette; used by
                                                ; MenuGameShowPlayerStats
        resb 768
gmroster:                                       ; game line editor roster entries (1Ah bytes): position; used
                                                ; by CheckGameRosterComplete, DrawGameLineJerseys_join,
                                                ; GameDressPlayer ...
        resb 1
gmrosterjersey:                                 ; entry +1 jersey; used by DrawGameLineJerseys_join,
                                                ; GameDressPlayer, GameLineEditorLoop ...
        resb 1
gmrosterslot:                                   ; entry +2 hmroster index; used by CheckGameRosterComplete,
                                                ; DrawGameLineJerseys, GameDressPlayer ...
        resb 1
gmrosterpos:                                    ; Byte 3 of each game roster record (26 bytes): copied from
                                                ; the roster file record; used by LoadGameRoster
        resb 1
gmrosterdot:                                    ; Byte 4 of each game roster record: set to a full stop after
                                                ; the jersey number; used by LoadGameRoster
        resb 1
gmrosterspace:                                  ; Byte 5 of each game roster record: set to a space before the
                                                ; name; used by LoadGameRoster
        resb 1
gmrostername:                                   ; Player name (16 bytes) of each game roster record; used by
                                                ; LoadGameRoster
        resb 610
leaguesetimg:                                   ; selects setting5 vs setting3 image; used by
                                                ; DrawLeagueSetDlgSel, PlayCrowdSample, SetLeagueSetImage
        resb 4
setbits:                                        ; settings dialog checkbox bits; used by ControlsDlgLoop,
                                                ; DrawControlsOpts, DrawCtlBoxes ...
        resb 1
        resb 3
ControlsDlgFlags:                               ; Bit flags the controls dialog builds from its options; used
                                                ; by ControlsDlgLoop, DrawControlsOpts
        resb 4
rockteamcues:                                   ; 6 loaded team music cue handles; used by FreeRockMusic,
                                                ; LoadRockMusic, PlayCrowdSample
        resb 12
crowdsamples:                                   ; PlayCrowdSample: samples of cues 6 to 8; used by
                                                ; PlayCrowdSample
        resb 12
rocktunes:                                      ; 3 handles: device rock tune, team tune, ROCKDITI; used by
                                                ; FreeRockMusic, LoadRockMusic
        resb 4
        resb 4
        resb 4
rockrandcues:                                   ; 3 random cue handles; used by FreeRockMusic, LoadRockMusic
        resb 836
GadgetMovie:                                    ; Movie handle; GadgetMovieFrameRate reads its rate; used
                                                ; by GadgetMovieFrameRate
        resb 4
hilightslot:                                    ; ReplaySaveHilight: the highlight slot row picked, 0-3; used
                                                ; by ReplaySaveHilight
        resb 4
gadgetfile:                                     ; loaded gadget .PPV file; used by InstantReplay,
                                                ; ReplaySaveHilight, ReplaySaveHilight_n3
        resb 4
gadgetptry:                                     ; pointer y (init 0BCh); used by InstantReplay,
                                                ; ReplayControlLoop, ReplaySaveHilight ...
        resb 4
gadgetptrx:                                     ; pointer x (init 100h); used by InstantReplay,
                                                ; ReplayControlLoop, ReplaySaveHilight ...
        resb 4
gadgetshape:                                    ; gad1 shape from gadget file; used by InstantReplay,
                                                ; ReplayControlLoop, ReplaySaveHilight ...
        resb 4
ReplaySpeedAccum:                               ; Replay speed accumulator; the replay steps a frame each time
                                                ; it reaches five; used by ReplayControlLoop
        resb 4
ReplayHoverPrev:                                ; Player last highlighted under the replay pointer (-1 for
                                                ; none); used by InstantReplay, ReplayControlLoop
        resb 4
replayspotx:                                    ; instant replay: x of the spot the camera follows; used by
                                                ; InstantReplay, ReplayControlLoop
        resb 4
replayspoty:                                    ; instant replay: y of the spot the camera follows; used by
                                                ; InstantReplay, ReplayControlLoop
        resb 4
replaynosave:                                   ; instant replay: the save highlight button is off
                                                ; (exhibition, no human team, or no disk space); used by
                                                ; InstantReplay, ReplayControlLoop, SaveHilight
        resb 4
replaybtnarmed:                                 ; ReplayControlLoop: a press arms the buttons, a release
                                                ; disarms them; used by InstantReplay, ReplayControlLoop
        resb 4
hilightfont:                                    ; loaded HILIGHT.VFN (LoadGameGfx); used by FreeGameMemory,
                                                ; HilightSaveToDlg, LoadGameGfx ...
        resb 4
replayptrx:                                     ; instant replay: rink x under the pointer; used by
                                                ; InstantReplay, ReplayControlLoop
        resb 4
replayptry:                                     ; instant replay: rink y under the pointer; used by
                                                ; InstantReplay, ReplayControlLoop
        resb 4
ReplayCamFree:                                  ; Set when the replay camera follows the pointer instead of a
                                                ; player; used by InstantReplay, ReplayControlLoop
        resb 64
ReplayHoverPlayer:                              ; Player nearest the replay pointer (-1 for none); used by
                                                ; DrawRinkSideObjects, InstantReplay, ReplayControlLoop
        resb 4
ReplayStartRate:                                ; Set to 8 when instant replay starts; used by InstantReplay
        resb 4
ReplayCtlFlags:                                 ; Replay control button state flags (44h at start); used by
                                                ; InstantReplay, ReplayControlLoop
        resb 2
        resb 2
replayfrac:                                     ; instant replay: fraction of a replay step kept between
                                                ; passes (twentieths); used by InstantReplay,
                                                ; ReplayControlLoop
        resb 4
pl20spr:                                        ; "pl20" shape; used by DrawExhSetChecks, DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
pl05spr:                                        ; "pl05" period length shape; used by DrawExhSetChecks,
                                                ; DrawLeagueSetChecks, LoadSettingsShapes
        resb 4
pl10spr:                                        ; "pl10" shape; used by DrawExhSetChecks, DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
pg07spr:                                        ; "pg07" shape; used by DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
na05spr:                                        ; "na05" shape; used by DrawLeagueSetDlg, LoadSettingsShapes
        resb 4
pg01spr:                                        ; "pg01" shape; used by DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
acptspr:                                        ; "acpt" shape; used by ExhSetEditLoop, LeagueSetEditLoop,
                                                ; LoadSettingsShapes ...
        resb 4
na03spr:                                        ; "na03" shape; used by DrawLeagueSetDlg, LoadSettingsShapes
        resb 4
pg03spr:                                        ; "pg03" shape; used by DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
chkoffspr:                                      ; unchecked box shape; used by DrawExhSetChecks,
                                                ; DrawLeagueSetChecks, DrawModeSetChecks ...
        resb 4
pg05spr:                                        ; "pg05" shape; used by DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
chkonspr:                                       ; checked box shape; used by DrawExhSetChecks,
                                                ; DrawLeagueSetChecks, DrawModeSetChecks ...
        resb 4
na01spr:                                        ; "na01" shape; used by DrawLeagueSetDlg, LoadSettingsShapes
        resb 4
titlebckspr:                                    ; TitleBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
homebckspr:                                     ; HomeBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
homenamebckspr:                                 ; HomeNameBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
visbckspr:                                      ; VisBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
visnamebckspr:                                  ; VisNameBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
SfxTestSample:                                  ; Sample handle the sound setup frees when the device changes;
                                                ; used by SetSoundDevice, sfx
        resb 4
SpeechMemBlock:                                 ; Memory block freed after the speech system shuts down; used
                                                ; by SetSoundDevice
        resb 4
speechq:                                        ; speech queue struct (20 entries + counters at +50h..+60h);
                                                ; used by InitSpeech, QueueSpeechClip, ResetSpeechQueue ...
        resb 4
speechbank:                                     ; 400 x 26h slot table + header at +3B60h..+3B80h; used by
                                                ; CompactSpeechSlot, FindFreeSpeechSlot, FindLoadedSpeechSlot
                                                ; ...
        resb 4
samplereq:                                      ; 'sample mem man': 20 requested names + counters; used by
                                                ; InitSpeech, IsSampleRequested, MakeSampleRoom ...
        resb 4
speechcopybuf:                                  ; copy buffer for MoveSampleMem; used by InitSpeech,
                                                ; MoveSampleMem
        resb 4
poseriesbuf:                                    ; POAfterGame: buffer the series score is formatted into; used
                                                ; by POAfterGame
        resb 16
fileoncd:                                       ; 549 per-file flags: 1 = load from CD (MakePath prefix
                                                ; cddriveptr), 0 = installed locally (from ALLFILES.TXT); used
                                                ; by AddHumanTeam, AwardsCeremony, CalGoalieStatsScreen ...
        resb 1
        resb 23
        resb 2
        resb 5
        resb 2
        resb 3
        resb 3
        resb 4
        resb 42
        resb 2
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 7
        resb 1
        resb 3
        resb 1
        resb 2
        resb 6
        resb 28
        resb 1
        resb 1
        resb 2
        resb 6
        resb 10
        resb 1
        resb 70
        resb 1
        resb 1
        resb 14
        resb 3
        resb 2
        resb 4
        resb 2
        resb 2
        resb 7
        resb 28
        resb 1
        resb 2
        resb 1
        resb 1
        resb 12
        resb 2
        resb 2
        resb 1
portraitoncd:                                   ; player cards: 1 when the portrait of the player is read from
                                                ; the CD; used by GoalieStatsCard, SkaterStatsCard
        resb 30
        resb 4
        resb 2
        resb 1
        resb 1
        resb 3
        resb 3
        resb 1
        resb 2
        resb 1
        resb 1
        resb 5
        resb 1
        resb 1
        resb 1
        resb 1
        resb 24
        resb 2
        resb 25
        resb 3
        resb 19
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 18
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 2
        resb 1
        resb 50
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 1
        resb 2
        resb 1
        resb 1
        resb 20
vgapage:                                        ; vgaflip toggles it 0/1 and shows page 0B00h or 4400h; used
                                                ; by AddDirtyRect, BlitClipRect, vgaflip
        resb 4
memlist1:                                       ; memory block list head returned by GetMemListHead(1); used
                                                ; by AddHighMemList, AddMemListRegion, FindCachedFile ...
        resb 4
memlist0:                                       ; memory block list head returned by GetMemListHead(0); used
                                                ; by GetMemListHead, MemViewerListHead
        resb 156
