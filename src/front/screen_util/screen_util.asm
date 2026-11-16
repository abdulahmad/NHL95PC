; Scoreboard sprites, the blitter the menus call, and the titles on the statistics screens.
bits 32
%include "hockey.inc"
section s_1CC3D progbits alloc exec nowrite align=1
extern __CHK, awlineind, awpanelspr, str_Dashes, awayremap, homeremap, cddriveptr, cliprect_x0
extern cliprect_x1, cliprect_y0, cliprect_y1, clockdigits, dirtyrectcount, dirtyrectptr, dword_C679D, dword_C67B9
extern dword_C67BD, dword_C891E, dword_CE8EB, dword_CF00B, dword_CF4CB, dword_CF517, standingsmenubar_srccnt, dword_CF5D7
extern dword_CF5F7, dword_CF617, dword_CF637, dword_CF657, dword_CF677, rostermenubar_srccnt, teamstatsmenubar_srccnt, skaterstatsmenubar_srccnt
extern goaliestatsmenubar_srccnt, dword_CFA4B, exhstate, fileoncd, hmlineind, hmpanelspr, lastsprremap, lgstate
extern linesprites, MakePath, mi_9394Playoffs, mi_9394Season, mi_LeaguePlayoffs, mi_LeagueSeason, mi_PlayoffMode, menutext_statsleague
extern menuact_statsleague, menutext_statslgplayoffs, menuact_statslgplayoffs, menutext_statsplayoff, menuact_statsplayoff, off_CF51F, off_CF5DF, off_CF61F
extern off_CF67F, penaltydigits, postate, scoredigits, scrbrdshapes, spritedrawcount, statsfromleague, statsleague
extern statsplayoffs, StatsSelLeague, StatsSelLeaguePlayoffs, StatsSelPlayoffMode, statsteamsel, str_BroadcastBooth, str_HomeLineTags, str_Homp
extern str_IntermissionDesk, str_LeagueCalendar, str_LgPlayoffsTitle, str_LgSeasonTitle, str_LineCodes0, str_LineCodes1, str_LineCodes2, str_LineNames
extern str_PlayOffsSfx, str_PlayoffTree, str_POTitle, str_PPV, str_RinkSide, str_scrbrd1, str_SeasonPlayOffsSfx, str_SeasonSfx
extern str_SportsCentral, str_VisLineTags, str_Visp, strcpy_, strncpy_, sub_6AB7C, sub_8E8A0, ProjectPointList
extern FindShape, sub_B4CD8, SetColorRemap, sub_B4E50, sub_B500C, sub_B52B4, sub_B5584, sub_B56B8
extern sub_B5974, sub_B5AC8, awayremap_eC0, homeremap_eC0, vgapage
global LoadScoreboardGfx, DrawSprite_jt, DrawSprite, DrawSprite_b0, DrawSprite_b1, DrawSprite_b2, DrawSprite_b3, DrawSprite_b4
global DrawSprite_b5, DrawSprite_b6, DrawSprite_b7, NullBlit, NullFunc_1D024, AddDirtyRect, SetupStatsSourceMenu_jt, SetupStatsSourceMenu
global SetupStatsSourceMenu_lg, SetupStatsSourceMenu_po, SetupStatsSourceMenu_exh, SetupStatsSourceMenu_all, BuildSavedGameLabels, StrLenToDot, SetScreenTitle_jt, SetScreenTitle
global SetScreenTitle_central, SetScreenTitle_calendar, SetScreenTitle_tree, SetScreenTitle_booth, SetScreenTitle_desk, SetScreenTitle_rink, StrPrefixDiffers
;-----------------------------------------------------------------------------
; LoadScoreboardGfx                                               1CC3D  95 PC
; Loads scrbrd1.PPV, gets scoredigits/clockdigits/penalty digits, line
; indicator and visp/homp sprites; called from LoadGameTeams
;-----------------------------------------------------------------------------
; C: src/front/screen_util/LoadScoreboardGfx.c
%ifdef CBUILD
%include "c/front/screen_util/LoadScoreboardGfx.inc"
%else
LoadScoreboardGfx:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ecx, str_PPV
        mov ebx, str_scrbrd1
        cmp byte [fileoncd+016Ch], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [scrbrdshapes], eax
        push scoredigits
        push str_LineCodes0
        push eax
        call ProjectPointList
        add esp, byte 0Ch
        push clockdigits
        push str_LineCodes1
        mov edx, dword [scrbrdshapes]
        push edx
        call ProjectPointList
        add esp, byte 0Ch
        push penaltydigits
        push str_LineCodes2
        mov ebx, dword [scrbrdshapes]
        push ebx
        call ProjectPointList
        add esp, byte 0Ch
        push awlineind
        push str_VisLineTags
        mov ecx, dword [scrbrdshapes]
        push ecx
        call ProjectPointList
        add esp, byte 0Ch
        push hmlineind
        push str_HomeLineTags
        mov esi, dword [scrbrdshapes]
        push esi
        call ProjectPointList
        add esp, byte 0Ch
        push str_Visp
        mov edi, dword [scrbrdshapes]
        push edi
        call FindShape
        add esp, byte 8
        mov dword [awpanelspr], eax
        push str_Homp
        mov ebp, dword [scrbrdshapes]
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [hmpanelspr], eax
        push linesprites
        push str_LineNames
        mov eax, dword [scrbrdshapes]
        push eax
        call ProjectPointList
        add esp, byte 0Ch
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
DrawSprite_jt:
        dd DrawSprite_b0
        dd DrawSprite_b1
        dd DrawSprite_b2
        dd DrawSprite_b3
        dd DrawSprite_b4
        dd DrawSprite_b5
        dd DrawSprite_b6
        dd DrawSprite_b7
