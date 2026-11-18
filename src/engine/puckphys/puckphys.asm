; Puck physics: puck against bodies, sticks and goalies, shot modes, deflections, the shot.
bits 32
%include "hockey.inc"
%include "spa.inc"
section s_56D06 progbits alloc exec nowrite align=1
extern __CHK, a2touchpuck, assreplace, ChkShotStat, Crowdlevel, CwdExciteLvl, dopass_ret6, SpeechPatchNext
extern EndPenaltyShot, FallDown, GetHot, GiveControl, gmode, gmode2, iflags, imul32
extern lastplayer, onetimerflag, PassCompleted, passdir, PassLaneChk, PassLaneChk_ret5a, passplayer, passspeed
extern penshotlive, puckc, puckflip, puckvx, puckvy, puckvz, puckx, pucky
extern puckz, randomd0, regd0, regd0_m3, regd1, regd1_m3, regd2, SetSPA
extern sflags, sflags3, sfx, ShotLaneOpen, shotongoal, shotontarget, shotplayer, shotsets
extern shotsetz, SortCords, vecdist, vtoa
global puckbody, PuckIChk, puckshadow, puckglue, puckgoalie, puckstick, SetShotMode, ShotMode
global Findhittype, deflect, shotdiradj, doshot
;-----------------------------------------------------------------------------
; puckbody                         56D06  94G collide94.asm, medium confidence
; puckbody (puck hits player a2): a2touchpuck, GetHot, puckflip, sfx;
; called from checkpuckcoll
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/puckbody.c
%ifdef CBUILD
%include "c/engine/puckphys/puckbody.inc"
%else
puckbody:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, eax
        mov ecx, edx
        mov dx, word [byte eax+012h]
        cmp dx, 430h
        jl short .1
        cmp dx, 467h
        jg short .1
        cmp dx, 44Fh
        jg short .2
        test byte [byte eax+012h], 1
        je short .2
        cmp word [byte ebx+0Ah], byte 8
        jg near .x
        jmp short .2
.1:
        cmp word [byte ebx+0Ah], byte 8
        jg short .2
        mov ax, word [regd0]
        xor ah, ah
        and al, 0Fh
        mov word [regd1], ax
        test ax, ax
        jne near .x
.2:
        cmp word [byte ecx+SCnum], byte 10h
        je short .3
        mov eax, ecx
        call a2touchpuck
.3:
        mov word [byte ebx+010h], 0
        mov word [byte ecx+03Eh], 8
        mov ax, word [byte ebx+02h]
        mov dx, word [byte ecx+Xpos+2]
        sub eax, edx
        mov word [regd0], ax
        mov ax, word [byte ebx+06h]
        mov si, word [byte ecx+Ypos+2]
        sub ax, si
        mov word [regd1], ax
        jne short .4
        mov eax, ecx
        call GetHot
.4:
        mov dx, word [byte ebx+0Ch]
        mov di, word [byte ebx+0Eh]
        mov al, byte [regd0]
        mov byte [byte ebx+0Dh], al
        mov al, byte [regd1]
        mov byte [byte ebx+0Fh], al
        mov eax, ebx
        call puckflip
        cmp word [byte ebx+0Ah], byte 8
        jg short .5
        cmp word [byte ecx+SPA], SPAcatch
        je near .x
        mov eax, 0A3h
        call sfx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.5:
        mov esi, 0A3h
        movsx eax, dx
        mov edx, eax
        imul edx, eax
        movsx eax, di
        imul eax, eax
        add eax, edx
        cmp eax, 895440h
        jle short .6
        cmp word [byte ebx+0Ah], byte 0Ch
        jle short .6
        mov esi, 0A2h
        mov edx, ecx
        mov eax, ebx
        call FallDown
.6:
        cmp word [byte ecx+SPA], SPAcatch
        je short .7
        movsx eax, si
        call sfx
.7:
        mov dl, byte [byte ecx+pflags]
        test dl, 20h
        jne short .x
        cmp word [byte ecx+SCnum], byte 10h
        je short .x
        mov dh, dl
        or dh, 20h
        mov byte [byte ecx+pflags], dh
        mov edx, SPAcatch
        mov eax, ecx
        call SetSPA
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PuckIChk                                              56E52  94G logic94.asm
; (icing). iflags bit 2 ifok, bit 0 ifcgl, bit 1 ifdir; loose puck past the goal
; line: |puckx| > 2Ch sets ifcgl (icing), else clears ifok.
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/PuckIChk.c
%ifdef CBUILD
%include "c/engine/puckphys/PuckIChk.inc"
%else
PuckIChk:
        push dword 8
        call __CHK
        push ebx
        mov ah, byte [iflags]
        test ah, 4
        je near .x
        test ah, 1
        jne short .x
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge short .x
        test byte [iflags], 2
        jne short .1
        mov eax, dword [pucky]
        movsx eax, word [eax]
        cmp eax, 0FFFFFF18h
        jge short .x
        jmp short .2
.1:
        mov eax, dword [pucky]
        cmp word [eax], 0E8h
        jl short .x
.2:
        mov eax, dword [puckx]
        mov bx, word [eax]
        test bx, bx
        jge short .3
        movsx eax, bx
        neg eax
        jmp short .4
.3:
        movsx eax, bx
.4:
        cmp eax, byte 2Ch
        jg short .5
        and byte [iflags], 0FBh
        pop ebx
        ret
.5:
        or byte [iflags], 1
