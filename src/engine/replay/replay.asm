; Recording and stepping instant replay, and the objects at the side of the rink (95G engine/replay95).
bits 32
%include "hockey.inc"
section s_67564 progbits alloc exec nowrite align=1
extern __CHK, awlinetab, bannermsg, bannerstrs, bannertimer, ovlseqtimed, rinkobjanim, dressbystatus
extern lineslotgroups, lineslotgroupstart, hmrosterpos, awayremap, homeremap, rinkobjs_b3, hmtmgoalie_b1, doorZpos2
extern regd1_b1, defsort_d, dressflags, dressflags_aw, offsort_fwd, rpl_flip, rpl_jersey, rpl_pos
extern rpl_pos_b1, rpl_c1player, rpl_c2player, rpl_puckc, rpl_pbnum, rpl_pbnum_b1, rpl_objstep, rpl_objstep_b1
extern c1playernum, c2playernum, camx, camx_m2, camy, cddriveptr, cliprect_x0, cliprect_x1
extern cliprect_y0, cliprect_y1, clockticks, cont1team, cont2team, Crowd_Noise, crowdlevel, CrowdNoiseOff
extern curperiod, DrawFrameSprite, DrawRinkEndArt, DrawSprite, DrawSpriteNumber, ovlartfiles, markframes_e1, rinkobjdefs_m2
extern ovlmemneed, DrawClipLeft, DrawClipRight, ovlstepart, ovlstepart_e21, ovlstepart_e30, RinkSideShape
extern RinkSideShapeFlipped, ovlartbank, regd3_m2, regd0_m3, regd1_m3, SpeechPatchNext, lineslotmark
extern linesortidx, dressedskaters, rpl_x_e14_m2, rpl_x_e14, rpl_x_e16, rpl_y_e14_m2, rpl_y_e14, rpl_y_e16
extern rpl_frame_e14_m2, rpl_frame_e14, rpl_flip_m3, rpl_jersey_m3, rpl_pos_m3, rpl_puckz_m2, rpl_c1player_m3, rpl_puckc_m3
extern rpl_objstep_m3, rpl_ysort, ReplayHoverPlayer, fileoncd, fox, foy, fputchar, FreeMemBlock
extern gameclock, gmode, gmode2, gsp, hmlinetab, hmroster, hmtmgoalie, hmtmstruct
extern joysampling, joysampling_save, lastsfx, MakePath, ovlartnames, ovlscripts, goaliemenuflags, goaliemenuflags_e02
extern ovlscript, ovlseq, ovlstep, ovlstepidx, ovlsteptimer, ovltimer, PBnum, Pencntdwn
extern photoptrsf, puckc, puckstruct, puckz, recbpr, RefStep, regd0, regd1
extern regd2, regd3, replayplay, replaysfx, replaystart, replaytick, scor2font, scor3font
extern scrollx, scrolly, setpersonel, sflags, sfx, shownumbers, SortCords, sprintf_
extern spritedrawcount, str_04d2, str_AWAYPALS, str_extBIN, str_HOMEPALS4, str_Pal30, str_PPV, str_Rinkpal
extern MarkZoneRect, MemLargestFree, LoadBank, OpenArtArchiveErr, TextSetColors, TextSetFont, ShapeBankCount, FillRect
extern FillRectClipped, PrintString, SortIndices, FindShape, JoyButtonMap, SetClipWindow, VgaBlitKeyedFlipV, PutPixel
extern textline1, textline2, textline3, textline4, textline5, hmplattr, offsort_c, defsort_r
extern offsort_d, defsort_c, offsort_l, defsort_l, offsort_r, defsort_fwd, ovlsteptime, Pencntdwn2
extern rinkobjdefs, replayfollowpl, rinkobjs, refYpos2, reftemp3, dressedfwds, dresseddefs, rpl_x
extern rpl_x_e15, rpl_y, rpl_y_e15, rpl_frame, rpl_frame_e15, rpl_puckz, rpl_puckunused, rpl_camx
extern rpl_camy, rpl_objframe, xc1, yc1, yleader
global ReplayRecordReset, ReplayFirstFrame, ReplayPrevFrame, updatereplay, ReplayStep, ReplayStep_popx, DrawRinkSideObjects
;-----------------------------------------------------------------------------
; ReplayRecordReset                            67564  95 PC, medium confidence
; Replay tick counter replaytick = 1 (next updatereplay call records) and the
; recorded sfx replaysfx = -1; called from the period start / load code
;-----------------------------------------------------------------------------
; C: src/engine/replay/ReplayRecordReset.c
%ifdef CBUILD
%include "c/engine/replay/ReplayRecordReset.inc"
%else
ReplayRecordReset:
        push dword 4
        call __CHK
        mov word [replaytick], 1
        mov word [replaysfx], 0FFFFh
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReplayFirstFrame                             67581  95 PC, medium confidence
; Oldest replay frame: recbpr when the buffer has wrapped (sflags bit 4),
; else replaystart
;-----------------------------------------------------------------------------
; C: src/engine/replay/ReplayFirstFrame.c
%ifdef CBUILD
%include "c/engine/replay/ReplayFirstFrame.inc"
%else
ReplayFirstFrame:
        push dword 4
        call __CHK
        test byte [sflags], 10h
        jne short .1
        mov eax, dword [replaystart]
        ret
