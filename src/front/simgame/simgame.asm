; Simulating a game that is not played by hand, and the loading picture shown while that runs.
bits 32
%include "hockey.inc"
section s_45282 progbits alloc exec nowrite align=1
extern __CHK, addtimer, CareerDbPtr, CareerDbPtr2, cddriveptr, FadePalStep, fileoncd, FreeMemBlock
extern gameopts, KeyDbPtr, loadpals, loadscreenon, MakePath, memcpy_, memset_, palcycledelay
extern palcyclelock, palcyclephase, rand_, ReadDbRec4Ch, ReadTeamRec, seasondb, SeasonDbPtr, SeasonDbPtr2
extern SetTickDeadline, simdorder, simfwdorder, str_LoadPic, str_Pal23, AllocMemBlock, MemLargestFree, LoadBank
extern SetPalette, DrawArtOpaque, FindShape, ClearScreen, VgaSetPalette, SetScreenTarget, sub_B4C61, tag_ags
extern tag_agset, tag_aps, tag_apset, tag_at, tag_gk, tag_gs, tag_gset, tag_pk
extern tag_ps, tag_pset, tag_t, WaitTickDeadline, WriteTeamRec
global RandMod, SimAddPair, SimulateGame, LoadScreenPalTick, ShowLoadingScreen
;-----------------------------------------------------------------------------
; RandMod                                                         45282  95 PC
; (n): (rand() & 7FFFh) % n
;-----------------------------------------------------------------------------
; C: src/front/simgame/RandMod.c
%ifdef CBUILD
%include "c/front/simgame/RandMod.inc"
%else
RandMod:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        call rand_
        and eax, 7FFFh
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov eax, edx
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SimAddPair                                   452A6  95 PC, medium confidence
; (count*, list, a, b): appends an (a, b) dword pair to a list of at most 4
; (SimulateGame scoring events)
;-----------------------------------------------------------------------------
; C: src/front/simgame/SimAddPair.c
%ifdef CBUILD
%include "c/front/simgame/SimAddPair.inc"
%else
SimAddPair:
        push dword 8
        call __CHK
        push esi
        mov esi, dword [eax]
        cmp esi, byte 4
        jge short .x
        mov dword [edx+esi*8], ebx
        mov ebx, dword [eax]
        mov dword [byte edx+ebx*8+04h], ecx
        inc dword [eax]
.x:
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SimulateGame                                    452C5  95 PC, low confidence
; Called for every unplayed league game the CPU plays (SimScheduleDay,
; SimPlayoffRound*); uses rand_ and the TEAMS.DB records
;-----------------------------------------------------------------------------
SimulateGame:
        push dword 224h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 204h
        push ebx
        xor edx, edx
        mov dword [dword esp+01D0h], edx
.1:
        xor ebx, ebx
        mov dword [dword esp+01CCh], ebx
.2:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov ebp, dword [dword esp+01CCh]
        add eax, ebp
        xor dl, dl
        mov byte [dword esp+eax+0ECh], dl
        mov byte [dword esp+eax+0F8h], dl
        lea eax, [byte ebp+01h]
        mov dword [dword esp+01CCh], eax
        cmp eax, byte 5
        jl short SimulateGame.2
        mov ebx, dword [dword esp+01D0h]
        inc ebx
        mov dword [dword esp+01D0h], ebx
        cmp ebx, byte 2
        jl short SimulateGame.1
        mov byte [dword esp+01F4h], dl
        mov byte [dword esp+01F0h], dl
        xor eax, eax
        mov al, byte [byte ecx+02h]
        mov dword [dword esp+013Ch], eax
        xor eax, eax
        mov al, byte [byte ecx+03h]
        mov dword [dword esp+0140h], eax
        lea eax, [byte ecx+04h]
        mov dword [dword esp+0184h], eax
        lea eax, [byte ecx+05h]
        mov dword [dword esp+0188h], eax
        mov byte [byte ecx+04h], dl
        mov byte [byte ecx+05h], dl
        xor eax, eax
        mov dword [dword esp+01ACh], eax
        mov dword [dword esp+01D0h], eax
.3:
        push byte 20h
        push dword 2E8h
        push tag_t
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, dword [dword esp+01D0h]
        mov dword [dword esp+ebp*4+016Ch], eax
        push byte 20h
        push byte 4Ch
        push tag_at
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+0164h], eax
        push byte 20h
        push byte 64h
        push tag_pk
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+017Ch], eax
        push byte 20h
        push byte 64h
        push tag_ps
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+0154h], eax
        push byte 20h
        push byte 64h
        push tag_pset
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+015Ch], eax
        push byte 20h
        push byte 64h
        push tag_aps
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+012Ch], eax
        push byte 20h
        push byte 64h
        push tag_apset
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+0104h], eax
        push byte 20h
        push byte 0Ch
        push tag_gk
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+0134h], eax
        push byte 20h
        push byte 0Ch
        push tag_gs
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+0124h], eax
        push byte 20h
        push byte 0Ch
        push tag_gset
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+010Ch], eax
        push byte 20h
        push byte 0Ch
        push tag_ags
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+014Ch], eax
        push byte 20h
        push byte 0Ch
        push tag_agset
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+0114h], eax
        lea ebx, [byte ebp+01h]
        mov dword [dword esp+01D0h], ebx
        cmp ebx, byte 2
        jl near SimulateGame.3
        xor ebp, ebp
        mov dword [dword esp+01A4h], ebp
        mov dword [dword esp+01D0h], ebp
        mov ebp, dword [esp]
        jmp near .8
.4:
        xor cl, cl
        mov byte [dword esp+edx+01DCh], cl
        mov ecx, edx
        shl ecx, 2
        mov ebx, dword [dword esp+ecx+013Ch]
        mov edx, dword [dword esp+ecx+0164h]
        mov eax, dword [dword esp+021Ch]
        call ReadDbRec4Ch
        mov dword [dword esp+01A4h], eax
        test eax, eax
        jne near .7
        mov ebx, dword [dword esp+ecx+013Ch]
        mov edx, dword [dword esp+ecx+016Ch]
        mov eax, dword [dword esp+0218h]
        call ReadTeamRec
        mov dword [dword esp+01A4h], eax
        cmp ebp, 444h
        jl short .5
        mov eax, dword [dword esp+ecx+0164h]
        add eax, byte 3Ah
        mov dword [dword esp+ecx+0144h], eax
        mov eax, dword [dword esp+ecx+016Ch]
        add eax, byte 3Ah
        jmp short .6
.5:
        mov eax, dword [dword esp+ecx+0164h]
        add eax, byte 28h
        mov dword [dword esp+ecx+0144h], eax
        mov eax, dword [dword esp+ecx+016Ch]
        add eax, byte 28h
.6:
        mov dword [dword esp+ecx+0174h], eax
        mov eax, dword [dword esp+01D0h]
        mov byte [dword esp+eax+01E0h], 0B4h
        xor edx, edx
        mov dword [dword esp+eax*4+018Ch], edx
.7:
        inc dword [dword esp+01D0h]
.8:
        mov edx, dword [dword esp+01D0h]
        cmp edx, byte 2
        jge short .9
        cmp dword [dword esp+01A4h], byte 0
        je near SimulateGame.4
.9:
        xor ecx, ecx
        mov dword [dword esp+01D0h], ecx
        jmp near .27
.10:
        mov dword [dword esp+01CCh], ebp
        jmp near .17
