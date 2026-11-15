; The debug monitor and the stats.log dump of both teams and every player.
bits 32
%include "hockey.inc"
section s_688A4 progbits alloc exec nowrite align=1
extern __CHK, AllInPlace, awgoalcnt, awscore, awshotcnt, awtmap, awtmgoalie, awtmplstats
extern awtmstruct, bailout_vec, c1playernum, c2playernum, camx, camx_m2, camy, clockticks
extern cont1team, cont2team, dbg_assnames, dbg_posnames, dbg_spalist, dbg_spanames, DebugPrintf, debugstep
extern PenBuf_m2, exitgame, fclose_, fopen_, fprintf_, frameaccum, gameclock, gamemode
extern gameover, gmode, gmode2, gsp, hmgoalcnt, hmscore, hmshotcnt, hmtmap
extern hmtmgoalie, hmtmpdst_m2, hmtmplstats, hmtmstruct, hudhundaccum, joyq_flush, Penaltytimer, PenBuf
extern PenBuf_pl, Pencntdwn, penshotctl, penshotlive, penshotmode, penshotplayer, penshotpnum, penshotstart
extern penshotteam, penshottimer, PollKey, psendcount, puckc, puckvz, refsignal, RefStep
extern sflags3, shotongoal, shotontarget, SortCords, sprintf_, str_dbgAss, str_dbgBail, str_dbgC12
extern str_dbgClin, str_dbgD, str_dbgDash, str_dbgDRb, str_dbgDS, str_dbgG, str_dbgGO, str_dbgGsp
extern str_dbgHVpos, str_dbgI, str_dbgIdx, str_dbgL, str_dbgLbD, str_dbgLip, str_dbgO, str_dbgPb
extern str_dbgPenShot, str_dbgPosVel, str_dbgPuckc, str_dbgRef, str_dbgS, str_dbgSpa, str_dbgSpace, str_dbgVz
extern str_debError, str_dumpAway, str_dumpGlHdrA, str_dumpGlHdrH, str_dumpGlLine, str_dumpHex, str_dumpHome, str_dumpPlHdrA
extern str_dumpPlHdrH, str_dumpPlLineA, str_dumpPlLineH, str_dumpPool, str_dumpRule, str_dumpSortcords, str_dumpSortLine, str_dumpTeamHdrA
extern str_dumpTeamHdrH, str_dumpTmstructs, str_ErrDumpStats, str_fmode_at, str_newline, str_pen, str_statslog, sub_93E38
extern threat, VisTeam, WaitKey, word_CBC44, xc1, yc1
global DebugMonitor, DebugMonitor_pop, DumpStatsLog
;-----------------------------------------------------------------------------
; DebugMonitor                                 688A4  95 PC, medium confidence
; Unreferenced PC debug monitor: when debugstep is set prints a state line
; per frame through DebugPrintf (clin=, ps<>, HVpos<>, ref<>, pb[],
; puckc/gmclock) and one line per SortCords object (17 entries, skipping
; 0Ch/0Dh/0Fh); flags 'debError' on a bad SPA/SCnum; then reads a key: '0'
; bail, 'm' sub_93E38, 'd' DumpStatsLog("stats.log"), '\' toggles debugstep
;-----------------------------------------------------------------------------
; C: src/pc/debug_dump/DebugMonitor.c
%ifdef CBUILD
%include "c/pc/debug_dump/DebugMonitor.inc"
%else
DebugMonitor:
        push dword 250h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 200h
        sub ebp, 27Eh
        cmp word [debugstep], byte 0
        je near .readkey
        test byte [gmode2], 80h
        je short .1
        push str_dbgO
        jmp short .2
.1:
        push str_dbgDash
