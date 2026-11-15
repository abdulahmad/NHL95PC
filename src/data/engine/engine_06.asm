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
global str_dumpGlLine, str_dumpTeamHdrA, str_dumpAway, str_dumpPlHdrA, str_dumpPlLineA, str_dumpGlHdrA, unk_C1B3E, unk_C1B49
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
str_EASports:
        db 045h,041h,020h,053h,070h,06Fh,072h,074h,073h,00h
str_StarFmt:
        db 025h,073h,020h,053h,074h,061h,072h,00h
unk_C1B3E:
        db 00h,00h
PenaltyList:
        db 052h,06Fh,075h,067h,068h,069h,06Eh,067h,00h
unk_C1B49:
        db 00h
str_Charging:
        db 043h,068h,061h,072h,067h,069h,06Eh,067h,00h
str_Slashing:
        db 053h,06Ch,061h,073h,068h,069h,06Eh,067h,00h
str_CrossChecking:
        db 043h,072h,06Fh,073h,073h,043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_Hooking:
        db 048h,06Fh,06Fh,06Bh,069h,06Eh,067h,00h
str_Tripping:
        db 054h,072h,069h,070h,070h,069h,06Eh,067h,00h
str_Interference:
        db 049h,06Eh,074h,065h,072h,066h,065h,072h,065h,06Eh,063h,065h,00h
str_Holding:
        db 048h,06Fh,06Ch,064h,069h,06Eh,067h,00h
str_HighSticking:
        db 048h,069h,067h,068h,053h,074h,069h,063h,06Bh,069h,06Eh,067h,00h
str_Boarding:
        db 042h,06Fh,061h,072h,064h,069h,06Eh,067h,00h
str_Elbowing:
        db 045h,06Ch,062h,06Fh,077h,069h,06Eh,067h,00h
str_AbuseOfOfficial:
        db 041h,062h,075h,073h,065h,020h,06Fh,066h,020h,04Fh,066h,066h,069h,063h,069h,061h
        db 06Ch,00h
str_CheckingFromBehind:
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,020h,066h,072h,06Fh,06Dh,020h,042h,065h
        db 068h,069h,06Eh,064h,00h
str_PenaltyShot2:
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,053h,068h,06Fh,074h,00h
str_Roughing:
        db 072h,06Fh,075h,067h,068h,069h,06Eh,067h,00h
str_Charging2:
        db 063h,068h,061h,072h,067h,069h,06Eh,067h,00h
str_Slashing2:
        db 073h,06Ch,061h,073h,068h,069h,06Eh,067h,00h
str_Xcheck:
        db 078h,063h,068h,065h,063h,06Bh,00h
str_Hooking2:
        db 068h,06Fh,06Fh,06Bh,069h,06Eh,067h,00h
str_Tripping2:
        db 074h,072h,069h,070h,070h,069h,06Eh,067h,00h
str_Interfer:
        db 069h,06Eh,074h,065h,072h,066h,065h,072h,00h
str_Holding2:
        db 068h,06Fh,06Ch,064h,069h,06Eh,067h,00h
str_Histick:
        db 068h,069h,073h,074h,069h,063h,06Bh,00h
str_Boarding2:
        db 062h,06Fh,061h,072h,064h,069h,06Eh,067h,00h
str_Elbowing2:
        db 065h,06Ch,062h,06Fh,077h,069h,06Eh,067h,00h
str_Abuse:
        db 061h,062h,075h,073h,065h,00h
str_Checkbnd:
        db 063h,068h,065h,063h,06Bh,062h,06Eh,064h,00h
str_Penshot:
        db 070h,065h,06Eh,073h,068h,06Fh,074h,00h
str_B3:
        db 042h,033h,00h
str_B4:
        db 042h,034h,00h
str_B5:
        db 042h,035h,00h
str_B6:
        db 042h,036h,00h
str_B7:
        db 042h,037h,00h
str_B8:
        db 042h,038h,00h
str_FmtNumFirstLast:
        db 025h,073h,023h,025h,064h,020h,025h,073h,020h,025h,073h,025h,073h,00h