.11:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        mov edx, ebx
        add eax, ebx
        xor dl, bl
        mov byte [dword esp+eax+0A0h], dl
        xor dh, bh
        mov byte [byte esp+eax+038h], dh
        xor bl, bl
        mov byte [byte esp+eax+04h], bl
        xor bh, bh
        mov byte [byte esp+eax+06Ch], bh
        mov ebx, dword [dword esp+01D0h]
        shl ebx, 2
        mov eax, dword [dword esp+ebx+016Ch]
        mov ecx, dword [dword esp+01CCh]
        shl ecx, 2
        mov eax, dword [byte ecx+eax+04Ch]
        cmp eax, byte 0FFFFFFFFh
        je near .16
        call KeyDbPtr
        mov edx, dword [dword esp+ebx+017Ch]
        mov dword [ecx+edx], eax
        cmp dword [dword esp+01A4h], byte 0
        jne near .14
        mov eax, dword [dword esp+ebx+017Ch]
        mov eax, dword [ecx+eax]
        mov eax, dword [byte eax+028h]
        call CareerDbPtr
        mov edx, dword [dword esp+ebx+012Ch]
        mov dword [ecx+edx], eax
        mov ebp, dword [dword esp+ebx+012Ch]
        mov ebp, dword [ecx+ebp]
        xor eax, eax
        mov ax, word [byte ebp+0Eh]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        mov edx, dword [dword esp+01D4h]
        add eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 2
        xor eax, eax
        mov ax, word [byte ebp+00h]
        mov dword [dword esp+01A0h], eax
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01A0h]
        mov word [byte ebp+0Eh], ax
        mov ebp, dword [dword esp+ebx+012Ch]
        mov ebp, dword [ecx+ebp]
        xor eax, eax
        mov ax, word [byte ebp+0Ch]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        mov edx, dword [dword esp+01D4h]
        add eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 2
        xor eax, eax
        mov ax, word [byte ebp+00h]
        mov dword [dword esp+01A0h], eax
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01A0h]
        mov word [byte ebp+0Ch], ax
        mov ebp, dword [dword esp+ebx+012Ch]
        mov ebp, dword [ecx+ebp]
        xor eax, eax
        mov ax, word [byte ebp+0Ah]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        mov edx, dword [dword esp+01D4h]
        add eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 2
        xor eax, eax
        mov ax, word [byte ebp+00h]
        mov dword [dword esp+01A0h], eax
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01A0h]
        mov word [byte ebp+0Ah], ax
        mov ebp, dword [dword esp+ebx+012Ch]
        mov ebp, dword [ecx+ebp]
        xor eax, eax
        mov ax, word [byte ebp+08h]
        mov edx, eax
        shl edx, 2
        add edx, eax
        shl edx, 2
        add edx, eax
        shl edx, 2
        xor eax, eax
        mov ax, word [byte ebp+00h]
        mov dword [dword esp+01A0h], eax
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01A0h]
        mov word [byte ebp+08h], ax
        mov ebp, dword [dword esp+ebx+012Ch]
        mov ebp, dword [ecx+ebp]
        xor eax, eax
        mov ax, word [byte ebp+04h]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        mov edx, dword [dword esp+01D4h]
        add eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 2
        xor eax, eax
        mov ax, word [byte ebp+00h]
        mov dword [dword esp+01A0h], eax
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01A0h]
        mov word [byte ebp+04h], ax
        mov ebp, dword [dword esp+ebx+012Ch]
        mov ebp, dword [ecx+ebp]
        xor eax, eax
        mov ax, word [byte ebp+02h]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        mov edx, dword [dword esp+01D4h]
        add eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 2
        xor eax, eax
        mov ax, word [byte ebp+00h]
        mov dword [dword esp+01A0h], eax
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01A0h]
        mov word [byte ebp+02h], ax
        mov eax, dword [dword esp+ebx+012Ch]
        mov eax, dword [ecx+eax]
        mov dx, word [byte eax+02h]
        mov dword [dword esp+01E4h], edx
        mov dx, word [byte eax+04h]
        add dword [dword esp+01E4h], edx
        mov edx, dword [dword esp+01E4h]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+ebx+012Ch]
        mov eax, dword [ecx+eax]
        mov word [eax], 54h
        cmp dword [esp], 444h
        jl short .12
        mov eax, dword [dword esp+ebx+012Ch]
        mov edx, dword [ecx+eax]
        mov eax, dword [dword esp+ebx+0104h]
        add edx, byte 12h
        mov dword [ecx+eax], edx
        jmp short .13
.12:
        mov eax, dword [dword esp+ebx+012Ch]
        mov edx, dword [dword esp+ebx+0104h]
        mov eax, dword [ecx+eax]
        mov dword [ecx+edx], eax
.13:
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+01CCh]
        mov ebx, dword [dword esp+eax*4+012Ch]
        mov edx, dword [ebx+edx*4]
        mov dx, word [byte edx+0Ch]
        and edx, 0FFFFh
        add dword [dword esp+eax*4+018Ch], edx
.14:
        cmp dword [dword esp+01A4h], byte 0
        jne short .16
        mov edx, dword [dword esp+01D0h]
        shl edx, 2
        mov ebx, dword [dword esp+01CCh]
        shl ebx, 2
        mov eax, dword [dword esp+edx+017Ch]
        mov eax, dword [ebx+eax]
        mov eax, dword [byte eax+02Ch]
        call SeasonDbPtr
        mov ecx, eax
        mov eax, dword [dword esp+edx+0154h]
        mov dword [ebx+eax], ecx
        cmp dword [esp], 444h
        jl short .15
        mov eax, dword [dword esp+edx+0154h]
        mov ecx, dword [ebx+eax]
        mov eax, dword [dword esp+edx+015Ch]
        add ecx, byte 12h
        mov dword [ebx+eax], ecx
        jmp short .16
.15:
        mov eax, dword [dword esp+edx+0154h]
        mov edx, dword [dword esp+edx+015Ch]
        mov eax, dword [ebx+eax]
        mov dword [edx+ebx], eax
.16:
        inc dword [dword esp+01CCh]
.17:
        mov ebx, dword [dword esp+01CCh]
        cmp ebx, byte 19h
        jge short .18
        cmp dword [dword esp+01A4h], byte 0
        je near SimulateGame.11
.18:
        xor ebp, ebp
        mov dword [dword esp+01CCh], ebp
        jmp near .25
.19:
        mov edx, dword [dword esp+01D0h]
        shl edx, 2
        mov eax, dword [dword esp+edx+016Ch]
        mov ebx, dword [dword esp+01CCh]
        shl ebx, 2
        mov eax, dword [dword ebx+eax+0B0h]
        cmp eax, byte 0FFFFFFFFh
        je near .24
        call KeyDbPtr
        mov ecx, eax
        mov eax, dword [dword esp+edx+0134h]
        mov dword [ebx+eax], ecx
        cmp dword [dword esp+01A4h], byte 0
        jne short .21
        mov eax, dword [dword esp+edx+0134h]
        mov eax, dword [ebx+eax]
        mov eax, dword [byte eax+028h]
        call CareerDbPtr2
        mov ecx, eax
        mov eax, dword [dword esp+edx+014Ch]
        mov dword [ebx+eax], ecx
        cmp dword [esp], 444h
        jl short .20
        mov eax, dword [dword esp+edx+014Ch]
        mov ecx, dword [ebx+eax]
        mov eax, dword [dword esp+edx+0114h]
        add ecx, byte 16h
        mov dword [ebx+eax], ecx
        jmp short .21
.20:
        mov eax, dword [dword esp+edx+014Ch]
        mov edx, dword [dword esp+edx+0114h]
        mov eax, dword [ebx+eax]
        mov dword [edx+ebx], eax
.21:
        cmp dword [dword esp+01A4h], byte 0
        jne short .24
        mov edx, dword [dword esp+01D0h]
        shl edx, 2
        mov ebx, dword [dword esp+01CCh]
        shl ebx, 2
        mov eax, dword [dword esp+edx+0134h]
        mov eax, dword [ebx+eax]
        mov eax, dword [byte eax+02Ch]
        call SeasonDbPtr2
        mov ecx, dword [dword esp+edx+0124h]
        mov dword [ecx+ebx], eax
        cmp dword [esp], 444h
        jl short .22
        mov eax, dword [dword esp+edx+0124h]
        mov eax, dword [ebx+eax]
        mov edx, dword [dword esp+edx+010Ch]
        add eax, byte 16h
        jmp short .23
.22:
        mov eax, dword [dword esp+edx+0124h]
        mov edx, dword [dword esp+edx+010Ch]
        mov eax, dword [ebx+eax]
.23:
        mov dword [edx+ebx], eax
.24:
        inc dword [dword esp+01CCh]
.25:
        cmp dword [dword esp+01CCh], byte 3
        jge short .26
        cmp dword [dword esp+01A4h], byte 0
        je near SimulateGame.19
.26:
        inc dword [dword esp+01D0h]
.27:
        cmp dword [dword esp+01D0h], byte 2
        jge short .28
        mov ebp, dword [dword esp+01A4h]
        test ebp, ebp
        je near SimulateGame.10
.28:
        xor eax, eax
        mov dword [dword esp+01D0h], eax
        jmp near .49
.29:
        mov byte [dword esp+eax+01ECh], 5
        mov ebx, eax
        shl ebx, 2
        mov edx, dword [dword esp+ebx+018Ch]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov ecx, 54h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [dword esp+ebx+018Ch], eax
        call rand_
        mov edx, eax
        and edx, 7FFFh
        mov ecx, 3E8h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        cmp edx, 136h
        jle short .30
        mov eax, dword [dword esp+ebx+016Ch]
        mov al, byte [dword eax+0E0h]
        jmp short .31
.30:
        mov eax, dword [dword esp+ebx+016Ch]
        mov al, byte [dword eax+0E1h]
.31:
        sub al, 19h
        mov edx, dword [dword esp+01D0h]
        mov byte [dword esp+edx+01D8h], al
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+0174h]
        inc byte [edx]
        xor edx, edx
        mov dl, byte [dword esp+eax+01D8h]
        mov eax, dword [dword esp+eax*4+010Ch]
        mov eax, dword [eax+edx*4]
        xor ebx, ebx
        mov dword [dword esp+01CCh], ebx
        inc word [eax]
.32:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        mov ecx, dword [dword esp+01CCh]
        add eax, ecx
        xor dl, dl
        mov byte [byte esp+eax+06Ch], dl
        lea ebp, [byte ecx+01h]
        mov dword [dword esp+01CCh], ebp
        cmp ebp, byte 19h
        jl short SimulateGame.32
        xor edx, edx
        mov dword [dword esp+01CCh], edx
.33:
        xor ebx, ebx
.34:
        mov eax, dword [dword esp+01D0h]
        mov ecx, dword [dword esp+eax*4+016Ch]
        mov edx, dword [dword esp+01CCh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add ecx, eax
        mov cl, byte [dword ecx+ebx+0BCh]
        cmp cl, 19h
        jae short .35
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        xor eax, eax
        mov al, cl
        add eax, edx
        inc byte [byte esp+eax+06Ch]
.35:
        inc ebx
        cmp ebx, byte 3
        jl short SimulateGame.34
        mov ebx, dword [dword esp+01CCh]
        inc ebx
        mov dword [dword esp+01CCh], ebx
        cmp ebx, byte 4
        jl short SimulateGame.33
        xor ebp, ebp
        mov dword [dword esp+01CCh], ebp
.36:
        xor ebx, ebx
.37:
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+016Ch]
        mov eax, dword [dword esp+01CCh]
        add eax, eax
        add eax, edx
        mov cl, byte [dword ebx+eax+0C8h]
        cmp cl, 19h
        jae short .38
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        xor eax, eax
        mov al, cl
        add eax, edx
        inc byte [byte esp+eax+06Ch]
