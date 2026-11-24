; Strings and constants of front/game_lines (src/front/game_lines), in link order.
bits 32
%include "hockey.inc"
section s_C30CC progbits alloc noexec write align=1
global str_Pal25, str_Lineditp2, str_Shrt2, str_Pntr3, str_Pointer13, str_Embpal4, str_Pal26, str_Lelogo
global str_Menubuff8, str_C2dS2, str_S2dSS, str_dot2, str_S6, str_Keys3, str_Pstat3, str_Gstat3
global str_SRoster, str_Pos2, str_No2, str_Name2, str_GP8, str_G4, str_A4, str_PT2
global str_Shots4, str_PIM4, str_PlusMinus7, str_C5, str_Min4, str_GAA4, str_W6, str_L8
global str_T6, str_GA3, str_SA3, str_PCT2, str_Pal27, str_Lineditp3, str_Shrt3, str_Pntr4
global str_Pointer14, str_Embpal5, str_Pal28, str_Lelogo2, str_Menubuff9, str_C2dS3, str_Key, str_ErrA1
global str_ErrA2, str_ErrA3, str_ErrA4, str_ErrA5, str_ErrA6, str_ErrA7, str_ErrA8, str_EmbS
global str_HOMEPALS3, str_Bkgd10, str_Forward, str_Line1, str_Line2, str_Line3, str_Line4, str_Power
global str_Play1, str_Play2, str_Penalty, str_Kill1, str_Kill2, str_Defense3, str_Goaltenders, str_Extra
global str_Attackers, str_S2dSS2, str_dot3, str_S7, str_Teams2, str_ErrB2Perror, str_ErrB3, str_ErrB4
global str_ErrB5, str_ErrB6, str_ErrB7, str_ErrB2, str_Tstat2, str_Keys4, str_Pstat4, str_Gstat4
str_Pal25:                                      ; string 'Pal'; used by DbLineEditor, DbLineEditorLoop
        db 050h,061h,06Ch,00h
str_Lineditp2:                                  ; string 'lineditp'; used by DbLineEditor
        db 06Ch,069h,06Eh,065h,064h,069h,074h,070h,00h
str_Shrt2:                                      ; string 'shrt'; used by DbLineEditor
        db 073h,068h,072h,074h,00h
str_Pntr3:                                      ; string 'pntr'; used by DbLineEditorLoop
        db 070h,06Eh,074h,072h,00h
str_Pointer13:                                  ; string 'Pointer'; used by DbLineEditorLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Embpal4:                                    ; string 'embpal'; used by DbLineEditorLoop
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal26:                                      ; string '!pal'; used by DbLineEditorLoop
        db 021h,070h,061h,06Ch,00h
str_Lelogo:                                     ; string 'lelogo'; used by DbLineEditorLoop
        db 06Ch,065h,06Ch,06Fh,067h,06Fh,00h
str_Menubuff8:                                  ; string 'menubuff'; used by DbLineEditorLoop
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_C2dS2:                                      ; string '%c %2d %s'; used by DbLineEditorLoop,
                                                ; DrawLineJerseys, DressPlayer ...
        db 025h,063h,020h,025h,032h,064h,020h,025h,073h,00h
str_S2dSS:                                      ; string '%s %2d %s%s'; used by CheckRosterComplete
        db 025h,073h,020h,025h,032h,064h,020h,025h,073h,025h,073h,00h
str_dot2:                                       ; string '.'; used by CheckRosterComplete
        db 02Eh,00h
str_S6:                                         ; string 's.'; used by CheckRosterComplete
        db 073h,02Eh,00h
str_Keys3:                                      ; string 'keys'; used by MenuShowPlayerStats
        db 06Bh,065h,079h,073h,00h
str_Pstat3:                                     ; string 'pstat'; used by MenuShowPlayerStats
        db 070h,073h,074h,061h,074h,00h
str_Gstat3:                                     ; string 'gstat'; used by MenuShowPlayerStats
        db 067h,073h,074h,061h,074h,00h,00h
str_SRoster:                                    ; string '%s Roster:'; used by ShowRosterStats
        db 025h,073h,020h,052h,06Fh,073h,074h,065h,072h,03Ah,00h
str_Pos2:                                       ; string 'Pos'; used by ShowRosterStats
        db 050h,06Fh,073h,00h
str_No2:                                        ; string 'No'; used by ShowRosterStats
        db 04Eh,06Fh,00h