.1:
        mov eax, dword [recbpr]
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReplayPrevFrame                              675A0  95 PC, medium confidence
; 94G suba4 role for the record pointer: recbpr - 80h, or the last frame of
; the buffer (replaystart + 9580h) when recbpr is at the start and the buffer
; has wrapped (sflags bit 4 = 94G sfwrap)
;-----------------------------------------------------------------------------
; C: src/engine/replay/ReplayPrevFrame.c
%ifdef CBUILD
%include "c/engine/replay/ReplayPrevFrame.inc"
%else
ReplayPrevFrame:
        push dword 8
        call __CHK
        push edx
        mov eax, dword [recbpr]
        mov edx, dword [replaystart]
        cmp eax, edx
        jne short .2
        test byte [sflags], 10h
        je short .1
        lea eax, [dword edx+09580h]
        pop edx
        ret
.1:
        mov eax, edx
        pop edx
        ret
.2:
        sub eax, 80h
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; updatereplay                                         675D6  94G replay94.asm
; 93G/94G updatereplay (save replay events every frame): not in highlight
; mode (gmode bit 4); every 2nd tick packs the 17 sort objects (Xpos/Ypos 10
; bits, frame, attribute bits), the roster bytes and positions (15 for
; negative, as 94G), puck z, lastsfx (then -1) into the 80h-byte frame at
; recbpr; gmode2 bit 2 rewrites the previous frame (94G sf2drec)
;-----------------------------------------------------------------------------
updatereplay:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        test byte [gmode], 10h
        jne near .x
        mov dx, word [replaytick]
        inc edx
        mov word [replaytick], dx
        cmp dx, byte 2
        jge short .3
        test byte [gmode2], 4
        je short .1
        mov word [replaysfx], 0FFFFh
        jmp short .2
.1:
        mov ax, word [lastsfx]
        mov word [replaysfx], ax
.2:
        mov word [lastsfx], 0FFFFh
        jmp near .x
.3:
        mov edi, edx
        sub edi, byte 2
        mov word [replaytick], di
        test byte [gmode2], 4
        je short .4
        call ReplayPrevFrame
        mov dword [recbpr], eax
.4:
        mov eax, SortCords
        xor edx, edx
        jmp short .6
.5:
        mov bx, word [byte eax+Ypos+2]
        and bh, 3
        movsx ebx, bx
        mov ecx, ebx
        shl ecx, 0Ah
        mov bx, word [byte eax+Xpos+2]
        and bh, 3
        movsx ebx, bx
        or ecx, ebx
        mov bx, word [byte eax+012h]
        and bh, 7
        movsx ebx, bx
        shl ebx, 14h
        or ecx, ebx
        mov bx, word [byte eax+054h]
        xor bl, bl
        and bh, 8
        movsx ebx, bx
        shl ebx, 14h
        or ecx, ebx
        mov ebx, dword [recbpr]
        mov dword [ebx], ecx
        add dword [recbpr], byte 4
        inc edx
        add eax, 80h
.6:
        cmp dx, byte 11h
        jl short updatereplay.5
        mov eax, SortCords
        xor edx, edx
        jmp short .8
.7:
        mov ebx, dword [recbpr]
        lea ecx, [byte ebx+01h]
        mov dword [recbpr], ecx
        mov cl, byte [byte eax+05Eh]
        mov byte [ebx], cl
        inc edx
        add eax, 80h
.8:
        cmp dx, byte 0Ch
        jl short updatereplay.7
        mov eax, SortCords
        xor edx, edx
        jmp short .14
.9:
        mov bx, word [byte eax+position]
        test bx, bx
        jge short .10
        mov word [regd0], 0Fh
        jmp short .11
.10:
        mov word [regd0], bx
.11:
        add eax, 80h
        mov si, word [byte eax+position]
        test si, si
        jge short .12
        or byte [regd0], 0F0h
        jmp short .13
.12:
        mov ebx, esi
        shl ebx, 4
        or word [regd0], bx
.13:
        mov ebx, dword [recbpr]
        add eax, 80h
        lea ecx, [byte ebx+01h]
        mov dword [recbpr], ecx
        mov cl, byte [regd0]
        mov byte [ebx], cl
        inc edx
.14:
        cmp dx, byte 6
        jl short updatereplay.9
        mov ebx, dword [puckz]
        mov eax, dword [recbpr]
        lea ecx, [byte eax+01h]
        mov dword [recbpr], ecx
        mov dl, byte [ebx]
        mov byte [eax], dl
        mov eax, dword [recbpr]
        lea ebx, [byte eax+01h]
        mov dword [recbpr], ebx
        mov dl, byte [doorZpos2]
        mov byte [eax], dl
        mov eax, dword [recbpr]
        lea ebx, [byte eax+01h]
        mov dword [recbpr], ebx
        mov dl, byte [replaysfx]
        mov byte [eax], dl
        mov eax, dword [recbpr]
        lea ebx, [byte eax+01h]
        mov dword [recbpr], ebx
        mov dl, byte [lastsfx]
        mov byte [eax], dl
        mov eax, 0FFFFFFFFh
        mov word [lastsfx], ax
        mov word [replaysfx], ax
        mov dl, byte [c2playernum]
        and dl, 0Fh
        shl dl, 4
        mov al, byte [c1playernum]
        and al, 0Fh
        or dl, al
        mov eax, dword [recbpr]
        lea ebx, [byte eax+01h]
        mov dword [recbpr], ebx
        mov byte [eax], dl
        mov ebx, dword [puckc]
        mov eax, dword [recbpr]
        lea ecx, [byte eax+01h]
        mov dword [recbpr], ecx
        mov dl, byte [ebx]
        mov byte [eax], dl
        mov dl, byte [PBnum+1]
        and dl, 0Fh
        shl dl, 4
        mov al, byte [PBnum]
        and al, 0Fh
        or dl, al
        mov eax, dword [recbpr]
        lea ebx, [byte eax+01h]
        mov dword [recbpr], ebx
        mov byte [eax], dl
        mov eax, dword [recbpr]
        lea ebx, [byte eax+01h]
        mov dword [recbpr], ebx
        mov dl, byte [camx]
        mov byte [eax], dl
        mov eax, dword [recbpr]
        mov dx, word [camy]
        mov word [eax], dx
        mov ecx, dword [recbpr]
        add ecx, byte 2
        mov dword [recbpr], ecx
        mov dx, word [crowdlevel]
        mov word [ecx], dx
        xor edx, edx
        add dword [recbpr], byte 2
        jmp short .16
