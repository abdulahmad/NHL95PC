; Scoreboard sprites, the statistics sort orders, and the away roster.
bits 32
%include "hockey.inc"
section s_DB7EC nobits alloc noexec write align=1
global awroster, byte_DB7F1, hmgoalieidx, hmscratch, byte_DC264, byte_DC265, byte_DC266
global byte_DC267, byte_DC268, hmteamrec_skaters, hmteamrec_goalies, s1font, schedgameidx, pointerspr, dword_DC23E
global linesprites, hudhundstep, penaltydigits, dword_DC2B8, hmpanelspr, awpanelspr, scoredigits, scrbrdshapes
global clockdigits, clockcolon, cupseries, dword_DC33C, statsteamorder, dword_DC6A8, sfpal2, sfpal1
global dword_DC6B4, statsnumgoalies, statsskaterorder, statsgoalieorder, dword_DC734, leaguestatsmode, statsgoalieplr, statsnumskaters
global statsskaterplr, playofftree, hmteamrec, unk_DBD1C, awteamrec
global hmlinetab, hmglstats, awglstats, hmlineind, awlineind, unk_DC340, hmglstats_w2
global hmglstats_w4, hmglstats_w8, hmglstats_w14
awroster:
resb 5
byte_DB7F1:
resb 1087
hmteamrec:
resb 5
resb 71
hmteamrec_skaters:
resb 100
hmteamrec_goalies:
resb 12
resb 48
unk_DBD1C:
resb 508
awteamrec:
resb 5
resb 183
resb 556
hmlinetab:
resb 36
hmgoalieidx:
resb 1
resb 3
hmscratch:
resb 8
s1font:
resb 4
schedgameidx:
resb 4
pointerspr:
resb 6
dword_DC23E:
resb 2
hmglstats:
resb 2
hmglstats_w2:
resb 2
hmglstats_w4:
resb 4
hmglstats_w8:
resb 6
hmglstats_w14:
resb 4
awglstats:
resb 18
byte_DC264:
resb 1
byte_DC265:
resb 1
byte_DC266:
resb 1
byte_DC267:
resb 1
byte_DC268:
resb 4
linesprites:
resb 32
hudhundstep:
resb 4
penaltydigits:
resb 40
dword_DC2B8:
resb 4
hmpanelspr:
resb 4
awpanelspr:
resb 4
scoredigits:
resb 44
scrbrdshapes:
resb 4
hmlineind:
resb 12
awlineind:
resb 12
clockdigits:
resb 40
clockcolon:
resb 4
cupseries:
resb 4
dword_DC33C:
resb 4
unk_DC340:
resb 768
statsteamorder:
resb 104
dword_DC6A8:
resb 4
sfpal2:
resb 4
sfpal1:
resb 4
dword_DC6B4:
resb 4
statsnumgoalies:
resb 4
statsskaterorder:
resb 100
statsgoalieorder:
resb 20
dword_DC734:
resb 4
leaguestatsmode:
resb 4
statsgoalieplr:
resb 20
statsnumskaters:
resb 4
statsskaterplr:
resb 100
playofftree:
resb 4