;-----------------------------------------------------------------------------
; DrawSprite                                   1CD73  95 PC, medium confidence
; 233 callers; clips sprite rect against cliprect_*, optional hflip, team
; palette remap, dispatches to 8 blitters B4CD8..B5AC8
;-----------------------------------------------------------------------------
DrawSprite:
        push dword 3Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov esi, eax
        mov word [byte esp+018h], cx
        xor ecx, ecx
        mov dword [byte esp+010h], ecx
        cmp word [byte esp+018h], byte 0
        je short .1
        mov cx, word [byte eax+04h]
        mov eax, edx
        sub eax, ecx
        add ax, word [byte esi+08h]
        inc eax
        mov word [byte esp+014h], ax
        jmp short .2
.1:
        mov ax, word [byte eax+08h]
        sub edx, eax
        mov word [byte esp+014h], dx
.2:
        mov ax, word [byte esi+0Ah]
        sub ebx, eax
        mov word [byte esp+01Ch], bx
        mov eax, dword [byte esp+014h]
        add ax, word [byte esi+04h]
        dec eax
        mov edx, ebx
        add dx, word [byte esi+06h]
        mov edi, dword [byte esp+012h]
        sar edi, 10h
        cmp edi, dword [cliprect_x1]
        jge near DrawSprite_b0.x
        cwde
        cmp eax, dword [cliprect_x0]
        jl near DrawSprite_b0.x
        mov ecx, dword [byte esp+01Ah]
        sar ecx, 10h
        cmp ecx, dword [cliprect_y1]
        jge near DrawSprite_b0.x
        movsx edx, dx
        cmp edx, dword [cliprect_y0]
        jle near DrawSprite_b0.x
        cmp edi, dword [cliprect_x0]
        jl short .3
        cmp eax, dword [cliprect_x1]
        jge short .3
        cmp ecx, dword [cliprect_y0]
        jl short .3
        cmp edx, dword [cliprect_y1]
        jl short .4
.3:
        mov dword [byte esp+010h], 1
.4:
        cmp word [byte esp+018h], byte 0
        je short .5
        add dword [byte esp+010h], byte 4
.5:
        mov edx, dword [byte esp+030h]
        test dx, dx
        jl near .17
        mov eax, dword [byte esp+016h]
        sar eax, 10h
        add eax, eax
        mov ebp, dword [byte esp+02Eh]
        sar ebp, 10h
        add ebp, eax
        cmp ebp, dword [lastsprremap]
        je near .16
        cmp word [byte esp+018h], byte 0
        je short .9
        test dx, dx
        je short .6
        mov edi, awayremap_eC0
        jmp short .7
.6:
        mov edi, homeremap_eC0
