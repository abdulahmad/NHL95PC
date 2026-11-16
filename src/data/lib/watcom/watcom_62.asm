; Watcom runtime data.
bits 32
%include "hockey.inc"
section s_D4D0F progbits alloc noexec write align=1
extern __ClosedStreams, DefaultFpeHandler, str_EACSNDFLIBJul28
global _osmajor, _osminor, __iob_flags, SavedTextMode, SavedTextPage, SavedTextRows, VesaBankShift, byte_D4F5C
global byte_D4F5D, byte_D4F5E, FpeHandler, _fmode, PrintfSavedEbx, PrintfSavedEcx, PrintfSavedEdx, PrintfSavedEsi
global PrintfSavedEdi, PrintfSavedReturn, VesaBank, dword_D4F50, dword_D4F58, sndhandlecount, dword_D4F8A, dword_D4F8E
global dword_D4F92, __iob, __stdout_buf, unk_D4D4C, __iob_end, __NFiles, SavedTextColumns, word_D4F68
global word_D4F88
_osmajor:
        db 00h
_osminor:
        db 00h
FpeHandler:
        dd DefaultFpeHandler
        db 00h,00h,00h
__iob:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
__stdout_buf:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,00h,00h,00h
        db 01h,00h,00h,00h,00h,00h,00h,00h,00h,00h
unk_D4D4C:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h
__iob_flags:
        db 00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,03h,00h,00h,00h,03h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,02h,00h,00h,00h,04h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h
__iob_end:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h
__NFiles:
        db 061h
_fmode:
        db 00h,01h,00h,00h
        dd __ClosedStreams
        db 00h,00h,00h
PrintfSavedEbx:
        db 00h,00h,00h,00h
PrintfSavedEcx:
        db 00h,00h,00h,00h
PrintfSavedEdx:
        db 00h,00h,00h,00h
PrintfSavedEsi:
        db 00h,00h,00h,00h
PrintfSavedEdi:
        db 00h,00h,00h,00h
PrintfSavedReturn:
        db 00h,00h,00h,00h
SavedTextMode:
        db 00h
SavedTextPage:
        db 00h
SavedTextColumns:
        db 00h,00h
SavedTextRows:
        db 00h,00h,00h,00h
VesaBank:
        db 00h,00h,00h,00h
dword_D4F50:
        db 00h,00h,00h,00h
VesaBankShift:
        db 00h,00h,00h,00h
dword_D4F58:
        db 00h,00h,00h,00h
byte_D4F5C:
        db 00h
byte_D4F5D:
        db 00h
byte_D4F5E:
        db 00h,00h
        dd str_EACSNDFLIBJul28
sndhandlecount:
        db 00h,00h,00h,00h
word_D4F68:
        db 01h,00h,02h,00h,04h,00h,08h,00h,010h,00h,020h,00h,040h,00h,080h,00h
        db 00h,01h,00h,02h,00h,04h,00h,08h,00h,010h,00h,020h,00h,040h,00h,080h
word_D4F88:
        db 00h,00h
dword_D4F8A:
        db 00h,00h,00h,00h
dword_D4F8E:
        db 01h,00h,00h,00h
dword_D4F92:
        db 01h,00h,00h,00h
