; Penalty names, goal and assist messages, and the three-stars text.
bits 32
%include "hockey.inc"
section s_C1B2C progbits alloc noexec write align=1
global PenaltyList, str_EASports, str_StarFmt, str_FmtNumFirstLast, str_FmtNumInitialLast, str_FmtNumNameSuffix, str_FmtNumName, str_FmtClockEvent
global str_PPTag, str_SHTag, str_FmtParenD, str_Unassisted, str_Assists, str_PenaltyShot, str_ToBeTakenBy, str_02d02dSPenalty
global str_GameMisconduct, str_DMinutes, str_02d02dSInjury, str_GoneForTheGame, str_GoneFor1Period, str_ServedByD, str_04d2, str_HOMEPALS4
global str_AWAYPALS, str_Rinkpal, str_Pal30, str_pen, str_dbgClin, str_dbgPenShot, str_dbgLip, str_dbgHVpos
global str_dbgRef, str_dbgPb, str_dbgG, str_dbgGO, str_dbgGsp, str_dbgC12, str_dbgPuckc, str_dbgIdx
global str_dbgD, str_dbgLbD, str_dbgDRb, str_dbgDS, str_dbgPosVel, str_dbgVz, str_dbgAss, str_dbgSpa
global str_debError, str_dbgBail, str_statslog, str_fmode_at, str_ErrDumpStats, str_dumpPool, str_dumpTmstructs, str_dumpHex
global str_dumpSortcords, str_dumpSortLine, str_dumpRule, str_dumpTeamHdrH, str_dumpHome, str_dumpPlHdrH, str_dumpPlLineH, str_dumpGlHdrH
global str_dumpGlLine, str_dumpTeamHdrA, str_dumpAway, str_dumpPlHdrA, str_dumpPlLineA, str_dumpGlHdrA, str_NoStar, str_NoPenalty
global str_Charging, str_Slashing, str_CrossChecking, str_Hooking, str_Tripping, str_Interference, str_Holding, str_HighSticking
global str_Boarding, str_Elbowing, str_AbuseOfOfficial, str_CheckingFromBehind, str_PenaltyShot2, str_Roughing, str_Charging2, str_Slashing2
global str_Xcheck, str_Hooking2, str_Tripping2, str_Interfer, str_Holding2, str_Histick, str_Boarding2, str_Elbowing2
global str_Abuse, str_Checkbnd, str_Penshot, str_B3, str_B4, str_B5, str_B6, str_B7
global str_B8, str_S8, str_BnReturnGoalie, str_BnPullGoalie, str_BnFaceOff, str_BnTwoLinePass, str_BnOffside, str_BnIcing
global str_BnPenalty, str_BnPenaltyShot, str_Gready, str_Gready2, str_Gglover, str_Gglovel, str_Gglovel2, str_Gstickr
global str_Gstickl, str_Gstackr, str_Gstackl, str_Gdive, str_Gswing, str_Gskate, str_Pflip, str_Glide
global str_Skatewp, str_Skate, str_Turnl, str_Turnr, str_Stop, str_Passf, str_Passb, str_Shotf
global str_Shotb, str_Glideback, str_Skateback, str_Sweepchk, str_Shoulderchkl, str_Shoulderchkr, str_Hipchkl, str_Hipchkr
global str_Burst, str_Hold, str_Hold2, str_Flail, str_Fallfwd, str_Fallback, str_Celebrate, str_Pump
global str_Wallright, str_Wallleft, str_Faceoff, str_Faceoffr, str_Siren, str_Bglass, str_Stanley2, str_Catch
global str_Hook, str_Hook2, str_Stumble, str_Fake, str_Flip, str_Injury1, str_Refglide, str_Refskate
global str_Refturnl, str_Refturnr, str_Refstop, str_Reffallback, str_Armupglide, str_Armupskate, str_Armupturnl, str_Armupturnr
global str_Armupstop, str_Refpickup, str_Refpointgoa, str_Refdrop, str_Reffowait, str_Refrough, str_Refcharge, str_Refslash
global str_Refxcheck, str_Refhook, str_Reftrip, str_Refinterfer, str_Refhold, str_Refabuseoff, str_Refbehind, str_Faceoffpoke
global str_Gwallright, str_Gwallleft, str_Anthem1, str_Anthem2, str_Anthem3, str_Anthem4, str_Anthem5, str_Drink
global str_Refanthem1, str_Refanthem2, str_Onetimef, str_Onetimeb, str_Getcup, str_Brcup, str_Gvcup, str_Clap
global str_Stansk, str_Crosscheck, str_Boardback, str_Boardfront, str_Boardright, str_Boardleft, str_Benchcheckr, str_Benchcheckl
global str_Refpenshot, str_Goaliepoke, str_Goalieknee, str_Gokneehold, str_Gofallback, str_Gofallglove, str_Gofallstick, str_Fakeshotf
global str_Fakeshotb, str_Fakeonetimef, str_Fakeonetimeb, str_Blockleft, str_Blockright, str_Blockfront, str_Blockknee, str_Refelbow
global str_Refhistick, str_ERROR, str_Null, str_Defo, str_Defd, str_Wingd, str_Wingo, str_Centd
global str_Cento, str_Score, str_Stan, str_Exben, str_Expen, str_Bench, str_Dopen, str_Goalie2
global str_Goalieget, str_Puckc, str_Nearest, str_Shoot, str_Passrec, str_3star, str_R3star, str_Fowait
global str_Pnorm, str_Pshad, str_Pnothing, str_Pface, str_Pface2, str_Gamemiscon, str_Rfaceoff, str_Rnorm
global str_Rcallpen, str_Rpickup, str_Rgotofo, str_Rpointgoal, str_Rgetnew, str_Anth, str_Ranth, str_Agotofo
global str_Benwait, str_Initper, str_Pgivecup, str_Rpenshot, str_Apswait, str_Abreak, str_Error2, str_G5
global str_LD, str_RD2, str_LW, str_C6, str_RW, str_XC, str_dbgO, str_dbgDash
global str_dbgL, str_dbgI, str_dbgSpace, str_dbgS, str_newline
str_EASports:                                   ; "EA Sports" (three-stars caption, assthreestars); used by
                                                ; assthreestars
        db 045h,041h,020h,053h,070h,06Fh,072h,074h,073h,00h
