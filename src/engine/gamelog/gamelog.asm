; The rink objects, the deferred calls, and the game log: the summary records and the goal, assist,
; penalty and injury events that the summary screens read.
bits 32
%include "hockey.inc"
section s_614C2 progbits alloc exec nowrite align=1
extern __CHK, assinsert, assreplace, awgoalcnt, awscore, awtmap, awtmflags, awtmstruct
extern bannermsg, bannertimer, pendelaytab_e13, pendelay2tab, pendelay2tab_e4, rinkobjanim, rinkobjanim_b1, hmtmcoachflags
extern awtmcoachflags, milestonesaid, milestonesaid_b1, PenBuf_pl_m2, curevent, curevent_b1, curevent_b2, curevent_b3
extern curevent_b4, curevent_b5, curevent_b6, curevent_b7, curevent_b8, curevent_b9, curevent_b10, goalevent
extern c1playernum, c2playernum, CanRemovePlayer, clockticks, CloseTextOverlay, cont1team, cont2team, crowdlevel
extern curperiod, CwdExciteLvl, defercount, deferpending, DrawFrameSprite, DrawSprite, penmintab_m3, dword_CBEBE
extern goalienotebits, sideobjpos, hmplstats_m2, hmplstats, plcareergoals, plcareerpts, plseasongoals, plseasonpts
extern hmtmtouch2, hmtmtouch3, dword_E0220, dword_E0230, PenBuf_m2, dword_E9A9E, rinkobjused_m2, defertab
extern defertab_a1, defertab_a2, defertab_a3, defertab_a4, defertab_a5, defertab_a6, defertab_fn, FatalError
extern FileClose, FileOpenRW, FileWriteAt, fox, foy, fputchar, gameclock, gamemode
extern gameopts, gmode, gmode2, gsp, gsummarypath, gsumqcount, hmgoalcnt, hmroster
extern hmrosterjersey, hmscore, hmteamrec, hmtmap, hmtmflags, hmtmgoalie, hmtmlines, hmtmstruct
extern HomeTeam, joysampling, joysampling_save, lastsfx, LoadTeamPPV, lseek_, ltx, lty
extern MenuCallbackTrue, MenuCallbackTrue2, musicon, pennametab, ovlseq, ovltimer, PanelAddPenalty, PanelRemovePenalty
extern PaPenalty, PaPenaltyShot, PaSpeechBusy, PBnum, penaltynames, Penaltytimer, PenBuf, PenBuf_m5
extern PenBuf_pl, Pencntdwn, pendelaytab, penmintab, penshotfox, penshotfoy, penshotlive, penshotmode
extern penshotplayer, penshotpnum, penshotstart, penshotteam, penshottimer, periodendtime, PerTimeTotal, photoptrsf
extern PlayCrowdSample, priolist_m1, puckc, puckstruct, pucktemp1, puckvx, puckvy, puckvz
extern puckx, pucky, puckz, randomd0, RefPen, refsignal, RefStep, regd1
extern regd2, regd3, restorepl, s1font, scor2font, scpflags2, Setplass, setplayer
extern sflags, sflags3, sfx, shotongoal, shotontarget, SortCords, sortobj15, sprintf_
extern str_02d02dSInjury, str_02d02dSPenalty, str_Assists, str_B3, str_B4, str_B5, str_B6, str_B7
extern str_B8, str_DMinutes, str_FmtClockEvent, str_FmtNumFirstLast, str_FmtNumInitialLast, str_FmtNumName, str_FmtNumNameSuffix, str_FmtParenD
extern str_GameMisconduct, str_GoneFor1Period, str_GoneForTheGame, str_PenaltyShot, str_PPTag, str_S8, str_ServedByD, str_SHTag
extern str_ToBeTakenBy, str_Unassisted, strcpy_, strlen_, TextSetFont, teamabbrevs, textline1, textline2
extern textline3, textline4, textline5, unk_C1B49, gsumheader, gsumtail, gsumqueue, UpdateTextOverlay
extern vecdist, VisTeam, gsumcount, penaltysc, word_CBC44, injurystop, Pencntdwn2, rinkobjdefs
extern penbannertab, hmplstats_w2, rinkobjs, hmtmtouch1, penevteam, rinkobjused, yleader
global SetRinkObject, SetBoxDoorObject, DecayCrowdLevel, sfxslots_popx, DrawRinkObjects, QueueDeferredCall, RunDeferredCalls, fileio_popebpx
global AppendGSumRecord, FlushGSumQueue, ReadGSumHeader, fileio_tail_a, fileio_tail_b, fileio_tail_c, ReadGSumTail, WriteGSumHeader
global FormatPlayerName, BuildEventLines, PostGoalEvent, PostPenaltyEvent, PostInjuryEvent, NullCallback0C, ChkScorerMilestone, QueueGoalieNote
;-----------------------------------------------------------------------------
; SetRinkObject                                   614C2  95 PC, low confidence
; (slot, frame): fills the 0Ch-byte rinkobjs slot from the rinkobjdefs frame
; triple (x, y, z) and rinkobjanim/CCE01, and marks the frame bit in
; rinkobjused
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/SetRinkObject.c
%ifdef CBUILD
%include "c/engine/gamelog/SetRinkObject.inc"
%else
SetRinkObject:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov esi, edx
        mov ebx, eax
        shl ebx, 2
        sub ebx, eax
        shl ebx, 2
        add ebx, rinkobjs
        mov word [ebx], dx
        mov eax, edx
        sar edx, 1Fh
        shl edx, 4
        LD sbb, eax, edx
        sar eax, 4
        lea edi, [eax+eax]
        mov ecx, 10h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov cl, dl
        mov edx, 1
        shl edx, cl
        mov eax, dword [dword edi+rinkobjused-2]
        sar eax, 10h
        or eax, edx
        mov word [dword edi+rinkobjused], ax
        mov eax, esi
        shl esi, 2
        sub esi, eax
        mov ax, word [nosplit esi*2+rinkobjdefs]
        mov word [byte ebx+05h], ax
        inc esi
        mov ax, word [nosplit esi*2+rinkobjdefs]
        mov word [byte ebx+07h], ax
        inc esi
        mov ax, word [nosplit esi*2+rinkobjdefs]
        mov word [byte ebx+09h], ax
        mov eax, dword [byte ebx+07h]
        sar eax, 10h
        mov al, byte [dword eax+rinkobjanim]
        mov byte [byte ebx+0Bh], al
        mov eax, dword [byte ebx+07h]
        sar eax, 10h
        mov al, byte [dword eax+rinkobjanim_b1]
        mov byte [byte ebx+04h], al
        mov byte [byte ebx+02h], 0Ch
        mov byte [byte ebx+03h], 1
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetBoxDoorObject                                61576  95 PC, low confidence
; Team: SetRinkObject slot 12h/13h with frame 87h/88h (home/away); called
; when a player enters or leaves the penalty box
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/SetBoxDoorObject.c
%ifdef CBUILD
%include "c/engine/gamelog/SetBoxDoorObject.inc"
%else
SetBoxDoorObject:
        push dword 8
        call __CHK
        push edx
        test eax, eax
        je short .1
        mov edx, 88h
        mov eax, 13h
        jmp short .2
