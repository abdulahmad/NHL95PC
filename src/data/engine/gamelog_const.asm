; Strings and constants of engine/gamelog (src/engine/gamelog), in link order.
bits 32
%include "hockey.inc"
section s_C1B49 progbits alloc noexec write align=1
global str_NoPenalty, str_Charging, str_Slashing, str_CrossChecking, str_Hooking, str_Tripping, str_Interference, str_Holding
global str_HighSticking, str_Boarding, str_Elbowing, str_AbuseOfOfficial, str_CheckingFromBehind, str_PenaltyShot2, str_Roughing, str_Charging2
global str_Slashing2, str_Xcheck, str_Hooking2, str_Tripping2, str_Interfer, str_Holding2, str_Histick, str_Boarding2
global str_Elbowing2, str_Abuse, str_Checkbnd, str_Penshot, str_B3, str_B4, str_B5, str_B6
global str_B7, str_B8, str_FmtNumFirstLast, str_FmtNumInitialLast, str_FmtNumNameSuffix, str_FmtNumName, str_FmtClockEvent, str_PPTag
global str_SHTag, str_S8, str_FmtParenD, str_Unassisted, str_Assists, str_PenaltyShot, str_ToBeTakenBy, str_02d02dSPenalty
global str_GameMisconduct, str_DMinutes, str_02d02dSInjury, str_GoneForTheGame, str_GoneFor1Period, str_ServedByD, str_BnReturnGoalie, str_BnPullGoalie
global str_BnFaceOff, str_BnTwoLinePass, str_BnOffside, str_BnIcing, str_BnPenalty, str_BnPenaltyShot
str_NoPenalty:                                  ; Empty penalty name in the penalty name list; used by
                                                ; BuildEventLines
        db 00h
str_Charging:                                   ; "Charging" string literal
        db 043h,068h,061h,072h,067h,069h,06Eh,067h,00h
str_Slashing:                                   ; "Slashing" string literal
        db 053h,06Ch,061h,073h,068h,069h,06Eh,067h,00h
str_CrossChecking:                              ; "CrossChecking" string literal
        db 043h,072h,06Fh,073h,073h,043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_Hooking:                                    ; "Hooking" string literal
        db 048h,06Fh,06Fh,06Bh,069h,06Eh,067h,00h
str_Tripping:                                   ; "Tripping" string literal
        db 054h,072h,069h,070h,070h,069h,06Eh,067h,00h
str_Interference:                               ; "Interference" string literal
        db 049h,06Eh,074h,065h,072h,066h,065h,072h,065h,06Eh,063h,065h,00h
str_Holding:                                    ; "Holding" string literal
        db 048h,06Fh,06Ch,064h,069h,06Eh,067h,00h
str_HighSticking:                               ; "HighSticking" string literal
        db 048h,069h,067h,068h,053h,074h,069h,063h,06Bh,069h,06Eh,067h,00h
str_Boarding:                                   ; "Boarding" string literal
        db 042h,06Fh,061h,072h,064h,069h,06Eh,067h,00h
str_Elbowing:                                   ; "Elbowing" string literal
        db 045h,06Ch,062h,06Fh,077h,069h,06Eh,067h,00h
str_AbuseOfOfficial:                            ; "Abuse of Official" string literal
        db 041h,062h,075h,073h,065h,020h,06Fh,066h,020h,04Fh,066h,066h,069h,063h,069h,061h
        db 06Ch,00h
str_CheckingFromBehind:                         ; "Checking from Behind" string literal
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,020h,066h,072h,06Fh,06Dh,020h,042h,065h
        db 068h,069h,06Eh,064h,00h
str_PenaltyShot2:                               ; "Penalty Shot" string literal
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,053h,068h,06Fh,074h,00h
str_Roughing:                                   ; "roughing" string literal
        db 072h,06Fh,075h,067h,068h,069h,06Eh,067h,00h
