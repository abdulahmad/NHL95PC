; Edit Rosters menu slots for free agents, lines, and moving a player to the other roster.
bits 32
%include "hockey.inc"
section s_D0151 progbits alloc noexec write align=1
extern ShowFreeAgents, EditTeamLines, CreateFreeAgent, FindPlayer, LineEdDone, MenuLineEdCancel, unk_CFBE8, unk_CFCF2
extern unk_CFE08, unk_CFF51, unk_D006E, str_FreeAgents2, str_FindPlayer, unk_D010E, unk_D0118, unk_D0122
extern unk_D012E, unk_D0139
global roster1divmenus, roster2divmenus, menu_r1_tofa, menu_r1_toroster2, menu_r2_tofa, menu_r2_toroster1, menu_r1_freeagents, menu_r2_freeagents
global menu_r1_editlines, menu_r2_editlines, unk_D01F9, str_MoveToFreeAgent, str_MoveToRoster2, str_MoveToRoster1, str_CreateFreeAgent, str_EditTeamLines
global unk_D031D, unk_D039D, str_File3, str_Roster12, str_Roster22, str_EditRoster1, str_EditRoster2, unk_D0450
global str_Done5, str_Cancel8, unk_D04FC, str_DressPlayer2, str_ScratchPlayer2, unk_D0558
roster1divmenus:
dd unk_CFBE8
db 06h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,066h,00h,00h,00h
db 023h,00h,00h,00h
dd unk_D0118
db 00h,00h,00h,00h
dd unk_CFCF2
db 06h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h,066h,00h,00h,00h
db 035h,00h,00h,00h
dd unk_D0122
db 00h,00h,00h,00h
dd unk_CFE08
db 07h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,066h,00h,00h,00h
db 047h,00h,00h,00h
dd unk_D012E
db 00h,00h,00h,00h
dd unk_CFF51
db 07h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,066h,00h,00h,00h
db 059h,00h,00h,00h
dd str_FreeAgents2
menu_r1_freeagents:
dd ShowFreeAgents
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
db 066h,00h,00h,00h,06Ch,00h,00h,00h
dd str_FindPlayer
dd FindPlayer
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_D01F9:
db 00h,00h,00h,00h,00h,00h,00h,00h,066h,00h,00h,00h,011h,00h,00h,00h
dd unk_D010E
db 00h,00h,00h,00h
roster2divmenus:
dd unk_CFBE8
db 06h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,066h,00h,00h,00h
db 023h,00h,00h,00h
dd unk_D0118
db 00h,00h,00h,00h
dd unk_CFCF2
db 06h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h,066h,00h,00h,00h
db 035h,00h,00h,00h
dd unk_D0122
db 00h,00h,00h,00h
dd unk_CFE08
db 07h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,066h,00h,00h,00h
db 047h,00h,00h,00h
dd unk_D012E
db 00h,00h,00h,00h
dd unk_CFF51
db 07h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,066h,00h,00h,00h
db 059h,00h,00h,00h
dd str_FreeAgents2
menu_r2_freeagents:
dd ShowFreeAgents
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
db 066h,00h,00h,00h,06Ch,00h,00h,00h
dd str_FindPlayer
dd FindPlayer
db 00h,00h,00h,00h,00h,00h,00h,00h
str_MoveToFreeAgent:
db 04Dh,06Fh,076h,065h,020h,074h,06Fh,020h,046h,072h,065h,065h,020h,041h,067h,065h
db 06Eh,074h,020h,04Ch,069h,073h,074h,00h
str_MoveToRoster2:
db 04Dh,06Fh,076h,065h,020h,074h,06Fh,020h,052h,06Fh,073h,074h,065h,072h,020h,032h
db 00h
str_MoveToRoster1:
db 04Dh,06Fh,076h,065h,020h,074h,06Fh,020h,052h,06Fh,073h,074h,065h,072h,020h,031h
db 00h
str_CreateFreeAgent:
db 043h,072h,065h,061h,074h,065h,020h,046h,072h,065h,065h,020h,041h,067h,065h,06Eh
db 074h,020h,02Eh,02Eh,02Eh,00h
str_EditTeamLines:
db 045h,064h,069h,074h,020h,054h,065h,061h,06Dh,020h,04Ch,069h,06Eh,065h,073h,020h
db 02Eh,02Eh,02Eh,00h
unk_D031D:
db 00h,00h,00h,00h,00h,00h,00h,00h,0A9h,00h,00h,00h,011h,00h,00h,00h
dd str_MoveToFreeAgent
menu_r1_tofa:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 012h,00h,00h,00h,0A9h,00h,00h,00h,023h,00h,00h,00h
dd str_MoveToRoster2
menu_r1_toroster2:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 024h,00h,00h,00h,0A9h,00h,00h,00h,035h,00h,00h,00h
dd str_CreateFreeAgent
dd CreateFreeAgent
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
db 0A9h,00h,00h,00h,048h,00h,00h,00h
dd str_EditTeamLines
menu_r1_editlines:
dd EditTeamLines
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_D039D:
db 00h,00h,00h,00h,00h,00h,00h,00h,0A9h,00h,00h,00h,011h,00h,00h,00h
dd str_MoveToFreeAgent
menu_r2_tofa:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 012h,00h,00h,00h,0A9h,00h,00h,00h,023h,00h,00h,00h
dd str_MoveToRoster1
menu_r2_toroster1:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 024h,00h,00h,00h,0A9h,00h,00h,00h,035h,00h,00h,00h
dd str_CreateFreeAgent
dd CreateFreeAgent
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
db 0A9h,00h,00h,00h,048h,00h,00h,00h
dd str_EditTeamLines
menu_r2_editlines:
dd EditTeamLines
db 00h,00h,00h,00h,00h,00h,00h,00h
str_File3:
db 046h,069h,06Ch,065h,00h
str_Roster12:
db 052h,06Fh,073h,074h,065h,072h,020h,031h,00h
str_Roster22:
db 052h,06Fh,073h,074h,065h,072h,020h,032h,00h
str_EditRoster1:
db 045h,064h,069h,074h,020h,052h,06Fh,073h,074h,065h,072h,020h,031h,00h
str_EditRoster2:
db 045h,064h,069h,074h,020h,052h,06Fh,073h,074h,065h,072h,020h,032h,00h
unk_D0450:
db 00h,00h,00h,00h,00h,00h,00h,00h,020h,00h,00h,00h,012h,00h,00h,00h
dd str_File3
db 00h,00h,00h,00h
dd unk_D006E
db 04h,00h,00h,00h,021h,00h,00h,00h,00h,00h,00h,00h,05Ch,00h,00h,00h
db 012h,00h,00h,00h
dd str_Roster12
db 00h,00h,00h,00h
dd unk_D0139
db 06h,00h,00h,00h,05Dh,00h,00h,00h,00h,00h,00h,00h,09Ah,00h,00h,00h
db 012h,00h,00h,00h
dd str_Roster22
db 00h,00h,00h,00h
dd unk_D01F9
db 06h,00h,00h,00h,09Bh,00h,00h,00h,00h,00h,00h,00h,0F4h,00h,00h,00h
db 012h,00h,00h,00h
dd str_EditRoster1
db 00h,00h,00h,00h
dd unk_D031D
db 04h,00h,00h,00h,0F5h,00h,00h,00h,00h,00h,00h,00h,050h,01h,00h,00h
db 012h,00h,00h,00h
dd str_EditRoster2
db 00h,00h,00h,00h
dd unk_D039D
db 04h,00h,00h,00h
str_Done5:
db 044h,06Fh,06Eh,065h,00h
str_Cancel8:
db 043h,061h,06Eh,063h,065h,06Ch,00h
unk_D04FC:
db 00h,00h,00h,00h,00h,00h,00h,00h,034h,00h,00h,00h,011h,00h,00h,00h
dd str_Done5
dd LineEdDone
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
db 034h,00h,00h,00h,024h,00h,00h,00h
dd str_Cancel8
dd MenuLineEdCancel
db 00h,00h,00h,00h,00h,00h,00h,00h
str_DressPlayer2:
db 044h,072h,065h,073h,073h,020h,050h,06Ch,061h,079h,065h,072h,00h
str_ScratchPlayer2:
db 053h,063h,072h,061h,074h,063h,068h,020h,050h,06Ch,061h,079h,065h,072h,00h
unk_D0558:
db 00h,00h,00h,00h,00h,00h,00h,00h,068h,00h,00h,00h,011h,00h,00h,00h
dd str_DressPlayer2
