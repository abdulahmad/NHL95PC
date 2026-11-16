; Palette fades and clipped blits (PC only).
bits 32
%include "hockey.inc"
section s_76429 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, blitclipbottom, blitclipleft, blitclipright, blitcliptop, ClearScreen, dlgfillcol
extern fadeend, fadeend2, fadepal, fadepal2, fadestart, fadestart2, fadestep, fadestep2
extern FillRect, fputchar, j___delay_, palfadedin, PrintString, stub_8C218, SetScreenTarget, WaitRetraceEnd
extern vgapage, VgaSetPalette
global FadePalStep, FadePalStep_ret, FadePalStepSlow, SetPalette768, RandLfsrByte, BlitClipRect, str_Scratch2, str_Dress2
global str_Player2, str_GoalieW2, str_RosterIncomplete2, PrintLineEdStatus
;-----------------------------------------------------------------------------
; FadePalStep                                                     76429  95 PC
; (in, pal, steps): fades the 300h-byte palette in or out through fadepal
; (steps capped at 2 when already faded in)
;-----------------------------------------------------------------------------
; C: src/front/fade/FadePalStep.c
%ifdef CBUILD
%include "c/front/fade/FadePalStep.inc"
%else
FadePalStep:
        push dword 1Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        mov dword [esp], ebx
        test eax, eax
        je short .4
        cmp dword [palfadedin], byte 0
        je short .3
        mov ecx, dword [esp]
        cmp ecx, byte 2
        jle short .1
        mov eax, 2
        jmp short .2
.1:
        mov eax, ecx
.2:
        mov dword [esp], eax
.3:
        mov dword [palfadedin], 1
        jmp short .5
.4:
        mov dword [palfadedin], eax
.5:
        cmp dword [esp], byte 2
        jge short .7
        test edi, edi
        jne short .6
        mov eax, esi
        call SetPalette768
        jmp near FadePalStep_ret
.6:
        mov ecx, 300h
        xor edx, edx
        mov eax, fadepal
        call __STOSB
        mov eax, fadepal
        call SetPalette768
        push byte 0
        call ClearScreen
        add esp, byte 4
        jmp short FadePalStep_ret
.7:
        mov al, byte [esp]
        dec al
        mov byte [fadestart+1], al
        mov al, byte [esp]
        inc al
        mov byte [fadeend], al
        mov ecx, dword [dword edi+fadestart-3]
        sar ecx, 18h
        mov ebp, dword [esp]
        jmp short .10
.8:
        xor ebx, ebx
.9:
        movsx edx, byte [esi+ebx]
        imul edx, ecx
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov byte [dword ebx+fadepal], al
        inc ebx
        cmp ebx, 300h
        jl short FadePalStep.9
        mov eax, fadepal
        call SetPalette768
        mov eax, dword [dword edi+fadestep-3]
        sar eax, 18h
        add ecx, eax
.10:
        mov eax, dword [dword edi+fadeend-3]
        sar eax, 18h
        cmp ecx, eax
        jne short FadePalStep.8
FadePalStep_ret:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FadePalStepSlow                                                 7651B  95 PC
; Same with a 45 ms delay per step (no refs)
;-----------------------------------------------------------------------------
; C: src/front/fade/FadePalStep.c (FadePalStepSlow)
%ifdef CBUILD
%include "c/front/fade/FadePalStep.FadePalStepSlow.inc"
%else
FadePalStepSlow:
        push dword 1Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        mov dword [esp], ebx
        test eax, eax
        je short .4
        cmp dword [palfadedin], byte 0
        je short .3
        mov ecx, dword [esp]
        cmp ecx, byte 2
        jle short .1
        mov eax, 2
        jmp short .2
.1:
        mov eax, ecx
.2:
        mov dword [esp], eax
.3:
        mov dword [palfadedin], 1
        jmp short .5
.4:
        mov dword [palfadedin], eax
.5:
        cmp dword [esp], byte 2
        jge short .7
        test edi, edi
        jne short .6
        mov eax, esi
        call SetPalette768
        jmp short FadePalStep_ret
.6:
        mov ecx, 300h
        xor edx, edx
        mov eax, fadepal2
        call __STOSB
        mov eax, fadepal2
        call SetPalette768
        push byte 0
        call ClearScreen
        add esp, byte 4
        jmp near FadePalStep_ret
.7:
        mov al, byte [esp]
        dec al
        mov byte [fadestart2+1], al
        mov al, byte [esp]
        inc al
        mov byte [fadeend2], al
        mov ecx, dword [dword edi+fadestart2-3]
        sar ecx, 18h
        mov ebp, dword [esp]
        jmp short .10
.8:
        xor ebx, ebx
.9:
        movsx edx, byte [esi+ebx]
        imul edx, ecx
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov byte [dword ebx+fadepal2], al
        inc ebx
        cmp ebx, 300h
        jl short FadePalStepSlow.9
        mov eax, 2Dh
        call j___delay_
        mov eax, fadepal2
        call SetPalette768
        mov eax, dword [dword edi+fadestep2-3]
        sar eax, 18h
        add ecx, eax
.10:
        mov eax, dword [dword edi+fadeend2-3]
        sar eax, 18h
        cmp ecx, eax
        jne short FadePalStepSlow.8
        jmp near FadePalStep_ret
