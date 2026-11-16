; Watcom runtime data.
bits 32
%include "hockey.inc"
section s_D4D0F progbits alloc noexec write align=1
extern dword_F24C8, DefaultFpeHandler, str_EACSNDFLIBJul28
global _osmajor, _osminor, byte_D4D59, SavedTextMode, SavedTextPage, SavedTextRows, VesaBankShift, byte_D4F5C
global byte_D4F5D, byte_D4F5E, FpeHandler, dword_D4F21, PrintfSavedEbx, PrintfSavedEcx, PrintfSavedEdx, PrintfSavedEsi
global PrintfSavedEdi, PrintfSavedReturn, dword_D4F4C, dword_D4F50, dword_D4F58, sndhandlecount, dword_D4F8A, dword_D4F8E
global dword_D4F92, unk_D4D18, unk_D4D32, unk_D4D4C, unk_D4D9A, unk_D4F20, SavedTextColumns, word_D4F68
global word_D4F88
_osmajor:
        db 00h
_osminor:
        db 00h
FpeHandler:
        dd DefaultFpeHandler
        db 00h,00h,00h
unk_D4D18:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
unk_D4D32:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,00h,00h,00h
        db 01h,00h,00h,00h,00h,00h,00h,00h,00h,00h
unk_D4D4C:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h
byte_D4D59:
        db 00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,03h,00h,00h,00h,03h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,02h,00h,00h,00h,04h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h
unk_D4D9A:
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
unk_D4F20:
        db 061h
dword_D4F21:
        db 00h,01h,00h,00h
        dd dword_F24C8
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
dword_D4F4C:
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
