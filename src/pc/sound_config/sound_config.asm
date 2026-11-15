; Choosing a sound card: the dialog, and writing that choice to NHL.CFG.
bits 32
%include "hockey.inc"
section s_82579 progbits alloc exec nowrite align=1
extern __CHK, __STOSD, acptspr, str_04x, sndcardmissing, crowddriver, homeremap, homeremap_e05
extern homeremap_e07, homeremap_e10, homeremap_e11, homeremap_e13, homeremap_e14, homeremap_e16, homeremap_e49, homeremap_e50
extern homeremap_e51, homeremap_e60, homeremap_eFB, homeremap_eFC, homeremap_eFD, homeremap_eFE, cddriveptr, chkoffspr
extern chkonspr, ClearInputQueue, cont2team, ctl1side, ctl1team, ctl2side, ctl2team, DrawSelBoxOff
extern DrawSelBoxOn, dword_C4CFC, cursndbank, lockerindex, lockerteams, poroundnameidx, lockeracceptx, lockeraccepty
extern lockercancelx, lockercancely, dword_D2350, dword_D2423, dword_D2427, digidriver, sndtempbuf, speechchannel
extern dword_ED7A4, dword_ED7A8, FadeOutPalCycle, FadePalStep, FatalError, fclose_, fdlg_cancel, fileoncd
extern fopen_, fprintf_, fputchar, FreeMemBlock, gamemode, gameopts, GetInputEvent, homebckspr
extern homenamebckspr, HomeTeam, InitSpeech, kaufmfont, lockerrects, mainfont, MakePath, MessageBox
extern modesetlabel, MouseSetPos, msg_InitMT32, musichandle, musicon, musicslot, na01spr, na03spr
extern na05spr, menutext_deskreturn, menutext_desktodesk, jerseyabbrevs, poroundnames, pg01spr, pg03spr, pg05spr
extern pg07spr, pl05spr, pl10spr, pl20spr, PlayDigiSample, pointerspr, PrintOutlinedText, PrintShadowText
extern ptrupdatefn, RestoreDialogBg, s1font, setbits, SetDialogColors, SetTextColors, SetTickDeadline, settingsfile
extern ShowLoadingScreen, ShutdownSpeech, ShutdownSpeech_ret5, sndcardname, songdata, soundcardrects, sounddev, sounddevids
extern speechbank, speechinit, speechq, sprintf_, str_00002, str_Accept, str_Acpt, str_ADLib
extern str_ADLIB, str_Adlib, str_Buffer, str_Canc, str_Cancel2, str_CantOpenNhlCfg, str_CFG, str_Dbx2
extern str_Emmcopybuf, str_Exhibition2, str_ExhibitionGame, str_HomeBck, str_HomeNameBck, str_HomeTeam, str_Iff11, str_Iff12
extern str_Jersey, str_JERSH, str_JERSV, str_LAAtMTL, str_League2, str_Lockroom, str_Maindesk2, str_MT32
extern str_MT322, str_MT323, str_MT32HOCK, str_Na01, str_Na03, str_Na05, str_NHL3, str_Off
extern str_On, str_P01, str_PC, str_PCBEEP, str_PCBEEP2, str_PCSpeaker, str_Pg01, str_Pg03
extern str_Pg05, str_Pg07, str_Pl05, str_Pl10, str_Pl20, str_Playoff, str_PlayoffTree2, str_Pointer20
extern str_Pointer21, str_Return, str_Room, str_SBDAC, str_SBDAC2, str_Settings, str_Settings3, str_ShowLeague
extern str_Slapshot, str_Sound4, str_SoundBlaster, str_SoundBlaster2, str_SportsCentral2, str_Temp8, str_TitleBck, str_UltraSound
extern str_ULTRASOUND, str_VisBck, str_VisitingTeam, str_VisNameBck, str_Vs, strcpy_, strncpy_, AllocMemBlock
extern sub_8D2F0, LoadBank, TextSetColors, TextSaveState, TextRestoreState, TextSetFont, sub_8EB5B, sub_8EB93
extern sub_8ECC0, LoadSample, FreeSample, sub_8F98F, sub_8FB8E, sub_8FBE5, sub_8FC37, SndQuery
extern sub_8FCDF, SetPalette, PutBlock, FillRect, DrawArtOpaque, sub_91284, sub_912C8, DrawArt
extern GrabBlock, PrintString, sub_91FE0, sub_97079, MouseRead, FindShape, VgaSetPalette, sub_B4BA8
extern SetColorRemap, sub_B4FAC, PlotPixel, teamcitynames, teamdivflags, titlebckspr, str_R4, sndselbox1
extern sndselbox2, msg_NoSoundCard, visbckspr, visnamebckspr, VisTeam, WaitDigiSample, WaitTickDeadline, WriteCurModeState
global MenuSoundSettings, DrawSoundCardDlg, DrawSoundCardOpts, SoundCardHitTest, RedrawSoundCardOpts, SoundCardDlgLoop, SoundCardDlgLoop_poll, SoundCardDlgLoop_next
global SoundCardDlg_epilogue, SoundCardDlgLoop_x, SetSoundDevice
;-----------------------------------------------------------------------------
; MenuSoundSettings                            82579  95 PC, medium confidence
; Menu action "Sound Settings ..."
;-----------------------------------------------------------------------------
; C: src/pc/sound_config/MenuSoundSettings.c
%ifdef CBUILD
%include "c/pc/sound_config/MenuSoundSettings.inc"
%else
MenuSoundSettings:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        cmp byte [musicon], 0
        je short .1
        cmp dword [songdata], byte 0
        jne short .2
