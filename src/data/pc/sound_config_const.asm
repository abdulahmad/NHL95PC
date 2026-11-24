; Strings and constants of pc/sound_config (src/pc/sound_config), in link order.
bits 32
%include "hockey.inc"
section s_C3480 progbits alloc noexec write align=1
global str_Settings, str_On, str_Off, str_Acpt, str_Canc, str_Na01, str_Na03, str_Na05
global str_Pg01, str_Pg03, str_Pg05, str_Pg07, str_Pl05, str_Pl10, str_Pl20, str_ANA4
global str_BOS2, str_BUF4, str_CGY2, str_CHI2, str_DAL2, str_DET2, str_EDM2, str_FLA2
global str_HFD2, str_LA2, str_MTL2, str_NJ2, str_NYI2, str_NYR2, str_OTT2, str_PHI2
global str_PIT2, str_QUE2, str_STL2, str_SJ2, str_TB2, str_TOR2, str_VAN2, str_WSH2
global str_WPG2, str_ASW2, str_ASE2, str_WesternConferenceQuarter, str_EasternConferenceQuarter, str_StanleyCupFinals, str_HomeBck, str_VisBck
global str_HomeNameBck, str_VisNameBck, str_TitleBck, str_Lockroom, str_P01, str_Room, str_JERSH, str_00002
global str_JERSV, str_Vs, str_Accept, str_Cancel2, str_HomeTeam, str_VisitingTeam, str_ExhibitionGame, str_Iff11
global str_Jersey, str_Pointer20, str_Temp8, str_Buffer, str_Sound4, str_Dbx2, str_PCSpeaker, str_SoundBlaster
global str_ADLib, str_MT32, str_UltraSound, str_Pointer21, str_Iff12, str_Maindesk2, str_Slapshot, str_MT32HOCK
global str_NHL3, str_R4, str_CantOpenNhlCfg, str_04x, str_Emmcopybuf, str_RoughingPen, str_ChargingPen, str_SlashingPen
global str_XcheckPen, str_HookingPen, str_TrippingPen, str_InterferPen, str_HoldingPen, str_AbusePen, str_CheckbndPen, str_BoardingPen
global str_ElbowingPen, str_HistickPen, str_SpearingPen
str_Settings:                                   ; string 'settings'; used by LoadSettingsShapes
        db 073h,065h,074h,074h,069h,06Eh,067h,073h,00h
str_On:                                         ; string 'On '; used by LoadSettingsShapes
        db 04Fh,06Eh,020h,020h,00h
str_Off:                                        ; string 'Off '; used by LoadSettingsShapes
        db 04Fh,066h,066h,020h,00h
str_Acpt:                                       ; string 'acpt'; used by LoadSettingsShapes
        db 061h,063h,070h,074h,00h
str_Canc:                                       ; string 'canc'; used by LoadSettingsShapes
        db 063h,061h,06Eh,063h,00h
str_Na01:                                       ; string 'na01'; used by LoadSettingsShapes
        db 06Eh,061h,030h,031h,00h
str_Na03:                                       ; string 'na03'; used by LoadSettingsShapes
        db 06Eh,061h,030h,033h,00h
str_Na05:                                       ; string 'na05'; used by LoadSettingsShapes
        db 06Eh,061h,030h,035h,00h
str_Pg01:                                       ; string 'pg01'; used by LoadSettingsShapes
        db 070h,067h,030h,031h,00h
str_Pg03:                                       ; string 'pg03'; used by LoadSettingsShapes
        db 070h,067h,030h,033h,00h
str_Pg05:                                       ; string 'pg05'; used by LoadSettingsShapes
        db 070h,067h,030h,035h,00h
str_Pg07:                                       ; string 'pg07'; used by LoadSettingsShapes
        db 070h,067h,030h,037h,00h
str_Pl05:                                       ; string 'pl05'; used by LoadSettingsShapes
        db 070h,06Ch,030h,035h,00h
