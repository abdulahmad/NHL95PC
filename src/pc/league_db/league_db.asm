; The league databases. The Central Registry menu, the free agent and roster lists, loading, saving and
; freeing the databases in memory, and the record pointers.
bits 32
%include "hockey.inc"
section s_6BE95 progbits alloc exec nowrite align=1
extern __CHK, _dos_getdiskfree_, addtimer, attdb, attdb_size, boxfillcolor, boxlitecolor, boxshadecolor
extern btn_LeagueExists, byte_D416A, byte_D42C3, careerdb, careerdb_size, carteamsdb, carteamsdb_size, CheckDatabases
extern ctlavailmask, curdbname, dbdirty, dbexistsmsg, DeleteDir, dlgtextbg, dlgtextfg, DrawButtons
extern DrawEditRosters, DrawScrollBar, dword_C4CFC, dword_C71E0, dword_CCC94, dword_CDA24, dword_CDA38, dword_D0B12
extern dword_D0BFC, dword_D0C04, dword_D0C10, dword_D0C18, dword_D0C20, dword_EA2B0, dword_EBCA4, editptrspr
extern EditRosters, editrosters_exit, enterheld, facount, FadePalStep, falist, falistsel, FatalError
extern FitPlayerName, fputchar, FreeMemBlock, fullscrbmp, InitSpeechSlots, inputev, inputinstalled, inputpolldiv
extern inputqcount, inputqhead, inputqtail, inputqueue, inputrepeat, joybtnheld, joycalactive, joycalposthook
extern joycalprehook, joycalx, joycaly, joyenablemask, keydb, keydb_size, lastinputdir, lastmousebtns
extern lastmousex, lastmousey, leaguedbnames, mainfont, MakePath, memcpy_, memset_, MessageBox
extern mkdir_, mousebtns, mousepollfn, MouseSetPos, mousex, mousey, msglines, musichandle
extern musicon, musicslot, nodiskspacemsg, pointerspr, PollKey, PrintCenteredText, PrintShadowText, ptrstep
extern ptrupdatefn, RemoveTimerCallback, RestoreDialogBg, rmdir_, rosterisfa, rosterjersey, rosterlist, rostersel
extern rosterteamptr, RunEditRosters, savedbbtns, scrpitch, seasondb, seasondb_size, SetTextColors, songdata
extern speechbank, sprintf_, str_3dKbytesOfFree2, str_C4, str_Current2, str_Current3, str_DATABASE, str_DBX
extern str_dot, str_EnterANewDatabase, str_ErrorGettingDiskSpace, str_extDB, str_fmt2d, str_FreeAgents, str_Joycal, str_Left
extern str_LEFTJOYSTICK, str_Pal24, str_Pointer11, str_Puck, str_PuckBack, str_RIGHTJOYSTICK, str_Rite, str_S5
extern str_SaveAsGameDatabases, str_SavingDatabases, str_Scrn3, str_space, str_Temp7, str_XXXKbytesOfFree2, strcat_, strcpy_
extern strlen_, strupr_, sub_8CCA8, sub_8D2F0, sub_8E83C, sub_8E8A0, sub_8E9C0, sub_8E9E8
extern sub_8EA00, sub_8EA18, sub_8FC8A, sub_8FCDF, sub_8FFB0, sub_90D20, sub_90F38, sub_910E0
extern sub_9121C, sub_91370, sub_913B4, sub_91400, sub_91964, sub_92CD0, sub_92DE0, sub_932D0
extern sub_B29F0, sub_B2CBE, sub_B2F22, sub_B30B4, sub_B30F4, sub_B340B, sub_B3464, sub_B384E
extern sub_B387E, sub_B392C, sub_B39D0, sub_B4B88, sub_B4BA8, sub_B4C61, sub_B4F8C, sub_B4FAC
extern teamsdb, teamsdb_size, TextInputDialog, unk_C27F5, unk_D0450, unk_D0BB8, unk_D0BF0, unk_D45D8
extern unknown_libname_1
global MenuCentralRegistry, unk13_6BF3D, BuildFreeAgentList, BuildFreeAgentList_ret, BuildTeamRosterList, LoadLeagueDbsMem, MenuSaveDbs, MenuSaveDbsAs
global SaveDbsToDir, WriteLeagueDbsMem, FreeLeagueDbsMem, CarTeamRecPtr, TeamRecPtr, KeyDbPtr, SeasonDbPtr, SeasonDbPtr_common
global SeasonDbPtr2, CareerDbPtr, CareerDbPtr_common, CareerDbPtr2, AttDbPtr
; C: src/pc/league_db/MenuCentralRegistry.c
%ifdef CBUILD
%include "c/pc/league_db/MenuCentralRegistry.inc"
%else
MenuCentralRegistry:
push dword 1Ch	; 6BE95
call __CHK	; 6BE9A
push ebx	; 6BE9F
push ecx	; 6BEA0
push edx	; 6BEA1
push esi	; 6BEA2
push ebp	; 6BEA3
cmp byte [musicon], 0	; 6BEA4
je short .1	; 6BEAB
mov eax, dword [speechbank]	; 6BEAD
mov edx, dword [dword eax+03B60h]	; 6BEB2
push edx	; 6BEB8
call sub_8D2F0	; 6BEB9
add esp, byte 4	; 6BEBE
.1:
mov dword [scrpitch], 0A0h	; 6BEC1
xor ecx, ecx	; 6BECB
mov dword [dword_C71E0], ecx	; 6BECD
call RunEditRosters	; 6BED3
mov esi, dword [falistsel]	; 6BED8
test esi, esi	; 6BEDE
je short .2	; 6BEE0
push esi	; 6BEE2
call FreeMemBlock	; 6BEE3
add esp, byte 4	; 6BEE8
xor ebp, ebp	; 6BEEB
mov dword [falistsel], ebp	; 6BEED
.2:
mov eax, dword [falist]	; 6BEF3
test eax, eax	; 6BEF8
je short .3	; 6BEFA
push eax	; 6BEFC
call FreeMemBlock	; 6BEFD
add esp, byte 4	; 6BF02
xor ebx, ebx	; 6BF05
mov dword [falist], ebx	; 6BF07
.3:
cmp byte [musicon], 0	; 6BF0D
je short .4	; 6BF14
mov dword [dword_CCC94], 20h	; 6BF16
mov eax, dword [dword_C4CFC]	; 6BF20
call InitSpeechSlots	; 6BF25
xor esi, esi	; 6BF2A
mov dword [dword_CCC94], esi	; 6BF2C
.4:
mov eax, 2	; 6BF32
pop ebp	; 6BF37
pop esi	; 6BF38
pop edx	; 6BF39
pop ecx	; 6BF3A
pop ebx	; 6BF3B
ret	; 6BF3C
%endif ; C
unk13_6BF3D:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
; C: src/pc/league_db/BuildFreeAgentList.c
%ifdef CBUILD
%include "c/pc/league_db/BuildFreeAgentList.inc"
%else
BuildFreeAgentList:
push dword 20h	; 6BF4A
call __CHK	; 6BF4F
push ebx	; 6BF54
push ecx	; 6BF55
push edx	; 6BF56
push esi	; 6BF57
push edi	; 6BF58
push ebp	; 6BF59
sub esp, byte 4	; 6BF5A
mov ebx, 34h	; 6BF5D
xor edx, edx	; 6BF62
mov eax, dword [keydb_size]	; 6BF64
div ebx	; 6BF69
mov dword [esp], eax	; 6BF6B
xor ebx, ebx	; 6BF6E
xor esi, esi	; 6BF70
jmp near .3	; 6BF72
.1:
mov edi, esi	; 6BF77
shl edi, 2	; 6BF79
sub edi, esi	; 6BF7C
shl edi, 2	; 6BF7E
add edi, esi	; 6BF81
shl edi, 2	; 6BF83
mov edx, dword [keydb]	; 6BF86
add edx, edi	; 6BF8C
cmp byte [edx], 0FFh	; 6BF8E
jne near .2	; 6BF91
mov eax, ebx	; 6BF97
shl eax, 3	; 6BF99
sub eax, ebx	; 6BF9C
shl eax, 2	; 6BF9E
sub eax, ebx	; 6BFA1
mov ecx, dword [falist]	; 6BFA3
mov byte [byte ecx+eax+02h], bl	; 6BFA9
mov ebp, dword [falist]	; 6BFAD
mov cl, byte [byte edx+02h]	; 6BFB3
mov byte [eax+ebp], cl	; 6BFB6
mov ebp, dword [falist]	; 6BFB9
mov cl, byte [byte edx+01h]	; 6BFBF
mov byte [byte eax+ebp+01h], cl	; 6BFC2
mov ecx, dword [falist]	; 6BFC6
mov byte [byte ecx+eax+03h], 3	; 6BFCC
mov ecx, dword [falist]	; 6BFD1
mov dword [byte ecx+eax+04h], edi	; 6BFD7
mov edi, dword [falist]	; 6BFDB
mov cl, byte [byte edx+03h]	; 6BFE1
mov byte [byte edi+eax+08h], cl	; 6BFE4
mov edi, dword [falist]	; 6BFE8
mov cl, byte [str_dot]	; 6BFEE
mov byte [byte edi+eax+09h], cl	; 6BFF4
mov edi, dword [falist]	; 6BFF8
mov cl, byte [str_space]	; 6BFFE
mov byte [byte edi+eax+0Ah], cl	; 6C004
mov ecx, dword [falist]	; 6C008
mov byte [byte ecx+eax+0Bh], 0	; 6C00E
add edx, byte 13h	; 6C013
mov ecx, dword [falist]	; 6C016
add eax, ecx	; 6C01C
add eax, byte 8	; 6C01E
call strcat_	; 6C021
inc ebx	; 6C026
.2:
inc esi	; 6C027
.3:
cmp esi, dword [esp]	; 6C028
jge short .4	; 6C02B
cmp ebx, dword [facount]	; 6C02D
jl near BuildFreeAgentList.1	; 6C033
.4:
add esp, byte 4	; 6C039
BuildFreeAgentList_ret:
pop ebp	; 6C03C
pop edi	; 6C03D
pop esi	; 6C03E
pop edx	; 6C03F
pop ecx	; 6C040
pop ebx	; 6C041
ret	; 6C042
%endif ; C
; C: src/pc/league_db/BuildTeamRosterList.c
%ifdef CBUILD
%include "c/pc/league_db/BuildTeamRosterList.inc"
%else
BuildTeamRosterList:
push dword 14h	; 6C043
call __CHK	; 6C048
push ecx	; 6C04D
push esi	; 6C04E
push edi	; 6C04F
push ebp	; 6C050
mov esi, eax	; 6C051
mov ebp, edx	; 6C053
mov edi, ebx	; 6C055
xor ebx, ebx	; 6C057
.1:
mov edx, ebx	; 6C059
shl edx, 3	; 6C05B
sub edx, ebx	; 6C05E
shl edx, 2	; 6C060
sub edx, ebx	; 6C063
mov byte [byte edx+ebp+02h], bl	; 6C065
inc ebx	; 6C069
cmp ebx, byte 1Ch	; 6C06A
jl short BuildTeamRosterList.1	; 6C06D
mov eax, esi	; 6C06F
call TeamRecPtr	; 6C071
mov dword [edi], eax	; 6C076
xor ebx, ebx	; 6C078
.2:
mov eax, dword [edi]	; 6C07A
mov ecx, ebx	; 6C07C
mov ecx, dword [byte eax+ecx*4+04Ch]	; 6C07E
mov edx, ebx	; 6C082
shl edx, 3	; 6C084
sub edx, ebx	; 6C087
shl edx, 2	; 6C089
sub edx, ebx	; 6C08C
add edx, ebp	; 6C08E
cmp ecx, byte 0FFFFFFFFh	; 6C090
jne short .3	; 6C093
mov byte [edx], 0	; 6C095
mov byte [byte edx+01h], 64h	; 6C098
mov byte [byte edx+02h], 0	; 6C09C
mov byte [byte edx+03h], 0	; 6C0A0
jmp short .4	; 6C0A4
.3:
mov eax, ecx	; 6C0A6
call KeyDbPtr	; 6C0A8
mov esi, eax	; 6C0AD
mov al, byte [byte eax+02h]	; 6C0AF
mov byte [edx], al	; 6C0B2
mov al, byte [byte esi+01h]	; 6C0B4
mov byte [byte edx+01h], al	; 6C0B7
mov byte [byte edx+03h], 3	; 6C0BA
mov dword [byte edx+04h], ecx	; 6C0BE
mov al, byte [byte esi+03h]	; 6C0C1
mov byte [byte edx+08h], al	; 6C0C4
mov al, byte [str_dot]	; 6C0C7
mov byte [byte edx+09h], al	; 6C0CC
mov al, byte [str_space]	; 6C0CF
mov byte [byte edx+0Ah], al	; 6C0D4
mov byte [byte edx+0Bh], 0	; 6C0D7
add esi, byte 13h	; 6C0DB
lea eax, [byte edx+08h]	; 6C0DE
mov edx, esi	; 6C0E1
call strcat_	; 6C0E3
.4:
inc ebx	; 6C0E8
cmp ebx, byte 19h	; 6C0E9
jl short BuildTeamRosterList.2	; 6C0EC
xor ebx, ebx	; 6C0EE
.5:
mov ecx, dword [edi]	; 6C0F0
mov eax, ebx	; 6C0F2
mov ecx, dword [dword ecx+eax*4+0B0h]	; 6C0F4
lea esi, [byte ebx+019h]	; 6C0FB
mov edx, esi	; 6C0FE
shl edx, 3	; 6C100
sub edx, esi	; 6C103
shl edx, 2	; 6C105
sub edx, esi	; 6C108
add edx, ebp	; 6C10A
cmp ecx, byte 0FFFFFFFFh	; 6C10C
jne short .6	; 6C10F
mov byte [edx], 0	; 6C111
mov byte [byte edx+01h], 64h	; 6C114
mov byte [byte edx+02h], 0	; 6C118
mov byte [byte edx+03h], 0	; 6C11C
jmp short .7	; 6C120
.6:
mov eax, ecx	; 6C122
call KeyDbPtr	; 6C124
mov esi, eax	; 6C129
mov al, byte [byte eax+02h]	; 6C12B
mov byte [edx], al	; 6C12E
mov al, byte [byte esi+01h]	; 6C130
mov byte [byte edx+01h], al	; 6C133
mov byte [byte edx+03h], 3	; 6C136
mov dword [byte edx+04h], ecx	; 6C13A
mov al, byte [byte esi+03h]	; 6C13D
mov byte [byte edx+08h], al	; 6C140
mov al, byte [str_dot]	; 6C143
mov byte [byte edx+09h], al	; 6C148
mov al, byte [str_space]	; 6C14B
mov byte [byte edx+0Ah], al	; 6C150
mov byte [byte edx+0Bh], 0	; 6C153
add esi, byte 13h	; 6C157
lea eax, [byte edx+08h]	; 6C15A
mov edx, esi	; 6C15D
call strcat_	; 6C15F
.7:
inc ebx	; 6C164
cmp ebx, byte 3	; 6C165
jl short BuildTeamRosterList.5	; 6C168
xor ebx, ebx	; 6C16A
.8:
mov edx, dword [edi]	; 6C16C
add edx, ebx	; 6C16E
mov ah, byte [dword edx+0E4h]	; 6C170
cmp ah, 64h	; 6C176
je short .9	; 6C179
xor ecx, ecx	; 6C17B
mov cl, ah	; 6C17D
mov edx, ecx	; 6C17F
shl edx, 3	; 6C181
sub edx, ecx	; 6C184
shl edx, 2	; 6C186
sub edx, ecx	; 6C189
mov byte [byte edx+ebp+03h], 2	; 6C18B
.9:
inc ebx	; 6C190
cmp ebx, byte 8	; 6C191
jl short BuildTeamRosterList.8	; 6C194
pop ebp	; 6C196
pop edi	; 6C197
pop esi	; 6C198
pop ecx	; 6C199
ret	; 6C19A
%endif ; C
; C: src/pc/league_db/LoadLeagueDbsMem.c
%ifdef CBUILD
%include "c/pc/league_db/LoadLeagueDbsMem.inc"
%else
LoadLeagueDbsMem:
push dword 3Ch	; 6C19B
call __CHK	; 6C1A0
push ebx	; 6C1A5
push ecx	; 6C1A6
push edx	; 6C1A7
push esi	; 6C1A8
sub esp, byte 20h	; 6C1A9
mov esi, eax	; 6C1AC
call FreeLeagueDbsMem	; 6C1AE
mov ebx, dword [leaguedbnames+14h]	; 6C1B3
mov ecx, esi	; 6C1B9
xor edx, edx	; 6C1BB
mov eax, esp	; 6C1BD
call MakePath	; 6C1BF
push byte 20h	; 6C1C4
lea eax, [byte esp+04h]	; 6C1C6
push eax	; 6C1CA
call sub_8E8A0	; 6C1CB
add esp, byte 8	; 6C1D0
mov dword [seasondb], eax	; 6C1D3
mov eax, esp	; 6C1D8
push eax	; 6C1DA
call sub_92DE0	; 6C1DB
add esp, byte 4	; 6C1E0
mov dword [seasondb_size], eax	; 6C1E3
mov ebx, dword [leaguedbnames+4]	; 6C1E8
mov ecx, esi	; 6C1EE
xor edx, edx	; 6C1F0
mov eax, esp	; 6C1F2
call MakePath	; 6C1F4
push byte 20h	; 6C1F9
lea eax, [byte esp+04h]	; 6C1FB
push eax	; 6C1FF
call sub_8E8A0	; 6C200
add esp, byte 8	; 6C205
mov dword [careerdb], eax	; 6C208
mov eax, esp	; 6C20D
push eax	; 6C20F
call sub_92DE0	; 6C210
add esp, byte 4	; 6C215
mov dword [careerdb_size], eax	; 6C218
mov ebx, dword [leaguedbnames+0Ch]	; 6C21D
mov ecx, esi	; 6C223
xor edx, edx	; 6C225
mov eax, esp	; 6C227
call MakePath	; 6C229
push byte 20h	; 6C22E
lea eax, [byte esp+04h]	; 6C230
push eax	; 6C234
call sub_8E8A0	; 6C235
add esp, byte 8	; 6C23A
mov dword [carteamsdb], eax	; 6C23D
mov eax, esp	; 6C242
push eax	; 6C244
call sub_92DE0	; 6C245
add esp, byte 4	; 6C24A
mov dword [carteamsdb_size], eax	; 6C24D
mov ebx, dword [leaguedbnames]	; 6C252
mov ecx, esi	; 6C258
xor edx, edx	; 6C25A
mov eax, esp	; 6C25C
call MakePath	; 6C25E
push byte 20h	; 6C263
lea eax, [byte esp+04h]	; 6C265
push eax	; 6C269
call sub_8E8A0	; 6C26A
add esp, byte 8	; 6C26F
mov dword [keydb], eax	; 6C272
mov eax, esp	; 6C277
push eax	; 6C279
call sub_92DE0	; 6C27A
add esp, byte 4	; 6C27F
mov dword [keydb_size], eax	; 6C282
mov ebx, dword [leaguedbnames+10h]	; 6C287
mov ecx, esi	; 6C28D
xor edx, edx	; 6C28F
mov eax, esp	; 6C291
call MakePath	; 6C293
push byte 20h	; 6C298
lea eax, [byte esp+04h]	; 6C29A
push eax	; 6C29E
call sub_8E8A0	; 6C29F
add esp, byte 8	; 6C2A4
mov dword [teamsdb], eax	; 6C2A7
mov eax, esp	; 6C2AC
push eax	; 6C2AE
call sub_92DE0	; 6C2AF
add esp, byte 4	; 6C2B4
mov dword [teamsdb_size], eax	; 6C2B7
mov ebx, dword [leaguedbnames+8]	; 6C2BC
mov ecx, esi	; 6C2C2
xor edx, edx	; 6C2C4
mov eax, esp	; 6C2C6
call MakePath	; 6C2C8
push byte 20h	; 6C2CD
lea eax, [byte esp+04h]	; 6C2CF
push eax	; 6C2D3
call sub_8E8A0	; 6C2D4
add esp, byte 8	; 6C2D9
mov dword [attdb], eax	; 6C2DC
mov eax, esp	; 6C2E1
push eax	; 6C2E3
call sub_92DE0	; 6C2E4
add esp, byte 4	; 6C2E9
mov dword [attdb_size], eax	; 6C2EC
add esp, byte 20h	; 6C2F1
pop esi	; 6C2F4
pop edx	; 6C2F5
pop ecx	; 6C2F6
pop ebx	; 6C2F7
ret	; 6C2F8
%endif ; C
; C: src/pc/league_db/MenuSaveDbs.c
%ifdef CBUILD
%include "c/pc/league_db/MenuSaveDbs.inc"
%else
MenuSaveDbs:
push dword 3Ch	; 6C2F9
call __CHK	; 6C2FE
push ecx	; 6C303
push esi	; 6C304
push edi	; 6C305
push ebp	; 6C306
sub esp, byte 10h	; 6C307
push edx	; 6C30A
mov ebp, ebx	; 6C30B
lea edi, [byte esp+04h]	; 6C30D
mov esi, unk13_6BF3D	; 6C311
movsd	; 6C316
movsd	; 6C317
movsd	; 6C318
movsb	; 6C319
mov dword [msglines], str_SaveAsGameDatabases	; 6C31A
push byte 0FFFFFFFFh	; 6C324
push ebx	; 6C326
mov ebx, dword [byte esp+08h]	; 6C327
push ebx	; 6C32B
push byte 2	; 6C32C
push savedbbtns	; 6C32E
mov ecx, 1	; 6C333
mov ebx, msglines	; 6C338
mov edx, 0FFFFFFFFh	; 6C33D
mov eax, edx	; 6C342
call MessageBox	; 6C344
cmp eax, byte 1	; 6C349
jne short .x	; 6C34C
mov edx, ebp	; 6C34E
mov eax, dword [esp]	; 6C350
call CheckDatabases	; 6C353
mov edx, eax	; 6C358
call DrawEditRosters	; 6C35A
test edx, edx	; 6C35F
je short .x	; 6C361
mov edi, curdbname	; 6C363
mov esi, str_Current2	; 6C368
movsd	; 6C36D
movsd	; 6C36E
mov dword [msglines], str_SavingDatabases	; 6C36F
push byte 0	; 6C379
push ebp	; 6C37B
mov esi, dword [byte esp+08h]	; 6C37C
push esi	; 6C380
push byte 0	; 6C381
push byte 0	; 6C383
mov ecx, 1	; 6C385
mov ebx, msglines	; 6C38A
mov edx, 0FFFFFFFFh	; 6C38F
mov eax, edx	; 6C394
call MessageBox	; 6C396
mov edx, str_extDB	; 6C39B
lea eax, [byte esp+04h]	; 6C3A0
call SaveDbsToDir	; 6C3A4
call RestoreDialogBg	; 6C3A9
call DrawEditRosters	; 6C3AE
.x:
add esp, byte 14h	; 6C3B3
pop ebp	; 6C3B6
pop edi	; 6C3B7
pop esi	; 6C3B8
pop ecx	; 6C3B9
ret	; 6C3BA
%endif ; C
; C: src/pc/league_db/MenuSaveDbsAs.c
%ifdef CBUILD
%include "c/pc/league_db/MenuSaveDbsAs.inc"
%else
MenuSaveDbsAs:
push dword 78h	; 6C3BB
call __CHK	; 6C3C0
push ecx	; 6C3C5
push esi	; 6C3C6
push edi	; 6C3C7
push ebp	; 6C3C8
sub esp, byte 50h	; 6C3C9
mov edi, edx	; 6C3CC
mov ebp, ebx	; 6C3CE
xor esi, esi	; 6C3D0
mov dword [byte esp+04Ch], esi	; 6C3D2
push byte 5	; 6C3D6
push esi	; 6C3D8
push esi	; 6C3D9
push esi	; 6C3DA
push esi	; 6C3DB
mov ecx, 30h	; 6C3DC
mov ebx, 8	; 6C3E1
lea edx, [byte esp+050h]	; 6C3E6
mov eax, str_EnterANewDatabase	; 6C3EA
call TextInputDialog	; 6C3EF
cmp byte [byte esp+03Ch], 0	; 6C3F4
je near .x	; 6C3F9
cmp eax, byte 1Bh	; 6C3FF
je near .x	; 6C402
lea edx, [byte esp+03Ch]	; 6C408
lea eax, [byte esp+02Ch]	; 6C40C
call strcpy_	; 6C410
mov edx, str_DBX	; 6C415
lea eax, [byte esp+03Ch]	; 6C41A
call strcat_	; 6C41E
mov ebx, esp	; 6C423
mov edx, 10h	; 6C425
lea eax, [byte esp+03Ch]	; 6C42A
call unknown_libname_1	; 6C42E
test eax, eax	; 6C433
sete al	; 6C435
and eax, 0FFh	; 6C438
je short .2	; 6C43D
push byte 0FFFFFFFFh	; 6C43F
push ebp	; 6C441
push edi	; 6C442
push byte 2	; 6C443
push btn_LeagueExists	; 6C445
mov ecx, 2	; 6C44A
mov ebx, dbexistsmsg	; 6C44F
mov edx, 0FFFFFFFFh	; 6C454
mov eax, edx	; 6C459
call MessageBox	; 6C45B
cmp eax, byte 1	; 6C460
jne short .1	; 6C463
lea eax, [byte esp+03Ch]	; 6C465
call DeleteDir	; 6C469
jmp short .2	; 6C46E
.1:
mov esi, 1	; 6C470
.2:
test esi, esi	; 6C475
jne short .3	; 6C477
lea eax, [byte esp+03Ch]	; 6C479
call mkdir_	; 6C47D
mov dword [byte esp+04Ch], eax	; 6C482
.3:
test esi, esi	; 6C486
jne short .x	; 6C488
cmp dword [byte esp+04Ch], byte 0	; 6C48A
jne short .x	; 6C48F
lea edx, [byte esp+02Ch]	; 6C491
mov eax, curdbname	; 6C495
call strcpy_	; 6C49A
mov edx, str_extDB	; 6C49F
lea eax, [byte esp+03Ch]	; 6C4A4
call SaveDbsToDir	; 6C4A8
call DrawEditRosters	; 6C4AD
.x:
add esp, byte 50h	; 6C4B2
pop ebp	; 6C4B5
pop edi	; 6C4B6
pop esi	; 6C4B7
pop ecx	; 6C4B8
ret	; 6C4B9
%endif ; C
; C: src/pc/league_db/SaveDbsToDir.c
%ifdef CBUILD
%include "c/pc/league_db/SaveDbsToDir.inc"
%else
SaveDbsToDir:
push dword 0CCh	; 6C4BA
call __CHK	; 6C4BF
push ebx	; 6C4C4
push ecx	; 6C4C5
push esi	; 6C4C6
push edi	; 6C4C7
push ebp	; 6C4C8
sub esp, 0A0h	; 6C4C9
mov ebp, eax	; 6C4CF
mov dword [dword esp+09Ch], edx	; 6C4D1
lea edx, [dword esp+08Ch]	; 6C4D8
xor eax, eax	; 6C4DF
call _dos_getdiskfree_	; 6C4E1
test eax, eax	; 6C4E6
je short .1	; 6C4E8
push str_ErrorGettingDiskSpace	; 6C4EA
call FatalError	; 6C4EF
add esp, byte 4	; 6C4F4
.1:
xor esi, esi	; 6C4F7
mov si, word [dword esp+090h]	; 6C4F9
xor eax, eax	; 6C501
mov ax, word [dword esp+092h]	; 6C503
imul esi, eax	; 6C50B
mov ebx, dword [leaguedbnames+14h]	; 6C50E
mov ecx, dword [dword esp+09Ch]	; 6C514
mov edx, ebp	; 6C51B
lea eax, [byte esp+02Ch]	; 6C51D
call MakePath	; 6C521
mov ebx, esp	; 6C526
xor edx, edx	; 6C528
lea eax, [byte esp+02Ch]	; 6C52A
call unknown_libname_1	; 6C52E
test eax, eax	; 6C533
je short .2	; 6C535
xor edx, edx	; 6C537
mov dword [byte esp+04Ch], edx	; 6C539
jmp short .3	; 6C53D
.2:
mov eax, dword [byte esp+01Ah]	; 6C53F
add eax, 3FFh	; 6C543
shr eax, 0Ah	; 6C548
mov dword [byte esp+04Ch], eax	; 6C54B
.3:
mov ebx, dword [leaguedbnames+4]	; 6C54F
mov ecx, dword [dword esp+09Ch]	; 6C555
mov edx, ebp	; 6C55C
lea eax, [byte esp+02Ch]	; 6C55E
call MakePath	; 6C562
mov ebx, esp	; 6C567
xor edx, edx	; 6C569
lea eax, [byte esp+02Ch]	; 6C56B
call unknown_libname_1	; 6C56F
test eax, eax	; 6C574
je short .4	; 6C576
xor ebx, ebx	; 6C578
mov dword [byte esp+050h], ebx	; 6C57A
jmp short .5	; 6C57E
.4:
mov eax, dword [byte esp+01Ah]	; 6C580
add eax, 3FFh	; 6C584
shr eax, 0Ah	; 6C589
mov dword [byte esp+050h], eax	; 6C58C
.5:
mov ebx, dword [leaguedbnames+0Ch]	; 6C590
mov ecx, dword [dword esp+09Ch]	; 6C596
mov edx, ebp	; 6C59D
lea eax, [byte esp+02Ch]	; 6C59F
call MakePath	; 6C5A3
mov ebx, esp	; 6C5A8
xor edx, edx	; 6C5AA
lea eax, [byte esp+02Ch]	; 6C5AC
call unknown_libname_1	; 6C5B0
test eax, eax	; 6C5B5
je short .6	; 6C5B7
xor ecx, ecx	; 6C5B9
mov dword [byte esp+054h], ecx	; 6C5BB
jmp short .7	; 6C5BF
.6:
mov eax, dword [byte esp+01Ah]	; 6C5C1
add eax, 3FFh	; 6C5C5
shr eax, 0Ah	; 6C5CA
mov dword [byte esp+054h], eax	; 6C5CD
.7:
mov ebx, dword [leaguedbnames]	; 6C5D1
mov ecx, dword [dword esp+09Ch]	; 6C5D7
mov edx, ebp	; 6C5DE
lea eax, [byte esp+02Ch]	; 6C5E0
call MakePath	; 6C5E4
mov ebx, esp	; 6C5E9
xor edx, edx	; 6C5EB
lea eax, [byte esp+02Ch]	; 6C5ED
call unknown_libname_1	; 6C5F1
test eax, eax	; 6C5F6
je short .8	; 6C5F8
xor edi, edi	; 6C5FA
mov dword [byte esp+058h], edi	; 6C5FC
jmp short .9	; 6C600
.8:
mov eax, dword [byte esp+01Ah]	; 6C602
add eax, 3FFh	; 6C606
shr eax, 0Ah	; 6C60B
mov dword [byte esp+058h], eax	; 6C60E
.9:
mov ebx, dword [leaguedbnames+10h]	; 6C612
mov ecx, dword [dword esp+09Ch]	; 6C618
mov edx, ebp	; 6C61F
lea eax, [byte esp+02Ch]	; 6C621
call MakePath	; 6C625
mov ebx, esp	; 6C62A
xor edx, edx	; 6C62C
lea eax, [byte esp+02Ch]	; 6C62E
call unknown_libname_1	; 6C632
test eax, eax	; 6C637
je short .10	; 6C639
xor eax, eax	; 6C63B
jmp short .11	; 6C63D
.10:
mov eax, dword [byte esp+01Ah]	; 6C63F
add eax, 3FFh	; 6C643
shr eax, 0Ah	; 6C648
.11:
mov dword [byte esp+05Ch], eax	; 6C64B
mov ebx, dword [leaguedbnames+8]	; 6C64F
mov ecx, dword [dword esp+09Ch]	; 6C655
mov edx, ebp	; 6C65C
lea eax, [byte esp+02Ch]	; 6C65E
call MakePath	; 6C662
mov ebx, esp	; 6C667
xor edx, edx	; 6C669
lea eax, [byte esp+02Ch]	; 6C66B
call unknown_libname_1	; 6C66F
test eax, eax	; 6C674
je short .12	; 6C676
xor edx, edx	; 6C678
mov dword [byte esp+060h], edx	; 6C67A
jmp short .13	; 6C67E
.12:
mov eax, dword [byte esp+01Ah]	; 6C680
add eax, 3FFh	; 6C684
shr eax, 0Ah	; 6C689
mov dword [byte esp+060h], eax	; 6C68C
.13:
mov edx, dword [seasondb_size]	; 6C690
add edx, 3FFh	; 6C696
mov eax, edx	; 6C69C
sar edx, 1Fh	; 6C69E
shl edx, 0Ah	; 6C6A1
LD sbb, eax, edx	; 6C6A4
sar eax, 0Ah	; 6C6A6
mov dword [byte esp+06Ch], eax	; 6C6A9
mov edx, dword [careerdb_size]	; 6C6AD
add edx, 3FFh	; 6C6B3
mov eax, edx	; 6C6B9
sar edx, 1Fh	; 6C6BB
shl edx, 0Ah	; 6C6BE
LD sbb, eax, edx	; 6C6C1
sar eax, 0Ah	; 6C6C3
mov dword [byte esp+070h], eax	; 6C6C6
mov edx, dword [carteamsdb_size]	; 6C6CA
add edx, 3FFh	; 6C6D0
mov eax, edx	; 6C6D6
sar edx, 1Fh	; 6C6D8
shl edx, 0Ah	; 6C6DB
LD sbb, eax, edx	; 6C6DE
sar eax, 0Ah	; 6C6E0
mov dword [byte esp+074h], eax	; 6C6E3
mov edx, dword [keydb_size]	; 6C6E7
add edx, 3FFh	; 6C6ED
mov eax, edx	; 6C6F3
sar edx, 1Fh	; 6C6F5
shl edx, 0Ah	; 6C6F8
LD sbb, eax, edx	; 6C6FB
sar eax, 0Ah	; 6C6FD
mov dword [byte esp+078h], eax	; 6C700
mov edx, dword [teamsdb_size]	; 6C704
add edx, 3FFh	; 6C70A
mov eax, edx	; 6C710
sar edx, 1Fh	; 6C712
shl edx, 0Ah	; 6C715
LD sbb, eax, edx	; 6C718
sar eax, 0Ah	; 6C71A
mov dword [byte esp+07Ch], eax	; 6C71D
mov edx, dword [attdb_size]	; 6C721
add edx, 3FFh	; 6C727
mov eax, edx	; 6C72D
sar edx, 1Fh	; 6C72F
shl edx, 0Ah	; 6C732
LD sbb, eax, edx	; 6C735
sar eax, 0Ah	; 6C737
mov dword [dword esp+080h], eax	; 6C73A
xor ebx, ebx	; 6C741
mov dword [dword esp+084h], ebx	; 6C743
xor edi, edi	; 6C74A
.14:
mov edx, dword [byte esp+ebx*4+06Ch]	; 6C74C
add edx, esi	; 6C750
dec edx	; 6C752
mov eax, edx	; 6C753
sar edx, 1Fh	; 6C755
idiv esi	; 6C758
add edi, eax	; 6C75A
mov edx, dword [byte esp+ebx*4+04Ch]	; 6C75C
add edx, esi	; 6C760
dec edx	; 6C762
mov eax, edx	; 6C763
sar edx, 1Fh	; 6C765
idiv esi	; 6C768
sub edi, eax	; 6C76A
inc ebx	; 6C76C
cmp ebx, byte 6	; 6C76D
jl short SaveDbsToDir.14	; 6C770
xor eax, eax	; 6C772
mov ax, word [dword esp+08Eh]	; 6C774
cmp edi, eax	; 6C77C
jle near .16	; 6C77E
mov eax, 140h	; 6C784
mov dword [dword esp+098h], eax	; 6C789
mov edx, 0F0h	; 6C790
mov dword [dword esp+094h], edx	; 6C795
push edx	; 6C79C
push eax	; 6C79D
call MouseSetPos	; 6C79E
add esp, byte 8	; 6C7A3
xor ebx, ebx	; 6C7A6
.15:
mov edx, dword [byte esp+ebx*4+06Ch]	; 6C7A8
add edx, esi	; 6C7AC
dec edx	; 6C7AE
mov eax, edx	; 6C7AF
sar edx, 1Fh	; 6C7B1
idiv esi	; 6C7B4
add edi, eax	; 6C7B6
inc ebx	; 6C7B8
cmp ebx, byte 6	; 6C7B9
jl short SaveDbsToDir.15	; 6C7BC
mov edx, edi	; 6C7BE
imul edx, esi	; 6C7C0
mov eax, edx	; 6C7C3
sar edx, 1Fh	; 6C7C5
shl edx, 0Ah	; 6C7C8
LD sbb, eax, edx	; 6C7CB
sar eax, 0Ah	; 6C7CD
push eax	; 6C7D0
push str_3dKbytesOfFree2	; 6C7D1
push str_XXXKbytesOfFree2	; 6C7D6
call sprintf_	; 6C7DB
add esp, byte 0Ch	; 6C7E0
push dword 320h	; 6C7E3
lea eax, [dword esp+098h]	; 6C7E8
push eax	; 6C7EF
lea eax, [dword esp+0A0h]	; 6C7F0
push eax	; 6C7F7
push byte 0	; 6C7F8
push byte 0	; 6C7FA
mov ecx, 3	; 6C7FC
mov ebx, nodiskspacemsg	; 6C801
mov edx, 0FFFFFFFFh	; 6C806
mov eax, edx	; 6C80B
call MessageBox	; 6C80D
cmp byte [byte ebp+00h], 0	; 6C812
je near .x	; 6C816
mov eax, ebp	; 6C81C
call rmdir_	; 6C81E
jmp near .x	; 6C823
.16:
mov ebx, dword [leaguedbnames+14h]	; 6C828
mov ecx, dword [dword esp+09Ch]	; 6C82E
mov edx, ebp	; 6C835
lea eax, [byte esp+02Ch]	; 6C837
call MakePath	; 6C83B
mov ecx, dword [seasondb_size]	; 6C840
push ecx	; 6C846
mov esi, dword [seasondb]	; 6C847
push esi	; 6C84D
lea eax, [byte esp+034h]	; 6C84E
push eax	; 6C852
call sub_932D0	; 6C853
add esp, byte 0Ch	; 6C858
mov ebx, dword [leaguedbnames+4]	; 6C85B
mov ecx, dword [dword esp+09Ch]	; 6C861
mov edx, ebp	; 6C868
lea eax, [byte esp+02Ch]	; 6C86A
call MakePath	; 6C86E
mov edi, dword [careerdb_size]	; 6C873
push edi	; 6C879
mov eax, dword [careerdb]	; 6C87A
push eax	; 6C87F
lea eax, [byte esp+034h]	; 6C880
push eax	; 6C884
call sub_932D0	; 6C885
add esp, byte 0Ch	; 6C88A
mov ebx, dword [leaguedbnames+0Ch]	; 6C88D
mov ecx, dword [dword esp+09Ch]	; 6C893
mov edx, ebp	; 6C89A
lea eax, [byte esp+02Ch]	; 6C89C
call MakePath	; 6C8A0
mov edx, dword [carteamsdb_size]	; 6C8A5
push edx	; 6C8AB
mov ebx, dword [carteamsdb]	; 6C8AC
push ebx	; 6C8B2
lea eax, [byte esp+034h]	; 6C8B3
push eax	; 6C8B7
call sub_932D0	; 6C8B8
add esp, byte 0Ch	; 6C8BD
mov ebx, dword [leaguedbnames]	; 6C8C0
mov ecx, dword [dword esp+09Ch]	; 6C8C6
mov edx, ebp	; 6C8CD
lea eax, [byte esp+02Ch]	; 6C8CF
call MakePath	; 6C8D3
mov ecx, dword [keydb_size]	; 6C8D8
push ecx	; 6C8DE
mov esi, dword [keydb]	; 6C8DF
push esi	; 6C8E5
lea eax, [byte esp+034h]	; 6C8E6
push eax	; 6C8EA
call sub_932D0	; 6C8EB
add esp, byte 0Ch	; 6C8F0
mov ebx, dword [leaguedbnames+10h]	; 6C8F3
mov ecx, dword [dword esp+09Ch]	; 6C8F9
mov edx, ebp	; 6C900
lea eax, [byte esp+02Ch]	; 6C902
call MakePath	; 6C906
mov edi, dword [teamsdb_size]	; 6C90B
push edi	; 6C911
mov eax, dword [teamsdb]	; 6C912
push eax	; 6C917
lea eax, [byte esp+034h]	; 6C918
push eax	; 6C91C
call sub_932D0	; 6C91D
add esp, byte 0Ch	; 6C922
mov ebx, dword [leaguedbnames+8]	; 6C925
mov ecx, dword [dword esp+09Ch]	; 6C92B
mov edx, ebp	; 6C932
lea eax, [byte esp+02Ch]	; 6C934
call MakePath	; 6C938
mov edx, dword [attdb_size]	; 6C93D
push edx	; 6C943
mov ebx, dword [attdb]	; 6C944
push ebx	; 6C94A
lea eax, [byte esp+034h]	; 6C94B
push eax	; 6C94F
call sub_932D0	; 6C950
add esp, byte 0Ch	; 6C955
xor ecx, ecx	; 6C958
mov dword [dbdirty], ecx	; 6C95A
.x:
add esp, 0A0h	; 6C960
pop ebp	; 6C966
pop edi	; 6C967
pop esi	; 6C968
pop ecx	; 6C969
pop ebx	; 6C96A
ret	; 6C96B
%endif ; C
; C: src/pc/league_db/BuildFreeAgentList.c (WriteLeagueDbsMem)
%ifdef CBUILD
%include "c/pc/league_db/BuildFreeAgentList.WriteLeagueDbsMem.inc"
%else
WriteLeagueDbsMem:
push dword 48h	; 6C96C
call __CHK	; 6C971
push ebx	; 6C976
push ecx	; 6C977
push edx	; 6C978
push esi	; 6C979
push edi	; 6C97A
push ebp	; 6C97B
sub esp, byte 20h	; 6C97C
mov esi, eax	; 6C97F
mov ebx, dword [leaguedbnames+14h]	; 6C981
mov ecx, eax	; 6C987
xor edx, edx	; 6C989
mov eax, esp	; 6C98B
call MakePath	; 6C98D
mov edx, dword [seasondb_size]	; 6C992
push edx	; 6C998
mov ebx, dword [seasondb]	; 6C999
push ebx	; 6C99F
lea eax, [byte esp+08h]	; 6C9A0
push eax	; 6C9A4
call sub_932D0	; 6C9A5
add esp, byte 0Ch	; 6C9AA
mov ebx, dword [leaguedbnames+4]	; 6C9AD
mov ecx, esi	; 6C9B3
xor edx, edx	; 6C9B5
mov eax, esp	; 6C9B7
call MakePath	; 6C9B9
mov ecx, dword [careerdb_size]	; 6C9BE
push ecx	; 6C9C4
mov edi, dword [careerdb]	; 6C9C5
push edi	; 6C9CB
lea eax, [byte esp+08h]	; 6C9CC
push eax	; 6C9D0
call sub_932D0	; 6C9D1
add esp, byte 0Ch	; 6C9D6
mov ebx, dword [leaguedbnames+0Ch]	; 6C9D9
mov ecx, esi	; 6C9DF
xor edx, edx	; 6C9E1
mov eax, esp	; 6C9E3
call MakePath	; 6C9E5
mov ebp, dword [carteamsdb_size]	; 6C9EA
push ebp	; 6C9F0
mov eax, dword [carteamsdb]	; 6C9F1
push eax	; 6C9F6
lea eax, [byte esp+08h]	; 6C9F7
push eax	; 6C9FB
call sub_932D0	; 6C9FC
add esp, byte 0Ch	; 6CA01
mov ebx, dword [leaguedbnames]	; 6CA04
mov ecx, esi	; 6CA0A
xor edx, edx	; 6CA0C
mov eax, esp	; 6CA0E
call MakePath	; 6CA10
mov edx, dword [keydb_size]	; 6CA15
push edx	; 6CA1B
mov ebx, dword [keydb]	; 6CA1C
push ebx	; 6CA22
lea eax, [byte esp+08h]	; 6CA23
push eax	; 6CA27
call sub_932D0	; 6CA28
add esp, byte 0Ch	; 6CA2D
mov ebx, dword [leaguedbnames+10h]	; 6CA30
mov ecx, esi	; 6CA36
xor edx, edx	; 6CA38
mov eax, esp	; 6CA3A
call MakePath	; 6CA3C
mov ecx, dword [teamsdb_size]	; 6CA41
push ecx	; 6CA47
mov edi, dword [teamsdb]	; 6CA48
push edi	; 6CA4E
lea eax, [byte esp+08h]	; 6CA4F
push eax	; 6CA53
call sub_932D0	; 6CA54
add esp, byte 0Ch	; 6CA59
mov ebx, dword [leaguedbnames+8]	; 6CA5C
mov ecx, esi	; 6CA62
xor edx, edx	; 6CA64
mov eax, esp	; 6CA66
call MakePath	; 6CA68
mov ebp, dword [attdb_size]	; 6CA6D
push ebp	; 6CA73
mov eax, dword [attdb]	; 6CA74
push eax	; 6CA79
lea eax, [byte esp+08h]	; 6CA7A
push eax	; 6CA7E
call sub_932D0	; 6CA7F
add esp, byte 0Ch	; 6CA84
add esp, byte 20h	; 6CA87
jmp near BuildFreeAgentList_ret	; 6CA8A
%endif ; C
; C: src/pc/league_db/BuildFreeAgentList.c (FreeLeagueDbsMem)
%ifdef CBUILD
%include "c/pc/league_db/BuildFreeAgentList.FreeLeagueDbsMem.inc"
%else
FreeLeagueDbsMem:
push dword 20h	; 6CA8F
call __CHK	; 6CA94
push ebx	; 6CA99
push ecx	; 6CA9A
push edx	; 6CA9B
push esi	; 6CA9C
push edi	; 6CA9D
push ebp	; 6CA9E
mov edx, dword [attdb]	; 6CA9F
test edx, edx	; 6CAA5
je short .1	; 6CAA7
push edx	; 6CAA9
call FreeMemBlock	; 6CAAA
add esp, byte 4	; 6CAAF
xor ecx, ecx	; 6CAB2
mov dword [attdb], ecx	; 6CAB4
mov dword [attdb_size], ecx	; 6CABA
.1:
mov edi, dword [teamsdb]	; 6CAC0
test edi, edi	; 6CAC6
je short .2	; 6CAC8
push edi	; 6CACA
call FreeMemBlock	; 6CACB
add esp, byte 4	; 6CAD0
xor eax, eax	; 6CAD3
mov dword [teamsdb], eax	; 6CAD5
mov dword [teamsdb_size], eax	; 6CADA
.2:
mov ebx, dword [keydb]	; 6CADF
test ebx, ebx	; 6CAE5
je short .3	; 6CAE7
push ebx	; 6CAE9
call FreeMemBlock	; 6CAEA
add esp, byte 4	; 6CAEF
xor esi, esi	; 6CAF2
mov dword [keydb], esi	; 6CAF4
mov dword [keydb_size], esi	; 6CAFA
.3:
mov ebp, dword [carteamsdb]	; 6CB00
test ebp, ebp	; 6CB06
je short .4	; 6CB08
push ebp	; 6CB0A
call FreeMemBlock	; 6CB0B
add esp, byte 4	; 6CB10
xor edx, edx	; 6CB13
mov dword [carteamsdb], edx	; 6CB15
mov dword [carteamsdb_size], edx	; 6CB1B
.4:
mov ecx, dword [careerdb]	; 6CB21
test ecx, ecx	; 6CB27
je short .5	; 6CB29
push ecx	; 6CB2B
call FreeMemBlock	; 6CB2C
add esp, byte 4	; 6CB31
xor edi, edi	; 6CB34
mov dword [careerdb], edi	; 6CB36
mov dword [careerdb_size], edi	; 6CB3C
.5:
mov eax, dword [seasondb]	; 6CB42
test eax, eax	; 6CB47
je near BuildFreeAgentList_ret	; 6CB49
push eax	; 6CB4F
call FreeMemBlock	; 6CB50
add esp, byte 4	; 6CB55
xor ebx, ebx	; 6CB58
mov dword [seasondb], ebx	; 6CB5A
mov dword [seasondb_size], ebx	; 6CB60
jmp near BuildFreeAgentList_ret	; 6CB66
%endif ; C
; C: src/pc/league_db/CarTeamRecPtr.c
%ifdef CBUILD
%include "c/pc/league_db/CarTeamRecPtr.inc"
%else
CarTeamRecPtr:
push dword 8	; 6CB6B
call __CHK	; 6CB70
push edx	; 6CB75
mov edx, eax	; 6CB76
shl eax, 2	; 6CB78
add eax, edx	; 6CB7B
shl eax, 2	; 6CB7D
sub eax, edx	; 6CB80
mov edx, eax	; 6CB82
shl edx, 2	; 6CB84
mov eax, dword [carteamsdb]	; 6CB87
add eax, edx	; 6CB8C
pop edx	; 6CB8E
ret	; 6CB8F
%endif ; C
; C: src/pc/league_db/TeamRecPtr.c
%ifdef CBUILD
%include "c/pc/league_db/TeamRecPtr.inc"
%else
TeamRecPtr:
push dword 8	; 6CB90
call __CHK	; 6CB95
push edx	; 6CB9A
mov edx, eax	; 6CB9B
shl eax, 2	; 6CB9D
sub eax, edx	; 6CBA0
shl eax, 3	; 6CBA2
mov edx, eax	; 6CBA5
shl eax, 5	; 6CBA7
sub eax, edx	; 6CBAA
mov edx, eax	; 6CBAC
mov eax, dword [teamsdb]	; 6CBAE
add eax, edx	; 6CBB3
pop edx	; 6CBB5
ret	; 6CBB6
%endif ; C
; C: src/pc/league_db/KeyDbPtr.c
%ifdef CBUILD
%include "c/pc/league_db/KeyDbPtr.inc"
%else
KeyDbPtr:
push dword 8	; 6CBB7
call __CHK	; 6CBBC
push edx	; 6CBC1
mov edx, dword [keydb]	; 6CBC2
add eax, edx	; 6CBC8
pop edx	; 6CBCA
ret	; 6CBCB
SeasonDbPtr:
push dword 8	; 6CBCC
SeasonDbPtr_common:
call __CHK	; 6CBD1
push edx	; 6CBD6
mov edx, dword [seasondb]	; 6CBD7
add eax, edx	; 6CBDD
pop edx	; 6CBDF
ret	; 6CBE0
SeasonDbPtr2:
push dword 8	; 6CBE1
jmp short SeasonDbPtr_common	; 6CBE6
CareerDbPtr:
push dword 8	; 6CBE8
CareerDbPtr_common:
call __CHK	; 6CBED
push edx	; 6CBF2
mov edx, dword [careerdb]	; 6CBF3
add eax, edx	; 6CBF9
pop edx	; 6CBFB
ret	; 6CBFC
CareerDbPtr2:
push dword 8	; 6CBFD
jmp short CareerDbPtr_common	; 6CC02
AttDbPtr:
push dword 8	; 6CC04
.1:
call __CHK	; 6CC09
push edx	; 6CC0E
mov edx, dword [attdb]	; 6CC0F
add eax, edx	; 6CC15
pop edx	; 6CC17
ret	; 6CC18
AttDbPtr2:
push dword 8	; 6CC19
jmp short AttDbPtr.1	; 6CC1E
%endif ; C