.2:
        call DebugPrintf
        add esp, byte 4
        xor dl, dl
        mov byte [byte ebp+07Eh], dl
        mov eax, dword [awtmstruct+tmline-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmstruct+tmline-2]
        sar eax, 10h
        push eax
        push str_dbgClin
        lea eax, [byte ebp+07Eh]
        push eax
        call sprintf_
        add esp, byte 10h
        mov esi, eax
        mov edx, dword [shotongoal]
        push edx
        mov ebx, dword [shotontarget]
        push ebx
        mov ecx, dword [penshotctl]
        push ecx
        mov edi, dword [penshotteam]
        push edi
        mov eax, dword [penshotpnum]
        push eax
        mov edx, dword [penshotplayer]
        push edx
        mov ebx, dword [psendcount]
        push ebx
        mov ecx, dword [penshottimer]
        push ecx
        mov edi, dword [penshotstart]
        push edi
        mov eax, dword [penshotlive]
        push eax
        mov edx, dword [penshotmode]
        push edx
        push str_dbgPenShot
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 34h
        add esi, eax
        call AllInPlace
        push eax
        push str_dbgLip
        call DebugPrintf
        add esp, byte 8
        mov eax, dword [yc1-2]
        sar eax, 10h
        push eax
        mov eax, dword [xc1-2]
        sar eax, 10h
        push eax
        mov eax, dword [camy-2]
        sar eax, 10h
        push eax
        mov eax, dword [camx-2]
        sar eax, 10h
        push eax
        push str_dbgHVpos
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 18h
        add esi, eax
        mov eax, dword [refsignal-2]
        sar eax, 10h
        push eax
        mov eax, dword [RefStep-2]
        sar eax, 10h
        push eax
        push str_dbgRef
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 10h
        add esi, eax
        mov eax, dword [PenBuf_pl-3]
        sar eax, 18h
        push eax
        mov eax, dword [PenBuf-3]
        sar eax, 18h
        push eax
        push str_dbgPb
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 10h
        add esi, eax
        mov eax, dword [awtmgoalie-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmgoalie-2]
        sar eax, 10h
        push eax
        push str_dbgG
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 10h
        add esi, eax
        mov dh, byte [gmode]
        test dh, 80h
        setne al
        and eax, 0FFh
        push eax
        test dh, 40h
        setne al
        and eax, 0FFh
        push eax
        mov eax, dword [exitgame-2]
        sar eax, 10h
        push eax
        mov eax, dword [gameover-2]
        sar eax, 10h
        push eax
        push str_dbgGO
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 18h
        add esi, eax
        mov eax, dword [clockticks-2]
        sar eax, 10h
        push eax
        mov eax, dword [gameclock-2]
        sar eax, 10h
        push eax
        push str_dbgGsp
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 10h
        add esi, eax
        mov eax, dword [cont2team-2]
        sar eax, 10h
        push eax
        mov eax, dword [cont1team-2]
        sar eax, 10h
        push eax
        mov eax, dword [c2playernum-2]
        sar eax, 10h
        push eax
        mov eax, dword [c1playernum-2]
        sar eax, 10h
        push eax
        push str_dbgC12
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 18h
        add esi, eax
        mov eax, dword [Pencntdwn-2]
        sar eax, 10h
        push eax
        mov bh, byte [gmode]
        test bh, 4
        setne al
        and eax, 0FFh
        push eax
        test bh, 1
        setne al
        and eax, 0FFh
        push eax
        mov eax, dword [puckc]
        movsx eax, byte [eax]
        push eax
        push str_dbgPuckc
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 18h
        lea eax, [byte ebp+07Eh]
        push eax
        call DebugPrintf
        add esp, byte 4
        xor edi, edi
        jmp near .17
.objloop:
        cmp di, byte 0Ch
        je near .16
        cmp di, byte 0Dh
        je near .16
        cmp di, byte 0Fh
        je near .16
        movsx edx, di
        shl edx, 7
        add edx, SortCords
        xor ch, ch
        mov byte [byte ebp+07Eh], ch
        mov eax, dword [byte edx+temp5-2]
        sar eax, 10h
        push eax
        push str_dbgIdx
        lea eax, [byte ebp+07Eh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov esi, eax
        xor eax, eax
        mov al, byte [byte edx+05Eh]
        push eax
        push str_dbgD
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 0Ch
        add esi, eax
        mov eax, dword [byte edx+044h]
        sar eax, 18h
        push eax
        push str_dbgD
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 0Ch
        add esi, eax
        test byte [byte edx+pflags], 40h
        setne al
        mov ebx, eax
        and ebx, 0FFh
        shl ebx, 8
        mov eax, dword [byte edx+044h]
        sar eax, 18h
        mov eax, dword [dword ebx+eax*2+hmtmpdst_m2]
        sar eax, 10h
        push eax
        push str_dbgD
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 0Ch
        add esi, eax
        mov eax, dword [byte edx+040h]
        sar eax, 18h
        push eax
        push str_dbgLbD
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 0Ch
        add esi, eax
        mov eax, dword [byte edx+03Fh]
        sar eax, 18h
        push eax
        push str_dbgDRb
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 0Ch
        add esi, eax
        cmp word [byte edx+position], byte 0
        jl short .4
        mov eax, dword [byte edx+position-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+dbg_posnames]
        jmp short .5
.4:
        mov eax, str_pen
.5:
        push eax
        movsx eax, di
        push eax
        push str_dbgDS
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 10h
        add esi, eax
        mov eax, dword [byte edx+temp4-2]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+temp3-2]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+facedir-2]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+Yvel-2]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+Xvel-2]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        push eax
        mov eax, dword [edx]
        sar eax, 10h
        push eax
        push str_dbgPosVel
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 24h
        add esi, eax
        cmp di, byte 0Eh
        jne short .6
        mov eax, dword [puckvz]
        movsx eax, word [eax]
        push eax
        push str_dbgVz
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 0Ch
        add esi, eax