.15:
        movsx ecx, dx
        lea ebx, [byte ecx+ecx+01h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        mov al, byte [nosplit eax*4+rinkobjs_b3]
        and al, 0Fh
        mov byte [esp], al
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov al, byte [nosplit eax*8+rinkobjs_b3]
        and al, 0Fh
        shl al, 4
        mov bl, byte [esp]
        or bl, al
        mov eax, dword [recbpr]
        lea ecx, [byte eax+01h]
        mov dword [recbpr], ecx
        mov byte [eax], bl
        inc edx
.16:
        cmp dx, byte 0Ah
        jl short updatereplay.15
        xor edx, edx
        jmp short .18
.17:
        movsx ebx, dx
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        mov ebx, eax
        shl ebx, 2
        mov eax, dword [recbpr]
        lea ecx, [byte eax+01h]
        mov dword [recbpr], ecx
        mov bl, byte [dword ebx+rinkobjs]
        mov byte [eax], bl
        inc edx
.18:
        cmp dx, byte 14h
        jl short updatereplay.17
        mov eax, dword [replaystart]
        lea ebx, [dword eax+09600h]
        cmp ebx, dword [recbpr]
        ja short .x
        or byte [sflags], 10h
        mov dword [recbpr], eax
.x:
        add esp, byte 4
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ReplayStep                                   67900  95 PC, medium confidence
; 94G adda4/suba4 role: moves the play pointer replayplay eax frames (80h
; each, wrapping at replaystart + 9600h when sflags bit 4, stopping at
; recbpr) and restores the frame (positions, sfx, CrowdNoiseUpdate /
; CrowdNoiseOff); called from the replay gadgets
;-----------------------------------------------------------------------------
ReplayStep:
        push dword 6Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 48h
        mov esi, eax
        mov ecx, edx
        mov dword [byte esp+044h], eax
        test ax, ax
        jl near .6
        mov ebx, dword [replayplay]
.1:
        cmp si, byte 1
        jl near .11
        mov edx, dword [replaystart]
        dec esi
        mov ebp, dword [replayplay]
        add ebp, 80h
        mov dword [replayplay], ebp
        lea eax, [dword edx+09600h]
        cmp eax, ebp
        jne short .3
        test byte [sflags], 10h
        jne short .2
        mov esi, 0FFFFFFFFh
        sub ebp, 80h
        mov dword [replayplay], ebp
        jmp near .11
.2:
        mov dword [replayplay], edx
.3:
        mov eax, dword [replayplay]
        cmp eax, dword [recbpr]
        jne short .4
        mov esi, 0FFFFFFFFh
        sub dword [replayplay], 80h
        jmp near .11
.4:
        test cx, cx
        je short ReplayStep.1
        cmp ebx, eax
        je short ReplayStep.1
        mov al, byte [byte eax+058h]
        xor ah, ah
        cmp ax, 0FFh
        je short .5
        cwde
        call sfx
.5:
        mov edx, dword [replayplay]
        xor eax, eax
        mov al, byte [byte edx+059h]
        cmp ax, 0FFh
        je near ReplayStep.1
        cwde
        call sfx
        jmp near ReplayStep.1
.6:
        mov ebx, dword [recbpr]
        mov edx, dword [replaystart]
.7:
        test si, si
        jge short .11
        inc esi
        cmp edx, dword [replayplay]
        jne short .10
        test byte [sflags], 10h
        jne short .9
.8:
        mov esi, 0FFFFFFFFh
        jmp short .11
.9:
        lea eax, [dword edx+09600h]
        mov dword [replayplay], eax
.10:
        mov eax, dword [replayplay]
        cmp eax, ebx
        je short ReplayStep.8
        lea edi, [byte eax-080h]
        mov dword [replayplay], edi
        jmp short ReplayStep.7
.11:
        xor eax, eax
        jmp near .16
.12:
        mov edx, dword [replayplay]
        mov ebx, dword [edx]
        mov dword [regd0], ebx
        mov bx, word [regd0]
        and bh, 3
        mov word [regd1], bx
        add edx, byte 4
        mov dword [replayplay], edx
        mov dl, byte [regd1_b1]
        test dl, 2
        je short .13
        mov dh, dl
        or dh, 0FCh
        mov byte [regd1_b1], dh
.13:
        movsx edx, ax
        mov bx, word [regd1]
        mov word [nosplit edx*2+rpl_x], bx
        sar dword [regd0], 0Ah
        mov dx, word [regd0]
        and dh, 3
        mov word [regd1], dx
        mov bl, byte [regd1_b1]
        test bl, 2
        je short .14
        mov bh, bl
        or bh, 0FCh
        mov byte [regd1_b1], bh
.14:
        movsx edx, ax
        mov bx, word [regd1]
        mov word [nosplit edx*2+rpl_y], bx
        sar dword [regd0], 0Ah
        mov dx, word [regd0]
        and dh, 7
        mov word [regd1], dx
        cmp dx, 7FFh
        jne short .15
        mov word [regd1], 0FFFFh
.15:
        movsx edx, ax
        mov bx, word [regd1]
        mov word [nosplit edx*2+rpl_frame], bx
        test byte [regd1_m3], 8
        setne dl
        and edx, 0FFh
        mov bl, dl
        movsx edx, ax
        mov byte [dword edx+rpl_flip], bl
        inc eax
.16:
        cmp ax, 11h
        jl near ReplayStep.12
        xor eax, eax
        jmp short .18
.17:
        mov edx, dword [replayplay]
        movsx ebx, ax
        lea edi, [byte edx+01h]
        mov dword [replayplay], edi
        mov dl, byte [edx]
        mov byte [dword ebx+rpl_jersey], dl
        inc eax
.18:
        cmp ax, 0Ch
        jl short ReplayStep.17
        xor eax, eax
        jmp near .24
.19:
        mov edx, dword [replayplay]
        lea ebx, [byte edx+01h]
        mov dword [replayplay], ebx
        mov dl, byte [edx]
        mov byte [regd0], dl
        and dl, 0Fh
        mov byte [regd1], dl
        cmp dl, 0Fh
        jne short .20
        mov edx, 0FFFFFFFFh
        jmp short .21
.20:
        mov edx, dword [regd1-3]
        sar edx, 18h
.21:
        mov bl, dl
        movsx edx, ax
        mov byte [nosplit edx*2+rpl_pos], bl
        mov edx, dword [regd0_m3]
        sar edx, 1Ch
        and edx, byte 0Fh
        mov byte [regd1], dl
        cmp dl, 0Fh
        jne short .22
        mov edx, 0FFFFFFFFh
        jmp short .23
.22:
        mov edx, dword [regd1-3]
        sar edx, 18h
.23:
        mov bl, dl
        movsx edx, ax
        mov byte [nosplit edx*2+rpl_pos_b1], bl
        inc eax
.24:
        cmp ax, 6
        jl short ReplayStep.19
        mov eax, dword [replayplay]
        lea edx, [byte eax+01h]
        mov dword [replayplay], edx
        movsx ax, byte [eax]
        mov word [rpl_puckz], ax
        mov eax, edx
        inc edx
        mov dword [replayplay], edx
        movsx ax, byte [eax]
        mov word [rpl_puckunused], ax
        lea edi, [byte edx+02h]
        mov dword [replayplay], edi
        lea edx, [byte edi+01h]
        mov dword [replayplay], edx
        mov al, byte [edi]
        mov byte [regd0], al
        and al, 0Fh
        mov byte [regd1], al
        cmp al, 0Fh
        jne short .25
        mov eax, 0FFFFFFFFh
        jmp short .26
.25:
        mov eax, dword [regd1-3]
        sar eax, 18h
.26:
        mov byte [rpl_c1player], al
        mov eax, dword [regd0_m3]
        sar eax, 1Ch
        and eax, byte 0Fh
        mov byte [regd1], al
        cmp al, 0Fh
        jne short .27
        mov eax, 0FFFFFFFFh
        jmp short .28
.27:
        mov eax, dword [regd1-3]
        sar eax, 18h
.28:
        mov byte [rpl_c2player], al
        mov eax, dword [replayplay]
        lea edx, [byte eax+01h]
        mov dword [replayplay], edx
        mov al, byte [eax]
        mov byte [rpl_puckc], al
        mov eax, edx
        inc edx
        mov dword [replayplay], edx
        mov al, byte [eax]
        mov byte [regd0], al
        and al, 0Fh
        mov byte [rpl_pbnum], al
        mov eax, dword [regd0_m3]
        sar eax, 1Ch
        and eax, byte 0Fh
        mov byte [rpl_pbnum_b1], al
        mov eax, edx
        inc edx
        mov dword [replayplay], edx
        movsx ax, byte [eax]
        mov word [rpl_camx], ax
        mov word [camx], ax
        mov eax, edx
        mov dx, word [edx]
        mov word [rpl_camy], dx
        mov word [camy], dx
        add eax, byte 2
        mov dword [replayplay], eax
        mov edx, eax
        mov ax, word [eax]
        mov word [crowdlevel], ax
        xor eax, eax
        add edx, byte 2
        mov dword [replayplay], edx
        jmp short .30
.29:
        mov edx, dword [replayplay]
        lea ebx, [byte edx+01h]
        mov dword [replayplay], ebx
        mov dl, byte [edx]
        mov byte [regd0], dl
        xor edx, edx
        mov dl, byte [regd0]
        sar edx, 4
        mov bl, dl
        movsx edx, ax
        mov byte [nosplit edx*2+rpl_objstep], bl
        mov bl, byte [regd0]
        and bl, 0Fh
        mov byte [nosplit edx*2+rpl_objstep_b1], bl
        inc eax
.30:
        cmp ax, 0Ah
        jl short ReplayStep.29
        xor eax, eax
        jmp short .33
.31:
        mov edx, dword [replayplay]
        lea ebx, [byte edx+01h]
        mov dword [replayplay], ebx
        mov dl, byte [edx]
        xor dh, dh
        mov word [regd0], dx
        cmp dx, 0FFh
        jne short .32
        mov word [regd0], 0FFFFh
.32:
        movsx edx, ax
        mov bx, word [regd0]
        mov word [nosplit edx*2+rpl_objframe], bx
        inc eax
.33:
        cmp ax, 14h
        jl short ReplayStep.31
        test cx, cx
        je short .34
        mov eax, dword [replayplay]
        cmp eax, dword [recbpr]
        je short .34
        mov eax, dword [byte esp+044h]
        add eax, eax
        cwde
        call Crowd_Noise
        jmp short .35
.34:
        call CrowdNoiseOff
.35:
        xor eax, eax
        sub dword [replayplay], 80h
        jmp short .37
.36:
        movsx ebx, ax
        mov ecx, dword [nosplit ebx*2+rpl_x_e16]
        sar ecx, 10h
        mov dword [esp+ebx*4], ecx
        mov dword [nosplit ebx*4+rpl_ysort], ebx
        inc eax
.37:
        cmp ax, 11h
        jl short ReplayStep.36
        push rpl_ysort
        lea eax, [byte esp+04h]
        push eax
        push byte 11h
        call SortIndices
        add esp, byte 0Ch
        mov eax, esi
        add esp, byte 48h
ReplayStep_popx:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; DrawRinkSideObjects                             67DCC  95 PC, low confidence
; Draws the side sprites (counts rpl_pbnum / rpl_pbnum_b1 at 17Eh,0B3h by
; camera position) and the 12h+ rink objects of rpl_objframe (rinkobjdefs
; frames, photoptrsf); used by the display and replay frame code
;-----------------------------------------------------------------------------
DrawRinkSideObjects:
        push dword 64h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 34h
        push eax
        push edx
        mov eax, dword [camx-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFF0h
        jle near .7
        cmp word [camy], byte 50h
        jge short .3
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF6Ch
        jle short .3
        xor esi, esi
        jmp short .2
.1:
        push byte 0
        mov eax, esi
        add eax, 3
        imul eax, byte 0FFFFFFF5h
        movsx ebx, ax
        xor ecx, ecx
        mov edx, 0B3h
        mov eax, 17Eh
        call DrawFrameSprite
        inc esi
.2:
        movsx ax, byte [rpl_pbnum]
        cmp si, ax
        jge short .3
        cmp si, byte 3
        jl short DrawRinkSideObjects.1
.3:
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB5h
        jle short .7
        cmp word [camy], 0B1h
        jge short .7
        mov eax, dword [rpl_pbnum_b1-3]
        sar eax, 18h
        dec eax
        cmp eax, byte 2
        jl short .4
        mov eax, 2
.4:
        mov esi, eax
        jmp short .6
.5:
        push byte 1
        mov eax, esi
        add eax, 3
        imul eax, byte 0Bh
        movsx ebx, ax
        xor ecx, ecx
        mov edx, 0B3h
        mov eax, 17Eh
        call DrawFrameSprite
        dec esi
.6:
        test si, si
        jge short DrawRinkSideObjects.5
.7:
        xor esi, esi
        jmp near .10
.8:
        movsx eax, si
        mov di, word [nosplit eax*2+rpl_objframe]
        test di, di
        jl short .9
        imul edi, byte 3
        movsx edx, di
        mov dx, word [nosplit edx*2+rinkobjdefs]
        mov word [byte ebp-0Ch], dx
        inc edi
        movsx edx, di
        mov dx, word [nosplit edx*2+rinkobjdefs]
        mov word [byte ebp-04h], dx
        inc edi
        movsx edx, di
        mov edx, dword [nosplit edx*2+rinkobjdefs_m2]
        sar edx, 10h
        mov eax, dword [dword eax+rpl_objstep-3]
        sar eax, 18h
        movsx ax, byte [dword edx+eax+rinkobjanim]
        mov word [byte ebp-08h], ax
        push byte 0
        push byte 0FFFFFFFFh
        cmp word [byte ebp-0Ch], 0C0h
        setg al
        xor ah, ah
        movsx ecx, ax
        mov ebx, dword [byte ebp-06h]
        sar ebx, 10h
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+photoptrsf]
        call DrawSprite
.9:
        inc esi
.10:
        cmp si, byte 12h
        jl near DrawRinkSideObjects.8
        mov esi, 13h
        jmp near .23
.11:
        movsx eax, si
        mov di, word [nosplit eax*2+rpl_objframe]
        test di, di
        jge short .12
        mov word [byte ebp-08h], 0FFFFh
        jmp short .13
.12:
        imul edi, byte 3
        movsx edx, di
        mov dx, word [nosplit edx*2+rinkobjdefs]
        mov word [byte ebp-0Ch], dx
        inc edi
        movsx edx, di
        mov dx, word [nosplit edx*2+rinkobjdefs]
        mov word [byte ebp-04h], dx
        inc edi
        movsx edx, di
        mov edx, dword [nosplit edx*2+rinkobjdefs_m2]
        sar edx, 10h
        mov eax, dword [dword eax+rpl_objstep-3]
        sar eax, 18h
        movsx ax, byte [dword edx+eax+rinkobjanim]
        mov word [byte ebp-08h], ax
.13:
        cmp word [byte ebp-08h], byte 64h
        jg short .14
        test di, di
        jge short .17
.14:
        push byte 0
        cmp si, byte 13h
        sete al
        xor ah, ah
        cwde
        push eax
        xor ecx, ecx
        cmp si, byte 12h
        jne short .15
        mov eax, 1A5h
        jmp short .16
.15:
        mov eax, 12Dh
.16:
        movsx ebx, ax
        mov eax, dword [RinkSideShape]
        mov edx, 4
        call DrawSprite
.17:
        cmp word [byte ebp-08h], byte 0
        jl short .18
        push byte 0
        cmp si, byte 13h
        sete al
        xor ah, ah
        cwde
        push eax
        mov ebx, dword [byte ebp-06h]
        sar ebx, 10h
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+photoptrsf]
        xor ecx, ecx
        call DrawSprite