.7:
        xor edx, edx
.8:
        mov bl, byte [byte edx+edi+04h]
        mov byte [byte esp+08h], bl
        mov bl, byte [byte edx+edi+03h]
        mov byte [byte esp+09h], bl
        mov bl, byte [byte edx+edi+01h]
        mov byte [byte esp+0Bh], bl
        mov bl, byte [edx+edi]
        mov byte [byte esp+0Ch], bl
        mov bl, byte [byte esp+08h]
        mov byte [edx+edi], bl
        mov bl, byte [byte esp+09h]
        mov byte [byte edx+edi+01h], bl
        mov bl, byte [byte esp+0Bh]
        mov byte [byte edx+edi+03h], bl
        mov bl, byte [byte esp+0Ch]
        mov byte [byte edx+edi+04h], bl
        add edx, byte 10h
        cmp edx, byte 40h
        jl short DrawSprite.8
.9:
        cmp word [byte esp+030h], byte 0
        je short .10
        mov eax, awayremap
        jmp short .11
.10:
        mov eax, homeremap
.11:
        push eax
        call SetColorRemap
        add esp, byte 4
        cmp word [byte esp+018h], byte 0
        je short .15
        cmp word [byte esp+030h], byte 0
        je short .12
        mov edi, awayremap_eC0
        jmp short .13
.12:
        mov edi, homeremap_eC0
.13:
        xor edx, edx
.14:
        mov bl, byte [byte edx+edi+04h]
        mov byte [esp], bl
        mov bl, byte [byte edx+edi+03h]
        mov byte [byte esp+01h], bl
        mov bl, byte [byte edx+edi+01h]
        mov byte [byte esp+03h], bl
        mov bl, byte [edx+edi]
        mov byte [byte esp+04h], bl
        mov bl, byte [esp]
        mov byte [edx+edi], bl
        mov bl, byte [byte esp+01h]
        mov byte [byte edx+edi+01h], bl
        mov bl, byte [byte esp+03h]
        mov byte [byte edx+edi+03h], bl
        mov bl, byte [byte esp+04h]
        mov byte [byte edx+edi+04h], bl
        add edx, byte 10h
        cmp edx, byte 40h
        jl short DrawSprite.14
.15:
        mov dword [lastsprremap], ebp
.16:
        add dword [byte esp+010h], byte 2
.17:
        mov eax, dword [esi]
        shl eax, 18h
        sar eax, 18h
        test eax, eax
        je short .18
        add dword [byte esp+010h], byte 8
.18:
        mov eax, dword [byte esi+04h]
        sar eax, 10h
        mov ebp, dword [byte esp+01Ah]
        sar ebp, 10h
        add eax, ebp
        push eax
        mov ecx, dword [byte esi+02h]
        sar ecx, 10h
        mov edi, dword [byte esp+016h]
        sar edi, 10h
        add ecx, edi
        mov eax, dword [spritedrawcount]
        lea edx, [byte eax+01h]
        mov dword [spritedrawcount], edx
        mov ebx, ebp
        mov edx, edi
        call sub_6AB7C
        mov eax, dword [byte esp+010h]
        sub eax, byte 8
        cmp ax, 7
        ja short DrawSprite_b0.x
        and eax, 0FFFFh
        jmp dword [nosplit cs:eax*4+DrawSprite_jt]
DrawSprite_b0:
        push ebp
        push edi
        push esi
        call sub_B4CD8
.1:
        add esp, byte 0Ch
.x:
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        ret 8
DrawSprite_b1:
        push ebp
        push edi
        push esi
        call sub_B500C
        jmp short DrawSprite_b0.1
DrawSprite_b2:
        push ebp
        push edi
        push esi
        call sub_B4E50
        jmp short DrawSprite_b0.1
DrawSprite_b3:
        push ebp
        push edi
        push esi
        call sub_B52B4
        jmp short DrawSprite_b0.1
DrawSprite_b4:
        push ebp
        push edi
        push esi
        call sub_B5584
        jmp short DrawSprite_b0.1
DrawSprite_b5:
        push ebp
        push edi
        push esi
        call sub_B56B8
        jmp short DrawSprite_b0.1
DrawSprite_b6:
        push ebp
        push edi
        push esi
        call sub_B5974
        jmp short DrawSprite_b0.1
