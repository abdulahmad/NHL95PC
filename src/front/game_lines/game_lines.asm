; The in-game line editor: jerseys, using or saving a set of lines, and whether the roster is complete.
; One module, with its own copies of the line editor strings.
bits 32
%include "hockey.inc"
section s_767D0 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, asc_C3164, blitclipbottom, blitclipleft, blitclipright, blitcliptop, boxfillcolor
extern boxlitecolor, boxshadecolor, byte_D11BC, byte_D12DE, byte_D1333, byte_D1334, byte_D1335, byte_D1336
extern byte_ECDF4, byte_ED0F7, byte_ED0F8, byte_ED0F9, byte_ED0FA, CareerDbPtr, CareerDbPtr2, cddriveptr
extern ClearInputQueue, cont2team, crestnames, curperiod, dlgbevelcol1, dlgbevelcol2, dlgedgecol1, dlgedgecol2
extern dlgedgecol3, dlgfillcol, dlgtextbg, dlgtextfg, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel
extern dword_D1398, dword_D139C, dword_D13C8, dword_D13CC, dword_D1418, dword_D141C, dword_D1458, dword_D145C
extern dword_D1468, dword_D146C, dword_DBC7C, dword_DBCE0, dword_DC734, dword_DC738, editptrspr, exit_
extern fadeend, fadeend2, FadeOutPalCycle, fadepal, fadepal2, FadePalStep, fadestart, fadestart2
extern fadestep, fadestep2, FatalError, fileoncd, FitPlayerName, fputchar, FreeMemBlock, fullscrbmp
extern gameopts, GetInputEvent, gmroster, gmrosterjersey, gmrosterslot, hmroster, hmrosterjersey, hmteamrec
extern HomeTeam, j___close_, j___delay_, jerseydigits, jerseyremap, KeyDbPtr, leaguedbfmt, leaguedbfmt2
extern lineedpanel, lineslotx, linesloty, lseek_, mainfont, MakePath, memcpy_, menuact_dbdress
extern menuact_dbscratch, menuact_gamedress, menuact_gamescratch, menuact_savedeflines, menuact_savedeflines2, menuact_savelines, menuact_uselines, menuact_uselines2
extern MenuHitTest, MessageBox, MouseSetPos, msglines, MusicChanReset2, musichandle, musicon, musicslot
extern open_, palfadedin, perror_, pointerspr, PrintCenteredText, PrintFmt1, PrintFmt2, PrintLineEdStatus
extern PrintShadowText, ptrupdatefn, qsort_, read_, rostergstat, rosterjersey, rosterlist, rosterpstat
extern rosterslot, rosterstat, rosterteam, rosterteamrec, RunMenu, SetDrawBitmap, SetTextColors, ShowLoadingScreen
extern songdata, SpeechBusy, sprintf_, statscategory, statsgoaliebuf, statsgoalieorder, statsgoalieplr, statsplayerbuf
extern statsplayoffs, statsredrawcb, statsskaterbuf, statsskaterorder, statsskaterplr, statsteambuf, str_A4, str_Attackers
extern str_Bkgd10, str_Bkgd2, str_C2dS2, str_C2dS3, str_C5, str_Defense3, str_Dress2, str_Embpal4
extern str_Embpal5, str_EmbS, str_ErrA1, str_ErrA2, str_ErrA3, str_ErrA4, str_ErrA5, str_ErrA6
extern str_ErrA7, str_ErrA8, str_ErrB2, str_ErrB2Perror, str_ErrB3, str_ErrB4, str_ErrB5, str_ErrB6
extern str_ErrB7, str_extBIN, str_Extra, str_fmt2d, str_fmt3d, str_fmt4d, str_fmtEmb, str_fmtMinSec
extern str_fmtTenths, str_Forward, str_G4, str_GA3, str_GAA4, str_GoalieW2, str_Goaltenders, str_GP8
extern str_Gstat3, str_Gstat4, str_HOMEPALS3, str_Key, str_Keys3, str_Keys4, str_Kill1, str_Kill2
extern str_L8, str_Lelogo, str_Lelogo2, str_Line1, str_Line2, str_Line3, str_Line4, str_Lineditp2
extern str_Lineditp3, str_Menubuff8, str_Menubuff9, str_Min4, str_Name2, str_No2, str_Pal25, str_Pal26
extern str_Pal27, str_Pal28, str_PCT2, str_Penalty, str_PIM4, str_Play1, str_Play2, str_Player2
extern str_Pntr3, str_Pntr4, str_Pointer13, str_Pointer14, str_Pos2, str_Power, str_Pstat3, str_Pstat4
extern str_PT2, str_RosterIncomplete2, str_S2dSS, str_S2dSS2, str_S6, str_S7, str_SA3, str_Scratch2
extern str_Shots4, str_Shrt2, str_Shrt3, str_SRoster, str_T6, str_Teams2, str_Tstat2, str_W6
extern strcmp_, stub_8C218, sub_8CCA8, sub_8D2F0, sub_8E83C, sub_8E8A0, sub_8E9C0, sub_8E9E8
extern sub_8EA00, sub_8EA18, sub_8FC8A, sub_8FCDF, sub_8FFB0, sub_903F0, sub_9061C, sub_90D20
extern sub_9121C, sub_91370, sub_913B4, sub_91400, sub_91964, sub_91FE0, sub_931FC, sub_B2DCA
extern sub_B2E1B, sub_B30B4, sub_B392C, sub_B4B58, sub_B4B88, sub_B4BA8, sub_B4BC4, sub_B4C84
extern sub_B4DD4, sub_B4FAC, sub_B5DB0, TeamRosterScreen, unk_C311D, unk_C3283, unk_CF48F, unk_D075E
extern unk_DBD1C, unknown_libname_1, vgapage, VisTeam, WaitKey, write_
global GameLineEditor, GameRosterCmp, GameLineEditorLoop, LineEdHitTest, LoadGameRoster, DrawGameLineJerseys_jt, DrawGameLineJerseys, DrawGameLineJerseys_st1
global DrawGameLineJerseys_st2, DrawGameLineJerseys_st0, DrawGameLineJerseys_join, DrawLineEditorScreen, StubRet4a, LoadJerseyColours, DrawDlgFrame, StubRet4b
global CheckGameRosterComplete, PruneGameLines, MenuUseTheseLines, MenuLineEdCancel, MenuUseOriginalLines, MenuUseOriginalLines_redraw, MenuUseOriginalLines_ret0, MenuUseOriginalLines_ret
global MenuUseDefaultLines, MenuSaveDefaultLines, MenuSaveDefaultLines_ret, MenuSaveDefaultLines_pop, MenuSaveTheseLines, MenuSaveTheseLines_x, MenuGameShowPlayerStats, MenuReturnToLineEditor
global GameScratchPlayer, GameDressPlayer, BlitJerseyDigit, MakeJerseyShape
; C: src/front/game_lines/GameLineEditor.c
%ifdef CBUILD
%include "c/front/game_lines/GameLineEditor.inc"
%else
GameLineEditor:
push dword 68h	; 767D0
call __CHK	; 767D5
push esi	; 767DA
push edi	; 767DB
push ebp	; 767DC
sub esp, byte 48h	; 767DD
mov esi, eax	; 767E0
mov dword [byte esp+020h], edx	; 767E2
mov dword [byte esp+044h], ebx	; 767E6
mov dword [byte esp+040h], ecx	; 767EA
push byte 20h	; 767EE
push dword 300h	; 767F0
push str_Pal27	; 767F5
call sub_8CCA8	; 767FA
mov edi, eax	; 767FF
add esp, byte 0Ch	; 76801
push eax	; 76804
push dword 100h	; 76805
push byte 0	; 7680A
call sub_8FFB0	; 7680C
add esp, byte 0Ch	; 76811
mov ebx, 10h	; 76814
mov edx, edi	; 76819
mov eax, 1	; 7681B
call FadePalStep	; 76820
push edi	; 76825
call FreeMemBlock	; 76826
add esp, byte 4	; 7682B
cmp byte [musicon], 0	; 7682E
je short .2	; 76835
cmp dword [songdata], byte 0	; 76837
je short .2	; 7683E
mov eax, dword [musichandle]	; 76840
mov ebx, 32h	; 76845
mov edx, 3	; 7684A
call sub_8FCDF	; 7684F
.1:
mov eax, dword [musicslot-3]	; 76854
sar eax, 18h	; 76859
mov edx, 3	; 7685C
call sub_8FC8A	; 76861
test eax, eax	; 76866
je short GameLineEditor.1	; 76868
mov ebx, dword [songdata]	; 7686A
push ebx	; 76870
call sub_8D2F0	; 76871
add esp, byte 4	; 76876
xor ecx, ecx	; 76879
mov dword [songdata], ecx	; 7687B
.2:
cmp byte [musicon], 0	; 76881
je short .4	; 76888
test byte [gameopts+1], 1	; 7688A
je short .4	; 76891
call MusicChanReset2	; 76893
.3:
call SpeechBusy	; 76898
test eax, eax	; 7689D
jne short GameLineEditor.3	; 7689F
.4:
call ShowLoadingScreen	; 768A1
mov eax, dword [dlgfillcol]	; 768A6
mov dword [byte esp+010h], eax	; 768AB
mov eax, dword [dlgedgecol1]	; 768AF
mov dword [byte esp+038h], eax	; 768B4
mov eax, dword [dlgedgecol2]	; 768B8
mov dword [byte esp+03Ch], eax	; 768BD
mov eax, dword [dlgedgecol3]	; 768C1
mov dword [byte esp+028h], eax	; 768C6
mov eax, dword [dlgbevelcol1]	; 768CA
mov dword [byte esp+024h], eax	; 768CF
mov eax, dword [dlgbevelcol2]	; 768D3
mov dword [byte esp+01Ch], eax	; 768D8
mov edi, 0C1h	; 768DC
mov dword [dlgfillcol], edi	; 768E1
mov ebp, 0C0h	; 768E7
mov dword [dlgedgecol1], ebp	; 768EC
mov dword [dlgedgecol2], edi	; 768F2
mov edx, 0C2h	; 768F8
mov dword [dlgedgecol3], edx	; 768FD
mov dword [dlgbevelcol1], 0C3h	; 76903
mov dword [dlgbevelcol2], edx	; 7690D
mov eax, dword [boxfillcolor]	; 76913
mov dword [byte esp+018h], eax	; 76918
mov eax, dword [boxlitecolor]	; 7691C
mov dword [byte esp+014h], eax	; 76921
mov eax, dword [boxshadecolor]	; 76925
mov dword [byte esp+034h], eax	; 7692A
mov eax, dword [dlgtextfg]	; 7692E
mov dword [byte esp+030h], eax	; 76933
mov eax, dword [dlgtextbg]	; 76937
mov dword [byte esp+02Ch], eax	; 7693C
mov dword [boxfillcolor], edi	; 76940
mov dword [boxlitecolor], ebp	; 76946
mov dword [boxshadecolor], edi	; 7694C
mov dword [dlgtextfg], ebp	; 76952
mov dword [dlgtextbg], edi	; 76958
call sub_B4BA8	; 7695E
push dword 1E0h	; 76963
push byte 0	; 76968
push dword 280h	; 7696A
push byte 0	; 7696F
call sub_B4BC4	; 76971
add esp, byte 10h	; 76976
push dword 0C8h	; 76979
push dword 140h	; 7697E
call MouseSetPos	; 76983
add esp, byte 8	; 76988
xor ecx, ecx	; 7698B
mov ebx, str_Lineditp3	; 7698D
cmp byte [fileoncd+0E8h], 1	; 76992
jne short .5	; 76999
mov edx, dword [cddriveptr]	; 7699B
jmp short .6	; 769A1
.5:
xor edx, edx	; 769A3
.6:
mov eax, esp	; 769A5
call MakePath	; 769A7
push byte 0	; 769AC
lea eax, [byte esp+04h]	; 769AE
push eax	; 769B2
call sub_8E83C	; 769B3
mov ebp, eax	; 769B8
add esp, byte 8	; 769BA
push str_Shrt3	; 769BD
push eax	; 769C2
call sub_B30B4	; 769C3
mov edi, eax	; 769C8
add esp, byte 8	; 769CA
call FadeOutPalCycle	; 769CD
mov ecx, dword [byte esp+040h]	; 769D2
push ecx	; 769D6
mov ecx, dword [byte esp+048h]	; 769D7
xor ebx, ebx	; 769DB
mov edx, edi	; 769DD
mov eax, esi	; 769DF
call DrawLineEditorScreen	; 769E1
mov eax, esi	; 769E6
call LoadGameRoster	; 769E8
mov ecx, GameRosterCmp	; 769ED
mov ebx, 16h	; 769F2
mov edx, 1Ch	; 769F7
mov eax, gmroster	; 769FC
call qsort_	; 76A01
push ebp	; 76A06
mov eax, dword [byte esp+044h]	; 76A07
push eax	; 76A0B
mov edx, dword [byte esp+04Ch]	; 76A0C
push edx	; 76A10
xor ecx, ecx	; 76A11
mov ebx, esi	; 76A13
mov edx, edi	; 76A15
mov eax, dword [byte esp+02Ch]	; 76A17
call GameLineEditorLoop	; 76A1B
push ebp	; 76A20
call FreeMemBlock	; 76A21
add esp, byte 4	; 76A26
mov eax, dword [byte esp+010h]	; 76A29
mov dword [dlgfillcol], eax	; 76A2D
mov eax, dword [byte esp+038h]	; 76A32
mov dword [dlgedgecol1], eax	; 76A36
mov eax, dword [byte esp+03Ch]	; 76A3B
mov dword [dlgedgecol2], eax	; 76A3F
mov eax, dword [byte esp+028h]	; 76A44
mov dword [dlgedgecol3], eax	; 76A48
mov eax, dword [byte esp+024h]	; 76A4D
mov dword [dlgbevelcol1], eax	; 76A51
mov eax, dword [byte esp+01Ch]	; 76A56
mov dword [dlgbevelcol2], eax	; 76A5A
mov eax, dword [byte esp+018h]	; 76A5F
mov dword [boxfillcolor], eax	; 76A63
mov eax, dword [byte esp+014h]	; 76A68
mov dword [boxlitecolor], eax	; 76A6C
mov eax, dword [byte esp+034h]	; 76A71
mov dword [boxshadecolor], eax	; 76A75
mov eax, dword [byte esp+030h]	; 76A7A
mov dword [dlgtextfg], eax	; 76A7E
mov eax, dword [byte esp+02Ch]	; 76A83
mov dword [dlgtextbg], eax	; 76A87
add esp, byte 48h	; 76A8C
pop ebp	; 76A8F
pop edi	; 76A90
pop esi	; 76A91
ret	; 76A92
%endif ; C
; C: src/front/game_lines/GameRosterCmp.c
%ifdef CBUILD
%include "c/front/game_lines/GameRosterCmp.inc"
%else
GameRosterCmp:
push dword 8	; 76A93
call __CHK	; 76A98
push ebx	; 76A9D
mov bl, byte [eax]	; 76A9E
mov bh, byte [edx]	; 76AA0
cmp bl, bh	; 76AA2
jne short .2	; 76AA4
cmp byte [eax], 0	; 76AA6
jne short .1	; 76AA9
xor eax, eax	; 76AAB
pop ebx	; 76AAD
ret	; 76AAE
.1:
add edx, byte 6	; 76AAF
add eax, byte 6	; 76AB2
call strcmp_	; 76AB5
pop ebx	; 76ABA
ret	; 76ABB
.2:
test bl, bl	; 76ABC
je short .5	; 76ABE
test bh, bh	; 76AC0
jne short .4	; 76AC2
.3:
mov eax, 0FFFFFFFFh	; 76AC4
pop ebx	; 76AC9
ret	; 76ACA
.4:
cmp bl, 4Ch	; 76ACB
je short GameRosterCmp.3	; 76ACE
cmp bh, 4Ch	; 76AD0
je short .5	; 76AD3
cmp bl, 43h	; 76AD5
je short GameRosterCmp.3	; 76AD8
cmp bh, 43h	; 76ADA
je short .5	; 76ADD
cmp bl, 52h	; 76ADF
je short GameRosterCmp.3	; 76AE2
cmp bh, 52h	; 76AE4
je short .5	; 76AE7
cmp bl, 44h	; 76AE9
je short GameRosterCmp.3	; 76AEC
.5:
mov eax, 1	; 76AEE
pop ebx	; 76AF3
ret	; 76AF4
%endif ; C
GameLineEditorLoop:
push dword 148h	; 76AF5
call __CHK	; 76AFA
push esi	; 76AFF
push edi	; 76B00
push ebp	; 76B01
mov ebp, esp	; 76B02
sub esp, 118h	; 76B04
push eax	; 76B0A
push edx	; 76B0B
sub ebp, byte 76h	; 76B0C
mov byte [byte ebp+072h], bl	; 76B0F
xor edx, edx	; 76B12
mov dword [byte ebp+066h], edx	; 76B14
mov ebx, 0FFFFFFFFh	; 76B17
mov dword [byte ebp+022h], ebx	; 76B1C
mov dword [byte ebp+01Eh], ebx	; 76B1F
mov dword [byte ebp+04Eh], 0C0h	; 76B22
mov dword [byte ebp+056h], 0C1h	; 76B29
mov dword [byte ebp+052h], 0C2h	; 76B30
push str_Pntr4	; 76B37
mov edx, dword [dword ebp+08Eh]	; 76B3C
push edx	; 76B42
call sub_B30B4	; 76B43
mov dword [byte ebp+03Ah], eax	; 76B48
add esp, byte 8	; 76B4B
mov eax, dword [dword ebp+086h]	; 76B4E
mov dword [byte ebp+0Eh], eax	; 76B54
mov eax, dword [dword ebp+08Ah]	; 76B57
mov dword [byte ebp-012h], eax	; 76B5D
xor ebx, ebx	; 76B60
mov dword [byte ebp+01Ah], ebx	; 76B62
mov dword [byte ebp+016h], ebx	; 76B65
mov dword [byte ebp+012h], ebx	; 76B68
mov dword [byte ebp-016h], ebx	; 76B6B
mov dword [byte ebp-01Ah], ebx	; 76B6E
mov dword [byte ebp-01Eh], ebx	; 76B71
mov dword [byte ebp-022h], ebx	; 76B74
mov dword [byte ebp+0Ah], ebx	; 76B77
mov dword [byte ebp+06h], ebx	; 76B7A
mov dword [byte ebp+02h], ebx	; 76B7D
mov dword [byte ebp-02h], ebx	; 76B80
mov dword [byte ebp-06Eh], ebx	; 76B83
mov dword [byte ebp-072h], ebx	; 76B86
mov dword [menuact_gamescratch], ebx	; 76B89
mov dword [menuact_gamedress], ebx	; 76B8F
mov edx, dword [byte ebp+03Ah]	; 76B95
mov edx, dword [byte edx+02h]	; 76B98
sar edx, 10h	; 76B9B
mov eax, dword [byte ebp+03Ah]	; 76B9E
mov eax, dword [byte eax+04h]	; 76BA1
sar eax, 10h	; 76BA4
inc eax	; 76BA7
inc edx	; 76BA8
imul eax, edx	; 76BA9
add eax, byte 11h	; 76BAC
push byte 20h	; 76BAF
push eax	; 76BB1
push str_Pointer14	; 76BB2
call sub_8CCA8	; 76BB7
add esp, byte 0Ch	; 76BBC
mov dword [byte ebp+05Ah], eax	; 76BBF
mov edi, eax	; 76BC2
mov esi, dword [byte ebp+03Ah]	; 76BC4
movsd	; 76BC7
movsd	; 76BC8
movsd	; 76BC9
movsd	; 76BCA
movsb	; 76BCB
mov edx, dword [byte ebp+03Ah]	; 76BCC
mov dx, word [byte edx+04h]	; 76BCF
inc edx	; 76BD3
mov word [byte eax+04h], dx	; 76BD4
mov edx, dword [byte ebp+03Ah]	; 76BD8
mov dx, word [byte edx+06h]	; 76BDB
inc edx	; 76BDF
mov word [byte eax+06h], dx	; 76BE0
mov edx, dword [byte ebp+0Eh]	; 76BE4
mov edx, dword [edx]	; 76BE7
mov eax, dword [byte ebp+0Eh]	; 76BE9
mov edi, dword [byte eax+08h]	; 76BEC
add edx, edi	; 76BEF
mov eax, edx	; 76BF1
sar edx, 1Fh	; 76BF3
LD sub, eax, edx	; 76BF6
sar eax, 1	; 76BF8
mov esi, eax	; 76BFA
mov dword [byte ebp+032h], eax	; 76BFC
mov edx, dword [byte ebp+0Eh]	; 76BFF
mov edx, dword [byte edx+04h]	; 76C02
mov eax, dword [byte ebp+0Eh]	; 76C05
mov ebx, dword [byte eax+0Ch]	; 76C08
add edx, ebx	; 76C0B
mov eax, edx	; 76C0D
sar edx, 1Fh	; 76C0F
LD sub, eax, edx	; 76C12
sar eax, 1	; 76C14
mov edi, eax	; 76C16
mov dword [byte ebp+02Eh], eax	; 76C18
mov dword [menuact_savelines], MenuSaveTheseLines	; 76C1B
mov eax, MenuUseTheseLines	; 76C25
mov dword [menuact_uselines], eax	; 76C2A
mov dword [menuact_uselines2], eax	; 76C2F
mov ebx, MenuSaveDefaultLines	; 76C34
mov dword [menuact_savedeflines], ebx	; 76C39
mov dword [menuact_savedeflines2], ebx	; 76C3F
xor eax, eax	; 76C45
mov dword [byte ebp+036h], eax	; 76C47
.1:
mov eax, dword [dword ebp-0A6h]	; 76C4A
add eax, dword [byte ebp+036h]	; 76C50
cmp byte [eax], 64h	; 76C53
jne short .2	; 76C56
xor eax, eax	; 76C58
mov dword [menuact_savelines], eax	; 76C5A
mov dword [menuact_uselines], eax	; 76C5F
mov dword [menuact_uselines2], eax	; 76C64
mov dword [menuact_savedeflines], eax	; 76C69
mov dword [menuact_savedeflines2], eax	; 76C6E
jmp short .3	; 76C73
.2:
mov ebx, dword [byte ebp+036h]	; 76C75
inc ebx	; 76C78
mov dword [byte ebp+036h], ebx	; 76C79
cmp ebx, byte 28h	; 76C7C
jl short GameLineEditorLoop.1	; 76C7F
.3:
xor edx, edx	; 76C81
mov dword [byte ebp+036h], edx	; 76C83
.4:
mov eax, dword [dword ebp-0A6h]	; 76C86
mov ebx, dword [byte ebp+036h]	; 76C8C
add eax, ebx	; 76C8F
mov dh, byte [eax]	; 76C91
cmp dh, 64h	; 76C93
je short .5	; 76C96
xor edx, edx	; 76C98
mov dl, byte [eax]	; 76C9A
mov ebx, edx	; 76C9C
shl ebx, 2	; 76C9E
add ebx, edx	; 76CA1
shl ebx, 3	; 76CA3
sub ebx, edx	; 76CA6
xor edx, edx	; 76CA8
mov dl, byte [byte ebp+072h]	; 76CAA
mov eax, edx	; 76CAD
shl eax, 4	; 76CAF
add eax, edx	; 76CB2
shl eax, 4	; 76CB4
add eax, edx	; 76CB7
mov dl, byte [dword ebx+eax*4+hmrosterjersey]	; 76CB9
mov eax, dword [byte ebp+036h]	; 76CC0
mov byte [dword eax+ebp-0A2h], dl	; 76CC3
jmp short .6	; 76CCA
.5:
mov byte [dword ebx+ebp-0A2h], dh	; 76CCC
.6:
mov ecx, dword [byte ebp+036h]	; 76CD3
inc ecx	; 76CD6
mov dword [byte ebp+036h], ecx	; 76CD7
cmp ecx, byte 28h	; 76CDA
jl short GameLineEditorLoop.4	; 76CDD
cmp dword [curperiod], byte 0	; 76CDF
jge short .9	; 76CE6
xor ebx, ebx	; 76CE8
mov dword [byte ebp+036h], ebx	; 76CEA
.7:
mov eax, dword [dword ebp-0A6h]	; 76CED
add eax, dword [byte ebp+036h]	; 76CF3
mov bh, byte [byte eax+028h]	; 76CF6
cmp bh, 64h	; 76CF9
je short .8	; 76CFC
xor edx, edx	; 76CFE
mov dl, bh	; 76D00
mov ebx, edx	; 76D02
shl ebx, 2	; 76D04
add ebx, edx	; 76D07
shl ebx, 3	; 76D09
sub ebx, edx	; 76D0C
xor edx, edx	; 76D0E
mov dl, byte [byte ebp+072h]	; 76D10
mov eax, edx	; 76D13
shl eax, 4	; 76D15
add eax, edx	; 76D18
shl eax, 4	; 76D1A
add eax, edx	; 76D1D
shl eax, 2	; 76D1F
add eax, ebx	; 76D22
cmp byte [dword eax+hmroster], 3	; 76D24
jne short .8	; 76D2B
mov byte [dword eax+hmroster], 2	; 76D2D
.8:
mov eax, dword [byte ebp+036h]	; 76D34
inc eax	; 76D37
mov dword [byte ebp+036h], eax	; 76D38
cmp eax, byte 8	; 76D3B
jl short GameLineEditorLoop.7	; 76D3E
.9:
push byte 20h	; 76D40
push dword 300h	; 76D42
push str_Pal27	; 76D47
call sub_8CCA8	; 76D4C
add esp, byte 0Ch	; 76D51
mov dword [byte ebp+046h], eax	; 76D54
xor ecx, ecx	; 76D57
mov ebx, str_Embpal5	; 76D59
cmp byte [fileoncd+08Eh], 1	; 76D5E
jne short .10	; 76D65
mov edx, dword [cddriveptr]	; 76D67
jmp short .11	; 76D6D
.10:
xor edx, edx	; 76D6F
.11:
lea eax, [byte ebp-032h]	; 76D71
call MakePath	; 76D74
push byte 0	; 76D79
lea eax, [byte ebp-032h]	; 76D7B
push eax	; 76D7E
call sub_8E83C	; 76D7F
mov dword [byte ebp+03Ah], eax	; 76D84
add esp, byte 8	; 76D87
push str_Pal28	; 76D8A
push eax	; 76D8F
call sub_B30B4	; 76D90
add esp, byte 8	; 76D95
lea edx, [byte eax+010h]	; 76D98
mov ebx, 300h	; 76D9B
mov eax, dword [byte ebp+046h]	; 76DA0
call memcpy_	; 76DA3
mov ecx, dword [byte ebp+03Ah]	; 76DA8
push ecx	; 76DAB
call FreeMemBlock	; 76DAC
add esp, byte 4	; 76DB1
xor eax, eax	; 76DB4
mov al, byte [byte ebp+072h]	; 76DB6
mov ebx, dword [byte ebp+046h]	; 76DB9
mov edx, dword [dword ebp+08Eh]	; 76DBC
call LoadJerseyColours	; 76DC2
cmp byte [byte ebp+072h], 0	; 76DC7
je short .12	; 76DCB
mov ax, word [VisTeam]	; 76DCD
jmp short .13	; 76DD3
.12:
mov ax, word [HomeTeam]	; 76DD5
.13:
cwde	; 76DDB
mov al, byte [nosplit eax*4+byte_D11BC]	; 76DDC
mov byte [byte ebp+06Eh], al	; 76DE3
xor eax, eax	; 76DE6
mov al, byte [byte ebp+06Eh]	; 76DE8
mov al, byte [dword eax+jerseyremap]	; 76DEB
mov byte [byte ebp+06Eh], al	; 76DF1
mov al, byte [byte_D12DE]	; 76DF4
mov byte [byte ebp+06Ah], al	; 76DF9
xor ebx, ebx	; 76DFC
mov bl, byte [byte ebp+072h]	; 76DFE
mov edx, dword [dword ebp-0AAh]	; 76E01
lea eax, [dword ebp-0A2h]	; 76E07
call DrawGameLineJerseys	; 76E0D
xor ecx, ecx	; 76E12
mov ebx, str_Lelogo2	; 76E14
cmp byte [fileoncd+021Bh], 1	; 76E19
jne short .14	; 76E20
mov edx, dword [cddriveptr]	; 76E22
jmp short .15	; 76E28
.14:
xor edx, edx	; 76E2A
.15:
lea eax, [byte ebp-032h]	; 76E2C
call MakePath	; 76E2F
push byte 0	; 76E34
lea eax, [byte ebp-032h]	; 76E36
push eax	; 76E39
call sub_8E83C	; 76E3A
mov dword [byte ebp+03Ah], eax	; 76E3F
add esp, byte 8	; 76E42
push str_Pal28	; 76E45
push eax	; 76E4A
call sub_B30B4	; 76E4B
add esp, byte 8	; 76E50
lea edx, [dword eax+026Eh]	; 76E53
mov eax, dword [byte ebp+046h]	; 76E59
add eax, 25Eh	; 76E5C
mov ebx, 93h	; 76E61
call memcpy_	; 76E66
mov edx, dword [byte ebp+03Ah]	; 76E6B
push edx	; 76E6E
call FreeMemBlock	; 76E6F
add esp, byte 4	; 76E74
mov ebx, 10h	; 76E77
mov edx, dword [byte ebp+046h]	; 76E7C
xor eax, eax	; 76E7F
call FadePalStep	; 76E81
mov ebx, dword [byte ebp+046h]	; 76E86
push ebx	; 76E89
call FreeMemBlock	; 76E8A
add esp, byte 4	; 76E8F
cmp edi, byte 20h	; 76E92
jge short .16	; 76E95
xor eax, eax	; 76E97
jmp short .17	; 76E99
.16:
lea eax, [byte edi-020h]	; 76E9B
.17:
push eax	; 76E9E
cmp esi, byte 1Ch	; 76E9F
jge short .18	; 76EA2
xor eax, eax	; 76EA4
jmp short .19	; 76EA6
.18:
lea eax, [byte esi-01Ch]	; 76EA8
.19:
push eax	; 76EAB
mov ecx, dword [byte ebp+05Ah]	; 76EAC
push ecx	; 76EAF
call sub_91400	; 76EB0
add esp, byte 0Ch	; 76EB5
push edi	; 76EB8
lea eax, [byte esi-03h]	; 76EB9
push eax	; 76EBC
mov eax, dword [pointerspr]	; 76EBD
push eax	; 76EC2
call sub_91FE0	; 76EC3
add esp, byte 0Ch	; 76EC8
push dword 1E0h	; 76ECB
push dword 280h	; 76ED0
push byte 0	; 76ED5
push byte 0	; 76ED7
call sub_B2E1B	; 76ED9
add esp, byte 10h	; 76EDE
push edi	; 76EE1
push esi	; 76EE2
call MouseSetPos	; 76EE3
add esp, byte 8	; 76EE8
lea eax, [byte ebp+036h]	; 76EEB
push eax	; 76EEE
push eax	; 76EEF
push eax	; 76EF0
call sub_B2DCA	; 76EF1
add esp, byte 0Ch	; 76EF6
call ClearInputQueue	; 76EF9
jmp near .31	; 76EFE
.20:
sub edi, byte 20h	; 76F03
.21:
push edi	; 76F06
cmp esi, byte 1Ch	; 76F07
jge short .22	; 76F0A
xor esi, esi	; 76F0C
jmp short .23	; 76F0E
.22:
sub esi, byte 1Ch	; 76F10
.23:
push esi	; 76F13
mov ebx, dword [byte ebp+05Ah]	; 76F14
push ebx	; 76F17
call sub_903F0	; 76F18
add esp, byte 0Ch	; 76F1D
mov ecx, dword [byte ebp+02Eh]	; 76F20
cmp ecx, byte 20h	; 76F23
jge short .24	; 76F26
xor eax, eax	; 76F28
jmp short .25	; 76F2A
.24:
lea eax, [byte ecx-020h]	; 76F2C
.25:
push eax	; 76F2F
mov esi, dword [byte ebp+032h]	; 76F30
cmp esi, byte 1Ch	; 76F33
jge short .26	; 76F36
xor eax, eax	; 76F38
jmp short .27	; 76F3A
.26:
lea eax, [byte esi-01Ch]	; 76F3C
.27:
push eax	; 76F3F
mov edi, dword [byte ebp+05Ah]	; 76F40
push edi	; 76F43
call sub_91400	; 76F44
add esp, byte 0Ch	; 76F49
mov eax, dword [byte ebp+02Eh]	; 76F4C
mov edx, dword [byte ebp+0Eh]	; 76F4F
cmp eax, dword [byte edx+0Ch]	; 76F52
jle near .29	; 76F55
cmp dword [byte ebp+032h], 1F4h	; 76F5B
jge near .29	; 76F62
cmp dword [byte ebp+022h], byte 0FFFFFFFFh	; 76F68
je near .29	; 76F6C
cmp dword [byte ebp+012h], byte 0	; 76F72
je short .28	; 76F76
lea eax, [byte ebp+026h]	; 76F78
push eax	; 76F7B
lea eax, [byte ebp+02Ah]	; 76F7C
push eax	; 76F7F
lea eax, [byte ebp-072h]	; 76F80
push eax	; 76F83
lea eax, [byte ebp-012h]	; 76F84
push eax	; 76F87
mov ecx, dword [byte ebp+066h]	; 76F88
lea ebx, [byte ebp+0Eh]	; 76F8B
mov edx, dword [byte ebp+02Eh]	; 76F8E
mov eax, dword [byte ebp+032h]	; 76F91
call MenuHitTest	; 76F94
test eax, eax	; 76F99
jne near .29	; 76F9B
.28:
mov edx, dword [byte ebp+022h]	; 76FA1
mov eax, edx	; 76FA4
shl eax, 2	; 76FA6
sub eax, edx	; 76FA9
shl eax, 2	; 76FAB
sub eax, edx	; 76FAE
lea edx, [eax+eax]	; 76FB0
xor ebx, ebx	; 76FB3
mov bl, byte [dword edx+gmrosterslot]	; 76FB5
mov ecx, ebx	; 76FBB
shl ecx, 2	; 76FBD
add ecx, ebx	; 76FC0
shl ecx, 3	; 76FC2
sub ecx, ebx	; 76FC5
xor ebx, ebx	; 76FC7
mov bl, byte [byte ebp+072h]	; 76FC9
mov eax, ebx	; 76FCC
shl eax, 4	; 76FCE
add eax, ebx	; 76FD1
shl eax, 4	; 76FD3
add eax, ebx	; 76FD6
cmp byte [dword ecx+eax*4+hmroster], 2	; 76FD8
je short .29	; 76FE0
xor ecx, ecx	; 76FE2
mov cl, byte [byte ebp+06Ah]	; 76FE4
xor ebx, ebx	; 76FE7
mov bl, byte [byte ebp+06Eh]	; 76FE9
mov dl, byte [dword edx+gmrosterjersey]	; 76FEC
and edx, 0FFh	; 76FF2
mov eax, jerseyremap	; 76FF8
call MakeJerseyShape	; 76FFD
push jerseyremap	; 77002
call sub_B4DD4	; 77007
add esp, byte 4	; 7700C
mov eax, dword [byte ebp+02Eh]	; 7700F
sub eax, byte 20h	; 77012
push eax	; 77015
mov eax, dword [byte ebp+032h]	; 77016
sub eax, byte 1Ch	; 77019
push eax	; 7701C
mov eax, dword [dword ebp-0AAh]	; 7701D
push eax	; 77023
call sub_91FE0	; 77024
add esp, byte 0Ch	; 77029
.29:
mov edx, dword [byte ebp+02Eh]	; 7702C
push edx	; 7702F
mov eax, dword [byte ebp+032h]	; 77030
sub eax, byte 3	; 77033
push eax	; 77036
mov ebx, dword [pointerspr]	; 77037
push ebx	; 7703D
.30:
call sub_91FE0	; 7703E
add esp, byte 0Ch	; 77043
mov esi, dword [byte ebp+032h]	; 77046
mov edi, dword [byte ebp+02Eh]	; 77049
.31:
xor ecx, ecx	; 7704C
.32:
call GetInputEvent	; 7704E
test eax, eax	; 77053
je short .33	; 77055
lea ebx, [byte ebp+02Eh]	; 77057
lea edx, [byte ebp+032h]	; 7705A
call dword [ptrupdatefn]	; 7705D
mov ecx, eax	; 77063
test al, 2	; 77065
je short GameLineEditorLoop.32	; 77067
.33:
test cl, 2	; 77069
jne short .35	; 7706C
cmp esi, dword [byte ebp+032h]	; 7706E
jne short .34	; 77071
cmp edi, dword [byte ebp+02Eh]	; 77073
je short GameLineEditorLoop.31	; 77076
.34:
cmp edi, byte 20h	; 77078
jge near GameLineEditorLoop.20	; 7707B
xor edi, edi	; 77081
jmp near GameLineEditorLoop.21	; 77083
.35:
lea eax, [byte ebp+026h]	; 77088
push eax	; 7708B
lea eax, [byte ebp+02Ah]	; 7708C
push eax	; 7708F
lea eax, [byte ebp-072h]	; 77090
push eax	; 77093
lea eax, [byte ebp-012h]	; 77094
push eax	; 77097
mov ecx, dword [byte ebp+066h]	; 77098
lea ebx, [byte ebp+0Eh]	; 7709B
mov edx, dword [byte ebp+02Eh]	; 7709E
mov eax, dword [byte ebp+032h]	; 770A1
call MenuHitTest	; 770A4
lea edx, [byte edi-020h]	; 770A9
test eax, eax	; 770AC
je near .63	; 770AE
mov ebx, dword [byte ebp+02Ah]	; 770B4
shl ebx, 2	; 770B7
mov eax, dword [byte ebp+026h]	; 770BA
shl eax, 5	; 770BD
mov dword [byte ebp+04Ah], eax	; 770C0
mov eax, dword [byte ebx+ebp+0Eh]	; 770C3
add eax, dword [byte ebp+04Ah]	; 770C7
cmp dword [byte eax+014h], byte 0	; 770CA
je near .47	; 770CE
mov eax, dword [byte ebp+026h]	; 770D4
cmp eax, dword [byte ebx+ebp-02h]	; 770D7
jne near .42	; 770DB
cmp edi, byte 20h	; 770E1
jge short .36	; 770E4
xor edx, edx	; 770E6
.36:
push edx	; 770E8
cmp esi, byte 1Ch	; 770E9
jge short .37	; 770EC
xor esi, esi	; 770EE
jmp short .38	; 770F0
.37:
sub esi, byte 1Ch	; 770F2
.38:
push esi	; 770F5
mov esi, dword [byte ebp+05Ah]	; 770F6
push esi	; 770F9
call sub_903F0	; 770FA
add esp, byte 0Ch	; 770FF
mov dword [byte ebp+036h], 3	; 77102
jmp short .41	; 77109
.39:
mov eax, ebx	; 7710B
shl eax, 2	; 7710D
mov esi, dword [byte eax+ebp-022h]	; 77110
test esi, esi	; 77114
je short .40	; 77116
mov edi, dword [byte ebp+ebx*8-06Eh]	; 77118
push edi	; 7711C
mov ebx, dword [byte ebp+ebx*8-072h]	; 7711D
push ebx	; 77121
push esi	; 77122
call sub_903F0	; 77123
add esp, byte 0Ch	; 77128
mov eax, dword [byte ebp+036h]	; 7712B
xor esi, esi	; 7712E
mov dword [byte ebp+eax*8-06Eh], esi	; 77130
mov dword [byte ebp+eax*8-072h], esi	; 77134
mov edi, dword [byte ebp+eax*4-022h]	; 77138
push edi	; 7713C
call FreeMemBlock	; 7713D
add esp, byte 4	; 77142
.40:
dec dword [byte ebp+036h]	; 77145
.41:
mov ebx, dword [byte ebp+036h]	; 77148
test ebx, ebx	; 7714B
jge short GameLineEditorLoop.39	; 7714D
xor ecx, ecx	; 7714F
mov dword [byte ebp+066h], ecx	; 77151
mov eax, dword [byte ebp+02Ah]	; 77154
mov esi, dword [byte ebp+026h]	; 77157
shl esi, 5	; 7715A
mov eax, dword [byte ebp+eax*4+0Eh]	; 7715D
add esi, eax	; 77161
lea eax, [byte ebp+02Eh]	; 77163
push eax	; 77166
lea eax, [byte ebp+032h]	; 77167
push eax	; 7716A
mov edi, dword [dword ebp+08Ah]	; 7716B
push edi	; 77171
mov eax, dword [dword ebp+086h]	; 77172
push eax	; 77178
push ecx	; 77179
mov edx, dword [dword ebp-0AAh]	; 7717A
push edx	; 77180
xor ebx, ebx	; 77181
mov bl, byte [byte ebp+072h]	; 77183
lea ecx, [byte ebp+022h]	; 77186
mov edx, dword [dword ebp-0A6h]	; 77189
lea eax, [dword ebp-0A2h]	; 7718F
call dword [byte esi+014h]	; 77195
xor ebx, ebx	; 77198
mov dword [byte ebp+01Ah], ebx	; 7719A
mov dword [byte ebp+016h], ebx	; 7719D
mov dword [byte ebp+012h], ebx	; 771A0
mov dword [byte ebp-01Ah], ebx	; 771A3
mov dword [byte ebp-01Eh], ebx	; 771A6
mov dword [byte ebp-022h], ebx	; 771A9
mov dword [byte ebp+0Ah], ebx	; 771AC
mov dword [byte ebp+06h], ebx	; 771AF
mov dword [byte ebp+02h], ebx	; 771B2
mov dword [byte ebp-06h], ebx	; 771B5
mov dword [byte ebp-0Ah], ebx	; 771B8
mov dword [byte ebp-0Eh], ebx	; 771BB
cmp eax, byte 1	; 771BE
je near .111	; 771C1
call ClearInputQueue	; 771C7
jmp near .104	; 771CC
.42:
cmp edi, byte 20h	; 771D1
jge short .43	; 771D4
xor edx, edx	; 771D6
.43:
push edx	; 771D8
cmp esi, byte 1Ch	; 771D9
jge short .44	; 771DC
xor esi, esi	; 771DE
jmp short .45	; 771E0
.44:
sub esi, byte 1Ch	; 771E2
.45:
push esi	; 771E5
mov esi, dword [byte ebp+05Ah]	; 771E6
push esi	; 771E9
call sub_903F0	; 771EA
add esp, byte 0Ch	; 771EF
mov edi, dword [byte ebp+052h]	; 771F2
push edi	; 771F5
mov eax, dword [byte ebp+056h]	; 771F6
push eax	; 771F9
mov eax, dword [byte ebp+02Ah]	; 771FA
mov ebx, dword [byte ebp+eax*8-06Eh]	; 771FD
mov edx, dword [byte ebp+eax*8-072h]	; 77201
mov ecx, dword [byte ebp+eax*4-02h]	; 77205
shl ecx, 5	; 77209
mov eax, dword [byte ebp+eax*4+0Eh]	; 7720C
add eax, ecx	; 77210
mov ecx, dword [byte ebp+04Eh]	; 77212
call DrawMenuItemSel	; 77215
mov edx, dword [byte ebp+02Ah]	; 7721A
mov eax, dword [byte ebp+026h]	; 7721D
mov dword [byte ebp+edx*4-02h], eax	; 77220
push edi	; 77224
mov ecx, dword [byte ebp+056h]	; 77225
push ecx	; 77228
mov ebx, dword [byte ebp+edx*8-06Eh]	; 77229
mov esi, dword [byte ebp+edx*8-072h]	; 7722D
mov ecx, eax	; 77231
shl ecx, 5	; 77233
mov eax, dword [byte ebp+edx*4+0Eh]	; 77236
add eax, ecx	; 7723A
mov ecx, dword [byte ebp+04Eh]	; 7723C
mov edx, esi	; 7723F
.46:
call DrawMenuItemNorm	; 77241
jmp near .104	; 77246
.47:
cmp dword [byte eax+018h], byte 0	; 7724B
je near .59	; 7724F
cmp edi, byte 20h	; 77255
jge short .48	; 77258
xor edx, edx	; 7725A
.48:
push edx	; 7725C
cmp esi, byte 1Ch	; 7725D
jge short .49	; 77260
xor esi, esi	; 77262
jmp short .50	; 77264
.49:
sub esi, byte 1Ch	; 77266
.50:
push esi	; 77269
mov ecx, dword [byte ebp+05Ah]	; 7726A
push ecx	; 7726D
call sub_903F0	; 7726E
add esp, byte 0Ch	; 77273
mov eax, dword [byte ebp+066h]	; 77276
cmp eax, dword [byte ebp+02Ah]	; 77279
je short .54	; 7727C
mov dword [byte ebp+036h], eax	; 7727E
jmp short .53	; 77281
.51:
shl eax, 2	; 77283
xor edi, edi	; 77286
mov dword [byte eax+ebp-02h], edi	; 77288
cmp dword [byte eax+ebp-022h], byte 0	; 7728C
je short .52	; 77291
mov edx, dword [byte ebp+036h]	; 77293
mov ebx, dword [byte ebp+edx*8-06Eh]	; 77296
push ebx	; 7729A
mov ecx, dword [byte ebp+edx*8-072h]	; 7729B
push ecx	; 7729F
mov esi, dword [byte eax+ebp-022h]	; 772A0
push esi	; 772A4
call sub_903F0	; 772A5
add esp, byte 0Ch	; 772AA
mov eax, dword [byte ebp+036h]	; 772AD
mov dword [byte ebp+eax*8-06Eh], edi	; 772B0
mov dword [byte ebp+eax*8-072h], edi	; 772B4
mov edx, dword [byte ebp+eax*4-022h]	; 772B8
push edx	; 772BC
call FreeMemBlock	; 772BD
add esp, byte 4	; 772C2
mov eax, dword [byte ebp+036h]	; 772C5
mov dword [byte ebp+eax*4-022h], edi	; 772C8
mov dword [byte ebp+eax*4+0Eh], edi	; 772CC
mov dword [byte ebp+eax*4-012h], edi	; 772D0
.52:
dec dword [byte ebp+036h]	; 772D4
.53:
mov eax, dword [byte ebp+036h]	; 772D7
mov esi, dword [byte ebp+02Ah]	; 772DA
cmp eax, esi	; 772DD
jg short GameLineEditorLoop.51	; 772DF
mov dword [byte ebp+066h], esi	; 772E1
.54:
mov eax, dword [byte ebp+052h]	; 772E4
push eax	; 772E7
mov edx, dword [byte ebp+056h]	; 772E8
push edx	; 772EB
mov edi, dword [byte ebp+066h]	; 772EC
mov ebx, dword [byte ebp+edi*8-06Eh]	; 772EF
mov edx, dword [byte ebp+edi*8-072h]	; 772F3
mov eax, dword [byte ebp+edi*4-02h]	; 772F7
shl eax, 5	; 772FB
mov ecx, dword [byte ebp+edi*4+0Eh]	; 772FE
add eax, ecx	; 77302
mov ecx, dword [byte ebp+04Eh]	; 77304
call DrawMenuItemSel	; 77307
mov eax, dword [byte ebp+026h]	; 7730C
mov dword [byte ebp+edi*4-02h], eax	; 7730F
mov eax, dword [byte ebp+052h]	; 77313
push eax	; 77316
mov edx, dword [byte ebp+056h]	; 77317
push edx	; 7731A
mov ebx, dword [byte ebp+edi*8-06Eh]	; 7731B
mov edx, dword [byte ebp+edi*8-072h]	; 7731F
mov ecx, dword [byte ebp+026h]	; 77323
shl ecx, 5	; 77326
mov eax, dword [byte ebp+edi*4+0Eh]	; 77329
add eax, ecx	; 7732D
mov ecx, dword [byte ebp+04Eh]	; 7732F
call DrawMenuItemNorm	; 77332
mov eax, dword [byte ebp+02Ah]	; 77337
mov ecx, dword [byte ebp+026h]	; 7733A
shl ecx, 5	; 7733D
mov ebx, dword [byte ebp+eax*4+0Eh]	; 77340
lea esi, [byte edi+01h]	; 77344
mov dword [byte ebp+066h], esi	; 77347
mov ebx, dword [byte ecx+ebx+018h]	; 7734A
mov dword [byte ebp+esi*4+0Eh], ebx	; 7734E
mov eax, dword [byte ebp+eax*4+0Eh]	; 77352
add eax, ecx	; 77356
mov ebx, dword [byte eax+01Ch]	; 77358
mov dword [byte ebp+esi*4-012h], ebx	; 7735B
cmp esi, byte 1	; 7735F
je short .55	; 77362
mov edx, dword [byte eax+08h]	; 77364
jmp short .56	; 77367
.55:
mov edx, dword [eax]	; 77369
.56:
mov eax, dword [byte ebp+066h]	; 7736B
mov ebx, dword [byte ebp+eax*8-07Ah]	; 7736E
add edx, ebx	; 77372
mov dword [byte ebp+eax*8-072h], edx	; 77374
mov edx, dword [byte ebp+026h]	; 77378
shl edx, 5	; 7737B
mov eax, dword [byte ebp+02Ah]	; 7737E
shl eax, 2	; 77381
cmp dword [byte ebp+066h], byte 1	; 77384
je short .57	; 77388
mov eax, dword [byte eax+ebp+0Eh]	; 7738A
mov eax, dword [byte edx+eax+04h]	; 7738E
jmp short .58	; 77392
.57:
mov eax, dword [byte eax+ebp+0Eh]	; 77394
mov eax, dword [byte edx+eax+0Ch]	; 77398
.58:
mov edx, dword [byte ebp+066h]	; 7739C
shl edx, 3	; 7739F
mov dword [byte ebp+05Eh], edx	; 773A2
mov esi, dword [byte edx+ebp-076h]	; 773A5
add eax, esi	; 773A9
mov dword [byte edx+ebp-06Eh], eax	; 773AB
mov eax, dword [byte ebp+066h]	; 773AF
shl eax, 2	; 773B2
mov dword [byte ebp+062h], eax	; 773B5
mov edx, dword [byte eax+ebp-012h]	; 773B8
shl edx, 5	; 773BC
mov eax, dword [byte eax+ebp+0Eh]	; 773BF
mov ebx, dword [byte edx+eax-018h]	; 773C3
sub ebx, dword [eax]	; 773C7
inc ebx	; 773C9
mov dword [byte ebp+042h], ebx	; 773CA
mov edx, dword [byte edx+eax-014h]	; 773CD
sub edx, dword [byte eax+04h]	; 773D1
inc edx	; 773D4
mov dword [byte ebp+03Eh], edx	; 773D5
push byte 20h	; 773D8
mov eax, dword [byte ebp+042h]	; 773DA
imul eax, edx	; 773DD
add eax, byte 11h	; 773E0
push eax	; 773E3
push str_Menubuff9	; 773E4
call sub_8CCA8	; 773E9
add esp, byte 0Ch	; 773EE
mov edx, dword [byte ebp+062h]	; 773F1
mov dword [byte edx+ebp-022h], eax	; 773F4
mov esi, dword [pointerspr]	; 773F8
mov edi, eax	; 773FE
movsd	; 77400
movsd	; 77401
movsd	; 77402
movsd	; 77403
movsb	; 77404
mov eax, dword [byte edx+ebp-022h]	; 77405
mov edx, dword [byte ebp+042h]	; 77409
mov word [byte eax+04h], dx	; 7740C
mov eax, dword [byte ebp+062h]	; 77410
mov eax, dword [byte eax+ebp-022h]	; 77413
mov edx, dword [byte ebp+03Eh]	; 77417
mov word [byte eax+06h], dx	; 7741A
mov eax, dword [byte ebp+05Eh]	; 7741E
mov esi, dword [byte eax+ebp-06Eh]	; 77421
push esi	; 77425
mov edi, dword [byte eax+ebp-072h]	; 77426
push edi	; 7742A
mov eax, dword [byte ebp+062h]	; 7742B
mov edx, dword [byte eax+ebp-022h]	; 7742E
push edx	; 77432
call sub_91400	; 77433
add esp, byte 0Ch	; 77438
mov ebx, dword [byte ebp+052h]	; 7743B
push ebx	; 7743E
mov ecx, dword [byte ebp+056h]	; 7743F
push ecx	; 77442
mov esi, dword [byte ebp+04Eh]	; 77443
push esi	; 77446
mov ecx, dword [byte ebp+05Eh]	; 77447
mov ecx, dword [byte ecx+ebp-06Eh]	; 7744A
mov ebx, dword [byte ebp+05Eh]	; 7744E
mov ebx, dword [byte ebx+ebp-072h]	; 77451
mov edx, dword [byte ebp+062h]	; 77455
mov edx, dword [byte edx+ebp-012h]	; 77458
mov eax, dword [byte ebp+062h]	; 7745C
mov eax, dword [byte eax+ebp+0Eh]	; 7745F
call DrawMenuDropdown	; 77463
mov eax, dword [byte ebp+062h]	; 77468
xor edi, edi	; 7746B
mov dword [byte eax+ebp-02h], edi	; 7746D
mov eax, dword [byte ebp+052h]	; 77471
push eax	; 77474
mov edx, dword [byte ebp+056h]	; 77475
push edx	; 77478
mov ebx, dword [byte ebp+05Eh]	; 77479
mov ebx, dword [byte ebx+ebp-06Eh]	; 7747C
mov edx, dword [byte ebp+05Eh]	; 77480
mov edx, dword [byte edx+ebp-072h]	; 77483
mov eax, dword [byte ebp+062h]	; 77487
mov eax, dword [byte eax+ebp+0Eh]	; 7748A
mov ecx, esi	; 7748E
jmp near GameLineEditorLoop.46	; 77490
.59:
cmp edi, byte 20h	; 77495
jge short .60	; 77498
xor edx, edx	; 7749A
.60:
push edx	; 7749C
cmp esi, byte 1Ch	; 7749D
jge short .61	; 774A0
xor esi, esi	; 774A2
jmp short .62	; 774A4
.61:
sub esi, byte 1Ch	; 774A6
.62:
push esi	; 774A9
mov ecx, dword [byte ebp+05Ah]	; 774AA
push ecx	; 774AD
call sub_903F0	; 774AE
add esp, byte 0Ch	; 774B3
mov esi, dword [byte ebp+052h]	; 774B6
push esi	; 774B9
mov edi, dword [byte ebp+056h]	; 774BA
push edi	; 774BD
mov eax, dword [byte ebp+02Ah]	; 774BE
mov ebx, dword [byte ebp+eax*8-06Eh]	; 774C1
mov edx, dword [byte ebp+eax*8-072h]	; 774C5
mov ecx, dword [byte ebp+eax*4-02h]	; 774C9
shl ecx, 5	; 774CD
mov eax, dword [byte ebp+eax*4+0Eh]	; 774D0
add eax, ecx	; 774D4
mov ecx, dword [byte ebp+04Eh]	; 774D6
call DrawMenuItemSel	; 774D9
mov edx, dword [byte ebp+02Ah]	; 774DE
mov eax, dword [byte ebp+026h]	; 774E1
mov dword [byte ebp+edx*4-02h], eax	; 774E4
push esi	; 774E8
push edi	; 774E9
mov ebx, dword [byte ebp+edx*8-06Eh]	; 774EA
mov eax, dword [byte ebp+edx*8-072h]	; 774EE
mov ecx, dword [byte ebp+edx*4-02h]	; 774F2
shl ecx, 5	; 774F6
mov esi, dword [byte ebp+edx*4+0Eh]	; 774F9
add esi, ecx	; 774FD
mov ecx, dword [byte ebp+04Eh]	; 774FF
mov edx, eax	; 77502
mov eax, esi	; 77504
jmp near GameLineEditorLoop.46	; 77506
.63:
cmp edi, byte 20h	; 7750B
jge short .64	; 7750E
xor edx, edx	; 77510
.64:
push edx	; 77512
cmp esi, byte 1Ch	; 77513
jge short .65	; 77516
xor esi, esi	; 77518
jmp short .66	; 7751A
.65:
sub esi, byte 1Ch	; 7751C
.66:
push esi	; 7751F
mov edx, dword [byte ebp+05Ah]	; 77520
push edx	; 77523
call sub_903F0	; 77524
add esp, byte 0Ch	; 77529
mov dword [byte ebp+036h], 3	; 7752C
jmp short .69	; 77533
.67:
mov eax, ecx	; 77535
shl eax, 2	; 77537
mov edx, dword [byte eax+ebp-022h]	; 7753A
test edx, edx	; 7753E
je short .68	; 77540
mov ebx, dword [byte ebp+ecx*8-06Eh]	; 77542
push ebx	; 77546
mov ecx, dword [byte ebp+ecx*8-072h]	; 77547
push ecx	; 7754B
push edx	; 7754C
call sub_903F0	; 7754D
add esp, byte 0Ch	; 77552
mov eax, dword [byte ebp+036h]	; 77555
xor edi, edi	; 77558
mov dword [byte ebp+eax*8-06Eh], edi	; 7755A
mov dword [byte ebp+eax*8-072h], edi	; 7755E
mov edx, dword [byte ebp+eax*4-022h]	; 77562
push edx	; 77566
call FreeMemBlock	; 77567
add esp, byte 4	; 7756C
.68:
dec dword [byte ebp+036h]	; 7756F
.69:
mov ecx, dword [byte ebp+036h]	; 77572
test ecx, ecx	; 77575
jge short GameLineEditorLoop.67	; 77577
xor esi, esi	; 77579
mov dword [byte ebp+066h], esi	; 7757B
mov dword [byte ebp+01Ah], esi	; 7757E
mov dword [byte ebp+016h], esi	; 77581
mov dword [byte ebp+012h], esi	; 77584
mov dword [byte ebp-01Ah], esi	; 77587
mov dword [byte ebp-01Eh], esi	; 7758A
mov dword [byte ebp-022h], esi	; 7758D
mov dword [byte ebp+0Ah], esi	; 77590
mov dword [byte ebp+06h], esi	; 77593
mov dword [byte ebp+02h], esi	; 77596
mov dword [byte ebp-06h], esi	; 77599
mov dword [byte ebp-0Ah], esi	; 7759C
mov dword [byte ebp-0Eh], esi	; 7759F
lea ebx, [byte ebp+01Eh]	; 775A2
mov edx, dword [byte ebp+02Eh]	; 775A5
mov eax, dword [byte ebp+032h]	; 775A8
call LineEdHitTest	; 775AB
test eax, eax	; 775B0
je near .104	; 775B2
cmp dword [byte ebp+01Eh], byte 64h	; 775B8
jge near .97	; 775BC
mov eax, dword [byte ebp+022h]	; 775C2
cmp eax, byte 0FFFFFFFFh	; 775C5
je near .97	; 775C8
mov edx, eax	; 775CE
shl eax, 2	; 775D0
sub eax, edx	; 775D3
shl eax, 2	; 775D5
sub eax, edx	; 775D8
xor edx, edx	; 775DA
mov dl, byte [nosplit eax*2+gmrosterslot]	; 775DC
mov ebx, edx	; 775E3
shl ebx, 2	; 775E5
add ebx, edx	; 775E8
shl ebx, 3	; 775EA
sub ebx, edx	; 775ED
xor edx, edx	; 775EF
mov dl, byte [byte ebp+072h]	; 775F1
mov eax, edx	; 775F4
shl eax, 4	; 775F6
add eax, edx	; 775F9
shl eax, 4	; 775FB
add eax, edx	; 775FE
cmp byte [dword ebx+eax*4+hmroster], 2	; 77600
je near .97	; 77608
push dword 0C1h	; 7760E
push dword 0C0h	; 77613
call sub_8E9C0	; 77618
add esp, byte 8	; 7761D
mov edx, dword [byte ebp+022h]	; 77620
mov eax, edx	; 77623
shl eax, 2	; 77625
sub eax, edx	; 77628
shl eax, 2	; 7762A
sub eax, edx	; 7762D
add eax, eax	; 7762F
mov edx, dword [byte ebp+01Eh]	; 77631
cmp edx, byte 0Ch	; 77634
jge near .74	; 77637
mov ch, byte [dword eax+gmroster]	; 7763D
cmp ch, 43h	; 77643
je short .70	; 77646
cmp ch, 4Ch	; 77648
je short .70	; 7764B
cmp ch, 52h	; 7764D
jne near .94	; 77650
.70:
mov ebx, 3	; 77656
mov eax, dword [byte ebp+01Eh]	; 7765B
mov edx, eax	; 7765E
sar edx, 1Fh	; 77660
idiv ebx	; 77663
mov dword [byte ebp+036h], eax	; 77665
xor esi, esi	; 77668
.71:
mov edx, dword [byte ebp+036h]	; 7766A
mov eax, edx	; 7766D
shl eax, 2	; 7766F
sub eax, edx	; 77672
lea edx, [eax+esi]	; 77674
mov ebx, dword [byte ebp+022h]	; 77677
mov eax, ebx	; 7767A
shl eax, 2	; 7767C
sub eax, ebx	; 7767F
shl eax, 2	; 77681
sub eax, ebx	; 77684
mov bl, byte [dword edx+ebp-0A2h]	; 77686
cmp bl, byte [nosplit eax*2+gmrosterjersey]	; 7768D
jne short .72	; 77694
mov byte [dword edx+ebp-0A2h], 64h	; 77696
.72:
inc esi	; 7769E
cmp esi, byte 3	; 7769F
jl short GameLineEditorLoop.71	; 776A2
mov ebx, 3	; 776A4
mov eax, dword [byte ebp+01Eh]	; 776A9
mov edx, eax	; 776AC
sar edx, 1Fh	; 776AE
idiv ebx	; 776B1
mov esi, edx	; 776B3
mov edx, dword [byte ebp+022h]	; 776B5
mov ebx, edx	; 776B8
shl ebx, 2	; 776BA
sub ebx, edx	; 776BD
shl ebx, 2	; 776BF
sub ebx, edx	; 776C2
add ebx, ebx	; 776C4
mov edx, dword [byte ebp+036h]	; 776C6
mov eax, edx	; 776C9
shl eax, 2	; 776CB
sub eax, edx	; 776CE
add esi, eax	; 776D0
mov al, byte [dword ebx+gmrosterjersey]	; 776D2
mov byte [dword esi+ebp-0A2h], al	; 776D8
xor esi, esi	; 776DF
.73:
xor ecx, ecx	; 776E1
mov cl, byte [byte ebp+06Ah]	; 776E3
xor ebx, ebx	; 776E6
mov bl, byte [byte ebp+06Eh]	; 776E8
mov edx, dword [byte ebp+036h]	; 776EB
mov eax, edx	; 776EE
shl eax, 2	; 776F0
sub eax, edx	; 776F3
add eax, esi	; 776F5
xor edx, edx	; 776F7
mov dl, byte [dword eax+ebp-0A2h]	; 776F9
mov eax, jerseyremap	; 77700
call MakeJerseyShape	; 77705
push jerseyremap	; 7770A
call sub_B4DD4	; 7770F
add esp, byte 4	; 77714
mov edx, dword [byte ebp+036h]	; 77717
mov eax, edx	; 7771A
shl eax, 2	; 7771C
sub eax, edx	; 7771F
add eax, esi	; 77721
mov edi, dword [nosplit eax*8+linesloty]	; 77723
push edi	; 7772A
mov edx, dword [nosplit eax*8+lineslotx]	; 7772B
push edx	; 77732
mov ebx, dword [dword ebp-0AAh]	; 77733
push ebx	; 77739
call sub_931FC	; 7773A
add esp, byte 0Ch	; 7773F
inc esi	; 77742
cmp esi, byte 3	; 77743
jl short GameLineEditorLoop.73	; 77746
jmp near .94	; 77748
.74:
cmp edx, byte 12h	; 7774D
jge near .78	; 77750
cmp byte [dword eax+gmroster], 44h	; 77756
jne near .94	; 7775D
sub edx, byte 0Ch	; 77763
mov eax, edx	; 77766
sar edx, 1Fh	; 77768
LD sub, eax, edx	; 7776B
sar eax, 1	; 7776D
mov dword [byte ebp+036h], eax	; 7776F
mov cl, 64h	; 77772
.75:
mov edx, dword [byte ebp+036h]	; 77774
add edx, edx	; 77777
add edx, esi	; 77779
mov ebx, dword [byte ebp+022h]	; 7777B
mov eax, ebx	; 7777E
shl eax, 2	; 77780
sub eax, ebx	; 77783
shl eax, 2	; 77785
sub eax, ebx	; 77788
mov bl, byte [dword edx+ebp-096h]	; 7778A
cmp bl, byte [nosplit eax*2+gmrosterjersey]	; 77791
jne short .76	; 77798
mov byte [dword edx+ebp-096h], cl	; 7779A
.76:
inc esi	; 777A1
cmp esi, byte 2	; 777A2
jl short GameLineEditorLoop.75	; 777A5
mov edx, dword [byte ebp+01Eh]	; 777A7
sub edx, byte 0Ch	; 777AA
mov ebx, 2	; 777AD
mov eax, edx	; 777B2
sar edx, 1Fh	; 777B4
idiv ebx	; 777B7
mov esi, edx	; 777B9
mov edx, dword [byte ebp+022h]	; 777BB
mov eax, edx	; 777BE
shl eax, 2	; 777C0
sub eax, edx	; 777C3
shl eax, 2	; 777C5
sub eax, edx	; 777C8
mov edx, dword [byte ebp+036h]	; 777CA
add edx, edx	; 777CD
add esi, edx	; 777CF
mov al, byte [nosplit eax*2+gmrosterjersey]	; 777D1
mov byte [dword esi+ebp-096h], al	; 777D8
xor esi, esi	; 777DF
.77:
xor ecx, ecx	; 777E1
mov cl, byte [byte ebp+06Ah]	; 777E3
xor ebx, ebx	; 777E6
mov bl, byte [byte ebp+06Eh]	; 777E8
mov eax, dword [byte ebp+036h]	; 777EB
add eax, eax	; 777EE
add eax, esi	; 777F0
xor edx, edx	; 777F2
mov dl, byte [dword eax+ebp-096h]	; 777F4
mov eax, jerseyremap	; 777FB
call MakeJerseyShape	; 77800
push jerseyremap	; 77805
call sub_B4DD4	; 7780A
add esp, byte 4	; 7780F
mov eax, dword [byte ebp+036h]	; 77812
add eax, eax	; 77815
add eax, esi	; 77817
mov edx, dword [nosplit eax*8+dword_D139C]	; 77819
push edx	; 77820
mov ebx, dword [nosplit eax*8+dword_D1398]	; 77821
push ebx	; 77828
mov ecx, dword [dword ebp-0AAh]	; 77829
push ecx	; 7782F
call sub_931FC	; 77830
add esp, byte 0Ch	; 77835
inc esi	; 77838
cmp esi, byte 2	; 77839
jl short GameLineEditorLoop.77	; 7783C
jmp near .94	; 7783E
.78:
cmp edx, byte 1Ch	; 77843
jge near .82	; 77846
cmp byte [dword eax+gmroster], 47h	; 7784C
je near .94	; 77853
sub edx, byte 12h	; 77859
mov ebx, 5	; 7785C
mov eax, edx	; 77861
sar edx, 1Fh	; 77863
idiv ebx	; 77866
mov dword [byte ebp+036h], eax	; 77868
.79:
mov edx, dword [byte ebp+036h]	; 7786B
mov eax, edx	; 7786E
shl eax, 2	; 77870
add eax, edx	; 77873
lea edx, [eax+esi]	; 77875
mov ebx, dword [byte ebp+022h]	; 77878
mov eax, ebx	; 7787B
shl eax, 2	; 7787D
sub eax, ebx	; 77880
shl eax, 2	; 77882
sub eax, ebx	; 77885
mov bl, byte [dword edx+ebp-090h]	; 77887
cmp bl, byte [nosplit eax*2+gmrosterjersey]	; 7788E
jne short .80	; 77895
mov byte [dword edx+ebp-090h], 64h	; 77897
.80:
inc esi	; 7789F
cmp esi, byte 5	; 778A0
jl short GameLineEditorLoop.79	; 778A3
mov edx, dword [byte ebp+01Eh]	; 778A5
sub edx, byte 12h	; 778A8
mov ebx, 5	; 778AB
mov eax, edx	; 778B0
sar edx, 1Fh	; 778B2
idiv ebx	; 778B5
mov esi, edx	; 778B7
mov edx, dword [byte ebp+022h]	; 778B9
mov eax, edx	; 778BC
shl eax, 2	; 778BE
sub eax, edx	; 778C1
shl eax, 2	; 778C3
sub eax, edx	; 778C6
lea edx, [eax+eax]	; 778C8
mov ebx, dword [byte ebp+036h]	; 778CB
mov eax, ebx	; 778CE
shl eax, 2	; 778D0
add eax, ebx	; 778D3
add esi, eax	; 778D5
mov al, byte [dword edx+gmrosterjersey]	; 778D7
mov byte [dword esi+ebp-090h], al	; 778DD
xor esi, esi	; 778E4
.81:
xor ecx, ecx	; 778E6
mov cl, byte [byte ebp+06Ah]	; 778E8
xor ebx, ebx	; 778EB
mov bl, byte [byte ebp+06Eh]	; 778ED
mov edx, dword [byte ebp+036h]	; 778F0
mov eax, edx	; 778F3
shl eax, 2	; 778F5
add eax, edx	; 778F8
add eax, esi	; 778FA
xor edx, edx	; 778FC
mov dl, byte [dword eax+ebp-090h]	; 778FE
mov eax, jerseyremap	; 77905
call MakeJerseyShape	; 7790A
push jerseyremap	; 7790F
call sub_B4DD4	; 77914
add esp, byte 4	; 77919
mov edx, dword [byte ebp+036h]	; 7791C
mov eax, edx	; 7791F
shl eax, 2	; 77921
add eax, edx	; 77924
add eax, esi	; 77926
mov ecx, dword [nosplit eax*8+dword_D13CC]	; 77928
push ecx	; 7792F
mov edi, dword [nosplit eax*8+dword_D13C8]	; 77930
push edi	; 77937
mov eax, dword [dword ebp-0AAh]	; 77938
push eax	; 7793E
call sub_931FC	; 7793F
add esp, byte 0Ch	; 77944
inc esi	; 77947
cmp esi, byte 5	; 77948
jl short GameLineEditorLoop.81	; 7794B
jmp near .94	; 7794D
.82:
cmp edx, byte 24h	; 77952
jge near .86	; 77955
cmp byte [dword eax+gmroster], 47h	; 7795B
je near .94	; 77962
sub edx, byte 1Ch	; 77968
mov eax, edx	; 7796B
sar edx, 1Fh	; 7796D
shl edx, 2	; 77970
LD sbb, eax, edx	; 77973
sar eax, 2	; 77975
mov dword [byte ebp+036h], eax	; 77978
mov cl, 64h	; 7797B
.83:
mov edx, dword [byte ebp+036h]	; 7797D
shl edx, 2	; 77980
add edx, esi	; 77983
mov ebx, dword [byte ebp+022h]	; 77985
mov eax, ebx	; 77988
shl eax, 2	; 7798A
sub eax, ebx	; 7798D
shl eax, 2	; 7798F
sub eax, ebx	; 77992
mov bl, byte [dword edx+ebp-086h]	; 77994
cmp bl, byte [nosplit eax*2+gmrosterjersey]	; 7799B
jne short .84	; 779A2
mov byte [dword edx+ebp-086h], cl	; 779A4
.84:
inc esi	; 779AB
cmp esi, byte 4	; 779AC
jl short GameLineEditorLoop.83	; 779AF
mov edx, dword [byte ebp+01Eh]	; 779B1
sub edx, byte 1Ch	; 779B4
mov ebx, 4	; 779B7
mov eax, edx	; 779BC
sar edx, 1Fh	; 779BE
idiv ebx	; 779C1
mov esi, edx	; 779C3
mov edx, dword [byte ebp+022h]	; 779C5
mov eax, edx	; 779C8
shl eax, 2	; 779CA
sub eax, edx	; 779CD
shl eax, 2	; 779CF
sub eax, edx	; 779D2
mov edx, dword [byte ebp+036h]	; 779D4
shl edx, 2	; 779D7
add esi, edx	; 779DA
mov al, byte [nosplit eax*2+gmrosterjersey]	; 779DC
mov byte [dword esi+ebp-086h], al	; 779E3
xor esi, esi	; 779EA
.85:
xor ecx, ecx	; 779EC
mov cl, byte [byte ebp+06Ah]	; 779EE
xor ebx, ebx	; 779F1
mov bl, byte [byte ebp+06Eh]	; 779F3
mov eax, dword [byte ebp+036h]	; 779F6
shl eax, 2	; 779F9
add eax, esi	; 779FC
xor edx, edx	; 779FE
mov dl, byte [dword eax+ebp-086h]	; 77A00
mov eax, jerseyremap	; 77A07
call MakeJerseyShape	; 77A0C
push jerseyremap	; 77A11
call sub_B4DD4	; 77A16
add esp, byte 4	; 77A1B
mov eax, dword [byte ebp+036h]	; 77A1E
shl eax, 2	; 77A21
add eax, esi	; 77A24
mov edi, dword [nosplit eax*8+dword_D141C]	; 77A26
push edi	; 77A2D
mov edx, dword [nosplit eax*8+dword_D1418]	; 77A2E
push edx	; 77A35
mov ebx, dword [dword ebp-0AAh]	; 77A36
push ebx	; 77A3C
call sub_931FC	; 77A3D
add esp, byte 0Ch	; 77A42
inc esi	; 77A45
cmp esi, byte 4	; 77A46
jl short GameLineEditorLoop.85	; 77A49
jmp near .94	; 77A4B
.86:
cmp edx, byte 26h	; 77A50
jge near .90	; 77A53
cmp byte [dword eax+gmroster], 47h	; 77A59
jne near .94	; 77A60
mov ch, 64h	; 77A66
.87:
mov edx, dword [byte ebp+022h]	; 77A68
mov eax, edx	; 77A6B
shl eax, 2	; 77A6D
sub eax, edx	; 77A70
shl eax, 2	; 77A72
sub eax, edx	; 77A75
mov dl, byte [byte esi+ebp-07Eh]	; 77A77
cmp dl, byte [nosplit eax*2+gmrosterjersey]	; 77A7B
jne short .88	; 77A82
mov byte [byte esi+ebp-07Eh], ch	; 77A84
.88:
inc esi	; 77A88
cmp esi, byte 2	; 77A89
jl short GameLineEditorLoop.87	; 77A8C
mov esi, dword [byte ebp+01Eh]	; 77A8E
sub esi, byte 24h	; 77A91
mov edx, dword [byte ebp+022h]	; 77A94
mov eax, edx	; 77A97
shl eax, 2	; 77A99
sub eax, edx	; 77A9C
shl eax, 2	; 77A9E
sub eax, edx	; 77AA1
mov al, byte [nosplit eax*2+gmrosterjersey]	; 77AA3
mov byte [byte esi+ebp-07Eh], al	; 77AAA
xor esi, esi	; 77AAE
.89:
xor ecx, ecx	; 77AB0
mov cl, byte [byte ebp+06Ah]	; 77AB2
xor ebx, ebx	; 77AB5
mov bl, byte [byte ebp+06Eh]	; 77AB7
xor edx, edx	; 77ABA
mov dl, byte [byte esi+ebp-07Eh]	; 77ABC
mov eax, jerseyremap	; 77AC0
call MakeJerseyShape	; 77AC5
push jerseyremap	; 77ACA
call sub_B4DD4	; 77ACF
add esp, byte 4	; 77AD4
mov edx, dword [nosplit esi*8+dword_D145C]	; 77AD7
push edx	; 77ADE
mov ebx, dword [nosplit esi*8+dword_D1458]	; 77ADF
push ebx	; 77AE6
mov ecx, dword [dword ebp-0AAh]	; 77AE7
push ecx	; 77AED
call sub_931FC	; 77AEE
add esp, byte 0Ch	; 77AF3
inc esi	; 77AF6
cmp esi, byte 2	; 77AF7
jl short GameLineEditorLoop.89	; 77AFA
jmp near .94	; 77AFC
.90:
cmp byte [dword eax+gmroster], 47h	; 77B01
je near .94	; 77B08
mov bh, 64h	; 77B0E
.91:
mov edx, dword [byte ebp+022h]	; 77B10
mov eax, edx	; 77B13
shl eax, 2	; 77B15
sub eax, edx	; 77B18
shl eax, 2	; 77B1A
sub eax, edx	; 77B1D
mov dl, byte [byte esi+ebp-07Ch]	; 77B1F
cmp dl, byte [nosplit eax*2+gmrosterjersey]	; 77B23
jne short .92	; 77B2A
mov byte [byte esi+ebp-07Ch], bh	; 77B2C
.92:
inc esi	; 77B30
cmp esi, byte 2	; 77B31
jl short GameLineEditorLoop.91	; 77B34
mov esi, dword [byte ebp+01Eh]	; 77B36
sub esi, byte 26h	; 77B39
mov edx, dword [byte ebp+022h]	; 77B3C
mov eax, edx	; 77B3F
shl eax, 2	; 77B41
sub eax, edx	; 77B44
shl eax, 2	; 77B46
sub eax, edx	; 77B49
mov al, byte [nosplit eax*2+gmrosterjersey]	; 77B4B
mov byte [byte esi+ebp-07Ch], al	; 77B52
xor esi, esi	; 77B56
.93:
xor ecx, ecx	; 77B58
mov cl, byte [byte ebp+06Ah]	; 77B5A
xor ebx, ebx	; 77B5D
mov bl, byte [byte ebp+06Eh]	; 77B5F
xor edx, edx	; 77B62
mov dl, byte [byte esi+ebp-07Ch]	; 77B64
mov eax, jerseyremap	; 77B68
call MakeJerseyShape	; 77B6D
push jerseyremap	; 77B72
call sub_B4DD4	; 77B77
add esp, byte 4	; 77B7C
mov ecx, dword [nosplit esi*8+dword_D146C]	; 77B7F
push ecx	; 77B86
mov edi, dword [nosplit esi*8+dword_D1468]	; 77B87
push edi	; 77B8E
mov eax, dword [dword ebp-0AAh]	; 77B8F
push eax	; 77B95
call sub_931FC	; 77B96
add esp, byte 0Ch	; 77B9B
inc esi	; 77B9E
cmp esi, byte 2	; 77B9F
jl short GameLineEditorLoop.93	; 77BA2
.94:
mov dword [menuact_savelines], MenuSaveTheseLines	; 77BA4
mov esi, MenuUseTheseLines	; 77BAE
mov dword [menuact_uselines], esi	; 77BB3
mov dword [menuact_uselines2], esi	; 77BB9
mov eax, MenuSaveDefaultLines	; 77BBF
mov dword [menuact_savedeflines], eax	; 77BC4
mov dword [menuact_savedeflines2], eax	; 77BC9
xor ebx, ebx	; 77BCE
mov dword [byte ebp+036h], ebx	; 77BD0
.95:
mov eax, dword [byte ebp+036h]	; 77BD3
cmp byte [dword eax+ebp-0A2h], 64h	; 77BD6
jne short .96	; 77BDE
xor edi, edi	; 77BE0
mov dword [menuact_savelines], edi	; 77BE2
mov dword [menuact_uselines], edi	; 77BE8
mov dword [menuact_uselines2], edi	; 77BEE
mov dword [menuact_savedeflines], edi	; 77BF4
mov dword [menuact_savedeflines2], edi	; 77BFA
jmp near .104	; 77C00
.96:
lea ecx, [byte eax+01h]	; 77C05
mov dword [byte ebp+036h], ecx	; 77C08
cmp ecx, byte 28h	; 77C0B
jl short GameLineEditorLoop.95	; 77C0E
jmp near .104	; 77C10
.97:
mov edx, dword [byte ebp+01Eh]	; 77C15
cmp edx, byte 64h	; 77C18
jl near .104	; 77C1B
lea ebx, [byte edx-064h]	; 77C21
mov dword [byte ebp+01Eh], ebx	; 77C24
mov edx, ebx	; 77C27
mov eax, ebx	; 77C29
shl eax, 2	; 77C2B
sub eax, ebx	; 77C2E
shl eax, 2	; 77C30
sub eax, ebx	; 77C33
xor edx, ebx	; 77C35
mov dl, byte [nosplit eax*2+gmrosterslot]	; 77C37
mov ebx, edx	; 77C3E
shl ebx, 2	; 77C40
add ebx, edx	; 77C43
shl ebx, 3	; 77C45
sub ebx, edx	; 77C48
xor edx, edx	; 77C4A
mov dl, byte [byte ebp+072h]	; 77C4C
mov eax, edx	; 77C4F
shl eax, 4	; 77C51
add eax, edx	; 77C54
shl eax, 4	; 77C56
add eax, edx	; 77C59
shl eax, 2	; 77C5B
add eax, ebx	; 77C5E
mov ch, byte [dword eax+hmroster]	; 77C60
test ch, ch	; 77C66
je near .104	; 77C68
cmp ch, 4	; 77C6E
je short .98	; 77C71
cmp ch, 3	; 77C73
je short .98	; 77C76
cmp ch, 2	; 77C78
jne near .104	; 77C7B
cmp dword [curperiod], byte 0	; 77C81
jge near .104	; 77C88
.98:
mov esi, dword [byte ebp+022h]	; 77C8E
cmp esi, byte 0FFFFFFFFh	; 77C91
je near .101	; 77C94
mov edx, esi	; 77C9A
mov eax, esi	; 77C9C
shl eax, 2	; 77C9E
sub eax, esi	; 77CA1
shl eax, 2	; 77CA3
sub eax, esi	; 77CA6
xor edx, esi	; 77CA8
mov dl, byte [nosplit eax*2+gmrosterslot]	; 77CAA
mov ebx, edx	; 77CB1
shl ebx, 2	; 77CB3
add ebx, edx	; 77CB6
shl ebx, 3	; 77CB8
sub ebx, edx	; 77CBB
xor edx, edx	; 77CBD
mov dl, byte [byte ebp+072h]	; 77CBF
mov eax, edx	; 77CC2
shl eax, 4	; 77CC4
add eax, edx	; 77CC7
shl eax, 4	; 77CC9
add eax, edx	; 77CCC
cmp byte [dword ebx+eax*4+hmroster], 2	; 77CCE
jne short .99	; 77CD6
push dword 0C1h	; 77CD8
push dword 0FCh	; 77CDD
jmp short .100	; 77CE2
.99:
push dword 0C1h	; 77CE4
push dword 0C3h	; 77CE9
.100:
call sub_8E9C0	; 77CEE
add esp, byte 8	; 77CF3
mov edx, dword [byte ebp+022h]	; 77CF6
mov eax, edx	; 77CF9
shl eax, 2	; 77CFB
sub eax, edx	; 77CFE
shl eax, 2	; 77D00
sub eax, edx	; 77D03
add eax, eax	; 77D05
mov edx, gmroster	; 77D07
add edx, eax	; 77D0C
add edx, byte 3	; 77D0E
push edx	; 77D11
xor edx, edx	; 77D12
mov dl, byte [dword eax+gmrosterjersey]	; 77D14
push edx	; 77D1A
mov al, byte [dword eax+gmroster]	; 77D1B
and eax, 0FFh	; 77D21
push eax	; 77D26
push str_C2dS3	; 77D27
lea eax, [byte ebp-052h]	; 77D2C
push eax	; 77D2F
call sprintf_	; 77D30
add esp, byte 14h	; 77D35
mov edx, dword [byte ebp+022h]	; 77D38
mov eax, edx	; 77D3B
shl eax, 2	; 77D3D
sub eax, edx	; 77D40
shl eax, 2	; 77D42
add eax, edx	; 77D45
lea edx, [byte eax+016h]	; 77D47
lea ebx, [byte ebp-052h]	; 77D4A
mov eax, 1FAh	; 77D4D
call PrintLineEdStatus	; 77D52
.101:
mov eax, dword [byte ebp+01Eh]	; 77D57
mov dword [byte ebp+022h], eax	; 77D5A
mov dword [menuact_gamedress], GameDressPlayer	; 77D5D
mov dword [menuact_gamescratch], GameScratchPlayer	; 77D67
mov edx, dword [byte ebp+01Eh]	; 77D71
mov eax, edx	; 77D74
shl eax, 2	; 77D76
sub eax, edx	; 77D79
shl eax, 2	; 77D7B
sub eax, edx	; 77D7E
xor edx, edx	; 77D80
mov dl, byte [nosplit eax*2+gmrosterslot]	; 77D82
mov ebx, edx	; 77D89
shl ebx, 2	; 77D8B
add ebx, edx	; 77D8E
shl ebx, 3	; 77D90
sub ebx, edx	; 77D93
xor edx, edx	; 77D95
mov dl, byte [byte ebp+072h]	; 77D97
mov eax, edx	; 77D9A
shl eax, 4	; 77D9C
add eax, edx	; 77D9F
shl eax, 4	; 77DA1
add eax, edx	; 77DA4
cmp byte [dword ebx+eax*4+hmroster], 2	; 77DA6
jne short .102	; 77DAE
push dword 0C1h	; 77DB0
push dword 0FDh	; 77DB5
jmp short .103	; 77DBA
.102:
push dword 0C1h	; 77DBC
push dword 0C0h	; 77DC1
.103:
call sub_8E9C0	; 77DC6
add esp, byte 8	; 77DCB
mov edx, dword [byte ebp+022h]	; 77DCE
mov eax, edx	; 77DD1
shl eax, 2	; 77DD3
sub eax, edx	; 77DD6
shl eax, 2	; 77DD8
sub eax, edx	; 77DDB
add eax, eax	; 77DDD
mov edx, gmroster	; 77DDF
add edx, eax	; 77DE4
add edx, byte 3	; 77DE6
push edx	; 77DE9
xor edx, edx	; 77DEA
mov dl, byte [dword eax+gmrosterjersey]	; 77DEC
push edx	; 77DF2
mov al, byte [dword eax+gmroster]	; 77DF3
and eax, 0FFh	; 77DF9
push eax	; 77DFE
push str_C2dS3	; 77DFF
lea eax, [byte ebp-052h]	; 77E04
push eax	; 77E07
call sprintf_	; 77E08
add esp, byte 14h	; 77E0D
mov edx, dword [byte ebp+022h]	; 77E10
mov eax, edx	; 77E13
shl eax, 2	; 77E15
sub eax, edx	; 77E18
shl eax, 2	; 77E1A
add eax, edx	; 77E1D
lea edx, [byte eax+016h]	; 77E1F
lea ebx, [byte ebp-052h]	; 77E22
mov eax, 1FAh	; 77E25
call PrintLineEdStatus	; 77E2A
.104:
mov edx, dword [byte ebp+02Eh]	; 77E2F
cmp edx, byte 20h	; 77E32
jge short .105	; 77E35
xor eax, eax	; 77E37
jmp short .106	; 77E39
.105:
lea eax, [byte edx-020h]	; 77E3B
.106:
push eax	; 77E3E
mov ebx, dword [byte ebp+032h]	; 77E3F
cmp ebx, byte 1Ch	; 77E42
jge short .107	; 77E45
xor eax, eax	; 77E47
jmp short .108	; 77E49
.107:
lea eax, [byte ebx-01Ch]	; 77E4B
.108:
push eax	; 77E4E
mov ecx, dword [byte ebp+05Ah]	; 77E4F
push ecx	; 77E52
call sub_91400	; 77E53
add esp, byte 0Ch	; 77E58
mov eax, dword [byte ebp+02Eh]	; 77E5B
mov edx, dword [byte ebp+0Eh]	; 77E5E
cmp eax, dword [byte edx+0Ch]	; 77E61
jle near .110	; 77E64
mov edi, dword [byte ebp+032h]	; 77E6A
cmp edi, 1F4h	; 77E6D
jge near .110	; 77E73
cmp dword [byte ebp+022h], byte 0FFFFFFFFh	; 77E79
je near .110	; 77E7D
cmp dword [byte ebp+012h], byte 0	; 77E83
je short .109	; 77E87
lea eax, [byte ebp+026h]	; 77E89
push eax	; 77E8C
lea eax, [byte ebp+02Ah]	; 77E8D
push eax	; 77E90
lea eax, [byte ebp-072h]	; 77E91
push eax	; 77E94
lea eax, [byte ebp-012h]	; 77E95
push eax	; 77E98
mov ecx, dword [byte ebp+066h]	; 77E99
lea ebx, [byte ebp+0Eh]	; 77E9C
mov edx, dword [byte ebp+02Eh]	; 77E9F
mov eax, edi	; 77EA2
call MenuHitTest	; 77EA4
test eax, eax	; 77EA9
jne near .110	; 77EAB
.109:
mov edx, dword [byte ebp+022h]	; 77EB1
mov eax, edx	; 77EB4
shl eax, 2	; 77EB6
sub eax, edx	; 77EB9
shl eax, 2	; 77EBB
sub eax, edx	; 77EBE
lea edx, [eax+eax]	; 77EC0
xor ebx, ebx	; 77EC3
mov bl, byte [dword edx+gmrosterslot]	; 77EC5
mov ecx, ebx	; 77ECB
shl ecx, 2	; 77ECD
add ecx, ebx	; 77ED0
shl ecx, 3	; 77ED2
sub ecx, ebx	; 77ED5
xor ebx, ebx	; 77ED7
mov bl, byte [byte ebp+072h]	; 77ED9
mov eax, ebx	; 77EDC
shl eax, 4	; 77EDE
add eax, ebx	; 77EE1
shl eax, 4	; 77EE3
add eax, ebx	; 77EE6
cmp byte [dword ecx+eax*4+hmroster], 2	; 77EE8
je short .110	; 77EF0
xor ecx, ecx	; 77EF2
mov cl, byte [byte ebp+06Ah]	; 77EF4
xor ebx, ebx	; 77EF7
mov bl, byte [byte ebp+06Eh]	; 77EF9
mov dl, byte [dword edx+gmrosterjersey]	; 77EFC
and edx, 0FFh	; 77F02
mov eax, jerseyremap	; 77F08
call MakeJerseyShape	; 77F0D
push jerseyremap	; 77F12
call sub_B4DD4	; 77F17
add esp, byte 4	; 77F1C
mov eax, dword [byte ebp+02Eh]	; 77F1F
sub eax, byte 20h	; 77F22
push eax	; 77F25
mov eax, dword [byte ebp+032h]	; 77F26
sub eax, byte 1Ch	; 77F29
push eax	; 77F2C
mov ebx, dword [dword ebp-0AAh]	; 77F2D
push ebx	; 77F33
call sub_91FE0	; 77F34
add esp, byte 0Ch	; 77F39
.110:
mov ecx, dword [byte ebp+02Eh]	; 77F3C
push ecx	; 77F3F
mov eax, dword [byte ebp+032h]	; 77F40
sub eax, byte 3	; 77F43
push eax	; 77F46
mov esi, dword [pointerspr]	; 77F47
push esi	; 77F4D
jmp near GameLineEditorLoop.30	; 77F4E
.111:
call ClearInputQueue	; 77F53
mov edi, dword [byte ebp+05Ah]	; 77F58
push edi	; 77F5B
call FreeMemBlock	; 77F5C
add esp, byte 4	; 77F61
xor eax, eax	; 77F64
lea esp, [byte ebp+076h]	; 77F66
pop ebp	; 77F69
pop edi	; 77F6A
pop esi	; 77F6B
ret 0Ch	; 77F6C
; C: src/front/game_lines/LineEdHitTest.c
%ifdef CBUILD
%include "c/front/game_lines/LineEdHitTest.inc"
%else
LineEdHitTest:
push dword 14h	; 77F6F
call __CHK	; 77F74
push ecx	; 77F79
push esi	; 77F7A
push edi	; 77F7B
push ebp	; 77F7C
mov ecx, eax	; 77F7D
mov esi, edx	; 77F7F
mov edi, ebx	; 77F81
lea ecx, [byte eax+04h]	; 77F83
cmp ecx, 1F4h	; 77F86
jge short .4	; 77F8C
xor edx, edx	; 77F8E
.1:
mov eax, edx	; 77F90
shl eax, 3	; 77F92
mov ebx, dword [dword eax+lineslotx]	; 77F95
cmp ecx, ebx	; 77F9B
jl short .3	; 77F9D
add ebx, byte 3Ah	; 77F9F
cmp ecx, ebx	; 77FA2
jge short .3	; 77FA4
mov ebp, dword [dword eax+linesloty]	; 77FA6
cmp esi, ebp	; 77FAC
jl short .3	; 77FAE
lea eax, [byte ebp+028h]	; 77FB0
cmp esi, eax	; 77FB3
jge short .3	; 77FB5
mov dword [edi], edx	; 77FB7
.2:
mov eax, 1	; 77FB9
pop ebp	; 77FBE
pop edi	; 77FBF
pop esi	; 77FC0
pop ecx	; 77FC1
ret	; 77FC2
.3:
inc edx	; 77FC3
cmp edx, byte 28h	; 77FC4
jl short LineEdHitTest.1	; 77FC7
jmp short .5	; 77FC9
.4:
cmp edx, byte 16h	; 77FCB
jl short .5	; 77FCE
cmp edx, 182h	; 77FD0
jge short .5	; 77FD6
sub edx, byte 16h	; 77FD8
mov ebx, 0Dh	; 77FDB
mov eax, edx	; 77FE0
sar edx, 1Fh	; 77FE2
idiv ebx	; 77FE5
add eax, byte 64h	; 77FE7
mov dword [edi], eax	; 77FEA
jmp short LineEdHitTest.2	; 77FEC
.5:
xor eax, eax	; 77FEE
pop ebp	; 77FF0
pop edi	; 77FF1
pop esi	; 77FF2
pop ecx	; 77FF3
ret	; 77FF4
%endif ; C
LoadGameRoster:
push dword 0ACh	; 77FF5
call __CHK	; 77FFA
push ebx	; 77FFF
push ecx	; 78000
push edx	; 78001
push esi	; 78002
push edi	; 78003
push ebp	; 78004
sub esp, 84h	; 78005
mov edi, eax	; 7800B
xor edx, edx	; 7800D
mov dword [dword esp+080h], edx	; 7800F
.1:
mov edx, dword [dword esp+080h]	; 78016
mov eax, edx	; 7801D
shl eax, 2	; 7801F
sub eax, edx	; 78022
shl eax, 2	; 78024
sub eax, edx	; 78027
mov dl, byte [dword esp+080h]	; 78029
mov byte [nosplit eax*2+gmrosterslot], dl	; 78030
mov ebx, dword [dword esp+080h]	; 78037
inc ebx	; 7803E
mov dword [dword esp+080h], ebx	; 7803F
cmp ebx, byte 1Ch	; 78046
jl short LoadGameRoster.1	; 78049
push str_Key	; 7804B
push leaguedbfmt	; 78050
lea eax, [byte esp+068h]	; 78055
push eax	; 78059
call sprintf_	; 7805A
add esp, byte 0Ch	; 7805F
lea ebx, [byte esp+034h]	; 78062
xor edx, edx	; 78066
lea eax, [byte esp+060h]	; 78068
call unknown_libname_1	; 7806C
test eax, eax	; 78071
je short .2	; 78073
push str_ErrA1	; 78075
call FatalError	; 7807A
add esp, byte 4	; 7807F
.2:
push dword 200h	; 78082
lea eax, [byte esp+064h]	; 78087
push eax	; 7808B
call open_	; 7808C
add esp, byte 8	; 78091
mov esi, eax	; 78094
test eax, eax	; 78096
jge short .3	; 78098
push str_ErrA2	; 7809A
call FatalError	; 7809F
add esp, byte 4	; 780A4
.3:
xor ebp, ebp	; 780A7
mov dword [dword esp+080h], ebp	; 780A9
.4:
mov eax, edi	; 780B0
shl eax, 2	; 780B2
sub eax, edi	; 780B5
shl eax, 3	; 780B7
mov edx, eax	; 780BA
shl eax, 5	; 780BC
sub eax, edx	; 780BF
mov edx, eax	; 780C1
mov eax, dword [dword esp+080h]	; 780C3
cmp dword [dword edx+eax*4+dword_DBC7C], byte 0	; 780CA
jge short .5	; 780D2
mov edx, eax	; 780D4
shl eax, 2	; 780D6
sub eax, edx	; 780D9
shl eax, 2	; 780DB
sub eax, edx	; 780DE
xor bh, bh	; 780E0
mov byte [nosplit eax*2+gmroster], bh	; 780E2
jmp near .11	; 780E9
.5:
xor ebx, ebx	; 780EE
xor edx, edx	; 780F0
mov eax, esi	; 780F2
call lseek_	; 780F4
test eax, eax	; 780F9
je short .6	; 780FB
push str_ErrA3	; 780FD
call FatalError	; 78102
add esp, byte 4	; 78107
.6:
mov eax, edi	; 7810A
shl eax, 2	; 7810C
sub eax, edi	; 7810F
shl eax, 3	; 78111
mov edx, eax	; 78114
shl eax, 5	; 78116
sub eax, edx	; 78119
mov edx, dword [dword esp+080h]	; 7811B
mov edx, dword [dword eax+edx*4+dword_DBC7C]	; 78122
xor ebx, ebx	; 78129
mov eax, esi	; 7812B
call lseek_	; 7812D
test eax, eax	; 78132
jge short .7	; 78134
push str_ErrA4	; 78136
call FatalError	; 7813B
add esp, byte 4	; 78140
.7:
mov ebx, 34h	; 78143
mov edx, esp	; 78148
mov eax, esi	; 7814A
call read_	; 7814C
test eax, eax	; 78151
jl short .8	; 78153
cmp eax, byte 34h	; 78155
je short .9	; 78158
.8:
push str_ErrA5	; 7815A
call FatalError	; 7815F
add esp, byte 4	; 78164
.9:
mov edx, dword [dword esp+080h]	; 78167
mov eax, edx	; 7816E
shl eax, 2	; 78170
sub eax, edx	; 78173
shl eax, 2	; 78175
sub eax, edx	; 78178
lea edx, [eax+eax]	; 7817A
mov al, byte [byte esp+02h]	; 7817D
mov byte [dword edx+gmroster], al	; 78181
mov al, byte [byte esp+01h]	; 78187
mov byte [dword edx+gmrosterjersey], al	; 7818B
mov al, byte [byte esp+03h]	; 78191
mov byte [dword edx+byte_ED0F7], al	; 78195
mov byte [dword edx+byte_ED0F8], 2Eh	; 7819B
mov byte [dword edx+byte_ED0F9], 20h	; 781A2
xor eax, eax	; 781A9
.10:
mov ebx, dword [dword esp+080h]	; 781AB
mov edx, ebx	; 781B2
shl edx, 2	; 781B4
sub edx, ebx	; 781B7
shl edx, 2	; 781B9
sub edx, ebx	; 781BC
mov bl, byte [byte esp+eax+013h]	; 781BE
mov byte [dword eax+edx*2+byte_ED0FA], bl	; 781C2
inc eax	; 781C9
cmp eax, byte 10h	; 781CA
jl short LoadGameRoster.10	; 781CD
.11:
mov ecx, dword [dword esp+080h]	; 781CF
inc ecx	; 781D6
mov dword [dword esp+080h], ecx	; 781D7
cmp ecx, byte 19h	; 781DE
jl near LoadGameRoster.4	; 781E1
xor eax, eax	; 781E7
mov dword [dword esp+080h], eax	; 781E9
.12:
mov eax, edi	; 781F0
shl eax, 2	; 781F2
sub eax, edi	; 781F5
shl eax, 3	; 781F7
mov edx, eax	; 781FA
shl eax, 5	; 781FC
sub eax, edx	; 781FF
mov edx, eax	; 78201
mov eax, dword [dword esp+080h]	; 78203
cmp dword [dword edx+eax*4+dword_DBCE0], byte 0	; 7820A
jge short .13	; 78212
lea edx, [byte eax+019h]	; 78214
mov eax, edx	; 78217
shl eax, 2	; 78219
sub eax, edx	; 7821C
shl eax, 2	; 7821E
sub eax, edx	; 78221
xor dl, dl	; 78223
mov byte [nosplit eax*2+gmroster], dl	; 78225
jmp near .19	; 7822C
.13:
xor ebx, ebx	; 78231
xor edx, edx	; 78233
mov eax, esi	; 78235
call lseek_	; 78237
test eax, eax	; 7823C
je short .14	; 7823E
push str_ErrA6	; 78240
call FatalError	; 78245
add esp, byte 4	; 7824A
.14:
mov eax, edi	; 7824D
shl eax, 2	; 7824F
sub eax, edi	; 78252
shl eax, 3	; 78254
mov edx, eax	; 78257
shl eax, 5	; 78259
sub eax, edx	; 7825C
mov edx, dword [dword esp+080h]	; 7825E
mov edx, dword [dword eax+edx*4+dword_DBCE0]	; 78265
xor ebx, ebx	; 7826C
mov eax, esi	; 7826E
call lseek_	; 78270
test eax, eax	; 78275
jge short .15	; 78277
push str_ErrA7	; 78279
call FatalError	; 7827E
add esp, byte 4	; 78283
.15:
mov ebx, 34h	; 78286
mov edx, esp	; 7828B
mov eax, esi	; 7828D
call read_	; 7828F
test eax, eax	; 78294
jl short .16	; 78296
cmp eax, byte 34h	; 78298
je short .17	; 7829B
.16:
push str_ErrA8	; 7829D
call FatalError	; 782A2
add esp, byte 4	; 782A7
.17:
mov edx, dword [dword esp+080h]	; 782AA
add edx, byte 19h	; 782B1
mov eax, edx	; 782B4
shl eax, 2	; 782B6
sub eax, edx	; 782B9
shl eax, 2	; 782BB
sub eax, edx	; 782BE
lea edx, [eax+eax]	; 782C0
mov al, byte [byte esp+02h]	; 782C3
mov byte [dword edx+gmroster], al	; 782C7
mov al, byte [byte esp+01h]	; 782CD
mov byte [dword edx+gmrosterjersey], al	; 782D1
mov al, byte [byte esp+03h]	; 782D7
mov byte [dword edx+byte_ED0F7], al	; 782DB
mov byte [dword edx+byte_ED0F8], 2Eh	; 782E1
mov byte [dword edx+byte_ED0F9], 20h	; 782E8
xor eax, eax	; 782EF
.18:
mov ebx, dword [dword esp+080h]	; 782F1
add ebx, byte 19h	; 782F8
mov edx, ebx	; 782FB
shl edx, 2	; 782FD
sub edx, ebx	; 78300
shl edx, 2	; 78302
sub edx, ebx	; 78305
mov bl, byte [byte esp+eax+013h]	; 78307
mov byte [dword eax+edx*2+byte_ED0FA], bl	; 7830B
inc eax	; 78312
cmp eax, byte 10h	; 78313
jl short LoadGameRoster.18	; 78316
.19:
mov ecx, dword [dword esp+080h]	; 78318
inc ecx	; 7831F
mov dword [dword esp+080h], ecx	; 78320
cmp ecx, byte 3	; 78327
jl near LoadGameRoster.12	; 7832A
mov eax, esi	; 78330
call j___close_	; 78332
add esp, 84h	; 78337
pop ebp	; 7833D
pop edi	; 7833E
pop esi	; 7833F
pop edx	; 78340
pop ecx	; 78341
pop ebx	; 78342
ret	; 78343
db 08Bh,0C0h
DrawGameLineJerseys_jt:
dd DrawGameLineJerseys_st0
dd DrawGameLineJerseys_st1
dd DrawGameLineJerseys_st2
dd DrawGameLineJerseys_st2
dd DrawGameLineJerseys_st0
dd DrawGameLineJerseys_st0
dd DrawGameLineJerseys_join
dd DrawGameLineJerseys_st0
; C: src/front/game_lines/DrawGameLineJerseys.c
%ifdef CBUILD
%include "c/front/game_lines/DrawGameLineJerseys.inc"
%else
DrawGameLineJerseys:
push dword 58h	; 78366
call __CHK	; 7836B
push ecx	; 78370
push esi	; 78371
push edi	; 78372
push ebp	; 78373
sub esp, byte 2Ch	; 78374
push eax	; 78377
mov ebp, edx	; 78378
mov byte [byte esp+024h], bl	; 7837A
test bl, bl	; 7837E
je short .1	; 78380
mov ax, word [VisTeam]	; 78382
jmp short .2	; 78388
.1:
mov ax, word [HomeTeam]	; 7838A
.2:
cwde	; 78390
mov al, byte [nosplit eax*4+byte_D11BC]	; 78391
mov byte [byte esp+02Ch], al	; 78398
xor eax, eax	; 7839C
mov al, byte [byte esp+02Ch]	; 7839E
mov al, byte [dword eax+jerseyremap]	; 783A2
mov byte [byte esp+02Ch], al	; 783A8
mov al, byte [byte_D12DE]	; 783AC
mov byte [byte esp+028h], al	; 783B1
xor esi, esi	; 783B5
.3:
xor ecx, ecx	; 783B7
mov cl, byte [byte esp+028h]	; 783B9
xor ebx, ebx	; 783BD
mov bl, byte [byte esp+02Ch]	; 783BF
mov eax, dword [esp]	; 783C3
xor edx, edx	; 783C6
mov dl, byte [esi+eax]	; 783C8
mov eax, jerseyremap	; 783CB
call MakeJerseyShape	; 783D0
push jerseyremap	; 783D5
call sub_B4DD4	; 783DA
add esp, byte 4	; 783DF
mov edx, dword [nosplit esi*8+linesloty]	; 783E2
push edx	; 783E9
mov ebx, dword [nosplit esi*8+lineslotx]	; 783EA
push ebx	; 783F1
push ebp	; 783F2
call sub_931FC	; 783F3
add esp, byte 0Ch	; 783F8
inc esi	; 783FB
cmp esi, byte 28h	; 783FC
jl short DrawGameLineJerseys.3	; 783FF
xor esi, esi	; 78401
.4:
mov edx, esi	; 78403
mov eax, esi	; 78405
shl eax, 2	; 78407
sub eax, esi	; 7840A
shl eax, 2	; 7840C
sub eax, esi	; 7840F
xor edx, esi	; 78411
mov dl, byte [nosplit eax*2+gmrosterslot]	; 78413
mov ebx, edx	; 7841A
shl ebx, 2	; 7841C
add ebx, edx	; 7841F
shl ebx, 3	; 78421
sub ebx, edx	; 78424
xor edx, edx	; 78426
mov dl, byte [byte esp+024h]	; 78428
mov eax, edx	; 7842C
shl eax, 4	; 7842E
add eax, edx	; 78431
shl eax, 4	; 78433
add eax, edx	; 78436
shl eax, 2	; 78438
add eax, ebx	; 7843B
mov dl, byte [dword eax+hmroster]	; 7843D
test dl, dl	; 78443
je near DrawGameLineJerseys_join.x	; 78445
mov al, dl	; 7844B
dec al	; 7844D
cmp al, 7	; 7844F
ja short DrawGameLineJerseys_join	; 78451
and eax, 0FFh	; 78453
jmp dword [nosplit cs:eax*4+DrawGameLineJerseys_jt]	; 78458
DrawGameLineJerseys_st1:
cmp dword [curperiod], byte 0	; 78460
jge short .1	; 78467
mov edi, 0FCh	; 78469
jmp short DrawGameLineJerseys_join	; 7846E
.1:
mov edi, 0C2h	; 78470
jmp short DrawGameLineJerseys_join	; 78475
DrawGameLineJerseys_st2:
mov edi, 0C3h	; 78477
jmp short DrawGameLineJerseys_join	; 7847C
DrawGameLineJerseys_st0:
mov edi, 0C2h	; 7847E
DrawGameLineJerseys_join:
push dword 0C1h	; 78483
push edi	; 78488
call sub_8E9C0	; 78489
add esp, byte 8	; 7848E
mov eax, esi	; 78491
shl eax, 2	; 78493
sub eax, esi	; 78496
shl eax, 2	; 78498
sub eax, esi	; 7849B
add eax, eax	; 7849D
mov edx, gmroster	; 7849F
add edx, eax	; 784A4
add edx, byte 3	; 784A6
push edx	; 784A9
xor edx, edx	; 784AA
mov dl, byte [dword eax+gmrosterjersey]	; 784AC
push edx	; 784B2
mov al, byte [dword eax+gmroster]	; 784B3
and eax, 0FFh	; 784B9
push eax	; 784BE
push str_C2dS3	; 784BF
lea eax, [byte esp+014h]	; 784C4
push eax	; 784C8
call sprintf_	; 784C9
add esp, byte 14h	; 784CE
mov eax, esi	; 784D1
shl eax, 2	; 784D3
sub eax, esi	; 784D6
shl eax, 2	; 784D8
add eax, esi	; 784DB
lea edx, [byte eax+016h]	; 784DD
lea ebx, [byte esp+04h]	; 784E0
mov eax, 1FAh	; 784E4
call PrintLineEdStatus	; 784E9
inc esi	; 784EE
cmp esi, byte 1Ch	; 784EF
jl near DrawGameLineJerseys.4	; 784F2
.x:
add esp, byte 30h	; 784F8
pop ebp	; 784FB
pop edi	; 784FC
pop esi	; 784FD
pop ecx	; 784FE
ret	; 784FF
%endif ; C
; C: src/front/game_lines/DrawLineEditorScreen.c
%ifdef CBUILD
%include "c/front/game_lines/DrawLineEditorScreen.inc"
%else
DrawLineEditorScreen:
push dword 178h	; 78500
call __CHK	; 78505
push esi	; 7850A
push edi	; 7850B
push ebp	; 7850C
sub esp, 15Ch	; 7850D
mov edi, eax	; 78513
mov ebp, ecx	; 78515
mov dword [dword esp+0154h], 0C0h	; 78517
mov dword [dword esp+0150h], 0C1h	; 78522
mov dword [dword esp+0158h], 0C2h	; 7852D
shl eax, 2	; 78538
sub eax, edi	; 7853B
shl eax, 3	; 7853D
mov edx, eax	; 78540
shl eax, 5	; 78542
sub eax, edx	; 78545
add eax, hmteamrec	; 78547
push eax	; 7854C
push str_EmbS	; 7854D
lea eax, [dword esp+0148h]	; 78552
push eax	; 78559
call sprintf_	; 7855A
add esp, byte 0Ch	; 7855F
xor ecx, ecx	; 78562
lea ebx, [dword esp+0140h]	; 78564
cmp byte [fileoncd+070h], 1	; 7856B
jne short .1	; 78572
mov edx, dword [cddriveptr]	; 78574
jmp short .2	; 7857A
.1:
xor edx, edx	; 7857C
.2:
lea eax, [dword esp+0100h]	; 7857E
call MakePath	; 78585
push byte 0	; 7858A
lea eax, [dword esp+0104h]	; 7858C
push eax	; 78593
call sub_8E83C	; 78594
add esp, byte 8	; 78599
mov esi, eax	; 7859C
xor eax, eax	; 7859E
.3:
mov byte [esp+eax], al	; 785A0
inc eax	; 785A3
cmp eax, 100h	; 785A4
jl short DrawLineEditorScreen.3	; 785A9
mov ecx, str_extBIN	; 785AB
mov ebx, str_HOMEPALS3	; 785B0
cmp byte [fileoncd+0A1h], 1	; 785B5
jne short .4	; 785BC
mov edx, dword [cddriveptr]	; 785BE
jmp short .5	; 785C4
.4:
xor edx, edx	; 785C6
.5:
lea eax, [dword esp+0100h]	; 785C8
call MakePath	; 785CF
push byte 0	; 785D4
lea eax, [dword esp+0104h]	; 785D6
push eax	; 785DD
call sub_8E8A0	; 785DE
add esp, byte 8	; 785E3
mov ecx, eax	; 785E6
test edi, edi	; 785E8
je short .6	; 785EA
mov ax, word [VisTeam]	; 785EC
jmp short .7	; 785F2
.6:
mov ax, word [HomeTeam]	; 785F4
.7:
movsx edx, ax	; 785FA
mov eax, edx	; 785FD
shl eax, 3	; 785FF
sub eax, edx	; 78602
shl eax, 6	; 78604
lea ebx, [dword ecx+0C0h]	; 78607
add ebx, eax	; 7860D
mov eax, 80h	; 7860F
.8:
mov dl, byte [ebx+eax]	; 78614
mov byte [esp+eax], dl	; 78617
inc eax	; 7861A
cmp eax, 100h	; 7861B
jl short DrawLineEditorScreen.8	; 78620
push ecx	; 78622
call FreeMemBlock	; 78623
add esp, byte 4	; 78628
mov eax, esp	; 7862B
push eax	; 7862D
call sub_B4DD4	; 7862E
add esp, byte 4	; 78633
push byte 0	; 78636
push byte 0FFFFFFB4h	; 78638
push str_Bkgd10	; 7863A
push esi	; 7863F
call sub_B30B4	; 78640
add esp, byte 8	; 78645
push eax	; 78648
call sub_91FE0	; 78649
add esp, byte 0Ch	; 7864E
push esi	; 78651
call FreeMemBlock	; 78652
add esp, byte 4	; 78657
mov esi, dword [dword esp+0158h]	; 7865A
push esi	; 78661
mov ecx, dword [dword esp+0154h]	; 78662
mov ebx, dword [dword esp+0158h]	; 78669
mov edx, dword [dword esp+0170h]	; 78670
mov eax, ebp	; 78677
call DrawMenuBar	; 78679
push dword 0C1h	; 7867E
push dword 0C0h	; 78683
call sub_8E9C0	; 78688
add esp, byte 8	; 7868D
push byte 1	; 78690
mov ecx, 1DFh	; 78692
mov ebx, 27Fh	; 78697
mov edx, 13h	; 7869C
mov eax, 1F4h	; 786A1
call DrawDlgFrame	; 786A6
xor ecx, ecx	; 786AB
mov ebx, str_Lelogo2	; 786AD
cmp byte [fileoncd+021Bh], 1	; 786B2
jne short .9	; 786B9
mov edx, dword [cddriveptr]	; 786BB
jmp short .10	; 786C1
.9:
xor edx, edx	; 786C3
.10:
lea eax, [dword esp+0100h]	; 786C5
call MakePath	; 786CC
push byte 0	; 786D1
lea eax, [dword esp+0104h]	; 786D3
push eax	; 786DA
call sub_8E83C	; 786DB
add esp, byte 8	; 786E0
mov esi, eax	; 786E3
test edi, edi	; 786E5
je short .11	; 786E7
mov ax, word [VisTeam]	; 786E9
jmp short .12	; 786EF
.11:
mov ax, word [HomeTeam]	; 786F1
.12:
cwde	; 786F7
mov edi, dword [nosplit eax*4+crestnames]	; 786F8
push edi	; 786FF
push esi	; 78700
call sub_B30B4	; 78701
add esp, byte 8	; 78706
push dword 191h	; 78709
push dword 218h	; 7870E
push eax	; 78713
call sub_91370	; 78714
add esp, byte 0Ch	; 78719
push esi	; 7871C
call FreeMemBlock	; 7871D
add esp, byte 4	; 78722
push byte 1	; 78725
mov ecx, 54h	; 78727
mov ebx, 45h	; 7872C
mov edx, 2Ch	; 78731
mov eax, 5	; 78736
call DrawDlgFrame	; 7873B
push byte 33h	; 78740
push byte 0Ch	; 78742
push str_Forward	; 78744
call sub_91964	; 78749
add esp, byte 0Ch	; 7874E
push byte 40h	; 78751
push byte 13h	; 78753
push str_Line1	; 78755
call sub_91964	; 7875A
add esp, byte 0Ch	; 7875F
push byte 1	; 78762
mov ecx, 85h	; 78764
mov ebx, 45h	; 78769
mov edx, 5Dh	; 7876E
mov eax, 5	; 78773
call DrawDlgFrame	; 78778
push byte 64h	; 7877D
push byte 0Ch	; 7877F
push str_Forward	; 78781
call sub_91964	; 78786
add esp, byte 0Ch	; 7878B
push byte 71h	; 7878E
push byte 13h	; 78790
push str_Line2	; 78792
call sub_91964	; 78797
add esp, byte 0Ch	; 7879C
push byte 1	; 7879F
mov ecx, 0B6h	; 787A1
mov ebx, 45h	; 787A6
mov edx, 8Eh	; 787AB
mov eax, 5	; 787B0
call DrawDlgFrame	; 787B5
push dword 95h	; 787BA
push byte 0Ch	; 787BF
push str_Forward	; 787C1
call sub_91964	; 787C6
add esp, byte 0Ch	; 787CB
push dword 0A2h	; 787CE
push byte 13h	; 787D3
push str_Line3	; 787D5
call sub_91964	; 787DA
add esp, byte 0Ch	; 787DF
push byte 1	; 787E2
mov ecx, 0E7h	; 787E4
mov ebx, 45h	; 787E9
mov edx, 0BFh	; 787EE
mov eax, 5	; 787F3
call DrawDlgFrame	; 787F8
push dword 0C6h	; 787FD
push byte 0Ch	; 78802
push str_Forward	; 78804
call sub_91964	; 78809
add esp, byte 0Ch	; 7880E
push dword 0D3h	; 78811
push byte 13h	; 78816
push str_Line4	; 78818
call sub_91964	; 7881D
add esp, byte 0Ch	; 78822
push byte 1	; 78825
mov ecx, 122h	; 78827
mov ebx, 45h	; 7882C
mov edx, 0FAh	; 78831
mov eax, 5	; 78836
call DrawDlgFrame	; 7883B
push dword 101h	; 78840
push byte 10h	; 78845
push str_Power	; 78847
call sub_91964	; 7884C
add esp, byte 0Ch	; 78851
push dword 10Eh	; 78854
push byte 11h	; 78859
push str_Play1	; 7885B
call sub_91964	; 78860
add esp, byte 0Ch	; 78865
push byte 1	; 78868
mov ecx, 153h	; 7886A
mov ebx, 45h	; 7886F
mov edx, 12Bh	; 78874
mov eax, 5	; 78879
call DrawDlgFrame	; 7887E
push dword 132h	; 78883
push byte 10h	; 78888
push str_Power	; 7888A
call sub_91964	; 7888F
add esp, byte 0Ch	; 78894
push dword 13Fh	; 78897
push byte 11h	; 7889C
push str_Play2	; 7889E
call sub_91964	; 788A3
add esp, byte 0Ch	; 788A8
push byte 1	; 788AB
mov ecx, 18Eh	; 788AD
mov ebx, 45h	; 788B2
mov edx, 166h	; 788B7
mov eax, 5	; 788BC
call DrawDlgFrame	; 788C1
push dword 16Dh	; 788C6
push byte 0Ch	; 788CB
push str_Penalty	; 788CD
call sub_91964	; 788D2
add esp, byte 0Ch	; 788D7
push dword 17Ah	; 788DA
push byte 13h	; 788DF
push str_Kill1	; 788E1
call sub_91964	; 788E6
add esp, byte 0Ch	; 788EB
push byte 1	; 788EE
mov ecx, 1BFh	; 788F0
mov ebx, 45h	; 788F5
mov edx, 197h	; 788FA
mov eax, 5	; 788FF
call DrawDlgFrame	; 78904
push dword 19Eh	; 78909
push byte 0Ch	; 7890E
push str_Penalty	; 78910
call sub_91964	; 78915
add esp, byte 0Ch	; 7891A
push dword 1ABh	; 7891D
push byte 13h	; 78922
push str_Kill2	; 78924
call sub_91964	; 78929
add esp, byte 0Ch	; 7892E
push byte 1	; 78931
mov ecx, 54h	; 78933
mov ebx, 154h	; 78938
mov edx, 2Ch	; 7893D
mov eax, 114h	; 78942
call DrawDlgFrame	; 78947
push byte 33h	; 7894C
push dword 11Bh	; 7894E
push str_Defense3	; 78953
call sub_91964	; 78958
add esp, byte 0Ch	; 7895D
push byte 40h	; 78960
push dword 120h	; 78962
push str_Line1	; 78967
call sub_91964	; 7896C
add esp, byte 0Ch	; 78971
push byte 1	; 78974
mov ecx, 85h	; 78976
mov ebx, 154h	; 7897B
mov edx, 5Dh	; 78980
mov eax, 114h	; 78985
call DrawDlgFrame	; 7898A
push byte 64h	; 7898F
push dword 11Bh	; 78991
push str_Defense3	; 78996
call sub_91964	; 7899B
add esp, byte 0Ch	; 789A0
push byte 71h	; 789A3
push dword 120h	; 789A5
push str_Line2	; 789AA
call sub_91964	; 789AF
add esp, byte 0Ch	; 789B4
push byte 1	; 789B7
mov ecx, 0B6h	; 789B9
mov ebx, 154h	; 789BE
mov edx, 8Eh	; 789C3
mov eax, 114h	; 789C8
call DrawDlgFrame	; 789CD
push dword 95h	; 789D2
push dword 11Bh	; 789D7
push str_Defense3	; 789DC
call sub_91964	; 789E1
add esp, byte 0Ch	; 789E6
push dword 0A2h	; 789E9
push dword 120h	; 789EE
push str_Line3	; 789F3
call sub_91964	; 789F8
add esp, byte 0Ch	; 789FD
push byte 1	; 78A00
mov ecx, 0F0h	; 78A02
mov ebx, 1E4h	; 78A07
mov edx, 0C8h	; 78A0C
mov eax, 186h	; 78A11
call DrawDlgFrame	; 78A16
push dword 0D5h	; 78A1B
push dword 18Fh	; 78A20
push str_Goaltenders	; 78A25
call sub_91964	; 78A2A
add esp, byte 0Ch	; 78A2F
push byte 1	; 78A32
mov ecx, 18Eh	; 78A34
mov ebx, 1C7h	; 78A39
mov edx, 166h	; 78A3E
mov eax, 173h	; 78A43
call DrawDlgFrame	; 78A48
push dword 16Dh	; 78A4D
push dword 189h	; 78A52
push str_Extra	; 78A57
call sub_91964	; 78A5C
add esp, byte 0Ch	; 78A61
push dword 17Ah	; 78A64
push dword 17Dh	; 78A69
push str_Attackers	; 78A6E
call sub_91964	; 78A73
add esp, byte 0Ch	; 78A78
add esp, 15Ch	; 78A7B
StubRet4a:
pop ebp	; 78A81
pop edi	; 78A82
pop esi	; 78A83
ret 4	; 78A84
%endif ; C
; C: src/front/game_lines/LoadJerseyColours.c
%ifdef CBUILD
%include "c/front/game_lines/LoadJerseyColours.inc"
%else
LoadJerseyColours:
push dword 2Ch	; 78A87
call __CHK	; 78A8C
push ecx	; 78A91
push esi	; 78A92
push edi	; 78A93
push ebp	; 78A94
sub esp, byte 10h	; 78A95
mov edi, eax	; 78A98
mov esi, ebx	; 78A9A
mov ecx, str_extBIN	; 78A9C
mov ebx, str_HOMEPALS3	; 78AA1
cmp byte [fileoncd+0A1h], 1	; 78AA6
jne short .1	; 78AAD
mov edx, dword [cddriveptr]	; 78AAF
jmp short .2	; 78AB5
.1:
xor edx, edx	; 78AB7
.2:
mov eax, esp	; 78AB9
call MakePath	; 78ABB
push byte 0	; 78AC0
lea eax, [byte esp+04h]	; 78AC2
push eax	; 78AC6
call sub_8E8A0	; 78AC7
add esp, byte 8	; 78ACC
mov ebp, eax	; 78ACF
test edi, edi	; 78AD1
je short .3	; 78AD3
mov ax, word [VisTeam]	; 78AD5
jmp short .4	; 78ADB
.3:
mov ax, word [HomeTeam]	; 78ADD
.4:
movsx edx, ax	; 78AE3
mov eax, edx	; 78AE6
shl eax, 3	; 78AE8
sub eax, edx	; 78AEB
shl eax, 6	; 78AED
lea ebx, [eax+ebp]	; 78AF0
xor eax, eax	; 78AF3
.5:
mov cl, byte [ebx+eax]	; 78AF5
mov byte [dword esi+eax+0CCh], cl	; 78AF8
inc eax	; 78AFF
cmp eax, 0B4h	; 78B00
jl short LoadJerseyColours.5	; 78B05
mov eax, 0B4h	; 78B07
.6:
mov dl, byte [ebx+eax]	; 78B0C
mov byte [dword esi+eax+0198h], dl	; 78B0F
inc eax	; 78B16
cmp eax, 0C0h	; 78B17
jl short LoadJerseyColours.6	; 78B1C
mov byte [dword esi+0264h], 18h	; 78B1E
mov byte [dword esi+0265h], 0	; 78B25
mov byte [dword esi+0266h], 0	; 78B2C
mov byte [dword esi+0267h], 2Ah	; 78B33
mov byte [dword esi+0268h], 0	; 78B3A
mov byte [dword esi+0269h], 0	; 78B41
mov byte [dword esi+026Ah], 3Bh	; 78B48
mov byte [dword esi+026Bh], 12h	; 78B4F
mov byte [dword esi+026Ch], 0	; 78B56
mov byte [dword esi+026Dh], 3Bh	; 78B5D
mov byte [dword esi+026Eh], 3Bh	; 78B64
mov byte [dword esi+026Fh], 3Bh	; 78B6B
mov eax, 80h	; 78B72
add ebx, 0C0h	; 78B77
.7:
lea edx, [ebx+eax]	; 78B7D
mov cl, byte [edx]	; 78B80
cmp cl, 80h	; 78B82
jge short .8	; 78B85
movsx esi, cl	; 78B87
cmp esi, 0BBh	; 78B8A
jg short .9	; 78B90
.8:
mov dl, byte [ebx+eax]	; 78B92
sub dl, 3Ch	; 78B95
jmp short .10	; 78B98
.9:
mov dl, cl	; 78B9A
add dl, 8	; 78B9C
.10:
mov byte [dword eax+jerseyremap], dl	; 78B9F
inc eax	; 78BA5
cmp eax, 0FFh	; 78BA6
jl short LoadJerseyColours.7	; 78BAB
mov byte [byte_D1333], 0FBh	; 78BAD
mov byte [byte_D1334], 0FCh	; 78BB4
mov byte [byte_D1335], 0FDh	; 78BBB
mov byte [byte_D1336], 0FEh	; 78BC2
push ebp	; 78BC9
call FreeMemBlock	; 78BCA
add esp, byte 4	; 78BCF
push jerseyremap	; 78BD2
call sub_B4DD4	; 78BD7
add esp, byte 4	; 78BDC
add esp, byte 10h	; 78BDF
pop ebp	; 78BE2
pop edi	; 78BE3
pop esi	; 78BE4
pop ecx	; 78BE5
ret	; 78BE6
%endif ; C
; C: src/front/game_lines/DrawLineEditorScreen.c (DrawDlgFrame)
%ifdef CBUILD
%include "c/front/game_lines/DrawLineEditorScreen.DrawDlgFrame.inc"
%else
DrawDlgFrame:
push dword 38h	; 78BE7
call __CHK	; 78BEC
push esi	; 78BF1
push edi	; 78BF2
push ebp	; 78BF3
sub esp, byte 14h	; 78BF4
mov esi, eax	; 78BF7
mov edi, edx	; 78BF9
mov ebp, ebx	; 78BFB
mov dword [byte esp+010h], ecx	; 78BFD
mov edx, dword [dlgfillcol]	; 78C01
push edx	; 78C07
mov eax, ecx	; 78C08
sub eax, edi	; 78C0A
inc eax	; 78C0C
push eax	; 78C0D
mov eax, ebx	; 78C0E
sub eax, esi	; 78C10
inc eax	; 78C12
push eax	; 78C13
push edi	; 78C14
push esi	; 78C15
call sub_90D20	; 78C16
add esp, byte 14h	; 78C1B
mov ebx, dword [dlgedgecol1]	; 78C1E
push ebx	; 78C24
push edi	; 78C25
lea eax, [byte ebp-01h]	; 78C26
push eax	; 78C29
push edi	; 78C2A
push esi	; 78C2B
call sub_B4FAC	; 78C2C
add esp, byte 14h	; 78C31
mov ecx, dword [dlgedgecol1]	; 78C34
push ecx	; 78C3A
mov eax, dword [byte esp+014h]	; 78C3B
dec eax	; 78C3F
push eax	; 78C40
push esi	; 78C41
push edi	; 78C42
push esi	; 78C43
call sub_B4FAC	; 78C44
add esp, byte 14h	; 78C49
mov eax, dword [dlgedgecol2]	; 78C4C
push eax	; 78C51
mov edx, dword [byte esp+014h]	; 78C52
push edx	; 78C56
push ebp	; 78C57
lea eax, [byte edi+01h]	; 78C58
push eax	; 78C5B
push ebp	; 78C5C
call sub_B4FAC	; 78C5D
add esp, byte 14h	; 78C62
mov ebx, dword [dlgedgecol2]	; 78C65
push ebx	; 78C6B
mov ecx, dword [byte esp+014h]	; 78C6C
push ecx	; 78C70
push ebp	; 78C71
push ecx	; 78C72
lea eax, [byte esi+01h]	; 78C73
push eax	; 78C76
call sub_B4FAC	; 78C77
add esp, byte 14h	; 78C7C
mov edx, dword [dlgedgecol3]	; 78C7F
push edx	; 78C85
mov ebx, dword [byte esp+014h]	; 78C86
push ebx	; 78C8A
push esi	; 78C8B
call sub_B5DB0	; 78C8C
add esp, byte 0Ch	; 78C91
mov ecx, dword [dlgedgecol3]	; 78C94
push ecx	; 78C9A
push edi	; 78C9B
push ebp	; 78C9C
call sub_B5DB0	; 78C9D
add esp, byte 0Ch	; 78CA2
cmp dword [byte esp+024h], byte 0	; 78CA5
je near .1	; 78CAA
mov edx, dword [dlgbevelcol2]	; 78CB0
push edx	; 78CB6
mov eax, edi	; 78CB7
add eax, byte 2	; 78CB9
mov dword [byte esp+04h], eax	; 78CBC
push eax	; 78CC0
mov eax, esi	; 78CC1
add eax, byte 2	; 78CC3
mov dword [byte esp+0Ch], eax	; 78CC6
push eax	; 78CCA
call sub_B5DB0	; 78CCB
add esp, byte 0Ch	; 78CD0
mov eax, dword [dlgbevelcol2]	; 78CD3
push eax	; 78CD8
add edi, byte 3	; 78CD9
mov dword [byte esp+0Ch], edi	; 78CDC
push edi	; 78CE0
lea edi, [byte esi+03h]	; 78CE1
push edi	; 78CE4
call sub_B5DB0	; 78CE5
add esp, byte 0Ch	; 78CEA
mov ebx, dword [dlgbevelcol1]	; 78CED
push ebx	; 78CF3
mov ecx, dword [byte esp+04h]	; 78CF4
push ecx	; 78CF8
push edi	; 78CF9
call sub_B5DB0	; 78CFA
add esp, byte 0Ch	; 78CFF
mov esi, dword [dlgbevelcol1]	; 78D02
push esi	; 78D08
mov eax, dword [byte esp+0Ch]	; 78D09
push eax	; 78D0D
mov edx, dword [byte esp+0Ch]	; 78D0E
push edx	; 78D12
call sub_B5DB0	; 78D13
add esp, byte 0Ch	; 78D18
mov ebx, dword [dlgbevelcol1]	; 78D1B
push ebx	; 78D21
mov esi, dword [byte esp+014h]	; 78D22
sub esi, byte 2	; 78D26
push esi	; 78D29
mov ecx, dword [byte esp+0Ch]	; 78D2A
push ecx	; 78D2E
call sub_B5DB0	; 78D2F
add esp, byte 0Ch	; 78D34
mov eax, dword [dlgbevelcol1]	; 78D37
push eax	; 78D3C
mov eax, dword [byte esp+014h]	; 78D3D
sub eax, byte 3	; 78D41
mov dword [byte esp+010h], eax	; 78D44
push eax	; 78D48
push edi	; 78D49
call sub_B5DB0	; 78D4A
add esp, byte 0Ch	; 78D4F
mov ebx, dword [dlgbevelcol2]	; 78D52
push ebx	; 78D58
push esi	; 78D59
push edi	; 78D5A
call sub_B5DB0	; 78D5B
add esp, byte 0Ch	; 78D60
mov ecx, dword [dlgbevelcol2]	; 78D63
push ecx	; 78D69
mov edi, dword [byte esp+010h]	; 78D6A
push edi	; 78D6E
mov eax, dword [byte esp+0Ch]	; 78D6F
push eax	; 78D73
call sub_B5DB0	; 78D74
add esp, byte 0Ch	; 78D79
mov edx, dword [dlgbevelcol2]	; 78D7C
push edx	; 78D82
mov ebx, dword [byte esp+04h]	; 78D83
push ebx	; 78D87
lea edi, [byte ebp-03h]	; 78D88
push edi	; 78D8B
call sub_B5DB0	; 78D8C
add esp, byte 0Ch	; 78D91
mov ecx, dword [dlgbevelcol2]	; 78D94
push ecx	; 78D9A
mov eax, dword [byte esp+0Ch]	; 78D9B
push eax	; 78D9F
sub ebp, byte 2	; 78DA0
push ebp	; 78DA3
call sub_B5DB0	; 78DA4
add esp, byte 0Ch	; 78DA9
mov edx, dword [dlgbevelcol1]	; 78DAC
push edx	; 78DB2
mov ebx, dword [byte esp+04h]	; 78DB3
push ebx	; 78DB7
push ebp	; 78DB8
call sub_B5DB0	; 78DB9
add esp, byte 0Ch	; 78DBE
mov ecx, dword [dlgbevelcol1]	; 78DC1
push ecx	; 78DC7
mov eax, dword [byte esp+0Ch]	; 78DC8
push eax	; 78DCC
push edi	; 78DCD
call sub_B5DB0	; 78DCE
add esp, byte 0Ch	; 78DD3
mov edx, dword [dlgbevelcol1]	; 78DD6
push edx	; 78DDC
push esi	; 78DDD
push edi	; 78DDE
call sub_B5DB0	; 78DDF
add esp, byte 0Ch	; 78DE4
mov ebx, dword [dlgbevelcol1]	; 78DE7
push ebx	; 78DED
mov ecx, dword [byte esp+010h]	; 78DEE
push ecx	; 78DF2
push ebp	; 78DF3
call sub_B5DB0	; 78DF4
add esp, byte 0Ch	; 78DF9
mov eax, dword [dlgbevelcol2]	; 78DFC
push eax	; 78E01
push esi	; 78E02
push ebp	; 78E03
call sub_B5DB0	; 78E04
add esp, byte 0Ch	; 78E09
mov edx, dword [dlgbevelcol2]	; 78E0C
push edx	; 78E12
mov ebx, dword [byte esp+010h]	; 78E13
push ebx	; 78E17
push edi	; 78E18
call sub_B5DB0	; 78E19
add esp, byte 0Ch	; 78E1E
.1:
add esp, byte 14h	; 78E21
jmp near StubRet4a	; 78E24
%endif ; C
; C: src/front/game_lines/StubRet4b.c
%ifdef CBUILD
%include "c/front/game_lines/StubRet4b.inc"
%else
StubRet4b:
push dword 10h	; 78E29
call __CHK	; 78E2E
ret 4	; 78E33
%endif ; C
; C: src/front/game_lines/CheckGameRosterComplete.c
%ifdef CBUILD
%include "c/front/game_lines/CheckGameRosterComplete.inc"
%else
CheckGameRosterComplete:
push dword 0C0h	; 78E36
call __CHK	; 78E3B
push ecx	; 78E40
push esi	; 78E41
push edi	; 78E42
push ebp	; 78E43
sub esp, 94h	; 78E44
mov byte [dword esp+090h], al	; 78E4A
mov dword [dword esp+080h], edx	; 78E51
mov dword [dword esp+084h], ebx	; 78E58
xor edx, edx	; 78E5F
mov dword [dword esp+08Ch], edx	; 78E61
xor ebp, ebp	; 78E68
lea edi, [byte esp+060h]	; 78E6A
mov esi, str_Scratch2	; 78E6E
movsd	; 78E73
movsd	; 78E74
lea edi, [byte esp+078h]	; 78E75
mov esi, str_Dress2	; 78E79
movsd	; 78E7E
movsw	; 78E7F
lea edi, [byte esp+070h]	; 78E81
mov esi, str_Player2	; 78E85
movsd	; 78E8A
movsw	; 78E8B
movsb	; 78E8D
lea edi, [byte esp+068h]	; 78E8E
mov esi, str_GoalieW2	; 78E92
movsd	; 78E97
movsw	; 78E98
movsb	; 78E9A
mov dword [dword esp+088h], str_S2dSS2	; 78E9B
mov ecx, 6	; 78EA6
lea edi, [byte esp+038h]	; 78EAB
mov esi, str_RosterIncomplete2	; 78EAF
rep movsd	; 78EB4
movsw	; 78EB6
movsb	; 78EB8
lea eax, [byte esp+038h]	; 78EB9
mov dword [byte esp+054h], eax	; 78EBD
mov edi, 1	; 78EC1
cmp dword [curperiod], byte 0	; 78EC6
jge near .19	; 78ECD
xor ebx, ebx	; 78ED3
.1:
mov eax, ebx	; 78ED5
shl eax, 2	; 78ED7
sub eax, ebx	; 78EDA
shl eax, 2	; 78EDC
sub eax, ebx	; 78EDF
lea edx, [eax+eax]	; 78EE1
xor ecx, ecx	; 78EE4
mov cl, byte [dword edx+gmrosterslot]	; 78EE6
mov esi, ecx	; 78EEC
shl esi, 2	; 78EEE
add esi, ecx	; 78EF1
shl esi, 3	; 78EF3
sub esi, ecx	; 78EF6
xor ecx, ecx	; 78EF8
mov cl, byte [dword esp+090h]	; 78EFA
mov eax, ecx	; 78F01
shl eax, 4	; 78F03
add eax, ecx	; 78F06
shl eax, 4	; 78F08
add eax, ecx	; 78F0B
cmp byte [dword esi+eax*4+hmroster], 3	; 78F0D
jne short .3	; 78F15
cmp byte [dword edx+gmroster], 47h	; 78F17
je short .2	; 78F1E
inc dword [dword esp+08Ch]	; 78F20
jmp short .3	; 78F27
.2:
inc ebp	; 78F29
.3:
inc ebx	; 78F2A
cmp ebx, byte 1Ch	; 78F2B
jl short CheckGameRosterComplete.1	; 78F2E
cmp dword [dword esp+08Ch], byte 12h	; 78F30
jne short .4	; 78F38
cmp ebp, byte 2	; 78F3A
je near .19	; 78F3D
.4:
mov edx, dword [dword esp+08Ch]	; 78F43
cmp edx, byte 12h	; 78F4A
jge short .7	; 78F4D
mov eax, 12h	; 78F4F
sub eax, edx	; 78F54
cmp eax, byte 1	; 78F56
jne short .5	; 78F59
mov eax, unk_C3283	; 78F5B
jmp short .6	; 78F60
.5:
mov eax, str_S7	; 78F62
.6:
push eax	; 78F67
lea eax, [byte esp+074h]	; 78F68
push eax	; 78F6C
mov eax, 12h	; 78F6D
sub eax, dword [dword esp+094h]	; 78F72
push eax	; 78F79
lea eax, [dword esp+084h]	; 78F7A
push eax	; 78F81
mov ebx, dword [dword esp+098h]	; 78F82
push ebx	; 78F89
jmp short .10	; 78F8A
.7:
jle short .11	; 78F8C
lea eax, [byte edx-012h]	; 78F8E
cmp eax, byte 1	; 78F91
jne short .8	; 78F94
mov eax, unk_C3283	; 78F96
jmp short .9	; 78F9B
.8:
mov eax, str_S7	; 78F9D
.9:
push eax	; 78FA2
lea eax, [byte esp+074h]	; 78FA3
push eax	; 78FA7
mov eax, dword [dword esp+094h]	; 78FA8
sub eax, byte 12h	; 78FAF
push eax	; 78FB2
lea eax, [byte esp+06Ch]	; 78FB3
push eax	; 78FB7
mov ecx, dword [dword esp+098h]	; 78FB8
push ecx	; 78FBF
.10:
lea eax, [byte esp+030h]	; 78FC0
push eax	; 78FC4
call sprintf_	; 78FC5
add esp, byte 18h	; 78FCA
lea edx, [byte esp+01Ch]	; 78FCD
mov dword [byte esp+edi*4+054h], edx	; 78FD1
inc edi	; 78FD5
.11:
cmp ebp, byte 2	; 78FD6
jge short .14	; 78FD9
mov eax, 2	; 78FDB
sub eax, ebp	; 78FE0
cmp eax, byte 1	; 78FE2
jne short .12	; 78FE5
mov eax, unk_C3283	; 78FE7
jmp short .13	; 78FEC
.12:
mov eax, str_S7	; 78FEE
.13:
push eax	; 78FF3
lea eax, [byte esp+06Ch]	; 78FF4
push eax	; 78FF8
mov eax, 2	; 78FF9
sub eax, ebp	; 78FFE
push eax	; 79000
lea eax, [dword esp+084h]	; 79001
push eax	; 79008
mov esi, dword [dword esp+098h]	; 79009
push esi	; 79010
jmp short .17	; 79011
.14:
jle short .18	; 79013
lea eax, [byte ebp-02h]	; 79015
cmp eax, byte 1	; 79018
jne short .15	; 7901B
mov eax, unk_C3283	; 7901D
jmp short .16	; 79022
.15:
mov eax, str_S7	; 79024
.16:
push eax	; 79029
lea eax, [byte esp+06Ch]	; 7902A
push eax	; 7902E
sub ebp, byte 2	; 7902F
push ebp	; 79032
lea eax, [byte esp+06Ch]	; 79033
push eax	; 79037
mov ecx, dword [dword esp+098h]	; 79038
push ecx	; 7903F
.17:
lea eax, [byte esp+014h]	; 79040
push eax	; 79044
call sprintf_	; 79045
add esp, byte 18h	; 7904A
mov edx, esp	; 7904D
mov dword [byte esp+edi*4+054h], edx	; 7904F
inc edi	; 79053
.18:
push byte 0FFFFFFFFh	; 79054
mov ebp, dword [dword esp+088h]	; 79056
push ebp	; 7905D
mov eax, dword [dword esp+088h]	; 7905E
push eax	; 79065
push byte 0	; 79066
push byte 0	; 79068
mov ecx, edi	; 7906A
lea ebx, [byte esp+068h]	; 7906C
mov edx, 0FFFFFFFFh	; 79070
mov eax, edx	; 79075
call MessageBox	; 79077
mov eax, 1	; 7907C
jmp short .x	; 79081
.19:
xor eax, eax	; 79083
.x:
add esp, 94h	; 79085
pop ebp	; 7908B
pop edi	; 7908C
pop esi	; 7908D
pop ecx	; 7908E
ret	; 7908F
%endif ; C
; C: src/front/game_lines/PruneGameLines.c
%ifdef CBUILD
%include "c/front/game_lines/PruneGameLines.inc"
%else
PruneGameLines:
push dword 18h	; 79090
call __CHK	; 79095
push ebx	; 7909A
push ecx	; 7909B
push esi	; 7909C
push edi	; 7909D
sub esp, byte 4	; 7909E
mov byte [esp], al	; 790A1
mov esi, edx	; 790A4
cmp dword [curperiod], byte 0	; 790A6
jl short .3	; 790AD
xor eax, eax	; 790AF
.1:
lea ebx, [esi+eax]	; 790B1
cmp byte [ebx], 64h	; 790B4
je short .2	; 790B7
xor ecx, ecx	; 790B9
mov cl, byte [ebx]	; 790BB
mov edi, ecx	; 790BD
shl edi, 2	; 790BF
add edi, ecx	; 790C2
shl edi, 3	; 790C4
sub edi, ecx	; 790C7
xor ecx, ecx	; 790C9
mov cl, byte [esp]	; 790CB
mov edx, ecx	; 790CE
shl edx, 4	; 790D0
add edx, ecx	; 790D3
shl edx, 4	; 790D5
add edx, ecx	; 790D8
shl edx, 2	; 790DA
add edx, edi	; 790DD
mov ch, byte [dword edx+hmroster]	; 790DF
cmp ch, 4	; 790E5
je short .2	; 790E8
cmp ch, 3	; 790EA
je short .2	; 790ED
mov byte [ebx], 64h	; 790EF
.2:
inc eax	; 790F2
cmp eax, byte 28h	; 790F3
jl short PruneGameLines.1	; 790F6
jmp near .x	; 790F8
.3:
xor eax, eax	; 790FD
.4:
xor ebx, ebx	; 790FF
mov bl, byte [esp]	; 79101
mov ecx, ebx	; 79104
shl ecx, 4	; 79106
add ecx, ebx	; 79109
shl ecx, 4	; 7910B
add ecx, ebx	; 7910E
shl ecx, 2	; 79110
mov edx, eax	; 79113
shl edx, 2	; 79115
add edx, eax	; 79118
shl edx, 3	; 7911A
sub edx, eax	; 7911D
add edx, ecx	; 7911F
cmp byte [dword edx+hmroster], 2	; 79121
jne short .5	; 79128
mov byte [dword edx+hmroster], 3	; 7912A
.5:
inc eax	; 79131
cmp eax, byte 1Ch	; 79132
jl short PruneGameLines.4	; 79135
xor eax, eax	; 79137
.6:
lea edx, [esi+eax]	; 79139
mov cl, byte [byte edx+028h]	; 7913C
cmp cl, 64h	; 7913F
je short .7	; 79142
xor ebx, ebx	; 79144
mov bl, cl	; 79146
mov ecx, ebx	; 79148
shl ecx, 2	; 7914A
add ecx, ebx	; 7914D
shl ecx, 3	; 7914F
sub ecx, ebx	; 79152
xor ebx, ebx	; 79154
mov bl, byte [esp]	; 79156
mov edx, ebx	; 79159
shl edx, 4	; 7915B
add edx, ebx	; 7915E
shl edx, 4	; 79160
add edx, ebx	; 79163
shl edx, 2	; 79165
add edx, ecx	; 79168
cmp byte [dword edx+hmroster], 3	; 7916A
jne short .7	; 79171
mov byte [dword edx+hmroster], 2	; 79173
.7:
inc eax	; 7917A
cmp eax, byte 8	; 7917B
jl short PruneGameLines.6	; 7917E
.x:
add esp, byte 4	; 79180
pop edi	; 79183
pop esi	; 79184
pop ecx	; 79185
pop ebx	; 79186
ret	; 79187
%endif ; C
; C: src/front/game_lines/MenuSaveDefaultLines.c (MenuUseTheseLines)
%ifdef CBUILD
%include "c/front/game_lines/MenuSaveDefaultLines.MenuUseTheseLines.inc"
%else
MenuUseTheseLines:
push dword 18h	; 79188
call __CHK	; 7918D
push esi	; 79192
push edi	; 79193
push ebp	; 79194
sub esp, byte 8	; 79195
mov esi, eax	; 79198
mov edi, edx	; 7919A
mov byte [byte esp+04h], bl	; 7919C
xor eax, eax	; 791A0
mov al, bl	; 791A2
mov ebx, dword [byte esp+02Ch]	; 791A4
mov edx, dword [byte esp+028h]	; 791A8
call CheckGameRosterComplete	; 791AC
test eax, eax	; 791B1
jne near MenuUseOriginalLines_ret0	; 791B3
mov dword [esp], eax	; 791B9
.1:
xor edx, edx	; 791BC
.2:
xor ebx, ebx	; 791BE
mov bl, byte [byte esp+04h]	; 791C0
mov ecx, ebx	; 791C4
shl ecx, 4	; 791C6
add ecx, ebx	; 791C9
shl ecx, 4	; 791CB
add ecx, ebx	; 791CE
shl ecx, 2	; 791D0
mov eax, edx	; 791D3
shl eax, 2	; 791D5
add eax, edx	; 791D8
shl eax, 3	; 791DA
sub eax, edx	; 791DD
add eax, ecx	; 791DF
cmp byte [dword eax+hmroster], 0	; 791E1
je short .3	; 791E8
mov ebx, dword [esp]	; 791EA
mov bl, byte [esi+ebx]	; 791ED
cmp bl, byte [dword eax+hmrosterjersey]	; 791F0
jne short .3	; 791F6
mov eax, dword [esp]	; 791F8
mov byte [edi+eax], dl	; 791FB
jmp short .4	; 791FE
.3:
inc edx	; 79200
cmp edx, byte 1Ch	; 79201
jl short MenuUseTheseLines.2	; 79204
.4:
mov ebx, dword [esp]	; 79206
inc ebx	; 79209
mov dword [esp], ebx	; 7920A
cmp ebx, byte 28h	; 7920D
jl short MenuUseTheseLines.1	; 79210
cmp dword [curperiod], byte 0	; 79212
jge short .9	; 79219
xor ebp, ebp	; 7921B
mov dword [esp], ebp	; 7921D
.5:
mov eax, dword [esp]	; 79220
mov byte [byte edi+eax+028h], 64h	; 79223
inc eax	; 79228
mov dword [esp], eax	; 79229
cmp eax, byte 8	; 7922C
jl short MenuUseTheseLines.5	; 7922F
xor ebx, ebx	; 79231
mov dword [esp], ebx	; 79233
xor edx, edx	; 79236
jmp short .8	; 79238
.6:
xor ebx, ebx	; 7923A
mov bl, byte [byte esp+04h]	; 7923C
mov ecx, ebx	; 79240
shl ecx, 4	; 79242
add ecx, ebx	; 79245
shl ecx, 4	; 79247
add ecx, ebx	; 7924A
shl ecx, 2	; 7924C
mov ebx, dword [esp]	; 7924F
mov eax, ebx	; 79252
shl eax, 2	; 79254
add eax, ebx	; 79257
shl eax, 3	; 79259
sub eax, ebx	; 7925C
add eax, ecx	; 7925E
mov cl, byte [dword eax+hmroster]	; 79260
test cl, cl	; 79266
je short .7	; 79268
cmp cl, 3	; 7926A
je short .7	; 7926D
mov bl, byte [esp]	; 7926F
mov byte [byte edx+edi+028h], bl	; 79272
inc edx	; 79276
.7:
inc dword [esp]	; 79277
.8:
cmp dword [esp], byte 1Ch	; 7927A
jl short MenuUseTheseLines.6	; 7927E
.9:
mov eax, 1	; 79280
jmp near MenuUseOriginalLines_ret	; 79285
%endif ; C
; C: src/front/game_lines/MenuLineEdCancel.c
%ifdef CBUILD
%include "c/front/game_lines/MenuLineEdCancel.inc"
%else
MenuLineEdCancel:
push dword 4	; 7928A
call __CHK	; 7928F
mov eax, 1	; 79294
ret 18h	; 79299
%endif ; C
; C: src/front/game_lines/MenuSaveDefaultLines.c (MenuUseOriginalLines)
%ifdef CBUILD
%include "c/front/game_lines/MenuSaveDefaultLines.MenuUseOriginalLines.inc"
%else
MenuUseOriginalLines:
push dword 18h	; 7929C
call __CHK	; 792A1
push esi	; 792A6
push edi	; 792A7
push ebp	; 792A8
sub esp, byte 8	; 792A9
mov edi, eax	; 792AC
mov byte [byte esp+04h], bl	; 792AE
mov dword [esp], ecx	; 792B2
xor ebx, ebx	; 792B5
mov bl, byte [byte esp+04h]	; 792B7
mov eax, ebx	; 792BB
shl eax, 2	; 792BD
sub eax, ebx	; 792C0
shl eax, 3	; 792C2
mov edx, eax	; 792C5
shl eax, 5	; 792C7
sub eax, edx	; 792CA
mov ebp, hmteamrec	; 792CC
add ebp, eax	; 792D1
add ebp, 0ECh	; 792D3
mov edx, ebp	; 792D9
mov eax, ebx	; 792DB
call PruneGameLines	; 792DD
mov dword [menuact_savelines], MenuSaveTheseLines	; 792E2
mov ebx, MenuUseTheseLines	; 792EC
mov dword [menuact_uselines], ebx	; 792F1
mov dword [menuact_uselines2], ebx	; 792F7
mov esi, MenuSaveDefaultLines	; 792FD
mov dword [menuact_savedeflines], esi	; 79302
mov dword [menuact_savedeflines2], esi	; 79308
xor edx, edx	; 7930E
.1:
lea eax, [edx+ebp]	; 79310
lea ebx, [edi+edx]	; 79313
mov cl, byte [eax]	; 79316
cmp cl, 64h	; 79318
je short .2	; 7931B
xor ecx, ecx	; 7931D
mov cl, byte [eax]	; 7931F
mov esi, ecx	; 79321
shl esi, 2	; 79323
add esi, ecx	; 79326
shl esi, 3	; 79328
sub esi, ecx	; 7932B
xor ecx, ecx	; 7932D
mov cl, byte [byte esp+04h]	; 7932F
mov eax, ecx	; 79333
shl eax, 4	; 79335
add eax, ecx	; 79338
shl eax, 4	; 7933A
add eax, ecx	; 7933D
mov al, byte [dword esi+eax*4+hmrosterjersey]	; 7933F
mov byte [ebx], al	; 79346
jmp short .3	; 79348
.2:
mov byte [ebx], cl	; 7934A
xor ebx, ebx	; 7934C
mov dword [menuact_savelines], ebx	; 7934E
mov dword [menuact_uselines], ebx	; 79354
mov dword [menuact_uselines2], ebx	; 7935A
mov dword [menuact_savedeflines], ebx	; 79360
mov dword [menuact_savedeflines2], ebx	; 79366
.3:
inc edx	; 7936C
cmp edx, byte 28h	; 7936D
jl short MenuUseOriginalLines.1	; 79370
MenuUseOriginalLines_redraw:
xor ebx, ebx	; 79372
mov bl, byte [byte esp+04h]	; 79374
mov edx, dword [byte esp+018h]	; 79378
mov eax, edi	; 7937C
call DrawGameLineJerseys	; 7937E
mov eax, dword [esp]	; 79383
mov dword [eax], 0FFFFFFFFh	; 79386
xor ecx, ecx	; 7938C
mov dword [menuact_gamescratch], ecx	; 7938E
mov dword [menuact_gamedress], ecx	; 79394
MenuUseOriginalLines_ret0:
xor eax, eax	; 7939A
MenuUseOriginalLines_ret:
add esp, byte 8	; 7939C
jmp near MenuSaveDefaultLines_pop	; 7939F
%endif ; C
; C: src/front/game_lines/MenuSaveDefaultLines.c (MenuUseDefaultLines)
%ifdef CBUILD
%include "c/front/game_lines/MenuSaveDefaultLines.MenuUseDefaultLines.inc"
%else
MenuUseDefaultLines:
push dword 18h	; 793A4
call __CHK	; 793A9
push esi	; 793AE
push edi	; 793AF
push ebp	; 793B0
sub esp, byte 8	; 793B1
mov edi, eax	; 793B4
mov byte [byte esp+04h], bl	; 793B6
mov dword [esp], ecx	; 793BA
xor ebx, ebx	; 793BD
mov bl, byte [byte esp+04h]	; 793BF
mov eax, ebx	; 793C3
shl eax, 2	; 793C5
sub eax, ebx	; 793C8
shl eax, 3	; 793CA
mov edx, eax	; 793CD
shl eax, 5	; 793CF
sub eax, edx	; 793D2
mov ebp, hmteamrec	; 793D4
add ebp, eax	; 793D9
add ebp, 0BCh	; 793DB
mov edx, ebp	; 793E1
mov eax, ebx	; 793E3
call PruneGameLines	; 793E5
mov dword [menuact_savelines], MenuSaveTheseLines	; 793EA
mov ebx, MenuUseTheseLines	; 793F4
mov dword [menuact_uselines], ebx	; 793F9
mov dword [menuact_uselines2], ebx	; 793FF
mov esi, MenuSaveDefaultLines	; 79405
mov dword [menuact_savedeflines], esi	; 7940A
mov dword [menuact_savedeflines2], esi	; 79410
xor edx, edx	; 79416
.1:
lea eax, [edx+ebp]	; 79418
lea ebx, [edi+edx]	; 7941B
mov cl, byte [eax]	; 7941E
cmp cl, 64h	; 79420
je short .2	; 79423
xor ecx, ecx	; 79425
mov cl, byte [eax]	; 79427
mov esi, ecx	; 79429
shl esi, 2	; 7942B
add esi, ecx	; 7942E
shl esi, 3	; 79430
sub esi, ecx	; 79433
xor ecx, ecx	; 79435
mov cl, byte [byte esp+04h]	; 79437
mov eax, ecx	; 7943B
shl eax, 4	; 7943D
add eax, ecx	; 79440
shl eax, 4	; 79442
add eax, ecx	; 79445
mov al, byte [dword esi+eax*4+hmrosterjersey]	; 79447
mov byte [ebx], al	; 7944E
jmp short .3	; 79450
.2:
mov byte [ebx], cl	; 79452
xor ebx, ebx	; 79454
mov dword [menuact_savelines], ebx	; 79456
mov dword [menuact_uselines], ebx	; 7945C
mov dword [menuact_uselines2], ebx	; 79462
mov dword [menuact_savedeflines], ebx	; 79468
mov dword [menuact_savedeflines2], ebx	; 7946E
.3:
inc edx	; 79474
cmp edx, byte 28h	; 79475
jl short MenuUseDefaultLines.1	; 79478
jmp near MenuUseOriginalLines_redraw	; 7947A
%endif ; C
MenuSaveDefaultLines:
db 068h,02Ch,03h,00h,00h
call __CHK	; 79484
push esi	; 79489
push edi	; 7948A
push ebp	; 7948B
sub esp, 310h	; 7948C
mov esi, eax	; 79492
mov byte [dword esp+030Ch], bl	; 79494
xor eax, eax	; 7949B
mov al, bl	; 7949D
mov ebx, dword [dword esp+0334h]	; 7949F
mov edx, dword [dword esp+0330h]	; 794A6
call CheckGameRosterComplete	; 794AD
test eax, eax	; 794B2
jne near .24	; 794B4
cmp byte [dword esp+030Ch], 0	; 794BA
je short .1	; 794C2
push str_Teams2	; 794C4
push leaguedbfmt2	; 794C9
jmp short .2	; 794CE
.1:
push str_Teams2	; 794D0
push leaguedbfmt	; 794D5
.2:
lea eax, [dword esp+02F0h]	; 794DA
push eax	; 794E1
call sprintf_	; 794E2
add esp, byte 0Ch	; 794E7
push dword 202h	; 794EA
lea eax, [dword esp+02ECh]	; 794EF
push eax	; 794F6
call open_	; 794F7
add esp, byte 8	; 794FC
mov ebp, eax	; 794FF
test eax, eax	; 79501
jge short .3	; 79503
call sub_B4B58	; 79505
mov eax, str_ErrB2Perror	; 7950A
call perror_	; 7950F
call WaitKey	; 79514
mov eax, 1	; 79519
call exit_	; 7951E
.3:
xor ebx, ebx	; 79523
xor edx, edx	; 79525
mov eax, ebp	; 79527
call lseek_	; 79529
test eax, eax	; 7952E
je short .4	; 79530
push str_ErrB3	; 79532
call FatalError	; 79537
add esp, byte 4	; 7953C
.4:
cmp byte [dword esp+030Ch], 0	; 7953F
je short .5	; 79547
mov edx, dword [HomeTeam]	; 79549
jmp short .6	; 7954F
.5:
mov edx, dword [cont2team]	; 79551
.6:
sar edx, 10h	; 79557
mov eax, edx	; 7955A
shl eax, 2	; 7955C
sub eax, edx	; 7955F
shl eax, 3	; 79561
mov edx, eax	; 79564
shl eax, 5	; 79566
sub eax, edx	; 79569
xor ebx, ebx	; 7956B
mov edx, eax	; 7956D
mov eax, ebp	; 7956F
call lseek_	; 79571
mov ebx, eax	; 79576
test ebx, ebx	; 79578
jge short .7	; 7957A
push str_ErrB4	; 7957C
call FatalError	; 79581
add esp, byte 4	; 79586
.7:
mov ebx, 2E8h	; 79589
mov edx, esp	; 7958E
mov eax, ebp	; 79590
call read_	; 79592
test eax, eax	; 79597
jl short .8	; 79599
cmp eax, 2E8h	; 7959B
je short .9	; 795A0
.8:
push str_ErrB5	; 795A2
call FatalError	; 795A7
add esp, byte 4	; 795AC
.9:
mov ebx, 1	; 795AF
mov edx, 0FFFFFD18h	; 795B4
mov eax, ebp	; 795B9
call lseek_	; 795BB
mov ecx, eax	; 795C0
mov ebx, eax	; 795C2
test eax, eax	; 795C4
jge short .12	; 795C6
mov edx, dword [HomeTeam-2]	; 795C8
sar edx, 10h	; 795CE
mov eax, edx	; 795D1
shl eax, 2	; 795D3
sub eax, edx	; 795D6
shl eax, 3	; 795D8
mov edx, eax	; 795DB
shl eax, 5	; 795DD
sub eax, edx	; 795E0
cmp ecx, eax	; 795E2
je short .10	; 795E4
cmp byte [dword esp+030Ch], 0	; 795E6
je short .11	; 795EE
.10:
mov edx, dword [VisTeam-2]	; 795F0
sar edx, 10h	; 795F6
mov eax, edx	; 795F9
shl eax, 2	; 795FB
sub eax, edx	; 795FE
shl eax, 3	; 79600
mov edx, eax	; 79603
shl eax, 5	; 79605
sub eax, edx	; 79608
cmp ebx, eax	; 7960A
je short .12	; 7960C
cmp byte [dword esp+030Ch], 0	; 7960E
je short .12	; 79616
.11:
push str_ErrB6	; 79618
call FatalError	; 7961D
add esp, byte 4	; 79622
.12:
xor edx, edx	; 79625
mov dword [dword esp+0308h], edx	; 79627
.13:
xor edx, edx	; 7962E
.14:
xor ebx, ebx	; 79630
mov bl, byte [dword esp+030Ch]	; 79632
mov ecx, ebx	; 79639
shl ecx, 4	; 7963B
add ecx, ebx	; 7963E
shl ecx, 4	; 79640
add ecx, ebx	; 79643
shl ecx, 2	; 79645
mov eax, edx	; 79648
shl eax, 2	; 7964A
add eax, edx	; 7964D
shl eax, 3	; 7964F
sub eax, edx	; 79652
add eax, ecx	; 79654
cmp byte [dword eax+hmroster], 0	; 79656
je short .15	; 7965D
mov ebx, dword [dword esp+0308h]	; 7965F
mov bl, byte [esi+ebx]	; 79666
cmp bl, byte [dword eax+hmrosterjersey]	; 79669
jne short .15	; 7966F
mov eax, dword [dword esp+0308h]	; 79671
mov byte [dword esp+eax+0BCh], dl	; 79678
jmp short .16	; 7967F
.15:
inc edx	; 79681
cmp edx, byte 1Ch	; 79682
jl short MenuSaveDefaultLines.14	; 79685
.16:
mov ebx, dword [dword esp+0308h]	; 79687
inc ebx	; 7968E
mov dword [dword esp+0308h], ebx	; 7968F
cmp ebx, byte 28h	; 79696
jl short MenuSaveDefaultLines.13	; 79699
cmp dword [curperiod], byte 0	; 7969B
jge near .21	; 796A2
xor edi, edi	; 796A8
mov dword [dword esp+0308h], edi	; 796AA
mov ch, 64h	; 796B1
.17:
mov eax, dword [dword esp+0308h]	; 796B3
mov byte [dword esp+eax+0E4h], ch	; 796BA
inc eax	; 796C1
mov dword [dword esp+0308h], eax	; 796C2
cmp eax, byte 8	; 796C9
jl short MenuSaveDefaultLines.17	; 796CC
xor ebx, ebx	; 796CE
mov dword [dword esp+0308h], ebx	; 796D0
xor edx, edx	; 796D7
jmp short .20	; 796D9
.18:
xor ebx, ebx	; 796DB
mov bl, byte [dword esp+030Ch]	; 796DD
mov ecx, ebx	; 796E4
shl ecx, 4	; 796E6
add ecx, ebx	; 796E9
shl ecx, 4	; 796EB
add ecx, ebx	; 796EE
shl ecx, 2	; 796F0
mov ebx, dword [dword esp+0308h]	; 796F3
mov eax, ebx	; 796FA
shl eax, 2	; 796FC
add eax, ebx	; 796FF
shl eax, 3	; 79701
sub eax, ebx	; 79704
add eax, ecx	; 79706
mov bl, byte [dword eax+hmroster]	; 79708
test bl, bl	; 7970E
je short .19	; 79710
cmp bl, 3	; 79712
je short .19	; 79715
mov al, byte [dword esp+0308h]	; 79717
mov byte [dword esp+edx+0E4h], al	; 7971E
inc edx	; 79725
.19:
inc dword [dword esp+0308h]	; 79726
.20:
cmp dword [dword esp+0308h], byte 1Ch	; 7972D
jl short MenuSaveDefaultLines.18	; 79735
.21:
mov ebx, 2E8h	; 79737
mov edx, esp	; 7973C
mov eax, ebp	; 7973E
call write_	; 79740
test eax, eax	; 79745
jl short .22	; 79747
cmp eax, 2E8h	; 79749
je short .23	; 7974E
.22:
push str_ErrB7	; 79750
call FatalError	; 79755
add esp, byte 4	; 7975A
.23:
xor edx, edx	; 7975D
mov dl, byte [dword esp+030Ch]	; 7975F
mov eax, edx	; 79766
shl eax, 2	; 79768
sub eax, edx	; 7976B
shl eax, 3	; 7976D
mov edx, eax	; 79770
shl eax, 5	; 79772
sub eax, edx	; 79775
mov ecx, 0Ch	; 79777
lea edi, [dword eax+hmteamrec+0BCh]	; 7977C
lea esi, [dword esp+0BCh]	; 79782
rep movsd	; 79789
mov ecx, 0Ch	; 7978B
lea edi, [dword eax+unk_DBD1C]	; 79790
lea esi, [dword esp+0ECh]	; 79796
rep movsd	; 7979D
mov eax, ebp	; 7979F
call j___close_	; 797A1
.24:
xor eax, eax	; 797A6
MenuSaveDefaultLines_ret:
add esp, 310h	; 797A8
MenuSaveDefaultLines_pop:
pop ebp	; 797AE
pop edi	; 797AF
pop esi	; 797B0
ret 18h	; 797B1
MenuSaveTheseLines:
db 068h,02Ch,03h,00h,00h,0E8h,08Eh,031h,01h,00h,056h,057h,055h,081h,0ECh,010h
db 03h,00h,00h,089h,0C6h,088h,09Ch,024h,0Ch,03h,00h,00h,031h,0C0h,088h,0D8h
db 08Bh,09Ch,024h,034h,03h,00h,00h,08Bh,094h,024h,030h,03h,00h,00h,0E8h,04Fh
db 0F6h,0FFh,0FFh,085h,0C0h,074h,04h,031h,0C0h,0EBh,0B9h,080h,0BCh,024h,0Ch,03h
db 00h,00h,00h,074h,0Ch,068h
dd str_Teams2
MenuSaveTheseLines_x:
push leaguedbfmt2	; 797FE
jmp short .1	; 79803
push str_Teams2	; 79805
push leaguedbfmt	; 7980A
.1:
lea eax, [dword esp+02F0h]	; 7980F
push eax	; 79816
call sprintf_	; 79817
add esp, byte 0Ch	; 7981C
push dword 202h	; 7981F
lea eax, [dword esp+02ECh]	; 79824
push eax	; 7982B
call open_	; 7982C
add esp, byte 8	; 79831
mov ebp, eax	; 79834
test eax, eax	; 79836
jge short .2	; 79838
push str_ErrB2	; 7983A
call FatalError	; 7983F
add esp, byte 4	; 79844
.2:
xor ebx, ebx	; 79847
xor edx, edx	; 79849
mov eax, ebp	; 7984B
call lseek_	; 7984D
test eax, eax	; 79852
je short .3	; 79854
push str_ErrB3	; 79856
call FatalError	; 7985B
add esp, byte 4	; 79860
.3:
cmp byte [dword esp+030Ch], 0	; 79863
je short .4	; 7986B
mov edx, dword [HomeTeam]	; 7986D
jmp short .5	; 79873
.4:
mov edx, dword [cont2team]	; 79875
.5:
sar edx, 10h	; 7987B
mov eax, edx	; 7987E
shl eax, 2	; 79880
sub eax, edx	; 79883
shl eax, 3	; 79885
mov edx, eax	; 79888
shl eax, 5	; 7988A
sub eax, edx	; 7988D
xor ebx, ebx	; 7988F
mov edx, eax	; 79891
mov eax, ebp	; 79893
call lseek_	; 79895
mov ebx, eax	; 7989A
test ebx, ebx	; 7989C
jge short .6	; 7989E
push str_ErrB4	; 798A0
call FatalError	; 798A5
add esp, byte 4	; 798AA
.6:
mov ebx, 2E8h	; 798AD
mov edx, esp	; 798B2
mov eax, ebp	; 798B4
call read_	; 798B6
test eax, eax	; 798BB
jl short .7	; 798BD
cmp eax, 2E8h	; 798BF
je short .8	; 798C4
.7:
push str_ErrB5	; 798C6
call FatalError	; 798CB
add esp, byte 4	; 798D0
.8:
mov ebx, 1	; 798D3
mov edx, 0FFFFFD18h	; 798D8
mov eax, ebp	; 798DD
call lseek_	; 798DF
mov ecx, eax	; 798E4
mov ebx, eax	; 798E6
test eax, eax	; 798E8
jge short .11	; 798EA
mov edx, dword [HomeTeam-2]	; 798EC
sar edx, 10h	; 798F2
mov eax, edx	; 798F5
shl eax, 2	; 798F7
sub eax, edx	; 798FA
shl eax, 3	; 798FC
mov edx, eax	; 798FF
shl eax, 5	; 79901
sub eax, edx	; 79904
cmp ecx, eax	; 79906
je short .9	; 79908
cmp byte [dword esp+030Ch], 0	; 7990A
je short .10	; 79912
.9:
mov edx, dword [VisTeam-2]	; 79914
sar edx, 10h	; 7991A
mov eax, edx	; 7991D
shl eax, 2	; 7991F
sub eax, edx	; 79922
shl eax, 3	; 79924
mov edx, eax	; 79927
shl eax, 5	; 79929
sub eax, edx	; 7992C
cmp ebx, eax	; 7992E
je short .11	; 79930
cmp byte [dword esp+030Ch], 0	; 79932
je short .11	; 7993A
.10:
push str_ErrB6	; 7993C
call FatalError	; 79941
add esp, byte 4	; 79946
.11:
xor edx, edx	; 79949
mov dword [dword esp+0308h], edx	; 7994B
.12:
xor ecx, ecx	; 79952
.13:
xor edx, edx	; 79954
mov dl, byte [dword esp+030Ch]	; 79956
mov ebx, edx	; 7995D
shl ebx, 4	; 7995F
add ebx, edx	; 79962
shl ebx, 4	; 79964
add ebx, edx	; 79967
shl ebx, 2	; 79969
mov eax, ecx	; 7996C
shl eax, 2	; 7996E
add eax, ecx	; 79971
shl eax, 3	; 79973
sub eax, ecx	; 79976
add eax, ebx	; 79978
cmp byte [dword eax+hmroster], 0	; 7997A
je short .14	; 79981
mov edx, dword [dword esp+0308h]	; 79983
mov dl, byte [edx+esi]	; 7998A
cmp dl, byte [dword eax+hmrosterjersey]	; 7998D
jne short .14	; 79993
mov eax, dword [dword esp+0308h]	; 79995
mov byte [dword esp+eax+0BCh], cl	; 7999C
jmp short .15	; 799A3
.14:
inc ecx	; 799A5
cmp ecx, byte 1Ch	; 799A6
jl short MenuSaveTheseLines_x.13	; 799A9
.15:
mov ebx, dword [dword esp+0308h]	; 799AB
inc ebx	; 799B2
mov dword [dword esp+0308h], ebx	; 799B3
cmp ebx, byte 28h	; 799BA
jl short MenuSaveTheseLines_x.12	; 799BD
xor esi, esi	; 799BF
mov dword [dword esp+0308h], esi	; 799C1
mov bl, 64h	; 799C8
.16:
mov eax, dword [dword esp+0308h]	; 799CA
mov byte [dword esp+eax+0E4h], bl	; 799D1
lea edi, [byte eax+01h]	; 799D8
mov dword [dword esp+0308h], edi	; 799DB
cmp edi, byte 8	; 799E2
jl short MenuSaveTheseLines_x.16	; 799E5
xor edx, edx	; 799E7
mov dword [dword esp+0308h], edx	; 799E9
xor ecx, ecx	; 799F0
jmp short .19	; 799F2
.17:
xor edx, edx	; 799F4
mov dl, byte [dword esp+030Ch]	; 799F6
mov ebx, edx	; 799FD
shl ebx, 4	; 799FF
add ebx, edx	; 79A02
shl ebx, 4	; 79A04
add ebx, edx	; 79A07
shl ebx, 2	; 79A09
mov edx, dword [dword esp+0308h]	; 79A0C
mov eax, edx	; 79A13
shl eax, 2	; 79A15
add eax, edx	; 79A18
shl eax, 3	; 79A1A
sub eax, edx	; 79A1D
add eax, ebx	; 79A1F
mov bh, byte [dword eax+hmroster]	; 79A21
test bh, bh	; 79A27
je short .18	; 79A29
cmp bh, 3	; 79A2B
je short .18	; 79A2E
mov al, byte [dword esp+0308h]	; 79A30
mov byte [dword esp+ecx+0E4h], al	; 79A37
inc ecx	; 79A3E
.18:
inc dword [dword esp+0308h]	; 79A3F
.19:
cmp dword [dword esp+0308h], byte 1Ch	; 79A46
jl short MenuSaveTheseLines_x.17	; 79A4E
mov ebx, 2E8h	; 79A50
mov edx, esp	; 79A55
mov eax, ebp	; 79A57
call write_	; 79A59
test eax, eax	; 79A5E
jl short .20	; 79A60
cmp eax, 2E8h	; 79A62
je short .21	; 79A67
.20:
push str_ErrB7	; 79A69
call FatalError	; 79A6E
add esp, byte 4	; 79A73
.21:
xor edx, edx	; 79A76
mov dl, byte [dword esp+030Ch]	; 79A78
mov eax, edx	; 79A7F
shl eax, 2	; 79A81
sub eax, edx	; 79A84
shl eax, 3	; 79A86
mov edx, eax	; 79A89
shl eax, 5	; 79A8B
sub eax, edx	; 79A8E
mov ecx, 0Ch	; 79A90
lea edi, [dword eax+hmteamrec+0BCh]	; 79A95
lea esi, [dword esp+0BCh]	; 79A9B
rep movsd	; 79AA2
mov ecx, 0Ch	; 79AA4
lea edi, [dword eax+unk_DBD1C]	; 79AA9
lea esi, [dword esp+0ECh]	; 79AAF
rep movsd	; 79AB6
mov eax, ebp	; 79AB8
call j___close_	; 79ABA
mov eax, 1	; 79ABF
jmp near MenuSaveDefaultLines_ret	; 79AC4
MenuGameShowPlayerStats:
push dword 348h	; 79AC9
call __CHK	; 79ACE
push esi	; 79AD3
push edi	; 79AD4
push ebp	; 79AD5
sub esp, 324h	; 79AD6
mov ebp, eax	; 79ADC
mov byte [dword esp+0320h], bl	; 79ADE
mov esi, ecx	; 79AE5
mov edx, 1	; 79AE7
mov dword [dword_DC738], edx	; 79AEC
mov dword [dword_DC734], edx	; 79AF2
mov dword [statsredrawcb], TeamRosterScreen	; 79AF8
test bl, bl	; 79B02
je short .1	; 79B04
mov eax, dword [HomeTeam]	; 79B06
jmp short .2	; 79B0B
.1:
mov eax, dword [cont2team]	; 79B0D
.2:
sar eax, 10h	; 79B12
mov dword [statscategory], eax	; 79B15
push byte 20h	; 79B1A
push dword 2A4h	; 79B1C
push str_Tstat2	; 79B21
call sub_8CCA8	; 79B26
add esp, byte 0Ch	; 79B2B
mov dword [statsteambuf], eax	; 79B2E
push byte 20h	; 79B33
push dword 5B0h	; 79B35
push str_Keys4	; 79B3A
call sub_8CCA8	; 79B3F
add esp, byte 0Ch	; 79B44
mov dword [statsplayerbuf], eax	; 79B47
push byte 20h	; 79B4C
push dword 497h	; 79B4E
push str_Pstat4	; 79B53
call sub_8CCA8	; 79B58
add esp, byte 0Ch	; 79B5D
mov dword [statsskaterbuf], eax	; 79B60
push byte 20h	; 79B65
push dword 10Eh	; 79B67
push str_Gstat4	; 79B6C
call sub_8CCA8	; 79B71
add esp, byte 0Ch	; 79B76
mov dword [statsgoaliebuf], eax	; 79B79
push byte_ECDF4	; 79B7E
push dword 100h	; 79B83
push byte 0	; 79B88
call sub_8FFB0	; 79B8A
add esp, byte 0Ch	; 79B8F
xor eax, eax	; 79B92
.3:
mov dl, byte [dword eax+byte_ECDF4]	; 79B94
mov byte [esp+eax], dl	; 79B9A
inc eax	; 79B9D
cmp eax, 300h	; 79B9E
jl short MenuGameShowPlayerStats.3	; 79BA3
mov ebx, 10h	; 79BA5
mov edx, esp	; 79BAA
mov eax, 1	; 79BAC
call FadePalStep	; 79BB1
cmp byte [dword esp+0320h], 0	; 79BB6
je short .4	; 79BBE
mov eax, dword [HomeTeam]	; 79BC0
jmp short .5	; 79BC5
.4:
mov eax, dword [cont2team]	; 79BC7
.5:
sar eax, 10h	; 79BCC
call TeamRosterScreen	; 79BCF
push dword 0C2h	; 79BD4
mov ecx, 0C1h	; 79BD9
mov ebx, 0C0h	; 79BDE
mov edx, 2	; 79BE3
mov eax, unk_CF48F	; 79BE8
call DrawMenuBar	; 79BED
xor eax, eax	; 79BF2
.6:
mov dl, byte [dword eax+byte_ECDF4]	; 79BF4
mov byte [esp+eax], dl	; 79BFA
inc eax	; 79BFD
cmp eax, 300h	; 79BFE
jl short MenuGameShowPlayerStats.6	; 79C03
mov ebx, 10h	; 79C05
mov edx, esp	; 79C0A
xor eax, eax	; 79C0C
call FadePalStep	; 79C0E
push dword 0C2h	; 79C13
mov ecx, 0C1h	; 79C18
mov ebx, 0C0h	; 79C1D
mov edx, 2	; 79C22
mov eax, unk_CF48F	; 79C27
call RunMenu	; 79C2C
mov ebx, 10h	; 79C31
mov edx, esp	; 79C36
mov eax, 1	; 79C38
call FadePalStep	; 79C3D
xor eax, eax	; 79C42
.7:
mov dl, byte [dword eax+byte_ECDF4]	; 79C44
mov byte [esp+eax], dl	; 79C4A
inc eax	; 79C4D
cmp eax, 300h	; 79C4E
jl short MenuGameShowPlayerStats.7	; 79C53
xor edi, edi	; 79C55
mov dword [dword_DC738], edi	; 79C57
mov dword [statsredrawcb], edi	; 79C5D
mov edx, dword [statsteambuf]	; 79C63
push edx	; 79C69
call FreeMemBlock	; 79C6A
add esp, byte 4	; 79C6F
mov ebx, dword [statsgoaliebuf]	; 79C72
push ebx	; 79C78
call FreeMemBlock	; 79C79
add esp, byte 4	; 79C7E
mov ecx, dword [statsskaterbuf]	; 79C81
push ecx	; 79C87
call FreeMemBlock	; 79C88
add esp, byte 4	; 79C8D
mov edi, dword [statsplayerbuf]	; 79C90
push edi	; 79C96
call FreeMemBlock	; 79C97
add esp, byte 4	; 79C9C
xor eax, eax	; 79C9F
mov dword [statsplayerbuf], eax	; 79CA1
mov dword [statsteambuf], eax	; 79CA6
xor ebx, ebx	; 79CAB
mov dword [statsgoaliebuf], eax	; 79CAD
mov dword [statsskaterbuf], eax	; 79CB2
mov edi, dword [dword esp+0340h]	; 79CB7
push edi	; 79CBE
movzx edi, byte [dword esp+0324h]	; 79CBF
mov ecx, dword [dword esp+0340h]	; 79CC7
mov edx, dword [dword esp+0338h]	; 79CCE
mov eax, edi	; 79CD5
call DrawLineEditorScreen	; 79CD7
mov ebx, edi	; 79CDC
mov edx, dword [dword esp+0334h]	; 79CDE
mov eax, ebp	; 79CE5
call DrawGameLineJerseys	; 79CE7
mov ebp, dword [esi]	; 79CEC
test ebp, ebp	; 79CEE
jl near .10	; 79CF0
mov edx, ebp	; 79CF6
mov eax, ebp	; 79CF8
shl eax, 2	; 79CFA
sub eax, ebp	; 79CFD
shl eax, 2	; 79CFF
sub eax, ebp	; 79D02
xor edx, ebp	; 79D04
mov dl, byte [nosplit eax*2+gmrosterslot]	; 79D06
mov eax, edx	; 79D0D
shl eax, 2	; 79D0F
add eax, edx	; 79D12
shl eax, 3	; 79D14
sub eax, edx	; 79D17
mov edx, eax	; 79D19
mov eax, edi	; 79D1B
shl eax, 4	; 79D1D
add eax, edi	; 79D20
shl eax, 4	; 79D22
add eax, edi	; 79D25
cmp byte [dword edx+eax*4+hmroster], 2	; 79D27
jne short .8	; 79D2F
push dword 0C1h	; 79D31
push dword 0FDh	; 79D36
jmp short .9	; 79D3B
.8:
push dword 0C1h	; 79D3D
push dword 0C0h	; 79D42
.9:
call sub_8E9C0	; 79D47
add esp, byte 8	; 79D4C
mov edi, dword [esi]	; 79D4F
mov eax, edi	; 79D51
shl eax, 2	; 79D53
sub eax, edi	; 79D56
shl eax, 2	; 79D58
sub eax, edi	; 79D5B
add eax, eax	; 79D5D
mov edx, gmroster	; 79D5F
add edx, eax	; 79D64
add edx, byte 3	; 79D66
push edx	; 79D69
xor edx, edx	; 79D6A
mov dl, byte [dword eax+gmrosterjersey]	; 79D6C
push edx	; 79D72
mov al, byte [dword eax+gmroster]	; 79D73
and eax, 0FFh	; 79D79
push eax	; 79D7E
push str_C2dS3	; 79D7F
lea eax, [dword esp+0310h]	; 79D84
push eax	; 79D8B
call sprintf_	; 79D8C
add esp, byte 14h	; 79D91
mov edx, dword [esi]	; 79D94
mov eax, edx	; 79D96
shl eax, 2	; 79D98
sub eax, edx	; 79D9B
shl eax, 2	; 79D9D
add eax, edx	; 79DA0
lea edx, [byte eax+016h]	; 79DA2
lea ebx, [dword esp+0300h]	; 79DA5
mov eax, 1FAh	; 79DAC
call PrintLineEdStatus	; 79DB1
.10:
mov ebx, 10h	; 79DB6
mov edx, esp	; 79DBB
xor eax, eax	; 79DBD
call FadePalStep	; 79DBF
xor eax, eax	; 79DC4
add esp, 324h	; 79DC6
jmp near MenuSaveDefaultLines_pop	; 79DCC
; C: src/front/game_lines/MenuReturnToLineEditor.c
%ifdef CBUILD
%include "c/front/game_lines/MenuReturnToLineEditor.inc"
%else
MenuReturnToLineEditor:
push dword 4	; 79DD1
call __CHK	; 79DD6
mov eax, 1	; 79DDB
ret	; 79DE0
%endif ; C
; C: src/front/game_lines/MenuSaveDefaultLines.c (GameScratchPlayer)
%ifdef CBUILD
%include "c/front/game_lines/MenuSaveDefaultLines.GameScratchPlayer.inc"
%else
GameScratchPlayer:
push dword 48h	; 79DE1
call __CHK	; 79DE6
push esi	; 79DEB
push edi	; 79DEC
push ebp	; 79DED
sub esp, byte 24h	; 79DEE
mov edi, eax	; 79DF1
mov byte [byte esp+020h], bl	; 79DF3
mov esi, ecx	; 79DF7
xor edx, edx	; 79DF9
.1:
mov ebx, dword [esi]	; 79DFB
mov eax, ebx	; 79DFD
shl eax, 2	; 79DFF
sub eax, ebx	; 79E02
shl eax, 2	; 79E04
sub eax, ebx	; 79E07
lea ebx, [eax+eax]	; 79E09
lea eax, [edi+edx]	; 79E0C
mov cl, byte [eax]	; 79E0F
cmp cl, byte [dword ebx+gmrosterjersey]	; 79E11
jne short .2	; 79E17
mov byte [eax], 64h	; 79E19
.2:
inc edx	; 79E1C
cmp edx, byte 28h	; 79E1D
jl short GameScratchPlayer.1	; 79E20
mov dword [menuact_savelines], MenuSaveTheseLines	; 79E22
mov ebx, MenuUseTheseLines	; 79E2C
mov dword [menuact_uselines], ebx	; 79E31
mov dword [menuact_uselines2], ebx	; 79E37
mov ebp, MenuSaveDefaultLines	; 79E3D
mov dword [menuact_savedeflines], ebp	; 79E42
mov dword [menuact_savedeflines2], ebp	; 79E48
xor edx, edx	; 79E4E
.3:
cmp byte [edx+edi], 64h	; 79E50
jne short .4	; 79E54
xor edx, edx	; 79E56
mov dword [menuact_savelines], edx	; 79E58
mov dword [menuact_uselines], edx	; 79E5E
mov dword [menuact_uselines2], edx	; 79E64
mov dword [menuact_savedeflines], edx	; 79E6A
mov dword [menuact_savedeflines2], edx	; 79E70
jmp short .5	; 79E76
.4:
inc edx	; 79E78
cmp edx, byte 28h	; 79E79
jl short GameScratchPlayer.3	; 79E7C
.5:
mov edx, dword [esi]	; 79E7E
mov eax, edx	; 79E80
shl eax, 2	; 79E82
sub eax, edx	; 79E85
shl eax, 2	; 79E87
sub eax, edx	; 79E8A
xor edx, edx	; 79E8C
mov dl, byte [nosplit eax*2+gmrosterslot]	; 79E8E
mov ecx, edx	; 79E95
shl ecx, 2	; 79E97
add ecx, edx	; 79E9A
shl ecx, 3	; 79E9C
sub ecx, edx	; 79E9F
xor ebx, ebx	; 79EA1
mov bl, byte [byte esp+020h]	; 79EA3
mov eax, ebx	; 79EA7
shl eax, 4	; 79EA9
add eax, ebx	; 79EAC
shl eax, 4	; 79EAE
add eax, ebx	; 79EB1
mov byte [dword ecx+eax*4+hmroster], 2	; 79EB3
mov edx, dword [byte esp+034h]	; 79EBB
mov eax, edi	; 79EBF
call DrawGameLineJerseys	; 79EC1
push dword 0C1h	; 79EC6
push dword 0FCh	; 79ECB
call sub_8E9C0	; 79ED0
add esp, byte 8	; 79ED5
mov edx, dword [esi]	; 79ED8
mov eax, edx	; 79EDA
shl eax, 2	; 79EDC
sub eax, edx	; 79EDF
shl eax, 2	; 79EE1
sub eax, edx	; 79EE4
add eax, eax	; 79EE6
mov edx, gmroster	; 79EE8
add edx, eax	; 79EED
add edx, byte 3	; 79EEF
push edx	; 79EF2
xor edx, edx	; 79EF3
mov dl, byte [dword eax+gmrosterjersey]	; 79EF5
push edx	; 79EFB
mov al, byte [dword eax+gmroster]	; 79EFC
and eax, 0FFh	; 79F02
push eax	; 79F07
push str_C2dS3	; 79F08
lea eax, [byte esp+010h]	; 79F0D
push eax	; 79F11
call sprintf_	; 79F12
add esp, byte 14h	; 79F17
mov edx, dword [esi]	; 79F1A
mov eax, edx	; 79F1C
shl eax, 2	; 79F1E
sub eax, edx	; 79F21
shl eax, 2	; 79F23
add eax, edx	; 79F26
lea edx, [byte eax+016h]	; 79F28
mov ebx, esp	; 79F2B
mov eax, 1FAh	; 79F2D
call PrintLineEdStatus	; 79F32
xor eax, eax	; 79F37
add esp, byte 24h	; 79F39
jmp near MenuSaveDefaultLines_pop	; 79F3C
%endif ; C
; C: src/front/game_lines/GameDressPlayer.c
%ifdef CBUILD
%include "c/front/game_lines/GameDressPlayer.inc"
%else
GameDressPlayer:
push dword 40h	; 79F41
call __CHK	; 79F46
push esi	; 79F4B
push edi	; 79F4C
sub esp, byte 20h	; 79F4D
mov edi, eax	; 79F50
mov esi, ecx	; 79F52
mov edx, dword [ecx]	; 79F54
mov eax, edx	; 79F56
shl eax, 2	; 79F58
sub eax, edx	; 79F5B
shl eax, 2	; 79F5D
sub eax, edx	; 79F60
xor edx, edx	; 79F62
mov dl, byte [nosplit eax*2+gmrosterslot]	; 79F64
mov ecx, edx	; 79F6B
shl ecx, 2	; 79F6D
add ecx, edx	; 79F70
shl ecx, 3	; 79F72
sub ecx, edx	; 79F75
and ebx, 0FFh	; 79F77
mov eax, ebx	; 79F7D
shl eax, 4	; 79F7F
add eax, ebx	; 79F82
shl eax, 4	; 79F84
add eax, ebx	; 79F87
mov byte [dword ecx+eax*4+hmroster], 3	; 79F89
mov edx, dword [byte esp+02Ch]	; 79F91
mov eax, edi	; 79F95
call DrawGameLineJerseys	; 79F97
push dword 0C1h	; 79F9C
push dword 0C0h	; 79FA1
call sub_8E9C0	; 79FA6
add esp, byte 8	; 79FAB
mov edx, dword [esi]	; 79FAE
mov eax, edx	; 79FB0
shl eax, 2	; 79FB2
sub eax, edx	; 79FB5
shl eax, 2	; 79FB7
sub eax, edx	; 79FBA
add eax, eax	; 79FBC
mov edx, gmroster	; 79FBE
add edx, eax	; 79FC3
add edx, byte 3	; 79FC5
push edx	; 79FC8
xor edx, edx	; 79FC9
mov dl, byte [dword eax+gmrosterjersey]	; 79FCB
push edx	; 79FD1
mov al, byte [dword eax+gmroster]	; 79FD2
and eax, 0FFh	; 79FD8
push eax	; 79FDD
push str_C2dS3	; 79FDE
lea eax, [byte esp+010h]	; 79FE3
push eax	; 79FE7
call sprintf_	; 79FE8
add esp, byte 14h	; 79FED
mov edx, dword [esi]	; 79FF0
mov eax, edx	; 79FF2
shl eax, 2	; 79FF4
sub eax, edx	; 79FF7
shl eax, 2	; 79FF9
add eax, edx	; 79FFC
lea edx, [byte eax+016h]	; 79FFE
mov ebx, esp	; 7A001
mov eax, 1FAh	; 7A003
call PrintLineEdStatus	; 7A008
xor eax, eax	; 7A00D
add esp, byte 20h	; 7A00F
pop edi	; 7A012
pop esi	; 7A013
ret 18h	; 7A014
%endif ; C
; C: src/front/game_lines/BlitJerseyDigit.c
%ifdef CBUILD
%include "c/front/game_lines/BlitJerseyDigit.inc"
%else
BlitJerseyDigit:
push dword 18h	; 7A017
call __CHK	; 7A01C
push esi	; 7A021
push edi	; 7A022
push ebp	; 7A023
sub esp, byte 8	; 7A024
mov esi, eax	; 7A027
mov edi, edx	; 7A029
mov byte [byte esp+04h], bl	; 7A02B
mov ebp, dword [byte esp+018h]	; 7A02F
xor ebx, ebx	; 7A033
.1:
mov ecx, 20h	; 7A035
mov eax, ebx	; 7A03A
mov edx, ebx	; 7A03C
sar edx, 1Fh	; 7A03E
idiv ecx	; 7A041
test edx, edx	; 7A043
jne short .2	; 7A045
mov ecx, edi	; 7A047
shl ecx, 2	; 7A049
sub ecx, edi	; 7A04C
shl ecx, 2	; 7A04E
mov eax, ebx	; 7A051
mov edx, ebx	; 7A053
sar edx, 1Fh	; 7A055
shl edx, 5	; 7A058
LD sbb, eax, edx	; 7A05B
sar eax, 5	; 7A05D
mov eax, dword [dword ecx+eax*4+jerseydigits]	; 7A060
mov dword [esp], eax	; 7A067
.2:
test byte [esp], 1	; 7A06A
je short .5	; 7A06E
test ebp, ebp	; 7A070
je short .3	; 7A072
cmp ebx, byte 23h	; 7A074
jle short .3	; 7A077
lea eax, [byte ebx+030h]	; 7A079
jmp short .4	; 7A07C
.3:
mov eax, ebx	; 7A07E
.4:
mov dl, byte [byte esp+04h]	; 7A080
mov byte [esi+eax], dl	; 7A084
.5:
sar dword [esp], 1	; 7A087
inc ebx	; 7A08A
cmp ebx, byte 54h	; 7A08B
jl short BlitJerseyDigit.1	; 7A08E
add esp, byte 8	; 7A090
pop ebp	; 7A093
pop edi	; 7A094
pop esi	; 7A095
ret 4	; 7A096
%endif ; C
; C: src/front/game_lines/MakeJerseyShape.c
%ifdef CBUILD
%include "c/front/game_lines/MakeJerseyShape.inc"
%else
MakeJerseyShape:
push dword 18h	; 7A099
call __CHK	; 7A09E
push esi	; 7A0A3
push edi	; 7A0A4
push ebp	; 7A0A5
sub esp, byte 4	; 7A0A6
mov esi, eax	; 7A0A9
mov edi, edx	; 7A0AB
xor eax, eax	; 7A0AD
jmp short .2	; 7A0AF
.1:
movsx edx, ax	; 7A0B1
mov byte [edx+esi], cl	; 7A0B4
inc eax	; 7A0B7
.2:
cmp ax, 8Fh	; 7A0B8
jle short MakeJerseyShape.1	; 7A0BC
mov eax, 0C0h	; 7A0BE
jmp short .4	; 7A0C3
.3:
movsx edx, ax	; 7A0C5
mov byte [edx+esi], cl	; 7A0C8
inc eax	; 7A0CB
.4:
cmp ax, 0EFh	; 7A0CC
jle short MakeJerseyShape.3	; 7A0D0
cmp edi, byte 63h	; 7A0D2
ja short .x	; 7A0D5
cmp edi, byte 0Ah	; 7A0D7
jae short .5	; 7A0DA
push byte 0	; 7A0DC
and ecx, 0FFh	; 7A0DE
and ebx, 0FFh	; 7A0E4
lea eax, [byte esi+030h]	; 7A0EA
mov edx, edi	; 7A0ED
jmp short .6	; 7A0EF
.5:
push byte 0	; 7A0F1
movzx ebp, cl	; 7A0F3
xor eax, eax	; 7A0F6
mov al, bl	; 7A0F8
mov dword [byte esp+04h], eax	; 7A0FA
mov ebx, 0Ah	; 7A0FE
xor edx, edx	; 7A103
mov eax, edi	; 7A105
div ebx	; 7A107
mov edx, eax	; 7A109
mov ecx, ebp	; 7A10B
mov ebx, dword [byte esp+04h]	; 7A10D
mov eax, esi	; 7A111
call BlitJerseyDigit	; 7A113
push byte 1	; 7A118
mov ebx, 0Ah	; 7A11A
xor edx, edx	; 7A11F
mov eax, edi	; 7A121
div ebx	; 7A123
lea eax, [byte esi+06Ch]	; 7A125
mov ecx, ebp	; 7A128
mov ebx, dword [byte esp+04h]	; 7A12A
.6:
call BlitJerseyDigit	; 7A12E
.x:
add esp, byte 4	; 7A133
pop ebp	; 7A136
pop edi	; 7A137
pop esi	; 7A138
ret	; 7A139
%endif ; C