str_StarFmt:                                    ; "%s Star" sprintf format, filled with str_1st/2nd/3rd by
                                                ; assthreestars; used by assthreestars
        db 025h,073h,020h,053h,074h,061h,072h,00h
str_NoStar:                                     ; Empty string pushed when a three stars line has no star
                                                ; text; used by assthreestars
        db 00h,00h
PenaltyList:                                    ; not referenced by name (reached through a neighbouring label
                                                ; or a table)
        db 052h,06Fh,075h,067h,068h,069h,06Eh,067h,00h
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
str_04d2:                                       ; string '%04d'; used by LoadTeamPPV
        db 025h,030h,034h,064h,00h,00h
str_HOMEPALS4:                                  ; string 'HOMEPALS'; used by LoadTeamPalette
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h
str_AWAYPALS:                                   ; string 'AWAYPALS'; used by LoadTeamPalette
        db 041h,057h,041h,059h,050h,041h,04Ch,053h,00h
str_Rinkpal:                                    ; string 'rinkpal'; used by LoadTeamPalette
        db 072h,069h,06Eh,06Bh,070h,061h,06Ch,00h
str_Pal30:                                      ; string '!pal'; used by LoadTeamPalette
        db 021h,070h,061h,06Ch,00h,00h
str_Gready:                                     ; "gready" string literal
        db 067h,072h,065h,061h,064h,079h,00h
str_Gready2:                                    ; "gready2" string literal
        db 067h,072h,065h,061h,064h,079h,032h,00h
str_Gglover:                                    ; "gglover" string literal
        db 067h,067h,06Ch,06Fh,076h,065h,072h,00h
str_Gglovel:                                    ; "gglovel" string literal
        db 067h,067h,06Ch,06Fh,076h,065h,06Ch,00h
str_Gglovel2:                                   ; "gglovel2" string literal
        db 067h,067h,06Ch,06Fh,076h,065h,06Ch,032h,00h
str_Gstickr:                                    ; "gstickr" string literal
        db 067h,073h,074h,069h,063h,06Bh,072h,00h
str_Gstickl:                                    ; "gstickl" string literal
        db 067h,073h,074h,069h,063h,06Bh,06Ch,00h
str_Gstackr:                                    ; "gstackr" string literal
        db 067h,073h,074h,061h,063h,06Bh,072h,00h
str_Gstackl:                                    ; "gstackl" string literal
        db 067h,073h,074h,061h,063h,06Bh,06Ch,00h
str_Gdive:                                      ; "gdive" string literal
        db 067h,064h,069h,076h,065h,00h
str_Gswing:                                     ; "gswing" string literal
        db 067h,073h,077h,069h,06Eh,067h,00h
str_Gskate:                                     ; "gskate" string literal
        db 067h,073h,06Bh,061h,074h,065h,00h
str_Pflip:                                      ; "pflip" string literal
        db 070h,066h,06Ch,069h,070h,00h
str_Glide:                                      ; "glide" string literal
        db 067h,06Ch,069h,064h,065h,00h
str_Skatewp:                                    ; "skatewp" string literal
        db 073h,06Bh,061h,074h,065h,077h,070h,00h
str_Skate:                                      ; "skate" string literal
        db 073h,06Bh,061h,074h,065h,00h
str_Turnl:                                      ; "turnl" string literal
        db 074h,075h,072h,06Eh,06Ch,00h
str_Turnr:                                      ; "turnr" string literal
        db 074h,075h,072h,06Eh,072h,00h
str_Stop:                                       ; "stop" string literal
        db 073h,074h,06Fh,070h,00h
str_Passf:                                      ; "passf" string literal
        db 070h,061h,073h,073h,066h,00h
str_Passb:                                      ; "passb" string literal
        db 070h,061h,073h,073h,062h,00h
str_Shotf:                                      ; "shotf" string literal
        db 073h,068h,06Fh,074h,066h,00h
