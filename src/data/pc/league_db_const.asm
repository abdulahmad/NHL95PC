; Strings and constants of pc/league_db (src/pc/league_db), in link order.
bits 32
%include "hockey.inc"
section s_C27CC progbits alloc noexec write align=1
global str_Joycal, str_Scrn3, str_Rite, str_Left, str_Pal24, str_Puck, str_PuckBack, str_OneSpace
global str_LEFTJOYSTICK, str_RIGHTJOYSTICK, str_SaveAsGameDatabases, str_Current2, str_EnterANewDatabase, str_DBX, str_ErrorGettingDiskSpace, str_3dKbytesOfFree2
global str_Temp7, str_Current3, str_Pointer11, str_S5, str_FreeAgents, str_DATABASE
str_Joycal:                                     ; string 'joycal'; used by JoystickCalScreen
        db 06Ah,06Fh,079h,063h,061h,06Ch,00h
str_Scrn3:                                      ; string 'scrn'; used by JoystickCalScreen
        db 073h,063h,072h,06Eh,00h
str_Rite:                                       ; string 'rite'; used by JoystickCalScreen
        db 072h,069h,074h,065h,00h
str_Left:                                       ; string 'left'; used by JoystickCalScreen
        db 06Ch,065h,066h,074h,00h
str_Pal24:                                      ; string '!pal'; used by JoystickCalScreen
        db 021h,070h,061h,06Ch,00h
str_Puck:                                       ; string 'puck'; used by JoystickCalScreen
        db 070h,075h,063h,06Bh,00h
str_PuckBack:                                   ; string 'PuckBack'; used by JoystickCalScreen
        db 050h,075h,063h,06Bh,042h,061h,063h,06Bh,00h
str_OneSpace:                                   ; One-space string printed on the joystick calibration screen;
                                                ; used by JoystickCalScreen
        db 020h,00h
str_LEFTJOYSTICK:                               ; string 'LEFT JOYSTICK'; used by CalLeftJoystick
        db 04Ch,045h,046h,054h,020h,04Ah,04Fh,059h,053h,054h,049h,043h,04Bh,00h
str_RIGHTJOYSTICK:                              ; string 'RIGHT JOYSTICK'; used by CalRightJoystick
        db 052h,049h,047h,048h,054h,020h,04Ah,04Fh,059h,053h,054h,049h,043h,04Bh,00h
str_SaveAsGameDatabases:                        ; string 'Save as game databases?'; used by MenuSaveDbs
        db 053h,061h,076h,065h,020h,061h,073h,020h,067h,061h,06Dh,065h,020h,064h,061h,074h
        db 061h,062h,061h,073h,065h,073h,03Fh,00h
str_Current2:                                   ; string 'Current'; used by MenuSaveDbs
        db 043h,075h,072h,072h,065h,06Eh,074h,00h
str_EnterANewDatabase:                          ; string 'Enter a new database name:'; used by MenuSaveDbsAs
        db 045h,06Eh,074h,065h,072h,020h,061h,020h,06Eh,065h,077h,020h,064h,061h,074h,061h
        db 062h,061h,073h,065h,020h,06Eh,061h,06Dh,065h,03Ah,00h
str_DBX:                                        ; string '.DBX'; used by MenuSaveDbsAs
        db 02Eh,044h,042h,058h,00h
str_ErrorGettingDiskSpace:                      ; "error getting disk space free\n" fatal; used by
                                                ; SaveDbsToDir
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_3dKbytesOfFree2:                            ; string '%3d Kbytes of free disk space.'; used by
                                                ; SaveDbsToDir
        db 025h,033h,064h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h
        db 065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h,00h
        db 00h
str_Temp7:                                      ; string 'temp'; used by RunEditRosters
        db 074h,065h,06Dh,070h,00h
str_Current3:                                   ; string 'Current'; used by RunEditRosters
        db 043h,075h,072h,072h,065h,06Eh,074h,00h
str_Pointer11:                                  ; string 'Pointer'; used by RunEditRosters
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_S5:                                         ; string '%s'; used by DrawRosterTitle
        db 025h,073h,00h
str_FreeAgents:                                 ; string 'Free Agents'; used by DrawRosterTitle
        db 046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,073h,00h
str_DATABASE:                                   ; string 'DATABASE : '; used by DrawDatabaseName
        db 044h,041h,054h,041h,042h,041h,053h,045h,020h,03Ah,020h,00h