str_FmtNumInitialLast:
        db 025h,073h,023h,025h,064h,020h,025h,063h,02Eh,020h,025h,073h,025h,073h,00h
str_FmtNumNameSuffix:
        db 025h,073h,023h,025h,064h,020h,025h,073h,025h,073h,00h
str_FmtNumName:
        db 025h,073h,023h,025h,064h,020h,025h,073h,00h
str_FmtClockEvent:
        db 025h,030h,032h,064h,03Ah,025h,030h,032h,064h,020h,025h,073h,00h
str_PPTag:
        db 020h,050h,050h,00h
str_SHTag:
        db 020h,053h,048h,00h
str_S8:
        db 025h,073h,00h
str_FmtParenD:
        db 020h,028h,025h,064h,029h,00h
str_Unassisted:
        db 055h,06Eh,061h,073h,073h,069h,073h,074h,065h,064h,00h
str_Assists:
        db 041h,073h,073h,069h,073h,074h,073h,03Ah,00h
str_PenaltyShot:
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,073h,068h,06Fh,074h,00h
str_ToBeTakenBy:
        db 074h,06Fh,020h,062h,065h,020h,074h,061h,06Bh,065h,06Eh,020h,062h,079h,00h
str_02d02dSPenalty:
        db 025h,030h,032h,064h,03Ah,025h,030h,032h,064h,020h,025h,073h,020h,050h,065h,06Eh
        db 061h,06Ch,074h,079h,00h
str_GameMisconduct:
        db 067h,061h,06Dh,065h,020h,06Dh,069h,073h,063h,06Fh,06Eh,064h,075h,063h,074h,00h
str_DMinutes:
        db 025h,064h,020h,06Dh,069h,06Eh,075h,074h,065h,073h,00h
str_02d02dSInjury:
        db 025h,030h,032h,064h,03Ah,025h,030h,032h,064h,020h,025h,073h,020h,049h,06Eh,06Ah
        db 075h,072h,079h,00h
str_GoneForTheGame:
        db 067h,06Fh,06Eh,065h,020h,066h,06Fh,072h,020h,074h,068h,065h,020h,067h,061h,06Dh
        db 065h,00h
str_GoneFor1Period:
        db 067h,06Fh,06Eh,065h,020h,066h,06Fh,072h,020h,031h,020h,070h,065h,072h,069h,06Fh
        db 064h,00h,00h,00h,00h
str_ServedByD:
        db 073h,065h,072h,076h,065h,064h,020h,062h,079h,020h,023h,025h,064h,00h,00h,00h
str_BnReturnGoalie:
        db 052h,045h,054h,055h,052h,04Eh,020h,047h,04Fh,041h,04Ch,049h,045h,00h
str_BnPullGoalie:
        db 050h,055h,04Ch,04Ch,020h,047h,04Fh,041h,04Ch,049h,045h,00h
str_BnFaceOff:
        db 046h,041h,043h,045h,02Dh,04Fh,046h,046h,00h
str_BnTwoLinePass:
        db 032h,020h,04Ch,049h,04Eh,045h,020h,050h,041h,053h,053h,00h
str_BnOffside:
        db 04Fh,046h,046h,053h,049h,044h,045h,00h
str_BnIcing:
        db 049h,043h,049h,04Eh,047h,00h
str_BnPenalty:
        db 050h,045h,04Eh,041h,04Ch,054h,059h,00h
str_BnPenaltyShot:
        db 050h,045h,04Eh,041h,04Ch,054h,059h,020h,053h,048h,04Fh,054h,00h
str_04d2:
        db 025h,030h,034h,064h,00h,00h
str_HOMEPALS4:
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h
str_AWAYPALS:
        db 041h,057h,041h,059h,050h,041h,04Ch,053h,00h
str_Rinkpal:
        db 072h,069h,06Eh,06Bh,070h,061h,06Ch,00h
str_Pal30:
        db 021h,070h,061h,06Ch,00h,00h
