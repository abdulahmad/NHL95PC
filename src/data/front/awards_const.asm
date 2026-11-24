; Strings and constants of front/awards (src/front/awards), in link order.
bits 32
%include "hockey.inc"
section s_C039F progbits alloc noexec write align=1
global str_ANA, str_MightyDucks, str_Cal, str_Flo, str_ctl07, str_ctl06, str_SS, str_GP
global str_Min, str_GAA, str_W, str_L, str_T, str_SO, str_EN, str_Shots
global str_Pct, str_G, str_A, str_Pt, str_PIM, str_PlusMinus, str_PPG, str_SHG
global str_Pal3, str_Palmem, str_Awardsi, str_Scrn, str_Titl, str_Iff, str_Awards, str_Mtafan
global str_Adafan, str_Awasong, str_Mtawards, str_Adawards, str_Summ, str_04d, str_F000149, str_D50D99
global str_D00D49, str_D50_D99, str_D00_D49, str_Trinknd, str_0000, str_HILIGHT, str_Numshp, str_GfxIdList
global BOS, BUF, CGY, CHI, DET, EDM, HFD, LA
global DAL, MTL, NJ, NYI, NYR, OTT, PHI, PIT
global QUE, STL, SJ, TB, TOR, VAN, WSH, WPG
global ANA, FLA, ASW, ASE, TeamList, Buffalo, Calgary, Chicago
global Detroit, Edmonton, Hartford, LosAngeles, Dallas, Montreal, NewJersey, NYIslanders
global NYRangers, Ottawa, Philadelphia, Pittsburgh, Quebec, StLouis, SanJose, TampaBay
global Toronto, Vancouver, Washington, Winnipeg, Anaheim, Florida, AllStarsWest, AllStarsEast
str_ANA:                                        ; string 'ANA'; used by DrawAwardsSummary, ShowAwardScreens
        db 041h,04Eh,041h,00h
str_MightyDucks:                                ; string 'Mighty Ducks\x07 of Anaheim'; used by
                                                ; DrawAwardsSummary, ShowAwardScreens
        db 04Dh,069h,067h,068h,074h,079h,020h,044h,075h,063h,06Bh,073h,07h,020h,06Fh,066h
        db 020h,041h,06Eh,061h,068h,065h,069h,06Dh,00h
str_Cal:                                        ; string 'Cal'; used by DrawAwardsSummary, ShowAwardScreens
        db 043h,061h,06Ch,00h
str_Flo:                                        ; string 'Flo'; used by DrawAwardsSummary, ShowAwardScreens
        db 046h,06Ch,06Fh,00h
str_ctl07:                                      ; one-byte control string 07h (text colour code) of the award
                                                ; screens; used by DrawAwardsSummary, ShowAwardScreens
        db 07h,00h
str_ctl06:                                      ; one-byte control string 06h (text colour code) of the award
                                                ; screens; used by DrawAwardsSummary, ShowAwardScreens
        db 06h,00h
str_SS:                                         ; string '%s %s'; used by ShowAwardScreens
        db 025h,073h,020h,025h,073h,00h
str_GP:                                         ; string 'GP'; used by ShowAwardScreens
        db 047h,050h,00h
str_Min:                                        ; string 'Min'; used by ShowAwardScreens
        db 04Dh,069h,06Eh,00h
str_GAA:                                        ; string 'GAA'; used by ShowAwardScreens
        db 047h,041h,041h,00h
str_W:                                          ; string 'W'; used by ShowAwardScreens
        db 057h,00h
str_L:                                          ; string 'L'; used by ShowAwardScreens
        db 04Ch,00h
str_T:                                          ; string 'T'; used by ShowAwardScreens
        db 054h,00h
str_SO:                                         ; string 'SO'; used by ShowAwardScreens
        db 053h,04Fh,00h
str_EN:                                         ; string 'EN'; used by ShowAwardScreens
        db 045h,04Eh,00h
str_Shots:                                      ; string 'Shots'; used by ShowAwardScreens
        db 053h,068h,06Fh,074h,073h,00h