DrawSprite_b7:
        push ebp
        push edi
        push esi
        call sub_B5AC8
        jmp short DrawSprite_b0.1
;-----------------------------------------------------------------------------
; NullBlit                                     1D019  95 PC, medium confidence
; Empty fn filling first 8 slots of the blitter table at C66D8
;-----------------------------------------------------------------------------
; C: src/front/screen_util/NullBlit.c
%ifdef CBUILD
%include "c/front/screen_util/NullBlit.inc"
%else
NullBlit:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; NullFunc_1D024                                                  1D024  95 PC
; Empty fn, no refs
;-----------------------------------------------------------------------------
; C: src/front/screen_util/NullFunc_1D024.c
%ifdef CBUILD
%include "c/front/screen_util/NullFunc_1D024.inc"
%else
NullFunc_1D024:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AddDirtyRect                                 1D02F  95 PC, medium confidence
; Appends x/4,y,w/4,h 16-byte rect to dirtyrectptr[page], bumps
; dirtyrectcount[page]; no direct refs
;-----------------------------------------------------------------------------
; C: src/front/screen_util/AddDirtyRect.c
%ifdef CBUILD
%include "c/front/screen_util/AddDirtyRect.inc"
%else
AddDirtyRect:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        mov esi, edx
        movsx edi, ax
        movsx edx, bx
        add edx, edi
        shr edx, 2
        movsx ebx, ax
        shr ebx, 2
        sub edx, ebx
        lea ebx, [byte edx+01h]
        cmp dword [vgapage], byte 0
        sete dl
        and edx, 0FFh
        mov edx, dword [nosplit edx*4+dirtyrectptr]
        mov dword [byte edx+08h], ebx
        movsx ebx, cx
        cmp dword [vgapage], byte 0
        sete dl
        and edx, 0FFh
        mov edx, dword [nosplit edx*4+dirtyrectptr]
        mov dword [byte edx+0Ch], ebx
        cwde
        mov edx, eax
        shr edx, 2
        cmp dword [vgapage], byte 0
        sete al
        and eax, 0FFh
        mov eax, dword [nosplit eax*4+dirtyrectptr]
        mov dword [eax], edx
        movsx edx, si
        cmp dword [vgapage], byte 0
        sete al
        and eax, 0FFh
        mov eax, dword [nosplit eax*4+dirtyrectptr]
        mov dword [byte eax+04h], edx
        mov esi, dword [vgapage]
        test esi, esi
        sete al
        and eax, 0FFh
        inc dword [nosplit eax*4+dirtyrectcount]
        test esi, esi
        sete al
        and eax, 0FFh
        add dword [nosplit eax*4+dirtyrectptr], byte 10h
        pop edi
        pop esi
        ret
%endif ; C
SetupStatsSourceMenu_jt:
        dd SetupStatsSourceMenu_all
        dd SetupStatsSourceMenu_exh
        dd SetupStatsSourceMenu_po
        dd SetupStatsSourceMenu_lg
;-----------------------------------------------------------------------------
; SetupStatsSourceMenu                         1D100  95 PC, medium confidence
; Picks Exhibition/League/Playoffs stats source items from lgstate/postate,
; copies name to statsleague, sets item count
;-----------------------------------------------------------------------------
SetupStatsSourceMenu:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        test eax, eax
        jne short .4
        cmp byte [postate+4], 0
        je short .1
        cmp byte [lgstate+4], 0
        jne short .4
.1:
        cmp byte [postate+4], 0
        je short .2
        mov eax, 2
        jmp short .4
.2:
        cmp byte [lgstate+4], 0
        je short .3
        mov eax, 3
        jmp short .4
.3:
        mov eax, 1
.4:
        cmp eax, byte 3
        ja near SetupStatsSourceMenu_all.9
        jmp dword [nosplit cs:eax*4+SetupStatsSourceMenu_jt]
SetupStatsSourceMenu_lg:
        mov dword [menuact_statsleague], StatsSelLeague
        mov dword [menuact_statslgplayoffs], StatsSelLeaguePlayoffs
        mov dword [menutext_statsleague], mi_LeagueSeason
        mov dword [menutext_statslgplayoffs], mi_LeaguePlayoffs
        cmp byte [mi_PlayoffMode], 1
        je short .1
        cmp byte [mi_LeagueSeason], 1
        jne short .3