str_Shotb:                                      ; "shotb" string literal
        db 073h,068h,06Fh,074h,062h,00h
str_Glideback:                                  ; "glideback" string literal
        db 067h,06Ch,069h,064h,065h,062h,061h,063h,06Bh,00h
str_Skateback:                                  ; "skateback" string literal
        db 073h,06Bh,061h,074h,065h,062h,061h,063h,06Bh,00h
str_Sweepchk:                                   ; "sweepchk" string literal
        db 073h,077h,065h,065h,070h,063h,068h,06Bh,00h
str_Shoulderchkl:                               ; "shoulderchkl" string literal
        db 073h,068h,06Fh,075h,06Ch,064h,065h,072h,063h,068h,06Bh,06Ch,00h
str_Shoulderchkr:                               ; "shoulderchkr" string literal
        db 073h,068h,06Fh,075h,06Ch,064h,065h,072h,063h,068h,06Bh,072h,00h
str_Hipchkl:                                    ; "hipchkl" string literal
        db 068h,069h,070h,063h,068h,06Bh,06Ch,00h
str_Hipchkr:                                    ; "hipchkr" string literal
        db 068h,069h,070h,063h,068h,06Bh,072h,00h
str_Burst:                                      ; "burst" string literal
        db 062h,075h,072h,073h,074h,00h
str_Hold:                                       ; "hold" string literal
        db 068h,06Fh,06Ch,064h,00h
str_Hold2:                                      ; "hold2" string literal
        db 068h,06Fh,06Ch,064h,032h,00h
str_Flail:                                      ; "flail" string literal
        db 066h,06Ch,061h,069h,06Ch,00h
str_Fallfwd:                                    ; "fallfwd" string literal
        db 066h,061h,06Ch,06Ch,066h,077h,064h,00h
str_Fallback:                                   ; "fallback" string literal
        db 066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Celebrate:                                  ; "celebrate" string literal
        db 063h,065h,06Ch,065h,062h,072h,061h,074h,065h,00h
str_Pump:                                       ; "pump" string literal
        db 070h,075h,06Dh,070h,00h
str_Wallright:                                  ; "wallright" string literal
        db 077h,061h,06Ch,06Ch,072h,069h,067h,068h,074h,00h
str_Wallleft:                                   ; "wallleft" string literal
        db 077h,061h,06Ch,06Ch,06Ch,065h,066h,074h,00h
str_Faceoff:                                    ; "faceoff" string literal
        db 066h,061h,063h,065h,06Fh,066h,066h,00h
str_Faceoffr:                                   ; "faceoffr" string literal
        db 066h,061h,063h,065h,06Fh,066h,066h,072h,00h
str_Siren:                                      ; "siren" string literal
        db 073h,069h,072h,065h,06Eh,00h
str_Bglass:                                     ; "bglass" string literal
        db 062h,067h,06Ch,061h,073h,073h,00h
str_Stanley2:                                   ; "stanley" string literal
        db 073h,074h,061h,06Eh,06Ch,065h,079h,00h
str_Catch:                                      ; "catch" string literal
        db 063h,061h,074h,063h,068h,00h
str_Hook:                                       ; "hook" string literal
        db 068h,06Fh,06Fh,06Bh,00h
str_Hook2:                                      ; "hook2" string literal
        db 068h,06Fh,06Fh,06Bh,032h,00h
str_Stumble:                                    ; "stumble" string literal
        db 073h,074h,075h,06Dh,062h,06Ch,065h,00h
str_Fake:                                       ; "fake" string literal
        db 066h,061h,06Bh,065h,00h
str_Flip:                                       ; "flip" string literal
        db 066h,06Ch,069h,070h,00h
str_Injury1:                                    ; "injury1" string literal
        db 069h,06Eh,06Ah,075h,072h,079h,031h,00h
str_Refglide:                                   ; "refglide" string literal
        db 072h,065h,066h,067h,06Ch,069h,064h,065h,00h
str_Refskate:                                   ; "refskate" string literal
        db 072h,065h,066h,073h,06Bh,061h,074h,065h,00h
str_Refturnl:                                   ; "refturnl" string literal
        db 072h,065h,066h,074h,075h,072h,06Eh,06Ch,00h
str_Refturnr:                                   ; "refturnr" string literal
        db 072h,065h,066h,074h,075h,072h,06Eh,072h,00h
str_Refstop:                                    ; "refstop" string literal
        db 072h,065h,066h,073h,074h,06Fh,070h,00h
str_Reffallback:                                ; "reffallback" string literal
        db 072h,065h,066h,066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Armupglide:                                 ; "armupglide" string literal
        db 061h,072h,06Dh,075h,070h,067h,06Ch,069h,064h,065h,00h
str_Armupskate:                                 ; "armupskate" string literal
        db 061h,072h,06Dh,075h,070h,073h,06Bh,061h,074h,065h,00h
str_Armupturnl:                                 ; "armupturnl" string literal
        db 061h,072h,06Dh,075h,070h,074h,075h,072h,06Eh,06Ch,00h
str_Armupturnr:                                 ; "armupturnr" string literal
        db 061h,072h,06Dh,075h,070h,074h,075h,072h,06Eh,072h,00h
