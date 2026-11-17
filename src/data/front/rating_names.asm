; The ratings label on the create-player screen.
bits 32
%include "hockey.inc"
section s_D0819 progbits alloc noexec write align=1
extern str_GP9, str_spG2, str_spA2, str_Pt4, str_PIM7, str_PlusMinus6, str_PPG4, str_SHG4
extern str_Shots6, str_Pct8, str_Shoots3, str_Speed3, str_Agility3, str_Weight3, str_ShotPower2, str_Checking3
extern str_StickHandling2, str_Accuracy2, str_Passing3, str_OffensiveAwareness3, str_DefensiveAwareness3, str_Aggressiveness2, str_Endurance2, str_ShootPassBias2
extern str_Faceoffs2, str_Min6, str_GA6, str_GAA5, str_spW3, str_SpL6, str_SpT3, str_SO3
extern str_EN3, str_SA5, str_GloveHand3, str_GloveLeft2, str_GloveRight2, str_StickLeft2, str_StickRight2, str_PuckControl2
extern str_PenaltyKilling3, str_PowerPlay3, str_Shooting2, str_Skating2, str_Defence2, str_Goaltending2, str_OverAll2
global str_Ratings, teamratingidx, rostereditmode, newskaterratingnames, newskaterattrs_m3, newgoalieratingnames, newgoalieattrs_m3, teamratingnames
str_Ratings:                                    ; string 'Ratings:'; used by DrawEditRosters
        db 052h,061h,074h,069h,06Eh,067h,073h,03Ah,00h,052h,06Fh,06Fh,06Bh,069h,065h,03Ah
        db 00h,04Eh,061h,06Dh,065h,03Ah,00h
        dd str_GP9
        dd str_spG2
        dd str_spA2
        dd str_Pt4
        dd str_PIM7
        dd str_PlusMinus6
        dd str_PPG4
        dd str_SHG4
        dd str_Shots6
        dd str_Pct8
        db 078h,00h,00h,00h,0A0h,00h,00h,00h,0C8h,00h,00h,00h,0F0h,00h,00h,00h
        db 018h,01h,00h,00h,040h,01h,00h,00h,07Ch,01h,00h,00h,0A4h,01h,00h,00h
        db 0CCh,01h,00h,00h,08h,02h,00h,00h
newskaterratingnames:                           ; create player: names of the 14 skater ratings (index 1-14);
                                                ; used by DrawShootsField, EditSkaterRating
        dd str_Shoots3
        dd str_Speed3
        dd str_Agility3
        dd str_Weight3
        dd str_ShotPower2
        dd str_Checking3
        dd str_StickHandling2
        dd str_Accuracy2
        dd str_Passing3
        dd str_OffensiveAwareness3
        dd str_DefensiveAwareness3
        dd str_Aggressiveness2
        dd str_Endurance2
        dd str_ShootPassBias2
newskaterattrs_m3 equ $+1
        dd str_Faceoffs2
        db 00h,01h,02h,03h,04h,05h,06h,07h,09h,0Ah,0Bh,0Ch,0Dh,0Eh,013h,078h
        db 00h,00h,00h,010h,01h,00h,00h,0A0h,00h,00h,00h,010h,01h,00h,00h,0C8h
        db 00h,00h,00h,010h,01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh,018h
        db 01h,00h,00h,010h,01h,00h,00h,040h,01h,00h,00h,010h,01h,00h,00h,07Ch
        db 01h,00h,00h,010h,01h,00h,00h,0A4h,01h,00h,00h,010h,01h,00h,00h,0CCh
        db 01h,00h,00h,010h,01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh,078h
        db 00h,00h,00h,01Dh,01h,00h,00h,0A0h,00h,00h,00h,01Dh,01h,00h,00h,0C8h
        db 00h,00h,00h,01Dh,01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh,018h
        db 01h,00h,00h,01Dh,01h,00h,00h,040h,01h,00h,00h,01Dh,01h,00h,00h,07Ch
        db 01h,00h,00h,01Dh,01h,00h,00h,0A4h,01h,00h,00h,01Dh,01h,00h,00h,0CCh
        db 01h,00h,00h,01Dh,01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh,0A0h
        db 00h,00h,00h,02Ah,01h,00h,00h,0C8h,00h,00h,00h,02Ah,01h,00h,00h,078h
        db 00h,00h,00h,037h,01h,00h,00h
        dd str_GP9
        dd str_Min6
        dd str_GA6
        dd str_GAA5
        dd str_spW3
        dd str_SpL6
        dd str_SpT3
        dd str_SO3
        dd str_EN3
        dd str_SA5
        dd str_Pct8
        db 078h,00h,00h,00h,0A0h,00h,00h,00h,0C8h,00h,00h,00h,0F0h,00h,00h,00h
        db 02Ch,01h,00h,00h,054h,01h,00h,00h,07Ch,01h,00h,00h,0A4h,01h,00h,00h
        db 0CCh,01h,00h,00h,0F4h,01h,00h,00h,030h,02h,00h,00h