.x:
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckshadow                         56ECF  94G logic94.asm, medium confidence
; Assignment table slot 19h: the puck shadow object
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/puckshadow.c
%ifdef CBUILD
%include "c/engine/puckphys/puckshadow.inc"
%else
puckshadow:
        push dword 8
        call __CHK
        push edx
        cmp word [byte eax+012h], 189h
        jne short .2
        mov edx, dword [puckx]
        mov dx, word [edx]
        mov word [byte eax+Xpos+2], dx
        mov edx, dword [pucky]
        mov dx, word [edx]
        mov word [byte eax+Ypos+2], dx
        mov word [byte eax+0Ah], 0
        test byte [sflags], 80h
        je short .1
        inc word [byte eax+Xpos+2]
        pop edx
        ret
.1:
        inc word [byte eax+Ypos+2]
        pop edx
        ret
.2:
        mov edx, dword [byte eax+010h]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je short .x
        cmp word [byte eax+SPA], SPAsiren
        jne short .x
        mov word [byte eax+Xpos+2], 0
        mov word [byte eax+Ypos+2], 122h
        mov word [byte eax+0Ah], 0Eh
        mov edx, dword [pucky]
        cmp word [edx], byte 0
        jge short .x
        mov word [byte eax+054h], 8000h
        mov word [byte eax+Ypos+2], 0FEF6h
        dec word [byte eax+0Ah]
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckglue                         56F5A  94G collide94.asm, medium confidence
; (92 puckstick.glue): player p takes the puck. puckc gets his SCnum a live
; penalty shot ends when his team's tmpsplayer takes it. The other team's
;
; assist slots are cleared and its tmflags bit 3 set. After a faceoff
; (sflags3 bit 4) count a faceoff won (and one won in the attacking end),
; raise Crowdlevel by 200 (max 1000) and the home crowd's CwdExciteLvl by 10;
;
; otherwise play sfx 9Bh . Then the pass completion, clear the pass/shot dir
; modes (sflags bits 2-3); a goalie checks the shot stat and gets temp5 hold
; time (5 after SPA 181h, else 8Ch). Falls into setd0player:
;
; GiveControl(regd0). The attacking-end count is two increments (if / else
; if): one `||` test moved the registers of the Crowdlevel clamp after it.
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/puckglue.c
%ifdef CBUILD
%include "c/engine/puckphys/puckglue.inc"
%else
puckglue:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov edx, eax
        mov ax, word [byte eax+06Ah]
        mov word [regd0], ax
        mov bl, byte [regd0]
        mov eax, dword [puckc]
        mov byte [eax], bl
        mov ebx, dword [byte edx+tmptr]
        mov ecx, dword [byte edx+optmptr]
        cmp dword [penshotlive], byte 0
        je short .1
        movsx ax, byte [byte edx+pnum]
        cmp ax, word [byte ebx+030h]
        jne short .1
        call EndPenaltyShot
        xor edi, edi
        mov dword [onetimerflag], edi
        mov dword [shotongoal], edi
.1:
        mov byte [byte ecx+033h], 0FFh
        mov byte [byte ecx+035h], 0FFh
        or byte [byte ecx+044h], 8
        mov cl, byte [sflags3]
        test cl, 10h
        je near .6
        mov ch, cl
        and ch, 0EFh
        mov byte [sflags3], ch
        test byte [gmode], 10h
        jne short .4
        inc word [byte ebx+012h]
        mov eax, dword [pucky]
        cmp word [eax], byte 4Eh
        jle short .2
        test byte [byte edx+pflags], 80h
        jne short .3
.2:
        mov ecx, dword [pucky]
        movsx eax, word [ecx]
        cmp eax, byte 0FFFFFFB2h
        jge short .4
        test byte [byte edx+pflags], 80h
        jne short .4
.3:
        inc word [byte ebx+014h]
.4:
        mov ax, word [Crowdlevel]
        cmp ax, 3E8h
        jg short .5
        mov ebx, eax
        add ebx, 0C8h
        mov word [Crowdlevel], bx
        cmp bx, 3E8h
        jle short .5
        mov word [Crowdlevel], 3E8h
.5:
        test byte [byte edx+pflags], 40h
        jne short .7
        add word [CwdExciteLvl], byte 0Ah
        jmp short .7
.6:
        mov eax, 9Bh
        call sfx
.7:
        mov eax, edx
        call PassCompleted
        and byte [sflags], 0F3h
        cmp word [byte edx+position], byte 0
        jne short .9
        call ChkShotStat
        call EndPenaltyShot
        cmp word [byte edx+SPA], SPAgdive
        jne short .8
        mov word [byte edx+temp5], 5
        jmp short .9
.8:
        mov word [byte edx+temp5], 8Ch
