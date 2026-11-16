; Drawing over the rink. The window onto the ice, the text overlays, the referee's call and goalie
; banners, and the team palettes.
bits 32
%include "hockey.inc"
section s_65CA8 progbits alloc exec nowrite align=1
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
global DitherRect, checkwindow, checkwindow_popebp, checkwindow_popx, LoadTeamPPV, DrawTextOverlay, CloseTextOverlay, UpdateTextOverlay
global DrawCallBanner, ShowGoalieBanner, SetTeamGoalie, LoadTeamPalette
;-----------------------------------------------------------------------------
; DitherRect                                      65CA8  95 PC, low confidence
; (x, y, w, h): calls the pixel routine sub_B5D80 on every second pixel of
; the rect (checkerboard shade), ret 4
;-----------------------------------------------------------------------------
; C: src/engine/hud/DitherRect.c
%ifdef CBUILD
%include "c/engine/hud/DitherRect.inc"
%else
DitherRect:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebp, eax
        mov dword [byte esp+04h], edx
        mov dword [byte esp+08h], ebx
        mov dword [esp], ecx
        lea edi, [byte edx+01h]
        jmp short .4
.1:
        mov esi, ebp
        jmp short .3
.2:
        mov ebx, dword [byte esp+01Ch]
        push ebx
        push edi
        push esi
        call sub_B5D80
        add esp, byte 0Ch
        add esi, byte 2
.3:
        mov eax, dword [byte esp+08h]
        add eax, ebp
        cmp esi, eax
        jl short DitherRect.2
        add edi, byte 2
.4:
        mov eax, dword [byte esp+04h]
        add eax, dword [esp]
        cmp edi, eax
        jl short DitherRect.1
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; checkwindow                       65D01  94G replay94.asm, medium confidence
; 93G/94G checkwindow role (set the scroll position to follow the puck):
; works on yc1/xc1 (93G: locked coordinates or puck carrier Ypos + Yvel
; lead), camx/camy with clamps, sflags and puckc; called once a frame from
; DoGameFrame. PC code differs (gmode bit 7 fixed view at -64h/0Fh)
;-----------------------------------------------------------------------------
; C: src/engine/hud/checkwindow.c
%ifdef CBUILD
%include "c/engine/hud/checkwindow.inc"
%else
checkwindow:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edx, 28h
        mov ecx, 0Ah
        xor ebx, ebx
        mov ax, word [yc1]
        mov word [regd2], ax
        mov ax, word [xc1]
        mov word [regd3], ax
        test byte [gmode], 80h
        je near .19
        mov edi, 0FFFFFF9Ch
        mov word [xc1], di
        mov word [regd3], di
        mov ebx, 0Fh
        mov word [yc1], bx
        mov word [regd2], bx
        mov ecx, 5
        mov ax, word [camy]
        sub ebx, eax
        mov word [regd0], bx
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFBh
        jge short .1
        mov word [regd1], 14h
        jmp short .2
.1:
        cmp bx, cx
        jle short .2
        mov word [regd1], 0Ah
.2:
        cmp word [regd0], byte 0
        jge short .3
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [regd0-2]
        sar eax, 10h
.4:
        movsx ecx, cx
        cmp eax, ecx
        jle near .11
        mov ax, word [camy]
        mov cx, word [regd1]
        sub ecx, eax
        mov word [regd1], cx
        test cx, cx
        jge short .5
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [regd1-2]
        sar eax, 10h
.6:
        cmp eax, byte 20h
        jle short .9
        cmp word [regd1], byte 0
        jge short .7
        mov eax, 0FFFFFFE0h
        jmp short .8
.7:
        mov eax, 20h
.8:
        mov word [regd1], ax
.9:
        mov ax, word [regd1]
        test ax, ax
        je short .11
        mov ebx, eax
        sar bx, 5
        mov word [regd1], bx
        test bx, bx
        jne short .10
        mov word [regd1], 1
.10:
        mov ax, word [regd1]
        add word [camy], ax
.11:
        mov ax, word [regd3]
        mov bx, word [camx]
        sub eax, ebx
        mov word [regd0], ax
        movsx ecx, dx
        neg ecx
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, ecx
        jge short .12
        mov ax, word [regd3]
        add edx, eax
        mov word [regd1], dx
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE0h
        jge short .13
        mov word [regd1], 0FFE0h
        jmp short .13
.12:
        cmp dx, word [regd0]
        jge near .65
        mov ax, word [regd3]
        sub eax, edx
        mov word [regd1], ax
        cmp ax, 20h
        jle short .13
        mov word [regd1], 20h
.13:
        mov ax, word [camx]
        mov dx, word [regd1]
        sub edx, eax
        mov word [regd1], dx
        test dx, dx
        jge short .14
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .15
.14:
        mov eax, dword [regd1-2]
        sar eax, 10h
.15:
        cmp eax, byte 20h
        jle short .18
        cmp word [regd1], byte 0
        jge short .16
        mov eax, 0FFFFFFE0h
        jmp short .17
.16:
        mov eax, 20h
.17:
        mov word [regd1], ax
.18:
        mov si, word [regd1]
        test si, si
        je near .65
        mov edi, esi
        sar di, 5
        mov word [regd1], di
        test di, di
        jne near .64
        mov word [regd1], 1
        jmp near .64
.19:
        cmp word [gameclock], byte 0
        jne short .20
        cmp word [clockticks], byte 0
        je near .43
.20:
        test byte [gmode], 4
        je short .21
        cmp word [Pencntdwn], byte 0
        jl short .22
.21:
        cmp word [RefStep], byte 0
        jle near .38