.38:
        inc ebx
        cmp ebx, byte 2
        jl short SimulateGame.37
        mov eax, dword [dword esp+01CCh]
        inc eax
        mov dword [dword esp+01CCh], eax
        cmp eax, byte 3
        jl short SimulateGame.36
        xor ebx, ebx
        mov dword [dword esp+01CCh], ebx
.39:
        xor ebx, ebx
.40:
        mov eax, dword [dword esp+01D0h]
        mov ecx, dword [dword esp+eax*4+016Ch]
        mov edx, dword [dword esp+01CCh]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add ecx, eax
        mov cl, byte [dword ecx+ebx+0CEh]
        cmp cl, 19h
        jae short .41
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        xor eax, eax
        mov al, cl
        add eax, edx
        inc byte [byte esp+eax+06Ch]
.41:
        inc ebx
        cmp ebx, byte 5
        jl short SimulateGame.40
        mov ecx, dword [dword esp+01CCh]
        inc ecx
        mov dword [dword esp+01CCh], ecx
        cmp ecx, byte 2
        jl short SimulateGame.39
        xor eax, eax
        mov dword [dword esp+01CCh], eax
.42:
        xor ebx, ebx
.43:
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+016Ch]
        mov eax, dword [dword esp+01CCh]
        shl eax, 2
        add eax, edx
        mov cl, byte [dword ebx+eax+0D8h]
        cmp cl, 19h
        jae short .44
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        xor edx, edx
        mov dl, cl
        add eax, edx
        inc byte [byte esp+eax+06Ch]
.44:
        inc ebx
        cmp ebx, byte 4
        jl short SimulateGame.43
        mov edx, dword [dword esp+01CCh]
        inc edx
        mov dword [dword esp+01CCh], edx
        cmp edx, byte 2
        jl short SimulateGame.42
        xor ecx, ecx
        mov dword [dword esp+01CCh], ecx
.45:
        mov eax, dword [dword esp+01D0h]
        mov ecx, dword [dword esp+eax*4+016Ch]
        add ecx, dword [dword esp+01CCh]
        mov cl, byte [dword ecx+0E2h]
        cmp cl, 19h
        jae short .46
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        xor eax, eax
        mov al, cl
        add eax, edx
        inc byte [byte esp+eax+06Ch]
.46:
        mov eax, dword [dword esp+01CCh]
        inc eax
        mov dword [dword esp+01CCh], eax
        cmp eax, byte 2
        jl short SimulateGame.45
        xor ebx, ebx
        mov dword [dword esp+01CCh], ebx
.47:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        mov ecx, dword [dword esp+01CCh]
        add eax, ecx
        cmp byte [byte esp+eax+06Ch], 0
        je short .48
        mov eax, edx
        mov edx, ecx
        mov eax, dword [dword esp+eax*4+015Ch]
        mov eax, dword [eax+edx*4]
        inc word [eax]
.48:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        mov ebp, dword [dword esp+01CCh]
        add eax, ebp
        xor bh, bh
        mov byte [byte esp+eax+06Ch], bh
        lea eax, [byte ebp+01h]
        mov dword [dword esp+01CCh], eax
        cmp eax, byte 19h
        jl short SimulateGame.47
        lea ebx, [byte edx+01h]
        mov dword [dword esp+01D0h], ebx
.49:
        mov eax, dword [dword esp+01D0h]
        cmp eax, byte 2
        jge short .50
        cmp dword [dword esp+01A4h], byte 0
        je near SimulateGame.29
.50:
        mov eax, dword [gameopts]
        and eax, 0C00h
        cmp eax, 800h
        jne short .51
        mov dword [dword esp+01B0h], 3Ch
        jmp short .53
.51:
        cmp eax, 400h
        jne short .52
        mov dword [dword esp+01B0h], 1Eh
        jmp short .53
.52:
        mov dword [dword esp+01B0h], 0Fh
.53:
        xor eax, eax
        mov dword [dword esp+01CCh], eax
        mov dword [dword esp+01B4h], eax
        jmp near .118
.54:
        cmp byte [dword esp+01F4h], 0
        jne near .58
        mov dword [dword esp+01D0h], ebp
.55:
        xor ebx, ebx
.56:
        mov eax, 0Ah
        call RandMod
        mov edx, eax
        cmp eax, ebx
        je short .57
        mov ecx, dword [dword esp+01D0h]
        mov eax, ecx
        shl eax, 2
        add ecx, eax
        shl ecx, 3
        mov eax, ebx
        shl eax, 2
        add eax, ecx
        shl edx, 2
        add edx, ecx
        mov ecx, dword [dword edx+simfwdorder]
        mov ebp, dword [dword eax+simfwdorder]
        xor ebp, ecx
        mov dword [dword eax+simfwdorder], ebp
        mov ecx, ebp
        mov ebp, dword [dword edx+simfwdorder]
        xor ebp, ecx
        mov dword [dword edx+simfwdorder], ebp
        xor dword [dword eax+simfwdorder], ebp
.57:
        inc ebx
        cmp ebx, byte 0Ah
        jl short SimulateGame.56
        mov ebp, dword [dword esp+01D0h]
        inc ebp
        mov dword [dword esp+01D0h], ebp
        cmp ebp, byte 2
        jl short SimulateGame.55
.58:
        cmp byte [dword esp+01F0h], 0
        jne near .62
        xor edx, edx
        mov dword [dword esp+01D0h], edx
.59:
        xor ebx, ebx
.60:
        mov eax, 3
        call RandMod
        mov edx, eax
        cmp eax, ebx
        je short .61
        mov ecx, dword [dword esp+01D0h]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        mov ecx, eax
        shl ecx, 2
        mov eax, ebx
        shl eax, 2
        add eax, ecx
        shl edx, 2
        add edx, ecx
        mov ecx, dword [dword edx+simdorder]
        mov ebp, dword [dword eax+simdorder]
        xor ebp, ecx
        mov dword [dword eax+simdorder], ebp
        mov ecx, ebp
        mov ebp, dword [dword edx+simdorder]
        xor ebp, ecx
        mov dword [dword edx+simdorder], ebp
        xor dword [dword eax+simdorder], ebp
.61:
        inc ebx
        cmp ebx, byte 3
        jl short SimulateGame.60
        mov ebp, dword [dword esp+01D0h]
        inc ebp
        mov dword [dword esp+01D0h], ebp
        cmp ebp, byte 2
        jl short SimulateGame.59
.62:
        xor edx, edx
        mov dword [dword esp+01D0h], edx
.63:
        mov eax, dword [dword esp+01D0h]
        mov al, byte [dword esp+eax+01ECh]
        mov edx, dword [dword esp+01D0h]
        mov byte [dword esp+edx+01E8h], al
        xor cl, cl
        mov byte [dword esp+edx+01ECh], cl
        xor ebx, ebx
.64:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, ebx
        mov ch, byte [dword esp+eax+0ECh]
        test ch, ch
        jbe short .65
        mov dl, ch
        dec dl
        mov byte [dword esp+eax+0ECh], dl
.65:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, ebx
        cmp byte [dword esp+eax+0ECh], 0
        jne short .66
        mov eax, dword [dword esp+01D0h]
        inc byte [dword esp+eax+01ECh]
.66:
        inc ebx
        cmp ebx, byte 5
        jl short SimulateGame.64
        mov eax, dword [dword esp+01D0h]
        xor ebx, ebx
        mov dword [dword esp+eax*4+011Ch], ebx
        lea ecx, [byte eax+01h]
        mov dword [dword esp+01D0h], ecx
        cmp ecx, byte 2
        jl near SimulateGame.63
        mov al, byte [dword esp+01E8h]
        cmp al, byte [dword esp+01ECh]
        jne short .67
        mov al, byte [dword esp+01E9h]
        cmp al, byte [dword esp+01EDh]
        je short .70
.67:
        mov al, byte [dword esp+01ECh]
        cmp al, byte [dword esp+01EDh]
        jbe short .68
        mov al, byte [dword esp+01E8h]
        cmp al, byte [dword esp+01E9h]
        ja short .68
        mov eax, dword [dword esp+0174h]
        inc word [byte eax+0Ah]
        mov eax, dword [dword esp+0178h]
        jmp short .69
.68:
        mov al, byte [dword esp+01EDh]
        cmp al, byte [dword esp+01ECh]
        jbe short .70
        mov al, byte [dword esp+01E9h]
        cmp al, byte [dword esp+01E8h]
        ja short .70
        mov eax, dword [dword esp+0178h]
        inc word [byte eax+0Ah]
        mov eax, dword [dword esp+0174h]
.69:
        inc word [byte eax+0Eh]
.70:
        mov al, byte [dword esp+01ECh]
        mov cl, byte [dword esp+01EDh]
        cmp al, cl
        jbe short .71
        xor edx, edx
        mov dl, cl
        xor eax, eax
        mov al, byte [dword esp+01ECh]
        sub eax, edx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 5
        sub eax, edx
        mov dword [dword esp+011Ch], eax
        neg eax
        mov dword [dword esp+0120h], eax
        jmp short .72
.71:
        cmp cl, al
        jbe short .72
        xor edx, edx
        mov dl, cl
        xor eax, eax
        mov al, byte [dword esp+01ECh]
        sub edx, eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 5
        sub eax, edx
        mov dword [dword esp+0120h], eax
        neg eax
        mov dword [dword esp+011Ch], eax