str_Armupstop:                                  ; "armupstop" string literal
        db 061h,072h,06Dh,075h,070h,073h,074h,06Fh,070h,00h
str_Refpickup:                                  ; "refpickup" string literal
        db 072h,065h,066h,070h,069h,063h,06Bh,075h,070h,00h
str_Refpointgoa:                                ; "refpointgoa" string literal
        db 072h,065h,066h,070h,06Fh,069h,06Eh,074h,067h,06Fh,061h,00h
str_Refdrop:                                    ; "refdrop" string literal
        db 072h,065h,066h,064h,072h,06Fh,070h,00h
str_Reffowait:                                  ; "reffowait" string literal
        db 072h,065h,066h,066h,06Fh,077h,061h,069h,074h,00h
str_Refrough:                                   ; "refrough" string literal
        db 072h,065h,066h,072h,06Fh,075h,067h,068h,00h
str_Refcharge:                                  ; "refcharge" string literal
        db 072h,065h,066h,063h,068h,061h,072h,067h,065h,00h
str_Refslash:                                   ; "refslash" string literal
        db 072h,065h,066h,073h,06Ch,061h,073h,068h,00h
str_Refxcheck:                                  ; "refxcheck" string literal
        db 072h,065h,066h,078h,063h,068h,065h,063h,06Bh,00h
str_Refhook:                                    ; "refhook" string literal
        db 072h,065h,066h,068h,06Fh,06Fh,06Bh,00h
str_Reftrip:                                    ; "reftrip" string literal
        db 072h,065h,066h,074h,072h,069h,070h,00h
str_Refinterfer:                                ; "refinterfer" string literal
        db 072h,065h,066h,069h,06Eh,074h,065h,072h,066h,065h,072h,00h
str_Refhold:                                    ; "refhold" string literal
        db 072h,065h,066h,068h,06Fh,06Ch,064h,00h
str_Refabuseoff:                                ; "refabuseoff" string literal
        db 072h,065h,066h,061h,062h,075h,073h,065h,06Fh,066h,066h,00h
str_Refbehind:                                  ; "refbehind" string literal
        db 072h,065h,066h,062h,065h,068h,069h,06Eh,064h,00h
str_Faceoffpoke:                                ; "faceoffpoke" string literal
        db 066h,061h,063h,065h,06Fh,066h,066h,070h,06Fh,06Bh,065h,00h
str_Gwallright:                                 ; "gwallright" string literal
        db 067h,077h,061h,06Ch,06Ch,072h,069h,067h,068h,074h,00h
str_Gwallleft:                                  ; "gwallleft" string literal
        db 067h,077h,061h,06Ch,06Ch,06Ch,065h,066h,074h,00h
str_Anthem1:                                    ; "anthem1" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,031h,00h
str_Anthem2:                                    ; "anthem2" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,032h,00h
str_Anthem3:                                    ; "anthem3" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,033h,00h
str_Anthem4:                                    ; "anthem4" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,034h,00h
str_Anthem5:                                    ; "anthem5" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,035h,00h
str_Drink:                                      ; "drink" string literal
        db 064h,072h,069h,06Eh,06Bh,00h
str_Refanthem1:                                 ; "refanthem1" string literal
        db 072h,065h,066h,061h,06Eh,074h,068h,065h,06Dh,031h,00h
str_Refanthem2:                                 ; "refanthem2" string literal
        db 072h,065h,066h,061h,06Eh,074h,068h,065h,06Dh,032h,00h
str_Onetimef:                                   ; "onetimef" string literal
        db 06Fh,06Eh,065h,074h,069h,06Dh,065h,066h,00h
str_Onetimeb:                                   ; "onetimeb" string literal
        db 06Fh,06Eh,065h,074h,069h,06Dh,065h,062h,00h
str_Getcup:                                     ; "getcup" string literal
        db 067h,065h,074h,063h,075h,070h,00h
str_Brcup:                                      ; "brcup" string literal
        db 062h,072h,063h,075h,070h,00h
str_Gvcup:                                      ; "gvcup" string literal
        db 067h,076h,063h,075h,070h,00h
str_Clap:                                       ; "clap" string literal
        db 063h,06Ch,061h,070h,00h
str_Stansk:                                     ; "stansk" string literal
        db 073h,074h,061h,06Eh,073h,06Bh,00h
str_Crosscheck:                                 ; "crosscheck" string literal
        db 063h,072h,06Fh,073h,073h,063h,068h,065h,063h,06Bh,00h
str_Boardback:                                  ; "boardback" string literal
        db 062h,06Fh,061h,072h,064h,062h,061h,063h,06Bh,00h
str_Boardfront:                                 ; "boardfront" string literal
        db 062h,06Fh,061h,072h,064h,066h,072h,06Fh,06Eh,074h,00h
str_Boardright:                                 ; "boardright" string literal
        db 062h,06Fh,061h,072h,064h,072h,069h,067h,068h,074h,00h
str_Boardleft:                                  ; "boardleft" string literal
        db 062h,06Fh,061h,072h,064h,06Ch,065h,066h,074h,00h