.18:
        cmp si, byte 12h
        jne short .21
        push byte 0
        push byte 0FFFFFFFFh
        xor ecx, ecx
        cmp si, si
        jne short .19
        mov eax, 1A5h
        jmp short .20
.19:
        mov eax, 12Dh
.20:
        movsx ebx, ax
        mov eax, dword [RinkSideShapeFlipped]
        mov edx, 4
        call DrawSprite
        jmp short .22
.21:
        mov ax, word [rpl_frame_e15]
        mov word [byte ebp-08h], ax
        cmp ax, 362h
        jl short .22
        push byte 0
        mov ebx, dword [rpl_y_e15-2]
        sar ebx, 10h
        mov edx, dword [rpl_x_e15-2]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.22:
        dec esi
.23:
        cmp si, byte 12h
        jge near DrawRinkSideObjects.11
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF50h
        jge short .24
        mov ax, word [cliprect_y1]
        mov word [byte ebp-010h], ax
        push dword 244h
        mov edx, dword [cliprect_y0]
        push edx
        mov ebx, dword [DrawClipRight]
        push ebx
        mov ecx, dword [DrawClipLeft]
        push ecx
        call SetClipWindow
        add esp, byte 10h
.24:
        xor esi, esi
        jmp short .26
.25:
        movsx edx, si
        xor edi, edi
        mov dword [byte ebp+edx*4-028h], edi
        mov dword [byte ebp+edx*4-034h], edx
        inc esi
