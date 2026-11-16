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
global _STACKLOW, _STACKTOP, CMainEnv, CMainResult, UngetChar, dword_D4D00, _Envptr, SndDriverTable
global _psp, __no87, _Envptr_w4
SndDriverTable:
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
_dynend:
        db 00h,00h,00h,00h
_curbrk:
        db 00h,00h,00h,00h
_LpCmdLine:
        db 00h,00h,00h,00h
_LpPgmName:
        db 00h,00h,00h,00h
_psp:
        db 00h,00h,00h,00h
_STACKLOW:
        db 00h,00h,00h,00h
_STACKTOP:
        db 00h,00h,00h,00h
CMainEnv:
        db 00h,00h,00h,00h
CMainResult:
        db 00h,00h,00h,00h
UngetChar:
        db 00h,00h,00h,00h,00h,00h,00h,00h
dword_D4D00:
        db 00h,00h,00h,00h
__no87:
        db 00h,00h
_Extender:
        db 00h
_ExtenderSubtype:
        db 00h
Is8087:
        db 00h
_Envptr:
        db 00h,00h,00h,00h
_Envptr_w4:
        db 00h,00h
