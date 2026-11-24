; Strings and constants of front/scoreboard (src/front/scoreboard), in link order.
bits 32
%include "hockey.inc"
section s_C064C progbits alloc noexec write align=1
global str_ErrDiskFree4, str_ErrDiskFree5, str_GsummaryDb, str_NeedKbytesFmt, str_3000, str_3001, str_3002, str_3003
global str_3004, str_3005, str_3006, str_3007, str_3008, str_3009, str_300, str_OT2
global str_BOS, str_BUF3, str_CGY, str_CHI, str_DET, str_EDM, str_HFD, str_LA
global str_DAL, str_MTL, str_NJ, str_NYI, str_NYR, str_OTT, str_PHI, str_PIT
global str_QUE, str_STL, str_SJ, str_TB, str_TOR, str_VAN, str_WSH, str_WPG
global str_ANA3, str_FLA, str_ASW, str_ASE, str_Scrbrd2, str_Srb3, str_Crests4, str_Stanley
global CreditBlankTitle, str_Credit19, str_Credit10, str_Credit09, str_Credit17, str_Credit01, str_Credit15, str_Credit12
global str_Credit08, str_Credit02, str_Credit11, str_Credit05, str_Credit06, str_Credit07, str_Credit18, str_Credit14
global str_Credit13, str_Credit16, str_Credit00, str_Credit04, str_Credit03
str_ErrDiskFree4:                               ; string 'error getting disk space free\n'; used by
                                                ; DiskSpaceShort
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_ErrDiskFree5:                               ; string 'error getting disk space free\n'; used by
                                                ; CheckGameDiskSpace
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_GsummaryDb:                                 ; string 'gsummary.db'; used by CheckGameDiskSpace
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,02Eh,064h,062h,00h
str_NeedKbytesFmt:                              ; string 'play the game, you require %2d Kbytes'; used by
                                                ; CheckGameDiskSpace
        db 070h,06Ch,061h,079h,020h,074h,068h,065h,020h,067h,061h,06Dh,065h,02Ch,020h,079h
        db 06Fh,075h,020h,072h,065h,071h,075h,069h,072h,065h,020h,025h,032h,064h,020h,04Bh
        db 062h,079h,074h,065h,073h,00h
str_3000:                                       ; string '3000'
        db 033h,030h,030h,030h,00h
str_3001:                                       ; string '3001'
        db 033h,030h,030h,031h,00h
str_3002:                                       ; string '3002'
        db 033h,030h,030h,032h,00h
str_3003:                                       ; string '3003'
        db 033h,030h,030h,033h,00h
str_3004:                                       ; string '3004'
        db 033h,030h,030h,034h,00h
str_3005:                                       ; string '3005'
        db 033h,030h,030h,035h,00h
str_3006:                                       ; string '3006'
        db 033h,030h,030h,036h,00h
str_3007:                                       ; string '3007'
        db 033h,030h,030h,037h,00h
str_3008:                                       ; string '3008'
        db 033h,030h,030h,038h,00h
str_3009:                                       ; string '3009'
        db 033h,030h,030h,039h,00h
str_300:                                        ; string '300 '
        db 033h,030h,030h,020h,00h
str_OT2:                                        ; "OT " string literal
        db 04Fh,054h,020h,020h,00h
str_BOS:                                        ; "BOS " string literal
        db 042h,04Fh,053h,020h,00h
str_BUF3:                                       ; "BUF " string literal
        db 042h,055h,046h,020h,00h
str_CGY:                                        ; "CGY " string literal
        db 043h,047h,059h,020h,00h
str_CHI:                                        ; "CHI " string literal
        db 043h,048h,049h,020h,00h
str_DET:                                        ; "DET " string literal
        db 044h,045h,054h,020h,00h
str_EDM:                                        ; "EDM " string literal
        db 045h,044h,04Dh,020h,00h
str_HFD:                                        ; "HFD " string literal
        db 048h,046h,044h,020h,00h
str_LA:                                         ; "LA " string literal
        db 04Ch,041h,020h,020h,00h
str_DAL:                                        ; "DAL " string literal
        db 044h,041h,04Ch,020h,00h
str_MTL:                                        ; "MTL " string literal
        db 04Dh,054h,04Ch,020h,00h
str_NJ:                                         ; "NJ " string literal
        db 04Eh,04Ah,020h,020h,00h
str_NYI:                                        ; "NYI " string literal
        db 04Eh,059h,049h,020h,00h
str_NYR:                                        ; "NYR " string literal
        db 04Eh,059h,052h,020h,00h
str_OTT:                                        ; "OTT " string literal
        db 04Fh,054h,054h,020h,00h