.1:
        mov edx, 87h
        mov eax, 12h
.2:
        call SetRinkObject
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DecayCrowdLevel                              615A2  95 PC, medium confidence
; Crowdlevel decays by 3 above 2BCh, 2 above 15Eh, then 1 per call; at 0
; picks a random crowd event
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/DecayCrowdLevel.c
%ifdef CBUILD
%include "c/engine/gamelog/DecayCrowdLevel.inc"
%else
DecayCrowdLevel:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov dx, word [crowdlevel]
        cmp dx, 2BCh
        jle short .1
        mov esi, edx
        sub esi, byte 2
        mov word [crowdlevel], si
        jmp short .2
.1:
        cmp dx, 15Eh
        jle short .2
        mov ecx, edx
        sub ecx, byte 3
        mov word [crowdlevel], cx
.2:
        mov di, word [crowdlevel]
        dec edi
        mov word [crowdlevel], di
        test di, di
        jge short .3
        xor edx, edx
        mov word [crowdlevel], dx
        mov eax, 10h
        call randomd0
        test ax, ax
        jne short .3
        mov eax, 20h
        call randomd0
        mov word [crowdlevel], ax
.3:
        xor ebx, ebx
        mov word [esp], bx
        jmp near .20
.4:
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, rinkobjs
        add ebx, eax
        cmp word [ebx], byte 0
        jge near .10
        mov ah, byte [byte ebx+02h]
        dec ah
        mov byte [byte ebx+02h], ah
        test ah, ah
        jge near .19
        cmp cx, byte 12h
        jne short .5
        mov eax, 11h
        call randomd0
        mov esi, eax
        add esi, 89h
        jmp near .9
.5:
        cmp cx, byte 13h
        jne short .6
        mov eax, 11h
        call randomd0
        mov esi, eax
        add esi, 9Ah
        jmp near .9
.6:
        cmp cx, byte 11h
        jne short .7
        test byte [gmode], 1
        je short .7
        mov eax, 4
        call randomd0
        cmp ax, 2
        jge short .7
        mov esi, eax
        add esi, 85h
        jmp short .9
.7:
        mov eax, 85h
        call randomd0
        mov esi, eax
.8:
        movsx ebx, si
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        shl edx, 4
        LD sbb, eax, edx
        sar eax, 4
        mov edi, dword [nosplit eax*2+rinkobjused_m2]
        sar edi, 10h
        mov ecx, 10h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov cl, dl
        mov eax, 1
        shl eax, cl
        test edi, eax
        je short .9
        inc esi
        cmp si, 85h
        jl short DecayCrowdLevel.8
        xor esi, esi
        jmp short DecayCrowdLevel.8
.9:
        movsx edx, si
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        call SetRinkObject
        jmp near .19
.10:
        mov ah, byte [byte ebx+02h]
        dec ah
        mov byte [byte ebx+02h], ah
        test ah, ah
        jge near .19
        cmp byte [byte ebx+0Bh], 0
        jge short .11
        mov eax, dword [byte ebx+08h]
        sar eax, 18h
        neg eax
        jmp short .12
.11:
        mov eax, dword [byte ebx+08h]
        sar eax, 18h
.12:
        mov edx, dword [ebx]
        sar edx, 18h
        cmp edx, eax
        jge short .13
        mov byte [byte ebx+02h], 0Ch
        inc byte [byte ebx+03h]
        mov eax, dword [byte ebx+07h]
        sar eax, 10h
        mov edx, dword [ebx]
        sar edx, 18h
        mov al, byte [dword edx+eax+rinkobjanim]
        mov byte [byte ebx+04h], al
        jmp near .19
.13:
        cmp byte [byte ebx+0Bh], 0
        jge short .14
        mov eax, 2
        call randomd0
        test ax, ax
        je short .14
        mov eax, dword [byte ebx+07h]
        sar eax, 10h
        mov al, byte [dword eax+rinkobjanim_b1]
        mov byte [byte ebx+04h], al
        mov byte [byte ebx+02h], 0Ch
        mov byte [byte ebx+03h], 1
        jmp near .19
.14:
        movsx ecx, word [ebx]
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        shl edx, 4
        LD sbb, eax, edx
        sar eax, 4
        lea edi, [eax+eax]
        mov esi, 10h
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv esi
        mov cl, dl
        mov edx, 1
        shl edx, cl
        not edx
        mov eax, dword [dword edi+rinkobjused-2]
        sar eax, 10h
        and eax, edx
        mov word [dword edi+rinkobjused], ax
        mov word [ebx], 0FFFFh
        mov edx, dword [crowdlevel-2]
        sar edx, 10h
        mov eax, 3E8h
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        shl edx, 3
        LD sbb, eax, edx
        sar eax, 3
        mov edx, eax
        cmp ax, 14h
        jge short .15
        mov edx, 14h
.15:
        cmp word [esp], byte 12h
        jl short .16
        cmp dx, byte 64h
        jge short .16
        mov edx, 64h
.16:
        cmp word [esp], byte 11h
        jne short .17
        test byte [gmode], 1
        je short .17
        mov edx, 78h
        jmp short .18
.17:
        movsx eax, dx
        call randomd0
        mov edx, eax
.18:
        mov byte [byte ebx+02h], dl
.19:
        inc word [esp]
.20:
        mov ecx, dword [esp]
        cmp cx, byte 14h
        jl near DecayCrowdLevel.4
        add esp, byte 4
sfxslots_popx:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawRinkObjects                                 61862  95 PC, low confidence
; Draws the 12h rink object slots of rinkobjs (photoptrsf frames at
; +05h/+07h) and the slot sprites from sideobjpos / dword_E0220 / dword_E0230
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/DecayCrowdLevel.c (DrawRinkObjects)
%ifdef CBUILD
%include "c/engine/gamelog/DecayCrowdLevel.DrawRinkObjects.inc"
%else
DrawRinkObjects:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 10h
        mov esi, rinkobjs
        xor edi, edi
        jmp short .3
