; BSS of front/awards (src/front/awards).
bits 32
%include "hockey.inc"
section s_D8C68 nobits alloc noexec write align=1
global rinkendbank, frameaccum, rinkendart, viewscrolly, hudhundaccum, viewscrollx, numshpbank, curperiod
global fadepalbuf, cupteam, presidentsteam, awardwinners, awardwinners_e01, awardwinners_e02, awardwinners_e03, awardwinners_e04
global awardwinners_e05, awardwinners_e06, awardwinners_e08, awardwinners_e09, awardstats9g, awardstats5, awardstats4, awardstats8
global awardstats2, awardstats1, awardstats9, awardstats3, awardstats0, awardstats6, photobanks, photoptrs
rinkendbank:                                    ; loaded trinknd.PPV holding rinkendart
                                                ; (LoadTransparentRinkEndOverlay); used by FreeGameMemory,
                                                ; LoadTransparentRinkEndOverlay, PlayHilight
        resb 4
frameaccum:                                     ; GameLoop: remainder of ticks*6 / 10 carried to the next pass
                                                ; when converting timer ticks to game frames; used by
                                                ; DumpStatsLog, Gameloop, LoadGameState ...
        resb 4
rinkendart:                                     ; frame '0000' of the 'trinknd' rink-end art (asset_loading),
                                                ; drawn by DrawRinkEndArt; used by DrawRinkEndArt,
                                                ; LoadTransparentRinkEndOverlay
        resb 2
        resb 2
viewscrolly:                                    ; rink view scroll y: 140h-camy-54h clamped to 1A8h, passed as
                                                ; edx to SetRinkScroll; used by Gameloop, InstantReplay,
                                                ; PreGameIntro ...
        resb 4
hudhundaccum:                                   ; used by DumpStatsLog, Gameloop, LoadGameState ...
        resb 2
        resb 2
viewscrollx:                                    ; rink view scroll x: camx+20h clamped to 0..40h, passed as
                                                ; eax to SetRinkScroll (game frame, replay); used by Gameloop,
                                                ; InstantReplay, PreGameIntro ...
        resb 4
numshpbank:                                     ; loaded numshp.PPV (LoadGameGfx); used by FreeGameMemory,
                                                ; LoadGameGfx, LoadGameGfx_common ...
        resb 4
curperiod:                                      ; period number (hilight record +3Ch printed as "Period %d";
                                                ; compared with 3); used by CheckGameRosterComplete,
                                                ; ClockTick, DeskPenaltySummary ...
        resb 4
fadepalbuf:                                     ; FadePalette: the scaled palette of each fade step is built
                                                ; here and set; used by FadePalette
        resb 768
cupteam:                                        ; team record shown for award 10 (Stanley Cup);
                                                ; PickAwardWinners, ShowAwardScreens; used by
                                                ; DrawAwardsSummary, PickAwardWinners, ShowAwardScreens
        resb 5
        resb 739
presidentsteam:                                 ; team record of the best regular-season record (Presidents'
                                                ; Trophy; points 2*W + T, then win%); PickAwardWinners,
                                                ; ShowAwardScreens; used by DrawAwardsSummary,
                                                ; PickAwardWinners, ShowAwardScreens
        resb 5
        resb 36
        resb 703
awardwinners:                                   ; used by DrawAwardsSummary, PickAwardWinners,
                                                ; ShowAwardScreens
        resb 52
awardwinners_e01:                               ; awardwinners[1] (34h-byte key records), filled by
                                                ; PickAwardWinners; used by PickAwardWinners
        resb 52
awardwinners_e02:                               ; awardwinners[2]; used by PickAwardWinners
        resb 52
awardwinners_e03:                               ; awardwinners[3]; used by PickAwardWinners
        resb 52
awardwinners_e04:                               ; awardwinners[4]; used by PickAwardWinners
        resb 52
awardwinners_e05:                               ; awardwinners[5]; used by PickAwardWinners
        resb 52
awardwinners_e06:                               ; awardwinners[6]; used by PickAwardWinners
        resb 104
awardwinners_e08:                               ; awardwinners[8]; used by PickAwardWinners
        resb 52
awardwinners_e09:                               ; awardwinners[9]; used by PickAwardWinners
        resb 104
awardstats9g:                                   ; goalie season stats record of award 9's winner when a goalie
                                                ; wins it; used by PickAwardWinners
        resb 54
awardstats5:                                    ; goalie season stats record of award 5's winner
        resb 54
awardstats4:                                    ; goalie season stats record of award 4's winner
        resb 54
awardstats8:                                    ; season stats record of award 8's winner
        resb 47
awardstats2:                                    ; season stats record of award 2's winner
        resb 47
awardstats1:                                    ; season stats record of award 1's winner
        resb 47
awardstats9:                                    ; skater season stats record of award 9's winner; used by
                                                ; PickAwardWinners
        resb 47
awardstats3:                                    ; season stats record of award 3's winner
        resb 47
awardstats0:                                    ; season stats record of award 0's winner (awardstatsptrs[0])
        resb 47
awardstats6:                                    ; season stats record of award 6's winner
        resb 48
photobanks:                                     ; 17h loaded .PPV player photo banks (LoadPlayerPhotos); used
                                                ; by EnsureFreeMemory, FreePhotoBanks, IndexPhotoBank ...
        resb 184
photoptrs:                                      ; 46Eh picture pointers, 50 per photo bank (IndexPhotoBank);
                                                ; used by DrawFrameSprite, IndexPhotoBank
        resb 4536