str_Pl10:                                       ; string 'pl10'; used by LoadSettingsShapes
        db 070h,06Ch,031h,030h,00h
str_Pl20:                                       ; string 'pl20'; used by LoadSettingsShapes
        db 070h,06Ch,032h,030h,00h,00h
str_ANA4:                                       ; "ANA" string literal
        db 041h,04Eh,041h,00h
str_BOS2:                                       ; "BOS" string literal
        db 042h,04Fh,053h,00h
str_BUF4:                                       ; "BUF" string literal
        db 042h,055h,046h,00h
str_CGY2:                                       ; "CGY" string literal
        db 043h,047h,059h,00h
str_CHI2:                                       ; "CHI" string literal
        db 043h,048h,049h,00h
str_DAL2:                                       ; "DAL" string literal
        db 044h,041h,04Ch,00h
str_DET2:                                       ; "DET" string literal
        db 044h,045h,054h,00h
str_EDM2:                                       ; "EDM" string literal
        db 045h,044h,04Dh,00h
str_FLA2:                                       ; "FLA" string literal
        db 046h,04Ch,041h,00h
str_HFD2:                                       ; "HFD" string literal
        db 048h,046h,044h,00h
str_LA2:                                        ; "LA" string literal
        db 04Ch,041h,00h
str_MTL2:                                       ; "MTL" string literal
        db 04Dh,054h,04Ch,00h
str_NJ2:                                        ; "NJ" string literal
        db 04Eh,04Ah,00h
str_NYI2:                                       ; "NYI" string literal
        db 04Eh,059h,049h,00h
str_NYR2:                                       ; "NYR" string literal
        db 04Eh,059h,052h,00h
str_OTT2:                                       ; "OTT" string literal
        db 04Fh,054h,054h,00h
str_PHI2:                                       ; "PHI" string literal
        db 050h,048h,049h,00h
str_PIT2:                                       ; "PIT" string literal
        db 050h,049h,054h,00h
str_QUE2:                                       ; "QUE" string literal
        db 051h,055h,045h,00h
str_STL2:                                       ; "STL" string literal
        db 053h,054h,04Ch,00h
str_SJ2:                                        ; "SJ" string literal
        db 053h,04Ah,00h
str_TB2:                                        ; "TB" string literal
        db 054h,042h,00h
str_TOR2:                                       ; "TOR" string literal
        db 054h,04Fh,052h,00h
str_VAN2:                                       ; "VAN" string literal
        db 056h,041h,04Eh,00h
str_WSH2:                                       ; "WSH" string literal
        db 057h,053h,048h,00h
str_WPG2:                                       ; "WPG" string literal
        db 057h,050h,047h,00h
str_ASW2:                                       ; "ASW" string literal
        db 041h,053h,057h,00h
str_ASE2:                                       ; "ASE" string literal
        db 041h,053h,045h,00h
str_WesternConferenceQuarter:                   ; "Western Conference Quarter-Finals" string literal
        db 057h,065h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,020h,051h,075h,061h,072h,074h,065h,072h,02Dh,046h,069h,06Eh,061h,06Ch
        db 073h,00h
str_EasternConferenceQuarter:                   ; "Eastern Conference Quarter-Finals" string literal
        db 045h,061h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,020h,051h,075h,061h,072h,074h,065h,072h,02Dh,046h,069h,06Eh,061h,06Ch
        db 073h,00h
str_StanleyCupFinals:                           ; string 'Stanley Cup Finals'
        db 053h,074h,061h,06Eh,06Ch,065h,079h,020h,043h,075h,070h,06h,020h,046h,069h,06Eh
        db 061h,06Ch,073h,00h
str_HomeBck:                                    ; string 'HomeBck'; used by LockerRoomScreen
        db 048h,06Fh,06Dh,065h,042h,063h,06Bh,00h
str_VisBck:                                     ; string 'VisBck'; used by LockerRoomScreen
        db 056h,069h,073h,042h,063h,06Bh,00h