str_Name2:                                      ; string 'Name'; used by ShowRosterStats
        db 04Eh,061h,06Dh,065h,00h
str_GP8:                                        ; string 'GP'; used by ShowRosterStats
        db 047h,050h,00h
str_G4:                                         ; string ' G'; used by ShowRosterStats
        db 020h,020h,047h,00h
str_A4:                                         ; string ' A'; used by ShowRosterStats
        db 020h,020h,041h,00h
str_PT2:                                        ; string ' PT'; used by ShowRosterStats
        db 020h,050h,054h,00h
str_Shots4:                                     ; string 'Shots'; used by ShowRosterStats
        db 053h,068h,06Fh,074h,073h,00h
str_PIM4:                                       ; string 'PIM'; used by ShowRosterStats
        db 050h,049h,04Dh,00h
str_PlusMinus7:                                 ; string ' +/-' (ShowRosterStats column head); used by
                                                ; ShowRosterStats
        db 020h,02Bh,02Fh,02Dh,00h
str_C5:                                         ; string '%c'; used by ShowRosterStats
        db 025h,063h,00h
str_Min4:                                       ; string ' Min'; used by ShowRosterStats
        db 020h,04Dh,069h,06Eh,00h
str_GAA4:                                       ; string ' GAA'; used by ShowRosterStats
        db 020h,020h,047h,041h,041h,00h
str_W6:                                         ; string ' W'; used by ShowRosterStats
        db 020h,057h,00h
str_L8:                                         ; string ' L'; used by ShowRosterStats
        db 020h,04Ch,00h
str_T6:                                         ; string ' T'; used by ShowRosterStats
        db 020h,054h,00h
str_GA3:                                        ; string ' GA'; used by ShowRosterStats
        db 020h,047h,041h,00h
str_SA3:                                        ; string ' SA'; used by ShowRosterStats
        db 020h,020h,053h,041h,00h
str_PCT2:                                       ; string ' PCT'; used by ShowRosterStats
        db 020h,020h,050h,043h,054h,00h,00h
str_Pal27:                                      ; string 'Pal'; used by GameLineEditor, GameLineEditorLoop
        db 050h,061h,06Ch,00h
str_Lineditp3:                                  ; string 'lineditp'; used by GameLineEditor
        db 06Ch,069h,06Eh,065h,064h,069h,074h,070h,00h
str_Shrt3:                                      ; string 'shrt'; used by GameLineEditor
        db 073h,068h,072h,074h,00h
str_Pntr4:                                      ; string 'pntr'; used by GameLineEditorLoop
        db 070h,06Eh,074h,072h,00h
str_Pointer14:                                  ; string 'Pointer'; used by GameLineEditorLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Embpal5:                                    ; string 'embpal'; used by GameLineEditorLoop
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal28:                                      ; string '!pal'; used by GameLineEditorLoop
        db 021h,070h,061h,06Ch,00h
str_Lelogo2:                                    ; string 'lelogo'; used by DrawLineEditorScreen,
                                                ; GameLineEditorLoop
        db 06Ch,065h,06Ch,06Fh,067h,06Fh,00h
str_Menubuff9:                                  ; string 'menubuff'; used by GameLineEditorLoop
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_C2dS3:                                      ; string '%c %2d %s'; used by DrawGameLineJerseys_join,
                                                ; GameDressPlayer, GameLineEditorLoop ...
        db 025h,063h,020h,025h,032h,064h,020h,025h,073h,00h
str_Key:                                        ; string 'key'; used by LoadGameRoster
        db 06Bh,065h,079h,00h
str_ErrA1:                                      ; FatalError code; used by LoadGameRoster
        db 041h,031h,00h
str_ErrA2:                                      ; FatalError code; used by LoadGameRoster
        db 041h,032h,00h
str_ErrA3:                                      ; FatalError code; used by LoadGameRoster
        db 041h,033h,00h
str_ErrA4:                                      ; FatalError code; used by LoadGameRoster
        db 041h,034h,00h
str_ErrA5:                                      ; FatalError code; used by LoadGameRoster
        db 041h,035h,00h
str_ErrA6:                                      ; FatalError code; used by LoadGameRoster
        db 041h,036h,00h
str_ErrA7:                                      ; FatalError code; used by LoadGameRoster
        db 041h,037h,00h
str_ErrA8:                                      ; FatalError code; used by LoadGameRoster
        db 041h,038h,00h
str_EmbS:                                       ; string 'emb%s'; used by DrawLineEditorScreen
        db 065h,06Dh,062h,025h,073h,00h