.1:
        push byte 0
        push dword 4E200h
        push str_Temp8
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [sndtempbuf], eax
.2:
        push byte 0
        push dword 5F11h
        push str_Buffer
        call AllocMemBlock
        mov ebp, eax
        add esp, byte 0Ch
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 80h
        mov word [byte eax+06h], 0BEh
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        call DrawSoundCardDlg
        call DrawSoundCardOpts
        call SoundCardDlgLoop
        push byte 13h
        push byte 0Ah
        push ebp
        call PutBlock
        add esp, byte 0Ch
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawSoundCardDlg                             8261C  95 PC, medium confidence
; "sound" PPV dbx2 dialog
;-----------------------------------------------------------------------------
; C: src/pc/sound_config/DrawSoundCardDlg.c
%ifdef CBUILD
%include "c/pc/sound_config/DrawSoundCardDlg.inc"
%else
DrawSoundCardDlg:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        call sub_B4BA8
        xor ecx, ecx
        mov ebx, str_Sound4
        cmp byte [fileoncd+0191h], 1
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
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push byte 13h
        push byte 0Ah
        push str_Dbx2
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call sub_91284
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        add esp, byte 20h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawSoundCardOpts                            82690  95 PC, medium confidence
; PC Speaker / Sound Blaster / AD Lib / MT-32 / UltraSound boxes by sound
; device bits
;-----------------------------------------------------------------------------
; C: src/pc/sound_config/DrawSoundCardOpts.c
%ifdef CBUILD
%include "c/pc/sound_config/DrawSoundCardOpts.inc"
%else
DrawSoundCardOpts:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, dword [sounddev]
        mov dword [setbits], eax
        xor edx, edx
.1:
        mov cl, dl
        mov esi, 1
        shl esi, cl
        mov eax, edx
        shl eax, 4
        add eax, soundcardrects
        test dword [setbits], esi
        je short .2
        call DrawSelBoxOn
        jmp short .3
.2:
        call DrawSelBoxOff
.3:
        inc edx
        cmp edx, byte 8
        jl short DrawSoundCardOpts.1
        mov esi, soundcardrects
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        test byte [sndcardmissing], 1
        jne short .4
        mov eax, dword [soundcardrects+4]
        add eax, byte 13h
        push eax
        mov eax, dword [soundcardrects]
        add eax, byte 18h
        push eax
        push str_PCSpeaker
        call PrintString
        add esp, byte 0Ch
.4:
        add esi, byte 10h
        test byte [sndcardmissing], 2
        jne short .5
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Eh
        push eax
        push str_SoundBlaster
        call PrintString
        add esp, byte 0Ch