str_PHI:                                        ; "PHI " string literal
        db 050h,048h,049h,020h,00h
str_PIT:                                        ; "PIT " string literal
        db 050h,049h,054h,020h,00h
str_QUE:                                        ; "QUE " string literal
        db 051h,055h,045h,020h,00h
str_STL:                                        ; "STL " string literal
        db 053h,054h,04Ch,020h,00h
str_SJ:                                         ; "SJ " string literal
        db 053h,04Ah,020h,020h,00h
str_TB:                                         ; "TB " string literal
        db 054h,042h,020h,020h,00h
str_TOR:                                        ; "TOR " string literal
        db 054h,04Fh,052h,020h,00h
str_VAN:                                        ; "VAN " string literal
        db 056h,041h,04Eh,020h,00h
str_WSH:                                        ; "WSH " string literal
        db 057h,053h,048h,020h,00h
str_WPG:                                        ; "WPG " string literal
        db 057h,050h,047h,020h,00h
str_ANA3:                                       ; "ANA " string literal
        db 041h,04Eh,041h,020h,00h
str_FLA:                                        ; "FLA " string literal
        db 046h,04Ch,041h,020h,00h
str_ASW:                                        ; "ASW " string literal
        db 041h,053h,057h,020h,00h
str_ASE:                                        ; "ASE " string literal
        db 041h,053h,045h,020h,00h
str_Scrbrd2:                                    ; string 'scrbrd2'; used by DrawHudPanel
        db 073h,063h,072h,062h,072h,064h,032h,00h
str_Srb3:                                       ; string 'srb3'; used by DrawHudPanel
        db 073h,072h,062h,033h,00h
str_Crests4:                                    ; string 'crests4'; used by DrawHudPanel
        db 063h,072h,065h,073h,074h,073h,034h,00h,00h,00h,00h
str_Stanley:                                    ; string 'Stanley'; used by LoadCupFinalSeries
        db 053h,074h,061h,06Eh,06Ch,065h,079h,00h
CreditBlankTitle:                               ; Empty string used as the title line of credit pages that
                                                ; have no title art
        db 00h,00h
str_Credit19:                                   ; "credit19" string literal
        db 063h,072h,065h,064h,069h,074h,031h,039h,00h
str_Credit10:                                   ; "credit10" string literal
        db 063h,072h,065h,064h,069h,074h,031h,030h,00h
str_Credit09:                                   ; "credit09" string literal
        db 063h,072h,065h,064h,069h,074h,030h,039h,00h
str_Credit17:                                   ; "credit17" string literal
        db 063h,072h,065h,064h,069h,074h,031h,037h,00h
str_Credit01:                                   ; "credit01" string literal
        db 063h,072h,065h,064h,069h,074h,030h,031h,00h
str_Credit15:                                   ; "credit15" string literal
        db 063h,072h,065h,064h,069h,074h,031h,035h,00h
str_Credit12:                                   ; "credit12" string literal
        db 063h,072h,065h,064h,069h,074h,031h,032h,00h
str_Credit08:                                   ; "credit08" string literal
        db 063h,072h,065h,064h,069h,074h,030h,038h,00h
str_Credit02:                                   ; "credit02" string literal
        db 063h,072h,065h,064h,069h,074h,030h,032h,00h
str_Credit11:                                   ; "credit11" string literal
        db 063h,072h,065h,064h,069h,074h,031h,031h,00h
str_Credit05:                                   ; "credit05" string literal
        db 063h,072h,065h,064h,069h,074h,030h,035h,00h
str_Credit06:                                   ; "credit06" string literal
        db 063h,072h,065h,064h,069h,074h,030h,036h,00h
str_Credit07:                                   ; "credit07" string literal
        db 063h,072h,065h,064h,069h,074h,030h,037h,00h
str_Credit18:                                   ; "credit18" string literal
        db 063h,072h,065h,064h,069h,074h,031h,038h,00h
str_Credit14:                                   ; "credit14" string literal
        db 063h,072h,065h,064h,069h,074h,031h,034h,00h
str_Credit13:                                   ; "credit13" string literal
        db 063h,072h,065h,064h,069h,074h,031h,033h,00h
str_Credit16:                                   ; "credit16" string literal
        db 063h,072h,065h,064h,069h,074h,031h,036h,00h
str_Credit00:                                   ; "credit00" string literal
        db 063h,072h,065h,064h,069h,074h,030h,030h,00h
str_Credit04:                                   ; "credit04" string literal
        db 063h,072h,065h,064h,069h,074h,030h,034h,00h
str_Credit03:                                   ; "credit03" string literal
        db 063h,072h,065h,064h,069h,074h,030h,033h,00h