str_HOMEPALS3:                                  ; string 'HOMEPALS'; used by DrawLineEditorScreen,
                                                ; LoadJerseyColours
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h
str_Bkgd10:                                     ; string 'bkgd'; used by DrawLineEditorScreen
        db 062h,06Bh,067h,064h,00h
str_Forward:                                    ; string 'forward'; used by DrawLineEditorScreen
        db 066h,06Fh,072h,077h,061h,072h,064h,00h
str_Line1:                                      ; string 'line 1'; used by DrawLineEditorScreen
        db 06Ch,069h,06Eh,065h,020h,031h,00h
str_Line2:                                      ; string 'line 2'; used by DrawLineEditorScreen
        db 06Ch,069h,06Eh,065h,020h,032h,00h
str_Line3:                                      ; string 'line 3'; used by DrawLineEditorScreen
        db 06Ch,069h,06Eh,065h,020h,033h,00h
str_Line4:                                      ; string 'line 4'; used by DrawLineEditorScreen
        db 06Ch,069h,06Eh,065h,020h,034h,00h
str_Power:                                      ; string 'power'; used by DrawLineEditorScreen
        db 070h,06Fh,077h,065h,072h,00h
str_Play1:                                      ; string 'play 1'; used by DrawLineEditorScreen
        db 070h,06Ch,061h,079h,020h,031h,00h
str_Play2:                                      ; string 'play 2'; used by DrawLineEditorScreen
        db 070h,06Ch,061h,079h,020h,032h,00h
str_Penalty:                                    ; string 'penalty'; used by DrawLineEditorScreen
        db 070h,065h,06Eh,061h,06Ch,074h,079h,00h
str_Kill1:                                      ; string 'kill 1'; used by DrawLineEditorScreen
        db 06Bh,069h,06Ch,06Ch,020h,031h,00h
str_Kill2:                                      ; string 'kill 2'; used by DrawLineEditorScreen
        db 06Bh,069h,06Ch,06Ch,020h,032h,00h
str_Defense3:                                   ; string 'defense'; used by DrawLineEditorScreen
        db 064h,065h,066h,065h,06Eh,073h,065h,00h
str_Goaltenders:                                ; string 'goaltenders'; used by DrawLineEditorScreen
        db 067h,06Fh,061h,06Ch,074h,065h,06Eh,064h,065h,072h,073h,00h
str_Extra:                                      ; string 'extra'; used by DrawLineEditorScreen
        db 065h,078h,074h,072h,061h,00h
str_Attackers:                                  ; string 'attackers'; used by DrawLineEditorScreen
        db 061h,074h,074h,061h,063h,06Bh,065h,072h,073h,00h
str_S2dSS2:                                     ; string '%s %2d %s%s'; used by CheckGameRosterComplete
        db 025h,073h,020h,025h,032h,064h,020h,025h,073h,025h,073h,00h
str_dot3:                                       ; string '.'; used by CheckGameRosterComplete
        db 02Eh,00h
str_S7:                                         ; string 's.'; used by CheckGameRosterComplete
        db 073h,02Eh,00h
str_Teams2:                                     ; string 'teams'; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines, MenuSaveTheseLines_x
        db 074h,065h,061h,06Dh,073h,00h
str_ErrB2Perror:                                ; "b2:" perror prefix; used by MenuSaveDefaultLines
        db 062h,032h,03Ah,00h
str_ErrB3:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,033h,00h
str_ErrB4:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,034h,00h
str_ErrB5:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,035h,00h
str_ErrB6:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,036h,00h
str_ErrB7:                                      ; FatalError code; used by MenuSaveDefaultLines,
                                                ; MenuSaveTheseLines_x
        db 042h,037h,00h
str_ErrB2:                                      ; FatalError code; used by MenuSaveTheseLines_x
        db 042h,032h,00h
str_Tstat2:                                     ; string 'tstat'; used by MenuGameShowPlayerStats
        db 074h,073h,074h,061h,074h,00h
str_Keys4:                                      ; string 'keys'; used by MenuGameShowPlayerStats
        db 06Bh,065h,079h,073h,00h
str_Pstat4:                                     ; string 'pstat'; used by MenuGameShowPlayerStats
        db 070h,073h,074h,061h,074h,00h
str_Gstat4:                                     ; string 'gstat'; used by MenuGameShowPlayerStats
        db 067h,073h,074h,061h,074h,00h,00h
