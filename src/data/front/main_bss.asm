; BSS of front/main (src/front/main).
bits 32
%include "hockey.inc"
section s_D8B68 nobits alloc noexec write align=1
global kaufmfont, pntrshapes, scor2font, mainfont, scor3font, joyrawbits, joyqueue, numshapes
global spritedrawcount, gfxidlist
kaufmfont:                                      ; handle from OpenArtArchiveErr for kaufm020.vfn loaded in
                                                ; main startup; used by AwardsCeremony, DrawCreatePlayer,
                                                ; DrawLockerJersey ...
        resb 4
pntrshapes:                                     ; handle from LoadBank for the pointer shape file; pointerspr
                                                ; is taken from it ('pntr'); used by main_
        resb 4
scor2font:                                      ; handle from OpenArtArchiveErr for scor2b.vfn; used by
                                                ; DrawCallBanner, DrawTextOverlay, FormatPlayerName ...
        resb 4
mainfont:                                       ; copy of the s1.vfn font handle; passed to TextSetFont by
                                                ; locker room, stats, save dialogs; used by CalendarScreen,
                                                ; DrawCreatePlayer, DrawLockerJersey ...
        resb 4
scor3font:                                      ; handle from OpenArtArchiveErr for scor3b.vfn loaded in main
                                                ; startup; used by DrawCallBanner, DrawTextOverlay, main_
        resb 4
joyrawbits:                                     ; joystick bits sampled by ReadJoyRaw (low byte joystick 1,
                                                ; high byte joystick 2); used by ReadJoyPad, SampleInputTick
        resb 4
joyqueue:                                       ; input queue: 50 records of 3 bytes (pad 1, pad 2, flags;
                                                ; flags bit 7 = key event), filled by the timer ISR; used by
                                                ; SampleInputTick, joyq_peek
        resb 152
numshapes:                                      ; 10 number shape pointers "0000".."0009" in numshpbank
                                                ; (LoadGameGfx); used by DrawSpriteNumber, LoadGameGfx,
                                                ; ReloadGameGfx
        resb 40
spritedrawcount:                                ; incremented per DrawSprite, reset per frame; used by
                                                ; DrawCallBanner, DrawSprite, DrawTextOverlay ...
        resb 12
gfxidlist:                                      ; graphics id list loaded by LoadGameGfx; DrawSpriteNumber
                                                ; takes the suffix sprite from it; used by DrawSpriteNumber,
                                                ; LoadGameGfx_common
        resb 28