.26:
        cmp si, byte 3
        jl short DrawRinkSideObjects.25
        mov eax, dword [rpl_puckc-3]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFFh
        je short .27
        mov eax, dword [nosplit eax*2+rpl_x_e16]
        sar eax, 10h
        mov dword [byte ebp-020h], eax
.27:
        cmp byte [rpl_c1player], 0
        jl short .28
        mov eax, dword [rpl_c1player-3]
        sar eax, 18h
        mov eax, dword [nosplit eax*2+rpl_x_e16]
        sar eax, 10h
        mov dword [byte ebp-028h], eax
.28:
        cmp byte [rpl_c2player], 0
        jl short .29
        mov eax, dword [rpl_c2player-3]
        sar eax, 18h
        mov eax, dword [nosplit eax*2+rpl_x_e16]
        sar eax, 10h
        mov dword [byte ebp-024h], eax
.29:
        lea eax, [byte ebp-034h]
        push eax
        lea eax, [byte ebp-028h]
        push eax
        push byte 3
        call SortIndices
        add esp, byte 0Ch
        xor edi, edi
        jmp near .43
.30:
        movsx esi, di
        mov si, word [byte ebp+esi*4-034h]
        cmp si, byte 2
        jne short .31
        mov eax, dword [rpl_puckc-3]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFFh
        je near .42
        push byte 0
        mov ebx, dword [nosplit eax*2+rpl_x_e16]
        sar ebx, 10h
        mov edx, dword [nosplit eax*2+dressedskaters]
        sar edx, 10h
        mov eax, dword [markframes_e1]
        sar eax, 10h
        xor ecx, ecx
        jmp near .41
