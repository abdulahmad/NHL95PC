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
SndTimerHandle:
        db 0FFh,0FFh,0FFh,0FFh
MidiTickCount:
        db 00h,00h,00h,00h,00h,00h
RetraceMode:
        db 00h,00h,00h,00h
KbdKeyTranslate:
        db 00h,00h,00h,00h,00h,048h,00h,00h,00h,050h,00h,00h,00h,00h,00h,00h
        db 00h,04Dh,00h,00h,00h,049h,00h,00h,00h,051h,00h,00h,00h,00h,00h,00h
        db 00h,04Bh,00h,00h,00h,047h,00h,00h,00h,04Fh,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
KbdLastKey:
        db 00h,00h
KbdPrevKey:
        db 00h,00h
KbdRepeatDelay:
        db 00h
KbdHeldKey:
        db 00h,00h
KbdRepeatTick:
        db 00h,00h,00h,00h,00h,00h
DosErrnoTable:
        db 00h,00h,00h,00h,09h,01h,01h,0Bh,06h,04h,05h,05h,05h,02h,03h,0FFh
        db 0FFh,07h,08h,06h,08h,01h,0FFh
SopenMask:
        db 00h,00h,00h,00h
__NHandles:
        db 014h,00h,00h,00h
IoModeTable:
        db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h
        db 02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
__io_mode:
        dd IoModeTable
NearestColorCache:
        db 00h,00h,00h,00h
NearestColorResult:
        db 00h,00h,00h,00h
PaletteUsable:
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
ArtDrawModeFuncs:
        dd PutBlock
        dd DrawArtXor
        dd DrawArt
        dd DrawArtShadow
SnapFileExts:
        dd str_Fsh
        dd str_3sh
SnapShapeSizes:
        db 07Bh,00h,00h,00h,01Eh,00h,00h,00h
SnapShapeTags:
        dd str_SHPI
        dd str_SHPM
FpuSystemFlags:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
OldFpuVectorOffset:
        db 00h,00h,00h,00h
OldFpuVectorSelector:
        db 00h,00h
FpuCr0Bits:
        db 00h,00h
__real87:
        db 00h,00h,00h,00h,0Fh,00h,00h,00h
StrErrorTable:
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