.72:
        xor eax, eax
        mov dword [dword esp+01D0h], eax
.73:
        mov eax, 3E8h
        call RandMod
        mov ecx, eax
        mov ebx, dword [dword esp+01D0h]
        shl ebx, 2
        mov ebp, dword [dword esp+01D0h]
        movzx ebp, byte [dword esp+ebp+01E0h]
        mov eax, dword [dword esp+ebx+018Ch]
        mov edx, eax
        sar edx, 1Fh
        idiv ebp
        cmp ecx, eax
        jge near .84
        mov ch, 0FFh
        xor ebx, ebx
.74:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        xor eax, eax
        mov al, byte [dword esp+01F4h]
        mov edx, dword [dword edx+eax*4+simfwdorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov dword [dword esp+01A0h], eax
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+016Ch]
        add edx, dword [dword esp+01A0h]
        mov cl, byte [dword edx+ebx+0BCh]
        xor edx, edx
        mov dl, cl
        mov dword [dword esp+01A0h], edx
        mov eax, dword [dword esp+eax*4+012Ch]
        mov eax, dword [eax+edx*4]
        xor edx, edx
        mov dx, word [byte eax+0Ch]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov ebp, 54h
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov edx, eax
        mov ebp, 3Ch
        sar edx, 1Fh
        idiv ebp
        mov ebp, eax
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, dword [dword esp+01A0h]
        mov al, byte [dword esp+eax+0A0h]
        and eax, 0FFh
        mov edx, eax
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub ebp, eax
        mov dword [dword esp+01C8h], ebp
        cmp ch, 0FFh
        je short .75
        mov eax, ebp
        cmp eax, dword [dword esp+01C0h]
        jle short .76
.75:
        mov eax, dword [dword esp+01D0h]
        xor edx, edx
        mov dl, cl
        mov edi, dword [dword esp+eax*4+015Ch]
        mov edi, dword [edi+edx*4]
        mov ch, bl
        mov eax, dword [dword esp+01C8h]
        mov dword [dword esp+01C0h], eax
        mov byte [dword esp+0200h], cl
.76:
        inc ebx
        cmp ebx, byte 3
        jl near SimulateGame.74
        xor ebx, ebx
.77:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        xor eax, eax
        mov al, byte [dword esp+01F0h]
        mov eax, dword [dword edx+eax*4+simdorder]
        add eax, eax
        mov ebp, dword [dword esp+01D0h]
        shl ebp, 2
        mov edx, dword [dword esp+ebp+016Ch]
        add eax, edx
        mov cl, byte [dword ebx+eax+0C8h]
        xor eax, eax
        mov al, cl
        mov dword [dword esp+0198h], eax
        shl eax, 2
        mov dword [dword esp+01B8h], eax
        mov eax, dword [dword esp+ebp+012Ch]
        add eax, dword [dword esp+01B8h]
        mov eax, dword [eax]
        mov ax, word [byte eax+0Ch]
        and eax, 0FFFFh
        mov dword [dword esp+01D4h], eax
        shl eax, 5
        mov edx, dword [dword esp+01D4h]
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov dword [dword esp+01D4h], 54h
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov edx, eax
        mov dword [dword esp+01D4h], 3Ch
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov dword [dword esp+01A0h], eax
        mov eax, dword [dword esp+01D0h]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        mov edx, dword [dword esp+01D4h]
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, dword [dword esp+0198h]
        mov al, byte [dword esp+eax+0A0h]
        and eax, 0FFh
        mov dword [dword esp+01D4h], eax
        shl eax, 5
        mov edx, dword [dword esp+01D4h]
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        mov edx, dword [dword esp+01A0h]
        sub edx, eax
        mov dword [dword esp+01C8h], edx
        mov eax, edx
        cmp eax, dword [dword esp+01C0h]
        jle short .78
        mov edi, dword [dword esp+ebp+015Ch]
        add edi, dword [dword esp+01B8h]
        mov edi, dword [edi]
        mov ch, bl
        add ch, 3
        mov dword [dword esp+01C0h], eax
        mov byte [dword esp+0200h], cl
.78:
        inc ebx
        cmp ebx, byte 2
        jl near SimulateGame.77
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add edx, eax
        xor eax, eax
        mov al, ch
        add eax, edx
        cmp byte [dword esp+eax+0ECh], 0
        jne near .81
        mov eax, 3E8h
        call RandMod
        cmp eax, byte 3Ch
        jge short .79
        mov dl, 5
        jmp short .80
.79:
        mov dl, 2
.80:
        mov dh, dl
        inc dh
        mov ebx, dword [dword esp+01D0h]
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        xor ebx, ebx
        mov bl, ch
        add eax, ebx
        mov byte [dword esp+eax+0ECh], dh
        xor ch, ch
        mov cl, dl
        add word [byte edi+0Ch], cx
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+0200h]
        add edx, eax
        mov eax, dword [dword esp+01D0h]
        mov ebx, dword [dword esp+eax*4+0174h]
        inc byte [dword esp+edx+0A0h]
        add word [byte ebx+010h], cx
        sub dword [dword esp+eax*4+018Ch], 3E8h
.81:
        xor eax, eax
        mov edx, dword [dword esp+01D0h]
        mov al, byte [dword esp+edx+01D8h]
        mov edx, eax
        shl edx, 2
        mov eax, dword [dword esp+01D0h]
        mov eax, dword [dword esp+eax*4+010Ch]
        mov eax, dword [edx+eax]
        inc word [byte eax+0Ch]
        mov eax, dword [dword esp+01D0h]
        inc eax
        mov dword [dword esp+01D0h], eax
        cmp eax, byte 2
        jl near SimulateGame.73
        mov bh, byte [dword esp+01F4h]
        inc bh
        mov byte [dword esp+01F4h], bh
        cmp bh, 0Ah
        jne short .82
        xor ch, ch
        mov byte [dword esp+01F4h], ch
.82:
        mov al, byte [dword esp+01F0h]
        inc al
        mov byte [dword esp+01F0h], al
        cmp al, 3
        jne short .83
        xor dl, dl
        mov byte [dword esp+01F0h], dl
.83:
        mov eax, dword [dword esp+01B0h]
        dec eax
        mov ebx, dword [dword esp+01CCh]
        cmp eax, ebx
        jne near .117
        lea edx, [byte ebx-01h]
        cmp dword [esp], 444h
        jl near .115
        mov eax, dword [dword esp+0184h]
        mov bl, byte [eax]
        mov eax, dword [dword esp+0188h]
        cmp bl, byte [eax]
        jne near .117
        jmp near .116
.84:
        xor eax, eax
        mov edx, dword [dword esp+01D0h]
        mov al, byte [dword esp+edx+01D8h]
        mov edx, dword [dword esp+ebx+014Ch]
        mov eax, dword [edx+eax*4]
        xor edx, edx
        mov dx, word [byte eax+012h]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov ebx, 54h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        mov ebx, 3Ch
        sar edx, 1Fh
        idiv ebx
        mov ebp, eax
        xor ebx, ebx
.85:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+01F4h]
        shl edx, 2
        mov edx, dword [dword edx+eax*8+simfwdorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        mov eax, dword [dword esp+01D0h]
        mov ecx, dword [dword esp+eax*4+016Ch]
        add edx, ecx
        mov cl, byte [dword edx+ebx+0BCh]
        mov edx, ecx
        and edx, 0FFh
        mov eax, dword [dword esp+eax*4+012Ch]
        mov eax, dword [eax+edx*4]
        xor edx, edx
        mov dx, word [byte eax+0Eh]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov ecx, 54h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, eax
        mov ecx, 3Ch
        sar edx, 1Fh
        idiv ecx
        add ebp, eax
        inc ebx
        cmp ebx, byte 3
        jl near SimulateGame.85
        xor ebx, ebx
.86:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        xor eax, eax
        mov al, byte [dword esp+01F0h]
        mov eax, dword [dword edx+eax*4+simdorder]
        add eax, eax
        mov dword [dword esp+01A0h], eax
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+016Ch]
        add edx, dword [dword esp+01A0h]
        mov cl, byte [dword edx+ebx+0C8h]
        mov edx, ecx
        and edx, 0FFh
        mov eax, dword [dword esp+eax*4+012Ch]
        mov eax, dword [eax+edx*4]
        xor edx, edx
        mov dx, word [byte eax+0Eh]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov ecx, 54h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, eax
        mov ecx, 3Ch
        sar edx, 1Fh
        idiv ecx
        add ebp, eax
        inc ebx
        cmp ebx, byte 2
        jl near SimulateGame.86
        mov edx, dword [dword esp+01D0h]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        xor eax, eax
        mov al, byte [dword esp+01F4h]
        shl eax, 2
        add ebx, eax
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, dword [dword ebx+simfwdorder]
        xor edx, edx
        mov dl, byte [dword esp+eax+0F8h]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov eax, dword [dword esp+01B4h]
        inc eax
        imul ebp, eax
        sub ebp, edx
        cmp ebp, 3E8h
        jle near SimulateGame.81
        mov ch, 0FFh
        xor ebx, ebx
