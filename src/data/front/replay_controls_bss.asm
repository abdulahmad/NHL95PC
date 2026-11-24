; BSS of front/replay_controls (src/front/replay_controls).
bits 32
%include "hockey.inc"
section s_ED368 nobits alloc noexec write align=1
global rockteamcues, crowdsamples, rocktunes, rockrandcues, GadgetMovie, hilightslot, gadgetfile, gadgetptry
global gadgetptrx, gadgetshape, ReplaySpeedAccum, ReplayHoverPrev, replayspotx, replayspoty, replaynosave, replaybtnarmed
global hilightfont, replayptrx, replayptry, ReplayCamFree, ReplayHoverPlayer, ReplayStartRate, ReplayCtlFlags, replayfrac
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