str_Gready:
        db 067h,072h,065h,061h,064h,079h,00h
str_Gready2:
        db 067h,072h,065h,061h,064h,079h,032h,00h
str_Gglover:
        db 067h,067h,06Ch,06Fh,076h,065h,072h,00h
str_Gglovel:
        db 067h,067h,06Ch,06Fh,076h,065h,06Ch,00h
str_Gglovel2:
        db 067h,067h,06Ch,06Fh,076h,065h,06Ch,032h,00h
str_Gstickr:
        db 067h,073h,074h,069h,063h,06Bh,072h,00h
str_Gstickl:
        db 067h,073h,074h,069h,063h,06Bh,06Ch,00h
str_Gstackr:
        db 067h,073h,074h,061h,063h,06Bh,072h,00h
str_Gstackl:
        db 067h,073h,074h,061h,063h,06Bh,06Ch,00h
str_Gdive:
        db 067h,064h,069h,076h,065h,00h
str_Gswing:
        db 067h,073h,077h,069h,06Eh,067h,00h
str_Gskate:
        db 067h,073h,06Bh,061h,074h,065h,00h
str_Pflip:
        db 070h,066h,06Ch,069h,070h,00h
str_Glide:
        db 067h,06Ch,069h,064h,065h,00h
str_Skatewp:
        db 073h,06Bh,061h,074h,065h,077h,070h,00h
str_Skate:
        db 073h,06Bh,061h,074h,065h,00h
str_Turnl:
        db 074h,075h,072h,06Eh,06Ch,00h
str_Turnr:
        db 074h,075h,072h,06Eh,072h,00h
str_Stop:
        db 073h,074h,06Fh,070h,00h
str_Passf:
        db 070h,061h,073h,073h,066h,00h
str_Passb:
        db 070h,061h,073h,073h,062h,00h
str_Shotf:
        db 073h,068h,06Fh,074h,066h,00h
str_Shotb:
        db 073h,068h,06Fh,074h,062h,00h
str_Glideback:
        db 067h,06Ch,069h,064h,065h,062h,061h,063h,06Bh,00h
str_Skateback:
        db 073h,06Bh,061h,074h,065h,062h,061h,063h,06Bh,00h
str_Sweepchk:
        db 073h,077h,065h,065h,070h,063h,068h,06Bh,00h
str_Shoulderchkl:
        db 073h,068h,06Fh,075h,06Ch,064h,065h,072h,063h,068h,06Bh,06Ch,00h
str_Shoulderchkr:
        db 073h,068h,06Fh,075h,06Ch,064h,065h,072h,063h,068h,06Bh,072h,00h
str_Hipchkl:
        db 068h,069h,070h,063h,068h,06Bh,06Ch,00h
str_Hipchkr:
        db 068h,069h,070h,063h,068h,06Bh,072h,00h
str_Burst:
        db 062h,075h,072h,073h,074h,00h
str_Hold:
        db 068h,06Fh,06Ch,064h,00h
str_Hold2:
        db 068h,06Fh,06Ch,064h,032h,00h
str_Flail:
        db 066h,06Ch,061h,069h,06Ch,00h
str_Fallfwd:
        db 066h,061h,06Ch,06Ch,066h,077h,064h,00h
str_Fallback:
        db 066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Celebrate:
        db 063h,065h,06Ch,065h,062h,072h,061h,074h,065h,00h
str_Pump:
        db 070h,075h,06Dh,070h,00h
str_Wallright:
        db 077h,061h,06Ch,06Ch,072h,069h,067h,068h,074h,00h
str_Wallleft:
        db 077h,061h,06Ch,06Ch,06Ch,065h,066h,074h,00h
str_Faceoff:
        db 066h,061h,063h,065h,06Fh,066h,066h,00h
str_Faceoffr:
        db 066h,061h,063h,065h,06Fh,066h,066h,072h,00h
str_Siren:
        db 073h,069h,072h,065h,06Eh,00h
str_Bglass:
        db 062h,067h,06Ch,061h,073h,073h,00h
