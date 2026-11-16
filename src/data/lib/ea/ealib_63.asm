; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_D4F96 progbits alloc noexec write align=1
extern PutBlock, DrawArtXor, DrawArt, DrawArtShadow, str_Fsh, str_3sh, str_SHPI, str_SHPM
extern str_Error0, str_NoSuchFileOr, str_ArgumentListTooBig, str_ExecFormatError, str_BadFileNumber, str_NotEnoughMemory, str_PermissionDenied, str_FileExists
extern str_CrossDeviceLink, str_InvalidArgument, str_FileTableOverflow, str_TooManyOpenFiles, str_NoSpaceLeftOn, str_ArgumentTooLarge, str_ResultTooLarge, str_ResourceDeadlockWouldOccur
global byte_D4FE8, byte_D506C, __real87, SndTimerHandle, dword_D4F9A, RetraceMode, dword_D4FA4, dword_D4FEB
global DosErrnoTable, SopenMask, __NHandles, __io_mode, dword_D5064, dword_D5068, dword_D5184, FpuSystemFlags
global OldFpuVectorOffset, ArtDrawModeFuncs, off_D517C, off_D518C, off_D51E4, unk_D5010, word_D4FE4, word_D4FE6
global word_D4FE9, OldFpuVectorSelector, FpuCr0Bits
SndTimerHandle:
        db 0FFh,0FFh,0FFh,0FFh
dword_D4F9A:
        db 00h,00h,00h,00h,00h,00h
RetraceMode:
        db 00h,00h,00h,00h
dword_D4FA4:
        db 00h,00h,00h,00h,00h,048h,00h,00h,00h,050h,00h,00h,00h,00h,00h,00h
        db 00h,04Dh,00h,00h,00h,049h,00h,00h,00h,051h,00h,00h,00h,00h,00h,00h
        db 00h,04Bh,00h,00h,00h,047h,00h,00h,00h,04Fh,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
word_D4FE4:
        db 00h,00h
word_D4FE6:
        db 00h,00h
byte_D4FE8:
        db 00h
word_D4FE9:
        db 00h,00h
dword_D4FEB:
        db 00h,00h,00h,00h,00h,00h
DosErrnoTable:
        db 00h,00h,00h,00h,09h,01h,01h,0Bh,06h,04h,05h,05h,05h,02h,03h,0FFh
        db 0FFh,07h,08h,06h,08h,01h,0FFh
SopenMask:
        db 00h,00h,00h,00h
__NHandles:
        db 014h,00h,00h,00h
unk_D5010:
        db 01h,00h,00h,00h,02h,00h,00h,00h,02h,00h,00h,00h,03h,00h,00h,00h
        db 02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
__io_mode:
        dd unk_D5010
dword_D5064:
        db 00h,00h,00h,00h
dword_D5068:
        db 00h,00h,00h,00h
byte_D506C:
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
off_D517C:
        dd str_Fsh
        dd str_3sh
dword_D5184:
        db 07Bh,00h,00h,00h,01Eh,00h,00h,00h
off_D518C:
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
off_D51E4:
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
