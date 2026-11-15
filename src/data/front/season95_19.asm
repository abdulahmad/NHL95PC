; The prompts when one team is human, and when every team is.
bits 32
%include "hockey.inc"
section s_C750F progbits alloc noexec write align=1
extern str_AllTheTeamsAre
global msg_OneHuman, msg_AllHuman, str_ThereIsOnlyOne, str_ControlledTeam, str_CanNotReadDatabases
msg_AllHuman:
        dd str_AllTheTeamsAre
str_ThereIsOnlyOne:
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Fh,06Eh,06Ch,079h,020h,06Fh,06Eh
        db 065h,020h,068h,075h,06Dh,061h,06Eh,00h
str_ControlledTeam:
        db 063h,06Fh,06Eh,074h,072h,06Fh,06Ch,06Ch,065h,064h,020h,074h,065h,061h,06Dh,021h
        db 00h
msg_OneHuman:
        dd str_ThereIsOnlyOne
        dd str_ControlledTeam
str_CanNotReadDatabases:
        db 043h,061h,06Eh,020h,06Eh,06Fh,074h,020h,072h,065h,061h,064h,020h,064h,061h,074h
        db 061h,062h,061h,073h,065h,073h,020h,069h,06Eh,020h,074h,068h,065h,020h,06Ch,065h
        db 061h,067h,075h,065h,00h
