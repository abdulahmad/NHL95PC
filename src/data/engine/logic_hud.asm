; The puck, the sorted sprite list, and the pointer into the replay tape.
bits 32
%include "hockey.inc"
section s_DF7CA nobits alloc noexec write align=1
global awtmpbox, awtmcoach_d2, awtmcoach_d3, awtmcoachflags, awtmcoachmode, scpflags2
global byte_DF87F, puckasslist, puckpflags2, doorZpos2, doorpflags, byte_DFFE2, refasslist, refweight
global reflegstr, reflegspd, milestonesaid, milestonesaid_b1, milestonesaid_b3, textline1, textline2, textline3
global textline4, textline5, PlList, LinePlayersAway, fofdata2_b3, fofdata2_b7, regd1_b1, awtmcoachenergy
global awtmlines, awtmplattr, awtmglattr, awtmplstats, awtmglstats, awtmroster, awtmptrF2, awtmsort
global puckcross_m2, sctemp4, puckstruct
global sortobj15, SumCwdExciteLvl, photoptrsf, dword_E0220, dword_E0230
global ovlartbank, ovlscript, fofdata2_m2, recbpr, replayplay, dword_E03A8
global regd3_m2, regd5_m2, regd0_m3, regd1_m3, SortCords
global sortobj11, unk_DFF5E, regd4, awtmgoaliesc, puckcross
global puckcross2, puckcross6
global pucktemp1, pucknopuck
global doortemp1, refYpos2, refXvel, refYvel, refframe
global refposition, reftemp1, reftemp3, reftemp4, reftemp5, milestonesaid_b2, lcrequest
global lcreqchoice, fofdata2, fofdata2_w2, fofdata2_w4, fofdata2_w6, fofdata
global fofdata_w2, LastShooterTeam, regd2, regd3, regd5, regd0, regd1
awtmpbox:
        resb 28
awtmcoach_d2:
        resb 1
awtmcoach_d3:
        resb 1
awtmcoachflags:
        resb 1
awtmcoachmode:
        resb 1
awtmcoachenergy:
        resb 4
awtmlines:
        resb 4
awtmplattr:
        resb 4
awtmglattr:
        resb 4
awtmplstats:
        resb 4
awtmglstats:
        resb 4
awtmroster:
        resb 4
awtmptrF2:
        resb 4
awtmsort:
        resb 4
awtmgoaliesc:
        resb 4
puckcross_m2:
        resb 2
puckcross:
        resb 2
puckcross2:
        resb 1
        resb 3
puckcross6:
        resb 1
        resb 1
SortCords:
        resb 2
        resb 2
        resb 2
        resb 20
        resb 18
sctemp4:
        resb 2
        resb 16
        resb 6
        resb 1
scpflags2:
        resb 30
byte_DF87F:
        resb 669
        resb 640
sortobj11:
        resb 128
        resb 2
        resb 4
        resb 6
        resb 2
        resb 242
puckstruct:
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 8
        resb 4
puckasslist:
        resb 8
pucktemp1:
        resb 2
        resb 22
pucknopuck:
        resb 4
unk_DFF5E:
        resb 3
puckpflags2:
        resb 15
        resb 44
sortobj15:
        resb 2
        resb 2
        resb 2
        resb 4
doorZpos2:
        resb 6
        resb 2
        resb 20
doortemp1:
        resb 18
        resb 12
doorpflags:
        resb 2
byte_DFFE2:
        resb 14
        resb 44
        resb 2
        resb 4
refYpos2:
        resb 6
refXvel:
        resb 2
refYvel:
        resb 4
refframe:
        resb 8
refposition:
        resb 4
refasslist:
        resb 8
reftemp1:
        resb 4
reftemp3:
        resb 2
reftemp4:
        resb 2
reftemp5:
        resb 8
        resb 32
refweight:
        resb 1
reflegstr:
        resb 1
reflegspd:
        resb 40
SumCwdExciteLvl:
        resb 4
photoptrsf:
        resb 384
dword_E0220:
        resb 16
dword_E0230:
        resb 20
ovlartbank:
        resb 4
ovlscript:
        resb 4
milestonesaid:
        resb 1
milestonesaid_b1:
        resb 1
milestonesaid_b2:
        resb 1
milestonesaid_b3:
        resb 1
textline1:
        resb 60
textline2:
        resb 60
textline3:
        resb 60
lcrequest:
        resb 2
        resb 2
textline4:
        resb 60
textline5:
        resb 58
        resb 2
lcreqchoice:
        resb 2
        resb 2
PlList:
        resb 6
LinePlayersAway:
        resb 4
fofdata2_m2:
        resb 2
fofdata2:
        resb 2
fofdata2_w2:
        resb 1
fofdata2_b3:
        resb 1
fofdata2_w4:
        resb 2
fofdata2_w6:
        resb 1
fofdata2_b7:
        resb 1
fofdata:
        resb 2
fofdata_w2:
        resb 2
recbpr:
        resb 4
LastShooterTeam:
        resb 4
replayplay:
        resb 4
dword_E03A8:
        resb 2
        resb 2
regd2:
        resb 2
regd3_m2:
        resb 2
regd3:
        resb 2
        resb 2
regd4:
        resb 2
regd5_m2:
        resb 2
regd5:
        resb 1
regd0_m3:
        resb 1
        resb 2
regd0:
        resb 1
regd1_m3:
        resb 1
        resb 2
regd1:
        resb 1
regd1_b1:
        resb 3