%endif ; C
;-----------------------------------------------------------------------------
; SetPalette768                                                   76614  95 PC
; Sets all 256 colours in two halves with vsync
;-----------------------------------------------------------------------------
; C: src/front/fade/SetPalette768.c
%ifdef CBUILD
%include "c/front/fade/SetPalette768.inc"
%else
SetPalette768:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, eax
        xor esi, esi
        xor edi, edi
        jmp short .2
.1:
        call WaitRetraceEnd
        lea eax, [edi+ebp]
        push eax
        push dword 80h
        push esi
        call VgaSetPalette
        add esp, byte 0Ch
        add esi, 80h
        add edi, 180h
.2:
        cmp esi, 100h
        jl short SetPalette768.1
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RandLfsrByte                                 7665E  95 PC, medium confidence
; 8-bit LFSR step (seed 2Bh, taps 0B8h) (no refs)
;-----------------------------------------------------------------------------
; C: src/front/fade/RandLfsrByte.c
%ifdef CBUILD
%include "c/front/fade/RandLfsrByte.inc"
%else
RandLfsrByte:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp byte [eax], 0
        jne short .1
        mov byte [eax], 2Bh
.1:
        mov dl, byte [eax]
        and dl, 1
        mov dh, byte [eax]
        shr dh, 1
        mov byte [eax], dh
        test dl, dl
        je short .2
        mov bl, dh
        xor bl, 0B8h
        mov byte [eax], bl
.2:
        mov al, byte [eax]
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; BlitClipRect                                 7668D  95 PC, medium confidence
; Clips a rect to ECDE4..ECDF0 and blits it to the screen (no refs)
;-----------------------------------------------------------------------------
; C: src/front/fade/BlitClipRect.c
%ifdef CBUILD
%include "c/front/fade/BlitClipRect.inc"
%else
BlitClipRect:
        push dword 30h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 8
        mov edi, eax
        mov esi, edx
        mov dword [byte ebp-04h], ebx
        mov dword [byte ebp-08h], ecx
        add eax, ebx
        add edx, ecx
        cmp edi, dword [blitclipright]
        jge near .x
        cmp esi, dword [blitclipbottom]
        jge near .x
        mov ebx, dword [blitclipleft]
        cmp eax, ebx
        jl short .x
        cmp edx, dword [blitcliptop]
        jl short .x
        cmp edi, ebx
        jge short .1
        mov edi, ebx
.1:
        mov ecx, dword [blitcliptop]
        cmp esi, ecx
        jge short .2
        mov esi, ecx
.2:
        mov ebx, dword [blitclipright]
        cmp eax, ebx
        jle short .3
        mov eax, ebx
.3:
        mov ecx, dword [blitclipbottom]
        cmp edx, ecx
        jle short .4
        mov edx, ecx
.4:
        sub eax, edi
        mov dword [byte ebp-04h], eax
        sub edx, esi
        mov dword [byte ebp-08h], edx
        call SetScreenTarget
        push byte 0
        mov eax, dword [byte ebp-08h]
        push eax
        mov edx, dword [byte ebp-04h]
        push edx
        push esi
        push edi
        cmp dword [vgapage], byte 0
        sete al
        and eax, 0FFh
        push eax
        call stub_8C218
        add esp, byte 18h
.x:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
str_Scratch2:                                   ; copy used by team_select
        db 053h,063h,072h,061h,074h,063h,068h,00h
str_Dress2:                                     ; string "Dress"; used by CheckGameRosterComplete
        db 044h,072h,065h,073h,073h,00h
str_Player2:                                    ; string "Player"; used by CheckGameRosterComplete
        db 050h,06Ch,061h,079h,065h,072h,00h
str_GoalieW2:                                   ; string "Goalie"; used by CheckGameRosterComplete
        db 047h,06Fh,061h,06Ch,069h,065h,00h
str_RosterIncomplete2:                          ; string "Your roster is incomplete."; used by
                                                ; CheckGameRosterComplete
        db 059h,06Fh,075h,072h,020h,072h,06Fh,073h,074h,065h,072h,020h,069h,073h,020h,069h
        db 06Eh,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,02Eh,00h
;-----------------------------------------------------------------------------
; PrintLineEdStatus                                               76771  95 PC
; (x, y, text): clears and prints a status text clamped to x 26Bh
;-----------------------------------------------------------------------------
; C: src/front/fade/PrintLineEdStatus.c
%ifdef CBUILD
%include "c/front/fade/PrintLineEdStatus.inc"
%else
PrintLineEdStatus:
        push dword 28h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov ebp, edx
        mov edi, ebx
        push ebx
        call fputchar
        add esp, byte 4
        add eax, esi
        cmp eax, 26Bh
        jle short .1
        mov eax, 26Bh
        sub eax, esi
        jmp short .2
.1:
        push edi
        call fputchar
        add esp, byte 4
.2:
        mov edx, dword [dlgfillcol]
        push edx
        push byte 0Bh
        push eax
        lea eax, [byte ebp+02h]
        push eax
        push esi
        call FillRect
        add esp, byte 14h
        push ebp
        push esi
        push edi
        call PrintString
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