.6:
        mov eax, dword [byte edx+assnum-2]
        sar eax, 10h
        mov eax, dword [byte edx+eax+01Bh]
        sar eax, 18h
        mov ebx, dword [nosplit eax*4+dbg_assnames]
        push ebx
        push str_dbgAss
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 0Ch
        add esi, eax
        test byte [byte edx+pflags], 20h
        je short .7
        push str_dbgL
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 8
        add esi, eax
.7:
        test byte [byte edx+pflags2], 2
        je short .8
        push str_dbgI
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 8
        add esi, eax
.8:
        push str_dbgSpace
        lea eax, [byte ebp+07Eh]
        add eax, esi
        push eax
        call sprintf_
        add esp, byte 8
        add esi, eax
        xor eax, eax
        jmp short .10
.9:
        movsx ebx, ax
        mov ecx, dword [byte edx+SPA-2]
        sar ecx, 10h
        cmp ecx, dword [nosplit ebx*4+dbg_spalist]
        je short .11
        inc eax
.10:
        cmp ax, 78h
        jl short DebugMonitor.9
.11:
        lea ebx, [byte ebp+07Eh]
        add ebx, esi
        cmp ax, 78h
        jl short .12
        mov eax, dword [byte edx+SPA-2]
        sar eax, 10h
        push eax
        push str_dbgSpa
        jmp short .13
.12:
        cwde
        mov ecx, dword [nosplit eax*4+dbg_spanames]
        push ecx
        push str_dbgS
.13:
        push ebx
        call sprintf_
        add esp, byte 0Ch
        add esi, eax
        mov eax, dword [byte edx+010h]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jl short .14
        cmp word [byte edx+012h], 46Eh
        jl short .15
.14:
        mov eax, dword [byte edx+010h]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+SCnum-2]
        sar eax, 10h
        push eax
        push str_debError
        lea eax, [byte ebp+07Eh]
        add esi, eax
        push esi
        call sprintf_
        add esp, byte 10h
        lea eax, [byte ebp+07Eh]
        push eax
        call DebugPrintf
        add esp, byte 4
        call WaitKey
        jmp short .16
.15:
        push str_newline
        lea eax, [byte ebp+07Eh]
        add esi, eax
        push esi
        call sprintf_
        add esp, byte 8
        lea eax, [byte ebp+07Eh]
        push eax
        call DebugPrintf
        add esp, byte 4
.16:
        inc edi
.17:
        cmp di, byte 11h
        jl near DebugMonitor.objloop
.readkey:
        cmp word [debugstep], byte 0
        je short .19
        call WaitKey
        jmp short .20
.19:
        call PollKey
.20:
        cmp ax, 30h
        jne short .21
        push str_dbgBail
        call DebugPrintf
        add esp, byte 4
        call dword [bailout_vec]
        jmp short .done
.21:
        cmp ax, 6Dh
        jne short .22
        call sub_93E38
        jmp short .done
.22:
        cmp ax, 64h
        jne short .23
        mov eax, str_statslog
        call DumpStatsLog
        jmp short .done
.23:
        cmp ax, 5Ch
        jne short .done
        cmp word [debugstep], byte 0
        je short .24
        call joyq_flush
.24:
        cmp word [debugstep], byte 0
        sete al
        xor ah, ah
        mov word [debugstep], ax
.done:
        lea esp, [dword ebp+027Eh]
DebugMonitor_pop:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DumpStatsLog                                                    68E7B  95 PC
; Fopen(name,"a+t") ('error dump stats' on failure), then fprintf of pool/gm
; header, both team structs (E8h bytes), SortCords (11h x 48h bytes and a
; field line), team stat lines (shts score ppg pp pen penmin atop pass
; passcomp), skater and goalie stat tables; called by DebugMonitor with
; "stats.log"
;-----------------------------------------------------------------------------
; C: src/pc/debug_dump/DebugMonitor.c (DumpStatsLog)
%ifdef CBUILD
%include "c/pc/debug_dump/DebugMonitor.DumpStatsLog.inc"
%else
DumpStatsLog:
        push dword 74h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edx, str_fmode_at
        call fopen_
        mov ebx, eax
        mov ecx, eax
        test eax, eax
        jne short .opened
        push str_ErrDumpStats
        call DebugPrintf
        add esp, byte 4
        jmp near .exit