str_HomeNameBck:                                ; string 'HomeNameBck'; used by LockerRoomScreen
        db 048h,06Fh,06Dh,065h,04Eh,061h,06Dh,065h,042h,063h,06Bh,00h
str_VisNameBck:                                 ; string 'VisNameBck'; used by LockerRoomScreen
        db 056h,069h,073h,04Eh,061h,06Dh,065h,042h,063h,06Bh,00h
str_TitleBck:                                   ; string 'TitleBck'; used by LockerRoomScreen
        db 054h,069h,074h,06Ch,065h,042h,063h,06Bh,00h
str_Lockroom:                                   ; string 'lockroom'; used by DrawLockerRoom
        db 06Ch,06Fh,063h,06Bh,072h,06Fh,06Fh,06Dh,00h
str_P01:                                        ; string '!p01'; used by DrawLockerJersey, DrawLockerRoom
        db 021h,070h,030h,031h,00h
str_Room:                                       ; string 'room'; used by DrawLockerRoom
        db 072h,06Fh,06Fh,06Dh,00h
str_JERSH:                                      ; string 'JER%sH'; used by DrawLockerJersey, DrawLockerRoom
        db 04Ah,045h,052h,025h,073h,048h,00h
str_00002:                                      ; string '0000'; used by DrawLockerJersey, DrawLockerRoom
        db 030h,030h,030h,030h,00h
str_JERSV:                                      ; string 'JER%sV'; used by DrawLockerJersey, DrawLockerRoom
        db 04Ah,045h,052h,025h,073h,056h,00h
str_Vs:                                         ; string 'vs'; used by DrawLockerRoom
        db 076h,073h,00h
str_Accept:                                     ; string 'Accept'; used by DrawLockerRoom
        db 041h,063h,063h,065h,070h,074h,00h
str_Cancel2:                                    ; string 'Cancel'; used by DrawLockerRoom
        db 043h,061h,06Eh,063h,065h,06Ch,00h
str_HomeTeam:                                   ; string 'Home Team'; used by DrawLockerRoom
        db 048h,06Fh,06Dh,065h,020h,054h,065h,061h,06Dh,00h
str_VisitingTeam:                               ; string 'Visiting Team'; used by DrawLockerRoom
        db 056h,069h,073h,069h,074h,069h,06Eh,067h,020h,054h,065h,061h,06Dh,00h
str_ExhibitionGame:                             ; string 'Exhibition Game'; used by DrawLockerRoom
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,020h,047h,061h,06Dh,065h,00h
str_Iff11:                                      ; string '.iff'; used by DrawLockerRoom
        db 02Eh,069h,066h,066h,00h
str_Jersey:                                     ; string 'jersey'; used by DrawLockerRoom
        db 06Ah,065h,072h,073h,065h,079h,00h
str_Pointer20:                                  ; string 'Pointer'; used by LockerRoomLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h,00h,00h
str_Temp8:                                      ; string 'temp'; used by MenuSoundSettings
        db 074h,065h,06Dh,070h,00h
str_Buffer:                                     ; string 'buffer'; used by MenuSoundSettings
        db 062h,075h,066h,066h,065h,072h,00h
str_Sound4:                                     ; string 'sound'; used by DrawSoundCardDlg
        db 073h,06Fh,075h,06Eh,064h,00h
str_Dbx2:                                       ; string 'dbx2'; used by DrawSoundCardDlg
        db 064h,062h,078h,032h,00h
str_PCSpeaker:                                  ; string 'PC Speaker'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 050h,043h,020h,053h,070h,065h,061h,06Bh,065h,072h,00h
str_SoundBlaster:                               ; string 'Sound Blaster'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 053h,06Fh,075h,06Eh,064h,020h,042h,06Ch,061h,073h,074h,065h,072h,00h
str_ADLib:                                      ; string 'AD Lib'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 041h,044h,020h,04Ch,069h,062h,00h
str_MT32:                                       ; string 'MT-32'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 04Dh,054h,02Dh,033h,032h,00h
str_UltraSound:                                 ; string 'UltraSound'; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts
        db 055h,06Ch,074h,072h,061h,053h,06Fh,075h,06Eh,064h,00h