str_Stanley2:
        db 073h,074h,061h,06Eh,06Ch,065h,079h,00h
str_Catch:
        db 063h,061h,074h,063h,068h,00h
str_Hook:
        db 068h,06Fh,06Fh,06Bh,00h
str_Hook2:
        db 068h,06Fh,06Fh,06Bh,032h,00h
str_Stumble:
        db 073h,074h,075h,06Dh,062h,06Ch,065h,00h
str_Fake:
        db 066h,061h,06Bh,065h,00h
str_Flip:
        db 066h,06Ch,069h,070h,00h
str_Injury1:
        db 069h,06Eh,06Ah,075h,072h,079h,031h,00h
str_Refglide:
        db 072h,065h,066h,067h,06Ch,069h,064h,065h,00h
str_Refskate:
        db 072h,065h,066h,073h,06Bh,061h,074h,065h,00h
str_Refturnl:
        db 072h,065h,066h,074h,075h,072h,06Eh,06Ch,00h
str_Refturnr:
        db 072h,065h,066h,074h,075h,072h,06Eh,072h,00h
str_Refstop:
        db 072h,065h,066h,073h,074h,06Fh,070h,00h
str_Reffallback:
        db 072h,065h,066h,066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Armupglide:
        db 061h,072h,06Dh,075h,070h,067h,06Ch,069h,064h,065h,00h
str_Armupskate:
        db 061h,072h,06Dh,075h,070h,073h,06Bh,061h,074h,065h,00h
str_Armupturnl:
        db 061h,072h,06Dh,075h,070h,074h,075h,072h,06Eh,06Ch,00h
str_Armupturnr:
        db 061h,072h,06Dh,075h,070h,074h,075h,072h,06Eh,072h,00h
str_Armupstop:
        db 061h,072h,06Dh,075h,070h,073h,074h,06Fh,070h,00h
str_Refpickup:
        db 072h,065h,066h,070h,069h,063h,06Bh,075h,070h,00h
str_Refpointgoa:
        db 072h,065h,066h,070h,06Fh,069h,06Eh,074h,067h,06Fh,061h,00h
str_Refdrop:
        db 072h,065h,066h,064h,072h,06Fh,070h,00h
str_Reffowait:
        db 072h,065h,066h,066h,06Fh,077h,061h,069h,074h,00h
str_Refrough:
        db 072h,065h,066h,072h,06Fh,075h,067h,068h,00h
str_Refcharge:
        db 072h,065h,066h,063h,068h,061h,072h,067h,065h,00h
str_Refslash:
        db 072h,065h,066h,073h,06Ch,061h,073h,068h,00h
str_Refxcheck:
        db 072h,065h,066h,078h,063h,068h,065h,063h,06Bh,00h
str_Refhook:
        db 072h,065h,066h,068h,06Fh,06Fh,06Bh,00h
str_Reftrip:
        db 072h,065h,066h,074h,072h,069h,070h,00h
str_Refinterfer:
        db 072h,065h,066h,069h,06Eh,074h,065h,072h,066h,065h,072h,00h
str_Refhold:
        db 072h,065h,066h,068h,06Fh,06Ch,064h,00h
str_Refabuseoff:
        db 072h,065h,066h,061h,062h,075h,073h,065h,06Fh,066h,066h,00h
str_Refbehind:
        db 072h,065h,066h,062h,065h,068h,069h,06Eh,064h,00h
str_Faceoffpoke:
        db 066h,061h,063h,065h,06Fh,066h,066h,070h,06Fh,06Bh,065h,00h
str_Gwallright:
        db 067h,077h,061h,06Ch,06Ch,072h,069h,067h,068h,074h,00h
str_Gwallleft:
        db 067h,077h,061h,06Ch,06Ch,06Ch,065h,066h,074h,00h
str_Anthem1:
        db 061h,06Eh,074h,068h,065h,06Dh,031h,00h
str_Anthem2:
        db 061h,06Eh,074h,068h,065h,06Dh,032h,00h