str_Pct:                                        ; string 'Pct'; used by ShowAwardScreens
        db 050h,063h,074h,00h
str_G:                                          ; string 'G'; used by ShowAwardScreens
        db 047h,00h
str_A:                                          ; string 'A'; used by ShowAwardScreens
        db 041h,00h
str_Pt:                                         ; string 'Pt'; used by ShowAwardScreens
        db 050h,074h,00h
str_PIM:                                        ; string 'PIM'; used by ShowAwardScreens
        db 050h,049h,04Dh,00h
str_PlusMinus:                                  ; string '+/-'; used by ShowAwardScreens
        db 02Bh,02Fh,02Dh,00h
str_PPG:                                        ; string 'PPG'; used by ShowAwardScreens
        db 050h,050h,047h,00h
str_SHG:                                        ; string 'SHG'; used by ShowAwardScreens
        db 053h,048h,047h,00h
str_Pal3:                                       ; string '!pal'; used by AwardsCeremony, ShowAwardScreens
        db 021h,070h,061h,06Ch,00h
str_Palmem:                                     ; string 'palmem'; used by AwardsCeremony, ShowAwardScreens
        db 070h,061h,06Ch,06Dh,065h,06Dh,00h
str_Awardsi:                                    ; string 'awardsi'; used by AwardsCeremony
        db 061h,077h,061h,072h,064h,073h,069h,00h
str_Scrn:                                       ; string 'scrn'; used by AwardsCeremony
        db 073h,063h,072h,06Eh,00h
str_Titl:                                       ; string 'titl'; used by AwardsCeremony
        db 074h,069h,074h,06Ch,00h
str_Iff:                                        ; string '.iff'; used by AwardsCeremony
        db 02Eh,069h,066h,066h,00h
str_Awards:                                     ; string 'awards'; used by AwardsCeremony
        db 061h,077h,061h,072h,064h,073h,00h
str_Mtafan:                                     ; string 'mtafan'; used by AwardsCeremony
        db 06Dh,074h,061h,066h,061h,06Eh,00h
str_Adafan:                                     ; string 'adafan'; used by AwardsCeremony
        db 061h,064h,061h,066h,061h,06Eh,00h
str_Awasong:                                    ; string 'awasong'; used by AwardsCeremony
        db 061h,077h,061h,073h,06Fh,06Eh,067h,00h
str_Mtawards:                                   ; string 'mtawards'; used by AwardsCeremony
        db 06Dh,074h,061h,077h,061h,072h,064h,073h,00h
str_Adawards:                                   ; string 'adawards'; used by AwardsCeremony
        db 061h,064h,061h,077h,061h,072h,064h,073h,00h
str_Summ:                                       ; string 'summ'; used by AwardsCeremony
        db 073h,075h,06Dh,06Dh,00h,00h,00h,00h
str_04d:                                        ; string '%04d'; used by IndexPhotoBank, LoadGameGfx,
                                                ; LoadPhotoBankF ...
        db 025h,030h,034h,064h,00h
str_F000149:                                    ; string 'f000_149'; used by LoadPhotoBankF
        db 066h,030h,030h,030h,05Fh,031h,034h,039h,00h
str_D50D99:                                     ; string '%d50%d99'; used by LoadPlayerPhotos
        db 025h,064h,035h,030h,025h,064h,039h,039h,00h
str_D00D49:                                     ; string '%d00%d49'; used by LoadPlayerPhotos
        db 025h,064h,030h,030h,025h,064h,034h,039h,00h
str_D50_D99:                                    ; string '%d50_%d99'; used by LoadPlayerPhotos
        db 025h,064h,035h,030h,05Fh,025h,064h,039h,039h,00h
str_D00_D49:                                    ; string '%d00_%d49'; used by LoadPlayerPhotos
        db 025h,064h,030h,030h,05Fh,025h,064h,034h,039h,00h