.1:
        cmp word [esi], byte 0
        jl short .2
        push byte 0
        push byte 0FFFFFFFFh
        cmp word [byte esi+05h], 0C0h
        setg al
        xor ah, ah
        cwde
        mov dword [byte ebp-010h], eax
        mov ebx, dword [byte esi+05h]
        sar ebx, 10h
        mov edx, dword [byte esi+03h]
        sar edx, 10h
        mov eax, dword [byte esi+01h]
        sar eax, 18h
        mov eax, dword [nosplit eax*4+photoptrsf]
        mov ecx, dword [byte ebp-010h]
        call DrawSprite
.2:
        inc edi
        add esi, byte 0Ch
.3:
        cmp di, byte 12h
        jl short DrawRinkObjects.1
        mov edi, 1
        add esi, byte 0Ch
        jmp near .12
.4:
        cmp word [esi], byte 0
        jge short .5
        mov word [byte ebp-0Ch], 0FFFFh
        jmp short .6
.5:
        movsx ax, byte [byte esi+04h]
        mov word [byte ebp-0Ch], ax
.6:
        mov ax, word [byte esi+05h]
        mov word [byte ebp-08h], ax
        mov ax, word [byte esi+07h]
        mov word [byte ebp-04h], ax
        cmp word [byte ebp-0Ch], byte 64h
        jg short .7
        cmp word [esi], byte 0
        jge short .8
.7:
        push byte 0
        movsx eax, di
        push eax
        mov ebx, dword [nosplit eax*4+sideobjpos]
        sar ebx, 10h
        mov eax, dword [dword_E0220]
        xor ecx, ecx
        mov edx, 4
        call DrawSprite
.8:
        cmp word [byte ebp-0Ch], byte 0
        jl short .9
        push byte 0
        movsx eax, di
        push eax
        mov ebx, dword [byte ebp-06h]
        sar ebx, 10h
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+photoptrsf]
        xor ecx, ecx
        call DrawSprite
.9:
        test di, di
        jne short .10
        push byte 0
        push byte 0FFFFFFFFh
        movsx eax, di
        mov ebx, dword [nosplit eax*4+sideobjpos]
        sar ebx, 10h
        mov eax, dword [dword_E0230]
        xor ecx, ecx
        mov edx, 4
        call DrawSprite
        jmp short .11
.10:
        test byte [gmode], 80h
        je short .11
        cmp word [sortobj15+12h], 362h
        jl short .11
        push byte 0
        mov ebx, dword [sortobj15+4]
        sar ebx, 10h
        mov edx, dword [sortobj15]
        sar edx, 10h
        mov eax, dword [sortobj15+10h]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.11:
        dec edi
        sub esi, byte 0Ch
.12:
        test di, di
        jge near DrawRinkObjects.4
        mov esp, ebp
        pop ebp
        jmp near sfxslots_popx
%endif ; C
;-----------------------------------------------------------------------------
; QueueDeferredCall                            619C8  95 PC, medium confidence
; Stores a function pointer and 7 args in the next 20h-byte slot
; (defertab..E9BC0, count defercount)
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/QueueDeferredCall.c
%ifdef CBUILD
%include "c/engine/gamelog/QueueDeferredCall.inc"
%else
QueueDeferredCall:
        push dword 8
        call __CHK
        push esi
        mov esi, eax
        mov eax, dword [defercount]
        shl eax, 5
        mov dword [dword eax+defertab_fn], esi
        mov dword [dword eax+defertab], edx
        mov dword [dword eax+defertab_a1], ebx
        mov dword [dword eax+defertab_a2], ecx
        mov edx, dword [byte esp+08h]
        mov dword [dword eax+defertab_a3], edx
        mov edx, dword [byte esp+0Ch]
        mov dword [dword eax+defertab_a4], edx
        mov edx, dword [byte esp+010h]
        mov dword [dword eax+defertab_a5], edx
        mov edx, dword [byte esp+014h]
        mov dword [dword eax+defertab_a6], edx
        inc dword [defercount]
        pop esi
        ret 10h
%endif ; C
;-----------------------------------------------------------------------------
; RunDeferredCalls                             61A27  95 PC, medium confidence
; Calls every queued slot from QueueDeferredCall with its args
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/RunDeferredCalls.c
%ifdef CBUILD
%include "c/engine/gamelog/RunDeferredCalls.inc"
%else
RunDeferredCalls:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        xor edi, edi
        jmp short .2
.1:
        mov esi, edi
        shl esi, 5
        mov ebx, dword [dword esi+defertab_a6]
        push ebx
        mov ecx, dword [dword esi+defertab_a5]
        push ecx
        mov ebp, dword [dword esi+defertab_a4]
        push ebp
        mov ecx, dword [dword esi+defertab_a3]
        mov ebx, dword [dword esi+defertab_a2]
        mov edx, dword [dword esi+defertab_a1]
        mov eax, dword [dword esi+defertab]
        call dword [dword esi+defertab_fn]
        inc edi
.2:
        cmp edi, dword [defercount]
        jl short RunDeferredCalls.1
        xor eax, eax
        mov dword [defercount], eax
fileio_popebpx:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AppendGSumRecord                             61A8A  95 PC, medium confidence
; Bumps the gsummary record count gsumcount, opens gsummarypath, rewrites the
; 0Bh-byte header (gsumheader) and appends the record in eax (B3/B4..
; FatalError codes)
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/AppendGSumRecord.c
%ifdef CBUILD
%include "c/engine/gamelog/AppendGSumRecord.inc"
%else
AppendGSumRecord:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 4
        mov esi, eax
        inc word [gsumcount]
        mov edx, esp
        mov eax, gsummarypath
        call FileOpenRW
        test eax, eax
        je short .1
        push str_B3
        call FatalError
        add esp, byte 4
.1:
        xor ebx, ebx
        xor edx, edx
        mov eax, dword [esp]
        call lseek_
        test eax, eax
        jge short .2
        push str_B4
        call FatalError
        add esp, byte 4
.2:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumheader
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .3
        push str_B5
        call FatalError
        add esp, byte 4
.3:
        mov ebx, 2
        mov edx, 0FFFFFFF5h
        mov eax, dword [esp]
        call lseek_
        test eax, eax
        jge short .4
        push str_B6
        call FatalError
        add esp, byte 4
.4:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, esi
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .5
        push str_B7
        call FatalError
        add esp, byte 4
.5:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumtail
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .6
        push str_B8
        call FatalError
        add esp, byte 4
.6:
        mov eax, esp
        call FileClose
        add esp, byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FlushGSumQueue                               61B85  95 PC, medium confidence
