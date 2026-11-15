; Menu records for the mode settings screen.
bits 32
%include "hockey.inc"
section s_CEDE7 progbits alloc noexec write align=1
extern modesetlabel, MenuModeSettings, str_Dashes3, str_VisitingTeamGoalie, awgoaliemenu
global menusub_hmgoalie, menusub_awgoalie, hmgoaliemenu
menusub_hmgoalie:
dd hmgoaliemenu
db 03h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,0A9h,00h,00h,00h
db 05Ah,00h,00h,00h
dd str_VisitingTeamGoalie
db 00h,00h,00h,00h
menusub_awgoalie:
dd awgoaliemenu
db 03h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h,0A9h,00h,00h,00h
db 06Bh,00h,00h,00h
dd str_Dashes3
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 06Ch,00h,00h,00h,0A9h,00h,00h,00h,07Eh,00h,00h,00h
dd modesetlabel
dd MenuModeSettings
db 00h,00h,00h,00h,00h,00h,00h,00h
hmgoaliemenu:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,011h,00h,00h,00h
