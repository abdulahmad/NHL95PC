; Replay bookkeeping, and the name lists the debug dump prints.
bits 32
%include "hockey.inc"
section s_CD34C progbits alloc noexec write align=1
extern str_pen, unk_C1B49, str_Roughing, str_Charging2, str_Slashing2, str_Xcheck, str_Hooking2, str_Tripping2
extern str_Interfer, str_Holding2, str_Histick, str_Boarding2, str_Elbowing2, str_Abuse, str_Checkbnd, str_Penshot
extern str_BnReturnGoalie, str_BnPullGoalie, str_BnFaceOff, str_BnTwoLinePass, str_BnOffside, str_BnIcing, str_BnPenalty, str_BnPenaltyShot
extern str_Gready, str_Gready2, str_Gglover, str_Gglovel, str_Gglovel2, str_Gstickr, str_Gstickl, str_Gstackr
extern str_Gstackl, str_Gdive, str_Gswing, str_Gskate, str_Pflip, str_Glide, str_Skatewp, str_Skate
extern str_Turnl, str_Turnr, str_Stop, str_Passf, str_Passb, str_Shotf, str_Shotb, str_Glideback
extern str_Skateback, str_Sweepchk, str_Shoulderchkl, str_Shoulderchkr, str_Hipchkl, str_Hipchkr, str_Burst, str_Hold
extern str_Hold2, str_Flail, str_Fallfwd, str_Fallback, str_Celebrate, str_Pump, str_Wallright, str_Wallleft
extern str_Faceoff, str_Faceoffr, str_Siren, str_Bglass, str_Stanley2, str_Catch, str_Hook, str_Hook2
extern str_Stumble, str_Fake, str_Flip, str_Injury1, str_Refglide, str_Refskate, str_Refturnl, str_Refturnr
extern str_Refstop, str_Reffallback, str_Armupglide, str_Armupskate, str_Armupturnl, str_Armupturnr, str_Armupstop, str_Refpickup
extern str_Refpointgoa, str_Refdrop, str_Reffowait, str_Refrough, str_Refcharge, str_Refslash, str_Refxcheck, str_Refhook
extern str_Reftrip, str_Refinterfer, str_Refhold, str_Refabuseoff, str_Refbehind, str_Faceoffpoke, str_Gwallright, str_Gwallleft
extern str_Anthem1, str_Anthem2, str_Anthem3, str_Anthem4, str_Anthem5, str_Drink, str_Refanthem1, str_Refanthem2
extern str_Onetimef, str_Onetimeb, str_Getcup, str_Brcup, str_Gvcup, str_Clap, str_Stansk, str_Crosscheck
extern str_Boardback, str_Boardfront, str_Boardright, str_Boardleft, str_Benchcheckr, str_Benchcheckl, str_Refpenshot, str_Goaliepoke
extern str_Goalieknee, str_Gokneehold, str_Gofallback, str_Gofallglove, str_Gofallstick, str_Fakeshotf, str_Fakeshotb, str_Fakeonetimef
extern str_Fakeonetimeb, str_Blockleft, str_Blockright, str_Blockfront, str_Blockknee, str_Refelbow, str_Refhistick, str_ERROR
extern str_Null, str_Defo, str_Defd, str_Wingd, str_Wingo, str_Centd, str_Cento, str_Score
extern str_Stan, str_Exben, str_Expen, str_Bench, str_Dopen, str_Goalie2, str_Goalieget, str_Puckc
extern str_Nearest, str_Shoot, str_Passrec, str_3star, str_R3star, str_Fowait, str_Pnorm, str_Pshad
extern str_Pnothing, str_Pface, str_Pface2, str_Gamemiscon, str_Rfaceoff, str_Rnorm, str_Rcallpen, str_Rpickup
extern str_Rgotofo, str_Rpointgoal, str_Rgetnew, str_Anth, str_Ranth, str_Agotofo, str_Benwait, str_Initper
extern str_Pgivecup, str_Rpenshot, str_Apswait, str_Abreak, str_Error2, str_G5, str_LD, str_RD2
extern str_LW, str_C6, str_RW, str_XC, str_sp00XXXXXXXXXXXXXXXXX, str_sp00XXXXXXXXXXXXXXXXX2, str_spNONE, str_sp00XXXXXXXXXXXXXXXXX3
extern str_sp00XXXXXXXXXXXXXXXXX4, str_spNONE2
global byte_CD418, byte_CD421, byte_CD473, gsumqcount, defercount, dword_CD41E, ovlmemneed, dbg_spalist
global dword_CD9A0, pennametab, off_CD498, off_CD4A0, bannerstrs, off_CD4FA, dbg_spanames, dbg_assnames
global dbg_posnames, penbannertab, word_CD4FC, replaytick, replaysfx
gsumqcount:
db 00h,00h,00h,00h
defercount:
db 00h,00h,00h,00h
pennametab:
dd str_Roughing
dd unk_C1B49
dd str_Charging2
dd str_Slashing2
dd str_Roughing
dd str_Xcheck
dd str_Hooking2
dd str_Tripping2
dd str_Interfer
dd str_Holding2
dd str_Histick
dd str_Boarding2
dd str_Elbowing2
dd str_Abuse
dd str_Checkbnd
dd str_Boarding2
dd str_Elbowing2
dd str_Penshot
penbannertab:
db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,02h,00h,00h,00h
db 02h,00h,00h,00h,02h,00h,00h,00h,05h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
db 04h,00h,00h,00h,06h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,06h,00h,00h,00h
db 06h,00h,00h,00h,06h,00h,00h,00h,06h,00h,00h,00h,06h,00h,00h,00h
db 06h,00h,00h,00h,06h,00h,00h,00h,06h,00h,00h,00h,06h,00h,00h,00h
db 06h,00h,00h,00h,06h,00h,00h,00h,06h,00h,00h,00h,06h,00h,00h,00h
db 06h,00h,00h,00h,06h,00h,00h,00h,07h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
db 06h,00h,00h,00h,03h,00h,00h,00h,02h,00h,00h,00h
byte_CD418:
db 00h,00h,02h,01h,01h,00h
dword_CD41E:
db 00h,01h,00h
byte_CD421:
db 00h,03h,06h,09h,0FFh,01h,04h,07h,0Ah,0FFh,02h,05h,08h,0Bh,0FFh,0Ch
db 0Eh,010h,0FFh,0Dh,0Fh,011h,0FFh,012h,017h,00h,03h,06h,09h,0FFh,013h,018h
db 01h,04h,07h,0Ah,0FFh,014h,019h,02h,05h,08h,0Bh,0FFh,015h,01Ah,0Ch,0Eh
db 010h,0FFh,016h,01Bh,0Dh,0Fh,011h,0FFh,01Ch,020h,00h,03h,06h,09h,0FFh,01Dh
db 021h,01h,04h,07h,0Ah,0FFh,01Eh,022h,0Ch,0Eh,010h,0FFh,01Fh,023h,0Dh,0Fh
db 011h,0FFh
byte_CD473:
db 00h,05h,0Ah,00h,05h,0Ah,00h,05h,0Ah,00h,05h,0Ah,0Fh,013h,0Fh,013h
db 0Fh,013h,017h,01Eh,025h,02Ch,032h,017h,01Eh,025h,02Ch,032h,038h,03Fh,046h,04Ch
db 038h,03Fh,046h,04Ch,00h
off_CD498:
dd str_sp00XXXXXXXXXXXXXXXXX
dd str_sp00XXXXXXXXXXXXXXXXX2
off_CD4A0:
dd str_spNONE
dd str_sp00XXXXXXXXXXXXXXXXX3
dd str_sp00XXXXXXXXXXXXXXXXX4
dd str_spNONE2
ovlmemneed:
db 0Dh,0ACh,00h,00h,0CDh,05Ch,00h,00h,0A5h,050h,00h,00h,0AAh,050h,00h,00h
db 023h,03Ch,00h,00h,07Bh,04Fh,00h,00h,084h,06Dh,00h,00h,0D1h,037h,01h,00h
db 0D5h,0D0h,01h,00h,075h,0C4h,00h,00h,0C5h,0C7h,01h,00h
bannerstrs:
dd str_BnReturnGoalie
dd str_BnPullGoalie
dd str_BnFaceOff
dd str_BnTwoLinePass
dd str_BnOffside
dd str_BnIcing
dd str_BnPenalty
off_CD4FA equ $+2
dd str_BnPenaltyShot
word_CD4FC:
db 0FFh,0FFh
replaytick:
db 01h,00h
replaysfx:
db 0FFh,0FFh,00h,00h
dbg_spalist:
db 01h,00h,00h,00h,099h,00h,00h,00h,0B1h,00h,00h,00h,0C9h,00h,00h,00h
db 0E1h,00h,00h,00h,01h,01h,00h,00h,019h,01h,00h,00h,031h,01h,00h,00h
db 059h,01h,00h,00h,081h,01h,00h,00h,0B9h,01h,00h,00h,0F1h,01h,00h,00h
db 039h,02h,00h,00h,089h,02h,00h,00h,0A1h,02h,00h,00h,0E9h,02h,00h,00h
db 031h,03h,00h,00h,049h,03h,00h,00h,061h,03h,00h,00h,089h,03h,00h,00h
db 0C1h,03h,00h,00h,0F9h,03h,00h,00h,091h,04h,00h,00h,029h,05h,00h,00h
db 041h,05h,00h,00h,089h,05h,00h,00h,0C1h,05h,00h,00h,0D9h,05h,00h,00h
db 0F1h,05h,00h,00h,09h,06h,00h,00h,021h,06h,00h,00h,039h,06h,00h,00h
db 051h,06h,00h,00h,069h,06h,00h,00h,081h,06h,00h,00h,0D9h,06h,00h,00h
db 031h,07h,00h,00h,069h,07h,00h,00h,0A1h,07h,00h,00h,0BFh,07h,00h,00h
db 0DDh,07h,00h,00h,0F1h,07h,00h,00h,0FDh,07h,00h,00h,021h,08h,00h,00h
db 033h,08h,00h,00h,04Bh,08h,00h,00h,073h,08h,00h,00h,08Bh,08h,00h,00h
db 0D3h,08h,00h,00h,02Bh,09h,00h,00h,093h,09h,00h,00h,0Bh,0Ah,00h,00h
db 05Bh,0Ah,00h,00h,073h,0Ah,00h,00h,0BBh,0Ah,00h,00h,0D3h,0Ah,00h,00h
db 0EBh,0Ah,00h,00h,013h,0Bh,00h,00h,04Bh,0Bh,00h,00h,063h,0Bh,00h,00h
db 0ABh,0Bh,00h,00h,0C3h,0Bh,00h,00h,0DBh,0Bh,00h,00h,03h,0Ch,00h,00h
db 01Bh,0Ch,00h,00h,043h,0Ch,00h,00h,057h,0Ch,00h,00h,063h,0Ch,00h,00h
db 073h,0Ch,00h,00h,08Bh,0Ch,00h,00h,09Bh,0Ch,00h,00h,0ABh,0Ch,00h,00h
db 0BBh,0Ch,00h,00h,0CBh,0Ch,00h,00h,0D9h,0Ch,00h,00h,0E7h,0Ch,00h,00h
db 0F5h,0Ch,00h,00h,05h,0Dh,00h,00h,015h,0Dh,00h,00h,02Dh,0Dh,00h,00h
db 045h,0Dh,00h,00h,057h,0Dh,00h,00h,067h,0Dh,00h,00h,07Bh,0Dh,00h,00h
db 089h,0Dh,00h,00h,097h,0Dh,00h,00h,0ABh,0Dh,00h,00h,0C3h,0Dh,00h,00h
db 0D3h,0Dh,00h,00h,02Bh,0Eh,00h,00h,083h,0Eh,00h,00h,097h,0Eh,00h,00h
db 0A9h,0Eh,00h,00h,0B5h,0Eh,00h,00h,0CBh,0Eh,00h,00h,0D7h,0Eh,00h,00h
db 0Fh,0Fh,00h,00h,055h,0Fh,00h,00h,09Bh,0Fh,00h,00h,0E1h,0Fh,00h,00h
db 027h,010h,00h,00h,055h,010h,00h,00h,083h,010h,00h,00h,095h,010h,00h,00h
db 0CDh,010h,00h,00h,035h,011h,00h,00h,09Dh,011h,00h,00h,0D5h,011h,00h,00h
db 01Dh,012h,00h,00h,065h,012h,00h,00h,0DDh,012h,00h,00h,055h,013h,00h,00h
db 08Dh,013h,00h,00h,0C5h,013h,00h,00h,01Dh,014h,00h,00h,075h,014h,00h,00h
db 0ADh,014h,00h,00h,0E5h,014h,00h,00h,0F9h,014h,00h,00h,0Dh,015h,00h,00h
dbg_spanames:
dd str_Gready
dd str_Gready2
dd str_Gglover
dd str_Gglovel
dd str_Gglovel2
dd str_Gstickr
dd str_Gstickl
dd str_Gstackr
dd str_Gstackl
dd str_Gdive
dd str_Gswing
dd str_Gskate
dd str_Pflip
dd str_Glide
dd str_Skatewp
dd str_Skate
dd str_Turnl
dd str_Turnr
dd str_Stop
dd str_Passf
dd str_Passb
dd str_Shotf
dd str_Shotb
dd str_Glideback
dd str_Skateback
dd str_Sweepchk
dd str_Shoulderchkl
dd str_Shoulderchkr
dd str_Hipchkl
dd str_Hipchkr
dd str_Burst
dd str_Hold
dd str_Hold2
dd str_Flail
dd str_Fallfwd
dd str_Fallback
dd str_Celebrate
dd str_Pump
dd str_Wallright
dd str_Wallleft
dd str_Faceoff
dd str_Faceoffr
dd str_Siren
dd str_Bglass
dd str_Stanley2
dd str_Catch
dd str_Hook
dd str_Hook2
dd str_Stumble
dd str_Fake
dd str_Flip
dd str_Injury1
dd str_Refglide
dd str_Refskate
dd str_Refturnl
dd str_Refturnr
dd str_Refstop
dd str_Reffallback
dd str_Armupglide
dd str_Armupskate
dd str_Armupturnl
dd str_Armupturnr
dd str_Armupstop
dd str_Refpickup
dd str_Refpointgoa
dd str_Refdrop
dd str_Reffowait
dd str_Refrough
dd str_Refcharge
dd str_Refslash
dd str_Refxcheck
dd str_Refhook
dd str_Reftrip
dd str_Refinterfer
dd str_Refhold
dd str_Refabuseoff
dd str_Refbehind
dd str_Faceoffpoke
dd str_Gwallright
dd str_Gwallleft
dd str_Anthem1
dd str_Anthem2
dd str_Anthem3
dd str_Anthem4
dd str_Anthem5
dd str_Drink
dd str_Refanthem1
dd str_Refanthem2
dd str_Onetimef
dd str_Onetimeb
dd str_Getcup
dd str_Brcup
dd str_Gvcup
dd str_Clap
dd str_Stansk
dd str_Crosscheck
dd str_Boardback
dd str_Boardfront
dd str_Boardright
dd str_Boardleft
dd str_Benchcheckr
dd str_Benchcheckl
dd str_Refpenshot
dd str_Goaliepoke
dd str_Goalieknee
dd str_Gokneehold
dd str_Gofallback
dd str_Gofallglove
dd str_Gofallstick
dd str_Fakeshotf
dd str_Fakeshotb
dd str_Fakeonetimef
dd str_Fakeonetimeb
dd str_Blockleft
dd str_Blockright
dd str_Blockfront
dd str_Blockknee
dd str_Refelbow
dd str_Refhistick
dd str_ERROR
dbg_assnames:
dd str_Null
dd str_Defo
dd str_Defd
dd str_Wingd
dd str_Wingo
dd str_Centd
dd str_Cento
dd str_Score
dd str_Stan
dd str_Exben
dd str_Expen
dd str_Bench
dd str_pen
dd str_Dopen
dd str_Goalie2
dd str_Goalieget
dd str_Puckc
dd str_Nearest
dd str_Shoot
dd str_Passrec
dd str_3star
dd str_R3star
dd str_Fowait
dd str_Faceoff
dd str_Pnorm
dd str_Pshad
dd str_Pnothing
dd str_Pface
dd str_Pface2
dd str_Gamemiscon
dd str_Rfaceoff
dd str_Rnorm
dd str_Rcallpen
dd str_Rpickup
dd str_Rgotofo
dd str_Rpointgoal
dd str_Rgetnew
dd str_Anth
dd str_Ranth
dd str_Agotofo
dd str_Benwait
dd str_Initper
dd str_Getcup
dd str_Pgivecup
dd str_Rpenshot
dd str_Apswait
dd str_Abreak
dd str_Error2
dbg_posnames:
dd str_G5
dd str_LD
dd str_RD2
dd str_LW
dd str_C6
dd str_RW
dd str_XC
dword_CD9A0:
db 00h,00h,024h,0FFh,0B0h,0FFh,079h,0FFh,019h,00h,09Ch,0FFh,092h,0FFh,0C9h,0FFh
db 01Eh,00h,0DCh,0FFh,050h,00h,0B8h,0FFh,00h,00h,0DCh,00h,028h,00h,052h,00h
db 0C2h,0FFh,048h,00h,06Eh,00h,024h,00h,0F1h,0FFh,09h,00h,0C9h,0FFh,00h,00h