str_Pointer21:                                  ; string 'Pointer'; used by SoundCardDlgLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff12:                                      ; string '.iff'; used by SoundCardDlgLoop_poll
        db 02Eh,069h,066h,066h,00h
str_Maindesk2:                                  ; string 'maindesk'; used by SoundCardDlgLoop_poll
        db 06Dh,061h,069h,06Eh,064h,065h,073h,06Bh,00h
str_Slapshot:                                   ; string 'slapshot'; used by SetSoundDevice
        db 073h,06Ch,061h,070h,073h,068h,06Fh,074h,00h
str_MT32HOCK:                                   ; string 'MT32HOCK'; used by SetSoundDevice
        db 04Dh,054h,033h,032h,048h,04Fh,043h,04Bh,00h
str_NHL3:                                       ; string 'NHL'; used by SetSoundDevice
        db 04Eh,048h,04Ch,00h
str_R4:                                         ; string 'r+'; used by SetSoundDevice
        db 072h,02Bh,00h
str_CantOpenNhlCfg:                             ; string 'cannot open nhl.cfg'; used by SetSoundDevice
        db 063h,061h,06Eh,06Eh,06Fh,074h,020h,06Fh,070h,065h,06Eh,020h,06Eh,068h,06Ch,02Eh
        db 063h,066h,067h,00h
str_04x:                                        ; string '%04x '; used by SetSoundDevice
        db 025h,030h,034h,078h,0Ah,00h
str_Emmcopybuf:                                 ; string 'emmcopybuf'; used by SetSoundDevice
        db 065h,06Dh,06Dh,063h,06Fh,070h,079h,062h,075h,066h,00h
str_RoughingPen:                                ; "roughing.pen" string literal
        db 072h,06Fh,075h,067h,068h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_ChargingPen:                                ; "charging.pen" string literal
        db 063h,068h,061h,072h,067h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_SlashingPen:                                ; "slashing.pen" string literal
        db 073h,06Ch,061h,073h,068h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_XcheckPen:                                  ; "xcheck.pen" string literal
        db 078h,063h,068h,065h,063h,06Bh,02Eh,070h,065h,06Eh,00h
str_HookingPen:                                 ; "hooking.pen" string literal
        db 068h,06Fh,06Fh,06Bh,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_TrippingPen:                                ; "tripping.pen" string literal
        db 074h,072h,069h,070h,070h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_InterferPen:                                ; "interfer.pen" string literal
        db 069h,06Eh,074h,065h,072h,066h,065h,072h,02Eh,070h,065h,06Eh,00h
str_HoldingPen:                                 ; "holding.pen" string literal
        db 068h,06Fh,06Ch,064h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_AbusePen:                                   ; "abuse.pen" string literal
        db 061h,062h,075h,073h,065h,02Eh,070h,065h,06Eh,00h
str_CheckbndPen:                                ; "checkbnd.pen" string literal
        db 063h,068h,065h,063h,06Bh,062h,06Eh,064h,02Eh,070h,065h,06Eh,00h
str_BoardingPen:                                ; "boarding.pen" string literal
        db 062h,06Fh,061h,072h,064h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_ElbowingPen:                                ; "elbowing.pen" string literal
        db 065h,06Ch,062h,06Fh,077h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
str_HistickPen:                                 ; "histick.pen" string literal
        db 068h,069h,073h,074h,069h,063h,06Bh,02Eh,070h,065h,06Eh,00h
str_SpearingPen:                                ; "spearing.pen" string literal
        db 073h,070h,065h,061h,072h,069h,06Eh,067h,02Eh,070h,065h,06Eh,00h