.87:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        xor eax, eax
        mov al, byte [dword esp+01F4h]
        mov edx, dword [dword edx+eax*4+simfwdorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov dword [dword esp+01A0h], eax
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+016Ch]
        add edx, dword [dword esp+01A0h]
        mov cl, byte [dword edx+ebx+0BCh]
        movzx ebp, cl
        mov edx, ebp
        shl edx, 2
        mov eax, dword [dword esp+eax*4+012Ch]
        add eax, edx
        mov eax, dword [eax]
        mov ax, word [byte eax+0Eh]
        and eax, 0FFFFh
        mov edx, eax
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov dword [dword esp+01D4h], 54h
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov edx, eax
        mov dword [dword esp+01D4h], 3Ch
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov dword [dword esp+01A0h], eax
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add ebp, eax
        xor edx, edx
        mov dl, byte [byte esp+ebp+038h]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        mov edx, dword [dword esp+01A0h]
        sub edx, eax
        mov dword [dword esp+01C4h], edx
        cmp ch, 0FFh
        je short .88
        mov eax, edx
        cmp eax, dword [dword esp+01BCh]
        jle short .89
.88:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, ebx
        cmp byte [dword esp+eax+0ECh], 0
        jne short .89
        mov eax, dword [dword esp+01D0h]
        xor edx, edx
        mov dl, cl
        mov edi, dword [dword esp+eax*4+015Ch]
        mov edi, dword [edi+edx*4]
        mov ch, bl
        mov eax, dword [dword esp+01C4h]
        mov dword [dword esp+01BCh], eax
        mov byte [dword esp+0200h], cl
.89:
        inc ebx
        cmp ebx, byte 3
        jl near SimulateGame.87
        xor ebx, ebx
.90:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        xor edx, edx
        mov dl, byte [dword esp+01F0h]
        shl edx, 2
        mov edx, dword [dword edx+eax*4+simdorder]
        add edx, edx
        mov ebp, dword [dword esp+01D0h]
        shl ebp, 2
        mov eax, dword [dword esp+ebp+016Ch]
        add eax, edx
        mov cl, byte [dword ebx+eax+0C8h]
        xor eax, eax
        mov al, cl
        mov dword [dword esp+019Ch], eax
        shl eax, 2
        mov dword [dword esp+01A8h], eax
        mov eax, dword [dword esp+ebp+012Ch]
        add eax, dword [dword esp+01A8h]
        mov eax, dword [eax]
        mov ax, word [byte eax+0Eh]
        and eax, 0FFFFh
        mov dword [dword esp+01D4h], eax
        shl eax, 5
        mov edx, dword [dword esp+01D4h]
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov dword [dword esp+01D4h], 54h
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov edx, eax
        mov dword [dword esp+01D4h], 3Ch
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov dword [dword esp+01A0h], eax
        mov eax, dword [dword esp+01D0h]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        mov edx, dword [dword esp+01D4h]
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, dword [dword esp+019Ch]
        mov al, byte [byte esp+eax+038h]
        and eax, 0FFh
        mov dword [dword esp+01D4h], eax
        shl eax, 5
        mov edx, dword [dword esp+01D4h]
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        mov edx, dword [dword esp+01A0h]
        sub edx, eax
        mov dword [dword esp+01C4h], edx
        mov eax, edx
        cmp eax, dword [dword esp+01BCh]
        jle short .91
        mov eax, dword [dword esp+01D0h]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        add eax, dword [dword esp+01D4h]
        add eax, ebx
        cmp byte [dword esp+eax+0EFh], 0
        jne short .91
        mov edi, dword [dword esp+ebp+015Ch]
        add edi, dword [dword esp+01A8h]
        mov edi, dword [edi]
        mov eax, dword [dword esp+01C4h]
        mov dword [dword esp+01BCh], eax
        mov byte [dword esp+0200h], cl
.91:
        inc ebx
        cmp ebx, byte 2
        jl near SimulateGame.90
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        xor ebx, ebx
        mov bl, byte [dword esp+01F4h]
        shl ebx, 2
        add ebx, eax
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [dword ebx+simfwdorder]
        add edx, eax
        mov ebx, dword [dword esp+01D0h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        add ebx, eax
        xor eax, eax
        mov al, byte [dword esp+0200h]
        inc byte [dword esp+edx+0F8h]
        add eax, ebx
        inc byte [byte esp+eax+038h]
        inc word [byte edi+0Eh]
        xor edx, edx
        mov eax, dword [dword esp+01D0h]
        mov dl, byte [dword esp+eax+01D8h]
        mov eax, dword [dword esp+eax*4+010Ch]
        mov eax, dword [eax+edx*4]
        mov edx, dword [dword esp+01D0h]
        xor dl, 1
        inc word [byte eax+012h]
        xor eax, eax
        mov al, byte [dword esp+edx+01D8h]
        mov edx, dword [dword esp+edx*4+014Ch]
        mov edx, dword [edx+eax*4]
        cmp word [byte edx+012h], byte 0
        je short .92
        xor ebx, ebx
        mov bx, word [byte edx+0Eh]
        mov eax, ebx
        shl eax, 5
        sub eax, ebx
        shl eax, 2
        add ebx, eax
        shl ebx, 3
        xor ecx, ecx
        mov cx, word [byte edx+012h]
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov ebx, eax
        jmp short .93
.92:
        call rand_
        mov edx, eax
        and edx, 7FFFh
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        lea ebx, [byte edx+01h]
.93:
        xor edx, edx
        mov eax, dword [dword esp+01D0h]
        mov dl, byte [dword esp+eax+01DCh]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov ecx, 21h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        sub ebx, eax
        mov eax, dword [dword esp+01D0h]
        xor edx, edx
        mov dl, byte [dword esp+0200h]
        mov eax, dword [dword esp+eax*4+012Ch]
        mov edx, dword [eax+edx*4]
        cmp word [byte edx+0Eh], byte 0
        je short .94
        xor ecx, ecx
        mov cx, word [byte edx+02h]
        mov eax, ecx
        shl eax, 5
        sub eax, ecx
        shl eax, 2
        add ecx, eax
        shl ecx, 3
        movzx ebp, word [byte edx+0Eh]
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv ebp
        jmp short .95
.94:
        call rand_
        mov edx, eax
        and edx, 7FFFh
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        lea eax, [byte edx+01h]
.95:
        mov edx, dword [dword esp+01B4h]
        cmp edx, dword [dword esp+01B0h]
        jl short .96
        mov edx, dword [dword esp+0220h]
        cmp edx, dword [dword esp+01D0h]
        jne short .96
        mov ebx, 3E8h
        jmp short .97
.96:
        lea edx, [eax+ebx]
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, eax
        mov eax, dword [dword esp+01D0h]
        add edx, dword [dword esp+eax*4+011Ch]
        lea ebx, [byte edx+0Dh]
.97:
        mov eax, 3E8h
        call RandMod
        mov edx, eax
        mov ecx, dword [dword esp+0220h]
        test ecx, ecx
        je short .98
        cmp ecx, byte 1
        jne short .100
.98:
        mov eax, dword [dword esp+01D0h]
        cmp eax, dword [dword esp+0220h]
        je short .100
        xor al, 1
        xor ecx, ecx
        mov cl, byte [dword esp+eax+01DCh]
        mov dword [dword esp+01A0h], ecx
        xor ecx, ecx
        mov ebp, dword [dword esp+01D0h]
        mov cl, byte [dword esp+ebp+01DCh]
        mov dword [dword esp+01D4h], ecx
        mov ecx, dword [dword esp+01A0h]
        dec ecx
        cmp ecx, dword [dword esp+01D4h]
        jle short .99
        cmp byte [dword esp+eax+01DCh], 0
        jne short .100
.99:
        lea edx, [byte ebx+01h]
.100:
        cmp edx, ebx
        jg near SimulateGame.81
        mov al, byte [dword esp+0200h]
        mov byte [dword esp+01F8h], al
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        xor eax, eax
        mov al, byte [dword esp+0200h]
        inc word [byte edi+02h]
        inc word [byte edi+06h]
        add eax, edx
        mov ebx, dword [dword esp+01D0h]
        xor bl, 1
        xor edx, edx
        mov dl, byte [dword esp+ebx+01D8h]
        mov ecx, edx
        shl ecx, 2
        shl ebx, 2
        mov edx, dword [dword esp+ebx+010Ch]
        inc byte [byte esp+eax+06Ch]
        mov edx, dword [ecx+edx]
        mov eax, dword [dword esp+01D0h]
        shl eax, 2
        inc word [byte edx+0Eh]
        mov edx, dword [dword esp+eax+0174h]
        inc word [byte edx+04h]
        mov edx, dword [dword esp+eax+0184h]
        inc byte [edx]
        mov edx, dword [dword esp+01D0h]
        inc byte [dword esp+edx+01DCh]
        cmp dword [dword esp+eax+011Ch], byte 0
        jle short .101
        mov eax, dword [dword esp+eax+0174h]
        inc word [byte eax+08h]
        inc word [byte edi+08h]
        mov eax, dword [dword esp+ebx+0174h]
        inc word [byte eax+0Ch]
.101:
        mov eax, dword [dword esp+01D0h]
        xor al, 1
        mov eax, dword [dword esp+eax*4+0174h]
        mov edx, dword [dword esp+01D0h]
        inc word [byte eax+06h]
        cmp dword [dword esp+edx*4+011Ch], byte 0
        jge short .102
        inc word [byte edi+0Ah]
.102:
        xor ebx, ebx
.103:
        mov eax, dword [dword esp+01D0h]
        mov edx, eax
        shl edx, 2
        add edx, eax
        shl edx, 3
        xor eax, eax
        mov al, byte [dword esp+01F4h]
        shl eax, 2
        mov dword [dword esp+01D4h], eax
        add edx, eax
        mov edx, dword [dword edx+simfwdorder]
        mov ecx, edx
        shl ecx, 2
        sub ecx, edx
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+016Ch]
        add ecx, edx
        mov cl, byte [dword ecx+ebx+0BCh]
        xor edx, edx
        mov dl, cl
        mov eax, dword [dword esp+eax*4+015Ch]
        mov edx, dword [eax+edx*4]
        mov ebp, dword [dword esp+01D0h]
        xor ebp, byte 1
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        inc word [byte edx+010h]
        mov edx, dword [dword esp+01D4h]
        mov edx, dword [dword edx+eax*8+simfwdorder]
        mov ecx, edx
        shl ecx, 2
        sub ecx, edx
        mov edx, dword [dword esp+ebp*4+016Ch]
        add ecx, edx
        mov cl, byte [dword ecx+ebx+0BCh]
        xor edx, edx
        mov dl, cl
        mov eax, dword [dword esp+ebp*4+015Ch]
        mov eax, dword [eax+edx*4]
        dec word [byte eax+010h]
        inc ebx
        cmp ebx, byte 3
        jl near SimulateGame.103
        xor ebx, ebx
