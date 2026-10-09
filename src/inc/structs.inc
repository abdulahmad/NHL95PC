; NHL 95 PC structure field offsets, written as the 93 Genesis names (see tools/struct_fieldmap.csv for the evidence).
; Equates only. Use them in operands with the original displacement size: [byte esi+Xvel], not [esi+0Ch]; the
; assembled bytes must not change. A field that is a 16.16 long on Genesis and 68k-word-aligned there is often read
; with the Watcom -5r short load: mov edx, [byte ecx+Xvel-2] / sar edx, 10h loads the word Xvel (sign-extended).
; Add a field here and a row in tools/struct_fieldmap.csv in the same commit. An equate nothing uses may stay.

; ---- player structure (93G SortCords player block, 93G offset in the comment). Pointer usually in eax/ecx/esi/edi.
Xpos       equ 00h   ; 93G $00; also accessed at 02h (integer word of the 16.16 value); seed: SetSPA/asseben hand alignment
Ypos       equ 04h   ; 93G $14; also accessed at 06h (integer word of the 16.16 value); seed: SetSPA/asseben hand alignment
OldXpos    equ 74h   ; 93G $1C; aligned 2/3 accesses in puckfaceoff2, updateplayers
Xvel       equ 0Ch   ; 93G $28; seed: SetSPA/asseben hand alignment
Yvel       equ 0Eh   ; 93G $2A; seed: SetSPA/asseben hand alignment
position   equ 1Ah   ; 93G $34; aligned 9/13 accesses in assbench, assdefd, assdefo, assnearest, asswingd, asswingo
assnum     equ 1Ch   ; 93G $36; seed: SetSPA/asseben hand alignment
temp1      equ 26h   ; 93G $40; seed: SetSPA/asseben hand alignment
temp2      equ 28h   ; 93G $42; seed: SetSPA/asseben hand alignment
temp3      equ 2Ah   ; 93G $44; aligned 16/26 accesses in assbench, asscentero, assdefd, assnearest, asspenalty, assscore
temp4      equ 2Ch   ; 93G $46; aligned 13/20 accesses in assbench, asscentero, assdefd, assgoalie, asspenalty, assscore
temp5      equ 2Eh   ; 93G $48; aligned 8/12 accesses in asscentero, assgoalie, asswingo
Wallcos    equ 30h   ; 93G $4E; aligned 2/2 accesses in asspenalty, updateplayers
Wallsin    equ 32h   ; 93G $50; aligned 2/2 accesses in asspenalty, updateplayers
SCnum      equ 6Ah   ; 93G $52; seed: SetSPA/asseben hand alignment
facedir    equ 36h   ; 93G $54; seed: SetSPA/asseben hand alignment
SPA        equ 38h   ; 93G $58; seed: SetSPA/asseben hand alignment
SPAnum     equ 3Ah   ; 93G $5A; seed: SetSPA/asseben hand alignment
SPAcnt     equ 3Ch   ; 93G $5C; seed: SetSPA/asseben hand alignment
newpos     equ 42h   ; 93G $60; aligned 3/3 accesses in assbench, assepen
newpnum    equ 43h   ; 93G $61; aligned 3/3 accesses in assbench, assepen
pflags     equ 44h   ; 93G $62; seed: SetSPA/asseben hand alignment
pflags2    equ 45h   ; 93G $63; seed: SetSPA/asseben hand alignment