str_Benchcheckr:                                ; "benchcheckr" string literal
        db 062h,065h,06Eh,063h,068h,063h,068h,065h,063h,06Bh,072h,00h
str_Benchcheckl:                                ; "benchcheckl" string literal
        db 062h,065h,06Eh,063h,068h,063h,068h,065h,063h,06Bh,06Ch,00h
str_Refpenshot:                                 ; "refpenshot" string literal
        db 072h,065h,066h,070h,065h,06Eh,073h,068h,06Fh,074h,00h
str_Goaliepoke:                                 ; "goaliepoke" string literal
        db 067h,06Fh,061h,06Ch,069h,065h,070h,06Fh,06Bh,065h,00h
str_Goalieknee:                                 ; "goalieknee" string literal
        db 067h,06Fh,061h,06Ch,069h,065h,06Bh,06Eh,065h,065h,00h
str_Gokneehold:                                 ; "gokneehold" string literal
        db 067h,06Fh,06Bh,06Eh,065h,065h,068h,06Fh,06Ch,064h,00h
str_Gofallback:                                 ; "gofallback" string literal
        db 067h,06Fh,066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Gofallglove:                                ; "gofallglove" string literal
        db 067h,06Fh,066h,061h,06Ch,06Ch,067h,06Ch,06Fh,076h,065h,00h
str_Gofallstick:                                ; "gofallstick" string literal
        db 067h,06Fh,066h,061h,06Ch,06Ch,073h,074h,069h,063h,06Bh,00h
str_Fakeshotf:                                  ; "fakeshotf" string literal
        db 066h,061h,06Bh,065h,073h,068h,06Fh,074h,066h,00h
str_Fakeshotb:                                  ; "fakeshotb" string literal
        db 066h,061h,06Bh,065h,073h,068h,06Fh,074h,062h,00h
str_Fakeonetimef:                               ; "fakeonetimef" string literal
        db 066h,061h,06Bh,065h,06Fh,06Eh,065h,074h,069h,06Dh,065h,066h,00h
str_Fakeonetimeb:                               ; "fakeonetimeb" string literal
        db 066h,061h,06Bh,065h,06Fh,06Eh,065h,074h,069h,06Dh,065h,062h,00h
str_Blockleft:                                  ; "blockleft" string literal
        db 062h,06Ch,06Fh,063h,06Bh,06Ch,065h,066h,074h,00h
str_Blockright:                                 ; "blockright" string literal
        db 062h,06Ch,06Fh,063h,06Bh,072h,069h,067h,068h,074h,00h
str_Blockfront:                                 ; "blockfront" string literal
        db 062h,06Ch,06Fh,063h,06Bh,066h,072h,06Fh,06Eh,074h,00h
str_Blockknee:                                  ; "blockknee" string literal
        db 062h,06Ch,06Fh,063h,06Bh,06Bh,06Eh,065h,065h,00h
str_Refelbow:                                   ; "refelbow" string literal
        db 072h,065h,066h,065h,06Ch,062h,06Fh,077h,00h
str_Refhistick:                                 ; "refhistick" string literal
        db 072h,065h,066h,068h,069h,073h,074h,069h,063h,06Bh,00h
str_ERROR:                                      ; "ERROR" string literal
        db 045h,052h,052h,04Fh,052h,00h
str_Null:                                       ; "null" string literal
        db 06Eh,075h,06Ch,06Ch,00h
str_Defo:                                       ; "defo" string literal
        db 064h,065h,066h,06Fh,00h
str_Defd:                                       ; "defd" string literal
        db 064h,065h,066h,064h,00h
str_Wingd:                                      ; "wingd" string literal
        db 077h,069h,06Eh,067h,064h,00h
str_Wingo:                                      ; "wingo" string literal
        db 077h,069h,06Eh,067h,06Fh,00h
str_Centd:                                      ; "centd" string literal
        db 063h,065h,06Eh,074h,064h,00h
str_Cento:                                      ; "cento" string literal
        db 063h,065h,06Eh,074h,06Fh,00h
str_Score:                                      ; "score" string literal
        db 073h,063h,06Fh,072h,065h,00h
str_Stan:                                       ; "stan" string literal
        db 073h,074h,061h,06Eh,00h
str_Exben:                                      ; "exben" string literal
        db 065h,078h,062h,065h,06Eh,00h
str_Expen:                                      ; "expen" string literal
        db 065h,078h,070h,065h,06Eh,00h
str_Bench:                                      ; "bench" string literal
        db 062h,065h,06Eh,063h,068h,00h
str_pen:                                        ; string pen (DebugMonitor prints it for an object in the
                                                ; penalty box); used by DebugMonitor
        db 070h,065h,06Eh,00h
str_Dopen:                                      ; "dopen" string literal
        db 064h,06Fh,070h,065h,06Eh,00h
str_Goalie2:                                    ; "goalie" string literal
        db 067h,06Fh,061h,06Ch,069h,065h,00h
str_Goalieget:                                  ; "goalieget" string literal
        db 067h,06Fh,061h,06Ch,069h,065h,067h,065h,074h,00h
str_Puckc:                                      ; "puckc" string literal
        db 070h,075h,063h,06Bh,063h,00h