.5:
        add esi, byte 10h
        test byte [sndcardmissing], 4
        jne short .6
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 29h
        push eax
        push str_ADLib
        call PrintString
        add esp, byte 0Ch
.6:
        add esi, byte 10h
        test byte [sndcardmissing], 8
        jne short .7
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 28h
        push eax
        push str_MT32
        call PrintString
        add esp, byte 0Ch
.7:
        add esi, byte 20h
        test byte [sndcardmissing], 20h
        jne short .x
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 18h
        push eax
        push str_UltraSound
        call PrintString
        add esp, byte 0Ch
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SoundCardHitTest                             827B3  95 PC, medium confidence
; Hit-test 8 rects at soundcardrects
;-----------------------------------------------------------------------------
; C: src/pc/sound_config/SoundCardHitTest.c
%ifdef CBUILD
%include "c/pc/sound_config/SoundCardHitTest.inc"
%else
SoundCardHitTest:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov ecx, eax
        mov esi, edx
        xor edx, edx
        lea ecx, [byte eax-06h]
        sub esi, byte 13h
.1:
        mov eax, edx
        shl eax, 4
        cmp ecx, dword [dword eax+soundcardrects]
        jl short .2
        cmp ecx, dword [dword eax+soundcardrects+8]
        jg short .2
        cmp esi, dword [dword eax+soundcardrects+4]
        jl short .2
        cmp esi, dword [dword eax+soundcardrects+0Ch]
        jg short .2
        mov dword [ebx], edx
        mov eax, 1
        pop esi
        pop ecx
        ret
.2:
        inc edx
        cmp edx, byte 8
        jl short SoundCardHitTest.1
        xor eax, eax
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RedrawSoundCardOpts                          82805  95 PC, medium confidence
; Redraw of the card options from the sound config loop
;-----------------------------------------------------------------------------
; C: src/pc/sound_config/RedrawSoundCardOpts.c
%ifdef CBUILD
%include "c/pc/sound_config/RedrawSoundCardOpts.inc"
%else
RedrawSoundCardOpts:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        xor edx, edx
.1:
        mov cl, dl
        mov esi, 1
        shl esi, cl
        mov eax, edx
        shl eax, 4
        add eax, soundcardrects
        test dword [setbits], esi
        je short .2
        call DrawSelBoxOn
        jmp short .3
.2:
        call DrawSelBoxOff
.3:
        inc edx
        cmp edx, byte 8
        jl short RedrawSoundCardOpts.1
        mov esi, soundcardrects
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        test byte [sndcardmissing], 1
        jne short .4
        mov eax, dword [soundcardrects+4]
        add eax, byte 13h
        push eax
        mov eax, dword [soundcardrects]
        add eax, byte 18h
        push eax
        push str_PCSpeaker
        call PrintString
        add esp, byte 0Ch
.4:
        add esi, byte 10h
        test byte [sndcardmissing], 2
        jne short .5
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Eh
        push eax
        push str_SoundBlaster
        call PrintString
        add esp, byte 0Ch
.5:
        add esi, byte 10h
        test byte [sndcardmissing], 4
        jne short .6
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 29h
        push eax
        push str_ADLib
        call PrintString
        add esp, byte 0Ch
.6:
        add esi, byte 10h
        test byte [sndcardmissing], 8
        jne short .7
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 28h
        push eax
        push str_MT32
        call PrintString
        add esp, byte 0Ch
.7:
        add esi, byte 20h
        test byte [sndcardmissing], 20h
        jne short .x
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 18h
        push eax
        push str_UltraSound
        call PrintString
        add esp, byte 0Ch
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SoundCardDlgLoop                             8291E  95 PC, medium confidence
; Sound settings dialog loop: card boxes (SoundCardHitTest /
; DrawSelBoxOn/Off), calls SetSoundDevice; from MenuSoundSettings
;-----------------------------------------------------------------------------
; C: src/pc/sound_config/SoundCardDlgLoop.c
%ifdef CBUILD
%include "c/pc/sound_config/SoundCardDlgLoop.inc"
%else
SoundCardDlgLoop:
        push dword 60h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 38h
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        inc edx
        imul edx, eax
        add edx, byte 11h
        push byte 0
        push edx
        push str_Pointer21
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+04h]
        inc edx
        mov word [byte eax+04h], dx
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+06h]
        inc edx
        mov word [byte eax+06h], dx
        mov edx, dword [sndtempbuf]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [sndtempbuf], ecx
