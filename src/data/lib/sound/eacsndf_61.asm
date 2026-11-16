; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_D4BA0 progbits alloc noexec write align=1
extern NullDriverOpen, NullDriverInit, NullDriverReturn, NullDriverQuery, NullDriverSetTrack, NullDriverMidi, NullDriverPlayDigi, sub_9D698
extern sub_9D6E6, sub_9D6F3, sub_9DAAC, sub_9DC9F, sub_9DE9C, sub_9DEA9, sub_9DEBE, sub_9DF73
extern sub_9DF80, sub_9E676, ParseBlasterEnv, SbOpen, SbInit, SbClose, SbService, SbQuery
extern SbSetTrack, SbPlayDigi, sub_9FD94, sub_9FD9A, sub_9FDEA, sub_9FE3B, sub_9FFA0, GusProbe
extern GusDetect, GusInitDigi, GusInitMusic, GusCloseDigi, GusCloseMusic, GusService, GusQuery, GusSetTrack
extern GusPlayDigi, GusMusicMidi, GusDigiMidi
global _Extender, _ExtenderSubtype, Is8087, _dynend, _curbrk, _LpCmdLine, _LpPgmName
global _STACKLOW, _STACKTOP, dword_D4CF0, dword_D4CF4, UngetChar, dword_D4D00, _Envptr, SndDriverTable
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
        dd sub_9D698
        dd sub_9D6E6
        dd sub_9D6F3
        dd NullDriverQuery
        dd NullDriverSetTrack
        dd sub_9DAAC
        dd NullDriverPlayDigi
        db 05h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        dd sub_9DE9C
        dd sub_9DEA9
        dd sub_9DEBE
        dd sub_9DF73
        dd sub_9DF80
        dd NullDriverQuery
        dd NullDriverSetTrack
        dd sub_9E676
        dd NullDriverPlayDigi
        db 01h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        dd ParseBlasterEnv
        dd SbOpen
        dd SbInit
        dd SbClose
        dd SbService
        dd SbQuery
        dd SbSetTrack
        dd sub_9DC9F
        dd SbPlayDigi
        db 04h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
        dd sub_9FD94
        dd sub_9FD9A
        dd sub_9FDEA
        dd sub_9FE3B
        dd NullDriverReturn
        dd NullDriverQuery
        dd NullDriverSetTrack
        dd sub_9FFA0
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
dword_D4CF0:
        db 00h,00h,00h,00h
dword_D4CF4:
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
