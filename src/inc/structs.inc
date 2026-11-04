; NHL 95 PC structure field offsets, written as the 93 Genesis names (see tools/names/struct_fieldmap.csv for the evidence).
; Equates only. Use them in operands with the original displacement size: [byte esi+Xvel], not [esi+0Ch]; the
; assembled bytes must not change. A field that is a 16.16 long on Genesis and 68k-word-aligned there is often read
; with the Watcom -5r short load: mov edx, [byte ecx+Xvel-2] sar edx, 10h loads the word Xvel (sign-extended).
; 'size b/w/d' is the PC access size (tools/struct_operands.py matches operands by offset and size). A 'size d' field
; is a 16.16 value; its integer word is Field+2 ([byte ebx+Xpos+2]).
; Add a field here and a row in tools/names/struct_fieldmap.csv in the same commit. An equate nothing uses may stay.

; ---- player structure. Pointer usually in eax/ecx/esi/edi.
Xpos       equ 00h   ; size d
Ypos       equ 04h   ; size d
OldXpos    equ 74h   ; size d
OldYpos    equ 78h   ; size d; 93G OldYpos: updateplayers saves Ypos here
OldZpos    equ 7Ch   ; size d; 93G OldZpos: updateplayers saves Zpos here
Zpos       equ 08h   ; size d; defaultsprites_0 writes the integer word at +0Ah from the zcord column, as it writes Xpos+2 Ypos+2 from xcord ycord
Xvel       equ 0Ch   ; size w
Yvel       equ 0Eh   ; size w
Zvel       equ 10h   ; size w; puckbody clears the puck's word at +10h
position   equ 1Ah   ; size w
assnum     equ 1Ch   ; size w
temp1      equ 26h   ; size w
temp2      equ 28h   ; size w
temp3      equ 2Ah   ; size w
temp4      equ 2Ch   ; size w
temp5      equ 2Eh   ; size w
Wallcos    equ 30h   ; size w
Wallsin    equ 32h   ; size w
radiusx    equ 66h   ; size w; defaultsprites_0 writes word [x+66h] from the radx column
radiusy    equ 68h   ; size w; defaultsprites_0 writes word [x+68h] from the rady column
SCnum      equ 6Ah   ; size w
facedir    equ 36h   ; size w
SPA        equ 38h   ; size w
SPAnum     equ 3Ah   ; size w
SPAcnt     equ 3Ch   ; size w
newpos     equ 42h   ; size b
newpnum    equ 43h   ; size b
pflags     equ 44h   ; size b
pflags2    equ 45h   ; size b
asslist    equ 1Eh   ; size b; byte array indexed by assnum: avdgoal/goalieacc cmp byte [reg+assnum+asslist]
pnum       equ 47h   ; size b; engine_skating playeracc: byte (dword [x-3] sar 18h) *2 indexes the team energy words.b pnum(a3),d1 add d1,d1
puckdist   equ 4Eh   ; size w; none; updateplayers: word vecdist(puck - player) per frame (mov word [esi+4Eh],ax after vecdist of puckx/pucky minus Xpos/Ypos)
puckdir    equ 52h   ; size b; none; updateplayers: byte vtoa(puck - player), the direction to the puck; goalieacc/skatetopuck/chk4pass read it
attrlo     equ 54h   ; size b; low byte; low byte of the attribute word: defaultsprites_0 writes word [x+54h] from the.list att column; its high byte is attribute (55h), the byte 68k btst reads
attribute  equ 55h   ; size b; doplayeracc.s1 and noturn0.nostop: test byte [reg+55h],8
weight     equ 56h   ; size b; playeracc: byte >>3 subtracted from 32.b weight(a3),d2 lsr #3
legstr     equ 57h   ; size b; playeracc: added to the accel factor (twice for the goalie); stopna step 200+legstr
legspd     equ 58h   ; size b; playeracc: times the energy level for the MaxSpeed index.b legspd(a3),d2 mulu d0,d2
endurance  equ 61h   ; size b; playeracc.sube: added to the energy level.b endurance(a3),d2 add d2,d0
frame      equ 12h   ; size w; (alice frame number); GetHot reads word [x+12h] as the hot spot frame; assdopen sets it to -1
impactp    equ 14h   ; size w; Holdplayer: Acheck target SortCords[impactp] when impact != 0 (dword [x+12h] sar 10h).w impactp(a3),d0 asl #7
impact     equ 18h   ; size w; Holdplayer and Acheck: cmp word [x+18h],0
limpact    equ 16h   ; size w; 93G limpact (last impact value): updateplayers copies impact here
tmptr      equ 6Ch   ; size d; none (loadTeamStruct by pfteam); pointer to the player's own team structure: lineinput, lcselect, getlchoice read tmflags/tmline/tmap through it
optmptr    equ 70h   ; size d; none; pointer to the other team's structure: lcselect and getlchoice compare its tmap with tmptr's
nopuck     equ 3Eh   ; size w; after SPA/SPAnum/SPAcnt; ScatterPass dopass set it (28h 10h) after a pass.b #$14,nopuck(a3) ('no puck coll until zero')
passlane   equ 53h   ; size b; none; chk4pass stores the PassLaneChk result here; dopass passes only when it is set; setplayer and ScatterPass clear it
aioff      equ 59h   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record with the aioff formula (x xor 0Fh + 0Fh) >> 1
aidef      equ 5Ah   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record with the aidef formula (x xor 0Fh + 0Fh) >> 1
shotspd    equ 5Bh   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record
shotacc    equ 5Ch   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record
passacc    equ 5Dh   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record; ScatterPass scatters a pass by (12h - passacc) * 20
rostnum    equ 5Eh   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record (jersey number, record byte +5)
spodds     equ 5Fh   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record
stickhand  equ 60h   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record
aggress    equ 62h   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record
checking   equ 64h   ; size b; (no equate); inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record
handed     equ 65h   ; size b; inc offset - 11h, the shift of the whole weight..endurance block; PC setplayer fills it from the roster record; setplayer clears attribute bit 3 and sets it again from handed