.22:
        mov eax, SortCords+800h
        mov si, word [SortCords+802h]
        mov word [xc1], si
        mov si, word [refYpos2]
        mov word [yc1], si
        mov si, word [xc1]
        mov di, word [camx]
        sub esi, edi
        mov word [regd2], si
        mov si, word [reftemp3]
        sub esi, edi
        mov word [regd3], si
        mov esi, dword [regd2-2]
        sar esi, 10h
        mov edi, dword [regd3-2]
        sar edi, 10h
        xor edi, esi
        test edi, edi
        jge short .23
        mov si, word [camx]
        jmp short .27
.23:
        cmp word [regd2], byte 0
        jge short .24
        neg esi
.24:
        cmp word [regd3], byte 0
        jge short .25
        mov edi, dword [regd3-2]
        sar edi, 10h
        neg edi
        jmp short .26
.25:
        mov edi, dword [regd3-2]
        sar edi, 10h
.26:
        cmp esi, edi
        jle short .28
        mov si, word [byte eax+temp3]
.27:
        mov word [xc1], si
.28:
        mov si, word [yc1]
        mov di, word [camy]
        sub esi, edi
        mov word [regd2], si
        mov si, word [byte eax+temp4]
        sub esi, edi
        mov word [regd3], si
        mov esi, dword [regd2-2]
        sar esi, 10h
        mov edi, dword [regd3-2]
        sar edi, 10h
        xor edi, esi
        test edi, edi
        jge short .30
        mov si, word [camy]
.29:
        mov word [regd2], si
        mov word [yc1], si
        jmp short .36
.30:
        cmp word [regd2], byte 0
        jge short .31
        mov edi, esi
        neg edi
        jmp short .32
.31:
        mov edi, esi
.32:
        cmp word [regd3], byte 0
        jge short .33
        mov esi, dword [regd3-2]
        sar esi, 10h
        neg esi
        jmp short .34
.33:
        mov esi, dword [regd3-2]
        sar esi, 10h
.34:
        cmp edi, esi
        jle short .35
        mov si, word [byte eax+temp4]
        jmp short checkwindow.29
.35:
        mov si, word [yc1]
        mov word [regd2], si
.36:
        mov si, word [xc1]
        mov word [regd3], si
        mov esi, dword [eax]
        sar esi, 10h
        mov edi, dword [fox-2]
        sar edi, 10h
        sub esi, edi
        mov edi, esi
        mov esi, dword [byte eax+Ypos]
        sar esi, 10h
        mov dword [esp], esi
        mov esi, dword [foy-2]
        sar esi, 10h
        mov ebp, dword [esp]
        sub ebp, esi
        mov esi, ebp
        mov ebp, dword [byte eax+assnum-2]
        sar ebp, 10h
        add eax, ebp
        cmp byte [byte eax+01Eh], 22h
        je short .37
        cmp byte [byte eax+01Eh], 2Ch
        jne near .43
.37:
        imul edi, edi
        imul esi, esi
        add esi, edi
        cmp esi, 640h
        jge near .43
        mov ax, word [foy]
        mov word [yc1], ax
        mov word [regd2], ax
        mov ax, word [fox]
        mov word [xc1], ax
        mov word [regd3], ax
        xor ecx, ecx
        xor edx, edx
        jmp near .43
.38:
        test byte [sflags], 40h
        jne near .43
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl near .41
        movsx eax, byte [eax]
        shl eax, 7
        add eax, SortCords
        mov edi, 2
        mov word [regd0], di
        cmp word [byte eax+SCnum], byte 10h
        jne short .39
        mov esi, dword [byte eax+0Ch]
        sar esi, 18h
        neg esi
        mov word [yleader], si
        jmp near .42
.39:
        test byte [byte eax+pflags], 80h
        je short .40
        mov esi, dword [byte eax+Yvel-2]
        sar esi, 10h
        cmp esi, byte 0FFFFFF9Ch
        setl bl
        xor bh, bh
        mov esi, edi
        mov di, word [yleader]
        add edi, esi
        mov word [yleader], di
        cmp di, byte 32h
        jl short .42
        mov word [yleader], 32h
        jmp short .42
.40:
        cmp word [byte eax+Yvel], byte 64h
        setg bl
        xor bh, bh
        mov si, word [regd0]
        sub word [yleader], si
        mov esi, dword [yleader-2]
        sar esi, 10h
        cmp esi, byte 0FFFFFFCEh
        jg short .42
        mov word [yleader], 0FFCEh
        jmp short .42
.41:
        mov eax, puckstruct
.42:
        mov esi, dword [byte eax+0Ch]
        sar esi, 18h
        mov edi, dword [byte eax+Ypos]
        sar edi, 10h
        add edi, esi
        mov esi, dword [yleader-2]
        sar esi, 10h
        add esi, edi
        mov word [regd2], si
        mov word [yc1], si
        mov ax, word [byte eax+Xpos+2]
        mov word [regd3], ax
        mov word [xc1], ax
.43:
        mov ax, word [regd2]
        mov di, word [camy]
        sub eax, edi
        mov word [regd0], ax
        movsx eax, cx
        neg eax
        mov esi, dword [regd0-2]
        sar esi, 10h
        cmp esi, eax
        jge short .44
        mov ax, word [regd2]
        add eax, ecx
        mov word [regd1], ax
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, 0FFFFFF44h
        jge short .47
        mov word [regd1], 0FF44h
        jmp short .47
.44:
        cmp cx, word [regd0]
        jge short .47
        test bx, bx
        je short .45
        mov ax, word [regd2]
        jmp short .46
.45:
        mov ax, word [regd2]
        sub eax, ecx
.46:
        mov word [regd1], ax
        cmp word [regd1], 0ECh
        jle short .47
        mov word [regd1], 0ECh
.47:
        cmp word [regd0], byte 0
        jge short .48
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .49
.48:
        mov eax, dword [regd0-2]
        sar eax, 10h
