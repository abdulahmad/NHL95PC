; Which game of the current series is about to be played.
bits 32
%include "hockey.inc"
section s_D29FB progbits alloc noexec write align=1
global seriesgameno, str_YourTeamHasBeen, str_FromThePlayOffs, str_WishToSeeThe, str_OfThePlayOffs, str_TheEliminated
seriesgameno:
        db 0FFh,0FFh,0FFh,0FFh
str_YourTeamHasBeen:
        db 059h,06Fh,075h,072h,020h,074h,065h,061h,06Dh,020h,068h,061h,073h,020h,062h,065h
        db 065h,06Eh,020h,065h,06Ch,069h,06Dh,069h,06Eh,061h,074h,065h,064h,00h
str_FromThePlayOffs:
        db 066h,072h,06Fh,06Dh,020h,074h,068h,065h,020h,070h,06Ch,061h,079h,02Dh,06Fh,066h
        db 066h,073h,02Eh,020h,044h,06Fh,020h,079h,06Fh,075h,00h
str_WishToSeeThe:
        db 077h,069h,073h,068h,020h,074h,06Fh,020h,073h,065h,065h,020h,074h,068h,065h,020h
        db 066h,069h,06Eh,061h,06Ch,020h,072h,065h,073h,075h,06Ch,074h,073h,00h
str_OfThePlayOffs:
        db 06Fh,066h,020h,074h,068h,065h,020h,070h,06Ch,061h,079h,02Dh,06Fh,066h,066h,073h
        db 03Fh,00h
str_TheEliminated:
        db 054h,068h,065h,020h