str_Anthem3:
        db 061h,06Eh,074h,068h,065h,06Dh,033h,00h
str_Anthem4:
        db 061h,06Eh,074h,068h,065h,06Dh,034h,00h
str_Anthem5:
        db 061h,06Eh,074h,068h,065h,06Dh,035h,00h
str_Drink:
        db 064h,072h,069h,06Eh,06Bh,00h
str_Refanthem1:
        db 072h,065h,066h,061h,06Eh,074h,068h,065h,06Dh,031h,00h
str_Refanthem2:
        db 072h,065h,066h,061h,06Eh,074h,068h,065h,06Dh,032h,00h
str_Onetimef:
        db 06Fh,06Eh,065h,074h,069h,06Dh,065h,066h,00h
str_Onetimeb:
        db 06Fh,06Eh,065h,074h,069h,06Dh,065h,062h,00h
str_Getcup:
        db 067h,065h,074h,063h,075h,070h,00h
str_Brcup:
        db 062h,072h,063h,075h,070h,00h
str_Gvcup:
        db 067h,076h,063h,075h,070h,00h
str_Clap:
        db 063h,06Ch,061h,070h,00h
str_Stansk:
        db 073h,074h,061h,06Eh,073h,06Bh,00h
str_Crosscheck:
        db 063h,072h,06Fh,073h,073h,063h,068h,065h,063h,06Bh,00h
str_Boardback:
        db 062h,06Fh,061h,072h,064h,062h,061h,063h,06Bh,00h
str_Boardfront:
        db 062h,06Fh,061h,072h,064h,066h,072h,06Fh,06Eh,074h,00h
str_Boardright:
        db 062h,06Fh,061h,072h,064h,072h,069h,067h,068h,074h,00h
str_Boardleft:
        db 062h,06Fh,061h,072h,064h,06Ch,065h,066h,074h,00h
str_Benchcheckr:
        db 062h,065h,06Eh,063h,068h,063h,068h,065h,063h,06Bh,072h,00h
str_Benchcheckl:
        db 062h,065h,06Eh,063h,068h,063h,068h,065h,063h,06Bh,06Ch,00h
str_Refpenshot:
        db 072h,065h,066h,070h,065h,06Eh,073h,068h,06Fh,074h,00h
str_Goaliepoke:
        db 067h,06Fh,061h,06Ch,069h,065h,070h,06Fh,06Bh,065h,00h
str_Goalieknee:
        db 067h,06Fh,061h,06Ch,069h,065h,06Bh,06Eh,065h,065h,00h
str_Gokneehold:
        db 067h,06Fh,06Bh,06Eh,065h,065h,068h,06Fh,06Ch,064h,00h
str_Gofallback:
        db 067h,06Fh,066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Gofallglove:
        db 067h,06Fh,066h,061h,06Ch,06Ch,067h,06Ch,06Fh,076h,065h,00h
str_Gofallstick:
        db 067h,06Fh,066h,061h,06Ch,06Ch,073h,074h,069h,063h,06Bh,00h
str_Fakeshotf:
        db 066h,061h,06Bh,065h,073h,068h,06Fh,074h,066h,00h
str_Fakeshotb:
        db 066h,061h,06Bh,065h,073h,068h,06Fh,074h,062h,00h
str_Fakeonetimef:
        db 066h,061h,06Bh,065h,06Fh,06Eh,065h,074h,069h,06Dh,065h,066h,00h
str_Fakeonetimeb:
        db 066h,061h,06Bh,065h,06Fh,06Eh,065h,074h,069h,06Dh,065h,062h,00h
str_Blockleft:
        db 062h,06Ch,06Fh,063h,06Bh,06Ch,065h,066h,074h,00h
str_Blockright:
        db 062h,06Ch,06Fh,063h,06Bh,072h,069h,067h,068h,074h,00h
str_Blockfront:
        db 062h,06Ch,06Fh,063h,06Bh,066h,072h,06Fh,06Eh,074h,00h
str_Blockknee:
        db 062h,06Ch,06Fh,063h,06Bh,06Bh,06Eh,065h,065h,00h