str_Charging2:                                  ; "charging" string literal
        db 063h,068h,061h,072h,067h,069h,06Eh,067h,00h
str_Slashing2:                                  ; "slashing" string literal
        db 073h,06Ch,061h,073h,068h,069h,06Eh,067h,00h
str_Xcheck:                                     ; "xcheck" string literal
        db 078h,063h,068h,065h,063h,06Bh,00h
str_Hooking2:                                   ; "hooking" string literal
        db 068h,06Fh,06Fh,06Bh,069h,06Eh,067h,00h
str_Tripping2:                                  ; "tripping" string literal
        db 074h,072h,069h,070h,070h,069h,06Eh,067h,00h
str_Interfer:                                   ; "interfer" string literal
        db 069h,06Eh,074h,065h,072h,066h,065h,072h,00h
str_Holding2:                                   ; "holding" string literal
        db 068h,06Fh,06Ch,064h,069h,06Eh,067h,00h
str_Histick:                                    ; "histick" string literal
        db 068h,069h,073h,074h,069h,063h,06Bh,00h
str_Boarding2:                                  ; "boarding" string literal
        db 062h,06Fh,061h,072h,064h,069h,06Eh,067h,00h
str_Elbowing2:                                  ; "elbowing" string literal
        db 065h,06Ch,062h,06Fh,077h,069h,06Eh,067h,00h
str_Abuse:                                      ; "abuse" string literal
        db 061h,062h,075h,073h,065h,00h
str_Checkbnd:                                   ; "checkbnd" string literal
        db 063h,068h,065h,063h,06Bh,062h,06Eh,064h,00h
str_Penshot:                                    ; "penshot" string literal
        db 070h,065h,06Eh,073h,068h,06Fh,074h,00h
str_B3:                                         ; string 'B3'; used by AppendGSumRecord, ReadGSumHeader,
                                                ; ReadGSumTail ...
        db 042h,033h,00h
str_B4:                                         ; string 'B4'; used by AppendGSumRecord, WriteGSumHeader,
                                                ; fileio_tail_a
        db 042h,034h,00h
str_B5:                                         ; string 'B5'; used by AppendGSumRecord, WriteGSumHeader
        db 042h,035h,00h
str_B6:                                         ; string 'B6'; used by AppendGSumRecord, ReadGSumTail,
                                                ; WriteGSumHeader
        db 042h,036h,00h
str_B7:                                         ; string 'B7'; used by AppendGSumRecord
        db 042h,037h,00h
str_B8:                                         ; string 'B8'; used by AppendGSumRecord, WriteGSumHeader
        db 042h,038h,00h
str_FmtNumFirstLast:                            ; string '%s#%d %s %s%s'; used by FormatPlayerName
        db 025h,073h,023h,025h,064h,020h,025h,073h,020h,025h,073h,025h,073h,00h
str_FmtNumInitialLast:                          ; string '%s#%d %c. %s%s'; used by FormatPlayerName
        db 025h,073h,023h,025h,064h,020h,025h,063h,02Eh,020h,025h,073h,025h,073h,00h
str_FmtNumNameSuffix:                           ; string '%s#%d %s%s'; used by FormatPlayerName
        db 025h,073h,023h,025h,064h,020h,025h,073h,025h,073h,00h
str_FmtNumName:                                 ; string '%s#%d %s'; used by FormatPlayerName
        db 025h,073h,023h,025h,064h,020h,025h,073h,00h
str_FmtClockEvent:                              ; string '%02d:%02d %s'; used by BuildEventLines
        db 025h,030h,032h,064h,03Ah,025h,030h,032h,064h,020h,025h,073h,00h
str_PPTag:                                      ; string ' PP'; used by BuildEventLines
        db 020h,050h,050h,00h
str_SHTag:                                      ; string ' SH'; used by BuildEventLines
        db 020h,053h,048h,00h
str_S8:                                         ; string '%s'; used by BuildEventLines
        db 025h,073h,00h
