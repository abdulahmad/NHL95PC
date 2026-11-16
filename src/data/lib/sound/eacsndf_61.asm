; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_D4BA0 progbits alloc noexec write align=1
extern NullDriverOpen, NullDriverInit, NullDriverReturn, NullDriverQuery, NullDriverSetTrack, NullDriverMidi, NullDriverPlayDigi, PcSpkInit
extern PcSpkClose, PcSpkService, PcSpkMidi, SbMidi, AdlibDetect, AdlibOpen, AdlibInit, AdlibClose
extern AdlibService, AdlibMidi, ParseBlasterEnv, SbOpen, SbInit, SbClose, SbService, SbQuery
extern SbSetTrack, SbPlayDigi, Mpu401Detect, Mpu401Open, Mpu401Init, Mpu401Close, Mpu401Midi, GusProbe
extern GusDetect, GusInitDigi, GusInitMusic, GusCloseDigi, GusCloseMusic, GusService, GusQuery, GusSetTrack
extern GusPlayDigi, GusMusicMidi, GusDigiMidi
global _Extender, _ExtenderSubtype, Is8087, _dynend, _curbrk, _LpCmdLine, _LpPgmName
global _STACKLOW, _STACKTOP, CMainEnv, CMainResult, UngetChar, SpawnActive, _Envptr, SndDriverTable
global _psp, __no87, _Envptr_w4
SndDriverTable:                                 ; entry points, driver type and open handle of the seven sound
                                                ; drivers (none, PC speaker, AdLib, Sound Blaster,
                                                ; MT-32/MPU-401, GUS music, GUS digital); used by
                                                ; SndDriverHandle, SndOpenDriver
        dd NullDriverOpen
        dd NullDriverOpen
        dd NullDriverInit
        dd NullDriverReturn
        dd NullDriverReturn
        dd NullDriverQuery
        dd NullDriverSetTrack
        dd NullDriverMidi
        dd NullDriverPlayDigi
        db 00h,00h,00h,00h
        db 0FFh,0FFh,0FFh,0FFh
        dd NullDriverOpen
        dd NullDriverOpen
        dd PcSpkInit
        dd PcSpkClose
        dd PcSpkService
        dd NullDriverQuery
        dd NullDriverSetTrack
        dd PcSpkMidi
        dd NullDriverPlayDigi
        db 05h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        dd AdlibDetect
        dd AdlibOpen
        dd AdlibInit
        dd AdlibClose
        dd AdlibService
        dd NullDriverQuery
        dd NullDriverSetTrack
        dd AdlibMidi
        dd NullDriverPlayDigi
        db 01h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        dd ParseBlasterEnv
        dd SbOpen
        dd SbInit
        dd SbClose
        dd SbService
        dd SbQuery
        dd SbSetTrack
        dd SbMidi
        dd SbPlayDigi
        db 04h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        dd Mpu401Detect
        dd Mpu401Open
        dd Mpu401Init
        dd Mpu401Close
        dd NullDriverReturn
        dd NullDriverQuery
        dd NullDriverSetTrack
        dd Mpu401Midi
        dd NullDriverPlayDigi
        db 03h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        dd GusDetect
        dd GusProbe
        dd GusInitMusic
        dd GusCloseMusic
        dd NullDriverReturn
        dd NullDriverQuery
        dd NullDriverSetTrack
        dd GusMusicMidi
        dd NullDriverPlayDigi
        db 01h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        dd GusDetect
        dd GusProbe
        dd GusInitDigi
        dd GusCloseDigi
        dd GusService
        dd GusQuery
        dd GusSetTrack
        dd GusDigiMidi
        dd GusPlayDigi
        db 04h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
_dynend:                                        ; Watcom cstart: end of the dynamic memory, set after the
                                                ; stack is placed; used by __saved_DS
        db 00h,00h,00h,00h
_curbrk:                                        ; Watcom: the break address; cstart sets it to esp and the
                                                ; DOS/4GW sbrk glue moves it; used by __CreateNewNHeap_,
                                                ; __ExpandDGROUP_, __LastFree_ ...
        db 00h,00h,00h,00h
_LpCmdLine:                                     ; Watcom cstart: pointer to the command tail (the port passes
                                                ; its copy); used by __saved_DS
        db 00h,00h,00h,00h
_LpPgmName:                                     ; Watcom cstart: pointer cstart leaves at the program name
                                                ; after the environment strings; used by __saved_DS
        db 00h,00h,00h,00h
_psp:                                           ; Watcom cstart: program segment prefix selector; used by
                                                ; GetPsp, __saved_DS
        db 00h,00h,00h,00h
_STACKLOW:                                      ; Watcom: the bound __STK compares the stack pointer with;
                                                ; used by CMainHook, __STK, __saved_DS
        db 00h,00h,00h,00h
_STACKTOP:                                      ; Watcom cstart: the initial esp; used by __brk_, __saved_DS
        db 00h,00h,00h,00h
CMainEnv:                                       ; Environment pointer passed to main; used by __CMain
        db 00h,00h,00h,00h
CMainResult:                                    ; Value main returned; used by __CMain
        db 00h,00h,00h,00h
UngetChar:                                      ; used by getche_
        db 00h,00h,00h,00h,00h,00h,00h,00h
SpawnActive:                                    ; Set while a DOS child program runs from __dospawn; used by
                                                ; __dospawn
        db 00h,00h,00h,00h
__no87:                                         ; Watcom cstart: set when the environment has NO87; used by
                                                ; __chk8087_, __saved_DS
        db 00h,00h
_Extender:                                      ; Watcom cstart: DOS extender type (1 = DOS/4G); used by
                                                ; CopyDtaIn, CopyDtaOut, EmuRestoreFpuVector ...
        db 00h
_ExtenderSubtype:                               ; Watcom cstart: extender subtype (0 = flat, zero-based data);
                                                ; used by __AdjustAmount_, __ExpandDGROUP_,
                                                ; __HeapManager_expand_ ...
        db 00h
Is8087:                                         ; used by InitFpuFlags, __ExpandDGROUP_, __LastFree_ ...
        db 00h
_Envptr:                                        ; Watcom cstart: far pointer to the environment, offset part;
                                                ; __setenvp_ reads it; used by __saved_DS, __setenvp_
        db 00h,00h,00h,00h
_Envptr_w4:                                     ; _Envptr+4: the selector half of the far pointer; used by
                                                ; __saved_DS, __setenvp_
        db 00h,00h
