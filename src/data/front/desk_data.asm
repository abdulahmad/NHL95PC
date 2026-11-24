; Initialised data of front/desk (src/front/desk).
bits 32
%include "hockey.inc"
section s_C65F4 progbits alloc noexec write align=1
extern NullBlit, VgaBlitKeyed, VgaBlitKeyedFlipH, VgaBlitKeyedFlipHV, VgaBlitKeyedFlipV, VgaBlitRemap, VgaBlitRemapFlipH, VgaBlitRemapFlipHV
extern VgaBlitRemapFlipV
global hlplayedmask, str_ReturningToSportsCentral, str_ReturningOutOfThe, str_ReturningToThePlayoff, str_ExitingTheGame, str_MayLoseThisGame, str_DoYouWishToReturn, str_DoYouWishToExit
global msg_DeskExit, msg_DeskExit_e02, CdStreamRateFactor, RosterStatusByInjury, screenbm, dirtyrectcount, DeskRedrawAll, DeskRedrawFlag
hlplayedmask:                                   ; bits of the 6 highlights already shown (PlayRandomHighlight,
                                                ; IntermissionDesk); used by IntermissionDesk,
                                                ; PlayRandomHighlight
        db 00h,00h,00h,00h
str_ReturningToSportsCentral:                   ; string 'Returning to sports central'; used by
                                                ; DeskReturnConfirm
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,074h,06Fh,020h,073h,070h,06Fh
        db 072h,074h,073h,020h,063h,065h,06Eh,074h,072h,061h,06Ch,00h
str_ReturningOutOfThe:                          ; string 'Returning out of the game'; used by
                                                ; DeskReturnConfirm
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,06Fh,075h,074h,020h,06Fh,066h
        db 020h,074h,068h,065h,020h,067h,061h,06Dh,065h,00h
str_ReturningToThePlayoff:                      ; string 'Returning to the playoff tree'; used by
                                                ; DeskReturnConfirm
        db 052h,065h,074h,075h,072h,06Eh,069h,06Eh,067h,020h,074h,06Fh,020h,074h,068h,065h
        db 020h,070h,06Ch,061h,079h,06Fh,066h,066h,020h,074h,072h,065h,065h,00h
str_ExitingTheGame:                             ; string 'Exiting the game'; used by DeskExitGame
        db 045h,078h,069h,074h,069h,06Eh,067h,020h,074h,068h,065h,020h,067h,061h,06Dh,065h
        db 00h
str_MayLoseThisGame:                            ; "may lose this game's data." string literal
        db 06Dh,061h,079h,020h,06Ch,06Fh,073h,065h,020h,074h,068h,069h,073h,020h,067h,061h
        db 06Dh,065h,027h,073h,020h,064h,061h,074h,061h,02Eh,00h
str_DoYouWishToReturn:                          ; string 'Do you wish to return?'; used by DeskReturnConfirm
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,072h
        db 065h,074h,075h,072h,06Eh,03Fh,00h
str_DoYouWishToExit:                            ; string 'Do you wish to exit?'; used by DeskExitGame
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,065h
        db 078h,069h,074h,03Fh,00h
msg_DeskExit:                                   ; DeskExitGame / DeskReturnConfirm message lines; line 0 is
                                                ; patched; used by DeskExitGame, DeskReturnConfirm
        db 00h,00h,00h,00h
        dd str_MayLoseThisGame
msg_DeskExit_e02:                               ; msg_DeskExit[2], patched with 'Do you wish to exit /
                                                ; return'; used by DeskExitGame, DeskReturnConfirm
        db 00h,00h,00h,00h
CdStreamRateFactor:                             ; Rate factor (0Dh) the CD stream code scales its read sizes
                                                ; by; used by CdStreamCreate, CdStreamService
        db 0Dh,00h,00h,00h
RosterStatusByInjury:                           ; Roster status code per injury value (word entries) used by
                                                ; LoadTeamRoster
        db 07h,00h,04h,00h,03h,00h,06h,00h,01h,00h,08h,00h,02h,00h,00h,00h
screenbm:                                       ; pointer to the screen bitmap descriptor (set in main_
                                                ; startup), selected by SelectScreenBM; used by
                                                ; SelectScreenBM, main_
        db 00h,00h,00h,00h
dirtyrectcount:                                 ; per-page rect count; used by AddDirtyRect
        db 00h,00h,00h,00h,00h,00h,00h,00h
DeskRedrawAll:                                  ; Flag set when the desk and replay screens must be redrawn in
                                                ; full; used by DeskGoToReplay, DeskReloadGame,
                                                ; DeskReturnConfirm ...
        db 00h,00h,00h,00h
DeskRedrawFlag:                                 ; Flag set after the desk photos load and fade in so the desk
                                                ; redraws; used by DeskGoToReplay, DeskReloadGame,
                                                ; DeskReturnConfirm ...
        db 00h,00h,00h,00h
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd NullBlit
        dd VgaBlitKeyed
        dd VgaBlitKeyedFlipV
        dd VgaBlitRemap
        dd VgaBlitRemapFlipV
        dd VgaBlitKeyedFlipH
        dd VgaBlitKeyedFlipHV
        dd VgaBlitRemapFlipH
        dd VgaBlitRemapFlipHV