.49:
        movsx ecx, cx
        cmp eax, ecx
        jle near .56
        mov ax, word [camy]
        mov di, word [regd1]
        sub edi, eax
        mov word [regd1], di
        test byte [gmode], 1
        je short .54
        test di, di
        jge short .50
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .51
.50:
        mov eax, dword [regd1-2]
        sar eax, 10h
.51:
        cmp eax, byte 20h
        jle short .54
        cmp word [regd1], byte 0
        jge short .52
        mov eax, 0FFFFFFE0h
        jmp short .53
.52:
        mov eax, 20h
.53:
        mov word [regd1], ax
.54:
        mov si, word [regd1]
        test si, si
        je short .56
        test bx, bx
        sete al
        xor ecx, ecx
        mov cl, al
        add ecx, byte 3
        mov edi, esi
        sar di, cl
        mov word [regd1], di
        test di, di
        jne short .55
        mov word [regd1], 1
.55:
        mov ax, word [regd1]
        add word [camy], ax
.56:
        mov ax, word [regd3]
        mov si, word [camx]
        sub eax, esi
        mov word [regd0], ax
        movsx eax, dx
        neg eax
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        cmp ecx, eax
        jge short .57
        mov ax, word [regd3]
        add edx, eax
        mov word [regd1], dx
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE0h
        jge short .58
        mov word [regd1], 0FFE0h
        jmp short .58
.57:
        cmp dx, word [regd0]
        jge near .65
        mov ax, word [regd3]
        sub eax, edx
        mov word [regd1], ax
        cmp ax, 20h
        jle short .58
        mov word [regd1], 20h
.58:
        mov ax, word [camx]
        mov cx, word [regd1]
        sub ecx, eax
        mov word [regd1], cx
        test cx, cx
        jge short .59
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .60
.59:
        mov eax, dword [regd1-2]
        sar eax, 10h
.60:
        cmp eax, byte 20h
        jle short .63
        cmp word [regd1], byte 0
        jge short .61
        mov eax, 0FFFFFFE0h
        jmp short .62
.61:
        mov eax, 20h
.62:
        mov word [regd1], ax
.63:
        mov ax, word [regd1]
        test ax, ax
        je short .65
        mov edx, eax
        sar dx, 4
        mov word [regd1], dx
        test dx, dx
        jne short .64
        mov word [regd1], 1
.64:
        mov ax, word [regd1]
        add word [camx], ax
.65:
        add esp, byte 4
checkwindow_popebp:
        pop ebp
checkwindow_popx:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadTeamPPV                                     66497  95 PC, low confidence
; Team: when sub_8DAB8() >= ovlmemneed[team], opens the team's .PPV (name
; ovlartnames[team], CD flag via ovlartfiles into fileoncd) with sub_8E8A0;
; joysampling held off while loading
;-----------------------------------------------------------------------------
; C: src/engine/hud/checkwindow.c (LoadTeamPPV)
%ifdef CBUILD
%include "c/engine/hud/checkwindow.LoadTeamPPV.inc"
%else
LoadTeamPPV:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov edi, eax
        movsx esi, ax
        shl esi, 2
        call sub_8DAB8
        cmp eax, dword [dword esi+ovlmemneed]
        jl near .5
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor ebx, ebx
        mov dword [joysampling], ebx
        mov ecx, str_PPV
        mov ebx, dword [dword esi+ovlartnames]
        mov eax, dword [dword esi+ovlartfiles]
        cmp byte [dword eax+fileoncd], 1
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
        mov dword [ovlartbank], eax
        xor esi, esi
        jmp short .4
.3:
        push esi
        push str_04d2
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, esp
        push eax
        mov ebp, dword [ovlartbank]
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [nosplit esi*4+ovlstepart], eax
        inc esi
.4:
        mov ecx, dword [ovlartbank]
        push ecx
        call ShapeBankCount
        add esp, byte 4
        cmp esi, eax
        jl short LoadTeamPPV.3
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
        mov word [ovlseq], di
        movsx eax, di
        mov edx, dword [nosplit eax*4+ovlscripts]
        mov dword [ovlscript], edx
        mov ax, word [nosplit eax*4+ovlsteptime]
        mov word [ovlsteptimer], ax
        mov word [ovlstepidx], 1
        mov eax, dword [ovlscript]
        movsx ax, byte [byte eax+01h]
        mov word [ovlstep], ax
.5:
        add esp, byte 10h
        jmp near checkwindow_popebp
%endif ; C
;-----------------------------------------------------------------------------
; DrawTextOverlay                              665AD  95 PC, medium confidence
; Draws the textline1..5 overlay sliding in/out with the ovltimer timer (<10h
; in, 100h..258h out) and clears the call banner (bannermsg -1, bannertimer
; 0)
;-----------------------------------------------------------------------------
; C: src/engine/hud/checkwindow.c (DrawTextOverlay)
%ifdef CBUILD
%include "c/engine/hud/checkwindow.DrawTextOverlay.inc"
%else
DrawTextOverlay:
        push dword 60h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        mov dx, word [ovltimer]
        cmp dx, byte 10h
        jge short .1
        mov edi, edx
        sub edi, byte 10h
        jmp short .3
.1:
        cmp dx, 100h
        jg short .2
        xor edi, edi
        jmp short .3
.2:
        cmp dx, 258h
        jl short .3
        mov edi, 258h
        sub edi, edx
