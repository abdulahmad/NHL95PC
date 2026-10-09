; NHL 95 PC structure field offsets, written as the 93 Genesis names (see tools/struct_fieldmap.csv for the evidence).
; Equates only. Use them in operands with the original displacement size: [byte esi+Xvel], not [esi+0Ch]; the
; assembled bytes must not change. A field that is a 16.16 long on Genesis and 68k-word-aligned there is often read
; with the Watcom -5r short load: mov edx, [byte ecx+Xvel-2] / sar edx, 10h loads the word Xvel (sign-extended).
; 'size b/w/d' is the PC access size (tools/struct_operands.py matches operands by offset and size). A 'size d' field
; is a 16.16 value; its integer word is Field+2 ([byte ebx+Xpos+2]).
; Add a field here and a row in tools/struct_fieldmap.csv in the same commit. An equate nothing uses may stay.

; ---- player structure (93G SortCords player block, 93G offset in the comment). Pointer usually in eax/ecx/esi/edi.
Xpos       equ 00h   ; size d; 93G $00; seed: SetSPA/asseben hand alignment
Ypos       equ 04h   ; size d; 93G $14; seed: SetSPA/asseben hand alignment
OldXpos    equ 74h   ; size d; 93G $1C; aligned 2/3 accesses in puckfaceoff2, updateplayers
Xvel       equ 0Ch   ; size w; 93G $28; seed: SetSPA/asseben hand alignment
Yvel       equ 0Eh   ; size w; 93G $2A; seed: SetSPA/asseben hand alignment
position   equ 1Ah   ; size w; 93G $34; aligned 9/13 accesses in assbench, assdefd, assdefo, assnearest, asswingd, asswingo
assnum     equ 1Ch   ; size w; 93G $36; seed: SetSPA/asseben hand alignment
temp1      equ 26h   ; size w; 93G $40; seed: SetSPA/asseben hand alignment
temp2      equ 28h   ; size w; 93G $42; seed: SetSPA/asseben hand alignment
temp3      equ 2Ah   ; size w; 93G $44; aligned 16/26 accesses in assbench, asscentero, assdefd, assnearest, asspenalty, assscore
temp4      equ 2Ch   ; size w; 93G $46; aligned 13/20 accesses in assbench, asscentero, assdefd, assgoalie, asspenalty, assscore
temp5      equ 2Eh   ; size w; 93G $48; aligned 8/12 accesses in asscentero, assgoalie, asswingo
Wallcos    equ 30h   ; size w; 93G $4E; aligned 2/2 accesses in asspenalty, updateplayers
Wallsin    equ 32h   ; size w; 93G $50; aligned 2/2 accesses in asspenalty, updateplayers
SCnum      equ 6Ah   ; size w; 93G $52; seed: SetSPA/asseben hand alignment
facedir    equ 36h   ; size w; 93G $54; seed: SetSPA/asseben hand alignment
SPA        equ 38h   ; size w; 93G $58; seed: SetSPA/asseben hand alignment
SPAnum     equ 3Ah   ; size w; 93G $5A; seed: SetSPA/asseben hand alignment
SPAcnt     equ 3Ch   ; size w; 93G $5C; seed: SetSPA/asseben hand alignment
newpos     equ 42h   ; size b; 93G $60; aligned 3/3 accesses in assbench, assepen
newpnum    equ 43h   ; size b; 93G $61; aligned 3/3 accesses in assbench, assepen
pflags     equ 44h   ; size b; 93G $62; seed: SetSPA/asseben hand alignment
pflags2    equ 45h   ; size b; 93G $63; seed: SetSPA/asseben hand alignment
asslist    equ 1Eh   ; size b; 93G $38; byte array indexed by assnum: avdgoal/goalieacc cmp byte [reg+assnum+asslist] (93G asslist(a3,d1.w))
pnum       equ 47h   ; size b; 93G $66; engine_skating playeracc: byte (dword [x-3] / sar 18h) *2 indexes the team energy words, as 93G getpde move.b pnum(a3),d1 / add d1,d1
puckdist   equ 4Eh   ; size w; 93G none; updateplayers: word vecdist(puck - player) per frame (mov word [esi+4Eh],ax after vecdist of puckx/pucky minus Xpos/Ypos)
puckdir    equ 52h   ; size b; 93G none; updateplayers: byte vtoa(puck - player), the direction to the puck; goalieacc/skatetopuck/chk4pass read it
attribute  equ 55h   ; size b; 93G $4; doplayeracc .s1 and noturn0 .nostop: test byte [reg+55h],8 where 93G does btst #3,attribute(a3) (PC keeps only the flip bits byte)
weight     equ 56h   ; size b; 93G $67; playeracc: byte >>3 subtracted from 32, as 93G move.b weight(a3),d2 / lsr #3
legstr     equ 57h   ; size b; 93G $68; playeracc: added to the accel factor (twice for the goalie) as 93G legstr; StopNA step 200+legstr
legspd     equ 58h   ; size b; 93G $69; playeracc: times the energy level for the MaxSpeed index, as 93G move.b legspd(a3),d2 / mulu d0,d2
endurance  equ 61h   ; size b; 93G $72; playeracc .sube: added to the energy level, as 93G move.b endurance(a3),d2 / add d2,d0
frame      equ 12h   ; size w; 93G $6 (alice frame number); GetHot reads word [x+12h] as the hot spot frame (94G GetHot frame(a0)); assdopen sets it to -1 (94G clr.w frame(a3))
impactp    equ 14h   ; size w; 93G $2E; holdplayer: Acheck target SortCords[impactp] when impact != 0 (dword [x+12h] / sar 10h), as 93G move.w impactp(a3),d0 / asl #7
impact     equ 18h   ; size w; 93G $32; holdplayer and Acheck: cmp word [x+18h],0 where 93G does tst.w impact(a3)
tmptr      equ 6Ch   ; size d; 93G none (loadTeamStruct by pfteam); pointer to the player's own team structure: lineinput, lcselect, getlchoice read tmflags/tmline/tmap through it
optmptr    equ 70h   ; size d; 93G none; pointer to the other team's structure: lcselect and getlchoice compare its tmap with tmptr's (93G tmap(a2) vs the other tmstruct)

