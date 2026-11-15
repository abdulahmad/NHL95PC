; Fonts, the award winners, the rink-end art, and the number shapes.
bits 32
%include "hockey.inc"
section s_D8B68 nobits alloc noexec write align=1
global fadepalbuf, byte_D9299, awardwinners, kaufmfont, pntrshapes, scor2font, mainfont, scor3font
global joyrawbits, numshapes, spritedrawcount, gfxidlist, rinkendbank, frameaccum, rinkendart, dword_D8C72
global viewscrolly, hudhundaccum, dword_D8C7A, viewscrollx, numshpbank, curperiod, joyqueue, cupteam
global presidentsteam, awardwinners_e01, awardwinners_e02, awardwinners_e03, awardwinners_e04, awardwinners_e05
global awardwinners_e06, awardwinners_e08, awardwinners_e09, awardstats9g, awardstats5, awardstats4, awardstats8, awardstats2
global awardstats1, awardstats9, awardstats3, awardstats0, awardstats6
kaufmfont:
resb 4
pntrshapes:
resb 4
scor2font:
resb 4
mainfont:
resb 4
scor3font:
resb 4
joyrawbits:
resb 4
joyqueue:
resb 152
numshapes:
resb 40
spritedrawcount:
resb 12
gfxidlist:
resb 28
rinkendbank:
resb 4
frameaccum:
resb 4
rinkendart:
resb 2
dword_D8C72:
resb 2
viewscrolly:
resb 4
hudhundaccum:
resb 2
dword_D8C7A:
resb 2
viewscrollx:
resb 4
numshpbank:
resb 4
curperiod:
resb 4
fadepalbuf:
resb 768
cupteam:
resb 5
resb 739
presidentsteam:
resb 5
resb 36
byte_D9299:
resb 703
awardwinners:
resb 52
awardwinners_e01:
resb 52
awardwinners_e02:
resb 52
awardwinners_e03:
resb 52
awardwinners_e04:
resb 52
awardwinners_e05:
resb 52
awardwinners_e06:
resb 104
awardwinners_e08:
resb 52
awardwinners_e09:
resb 104
awardstats9g:
resb 54
awardstats5:
resb 54
awardstats4:
resb 54
awardstats8:
resb 47
awardstats2:
resb 47
awardstats1:
resb 47
awardstats9:
resb 47
awardstats3:
resb 47
awardstats0:
resb 47
awardstats6:
resb 48