newgoalieratingnames:                           ; create player: names of the 10 goalie ratings (index 1-10);
                                                ; used by DrawGloveField, EditGoalieRating
        dd str_GloveHand3
        dd str_GloveLeft2
        dd str_GloveRight2
        dd str_StickLeft2
        dd str_StickRight2
        dd str_PuckControl2
        dd str_Speed3
        dd str_Agility3
        dd str_Weight3
        dd str_OffensiveAwareness3
newgoalieattrs_m3 equ $+1
        dd str_DefensiveAwareness3
        db 00h,01h,02h,03h,04h,05h,06h,07h,08h,0Ah,0Bh,078h,00h,00h,00h,010h
        db 01h,00h,00h,0A0h,00h,00h,00h,010h,01h,00h,00h,0C8h,00h,00h,00h,010h
        db 01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh,02Ch,01h,00h,00h,010h
        db 01h,00h,00h,054h,01h,00h,00h,010h,01h,00h,00h,07Ch,01h,00h,00h,010h
        db 01h,00h,00h,0A4h,01h,00h,00h,010h,01h,00h,00h,0CCh,01h,00h,00h,010h
        db 01h,00h,00h,0F4h,01h,00h,00h,010h,01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch
        db 0FFh,0FFh,0FFh,078h,00h,00h,00h,01Dh,01h,00h,00h,0A0h,00h,00h,00h,01Dh
        db 01h,00h,00h,0C8h,00h,00h,00h,01Dh,01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch
        db 0FFh,0FFh,0FFh,02Ch,01h,00h,00h,01Dh,01h,00h,00h,054h,01h,00h,00h,01Dh
        db 01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh,0A4h,01h,00h,00h,01Dh
        db 01h,00h,00h,0CCh,01h,00h,00h,01Dh,01h,00h,00h,0F4h,01h,00h,00h,01Dh
        db 01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh
teamratingnames:                                ; DrawEditRosters: the nine team rating names; used by
                                                ; DrawEditRosters
        dd str_PenaltyKilling3
        dd str_PowerPlay3
        dd str_Shooting2
        dd str_Skating2
        dd str_Passing3
        dd str_Defence2
        dd str_Checking3
        dd str_Goaltending2
        dd str_OverAll2
teamratingidx:                                  ; DrawEditRosters: index of each of the nine ratings in the
                                                ; team record; used by DrawEditRosters
        db 00h,01h,04h,05h,06h,07h,08h,0Ah,0Bh,045h,06Eh,074h,065h,072h,020h,061h
        db 020h,070h,06Fh,073h,069h,074h,069h,06Fh,06Eh,020h,066h,06Fh,072h,00h,028h,059h
        db 029h,065h,073h,020h,06Fh,072h,020h,028h,04Eh,029h,06Fh,00h
rostereditmode:                                 ; roster editor mode (2: CopyRoster1Rec copies the team record
                                                ; into the edit buffer); used by CopyRoster1Rec,
                                                ; DrawEditRosters, EditRosters ...
        db 00h,00h,00h,00h
