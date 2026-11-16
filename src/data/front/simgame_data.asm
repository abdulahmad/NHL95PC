; The shuffled line orders used when a game is simulated, and whether the loading picture is up.
bits 32
%include "hockey.inc"
section s_C900C progbits alloc noexec write align=1
global simfwdorder, simdorder, loadscreenon
simfwdorder:                                    ; 20 dword forward-line orders (0..3) shuffled by
                                                ; SimulateGame; used by SimulateGame
        db 00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h
        db 00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h
        db 01h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h
        db 02h,00h,00h,00h,03h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h
        db 02h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h
simdorder:                                      ; 6 dword defence-pair orders (0..2) shuffled by SimulateGame;
                                                ; used by SimulateGame
        db 00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h
        db 01h,00h,00h,00h,02h,00h,00h,00h
loadscreenon:                                   ; loading screen already shown; used by FadeOutPalCycle,
                                                ; ShowLoadingScreen
        db 00h,00h,00h,00h