.1:
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+02Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [byte esp+034h]
        mov dword [byte esp+02Ch], eax
        mov eax, dword [byte esp+030h]
        mov dword [byte esp+028h], eax
        call sub_B4BA8
        mov esi, dword [byte esp+028h]
        push esi
        mov eax, dword [byte esp+030h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+028h]
        push edi
        mov eax, dword [byte esp+030h]
        sub eax, byte 4
        push eax
        mov eax, dword [pointerspr]
        push eax
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
.2:
        xor edx, edx
        mov dword [byte esp+024h], edx
.3:
        call GetInputEvent
        test eax, eax
        je short .4
        lea ebx, [byte esp+028h]
        lea edx, [byte esp+02Ch]
        call dword [ptrupdatefn]
        mov dword [byte esp+024h], eax
        test al, 6
        je short SoundCardDlgLoop.3
.4:
        mov ah, byte [byte esp+024h]
        test ah, 2
        jne near SoundCardDlgLoop_poll.2
        test ah, 4
        jne short SoundCardDlgLoop_poll.2
        mov eax, dword [byte esp+02Ch]
        cmp eax, dword [byte esp+034h]
        jne short .5
        mov eax, dword [byte esp+028h]
        cmp eax, dword [byte esp+030h]
        je short SoundCardDlgLoop.2
.5:
        mov ebx, dword [byte esp+030h]
        push ebx
        mov eax, dword [byte esp+038h]
        sub eax, byte 4
SoundCardDlgLoop_poll:
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [byte esp+028h]
        push ecx
        mov eax, dword [byte esp+030h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov esi, dword [byte esp+028h]
        push esi
        mov eax, dword [byte esp+030h]
        sub eax, byte 4
        push eax
        mov edi, dword [pointerspr]
        push edi
.1:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+02Ch]
        mov dword [byte esp+034h], eax
        mov eax, dword [byte esp+028h]
        mov dword [byte esp+030h], eax
        jmp near SoundCardDlgLoop.2
.2:
        mov eax, dword [byte esp+034h]
        sub eax, byte 4
        mov dh, byte [byte esp+024h]
        test dh, 2
        je near SoundCardDlgLoop_x
        mov ebx, dword [byte esp+030h]
        push ebx
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        lea ebx, [byte esp+020h]
        mov edx, dword [byte esp+028h]
        mov eax, dword [byte esp+02Ch]
        call SoundCardHitTest
        test eax, eax
        je near .20
        mov cl, byte [byte esp+020h]
        mov eax, 1
        shl eax, cl
        mov dword [byte esp+020h], eax
        test dword [setbits], eax
        jne near .20
        test dword [sndcardmissing], eax
        je near .20
        cmp eax, byte 10h
        jb short .5
        jbe short .7
        cmp eax, byte 40h
        jb short .3
        jbe short .8
        cmp eax, 80h
        je near .21
        jmp near .19
.3:
        cmp eax, byte 20h
.4:
        je short .7
        jmp near .19
.5:
        cmp eax, byte 4
        jb short .6
        jbe short .7
        cmp eax, byte 8
        jmp short SoundCardDlgLoop_poll.4
.6:
        cmp eax, byte 1
        jb near .19
        cmp eax, byte 2
        ja near .19
.7:
        mov eax, dword [byte esp+020h]
        mov dword [setbits], eax
        jmp near .19
.8:
        mov eax, sndselbox1
        call DrawSelBoxOn
        push dword 0F7h
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        cmp byte [musicon], 0
        je short .10
        cmp dword [songdata], byte 0
        je short .10
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.9:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short SoundCardDlgLoop_poll.9
        mov eax, dword [songdata]
        push eax
        call sub_8D2F0
        add esp, byte 4
        xor edx, edx
        mov dword [songdata], edx
