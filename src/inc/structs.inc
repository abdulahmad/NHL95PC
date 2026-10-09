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
attribute  equ 55h   ; size b; 93G $4; doplayeracc .s1 and noturn0 .nostop: test byte [reg+55h],8 where 93G does btst #3,attribute(a3) (PC keeps only the flip bits byte)
weight     equ 56h   ; size b; 93G $67; playeracc: byte >>3 subtracted from 32, as 93G move.b weight(a3),d2 / lsr #3
legstr     equ 57h   ; size b; 93G $68; playeracc: added to the accel factor (twice for the goalie) as 93G legstr; StopNA step 200+legstr
legspd     equ 58h   ; size b; 93G $69; playeracc: times the energy level for the MaxSpeed index, as 93G move.b legspd(a3),d2 / mulu d0,d2
endurance  equ 61h   ; size b; 93G $72; playeracc .sube: added to the energy level, as 93G move.b endurance(a3),d2 / add d2,d0