str_Nearest:                                    ; "nearest" string literal
        db 06Eh,065h,061h,072h,065h,073h,074h,00h
str_Shoot:                                      ; "shoot" string literal
        db 073h,068h,06Fh,06Fh,074h,00h
str_Passrec:                                    ; "passrec" string literal
        db 070h,061h,073h,073h,072h,065h,063h,00h
str_3star:                                      ; "3star" string literal
        db 033h,073h,074h,061h,072h,00h
str_R3star:                                     ; "r3star" string literal
        db 072h,033h,073h,074h,061h,072h,00h
str_Fowait:                                     ; "fowait" string literal
        db 066h,06Fh,077h,061h,069h,074h,00h
str_Pnorm:                                      ; "pnorm" string literal
        db 070h,06Eh,06Fh,072h,06Dh,00h
str_Pshad:                                      ; "pshad" string literal
        db 070h,073h,068h,061h,064h,00h
str_Pnothing:                                   ; "pnothing" string literal
        db 070h,06Eh,06Fh,074h,068h,069h,06Eh,067h,00h
str_Pface:                                      ; "pface" string literal
        db 070h,066h,061h,063h,065h,00h
str_Pface2:                                     ; "pface2" string literal
        db 070h,066h,061h,063h,065h,032h,00h
str_Gamemiscon:                                 ; "gamemiscon" string literal
        db 067h,061h,06Dh,065h,06Dh,069h,073h,063h,06Fh,06Eh,00h
str_Rfaceoff:                                   ; "rfaceoff" string literal
        db 072h,066h,061h,063h,065h,06Fh,066h,066h,00h
str_Rnorm:                                      ; "rnorm" string literal
        db 072h,06Eh,06Fh,072h,06Dh,00h
str_Rcallpen:                                   ; "rcallpen" string literal
        db 072h,063h,061h,06Ch,06Ch,070h,065h,06Eh,00h
str_Rpickup:                                    ; "rpickup" string literal
        db 072h,070h,069h,063h,06Bh,075h,070h,00h
str_Rgotofo:                                    ; "rgotofo" string literal
        db 072h,067h,06Fh,074h,06Fh,066h,06Fh,00h
str_Rpointgoal:                                 ; "rpointgoal" string literal
        db 072h,070h,06Fh,069h,06Eh,074h,067h,06Fh,061h,06Ch,00h
str_Rgetnew:                                    ; "rgetnew" string literal
        db 072h,067h,065h,074h,06Eh,065h,077h,00h
str_Anth:                                       ; "anth" string literal
        db 061h,06Eh,074h,068h,00h
str_Ranth:                                      ; "ranth" string literal
        db 072h,061h,06Eh,074h,068h,00h
str_Agotofo:                                    ; "agotofo" string literal
        db 061h,067h,06Fh,074h,06Fh,066h,06Fh,00h
str_Benwait:                                    ; "benwait" string literal
        db 062h,065h,06Eh,077h,061h,069h,074h,00h
str_Initper:                                    ; "initper" string literal
        db 069h,06Eh,069h,074h,070h,065h,072h,00h
str_Pgivecup:                                   ; "pgivecup" string literal
        db 070h,067h,069h,076h,065h,063h,075h,070h,00h
str_Rpenshot:                                   ; "rpenshot" string literal
        db 072h,070h,065h,06Eh,073h,068h,06Fh,074h,00h
str_Apswait:                                    ; "apswait" string literal
        db 061h,070h,073h,077h,061h,069h,074h,00h
str_Abreak:                                     ; "abreak" string literal
        db 061h,062h,072h,065h,061h,06Bh,00h
str_Error2:                                     ; "error" string literal
        db 065h,072h,072h,06Fh,072h,00h
str_G5:                                         ; string 'G'
        db 047h,00h
str_LD:                                         ; "LD" string literal
        db 04Ch,044h,00h
str_RD2:                                        ; "RD" string literal
        db 052h,044h,00h
str_LW:                                         ; "LW" string literal
        db 04Ch,057h,00h
str_C6:                                         ; string 'C'
        db 043h,00h
str_RW:                                         ; "RW" string literal
        db 052h,057h,00h
str_XC:                                         ; "XC" string literal
        db 058h,043h,00h
str_dbgO:                                       ; string 'O'; used by DebugMonitor
        db 04Fh,00h
str_dbgDash:                                    ; string '-'; used by DebugMonitor
        db 02Dh,00h
str_dbgClin:                                    ; string '------------------------clin=%d %d '; used by
                                                ; DebugMonitor
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,063h,06Ch,069h,06Eh,03Dh,025h,064h,020h
        db 025h,064h,020h,00h
str_dbgPenShot:                                 ; string 'ps<%d %d %d %d %d> f(%d %d %d %d) b(%d %d)'; used by
                                                ; DebugMonitor
        db 070h,073h,03Ch,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h
        db 064h,03Eh,020h,066h,028h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 029h,020h,062h,028h,025h,064h,020h,025h,064h,029h,00h
str_dbgLip:                                     ; string 'lip %d '; used by DebugMonitor
        db 06Ch,069h,070h,020h,025h,064h,020h,00h
