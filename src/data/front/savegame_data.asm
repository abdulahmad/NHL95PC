; Initialised data of front/savegame (src/front/savegame).
bits 32
%include "hockey.inc"
section s_D27EF progbits alloc noexec write align=1
extern str_LeagueGame, str_PlayOffGame, str_SavingCurrent
global msg_SavingLeagueGame, msg_SavingPlayoffGame, str_InsufficientDiskSpaceTo3, str_AGameYouRequire3, str_OfFreeDiskSpace2, msg_NoSaveSpace
msg_SavingLeagueGame:                           ; 'Saving Current' / 'League Game.'; used by MenuSaveGame
        dd str_SavingCurrent
        dd str_LeagueGame
msg_SavingPlayoffGame:                          ; 'Saving Current' / 'Play-Off Game.'; used by MenuSaveGame
        dd str_SavingCurrent
        dd str_PlayOffGame
str_InsufficientDiskSpaceTo3:                   ; "Insufficient disk space to save" string literal
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,020h,073h,061h,076h,065h,00h
str_AGameYouRequire3:                           ; string 'a game, you require XXX Kbytes '; used by
                                                ; MenuSaveGame
        db 061h,020h,067h,061h,06Dh,065h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h
        db 069h,072h,065h,020h,058h,058h,058h,020h,04Bh,062h,079h,074h,065h,073h,020h,020h
        db 020h,00h
str_OfFreeDiskSpace2:                           ; "of free disk space." string literal
        db 06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h
        db 063h,065h,02Eh,00h
msg_NoSaveSpace:                                ; 'Insufficient disk space to save' / 'a game, you require XXX
                                                ; Kbytes' / 'of free disk space.'; used by MenuSaveGame
        dd str_InsufficientDiskSpaceTo3
        dd str_AGameYouRequire3
        dd str_OfFreeDiskSpace2
        db 00h,00h,00h