str_Refelbow:
        db 072h,065h,066h,065h,06Ch,062h,06Fh,077h,00h
str_Refhistick:
        db 072h,065h,066h,068h,069h,073h,074h,069h,063h,06Bh,00h
str_ERROR:
        db 045h,052h,052h,04Fh,052h,00h
str_Null:
        db 06Eh,075h,06Ch,06Ch,00h
str_Defo:
        db 064h,065h,066h,06Fh,00h
str_Defd:
        db 064h,065h,066h,064h,00h
str_Wingd:
        db 077h,069h,06Eh,067h,064h,00h
str_Wingo:
        db 077h,069h,06Eh,067h,06Fh,00h
str_Centd:
        db 063h,065h,06Eh,074h,064h,00h
str_Cento:
        db 063h,065h,06Eh,074h,06Fh,00h
str_Score:
        db 073h,063h,06Fh,072h,065h,00h
str_Stan:
        db 073h,074h,061h,06Eh,00h
str_Exben:
        db 065h,078h,062h,065h,06Eh,00h
str_Expen:
        db 065h,078h,070h,065h,06Eh,00h
str_Bench:
        db 062h,065h,06Eh,063h,068h,00h
str_pen:
        db 070h,065h,06Eh,00h
str_Dopen:
        db 064h,06Fh,070h,065h,06Eh,00h
str_Goalie2:
        db 067h,06Fh,061h,06Ch,069h,065h,00h
str_Goalieget:
        db 067h,06Fh,061h,06Ch,069h,065h,067h,065h,074h,00h
str_Puckc:
        db 070h,075h,063h,06Bh,063h,00h
str_Nearest:
        db 06Eh,065h,061h,072h,065h,073h,074h,00h
str_Shoot:
        db 073h,068h,06Fh,06Fh,074h,00h
str_Passrec:
        db 070h,061h,073h,073h,072h,065h,063h,00h
str_3star:
        db 033h,073h,074h,061h,072h,00h
str_R3star:
        db 072h,033h,073h,074h,061h,072h,00h
str_Fowait:
        db 066h,06Fh,077h,061h,069h,074h,00h
str_Pnorm:
        db 070h,06Eh,06Fh,072h,06Dh,00h
str_Pshad:
        db 070h,073h,068h,061h,064h,00h
str_Pnothing:
        db 070h,06Eh,06Fh,074h,068h,069h,06Eh,067h,00h
str_Pface:
        db 070h,066h,061h,063h,065h,00h
str_Pface2:
        db 070h,066h,061h,063h,065h,032h,00h
str_Gamemiscon:
        db 067h,061h,06Dh,065h,06Dh,069h,073h,063h,06Fh,06Eh,00h
str_Rfaceoff:
        db 072h,066h,061h,063h,065h,06Fh,066h,066h,00h
str_Rnorm:
        db 072h,06Eh,06Fh,072h,06Dh,00h
str_Rcallpen:
        db 072h,063h,061h,06Ch,06Ch,070h,065h,06Eh,00h
str_Rpickup:
        db 072h,070h,069h,063h,06Bh,075h,070h,00h
str_Rgotofo:
        db 072h,067h,06Fh,074h,06Fh,066h,06Fh,00h
str_Rpointgoal:
        db 072h,070h,06Fh,069h,06Eh,074h,067h,06Fh,061h,06Ch,00h
str_Rgetnew:
        db 072h,067h,065h,074h,06Eh,065h,077h,00h
str_Anth:
        db 061h,06Eh,074h,068h,00h
str_Ranth:
        db 072h,061h,06Eh,074h,068h,00h
str_Agotofo:
        db 061h,067h,06Fh,074h,06Fh,066h,06Fh,00h
str_Benwait:
        db 062h,065h,06Eh,077h,061h,069h,074h,00h
str_Initper:
        db 069h,06Eh,069h,074h,070h,065h,072h,00h
str_Pgivecup:
        db 070h,067h,069h,076h,065h,063h,075h,070h,00h