.9:
        mov eax, dword [regd0-2]
        sar eax, 10h
        call GiveControl
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckgoalie                       57096  94G collide94.asm, medium confidence
; puckgoalie: the puck pk hits goalie p (regd0 /
; regd1 = the gap from checkpuckcoll_ccx). Nothing during a stoppage (gmode
;
; bit 4) or while p's frame is 206h-215h with the puck at height 5 or more.
; regd2 = the save side: 2 for a low puck (Zpos <= 8), plus 1 unless the
; direction of the hit relative to facedir has bit 2 (a random direction when
;
; it is a multiple of 4), doubled, flipped by 2 with attribute bit 3. A hard
; shot (|vx| + |vy| above 4268h, or above 1770h during SPA 119Dh-121Dh) from
; the other team's shooter (shotplayer) from more than 58h out at the right
;
; end, with gmode2 bit 4 and no pflags bit 6, is a big save (byte +63h). Then
; ChkShotStat, a2touchpuck and the save sounds (7Dh / A1h for a fast puck
; while the clock runs, 9Dh or A3h). A loose puck slow enough for his shotspd
;
; (random below ((shotspd * 5 / 4 + 2) << 9) + 2000h) is caught (puck stopped
; and dropped to height 8, its velocity quartered, puckglue) unless pflags2
; bit 2 is set; a carried puck is knocked loose (its carrier gets nopuck 14h,
;
; lastplayer, the pass / shot dir modes cleared). Otherwise the puck
; rebounds: height at most 0Ah, p's nopuck 0Ah and temp4 4, the velocity high
; bytes from half the gap (GetHot when the y gap is 0; the y gap at least 1
;
; and against p's Yvel), puckflip. No result.
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/puckgoalie.c
%ifdef CBUILD
%include "c/engine/puckphys/puckgoalie.inc"
%else
puckgoalie:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov ecx, eax
        mov ebx, edx
        xor edx, edx
        mov word [esp], dx
        test byte [gmode], 10h
        jne near .x
        mov word [regd2], dx
        cmp word [byte ecx+0Ah], byte 8
        jg short .1
        mov word [regd2], 2
.1:
        mov ax, word [regd1]
        neg eax
        movsx edx, ax
        mov ax, word [regd0]
        neg eax
        cwde
        call vtoa
        sub ax, word [byte ebx+facedir]
        xor ah, ah
        and al, 7
        mov word [regd0], ax
        test byte [regd0], 3
        jne short .2
        mov eax, 100h
        call randomd0
        mov word [regd0], ax
.2:
        mov ax, word [regd0]
        xor ah, ah
        and al, 4
        cwde
        sar eax, 2
        xor al, 1
        mov edx, eax
        mov eax, dword [regd2-2]
        sar eax, 10h
        add eax, edx
        mov word [regd2], ax
        mov esi, eax
        add esi, eax
        mov word [regd2], si
        test byte [byte ebx+055h], 8
        je short .3
        xor byte [regd2], 2
.3:
        mov ax, word [byte ebx+012h]
        cmp ax, 206h
        jl short .4
        cmp ax, 216h
        jge short .4
        mov eax, dword [puckz]
        cmp word [eax], byte 5
        jge near .x
.4:
        mov byte [byte ebx+063h], 0
        cmp word [SpeechPatchNext], byte 0
        jne near .12
        test byte [byte ebx+pflags], 40h
        jne near .12
        test byte [gmode2], 10h
        je near .12
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        cmp word [shotplayer], byte 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je near .12
        mov eax, dword [shotplayer-2]
        sar eax, 10h
        shl eax, 7
        cmp word [dword eax+SortCords+6], byte 0
        jge short .5
        mov eax, dword [dword eax+SortCords+4]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [dword eax+SortCords+4]
        sar eax, 10h
.6:
        cmp eax, byte 58h
        jle near .12
        mov eax, dword [shotplayer-2]
        sar eax, 10h
        shl eax, 7
        cmp word [dword eax+SortCords+6], byte 0
        setg al
        and eax, 0FFh
        test byte [byte ebx+pflags], 80h
        setne dl
        and edx, 0FFh
        xor eax, edx
        je short .12
        mov eax, dword [puckvy]
        mov si, word [eax]
        test si, si
        jge short .7
        movsx edx, si
        neg edx
        jmp short .8
.7:
        movsx edx, si
.8:
        mov eax, dword [puckvx]
        mov di, word [eax]
        test di, di
        jge short .9
        movsx eax, di
        neg eax
        jmp short .10
.9:
        movsx eax, di
.10:
        add eax, edx
        cmp ax, 4268h
        jg short .11
        cmp ax, 1770h
        jle short .12
        mov ax, word [byte ebx+SPA]
        cmp ax, SPAgofallback
        jl short .12
        cmp ax, SPAgofallstick
        jg short .12
.11:
        mov word [esp], 1
.12:
        call ChkShotStat
        mov eax, ebx
        call a2touchpuck
        test byte [gmode], 1
        jne short .17
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .13
        movsx eax, di
        neg eax
        jmp short .14
.13:
        movsx eax, di
.14:
        cmp eax, 0FA0h
        jle short .17
        test byte [byte ebx+pflags], 40h
        jne short .15
        mov eax, 7Dh
        jmp short .16
.15:
        mov eax, 0A1h
.16:
        call sfx
.17:
        mov eax, dword [puckvy]
        mov dx, word [eax]
        test dx, dx
        jge short .18
        movsx eax, dx
        neg eax
        jmp short .19
.18:
        movsx eax, dx
.19:
        cmp eax, 0BB8h
        jle short .20
        mov eax, 9Dh
        jmp short .21
.20:
        mov eax, 0A3h
.21:
        call sfx
        mov eax, dword [puckc]
        mov dl, byte [eax]
        test dl, dl
        jge near .27
        xor edx, edx
        mov dl, byte [byte ebx+05Bh]
        mov eax, edx
        shl eax, 2
        add edx, eax
        mov eax, edx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        add eax, byte 2
        shl eax, 9
        cwde
        call randomd0
        add ah, 20h
        mov word [regd0], ax
        mov eax, dword [puckvx]
        mov si, word [eax]
        test si, si
        jge short .22
        movsx eax, si
        neg eax
        jmp short .23
.22:
        movsx eax, si
.23:
        mov edx, dword [regd0-2]
        sar edx, 10h
        cmp eax, edx
        jg near .28
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .24
        movsx eax, di
        neg eax
        jmp short .25
.24:
        movsx eax, di
.25:
        mov edx, dword [regd0-2]
        sar edx, 10h
        cmp eax, edx
        jg short .28
        test byte [byte ebx+pflags2], 4
        jne short .28
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        cmp word [eax], byte 8
        jle short .26
        mov word [eax], 8
.26:
        mov eax, dword [puckvx]
        sar word [eax], 2
        mov eax, dword [puckvy]
        sar word [eax], 2
        mov eax, ebx
        call puckglue
        mov al, byte [esp]
        mov byte [byte ebx+063h], al
        jmp near .x
.27:
        movsx edx, dl
        shl edx, 7
        add edx, SortCords
        mov byte [eax], 0FFh
        mov word [byte edx+03Eh], 14h
        mov ax, word [byte edx+06Ah]
        mov word [lastplayer], ax
        and byte [sflags], 0F3h
.28:
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        cmp word [eax], byte 0Ah
        jle short .29
        mov word [eax], 0Ah
.29:
        mov word [byte ebx+03Eh], 0Ah
        mov word [byte ebx+temp4], 4
        mov ax, word [byte ecx+02h]
        mov si, word [byte ebx+Xpos+2]
        sub eax, esi
        mov word [regd0], ax
        mov ax, word [byte ecx+06h]
        mov di, word [byte ebx+Ypos+2]
        sub ax, di
        mov word [regd1], ax
        jne short .30
        mov eax, ebx
        call GetHot
.30:
        cmp word [regd1], byte 0
        jne short .31
        mov esi, 1
        mov word [regd1], si
.31:
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        xor eax, edx
        test eax, eax
        jl short .32
        neg word [regd1]
.32:
        mov eax, dword [regd0_m3]
        sar eax, 19h
        mov byte [byte ecx+0Dh], al
        mov eax, dword [regd1_m3]
        sar eax, 19h
        mov byte [byte ecx+0Fh], al
        mov eax, ecx
        call puckflip
.x:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckstick                        57483  94G collide94.asm, medium confidence
; puckstick: the puck touches player p's stick (regd0 = the squared distance
; from checkpuckcoll_ccx).
;
; A goalie does nothing during a highlight (gmode bit 4); otherwise his save
; flag (byte 63h) is cleared and set again when the puck comes from a shot of
; the other team's shotplayer from beyond 58h, from the far side
;
; (by pflags bit 7) and fast (|vy| over 2EE0h, or over 1770h with SPA
; 119Dh-121Dh), then ChkShotStat. Then pflags bit 0 is cleared.
;
; With a carrier (puckc) on the other team, in range (regd0 up to 24h) and p
; not in SPA 13C5h-14ADh: a skater steals only from a skater and on
; randomd0(carrier pde + 20h - p's pde, an eighth more against a carrier
;
; with pflags bit 3 and p without) up to 2, a goalie always; both get nopuck
; pde + 14h, lastplayer = the carrier, sflags bits 2-3 cleared, and the stick
; deflect.
;
; Without a carrier (a goalie only within 40h): regd0 = puck speed squared,
; regd1 = (13000 + 700 * stickhand, no stickhand bonus with gmode2 bit 4)
; squared; outside SPA 13C5h-14ADh p catches the puck when it is slow enough,
;
; or as the pass receiver (passplayer) on randomd0(2): vz cleared, puckglue,
; and a goalie keeps it below z 8 with vx vy quartered and his save flag set.
; Else nopuck 8 and the stick deflect: sfx 99h, a2touchpuck, deflect(puck).
;-----------------------------------------------------------------------------
; C: src/engine/pass/PassLaneChk.c (puckstick)
%ifdef CBUILD
%include "c/engine/pass/PassLaneChk.puckstick.inc"
%else
puckstick:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, eax
        mov esi, edx
        xor edx, edx
        cmp word [byte esi+position], byte 0
        jne near .9
        test byte [gmode], 10h
        jne near PassLaneChk_ret5a
        mov byte [byte esi+063h], 0
        cmp word [SpeechPatchNext], byte 0
        jne near .8
        test byte [byte esi+pflags], 40h
        jne near .8
        test byte [gmode2], 10h
        je near .8
        cmp word [byte esi+SCnum], byte 6
        setl al
        mov ebx, eax
        and ebx, 0FFh
        cmp word [shotplayer], byte 6
        setl al
        and eax, 0FFh
        xor eax, ebx
        je near .8
        mov edi, dword [shotplayer-2]
        sar edi, 10h
        shl edi, 7
        cmp word [dword edi+SortCords+6], byte 0
        jge short .1
        mov eax, dword [dword edi+SortCords+4]
        sar eax, 10h
        neg eax
        jmp short .2
