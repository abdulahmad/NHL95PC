; Strings and constants of front/main (src/front/main), in link order.
bits 32
%include "hockey.inc"
section s_C0004 progbits alloc noexec write align=1
global str_NoDiskSpaceC, str_ErrDiskFree2, str_NoDiskSpaceCur, str_NoMemory, str_CheckRefCard, str_NoConvMemory, str_CheckRefCard2, str_Pointer3
global str_Pntr, str_S1, str_Scor2b, str_Scor3b, str_Kaufm020, str_ConfigureLeftJoystick, str_ConfigureRightJoystick, str_GameSet2
global str_errd3, str_errd4, str_Temp3, str_ErrDiskFree3, str_backslash, str_GameSav2, str_ArtHart, str_ArtRoss
global str_ArtNorr, str_ArtSelk, str_ArtVezi, str_ArtJenn, str_ArtCald, str_ArtPres, str_ArtConn, str_ArtEasn
global str_ArtStan, str_Hart, str_ArtRoss2, str_Norris, str_Selke, str_Vezina, str_Jennings, str_Calder
global str_Presidents, str_ConnSmythe, str_EASportsCup, str_StanleyCup, str_MostValuablePlayer, str_PointsLeader, str_RegularSeason, str_BestDefenseman
global str_BestDefensiveForward, str_BestGoalkeeper, str_BestGoalsAgainstAverage, str_BestRookie, str_BestRegularSeasonRecord, str_InThePlayoffs, str_Most3StarSelections, str_StanleyCupChampions
global str_Season2, str_Playoff2
str_NoDiskSpaceC:                               ; string "\nInsufficient Disk Space free on 'C:'.\nPlease free
                                                ; up at least 2 Kbytes of disk space\n"; used by main_
        db 0Ah,049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,044h,069h
        db 073h,06Bh,020h,053h,070h,061h,063h,065h,020h,066h,072h,065h,065h,020h,06Fh,06Eh
        db 020h,027h,043h,03Ah,027h,02Eh,0Ah,050h,06Ch,065h,061h,073h,065h,020h,066h,072h
        db 065h,065h,020h,075h,070h,020h,061h,074h,020h,06Ch,065h,061h,073h,074h,020h,032h
        db 020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,064h,069h,073h,06Bh,020h
        db 073h,070h,061h,063h,065h,0Ah,00h
str_ErrDiskFree2:                               ; string 'error getting disk space free\n'; used by main_
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_NoDiskSpaceCur:                             ; string '\nInsufficient Disk Space free on current
                                                ; drive.\nPlease free up at least %d Kbytes of disk space\n';
                                                ; used by main_
        db 0Ah,049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,044h,069h
        db 073h,06Bh,020h,053h,070h,061h,063h,065h,020h,066h,072h,065h,065h,020h,06Fh,06Eh
        db 020h,063h,075h,072h,072h,065h,06Eh,074h,020h,064h,072h,069h,076h,065h,02Eh,0Ah
        db 050h,06Ch,065h,061h,073h,065h,020h,066h,072h,065h,065h,020h,075h,070h,020h,061h
        db 074h,020h,06Ch,065h,061h,073h,074h,020h,025h,064h,020h,04Bh,062h,079h,074h,065h
        db 073h,020h,06Fh,066h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,0Ah
        db 00h
str_NoMemory:                                   ; string '\nInsufficient memory available.'; used by main_
        db 0Ah,049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,06Dh,065h
        db 06Dh,06Fh,072h,079h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,02Eh,00h
str_CheckRefCard:                               ; string '\nPlease check your reference card.\n\n'; used by
                                                ; main_
        db 0Ah,050h,06Ch,065h,061h,073h,065h,020h,063h,068h,065h,063h,06Bh,020h,079h,06Fh
        db 075h,072h,020h,072h,065h,066h,065h,072h,065h,06Eh,063h,065h,020h,063h,061h,072h
        db 064h,02Eh,0Ah,0Ah,00h
str_NoConvMemory:                               ; string '\nInsufficient conventional memory available.'; used
                                                ; by main_
        db 0Ah,049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,063h,06Fh
        db 06Eh,076h,065h,06Eh,074h,069h,06Fh,06Eh,061h,06Ch,020h,06Dh,065h,06Dh,06Fh,072h
        db 079h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch,065h,02Eh,00h