.10:
        mov eax, dword [setbits]
        call SetSoundDevice
        test eax, eax
        je near .15
        mov eax, dword [setbits]
        mov dword [sounddev], eax
        push ebp
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .13
        cmp dword [songdata], byte 0
        jne short .13
        mov ecx, str_Iff12
        mov ebx, str_Maindesk2
        cmp byte [fileoncd+01DBh], 1
        jne short .11
        mov edx, dword [cddriveptr]
        jmp short .12
.11:
        xor edx, edx
.12:
        mov eax, esp
        call MakePath
        mov eax, esp
        call sub_8F98F
        mov dword [songdata], eax
        test eax, eax
        je short .13
        test byte [gameopts], 40h
        je short .13
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call sub_8FB8E
.13:
        cmp byte [musicon], 0
        je short .14
        or byte [gameopts+1], 1
        jmp near SoundCardDlgLoop_next.1
.14:
        and byte [gameopts+1], 0FEh
        jmp near SoundCardDlgLoop_next.1
.15:
        mov eax, dword [setbits]
        xor dword [sndcardmissing], eax
        mov eax, dword [sounddev]
        mov dword [setbits], eax
        cmp byte [musicon], 0
        je short .18
        cmp dword [songdata], byte 0
        jne short .18
        mov ecx, str_Iff12
        mov ebx, str_Maindesk2
        cmp byte [fileoncd+01DBh], 1
        jne short .16
        mov edx, dword [cddriveptr]
        jmp short .17
.16:
        xor edx, edx
.17:
        mov eax, esp
        call MakePath
        mov eax, esp
        call sub_8F98F
        mov dword [songdata], eax
        test eax, eax
        je short .18
        test byte [gameopts], 40h
        je short .18
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call sub_8FB8E
.18:
        mov eax, sndselbox1
        call DrawSelBoxOff
.19:
        call RedrawSoundCardOpts
