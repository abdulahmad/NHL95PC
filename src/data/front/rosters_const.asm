; Strings and constants of front/rosters (src/front/rosters), in link order.
bits 32
%include "hockey.inc"
section s_C28C4 progbits alloc noexec write align=1
global str_Prez2, str_Pal, str_ea, str_Uar, str_Uarm, str_TheJerseyNumber2d, str_PleaseEnterANew, str_Menubuff
global str_TheDatabaseHasNot, str_AreYouSureYou, str_GP9, str_spG2, str_spA2, str_Pt4, str_PIM7, str_PlusMinus6
global str_PPG4, str_SHG4, str_Shots6, str_Pct8, str_Shoots3, str_Speed3, str_Agility3, str_Weight3
global str_ShotPower2, str_Checking3, str_StickHandling2, str_Accuracy2, str_Passing3, str_OffensiveAwareness3, str_DefensiveAwareness3, str_Aggressiveness2
global str_Endurance2, str_ShootPassBias2, str_Faceoffs2, str_Min6, str_GA6, str_GAA5, str_spW3, str_SpL6
global str_SpT3, str_SO3, str_EN3, str_SA5, str_GloveHand3, str_GloveLeft2, str_GloveRight2, str_StickLeft2
global str_StickRight2, str_PuckControl2, str_PenaltyKilling3, str_PowerPlay3, str_Shooting2, str_Skating2, str_Defence2, str_Goaltending2
global str_OverAll2, str_Cancel6, str_Create, str_X
str_Prez2:                                      ; string 'prez2'; used by DrawEditRosters
        db 070h,072h,065h,07Ah,032h,00h
str_Pal:                                        ; string '!pal'; used by DrawEditRosters
        db 021h,070h,061h,06Ch,00h
str_ea:                                         ; string 'ea '; used by DrawEditRosters
        db 065h,061h,020h,020h,00h
str_Uar:                                        ; string 'uar'; used by LoadRosterList_faloop
        db 075h,061h,072h,00h
str_Uarm:                                       ; string 'uarm'; used by LoadRosterList_faloop
        db 075h,061h,072h,06Dh,00h
str_TheJerseyNumber2d:                          ; string 'The jersey number %2d is already used!'; used by
                                                ; FixJerseyNumber
        db 054h,068h,065h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh,062h,065h
        db 072h,020h,025h,032h,064h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
        db 020h,075h,073h,065h,064h,021h,00h
str_PleaseEnterANew:                            ; string 'Please enter a new jersey number for'; used by
                                                ; FixJerseyNumber
        db 050h,06Ch,065h,061h,073h,065h,020h,065h,06Eh,074h,065h,072h,020h,061h,020h,06Eh
        db 065h,077h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh,062h,065h,072h
        db 020h,066h,06Fh,072h,00h
str_Menubuff:                                   ; string 'menubuff'; used by EditRosters
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_TheDatabaseHasNot:                          ; string 'The database has not been saved.'; used by
                                                ; EditRosters
        db 054h,068h,065h,020h,064h,061h,074h,061h,062h,061h,073h,065h,020h,068h,061h,073h
        db 020h,06Eh,06Fh,074h,020h,062h,065h,065h,06Eh,020h,073h,061h,076h,065h,064h,02Eh
        db 00h
str_AreYouSureYou:                              ; string 'Are you sure you want to exit?'; used by EditRosters
        db 041h,072h,065h,020h,079h,06Fh,075h,020h,073h,075h,072h,065h,020h,079h,06Fh,075h
        db 020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,065h,078h,069h,074h,03Fh,00h,00h
        db 00h
str_GP9:                                        ; "GP" string literal
        db 047h,050h,00h
str_spG2:                                       ; string ' G'
        db 020h,020h,047h,00h
str_spA2:                                       ; string ' A'
        db 020h,020h,041h,00h
str_Pt4:                                        ; " Pt" string literal
        db 020h,050h,074h,00h
str_PIM7:                                       ; "PIM" string literal
        db 050h,049h,04Dh,00h
str_PlusMinus6:                                 ; string ' +/-'
        db 020h,02Bh,02Fh,02Dh,00h
str_PPG4:                                       ; "PPG" string literal
        db 050h,050h,047h,00h
str_SHG4:                                       ; "SHG" string literal
        db 053h,048h,047h,00h
str_Shots6:                                     ; "Shots" string literal
        db 053h,068h,06Fh,074h,073h,00h
str_Pct8:                                       ; " Pct" string literal
        db 020h,020h,050h,063h,074h,00h
str_Shoots3:                                    ; "Shoots" string literal
        db 053h,068h,06Fh,06Fh,074h,073h,00h