str_dbgHVpos:                                   ; string 'HVpos<%d %d, %d %d> '; used by DebugMonitor
        db 048h,056h,070h,06Fh,073h,03Ch,025h,064h,020h,025h,064h,02Ch,020h,025h,064h,020h
        db 025h,064h,03Eh,020h,00h
str_dbgRef:                                     ; string 'ref<%d %d> '; used by DebugMonitor
        db 072h,065h,066h,03Ch,025h,064h,020h,025h,064h,03Eh,020h,00h
str_dbgPb:                                      ; string 'pb[%d %d]'; used by DebugMonitor
        db 070h,062h,05Bh,025h,064h,020h,025h,064h,05Dh,00h
str_dbgG:                                       ; string 'G<%d %d> '; used by DebugMonitor
        db 047h,03Ch,025h,064h,020h,025h,064h,03Eh,020h,00h
str_dbgGO:                                      ; string 'GO=%d PO=%d go=%d gs=%d '; used by DebugMonitor
        db 047h,04Fh,03Dh,025h,064h,020h,050h,04Fh,03Dh,025h,064h,020h,067h,06Fh,03Dh,025h
        db 064h,020h,067h,073h,03Dh,025h,064h,020h,00h
str_dbgGsp:                                     ; string 'g=%d %d '; used by DebugMonitor
        db 067h,03Dh,025h,064h,020h,025h,064h,020h,00h
str_dbgC12:                                     ; string 'c12(%d %d)(%d %d) '; used by DebugMonitor
        db 063h,031h,032h,028h,025h,064h,020h,025h,064h,029h,028h,025h,064h,020h,025h,064h
        db 029h,020h,00h
str_dbgPuckc:                                   ; string 'puckc = %d gmclock%d gmpen%d pcdwn=%d\n'; used by
                                                ; DebugMonitor
        db 070h,075h,063h,06Bh,063h,020h,03Dh,020h,025h,064h,020h,067h,06Dh,063h,06Ch,06Fh
        db 063h,06Bh,025h,064h,020h,067h,06Dh,070h,065h,06Eh,025h,064h,020h,070h,063h,064h
        db 077h,06Eh,03Dh,025h,064h,0Ah,00h
str_dbgIdx:                                     ; string '%d) '; used by DebugMonitor
        db 025h,064h,029h,020h,00h
str_dbgD:                                       ; string '%d '; used by DebugMonitor
        db 025h,064h,020h,00h
str_dbgLbD:                                     ; string '[%d '; used by DebugMonitor
        db 05Bh,025h,064h,020h,00h
str_dbgDRb:                                     ; string '%d] '; used by DebugMonitor
        db 025h,064h,05Dh,020h,00h
str_dbgDS:                                      ; string '%d %s '; used by DebugMonitor
        db 025h,064h,020h,025h,073h,020h,00h
str_dbgPosVel:                                  ; string '@(%d %d) v(%d %d) %d(%d %d)'; used by DebugMonitor
        db 040h,028h,025h,064h,020h,025h,064h,029h,020h,076h,028h,025h,064h,020h,025h,064h
        db 029h,020h,025h,064h,028h,025h,064h,020h,025h,064h,029h,00h
str_dbgVz:                                      ; string 'vz%d '; used by DebugMonitor
        db 076h,07Ah,025h,064h,020h,00h
str_dbgAss:                                     ; string 'A%s '; used by DebugMonitor
        db 041h,025h,073h,020h,00h
str_dbgL:                                       ; string 'L'; used by DebugMonitor
        db 04Ch,00h
str_dbgI:                                       ; string 'I'; used by DebugMonitor
        db 049h,00h
str_dbgSpace:                                   ; string ' '; used by DebugMonitor
        db 020h,00h
str_dbgSpa:                                     ; string 'spa=%d'; used by DebugMonitor
        db 073h,070h,061h,03Dh,025h,064h,00h
str_dbgS:                                       ; string '%s'; used by DebugMonitor
        db 025h,073h,00h
str_debError:                                   ; string 'debError: %d frame %d \n'; used by DebugMonitor
        db 064h,065h,062h,045h,072h,072h,06Fh,072h,03Ah,020h,025h,064h,020h,066h,072h,061h
        db 06Dh,065h,020h,025h,064h,020h,0Ah,00h
str_newline:                                    ; string '\n'; used by DebugMonitor, DumpStatsLog
        db 0Ah,00h
str_dbgBail:                                    ; string 'bail\n'; used by DebugMonitor
        db 062h,061h,069h,06Ch,0Ah,00h
str_statslog:                                   ; string 'stats.log'; used by DebugMonitor
        db 073h,074h,061h,074h,073h,02Eh,06Ch,06Fh,067h,00h
str_fmode_at:                                   ; string 'a+t'; used by DumpStatsLog
        db 061h,02Bh,074h,00h
str_ErrDumpStats:                               ; string 'error dump stats\n'; used by DumpStatsLog
        db 065h,072h,072h,06Fh,072h,020h,064h,075h,06Dh,070h,020h,073h,074h,061h,074h,073h
        db 0Ah,00h
