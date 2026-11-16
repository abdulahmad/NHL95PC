; Messages for creating a player and for moving players to the free-agent list.
bits 32
%include "hockey.inc"
section s_D0C5C progbits alloc noexec write align=1
extern str_Cancel6, str_Create, str_Yes, str_No4
global str_ThereIsNoSpace, str_TheSelectedPlayer, str_NotEnoughSpaceTo2, str_AddAllSelectedPlayers, str_ErrorWhileMakingNew, str_NewPlayer, str_NotAddedToDatabases, str_Move
global str_ToFreeAgentList, str_CreateAPlayerOr, PosBitMasks, str_Two, str_Continue, str_Stop2, btn_DBError, str_Player4
global str_Goalie3, btn_CreateFreeAgent
str_Two:
        db 032h,00h,00h,00h,0B8h,01h,00h,00h,03Fh,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Cancel6
        db 0Fh,02h,00h,00h,0B8h,01h,00h,00h,03Fh,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Create
str_Continue:
        db 043h,06Fh,06Eh,074h,069h,06Eh,075h,065h,00h
str_Stop2:
        db 053h,074h,06Fh,070h,00h
btn_DBError:
        db 014h,00h,00h,00h,0C2h,01h,00h,00h,050h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Continue
        db 01Ch,02h,00h,00h,0C2h,01h,00h,00h,050h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Stop2
PosBitMasks:
        db 01h,00h,00h,00h,02h,00h,00h,00h,04h,00h,00h,00h,08h,00h,00h,00h
        db 010h,00h,00h,00h,020h,00h,00h,00h,040h,00h,00h,00h,080h,00h,00h,00h
        db 00h,01h,00h,00h,00h,02h,00h,00h,046h,072h,065h,065h,020h,041h,067h,065h
        db 06Eh,074h,020h,050h,06Ch,061h,079h,065h,072h,073h,00h,077h,069h,06Ch,06Ch,020h
        db 062h,065h,020h,064h,065h,06Ch,065h,074h,065h,064h,02Eh,00h,043h,06Fh,06Eh,074h
        db 069h,06Eh,075h,065h,03Fh,00h,08h,00h,00h,00h,03Ch,00h,00h,00h,025h,00h
        db 00h,00h,014h,00h,00h,00h,00h,00h,00h,00h,05h,00h,00h,00h
        dd str_No4
        db 0F8h,0FFh,0FFh,0FFh,03Ch,00h,00h,00h,025h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Yes
str_ThereIsNoSpace:
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,020h,073h,070h,061h,063h
        db 065h,020h,074h,06Fh,020h,061h,064h,064h,00h
str_TheSelectedPlayer:
        db 074h,068h,065h,020h,073h,065h,06Ch,065h,063h,074h,065h,064h,020h,070h,06Ch,061h
        db 079h,065h,072h,00h
str_NotEnoughSpaceTo2:
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 075h,067h,068h,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,00h
str_AddAllSelectedPlayers:
        db 061h,064h,064h,020h,061h,06Ch,06Ch,020h,073h,065h,06Ch,065h,063h,074h,065h,064h
        db 020h,070h,06Ch,061h,079h,065h,072h,073h,00h,04Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 075h,067h,068h,074h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,00h
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,074h,020h,06Dh,065h,06Dh,06Fh
        db 072h,079h,00h,074h,06Fh,020h,064h,065h,06Ch,065h,074h,065h,020h,070h,06Ch,061h
        db 079h,065h,072h,073h,021h,00h,074h,06Fh,020h,061h,064h,064h,020h,070h,06Ch,061h
        db 079h,065h,072h,073h,021h,00h
str_ErrorWhileMakingNew:
        db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,06Dh,061h,06Bh,069h
        db 06Eh,067h,020h,06Eh,065h,077h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h
        db 021h,00h
str_NewPlayer:
        db 04Eh,065h,077h,020h,070h,06Ch,061h,079h,065h,072h,00h
str_NotAddedToDatabases:
        db 020h,06Eh,06Fh,074h,020h,061h,064h,064h,065h,064h,020h,074h,06Fh,020h,064h,061h
        db 074h,061h,062h,061h,073h,065h,073h,021h,00h,050h,06Ch,061h,079h,065h,072h,020h
        db 06Eh,06Fh,074h,020h,064h,065h,06Ch,065h,074h,065h,064h,020h,066h,072h,06Fh,06Dh
        db 020h,064h,061h,074h,061h,062h,061h,073h,065h,073h,021h,00h
str_Move:
        db 04Dh,06Fh,076h,065h,00h
str_ToFreeAgentList:
        db 074h,06Fh,020h,046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,020h,04Ch,069h
        db 073h,074h,03Fh,00h,074h,06Fh,020h,052h,06Fh,073h,074h,065h,072h,020h,031h,03Fh
        db 00h,074h,06Fh,020h,052h,06Fh,073h,074h,065h,072h,020h,032h,03Fh,00h
str_CreateAPlayerOr:
        db 043h,072h,065h,061h,074h,065h,020h,061h,020h,070h,06Ch,061h,079h,065h,072h,020h
        db 06Fh,072h,020h,067h,06Fh,061h,06Ch,069h,065h,02Eh,00h
str_Player4:
        db 050h,06Ch,061h,079h,065h,072h,00h
str_Goalie3:
        db 047h,06Fh,061h,06Ch,069h,065h,00h
btn_CreateFreeAgent:
        db 08h,00h,00h,00h,01Ch,00h,00h,00h,048h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Player4
        db 0F8h,0FFh,0FFh,0FFh,01Ch,00h,00h,00h,048h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Goalie3
