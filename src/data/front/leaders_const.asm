; Strings and constants of front/leaders (src/front/leaders), in link order.
bits 32
%include "hockey.inc"
section s_C1211 progbits alloc noexec write align=1
global str_Keys, str_Pstat, str_Gstat, str_Addsort2, str_KeyDb2, str_Pstatbar7, str_Pst26, str_StatsUnavailable2
global str_POS, str_NO, str_PLAYER2, str_TEAM, str_GP6, str_C2, str_LSSCEDDB, str_SCHEDULEDB3
str_Keys:                                       ; string 'keys'; used by LeadersScreen
        db 06Bh,065h,079h,073h,00h
str_Pstat:                                      ; string 'pstat'; used by LeadersScreen
        db 070h,073h,074h,061h,074h,00h
str_Gstat:                                      ; string 'gstat'; used by LeadersScreen
        db 067h,073h,074h,061h,074h,00h
str_Addsort2:                                   ; string 'addsort'; used by LeadersScreen
        db 061h,064h,064h,073h,06Fh,072h,074h,00h
str_KeyDb2:                                     ; string 'key.db'; used by LeadersScreen
        db 06Bh,065h,079h,02Eh,064h,062h,00h
str_Pstatbar7:                                  ; string 'pstatbar'; used by LeadersScreen
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst26:                                      ; string 'pst2'; used by LeadersScreen
        db 070h,073h,074h,032h,00h
str_StatsUnavailable2:                          ; string 'Stats Unavailable'; used by LeadersScreen
        db 053h,074h,061h,074h,073h,020h,055h,06Eh,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_POS:                                        ; string 'POS'; used by LeadersScreen
        db 050h,04Fh,053h,00h
str_NO:                                         ; string 'NO'; used by LeadersScreen
        db 04Eh,04Fh,00h
str_PLAYER2:                                    ; string 'PLAYER'; used by LeadersScreen
        db 050h,04Ch,041h,059h,045h,052h,00h
str_TEAM:                                       ; string 'TEAM'; used by LeadersScreen
        db 054h,045h,041h,04Dh,00h
str_GP6:                                        ; string 'GP'; used by LeadersScreen
        db 047h,050h,00h
str_C2:                                         ; string '%c'; used by LeadersScreen
        db 025h,063h,00h,00h,00h
str_LSSCEDDB:                                   ; "LSSCED.DB" string literal
        db 04Ch,053h,053h,043h,045h,044h,02Eh,044h,042h,00h
str_SCHEDULEDB3:                                ; "SCHEDULE.DB" string literal
        db 053h,043h,048h,045h,044h,055h,04Ch,045h,02Eh,044h,042h,00h