.opened:
        mov edx, dword [gamemode]
        push edx
        mov esi, dword [frameaccum]
        push esi
        mov edi, dword [hudhundaccum]
        push edi
        push str_dumpPool
        push eax
        call fprintf_
        add esp, byte 14h
        push str_dumpTmstructs
        push ebx
        call fprintf_
        add esp, byte 8
        xor esi, esi
        jmp short .5
.2:
        movsx eax, si
        shl eax, 8
        mov ebx, hmtmstruct
        add ebx, eax
        xor edx, edx
        jmp short .4
.3:
        mov ebp, dword [ebx]
        push ebp
        push str_dumpHex
        push ecx
        add ebx, byte 4
        call fprintf_
        add esp, byte 0Ch
        add edx, byte 4
.4:
        movsx eax, dx
        cmp eax, 0E8h
        jb short DumpStatsLog.3
        push str_newline
        push ecx
        call fprintf_
        add esp, byte 8
        inc esi
.5:
        cmp si, byte 2
        jl short DumpStatsLog.2
        push str_dumpSortcords
        push ecx
        call fprintf_
        add esp, byte 8
        xor esi, esi
        jmp short .9
.6:
        movsx ebx, si
        shl ebx, 7
        add ebx, SortCords
        xor edx, edx
        jmp short .8
.7:
        movsx eax, word [ebx]
        push eax
        push str_dumpHex
        push ecx
        add ebx, byte 2
        call fprintf_
        add esp, byte 0Ch
        add edx, byte 2
.8:
        cmp dx, byte 48h
        jl short DumpStatsLog.7
        push str_newline
        push ecx
        call fprintf_
        add esp, byte 8
        inc esi
.9:
        cmp si, byte 11h
        jl short DumpStatsLog.6
        xor esi, esi
        jmp near .11
.10:
        movsx eax, si
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        mov eax, dword [byte ebx+052h]
        sar eax, 10h
        push eax
        xor eax, eax
        mov al, byte [byte ebx+063h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+062h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+05Dh]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+05Fh]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+061h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+05Ch]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+060h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+064h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+065h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+05Bh]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+05Ah]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+059h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+058h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+057h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+056h]
        push eax
        xor eax, eax
        mov al, byte [byte ebx+05Eh]
        push eax
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        push eax
        mov eax, dword [byte ebx+068h]
        sar eax, 10h
        push eax
        push str_dumpSortLine
        push ecx
        call fprintf_
        add esp, byte 54h
        inc esi
.11:
        cmp si, byte 11h
        jl near DumpStatsLog.10
        mov esi, hmtmstruct
        push str_dumpRule
        push ecx
        call fprintf_
        add esp, byte 8
        push str_dumpTeamHdrH
        push ecx
        call fprintf_
        add esp, byte 8
        mov eax, dword [hmtmstruct+tmpasscomp-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmstruct+tmpass-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmstruct+tmATOP-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmstruct+tmpenmin-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmstruct+tmpen-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmstruct+tmpp-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmstruct+tmppg-2]
        sar eax, 10h
        push eax
        xor eax, eax
        mov al, byte [hmgoalcnt]
        push eax
        xor eax, eax
        mov al, byte [hmshotcnt]
        push eax
        mov eax, dword [hmscore-2]
        sar eax, 10h
        push eax
        mov eax, dword [hmtmstruct+tmshots-2]
        sar eax, 10h
        push eax
        push str_dumpHome
        push ecx
        call fprintf_
        add esp, byte 34h
        mov ebx, dword [hmtmplstats]
        push str_dumpPlHdrH
        push ecx
        call fprintf_
        add esp, byte 8
        xor edx, edx
        jmp short .13
.12:
        movsx ebp, dx
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 3
        sub eax, ebp
        mov dword [esp], eax
        mov eax, dword [dword esi+tmroster]
        add eax, dword [esp]
        movzx edi, byte [eax]
        push edi
        mov edi, dword [byte ebx+0Ch]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+0Ah]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+08h]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+06h]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+04h]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+02h]
        sar edi, 10h
        push edi
        mov edi, dword [ebx]
        sar edi, 10h
        push edi
        movsx edi, word [ebx]
        push edi
        mov al, byte [byte eax+05h]
        and eax, 0FFh
        push eax
        push ebp
        push str_dumpPlLineH
        push ecx
        call fprintf_
        add esp, byte 34h
        add ebx, byte 10h
        inc edx