str_Trinknd:                                    ; string 'trinknd'; used by LoadTransparentRinkEndOverlay
        db 074h,072h,069h,06Eh,06Bh,06Eh,064h,00h
str_0000:                                       ; string '0000'; used by LoadTransparentRinkEndOverlay
        db 030h,030h,030h,030h,00h
str_HILIGHT:                                    ; string 'HILIGHT'; used by LoadGameGfx, ReloadGameGfx
        db 048h,049h,04Ch,049h,047h,048h,054h,00h
str_Numshp:                                     ; string 'numshp'; used by LoadGameGfx, ReloadGameGfx
        db 06Eh,075h,06Dh,073h,068h,070h,00h
str_GfxIdList:                                  ; string '000G000D000D000L000C000R000X'; used by
                                                ; LoadGameGfx_common
        db 030h,030h,030h,047h,030h,030h,030h,044h,030h,030h,030h,044h,030h,030h,030h,04Ch
        db 030h,030h,030h,043h,030h,030h,030h,052h,030h,030h,030h,058h,00h,00h,00h,00h
BOS:                                            ; on-screen team abbreviation in teamabbrevs
        db 042h,04Fh,053h,00h
BUF:                                            ; on-screen team abbreviation in teamabbrevs
        db 042h,055h,046h,00h
CGY:                                            ; on-screen team abbreviation in teamabbrevs
        db 043h,047h,059h,00h
CHI:                                            ; on-screen team abbreviation in teamabbrevs
        db 043h,048h,049h,00h
DET:                                            ; on-screen team abbreviation in teamabbrevs
        db 044h,045h,054h,00h
EDM:                                            ; on-screen team abbreviation in teamabbrevs
        db 045h,044h,04Dh,00h
HFD:                                            ; on-screen team abbreviation in teamabbrevs
        db 048h,046h,044h,00h
LA:                                             ; on-screen team abbreviation in teamabbrevs
        db 04Ch,041h,00h
DAL:                                            ; on-screen team abbreviation in teamabbrevs
        db 044h,041h,04Ch,00h
MTL:                                            ; on-screen team abbreviation in teamabbrevs
        db 04Dh,054h,04Ch,00h
NJ:                                             ; on-screen team abbreviation in teamabbrevs
        db 04Eh,04Ah,00h
NYI:                                            ; on-screen team abbreviation in teamabbrevs
        db 04Eh,059h,049h,00h
NYR:                                            ; on-screen team abbreviation in teamabbrevs
        db 04Eh,059h,052h,00h
OTT:                                            ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 04Fh,054h,054h,00h
PHI:                                            ; on-screen team abbreviation in teamabbrevs
        db 050h,048h,049h,00h
PIT:                                            ; on-screen team abbreviation in teamabbrevs
        db 050h,049h,054h,00h
QUE:                                            ; on-screen team abbreviation in teamabbrevs
        db 051h,055h,045h,00h
STL:                                            ; on-screen team abbreviation in teamabbrevs
        db 053h,054h,04Ch,00h
SJ:                                             ; on-screen team abbreviation in teamabbrevs
        db 053h,04Ah,00h
TB:                                             ; on-screen abbreviation TB
        db 054h,042h,00h
TOR:                                            ; on-screen team abbreviation in teamabbrevs
        db 054h,04Fh,052h,00h
VAN:                                            ; on-screen team abbreviation in teamabbrevs
        db 056h,041h,04Eh,00h
WSH:                                            ; on-screen team abbreviation in teamabbrevs
        db 057h,053h,048h,00h
WPG:                                            ; on-screen team abbreviation in teamabbrevs
        db 057h,050h,047h,00h
ANA:                                            ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 041h,04Eh,041h,00h
FLA:                                            ; on-screen team abbreviation in teamabbrevs
        db 046h,04Ch,041h,00h
ASW:                                            ; on-screen abbreviation for West All Stars
        db 041h,053h,057h,00h
ASE:                                            ; on-screen abbreviation for East All Stars
        db 041h,053h,045h,00h