; ---- team structure (93G hmtmstruct/awtmstruct; PC home DF614, away DF714, 100h apart). No 'size' tag on purpose:
; these offsets collide with player fields. They carry a 'tsize' tag instead (b/w/d, 'w array' for per-player word
; arrays): tools/struct_operands.py applies them only on a register it saw loaded with a team pointer
; (mov REG, hmtmstruct / awtmstruct, or mov REG, [x+tmptr] / [x+optmptr]) in straight-line code.
tmline     equ 2Ah   ; tsize w; 93G $16; getlchoice adds tmline*4 to the choice index (93G adds tmline*3); lcfound/lcselect store the new line, then setpersonel
tmlcnt     equ 2Ch   ; tsize w; 93G none; lcfound/lcselect: when the new line is < 4 it is incremented and wrapped at 3 (even-strength line rotation count)
tmap       equ 36h   ; tsize w; 93G $24; getlchoice/lcselect: other tmap - own tmap selects the even / short-handed / power-play choices (93G 'number I'm short')
tmscore    equ 10h   ; tsize w; 93G $C; Goal adds 1 (inc word [esi+10h]); PeriodOver/clockcont_0 compare hmscore (DF624) with awscore (DF724)
tmpde      equ 46h   ; tsize w array; 93G $32 (energy word per roster player, 1000h = full); burst subtracts 0CCh from [tmptr+pnum*2+46h] (93G setpde); reenergizeteam refills 1000h
tmpdst     equ 7Eh   ; tsize w array; 93G $66 (-2 bench / -1 ice / 0+ box): word per roster player: -2 bench, -1 on ice (setplayer, forcepldata), >0 penalty box time; restoreteams sets all to -2; ResetBench counts >0 into PBnum
tmlines    equ 0DAh  ; tsize d; 93G none; pointer to the team's line table (clearteams: home hmlinetab, away awlinetab); getlinee and setpersonel read it
tmroster   equ 0EEh  ; tsize d; 93G none; pointer to the team roster, 27h bytes per player (byte 0 = status: 3 bench, 4 on ice); clearteams: hmroster / awroster
tmsort     equ 0F6h  ; tsize d; 93G $22; pointer to the team's first SortCords entry (home SortCords, away SortCords+300h); forcepldata/resetplstuff walk 6 entries from it
tmflags    equ 44h   ; tsize b; 93G $30; lineinput: bit 0 'start lc mode' cleared before opening the box; lcfound/lcselect clear bit 1 (93G bclr #1,tmflags(a2))
tmpptime   equ 08h   ; tsize w; 94G $352 (power-play seconds): updatePPTeamTime adds 1 for the team on the power play (gmode2 bits 5/6)
tmATOP     equ 0Eh   ; tsize w; 93G $A (attack time of possession stat): chkatop adds 1 once a second for the team with the puck past the blue line
tmgoalie   equ 38h   ; tsize w; 93G $26 (goalie 1/2/none): releasepl picks the priolist row by its sign (93G tst.w tmgoalie(a2) / bpl)
tmpbox     equ 0B6h  ; tsize b array; 93G $9A (penalty box list: roster indexes, ends with a negative byte): ProcessPenaltyList walks it and shifts it down
tmshots    equ 00h   ; tsize w; team shots: the stats.log dump (DumpStatsLog) prints it under 'shts'
tmppg      equ 02h   ; tsize w; power-play goals: DumpStatsLog 'ppg' column
tmpp       equ 04h   ; tsize w; power plays: DumpStatsLog 'pp' column
tmpen      equ 0Ah   ; tsize w; penalties: DumpStatsLog 'pen' column
tmpenmin   equ 0Ch   ; tsize w; penalty minutes: DumpStatsLog 'penmin' column
tmpass     equ 26h   ; tsize w; passes: DumpStatsLog 'pass' column
tmpasscomp equ 28h   ; tsize w; completed passes: DumpStatsLog 'passcomp' column
tmplstats  equ 0E6h  ; tsize d; pointer to skater stats, 10h bytes per roster player 0-18h (words g, a, pen, +/-, ppg, shg, eng, sht): DumpStatsLog
tmglstats  equ 0EAh  ; tsize d; pointer to goalie stats, 6 bytes per goalie (roster 19h-1Bh; words min, sht, sav): DumpStatsLog
