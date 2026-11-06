; Menu records for the mode settings screen.
bits 32
%include "hockey.inc"
section s_CEDE7 progbits alloc noexec write align=1
extern modesetlabel, MenuModeSettings, unk_CDC1E, unk_CDC80, unk_CEEAF
global dword_CEDE7, dword_CEE07, unk_CEE4F
dword_CEDE7:
dd unk_CEE4F
db 03h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,0A9h,00h,00h,00h
db 05Ah,00h,00h,00h
dd unk_CDC80
db 00h,00h,00h,00h
dword_CEE07:
dd unk_CEEAF
db 03h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h,0A9h,00h,00h,00h
db 06Bh,00h,00h,00h
dd unk_CDC1E
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 06Ch,00h,00h,00h,0A9h,00h,00h,00h,07Eh,00h,00h,00h
dd modesetlabel
dd MenuModeSettings
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CEE4F:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,011h,00h,00h,00h
