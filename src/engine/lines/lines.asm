; Building lines. Sorting the players by position, the default lines, filling and refilling each slot,
; and which players can be removed (95G engine/lines95).
bits 32
%include "hockey.inc"
section s_644A8 progbits alloc exec nowrite align=1
extern __CHK, awlinetab, bannermsg, bannerstrs, bannertimer, ovlseqtimed, rinkobjanim, dressbystatus
extern lineslotgroups, lineslotgroupstart, hmrosterpos, awayremap, homeremap, rinkobjs_b3, hmtmgoalie_b1, doorZpos2
extern regd1_b1, defsort_d, dressflags, dressflags_aw, offsort_fwd, rpl_flip, rpl_jersey, rpl_pos
extern rpl_pos_b1, rpl_c1player, rpl_c2player, rpl_puckc, rpl_pbnum, rpl_pbnum_b1, rpl_objstep, rpl_objstep_b1
extern c1playernum, c2playernum, camx, camx_m2, camy, cddriveptr, cliprect_x0, cliprect_x1
extern cliprect_y0, cliprect_y1, clockticks, cont1team, cont2team, Crowd_Noise, crowdlevel, CrowdNoiseOff
extern curperiod, DrawFrameSprite, DrawRinkEndArt, DrawSprite, DrawSpriteNumber, ovlartfiles, markframes_e1, rinkobjdefs_m2
extern dword_CD41E, ovlmemneed, dword_D30BC, dword_D30C0, ovlstepart, ovlstepart_e21, ovlstepart_e30, dword_E0220
extern dword_E0230, ovlartbank, regd3_m2, regd0_m3, regd1_m3, dword_E9A9E, lineslotmark, dword_E9C85
extern linesortidx, dressedskaters, rpl_x_e14_m2, rpl_x_e14, rpl_x_e16, rpl_y_e14_m2, rpl_y_e14, rpl_y_e16
extern rpl_frame_e14_m2, rpl_frame_e14, rpl_flip_m3, rpl_jersey_m3, rpl_pos_m3, rpl_puckz_m2, rpl_c1player_m3, rpl_puckc_m3
extern rpl_objstep_m3, rpl_ysort, dword_ED74C, fileoncd, fox, foy, fputchar, FreeMemBlock
extern gameclock, gmode, gmode2, gsp, hmlinetab, hmroster, hmtmgoalie, hmtmstruct
extern joysampling, joysampling_save, lastsfx, MakePath, ovlartnames, ovlscripts, goaliemenuflags, goaliemenuflags_e02
extern ovlscript, ovlseq, ovlstep, ovlstepidx, ovlsteptimer, ovltimer, PBnum, Pencntdwn
extern photoptrsf, puckc, puckstruct, puckz, recbpr, RefStep, regd0, regd1
extern regd2, regd3, replayplay, replaysfx, replaystart, replaytick, scor2font, scor3font
extern scrollx, scrolly, setpersonel, sflags, sfx, shownumbers, SortCords, sprintf_
extern spritedrawcount, str_04d2, str_AWAYPALS, str_extBIN, str_HOMEPALS4, str_Pal30, str_PPV, str_Rinkpal
extern MarkZoneRect, sub_8DAB8, LoadBank, sub_8E8A0, TextSetColors, TextSetFont, ShapeBankCount, FillRect
extern sub_90EC0, PrintString, SortIndices, FindShape, JoyButtonMap, SetClipWindow, sub_B500C, sub_B5D80
extern textline1, textline2, textline3, textline4, textline5, hmplattr, offsort_c, defsort_r
extern offsort_d, defsort_c, offsort_l, defsort_l, offsort_r, defsort_fwd, ovlsteptime, Pencntdwn2
extern rinkobjdefs, replayfollowpl, rinkobjs, refYpos2, reftemp3, dressedfwds, dresseddefs, rpl_x
extern rpl_x_e15, rpl_y, rpl_y_e15, rpl_frame, rpl_frame_e15, rpl_puckz, word_E9FA9, rpl_camx
extern rpl_camy, rpl_objframe, xc1, yc1, yleader
global SortPlayersByPos, SortNonDefPlayers, BuildDefaultLines, lines_popx, CanFillLineSlot, lines_addesp10_x, FillDressedSlots, PickForLineSlot
global lines_popx2, PickGoalie, PickExtraSkater, RefillLineSlots, RemoveFromLines, SetupTeamLines, NormalizeDressFlags, CanRemovePlayer
;-----------------------------------------------------------------------------
; SortPlayersByPos                             644A8  95 PC, medium confidence
; (team, outlist, scores, poschar): for the 19h roster players whose position
; byte (hmrosterpos) is poschar takes their score, others -1; sorts
; (SortIndices) and writes the ranked roster indices to outlist;
; BuildDefaultLines calls it for D, R, L, C
;-----------------------------------------------------------------------------
; C: src/engine/lines/SortPlayersByPos.c
%ifdef CBUILD
%include "c/engine/lines/SortPlayersByPos.inc"
%else
SortPlayersByPos:
        push dword 24h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        push eax
        mov ebp, edx
        mov edi, ebx
        mov byte [byte esp+04h], cl
        xor eax, eax
.1:
        mov ebx, eax
        shl ebx, 2
        mov dword [dword ebx+linesortidx], eax
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        mov esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 2
        mov edx, eax
        shl edx, 2
        add edx, eax
        shl edx, 3
        sub edx, eax
        mov dl, byte [dword edx+esi+hmrosterpos]
        cmp dl, byte [byte esp+04h]
        je short .2
        mov dword [dword ebx+lineslotmark], 0FFFFFFFFh
        jmp short .3
.2:
        mov edx, eax
        movsx edx, word [edi+edx*2]
        mov dword [dword ebx+lineslotmark], edx
.3:
        inc eax
        cmp eax, byte 19h
        jl short SortPlayersByPos.1
        push linesortidx
        push lineslotmark
        push byte 19h
        call SortIndices
        add esp, byte 0Ch
        xor eax, eax
.4:
        mov edx, eax
        shl edx, 2
        cmp dword [dword edx+lineslotmark], byte 0
        jge short .5
        mov edx, 0FFFFFFFFh
        jmp short .6
.5:
        mov edx, dword [dword edx+linesortidx-3]
        sar edx, 18h
.6:
        mov byte [eax+ebp], dl
        inc eax
        cmp eax, byte 19h
        jl short SortPlayersByPos.4
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SortNonDefPlayers                               6455F  95 PC, low confidence
; As SortPlayersByPos but every player except position 'D' is ranked (second
; pass of BuildDefaultLines)
;-----------------------------------------------------------------------------
; C: src/engine/lines/SortNonDefPlayers.c
%ifdef CBUILD
%include "c/engine/lines/SortNonDefPlayers.inc"
%else
SortNonDefPlayers:
        push dword 24h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        push eax
        mov edi, edx
        mov ebp, ebx
        xor eax, eax