.1:
        mov byte [mi_LeagueSeason], 1
        mov ch, 2
        mov byte [mi_PlayoffMode], ch
        mov byte [mi_LeaguePlayoffs], ch
        mov byte [mi_9394Playoffs], ch
        mov byte [mi_9394Season], ch
        mov dword [statsfromleague], 1
        cmp dword [statsplayoffs], byte 0
        je short .2
        xor esi, esi
        mov dword [statsteamsel], esi
.2:
        xor edi, edi
        mov dword [statsplayoffs], edi
        jmp short .5
.3:
        cmp byte [mi_LeaguePlayoffs], 1
        jne short .6
        mov dl, 2
        mov byte [mi_PlayoffMode], dl
        mov byte [mi_LeagueSeason], dl
        mov byte [mi_9394Playoffs], dl
        mov byte [mi_9394Season], dl
        mov dword [statsfromleague], 1
        mov ebp, dword [statsplayoffs]
        test ebp, ebp
        jne short .4
        mov dword [statsteamsel], ebp
.4:
        mov dword [statsplayoffs], 1
.5:
        mov ebx, 1Fh
        mov edx, lgstate+4
        mov eax, statsleague
        call strncpy_
.6:
        mov ecx, 5
        jmp near SetupStatsSourceMenu_all.9
SetupStatsSourceMenu_po:
        mov dword [menuact_statsleague], StatsSelPlayoffMode
        mov dword [menutext_statsleague], mi_PlayoffMode
        cmp byte [mi_LeagueSeason], 1
        je short .1
        cmp byte [mi_LeaguePlayoffs], 1
        je short .1
        cmp byte [mi_PlayoffMode], 1
        jne short .3
.1:
        mov byte [mi_PlayoffMode], 1
        mov ch, 2
        mov byte [mi_LeaguePlayoffs], ch
        mov byte [mi_LeagueSeason], ch
        mov byte [mi_9394Playoffs], ch
        mov byte [mi_9394Season], ch
        mov dword [statsfromleague], 1
        mov ebx, dword [statsplayoffs]
        test ebx, ebx
        jne short .2
        mov dword [statsteamsel], ebx
.2:
        mov dword [statsplayoffs], 1
        mov ebx, 1Fh
        mov edx, postate+4
        mov eax, statsleague
        call strncpy_
.3:
        mov ecx, 4
        jmp near SetupStatsSourceMenu_all.9
SetupStatsSourceMenu_exh:
        mov dh, byte [mi_9394Season]
        cmp dh, 2
        jne short .2
        cmp dh, byte [mi_9394Playoffs]
        jne short .2
        mov byte [mi_9394Season], 1
        mov byte [mi_PlayoffMode], dh
        mov byte [mi_LeaguePlayoffs], dh
        mov byte [mi_LeagueSeason], dh
        mov byte [mi_9394Playoffs], dh
        xor edi, edi
        mov dword [statsfromleague], edi
        cmp dword [statsplayoffs], byte 0
        je short .1
        mov dword [statsteamsel], edi
.1:
        xor edx, edx
        mov dword [statsplayoffs], edx
        mov ebx, 1Fh
        mov edx, exhstate+4
        mov eax, statsleague
        call strncpy_
.2:
        mov ecx, 2
        jmp near SetupStatsSourceMenu_all.9
SetupStatsSourceMenu_all:
        mov dword [menuact_statsleague], StatsSelLeague
        mov dword [menuact_statslgplayoffs], StatsSelLeaguePlayoffs
        mov dword [menuact_statsplayoff], StatsSelPlayoffMode
        mov dword [menutext_statsleague], mi_LeagueSeason
        mov dword [menutext_statslgplayoffs], mi_LeaguePlayoffs
        mov dword [menutext_statsplayoff], mi_PlayoffMode
        cmp byte [mi_LeagueSeason], 1
        jne short .3
        mov al, 2
        mov byte [mi_PlayoffMode], al
        mov byte [mi_LeaguePlayoffs], al
        mov byte [mi_9394Playoffs], al
        mov byte [mi_9394Season], al
        mov dword [statsfromleague], 1
        cmp dword [statsplayoffs], byte 0
        je short .1
        xor esi, esi
        mov dword [statsteamsel], esi