.1:
        mov eax, dword [dword edi+SortCords+4]
        sar eax, 10h
.2:
        cmp eax, byte 58h
        jle near .8
        mov eax, dword [shotplayer-2]
        sar eax, 10h
        shl eax, 7
        cmp word [dword eax+SortCords+6], byte 0
        setg al
        mov ebx, eax
        and ebx, 0FFh
        test byte [byte esi+pflags], 80h
        setne al
        and eax, 0FFh
        xor eax, ebx
        je short .8
        mov edi, dword [puckvy]
        mov cx, word [edi]
        test cx, cx
        jge short .3
        movsx eax, cx
        neg eax
        jmp short .4
.3:
        movsx eax, cx
.4:
        cmp eax, 2EE0h
        jg short .7
        mov edi, dword [puckvy]
        mov ax, word [edi]
        test ax, ax
        jge short .5
        cwde
        neg eax
        jmp short .6
.5:
        cwde
.6:
        cmp eax, 1770h
        jle short .8
        mov bx, word [byte esi+SPA]
        cmp bx, SPAgofallback
        jl short .8
        cmp bx, SPAgofallstick
        jg short .8
.7:
        mov edx, 1
.8:
        call ChkShotStat
.9:
        and byte [byte esi+pflags], 0FEh
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl near .13
        mov di, word [byte esi+SPA]
        cmp di, SPAblockleft
        jl short .10
        cmp di, SPAblockknee
        jle near PassLaneChk_ret5a
