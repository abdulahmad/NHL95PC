; Password prompts for a team and for the master controller.
bits 32
%include "hockey.inc"
section s_C82A5 progbits alloc noexec write align=1
global str_EnterPasswordFor, str_VerifyPasswordFor, str_EnterMasterPassword, str_EnterMasterControllerPasswor, str_VerifyMasterControllerPasswo, passkey, passkey_m1, str_January
global str_February, str_March, str_April, str_May, str_June, str_July, str_August, str_September
global str_October, str_November, str_December
str_EnterPasswordFor:                           ; string 'Enter password for '; used by AskTeamPassword,
                                                ; LeagueTeamSelect
        db 045h,06Eh,074h,065h,072h,020h,070h,061h,073h,073h,077h,06Fh,072h,064h,020h,066h
        db 06Fh,072h,020h,00h
str_VerifyPasswordFor:                          ; string 'Verify password for '; used by LeagueTeamSelect
        db 056h,065h,072h,069h,066h,079h,020h,070h,061h,073h,073h,077h,06Fh,072h,064h,020h
        db 066h,06Fh,072h,020h,00h
str_EnterMasterPassword:                        ; string ' enter master password.'; used by AskMasterPassword
        db 020h,065h,06Eh,074h,065h,072h,020h,06Dh,061h,073h,074h,065h,072h,020h,070h,061h
        db 073h,073h,077h,06Fh,072h,064h,02Eh,00h
str_EnterMasterControllerPasswor:               ; string 'Enter master controller password for '; used by
                                                ; ChooseLeagueController
        db 045h,06Eh,074h,065h,072h,020h,06Dh,061h,073h,074h,065h,072h,020h,063h,06Fh,06Eh
        db 074h,072h,06Fh,06Ch,06Ch,065h,072h,020h,070h,061h,073h,073h,077h,06Fh,072h,064h
        db 020h,066h,06Fh,072h,020h,00h
str_VerifyMasterControllerPasswo:               ; string 'Verify master controller password for '; used by
                                                ; ChooseLeagueController
        db 056h,065h,072h,069h,066h,079h,020h,06Dh,061h,073h,074h,065h,072h,020h,063h,06Fh
        db 06Eh,074h,072h,06Fh,06Ch,06Ch,065h,072h,020h,070h,061h,073h,073h,077h,06Fh,072h
        db 064h,020h,066h,06Fh,072h,020h
passkey_m1:                                     ; byte before the password key (backward XOR index); used by
                                                ; EncryptPassword
        db 00h
passkey:                                        ; "NHLHockey" password XOR key; used by EncryptPassword
        db 04Eh,048h,04Ch,048h,06Fh,063h,06Bh,065h,079h,00h
str_January:                                    ; "January" string literal
        db 04Ah,061h,06Eh,075h,061h,072h,079h,00h
str_February:                                   ; "February" string literal
        db 046h,065h,062h,072h,075h,061h,072h,079h,00h
str_March:                                      ; "March" string literal
        db 04Dh,061h,072h,063h,068h,00h
str_April:                                      ; "April" string literal
        db 041h,070h,072h,069h,06Ch,00h
str_May:                                        ; "May" string literal
        db 04Dh,061h,079h,00h
str_June:                                       ; "June" string literal
        db 04Ah,075h,06Eh,065h,00h
str_July:                                       ; "July" string literal
        db 04Ah,075h,06Ch,079h,00h
str_August:                                     ; "August" string literal
        db 041h,075h,067h,075h,073h,074h,00h
str_September:                                  ; "September" string literal
        db 053h,065h,070h,074h,065h,06Dh,062h,065h,072h,00h
str_October:                                    ; "October" string literal
        db 04Fh,063h,074h,06Fh,062h,065h,072h,00h
str_November:                                   ; "November" string literal
        db 04Eh,06Fh,076h,065h,06Dh,062h,065h,072h,00h
str_December:                                   ; "December" string literal
        db 044h,065h,063h,065h,06Dh,062h,065h,072h,00h
        dd str_January
        dd str_February
        dd str_March
        dd str_April
        dd str_May
        dd str_June
        dd str_July
        dd str_August
        dd str_September
        dd str_October
        dd str_November
        dd str_December