; AppendGSumRecord for each queued 0Dh-byte record at gsumqueue (count
; gsumqcount), then clears the count
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/FlushGSumQueue.c
%ifdef CBUILD
%include "c/engine/gamelog/FlushGSumQueue.inc"
%else
FlushGSumQueue:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        xor edx, edx
        jmp short .2
.1:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, gsumqueue
        call AppendGSumRecord
        inc edx
.2:
        cmp edx, dword [gsumqcount]
        jl short FlushGSumQueue.1
        xor ecx, ecx
        mov dword [gsumqcount], ecx
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadGSumHeader                               61BBF  95 PC, medium confidence
; Opens gsummarypath and reads the 0Bh-byte header into gsumheader
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/ReadGSumHeader.c
%ifdef CBUILD
%include "c/engine/gamelog/ReadGSumHeader.inc"
%else
ReadGSumHeader:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 4
        mov edx, esp
        mov eax, gsummarypath
        call FileOpenRW
        test eax, eax
        je short .1
        push str_B3
        call FatalError
        add esp, byte 4
.1:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumheader
fileio_tail_a:
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short fileio_tail_c
        push str_B4
fileio_tail_b:
        call FatalError
        add esp, byte 4
fileio_tail_c:
        mov eax, esp
        call FileClose
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadGSumTail                                 61C22  95 PC, medium confidence
; Opens gsummarypath, seeks to end-0Bh and reads the last record into
; gsumtail
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/ReadGSumHeader.c (ReadGSumTail)
%ifdef CBUILD
%include "c/engine/gamelog/ReadGSumHeader.ReadGSumTail.inc"
%else
ReadGSumTail:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 4
        mov edx, esp
        mov eax, gsummarypath
        call FileOpenRW
        test eax, eax
        je short .1
        push str_B3
        call FatalError
        add esp, byte 4
.1:
        mov ebx, 2
        mov edx, 0FFFFFFF5h
        mov eax, dword [esp]
        call lseek_
        test eax, eax
        jge short .2
        push str_B6
        call FatalError
        add esp, byte 4
.2:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumtail
        jmp near fileio_tail_a
%endif ; C
;-----------------------------------------------------------------------------
; WriteGSumHeader                              61C86  95 PC, medium confidence
; Bumps gsumcount and writes the 0Bh-byte header gsumheader at offset 0 of
; gsummarypath
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/ReadGSumHeader.c (WriteGSumHeader)
%ifdef CBUILD
%include "c/engine/gamelog/ReadGSumHeader.WriteGSumHeader.inc"
%else
WriteGSumHeader:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 4
        inc word [gsumcount]
        mov edx, esp
        mov eax, gsummarypath
        call FileOpenRW
        test eax, eax
        je short .1
        push str_B3
        call FatalError
        add esp, byte 4
.1:
        xor ebx, ebx
        xor edx, edx
        mov eax, dword [esp]
        call lseek_
        test eax, eax
        jge short .2
        push str_B4
        call FatalError
        add esp, byte 4
.2:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumheader
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .3
        push str_B5
        call FatalError
        add esp, byte 4
.3:
        mov ebx, 2
        xor edx, edx
        mov eax, dword [esp]
        call lseek_
        test eax, eax
        jge short .4
        push str_B6
        call FatalError
        add esp, byte 4
.4:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumtail
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je near fileio_tail_c
        push str_B8
        jmp near fileio_tail_b
%endif ; C
;-----------------------------------------------------------------------------
; FormatPlayerName                             61D48  95 PC, medium confidence
; Sprintf '%s#%d %s %s%s' / '%s#%d %c. %s%s' variants of a roster name for
; the event text
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/FormatPlayerName.c
%ifdef CBUILD
%include "c/engine/gamelog/FormatPlayerName.inc"
%else
FormatPlayerName:
        push dword 48h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        mov edi, eax
        mov dword [byte esp+014h], edx
        mov word [byte esp+018h], bx
        mov ebp, ecx
        mov edx, dword [scor2font]
        push edx
        call TextSetFont
        add esp, byte 4
        mov ebx, dword [byte esp+030h]
        push ebx
        mov ecx, dword [byte esp+030h]
        push ecx
        push ebp
        mov esi, dword [byte esp+022h]
        sar esi, 10h
        push esi
        mov eax, dword [byte esp+024h]
        push eax
        push str_FmtNumFirstLast
        push edi
        call sprintf_
        add esp, byte 1Ch
        push edi
        call fputchar
        add esp, byte 4
        cmp eax, byte 7Ch
        jle near .3
        mov edx, dword [byte esp+030h]
        push edx
        mov ebx, dword [byte esp+030h]
        push ebx
        movsx eax, byte [byte ebp+00h]
        push eax
        push esi
        mov ecx, dword [byte esp+024h]
        push ecx
        push str_FmtNumInitialLast
        push edi
        call sprintf_
        add esp, byte 1Ch
        push edi
        call fputchar
        add esp, byte 4
        cmp eax, byte 7Ch
        jle near .3
        mov ebp, dword [byte esp+030h]
        push ebp
        mov eax, dword [byte esp+030h]
        push eax
        push esi
        mov edx, dword [byte esp+020h]
        push edx
        push str_FmtNumNameSuffix
        push edi
        call sprintf_
        add esp, byte 18h
        push edi
        call fputchar
        add esp, byte 4
        cmp eax, byte 7Ch
        jle short .3
        push ebp
        push esi
        mov ecx, dword [byte esp+01Ch]
        push ecx
        push str_FmtNumName
        push edi
        call sprintf_
        add esp, byte 14h
        push edi
        call fputchar
        add esp, byte 4
        mov ebp, 7Ch
        sub ebp, eax
        mov edx, dword [byte esp+02Ch]
        mov eax, esp
        call strcpy_
        mov eax, esp
        call strlen_
        mov esi, eax
.1:
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        cmp eax, ebp
        jle short .2
        dec esi
        xor ah, ah
        mov byte [esp+esi], ah
        jmp short FormatPlayerName.1
.2:
        mov esi, dword [byte esp+030h]
        push esi
        lea eax, [byte esp+04h]
        push eax
        mov eax, dword [byte esp+01Eh]
        sar eax, 10h
        push eax
        mov ebp, dword [byte esp+020h]
        push ebp
        push str_FmtNumNameSuffix
        push edi
        call sprintf_
        add esp, byte 18h