TeamList:                                       ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 042h,04Fh,053h,054h,04Fh,04Eh,00h
Buffalo:                                        ; city string BUFFALO
        db 042h,055h,046h,046h,041h,04Ch,04Fh,00h
Calgary:                                        ; city string CALGARY
        db 043h,041h,04Ch,047h,041h,052h,059h,00h
Chicago:                                        ; city string CHICAGO
        db 043h,048h,049h,043h,041h,047h,04Fh,00h
Detroit:                                        ; city string DETROIT
        db 044h,045h,054h,052h,04Fh,049h,054h,00h
Edmonton:                                       ; city string EDMONTON
        db 045h,044h,04Dh,04Fh,04Eh,054h,04Fh,04Eh,00h
Hartford:                                       ; city string HARTFORD
        db 048h,041h,052h,054h,046h,04Fh,052h,044h,00h
LosAngeles:                                     ; city string LOS ANGELES
        db 04Ch,04Fh,053h,020h,041h,04Eh,047h,045h,04Ch,045h,053h,00h
Dallas:                                         ; city string DALLAS
        db 044h,041h,04Ch,04Ch,041h,053h,00h
Montreal:                                       ; city string MONTREAL
        db 04Dh,04Fh,04Eh,054h,052h,045h,041h,04Ch,00h
NewJersey:                                      ; city string NEW JERSEY
        db 04Eh,045h,057h,020h,04Ah,045h,052h,053h,045h,059h,00h
NYIslanders:                                    ; city string NY ISLANDERS; long name, not NYI
        db 04Eh,059h,020h,049h,053h,04Ch,041h,04Eh,044h,045h,052h,053h,00h
NYRangers:                                      ; city string NY RANGERS; long name, not NYR
        db 04Eh,059h,020h,052h,041h,04Eh,047h,045h,052h,053h,00h
Ottawa:                                         ; city string OTTAWA
        db 04Fh,054h,054h,041h,057h,041h,00h
Philadelphia:                                   ; city string PHILADELPHIA
        db 050h,048h,049h,04Ch,041h,044h,045h,04Ch,050h,048h,049h,041h,00h
Pittsburgh:                                     ; city string PITTSBURGH
        db 050h,049h,054h,054h,053h,042h,055h,052h,047h,048h,00h
Quebec:                                         ; city string QUEBEC
        db 051h,055h,045h,042h,045h,043h,00h
StLouis:                                        ; city string ST LOUIS
        db 053h,054h,020h,04Ch,04Fh,055h,049h,053h,00h
SanJose:                                        ; city string SAN JOSE
        db 053h,041h,04Eh,020h,04Ah,04Fh,053h,045h,00h
TampaBay:                                       ; city string TAMPA BAY
        db 054h,041h,04Dh,050h,041h,020h,042h,041h,059h,00h
Toronto:                                        ; city string TORONTO
        db 054h,04Fh,052h,04Fh,04Eh,054h,04Fh,00h
Vancouver:                                      ; city string VANCOUVER
        db 056h,041h,04Eh,043h,04Fh,055h,056h,045h,052h,00h
Washington:                                     ; city string WASHINGTON
        db 057h,041h,053h,048h,049h,04Eh,047h,054h,04Fh,04Eh,00h
Winnipeg:                                       ; city string WINNIPEG
        db 057h,049h,04Eh,04Eh,049h,050h,045h,047h,00h
Anaheim:                                        ; city string ANAHEIM
        db 041h,04Eh,041h,048h,045h,049h,04Dh,00h
Florida:                                        ; city string FLORIDA
        db 046h,04Ch,04Fh,052h,049h,044h,041h,00h
AllStarsWest:                                   ; city string WEST ALL STARS
        db 057h,045h,053h,054h,020h,041h,04Ch,04Ch,020h,053h,054h,041h,052h,053h,00h
AllStarsEast:                                   ; city string EAST ALL STARS
        db 045h,041h,053h,054h,020h,041h,04Ch,04Ch,020h,053h,054h,041h,052h,053h,00h,00h
        db 00h