str_FmtParenD:                                  ; string ' (%d)'; used by BuildEventLines
        db 020h,028h,025h,064h,029h,00h
str_Unassisted:                                 ; string 'Unassisted'; used by BuildEventLines
        db 055h,06Eh,061h,073h,073h,069h,073h,074h,065h,064h,00h
str_Assists:                                    ; string 'Assists:'; used by BuildEventLines
        db 041h,073h,073h,069h,073h,074h,073h,03Ah,00h
str_PenaltyShot:                                ; string 'Penalty shot'; used by BuildEventLines
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,073h,068h,06Fh,074h,00h
str_ToBeTakenBy:                                ; string 'to be taken by'; used by BuildEventLines
        db 074h,06Fh,020h,062h,065h,020h,074h,061h,06Bh,065h,06Eh,020h,062h,079h,00h
str_02d02dSPenalty:                             ; string '%02d:%02d %s Penalty'; used by BuildEventLines
        db 025h,030h,032h,064h,03Ah,025h,030h,032h,064h,020h,025h,073h,020h,050h,065h,06Eh
        db 061h,06Ch,074h,079h,00h
str_GameMisconduct:                             ; string 'game misconduct'; used by BuildEventLines
        db 067h,061h,06Dh,065h,020h,06Dh,069h,073h,063h,06Fh,06Eh,064h,075h,063h,074h,00h
str_DMinutes:                                   ; string '%d minutes'; used by BuildEventLines
        db 025h,064h,020h,06Dh,069h,06Eh,075h,074h,065h,073h,00h
str_02d02dSInjury:                              ; string '%02d:%02d %s Injury'; used by BuildEventLines
        db 025h,030h,032h,064h,03Ah,025h,030h,032h,064h,020h,025h,073h,020h,049h,06Eh,06Ah
        db 075h,072h,079h,00h
str_GoneForTheGame:                             ; string 'gone for the game'; used by BuildEventLines
        db 067h,06Fh,06Eh,065h,020h,066h,06Fh,072h,020h,074h,068h,065h,020h,067h,061h,06Dh
        db 065h,00h
str_GoneFor1Period:                             ; string 'gone for 1 period'; used by BuildEventLines
        db 067h,06Fh,06Eh,065h,020h,066h,06Fh,072h,020h,031h,020h,070h,065h,072h,069h,06Fh
        db 064h,00h,00h,00h,00h
str_ServedByD:                                  ; string 'served by #%d'; used by InProgress
        db 073h,065h,072h,076h,065h,064h,020h,062h,079h,020h,023h,025h,064h,00h,00h,00h
str_BnReturnGoalie:                             ; string 'RETURN GOALIE'
        db 052h,045h,054h,055h,052h,04Eh,020h,047h,04Fh,041h,04Ch,049h,045h,00h
str_BnPullGoalie:                               ; string 'PULL GOALIE'
        db 050h,055h,04Ch,04Ch,020h,047h,04Fh,041h,04Ch,049h,045h,00h
str_BnFaceOff:                                  ; string 'FACE-OFF'
        db 046h,041h,043h,045h,02Dh,04Fh,046h,046h,00h
str_BnTwoLinePass:                              ; string '2 LINE PASS'
        db 032h,020h,04Ch,049h,04Eh,045h,020h,050h,041h,053h,053h,00h
str_BnOffside:                                  ; string 'OFFSIDE'
        db 04Fh,046h,046h,053h,049h,044h,045h,00h
str_BnIcing:                                    ; string 'ICING'
        db 049h,043h,049h,04Eh,047h,00h
str_BnPenalty:                                  ; string 'PENALTY'
        db 050h,045h,04Eh,041h,04Ch,054h,059h,00h
str_BnPenaltyShot:                              ; string 'PENALTY SHOT'
        db 050h,045h,04Eh,041h,04Ch,054h,059h,020h,053h,048h,04Fh,054h,00h
