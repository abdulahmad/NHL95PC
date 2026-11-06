; The scoreboard drawn during a game: the score, the clock, the line energy and penalty bars,
; and the Stanley Cup final series. One module: the panel functions share UpdateHudPanel's exit.
bits 32
%include "hockey.inc"
section s_14A20 progbits alloc exec nowrite align=1
extern __CHK, _dos_close_, _dos_creat_, _dos_getdiskfree_, _dos_open_, _dos_read_, _dos_write_, awlineind
extern awpanelspr, awscore, awtmline, awtmstruct, byte_DC8D8, byte_DC91B, byte_DC9D7, byte_DC9D8
extern byte_DCA1B, byte_DCAD7, cddriveptr, clockcolon, clockdigits, cont2team, crestnames, ctlavailmask
extern cupseries, curleague, demomode, DemoSetupStub, demoteammode, dword_C56C4, dword_C56E4, dword_C5710
extern dword_C5714, dword_C5718, dword_C583C, dword_C5844, dword_C5848, dword_C5854, dword_C5858, dword_C585C
extern dword_C5860, dword_C5861, dword_C5862, dword_CC0EC, dword_DC2B8, energywarn, exhstate, FadeOutPalCycle
extern FatalError, fileoncd, FreeMemBlock, Gameloop, gamemode, gameopts, gamepal, gameresult
extern GetPeriodTime, gmode, hmlineind, hmpanelspr, hmscore, hmtmline, hmtmstruct, HomeTeam
extern hudawayline, hudclockhund, hudclockmin, hudclocksec, hudhomeline, hudhundstep, hudpenaway, hudpenhome
extern InitGameSummary, InputInstall, InputRemove, introskipped, j_unlink_, joyq_flush, lcblink, lcboxon
extern lcline, leaguedbnames, linesprites, LoadModeState, LoadRink, LoadRockMusic, LoadScheduleDB, LoadTeamPalette
extern lseek_, MakePath, MessageBox, mousebtns, mousepollfn, MouseSetPos, msg_NeedKbytes, musicon
extern off_C56B5, off_C57C8, PaPreloadClips, penaltydigits, perioddigits, PerTimeTab, PollKey, rand_
extern randomd0, ReloadGameGfx, rmdir_, scoredigits, seed, SelectRinkBM, SelectScreenBM, SeriesLength
extern SetScreenSize, SetupControllers, SetupDemoGame, ShowLoadingScreen, sprintf_, str_backslash2, str_Crests4, str_dot
extern str_ErrDiskFree4, str_ErrDiskFree5, str_GsummaryDb, str_NeedKbytesFmt, str_PPV, str_Scrbrd2, str_Srb3, str_Stanley
extern str_star, strcat_, strcpy_, sub_8CCA8, sub_8E8A0, sub_90D20, sub_B30B4, sub_B3464
extern sub_B4CD8, sub_B4CF2, sub_B4DD4, sub_B4E50, teamabbrevs, teamdivflags, TeamLineEnergy, unknown_libname_1
extern unknown_libname_2, VisTeam, word_CBC60
global DrawPanelScore, DrawPanelLine, DrawPanelLine_x, GetLineEnergies, PanelAddPenalty, PanelRemovePenalty, UpdateHudPanel, UpdateHudPanel_x
global DrawPanelClock, DrawHudPanel, TickPanelClock, DrawPanelClockDigits, TickPanelPenalties, DrawEnergyBar, DrawLineGroupBars, DrawPanelPenalties
global LoadCupFinalSeries, IsCupClinched, CupSeriesWinner
; C: src/front/scoreboard/DrawPanelScore.c
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelScore.inc"
%else
DrawPanelScore:
push dword 1Ch	; 14A20
call __CHK	; 14A25
push ebx	; 14A2A
push ecx	; 14A2B
push esi	; 14A2C
mov ebx, eax	; 14A2D
mov esi, edx	; 14A2F
cmp dx, byte 64h	; 14A31
jl short .1	; 14A35
mov ecx, 64h	; 14A37
mov eax, edx	; 14A3C
cwd	; 14A3E
idiv cx	; 14A40
mov esi, edx	; 14A43
.1:
call SelectScreenBM	; 14A45
test bx, bx	; 14A4A
je short .4	; 14A4D
push byte 4	; 14A4F
push dword 0FFh	; 14A51
cmp si, byte 0Ah	; 14A56
jge short .2	; 14A5A
mov eax, 0Ah	; 14A5C
jmp short .3	; 14A61
.2:
movsx edx, si	; 14A63
mov ebx, 0Ah	; 14A66
mov eax, edx	; 14A6B
sar edx, 1Fh	; 14A6D
idiv ebx	; 14A70
.3:
mov ecx, dword [nosplit eax*4+scoredigits]	; 14A72
push ecx	; 14A79
call sub_B4CD8	; 14A7A
add esp, byte 0Ch	; 14A7F
push byte 4	; 14A82
push dword 109h	; 14A84
movsx edx, si	; 14A89
mov ebx, 0Ah	; 14A8C
mov eax, edx	; 14A91
sar edx, 1Fh	; 14A93
idiv ebx	; 14A96
mov esi, dword [nosplit edx*4+scoredigits]	; 14A98
push esi	; 14A9F
jmp short .7	; 14AA0
.4:
push byte 4	; 14AA2
push byte 2Eh	; 14AA4
cmp si, byte 0Ah	; 14AA6
jge short .5	; 14AAA
mov eax, 0Ah	; 14AAC
jmp short .6	; 14AB1
.5:
movsx edx, si	; 14AB3
mov ebx, 0Ah	; 14AB6
mov eax, edx	; 14ABB
sar edx, 1Fh	; 14ABD
idiv ebx	; 14AC0
.6:
mov edx, dword [nosplit eax*4+scoredigits]	; 14AC2
push edx	; 14AC9
call sub_B4CD8	; 14ACA
add esp, byte 0Ch	; 14ACF
push byte 4	; 14AD2
push byte 38h	; 14AD4
movsx edx, si	; 14AD6
mov ebx, 0Ah	; 14AD9
mov eax, edx	; 14ADE
sar edx, 1Fh	; 14AE0
idiv ebx	; 14AE3
mov ebx, dword [nosplit edx*4+scoredigits]	; 14AE5
push ebx	; 14AEC
.7:
call sub_B4CD8	; 14AED
add esp, byte 0Ch	; 14AF2
call SelectRinkBM	; 14AF5
pop esi	; 14AFA
pop ecx	; 14AFB
pop ebx	; 14AFC
ret	; 14AFD
%endif ; C
; C: src/front/scoreboard/DrawPanelLine.c
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelLine.inc"
%else
DrawPanelLine:
push dword 24h	; 14AFE
call __CHK	; 14B03
push ebx	; 14B08
push ecx	; 14B09
push esi	; 14B0A
push edi	; 14B0B
push ebp	; 14B0C
mov ebx, eax	; 14B0D
call SelectScreenBM	; 14B0F
test bx, bx	; 14B14
je short .3	; 14B17
mov ebp, dword [hudawayline]	; 14B19
cmp ebp, byte 4	; 14B1F
setl al	; 14B22
mov ebx, eax	; 14B25
and ebx, 0FFh	; 14B27
cmp dx, byte 4	; 14B2D
setl al	; 14B31
and eax, 0FFh	; 14B34
xor eax, ebx	; 14B39
jne short .1	; 14B3B
cmp ebp, byte 6	; 14B3D
setl al	; 14B40
mov ebx, eax	; 14B43
and ebx, 0FFh	; 14B45
cmp dx, byte 6	; 14B4B
setl al	; 14B4F
and eax, 0FFh	; 14B52
xor eax, ebx	; 14B57
je short .2	; 14B59
.1:
xor ecx, ecx	; 14B5B
mov dword [dword_C5860], ecx	; 14B5D
.2:
movsx eax, dx	; 14B63
mov dword [hudawayline], eax	; 14B66
push byte 14h	; 14B6B
push dword 0FBh	; 14B6D
mov esi, dword [nosplit eax*4+linesprites]	; 14B72
push esi	; 14B79
jmp short .6	; 14B7A
.3:
cmp dword [hudhomeline], byte 4	; 14B7C
setl al	; 14B83
mov ebx, eax	; 14B86
and ebx, 0FFh	; 14B88
cmp dx, byte 4	; 14B8E
setl al	; 14B92
and eax, 0FFh	; 14B95
xor eax, ebx	; 14B9A
jne short .4	; 14B9C
cmp dword [hudhomeline], byte 6	; 14B9E
setl al	; 14BA5
mov ebx, eax	; 14BA8
and ebx, 0FFh	; 14BAA
cmp dx, byte 6	; 14BB0
setl al	; 14BB4
and eax, 0FFh	; 14BB7
xor eax, ebx	; 14BBC
je short .5	; 14BBE
.4:
xor esi, esi	; 14BC0
mov dword [dword_C585C], esi	; 14BC2
.5:
movsx eax, dx	; 14BC8
mov dword [hudhomeline], eax	; 14BCB
push byte 14h	; 14BD0
push byte 2Ah	; 14BD2
mov edi, dword [nosplit eax*4+linesprites]	; 14BD4
push edi	; 14BDB
.6:
call sub_B4CD8	; 14BDC
add esp, byte 0Ch	; 14BE1
call SelectRinkBM	; 14BE4
DrawPanelLine_x:
pop ebp	; 14BE9
pop edi	; 14BEA
pop esi	; 14BEB
pop ecx	; 14BEC
pop ebx	; 14BED
ret	; 14BEE
%endif ; C
; C: src/front/scoreboard/GetLineEnergies.c
%ifdef CBUILD
%include "c/front/scoreboard/GetLineEnergies.inc"
%else
GetLineEnergies:
push dword 10h	; 14BEF
call __CHK	; 14BF4
push ebx	; 14BF9
push ecx	; 14BFA
push esi	; 14BFB
mov ecx, eax	; 14BFC
mov esi, edx	; 14BFE
xor ebx, ebx	; 14C00
.1:
movsx edx, bx	; 14C02
movsx eax, cx	; 14C05
call TeamLineEnergy	; 14C08
movsx edx, ax	; 14C0D
mov eax, ebx	; 14C10
sub edx, byte 60h	; 14C12
mov dword [esi+eax*4], edx	; 14C15
inc ebx	; 14C18
cmp ebx, byte 8	; 14C19
jl short GetLineEnergies.1	; 14C1C
pop esi	; 14C1E
pop ecx	; 14C1F
pop ebx	; 14C20
ret	; 14C21
%endif ; C
; C: src/front/scoreboard/PanelAddPenalty.c
%ifdef CBUILD
%include "c/front/scoreboard/PanelAddPenalty.inc"
%else
PanelAddPenalty:
push dword 10h	; 14C22
call __CHK	; 14C27
push ecx	; 14C2C
push esi	; 14C2D
push edi	; 14C2E
mov ecx, eax	; 14C2F
mov edi, edx	; 14C31
mov esi, ebx	; 14C33
xor edx, edx	; 14C35
mov dword [dword_C585C], edx	; 14C37
mov dword [dword_C5860], edx	; 14C3D
test ax, ax	; 14C43
je short .1	; 14C46
mov eax, hudpenaway	; 14C48
jmp short .2	; 14C4D
.1:
mov eax, hudpenhome	; 14C4F
.2:
xor edx, edx	; 14C54
jmp short .6	; 14C56
.3:
movsx ebx, word [eax]	; 14C58
cmp ebx, byte 0FFFFFFFFh	; 14C5B
jne short .5	; 14C5E
mov word [eax], di	; 14C60
mov word [byte eax+02h], si	; 14C63
mov word [byte eax+06h], 0	; 14C67
mov dx, word [byte eax+06h]	; 14C6D
mov word [byte eax+04h], dx	; 14C71
test cx, cx	; 14C75
je short .4	; 14C78
xor esi, esi	; 14C7A
mov dword [dword_C5848], esi	; 14C7C
pop edi	; 14C82
pop esi	; 14C83
pop ecx	; 14C84
ret	; 14C85
.4:
xor ecx, ecx	; 14C86
mov dword [dword_C5844], ecx	; 14C88
pop edi	; 14C8E
pop esi	; 14C8F
pop ecx	; 14C90
ret	; 14C91
.5:
add eax, byte 8	; 14C92
inc edx	; 14C95
.6:
cmp dx, byte 8	; 14C96
jl short PanelAddPenalty.3	; 14C9A
pop edi	; 14C9C
pop esi	; 14C9D
pop ecx	; 14C9E
ret	; 14C9F
%endif ; C
; C: src/front/scoreboard/PanelRemovePenalty.c
%ifdef CBUILD
%include "c/front/scoreboard/PanelRemovePenalty.inc"
%else
PanelRemovePenalty:
push dword 0Ch	; 14CA0
call __CHK	; 14CA5
push ebx	; 14CAA
push ecx	; 14CAB
mov ecx, edx	; 14CAC
test ax, ax	; 14CAE
je short .1	; 14CB1
mov eax, hudpenaway	; 14CB3
jmp short .2	; 14CB8
.1:
mov eax, hudpenhome	; 14CBA
.2:
xor ebx, ebx	; 14CBF
xor edx, edx	; 14CC1
jmp short .5	; 14CC3
.3:
cmp cx, word [eax]	; 14CC5
jne short .4	; 14CC8
mov ebx, eax	; 14CCA
jmp short .6	; 14CCC
.4:
add eax, byte 8	; 14CCE
inc edx	; 14CD1
.5:
cmp dx, byte 8	; 14CD2
jl short PanelRemovePenalty.3	; 14CD6
.6:
test ebx, ebx	; 14CD8
je short .x	; 14CDA
mov word [byte ebx+06h], 0	; 14CDC
mov ax, word [byte ebx+06h]	; 14CE2
mov word [byte ebx+04h], ax	; 14CE6
mov word [byte ebx+02h], ax	; 14CEA
.x:
pop ecx	; 14CEE
pop ebx	; 14CEF
ret	; 14CF0
%endif ; C
; C: src/front/scoreboard/UpdateHudPanel.c
%ifdef CBUILD
%include "c/front/scoreboard/UpdateHudPanel.inc"
%else
UpdateHudPanel:
push dword 20h	; 14CF1
call __CHK	; 14CF6
push ebx	; 14CFB
push ecx	; 14CFC
push edx	; 14CFD
push esi	; 14CFE
push edi	; 14CFF
push ebp	; 14D00
call SelectScreenBM	; 14D01
cmp dword [hudclockmin], byte 0	; 14D06
jl near UpdateHudPanel_x	; 14D0D
mov eax, dword [hudhundstep]	; 14D13
mov dword [dword_C583C], eax	; 14D18
xor ebx, ebx	; 14D1D
mov dword [hudhundstep], ebx	; 14D1F
call TickPanelClock	; 14D25
test eax, eax	; 14D2A
je short .1	; 14D2C
test byte [gmode], 10h	; 14D2E
jne short .1	; 14D35
mov edx, dword [dword_C583C]	; 14D37
mov eax, hudpenhome	; 14D3D
call TickPanelPenalties	; 14D42
mov edx, dword [dword_C583C]	; 14D47
mov eax, hudpenaway	; 14D4D
call TickPanelPenalties	; 14D52
.1:
mov edx, dword_C56E4	; 14D57
xor eax, eax	; 14D5C
call GetLineEnergies	; 14D5E
mov edx, dword_C56C4	; 14D63
mov eax, 1	; 14D68
call GetLineEnergies	; 14D6D
call DrawPanelClockDigits	; 14D72
mov edx, dword [hudhomeline]	; 14D77
mov ebx, 1F4h	; 14D7D
mov eax, dword [nosplit edx*4+dword_C56E4]	; 14D82
mov edx, eax	; 14D89
sar edx, 1Fh	; 14D8B
idiv ebx	; 14D8E
mov edx, 2Bh	; 14D90
call DrawEnergyBar	; 14D95
mov edx, dword [hudawayline]	; 14D9A
mov eax, dword [nosplit edx*4+dword_C56C4]	; 14DA0
mov edx, eax	; 14DA7
sar edx, 1Fh	; 14DA9
idiv ebx	; 14DAC
mov edx, 0FCh	; 14DAE
call DrawEnergyBar	; 14DB3
cmp word [lcboxon], byte 0	; 14DB8
jne short .2	; 14DC0
cmp dword [dword_C5844], byte 0	; 14DC2
jne short .2	; 14DC9
test byte [gmode], 10h	; 14DCB
je short .3	; 14DD2
.2:
push byte 4Ah	; 14DD4
mov ebx, dword [hudhomeline]	; 14DD6
mov ecx, dword_C56E4	; 14DDC
mov edx, hmlineind	; 14DE1
mov eax, dword_C585C	; 14DE6
call DrawLineGroupBars	; 14DEB
xor ecx, ecx	; 14DF0
mov dword [dword_C5854], ecx	; 14DF2
jmp short .6	; 14DF8
.3:
cmp word [hudpenhome], byte 0	; 14DFA
jge short .4	; 14E02
mov dword [dword_C5844], 1	; 14E04
push byte 4Ah	; 14E0E
mov ebx, dword [hudhomeline]	; 14E10
mov ecx, dword_C56E4	; 14E16
mov edx, hmlineind	; 14E1B
mov eax, dword_C585C	; 14E20
call DrawLineGroupBars	; 14E25
xor ebx, ebx	; 14E2A
mov dword [dword_C5854], ebx	; 14E2C
jmp short .6	; 14E32
.4:
cmp dword [dword_C5854], byte 0	; 14E34
jne short .5	; 14E3B
mov edi, dword [hmpanelspr]	; 14E3D
push edi	; 14E43
call sub_B4CF2	; 14E44
add esp, byte 4	; 14E49
mov dword [dword_C5854], 1	; 14E4C
.5:
mov edx, 48h	; 14E56
mov eax, hudpenhome	; 14E5B
call DrawPanelPenalties	; 14E60
xor eax, eax	; 14E65
mov dword [dword_C585C], eax	; 14E67
.6:
cmp word [lcboxon+2], byte 0	; 14E6C
jne short .7	; 14E74
cmp dword [dword_C5848], byte 0	; 14E76
jne short .7	; 14E7D
test byte [gmode], 10h	; 14E7F
je short .8	; 14E86
.7:
push dword 0C1h	; 14E88
mov ebx, dword [hudawayline]	; 14E8D
mov ecx, dword_C56C4	; 14E93
mov edx, awlineind	; 14E98
mov eax, dword_C5860	; 14E9D
call DrawLineGroupBars	; 14EA2
xor esi, esi	; 14EA7
mov dword [dword_C5858], esi	; 14EA9
jmp near UpdateHudPanel_x	; 14EAF
.8:
cmp word [hudpenaway], byte 0	; 14EB4
jge short .9	; 14EBC
mov dword [dword_C5848], 1	; 14EBE
push dword 0C1h	; 14EC8
mov ebx, dword [hudawayline]	; 14ECD
mov ecx, dword_C56C4	; 14ED3
mov edx, awlineind	; 14ED8
mov eax, dword_C5860	; 14EDD
call DrawLineGroupBars	; 14EE2
xor ecx, ecx	; 14EE7
mov dword [dword_C5858], ecx	; 14EE9
jmp short UpdateHudPanel_x	; 14EEF
.9:
cmp dword [dword_C5858], byte 0	; 14EF1
jne short .10	; 14EF8
mov ebp, dword [awpanelspr]	; 14EFA
push ebp	; 14F00
call sub_B4CF2	; 14F01
add esp, byte 4	; 14F06
mov dword [dword_C5858], 1	; 14F09
.10:
mov edx, 0BFh	; 14F13
mov eax, hudpenaway	; 14F18
call DrawPanelPenalties	; 14F1D
xor edx, edx	; 14F22
mov dword [dword_C5860], edx	; 14F24
UpdateHudPanel_x:
pop ebp	; 14F2A
pop edi	; 14F2B
pop esi	; 14F2C
pop edx	; 14F2D
pop ecx	; 14F2E
pop ebx	; 14F2F
ret	; 14F30
%endif ; C
; C: src/front/scoreboard/UpdateHudPanel.c (DrawPanelClock)
%ifdef CBUILD
%include "c/front/scoreboard/UpdateHudPanel.DrawPanelClock.inc"
%else
DrawPanelClock:
push dword 28h	; 14F31
call __CHK	; 14F36
push ebx	; 14F3B
push ecx	; 14F3C
push edx	; 14F3D
push esi	; 14F3E
push edi	; 14F3F
push ebp	; 14F40
mov edx, dword [hudclockmin]	; 14F41
test edx, edx	; 14F47
jne near .3	; 14F49
push byte 3	; 14F4F
push dword 0AAh	; 14F51
mov edx, dword [clockcolon]	; 14F56
push edx	; 14F5C
call sub_B4CD8	; 14F5D
add esp, byte 0Ch	; 14F62
cmp dword [hudclocksec], byte 0Ah	; 14F65
jge short .1	; 14F6C
push byte 3	; 14F6E
push dword 8Ch	; 14F70
mov esi, dword [clockcolon]	; 14F75
push esi	; 14F7B
jmp short .2	; 14F7C
.1:
push byte 3	; 14F7E
push dword 8Ch	; 14F80
mov ebx, 0Ah	; 14F85
mov eax, dword [hudclocksec]	; 14F8A
mov edx, eax	; 14F8F
sar edx, 1Fh	; 14F91
idiv ebx	; 14F94
mov ecx, dword [nosplit eax*4+clockdigits]	; 14F96
push ecx	; 14F9D
.2:
call sub_B4CD8	; 14F9E
add esp, byte 0Ch	; 14FA3
push byte 3	; 14FA6
push dword 95h	; 14FA8
mov ebx, 0Ah	; 14FAD
mov eax, dword [hudclocksec]	; 14FB2
mov edx, eax	; 14FB7
sar edx, 1Fh	; 14FB9
idiv ebx	; 14FBC
mov edi, dword [nosplit edx*4+clockdigits]	; 14FBE
push edi	; 14FC5
call sub_B4CD8	; 14FC6
add esp, byte 0Ch	; 14FCB
push byte 3	; 14FCE
push dword 0A1h	; 14FD0
mov ebx, 0Ah	; 14FD5
mov eax, dword [hudclockhund]	; 14FDA
mov edx, eax	; 14FDF
sar edx, 1Fh	; 14FE1
idiv ebx	; 14FE4
mov ebp, dword [nosplit eax*4+clockdigits]	; 14FE6
push ebp	; 14FED
jmp near .6	; 14FEE
.3:
cmp edx, byte 0Ah	; 14FF3
jge short .4	; 14FF6
push byte 3	; 14FF8
push dword 8Ch	; 14FFA
mov esi, dword [clockcolon]	; 14FFF
push esi	; 15005
jmp short .5	; 15006
.4:
push byte 3	; 15008
push dword 8Ch	; 1500A
mov ebx, 0Ah	; 1500F
mov eax, edx	; 15014
sar edx, 1Fh	; 15016
idiv ebx	; 15019
mov ecx, dword [nosplit eax*4+clockdigits]	; 1501B
push ecx	; 15022
.5:
call sub_B4CD8	; 15023
add esp, byte 0Ch	; 15028
push byte 3	; 1502B
push dword 95h	; 1502D
mov ebx, 0Ah	; 15032
mov eax, dword [hudclockmin]	; 15037
mov edx, eax	; 1503C
sar edx, 1Fh	; 1503E
idiv ebx	; 15041
mov edi, dword [nosplit edx*4+clockdigits]	; 15043
push edi	; 1504A
call sub_B4CD8	; 1504B
add esp, byte 0Ch	; 15050
push byte 3	; 15053
push dword 0A1h	; 15055
mov ebx, 0Ah	; 1505A
mov eax, dword [hudclocksec]	; 1505F
mov edx, eax	; 15064
sar edx, 1Fh	; 15066
idiv ebx	; 15069
mov ebp, dword [nosplit eax*4+clockdigits]	; 1506B
push ebp	; 15072
call sub_B4CD8	; 15073
add esp, byte 0Ch	; 15078
push byte 3	; 1507B
push dword 0AAh	; 1507D
mov ebx, 0Ah	; 15082
mov eax, dword [hudclocksec]	; 15087
mov edx, eax	; 1508C
sar edx, 1Fh	; 1508E
idiv ebx	; 15091
mov eax, dword [nosplit edx*4+clockdigits]	; 15093
push eax	; 1509A
.6:
call sub_B4CD8	; 1509B
add esp, byte 0Ch	; 150A0
mov eax, dword [hudclockmin]	; 150A3
mov dword [dword_C5710], eax	; 150A8
mov eax, dword [hudclocksec]	; 150AD
mov dword [dword_C5714], eax	; 150B2
mov eax, dword [hudclockhund]	; 150B7
mov dword [dword_C5718], eax	; 150BC
jmp near UpdateHudPanel_x	; 150C1
%endif ; C
; C: src/front/scoreboard/DrawHudPanel.c
%ifdef CBUILD
%include "c/front/scoreboard/DrawHudPanel.inc"
%else
DrawHudPanel:
push dword 34h	; 150C6
call __CHK	; 150CB
push esi	; 150D0
push edi	; 150D1
push ebp	; 150D2
sub esp, byte 14h	; 150D3
push eax	; 150D6
mov ebp, edx	; 150D7
mov esi, ebx	; 150D9
test ecx, ecx	; 150DB
je short .1	; 150DD
call GetPeriodTime	; 150DF
cwde	; 150E4
mov dword [hudclocksec], eax	; 150E5
mov dword [hudclockmin], eax	; 150EA
mov ebx, 3Ch	; 150EF
mov edx, eax	; 150F4
sar edx, 1Fh	; 150F6
idiv ebx	; 150F9
mov dword [hudclockmin], eax	; 150FB
mov eax, dword [hudclocksec]	; 15100
mov edx, eax	; 15105
sar edx, 1Fh	; 15107
idiv ebx	; 1510A
mov dword [hudclocksec], edx	; 1510C
xor edx, edx	; 15112
mov dword [hudclockhund], edx	; 15114
.1:
xor ebx, ebx	; 1511A
mov dword [dword_C583C], ebx	; 1511C
mov dword [dword_C5848], ebx	; 15122
mov dword [dword_C5844], ebx	; 15128
mov eax, dword [hmtmline-2]	; 1512E
sar eax, 10h	; 15133
mov dword [hudhomeline], eax	; 15136
mov eax, dword [awtmline-2]	; 1513B
sar eax, 10h	; 15140
mov dword [hudawayline], eax	; 15143
mov dword [dword_C5858], ebx	; 15148
mov dword [dword_C5854], ebx	; 1514E
mov dword [dword_C5860], ebx	; 15154
mov dword [dword_C585C], ebx	; 1515A
call SelectScreenBM	; 15160
mov ecx, str_PPV	; 15165
mov ebx, str_Scrbrd2	; 1516A
cmp byte [fileoncd+016Dh], 1	; 1516F
jne short .2	; 15176
mov edx, dword [cddriveptr]	; 15178
jmp short .3	; 1517E
.2:
xor edx, edx	; 15180
.3:
lea eax, [byte esp+04h]	; 15182
call MakePath	; 15186
push byte 0	; 1518B
lea eax, [byte esp+08h]	; 1518D
push eax	; 15191
call sub_8E8A0	; 15192
mov edi, eax	; 15197
add esp, byte 8	; 15199
mov dword [byte esp+014h], eax	; 1519C
push str_Srb3	; 151A0
push eax	; 151A5
call sub_B30B4	; 151A6
add esp, byte 8	; 151AB
push eax	; 151AE
call sub_B4CF2	; 151AF
add esp, byte 4	; 151B4
mov edx, dword [hmscore-2]	; 151B7
sar edx, 10h	; 151BD
xor eax, eax	; 151C0
call DrawPanelScore	; 151C2
mov edx, dword [awscore-2]	; 151C7
sar edx, 10h	; 151CD
mov eax, 1	; 151D0
call DrawPanelScore	; 151D5
call SelectScreenBM	; 151DA
call DrawPanelClock	; 151DF
test esi, esi	; 151E4
jne short .4	; 151E6
push byte 16h	; 151E8
push dword 98h	; 151EA
mov ecx, dword [off_C57C8]	; 151EF
push ecx	; 151F5
jmp short .5	; 151F6
.4:
mov ebx, 64h	; 151F8
mov eax, esi	; 151FD
mov edx, esi	; 151FF
sar edx, 1Fh	; 15201
idiv ebx	; 15204
mov esi, edx	; 15206
push byte 16h	; 15208
push dword 98h	; 1520A
mov ebx, 0Ah	; 1520F
mov eax, edx	; 15214
sar edx, 1Fh	; 15216
idiv ebx	; 15219
mov edx, dword [nosplit eax*4+perioddigits]	; 1521B
push edx	; 15222
push edi	; 15223
call sub_B30B4	; 15224
add esp, byte 8	; 15229
push eax	; 1522C
call sub_B4CD8	; 1522D
add esp, byte 0Ch	; 15232
push byte 16h	; 15235
push dword 0A0h	; 15237
mov ebx, 0Ah	; 1523C
mov eax, esi	; 15241
mov edx, esi	; 15243
sar edx, 1Fh	; 15245
idiv ebx	; 15248
mov ebx, dword [nosplit edx*4+perioddigits]	; 1524A
push ebx	; 15251
.5:
push edi	; 15252
call sub_B30B4	; 15253
add esp, byte 8	; 15258
push eax	; 1525B
call sub_B4CD8	; 1525C
add esp, byte 0Ch	; 15261
mov esi, dword [byte esp+014h]	; 15264
push esi	; 15268
call FreeMemBlock	; 15269
add esp, byte 4	; 1526E
mov ecx, str_PPV	; 15271
mov ebx, str_Crests4	; 15276
cmp byte [fileoncd+057h], 1	; 1527B
jne short .6	; 15282
mov edx, dword [cddriveptr]	; 15284
jmp short .7	; 1528A
.6:
xor edx, edx	; 1528C
.7:
lea eax, [byte esp+04h]	; 1528E
call MakePath	; 15292
push byte 0	; 15297
lea eax, [byte esp+08h]	; 15299
push eax	; 1529D
call sub_8E8A0	; 1529E
mov esi, eax	; 152A3
add esp, byte 8	; 152A5
mov dh, 67h	; 152A8
mov byte [byte_DCA1B], dh	; 152AA
mov byte [byte_DC91B], dh	; 152B0
mov bh, 0FFh	; 152B6
mov byte [byte_DC9D7], bh	; 152B8
mov byte [byte_DCAD7], bh	; 152BE
push byte_DC9D8	; 152C4
call sub_B4DD4	; 152C9
add esp, byte 4	; 152CE
push byte 4	; 152D1
push byte 4	; 152D3
mov eax, dword [byte esp+08h]	; 152D5
mov edi, dword [nosplit eax*4+crestnames]	; 152D9
push edi	; 152E0
push esi	; 152E1
call sub_B30B4	; 152E2
add esp, byte 8	; 152E7
push eax	; 152EA
call sub_B4E50	; 152EB
add esp, byte 0Ch	; 152F0
push byte_DC8D8	; 152F3
call sub_B4DD4	; 152F8
add esp, byte 4	; 152FD
push byte 4	; 15300
push dword 11Ch	; 15302
mov ebp, dword [nosplit ebp*4+crestnames]	; 15307
push ebp	; 1530E
push esi	; 1530F
call sub_B30B4	; 15310
add esp, byte 8	; 15315
push eax	; 15318
call sub_B4E50	; 15319
add esp, byte 0Ch	; 1531E
mov ch, 43h	; 15321
mov byte [byte_DCA1B], ch	; 15323
mov byte [byte_DC91B], ch	; 15329
push esi	; 1532F
call FreeMemBlock	; 15330
add esp, byte 4	; 15335
push byte 14h	; 15338
push byte 2Ah	; 1533A
mov eax, dword [hudhomeline]	; 1533C
mov edx, dword [nosplit eax*4+linesprites]	; 15341
push edx	; 15348
call sub_B4CD8	; 15349
add esp, byte 0Ch	; 1534E
push byte 14h	; 15351
push dword 0FBh	; 15353
mov eax, dword [hudawayline]	; 15358
mov ebx, dword [nosplit eax*4+linesprites]	; 1535D
push ebx	; 15364
call sub_B4CD8	; 15365
add esp, byte 0Ch	; 1536A
add esp, byte 18h	; 1536D
pop ebp	; 15370
pop edi	; 15371
pop esi	; 15372
ret	; 15373
%endif ; C
; C: src/front/scoreboard/TickPanelClock.c
%ifdef CBUILD
%include "c/front/scoreboard/TickPanelClock.inc"
%else
TickPanelClock:
push dword 14h	; 15374
call __CHK	; 15379
push ebx	; 1537E
push ecx	; 1537F
push edx	; 15380
push esi	; 15381
mov edx, dword [hudclockmin]	; 15382
mov dword [dword_C5710], edx	; 15388
mov edx, dword [hudclocksec]	; 1538E
mov dword [dword_C5714], edx	; 15394
mov edx, dword [hudclockhund]	; 1539A
mov dword [dword_C5718], edx	; 153A0
sub edx, eax	; 153A6
mov dword [hudclockhund], edx	; 153A8
test edx, edx	; 153AE
jge short .1	; 153B0
lea ecx, [byte edx+064h]	; 153B2
mov dword [hudclockhund], ecx	; 153B5
mov esi, dword [hudclocksec]	; 153BB
dec esi	; 153C1
mov dword [hudclocksec], esi	; 153C2
test esi, esi	; 153C8
jge short .1	; 153CA
mov dword [hudclocksec], 3Bh	; 153CC
mov eax, dword [hudclockmin]	; 153D6
dec eax	; 153DB
mov dword [hudclockmin], eax	; 153DC
test eax, eax	; 153E1
jge short .1	; 153E3
xor ebx, ebx	; 153E5
mov dword [hudclockhund], ebx	; 153E7
mov dword [hudclocksec], ebx	; 153ED
mov dword [hudclockmin], ebx	; 153F3
xor eax, eax	; 153F9
pop esi	; 153FB
pop edx	; 153FC
pop ecx	; 153FD
pop ebx	; 153FE
ret	; 153FF
.1:
mov eax, 1	; 15400
pop esi	; 15405
pop edx	; 15406
pop ecx	; 15407
pop ebx	; 15408
ret	; 15409
%endif ; C
; C: src/front/scoreboard/UpdateHudPanel.c (DrawPanelClockDigits)
%ifdef CBUILD
%include "c/front/scoreboard/UpdateHudPanel.DrawPanelClockDigits.inc"
%else
DrawPanelClockDigits:
push dword 28h	; 1540A
call __CHK	; 1540F
push ebx	; 15414
push ecx	; 15415
push edx	; 15416
push esi	; 15417
push edi	; 15418
push ebp	; 15419
mov edx, dword [hudclockmin]	; 1541A
test edx, edx	; 15420
jne near .6	; 15422
cmp edx, dword [dword_C5710]	; 15428
je short .1	; 1542E
push byte 3	; 15430
push dword 0AAh	; 15432
mov edi, dword [clockcolon]	; 15437
push edi	; 1543D
call sub_B4CD8	; 1543E
add esp, byte 0Ch	; 15443
.1:
mov eax, dword [dword_C5714]	; 15446
mov ebp, dword [hudclocksec]	; 1544B
cmp eax, ebp	; 15451
je near .5	; 15453
mov ebx, 0Ah	; 15459
mov edx, eax	; 1545E
sar edx, 1Fh	; 15460
idiv ebx	; 15463
mov ebx, eax	; 15465
mov ecx, 0Ah	; 15467
mov eax, ebp	; 1546C
mov edx, ebp	; 1546E
sar edx, 1Fh	; 15470
idiv ecx	; 15473
cmp ebx, eax	; 15475
je short .4	; 15477
cmp ebp, ecx	; 15479
jge short .2	; 1547B
push byte 3	; 1547D
push dword 8Ch	; 1547F
mov ecx, dword [clockcolon]	; 15484
push ecx	; 1548A
jmp short .3	; 1548B
.2:
push byte 3	; 1548D
push dword 8Ch	; 1548F
mov ebx, dword [nosplit eax*4+clockdigits]	; 15494
push ebx	; 1549B
.3:
call sub_B4CD8	; 1549C
add esp, byte 0Ch	; 154A1
.4:
mov ebx, 0Ah	; 154A4
mov eax, dword [dword_C5714]	; 154A9
mov edx, eax	; 154AE
sar edx, 1Fh	; 154B0
idiv ebx	; 154B3
mov ebx, edx	; 154B5
mov ecx, 0Ah	; 154B7
mov eax, dword [hudclocksec]	; 154BC
mov edx, eax	; 154C1
sar edx, 1Fh	; 154C3
idiv ecx	; 154C6
cmp ebx, edx	; 154C8
je short .5	; 154CA
push byte 3	; 154CC
push dword 95h	; 154CE
mov esi, dword [nosplit edx*4+clockdigits]	; 154D3
push esi	; 154DA
call sub_B4CD8	; 154DB
add esp, byte 0Ch	; 154E0
.5:
mov ebx, 0Ah	; 154E3
mov eax, dword [dword_C5718]	; 154E8
mov edx, eax	; 154ED
sar edx, 1Fh	; 154EF
idiv ebx	; 154F2
mov ebx, eax	; 154F4
mov ecx, 0Ah	; 154F6
mov eax, dword [hudclockhund]	; 154FB
mov edx, eax	; 15500
sar edx, 1Fh	; 15502
idiv ecx	; 15505
cmp ebx, eax	; 15507
je near UpdateHudPanel_x	; 15509
push byte 3	; 1550F
push dword 0A1h	; 15511
mov edi, dword [nosplit eax*4+clockdigits]	; 15516
push edi	; 1551D
jmp near .12	; 1551E
.6:
mov eax, dword [dword_C5710]	; 15523
cmp eax, edx	; 15528
je near .10	; 1552A
mov ebx, 0Ah	; 15530
mov edx, eax	; 15535
sar edx, 1Fh	; 15537
idiv ebx	; 1553A
mov ebx, eax	; 1553C
mov ecx, 0Ah	; 1553E
mov eax, dword [hudclockmin]	; 15543
mov edx, eax	; 15548
sar edx, 1Fh	; 1554A
idiv ecx	; 1554D
cmp ebx, eax	; 1554F
je short .9	; 15551
cmp dword [hudclockmin], byte 0Ah	; 15553
jge short .7	; 1555A
push byte 3	; 1555C
push dword 8Ch	; 1555E
mov edi, dword [clockcolon]	; 15563
push edi	; 15569
jmp short .8	; 1556A
.7:
push byte 3	; 1556C
push dword 8Ch	; 1556E
mov esi, dword [nosplit eax*4+clockdigits]	; 15573
push esi	; 1557A
.8:
call sub_B4CD8	; 1557B
add esp, byte 0Ch	; 15580
.9:
mov ebx, 0Ah	; 15583
mov eax, dword [dword_C5710]	; 15588
mov edx, eax	; 1558D
sar edx, 1Fh	; 1558F
idiv ebx	; 15592
mov ebx, edx	; 15594
mov ecx, 0Ah	; 15596
mov eax, dword [hudclockmin]	; 1559B
mov edx, eax	; 155A0
sar edx, 1Fh	; 155A2
idiv ecx	; 155A5
cmp ebx, edx	; 155A7
je short .10	; 155A9
push byte 3	; 155AB
push dword 95h	; 155AD
mov ebp, dword [nosplit edx*4+clockdigits]	; 155B2
push ebp	; 155B9
call sub_B4CD8	; 155BA
add esp, byte 0Ch	; 155BF
.10:
mov eax, dword [dword_C5714]	; 155C2
cmp eax, dword [hudclocksec]	; 155C7
je near UpdateHudPanel_x	; 155CD
mov ebx, 0Ah	; 155D3
mov edx, eax	; 155D8
sar edx, 1Fh	; 155DA
idiv ebx	; 155DD
mov ebx, eax	; 155DF
mov ecx, 0Ah	; 155E1
mov eax, dword [hudclocksec]	; 155E6
mov edx, eax	; 155EB
sar edx, 1Fh	; 155ED
idiv ecx	; 155F0
cmp ebx, eax	; 155F2
je short .11	; 155F4
push byte 3	; 155F6
push dword 0A1h	; 155F8
mov ebx, dword [nosplit eax*4+clockdigits]	; 155FD
push ebx	; 15604
call sub_B4CD8	; 15605
add esp, byte 0Ch	; 1560A
.11:
mov ebx, 0Ah	; 1560D
mov eax, dword [dword_C5714]	; 15612
mov edx, eax	; 15617
sar edx, 1Fh	; 15619
idiv ebx	; 1561C
mov ebx, edx	; 1561E
mov ecx, 0Ah	; 15620
mov eax, dword [hudclocksec]	; 15625
mov edx, eax	; 1562A
sar edx, 1Fh	; 1562C
idiv ecx	; 1562F
cmp ebx, edx	; 15631
je near UpdateHudPanel_x	; 15633
push byte 3	; 15639
push dword 0AAh	; 1563B
mov ecx, dword [nosplit edx*4+clockdigits]	; 15640
push ecx	; 15647
.12:
call sub_B4CD8	; 15648
add esp, byte 0Ch	; 1564D
jmp near UpdateHudPanel_x	; 15650
%endif ; C
; C: src/front/scoreboard/DrawPanelLine.c (TickPanelPenalties)
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelLine.TickPanelPenalties.inc"
%else
TickPanelPenalties:
push dword 18h	; 15655
call __CHK	; 1565A
push ebx	; 1565F
push ecx	; 15660
push esi	; 15661
push edi	; 15662
push ebp	; 15663
mov ecx, eax	; 15664
xor ebp, ebp	; 15666
.1:
mov eax, ebp	; 15668
shl eax, 3	; 1566A
add eax, ecx	; 1566D
mov bx, word [byte eax+06h]	; 1566F
sub ebx, edx	; 15673
mov word [byte eax+06h], bx	; 15675
test bx, bx	; 15679
jge short .2	; 1567C
mov edi, ebx	; 1567E
add edi, byte 64h	; 15680
mov word [byte eax+06h], di	; 15683
mov bx, word [byte eax+04h]	; 15687
dec ebx	; 1568B
mov word [byte eax+04h], bx	; 1568C
test bx, bx	; 15690
jge short .2	; 15693
mov word [byte eax+04h], 3Bh	; 15695
mov di, word [byte eax+02h]	; 1569B
dec edi	; 1569F
mov word [byte eax+02h], di	; 156A0
test di, di	; 156A4
jge short .2	; 156A7
mov word [byte eax+02h], 0	; 156A9
mov word [byte eax+04h], 0	; 156AF
mov word [byte eax+06h], 0	; 156B5
mov word [eax], 0FFFFh	; 156BB
.2:
inc ebp	; 156C0
cmp ebp, byte 2	; 156C1
jl short TickPanelPenalties.1	; 156C4
xor ebp, ebp	; 156C6
.3:
mov eax, ebp	; 156C8
cmp word [ecx+eax*8], byte 0	; 156CA
jge short .7	; 156CF
mov ebx, ebp	; 156D1
lea edx, [byte ebp+01h]	; 156D3
jmp short .6	; 156D6
.4:
mov eax, edx	; 156D8
shl eax, 3	; 156DA
add eax, ecx	; 156DD
cmp word [eax], byte 0	; 156DF
jl short .5	; 156E3
mov edi, ebx	; 156E5
shl edi, 3	; 156E7
add edi, ecx	; 156EA
mov esi, eax	; 156EC
movsd	; 156EE
movsd	; 156EF
mov word [eax], 0FFFFh	; 156F0
inc ebx	; 156F5
.5:
inc edx	; 156F6
.6:
cmp edx, byte 8	; 156F7
jl short TickPanelPenalties.4	; 156FA
.7:
inc ebp	; 156FC
cmp ebp, byte 7	; 156FD
jl short TickPanelPenalties.3	; 15700
jmp near DrawPanelLine_x	; 15702
%endif ; C
; C: src/front/scoreboard/DrawPanelLine.c (DrawEnergyBar)
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelLine.DrawEnergyBar.inc"
%else
DrawEnergyBar:
push dword 38h	; 15707
call __CHK	; 1570C
push ebx	; 15711
push ecx	; 15712
push esi	; 15713
push edi	; 15714
push ebp	; 15715
sub esp, byte 0Ch	; 15716
mov esi, eax	; 15719
mov edi, edx	; 1571B
cmp edx, 0A0h	; 1571D
setg al	; 15723
mov ebp, eax	; 15726
and ebp, 0FFh	; 15728
add ebp, ebp	; 1572E
cmp word [dword ebp+energywarn], byte 0	; 15730
je short .1	; 15738
xor ebx, ebx	; 1573A
mov dword [byte esp+08h], ebx	; 1573C
mov ebp, 7	; 15740
jmp short .2	; 15745
.1:
mov dword [byte esp+08h], 67h	; 15747
xor ebp, ebp	; 1574F
.2:
mov ecx, dword [byte esp+08h]	; 15751
push ecx	; 15755
push byte 3	; 15756
push esi	; 15758
push byte 1Ah	; 15759
lea eax, [byte edi+09h]	; 1575B
sub eax, esi	; 1575E
push eax	; 15760
call sub_90D20	; 15761
add esp, byte 14h	; 15766
mov eax, dword [byte esp+08h]	; 15769
push eax	; 1576D
push byte 3	; 1576E
push esi	; 15770
push byte 1Ah	; 15771
lea eax, [byte edi+010h]	; 15773
mov dword [byte esp+010h], eax	; 15776
push eax	; 1577A
call sub_90D20	; 1577B
add esp, byte 14h	; 15780
push ebp	; 15783
push byte 3	; 15784
mov eax, 8	; 15786
sub eax, esi	; 1578B
mov dword [byte esp+0Ch], eax	; 1578D
push eax	; 15791
push byte 1Ah	; 15792
inc edi	; 15794
push edi	; 15795
call sub_90D20	; 15796
add esp, byte 14h	; 1579B
push ebp	; 1579E
push byte 3	; 1579F
mov ecx, dword [byte esp+0Ch]	; 157A1
push ecx	; 157A5
push byte 1Ah	; 157A6
add esi, dword [byte esp+010h]	; 157A8
push esi	; 157AC
call sub_90D20	; 157AD
add esp, byte 14h	; 157B2
add esp, byte 0Ch	; 157B5
jmp near DrawPanelLine_x	; 157B8
%endif ; C
; C: src/front/scoreboard/DrawLineGroupBars.c
%ifdef CBUILD
%include "c/front/scoreboard/DrawLineGroupBars.inc"
%else
DrawLineGroupBars:
push dword 4Ch	; 157BD
call __CHK	; 157C2
push esi	; 157C7
push edi	; 157C8
push ebp	; 157C9
sub esp, byte 28h	; 157CA
mov esi, eax	; 157CD
mov dword [byte esp+014h], ebx	; 157CF
mov dword [byte esp+010h], ecx	; 157D3
cmp dword [byte esp+038h], 0A0h	; 157D7
setg al	; 157DF
movzx ebp, al	; 157E2
mov dword [byte esp+0Ch], ebp	; 157E5
add ebp, ebp	; 157E9
cmp word [dword ebp+lcboxon], byte 0	; 157EB
je short .1	; 157F3
mov ebp, dword [dword ebp+lcline-2]	; 157F5
sar ebp, 10h	; 157FB
jmp short .2	; 157FE
.1:
mov ebp, dword [byte esp+014h]	; 15800
.2:
mov dword [byte esp+01Ch], ebp	; 15804
mov ecx, dword [byte esp+01Ch]	; 15808
cmp ecx, byte 4	; 1580C
jb short .3	; 1580F
cmp ecx, byte 5	; 15811
jbe short .5	; 15814
cmp ecx, byte 7	; 15816
jbe short .7	; 15819
jmp near .9	; 1581B
.3:
cmp dword [esi], byte 0	; 15820
jne short .4	; 15823
mov ebp, dword [edx]	; 15825
push ebp	; 15827
call sub_B4CF2	; 15828
add esp, byte 4	; 1582D
mov dword [esi], 1	; 15830
.4:
mov edi, 8	; 15836
xor eax, eax	; 1583B
mov dword [byte esp+08h], eax	; 1583D
mov dword [byte esp+018h], 4	; 15841
jmp short .9	; 15849
.5:
cmp dword [esi], byte 0	; 1584B
jne short .6	; 1584E
mov ebx, dword [byte edx+04h]	; 15850
push ebx	; 15853
call sub_B4CF2	; 15854
add esp, byte 4	; 15859
mov dword [esi], 1	; 1585C
.6:
mov edi, 0Eh	; 15862
mov dword [byte esp+08h], 4	; 15867
mov dword [byte esp+018h], 6	; 1586F
jmp short .9	; 15877
.7:
cmp dword [esi], byte 0	; 15879
jne short .8	; 1587C
mov ecx, dword [byte edx+08h]	; 1587E
push ecx	; 15881
call sub_B4CF2	; 15882
add esp, byte 4	; 15887
mov dword [esi], 1	; 1588A
.8:
mov edi, 0Eh	; 15890
mov dword [byte esp+08h], 6	; 15895
mov dword [byte esp+018h], 8	; 1589D
.9:
mov ebp, dword [byte esp+08h]	; 158A5
jmp near .15	; 158A9
.10:
cmp ebp, dword [byte esp+01Ch]	; 158AE
jne short .11	; 158B2
mov edx, dword [byte esp+0Ch]	; 158B4
cmp word [nosplit edx*2+lcblink], byte 0	; 158B8
je short .11	; 158C1
mov dword [byte esp+024h], 61h	; 158C3
mov dword [byte esp+020h], 7	; 158CB
jmp short .14	; 158D3
.11:
cmp ebp, dword [byte esp+014h]	; 158D5
jne short .12	; 158D9
mov edx, 21h	; 158DB
jmp short .13	; 158E0
.12:
mov edx, 67h	; 158E2
.13:
mov dword [byte esp+024h], edx	; 158E7
xor eax, eax	; 158EB
mov dword [byte esp+020h], eax	; 158ED
.14:
mov edx, ebp	; 158F1
shl edx, 2	; 158F3
add edx, dword [byte esp+010h]	; 158F6
mov esi, 0C8h	; 158FA
mov eax, dword [edx]	; 158FF
mov edx, eax	; 15901
sar edx, 1Fh	; 15903
idiv esi	; 15906
mov esi, eax	; 15908
mov eax, dword [byte esp+024h]	; 1590A
push eax	; 1590E
push byte 3	; 1590F
push esi	; 15911
push edi	; 15912
mov edx, dword [byte esp+048h]	; 15913
add edx, byte 15h	; 15917
sub edx, esi	; 1591A
push edx	; 1591C
call sub_90D20	; 1591D
add esp, byte 14h	; 15922
mov edx, dword [byte esp+024h]	; 15925
push edx	; 15929
push byte 3	; 1592A
push esi	; 1592C
push edi	; 1592D
mov edx, dword [byte esp+048h]	; 1592E
add edx, byte 20h	; 15932
mov dword [byte esp+010h], edx	; 15935
push edx	; 15939
call sub_90D20	; 1593A
add esp, byte 14h	; 1593F
mov ecx, dword [byte esp+020h]	; 15942
push ecx	; 15946
push byte 3	; 15947
mov edx, 14h	; 15949
sub edx, esi	; 1594E
mov dword [byte esp+0Ch], edx	; 15950
push edx	; 15954
push edi	; 15955
mov edx, dword [byte esp+048h]	; 15956
inc edx	; 1595A
push edx	; 1595B
call sub_90D20	; 1595C
add esp, byte 14h	; 15961
mov edx, dword [byte esp+020h]	; 15964
push edx	; 15968
push byte 3	; 15969
mov ebx, dword [byte esp+0Ch]	; 1596B
push ebx	; 1596F
push edi	; 15970
add esi, dword [byte esp+010h]	; 15971
push esi	; 15975
call sub_90D20	; 15976
add esp, byte 14h	; 1597B
inc ebp	; 1597E
add edi, byte 6	; 1597F
.15:
cmp ebp, dword [byte esp+018h]	; 15982
jl near DrawLineGroupBars.10	; 15986
add esp, byte 28h	; 1598C
pop ebp	; 1598F
pop edi	; 15990
pop esi	; 15991
ret 4	; 15992
%endif ; C
; C: src/front/scoreboard/DrawPanelLine.c (DrawPanelPenalties)
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelLine.DrawPanelPenalties.inc"
%else
DrawPanelPenalties:
push dword 2Ch	; 15995
call __CHK	; 1599A
push ebx	; 1599F
push ecx	; 159A0
push esi	; 159A1
push edi	; 159A2
push ebp	; 159A3
sub esp, byte 4	; 159A4
push eax	; 159A7
mov edi, edx	; 159A8
xor edx, edx	; 159AA
mov dword [byte esp+04h], edx	; 159AC
mov esi, 9	; 159B0
jmp near .8	; 159B5
.1:
mov eax, ebx	; 159BA
shl eax, 3	; 159BC
add eax, dword [esp]	; 159BF
lea edx, [byte edi+0Ah]	; 159C2
mov bx, word [eax]	; 159C5
test bx, bx	; 159C8
jl near .6	; 159CB
cmp bx, byte 0Ah	; 159D1
jge short .2	; 159D5
push esi	; 159D7
push edx	; 159D8
mov ebx, dword [dword_DC2B8]	; 159D9
push ebx	; 159DF
jmp short .3	; 159E0
.2:
push esi	; 159E2
push edx	; 159E3
movsx edx, bx	; 159E4
mov ebx, 0Ah	; 159E7
mov eax, edx	; 159EC
sar edx, 1Fh	; 159EE
idiv ebx	; 159F1
mov edx, dword [nosplit eax*4+penaltydigits]	; 159F3
push edx	; 159FA
.3:
call sub_B4CD8	; 159FB
add esp, byte 0Ch	; 15A00
push esi	; 15A03
lea eax, [byte edi+010h]	; 15A04
push eax	; 15A07
mov ebp, dword [byte esp+0Ch]	; 15A08
shl ebp, 3	; 15A0C
add ebp, dword [byte esp+08h]	; 15A0F
movsx edx, word [byte ebp+00h]	; 15A13
mov ebx, 0Ah	; 15A17
mov eax, edx	; 15A1C
sar edx, 1Fh	; 15A1E
idiv ebx	; 15A21
mov edx, dword [nosplit edx*4+penaltydigits]	; 15A23
push edx	; 15A2A
call sub_B4CD8	; 15A2B
add esp, byte 0Ch	; 15A30
lea eax, [byte edi+01Bh]	; 15A33
cmp word [byte ebp+02h], byte 0Ah	; 15A36
jge short .4	; 15A3B
push esi	; 15A3D
push eax	; 15A3E
mov ecx, dword [dword_DC2B8]	; 15A3F
push ecx	; 15A45
jmp short .5	; 15A46
.4:
push esi	; 15A48
push eax	; 15A49
mov edx, dword [byte ebp+00h]	; 15A4A
sar edx, 10h	; 15A4D
mov ebx, 0Ah	; 15A50
mov eax, edx	; 15A55
sar edx, 1Fh	; 15A57
idiv ebx	; 15A5A
mov ebx, dword [nosplit eax*4+penaltydigits]	; 15A5C
push ebx	; 15A63
.5:
call sub_B4CD8	; 15A64
add esp, byte 0Ch	; 15A69
push esi	; 15A6C
lea eax, [byte edi+021h]	; 15A6D
push eax	; 15A70
mov ebp, dword [byte esp+0Ch]	; 15A71
shl ebp, 3	; 15A75
add ebp, dword [byte esp+08h]	; 15A78
mov edx, dword [byte ebp+00h]	; 15A7C
sar edx, 10h	; 15A7F
mov ebx, 0Ah	; 15A82
mov eax, edx	; 15A87
sar edx, 1Fh	; 15A89
idiv ebx	; 15A8C
mov edx, dword [nosplit edx*4+penaltydigits]	; 15A8E
push edx	; 15A95
call sub_B4CD8	; 15A96
add esp, byte 0Ch	; 15A9B
push esi	; 15A9E
lea eax, [byte edi+02Ah]	; 15A9F
push eax	; 15AA2
mov edx, dword [byte ebp+02h]	; 15AA3
sar edx, 10h	; 15AA6
mov ebx, 0Ah	; 15AA9
mov eax, edx	; 15AAE
sar edx, 1Fh	; 15AB0
idiv ebx	; 15AB3
mov ebx, dword [nosplit eax*4+penaltydigits]	; 15AB5
push ebx	; 15ABC
call sub_B4CD8	; 15ABD
add esp, byte 0Ch	; 15AC2
push esi	; 15AC5
lea eax, [byte edi+030h]	; 15AC6
push eax	; 15AC9
mov edx, dword [byte ebp+02h]	; 15ACA
sar edx, 10h	; 15ACD
mov ebx, 0Ah	; 15AD0
mov eax, edx	; 15AD5
sar edx, 1Fh	; 15AD7
idiv ebx	; 15ADA
mov ecx, dword [nosplit edx*4+penaltydigits]	; 15ADC
push ecx	; 15AE3
jmp short .7	; 15AE4
.6:
push esi	; 15AE6
push edx	; 15AE7
mov ebp, dword [dword_DC2B8]	; 15AE8
push ebp	; 15AEE
call sub_B4CD8	; 15AEF
add esp, byte 0Ch	; 15AF4
push esi	; 15AF7
lea eax, [byte edi+010h]	; 15AF8
push eax	; 15AFB
mov eax, dword [dword_DC2B8]	; 15AFC
push eax	; 15B01
call sub_B4CD8	; 15B02
add esp, byte 0Ch	; 15B07
push esi	; 15B0A
lea eax, [byte edi+01Bh]	; 15B0B
push eax	; 15B0E
mov edx, dword [dword_DC2B8]	; 15B0F
push edx	; 15B15
call sub_B4CD8	; 15B16
add esp, byte 0Ch	; 15B1B
push esi	; 15B1E
lea eax, [byte edi+021h]	; 15B1F
push eax	; 15B22
mov ebx, dword [dword_DC2B8]	; 15B23
push ebx	; 15B29
call sub_B4CD8	; 15B2A
add esp, byte 0Ch	; 15B2F
push esi	; 15B32
lea eax, [byte edi+02Ah]	; 15B33
push eax	; 15B36
mov ecx, dword [dword_DC2B8]	; 15B37
push ecx	; 15B3D
call sub_B4CD8	; 15B3E
add esp, byte 0Ch	; 15B43
push esi	; 15B46
lea eax, [byte edi+030h]	; 15B47
push eax	; 15B4A
mov ebp, dword [dword_DC2B8]	; 15B4B
push ebp	; 15B51
.7:
call sub_B4CD8	; 15B52
add esp, byte 0Ch	; 15B57
inc dword [byte esp+04h]	; 15B5A
add esi, byte 5	; 15B5E
.8:
mov ebx, dword [byte esp+04h]	; 15B61
cmp ebx, byte 4	; 15B65
jl near DrawPanelPenalties.1	; 15B68
add esp, byte 8	; 15B6E
jmp near DrawPanelLine_x	; 15B71
%endif ; C
; C: src/front/scoreboard/LoadCupFinalSeries.c
%ifdef CBUILD
%include "c/front/scoreboard/LoadCupFinalSeries.inc"
%else
LoadCupFinalSeries:
push dword 28h	; 15B76
call __CHK	; 15B7B
push ebx	; 15B80
push ecx	; 15B81
push edx	; 15B82
push esi	; 15B83
push edi	; 15B84
sub esp, byte 4	; 15B85
mov eax, dword [HomeTeam-2]	; 15B88
sar eax, 10h	; 15B8D
mov edx, dword [VisTeam-2]	; 15B90
sar edx, 10h	; 15B96
mov eax, dword [nosplit eax*4+teamdivflags]	; 15B99
or eax, dword [nosplit edx*4+teamdivflags]	; 15BA0
test al, 3	; 15BA7
je near .2	; 15BA9
test al, 0Ch	; 15BAF
je short .2	; 15BB1
push byte 20h	; 15BB3
push byte 2Ah	; 15BB5
push str_Stanley	; 15BB7
call sub_8CCA8	; 15BBC
add esp, byte 0Ch	; 15BC1
mov dword [cupseries], eax	; 15BC4
mov eax, esp	; 15BC9
call LoadScheduleDB	; 15BCB
mov eax, dword [esp]	; 15BD0
add eax, byte 2	; 15BD3
mov dword [esp], eax	; 15BD6
xor edx, edx	; 15BD9
.1:
lea esi, [dword edx+04A6h]	; 15BDB
mov eax, esi	; 15BE1
shl eax, 2	; 15BE3
sub eax, esi	; 15BE6
add eax, eax	; 15BE8
mov esi, dword [esp]	; 15BEA
add esi, eax	; 15BED
mov eax, edx	; 15BEF
shl eax, 2	; 15BF1
sub eax, edx	; 15BF4
add eax, eax	; 15BF6
mov edi, dword [cupseries]	; 15BF8
add edi, eax	; 15BFE
movsd	; 15C00
movsw	; 15C01
inc edx	; 15C03
cmp edx, byte 7	; 15C04
jl short LoadCupFinalSeries.1	; 15C07
mov eax, dword [esp]	; 15C09
sub eax, byte 2	; 15C0C
mov dword [esp], eax	; 15C0F
je short .x	; 15C12
push eax	; 15C14
call FreeMemBlock	; 15C15
add esp, byte 4	; 15C1A
jmp short .x	; 15C1D
.2:
xor ecx, ecx	; 15C1F
mov dword [cupseries], ecx	; 15C21
.x:
add esp, byte 4	; 15C27
pop edi	; 15C2A
pop esi	; 15C2B
pop edx	; 15C2C
pop ecx	; 15C2D
pop ebx	; 15C2E
ret	; 15C2F
%endif ; C
; C: src/front/scoreboard/IsCupClinched.c
%ifdef CBUILD
%include "c/front/scoreboard/IsCupClinched.inc"
%else
IsCupClinched:
push dword 14h	; 15C30
call __CHK	; 15C35
push ebx	; 15C3A
push ecx	; 15C3B
push eax	; 15C3C
push edx	; 15C3D
cmp dword [cupseries], byte 0	; 15C3E
jne short .2	; 15C45
.1:
xor eax, eax	; 15C47
jmp near .x	; 15C49
.2:
xor ebx, ebx	; 15C4E
jmp short .4	; 15C50
.3:
inc ebx	; 15C52
.4:
mov eax, ebx	; 15C53
shl eax, 2	; 15C55
sub eax, ebx	; 15C58
lea edx, [eax+eax]	; 15C5A
mov eax, dword [cupseries]	; 15C5D
add eax, edx	; 15C62
cmp byte [byte eax+04h], 0FFh	; 15C64
jne short IsCupClinched.3	; 15C68
mov cl, byte [byte esp+04h]	; 15C6A
mov byte [byte eax+04h], cl	; 15C6E
mov eax, dword [cupseries]	; 15C71
add edx, eax	; 15C76
mov al, byte [esp]	; 15C78
mov byte [byte edx+05h], al	; 15C7B
cmp dword [gamemode], byte 1	; 15C7E
jne short .5	; 15C85
mov edx, dword [gameopts]	; 15C87
shl edx, 11h	; 15C8D
shr edx, 1Dh	; 15C90
jmp short .6	; 15C93
.5:
mov eax, dword [cupseries]	; 15C95
call SeriesLength	; 15C9A
mov edx, eax	; 15C9F
.6:
mov eax, dword [cupseries]	; 15CA1
call CupSeriesWinner	; 15CA6
mov edx, eax	; 15CAB
mov eax, ebx	; 15CAD
shl eax, 2	; 15CAF
sub eax, ebx	; 15CB2
lea ebx, [eax+eax]	; 15CB4
mov eax, dword [cupseries]	; 15CB7
mov byte [byte ebx+eax+05h], 0FFh	; 15CBC
mov cl, byte [byte ebx+eax+05h]	; 15CC1
mov eax, dword [cupseries]	; 15CC5
mov byte [byte ebx+eax+04h], cl	; 15CCA
test edx, edx	; 15CCE
jl near IsCupClinched.1	; 15CD0
mov eax, 1	; 15CD6
.x:
add esp, byte 8	; 15CDB
pop ecx	; 15CDE
pop ebx	; 15CDF
ret	; 15CE0
%endif ; C
; C: src/front/scoreboard/CupSeriesWinner.c
%ifdef CBUILD
%include "c/front/scoreboard/CupSeriesWinner.inc"
%else
CupSeriesWinner:
push dword 24h	; 15CE1
call __CHK	; 15CE6
push ebx	; 15CEB
push ecx	; 15CEC
push esi	; 15CED
push edi	; 15CEE
push ebp	; 15CEF
sub esp, byte 0Ch	; 15CF0
mov ebp, edx	; 15CF3
shr ebp, 1	; 15CF5
inc ebp	; 15CF7
xor edx, edx	; 15CF8
mov dl, byte [byte eax+02h]	; 15CFA
mov dword [byte esp+08h], edx	; 15CFD
xor edx, edx	; 15D01
mov dl, byte [byte eax+03h]	; 15D03
mov dword [byte esp+04h], edx	; 15D06
xor edx, edx	; 15D0A
xor ebx, ebx	; 15D0C
jmp short .7	; 15D0E
.1:
cmp byte [byte eax+04h], 0FFh	; 15D10
jne short .2	; 15D14
mov eax, 0FFFFFFFFh	; 15D16
jmp short .x	; 15D1B
.2:
movzx esi, byte [byte eax+02h]	; 15D1D
mov dword [esp], esi	; 15D21
lea edi, [byte ebx+01h]	; 15D24
lea esi, [byte edx+01h]	; 15D27
mov ecx, dword [esp]	; 15D2A
cmp ecx, dword [byte esp+08h]	; 15D2D
jne short .4	; 15D31
mov cl, byte [byte eax+04h]	; 15D33
cmp cl, byte [byte eax+05h]	; 15D36
ja short .5	; 15D39
.3:
mov edx, esi	; 15D3B
jmp short .6	; 15D3D
.4:
mov cl, byte [byte eax+04h]	; 15D3F
cmp cl, byte [byte eax+05h]	; 15D42
ja short CupSeriesWinner.3	; 15D45
.5:
mov ebx, edi	; 15D47
.6:
add eax, byte 6	; 15D49
.7:
cmp ebx, ebp	; 15D4C
jae short .8	; 15D4E
cmp edx, ebp	; 15D50
jb short CupSeriesWinner.1	; 15D52
.8:
cmp ebx, edx	; 15D54
jle short .9	; 15D56
mov eax, dword [byte esp+08h]	; 15D58
jmp short .x	; 15D5C
.9:
mov eax, dword [byte esp+04h]	; 15D5E
.x:
add esp, byte 0Ch	; 15D62
pop ebp	; 15D65
pop edi	; 15D66
pop esi	; 15D67
pop ecx	; 15D68
pop ebx	; 15D69
ret	; 15D6A
%endif ; C
