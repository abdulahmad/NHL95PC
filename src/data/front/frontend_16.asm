; Which device each pad is, the hot-key state, and the shot and goal counters for the two teams.
bits 32
%include "hockey.inc"
section s_C4D18 progbits alloc noexec write align=1
extern TeamList, str_ArtHart, str_ArtRoss, str_ArtNorr, str_ArtSelk, str_ArtVezi, str_ArtJenn, str_ArtCald
extern str_ArtPres, str_ArtConn, str_ArtEasn, str_ArtStan, unk_C0243, unk_C0248, unk_C0251, unk_C0258
extern unk_C025E, unk_C0265, unk_C026E, unk_C0275, unk_C0280, unk_C028C, unk_C029A, unk_C02A7
extern unk_C02BC, unk_C02CA, unk_C02D9, unk_C02E9, unk_C0300, unk_C0310, unk_C032B, unk_C0337
extern unk_C0352, unk_C0362, unk_C0379, unk_C0390, unk_C0397, BOS, BUF, CGY
extern CHI, DET, EDM, HFD, LA, DAL, MTL, NJ
extern NYI, NYR, OTT, PHI, PIT, QUE, STL, SJ
extern TB, TOR, VAN, WSH, WPG, ANA, FLA, ASW
extern ASE, Buffalo, Calgary, Chicago, Detroit, Edmonton, Hartford, LosAngeles
extern Dallas, Montreal, NewJersey, NYIslanders, NYRangers, Ottawa, Philadelphia, Pittsburgh
extern Quebec, StLouis, SanJose, TampaBay, Toronto, Vancouver, Washington, Winnipeg
extern Anaheim, Florida, AllStarsWest, AllStarsEast, unk_D97CA, unk_D9800, unk_D9836, unk_D9865
extern unk_D9894, unk_D98C3, unk_D98F2, unk_D9921, unk_D9950
global str_D02d, str_D01d, pad1dev, pad2dev, lasthotkey, byte_C5138, awardtype, keydirtab
global byte_C541B, byte_C5424
global byte_C5425, byte_C5426, byte_C5427, hmgoalcnt, hmshotcnt, awgoalcnt, awshotcnt, joyqtick
global samesideflag, inputframes, escrequest, joyrec, palfadedin, screenw, screenh, demomode
global dword_C5131, dword_C5133, dword_C5135, dword_C513C, dword_C5168
global postate
global lgstate
global gameresult, gamemode, gameopts, ctl1team, ctl2team, ctl1dev, ctl2dev, ctl1side
global ctl2side, sounddev, awardart, awardnames, awardtitles, off_C524F, off_C5253, off_C5257
global off_C525B, off_C525F, off_C5263, off_C5267, off_C526F, off_C5273, off_C527B, teamabbrevs
global off_C5441, teamcitynames, unk_C4E30, str_fmtpd, exhstate, unk_C5423, unk_C542E
global word_C5428
joyqtick:
db 00h,00h,00h,00h
pad1dev:
db 08h
pad2dev:
db 02h
lasthotkey:
db 00h
keydirtab:
db 08h,00h,04h,08h,02h,01h,03h,02h,06h,07h,05h,06h,08h,00h,04h
db 08h,00h,0DCh,07Bh,00h,00h,0CFh,0BDh,00h,00h,0F7h,00h,00h,00h,0C0h,08h
db 00h,00h,062h,04h,00h,00h,00h,00h,00h,00h,0DFh,0FFh,00h,00h,0FFh,0DFh
db 00h,00h,0FFh,0FFh,00h,00h,00h,00h,00h,00h,0FEh,0EFh,00h,00h,0FFh,0FFh
db 00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh
db 00h,00h,0FCh,0FCh,00h,00h,0FFh,0FFh,00h,00h,0FBh,0FFh,00h,00h,0FFh,0FFh
db 00h,00h,0FBh,0FFh,00h,00h,0FFh,0FFh,00h,00h,01Fh,00h,00h,00h,07Ch,0FEh
db 00h,00h,051h,013h,00h,00h,0DBh,0B6h,00h,00h,0EDh,0FFh,00h,00h,0FFh,0FFh
db 00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh
db 00h,00h,00h,00h,00h,00h,080h,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh
db 00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh,00h,00h,0FFh,0FFh
db 00h,00h,0FFh,03h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
samesideflag:
db 00h,00h,00h,00h
inputframes:
db 00h,00h,00h,00h
escrequest:
db 00h,00h,00h,00h
joyrec:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
palfadedin:
db 00h,00h,00h,00h
screenw:
db 080h,02h,00h,00h
screenh:
db 0E0h,01h,00h,00h
unk_C4E30:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
demomode:
db 00h
dword_C5131:
db 00h,00h
dword_C5133:
db 00h,01h
dword_C5135:
db 0Fh,01h,0FFh
byte_C5138:
db 011h,0FFh,00h,00h
dword_C513C:
db 0E9h,00h,00h,00h,09Dh,00h,00h,00h,01h,00h,00h,00h,0ACh,00h,00h,00h
db 0C4h,00h,00h,00h,0C2h,00h,00h,00h,0E3h,00h,00h,00h,062h,00h,00h,00h
db 04h,00h,00h,00h,05Bh,00h,00h,00h,014h,00h,00h,00h
dword_C5168:
db 0CEh,01h,00h,00h,0CFh,01h,00h,00h,0CBh,01h,00h,00h,0CCh,01h,00h,00h
db 0C9h,01h,00h,00h,0CAh,01h,00h,00h,0D1h,01h,00h,00h,0CDh,01h,00h,00h
db 0D2h,01h,00h,00h,0D0h,01h,00h,00h,0D3h,01h,00h,00h
awardart:
dd str_ArtHart
dd str_ArtRoss
dd str_ArtNorr
dd str_ArtSelk
dd str_ArtVezi
dd str_ArtJenn
dd str_ArtCald
dd str_ArtPres
dd str_ArtConn
dd str_ArtEasn
dd str_ArtStan
awardnames:
dd unk_C0243
dd unk_C0248
dd unk_C0251
dd unk_C0258
dd unk_C025E
dd unk_C0265
dd unk_C026E
dd unk_C0275
dd unk_C0280
dd unk_C028C
dd unk_C029A
awardtitles:
dd unk_C02A7
db 00h,00h,00h,00h
dd unk_C02BC
dd unk_C02CA
dd unk_C02D9
db 00h,00h,00h,00h
dd unk_C02E9
db 00h,00h,00h,00h
dd unk_C0300
db 00h,00h,00h,00h
dd unk_C0310
db 00h,00h,00h,00h
dd unk_C032B
db 00h,00h,00h,00h
dd unk_C0337
db 00h,00h,00h,00h
dd unk_C02A7
dd unk_C0352
dd unk_C0362
db 00h,00h,00h,00h
dd unk_C0379
db 00h,00h,00h,00h
awardtype:
db 01h,01h,01h,01h,00h,00h,01h,02h,01h
db 01h,02h
off_C524F:
dd unk_D9921
off_C5253:
dd unk_D9894
off_C5257:
dd unk_D9865
off_C525B:
dd unk_D98F2
off_C525F:
dd unk_D9800
off_C5263:
dd unk_D97CA
off_C5267:
dd unk_D9950
db 00h,00h,00h,00h
off_C526F:
dd unk_D9836
off_C5273:
dd unk_D98C3
db 00h,00h,00h,00h
off_C527B:
dd unk_C0390
dd unk_C0397
str_fmtpd:
db 025h,064h,00h
str_D02d:
db 025h,064h,02Eh,025h,030h,032h,064h,00h
str_D01d:
db 025h,064h,02Eh,025h,030h,031h,064h,00h,00h,00h
exhstate:
db 00h,00h,00h,00h
db 02Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 0Ch,00h,00h,00h
db 015h,00h,00h,00h,0FFh
db 07Bh,00h,00h
db 0FFh,0FFh,0FFh,0FFh
db 0FEh,0FFh,0FFh,0FFh
db 010h,00h,00h,00h
db 010h,00h,00h,00h
db 00h,00h,00h,00h
db 01h,00h,00h,00h
postate:
db 01h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 0Ch,00h,00h,00h
db 015h,00h,00h,00h
db 0FFh
db 079h,00h,00h
db 0FFh,0FFh,0FFh,0FFh
db 0FEh,0FFh,0FFh,0FFh
db 010h,00h,00h,00h
db 010h,00h,00h,00h
db 00h,00h,00h,00h
db 01h,00h,00h,00h
lgstate:
db 02h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,025h,073h,02Eh
db 064h,062h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 0Ch,00h,00h,00h
db 015h,00h,00h,00h
db 0FFh
db 07Bh,00h,00h
db 0FFh,0FFh,0FFh,0FFh
db 0FEh,0FFh,0FFh,0FFh
db 010h,00h,00h,00h
db 010h,00h,00h,00h
db 00h,00h,00h,00h
db 01h,00h,00h,00h
gameresult:
db 00h,00h,00h,00h
gamemode:
db 00h,00h,00h,00h
gameopts:
db 0FFh
db 07Bh,00h,00h
ctl1team:
db 0FFh,0FFh,0FFh,0FFh
ctl2team:
db 0FEh,0FFh,0FFh,0FFh
ctl1dev:
db 010h,00h,00h,00h
ctl2dev:
db 010h,00h,00h,00h
ctl1side:
db 00h,00h,00h,00h
ctl2side:
db 01h,00h,00h,00h
byte_C541B:
db 0FFh,00h,00h,00h
sounddev:
db 010h,00h,00h,00h
unk_C5423:
db 00h
byte_C5424:
db 00h
byte_C5425:
db 00h
byte_C5426:
db 00h
byte_C5427:
db 00h
word_C5428:
db 00h,00h,00h,00h,00h,00h
unk_C542E:
db 04h
hmgoalcnt:
db 00h
hmshotcnt:
db 00h
awgoalcnt:
db 00h
awshotcnt:
db 00h,00h,00h,00h,00h,00h,00h
teamabbrevs:
dd BOS
dd BUF
off_C5441:
dd CGY
dd CHI
dd DET
dd EDM
dd HFD
dd LA
dd DAL
dd MTL
dd NJ
dd NYI
dd NYR
dd OTT
dd PHI
dd PIT
dd QUE
dd STL
dd SJ
dd TB
dd TOR
dd VAN
dd WSH
dd WPG
dd ANA
dd FLA
dd ASW
dd ASE
teamcitynames:
dd TeamList
dd Buffalo
dd Calgary
dd Chicago
dd Detroit
dd Edmonton
dd Hartford
dd LosAngeles
dd Dallas
dd Montreal
dd NewJersey
dd NYIslanders
dd NYRangers
dd Ottawa
dd Philadelphia
dd Pittsburgh
dd Quebec
dd StLouis
dd SanJose
dd TampaBay
dd Toronto
dd Vancouver
dd Washington
dd Winnipeg
dd Anaheim
dd Florida
dd AllStarsWest
dd AllStarsEast
