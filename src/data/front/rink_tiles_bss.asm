; BSS of front/rink_tiles (src/front/rink_tiles).
bits 32
%include "hockey.inc"
section s_DD6A8 nobits alloc noexec write align=1
global rinkwtiles, scrolly, scrollx, rinkhtiles, bgscrolly, bgscrollx
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