.1:
        xor edi, edi
        mov dword [statsplayoffs], edi
.2:
        mov ebx, 1Fh
        mov edx, lgstate+4
        jmp near .7
.3:
        cmp byte [mi_LeaguePlayoffs], 1
        jne short .5
        mov dh, 2
        mov byte [mi_PlayoffMode], dh
        mov byte [mi_LeagueSeason], dh
        mov byte [mi_9394Playoffs], dh
        mov byte [mi_9394Season], dh
        mov dword [statsfromleague], 1
        mov ebp, dword [statsplayoffs]
        test ebp, ebp
        jne short .4
        mov dword [statsteamsel], ebp
.4:
        mov dword [statsplayoffs], 1
        jmp short SetupStatsSourceMenu_all.2
.5:
        cmp byte [mi_PlayoffMode], 1
        jne short .8
        mov cl, 2
        mov byte [mi_LeaguePlayoffs], cl
        mov byte [mi_LeagueSeason], cl
        mov byte [mi_9394Playoffs], cl
        mov byte [mi_9394Season], cl
        mov dword [statsfromleague], 1
        mov ebx, dword [statsplayoffs]
        test ebx, ebx
        jne short .6
        mov dword [statsteamsel], ebx
.6:
        mov dword [statsplayoffs], 1
        mov ebx, 1Fh
        mov edx, postate+4
.7:
        mov eax, statsleague
        call strncpy_
.8:
        mov ecx, 7
.9:
        cmp ecx, byte 4
        jne short .10
        mov dword [dword_C67B9], 0C5h
        xor bh, bh
        mov byte [str_Dashes], bh
        jmp short .11
.10:
        mov dword [dword_C67B9], 0F7h
        mov byte [str_Dashes], 2Dh
.11:
        xor edx, edx
        mov ebx, 11h
        jmp short .13
.12:
        mov eax, edx
        shl eax, 5
        mov dword [dword eax+dword_C67BD], ebx
        mov esi, dword [dword_C67B9]
        mov dword [dword eax+dword_C67B9], esi
        inc edx
        add ebx, byte 12h
.13:
        cmp edx, ecx
        jl short SetupStatsSourceMenu_all.12
        mov eax, ecx
        shl eax, 5
        mov dword [dword_CE8EB], ecx
        mov dword [dword_CF00B], ecx
        mov dword [dword_CF4CB], ecx
        mov dword [standingsmenubar_srccnt], ecx
        mov dword [rostermenubar_srccnt], ecx
        mov dword [teamstatsmenubar_srccnt], ecx
        mov dword [skaterstatsmenubar_srccnt], ecx
        mov dword [goaliestatsmenubar_srccnt], ecx
        mov dword [dword_CFA4B], ecx
        mov dword [dword_C891E], ecx
        inc dword [dword eax+dword_C679D]
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; BuildSavedGameLabels                                            1D518  95 PC
; Copies postate/lgstate names (dot-stripped) into the label strings and
; appends Play-Offs / Season suffixes to mi_ items
;-----------------------------------------------------------------------------
; C: src/front/screen_util/BuildSavedGameLabels.c
%ifdef CBUILD
%include "c/front/screen_util/BuildSavedGameLabels.inc"
%else
BuildSavedGameLabels:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        cmp byte [postate+4], 0
        je short .1
        mov eax, postate+4
        call StrLenToDot
        mov ebx, eax
        xor dl, dl
        mov byte [dword eax+postate+4], dl
        mov edx, postate+4
        mov eax, str_POTitle+1
        call strcpy_
        lea eax, [byte ebx+03h]
        add eax, mi_PlayoffMode
        mov edx, str_PlayOffsSfx
        call strcpy_
        mov byte [dword ebx+postate+4], 2Eh
