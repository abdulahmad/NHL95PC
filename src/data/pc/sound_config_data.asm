; Initialised data of pc/sound_config (src/pc/sound_config).
bits 32
%include "hockey.inc"
section s_D20A8 progbits alloc noexec write align=1
extern str_ANA4, str_ASE2, str_ASW2, str_BOS2, str_BUF4, str_CGY2, str_CHI2, str_DAL2
extern str_DET2, str_EasternConferenceQuarter, str_EDM2, str_FLA2, str_HFD2, str_LA2, str_MTL2, str_NJ2
extern str_NYI2, str_NYR2, str_OTT2, str_PHI2, str_PIT2, str_QUE2, str_SJ2, str_StanleyCupFinals
extern str_STL2, str_TB2, str_TOR2, str_VAN2, str_WesternConferenceQuarter, str_WPG2, str_WSH2
global settingsfile, str_Exhibition2, str_Playoff, str_League2, str_ShowLeague, str_Settings3, lockerindex, lockerteams
global jerseyabbrevs, poroundnames, poroundnameidx, lockerrects, lockeracceptx, lockeraccepty, lockercancelx, lockercancely
global PcSpkSampleReady, str_PCBEEP, str_SBDAC, str_ADLIB, str_MT322, str_SBDAC2, str_PCBEEP2, str_PC
global soundcardrects, sndselbox1, sndselbox2, SoundDevActive, musicdriver, digidriver, musicslot, MusicOn
global musichandle, sndtempbuf, crowddriver, sounddevids, str_CouldNotFindA, str_CardInThisMachine, str_SoundBlaster2, str_Adlib
global str_MT323, str_ULTRASOUND, msg_NoSoundCard, sndcardname, str_InitializingTheMT32Card, str_PleaseWait, msg_InitMT32
settingsfile:                                   ; loaded "settings" PPV file (0 = not loaded); used by
                                                ; LeagueSettingsDlg, LoadSettingsShapes,
                                                ; MenuExhibitionSettings ...
        db 00h,00h,00h,00h
str_Exhibition2:                                ; string 'Exhibition'; used by DrawSettingsHeading_n1,
                                                ; SetModeMenuLabels
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,00h
str_Playoff:                                    ; string 'Playoff'; used by DrawSettingsHeading_n1,
                                                ; SetModeMenuLabels
        db 050h,06Ch,061h,079h,06Fh,066h,066h,00h
str_League2:                                    ; string 'League'; used by DrawSettingsHeading_n1
        db 04Ch,065h,061h,067h,075h,065h,00h
str_ShowLeague:                                 ; string 'Show League'; used by SetModeMenuLabels
        db 053h,068h,06Fh,077h,020h,04Ch,065h,061h,067h,075h,065h,00h
str_Settings3:                                  ; string ' Settings ...'; used by SetModeMenuLabels
        db 020h,053h,065h,074h,074h,069h,06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
lockerindex:                                    ; LockerRoomScreen: locker index of the home and the visiting
                                                ; team; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomLoop
        db 01h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h,04h,00h,00h,00h
        db 06h,00h,00h,00h,07h,00h,00h,00h,09h,00h,00h,00h,0Ah,00h,00h,00h
        db 05h,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Dh,00h,00h,00h
        db 0Eh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h,011h,00h,00h,00h
        db 012h,00h,00h,00h,013h,00h,00h,00h,014h,00h,00h,00h,015h,00h,00h,00h
        db 016h,00h,00h,00h,017h,00h,00h,00h,018h,00h,00h,00h,019h,00h,00h,00h
        db 00h,00h,00h,00h,08h,00h,00h,00h,01Ah,00h,00h,00h,01Bh,00h,00h,00h
lockerteams:                                    ; LockerRoomScreen: team of each locker; OK sets HomeTeam /
                                                ; VisTeam from it; used by DrawLockerJersey,
                                                ; LockerRoomLoop_n0, LockerRoomLoop_n1 ...
        db 018h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h
        db 03h,00h,00h,00h,08h,00h,00h,00h,04h,00h,00h,00h,05h,00h,00h,00h
        db 019h,00h,00h,00h,06h,00h,00h,00h,07h,00h,00h,00h,09h,00h,00h,00h
        db 0Ah,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Dh,00h,00h,00h
        db 0Eh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h,011h,00h,00h,00h
        db 012h,00h,00h,00h,013h,00h,00h,00h,014h,00h,00h,00h,015h,00h,00h,00h
        db 016h,00h,00h,00h,017h,00h,00h,00h,01Ah,00h,00h,00h,01Bh,00h,00h,00h
jerseyabbrevs:                                  ; locker room: team abbreviation for the JERSH / JERSV file
                                                ; names; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomLoop_n6
        dd str_ANA4
        dd str_BOS2
        dd str_BUF4
        dd str_CGY2
        dd str_CHI2
        dd str_DAL2
        dd str_DET2
        dd str_EDM2
        dd str_FLA2
        dd str_HFD2
        dd str_LA2
        dd str_MTL2
        dd str_NJ2
        dd str_NYI2
        dd str_NYR2
        dd str_OTT2
        dd str_PHI2
        dd str_PIT2
        dd str_QUE2
        dd str_STL2
        dd str_SJ2
        dd str_TB2
        dd str_TOR2
        dd str_VAN2
        dd str_WSH2
        dd str_WPG2
        dd str_ASW2
        dd str_ASE2