.104:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        xor edx, edx
        mov dl, byte [dword esp+01F0h]
        shl edx, 2
        mov dword [dword esp+01D4h], edx
        add eax, edx
        mov edx, dword [dword eax+simdorder]
        add edx, edx
        mov eax, dword [dword esp+01D0h]
        mov ecx, dword [dword esp+eax*4+016Ch]
        add ecx, edx
        mov cl, byte [dword ecx+ebx+0C8h]
        xor edx, edx
        mov dl, cl
        mov ecx, edx
        shl ecx, 2
        mov edx, dword [dword esp+eax*4+015Ch]
        mov edx, dword [ecx+edx]
        mov ebp, eax
        xor ebp, byte 1
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 2
        inc word [byte edx+010h]
        add eax, dword [dword esp+01D4h]
        mov edx, dword [dword eax+simdorder]
        add edx, edx
        mov ecx, dword [dword esp+ebp*4+016Ch]
        add ecx, edx
        mov cl, byte [dword ecx+ebx+0C8h]
        xor edx, edx
        mov dl, cl
        mov eax, dword [dword esp+ebp*4+015Ch]
        mov eax, dword [eax+edx*4]
        dec word [byte eax+010h]
        inc ebx
        cmp ebx, byte 2
        jl near SimulateGame.104
        xor ch, ch
        mov byte [dword esp+0204h], ch
        mov eax, 3E8h
        call RandMod
        mov edx, eax
        cmp eax, 320h
        jg short .105
        mov eax, dword [dword esp+01D0h]
        cmp byte [dword esp+eax+01ECh], 2
        jb short .105
        mov byte [dword esp+0204h], 2
        jmp short .106
.105:
        cmp edx, 384h
        jg short .106
        mov eax, dword [dword esp+01D0h]
        cmp byte [dword esp+eax+01ECh], 1
        jb short .106
        mov byte [dword esp+0204h], 1
.106:
        mov byte [dword esp+01FCh], 0FFh
.107:
        cmp byte [dword esp+0204h], 0
        je near SimulateGame.81
        mov ch, 0FFh
        xor ebx, ebx
.108:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+01F4h]
        shl edx, 2
        mov edx, dword [dword edx+eax*8+simfwdorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov dword [dword esp+01D4h], eax
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+016Ch]
        add edx, dword [dword esp+01D4h]
        mov cl, byte [dword edx+ebx+0BCh]
        movzx ebp, cl
        mov edx, ebp
        shl edx, 2
        mov eax, dword [dword esp+eax*4+012Ch]
        add eax, edx
        mov eax, dword [eax]
        mov ax, word [byte eax+04h]
        and eax, 0FFFFh
        mov edx, eax
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov dword [dword esp+01D4h], 54h
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov edx, eax
        mov dword [dword esp+01D4h], 3Ch
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov dword [dword esp+01D4h], eax
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add ebp, eax
        xor edx, edx
        mov dl, byte [byte esp+ebp+04h]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        mov edx, dword [dword esp+01D4h]
        sub edx, eax
        cmp ch, 0FFh
        je short .109
        cmp edx, esi
        jle short .110
.109:
        mov eax, dword [dword esp+01D0h]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        add eax, dword [dword esp+01D4h]
        add eax, ebx
        cmp byte [dword esp+eax+0ECh], 0
        jne short .110
        cmp cl, byte [dword esp+01F8h]
        je short .110
        cmp cl, byte [dword esp+01FCh]
        je short .110
        mov eax, dword [dword esp+01D0h]
        movzx esi, cl
        mov edi, dword [dword esp+eax*4+015Ch]
        mov edi, dword [edi+esi*4]
        mov ch, bl
        mov esi, edx
        mov byte [dword esp+0200h], cl
.110:
        inc ebx
        cmp ebx, byte 3
        jl near SimulateGame.108
        xor ebx, ebx
.111:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        xor eax, eax
        mov al, byte [dword esp+01F0h]
        mov eax, dword [dword edx+eax*4+simdorder]
        add eax, eax
        mov dword [dword esp+01D4h], eax
        mov eax, dword [dword esp+01D0h]
        mov edx, dword [dword esp+eax*4+016Ch]
        add edx, dword [dword esp+01D4h]
        mov cl, byte [dword edx+ebx+0C8h]
        movzx ebp, cl
        mov edx, ebp
        shl edx, 2
        mov eax, dword [dword esp+eax*4+012Ch]
        add eax, edx
        mov eax, dword [eax]
        mov ax, word [byte eax+04h]
        and eax, 0FFFFh
        mov edx, eax
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add edx, eax
        shl edx, 3
        mov dword [dword esp+01D4h], 54h
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov edx, eax
        mov dword [dword esp+01D4h], 3Ch
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+01D4h]
        mov dword [dword esp+01D4h], eax
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add ebp, eax
        xor edx, edx
        mov dl, byte [byte esp+ebp+04h]
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        mov edx, dword [dword esp+01D4h]
        sub edx, eax
        cmp ch, 0FFh
        je short .112
        cmp edx, esi
        jle short .113
.112:
        mov eax, dword [dword esp+01D0h]
        mov dword [dword esp+01D4h], eax
        shl eax, 2
        add eax, dword [dword esp+01D4h]
        add eax, ebx
        cmp byte [dword esp+eax+0EFh], 0
        jne short .113
        cmp cl, byte [dword esp+01F8h]
        je short .113
        cmp cl, byte [dword esp+01FCh]
        je short .113
        mov eax, dword [dword esp+01D0h]
        movzx esi, cl
        mov edi, dword [dword esp+eax*4+015Ch]
        mov edi, dword [edi+esi*4]
        mov ch, bl
        add ch, 3
        mov esi, edx
        mov byte [dword esp+0200h], cl
.113:
        inc ebx
        cmp ebx, byte 2
        jl near SimulateGame.111
        cmp ch, 0FFh
        je short .114
        mov al, byte [dword esp+0200h]
        mov byte [dword esp+01FCh], al
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        xor eax, eax
        mov al, byte [dword esp+0200h]
        add eax, edx
        inc byte [byte esp+eax+04h]
        inc word [byte edi+04h]
        inc word [byte edi+06h]
        dec byte [dword esp+0204h]
        jmp near SimulateGame.107
.114:
        xor dl, dl
        mov byte [dword esp+0204h], dl
        jmp near SimulateGame.107
.115:
        mov eax, dword [dword esp+0184h]
        mov bl, byte [eax]
        mov eax, dword [dword esp+0188h]
        cmp bl, byte [eax]
        jne short .117
        mov ebp, dword [dword esp+01ACh]
        cmp ebp, byte 5
        jge short .117
        lea eax, [byte ebp+01h]
        mov dword [dword esp+01ACh], eax
.116:
        mov dword [dword esp+01CCh], edx
.117:
        inc dword [dword esp+01CCh]
        inc dword [dword esp+01B4h]
.118:
        mov eax, dword [dword esp+01CCh]
        cmp eax, dword [dword esp+01B0h]
        jge short .119
        mov ebp, dword [dword esp+01A4h]
        test ebp, ebp
        je near SimulateGame.54
.119:
        mov eax, dword [dword esp+0184h]
        mov dl, byte [eax]
        mov eax, dword [dword esp+0188h]
        cmp dl, byte [eax]
        jne short .120
        mov eax, dword [dword esp+0174h]
        inc byte [byte eax+03h]
        mov eax, dword [dword esp+0178h]
        inc byte [byte eax+03h]
        xor eax, eax
        mov al, byte [dword esp+01D8h]
        shl eax, 2
        add eax, dword [dword esp+010Ch]
        mov eax, dword [eax]
        inc word [byte eax+06h]
        xor eax, eax
        mov al, byte [dword esp+01D9h]
        shl eax, 2
        add eax, dword [dword esp+0110h]
        mov eax, dword [eax]
        inc word [byte eax+06h]
        jmp near .123
.120:
        mov eax, dword [dword esp+0184h]
        mov dl, byte [eax]
        mov eax, dword [dword esp+0188h]
        cmp dl, byte [eax]
        jbe short .121
        mov eax, dword [dword esp+0174h]
        inc byte [byte eax+01h]
        mov eax, dword [dword esp+0178h]
        inc byte [byte eax+02h]
        xor eax, eax
        mov al, byte [dword esp+01D8h]
        shl eax, 2
        add eax, dword [dword esp+010Ch]
        mov eax, dword [eax]
        inc word [byte eax+02h]
        xor eax, eax
        mov al, byte [dword esp+01D9h]
        shl eax, 2
        add eax, dword [dword esp+0110h]
        jmp short .122