.1:
        mov ebx, eax
        shl ebx, 2
        mov dword [dword ebx+linesortidx], eax
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        mov esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 2
        mov edx, eax
        shl edx, 2
        add edx, eax
        shl edx, 3
        sub edx, eax
        mov dl, byte [dword edx+esi+hmrosterpos]
        xor dh, dh
        cmp dx, byte 44h
        jne short .2
        mov dword [dword ebx+lineslotmark], 0FFFFFFFFh
        jmp short .3
.2:
        mov edx, eax
        movsx edx, word [byte ebp+edx*2+00h]
        mov dword [dword ebx+lineslotmark], edx
.3:
        inc eax
        cmp eax, byte 19h
        jl short SortNonDefPlayers.1
        push linesortidx
        push lineslotmark
        push byte 19h
        call SortIndices
        add esp, byte 0Ch
        xor eax, eax
.4:
        mov edx, eax
        shl edx, 2
        cmp dword [dword edx+lineslotmark], byte 0
        jge short .5
        mov edx, 0FFFFFFFFh
        jmp short .6
.5:
        mov edx, dword [dword edx+linesortidx-3]
        sar edx, 18h
.6:
        mov byte [edi+eax], dl
        inc eax
        cmp eax, byte 19h
        jl short SortNonDefPlayers.4
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; BuildDefaultLines                               64614  95 PC, low confidence
; Ranks each team's players by position (SortPlayersByPos D/R/L/C,
; SortNonDefPlayers) into defsort_d / offsort_fwd and fills hmlinetab /
; awlinetab and the dressed flags dressflags; called from SetupGame and the
; game load path
;-----------------------------------------------------------------------------
; C: src/engine/lines/BuildDefaultLines.c
%ifdef CBUILD
%include "c/engine/lines/BuildDefaultLines.inc"
%else
BuildDefaultLines:
        push dword 0F4h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 0D8h
        xor esi, esi
        jmp near .13
.1:
        xor edx, edx
        jmp near .6
.2:
        movsx ecx, si
        mov ebp, ecx
        shl ebp, 4
        add ebp, ecx
        shl ebp, 4
        add ebp, ecx
        shl ebp, 2
        movsx edi, dx
        mov eax, edi
        shl eax, 2
        add eax, edi
        shl eax, 3
        sub eax, edi
        add eax, ebp
        mov bl, byte [dword eax+hmroster]
        test bl, bl
        je short .3
        cmp bl, 1
        jne short .4
.3:
        movsx ebx, si
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        add eax, ebx
        add eax, eax
        movsx ebx, dx
        add ebx, ebx
        add eax, ebx
        mov ebx, 0FFFFFFFFh
        mov word [esp+eax], bx
        mov word [byte esp+eax+064h], bx
        jmp near .5
.4:
        mov eax, ecx
        shl eax, 5
        sub eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        mov ebp, hmplattr
        add ebp, eax
        mov ebx, edi
        mov eax, edi
        shl eax, 2
        add eax, edi
        xor ebx, edi
        mov bl, byte [byte ebp+eax*4+01h]
        mov dword [dword esp+0D4h], ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+eax*4+02h]
        mov dword [dword esp+0D0h], ebx
        mov ebx, dword [dword esp+0D4h]
        add ebx, dword [dword esp+0D0h]
        mov dword [dword esp+0D0h], ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+eax*4+04h]
        mov dword [dword esp+0D4h], ebx
        mov ebx, dword [dword esp+0D0h]
        add ebx, dword [dword esp+0D4h]
        mov dword [dword esp+0D4h], ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+eax*4+06h]
        mov dword [dword esp+0D0h], ebx
        mov ebx, dword [dword esp+0D4h]
        add ebx, dword [dword esp+0D0h]
        mov dword [dword esp+0D4h], ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+eax*4+09h]
        mov dword [dword esp+0D0h], ebx
        mov ebx, dword [dword esp+0D4h]
        add ebx, dword [dword esp+0D0h]
        mov dword [dword esp+0D0h], ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+eax*4+0Ah]
        mov dword [dword esp+0D4h], ebx
        mov ebx, dword [dword esp+0D0h]
        add ebx, dword [dword esp+0D4h]
        mov dword [dword esp+0D4h], ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+eax*4+03h]
        mov dword [dword esp+0D0h], ebx
        mov ebx, dword [dword esp+0D4h]
        add ebx, dword [dword esp+0D0h]
        mov dword [dword esp+0D0h], ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+eax*4+0Dh]
        mov dword [dword esp+0D4h], ebx
        mov ebx, dword [dword esp+0D0h]
        add ebx, dword [dword esp+0D4h]
        mov dword [dword esp+0D4h], ebx
        mov ebx, ecx
        shl ebx, 2
        sub ebx, ecx
        shl ebx, 3
        add ecx, ebx
        add ecx, ecx
        lea ebx, [edi+edi]
        add ebx, ecx
        mov ecx, dword [dword esp+0D4h]
        mov word [byte esp+ebx+064h], cx
        xor ecx, ecx
        mov cl, byte [byte ebp+eax*4+01h]
        movzx di, byte [byte ebp+eax*4+02h]
        add ecx, edi
        movzx di, byte [byte ebp+eax*4+04h]
        add ecx, edi
        movzx di, byte [byte ebp+eax*4+06h]
        add ecx, edi
        movzx di, byte [byte ebp+eax*4+09h]
        add ecx, edi
        movzx di, byte [byte ebp+eax*4+0Bh]
        add ecx, edi
        movzx di, byte [byte ebp+eax*4+05h]
        add ecx, edi
        movzx di, byte [byte ebp+eax*4+0Ch]
        add edi, ecx
        xor ecx, ecx
        mov cl, byte [byte ebp+eax*4+03h]
        add ecx, edi
        mov al, byte [byte ebp+eax*4+0Dh]
        xor ah, ah
        add eax, ecx
        mov word [esp+ebx], ax
.5:
        inc edx
