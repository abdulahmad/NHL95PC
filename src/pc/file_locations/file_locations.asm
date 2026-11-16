; Which files live on the CD, and the coach's cut scene after a game.
bits 32
%include "hockey.inc"
section s_8BAAF progbits alloc exec nowrite align=1
extern __CHK, str_S9, cddriveptr, cddrivestr, FadeOutPalCycle, FadePalette, FatalError, fclose_
extern fgets_, fileoncd, fopen_, FreeCoachClip, FreeMemBlock, fscanf_, gameopts, InputInstall
extern InputRemove, MakePath, memcpy_, MusicChanReset2, MusicOn, musicslot, PlayMVI, rand_
extern SayCoachClip, songdata, SpeechBusy, sprintf_, str_ALLFILESTXT, str_ALLFILESTXT2, str_CantOpenNhlCfg2, str_Clip04d
extern str_Cmv2, str_Coach, str_Coachcut, str_CouldNotOpenALLFILES, str_Iff13, str_NhlCfg, str_Pal29, str_Scrn4
extern strcat_, stricmp_, PushMemDescriptorLocked, LoadBank, LoadDigiFile, SndQuery, SetPalette, DrawBitmap
extern FindShape, SetScreenTarget, str_ModeR, WaitClickTimeout
global InitFileLocations, CoachCutScene
;-----------------------------------------------------------------------------
; InitFileLocations                            8BAAF  95 PC, medium confidence
; From main_: reads nhl.cfg (2nd line = CD drive letter into cddrivestr),
; opens <drive>:ALLFILES.TXT (or local), marks all 549 fileoncd entries 1
;
; then clears those listed as installed
;-----------------------------------------------------------------------------
; C: src/pc/file_locations/InitFileLocations.c
%ifdef CBUILD
%include "c/pc/file_locations/InitFileLocations.inc"
%else
InitFileLocations:
        push dword 22B0h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 228Ch
        mov edx, str_ModeR
        mov eax, str_NhlCfg
        call fopen_
        mov esi, eax
        test eax, eax
        jne short .1
        push str_CantOpenNhlCfg2
        call FatalError
        add esp, byte 4
.1:
        mov ebx, esi
        mov edx, 10h
        lea eax, [dword esp+02250h]
        call fgets_
        mov ebx, esi
        mov edx, 10h
        lea eax, [dword esp+02250h]
        call fgets_
        mov al, byte [dword esp+02250h]
        mov byte [cddrivestr], al
        xor ah, ah
        mov byte [dword esp+02251h], ah
        mov edx, str_ALLFILESTXT
        lea eax, [dword esp+02250h]
        call strcat_
        mov edx, str_ModeR
        lea eax, [dword esp+02250h]
        call fopen_
        mov edi, eax
        test eax, eax
        jne short .2
        mov edx, str_ModeR
        mov eax, str_ALLFILESTXT2
        call fopen_
        mov edi, eax
        test eax, eax
        jne short .2
        mov eax, esi
        call fclose_
        push str_CouldNotOpenALLFILES
        call FatalError
        add esp, byte 4
.2:
        xor ebx, ebx
        xor ecx, ecx
.3:
        cmp ebx, 225h
        jge short .4
        cmp ecx, byte 0FFFFFFFFh
        je short .4
        mov byte [dword ebx+fileoncd], 1
        mov edx, ebx
        shl edx, 4
        mov eax, esp
        add eax, edx
        push eax
        push str_S9
        push edi
        call fscanf_
        add esp, byte 0Ch
        mov ecx, eax
        inc ebx
        jmp short InitFileLocations.3
.4:
        mov eax, edi
        call fclose_
        xor ecx, ecx
.5:
        cmp ecx, byte 0FFFFFFFFh
        je short .8
        lea eax, [dword esp+02250h]
        push eax
        push str_S9
        push esi
        call fscanf_
        add esp, byte 0Ch
        mov ecx, eax
        xor ebx, ebx
.6:
        cmp ebx, 225h
        jge short InitFileLocations.5
        mov eax, ebx
        shl eax, 4
        mov edx, esp
        add edx, eax
        lea eax, [dword esp+02250h]
        call stricmp_
        test eax, eax
        jne short .7
        xor dh, dh
        mov byte [dword ebx+fileoncd], dh
        mov ebx, 226h
        jmp short InitFileLocations.6
.7:
        inc ebx
        jmp short InitFileLocations.6
.8:
        mov eax, esi
        call fclose_
        add esp, 228Ch
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CoachCutScene                                8BC15  95 PC, medium confidence
; From PostGameDesk: coachcut scrn / !pal, SayCoachClip, random clip%04d.cmv
; via PlayMVI, FreeCoachClip
;-----------------------------------------------------------------------------
; C: src/pc/file_locations/CoachCutScene.c
%ifdef CBUILD
%include "c/pc/file_locations/CoachCutScene.inc"
%else
CoachCutScene:
        push dword 358h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 330h
        call FadeOutPalCycle
        call InputInstall
        xor ecx, ecx
        mov ebx, str_Coachcut
        cmp byte [fileoncd+01E6h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalette
        call SetScreenTarget
        push str_Scrn4
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        push str_Pal29
        push esi
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [MusicOn], 0
        je short .5
        cmp dword [songdata], byte 0
        jne short .5
        mov ecx, str_Iff13
        mov ebx, str_Coach
        cmp byte [fileoncd+021Fh], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        lea eax, [dword esp+0300h]
        call MakePath
        lea eax, [dword esp+0300h]
        call LoadDigiFile
        mov dword [songdata], eax
.5:
        cmp byte [MusicOn], 0
        je short .6
        test byte [gameopts+1], 1
        je short .6
        mov edi, 1
        call SayCoachClip
        jmp short .7
.6:
        xor edi, edi
.7:
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalette
        mov eax, 0Ah
        call WaitClickTimeout
        mov esi, eax
        test eax, eax
        jne near .15
        call rand_
        mov edx, eax
        mov ebx, 32h
        sar edx, 1Fh
        idiv ebx
        lea eax, [byte edx+01h]
        push eax
        push str_Clip04d
        lea eax, [dword esp+0328h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov ecx, str_Cmv2
        lea ebx, [dword esp+0320h]
        cmp byte [dword edx+fileoncd+01E7h], 1
        jne short .8
        mov edx, dword [cddriveptr]
        jmp short .9
.8:
        xor edx, edx
.9:
        lea eax, [dword esp+0300h]
        call MakePath
        cmp byte [MusicOn], 0
        je short .11
        test byte [gameopts+1], 1
        je short .11
.10:
        call SpeechBusy
        test eax, eax
        jne short CoachCutScene.10
.11:
        mov ebx, 54h
        mov edx, 161h
        lea eax, [dword esp+0300h]
        call PlayMVI
        mov esi, eax
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalette
        cmp byte [MusicOn], 0
        je short .13
        test byte [gameopts+1], 1
        je short .13
        call MusicChanReset2
.12:
        call SpeechBusy
        test eax, eax
        jne short CoachCutScene.12
.13:
        cmp byte [MusicOn], 0
        je near .16
        cmp dword [songdata], byte 0
        je near .16
.14:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short CoachCutScene.14
        mov edx, dword [songdata]
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebx, ebx
        mov dword [songdata], ebx
        jmp short .16
.15:
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalette
        cmp byte [MusicOn], 0
        je short .16
        mov ebx, dword [songdata]
        test ebx, ebx
        je short .16
        push ebx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
.16:
        cmp edi, byte 1
        jne short .17
        call FreeCoachClip
.17:
        call InputRemove
        mov eax, esi
        add esp, 330h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