.121:
        mov eax, dword [dword esp+0178h]
        inc byte [byte eax+01h]
        mov eax, dword [dword esp+0174h]
        inc byte [byte eax+02h]
        xor eax, eax
        mov al, byte [dword esp+01D9h]
        shl eax, 2
        add eax, dword [dword esp+0110h]
        mov eax, dword [eax]
        inc word [byte eax+02h]
        xor eax, eax
        mov al, byte [dword esp+01D8h]
        shl eax, 2
        add eax, dword [dword esp+010Ch]
.122:
        mov eax, dword [eax]
        inc word [byte eax+04h]
.123:
        xor eax, eax
        mov dword [dword esp+0194h], eax
        mov eax, dword [dword esp+0184h]
        cmp byte [eax], 0
        jne short .124
        xor eax, eax
        mov al, byte [dword esp+01D9h]
        shl eax, 2
        add eax, dword [dword esp+0110h]
        mov eax, dword [eax]
        inc word [byte eax+08h]
        xor ecx, ecx
        mov cl, byte [dword esp+01D9h]
        add ecx, byte 19h
        mov ebx, 1
        lea edx, [dword esp+0D4h]
        lea eax, [dword esp+0194h]
        call SimAddPair
.124:
        mov eax, dword [dword esp+0188h]
        cmp byte [eax], 0
        jne short .125
        xor eax, eax
        mov al, byte [dword esp+01D8h]
        shl eax, 2
        add eax, dword [dword esp+010Ch]
        mov eax, dword [eax]
        inc word [byte eax+08h]
        xor ecx, ecx
        mov cl, byte [dword esp+01D8h]
        add ecx, byte 19h
        xor ebx, ebx
        lea edx, [dword esp+0D4h]
        lea eax, [dword esp+0194h]
        call SimAddPair
.125:
        xor ecx, ecx
        mov dword [dword esp+01D0h], ecx
        mov ebx, 0FFh
        jmp short .130
.126:
        mov dword [dword esp+01CCh], edx
        jmp short .128
.127:
        mov eax, dword [dword esp+01D0h]
        shl eax, 3
        mov edx, ebp
        shl edx, 2
        add eax, edx
        mov dword [dword esp+eax+0D4h], ebx
        lea ecx, [byte ebp+01h]
        mov dword [dword esp+01CCh], ecx
.128:
        mov ebp, dword [dword esp+01CCh]
        cmp ebp, byte 2
        jge short .129
        cmp dword [dword esp+01A4h], byte 0
        je short SimulateGame.127
.129:
        inc dword [dword esp+01D0h]
.130:
        cmp dword [dword esp+01D0h], byte 3
        jge short .131
        mov edx, dword [dword esp+01A4h]
        test edx, edx
        je short SimulateGame.126
.131:
        mov ch, 0FFh
        mov cl, ch
        xor ebx, ebx
        mov dword [dword esp+01D0h], ebx
        jmp near .138
.132:
        mov dword [dword esp+01CCh], edi
        jmp short .136
.133:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, dword [dword esp+01CCh]
        xor edx, edx
        mov dl, byte [byte esp+eax+06Ch]
        lea esi, [edx+edx]
        xor edx, edx
        mov dl, byte [byte esp+eax+04h]
        add edx, esi
        mov al, byte [byte esp+eax+038h]
        and eax, 0FFh
        add eax, edx
        cmp cl, 0FFh
        je short .134
        cmp eax, ebx
        jle short .135
.134:
        mov ch, byte [dword esp+01D0h]
        mov cl, byte [dword esp+01CCh]
.135:
        inc dword [dword esp+01CCh]
.136:
        cmp dword [dword esp+01CCh], byte 19h
        jge short .137
        cmp dword [dword esp+01A4h], byte 0
        je short SimulateGame.133
.137:
        inc dword [dword esp+01D0h]
.138:
        cmp dword [dword esp+01D0h], byte 2
        jge short .139
        mov edi, dword [dword esp+01A4h]
        test edi, edi
        je near SimulateGame.132
.139:
        cmp ch, 0FFh
        je short .140
        xor eax, eax
        mov al, cl
        xor ebx, ebx
        mov bl, ch
        mov ecx, eax
        lea edx, [dword esp+0D4h]
        lea eax, [dword esp+0194h]
        call SimAddPair
.140:
        mov ch, 0FFh
        mov cl, ch
        xor ebx, ebx
        mov dword [dword esp+01D0h], ebx
        jmp short .147
.141:
        mov dword [dword esp+01CCh], esi
        jmp short .145