.10:
        mov edx, dword [puckc]
        movsx eax, byte [edx]
        shl eax, 7
        mov edi, SortCords
        add edi, eax
        xor eax, eax
        mov al, byte [byte esi+pflags]
        xor edx, edx
        mov dl, byte [byte edi+pflags]
        xor eax, edx
        test al, 40h
        je near PassLaneChk_ret5a
        cmp dword [regd0], byte 24h
        ja near PassLaneChk_ret5a
        cmp word [byte esi+position], byte 0
        je near .12
        cmp word [byte edi+position], byte 0
        je near PassLaneChk_ret5a
        xor eax, eax
        mov al, byte [byte edi+060h]
        push eax
        mov edx, dword [byte edi+044h]
        sar edx, 18h
        add edx, edx
        mov eax, dword [byte edi+tmptr]
        mov eax, dword [byte edx+eax+044h]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        cwde
        mov dword [esp], eax
        xor eax, eax
        mov al, byte [byte esi+060h]
        push eax
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov edx, dword [byte esi+06Ch]
        mov eax, dword [byte edx+eax*2+tmpde-2]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        movsx edx, ax
        mov eax, dword [esp]
        add eax, byte 20h
        sub eax, edx
        mov word [regd0], ax
        test byte [byte edi+pflags], 8
        je short .11
        test byte [byte esi+pflags], 8
        jne short .11
        mov ebx, dword [regd0-2]
        sar ebx, 10h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        shl edx, 3
        LD sbb, eax, edx
        sar eax, 3
        add eax, ebx
        mov word [regd0], ax
.11:
        mov eax, dword [regd0-2]
        sar eax, 10h
        call randomd0
        cmp ax, 2
        jg near PassLaneChk_ret5a
.12:
        xor eax, eax
        mov al, byte [byte edi+060h]
        push eax
        mov eax, dword [byte edi+044h]
        sar eax, 18h
        mov edx, dword [byte edi+tmptr]
        mov eax, dword [byte edx+eax*2+tmpde-2]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        cwde
        add eax, byte 14h
        mov word [byte edi+03Eh], ax
        xor eax, eax
        mov al, byte [byte esi+060h]
        push eax
        mov edx, dword [byte esi+044h]
        sar edx, 18h
        add edx, edx
        mov eax, dword [byte esi+06Ch]
        mov eax, dword [byte edx+eax+044h]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        cwde
        add eax, byte 14h
        mov word [byte esi+03Eh], ax
        mov ax, word [byte edi+SCnum]
        mov word [lastplayer], ax
        and byte [sflags], 0F3h
        jmp near .20
.13:
        cmp word [byte esi+position], byte 0
        jne short .14
        cmp dword [regd0], byte 40h
        ja near PassLaneChk_ret5a
.14:
        mov eax, dword [puckvx]
        mov ax, word [eax]
        mov word [regd0], ax
        mov eax, dword [puckvy]
        mov ax, word [eax]
        mov word [regd1], ax
        mov ebx, dword [regd0-2]
        sar ebx, 10h
        imul ebx, ebx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add ebx, eax
        mov dword [regd0], ebx
        xor eax, eax
        mov word [regd1], ax
        test byte [gmode2], 10h
        jne short .15
        mov al, byte [byte esi+060h]
        imul eax, dword 2BCh
        mov word [regd1], ax
.15:
        add word [regd1], 32C8h
        mov ebx, dword [regd1-2]
        sar ebx, 10h
        imul ebx, ebx
        mov dword [regd1], ebx
        mov cx, word [byte esi+SPA]
        cmp cx, SPAblockleft
        jl short .16
        cmp cx, SPAblockknee
        jle near .19
.16:
        mov eax, dword [regd0]
        cmp eax, dword [regd1]
        jbe short .17
        mov ax, word [byte esi+SCnum]
        cmp ax, word [passplayer]
        jne short .19
        mov eax, 2
        call randomd0
        test ax, ax
        je short .19
.17:
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, esi
        call puckglue
        cmp word [byte esi+position], byte 0
        jne near PassLaneChk_ret5a
        mov ebx, dword [puckz]
        cmp word [ebx], byte 8
        jle short .18
        mov word [ebx], 8
.18:
        mov ebx, dword [puckvx]
        sar word [ebx], 2
        mov ebx, dword [puckvy]
        sar word [ebx], 2
        mov byte [byte esi+063h], dl
        jmp near PassLaneChk_ret5a
.19:
        mov word [byte esi+03Eh], 8
.20:
        mov eax, SPAgready2
        call sfx
        mov eax, esi
        call a2touchpuck
        mov eax, ebp
        call deflect
        jmp near PassLaneChk_ret5a
%endif ; C
;-----------------------------------------------------------------------------
; SetShotMode                        5786E  94G logic94.asm, medium confidence
; P winds up a shot: pass direction 8 (shot), sflags bit 3; regd0 = direction
; from p to the attacked goal (x 0, y +/-F0h by pflags bit 7), passspeed = 15,
;
; then the slap (SPA 491h, when Findhittype finds a hit type) or wrist shot
; animation (3F9h).
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/SetShotMode.c
%ifdef CBUILD
%include "c/engine/puckphys/SetShotMode.inc"
%else
SetShotMode:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov word [passdir], 8
        or byte [sflags], 8
        xor ecx, ecx
        mov word [regd0], cx
        test byte [byte ebx+pflags], 80h
        jne short .1
        mov eax, 0FFFFFF10h
        jmp short .2
