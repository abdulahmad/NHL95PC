; Reading NHL.CFG at start-up: which sound device to use, then starting the driver.
bits 32
%include "hockey.inc"
section s_3DB41 progbits alloc exec nowrite align=1
extern __CHK, FatalError, fclose_, fopen_, fscanf_, greyramp, MakePath, MouseSetPos
extern SetDialogColors, SetSoundDevice, sounddevids, str_CannotOpenNhlCfg, str_CFG, str_fmt4x, str_NHL2, str_R3
extern sub_8EB93, sub_8FE83, sub_B3454, VgaSetPalette
global LoadNhlCfg, negone_3DC28
;-----------------------------------------------------------------------------
; LoadNhlCfg                                                      3DB41  95 PC
; Startup: opens NHL.CFG ("cannot open nhl.cfg" fatal), fscanf "%4x" sound
; device index -> sounddevids (default 10h), sets palette 0-3 to a grey ramp,
; installs sub_8EB93 handler, mouse to 0,0, dialog colors, then starts the
; sound driver (SetSoundDevice); the writer is in sound_config
;-----------------------------------------------------------------------------
; C: src/pc/config_cfg/LoadNhlCfg.c
%ifdef CBUILD
%include "c/pc/config_cfg/LoadNhlCfg.inc"
%else
LoadNhlCfg:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 14h
        mov ecx, str_CFG
        mov ebx, str_NHL2
        xor edx, edx
        mov eax, esp
        call MakePath
        mov edx, str_R3
        mov eax, esp
        call fopen_
        mov esi, eax
        test eax, eax
        jne short .1
        push str_CannotOpenNhlCfg
        call FatalError
        add esp, byte 4
.1:
        lea eax, [byte esp+010h]
        push eax
        push str_fmt4x
        push esi
        call fscanf_
        add esp, byte 0Ch
        cmp eax, byte 1
        jne short .2
        mov edi, dword [byte esp+010h]
        mov edi, dword [nosplit edi*4+sounddevids]
        jmp short .3
.2:
        mov edi, 10h
.3:
        mov eax, esi
        call fclose_
        xor esi, esi
.4:
        mov al, byte [dword esi+greyramp]
        mov byte [esp], al
        mov byte [byte esp+01h], al
        mov byte [byte esp+02h], al
        mov eax, esp
        push eax
        push byte 1
        push esi
        call VgaSetPalette
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 4
        jl short LoadNhlCfg.4
        push sub_8EB93
        call sub_B3454
        add esp, byte 4
        push byte 0
        push byte 0
        call MouseSetPos
        add esp, byte 8
        push byte 0
        mov ecx, 3
        mov ebx, 1
        mov edx, ecx
        mov eax, 2
        call SetDialogColors
        mov eax, 1
        call sub_8FE83
        mov eax, edi
        call SetSoundDevice
        add esp, byte 14h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
negone_3DC28:
        db 0FFh,0FFh,0FFh,0FFh
