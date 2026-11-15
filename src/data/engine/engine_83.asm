; Both teams while a game is on: lines, goalies, rosters, and scores.
bits 32
%include "hockey.inc"
section s_DF63E nobits alloc noexec write align=1
global hmtmgoalie_b1, hmtmflags, hmtmpbox, hmtmcoach_d2, hmtmcoach_d3, hmtmcoachflags, hmtmcoachmode, awtmflags
global hmtmextra, hmtmtouch2, hmtmtouch3, hmtmnear, hmtmpdst_m2, hmtmpdst_gl_m2, hmtmcoachenergy, hmtmlines
global hmtmplattr, hmtmglattr, hmtmplstats, hmtmglstats, hmtmroster, hmtmptrF2, hmtmsort
global awtmstruct
global awtmtouch3, awtmnear, hmtmline, hmtmlcnt, hmtmtouch1, hmtmap, hmtmgoalie
global hmtmnearpl, hmtmpde, hmtmpdst, hmtmgoaliesc, awscore, awtmline, awtmlcnt, awtmextra
global awtmtouch1, awtmtouch2, awtmap, awtmgoalie, awtmnearpl
hmtmline:
        resb 2
hmtmlcnt:
        resb 2
hmtmextra:
        resb 2
hmtmtouch1:
        resb 2
hmtmtouch2:
        resb 2
hmtmtouch3:
        resb 2
hmtmap:
        resb 2
hmtmgoalie:
        resb 1
hmtmgoalie_b1:
        resb 5
hmtmnear:
        resb 4
hmtmnearpl:
        resb 2
hmtmflags:
        resb 2
hmtmpde:
        resb 54
hmtmpdst_m2:
        resb 2
hmtmpdst:
        resb 48
hmtmpdst_gl_m2:
        resb 8
hmtmpbox:
        resb 28
hmtmcoach_d2:
        resb 1
hmtmcoach_d3:
        resb 1
hmtmcoachflags:
        resb 1
hmtmcoachmode:
        resb 1
hmtmcoachenergy:
        resb 4
hmtmlines:
        resb 4
hmtmplattr:
        resb 4
hmtmglattr:
        resb 4
hmtmplstats:
        resb 4
hmtmglstats:
        resb 4
hmtmroster:
        resb 4
hmtmptrF2:
        resb 4
hmtmsort:
        resb 4
hmtmgoaliesc:
        resb 4
        resb 2
awtmstruct:
        resb 2
        resb 6
        resb 2
        resb 2
        resb 2
        resb 2
awscore:
        resb 20
        resb 2
        resb 2
        resb 2
awtmline:
        resb 2
awtmlcnt:
        resb 2
awtmextra:
        resb 2
awtmtouch1:
        resb 2
awtmtouch2:
        resb 2
awtmtouch3:
        resb 2
awtmap:
        resb 2
awtmgoalie:
        resb 6
awtmnear:
        resb 4
awtmnearpl:
        resb 2
awtmflags:
        resb 2