.142:
        mov edx, dword [dword esp+01D0h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, dword [dword esp+01CCh]
        mov al, byte [byte esp+eax+06Ch]
        and eax, 0FFh
        cmp cl, 0FFh
        je short .143
        cmp eax, ebx
        jle short .144
.143:
        mov ch, byte [dword esp+01D0h]
        mov cl, byte [dword esp+01CCh]
.144:
        inc dword [dword esp+01CCh]
.145:
        cmp dword [dword esp+01CCh], byte 19h
        jge short .146
        cmp dword [dword esp+01A4h], byte 0
        je short SimulateGame.142
.146:
        inc dword [dword esp+01D0h]
.147:
        cmp dword [dword esp+01D0h], byte 2
        jge short .148
        mov esi, dword [dword esp+01A4h]
        test esi, esi
        je short SimulateGame.141
.148:
        cmp ch, 0FFh
        je short .149
        xor eax, eax
        mov al, cl
        xor ebx, ebx
        mov bl, ch
        mov ecx, eax
        lea edx, [dword esp+0D4h]
        lea eax, [dword esp+0194h]
        call SimAddPair
.149:
        mov ch, 0FFh
        mov cl, ch
        xor ebx, ebx
        mov dword [dword esp+01D0h], ebx
        mov ebp, dword [dword esp+01A4h]
        jmp short .156
.150:
        mov dword [dword esp+01CCh], edx
        mov edx, dword [dword esp+01D0h]
        jmp short .154
.151:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, edi
        mov al, byte [byte esp+eax+04h]
        and eax, 0FFh
        cmp cl, 0FFh
        je short .152
        cmp eax, ebx
        jle short .153
.152:
        mov ch, byte [dword esp+01D0h]
        mov cl, byte [dword esp+01CCh]
.153:
        inc dword [dword esp+01CCh]
.154:
        mov edi, dword [dword esp+01CCh]
        cmp edi, byte 19h
        jge short .155
        test ebp, ebp
        je short SimulateGame.151
.155:
        inc dword [dword esp+01D0h]
.156:
        cmp dword [dword esp+01D0h], byte 2
        jge short .157
        mov edx, dword [dword esp+01A4h]
        test edx, edx
        je short SimulateGame.150
.157:
        cmp ch, 0FFh
        je short .158
        xor eax, eax
        mov al, cl
        xor ebx, ebx
        mov bl, ch
        mov ecx, eax
        lea edx, [dword esp+0D4h]
        lea eax, [dword esp+0194h]
        call SimAddPair
.158:
        xor ebx, ebx
        mov dword [dword esp+01D0h], ebx
        mov ebp, dword [dword esp+01A4h]
        jmp short .162
.159:
        mov ch, byte [dword esp+edi*8+0D4h]
        mov cl, byte [dword esp+edi*8+0D8h]
        cmp ch, 0FFh
        je short .161
        cmp cl, 0FFh
        je short .161
        xor eax, eax
        mov al, ch
        shl eax, 2
        xor edx, edx
        mov dl, cl
        shl edx, 2
        mov ebx, dword [dword esp+eax+017Ch]
        mov ebx, dword [edx+ebx]
        lea ecx, [edi+edi]
        cmp byte [byte ebx+02h], 47h
        jne short .160
        mov eax, dword [dword esp+eax+0124h]
        mov eax, dword [edx+eax]
        inc word [byte ecx+eax+030h]
        jmp short .161
.160:
        mov eax, dword [dword esp+eax+0154h]
        mov eax, dword [edx+eax]
        inc word [byte ecx+eax+028h]
.161:
        inc dword [dword esp+01D0h]
.162:
        mov edi, dword [dword esp+01D0h]
        cmp edi, byte 3
        jge short .163
        test ebp, ebp
        je short SimulateGame.159
.163:
        xor eax, eax
        mov dword [dword esp+01D0h], eax
.164:
        xor eax, eax
        mov edx, dword [dword esp+01D0h]
        mov al, byte [dword esp+edx+01D8h]
        mov ebx, eax
        shl ebx, 2
        mov eax, dword [dword esp+edx*4+010Ch]
        mov ebx, dword [ebx+eax]
        mov cx, word [ebx]
        test cx, cx
        je short .165
        xor edx, edx
        mov dx, word [byte ebx+0Eh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        xor ecx, ecx
        mov cx, word [ebx]
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov word [byte ebx+010h], ax
        jmp short .166
.165:
        mov word [byte ebx+010h], cx
.166:
        xor ebx, ebx
        mov eax, dword [dword esp+01D0h]
        mov bl, byte [dword esp+eax+01D8h]
        mov eax, dword [dword esp+eax*4+010Ch]
        mov ebx, dword [eax+ebx*4]
        mov ax, word [byte ebx+012h]
        test ax, ax
        je short .167
        xor edx, edx
        mov dx, word [byte ebx+0Eh]
        xor ecx, ecx
        mov cx, ax
        mov eax, ecx
        sub eax, edx
        mov esi, eax
        shl esi, 5
        sub esi, eax
        shl esi, 2
        add esi, eax
        shl esi, 3
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [esi+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
.167:
        mov word [byte ebx+014h], ax
        mov ebx, dword [dword esp+01D0h]
        inc ebx
        mov dword [dword esp+01D0h], ebx
        cmp ebx, byte 2
        jl near SimulateGame.164
        xor esi, esi
        mov dword [dword esp+01D0h], esi
        jmp near .177
.168:
        mov ebx, dword [dword esp+edi*4+013Ch]
        mov edx, dword [dword esp+edi*4+016Ch]
        mov eax, dword [dword esp+0218h]
        call WriteTeamRec
        mov dword [dword esp+01A4h], eax
        mov dword [dword esp+01CCh], ebp
        mov edi, dword [dword esp+01A4h]
        jmp short .171
.169:
        mov edx, dword [dword esp+01D0h]
        shl edx, 2
        mov eax, dword [dword esp+edx+016Ch]
        mov ebx, esi
        shl ebx, 2
        mov eax, dword [byte ebx+eax+04Ch]
        cmp eax, byte 0FFFFFFFFh
        je short .170
        mov eax, dword [dword esp+edx+017Ch]
        mov eax, dword [ebx+eax]
        mov eax, dword [byte eax+02Ch]
        mov edx, dword [dword esp+edx+0154h]
        mov edx, dword [edx+ebx]
        mov ebx, dword [seasondb]
        add eax, ebx
        mov ebx, 2Fh
        call memcpy_
.170:
        inc dword [dword esp+01CCh]
.171:
        mov esi, dword [dword esp+01CCh]
        cmp esi, byte 19h
        jge short .172
        test edi, edi
        je short SimulateGame.169
.172:
        xor ebp, ebp
        mov dword [dword esp+01CCh], ebp
        jmp short .175
.173:
        mov edx, dword [dword esp+01D0h]
        shl edx, 2
        mov eax, dword [dword esp+edx+016Ch]
        mov ebx, dword [dword esp+01CCh]
        shl ebx, 2
        mov eax, dword [dword ebx+eax+0B0h]
        cmp eax, byte 0FFFFFFFFh
        je short .174
        mov eax, dword [dword esp+edx+0134h]
        mov eax, dword [ebx+eax]
        mov eax, dword [byte eax+02Ch]
        mov edx, dword [dword esp+edx+0124h]
        mov edx, dword [edx+ebx]
        mov ebx, dword [seasondb]
        add eax, ebx
        mov ebx, 2Fh
        call memcpy_
.174:
        inc dword [dword esp+01CCh]
.175:
        cmp dword [dword esp+01CCh], byte 3
        jge short .176
        cmp dword [dword esp+01A4h], byte 0
        je short SimulateGame.173
.176:
        inc dword [dword esp+01D0h]
.177:
        mov edi, dword [dword esp+01D0h]
        cmp edi, byte 2
        jge short .178
        mov ebp, dword [dword esp+01A4h]
        test ebp, ebp
        je near SimulateGame.168
.178:
        xor eax, eax
        mov dword [dword esp+01D0h], eax
.179:
        mov esi, dword [dword esp+01D0h]
        mov ebx, dword [dword esp+esi*4+0114h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov ecx, dword [dword esp+esi*4+014Ch]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov edi, dword [dword esp+esi*4+010Ch]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+esi*4+0124h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [dword esp+esi*4+0134h]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [dword esp+esi*4+0104h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [dword esp+esi*4+012Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov ecx, dword [dword esp+esi*4+015Ch]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov edi, dword [dword esp+esi*4+0154h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+esi*4+017Ch]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [dword esp+esi*4+0164h]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [dword esp+esi*4+016Ch]
        push edx
        call FreeMemBlock
        add esp, byte 4
        lea ebx, [byte esi+01h]
        mov dword [dword esp+01D0h], ebx
        cmp ebx, byte 2
        jl near SimulateGame.179
        mov eax, dword [dword esp+01A4h]
        add esp, 208h
        pop ebp
        pop edi
        pop esi
        ret 0Ch
;-----------------------------------------------------------------------------
; LoadScreenPalTick                                               47951  95 PC
; Timer callback: every 4th tick rotates to the next of the 3 loading-screen
; palettes (loadpals) unless palcyclelock
;-----------------------------------------------------------------------------
; C: src/front/simgame/LoadScreenPalTick.c
%ifdef CBUILD
%include "c/front/simgame/LoadScreenPalTick.inc"
%else
LoadScreenPalTick:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        cmp dword [palcyclelock], byte 1
        je near .x
        mov ah, byte [palcycledelay]
        test ah, ah
        jbe short .1
        mov dh, ah
        dec dh
        mov byte [palcycledelay], dh
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov ebx, 1
        mov dword [palcyclelock], ebx
        mov byte [palcycledelay], 3
        xor edx, edx
        mov dl, byte [palcyclephase]
        add edx, ebx
        mov ebx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov byte [palcyclephase], dl
        call sub_B4C61
        xor edx, edx
        mov dl, byte [palcyclephase]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 8
        add eax, loadpals
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [palcyclelock], ecx
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShowLoadingScreen                                               479E9  95 PC
; Once (loadscreenon), if enough free memory: shows the "load" picture,
; builds 3 rotated copies of its palette, installs LoadScreenPalTick as timer
; callback and fades in; cleared by engine_init
;-----------------------------------------------------------------------------
; C: src/front/simgame/ShowLoadingScreen.c
%ifdef CBUILD
%include "c/front/simgame/ShowLoadingScreen.inc"
%else
ShowLoadingScreen:
        push dword 934h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 910h
        mov edx, dword [loadscreenon]
        test edx, edx
        jne near .x
        push loadpals
        push dword 100h
        push edx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 8
        mov edx, loadpals
        mov eax, 1
        call FadePalStep
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        call MemLargestFree
        cmp eax, 222E0h
        jle near .x
        mov ebx, 900h
        xor edx, edx
        mov eax, loadpals
        call memset_
        xor ecx, ecx
        mov ebx, str_LoadPic
        cmp byte [fileoncd+0222h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0900h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0904h]
        push eax
        call LoadBank
        add esp, byte 8
        mov edi, eax
        push str_Pal23
        push eax
        call FindShape
        add esp, byte 8
        lea ecx, [byte eax+010h]
        mov ebx, 300h
        mov edx, ecx
        mov eax, esp
        call memcpy_
        mov ebx, 300h
        mov edx, ecx
        lea eax, [dword esp+0300h]
        call memcpy_
        mov ebx, 300h
        mov edx, ecx
        lea eax, [dword esp+0600h]
        call memcpy_
        mov edx, 1
.3:
        cmp edx, byte 60h
        jge short .4
        lea esi, [byte edx+02Fh]
        jmp short .5
.4:
        lea esi, [byte edx-05Fh]
.5:
        mov eax, esi
        shl eax, 2
        sub eax, esi
        mov ebx, edx
        shl ebx, 2
        sub ebx, edx
        mov cl, byte [esp+eax]
        mov byte [dword esp+ebx+0300h], cl
        mov cl, byte [byte esp+eax+01h]
        mov byte [dword esp+ebx+0301h], cl
        mov al, byte [byte esp+eax+02h]
        mov byte [dword esp+ebx+0302h], al
        inc edx
        cmp edx, 90h
        jl short ShowLoadingScreen.3
        mov edx, 1
.6:
        cmp edx, byte 30h
        jge short .7
        lea esi, [byte edx+060h]
        jmp short .8
.7:
        lea esi, [byte edx-02Fh]
.8:
        mov ebx, esi
        shl ebx, 2
        sub ebx, esi
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov cl, byte [esp+ebx]
        mov byte [dword esp+eax+0600h], cl
        mov cl, byte [byte esp+ebx+01h]
        mov byte [dword esp+eax+0601h], cl
        mov bl, byte [byte esp+ebx+02h]
        mov byte [dword esp+eax+0602h], bl
        inc edx
        cmp edx, 90h
        jl short ShowLoadingScreen.6
        push str_LoadPic
        push edi
        call FindShape
        add esp, byte 8
        push byte 4Bh
        push byte 64h
        push eax
        call DrawArtOpaque
        add esp, byte 0Ch
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov dword [palcyclelock], 1
        xor dl, dl
        mov byte [palcyclephase], dl
        mov byte [palcycledelay], 3
        push LoadScreenPalTick
        call addtimer
        add esp, byte 4
        xor ecx, ecx
        mov dword [palcyclelock], ecx
        xor esi, esi
.9:
        test esi, esi
        jne short .13
        mov esi, 1
        xor ecx, ecx
.10:
        xor edx, edx
.11:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 8
        add eax, edx
        mov bl, byte [dword eax+loadpals]
        cmp bl, byte [esp+eax]
        jge short .12
        inc bl
        mov byte [dword eax+loadpals], bl
        cmp esi, byte 1
        jne short .12
        xor esi, esi
.12:
        inc edx
        cmp edx, 300h
        jl short ShowLoadingScreen.11
        inc ecx
        cmp ecx, byte 3
        jl short ShowLoadingScreen.10
        push byte 2
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        jmp short ShowLoadingScreen.9
.13:
        mov dword [loadscreenon], 1
.x:
        add esp, 910h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