.20:
        mov edi, dword [byte esp+028h]
        push edi
        mov eax, dword [byte esp+030h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [byte esp+028h]
        push eax
        mov eax, dword [byte esp+030h]
        sub eax, byte 4
        push eax
        mov edx, dword [pointerspr]
        push edx
        jmp near SoundCardDlgLoop_poll.1
.21:
        mov eax, sndselbox2
        call DrawSelBoxOn
SoundCardDlgLoop_next:
        push ebp
        call FreeMemBlock
        add esp, byte 4
.1:
        xor eax, eax
        add esp, byte 38h
;-----------------------------------------------------------------------------
; SoundCardDlg_epilogue                        82D53  95 PC, medium confidence
; Shared pop/ret epilogue (jumped to from SetSoundDevice)
;-----------------------------------------------------------------------------
SoundCardDlg_epilogue:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SoundCardDlgLoop_x                                              82D5A  95 PC
; SoundCardDlgLoop tail: redraws the pressed button (PutBlock) and goes back
; to polling.
;-----------------------------------------------------------------------------
SoundCardDlgLoop_x:
        test dh, 4
        je short .1
        mov edx, dword [byte esp+030h]
        push edx
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        jmp short SoundCardDlgLoop_next
.1:
        mov ebx, dword [byte esp+030h]
        push ebx
        jmp near SoundCardDlgLoop_poll
%endif ; C
;-----------------------------------------------------------------------------
; SetSoundDevice                               82D7A  95 PC, medium confidence
; Shuts down current driver, selects PCBEEP/SBDAC/ADLIB/MT32 drivers by
; device bit, MT-32 init message, test 'slapshot' sample, writes nhl.cfg
; (%04x); also from LoadNhlCfg
;-----------------------------------------------------------------------------
; C: src/pc/sound_config/SoundCardDlgLoop.c (SetSoundDevice)
%ifdef CBUILD
%include "c/pc/sound_config/SoundCardDlgLoop.SetSoundDevice.inc"
%else
SetSoundDevice:
        push dword 74h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 44h
        mov esi, eax
        xor ebp, ebp
        mov dword [byte esp+03Ch], 1
        cmp dword [dword_D2423], byte 0
        je short .4
        mov ecx, dword [sounddev]
        cmp ecx, byte 2
        je short .1
        cmp ecx, byte 20h
        jne short .2
.1:
        call ShutdownSpeech
        mov edx, dword [dword_ED7A8]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [dword_ED7A8], ebx
        jmp short .3
.2:
        cmp ecx, byte 4
        jne short .3
        mov eax, dword [dword_ED7A4]
        call FreeSample
.3:
        call sub_8EB93
.4:
        mov dword [cursndbank], 20h
        xor edi, edi
        mov dword [dword_D2423], edi
.5:
        cmp esi, byte 4
        jb short .6
        jbe near .9
        cmp esi, byte 8
        jb near .12
        jbe near .10
        cmp esi, byte 20h
        je near .11
        jmp near .12
.6:
        cmp esi, byte 1
        jb near .12
        jbe short .7
        cmp esi, byte 2
        je short .8
        jmp near .12
.7:
        mov edx, str_PCBEEP
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_PC
        lea eax, [byte esp+010h]
        call strcpy_
        mov dword [dword_D2427], 1
        mov dword [digidriver], 0FFFFFFFFh
        xor ch, ch
        mov byte [crowddriver], ch
        jmp near .13
.8:
        mov edx, str_SBDAC
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_PC
        lea eax, [byte esp+010h]
        call strcpy_
        mov dword [dword_D2427], esi
        mov dword [digidriver], 3
        mov bh, 1
        mov byte [musicslot], bh
        mov byte [crowddriver], bh
        jmp near .13
.9:
        mov edx, str_ADLIB
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_PC
        lea eax, [byte esp+010h]
        call strcpy_
        mov dword [dword_D2427], 2
        mov dword [digidriver], 0FFFFFFFFh
        xor bl, bl
        mov byte [crowddriver], bl
        jmp near .13
.10:
        mov edx, str_MT322
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_PC
        lea eax, [byte esp+010h]
        call strcpy_
        mov dword [dword_D2427], 4
        mov dword [digidriver], 0FFFFFFFFh
        xor dh, dh
        mov byte [crowddriver], dh
        jmp short .13
.11:
        mov edx, str_SBDAC2
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_PC
        lea eax, [byte esp+010h]
        call strcpy_
        mov dword [dword_D2427], 5
        mov dword [digidriver], 6
        mov ah, 1
        mov byte [musicslot], ah
        mov byte [crowddriver], ah
        jmp short .13
.12:
        mov edx, str_PCBEEP2
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_PC
        lea eax, [byte esp+010h]
        call strcpy_
        xor eax, eax
        mov dword [dword_D2427], eax
        mov dword [digidriver], 0FFFFFFFFh
        xor al, al
        mov byte [crowddriver], al
.13:
        call sub_8EB5B
        mov ebx, dword [dword_D2427]
        test ebx, ebx
        jl short .15
        mov eax, ebx
        call sub_97079
        mov ebp, eax
        cmp eax, byte 0FFFFFFFFh
        je short .15
        mov ecx, dword [digidriver]
        test ecx, ecx
        jl short .14
        mov eax, ecx
        call sub_97079
        mov dword [byte esp+03Ch], eax
        cmp eax, byte 0FFFFFFFFh
        je short .15
.14:
        mov dword [dword_D2423], 0FFFFFFFFh
.15:
        cmp dword [dword_D2423], byte 0
        je near .29
        lea edx, [byte esp+010h]
        lea eax, [byte esp+020h]
        call sub_8ECC0
        cmp esi, byte 4
        jne short .18
        xor ecx, ecx
        mov ebx, str_Slapshot
        cmp byte [fileoncd+018Fh], 1
        jne short .16
        mov edx, dword [cddriveptr]
        jmp short .17
.16:
        xor edx, edx
.17:
        mov eax, esp
        call MakePath
        mov eax, esp
        call LoadSample
        mov dword [dword_ED7A4], eax
.18:
        cmp esi, byte 8
        jne near .21
        mov ebx, dword [dword_D2350]
        test ebx, ebx
        jne near .21
        push ebx
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        push ebx
        push ebx
        mov ecx, 2
        mov ebx, msg_InitMT32
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        xor ecx, ecx
        mov ebx, str_MT32HOCK
        cmp byte [fileoncd+0F7h], 1
        jne short .19
        mov edx, dword [cddriveptr]
        jmp short .20
.19:
        xor edx, edx
.20:
        mov eax, esp
        call MakePath
        mov eax, esp
        call LoadSample
        mov edx, eax
        mov dword [dword_D2350], 0FFFFFFFFh
        mov dword [sounddev], 8
        call PlayDigiSample
        call WaitDigiSample
        mov eax, edx
        call FreeSample
        call RestoreDialogBg
.21:
        mov dword [sounddev], esi
        cmp byte [crowddriver], 0
        je short .22
        mov eax, dword [byte esp+03Ch]
        jmp short .23
.22:
        mov eax, ebp
.23:
        mov byte [crowddriver], al
        mov al, byte [byte esp+03Ch]
        mov byte [musicslot], al
        mov eax, dword [sounddev]
        mov dword [setbits], eax
        mov ecx, str_CFG
        mov ebx, str_NHL3
        xor edx, edx
        mov eax, esp
        call MakePath
        mov edx, str_R4
        mov eax, esp
        call fopen_
        mov edi, eax
        test eax, eax
        jne short .24
        push str_CantOpenNhlCfg
        call FatalError
        add esp, byte 4
.24:
        xor eax, eax
.25:
        cmp esi, dword [nosplit eax*4+sounddevids]
        je short .26
        inc eax
        jmp short SetSoundDevice.25
.26:
        push eax
        push str_04x
        push edi
        call fprintf_
        add esp, byte 0Ch
        mov eax, edi
        call fclose_
        mov ecx, dword [sounddev]
        cmp ecx, byte 2
        je short .27
        cmp ecx, byte 20h
        jne short .28
.27:
        mov byte [musicon], 1
        mov eax, dword [digidriver]
        mov dword [musichandle], eax
        jmp near .39
.28:
        xor bh, bh
        mov byte [musicon], bh
        jmp near .39
.29:
        cmp esi, byte 10h
        je near .37
        cmp esi, byte 1
        je near .37
        cmp esi, byte 4
        jb short .30
        jbe short .32
        cmp esi, byte 8
        jb short .34
        jbe short .33
        cmp esi, byte 20h
        je short .31
        jmp short .34
.30:
        cmp esi, byte 2
        jne short .34
        mov dword [sndcardname], str_SoundBlaster2
        jmp short .34
.31:
        mov dword [sndcardname], str_ULTRASOUND
        jmp short .34
.32:
        mov dword [sndcardname], str_Adlib
        jmp short .34
.33:
        mov dword [sndcardname], str_MT323
.34:
        xor edx, edx
        mov dword [byte esp+040h], edx
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+040h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_NoSoundCard
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.35:
        call GetInputEvent
        test eax, eax
        je short .36
        lea ebx, [byte esp+030h]
        lea edx, [byte esp+034h]
        call dword [ptrupdatefn]
        mov dword [byte esp+040h], eax
.36:
        test byte [byte esp+040h], 2
        je short SetSoundDevice.35
        call RestoreDialogBg
        mov esi, 10h
        jmp short .38
.37:
        mov dword [dword_D2423], 0FFFFFFFFh
.38:
        call sub_8EB93
        push byte 64h
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
.39:
        cmp dword [dword_D2423], byte 0
        je near SetSoundDevice.5
        mov edx, dword [sounddev]
        cmp edx, byte 2
        je short .40
        cmp edx, byte 20h
        jne short .41
.40:
        push byte 20h
        push dword 400h
        push str_Emmcopybuf
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword_ED7A8], eax
        mov edx, dword [dword_C4CFC]
        movzx esi, byte [musicslot]
        mov ecx, 400h
        mov ebx, eax
        mov eax, esi
        call InitSpeech
.41:
        xor ecx, ecx
        mov dword [cursndbank], ecx
        mov eax, 1
        add esp, byte 44h
        jmp near SoundCardDlg_epilogue
%endif ; C