.6:
        cmp dx, byte 19h
        jl near BuildDefaultLines.2
        movsx edi, si
        mov ebp, edi
        shl ebp, 2
        sub ebp, edi
        shl ebp, 3
        add ebp, edi
        add ebp, ebp
        lea eax, [byte esp+064h]
        add eax, ebp
        mov dword [dword esp+0CCh], eax
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        add eax, edi
        mov dword [dword esp+0C8h], eax
        mov edx, offsort_d
        add edx, eax
        mov ecx, 44h
        mov ebx, dword [dword esp+0CCh]
        mov eax, edi
        call SortPlayersByPos
        mov edx, offsort_r
        add edx, dword [dword esp+0C8h]
        mov ecx, 52h
        mov ebx, dword [dword esp+0CCh]
        mov eax, edi
        call SortPlayersByPos
        mov edx, offsort_l
        add edx, dword [dword esp+0C8h]
        mov ecx, 4Ch
        mov ebx, dword [dword esp+0CCh]
        mov eax, edi
        call SortPlayersByPos
        mov edx, offsort_c
        add edx, dword [dword esp+0C8h]
        mov ecx, 43h
        mov ebx, dword [dword esp+0CCh]
        mov eax, edi
        call SortPlayersByPos
        mov eax, esp
        add ebp, eax
        mov edx, defsort_d
        add edx, dword [dword esp+0C8h]
        mov ecx, 44h
        mov ebx, ebp
        mov eax, edi
        call SortPlayersByPos
        mov edx, defsort_r
        add edx, dword [dword esp+0C8h]
        mov ecx, 52h
        mov ebx, ebp
        mov eax, edi
        call SortPlayersByPos
        mov edx, defsort_l
        add edx, dword [dword esp+0C8h]
        mov ecx, 4Ch
        mov ebx, ebp
        mov eax, edi
        call SortPlayersByPos
        mov edx, defsort_c
        add edx, dword [dword esp+0C8h]
        mov ecx, 43h
        mov ebx, ebp
        mov eax, edi
        call SortPlayersByPos
        mov edx, offsort_fwd
        add edx, dword [dword esp+0C8h]
        mov ebx, dword [dword esp+0CCh]
        mov eax, edi
        call SortNonDefPlayers
        mov edx, defsort_fwd
        add edx, dword [dword esp+0C8h]
        mov ebx, ebp
        mov eax, edi
        call SortNonDefPlayers
        xor edx, edx
        movsx ecx, si
        jmp short .8
.7:
        mov ebp, ecx
        shl ebp, 4
        add ebp, ecx
        shl ebp, 4
        add ebp, ecx
        shl ebp, 2
        movsx edi, dx
        mov eax, edi
        shl eax, 2
        add eax, edi
        shl eax, 3
        sub eax, edi
        movzx ebp, byte [dword eax+ebp+hmroster]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add eax, ecx
        add edi, eax
        mov al, byte [dword ebp+dressbystatus]
        mov byte [dword edi+dressflags], al
        inc edx
.8:
        cmp dx, byte 19h
        jl short BuildDefaultLines.7
        test si, si
        je short .9
        mov ebx, awlinetab
        jmp short .10
.9:
        mov ebx, hmlinetab
.10:
        xor edx, edx
        jmp short .12
.11:
        movsx ecx, si
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add ecx, eax
        movsx eax, byte [ebx]
        inc ebx
        mov byte [dword ecx+eax+dressflags], 0
        inc edx
.12:
        cmp dx, byte 12h
        jl short BuildDefaultLines.11
        inc esi
.13:
        cmp si, byte 2
        jl near BuildDefaultLines.1
        add esp, 0D8h
lines_popx:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CanFillLineSlot                                 64A0B  95 PC, low confidence
; (team, slot, roster idx): 0 when the player's status (dressbystatus of
; hmroster) is 0, or 2 without a dressed flag 2, or he already holds 2 of the
; same-position slots (slot mod 3) in hmlinetab / awlinetab; else checks the
; position byte (hmrosterpos) against the slot
;-----------------------------------------------------------------------------
CanFillLineSlot:
        push dword 24h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, eax
        mov ecx, edx
        mov edi, ebx
        test ax, ax
        je short .1
        mov ebp, awlinetab
        jmp short .2
.1:
        mov ebp, hmlinetab
.2:
        movsx eax, si
        mov dword [byte esp+04h], eax
        mov ebx, eax
        shl ebx, 4
        add ebx, eax
        shl ebx, 4
        add ebx, eax
        shl ebx, 2
        movsx eax, di
        mov dword [byte esp+08h], eax
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov al, byte [dword ebx+eax+hmroster]
        and eax, 0FFh
        movsx bx, byte [dword eax+dressbystatus]
        test bx, bx
        jne short .4
.3:
        xor edx, edx
        jmp near .34
.4:
        cmp bx, byte 2
        jne short .5
        mov edx, dword [byte esp+04h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, dword [byte esp+08h]
        cmp byte [dword eax+dressflags], 2
        jne short CanFillLineSlot.3
.5:
        movsx edx, si
        mov ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 2
        movsx edx, di
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        xor edx, edx
        mov dl, byte [dword ebx+eax+hmrosterpos]
        cmp cx, byte 0Ch
        jge near .11
        xor esi, esi
        xor ebx, ebx
        jmp short .9
.6:
        movsx edx, bx
        mov dword [byte esp+0Ch], 3
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+0Ch]
        mov dword [esp], edx
        movsx edx, cx
        mov dword [byte esp+0Ch], 3
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+0Ch]
        cmp edx, dword [esp]
        jne short .7
        cmp bx, cx
        jge short .8
.7:
        movsx edx, bx
        movsx dx, byte [edx+ebp]
        cmp dx, di
        jne short .8
        inc esi
.8:
        inc ebx
.9:
        cmp bx, byte 0Ch
        jl short CanFillLineSlot.6
        cmp si, byte 2
        jl short .10
        cmp word [dressedfwds], byte 6
        jg near CanFillLineSlot.3
.10:
        movsx edx, cx
        mov ebx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        mov edx, eax
        mov esi, eax
        add esi, byte 2
        jmp near .27
.11:
        cmp cx, byte 12h
        jge near .17
        cmp word [dresseddefs], byte 3
        jl short .16
        xor esi, esi
        mov ebx, 0Ch
        jmp short .15
.12:
        movsx edx, bx
        mov dword [byte esp+0Ch], 2
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+0Ch]
        mov dword [esp], edx
        movsx edx, cx
        mov dword [byte esp+0Ch], 2
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte esp+0Ch]
        cmp edx, dword [esp]
        jne short .13
        cmp bx, cx
        jge short .14
.13:
        movsx edx, bx
        movsx dx, byte [edx+ebp]
        cmp dx, di
        jne short .14
        inc esi
.14:
        inc ebx
.15:
        cmp bx, byte 12h
        jl short CanFillLineSlot.12
        cmp si, byte 2
        jge near CanFillLineSlot.3
.16:
        mov edx, ecx
        and dl, 0FEh
        mov esi, edx
        inc esi
        jmp near .27
.17:
        cmp cx, byte 1Ch
        jge short .23
        cmp dx, byte 44h
        jne short .18
        cmp word [dresseddefs], byte 4
        jl short .19
.18:
        cmp dx, byte 44h
        je short .22
        cmp word [dressedfwds], byte 6
        jge short .22
.19:
        cmp cx, byte 17h
        jge short .20
        mov edx, 12h
        jmp short .21