.31:
        test si, si
        je short .32
        mov al, byte [rpl_c2player]
        jmp short .33
.32:
        mov al, byte [rpl_c1player]
.33:
        cbw
        mov word [byte ebp-08h], ax
        test ax, ax
        jl near .42
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        add eax, eax
        mov edx, dword [dword eax+rpl_frame-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je near .42
        mov dx, word [dword eax+rpl_x]
        mov word [byte ebp-0Ch], dx
        mov ax, word [dword eax+rpl_y]
        mov word [byte ebp-04h], ax
        xor eax, eax
        mov word [byte ebp-08h], ax
        mov edx, dword [byte ebp-03Eh]
        sar edx, 10h
        lea eax, [dword edx+0A8h]
        mov ebx, 140h
        sub ebx, eax
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        cmp eax, ebx
        jge short .34
        mov eax, dword [byte ebp-03Ch]
        add eax, 0A8h
        mov edx, 140h
        sub edx, eax
        mov word [byte ebp-04h], dx
        mov word [byte ebp-08h], 1
        jmp short .35
.34:
        mov ebx, 140h
        sub ebx, edx
        cmp eax, ebx
        jl short .35
        mov eax, 140h
        sub eax, dword [byte ebp-03Ch]
        inc eax
        mov word [byte ebp-04h], ax
        mov word [byte ebp-08h], 2
.35:
        mov ebx, 0C0h
        sub ebx, dword [byte ebp-038h]
        mov eax, 140h
        sub eax, ebx
        mov ebx, eax
        cmp word [byte ebp-08h], byte 0
        je short .37
        mov eax, dword [byte ebp-03Ah]
        sar eax, 10h
        mov edx, 0C0h
        sub edx, eax
        mov ecx, 140h
        sub ecx, edx
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        sub ecx, byte 0Ch
        cmp edx, ecx
        jl short .36
        sub ebx, byte 0Dh
        mov word [byte ebp-0Ch], bx
        or byte [byte ebp-08h], 8
        jmp short .39
.36:
        sub eax, 0B4h
        cmp edx, eax
        jge short .39
        mov eax, dword [byte ebp-038h]
        db 081h,0E8h,0B4h,00h,00h,00h           ; insn: sub eax,0B4h
        mov word [byte ebp-0Ch], ax
        or byte [byte ebp-08h], 4
        jmp short .39
.37:
        mov eax, dword [byte ebp-03Ah]
        sar eax, 10h
        mov edx, 0C0h
        sub edx, eax
        mov ecx, 140h
        sub ecx, edx
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        cmp edx, ecx
        jl short .38
        dec ebx
        mov word [byte ebp-0Ch], bx
        mov word [byte ebp-08h], 8
        jmp short .39
.38:
        sub eax, 0C0h
        cmp edx, eax
        jge short .39
        mov eax, dword [byte ebp-038h]
        db 081h,0E8h,0C0h,00h,00h,00h           ; insn: sub eax,0C0h
        mov word [byte ebp-0Ch], ax
        mov word [byte ebp-08h], 4
.39:
        mov eax, dword [byte ebp-08h]
        test ax, ax
        je short .40
        push byte 0
        xor ah, ah
        and al, 8
        cwde
        mov dword [byte ebp-01Ch], eax
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        mov dword [byte ebp-018h], eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        mov dword [byte ebp-014h], eax
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        push eax
        call JoyButtonMap
        add esp, byte 4
        movsx edx, si
        shl edx, 4
        mov eax, dword [dword edx+eax*2+markframes_e1]
        sar eax, 10h
        mov ecx, dword [byte ebp-01Ch]
        mov ebx, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        jmp short .41
.40:
        push byte 0
        mov ebx, dword [byte ebp-06h]
        sar ebx, 10h
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        movsx eax, si
        mov eax, dword [nosplit eax*2+Pencntdwn2]
        sar eax, 10h
        xor ecx, ecx
.41:
        call DrawFrameSprite
.42:
        inc edi
.43:
        cmp di, byte 3
        jl near DrawRinkSideObjects.30
        mov esi, 0Fh
        mov ax, word [rpl_frame_e15]
        mov word [byte ebp-08h], ax
        cmp ax, 284h
        jl short .44
        cmp ax, 288h
        jg short .44
        push byte 0
        cmp word [rpl_x_e15], byte 0
        setl al
        xor ah, ah
        movsx ecx, ax
        movsx eax, si
        mov ebx, dword [nosplit eax*2+rpl_x_e16]
        sar ebx, 10h
        mov edx, dword [nosplit eax*2+dressedskaters]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        jmp short .47
.44:
        cmp word [byte ebp-08h], 189h
        jne short .45
        mov eax, dword [rpl_puckz-2]
        sar eax, 10h
        cmp eax, 0FFFFFF00h
        jle short .45
        cmp byte [rpl_puckc], 10h
        jne short .46
.45:
        movsx eax, si
        cmp word [nosplit eax*2+rpl_y], byte 0
        jl short .48
        mov ecx, dword [byte ebp-08h]
        cmp cx, 22Ah
        jl short .48
        cmp cx, 237h
        jg short .48
.46:
        push byte 0
        movsx eax, si
        mov ebx, dword [nosplit eax*2+rpl_x_e16]
        sar ebx, 10h
        mov edx, dword [nosplit eax*2+dressedskaters]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        xor ecx, ecx
.47:
        call DrawFrameSprite
.48:
        cmp byte [rpl_puckc], 10h
        je short .49
        cmp word [rpl_puckz], byte 0
        jl short .49
        push byte 0
        mov ebx, dword [rpl_y_e14-2]
        sar ebx, 10h
        mov edx, dword [rpl_puckz-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, ebx
        movsx ebx, ax
        mov edx, dword [rpl_x_e14-2]
        sar edx, 10h
        mov eax, dword [rpl_frame_e14-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.49:
        xor edi, edi
        jmp near .68
.50:
        movsx esi, di
        mov si, word [nosplit esi*4+rpl_ysort]
        cmp si, byte 0Fh
        je near .67
        cmp si, byte 0Eh
        jne near .54
        mov eax, dword [rpl_puckc-3]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFFh
        jne near .67
        cmp word [rpl_puckz], byte 0
        jle near .67
        movsx eax, si
        add eax, eax
        cmp word [dword eax+rpl_y], 0E8h
        jge near .67
        mov edx, dword [dword eax+rpl_y-2]
        sar edx, 10h
        cmp edx, 0FFFFFF18h
        jg short .53
        cmp edx, 0FFFFFF10h
        jl short .53
        cmp word [dword eax+rpl_x], byte 0
        jge short .51
        mov eax, dword [dword eax+rpl_x-2]
        sar eax, 10h
        neg eax
        jmp short .52
.51:
        mov eax, dword [dword eax+rpl_x-2]
        sar eax, 10h
.52:
        cmp eax, byte 14h
        jg short .53
        cmp word [rpl_puckz], byte 0Dh
        jl near .67
.53:
        push byte 0
        movsx ebx, si
        mov ecx, dword [nosplit ebx*2+rpl_x_e16]
        sar ecx, 10h
        mov edx, dword [rpl_puckz-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, ecx
        cwde
        mov edx, dword [nosplit ebx*2+dressedskaters]
        sar edx, 10h
        mov esi, dword [nosplit ebx*2+rpl_y_e16]
        sar esi, 10h
        xor ecx, ecx
        mov ebx, eax
        mov eax, esi
        jmp near .66
.54:
        cmp si, byte 0Ch
        jge short .55
        movsx eax, si
        cmp byte [dword eax+rpl_pos], 0
        jl near .67
.55:
        movsx eax, si
        mov eax, dword [nosplit eax*2+rpl_y_e16]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je near .60
        cmp si, byte 0Ch
        jge near .60
        mov eax, dword [rpl_puckc-3]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFFh
        je short .56
        movsx ax, byte [rpl_puckc]
        cmp si, ax
        je short .57
.56:
        movsx ax, byte [rpl_c1player]
        cmp si, ax
        je short .57
        movsx ax, byte [rpl_c2player]
        cmp si, ax
        je short .57
        movsx eax, si
        cmp eax, dword [ReplayHoverPlayer]
        je short .57
        cmp si, word [replayfollowpl]
        jne short .58
.57:
        movsx eax, si
        mov edx, dword [dword eax+rpl_pos-3]
        sar edx, 18h
        mov dword [byte ebp-014h], edx
        mov ebx, dword [dword eax+rpl_jersey-3]
        sar ebx, 18h
        mov edx, dword [nosplit eax*2+rpl_x_e16]
        sar edx, 10h
        mov eax, dword [nosplit eax*2+dressedskaters]
        sar eax, 10h
        mov ecx, dword [byte ebp-014h]
        jmp short .59
.58:
        cmp dword [shownumbers], byte 0
        je short .60
        mov ebx, dword [dword eax+rpl_jersey-3]
        sar ebx, 18h
        mov edx, dword [nosplit eax*2+rpl_x_e16]
        sar edx, 10h
        mov eax, dword [nosplit eax*2+dressedskaters]
        sar eax, 10h
        mov ecx, 0FFFFFFFFh
.59:
        call DrawSpriteNumber
.60:
        cmp si, byte 5
        setg al
        xor ah, ah
        cwde
        push eax
        movsx eax, si
        mov ecx, dword [dword eax+rpl_flip-3]
        sar ecx, 18h
        mov ebx, dword [nosplit eax*2+rpl_x_e16]
        sar ebx, 10h
        mov edx, dword [nosplit eax*2+dressedskaters]
        sar edx, 10h
        mov eax, dword [nosplit eax*2+rpl_y_e16]
        sar eax, 10h
        call DrawFrameSprite
        cmp si, byte 0Ch
        jne near .67
        cmp byte [rpl_puckc], 10h
        je near .67
        cmp word [rpl_x_e14], byte 0
        jge short .61
        mov eax, dword [rpl_x_e14-2]
        sar eax, 10h
        neg eax
        jmp short .62
.61:
        mov eax, dword [rpl_x_e14-2]
        sar eax, 10h
.62:
        cmp eax, byte 6
        jne short .63
        cmp word [rpl_y_e14], 0F0h
        je short .65
.63:
        movsx eax, si
        add eax, eax
        mov dx, word [rpl_y_e14]
        cmp dx, word [dword eax+rpl_y]
        jl short .67
        cmp word [rpl_puckz], byte 0Dh
        jl short .67
        mov eax, dword [dword eax+rpl_x-2]
        sar eax, 10h
        mov edx, dword [rpl_x_e14-2]
        sar edx, 10h
        sub edx, eax
        mov eax, edx
        test edx, edx
        jge short .64
        neg eax
.64:
        cmp eax, byte 15h
        jge short .67
.65:
        push byte 0
        mov edx, dword [rpl_puckz-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, dword [rpl_y_e14-2]
        sar edx, 10h
        add eax, edx
        movsx ebx, ax
        mov edx, dword [rpl_x_e14-2]
        sar edx, 10h
        mov eax, dword [rpl_frame_e14-2]
        sar eax, 10h
        xor ecx, ecx
.66:
        call DrawFrameSprite
.67:
        inc edi
.68:
        cmp di, byte 11h
        jl near DrawRinkSideObjects.50
        mov eax, dword [rpl_y_e14-2]
        sar eax, 10h
        cmp eax, 0FFFFFF18h
        jg near .71
        cmp eax, 0FFFFFF14h
        jl short .71
        cmp word [rpl_x_e14], byte 0
        jge short .69
        mov eax, dword [rpl_x_e14-2]
        sar eax, 10h
        neg eax
        jmp short .70
.69:
        mov eax, dword [rpl_x_e14-2]
        sar eax, 10h
.70:
        cmp eax, byte 14h
        jg short .71
        cmp word [rpl_puckz], byte 0Dh
        jl short .71
        push byte 0
        mov edx, dword [rpl_puckz-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, dword [rpl_y_e14-2]
        sar edx, 10h
        add eax, edx
        movsx ebx, ax
        mov edx, dword [rpl_x_e14-2]
        sar edx, 10h
        mov eax, dword [rpl_frame_e14-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.71:
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF50h
        jge short .72
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        mov esi, dword [cliprect_y0]
        push esi
        mov edi, dword [DrawClipRight]
        push edi
        mov eax, dword [DrawClipLeft]
        push eax
        call SetClipWindow
        add esp, byte 10h
.72:
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF70h
        jge short .73
        call DrawRinkEndArt
.73:
        cmp word [rpl_y_e15], byte 0
        jge short .74
        mov si, word [rpl_frame_e15]
        cmp si, 22Ah
        jl short .74
        cmp si, 237h
        jg short .74
        push byte 0
        mov ebx, dword [rpl_y_e15-2]
        sar ebx, 10h
        mov edx, dword [rpl_x_e15-2]
        sar edx, 10h
        mov eax, dword [rpl_frame_e15-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.74:
        mov ebx, dword [rpl_y_e14-2]
        sar ebx, 10h
        cmp ebx, 0FFFFFEF8h
        jge short .75
        mov eax, dword [rpl_puckc-3]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFFh
        jne short .75
        cmp word [rpl_puckz], byte 0
        jl short .75
        push byte 0
        mov edx, dword [rpl_puckz-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, ebx
        movsx ebx, ax
        mov edx, dword [rpl_x_e14-2]
        sar edx, 10h
        mov eax, dword [rpl_frame_e14-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.75:
        mov esp, ebp
        jmp near ReplayStep_popx