.3:
        mov word [bannermsg], 0FFFFh
        xor edx, edx
        mov word [bannertimer], dx
        test di, di
        jge near .5
        movsx ebx, di
        add ebx, byte 10h
        mov eax, ebx
        shl eax, 5
        lea edx, [ebx+eax]
        add edx, edx
        mov eax, edx
        sar edx, 1Fh
        shl edx, 4
        LD sbb, eax, edx
        sar eax, 4
        mov word [byte esp+018h], ax
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        lea edx, [ebx+eax]
        add edx, edx
        mov eax, edx
        sar edx, 1Fh
        shl edx, 4
        LD sbb, eax, edx
        sar eax, 4
        mov dword [byte esp+02Ch], eax
        mov ax, word [cliprect_x0]
        mov word [byte esp+028h], ax
        mov ax, word [cliprect_x1]
        mov word [byte esp+0Ch], ax
        mov ax, word [cliprect_y0]
        mov word [byte esp+020h], ax
        mov ax, word [cliprect_y1]
        mov word [byte esp+010h], ax
        mov si, word [scrollx]
        add esi, byte 4Ah
        sub esi, dword [byte esp+018h]
        cmp word [gsp], byte 4
        jne short .4
        add esi, 0ACh
.4:
        mov eax, dword [byte esp+018h]
        add eax, esi
        mov edx, dword [byte esp+018h]
        add edx, eax
        mov word [byte esp+024h], dx
        mov ax, word [scrolly]
        add eax, 32h
        mov edx, dword [byte esp+02Ch]
        sub eax, edx
        mov word [byte esp+01Ch], ax
        add eax, edx
        add edx, eax
        mov word [byte esp+014h], dx
        mov ax, word [cliprect_x0]
        sub ax, word [scrollx]
        add esi, eax
        add word [byte esp+024h], ax
        mov ax, word [cliprect_y0]
        sub ax, word [scrolly]
        add word [byte esp+01Ch], ax
        add word [byte esp+014h], ax
        mov eax, dword [byte esp+012h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+01Eh]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+02Ah]
        sar eax, 10h
        push eax
        movsx eax, si
        push eax
        call SetClipWindow
        add esp, byte 10h
.5:
        mov si, word [scrollx]
        add esi, byte 0Ch
        cmp word [gsp], byte 4
        jne short .6
        add esi, 0ACh
.6:
        mov ax, word [scrolly]
        add eax, 0Ch
        mov word [byte esp+01Ch], ax
        mov eax, esi
        add eax, 7Bh
        mov word [byte esp+024h], ax
        mov ax, word [scrolly]
        add eax, 57h
        mov word [byte esp+014h], ax
        mov ax, word [cliprect_x0]
        sub ax, word [scrollx]
        add esi, eax
        add word [byte esp+024h], ax
        mov ax, word [cliprect_y0]
        sub ax, word [scrolly]
        add word [byte esp+01Ch], ax
        add word [byte esp+014h], ax
        test di, di
        jl short .7
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .7
        mov eax, dword [ovlstep-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne short .8
.7:
        push byte 10h
        mov eax, dword [byte esp+016h]
        sar eax, 10h
        mov ebp, dword [byte esp+01Eh]
        sar ebp, 10h
        sub eax, ebp
        mov dword [byte esp+08h], eax
        push eax
        mov eax, dword [byte esp+02Ah]
        sar eax, 10h
        movsx edx, si
        mov dword [byte esp+08h], edx
        sub eax, edx
        mov dword [byte esp+010h], eax
        push eax
        push ebp
        push edx
        call sub_90EC0
        add esp, byte 14h
        push byte 9
        mov ecx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        mov edx, ebp
        mov eax, dword [byte esp+04h]
        call DitherRect
.8:
        test di, di
        je short .9
        cmp word [byte esp+018h], byte 3Eh
        jl short .10
.9:
        push byte 0
        push byte 4
        push dword 83h
        mov eax, dword [byte esp+026h]
        sar eax, 10h
        mov dword [byte esp+014h], eax
        sub eax, byte 4
        push eax
        movsx ebp, si
        sub ebp, byte 4
        push ebp
        call FillRect
        add esp, byte 14h
        push byte 0
        push byte 4Bh
        push byte 4
        mov edx, dword [byte esp+014h]
        push edx
        push ebp
        call FillRect
        add esp, byte 14h
        push byte 0
        push byte 4Bh
        push byte 4
        mov ebx, dword [byte esp+014h]
        push ebx
        mov eax, dword [byte esp+032h]
        sar eax, 10h
        push eax
        call FillRect
        add esp, byte 14h
        push byte 0
        push byte 4
        push dword 83h
        mov eax, dword [byte esp+01Eh]
        sar eax, 10h
        push eax
        push ebp
        call FillRect
        add esp, byte 14h
.10:
        test di, di
        jge short .11
        mov eax, dword [byte esp+0Eh]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+022h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+012h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+032h]
        sar eax, 10h
        push eax
        call SetClipWindow
        add esp, byte 10h
        jmp near .33