str_CheckRefCard2:                              ; string '\nPlease check your reference card.\n\n'; used by
                                                ; main_
        db 0Ah,050h,06Ch,065h,061h,073h,065h,020h,063h,068h,065h,063h,06Bh,020h,079h,06Fh
        db 075h,072h,020h,072h,065h,066h,065h,072h,065h,06Eh,063h,065h,020h,063h,061h,072h
        db 064h,02Eh,0Ah,0Ah,00h
str_Pointer3:                                   ; string 'pointer3'; used by main_
        db 070h,06Fh,069h,06Eh,074h,065h,072h,033h,00h
str_Pntr:                                       ; string 'pntr'; used by main_
        db 070h,06Eh,074h,072h,00h
str_S1:                                         ; string 's1'; used by main_
        db 073h,031h,00h
str_Scor2b:                                     ; string 'scor2b'; used by main_
        db 073h,063h,06Fh,072h,032h,062h,00h
str_Scor3b:                                     ; string 'scor3b'; used by main_
        db 073h,063h,06Fh,072h,033h,062h,00h
str_Kaufm020:                                   ; string 'kaufm020'; used by main_
        db 06Bh,061h,075h,066h,06Dh,030h,032h,030h,00h
str_ConfigureLeftJoystick:                      ; string 'Configure Left Joystick'; used by main_
        db 043h,06Fh,06Eh,066h,069h,067h,075h,072h,065h,020h,04Ch,065h,066h,074h,020h,04Ah
        db 06Fh,079h,073h,074h,069h,063h,06Bh,00h
str_ConfigureRightJoystick:                     ; string 'Configure Right Joystick'; used by main_
        db 043h,06Fh,06Eh,066h,069h,067h,075h,072h,065h,020h,052h,069h,067h,068h,074h,020h
        db 04Ah,06Fh,079h,073h,074h,069h,063h,06Bh,00h
str_GameSet2:                                   ; string 'game.set'; used by main_
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_errd3:                                      ; string 'd3'; used by main_
        db 064h,033h,00h
str_errd4:                                      ; string 'd4'; used by main_
        db 064h,034h,00h
str_Temp3:                                      ; string 'temp'; used by main_
        db 074h,065h,06Dh,070h,00h
str_ErrDiskFree3:                               ; string 'error getting disk space free\n'; used by
                                                ; DiskFreeBytes
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h,00h
        db 00h
str_backslash:                                  ; string '\\'; used by PlayGame
        db 05Ch,00h
str_GameSav2:                                   ; string 'game.sav'; used by PlayGame
        db 067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h,00h
str_ArtHart:                                    ; string 'hart'
        db 068h,061h,072h,074h,00h
str_ArtRoss:                                    ; string 'ross'
        db 072h,06Fh,073h,073h,00h
str_ArtNorr:                                    ; string 'norr'
        db 06Eh,06Fh,072h,072h,00h
str_ArtSelk:                                    ; string 'selk'
        db 073h,065h,06Ch,06Bh,00h
str_ArtVezi:                                    ; string 'vezi'
        db 076h,065h,07Ah,069h,00h
str_ArtJenn:                                    ; string 'jenn'
        db 06Ah,065h,06Eh,06Eh,00h
str_ArtCald:                                    ; string 'cald'
        db 063h,061h,06Ch,064h,00h
str_ArtPres:                                    ; string 'pres'
        db 070h,072h,065h,073h,00h
str_ArtConn:                                    ; string 'conn'
        db 063h,06Fh,06Eh,06Eh,00h
str_ArtEasn:                                    ; string 'easn'
        db 065h,061h,073h,06Eh,00h
str_ArtStan:                                    ; string 'stan'
        db 073h,074h,061h,06Eh,00h
str_Hart:                                       ; "Hart" string literal
        db 048h,061h,072h,074h,00h
str_ArtRoss2:                                   ; "Art Ross" string literal
        db 041h,072h,074h,020h,052h,06Fh,073h,073h,00h
str_Norris:                                     ; "Norris" string literal
        db 04Eh,06Fh,072h,072h,069h,073h,00h
str_Selke:                                      ; "Selke" string literal
        db 053h,065h,06Ch,06Bh,065h,00h