.3:
        mov eax, dword [s1font]
        push eax
        call TextSetFont
        add esp, byte 4
        add esp, byte 1Ch
        pop ebp
        pop edi
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; BuildEventLines                              61E99  95 PC, medium confidence
; Fills the 5 event text lines from the event record E9AC8 (1 goal: time,
; PP/SH, scorer, Assists/Unassisted; 2 penalty: 'Penalty shot', '%d minutes',
; 'game misconduct', 'served by #%d'; 3 injury: 'gone for the game' / '1
; period')
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/BuildEventLines.c
%ifdef CBUILD
%include "c/engine/gamelog/BuildEventLines.inc"
%else
BuildEventLines:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        xor ah, ah
        mov byte [textline5], ah
        mov byte [textline4], ah
        mov byte [textline2], ah
        mov byte [textline1], ah
        mov byte [textline3], ah
        mov cl, byte [curevent]
        cmp cl, 1
        jne near .8
        movzx esi, byte [curevent_b1]
        mov edx, esi
        shl edx, 2
        sub edx, esi
        shl edx, 3
        mov eax, edx
        shl edx, 5
        sub edx, eax
        add edx, hmteamrec
        add edx, byte 1Ah
        push edx
        xor eax, eax
        mov al, byte [curevent_b8]
        push eax
        xor eax, eax
        mov al, byte [curevent_b7]
        push eax
        push str_FmtClockEvent
        push textline3
        call sprintf_
        add esp, byte 14h
        xor eax, eax
        mov al, byte [curevent_b5]
        xor edx, edx
        mov dl, byte [curevent_b2]
        test al, 2
        je short .1
        mov eax, str_SHTag
        jmp short .3
.1:
        test al, 4
        je short .2
        mov eax, str_PPTag
        jmp short .3
.2:
        mov eax, unk_C1B49
.3:
        push eax
        push str_S8
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        mov ecx, eax
        add esp, byte 0Ch
        cmp dword [gamemode], byte 0
        je short .4
        test byte [gmode], 10h
        jne short .4
        cmp edx, byte 19h
        jge short .4
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 3
        lea ebx, [esi+eax]
        shl ebx, 4
        mov eax, edx
        shl eax, 4
        add eax, ebx
        mov ebx, dword [dword eax+hmplstats-2]
        sar ebx, 10h
        add ebx, dword [dword eax+plseasongoals]
        push ebx
        push str_FmtParenD
        lea eax, [byte esp+08h]
        add eax, ecx
        push eax
        call sprintf_
        add esp, byte 0Ch
.4:
        mov eax, esp
        push eax
        mov ebx, esi
        mov edi, esi
        shl edi, 4
        add edi, esi
        shl edi, 4
        add edi, esi
        shl edi, 2
        mov ebp, hmroster
        add ebp, edi
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        lea ecx, [eax+ebp]
        lea edx, [byte ecx+017h]
        push edx
        add ecx, byte 7
        xor ebx, esi
        mov bl, byte [dword edi+eax+hmrosterjersey]
        mov edx, unk_C1B49
        mov eax, textline1
        call FormatPlayerName
        xor edx, edx
        mov dl, byte [curevent_b3]
        cmp edx, 0FFh
        jne short .5
        push str_Unassisted
        push textline2
        call sprintf_
        add esp, byte 8
        jmp short .6
.5:
        push str_Assists
        push textline2
        call sprintf_
        add esp, byte 8
        push unk_C1B49
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov edx, eax
        add eax, ebp
        lea ebx, [byte eax+017h]
        push ebx
        lea ecx, [byte eax+07h]
        xor ebx, ebx
        mov bl, byte [dword edx+edi+hmrosterjersey]
        mov edx, unk_C1B49
        mov eax, textline4
        call FormatPlayerName
.6:
        xor edx, edx
        mov dl, byte [curevent_b4]
        cmp edx, 0FFh
        je near .14
        push unk_C1B49
        mov ebx, esi
        shl ebx, 4
        add ebx, esi
        shl ebx, 4
        add ebx, esi
        shl ebx, 2
        mov ecx, hmroster
        add ecx, ebx
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        lea edx, [ecx+eax]
        lea ecx, [byte edx+017h]
        push ecx
        lea ecx, [byte edx+07h]
        mov bl, byte [dword ebx+eax+hmrosterjersey]
        and ebx, 0FFh
        mov edx, unk_C1B49
        mov eax, textline5
.7:
        call FormatPlayerName
        jmp near .14
.8:
        cmp cl, 2
        jne near .11
        movzx esi, byte [curevent_b1]
        xor edx, edx
        mov dl, byte [curevent_b2]
        cmp byte [curevent_b3], 11h
        jne near .9
        mov edx, dword [penshotteam]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        add eax, hmteamrec
        push eax
        xor eax, eax
        mov al, byte [curevent_b7]
        push eax
        xor eax, eax
        mov al, byte [curevent_b6]
        push eax
        push str_FmtClockEvent
        push textline3
        call sprintf_
        add esp, byte 14h
        mov edi, textline1
        mov esi, str_PenaltyShot
        movsd
        movsd
        movsd
        movsb
        mov edi, textline2
        mov esi, str_ToBeTakenBy
        movsd
        movsd
        movsd
        movsw
        movsb
        push unk_C1B49
        mov edx, dword [penshotteam]
        mov ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 2
        mov ecx, hmroster
        add ecx, ebx
        mov edx, dword [penshotpnum]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        lea edx, [ecx+eax]
        lea ecx, [byte edx+017h]
        push ecx
        lea ecx, [byte edx+07h]
        add eax, ebx
        xor ebx, ebx
        mov bl, byte [dword eax+hmrosterjersey]
        mov edx, unk_C1B49
        mov eax, textline4
        jmp near BuildEventLines.7
.9:
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 3
        mov ebx, eax
        shl eax, 5
        sub eax, ebx
        add eax, hmteamrec
        push eax
        xor eax, eax
        mov al, byte [curevent_b7]
        push eax
        xor eax, eax
        mov al, byte [curevent_b6]
        push eax
        push str_02d02dSPenalty
        push textline3
        call sprintf_
        add esp, byte 14h
        push unk_C1B49
        mov ebx, esi
        shl ebx, 4
        add ebx, esi
        shl ebx, 4
        add ebx, esi
        shl ebx, 2
        mov ecx, hmroster
        add ecx, ebx
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov edx, eax
        add eax, ecx
        lea ecx, [byte eax+017h]
        push ecx
        lea ecx, [byte eax+07h]
        lea eax, [ebx+edx]
        xor ebx, ebx
        mov bl, byte [dword eax+hmrosterjersey]
        mov edx, unk_C1B49
        mov eax, textline1
        call FormatPlayerName
        xor eax, eax
        mov al, byte [curevent_b3]
        mov edx, dword [nosplit eax*4+penaltynames]
        mov eax, textline2
        call strcpy_
        movzx edi, byte [curevent_b4]
        cmp edi, 0FFh
        jne short .10
        mov edi, textline4
        mov esi, str_GameMisconduct
        movsd
        movsd
        movsd
        movsd
        jmp near .14
.10:
        push edi
        push str_DMinutes
        push textline4
        call sprintf_
        add esp, byte 0Ch
        jmp near .14
.11:
        cmp cl, 3
        jne near .14
        movzx esi, byte [curevent_b1]
        xor edx, edx
        mov dl, byte [curevent_b2]
        mov edi, dword [curevent_b3-3]
        sar edi, 18h
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 3
        mov ebx, eax
        shl eax, 5
        sub eax, ebx
        add eax, hmteamrec
        push eax
        xor eax, eax
        mov al, byte [curevent_b6]
        push eax
        xor eax, eax
        mov al, byte [curevent_b5]
        push eax
        push str_02d02dSInjury
        push textline3
        call sprintf_
        add esp, byte 14h
        push unk_C1B49
        mov ebx, esi
        shl ebx, 4
        add ebx, esi
        shl ebx, 4
        add ebx, esi
        shl ebx, 2
        mov ecx, hmroster
        add ecx, ebx
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        add ecx, eax
        lea edx, [byte ecx+017h]
        push edx
        add ecx, byte 7
        mov bl, byte [dword ebx+eax+hmrosterjersey]
        and ebx, 0FFh
        mov edx, unk_C1B49
        mov eax, textline1
        call FormatPlayerName
        test edi, edi
        jle short .12
        push str_GoneForTheGame
        jmp short .13
.12:
        push str_GoneFor1Period
.13:
        push textline2
        call sprintf_
        add esp, byte 8
.14:
        add esp, byte 0Ch
        jmp near fileio_popebpx
%endif ; C
;-----------------------------------------------------------------------------
; PostGoalEvent                                62343  95 PC, medium confidence
; Sets event type 1 + scorer / assist fields, BuildEventLines (from player
; logic)
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/PostGoalEvent.c
%ifdef CBUILD
%include "c/engine/gamelog/PostGoalEvent.inc"
%else
PostGoalEvent:
        push dword 10h
        call __CHK
        push esi
        push edi
        push eax
        mov byte [curevent], 1
        mov al, byte [esp]
        mov byte [curevent_b1], al
        mov byte [curevent_b2], dl
        mov byte [curevent_b3], bl
        mov byte [curevent_b4], cl
        mov al, byte [byte esp+010h]
        mov byte [curevent_b5], al
        mov al, byte [curperiod]
        mov byte [curevent_b6], al
        mov al, byte [byte esp+014h]
        mov byte [curevent_b7], al
        mov al, byte [byte esp+018h]
        mov byte [curevent_b8], al
        mov eax, dword [esp]
        shl eax, 8
        mov dx, word [dword eax+hmtmgoalie]
        xor dh, dh
        and dl, 1
        movsx edx, dx
        mov eax, dword [dword eax+hmtmlines]
        mov al, byte [byte edx+eax+024h]
        mov byte [curevent_b9], al
        cmp dword [esp], byte 0
        sete al
        and eax, 0FFh
        shl eax, 8
        mov ax, word [dword eax+hmtmgoalie]
        xor ah, ah
        and al, 1
        movsx edx, ax
        cmp dword [esp], byte 0
        sete al
        and eax, 0FFh
        shl eax, 8
        mov eax, dword [dword eax+hmtmlines]
        mov al, byte [byte edx+eax+024h]
        mov byte [curevent_b10], al
        test byte [gmode], 10h
        jne short .3
        mov edx, dword [gsumqcount]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edi, [dword eax+gsumqueue]
        mov esi, curevent
        movsd
        movsd
        movsw
        movsb
        mov ecx, dword [gsumqcount]
        inc ecx
        mov dword [gsumqcount], ecx
        cmp ecx, byte 8
        jl short .1
        lea edi, [byte ecx-01h]
        mov dword [gsumqcount], edi
.1:
        cmp dword [esp], byte 0
        je short .2
        inc byte [awgoalcnt]
        jmp short .3
.2:
        inc byte [hmgoalcnt]
.3:
        cmp dword [esp], byte 0
        jne short .6
        mov eax, 14h
        call randomd0
        cmp ax, 0Ah
        jge short .4
        mov eax, 1
        jmp short .5
.4:
        mov eax, 5
.5:
        cwde
        call LoadTeamPPV
.6:
        call BuildEventLines
        call CloseTextOverlay
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor edx, edx
        mov dword [joysampling], edx
        mov edi, goalevent
        mov esi, curevent
        movsd
        movsd
        movsw
        movsb
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
        add esp, byte 4
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; PostPenaltyEvent                             624B9  95 PC, medium confidence
; Sets event type 2, BuildEventLines, PaPenalty / PaPenaltyShot
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/PostPenaltyEvent.c
%ifdef CBUILD
%include "c/engine/gamelog/PostPenaltyEvent.inc"
%else
PostPenaltyEvent:
        push dword 2Ch
        call __CHK
        push esi
        push edi
        push ebp
        push eax
        push edx
        mov edx, ecx
        test byte [gmode], 10h
        jne near .18
        mov byte [curevent], 2
        mov al, byte [byte esp+04h]
        mov byte [curevent_b1], al
        mov al, byte [esp]
        mov byte [curevent_b2], al
        mov byte [curevent_b3], bl
        mov byte [curevent_b4], dl
        mov al, byte [curperiod]
        mov byte [curevent_b5], al
        mov al, byte [byte esp+018h]
        mov byte [curevent_b6], al
        mov al, byte [byte esp+01Ch]
        mov byte [curevent_b7], al
        mov ecx, dword [gsumqcount]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        lea edi, [dword eax+gsumqueue]
        mov esi, curevent
        movsd
        movsd
        movsw
        movsb
        mov ecx, dword [gsumqcount]
        inc ecx
        mov dword [gsumqcount], ecx
        cmp ecx, byte 8
        jl short .1
        lea edi, [byte ecx-01h]
        mov dword [gsumqcount], edi
.1:
        mov eax, dword [ovltimer-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne near .6
        cmp ebx, byte 11h
        je near .6
        cmp dword [byte esp+04h], byte 0
        je short .2
        mov eax, 4
        call randomd0
        test ax, ax
        jne short .2
        mov eax, 0Ah
        jmp short .5
.2:
        cmp ebx, byte 4
        jne short .3
        mov eax, 3
        call randomd0
        test ax, ax
        jne short .6
        mov eax, 6
        jmp short .5
.3:
        cmp ebx, byte 6
        jne short .4
        mov eax, 3
        call randomd0
        test ax, ax
        jne short .6
        mov eax, 7
        jmp short .5
.4:
        cmp ebx, byte 5
        jne short .6
        mov eax, 3
        call randomd0
        test ax, ax
        jne short .6
        mov eax, 9
.5:
        call LoadTeamPPV
.6:
        call BuildEventLines
        call CloseTextOverlay
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor eax, eax
        mov dword [joysampling], eax
        cmp word [crowdlevel], 190h
        jle short .7
        mov word [crowdlevel], 190h
.7:
        cmp dword [byte esp+04h], byte 0
        je short .8
        mov ax, word [VisTeam]
        jmp short .9
.8:
        mov ax, word [HomeTeam]
.9:
        movsx esi, ax
        cmp ebx, byte 11h
        jne short .12
        cmp dword [penshotteam], byte 0
        je short .10
        mov ax, word [VisTeam]
        jmp short .11
.10:
        mov ax, word [HomeTeam]
.11:
        movsx esi, ax
        mov edx, dword [penshotteam]
        mov ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 2
        mov edx, dword [penshotpnum]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        xor edx, edx
        mov dl, byte [dword ebx+eax+hmrosterjersey]
        mov eax, dword [nosplit esi*4+teamabbrevs]
        mov ecx, dword [byte esp+01Ch]
        mov ebx, dword [byte esp+018h]
        call PaPenaltyShot
        jmp near .17
.12:
        cmp dword [byte esp+020h], byte 0
        sete al
        mov ebp, eax
        and ebp, 0FFh
        mov eax, dword [penevteam-2]
        sar eax, 10h
        cmp eax, dword [byte esp+04h]
        jne short .13
        mov eax, 2
        jmp short .14
.13:
        mov eax, 1
        mov ecx, dword [byte esp+04h]
        mov word [penevteam], cx
.14:
        mov edi, dword [byte esp+020h]
        test edi, edi
        je short .15
        mov cl, byte [nosplit edi*2+PenBuf_pl_m2]
        and cl, 1Fh
        cmp cl, 6
        setl cl
        and ecx, 0FFh
        xor ecx, dword [byte esp+04h]
        je short .15
        lea ecx, [byte eax+01h]
        jmp short .16
.15:
        mov ecx, eax
.16:
        push ebp
        push ecx
        push eax
        mov eax, dword [byte esp+028h]
        push eax
        mov ecx, dword [byte esp+028h]
        push ecx
        mov ecx, dword [nosplit ebx*4+pennametab]
        mov ebx, dword [byte esp+018h]
        mov edi, ebx
        shl edi, 4
        add edi, ebx
        shl edi, 4
        add edi, ebx
        shl edi, 2
        mov ebx, dword [byte esp+014h]
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        movzx edi, byte [dword edi+eax+hmrosterjersey]
        mov eax, dword [nosplit esi*4+teamabbrevs]
        mov ebx, edx
        mov edx, edi
        call PaPenalty
        test ebp, ebp
        je short .17
        mov word [penevteam], 0FFFFh
.17:
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
.18:
        xor eax, eax
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; PostInjuryEvent                              62764  95 PC, medium confidence
; Sets event type 3, BuildEventLines (from physics)
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/PostInjuryEvent.c
%ifdef CBUILD
%include "c/engine/gamelog/PostInjuryEvent.inc"
%else
PostInjuryEvent:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        test byte [gmode], 10h
        jne short .2
        mov byte [curevent], 3
        mov byte [curevent_b1], al
        mov byte [curevent_b2], dl
        mov byte [curevent_b3], bl
        mov al, byte [curperiod]
        mov byte [curevent_b4], al
        mov byte [curevent_b5], cl
        mov al, byte [byte esp+0Ch]
        mov byte [curevent_b6], al
        mov edx, dword [gsumqcount]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edi, [dword eax+gsumqueue]
        mov esi, curevent
        movsd
        movsd
        movsw
        movsb
        mov edx, dword [gsumqcount]
        inc edx
        mov dword [gsumqcount], edx
        cmp edx, byte 8
        jl short .1
        lea ecx, [byte edx-01h]
        mov dword [gsumqcount], ecx
.1:
        call BuildEventLines
        call CloseTextOverlay
.2:
        xor eax, eax
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; NullCallback0C                               627F8  95 PC, medium confidence
; Returns 0, ret 0Ch; no direct callers
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/PostInjuryEvent.c (NullCallback0C)
%ifdef CBUILD
%include "c/engine/gamelog/PostInjuryEvent.NullCallback0C.inc"
%else
NullCallback0C:
        push dword 4
        call __CHK
        xor eax, eax
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; ChkScorerMilestone                           62807  95 PC, medium confidence
; After a goal checks the scorer's season/game totals (hmtmtouch1,
; hmplstats.., plcareergoals/7C/80): hat trick (3), first goal, 50 goals, 100
; points/goals multiples; queues the note with QueueDeferredCall and sets
; deferpending
;-----------------------------------------------------------------------------
ChkScorerMilestone:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edx, dword [pucky]
        cmp word [edx], byte 0
        setl dl
        mov ebp, edx
        and ebp, 0FFh
        test byte [gmode], 2
        setne dl
        and edx, 0FFh
        xor ebp, edx
        lea edx, [byte ebp+ebp+00h]
        cmp byte [dword edx+milestonesaid], 0
        je short .1
        cmp byte [dword edx+milestonesaid_b1], 0
        jne near .17
.1:
        xor esi, esi
        mov edx, ebp
        shl edx, 8
        mov dx, word [dword edx+hmtmtouch1]
        xor dh, dh
        movsx edi, dx
        cmp edi, byte 19h
        jge near .10
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        lea ebx, [edx+ebp]
        shl ebx, 4
        mov edx, edi
        shl edx, 4
        add edx, ebx
        mov ecx, dword [dword edx+hmplstats-2]
        sar ecx, 10h
        mov ebx, dword [dword edx+hmplstats_w2-2]
        sar ebx, 10h
        add ebx, ecx
        cmp ecx, byte 3
        jne short .3
        mov esi, 1
.2:
        mov ebx, ecx
        jmp near .10
.3:
        cmp dword [gamemode], byte 0
        je near .10
        test byte [gameopts+1], 2
        je near .8
        mov eax, dword [dword edx+plseasongoals]
        mov dword [esp], eax
        mov eax, dword [dword edx+plcareergoals]
        add dword [esp], eax
        mov eax, dword [esp]
        add eax, ecx
        cmp eax, byte 1
        jne short .4
        mov esi, 6
        mov ebx, eax
        jmp near .10
.4:
        add ecx, dword [dword edx+plseasongoals]
        cmp ecx, byte 32h
        jl short .5
        mov dword [esp], 32h
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv dword [esp]
        test edx, edx
        jne short .5
        mov esi, 2
        jmp short ChkScorerMilestone.2
.5:
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        add edx, ebp
        shl edx, 4
        mov dword [esp], edx
        mov edx, edi
        shl edx, 4
        add edx, dword [esp]
        add ebx, dword [dword edx+plseasonpts]
        cmp ebx, byte 64h
        jl short .6
        mov dword [esp], 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv dword [esp]
        test edx, edx
        jne short .6
        mov esi, 4
        jmp near .10
.6:
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        add edx, ebp
        shl edx, 4
        mov eax, edi
        shl eax, 4
        add edx, eax
        add ecx, dword [dword edx+plcareergoals]
        cmp ecx, byte 64h
        jl short .7
        mov dword [esp], 64h
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv dword [esp]
        test edx, edx
        jne short .7
        mov esi, 3
        jmp near ChkScorerMilestone.2
.7:
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        add edx, ebp
        shl edx, 4
        mov ecx, edi
        shl ecx, 4
        add ebx, dword [dword ecx+edx+plcareerpts]
        cmp ebx, byte 64h
        jl near .10
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .10
        mov esi, 5
        jmp short .10
.8:
        add ecx, dword [dword edx+plseasongoals]
        cmp ecx, byte 0Ah
        jl short .9
        mov dword [esp], 0Ah
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv dword [esp]
        test edx, edx
        jne short .9
        mov esi, 7
        jmp near ChkScorerMilestone.2
.9:
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        lea ecx, [edx+ebp]
        shl ecx, 4
        mov edx, edi
        shl edx, 4
        add ebx, dword [dword ecx+edx+plseasonpts]
        cmp ebx, byte 14h
        jl short .10
        mov ecx, 14h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .10
        mov esi, 8
.10:
        cmp dword [gamemode], byte 0
        je near .16
        test esi, esi
        jne near .16
        mov edi, ebp
        shl edi, 8
        mov edi, dword [dword edi+hmtmtouch2-2]
        sar edi, 10h
        test edi, edi
        jl near .16
        cmp edi, byte 19h
        jge near .16
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        lea ebx, [edx+ebp]
        shl ebx, 4
        mov edx, edi
        shl edx, 4
        add edx, ebx
        mov ecx, dword [dword edx+hmplstats_w2-2]
        sar ecx, 10h
        mov ebx, dword [dword edx+hmplstats-2]
        sar ebx, 10h
        add ebx, ecx
        test byte [gameopts+1], 2
        je short .12
        add ebx, dword [dword edx+plseasonpts]
        cmp ebx, byte 64h
        jl short .11
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .11
        mov esi, 4
        jmp short .13
.11:
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        add edx, ebp
        shl edx, 4
        mov ecx, edi
        shl ecx, 4
        add ebx, dword [dword ecx+edx+plcareerpts]
        cmp ebx, byte 64h
        jl short .13
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .13
        mov esi, 5
        jmp short .13
.12:
        add ebx, dword [dword edx+plseasonpts]
        cmp ebx, byte 14h
        jl short .13
        mov ecx, 14h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .13
        mov esi, 8
.13:
        test esi, esi
        jne near .16
        mov edi, ebp
        shl edi, 8
        mov edi, dword [dword edi+hmtmtouch3-2]
        sar edi, 10h
        test edi, edi
        jl near .16
        cmp edi, byte 19h
        jge near .16
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        lea ebx, [edx+ebp]
        shl ebx, 4
        mov edx, edi
        shl edx, 4
        add edx, ebx
        mov ecx, dword [dword edx+hmplstats_w2-2]
        sar ecx, 10h
        mov ebx, dword [dword edx+hmplstats-2]
        sar ebx, 10h
        add ebx, ecx
        test byte [gameopts+1], 2
        je short .15
        add ebx, dword [dword edx+plseasonpts]
        cmp ebx, byte 64h
        jl short .14
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .14
        mov esi, 4
        jmp short .16
.14:
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        shl edx, 3
        lea ecx, [edx+ebp]
        shl ecx, 4
        mov edx, edi
        shl edx, 4
        add ebx, dword [dword ecx+edx+plcareerpts]
        cmp ebx, byte 64h
        jl short .16
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .16
        mov esi, 5
        jmp short .16
.15:
        add ebx, dword [dword edx+plseasonpts]
        cmp ebx, byte 14h
        jl short .16
        mov ecx, 14h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .16
        mov esi, 8
.16:
        test esi, esi
        je short .17
        push byte 0
        push byte 0
        push byte 0
        push ebx
        mov ecx, esi
        mov ebx, edi
        mov edx, ebp
        mov eax, MenuCallbackTrue2
        call QueueDeferredCall
        mov dword [deferpending], 1
        mov word [ovltimer], 0FFFFh
.17:
        add esp, byte 4
        jmp near fileio_popebpx
;-----------------------------------------------------------------------------
; QueueGoalieNote                                 62C37  95 PC, low confidence
; Once per goalie (bit mask goalienotebits, 3Fh = all done): queues a
; deferred note for the goalie of the team of player penaltysc and sets
; deferpending
;-----------------------------------------------------------------------------
; C: src/engine/gamelog/QueueGoalieNote.c
%ifdef CBUILD
%include "c/engine/gamelog/QueueGoalieNote.inc"
%else
QueueGoalieNote:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [goalienotebits], byte 3Fh
        jne short .2
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        cmp word [penaltysc], byte 0
        jl short QueueGoalieNote.1
        mov eax, dword [penaltysc-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        test byte [byte eax+044h], 40h
        setne dl
        xor ebx, ebx
        mov bl, dl
        mov esi, ebx
        mov edx, dword [byte eax+06Ch]
        mov ecx, dword [byte edx+tmgoalie-2]
        sar ecx, 10h
        mov edx, 1
        shl edx, cl
        test ebx, ebx
        je short .3
        shl edx, 3
.3:
        mov ebx, dword [goalienotebits]
        test edx, ebx
        jne short QueueGoalieNote.1
        mov ecx, ebx
        or ecx, edx
        mov dword [goalienotebits], ecx
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ebx, dword [byte eax+044h]
        sar ebx, 18h
        xor ecx, ecx
        mov edx, esi
        mov eax, MenuCallbackTrue
        call QueueDeferredCall
        mov dword [deferpending], 1
        mov eax, 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
