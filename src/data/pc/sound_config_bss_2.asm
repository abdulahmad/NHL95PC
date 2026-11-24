; BSS of pc/sound_config (src/pc/sound_config): the module's second run in link order.
bits 32
%include "hockey.inc"
section s_ED75C nobits alloc noexec write align=1
global pl20spr, pl05spr, pl10spr, pg07spr, na05spr, pg01spr, acptspr, na03spr
global pg03spr, chkoffspr, pg05spr, chkonspr, na01spr, titlebckspr, homebckspr, homenamebckspr
global visbckspr, visnamebckspr, SfxTestSample, SpeechMemBlock, speechq, speechbank
pl20spr:                                        ; "pl20" shape; used by DrawExhSetChecks, DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
pl05spr:                                        ; "pl05" period length shape; used by DrawExhSetChecks,
                                                ; DrawLeagueSetChecks, LoadSettingsShapes
        resb 4
pl10spr:                                        ; "pl10" shape; used by DrawExhSetChecks, DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
pg07spr:                                        ; "pg07" shape; used by DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
na05spr:                                        ; "na05" shape; used by DrawLeagueSetDlg, LoadSettingsShapes
        resb 4
pg01spr:                                        ; "pg01" shape; used by DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
acptspr:                                        ; "acpt" shape; used by ExhSetEditLoop, LeagueSetEditLoop,
                                                ; LoadSettingsShapes ...
        resb 4
na03spr:                                        ; "na03" shape; used by DrawLeagueSetDlg, LoadSettingsShapes
        resb 4
pg03spr:                                        ; "pg03" shape; used by DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
chkoffspr:                                      ; unchecked box shape; used by DrawExhSetChecks,
                                                ; DrawLeagueSetChecks, DrawModeSetChecks ...
        resb 4
pg05spr:                                        ; "pg05" shape; used by DrawLeagueSetChecks,
                                                ; LoadSettingsShapes
        resb 4
chkonspr:                                       ; checked box shape; used by DrawExhSetChecks,
                                                ; DrawLeagueSetChecks, DrawModeSetChecks ...
        resb 4
na01spr:                                        ; "na01" shape; used by DrawLeagueSetDlg, LoadSettingsShapes
        resb 4
titlebckspr:                                    ; TitleBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
homebckspr:                                     ; HomeBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
homenamebckspr:                                 ; HomeNameBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
visbckspr:                                      ; VisBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
visnamebckspr:                                  ; VisNameBck; used by DrawLockerJersey, DrawLockerRoom,
                                                ; LockerRoomScreen
        resb 4
SfxTestSample:                                  ; Sample handle the sound setup frees when the device changes;
                                                ; used by SetSoundDevice, sfx
        resb 4
SpeechMemBlock:                                 ; Memory block freed after the speech system shuts down; used
                                                ; by SetSoundDevice
        resb 4
speechq:                                        ; speech queue struct (20 entries + counters at +50h..+60h);
                                                ; used by InitSpeech, QueueSpeechClip, ResetSpeechQueue ...
        resb 4
speechbank:                                     ; 400 x 26h slot table + header at +3B60h..+3B80h; used by
                                                ; CompactSpeechSlot, FindFreeSpeechSlot, FindLoadedSpeechSlot
                                                ; ...
        resb 4