str_Vezina:                                     ; "Vezina" string literal
        db 056h,065h,07Ah,069h,06Eh,061h,00h
str_Jennings:                                   ; "Jennings" string literal
        db 04Ah,065h,06Eh,06Eh,069h,06Eh,067h,073h,00h
str_Calder:                                     ; "Calder" string literal
        db 043h,061h,06Ch,064h,065h,072h,00h
str_Presidents:                                 ; "Presidents" string literal
        db 050h,072h,065h,073h,069h,064h,065h,06Eh,074h,073h,00h
str_ConnSmythe:                                 ; "Conn Smythe" string literal
        db 043h,06Fh,06Eh,06Eh,020h,053h,06Dh,079h,074h,068h,065h,00h
str_EASportsCup:                                ; "EA Sports Cup" string literal
        db 045h,041h,020h,053h,070h,06Fh,072h,074h,073h,020h,043h,075h,070h,00h
str_StanleyCup:                                 ; string 'Stanley Cup '
        db 053h,074h,061h,06Eh,06Ch,065h,079h,020h,043h,075h,070h,06h,00h
str_MostValuablePlayer:                         ; "Most Valuable Player" string literal
        db 04Dh,06Fh,073h,074h,020h,056h,061h,06Ch,075h,061h,062h,06Ch,065h,020h,050h,06Ch
        db 061h,079h,065h,072h,00h
str_PointsLeader:                               ; "Points Leader" string literal
        db 050h,06Fh,069h,06Eh,074h,073h,020h,04Ch,065h,061h,064h,065h,072h,00h
str_RegularSeason:                              ; "Regular Season" string literal
        db 052h,065h,067h,075h,06Ch,061h,072h,020h,053h,065h,061h,073h,06Fh,06Eh,00h
str_BestDefenseman:                             ; "Best Defenseman" string literal
        db 042h,065h,073h,074h,020h,044h,065h,066h,065h,06Eh,073h,065h,06Dh,061h,06Eh,00h
str_BestDefensiveForward:                       ; "Best Defensive Forward" string literal
        db 042h,065h,073h,074h,020h,044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,046h
        db 06Fh,072h,077h,061h,072h,064h,00h
str_BestGoalkeeper:                             ; "Best Goalkeeper" string literal
        db 042h,065h,073h,074h,020h,047h,06Fh,061h,06Ch,06Bh,065h,065h,070h,065h,072h,00h
str_BestGoalsAgainstAverage:                    ; "Best Goals Against Average" string literal
        db 042h,065h,073h,074h,020h,047h,06Fh,061h,06Ch,073h,020h,041h,067h,061h,069h,06Eh
        db 073h,074h,020h,041h,076h,065h,072h,061h,067h,065h,00h
str_BestRookie:                                 ; "Best Rookie" string literal
        db 042h,065h,073h,074h,020h,052h,06Fh,06Fh,06Bh,069h,065h,00h
str_BestRegularSeasonRecord:                    ; "Best Regular Season Record" string literal
        db 042h,065h,073h,074h,020h,052h,065h,067h,075h,06Ch,061h,072h,020h,053h,065h,061h
        db 073h,06Fh,06Eh,020h,052h,065h,063h,06Fh,072h,064h,00h
str_InThePlayoffs:                              ; "in the Playoffs" string literal
        db 069h,06Eh,020h,074h,068h,065h,020h,050h,06Ch,061h,079h,06Fh,066h,066h,073h,00h
str_Most3StarSelections:                        ; "Most 3 Star Selections" string literal
        db 04Dh,06Fh,073h,074h,020h,033h,020h,053h,074h,061h,072h,020h,053h,065h,06Ch,065h
        db 063h,074h,069h,06Fh,06Eh,073h,00h
str_StanleyCupChampions:                        ; string 'Stanley Cup Champions'
        db 053h,074h,061h,06Eh,06Ch,065h,079h,020h,043h,075h,070h,06h,020h,043h,068h,061h
        db 06Dh,070h,069h,06Fh,06Eh,073h,00h
str_Season2:                                    ; "Season" string literal
        db 053h,065h,061h,073h,06Fh,06Eh,00h
str_Playoff2:                                   ; "Playoff" string literal
        db 050h,06Ch,061h,079h,06Fh,066h,066h,00h