; ---- team structure (away DF714, 100h apart). No 'size' tag on purpose:
; these offsets collide with player fields. They carry a 'tsize' tag instead (b/w/d, 'w array' for per-player word
; arrays): tools/struct_operands.py applies them only on a register it saw loaded with a team pointer
; (mov REG, hmtmstruct awtmstruct, or mov REG, [x+tmptr] [x+optmptr]) in straight-line code.
tmline     equ 2Ah   ; tsize w; getlchoice adds tmline*4 to the choice index; lcfound/lcselect store the new line, then setpersonel
tmlcnt     equ 2Ch   ; tsize w; none; lcfound/lcselect: when the new line is < 4 it is incremented and wrapped at 3 (even-strength line rotation count)
tmextra    equ 2Eh   ; tsize w; none; SetPlList: pnum of the extra attacker (position 6) it lists, -1 with the goalie in
tmap       equ 36h   ; tsize w; getlchoice/lcselect: other tmap - own tmap selects the even short-handed power-play choices
tmscore    equ 10h   ; tsize w; Goal adds 1 (inc word [esi+10h]); PeriodOver/clockcont_0 compare hmscore with awscore
tmpde      equ 46h   ; tsize w array; (energy word per roster player, 1000h = full); burst subtracts 0CCh from [tmptr+pnum*2+46h]; reenergizeteam refills 1000h
tmpdst     equ 7Eh   ; tsize w array; (-2 bench -1 ice 0+ box): word per roster player: -2 bench, -1 on ice (setplayer, forcepldata), >0 penalty box time; restoreteams sets all to -2; ResetBench counts >0 into PBnum
tmlines    equ 0DAh  ; tsize d; none; pointer to the team's line table (clearteams: home hmlinetab, away awlinetab); getlinee and setpersonel read it
tmroster   equ 0EEh  ; tsize d; none; pointer to the team roster, 27h bytes per player (byte 0 = status: 3 bench, 4 on ice); clearteams: hmroster awroster
tmsort     equ 0F6h  ; tsize d; pointer to the team's first SortCords entry (home SortCords, away SortCords+300h); forcepldata/resetplstuff walk 6 entries from it
tmflags    equ 44h   ; tsize b; lineinput: bit 0 'start lc mode' cleared before opening the box; lcfound/lcselect clear bit 1 (tmflags(a2))
tmpptime   equ 08h   ; tsize w; (power-play seconds): updatePPTeamTime adds 1 for the team on the power play (gmode2 bits 5/6)
tmATOP     equ 0Eh   ; tsize w; (attack time of possession stat): chkatop adds 1 once a second for the team with the puck past the blue line
tmgoalie   equ 38h   ; tsize w; (goalie 1/2/none): releasepl picks the priolist row by its sign
tmpbox     equ 0B6h  ; tsize b array; (penalty box list: roster indexes, ends with a negative byte): updatepentime_ut walks it and shifts it down
tmshots    equ 00h   ; tsize w; team shots: the stats.log dump (DumpStatsLog) prints it under 'shts'
tmppg      equ 02h   ; tsize w; power-play goals: DumpStatsLog 'ppg' column
tmpp       equ 04h   ; tsize w; power plays: DumpStatsLog 'pp' column
tmpen      equ 0Ah   ; tsize w; penalties: DumpStatsLog 'pen' column
tmpenmin   equ 0Ch   ; tsize w; penalty minutes: DumpStatsLog 'penmin' column
tmpass     equ 26h   ; tsize w; passes: DumpStatsLog 'pass' column
tmpasscomp equ 28h   ; tsize w; completed passes: DumpStatsLog 'passcomp' column
tmplstats  equ 0E6h  ; tsize d; pointer to skater stats, 10h bytes per roster player 0-18h (words g, a, pen, +/-, ppg, shg, eng, sht): DumpStatsLog
tmglstats  equ 0EAh  ; tsize d; pointer to goalie stats, 6 bytes per goalie (roster 19h-1Bh; words min, sht, sav): DumpStatsLog
tmfowon    equ 12h   ; tsize w; (faceoffs won): puckglue adds 1 when the player takes the puck off a faceoff (sflags3 bit 4)
tmfowonoz  equ 14h   ; tsize w; puckglue adds 1 too when that faceoff was in the attacking end (puck y beyond 4Eh toward the team's net side by pflags bit 7)
tmpsplayer equ 30h   ; tsize w; puckglue ends a live penalty shot when the player with this roster index (pnum) takes the puck
tmast1     equ 33h   ; tsize b; (assist 1, st): puckglue sets it to -1 in the other team's structure
tmast2     equ 35h   ; tsize b; (assist 2, st): puckglue sets it to -1 in the other team's structure