.20:
        mov edx, 17h
.21:
        mov esi, edx
        add esi, byte 4
        jmp short .27
.22:
        mov edx, 12h
        mov esi, 1Bh
        jmp short .27
.23:
        cmp dx, byte 44h
        jne short .26
        cmp word [dresseddefs], byte 4
        jge short .26
        cmp cx, byte 20h
        jge short .24
        mov edx, 1Ch
        jmp short .25
.24:
        mov edx, 20h
.25:
        mov esi, edx
        add esi, byte 3
        jmp short .27
.26:
        mov edx, 1Ch
        mov esi, 23h
.27:
        mov ebx, edx
        jmp short .33
.28:
        cmp bx, cx
        je short .32
        cmp cx, byte 1Ch
        jl short .29
        movsx edx, cx
        movsx eax, bx
        add edx, byte 4
        jmp short .30
.29:
        cmp cx, byte 12h
        jl short .31
        movsx edx, cx
        movsx eax, bx
        add edx, byte 5
.30:
        cmp eax, edx
        je short .32
.31:
        movsx edx, bx
        movsx dx, byte [edx+ebp]
        cmp dx, di
        jne short .32
        xor edx, edi
        jmp short .34
.32:
        inc ebx
.33:
        cmp bx, si
        jle short CanFillLineSlot.28
        mov edx, 1
.34:
        mov eax, edx
lines_addesp10_x:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; FillDressedSlots                                64CA8  95 PC, low confidence
; Walks the dressed-flag list dressflags of a team and places each dressed
; player (flag 2 first) in a line slot with CanFillLineSlot
;-----------------------------------------------------------------------------
FillDressedSlots:
        push dword 24h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebp, eax
        mov word [esp], dx
        mov word [byte esp+08h], bx
        xor edx, edx
        mov word [byte esp+0Ch], dx
        jmp near .11
.1:
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add eax, ecx
        mov edi, dword [byte esp+02h]
        sar edi, 10h
        lea esi, [eax+edi]
        cmp byte [dword esi+dressflags], 0
        je near .10
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        mov ebx, edi
        mov eax, ecx
        call CanFillLineSlot
        test ax, ax
        je near .10
        cmp byte [dword esi+dressflags], 2
        jne near .9
        cmp word [dressedskaters], byte 12h
        jge near .10
        mov edx, ecx
        shl edx, 4
        add edx, ecx
        shl edx, 4
        add edx, ecx
        shl edx, 2
        mov eax, edi
        shl eax, 2
        add eax, edi
        shl eax, 3
        sub eax, edi
        cmp byte [dword edx+eax+hmrosterpos], 44h
        je short .2
        cmp word [dressedfwds], byte 0Ch
        jge near .10