.1:
        cmp byte [lgstate+4], 0
        je short .x
        mov eax, lgstate+4
        call StrLenToDot
        mov ebx, eax
        xor cl, cl
        mov byte [dword eax+lgstate+4], cl
        mov edx, lgstate+4
        mov eax, str_LgSeasonTitle+1
        call strcpy_
        mov edx, lgstate+4
        mov eax, str_LgPlayoffsTitle+1
        call strcpy_
        lea ecx, [byte ebx+03h]
        mov eax, mi_LeagueSeason
        add eax, ecx
        mov edx, str_SeasonSfx
        call strcpy_
        mov eax, mi_LeaguePlayoffs
        add eax, ecx
        mov edx, str_SeasonPlayOffsSfx
        call strcpy_
        mov byte [dword ebx+lgstate+4], 2Eh
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StrLenToDot                                                     1D5D5  95 PC
; Counts chars until NUL or '.'
;-----------------------------------------------------------------------------
; C: src/front/screen_util/StrLenToDot.c
%ifdef CBUILD
%include "c/front/screen_util/StrLenToDot.inc"
%else
StrLenToDot:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        xor edx, edx
        jmp short .2
.1:
        inc edx
        inc eax
.2:
        mov bl, byte [eax]
        test bl, bl
        je short .3
        cmp bl, 2Eh
        jne short StrLenToDot.1
.3:
        mov eax, edx
        pop edx
        pop ebx
        ret
%endif ; C
        db 090h
SetScreenTitle_jt:
        dd SetScreenTitle_central
        dd SetScreenTitle_tree
        dd SetScreenTitle_calendar
        dd SetScreenTitle_booth
        dd SetScreenTitle_desk
        dd SetScreenTitle_rink
;-----------------------------------------------------------------------------
; SetScreenTitle                                                  1D610  95 PC
; Mode 0-5 -> Sports Central/Playoff Tree/League Calendar/Broadcast
; Booth/Intermission Desk/Rink Side title + width into screen headers
;-----------------------------------------------------------------------------
; C: src/front/screen_util/SetScreenTitle.c
%ifdef CBUILD
%include "c/front/screen_util/SetScreenTitle.inc"
%else
SetScreenTitle:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp eax, byte 5
        ja short SetScreenTitle_rink.1
        jmp dword [nosplit cs:eax*4+SetScreenTitle_jt]
SetScreenTitle_central:
        mov ebx, str_SportsCentral
        mov edx, 67h
        jmp short SetScreenTitle_rink.1
SetScreenTitle_calendar:
        mov ebx, str_LeagueCalendar
        mov edx, 76h
        jmp short SetScreenTitle_rink.1
SetScreenTitle_tree:
        mov ebx, str_PlayoffTree
        mov edx, 59h
        jmp short SetScreenTitle_rink.1
SetScreenTitle_booth:
        mov ebx, str_BroadcastBooth
        mov edx, 73h
        jmp short SetScreenTitle_rink.1
SetScreenTitle_desk:
        mov ebx, str_IntermissionDesk
        mov edx, 7Eh
        jmp short SetScreenTitle_rink.1
SetScreenTitle_rink:
        mov ebx, str_RinkSide
        mov edx, 41h
.1:
        mov dword [off_CF67F], ebx
        mov dword [off_CF61F], ebx
        mov dword [off_CF5DF], ebx
        mov dword [off_CF51F], ebx
        mov dword [dword_CF5D7], edx
        mov dword [dword_CF517], edx
        cmp edx, byte 7Dh
        jg short .2
        mov edx, 7Dh
.2:
        mov dword [dword_CF677], edx
        mov dword [dword_CF657], edx
        mov dword [dword_CF637], edx
        mov dword [dword_CF617], edx
        mov dword [dword_CF5F7], edx
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StrPrefixDiffers                                                1D6BE  95 PC
; Returns 1 on first mismatching char before either NUL
;-----------------------------------------------------------------------------
; C: src/front/screen_util/StrPrefixDiffers.c
%ifdef CBUILD
%include "c/front/screen_util/StrPrefixDiffers.inc"
%else
StrPrefixDiffers:
        push dword 8
        call __CHK
        push ebx
.1:
        mov bl, byte [eax]
        test bl, bl
        je short .3
        mov bh, byte [edx]
        test bh, bh
        je short .3
        cmp bl, bh
        je short .2
        mov eax, 1
        pop ebx
        ret
.2:
        inc eax
        inc edx
        jmp short StrPrefixDiffers.1
.3:
        xor eax, eax
        pop ebx
        ret
%endif ; C
