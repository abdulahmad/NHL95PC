; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_D4F96 progbits alloc noexec write align=1
extern PutBlock, DrawArtXor, DrawArt, DrawArtShadow, str_Fsh, str_3sh, str_SHPI, str_SHPM
extern str_Error0, str_NoSuchFileOr, str_ArgumentListTooBig, str_ExecFormatError, str_BadFileNumber, str_NotEnoughMemory, str_PermissionDenied, str_FileExists
extern str_CrossDeviceLink, str_InvalidArgument, str_FileTableOverflow, str_TooManyOpenFiles, str_NoSpaceLeftOn, str_ArgumentTooLarge, str_ResultTooLarge, str_ResourceDeadlockWouldOccur
global KbdRepeatDelay, PaletteUsable, __real87, SndTimerHandle, MidiTickCount, RetraceMode, KbdKeyTranslate, KbdRepeatTick
global DosErrnoTable, SopenMask, __NHandles, __io_mode, NearestColorCache, NearestColorResult, SnapShapeSizes, FpuSystemFlags
global OldFpuVectorOffset, ArtDrawModeFuncs, SnapFileExts, SnapShapeTags, StrErrorTable, IoModeTable, KbdLastKey, KbdPrevKey
global KbdHeldKey, OldFpuVectorSelector, FpuCr0Bits
SndTimerHandle:                                 ; open sound handle that is serviced first on each timer tick,
                                                ; or -1; used by SeqUpdate, SndClearTables, SndOpenDriver
        db 0FFh,0FFh,0FFh,0FFh
MidiTickCount:                                  ; Tick counter shared by the MIDI drivers; used by AdlibMidi,
                                                ; GusDigiMidi, GusMusicMidi ...
        db 00h,00h,00h,00h,00h,00h
RetraceMode:                                    ; How the wait for retrace works; used by ResetHotkeyState,
                                                ; WaitRetrace
        db 00h,00h,00h,00h
KbdKeyTranslate:                                ; Key code translation table for KbdGetKeyQuiet; used by
                                                ; KbdGetKeyQuiet
        db 00h,00h,00h,00h,00h,048h,00h,00h,00h,050h,00h,00h,00h,00h,00h,00h
        db 00h,04Dh,00h,00h,00h,049h,00h,00h,00h,051h,00h,00h,00h,00h,00h,00h
        db 00h,04Bh,00h,00h,00h,047h,00h,00h,00h,04Fh,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
KbdLastKey:                                     ; Last key returned by KbdGetKeyQuiet; used by KbdGetKeyQuiet
        db 00h,00h
KbdPrevKey:                                     ; Key before the last one; used by KbdGetKeyQuiet
        db 00h,00h
KbdRepeatDelay:                                 ; Countdown before a held key repeats; used by KbdGetKeyQuiet
        db 00h
KbdHeldKey:                                     ; Key being held; used by KbdGetKeyQuiet
        db 00h,00h
KbdRepeatTick:                                  ; Tick of the last key repeat; used by KbdGetKeyQuiet
        db 00h,00h,00h,00h,00h,00h
DosErrnoTable:                                  ; DOS error to errno table; used by __set_errno_dos_
        db 00h,00h,00h,00h,09h,01h,01h,0Bh,06h,04h,05h,05h,05h,02h,03h,0FFh
        db 0FFh,07h,08h,06h,08h,01h,0FFh
SopenMask:                                      ; used by sopen_
        db 00h,00h,00h,00h
__NHandles:                                     ; Number of file handles; used by __IOMode_
        db 014h,00h,00h,00h
IoModeTable:                                    ; Default stream modes for the standard handles
        db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h
        db 02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
__io_mode:                                      ; File handle mode table pointer; used by __IOMode_,
                                                ; __SetIOMode_
        dd IoModeTable
NearestColorCache:                              ; Last colour looked up by FindNearestColor; used by
                                                ; FindNearestColor
        db 00h,00h,00h,00h
NearestColorResult:                             ; Last palette index found by FindNearestColor; used by
                                                ; FindNearestColor
        db 00h,00h,00h,00h
PaletteUsable:                                  ; 1 for each palette entry FindNearestColor may pick; used by
                                                ; FindNearestColor
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
        db 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,00h,00h
ArtDrawModeFuncs:                               ; Draw routine for each art draw mode; used by
                                                ; DrawArtAnyFormat
        dd PutBlock
        dd DrawArtXor
        dd DrawArt
        dd DrawArtShadow
SnapFileExts:                                   ; File extension per screenshot format; used by
                                                ; SnapScreenToShape
        dd str_Fsh
        dd str_3sh
SnapShapeSizes:                                 ; Shape size per screenshot format; used by SnapScreenToShape
        db 07Bh,00h,00h,00h,01Eh,00h,00h,00h
SnapShapeTags:                                  ; Shape file tag per screenshot format; used by
                                                ; SnapScreenToShape
        dd str_SHPI
        dd str_SHPM
FpuSystemFlags:                                 ; used by EmuRestoreRealVector, SetSystemFpuFlag
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
OldFpuVectorOffset:                             ; used by EmuRestoreFpuVector, HookCoprocessorVector
        db 00h,00h,00h,00h
OldFpuVectorSelector:                           ; used by EmuRestoreFpuVector, HookCoprocessorVector
        db 00h,00h
FpuCr0Bits:                                     ; used by EmuRestoreFpuVector, EmuRestoreRealVector,
                                                ; InitFpuFlags ...
        db 00h,00h
__real87:                                       ; Watcom: a real coprocessor is present; used by InitFpuFlags,
                                                ; __sys_fini_387_emulator
        db 00h,00h,00h,00h,0Fh,00h,00h,00h
StrErrorTable:                                  ; errno message strings for strerror; used by strerror_
        dd str_Error0
        dd str_NoSuchFileOr
        dd str_ArgumentListTooBig
        dd str_ExecFormatError
        dd str_BadFileNumber
        dd str_NotEnoughMemory
        dd str_PermissionDenied
        dd str_FileExists
        dd str_CrossDeviceLink
        dd str_InvalidArgument
        dd str_FileTableOverflow
        dd str_TooManyOpenFiles
        dd str_NoSpaceLeftOn
        dd str_ArgumentTooLarge
        dd str_ResultTooLarge
        dd str_ResourceDeadlockWouldOccur