.1:
        mov eax, 0F0h
.2:
        mov word [regd1], ax
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [regd0]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov word [regd0], ax
        mov word [passspeed], 0Fh
        movsx edx, ax
        mov eax, ebx
        call Findhittype
        test ax, ax
        je short .3
        mov edx, SPAshotb
        jmp short .4
.3:
        mov edx, SPAshotf
.4:
        mov eax, ebx
        call SetSPA
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShotMode                           578FA  94G logic94.asm, medium confidence
; Shot wind-up of p (frame counter SPAnum): from frame 14 shoot (doshot).
; Without regd0 bit 3 the aim direction (regd0 & 7) becomes passdir. Before
;
; frame 10 a release (regd1 bit 4 or 6) ends the wind-up: clear sflags bit 3,
; flag 20h, and switch the slap SPAs 3F9h/491h/DD3h/E2Bh to their
; follow-through 1265h/12DDh/ 1355h/138Dh. Otherwise before frame 8 count
;
; passspeed and jump to the mirrored frame (14 - SPAnum) for a weak shooter
; (shotspd < 10) past frame 4 or when regd2 bit 5 is set.
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/ShotMode.c
%ifdef CBUILD
%include "c/engine/puckphys/ShotMode.inc"
%else
ShotMode:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        cmp word [byte eax+03Ah], byte 0Eh
        jl short .1
        call doshot
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        test byte [regd0], 8
        jne short .2
        mov cx, word [regd0]
        xor ch, ch
        and cl, 7
        mov word [regd0], cx
        mov word [passdir], cx
.2:
        mov si, word [byte edx+SPAnum]
        cmp si, byte 0Ah
        jge near .x
        mov bl, byte [regd1]
        test bl, 10h
        jne short .3
        test bl, 40h
        je short .8
.3:
        and byte [sflags], 0F7h
        or byte [byte edx+pflags], 20h
        mov ax, word [byte edx+SPA]
        cmp ax, SPAshotb
        jb short .4
        jbe short .5
        cmp ax, SPAonetimef
        jb near .x
        jbe short .6
        cmp ax, SPAonetimeb
        je short .7
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cmp ax, SPAshotf
        jne short .x
        mov word [byte edx+SPA], SPAfakeshotf
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.5:
        mov word [byte edx+SPA], SPAfakeshotb
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.6:
        mov word [byte edx+SPA], SPAfakeonetimef
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov word [byte edx+SPA], SPAfakeonetimeb
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        cmp si, byte 8
        jge short .x
        inc word [passspeed]
        cmp byte [byte edx+05Bh], 0Ah
        jae short .9
        mov bx, word [byte edx+SPAnum]
        cmp bx, byte 4
        jle short .9
        mov eax, 0Eh
        sub eax, ebx
        jmp short .10
.9:
        test byte [regd2], 20h
        je short .x
        mov eax, 0Eh
        mov cx, word [byte edx+SPAnum]
        sub eax, ecx
.10:
        mov word [byte edx+SPAnum], ax
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Findhittype                        579FF  94G logic94.asm, medium confidence
; Type of swing for player p shooting in direction dir. d = (facedir - dir) &
; 7; returns 1 (backhand) when bit d of F0h (sprite X-flipped,
;
; attribute bit 3) or of 1Eh (not flipped) is set, else 0 (forehand).
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/Findhittype.c
%ifdef CBUILD
%include "c/engine/puckphys/Findhittype.inc"
%else
Findhittype:
        push dword 8
        call __CHK
        push ecx
        mov cx, word [byte eax+036h]
        sub ecx, edx
        mov edx, ecx
        xor dh, ch
        and dl, 7
        test byte [byte eax+055h], 8
        je short .1
        movsx ecx, dx
        mov eax, 1
        shl eax, cl
        test al, 0F0h
        jmp short .2
.1:
        movsx ecx, dx
        mov eax, 1
        shl eax, cl
        test al, 1Eh
.2:
        setne al
        xor ah, ah
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; deflect                                             57A3E  94G collide94.asm
; The puck p is deflected: no carrier (puckc byte -1), random x y velocity
; -1000h..FFFh, random z velocity 0..FFFh (also left in regd0), then puckflip.
;-----------------------------------------------------------------------------
; C: src/engine/puckphys/deflect.c
%ifdef CBUILD
%include "c/engine/puckphys/deflect.inc"
%else
deflect:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov eax, 2000h
        call randomd0
        db 081h,0E8h,00h,010h,00h,00h           ; insn: sub eax,1000h
        mov word [byte edx+0Eh], ax
        mov eax, 2000h
        call randomd0
        db 081h,0E8h,00h,010h,00h,00h           ; insn: sub eax,1000h
        mov word [byte edx+0Ch], ax
        mov eax, 1000h
        call randomd0
        mov word [byte edx+010h], ax
        mov word [regd0], ax
        mov eax, edx
        call puckflip
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; shotdiradj                                            57A98  95G input95.asm
; shotdiradj: where a computer player or a one-timer shoots. pflags bit 3
; bails out, then the goalie on that side of SortCords
;-----------------------------------------------------------------------------
shotdiradj:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, eax
        test byte [byte eax+pflags], 8
        jne near .14
        cmp word [byte esi+06Ah], byte 6
        jge short .1
        mov eax, 6
        jmp short .2
.1:
        xor eax, eax
.2:
        shl eax, 7
        add eax, SortCords
        xor edx, edx
        jmp short .4