str_dumpPool:                                   ; string '===== pool(%d %d) gm%d ====\n'; used by DumpStatsLog
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,070h,06Fh,06Fh,06Ch,028h,025h,064h,020h,025h,064h
        db 029h,020h,067h,06Dh,025h,064h,020h,03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpTmstructs:                              ; string '===== tmstructs ====\n'; used by DumpStatsLog
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,074h,06Dh,073h,074h,072h,075h,063h,074h,073h,020h
        db 03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpHex:                                    ; string '%x '; used by DumpStatsLog
        db 025h,078h,020h,00h
str_dumpSortcords:                              ; string '===== sortcords ====\n'; used by DumpStatsLog
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,073h,06Fh,072h,074h,063h,06Fh,072h,064h,073h,020h
        db 03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpSortLine:                               ; string '%d:%d[%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d
                                                ; %d %x]\n'; used by DumpStatsLog
        db 025h,064h,03Ah,025h,064h,05Bh,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h
        db 064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h
        db 025h,064h,020h,025h,064h,020h,025h,078h,05Dh,0Ah,00h
str_dumpRule:                                   ; string
                                                ; '==================================================\n'; used
                                                ; by DumpStatsLog
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,0Ah,00h
str_dumpTeamHdrH:                               ; string ' shts score [shots score] ppg pp pen penmin atop
                                                ; pass passcomp\n'; used by DumpStatsLog
        db 020h,020h,020h,020h,020h,020h,020h,073h,068h,074h,073h,020h,073h,063h,06Fh,072h
        db 065h,020h,05Bh,073h,068h,06Fh,074h,073h,020h,073h,063h,06Fh,072h,065h,05Dh,020h
        db 070h,070h,067h,020h,070h,070h,020h,070h,065h,06Eh,020h,070h,065h,06Eh,06Dh,069h
        db 06Eh,020h,061h,074h,06Fh,070h,020h,070h,061h,073h,073h,020h,070h,061h,073h,073h
        db 063h,06Fh,06Dh,070h,0Ah,00h
str_dumpHome:                                   ; string 'home : %d %d [%d %d] %d %d %d %d %d %d %d\n'; used
                                                ; by DumpStatsLog
        db 068h,06Fh,06Dh,065h,020h,03Ah,020h,025h,064h,020h,025h,064h,020h,05Bh,025h,064h
        db 020h,025h,064h,05Dh,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,0Ah,00h
str_dumpPlHdrH:                                 ; string ' i pnum g a pen +/- ppg shg eng sht status\n'; used
                                                ; by DumpStatsLog
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,067h,020h,020h,061h,020h,020h
        db 070h,065h,06Eh,020h,02Bh,02Fh,02Dh,020h,070h,070h,067h,020h,073h,068h,067h,020h
        db 065h,06Eh,067h,020h,073h,068h,074h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpPlLineH:                                ; string '%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n'; used
                                                ; by DumpStatsLog
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpGlHdrH:                                 ; string ' i pnum min sht sav status\n'; used by DumpStatsLog
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,06Dh,069h,06Eh,020h,073h,068h
        db 074h,020h,073h,061h,076h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpGlLine:                                 ; string '%3d %3d %5d %3d %3d %3d\n'; used by DumpStatsLog
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,035h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpTeamHdrA:                               ; string ' shts score [shots score] ppg pp pen penmin atop
                                                ; pass passcomp\n'; used by DumpStatsLog
        db 020h,020h,020h,020h,020h,020h,020h,073h,068h,074h,073h,020h,073h,063h,06Fh,072h
        db 065h,020h,05Bh,073h,068h,06Fh,074h,073h,020h,073h,063h,06Fh,072h,065h,05Dh,020h
        db 070h,070h,067h,020h,070h,070h,020h,070h,065h,06Eh,020h,070h,065h,06Eh,06Dh,069h
        db 06Eh,020h,061h,074h,06Fh,070h,020h,070h,061h,073h,073h,020h,070h,061h,073h,073h
        db 063h,06Fh,06Dh,070h,0Ah,00h
str_dumpAway:                                   ; string 'away : %d %d [%d %d] %d %d %d %d %d %d %d\n'; used
                                                ; by DumpStatsLog
        db 061h,077h,061h,079h,020h,03Ah,020h,025h,064h,020h,025h,064h,020h,05Bh,025h,064h
        db 020h,025h,064h,05Dh,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,0Ah,00h
str_dumpPlHdrA:                                 ; string ' i pnum g a pen +/- ppg shg eng sht status\n'; used
                                                ; by DumpStatsLog
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,067h,020h,020h,061h,020h,020h
        db 070h,065h,06Eh,020h,02Bh,02Fh,02Dh,020h,070h,070h,067h,020h,073h,068h,067h,020h
        db 065h,06Eh,067h,020h,073h,068h,074h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpPlLineA:                                ; string '%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n'; used
                                                ; by DumpStatsLog
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpGlHdrA:                                 ; string ' i pnum min sht sav status\n'; used by DumpStatsLog
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,06Dh,069h,06Eh,020h,073h,068h
        db 074h,020h,073h,061h,076h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h,00h,00h
        db 00h