.11:
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je near .20
        mov eax, dword [ovlstep-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je near .20
        cmp word [ovlseq], byte 0Ah
        jne short .12
        cmp word [ovlstep], byte 10h
        jle short .12
        mov edi, dword [byte esp+01Ah]
        sar edi, 10h
        push edi
        movsx ebp, si
        push ebp
        mov ebx, dword [ovlstepart_e30]
        push ebx
        call sub_B500C
        add esp, byte 0Ch
        add edi, byte 1Fh
        push edi
        add ebp, byte 11h
        push ebp
        mov eax, dword [ovlstep-2]
        sar eax, 10h
        mov ecx, dword [nosplit eax*4+ovlstepart]
        push ecx
        jmp short .14
.12:
        cmp word [ovlseq], byte 8
        jne short .13
        mov bx, word [ovlstep]
        cmp bx, byte 12h
        jl short .13
        cmp bx, byte 14h
        jg short .13
        mov ebp, dword [byte esp+01Ah]
        sar ebp, 10h
        push ebp
        movsx edi, si
        push edi
        mov eax, dword [ovlstepart_e21]
        push eax
        call sub_B500C
        add esp, byte 0Ch
        add ebp, byte 3Ch
        push ebp
        push edi
        mov eax, dword [ovlstep-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+ovlstepart]
        push edx
        jmp short .14
.13:
        mov eax, dword [byte esp+01Ah]
        sar eax, 10h
        push eax
        movsx eax, si
        push eax
        mov eax, dword [ovlstep-2]
        sar eax, 10h
        mov ebp, dword [nosplit eax*4+ovlstepart]
        push ebp
.14:
        call sub_B500C
        add esp, byte 0Ch
        cmp word [ovlseq], byte 0
        jne near .33
        cmp word [ovlstep], byte 2
        jne near .33
        add word [byte esp+01Ch], byte 23h
        cmp word [crowdlevel], 2EEh
        jle short .16
        mov eax, dword [crowdlevel-2]
        sar eax, 10h
        sub eax, 2EEh
        cmp eax, 0C8h
        jl short .15
        mov eax, 0C8h
.15:
        mov word [byte esp+018h], ax
        mov ebx, 5
        cwd
        idiv bx
        mov word [byte esp+018h], ax
        push byte 30h
        mov ecx, dword [byte esp+016h]
        sar ecx, 10h
        mov edx, dword [byte esp+01Eh]
        sar edx, 10h
        sub ecx, edx
        mov ebx, dword [byte esp+01Ah]
        sar ebx, 10h
        movsx eax, si
        call DitherRect
.16:
        cmp word [crowdlevel], 3B6h
        jle short .18
        mov eax, dword [crowdlevel-2]
        sar eax, 10h
        add esi, byte 28h
        sub eax, 3B6h
        cmp eax, 0C8h
        jl short .17
        mov eax, 0C8h
.17:
        mov word [byte esp+018h], ax
        mov ebx, 5
        cwd
        idiv bx
        mov word [byte esp+018h], ax
        push byte 27h
        mov ecx, dword [byte esp+016h]
        sar ecx, 10h
        mov edx, dword [byte esp+01Eh]
        sar edx, 10h
        sub ecx, edx
        mov ebx, dword [byte esp+01Ah]
        sar ebx, 10h
        movsx eax, si
        call DitherRect
.18:
        cmp word [crowdlevel], 47Eh
        jle near .33
        mov eax, dword [crowdlevel-2]
        sar eax, 10h
        add esi, byte 28h
        sub eax, 47Eh
        cmp eax, 0D7h
        jl short .19
        mov eax, 0D7h
.19:
        mov word [byte esp+018h], ax
        mov ebx, 5
        cwd
        idiv bx
        mov word [byte esp+018h], ax
        push byte 60h
        mov ecx, dword [byte esp+016h]
        sar ecx, 10h
        mov edx, dword [byte esp+01Eh]
        sar edx, 10h
        sub ecx, edx
        mov ebx, dword [byte esp+01Ah]
        sar ebx, 10h
        movsx eax, si
        call DitherRect
        jmp near .33
.20:
        cmp byte [textline5], 0
        je short .21
        mov dword [byte esp+02Ch], 0Dh
        add word [byte esp+01Ch], byte 8
        jmp short .23
.21:
        cmp byte [textline4], 0
        je short .22
        mov dword [byte esp+02Ch], 0Fh
        add word [byte esp+01Ch], byte 0Bh
        jmp short .23
.22:
        mov dword [byte esp+02Ch], 12h
        add word [byte esp+01Ch], byte 0Fh
.23:
        mov ecx, dword [scor3font]
        push ecx
        add esi, byte 3Eh
        call TextSetFont
        add esp, byte 4
        push dword 0FFh
        push byte 25h
        call TextSetColors
        add esp, byte 8
        mov edi, dword [byte esp+01Ch]
        cmp byte [textline3], 0
        je short .24
        mov eax, dword [byte esp+01Ah]
        sar eax, 10h
        push eax
        push textline3
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline3
        call PrintString
        add esp, byte 0Ch
.24:
        cmp byte [textline1], 0
        je short .25
        add edi, dword [byte esp+02Ch]
        movsx eax, di
        push eax
        push textline1
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline1
        call PrintString
        add esp, byte 0Ch
.25:
        cmp byte [textline2], 0
        je short .26
        add edi, dword [byte esp+02Ch]
        movsx eax, di
        push eax
        push textline2
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline2
        call PrintString
        add esp, byte 0Ch
.26:
        cmp byte [textline4], 0
        je short .27
        add edi, dword [byte esp+02Ch]
        movsx eax, di
        push eax
        push textline4
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline4
        call PrintString
        add esp, byte 0Ch
.27:
        cmp byte [textline5], 0
        je short .28
        add edi, dword [byte esp+02Ch]
        movsx eax, di
        push eax
        push textline5
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline5
        call PrintString
        add esp, byte 0Ch
.28:
        mov edi, dword [scor2font]
        push edi
        call TextSetFont
        add esp, byte 4
        push dword 0FFh
        push byte 27h
        call TextSetColors
        add esp, byte 8
        mov edi, dword [byte esp+01Ch]
        cmp byte [textline3], 0
        je short .29
        mov eax, dword [byte esp+01Ah]
        sar eax, 10h
        push eax
        push textline3
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline3
        call PrintString
        add esp, byte 0Ch
.29:
        cmp byte [textline1], 0
        je short .30
        add edi, dword [byte esp+02Ch]
        movsx eax, di
        push eax
        push textline1
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline1
        call PrintString
        add esp, byte 0Ch
.30:
        cmp byte [textline2], 0
        je short .31
        add edi, dword [byte esp+02Ch]
        movsx eax, di
        push eax
        push textline2
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline2
        call PrintString
        add esp, byte 0Ch
.31:
        cmp byte [textline4], 0
        je short .32
        add edi, dword [byte esp+02Ch]
        movsx eax, di
        push eax
        push textline4
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline4
        call PrintString
        add esp, byte 0Ch
.32:
        cmp byte [textline5], 0
        je short .33
        add edi, dword [byte esp+02Ch]
        movsx eax, di
        push eax
        push textline5
        call fputchar
        mov edx, eax
        add esp, byte 4
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        movsx edx, si
        sub edx, eax
        push edx
        push textline5
        call PrintString
        add esp, byte 0Ch
.33:
        mov si, word [cliprect_x0]
        add esi, byte 8
        cmp word [gsp], byte 4
        jne short .34
        add esi, 0ACh
.34:
        mov ax, word [cliprect_y0]
        add eax, 8
        mov word [byte esp+01Ch], ax
        mov ebx, dword [byte esp+01Ah]
        sar ebx, 10h
        lea eax, [byte ebx+053h]
        push eax
        movsx edx, si
        lea ecx, [dword edx+083h]
        mov eax, dword [spritedrawcount]
        lea edi, [byte eax+01h]
        mov dword [spritedrawcount], edi
        call MarkZoneRect
        add esp, byte 30h
        jmp near checkwindow_popebp
%endif ; C
;-----------------------------------------------------------------------------
; CloseTextOverlay                             66DDA  95 PC, medium confidence
; Ovltimer: 100h (fully shown) -> 10h (start sliding out), else 0
;-----------------------------------------------------------------------------
; C: src/engine/hud/CloseTextOverlay.c
%ifdef CBUILD
%include "c/engine/hud/CloseTextOverlay.inc"
%else
CloseTextOverlay:
        push dword 8
        call __CHK
        push ebx
        cmp word [ovltimer], 100h
        jne short .1
        mov word [ovltimer], 10h
        pop ebx
        ret
.1:
        xor ebx, ebx
        mov word [ovltimer], bx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; UpdateTextOverlay                            66E06  95 PC, medium confidence
; Per frame: crowd boost while a sequence runs; steps the overlay script
; ovlscript (ovlseq sequence, ovlstep step, ovlstepidx/ovlsteptimer from
; ovlsteptime), frees the script buffer (ovlartbank) at the end; advances
; ovltimer and clears textline1..5 after 268h
;-----------------------------------------------------------------------------
; C: src/engine/hud/checkwindow.c (UpdateTextOverlay)
%ifdef CBUILD
%include "c/engine/hud/checkwindow.UpdateTextOverlay.inc"
%else
UpdateTextOverlay:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        cmp word [ovltimer], byte 0
        jl near checkwindow_popx
        mov bx, word [Pencntdwn]
        cmp bx, 100h
        jl short .1
        cmp bx, 140h
        jg short .1
        test byte [gmode], 40h
        je near checkwindow_popx
.1:
        cmp word [ovlseq], byte 0
        jne near .6
        cmp word [ovlstep], byte 5
        jge short .6
        mov ax, word [crowdlevel]
        cmp ax, 5DCh
        jge short .6
        cmp word [ovlstepidx], byte 1
        jne short .2
        cmp ax, 280h
        jge short .2
        mov word [crowdlevel], 280h
.2:
        mov si, word [ovlstepidx]
        cmp si, byte 1
        jl short .3
        cmp si, byte 5
        jl short .5
.3:
        mov ax, word [ovlstepidx]
        cmp ax, 7
        jle short .4
        cmp ax, 0Dh
        jl short .5
.4:
        cmp word [ovlstepidx], byte 10h
        jle short .6
.5:
        add word [crowdlevel], byte 8
.6:
        cmp word [ovltimer], byte 10h
        jne near .9
        mov edx, dword [ovlseq-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je near .9
        mov ebx, dword [ovlscript]
        test ebx, ebx
        je near .9
        mov si, word [ovlsteptimer]
        dec esi
        mov word [ovlsteptimer], si
        test si, si
        jge near checkwindow_popx
        mov eax, ebx
        movsx bx, byte [ebx]
        mov cx, word [ovlstepidx]
        cmp bx, cx
        jne short .8
        mov ecx, dword [ovlartbank]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp byte [dword eax+ovlseqtimed], 0
        je short .7
        mov word [ovltimer], 258h
.7:
        mov eax, 0FFFFFFFFh
        mov word [ovlstep], ax
        mov word [ovlseq], ax
        xor esi, esi
        mov dword [ovlscript], esi
        jmp near checkwindow_popx
.8:
        mov esi, ecx
        inc esi
        mov word [ovlstepidx], si
        mov ebx, dword [ovlstepidx-2]
        sar ebx, 10h
        movsx ax, byte [ebx+eax]
        mov word [ovlstep], ax
        mov ax, word [nosplit edx*4+ovlsteptime]
        mov word [ovlsteptimer], ax
        jmp near checkwindow_popx
.9:
        mov di, word [ovltimer]
        cmp di, 100h
        jl short .10
        cmp di, 258h
        jl short .11
.10:
        inc word [ovltimer]
.11:
        cmp word [ovltimer], 268h
        jle near checkwindow_popx
        mov word [ovltimer], 0FFFFh
        xor dl, dl
        mov byte [textline5], dl
        mov byte [textline4], dl
        mov byte [textline2], dl
        mov byte [textline1], dl
        mov byte [textline3], dl
        jmp near checkwindow_popx
%endif ; C
;-----------------------------------------------------------------------------
; DrawCallBanner                               66FE2  95 PC, medium confidence
; Draws the referee call banner bannermsg (bannerstrs: RETURN GOALIE, PULL
; GOALIE, FACE-OFF, 2 LINE PASS, OFFSIDE, ICING, PENALTY, PENALTY SHOT) with
; scor3font at scrolly+95h; called from the engine frame when bannermsg != -1
;-----------------------------------------------------------------------------
; C: src/engine/hud/checkwindow.c (DrawCallBanner)
%ifdef CBUILD
%include "c/engine/hud/checkwindow.DrawCallBanner.inc"
%else
DrawCallBanner:
        push dword 54h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov edi, eax
        mov si, word [scrollx]
        add esi, byte 0Ch
        mov ax, word [scrolly]
        add eax, 95h
        mov word [byte esp+01Ch], ax
        mov ax, word [scrolly]
        add eax, 9Eh
        mov word [byte esp+020h], ax
        mov edx, dword [scor3font]
        push edx
        call TextSetFont
        add esp, byte 4
        movsx ebp, di
        shl ebp, 2
        mov ebx, dword [dword ebp+bannerstrs]
        push ebx
        call fputchar
        add esp, byte 4
        add eax, 4
        mov word [byte esp+018h], ax
        add eax, esi
        mov di, word [cliprect_x0]
        sub di, word [scrollx]
        add esi, edi
        add eax, edi
        mov di, word [cliprect_y0]
        sub di, word [scrolly]
        add word [byte esp+01Ch], di
        add word [byte esp+020h], di
        push byte 10h
        mov edx, dword [byte esp+022h]
        sar edx, 10h
        mov dword [byte esp+04h], edx
        mov edi, dword [byte esp+01Eh]
        sar edi, 10h
        add word [byte esp+01Ch], byte 8
        sub edx, edi
        mov dword [byte esp+010h], edx
        push edx
        cwde
        mov dword [byte esp+0Ch], eax
        movsx eax, si
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+0Ch]
        mov edx, dword [byte esp+010h]
        sub eax, edx
        mov dword [byte esp+018h], eax
        push eax
        push edi
        push edx
        call FillRect
        add esp, byte 14h
        push byte 9
        mov ecx, dword [byte esp+010h]
        mov ebx, dword [byte esp+014h]
        mov edx, edi
        mov eax, dword [byte esp+0Ch]
        call DitherRect
        push byte 0
        push byte 4
        mov eax, dword [byte esp+01Eh]
        sar eax, 10h
        mov dword [byte esp+01Ch], eax
        push eax
        lea eax, [byte edi-04h]
        push eax
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
        mov dword [byte esp+020h], eax
        push eax
        call FillRect
        add esp, byte 14h
        push byte 0
        push byte 9
        push byte 4
        push edi
        mov ebx, dword [byte esp+020h]
        push ebx
        call FillRect
        add esp, byte 14h
        push byte 0
        push byte 9
        push byte 4
        push edi
        mov ecx, dword [byte esp+014h]
        push ecx
        call FillRect
        add esp, byte 14h
        push byte 0
        push byte 4
        mov edi, dword [byte esp+01Ch]
        push edi
        mov eax, dword [byte esp+0Ch]
        push eax
        mov edx, dword [byte esp+020h]
        push edx
        call FillRect
        add esp, byte 14h
        push dword 0FFh
        push byte 25h
        call TextSetColors
        add esp, byte 8
        mov eax, esi
        add eax, 2
        mov edx, dword [byte esp+01Ch]
        inc edx
        mov word [byte esp+020h], dx
        mov edi, dword [byte esp+01Eh]
        sar edi, 10h
        push edi
        cwde
        mov dword [byte esp+04h], eax
        push eax
        mov ecx, dword [dword ebp+bannerstrs]
        push ecx
        call PrintString
        add esp, byte 0Ch
        mov eax, dword [scor2font]
        push eax
        call TextSetFont
        add esp, byte 4
        push dword 0FFh
        push byte 27h
        call TextSetColors
        add esp, byte 8
        push edi
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [dword ebp+bannerstrs]
        push ebx
        call PrintString
        add esp, byte 0Ch
        sub esi, byte 4
        sub word [byte esp+01Ch], byte 4
        mov ebx, dword [byte esp+01Ah]
        sar ebx, 10h
        lea eax, [byte ebx+011h]
        push eax
        movsx edx, si
        mov ecx, dword [byte esp+018h]
        add ecx, edx
        mov eax, dword [spritedrawcount]
        lea edi, [byte eax+01h]
        mov dword [spritedrawcount], edi
        call MarkZoneRect
        add esp, byte 24h
        jmp near checkwindow_popebp
%endif ; C
;-----------------------------------------------------------------------------
; ShowGoalieBanner                             671E8  95 PC, medium confidence
; For a controller-owned team: when its goalie (hmtmgoalie) is pulled or
; returned sets bannermsg 0/1 (RETURN / PULL GOALIE) and bannertimer 50h
;-----------------------------------------------------------------------------
; C: src/engine/hud/ShowGoalieBanner.c
%ifdef CBUILD
%include "c/engine/hud/ShowGoalieBanner.inc"
%else
ShowGoalieBanner:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        cwde
        mov ebx, eax
        shl ebx, 8
        mov bx, word [dword ebx+hmtmgoalie]
        cmp dword [curperiod], byte 0FFFFFFFFh
        je near .x
        mov ecx, dword [cont1team-2]
        sar ecx, 10h
        inc eax
        cmp ecx, eax
        je short .1
        mov ecx, dword [cont2team-2]
        sar ecx, 10h
        cmp ecx, eax
        jne near .x
.1:
        movsx eax, bx
        and eax, 0FFF0h
        cmp eax, 0FF00h
        je near .x
        test bx, bx
        setge al
        and eax, 0FFh
        mov cx, word [bannermsg]
        cmp ax, cx
        jg short .2
        cmp cx, byte 2
        jge short .3
.2:
        mov word [bannermsg], ax
        mov word [bannertimer], 50h
.3:
        test bx, bx
        jge short .4
        movsx ecx, dx
        mov ebx, ecx
        shl ebx, 2
        sub ebx, ecx
        shl ebx, 2
        mov eax, dword [dword ebx+goaliemenuflags_e02]
        mov byte [eax], 2
        mov eax, ecx
        shl eax, 8
        mov cx, word [dword eax+hmtmgoalie]
        xor ch, ch
        and cl, 0Fh
        mov word [dword eax+hmtmgoalie], cx
        movsx eax, cx
        mov eax, dword [dword ebx+eax*4+goaliemenuflags]
        jmp short .5
.4:
        movsx esi, dx
        mov ecx, esi
        shl ecx, 2
        sub ecx, esi
        shl ecx, 2
        xor bh, bh
        and bl, 0Fh
        movsx eax, bx
        mov eax, dword [dword ecx+eax*4+goaliemenuflags]
        mov byte [eax], 2
        mov eax, esi
        shl eax, 8
        or word [dword eax+hmtmgoalie], byte 0FFF0h
        mov eax, dword [dword ecx+goaliemenuflags_e02]
.5:
        mov byte [eax], 1
        movsx eax, dx
        shl eax, 8
        add eax, hmtmstruct
        call setpersonel
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetTeamGoalie                                672F9  95 PC, medium confidence
; (team, goalie): for a controller-owned team writes hmtmgoalie(+team*100h);
; negative = pulled (OR 0FFF0h); settings_dialogs calls it from the goalie
; menu
;-----------------------------------------------------------------------------
; C: src/engine/hud/SetTeamGoalie.c
%ifdef CBUILD
%include "c/engine/hud/SetTeamGoalie.inc"
%else
SetTeamGoalie:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        movsx ebx, ax
        mov ecx, ebx
        shl ecx, 8
        mov cx, word [dword ecx+hmtmgoalie]
        mov esi, dword [cont1team-2]
        sar esi, 10h
        inc ebx
        cmp esi, ebx
        je short .1
        mov esi, dword [cont2team-2]
        sar esi, 10h
        cmp esi, ebx
        jne near .x
.1:
        test dx, dx
        jge short .2
        movsx edx, ax
        shl edx, 8
        or word [dword edx+hmtmgoalie], byte 0FFF0h
        jmp short .3
.2:
        movsx ebx, ax
        shl ebx, 8
        mov word [dword ebx+hmtmgoalie], dx
        mov dl, byte [gmode]
        test dl, 1
        jne short .3
        test dl, 8
        je short .3
        mov edx, dword [puckc]
        mov bl, byte [edx]
        test bl, bl
        jl short .3
        cmp bl, 6
        setl dl
        mov ebx, edx
        and ebx, 0FFh
        movsx edx, ax
        xor ebx, edx
        je short .3
        shl edx, 8
        or byte [dword edx+hmtmgoalie_b1], 0FFh
.3:
        movsx edx, ax
        shl edx, 8
        cmp word [dword edx+hmtmgoalie], byte 0
        jge short .4
        test cx, cx
        jl short .x
.4:
        movsx edx, ax
        shl edx, 8
        cmp cx, word [dword edx+hmtmgoalie]
        je short .x
        mov eax, hmtmstruct
        add eax, edx
        call setpersonel
.x:
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadTeamPalette                              673C5  95 PC, medium confidence
; (team, ?, pal): opens HOMEPALS.BIN (CD flag fileoncd+0A1h) and copies the
; team's 0C0h colour bytes (record team*1C0h) into pal+180h
;-----------------------------------------------------------------------------
; C: src/engine/hud/LoadTeamPalette.c
%ifdef CBUILD
%include "c/engine/hud/LoadTeamPalette.inc"
%else
LoadTeamPalette:
        push dword 30h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov edi, eax
        mov dword [byte esp+010h], edx
        mov esi, ebx
        mov ecx, str_extBIN
        mov ebx, str_HOMEPALS4
        cmp byte [fileoncd+0A1h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        mov edx, eax
        add esp, byte 8
        mov ebp, eax
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 6
        add edx, eax
        xor eax, eax
.3:
        mov cl, byte [edx+eax]
        mov byte [dword esi+eax+0180h], cl
        inc eax
        cmp eax, 0C0h
        jl short LoadTeamPalette.3
        xor eax, eax
        add edx, 0C0h
.4:
        mov bl, byte [edx+eax]
        mov byte [dword eax+homeremap], bl
        inc eax
        cmp eax, 100h
        jl short LoadTeamPalette.4
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ecx, str_extBIN
        mov ebx, str_AWAYPALS
        cmp byte [fileoncd+02Bh], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp short .6
.5:
        xor edx, edx
.6:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        mov edx, eax
        add esp, byte 8
        mov ebp, eax
        mov ebx, dword [byte esp+010h]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 6
        add edx, eax
        xor eax, eax
.7:
        mov cl, byte [edx+eax]
        mov byte [dword esi+eax+0240h], cl
        inc eax
        cmp eax, 0C0h
        jl short LoadTeamPalette.7
        xor eax, eax
        add edx, 0C0h
.8:
        mov bl, byte [edx+eax]
        mov byte [dword eax+awayremap], bl
        inc eax
        cmp eax, 90h
        jl short LoadTeamPalette.8
        mov eax, 90h
.9:
        mov bl, byte [edx+eax]
        add bl, 40h
        mov byte [dword eax+awayremap], bl
        inc eax
        cmp eax, 100h
        jl short LoadTeamPalette.9
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Rinkpal
        cmp byte [fileoncd+015Fh], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov ebp, eax
        push str_Pal30
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        xor eax, eax
.12:
        mov bl, byte [edx+eax]
        mov byte [esi+eax], bl
        inc eax
        cmp eax, 180h
        jl short LoadTeamPalette.12
        mov eax, 2F1h
.13:
        mov bl, byte [edx+eax]
        mov byte [esi+eax], bl
        inc eax
        cmp eax, 300h
        jl short LoadTeamPalette.13
        push ebp
        call FreeMemBlock
        add esp, byte 4
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