str_Rpenshot:
        db 072h,070h,065h,06Eh,073h,068h,06Fh,074h,00h
str_Apswait:
        db 061h,070h,073h,077h,061h,069h,074h,00h
str_Abreak:
        db 061h,062h,072h,065h,061h,06Bh,00h
str_Error2:
        db 065h,072h,072h,06Fh,072h,00h
str_G5:
        db 047h,00h
str_LD:
        db 04Ch,044h,00h
str_RD2:
        db 052h,044h,00h
str_LW:
        db 04Ch,057h,00h
str_C6:
        db 043h,00h
str_RW:
        db 052h,057h,00h
str_XC:
        db 058h,043h,00h
str_dbgO:
        db 04Fh,00h
str_dbgDash:
        db 02Dh,00h
str_dbgClin:
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,063h,06Ch,069h,06Eh,03Dh,025h,064h,020h
        db 025h,064h,020h,00h
str_dbgPenShot:
        db 070h,073h,03Ch,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h
        db 064h,03Eh,020h,066h,028h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 029h,020h,062h,028h,025h,064h,020h,025h,064h,029h,00h
str_dbgLip:
        db 06Ch,069h,070h,020h,025h,064h,020h,00h
str_dbgHVpos:
        db 048h,056h,070h,06Fh,073h,03Ch,025h,064h,020h,025h,064h,02Ch,020h,025h,064h,020h
        db 025h,064h,03Eh,020h,00h
str_dbgRef:
        db 072h,065h,066h,03Ch,025h,064h,020h,025h,064h,03Eh,020h,00h
str_dbgPb:
        db 070h,062h,05Bh,025h,064h,020h,025h,064h,05Dh,00h
str_dbgG:
        db 047h,03Ch,025h,064h,020h,025h,064h,03Eh,020h,00h
str_dbgGO:
        db 047h,04Fh,03Dh,025h,064h,020h,050h,04Fh,03Dh,025h,064h,020h,067h,06Fh,03Dh,025h
        db 064h,020h,067h,073h,03Dh,025h,064h,020h,00h
str_dbgGsp:
        db 067h,03Dh,025h,064h,020h,025h,064h,020h,00h
str_dbgC12:
        db 063h,031h,032h,028h,025h,064h,020h,025h,064h,029h,028h,025h,064h,020h,025h,064h
        db 029h,020h,00h
str_dbgPuckc:
        db 070h,075h,063h,06Bh,063h,020h,03Dh,020h,025h,064h,020h,067h,06Dh,063h,06Ch,06Fh
        db 063h,06Bh,025h,064h,020h,067h,06Dh,070h,065h,06Eh,025h,064h,020h,070h,063h,064h
        db 077h,06Eh,03Dh,025h,064h,0Ah,00h
str_dbgIdx:
        db 025h,064h,029h,020h,00h
str_dbgD:
        db 025h,064h,020h,00h
str_dbgLbD:
        db 05Bh,025h,064h,020h,00h
str_dbgDRb:
        db 025h,064h,05Dh,020h,00h
str_dbgDS:
        db 025h,064h,020h,025h,073h,020h,00h
str_dbgPosVel:
        db 040h,028h,025h,064h,020h,025h,064h,029h,020h,076h,028h,025h,064h,020h,025h,064h
        db 029h,020h,025h,064h,028h,025h,064h,020h,025h,064h,029h,00h
str_dbgVz:
        db 076h,07Ah,025h,064h,020h,00h
str_dbgAss:
        db 041h,025h,073h,020h,00h
str_dbgL:
        db 04Ch,00h
str_dbgI:
        db 049h,00h
str_dbgSpace:
        db 020h,00h
str_dbgSpa:
        db 073h,070h,061h,03Dh,025h,064h,00h
str_dbgS:
        db 025h,073h,00h
str_debError:
        db 064h,065h,062h,045h,072h,072h,06Fh,072h,03Ah,020h,025h,064h,020h,066h,072h,061h
        db 06Dh,065h,020h,025h,064h,020h,0Ah,00h