.3:
        cmp word [byte eax+position], byte 0
        je short .5
        inc edx
        add eax, 80h
.4:
        cmp dx, byte 6
        jl short shotdiradj.3
.5:
        cmp dx, byte 6
        jne short .6
        mov word [passdir], 8
        jmp near .14
.6:
        mov edx, dword [byte eax+0Ah]
        sar edx, 19h
        mov ebx, dword [eax]
        sar ebx, 10h
        add ebx, edx
        mov edx, dword [puckx]
        movsx edx, word [edx]
        sub ebx, edx
        movsx edx, bx
        mov dword [byte esp+08h], edx
        mov ebx, dword [byte eax+0Ch]
        sar ebx, 19h
        mov edx, dword [byte eax+Ypos]
        sar edx, 10h
        add edx, ebx
        mov eax, dword [pucky]
        movsx eax, word [eax]
        sub edx, eax
        movsx edi, dx
        push edi
        mov edx, dword [byte esp+0Ch]
        push edx
        call vecdist
        add esp, byte 8
        mov word [byte esp+0Ch], ax
        test ax, ax
        jne short .7
        mov eax, 1
        mov word [byte esp+0Ch], ax
.7:
        mov edx, 12h
        mov eax, 0E8h
        test byte [byte esi+044h], 80h
        jne short .8
        mov eax, 0FFFFFF18h
.8:
        mov ecx, dword [puckx]
        movsx ecx, word [ecx]
        movsx edx, dx
        mov dword [esp], edx
        sub edx, ecx
        mov ebx, dword [pucky]
        movsx ebx, word [ebx]
        cwde
        sub eax, ebx
        mov ebx, dword [byte esp+08h]
        imul ebx, eax
        mov dword [byte esp+04h], ebx
        imul edx, edi
        mov eax, ebx
        sub eax, edx
        mov edx, eax
        mov ebp, dword [byte esp+0Ah]
        sar ebp, 10h
        sar edx, 1Fh
        idiv ebp
        mov ebx, eax
        mov edx, dword [esp]
        neg edx
        sub edx, ecx
        imul edx, edi
        mov eax, dword [byte esp+04h]
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        idiv ebp
        add ebx, eax
        test bx, bx
        jge short .9
        movsx eax, bx
        neg eax
        jmp short .10
.9:
        movsx eax, bx
.10:
        cmp eax, byte 2Ch
        jle short .11
        xor edi, edi
        mov word [passdir], di
        jmp short .14
.11:
        test byte [byte esi+044h], 80h
        je short .12
        neg ebx
.12:
        test bx, bx
        jl short .13
        mov word [passdir], 2
        jmp short .14
.13:
        mov word [passdir], 6
.14:
        add esp, byte 10h
        jmp near dopass_ret6
;-----------------------------------------------------------------------------
; doshot                                                57C0B  94G logic94.asm
; doshot (stick is at puck so launch puck toward goal): shotdiradj, shot
; speed, sfx, assreplace
;-----------------------------------------------------------------------------
doshot:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov esi, eax
        call shotdiradj
        mov ax, word [byte esi+SCnum]
        mov word [shotplayer], ax
        and byte [sflags], 0F7h
        or byte [byte esi+pflags], 20h
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        je short .1
        mov bx, word [byte esi+SPA]
        cmp bx, SPAonetimef
        je short .1
        cmp bx, SPAonetimeb
        je short .1
        mov eax, SPAgready2
        call sfx
        jmp near .40
.1:
        or byte [gmode2], 10h
        mov di, word [byte esi+SPA]
        cmp di, SPAshotb
        je short .2
        cmp di, SPAonetimeb
        jne short .3
.2:
        mov word [byte esp+0Ch], 0AAh
        mov eax, dword [passspeed-2]
        sar eax, 10h
        mov edx, eax
        sar edx, 2
        sub eax, edx
        mov word [passspeed], ax
        jmp short .4
.3:
        mov word [byte esp+0Ch], 0AAh
.4:
        xor edx, edx
        mov dl, byte [byte esi+05Bh]
        cmp dx, byte 0Ch
        jle short .9
        cmp word [byte esi+Xpos+2], byte 0
        jge short .5
        mov eax, dword [esi]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [esi]
        sar eax, 10h
.6:
        cmp word [byte esi+Ypos+2], byte 0
        jge short .7
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
        neg ebx
        jmp short .8
.7:
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
.8:
        add eax, ebx
        cmp eax, 1F4h
        jge short .9
        add edx, byte 2
.9:
        cmp dx, byte 0Eh
        jle short .10
        inc edx
.10:
        cmp dx, byte 0Dh
        jle short .11
        inc edx
.11:
        cmp dx, byte 0Ah
        jle short .12
        inc edx
.12:
        movsx eax, dx
        push eax
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov edx, dword [byte esi+06Ch]
        mov eax, dword [byte edx+eax*2+tmpde-2]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        movsx edx, ax
        mov eax, dword [passspeed-2]
        sar eax, 10h
        add edx, byte 14h
        imul eax, edx
        mov word [passspeed], ax
        mov eax, dword [passspeed-2]
        sar eax, 10h
        imul eax, dword 5249h
        shr eax, 10h
        mov word [passspeed], ax
        cmp dword [shotongoal], byte 0
        je short .13
        call ShotLaneOpen
        mov eax, dword [shotontarget]
        mov dword [shotongoal], eax
.13:
        mov eax, dword [passdir]
        sar eax, 14h
        mov edx, 3
        sub edx, eax
        test dx, dx
        jle short .14
        mov word [byte esp+0Ch], 9Ah