.13:
        cmp dx, byte 19h
        jl short DumpStatsLog.12
        mov ebx, dword [dword esi+tmglstats]
        push str_dumpGlHdrH
        push ecx
        call fprintf_
        add esp, byte 8
        xor edx, edx
        jmp short .15
.14:
        movsx ebp, dx
        lea edi, [byte ebp+019h]
        mov eax, edi
        shl eax, 2
        add eax, edi
        shl eax, 3
        sub eax, edi
        mov dword [esp], eax
        mov eax, dword [dword esi+tmroster]
        add eax, dword [esp]
        movzx edi, byte [eax]
        push edi
        mov edi, dword [byte ebx+02h]
        sar edi, 10h
        push edi
        mov edi, dword [ebx]
        sar edi, 10h
        push edi
        movsx edi, word [ebx]
        push edi
        mov al, byte [byte eax+05h]
        and eax, 0FFh
        push eax
        push ebp
        push str_dumpGlLine
        push ecx
        call fprintf_
        add esp, byte 20h
        add ebx, byte 6
        inc edx
.15:
        cmp dx, byte 3
        jl short DumpStatsLog.14
        mov esi, awtmstruct
        push str_dumpTeamHdrA
        push ecx
        call fprintf_
        add esp, byte 8
        mov eax, dword [awtmstruct+tmpasscomp-2]
        sar eax, 10h
        push eax
        mov eax, dword [awtmstruct+tmpass-2]
        sar eax, 10h
        push eax
        mov eax, dword [awtmstruct+tmATOP-2]
        sar eax, 10h
        push eax
        mov eax, dword [awtmstruct+tmpenmin-2]
        sar eax, 10h
        push eax
        mov eax, dword [awtmstruct+tmpen-2]
        sar eax, 10h
        push eax
        mov eax, dword [awtmstruct+tmpp-2]
        sar eax, 10h
        push eax
        mov eax, dword [awtmstruct+tmppg-2]
        sar eax, 10h
        push eax
        xor eax, eax
        mov al, byte [awgoalcnt]
        push eax
        xor eax, eax
        mov al, byte [awshotcnt]
        push eax
        mov eax, dword [awscore-2]
        sar eax, 10h
        push eax
        mov eax, dword [awtmstruct+tmshots-2]
        sar eax, 10h
        push eax
        push str_dumpAway
        push ecx
        call fprintf_
        add esp, byte 34h
        mov ebx, dword [awtmplstats]
        push str_dumpPlHdrA
        push ecx
        call fprintf_
        add esp, byte 8
        xor edx, edx
        jmp short .17
.16:
        movsx ebp, dx
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 3
        sub eax, ebp
        mov dword [esp], eax
        mov eax, dword [dword esi+tmroster]
        add eax, dword [esp]
        movzx edi, byte [eax]
        push edi
        mov edi, dword [byte ebx+0Ch]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+0Ah]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+08h]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+06h]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+04h]
        sar edi, 10h
        push edi
        mov edi, dword [byte ebx+02h]
        sar edi, 10h
        push edi
        mov edi, dword [ebx]
        sar edi, 10h
        push edi
        movsx edi, word [ebx]
        push edi
        mov al, byte [byte eax+05h]
        and eax, 0FFh
        push eax
        push ebp
        push str_dumpPlLineA
        push ecx
        call fprintf_
        add esp, byte 34h
        add ebx, byte 10h
        inc edx
.17:
        cmp dx, byte 19h
        jl short DumpStatsLog.16
        mov ebx, dword [dword esi+tmglstats]
        push str_dumpGlHdrA
        push ecx
        call fprintf_
        add esp, byte 8
        xor edx, edx
        jmp short .19
.18:
        movsx ebp, dx
        lea edi, [byte ebp+019h]
        mov eax, edi
        shl eax, 2
        add eax, edi
        shl eax, 3
        sub eax, edi
        mov edi, dword [dword esi+tmroster]
        add eax, edi
        movzx edi, byte [eax]
        push edi
        mov edi, dword [byte ebx+02h]
        sar edi, 10h
        push edi
        mov edi, dword [ebx]
        sar edi, 10h
        push edi
        movsx edi, word [ebx]
        push edi
        mov al, byte [byte eax+05h]
        and eax, 0FFh
        push eax
        push ebp
        push str_dumpGlLine
        push ecx
        call fprintf_
        add esp, byte 20h
        add ebx, byte 6
        inc edx
.19:
        cmp dx, byte 3
        jl short DumpStatsLog.18
        mov eax, ecx
        call fclose_
.exit:
        add esp, byte 4
        jmp near DebugMonitor_pop
%endif ; C