str_newline:
        db 0Ah,00h
str_dbgBail:
        db 062h,061h,069h,06Ch,0Ah,00h
str_statslog:
        db 073h,074h,061h,074h,073h,02Eh,06Ch,06Fh,067h,00h
str_fmode_at:
        db 061h,02Bh,074h,00h
str_ErrDumpStats:
        db 065h,072h,072h,06Fh,072h,020h,064h,075h,06Dh,070h,020h,073h,074h,061h,074h,073h
        db 0Ah,00h
str_dumpPool:
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,070h,06Fh,06Fh,06Ch,028h,025h,064h,020h,025h,064h
        db 029h,020h,067h,06Dh,025h,064h,020h,03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpTmstructs:
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,074h,06Dh,073h,074h,072h,075h,063h,074h,073h,020h
        db 03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpHex:
        db 025h,078h,020h,00h
str_dumpSortcords:
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,073h,06Fh,072h,074h,063h,06Fh,072h,064h,073h,020h
        db 03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpSortLine:
        db 025h,064h,03Ah,025h,064h,05Bh,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h
        db 064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h
        db 025h,064h,020h,025h,064h,020h,025h,078h,05Dh,0Ah,00h
str_dumpRule:
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,0Ah,00h
str_dumpTeamHdrH:
        db 020h,020h,020h,020h,020h,020h,020h,073h,068h,074h,073h,020h,073h,063h,06Fh,072h
        db 065h,020h,05Bh,073h,068h,06Fh,074h,073h,020h,073h,063h,06Fh,072h,065h,05Dh,020h
        db 070h,070h,067h,020h,070h,070h,020h,070h,065h,06Eh,020h,070h,065h,06Eh,06Dh,069h
        db 06Eh,020h,061h,074h,06Fh,070h,020h,070h,061h,073h,073h,020h,070h,061h,073h,073h
        db 063h,06Fh,06Dh,070h,0Ah,00h
str_dumpHome:
        db 068h,06Fh,06Dh,065h,020h,03Ah,020h,025h,064h,020h,025h,064h,020h,05Bh,025h,064h
        db 020h,025h,064h,05Dh,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,0Ah,00h
str_dumpPlHdrH:
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,067h,020h,020h,061h,020h,020h
        db 070h,065h,06Eh,020h,02Bh,02Fh,02Dh,020h,070h,070h,067h,020h,073h,068h,067h,020h
        db 065h,06Eh,067h,020h,073h,068h,074h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpPlLineH:
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpGlHdrH:
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,06Dh,069h,06Eh,020h,073h,068h
        db 074h,020h,073h,061h,076h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpGlLine:
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,035h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpTeamHdrA:
        db 020h,020h,020h,020h,020h,020h,020h,073h,068h,074h,073h,020h,073h,063h,06Fh,072h
        db 065h,020h,05Bh,073h,068h,06Fh,074h,073h,020h,073h,063h,06Fh,072h,065h,05Dh,020h
        db 070h,070h,067h,020h,070h,070h,020h,070h,065h,06Eh,020h,070h,065h,06Eh,06Dh,069h
        db 06Eh,020h,061h,074h,06Fh,070h,020h,070h,061h,073h,073h,020h,070h,061h,073h,073h
        db 063h,06Fh,06Dh,070h,0Ah,00h
str_dumpAway:
        db 061h,077h,061h,079h,020h,03Ah,020h,025h,064h,020h,025h,064h,020h,05Bh,025h,064h
        db 020h,025h,064h,05Dh,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,0Ah,00h
str_dumpPlHdrA:
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,067h,020h,020h,061h,020h,020h
        db 070h,065h,06Eh,020h,02Bh,02Fh,02Dh,020h,070h,070h,067h,020h,073h,068h,067h,020h
        db 065h,06Eh,067h,020h,073h,068h,074h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpPlLineA:
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpGlHdrA:
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,06Dh,069h,06Eh,020h,073h,068h
        db 074h,020h,073h,061h,076h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h,00h,00h
        db 00h
