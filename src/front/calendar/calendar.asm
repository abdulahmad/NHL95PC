; The league calendar, stepping to the next or previous month, playing a league game, posting the result
; into the team files, and the team grid used while setting a league up.
bits 32
%include "hockey.inc"
section s_33FFD progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, calcolx, calendarshapes, calexit, CalGoalieStatsScreen, calmenubar, calmonth
extern calnextslot, calprevslot, calredraw, calrowy, calsel, calselday, calselmonth, CalSkaterStatsScreen
extern CalStandingsMenu, CalStandingsScreen, CalTeamStatsScreen, cddriveptr, ClearInputQueue, ClearScreen, crestnames, DrawArt
extern DrawBitmap, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, FadeOutPalCycle, FadePalStep, FileClose
extern fileoncd, FileOpenRead, FileReadAt, FindShape, fontcolor, fputchar, FreeMemBlock, GameGoalieStatsScreen
extern gameopts, GameSkaterStatsScreen, GameStandingsMenu, GameStandingsScreen, GameTeamStatsScreen, GetInputEvent, goaliestatscb, GrabBlock
extern leaguedbnames, lgteam_17, LoadBank, mainfont, MakePath, MenuHitTest, monthdays, monthfirstday
extern monthfirstday_m1, MouseRead, MouseSetPos, musichandle, musicon, musicslot, pointerspr, PrintString
extern ptrupdatefn, PutBlock, ReadSchedGame, savepal, SetClipWindow, SetColorRemap, SetCtlTeams, SetDialogColors
extern SetPalette, ShowLoadingScreen, skaterstatscb, SndQuery, songdata, sprintf_, standingscb, standingsmenucb
extern str_02d9D, str_Away, str_Bkgd7, str_Boxb, str_Boxr, str_Calendar, str_Callogo, str_D8
extern str_Home, str_Iff9, str_L7, str_Menubuff5, str_Pal17, str_Pointer8, str_SDD2, str_T5
extern str_W5, sub_8D2F0, sub_8F98F, sub_8FB8E, sub_8FCDF, sub_913D0, sub_B4BA8, sub_B4FAC
extern teamstatscb, TextRestoreState, TextSaveState, TextSetFont
global DrawCalendarDay, CalNextMonth, CalPrevMonth, CalReturn, ApplyShapePalette, SetGameSides, CalendarScreen
;-----------------------------------------------------------------------------
; DrawCalendarDay                              33FFD  95 PC, medium confidence
; Draws one calendar day box (boxr / boxb) at calcolx / calrowy: day number,
; opponent crest, Home / Away and the W / L / T "%s:%d-%d" result
;-----------------------------------------------------------------------------
DrawCalendarDay:
        push dword 0CCh
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 9Ch
        push eax
        push edx
        push ecx
        mov esi, dword [dword esp+0C4h]
        push str_Boxr
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+084h], eax
        push str_Boxb
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+094h], eax
        push str_Bkgd7
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        mov edx, dword [byte esp+08h]
        cmp edx, byte 9
        setl al
        and eax, 0FFh
        add eax, byte 3
        push eax
        lea eax, [byte edx+01h]
        push eax
        push str_02d9D
        lea eax, [byte esp+058h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea eax, [byte esp+04Ch]
        push eax
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        mov ecx, dword [dword esp+0BCh]
        shl ecx, 2
        mov ebx, dword [dword ecx+crestnames]
        mov byte [byte esp+04Ch], 21h
        mov al, byte [ebx]
        mov byte [byte esp+04Dh], al
        mov al, byte [byte ebx+01h]
        mov byte [byte esp+04Eh], al
        mov al, byte [byte ebx+02h]
        mov byte [byte esp+04Fh], al
        push byte 3Fh
        push byte 26h
        add ecx, dword [byte esp+0Ch]
        mov esi, dword [ecx]
        push esi
        call sub_913D0
        add esp, byte 0Ch
        lea eax, [byte esp+0Ch]
        push eax
        call TextSaveState
        add esp, byte 4
        mov edi, dword [dword esp+0C0h]
        push edi
        call TextSetFont
        add esp, byte 4
        mov dword [fontcolor], 0C0h
        mov eax, dword [byte esp+08h]
        cmp byte [dword eax+monthfirstday], 0
        je short .1
        mov esi, dword [calcolx]
        add esi, byte 7
        mov edi, dword [calrowy]
        jmp short .2
.1:
        mov esi, dword [calcolx+18h]
        add esi, byte 7
        mov edi, dword [calrowy+14h]
.2:
        add edi, byte 5
        mov dword [fontcolor], 0B6h
        push edi
        push esi
        push str_Home
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0B7h
        add edi, byte 0Ch
        push edi
        push esi
        push str_Away
        call PrintString
        add esp, byte 0Ch
        xor ebp, ebp
        jmp near .4
.3:
        xor ebx, ebx
        mov eax, dword [byte esp+08h]
        mov bl, byte [dword eax+monthfirstday]
        add ebx, ebp
        mov esi, 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        mov esi, edx
        mov ecx, 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov esi, dword [nosplit esi*4+calcolx]
        add esi, byte 4
        mov edi, dword [nosplit eax*4+calrowy]
        inc edi
        inc ebp
        push ebp
        push str_D8
        lea eax, [byte esp+054h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov dword [fontcolor], 0C0h
        push edi
        push esi
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0FFh
        dec edi
        push edi
        dec esi
        push esi
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
.4:
        xor eax, eax
        mov ebx, dword [byte esp+08h]
        mov al, byte [dword ebx+monthdays]
        cmp ebp, eax
        jl near DrawCalendarDay.3
        mov dword [dword esp+098h], 0FFFFFFFFh
        xor ebp, ebp
        jmp near .18
.5:
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        add ebx, ebx
        add ebx, dword [esp]
        xor ecx, ecx
        mov cl, byte [ebx]
        mov eax, dword [byte esp+08h]
        inc eax
        cmp ecx, eax
        jne near .17
        xor ecx, eax
        mov cl, byte [byte ebx+01h]
        xor eax, eax
        mov esi, dword [byte esp+08h]
        mov al, byte [dword esi+monthfirstday]
        add eax, ecx
        lea esi, [byte eax-01h]
        mov ecx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov edi, edx
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov esi, edi
        mov esi, dword [nosplit esi*4+calcolx]
        mov edi, dword [nosplit eax*4+calrowy]
        xor eax, eax
        mov al, byte [byte ebx+02h]
        cmp eax, dword [dword esp+0BCh]
        jne short .10
        mov eax, dword [dword esp+084h]
        mov dword [dword esp+09Ch], eax
        xor eax, eax
        mov al, byte [byte ebx+03h]
        mov dword [dword esp+0A4h], eax
        mov al, byte [byte ebx+04h]
        mov ch, byte [byte ebx+05h]
        cmp al, ch
        jbe short .7
        xor eax, eax
        mov al, ch
        push eax
        xor eax, eax
        mov al, byte [byte ebx+04h]
.6:
        push eax
        push str_W5
        jmp near .13
.7:
        jae short .9
        xor eax, eax
        mov al, ch
        push eax
        xor eax, eax
        mov al, byte [byte ebx+04h]
.8:
        push eax
        push str_L7
        jmp short .13
.9:
        xor eax, eax
        mov al, ch
        push eax
        xor eax, eax
        mov al, byte [byte ebx+04h]
        push eax
        push str_T5
        jmp short .13
.10:
        mov ecx, dword [dword esp+094h]
        mov dword [dword esp+09Ch], ecx
        mov dword [dword esp+0A4h], eax
        mov al, byte [byte ebx+04h]
        mov dh, byte [byte ebx+05h]
        cmp al, dh
        jbe short .11
        xor eax, eax
        mov al, byte [byte ebx+04h]
        push eax
        xor eax, eax
        mov al, dh
        jmp short DrawCalendarDay.8
.11:
        jae short .12
        xor eax, eax
        mov al, byte [byte ebx+04h]
        push eax
        xor eax, eax
        mov al, dh
        jmp short DrawCalendarDay.6
.12:
        xor eax, eax
        mov al, dh
        push eax
        xor eax, eax
        mov al, byte [byte ebx+04h]
        push eax
        push str_T5
.13:
        push str_SDD2
        lea eax, [byte esp+07Ch]
        push eax
        call sprintf_
        add esp, byte 14h
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        add ebx, ebx
        mov eax, dword [esp]
        add eax, ebx
        mov dword [dword esp+0A0h], eax
        cmp byte [byte eax+04h], 0FFh
        je short .14
        cmp byte [byte eax+05h], 0FFh
        jne near .15
.14:
        push edi
        push esi
        mov edx, dword [dword esp+0A4h]
        push edx
        call DrawArt
        add esp, byte 0Ch
        push edi
        push esi
        mov eax, dword [dword esp+0ACh]
        shl eax, 2
        add eax, dword [byte esp+0Ch]
        mov ecx, dword [eax]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        mov eax, dword [esp]
        mov al, byte [byte eax+ebx*2+01h]
        and eax, 0FFh
        push eax
        push str_D8
        lea eax, [byte esp+054h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov dword [fontcolor], 0FFh
        lea eax, [byte edi+01h]
        push eax
        lea eax, [byte esi+04h]
        push eax
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0C0h
        push edi
        add esi, byte 3
        push esi
        lea eax, [byte esp+054h]
        jmp near .16
.15:
        push edi
        push esi
        mov eax, dword [dword esp+0ACh]
        shl eax, 2
        add eax, dword [byte esp+0Ch]
        mov ecx, dword [eax]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        xor eax, eax
        mov ebx, dword [dword esp+0A0h]
        mov al, byte [byte ebx+01h]
        push eax
        push str_D8
        lea eax, [byte esp+054h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov dword [fontcolor], 0C0h
        lea eax, [byte edi+01h]
        push eax
        lea eax, [byte esi+04h]
        push eax
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0FFh
        push edi
        lea eax, [byte esi+03h]
        push eax
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
        push edi
        push esi
        mov ebx, dword [dword esp+0A4h]
        push ebx
        call DrawArt
        add esp, byte 0Ch
        mov dword [fontcolor], 0FFh
        lea eax, [byte edi+031h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        lea ebx, [byte esi+027h]
        sub ebx, eax
        push ebx
        lea eax, [byte esp+074h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0C0h
        add edi, byte 30h
        push edi
        lea eax, [byte esp+070h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        add esi, byte 26h
        sub esi, eax
        push esi
        lea eax, [byte esp+074h]
.16:
        push eax
        call PrintString
        add esp, byte 0Ch
        mov eax, ebp
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        add ebx, ebx
        add ebx, dword [esp]
        xor eax, ebp
        mov al, byte [ebx]
        mov esi, dword [calselmonth]
        cmp eax, esi
        jne short .17
        xor eax, esi
        mov al, byte [byte ebx+01h]
        cmp eax, dword [calselday]
        jne short .17
        mov dword [dword esp+098h], ebp
.17:
        inc ebp
.18:
        cmp ebp, dword [dword esp+0B8h]
        jl near DrawCalendarDay.5
        mov ebx, dword [dword esp+098h]
        test ebx, ebx
        jl near .19
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        add eax, dword [esp]
        mov al, byte [byte eax+01h]
        and eax, 0FFh
        xor ebx, ebx
        mov ecx, dword [byte esp+08h]
        mov bl, byte [dword ecx+monthfirstday]
        add eax, ebx
        lea ebx, [byte eax-01h]
        mov ecx, 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov esi, edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov esi, dword [nosplit esi*4+calcolx]
        mov edi, dword [nosplit eax*4+calrowy]
        lea eax, [byte esi+04Ch]
        mov dword [dword esp+090h], eax
        lea ebp, [byte edi+03Eh]
        push dword 0BBh
        lea eax, [byte edi-01h]
        mov dword [dword esp+080h], eax
        push eax
        mov edx, dword [dword esp+098h]
        push edx
        push eax
        lea eax, [byte esi-01h]
        mov dword [dword esp+090h], eax
        push eax
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        push edi
        mov eax, dword [dword esp+098h]
        dec eax
        mov dword [dword esp+090h], eax
        push eax
        push edi
        push esi
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        push ebp
        mov edx, dword [dword esp+088h]
        push edx
        mov ebx, dword [dword esp+088h]
        push ebx
        push edx
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        lea eax, [byte ebp-01h]
        mov dword [dword esp+090h], eax
        push eax
        push esi
        push edi
        push esi
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        push ebp
        mov edx, dword [dword esp+098h]
        push edx
        mov ebx, dword [dword esp+088h]
        push ebx
        push edx
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        mov eax, dword [dword esp+090h]
        push eax
        mov edx, dword [dword esp+090h]
        push edx
        push edi
        push edx
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        push ebp
        mov ecx, dword [dword esp+098h]
        push ecx
        push ebp
        mov edi, dword [dword esp+090h]
        push edi
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        mov ebp, dword [dword esp+090h]
        push ebp
        mov eax, dword [dword esp+090h]
        push eax
        push ebp
        push esi
        call sub_B4FAC
        add esp, byte 14h
.19:
        lea eax, [byte esp+0Ch]
        push eax
        call TextRestoreState
        add esp, byte 4
        add esp, 0A8h
        pop ebp
        pop edi
        pop esi
        ret 10h
;-----------------------------------------------------------------------------
; CalNextMonth                                                    34691  95 PC
; Calendar "Next month": calmonth +1 (wraps 11 -> 0, stops at June), disables
; itself at the last month
;-----------------------------------------------------------------------------
; C: src/front/calendar/CalNextMonth.c
%ifdef CBUILD
%include "c/front/calendar/CalNextMonth.inc"
%else
CalNextMonth:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edi
        mov dword [calnextslot], CalNextMonth
        mov dword [calprevslot], CalPrevMonth
        mov ecx, dword [calmonth]
        inc ecx
        mov dword [calmonth], ecx
        cmp ecx, byte 0Ch
        jne short .1
        xor edi, edi
        mov dword [calmonth], edi
.1:
        cmp dword [calmonth], byte 6
        jne short .2
        mov dword [calmonth], 5
.2:
        cmp dword [calmonth], byte 5
        jne short .3
        xor ebx, ebx
        mov dword [calnextslot], ebx
.3:
        mov dword [calsel], 0FFFFFFFFh
        pop edi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalPrevMonth                                                    346FE  95 PC
; Calendar "Previous month": calmonth -1 (wraps 0 -> 11, stops at October),
; disables itself at the first month
;-----------------------------------------------------------------------------
; C: src/front/calendar/CalPrevMonth.c
%ifdef CBUILD
%include "c/front/calendar/CalPrevMonth.inc"
%else
CalPrevMonth:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov dword [calnextslot], CalNextMonth
        mov dword [calprevslot], CalPrevMonth
        mov ecx, dword [calmonth]
        dec ecx
        mov dword [calmonth], ecx
        cmp ecx, byte 0FFFFFFFFh
        jne short .1
        mov dword [calmonth], 0Bh
.1:
        cmp dword [calmonth], byte 8
        jne short .2
        mov dword [calmonth], 9
.2:
        cmp dword [calmonth], byte 9
        jne short .3
        xor ebx, ebx
        mov dword [calprevslot], ebx
.3:
        mov dword [calsel], 0FFFFFFFFh
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalReturn                                                       3476B  95 PC
; Calendar "Return to Sports Central": sets calexit and calsel to -1
;-----------------------------------------------------------------------------
; C: src/front/calendar/CalReturn.c
%ifdef CBUILD
%include "c/front/calendar/CalReturn.inc"
%else
CalReturn:
        push dword 8
        call __CHK
        push edx
        mov edx, 0FFFFFFFFh
        mov dword [calexit], edx
        mov dword [calsel], edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ApplyShapePalette                            34789  95 PC, medium confidence
; Sets the palette from the !pal block of the given shape file
;-----------------------------------------------------------------------------
; C: src/front/calendar/ApplyShapePalette.c
%ifdef CBUILD
%include "c/front/calendar/ApplyShapePalette.inc"
%else
ApplyShapePalette:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push str_Pal17
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetGameSides                                 347B7  95 PC, medium confidence
; (team, sched, game): sets the side controls for the two teams of a schedule
; game (the other team -1 unless it is a human team)
;-----------------------------------------------------------------------------
; C: src/front/calendar/SetGameSides.c
%ifdef CBUILD
%include "c/front/calendar/SetGameSides.inc"
%else
SetGameSides:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        add edx, ecx
        xor eax, eax
        mov al, byte [byte edx+02h]
        cmp esi, eax
        jne short .1
        mov dl, byte [byte edx+03h]
        and edx, 0FFh
        jmp short .2
.1:
        movzx esi, byte [byte edx+03h]
        mov edx, eax
.2:
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [nosplit eax*2+lgteam_17], 1
        je short .3
        mov edx, 0FFFFFFFFh
.3:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        add eax, ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        xor ebx, ebx
        mov bl, byte [byte eax+02h]
        mov eax, esi
        call SetCtlTeams
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalendarScreen                                                  34821  95 PC
; League calendar (calendar / callogo): month grid of the human team's games,
; Play / Game / Statistics menu, picks and plays the next game; called from
; import_export
;-----------------------------------------------------------------------------
CalendarScreen:
        push dword 7F8h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 7D0h
        push eax
        mov edi, edx
        mov ebp, ebx
        mov dword [dword esp+0780h], 0FFFFFFFFh
        xor ebx, ebx
        mov dword [dword esp+07B0h], ebx
        mov dword [dword esp+079Ch], 0C0h
        mov dword [dword esp+07A4h], 0Ch
        mov dword [dword esp+07A0h], 67h
        call sub_B4BA8
        push byte 0
        call ClearScreen
        add esp, byte 4
        cmp byte [musicon], 0
        je short .1
        cmp dword [songdata], byte 0
        je short .1
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.1:
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .3
        cmp dword [songdata], byte 0
        je short .3
.2:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short CalendarScreen.2
        mov ecx, dword [songdata]
        push ecx
        call sub_8D2F0
        add esp, byte 4
        xor esi, esi
        mov dword [songdata], esi
.3:
        call ShowLoadingScreen
        mov dword [teamstatscb], CalTeamStatsScreen
        mov dword [skaterstatscb], CalSkaterStatsScreen
        mov dword [goaliestatscb], CalGoalieStatsScreen
        mov dword [standingscb], CalStandingsScreen
        mov dword [standingsmenucb], CalStandingsMenu
        push dword 0FFh
        mov ecx, 0C0h
        mov ebx, 67h
        mov edx, ecx
        mov eax, 0Ch
        call SetDialogColors
        xor edx, edx
        mov word [dword esp+07B8h], dx
        mov dword [calsel], 0FFFFFFFFh
        xor edx, edx
        mov dword [calexit], edx
        mov dword [calredraw], edx
        mov eax, dword [mainfont]
        mov dword [dword esp+07ACh], eax
        xor ecx, ecx
        mov ebx, str_Calendar
        cmp byte [fileoncd+01C1h], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        lea eax, [dword esp+06F8h]
        call MakePath
        push byte 20h
        lea eax, [dword esp+06FCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [calendarshapes], eax
        xor ecx, ecx
        mov ebx, str_Callogo
        cmp byte [fileoncd+01C2h], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [dword esp+06F8h]
        call MakePath
        push byte 20h
        lea eax, [dword esp+06FCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [dword esp+078Ch], eax
        xor ebx, ebx
        mov word [dword esp+07CCh], bx
        jmp short .9
.8:
        mov eax, dword [dword esp+07CAh]
        sar eax, 10h
        mov dl, byte [dword esp+07CCh]
        mov byte [byte esp+eax+04h], dl
        mov eax, ecx
        inc eax
        mov word [dword esp+07CCh], ax
.9:
        mov ecx, dword [dword esp+07CCh]
        cmp cx, 100h
        jl short CalendarScreen.8
        lea eax, [byte esp+04h]
        push eax
        call SetColorRemap
        add esp, byte 4
        xor esi, esi
        mov word [dword esp+07CCh], si
        jmp short .11
.10:
        mov esi, dword [dword esp+07CAh]
        sar esi, 10h
        mov eax, dword [nosplit esi*4+crestnames]
        push eax
        mov edx, dword [dword esp+0790h]
        push edx
        call FindShape
        add esp, byte 8
        mov dword [dword esp+esi*4+0690h], eax
        inc word [dword esp+07CCh]
.11:
        cmp word [dword esp+07CCh], byte 1Ah
        jl short CalendarScreen.10
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, edi
        mov edx, dword [esp]
        lea eax, [dword esp+06F8h]
        call MakePath
        lea edx, [dword esp+0780h]
        lea eax, [dword esp+06F8h]
        call FileOpenRead
        mov esi, eax
        test ax, ax
        jne short .12
        mov ecx, 2
        xor ebx, ebx
        lea edx, [dword esp+07C0h]
        mov eax, dword [dword esp+0780h]
        call FileReadAt
        mov esi, eax
.12:
        test si, si
        jne near .22
        mov dword [calmonth], 0FFFFFFFFh
        mov edi, 5
        mov ebx, 0FFFFFFFFh
        mov dword [dword esp+07BCh], ebx
        mov word [dword esp+07C4h], bx
        mov word [dword esp+07CCh], si
        jmp near .20
.13:
        mov ebx, dword [dword esp+07CAh]
        sar ebx, 10h
        mov eax, dword [dword esp+07B6h]
        sar eax, 10h
        mov ecx, eax
        shl ecx, 2
        sub ecx, eax
        add ecx, ecx
        lea edx, [dword esp+0304h]
        add edx, ecx
        mov eax, dword [dword esp+0780h]
        call ReadSchedGame
        mov esi, eax
        test ax, ax
        jne near .19
        mov eax, dword [dword esp+07CCh]
        cmp ax, word [dword esp+07C0h]
        jne near .16
        cmp byte [dword esp+ecx+0306h], 0FFh
        je short .14
        cmp byte [dword esp+ecx+0307h], 0FFh
        je short .14
        movzx di, byte [dword esp+ecx+0304h]
        dec edi
        xor eax, eax
        mov al, byte [dword esp+ecx+0304h]
        mov dword [calselmonth], eax
        xor eax, eax
        mov al, byte [dword esp+ecx+0305h]
        jmp short .15
.14:
        mov ebx, dword [dword esp+07B6h]
        sar ebx, 10h
        lea edx, [byte ebx-01h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        movzx di, byte [dword esp+eax*2+0304h]
        dec edi
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        xor edx, edx
        mov dl, byte [dword esp+eax*2+0304h]
        mov dword [calselmonth], edx
        mov al, byte [dword esp+eax*2+0305h]
        and eax, 0FFh
.15:
        mov dword [calselday], eax
.16:
        mov edx, dword [dword esp+07B6h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        xor edx, edx
        mov dl, byte [dword esp+eax+0306h]
        cmp edx, ebp
        je short .17
        mov al, byte [dword esp+eax+0307h]
        and eax, 0FFh
        cmp eax, ebp
        jne near .19
.17:
        mov edx, dword [dword esp+07B6h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov dh, byte [dword esp+eax+0304h]
        cmp dh, 0FFh
        je near .19
        cmp byte [dword esp+eax+0305h], 0FFh
        je short .19
        mov bh, byte [dword esp+eax+0308h]
        cmp bh, 0FFh
        jne short .18
        cmp bh, byte [dword esp+eax+0309h]
        jne short .18
        cmp dword [calmonth], byte 0
        jge short .18
        mov al, dh
        and eax, 0FFh
        dec eax
        mov dword [calmonth], eax
        mov eax, dword [dword esp+07CCh]
        mov dword [dword esp+07BCh], eax
        mov eax, dword [dword esp+07B8h]
        mov word [dword esp+07C4h], ax
.18:
        mov eax, dword [dword esp+07B6h]
        sar eax, 10h
        mov edx, dword [dword esp+07CCh]
        mov word [dword esp+eax*2+05ACh], dx
        inc word [dword esp+07B8h]
.19:
        inc word [dword esp+07CCh]
.20:
        cmp word [dword esp+07CCh], 4ADh
        jge short .21
        test si, si
        je near CalendarScreen.13
.21:
        cmp dword [calmonth], byte 0
        jge short .22
        movsx eax, di
        mov dword [calmonth], eax
.22:
        test si, si
        je short .23
        call FadeOutPalCycle
.23:
        lea eax, [dword esp+0780h]
        call FileClose
        cmp word [dword esp+07BCh], byte 0
        jl short .24
        test si, si
        jne short .24
        mov ecx, dword [dword esp+07C2h]
        sar ecx, 10h
        mov ebx, ecx
        lea edx, [dword esp+0304h]
        mov eax, ebp
        call SetGameSides
        mov edx, ecx
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        xor edx, ecx
        mov dl, byte [dword esp+eax*2+0304h]
        mov dword [calselmonth], edx
        mov al, byte [dword esp+eax*2+0305h]
        and eax, 0FFh
        mov dword [calselday], eax
        mov eax, dword [dword esp+ecx*2+05AAh]
        sar eax, 10h
        mov dword [calsel], eax
.24:
        test si, si
        jne near .83
        cmp dword [calmonth], byte 5
        jne short .25
        xor eax, eax
        mov dword [calnextslot], eax
        jmp short .26
.25:
        mov dword [calnextslot], CalNextMonth
.26:
        cmp dword [calmonth], byte 9
        jne short .27
        xor ecx, ecx
        mov dword [calprevslot], ecx
        jmp short .28
.27:
        mov dword [calprevslot], CalPrevMonth
.28:
        mov ax, word [calmonth]
        mov word [dword esp+07D0h], ax
        call sub_B4BA8
        mov esi, calmenubar
        mov dword [dword esp+0730h], esi
        mov edi, 3
        mov dword [dword esp+0748h], edi
        xor eax, eax
        mov dword [dword esp+0734h], eax
        mov dword [dword esp+073Ch], eax
        mov dword [dword esp+0740h], eax
        mov dword [dword esp+0754h], eax
        mov dword [dword esp+0758h], eax
        mov dword [dword esp+0718h], eax
        mov dword [dword esp+071Ch], eax
        call FadeOutPalCycle
        call sub_B4BA8
        mov edx, dword [dword esp+07A0h]
        push edx
        mov ecx, dword [dword esp+07A8h]
        mov ebx, dword [dword esp+07A0h]
        mov edx, edi
        mov eax, esi
        call DrawMenuBar
        mov ebx, dword [calendarshapes]
        push ebx
        mov ecx, dword [dword esp+07B0h]
        push ecx
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
        cmp byte [musicon], 0
        je short .31
        cmp dword [songdata], byte 0
        jne short .31
        mov ecx, str_Iff9
        mov ebx, str_Calendar
        cmp byte [fileoncd+01E2h], 1
        jne short .29
        mov edx, dword [cddriveptr]
        jmp short .30
.29:
        xor edx, edx
.30:
        lea eax, [dword esp+06F8h]
        call MakePath
        lea eax, [dword esp+06F8h]
        call sub_8F98F
        mov dword [songdata], eax
        test eax, eax
        je short .31
        test byte [gameopts], 40h
        je short .31
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call sub_8FB8E
.31:
        mov eax, dword [calendarshapes]
        call ApplyShapePalette
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        add edx, byte 4
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer8
        call AllocMemBlock
        mov dword [dword esp+0794h], eax
        add esp, byte 0Ch
        mov dword [dword esp+0794h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+04h]
        inc eax
        mov edx, dword [dword esp+0788h]
        mov word [byte edx+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte edx+06h], ax
        lea eax, [dword esp+0774h]
        push eax
        lea eax, [dword esp+077Ch]
        push eax
        lea eax, [dword esp+0784h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [dword esp+0778h]
        mov dword [dword esp+0770h], eax
        mov eax, dword [dword esp+0774h]
        mov dword [dword esp+076Ch], eax
        push eax
        mov eax, dword [dword esp+077Ch]
        push eax
        mov edx, dword [dword esp+0790h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [dword esp+077Ch]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
.32:
        xor ecx, ecx
.33:
        call GetInputEvent
        mov esi, eax
        test eax, eax
        je short .34
        lea ebx, [dword esp+076Ch]
        lea edx, [dword esp+0770h]
        call dword [ptrupdatefn]
        mov ecx, eax
.34:
        test esi, esi
        je short .35
        test cl, 2
        je short CalendarScreen.33
.35:
        test cl, 2
        jne short .37
        mov eax, dword [dword esp+0770h]
        cmp eax, dword [dword esp+0778h]
        jne short .36
        mov eax, dword [dword esp+076Ch]
        cmp eax, dword [dword esp+0774h]
        je near .82
.36:
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [dword esp+077Ch]
        push ecx
        mov esi, dword [dword esp+079Ch]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [dword esp+076Ch]
        push edi
        mov eax, dword [dword esp+0774h]
        push eax
        push esi
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+076Ch]
        push ebx
        mov ecx, dword [dword esp+0774h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        jmp near .80
.37:
        lea eax, [dword esp+0764h]
        push eax
        lea eax, [dword esp+076Ch]
        push eax
        lea eax, [dword esp+0720h]
        push eax
        lea eax, [dword esp+0754h]
        push eax
        mov ecx, dword [dword esp+07C0h]
        lea ebx, [dword esp+0740h]
        mov edx, dword [dword esp+077Ch]
        mov eax, dword [dword esp+0780h]
        call MenuHitTest
        test eax, eax
        je near .65
        mov edx, dword [dword esp+0768h]
        shl edx, 2
        mov eax, dword [dword esp+0764h]
        shl eax, 5
        mov ebx, dword [dword esp+edx+0730h]
        add eax, ebx
        cmp dword [byte eax+014h], byte 0
        je near .50
        mov eax, dword [dword esp+0764h]
        cmp eax, dword [dword esp+edx+0754h]
        jne near .45
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [dword esp+077Ch]
        push ecx
        mov esi, dword [dword esp+079Ch]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .40
.38:
        mov esi, dword [dword esp+07CAh]
        sar esi, 10h
        mov edi, esi
        shl edi, 2
        mov eax, dword [dword esp+edi+073Ch]
        test eax, eax
        je short .39
        mov edx, dword [dword esp+esi*8+071Ch]
        push edx
        mov ebx, dword [dword esp+esi*8+071Ch]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+esi*8+0718h], eax
        mov dword [dword esp+esi*8+071Ch], eax
        mov ebx, dword [dword esp+edi+073Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.39:
        dec word [dword esp+07CCh]
.40:
        cmp word [dword esp+07CCh], byte 0
        jge short CalendarScreen.38
        xor esi, esi
        mov dword [dword esp+07B0h], esi
        mov eax, dword [dword esp+0768h]
        mov edx, dword [dword esp+0764h]
        shl edx, 5
        mov eax, dword [dword esp+eax*4+0730h]
        call dword [byte edx+eax+014h]
        mov esi, eax
        lea eax, [byte esp+04h]
        push eax
        call SetColorRemap
        add esp, byte 4
        xor edi, edi
        mov dword [dword esp+0734h], edi
        mov dword [dword esp+073Ch], edi
        mov dword [dword esp+0740h], edi
        mov dword [dword esp+0758h], edi
        mov dword [dword esp+074Ch], edi
        cmp esi, byte 1
        jne short .42
        mov esi, dword [dword esp+0794h]
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .41
        cmp dword [songdata], byte 0
        je short .41
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.41:
        xor eax, eax
        jmp near .x
.42:
        mov esi, dword [dword esp+0774h]
        push esi
        mov edi, dword [dword esp+077Ch]
        push edi
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [dword esp+0778h]
        mov dword [dword esp+0770h], eax
        mov eax, dword [dword esp+0774h]
        mov dword [dword esp+076Ch], eax
        call ClearInputQueue
        mov eax, dword [dword esp+07CEh]
        sar eax, 10h
        cmp eax, dword [calmonth]
        je short .43
        call sub_B4BA8
        mov ebx, dword [dword esp+07A0h]
        push ebx
        mov ecx, dword [dword esp+07A8h]
        mov ebx, dword [dword esp+07A0h]
        mov edx, 3
        mov eax, calmenubar
        call DrawMenuBar
        mov ecx, dword [calendarshapes]
        push ecx
        mov esi, dword [dword esp+07B0h]
        push esi
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
.43:
        cmp dword [calredraw], byte 0
        je short .44
        call sub_B4BA8
        mov eax, dword [dword esp+07A0h]
        push eax
        mov ecx, dword [dword esp+07A8h]
        mov ebx, dword [dword esp+07A0h]
        mov edx, 3
        mov eax, calmenubar
        call DrawMenuBar
        mov edx, dword [calendarshapes]
        push edx
        mov ebx, dword [dword esp+07B0h]
        push ebx
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
        mov eax, dword [calendarshapes]
        call ApplyShapePalette
        xor ecx, ecx
        mov dword [calredraw], ecx
.44:
        mov ax, word [calmonth]
        mov word [dword esp+07D0h], ax
        jmp near .79
.45:
        mov ecx, dword [dword esp+0774h]
        push ecx
        mov esi, dword [dword esp+077Ch]
        push esi
        mov edi, dword [dword esp+079Ch]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+07B0h]
        cmp eax, dword [dword esp+0768h]
        je near .49
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .48
.46:
        mov esi, edi
        shl esi, 2
        xor ecx, ecx
        mov dword [dword esp+esi+0754h], ecx
        mov eax, dword [dword esp+esi+073Ch]
        test eax, eax
        je short .47
        mov edx, dword [dword esp+edi*8+071Ch]
        push edx
        mov ebx, dword [dword esp+edi*8+071Ch]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+edi*8+071Ch], eax
        mov dword [dword esp+edi*8+0718h], eax
        mov edx, dword [dword esp+esi+073Ch]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [dword esp+esi+073Ch], ebx
        mov dword [dword esp+esi+0730h], ebx
        mov dword [dword esp+esi+0748h], ebx
.47:
        dec word [dword esp+07CCh]
.48:
        mov edi, dword [dword esp+07CAh]
        sar edi, 10h
        mov ebx, dword [dword esp+0768h]
        cmp edi, ebx
        jg near CalendarScreen.46
        mov dword [dword esp+07B0h], ebx
.49:
        mov eax, dword [dword esp+07A0h]
        push eax
        mov edx, dword [dword esp+07A8h]
        push edx
        mov eax, dword [dword esp+0770h]
        mov ebx, dword [dword esp+eax*8+0724h]
        mov edx, dword [dword esp+eax*8+0720h]
        mov ecx, dword [dword esp+eax*4+075Ch]
        shl ecx, 5
        mov eax, dword [dword esp+eax*4+0738h]
        add eax, ecx
        mov ecx, dword [dword esp+07A4h]
        call DrawMenuItemSel
        mov edx, dword [dword esp+0768h]
        mov eax, dword [dword esp+0764h]
        mov dword [dword esp+edx*4+0754h], eax
        mov ebx, dword [dword esp+07A0h]
        push ebx
        mov ecx, dword [dword esp+07A8h]
        push ecx
        mov ebx, dword [dword esp+edx*8+0724h]
        mov eax, dword [dword esp+edx*8+0720h]
        mov esi, dword [dword esp+edx*4+075Ch]
        shl esi, 5
        mov edx, dword [dword esp+edx*4+0738h]
        add esi, edx
        mov ecx, dword [dword esp+07A4h]
        mov edx, eax
        mov eax, esi
        jmp near .64
.50:
        cmp dword [byte eax+018h], byte 0
        je near .59
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [dword esp+077Ch]
        push ecx
        mov esi, dword [dword esp+079Ch]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+07B0h]
        cmp eax, dword [dword esp+0768h]
        je near .54
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .53
.51:
        mov esi, edi
        shl esi, 2
        xor ebx, ebx
        mov dword [dword esp+esi+0754h], ebx
        mov ecx, dword [dword esp+esi+073Ch]
        test ecx, ecx
        je short .52
        mov eax, dword [dword esp+edi*8+071Ch]
        push eax
        mov edx, dword [dword esp+edi*8+071Ch]
        push edx
        push ecx
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [dword esp+edi*8+0718h], ecx
        mov dword [dword esp+edi*8+071Ch], ecx
        mov edx, dword [dword esp+esi+073Ch]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [dword esp+esi+073Ch], ebx
        mov dword [dword esp+esi+0730h], ebx
        mov dword [dword esp+esi+0748h], ebx
.52:
        dec word [dword esp+07CCh]
.53:
        mov edi, dword [dword esp+07CAh]
        sar edi, 10h
        mov edx, dword [dword esp+0768h]
        cmp edi, edx
        jg near CalendarScreen.51
        mov dword [dword esp+07B0h], edx
.54:
        mov eax, dword [dword esp+07A0h]
        push eax
        mov edx, dword [dword esp+07A8h]
        push edx
        mov edi, dword [dword esp+07B8h]
        mov ebx, dword [dword esp+edi*8+0724h]
        mov edx, dword [dword esp+edi*8+0720h]
        mov eax, dword [dword esp+edi*4+075Ch]
        shl eax, 5
        mov ecx, dword [dword esp+edi*4+0738h]
        add eax, ecx
        mov ecx, dword [dword esp+07A4h]
        call DrawMenuItemSel
        mov eax, dword [dword esp+0764h]
        mov dword [dword esp+edi*4+0754h], eax
        mov eax, dword [dword esp+07A0h]
        push eax
        mov edx, dword [dword esp+07A8h]
        push edx
        mov ebx, dword [dword esp+edi*8+0724h]
        mov edx, dword [dword esp+edi*8+0720h]
        mov eax, dword [dword esp+076Ch]
        shl eax, 5
        mov ecx, dword [dword esp+edi*4+0738h]
        add eax, ecx
        mov ecx, dword [dword esp+07A4h]
        call DrawMenuItemNorm
        mov eax, dword [dword esp+0768h]
        mov ecx, dword [dword esp+0764h]
        shl ecx, 5
        mov ebx, dword [dword esp+eax*4+0730h]
        lea esi, [byte edi+01h]
        mov dword [dword esp+07B0h], esi
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [dword esp+esi*4+0730h], ebx
        mov eax, dword [dword esp+eax*4+0730h]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [dword esp+esi*4+0748h], ebx
        cmp esi, byte 1
        je short .55
        mov edx, dword [byte eax+08h]
        jmp short .56
.55:
        mov edx, dword [eax]
.56:
        mov eax, dword [dword esp+07B0h]
        mov ebx, dword [dword esp+eax*8+0710h]
        add edx, ebx
        mov dword [dword esp+eax*8+0718h], edx
        mov edx, dword [dword esp+0764h]
        shl edx, 5
        mov eax, dword [dword esp+0768h]
        shl eax, 2
        cmp dword [dword esp+07B0h], byte 1
        je short .57
        mov eax, dword [dword esp+eax+0730h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .58
.57:
        mov eax, dword [dword esp+eax+0730h]
        mov eax, dword [byte edx+eax+0Ch]
.58:
        mov edx, dword [dword esp+07B0h]
        shl edx, 3
        mov dword [dword esp+0790h], edx
        mov esi, dword [dword esp+edx+0714h]
        add eax, esi
        mov dword [dword esp+edx+071Ch], eax
        mov eax, dword [dword esp+07B0h]
        shl eax, 2
        mov dword [dword esp+0798h], eax
        mov edx, dword [dword esp+eax+0748h]
        shl edx, 5
        mov eax, dword [dword esp+eax+0730h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [dword esp+0760h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [dword esp+0784h], edx
        push byte 20h
        mov eax, dword [dword esp+0764h]
        shl eax, 2
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff5
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+0798h]
        mov dword [dword esp+edx+073Ch], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [dword esp+edx+073Ch]
        mov edx, dword [dword esp+0760h]
        mov word [byte eax+04h], dx
        mov eax, dword [dword esp+0798h]
        mov eax, dword [dword esp+eax+073Ch]
        mov edx, dword [dword esp+0784h]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+0790h]
        mov esi, dword [dword esp+eax+071Ch]
        push esi
        mov edi, dword [dword esp+eax+071Ch]
        push edi
        mov eax, dword [dword esp+07A0h]
        mov edx, dword [dword esp+eax+0744h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+07A0h]
        push ebx
        mov ecx, dword [dword esp+07A8h]
        push ecx
        mov esi, dword [dword esp+07A4h]
        push esi
        mov ecx, dword [dword esp+079Ch]
        mov ecx, dword [dword esp+ecx+0728h]
        mov ebx, dword [dword esp+079Ch]
        mov ebx, dword [dword esp+ebx+0724h]
        mov edx, dword [dword esp+07A4h]
        mov edx, dword [dword esp+edx+0754h]
        mov eax, dword [dword esp+07A4h]
        mov eax, dword [dword esp+eax+073Ch]
        call DrawMenuDropdown
        mov eax, dword [dword esp+0798h]
        xor edi, edi
        mov dword [dword esp+eax+0754h], edi
        mov eax, dword [dword esp+07A0h]
        push eax
        mov edx, dword [dword esp+07A8h]
        push edx
        mov ebx, dword [dword esp+0798h]
        mov ebx, dword [dword esp+ebx+0724h]
        mov edx, dword [dword esp+0798h]
        mov edx, dword [dword esp+edx+0720h]
        mov eax, dword [dword esp+07A0h]
        mov eax, dword [dword esp+eax+0738h]
        mov ecx, esi
        jmp near .64
.59:
        mov esi, dword [dword esp+0774h]
        push esi
        mov edi, dword [dword esp+077Ch]
        push edi
        mov eax, dword [dword esp+079Ch]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+07B0h]
        cmp eax, dword [dword esp+0768h]
        je near .63
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .62
.60:
        mov esi, edi
        shl esi, 2
        xor edx, edx
        mov dword [dword esp+esi+0754h], edx
        mov ebx, dword [dword esp+esi+073Ch]
        test ebx, ebx
        je short .61
        mov ecx, dword [dword esp+edi*8+071Ch]
        push ecx
        mov eax, dword [dword esp+edi*8+071Ch]
        push eax
        push ebx
        call PutBlock
        add esp, byte 0Ch
        xor ebx, ebx
        mov dword [dword esp+edi*8+0718h], ebx
        mov dword [dword esp+edi*8+071Ch], ebx
        mov edi, dword [dword esp+esi+073Ch]
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [dword esp+esi+073Ch], eax
        mov dword [dword esp+esi+0730h], eax
        mov dword [dword esp+esi+0748h], eax
.61:
        dec word [dword esp+07CCh]
.62:
        mov edi, dword [dword esp+07CAh]
        sar edi, 10h
        mov eax, dword [dword esp+0768h]
        cmp edi, eax
        jg near CalendarScreen.60
        mov dword [dword esp+07B0h], eax
.63:
        mov ecx, dword [dword esp+07A0h]
        push ecx
        mov esi, dword [dword esp+07A8h]
        push esi
        mov eax, dword [dword esp+0770h]
        mov ebx, dword [dword esp+eax*8+0724h]
        mov edx, dword [dword esp+eax*8+0720h]
        mov ecx, dword [dword esp+eax*4+075Ch]
        shl ecx, 5
        mov eax, dword [dword esp+eax*4+0738h]
        add eax, ecx
        mov ecx, dword [dword esp+07A4h]
        call DrawMenuItemSel
        mov edx, dword [dword esp+0768h]
        mov eax, dword [dword esp+0764h]
        mov dword [dword esp+edx*4+0754h], eax
        mov edi, dword [dword esp+07A0h]
        push edi
        push esi
        mov ebx, dword [dword esp+edx*8+0724h]
        mov eax, dword [dword esp+edx*8+0720h]
        mov esi, dword [dword esp+edx*4+075Ch]
        shl esi, 5
        mov edx, dword [dword esp+edx*4+0738h]
        add esi, edx
        mov ecx, dword [dword esp+07A4h]
        mov edx, eax
        mov eax, esi
.64:
        call DrawMenuItemNorm
        jmp near .79
.65:
        mov edi, dword [dword esp+0774h]
        push edi
        mov eax, dword [dword esp+077Ch]
        push eax
        mov edx, dword [dword esp+079Ch]
        push edx
        call PutBlock
        add esp, byte 0Ch
        cmp dword [dword esp+07B0h], byte 0
        je near .69
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .68
.66:
        mov esi, dword [dword esp+07CAh]
        sar esi, 10h
        mov edi, esi
        shl edi, 2
        mov eax, dword [dword esp+edi+073Ch]
        test eax, eax
        je short .67
        mov edx, dword [dword esp+esi*8+071Ch]
        push edx
        mov ebx, dword [dword esp+esi*8+071Ch]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+esi*8+0718h], eax
        mov dword [dword esp+esi*8+071Ch], eax
        mov ebx, dword [dword esp+edi+073Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.67:
        dec word [dword esp+07CCh]
.68:
        cmp word [dword esp+07CCh], byte 0
        jge short CalendarScreen.66
        xor eax, eax
        mov dword [dword esp+07B0h], eax
        mov dword [dword esp+0734h], eax
        mov dword [dword esp+073Ch], eax
        mov dword [dword esp+0740h], eax
        mov dword [dword esp+0758h], eax
        mov dword [dword esp+074Ch], eax
        jmp near .79
.69:
        mov word [dword esp+07B4h], 0FFFFh
        mov ecx, dword [dword esp+0770h]
        cmp ecx, byte 52h
        jl near .78
        cmp ecx, 25Fh
        jge near .78
        mov edi, dword [dword esp+076Ch]
        cmp edi, byte 44h
        jl near .78
        cmp edi, 1B2h
        jge near .78
        lea edx, [byte edi-044h]
        mov ebx, 3Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, eax
        shl esi, 3
        sub esi, eax
        lea edx, [byte ecx-052h]
        mov ebx, 4Bh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        add esi, eax
        mov ebx, dword [calmonth]
        xor edx, edx
        mov dl, byte [dword ebx+monthfirstday]
        mov ecx, 7
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov eax, esi
        sub eax, edx
        mov word [dword esp+07C8h], ax
        test ax, ax
        jl near .78
        xor eax, eax
        mov al, byte [dword ebx+monthdays]
        mov edx, dword [dword esp+07C6h]
        sar edx, 10h
        cmp edx, eax
        jge near .78
        xor ebx, ebx
        mov word [dword esp+07CCh], bx
        jmp near .77
.70:
        mov edx, dword [dword esp+07CAh]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        xor ecx, ecx
        mov cl, byte [dword esp+eax+0304h]
        mov ebx, dword [calmonth]
        inc ebx
        cmp ecx, ebx
        jne near .76
        xor ecx, ebx
        mov cl, byte [dword esp+eax+0305h]
        mov ebx, dword [dword esp+07C6h]
        sar ebx, 10h
        inc ebx
        cmp ecx, ebx
        jne near .76
        mov bl, byte [dword esp+eax+0308h]
        cmp bl, 0FFh
        jne near .76
        cmp bl, byte [dword esp+eax+0309h]
        jne near .76
        mov eax, dword [dword esp+edx*2+05AAh]
        sar eax, 10h
        cmp eax, dword [calsel]
        jne short .71
        mov dword [calexit], 0FFFFFFFFh
.71:
        cmp word [dword esp+07C0h], 444h
        jl short .72
        mov eax, dword [dword esp+07CAh]
        sar eax, 10h
        mov ax, word [dword esp+eax*2+05ACh]
        cmp ax, word [dword esp+07BCh]
        jne short .73
.72:
        mov eax, dword [dword esp+07CAh]
        sar eax, 10h
        mov ax, word [dword esp+eax*2+05ACh]
        mov word [dword esp+07B4h], ax
        mov eax, dword [dword esp+07CCh]
        mov word [dword esp+07C4h], ax
        mov eax, dword [dword esp+07B8h]
        mov word [dword esp+07CCh], ax
.73:
        mov esi, dword [calselmonth]
        mov edi, dword [calselday]
        mov ebx, dword [dword esp+07C2h]
        sar ebx, 10h
        mov edx, ebx
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        xor edx, ebx
        mov dl, byte [dword esp+eax*2+0304h]
        mov dword [calselmonth], edx
        mov al, byte [dword esp+eax*2+0305h]
        and eax, 0FFh
        mov dword [calselday], eax
        cmp dword [calexit], byte 0
        jne short .74
        lea edx, [dword esp+0304h]
        mov eax, ebp
        call SetGameSides
.74:
        call sub_B4BA8
        mov ebx, dword [dword esp+07A0h]
        push ebx
        mov ecx, dword [dword esp+07A8h]
        mov ebx, dword [dword esp+07A0h]
        mov edx, 3
        mov eax, calmenubar
        call DrawMenuBar
        mov ecx, dword [calselmonth]
        cmp esi, ecx
        jne near .75
        cmp edi, dword [calselday]
        je near .75
        movzx esi, byte [dword ecx+monthfirstday_m1]
        add esi, edi
        dec esi
        mov ebx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov ebx, edx
        mov ecx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov esi, ebx
        shl esi, 2
        mov ecx, dword [dword esi+calcolx]
        sub ecx, byte 2
        mov ebx, dword [nosplit eax*4+calrowy]
        sub ebx, byte 2
        mov edx, dword [dword esi+calcolx]
        add edx, byte 4Dh
        mov eax, dword [nosplit eax*4+calrowy]
        add eax, byte 3Fh
        push eax
        push ebx
        push edx
        push ecx
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [calendarshapes]
        push edx
        mov ebx, dword [dword esp+07B0h]
        push ebx
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
.75:
        mov eax, dword [calselmonth]
        movzx esi, byte [dword eax+monthfirstday_m1]
        add esi, dword [calselday]
        dec esi
        mov ebx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov ebx, edx
        mov ecx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov esi, eax
        mov eax, ebx
        mov ebx, dword [nosplit eax*4+calcolx]
        sub ebx, byte 2
        mov edx, dword [nosplit esi*4+calrowy]
        sub edx, byte 2
        mov eax, dword [nosplit eax*4+calcolx]
        add eax, byte 4Dh
        mov ecx, dword [nosplit esi*4+calrowy]
        add ecx, byte 3Fh
        push ecx
        push edx
        push eax
        push ebx
        call SetClipWindow
        add esp, byte 10h
        mov esi, dword [calendarshapes]
        push esi
        mov edi, dword [dword esp+07B0h]
        push edi
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
.76:
        inc word [dword esp+07CCh]
.77:
        mov eax, dword [dword esp+07CCh]
        cmp ax, word [dword esp+07B8h]
        jl near CalendarScreen.70
.78:
        mov eax, dword [dword esp+07B2h]
        sar eax, 10h
        mov dword [calsel], eax
.79:
        mov ecx, dword [dword esp+0774h]
        push ecx
        mov esi, dword [dword esp+077Ch]
        push esi
        mov edi, dword [dword esp+079Ch]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0774h]
        push eax
        mov edx, dword [dword esp+077Ch]
        push edx
        mov ebx, dword [dword esp+079Ch]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [dword esp+076Ch]
        push ecx
        mov esi, dword [dword esp+0774h]
        push esi
        mov edi, dword [dword esp+079Ch]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        cmp dword [calexit], byte 0
        jne short .81
        mov edx, dword [dword esp+076Ch]
        push edx
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
.80:
        call DrawArt
        add esp, byte 0Ch
.81:
        mov eax, dword [dword esp+0770h]
        mov dword [dword esp+0778h], eax
        mov eax, dword [dword esp+076Ch]
        mov dword [dword esp+0774h], eax
.82:
        cmp dword [calexit], byte 0
        je near CalendarScreen.32
.83:
        mov edi, dword [dword esp+0794h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+078Ch]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [calendarshapes]
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor edx, edx
        mov dword [calendarshapes], edx
        mov dword [teamstatscb], GameTeamStatsScreen
        mov dword [skaterstatscb], GameSkaterStatsScreen
        mov dword [goaliestatscb], GameGoalieStatsScreen
        mov dword [standingscb], GameStandingsScreen
        mov dword [standingsmenucb], GameStandingsMenu
        cmp byte [musicon], 0
        je short .84
        cmp dword [songdata], byte 0
        je short .84
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.84:
        mov eax, dword [calsel]
.x:
        add esp, 7D4h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