str_Speed3:                                     ; "Speed" string literal
        db 053h,070h,065h,065h,064h,00h
str_Agility3:                                   ; "Agility" string literal
        db 041h,067h,069h,06Ch,069h,074h,079h,00h
str_Weight3:                                    ; "Weight" string literal
        db 057h,065h,069h,067h,068h,074h,00h
str_ShotPower2:                                 ; "Shot Power" string literal
        db 053h,068h,06Fh,074h,020h,050h,06Fh,077h,065h,072h,00h
str_Checking3:                                  ; "Checking" string literal
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_StickHandling2:                             ; "StickHandling" string literal
        db 053h,074h,069h,063h,06Bh,048h,061h,06Eh,064h,06Ch,069h,06Eh,067h,00h
str_Accuracy2:                                  ; "Accuracy" string literal
        db 041h,063h,063h,075h,072h,061h,063h,079h,00h
str_Passing3:                                   ; "Passing" string literal
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_OffensiveAwareness3:                        ; "Offensive Awareness" string literal
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_DefensiveAwareness3:                        ; "Defensive Awareness" string literal
        db 044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_Aggressiveness2:                            ; "Aggressiveness" string literal
        db 041h,067h,067h,072h,065h,073h,073h,069h,076h,065h,06Eh,065h,073h,073h,00h
str_Endurance2:                                 ; "Endurance" string literal
        db 045h,06Eh,064h,075h,072h,061h,06Eh,063h,065h,00h
str_ShootPassBias2:                             ; "Shoot/Pass Bias" string literal
        db 053h,068h,06Fh,06Fh,074h,02Fh,050h,061h,073h,073h,020h,042h,069h,061h,073h,00h
str_Faceoffs2:                                  ; "Faceoffs" string literal
        db 046h,061h,063h,065h,06Fh,066h,066h,073h,00h
str_Min6:                                       ; " Min" string literal
        db 020h,04Dh,069h,06Eh,00h
str_GA6:                                        ; " GA" string literal
        db 020h,020h,047h,041h,00h
str_GAA5:                                       ; " GAA" string literal
        db 020h,020h,047h,041h,041h,00h
str_spW3:                                       ; string ' W'
        db 020h,057h,00h
str_SpL6:                                       ; string ' L'
        db 020h,04Ch,00h
str_SpT3:                                       ; string ' T'
        db 020h,054h,00h
str_SO3:                                        ; "SO" string literal
        db 053h,04Fh,00h
str_EN3:                                        ; "EN" string literal
        db 045h,04Eh,00h
str_SA5:                                        ; " SA" string literal
        db 020h,020h,020h,053h,041h,00h
str_GloveHand3:                                 ; "Glove Hand" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,048h,061h,06Eh,064h,00h
str_GloveLeft2:                                 ; "Glove Left" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,04Ch,065h,066h,074h,00h
str_GloveRight2:                                ; "Glove Right" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,052h,069h,067h,068h,074h,00h
str_StickLeft2:                                 ; "Stick Left" string literal
        db 053h,074h,069h,063h,06Bh,020h,04Ch,065h,066h,074h,00h
str_StickRight2:                                ; "Stick Right" string literal
        db 053h,074h,069h,063h,06Bh,020h,052h,069h,067h,068h,074h,00h
str_PuckControl2:                               ; "Puck Control" string literal
        db 050h,075h,063h,06Bh,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch,00h
str_PenaltyKilling3:                            ; "Penalty Killing" string literal
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h,06Ch,06Ch,069h,06Eh,067h,00h
str_PowerPlay3:                                 ; "Power Play" string literal
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,00h
str_Shooting2:                                  ; "Shooting" string literal
        db 053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,00h
str_Skating2:                                   ; "Skating" string literal
        db 053h,06Bh,061h,074h,069h,06Eh,067h,00h
str_Defence2:                                   ; "Defence" string literal
        db 044h,065h,066h,065h,06Eh,063h,065h,00h
str_Goaltending2:                               ; "Goaltending" string literal
        db 047h,06Fh,061h,06Ch,074h,065h,06Eh,064h,069h,06Eh,067h,00h
str_OverAll2:                                   ; "Over all" string literal
        db 04Fh,076h,065h,072h,020h,061h,06Ch,06Ch,00h
str_Cancel6:                                    ; "Cancel" string literal
        db 043h,061h,06Eh,063h,065h,06Ch,00h
str_Create:                                     ; "Create" string literal
        db 043h,072h,065h,061h,074h,065h,00h
str_X:                                          ; string 'X'
        db 058h,00h,00h,00h,00h