poroundnames:                                   ; locker room: playoff round names ('Western Conference
                                                ; Quarter' ...); used by DrawLockerJersey, DrawLockerRoom
        dd str_WesternConferenceQuarter
        dd str_EasternConferenceQuarter
        dd str_StanleyCupFinals
poroundnameidx:                                 ; locker room: index into poroundnames; used by
                                                ; DrawLockerJersey, DrawLockerRoom
        db 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        db 01h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
lockerrects:                                    ; 16-byte rects; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerHitTest
        db 023h,00h,00h,00h
        db 046h,00h,00h,00h
        db 040h,01h,00h,00h
        db 090h,01h,00h,00h,059h,01h,00h,00h,046h,00h,00h,00h,076h,02h,00h,00h
        db 090h,01h,00h,00h
        db 095h,00h,00h,00h
        db 0B0h,01h,00h,00h
        db 0C4h,00h,00h,00h
        db 0C4h,01h,00h,00h
        db 0D9h,00h,00h,00h
        db 0B0h,01h,00h,00h
        db 08h,01h,00h,00h,0C4h,01h,00h,00h
        db 079h,01h,00h,00h
        db 0B0h,01h,00h,00h
        db 0A8h,01h,00h,00h
        db 0C4h,01h,00h,00h
        db 0BDh,01h,00h,00h
        db 0B0h,01h,00h,00h
        db 0ECh,01h,00h,00h,0C4h,01h,00h,00h
lockeracceptx:                                  ; locker room: Accept button rectangle, x; used by
                                                ; DrawLockerRoom
        db 01Bh,02h,00h,00h
lockeraccepty:                                  ; locker room: Accept button rectangle, y onward; used by
                                                ; DrawLockerRoom
        db 0B7h,01h,00h,00h,06Bh,02h,00h,00h,0CBh,01h,00h,00h
lockercancelx:                                  ; locker room: Cancel button rectangle, x; used by
                                                ; DrawLockerRoom
        db 015h,00h,00h,00h
lockercancely:                                  ; locker room: Cancel button rectangle, y onward; used by
                                                ; DrawLockerRoom
        db 0B7h,01h,00h,00h,065h,00h,00h,00h,0CBh,01h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
PcSpkSampleReady:                               ; Set to -1 once the PC speaker test sample is loaded; used by
                                                ; SetSoundDevice
        db 00h,00h,00h,00h,02Eh,053h,043h,04Eh,00h,02Eh,050h,041h,054h,00h,02Eh,054h
        db 049h,04Dh,00h,050h,043h,046h,046h,025h,030h,033h,064h,00h,050h,043h,00h
str_PCBEEP:                                     ; string 'PCBEEP'; used by SetSoundDevice
        db 050h,043h,042h,045h,045h,050h,00h,053h,042h,00h
str_SBDAC:                                      ; string 'SBDAC'; used by SetSoundDevice
        db 053h,042h,044h,041h,043h,00h,059h,04Dh,00h
str_ADLIB:                                      ; string 'ADLIB'; used by SetSoundDevice
        db 041h,044h,04Ch,049h,042h,00h,04Dh,054h,00h
str_MT322:                                      ; string 'MT32'; used by SetSoundDevice
        db 04Dh,054h,033h,032h,00h
str_SBDAC2:                                     ; string 'SBDAC'; used by SetSoundDevice
        db 053h,042h,044h,041h,043h,00h,04Eh,04Ch,00h
str_PCBEEP2:                                    ; string 'PCBEEP'; used by SetSoundDevice
        db 050h,043h,042h,045h,045h,050h,00h
str_PC:                                         ; string 'PC'; used by SetSoundDevice
        db 050h,043h,00h
soundcardrects:                                 ; 16-byte rects; used by DrawSoundCardOpts,
                                                ; RedrawSoundCardOpts, SoundCardHitTest
        db 0Eh,00h,00h,00h
        db 01Eh,00h,00h,00h
        db 071h,00h,00h,00h
        db 02Fh,00h,00h,00h,0Eh,00h,00h,00h,033h,00h,00h,00h,071h,00h,00h,00h
        db 044h,00h,00h,00h,0Eh,00h,00h,00h,048h,00h,00h,00h,071h,00h,00h,00h
        db 059h,00h,00h,00h,0Eh,00h,00h,00h,05Dh,00h,00h,00h,071h,00h,00h,00h
        db 06Eh,00h,00h,00h,0Eh,00h,00h,00h,087h,00h,00h,00h,071h,00h,00h,00h
        db 098h,00h,00h,00h,0Eh,00h,00h,00h,072h,00h,00h,00h,071h,00h,00h,00h
        db 083h,00h,00h,00h
sndselbox1:                                     ; sound card dialog: rectangle of the first selection box;
                                                ; used by SoundCardDlgLoop_poll
        db 09h,00h,00h,00h,0A4h,00h,00h,00h,03Ah,00h,00h,00h,0B4h,00h,00h,00h
sndselbox2:                                     ; sound card dialog: rectangle of the second selection box;
                                                ; used by SoundCardDlgLoop_poll
        db 045h,00h,00h,00h,0A4h,00h,00h,00h,076h,00h,00h,00h,0B4h,00h,00h,00h
SoundDevActive:                                 ; Non-zero while a sound device is set up; SetSoundDevice
                                                ; checks and clears it; used by SetSoundDevice
        db 00h,00h,00h,00h
musicdriver:                                    ; Music driver number chosen by SetSoundDevice (1 for the PC
                                                ; speaker; -1 for none); used by PlayDigiSample,
                                                ; SetSoundDevice, sfx
        db 0FFh,0FFh,0FFh,0FFh
digidriver:                                     ; SetSoundDevice: id of the second, digital sound driver (3
                                                ; Sound Blaster, 6 Ultrasound, -1 none); used by
                                                ; SetSoundDevice
        db 0FFh
        db 0FFh,0FFh,0FFh
musicslot:                                      ; music driver slot byte read before fade/wait calls
                                                ; (SndQuery(slot,3) polled until done) in PlayMVI,
                                                ; arena_logos, sound_config; used by AwardsCeremony,
                                                ; CalendarScreen, CoachCutScene ...
        db 00h
MusicOn:                                        ; music present/on flag tested before every song call (with
                                                ; songdata != 0); used by AwardsCeremony, CalendarScreen,
                                                ; ClockTick ...
        db 00h
musichandle:                                    ; music handle passed to the play (PlayDigiBlockLoop) and fade
                                                ; (SetDigiChannelVolume) calls; used by AwardsCeremony,
                                                ; CalendarScreen, DbLineEditor ...
        db 00h,00h,00h,00h
sndtempbuf:                                     ; MenuSoundSettings: the 320 KB TEMP buffer; used by
                                                ; MenuSoundSettings, SoundCardDlgLoop
        db 00h,00h,00h,00h
crowddriver:                                    ; SetSoundDevice: the digital driver the crowd noise calls use
                                                ; (Crowd_Noise, CrowdNoiseOff); used by CrowdNoiseOff,
                                                ; Crowd_Noise, SetSoundDevice
        db 00h
sounddevids:                                    ; [6] sound device ids (10h,1,4,2,8,20h) indexed by the
                                                ; NHL.CFG value; used by LoadNhlCfg, SetSoundDevice
        db 010h,00h,00h,00h,01h,00h,00h,00h,04h,00h,00h,00h,02h,00h,00h,00h
        db 08h,00h,00h,00h,020h,00h,00h,00h
str_CouldNotFindA:                              ; "Could not find a" string literal
        db 043h,06Fh,075h,06Ch,064h,020h,06Eh,06Fh,074h,020h,066h,069h,06Eh,064h,020h,061h
        db 00h
str_CardInThisMachine:                          ; "card in this machine!" string literal
        db 063h,061h,072h,064h,020h,069h,06Eh,020h,074h,068h,069h,073h,020h,06Dh,061h,063h
        db 068h,069h,06Eh,065h,021h,00h
str_SoundBlaster2:                              ; string 'SoundBlaster'; used by SetSoundDevice
        db 053h,06Fh,075h,06Eh,064h,042h,06Ch,061h,073h,074h,065h,072h,00h
str_Adlib:                                      ; string 'Adlib'; used by SetSoundDevice
        db 041h,064h,06Ch,069h,062h,00h
str_MT323:                                      ; string 'MT32'; used by SetSoundDevice
        db 04Dh,054h,033h,032h,00h
str_ULTRASOUND:                                 ; string 'ULTRASOUND'; used by SetSoundDevice
        db 055h,04Ch,054h,052h,041h,053h,04Fh,055h,04Eh,044h,00h
msg_NoSoundCard:                                ; SetSoundDevice message 'Could not find a'; used by
                                                ; SetSoundDevice
        dd str_CouldNotFindA
sndcardname:                                    ; card name string pointer
                                                ; (SoundBlaster/Adlib/MT32/ULTRASOUND); used by SetSoundDevice
        db 00h,00h,00h,00h
        dd str_CardInThisMachine
str_InitializingTheMT32Card:                    ; "Initializing the MT32 card." string literal
        db 049h,06Eh,069h,074h,069h,061h,06Ch,069h,07Ah,069h,06Eh,067h,020h,074h,068h,065h
        db 020h,04Dh,054h,033h,032h,020h,063h,061h,072h,064h,02Eh,00h
str_PleaseWait:                                 ; "Please wait." string literal
        db 050h,06Ch,065h,061h,073h,065h,020h,077h,061h,069h,074h,02Eh,00h
msg_InitMT32:                                   ; message 'Initializing the MT32 card.' / 'Please wait.'; used
                                                ; by SetSoundDevice
        dd str_InitializingTheMT32Card
        dd str_PleaseWait
        db 00h,00h,00h