.14:
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov word [byte esi+03Eh], 10h
        mov ax, word [byte esi+SCnum]
        mov word [lastplayer], ax
        mov edx, 0E8h
        test byte [byte esi+pflags], 80h
        jne short .15
        mov edx, 0FFFFFF18h
.15:
        mov edi, dword [passdir-2]
        sar edi, 10h
        mov ebx, dword [puckx]
        mov ax, word [nosplit edi*4+shotsets]
        mov cx, word [ebx]
        sub eax, ecx
        mov word [byte esp+08h], ax
        mov eax, dword [pucky]
        mov bx, word [eax]
        sub edx, ebx
        mov word [byte esp+010h], dx
        mov di, word [nosplit edi*4+shotsetz]
        mov eax, dword [byte esp+0Eh]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        push eax
        call vecdist
        add esp, byte 8
        mov ecx, eax
        test ax, ax
        jne short .16
        mov ecx, 1
.16:
        test byte [gmode], 10h
        jne near .27
        xor edx, edx
        mov dl, byte [byte esi+05Ch]
        cmp dx, byte 0Eh
        jle short .17
        inc edx
.17:
        cmp dx, byte 0Dh
        jle short .18
        inc edx
.18:
        cmp cx, 0C8h
        jg short .19
        xor eax, eax
        mov al, byte [byte esi+05Ch]
        add eax, 10h
        cwde
        call randomd0
        cmp ax, 0Eh
        jg near .27
.19:
        mov ebx, dword [passdir]
        sar ebx, 14h
        movsx eax, dx
        sub ebx, eax
        movsx eax, cx
        add ebx, byte 10h
        imul eax, ebx
        and eax, 0FFFFh
        sar eax, 6
        mov ebx, eax
        cmp cx, 0FAh
        jge short .20
        sar bx, 1
.20:
        cmp bx, 0A0h
        jle short .21
        mov ebx, 0A0h
.21:
        mov eax, ebx
        add eax, ebx
        cwde
        call randomd0
        sub eax, ebx
        add word [byte esp+08h], ax
        cmp bx, byte 3Ch
        jle short .22
        mov ebx, 3Ch
.22:
        cmp word [byte esp+010h], byte 0
        jge short .23
        movsx edx, bx
        sar edx, 1
        jmp short .24
.23:
        movsx edx, bx
.24:
        mov eax, edx
        add eax, edx
        mov word [byte esp+04h], ax
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call randomd0
        sub eax, edx
        mov edx, eax
        add word [byte esp+010h], dx
        movsx ebp, bx
        mov edx, ebp
        sar edx, 1
        cmp cx, 0A0h
        jge short .25
        mov dword [esp], 3
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv dword [esp]
        mov edx, eax
.25:
        cmp cx, byte 50h
        jge short .26
        movsx eax, bx
        sar eax, 2
        mov edx, eax
.26:
        movsx eax, dx
        call randomd0
        add edi, eax
.27:
        mov edx, dword [passspeed-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        imul edx, eax
        movsx ebp, cx
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov ebx, eax
        mov eax, dword [puckvx]
        mov word [eax], bx
        mov edx, dword [passspeed-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [byte esp+0Eh]
        sar edx, 10h
        imul edx, eax
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov ebx, eax
        mov eax, dword [puckvy]
        mov word [eax], bx
        cmp dword [penshotlive], byte 0
        je near .37
        mov eax, dword [byte esi+Xvel-2]
        sar eax, 10h
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        xor edx, eax
        test edx, edx
        jl short .32
        cmp word [byte esi+Xvel], byte 0
        jge short .28
        mov edx, eax
        neg edx
        jmp short .29
.28:
        mov edx, eax
.29:
        mov eax, dword [puckvx]
        mov bx, word [eax]
        test bx, bx
        jge short .30
        movsx eax, bx
        neg eax
        jmp short .31
.30:
        movsx eax, bx
.31:
        cmp eax, edx
        jge short .32
        mov dx, word [byte esi+Xvel]
        add edx, 1F4h
        mov eax, dword [puckvx]
        mov word [eax], dx
.32:
        mov eax, dword [byte esi+Yvel-2]
        sar eax, 10h
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        xor edx, eax
        test edx, edx
        jl short .37
        cmp word [byte esi+Yvel], byte 0
        jge short .33
        mov edx, eax
        neg edx
        jmp short .34
.33:
        mov edx, eax
.34:
        mov eax, dword [puckvy]
        mov bx, word [eax]
        test bx, bx
        jge short .35
        movsx eax, bx
        neg eax
        jmp short .36
.35:
        movsx eax, bx
.36:
        cmp eax, edx
        jge short .37
        mov dx, word [byte esi+Yvel]
        add edx, 1F4h
        mov eax, dword [puckvy]
        mov word [eax], dx
.37:
        test di, di
        je short .39
        mov ebp, dword [passspeed-2]
        sar ebp, 10h
        mov eax, ebp
        shl eax, 4
        add eax, ebp
        shl eax, 2
        movsx edx, di
        imul eax, edx
        movsx ecx, cx
        xor edx, edx
        div ecx
        mov edi, eax
        imul eax, ecx, dword 0B33h
        xor edx, edx
        div ebp
        add edi, eax
        cmp di, 1800h
        jbe short .38
        mov edi, 1800h
.38:
        mov eax, dword [puckvz]
        mov word [eax], di
.39:
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        call sfx
        cmp dword [penshotlive], byte 0
        je short .40
        mov edx, 11h
        mov eax, esi
        call assreplace
.40:
        add esp, byte 14h
        jmp near dopass_ret6