.2:
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov ecx, edx
        shl ecx, 4
        add ecx, edx
        shl ecx, 4
        add ecx, edx
        shl ecx, 2
        mov edx, dword [byte esp+02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov byte [dword ecx+eax+hmroster], 3
        cmp word [esp], byte 0
        je short .3
        mov esi, awlinetab
        jmp short .4
.3:
        mov esi, hmlinetab
.4:
        mov ecx, 28h
        mov edi, dword [byte esp+04h]
        jmp short .7
.5:
        movsx eax, cx
        add eax, esi
        movsx dx, byte [eax]
        cmp dx, di
        jne short .6
        mov byte [eax], 64h
.6:
        inc ecx
.7:
        cmp cx, byte 30h
        jl short FillDressedSlots.5
        mov esi, dword [byte esp-02h]
        sar esi, 10h
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 3
        add eax, esi
        mov ecx, dword [byte esp+02h]
        sar ecx, 10h
        mov byte [dword ecx+eax+dressflags], 1
        mov edx, esi
        shl esi, 4
        add esi, edx
        shl esi, 4
        add esi, edx
        shl esi, 2
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 3
        sub eax, ecx
        inc word [dressedskaters]
        cmp byte [dword esi+eax+hmrosterpos], 44h
        jne short .8
        inc word [dresseddefs]
        jmp short .9
.8:
        inc word [dressedfwds]
.9:
        mov eax, dword [byte esp+04h]
        jmp near lines_addesp10_x
.10:
        inc word [byte esp+0Ch]
.11:
        cmp word [byte esp+0Ch], byte 19h
        jge short .12
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        movsx ax, byte [eax+ebp]
        mov word [byte esp+04h], ax
        test ax, ax
        jge near FillDressedSlots.1
.12:
        mov eax, 0FFFFFFFFh
        jmp near lines_addesp10_x
;-----------------------------------------------------------------------------
; PickForLineSlot                                 64E60  95 PC, low confidence
; (team, slot): walks the position preference list lineslotgroups from
; lineslotgroupstart[slot] and returns the first ranked player that
; CanFillLineSlot accepts
;-----------------------------------------------------------------------------
PickForLineSlot:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        push eax
        mov esi, edx
        test ax, ax
        je short .1
        mov ebp, awlinetab
        jmp short .2
.1:
        mov ebp, hmlinetab
.2:
        movsx eax, si
        movsx ax, byte [dword eax+lineslotgroupstart]
        mov dword [byte esp+04h], eax
        mov ecx, eax
.3:
        movsx eax, cx
        movsx ax, byte [dword eax+lineslotgroups]
        inc ecx
        cmp ax, si
        jne short PickForLineSlot.3
.4:
        movsx eax, cx
        cmp byte [dword eax+lineslotgroups], 0
        jl short .7
        mov eax, dword [dword eax+lineslotgroups-3]
        sar eax, 18h
        movsx di, byte [eax+ebp]
        movsx ebx, byte [eax+ebp]
        movsx edx, si
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        call CanFillLineSlot
        test ax, ax
        je short .6
.5:
        mov esi, edi
        jmp near .48
.6:
        inc ecx
        jmp short PickForLineSlot.4
.7:
        movsx ebx, si
        movsx edx, byte [ebx+ebp]
        mov edi, edx
        shl edi, 2
        add edi, edx
        shl edi, 3
        sub edi, edx
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        mov al, byte [dword edi+eax*4+hmrosterpos]
        xor ah, ah
        mov dword [byte esp+08h], eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        mov ecx, dword [byte esp+08h]
        cmp cx, byte 44h
        jne short .12
        mov ecx, edx
        cmp si, byte 1Ch
        jge short .8
        cmp si, byte 12h
        jl short .8
        add eax, offsort_d
        jmp short .9
.8:
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, defsort_d
.9:
        mov edx, ecx
.10:
        call FillDressedSlots
        test ax, ax
        jl near .31
.11:
        mov esi, eax
        jmp near .48
.12:
        cmp cx, byte 43h
        jne near .18
        cmp si, byte 1Ch
        jge short .13
        add eax, offsort_c
        jmp short .14
.13:
        add eax, defsort_c
.14:
        call FillDressedSlots
        test ax, ax
        jge short PickForLineSlot.11
        movsx ecx, si
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        cmp si, byte 1Ch
        jge short .15
        add eax, offsort_l
        jmp short .16
.15:
        add eax, defsort_l
.16:
        mov ebx, ecx
        call FillDressedSlots
        test ax, ax
        jge short PickForLineSlot.11
        movsx ebx, si
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add eax, ecx
        cmp si, byte 1Ch
        jge short .17
        add eax, offsort_r
        jmp near PickForLineSlot.9
.17:
        add eax, defsort_r
        jmp near PickForLineSlot.9
.18:
        cmp cx, byte 52h
        jne near .25
        cmp si, byte 1Ch
        jge short .19
        add eax, offsort_r
        jmp short .20
.19:
        add eax, defsort_r
.20:
        call FillDressedSlots
        test ax, ax
        jge near PickForLineSlot.11
        movsx ecx, si
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        cmp si, byte 1Ch
        jge short .21
        add eax, offsort_l
        jmp short .22
.21:
        add eax, defsort_l
.22:
        mov ebx, ecx
        call FillDressedSlots
        test ax, ax
        jge near PickForLineSlot.11
        movsx ecx, si
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        cmp si, byte 1Ch
        jge short .23
        add eax, offsort_c
        jmp short .24
.23:
        add eax, defsort_c
.24:
        mov ebx, ecx
        jmp near PickForLineSlot.10
.25:
        cmp cx, byte 4Ch
        jne near .31
        cmp si, byte 1Ch
        jge short .26
        add eax, offsort_l
        jmp short .27
.26:
        add eax, defsort_l
.27:
        call FillDressedSlots
        test ax, ax
        jge near PickForLineSlot.11
        movsx ebx, si
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add eax, ecx
        cmp si, byte 1Ch
        jge short .28
        add eax, offsort_r
        jmp short .29
.28:
        add eax, defsort_r
.29:
        mov edx, ecx
        call FillDressedSlots
        test ax, ax
        jge near PickForLineSlot.11
        movsx ebx, si
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add eax, ecx
        cmp si, byte 1Ch
        jge short .30
        add eax, offsort_c
        jmp near PickForLineSlot.9
.30:
        add eax, defsort_c
        jmp near PickForLineSlot.9
.31:
        mov ecx, dword [byte esp+04h]
.32:
        movsx eax, cx
        movsx dx, byte [dword eax+lineslotgroups]
        cmp dx, si
        je short .33
        mov eax, dword [dword eax+lineslotgroups-3]
        sar eax, 18h
        movsx di, byte [eax+ebp]
        movsx ebx, byte [eax+ebp]
        movsx edx, si
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        call CanFillLineSlot
        test ax, ax
        jne near PickForLineSlot.5
        inc ecx
        jmp short PickForLineSlot.32
.33:
        cmp word [byte esp+08h], byte 44h
        jne short .35
        cmp si, byte 12h
        jl short .34
        cmp si, byte 1Ch
        jge short .34
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, offsort_d
        jmp short .37
.34:
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, defsort_d
        jmp short .37
.35:
        cmp si, byte 1Ch
        jge short .36
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, offsort_fwd
        jmp short .37
.36:
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, defsort_fwd
.37:
        mov ebp, eax
        xor ecx, ecx
        jmp short .39
.38:
        movsx eax, cx
        movsx di, byte [eax+ebp]
        test di, di
        jl short .40
        movsx ebx, di
        movsx edx, si
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        call CanFillLineSlot
        test ax, ax
        jne near PickForLineSlot.5
        inc ecx
.39:
        cmp cx, byte 19h
        jl short PickForLineSlot.38
.40:
        cmp word [byte esp+08h], byte 44h
        jne short .42
        cmp si, byte 12h
        jl short .41
        cmp si, byte 1Ch
        jge short .41
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, offsort_fwd
        jmp short .44
.41:
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, defsort_fwd
        jmp short .44
.42:
        cmp si, byte 1Ch
        jge short .43
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, offsort_d
        jmp short .44
.43:
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, defsort_d
.44:
        mov ebp, eax
        xor ecx, ecx
        jmp short .46
.45:
        movsx eax, cx
        movsx di, byte [eax+ebp]
        test di, di
        jl short .47
        movsx ebx, di
        movsx edx, si
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        call CanFillLineSlot
        test ax, ax
        jne near PickForLineSlot.5
        inc ecx
.46:
        cmp cx, byte 19h
        jl short PickForLineSlot.45
.47:
        xor esi, esi
.48:
        mov eax, esi
        add esp, byte 0Ch
lines_popx2:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; PickGoalie                                      652D6  95 PC, low confidence
; (team, slot, force): for slot 24h copies the backup (+25h) to the starter;
; then the first roster player other than +24h/+25h with status 1 becomes
; +25h (status 2 is promoted to 3 when forced and cleared from slots
; 28h..2Fh)
;-----------------------------------------------------------------------------
; C: src/engine/lines/PickGoalie.c
%ifdef CBUILD
%include "c/engine/lines/PickGoalie.inc"
%else
PickGoalie:
        push dword 14h
        call __CHK
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        mov dword [esp], ebx
        test ax, ax
        je short .1
        mov eax, awlinetab
        jmp short .2
.1:
        mov eax, hmlinetab
.2:
        mov ebx, eax
        cmp dx, byte 24h
        jne short .3
        mov dl, byte [byte eax+025h]
        mov byte [byte eax+024h], dl
.3:
        mov edx, 19h
        jmp near .11
.4:
        movsx ax, byte [byte ebx+024h]
        cmp dx, ax
        je near .10
        movsx ax, byte [byte ebx+025h]
        cmp dx, ax
        je near .10
        movsx ecx, di
        mov esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 2
        movsx ecx, dx
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 3
        sub eax, ecx
        add eax, esi
        movzx si, byte [dword eax+hmroster]
        xor ecx, ecx
        mov cl, byte [dword eax+hmroster]
        cmp byte [dword ecx+dressbystatus], 1
        jne short .6
.5:
        mov byte [byte ebx+025h], dl
        jmp short .x
.6:
        cmp si, byte 2
        jne short .10
        cmp word [esp], byte 0
        je short .10
        mov byte [dword eax+hmroster], 3
        mov ecx, 28h
        jmp short .9
.7:
        movsx eax, cx
        add eax, ebx
        movsx si, byte [eax]
        cmp si, dx
        jne short .8
        mov byte [eax], 64h
.8:
        inc ecx
.9:
        cmp cx, byte 30h
        jl short PickGoalie.7
        jmp short PickGoalie.5
.10:
        inc edx
.11:
        cmp dx, byte 1Ch
        jl near PickGoalie.4
        mov al, byte [byte ebx+024h]
        mov byte [byte ebx+025h], al
.x:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PickExtraSkater                                 653BE  95 PC, low confidence
; (team, slot): for slot 26h keeps +27h when available, else takes the first
; available ranked player from offsort_fwd into +26h
;-----------------------------------------------------------------------------
; C: src/engine/lines/PickForLineSlot.c (PickExtraSkater)
%ifdef CBUILD
%include "c/engine/lines/PickForLineSlot.PickExtraSkater.inc"
%else
PickExtraSkater:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov edi, eax
        mov ebx, edx
        test ax, ax
        je short .1
        mov edx, awlinetab
        jmp short .2
.1:
        mov edx, hmlinetab
.2:
        mov esi, edx
        movsx eax, di
        mov ecx, eax
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add eax, ecx
        mov ebp, offsort_fwd
        add ebp, eax
        cmp bx, byte 26h
        jne near .7
        movsx bx, byte [byte edx+027h]
        mov eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 2
        mov dword [esp], eax
        mov eax, dword [byte edx+024h]
        sar eax, 18h
        mov dword [byte esp+04h], eax
        shl eax, 2
        mov ecx, dword [byte esp+04h]
        add eax, ecx
        shl eax, 3
        sub eax, ecx
        add eax, dword [esp]
        mov al, byte [dword eax+hmroster]
        and eax, 0FFh
        cmp byte [dword eax+dressbystatus], 1
        jne short .3
        mov byte [byte edx+026h], bl
        jmp short .7
.3:
        xor edx, edx
        jmp short .6
.4:
        movsx eax, dx
        movsx bx, byte [eax+ebp]
        test bx, bx
        jl short .7
        movsx ecx, di
        mov eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 2
        mov dword [byte esp+04h], eax
        movsx ecx, bx
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 3
        sub eax, ecx
        add eax, dword [byte esp+04h]
        mov al, byte [dword eax+hmroster]
        and eax, 0FFh
        cmp byte [dword eax+dressbystatus], 1
        jne short .5
        mov byte [byte esi+026h], bl
        jmp short .7
.5:
        inc edx
.6:
        cmp dx, byte 19h
        jl short PickExtraSkater.4
.7:
        movsx edx, di
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        mov ebp, offsort_fwd
        add ebp, eax
        xor edx, edx
        jmp short .10
.8:
        movsx eax, dx
        movsx bx, byte [eax+ebp]
        test bx, bx
        jl short .11
        movsx ecx, di
        mov eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 2
        mov dword [byte esp+04h], eax
        movsx ecx, bx
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 3
        sub eax, ecx
        add eax, dword [byte esp+04h]
        mov al, byte [dword eax+hmroster]
        and eax, 0FFh
        cmp byte [dword eax+dressbystatus], 1
        jne short .9
        movsx ax, byte [byte esi+026h]
        cmp bx, ax
        je short .9
        mov byte [byte esi+027h], bl
        jmp short .11
.9:
        inc edx
.10:
        cmp dx, byte 19h
        jl short PickExtraSkater.8
.11:
        add esp, byte 8
        jmp near lines_popx2
%endif ; C
;-----------------------------------------------------------------------------
; RefillLineSlots                                 6552E  95 PC, low confidence
; (team, first slot, i, count, step): clears the dressed flag of the slot's
; current player, then fills count slots (step apart) with PickForLineSlot
; and clears their flags below slot 12h; ret 4
;-----------------------------------------------------------------------------
; C: src/engine/lines/RefillLineSlots.c
%ifdef CBUILD
%include "c/engine/lines/RefillLineSlots.inc"
%else
RefillLineSlots:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        push eax
        mov esi, edx
        mov edi, ebx
        mov dword [byte esp+04h], ecx
        test ax, ax
        je short .1
        mov eax, awlinetab
        jmp short .2
.1:
        mov eax, hmlinetab
.2:
        mov ebp, eax
        movsx ebx, si
        movsx ecx, byte [ebx+eax]
        mov ebx, dword [byte esp-02h]
        sar ebx, 10h
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        add eax, ebx
        xor dl, dl
        mov byte [dword ecx+eax+dressflags], dl
.3:
        cmp di, word [byte esp+04h]
        jge short .x
        movsx ecx, si
        mov ebx, dword [byte esp-02h]
        sar ebx, 10h
        mov edx, ecx
        mov eax, ebx
        call PickForLineSlot
        mov edx, eax
        lea eax, [ecx+ebp]
        mov byte [eax], dl
        cmp si, byte 12h
        jge short .4
        movsx ecx, dl
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        add eax, ebx
        xor dh, dh
        mov byte [dword ecx+eax+dressflags], dh
.4:
        inc edi
        add esi, dword [byte esp+018h]
        jmp short RefillLineSlots.3
.x:
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; RemoveFromLines                                 655CC  95 PC, low confidence
; Team eax, roster player edx (pnum): takes the player out of the team's line
; table (hmlinetab home / awlinetab away) and refills the slot from the
; dressed lists; called when a player is injured or ejected (player logic
; 4AD5E, physics 56012)
;-----------------------------------------------------------------------------
RemoveFromLines:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 8
        push eax
        push edx
        test ax, ax
        je short .1
        mov esi, awlinetab
        jmp short .2
.1:
        mov esi, hmlinetab
.2:
        mov edx, dword [byte esp+02h]
        sar edx, 10h
        mov ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 2
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        add eax, ebx
        mov dl, byte [dword eax+hmrosterpos]
        cmp dl, 44h
        jne near .6
        xor edi, edi
        mov word [dresseddefs], di
        mov word [byte esp+0Ch], di
        jmp short .5
.3:
        mov ebx, dword [byte esp+02h]
        sar ebx, 10h
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        add eax, ebx
        mov edx, dword [byte esp+0Ah]
        sar edx, 10h
        movsx ax, byte [dword edx+eax+defsort_d]
        test ax, ax
        jl near .10
        mov edx, ebx
        shl edx, 4
        add edx, ebx
        shl edx, 4
        add ebx, edx
        shl ebx, 2
        movsx edx, ax
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov al, byte [dword ebx+eax+hmroster]
        and eax, 0FFh
        cmp byte [dword eax+dressbystatus], 1
        jne short .4
        inc word [dresseddefs]
.4:
        inc word [byte esp+0Ch]
.5:
        cmp word [byte esp+0Ch], byte 19h
        jl short RemoveFromLines.3
        jmp near .10
.6:
        cmp dl, 47h
        je near .10
        xor ebx, ebx
        mov word [dressedfwds], bx
        mov word [byte esp+0Ch], bx
        jmp short .9
.7:
        mov ebx, dword [byte esp+02h]
        sar ebx, 10h
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        lea edx, [ebx+eax]
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        movsx ax, byte [dword edx+eax+offsort_fwd]
        test ax, ax
        jl short .10
        mov edx, ebx
        shl edx, 4
        add edx, ebx
        shl edx, 4
        add ebx, edx
        shl ebx, 2
        movsx edx, ax
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov al, byte [dword ebx+eax+hmroster]
        and eax, 0FFh
        cmp byte [dword eax+dressbystatus], 1
        jne short .8
        inc word [dressedfwds]
.8:
        inc word [byte esp+0Ch]
.9:
        cmp word [byte esp+0Ch], byte 19h
        jl short RemoveFromLines.7
.10:
        xor edi, edi
        mov word [byte esp+0Ch], di
        jmp short .15
.11:
        xor edx, edx
        mov dword [byte esp+08h], edx
        jmp short .14
.12:
        movsx ax, byte [esi]
        inc esi
        cmp ax, word [esp]
        jne short .13
        push byte 3
        mov ebx, dword [byte esp+0Eh]
        sar ebx, 10h
        movsx edx, di
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        mov ecx, 4
        call RefillLineSlots
.13:
        inc edi
        inc dword [byte esp+08h]
.14:
        cmp word [byte esp+08h], byte 3
        jl short RemoveFromLines.12
        inc word [byte esp+0Ch]
.15:
        cmp word [byte esp+0Ch], byte 4
        jl short RemoveFromLines.11
        xor eax, eax
        mov word [byte esp+0Ch], ax
        jmp short .20
.16:
        xor edx, edx
        mov dword [byte esp+08h], edx
        jmp short .19
.17:
        movsx ax, byte [esi]
        inc esi
        cmp ax, word [esp]
        jne short .18
        push byte 2
        mov ebx, dword [byte esp+0Eh]
        sar ebx, 10h
        movsx edx, di
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        mov ecx, 3
        call RefillLineSlots
.18:
        inc edi
        inc dword [byte esp+08h]
.19:
        cmp word [byte esp+08h], byte 2
        jl short RemoveFromLines.17
        inc word [byte esp+0Ch]
.20:
        cmp word [byte esp+0Ch], byte 3
        jl short RemoveFromLines.16
        xor eax, eax
        mov word [byte esp+0Ch], ax
        jmp short .25
.21:
        xor edx, edx
        mov dword [byte esp+08h], edx
        jmp short .24
.22:
        movsx ax, byte [esi]
        inc esi
        cmp ax, word [esp]
        jne short .23
        push byte 5
        mov ebx, dword [byte esp+0Eh]
        sar ebx, 10h
        movsx edx, di
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        mov ecx, 2
        call RefillLineSlots
.23:
        inc edi
        inc dword [byte esp+08h]
.24:
        cmp word [byte esp+08h], byte 5
        jl short RemoveFromLines.22
        inc word [byte esp+0Ch]
.25:
        cmp word [byte esp+0Ch], byte 2
        jl short RemoveFromLines.21
        xor eax, eax
        mov word [byte esp+0Ch], ax
        jmp short .30
.26:
        xor edx, edx
        mov dword [byte esp+08h], edx
        jmp short .29
.27:
        movsx ax, byte [esi]
        inc esi
        cmp ax, word [esp]
        jne short .28
        push byte 4
        mov ebx, dword [byte esp+0Eh]
        sar ebx, 10h
        movsx edx, di
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        mov ecx, 2
        call RefillLineSlots
.28:
        inc edi
        inc dword [byte esp+08h]
.29:
        cmp word [byte esp+08h], byte 4
        jl short RemoveFromLines.27
        inc word [byte esp+0Ch]
.30:
        cmp word [byte esp+0Ch], byte 2
        jl short RemoveFromLines.26
        xor eax, eax
        mov word [byte esp+0Ch], ax
        jmp short .33
.31:
        movsx ax, byte [esi]
        inc esi
        cmp ax, word [esp]
        jne short .32
        movsx edx, di
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        xor ebx, ebx
        call PickGoalie
.32:
        inc edi
        inc word [byte esp+0Ch]
.33:
        cmp word [byte esp+0Ch], byte 2
        jl short RemoveFromLines.31
        xor ecx, ecx
        mov word [byte esp+0Ch], cx
        jmp short .36
.34:
        movsx ax, byte [esi]
        inc esi
        cmp ax, word [esp]
        jne short .35
        movsx edx, di
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call PickExtraSkater
.35:
        inc edi
        inc word [byte esp+0Ch]
.36:
        cmp word [byte esp+0Ch], byte 2
        jl short RemoveFromLines.34
        add esp, byte 10h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SetupTeamLines                                  658F3  95 PC, low confidence
; Team eax: counts the available players (dressbystatus by roster status) of
; the two dressed lists (defsort_d / offsort_fwd) into dresseddefs /
; dressedfwds, then fills the line table (hmlinetab / awlinetab); called for
; both teams at game start / load after BuildDefaultLines
;-----------------------------------------------------------------------------
; C: src/engine/lines/BuildDefaultLines.c (SetupTeamLines)
%ifdef CBUILD
%include "c/engine/lines/BuildDefaultLines.SetupTeamLines.inc"
%else
SetupTeamLines:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        test ax, ax
        je short .1
        mov ebp, awlinetab
        jmp short .2
.1:
        mov ebp, hmlinetab
.2:
        xor edx, edx
        mov word [dresseddefs], dx
        xor ecx, ecx
        jmp short .5
.3:
        movsx edi, si
        mov edx, edi
        shl edx, 2
        sub edx, edi
        shl edx, 3
        add edx, edi
        movsx eax, cx
        movsx dx, byte [dword edx+eax+defsort_d]
        test dx, dx
        jl short .6
        mov ebx, edi
        shl edi, 4
        add edi, ebx
        shl edi, 4
        add edi, ebx
        shl edi, 2
        movsx ebx, dx
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        mov al, byte [dword edi+eax+hmroster]
        and eax, 0FFh
        cmp byte [dword eax+dressbystatus], 1
        jne short .4
        inc word [dresseddefs]
.4:
        inc ecx
.5:
        cmp cx, byte 19h
        jl short SetupTeamLines.3
.6:
        xor ecx, ecx
        mov word [dressedfwds], cx
        jmp short .9
.7:
        movsx edi, si
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        add eax, edi
        movsx edx, cx
        movsx dx, byte [dword edx+eax+offsort_fwd]
        test dx, dx
        jl short .10
        mov ebx, edi
        shl edi, 4
        add edi, ebx
        shl edi, 4
        add edi, ebx
        shl edi, 2
        movsx ebx, dx
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        mov al, byte [dword edi+eax+hmroster]
        and eax, 0FFh
        cmp byte [dword eax+dressbystatus], 1
        jne short .8
        inc word [dressedfwds]
.8:
        inc ecx
.9:
        cmp cx, byte 19h
        jl short SetupTeamLines.7
.10:
        mov ax, word [dressedfwds]
        mov dx, word [dresseddefs]
        add eax, edx
        mov word [dressedskaters], ax
        xor ecx, ecx
        jmp short .12
.11:
        movsx eax, cx
        xor edx, edx
        mov dword [nosplit eax*4+lineslotmark], edx
        inc ecx
.12:
        cmp cx, byte 19h
        jl short SetupTeamLines.11
        xor ecx, ecx
        mov edi, 1
        jmp short .14
.13:
        movsx eax, cx
        movsx eax, byte [eax+ebp]
        mov dword [nosplit eax*4+lineslotmark], edi
        inc ecx
.14:
        cmp cx, byte 24h
        jl short SetupTeamLines.13
        mov eax, dword [byte ebp+024h]
        sar eax, 18h
        mov ebx, 1
        mov dword [nosplit eax*4+lineslotmark], ebx
        mov eax, dword [byte ebp+023h]
        sar eax, 18h
        mov dword [nosplit eax*4+lineslotmark], ebx
        xor ecx, ecx
        jmp short .18
.15:
        movsx ebx, si
        mov edi, ebx
        shl edi, 4
        add edi, ebx
        shl edi, 4
        add edi, ebx
        shl edi, 2
        movsx edx, cx
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov al, byte [dword edi+eax+hmroster]
        xor ah, ah
        cmp dword [nosplit edx*4+lineslotmark], byte 0
        je short .17
        test ax, ax
        je short .16
        cmp ax, 1
        jne short .17
.16:
        movsx edx, cx
        movsx eax, si
        call RemoveFromLines
.17:
        inc ecx
.18:
        cmp cx, byte 19h
        jl short SetupTeamLines.15
        mov ecx, 24h
        jmp short .22
.19:
        movsx eax, cx
        movsx ebx, byte [eax+ebp]
        mov edx, ebx
        shl edx, 2
        add edx, ebx
        shl edx, 3
        sub edx, ebx
        movsx ebx, si
        mov eax, ebx
        shl eax, 4
        add eax, ebx
        shl eax, 4
        add eax, ebx
        mov al, byte [dword edx+eax*4+hmroster]
        xor ah, ah
        test ax, ax
        je short .20
        cmp ax, 1
        jne short .21
.20:
        movsx edx, cx
        movsx eax, si
        mov ebx, 1
        call PickGoalie
.21:
        inc ecx
.22:
        cmp cx, byte 25h
        jl short SetupTeamLines.19
        xor ecx, ecx
        jmp short .24
.23:
        movsx ebx, si
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        add eax, ebx
        movsx edx, cx
        cmp byte [dword edx+eax+dressflags], 1
        sete dl
        movsx ebx, si
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        add ebx, eax
        movsx eax, cx
        mov byte [dword ebx+eax+dressflags], dl
        inc ecx
.24:
        cmp cx, byte 19h
        jl short SetupTeamLines.23
        jmp near lines_popx
%endif ; C
;-----------------------------------------------------------------------------
; NormalizeDressFlags                          65B48  95 PC, medium confidence
; For the 19h entries of both dressed-flag lists dressflags / dressflags_aw:
; flag = (flag == 1)
;-----------------------------------------------------------------------------
; C: src/engine/lines/NormalizeDressFlags.c
%ifdef CBUILD
%include "c/engine/lines/NormalizeDressFlags.inc"
%else
NormalizeDressFlags:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        xor eax, eax
.1:
        mov dh, byte [dword eax+dressflags]
        cmp dh, 1
        sete dl
        mov byte [dword eax+dressflags], dl
        mov bl, byte [dword eax+dressflags_aw]
        cmp bl, 1
        sete dl
        mov byte [dword eax+dressflags_aw], dl
        inc eax
        cmp eax, byte 19h
        jl short NormalizeDressFlags.1
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CanRemovePlayer                              65B83  95 PC, medium confidence
; Rejects the auto proposal setInjuryType (that is 55E72). Player eax (team
; by pflags bit 6, roster pnum +47h): counts roster players with status 3 or
; 4 in the team's dressed list (defsort_d, 19h per team) and returns count >
; 2 when he is in it, else the count in the second list (offsort_fwd) > 4;
; injury / penalty code calls it before taking a player out (with PBnum < 8)
;-----------------------------------------------------------------------------
; C: src/engine/lines/BuildDefaultLines.c (CanRemovePlayer)
%ifdef CBUILD
%include "c/engine/lines/BuildDefaultLines.CanRemovePlayer.inc"
%else
CanRemovePlayer:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov ebp, eax
        xor edx, edx
        mov dword [byte esp+04h], edx
        test byte [byte eax+044h], 40h
        setne al
        xor ah, ah
        mov edi, eax
        xor ecx, ecx
        jmp near .5
.1:
        movsx esi, di
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 3
        add esi, eax
        movsx eax, dx
        movsx bx, byte [dword esi+eax+defsort_d]
        test bx, bx
        jl short .6
        movsx ax, byte [byte ebp+047h]
        cmp bx, ax
        jne short .2
        mov dword [byte esp+04h], 1
.2:
        movsx esi, di
        mov eax, esi
        shl eax, 4
        add eax, esi
        shl eax, 4
        add eax, esi
        shl eax, 2
        mov dword [esp], eax
        movsx esi, bx
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 3
        sub eax, esi
        add eax, dword [esp]
        mov al, byte [dword eax+hmroster]
        xor ah, ah
        cmp ax, 4
        je short .3
        cmp ax, 3
        jne short .4
.3:
        inc ecx
.4:
        inc edx
.5:
        cmp dx, byte 19h
        jl short CanRemovePlayer.1
.6:
        cmp word [byte esp+04h], byte 0
        je short .7
        cmp cx, byte 2
        jmp short .13
.7:
        xor ecx, ecx
        xor edx, edx
        jmp short .11
.8:
        movsx ebp, di
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 3
        add eax, ebp
        movsx esi, dx
        movsx bx, byte [dword esi+eax+offsort_fwd]
        test bx, bx
        jl short .12
        mov esi, ebp
        shl ebp, 4
        add ebp, esi
        shl ebp, 4
        add ebp, esi
        shl ebp, 2
        movsx esi, bx
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 3
        sub eax, esi
        mov al, byte [dword eax+ebp+hmroster]
        xor ah, ah
        cmp ax, 4
        je short .9
        cmp ax, 3
        jne short .10
.9:
        inc ecx
.10:
        inc edx
.11:
        cmp dx, byte 19h
        jl short CanRemovePlayer.8
.12:
        cmp cx, byte 4
.13:
        setg al
        and eax, 0FFh
        add esp, byte 8
        jmp near lines_popx
%endif ; C
